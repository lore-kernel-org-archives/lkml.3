Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3LND1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:52 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60092 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3LND1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 106/115] ion: allow cached mappings of chunk and system heap buffers
Date: Fri, 13 Dec 2013 19:26:26 -0800
Message-Id: <1386991595-6251-14-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Now that ion_vm_fault uses vm_insert_pfn instead of vm_insert_page
cached buffers can be supported in any heap.  Remove the checks
in the chunk and system heaps.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_chunk_heap.c  | 3 ---
 drivers/staging/android/ion/ion_system_heap.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 4eacf52..34d1d18 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -47,9 +47,6 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 	unsigned long num_chunks;
 	unsigned long allocated_size;
 
-	if (ion_buffer_fault_user_mappings(buffer))
-		return -ENOMEM;
-
 	allocated_size = ALIGN(size, chunk_heap->chunk_size);
 	num_chunks = allocated_size / chunk_heap->chunk_size;
 
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index a4bcf09..53afa33 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -148,9 +148,6 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	if (align > PAGE_SIZE)
 		return -EINVAL;
 
-	if (ion_buffer_fault_user_mappings(buffer))
-		return -EINVAL;
-
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
 		info = alloc_largest_available(sys_heap, buffer, size_remaining, max_order);
-- 
1.8.3.2

