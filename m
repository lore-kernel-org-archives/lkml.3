Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaLFCZC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:25:02 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56061 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751051AbaLFCZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:25:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Timur Tabi <timur@tabi.org>, Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Li.Xiubo@freescale.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] sound / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Sat, 06 Dec 2014 03:46:27 +0100
Message-ID: <2064254.7lXiTpmK64@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
depending on CONFIG_PM_RUNTIME may now be changed to depend on
CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under sound/.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 sound/pci/hda/hda_controller.c |    2 +-
 sound/pci/hda/hda_intel.c      |    5 +----
 sound/soc/codecs/cs35l32.c     |    2 +-
 sound/soc/codecs/cs42xx8.c     |    2 +-
 sound/soc/codecs/max98090.c    |    2 +-
 sound/soc/codecs/pcm512x.c     |    2 +-
 sound/soc/codecs/tas2552.c     |    4 ++--
 sound/soc/codecs/wm2200.c      |    2 +-
 sound/soc/codecs/wm5100.c      |    2 +-
 sound/soc/codecs/wm8962.c      |    2 +-
 sound/soc/fsl/fsl_asrc.c       |    4 ++--
 sound/soc/samsung/i2s.c        |    4 ++--
 12 files changed, 15 insertions(+), 18 deletions(-)

