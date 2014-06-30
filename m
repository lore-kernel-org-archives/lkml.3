Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaF3NZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:25:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaF3NZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:25:01 -0400
Message-ID: <53B16527.8060301@suse.de>
Date: Mon, 30 Jun 2014 15:24:55 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Andreas Olofsson <andreas@adapteva.com>,
        Ben Chaco <bchaco@x3-c.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Matteo Vit <matteo.vit@starwaredesign.com>
Subject: Re: [PATCH 1/1] ARM: dts: zynq: Add Parallella device tree
References: <1404075022-28745-1-git-send-email-afaerber@suse.de>	<1404075022-28745-2-git-send-email-afaerber@suse.de> <CAOesGMhKY1Lb+o8AbtFXS5c7SLg2uGt4-oosdro2FMj_+bB6Tw@mail.gmail.com>
In-Reply-To: <CAOesGMhKY1Lb+o8AbtFXS5c7SLg2uGt4-oosdro2FMj_+bB6Tw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

+Matteo

Am 30.06.2014 07:15, schrieb Olof Johansson:
> On Sun, Jun 29, 2014 at 1:50 PM, Andreas Färber <afaerber@suse.de> wrote:
>> This allows to boot the Adapteva Parallella board to serial console.
>>
>> Cc: Andreas Olofsson <andreas@adapteva.com>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
> 
> Nice and clean DTS, just a couple of comments below.
> 
>> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
>> new file mode 100644
>> index 0000000..98df66c
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/zynq-parallella.dts
>> @@ -0,0 +1,63 @@
>> +/*
>> + * Copyright (c) 2014 SUSE LINUX Products GmbH
>> + *
>> + * Derived from zynq-zed.dts:
>> + *
>> + *  Copyright (C) 2011 Xilinx
>> + *  Copyright (C) 2012 National Instruments Corp.
>> + *  Copyright (C) 2013 Xilinx
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +/dts-v1/;
>> +/include/ "zynq-7000.dtsi"
>> +
>> +/ {
>> +       model = "Parallella Board";
>> +       compatible = "xlnx,zynq-7000";
> 
> This should have a more specific compatible as the first one. Probably
> something like:
>    compatible = "adapteva,parallella", "xlnx,zynq-7000";

Sure, I can add one if desired. As indicated in the file header, I used
zynq-zed.dts as template, which doesn't have its own either:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/zynq-zed.dts

Andreas, can I assume you would be okay with me assigning Adapteva, Inc.
the suggested "adapteva" prefix in the below list?

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/vendor-prefixes.txt

I guess it'll come in handy if we ever document the Epiphany
coprocessor's registers. The physical chip on the board is connected via
some FPGA glue - would that be placed like this?

/ {
	amba {
		epiphany: epiphany@80000000 {
			compatible = "adapteva,epiphany-iii";
			reg = <0x80000000 0x40000000>;
		};
	};
};

It's accessed through /dev/epiphany in a userspace library below,

https://github.com/adapteva/epiphany-libs/blob/master/src/e-hal/src/epiphany-hal.c#L215

https://github.com/adapteva/epiphany-libs/commit/80364e8ee4e99e450a632885a62e7a501398c200

but it's not clear to me who is supposed to create that device. No
downstream kernel driver nor corresponding node in the device tree:

https://github.com/parallella/parallella-linux-adi/blob/d04c39251dc3153b60555642b502dde15f7156a6/arch/arm/boot/dts/zynq-parallella.dts

Ben? Andreas?

Anyway, given that vf610.dtsi only documents the Cortex-A5 core but not
its Cortex-M4 companion core, I'm assuming we should not add the 16 (or
64) Epiphany cores to /cpus node (which would then require to split this
file into zynq-parallella.dtsi and zynq-parallella-{e16,e64}.dts).

>> +
>> +       memory {
>> +               device_type = "memory";
>> +               reg = <0 0x20000000>;

Err, this should be <0 0x40000000> (1 GiB). Copied from zynq-zed.dts,
and downstream has the wrong value, too.

> Does the bootloader update this entry, or is it truly static? If it's
> updated then it's become recent habit to leave the memory size empty
> in the static file.

The board uses a downstream U-Boot, displaying 992 MiB on serial.

andreas@parallella:/proc/device-tree/memory> hexdump -C reg
00000000  00 00 00 00 3e 00 00 00                           |....>...|
00000008

That matches 992 * 1024 * 1024. Shall I change to <0 0> then?

Confusing though is that the Epiphany manual says memory at <0x1e000000
0x02000000> is reserved for use by the Epiphany:

http://adapteva.com/docs/epiphany_sdk_ref.pdf section 14.1 page 118

I believe that is rather 0x3e000000, which U-Boot seems to confirm:

https://github.com/parallella/parallella-uboot/blob/3f4794e9ac524be6a373e6ff39ee9ae4529e0f14/include/configs/parallella.h#L25

>> +       };
>> +
>> +       chosen {
>> +               bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait";
>> +       };
>> +};
> 
> A bit more torn on this one, I'm OK with it staying in even if
> firmware overrides for all practical purposes since it's good to keep
> around for reference w.r.t. console. Note that we're starting to move
> over to using /chosen/stdout-path, so you might want to add that now
> instead of later.

The board boots U-Boot from flash; U-Boot is configured with no
bootdelay, and users are instructed to deploy one of two provided
devicetree.dtb files, depending on whether they want to run headless
(console=ttyPS0,115200) or with HDMI-enabling FPGA bitstream (no
console=). No bootargs variable is set in U-Boot environment.

U-Boot loads uImage, device tree and bitstream from FAT p1, and device
trees currently hardcode an ext4 p2, so I intentionally left that in
here, for unmodified .dtb deployment for shipping bootloader.

I'll look into /chosen/stdout-path, thanks for the pointer.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
