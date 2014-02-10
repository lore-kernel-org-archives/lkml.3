Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaBJUN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:13:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaBJTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:43:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 045/124] staging: r8712u: Set device type to wlan
Date: Mon, 10 Feb 2014 11:39:45 -0800
Message-Id: <1392061264-28124-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 3a21f00a5002b14e4aab52aef59d33ed28468a13 upstream.

The latest version of NetworkManager does not recognize the device as wireless
without this change.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/rtl8712/usb_intf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index a96cd06..601b9f7 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -358,6 +358,10 @@ static u8 key_2char2num(u8 hch, u8 lch)
 	return (hex_to_bin(hch) << 4) | hex_to_bin(lch);
 }
 
+static const struct device_type wlan_type = {
+	.name = "wlan",
+};
+
 /*
  * drv_init() - a device potentially for us
  *
@@ -393,6 +397,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	padapter->pusb_intf = pusb_intf;
 	usb_set_intfdata(pusb_intf, pnetdev);
 	SET_NETDEV_DEV(pnetdev, &pusb_intf->dev);
+	pnetdev->dev.type = &wlan_type;
 	/* step 2. */
 	padapter->dvobj_init = &r8712_usb_dvobj_init;
 	padapter->dvobj_deinit = &r8712_usb_dvobj_deinit;
-- 
1.8.3.2

