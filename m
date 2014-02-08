Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaBHHxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:53:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:13411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbaBHHw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="471774445"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, peterz@infradead.org,
        mingo@kernel.org
Subject: [PATCH 06/14] asmlinkage: Make trace_hardirq visible
Date: Sat,  8 Feb 2014 08:52:02 +0100
Message-Id: <1391845930-28580-6-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can be called from assembler code.

Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/locking/lockdep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c8b6753c..aa3bf15 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2557,7 +2557,7 @@ static void __trace_hardirqs_on_caller(unsigned long ip)
 	debug_atomic_inc(hardirqs_on_events);
 }
 
-void trace_hardirqs_on_caller(unsigned long ip)
+__visible void trace_hardirqs_on_caller(unsigned long ip)
 {
 	time_hardirqs_on(CALLER_ADDR0, ip);
 
@@ -2610,7 +2610,7 @@ EXPORT_SYMBOL(trace_hardirqs_on);
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off_caller(unsigned long ip)
+__visible void trace_hardirqs_off_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-- 
1.8.5.2

