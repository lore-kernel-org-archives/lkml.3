Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbaC0LKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:10:23 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63578 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbaC0LKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:10:21 -0400
From: Ma Haijun <mahaijuns@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Al Viro <viro@ZenIV.linux.org.uk>,
        Ma Haijun <mahaijuns@gmail.com>
Subject: [PATCH] [media] videobuf-dma-contig: fix incorrect argument to vm_iomap_memory() call
Date: Thu, 27 Mar 2014 19:07:06 +0800
Message-Id: <1395918426-27787-2-git-send-email-mahaijuns@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second argument should be physical address rather than virtual address.

Signed-off-by: Ma Haijun <mahaijuns@gmail.com>
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index 7e6b209..bf80f0f 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -305,7 +305,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 	/* Try to remap memory */
 	size = vma->vm_end - vma->vm_start;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	retval = vm_iomap_memory(vma, vma->vm_start, size);
+	retval = vm_iomap_memory(vma, mem->dma_handle, size);
 	if (retval) {
 		dev_err(q->dev, "mmap: remap failed with error %d. ",
 			retval);
-- 
1.8.3.2

