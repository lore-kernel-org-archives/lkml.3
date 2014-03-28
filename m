Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaC1KwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:52:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:14027 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaC1KwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:52:19 -0400
Message-ID: <5335540B.9060008@huawei.com>
Date: Fri, 28 Mar 2014 18:50:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v4 3/4] kmemleak: remove redundant code
References: <533553E2.7050801@huawei.com>
In-Reply-To: <533553E2.7050801@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove kmemleak_padding().
- remove kmemleak_release().

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/kmemleak.h | 2 --
 mm/kmemleak.c            | 7 +------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 2a5e554..5bb4246 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -30,8 +30,6 @@ extern void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size) __ref;
 extern void kmemleak_free(const void *ptr) __ref;
 extern void kmemleak_free_part(const void *ptr, size_t size) __ref;
 extern void kmemleak_free_percpu(const void __percpu *ptr) __ref;
-extern void kmemleak_padding(const void *ptr, unsigned long offset,
-			     size_t size) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 06cd220..6f90d00 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1549,11 +1549,6 @@ static int kmemleak_open(struct inode *inode, struct file *file)
 	return seq_open(file, &kmemleak_seq_ops);
 }
 
-static int kmemleak_release(struct inode *inode, struct file *file)
-{
-	return seq_release(inode, file);
-}
-
 static int dump_str_object_info(const char *str)
 {
 	unsigned long flags;
@@ -1691,7 +1686,7 @@ static const struct file_operations kmemleak_fops = {
 	.read		= seq_read,
 	.write		= kmemleak_write,
 	.llseek		= seq_lseek,
-	.release	= kmemleak_release,
+	.release	= seq_release,
 };
 
 static void __kmemleak_do_cleanup(void)
-- 
1.8.0.2

