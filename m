Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3LND1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:03 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36003 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3LND0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:26:50 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 097/115] gpu: ion: fix use-after-free in ion_heap_freelist_drain
Date: Fri, 13 Dec 2013 19:26:17 -0800
Message-Id: <1386991595-6251-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitchel Humpherys <mitchelh@codeaurora.org>

The `buffer' variable is being used after being freed. Fix this.

Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index deaab7c..0a5cea0 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -200,9 +200,9 @@ size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
 		if (total_drained >= size)
 			break;
 		list_del(&buffer->list);
-		ion_buffer_destroy(buffer);
 		heap->free_list_size -= buffer->size;
 		total_drained += buffer->size;
+		ion_buffer_destroy(buffer);
 	}
 	rt_mutex_unlock(&heap->lock);
 
-- 
1.8.3.2

