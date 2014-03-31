Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaCaLkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:40:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14475 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaCaLkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:40:36 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-65-5339543118e8
Message-id: <5339542A.50502@samsung.com>
Date: Mon, 31 Mar 2014 13:40:26 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, t.figa@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, m.szyprowski@samsung.com, t-kristo@ti.com
Subject: Re: [PATCH RFC v3 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com>
 <46532903.ghnH4Us8Zz@avalon> <53343D9C.6040605@samsung.com>
 <5456863.skuFAcRA98@avalon>
In-reply-to: <5456863.skuFAcRA98@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e/4FV3DEMtgg4dHhCzmHznHatH/ZiGr
	xYE/OxgtmhevZ7M42/SG3aJz4hJ2i02Pr7FaXN41h83i9mVei7VH7rJbLL1+kcni6YSLbBat
	e4+wW8yY/JLNYsnTDjaL9TNeszgIeKyZt4bRo6W5h83jcl8vk8fsjpmsHptWdbJ53Lm2h81j
	/9w17B6bl9R79G1Zxehx/MZ2Jo/Pm+QCuKO4bFJSczLLUov07RK4Mnb8TCxYqlGx4vBD9gbG
	/3JdjJwcEgImEkvfP2CFsMUkLtxbz9bFyMUhJLCUUaL95nJGCOcTo8T763fZQap4BTQkVnVe
	YgaxWQRUJTpe7mMCsdkEDCV6j/YxgtiiAhEScyduZoOoF5T4MfkeC4gtImAh0btoOthQZoEm
	ZolXd7vBVgsLREusPPiFHWLbIkaJqS/ngyU4gbbdWdEJNolZQEdif+s0KFteYvOat8wTGAVm
	IVkyC0nZLCRlCxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKExN6XHYyLj1kdYhTgYFTi
	4X0w2SJYiDWxrLgy9xCjBAezkgjvN3/LYCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mi9rPbcs6
	mHXc+a38Ftc1+3K69uvMfjUv60quwd+I+GI3g1RjCT7Oea3/kvui+6wsU1iXrpT3NNC1Ndn3
	WvXjjw/RaXJhk+b2G3r49X/66FyXOW/JXXn5cxsbtzlrH030/8+neKprWdFJk4fOz6tDXqaV
	Mc/a+bLi/I99ITsbt2WLW8YdujRBiaU4I9FQi7moOBEA9aUygJsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 28/03/14 17:49, Laurent Pinchart wrote:
> On Thursday 27 March 2014 16:02:52 Sylwester Nawrocki wrote:
>> > On 27/03/14 15:08, Laurent Pinchart wrote:
>>> > > On Thursday 27 March 2014 14:57:56 Sylwester Nawrocki wrote:
>>>> > >> On 27/03/14 14:24, Laurent Pinchart wrote:
>>>>> > >>> On Thursday 27 March 2014 13:16:19 Sylwester Nawrocki wrote:
>>>>>> > >>>> This function adds a helper function to configure clock parents and
>>>>>> > >>>> rates as specified in clock-parents, clock-rates DT properties for a
>>>>>> > >>>> consumer device and a call to it before driver is bound to a device.
>>>>>> > >>>> 
>>>>>> > >>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>>>> > >>>> ---
>>>> > >> 
>>>> > >> [...]
>>>> > >> 
>>>>>> > >>>>  .../devicetree/bindings/clock/clock-bindings.txt   |   26 ++++++
>>>>>> > >>>>  drivers/base/dd.c                                  |    7 ++
>>>>>> > >>>>  drivers/clk/Makefile                               |    1 +
>>>>>> > >>>>  drivers/clk/clk-conf.c                             |   87 ++++++++++++
>>>>>> > >>>>  drivers/clk/clk.c                                  |   10 ++-
>>>>>> > >>>>  include/linux/clk/clk-conf.h                       |   19 +++++
>>>>>> > >>>>  6 files changed, 149 insertions(+), 1 deletion(-)
>>>>>> > >>>>  create mode 100644 drivers/clk/clk-conf.c
>>>>>> > >>>>  create mode 100644 include/linux/clk/clk-conf.h
>>>>>> > >>>> 
>>>>>> > >>>> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>>>>> > >>>> b/Documentation/devicetree/bindings/clock/clock-bindings.txt index
>>>>>> > >>>> 7c52c29..b452f80 100644
>>>>>> > >>>> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>>>>> > >>>> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>>>>> > >>>> @@ -115,3 +115,29 @@ clock signal, and a UART.
>>>>>> > >>>>    ("pll" and "pll-switched").
>>>>>> > >>>>  
>>>>>> > >>>>  * The UART has its baud clock connected the external oscillator and
>>>>>> > >>>>    its register clock connected to the PLL clock (the "pll-switched"
>>>>>> > >>>>    signal)
>>>>>> > >>>> 
>>>>>> > >>>> +
>>>>>> > >>>> +==Assigned clock parents and rates==
>>>>>> > >>>> +
>>>>>> > >>>> +Some platforms require static initial configuration of parts of the
>>>>>> > >>>> clocks
>>>>>> > >>>> +controller. Such a configuration can be specified in a clock consumer
>>>>>> > >>>> node
>>>>>> > >>>> +through clock-parents and clock-rates DT properties. The former should
>>>>>> > >>>> contain
>>>>>> > >>>> +a list of parent clocks in form of phandle and clock specifier pairs,
>>>>>> > >>>> the
>>>>>> > >>>> +latter the list of assigned clock frequency values (one cell each).
>>>>>> > >>>> +
>>>>>> > >>>> +    uart@a000 {
>>>>>> > >>>> +        compatible = "fsl,imx-uart";
>>>>>> > >>>> +        reg = <0xa000 0x1000>;
>>>>>> > >>>> +        ...
>>>>>> > >>>> +        clocks = <&clkcon 0>, <&clkcon 3>;
>>>>>> > >>>> +        clock-names = "baud", "mux";
>>>>>> > >>>> +
>>>>>> > >>>> +        clock-parents = <0>, <&pll 1>;
>>>>>> > >>>> +        clock-rates = <460800>;
>>>>>> > >>>> +    };
>>>>>> > >>>> +
>>>>>> > >>>> +In this example the pll is set as parent of "mux" clock and frequency
>>>>>> > >>>> of "baud"
>>>>>> > >>>> +clock is specified as 460800 Hz.
>>>>> > >>> 
>>>>> > >>> I'm curious, what should happen when two devices have conflicting
>>>>> > >>> requirements ? If a different device required the <&clkcon 3> parent to
>>>>> > >>> be set to <&pll 2> for instance, who should win ? Shouldn't a warning be
>>>>> > >>> printed ?
>>>> > >> 
>>>> > >> In general, the assumption is that the <&clkcon 3> clock would be used
>>>> > >> only by the uart@a000 device.
>>> > > 
>>> > > OK. Removing the problem is a simple way to fix it :-) What about stating
>>> > > this explicitly in the documentation then ? Maybe by prefixing your
>>> > > proposed explanation below with something like
>>> > > 
>>> > > "Configuring a clock parent and rate through the device node that uses the
>>> > > clock is only supported for clocks that have a single user."
>> > 
>> > Looks good, we could add it. Or perhaps something like:
>> > 
>> > "Configuring a clock parent and rate through the device node that uses the
>> >  clock should be only done for clocks that have a single user. If a clock
>> >  is shared and conflicting parent or rate configuration is specified in
>> >  multiple consumer nodes a resulting configuration is undefined." ?
>> > 
>> > Not sure if it is acceptable to inject such an unpredictability to the
>> > kernel from DT though. Might be more reasonable to go with a clarification
>> > as you proposed.
>
> I would go further and forbid it.
> 
> "Configuring a clock parent and rate through the device node that uses the
> clock can be done only for clocks that have a single user. Specifying 
> conflicting parent or rate configuration in multiple consumer nodes for a 
> shared clock is forbidden."

Sounds good to me, I'll add it in next version of the patch. Thanks.

--
Regards,
Sylwester
