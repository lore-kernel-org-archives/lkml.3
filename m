Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaKUGhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:37:48 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50199 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaKUGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:37:47 -0500
Date: Fri, 21 Nov 2014 07:37:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121063742.GA29250@gmail.com>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141120152509.GA5412@redhat.com>
 <CA+55aFzP0jivKYWUVwt==wNaBjZM+aBQLMT=Td+2cOVKSvm-dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzP0jivKYWUVwt==wNaBjZM+aBQLMT=Td+2cOVKSvm-dQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...]
> 
> That's *especially* true if it turns out that the 3.17 problem 
> you saw was actually a perf bug that has already been fixed and 
> is in stable. We've been looking at kernel/smp.c changes, and 
> looking for x86 IPI or APIC changes, and found some harmlessly 
> (at least on x86) suspicious code and this exercise might be 
> worth it for that reason, but what if it's really just a 
> scheduler regression.
> 
> There's been a *lot* more scheduler changes since 3.17 than the 
> small things we've looked at for x86 entry or IPI handling. And 
> the scheduler changes have been about things like overloaded 
> scheduling groups etc, and I could easily imaging that some bug 
> *there* ends up causing the watchdog process not to schedule.
> 
> Hmm? Scheduler people?

Hm, that's a possibility, yes.

The watchdog threads are pretty simple beasts though, using 
SCHED_FIFO:

 kernel/watchdog.c:      watchdog_set_prio(SCHED_FIFO, MAX_RT_PRIO - 1);

which is typically only affected by less than 10% of scheduler 
changes - but it's entirely possible still.

It might make sense to disable the softlockup detector altogether 
and just see whether trinity finishes/wedges, whether a login 
over the console is still possible - etc.

The softlockup messages in themselves are only analytical, unless 
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1 is used.

Interesting bug.

Thanks,

	Ingo
