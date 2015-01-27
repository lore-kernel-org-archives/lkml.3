Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbbA0MSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35038 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221AbbA0MR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Karl Relton <karllinuxtest.relton@ntlworld.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 043/126] HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard
Date: Tue, 27 Jan 2015 12:15:48 +0000
Message-Id: <1422361031-19364-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Relton <karllinuxtest.relton@ntlworld.com>

commit da940db41dcf8c04166f711646df2f35376010aa upstream.

Apple bluetooth wireless keyboard (sold in UK) has always reported zero
for battery strength no matter what condition the batteries are actually
in. With this patch applied (applying same quirk as other Apple
keyboards), the battery strength is now correctly reported.

Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 62e828655922..89ce91883eba 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -312,6 +312,9 @@ static const struct hid_device_id hid_battery_quirks[] = {
 			       USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI),
 	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+			       USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO),
+	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
 		USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
 	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
 	{}
-- 
2.1.4

