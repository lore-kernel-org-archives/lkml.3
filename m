Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbaDBMdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:33:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:14452 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758456AbaDBMd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:33:29 -0400
Date: Wed, 2 Apr 2014 08:33:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Gleb Natapov <gleb@redhat.com>, Peter Anvin <hpa@zytor.com>,
        Jan Hubicka <hubicka@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
Message-ID: <20140402083325.2b6e5d8b@gandalf.local.home>
In-Reply-To: <CA+55aFyQHdtgQpnS7ar2db5QoZhmMStH_LgxHvAaCUbVEx_PQQ@mail.gmail.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
	<CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
	<20140331230347.GH32556@tassilo.jf.intel.com>
	<CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
	<CA+55aFxCCOASxhgRfGmNRPgHwZQJ2Q0Oa9-vwpMdmTqx99m26g@mail.gmail.com>
	<533B0B5F.2040907@linux.intel.com>
	<20140401200145.05e0437e@gandalf.local.home>
	<CA+55aFyQHdtgQpnS7ar2db5QoZhmMStH_LgxHvAaCUbVEx_PQQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2014 17:35:05 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Apr 1, 2014 at 5:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Why would they break tracing? I remember there was a issue with compat
> > calls, are these related to that?
> 
> They "break" tracing by being invisible to syscall tracing. As you
> really should know ;)
> 
> The syscall tracing feature depends on the wrappers that
> SYSCALL_DEFINEx() creates. See the SYSCALL_TRACE_ENTER_EVENT() etc
> crud in <linux/syscalls.h>
> 
> So there's no SYSCALL_METADATA for those system calls that weren't
> created with the proper SYSCALL_DEFINE() wrappers.
> 

Heh, I know that not having the SYSCALL_DEFINEx() wrappers means that
they wont be traced. I must have misunderstood Peter, as I thought he
meant if we added SYSCALL_DEFINEx(), that they would break tracing.

IIRC, the compat calls had some issues with the SYSCALL_DEFINE()
macros, and I was thinking theses functions would have some off the
wall issue as well.

Yeah, adding the SYSCALL_DEFINEx() macros around those functions would
be good for tracing as well.

Glad I understand you two now ;-)

I would have thought my jet lag would be over by now.

-- Steve
