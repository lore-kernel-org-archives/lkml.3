Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3FQCrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 22:47:15 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39168 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab3FQCrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 22:47:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130617021342.GJ15043@verge.net.au>
References: <20130617002056.7646.54131.sendpatchset@w520>
	<20130617021342.GJ15043@verge.net.au>
Date: Mon, 17 Jun 2013 11:47:11 +0900
Message-ID: <CANqRtoTfiWFv0JWwJysi47gsSjJx9g3-FFMMzCYROWDPbndnYQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] arm: arch_timer: Do not set C3STOP in case CPU_IDLE=n
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Mon, Jun 17, 2013 at 11:13 AM, Simon Horman <horms@verge.net.au> wrote:
> On Mon, Jun 17, 2013 at 09:20:56AM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Modify the ARM architected timer driver to not set C3STOP
>> in case CPU_IDLE is disabled. This is a short term fix that
>> allows use of high resolution timers even though no additional
>> clock event is registered.
>>
>> Not-really-Signed-off-by: Magnus Damm <damm@opensource.se>
>> ---
>>
>>  If someone cares about this case then perhaps it should be
>>  moved up to the clock event main code. The same issue should
>>  in theory trigger on all architectures, perhaps x86 people
>>  hunting for low latency may try to disable CPU_IDLE?
>>
>>  I propose carrying this patch locally to enable high resolution
>>  timers until CPU_IDLE and an additional clock event is supported.
>>
>>  Observed on r8a73a4 and APE6EVM.
>
> Hi Magnus,
>
> Is this patch intended to be picked up by me for the LTSI-3.4.25 based
> backports that live in my renesas-backports tree?

Yes, correct.

The patch was mainly written to satisfy a feature request for your
backports, but I noticed that the same issue exists in upstream as
well.

Ideally I'd like to use the same code for the backport and upstream,
but I am not sure if anyone in upstream really cares. The more long
term solution is obviously to install a second clock event, perhaps
that's good enough.

> If so, could you  clearly state this (below the '---' is fine) and
> include a proper Sob line to indicate that it is fit to be merged
> even if that merge is not into mainline.

Sure, but  I'd like to hear opinions from other people before
resending. I will follow your recommendation in next version.

Thanks,

/ magnus
