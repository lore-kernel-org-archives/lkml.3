Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbaCQNR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:17:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44773 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbaCQNR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:17:56 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b6-5326f600fb70
Message-id: <5326F5FD.5060302@samsung.com>
Date: Mon, 17 Mar 2014 14:17:49 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: mturquette@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: samsung: fixed compiler warning
 [-Wpointer-to-int-cast]
References: <1393382561-5388-1-git-send-email-pankaj.dubey@samsung.com>
 <53264E61.2010502@samsung.com>
In-reply-to: <53264E61.2010502@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xq7qM39SCDU4ZW2x6fI3V4vKuOWwW
	M87vY7J4OuEim8WirV/YHVg97lzbw+axeUm9R9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVM
	vtXJVLCHs2LJ6i+sDYyX2bsYOTkkBEwkjm+ZwAxhi0lcuLeerYuRi0NIYCmjxLK2WywQzmdG
	iRfH9jCBVPEKaElM678E1s0ioCrR/bqZEcRmE1CT+NzwiA3E5geqWdN0nQXEFhWIkJg7cTMb
	RK+gxI/J98DiIgLaEp2X77GCLGAWaGKUeL/jB1hCWCBYonlnB9gyIYEMiUO7X7KC2JxADZO+
	zQdbxixgLbFy0jYoW15i85q3zBMYBWch2TELSdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfm
	pesl5+duYoSE99cdjEuPWR1iFOBgVOLhnaCsFizEmlhWXJl7iFGCg1lJhNfpHVCINyWxsiq1
	KD++qDQntfgQIxMHp1QDY3bmDZ0FE79O/p3GtP7r5BCHOb9UKn04FCW7NVy+yBWbHa7YZsFb
	12Q2b+fpUkdnLWnF2TvENTLrrmaIWXUrl/rJJrsWczJ9Ob5gkeO6/Jdh8gfDU7x8AzS+RX+s
	5p+TJW6t0C+v9/WCe+Dy8iumMlxKV6c3rtjXvey22NpA4T2fQnM+c1UqsRRnJBpqMRcVJwIA
	nytweU0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 17.03.2014 02:22, Pankaj Dubey wrote:
> On 02/26/2014 11:42 AM, Pankaj Dubey wrote:
>> When compiled using ARM64 cross compiler, gcc complains as
>>
>> drivers/clk/samsung/clk.c:293:18:
>> warning: cast from pointer to integer of different size
>> [-Wpointer-to-int-cast]
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   drivers/clk/samsung/clk.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
>> index 91bec3e..59142ba 100644
>> --- a/drivers/clk/samsung/clk.c
>> +++ b/drivers/clk/samsung/clk.c
>> @@ -278,7 +278,7 @@ void __init samsung_clk_of_register_fixed_ext(
>>       for_each_matching_node_and_match(np, clk_matches, &match) {
>>           if (of_property_read_u32(np, "clock-frequency", &freq))
>>               continue;
>> -        fixed_rate_clk[(u32)match->data].fixed_rate = freq;
>> +        fixed_rate_clk[(unsigned long)match->data].fixed_rate = freq;
>>       }
>>       samsung_clk_register_fixed_rate(fixed_rate_clk, nr_fixed_rate_clk);
>>   }
>
> Gentle Ping.

Missed this patch, thanks. Applied for v3.15.

Best regards,
Tomasz
