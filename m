Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3LBI2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:28:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:22048 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3LBI2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:28:11 -0500
Message-ID: <529C4492.6060203@atmel.com>
Date: Mon, 2 Dec 2013 09:28:02 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linus@narrativeteam.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: rtc-at91rm9200: Corrected alarm over day/month wrap:
References: <1384795254-11996-1-git-send-email-nicolas.ferre@atmel.com> <20131118143740.cdb5c0ee72b3d68e443afd66@linux-foundation.org>
In-Reply-To: <20131118143740.cdb5c0ee72b3d68e443afd66@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/11/2013 23:37, Andrew Morton :
> On Mon, 18 Nov 2013 18:20:54 +0100 Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>
>> From: Linus Pizunski <linus@narrativeteam.com>
>>
>> Update month and day of month to the alarm month/day instead
>> of current day/month when setting the RTC alarm mask.
>>
>> Signed-off-by: Linus Pizunski <linus@narrativeteam.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
> I changed this to signed-off-by, as you were on the patch delivery path.
>
>> --- a/drivers/rtc/rtc-at91rm9200.c
>> +++ b/drivers/rtc/rtc-at91rm9200.c
>> @@ -220,6 +220,8 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
>>
>>   	at91_alarm_year = tm.tm_year;
>>
>> +	tm.tm_mon = alrm->time.tm_mon;
>> +	tm.tm_mday = alrm->time.tm_mday;
>>   	tm.tm_hour = alrm->time.tm_hour;
>>   	tm.tm_min = alrm->time.tm_min;
>>   	tm.tm_sec = alrm->time.tm_sec;
>
> I queued this for 3.13.  Do we think it warrants a -stable backport?

(I am late, but it seems this one is not sent to Linus yet...)

Well, yes, we can tag this one for "-stable". The patch applies on 
nearly each kernel that I can think about (code is from 2.6.17-ish). But 
this patch applies with an offset...

Best regards,
-- 
Nicolas Ferre
