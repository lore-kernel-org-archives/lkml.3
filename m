Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3KKX7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:59:06 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39676 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3KKX67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:58:59 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv5.1 4/5] check quirk to pad epout buf size when not aligned to
 maxpacketsize
In-Reply-To: <1384201011-11114-5-git-send-email-david.a.cohen@linux.intel.com>
Organization: http://mina86.com/
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-5-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:linux-usb@vger.kernel.org::aiyJnXEIDSYuk5ou:00000000000000000000000000000000000015Jz
X-Hashcash: 1:20:131111:stern@rowland.harvard.edu::xKXUN8JCJOBpK5pB:0000000000000000000000000000000000002FgE
X-Hashcash: 1:20:131111:balbi@ti.com::xxUxq/1bKEbFguN4:000002bqh
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::MFeJWiYbymNjgRmo:000000000000000000000000000000000JX0
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::Afx7O1GxyaR+UQOF:0000000000000000000000000000000005ieE
X-Hashcash: 1:20:131111:gregkh@linuxfoundation.org::gjbK1Y3N1fPYl26E:000000000000000000000000000000000001+EL
Date: Tue, 12 Nov 2013 00:58:55 +0100
Message-ID: <xa1ttxfiwkw0.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
to pad epout buffer to match above condition if quirk is found.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_fs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

On Tue, Nov 12 2013, David Cohen wrote:
> One curiosity here. This patch prints the following warning:
>
> In file included from (...)/drivers/usb/gadget/g_ffs.c:55:0:
> (...)/drivers/usb/gadget/f_fs.c: In function 'ffs_epfile_io.isra.18':
> (...)/drivers/usb/gadget/f_fs.c:837:15: warning: 'data_len' may be used 
> uninitialized in this function [-Wmaybe-uninitialized]

With the below code, this should no longer be a problem.

Also fixes issues pointed out by Alan.

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 6cb0b22..9aa3200 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -753,6 +753,7 @@ static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
 	struct ffs_epfile *epfile = file->private_data;
+	struct usb_gadget *gadget = epfile->ffs->gadget;
 	struct ffs_ep *ep;
 	char *data = NULL;
 	ssize_t ret;
@@ -788,7 +789,14 @@ static ssize_t ffs_epfile_io(struct file *file,
 
 	/* Allocate & copy */
 	if (!halt) {
-		data = kmalloc(len, GFP_KERNEL);
+		/*
+		 * Controller requires buffer size to be aligned to
+		 * maxpacketsize of an out endpoint.
+		 */
+		size_t data_len = read && gadget->quirk_ep_out_aligned_size ?
+			usb_ep_align_maxpacketsize(ep->ep, len) : len;
+
+		data = kmalloc(data_len, GFP_KERNEL);
 		if (unlikely(!data))
 			return -ENOMEM;
 
-- 
1.8.4.1

