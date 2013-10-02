Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3JBNze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:55:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44580 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab3JBNzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:55:32 -0400
Date: Wed, 2 Oct 2013 15:55:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, bp@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/boot] x86/boot: Further compress CPUs bootup message
Message-ID: <20131002135528.GC20568@pd.tnic>
References: <20130930095624.GB16383@pd.tnic>
 <tip-a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077@git.kernel.org>
 <20131002115235.GR3081@twins.programming.kicks-ass.net>
 <20131002122020.GN26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131002122020.GN26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 02:20:20PM +0200, Peter Zijlstra wrote:
> > [    0.314494] smpboot: Booting Node   0, Processors  #   1[    0.333365] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> >  #   2 #   3 #   4 #   5 OK
> > [    0.398473] smpboot: Booting Node   1, Processors  #   6 #   7 #   8 #   9 #  10 #  11 OK
> > [    0.565198] smpboot: Booting Node   0, Processors  #  12 #  13 #  14 #  15 #  16 #  17 OK
> > [    0.654558] smpboot: Booting Node   1, Processors  #  18 #  19 #  20 #  21 #  22 #  23 OK
> > [    0.743527] Brought up 24 CPUs
> 
> operator error here.. this was from the (old) fallback kernel; the new
> one didn't actually boot.

FWIW, this will happen, regardless of what we do:

[    0.089350] x86: Booting SMP configuration:
[    0.104355] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.089427] .... node  #0, CPUs:      #1 #2 #3
[    0.136301] x86: Booted up 1 node, 4 CPUs
[    0.136442] smpboot: Total of 4 processors activated (23146.32 BogoMIPS)

as the NMI watchdog thing keeps shouting in-between. Do we still need it
- I mean, how can I really use the info that NMI watchdog is consuming a
perf counter? I mean I know how, but do people actually use that info or
everyone knows already? :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
