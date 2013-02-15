Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3BOTfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:35:33 -0500
Received: from mout.gmx.net ([212.227.15.19]:59113 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab3BOTfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:35:31 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/iVDANSQfiyN6mU7ArXYtZ58e4bkIp2hs+s53U6w
	pexNz0oKTLJqK2
From: Peter Huewe <peterhuewe@gmx.de>
To: Matt Mooney <mfm@muteddisk.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/usbip: Mark local functions as static (fix sparse warnings)
Date: Fri, 15 Feb 2013 20:39:57 +0100
Message-Id: <1360957197-16264-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse complains about these functions:
usbip/stub_dev.c:529:5: warning: symbol 'stub_pre_reset' was not declared. Should it be static?
usbip/stub_dev.c:535:5: warning: symbol 'stub_post_reset' was not declared. Should it be static?

-> add static keyword to silence the warning and make sparse happy.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/usbip/stub_dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index ca5de9d..67556ac 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -526,13 +526,13 @@ static void stub_disconnect(struct usb_interface *interface)
  * when the device is being reset
  */
 
-int stub_pre_reset(struct usb_interface *interface)
+static int stub_pre_reset(struct usb_interface *interface)
 {
 	dev_dbg(&interface->dev, "pre_reset\n");
 	return 0;
 }
 
-int stub_post_reset(struct usb_interface *interface)
+static int stub_post_reset(struct usb_interface *interface)
 {
 	dev_dbg(&interface->dev, "post_reset\n");
 	return 0;
-- 
1.7.8.6

