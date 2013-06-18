Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3FRHcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:32:11 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:62947 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3FRHcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:32:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130617145352.GG6809@e106331-lin.cambridge.arm.com>
References: <20130617002056.7646.54131.sendpatchset@w520>
	<20130617145352.GG6809@e106331-lin.cambridge.arm.com>
Date: Tue, 18 Jun 2013 16:32:07 +0900
Message-ID: <CANqRtoTu7U6x6QmiV8JsCxeF8WU3n_bndFgR0Tif5TwEpFXbLA@mail.gmail.com>
Subject: Re: [PATCH/RFC] arm: arch_timer: Do not set C3STOP in case CPU_IDLE=n
From: Magnus Damm <magnus.damm@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "shinya.kuribayashi.px@renesas.com" 
	<shinya.kuribayashi.px@renesas.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jun 17, 2013 at 11:53 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Jun 17, 2013 at 01:20:56AM +0100, Magnus Damm wrote:
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
>
> I think that changing tick_is_oneshot_capable and friends to only worry about
> C3STOP when CPU_IDLE is enabled would be a nicer solution. That way you enable
> all clock_event_devices with C3STOP to function as high resolution timers when
> CPU_IDLE's selected. Presenting the hardware differently depending on CPU_IDLE
> feels wrong.

I agree that doing this in the clock event driver is a bit odd. So
because of that I just posted this patch:

[PATCH/RFC] clockevents: Ignore C3STOP when CPUIdle is disabled

> Having some other clock_event_device would be a nicer solution still.

No doubt that another clock event device helps, but mainly together
with CPU Idle IMO.

Thanks for your comments!

/ magnus
