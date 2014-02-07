Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaBGMt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:49:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314AbaBGLuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 105/233] staging: r8712u: Set device type to wlan
Date: Fri,  7 Feb 2014 11:45:24 +0000
Message-Id: <1391773652-25214-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 3a21f00a5002b14e4aab52aef59d33ed28468a13 upstream.

The latest version of NetworkManager does not recognize the device as wireless
without this change.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/rtl8712/usb_intf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index c812d6c7..e3a005d 100644
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

