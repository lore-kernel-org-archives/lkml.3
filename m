Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaJUKVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:21:44 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60112 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbaJUKVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:21:43 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: hub: remove unused variable
Date: Tue, 21 Oct 2014 15:51:34 +0530
Message-Id: <1413886894-21534-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the integer variable 'feature' was not being used anywhere in the function.
so it is safe to remove the variable.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/usb/core/hub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 11e80ac..7eb45cd 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3907,14 +3907,9 @@ static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
 static int usb_disable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
 		enum usb3_link_state state)
 {
-	int feature;
-
 	switch (state) {
 	case USB3_LPM_U1:
-		feature = USB_PORT_FEAT_U1_TIMEOUT;
-		break;
 	case USB3_LPM_U2:
-		feature = USB_PORT_FEAT_U2_TIMEOUT;
 		break;
 	default:
 		dev_warn(&udev->dev, "%s: Can't disable non-U1 or U2 state.\n",
-- 
1.8.1.2

