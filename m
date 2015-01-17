Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbbAQLxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 06:53:10 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36803 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbAQLxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 06:53:07 -0500
Date: Sat, 17 Jan 2015 11:52:37 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Message-ID: <20150117115237.GA30886@e104818-lin.cambridge.arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <20150116162944.EE0E3C40BF1@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116162944.EE0E3C40BF1@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 04:29:44PM +0000, Grant Likely wrote:
> On Thu, 15 Jan 2015 18:23:47 +0000, Catalin Marinas <catalin.marinas@arm.com>  wrote:
> > On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
> > > On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > > > This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
> > >
> > > I'll get right to the point: Can we please have this series queued up
> > > for v3.20?
> >
> > Before you even ask for this, please look at the patches and realise
> > that there is a complete lack of Reviewed-by tags on the code (well,
> > apart from trivial Kconfig changes). In addition, the series touches on
> > other subsystems like clocksource, irqchip, acpi and I don't see any
> > acks from the corresponding maintainers. So even if I wanted to merge
> > the series, there is no way it can be done without additional
> > reviews/acks. On the document (last patch), I'd like to see a statement
> > from HP as they've been vocal in private but no public endorsement of
> > this doc.
> 
> I have to ask. We've got no idea what you are thinking in terms of merge
> timeline. The ToDo list is part of the question, certainly, but if I
> have to ask flat-out to get some progress, then I will. Up to this
> point, the primary objections have been coming from you and other ARM
> maintainers, not the ACPI maintainer, and not other subsystem
> maintainers, so of course I'm going to address my arguments to you and
> Will.

I'm not entirely sure the other maintainers looked at the patches at
all, mainly because they thought it's all too ARM specific. Pushing to
linux-next is a first step but I wouldn't do it without acks from the
corresponding maintainers.

> > > Instead, keeping these patches out means that hardware is getting
> > > developed and tested against Fedora, early access RHEL and Linaro
> > > kernels. It means that we're abdicating on any influence mainline has
> > > over how those platforms are developed. The longer these patches stay
> > > out of mainline, the greater the potential for delta between what is
> > > in the vendor kernels and what we accept into mainline.
> >
> > I'm not buying this argument. Putting pressure on maintainers to merge
> > something because Fedora or some other distro has merged them is not the
> > right approach. If such Linux vendors ignore arguments on the list just
> > for the sake of providing ACPI support, there is a high chance that they
> > will accept non-standard code any other time when the kernel community
> > disagrees.
> 
> It's not like I'm arguing for stuff that isn't ready to be merged. Even
> back last October there was broad agreement from all of us (Will, Olof,
> Marc Z. Mark R., myself) that these patches are correct and that the
> remaining objections are related to larger questions of ecosystem. My
> argument is that for all the outstanding issues, we've either got a
> solution, or a process for working it out with hardware vendors. Keeping
> things out of mainline now I think has hit the point of actively hurting
> development. We're still having to dicker about with the core patches
> that aren't supposed to be contentious anymore, and we're making the
> hardware vendors work out of tree unnecessarily.

Things are getting better but if we didn't have objections starting a
year ago, I don't think as much effort would have been dedicated to
things like arm-acpi.txt, clarifying the ACPI spec around GIC support
etc. From my perspective, pushing a non-working (IOW not fully
functional) implementation in the kernel with a plan to sort things out
later doesn't really work. I wasn't fully convinced that Linaro will
dedicate the same effort once the code goes into mainline. So maybe not
the nicest approach but blocking ACPI merging is a way to see longer
term plans thought out.

Anyway, we now got to a point where the core patches are ok (-ish, there
are some comments to be addressed), we have some documents and guidance
that can evolve in time and we can show this working on real hardware
(well, not fully functional, for example you don't yet have lower CPU
power states). I'll have a look at the branch Al pointed me at (I would
have preferred linux-arm-kernel discussions rather than linaro-acpi
which I don't follow) but in the meantime I trust Arnd to have
scrutinised the Seattle patches ;).

I'll do another review of the ACPI core patches next week but with the
current comments addressed and acks from the subsystem maintainers
affected by these patches, we could try to push them to linux-next (but
no commitment for a specific kernel version). Once in -next, subsequent
fixes would have to go on top to avoid rebasing.

> > > 6. How does the kernel handle_DSD usage?
> > > While important, these issues are separate from whether or not to
> > > merge the core aarch64 code. This work was defined and driven by Intel
> > > for their embedded platforms, and it is already in mainline. Keeping
> > > aarch64 support out isn't going to prevent drivers using it from being
> > > merged. I don't think this should be a reason for blocking this
> > > series.
> >
> > Intel folk is coming from the other direction, relatively standard
> > hardware getting slightly more non-standard and they need a few bits
> > added in _DSD. On ARM, we have completely non-standard hardware with DT
> > used to describe complex topology (clocks, pin controls, voltage
> > regulators etc.) with a high risk that vendors see _DSD as a work around
> > standardising hardware or doing it properly in ACPI (whatever that
> > means, AML?).
[...]
> However, what we do have is a rule that bindings must be documented,
> whether they be DT or ACPI. So, regardless of what vendors try to shove
> into ACPI, the rule is that driver support shouldn't be merged without
> documented bindings (either in the kernel tree, or UEFI forum's repo),
> and that gives us some leverage.

The problem I have with this process is that the _DSD properties would
not be reviewed by the kernel maintainers before they are approved by
the UEFI forum. So the kernel community are just faced with a set of
patches to support approved _DSD bindings and at that point it's late to
push back, especially when such bindings were already implemented in
firmware.

I'd like to see some proper guidance for _DSD bindings rather than some
examples like "linux,trigger" currently on the UEFI website.

-- 
Catalin
