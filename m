Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaIXAYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:24:44 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33534 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaIXAYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:24:41 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 1/4] toshiba_acpi: Rename hci_raw to tci_raw
Date: Tue, 23 Sep 2014 18:24:25 -0600
Message-Id: <1411518268-2773-2-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
References: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function name hci_raw was used before to reflect
a raw (read/write) call to the Toshiba's Hardware
Configuration Interface (HCI), however, since the
introduction of the System Configuration Interface
(SCI), that "name" no longer applies.

This patch changes the name of that function to
tci_raw (for Toshiba Configuration Interface), and
change the comments about it.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 40 ++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index edd8f3d..b7030dc 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -71,7 +71,7 @@ MODULE_LICENSE("GPL");
 /* Toshiba ACPI method paths */
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
 
-/* Toshiba HCI interface definitions
+/* Toshiba configuration interface definitions
  *
  * HCI is Toshiba's "Hardware Control Interface" which is supposed to
  * be uniform across all their models.  Ideally we would just call
@@ -274,10 +274,10 @@ static int write_acpi_int(const char *methodName, int val)
 	return (status == AE_OK) ? 0 : -EIO;
 }
 
-/* Perform a raw HCI call.  Here we don't care about input or output buffer
- * format.
+/* Perform a raw configuration call.  Here we don't care about input or output
+ * buffer format.
  */
-static acpi_status hci_raw(struct toshiba_acpi_dev *dev,
+static acpi_status tci_raw(struct toshiba_acpi_dev *dev,
 			   const u32 in[HCI_WORDS], u32 out[HCI_WORDS])
 {
 	struct acpi_object_list params;
@@ -320,7 +320,7 @@ static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
 {
 	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	acpi_status status = tci_raw(dev, in, out);
 	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
 	return status;
 }
@@ -330,7 +330,7 @@ static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
 {
 	u32 in[HCI_WORDS] = { HCI_GET, reg, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
 	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
 	return status;
@@ -341,7 +341,7 @@ static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
 {
 	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
 	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	acpi_status status = tci_raw(dev, in, out);
 	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
 	return status;
 }
@@ -351,7 +351,7 @@ static acpi_status hci_read2(struct toshiba_acpi_dev *dev, u32 reg,
 {
 	u32 in[HCI_WORDS] = { HCI_GET, reg, *out1, *out2, 0, 0 };
 	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
 	*out2 = out[3];
 	*result = (status == AE_OK) ? out[0] : HCI_FAILURE;
@@ -367,7 +367,7 @@ static int sci_open(struct toshiba_acpi_dev *dev)
 	u32 out[HCI_WORDS];
 	acpi_status status;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if  (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		pr_err("ACPI call to open SCI failed\n");
 		return 0;
@@ -391,7 +391,7 @@ static void sci_close(struct toshiba_acpi_dev *dev)
 	u32 out[HCI_WORDS];
 	acpi_status status;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		pr_err("ACPI call to close SCI failed\n");
 		return;
@@ -410,7 +410,7 @@ static acpi_status sci_read(struct toshiba_acpi_dev *dev, u32 reg,
 {
 	u32 in[HCI_WORDS] = { SCI_GET, reg, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	acpi_status status = tci_raw(dev, in, out);
 	*out1 = out[2];
 	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
 	return status;
@@ -421,7 +421,7 @@ static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
 {
 	u32 in[HCI_WORDS] = { SCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[HCI_WORDS];
-	acpi_status status = hci_raw(dev, in, out);
+	acpi_status status = tci_raw(dev, in, out);
 	*result = (ACPI_SUCCESS(status)) ? out[0] : HCI_FAILURE;
 	return status;
 }
@@ -436,7 +436,7 @@ static int toshiba_illumination_available(struct toshiba_acpi_dev *dev)
 	if (!sci_open(dev))
 		return 0;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	sci_close(dev);
 	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		pr_err("ACPI call to query Illumination support failed\n");
@@ -509,7 +509,7 @@ static int toshiba_kbd_illum_available(struct toshiba_acpi_dev *dev)
 	if (!sci_open(dev))
 		return 0;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	sci_close(dev);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query kbd illumination support failed\n");
@@ -666,7 +666,7 @@ static int toshiba_eco_mode_available(struct toshiba_acpi_dev *dev)
 	u32 in[HCI_WORDS] = { HCI_GET, HCI_ECO_MODE, 0, 1, 0, 0 };
 	u32 out[HCI_WORDS];
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_info("ACPI call to get ECO led failed\n");
 		return 0;
@@ -683,7 +683,7 @@ static enum led_brightness toshiba_eco_mode_get_status(struct led_classdev *cdev
 	u32 out[HCI_WORDS];
 	acpi_status status;
 
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to get ECO led failed\n");
 		return LED_OFF;
@@ -703,7 +703,7 @@ static void toshiba_eco_mode_set_status(struct led_classdev *cdev,
 
 	/* Switch the Eco Mode led on/off */
 	in[2] = (brightness) ? 1 : 0;
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to set ECO led failed\n");
 		return;
@@ -720,7 +720,7 @@ static int toshiba_accelerometer_supported(struct toshiba_acpi_dev *dev)
 	/* Check if the accelerometer call exists,
 	 * this call also serves as initialization
 	 */
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query the accelerometer failed\n");
 		return -EIO;
@@ -744,7 +744,7 @@ static int toshiba_accelerometer_get(struct toshiba_acpi_dev *dev,
 	acpi_status status;
 
 	/* Check the Accelerometer status */
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
 		pr_err("ACPI call to query the accelerometer failed\n");
 		return -EIO;
@@ -939,7 +939,7 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
 	}
 
 	in[2] = value << HCI_LCD_BRIGHTNESS_SHIFT;
-	status = hci_raw(dev, in, out);
+	status = tci_raw(dev, in, out);
 	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
 		pr_err("ACPI call to set brightness failed");
 		return -EIO;
-- 
2.0.0

