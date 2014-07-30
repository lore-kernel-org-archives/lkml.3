Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaG3Iww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:52:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50864 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaG3Iwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:52:50 -0400
From: Chintan Pandya <cpandya@codeaurora.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chintan Pandya <cpandya@codeaurora.org>
Subject: [PATCH] mm: BUG when __kmap_atomic_idx crosses boundary
Date: Wed, 30 Jul 2014 14:22:35 +0530
Message-Id: <1406710355-4360-1-git-send-email-cpandya@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__kmap_atomic_idx >= KM_TYPE_NR or < ZERO is a bug.
Report it even if CONFIG_DEBUG_HIGHMEM is not enabled.
That saves much debugging efforts.

Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
---
 include/linux/highmem.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 7fb31da..f42cafd 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -93,8 +93,8 @@ static inline int kmap_atomic_idx_push(void)
 
 #ifdef CONFIG_DEBUG_HIGHMEM
 	WARN_ON_ONCE(in_irq() && !irqs_disabled());
-	BUG_ON(idx > KM_TYPE_NR);
 #endif
+	BUG_ON(idx >= KM_TYPE_NR);
 	return idx;
 }
 
@@ -105,13 +105,9 @@ static inline int kmap_atomic_idx(void)
 
 static inline void kmap_atomic_idx_pop(void)
 {
-#ifdef CONFIG_DEBUG_HIGHMEM
 	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
 
 	BUG_ON(idx < 0);
-#else
-	__this_cpu_dec(__kmap_atomic_idx);
-#endif
 }
 
 #endif
-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

