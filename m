Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3BBUp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 15:45:59 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:45189 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3BBUp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 15:45:57 -0500
From: Paul Sbarra <sbarra.paul@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Sbarra <sbarra.paul@gmail.com>
Subject: [PATCH 1/3] hid: Add report descriptor for Logitech Driving Force wheel
Date: Sat,  2 Feb 2013 14:45:23 -0600
Message-Id: <1359837925-6383-1-git-send-email-sbarra.paul@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the original report descriptor as reported by lsusb -vd 046d:c294.

Signed-off-by: Paul Sbarra <sbarra.paul@gmail.com>
---
 drivers/hid/hid-lg.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 79 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index a2f8e88..9312a62 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -40,17 +40,83 @@
 #define LG_FF3			0x1000
 #define LG_FF4			0x2000
 
-/* Size of the original descriptor of the Driving Force Pro wheel */
+/* Size of the original descriptors of the Driving Force (and Pro) wheels */
+#define DF_RDESC_ORIG_SIZE	130
 #define DFP_RDESC_ORIG_SIZE	97
 
-/* Fixed report descriptor for Logitech Driving Force Pro wheel controller
+/* Fixed report descriptors for Logitech Driving Force (and Pro)
+ * wheel controllers
  *
- * The original descriptor hides the separate throttle and brake axes in
+ * The original descriptors hide the separate throttle and brake axes in
  * a custom vendor usage page, providing only a combined value as
  * GenericDesktop.Y.
- * This descriptor removes the combined Y axis and instead reports
+ * These descriptors remove the combined Y axis and instead report
  * separate throttle (Y) and brake (RZ).
  */
+static __u8 df_rdesc_fixed[] = {
+0x05, 0x01,         /*  Usage Page (Desktop),                   */
+0x09, 0x04,         /*  Usage (Joystik),                        */
+0xA1, 0x01,         /*  Collection (Application),               */
+0xA1, 0x02,         /*      Collection (Logical),               */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x0A,         /*          Report Size (10),               */
+0x14,               /*          Logical Minimum (0),            */
+0x26, 0xFF, 0x03,   /*          Logical Maximum (1023),         */
+0x34,               /*          Physical Minimum (0),           */
+0x46, 0xFF, 0x03,   /*          Physical Maximum (1023),        */
+0x09, 0x30,         /*          Usage (X),                      */
+0x81, 0x02,         /*          Input (Variable),               */
+0x95, 0x0C,         /*          Report Count (12),              */
+0x75, 0x01,         /*          Report Size (1),                */
+0x25, 0x01,         /*          Logical Maximum (1),            */
+0x45, 0x01,         /*          Physical Maximum (1),           */
+0x05, 0x09,         /*          Usage (Buttons),                */
+0x19, 0x01,         /*          Usage Minimum (1),              */
+0x29, 0x0c,         /*          Usage Maximum (12),             */
+0x81, 0x02,         /*          Input (Variable),               */
+0x95, 0x02,         /*          Report Count (2),               */
+0x06, 0x00, 0xFF,   /*          Usage Page (Vendor: 65280),     */
+0x09, 0x01,         /*          Usage (?: 1),                   */
+0x81, 0x02,         /*          Input (Variable),               */
+0x05, 0x01,         /*          Usage Page (Desktop),           */
+0x09, 0x31,         /*          Usage (Y),                      */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x95, 0x01,         /*          Report Count (1),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x81, 0x02,         /*          Input (Variable),               */
+0x25, 0x07,         /*          Logical Maximum (7),            */
+0x46, 0x3B, 0x01,   /*          Physical Maximum (315),         */
+0x75, 0x04,         /*          Report Size (4),                */
+0x65, 0x14,         /*          Unit (Degrees),                 */
+0x09, 0x39,         /*          Usage (Hat Switch),             */
+0x81, 0x42,         /*          Input (Variable, Null State),   */
+0x75, 0x01,         /*          Report Size (1),                */
+0x95, 0x04,         /*          Report Count (4),               */
+0x65, 0x00,         /*          Unit (none),                    */
+0x06, 0x00, 0xFF,   /*          Usage Page (Vendor: 65280),     */
+0x09, 0x01,         /*          Usage (?: 1),                   */
+0x25, 0x01,         /*          Logical Maximum (1),            */
+0x45, 0x01,         /*          Physical Maximum (1),           */
+0x81, 0x02,         /*          Input (Variable),               */
+0x95, 0x02,         /*          Report Count (2),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x09, 0x02,         /*          Usage (?: 2),                   */
+0x81, 0x02,         /*          Input (Variable),               */
+0xC0,               /*      End Collection,                     */
+0xA1, 0x02,         /*      Collection (Logical),               */
+0x26, 0xFF, 0x00,   /*          Logical Maximum (255),          */
+0x46, 0xFF, 0x00,   /*          Physical Maximum (255),         */
+0x95, 0x07,         /*          Report Count (7),               */
+0x75, 0x08,         /*          Report Size (8),                */
+0x09, 0x03,         /*          Usage (?: 3),                   */
+0x91, 0x02,         /*          Output (Variable),              */
+0xC0,               /*      End Collection,                     */
+0xC0                /*  End Collection                          */
+};
+
 static __u8 dfp_rdesc_fixed[] = {
 0x05, 0x01,         /*  Usage Page (Desktop),                   */
 0x09, 0x04,         /*  Usage (Joystik),                        */
@@ -99,7 +165,6 @@ static __u8 dfp_rdesc_fixed[] = {
 0xC0                /*  End Collection                          */
 };
 
-
 /*
  * Certain Logitech keyboards send in report #3 keys which are far
  * above the logical maximum described in descriptor. This extends
@@ -135,6 +200,15 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	}
 
 	switch (hdev->product) {
+	case USB_DEVICE_ID_LOGITECH_WHEEL:
+		if (*rsize == DF_RDESC_ORIG_SIZE) {
+			hid_info(hdev,
+				"fixing up Logitech Driving Force report descriptor\n");
+			rdesc = df_rdesc_fixed;
+			*rsize = sizeof(df_rdesc_fixed);
+		}
+		break;
+
 	case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
 		if (*rsize == DFP_RDESC_ORIG_SIZE) {
 			hid_info(hdev,
-- 
1.8.1.1

