Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaJUQLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:11:10 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:54170 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbaJUQLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410211210000.5308@nanos>
References: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1410211210000.5308@nanos>
Date: Tue, 21 Oct 2014 09:11:04 -0700
Message-ID: <CALAqxLVtYeHX0qBkOFjf58opp9ympxbjFa2DsaYx-KOthqQS=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] time: Fix NTP adjustment mult overflow.
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 3:19 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 9 Oct 2014, pang.xunlei wrote:
>
> First of all: Please use proper line breaks in the changelog.
>
>> The mult memember of struct clocksource should always be a large u32
>> number when calculated through __clocksource_updatefreq_scale(). The
>> value of (cs->mult+cs->maxadj) may have a chance to reach very near
>> 0xFFFFFFFF.
>
> And what's the actual problem with reaching a value near 0xFFFFFFFF?
>
>> For instance, 555MHz oscillator: cs->mult is 0xE6A17102,
>> cs->maxadj is 0x195E8EFD, cs->mult+cs->maxadj is 0xFFFFFFFF. Such
>> oscillators would probably exist on some processors like MIPS which
>> use CP0 compare/count CPU clock as the clock source.
>
> Again, what's the problem?

So the problem is that with an adjustment the mult value might
overflow, becoming very small, bascially causing time to stop
increasing. This is mentioned below, but I agree we're burying the
headline a bit.


>> Clocksource might encounter large frequency adjustment due to the
>> hardware unstability, environment temperature, software deviation,
>> NTP algorithm accuracy, etc. When NTP slewes the clock, kernel goes
>> through update_wall_time()->...->timekeeping_apply_adjustment():
>> tk->tkr.mult += mult_adj; Unfortunately, tk->tkr.mult may overflow
>> after this operation, though such cases are next to impossible to
>> happen in practice.
>
> So you adding this just for correctness reasons, not because you
> observed the problem in practice?

This is my understanding.

I'll work with Xunlei to make further clarifications to the changelog
to make this more explicit.

Thanks for your feedback!
-john
