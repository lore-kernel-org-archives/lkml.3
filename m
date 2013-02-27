Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423Ab3B0AJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:09:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760385Ab3B0AJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [ 50/86] drm/usb: bind driver to correct device
Date: Tue, 26 Feb 2013 16:07:58 -0800
Message-Id: <20130226235918.097223583@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 9f23de52b64f7fb801fd76f3dd8651a0dc89187b upstream.

While looking at plymouth on udl I noticed that plymouth was trying
to use its fb plugin not its drm one, it was trying to drmOpen a driver called
usb not udl, noticed that we actually had out driver pointing at the wrong
device.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_usb.c
+++ b/drivers/gpu/drm/drm_usb.c
@@ -18,7 +18,7 @@ int drm_get_usb_dev(struct usb_interface
 
 	usbdev = interface_to_usbdev(interface);
 	dev->usbdev = usbdev;
-	dev->dev = &usbdev->dev;
+	dev->dev = &interface->dev;
 
 	mutex_lock(&drm_global_mutex);
 


