Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaB0Mfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:35:30 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49876 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaB0MfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:35:21 -0500
Date: Thu, 27 Feb 2014 18:03:05 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 43/46] kernel: Add prototype declaration to header file
 kernel/sched/sched.h
Message-ID: <0a032164ac80760510aa7ff565365becf8555eb4.1393493278.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of function to header file
kernel/sched/sched.h because it is used by more than one file.

This eliminates the following warning in kernel/sched/core.c:
kernel/sched/core.c:2760:25: warning: no previous prototype for ‘schedule_user’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/sched.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 586613e..c3688e2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -286,6 +286,7 @@ static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
 
 extern int tg_nop(struct task_group *tg, void *data);
 
+asmlinkage void __sched schedule_user(void);
 extern void free_fair_sched_group(struct task_group *tg);
 extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
 extern void unregister_fair_sched_group(struct task_group *tg, int cpu);
-- 
1.7.9.5

