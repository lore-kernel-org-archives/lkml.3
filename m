Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaFROyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:54:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18095 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaFROyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:54:14 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-86-53a1a81306a9
Message-id: <53A1A6E5.6070200@samsung.com>
Date: Wed, 18 Jun 2014 18:49:09 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: get rid of hardcoded assumptions about kernel stack
 size
References: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
 <20140618143145.GH2186@arm.com>
In-reply-to: <20140618143145.GH2186@arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xq7rCKxYGG+xdbmLxflkPo8Wmx9dY
	LS7vmsNmcfsyr8X0Y3/ZLF5+PMHiwOaxZt4aRo+W5h42jzvX9rB5bF5S7/F5k1wAaxSXTUpq
	TmZZapG+XQJXRvcrr4IjnBX7p85nbmC8z97FyMkhIWAi8ezQIjYIW0ziwr31QDYXh5DAUkaJ
	233bWCCcZiaJk+t+sYJU8QpoSfyeuQmoioODRUBV4uBJEZAwm4CexL9Z28HCogIREo8vCEFU
	C0r8mHyPBcQWAaq+PO0II8hIZoFOJokjH28zgySEBUIkntxeAVYkJJAmceL3JLCDOAV0JJZd
	/gBWwwxk72+dxgZhy0tsXvOWeQKjwCwkO2YhKZuFpGwBI/MqRtHU0uSC4qT0XEO94sTc4tK8
	dL3k/NxNjJCg/rKDcfExq0OMAhyMSjy8H94uCBZiTSwrrsw9xCjBwawkwjt55sJgId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYzua7wU7mVusrVq3yFgc95jp/Xs0Gs6Wx+LMJzb7ibUVGhS4PxD
	O32V0crzYQ+nPr65zrQg1/jA+dBeoSsnwuV2BCy81VPw7/k89r7dEQGr5nSJS4ec8LpUGl+f
	NXttTt/RI1OErN9P2Jjw0lC/IXbi+3KdU5mPN0TMvOlSsDo2gufX7NnbpL2UWIozEg21mIuK
	EwGkJHNYSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/14 18:31, Will Deacon wrote:
> On Wed, Jun 18, 2014 at 02:50:22PM +0100, Andrey Ryabinin wrote:
>> Changing kernel stack size on arm is not as simple as it should be:
>> 1) THRED_SIZE macro doen't respect PAGE_SIZE and THREAD_SIZE_ORDER
> 
> THREAD_SIZE
> 
Yup, I just found some more typos in my commit message.
I'll fix them in update.

>> 2) stack size is hardcoded in get_thread_info macro
>>
>> This patch fixes it by caculating THREAD_SIZE and thread_info address
>> taking into account PAGE_SIZE and THREAD_SIZE_ORDER.
>>
>> Now changing stack size becomes simply changing THREAD_SIZE_ORDER.
> 
> Curious: is this just a cleanup, or are you actually running out of kernel
> stack on an ARM platform?
> 

It's actually both.
I'm working on address sanitizer for kernel [1]. Recently we started experiments with
stack instrumentation. Compiler inserts redzones around every variable on stack, so
we could detect accesses to such redzones and catch out-of-bound read/write bugs on stack variables.
Obviously stack is bloated in such kernel.
For mainline kernel it just a cleanup.


[1] https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel

> Will
> 

