Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbbA0MUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:20:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbbA0MUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jisheng Zhang <jszhang@marvell.com>,
        Michael Turquette <mturquette@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 113/126] clk: berlin: bg2q: remove non-exist "smemc" gate clock
Date: Tue, 27 Jan 2015 12:16:58 +0000
Message-Id: <1422361031-19364-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@marvell.com>

commit b71e8ecd57c8aae5b1815782c47b74ffe3efc09a upstream.

The "smemc" clock is removed on BG2Q SoCs. In fact, bit19 of clkenable
register is for nfc. Current code use bit19 for non-exist "smemc"
incorrectly, this prevents eMMC from working due to the sdhci's
"core" clk is still gated.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clk/berlin/bg2q.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
index 21784e4eb3f0..440ef81ab15c 100644
--- a/drivers/clk/berlin/bg2q.c
+++ b/drivers/clk/berlin/bg2q.c
@@ -285,7 +285,6 @@ static const struct berlin2_gate_data bg2q_gates[] __initconst = {
 	{ "pbridge",	"perif",	15, CLK_IGNORE_UNUSED },
 	{ "sdio",	"perif",	16, CLK_IGNORE_UNUSED },
 	{ "nfc",	"perif",	18 },
-	{ "smemc",	"perif",	19 },
 	{ "pcie",	"perif",	22 },
 };
 
-- 
2.1.4

