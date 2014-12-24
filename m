Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaLXTev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 14:34:51 -0500
Received: from mx5-phx2.redhat.com ([209.132.183.37]:44833 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaLXTes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 14:34:48 -0500
Date: Wed, 24 Dec 2014 14:33:29 -0500 (EST)
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
From: Jon Masters <jcm@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Olof Johansson <olof@lixom.net>,
        Robert Richter <rric@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Al Stone <al.stone@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>,
        Jason Cooper <jason@lakedaemon.net>
MIME-Version: 1.0
Message-ID: <1568291769.2704703.1419449609942.JavaMail.zimbra@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 8.0.6_GA_5922 (MobileSync - Android/4.4.4-EAS-2.0)
In-Reply-To: <20141224171815.GD13399@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org> <20141224171815.GD13399@e104818-lin.cambridge.arm.com>
Thread-Topic: Documentation: ACPI for ARM64
Thread-Index: ibjx0XFPFml1tPo0tYvmRjXtz6V7hA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Good feedback. In particular, though we have only one example of _DSD (network parameters because the hardware might be reset post boot and some of it is not sophisticated enough to preserve programmed MAC and parameters such as PHy type that will require reloading, both because drivers might be reprobed or because we might reboot or kexec) it is reasonable not to pull support for that into upstream on a short term basis while some of the process is codified. Generally with _DSD I know nobody is implementing anything else in the medium term and have ensured the vendors concerned have had private conversations to ensure existing _DSD entries in DSDTs out there conform to those proposed and are all self consistent (and are supported in certain other kernels so far). But for now that can suffice until the process is codified to a level everyone is comfortable with - certainly we would not expect growth there in the short term and would absolutely not expect DT entries to be arbitrarily carried over.

Also, I agree with the sentiments around codifying into the SBBR. Upstream kernel docs should pertain to Linux, but ideally non OS specifics will live in the SBBR. As one of the original coauthors of the SBBR I know our intention is to grow that document into a more complete platform doc. With that in mind, I will be donating Red Hat's commercial hardware requirements (shared with vendors in separate discussions) as input into that process in 2015.

Jon.

-- 
Computer Architect | Sent from my #ARM Powered Mobile Device

On Dec 24, 2014 5:18 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> Hi, 
>
> Some thoughts before the end of the year. I won't be able to follow up 
> until around 5th of January though. 
>
> On Hi,

Some thoughts before the end of the year. I won't be able to follow up
until around 5th of January though.

On Fri, Oct 17, 2014 at 02:37:14PM +0100, Hanjun Guo wrote:
> --- /dev/null
> +++ b/Documentation/arm64/arm-acpi.txt
> @@ -0,0 +1,323 @@
> +ACPI on ARMv8 Servers
> +---------------------
> +ACPI can be used for ARMv8 general purpose servers designed to follow
> +the ARM SBSA (Server Base System Architecture) specification, currently
> +available to those with an ARM login at http://silver.arm.com.

You should mention SBBR (Server Base Boot Requirements) here as well.
The arm-acpi.txt is complementary to arm-acpi.txt and longer term we
should aim to move parts of the Linux document into the more OS-agonstic
SBBR.

> +The ARMv8 kernel implements the reduced hardware model of ACPI version
> +5.1 and its corresponding errata.

I would say 5.1 or later to avoid updating this document every time we
get a new ACPI release.

> +If an ARMv8 system does not meet the requirements of the SBSA, or cannot
> +be described using the mechanisms defined in the required ACPI specifications,
> +then it is likely that Device Tree (DT) is more suitable than ACPI for the
> +hardware.

Based on some private discussions, I think we could drop some of the
references to DT in this document. It should specify the requirements
for ACPI support and, if not met, the alternative SoC support is
automatically DT for Linux. That's just to make it easier to move parts
of this doc into SBBR.

> +Relationship with Device Tree
> +-----------------------------

This section is fine, Linux specific and it will stay in this document.

> +ACPI support in drivers and subsystems for ARMv8 should never be mutually
> +exclusive with DT support at compile time.
> +
> +At boot time the kernel will only use one description method depending on
> +parameters passed from the bootloader (including kernel bootargs).
> +
> +Regardless of whether DT or ACPI is used, the kernel must always be capable
> +of booting with either scheme (in kernels with both schemes enabled at compile
> +time).
> +
> +When booting using ACPI tables, the /chosen node in DT will still be parsed
> +to extract the kernel command line and initrd path.  No other section of the
> +DT will be used.

I don't think this paragraph is needed. That's a kernel detail when how
the EFI_STUB passes the information to the rest of the kernel. We
mandate UEFI booting for ACPI support, so I wouldn't expect an
ACPI-aware U-Boot.

> +Booting using ACPI tables
> +-------------------------
> +The only defined method for passing ACPI tables to the kernel on ARMv8
> +is via the UEFI system configuration table.
> +
> +Processing of ACPI tables may be disabled by passing acpi=off on the kernel
> +command line; this is the default behavior.  If acpi=force is used, the kernel
> +will ONLY use device configuration information contained in the ACPI tables.

See my comments to Al around the defaults. I think if only ACPI tables
are present, we shouldn't panic the kernel if acpi=force is missing but
continue with ACPI. If both DT and ACPI tables are present, DT will be
the default. You could say "this is the default behaviour if both ACPI
and DT tables are present".

> +Device Enumeration
> +------------------
> +Device descriptions in ACPI should use standard recognized ACPI interfaces.
> +These can contain less information than is typically provided via a Device

s/can/may/ ? Not sure, it just sounds better to me (not a native English
speaker).

> +Tree description for the same device.  This is also one of the reasons that
> +ACPI can be useful -- the driver takes into account that it may have less
> +detailed information about the device and uses sensible defaults instead.
> +If done properly in the driver, the hardware can change and improve over
> +time without the driver having to change at all.
> +
> +Clocks provide an excellent example.  In DT, clocks need to be specified
> +and the drivers need to take them into account.  In ACPI, the assumption
> +is that UEFI will leave the device in a reasonable default state, including
> +any clock settings.  If for some reason the driver needs to change a clock
> +value, this can be done in an ACPI method; all the driver needs to do is
> +invoke the method and not concern itself with what the method needs to do
> +to change the clock.  Changing the hardware can then take place over time
> +by changing what the ACPI method does, and not the driver.
> +
> +ACPI drivers should only look at one specific ASL object -- the _DSD object
> +-- for device driver parameters (known in DT as "bindings", or "Device
> +Properties" in ACPI).  Not all DT bindings will be recognized. 

This last sentence kind of implies that many of the DT bindings will be
recognised. While it is useful to have some commonalities, I think this
gives the wrong message that _DSD is a copy of DT. We should avoid this.

> The UEFI
> +Forum provides a mechanism for registering such bindings [URL TBD by ASWG]

s/bindings/properties/ if we talk in the ACPI context.

> +so that they may be used on any operating system supporting ACPI.  Device
> +properties that have not been registered with the UEFI Forum should not be
> +used.

More about this further down.

> +Drivers should look for device properties in the _DSD object ONLY; the _DSD
> +object is described in the ACPI specification section 6.2.5, but more
> +specifically, use the _DSD Device Properties UUID:
> +
> +   -- UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> +
> +   -- http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf)
> +
> +The kernel has an interface for looking up device properties in a manner
> +independent of whether DT or ACPI is being used and that interface should
> +be used;

I haven't followed the _DSD kernel support but does it provide a common
API to be shared with DT? I'm not entirely convinced it's a good idea.

> it can eliminate some duplication of code paths in driver probing
> +functions and discourage divergence between DT bindings and ACPI device
> +properties.

Given the current different mechanism of reviewing/approving bindings
between DT and ACPI (kernel community vs UEFI forum), I don't see how we
encourage convergence (unless we state that _DSD are Linux-only, Windows
should use a different mechanism like .inf files).

> +ACPI tables are described with a formal language called ASL, the ACPI
> +Source Language (section 19 of the specification).  This means that there
> +are always multiple ways to describe the same thing -- including device
> +properties.  For example, device properties could use an ASL construct
> +that looks like this: Name(KEY0, "value0").  An ACPI device driver would
> +then retrieve the value of the property by evaluating the KEY0 object.
> +However, using Name() this way has multiple problems: (1) ACPI limits
> +names ("KEY0") to four characters unlike DT; (2) there is no industry
> +wide registry that maintains a list of names, minimzing re-use; (3)
> +there is also no registry for the definition of property values ("value0"),
> +again making re-use difficult; and (4) how does one maintain backward
> +compatibility as new hardware comes out?  The _DSD method was created
> +to solve precisely these sorts of problems; Linux drivers should ALWAYS
> +use the _DSD method for device properties and nothing else.
> +
> +The _DSM object (ACPI Section 9.14.1) could also be used for conveying
> +device properties to a driver.  Linux drivers should only expect it to
> +be used if _DSD cannot represent the data required, and there is no way
> +to create a new UUID for the _DSD object.  Note that there is even less
> +regulation of the use of _DSM than there is of _DSD.  Drivers that depend
> +on the contents of _DSM objects will be more difficult to maintain over
> +time because of this.
> +
> +The _DSD object is a very flexible mechanism in ACPI, as are the registered
> +Device Properties.  This flexibility allows _DSD to cover more than just the
> +generic server case and care should be taken in device drivers not to expect
> +it to replicate highly specific embedded behaviour from DT.

While this is all good, we need to be more specific on what "embedded
behaviour" means. Maybe not for this document but the UEFI approval
process for new properties doesn't give any hint on what is and is not
sane (and I already disagree with some of the examples on uefi.org).

> +Both DT bindings and ACPI device properties for device drivers have review
> +processes.  Use them.  And, before creating new device properties, check to
> +be sure that they have not been defined before and either registered in the
> +Linux kernel documentation or the UEFI Forum.  If the device drivers supports
> +ACPI and DT, please make sure the device properties are consistent in both
> +places.

In the interest of progress, I think we need to *temporarily* ban the
use of _DSD on ARM platforms aimed at ACPI and state it clearly in this
document. Once we are happy with the UEFI forum review process, we'll
adjust the document accordingly.

My problems with _DSD:

a) no clear guidance on what a good property means, whether it covers
   just device specific information or it may include Linux behaviour
   (like "linux,default-trigger", I don't think it should)
b) the Linux kernel community does not seem to be involved in the UEFI
   forum _DSD review process. This means that we'll be faced with
   patches against drivers to support UEFI-published _DSD properties.
   I want to avoid such arguments, rejecting kernel code is too late
   after _DSD properties have been published

