Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaAQP1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:27:20 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:44982
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbaAQP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:27:14 -0500
Message-Id: <20140117151834.870168754@linux.com>
Date: Fri, 17 Jan 2014 09:18:17 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 05/41] drivers/char/random: Replace __get_cpu_var uses
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_drivers_char
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A single case of using __get_cpu_var for address calculation.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/char/random.c
===================================================================
--- linux.orig/drivers/char/random.c	2013-12-02 16:07:47.924685509 -0600
+++ linux/drivers/char/random.c	2013-12-02 16:07:47.924685509 -0600
@@ -838,7 +838,7 @@ static DEFINE_PER_CPU(struct fast_pool,
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
-	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
+	struct fast_pool	*fast_pool = this_cpu_ptr(&irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
 	cycles_t		cycles = random_get_entropy();

