Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab3KSUAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:00:22 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:16543 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3KSUAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:00:18 -0500
X-AuditID: cbfec37d-b7f0e6d00000657c-06-528bc350859a
Message-id: <528BC34E.9010008@samsung.com>
Date: Tue, 19 Nov 2013 13:00:14 -0700
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
 <1384887205.17783.40.camel@joe-AO722> <528BB492.8090404@samsung.com>
 <1384888035.17783.45.camel@joe-AO722>
In-reply-to: <1384888035.17783.45.camel@joe-AO722>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9hX93Aw91BBjcPMFs0L17PZjH7/mMW
	i1lT9jJZXN41h83ic+8RRou7p46yWZw5fYnV4utPBwcOj52z7rJ7LN7zkslj/9w17B5fVl1j
	9thytZ3FY8Xq7+wenzfJBbBHcdmkpOZklqUW6dslcGXMOqpXsEigYuKTj2wNjD94uhg5OCQE
	TCSuLdTrYuQEMsUkLtxbz9bFyMUhJLCMUWJD9wl2CKeXSeLuy+9QziZGiWWtBxhBWngFtCQO
	TdnBBmKzCKhK7NuzgRnEZhNQl/j8egc7iC0kICfRtGQ1WFxUIELi6OpnrBC9ghI/Jt9jAblC
	REBR4u4WfpAws8AJRolbvWAjhQW8Jd5OXAZ10WZGiWdLnoLt5RQwkrh96QwLRIO1xMpJ2xgh
	bHmJzWveMkPsVZb4c/kUE8SXihLbV1tNYBSZhWTzLCTds5B0L2BkXsUoVlqcXFCclJ5aYaJX
	nJhbXJqXrpecn7uJERJhtTsY73+1OcQowMGoxMNbuKg7SIg1say4MvcQowQHs5IIb009UIg3
	JbGyKrUoP76oNCe1+BAjEwenVAPjhr7tIakvrzNmfFWb93dqmIupxRKboNqfMx8EVh4/eGYJ
	R1YE54fW0AcSvLnGfU5OSqwBHw50lQkeCSibLFLDJn5xkvY2rZC7obYPLt9adk8p2vSz0BqR
	5xvvPbZac+vFMZW1XWw/3c4tmnXNv4dn65uYD4wqfiZvjX2Cjj03eBYfWyY1//IMJZbijERD
	Leai4kQAFdrF544CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 12:07 PM, Joe Perches wrote:
> On Tue, 2013-11-19 at 11:57 -0700, Shuah Khan wrote:
>> On 11/19/2013 11:53 AM, Joe Perches wrote:
>>> On Tue, 2013-11-19 at 11:46 -0700, Shuah Khan wrote:
>>>> Replaced printks with dev_* and pr_* routines. Replacing printk in
>>>> __suspend_report_result() will require passing in struct device *
>>>> pointer from calling routines and this will require changes to
>>>> external interface suspend_report_result() which is used by several
>>>> drivers. Hence, this one instance is replaced by pr_err().
>>> []
>>>> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
>>> []
>>>> @@ -1308,9 +1308,8 @@ int dpm_prepare(pm_message_t state)
>>>>    				error = 0;
>>>>    				continue;
>>>>    			}
>>>> -			printk(KERN_INFO "PM: Device %s not prepared "
>>>> -				"for power transition: code %d\n",
>>>> -				dev_name(dev), error);
>>>> +			dev_info("PM: not prepared for power transition: ",
>>>> +				 "code %d\n", error);
>>>
>>> Shuah, you have to make sure the files modified by
>>> your patches compile successfully before sending
>>> patches like this.
>> Oops. I did compile. Missed the warning. Sorry about that.
>
> btw:
>
> When you're doing patches like this, not bugfixes,
> not something that's going to be applied to current
> or stable, please make them against -next and not
> against Linus' tree.

ok. Makes sense changes like this don't need to be rushed. They could 
use soak time in linux-next.

>
> Also, I would make the larger change that modifies
> all the drivers like I suggested.  What you've done
> I think is a half-measure and is incomplete.
>

I was a bit reluctant to change all the drivers since the original 
message didn't include device information. However, adding device 
information would make this message more useful.

I will re-do the patch to make the larger change.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
