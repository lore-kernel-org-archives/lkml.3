Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaDFWp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 18:45:29 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51365 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaDFWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 18:45:27 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH] Staging: rts5139: fix coding style
Date: Mon,  7 Apr 2014 00:45:05 +0200
Message-Id: <1396824306-20343-1-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix some coding style issues in rts51x.c (from rts5139 module)
This is for task 10 of the Eudyptula challenge

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 62 ++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index c8d06d4..b732d2a 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -273,7 +273,7 @@ static int rts51x_control_thread(void *__chip)
 		/* has the command timed out *already* ? */
 		if (test_bit(FLIDX_TIMED_OUT, &chip->usb->dflags)) {
 			chip->srb->result = DID_ABORT << 16;
-			goto SkipForAbort;
+			goto abort;
 		}
 
 		scsi_unlock(host);
@@ -291,15 +291,15 @@ static int rts51x_control_thread(void *__chip)
 		 */
 		else if (chip->srb->device->id) {
 			RTS51X_DEBUGP("Bad target number (%d:%d)\n",
-				       chip->srb->device->id,
-				       chip->srb->device->lun);
+				      chip->srb->device->id,
+				      chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (chip->srb->device->lun > chip->max_lun) {
 			RTS51X_DEBUGP("Bad LUN (%d:%d)\n",
-				       chip->srb->device->id,
-				       chip->srb->device->lun);
+				      chip->srb->device->id,
+				      chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
@@ -316,7 +316,7 @@ static int rts51x_control_thread(void *__chip)
 		if (chip->srb->result != DID_ABORT << 16)
 			chip->srb->scsi_done(chip->srb);
 		else
-SkipForAbort :
+abort :
 			RTS51X_DEBUGP("scsi command aborted\n");
 
 		/* If an abort request was received we need to signal that
@@ -433,12 +433,12 @@ static int associate_dev(struct rts51x_chip *chip, struct usb_interface *intf)
 	rts51x->pusb_intf = intf;
 	rts51x->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
 	RTS51X_DEBUGP("Vendor: 0x%04x, Product: 0x%04x, Revision: 0x%04x\n",
-		       le16_to_cpu(rts51x->pusb_dev->descriptor.idVendor),
-		       le16_to_cpu(rts51x->pusb_dev->descriptor.idProduct),
-		       le16_to_cpu(rts51x->pusb_dev->descriptor.bcdDevice));
+		      le16_to_cpu(rts51x->pusb_dev->descriptor.idVendor),
+		      le16_to_cpu(rts51x->pusb_dev->descriptor.idProduct),
+		      le16_to_cpu(rts51x->pusb_dev->descriptor.bcdDevice));
 	RTS51X_DEBUGP("Interface Subclass: 0x%02x, Protocol: 0x%02x\n",
-		       intf->cur_altsetting->desc.bInterfaceSubClass,
-		       intf->cur_altsetting->desc.bInterfaceProtocol);
+		      intf->cur_altsetting->desc.bInterfaceSubClass,
+		      intf->cur_altsetting->desc.bInterfaceProtocol);
 
 	/* Store our private data in the interface */
 	usb_set_intfdata(intf, chip);
@@ -569,8 +569,7 @@ static int get_pipes(struct rts51x_chip *chip)
 	}
 
 	if (!ep_in || !ep_out) {
-		RTS51X_DEBUGP("Endpoint sanity check failed!"
-					"Rejecting dev.\n");
+		RTS51X_DEBUGP("Endpoint sanity check failed! Rejecting dev.\n");
 		return -EIO;
 	}
 
@@ -608,7 +607,8 @@ static int rts51x_acquire_resources(struct rts51x_chip *chip)
 		return -ENOMEM;
 	}
 
-	chip->cmd_buf = chip->rsp_buf = rts51x->iobuf;
+	chip->cmd_buf = rts51x->iobuf;
+	chip->rsp_buf = rts51x->iobuf;
 
 	rts51x_init_options(chip);
 
@@ -723,10 +723,10 @@ static int rts51x_probe(struct usb_interface *intf,
 
 	RTS51X_DEBUGP("%s detected\n", RTS51X_NAME);
 
-	rts51x = kzalloc(sizeof(struct rts51x_usb), GFP_KERNEL);
+	rts51x = kzalloc(sizeof(*rts51x), GFP_KERNEL);
 	if (!rts51x) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to allocate rts51x_usb\n");
+		pr_warn(RTS51X_TIP
+			"Unable to allocate rts51x_usb\n");
 		return -ENOMEM;
 	}
 
@@ -736,8 +736,8 @@ static int rts51x_probe(struct usb_interface *intf,
 	 */
 	host = scsi_host_alloc(&rts51x_host_template, sizeof(*chip));
 	if (!host) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to allocate the scsi host\n");
+		pr_warn(RTS51X_TIP
+			"Unable to allocate the scsi host\n");
 		kfree(rts51x);
 		return -ENOMEM;
 	}
@@ -763,42 +763,42 @@ static int rts51x_probe(struct usb_interface *intf,
 	/* Associate the us_data structure with the USB device */
 	result = associate_dev(chip, intf);
 	if (result)
-		goto BadDevice;
+		goto bad_device;
 
 	/* Find the endpoints and calculate pipe values */
 	result = get_pipes(chip);
 	if (result)
-		goto BadDevice;
+		goto bad_device;
 
 	/* Acquire all the other resources and add the host */
 	result = rts51x_acquire_resources(chip);
 	if (result)
-		goto BadDevice;
+		goto bad_device;
 
 	/* Start up our control thread */
 	th = kthread_run(rts51x_control_thread, chip, RTS51X_CTL_THREAD);
 	if (IS_ERR(th)) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to start control thread\n");
+		pr_warn(RTS51X_TIP
+			"Unable to start control thread\n");
 		result = PTR_ERR(th);
-		goto BadDevice;
+		goto bad_device;
 	}
 	rts51x->ctl_thread = th;
 
 	result = scsi_add_host(rts51x_to_host(chip), &rts51x->pusb_intf->dev);
 	if (result) {
-		printk(KERN_WARNING RTS51X_TIP "Unable to add the scsi host\n");
-		goto BadDevice;
+		pr_warn(RTS51X_TIP "Unable to add the scsi host\n");
+		goto bad_device;
 	}
 	scsi_scan_host(rts51x_to_host(chip));
 
 	/* Start up our polling thread */
 	th = kthread_run(rts51x_polling_thread, chip, RTS51X_POLLING_THREAD);
 	if (IS_ERR(th)) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to start polling thread\n");
+		pr_warn(RTS51X_TIP
+			"Unable to start polling thread\n");
 		result = PTR_ERR(th);
-		goto BadDevice;
+		goto bad_device;
 	}
 	rts51x->polling_thread = th;
 
@@ -813,7 +813,7 @@ static int rts51x_probe(struct usb_interface *intf,
 	return 0;
 
 	/* We come here if there are any problems */
-BadDevice:
+bad_device:
 	RTS51X_DEBUGP("rts51x_probe() failed\n");
 	release_everything(chip);
 	return result;
-- 
1.9.1

