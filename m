Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab3A0O7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:59:03 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:37743 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3A0O7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:59:01 -0500
From: Fabio Estevam <festevam@gmail.com>
To: mingo@kernel.org
Cc: pjt@google.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] sched: debug: Promote atomic64_read to u64 for printing
Date: Sun, 27 Jan 2013 12:58:36 -0200
Message-Id: <1359298716-6908-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 2d58000fd (sched: Fix print format for u64) introduced the following 
build warning for x86_64:

kernel/sched/debug.c: In function 'print_cfs_rq':
kernel/sched/debug.c:225:2: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 4 has type 'long int' [-Wformat]
kernel/sched/debug.c:225:2: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 3 has type 'long int' [-Wformat]

atomi64_read() function may have a different returning type depending on the 
architecture, so in order to guarantee that it builds fine on any system without
warnings, promote it to u64 for printing purpose.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 kernel/sched/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index b46faf5..2aacabe 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -216,7 +216,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
 	SEQ_printf(m, "  .%-30s: %llu\n", "tg_load_avg",
-			atomic64_read(&cfs_rq->tg->load_avg));
+			(u64)atomic64_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
-- 
1.7.9.5

