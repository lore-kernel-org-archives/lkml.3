Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3A0N7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:59:32 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:38270 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3A0N73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:59:29 -0500
Date: Sun, 27 Jan 2013 08:59:23 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH resend] sched: fix compilation warning
Message-ID: <20130127135923.GA8437@gmail.com>
References: <1354727440-20157-1-git-send-email-dinggnu@gmail.com>
 <CAM3j68rOMRdrovAkWdwfB477W+efMC1uGkbHNjz+kRz4LMaXag@mail.gmail.com>
 <50FAF36A.6000205@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50FAF36A.6000205@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following compilation warning is caused by Commit-ID:
c566e8e9e44b72b53091da20e2dedefc730f2ee2

kernel/sched/debug.c: In function ‘print_cfs_rq’:
kernel/sched/debug.c:225:2: warning: format ‘%ld’ expects argument of type
‘long int’, but argument 4 has type ‘long long int’ [-Wformat]
kernel/sched/debug.c:225:2: warning: format ‘%ld’ expects argument of type
‘long int’, but argument 3 has type ‘long long int’ [-Wformat]

where function atomic64_read returns long long int, but %ld was used in the
printf

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
resend because no reply for
Message-Id: <1354727440-20157-1-git-send-email-dinggnu@gmail.com>

 kernel/sched/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..83ec463 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -222,7 +222,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
 			atomic64_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
-- 
1.7.10.4

