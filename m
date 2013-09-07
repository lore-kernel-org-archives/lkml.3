Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab3IGIZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:25:18 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:37424 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3IGIZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:25:16 -0400
Message-ID: <522AE146.1020707@gmail.com>
Date: Sat, 07 Sep 2013 10:18:14 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH 03/19] pramfs: export xip_file_fault
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export xip_file_fault to modules.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 include/linux/fs.h |    2 ++
 mm/filemap_xip.c   |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b4cd82..1f61e07 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -41,6 +41,7 @@ struct kobject;
 struct pipe_inode_info;
 struct poll_table_struct;
 struct kstatfs;
+struct vm_fault;
 struct vm_area_struct;
 struct vfsmount;
 struct cred;
@@ -2445,6 +2446,7 @@ extern int nonseekable_open(struct inode * inode, struct file * filp);
 #ifdef CONFIG_FS_XIP
 extern ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
 			     loff_t *ppos);
+extern int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
 extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
 			      size_t len, loff_t *ppos);
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 28fe26b..50bbc5d 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -219,7 +219,7 @@ retry:
  *
  * This function is derived from filemap_fault, but used for execute in place
  */
-static int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
@@ -303,6 +303,7 @@ out:
 	}
 }
 
+EXPORT_SYMBOL_GPL(xip_file_fault);
 static const struct vm_operations_struct xip_file_vm_ops = {
 	.fault	= xip_file_fault,
 	.page_mkwrite	= filemap_page_mkwrite,
-- 
1.7.3.4
