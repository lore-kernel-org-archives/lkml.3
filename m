Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3BFSLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:11:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49752 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3BFSLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:11:17 -0500
Message-ID: <51129CC2.7040709@wwwdotorg.org>
Date: Wed, 06 Feb 2013 11:11:14 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Haojian Zhuang <haojian.zhuang@gmail.com>
CC: jonghwa3.lee@samsung.com, Venu Byravarasu <vbyravarasu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] rtc: Modify leap year test for more simpler way
References: <1360149775-19606-1-git-send-email-jonghwa3.lee@samsung.com> <D958900912E20642BCBC71664EFECE3E6E1B6C6A52@BGMAIL02.nvidia.com> <51124FF2.2070605@samsung.com> <CAN1soZwtchSj_idRCu=6Q5uxY8LfZ+HTOQU2Y72Cspbd49xeuw@mail.gmail.com>
In-Reply-To: <CAN1soZwtchSj_idRCu=6Q5uxY8LfZ+HTOQU2Y72Cspbd49xeuw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 06:00 AM, Haojian Zhuang wrote:
> On Wed, Feb 6, 2013 at 8:43 PM,  <jonghwa3.lee@samsung.com> wrote:
>> On 2013년 02월 06일 20:42, Venu Byravarasu wrote:
>>> By definition, leap year is one, which is a divisible by 4 & 400, excluding multiples of 100s.
>>> Hence I feel this patch is not correct.
>>
>> No, I think you might misunderstood the it's meaning. The former code checks
>> whether if it is multiple of 4 or not. Formal mathematical way to verify multiple of 4
>> is just checks the last two digits are multiple of 4. This '(!year % 4) && (year % 100)'
>> part does it. But with only that checking, it may miss the case of multiple of 400 which
>> is also multiple of 4. Then my modification checks in hexadecimal, whether if number
>> has any of 1st and 2nd bit with value 1. Because any number which has all bits above
>> the 3rd can be divided with 4(2^2).
>> (e.g. 44(0b101100) = 2^5+2^3+2^2 = 2^2(2^3 + 2 + 1))
>> So It does same things with less instructions.
> 
> I still can't understand your logic.
> 
> Please check whether 200 year is leap year.
> 
> 200(decimal) = 2b11001000
> 
> !(200 & 0x3) = 1 (Your condition said that 200 year is a leap year.)
> 
> According to this logic in below.
>  if year mod 4 = 0 and year mod 100 <> 0 or year mod 400 = 0, then
> it's a leap year.
> 
> This tells us that 200 year isn't a leap year because 200 mod 100 ==
> 0. So who is wrong?

The rule is: it's a leap year if divisible by 4, unless it's divisible
by 100, but actually also including years divisible by 400. So, the
current code is correct, and the patch is wrong.

http://en.wikipedia.org/wiki/Leap_year#Algorithm
