Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbaCCRix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:38:53 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:37987 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbaCCRio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:38:44 -0500
Date: Mon, 3 Mar 2014 18:37:40 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
Message-ID: <20140303173740.GC16655@lunn.ch>
References: <20140207180836.GE8533@titan.lakedaemon.net>
 <1392667236-19126-1-git-send-email-jason@lakedaemon.net>
 <20140303150215.GI21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303150215.GI21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:02:15PM +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 17, 2014 at 08:00:36PM +0000, Jason Cooper wrote:
> > The corresponding driver didn't make it into v3.14, so we need to remove
> > the node.  Dove systems fail to boot with the node present and no
> > driver.
> > 
> > This node will be re-added when the driver makes it to mainline.
> 
> I'm going to stick my oar in on this and ask what is a very fundamental
> question.
> 
> If we're adding the PMU interrupt controller as a separate "device"
> aren't we describing our implementation rather than the hardware?  It
> isn't a separate device as far as the description of it in the reference
> manuals.
> 
> Moreover, should the PMU interrupt controller be something which is
> handled by a separate chunk of code to a driver for the PMU as a whole,
> or are we storing up problems with resource clashes?  I can quite see
> a PMU driver coming along in the future offering a pair of generic
> power domains for the GPU and VPU, and such a driver would need to map
> all the PMU registers so it can access the power control, reset and
> isolator registers.

Hi Russell

I suspect you are right, we are storing up problems.

During the 4 months between submitting this driver and actually
getting it accepted, i've learned quite a bit. I tried to implement
cpufreq for Dove and ran into the problems you mention. The registers
in the PMU are interleaved so that you cannot cleanly separate out the
range needed for cpufreq. We probably need a PMU device, which exports
a register syscon and have the interrupt controller make use of it.

	Andrew
