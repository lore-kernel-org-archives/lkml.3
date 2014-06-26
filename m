Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaFZUej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaFZUei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:34:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 03/15] kexec: rename unusebale_pages to unusable_pages
Date: Thu, 26 Jun 2014 16:33:32 -0400
Message-Id: <1403814824-7587-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use the more common "unusable".

This patch was originally written and posted by Boris. I am including it
in this patch series.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 include/linux/kexec.h | 2 +-
 kernel/kexec.c        | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index a756419..d9bb0a5 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -100,7 +100,7 @@ struct kimage {
 
 	struct list_head control_pages;
 	struct list_head dest_pages;
-	struct list_head unuseable_pages;
+	struct list_head unusable_pages;
 
 	/* Address of next control page to allocate for crash kernels. */
 	unsigned long control_page;
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 369f41a..3aad6dc 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -153,7 +153,7 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 	INIT_LIST_HEAD(&image->dest_pages);
 
 	/* Initialize the list of unusable pages */
-	INIT_LIST_HEAD(&image->unuseable_pages);
+	INIT_LIST_HEAD(&image->unusable_pages);
 
 	/* Read in the segments */
 	image->nr_segments = nr_segments;
@@ -608,7 +608,7 @@ static void kimage_free_extra_pages(struct kimage *image)
 	kimage_free_page_list(&image->dest_pages);
 
 	/* Walk through and free any unusable pages I have cached */
-	kimage_free_page_list(&image->unuseable_pages);
+	kimage_free_page_list(&image->unusable_pages);
 
 }
 static void kimage_terminate(struct kimage *image)
@@ -731,7 +731,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
 		/* If the page cannot be used file it away */
 		if (page_to_pfn(page) >
 				(KEXEC_SOURCE_MEMORY_LIMIT >> PAGE_SHIFT)) {
-			list_add(&page->lru, &image->unuseable_pages);
+			list_add(&page->lru, &image->unusable_pages);
 			continue;
 		}
 		addr = page_to_pfn(page) << PAGE_SHIFT;
-- 
1.9.0

