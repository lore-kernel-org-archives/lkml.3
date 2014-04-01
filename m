Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaDAAdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:33:55 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:51742 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaDAAdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
	<CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
	<20140331230347.GH32556@tassilo.jf.intel.com>
	<CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
Date: Mon, 31 Mar 2014 17:33:52 -0700
X-Google-Sender-Auth: r3YLJyVrw3ZjpQfnE_mg4IO3wbo
Message-ID: <CA+55aFxCCOASxhgRfGmNRPgHwZQJ2Q0Oa9-vwpMdmTqx99m26g@mail.gmail.com>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Anvin <hpa@zytor.com>, Jan Hubicka <hubicka@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 5:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So what I would propose is:
>
>  - don't do the __visible as part of asmlinkage, because it really is
> conceptually wrong
>
>  - add the visible to the SYSCALL_DEFINEx() macros
>
> and after that I strongly suspect that there will be only a handful of
> cases left that are called from assembly language and that aren't
> system calls. Things like "printk()" and friends that are really
> special. They'd need a few manual "__visible" annotations.

I notice that there seems to be a handful of x86 system calls that
don't use the SYSCALL_DEFINEx() macros to define the system call, some
grepping finds at least ioperm(), modify_ldt(), sigreturn() and
rt_sigreturn(). There are probably others. They should just be
converted to SYSCALL_DEFINEx() while at it. No, x86 doesn't need the
typecasting, but it won't hurt either, and it's good to be consistent.

I'm not sure why those system calls didn't get converted (other
x86-specific ones like vm86() _have_ gotten converted), maybe there's
some reason for it. But I *think* the reason is "nobody noticed".

                  Linus
