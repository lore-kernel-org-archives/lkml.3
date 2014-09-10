Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbbAHSJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:09:38 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48948 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbbAHSJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:09:36 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Rohith Seelaboyina <rseelaboyina@nvidia.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, r.baldyga@samsung.com,
        andrzej.p@samsung.com, joe@perches.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: f_fs: refactor and document __ffs_ep0_read_events better
In-Reply-To: <20150108170236.GI31926@saruman>
Date: Wed, 10 Sep 2014 17:50:24 +0200
Organization: http://mina86.com/
References: <1419422401-8401-1-git-send-email-rseelaboyina@nvidia.com> <xa1t3885qg8k.fsf@mina86.com> <20150108170236.GI31926@saruman>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:150108:andrzej.p@samsung.com::a3zOdRhgwwVRNDm5:000000000000000000000000000000000000000002gJ
X-Hashcash: 1:20:150108:joe@perches.com::u2cGQLXHlvLZSBeC:002IQT
X-Hashcash: 1:20:150108:rseelaboyina@nvidia.com::2GmZW2NiRdftVMmT:000000000000000000000000000000000000002hhx
X-Hashcash: 1:20:150108:r.baldyga@samsung.com::wSXOfSxU8zVGdCmB:00000000000000000000000000000000000000003Y2O
X-Hashcash: 1:20:150108:balbi@ti.com::cO7G9DJ93rlrvDs0:0000049Zf
X-Hashcash: 1:20:150108:balbi@ti.com::Gg6IkWjhoAJJ/yCK:000006p/v
X-Hashcash: 1:20:150108:gregkh@linuxfoundation.org::aoNYL1cFCYo++3RH:000000000000000000000000000000000007a/k
X-Hashcash: 1:20:150108:linux-kernel@vger.kernel.org::2lFM00A6iW32NrxJ:0000000000000000000000000000000009z2k
X-Hashcash: 1:20:150108:linux-usb@vger.kernel.org::vyuClMdKx7w/Ndtg:0000000000000000000000000000000000009Pnx
Message-ID: <xa1tfvbl6t5w.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using variable length array, use a static length equal to
the size of the ffs->ev.types array.  This gets rid of a sparse warning:

	drivers/usb/gadget/function/f_fs.c:401:44: warning:
	Variable length array is used.

and makes it more explicit that the array has a very tight upper size
limit.  Also add some more documentation about the ev.types array and
how its size is limited and affects the rest of the code.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Rohith Seelaboyina <rseelaboyina@nvidia.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/function/f_fs.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 63314ed..a00ee97 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -390,17 +390,20 @@ done_spin:
 	return ret;
 }
 
+/* Called with ffs->ev.waitq.lock and ffs->mutex held, both released on exit. */
 static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 				     size_t n)
 {
 	/*
-	 * We are holding ffs->ev.waitq.lock and ffs->mutex and we need
-	 * to release them.
+	 * n cannot be bigger than ffs->ev.count, which cannot be bigger than
+	 * size of ffs->ev.types array (which is four) so that's how much space
+	 * we reserve.
 	 */
-	struct usb_functionfs_event events[n];
+	struct usb_functionfs_event events[ARRAY_SIZE(ffs->ev.types)];
+	const size_t size = n * sizeof *events;
 	unsigned i = 0;
 
-	memset(events, 0, sizeof events);
+	memset(events, 0, size);
 
 	do {
 		events[i].type = ffs->ev.types[i];
@@ -410,19 +413,15 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 		}
 	} while (++i < n);
 
-	if (n < ffs->ev.count) {
-		ffs->ev.count -= n;
+	ffs->ev.count -= n;
+	if (ffs->ev.count)
 		memmove(ffs->ev.types, ffs->ev.types + n,
 			ffs->ev.count * sizeof *ffs->ev.types);
-	} else {
-		ffs->ev.count = 0;
-	}
 
 	spin_unlock_irq(&ffs->ev.waitq.lock);
 	mutex_unlock(&ffs->mutex);
 
-	return unlikely(__copy_to_user(buf, events, sizeof events))
-		? -EFAULT : sizeof events;
+	return unlikely(__copy_to_user(buf, events, size)) ? -EFAULT : size;
 }
 
 static ssize_t ffs_ep0_read(struct file *file, char __user *buf,
@@ -2377,6 +2376,13 @@ static void __ffs_event_add(struct ffs_data *ffs,
 	if (ffs->setup_state == FFS_SETUP_PENDING)
 		ffs->setup_state = FFS_SETUP_CANCELLED;
 
+	/*
+	 * Logic of this function guarantees that there are at most four pending
+	 * evens on ffs->ev.types queue.  This is important because the queue
+	 * has space for four elements only and __ffs_ep0_read_events function
+	 * depends on that limit as well.  If more event types are added, those
+	 * limits have to be revisited or guaranteed to still hold.
+	 */
 	switch (type) {
 	case FUNCTIONFS_RESUME:
 		rem_type2 = FUNCTIONFS_SUSPEND;
-- 
2.2.0.rc0.207.ga3a616c
