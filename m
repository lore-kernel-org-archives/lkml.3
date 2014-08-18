Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHRMuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:50:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46758 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbaHRMuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:50:00 -0400
Date: Mon, 18 Aug 2014 13:49:52 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
Message-ID: <20140818124952.GI14559@leverpostej>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
 <CAOesGMjs1dM37ZoFA-xs7tYYaXP-XC3NjJsj291bCNoDwAXwiw@mail.gmail.com>
 <20140812182347.GA4100@arm.com>
 <2152407.NpXOMHAEH6@vostro.rjw.lan>
 <53EC2B35.5010302@linaro.org>
 <20140814102723.GB9039@arm.com>
 <53EDCE56.6020702@linaro.org>
 <20140815100113.GA18863@arm.com>
 <53F1C776.4080501@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F1C776.4080501@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:29:26AM +0100, Hanjun Guo wrote:
> On 2014-8-15 18:01, Catalin Marinas wrote:
> > Hanjun,
> 
> Hi Catalin,
> 
> > 
> > On Fri, Aug 15, 2014 at 10:09:42AM +0100, Hanjun Guo wrote:
> >> On 2014-8-14 18:27, Catalin Marinas wrote:
> >>> On Thu, Aug 14, 2014 at 04:21:25AM +0100, Hanjun Guo wrote:
> >>>> On 2014-8-14 7:41, Rafael J. Wysocki wrote:
> >>>>> On Tuesday, August 12, 2014 07:23:47 PM Catalin Marinas wrote:
> >>>>>> If we consider ACPI unusable on ARM but we still want to start merging
> >>>>>> patches, we should rather make the config option depend on BROKEN
> >>>>>> (though if it is that unusable that no real platform can use it, I would
> >>>>>> rather not merge it at all at this stage).
> >>>>>
> >>>>> I agree here.
> >>>>>
> >>>>> I would recommend creating a separate branch for that living outside of the
> >>>>> mainline kernel and merging it when there are real users.
> >>>>
> >>>> Real users will coming soon, we already tested this patch set on real hardware
> >>>> (ARM64 Juno platform),
> >>>
> >>> I don't consider Juno a server platform ;) (but it's good enough for
> >>> development).
> >>>
> >>>> and I think ARM64 server chips and platforms will show up before 3.18
> >>>> is released.
> >>>
> >>> That's what I've heard/seen. The questions I have are (a) whether
> >>> current ACPI patchset is enough to successfully run Linux on such
> >>> _hardware_ platform (maybe not fully optimised, for example just WFI
> >>> cpuidle) and (b) whether we still want to mandate a DT in the kernel for
> >>> such platforms.
> >>
> >> For (a), this patch set is only for ARM64 core, not including platform
> >> specific device drivers, it will be covered by the binding of _DSD or
> >> explicit definition of PNP ID/ACPI ID(s).
> > 
> > So we go back to the discussions we had few months ago in Macau. I'm not
> > concerned about the core ARM and architected peripherals covered by ACPI
> > 5.1 (as long as the current patches get positive technical review). But
> > I'm concerned about the additional bits needed for a real SoC like _DSD
> > definitions, how they get reviewed/accepted (or is it just the vendor's
> > problem?).
> 
> As the _DSD patch set sent out by Intel folks, _DSD definitions are just
> DT definitions. To use _DSD or not, I think it depends on OEM use cases,
> we can bring up Juno without _DSD (Graeme is working on that, still need
> some time to clean up the code).

Let's not confuse matters by saying that _DSD is DT. DSD allows for
key-value pairs, and has a reference mechanism roughly equivalent to
phandles. That does not make them the same thing.

Not having any guidelines for vendors is an extremely bad idea. The DT
bindings we get a chance to review often have major issues. I do not
believe that vendors will do things sanely without good guidance and
strong incentives.

[...]

> >> For ACPI 5.1, it fixes many problems for ARM:
> >> - weak definition for GIC, so we introduce visualization, v2m and
> >>   part of GICv3/4 (redistributors) support.
> >> - No support for PSCI. Fix it to support PSCI 0.2+;
> >> - Not support for Always-on timer and SBSA-L1 watchdog.
> > 
> > These are all good, that's why we shouldn't even talk about ACPI 5.0 in
> > the ARM context.
> > 
> >> - How to describe device properties, so _DSD is introduced for
> >>   device probe.
> > 
> > For the last bullet, is there any review process (at least like what we
> > have for DT bindings)? On top of such process, do we have guidelines and
> > example code on how the Linux support should be implemented. As Olof
> > mentioned, should we see how the DT and ACPI probing paths work
> > together? I really think we should be very clear here and not let
> > vendors invent their own independent methods.
> 
> As said above, Intel folks provided some good examples for that, and
> clarified a lot of things:
> 
> https://lkml.org/lkml/2014/8/17/10

Quite frankly, the examples provided in the _DSD series are atrocious.
They constitute a trivial mapping of some existing DT bindings to ACPI
which do not appear to have gone through any sort of review w.r.t.
remaining idiomatic.

Thanks,
Mark.
