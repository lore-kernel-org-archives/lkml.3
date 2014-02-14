Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaBNQLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:11:23 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:42065 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBNQLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:11:22 -0500
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
Date: Fri, 14 Feb 2014 17:12:27 +0100
Message-ID: <1790131.DSZsj6HrSK@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CANqRtoS-d-CW3XX3_E2dgJ83btRZYWiMCYmWUJAPqh9EeBhLEQ@mail.gmail.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <107109887.afEv2P92gg@avalon> <CANqRtoS-d-CW3XX3_E2dgJ83btRZYWiMCYmWUJAPqh9EeBhLEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Saturday 15 February 2014 01:01:30 Magnus Damm wrote:
> On Sat, Feb 15, 2014 at 12:53 AM, Laurent Pinchart wrote:
> > On Friday 14 February 2014 10:58:22 Mark Rutland wrote:
> >> On Fri, Feb 14, 2014 at 01:00:01AM +0000, Laurent Pinchart wrote:
> >> > +Channels Optional Properties:
> >> > +
> >> > +  - clock-source-rating: rating of the timer as a clock source device.
> >> > +  - clock-event-rating: rating of the timer as a clock event device.
> >> 
> >> This feels like a leak of Linux internals. Why do you need this?
> > 
> > You're right, it is. The clock source and clock event ratings are
> > currently configured through platform data, I'll need to find a way to
> > compute them in the driver instead.
> 
> That would be very good!

Any pointer would be appreciated :-) How did you compute the various ratings 
used in platform data all over the place ?

> > There's still one piece of Linux-specific data I need though, as I need to
> > specify for each channel whether to use it as a clock source device, a
> > clock event device, both of them or none. That's configuration
> > information that needs to be provided somehow.
> 
> I think you can decide clock source or clock event assignment based on
> number of channels available. If you have only a single channel then both
> clock event and clock source need to be supported. Otherwise use one channel
> for clock source and the rest for clock events.

That won't match the current situation. Look at CMT0 in r8a7790 for instance. 
There's two hardware channels available, and we only use the first one, for 
clock events only.

> This is probably out of scope for this DT conversion, but it would be neat
> if you somehow could specify the CPU affinity for a channel to tie a clock
> event to an individual CPU core. This would make a a per-cpu timer unless
> I'm mistaken. But that's more of a software policy than anything else.

Yes, that's a configuration that needs to be specified somewhere. I don't know 
where though.

-- 
Regards,

Laurent Pinchart

