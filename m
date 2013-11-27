Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab3K0OLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:11:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3K0OLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:11:01 -0500
Date: Wed, 27 Nov 2013 06:10:10 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-bb8cbbfee68518796df4050868e5b0f5ad078f9f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        David.Laight@ACULAB.COM, geert@linux-m68k.org,
        akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        David.Laight@ACULAB.COM, geert@linux-m68k.org,
        akpm@linux-foundation.org, tj@kernel.org, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20131113143612.GA10540@redhat.com>
References: <20131113143612.GA10540@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] tasks/fork: Remove unnecessary child->exit_state
Git-Commit-ID: bb8cbbfee68518796df4050868e5b0f5ad078f9f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:10:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb8cbbfee68518796df4050868e5b0f5ad078f9f
Gitweb:     http://git.kernel.org/tip/bb8cbbfee68518796df4050868e5b0f5ad078f9f
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 13 Nov 2013 15:36:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 13:50:50 +0100

tasks/fork: Remove unnecessary child->exit_state

A zombie task obviously can't fork(), remove the unnecessary
initialization of child->exit_state. It is zero anyway after
dup_task_struct().

Note: copy_process() is huge and it has a lot of chaotic
initializations, probably it makes sense to move them into the
new helper called by dup_task_struct().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131113143612.GA10540@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/fork.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 728d5be..b308082 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1402,13 +1402,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		p->tgid = p->pid;
 	}
 
-	p->pdeath_signal = 0;
-	p->exit_state = 0;
-
 	p->nr_dirtied = 0;
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when = 0;
 
+	p->pdeath_signal = 0;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
