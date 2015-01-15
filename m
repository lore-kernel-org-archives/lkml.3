Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbbAOQ0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:26:44 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:47343 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbbAOQ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:26:41 -0500
MIME-Version: 1.0
In-Reply-To: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 15 Jan 2015 16:26:20 +0000
X-Google-Sender-Auth: w9rwFx4iBC7RLoKrXXQ2VRV3xA8
Message-ID: <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        liyi 00215672 <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> Hi,
>
> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1

Hi Catalin and Will,

I'll get right to the point: Can we please have this series queued up
for v3.20? I really think we've hit the point where it is more
valuable to merge it (or at least prepare to merge it) rather than
keeping it out of mainline.

First, I think we've agreed that the patches themselves are fine. The
remaining objections are based on maturity and whether or not we can
handle long term support. At this point, for all of the items on Al's
ACPI todo list, we've either got solutions for the problems, or solid
plans on how it is going to get solved (I'll go through each item one
by one at the end of this email). I won't claim that list is
exhaustive though. Please shout if there are new issues that need to
be added.

Second, real platforms using ACPI are showing up in various places.
Platforms are available from both APM and AMD. Huawei have spoken up
with test results that the patches boot on their unreleased platform
(Huawei needs GICv3 extensions, but otherwise it works). The
commercial products that are being built right now are being built
around these patches. Fedora Rawhide has picked them up also.

Continuing to keep the patches out I think is having the opposite
effect from what is desired. Catalin, you've told me a few times that
saying "no" is the only leverage you have to keeping crap drivers out
of the kernel until things mature, and by extension influence how
firmware gets implemented. However, as far as drivers are concerned,
there is nothing stopping maintainers from picking up ACPI drivers for
ARM hardware regardless of whether or not the core ARM code is merged.
If a driver depends on CONFIG_ACPI, and if the code seems to look
good, there is nothing preventing it from being merged. There are
already ARM related ACPI patches going into mainline.

For example: https://lkml.org/lkml/2014/12/25/120

Instead, keeping these patches out means that hardware is getting
developed and tested against Fedora, early access RHEL and Linaro
kernels. It means that we're abdicating on any influence mainline has
over how those platforms are developed. The longer these patches stay
out of mainline, the greater the potential for delta between what is
in the vendor kernels and what we accept into mainline.

The other concern may be keeping crap out of the core ARM code, but I
really don't think that will be an issue. The two of you still have
complete control over arch/arm64 and I fully expect crap code will be
aggressively NAKed whether or not it is ACPI related. All that merging
this series does is lays down a foundation of functionality on the
stuff we are pretty confident is correct. It keeps the delta between
mainline and the development code small and restricted to only the
bits that are still in flux.

Finally, keeping them out has the practical effect of causing extra
work to continually rebase them, while potentially running into new
conflicts and bugs, for little if any real benefit. Whereas getting
them into linux-next starts giving us some feedback on conflicts with
other things that are being queued up for mainline. Not to mention
reviewer fatigue having to go over the same set of patches again and
again.

Right now we're at -rc4. We'll be at -rc5 this weekend, and quite
possibly have a new merge window right at the start of Connect.
Queuing these patches up now isn't even a 100% commitment for you to
ask Linus to pull them. We can have further discussions at Connect. If
you're still not satisfied then drop them out again for another cycle.
However, if they aren't queued up now, then we're looking at mid-June
before they show up in a mainline kernel release.

As promised earlier, I said that I'd go through the todo list items.
Here they are with discussion:
1. Define how Aarch64 OS identifies itself to firmware
- We've pretty much settled on dropping the _OSI interface entirely,
which is trivial to do. All of the current platforms can adapt to
this. There are still some discussions around _OSC, but given that
this is the first release there isn't anything for the platform to
differentiate on regarding features. This isn't going to affect
current platforms, but rather will be important with the release of
the next version of the ACPI spec. It shouldn't affect our ability to
merge core support

2. Linux must choose DT booting by default when offered both ACPI and
   * Status: DONE, but being revisited for possible algorithmic change

3. Linux UEFI/ACPI testing tools must be made available
   * Done. We're implementing more tests of course, but that is expected.

4. Set clear expectations for those providing ACPI for use with Linux
   * We have a document that covers what we know so far, and will
continue to expand it. Also talking with the SBBR folks to move
relevant requirements into the SBBR doc.

5. Platform support patches need verification and review
   * ACPI core works on at least the Foundation model, Juno, APM
Mustang, and AMD Seattle
   * There still are driver patches being discussed. See Al's summary
for details
   * As I argued above, the state of driver patches isn't going to be

6. How does the kernel handle_DSD usage?
While important, these issues are separate from whether or not to
merge the core aarch64 code. This work was defined and driven by Intel
for their embedded platforms, and it is already in mainline. Keeping
aarch64 support out isn't going to prevent drivers using it from being
merged. I don't think this should be a reason for blocking this
series.

7. Why is ACPI required?
I hope I've addressed this[1], but discussion continues.

[1] http://www.spinics.net/lists/arm-kernel/msg389955.html
