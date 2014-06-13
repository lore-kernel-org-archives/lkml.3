Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaFMOar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:30:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24997 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaFMOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:30:45 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c3-539b0b11d6c1
Message-id: <539B0B10.5000005@samsung.com>
Date: Fri, 13 Jun 2014 16:30:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tero Kristo <t-kristo@ti.com>, sw0312.kim@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v5 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1397042790-10636-1-git-send-email-s.nawrocki@samsung.com>
 <1397042790-10636-3-git-send-email-s.nawrocki@samsung.com>
 <CAL_JsqKDJ_yFxFYnrTtmzMPoxO2rmypiujybwbhUh35y1LS-Mw@mail.gmail.com>
 <5347DF4D.5000005@samsung.com> <20140523013406.9521.82891@quantum>
In-reply-to: <20140523013406.9521.82891@quantum>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t/xq7qC3LODDS4fM7Z4cKuVyWL+kXOs
	Fv1vFrJaHPizg9GiefF6NouzTW/YLTonLmG32PT4GqvF5V1z2CxuX+a1WHvkLrvF0usXmSye
	TrjIZjFp7VRGi9a9R9gtvn/7xmbxd/smFosZk1+yWSx52sFmsX7GaxYHEY8189YwerQ097B5
	XO7rZfJ49nIyk8fOWXfZPWZ3zGT12LSqk83jzrU9bB77565h99i8pN6jt/kdm0f/XwOPvi2r
	GD2O39jO5PF5k1wAfxSXTUpqTmZZapG+XQJXRv8ztYI7dhX7ek8wNzBOMOhi5OSQEDCRePlr
	ARuELSZx4d56IJuLQ0hgKaPE94mfWSCcT4wS8xbOZwep4hXQkmhaf5IJxGYRUJWYdHEeC4jN
	JmAo0Xu0j7GLkYNDVCBC4vEFIYhyQYkfk++BlYgAtW470Aq2gFngMZvEjs9zwOqFBaIlNm0t
	hdjVzySxtPs4I0gDp4CBxPQ3K5hBbGYBdYlJ8xZB2fISm9e8ZZ7AKDALyY5ZSMpmISlbwMi8
	ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkir/sYFx8zOoQowAHoxIP74fqWcFCrIllxZW5
	hxglOJiVRHjvNQCFeFMSK6tSi/Lji0pzUosPMTJxcEo1MHYH+i5lNUldLeiV1c5SmGjzQ9zu
	4acJdWsnrGVon7cyUK304+aHP1e43Dzt8/oz+8GeD1Im2x0KN+xvda5cpTtXyW6h47p+iwMu
	j9jyyyVv9Oz0byp64scRwC0o/3XDi1Om8Xb+YhMOKHRmBWQpau7d/S1kc8kXoUdrd26+1seu
	fbnLSHCnjxJLcUaioRZzUXEiAC68TC7AAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/14 03:34, Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2014-04-11 05:25:49)
