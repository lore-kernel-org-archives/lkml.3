Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3EMCUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:20:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:54549 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3EMCUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:20:01 -0400
From: Libin <huawei.libin@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <guohanjun@huawei.com>, <wangyijing@huawei.com>
Subject: [PATCH] char: Use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
Date: Mon, 13 May 2013 10:17:39 +0800
Message-ID: <1368411459-52524-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
as a inline funcion vma_pages() in linux/mm.h, so using it.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 drivers/char/mspec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index e1f60f9..f1d7fa4 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -267,7 +267,7 @@ mspec_mmap(struct file *file, struct vm_area_struct *vma,
 	if ((vma->vm_flags & VM_WRITE) == 0)
 		return -EPERM;
 
-	pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	pages = vma_pages(vma);
 	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
 	if (vdata_size <= PAGE_SIZE)
 		vdata = kzalloc(vdata_size, GFP_KERNEL);
-- 
1.8.2.1


