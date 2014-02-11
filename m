Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaBKDwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:52:14 -0500
Received: from [213.199.154.204] ([213.199.154.204]:10881 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbaBKDwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:52:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <Guangyu.Chen@freescale.com>,
        <shawn.guo@linaro.org>
CC: <perex@perex.cz>, <tiwai@suse.de>, <fabio.estevam@freescale.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 2/2] ASoC: fsl: Make Freescale SAI/ESAI/SPDIF to be visible in Kconfig
Date: Tue, 11 Feb 2014 10:47:05 +0800
Message-ID: <1392086825-15737-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392086825-15737-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For simple card since the whole idea is to support any CODEC and
any CPU DAI with the same driver, we should probably just make sure
that all the individual CODEC and CPU DAI drivers can be enabled in
Kconfig. That way we don't have to have specific Kconfig entries for
boards and loose some of the benefit of the generic card.

This will make the Freescale SAI/ESAI/SPDIF device be visible in
Kconfig.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Mark Brown <broonie@linaro.org>
---
 sound/soc/fsl/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index d0914c0..f397144 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -1,5 +1,5 @@
 config SND_SOC_FSL_SAI
-	tristate
+	tristate "ALSA SoC support for the Freescale SAI device"
 	select REGMAP_MMIO
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 
@@ -7,11 +7,11 @@ config SND_SOC_FSL_SSI
 	tristate
 
 config SND_SOC_FSL_SPDIF
-	tristate
+	tristate "ALSA SoC support for the Freescale SPDIF device"
 	select REGMAP_MMIO
 
 config SND_SOC_FSL_ESAI
-	tristate
+	tristate "ALSA SoC support for the Freescale ESAI device"
 	select REGMAP_MMIO
 
 config SND_SOC_FSL_UTILS
-- 
1.8.4


