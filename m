Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaGPTbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:31:42 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:48091 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaGPTbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:31:38 -0400
From: Preston Fick <pffick@gmail.com>
To: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: preston.fick@silabs.com
Subject: [PATCH 1/1] Removing unncessary `usb_reset_device` on startup
Date: Wed, 16 Jul 2014 14:31:30 -0500
Message-Id: <1405539090-5682-1-git-send-email-pffick@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Preston Fick <preston.fick@silabs.com>

This `usb_reset_device` command has been around since the driver was
originally reverse engineered. It doesn't cause much issue on single
interface CP210x devices, but on the CP2105 and CP2108 with 2 and 4
interfaces respectively it will cause instability on enumeration and
delays enumeration noticably. There should be no reason to reset a device
at startup, per the CP210x AN571 spec.

Signed-off-by: Preston Fick <preston.fick@silabs.com>
---
 drivers/usb/serial/cp210x.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 762e4a5..6891269 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -855,9 +855,6 @@ static int cp210x_startup(struct usb_serial *serial)
 	struct usb_host_interface *cur_altsetting;
 	struct cp210x_serial_private *spriv;
 
-	/* cp210x buffers behave strangely unless device is reset */
-	usb_reset_device(serial->dev);
-
 	spriv = kzalloc(sizeof(*spriv), GFP_KERNEL);
 	if (!spriv)
 		return -ENOMEM;
-- 
1.9.1

