Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaIDJpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:45:55 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42814 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750990AbaIDJpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:45:53 -0400
Date: Thu, 4 Sep 2014 10:45:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v10 03/19] arm: fiq: Replace default FIQ handler
Message-ID: <20140904094521.GB30401@n2100.arm.linux.org.uk>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org> <20140819173742.GG30401@n2100.arm.linux.org.uk> <53F39377.1070308@linaro.org> <20140828150112.GD30401@n2100.arm.linux.org.uk> <5405AEBC.9020904@linaro.org> <20140902164204.GT30401@n2100.arm.linux.org.uk> <5406EBAA.9040206@linaro.org> <20140903193453.GA30401@n2100.arm.linux.org.uk> <54082C40.2000107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54082C40.2000107@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:09:20AM +0100, Daniel Thompson wrote:
> On 03/09/14 20:34, Russell King - ARM Linux wrote:
> > I would say that the ARM specific changes to entry-armv.S and setup.c
> > are correct.  All that you're doing there is to replace the existing
> > default no-op FIQ handler with some additional code which gets us into
> > SVC mode and back out, but itself is also a no-op.  In other words, no
> > real change.
> > 
> > That's a good first patch, and one which I would actually like to have
> > in my tree sooner rather than later, so that I can split that out from
> > my prototype code.
> 
> So would I!
> 
> I did some rebasing yesterday to put anything to do with kgdb right at
> the back of the queue. This "good first patch" is now actually the first
> patch; where the nofifier used to be it currently calls do_unexp_fiq()
> making it very close to "no real change".
> 
> BTW do_unexp_fiq() calls printk() but

You're making the assumption that something called do_unexp_fiq() before
your patches.  It seems that that function is dead code, and now that
you've pointed that out, I will kill this function.

The current situation is that if the CPU receives a FIQ, it enters the
FIQ vector, which contains an immediate return instruction.

> If you want me to work with something more recent then feel free to
> point me at it...

I'll post some of that stuff later today, probably this evening.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
