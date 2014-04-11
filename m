Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbaDKMZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:25:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48173 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbaDKMZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:25:56 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-6b-5347df5130f6
Message-id: <5347DF4D.5000005@samsung.com>
Date: Fri, 11 Apr 2014 14:25:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
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
In-reply-to: <CAL_JsqKDJ_yFxFYnrTtmzMPoxO2rmypiujybwbhUh35y1LS-Mw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xK7qB992DDd6eV7J4cKuVyWL+kXOs
	Fv1vFrJaHPizg9GiefF6NouzTW/YLTonLmG32PT4GqvF5V1z2CxuX+a1WHvkLrvF0usXmSye
	TrjIZjFp7VRGi9a9R9gtvn/7xmbxd/smFosZk1+yWSx52sFmsX7GaxYHEY8189YwerQ097B5
	XO7rZfJ49nIyk8fOWXfZPWZ3zGT12LSqk83jzrU9bB77565h99i8pN6jt/kdm0f/XwOPvi2r
	GD2O39jO5PF5k1wAfxSXTUpqTmZZapG+XQJXxuO3C1gKLllU/J30iKWBsV+ri5GTQ0LARGLZ
	qadsELaYxIV764FsLg4hgaWMEu92X2GBcD4xSizaMJEdpIpXQEtizeUPrCA2i4CqRMvxN0wg
	NpuAoUTv0T5GEFtUIELiXuNhVoh6QYkfk++xgNgiAuoS35YfB9vALPCCTeL1z3agZg4OYYFo
	iU1bSyGWnWKUeDLlCVgzp0CwxIMdt8CamQV0JPa3TmODsOUlNq95yzyBUWAWkh2zkJTNQlK2
	gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIJH/dwbj0mNUhRgEORiUe3gOX3IKFWBPL
	iitzDzFKcDArifBuuuoeLMSbklhZlVqUH19UmpNafIiRiYNTqoFx3bbXjMGesUYzjnKxLWFj
	/fGvUSI3ketbbanGzJTn+wRUtJIXlQgk8tQINP+N3nHm32zLp0n759wr3OB0+nuZuOW5pJip
	j+50iUWmdXxTfO4y0WizT2riotedlVZHn5ovc00WVzOrF/wTdfKavodx1qpjU38e3WJtZTW7
	lsOSbTmv7NN3c5qVWIozEg21mIuKEwEeqjFtwgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/14 18:04, Rob Herring wrote:
> On Wed, Apr 9, 2014 at 6:26 AM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> This patch adds a helper function to configure clock parents and
>> rates as specified in clock-parents, clock-rates DT properties
>> for a consumer device and a call to it before driver is bound to
>> a device.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
[...]
>> ---
>>  .../devicetree/bindings/clock/clock-bindings.txt   |   44 ++++++++++
>>  drivers/base/platform.c                            |    5 ++
>>  drivers/clk/Makefile                               |    3 +
>>  drivers/clk/clk-conf.c                             |   85 ++++++++++++++++++++
>>  drivers/clk/clk.c                                  |   12 ++-
>>  include/linux/clk/clk-conf.h                       |   19 +++++
>>  6 files changed, 167 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/clk/clk-conf.c
>>  create mode 100644 include/linux/clk/clk-conf.h
>>
>> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>> index 700e7aa..93513fc 100644
>> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>> @@ -132,3 +132,47 @@ clock signal, and a UART.
>>    ("pll" and "pll-switched").
>>  * The UART has its baud clock connected the external oscillator and its
>>    register clock connected to the PLL clock (the "pll-switched" signal)
>> +
>> +==Assigned clock parents and rates==
>> +
>> +Some platforms require static initial configuration of parts of the clocks
>> +controller. Such a configuration can be specified in a clock consumer node
>> +through clock-parents and clock-rates DT properties. The former should
>> +contain a list of parent clocks in form of phandle and clock specifier pairs,
>> +the latter the list of assigned clock frequency values (one cell each).
>> +To skip setting parent or rate of a clock its corresponding entry should be
>> +set to 0, or can be omitted if it is not followed by any non-zero entry.
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
> 
> Is this the input frequency or serial baud rate? Looks like a baud
> rate, but the clock framework needs input (to the uart) frequency. I
> would say this should be clock-frequency and specify the max baud rate
> as is being done with i2c bindings. The uart driver should know how to
> convert between input clock freq and baud rate.

