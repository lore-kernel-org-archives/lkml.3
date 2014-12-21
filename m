Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaLUACg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 19:02:36 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:40038 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaLUACd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 19:02:33 -0500
From: Ross Skaliotis <rskaliotis@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ross Skaliotis <rskaliotis@gmail.com>
Subject: [PATCH] hid: Fix battery support for the 2009 ANSI Apple wireless keyboard.
Date: Sat, 20 Dec 2014 19:01:35 -0500
Message-Id: <1419120095-11889-1-git-send-email-rskaliotis@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabled quirks necessary for correct battery capacity reporting. Cleaned up
surrounding style.

Signed-off-by: Ross Skaliotis <rskaliotis@gmail.com>
---
 drivers/hid/hid-input.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index e0a0f06..146da43 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -306,10 +306,13 @@ static enum power_supply_property hidinput_battery_props[] = {
 
 static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
-			USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
-	HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
+		USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+		USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
+	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
-			       USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI),
+		USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI),
 	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
 		USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
-- 
2.0.4

