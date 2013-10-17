Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab3JQOdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:33:06 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50464 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756187Ab3JQOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:33:03 -0400
Date: Thu, 17 Oct 2013 15:32:04 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 3/4] ARM: EXYNOS: add Exynos Dual Cluster Support
Message-ID: <20131017143204.GE2442@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 12:45:29PM +0200, Daniel Lezcano wrote:
> On 10/14/2013 05:08 PM, Vyacheslav Tyrtov wrote:
> > From: Tarek Dakhran <t.dakhran@samsung.com>
> > 
> > Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
> > This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.

[...]

> > +	__mcpm_cpu_down(cpu, cluster);
> > +
> > +	if (!skip_wfi) {
> > +		exynos_core_power_down(cpu, cluster);
> > +		wfi();
> > +	}
> > +}
> 
> I did not looked line by line but these functions looks very similar
> than the tc2_pm.c's function. no ?

This is true.

> May be some code consolidation could be considered here.
> 
> Added Nico and Lorenzo in Cc.
> 
> Thanks
>   -- Daniel

Nico can commnent further, but I think the main concern here was that
this code shouldn't be factored prematurely.

There are many low-level platform specifics involved here, so it's
hard to be certain that all platforms could fit into a more abstracted
framework until we have some evidence to look at.

This could be revisited when we have a few diverse MCPM ports to
compare.


The low-level A15/A7 cacheflush sequence is already being factored
by Nico [1].

Cheers
---Dave

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/205085.html
[PATCH] ARM: cacheflush: consolidate single-CPU ARMv7 cache disabling code

[...]
