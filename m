Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbaICKA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:00:26 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57473 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932577AbaICJ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:59:08 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Preston Fick <preston.fick@silabs.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 03/56] USB: serial: cp210x: Removing unncessary `usb_reset_device` on startup
Date: Wed,  3 Sep 2014 11:26:22 +0200
Message-Id: <664dc48e6aaa67b14a4742d1bf77bde15b1603e6.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Preston Fick <preston.fick@silabs.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 934ef5aca9daea10507eebcbd0fb8f6d57d55359 upstream.

This `usb_reset_device` command has been around since the driver was
originally reverse engineered. It doesn't cause much issue on single
interface CP210x devices, but on the CP2105 and CP2108 with 2 and 4
interfaces respectively it will cause instability on enumeration and
delays enumeration noticably. There should be no reason to reset a device
at startup, per the CP210x AN571 spec.

Signed-off-by: Preston Fick <preston.fick@silabs.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/cp210x.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 1db213a6e843..e5ac744ac73f 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -860,9 +860,6 @@ static int cp210x_startup(struct usb_serial *serial)
 	struct usb_host_interface *cur_altsetting;
 	struct cp210x_serial_private *spriv;
 
-	/* cp210x buffers behave strangely unless device is reset */
-	usb_reset_device(serial->dev);
-
 	spriv = kzalloc(sizeof(*spriv), GFP_KERNEL);
 	if (!spriv)
 		return -ENOMEM;
-- 
2.1.0

