Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaAMTZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:25:46 -0500
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:33418 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753115AbaAMTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:25:41 -0500
MIME-Version: 1.0
In-Reply-To: <201401131619.35030.arnd@arndb.de>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
	<6073715.cGydpIHKD1@wuerfel>
	<CAL85gmA5Ob+kp-+5seO-wcB8tx4jyiOeFMyCsZWFBLdX09nZDg@mail.gmail.com>
	<201401131619.35030.arnd@arndb.de>
Date: Mon, 13 Jan 2014 11:25:39 -0800
Message-ID: <CAL85gmCTsxng3jCaAcCjePE6Pxu7Jg98TDUqQrDFzsfW2GQwEg@mail.gmail.com>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot
 dts node.
From: Feng Kan <fkan@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is not what I was asking about.
>
> The problem with your binding is that it doesn't seem to describe
> the hardware structure at all, but rather try to invent devices
> because of how it's convenient for how you write the Linux drivers.
>
> This is never a good idea and it will become a problem once you
> try to port a different operating system, or when the structure
> of the Linux drivers changes. Remember that in Linux we can freely
> reorganize our code as requirements change, but the bindings have
> to remain stable to allow running new kernels with an older device
> tree that may be shipped with the firmware.
>
> (Side note: if you end up doing an ACPI driver for this after all,
> the problem is even worse because it's basically impossible to update
> the ACPI tables in field, while with DT you can at least override
> them in the firmware if something goes really wrong.)
>
> On most SoCs I've seen, the system reset registers are part of
> some on-chip device, most likely one of
> - A SoC-specific system control register set containing various
>   global registers that may be of interest to other parts of the
>   kernel.
FKAN: our system block in your reference would be the system clock unit (SCU).
It handles number of things (JTAG, clock control, power control not
touched by OS).
The register that is relevant to the system reset is this lone
register. I reduce the
range of the dts aperture due to this fact.


> - A watchdog timer device that will reset the system after a crash,
>   or when explicit requested by the OS
> - A dedicated reset controller that has registers for individually
>   resetting a number of subsystems of the SoC, or all at once in
>   case of system reboot.
> - an interface to an external or integrated power management IC
>   that controls voltages and/or clock frequencies provided to
>   the SoC and other parts of the system.
>
> In each of those cases, we already have a subsystem that is supposed
> to handle the entire register set and provide a system reset method
> as one of the things it does. Given that your register is at offset
> 0x14 from the start of a larger MMIO range, I strongly suspect
> that the same is true here.
FKAN: I could remove this dts node and create another dts node that
describe the range of registers on the SCU and use that node in this driver.
I am not sure which subsystem I can use to handle this case, I do see a reset
subsystem in the kernel but more used for ip resets. Please kindly let
me know. Thanks for the great feedback.
>
>         Arnd
