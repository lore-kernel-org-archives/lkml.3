Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbbA2MTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:19:04 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9977 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbbA2MTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:19:00 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-dd-54ca24a0e9a1
Message-id: <54CA2524.6090500@samsung.com>
Date: Thu, 29 Jan 2015 13:18:44 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Chanwoo Choi <cwchoi00@gmail.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/12] clk: samsung: exynos5433: Add clocks using common
 clock framework
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
 <1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
 <54C129B0.1090404@samsung.com> <54C1FBF6.4040405@samsung.com>
 <54C2877A.3040500@samsung.com>
 <CAGTfZH3NM-Y7Q9ru_iyKXFRO67TAc=SG8urwDyUF_qWWKEGVVg@mail.gmail.com>
 <54C972DB.1020808@samsung.com>
In-reply-to: <54C972DB.1020808@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xa7oLVE6FGJxsELK4vF/b4vqX56wW
	z45qW0y6P4HFov/xa2aLy7vmsFnMOL+PyeLphItsFou2fmG3mDH5JZvFql1/GB24PXbOusvu
	sWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoErY/Zm5YLp9hXr/h1iamC8rd/F
	yMEhIWAisfGbUhcjJ5ApJnHh3nq2LkYuDiGBpYwSu6eeZIdwPjFKzJ/+lwWkgVdAS2LOOX2Q
	BhYBVYmOM19ZQGw2AUOJ3qN9jCC2qECExMm7e9hBbF4BQYkfk++B1YgIaEjM/HuFEWQms8Ap
	Zokbp5+zgswUFkiU2L2OC2LXCSaJzaub2UAaOAW0Jb7Na2YCqWEWUJeYMiUXJMwsIC+xec1b
	5gmMArOQrJiFUDULSdUCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCEx8HUH49JjVocY
	BTgYlXh4Z2w6GSLEmlhWXJl7iFGCg1lJhLdQ6VSIEG9KYmVValF+fFFpTmrxIUYmDk6pBsaj
	OnvXqXT3fP5ltE/2v8JNJp7b9sd2l9XLFFqctpNcJltlK9O+8eCPJpPcwMLjr5+qd+XovdXq
	Upm0y8qg9iV7f0rpUSNl1eBTf08KXz3HVaBh/LjczmjRi2Ozpn0z4omdV77zn9bE+7etPokt
	8+O6Iv/tDd+u5L59vufa83Q3rpo2pUcnQlKJpTgj0VCLuag4EQC2DZL4XwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 29/01/15 00:38, Chanwoo Choi wrote:
...
>>>>
>>>> Right. current samsung clock drivers cannot show the hierarchy among clock
>>>> domains in DT.
>>>>
>>>>>> IOW, there is currently
>>>>>> no way to ensure proper registration order of the CMUs (clock domains).
>>>>>> This may be important in some cases.
>>>>>>
>>>>>> To address this we could either add clocks/clock-names properties in
>>>>>> respective CMU device nodes, pointing to any clocks in other CMU(s) or
>>>>>> make a single device node for the whole clock controller, with an
>>>>>> aggregated reg entry, e.g.
>>>>>>
>>>>>>  cmu: clock-controller@0x10030000 {
>>>>>>    compatible = "samsung,exynos5433-cmu";
>>>>>>    reg =   <0x10030000 0x0c04>,
>>>>>>            <0x10fc0000 0x0c04>,
>>>>>>            <0x105b0000 0x100c>,
>>>>>>            <0x14c80000 0x0b08>,
>>>>>>            <0x10040000 0x0b20>,
>>>>>>            <0x156e0000 0x0b04>,
>>>>>>                    ...
>>>>>>    reg-names = "top", "cpif", "mif", "peric", "peris", "fsys"...
>>>>>>    #clock-cells = <1>;
>>>>>>  };
>>>>
>>>> If you make a single device node to support various clock domain,
>>>> How are you indicate the specific clock in some clock domain?
>>>
>>> This might be an issue, we would need to make all the clk indexes a one
>>> contiguous set.
>>
>> Exynos5433 has a whole lot of clocks against Exynos4 series clocks.
>> So, if make all the clocks in the same set, I wonder making too huge set.
>> It may cause the complicated code to find the proper clock or to analyze
>> the clock driver.
>>
>> I'm wondering if there is really any use of having such
>>> information expressed explicitly in DT, or it would just make the DT
>>> binding closer resembling the SoC's documentation ?
>>
>> If we show the hierarchy or dependency between clock domains,
>> I think we should modify "structure samsung_clk_provider"
>> to include dependency information between clock domains.
>> (It is just my opinion, this opinion could be not proper solution.)

As your patches stand currently there is no need to do anything else
in the driver, since the clock dependencies are specified by static
clock names in each clk domain provider.
We could just leave the multiple nodes, one per each clk domain and if
we specified parent clocks to each clk domain the clk providers would
be registered in proper order, since clk core would take care of it.

>> Because when we use the common clk framework without adding
>> any dependency information between clock domains, it is well working.

Yes it works currently, but if you try to get/set rate of a clock supplied
by a clk domain A right after this domain is registered, and domain B which
provides clocks to domain A is not yet registered the clk rate will be
incorrect.
We are currently not seeing any issues only because our use cases are
limited.

