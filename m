Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaEVLyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:54:12 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54077 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaEVLyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:54:11 -0400
Message-ID: <537DE56F.3040003@linaro.org>
Date: Thu, 22 May 2014 13:54:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Shinya Kuribayashi'" <shinya.kuribayashi.px@renesas.com>,
        "'Magnus Damm'" <damm@opensource.se>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Joe Perches'" <joe@perches.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] clocksource: em_sti: remove unnecessary OOM messages
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com> <002d01cf6384$a6dbcf90$f4936eb0$%han@samsung.com> <5379E177.2030707@linaro.org> <001a01cf757a$087b4530$1971cf90$%han@samsung.com>
In-Reply-To: <001a01cf757a$087b4530$1971cf90$%han@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 06:55 AM, Jingoo Han wrote:
> On Monday, May 19, 2014 7:48 PM, Daniel Lezcano wrote:
>> On 04/29/2014 10:26 AM, Jingoo Han wrote:
>>> The site-specific OOM messages are unnecessary, because they
>>> duplicate the MM subsystem generic OOM message.
>>
>> Are you sure the MM subsys display a message when an allocation fails ?
>>
>> There are multiple reasons an allocation can fail.
>
> (+cc Viresh Kumar, Laurent Pinchart, Dan Carpenter, Joe Perches,
>         Thierry Reding, Andrew Morton)
>
> There was a discussion about this in other threads. [1]
> Please refer to the following link. Thank you.
>
> [1] http://patchwork.ozlabs.org/patch/324158/

Ok, thanks for the pointer.



>>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>>> ---
>>>    drivers/clocksource/em_sti.c |    4 +---
>>>    1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
>>> index 9d17083..d0a7bd6 100644
>>> --- a/drivers/clocksource/em_sti.c
>>> +++ b/drivers/clocksource/em_sti.c
>>> @@ -318,10 +318,8 @@ static int em_sti_probe(struct platform_device *pdev)
>>>    	int irq;
>>>
>>>    	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
>>> -	if (p == NULL) {
>>> -		dev_err(&pdev->dev, "failed to allocate driver data\n");
>>> +	if (p == NULL)
>>>    		return -ENOMEM;
>>> -	}
>>>
>>>    	p->pdev = pdev;
>>>    	platform_set_drvdata(pdev, p);
>>>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

