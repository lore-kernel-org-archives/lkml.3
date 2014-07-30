Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaG3QiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:38:01 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:33290 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbaG3Qh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:37:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140730154626.GD20162@leverpostej>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org> <20140730154626.GD20162@leverpostej>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 30 Jul 2014 11:37:38 -0500
Message-ID: <CAL_JsqLJ_W34XTF2aMOW9z+Gq4oxbrX1RztyJN8Mi0OFPeNxfg@mail.gmail.com>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder SoC
To: Mark Rutland <mark.rutland@arm.com>, Robert Richter <rric@kernel.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 10:46 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Wed, Jul 30, 2014 at 04:06:31PM +0100, Robert Richter wrote:
>> From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
>>
>> Add initial device tree nodes for Cavium Thunder SoCs with support of
>> 48 cores and gicv3. The dts file requires further changes, esp. for
>> pci, gicv3-its and smmu. This changes will be added later together
>> with the device drivers.
>>
>> Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
>> Signed-off-by: Robert Richter <rrichter@cavium.com>
>> ---
>>  arch/arm64/boot/dts/Makefile         |   1 +
>>  arch/arm64/boot/dts/thunder-88xx.dts | 387 +++++++++++++++++++++++++++++++++++
>>  2 files changed, 388 insertions(+)
>>  create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts
>>
>> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
>> index c52bdb051f66..f8001a62029c 100644
>> --- a/arch/arm64/boot/dts/Makefile
>> +++ b/arch/arm64/boot/dts/Makefile
>> @@ -1,3 +1,4 @@
>> +dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>>
>> diff --git a/arch/arm64/boot/dts/thunder-88xx.dts b/arch/arm64/boot/dts/thunder-88xx.dts
>> new file mode 100644
>> index 000000000000..4cf20ac9138b
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/thunder-88xx.dts
>> @@ -0,0 +1,387 @@
>> +/*
>> + * Cavium Thunder DTS file
>> + *
>> + * Copyright (C) 2013, Cavium Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation; either version 2 of
>> + * the License, or (at your option) any later version.
>> + */

You may want to reconsider if this should be BSD.

>> +/dts-v1/;
>> +
>> +/* Reserving first 12MB of DDR for firmware */
>> +/memreserve/ 0x00000000 0x00c00000;
>
> What exactly is this memreserve intended to protect at runtime?
>
> The only item of runtime firmware I see in use below is PSCI on the
> secure side.
>
> How is the kernel booted on this platform? UEFI?
>
>> +/ {
>> +     model = "Cavium ThunderX CN88XX Family";
>> +     compatible = "cavium,thunder-88xx";
>
> Please don't use wildcards in compatible strings. Give this an absolute
> name, and override as necessary.
>
>> +     interrupt-parent = <&gic0>;
>> +     #address-cells = <2>;
>> +     #size-cells = <2>;
>> +
>> +     aliases {
>> +             serial0 = &uaa0;
>> +             serial1 = &uaa1;
>> +     };
>> +
>> +     psci {
>> +             compatible = "arm,psci-0.2";
>> +             method = "smc";
>> +     };
>
> Nice!
>
>> +
>> +     cpus {
>> +             #address-cells = <2>;
>> +             #size-cells = <0>;
>> +
>> +             cpu@000 {
>> +                     device_type = "cpu";
>> +                     compatible = "cavium,thunder", "arm,armv8";
>> +                     reg = <0x0 0x000>;
>> +                     enable-method = "psci";
>> +             };
>
> Just to check: both the SoC and CPU are called thunder?
>
> [...]
>
>> +
>> +     memory@00000000 {
>> +             device_type = "memory";
>> +             reg = <0x0 0x00000000 0x0 0x80000000>;
>> +     };
>> +
>> +     gic0: interrupt-controller@801000000000 {
>
> To make this easier to read, please place a comma between 32-bit
> portions of the unit address (e.g. here have 8010,00000000).

Mark, perhaps a dtc or checkpatch.pl check for this?

This should also be under a bus node.

>> +             compatible = "arm,gic-v3";
>> +             #interrupt-cells = <3>;
>> +             #address-cells = <2>;
>> +             #size-cells = <2>;
>> +             ranges;
>
> This has no children, so why have ranges, #address-cells, and
> #size-cells?
>
>> +             interrupt-controller;
>> +             reg = <0x8010 0x00000000 0x0 0x010000>, /* GICD */
>> +                   <0x8010 0x80000000 0x0 0x200000>; /* GICR */
>> +             interrupts = <1 9 0xf04>;
>> +     };
>> +
>> +     timer {
>> +             compatible = "arm,armv8-timer";
>> +             interrupts = <1 13 0xff01>,
>> +                          <1 14 0xff01>,
>> +                          <1 11 0xff01>,
>> +                          <1 10 0xff01>;
>> +     };
>> +
>> +     soc {
>> +             compatible = "simple-bus";
>> +             #address-cells = <2>;
>> +             #size-cells = <2>;
>> +             ranges;
>> +
>> +             clocks {
>> +                     #address-cells = <2>;
>> +                     #size-cells = <2>;
>> +                     ranges;
>> +
>> +                     refclk50mhz: refclk50mhz {
>> +                             compatible = "fixed-clock";
>> +                             #clock-cells = <0>;
>> +                             clock-frequency = <50000000>;
>> +                             clock-output-names = "refclk50mhz";
>> +                     };
>> +             };
>
> Please get rid of the clocks node and just put the clocks here.
>
>> +
>> +             uaa0: serial@87e024000000 {
>> +                     compatible = "arm,pl011", "arm,primecell";
>> +                     reg = <0x87e0 0x24000000 0x0 0x1000>;
>> +                     interrupts = <1 21 4>;
>> +                     clocks = <&refclk50mhz>;
>> +                     clock-names = "apb_pclk";
>
> Is this actually the apb_pclk, or is the the uartclk? I assume it's the
> latter.

Shouldn't new bindings have both clocks here? A single clock was a
mistake I think (mine in fact).

Rob
