Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaAQQKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:10:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:54478 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:10:19 -0500
Date: Fri, 17 Jan 2014 17:10:16 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
Message-ID: <20140117161016.GE5785@linutronix.de>
References: <20131223225017.GA8623@linutronix.de>
 <20131227200024.GA19505@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131227200024.GA19505@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2013-12-27 21:00:24 [+0100]:

>> - A patch from Thomas Gleixner not to raise the timer softirq
>>   unconditionally (only if a timer is pending)
>> 
>
>This one seems to deadlock early in the boot sequence on x86
>(i3/i7/Phenom-4x here and Carsten Emde also had boot failures)
>
>after droping this patch with:
>patch -p1 -R < ../paches/timers-do-not-raise-softirq-unconditionally.patch
>3.12.6-rt9 boots up fine. cyclictest seems to be back to what it was before
>(only ran for a few minutes idle and 1h with load on an i3).
>
>The main problem with this patch though are proceduaral isues 
>the commit note - which is a mail exchange - actually does not explain what 
>the rational for the changes is (...well I don't understand the logic of
>run_local_timers - if someone can explain - pleas do) and notably:
>
>from timers-do-not-raise-softirq-unconditionally.patch
><snip>
>well, that very same problem is in mainline if you add "threadirqs" to
>the command line. But we can be smart about this. The untested patch
>                                                    ^^^^^^^^^^^^^^^^^^
>below should address that issue. If that works on mainline we can
>adapt it for RT (needs a trylock(&base->lock) there).
><snip>
>
> does make me wonder why this went into -rt9 ?

It was on the mailing list for a few weeks. My understanding was that
Mike Galbraith tested it on mainline and then I added the RT specific
pieces and added it it to the tree.

> It also build fails with CONFIG_PREEMPT_RT_FULL not set.

I will add a non-RT based config to my compile tests.

> as with this patch, systems that booted just fine with 3.12.5-rt7 don't
> even boot (atleast my 3 x86 test boxes here did not) this raises some
> questions regarding the process of getting patches into -rtX - are
> we going to fast here ?
>
> I would prefere if such patches would go out with a request for testing
> or atleast a "might blow up your system" note in them...

I didn't expect that much trouble. In general I try to avoid adding
explosives unless marked as such.

>thx!
>hofrat

Sebastian
