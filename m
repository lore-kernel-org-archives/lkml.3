Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbbAQQD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 11:03:56 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:51616 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbAQQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 11:03:55 -0500
From: Bruno E O Meneguele <bmeneguele@gmail.com>
To: peterhuewe@gmx.de
Cc: linux-kernel@vger.kernel.org, Bruno E O Meneguele <bmeneguele@gmail.com>
Subject: [PATCH] Char: tpm: fixed white spaces and braces coding style issues
Date: Sat, 17 Jan 2015 17:03:30 +0100
Message-Id: <1421510610-12139-1-git-send-email-bmeneguele@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues.

Signed-off-by: Bruno E O Meneguele <bmeneguele@gmail.com>
---
 drivers/char/tpm/tpm.h              | 10 +++++-----
 drivers/char/tpm/tpm_i2c_stm_st33.c | 10 ++++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e4d0888d2eab..51d843c43b25 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -10,13 +10,13 @@
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
- * Specifications at www.trustedcomputinggroup.org	 
+ * Specifications at www.trustedcomputinggroup.org
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation, version 2 of the
  * License.
- * 
+ *
  */
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -88,7 +88,7 @@ struct tpm_vendor_specific {
 	u16 manufacturer_id;
 };
 
-#define TPM_VPRIV(c)	(c)->vendor.priv
+#define TPM_VPRIV(c)	 ((c)->vendor.priv)
 
 #define TPM_VID_INTEL    0x8086
 #define TPM_VID_WINBOND  0x1050
@@ -110,7 +110,7 @@ struct tpm_chip {
 	struct dentry **bios_dir;
 
 	struct list_head list;
-	void (*release) (struct device *);
+	void (*release)(struct device *);
 };
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
@@ -321,7 +321,7 @@ extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
-extern struct tpm_chip* tpm_register_hardware(struct device *,
+extern struct tpm_chip *tpm_register_hardware(struct device *,
 					      const struct tpm_class_ops *ops);
 extern void tpm_dev_vendor_release(struct tpm_chip *);
 extern void tpm_remove_hardware(struct device *);
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 4669e3713428..02cd398bef14 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -157,6 +157,7 @@ static int read8_reg(struct i2c_client *client, u8 tpm_register,
 static void clear_interruption(struct i2c_client *client)
 {
 	u8 interrupt;
+
 	I2C_READ_DATA(client, TPM_INT_STATUS, &interrupt, 1);
 	I2C_WRITE_DATA(client, TPM_INT_STATUS, &interrupt, 1);
 	I2C_READ_DATA(client, TPM_INT_STATUS, &interrupt, 1);
@@ -233,6 +234,7 @@ static u8 tpm_stm_i2c_status(struct tpm_chip *chip)
 {
 	struct i2c_client *client;
 	u8 data;
+
 	client = (struct i2c_client *)TPM_VPRIV(chip);
 
 	I2C_READ_DATA(client, TPM_STS, &data, 1);
@@ -679,7 +681,7 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 				IRQF_TRIGGER_HIGH,
 				"TPM SERIRQ management", chip);
 		if (err < 0) {
-			dev_err(chip->dev , "TPM SERIRQ signals %d not available\n",
+			dev_err(chip->dev, "TPM SERIRQ signals %d not available\n",
 				gpio_to_irq(platform_data->io_serirq));
 			goto _irq_set;
 		}
@@ -784,11 +786,11 @@ static int tpm_st33_i2c_pm_suspend(struct device *dev)
 	struct st33zp24_platform_data *pin_infos = dev->platform_data;
 	int ret = 0;
 
-	if (power_mgt) {
+	if (power_mgt)
 		gpio_set_value(pin_infos->io_lpcpd, 0);
-	} else {
+	else
 		ret = tpm_pm_suspend(dev);
-	}
+
 	return ret;
 }				/* tpm_st33_i2c_suspend() */
 
-- 
2.2.1

