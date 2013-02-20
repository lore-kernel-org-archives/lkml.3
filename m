Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab3BTJCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:02:45 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59952 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3BTJCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:02:43 -0500
Date: Wed, 20 Feb 2013 10:02:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/platform changes for v3.9
Message-ID: <20130220090238.GA18213@gmail.com>
References: <20130219154128.GA15608@gmail.com>
 <CA+55aFxn=xFGhF8L2pJYP8wOe3VdCpGtaibB0bbRuH8FAKkCNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxn=xFGhF8L2pJYP8wOe3VdCpGtaibB0bbRuH8FAKkCNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Feb 19, 2013 at 7:41 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest x86-platform-for-linus git tree from:
> 
> Hmm.
> 
> My main desktop just had a reboot failure - it just got stuck 
> at the end, not powering down, and not rebooting like it 
> should have.
> 
> This is *not* necessarily the pull that caused it, but 
> 8f55cea410db rebooted cleanly, and 1a13c0b181f2 did not. That 
> implies that it's one of your pull requests. The pulls I did 
> in between are:
> 
>  - scheduler (with the dyntick and cputime accounting)
> 
>  - smp-hotplug-for-linus: stop_machine preparatory patches from Thomas..
> 
>  - timers-core-for-linus. Hmm..
> 
>  - x86-apic-for-linus: certainly possibly causing problems at shutdown..
> 
>  - x86-asm-for-linus: sounds unlikely, but who knows..
> 
>  - x86-boot-for-linus: shouldn't affect shutdown, but..
> 
>  - x86-build-for-linus: _really_ shouldn't affect shutdown..
> 
>  - x86-cleanups-for-linus: unlikely
> 
>  - x86-hyperv-for-linus: no, not a hyperv user ;)
> 
>  - x86-platform-for-linus: rebooting is a platform thing, but none of
> this seems relevant
> 
>  - x86-uv-for-linus: not likely relevant.
> 
> I'm not going to bisect it right now, hoping that somebody 
> goes "Hmm, maybe it's xyzzy". And maybe it was just a one-time 
> event, but I don't recall having had that whole "reboot fails" 
> case on this machine before. Any ideas?

Hm, no quick ideas. None of those trees had any similar problems 
during development, so there's no "drat, it must be _that_ tree 
again" memory.

Timers and APIC would be my leading suspect - but scheduler and 
hotplug changes might be the culprits as well.

Yesterday, while preparing the trees I wanted to mention this 
x86/apic commit:

  336224ba5e4f x86, apic: Mask IO-APIC and PIC unconditionally on LAPIC resume

... as a change that needs monitored because it changes the 
suspend and shutdown sequence but then skipped mentioning it 
because it seemed relatively old and proven.

But there are other potentially dangerous commits as well - I 
suspect we won't be able to avoid a bisection :-/

Thanks,

	Ingo
