Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3CKX0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:26:53 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:53870 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754132Ab3CKX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:26:52 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>, Mirsal Ennaime <mirsal@mirsal.fr>
Subject: [PATCH v2 3/3] drivers: android: binder: Remove excessive indentation
Date: Tue, 12 Mar 2013 00:26:28 +0100
Message-Id: <1363044388-11409-4-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
 <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove one level of indentation from the binder proc page release code
by using slightly different control semantics.

This is a cosmetic patch which removes checkpatch "80-columns" warnings

Signed-off-by: Mirsal Ennaime <mirsal@mirsal.fr>
---
 drivers/staging/android/binder.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 4652cd8..db214ce 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -3001,17 +3001,20 @@ static void binder_deferred_release(struct binder_proc *proc)
 		int i;
 
 		for (i = 0; i < proc->buffer_size / PAGE_SIZE; i++) {
-			if (proc->pages[i]) {
-				void *page_addr = proc->buffer + i * PAGE_SIZE;
-				binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-					"binder_release: %d: page %d at %p not freed\n",
-					proc->pid, i,
-					page_addr);
-				unmap_kernel_range((unsigned long)page_addr,
-					PAGE_SIZE);
-				__free_page(proc->pages[i]);
-				page_count++;
-			}
+			void *page_addr;
+
+			if (!proc->pages[i])
+				continue;
+
+			page_addr = proc->buffer + i * PAGE_SIZE;
+			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
+				"binder_release: %d: page %d at %p not freed\n",
+				proc->pid, i,
+				page_addr);
+			unmap_kernel_range((unsigned long)page_addr,
+				PAGE_SIZE);
+			__free_page(proc->pages[i]);
+			page_count++;
 		}
 
 		kfree(proc->pages);
-- 
1.7.10.4

