Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbbASKlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:41:46 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:51963 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbbASKlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:41:44 -0500
Message-ID: <1421664101.9655.52.camel@x220>
Subject: [PATCH 1/4] ASoC: samsung: Remove goni or aquila with the WM8994
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene@kernel.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 11:41:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2015 10:41:42.0056 (UTC) FILETIME=[832C8280:01D033D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 28c8331d386a ("ARM: S5PV210: Remove support for board files")
removed the Kconfig symbols MACH_GONI and MACH_AQUILA. As a result the
dependencies of SND_SOC_GONI_AQUILA_WM8994 can never be met. So remove
the unbuildable "SoC I2S Audio support for AQUILA/GONI - WM8994".

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Suggested by Arnd Bergmann (see https://lkml.org/lkml/2014/9/4/381 ).

Previously submitted in https://lkml.org/lkml/2014/9/18/128 , but in an
awkward way. So this is basically a resend.

 sound/soc/samsung/Kconfig       |  11 --
 sound/soc/samsung/Makefile      |   2 -
 sound/soc/samsung/goni_wm8994.c | 289 ----------------------------------------
 3 files changed, 302 deletions(-)
 delete mode 100644 sound/soc/samsung/goni_wm8994.c

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index fc67f97f19f6..da6d0229cfa2 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -146,17 +146,6 @@ config SND_SOC_SMARTQ
 	select SND_SAMSUNG_I2S
 	select SND_SOC_WM8750
 
-config SND_SOC_GONI_AQUILA_WM8994
-	tristate "SoC I2S Audio support for AQUILA/GONI - WM8994"
-	depends on SND_SOC_SAMSUNG && (MACH_GONI || MACH_AQUILA)
-	depends on I2C=y
-	select SND_SAMSUNG_I2S
-	select MFD_WM8994
-	select SND_SOC_WM8994
-	help
-	  Say Y if you want to add support for SoC audio on goni or aquila
-	  with the WM8994.
-
 config SND_SOC_SAMSUNG_SMDK_SPDIF
 	tristate "SoC S/PDIF Audio support for SMDK"
 	depends on SND_SOC_SAMSUNG
diff --git a/sound/soc/samsung/Makefile b/sound/soc/samsung/Makefile
index 31e3dba7e3b5..052fe71be518 100644
--- a/sound/soc/samsung/Makefile
+++ b/sound/soc/samsung/Makefile
@@ -35,7 +35,6 @@ snd-soc-smdk-wm8994-objs := smdk_wm8994.o
 snd-soc-snow-objs := snow.o
 snd-soc-smdk-wm9713-objs := smdk_wm9713.o
 snd-soc-s3c64xx-smartq-wm8987-objs := smartq_wm8987.o
-snd-soc-goni-wm8994-objs := goni_wm8994.o
 snd-soc-smdk-spdif-objs := smdk_spdif.o
 snd-soc-smdk-wm8580pcm-objs := smdk_wm8580pcm.o
 snd-soc-smdk-wm8994pcm-objs := smdk_wm8994pcm.o
@@ -63,7 +62,6 @@ obj-$(CONFIG_SND_SOC_SNOW) += snd-soc-snow.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK_WM9713) += snd-soc-smdk-wm9713.o
 obj-$(CONFIG_SND_SOC_SMARTQ) += snd-soc-s3c64xx-smartq-wm8987.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK_SPDIF) += snd-soc-smdk-spdif.o
-obj-$(CONFIG_SND_SOC_GONI_AQUILA_WM8994) += snd-soc-goni-wm8994.o
 obj-$(CONFIG_SND_SOC_SMDK_WM8580_PCM) += snd-soc-smdk-wm8580pcm.o
 obj-$(CONFIG_SND_SOC_SMDK_WM8994_PCM) += snd-soc-smdk-wm8994pcm.o
 obj-$(CONFIG_SND_SOC_SPEYSIDE) += snd-soc-speyside.o
