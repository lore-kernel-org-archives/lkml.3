Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaDBABy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:01:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:11724 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755224AbaDBABu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:01:50 -0400
Date: Tue, 1 Apr 2014 20:01:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Anvin <hpa@zytor.com>, Jan Hubicka <hubicka@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
Message-ID: <20140401200145.05e0437e@gandalf.local.home>
In-Reply-To: <533B0B5F.2040907@linux.intel.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
	<CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
	<20140331230347.GH32556@tassilo.jf.intel.com>
	<CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
	<CA+55aFxCCOASxhgRfGmNRPgHwZQJ2Q0Oa9-vwpMdmTqx99m26g@mail.gmail.com>
	<533B0B5F.2040907@linux.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2014 11:54:23 -0700
"H. Peter Anvin" <hpa@linux.intel.com> wrote:

> On 03/31/2014 05:33 PM, Linus Torvalds wrote:
> > 
> > I notice that there seems to be a handful of x86 system calls that
> > don't use the SYSCALL_DEFINEx() macros to define the system call, some
> > grepping finds at least ioperm(), modify_ldt(), sigreturn() and
> > rt_sigreturn(). There are probably others. They should just be
> > converted to SYSCALL_DEFINEx() while at it. No, x86 doesn't need the
> > typecasting, but it won't hurt either, and it's good to be consistent.
> > 
> > I'm not sure why those system calls didn't get converted (other
> > x86-specific ones like vm86() _have_ gotten converted), maybe there's
> > some reason for it. But I *think* the reason is "nobody noticed".
> > 
> 
> Pretty much.  If nothing else, it breaks tracing.

Why would they break tracing? I remember there was a issue with compat
calls, are these related to that?

-- Steve
