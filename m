Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaHSJgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:36:54 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:16260
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751552AbaHSJgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:36:53 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <shc_work@mail.ru>, <fabio.estevam@freescale.com>,
        <shengjiu.wang@freescale.com>, <xobs@kosagi.com>, <arnd@arndb.de>,
        <sfr@canb.auug.org.au>, <timur@tabi.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH V2] ASoC: fsl-asoc-card: move 'config SND_SOC_FSL_ASOC_CARD' to 'if SND_IMX_SOC'
Date: Tue, 19 Aug 2014 17:36:41 +0800
Message-ID: <bfed4dfd3cf1ef134dac1f114f3d2b8cedf55c68.1408440952.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019006)(6009001)(189002)(199003)(68736004)(19580405001)(84676001)(230783001)(95666004)(44976005)(229853001)(83322001)(33646002)(104016003)(81542001)(64706001)(19580395003)(106466001)(81342001)(105606002)(6806004)(36756003)(77156001)(87286001)(26826002)(93916002)(85306004)(21056001)(92726001)(2201001)(20776003)(107046002)(47776003)(31966008)(92566001)(87936001)(76482001)(85852003)(46102001)(89996001)(79102001)(88136002)(50986999)(83072002)(99396002)(74502001)(62966002)(80022001)(86362001)(104166001)(77982001)(48376002)(97736001)(102836001)(50466002)(50226001)(4396001)(74662001)(1121002)(921003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB253;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build kernel with SND_SOC_FSL_ASOC_CARD=m && SND_SOC_FSL_{SSI,SAI,ESAI}=y
leads the following error:

   sound/built-in.o: In function `fsl_sai_probe':
>> fsl_sai.c:(.text+0x5f662): undefined reference to `imx_pcm_dma_init'
   sound/built-in.o: In function `fsl_esai_probe':
>> fsl_esai.c:(.text+0x6044b): undefined reference to `imx_pcm_dma_init'

The config SND_SOC_FSL_ASOC_CARD is for IMX SOC, So move it under condition
of 'if SND_IMX_SOC'.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/Kconfig |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 417ff70..9348fef 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -58,23 +58,6 @@ config SND_SOC_FSL_ESAI
 config SND_SOC_FSL_UTILS
 	tristate
 
-config SND_SOC_FSL_ASOC_CARD
-	tristate "Generic ASoC Sound Card with ASRC support"
-	depends on OF && I2C
-	select SND_SOC_IMX_AUDMUX
-	select SND_SOC_IMX_PCM_DMA
-	select SND_SOC_FSL_ESAI
-	select SND_SOC_FSL_SAI
-	select SND_SOC_FSL_SSI
-	select SND_SOC_CS42XX8_I2C
-	select SND_SOC_SGTL5000
-	select SND_SOC_WM8962
-	help
-	 ALSA SoC Audio support with ASRC feature for Freescale SoCs that have
-	 ESAI/SAI/SSI and connect with external CODECs such as WM8962, CS42888
-	 and SGTL5000.
-	 Say Y if you want to add support for Freescale Generic ASoC Sound Card.
-
 config SND_SOC_IMX_PCM_DMA
 	tristate
 	select SND_SOC_GENERIC_DMAENGINE_PCM
@@ -285,6 +268,23 @@ config SND_SOC_IMX_MC13783
 	select SND_SOC_MC13783
 	select SND_SOC_IMX_PCM_DMA
 
+config SND_SOC_FSL_ASOC_CARD
+	tristate "Generic ASoC Sound Card with ASRC support"
+	depends on OF && I2C
+	select SND_SOC_IMX_AUDMUX
+	select SND_SOC_IMX_PCM_DMA
+	select SND_SOC_FSL_ESAI
+	select SND_SOC_FSL_SAI
+	select SND_SOC_FSL_SSI
+	select SND_SOC_CS42XX8_I2C
+	select SND_SOC_SGTL5000
+	select SND_SOC_WM8962
+	help
+	 ALSA SoC Audio support with ASRC feature for Freescale SoCs that have
+	 ESAI/SAI/SSI and connect with external CODECs such as WM8962, CS42888
+	 and SGTL5000.
+	 Say Y if you want to add support for Freescale Generic ASoC Sound Card.
+
 endif # SND_IMX_SOC
 
 endmenu
-- 
1.7.9.5

