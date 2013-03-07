Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab3CGQaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:30:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3CGQav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:30:51 -0500
Date: Thu, 7 Mar 2013 08:29:32 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ad2b13536ace08dfcca4cf86b75a5d06efe06373@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, tglx@linutronix.de
In-Reply-To: <20130306111537.304379448@linutronix.de>
References: <20130306111537.304379448@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick: Call tick_init late
Git-Commit-ID: ad2b13536ace08dfcca4cf86b75a5d06efe06373
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 07 Mar 2013 08:29:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad2b13536ace08dfcca4cf86b75a5d06efe06373
Gitweb:     http://git.kernel.org/tip/ad2b13536ace08dfcca4cf86b75a5d06efe06373
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 5 Mar 2013 15:14:05 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 7 Mar 2013 16:13:25 +0100

tick: Call tick_init late

To convert the clockevents code to cpumask_var_t we need to move the
init call after the allocator setup. 

Clockevents are earliest registered from time_init() as they need
interrupts being set up, so this is safe.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130306111537.304379448@linutronix.de
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 63534a1..b3e0614 100644
--- a/init/main.c
+++ b/init/main.c
@@ -494,7 +494,6 @@ asmlinkage void __init start_kernel(void)
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
-	tick_init();
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE "%s", linux_banner);
@@ -551,6 +550,7 @@ asmlinkage void __init start_kernel(void)
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
+	tick_init();
 	init_timers();
 	hrtimers_init();
 	softirq_init();
