Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaIZNWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:22:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46279 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285AbaIZNWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:22:37 -0400
Date: Fri, 26 Sep 2014 14:20:38 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Chenhui Zhao <chenhui.zhao@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhuoyu.Zhang@freescale.com" <Zhuoyu.Zhang@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "leoli@freescale.com" <leoli@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] arm: ls1: add CPU hotplug platform support
Message-ID: <20140926132038.GF7422@leverpostej>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com>
 <1411730703-25836-2-git-send-email-chenhui.zhao@freescale.com>
 <20140926122003.GP5182@n2100.arm.linux.org.uk>
 <20140926124614.GD7422@leverpostej>
 <20140926130311.GQ5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926130311.GQ5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This looks to be a carbon copy of the vexpress pseudo-hotplug in
> > arch/arm/mach-vexpress/hotplug.c, which is obviously broken in the way
> > you describe above. Perhaps we should go about ripping that out?
> 
> The Versatile Express does not support suspend so the only problem case
> is kexec.  However, isn't this support needed for big.LITTLE, and as
> the Versatile Express is the platform which these features get developed
> on, having working CPU hotplug seems rather fundamental for ARM kernel
> feature development.
> 
> In that regard, Versatile Express is something of a special case.

It is admittedly helpful during development to perform pseudo-hotplug on
Versatile Express. I have a local patch adding vexpress_cpu_disable so I
can test for bugs that only trigger if CPU0 is hotplugged.

Given that, perhaps we should make it clearer that Versatile Express is
not a reference implementation for CPU hotplug; add some Kconfig (e.g.
VEXPRESS_PSEUDO_HOTPLUG) that depends on !KEXEC && !SUSPEND, and putting
a note in hotplug.c stating it's not suitable as a reference
implementation.

...but perhaps that's overkill.

Mark.