diff --git a/sound/soc/samsung/goni_wm8994.c b/sound/soc/samsung/goni_wm8994.c
deleted file mode 100644
index fad56b9e7369..000000000000
--- a/sound/soc/samsung/goni_wm8994.c
+++ /dev/null
@@ -1,289 +0,0 @@
-/*
- * goni_wm8994.c
- *
- * Copyright (C) 2010 Samsung Electronics Co.Ltd
- * Author: Chanwoo Choi <cw00.choi@samsung.com>
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- */
-
-#include <linux/module.h>
-#include <sound/soc.h>
-#include <sound/jack.h>
-
-#include <asm/mach-types.h>
-#include <mach/gpio-samsung.h>
-
-#include "../codecs/wm8994.h"
-
-#define MACHINE_NAME	0
-#define CPU_VOICE_DAI	1
-
-static const char *aquila_str[] = {
-	[MACHINE_NAME] = "aquila",
-	[CPU_VOICE_DAI] = "aquila-voice-dai",
-};
-
-static struct snd_soc_card goni;
-static struct platform_device *goni_snd_device;
-
-/* 3.5 pie jack */
-static struct snd_soc_jack jack;
-
-/* 3.5 pie jack detection DAPM pins */
-static struct snd_soc_jack_pin jack_pins[] = {
-	{
-		.pin = "Headset Mic",
-		.mask = SND_JACK_MICROPHONE,
-	}, {
-		.pin = "Headset Stereophone",
-		.mask = SND_JACK_HEADPHONE | SND_JACK_MECHANICAL |
-			SND_JACK_AVOUT,
-	},
-};
-
-/* 3.5 pie jack detection gpios */
-static struct snd_soc_jack_gpio jack_gpios[] = {
-	{
-		.gpio = S5PV210_GPH0(6),
-		.name = "DET_3.5",
-		.report = SND_JACK_HEADSET | SND_JACK_MECHANICAL |
-			SND_JACK_AVOUT,
-		.debounce_time = 200,
-	},
-};
-
-static const struct snd_soc_dapm_widget goni_dapm_widgets[] = {
-	SND_SOC_DAPM_SPK("Ext Left Spk", NULL),
-	SND_SOC_DAPM_SPK("Ext Right Spk", NULL),
-	SND_SOC_DAPM_SPK("Ext Rcv", NULL),
-	SND_SOC_DAPM_HP("Headset Stereophone", NULL),
-	SND_SOC_DAPM_MIC("Headset Mic", NULL),
-	SND_SOC_DAPM_MIC("Main Mic", NULL),
-	SND_SOC_DAPM_MIC("2nd Mic", NULL),
-	SND_SOC_DAPM_LINE("Radio In", NULL),
-};
-
-static const struct snd_soc_dapm_route goni_dapm_routes[] = {
-	{"Ext Left Spk", NULL, "SPKOUTLP"},
-	{"Ext Left Spk", NULL, "SPKOUTLN"},
-
-	{"Ext Right Spk", NULL, "SPKOUTRP"},
-	{"Ext Right Spk", NULL, "SPKOUTRN"},
-
-	{"Ext Rcv", NULL, "HPOUT2N"},
-	{"Ext Rcv", NULL, "HPOUT2P"},
-
-	{"Headset Stereophone", NULL, "HPOUT1L"},
-	{"Headset Stereophone", NULL, "HPOUT1R"},
-
-	{"IN1RN", NULL, "Headset Mic"},
-	{"IN1RP", NULL, "Headset Mic"},
-
-	{"IN1RN", NULL, "2nd Mic"},
-	{"IN1RP", NULL, "2nd Mic"},
-
-	{"IN1LN", NULL, "Main Mic"},
-	{"IN1LP", NULL, "Main Mic"},
-
-	{"IN2LN", NULL, "Radio In"},
-	{"IN2RN", NULL, "Radio In"},
-};
-
-static int goni_wm8994_init(struct snd_soc_pcm_runtime *rtd)
-{
-	struct snd_soc_codec *codec = rtd->codec;
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int ret;
-
-	/* set endpoints to not connected */
-	snd_soc_dapm_nc_pin(dapm, "IN2LP:VXRN");
-	snd_soc_dapm_nc_pin(dapm, "IN2RP:VXRP");
-	snd_soc_dapm_nc_pin(dapm, "LINEOUT1N");
-	snd_soc_dapm_nc_pin(dapm, "LINEOUT1P");
-	snd_soc_dapm_nc_pin(dapm, "LINEOUT2N");
-	snd_soc_dapm_nc_pin(dapm, "LINEOUT2P");
-
-	if (machine_is_aquila()) {
-		snd_soc_dapm_nc_pin(dapm, "SPKOUTRN");
-		snd_soc_dapm_nc_pin(dapm, "SPKOUTRP");
-	}
-
-	/* Headset jack detection */
-	ret = snd_soc_jack_new(codec, "Headset Jack",
-			SND_JACK_HEADSET | SND_JACK_MECHANICAL | SND_JACK_AVOUT,
-			&jack);
-	if (ret)
-		return ret;
-
-	ret = snd_soc_jack_add_pins(&jack, ARRAY_SIZE(jack_pins), jack_pins);
-	if (ret)
-		return ret;
-
-	ret = snd_soc_jack_add_gpios(&jack, ARRAY_SIZE(jack_gpios), jack_gpios);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static int goni_hifi_hw_params(struct snd_pcm_substream *substream,
-		struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	unsigned int pll_out = 24000000;
-	int ret = 0;
-
-	/* set the codec FLL */
-	ret = snd_soc_dai_set_pll(codec_dai, WM8994_FLL1, 0, pll_out,
-			params_rate(params) * 256);
-	if (ret < 0)
-		return ret;
-
-	/* set the codec system clock */
-	ret = snd_soc_dai_set_sysclk(codec_dai, WM8994_SYSCLK_FLL1,
-			params_rate(params) * 256, SND_SOC_CLOCK_IN);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static struct snd_soc_ops goni_hifi_ops = {
-	.hw_params = goni_hifi_hw_params,
-};
-
-static int goni_voice_hw_params(struct snd_pcm_substream *substream,
-		struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	unsigned int pll_out = 24000000;
-	int ret = 0;
-
-	if (params_rate(params) != 8000)
-		return -EINVAL;
-
-	/* set the codec FLL */
-	ret = snd_soc_dai_set_pll(codec_dai, WM8994_FLL2, 0, pll_out,
-			params_rate(params) * 256);
-	if (ret < 0)
-		return ret;
-
-	/* set the codec system clock */
-	ret = snd_soc_dai_set_sysclk(codec_dai, WM8994_SYSCLK_FLL2,
-			params_rate(params) * 256, SND_SOC_CLOCK_IN);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static struct snd_soc_dai_driver voice_dai = {
-	.name = "goni-voice-dai",
-	.id = 0,
-	.playback = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_8000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE,},
-	.capture = {
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_8000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE,},
-};
-
-static const struct snd_soc_component_driver voice_component = {
-	.name		= "goni-voice",
-};
-
-static struct snd_soc_ops goni_voice_ops = {
-	.hw_params = goni_voice_hw_params,
-};
-
-static struct snd_soc_dai_link goni_dai[] = {
-{
-	.name = "WM8994",
-	.stream_name = "WM8994 HiFi",
-	.cpu_dai_name = "samsung-i2s.0",
-	.codec_dai_name = "wm8994-aif1",
-	.platform_name = "samsung-i2s.0",
-	.codec_name = "wm8994-codec.0-001a",
-	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
-		   SND_SOC_DAIFMT_CBM_CFM,
-	.init = goni_wm8994_init,
-	.ops = &goni_hifi_ops,
-}, {
-	.name = "WM8994 Voice",
-	.stream_name = "Voice",
-	.cpu_dai_name = "goni-voice-dai",
-	.codec_dai_name = "wm8994-aif2",
-	.codec_name = "wm8994-codec.0-001a",
-	.dai_fmt = SND_SOC_DAIFMT_LEFT_J | SND_SOC_DAIFMT_IB_IF |
-		   SND_SOC_DAIFMT_CBM_CFM,
-	.ops = &goni_voice_ops,
-},
-};
-
-static struct snd_soc_card goni = {
-	.name = "goni",
-	.owner = THIS_MODULE,
-	.dai_link = goni_dai,
-	.num_links = ARRAY_SIZE(goni_dai),
-
-	.dapm_widgets = goni_dapm_widgets,
-	.num_dapm_widgets = ARRAY_SIZE(goni_dapm_widgets),
-	.dapm_routes = goni_dapm_routes,
-	.num_dapm_routes = ARRAY_SIZE(goni_dapm_routes),
-};
-
-static int __init goni_init(void)
-{
-	int ret;
-
-	if (machine_is_aquila()) {
-		voice_dai.name = aquila_str[CPU_VOICE_DAI];
-		goni_dai[1].cpu_dai_name = aquila_str[CPU_VOICE_DAI];
-		goni.name = aquila_str[MACHINE_NAME];
-	} else if (!machine_is_goni())
-		return -ENODEV;
-
-	goni_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!goni_snd_device)
-		return -ENOMEM;
-
-	/* register voice DAI here */
-	ret = devm_snd_soc_register_component(&goni_snd_device->dev,
-			&voice_component, &voice_dai, 1);
-	if (ret) {
-		platform_device_put(goni_snd_device);
-		return ret;
-	}
-
-	platform_set_drvdata(goni_snd_device, &goni);
-	ret = platform_device_add(goni_snd_device);
-
-	if (ret)
-		platform_device_put(goni_snd_device);
-
-	return ret;
-}
-
-static void __exit goni_exit(void)
-{
-	platform_device_unregister(goni_snd_device);
-}
-
-module_init(goni_init);
-module_exit(goni_exit);
-
-/* Module information */
-MODULE_DESCRIPTION("ALSA SoC WM8994 GONI(S5PV210)");
-MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
-MODULE_LICENSE("GPL");
-- 
1.9.3




