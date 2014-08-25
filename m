Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaHYDfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:35:54 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:36237
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753805AbaHYDfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:35:52 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <nicoleotsuka@gmail.com>, <timur@tabi.org>,
        <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>
CC: <galak@codeaurora.org>, <mark.rutland@arm.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 2/4] ASoC: fsl-esai: Convert to use regmap framework's endianness method.
Date: Mon, 25 Aug 2014 11:31:00 +0800
Message-ID: <1408937462-18727-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
References: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(19580405001)(6806004)(83322001)(68736004)(77156001)(44976005)(69596002)(47776003)(90102001)(64706001)(19580395003)(87286001)(4396001)(50226001)(80022001)(81342001)(104166001)(104016003)(46102001)(105606002)(81156004)(26826002)(99396002)(102836001)(84676001)(85306004)(20776003)(106466001)(21056001)(31966008)(62966002)(74502001)(74662001)(76482001)(50466002)(79102001)(76176999)(88136002)(50986999)(87936001)(95666004)(92566001)(2201001)(48376002)(229853001)(107046002)(89996001)(77982001)(86362001)(93916002)(92726001)(97736001)(36756003)(83072002)(81542001)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0620;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 sound/soc/fsl/fsl_esai.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index b2f6b3e..8bcdfda 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -710,7 +710,7 @@ static bool fsl_esai_writeable_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config fsl_esai_regmap_config = {
+static const struct regmap_config fsl_esai_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -736,9 +736,6 @@ static int fsl_esai_probe(struct platform_device *pdev)
 	esai_priv->pdev = pdev;
 	strcpy(esai_priv->name, np->name);
 
-	if (of_property_read_bool(np, "big-endian"))
-		fsl_esai_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
-
 	/* Get the addresses and IRQ */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	regs = devm_ioremap_resource(&pdev->dev, res);
-- 
1.8.5

