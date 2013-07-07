Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3GGX6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 19:58:50 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15936 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753254Ab3GGX6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 19:58:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ADI++gADUBN/OYaAxvg+4ac5LiLBqn/k=
Date: Sun, 7 Jul 2013 19:58:19 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [GIT PULL] clockevents/clocksource: Add Marvell Orion SoC timer
Message-ID: <20130707235819.GB11908@titan.lakedaemon.net>
References: <51B8D310.4050404@linaro.org>
 <51D9548B.9040907@gmail.com>
 <alpine.DEB.2.02.1307071508030.32106@ionos.tec.linutronix.de>
 <20130707144645.GA11908@titan.lakedaemon.net>
 <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307071723220.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 05:30:31PM +0200, Thomas Gleixner wrote:
> On Sun, 7 Jul 2013, Jason Cooper wrote:
> > Sure, but to be clear, Daniel, please drop this patch from your tree.  I
> > have no desire to create an out-of-tree dependency if we can avoid it.
> > It has a habit of going horribly wrong [1].
> > 
> > I'll cherry-pick
> > 
> >   0c1dcfd clocksource: Add Marvell Orion SoC timer
> 
> Don't do that. Do a git fetch on that branch and then git merge
> 0c1dcfd.

> The patches before that Marvel commit are already in Linus tree. That
> way it does not matter who sends first or not.

ahh, ok.  I see your point now, thanks.

Daniel, do you mind tagging that commit, eg 'mvebu-deps-3.12' or
similar?

> Also for the next merge window: Can we please let everything under
> drivers/clocksoure go through Daniels and my trees?

Of course, that's what I've been encouraging:

http://permalink.gmane.org/gmane.linux.ports.arm.kernel/242342

""" Using Thomas Petazzoni's quoting style here :)

Is there a reason why the following breakdown wouldn't work?

>  arch/arm/boot/dts/armada-370-xp.dtsi     |   1 +
>  arch/arm/boot/dts/armada-370.dtsi        |   1 +
>  arch/arm/boot/dts/armada-xp-mv78230.dtsi |   1 +
>  arch/arm/boot/dts/armada-xp-mv78260.dtsi |   1 +
>  arch/arm/boot/dts/armada-xp-mv78460.dtsi |   1 +

through mvebu/arm-soc

>  arch/arm/mach-mvebu/Kconfig              |   1 +

through mvebu/arm-soc after the other three have landed (v3.11-rc1)

>  drivers/irqchip/irq-armada-370-xp.c      | 186 ++++++++++++++++++++++++++++++-

through tglx

>  drivers/pci/host/pci-mvebu.c             |  21 ++++
>  drivers/pci/msi.c                        |  59 +++++++++-
>  drivers/pci/probe.c                      |   1 +
>  include/linux/msi.h                      |  22 ++++
>  include/linux/pci.h                      |   1 +

through Bjorn

I think we should view the manner in which we brought in the initial
mvebu-pcie series (all through arm-soc) as the exception, not the rule.
I have no problem, and in fact, prefer to have them reviewed as a
series, but if at *all* possible, the series should be structured so
relevant maintainers can pick up the relevant patches into their trees.

""" End quote

There's a delicate three-way balance between pushing patches that we
depend on to the appropriate maintainers, avoiding out-of-tree
dependencies for arm-soc, and keeping the ball moving.

I don't mind delaying half of a series so the drivers/ portion can land
in mainline, and the rest can land in the next cycle.  But when things
don't go according to that plan, I'd like a little consideration /
flexibility about solving the problem.  Especially considering I'm
*trying* to do the right thing by pushing to appropriate maintainers
first.

Of course, this is a moot point since, as you clarified above, this
dependency doesn't have the hazards typically associated with
out-of-tree dependencies.

thx,

Jason.
