Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaBNQBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:01:33 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36589 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaBNQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:01:32 -0500
MIME-Version: 1.0
In-Reply-To: <107109887.afEv2P92gg@avalon>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1392339605-20691-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<20140214105822.GE9907@e106331-lin.cambridge.arm.com>
	<107109887.afEv2P92gg@avalon>
Date: Sat, 15 Feb 2014 01:01:30 +0900
Message-ID: <CANqRtoS-d-CW3XX3_E2dgJ83btRZYWiMCYmWUJAPqh9EeBhLEQ@mail.gmail.com>
Subject: Re: [PATCH 23/27] clocksource: sh_cmt: Add DT support
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 12:53 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Friday 14 February 2014 10:58:22 Mark Rutland wrote:
>> On Fri, Feb 14, 2014 at 01:00:01AM +0000, Laurent Pinchart wrote:
>> > +Channels Optional Properties:
>> > +
>> > +  - clock-source-rating: rating of the timer as a clock source device.
>> > +  - clock-event-rating: rating of the timer as a clock event device.
>>
>> This feels like a leak of Linux internals. Why do you need this?
>
> You're right, it is. The clock source and clock event ratings are currently
> configured through platform data, I'll need to find a way to compute them in
> the driver instead.

That would be very good!

> There's still one piece of Linux-specific data I need though, as I need to
> specify for each channel whether to use it as a clock source device, a clock
> event device, both of them or none. That's configuration information that
> needs to be provided somehow.

I think you can decide clock source or clock event assignment based on
number of channels available. If you have only a single channel then
both clock event and clock source need to be supported. Otherwise use
one channel for clock source and the rest for clock events.

This is probably out of scope for this DT conversion, but it would be
neat if you somehow could specify the CPU affinity for a channel to
tie a clock event to an individual CPU core. This would make a a
per-cpu timer unless I'm mistaken. But that's more of a software
policy than anything else.

Thanks,

/ magnus
