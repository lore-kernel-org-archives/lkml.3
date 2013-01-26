Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3AZMTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:19:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51807 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3AZMTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:19:46 -0500
Date: Sat, 26 Jan 2013 04:19:06 -0800
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
Message-ID: <tip-cff3c124a7e82ca0ea1d6864b27ef18c403c0773@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
        mingo@kernel.org, pjt@google.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, peterz@infradead.org, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <1359123276-15833-7-git-send-email-arnd@arndb.de>
References: <1359123276-15833-7-git-send-email-arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/debug:
  Fix format string for 32-bit platforms
Git-Commit-ID: cff3c124a7e82ca0ea1d6864b27ef18c403c0773
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 26 Jan 2013 04:19:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cff3c124a7e82ca0ea1d6864b27ef18c403c0773
Gitweb:     http://git.kernel.org/tip/cff3c124a7e82ca0ea1d6864b27ef18c403c0773
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Fri, 25 Jan 2013 14:14:23 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 15:23:15 +0100

sched/debug: Fix format string for 32-bit platforms

The type returned from atomic64_t can be either unsigned
long or unsigned long long, depending on the architecture.
Using a cast to unsigned long long lets us use the same
format string for all architectures.

Without this patch, building with scheduler debugging
enabled results in:

  kernel/sched/debug.c: In function 'print_cfs_rq':
  kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'long long int' [-Wformat]
  kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'long long int' [-Wformat]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>
Cc: linux-arm-kernel@list.infradead.org
Link: http://lkml.kernel.org/r/1359123276-15833-7-git-send-email-arnd@arndb.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..7ae4c4c 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -222,8 +222,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
-			atomic64_read(&cfs_rq->tg->load_avg));
+	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
+			(unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
