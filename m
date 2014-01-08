Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaAHLE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:04:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33836 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbaAHLEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:04:52 -0500
Message-ID: <52CD30B2.2080807@ti.com>
Date: Wed, 8 Jan 2014 16:34:18 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <devicetree@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        <tony@atomide.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        "Kristo, Tero" <t-kristo@ti.com>, <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <4812867.NuB3hNkV9d@wuerfel> <52CD2807.9000200@ti.com> <4840680.vVGZYBJBID@wuerfel>
In-Reply-To: <4840680.vVGZYBJBID@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 04:10 PM, Arnd Bergmann wrote:
> On Wednesday 08 January 2014 15:57:19 Roger Quadros wrote:
>> It is a clock gate defined like so in the DT clock data
>>
>> on OMAP4
>>         init_60m_fclk: init_60m_fclk {
>>                 #clock-cells = <0>;
>>                 compatible = "ti,divider-clock";
>>                 clocks = <&dpll_usb_m2_ck>;
>>                 reg = <0x0104>;
>>                 ti,dividers = <1>, <8>;
>>         };
>>
>> on OMAP5
>>         l3init_60m_fclk: l3init_60m_fclk {
>>                 #clock-cells = <0>;
>>                 compatible = "ti,divider-clock";
>>                 clocks = <&dpll_usb_m2_ck>;
>>                 reg = <0x0104>;
>>                 ti,dividers = <1>, <8>;
>>         };
>>
>> So you can see that it is the same thing with a different name.
> 
> Right, but init_60m_fclk is the name of the clock output of the
> divider here, which is /not/ what you should put in the "clock-names"
> property of the consumer. The clock input name should reflect what
> the clock is used for instead.

Ah, now I get it. :). I agree that the name should reflect the function.

Looking more closely, the driver doesn't enable/disable the init_60m_fclk but just
uses it to configure the parent of utmi_p1_gfclk which is a clock input to the
USB module. 

Based on this I would call it "refclk_int" for internal reference clock.

cheers,
-roger
