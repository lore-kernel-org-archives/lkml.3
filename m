Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaJUKJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:09:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63067 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaJUKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:09:18 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-5c-544630cb057a
Message-id: <544630CA.2000502@samsung.com>
Date: Tue, 21 Oct 2014 14:09:14 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
 <20141021094714.GR23531@worktop.programming.kicks-ass.net>
In-reply-to: <20141021094714.GR23531@worktop.programming.kicks-ass.net>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e/4Nd3TBm4hBvcOy1p8/dLBYjFn/Ro2
	iwkP29gtpm0Ut1jZ+YDV4s+uHUwWl3fNYbO4dGABk0XLvgtMFsd7DzBZLD5ym9li86apzBat
	PT/ZLX5seMzqwOfRsrncY+esu+weCzaVemxeoeWxaVUnm8e7c+fYPU7M+M3i0XTmKLPHx6e3
	WDze77vK5nFmwRF2j8+b5DxOtHxhDeCN4rJJSc3JLEst0rdL4MqYdFK6YCtHxaQTMg2MLexd
	jJwcEgImEkdvv4SyxSQu3FvP1sXIxSEksJRR4trVDhYIp5lJouvpWRaQKl4BLYlPH3Yygtgs
	AqoS+3s2soLYbAJ6Ev9mbWcDsUUFIiSurJnDCFEvKPFj8j2wXhEBTYmVbffBapgFTjFLbL8u
	C2ILC3hJvP7Rygix7ACjxP91J5lBEpwC7hI7P6xl6mLkAGrQk7h/UQuiV15i85q3zBMYBWYh
	WTELoWoWkqoFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MULi7esOxqXHrA4xCnAwKvHw
	RixxDRFiTSwrrsw9xCjBwawkwpsr7BYixJuSWFmVWpQfX1Sak1p8iJGJg1OqgVHd00E9ptZX
	9Yh8071FtlvEf8nW5QvPOTx549dwP9EzC8+kWhRNKCnznHP+UPCT6Udsqjf3HIvZmKQXPvkh
	57Utxzg9mHQU/6Vw7To1k29zxS6eOZ8ny50OsfZ96Hpv67PVJ5edcvvyvnCz2rFDc+VU7lw9
	/0pTiulgz+PdtfN+MW4r3c609KaVEktxRqKhFnNRcSIAZYJ99ZUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 01:47 PM, Peter Zijlstra wrote:
> On Mon, Oct 20, 2014 at 02:54:59PM +0400, Andrey Ryabinin wrote:
>>
>> UBSan uses compile-time instrumentation to catch undefined behavior (UB).
>> Compiler inserts code that perform certain kinds of
>> checks before operations that could cause UB.
>> If check fails (i.e. UB detected) __ubsan_handle_* function called.
>> to print error message.
>>
>> So the most of the work is done by compiler.
>> This patch just implements ubsan handlers printing errors.
>>
>> GCC supports this since 4.9, however upcoming GCC 5.0 has
>> more checkers implemented.
> 
> It might be useful if you've got a link to the relevant GCC
> documentation of this new shiny stuf.
> 

Documentation is very brief (look for fsanitize=undefined): https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
GCC 4.9.1 doc: https://gcc.gnu.org/onlinedocs/gcc-4.9.1/gcc/Debugging-Options.html

And there is an article which might be interesting: http://developerblog.redhat.com/2014/10/16/gcc-undefined-behavior-sanitizer-ubsan/



