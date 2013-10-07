Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3JGSqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:46:09 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:50881 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232Ab3JGSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:46:06 -0400
X-Greylist: delayed 791 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2013 14:46:06 EDT
Message-ID: <0000014194317db2-c89f8992-7778-40d4-bb66-b2be41e675b2-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 7 Oct 2013 18:32:53 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [raw v1 3/4] Use raw_cpu_write for initialization of per cpu refcount.
References: <20131007183226.334180014@linux.com>
X-SES-Outgoing: 2013.10.07-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initialization of a structure is not subject to synchronization.
So simply disable the check.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/module.c
===================================================================
--- linux.orig/kernel/module.c	2013-09-05 13:43:30.557687773 -0500
+++ linux/kernel/module.c	2013-10-07 12:33:43.732059759 -0500
@@ -643,7 +643,7 @@ static int module_unload_init(struct mod
 	INIT_LIST_HEAD(&mod->target_list);
 
 	/* Hold reference count during initialization. */
-	__this_cpu_write(mod->refptr->incs, 1);
+	raw_cpu_write(mod->refptr->incs, 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
 

