Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3AXDcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:32:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab3AXDbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maia Kozheva <sikon@ubuntu.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 65/74] rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-Fi adapter
Date: Thu, 24 Jan 2013 01:27:17 -0200
Message-Id: <1358998046-613-66-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
BugLink: http://bugs.launchpad.net/bugs/1085351
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6b4226b..fe42f76 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1005,6 +1005,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	{ USB_DEVICE(0x2001, 0x3c1b) },
+	{ USB_DEVICE(0x2001, 0x3c1e) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
 	/* DVICO */
-- 
1.7.9.5

