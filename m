Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3BQW6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:58:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45783 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756311Ab3BQWzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:46 -0500
Message-Id: <20130217225005.039605447@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:30 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Maia Kozheva <sikon@ubuntu.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 29/66] rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB
 Wi-Fi adapter
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 0230812..d67d14e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -965,6 +965,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	{ USB_DEVICE(0x2001, 0x3c1b) },
+	{ USB_DEVICE(0x2001, 0x3c1e) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
 	/* DVICO */


