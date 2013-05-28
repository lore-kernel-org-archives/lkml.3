Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab3E1Nhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:37:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934110Ab3E1Nhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:37:52 -0400
Date: Tue, 28 May 2013 06:37:16 -0700
From: tip-bot for Stanislaw Gruszka <tipbot@zytor.com>
Message-ID: <tip-84f9f3a15611536537d59060818a2354d5039ff3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        sgruszka@redhat.com
In-Reply-To: <1367501673-6563-1-git-send-email-sgruszka@redhat.com>
References: <1367501673-6563-1-git-send-email-sgruszka@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use swap() macro in scale_stime()
Git-Commit-ID: 84f9f3a15611536537d59060818a2354d5039ff3
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

Commit-ID:  84f9f3a15611536537d59060818a2354d5039ff3
Gitweb:     http://git.kernel.org/tip/84f9f3a15611536537d59060818a2354d5039ff3
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Thu, 2 May 2013 15:34:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 11:58:10 +0200

sched: Use swap() macro in scale_stime()

Simple cleanup.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1367501673-6563-1-git-send-email-sgruszka@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
