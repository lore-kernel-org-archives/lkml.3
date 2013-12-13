Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3LMW0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:31 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57594 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3LMW03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:29 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 015/115] gpu: ion: Map only the vma size given
Date: Fri, 13 Dec 2013 14:23:49 -0800
Message-Id: <1386973529-4884-16-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laura Abbott <lauraa@codeaurora.org>

When mapping carveout buffers into userspace, only map
the size of the vma given, not the full size of the buffer
since clients may map less than the buffer size.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index e8c4e36..16f4fc7 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -116,7 +116,7 @@ int ion_carveout_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 {
 	return remap_pfn_range(vma, vma->vm_start,
 			       __phys_to_pfn(buffer->priv_phys) + vma->vm_pgoff,
-			       buffer->size,
+			       vma->vm_end - vma->vm_start,
 			       pgprot_noncached(vma->vm_page_prot));
 }
 
-- 
1.8.3.2

