Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaCaLkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:40:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21868 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaCaLkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:40:08 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-41-5339540ede1e
Message-id: <53395408.9020709@samsung.com>
Date: Mon, 31 Mar 2014 13:39:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
 <1393870975-21020-1-git-send-email-s.nawrocki@samsung.com>
 <5331664E.2050008@samsung.com> <20140325225446.5762.15937@quantum>
In-reply-to: <20140325225446.5762.15937@quantum>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xy7p8IZbBBj3bxCzmHznHatH/ZiGr
	xYE/OxgtmhevZ7M42/SG3WLT42usFpd3zWGzuH2Z12LtkbvsFkuvX2SyeDrhIptF694j7BYz
	Jr9ks1g/4zWLA5/HmnlrGD1amnvYPC739TJ5bFrVyeZx59oeNo/9c9ewe2xeUu/Rt2UVo8fn
	TXIBnFFcNimpOZllqUX6dglcGQe3nmcqWChZsexNUgPjb+EuRk4OCQETiTMH2lghbDGJC/fW
	s4HYQgJLGSV6Ttd1MXIB2Z8YJS59/cQOkuAV0JLofH+dEcRmEVCVaH3xkAnEZhMwlOg92gcW
	FxWIkJg7cTMbRL2gxI/J91hAbBGBPIn2Wz3MIEOZBaYwSXx5OhGsSFggWuJb5zIWiG0nGCVW
	bmoEm8opYCDRfGEfM4jNLKAuMWneIihbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqaWJhcU
	J6XnGukVJ+YWl+al6yXn525ihETU1x2MS49ZHWIU4GBU4uHtmGgRLMSaWFZcmXuIUYKDWUmE
	95u/ZbAQb0piZVVqUX58UWlOavEhRiYOTqkGRhHriMW35bjdDgq9XbQ8g70ldOVSvYnxW65M
	aT9xX037cd62e9F8s2avfbBW7uq3P5wdUel6edynGtKO+oWrpKS9mVWkeWZ2N8uPzba3lQU6
	7Q7Pu12o/+3ocxc2nflx/Prz0nTkr019IyUbKvWEL6Y64qdTxVzjNJaUP+x787yiU1Y/f/xM
	R4mlOCPRUIu5qDgRAPmmmZeGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 25/03/14 23:54, Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2014-03-25 04:19:42)
>> > On 03/03/14 19:22, Sylwester Nawrocki wrote:
[...]
>>> > > diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt 
>>> > > b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>> > > index 7c52c29..eb8d547 100644
>>> > > --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>> > > +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>> > > @@ -115,3 +115,26 @@ clock signal, and a UART.
>>> > >    ("pll" and "pll-switched").
>>> > >  * The UART has its baud clock connected the external oscillator and its
>>> > >    register clock connected to the PLL clock (the "pll-switched" signal)
>>> > > +
>>> > > +==Assigned clock parents and rates==
>>> > > +
>>> > > +Some platforms require static configuration of (parts of) the clock controller
>>> > > +often determined by the board design. Such a configuration can be specified in
>>> > > +a clock consumer node through clock-parents and clock-rates DT properties.
>>> > > +The former should contain list of parent clocks in form of phandle and clock
>>> > > +specifier pairs, the latter the list of assigned clock frequency values
>>> > > +(one cell each).
>>> > > +
>>> > > +    uart@a000 {
>>> > > +        compatible = "fsl,imx-uart";
>>> > > +        reg = <0xa000 0x1000>;
>>> > > +        ...
>>> > > +        clocks = <&clkcon 0>, <&clkcon 3>;
>>> > > +        clock-names = "baud", "mux";
>>> > > +
>>> > > +        clock-parents = <0>, <&pll 1>;
>> > 
>> > I have some doubts here, i.e. the order in which clocks are being 
>> > configured may be important in some cases. Should the binding then be
>> > specifying that the clocks will be configured in a sequence exactly 
>> > as listed in the clock-parents property ?
>
> That's a good point, and I think we should re-examine the role of a DT
> binding for this purpose. From my limited experience with DT, it seems
> to be really bad at anything involving sequencing. It doesn't give us
> function pointers/callbacks in the way that the old board files used to.
>
> So I think the binding you proposed is still a good idea, but only for
> the very simple case. If your platform has some detailed integration
> requirements that have corner cases like you describe below, then this
> DT binding might not be a good place to put the info.
> 
> A platform that provides its own pm runtime backend could neatly manage
> this by having a call to pm_runtime_get deal with these integration
> details such that the driver does not have to be aware of them. (caveat:
> that assumes in the example below that the only thing you want to do is
> set up your clocks once and then never touch them again)

This sounds reasonable, my impression was also that devicetree might be 
not the best place to put such a sequencing information.

We would just provide a one-time configuration data, without an indication 
of how the configuration should be performed when there are multiple 
clocks listed. As an usual DT practice the order of configuration wouldn't
be defined by the binding.

--
Regards,
Sylwester
