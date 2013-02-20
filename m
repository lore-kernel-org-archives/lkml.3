Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab3BTDfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 22:35:00 -0500
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:34071 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844Ab3BTDez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 22:34:55 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=YO+FcVZrxpdWV6Mo6AkY2Rtp7tuV51ZJEd1ZQZEmJbs= c=1 sm=1
 a=4uzrxgcXg54A:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=e9Lw78MXKG98cn13CacA:9
 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org
Subject: [PATCH 4/5] HID: LG4FF: Remove unnecessary deadzone code
Date: Tue, 19 Feb 2013 20:25:13 -0700
Message-Id: <1361330714-5217-4-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361330714-5217-1-git-send-email-simon@mungewell.org>
References: <1361330714-5217-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes code which is now unnecessary for setting the fuzz/flat
characterics for the logitech DFP wheel. This is now done in the previous
patch by marking the wheel as a multi-axis device.

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index d7947c7..65a6ec8 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -43,11 +43,6 @@
 #define G27_REV_MAJ 0x12
 #define G27_REV_MIN 0x38
 
-#define DFP_X_MIN 0
-#define DFP_X_MAX 16383
-#define DFP_PEDAL_MIN 0
-#define DFP_PEDAL_MAX 255
-
 #define to_hid_device(pdev) container_of(pdev, struct hid_device, dev)
 
 static void hid_lg4ff_set_range_dfp(struct hid_device *hid, u16 range);
@@ -598,18 +593,6 @@ int lg4ff_init(struct hid_device *hid)
 		return error;
 	dbg_hid("sysfs interface created\n");
 
-	/* Set default axes parameters */
-	switch (lg4ff_devices[i].product_id) {
-	case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
-		dbg_hid("Setting axes parameters for Driving Force Pro\n");
-		input_set_abs_params(dev, ABS_X, DFP_X_MIN, DFP_X_MAX, 0, 0);
-		input_set_abs_params(dev, ABS_Y, DFP_PEDAL_MIN, DFP_PEDAL_MAX, 0, 0);
-		input_set_abs_params(dev, ABS_RZ, DFP_PEDAL_MIN, DFP_PEDAL_MAX, 0, 0);
-		break;
-	default:
-		break;
-	}
-
 	/* Set the maximum range to start with */
 	entry->range = entry->max_range;
 	if (entry->set_range != NULL)
-- 
1.7.10.4

