Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaAHK15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:27:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48560 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbaAHK1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:27:53 -0500
Message-ID: <52CD2807.9000200@ti.com>
Date: Wed, 8 Jan 2014 15:57:19 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <20140108090808.GB16313@earth.universe> <52CD23E0.8030400@ti.com> <4812867.NuB3hNkV9d@wuerfel>
In-Reply-To: <4812867.NuB3hNkV9d@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 03:49 PM, Arnd Bergmann wrote:
> On Wednesday 08 January 2014 15:39:36 Roger Quadros wrote:
>>> What about the other clocks acquired in drivers/mfd/omap-usb-host.c? Shouldn't
>>> all of those be provided by via the DT phandle?
>>>
>>
>> All those clocks are identically named across the OMAP SoCs and are unique for each
>> SoC, so providing DT phandle for all of them is not required.
>>
>> The init_60m_fclk was renamed to l3init_60m_fclk in OMAP5, and hence the need for
>> this binding.
> 
> What do you mean it was renamed? Is it a different version of the omap-usb-host
> device then?

I meant the clock gates name on the SoC was renamed. The omap-usb-host device version
is revised as well.

>>> Should the clk_get be changed to of_clk_get()/of_clk_get_by_name() in the
>>> driver? This would potentially remove the need of the init_60m_fclk name.
>>>
>>
>> If we use of_clk_xxx() then we'll need to update DT nodes for OMAP4 and OMAP3 as
>> well to explicitly provide the clock phandle. For now we make use of the fact that
>> SoC clock data names the clock rightly i.e. "init_60m_fclk".
> 
> I'm getting the feeling that init_60m_fclk is not the name of the clock input
> of the omap-usb-host device at all, but rather the name of a signal on the
> omap soc, which would not be an appropriate identifier for the binding.

It is a clock gate defined like so in the DT clock data

on OMAP4
        init_60m_fclk: init_60m_fclk {
                #clock-cells = <0>;
                compatible = "ti,divider-clock";
                clocks = <&dpll_usb_m2_ck>;
                reg = <0x0104>;
                ti,dividers = <1>, <8>;
        };

on OMAP5
        l3init_60m_fclk: l3init_60m_fclk {
                #clock-cells = <0>;
                compatible = "ti,divider-clock";
                clocks = <&dpll_usb_m2_ck>;
                reg = <0x0104>;
                ti,dividers = <1>, <8>;
        };

So you can see that it is the same thing with a different name.

cheers,
-roger
