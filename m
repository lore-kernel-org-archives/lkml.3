Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaEMUk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:40:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50144 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbaEMUko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:40:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Dario Faggioli <raistlin@linux.it>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] sched/deadline: delete extraneous extern for to_ratio()
Date: Tue, 13 May 2014 16:40:05 -0400
Message-ID: <1400013605-18717-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a prototype for it added to kernel/sched/sched.h
at the same time the extern was added, so the extern in
the C file was never really ever needed.

See commit 332ac17ef5bfcff4766dfdfd3b4cdf10b8f8f155 ("sched/deadline:
Add bandwidth management for SCHED_DEADLINE tasks") for details.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[patch created against today's linux-next, in case that matters.]

 kernel/sched/deadline.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 3fa3fac9d819..1b05677f5af5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -57,8 +57,6 @@ void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime)
 	dl_b->dl_runtime = runtime;
 }
 
-extern unsigned long to_ratio(u64 period, u64 runtime);
-
 void init_dl_bw(struct dl_bw *dl_b)
 {
 	raw_spin_lock_init(&dl_b->lock);
-- 
1.9.2

