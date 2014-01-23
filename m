Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaAWGB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:01:56 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:11825
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbaAWGBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:01:53 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <shawn.guo@linaro.org>,
        <kuninori.morimoto.gx@renesas.com>
CC: <moinejf@free.fr>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 1/8] ASoC: fsl: Add VF610 soc audio card Kconfig
Date: Thu, 23 Jan 2014 13:02:43 +0800
Message-ID: <1390453370-29194-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/Kconfig | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 324988d..bc1fa9c 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -219,3 +219,27 @@ config SND_SOC_IMX_MC13783
 	select SND_SOC_IMX_PCM_DMA
 
 endif # SND_IMX_SOC
+
+menuconfig SND_VF610_SOC
+       tristate "SoC Audio for Freescale VF610 CPUs"
+       select DMA_ENGINE
+       help
+         Say Y or M if you want to add support for codecs attached to
+         the VF610 CPUs.
+
+         This will enable Freeacale SAI and SGTL5000 codec, and an extra
+         TWR-AUDIO-SGTL sub-board is needed for SGTL5000.
+
+if SND_VF610_SOC
+
+config SND_SOC_VF610_SGTL5000
+       tristate "SoC Audio support for VF610 boards with SGTL5000"
+       depends on OF && I2C
+       select SND_SOC_FSL_SAI
+       select SND_SOC_SGTL5000
+       select SND_SIMPLE_CARD
+       help
+         Say Y if you want to add support for SoC audio on an VF610 board with
+         a SGTL5000 codec and a SAI.
+
+endif #SND_VF610_SOC
-- 
1.8.4


