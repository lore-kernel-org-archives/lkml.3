Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaHYDfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:35:45 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:16204
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753805AbaHYDfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:35:43 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <nicoleotsuka@gmail.com>, <timur@tabi.org>,
        <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>
CC: <galak@codeaurora.org>, <mark.rutland@arm.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 3/4] ASoC: fsl-spdif: Convert to use regmap framework's endianness method.
Date: Mon, 25 Aug 2014 11:31:01 +0800
Message-ID: <1408937462-18727-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
References: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(199003)(189002)(97736001)(99396002)(80022001)(31966008)(86362001)(77982001)(47776003)(92566001)(88136002)(81542001)(92726001)(84676001)(79102001)(74502001)(95666004)(104016003)(62966002)(89996001)(46102001)(74662001)(85306004)(48376002)(19580395003)(50226001)(81156004)(64706001)(50466002)(69596002)(20776003)(4396001)(87936001)(105606002)(102836001)(83322001)(83072002)(76482001)(26826002)(76176999)(107046002)(6806004)(44976005)(36756003)(50986999)(85852003)(21056001)(93916002)(77156001)(68736004)(19580405001)(87286001)(81342001)(229853001)(104166001)(106466001)(90102001)(2201001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0612;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 sound/soc/fsl/fsl_spdif.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 70acfe4..ae4e408 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -1040,7 +1040,7 @@ static bool fsl_spdif_writeable_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config fsl_spdif_regmap_config = {
+static const struct regmap_config fsl_spdif_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -1184,9 +1184,6 @@ static int fsl_spdif_probe(struct platform_device *pdev)
 	memcpy(&spdif_priv->cpu_dai_drv, &fsl_spdif_dai, sizeof(fsl_spdif_dai));
 	spdif_priv->cpu_dai_drv.name = spdif_priv->name;
 
-	if (of_property_read_bool(np, "big-endian"))
-		fsl_spdif_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
-
 	/* Get the addresses and IRQ */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	regs = devm_ioremap_resource(&pdev->dev, res);
-- 
1.8.5

