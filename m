Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3JVSDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:03:01 -0400
Received: from mout.gmx.net ([212.227.15.15]:57156 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab3JVSBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:01:08 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 09/15] tpm: cleanup checkpatch warnings
Date: Tue, 22 Oct 2013 20:00:34 +0200
Message-Id: <1382464840-7639-9-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
References: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:awvu0LbprlCds4vWeyW6h96iCTRTQ8AjHECF4/tWT2QR2LoJpeU
 qSRLT6RzTveIWTsPqo6tOmo2f+c1FrBMOHSY0WvbURURUp3lhTZKxFxkg/vl6JCpM7/nHGN
 Wv1gKL6a26hIoZ+WjZYiOmKjLDXYdpwbxpsD3vyUpljDDQm2zgx1E0B8QYyr/uqFnP92G+8
 gVuGecGGuQ7QwR1XxwOlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

before we rename the file it might be a good idea to cleanup the long
persisting checkpatch warnings.
Since everything is really trivial, splitting the patch up would only
result in noise.

For the interested reader - here the checkpatch warnings:
(regrouped for easer readability)

ERROR: trailing whitespace
+ * Specifications at www.trustedcomputinggroup.org^I $
+ * $
+^I/* $
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: unnecessary whitespace before a quoted newline
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_temp_deactivated(struct device * dev,
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
+ * @chip_num: ^Itpm idx # or ANY$
+ * @res_buf: ^ITPM_PCR value$
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$
+ * @chip_num: ^Itpm idx # or AN&$
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

WARNING: line over 80 characters
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool check_cancel,

ERROR: trailing whitespace
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1554 lines checked

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 72f0c68..6ae41d3 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
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
  * Note, the TPM chip is not interrupt driven (only polling)
  * and can have very long timeouts (minutes!). Hence the unusual
  * calls to msleep.
@@ -371,13 +371,14 @@ static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		return -ENODATA;
 	if (count > bufsiz) {
 		dev_err(chip->dev,
-			"invalid count value %x %zx \n", count, bufsiz);
+			"invalid count value %x %zx\n", count, bufsiz);
 		return -E2BIG;
 	}
 
 	mutex_lock(&chip->tpm_mutex);
 
-	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {
+	rc = chip->vendor.send(chip, (u8 *) buf, count);
+	if (rc < 0) {
 		dev_err(chip->dev,
 			"tpm_transmit: tpm_send: error %zd\n", rc);
 		goto out;
@@ -444,7 +445,7 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 {
 	int err;
 
-	len = tpm_transmit(chip,(u8 *) cmd, len);
+	len = tpm_transmit(chip, (u8 *) cmd, len);
 	if (len <  0)
 		return len;
 	else if (len < TPM_HEADER_SIZE)
@@ -658,7 +659,7 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	return rc;
 }
 
-ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_enabled(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	cap_t cap;
@@ -674,7 +675,7 @@ ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
 }
 EXPORT_SYMBOL_GPL(tpm_show_enabled);
 
-ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_active(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	cap_t cap;
@@ -690,7 +691,7 @@ ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
 }
 EXPORT_SYMBOL_GPL(tpm_show_active);
 
-ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
+ssize_t tpm_show_owned(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	cap_t cap;
@@ -706,8 +707,8 @@ ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
 }
 EXPORT_SYMBOL_GPL(tpm_show_owned);
 
-ssize_t tpm_show_temp_deactivated(struct device * dev,
-				struct device_attribute * attr, char *buf)
+ssize_t tpm_show_temp_deactivated(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	cap_t cap;
 	ssize_t rc;
@@ -769,10 +770,10 @@ static int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 /**
  * tpm_pcr_read - read a pcr value
- * @chip_num: 	tpm idx # or ANY
+ * @chip_num:	tpm idx # or ANY
  * @pcr_idx:	pcr idx to retrieve
- * @res_buf: 	TPM_PCR value
- * 		size of res_buf is 20 bytes (or NULL if you don't care)
+ * @res_buf:	TPM_PCR value
+ *		size of res_buf is 20 bytes (or NULL if you don't care)
  *
  * The TPM driver should be built-in, but for whatever reason it
  * isn't, protect against the chip disappearing, by incrementing
@@ -794,9 +795,9 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
 
 /**
  * tpm_pcr_extend - extend pcr value with hash
- * @chip_num: 	tpm idx # or AN&
+ * @chip_num:	tpm idx # or AN&
  * @pcr_idx:	pcr idx to extend
- * @hash: 	hash value used to extend pcr value
+ * @hash:	hash value used to extend pcr value
  *
  * The TPM driver should be built-in, but for whatever reason it
  * isn't, protect against the chip disappearing, by incrementing
@@ -847,8 +848,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 	unsigned long duration;
 	struct tpm_cmd_t cmd;
 
-	duration = tpm_calc_ordinal_duration(chip,
-	                                     TPM_ORD_CONTINUE_SELFTEST);
+	duration = tpm_calc_ordinal_duration(chip, TPM_ORD_CONTINUE_SELFTEST);
 
 	loops = jiffies_to_msecs(duration) / delay_msec;
 
@@ -965,12 +965,12 @@ ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
 	if (err)
 		goto out;
 
-	/* 
+	/*
 	   ignore header 10 bytes
 	   algorithm 32 bits (1 == RSA )
 	   encscheme 16 bits
 	   sigscheme 16 bits
-	   parameters (RSA 12->bytes: keybit, #primes, expbit)  
+	   parameters (RSA 12->bytes: keybit, #primes, expbit)
 	   keylenbytes 32 bits
 	   256 byte modulus
 	   ignore checksum 20 bytes
@@ -1092,8 +1092,8 @@ ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
 }
 EXPORT_SYMBOL_GPL(tpm_store_cancel);
 
-static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool check_cancel,
-				   bool *canceled)
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask,
+					bool check_cancel, bool *canceled)
 {
 	u8 status = chip->vendor.status(chip);
 
@@ -1463,7 +1463,7 @@ void tpm_dev_release(struct device *dev)
 EXPORT_SYMBOL_GPL(tpm_dev_release);
 
 /*
- * Called from tpm_<specific>.c probe function only for devices 
+ * Called from tpm_<specific>.c probe function only for devices
  * the driver has determined it should claim.  Prior to calling
  * this function the specific probe function has called pci_enable_device
  * upon errant exit from this function specific probe function should call
-- 
1.7.5.4

