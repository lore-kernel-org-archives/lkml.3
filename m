Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaI1O1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 10:27:41 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45665 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754154AbaI1O1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 10:27:40 -0400
Date: Sun, 28 Sep 2014 15:27:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Li Yang <leoli@freescale.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Chenhui Zhao <chenhui.zhao@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhuoyu.Zhang@freescale.com" <Zhuoyu.Zhang@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm: ls1: add CPU hotplug platform support
Message-ID: <20140928142726.GH5182@n2100.arm.linux.org.uk>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com> <1411730703-25836-2-git-send-email-chenhui.zhao@freescale.com> <20140926122003.GP5182@n2100.arm.linux.org.uk> <20140926124614.GD7422@leverpostej> <20140926130311.GQ5182@n2100.arm.linux.org.uk> <20140926132038.GF7422@leverpostej> <CADRPPNQULzPhHt3Kk1EUnPRkfFOPGsWY4AqWEv=AdBc5y-Gg+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADRPPNQULzPhHt3Kk1EUnPRkfFOPGsWY4AqWEv=AdBc5y-Gg+Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 06:57:18PM +0800, Li Yang wrote:
> On Fri, Sep 26, 2014 at 9:20 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > This looks to be a carbon copy of the vexpress pseudo-hotplug in
> >> > arch/arm/mach-vexpress/hotplug.c, which is obviously broken in the way
> >> > you describe above. Perhaps we should go about ripping that out?
> >>
> >> The Versatile Express does not support suspend so the only problem case
> >> is kexec.  However, isn't this support needed for big.LITTLE, and as
> >> the Versatile Express is the platform which these features get developed
> >> on, having working CPU hotplug seems rather fundamental for ARM kernel
> >> feature development.
> >>
> >> In that regard, Versatile Express is something of a special case.
> >
> > It is admittedly helpful during development to perform pseudo-hotplug on
> > Versatile Express. I have a local patch adding vexpress_cpu_disable so I
> > can test for bugs that only trigger if CPU0 is hotplugged.
> >
> > Given that, perhaps we should make it clearer that Versatile Express is
> > not a reference implementation for CPU hotplug; add some Kconfig (e.g.
> > VEXPRESS_PSEUDO_HOTPLUG) that depends on !KEXEC && !SUSPEND, and putting
> > a note in hotplug.c stating it's not suitable as a reference
> > implementation.
> >
> > ...but perhaps that's overkill.
> 
> I agree that the pseudo-hotplug is breaking the kexec.  However, I
> don't think it breaks the system suspend case as tasks and interrupts
> have been moved out of the non-booting CPU.  The pseudo-hotplug would
> be even better than real hotplug as it introduces less latency.

Sorry, that's not an acceptable reason to use it.

NAK.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