>>>> +==Assigned clock parents and rates==
>>>> +
>>>> +Some platforms require static initial configuration of parts of the clocks
>>>> +controller. Such a configuration can be specified in a clock consumer node
>>>> +through clock-parents and clock-rates DT properties. The former should
>>>> +contain a list of parent clocks in form of phandle and clock specifier pairs,
>>>> +the latter the list of assigned clock frequency values (one cell each).
>>>> +To skip setting parent or rate of a clock its corresponding entry should be
>>>> +set to 0, or can be omitted if it is not followed by any non-zero entry.
>>>> +
>>>> +    uart@a000 {
>>>> +        compatible = "fsl,imx-uart";
>>>> +        reg = <0xa000 0x1000>;
>>>> +        ...
>>>> +        clocks = <&clkcon 0>, <&clkcon 3>;
>>>> +        clock-names = "baud", "mux";
>>>> +
>>>> +        clock-parents = <0>, <&pll 1>;
>>>> +        clock-rates = <460800>;
>>>
>>> Is this the input frequency or serial baud rate? Looks like a baud
>>> rate, but the clock framework needs input (to the uart) frequency. I
>>> would say this should be clock-frequency and specify the max baud rate
>>> as is being done with i2c bindings. The uart driver should know how to
>>> convert between input clock freq and baud rate.
>>
>> This UART example is not quite representative for the issues I have been
>> trying to address with this patch set. There is a need to set (an initial)
>> input clock frequency. E.g. in case of multimedia devices there may be
>> a need to set clock parent and frequency of an input clock to multiple IP
>> blocks, so they are clocked synchronously and data is carried properly
>> across a whole processing chain. Thus there may not be even clock output
>> in an IP block, but still input clock needs to be set. IIUC there is
>> similar issue with audio, where it is difficult to calculate the clock
>> frequencies/determine parent clocks in individual drivers algorithmically.
>>
>>>> +    };
>>>> +
>>>> +In this example the pll is set as parent of "mux" clock and frequency 
>>>> of "baud"
>>>> +clock is specified as 460800 Hz.
>>>
>>> I don't really like clock-parents. The parent information is part of
>>> the clock source, not the consumer.
>>
>> I'm not sure we must always consider the parent information as property
>> of a clock source. If for example we expose a structure like below as
>> single clock object, supporting clock gating, parent and frequency
>> setting the parent setting is still accessible from within a device
>> driver.
> 
> The design of the ccf implementation certainly allows one to hide
> individually addressable/configurable clock nodes within a single struct
> clk. But should we? I have always maintained that a clock driver should
> enumerate clocks in the same way that the data sheet or technical
> reference manual states. I did make a recent exception[1], but that is
> going to be rolled back after the coordinated clock rate changes land in
> mainline.
> 
>> And clock parent selection may depend on a system configuration
>> not immediately obvious from within a single device driver perspective.
>>
>>                          MUX
>>                        ,-------.     DIVIDER      GATE
>> common clk source 1 -->|--.    |   ,--------.   ,--------.
>>                        |   \   |   |        |   |        |
>> common clk source 2 -->|-   '--|-->|        |-->|        |--> consumer
>>        ...             |       |   |        |   |        |
>> common clk source N -->|-      |   '--------'   '--------'
>>                        '-------'
>>
>>> We've somewhat decided against having every single clock defined in DT
>>> and rather only describe a clock controller with leaf clocks to
>>> devices. That is not a hard rule, but for complex clock trees that is
>>> the norm. Doing something like this will require all levels of the
>>> clock tree to be described. You may have multiple layers of parents
>>> that have to be configured correctly. How are you configuring the rest
>>> of the tree?
>>
>> I believe even clock controllers where clocks are represented as flat
>> array often describe the clock tree entirely by parenthood, the tree
>> structure is just not obvious from the DT binding.
>> In addition, there seems to be appearing more and more clock controller
>> DT bindings describing their clocks individually.
> 
> I've been discouraging these per-clock node bindings in favor of the
> per-controller node style.
> 
>>
>>>> +Configuring a clock's parent and rate through the device node that uses
>>>> +the clock can be done only for clocks that have a single user. Specifying
>>>> +conflicting parent or rate configuration in multiple consumer nodes for
>>>> +a shared clock is forbidden.
>>>> +
>>>> +Configuration of common clocks, which affect multiple consumer devices
>>>> +can be specified in a dedicated 'assigned-clocks' subnode of a clock
>>>> +provider node, e.g.:
>>>
>>> This seems like a work-around due to having clock-parents in the
>>> consumer node. If (I'm not convinced we should) we have a binding for
>>> parent config, it needs to be a single binding that works for both
>>> cases.
>>
>> When this issue was first raised during an ARM kernel summit it was
>> proposed to add 'assigned' prefix to DT properties for such bindings.
>>
> 
> Yes, I like the "assigned-" prefix.
> 
>> How about separate properties for the default clock configuration,
>> e.g. assigned-clocks/assigned-clock-parents/assigned-clock-rates ?
>> So a clock provider would look like:
>>
>>     clkcon {
>>         ...
>>         #clock-cells = <1>;
>>
>>         assigned-clocks = <&clkcon 16>, <&clkcon 17>;
>>         assigned-clock-parents = <0>, <&clkcon 1>;
>>         assigned-clock-rates = <200000>;
>>     };
>>
>> And a consumer device node:
>>
>>     uart@a000 {
>>         compatible = "fsl,imx-uart";
>>         reg = <0xa000 0x1000>;
>>         ...
>>         clocks = <&clkcon 0>;
>>         clock-names = "baud";
>>
>>         assigned-clocks = <&clkcon 3>, <&clkcon 0>;
>>         assigned-clock-parents = <&pll 1>;
>>         assigned-clock-rates = <0>, <460800>;
>> };
> 
> It looks like this idea was dropped for v6. Can we revisit it? Take a

Yeah, we discussed this internally and some ones where not too excited
about such new properties, so I tried implementation of the bindings which
Grant initially suggested.
Having separate properties like these has an advantage though that the
clocks configuration specification is separated and not mixed with
regular clock properties describing solely the clock connections.

> look at Tero's example implementation for OMAP using this binding:
> 
> http://www.spinics.net/lists/linux-omap/msg104705.html
> 
> There is a bogus "default-clocks" node made solely for storing this info
> within the OMAP PRCM clock provider node. This is basically faking a
> clock consumer. I think with the proposed solution above Tero could have
> avoided that node entirely and done the following:

OK, I'm going to prepare new version of this series with the altered
DT binding.

> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 649b5cd..e3ff1a7 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -145,6 +145,11 @@
>  			cm2_clocks: clocks {
>  				#address-cells = <1>;
>  				#size-cells = <0>;
> +
> +				assigned-clocks = <&abe_dpll_refclk_mux_ck>,
> +					<&dpll_usb_ck>, <&dpll_abe_ck>;
> +				assigned-clock-parents = <&sys_32k_ck>;
> +				assigned-clock-rates = <0>, <960000000>, <98304000>;
>  			};
>  
>  			cm2_clockdomains: clockdomains {
> 
> 
> Tero, what do you think?
> 
> Regards,
> Mike
> 
> [1] http://www.spinics.net/lists/cpufreq/msg10071.html

--
Regards,
Sylwester
