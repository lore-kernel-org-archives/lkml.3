Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3LBJXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:23:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47993 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3LBJXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:23:36 -0500
Date: Mon, 2 Dec 2013 10:23:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        sre@ring0.de, sre@debian.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: linux-n900: minor coding style fixes
Message-ID: <20131202092333.GA19784@amd.pavel.ucw.cz>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
 <20131201200112.GE9743@amd.pavel.ucw.cz>
 <20131201202500.GA24067@amd.pavel.ucw.cz>
 <201312012136.39919@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312012136.39919@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace RX51 with N900 (RX-51) in user-visible places.

Fix comment style.

Simplify obvious code.

Add a fixme where error is not checked.

Signed-off-by: Pavel Machek <pavel@ucw.cz>


index e7604e5..64f7aca 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -642,7 +642,7 @@ static void cs_hsi_peek_on_data_complete(struct hsi_msg *msg)
 		cs_hsi_data_read_error(hi, msg);
 }
 
-/**
+/*
  * Read/write transaction is ongoing. Returns false if in
  * SSI_CHANNEL_STATE_POLL state.
  */
@@ -652,7 +652,7 @@ static inline int cs_state_xfer_active(unsigned int state)
 		(state & SSI_CHANNEL_STATE_READING);
 }
 
-/**
+/*
  * No pending read/writes
  */
 static inline int cs_state_idle(unsigned int state)
@@ -841,7 +841,7 @@ static int check_buf_params(struct cs_hsi_iface *hi,
 	return r;
 }
 
-/**
+/*
  * Block until pending data transfers have completed.
  */
 static int cs_hsi_data_sync(struct cs_hsi_iface *hi)
@@ -864,7 +864,7 @@ static int cs_hsi_data_sync(struct cs_hsi_iface *hi)
 			r = -ERESTARTSYS;
 			goto out;
 		}
-		/**
+		/*
 		 * prepare_to_wait must be called with hi->lock held
 		 * so that callbacks can check for waitqueue_active()
 		 */
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 4544798..31ead21 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -271,7 +271,7 @@ config VIDEO_AD5820
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	---help---
 	  This is a driver for the AD5820 camera lens voice coil.
-	  It is used for example in Nokia RX51.
+	  It is used for example in Nokia N900 (RX-51).
 
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index d2574b7..0f91673 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/ad5820.c
+ * drivers/media/i2c/ad5820.c
  *
  * AD5820 DAC driver for camera voice coil focus.
  *
@@ -101,9 +101,11 @@ static int ad5820_read(struct ad5820_device *coil)
 	return be16_to_cpu(data);
 }
 
-/* Calculate status word and write it to the device based on current
+/*
+ * Calculate status word and write it to the device based on current
  * values of V4L2 controls. It is assumed that the stored V4L2 control
- * values are properly limited and rounded. */
+ * values are properly limited and rounded.
+ */
 static int ad5820_update_hw(struct ad5820_device *coil)
 {
 	u16 status;
@@ -119,15 +121,15 @@ static int ad5820_update_hw(struct ad5820_device *coil)
 	return ad5820_write(coil, status);
 }
 
-/* --------------------------------------------------------------------------
+/*
  * Power handling
  */
