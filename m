Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaG1InJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:43:09 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51217 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaG1InC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:43:02 -0400
Message-ID: <53D60D11.8050205@linaro.org>
Date: Mon, 28 Jul 2014 09:42:57 +0100
From: Graeme Gregory <graeme.gregory@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Hanjun Guo <hanjun.guo@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>	<1406206825-15590-20-git-send-email-hanjun.guo@linaro.org> <CAOesGMhKHGkVK3dOLXXx9GQBMxDmjBu1WDBgHmwdGe1UK3jfcg@mail.gmail.com>
In-Reply-To: <CAOesGMhKHGkVK3dOLXXx9GQBMxDmjBu1WDBgHmwdGe1UK3jfcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27/07/2014 03:34, Olof Johansson wrote:
> On Thu, Jul 24, 2014 at 6:00 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>> From: Graeme Gregory <graeme.gregory@linaro.org>
>>
>> Add documentation for the guidelines of how to use ACPI
>> on ARM64.
> As the most vocal participant against ACPI being adopted, I would have
> appreciated a cc on this patch set -- it's not like you were going for
> a minimal set of cc recipients already. It makes it seem like you're
> trying to sneak it past me for comments. Not cool. I know that's
> probably not your intent, but still.
>
> Some comments below. Overall the doc looks pretty good, but the
> details about _DSD and clocks are somewhat worrisome.
>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   Documentation/arm64/arm-acpi.txt |  240 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 240 insertions(+)
>>   create mode 100644 Documentation/arm64/arm-acpi.txt
>>
>> diff --git a/Documentation/arm64/arm-acpi.txt b/Documentation/arm64/arm-acpi.txt
>> new file mode 100644
>> index 0000000..12cd550
>> --- /dev/null
>> +++ b/Documentation/arm64/arm-acpi.txt
>> @@ -0,0 +1,240 @@
>> +ACPI on ARMv8 Servers
>> +---------------------
>> +
>> +ACPI will be used for ARMv8 general purpose servers designed to follow
> "ACPI might be used"    or     "can be used"
>
>> +the SBSA specification (currently available to people with an ARM login at
>> +http://silver.arm.com)
>> +
>> +The implemented ACPI version is 5.1 + errata as released by the UEFI Forum,
>> +which is available at <http://www.uefi.org/acpi/specs>.
> The implemented version where? The kernel implements that version?
> Worth clarifying.
ok

the tables passed must be acpi 5.1+, the kernel must then obviously 
implement the 5.1 features, will clarify.
>> +If the machine does not meet these requirements then it is likely that Device
>> +Tree (DT) is more suitable for the hardware.
> This is should be a very clear statement that is currently vague
> w.r.t. which requirements are met or not, especially based on the
> sentence above.
The SBSA is the set of requirements, will clarify.

>> +Relationship with Device Tree
>> +-----------------------------
>> +
>> +ACPI support in drivers and subsystems for ARMv8 should never be mutually
>> +exclusive with DT support at compile time.
>> +
>> +At boot time the kernel will only use one description method depending on
>> +parameters passed from the bootloader.
> Possibly overriden by kernel bootargs. And as debated for quite a
> while earlier this year, acpi should still default to off -- if a DT
> and ACPI are both passed in, DT should at this time be given priority.
This does not work due to DT being misused as the kernel/bootloader 
communication layer as well. So a DT is always passed to the kernel. We 
cannot tell whether this is a useful DT without unpacking it and trying 
to boot platform from it.

There is an acpi=off parameter that can be passed to always disable acpi 
runtime.
> (Where can I learn more about how the boot loaders currently handle
> this? Do some of them pass in both DT and ACPI on some platforms, for
> example?)
Currently only one bootloader protocol is supported for ACPI and thats 
UEFI. As noted above due to abuse of DT in the /chosen/ node a DT is 
always passed to the kernel.

>> +Regardless of whether DT or ACPI is used, the kernel must always be capable
>> +of booting with either scheme.
> It should always be possible to compile out ACPI. There will be plenty
> of platforms that will not implement it, so disabling CONFIG_ACPI
> needs to be possible.
This will always be possible!
>> +When booting using ACPI tables the /chosen node in DT will still be parsed
>> +to extract the kernel command line and initrd path. No other section of
>> +the DT will be used.
>> +
>> +Booting using ACPI tables
>> +-------------------------
>> +
>> +Currently, the only defined method to pass ACPI tables to the kernel on ARMv8
>> +is via the UEFI system configuration table.
>> +
>> +The UEFI implementation MUST set the ACPI_20_TABLE_GUID to point to the
>> +RSDP table (the table with the ACPI signature "RSD PTR ").
>> +
>> +The pointer to the RSDP table will be retrieved from EFI by the ACPI core.
>> +
>> +Processing of ACPI tables may be disabled by passing acpi=off on the kernel
>> +command line.
>> +
>> +DO use an XSDT, RSDTs are deprecated and should not be used on arm64. They
>> +only allow for 32bit addresses.
>> +
>> +DO NOT use the 32-bit address fields in the FADT, they are deprecated, the
>> +64-bit alternatives MUST be used.
>> +
>> +The minimum set of tables MUST include RSDP, XSDT, FACS, FADT, DSDT, MADT
>> +and GTDT. If PCI is used the MCFG table MUST also be present.
>> +
>> +ACPI Detection
>> +--------------
>> +
>> +Drivers should determine their probe() type by checking for ACPI_HANDLE,
>> +or .of_node, or other information in the device structure. This is
>> +detailed further in the "Driver Recomendations" section.
>> +
>> +If the presence of ACPI needs to be detected at runtime, then check the value
>> +of acpi_disabled. If CONFIG_ACPI not being set acpi_disabled will always be 1.
> Just to make sure, if acpi_disabled is 0, then there will be no acpi
> handle associated with the device, right? I.e. there should be no need
> to have every single driver check for whether ACPI is disabled, the
> handle check should just fail instead.
I need to clarify this obviously, I meant for the second paragraph for 
that to be for code outside driver probing. Inside drivers they should 
only check for ACPI_HANDLE presence. But other bits of code espcially 
bits parsing tables for information in early boot should check for 
acpi_disabled before hunting for the tables etc.
>> +Device Enumeration
>> +------------------
>> +
>> +Device descriptions in ACPI should use standard recognised ACPI interfaces.
>> +These are far simpler than the information provided via Device Tree. Drivers
>> +should take into account this simplicity and work with sensible defaults.
>> +
>> +On no account should a Device Tree attempt to be replicated in ASL using such
>> +constructs as Name(KEY0, "Value1") type constructs. Additional driver specific
>> +data should be passed in the appropriate _DSM (ACPI Section 9.14.1) method or
>> +_DSD (ACPI Section 6.2.5). This data should be rare and not OS specific.
> I see these two sentences as contradictory, given that the _DSD doc
> linked below contains examples that mirror over several properties,
> such as "linux,default-trigger" and other LED-specific properties.
> (section 2.4.2 in the below doc). "default-state" seems to come from
> DT too?
>
> Care to elaborate and explain what the intention here is? This could
> worst case turn into quite a mess.
>
> Given that ACPI can present completely different data based on what OS
> is running, it's quite common to indeed have OS specific data in
> there. How does that relate to this document and these practices?
OS specific data has traditionally not worked out well for ACPI, I would 
like to "persuade" people not to use it on ARM.

The _DSD was quite late to the standards process and the supporting 
documentation is still catching up. We are working with ARM to bring 
these issues up and to define proper OS agnostic bindings for ARM.
>> +Common _DSD bindings should be submitted to ASWG to be included in the
>> +document :-
>> +
>> +http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
> So, for these that are a mirror of the device tree bindings, there
> needs to be a wording here around reviewing the DT binding first so we
> don't get diverging bindings.
>
>> +TODO: Clarification and examples from Juno implementation.
>> +
>> +Programmable Power Control Resources
>> +------------------------------------
>> +
>> +Programmable power control resources include such resources as voltage/current
>> +providers (regulators) and clock sources.
>> +
>> +For power control of these resources they should be represented with Power
>> +Resource Objects (ACPI Section 7.1). The ACPI core will then handle correctly
>> +enabling/disabling of resources as they are needed.
>> +
>> +There exists in the ACPI 5.1 specification no standard binding for these objects
>> +to enable programmable levels or rates so this should be avoid if possible and
>> +the resources set to appropriate level by the firmware. If this is not possible
>> +then any manipulation should be abstracted in ASL.
>> +
>> +Each device in ACPI has D-states and these can be controlled through
>> +the optional methods _PS0..._PS3 where _PS0 is full on and _PS3 is full off.
>> +
>> +If either _PS0 or _PS3 is implemented, then the other method must also be
>> +implemented.
>> +
>> +If a device requires usage or setup of a power resource when on, the ASL
>> +should organise that it is allocated/enabled using the _PS0 method.
>> +
>> +Resources allocated/enabled in the _PS0 method should be disabled/de-allocated
>> +in the _PS3 method.
>> +
>> +Such code in _PS? methods will of course be very platform specific but
>> +should allow the driver to operate the device without special non standard
>> +values being read from ASL. Further, abstracting the use of these resources
>> +allows hardware revisions without requiring updates to the kernel.
>> +
>> +TODO: Clarification and examples from Juno implementation.
>> +
>> +Clocks
>> +------
>> +
>> +Like clocks that are part of the power resources there is no standard way
>> +to represent a clock tree in ACPI 5.1 in a similar manner to how it is
>> +described in DT.
>> +
>> +Devices affected by this include things like UARTs, SoC driven LCD displays,
>> +etc.
>> +
>> +The firmware for example UEFI should initialise these clocks to fixed working
> Odd wording.  Maube "The firmware (for example UEFI) should..."
agreed!
>> +values before the kernel is executed. If a driver requires to know rates of
>> +clocks set by firmware then they can be passed to kernel using _DSD.
>> +
>> +example :-
>> +
>> +Device (CLK0) {
>> +       ...
>> +
>> +       Name (_DSD, Package() {
>> +               ToUUID("XXXXX"),
>> +               Package() {
>> +                       Package(2) {"#clock-cells", 0},
> Clock-cells? What do they mean here? Is this specified in the ACPI
> standards? I had to register to get access to it, and didn't feel like
> doing that right now. I guess it's not _all_ that open a spec. :(
>
>> +                       Package(2) {"clock-frequency", "10000"}
>> +               }
>> +       })
>> +
>> +       ...
>> +}
>> +
>> +Device (USR1) {
>> +       ...
>> +
>> +       Name (_DSD, Package() {
>> +               ToUUID("XXXXX"),
>> +               Package() {
>> +                       Package(2) {"clocks", Package() {1, ^CLK0}}},
> A clock is a device in the ACPI model? Why not just provide the rate
> as data into the device here? You said you're not trying to model the
> clock tree, so why reference an external node for it?
This section is still a bit WIP due to the above noted issues with _DSD 
documentation catching up with the standards process. I will need to 
work with the clock maintainers to see if we can agree a proper set of 
bindings for this. #blah-cells always was my least favorite DT feature.

>> +               }
>> +       })
>> +
>> +       ...
>> +}
>> +
>> +Driver Recommendations
>> +----------------------
>> +
>> +DO NOT remove any FDT handling when adding ACPI support for a driver, different
>> +systems may use the same device.
>> +
>> +DO try and keep complex sections of ACPI and DT functionality seperate. This
>> +may mean a patch to break out some complex DT to another function before
>> +the patch to add ACPI. This may happen in other functions but is most likely
>> +in probe function. This gives a clearer flow of data for reviewing driver
>> +source.
>> +
>> +probe() :-
>> +
>> +TODO: replace this with a specific real example from Juno?
>> +
>> +static int device_probe_dt(struct platform_device *pdev)
>> +{
>> +       /* DT specific functionality */
>> +       ...
>> +}
>> +
>> +static int device_probe_acpi(struct platform_device *pdev)
>> +{
>> +       /* ACPI specific functionality */
>> +       ...
>> +}
>> +
>> +static int device_probe(stuct platform_device *pdev)
>> +{
>> +       ...
>> +       acpi_handle handle = ACPI_HANDLE(&pdev->dev);
>> +       struct device_node node = pdev->dev.of_node;
>> +       ...
>> +
>> +       if (node)
>> +               ret = device_probe_dt(pdev);
>> +       else if (handle)
>> +               ret = device_probe_acpi(pdev);
>> +       else
>> +               /* other initialisation */
>> +               ...
>> +       /* Continue with any generic probe operations */
>> +       ...
>> +}
> This looks good to me, and it's also my preferred way of ACPI-enabling
> drivers. I guess we might discuss this at KS since it was a proposed
> topic there, and others will object. :)
Hopefully someone can summarise the discussion at KS for me, I will not 
be there.
>> +
>> +DO keep the MODULE_DEVICE_TABLE entries together in the driver to make it clear
>> +the different names the driver is probed for, both from DT and from ACPI.
>> +
>> +module device tables :-
>> +
>> +static struct of_device_id virtio_mmio_match[] = {
>> +        { .compatible = "virtio,mmio", },
>> +        {},
>> +};
>> +MODULE_DEVICE_TABLE(of, virtio_mmio_match);
>> +
>> +static const struct acpi_device_id virtio_mmio_acpi_match[] = {
>> +        { "LNRO0005", },
>> +        { }
> No comma here, but a comma on DT. Probably make them equivalent for
> consistency (including space between the braces).
ok
>> +};
>> +MODULE_DEVICE_TABLE(acpi, virtio_mmio_acpi_match);
>> +
>> +TODO: Add any other helpful rules that develop from Juno ACPI work.
> Looks like this should be fixed before the patch is merged, or this
> TODO removed.
The plan is to fix these TODOs with actual data from Juno as that will 
be in the UEFI for Juno.
>> +
>> +ASWG
>> +----
>> +
>> +The following areas are not yet well defined for ARM in the current ACPI
>> +specification and are expected to be worked through in the UEFI ACPI
>> +Specification Working Group (ASWG) <http://www.uefi.org/workinggroups>.
>> +Participation in this group is open to all UEFI members.
>> +
>> +       - ACPI based CPU topology
>> +       - ACPI based Power management
>> +       - CPU idle control based on PSCI
>> +       - CPU performance control (CPPC)
>> +
>> +No code shall be accepted into the kernel unless it complies with the released
>> +standards from UEFI ASWG. If there are features missing from ACPI to make it
>> +function on a platform ECRs should be submitted to ASWG and go through the
>> +approval process.
> Thanks for listing the things that are not in place yet. Please keep
> this doc up to date as new areas are discovered.
>
>
> -Olof
Thanks for the feedback, we shall work to incorporate it into the document.

Graeme

