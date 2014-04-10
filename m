Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934958AbaDJDWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934647AbaDJDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>, Chen Peter <B29397@freescale.com>,
        Greg KH <greg@kroah.com>, Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 015/134] HID: add quirk for Freescale i.MX28 ROM recovery
Date: Wed,  9 Apr 2014 20:22:11 -0700
Message-Id: <20140410032301.771765256@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 2843b673d03421e0e73cf061820d1db328f7c8eb upstream.

The USB recovery mode present in i.MX28 ROM emulates USB HID.
It needs this quirk to behave properly.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Chen Peter <B29397@freescale.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>
[jkosina@suse.cz: fix alphabetical ordering]
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[yjw: Backported to 3.4: adjust context]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -293,6 +293,9 @@
 #define USB_VENDOR_ID_FRUCTEL	0x25B6
 #define USB_DEVICE_ID_GAMETEL_MT_MODE	0x0002
 
+#define USB_VENDOR_ID_FREESCALE		0x15A2
+#define USB_DEVICE_ID_FREESCALE_MX28	0x004F
+
 #define USB_VENDOR_ID_GAMERON		0x0810
 #define USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR	0x0001
 #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR	0x0002
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -70,6 +70,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },


