Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaFDQXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:23:46 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:58296 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbaFDQXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:23:44 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <alpine.DEB.2.10.1406041134070.3319@nanos>
References: <20140604160522.1d788c1e@canb.auug.org.au>
	<alpine.DEB.2.10.1406041134070.3319@nanos>
Date: Wed, 4 Jun 2014 09:23:43 -0700
Message-ID: <CAOesGMhGT30QN2LeVp2sgzY0BjbguW=iw3x1PH8RVB-Rj-GZNQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tip tree
From: Olof Johansson <olof@lixom.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 3:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 4 Jun 2014, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> After merging the tip tree, today's linux-next build (arm
>> multi_v7_defconfig) failed like this:
>>
>>
>> drivers/clocksource/versatile.c: In function 'versatile_sched_clock_init':
>> drivers/clocksource/versatile.c:37:2: error: implicit declaration of function 'setup_sched_clock' [-Werror=implicit-function-declaration]
>>
>> Caused by commit c04ae71c9c26 ("sched_clock: Remove deprecated
>> setup_sched_clock() API") from the tip tree.  The usage was only added
>> to Linus' tree today by commit 220e2a8d22cd ("clocksource: Sched clock
>> source for Versatile Express") (but this commit has been in linux-next
>> since May 22 at least).
>>
>> I have reverted the tip tree commit for today.
>
> Dammit. Why the heck can ARM folks not route their stuff through the
> relevant maintainers? Because ARM is a different universe with
> different rules or what?

We talked about this as late as February this year. It's has been a
long-standing issue that we've struggled with how we should manage.

When I talked to you about it (irqchip drivers at the time), you said
you were in general fine with us merging driver patches when someone
times out waiting on you to review/merge a patch. My concern at the
time is that while we can look at the code of the patch and review
that, we don't have the larger picture of what's going on in the
subsystem. Which is what caused problems here, I'd say.

So, we'll dial back and stop taking these patches through our tree
without an explicit ack or shared branch from you (or Daniel on
clocksource). Not a problem at all.

> Of course this crap is already in Linus next branch, so it essentially
> blocks me from sending my pending timers/core branch.

We obviously never intended to cause any problems like these, and I
apologize for that. On the other hand, it would have been a lot easier
to handle had the code on your end landed a bit sooner than in the
middle of the merge window.

> Patch below. Linus, can you please apply this?
>
> I've ranted about this before. It's not the first time that ARM breaks
> stuff I maintain.
>
> Again: Send your stuff against drivers/clocksource and drivers/irqchip
> to the maintainers.
>
> I'm happy to provide you a separate branch to pull that stuff from me,
> if you have dependencies on that, but I really don't want to see any
> of this again, ever.
>
> Yours seriously grumpy

Not much I can say besides what's above and that I owe you a few beers
at the next conference.


-Olof
