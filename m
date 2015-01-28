Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbbA2JiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:38:03 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44855 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760008AbbA2JF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:57 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Karl Relton <karllinuxtest.relton@ntlworld.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 023/176] HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard
Date: Wed, 28 Jan 2015 15:27:33 +0100
Message-Id: <19fd1c1aad20eff874b7187cfdddb46d25786260.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karl Relton <karllinuxtest.relton@ntlworld.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit da940db41dcf8c04166f711646df2f35376010aa upstream.

Apple bluetooth wireless keyboard (sold in UK) has always reported zero
for battery strength no matter what condition the batteries are actually
in. With this patch applied (applying same quirk as other Apple
keyboards), the battery strength is now correctly reported.

Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d97f2323af57..6f568b64784b 100644
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
2.2.2

