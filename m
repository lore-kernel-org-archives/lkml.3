Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3JJPYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:24:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49807 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab3JJPYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:24:17 -0400
Message-ID: <5256C686.6000301@ti.com>
Date: Thu, 10 Oct 2013 10:23:50 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH V6 02/15] ARM: OMAP2+: AM33XX: add lateinit hook for calling
 pm late init
References: <1381354144-7134-1-git-send-email-nm@ti.com> <1381361098-8283-1-git-send-email-nm@ti.com> <52563BD8.1060703@ti.com> <20131010133209.GA13105@kahuna> <5256C5D2.9030302@ti.com>
In-Reply-To: <5256C5D2.9030302@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 10:20 AM, Joel Fernandes wrote:
> On 10/10/2013 08:32 AM, Nishanth Menon wrote:
>> On 00:32-20131010, Joel Fernandes wrote:
>>> On 10/09/2013 06:24 PM, Nishanth Menon wrote:
>>>> Call OMAP2+ generic lateinit hook from AM specific late init hook.
>>>> This allows the generic late initializations such as cpufreq hooks
>>>> to be active.
>>>>
>>>> Cc: Benoit Cousson <bcousson@baylibre.com>
>>>> Cc: Kevin Hilman <khilman@deeprootsystems.com>
>>>> Cc: Paul Walmsley <paul@pwsan.com>
>>>> Cc: Tony Lindgren <tony@atomide.com>
>>>> Signed-off-by: Nishanth Menon <nm@ti.com>
>>>> ---
>>>>  arch/arm/mach-omap2/board-generic.c |    1 +
>>>>  arch/arm/mach-omap2/common.h        |    1 +
>>>>  arch/arm/mach-omap2/io.c            |    6 ++++++
>>>>  3 files changed, 8 insertions(+)
>>>>
>>>> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
>>>> index 87162e1..b474498 100644
>>>> --- a/arch/arm/mach-omap2/board-generic.c
>>>> +++ b/arch/arm/mach-omap2/board-generic.c
>>>> @@ -180,6 +180,7 @@ DT_MACHINE_START(AM33XX_DT, "Generic AM33XX (Flattened Device Tree)")
>>>>  	.init_irq	= omap_intc_of_init,
>>>>  	.handle_irq	= omap3_intc_handle_irq,
>>>>  	.init_machine	= omap_generic_init,
>>>> +	.init_late	= am33xx_init_late,
>>>
>>> Instead of adding a new a *_init_late function for every platform, perhaps
>>> better to just do:
>>> .init_late	= omap2_common_pm_late_init;
>>>
>>> since that's the only function you're calling.
>>>
>>> Later if more functions are added, then it can be wrapped around.
>>
>> And what benefit would that give us? we break consistency of functions
>> available in io.c, considering the work we have already done in
>> out-of-tree patches on ti-forks, we *do know* that there is more
>> incoming and has to be done anyways, I prefer having symmetric
>> functions and a placeholder that folks can add on to.
>>
> 
> Ok, sure if you think such placeholders are right way and there's more code
> later to be added to init_late callbacks.
> 
> Adding 6 lines of identical code for every platform seems redundant, I'd just
> define an omap_common_late_init for all platforms for now, and then fork off for
> the future differences. That way we save on LOC and readability in the header as
> well. Your call.

I see a function of that name already exists. I guess you can leave your patch
as is then and not have to do this.

regards,

-Joel

