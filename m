Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbbANHjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:39:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229AbbANHj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:39:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Karl Relton <karllinuxtest.relton@ntlworld.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 20/44] HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard
Date: Tue, 13 Jan 2015 23:23:41 -0800
Message-Id: <20150114072228.652068385@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Relton <karllinuxtest.relton@ntlworld.com>

commit da940db41dcf8c04166f711646df2f35376010aa upstream.

Apple bluetooth wireless keyboard (sold in UK) has always reported zero
for battery strength no matter what condition the batteries are actually
in. With this patch applied (applying same quirk as other Apple
keyboards), the battery strength is now correctly reported.

Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -317,6 +317,9 @@ static const struct hid_device_id hid_ba
 			       USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI),
 	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
+			       USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO),
+	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
 		USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
 	  HID_BATTERY_QUIRK_PERCENT | HID_BATTERY_QUIRK_FEATURE },
 	{}


