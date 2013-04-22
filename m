Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3DVRKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 13:10:32 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63870 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3DVRKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 13:10:30 -0400
Message-ID: <51756F01.20408@samsung.com>
Date: Tue, 23 Apr 2013 02:10:25 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Andrew Morton'" <akpm@linuxfoundation.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, a.zummo@towertech.it,
        kgene.kim@samsung.com, thomas.ab@samsung.com, dianders@chromium.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Subject: Re: [PATCH] rtc: rtc-s3c: use clk_prepare_enable and clk_disable_unprepare
References: <1365517660-9322-1-git-send-email-gautam.vivek@samsung.com> <516535E4.5060308@samsung.com> <002e01ce366a$4c9f1390$e5dd3ab0$%han@samsung.com>
In-Reply-To: <002e01ce366a$4c9f1390$e5dd3ab0$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 13:09, Jingoo Han wrote:
> On Wednesday, April 10, 2013 6:50 PM, Sylwester Nawrocki wrote:
>> On 04/09/2013 04:27 PM, Vivek Gautam wrote:
>>> From: Thomas Abraham<thomas.abraham@linaro.org>
>>>
>>> Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
>>> calls as required by common clock framework.
>>>
>>> Signed-off-by: Thomas Abraham<thomas.abraham@linaro.org>
>>> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

>>
>> Thanks Vivek.
>>
>> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>
> CC'ed Andrew Morton
>
> It looks good.
> Reviewed-by: Jingoo Han<jg1.han@samsung.com>
>
>>
>>> ---
>>>
>>> The v1 of this patch is pretty old, but the change needs to be merged to
>>> avoid getting those needless WARN_ON() dumps on console.
>>>
>>> Changes from v1:
>>>   - Not using clk_disable_unprepare() at the end of s3c_rtc_probe(), since
>>>     this will unprepare the rtc clock which is again getting used in other
>>>     funtions later.
>>>   - Using clk_unprepare() at the remove() instead to fix things up.
>>>
>>>   drivers/rtc/rtc-s3c.c |    5 +++--
>>>   1 files changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
>>> index fb994e9..e3528c9 100644
>>> --- a/drivers/rtc/rtc-s3c.c
>>> +++ b/drivers/rtc/rtc-s3c.c
>>> @@ -430,6 +430,7 @@ static int s3c_rtc_remove(struct platform_device *dev)
>>>
>>>   	s3c_rtc_setaie(&dev->dev, 0);
>>>
>>> +	clk_unprepare(rtc_clk);
>>>   	rtc_clk = NULL;
>>>
>>>   	return 0;
>>> @@ -498,7 +499,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
>>>   		return ret;
>>>   	}
>>>
>>> -	clk_enable(rtc_clk);
>>> +	clk_prepare_enable(rtc_clk);
>>>
>>>   	/* check to see if everything is setup correctly */
>>>
>>> @@ -578,7 +579,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
>>>
>>>    err_nortc:
>>>   	s3c_rtc_enable(pdev, 0);
>>> -	clk_disable(rtc_clk);
>>> +	clk_disable_unprepare(rtc_clk);
>>>
>>>   	return ret;
>>>   }
