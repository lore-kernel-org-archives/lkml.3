Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaFEOls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:41:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFEOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:41:44 -0400
Date: Thu, 5 Jun 2014 07:40:38 -0700
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-f602d0632755be4f7eddfdd6c0af13216790177b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, raistlin@linux.it,
        paul.gortmaker@windriver.com
In-Reply-To: <1400013605-18717-1-git-send-email-paul.gortmaker@windriver.com>
References: <1400013605-18717-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Delete extraneous extern for to_ratio()
Git-Commit-ID: f602d0632755be4f7eddfdd6c0af13216790177b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f602d0632755be4f7eddfdd6c0af13216790177b
Gitweb:     http://git.kernel.org/tip/f602d0632755be4f7eddfdd6c0af13216790177b
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Tue, 13 May 2014 16:40:05 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 14:22:24 +0200

sched/deadline: Delete extraneous extern for to_ratio()

There was a prototype for it added to kernel/sched/sched.h
at the same time the extern was added, so the extern in
the C file was never really ever needed.

See commit 332ac17ef5bfcff4766dfdfd3b4cdf10b8f8f155
("sched/deadline: Add bandwidth management for SCHED_DEADLINE
tasks") for details.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>
Link: http://lkml.kernel.org/r/1400013605-18717-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f9ca7d1..0d6b170 100644
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
