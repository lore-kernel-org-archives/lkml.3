Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3LQERP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 23:17:15 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:14679
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab3LQEQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 23:16:44 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzbb2dI1458Kc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
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
Subject: [PATCHv3 1/7] ALSA: Add SAI SoC Digital Audio Interface driver.
Date: Tue, 17 Dec 2013 11:24:38 +0800
Message-ID: <1387250684-23406-2-git-send-email-Li.Xiubo@freescale.com>
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

Fix the description of one comment.

This adds Freescale SAI ASoC Audio support.
This implementation is only compatible with device tree definition.
Features:
o Supports playback/capture
o Supports 16/20/24 bit PCM
o Supports 8k - 96k sample rates
o Supports master and slave mode.

Signed-off-by: Alison Wang <b18965@freescale.com
Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/Kconfig   |   4 +
 sound/soc/fsl/Makefile  |   4 +-
 sound/soc/fsl/fsl_sai.c | 492 ++++++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/fsl/fsl_sai.h | 114 +++++++++++
 4 files changed, 613 insertions(+), 1 deletion(-)
 create mode 100644 sound/soc/fsl/fsl_sai.c
 create mode 100644 sound/soc/fsl/fsl_sai.h

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index b7ab71f..ac4fe4e 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -1,3 +1,7 @@
+config SND_SOC_FSL_SAI
+	tristate
+	select SND_SOC_GENERIC_DMAENGINE_PCM
+
 config SND_SOC_FSL_SSI
 	tristate
 
diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
index 8db705b..aaccbee 100644
--- a/sound/soc/fsl/Makefile
+++ b/sound/soc/fsl/Makefile
@@ -10,11 +10,13 @@ obj-$(CONFIG_SND_SOC_P1022_DS) += snd-soc-p1022-ds.o
 snd-soc-p1022-rdk-objs := p1022_rdk.o
 obj-$(CONFIG_SND_SOC_P1022_RDK) += snd-soc-p1022-rdk.o
 
-# Freescale PowerPC SSI/DMA Platform Support
+# Freescale SSI/DMA/SAI/SPDIF Support
+snd-soc-fsl-sai-objs := fsl_sai.o
 snd-soc-fsl-ssi-objs := fsl_ssi.o
 snd-soc-fsl-spdif-objs := fsl_spdif.o
 snd-soc-fsl-utils-objs := fsl_utils.o
 snd-soc-fsl-dma-objs := fsl_dma.o
