Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaBZFKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:10:32 -0500
Received: from [216.32.180.13] ([216.32.180.13]:12195 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbaBZFK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:10:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z37d4lzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <timur@tabi.org>, <tiwai@suse.de>, <lars@metafoo.de>,
        <Guangyu.Chen@freescale.com>, <fabio.estevam@freescale.com>,
        <shawn.guo@linaro.org>, <denis@eukrea.com>, <mpa@pengutronix.de>,
        <s.hauer@pengutronix.de>, <moinejf@free.fr>,
        <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 05/10] ASoC: imx-ssi: Add .of_xlate_tdm_slot_mask() support.
Date: Wed, 26 Feb 2014 11:59:30 +0800
Message-ID: <1393387175-15539-6-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393387175-15539-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393387175-15539-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add .of_xlate_tdm_slot_mask support for IMX SSI, and this
will generate the TDM slot TX and RX masks.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/Kconfig   | 1 +
 sound/soc/fsl/imx-ssi.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 7472308..67833dd 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -122,6 +122,7 @@ if SND_IMX_SOC
 
 config SND_SOC_IMX_SSI
 	tristate
+	select SND_SOC_FSL_UTILS
 
 config SND_SOC_IMX_PCM_FIQ
 	tristate
diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index df552fa..52d4b7a 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -50,6 +50,7 @@
 #include <linux/platform_data/asoc-imx-ssi.h>
 
 #include "imx-ssi.h"
+#include "fsl_utils.h"
 
 #define SSI_SACNT_DEFAULT (SSI_SACNT_AC97EN | SSI_SACNT_FV)
 
@@ -339,6 +340,7 @@ static const struct snd_soc_dai_ops imx_ssi_pcm_dai_ops = {
 	.set_fmt	= imx_ssi_set_dai_fmt,
 	.set_clkdiv	= imx_ssi_set_dai_clkdiv,
 	.set_sysclk	= imx_ssi_set_dai_sysclk,
+	.of_xlate_tdm_slot_mask = fsl_asoc_of_xlate_tdm_slot_mask,
 	.set_tdm_slot	= imx_ssi_set_dai_tdm_slot,
 	.trigger	= imx_ssi_trigger,
 };
-- 
1.8.4


