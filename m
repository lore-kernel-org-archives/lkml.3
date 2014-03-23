Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaCWOUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 10:20:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:57832 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaCWOUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 10:20:35 -0400
Message-Id: <20140323141940.034005322@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Mar 2014 14:20:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch 2/2] x86: hpet: Use proper destructor for delayed work
References: <20140323141648.703530841@linutronix.de>
Content-Disposition: inline; filename=x86-hpet-use-destroy-delayed.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

destroy_timer_on_stack() is hardly the right thing for a delayed
work. We leak a tracking object for the work itself when DEBUG_OBJECTS
is enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/arch/x86/kernel/hpet.c
===================================================================
--- tip.orig/arch/x86/kernel/hpet.c
+++ tip/arch/x86/kernel/hpet.c
@@ -699,7 +699,7 @@ static int hpet_cpuhp_notify(struct noti
 		/* FIXME: add schedule_work_on() */
 		schedule_delayed_work_on(cpu, &work.work, 0);
 		wait_for_completion(&work.complete);
-		destroy_timer_on_stack(&work.work.timer);
+		destroy_delayed_work_on_stack(&work.work);
 		break;
 	case CPU_DEAD:
 		if (hdev) {


