Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbaCLBYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:24:44 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52289 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbaCLBYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:24:42 -0400
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH] uio: Fix memory size check with vma in uio_mmap_physical()
Date: Wed, 12 Mar 2014 10:24:21 +0900
Message-Id: <1394587461-8574-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register for the device are mapped in uio_mmap_physical().
In this case, it might not be the same as the size of VMA always.
This uses PAGE_ALIGN to memory size, fix the check of the memory size
to be mapped.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/uio/uio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a673e5b..e371f5a 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -655,7 +655,7 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 
 	if (mem->addr & ~PAGE_MASK)
 		return -ENODEV;
-	if (vma->vm_end - vma->vm_start > mem->size)
+	if (vma->vm_end - vma->vm_start > PAGE_ALIGN(mem->size))
 		return -EINVAL;
 
 	vma->vm_ops = &uio_physical_vm_ops;
-- 
1.8.5

