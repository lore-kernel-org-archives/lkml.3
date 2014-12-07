Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaLGPmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 10:42:17 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64233 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaLGPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 10:41:52 -0500
From: robert.ward114@googlemail.com
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Rob Ward <robert.ward114@googlemail.com>
Subject: [PATCH 2/3] drivers: char: mem: Simplify DEVKMEM configuration
Date: Sun,  7 Dec 2014 15:40:34 +0000
Message-Id: <1417966835-14012-3-git-send-email-robert.ward114@googlemail.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
References: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Ward <robert.ward114@googlemail.com>

Simplify the use of CONFIG_DEVKMEM by making the kmem_fops
so that it is __maybe_unused.

This enabled the multiple #ifdef's used for this structure
to be removed and brings it in line with the use of CONFIG_DEVMEM

This change should introduce no functional changes.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/char/mem.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index b2ca476..4521fea 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -338,7 +338,6 @@ static int mmap_mem(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-#ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
 {
 	unsigned long pfn;
@@ -359,9 +358,7 @@ static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
 	vma->vm_pgoff = pfn;
 	return mmap_mem(file, vma);
 }
-#endif
 
-#ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
@@ -541,7 +538,6 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	*ppos = p;
 	return virtr + wrote ? : err;
 }
-#endif
 
 #ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file *file, char __user *buf,
@@ -721,8 +717,7 @@ static const struct file_operations __maybe_unused mem_fops = {
 	.get_unmapped_area = get_unmapped_area_mem,
 };
 
-#ifdef CONFIG_DEVKMEM
-static const struct file_operations kmem_fops = {
+static const struct file_operations __maybe_unused kmem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_kmem,
 	.write		= write_kmem,
@@ -730,7 +725,6 @@ static const struct file_operations kmem_fops = {
 	.open		= open_kmem,
 	.get_unmapped_area = get_unmapped_area_mem,
 };
-#endif
 
 static const struct file_operations null_fops = {
 	.llseek		= null_lseek,
-- 
2.0.2

