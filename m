Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbaDVV0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:26:39 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60079 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbaDVVXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:23:46 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v3 4/6] Staging: rts5139: Use standard pr_<level> prefixing
Date: Tue, 22 Apr 2014 23:23:02 +0200
Message-Id: <1398201784-7602-5-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define pr_fmt macro to prefix every pr_<level> function in standard way.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 100 +++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index 2be6210..8a0f9ae 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -23,6 +23,8 @@
  *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -109,13 +111,13 @@ static inline void usb_autopm_disable(struct usb_interface *intf)
 
 static void rts51x_try_to_enter_ss(struct rts51x_chip *chip)
 {
-	RTS51X_DEBUGP("Ready to enter SS state\n");
+	pr_debug("Ready to enter SS state\n");
 	usb_autopm_enable(chip->usb->pusb_intf);
 }
 
 void rts51x_try_to_exit_ss(struct rts51x_chip *chip)
 {
-	RTS51X_DEBUGP("Exit from SS state\n");
+	pr_debug("Exit from SS state\n");
 	usb_autopm_disable(chip->usb->pusb_intf);
 }
 
@@ -123,7 +125,7 @@ int rts51x_suspend(struct usb_interface *iface, pm_message_t message)
 {
 	struct rts51x_chip *chip = usb_get_intfdata(iface);
 
-	RTS51X_DEBUGP("%s, message.event = 0x%x\n", __func__, message.event);
+	pr_debug("%s, message.event = 0x%x\n", __func__, message.event);
 
 	/* Wait until no command is running */
 	mutex_lock(&chip->usb->dev_mutex);
@@ -132,11 +134,11 @@ int rts51x_suspend(struct usb_interface *iface, pm_message_t message)
 	rts51x_do_before_power_down(chip);
 
 	if (message.event == PM_EVENT_AUTO_SUSPEND) {
-		RTS51X_DEBUGP("Enter SS state");
+		pr_debug("Enter SS state");
 		chip->resume_from_scsi = 0;
 		RTS51X_SET_STAT(chip, STAT_SS);
 	} else {
-		RTS51X_DEBUGP("Enter SUSPEND state");
+		pr_debug("Enter SUSPEND state");
 		RTS51X_SET_STAT(chip, STAT_SUSPEND);
 	}
 
@@ -151,7 +153,7 @@ int rts51x_resume(struct usb_interface *iface)
 {
 	struct rts51x_chip *chip = usb_get_intfdata(iface);
 
-	RTS51X_DEBUGP("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	if (!RTS51X_CHK_STAT(chip, STAT_SS) || !chip->resume_from_scsi) {
 		mutex_lock(&chip->usb->dev_mutex);
@@ -159,7 +161,7 @@ int rts51x_resume(struct usb_interface *iface)
 		if (chip->option.ss_en) {
 			if (GET_PM_USAGE_CNT(chip) <= 0) {
 				/* Remote wake up, increase pm_usage_cnt */
-				RTS51X_DEBUGP("Incr pm_usage_cnt\n");
+				pr_debug("Incr pm_usage_cnt\n");
 				SET_PM_USAGE_CNT(chip, 1);
 			}
 		}
@@ -179,7 +181,7 @@ int rts51x_reset_resume(struct usb_interface *iface)
 {
 	struct rts51x_chip *chip = usb_get_intfdata(iface);
 
-	RTS51X_DEBUGP("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	mutex_lock(&chip->usb->dev_mutex);
 
@@ -219,7 +221,7 @@ static int rts51x_pre_reset(struct usb_interface *iface)
 {
 	struct rts51x_chip *chip = usb_get_intfdata(iface);
 
-	RTS51X_DEBUGP("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	/* Make sure no command runs during the reset */
 	mutex_lock(&chip->usb->dev_mutex);
@@ -230,7 +232,7 @@ static int rts51x_post_reset(struct usb_interface *iface)
 {
 	struct rts51x_chip *chip = usb_get_intfdata(iface);
 
-	RTS51X_DEBUGP("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	/* Report the reset to the SCSI core */
 	/* usb_stor_report_bus_reset(us); */
@@ -252,7 +254,7 @@ static int rts51x_control_thread(void *__chip)
 			break;
 
 		if (test_bit(FLIDX_DISCONNECTING, &chip->usb->dflags)) {
-			RTS51X_DEBUGP("-- exiting from rts51x-control\n");
+			pr_debug("-- exiting from rts51x-control\n");
 			break;
 		}
 
@@ -266,7 +268,7 @@ static int rts51x_control_thread(void *__chip)
 		if (chip->srb == NULL) {
 			scsi_unlock(host);
 			mutex_unlock(&chip->usb->dev_mutex);
-			RTS51X_DEBUGP("-- exiting from control thread\n");
+			pr_debug("-- exiting from control thread\n");
 			break;
 		}
 
@@ -282,7 +284,7 @@ static int rts51x_control_thread(void *__chip)
 		 * is UNKNOWN
 		 */
 		if (chip->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
-			RTS51X_DEBUGP("UNKNOWN data direction\n");
+			pr_debug("UNKNOWN data direction\n");
 			chip->srb->result = DID_ERROR << 16;
 		}
 
@@ -290,16 +292,16 @@ static int rts51x_control_thread(void *__chip)
 		 * the maximum known LUN
 		 */
 		else if (chip->srb->device->id) {
-			RTS51X_DEBUGP("Bad target number (%d:%d)\n",
-				      chip->srb->device->id,
-				      chip->srb->device->lun);
+			pr_debug("Bad target number (%d:%d)\n",
+				 chip->srb->device->id,
+				 chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (chip->srb->device->lun > chip->max_lun) {
-			RTS51X_DEBUGP("Bad LUN (%d:%d)\n",
-				      chip->srb->device->id,
-				      chip->srb->device->lun);
+			pr_debug("Bad LUN (%d:%d)\n",
+				 chip->srb->device->id,
+				 chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
@@ -317,7 +319,7 @@ static int rts51x_control_thread(void *__chip)
 			chip->srb->scsi_done(chip->srb);
 		else
 abort :
-			RTS51X_DEBUGP("scsi command aborted\n");
+			pr_debug("scsi command aborted\n");
 
 		/* If an abort request was received we need to signal that
 		 * the abort has finished.  The proper test for this is
@@ -362,7 +364,7 @@ static int rts51x_polling_thread(void *__chip)
 
 		/* if the device has disconnected, we are free to exit */
 		if (test_bit(FLIDX_DISCONNECTING, &chip->usb->dflags)) {
-			RTS51X_DEBUGP("-- exiting from rts51x-polling\n");
+			pr_debug("-- exiting from rts51x-polling\n");
 			break;
 		}
 
@@ -432,13 +434,13 @@ static int associate_dev(struct rts51x_chip *chip, struct usb_interface *intf)
 	rts51x->pusb_dev = interface_to_usbdev(intf);
 	rts51x->pusb_intf = intf;
 	rts51x->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
-	RTS51X_DEBUGP("Vendor: 0x%04x, Product: 0x%04x, Revision: 0x%04x\n",
-		      le16_to_cpu(rts51x->pusb_dev->descriptor.idVendor),
-		      le16_to_cpu(rts51x->pusb_dev->descriptor.idProduct),
-		      le16_to_cpu(rts51x->pusb_dev->descriptor.bcdDevice));
-	RTS51X_DEBUGP("Interface Subclass: 0x%02x, Protocol: 0x%02x\n",
-		      intf->cur_altsetting->desc.bInterfaceSubClass,
-		      intf->cur_altsetting->desc.bInterfaceProtocol);
+	pr_debug("Vendor: 0x%04x, Product: 0x%04x, Revision: 0x%04x\n",
+		 le16_to_cpu(rts51x->pusb_dev->descriptor.idVendor),
+		 le16_to_cpu(rts51x->pusb_dev->descriptor.idProduct),
+		 le16_to_cpu(rts51x->pusb_dev->descriptor.bcdDevice));
+	pr_debug("Interface Subclass: 0x%02x, Protocol: 0x%02x\n",
+		 intf->cur_altsetting->desc.bInterfaceSubClass,
+		 intf->cur_altsetting->desc.bInterfaceProtocol);
 
 	/* Store our private data in the interface */
 	usb_set_intfdata(intf, chip);
@@ -448,7 +450,7 @@ static int associate_dev(struct rts51x_chip *chip, struct usb_interface *intf)
 	retval = usb_register_dev(intf, &rts51x_class);
 	if (retval) {
 		/* something prevented us from registering this driver */
-		RTS51X_DEBUGP("Not able to get a minor for this device.");
+		pr_debug("Not able to get a minor for this device.");
 		usb_set_intfdata(intf, NULL);
 		return -ENOMEM;
 	}
@@ -458,7 +460,7 @@ static int associate_dev(struct rts51x_chip *chip, struct usb_interface *intf)
 	rts51x->cr = usb_buffer_alloc(rts51x->pusb_dev, sizeof(*rts51x->cr),
 				      GFP_KERNEL, &rts51x->cr_dma);
 	if (!rts51x->cr) {
-		RTS51X_DEBUGP("usb_ctrlrequest allocation failed\n");
+		pr_debug("usb_ctrlrequest allocation failed\n");
 		usb_set_intfdata(intf, NULL);
 		return -ENOMEM;
 	}
@@ -466,7 +468,7 @@ static int associate_dev(struct rts51x_chip *chip, struct usb_interface *intf)
 	rts51x->iobuf = usb_buffer_alloc(rts51x->pusb_dev, RTS51X_IOBUF_SIZE,
 					 GFP_KERNEL, &rts51x->iobuf_dma);
 	if (!rts51x->iobuf) {
-		RTS51X_DEBUGP("I/O buffer allocation failed\n");
+		pr_debug("I/O buffer allocation failed\n");
 		usb_set_intfdata(intf, NULL);
 		return -ENOMEM;
 	}
@@ -569,7 +571,7 @@ static int get_pipes(struct rts51x_chip *chip)
 	}
 
 	if (!ep_in || !ep_out) {
-		RTS51X_DEBUGP("Endpoint sanity check failed! Rejecting dev.\n");
+		pr_debug("Endpoint sanity check failed! Rejecting dev.\n");
 		return -EIO;
 	}
 
@@ -597,13 +599,13 @@ static int rts51x_acquire_resources(struct rts51x_chip *chip)
 
 	rts51x->current_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!rts51x->current_urb) {
-		RTS51X_DEBUGP("URB allocation failed\n");
+		pr_debug("URB allocation failed\n");
 		return -ENOMEM;
 	}
 
 	rts51x->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!rts51x->intr_urb) {
-		RTS51X_DEBUGP("URB allocation failed\n");
+		pr_debug("URB allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -623,13 +625,13 @@ static int rts51x_acquire_resources(struct rts51x_chip *chip)
 /* Release all our dynamic resources */
 static void rts51x_release_resources(struct rts51x_chip *chip)
 {
-	RTS51X_DEBUGP("-- %s\n", __func__);
+	pr_debug("-- %s\n", __func__);
 
 	/* Tell the control thread to exit.  The SCSI host must
 	 * already have been removed and the DISCONNECTING flag set
 	 * so that we won't accept any more commands.
 	 */
-	RTS51X_DEBUGP("-- sending exit command to thread\n");
+	pr_debug("-- sending exit command to thread\n");
 	complete(&chip->usb->cmnd_ready);
 	if (chip->usb->ctl_thread)
 		wait_for_completion(&chip->usb->control_exit);
@@ -654,7 +656,7 @@ static void dissociate_dev(struct rts51x_chip *chip)
 {
 	struct rts51x_usb *rts51x = chip->usb;
 
-	RTS51X_DEBUGP("-- %s\n", __func__);
+	pr_debug("-- %s\n", __func__);
 
 	/* Free the device-related DMA-mapped buffers */
 	if (rts51x->cr)
@@ -721,12 +723,12 @@ static int rts51x_probe(struct usb_interface *intf,
 	int result;
 	struct task_struct *th;
 
-	RTS51X_DEBUGP("%s detected\n", RTS51X_NAME);
+	pr_debug("%s detected\n", RTS51X_NAME);
 
 	rts51x = kzalloc(sizeof(struct rts51x_usb), GFP_KERNEL);
 	if (!rts51x) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to allocate rts51x_usb\n");
+		pr_warn(RTS51X_TIP
+			"Unable to allocate rts51x_usb\n");
 		return -ENOMEM;
 	}
 
@@ -736,8 +738,8 @@ static int rts51x_probe(struct usb_interface *intf,
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
@@ -778,8 +780,7 @@ static int rts51x_probe(struct usb_interface *intf,
 	/* Start up our control thread */
 	th = kthread_run(rts51x_control_thread, chip, RTS51X_CTL_THREAD);
 	if (IS_ERR(th)) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to start control thread\n");
+		pr_warn("Unable to start control thread\n");
 		result = PTR_ERR(th);
 		goto bad_device;
 	}
@@ -787,7 +788,7 @@ static int rts51x_probe(struct usb_interface *intf,
 
 	result = scsi_add_host(rts51x_to_host(chip), &rts51x->pusb_intf->dev);
 	if (result) {
-		printk(KERN_WARNING RTS51X_TIP "Unable to add the scsi host\n");
+		pr_warn("Unable to add the scsi host\n");
 		goto bad_device;
 	}
 	scsi_scan_host(rts51x_to_host(chip));
@@ -795,8 +796,7 @@ static int rts51x_probe(struct usb_interface *intf,
 	/* Start up our polling thread */
 	th = kthread_run(rts51x_polling_thread, chip, RTS51X_POLLING_THREAD);
 	if (IS_ERR(th)) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to start polling thread\n");
+		pr_warn("Unable to start polling thread\n");
 		result = PTR_ERR(th);
 		goto bad_device;
 	}
@@ -806,7 +806,7 @@ static int rts51x_probe(struct usb_interface *intf,
 	if (ss_en) {
 		rts51x->pusb_intf->needs_remote_wakeup = needs_remote_wakeup;
 		SET_PM_USAGE_CNT(chip, 1);
-		RTS51X_DEBUGP("pm_usage_cnt = %d\n", GET_PM_USAGE_CNT(chip));
+		pr_debug("pm_usage_cnt = %d\n", GET_PM_USAGE_CNT(chip));
 	}
 #endif
 
@@ -814,7 +814,7 @@ static int rts51x_probe(struct usb_interface *intf,
 
 	/* We come here if there are any problems */
 bad_device:
-	RTS51X_DEBUGP("rts51x_probe() failed\n");
+	pr_debug("rts51x_probe() failed\n");
 	release_everything(chip);
 	return result;
 }
@@ -823,7 +823,7 @@ static void rts51x_disconnect(struct usb_interface *intf)
 {
 	struct rts51x_chip *chip = (struct rts51x_chip *)usb_get_intfdata(intf);
 
-	RTS51X_DEBUGP("rts51x_disconnect() called\n");
+	pr_debug("rts51x_disconnect() called\n");
 	quiesce_and_remove_host(chip);
 	release_everything(chip);
 }
-- 
1.9.1

