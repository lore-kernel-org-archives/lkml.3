Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3CRVGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:06:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3CRVGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 14/75] staging: vt6656: Fix oops on resume from suspend.
Date: Mon, 18 Mar 2013 14:06:37 -0700
Message-Id: <20130318210511.259444898@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 6987a6dabfc40222ef767f67b57212fe3a0225fb upstream.

Remove usb_put_dev from vt6656_suspend and usb_get_dev
from vt6566_resume.

These are not normally in suspend/resume functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/main_usb.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -644,8 +644,6 @@ static int vt6656_suspend(struct usb_int
 	if (device->flags & DEVICE_FLAGS_OPENED)
 		device_close(device->dev);
 
-	usb_put_dev(interface_to_usbdev(intf));
-
 	return 0;
 }
 
@@ -656,8 +654,6 @@ static int vt6656_resume(struct usb_inte
 	if (!device || !device->dev)
 		return -ENODEV;
 
-	usb_get_dev(interface_to_usbdev(intf));
-
 	if (!(device->flags & DEVICE_FLAGS_OPENED))
 		device_open(device->dev);
 


