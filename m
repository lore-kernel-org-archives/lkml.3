Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaJOFWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:22:36 -0400
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:24112
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751073AbaJOFW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:22:29 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 2/3] pwm: ftm: add regmap rbtree type cache support.
Date: Wed, 15 Oct 2014 13:21:34 +0800
Message-ID: <1413350495-40980-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
References: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(69596002)(6806004)(76176999)(95666004)(21056001)(68736004)(62966002)(44976005)(19580405001)(50986999)(4396001)(104166001)(81156004)(106466001)(107046002)(102836001)(26826002)(80022003)(105606002)(46102003)(50226001)(97736003)(19580395003)(20776003)(88136002)(92726001)(87936001)(87286001)(99396003)(50466002)(31966008)(89996001)(77156001)(92566001)(84676001)(64706001)(36756003)(47776003)(93916002)(85306004)(76482002)(48376002)(104016003)(86362001)(120916001)(85852003)(229853001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;
X-Forefront-PRVS: 0365C0E14B
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to prepare for adding PM support for FTM pwm driver
using callback function suspend and resume in .driver.pm of
platform_driver.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/pwm/pwm-fsl-ftm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
index 1150598..9bfbea5 100644
--- a/drivers/pwm/pwm-fsl-ftm.c
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -397,12 +397,23 @@ static int fsl_pwm_init(struct fsl_pwm_chip *fpc)
 	return 0;
 }
 
+static bool fsl_pwm_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case FTM_CNT:
+		return true;
+	}
+	return false;
+}
+
 static const struct regmap_config fsl_pwm_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
 
 	.max_register = FTM_PWMLOAD,
+	.volatile_reg = fsl_pwm_volatile_reg,
+	.cache_type = REGCACHE_RBTREE,
 };
 
 static int fsl_pwm_probe(struct platform_device *pdev)
-- 
2.1.0.27.g96db324

