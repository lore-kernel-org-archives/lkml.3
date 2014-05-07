Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaEGWL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:11:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46277 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaEGWL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:11:27 -0400
Message-ID: <536AAF6A.3020207@ti.com>
Date: Wed, 7 May 2014 17:10:50 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/26] ARM: OMAP: dmtimer: Add comments on OMAP1 clock
 framework
References: <1398375849-6017-1-git-send-email-joelf@ti.com> <1398375849-6017-3-git-send-email-joelf@ti.com> <20140507152004.GC9502@atomide.com>
In-Reply-To: <20140507152004.GC9502@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 10:20 AM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [140424 14:44]:
>> OMAP1 doesn't support clock framework, add a comment where needed
>> and correct a FIXME.
> 
> This is at least a wrong comment, the original comment seems right
> to me.

Ok, I've no issues dropping this patch.

-Joel


> 
> Tony
>  
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  arch/arm/plat-omap/dmtimer.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
>> index ecd3f97..f5a674c 100644
>> --- a/arch/arm/plat-omap/dmtimer.c
>> +++ b/arch/arm/plat-omap/dmtimer.c
>> @@ -142,8 +142,7 @@ static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
>>  	int rc;
>>  
>>  	/*
>> -	 * FIXME: OMAP1 devices do not use the clock framework for dmtimers so
>> -	 * do not call clk_get() for these devices.
>> +	 * Do not call clk_get() for OMAP1 due to no clock framework support.
>>  	 */
>>  	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET)) {
>>  		timer->fclk = clk_get(&timer->pdev->dev, "fck");
>> @@ -461,6 +460,7 @@ int omap_dm_timer_stop(struct omap_dm_timer *timer)
>>  	if (unlikely(!timer))
>>  		return -EINVAL;
>>  
>> +	/* OMAP1 is not converted to clk framework so avoid clk_get_rate here */
>>  	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET))
>>  		rate = clk_get_rate(timer->fclk);
>>  
>> -- 
>> 1.7.9.5
>>

