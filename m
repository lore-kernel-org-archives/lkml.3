Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBKDws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:52:48 -0500
Received: from [213.199.154.204] ([213.199.154.204]:17220 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbaBKDwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:52:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <Guangyu.Chen@freescale.com>,
        <shawn.guo@linaro.org>
CC: <perex@perex.cz>, <tiwai@suse.de>, <fabio.estevam@freescale.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 1/2] ASoC: fsl: make sure the regmap-mmio is actually enabled
Date: Tue, 11 Feb 2014 10:47:04 +0800
Message-ID: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the Freescale SAI, ESAI and SPDIF are using the regmap-mmio,
there needs a select of REGMAP_MMIO in the Kconfig to ensure that
regmap-mmio is actually enabled.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Mark Brown <broonie@linaro.org>
---
 sound/soc/fsl/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 07f8f14..d0914c0 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -1,5 +1,6 @@
 config SND_SOC_FSL_SAI
 	tristate
+	select REGMAP_MMIO
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 
 config SND_SOC_FSL_SSI
@@ -7,9 +8,11 @@ config SND_SOC_FSL_SSI
 
 config SND_SOC_FSL_SPDIF
 	tristate
+	select REGMAP_MMIO
 
 config SND_SOC_FSL_ESAI
 	tristate
+	select REGMAP_MMIO
 
 config SND_SOC_FSL_UTILS
 	tristate
@@ -204,7 +207,6 @@ config SND_SOC_IMX_SPDIF
 	tristate "SoC Audio support for i.MX boards with S/PDIF"
 	select SND_SOC_IMX_PCM_DMA
 	select SND_SOC_FSL_SPDIF
-	select REGMAP_MMIO
 	help
 	  SoC Audio support for i.MX boards with S/PDIF
 	  Say Y if you want to add support for SoC audio on an i.MX board with
-- 
1.8.4


