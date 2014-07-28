Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaG1Q11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:27:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53267 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaG1Q1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:27:25 -0400
Date: Mon, 28 Jul 2014 09:27:50 -0700
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        linaro-acpi-private@linaro.org, Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
Message-ID: <20140728162750.GB32359@quad.lixom.net>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
 <1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
 <CAOesGMhKHGkVK3dOLXXx9GQBMxDmjBu1WDBgHmwdGe1UK3jfcg@mail.gmail.com>
 <5014834.k6eecMddPC@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5014834.k6eecMddPC@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:07:50AM +0200, Arnd Bergmann wrote:
> On Saturday 26 July 2014 19:34:48 Olof Johansson wrote:
> > On Thu, Jul 24, 2014 at 6:00 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > > +Relationship with Device Tree
> > > +-----------------------------
> > > +
> > > +ACPI support in drivers and subsystems for ARMv8 should never be mutually
> > > +exclusive with DT support at compile time.
> > > +
> > > +At boot time the kernel will only use one description method depending on
> > > +parameters passed from the bootloader.
> > 
> > Possibly overriden by kernel bootargs. And as debated for quite a
> > while earlier this year, acpi should still default to off -- if a DT
> > and ACPI are both passed in, DT should at this time be given priority.
> 
> I think this would be harder to do with the way that ACPI is passed in
> to the kernel. IIRC, you always have a minimal DT information based on
> the ARM64 boot protocol, but in the case of ACPI, this contains pointers
> to the ACPI tables, which are then used for populating the Linux platform
> devices (unless acpi=disabled is set), while the other contents of the
> DTB may be present but we skip the of_platform_populate state.

How can it be harder to do? If you support acpi=off, then you should support
acpi=on.

Another alternative would be to have an early fixup that stubs out
the acpi properties from the DTB unless there's an 'acpi' or 'acpi=on'
argument on the cmdline. Not quite as tidy a solution, though.

> If this is correct, then replacing the firmware-generated dtb with a
> user-provided on would implicitly remove the ACPI tables from visibility,
> which is exactly what we want.

I was of the impression that firmware patches in the ACPI entries into either
device-tree before launching the kernel. Is that not the case? And what if
some bootloader chooses to do it that way in the future? It's better to not
assume that they get it right.

> It's possible that I'm misremembering it though, and it should be
> documented better.

Yes, definitely needs to be documented to not leave room for random
interpretation later on.


-Olof
