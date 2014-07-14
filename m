Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbaGNV5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:57:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:42631 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaGNV5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:57:46 -0400
Date: Mon, 14 Jul 2014 23:57:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.14.12-rt9
Message-ID: <alpine.DEB.2.10.1407142242270.24854@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.14.12-rt9 release. 3.14.10-rt8 is a not
announced update to 3.14.12 without any RT changes.

Changes since 3.14.12-rt8:

   * Bring back the interrupt randomness hunk which got dropped due
     an unresolved reject. Thanks to Ben Hutchings for spotting that!

<politics>

Thanks a lot for all the supportive mails on- and offlist!

  The most intriguing idea so far was to jump on the momentum of the
  most hilarious crowd funding nonsense:

    https://www.kickstarter.com/projects/324283889/potato-salad

  So in consequence we might turn RT into a crowdfunded nonsense
  project which serves the purpose of controlling the potato-salad
  machine to make sure that Zack Danger Brown can deliver all the
  potato salad people have pledged for.

</politics>

Thanks,

      Thomas

---
The delta patch against 3.14.12-rt8 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.14/incr/patch-3.14.10-rt8-rt9.patch.xz

The RT patch against 3.14.12 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patch-3.14.12-rt9.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patches-3.14.12-rt9.tar.xz

Index: linux-stable/kernel/irq/manage.c
===================================================================
--- linux-stable.orig/kernel/irq/manage.c
+++ linux-stable/kernel/irq/manage.c
@@ -942,6 +942,12 @@ static int irq_thread(void *data)
 		if (action_ret == IRQ_HANDLED)
 			atomic_inc(&desc->threads_handled);
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+		migrate_disable();
+		add_interrupt_randomness(action->irq, 0,
+				 desc->random_ip ^ (unsigned long) action);
+		migrate_enable();
+#endif
 		wake_threads_waitq(desc);
 	}
 
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt8
+-rt9