This UART example is not quite representative for the issues I have been
trying to address with this patch set. There is a need to set (an initial)
input clock frequency. E.g. in case of multimedia devices there may be
a need to set clock parent and frequency of an input clock to multiple IP
blocks, so they are clocked synchronously and data is carried properly
across a whole processing chain. Thus there may not be even clock output
in an IP block, but still input clock needs to be set. IIUC there is
similar issue with audio, where it is difficult to calculate the clock
frequencies/determine parent clocks in individual drivers algorithmically.

>> +    };
>> +
>> +In this example the pll is set as parent of "mux" clock and frequency 
>> of "baud"
>> +clock is specified as 460800 Hz.
> 
> I don't really like clock-parents. The parent information is part of
> the clock source, not the consumer.

I'm not sure we must always consider the parent information as property
of a clock source. If for example we expose a structure like below as
single clock object, supporting clock gating, parent and frequency
setting the parent setting is still accessible from within a device
driver. And clock parent selection may depend on a system configuration
not immediately obvious from within a single device driver perspective.

                         MUX
                       ,-------.     DIVIDER      GATE
common clk source 1 -->|--.    |   ,--------.   ,--------.
                       |   \   |   |        |   |        |
common clk source 2 -->|-   '--|-->|        |-->|        |--> consumer
       ...             |       |   |        |   |        |
common clk source N -->|-      |   '--------'   '--------'
                       '-------'

> We've somewhat decided against having every single clock defined in DT
> and rather only describe a clock controller with leaf clocks to
> devices. That is not a hard rule, but for complex clock trees that is
> the norm. Doing something like this will require all levels of the
> clock tree to be described. You may have multiple layers of parents
> that have to be configured correctly. How are you configuring the rest
> of the tree?

I believe even clock controllers where clocks are represented as flat
array often describe the clock tree entirely by parenthood, the tree
structure is just not obvious from the DT binding.
In addition, there seems to be appearing more and more clock controller
DT bindings describing their clocks individually.

>> +Configuring a clock's parent and rate through the device node that uses
>> +the clock can be done only for clocks that have a single user. Specifying
>> +conflicting parent or rate configuration in multiple consumer nodes for
>> +a shared clock is forbidden.
>> +
>> +Configuration of common clocks, which affect multiple consumer devices
>> +can be specified in a dedicated 'assigned-clocks' subnode of a clock
>> +provider node, e.g.:
> 
> This seems like a work-around due to having clock-parents in the
> consumer node. If (I'm not convinced we should) we have a binding for
> parent config, it needs to be a single binding that works for both
> cases.

When this issue was first raised during an ARM kernel summit it was
proposed to add 'assigned' prefix to DT properties for such bindings.

How about separate properties for the default clock configuration,
e.g. assigned-clocks/assigned-clock-parents/assigned-clock-rates ?
So a clock provider would look like:

    clkcon {
        ...
        #clock-cells = <1>;

        assigned-clocks = <&clkcon 16>, <&clkcon 17>;
        assigned-clock-parents = <0>, <&clkcon 1>;
        assigned-clock-rates = <200000>;
    };

And a consumer device node:

    uart@a000 {
        compatible = "fsl,imx-uart";
        reg = <0xa000 0x1000>;
        ...
        clocks = <&clkcon 0>;
        clock-names = "baud";

        assigned-clocks = <&clkcon 3>, <&clkcon 0>;
        assigned-clock-parents = <&pll 1>;
        assigned-clock-rates = <0>, <460800>;
};

?
>> +
>> +    clkcon {
>> +        ...
>> +        #clock-cells = <1>;
>> +
>> +        assigned-clocks {
>> +            clocks = <&clkcon 16>, <&clkcon 17>;
>> +            clock-parents = <0>, <&clkcon 1>;
>> +            clock-rates = <200000>;
>> +        };
>> +    };

--
Thanks,
Sylwester
