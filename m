Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbaBDVA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:00:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaBDVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3.4 17/37] staging: r8712u: Set device type to wlan
Date: Tue,  4 Feb 2014 13:00:53 -0800
Message-Id: <20140204210056.491855606@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210055.992134150@linuxfoundation.org>
References: <20140204210055.992134150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 3a21f00a5002b14e4aab52aef59d33ed28468a13 upstream.

The latest version of NetworkManager does not recognize the device as wireless
without this change.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/usb_intf.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -361,6 +361,10 @@ static u8 key_2char2num(u8 hch, u8 lch)
 	return (hex_to_bin(hch) << 4) | hex_to_bin(lch);
 }
 
+static const struct device_type wlan_type = {
+	.name = "wlan",
+};
+
 /*
  * drv_init() - a device potentially for us
  *
@@ -396,6 +400,7 @@ static int r871xu_drv_init(struct usb_in
 	padapter->pusb_intf = pusb_intf;
 	usb_set_intfdata(pusb_intf, pnetdev);
 	SET_NETDEV_DEV(pnetdev, &pusb_intf->dev);
+	pnetdev->dev.type = &wlan_type;
 	/* step 2. */
 	padapter->dvobj_init = &r8712_usb_dvobj_init;
 	padapter->dvobj_deinit = &r8712_usb_dvobj_deinit;


