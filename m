Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbaC0PDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:03:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38976 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaC0PC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:02:58 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-1e-53343da04d91
Message-id: <53343D9C.6040605@samsung.com>
Date: Thu, 27 Mar 2014 16:02:52 +0100
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
 <77553409.zvN7VkNGe7@avalon> <53342E64.5060505@samsung.com>
 <46532903.ghnH4Us8Zz@avalon>
In-reply-to: <46532903.ghnH4Us8Zz@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e/4Fd0FtibBBtv+s1jMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu0XnxCXsFpseX2O1uLxrDpvF7cu8FmuP3GW3WHr9IpPF0wkX2Sxa
	9x5ht5gx+SWbxZKnHWwW62e8ZnEQ8Fgzbw2jR0tzD5vH5b5eJo/ZHTNZPTat6mTzuHNtD5vH
	/rlr2D02L6n36NuyitHj+I3tTB6fN8kFcEdx2aSk5mSWpRbp2yVwZTxefZW94K9Bxba9O1gb
	GL+odjFyckgImEj0rfnCAmGLSVy4t56ti5GLQ0hgKaPEvKYP7BDOJ0aJz5NvsYFU8QpoSUxq
	2c8EYrMIqEp0nlzFDGKzCRhK9B7tYwSxRQUiJOZO3AxVLyjxY/I9sA0iAhYSvYumM4IMZRZo
	YpZ4dbebFSQhLBAtsfLgF6htixklri35BjaJU0BTYse+j2DbmAV0JPa3TmODsOUlNq95yzyB
	UWAWkiWzkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZI9H3dwbj0mNUhRgEO
	RiUe3hlWJsFCrIllxZW5hxglOJiVRHhrTIBCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGI+GVz8z
	57G1jt7SxLgse9Up0YJ1/l0fNdqWLs/LyhCJKXbRemr7SOLWrWPN8yebKoscWl7BOSGwy+hX
	dCTL173S6T+OLebfuWpC4bW1VgePn3C5JTKxXMM3M6jPnPO8TZyc4pTfp8TbXTp9dllbfpO7
	PnW+zOwWV7WS58dvtp8R8Ww7kvT6rRJLcUaioRZzUXEiAOmyzHucAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/14 15:08, Laurent Pinchart wrote:
> On Thursday 27 March 2014 14:57:56 Sylwester Nawrocki wrote:
>> On 27/03/14 14:24, Laurent Pinchart wrote:
>>> On Thursday 27 March 2014 13:16:19 Sylwester Nawrocki wrote:
>>>> This function adds a helper function to configure clock parents and rates
>>>> as specified in clock-parents, clock-rates DT properties for a consumer
>>>> device and a call to it before driver is bound to a device.
>>>>
>>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> ---
>> [...]
>>>>  .../devicetree/bindings/clock/clock-bindings.txt   |   26 ++++++
>>>>  drivers/base/dd.c                                  |    7 ++
>>>>  drivers/clk/Makefile                               |    1 +
>>>>  drivers/clk/clk-conf.c                             |   87 ++++++++++++++
>>>>  drivers/clk/clk.c                                  |   10 ++-
>>>>  include/linux/clk/clk-conf.h                       |   19 +++++
>>>>  6 files changed, 149 insertions(+), 1 deletion(-)
>>>>  create mode 100644 drivers/clk/clk-conf.c
>>>>  create mode 100644 include/linux/clk/clk-conf.h
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>>> b/Documentation/devicetree/bindings/clock/clock-bindings.txt index
>>>> 7c52c29..b452f80 100644
>>>> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>>> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>>> @@ -115,3 +115,29 @@ clock signal, and a UART.
>>>>    ("pll" and "pll-switched").
>>>>  * The UART has its baud clock connected the external oscillator and its
>>>>    register clock connected to the PLL clock (the "pll-switched" signal)
>>>> +
>>>> +==Assigned clock parents and rates==
>>>> +
>>>> +Some platforms require static initial configuration of parts of the
>>>> clocks
>>>> +controller. Such a configuration can be specified in a clock consumer
>>>> node
>>>> +through clock-parents and clock-rates DT properties. The former should
>>>> contain
>>>> +a list of parent clocks in form of phandle and clock specifier pairs,
>>>> the
>>>> +latter the list of assigned clock frequency values (one cell each).
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
>>>> +    };
>>>> +
>>>> +In this example the pll is set as parent of "mux" clock and frequency of
>>>> "baud"
>>>> +clock is specified as 460800 Hz.
>>>
>>> I'm curious, what should happen when two devices have conflicting
>>> requirements ? If a different device required the <&clkcon 3> parent to
>>> be set to <&pll 2> for instance, who should win ? Shouldn't a warning be
>>> printed ?
>>
>> In general, the assumption is that the <&clkcon 3> clock would be used only
>> by the uart@a000 device.
> 
> OK. Removing the problem is a simple way to fix it :-) What about stating this 
> explicitly in the documentation then ? Maybe by prefixing your proposed 
> explanation below with something like
> 
> "Configuring a clock parent and rate through the device node that uses the 
> clock is only supported for clocks that have a single user."

Looks good, we could add it. Or perhaps something like:

"Configuring a clock parent and rate through the device node that uses the
 clock should be only done for clocks that have a single user. If a clock
 is shared and conflicting parent or rate configuration is specified in
 multiple consumer nodes a resulting configuration is undefined." ?

Not sure if it is acceptable to inject such an unpredictability to
the kernel from DT though. Might be more reasonable to go with
a clarification as you proposed.

>> If a clock is shared I'd say it shouldn't be put in a multiple consumer
>> device nodes. Instead it should be put in a clock provider node, as I was
>> trying to explain in the sentence below.
>>
>> A warning could be useful, but it could complicate the code. We would need,
>> for example, to store information about already configured clocks in a list
>> and scan it before actually altering any clock parent or rate.
> 
> I'm fine with implementing that later if needed, we can keep the initial 
> implementation simple.

OK.
>>>> +For clocks which are not directly connected to any consumer device
>>>> similarly
>>>> +clocks, clock-parents and/or clock-rates properties should be specified
>>>> in
>>>> +assigned-clocks subnode of a clock controller DT node.
>>>
>>> It might be that I'm not familiar enough with the clock framework, but
>>> this sounds unclear to me. I'm not sure what you mean exactly.
>>
>> Sorry about not being precise here, would something like below be more
>> clear ?
>>
>> "Configuration of common clocks, which affect multiple consumer devices
>> can be specified in a dedicated 'assigned-clocks' subnode of a clock
>> provider node, e.g.:
>>
>>     clkcon {
>>         ...
>>         #clock-cells = <1>;
>>
>>         assigned-clocks {
>>             clocks = <&clkcon 16>, <&clkcon 17>;
>>             clock-parents = <0>, <&clkcon 1>;
>>             clock-rates = <200000>;
>>         };
>>     };
>> "
> 
> That's clearer indeed. Can the parents and rates depend on the board, or on 
> the SoC only ? We might be getting dangerously close to specifying platform 
> configuration instead of describing the hardware. A real example might be nice 
> to support the discussion.

The clock parent and rates could be board specific, otherwise this API would
become much less useful. The configuration often depends on what external
devices are attached to an SoC.

I don't have a real life example for the "global" configuration of shared
clocks at the moment. I added this after seeing Tero's patches [1], maybe
he could talk about some real use cases (just realized I missed to Cc him.
fixing this mistake now).

>> Naturally it's this just an RFC, any critics or suggestions are welcome.:)

--
Regards,
Sylwester

[1] http://www.spinics.net/lists/linux-omap/msg103069.html
