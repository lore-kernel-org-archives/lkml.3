Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaICJ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:17 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57447 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751588AbaICJ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 12/56] HID: fix a couple of off-by-ones
Date: Wed,  3 Sep 2014 11:26:31 +0200
Message-Id: <1f78f21b43f2c69f2ea06ed35b77759d000dd2b4.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4ab25786c87eb20857bbb715c3ae34ec8fd6a214 upstream.

There are a few very theoretical off-by-one bugs in report descriptor size
checking when performing a pre-parsing fixup. Fix those.

Reported-by: Ben Hawkes <hawkes@google.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-cherry.c   | 2 +-
 drivers/hid/hid-kye.c      | 2 +-
 drivers/hid/hid-lg.c       | 4 ++--
 drivers/hid/hid-monterey.c | 2 +-
 drivers/hid/hid-petalynx.c | 2 +-
 drivers/hid/hid-sunplus.c  | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index 1bdcccc54a1d..f745d2c1325e 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -28,7 +28,7 @@
 static __u8 *ch_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 17 && rdesc[11] == 0x3c && rdesc[12] == 0x02) {
+	if (*rsize >= 18 && rdesc[11] == 0x3c && rdesc[12] == 0x02) {
 		hid_info(hdev, "fixing up Cherry Cymotion report descriptor\n");
 		rdesc[11] = rdesc[16] = 0xff;
 		rdesc[12] = rdesc[17] = 0x03;
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index d645caa690dd..8a3552cf3904 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -300,7 +300,7 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 *   - change the button usage range to 4-7 for the extra
 		 *     buttons
 		 */
-		if (*rsize >= 74 &&
+		if (*rsize >= 75 &&
 			rdesc[61] == 0x05 && rdesc[62] == 0x08 &&
 			rdesc[63] == 0x19 && rdesc[64] == 0x08 &&
 			rdesc[65] == 0x29 && rdesc[66] == 0x0f &&
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 06eb45fa6331..12fc48c968e6 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -345,14 +345,14 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	struct usb_device_descriptor *udesc;
 	__u16 bcdDevice, rev_maj, rev_min;
 
-	if ((drv_data->quirks & LG_RDESC) && *rsize >= 90 && rdesc[83] == 0x26 &&
+	if ((drv_data->quirks & LG_RDESC) && *rsize >= 91 && rdesc[83] == 0x26 &&
 			rdesc[84] == 0x8c && rdesc[85] == 0x02) {
 		hid_info(hdev,
 			 "fixing up Logitech keyboard report descriptor\n");
 		rdesc[84] = rdesc[89] = 0x4d;
 		rdesc[85] = rdesc[90] = 0x10;
 	}
-	if ((drv_data->quirks & LG_RDESC_REL_ABS) && *rsize >= 50 &&
+	if ((drv_data->quirks & LG_RDESC_REL_ABS) && *rsize >= 51 &&
 			rdesc[32] == 0x81 && rdesc[33] == 0x06 &&
 			rdesc[49] == 0x81 && rdesc[50] == 0x06) {
 		hid_info(hdev,
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index 9e14c00eb1b6..25daf28b26bd 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -24,7 +24,7 @@
 static __u8 *mr_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 30 && rdesc[29] == 0x05 && rdesc[30] == 0x09) {
+	if (*rsize >= 31 && rdesc[29] == 0x05 && rdesc[30] == 0x09) {
 		hid_info(hdev, "fixing up button/consumer in HID report descriptor\n");
 		rdesc[30] = 0x0c;
 	}
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index 736b2502df4f..6aca4f2554bf 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -25,7 +25,7 @@
 static __u8 *pl_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 60 && rdesc[39] == 0x2a && rdesc[40] == 0xf5 &&
+	if (*rsize >= 62 && rdesc[39] == 0x2a && rdesc[40] == 0xf5 &&
 			rdesc[41] == 0x00 && rdesc[59] == 0x26 &&
 			rdesc[60] == 0xf9 && rdesc[61] == 0x00) {
 		hid_info(hdev, "fixing up Petalynx Maxter Remote report descriptor\n");
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index 87fc91e1c8de..91072fa54663 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -24,7 +24,7 @@
 static __u8 *sp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 107 && rdesc[104] == 0x26 && rdesc[105] == 0x80 &&
+	if (*rsize >= 112 && rdesc[104] == 0x26 && rdesc[105] == 0x80 &&
 			rdesc[106] == 0x03) {
 		hid_info(hdev, "fixing up Sunplus Wireless Desktop report descriptor\n");
 		rdesc[105] = rdesc[110] = 0x03;
-- 
2.1.0

