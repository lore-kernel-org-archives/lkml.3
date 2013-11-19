Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab3KSS5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:57:48 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:10339 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KSS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:57:44 -0500
X-AuditID: cbfec37c-b7fd86d00000670b-15-528bb4a6f3e9
Message-id: <528BB492.8090404@samsung.com>
Date: Tue, 19 Nov 2013 11:57:22 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Joe Perches <joe@perches.com>
Cc: len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] power: Replace printks with dev_* and pr_* routines
References: <1384886818-11861-1-git-send-email-shuah.kh@samsung.com>
 <1384887205.17783.40.camel@joe-AO722>
In-reply-to: <1384887205.17783.40.camel@joe-AO722>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9hP91lW7qDDBoOaVs0L17PZjH7/mMW
	i1lT9jJZXN41h83ic+8RRou7p46yWZw5fYnV4utPBwcOj52z7rJ7LN7zkslj/9w17B5fVl1j
	9thytZ3FY8Xq7+wenzfJBbBHcdmkpOZklqUW6dslcGV8nP+RueAEZ8XOq/3sDYxn2LsYOTkk
	BEwkJkz/CWWLSVy4t56ti5GLQ0hgGaPE57Z/7BBOL5NE0/k7jBDOJkaJoyc7wFp4BbQkji08
	xwpiswioSvTfeMUIYrMJqEt8fr0DrEZIQE6iaclqZhBbVCBC4ujqZ6wQvYISPybfY+li5OAQ
	EVCUuLuFHyTMLHCCUeJWLxuILSzgLfF24jI2iDE5EucuzwMbySlgJHHtYDMTRL21xMpJ2xgh
	bHmJzWveMkPUK0v8uXyKCWS8BND47autJjCKzEKyeBaS7llIuhcwMq9iFCstTi4oTkpPrTDW
	K07MLS7NS9dLzs/dxAiJsZodjPe+2hxiFOBgVOLhLVjUHSTEmlhWXJl7iFGCg1lJhLemHijE
	m5JYWZValB9fVJqTWnyIkYmDU6qBcemfj94Hi24ces90runE626b14dknjC+XC6WLbqufpr8
	zaOv/3XGp9p5Pvk7X7PSOGnvB/ZdlT1yP8Qb4+64TFX49GBW4uvJr7ZP+CFZtC8rWcTtWc3W
	ZxWxtVwF36eydx+feX6KgsP28rDJZUeLnV+8OVH548te1iW7psV+VWKLvGrT1TrHyVGJpTgj
	0VCLuag4EQBejI5JjwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 11:53 AM, Joe Perches wrote:
> On Tue, 2013-11-19 at 11:46 -0700, Shuah Khan wrote:
>> Replaced printks with dev_* and pr_* routines. Replacing printk in
>> __suspend_report_result() will require passing in struct device *
>> pointer from calling routines and this will require changes to
>> external interface suspend_report_result() which is used by several
>> drivers. Hence, this one instance is replaced by pr_err().
> []
>> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> []
>> @@ -1308,9 +1308,8 @@ int dpm_prepare(pm_message_t state)
>>   				error = 0;
>>   				continue;
>>   			}
>> -			printk(KERN_INFO "PM: Device %s not prepared "
>> -				"for power transition: code %d\n",
>> -				dev_name(dev), error);
>> +			dev_info("PM: not prepared for power transition: ",
>> +				 "code %d\n", error);
>
> Shuah, you have to make sure the files modified by
> your patches compile successfully before sending
> patches like this.
>
>

Oops. I did compile. Missed the warning. Sorry about that.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