The alternative to _DSD would be to program the hardware to some sane
state. For example, I'm sure a MAC address can be written by firmware to
some register and the driver can read and store it locally (I'm not even
sure why we need MAC address in ACPI tables, this is not really a
property of the hardware but a configuration that could be done in
firmware).

> +Clocks
> +------
> +ACPI makes the assumption that clocks are initialized by the firmware --
> +UEFI, in this case -- to some working value before control is handed over
> +to the kernel.  This has implications for devices such as UARTs, or SoC
> +driven LCD displays, for example.
> +
> +When the kernel boots, the clock is assumed to be set to reasonable
> +working value.  If for some reason the frequency needs to change -- e.g.,
> +throttling for power management -- the device driver should expect that
> +process to be abstracted out into some ACPI method that can be invoked
> +(please see the ACPI specification for further recommendations on standard
> +methods to be expected).  If is not, there is no direct way for ACPI to
> +control the clocks.

I would emphasize that there is no way for _Linux_ to directly control the
clocks on an ACPI-enabled platform.

> +ASWG
> +----
> +The following areas are not yet fully defined for ARM in the 5.1 version
> +of the ACPI specification and are expected to be worked through in the
> +UEFI ACPI Specification Working Group (ASWG):
> +
> +   -- ACPI based CPU topology
> +   -- ACPI based Power management
> +   -- CPU idle control based on PSCI
> +   -- CPU performance control (CPPC)
> +   -- ACPI based SMMU
> +   -- ITS support for GIC in MADT

