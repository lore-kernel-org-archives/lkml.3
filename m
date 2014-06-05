Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaFEMfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:35:19 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58748 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFEMfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:35:17 -0400
Date: Thu, 5 Jun 2014 14:35:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605123512.GB1392@gmail.com>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <20140605081742.GC4926@gmail.com>
 <20140605111110.GA26771@gmail.com>
 <20140605122715.GD6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605122715.GD6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jun 05, 2014 at 01:11:10PM +0200, Ingo Molnar wrote:
> > Unfortunately even with the latest bits from you the breakage I 
> > reported weeks ago is not resolved:
> 
> crap, its the qrwlock bits, I fixed it for the config you gave me. 
> Some paravirt crap header hell thing. Happen to have another 
> .config?

A simple 'make defconfig' triggers the build failure for me:

  kernel/locking/qrwlock.c:24:25: fatal error: asm/qrwlock.h: No such file or directory

If I apply the minimal feature-enabling patch below on top of the base 
qrwlock patch.

Thanks,

	Ingo

==========================>
>From a79dedeee44dadf8e033a047b7cd4409bb7ad0d8 Mon Sep 17 00:00:00 2001
From: Waiman Long <Waiman.Long@hp.com>
Date: Mon, 3 Feb 2014 13:18:57 +0100
Subject: [PATCH] x86, locking: Switch x86 to qrwlock-style rwlocks

Make x86 use the fair rwlock_t.

Don't implement a custom queue_write_unlock() yet, use the generic path.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-r1xuzmdysvuhl3h86n5fbxi7@git.kernel.org
Cc: "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
[ Simplified it. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..bf7626f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -121,6 +121,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select ARCH_USE_BUILTIN_BSWAP
+	select ARCH_USE_QUEUE_RWLOCK
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
