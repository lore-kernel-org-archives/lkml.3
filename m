Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbaDVVXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:23:40 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64307 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbaDVVXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:23:38 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v3 1/6] Staging: rts5139: Camel case labels replaced
Date: Tue, 22 Apr 2014 23:22:59 +0200
Message-Id: <1398201784-7602-2-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace camel case labels with linux coding style compliant names.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index c8d06d4..9d9c706 100644
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
@@ -316,7 +316,7 @@ static int rts51x_control_thread(void *__chip)
 		if (chip->srb->result != DID_ABORT << 16)
 			chip->srb->scsi_done(chip->srb);
 		else
-SkipForAbort :
+abort :
 			RTS51X_DEBUGP("scsi command aborted\n");
 
 		/* If an abort request was received we need to signal that
@@ -763,17 +763,17 @@ static int rts51x_probe(struct usb_interface *intf,
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
@@ -781,14 +781,14 @@ static int rts51x_probe(struct usb_interface *intf,
 		printk(KERN_WARNING RTS51X_TIP
 		       "Unable to start control thread\n");
 		result = PTR_ERR(th);
-		goto BadDevice;
+		goto bad_device;
 	}
 	rts51x->ctl_thread = th;
 
 	result = scsi_add_host(rts51x_to_host(chip), &rts51x->pusb_intf->dev);
 	if (result) {
 		printk(KERN_WARNING RTS51X_TIP "Unable to add the scsi host\n");
-		goto BadDevice;
+		goto bad_device;
 	}
 	scsi_scan_host(rts51x_to_host(chip));
 
@@ -798,7 +798,7 @@ static int rts51x_probe(struct usb_interface *intf,
 		printk(KERN_WARNING RTS51X_TIP
 		       "Unable to start polling thread\n");
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

