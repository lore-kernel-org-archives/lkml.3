Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaEIU0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:26:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:38522 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbaEIU0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:26:33 -0400
Date: Fri, 9 May 2014 22:26:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: I'll queue a patch for 3.11 which removes the #ifdef... (was:
 Re: idle: Add the stack canary init to cpu_startup_entry())
In-Reply-To: <CAMuHMdV5yA8yyhao8SLCTWmo8bjof-BMQRK_UW+GUGE8pvAdUA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1405092211230.6261@ionos.tec.linutronix.de>
References: <CAMuHMdV5yA8yyhao8SLCTWmo8bjof-BMQRK_UW+GUGE8pvAdUA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Geert Uytterhoeven wrote:

> On Thu, Jun 20, 2013 at 8:31 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
> > Gitweb:     http://git.kernel.org/linus/;a=commit;h=d7880812b3594d3c6dcbe3cfd71dabb17347d082
> > Commit:     d7880812b3594d3c6dcbe3cfd71dabb17347d082
> > Parent:     c7788792a5e7b0d5d7f96d0766b4cb6112d47d75
> > Author:     Thomas Gleixner <tglx@linutronix.de>
> > AuthorDate: Mon Jun 10 16:52:03 2013 +0200
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Tue Jun 11 22:04:47 2013 +0200
> >
> >     idle: Add the stack canary init to cpu_startup_entry()
> >
> >     Moving x86 to the generic idle implementation (commit 7d1a9417 "x86:
> >     Use generic idle loop") wreckaged the stack protector.
> >
> >     I stupidly missed that boot_init_stack_canary() must be inlined from a
> >     function which never returns, but I put that call into
> >     arch_cpu_idle_prepare() which of course returns.
> >
> >     I pondered to play tricks with arch_cpu_idle_prepare() first, but then
> >     I noticed, that the other archs which have implemented the
> >     stackprotector (ARM and SH) do not initialize the canary for the
> >     non-boot cpus.
> >
> >     So I decided to move the boot_init_stack_canary() call into
> >     cpu_startup_entry() ifdeffed with an CONFIG_X86 for now. This #ifdef
> >     is just a temporary measure as I don't want to inflict the
> >     boot_init_stack_canary() call on ARM and SH that late in the cycle.
> >
> >     I'll queue a patch for 3.11 which removes the #ifdef if the ARM/SH
> >     maintainers have no objection.
> 
> Any progress here?

Obviosly not. None of the !x86 folks seemed to think that it matters
and I simply forgot about it. Bah, I can't even find the complex patch
anymore which solves that issue.

The main complexity is:

-#ifdef CONFIG_X86
...
-#ifdef

But I didn't want to do that without input of the affected subarch
maintainers.

Care to send that patch and I'll throw it into next and we watch the
resulting fireworks together :)

Thanks,

	tglx
