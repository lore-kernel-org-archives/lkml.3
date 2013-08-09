Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031531Ab3HIXE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:04:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:10655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031449Ab3HIXEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="378778932"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/13] Add might_fault_debug_only()
Date: Fri,  9 Aug 2013 16:04:14 -0700
Message-Id: <1376089460-5459-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a might_fault_debug_only() that only does something in the PROVE_LOCKING
case, but does not cond_resched for PREEMPT_VOLUNTARY. This is for
cases when the cond_resched is done elsewhere

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/sched.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 773f21d..bb7a08a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2473,11 +2473,13 @@ static inline void cond_resched_rcu(void)
 
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
+#define might_fault_debug_only() might_fault()
 #else
 static inline void might_fault(void)
 {
 	might_sleep();
 }
+#define might_fault_debug_only() do {} while(0)
 #endif
 
 /*
-- 
1.8.3.1

