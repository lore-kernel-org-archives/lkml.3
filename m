Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaFEEWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaFEEWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maia Kozheva <sikon@ubuntu.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 191/214] rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-Fi adapter
Date: Wed,  4 Jun 2014 21:19:14 -0700
Message-Id: <20140605041705.092842862@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maia Kozheva <sikon@ubuntu.com>

commit fd7b9270120ca7e53fbf0469febe0c68acf6a0a2 upstream.

D-Link DWA-125/B1 is a relatively new USB Wi-Fi adapter, using a
Ralink chipset supported by the rt2800usb driver. Currently, to work
around the problem (it's missing in all present kernel versions,
up to and including 3.7.x), I had to add this to /etc/rc.local:

echo 2001 3c1e >> /sys/bus/usb/drivers/rt2800usb/new_id

After that, the device works without problems. Been using it for over
a week with no bugs in sight.

The attached patch is trivial and simply adds the new USB ID to the
list of devices handled by rt2800usb.

Signed-off-by: Maia Kozheva <sikon@ubuntu.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1009,6 +1009,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	{ USB_DEVICE(0x2001, 0x3c1b) },
+	{ USB_DEVICE(0x2001, 0x3c1e) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
 	/* DVICO */


