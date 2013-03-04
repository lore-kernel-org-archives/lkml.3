Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3CDDou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757176Ab3CDDos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:48 -0500
Message-Id: <20130304033710.821322743@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dave Airlie <airlied@redhat.com>
Subject: [ 033/153] drm/usb: bind driver to correct device
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 9f23de52b64f7fb801fd76f3dd8651a0dc89187b upstream.

While looking at plymouth on udl I noticed that plymouth was trying
to use its fb plugin not its drm one, it was trying to drmOpen a driver called
usb not udl, noticed that we actually had out driver pointing at the wrong
device.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_usb.c
+++ b/drivers/gpu/drm/drm_usb.c
@@ -19,7 +19,7 @@ int drm_get_usb_dev(struct usb_interface
 
 	usbdev = interface_to_usbdev(interface);
 	dev->usbdev = usbdev;
-	dev->dev = &usbdev->dev;
+	dev->dev = &interface->dev;
 
 	mutex_lock(&drm_global_mutex);
 