>>> Similarly, the clock controller is divided into subdomains in older SoCs,
>>> like exynos4, yet we do not create separate device nodes for each domain.
>>> Is reference to each individual clock domain required in any other SoC's
>>> part in case of exynos5433 ?
>>
>> There is a difference between exynos4 cmu and exynos5433 cmu.
>> exynos4. As I knew, Exynos4 series have the one more clock domain.
>> But, there are not any IPs between clock domains. We can check it as following
>> read base address and scope.
>>
>> The base address and range of Exynos4412 clock domain :
>> - 0x1003_0000 ~ 0x1003_CA08
>> - 0x1004_0000 ~ 0x1004_8B0C
>>
>> But, the clock domain in base address map of exynos5433 is located
>> in non-continuous range. Also, there are un-related IPs to clocks.
>> (e.g., mct 101c_0000, gic 1100_1000, serial0 14c1_0000, pinctrl 1058_0000 ...)
>> If we make the one dt node for clock domains like exynos4,
>> I think it may cause the possible issue that clock drivers may access
>> the un-related memory-mapped region.
>>
>> The base address and range of Exynos5433 clock domain :
>> - top domain    : 0x1003_0000 ~ 0x1003_0c04
>> - cpif domain   : 0x10fc_0000 ~ 0x10fc_0x0c04
>> - mif domain    : 0x105b_0000 ~ 0x105b_0x100c
>> - peric domain : 0x14c8_0000 ~ 0x14c8_0b08
>> - peris domain  : 0x1004_0000 ~ 0x1004_0x0b20
>> - fsys domain   : 0x156e_0000 ~ 0x156e_0b04

For reason Tomasz mentioned it may be indeed better to model each clk
domain as separate node.  In order to, for example make it easier to
handle dependencies between clk domain and power domain.

The register region specified by reg property of course doesn't have to be
contiguous, each offset/size tuple from reg will be just mapped separately
in the driver.  So there can be gaps (including regions of other IP blocks)
between the clock controller blocks registers memory regions.

>>>> For example,
>>>> The serial dt node in exynos7.dtsi. serial_0 dt node use the uart clocks
>>>> in 'clock_peric0' clock domain and serial_1 dt node use the uart clocks
>>>> in 'clock-peric1' clock domain.
>>>>
>>>> When using the clock in specific clock domain,
>>>> we need to phandle(e.g., clock_peric0, clock_peric1) of clock domain.
>>>>
>>>>               serial_0: serial@13630000 {
>>>>                       compatible = "samsung,exynos4210-uart";
>>>>                       reg = <0x13630000 0x100>;
>>>>                       interrupts = <0 440 0>;
>>>>                       clocks = <&clock_peric0 PCLK_UART0>,
>>>>                                <&clock_peric0 SCLK_UART0>;
>>>>                       clock-names = "uart", "clk_uart_baud0";
>>>>                       status = "disabled";
>>>>               };
>>>>
>>>>               serial_1: serial@14c20000 {
>>>>                       compatible = "samsung,exynos4210-uart";
>>>>                       reg = <0x14c20000 0x100>;
>>>>                       interrupts = <0 456 0>;
>>>>                       clocks = <&clock_peric1 PCLK_UART1>,
>>>>                                <&clock_peric1 SCLK_UART1>;
>>>>                       clock-names = "uart", "clk_uart_baud0";
>>>>                       status = "disabled";
>>>>               };
>>>>
>>>>>> Then we could modify samsung_cmu_register_one() function by adding
>>>>>> the reg entry index or name argument. What do you think ?
>>>>
>>>> If there is more reasonable way to show the dependency between clock domains,
>>>> I will agree.
>>>
>>> The other option I mentioned is specifying all parent clocks of a given
>>> clock domain in its device node with clocks(/clock-names) properties.
>>> But it might be a bit hard to list all the clock domain dependencies
>>> this way
>>
>> Right, I agree that it is too hard.

I took a look at it again and it actually looks fairly easy to do.
In most cases we have just a few input clocks to each block, often
it's as little as 2 clocks. For instance, our CMU_TOP binding would
need to be updated to include following clk supplies:

 clock-controller@10030000 {
     compatible = "samsung,exynos5433-cmu-top";
     reg = <0x10030000 0x0c04>;
     clocks =   <&oscclk>,
		<&blk_mif CLK_FOUT_BUS_PLL>,
		<&blk_mif CLK_FOUT_MFC_PLL>,
		<&blk_cpif CLK_FOUT_MPHY_PLL>;

     clock-names = "oscclk",
		"bus_pll",
		"mfc_pll",
		"mphy_pll";
 };

Note the ISP_PLL and AUD_PLL already belong to CMU_TOP.

And here are related nodes:

 blk_mif: clock-controller@105b0000 {
     compatible = "samsung,exynos5433-cmu-mif";
     reg = <0x105b0000 0x100c>;
     clocks = ...
     clock-names = ...
 };

 blk_cpif: clock-controller@10fc0000 {
     compatible = "samsung,exynos5433-cmu-cpif";
     reg = <0x10fc0000 0x0c04>;
     clocks = ...
     clock-names = ...
 };

 oscclk: fixed-clock {
     compatible = "fixed-clock";
     clock-output-names = "oscclk";
 };


You don't need to change anything in the driver for now, please just add
such dependencies to the binding.  I hope there is no circular dependencies,
there generally shouldn't be if the blocks are modelled properly.

--
Thanks,
Sylwester
