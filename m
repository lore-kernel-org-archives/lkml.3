Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaICTne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:43:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaICTnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:43:32 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: wacom: Add support for the Cintiq Companion
Date: Wed,  3 Sep 2014 15:43:25 -0400
Message-Id: <1409773405-18030-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Wacom Cintiq Companion shares the same sensor than the Cintiq
Companion Hybrid, with the exception of the different PIDs.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi,

I guess this could now go through Jiri's tree given that it applies on top of a
plain 3.17-rcX. It can be scheduled for either 3.17 or 3.18 (no preferences on
my side).

Cheers,
Benjamin

 drivers/hid/wacom_wac.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index aa6a08e..c3cbbfb 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2573,6 +2573,14 @@ static const struct wacom_features wacom_features_0x309 =
 	{ "Wacom ISDv5 309", .type = WACOM_24HDT, /* Touch */
 	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x0307, .touch_max = 10,
 	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
+static const struct wacom_features wacom_features_0x30A =
+	{ "Wacom ISDv5 30A", 59352, 33648, 2047, 63,
+	  CINTIQ_HYBRID, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES, 200, 200,
+	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x30C };
+static const struct wacom_features wacom_features_0x30C =
+	{ "Wacom ISDv5 30C", .type = WACOM_24HDT, /* Touch */
+	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x30A, .touch_max = 10,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 
 #define USB_DEVICE_WACOM(prod)						\
 	HID_DEVICE(BUS_USB, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
@@ -2708,6 +2716,8 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x304) },
 	{ USB_DEVICE_WACOM(0x307) },
 	{ USB_DEVICE_WACOM(0x309) },
+	{ USB_DEVICE_WACOM(0x30A) },
+	{ USB_DEVICE_WACOM(0x30C) },
 	{ USB_DEVICE_WACOM(0x30E) },
 	{ USB_DEVICE_WACOM(0x314) },
 	{ USB_DEVICE_WACOM(0x315) },
-- 
2.1.0

