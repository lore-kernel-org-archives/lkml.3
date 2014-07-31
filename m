Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbaGaGYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:24:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41393 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaGaGYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:24:43 -0400
From: Chintan Pandya <cpandya@codeaurora.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chintan Pandya <cpandya@codeaurora.org>
Subject: [PATCH v2] mm: BUG when __kmap_atomic_idx equals KM_TYPE_NR
Date: Thu, 31 Jul 2014 11:54:31 +0530
Message-Id: <1406787871-2951-1-git-send-email-cpandya@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__kmap_atomic_idx is per_cpu variable. Each CPU can
use KM_TYPE_NR entries from FIXMAP i.e. from 0 to
KM_TYPE_NR - 1. Allowing __kmap_atomic_idx to over-
shoot to KM_TYPE_NR can mess up with next CPU's 0th
entry which is a bug. Hence BUG_ON if
__kmap_atomic_idx >= KM_TYPE_NR.

Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
---
Changes:

V1 --> V2

	Not touching CONFIG_DEBUG_HIGHMEM.

 include/linux/highmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 7fb31da..9286a46 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -93,7 +93,7 @@ static inline int kmap_atomic_idx_push(void)
 
 #ifdef CONFIG_DEBUG_HIGHMEM
 	WARN_ON_ONCE(in_irq() && !irqs_disabled());
-	BUG_ON(idx > KM_TYPE_NR);
+	BUG_ON(idx >= KM_TYPE_NR);
 #endif
 	return idx;
 }
-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

