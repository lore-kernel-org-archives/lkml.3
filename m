Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaGJOFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:05:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60599 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaGJOFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:05:14 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7c-53be9d98435f
Message-id: <53BE9C53.5090301@samsung.com>
Date: Thu, 10 Jul 2014 17:59:47 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>, Andi Kleen <andi@firstfloor.org>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kbuild <linux-kbuild@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, x86 maintainers <x86@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [RFC/PATCH RESEND -next 00/21] Address sanitizer for kernel
 (kasan) - dynamic memory error detector.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <53BDB1D6.1090605@intel.com> <8761j6nr53.fsf@tassilo.jf.intel.com>
 <CAOMGZ=Fmqg6MWyx3NygqVmYiqw=npkPQrO9ifhF489bq5Gxz4A@mail.gmail.com>
In-reply-to: <CAOMGZ=Fmqg6MWyx3NygqVmYiqw=npkPQrO9ifhF489bq5Gxz4A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHec/ZuWw1Oq0ZL0YXRlJIaZrQm1RoRBwSI1lmCFFLl0qb2tZG
	ptBqKmkRomlrWFne2JjYJuRtLRtDuwyz1EUNTTGni9TUvIC6cu6L337/h9/zfz48NC7o4gTT
	GZnXpYpMiUxE8jgffV19+3VPbOIDT+sYtPT6MYEqG00kcrgWKPR1/jdAM94hgEqGCylkuKcl
	UbNnAkOGoiECWUZcBFpua8FQb1sliQZN/wjk7uWjLx1VGMq39WCocNZHIJvh0yrVmDFU7XDj
	aNJThqMmSzmO+o1vKbT4coSIgWy+9j7JPmudBmyrfoBiqywqttrqxViLsYhkLTOlFFs80Yex
	k93dFPtOt8Rhf/Y9wtimmlvs9Oh3Djtl6ydZZ5WDYmctO84wybwjqVJZhlqqCD92iZe+8kKR
	befdsE45cA3ooIsBl4ZMFPQ2PicCvBX2DDaSxYBHC5haAA3z9UQgaDH4/q8e91t8JhQ2a8ZI
	P3OYEFjQMoz5mWTCoE/fvDYPYs7DjgceIuBvhotlgxw/C5l4OF7+ivKX4swwCXWFjtVA01sY
	Jfy2cjVw7DOAs+7blH+By4hhzQfTWhHO7INvCirIAO+ETaYJvAQw+nU39Os0/TqtCuBGECRV
	pWQrL6fJI8OUErlSlZkWlpIlt4DA8+daQG1ntB0wNBBt5I+3W8UCQqJW5sjtANK4SMj/VW4T
	C/ipkpybUkXWRYVKJlXaAUZzgzXAqDVvi3MP1dNccy7XXJGniU6uW/6xwevLFsYddp1bgB7r
	WFJuV3jE0QRC3dCtT0+Mit3+Z7euM0d3ME91IeRusiHJMOMUzkWuLBsGihJdo1dKnJsOWRJ8
	d9rUPvvJWFn86bO8duteZ0zp3J6k4GsndmU1CBMeCo/3hhpOMVYRR5kuiQjFFUrJf/t+MEva	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/14 01:59, Vegard Nossum wrote:
> On 9 July 2014 23:44, Andi Kleen <andi@firstfloor.org> wrote:
>> Dave Hansen <dave.hansen@intel.com> writes:
>>>
>>> You're also claiming that "KASAN is better than all of
>>
>> better as in finding more bugs, but surely not better as in
>> "do so with less overhead"
>>
>>> CONFIG_DEBUG_PAGEALLOC".  So should we just disallow (or hide)
>>> DEBUG_PAGEALLOC on kernels where KASAN is available?
>>
>> I don't think DEBUG_PAGEALLOC/SLUB debug and kasan really conflict.
>>
>> DEBUG_PAGEALLOC/SLUB is "much lower overhead but less bugs found".
>> KASAN is "slow but thorough" There are niches for both.
>>
>> But I could see KASAN eventually deprecating kmemcheck, which
>> is just incredible slow.
> 
> FWIW, I definitely agree with this -- if KASAN can do everything that
> kmemcheck can, it is no doubt the right way forward.
> 

AFAIK kmemcheck could catch reads of uninitialized memory.
KASAN can't do it now, but It should be possible to implementation.
There is such tool for userspace - https://code.google.com/p/memory-sanitizer/wiki/MemorySanitizer

However detection of reads of uninitialized  memory will require a different
shadow encoding. Therefore I think it would be better to make it as a separate feature, incompatible with kasan.



> 
> Vegard
> 

