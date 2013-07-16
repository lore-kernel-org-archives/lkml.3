Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab3GPRVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:21:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34287 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab3GPRVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:21:35 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 2/2] uio: drop unused vma_count member in uio_device struct
Date: Tue, 16 Jul 2013 19:21:04 +0200
Message-Id: <1373995264-31448-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373995264-31448-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1373995264-31448-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vma_count is used write-only and so fails to be useful. So remove it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/uio/uio.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 159cfb3..af24bda 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -35,7 +35,6 @@ struct uio_device {
 	atomic_t		event;
 	struct fasync_struct	*async_queue;
 	wait_queue_head_t	wait;
-	int			vma_count;
 	struct uio_info		*info;
 	struct kobject		*map_dir;
 	struct kobject		*portio_dir;
@@ -593,18 +592,6 @@ static int uio_find_mem_index(struct vm_area_struct *vma)
 	return -1;
 }
 
-static void uio_vma_open(struct vm_area_struct *vma)
-{
-	struct uio_device *idev = vma->vm_private_data;
-	idev->vma_count++;
-}
-
-static void uio_vma_close(struct vm_area_struct *vma)
-{
-	struct uio_device *idev = vma->vm_private_data;
-	idev->vma_count--;
-}
-
 static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
@@ -631,8 +618,6 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 }
 
 static const struct vm_operations_struct uio_logical_vm_ops = {
-	.open = uio_vma_open,
-	.close = uio_vma_close,
 	.fault = uio_vma_fault,
 };
 
@@ -640,7 +625,6 @@ static int uio_mmap_logical(struct vm_area_struct *vma)
 {
 	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &uio_vm_ops;
-	uio_vma_open(vma);
 	return 0;
 }
 
-- 
1.8.3.2

