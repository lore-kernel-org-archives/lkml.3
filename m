Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490Ab3IDIoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:44:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64198 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab3IDIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:44:21 -0400
Message-ID: <5226F2E2.3070202@linaro.org>
Date: Wed, 04 Sep 2013 10:44:18 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        sboyd@codeaurora.org, rob.herring@calxeda.com, olof@lixom.net,
        santosh.shilimkar@ti.com, grant.likely@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH] clocksource: em_sti: Set cpu_possible_mask to fix SMP
 broadcast
References: <20130904080151.24562.91334.sendpatchset@w520> <20130904083727.GE17329@verge.net.au>
In-Reply-To: <20130904083727.GE17329@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 10:37 AM, Simon Horman wrote:
> [ Droped johnstultz@linaro.org CC, the address seems to bounce

The address is john.stultz@linaro.org

>   Added Daniel Lezcano CC, I believe he handles clocksource these days ]

Right.

> On Wed, Sep 04, 2013 at 05:01:51PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Update the STI driver by setting cpu_possible_mask to make EMEV2
>> SMP work as expected together with the ARM broadcast timer.
>>
>> This breakage was introduced by:
>>
>> f7db706 ARM: 7674/1: smp: Avoid dummy clockevent being preferred over real hardware clock-event
>>
>> Without this fix SMP operation is broken on EMEV2 since no
>> broadcast timer interrupts trigger on the secondary CPU cores.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
> 
> Tested-by: Simon Horman <horms+renesas@verge.net.au>
> 
> I will let this sit for a few days to see if there is any further feedback.
> 
>> ---
>>
>>  Thanks to feedback from Stephen Boyd this is is a reworked version of:
>>  [PATCH] clocksource: em_sti: Adjust clock event rating to fix SMP broadcast
>>
>>  drivers/clocksource/em_sti.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- 0001/drivers/clocksource/em_sti.c
>> +++ work/drivers/clocksource/em_sti.c	2013-09-04 16:51:42.000000000 +0900
>> @@ -301,7 +301,7 @@ static void em_sti_register_clockevent(s
>>  	ced->name = dev_name(&p->pdev->dev);
>>  	ced->features = CLOCK_EVT_FEAT_ONESHOT;
>>  	ced->rating = 200;
>> -	ced->cpumask = cpumask_of(0);
>> +	ced->cpumask = cpu_possible_mask;
>>  	ced->set_next_event = em_sti_clock_event_next;
>>  	ced->set_mode = em_sti_clock_event_mode;
>>  
>>


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

