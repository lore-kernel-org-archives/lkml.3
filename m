Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaHOKBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 06:01:45 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55288 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750817AbaHOKBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 06:01:43 -0400
Date: Fri, 15 Aug 2014 11:01:13 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Olof Johansson <olof@lixom.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20140815100113.GA18863@arm.com>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
 <CAOesGMjs1dM37ZoFA-xs7tYYaXP-XC3NjJsj291bCNoDwAXwiw@mail.gmail.com>
 <20140812182347.GA4100@arm.com>
 <2152407.NpXOMHAEH6@vostro.rjw.lan>
 <53EC2B35.5010302@linaro.org>
 <20140814102723.GB9039@arm.com>
 <53EDCE56.6020702@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EDCE56.6020702@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hanjun,

On Fri, Aug 15, 2014 at 10:09:42AM +0100, Hanjun Guo wrote:
> On 2014-8-14 18:27, Catalin Marinas wrote:
> > On Thu, Aug 14, 2014 at 04:21:25AM +0100, Hanjun Guo wrote:
> >> On 2014-8-14 7:41, Rafael J. Wysocki wrote:
> >>> On Tuesday, August 12, 2014 07:23:47 PM Catalin Marinas wrote:
> >>>> If we consider ACPI unusable on ARM but we still want to start merging
> >>>> patches, we should rather make the config option depend on BROKEN
> >>>> (though if it is that unusable that no real platform can use it, I would
> >>>> rather not merge it at all at this stage).
> >>>
> >>> I agree here.
> >>>
> >>> I would recommend creating a separate branch for that living outside of the
> >>> mainline kernel and merging it when there are real users.
> >>
> >> Real users will coming soon, we already tested this patch set on real hardware
> >> (ARM64 Juno platform),
> > 
> > I don't consider Juno a server platform ;) (but it's good enough for
> > development).
> > 
> >> and I think ARM64 server chips and platforms will show up before 3.18
> >> is released.
> > 
> > That's what I've heard/seen. The questions I have are (a) whether
> > current ACPI patchset is enough to successfully run Linux on such
> > _hardware_ platform (maybe not fully optimised, for example just WFI
> > cpuidle) and (b) whether we still want to mandate a DT in the kernel for
> > such platforms.
> 
> For (a), this patch set is only for ARM64 core, not including platform
> specific device drivers, it will be covered by the binding of _DSD or
> explicit definition of PNP ID/ACPI ID(s).

So we go back to the discussions we had few months ago in Macau. I'm not
concerned about the core ARM and architected peripherals covered by ACPI
5.1 (as long as the current patches get positive technical review). But
I'm concerned about the additional bits needed for a real SoC like _DSD
definitions, how they get reviewed/accepted (or is it just the vendor's
problem?).

I think SBSA is too vague to guarantee a kernel image running on a
compliant platform without additional (vendor-specific) tweaks. So what
I asked for is (1) a document (guide) to define the strict set of ACPI
features and bindings needed for a real SoC and (2) proof that the
guidelines are enough for real hardware. I think we have (1) under
review with some good feedback so far. As for (2), we can probably only
discuss Juno openly. I think you could share the additional Juno patches
on this list so that reviewers can assess the suitability. If we deem
ACPI not (yet) suitable for Juno, is there other platform we could see
patches for?

> > Given the answer to (a) and what other features are needed, we may or
> > may not mandate (b). We were pretty clear few months ago that (b) is
> > still required but at the time we were only openly talking about ACPI
> > 5.0 which was lacking many features. I think we need to revisit that
> > position based on how usable ACPI 5.1 for ARM (and current kernel
> > implementation) is. Would you mind elaborating what an ACPI-only
> > platform miss?
> 
> Do you mean something still missing? We still miss some features for
> ARM in ACPI, but I think they are not critical, here is the list I can
> remember:
> - ITS for GICv3/4;
> - SMMU support;
> - CPU idle control.

I agree, these are not critical at this stage. But they only refer to
architected peripherals. Is there anything else missing for an SoC? Do
we need to define clocks?

> For ACPI 5.1, it fixes many problems for ARM:
> - weak definition for GIC, so we introduce visualization, v2m and
>   part of GICv3/4 (redistributors) support.
> - No support for PSCI. Fix it to support PSCI 0.2+;
> - Not support for Always-on timer and SBSA-L1 watchdog.

These are all good, that's why we shouldn't even talk about ACPI 5.0 in
the ARM context.

> - How to describe device properties, so _DSD is introduced for
>   device probe.

For the last bullet, is there any review process (at least like what we
have for DT bindings)? On top of such process, do we have guidelines and
example code on how the Linux support should be implemented. As Olof
mentioned, should we see how the DT and ACPI probing paths work
together? I really think we should be very clear here and not let
vendors invent their own independent methods.

> > I would expect a new server platform designed with ACPI in mind to
> > require minimal SoC specific code, so we may only see a few patches
> > under drivers/ for such platforms adding ACPI-specific probing (possibly
> > new drivers as well if it's a new component).
> > 
> >> For this patch set, DT is the first class citizen at now:
> >>
> >> a) We can always set CONFIG_ACPI as off in Kconfig, and use DT only;
> > 
> > Not just off but, based on maturity, depend on EXPERT.
> 
> Ok. And don't set ACPI default off (pass acpi=on to enable it)?

That's my view, just make it clear ACPI is experimental at the Kconfig
level because longer term we won't mandate SoCs to provide both DT and
ACPI tables.

> >> b) Even if we set CONFIG_ACPI=Y, we also can use DT as normal:
> >>
> >>   - Pass DT blob without (valid) ACPI tables (just as we boot the kernel now),
> >>     ACPI will disabled in the very early stage and FDT will still to be
> >>     unflattened, so will not break DT booting.
> >>
> >>   - We can pass ACPI=off to disable ACPI and use DT even if we got valid
> >>     ACPI tables (in the v1 patch set);
> >>
> >> So it is safe for people who want to use DT, and didn't change any behavior
> >> of DT booting except some extra test of if(acpi_disabled).
> > 
> > But should we require SoC firmware to provide both valid DT and ACPI
> > tables so that the user can decide which one to select at boot-time?
> 
> No, I think only one of them should be provided on real platforms.

That's what I thought. And such platforms would end up always passing
acpi=on anyway.

-- 
Catalin