In addition to the above and _DSD requirements/banning, I would also add
some clear statements around:

_OSC: only global/published capabilities are allowed. For
device-specific _OSC we need a process or maybe we can ban them entirely
and rely on _DSD once we clarify the process.

_OSI: firmware must not check for certain _OSI strings. Here I'm not
sure what we would have to do for ARM Linux. Reporting "Windows" does
not make any sense but not reporting anything can, as Matthew Garrett
pointed out, can be interpreted by firmware as "Linux". In addition to
any statements in this document, I suggest you patch
drivers/acpi/acpica/utosi.c accordingly, maybe report "Linux" for ARM
and print a kernel warning so that we notice earlier.

ACPI_OS_NAME: this is globally defined as "Microsoft Windows NT". It
doesn't make much sense in the ARM context. Could we change it to
"Linux" when CONFIG_ARM64?

Compatibility with older kernels: ACPI firmware must work, even though
not fully optimal, with the earliest kernel version implementing the
targeted ACPI spec. There may be a need for new drivers but otherwise
adding things like CPU power management should not break older kernel
versions. In addition, the ACPI firmware must also work with the latest
kernel version.


I strongly consider that we need to be very strict with the Linux ACPI
firmware and hardware requirements to avoid the need for supporting
non-standard implementations as much as possible. This is, however, a
live document, so we can relax it as we see fit (e.g. _DSD process
clarified).

In the meantime, Merry Christmas ;). I'll follow up in January.

-- 
Catalin
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
