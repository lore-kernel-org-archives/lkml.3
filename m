Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaIXHPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:15:10 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57164 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIXHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:15:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140924063738.GQ15315@lukather>
References: <1411311493-24344-1-git-send-email-wens@csie.org>
 <1411311493-24344-4-git-send-email-wens@csie.org> <20140924063738.GQ15315@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 24 Sep 2014 15:14:47 +0800
X-Google-Sender-Auth: gO0AbvSruDVhoDiyudgUJXJq8C0
Message-ID: <CAGb2v64voZpK_82wtkErRowR0vjEUALNUwvCx_sd8Q5wb4Hq-g@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 3/6] ARM: dts: sunxi: Add Allwinner A80 dtsi
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        yhf@merrii.com, ctl@merrii.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 2:37 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> Thanks, a lot for your patches :)
>
> On Sun, Sep 21, 2014 at 10:58:10PM +0800, Chen-Yu Tsai wrote:
>> The Allwinner A80 is a new multi-purpose SoC with 4 Cortex-A7 and
>> 4 Cortex-A15 cores in a big.LITTLE architecture, and a 64-core
>> PowerVR G6230 GPU.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  arch/arm/boot/dts/sun9i-a80.dtsi | 280 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 280 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/sun9i-a80.dtsi
>>
>> diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a80.dtsi
>> new file mode 100644
>> index 0000000..f23ea59
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/sun9i-a80.dtsi
>> @@ -0,0 +1,280 @@
>> +/*
>> + * Copyright 2014 Chen-Yu Tsai
>> + *
>> + * Chen-Yu Tsai <wens@csie.org>
>> + *
>> + * This file is dual-licensed: you can use it either under the terms
>> + * of the GPL or the X11 license, at your option. Note that this dual
>> + * licensing only applies to this file, and not this project as a
>> + * whole.
>> + *
>> + *  a) This library is free software; you can redistribute it and/or
>> + *     modify it under the terms of the GNU General Public License as
>> + *     published by the Free Software Foundation; either version 2 of the
>> + *     License, or (at your option) any later version.
>> + *
>> + *     This library is distributed in the hope that it will be useful,
>> + *     but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *     GNU General Public License for more details.
>> + *
>> + *     You should have received a copy of the GNU General Public
>> + *     License along with this library; if not, write to the Free
>> + *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
>> + *     MA 02110-1301 USA
>> + *
>> + * Or, alternatively,
>> + *
>> + *  b) Permission is hereby granted, free of charge, to any person
>> + *     obtaining a copy of this software and associated documentation
>> + *     files (the "Software"), to deal in the Software without
>> + *     restriction, including without limitation the rights to use,
>> + *     copy, modify, merge, publish, distribute, sublicense, and/or
>> + *     sell copies of the Software, and to permit persons to whom the
>> + *     Software is furnished to do so, subject to the following
>> + *     conditions:
>> + *
>> + *     The above copyright notice and this permission notice shall be
>> + *     included in all copies or substantial portions of the Software.
>> + *
>> + *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
>> + *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
>> + *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
>> + *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>> + *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + *     OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +/include/ "skeleton.dtsi"
>> +
>> +/ {
>> +     interrupt-parent = <&gic>;
>> +
>> +     aliases {
>> +             serial0 = &uart0;
>> +             serial1 = &uart1;
>> +             serial2 = &uart2;
>> +             serial3 = &uart3;
>> +             serial4 = &uart4;
>> +             serial5 = &uart5;
>> +             serial6 = &r_uart;
>> +     };
>> +
>> +     cpu-map {
>> +             cluster0 {
>> +                     core0 {
>> +                             cpu = <&cpu0>;
>> +                     };
>> +                     core1 {
>> +                             cpu = <&cpu1>;
>> +                     };
>> +                     core2 {
>> +                             cpu = <&cpu2>;
>> +                     };
>> +                     core3 {
>> +                             cpu = <&cpu3>;
>> +                     };
>
> Having separation lines between the cores here would be nice.

OK.

>> +             };
>> +
>> +             cluster1 {
>> +                     core0 {
>> +                             cpu = <&cpu4>;
>> +                     };
>> +                     core1 {
>> +                             cpu = <&cpu5>;
>> +                     };
>> +                     core2 {
>> +                             cpu = <&cpu6>;
>> +                     };
>> +                     core3 {
>> +                             cpu = <&cpu7>;
>> +                     };
>> +             };
>> +     };
>> +
>> +     cpus {
>> +             #address-cells = <1>;
>> +             #size-cells = <0>;
>> +
>> +             cpu0: cpu@0 {
>> +                     compatible = "arm,cortex-a7";
>> +                     device_type = "cpu";
>> +                     reg = <0x0>;
>> +             };
>> +
>> +             cpu1: cpu@1 {
>> +                     compatible = "arm,cortex-a7";
>> +                     device_type = "cpu";
>> +                     reg = <0x1>;
>> +             };
>> +
>> +             cpu2: cpu@2 {
>> +                     compatible = "arm,cortex-a7";
>> +                     device_type = "cpu";
>> +                     reg = <0x2>;
>> +             };
>> +
>> +             cpu3: cpu@3 {
>> +                     compatible = "arm,cortex-a7";
>> +                     device_type = "cpu";
>> +                     reg = <0x3>;
>> +             };
>> +
>> +             cpu4: cpu@100 {
>> +                     compatible = "arm,cortex-a15";
>> +                     device_type = "cpu";
>> +                     reg = <0x100>;
>> +             };
>> +
>> +             cpu5: cpu@101 {
>> +                     compatible = "arm,cortex-a15";
>> +                     device_type = "cpu";
>> +                     reg = <0x101>;
>> +             };
>> +
>> +             cpu6: cpu@102 {
>> +                     compatible = "arm,cortex-a15";
>> +                     device_type = "cpu";
>> +                     reg = <0x102>;
>> +             };
>> +
>> +             cpu7: cpu@103 {
>> +                     compatible = "arm,cortex-a15";
>> +                     device_type = "cpu";
>> +                     reg = <0x103>;
>> +             };
>> +     };
>> +
>> +     memory {
>> +             reg = <0x20000000 0x40000000>;
>
> Usually, what we put there was the maximum amount of RAM that can be
> handled by the SoC. I think that it can go above 1GB

With LPAE, it can handle 8GB. But the DT won't take 64bit values.
I'm not sure how to get it in. I'll look around for examples.

> It looks fine otherwise, thanks!

Thanks!

ChenYu
