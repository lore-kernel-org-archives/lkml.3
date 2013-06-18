Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3FRMa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:30:29 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:56190 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3FRMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:30:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sh_cmt: 32-bit control register support
Date: Tue, 18 Jun 2013 14:30:41 +0200
Message-ID: <6180605.R3OXnJCA3O@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CANqRtoTRcpEH13GY4jvmX5POFEZf2B6+vu0-ZGCMCk+sAeF7Ww@mail.gmail.com>
References: <20130617064052.3573.68839.sendpatchset@w520> <1531456.g1EpKAjrma@avalon> <CANqRtoTRcpEH13GY4jvmX5POFEZf2B6+vu0-ZGCMCk+sAeF7Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Tuesday 18 June 2013 20:54:47 Magnus Damm wrote:
> On Tue, Jun 18, 2013 at 7:35 PM, Laurent Pinchart wrote:
> > On Tuesday 18 June 2013 14:39:38 Magnus Damm wrote:
> >> On Tue, Jun 18, 2013 at 3:37 AM, Laurent Pinchart wrote:
> >> > On Monday 17 June 2013 15:40:52 Magnus Damm wrote:
> >> >> From: Magnus Damm <damm@opensource.se>
> >> >> 
> >> >> Add support for CMT hardware with 32-bit control and counter
> >> >> registers, as found on r8a73a4 and r8a7790. To use the CMT
> >> >> with 32-bit hardware a second I/O memory resource needs to
> >> >> point out the CMSTR register and it needs to be 32 bit wide.
> >> > 
> >> > Is a memory second resource required ? Can't we use a single resource
> >> > that will contain all the registers ?
> >> 
> >> The CMT hardware block comes with a shared timer start stop register
> >> that historically has been left out of the resource. The location of
> >> this register has so far been pointed out by the "channel offset"
> >> platform data member, together with information about which bit that
> >> happens to be assigned to the timer channel. This start stop register
> >> has happened to be kept in the same page of I/O memory as the main
> >> timer channel resource, so at this point we're sort of "lucky" that a
> >> single ioremap() has covered all cases.
> >> 
> >> With this patch it becomes optional to instead of platform data use a
> >> second resource to point out the timer start/stop register. While we
> >> do that we can also use the size of that resource to determine the I/O
> >> access width, which happens to be something that is needed to enable
> >> the driver on certain SoCs.
> > 
> > OK, I get it now. I've had a quick look at the documentation, and I'm
> > wondering whether we shouldn't register a single platform device that span
> > all the channels contained in the CMT, instead of registering one
> > platform device per channel.
> 
> I both agree with you and disagree because of the current state of timers in
> the linux kernel. I would have liked a single platform device with all
> channles if this would be a generic timer driver that from user space could
> be configured to associate channels with various subsystems like PWM,
> clocksource, clockevent.
> 
> At this point the driver is doing clockevent and clocksource only, and no
> sane user wants 84 channels of equivalent hardware blocks for those two.

Of course, but we could always select which channels to register clockevents 
and clocksources for in platform data. That won't fix the overall problem, but 
it's one step forward.

> So based on that I'd rather do it like today and let people write custom
> drivers for whatever applications they may use the other channels for.
> 
> So if you're in hacking mode, why don't you figure out some way timers can
> be configured from user space? =)

I don't have *that* much free time at the moment I'm afraid, and I'm sure you 
know why :-)

> If so then we can use DT to describe the actual hardware and let the
> software policy be decided via some configuration mechanism.

Don't we also need timers during early boot, when userspace isn't available 
yet ?

-- 
Regards,

Laurent Pinchart

