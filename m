Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaDQKYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:24:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48850 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaDQKYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:24:47 -0400
Date: Thu, 17 Apr 2014 12:24:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, atodorov@redhat.com,
        tony.luck@intel.com, gong.chen@linux.intel.com,
        jwboyer@fedoraproject.org, qmewlo@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140417102442.GA8215@pd.tnic>
References: <tip-ea431643d6c38728195e2c456801c3ef66bb9991@git.kernel.org>
 <20140417100944.GG11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140417100944.GG11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:09:44PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 17, 2014 at 02:57:54AM -0700, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  ea431643d6c38728195e2c456801c3ef66bb9991
> > Gitweb:     http://git.kernel.org/tip/ea431643d6c38728195e2c456801c3ef66bb9991
> > Author:     Ingo Molnar <mingo@kernel.org>
> > AuthorDate: Thu, 17 Apr 2014 10:25:53 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Thu, 17 Apr 2014 10:28:42 +0200
> > 
> > x86/mce: Fix CMCI preemption bugs
> > 
> > The following commit:
> > 
> >   27f6c573e0f7 ("x86, CMCI: Add proper detection of end of CMCI storms")
> > 
> > Added two preemption bugs:
> > 
> >  - machine_check_poll() does a get_cpu_var() without a matching
> >    put_cpu_var(), which causes preemption imbalance and crashes upon
> >    bootup.
> > 
> >  - it does percpu ops without disabling preemption. Preemption is not
> >    disabled due to the mistaken use of a raw spinlock.
> 
> it is arch_spinlock that doesn't disable preemption. raw_spinlock
> disables preemption just fine.

Hohum, __raw_spin_lock_irqsave does preempt_disable(). And
machine_check_poll should be running in irq context so why would the
original issue happen?

> kernel: [    7.341085] BUG: using __this_cpu_write() in preemptible [00000000] code: modprobe/546

Unfortunately, I have only one line in a mail CCed to me.

Color me confused.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
