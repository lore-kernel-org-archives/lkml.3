Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbaGYJhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:37:16 -0400
Received: from numascale.com ([213.162.240.84]:45472 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaGYJhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:37:14 -0400
Message-ID: <53D22533.9030401@numascale.com>
Date: Fri, 25 Jul 2014 17:36:51 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Hillf Danton <dhillf@gmail.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
        Steffen Persvold <sp@numascale.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.14] core onlining/hotplug regression
References: <53D20C2E.3070902@numascale.com> <alpine.DEB.2.10.1407251059130.23352@nanos>
In-Reply-To: <alpine.DEB.2.10.1407251059130.23352@nanos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 05:05 PM, Thomas Gleixner wrote:
> On Fri, 25 Jul 2014, Daniel J Blueman wrote:
>> On a larger x86 system with 1728 cores, 3.15(.6) asserts on
>> smpboot_thread_fn's td->cpu != smp_processor_id() consistently after ~1500
>> cores are online.
>>
>> Reverting the only directly related changes I could find [1,2] doesn't help.
>> Debugging indicates there is a race where the created thread is quickly
>> migrated to core 0 when this occurs, since smp_processor_id returns 0 in these
>> cases. Thomas introduced a thread parked state to fix related issues a year
>> back. Linux 3.14(.13) boots just nice.
>
> Weird. Commits [1,2] are definitely not the culprits.
>
>> Full boot output is at:
>> https://resources.numascale.com/linux-315-thread-mig.txt
>
> Not really helpful, as we don't see what causes it. We just see the
> wreckage.
>
>> Any theories so far? I'll start bisecting when I have full access to the
>> system again in a week and I'll do some more debugging with intermittent
>> access before then.
>
> One thing you could try is enabling tracing.
>
>      "ftrace=function ftrace_dump_on_oops"
>
> It'll take a looooong time to spill out the traces, but that should
> give us the root cause precisely.

Good trick. I'll get this early next week and we'll see what's up.

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
