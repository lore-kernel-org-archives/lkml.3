Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab3BGBQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:16:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29859 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3BGBQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:16:04 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7f7d6d000000f4e-94-51130051baf0
Content-transfer-encoding: 8BIT
Message-id: <5113004D.9050107@samsung.com>
Date: Thu, 07 Feb 2013 10:15:57 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] rtc: Modify leap year test for more simpler way
References: <1360149775-19606-1-git-send-email-jonghwa3.lee@samsung.com>
 <D958900912E20642BCBC71664EFECE3E6E1B6C6A52@BGMAIL02.nvidia.com>
 <51124FF2.2070605@samsung.com>
 <CAN1soZwtchSj_idRCu=6Q5uxY8LfZ+HTOQU2Y72Cspbd49xeuw@mail.gmail.com>
 <51129CC2.7040709@wwwdotorg.org>
In-reply-to: <51129CC2.7040709@wwwdotorg.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zTd1ABuFAg4l/xC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGnQV32Qta+CuuNG5lbGB8yt3FyMkhIWAisf34PGYIW0ziwr31
	bF2MXBxCAssYJf52zWLvYuQAK1pxJx8ivohRYvnThWwgDbwCghI/Jt9jAalhFpCXOHIpGyTM
	LKAuMWneImaI+i4mid8zNzFC1GtJXH41gQnEZhFQlfi7dT0riM0mICfxtukbI8gcUYEIiV/9
	HCBhEaDySc/+MYLMYRbYyiRx8+dTZpAaYQEXiQk7dSDmT2OS+NtyHWwOp4CuROPaLWAPSAh0
	s0vM3PqXHWKZgMS3yYdYIJ6Rldh0AOphSYmDK26wTGAUm4XknVkI78xC8s4CRuZVjKKpBckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGCHxILWDcWWDxSFGAQ5GJR7eG0uFAoVYE8uKK3MPMUpwMCuJ
	8GY/BQrxpiRWVqUW5ccXleakFh9iTAa6byKzlGhyPjBW80riDY0NjA0NLQ3NTC1NDUgTVhLn
	ZTz1JEBIID2xJDU7NbUgtQhmCxMHp1QD4yrpZ1r3PtVrFL02Mr7rHMYTWZxhFTNDk21CrPIO
	w6Y3S9foTT89zUrgnuWRyogVtik1yQeWbLffUK/nbctettdPviz6WHyZS72XEhOvdvSNxscn
	d2T3RZxaax2zWmLa9Ie3z+n57E2eM3NL9k+bKWY7ugJKxbqX3i162v3owPa1yuLP+xnilViK
	MxINtZiLihMBaTUlIssCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jAd1ABuFAg/NzOC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxp0Fd9kLWvgrrjRuZWxg
	fMrdxcjBISFgIrHiTn4XIyeQKSZx4d56ti5GLg4hgUWMEsufLmQDSfAKCEr8mHyPBaSeWUBe
	4silbJAws4C6xKR5i5gh6ruYJH7P3MQIUa8lcfnVBCYQm0VAVeLv1vWsIDabgJzE26ZvjCBz
	RAUiJH71c4CERYDKJz37xwgyh1lgK5PEzZ9PmUFqhAVcJCbs1IGYP41J4m/LdbA5nAK6Eo1r
	t7BNYBSYheS8WQjnzUJy3gJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwdH2TGoH48oG
	i0OMAhyMSjy8N5YKBQqxJpYVV+YeYpTgYFYS4c1+ChTiTUmsrEotyo8vKs1JLT7EmAz03ERm
	KdHkfGAiyCuJNzQ2MTOyNDIzNjE3NiZNWEmcl/HUkwAhgfTEktTs1NSC1CKYLUwcnFINjDvL
	mvI+hU4PalJWbd4/+e+Eg3tZl3yxnT9XOW31m8DHR1/7ZfBschPdeHj6c8ne5CutDpJTMs/1
	eYQcbPk6JUE3rd5x9/e/cQ2O6lIPmhJkXpvf3f1OdmGZpwHf3bSejZnNb5klld2Eojqj939Y
	0FW0U4Bt/b7eG5cDj1rwtKctygw5dPv0ViWW4oxEQy3mouJEANlDt2T6AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 02월 07일 03:11, Stephen Warren wrote:
> On 02/06/2013 06:00 AM, Haojian Zhuang wrote:
>> On Wed, Feb 6, 2013 at 8:43 PM,  <jonghwa3.lee@samsung.com> wrote:
>>> On 2013년 02월 06일 20:42, Venu Byravarasu wrote:
>>>> By definition, leap year is one, which is a divisible by 4 & 400, excluding multiples of 100s.
>>>> Hence I feel this patch is not correct.
>>>
>>> No, I think you might misunderstood the it's meaning. The former code checks
>>> whether if it is multiple of 4 or not. Formal mathematical way to verify multiple of 4
>>> is just checks the last two digits are multiple of 4. This '(!year % 4) && (year % 100)'
>>> part does it. But with only that checking, it may miss the case of multiple of 400 which
>>> is also multiple of 4. Then my modification checks in hexadecimal, whether if number
>>> has any of 1st and 2nd bit with value 1. Because any number which has all bits above
>>> the 3rd can be divided with 4(2^2).
>>> (e.g. 44(0b101100) = 2^5+2^3+2^2 = 2^2(2^3 + 2 + 1))
>>> So It does same things with less instructions.
>>
>> I still can't understand your logic.
>>
>> Please check whether 200 year is leap year.
>>
>> 200(decimal) = 2b11001000
>>
>> !(200 & 0x3) = 1 (Your condition said that 200 year is a leap year.)
>>
>> According to this logic in below.
>>  if year mod 4 = 0 and year mod 100 <> 0 or year mod 400 = 0, then
>> it's a leap year.
>>
>> This tells us that 200 year isn't a leap year because 200 mod 100 ==
>> 0. So who is wrong?
> 
> The rule is: it's a leap year if divisible by 4, unless it's divisible
> by 100, but actually also including years divisible by 400. So, the
> current code is correct, and the patch is wrong.
> 

Sorry, I was wrong. I didn't know the definition of leap year not including
multiple of 4. Sorry for making noise.

Thanks,
Jonghwa


> http://en.wikipedia.org/wiki/Leap_year#Algorithm
> 
