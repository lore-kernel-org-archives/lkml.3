Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3AXUY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:24:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34583 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3AXUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:23:00 -0500
Date: Thu, 24 Jan 2013 12:22:42 -0800
From: tip-bot for Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <tip-2d58000fd2020255af63ee92c8d0ef615f6c4ade@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fabio.estevam@freescale.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fabio.estevam@freescale.com, tglx@linutronix.de
In-Reply-To: <1356434680-10045-1-git-send-email-festevam@gmail.com>
References: <1356434680-10045-1-git-send-email-festevam@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix print format for u64
Git-Commit-ID: 2d58000fd2020255af63ee92c8d0ef615f6c4ade
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:22:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d58000fd2020255af63ee92c8d0ef615f6c4ade
Gitweb:     http://git.kernel.org/tip/2d58000fd2020255af63ee92c8d0ef615f6c4ade
Author:     Fabio Estevam <fabio.estevam@freescale.com>
AuthorDate: Tue, 25 Dec 2012 09:24:40 -0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 15:50:08 +0100

sched: Fix print format for u64

commit c566e8e9 ("sched: Aggregate total task_group load")
introduced the following build warnings:

  kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Wformat]
  kernel/sched/debug.c:225:2: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'u64' [-Wformat]

Use %llu format to print a u64 value as per
Documentation/printk-formats.txt.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: peterz@infradead.org
Cc: pjt@google.com
Link: http://lkml.kernel.org/r/1356434680-10045-1-git-send-email-festevam@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..8c2fc39 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -222,7 +222,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+	SEQ_printf(m, "  .%-30s: %llu\n", "tg_load_avg",
 			atomic64_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
