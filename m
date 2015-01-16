Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbbAPQ3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:29:51 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33584 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbbAPQ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:29:49 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
To: Catalin Marinas <catalin.marinas@arm.com>
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
In-Reply-To: <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
	<CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
	<20150115182346.GE2329@e104818-lin.cambridge.arm.com>
Date: Fri, 16 Jan 2015 16:29:44 +0000
Message-Id: <20150116162944.EE0E3C40BF1@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 18:23:47 +0000
, Catalin Marinas <catalin.marinas@arm.com>
 wrote:
> Hi Grant,
> 
> On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
> > On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > > This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
> > 
> > I'll get right to the point: Can we please have this series queued up
> > for v3.20?
> 
> Before you even ask for this, please look at the patches and realise
> that there is a complete lack of Reviewed-by tags on the code (well,
> apart from trivial Kconfig changes). In addition, the series touches on
> other subsystems like clocksource, irqchip, acpi and I don't see any
> acks from the corresponding maintainers. So even if I wanted to merge
> the series, there is no way it can be done without additional
> reviews/acks. On the document (last patch), I'd like to see a statement
> from HP as they've been vocal in private but no public endorsement of
> this doc.

I have to ask. We've got no idea what you are thinking in terms of merge
timeline. The ToDo list is part of the question, certainly, but if I
have to ask flat-out to get some progress, then I will. Up to this
point, the primary objections have been coming from you and other ARM
maintainers, not the ACPI maintainer, and not other subsystem
maintainers, so of course I'm going to address my arguments to you and
Will.


> I also have trouble seeing the full picture. Is there a git repository
> somewhere with this series and any additional patches required for a
> real hardware platform?

I believe Al has sent you a git URL by now.

> 
> > I really think we've hit the point where it is more valuable to merge
> > it (or at least prepare to merge it) rather than keeping it out of
> > mainline.
> 
> That's pretty subjective.

You and I are both maintainers; an awful lot of our job is subjective
opinion on whether something is ready or not! That's why I said "I
really think" rather than "We have".  :-)

The rest of my email is laying out my argument for why I think it is
time to start queuing these patches up.

> > Continuing to keep the patches out I think is having the opposite
> > effect from what is desired. Catalin, you've told me a few times that
> > saying "no" is the only leverage you have to keeping crap drivers out
> > of the kernel until things mature, and by extension influence how
> > firmware gets implemented. However, as far as drivers are concerned,
> > there is nothing stopping maintainers from picking up ACPI drivers for
> > ARM hardware regardless of whether or not the core ARM code is merged.
> > If a driver depends on CONFIG_ACPI, and if the code seems to look
> > good, there is nothing preventing it from being merged. There are
> > already ARM related ACPI patches going into mainline.
> > 
> > For example: https://lkml.org/lkml/2014/12/25/120
> 
> I wasn't really referring to simple driver changes like the above but to
> whole subsystems like clocks done in ACPI. My point was that before we
> enable arm64 ACPI, we need to have some clear guidelines to firmware and
> hardware vendors, otherwise if we don't know how to do it properly, we
> shouldn't even bother (or we may end up re-creating the DT support in
> ACPI; I'm not convinced that's sorted yet).

Whole subsystem changes aren't the big risk. Saying yes to this series
does not commit us to also picking up badly formed ACPI infrastructure.
Changes to subsystems get a lot more scrutiny than drivers do.

As for clocks, pinctrl, and regulators, the answer has been simple and
clear for a long time. No. We won't do anything automatic with any of
those in mainline until there is an ACPI specification that addresses
them. Until that time they are out-of-spec and won't be supported.

Also, my point still stands. Subsystem changes do not hinge on whether
or not arch/arm64 has ACPI support. Changes have been merged to add ACPI
support to platform_bus, i2c and spi subsystems well over a year ago.

