Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbbASKmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:42:14 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:59147 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbbASKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:42:10 -0500
Message-ID: <1421664127.9655.53.camel@x220>
Subject: [PATCH 2/4] ASoC: samsung: Remove PCM support for WM8580 on SMDK
From: Paul Bolle <pebolle@tiscali.nl>
To: Kukjin Kim <kgene@kernel.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 11:42:07 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2015 10:42:08.0088 (UTC) FILETIME=[92B0AD80:01D033D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 28c8331d386a ("ARM: S5PV210: Remove support for board files")
removed the Kconfig symbols MACH_SMDKC110 and MACH_SMDKV210. As a result
the dependencies of SND_SOC_SMDK_WM8580_PCM can never be met. So remove
the unbuildable "SoC PCM Audio support for WM8580 on SMDK".

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Suggested by Arnd Bergmann (see https://lkml.org/lkml/2014/9/4/381 ).

Previously submitted in https://lkml.org/lkml/2014/9/18/147 , but again
in an awkward way. So this is a resend too.


 sound/soc/samsung/Kconfig          |   9 --
 sound/soc/samsung/Makefile         |   2 -
 sound/soc/samsung/smdk_wm8580pcm.c | 176 -------------------------------------
 3 files changed, 187 deletions(-)
 delete mode 100644 sound/soc/samsung/smdk_wm8580pcm.c

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index da6d0229cfa2..3be649098b30 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -153,15 +153,6 @@ config SND_SOC_SAMSUNG_SMDK_SPDIF
 	help
 	  Say Y if you want to add support for SoC S/PDIF audio on the SMDK.
 
-config SND_SOC_SMDK_WM8580_PCM
-	tristate "SoC PCM Audio support for WM8580 on SMDK"
-	depends on SND_SOC_SAMSUNG && (MACH_SMDKV210 || MACH_SMDKC110)
-	depends on REGMAP_I2C
-	select SND_SOC_WM8580
-	select SND_SAMSUNG_PCM
-	help
-	  Say Y if you want to add support for SoC audio on the SMDK.
-
 config SND_SOC_SMDK_WM8994_PCM
 	tristate "SoC PCM Audio support for WM8994 on SMDK"
 	depends on SND_SOC_SAMSUNG
diff --git a/sound/soc/samsung/Makefile b/sound/soc/samsung/Makefile
index 052fe71be518..2b32c371da55 100644
--- a/sound/soc/samsung/Makefile
+++ b/sound/soc/samsung/Makefile
@@ -36,7 +36,6 @@ snd-soc-snow-objs := snow.o
 snd-soc-smdk-wm9713-objs := smdk_wm9713.o
 snd-soc-s3c64xx-smartq-wm8987-objs := smartq_wm8987.o
 snd-soc-smdk-spdif-objs := smdk_spdif.o
-snd-soc-smdk-wm8580pcm-objs := smdk_wm8580pcm.o
 snd-soc-smdk-wm8994pcm-objs := smdk_wm8994pcm.o
 snd-soc-speyside-objs := speyside.o
 snd-soc-tobermory-objs := tobermory.o
@@ -62,7 +61,6 @@ obj-$(CONFIG_SND_SOC_SNOW) += snd-soc-snow.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK_WM9713) += snd-soc-smdk-wm9713.o
 obj-$(CONFIG_SND_SOC_SMARTQ) += snd-soc-s3c64xx-smartq-wm8987.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK_SPDIF) += snd-soc-smdk-spdif.o
-obj-$(CONFIG_SND_SOC_SMDK_WM8580_PCM) += snd-soc-smdk-wm8580pcm.o
 obj-$(CONFIG_SND_SOC_SMDK_WM8994_PCM) += snd-soc-smdk-wm8994pcm.o
 obj-$(CONFIG_SND_SOC_SPEYSIDE) += snd-soc-speyside.o
 obj-$(CONFIG_SND_SOC_TOBERMORY) += snd-soc-tobermory.o
