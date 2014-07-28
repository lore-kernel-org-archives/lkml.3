Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaG1JJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:09:30 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61287 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaG1JJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:09:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Olof Johansson <olof@lixom.net>, Hanjun Guo <hanjun.guo@linaro.org>,
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
Date: Mon, 28 Jul 2014 11:07:50 +0200
Message-ID: <5014834.k6eecMddPC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAOesGMhKHGkVK3dOLXXx9GQBMxDmjBu1WDBgHmwdGe1UK3jfcg@mail.gmail.com>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-20-git-send-email-hanjun.guo@linaro.org> <CAOesGMhKHGkVK3dOLXXx9GQBMxDmjBu1WDBgHmwdGe1UK3jfcg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MBw2tZcOAob6kQRa+Fkyq2LjYITlFu5lAsaWF2/XEPO
 SCdVHZlgHO4dYSWys4/0DKrmKNbkaX4S0h+2l5sZzF3g+ynnkv
 F/oYKEKGwVHs9B2MO+m9VuGmpXNRs3foivWdtZe7YTsOCAgtAq
 RtKekfZpCJpVtH8MkuZkN8fCbaGvIY+j3r/R6dVIyoI7UUQ9Jx
 1JBXzwJ8hwfrW+Me+xbQHT5LtzA9HoH5Eqhzq9v7cWzIF0+Oej
 CuU7xEltWg16xWW69/iZgNBa3ghJrB8fobSlc1qCwZjU58YmFm
 4xG3xg/BLJnao5G2fcZ9jbvBMmU83BvRK6a3QhJGzh6hLtWhf0
 t97pRjBZWtBN8QE6i28M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 July 2014 19:34:48 Olof Johansson wrote:
> On Thu, Jul 24, 2014 at 6:00 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > +Relationship with Device Tree
> > +-----------------------------
> > +
> > +ACPI support in drivers and subsystems for ARMv8 should never be mutually
> > +exclusive with DT support at compile time.
> > +
> > +At boot time the kernel will only use one description method depending on
> > +parameters passed from the bootloader.
> 
> Possibly overriden by kernel bootargs. And as debated for quite a
> while earlier this year, acpi should still default to off -- if a DT
> and ACPI are both passed in, DT should at this time be given priority.

I think this would be harder to do with the way that ACPI is passed in
to the kernel. IIRC, you always have a minimal DT information based on
the ARM64 boot protocol, but in the case of ACPI, this contains pointers
to the ACPI tables, which are then used for populating the Linux platform
devices (unless acpi=disabled is set), while the other contents of the
DTB may be present but we skip the of_platform_populate state.

If this is correct, then replacing the firmware-generated dtb with a
user-provided on would implicitly remove the ACPI tables from visibility,
which is exactly what we want.

It's possible that I'm misremembering it though, and it should be
documented better.

> > +Regardless of whether DT or ACPI is used, the kernel must always be capable
> > +of booting with either scheme.
> 
> It should always be possible to compile out ACPI. There will be plenty
> of platforms that will not implement it, so disabling CONFIG_ACPI
> needs to be possible.

Right.

> > +Clocks
> > +------
> > +
> > +Like clocks that are part of the power resources there is no standard way
> > +to represent a clock tree in ACPI 5.1 in a similar manner to how it is
> > +described in DT.
> > +
> > +Devices affected by this include things like UARTs, SoC driven LCD displays,
> > +etc.
> > +
> > +The firmware for example UEFI should initialise these clocks to fixed working
> > +values before the kernel is executed. If a driver requires to know rates of
> > +clocks set by firmware then they can be passed to kernel using _DSD.
> > +
> > +example :-
> > +
> > +Device (CLK0) {
> > +       ...
> > +
> > +       Name (_DSD, Package() {
> > +               ToUUID("XXXXX"),
> > +               Package() {
> > +                       Package(2) {"#clock-cells", 0},
> 
> Clock-cells? What do they mean here? Is this specified in the ACPI
> standards? I had to register to get access to it, and didn't feel like
> doing that right now. I guess it's not _all_ that open a spec. :(
...
> > +                       Package(2) {"clock-frequency", "10000"}
> > +               }
> > +       })
> > +
> > +       ...
> > +}
> > +
> > +Device (USR1) {
> > +       ...
> > +
> > +       Name (_DSD, Package() {
> > +               ToUUID("XXXXX"),
> > +               Package() {
> > +                       Package(2) {"clocks", Package() {1, ^CLK0}}},
> 
> A clock is a device in the ACPI model? Why not just provide the rate
> as data into the device here? You said you're not trying to model the
> clock tree, so why reference an external node for it?

Exactly. I think what is going on here is a conflict of interests between
Intel's embedded ACPI uses and the ARM64 server requirements. The above
closely resembles what we do in DT, and that makes perfect sense for
Intel's machines so they can reuse a lot of the infrastructure we put
in place for DT. I also suspect it will take a few more years before
this actually gets accepted into both an ACPI specification and the
common operating systems (no point doing it if only Linux is going to
adopt it).

For the servers, I don't see how it makes any sense at all, independent
of the architecture, and relying on a feature like this would only serve
to delay the adoption of ACPI (whether that is a good or bad thing
may be a matter of perspective).

Maybe Graeme or others can comment on where this is coming from. What kind
of driver would actually need to find out the clock rate of a device on
an arm64 server? The examples above list "UARTs, SoC driven LCD displays,
etc.". For all I know, the UART is required to be PL01x (without DMA)
compatible, which should be fully described in ACPI, and I don't see why
a server would come with an LCD.

	Arnd
