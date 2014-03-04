Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaCDOSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:18:44 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50898 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbaCDOSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:18:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX190N479DbmyaTC++YuCXSbSq+iDdozLZsc=
X-DKIM: OpenDKIM Filter v2.0.1 titan A9641539972
Date: Tue, 4 Mar 2014 09:18:23 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
Message-ID: <20140304141823.GM1872@titan.lakedaemon.net>
References: <1392667236-19126-1-git-send-email-jason@lakedaemon.net>
 <20140303150215.GI21483@n2100.arm.linux.org.uk>
 <20140303173740.GC16655@lunn.ch>
 <20140303181529.GM21483@n2100.arm.linux.org.uk>
 <20140303222406.GW1872@titan.lakedaemon.net>
 <20140304092616.GH16655@lunn.ch>
 <5315AD6F.1070804@gmail.com>
 <20140304121136.GR21483@n2100.arm.linux.org.uk>
 <20140304135306.GL1872@titan.lakedaemon.net>
 <5315DCF1.90608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5315DCF1.90608@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 03:02:25PM +0100, Sebastian Hesselbarth wrote:
> On 03/04/2014 02:53 PM, Jason Cooper wrote:
> >On Tue, Mar 04, 2014 at 12:11:36PM +0000, Russell King - ARM Linux wrote:
> >>On Tue, Mar 04, 2014 at 11:39:43AM +0100, Sebastian Hesselbarth wrote:
> >>>On 03/04/2014 10:26 AM, Andrew Lunn wrote:
> >>>>>I could have sworn this was discussed with this particular patchset, but
> >>>>>I'm unable to find the conversation in my archives.  Neither during the
> >>>>>patch submission process, nor the (long) pull request thread.
> >>>>>
> >>>>>Perhaps it was an irc conversation?  Andrew, Sebastian, can you find a
> >>>>>link?  iirc, one of the DT maintainers (Mark Rutland?) raised the same
> >>>>>concern and I thought we answered that sufficiently...
> >>>>
> >>>>It was the cpufreq driver which caused the discussion. I looked at it
> >>>>for a while, and then task swapped onto the kirkwood move into
> >>>>mach-mvebu.
> >>>
> >>>I guess you are looking for this discussion
> >>>
> >>>http://comments.gmane.org/gmane.linux.power-management.general/41053
> >>>
> >>>and specifically Mark's remarks on PMU and DT in here
> >>>
> >>>http://permalink.gmane.org/gmane.linux.ports.arm.kernel/285384
> >>>
> >>>BTW, +1 for a single PMU node that either serves an mfd (or type
> >>>of) driver or that subsystem drivers derive their resources from.
> >>>Looking at Dove FS, that would also include clock gating, which
> >>>could be a mess to sort out.. anyway, let's get it on.
> >>
> >>So we have cpufreq, pm domains and an irq controller.  What's the plan
> >>for this, who's going to look at sorting this out?
> >
> >Andrew, Sebastian?  I'm currently task-saturated...
> 
> Phew, looks like I'll have to take it?
> 
> Are you guys ok with having a single PMU node with syscon provided
> regmap and make all drivers depend on it? I'd like to get a go from
> Russell here, as he has clearly something in mind.
> 
> We can consolidate drivers later if required. If we start that now,
> we definitely risk running out of time for v3.15.

Honestly, mvebu has enough going on atm.  I would target v3.16 and take
our time.  At least with the binding.  If the driver comes together
easily, we could always do like we did for mbus.  Do a legacy init from
the board (soc) file, then switch to the dt binding once everyone is
happy with it.

v3.14-rc6 is less than a week away, so I'll be sending final mvebu pull
requests late Wednesday/Thursday...

v3.14-rcX has been awful quiet, there might not be an -rc7.

thx,

Jason.
