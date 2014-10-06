Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaJFHCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 03:02:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62127 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJFHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 03:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <20141001100341.GJ6884@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-5-git-send-email-wens@csie.org> <20140925133427.GI15315@lukather>
 <CAGb2v65Yu=3rgQ+G6USJubKOPzcMJ5bqhe7d9wrYjpT9aFaZuw@mail.gmail.com>
 <20140929095344.GE4388@lukather> <CAGb2v64-zshYgcPo-WR0TVebUDY3=LKBA9DfTVDKk2PA6VSiUA@mail.gmail.com>
 <20141001100341.GJ6884@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 6 Oct 2014 15:02:24 +0800
X-Google-Sender-Auth: 9_gynQ52Q0_-1tDkMO-4pgaMwXs
Message-ID: <CAGb2v674Eyf-=bes2i-qBEjHvS7sPvs2VDqy4cjNu9cGMiYj-g@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] ARM: dts: sun9i: Add A80 Optimus Board support
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        ctl <ctl@merrii.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 6:03 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Mon, Sep 29, 2014 at 06:04:50PM +0800, Chen-Yu Tsai wrote:
>> On Mon, Sep 29, 2014 at 5:53 PM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>> > On Sat, Sep 27, 2014 at 09:10:48PM +0800, Chen-Yu Tsai wrote:
>> >> On Thu, Sep 25, 2014 at 9:34 PM, Maxime Ripard
>> >> <maxime.ripard@free-electrons.com> wrote:
>> >> > On Wed, Sep 24, 2014 at 10:48:58PM +0800, Chen-Yu Tsai wrote:
>> >> >> The A80 Optimus Board is was launched with the Allwinner A80 SoC.
>> >> >> It was jointly developed by Allwinner and Merrii.
>> >> >>
>> >> >> This board has a UART port, a JTAG connector, USB host ports, a USB
>> >> >> 3.0 OTG connector, an HDMI output, a micro SD slot, 8G NAND flash,
>> >> >> 4G DRAM, a camera sensor interface, a WiFi/BT combo chip, a headphone
>> >> >> jack, IR receiver, and additional GPIO headers.
>> >> >>
>> >> >> This patch adds only basic support.
>> >> >>
>> >> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> >> >> ---
>> >> >>  arch/arm/boot/dts/Makefile              |  2 +
>> >> >>  arch/arm/boot/dts/sun9i-a80-optimus.dts | 66 +++++++++++++++++++++++++++++++++
>> >> >>  2 files changed, 68 insertions(+)
>> >> >>  create mode 100644 arch/arm/boot/dts/sun9i-a80-optimus.dts
>> >> >>
>> >> >> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> >> >> index 2f42b18..098f319 100644
>> >> >> --- a/arch/arm/boot/dts/Makefile
>> >> >> +++ b/arch/arm/boot/dts/Makefile
>> >> >> @@ -424,6 +424,8 @@ dtb-$(CONFIG_MACH_SUN7I) += \
>> >> >>       sun7i-a20-pcduino3.dtb
>> >> >>  dtb-$(CONFIG_MACH_SUN8I) += \
>> >> >>       sun8i-a23-ippo-q8h-v5.dtb
>> >> >> +dtb-$(CONFIG_MACH_SUN9I) += \
>> >> >> +     sun9i-a80-optimus.dtb
>> >> >>  dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
>> >> >>       tegra20-iris-512.dtb \
>> >> >>       tegra20-medcom-wide.dtb \
>> >> >> diff --git a/arch/arm/boot/dts/sun9i-a80-optimus.dts b/arch/arm/boot/dts/sun9i-a80-optimus.dts
>> >> >> new file mode 100644
>> >> >> index 0000000..f83abab
>> >> >> --- /dev/null
>> >> >> +++ b/arch/arm/boot/dts/sun9i-a80-optimus.dts
>> >> >> @@ -0,0 +1,66 @@
>> >> >> +/*
>> >> >> + * Copyright 2014 Chen-Yu Tsai
>> >> >> + *
>> >> >> + * Chen-Yu Tsai <wens@csie.org>
>> >> >> + *
>> >> >> + * This file is dual-licensed: you can use it either under the terms
>> >> >> + * of the GPL or the X11 license, at your option. Note that this dual
>> >> >> + * licensing only applies to this file, and not this project as a
>> >> >> + * whole.
>> >> >> + *
>> >> >> + *  a) This library is free software; you can redistribute it and/or
>> >> >> + *     modify it under the terms of the GNU General Public License as
>> >> >> + *     published by the Free Software Foundation; either version 2 of the
>> >> >> + *     License, or (at your option) any later version.
>> >> >> + *
>> >> >> + *     This library is distributed in the hope that it will be useful,
>> >> >> + *     but WITHOUT ANY WARRANTY; without even the implied warranty of
>> >> >> + *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> >> >> + *     GNU General Public License for more details.
>> >> >> + *
>> >> >> + *     You should have received a copy of the GNU General Public
>> >> >> + *     License along with this library; if not, write to the Free
>> >> >> + *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
>> >> >> + *     MA 02110-1301 USA
>> >> >> + *
>> >> >> + * Or, alternatively,
>> >> >> + *
>> >> >> + *  b) Permission is hereby granted, free of charge, to any person
>> >> >> + *     obtaining a copy of this software and associated documentation
>> >> >> + *     files (the "Software"), to deal in the Software without
>> >> >> + *     restriction, including without limitation the rights to use,
>> >> >> + *     copy, modify, merge, publish, distribute, sublicense, and/or
>> >> >> + *     sell copies of the Software, and to permit persons to whom the
>> >> >> + *     Software is furnished to do so, subject to the following
>> >> >> + *     conditions:
>> >> >> + *
>> >> >> + *     The above copyright notice and this permission notice shall be
>> >> >> + *     included in all copies or substantial portions of the Software.
>> >> >> + *
>> >> >> + *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> >> >> + *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
>> >> >> + *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> >> >> + *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
>> >> >> + *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
>> >> >> + *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>> >> >> + *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> >> >> + *     OTHER DEALINGS IN THE SOFTWARE.
>> >> >> + */
>> >> >> +
>> >> >> +/dts-v1/;
>> >> >> +/include/ "sun9i-a80.dtsi"
>> >> >> +
>> >> >> +/ {
>> >> >> +     model = "Merrii A80 Optimus Board";
>> >> >> +     compatible = "merrii,a80-optimus", "allwinner,sun9i-a80";
>> >> >> +
>> >> >> +     chosen {
>> >> >> +             bootargs = "earlyprintk console=ttyS0,115200";
>> >> >> +     };
>> >> >
>> >> > Since you changed the memory node in the DTSI, you should probably add
>> >> > one here too, don't you?
>> >>
>> >> I thought we left fixing that to the bootloader?
>> >> I don't see any memory nodes in our other DTS.
>> >
>> > Yes, but does the A80 bootloader supports DT and actually fixes it? If
>> > not, then you'll still have to have a memory node, just like on the
>> > A31 (and presumably on the A23).
>>
>> Not at the moment no. But last I checked none of our board dts files
>> have separate memory nodes. We only have them in the dtsi, with the
>> largest supported ram size as its value. Also the bootloader
>> (u-boot that is) can pass the memory size via atags I think.
>
> Only if CONFIG_ARM_ATAG_DTB_COMPAT is set.

Right. Last time I checked, this is set in both sunxi_defconfig
and multiv7_defconfig.

>> At least I'm only getting 512MB RAM on my Optimus, due to u-boot
>> incorrectly assuming I only have as much. But that's another problem. :(
>
> And does it initialize the rest of the memory?

It does. Very weird. But it may have something to do with the u-boot
blob not being patched with all dram parameters.

>> Would this be a problem when using Android fastboot from the stock
>> u-boot?
>
> IIRC, fastboot passes ATAGS anyway, so as long as you have the
> configuration option mentionned above, you should be safe.

I take this as an OK for this patch?


Cheers
ChenYu
