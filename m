Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaDOSlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:41:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44477 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbaDOSl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:41:29 -0400
Message-ID: <534D7D58.4050201@codeaurora.org>
Date: Tue, 15 Apr 2014 11:41:28 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: myungjoo.ham@samsung.com
CC: =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] PM / devfreq: Use freq_table for available_frequencies
References: <1368716.232331397543409452.JavaMail.weblogic@epv6ml06>
In-Reply-To: <1368716.232331397543409452.JavaMail.weblogic@epv6ml06>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 11:30 PM, 함명주 wrote:
>> On 04/14/2014 06:36 PM, 함명주 wrote:
>>>> MyungJoo/Kyungmin,
>>>>
>>>> Bump. Can we accept this patch please?
>>>>
>>>> -Saravana
>>>
>>> Nack.
>>>
>>> Please note that freq_table is also an optional value, which may
>>> be null.
>>
>> Ah, I saw that the max_freq would be zero if freq_table was NULL and I
>> assumed that it can't be NULL. But I see that the max_freq limit is not
>> applied if it's zero. Thanks for catching it.
>>
>>> Besides, please be aware that your code is under rcu_read_lock().
>>
>> Valid point. I was just trying to keep the diff simple. No one's really
>> going to be catting this file often when performance matters.
>>
>>>
>>>
>>> Cheers,
>>> MyungJoo.
>>>
>>> ps. I'll send a related patch (avoid accessing null but not-an-error
>>> pointer at other sysfs nodes). Thank you for letting me catch such bugs anyway.
>>
>> I can go ahead and do this myself if you don't mind.
> 
> No, we don't need it. It was a false alarm.
> Reading again, I've found that we've already made other sysfs nodes
> check if either freq_table is null or its size is 0.
> 
> So, we only need to look at this available_frequencies node now.
> 
> I'll add some notes on the ABI doc for available_frequencies soon.
> 

Ah, I misunderstood your previous email. I thought you Nack-ed my patch
and decided to send your own patch to replace mine. Ok, I'll fix up mine
and send it out.

-Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