> > Instead, keeping these patches out means that hardware is getting
> > developed and tested against Fedora, early access RHEL and Linaro
> > kernels. It means that we're abdicating on any influence mainline has
> > over how those platforms are developed. The longer these patches stay
> > out of mainline, the greater the potential for delta between what is
> > in the vendor kernels and what we accept into mainline.
> 
> I'm not buying this argument. Putting pressure on maintainers to merge
> something because Fedora or some other distro has merged them is not the
> right approach. If such Linux vendors ignore arguments on the list just
> for the sake of providing ACPI support, there is a high chance that they
> will accept non-standard code any other time when the kernel community
> disagrees.

It's not like I'm arguing for stuff that isn't ready to be merged. Even
back last October there was broad agreement from all of us (Will, Olof,
Marc Z. Mark R., myself) that these patches are correct and that the
remaining objections are related to larger questions of ecosystem. My
argument is that for all the outstanding issues, we've either got a
solution, or a process for working it out with hardware vendors. Keeping
things out of mainline now I think has hit the point of actively hurting
development. We're still having to dicker about with the core patches
that aren't supposed to be contentious anymore, and we're making the
hardware vendors work out of tree unnecessarily.

> Just to be clear, I don't block the ACPI patches for fun, reading these
> long threads is not fun anymore. I don't have any religious arguments
> against ACPI, longer term I see it as a first class citizen alongside
> DT, but I want to make sure we do it properly and have a clear vision on
> how we support it in the future. You can call this "delayed
> gratification" if you want.
>
> And it's not about code going into arch/arm64 and not even small driver
> changes to enable ACPI but the longer term plans on how we reduce
> (rather than eliminate) future kernel quirks because we didn't first get
> to an agreement on how kernel and firmware interact. Things are getting
> better and Al's to-do list is a good benchmark (more comments below).
> 
> (I have my concerns with DT as well but the requirement of compatibility
> between older/newer kernels/firmware is not as strict)
> 
> > Finally, keeping them out has the practical effect of causing extra
> > work to continually rebase them, while potentially running into new
> > conflicts and bugs, for little if any real benefit. Whereas getting
> > them into linux-next starts giving us some feedback on conflicts with
> > other things that are being queued up for mainline. Not to mention
> > reviewer fatigue having to go over the same set of patches again and
> > again.
> 
> 17 patches is really not too hard and it looks like the number is slowly
> decreasing as they are picked by the corresponding maintainers.
> 
> > Right now we're at -rc4. We'll be at -rc5 this weekend, and quite
> > possibly have a new merge window right at the start of Connect.
> > Queuing these patches up now isn't even a 100% commitment for you to
> > ask Linus to pull them. We can have further discussions at Connect. If
> > you're still not satisfied then drop them out again for another cycle.
> > However, if they aren't queued up now, then we're looking at mid-June
> > before they show up in a mainline kernel release.
> 
> See the beginning of the email about the prerequisites for queuing
> something up into linux-next.
> 
> > As promised earlier, I said that I'd go through the todo list items.
> > Here they are with discussion:
> > 1. Define how Aarch64 OS identifies itself to firmware
> > - We've pretty much settled on dropping the _OSI interface entirely,
> > which is trivial to do. All of the current platforms can adapt to
> > this. There are still some discussions around _OSC, but given that
> > this is the first release there isn't anything for the platform to
> > differentiate on regarding features. This isn't going to affect
> > current platforms, but rather will be important with the release of
> > the next version of the ACPI spec. It shouldn't affect our ability to
> > merge core support
> 
> I'm fine with this.
> 
> > 2. Linux must choose DT booting by default when offered both ACPI and
> >    * Status: DONE, but being revisited for possible algorithmic change
> 
> OK.
> 
> > 3. Linux UEFI/ACPI testing tools must be made available
> >    * Done. We're implementing more tests of course, but that is expected.
> 
> OK.
> 
> > 4. Set clear expectations for those providing ACPI for use with Linux
> >    * We have a document that covers what we know so far, and will
> > continue to expand it. Also talking with the SBBR folks to move
> > relevant requirements into the SBBR doc.
> 
> Moving bits of it into SBBR is a good long term plan but it should not
> prevent the merging. However, I'd like to see more vendors ok'ing the
> kernel document.
> 
> > 5. Platform support patches need verification and review
> >    * ACPI core works on at least the Foundation model, Juno, APM
> > Mustang, and AMD Seattle
> >    * There still are driver patches being discussed. See Al's summary
> > for details
> >    * As I argued above, the state of driver patches isn't going to be
> 
> We are still lacking here. To quote Al, "First version for AMD Seattle
> has been posted to the public linaro-acpi mailing list for initial
> review". Sorry but I don't follow linaro-acpi list. I don't know what's
> in those patches and I can't tell which subsystems they touch, whether
> maintainers agree with them. So in conclusion, I'm not confident the
> arm64 hardware ACPI story looks that great yet.
> 
> As for Juno and foundation models, I don't consider them server
> platforms.
> 
> > 6. How does the kernel handle_DSD usage?
> > While important, these issues are separate from whether or not to
> > merge the core aarch64 code. This work was defined and driven by Intel
> > for their embedded platforms, and it is already in mainline. Keeping
> > aarch64 support out isn't going to prevent drivers using it from being
> > merged. I don't think this should be a reason for blocking this
> > series.
> 
> Intel folk is coming from the other direction, relatively standard
> hardware getting slightly more non-standard and they need a few bits
> added in _DSD. On ARM, we have completely non-standard hardware with DT
> used to describe complex topology (clocks, pin controls, voltage
> regulators etc.) with a high risk that vendors see _DSD as a work around
> standardising hardware or doing it properly in ACPI (whatever that
> means, AML?).

