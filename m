Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbaEGNeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:34:21 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:53096 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932919AbaEGNeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:34:18 -0400
Message-ID: <536A3654.20201@semaphore.gr>
Date: Wed, 07 May 2014 16:34:12 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>, Sekhar Nori <nsekhar@ti.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH v5 0/8] Introduce new cpufreq helper macros
References: <535AC247.3070907@semaphore.gr> <5369220A.3030207@semaphore.gr> <CAKohpo=3_7G+3bMF2CpWgZXvktdXBkCi4-tCxogwGcvvEEh18w@mail.gmail.com> <4469396.zveA7sC36d@vostro.rjw.lan>
In-Reply-To: <4469396.zveA7sC36d@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 07/05/2014 04:13 μμ, Rafael J. Wysocki wrote:
> On Wednesday, May 07, 2014 10:53:16 AM Viresh Kumar wrote:
>> On 6 May 2014 23:25, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>>> My bad. I'm sorry for this. :(
>>>
>>> Rafael,
>>> A solution could be to make cpufreq_next_valid an inline function in cpufreq.h,
>>> but as Viresh mentioned this would be very inefficient because of multiple copies.
>>
>> That statement was true when we didn't had this problem..
>>
>>> So, maybe it's better to revert the 2 patches that don't depend on CONFIG_CPU_FREQ:
>>>
>>> 4229e1c61a4a ("sh: clk: Use cpufreq_for_each_valid_entry macro for iteration") and
>>> 04ae58645afa ("irda: sh_sir: Use cpufreq_for_each_valid_entry macro for iteration").
>>
>> This doesn't look right. It can happen to some other drivers as well in future.
>> So, there are two solutions I can think of:
>> 1. move cpufreq_next_valid and rename it to __cpufreq_next_valid(). Also make it
>> inline. Then create two versions of cpufreq_next_valid(), one inlined (only when
>> CONFIG_CPU_FREQ=n) and other one in cpufreq.c (non- inlined)..
>>
>> But probably that would be called ugly by some people :)
>>
>> 2. Make cpufreq_next_valid() inline and forget about extra space it takes :)
>>
>> @Rafel: Let me know which one you like :)
> 
> 2.
> 
> 

Do you want me to resend the entire patch set or only patch 1/8?


Thanks,
Stratos
