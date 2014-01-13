Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaAMGvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:51:18 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:27957
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbaAMGvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:51:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 5/6] ASoC: fsl: Add VF610 simple audio card widgets driver.
Date: Mon, 13 Jan 2014 13:53:57 +0800
Message-ID: <1389592438-13761-6-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
References: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the SGTL5000 codec based off-CODEC widgets supports.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/Kconfig                     | 25 ++++++++++++++++++
 sound/soc/fsl/Makefile                    |  3 +++
 sound/soc/fsl/snd-soc-simple-card-vf610.c | 43 +++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)
 create mode 100644 sound/soc/fsl/snd-soc-simple-card-vf610.c

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 324988d..1a09028 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -219,3 +219,28 @@ config SND_SOC_IMX_MC13783
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
+
+endif #SND_VF610_SOC
diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
index b12ad4b..668cead 100644
--- a/sound/soc/fsl/Makefile
+++ b/sound/soc/fsl/Makefile
@@ -60,3 +60,6 @@ obj-$(CONFIG_SND_SOC_IMX_SGTL5000) += snd-soc-imx-sgtl5000.o
 obj-$(CONFIG_SND_SOC_IMX_WM8962) += snd-soc-imx-wm8962.o
 obj-$(CONFIG_SND_SOC_IMX_SPDIF) += snd-soc-imx-spdif.o
 obj-$(CONFIG_SND_SOC_IMX_MC13783) += snd-soc-imx-mc13783.o
+
+# Simple audio card widgets Support
+obj-$(CONFIG_SND_SOC_VF610_SGTL5000) += snd-soc-simple-card-vf610.o
diff --git a/sound/soc/fsl/snd-soc-simple-card-vf610.c b/sound/soc/fsl/snd-soc-simple-card-vf610.c
new file mode 100644
index 0000000..ee28748
--- /dev/null
+++ b/sound/soc/fsl/snd-soc-simple-card-vf610.c
@@ -0,0 +1,43 @@
+/*
+ * ASoC VF610 SGTL5000 off-CODEC widgets support
+ *
+ * Copyright 2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+
+static const struct snd_soc_dapm_widget vf610_sgtl5000_dapm_widgets[] = {
+	SND_SOC_DAPM_MIC("Mic Jack", NULL),
+	SND_SOC_DAPM_LINE("Line In Jack", NULL),
+	SND_SOC_DAPM_HP("Headphone Jack", NULL),
+	SND_SOC_DAPM_SPK("Line Out Jack", NULL),
+	SND_SOC_DAPM_SPK("Ext Spk", NULL),
+};
+
+struct snd_soc_widgets vf610_sgtl5000_widgets = {
+	.name = "vf610-sgtl5000",
+	.widgets = vf610_sgtl5000_dapm_widgets,
+	.cnt = ARRAY_SIZE(vf610_sgtl5000_dapm_widgets),
+};
+
+static int __init __vf610_sgtl5000_widgets_init(void)
+{
+	return snd_soc_register_widgets(&vf610_sgtl5000_widgets);
+}
+module_init(__vf610_sgtl5000_widgets_init);
+
+static void __exit __vf610_sgtl5000_widgets_exit(void)
+{
+	snd_soc_unregister_widgets(&vf610_sgtl5000_widgets);
+}
+module_exit(__vf610_sgtl5000_widgets_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:vf610-simple-card-widgets");
+MODULE_DESCRIPTION("ASoC Simple Sound Card Widgets");
+MODULE_AUTHOR("Xiubo Li <Li.Xiubo@freescale.com>");
-- 
1.8.4


