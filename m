Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaCJIhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:37:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49404 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaCJIhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:37:01 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 2/2] staging: usbip: rename struct dev_state to usb_dev_state
Date: Mon, 10 Mar 2014 10:36:41 +0200
Message-Id: <1394440601-13573-3-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1394440601-13573-1-git-send-email-valentina.manea.m@gmail.com>
References: <1394440601-13573-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct dev_state definition in usbcore conflicted with
enum dev_state definition in rt2x00 driver so it was
renamed to usb_dev_state.

Update usbip for this change.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/stub_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 952743c..773d8ca 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -395,7 +395,7 @@ static int stub_probe(struct usb_device *udev)
 	 * (struct dev_state) as long as it is unique.
 	 */
 	rc = usb_hub_claim_port(udev->parent, udev->portnum,
-			(struct dev_state *) udev);
+			(struct usb_dev_state *) udev);
 	if (rc) {
 		dev_dbg(&udev->dev, "unable to claim port\n");
 		return rc;
@@ -464,7 +464,7 @@ static void stub_disconnect(struct usb_device *udev)
 
 	/* release port */
 	rc = usb_hub_release_port(udev->parent, udev->portnum,
-				  (struct dev_state *) udev);
+				  (struct usb_dev_state *) udev);
 	if (rc) {
 		dev_dbg(&udev->dev, "unable to release port\n");
 		return;
-- 
1.8.1.2

