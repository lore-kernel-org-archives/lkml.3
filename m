Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaLAJNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:13:21 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57077 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaLAJNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:13:19 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-25-547c312d9337
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] clk: samsung: exynos4415: Fix build with PM_SLEEP disabled
Date: Mon, 01 Dec 2014 10:12:54 +0100
Message-id: <1417425174-26694-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xy7q6hjUhBmv2MFlsnLGe1eL6l+es
	Fq9fGFr0P37NbHG26Q27xabH11gtLu+aw2Yx4/w+Jou1R+6yWzydcJHN4vCbdlaLVbv+MDrw
	eOycdZfdY9OqTjaPO9f2sHlsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBk72x6yFJzl
	q1g5u5m9gfEqTxcjJ4eEgInEkvmH2CBsMYkL99YD2VwcQgJLGSUePFnDDJLgFRCU+DH5HksX
	IwcHs4C8xJFL2SBhZgF1iUnzFjFD1PcxSaw5/IsFJMEmYCyxefkSsKEiAh1MEt3HVECKmAXe
	MkqsP7+eESQhLOAtsXHXEbAiFgFViTNdx5kglrlLHJnazgRxkZzEyWOTWScw8s1CcscshDtm
	IbljASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQYP+6g3HpMatDjAIcjEo8vJprq0OE
	WBPLiitzDzFKcDArifD+egEU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBiksv8m39uLGoVMTKck
	U9aw9+xT3Bg8rWuT8ps3bnGq1yoflgkv3XZrzd2ttRUaDAIJlrLmTicPLWfg3bmqw/nbAtHE
	NKXCv1ULrjcprJDerfip88KB2PMci98c3eL65oWTYsUa5UdvC1e8blP84dyWyC4WmtmY4Cqg
	de11Yrxqi7zqio8buZVYijMSDbWYi4oTAZQtc2pUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following build errors when PM_SLEEP is disabled (e.g. by disabling
SUSPEND and HIBERNATION):

drivers/clk/samsung/clk-exynos4415.c: In function ‘exynos4415_cmu_init’:
drivers/clk/samsung/clk-exynos4415.c:982:2: error: ‘exynos4415_ctx’ undeclared (first use in this function)
drivers/clk/samsung/clk-exynos4415.c:982:2: note: each undeclared identifier is reported only once for each function it appears in
drivers/clk/samsung/clk-exynos4415.c: In function ‘exynos4415_cmu_dmc_init’:
drivers/clk/samsung/clk-exynos4415.c:1123:2: error: ‘exynos4415_dmc_ctx’ undeclared (first use in this function)
make[3]: *** [drivers/clk/samsung/clk-exynos4415.o] Error 1

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos4415.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4415.c b/drivers/clk/samsung/clk-exynos4415.c
index c7208c7a3add..2123fc251e0f 100644
--- a/drivers/clk/samsung/clk-exynos4415.c
+++ b/drivers/clk/samsung/clk-exynos4415.c
@@ -118,12 +118,13 @@ enum exynos4415_plls {
 	nr_plls,
 };
 
+static struct samsung_clk_provider *exynos4415_ctx;
+
 /*
  * Support for CMU save/restore across system suspends
  */
 #ifdef CONFIG_PM_SLEEP
 static struct samsung_clk_reg_dump *exynos4415_clk_regs;
-static struct samsung_clk_provider *exynos4415_ctx;
 
 static unsigned long exynos4415_cmu_clk_regs[] __initdata = {
 	SRC_LEFTBUS,
@@ -1031,9 +1032,10 @@ enum exynos4415_dmc_plls {
 	nr_dmc_plls,
 };
 
+static struct samsung_clk_provider *exynos4415_dmc_ctx;
+
 #ifdef CONFIG_PM_SLEEP
 static struct samsung_clk_reg_dump *exynos4415_dmc_clk_regs;
-static struct samsung_clk_provider *exynos4415_dmc_ctx;
 
 static unsigned long exynos4415_cmu_dmc_clk_regs[] __initdata = {
 	MPLL_LOCK,
-- 
1.9.1