diff --git a/sound/soc/samsung/smdk_wm8580pcm.c b/sound/soc/samsung/smdk_wm8580pcm.c
deleted file mode 100644
index 6deec5234c92..000000000000
--- a/sound/soc/samsung/smdk_wm8580pcm.c
+++ /dev/null
@@ -1,176 +0,0 @@
-/*
- *  sound/soc/samsung/smdk_wm8580pcm.c
- *
- *  Copyright (c) 2011 Samsung Electronics Co. Ltd
- *
- *  This program is free software; you can redistribute  it and/or  modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/module.h>
-#include <sound/soc.h>
-#include <sound/pcm_params.h>
-#include <sound/pcm.h>
-
-#include <asm/mach-types.h>
-
-#include "../codecs/wm8580.h"
-#include "dma.h"
-#include "pcm.h"
-
-/*
- * Board Settings:
- *  o '1' means 'ON'
- *  o '0' means 'OFF'
- *  o 'X' means 'Don't care'
- *
- * SMDK6410 Base B/D: CFG1-0000, CFG2-1111
- * SMDKC110, SMDKV210: CFGB11-100100, CFGB12-0000
- */
-
-#define SMDK_WM8580_EXT_OSC 12000000
-#define SMDK_WM8580_EXT_MCLK 4096000
-#define SMDK_WM8580_EXT_VOICE 2048000
-
-static unsigned long mclk_freq;
-static unsigned long xtal_freq;
-
-/*
- * If MCLK clock directly gets from XTAL, we don't have to use PLL
- * to make MCLK, but if XTAL clock source connects with other codec
- * pin (like XTI), we should have to set codec's PLL to make MCLK.
- * Because Samsung SoC does not support pcmcdclk output like I2S.
- */
-
-static int smdk_wm8580_pcm_hw_params(struct snd_pcm_substream *substream,
-			      struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
-	int rfs, ret;
-
-	switch (params_rate(params)) {
-	case 8000:
-		break;
-	default:
-		printk(KERN_ERR "%s:%d Sampling Rate %u not supported!\n",
-		__func__, __LINE__, params_rate(params));
-		return -EINVAL;
-	}
-
-	rfs = mclk_freq / params_rate(params) / 2;
-
-	if (mclk_freq == xtal_freq) {
-		ret = snd_soc_dai_set_sysclk(codec_dai, WM8580_CLKSRC_MCLK,
-						mclk_freq, SND_SOC_CLOCK_IN);
-		if (ret < 0)
-			return ret;
-
-		ret = snd_soc_dai_set_clkdiv(codec_dai, WM8580_MCLK,
-						WM8580_CLKSRC_MCLK);
-		if (ret < 0)
-			return ret;
-	} else {
-		ret = snd_soc_dai_set_sysclk(codec_dai, WM8580_CLKSRC_PLLA,
-						mclk_freq, SND_SOC_CLOCK_IN);
-		if (ret < 0)
-			return ret;
-
-		ret = snd_soc_dai_set_clkdiv(codec_dai, WM8580_MCLK,
-						WM8580_CLKSRC_PLLA);
-		if (ret < 0)
-			return ret;
-
-		ret = snd_soc_dai_set_pll(codec_dai, WM8580_PLLA, 0,
-						xtal_freq, mclk_freq);
-		if (ret < 0)
-			return ret;
-	}
-
-	/* Set PCM source clock on CPU */
-	ret = snd_soc_dai_set_sysclk(cpu_dai, S3C_PCM_CLKSRC_MUX,
-					mclk_freq, SND_SOC_CLOCK_IN);
-	if (ret < 0)
-		return ret;
-
-	/* Set SCLK_DIV for making bclk */
-	ret = snd_soc_dai_set_clkdiv(cpu_dai, S3C_PCM_SCLK_PER_FS, rfs);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static struct snd_soc_ops smdk_wm8580_pcm_ops = {
-	.hw_params = smdk_wm8580_pcm_hw_params,
-};
-
-#define SMDK_DAI_FMT (SND_SOC_DAIFMT_DSP_B | SND_SOC_DAIFMT_IB_NF | \
-	SND_SOC_DAIFMT_CBS_CFS)
-
-static struct snd_soc_dai_link smdk_dai[] = {
-	{
-		.name = "WM8580 PAIF PCM RX",
-		.stream_name = "Playback",
-		.cpu_dai_name = "samsung-pcm.0",
-		.codec_dai_name = "wm8580-hifi-playback",
-		.platform_name = "samsung-audio",
-		.codec_name = "wm8580.0-001b",
-		.dai_fmt = SMDK_DAI_FMT,
-		.ops = &smdk_wm8580_pcm_ops,
-	}, {
-		.name = "WM8580 PAIF PCM TX",
-		.stream_name = "Capture",
-		.cpu_dai_name = "samsung-pcm.0",
-		.codec_dai_name = "wm8580-hifi-capture",
-		.platform_name = "samsung-pcm.0",
-		.codec_name = "wm8580.0-001b",
-		.dai_fmt = SMDK_DAI_FMT,
-		.ops = &smdk_wm8580_pcm_ops,
-	},
-};
-
-static struct snd_soc_card smdk_pcm = {
-	.name = "SMDK-PCM",
-	.owner = THIS_MODULE,
-	.dai_link = smdk_dai,
-	.num_links = 2,
-};
-
-/*
- * After SMDKC110 Base Board's Rev is '0.1', 12MHz External OSC(X1)
- * is absent (or not connected), so we connect EXT_VOICE_CLK(OSC4),
- * 2.0484Mhz, directly with MCLK both Codec and SoC.
- */
-static int snd_smdk_probe(struct platform_device *pdev)
-{
-	int ret = 0;
-
-	xtal_freq = SMDK_WM8580_EXT_OSC;
-	mclk_freq = SMDK_WM8580_EXT_MCLK;
-
-	if (machine_is_smdkc110() || machine_is_smdkv210())
-		xtal_freq = mclk_freq = SMDK_WM8580_EXT_VOICE;
-
-	smdk_pcm.dev = &pdev->dev;
-	ret = devm_snd_soc_register_card(&pdev->dev, &smdk_pcm);
-	if (ret)
-		dev_err(&pdev->dev, "snd_soc_register_card failed %d\n", ret);
-
-	return ret;
-}
-
-static struct platform_driver snd_smdk_driver = {
-	.driver = {
-		.name = "samsung-smdk-pcm",
-	},
-	.probe = snd_smdk_probe,
-};
-
-module_platform_driver(snd_smdk_driver);
-
-MODULE_AUTHOR("Sangbeom Kim, <sbkim73@samsung.com>");
-MODULE_DESCRIPTION("ALSA SoC SMDK WM8580 for PCM");
-MODULE_LICENSE("GPL");
-- 
1.9.3




