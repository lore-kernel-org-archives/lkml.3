Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab3B1PDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:03:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3B1Otj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 093/139] drm/usb: bind driver to correct device
Date: Thu, 28 Feb 2013 14:44:03 +0000
Message-Id: <1362062689-2567-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 9f23de52b64f7fb801fd76f3dd8651a0dc89187b upstream.

While looking at plymouth on udl I noticed that plymouth was trying
to use its fb plugin not its drm one, it was trying to drmOpen a driver called
usb not udl, noticed that we actually had out driver pointing at the wrong
device.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_usb.c b/drivers/gpu/drm/drm_usb.c
index 37c9a52..767782a 100644
--- a/drivers/gpu/drm/drm_usb.c
+++ b/drivers/gpu/drm/drm_usb.c
@@ -18,7 +18,7 @@ int drm_get_usb_dev(struct usb_interface *interface,
 
 	usbdev = interface_to_usbdev(interface);
 	dev->usbdev = usbdev;
-	dev->dev = &usbdev->dev;
+	dev->dev = &interface->dev;
 
 	mutex_lock(&drm_global_mutex);
 
-- 
1.8.1.2

