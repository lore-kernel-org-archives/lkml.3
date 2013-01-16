Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3APQAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3APQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 049/222] usb: ftdi_sio: fixup BeagleBone A5+ quirk
Date: Wed, 16 Jan 2013 13:54:09 -0200
Message-Id: <1358351822-7675-50-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <jacmet@sunsite.dk>

commit 1a88d5eee2ef2ad1d3c4e32043e9c4c5347d4fc1 upstream.

BeagleBone A5+ devices ended up getting shipped with the
'BeagleBone/XDS100V2' product string, and not XDS100 like it
was agreed, so adjust the quirk to match.

For details, see the thread on the beagle list:

https://groups.google.com/forum/#!msg/beagleboard/zrFPew9_Wvo/ibWr1-eE8JwJ

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index b71ee32..d0b8c5c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1787,7 +1787,7 @@ static int ftdi_8u2232c_probe(struct usb_serial *serial)
 	struct usb_device *udev = serial->dev;
 
 	if ((udev->manufacturer && !strcmp(udev->manufacturer, "CALAO Systems")) ||
-	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100")))
+	    (udev->product && !strcmp(udev->product, "BeagleBone/XDS100V2")))
 		return ftdi_jtag_probe(serial);
 
 	return 0;
-- 
1.7.9.5

