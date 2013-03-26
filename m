Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693Ab3CZPVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:21:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53480 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934669Ab3CZPVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 006/150] staging: vt6656: Fix oops on resume from suspend.
Date: Tue, 26 Mar 2013 15:18:25 +0000
Message-Id: <1364311249-14454-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 6987a6dabfc40222ef767f67b57212fe3a0225fb upstream.

Remove usb_put_dev from vt6656_suspend and usb_get_dev
from vt6566_resume.

These are not normally in suspend/resume functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/vt6656/main_usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b318806..fa6dbe0 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -718,8 +718,6 @@ static int vt6656_suspend(struct usb_interface *intf, pm_message_t message)
 	if (device->flags & DEVICE_FLAGS_OPENED)
 		device_close(device->dev);
 
-	usb_put_dev(interface_to_usbdev(intf));
-
 	return 0;
 }
 
@@ -730,8 +728,6 @@ static int vt6656_resume(struct usb_interface *intf)
 	if (!device || !device->dev)
 		return -ENODEV;
 
-	usb_get_dev(interface_to_usbdev(intf));
-
 	if (!(device->flags & DEVICE_FLAGS_OPENED))
 		device_open(device->dev);
 
-- 
1.8.1.2

