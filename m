Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbaDBAfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:35:09 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:51309 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaDBAfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:35:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140401200145.05e0437e@gandalf.local.home>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
	<CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
	<20140331230347.GH32556@tassilo.jf.intel.com>
	<CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
	<CA+55aFxCCOASxhgRfGmNRPgHwZQJ2Q0Oa9-vwpMdmTqx99m26g@mail.gmail.com>
	<533B0B5F.2040907@linux.intel.com>
	<20140401200145.05e0437e@gandalf.local.home>
Date: Tue, 1 Apr 2014 17:35:05 -0700
X-Google-Sender-Auth: wdCxOTbMgGs-_XBwrIYShqdLwCs
Message-ID: <CA+55aFyQHdtgQpnS7ar2db5QoZhmMStH_LgxHvAaCUbVEx_PQQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Gleb Natapov <gleb@redhat.com>, Peter Anvin <hpa@zytor.com>,
        Jan Hubicka <hubicka@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 5:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Why would they break tracing? I remember there was a issue with compat
> calls, are these related to that?

They "break" tracing by being invisible to syscall tracing. As you
really should know ;)

The syscall tracing feature depends on the wrappers that
SYSCALL_DEFINEx() creates. See the SYSCALL_TRACE_ENTER_EVENT() etc
crud in <linux/syscalls.h>

So there's no SYSCALL_METADATA for those system calls that weren't
created with the proper SYSCALL_DEFINE() wrappers.

                  Linus