Index: linux-pm/sound/pci/hda/hda_controller.c
===================================================================
--- linux-pm.orig/sound/pci/hda/hda_controller.c
+++ linux-pm/sound/pci/hda/hda_controller.c
@@ -1676,7 +1676,7 @@ irqreturn_t azx_interrupt(int irq, void
 	u8 sd_status;
 	int i;
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	if (chip->driver_caps & AZX_DCAPS_PM_RUNTIME)
 		if (!pm_runtime_active(chip->card->dev))
 			return IRQ_NONE;
Index: linux-pm/sound/pci/hda/hda_intel.c
===================================================================
--- linux-pm.orig/sound/pci/hda/hda_intel.c
+++ linux-pm/sound/pci/hda/hda_intel.c
@@ -856,7 +856,7 @@ static int azx_resume(struct device *dev
 }
 #endif /* CONFIG_PM_SLEEP || SUPPORT_VGA_SWITCHEROO */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int azx_runtime_suspend(struct device *dev)
 {
 	struct snd_card *card = dev_get_drvdata(dev);
@@ -954,9 +954,6 @@ static int azx_runtime_idle(struct devic
 	return 0;
 }
 
-#endif /* CONFIG_PM_RUNTIME */
-
-#ifdef CONFIG_PM
 static const struct dev_pm_ops azx_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(azx_suspend, azx_resume)
 	SET_RUNTIME_PM_OPS(azx_runtime_suspend, azx_runtime_resume, azx_runtime_idle)
Index: linux-pm/sound/soc/codecs/cs35l32.c
===================================================================
--- linux-pm.orig/sound/soc/codecs/cs35l32.c
+++ linux-pm/sound/soc/codecs/cs35l32.c
@@ -550,7 +550,7 @@ static int cs35l32_i2c_remove(struct i2c
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int cs35l32_runtime_suspend(struct device *dev)
 {
 	struct cs35l32_private *cs35l32 = dev_get_drvdata(dev);
Index: linux-pm/sound/soc/codecs/cs42xx8.c
===================================================================
--- linux-pm.orig/sound/soc/codecs/cs42xx8.c
+++ linux-pm/sound/soc/codecs/cs42xx8.c
@@ -537,7 +537,7 @@ err_enable:
 }
 EXPORT_SYMBOL_GPL(cs42xx8_probe);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int cs42xx8_runtime_resume(struct device *dev)
 {
 	struct cs42xx8_priv *cs42xx8 = dev_get_drvdata(dev);
Index: linux-pm/sound/soc/codecs/max98090.c
===================================================================
--- linux-pm.orig/sound/soc/codecs/max98090.c
+++ linux-pm/sound/soc/codecs/max98090.c
@@ -2492,7 +2492,7 @@ static int max98090_i2c_remove(struct i2
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int max98090_runtime_resume(struct device *dev)
 {
 	struct max98090_priv *max98090 = dev_get_drvdata(dev);
Index: linux-pm/sound/soc/codecs/pcm512x.c
===================================================================
--- linux-pm.orig/sound/soc/codecs/pcm512x.c
+++ linux-pm/sound/soc/codecs/pcm512x.c
@@ -517,7 +517,7 @@ void pcm512x_remove(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(pcm512x_remove);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int pcm512x_suspend(struct device *dev)
 {
 	struct pcm512x_priv *pcm512x = dev_get_drvdata(dev);
Index: linux-pm/sound/soc/codecs/tas2552.c
===================================================================
--- linux-pm.orig/sound/soc/codecs/tas2552.c
+++ linux-pm/sound/soc/codecs/tas2552.c
@@ -115,7 +115,7 @@ static const struct snd_soc_dapm_route t
 	{"ClassD", NULL, "PLL"},
 };
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
 {
 	u8 cfg1_reg;
@@ -264,7 +264,7 @@ static int tas2552_mute(struct snd_soc_d
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int tas2552_runtime_suspend(struct device *dev)
 {
 	struct tas2552_data *tas2552 = dev_get_drvdata(dev);
Index: linux-pm/sound/soc/codecs/wm2200.c
===================================================================
--- linux-pm.orig/sound/soc/codecs/wm2200.c
+++ linux-pm/sound/soc/codecs/wm2200.c
@@ -2440,7 +2440,7 @@ static int wm2200_i2c_remove(struct i2c_
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int wm2200_runtime_suspend(struct device *dev)
 {
 	struct wm2200_priv *wm2200 = dev_get_drvdata(dev);
Index: linux-pm/sound/soc/codecs/wm5100.c
===================================================================
--- linux-pm.orig/sound/soc/codecs/wm5100.c
+++ linux-pm/sound/soc/codecs/wm5100.c
@@ -2664,7 +2664,7 @@ static int wm5100_i2c_remove(struct i2c_
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int wm5100_runtime_suspend(struct device *dev)
 {
 	struct wm5100_priv *wm5100 = dev_get_drvdata(dev);
Index: linux-pm/sound/soc/codecs/wm8962.c
===================================================================
--- linux-pm.orig/sound/soc/codecs/wm8962.c
+++ linux-pm/sound/soc/codecs/wm8962.c
@@ -3782,7 +3782,7 @@ static int wm8962_i2c_remove(struct i2c_
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int wm8962_runtime_resume(struct device *dev)
 {
 	struct wm8962_priv *wm8962 = dev_get_drvdata(dev);
Index: linux-pm/sound/soc/fsl/fsl_asrc.c
===================================================================
--- linux-pm.orig/sound/soc/fsl/fsl_asrc.c
+++ linux-pm/sound/soc/fsl/fsl_asrc.c
@@ -928,7 +928,7 @@ static int fsl_asrc_probe(struct platfor
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int fsl_asrc_runtime_resume(struct device *dev)
 {
 	struct fsl_asrc *asrc_priv = dev_get_drvdata(dev);
@@ -954,7 +954,7 @@ static int fsl_asrc_runtime_suspend(stru
 
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_SLEEP
 static int fsl_asrc_suspend(struct device *dev)
Index: linux-pm/sound/soc/samsung/i2s.c
===================================================================
--- linux-pm.orig/sound/soc/samsung/i2s.c
+++ linux-pm/sound/soc/samsung/i2s.c
@@ -1113,7 +1113,7 @@ static inline const struct samsung_i2s_d
 				platform_get_device_id(pdev)->driver_data;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int i2s_runtime_suspend(struct device *dev)
 {
 	struct i2s_dai *i2s = dev_get_drvdata(dev);
@@ -1131,7 +1131,7 @@ static int i2s_runtime_resume(struct dev
 
 	return 0;
 }
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static int samsung_i2s_probe(struct platform_device *pdev)
 {

