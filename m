Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3LQESh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 23:18:37 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:58036
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815Ab3LQERQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 23:17:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <timur@tabi.org>,
        <perex@perex.cz>
CC: <r64188@freescale.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <shawn.guo@linaro.org>, <b42378@freescale.com>,
        <b18965@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>
Subject: [PATCHv3 5/7] ASoC: fsl: Add SGTL5000 based audio machine driver.
Date: Tue, 17 Dec 2013 11:24:42 +0800
Message-ID: <1387250684-23406-6-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1387250684-23406-1-git-send-email-Li.Xiubo@freescale.com>
References: <1387250684-23406-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the SGTL5000 codec based audio driver supported with both
playback and capture dai link implemention.

This implementation is only compatible with device tree definition.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Alison Wang <b18965@freescale.com
---
 sound/soc/fsl/Kconfig          |  22 +++++
 sound/soc/fsl/Makefile         |   4 +
 sound/soc/fsl/vf610-sgtl5000.c | 178 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+)
 create mode 100644 sound/soc/fsl/vf610-sgtl5000.c

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index ac4fe4e..bb94c3c 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -217,3 +217,25 @@ config SND_SOC_IMX_MC13783
 	select SND_SOC_IMX_PCM_DMA
 
 endif # SND_IMX_SOC
+
+menuconfig SND_FSL_SOC
+	tristate "SoC Audio for Freescale VF610 CPUs"
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  the VF610 CPUs.
+
+	  This will enable Freeacale SAI and SGTL5000 codec, and an extra
+	  TWR-AUDIO-SGTL sub-board is needed for SGTL5000.
+
+if SND_FSL_SOC
+
+config SND_SOC_VF610_SGTL5000
+	tristate "SoC Audio support for VF610 boards with SGTL5000"
+	depends on OF && I2C
+	select SND_SOC_FSL_SAI
+	select SND_SOC_SGTL5000
+	help
+	  Say Y if you want to add support for SoC audio on an VF610 board with
+	  a SGTL5000 codec and a SAI.
+
+endif # SND_FSL_SOC
diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
index aaccbee..96110d1 100644
--- a/sound/soc/fsl/Makefile
+++ b/sound/soc/fsl/Makefile
@@ -22,6 +22,10 @@ obj-$(CONFIG_SND_SOC_FSL_SPDIF) += snd-soc-fsl-spdif.o
 obj-$(CONFIG_SND_SOC_FSL_UTILS) += snd-soc-fsl-utils.o
 obj-$(CONFIG_SND_SOC_POWERPC_DMA) += snd-soc-fsl-dma.o
 
+# VF610 Platform Support
+snd-soc-vf610-sgtl5000-objs := vf610-sgtl5000.o
+obj-$(CONFIG_SND_SOC_VF610_SGTL5000) += snd-soc-vf610-sgtl5000.o
+
 # MPC5200 Platform Support
 obj-$(CONFIG_SND_MPC52xx_DMA) += mpc5200_dma.o
 obj-$(CONFIG_SND_SOC_MPC5200_I2S) += mpc5200_psc_i2s.o