-
 static int ad5820_power_off(struct ad5820_device *coil, int standby)
 {
 	int ret = 0;
 
-	/* Go to standby first as real power off my be denied by the hardware
+	/*
+	 * Go to standby first as real power off my be denied by the hardware
 	 * (single power line control for both coil and sensor).
 	 */
 	if (standby) {
@@ -172,10 +174,9 @@ fail:
 	return ret;
 }
 
-/* --------------------------------------------------------------------------
+/*
  * V4L2 controls
  */
-
 static int ad5820_set_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct ad5820_device *coil =
@@ -244,7 +245,8 @@ static int ad5820_init_controls(struct ad5820_device *coil)
 
 	v4l2_ctrl_handler_init(&coil->ctrls, ARRAY_SIZE(ad5820_ctrls) + 1);
 
-	/* V4L2_CID_FOCUS_ABSOLUTE
+	/*
+	 * V4L2_CID_FOCUS_ABSOLUTE
 	 *
 	 * Minimum current is 0 mA, maximum is 100 mA. Thus, 1 code is
 	 * equivalent to 100/1023 = 0.0978 mA. Nevertheless, we do not use [mA]
@@ -273,10 +275,9 @@ static int ad5820_init_controls(struct ad5820_device *coil)
 	return 0;
 }
 
-/* --------------------------------------------------------------------------
+/*
  * V4L2 subdev operations
  */
-
 static int
 ad5820_registered(struct v4l2_subdev *subdev)
 {
@@ -323,7 +324,8 @@ ad5820_set_power(struct v4l2_subdev *subdev, int on)
 
 	mutex_lock(&coil->power_lock);
 
-	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
+	/*
+	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
 	 * update the power state.
 	 */
 	if (coil->power_count == !on) {
@@ -365,7 +367,7 @@ static const struct v4l2_subdev_internal_ops ad5820_internal_ops = {
 	.close = ad5820_close,
 };
 
-/* --------------------------------------------------------------------------
+/*
  * I2C driver
  */
 #ifdef CONFIG_PM
diff --git a/drivers/media/i2c/smia/Kconfig b/drivers/media/i2c/smia/Kconfig
index ed089e4..13ca043 100644
--- a/drivers/media/i2c/smia/Kconfig
+++ b/drivers/media/i2c/smia/Kconfig
@@ -14,4 +14,4 @@ config VIDEO_ET8EK8
 	select VIDEO_SMIAREGS
 	---help---
 	  This is a driver for the Toshiba ET8EK8 5 MP camera sensor.
-	  It is used for example in Nokia RX51.
+	  It is used for example in Nokia N900 (RX-51).
diff --git a/drivers/media/i2c/smia/smiaregs.c b/drivers/media/i2c/smia/smiaregs.c
index f88ac38..50193da 100644
--- a/drivers/media/i2c/smia/smiaregs.c
+++ b/drivers/media/i2c/smia/smiaregs.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/smiaregs.c
+ * drivers/media/i2c/smia/smiaregs.c
  *
  * Copyright (C) 2008 Nokia Corporation
  *
@@ -31,11 +31,8 @@
 #include <media/smiaregs.h>
 
 /*
- *
  * Video control helpers
- *
  */
-
 int smia_ctrl_find(const struct v4l2_queryctrl *ctrls, size_t nctrls, int id)
 {
 	size_t i;
@@ -183,11 +180,8 @@ int smia_mode_g_ctrl(const __u32 *ctrls, size_t nctrls, struct v4l2_control *vc,
 EXPORT_SYMBOL_GPL(smia_mode_g_ctrl);
 
 /*
- *
  * Reglist helpers
- *
  */
-
 static int smia_reglist_cmp(const void *a, const void *b)
 {
 	const struct smia_reglist **list1 = (const struct smia_reglist **)a,
@@ -197,22 +191,22 @@ static int smia_reglist_cmp(const void *a, const void *b)
 	if ((*list1)->type == SMIA_REGLIST_MODE &&
 	    (*list2)->type != SMIA_REGLIST_MODE)
 		return -1;
-	else if ((*list1)->type != SMIA_REGLIST_MODE &&
-		 (*list2)->type == SMIA_REGLIST_MODE)
+	if ((*list1)->type != SMIA_REGLIST_MODE &&
+	    (*list2)->type == SMIA_REGLIST_MODE)
 		return 1;
 
 	/* Descending width. */
 	if ((*list1)->mode.window_width > (*list2)->mode.window_width)
 		return -1;
-	else if ((*list1)->mode.window_width < (*list2)->mode.window_width)
+	if ((*list1)->mode.window_width < (*list2)->mode.window_width)
 		return 1;
 
 	if ((*list1)->mode.window_height > (*list2)->mode.window_height)
 		return -1;
-	else if ((*list1)->mode.window_height < (*list2)->mode.window_height)
+	if ((*list1)->mode.window_height < (*list2)->mode.window_height)
 		return 1;
-	else
-		return 0;
+
+	return 0;
 }
 
 /*
diff --git a/drivers/media/radio/radio-bcm2048.c b/drivers/media/radio/radio-bcm2048.c
index d948cac..087e321 100644
--- a/drivers/media/radio/radio-bcm2048.c
+++ b/drivers/media/radio/radio-bcm2048.c
@@ -353,6 +353,9 @@ static struct region_info region_configs[] = {
 
 /*
  *	I2C Interface read / write
+ *
+ * Note: callers use | operation to combine errors from multiple
+ * calls. So this has to return just single error value.
  */
 static int bcm2048_send_command(struct bcm2048_device *bdev, unsigned int reg,
 					unsigned int value)
@@ -492,6 +495,8 @@ static int bcm2048_set_rds_no_lock(struct bcm2048_device *bdev, u8 rds_on)
 		memset(&bdev->rds_info, 0, sizeof(bdev->rds_info));
 	}
 
+	/* FIXME: if (err) return err ? */
+
 	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_RDS_SYSTEM,
 					bdev->cache_fm_rds_system);
 
@@ -633,10 +638,7 @@ static int bcm2048_get_fm_frequency(struct bcm2048_device *bdev)
 	if (err)
 		return err;
 
-	err = compose_u16(msb, lsb);
-	err += BCM2048_FREQUENCY_BASE;
-
-	return err;
+	return compose_u16(msb, lsb) + BCM2048_FREQUENCY_BASE;
 }
 
 static int bcm2048_set_fm_af_frequency(struct bcm2048_device *bdev,
@@ -678,10 +680,7 @@ static int bcm2048_get_fm_af_frequency(struct bcm2048_device *bdev)
 	if (err)
 		return err;
 
-	err = compose_u16(msb, lsb);
-	err += BCM2048_FREQUENCY_BASE;
-
-	return err;
+	return compose_u16(msb, lsb) + BCM2048_FREQUENCY_BASE;
 }
 
 static int bcm2048_set_fm_deemphasis(struct bcm2048_device *bdev, int d)
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index a4b4300..66e7fed 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -527,7 +527,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		/* Set the DSP clock rate */
 		(void)dev_get_symbol(dev_context->dev_obj,
 				     "_BRIDGEINIT_DSP_FREQ", &ul_dsp_clk_addr);
-		/*Set Autoidle Mode for IVA2 PLL */
+		/* Set Autoidle Mode for IVA2 PLL */
 		(*pdata->dsp_cm_write)(1,
 				OMAP3430_IVA2_MOD, OMAP3430_CM_AUTOIDLE_PLL);
 
diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index a8319e6..45ea88a 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -25,14 +25,14 @@ config SND_OMAP_SOC_N810
 	  Say Y if you want to add support for SoC audio on Nokia N810.
 
 config SND_OMAP_SOC_RX51
-	tristate "SoC Audio support for Nokia RX-51"
+	tristate "SoC Audio support for Nokia N900 (RX-51)"
 	depends on SND_OMAP_SOC && I2C && ARM && (MACH_NOKIA_RX51 || COMPILE_TEST)
 	select SND_OMAP_SOC_MCBSP
 	select SND_SOC_TLV320AIC3X
 	select SND_SOC_TPA6130A2
 	help
-	  Say Y if you want to add support for SoC audio on Nokia RX-51
-	  hardware. This is also known as Nokia N900 product.
+	  Say Y if you want to add support for SoC audio on Nokia N900
+	  (RX-51) hardware.
 
 config SND_OMAP_SOC_AMS_DELTA
 	tristate "SoC Audio support for Amstrad E3 (Delta) videophone"

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
