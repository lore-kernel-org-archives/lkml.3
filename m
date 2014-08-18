Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaHRIjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:39:18 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:38654
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751118AbaHRIjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:39:17 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <shc_work@mail.ru>, <fabio.estevam@freescale.com>,
        <shengjiu.wang@freescale.com>, <xobs@kosagi.com>, <arnd@arndb.de>,
        <sfr@canb.auug.org.au>, <timur@tabi.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH V1 1/3] ASoC: fsl: Kconfig: remove dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
Date: Mon, 18 Aug 2014 16:38:38 +0800
Message-ID: <f30ba4e2c4eb6702fa40bd255036e6e9ad6eb47d.1408350626.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1408350626.git.shengjiu.wang@freescale.com>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(199003)(189002)(47776003)(20776003)(81542001)(84676001)(95666004)(105606002)(87286001)(74662001)(50466002)(4396001)(92726001)(229853001)(104166001)(48376002)(64706001)(76482001)(87936001)(46102001)(81342001)(31966008)(21056001)(76176999)(2201001)(74502001)(93916002)(86362001)(77982001)(88136002)(50986999)(50226001)(92566001)(89996001)(79102001)(19580405001)(62966002)(83072002)(85852003)(36756003)(33646002)(83322001)(44976005)(102836001)(19580395003)(77156001)(6806004)(107046002)(26826002)(80022001)(106466001)(97736001)(68736004)(104016003)(85306004)(99396002)(921003)(1121002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0617;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build kernel with SND_SOC_IMC_PCM_DMA=m && SND_IMX_SOC=n leads the following
error:

   sound/built-in.o: In function `fsl_sai_probe':
>> fsl_sai.c:(.text+0x5f662): undefined reference to `imx_pcm_dma_init'
   sound/built-in.o: In function `fsl_esai_probe':
>> fsl_esai.c:(.text+0x6044b): undefined reference to `imx_pcm_dma_init'

Most cpu driver in soc/fsl has use the function 'imx_pcm_dma_init' which is
defined in imx-pcm-dma.c, so need to select SND_SOC_IMX_PCM_DMA, but it depends
on SND_IMX_SOC, if SND_IMX_SOC=n, then SND_SOC_IMX_PCM_DMA will not be
selected.
So remove the dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 5ae777a..3a3732c 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -15,7 +15,7 @@ config SND_SOC_FSL_ASRC
 config SND_SOC_FSL_SAI
 	tristate "Synchronous Audio Interface (SAI) module support"
 	select REGMAP_MMIO
-	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
+	select SND_SOC_IMX_PCM_DMA
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Say Y if you want to add Synchronous Audio Interface (SAI)
@@ -25,7 +25,7 @@ config SND_SOC_FSL_SAI
 
 config SND_SOC_FSL_SSI
 	tristate "Synchronous Serial Interface module support"
-	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
+	select SND_SOC_IMX_PCM_DMA
 	select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && (MXC_TZIC || MXC_AVIC)
 	select REGMAP_MMIO
 	help
@@ -37,7 +37,7 @@ config SND_SOC_FSL_SSI
 config SND_SOC_FSL_SPDIF
 	tristate "Sony/Philips Digital Interface module support"
 	select REGMAP_MMIO
-	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
+	select SND_SOC_IMX_PCM_DMA
 	select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && (MXC_TZIC || MXC_AVIC)
 	help
 	  Say Y if you want to add Sony/Philips Digital Interface (SPDIF)
@@ -48,7 +48,7 @@ config SND_SOC_FSL_SPDIF
 config SND_SOC_FSL_ESAI
 	tristate "Enhanced Serial Audio Interface (ESAI) module support"
 	select REGMAP_MMIO
-	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
+	select SND_SOC_IMX_PCM_DMA
 	help
 	  Say Y if you want to add Enhanced Synchronous Audio Interface
 	  (ESAI) support for the Freescale CPUs.
-- 
1.7.9.5