Doing it properly in ACPI merely means giving the drivers the data
and/or methods that it needs. The ACPI spec does define some methods to
be used by OSPM, but everything else is completely arbitrary, and always
has been.

The *only* thing that _DSD does new is to define a specific format for
adding key-value properties to an ACPI object that follow the rules of
properties. Apple Mac hardware has done exactly the same thing for
years, except it stuffed that stuff into the _DSM method.

So, _DSD is no less "doing it property in ACPI" than AML methods would
be. In either case it is the responsibility of the driver to know what
extra properties/methods might be attached to the device, and to know
what to do with those properties/methods. The core OS doesn't care, and
won't touch them.

*so what* if vendor toss odd data into a _DSD property. It still won't
wire up to the automatic clock/pinctrl/voltage infrastructure that we
use for DT because none of those things will be there. It won't make a
non-standard ARM machine suddenly behave.

However, what we do have is a rule that bindings must be documented,
whether they be DT or ACPI. So, regardless of what vendors try to shove
into ACPI, the rule is that driver support shouldn't be merged without
documented bindings (either in the kernel tree, or UEFI forum's repo),
and that gives us some leverage.

What we can also do is create a least-effort path for driver authors.
There are helper functions for parsing _DSD that are easier than doing
something custom. It is less effort to use existing DT bindings with the
device properties API than to try and have a separate set of ACPI
bindings.

But, still, I strongly contend that this is a sideshow when looking at
the core ARM patches. _DSD code is happening right now, with or without
aarch64.

> > 7. Why is ACPI required?
> > I hope I've addressed this[1], but discussion continues.
> > 
> > [1] http://www.spinics.net/lists/arm-kernel/msg389955.html
> 
> That's great. I see this as a good reference for the future.
> 
> To complete the picture, we probably need a "Why *not* ACPI on ARM" blog
> as well explaining when ACPI is *not* suitable (e.g. no SBSA
> compliance). The arm-acpi.txt covers the ACPI requirements from the
> kernel perspective and, by contrast, DT would be better suited for
> certain platforms. The way you present it is that ACPI solves lots of
> problems that DT doesn't but not necessarily where the ACPI limitations
> are (vs DT).

I thought I was pretty clear in that document that ACPI is only
preferred for the general purpose ecosystem (OS vendor and HW vendor are
separate companies, and selected by the end user). Everywhere else the
preference is DT. However, I can write more on this topic and make it
clear that I'm talking about SBSA hardware. It will probably take me a
week or so to get that written. Certainly before we're in Hong Kong for
Connect.

g.
