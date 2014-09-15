Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaIOEVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:21:42 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40963 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaIOEVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:21:40 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
To: Will Deacon <will.deacon@arm.com>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
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
In-Reply-To: <20140911134922.GG6158@arm.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
	<20140911132935.068DCC408F6@trevor.secretlab.ca>
	<20140911134922.GG6158@arm.com>
Date: Sun, 14 Sep 2014 21:21:37 -0700
Message-Id: <20140915042137.A7249C41296@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 14:49:22 +0100, Will Deacon <will.deacon@arm.com> wrote:
> Hi Grant,
> 
> On Thu, Sep 11, 2014 at 02:29:34PM +0100, Grant Likely wrote:
> > On Mon,  1 Sep 2014 22:57:38 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > > ACPI 5.1 has been released and now be freely available for
> > > download [1]. It fixed some major gaps to run ACPI on ARM,
> > > this patch just follow the ACPI 5.1 spec and prepare the
> > > code to run ACPI on ARM64.
> > > 
> > > ACPI 5.1 has some major changes for the following tables and
> > > method which are essential for ARM platforms:
> > > 1) MADT table updates.
> > > 2) FADT updates for PSCI
> > > 3) GTDT
> > > 
> > > This patch set is the ARM64 ACPI core patches covered MADT, FADT
> > > and GTDT, platform board specific drivers are not covered by this
> > > patch set, but we provide drivers for Juno to boot with ACPI only
> > > in the follwing patch set for review purpose.
> 
> [...]
> 
> > I've read through this entire series now. In my mind, aside from a few
> > comments that I know you're addressing, this is ready.  The hooks into
> > arm64 core code are not terribly invasive, it is nicely organized and
> > manageable. Get the next version out ASAP, but I would also like to see
> > the diffs from this version to the next so I don't need to review the
> > entire series again.
> > 
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
> Apart from build testing, what does this wider exposure achieve?

It tests that ACPI support does not break existing platform support and
it builds in configurations that we simply haven't tested yet. The LEG
wiki has instructions for running the code on Fvp and Juno. It gets us
confidence that the patches aren't dangerous and that they work outside
of the ACPI developers environment.

Hanjun, what is the state of firmware binaries? I know we're building
them for releases and snapshots, but I don't know if they contain the
required ACPI bits.

> Is there a
> platform available that would be able to boot Linux (to a meaingful state)
> with this patch series alone?

(Hanjun/Graeme, correct me if I'm wrong here) There are two driver
patches that makes Juno and the FVP model usable. One for Ethernet
and one for the UART, but the UART one is going to be dropped in favour
of ARM's SBSA UART patch. It also works on AMD Seatlle with driver patches,
but those ones haven't been published yet.

g.

> I'm mindful of merging arch code that I'm unable to test, so I'd really
> rather it was merged along with the code (and a devicetree) for a platform
> that can use it.
> 
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

