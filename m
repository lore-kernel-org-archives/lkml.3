Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaK1Oge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:36:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36897 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbaK1Ogb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:36:31 -0500
Date: Fri, 28 Nov 2014 14:35:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "broonie@linaro.org" <broonie@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "corbet@lwn.net" <corbet@lwn.net>, "jslaby@suse.cz" <jslaby@suse.cz>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Message-ID: <20141128143532.GI25883@leverpostej>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
 <20141127134309.GJ857@leverpostej>
 <20141128142913.GB5393@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128142913.GB5393@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 02:29:13PM +0000, Catalin Marinas wrote:
> On Thu, Nov 27, 2014 at 01:43:09PM +0000, Mark Rutland wrote:
> > On Thu, Nov 27, 2014 at 12:12:15PM +0000, Catalin Marinas wrote:
> > > On Thu, Nov 27, 2014 at 11:50:43AM +0000, Mark Rutland wrote:
> > > > On Tue, Nov 25, 2014 at 12:16:56PM +0000, Chunyan Zhang wrote:
> > > > > +
> > > > > +       timer {
> > > > > +               compatible = "arm,armv8-timer";
> > > > > +               interrupts = <1 13 0xff01>,
> > > > > +                            <1 14 0xff01>,
> > > > > +                            <1 11 0xff01>,
> > > > > +                            <1 10 0xff01>;
> > > > > +               clock-frequency = <26000000>;
> > > > 
> > > > Please remove the clock-frequency property. Your FW should initialise
> > > > CNTFRQ_EL0 on all CPUs (certainly PSCI 0.2 requires that you do this).
> > > 
> > > Since this comes up regularly, I think we need a dev_warn() in the arch
> > > timer driver when CONFIG_ARM64.
> > 
> > I'll ack such a patch ;)
> 
> How rude would this be?
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 2133f9d59d06..aaaf3433ccb9 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -371,7 +371,8 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
> 		return;
>  
> 	/* Try to determine the frequency from the device tree or CNTFRQ */
> -	if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
> +	if (IS_ENABLED(CONFIG_ARM64) ||
> +	    of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
> 		if (cntbase)
> 			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
> 		else
>

Probably too rude, given it doesn't WARN() the user.

We should be extremely loud if we see the clock-frequency property on an
arm64 system. Whether or not we should ignore the property is another
matter.

Mark.
