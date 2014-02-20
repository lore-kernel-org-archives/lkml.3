Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaBTNjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:39:42 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:55542 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaBTNjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:39:40 -0500
X-AuditID: cbfec37b-b7f8f6d000007030-38-5306059af995
Message-id: <53060590.9090600@samsung.com>
Date: Thu, 20 Feb 2014 06:39:28 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.10 00/26] 3.10.31-stable review
References: <20140218224530.398913499@linuxfoundation.org>
 <53054C83.8000409@samsung.com> <5305AF24.4030503@huawei.com>
In-reply-to: <5305AF24.4030503@huawei.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9hX91ZrGzBBtu2a1jMWb+GzaJ58Xo2
	i8u75rBZfFh7isXi27TdjBZffzpYLNj4iNHiUd9bdgcOjxcLtzB77Jx1l92j5chbVo8TM36z
	eOyfu4bd4/MmuQC2KC6blNSczLLUIn27BK6MW6/62Qsu8lc8+nWIsYFxAU8XIyeHhICJxJFH
	/xkhbDGJC/fWs3UxcnEICSxjlGiYd4gFwullktj1ZSYzhLOBUeL85PnMIC28AloSi1//YAGx
	WQRUJfo3L2YDsdkE1CU+v97BDmILCchJNC1ZDVYvKhAh8ersRBaIXkGJH5PvAdkcHCICyhI9
	c5VB5jMLTGOSOHLgEdhJwgKmErOPNrFBzKmUOP/hK1gvJ9DeX0e/MYHYzALWEisnbWOEsOUl
	Nq95ywxRryzx5/IpJojXFCRW3HjDMoFRZBaS1bOQtM9C0r6AkXkVo1hpcXJBcVJ6aoWRXnFi
	bnFpXrpecn7uJkZIdFXvYLz71eYQowAHoxIPL8NVlmAh1sSy4srcQ4wSHMxKIrxbPrAGC/Gm
	JFZWpRblxxeV5qQWH2Jk4uCUamCMicp6ZCFulCBseuqg8vUFs7yv7LHW9OxyecX15mFx1F37
	fWc/nFNY3Bz2tbwv3W5ybNqv53bRD59EXH41WSGE4fzPucdk/iil97BdLk0yaV/5s9MkknP5
	x5uMcmc+K920fb7zVkqPYpMcg9jTkqczWSMmB2zMn/3ZTME+zvNUkq5aYlifRqcSS3FGoqEW
	c1FxIgAOYVrTjAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 12:30 AM, Xishi Qiu wrote:
> On 2014/2/20 8:29, Shuah Khan wrote:
>
>> On 02/18/2014 03:46 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.10.31 release.
>>> There are 26 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu Feb 20 22:45:20 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>      kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.31-rc1.gz
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Compile and boot tests passed on AMD system. Boot failed on Intel systems. I think the following changes are the suspect, so far by process of elimination - these two aren't in 3.12 and 3.13
>>
>> #    modified:   mm/hugetlb.c
>> #    modified:   mm/memory-failure.c
>>
>> However, my strong suspect is the following:
>>
>> Xishi Qiu <qiuxishi@huawei.com>
>>      mm: fix process accidentally killed by mce because of huge page migration
>>
>> I don't see how this could cause problems, none the less, I will test without these changes and let you know.
>>
>>
>> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>>      mm/memory-failure.c: fix memory leak in successful soft offlining
>>
>> I will test without these changes and let you know.
>>
>> -- Shuah
>>
>
> Hi Shuah
>
> I tested on my system, it boot successfully.
>
> hardware: Intel(R) Xeon(R) CPU E5-2420 0 @ 1.90GHz
> OS: v3.10.30 + the two patches
>
> Thanks,
> Xishi Qiu

Xishi,

I tested without your patch and still see the issue. My wild guess 
wasn't a good one :) I am starting git bisect now.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
