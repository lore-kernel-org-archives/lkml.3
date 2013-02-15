Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161955Ab3BONAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:00:32 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:49200 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161358Ab3BOM6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:22 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        =?UTF-8?q?Mattias=20Thor=C3=A9n?= <mattias.thoren@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/35] mfd: ab8500-debugfs: Change AB8500 debug permissions
Date: Fri, 15 Feb 2013 12:57:01 +0000
Message-Id: <1360933026-30325-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Thorén <mattias.thoren@stericsson.com>

Enable group write permissions for ab8500 debug MFD driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c |   56 +++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index ae8660a..148cbd2 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -2622,22 +2622,22 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("register-bank", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("register-bank", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_dir, &plf->dev, &ab8500_bank_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("register-address", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("register-address", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_dir, &plf->dev, &ab8500_address_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("register-value", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("register-value", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_dir, &plf->dev, &ab8500_val_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("irq-subscribe", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("irq-subscribe", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_dir, &plf->dev, &ab8500_subscribe_fops);
 	if (!file)
 		goto err;
@@ -2661,97 +2661,97 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("irq-unsubscribe", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("irq-unsubscribe", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_dir, &plf->dev, &ab8500_unsubscribe_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("hwreg", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("hwreg", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_dir, &plf->dev, &ab8500_hwreg_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("all-modem-registers", (S_IRUGO | S_IWUGO),
+	file = debugfs_create_file("all-modem-registers", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_dir, &plf->dev, &ab8500_modem_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("bat_ctrl", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("bat_ctrl", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_bat_ctrl_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("btemp_ball", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("btemp_ball", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_btemp_ball_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("main_charger_v", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("main_charger_v", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_main_charger_v_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("acc_detect1", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("acc_detect1", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_acc_detect1_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("acc_detect2", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("acc_detect2", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_acc_detect2_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("adc_aux1", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("adc_aux1", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_aux1_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("adc_aux2", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("adc_aux2", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_aux2_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("main_bat_v", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("main_bat_v", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_main_bat_v_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("vbus_v", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("vbus_v", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_vbus_v_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("main_charger_c", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("main_charger_c", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_main_charger_c_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("usb_charger_c", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("usb_charger_c", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_usb_charger_c_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("bk_bat_v", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("bk_bat_v", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_bk_bat_v_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("die_temp", (S_IRUGO | S_IWUSR),
+	file = debugfs_create_file("die_temp", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_die_temp_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("usb_id", (S_IRUGO | S_IWUGO),
+	file = debugfs_create_file("usb_id", (S_IRUGO | S_IWUSR | S_IWGRP),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_usb_id_fops);
 	if (!file)
 		goto err;
 
 	if (is_ab8540(ab8500)) {
-		file = debugfs_create_file("xtal_temp", (S_IRUGO | S_IWUGO),
+		file = debugfs_create_file("xtal_temp", (S_IRUGO | S_IWUSR | S_IWGRP),
 		    ab8500_gpadc_dir, &plf->dev, &ab8540_gpadc_xtal_temp_fops);
 		if (!file)
 			goto err;
-		file = debugfs_create_file("vbattruemeas", (S_IRUGO | S_IWUGO),
+		file = debugfs_create_file("vbattruemeas", (S_IRUGO | S_IWUSR | S_IWGRP),
 		    ab8500_gpadc_dir, &plf->dev,
 		    &ab8540_gpadc_vbat_true_meas_fops);
 		if (!file)
@@ -2778,27 +2778,27 @@ static int ab8500_debug_probe(struct platform_device *plf)
 				&plf->dev, &ab8540_gpadc_bat_temp_and_ibat_fops);
 		if (!file)
 			goto err;
-		file = debugfs_create_file("otp_calib", (S_IRUGO | S_IWUGO),
+		file = debugfs_create_file("otp_calib", (S_IRUGO | S_IWUSR | S_IWGRP),
 		    ab8500_gpadc_dir, &plf->dev, &ab8540_gpadc_otp_calib_fops);
 		if (!file)
 			goto err;
 	}
-	file = debugfs_create_file("avg_sample", (S_IRUGO | S_IWUGO),
+	file = debugfs_create_file("avg_sample", (S_IRUGO | S_IWUSR | S_IWGRP),
 		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_avg_sample_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("trig_edge", (S_IRUGO | S_IWUGO),
+	file = debugfs_create_file("trig_edge", (S_IRUGO | S_IWUSR | S_IWGRP),
 		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_trig_edge_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("trig_timer", (S_IRUGO | S_IWUGO),
+	file = debugfs_create_file("trig_timer", (S_IRUGO | S_IWUSR | S_IWGRP),
 		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_trig_timer_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("conv_type", (S_IRUGO | S_IWUGO),
+	file = debugfs_create_file("conv_type", (S_IRUGO | S_IWUSR | S_IWGRP),
 		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_conv_type_fops);
 	if (!file)
 		goto err;
-- 
1.7.10.4

