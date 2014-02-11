Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaBKMRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:17:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBKMRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:17:02 -0500
Date: Tue, 11 Feb 2014 04:16:35 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-f10447998a59b97747c16258a9c6e6a1512f27f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1328936700.2476.17.camel@laptop>
References: <1328936700.2476.17.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Clean up the __clear_buddies_*()
  functions
Git-Commit-ID: f10447998a59b97747c16258a9c6e6a1512f27f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:16:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f10447998a59b97747c16258a9c6e6a1512f27f3
Gitweb:     http://git.kernel.org/tip/f10447998a59b97747c16258a9c6e6a1512f27f3
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sat, 11 Feb 2012 06:05:00 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Feb 2014 16:17:16 +0100

sched/fair: Clean up the __clear_buddies_*() functions

Slightly easier code flow, no functional changes.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c4bb0ac..8461721 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2739,10 +2739,10 @@ static void __clear_buddies_last(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->last == se)
-			cfs_rq->last = NULL;
-		else
+		if (cfs_rq->last != se)
 			break;
+
+		cfs_rq->last = NULL;
 	}
 }
 
@@ -2750,10 +2750,10 @@ static void __clear_buddies_next(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->next == se)
-			cfs_rq->next = NULL;
-		else
+		if (cfs_rq->next != se)
 			break;
+
+		cfs_rq->next = NULL;
 	}
 }
 
@@ -2761,10 +2761,10 @@ static void __clear_buddies_skip(struct sched_entity *se)
 {
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
-		if (cfs_rq->skip == se)
-			cfs_rq->skip = NULL;
-		else
+		if (cfs_rq->skip != se)
 			break;
+
+		cfs_rq->skip = NULL;
 	}
 }
 
