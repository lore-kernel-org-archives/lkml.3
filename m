Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3ENPHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:07:25 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:50572 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757891Ab3ENPHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:07:23 -0400
Message-ID: <1368544041.1350.111.camel@x61.thuisdomein>
Subject: [PATCH] ASoC: remove saarb and tavorevb3 machine drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 14 May 2013 17:07:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2013 15:07:21.0763 (UTC) FILETIME=[BBEE8730:01CE50B4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for PXA95x was removed in v3.8. This means that the Kconfig
symbols MACH_SAARB and MACH_TAVOREVB3 are no longer available. This
leaves the SoC Audio support for Marvell Saarb and Marvell Tavor EVB3
unbuildable. Remove these drivers too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Basically untested.

1) To be specific: it was commit 49ea7fc094 ("ARM: pxa: remove pxa95x
support") that removed MACH_SAARB and MACH_TAVOREVB3.

 sound/soc/pxa/Kconfig     |  20 -----
 sound/soc/pxa/Makefile    |   4 -
 sound/soc/pxa/saarb.c     | 190 ----------------------------------------------
 sound/soc/pxa/tavorevb3.c | 189 ---------------------------------------------
 4 files changed, 403 deletions(-)
 delete mode 100644 sound/soc/pxa/saarb.c
 delete mode 100644 sound/soc/pxa/tavorevb3.c

diff --git a/sound/soc/pxa/Kconfig b/sound/soc/pxa/Kconfig
index 4d2e46f..b358094 100644
--- a/sound/soc/pxa/Kconfig
+++ b/sound/soc/pxa/Kconfig
@@ -130,26 +130,6 @@ config SND_PXA2XX_SOC_PALM27X
 	  Say Y if you want to add support for SoC audio on
 	  Palm T|X, T5, E2 or LifeDrive handheld computer.
 
-config SND_SOC_SAARB
-	tristate "SoC Audio support for Marvell Saarb"
-	depends on SND_PXA2XX_SOC && MACH_SAARB
-	select MFD_88PM860X
-	select SND_PXA_SOC_SSP
-	select SND_SOC_88PM860X
-	help
-	  Say Y if you want to add support for SoC audio on the
-	  Marvell Saarb reference platform.
-
-config SND_SOC_TAVOREVB3
-	tristate "SoC Audio support for Marvell Tavor EVB3"
-	depends on SND_PXA2XX_SOC && MACH_TAVOREVB3
-	select MFD_88PM860X
-	select SND_PXA_SOC_SSP
-	select SND_SOC_88PM860X
-	help
-	  Say Y if you want to add support for SoC audio on the
-	  Marvell Saarb reference platform.
-
 config SND_PXA910_SOC
 	tristate "SoC Audio for Marvell PXA910 chip"
 	depends on ARCH_MMP && SND
diff --git a/sound/soc/pxa/Makefile b/sound/soc/pxa/Makefile
index d8a265d..2cff67b 100644
--- a/sound/soc/pxa/Makefile
+++ b/sound/soc/pxa/Makefile
@@ -23,8 +23,6 @@ snd-soc-e800-objs := e800_wm9712.o
 snd-soc-spitz-objs := spitz.o
 snd-soc-em-x270-objs := em-x270.o
 snd-soc-palm27x-objs := palm27x.o
-snd-soc-saarb-objs := saarb.o
-snd-soc-tavorevb3-objs := tavorevb3.o
 snd-soc-zylonite-objs := zylonite.o
 snd-soc-hx4700-objs := hx4700.o
 snd-soc-magician-objs := magician.o
@@ -48,8 +46,6 @@ obj-$(CONFIG_SND_PXA2XX_SOC_HX4700) += snd-soc-hx4700.o
 obj-$(CONFIG_SND_PXA2XX_SOC_MAGICIAN) += snd-soc-magician.o
 obj-$(CONFIG_SND_PXA2XX_SOC_MIOA701) += snd-soc-mioa701.o
 obj-$(CONFIG_SND_PXA2XX_SOC_Z2) += snd-soc-z2.o
-obj-$(CONFIG_SND_SOC_SAARB) += snd-soc-saarb.o
-obj-$(CONFIG_SND_SOC_TAVOREVB3) += snd-soc-tavorevb3.o
 obj-$(CONFIG_SND_SOC_ZYLONITE) += snd-soc-zylonite.o
 obj-$(CONFIG_SND_PXA2XX_SOC_IMOTE2) += snd-soc-imote2.o
 obj-$(CONFIG_SND_SOC_RAUMFELD) += snd-soc-raumfeld.o
diff --git a/sound/soc/pxa/saarb.c b/sound/soc/pxa/saarb.c
deleted file mode 100644
index c34146b..0000000
--- a/sound/soc/pxa/saarb.c
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * saarb.c -- SoC audio for saarb
- *
- * Copyright (C) 2010 Marvell International Ltd.
- * 	Haojian Zhuang <haojian.zhuang@marvell.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/device.h>
-#include <linux/clk.h>
-#include <linux/i2c.h>
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-#include <sound/soc.h>
-#include <sound/jack.h>
-
-#include <asm/mach-types.h>
-
-#include "../codecs/88pm860x-codec.h"
-#include "pxa-ssp.h"
-
-static int saarb_pm860x_init(struct snd_soc_pcm_runtime *rtd);
-
-static struct platform_device *saarb_snd_device;
-
-static struct snd_soc_jack hs_jack, mic_jack;
-
-static struct snd_soc_jack_pin hs_jack_pins[] = {
-	{ .pin = "Headset Stereophone",	.mask = SND_JACK_HEADPHONE, },
-};
-
-static struct snd_soc_jack_pin mic_jack_pins[] = {
-	{ .pin = "Headset Mic 2",	.mask = SND_JACK_MICROPHONE, },
-};
-
-/* saarb machine dapm widgets */
-static const struct snd_soc_dapm_widget saarb_dapm_widgets[] = {
-	SND_SOC_DAPM_HP("Headphone Stereophone", NULL),
-	SND_SOC_DAPM_LINE("Lineout Out 1", NULL),
-	SND_SOC_DAPM_LINE("Lineout Out 2", NULL),
-	SND_SOC_DAPM_SPK("Ext Speaker", NULL),
-	SND_SOC_DAPM_MIC("Ext Mic 1", NULL),
-	SND_SOC_DAPM_MIC("Headset Mic", NULL),
-	SND_SOC_DAPM_MIC("Ext Mic 3", NULL),
-};
-
-/* saarb machine audio map */
-static const struct snd_soc_dapm_route saarb_audio_map[] = {
-	{"Headset Stereophone", NULL, "HS1"},
-	{"Headset Stereophone", NULL, "HS2"},
-
-	{"Ext Speaker", NULL, "LSP"},
-	{"Ext Speaker", NULL, "LSN"},
-
-	{"Lineout Out 1", NULL, "LINEOUT1"},
-	{"Lineout Out 2", NULL, "LINEOUT2"},
-
-	{"MIC1P", NULL, "Mic1 Bias"},
-	{"MIC1N", NULL, "Mic1 Bias"},
-	{"Mic1 Bias", NULL, "Ext Mic 1"},
-
-	{"MIC2P", NULL, "Mic1 Bias"},
-	{"MIC2N", NULL, "Mic1 Bias"},
-	{"Mic1 Bias", NULL, "Headset Mic 2"},
-
-	{"MIC3P", NULL, "Mic3 Bias"},
-	{"MIC3N", NULL, "Mic3 Bias"},
-	{"Mic3 Bias", NULL, "Ext Mic 3"},
-};
-
-static int saarb_i2s_hw_params(struct snd_pcm_substream *substream,
-				struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
-	int width = snd_pcm_format_physical_width(params_format(params));
-	int ret;
-
-	ret = snd_soc_dai_set_sysclk(cpu_dai, PXA_SSP_CLK_NET_PLL, 0,
-				     PM860X_CLK_DIR_OUT);
-	if (ret < 0)
-		return ret;
-
-	ret = snd_soc_dai_set_sysclk(codec_dai, 0, 0, PM860X_CLK_DIR_OUT);
-	if (ret < 0)
-		return ret;
-
-	ret = snd_soc_dai_set_tdm_slot(cpu_dai, 3, 3, 2, width);
-
-	return ret;
-}
-
-static struct snd_soc_ops saarb_i2s_ops = {
-	.hw_params	= saarb_i2s_hw_params,
-};
-
-static struct snd_soc_dai_link saarb_dai[] = {
-	{
-		.name		= "88PM860x I2S",
-		.stream_name	= "I2S Audio",
-		.cpu_dai_name	= "pxa-ssp-dai.1",
-		.codec_dai_name	= "88pm860x-i2s",
-		.platform_name	= "pxa-pcm-audio",
-		.codec_name	= "88pm860x-codec",
-		.init		= saarb_pm860x_init,
-		.dai_fmt	= SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
-				  SND_SOC_DAIFMT_CBM_CFM,
-		.ops		= &saarb_i2s_ops,
-	},
-};
-
-static struct snd_soc_card snd_soc_card_saarb = {
-	.name = "Saarb",
-	.owner = THIS_MODULE,
-	.dai_link = saarb_dai,
-	.num_links = ARRAY_SIZE(saarb_dai),
-
-	.dapm_widgets = saarb_dapm_widgets,
-	.num_dapm_widgets = ARRAY_SIZE(saarb_dapm_widgets),
-	.dapm_routes = saarb_audio_map,
-	.num_dapm_routes = ARRAY_SIZE(saarb_audio_map),
-};
-
-static int saarb_pm860x_init(struct snd_soc_pcm_runtime *rtd)
-{
-	struct snd_soc_codec *codec = rtd->codec;
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
-
-	/* connected pins */
-	snd_soc_dapm_enable_pin(dapm, "Ext Speaker");
-	snd_soc_dapm_enable_pin(dapm, "Ext Mic 1");
-	snd_soc_dapm_enable_pin(dapm, "Ext Mic 3");
-	snd_soc_dapm_disable_pin(dapm, "Headset Mic 2");
-	snd_soc_dapm_disable_pin(dapm, "Headset Stereophone");
-
-	/* Headset jack detection */
-	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE
-			| SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2,
-			&hs_jack);
-	snd_soc_jack_add_pins(&hs_jack, ARRAY_SIZE(hs_jack_pins),
-			      hs_jack_pins);
-	snd_soc_jack_new(codec, "Microphone Jack", SND_JACK_MICROPHONE,
-			 &mic_jack);
-	snd_soc_jack_add_pins(&mic_jack, ARRAY_SIZE(mic_jack_pins),
-			      mic_jack_pins);
-
-	/* headphone, microphone detection & headset short detection */
-	pm860x_hs_jack_detect(codec, &hs_jack, SND_JACK_HEADPHONE,
-			      SND_JACK_BTN_0, SND_JACK_BTN_1, SND_JACK_BTN_2);
-	pm860x_mic_jack_detect(codec, &hs_jack, SND_JACK_MICROPHONE);
-	return 0;
-}
-
-static int __init saarb_init(void)
-{
-	int ret;
-
-	if (!machine_is_saarb())
-		return -ENODEV;
-	saarb_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!saarb_snd_device)
-		return -ENOMEM;
-
-	platform_set_drvdata(saarb_snd_device, &snd_soc_card_saarb);
-
-	ret = platform_device_add(saarb_snd_device);
-	if (ret)
-		platform_device_put(saarb_snd_device);
-
-	return ret;
-}
-
-static void __exit saarb_exit(void)
-{
-	platform_device_unregister(saarb_snd_device);
-}
-
-module_init(saarb_init);
-module_exit(saarb_exit);
-
-MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
-MODULE_DESCRIPTION("ALSA SoC 88PM860x Saarb");
-MODULE_LICENSE("GPL");
diff --git a/sound/soc/pxa/tavorevb3.c b/sound/soc/pxa/tavorevb3.c
deleted file mode 100644
index 8b5ab8f..0000000
--- a/sound/soc/pxa/tavorevb3.c
+++ /dev/null
@@ -1,189 +0,0 @@
-/*
- * tavorevb3.c -- SoC audio for Tavor EVB3
- *
- * Copyright (C) 2010 Marvell International Ltd.
- * 	Haojian Zhuang <haojian.zhuang@marvell.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/device.h>
-#include <linux/clk.h>
-#include <linux/i2c.h>
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-#include <sound/soc.h>
-#include <sound/jack.h>
-
-#include <asm/mach-types.h>
-
-#include "../codecs/88pm860x-codec.h"
-#include "pxa-ssp.h"
-
-static int evb3_pm860x_init(struct snd_soc_pcm_runtime *rtd);
-
-static struct platform_device *evb3_snd_device;
-
-static struct snd_soc_jack hs_jack, mic_jack;
-
-static struct snd_soc_jack_pin hs_jack_pins[] = {
-	{ .pin = "Headset Stereophone",	.mask = SND_JACK_HEADPHONE, },
-};
-
-static struct snd_soc_jack_pin mic_jack_pins[] = {
-	{ .pin = "Headset Mic 2",	.mask = SND_JACK_MICROPHONE, },
-};
-
-/* tavorevb3 machine dapm widgets */
-static const struct snd_soc_dapm_widget evb3_dapm_widgets[] = {
-	SND_SOC_DAPM_HP("Headset Stereophone", NULL),
-	SND_SOC_DAPM_LINE("Lineout Out 1", NULL),
-	SND_SOC_DAPM_LINE("Lineout Out 2", NULL),
-	SND_SOC_DAPM_SPK("Ext Speaker", NULL),
-	SND_SOC_DAPM_MIC("Ext Mic 1", NULL),
-	SND_SOC_DAPM_MIC("Headset Mic 2", NULL),
-	SND_SOC_DAPM_MIC("Ext Mic 3", NULL),
-};
-
-/* tavorevb3 machine audio map */
-static const struct snd_soc_dapm_route evb3_audio_map[] = {
-	{"Headset Stereophone", NULL, "HS1"},
-	{"Headset Stereophone", NULL, "HS2"},
-
-	{"Ext Speaker", NULL, "LSP"},
-	{"Ext Speaker", NULL, "LSN"},
-
-	{"Lineout Out 1", NULL, "LINEOUT1"},
-	{"Lineout Out 2", NULL, "LINEOUT2"},
-
-	{"MIC1P", NULL, "Mic1 Bias"},
-	{"MIC1N", NULL, "Mic1 Bias"},
-	{"Mic1 Bias", NULL, "Ext Mic 1"},
-
-	{"MIC2P", NULL, "Mic1 Bias"},
-	{"MIC2N", NULL, "Mic1 Bias"},
-	{"Mic1 Bias", NULL, "Headset Mic 2"},
-
-	{"MIC3P", NULL, "Mic3 Bias"},
-	{"MIC3N", NULL, "Mic3 Bias"},
-	{"Mic3 Bias", NULL, "Ext Mic 3"},
-};
-
-static int evb3_i2s_hw_params(struct snd_pcm_substream *substream,
-			      struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
-	int width = snd_pcm_format_physical_width(params_format(params));
-	int ret;
-
-	ret = snd_soc_dai_set_sysclk(cpu_dai, PXA_SSP_CLK_NET_PLL, 0,
-				     PM860X_CLK_DIR_OUT);
-	if (ret < 0)
-		return ret;
-
-	ret = snd_soc_dai_set_sysclk(codec_dai, 0, 0, PM860X_CLK_DIR_OUT);
-	if (ret < 0)
-		return ret;
-
-	ret = snd_soc_dai_set_tdm_slot(cpu_dai, 3, 3, 2, width);
-	return ret;
-}
-
-static struct snd_soc_ops evb3_i2s_ops = {
-	.hw_params	= evb3_i2s_hw_params,
-};
-
-static struct snd_soc_dai_link evb3_dai[] = {
-	{
-		.name		= "88PM860x I2S",
-		.stream_name	= "I2S Audio",
-		.cpu_dai_name	= "pxa-ssp-dai.1",
-		.codec_dai_name	= "88pm860x-i2s",
-		.platform_name	= "pxa-pcm-audio",
-		.codec_name	= "88pm860x-codec",
-		.init		= evb3_pm860x_init,
-		.dai_fmt	= SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
-				  SND_SOC_DAIFMT_CBM_CFM,
-		.ops		= &evb3_i2s_ops,
-	},
-};
-
-static struct snd_soc_card snd_soc_card_evb3 = {
-	.name = "Tavor EVB3",
-	.owner = THIS_MODULE,
-	.dai_link = evb3_dai,
-	.num_links = ARRAY_SIZE(evb3_dai),
-
-	.dapm_widgets = evb3_dapm_widgets,
-	.num_dapm_widgets = ARRAY_SIZE(evb3_dapm_widgets),
-	.dapm_routes = evb3_audio_map,
-	.num_dapm_routes = ARRAY_SIZE(evb3_audio_map),
-};
-
-static int evb3_pm860x_init(struct snd_soc_pcm_runtime *rtd)
-{
-	struct snd_soc_codec *codec = rtd->codec;
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
-
-	/* connected pins */
-	snd_soc_dapm_enable_pin(dapm, "Ext Speaker");
-	snd_soc_dapm_enable_pin(dapm, "Ext Mic 1");
-	snd_soc_dapm_enable_pin(dapm, "Ext Mic 3");
-	snd_soc_dapm_disable_pin(dapm, "Headset Mic 2");
-	snd_soc_dapm_disable_pin(dapm, "Headset Stereophone");
-
-	/* Headset jack detection */
-	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE
-			| SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2,
-			&hs_jack);
-	snd_soc_jack_add_pins(&hs_jack, ARRAY_SIZE(hs_jack_pins),
-			      hs_jack_pins);
-	snd_soc_jack_new(codec, "Microphone Jack", SND_JACK_MICROPHONE,
-			 &mic_jack);
-	snd_soc_jack_add_pins(&mic_jack, ARRAY_SIZE(mic_jack_pins),
-			      mic_jack_pins);
-
-	/* headphone, microphone detection & headset short detection */
-	pm860x_hs_jack_detect(codec, &hs_jack, SND_JACK_HEADPHONE,
-			      SND_JACK_BTN_0, SND_JACK_BTN_1, SND_JACK_BTN_2);
-	pm860x_mic_jack_detect(codec, &hs_jack, SND_JACK_MICROPHONE);
-	return 0;
-}
-
-static int __init tavorevb3_init(void)
-{
-	int ret;
-
-	if (!machine_is_tavorevb3())
-		return -ENODEV;
-	evb3_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!evb3_snd_device)
-		return -ENOMEM;
-
-	platform_set_drvdata(evb3_snd_device, &snd_soc_card_evb3);
-
-	ret = platform_device_add(evb3_snd_device);
-	if (ret)
-		platform_device_put(evb3_snd_device);
-
-	return ret;
-}
-
-static void __exit tavorevb3_exit(void)
-{
-	platform_device_unregister(evb3_snd_device);
-}
-
-module_init(tavorevb3_init);
-module_exit(tavorevb3_exit);
-
-MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
-MODULE_DESCRIPTION("ALSA SoC 88PM860x Tavor EVB3");
-MODULE_LICENSE("GPL");
-- 
1.7.11.7

