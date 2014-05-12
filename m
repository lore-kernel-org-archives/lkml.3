Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaELHDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:03:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52888 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaELHD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:03:27 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-4b-53707238c8fd
Message-id: <53707132.9070806@samsung.com>
Date: Mon, 12 May 2014 10:58:58 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vladimir Murzin <murzin.v@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: memset: zero out upper bytes in r1
References: <1399273875-8403-1-git-send-email-a.ryabinin@samsung.com>
 <loom.20140508T095105-952@post.gmane.org>
 <loom.20140508T103032-725@post.gmane.org>
In-reply-to: <loom.20140508T103032-725@post.gmane.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xa7oWRQXBBg0fxCw2Pb7GanF51xw2
	i9uXeS22r93N7MDi0dLcw+axc9Zddo/NS+o9Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4vaSVpeAe
	X8Xf5m6WBsbb3F2MnBwSAiYSvT+PskDYYhIX7q1n62Lk4hASWMoosfPvLmYIp5FJYsmV1Uwg
	VbwCWhLP370BquLgYBFQldjbHwMSZhPQk/g3azsbiC0qECFxr/EwK0S5oMSPyfdYQMpFBDQk
	zrzhBwkzC8xklGhvkwOxhQVsJFaseM0KsWouo0Tvwttg4zkFzCR+zLaDqNeR2N86jQ3ClpfY
	vOYt8wRGgVlINsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCFh+2UH4+Jj
	VocYBTgYlXh4A7gKgoVYE8uKK3MPMUpwMCuJ8H70BwrxpiRWVqUW5ccXleakFh9iZOLglGpg
	5Li1+GzI2TUXrk0xOpabOYc9sifc3NsoRiv40Q+T4H/xwhoevbre3hblJsqq0S/OFWyf7Wnt
	MLF9uq6R3PfSMxmreGWVzDJPf/t+sW3ihP0GZ6oMWISf8b5MDlBj3jpt1aker82zheo7mcqb
	n2969MPguZTvhL3388WPX0jzXZr/b6L9NSl1JZbijERDLeai4kQA7EMhJTkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 12:38, Vladimir Murzin wrote:
> Vladimir Murzin <murzin.v <at> gmail.com> writes:
> 
>>
>> Andrey Ryabinin <a.ryabinin <at> samsung.com> writes:
>>
>>>
>>> memset doesn't work right for following example:
>>>
>>> 	signed char c = 0xF0;
>>> 	memset(addr, c, size);
>>>
>>> Variable c is signed, so after typcasting to int the value will be
> 0xFFFFFFF0.
>>> This value will be passed through r1 regitster to memset function.
>>> memset doesn't zero out upper bytes in r1, so memory will be filled
>>> with 0xFFFFFFF0 instead of expected 0xF0F0F0F0.
>>
>> It behaves the same as a generic implementation in lib/string.c, moreover
>> gcc built-in behaves the same. So it looks like expected behavior and POSIX
>> Programmer's Manual (man 3posix memset) explicitly says that "c" is
>> converted to unsigned char.
>>
>> Cheers
>> Vladimir
>>
>>
> 

Hi Vladimir.
Please, use reply to all next time, otherwise I might miss your mails.

> Sorry, had a bad coffee when posted it ;) It behaves /different/, but it is
> here for many years... 

Your are right, it's here for many years and wasn't noticed, probably because, there are no
such users, that call memset with not zero upper bytes in second argument. Though, I can't tell this
for sure, there are might be a few of such calls.
So this fix probably doesn't change anything for current kernel, however it might help to avoid problems in future.
Also, I think would be good to have the same behavior on different architectures (arm64/x86 works correctly
for example above).

> doesn't this change break something? iow, it possible
> that some user rely on this behavior...
> 

I don't think that such user exist, cause such user must know implementation details of memset
on ARM and rely on them.
If such user exist that's insane user and should be fixed.


> Vladimir
> 