diff --git a/sound/soc/fsl/vf610-sgtl5000.c b/sound/soc/fsl/vf610-sgtl5000.c
new file mode 100644
index 0000000..75337bf
--- /dev/null
+++ b/sound/soc/fsl/vf610-sgtl5000.c
@@ -0,0 +1,178 @@
+/*
+ * Freescale ALSA SoC Audio using SGTL5000 as codec.
+ *
+ * Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+
+#include "../codecs/sgtl5000.h"
+#include "fsl_sai.h"
+
+static unsigned int sysclk_rate;
+
+static int vf610_sgtl5000_dai_init(struct snd_soc_pcm_runtime *rtd)
+{
+	int ret;
+	struct device *dev = rtd->card->dev;
+
+	ret = snd_soc_dai_set_sysclk(rtd->codec_dai, SGTL5000_SYSCLK,
+				     sysclk_rate, SND_SOC_CLOCK_IN);
+	if (ret) {
+		dev_err(dev, "could not set codec driver clock params :%d\n",
+				ret);
+		return ret;
+	}
+
+	ret = snd_soc_dai_set_sysclk(rtd->cpu_dai, FSL_SAI_CLK_BUS,
+				     sysclk_rate, SND_SOC_CLOCK_OUT);
+	if (ret) {
+		dev_err(dev, "could not set cpu dai driver clock params :%d\n",
+				ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct snd_soc_dai_link vf610_sgtl5000_dai = {
+	.name = "HiFi",
+	.stream_name = "HiFi",
+	.codec_dai_name = "sgtl5000",
+	.init = &vf610_sgtl5000_dai_init,
+	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+		SND_SOC_DAIFMT_CBM_CFM,
+};
+
+static const struct snd_soc_dapm_widget vf610_sgtl5000_dapm_widgets[] = {
+	SND_SOC_DAPM_MIC("Mic Jack", NULL),
+	SND_SOC_DAPM_LINE("Line In Jack", NULL),
+	SND_SOC_DAPM_HP("Headphone Jack", NULL),
+	SND_SOC_DAPM_SPK("Line Out Jack", NULL),
+	SND_SOC_DAPM_SPK("Ext Spk", NULL),
+};
+
+static struct snd_soc_card vf610_sgtl5000_card = {
+	.owner = THIS_MODULE,
+	.num_links = 1,
+	.dai_link = &vf610_sgtl5000_dai,
+	.dapm_widgets = vf610_sgtl5000_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(vf610_sgtl5000_dapm_widgets),
+};
+
+static int vf610_sgtl5000_parse_dt(struct platform_device *pdev)
+{
+	int ret;
+	struct device_node *sai_np, *codec_np;
+	struct clk *codec_clk;
+	struct i2c_client *codec_dev;
+	struct device_node *np = pdev->dev.of_node;
+
+	ret = snd_soc_of_parse_card_name(&vf610_sgtl5000_card, "model");
+	if (ret)
+		return ret;
+
+	ret = snd_soc_of_parse_audio_routing(&vf610_sgtl5000_card,
+			"audio-routing");
+	if (ret)
+		return ret;
+
+	sai_np = of_parse_phandle(np, "saif-controller", 0);
+	if (!sai_np) {
+		dev_err(&pdev->dev, "\"saif-controller\" phandle missing or "
+				"invalid\n");
+		return -EINVAL;
+	}
+	vf610_sgtl5000_dai.cpu_of_node = sai_np;
+	vf610_sgtl5000_dai.platform_of_node = sai_np;
+
+	codec_np = of_parse_phandle(np, "audio-codec", 0);
+	if (!codec_np) {
+		dev_err(&pdev->dev, "\"audio-codec\" phandle missing or "
+				"invalid\n");
+		ret = -EINVAL;
+		goto sai_np_fail;
+	}
+	vf610_sgtl5000_dai.codec_of_node = codec_np;
+
+	codec_dev = of_find_i2c_device_by_node(codec_np);
+	if (!codec_dev) {
+		dev_err(&pdev->dev, "failed to find codec platform device\n");
+		ret = PTR_ERR(codec_dev);
+		goto codec_np_fail;
+	}
+
+	codec_clk = devm_clk_get(&codec_dev->dev, NULL);
+	if (IS_ERR(codec_clk)) {
+		dev_err(&pdev->dev, "failed to get codec clock\n");
+		ret = PTR_ERR(codec_clk);
+		goto codec_np_fail;
+	}
+
+	sysclk_rate = clk_get_rate(codec_clk);
+
+codec_np_fail:
+	of_node_put(codec_np);
+sai_np_fail:
+	of_node_put(sai_np);
+
+	return ret;
+}
+
+static int vf610_sgtl5000_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	vf610_sgtl5000_card.dev = &pdev->dev;
+
+	ret = vf610_sgtl5000_parse_dt(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "parse sgtl5000 device tree failed :%d\n",
+				ret);
+		return ret;
+	}
+
+	ret = devm_snd_soc_register_card(&pdev->dev, &vf610_sgtl5000_card);
+	if (ret) {
+		dev_err(&pdev->dev, "TWR-AUDIO-SGTL board required :%d\n",
+				ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int vf610_sgtl5000_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id vf610_sgtl5000_dt_ids[] = {
+	{ .compatible = "fsl,vf610-sgtl5000", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, vf610_sgtl5000_dt_ids);
+
+static struct platform_driver vf610_sgtl5000_driver = {
+	.driver = {
+		.name = "vf610-sgtl5000",
+		.owner = THIS_MODULE,
+		.of_match_table = vf610_sgtl5000_dt_ids,
+	},
+	.probe = vf610_sgtl5000_probe,
+	.remove = vf610_sgtl5000_remove,
+};
+module_platform_driver(vf610_sgtl5000_driver);
+
+MODULE_AUTHOR("Xiubo Li <Li.Xiubo@freescale.com>");
+MODULE_DESCRIPTION("Freescale SGTL5000 ASoC driver");
+MODULE_LICENSE("GPL");
-- 
1.8.4


