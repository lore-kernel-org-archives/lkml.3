Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaHYDgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:36:06 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:58588
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754212AbaHYDfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:35:54 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <nicoleotsuka@gmail.com>, <timur@tabi.org>,
        <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>
CC: <galak@codeaurora.org>, <mark.rutland@arm.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 1/4] ASoC: fsl-asrc: Convert to use regmap framework's endianness method.
Date: Mon, 25 Aug 2014 11:30:59 +0800
Message-ID: <1408937462-18727-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
References: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(81342001)(77156001)(26826002)(2201001)(20776003)(64706001)(4396001)(87936001)(76482001)(104016003)(77982001)(62966002)(85306004)(97736001)(92726001)(47776003)(21056001)(89996001)(83072002)(92566001)(102836001)(50226001)(80022001)(104166001)(90102001)(85852003)(88136002)(79102001)(46102001)(93916002)(86362001)(84676001)(95666004)(99396002)(229853001)(107046002)(6806004)(87286001)(36756003)(50466002)(19580395003)(19580405001)(44976005)(68736004)(81542001)(105606002)(69596002)(81156004)(48376002)(31966008)(76176999)(106466001)(74502001)(83322001)(74662001)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0618;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_asrc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 8221104..3b14531 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -684,7 +684,7 @@ static bool fsl_asrc_writeable_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config fsl_asrc_regmap_config = {
+static const struct regmap_config fsl_asrc_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -802,10 +802,6 @@ static int fsl_asrc_probe(struct platform_device *pdev)
 
 	asrc_priv->paddr = res->start;
 
-	/* Register regmap and let it prepare core clock */
-	if (of_property_read_bool(np, "big-endian"))
-		fsl_asrc_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
-
 	asrc_priv->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "mem", regs,
 						      &fsl_asrc_regmap_config);
 	if (IS_ERR(asrc_priv->regmap)) {
-- 
1.8.5

