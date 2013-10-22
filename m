Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3JVQO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:14:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:29263 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab3JVQMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:12:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378374486"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        peterz@infradead.org, mingo@kernel.org
Subject: [PATCH 06/11] asmlinkage: Make trace_hardirq visible
Date: Tue, 22 Oct 2013 09:12:21 -0700
Message-Id: <1382458346-24811-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Can be called from assembler code.

Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/lockdep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index d3749fe..d1a047d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2555,7 +2555,7 @@ static void __trace_hardirqs_on_caller(unsigned long ip)
 	debug_atomic_inc(hardirqs_on_events);
 }
 
-void trace_hardirqs_on_caller(unsigned long ip)
+__visible void trace_hardirqs_on_caller(unsigned long ip)
 {
 	time_hardirqs_on(CALLER_ADDR0, ip);
 
@@ -2608,7 +2608,7 @@ EXPORT_SYMBOL(trace_hardirqs_on);
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off_caller(unsigned long ip)
+__visible void trace_hardirqs_off_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-- 
1.8.3.1

