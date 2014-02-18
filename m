Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaBRLog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:44:36 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:41110 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaBRLof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:44:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 23/27] clocksource: sh_cmt: Add DT support
Date: Tue, 18 Feb 2014 12:45:42 +0100
Message-ID: <7960294.4iO1tboz2Y@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CANqRtoQFeX0y3A9ojKMo8ao+PRFiCzcmjfOqexBRzv-4P1s7Uw@mail.gmail.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <3240866.imZR2oMAtf@avalon> <CANqRtoQFeX0y3A9ojKMo8ao+PRFiCzcmjfOqexBRzv-4P1s7Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Tuesday 18 February 2014 09:51:30 Magnus Damm wrote:
> On Tue, Feb 18, 2014 at 6:43 AM, Laurent Pinchart wrote:
> > On Monday 17 February 2014 10:48:55 Magnus Damm wrote:
> >> On Mon, Feb 17, 2014 at 10:45 AM, Laurent Pinchart wrote:
> >> > On Saturday 15 February 2014 02:22:00 Magnus Damm wrote:
> >> >> On Sat, Feb 15, 2014 at 1:12 AM, Laurent Pinchart wrote:
> >> >> > On Saturday 15 February 2014 01:01:30 Magnus Damm wrote:
> >> >> >> On Sat, Feb 15, 2014 at 12:53 AM, Laurent Pinchart wrote:

[snip]

> >> >> >> > There's still one piece of Linux-specific data I need though, as
> >> >> >> > I need to specify for each channel whether to use it as a clock
> >> >> >> > source device, a clock event device, both of them or none. That's
> >> >> >> > configuration information that needs to be provided somehow.
> >> >> >> 
> >> >> >> I think you can decide clock source or clock event assignment based
> >> >> >> on number of channels available. If you have only a single channel
> >> >> >> then both clock event and clock source need to be supported.
> >> >> >> Otherwise use one channel for clock source and the rest for clock
> >> >> >> events.
> >> >> > 
> >> >> > That won't match the current situation. Look at CMT0 in r8a7790 for
> >> >> > instance. There's two hardware channels available, and we only use
> >> >> > the first one, for clock events only.
> >> >> 
> >> >> You are correct. The reason for that is that the CMT driver today is
> >> >> optimized for combined clock event and clock source operation.
> >> >> 
> >> >> Historically the hardware it initially was written for (sh-mobile on
> >> >> the SH arch) only had a single timer channel so combined operation was
> >> >> required for tickless to work. But since you're asking how to allocate
> >> >> channels then I propose checking numbers of channels available and go
> >> >> from there. With that the r8a7790 support can only get better. =)

[snip]

> > Nonetheless, specifying which timer channel to use as a clock source and
> > which channel to use as a clock event device might need to be specified
> > in DT (or somewhere else, but I'm not sure what other options we have
> > here).
>
> I disagree about the need for specifying clock source or clock event channel
> in DT.  Since per-cpu timers is out of scope for now then why don't we
> simply just let the driver automatically allocate the during run-time?
> 
> In case one CMT channel exists:
> Use that for both clock source and clock event.
> 
> In case more than one CMT channel exists:
> Use one separate channel for clock source and one separate channel for clock
> event.
> 
> That would cover our existing use case, no?

One of the issues with that approach is that the decision on what to use a 
channel for will be taken locally from a timer point of view, without a global 
system-wide view. When more than one timer is available for a given platform 
(several CMT instances for instance, or CMT + TMU) the driver will decide on 
how to configure each instance without taking the other timers into account. 
Beside leading to creating more clock sources and clock event devices than 
today (is that a problem ?), couldn't it also lead to taking sub-optimal 
decisions ?

You also mentioned that only a subset of channels have the ability to run 
during sleep states. I suppose this needs to be taken into account as well. 
Could you please elaborate on our requirements in that area ?

-- 
Regards,

Laurent Pinchart

