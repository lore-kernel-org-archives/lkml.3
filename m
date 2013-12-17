Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3LQJ5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:57:00 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13561 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3LQJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:56:57 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fc96d000006cd4-63-52b01fe74bb8
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stephen Warren <swarren@nvidia.com>, Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Padmavathi Venna <padma.v@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: exynos: File scope reg_save array should depend on
 PM_SLEEP
Date: Tue, 17 Dec 2013 10:56:39 +0100
Message-id: <1387274199-470-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xa7rP5TcEGXTckLN4N+8Fs8XrF4YW
	vQuusllsenyN1eLyrjlsFjPO72OyeDrhIpvF75vf2SxO/ulltPhxppvF4sb0FlaL9TNeszjw
	eFzu62Xy6Nl5htHjzrU9bB6bl9R79Da/Y/Po27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujN6H
	sQV/uCqmb1jP1sA4j7OLkZNDQsBE4sHChUwQtpjEhXvr2boYuTiEBJYySqx62QKW4BUQlPgx
	+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxg9hCAn1MEh1bUkFsNgFjic3Ll4DNERG4xCzxZed9
	VpCEsECwxIYekAWcHCwCqhLne/6xQMx3lTi8cAsjyHwJAQWJOZNsJjDyzkKyeRbC5llINi9g
	ZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERLYX3YwLj5mdYhRgINRiYd3x/z1QUKsiWXF
	lbmHGCU4mJVEeFkKgEK8KYmVValF+fFFpTmpxYcYmTg4pRoYY3RMm6z7n2vn/9lRdUGJr3WP
	yzXjT6d01lnOZrTau65jj/irSVW5vL/bG+7J3Jc8p3qhd5/Q9f5fPW94/KJdMha/rZzvw73p
	/xm3Bdfq7R+WdBxQTJmxaXL0iwtZPhtX7Z6xa+v709XsG5+YKhZv4t9SMtngMMfMa4Wrl20T
	nrnw4sZ1O0SWNSmxFGckGmoxFxUnAgDxl/69SgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move reg_save[] into CONFIG_PM_SLEEP dependency block as it is used only
by suspend and resume functions.

This fixes the warning on CONFIG_PM_SLEEP=n:
drivers/clk/samsung/clk-exynos-audss.c:29:22: warning: ‘reg_save’ defined but not used [-Wunused-variable]

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos-audss.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 39b40aaede2b..68e515d093d8 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -26,17 +26,17 @@ static struct clk_onecell_data clk_data;
 #define ASS_CLK_DIV 0x4
 #define ASS_CLK_GATE 0x8
 
+/* list of all parent clock list */
+static const char *mout_audss_p[] = { "fin_pll", "fout_epll" };
+static const char *mout_i2s_p[] = { "mout_audss", "cdclk0", "sclk_audio0" };
+
+#ifdef CONFIG_PM_SLEEP
 static unsigned long reg_save[][2] = {
 	{ASS_CLK_SRC,  0},
 	{ASS_CLK_DIV,  0},
 	{ASS_CLK_GATE, 0},
 };
 
-/* list of all parent clock list */
-static const char *mout_audss_p[] = { "fin_pll", "fout_epll" };
-static const char *mout_i2s_p[] = { "mout_audss", "cdclk0", "sclk_audio0" };
-
-#ifdef CONFIG_PM_SLEEP
 static int exynos_audss_clk_suspend(void)
 {
 	int i;
-- 
1.7.9.5

