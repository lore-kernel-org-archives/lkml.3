Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaC0N6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 09:58:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35191 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbaC0N6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 09:58:03 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-54-53342e68a344
Message-id: <53342E64.5060505@samsung.com>
Date: Thu, 27 Mar 2014 14:57:56 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org
Cc: mturquette@linaro.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, t.figa@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, m.szyprowski@samsung.com
Subject: Re: [PATCH RFC v3 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com>
 <1395922579-28547-3-git-send-email-s.nawrocki@samsung.com>
 <77553409.zvN7VkNGe7@avalon>
In-reply-to: <77553409.zvN7VkNGe7@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xq7oZeibBBr9PMlnMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu0XnxCXsFpseX2O1uLxrDpvF7cu8FmuP3GW3WHr9IpPF0wkX2Sxa
	9x5ht5gx+SWbxfoZr1kc+D3WzFvD6NHS3MPmcbmvl8ljdsdMVo9NqzrZPO5c28PmsX/uGnaP
	zUvqPfq2rGL0+LxJLoArissmJTUnsyy1SN8ugStj6r1mloJrChULN11jamC8IdHFyMkhIWAi
	MWH+cjYIW0ziwr31QDYXh5DAUkaJRTvbGCGcT4xAVbOYQap4BbQkmk9uYgGxWQRUJVpXngKz
	2QQMJXqP9jGC2KICERJzJ25mg6gXlPgx+R5YjYhAgsSa40uZQIYyC5xkkjh0q4sVJCEsEC2x
	8uAXdohtixgl3i14wQ6S4BTQlDg6swOsiFlAR2J/6zQ2CFteYvOat8wTGAVmIVkyC0nZLCRl
	CxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKERNrXHYxLj1kdYhTgYFTi4d1x3yhYiDWx
	rLgy9xCjBAezkgivr7JJsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG7g/TXXYnvj7gOqVey7kv
	2nVbX7vXlH3TqyZx72w06lp/uMxu7UTNe5yO36LbVA2bj/6xDt4zr8WJ1Sc1+Etkx0S/PY8F
	9haL5BlYuBixWR893h+j/+/Ut5u37jcr55br2Av8+iPL7ysgcO7sosiEPRnuzA/2LPme0OLK
	veAmr97ta1KaBxWVWIozEg21mIuKEwEwWi8ykgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 27/03/14 14:24, Laurent Pinchart wrote:
> On Thursday 27 March 2014 13:16:19 Sylwester Nawrocki wrote:
>> This function adds a helper function to configure clock parents and rates
>> as specified in clock-parents, clock-rates DT properties for a consumer
>> device and a call to it before driver is bound to a device.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
[...]
>> ---
>>  .../devicetree/bindings/clock/clock-bindings.txt   |   26 ++++++
>>  drivers/base/dd.c                                  |    7 ++
>>  drivers/clk/Makefile                               |    1 +
>>  drivers/clk/clk-conf.c                             |   87 +++++++++++++++++
>>  drivers/clk/clk.c                                  |   10 ++-
>>  include/linux/clk/clk-conf.h                       |   19 +++++
>>  6 files changed, 149 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/clk/clk-conf.c
>>  create mode 100644 include/linux/clk/clk-conf.h
>>
>> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>> b/Documentation/devicetree/bindings/clock/clock-bindings.txt index
>> 7c52c29..b452f80 100644
>> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>> @@ -115,3 +115,29 @@ clock signal, and a UART.
>>    ("pll" and "pll-switched").
>>  * The UART has its baud clock connected the external oscillator and its
>>    register clock connected to the PLL clock (the "pll-switched" signal)
>> +
>> +==Assigned clock parents and rates==
>> +
>> +Some platforms require static initial configuration of parts of the clocks
>> +controller. Such a configuration can be specified in a clock consumer node
>> +through clock-parents and clock-rates DT properties. The former should
>> contain
>> +a list of parent clocks in form of phandle and clock specifier pairs, the
>> +latter the list of assigned clock frequency values (one cell each).
>> +
>> +    uart@a000 {
>> +        compatible = "fsl,imx-uart";
>> +        reg = <0xa000 0x1000>;
>> +        ...
>> +        clocks = <&clkcon 0>, <&clkcon 3>;
>> +        clock-names = "baud", "mux";
>> +
>> +        clock-parents = <0>, <&pll 1>;
>> +        clock-rates = <460800>;
>> +    };
>> +
>> +In this example the pll is set as parent of "mux" clock and frequency of
>> "baud"
>> +clock is specified as 460800 Hz.
> 
> I'm curious, what should happen when two devices have conflicting requirements 
> ? If a different device required the <&clkcon 3> parent to be set to <&pll 2> 
> for instance, who should win ? Shouldn't a warning be printed ?

In general, the assumption is that the <&clkcon 3> clock would be used only
by the uart@a000 device. If a clock is shared I'd say it shouldn't be put
in a multiple consumer device nodes. Instead it should be put in a clock
provider node, as I was trying to explain in the sentence below.

A warning could be useful, but it could complicate the code. We would need,
for example, to store information about already configured clocks in a list and
scan it before actually altering any clock parent or rate.

>> +For clocks which are not directly connected to any consumer device
>> similarly
>> +clocks, clock-parents and/or clock-rates properties should be specified in
>> +assigned-clocks subnode of a clock controller DT node.
> 
> It might be that I'm not familiar enough with the clock framework, but this 
> sounds unclear to me. I'm not sure what you mean exactly.

Sorry about not being precise here, would something like below be more
clear ?

"Configuration of common clocks, which affect multiple consumer devices
can be specified in a dedicated 'assigned-clocks' subnode of a clock
provider node, e.g.:

    clkcon {
        ...
        #clock-cells = <1>;

        assigned-clocks {
            clocks = <&clkcon 16>, <&clkcon 17>;
            clock-parents = <0>, <&clkcon 1>;
            clock-rates = <200000>;
        };
    };	
"

Naturally it's this just an RFC, any critics or suggestions are welcome.:)

--
Regards,
Sylwester
