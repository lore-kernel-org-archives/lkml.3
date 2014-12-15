Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaLOCOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:14:23 -0500
Received: from regular2.263xmail.com ([211.157.152.4]:55720 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaLOCOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:14:14 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-SENDER-IP: 104.167.231.7
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <509e3764044bc5d39a2fb1ddbfd1bbd3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yakir Yang <ykk@rock-chips.com>
To: Yakir Yang <ykk@rock-chips.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jyri Sarha <jsarha@ti.com>, Sean Cross <xobs@kosagi.com>,
        Ben Zhang <benzh@chromium.org>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org
Subject: [PATCH 3/6] ASoC: dw-hdmi-audio: add codec driver for dw hdmi audio
Date: Mon, 15 Dec 2014 10:11:31 +0800
Message-Id: <1418609494-15820-4-git-send-email-ykk@rock-chips.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

codec driver get some interfaces from dw_hdmi driver, than using those
to set hdmi audio formats, corresponding to alsa formats.

Signed-off-by: Yakir Yang <ykk@rock-chips.com>
---

 sound/soc/codecs/Kconfig         |   4 +
 sound/soc/codecs/Makefile        |   2 +
 sound/soc/codecs/dw-hdmi-audio.c | 371 +++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/dw-hdmi-audio.h |  82 +++++++++
 4 files changed, 459 insertions(+)
 create mode 100644 sound/soc/codecs/dw-hdmi-audio.c
 create mode 100644 sound/soc/codecs/dw-hdmi-audio.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 883c577..e0b8be6 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -75,6 +75,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_MC13783 if MFD_MC13XXX
 	select SND_SOC_ML26124 if I2C
 	select SND_SOC_HDMI_CODEC
+	select SND_SOC_DW_HDMI_AUDIO
 	select SND_SOC_PCM1681 if I2C
 	select SND_SOC_PCM1792A if SPI_MASTER
 	select SND_SOC_PCM3008
@@ -459,6 +460,9 @@ config SND_SOC_MAX98095
 config SND_SOC_MAX9850
 	tristate
 
+config SND_SOC_DW_HDMI_AUDIO
+       tristate
+
 config SND_SOC_PCM1681
 	tristate "Texas Instruments PCM1681 CODEC"
 	depends on I2C
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index bbdfd1e..0ebb664 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -68,6 +68,7 @@ snd-soc-max9850-objs := max9850.o
 snd-soc-mc13783-objs := mc13783.o
 snd-soc-ml26124-objs := ml26124.o
 snd-soc-hdmi-codec-objs := hdmi.o
+snd-soc-dw-hdmi-audio-objs := dw-hdmi-audio.o
 snd-soc-pcm1681-objs := pcm1681.o
 snd-soc-pcm1792a-codec-objs := pcm1792a.o
 snd-soc-pcm3008-objs := pcm3008.o
@@ -249,6 +250,7 @@ obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
 obj-$(CONFIG_SND_SOC_MC13783)	+= snd-soc-mc13783.o
 obj-$(CONFIG_SND_SOC_ML26124)	+= snd-soc-ml26124.o
 obj-$(CONFIG_SND_SOC_HDMI_CODEC) += snd-soc-hdmi-codec.o
+obj-$(CONFIG_SND_SOC_DW_HDMI_AUDIO) += snd-soc-dw-hdmi-audio.o
 obj-$(CONFIG_SND_SOC_PCM1681)	+= snd-soc-pcm1681.o
 obj-$(CONFIG_SND_SOC_PCM1792A)	+= snd-soc-pcm1792a-codec.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
diff --git a/sound/soc/codecs/dw-hdmi-audio.c b/sound/soc/codecs/dw-hdmi-audio.c
new file mode 100644
index 0000000..a76d85d
--- /dev/null
+++ b/sound/soc/codecs/dw-hdmi-audio.c
@@ -0,0 +1,371 @@
+/*
+ * dw-hdmi-codec.c
+ *
+ * DesignerWare ALSA SoC DAI driver for DW HDMI audio.
+ * Copyright (c) 2014,  CORPORATION. All rights reserved.
+ * Authors: Yakir Yang <ykk@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.*
+ *
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/moduleparam.h>
+
+#include <sound/pcm.h>
+#include <sound/soc.h>
+#include <sound/core.h>
+#include <sound/jack.h>
+#include <sound/initval.h>
+#include <sound/pcm_params.h>
+
+#include <drm/bridge/dw_hdmi.h>
+#include "dw-hdmi-audio.h"
+
+struct snd_dw_hdmi {
+	struct device *dev;
+	struct dw_hdmi_audio_data data;
+
+	struct snd_soc_jack *jack;
+	struct delayed_work jack_work;
+	enum hdmi_jack_status jack_status;
+	enum hdmi_jack_status connect_status;
+};
+
+/**
+ * dw_hdmi_jack_detect - Enable hdmi detection via the HDMI IRQ
+ *
+ * @codec:  HDMI codec
+ * @jack:   jack to report detection events on
+ *
+ * Enable HDMI detection via IRQ on the HDMI.
+ *
+ * If no jack is supplied detection will be disabled.
+ */
+int dw_hdmi_jack_detect(struct snd_soc_codec *codec_dai,
+			struct snd_soc_jack *jack)
+{
+	struct snd_dw_hdmi *hdmi = snd_soc_codec_get_drvdata(codec_dai);
+
+	hdmi->jack = jack;
+	hdmi->jack_status = JACK_NO_LINEOUT;
+
+	snd_soc_jack_report(hdmi->jack, 0, SND_JACK_LINEOUT);
+
+	queue_delayed_work(system_power_efficient_wq, &hdmi->jack_work,
+			   msecs_to_jiffies(50));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dw_hdmi_jack_detect);
+
+static void dw_hdmi_jack_work(struct work_struct *work)
+{
+	struct snd_dw_hdmi *hdmi = container_of(work, struct snd_dw_hdmi,
+						jack_work.work);
+	u8 status;
+
+	status = hdmi->data.read(hdmi->data.dw, HDMI_PHY_STAT0) & HDMI_PHY_HPD;
+	if (status != hdmi->connect_status) {
+		hdmi->jack_status = status ? SND_JACK_LINEOUT : 0;
+		snd_soc_jack_report(hdmi->jack, hdmi->jack_status,
+				    SND_JACK_LINEOUT);
+		dev_info(hdmi->dev, "jack report [%d]\n", hdmi->jack_status);
+	}
+	hdmi->connect_status = status;
+}
+
+static irqreturn_t snd_dw_hdmi_irq(int irq, void *dev_id)
+{
+	struct snd_dw_hdmi *hdmi = dev_id;
+
+	queue_delayed_work(system_power_efficient_wq, &hdmi->jack_work,
+			   msecs_to_jiffies(50));
+
+	return IRQ_HANDLED;
+}
+
+void enable_dw_hdmi_audio(struct snd_dw_hdmi *hdmi)
+{
+	hdmi->data.mod(hdmi->data.dw, 0, HDMI_MC_CLKDIS_AUDCLK_DISABLE,
+		       HDMI_MC_CLKDIS);
+}
+
+void disable_dw_hdmi_audio(struct snd_dw_hdmi *hdmi)
+{
+	hdmi->data.mod(hdmi->data.dw, 1,
+		       HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
+}
+
+void set_dw_hdmi_audio_fmt(struct snd_dw_hdmi *hdmi, struct hdmi_audio_fmt fmt)
+{
+	hdmi->data.mod(hdmi->data.dw, fmt.input_type, AUDIO_CONF0_INTERFACE_MSK,
+		       HDMI_AUD_CONF0);
+
+	hdmi->data.mod(hdmi->data.dw, fmt.chan_num, AUDIO_CONF0_I2SINEN_MSK,
+		       HDMI_AUD_CONF0);
+
+	hdmi->data.mod(hdmi->data.dw, fmt.word_length, AUDIO_CONF1_DATWIDTH_MSK,
+		       HDMI_AUD_CONF1);
+
+	hdmi->data.mod(hdmi->data.dw, fmt.dai_fmt, AUDIO_CONF1_DATAMODE_MSK,
+		       HDMI_AUD_CONF1);
+
+	hdmi->data.write(hdmi->data.dw, 0, HDMI_AUD_INPUTCLKFS);
+
+	hdmi->data.set_sample_rate(hdmi->data.dw, fmt.sample_rate);
+}
+
+static int dw_hdmi_dai_startup(struct snd_pcm_substream *substream,
+			       struct snd_soc_dai *codec_dai)
+{
+	struct snd_dw_hdmi *hdmi = snd_soc_dai_get_drvdata(codec_dai);
+
+	dev_info(codec_dai->dev, "[codec_dai]: startup.\n");
+	enable_dw_hdmi_audio(hdmi);
+
+	return 0;
+}
+
+static int dw_hdmi_dai_hw_params(struct snd_pcm_substream *substream,
+				 struct snd_pcm_hw_params *params,
+				 struct snd_soc_dai *codec_dai)
+{
+	struct snd_dw_hdmi *hdmi = snd_soc_dai_get_drvdata(codec_dai);
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct hdmi_audio_fmt hdmi_fmt;
+	unsigned int fmt, rate, chan, width;
+
+	fmt = rtd->dai_link->dai_fmt & SND_SOC_DAIFMT_FORMAT_MASK;
+	switch (fmt) {
+	case SND_SOC_DAIFMT_I2S:
+		hdmi_fmt.dai_fmt = AUDIO_DAIFMT_IIS;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		hdmi_fmt.dai_fmt = AUDIO_DAIFMT_LEFT_J;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		hdmi_fmt.dai_fmt = AUDIO_DAIFMT_RIGHT_J;
+		break;
+	default:
+		dev_err(codec_dai->dev, "DAI format unsupported");
+		return -EINVAL;
+	}
+	dev_info(codec_dai->dev, "[codec_dai]: dai_fmt = %d.\n", fmt);
+
+	width = params_width(params);
+	switch (width) {
+	case 16:
+	case 24:
+		hdmi_fmt.word_length = width;
+		break;
+	default:
+		dev_err(codec_dai->dev, "width[%d] not support!\n", width);
+		return -EINVAL;
+	}
+	dev_info(codec_dai->dev, "[codec_dai]: word_length = %d.\n", width);
+
+	chan = params_channels(params);
+	switch (chan) {
+	case 2:
+		hdmi_fmt.chan_num = AUDIO_CHANNELNUM_2;
+		break;
+	case 4:
+		hdmi_fmt.chan_num = AUDIO_CHANNELNUM_4;
+		break;
+	case 6:
+		hdmi_fmt.chan_num = AUDIO_CHANNELNUM_6;
+		break;
+	case 8:
+		hdmi_fmt.chan_num = AUDIO_CHANNELNUM_8;
+		break;
+	default:
+		dev_err(codec_dai->dev, "channel[%d] not support!\n", chan);
+		return -EINVAL;
+	}
+	dev_info(codec_dai->dev, "[codec_dai]: chan_num = %d.\n", chan);
+
+	rate = params_rate(params);
+	switch (rate) {
+	case 32000:
+	case 44100:
+	case 48000:
+	case 88200:
+	case 96000:
+	case 176400:
+	case 192000:
+		hdmi_fmt.sample_rate = rate;
+		break;
+	default:
+		dev_err(codec_dai->dev, "rate[%d] not support!\n", rate);
+		return -EINVAL;
+	}
+	dev_info(codec_dai->dev, "[codec_dai]: sample_rate = %d.\n", rate);
+
+	hdmi_fmt.input_type = AUDIO_INPUTTYPE_IIS;
+
+	set_dw_hdmi_audio_fmt(hdmi, hdmi_fmt);
+
+	return 0;
+}
+
+static int dw_hdmi_dai_trigger(struct snd_pcm_substream *substream,
+			       int cmd, struct snd_soc_dai *codec_dai)
+{
+	struct snd_dw_hdmi *hdmi = snd_soc_dai_get_drvdata(codec_dai);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		disable_dw_hdmi_audio(hdmi);
+		dev_info(codec_dai->dev, "[codec_dai]: trigger enable.\n");
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		enable_dw_hdmi_audio(hdmi);
+		dev_info(codec_dai->dev, "[codec_dai]: trigger disable.\n");
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void dw_hdmi_dai_shutdown(struct snd_pcm_substream *substream,
+				 struct snd_soc_dai *codec_dai)
+{
+	struct snd_dw_hdmi *hdmi = snd_soc_dai_get_drvdata(codec_dai);
+
+	dev_info(codec_dai->dev, "[codec_dai]: shutdown.\n");
+	disable_dw_hdmi_audio(hdmi);
+}
+
+static const struct snd_soc_dapm_widget dw_hdmi_widgets[] = {
+	SND_SOC_DAPM_OUTPUT("TX"),
+};
+
+static const struct snd_soc_dapm_route dw_hdmi_routes[] = {
+	{ "TX", NULL, "Playback" },
+};
+
+static const struct snd_soc_dai_ops dw_hdmi_dai_ops = {
+	.startup = dw_hdmi_dai_startup,
+	.hw_params = dw_hdmi_dai_hw_params,
+	.trigger = dw_hdmi_dai_trigger,
+	.shutdown = dw_hdmi_dai_shutdown,
+};
+
+static struct snd_soc_dai_driver dw_hdmi_audio_dai[] = {
+{
+	.name = "dw-hdmi-hifi",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 2,
+		.channels_max = 8,
+		.rates = SNDRV_PCM_RATE_32000 |
+			 SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 |
+			 SNDRV_PCM_RATE_88200 | SNDRV_PCM_RATE_96000 |
+			 SNDRV_PCM_RATE_176400 | SNDRV_PCM_RATE_192000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+	},
+	.ops = &dw_hdmi_dai_ops,
+}
+};
+
+static struct snd_soc_codec_driver dw_hdmi_audio = {
+	.dapm_widgets = dw_hdmi_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(dw_hdmi_widgets),
+	.dapm_routes = dw_hdmi_routes,
+	.num_dapm_routes = ARRAY_SIZE(dw_hdmi_routes),
+};
+
+static int dw_hdmi_audio_probe(struct platform_device *pdev)
+{
+	struct dw_hdmi_audio_data *data = pdev->dev.platform_data;
+	struct snd_dw_hdmi *hdmi;
+	int ret;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	hdmi->data = *data;
+	hdmi->dev = &pdev->dev;
+	platform_set_drvdata(pdev, hdmi);
+
+	INIT_DELAYED_WORK(&hdmi->jack_work, dw_hdmi_jack_work);
+
+	ret = devm_request_irq(&pdev->dev, hdmi->data.irq, snd_dw_hdmi_irq,
+			       IRQF_SHARED, "dw-hdmi-audio", hdmi);
+	if (ret) {
+		dev_err(&pdev->dev, "request irq failed (%d)\n", ret);
+		goto free_hdmi_data;
+	}
+
+	ret = snd_soc_register_codec(&pdev->dev, &dw_hdmi_audio,
+				     dw_hdmi_audio_dai,
+				     ARRAY_SIZE(dw_hdmi_audio_dai));
+	if (ret) {
+		dev_err(&pdev->dev, "register codec failed (%d)\n", ret);
+		goto free_irq;
+	}
+
+	dev_info(&pdev->dev, "hdmi audio init success.\n");
+
+	return 0;
+
+free_irq:
+	devm_free_irq(&pdev->dev, hdmi->data.irq, hdmi);
+free_hdmi_data:
+	devm_kfree(&pdev->dev, hdmi);
+
+	return ret;
+}
+
+static int dw_hdmi_audio_remove(struct platform_device *pdev)
+{
+	struct snd_dw_hdmi *hdmi = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_codec(&pdev->dev);
+	devm_free_irq(&pdev->dev, hdmi->data.irq, hdmi);
+	devm_kfree(&pdev->dev, hdmi);
+
+	return 0;
+}
+
+static const struct of_device_id dw_hdmi_audio_ids[] = {
+	{ .compatible = "dw-hdmi-audio", },
+	{ }
+};
+
+static struct platform_driver dw_hdmi_audio_driver = {
+	.driver = {
+		.name = "dw-hdmi-audio",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(dw_hdmi_audio_ids),
+	},
+	.probe = dw_hdmi_audio_probe,
+	.remove = dw_hdmi_audio_remove,
+};
+module_platform_driver(dw_hdmi_audio_driver);
+
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
+MODULE_DESCRIPTION("DW HDMI Audio ASoC Interface");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" "dw-hdmi-audio");
+MODULE_DEVICE_TABLE(of, dw_hdmi_audio_ids);
diff --git a/sound/soc/codecs/dw-hdmi-audio.h b/sound/soc/codecs/dw-hdmi-audio.h
new file mode 100644
index 0000000..38e2e81
--- /dev/null
+++ b/sound/soc/codecs/dw-hdmi-audio.h
@@ -0,0 +1,82 @@
+/*
+ * dw-hdmi-audio.h -- DW HDMI ALSA SoC Audio driver
+ *
+ * Copyright 2011-2012 DesignerWare Products
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DW_HDMI_AUDIO_H
+#define _DW_HDMI_AUDIO_H
+
+enum hdmi_audio_reg {
+	HDMI_PHY_STAT0 = 0x3004,
+	HDMI_AUD_CONF0 = 0x3100,
+	HDMI_AUD_CONF1 = 0x3101,
+	HDMI_AUD_INPUTCLKFS = 0x3206,
+	HDMI_MC_CLKDIS = 0x4001,
+};
+
+enum {
+	HDMI_PHY_HPD = 0x2,
+	HDMI_MC_CLKDIS_AUDCLK_DISABLE = 0x8,
+};
+
+enum hdmi_audio_samplerate {
+	AUDIO_SAMPLERATE_32K = 32000,
+	AUDIO_SAMPLERATE_44K1 = 44100,
+	AUDIO_SAMPLERATE_48K = 48000,
+	AUDIO_SAMPLERATE_88K2 = 88200,
+	AUDIO_SAMPLERATE_96K = 96000,
+	AUDIO_SAMPLERATE_176K4 = 176400,
+	AUDIO_SAMPLERATE_192K = 192000,
+};
+
+#define AUDIO_CONF1_DATWIDTH_MSK	0x1F
+enum hdmi_audio_wordlength {
+	AUDIO_WORDLENGTH_16BIT = 16,
+	AUDIO_WORDLENGTH_24BIT = 24,
+};
+
+#define AUDIO_CONF1_DATAMODE_MSK	0xE0
+enum hdmi_audio_daifmt {
+	AUDIO_DAIFMT_IIS = 0x00,
+	AUDIO_DAIFMT_RIGHT_J = 0x20,
+	AUDIO_DAIFMT_LEFT_J = 0x40,
+	AUDIO_DAIFMT_BURST_1 = 0x60,
+	AUDIO_DAIFMT_BURST_2 = 0x80,
+};
+
+#define AUDIO_CONF0_INTERFACE_MSK	0x20
+enum hdmi_audio_inputtype {
+	AUDIO_INPUTTYPE_IIS = 0x20,
+	AUDIO_INPUTTYPE_SPDIF = 0x00,
+};
+
+#define AUDIO_CONF0_I2SINEN_MSK		0x0F
+enum hdmi_audio_channelnum {
+	AUDIO_CHANNELNUM_2 = 0x01,
+	AUDIO_CHANNELNUM_4 = 0x03,
+	AUDIO_CHANNELNUM_6 = 0x07,
+	AUDIO_CHANNELNUM_8 = 0x0F,
+};
+
+enum hdmi_jack_status {
+	JACK_LINEOUT,
+	JACK_NO_LINEOUT,
+};
+
+struct hdmi_audio_fmt {
+	enum hdmi_audio_inputtype input_type;
+	enum hdmi_audio_channelnum chan_num;
+	enum hdmi_audio_samplerate sample_rate;
+	enum hdmi_audio_wordlength word_length;
+	enum hdmi_audio_daifmt dai_fmt;
+};
+
+int dw_hdmi_jack_detect(struct snd_soc_codec *codec_dai,
+			struct snd_soc_jack *jack);
+
+#endif
-- 
2.1.2


