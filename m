Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab3JFOF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 10:05:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3JFOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 10:05:24 -0400
Date: Sun, 6 Oct 2013 07:04:19 -0700
From: tip-bot for Shawn Bohrer <tipbot@zytor.com>
Message-ID: <tip-6bfa687c19b7ab8adee03f0d43c197c2945dd869@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mgalbraith@suse.de, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, sbohrer@rgmadvisors.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        sbohrer@rgmadvisors.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1380914693-24634-1-git-send-email-shawn.bohrer@gmail.com>
References: <1380914693-24634-1-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Remove redundant nr_cpus_allowed test
Git-Commit-ID: 6bfa687c19b7ab8adee03f0d43c197c2945dd869
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 06 Oct 2013 07:04:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bfa687c19b7ab8adee03f0d43c197c2945dd869
Gitweb:     http://git.kernel.org/tip/6bfa687c19b7ab8adee03f0d43c197c2945dd869
Author:     Shawn Bohrer <sbohrer@rgmadvisors.com>
AuthorDate: Fri, 4 Oct 2013 14:24:53 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 6 Oct 2013 11:28:40 +0200

sched/rt: Remove redundant nr_cpus_allowed test

In 76854c7e8f3f4172fef091e78d88b3b751463ac6 ("sched: Use
rt.nr_cpus_allowed to recover select_task_rq() cycles") an
optimization was added to select_task_rq_rt() that immediately
returns when p->nr_cpus_allowed == 1 at the beginning of the
function.

This makes the latter p->nr_cpus_allowed > 1 check redundant,
which can now be removed.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <mgalbraith@suse.de>
Cc: tomk@rgmadvisors.com
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1380914693-24634-1-git-send-email-shawn.bohrer@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 01970c8..ceebfba 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1213,8 +1213,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->nr_cpus_allowed < 2 ||
-	     curr->prio <= p->prio) &&
-	    (p->nr_cpus_allowed > 1)) {
+	     curr->prio <= p->prio)) {
 		int target = find_lowest_rq(p);
 
 		if (target != -1)
