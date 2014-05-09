Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaEIFDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 01:03:00 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33107 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaEIFC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 01:02:58 -0400
Message-ID: <536C6175.5000302@gmail.com>
Date: Fri, 09 May 2014 07:02:45 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: kgene.kim@samsung.com, t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org, arnd@arndb.de,
        olof@lixom.net, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCHv4 7/7] ARM: dts: Add device tree sources for Exynos3250
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com> <1398388572-30239-8-git-send-email-cw00.choi@samsung.com> <535B0324.50705@gmail.com> <536C2A1C.6030807@samsung.com>
In-Reply-To: <536C2A1C.6030807@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 09.05.2014 03:06, Chanwoo Choi wrote:
> On 04/26/2014 09:51 AM, Tomasz Figa wrote:
>> On 25.04.2014 03:16, Chanwoo Choi wrote:

[snip]

>>> +    cpus {
>>> +        #address-cells = <1>;
>>> +        #size-cells = <0>;
>>> +
>>> +        cpu@0 {
>>> +            device_type = "cpu";
>>> +            compatible = "arm,cortex-a7";
>>> +            reg = <0>;
>>> +            clock-frequency = <1000000000>;
>>> +        };
>>
>> Why only one CPU? I believe Exynos3250 is dual core.
>
> I'll add cpu1 information.
>
>> Also are physical IDs of the cores really 0 and 1? On Exynos4210 for example they are 0x900 and 0x901, while on Exynos4212 they are 0xa00 and 0xa01. Please check this.
>
> The 'reg' property means only hardware id(hwid) of CPU.
> You can check it on arm_dt_init_cpu_maps() in arch/arm/kernel/devtree.c.h.
> or Documentation/devicetree/bindings/arm/cpus.txt.
>

Well, as described in Documentation/devicetree/bindings/arm/cpus.txt, on 
32-bit ARM v7 or later CPUs the "reg" property should be equal to the 
lower 24-bits of MPIDR value of given CPU, which in addition to core ID 
includes also cluster ID, which can be non-zero, even on single cluster 
SoCs (like it is on Exynos4210 and 4x12).

>>> +    };
>>> +
>>> +    fixed-rate-clocks {
>>> +        compatible = "simple-bus";
>>> +        #address-cells = <1>;
>>> +        #size-cells = <0>;

[snip]

>>> +    cmu: clock-controller@10030000 {
>>> +        compatible = "samsung,exynos3250-cmu";
>>> +        reg = <0x10030000 0x20000>;
>>> +        #clock-cells = <1>;
>>> +    };
>>> +
>>> +    rtc@10070000 {
>>
>> Please add label to the node, so it can be referenced from board dts files added later (using the method I explained above).
>
> OK, I'll add lable as following:
>
> 	rtc_0: rtc@10070000 {

There is no need to suffix the RTC with _0, as there is just one RTC in 
the SoC. So in this case rtc: rtc@10070000 will be enough.

>
>>
>>> +        compatible = "samsung,s3c6410-rtc";
>>> +        reg = <0x10070000 0x100>;
>>> +        interrupts = <0 73 0>, <0 74 0>;
>>> +        status = "disabled";
>>> +    };

[snip]

>>> +    adc: adc@126C0000 {
>>> +        compatible = "samsung,exynos-adc-v3";
>>> +        reg = <0x126C0000 0x100>, <0x10020718 0x4>;
>>> +        interrupts = <0 137 0>;
>>> +        clock-names = "adc", "sclk_tsadc";
>>> +        clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
>>> +        #io-channel-cells = <1>;
>>> +        io-channel-ranges;
>>> +        status = "disabled";
>>> +    };
>>> +
>>> +    serial@13800000 {
>>
>> Please add label.
>
> OK, I'll add lable as following:
>
> 	serial_0: serial@13800000 {
>

OK. In this case there are multiple instances of serial controller 
available so the _0 suffix is fine.

>>
>>> +        compatible = "samsung,exynos4210-uart";
>>> +        reg = <0x13800000 0x100>;
>>> +        interrupts = <0 109 0>;
>>> +        clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
>>> +        clock-names = "uart", "clk_uart_baud0";
>>> +        status = "disabled";
>>> +    };
>>> +
>>> +    serial@13810000 {
>
> OK, I'll add lable as following:
>
> 	serial_1: serial@13800000 {
>

OK.

>
> Thanks for your review.

You're welcome. Thanks for addressing my comments.

Best regards,
Tomasz
