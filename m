Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaFCNO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:14:26 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60483 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaFCNOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:14:24 -0400
Message-ID: <1401801261.5788.2.camel@marge.simpson.net>
Subject: [patchlet][resend] sched: Fix up /proc/sched_debug to print only
 runnable tasks again
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 03 Jun 2014 15:14:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit b32e86b430 dropped p->on_rq check, leading to printing tasks which
used to live on runqueues, which is very noisy and highly annoying.

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 kernel/sched/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -162,7 +162,7 @@ static void print_rq(struct seq_file *m,
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, p) {
-		if (task_cpu(p) != rq_cpu)
+		if (!p->on_rq || task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);


