Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab3GRN5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:57:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35800 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab3GRN5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:57:24 -0400
Date: Thu, 18 Jul 2013 14:56:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] clk: add MOXA ART SoCs clock driver
Message-ID: <20130718135650.GD29153@e106331-lin.cambridge.arm.com>
References: <1372943292-6960-1-git-send-email-jonas.jensen@gmail.com>
 <1374067396-30155-1-git-send-email-jonas.jensen@gmail.com>
 <20130718095035.GA29153@e106331-lin.cambridge.arm.com>
 <CACmBeS2SnpiUtiQD6j9qyaXZ5-chHSHVeo4c5=UhitVonvkKtw@mail.gmail.com>
 <20130718110201.GB29153@e106331-lin.cambridge.arm.com>
 <CACmBeS24smrJ4SLY7snv1_6SRcuXRkZ8t0PGMvBupUpKMMb43w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACmBeS24smrJ4SLY7snv1_6SRcuXRkZ8t0PGMvBupUpKMMb43w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:55:26PM +0100, Jonas Jensen wrote:
> On 18 July 2013 13:02, Mark Rutland <mark.rutland@arm.com> wrote:
> > Ok. I'm just concerned that the linkage isn't explicit or obvious.
> 
> > This does leave apb-clock completely dependent on core-clock, and unless
> > I've missed something there's no linkage between the two described in
> > the dt.
> 
> I can add a description in the core-clock binding and also for
> apb-clock pointing
> out that it's set from core-clock.
> 
> > How does core-clock physically relate to apb-clock? Does it feed or is
> > it fed by apb-clock?
> 
> apb-clock is entirely a DT construct used by drivers to get the fixed
> rate 48MHz.
> It's not fed by core-clock more than what happens in probe.
> 
> For UC-7112-LX, drivers using apb-clock are: clocksource, MMC, watchdog
> 
> Because clocksource relies on apb-clock, a successful probe of
> core-clock is critical.
> 
> Commonly, drivers look up the apb-clock node and call clk_get_rate.

When you say look up the apb-clock node, I assume they find it via their
clocks property with of_clk_get or similar, rather than scanning the
tree for a "moxart,moxa-apb-clock" node specifically?

> 
> > Are we always guaranteed to have core-clock if we have apb-clock, and is
> > it part of the same block in hardware? If so we could describe the
> > amalgamation as a provider with two clock outputs, with core-clock's
> > registers for configuration at probe-time.
> 
> Yes, as described above, there can not be a apb-clock without core-clock.
> 
> 
> I think drivers could find and use core-clock instead. Maybe the abstraction
> of apb-clock is unnecessary?

Given the above, I think it would make more sense to have core-clock
registered, and have it passed to the devices currently passed
apb-clock.

Thanks,
Mark.

> 
> 
> Best regards,
> Jonas
> 
