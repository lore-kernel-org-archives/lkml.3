Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaDXKgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:36:10 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47383 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaDXKgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:36:02 -0400
MIME-Version: 1.0
In-Reply-To: <5358E6A2.3020505@intel.com>
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com>
	<20140418105354.GA29167@gmail.com>
	<53548008.3040504@intel.com>
	<20140422113545.GA14950@gmail.com>
	<CABPqkBTHv3U6L4fKOvsFcaWR8HcOEaqGGxRMRn-+O68a0BLCuA@mail.gmail.com>
	<20140424081408.GA7709@gmail.com>
	<5358E6A2.3020505@intel.com>
Date: Thu, 24 Apr 2014 12:36:01 +0200
Message-ID: <CABPqkBRihMr=+X_Gb5dSYfForTpGA6XZGfTHOA3PZNAHTJDPkg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 12:25 PM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 04/24/2014 04:14 PM, Ingo Molnar wrote:
>>
>> * Stephane Eranian <eranian@google.com> wrote:
>>
>>>>> Most of the codes without comments are hardware specific codes.
>>>>> The corresponding contents in Intel uncore documents are big
>>>>> tables/lists, nothing tricky/interesting. I really don't know how
>>>>> to comment these code.
>>>>
>>>> Have a look at other PMU drivers, such as
>>>> arch/x86/kernel/cpu/perf_event_intel_rapl.c, which begin with a
>>>> general explanation attached below.
>>>
>>> I think a more useful modularization would be to split that huge
>>> file (perf_event_intel_uncore.c) into smaller files like we do for
>>> the core PMU. There is just too much stuff in this file for my own
>>> taste. Hard to navigate and I spend quite some time looking at it
>>> and modifying it!
>>>
>>> You could follow the model of the core PMU support files.
>>> You'd have a "core" file with the common routines, and then
>>> a file perf processor:
>>>     - perf_event_intel_uncore.c
>>>     - perf_event_intel_snbep_uncore.c
>>>     - perf_event_intel_nhmex_uncore.c
>>>     - perf_event_intel_ivt_uncore.c
>>>     - ...
>>>
>>> Each processor specific module, would be a kernel module. The core
>>> could be one too. Note that this would not alleviate the need for
>>> some basic descriptions at the beginning of each file outlining the
>>> PMU boxes exported to a minimum.
>
> Most of hardware specific codes in the Intel uncore driver are for SandyBridge/IvyBridge/Haswell. Uncore subsystem in these CPUs are similar. One module per CPU type means we have to duplicate lots of code. I don't think it's a good idea.
>
Then, at least split nhm_ex from the rest. It is very big.

> Regards
> Yan, Zheng
>
>>
>> This structure you outline sounds like a good first step, I like it.
>>
>> To simplify this restructuring, initially we could even keep the core
>> uncore bits in the core (ha!), to not have module-on-module
>> dependencies.
>>
>> Thanks,
>>
>>       Ingo
>>
>
