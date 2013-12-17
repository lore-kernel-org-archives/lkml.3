Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3LQUSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:18:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:20842 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751140Ab3LQUR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:17:59 -0500
Date: Tue, 17 Dec 2013 15:17:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: [PATCH] sched, deadline: Properly initialize def_dl_bandwidth lock
Message-ID: <20131217151753.58834399@gandalf.local.home>
In-Reply-To: <20131217122720.950475833@infradead.org>
References: <20131217122720.950475833@infradead.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Spinlocks even in structures require to be properly initialized.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/sched/deadline.c
===================================================================
--- linux-rt.git.orig/kernel/sched/deadline.c
+++ linux-rt.git/kernel/sched/deadline.c
@@ -18,7 +18,9 @@
 
 #include <linux/slab.h>
 
-struct dl_bandwidth def_dl_bandwidth;
+struct dl_bandwidth def_dl_bandwidth = {
+	.dl_runtime_lock = __RAW_SPIN_LOCK_UNLOCKED(def_dl_bandwidth.dl_runtime_lock),
+};
 
 static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se)
 {
