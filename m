Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbaGDNny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:43:54 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26055 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbaGDNnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:43:53 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-e1-53b6af967d66
Message-id: <53B6AE57.70307@samsung.com>
Date: Fri, 04 Jul 2014 17:38:31 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: get rid of hardcoded assumptions about kernel stack
 size
References: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
 <201407032224.28386.arnd@arndb.de> <53B6541B.6000702@samsung.com>
 <4429781.iuSvvPCxYj@wuerfel>
In-reply-to: <4429781.iuSvvPCxYj@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xq7rT1m8LNtj/UM3i76Rj7Bbvl/Uw
	Wmx6fI3V4vKuOWwWty/zWkw/9pfN4uXHEywO7B5r5q1h9Ghp7mHz+P1rEqPHnWt72Dw2L6n3
	+LxJLoAtissmJTUnsyy1SN8ugSvj0uNvjAX93BX7O5sZGxifcXQxcnJICJhIbFh9gRnCFpO4
	cG89G4gtJLCUUeLOOaYuRi4gu5lJ4u2672AJXgENidWNbUAJDg4WAVWJNS1hIGE2AT2Jf7O2
	g5WICkRIHOh7xgpRLijxY/I9FhBbREBRYuqLZ8wgM5kFHjFKtK38ApYQFgiReHJ7BQvEsuWM
	Eo39U8G6OQU0JT4eWQh2HbOAjsT+1mlsELa8xOY1b5knMArMQrJkFpKyWUjKFjAyr2IUTS1N
	LihOSs810itOzC0uzUvXS87P3cQICfavOxiXHrM6xCjAwajEw9vQsi1YiDWxrLgy9xCjBAez
	kgjvn1VAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwztghqmGSHPFBL2LD9TN+EKVuzLxSlnpHV
	fdXtdVphacqc096shQmB9/8s1q09/PL4gfcmt3Mf8ayWXJUoOOOi8ZGjs+qdEx/mP3nU5FuY
	+XLlTGnuWrVb80SW+bj9ZF6ts/RPbssWbf1qI3bV1wEzJbk0++JWXLjx+LhBxcXvG8Sl3Zts
	O3mUWIozEg21mIuKEwGv7K0dVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/14 14:27, Arnd Bergmann wrote:
> On Friday 04 July 2014 11:13:31 Andrey Ryabinin wrote:
>>>
>>> but I wonder if there is a way to avoid the extra include here, as it might also
>>> cause a general slowdown because of asm/memory.h getting pulled into more .c
>>> files. Would it be reasonable to hardcode PAGE_SIZE here?
>>>
>>
>> IMO it's a bug of iop13xx platform, that it includes "higlevel" linux/reboot.h
>> from a very "lowlevel" header mach/iop13xx.h. I think it should be fixed with a patch above.
>> Slowing down of kernel build for a few more seconds is not good enough reason for me to
>> hardcode PAGE_SIZE here.
> 
> I don't think we can pinpoint a specific header that is "wrong" here, the

That's just my opinion. Anyway, if this header needed only for declaring single enum
it worth to replace include with enum declaration.

> fundamental problem is that our header files are a bit messy when it comes
> to recursive inclusion and we'd be better off if we generally were a little
> more careful about including headers from other headers.
> 

That's why we need to remove reboot.h from iop13xx.h.
Are you going to send a proper formatted patch for that?

Speaking of asm/page.h, a lot of other architectures
also have it included in thread_info.h, so I would leave it there.


> It's also very hard to retroactively clean this up on a large scale.
> 
> 	Arnd
> 

