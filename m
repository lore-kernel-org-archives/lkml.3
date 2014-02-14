Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaBNUTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:19:37 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:34014
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbaBNUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:30 -0500
Message-Id: <20140214201904.974298699@linux.com>
Date: Fri, 14 Feb 2014 14:18:51 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 10/48] drivers/char/random: Replace __get_cpu_var uses
References: <20140214201841.826179349@linux.com>
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

