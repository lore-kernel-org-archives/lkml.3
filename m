Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3KKX5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:57:37 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55088 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3KKX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:57:25 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCHv5.1 3/5] usb: gadget: f_fs: remove loop from I/O function
In-Reply-To: <1384201011-11114-4-git-send-email-david.a.cohen@linux.intel.com>
Organization: http://mina86.com/
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-4-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::SBV59BMOFrgX843z:00000000000000000000000000000000015wu
X-Hashcash: 1:20:131111:balbi@ti.com::z6IvUFp1KCjKoQWh:000000NH9
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::61QxmR54+OzsdlcD:000000000000000000000000000000002Y9t
X-Hashcash: 1:20:131111:stern@rowland.harvard.edu::m8tOE9MRBkQS+L8j:000000000000000000000000000000000000239J
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::8XhvY7pn6Y3tP1O1:000000000000000000000000000000004z7A
X-Hashcash: 1:20:131111:linux-usb@vger.kernel.org::MSz+n//D7xwaeeM/:000000000000000000000000000000000000554s
X-Hashcash: 1:20:131111:gregkh@linuxfoundation.org::+MMu0sYbO8Hgp1ID:000000000000000000000000000000000005JKe
Date: Tue, 12 Nov 2013 00:57:22 +0100
Message-ID: <xa1twqkewkyl.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When endpoint changes (due to it being disabled or alt setting changed),
mimic the action as if the change happened after the request has been
queued, instead of retrying with the new endpoint.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c | 94 ++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 54 deletions(-)

Fixed checkpatch.pl issues pointed out by David.

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 0658908..6cb0b22 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -758,73 +758,59 @@ static ssize_t ffs_epfile_io(struct file *file,
 	ssize_t ret;
 	int halt;
 
-	goto first_try;
-	do {
-		spin_unlock_irq(&epfile->ffs->eps_lock);
-		mutex_unlock(&epfile->mutex);
+	/* Are we still active? */
+	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE)) {
+		ret = -ENODEV;
+		goto error;
+	}
 
-first_try:
-		/* Are we still active? */
-		if (WARN_ON(epfile->ffs->state != FFS_ACTIVE)) {
-			ret = -ENODEV;
+	/* Wait for endpoint to be enabled */
+	ep = epfile->ep;
+	if (!ep) {
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
 			goto error;
 		}
 
-		/* Wait for endpoint to be enabled */
-		ep = epfile->ep;
-		if (!ep) {
-			if (file->f_flags & O_NONBLOCK) {
-				ret = -EAGAIN;
-				goto error;
-			}
-
-			if (wait_event_interruptible(epfile->wait,
-						     (ep = epfile->ep))) {
-				ret = -EINTR;
-				goto error;
-			}
-		}
-
-		/* Do we halt? */
-		halt = !read == !epfile->in;
-		if (halt && epfile->isoc) {
-			ret = -EINVAL;
+		ret = wait_event_interruptible(epfile->wait, (ep = epfile->ep));
+		if (ret) {
+			ret = -EINTR;
 			goto error;
 		}
+	}
 
-		/* Allocate & copy */
-		if (!halt && !data) {
-			data = kzalloc(len, GFP_KERNEL);
-			if (unlikely(!data))
-				return -ENOMEM;
+	/* Do we halt? */
+	halt = !read == !epfile->in;
+	if (halt && epfile->isoc) {
+		ret = -EINVAL;
+		goto error;
+	}
 
-			if (!read &&
-			    unlikely(__copy_from_user(data, buf, len))) {
-				ret = -EFAULT;
-				goto error;
-			}
-		}
+	/* Allocate & copy */
+	if (!halt) {
+		data = kmalloc(len, GFP_KERNEL);
+		if (unlikely(!data))
+			return -ENOMEM;
 
-		/* We will be using request */
-		ret = ffs_mutex_lock(&epfile->mutex,
-				     file->f_flags & O_NONBLOCK);
-		if (unlikely(ret))
+		if (!read && unlikely(copy_from_user(data, buf, len))) {
+			ret = -EFAULT;
 			goto error;
+		}
+	}
 
-		/*
-		 * We're called from user space, we can use _irq rather then
-		 * _irqsave
-		 */
-		spin_lock_irq(&epfile->ffs->eps_lock);
+	/* We will be using request */
+	ret = ffs_mutex_lock(&epfile->mutex, file->f_flags & O_NONBLOCK);
+	if (unlikely(ret))
+		goto error;
 
-		/*
-		 * While we were acquiring mutex endpoint got disabled
-		 * or changed?
-		 */
-	} while (unlikely(epfile->ep != ep));
+	spin_lock_irq(&epfile->ffs->eps_lock);
 
-	/* Halt */
-	if (unlikely(halt)) {
+	if (epfile->ep != ep) {
+		/* In the meantime, endpoint got disabled or changed. */
+		ret = -ESHUTDOWN;
+		spin_unlock_irq(&epfile->ffs->eps_lock);
+	} else if (halt) {
+		/* Halt */
 		if (likely(epfile->ep == ep) && !WARN_ON(!ep->ep))
 			usb_ep_set_halt(ep->ep);
 		spin_unlock_irq(&epfile->ffs->eps_lock);
-- 
1.8.4.1

