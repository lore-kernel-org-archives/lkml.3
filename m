Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaAHKKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:10:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33818 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbaAHKKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:10:10 -0500
Message-ID: <52CD23E0.8030400@ti.com>
Date: Wed, 8 Jan 2014 15:39:36 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <bcousson@baylibre.com>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <1389161742-10533-2-git-send-email-rogerq@ti.com> <20140108090808.GB16313@earth.universe>
In-Reply-To: <20140108090808.GB16313@earth.universe>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Tero

Hi Sebastian,

On 01/08/2014 02:38 PM, Sebastian Reichel wrote:
> On Wed, Jan 08, 2014 at 11:45:38AM +0530, Roger Quadros wrote:
>> diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
>> index b381fa6..5635202 100644
>> --- a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
>> +++ b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
>> @@ -32,6 +32,10 @@ Optional properties:
>>  - single-ulpi-bypass: Must be present if the controller contains a single
>>    ULPI bypass control bit. e.g. OMAP3 silicon <= ES2.1
>>  
>> +- clocks: phandle to 60MHz functional clock to the USB Host module.
>> +
>> +- clock-names: must be "init_60m_fclk"
>> +
>>  Required properties if child node exists:
>>  
>>  - #address-cells: Must be 1
> 
> I have some questions:
> 
> What about the other clocks acquired in drivers/mfd/omap-usb-host.c? Shouldn't
> all of those be provided by via the DT phandle?
> 

All those clocks are identically named across the OMAP SoCs and are unique for each
SoC, so providing DT phandle for all of them is not required.

The init_60m_fclk was renamed to l3init_60m_fclk in OMAP5, and hence the need for
this binding.

> Should the clk_get be changed to of_clk_get()/of_clk_get_by_name() in the
> driver? This would potentially remove the need of the init_60m_fclk name.
> 

If we use of_clk_xxx() then we'll need to update DT nodes for OMAP4 and OMAP3 as
well to explicitly provide the clock phandle. For now we make use of the fact that
SoC clock data names the clock rightly i.e. "init_60m_fclk".

> $ grep clk_get drivers/mfd/omap-usb-host.c
>     omap->ehci_logic_fck = clk_get(dev, "ehci_logic_fck");
>     omap->utmi_p1_gfclk = clk_get(dev, "utmi_p1_gfclk");
>     omap->utmi_p2_gfclk = clk_get(dev, "utmi_p2_gfclk");
>     omap->xclk60mhsp1_ck = clk_get(dev, "xclk60mhsp1_ck");
>     omap->xclk60mhsp2_ck = clk_get(dev, "xclk60mhsp2_ck");
>     omap->init_60m_fclk = clk_get(dev, "init_60m_fclk");
>     omap->utmi_clk[i] = clk_get(dev, clkname);
>     omap->hsic480m_clk[i] = clk_get(dev, clkname);
>     omap->hsic60m_clk[i] = clk_get(dev, clkname);
> 

cheers,
-roger
