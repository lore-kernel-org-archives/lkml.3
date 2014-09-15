Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaIOEh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:37:28 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60948 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaIOEhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:37:25 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
To: Olof Johansson <olof@lixom.net>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
In-Reply-To: <CAOesGMhQXSTb_c_fDcVGubkUkoPVvikm3k7W8sOCZJNwqmqBUg@mail.gmail.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
	<20140911132935.068DCC408F6@trevor.secretlab.ca>
	<CAOesGMhQXSTb_c_fDcVGubkUkoPVvikm3k7W8sOCZJNwqmqBUg@mail.gmail.com>
Date: Sun, 14 Sep 2014 21:37:23 -0700
Message-Id: <20140915043723.30303C407E8@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 09:05:25 -0700, Olof Johansson <olof@lixom.net> wrote:
> On Thu, Sep 11, 2014 at 6:29 AM, Grant Likely <grant.likely@linaro.org> wrote:
> > On Mon,  1 Sep 2014 22:57:38 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> >> ACPI 5.1 has been released and now be freely available for
> >> download [1]. It fixed some major gaps to run ACPI on ARM,
> >> this patch just follow the ACPI 5.1 spec and prepare the
> >> code to run ACPI on ARM64.
> >>
> >> ACPI 5.1 has some major changes for the following tables and
> >> method which are essential for ARM platforms:
> >> 1) MADT table updates.
> >> 2) FADT updates for PSCI
> >> 3) GTDT
> >>
> >> This patch set is the ARM64 ACPI core patches covered MADT, FADT
> >> and GTDT, platform board specific drivers are not covered by this
> >> patch set, but we provide drivers for Juno to boot with ACPI only
> >> in the follwing patch set for review purpose.
> >>
> >> We first introduce acpi.c and its related head file which are needed
> >> by ACPI core, and then get RSDP to extract all the ACPI boot-time tables.
> >> When all the boot-time tables (FADT, MADT, GTDT) are ready, then
> >> parse them to init the sytem when booted. Specifically,
> >> a) we use FADT to init PSCI and use PSCI to boot SMP;
> >> b) Use MADT for GIC init and SMP init;
> >> c) GTDT for arch timer init.
> >>
> >> This patch set is based on 3.17-rc2 and was tested by Graeme on Juno
> >> and FVP base model boot with ACPI only OK, if you want to test them,
> >> you can pull from acpi-5.1-v3 branch in leg/acpi repo:
> >> git://git.linaro.org/leg/acpi/acpi.git
> >>
> >> Updates since v2:
> >>  - Refactor the code to make SMP/PSCI init with less sperated init
> >>    path by Tomasz
> >>  - make ACPI depend on EXPERT
> >>  - Address lots of comments from Catalin, Sudeep, Geoff
> >>  - Add Juno device ACPI driver patches for review
> >>
> >> Updates since v1:
> >>  - Set ACPI default off on ARM64 suggested by Olof;
> >>  - Rebase the patch set on top of linux-next branch/linux-pm tree which
> >>    includes the ACPICA for full ACPI 5.1 support.
> >>  - Update the document as suggested;
> >>  - Adress lots of comments from Mark, Sudeep, Randy, Naresh, Olof, Geoff
> >>    and more...
> >>
> >> [1]: http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
> >
> > I've read through this entire series now. In my mind, aside from a few
> > comments that I know you're addressing, this is ready.  The hooks into
> > arm64 core code are not terribly invasive, it is nicely organized and
> > manageable. Get the next version out ASAP, but I would also like to see
> > the diffs from this version to the next so I don't need to review the
> > entire series again.
> 
> I'm going to take a pass on the next version of the series that will
> get posted; I've been a bit too busy to pay close attention to the
> series the last few weeks and I might as well wait until the next
> version at this rate.

I've asked Hanjun to prepare diffs from one version of the series to the
next so that I don't need to rereview the entire thing. He sent them to
me privately. Do you want me to pass them along to you?

> 
> > Regarding the requests to refactor ACPICA to work better for ARM. I
> > completely agree that it should be done, but I do not think it should be
> > a prerequisite to getting this core support merged. That kind of
> > refactoring is far easier to justify when it has immediate improvement
> > on the mainline codebase, and it gives us a working baseline to test
> > against. Doing it the other way around just makes things harder.
> >
> > I would really like to see the next version of this series go into
> > linux-next. I think this is ready for some wider exposure. Have you got
> > a branch being pulled into Fengguang's autobuilder yet?
> 
> That's not how -next works. We only add code to -next that is targeted
> to the upcoming release, we certainly don't add it to get "wider
> exposure". If the code is ready then it can go in, but that's not the
> case at this time.

Sorry, I had a bad moment there. Apologies. Getting it into Fengguang's
builder is appropriate though.

> For "wider exposure" -- who do you have in mind? Everybody that's
> currently got hardware relevant for this already needs out-of-tree
> patches, so getting it into -next doesn't add any exposure. Doesn't
> Linaro do kernel builds and publish trees for this reason already?

There is the wider exposure of ensuring the ACPI patches don't interfere
with non-ACPI users, and also making sure it builds with configuration
combinations that we've not tried.

g.