+obj-$(CONFIG_SND_SOC_FSL_SAI) += snd-soc-fsl-sai.o
 obj-$(CONFIG_SND_SOC_FSL_SSI) += snd-soc-fsl-ssi.o
 obj-$(CONFIG_SND_SOC_FSL_SPDIF) += snd-soc-fsl-spdif.o
 obj-$(CONFIG_SND_SOC_FSL_UTILS) += snd-soc-fsl-utils.o
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
new file mode 100644
index 0000000..50a797e
--- /dev/null
+++ b/sound/soc/fsl/fsl_sai.c
@@ -0,0 +1,492 @@
+/*
+ * Freescale ALSA SoC Digital Audio Interface (SAI) driver.
+ *
+ * Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software, you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation, either version 2 of the License, or(at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/dmaengine_pcm.h>
+#include <sound/pcm_params.h>
+
+#include "fsl_sai.h"
+
+static inline u32 sai_readl(struct fsl_sai *sai,
+		const void __iomem *addr)
+{
+	u32 val;
+
+	val = __raw_readl(addr);
+
+	if (likely(sai->big_endian_regs))
+		val = be32_to_cpu(val);
+	else
+		val = le32_to_cpu(val);
+	rmb();
+
+	return val;
+}
+
+static inline void sai_writel(struct fsl_sai *sai,
+		u32 val, void __iomem *addr)
+{
+	wmb();
+	if (likely(sai->big_endian_regs))
+		val = cpu_to_be32(val);
+	else
+		val = cpu_to_le32(val);
+
+	__raw_writel(val, addr);
+}
+
+static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
+		int clk_id, unsigned int freq, int fsl_dir)
+{
+	u32 val_cr2, reg_cr2;
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	if (fsl_dir == FSL_FMT_TRANSMITTER)
+		reg_cr2 = FSL_SAI_TCR2;
+	else
+		reg_cr2 = FSL_SAI_RCR2;
+
+	val_cr2 = sai_readl(sai, sai->base + reg_cr2);
+	switch (clk_id) {
+	case FSL_SAI_CLK_BUS:
+		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
+		val_cr2 |= FSL_SAI_CR2_MSEL_BUS;
+		break;
+	case FSL_SAI_CLK_MAST1:
+		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
+		val_cr2 |= FSL_SAI_CR2_MSEL_MCLK1;
+		break;
+	case FSL_SAI_CLK_MAST2:
+		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
+		val_cr2 |= FSL_SAI_CR2_MSEL_MCLK2;
+		break;
+	case FSL_SAI_CLK_MAST3:
+		val_cr2 &= ~FSL_SAI_CR2_MSEL_MASK;
+		val_cr2 |= FSL_SAI_CR2_MSEL_MCLK3;
+		break;
+	default:
+		return -EINVAL;
+	}
+	sai_writel(sai, val_cr2, sai->base + reg_cr2);
+
+	return 0;
+}
+
+static int fsl_sai_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
+		int clk_id, unsigned int freq, int dir)
+{
+	int ret;
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	if (dir == SND_SOC_CLOCK_IN)
+		return 0;
+
+	ret = clk_prepare_enable(sai->clk);
+	if (ret)
+		return ret;
+
+	sai_writel(sai, 0x0, sai->base + FSL_SAI_RCSR);
+	sai_writel(sai, 0x0, sai->base + FSL_SAI_TCSR);
+	sai_writel(sai, FSL_SAI_MAXBURST_TX * 2, sai->base + FSL_SAI_TCR1);
+	sai_writel(sai, FSL_SAI_MAXBURST_RX - 1, sai->base + FSL_SAI_RCR1);
+
+	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
+					FSL_FMT_TRANSMITTER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set SAI's transmitter sysclk: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
+					FSL_FMT_RECEIVER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set SAI's receiver sysclk: %d\n",
+				ret);
+		return ret;
+	}
+
+	clk_disable_unprepare(sai->clk);
+
+	return 0;
+}
+
+static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
+				unsigned int fmt, int fsl_dir)
+{
+	u32 val_cr2, val_cr3, val_cr4, reg_cr2, reg_cr3, reg_cr4;
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	if (fsl_dir == FSL_FMT_TRANSMITTER) {
+		reg_cr2 = FSL_SAI_TCR2;
+		reg_cr3 = FSL_SAI_TCR3;
+		reg_cr4 = FSL_SAI_TCR4;
+	} else {
+		reg_cr2 = FSL_SAI_RCR2;
+		reg_cr3 = FSL_SAI_RCR3;
+		reg_cr4 = FSL_SAI_RCR4;
+	}
+
+	val_cr2 = sai_readl(sai, sai->base + reg_cr2);
+	val_cr3 = sai_readl(sai, sai->base + reg_cr3);
+	val_cr4 = sai_readl(sai, sai->base + reg_cr4);
+
+	if (sai->big_endian_data)
+		val_cr4 |= FSL_SAI_CR4_MF;
+	else
+		val_cr4 &= ~FSL_SAI_CR4_MF;
+
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		val_cr4 |= FSL_SAI_CR4_FSE;
+		val_cr4 |= FSL_SAI_CR4_FSP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_IB_IF:
+		val_cr4 |= FSL_SAI_CR4_FSP;
+		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		break;
+	case SND_SOC_DAIFMT_IB_NF:
+		val_cr4 &= ~FSL_SAI_CR4_FSP;
+		val_cr2 &= ~FSL_SAI_CR2_BCP;
+		break;
+	case SND_SOC_DAIFMT_NB_IF:
+		val_cr4 |= FSL_SAI_CR4_FSP;
+		val_cr2 |= FSL_SAI_CR2_BCP;
+		break;
+	case SND_SOC_DAIFMT_NB_NF:
+		val_cr4 &= ~FSL_SAI_CR4_FSP;
+		val_cr2 |= FSL_SAI_CR2_BCP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
+		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+		val_cr2 &= ~FSL_SAI_CR2_BCD_MSTR;
+		val_cr4 &= ~FSL_SAI_CR4_FSD_MSTR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val_cr3 |= FSL_SAI_CR3_TRCE;
+
+	if (fsl_dir == FSL_FMT_RECEIVER)
+		val_cr2 |= FSL_SAI_CR2_SYNC;
+
+	sai_writel(sai, val_cr2, sai->base + reg_cr2);
+	sai_writel(sai, val_cr3, sai->base + reg_cr3);
+	sai_writel(sai, val_cr4, sai->base + reg_cr4);
+
+	return 0;
+}
+
+static int fsl_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
+{
+	int ret;
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	ret = clk_prepare_enable(sai->clk);
+	if (ret)
+		return ret;
+
+	ret = fsl_sai_set_dai_fmt_tr(cpu_dai, fmt, FSL_FMT_TRANSMITTER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set SAI's transmitter format: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = fsl_sai_set_dai_fmt_tr(cpu_dai, fmt, FSL_FMT_RECEIVER);
+	if (ret) {
+		dev_err(cpu_dai->dev,
+				"Cannot set SAI's receiver format: %d\n",
+				ret);
+		return ret;
+	}
+
+	clk_disable_unprepare(sai->clk);
+
+	return 0;
+}
+
+static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params,
+		struct snd_soc_dai *cpu_dai)
+{
+	u32 val_cr4, val_cr5, val_mr, reg_cr4, reg_cr5, reg_mr, word_width;
+	unsigned int channels = params_channels(params);
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		reg_cr4 = FSL_SAI_TCR4;
+		reg_cr5 = FSL_SAI_TCR5;
+		reg_mr = FSL_SAI_TMR;
+	} else {
+		reg_cr4 = FSL_SAI_RCR4;
+		reg_cr5 = FSL_SAI_RCR5;
+		reg_mr = FSL_SAI_RMR;
+	}
+
+	val_cr4 = sai_readl(sai, sai->base + reg_cr4);
+	val_cr4 &= ~FSL_SAI_CR4_SYWD_MASK;
+	val_cr4 &= ~FSL_SAI_CR4_FRSZ_MASK;
+
+	val_cr5 = sai_readl(sai, sai->base + reg_cr5);
+	val_cr5 &= ~FSL_SAI_CR5_WNW_MASK;
+	val_cr5 &= ~FSL_SAI_CR5_W0W_MASK;
+	val_cr5 &= ~FSL_SAI_CR5_FBT_MASK;
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		word_width = 16;
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		word_width = 20;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		word_width = 24;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val_cr4 |= FSL_SAI_CR4_SYWD(word_width);
+	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
+	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
+
+	if (sai->big_endian_data)
+		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
+	else
+		val_cr5 |= FSL_SAI_CR5_FBT(0);
+
+	val_cr4 |= FSL_SAI_CR4_FRSZ(channels);
+	if (channels == 2 || channels == 1)
+		val_mr = ~0UL - ((1 << channels) - 1);
+	else
+		return -EINVAL;
+
+	sai_writel(sai, val_cr4, sai->base + reg_cr4);
+	sai_writel(sai, val_cr5, sai->base + reg_cr5);
+	sai_writel(sai, val_mr, sai->base + reg_mr);
+
+	return 0;
+}
+
+static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
+		struct snd_soc_dai *cpu_dai)
+{
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+	unsigned int tcsr, rcsr;
+
+	tcsr = sai_readl(sai, sai->base + FSL_SAI_TCSR);
+	rcsr = sai_readl(sai, sai->base + FSL_SAI_RCSR);
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		tcsr |= FSL_SAI_CSR_FRDE;
+		rcsr &= ~FSL_SAI_CSR_FRDE;
+	} else {
+		rcsr |= FSL_SAI_CSR_FRDE;
+		tcsr &= ~FSL_SAI_CSR_FRDE;
+	}
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		tcsr |= FSL_SAI_CSR_TERE;
+		rcsr |= FSL_SAI_CSR_TERE;
+		sai_writel(sai, rcsr, sai->base + FSL_SAI_RCSR);
+		sai_writel(sai, tcsr, sai->base + FSL_SAI_TCSR);
+		break;
+
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		if (!(cpu_dai->playback_active || cpu_dai->capture_active)) {
+			tcsr &= ~FSL_SAI_CSR_TERE;
+			rcsr &= ~FSL_SAI_CSR_TERE;
+		}
+		sai_writel(sai, tcsr, sai->base + FSL_SAI_TCSR);
+		sai_writel(sai, rcsr, sai->base + FSL_SAI_RCSR);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fsl_sai_startup(struct snd_pcm_substream *substream,
+		struct snd_soc_dai *cpu_dai)
+{
+	int ret;
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	ret = clk_prepare_enable(sai->clk);
+
+	return ret;
+}
+
+static void fsl_sai_shutdown(struct snd_pcm_substream *substream,
+		struct snd_soc_dai *cpu_dai)
+{
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	clk_disable_unprepare(sai->clk);
+}
+
+static const struct snd_soc_dai_ops fsl_sai_pcm_dai_ops = {
+	.set_sysclk	= fsl_sai_set_dai_sysclk,
+	.set_fmt	= fsl_sai_set_dai_fmt,
+	.hw_params	= fsl_sai_hw_params,
+	.trigger	= fsl_sai_trigger,
+	.startup	= fsl_sai_startup,
+	.shutdown	= fsl_sai_shutdown,
+};
+
+static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
+{
+	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
+
+	cpu_dai->playback_dma_data = &sai->dma_params_tx;
+	cpu_dai->capture_dma_data = &sai->dma_params_rx;
+
+	snd_soc_dai_set_drvdata(cpu_dai, sai);
+
+	return 0;
+}
+
+static int fsl_sai_dai_remove(struct snd_soc_dai *cpu_dai)
+{
+	cpu_dai->playback_dma_data = NULL;
+	cpu_dai->capture_dma_data = NULL;
+
+	snd_soc_dai_set_drvdata(cpu_dai, NULL);
+
+	return 0;
+}
+
+static struct snd_soc_dai_driver fsl_sai_dai = {
+	.probe = fsl_sai_dai_probe,
+	.remove = fsl_sai_dai_remove,
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000_96000,
+		.formats = FSL_SAI_FORMATS,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000_96000,
+		.formats = FSL_SAI_FORMATS,
+	},
+	.ops = &fsl_sai_pcm_dai_ops,
+};
+
+static const struct snd_soc_component_driver fsl_component = {
+	.name           = "fsl-sai",
+};
+
+static int fsl_sai_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct fsl_sai *sai;
+	struct resource *res;
+	struct device_node *np = pdev->dev.of_node;
+
+	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
+	if (!sai)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	sai->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(sai->base))
+		return PTR_ERR(sai->base);
+
+	sai->clk = devm_clk_get(&pdev->dev, "sai");
+	if (IS_ERR(sai->clk)) {
+		dev_err(&pdev->dev, "Cannot get SAI's clock\n");
+		return PTR_ERR(sai->clk);
+	}
+
+	sai->dma_params_rx.addr = res->start + FSL_SAI_RDR;
+	sai->dma_params_tx.addr = res->start + FSL_SAI_TDR;
+	sai->dma_params_rx.maxburst = FSL_SAI_MAXBURST_RX;
+	sai->dma_params_tx.maxburst = FSL_SAI_MAXBURST_TX;
+
+	sai->big_endian_regs = of_property_read_bool(np, "big-endian-regs");
+	sai->big_endian_data = of_property_read_bool(np, "big-endian-data");
+
+	platform_set_drvdata(pdev, sai);
+
+	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
+			&fsl_sai_dai, 1);
+	if (ret)
+		return ret;
+
+	ret = snd_dmaengine_pcm_register(&pdev->dev, NULL,
+			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int fsl_sai_remove(struct platform_device *pdev)
+{
+	snd_dmaengine_pcm_unregister(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id fsl_sai_ids[] = {
+	{ .compatible = "fsl,vf610-sai", },
+	{ /* sentinel */ }
+};
+
+static struct platform_driver fsl_sai_driver = {
+	.probe = fsl_sai_probe,
+	.remove = fsl_sai_remove,
+
+	.driver = {
+		.name = "fsl-sai",
+		.owner = THIS_MODULE,
+		.of_match_table = fsl_sai_ids,
+	},
+};
+module_platform_driver(fsl_sai_driver);
+
+MODULE_DESCRIPTION("Freescale Soc SAI Interface");
+MODULE_AUTHOR("Xiubo Li, <Li.Xiubo@freescale.com>");
+MODULE_ALIAS("platform:fsl-sai");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
new file mode 100644
index 0000000..41bb62e
--- /dev/null
+++ b/sound/soc/fsl/fsl_sai.h
@@ -0,0 +1,114 @@
+/*
+ * Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __FSL_SAI_H
+#define __FSL_SAI_H
+
+#include <sound/dmaengine_pcm.h>
+
+#define FSL_SAI_FORMATS (SNDRV_PCM_FMTBIT_S16_LE |\
+			 SNDRV_PCM_FMTBIT_S20_3LE |\
+			 SNDRV_PCM_FMTBIT_S24_LE)
+
+/* SAI Transmit/Recieve Control Register */
+#define FSL_SAI_TCSR		0x00
+#define FSL_SAI_RCSR		0x80
+#define FSL_SAI_CSR_TERE	BIT(31)
+#define FSL_SAI_CSR_FWF		BIT(17)
+#define FSL_SAI_CSR_FRIE	BIT(8)
+#define FSL_SAI_CSR_FRDE	BIT(0)
+
+/* SAI Transmit Data/FIFO/MASK Register */
+#define FSL_SAI_TDR		0x20
+#define FSL_SAI_TFR		0x40
+#define FSL_SAI_TMR		0x60
+
+/* SAI Recieve Data/FIFO/MASK Register */
+#define FSL_SAI_RDR		0xa0
+#define FSL_SAI_RFR		0xc0
+#define FSL_SAI_RMR		0xe0
+
+/* SAI Transmit and Recieve Configuration 1 Register */
+#define FSL_SAI_TCR1		0x04
+#define FSL_SAI_RCR1		0x84
+
+/* SAI Transmit and Recieve Configuration 2 Register */
+#define FSL_SAI_TCR2		0x08
+#define FSL_SAI_RCR2		0x88
+#define FSL_SAI_CR2_SYNC	BIT(30)
+#define FSL_SAI_CR2_MSEL_MASK	(0xff << 26)
+#define FSL_SAI_CR2_MSEL_BUS	0
+#define FSL_SAI_CR2_MSEL_MCLK1	BIT(26)
+#define FSL_SAI_CR2_MSEL_MCLK2	BIT(27)
+#define FSL_SAI_CR2_MSEL_MCLK3	(BIT(26) | BIT(27))
+#define FSL_SAI_CR2_BCP		BIT(25)
+#define FSL_SAI_CR2_BCD_MSTR	BIT(24)
+
+/* SAI Transmit and Recieve Configuration 3 Register */
+#define FSL_SAI_TCR3		0x0c
+#define FSL_SAI_RCR3		0x8c
+#define FSL_SAI_CR3_TRCE	BIT(16)
+#define FSL_SAI_CR3_WDFL(x)	(x)
+#define FSL_SAI_CR3_WDFL_MASK	0x1f
+
+/* SAI Transmit and Recieve Configuration 4 Register */
+#define FSL_SAI_TCR4		0x10
+#define FSL_SAI_RCR4		0x90
+#define FSL_SAI_CR4_FRSZ(x)	(((x) - 1) << 16)
+#define FSL_SAI_CR4_FRSZ_MASK	(0x1f << 16)
+#define FSL_SAI_CR4_SYWD(x)	(((x) - 1) << 8)
+#define FSL_SAI_CR4_SYWD_MASK	(0x1f << 8)
+#define FSL_SAI_CR4_MF		BIT(4)
+#define FSL_SAI_CR4_FSE		BIT(3)
+#define FSL_SAI_CR4_FSP		BIT(1)
+#define FSL_SAI_CR4_FSD_MSTR	BIT(0)
+
+/* SAI Transmit and Recieve Configuration 5 Register */
+#define FSL_SAI_TCR5		0x14
+#define FSL_SAI_RCR5		0x94
+#define FSL_SAI_CR5_WNW(x)	(((x) - 1) << 24)
+#define FSL_SAI_CR5_WNW_MASK	(0x1f << 24)
+#define FSL_SAI_CR5_W0W(x)	(((x) - 1) << 16)
+#define FSL_SAI_CR5_W0W_MASK	(0x1f << 16)
+#define FSL_SAI_CR5_FBT(x)	((x) << 8)
+#define FSL_SAI_CR5_FBT_MASK	(0x1f << 8)
+
+/* SAI type */
+#define FSL_SAI_DMA		BIT(0)
+#define FSL_SAI_USE_AC97	BIT(1)
+#define FSL_SAI_NET		BIT(2)
+#define FSL_SAI_TRA_SYN		BIT(3)
+#define FSL_SAI_REC_SYN		BIT(4)
+#define FSL_SAI_USE_I2S_SLAVE	BIT(5)
+
+#define FSL_FMT_TRANSMITTER	0
+#define FSL_FMT_RECEIVER	1
+
+/* SAI clock sources */
+#define FSL_SAI_CLK_BUS		0
+#define FSL_SAI_CLK_MAST1	1
+#define FSL_SAI_CLK_MAST2	2
+#define FSL_SAI_CLK_MAST3	3
+
+/* SAI data transfer numbers per DMA request */
+#define FSL_SAI_MAXBURST_TX 6
+#define FSL_SAI_MAXBURST_RX 6
+
+struct fsl_sai {
+	struct clk *clk;
+
+	void __iomem *base;
+
+	bool big_endian_regs;
+	bool big_endian_data;
+
+	struct snd_dmaengine_dai_dma_data dma_params_rx;
+	struct snd_dmaengine_dai_dma_data dma_params_tx;
+};
+
+#endif /* __FSL_SAI_H */
-- 
1.8.4


