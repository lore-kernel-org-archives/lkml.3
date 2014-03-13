Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaCMJ4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:56:54 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49517 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaCMJ4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:56:53 -0400
Message-ID: <532180E0.9060108@gmail.com>
Date: Thu, 13 Mar 2014 09:56:48 +0000
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: zmxu@marvell.com, jszhang@marvell.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: dts: berlin2q: add the Marvell Armada 1500 pro
 (BG2Q) device tree
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com> <1394622364-6848-2-git-send-email-antoine.tenart@free-electrons.com> <20140312122210.GA3040@piout.net>
In-Reply-To: <20140312122210.GA3040@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 12:22 PM, Alexandre Belloni wrote:
> On 12/03/2014 at 12:06:03 +0100, Antoine Ténart wrote :
>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> ---
>>   Documentation/arm/Marvell/README                   |   5 +
>>   .../devicetree/bindings/arm/marvell,berlin.txt     |   1 +

Please separate doc and dtsi changes into separate patches.

>>   arch/arm/boot/dts/berlin2q.dtsi                    | 167 +++++++++++++++++++++
>>   3 files changed, 173 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/berlin2q.dtsi
>>
>> diff --git a/Documentation/arm/Marvell/README b/Documentation/arm/Marvell/README
>> index 5a930c1528ad..69ad05ea8ed8 100644
>> --- a/Documentation/arm/Marvell/README
>> +++ b/Documentation/arm/Marvell/README
>> @@ -224,6 +224,11 @@ Berlin family (Digital Entertainment)
>>   		Core:		Marvell PJ4B (ARMv7), Tauros3 L2CC
>>   		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500/
>>   		Product Brief:	http://www.marvell.com/digital-entertainment/armada-1500/assets/Marvell-ARMADA-1500-Product-Brief.pdf
>> +	88DE3114, Armada 1500 Pro
>> +		Desgin name:	BG2-Q

s/Desgin/Design/

>> +		Core:		Quad Core ARM CA9, PL310 L2CC

s/ARM CA9/ARM Cortex-A9/

>> +		Homepage:	http://www.marvell.com/digital-entertainment/armada-1500-pro/
>> +		Product Brief:	http://www.marvell.com/digital-entertainment/armada-1500-pro/assets/Marvell_ARMADA_1500_PRO-01_product_brief.pdf
>>   	88DE????
>>   		Design name:	BG3
>>   		Core:		ARM Cortex-A15, CA15 integrated L2CC
>> diff --git a/Documentation/devicetree/bindings/arm/marvell,berlin.txt b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
>> index 737afa5f8148..25472b74218f 100644
>> --- a/Documentation/devicetree/bindings/arm/marvell,berlin.txt
>> +++ b/Documentation/devicetree/bindings/arm/marvell,berlin.txt
>> @@ -11,6 +11,7 @@ In addition, the above compatible shall be extended with the specific
>>   SoC and board used. Currently known SoC compatibles are:
>>       "marvell,berlin2"      for Marvell Armada 1500 (BG2, 88DE3100),
>>       "marvell,berlin2cd"    for Marvell Armada 1500-mini (BG2CD, 88DE3005)
>> +    "marvell,berlin2q"     for Marvell Armada 1500-pro (BG2Q)

Please add 88DE3114 above like there is already for the other SoCs.

>>       "marvell,berlin2ct"    for Marvell Armada ? (BG2CT, 88DE????)
>>       "marvell,berlin3"      for Marvell Armada ? (BG3, 88DE????)
>>
>> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
>> new file mode 100644
>> index 000000000000..f58c9c64c60e
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/berlin2q.dtsi
>> @@ -0,0 +1,167 @@
>> +/*
>> + * Copyright (C) 2014 Antoine Ténart <antoine.tenart@free-electrons.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>> +
>> +#include "skeleton.dtsi"
>> +
>> +/ {
>> +	model = "Marvell Armada 1500 pro (BG2-Q) SoC";
>> +	compatible = "marvell,berlin2q", "marvell,berlin";
[...]
>> +	clocks {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +
>> +		smclk: sysmgr-clock {
>> +			compatible = "fixed-clock";
>> +			#clock-cells = <0>;
>> +			clock-frequency = <25000000>;
>> +		};
>> +
>
> The 25MHz crystal is on the board, please move it to the board dts.

If you can confirm that sysmgr clock comes directly from this crystal,
I agree. If it is fed into a pll and can possibly be modified or gated,
make it depend on a 25MHz board crystal. If 25MHz is the only option
for this clock input, I could also live with it being part of the SoC
description.

Sebastian

