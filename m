Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab3BTKJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:09:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:38293 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab3BTKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:09:06 -0500
Date: Wed, 20 Feb 2013 11:09:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linaro-dev >> Lists Linaro-dev" <linaro-dev@lists.linaro.org>
Subject: Re: [resend] Timer broadcast question
In-Reply-To: <512400B2.9010801@mit.edu>
Message-ID: <alpine.LFD.2.02.1302201106590.22263@ionos>
References: <5123BE35.8070902@linaro.org> <alpine.LFD.2.02.1302191904560.22263@ionos> <5123C299.3080005@linaro.org> <512400B2.9010801@mit.edu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Andy Lutomirski wrote:
> On 02/19/2013 10:21 AM, Daniel Lezcano wrote:
> > On 02/19/2013 07:10 PM, Thomas Gleixner wrote:
> >> On Tue, 19 Feb 2013, Daniel Lezcano wrote:
> >>> I am working on identifying the different wakeup sources from the
> >>> interrupts and I have a question regarding the timer broadcast.
> >>>
> >>> The broadcast timer is setup to the next event and that will wake up any
> >>> idle cpu belonging to the "broadcast cpumask", right ?
> >>>
> >>> The cpu which has been woken up will look for each cpu the next-event
> >>> and send an IPI to wake it up.
> >>>  
> >>> Although, it is possible the sender of this IPI may not be concerned by
> >>> the timer expiration and has been woken up just for sending the IPI, right ?
> >>
> >> Correct.
> >>  
> >>> If this is correct, is it possible to setup the timer irq affinity to a
> >>> cpu which will be concerned by the timer expiration ? so we prevent an
> >>> unnecessary wake up for a cpu.
> >>
> >> It is possible, but we never implemented it.
> >>
> >> If we go there, we want to make that conditional on a property flag,
> >> because some interrupt controllers especially on x86 only allow to
> >> move the affinity from interrupt context, which is pointless.
> > 
> > Thanks Thomas for your quick answer. I will write a RFC patchset.
> 
> I'm curious what the use case is.  I played with this code awhile ago,
> and AFAICT it's not used on sensible (i.e. modern) systems.  Is there
> anything other than old x86 machines that needs it?

If the local apic timer is not affected by C-States, it's irrelevant,
but there are enough machines out there which do not have that. The
point is that we want a flag on the broadcast device which tells us
whether we should use dynamic affinity settings or not. On x86 we
would not set that flag ever.

Thanks,

	tglx


