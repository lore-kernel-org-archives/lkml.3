Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaBNQOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:14:21 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:42084 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaBNQOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:14:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Cartwright <joshc@codeaurora.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH 23/27] clocksource: sh_cmt: Add DT support
Date: Fri, 14 Feb 2014 17:15:24 +0100
Message-ID: <14506828.ROIfyxOcTT@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140214155951.GA22449@joshc.qualcomm.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <107109887.afEv2P92gg@avalon> <20140214155951.GA22449@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Friday 14 February 2014 09:59:51 Josh Cartwright wrote:
> On Fri, Feb 14, 2014 at 04:53:08PM +0100, Laurent Pinchart wrote:
> > On Friday 14 February 2014 10:58:22 Mark Rutland wrote:
> > > On Fri, Feb 14, 2014 at 01:00:01AM +0000, Laurent Pinchart wrote:
> > > > +Channels Optional Properties:
> > > > +
> > > > +  - clock-source-rating: rating of the timer as a clock source
> > > > device.
> > > > +  - clock-event-rating: rating of the timer as a clock event device.
> > > 
> > > This feels like a leak of Linux internals. Why do you need this?
> > 
> > You're right, it is. The clock source and clock event ratings are
> > currently configured through platform data, I'll need to find a way to
> > compute them in the driver instead.
> > 
> > There's still one piece of Linux-specific data I need though, as I need to
> > specify for each channel whether to use it as a clock source device, a
> > clock event device, both of them or none. That's configuration
> > information that needs to be provided somehow.
> 
> Are all the channels equally capable?  We had this problem for the
> cadence_ttc timer used on Zynq, and decided to just statically allocate
> the first timer to be the clocksource, and the second to be the
> clockevent.

No, they're not. The channels can be implemented with different counter 
widths, different available prescalers and source clocks and different power 
management features (not all of them are capable to run in all sleep states).

> Also, should the rating really be user configurable?

Probably not. I suppose the rating should be computed by the driver based on 
the source clock frequency, prescaler and counter width. Any help there would 
be very appreciated, I'm pretty new to clock source and clock event devices.

-- 
Regards,

Laurent Pinchart

