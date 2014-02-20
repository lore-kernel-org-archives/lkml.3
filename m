Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaBTRBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:01:44 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:56497 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbaBTRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:01:41 -0500
X-AuditID: cbfec37a-b7fc06d00000555a-6b-530634f41320
Message-id: <530634F2.3010600@samsung.com>
Date: Thu, 20 Feb 2014 10:01:38 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dirk.j.brandewie@intel.com
Cc: Xishi Qiu <qiuxishi@huawei.com>, linux-kernel@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.10 00/26] 3.10.31-stable review
References: <20140218224530.398913499@linuxfoundation.org>
 <53054C83.8000409@samsung.com> <5305AF24.4030503@huawei.com>
 <53060590.9090600@samsung.com>
In-reply-to: <53060590.9090600@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+wn+4XE7Zgg/4zOhZz1q9hszj+XNOi
	efF6NovLu+awWXxYe4rF4tu03YwWX386WCzY+IjR4lHfW3YHTo8XC7cwe+ycdZfdo+XIW1aP
	xXteMnmcmPGbxWP/3DXsHp83yQWwR3HZpKTmZJalFunbJXBlLNizga1glUjFqukP2BoYJwh0
	MXJySAiYSNx/vI8NwhaTuHBvPZDNxSEksIxR4vzvbiinl0liycevrBDOBkaJzobdzF2MHBy8
	AloST7c7gXSzCKhKvJp7hBXEZhNQl/j8egc7iC0kICfRtGQ1M4gtKhAh8ersRBYQm1dAUOLH
	5HtgtoiAv8TZ3asYQeYzC7QwSew5e54JJCEsYCox+2gT1BWzGCUW9awC28ApoC2xf3k72AZm
	AWuJlZO2MULY8hKb17xlhtisLPHn8ikmiN8UJFbceMMygVFkFpLls5C0z0LSvoCReRWjWGlx
	ckFxUnpqhaFecWJucWleul5yfu4mRkjEVe1gvPPV5hCjAAejEg/vCSm2YCHWxLLiytxDjBIc
	zEoivO4qQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MM00v6VapcZ32/fLp8fzoDf9eNuz6vvPT
	iW/JU4u0P904tEQ+5ufD6L3fu/7OUlRbZDmna/PU3LcCnHfeh3o99H0quGXP950FC32es87R
	z3t8acP3QyobZy5/bVZQe0+R6W8KQ0D6nGOLF2h+3VRWLsidbLnavbaMs+tJXozMoceZ01a8
	ai+q01JiKc5INNRiLipOBADpPPyBlgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 06:39 AM, Shuah Khan wrote:
> On 02/20/2014 12:30 AM, Xishi Qiu wrote:
>> On 2014/2/20 8:29, Shuah Khan wrote:
>>
>>> On 02/18/2014 03:46 PM, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 3.10.31 release.
>>>> There are 26 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Thu Feb 20 22:45:20 UTC 2014.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>
>>>> kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.31-rc1.gz
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>> Compile and boot tests passed on AMD system. Boot failed on Intel
>>> systems. I think the following changes are the suspect, so far by
>>> process of elimination - these two aren't in 3.12 and 3.13
>>>
>>> #    modified:   mm/hugetlb.c
>>> #    modified:   mm/memory-failure.c
>>>
>>> However, my strong suspect is the following:
>>>
>>> Xishi Qiu <qiuxishi@huawei.com>
>>>      mm: fix process accidentally killed by mce because of huge page
>>> migration
>>>
>>> I don't see how this could cause problems, none the less, I will test
>>> without these changes and let you know.
>>>
>>>
>>> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>>>      mm/memory-failure.c: fix memory leak in successful soft offlining
>>>
>>> I will test without these changes and let you know.
>>>
>>> -- Shuah
>>>
>>
>> Hi Shuah
>>
>> I tested on my system, it boot successfully.
>>
>> hardware: Intel(R) Xeon(R) CPU E5-2420 0 @ 1.90GHz
>> OS: v3.10.30 + the two patches
>>
>> Thanks,
>> Xishi Qiu
>
> Xishi,
>
> I tested without your patch and still see the issue. My wild guess
> wasn't a good one :) I am starting git bisect now.
>
> -- Shuah
>
>

ok I have it isolated to the following patch:

Dirk Brandewie <dirk.j.brandewie@intel.com>
     intel_pstate: Take core C0 time into account for core busy calculation

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 upstream.

Take non-idle time into account when calculating core busy time.
This ensures that intel_pstate will notice a decrease in load.

Boots just fine without this change.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
