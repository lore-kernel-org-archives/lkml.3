Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3LMW0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:11 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34328 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3LMW0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 002/115] gpu: ion: ion_carveout_heap: fix for 3.4
Date: Fri, 13 Dec 2013 14:23:36 -0800
Message-Id: <1386973529-4884-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

__arch_ioremap is no longer available, use __arm_ioremap instead.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index 6d02cd3..e8c4e36 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -99,14 +99,14 @@ void ion_carveout_heap_unmap_dma(struct ion_heap *heap,
 void *ion_carveout_heap_map_kernel(struct ion_heap *heap,
 				   struct ion_buffer *buffer)
 {
-	return __arch_ioremap(buffer->priv_phys, buffer->size,
+	return __arm_ioremap(buffer->priv_phys, buffer->size,
 			      MT_MEMORY_NONCACHED);
 }
 
 void ion_carveout_heap_unmap_kernel(struct ion_heap *heap,
 				    struct ion_buffer *buffer)
 {
-	__arch_iounmap(buffer->vaddr);
+	__arm_iounmap(buffer->vaddr);
 	buffer->vaddr = NULL;
 	return;
 }
-- 
1.8.3.2

