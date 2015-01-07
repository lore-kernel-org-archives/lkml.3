Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbbAGVlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:41:23 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39758 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbAGVlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:41:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sphbtWBx4N/x72VpKIbtGEVo9PT0hmQc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8001064035C
Date: Wed, 7 Jan 2015 16:40:55 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jon Masters <jcm@redhat.com>
Cc: Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Message-ID: <20150107214055.GP24989@titan.lakedaemon.net>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <2161376.07iV9ANMSk@wuerfel>
 <20150107115039.GA2199@e104818-lin.cambridge.arm.com>
 <1520439.Y1rXzXY1eS@wuerfel>
 <20150107172741.GY2634@sirena.org.uk>
 <20150107184158.GO24989@titan.lakedaemon.net>
 <54AD8FF2.60407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD8FF2.60407@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 02:58:42PM -0500, Jon Masters wrote:
> On 01/07/2015 01:41 PM, Jason Cooper wrote:
> > On Wed, Jan 07, 2015 at 05:27:41PM +0000, Mark Brown wrote:
> >> On Wed, Jan 07, 2015 at 02:06:28PM +0100, Arnd Bergmann wrote:
> >>> On Wednesday 07 January 2015 11:50:39 Catalin Marinas wrote:
> >>
> >>>> From what I gathered so far, the main reason for _some_ vendors is not
> >>>> support for "other" OS but actually features that ACPI has and DT
> >>>> doesn't (like AML; I deliberately ignore statements like "industry
> >>>> standard"). _If_ such reasons are sound, maybe they have a case for
> >>>> ACPI-only machines targeted primarily at Linux.
> >>
> >>> What I got from the replies from HP, Huawei and from earlier discussions
> >>> with Jon is that they all hope to get to the point of relying on AML
> >>> alone to bridge the differences between SoC families. However, I don't
> >>> see that happening with the limited hardware compatibility that the
> >>> existing SBSA provides:
> >>
> >> I tend to agree with you that it's an overreach to think that this is
> >> going to completely abstract away the differences between SoCs from
> >> different vendors without substantial further standardization work.
> >> However it does seem reasonable to expect that features like AML are
> >> going to be more successful in handling board differences and
> >> incremental revisions of SoCs - things like interactions with system
> >> power controllers for example.  That seems like a useful win in and of
> >> itself, and one that's worth supporting.
> > 
> > This piqued my interest, so I did a little research and found the
> > following to describe AML (second para under "What does this mean?")
> > 
> >   http://community.arm.com/groups/processors/blog/2014/05/01/let-s-talk-acpi-for-servers
> > 
> > iiuc, AML are basically drivers for some low-level functions provided as
> > binary blobs via the ACPI tables.
> 
> AML isn't a "driver" per se. Think of it as providing a couple of
> methods for doing things like turning on a device, where the interpreted
> code might cause e.g. a memory address to be written with a value that
> causes a side effect (e.g. talking with a system configuration
> co-processor hidden inside the SoC the adjusts the clocking, enables
> power, configures PHY parameters, etc.). Most of the "AML" that you see
> on servers is actually just informational, or methods that return data
> describing the hardware installed.

So, similar in scope to an irqchip driver?  Because that's what I was
thinking when I said "driver", not alsa or drm...  Thanks for great
description.

> > How does this work in a trusted boot scenario?
> 
> No different than on x86.

Suprisingly, I don't do much with x86 development-wise.  The x86 boxes
are just tools to me.  So I'm not very familiar with the intricacies
there.  Do you have a pointer to ACPI update security
standards/protocols?

> > Can the ACPI tables, and these binary blobs with it, be updated from userspace?
> 
> Tables are baked into the firmware and are updated as a result of normal
> firmware updates (which already has a defined process). There are
> secondary tables that can augment things like the primary DSDT but those
> are also provided by the platform. There are only two ways the "OS"
> might provide a DSDT, but only including here for pedantry:
> 
> 1). If you compile a kernel specially with an embedded DSDT within the
> image itself (nobody does this one any more AFAIK).
> 
> 2). If you attach a special update test DSDT into your initramfs in a
> particular way, in which case I believe secure boot already is disabled.
> 
> But these are all developer/debug things, not intended for users running
> in a secure boot environment.

Right, I'm more concerned about the update process being the vector to
inject bad code.

> > If so, is there an authentication mechanism (including for non-secure boot scenarios)?
> 
> It's no different than scenarios on x86, which are well covered.
> 
> > One of the reasons I've really enjoyed working with ARM platforms and DT
> > is the absence of this type of 'feature'.  I honestly don't care whether
> > the kernel gets the board configuration info from DT or ACPI or FOO, as
> > long as we can avoid the security mistakes of the past:
> > 
> >   http://www.spiegel.de/international/world/catalog-reveals-nsa-has-back-doors-for-numerous-devices-a-940994.html
> 
> ACPI is not the great satan.

Relax, I'm not saying, nor implying that. :)  I *am* saying that
upgradeable executable code not loaded from traditional OS storage
(harddisk, flash) is a valid security concern.

> I'm aware certain others in the community have written missinformed
> blog posts and G+ rants equating ACPI with SMI and even with various
> other system firmware.

You're in luck, I don't blog or do social media. :-P

> I can't force someone to become informed on a topic, especially if
> it's politically useful to them to hate on ACPI and use the security
> paranoia handwavy argument.

I'm not sure where you got that from.  I said very specifically, since
trimmed, that I don't care where the board configuration data comes
from, DT, ACPI, or FOO.

If ACPI works, is stable, and integrates with the community, I'd use it.
Right now, DT is the closest to that goal, so it's what I prefer.

> > I'm not advocating "throw out AML and ACPI with it!", rather I'd like to
> > see a serious, open, discussion about the security implications of a
> > convenience feature such as AML.
> 
> AML is in (almost) every server you're using today.

"It's already everywhere" is not a valid reason to dismiss a security
discussion.  It's *not* on ARM today, so AML on ARM is a significant
change to ecosystem.  I'd hope I'm not the only person who was taking
advantage of fewer firmware hiding spots that ARM provides. :)

> What you want to be worried about is hidden firmware, especially what
> might be running inside a Trusted environment or inside an SMI
> context, or the radio firmware on your phone that the NSA have
> backdoored.

These are all valid security concerns, but this thread was about
ACPI/AML on ARM, so I didn't mention them.  Just because there are three
other holes doesn't mean we should throw up our hands and not address the
one in front of us.

> Once we've solved every other issue, we can come back to whether the
> extremely limited capabilities of AML are what the evil bad guys are
> using to infiltrate our minds and make us think that we all want to
> use ACPI.

Umm, wow.  I was not implying that a malicious piece of code would call
AML in a bad way to do something nefarious.  I *am* concerned about a
malicious update to the ACPI tables hooking an innocent AML call so that
*any* malicious code could be run at boot time, or suspend/resume,
shutdown, etc.

Sorry to have plucked a nerve, but I am sincerely interested in having a
*rational* discussion about how this changes the ARM ecosystem.  fwiw,
if I didn't think this was going to hit mainline, I wouldn't've bothered
bringing it up. ;-)

thx,

Jason.
