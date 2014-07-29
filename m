Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaG2KH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:07:56 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36843 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaG2KHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:07:52 -0400
Date: Tue, 29 Jul 2014 12:07:47 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Naresh Bhat <naresh.bhat@linaro.org>, Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linaro-acpi-private@linaro.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
Message-ID: <20140729100747.GA18250@cbox>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
 <1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
 <CAFoFrHaWWxRPRYM5+bWj0tGnz05SokqwVGejUCUi+U-KChFBdQ@mail.gmail.com>
 <53D17852.3050606@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D17852.3050606@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 02:19:14PM -0700, Randy Dunlap wrote:
> On 07/24/2014 02:16 PM, Naresh Bhat wrote:
> > 
> > On 24 July 2014 18:30, Hanjun Guo <hanjun.guo@linaro.org <mailto:hanjun.guo@linaro.org>> wrote:
> > 
> >     From: Graeme Gregory <graeme.gregory@linaro.org <mailto:graeme.gregory@linaro.org>>
> > 
> >     Add documentation for the guidelines of how to use ACPI
> >     on ARM64.
> > 
> >     Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org <mailto:graeme.gregory@linaro.org>>
> >     Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org <mailto:hanjun.guo@linaro.org>>
> >     ---
> >      Documentation/arm64/arm-acpi.txt |  240 ++++++++++++++++++++++++++++++++++++++
> >      1 file changed, 240 insertions(+)
> >      create mode 100644 Documentation/arm64/arm-acpi.txt
> > 
> >     diff --git a/Documentation/arm64/arm-acpi.txt b/Documentation/arm64/arm-acpi.txt
> >     new file mode 100644
> >     index 0000000..12cd550
> >     --- /dev/null
> >     +++ b/Documentation/arm64/arm-acpi.txt
> >     @@ -0,0 +1,240 @@
> >     +ACPI on ARMv8 Servers
> >     +---------------------
> >     +
> >     +ACPI will be used for ARMv8 general purpose servers designed to follow
> >     +the SBSA specification (currently available to people with an ARM login at
> >     +http://silver.arm.com)
> >     +
> >     +The implemented ACPI version is 5.1 + errata as released by the UEFI Forum,
> >     +which is available at <http://www.uefi.org/acpi/specs>.
> >     +
> >     +If the machine does not meet these requirements then it is likely that Device
> >     +Tree (DT) is more suitable for the hardware.
> >     +
> >     +Relationship with Device Tree
> >     +-----------------------------
> >     +
> >     +ACPI support in drivers and subsystems for ARMv8 should never be mutually
> >     +exclusive with DT support at compile time.
> >     +
> >     +At boot time the kernel will only use one description method depending on
> >     +parameters passed from the bootloader.
> >     +
> >     +Regardless of whether DT or ACPI is used, the kernel must always be capable
> >     +of booting with either scheme.
> >     +
> >     +When booting using ACPI tables the /chosen node in DT will still be parsed
> >     +to extract the kernel command line and initrd path. No other section of
> >     +the DT will be used.
> >     +
> >     +Booting using ACPI tables
> >     +-------------------------
> >     +
> >     +Currently, the only defined method to pass ACPI tables to the kernel on ARMv8
> >     +is via the UEFI system configuration table.
> >     +
> >     +The UEFI implementation MUST set the ACPI_20_TABLE_GUID to point to the
> >     +RSDP table (the table with the ACPI signature "RSD PTR ").
> >     +
> >     +The pointer to the RSDP table will be retrieved from EFI by the ACPI core.
> >     +
> >     +Processing of ACPI tables may be disabled by passing acpi=off on the kernel
> >     +command line.
> >     +
> >     +DO use an XSDT, RSDTs are deprecated and should not be used on arm64. They
> >     +only allow for 32bit addresses.
> >     +
> >     +DO NOT use the 32-bit address fields in the FADT, they are deprecated, the
> >     +64-bit alternatives MUST be used.
> >     +
> >     +The minimum set of tables MUST include RSDP, XSDT, FACS, FADT, DSDT, MADT
> >     +and GTDT. If PCI is used the MCFG table MUST also be present.
> >     +
> >     +ACPI Detection
> >     +--------------
> >     +
> >     +Drivers should determine their probe() type by checking for ACPI_HANDLE,
> >     +or .of_node, or other information in the device structure. This is
> >     +detailed further in the "Driver Recomendations" section.
> >     +
> >     +If the presence of ACPI needs to be detected at runtime, then check the value
> >     +of acpi_disabled. If CONFIG_ACPI not being set acpi_disabled will always be 1.
> >     +
> >     +Device Enumeration
> >     +------------------
> >     +
> >     +Device descriptions in ACPI should use standard recognised ACPI interfaces.
> > 
> > 
> > recognized
> 
> Yeah, I saw all of these also, but we accept British or American spelling of these words.
> 
Would be good to check for a consistent spelling in this doc though.

-Christoffer
