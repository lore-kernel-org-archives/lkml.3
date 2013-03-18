Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3CREb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33556 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab3CREah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:37 -0400
Message-Id: <20130318042149.467578225@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 54/82] staging: vt6656: Fix oops on resume from suspend.
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 6987a6dabfc40222ef767f67b57212fe3a0225fb upstream.

Remove usb_put_dev from vt6656_suspend and usb_get_dev
from vt6566_resume.

These are not normally in suspend/resume functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/main_usb.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -718,8 +718,6 @@ static int vt6656_suspend(struct usb_int
 	if (device->flags & DEVICE_FLAGS_OPENED)
 		device_close(device->dev);
 
-	usb_put_dev(interface_to_usbdev(intf));
-
 	return 0;
 }
 
@@ -730,8 +728,6 @@ static int vt6656_resume(struct usb_inte
 	if (!device || !device->dev)
 		return -ENODEV;
 
-	usb_get_dev(interface_to_usbdev(intf));
-
 	if (!(device->flags & DEVICE_FLAGS_OPENED))
 		device_open(device->dev);
 


