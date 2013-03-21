Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab3CUOLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:11:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53902 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab3CUOLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:11:49 -0400
Message-ID: <514B1505.30409@ti.com>
Date: Thu, 21 Mar 2013 16:11:17 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rajendra Nayak <rnayak@ti.com>
CC: <tony@atomide.com>, <b-cousson@ti.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, "Menon, Nishanth" <nm@ti.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
References: <1363703220-4777-1-git-send-email-rogerq@ti.com> <1363703220-4777-2-git-send-email-rogerq@ti.com> <514B0650.5070406@ti.com> <514B10FE.1000805@ti.com> <514B1383.1070102@ti.com>
In-Reply-To: <514B1383.1070102@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 04:04 PM, Rajendra Nayak wrote:
> On Thursday 21 March 2013 07:24 PM, Roger Quadros wrote:
>> On 03/21/2013 03:08 PM, Rajendra Nayak wrote:
>>> []..
>>>
>>>> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
>>>> index 0274ff7..23f2064 100644
>>>> --- a/arch/arm/mach-omap2/board-generic.c
>>>> +++ b/arch/arm/mach-omap2/board-generic.c
>>>> @@ -158,7 +158,7 @@ DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
>>>>  	.init_irq	= omap_gic_of_init,
>>>>  	.init_machine	= omap_generic_init,
>>>>  	.init_late	= omap4430_init_late,
>>>> -	.init_time	= omap4_local_timer_init,
>>>> +	.init_time	= omap4_init_time,
>>>>  	.dt_compat	= omap4_boards_compat,
>>>>  	.restart	= omap44xx_restart,
>>>>  MACHINE_END
>>>
>>> []..
>>>> +#ifdef CONFIG_OF
>>>> +int __init omap4_clk_init_dt(void)
>>>> +{
>>>> +	struct device_node *np;
>>>> +
>>>> +	np = of_find_compatible_node(NULL, NULL, "ti,omap4-scrm");
>>>> +	if (np) {
>>>> +		scrm_data.clks = scrm_clks;
>>>> +		scrm_data.clk_num = ARRAY_SIZE(scrm_clks);
>>>> +		of_clk_add_provider(np, of_clk_src_onecell_get,	&scrm_data);
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>
>>> []..
>>>> +
>>>> +void __init omap4_init_time(void)
>>>> +{
>>>> +	omap4_clk_init_dt();
>>>> +	omap4_local_timer_init();
>>>> +}
>>>
>>> I guess you did all this because of_clk_add_provider() needs
>>> slab to be initialized. With the below patch[1], now clk inits
>>> happen within .init_timer already, so none of this would
>>> be needed.
>>>
>>> [1] http://www.spinics.net/lists/arm-kernel/msg231288.html
>>>
>>
>> Right. I can then call omap4_clk_init_dt() from within omap4xxx_clk_init().
>>
>> Any comments about the main subject? Does the approach look fine?
> 
> It looks fine, except for the fact that I was wondering if the clock
> provider needs to restrict itself to SCRM.
> Nishant Menon brought up a need for specifying the mpu clock source
> from within DT, to be able to use a generic cpufreq driver.
> It could be a provider (not specific to scrm, but having only scrm
> clocks for now) which we could add clocks as and when we see a need for
> them to be specified from DT.

OK, I will revise the patch to not make it SCRM specific.

> 
> Btw, you need to copy Paul Walmsley for any clock related patches as
> he is the OMAP clock maintainer.

OK. Thanks for letting know.

cheers,
-roger
