Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3K0OLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:11:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3K0OLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:11:00 -0500
Date: Wed, 27 Nov 2013 06:10:20 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-86506a99a62400e9f7b7d1344bcc9ea235faf98f@git.kernel.org>
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
In-Reply-To: <20131113143614.GA10547@redhat.com>
References: <20131113143614.GA10547@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] tasks/exit: Remove unused task_is_dead() method
Git-Commit-ID: 86506a99a62400e9f7b7d1344bcc9ea235faf98f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:10:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86506a99a62400e9f7b7d1344bcc9ea235faf98f
Gitweb:     http://git.kernel.org/tip/86506a99a62400e9f7b7d1344bcc9ea235faf98f
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 13 Nov 2013 15:36:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 13:50:52 +0100

tasks/exit: Remove unused task_is_dead() method

task_is_dead() has no users since commit 43e13cc107cf
("cred: remove task_is_dead() from __task_cred() validation"), and
nobody except exit.c should rely on ->exit_state (we still have
the users which should be changed).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131113143614.GA10547@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7e35d4b..cda8d63 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -168,7 +168,6 @@ extern char ___assert_task_state[1 - 2*!!(
 
 #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
 #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
-#define task_is_dead(task)	((task)->exit_state != 0)
 #define task_is_stopped_or_traced(task)	\
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
