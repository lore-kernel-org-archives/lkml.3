Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbaDVVXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:23:52 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46469 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731AbaDVVXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:23:48 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v3 5/6] Staging: rts5139: Removed OOM messages
Date: Tue, 22 Apr 2014 23:23:03 +0200
Message-Id: <1398201784-7602-6-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All allocation Out Of Memory messages removed.
We rely on the generic OOM message in dump_stack().

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index 8a0f9ae..6120410 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -460,7 +460,6 @@ static int associate_dev(struct rts51x_chip *chip, struct usb_interface *intf)
 	rts51x->cr = usb_buffer_alloc(rts51x->pusb_dev, sizeof(*rts51x->cr),
 				      GFP_KERNEL, &rts51x->cr_dma);
 	if (!rts51x->cr) {
-		pr_debug("usb_ctrlrequest allocation failed\n");
 		usb_set_intfdata(intf, NULL);
 		return -ENOMEM;
 	}
@@ -468,7 +467,6 @@ static int associate_dev(struct rts51x_chip *chip, struct usb_interface *intf)
 	rts51x->iobuf = usb_buffer_alloc(rts51x->pusb_dev, RTS51X_IOBUF_SIZE,
 					 GFP_KERNEL, &rts51x->iobuf_dma);
 	if (!rts51x->iobuf) {
-		pr_debug("I/O buffer allocation failed\n");
 		usb_set_intfdata(intf, NULL);
 		return -ENOMEM;
 	}
@@ -598,16 +596,12 @@ static int rts51x_acquire_resources(struct rts51x_chip *chip)
 	int retval;
 
 	rts51x->current_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rts51x->current_urb) {
-		pr_debug("URB allocation failed\n");
+	if (!rts51x->current_urb)
 		return -ENOMEM;
-	}
 
 	rts51x->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rts51x->intr_urb) {
-		pr_debug("URB allocation failed\n");
+	if (!rts51x->intr_urb)
 		return -ENOMEM;
-	}
 
 	chip->cmd_buf = rts51x->iobuf;
 	chip->rsp_buf = rts51x->iobuf;
@@ -726,11 +720,8 @@ static int rts51x_probe(struct usb_interface *intf,
 	pr_debug("%s detected\n", RTS51X_NAME);
 
 	rts51x = kzalloc(sizeof(struct rts51x_usb), GFP_KERNEL);
-	if (!rts51x) {
-		pr_warn(RTS51X_TIP
-			"Unable to allocate rts51x_usb\n");
+	if (!rts51x)
 		return -ENOMEM;
-	}
 
 	/*
 	 * Ask the SCSI layer to allocate a host structure, with extra
@@ -738,8 +729,6 @@ static int rts51x_probe(struct usb_interface *intf,
 	 */
 	host = scsi_host_alloc(&rts51x_host_template, sizeof(*chip));
 	if (!host) {
-		pr_warn(RTS51X_TIP
-			"Unable to allocate the scsi host\n");
 		kfree(rts51x);
 		return -ENOMEM;
 	}
-- 
1.9.1

