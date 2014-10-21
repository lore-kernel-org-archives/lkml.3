Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaJUDa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:30:57 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:32969 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaJUDa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:30:56 -0400
From: Ben Zhang <benzh@chromium.org>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, flove@realtek.com,
        linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>
Subject: [PATCH] ASoC: rt5677: fix rt5677 spi driver build
Date: Mon, 20 Oct 2014 20:30:13 -0700
Message-Id: <1413862213-18449-1-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a separate module for rt5677 spi driver. Without
this patch, the build fails due to multiple defs of
'init_module' and 'cleanup_module'. module_spi_driver()
defines its own module, so it can't be part of the rt5677
module.

Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 sound/soc/codecs/Kconfig      | 4 ++++
 sound/soc/codecs/Makefile     | 4 +++-
 sound/soc/codecs/rt5677-spi.c | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 2c7482e..6f21a76 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -504,6 +504,10 @@ config SND_SOC_RT5670
 config SND_SOC_RT5677
 	tristate
 
+config SND_SOC_RT5677_SPI
+	tristate
+	default SND_SOC_RT5677
+
 #Freescale sgtl5000 codec
 config SND_SOC_SGTL5000
 	tristate "Freescale SGTL5000 CODEC"
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 4435f9f..3e57edc 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -79,7 +79,8 @@ snd-soc-rt5640-objs := rt5640.o
 snd-soc-rt5645-objs := rt5645.o
 snd-soc-rt5651-objs := rt5651.o
 snd-soc-rt5670-objs := rt5670.o
-snd-soc-rt5677-objs := rt5677.o rt5677-spi.o
+snd-soc-rt5677-objs := rt5677.o
+snd-soc-rt5677-spi-objs := rt5677-spi.o
 snd-soc-sgtl5000-objs := sgtl5000.o
 snd-soc-alc5623-objs := alc5623.o
 snd-soc-alc5632-objs := alc5632.o
@@ -256,6 +257,7 @@ obj-$(CONFIG_SND_SOC_RT5645)	+= snd-soc-rt5645.o
 obj-$(CONFIG_SND_SOC_RT5651)	+= snd-soc-rt5651.o
 obj-$(CONFIG_SND_SOC_RT5670)	+= snd-soc-rt5670.o
 obj-$(CONFIG_SND_SOC_RT5677)	+= snd-soc-rt5677.o
+obj-$(CONFIG_SND_SOC_RT5677_SPI)	+= snd-soc-rt5677-spi.o
 obj-$(CONFIG_SND_SOC_SGTL5000)  += snd-soc-sgtl5000.o
 obj-$(CONFIG_SND_SOC_SIGMADSP)	+= snd-soc-sigmadsp.o
 obj-$(CONFIG_SND_SOC_SIGMADSP_I2C)	+= snd-soc-sigmadsp-i2c.o
diff --git a/sound/soc/codecs/rt5677-spi.c b/sound/soc/codecs/rt5677-spi.c
index 11c38f3..ef6348c 100644
--- a/sound/soc/codecs/rt5677-spi.c
+++ b/sound/soc/codecs/rt5677-spi.c
@@ -52,6 +52,7 @@ int rt5677_spi_write(u8 *txbuf, size_t len)
 
 	return status;
 }
+EXPORT_SYMBOL_GPL(rt5677_spi_write);
 
 /**
  * rt5677_spi_burst_write - Write data to SPI by rt5677 dsp memory address.
@@ -107,6 +108,7 @@ int rt5677_spi_burst_write(u32 addr, const struct firmware *fw)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rt5677_spi_burst_write);
 
 static int rt5677_spi_probe(struct spi_device *spi)
 {
-- 
2.1.0.rc2.206.gedb03e5

