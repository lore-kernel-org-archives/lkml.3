Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3EBNdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:33:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759340Ab3EBNdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:33:39 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip] sched: Use swap() macro on scale_stime()
Date: Thu,  2 May 2013 15:34:33 +0200
Message-Id: <1367501673-6563-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sched/cputime.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index cc2dc3e..94691bc 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -515,9 +515,8 @@ static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
 
 	for (;;) {
 		/* Make sure "rtime" is the bigger of stime/rtime */
-		if (stime > rtime) {
-			u64 tmp = rtime; rtime = stime; stime = tmp;
-		}
+		if (stime > rtime)
+			swap(rtime, stime);
 
 		/* Make sure 'total' fits in 32 bits */
 		if (total >> 32)
-- 
1.7.11.7

