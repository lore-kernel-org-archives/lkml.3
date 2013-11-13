Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3KMOgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:36:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759379Ab3KMOfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:35:17 -0500
Date: Wed, 13 Nov 2013 15:36:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] exit_state: kill task_is_dead()
Message-ID: <20131113143614.GA10547@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113143552.GA10517@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_is_dead() has no users since commit 43e13cc107cf
"cred: remove task_is_dead() from __task_cred() validation", and
nobody except exit.c should rely on ->exit_state (we still have
the users which should be changed).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee2c2e6..33cf854 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -167,7 +167,6 @@ extern char ___assert_task_state[1 - 2*!!(
 
 #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
 #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
-#define task_is_dead(task)	((task)->exit_state != 0)
 #define task_is_stopped_or_traced(task)	\
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
-- 
1.5.5.1

