Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaDGU2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:28:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57150 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaDGU2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:28:16 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v2 4/5] Staging: rts5139: pr_warn(...) in place of printk(KERN_WARNING ...)
Date: Mon,  7 Apr 2014 22:27:47 +0200
Message-Id: <1396902468-27906-5-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
References: <20140407003341.GA13365@kroah.com>
 <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All printk(KERN_WARNING ...) replaced with pr_warn(...).

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index 2be6210..a55b97e 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -725,8 +725,8 @@ static int rts51x_probe(struct usb_interface *intf,
 
 	rts51x = kzalloc(sizeof(struct rts51x_usb), GFP_KERNEL);
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
@@ -778,8 +778,8 @@ static int rts51x_probe(struct usb_interface *intf,
 	/* Start up our control thread */
 	th = kthread_run(rts51x_control_thread, chip, RTS51X_CTL_THREAD);
 	if (IS_ERR(th)) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to start control thread\n");
+		pr_warn(RTS51X_TIP
+			"Unable to start control thread\n");
 		result = PTR_ERR(th);
 		goto bad_device;
 	}
@@ -787,7 +787,7 @@ static int rts51x_probe(struct usb_interface *intf,
 
 	result = scsi_add_host(rts51x_to_host(chip), &rts51x->pusb_intf->dev);
 	if (result) {
-		printk(KERN_WARNING RTS51X_TIP "Unable to add the scsi host\n");
+		pr_warn(RTS51X_TIP "Unable to add the scsi host\n");
 		goto bad_device;
 	}
 	scsi_scan_host(rts51x_to_host(chip));
@@ -795,8 +795,8 @@ static int rts51x_probe(struct usb_interface *intf,
 	/* Start up our polling thread */
 	th = kthread_run(rts51x_polling_thread, chip, RTS51X_POLLING_THREAD);
 	if (IS_ERR(th)) {
-		printk(KERN_WARNING RTS51X_TIP
-		       "Unable to start polling thread\n");
+		pr_warn(RTS51X_TIP
+			"Unable to start polling thread\n");
 		result = PTR_ERR(th);
 		goto bad_device;
 	}
-- 
1.9.1

