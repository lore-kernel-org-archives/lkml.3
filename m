Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbbA2BJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:09:22 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52246 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbbA2BJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:09:20 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Evgeny Budilovsky <budevg@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: cptm1217: clearpad_tm1217: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:39:39 +0100
Message-Id: <1422484779-9786-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/cptm1217/clearpad_tm1217.c |   35 +++++++++++++---------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
index 7f265ce..444d86b 100644
--- a/drivers/staging/cptm1217/clearpad_tm1217.c
+++ b/drivers/staging/cptm1217/clearpad_tm1217.c
@@ -320,45 +320,44 @@ exit_thread:
 
 static int cp_tm1217_init_data(struct cp_tm1217_device *ts)
 {
-	int retval;
 	u8	req[2];
 
 	/* Read the vendor id/ fw revision etc. Ignoring return check as this
 	   is non critical info  */
 	req[0] = TMA1217_MANUFACTURER_ID;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->vinfo.vendor_id = req[1];
 
 	req[0] = TMA1217_PRODUCT_FAMILY;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->vinfo.product_family = req[1];
 
 	req[0] = TMA1217_FIRMWARE_REVISION;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->vinfo.firmware_rev = req[1];
 
 	req[0] = TMA1217_SERIAL_NO_HIGH;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->vinfo.serial_no = (req[1] << 8);
 
 	req[0] = TMA1217_SERIAL_NO_LOW;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->vinfo.serial_no = ts->vinfo.serial_no | req[1];
 
 	req[0] = TMA1217_MAX_X_HIGHER4;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->dinfo.maxX = (req[1] & 0xF) << 8;
 
 	req[0] = TMA1217_MAX_X_LOWER8;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->dinfo.maxX = ts->dinfo.maxX | req[1];
 
 	req[0] = TMA1217_MAX_Y_HIGHER4;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->dinfo.maxY = (req[1] & 0xF) << 8;
 
 	req[0] = TMA1217_MAX_Y_LOWER8;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	ts->dinfo.maxY = ts->dinfo.maxY | req[1];
 
 	return 0;
@@ -563,13 +562,12 @@ static int cp_tm1217_suspend(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct cp_tm1217_device *ts = i2c_get_clientdata(client);
 	u8 req[2];
-	int retval;
 
 	/* Put the controller to sleep */
 	req[0] = TMA1217_DEVICE_CTRL;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	req[1] = (req[1] & 0xF8) | 0x1;
-	retval = cp_tm1217_write(ts, req, 1);
+	cp_tm1217_write(ts, req, 1);
 
 	if (device_may_wakeup(&client->dev))
 		enable_irq_wake(client->irq);
@@ -586,13 +584,12 @@ static int cp_tm1217_resume(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct cp_tm1217_device *ts = i2c_get_clientdata(client);
 	u8 req[2];
-	int retval;
 
 	/* Take the controller out of sleep */
 	req[0] = TMA1217_DEVICE_CTRL;
-	retval = cp_tm1217_read(ts, req, 1);
+	cp_tm1217_read(ts, req, 1);
 	req[1] = (req[1] & 0xF8) | 0x4;
-	retval = cp_tm1217_write(ts, req, 1);
+	cp_tm1217_write(ts, req, 1);
 
 	/* Restore the register settings sinc the power to the
 	   could have been cut off */
@@ -601,15 +598,15 @@ static int cp_tm1217_resume(struct device *dev)
 	   finger arrives or departs. */
 	req[0] = TMA1217_REPORT_MODE;
 	req[1] = 0x02;
-	retval = cp_tm1217_write(ts, req, 1);
+	cp_tm1217_write(ts, req, 1);
 
 	/* Setup the device to no sleep mode for now and make it configured */
 	req[0] = TMA1217_DEVICE_CTRL;
 	req[1] = 0x84;
-	retval = cp_tm1217_write(ts, req, 1);
+	cp_tm1217_write(ts, req, 1);
 
 	/* Setup the interrupt mask */
-	retval = cp_tm1217_unmask_interrupt(ts);
+	cp_tm1217_unmask_interrupt(ts);
 
 	if (device_may_wakeup(&client->dev))
 		disable_irq_wake(client->irq);
-- 
1.7.10.4

