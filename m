Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaD2ESy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:18:54 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:58965
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754372AbaD2ESX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:18:23 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/4] pwm: ftm-pwm: Clean up the code.
Date: Tue, 29 Apr 2014 11:33:47 +0800
Message-ID: <1398742429-10399-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398742429-10399-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398742429-10399-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(50466002)(74502001)(36756003)(92566001)(46102001)(83322001)(77156001)(6806004)(85852003)(83072002)(44976005)(47776003)(19580405001)(101416001)(48376002)(19580395003)(81342001)(20776003)(92726001)(80022001)(87936001)(50986999)(50226001)(80976001)(77982001)(4396001)(81542001)(89996001)(77096999)(31966008)(86362001)(88136002)(76482001)(99396002)(93916002)(62966002)(87286001)(79102001)(76176999);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB499;H:tx30smr01.am.freescale.net;FPR:6F7570EF.1EBD62E.3FF698BC.99960AA0.201C6;MLV:sfv;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch intends to prepare for converting to direct regmap
API usage.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/pwm/pwm-fsl-ftm.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
index 420169e..4a4ad58 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -21,11 +21,10 @@
 #include <linux/slab.h>
 
 #define FTM_SC		0x00
-#define FTM_SC_CLK_MASK	0x3
-#define FTM_SC_CLK_SHIFT	3
-#define FTM_SC_CLK(c)	(((c) + 1) << FTM_SC_CLK_SHIFT)
+#define FTM_SC_CLK_MASK_SHIFT	3
+#define FTM_SC_CLK_MASK	(3 << FTM_SC_CLK_MASK_SHIFT)
+#define FTM_SC_CLK(c)	(((c) + 1) << FTM_SC_CLK_MASK_SHIFT)
 #define FTM_SC_PS_MASK	0x7
-#define FTM_SC_PS_SHIFT	0
 
 #define FTM_CNT		0x04
 #define FTM_MOD		0x08
@@ -258,7 +257,7 @@ static int fsl_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		}
 
 		val = readl(fpc->base + FTM_SC);
-		val &= ~(FTM_SC_PS_MASK << FTM_SC_PS_SHIFT);
+		val &= ~FTM_SC_PS_MASK;
 		val |= fpc->clk_ps;
 		writel(val, fpc->base + FTM_SC);
 		writel(period - 1, fpc->base + FTM_MOD);
@@ -305,7 +304,7 @@ static int fsl_counter_clock_enable(struct fsl_pwm_chip *fpc)
 
 	/* select counter clock source */
 	val = readl(fpc->base + FTM_SC);
-	val &= ~(FTM_SC_CLK_MASK << FTM_SC_CLK_SHIFT);
+	val &= ~FTM_SC_CLK_MASK;
 	val |= FTM_SC_CLK(fpc->cnt_select);
 	writel(val, fpc->base + FTM_SC);
 
@@ -357,7 +356,7 @@ static void fsl_counter_clock_disable(struct fsl_pwm_chip *fpc)
 
 	/* no users left, disable PWM counter clock */
 	val = readl(fpc->base + FTM_SC);
-	val &= ~(FTM_SC_CLK_MASK << FTM_SC_CLK_SHIFT);
+	val &= ~FTM_SC_CLK_MASK;
 	writel(val, fpc->base + FTM_SC);
 
 	clk_disable_unprepare(fpc->clk[FSL_PWM_CLK_CNTEN]);
-- 
1.8.4

