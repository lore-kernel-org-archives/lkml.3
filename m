Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaDXKZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:25:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:15578 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbaDXKZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,918,1389772800"; 
   d="scan'208";a="498798155"
Message-ID: <5358E6A2.3020505@intel.com>
Date: Thu, 24 Apr 2014 18:25:38 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com> <20140418105354.GA29167@gmail.com> <53548008.3040504@intel.com> <20140422113545.GA14950@gmail.com> <CABPqkBTHv3U6L4fKOvsFcaWR8HcOEaqGGxRMRn-+O68a0BLCuA@mail.gmail.com> <20140424081408.GA7709@gmail.com>
In-Reply-To: <20140424081408.GA7709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 04:14 PM, Ingo Molnar wrote:
> 
> * Stephane Eranian <eranian@google.com> wrote:
> 
>>>> Most of the codes without comments are hardware specific codes. 
>>>> The corresponding contents in Intel uncore documents are big 
>>>> tables/lists, nothing tricky/interesting. I really don't know how 
>>>> to comment these code.
>>>
>>> Have a look at other PMU drivers, such as
>>> arch/x86/kernel/cpu/perf_event_intel_rapl.c, which begin with a
>>> general explanation attached below.
>>
>> I think a more useful modularization would be to split that huge 
>> file (perf_event_intel_uncore.c) into smaller files like we do for 
>> the core PMU. There is just too much stuff in this file for my own 
>> taste. Hard to navigate and I spend quite some time looking at it 
>> and modifying it!
>>
>> You could follow the model of the core PMU support files.
>> You'd have a "core" file with the common routines, and then
>> a file perf processor:
>>     - perf_event_intel_uncore.c
>>     - perf_event_intel_snbep_uncore.c
>>     - perf_event_intel_nhmex_uncore.c
>>     - perf_event_intel_ivt_uncore.c
>>     - ...
>>
>> Each processor specific module, would be a kernel module. The core 
>> could be one too. Note that this would not alleviate the need for 
>> some basic descriptions at the beginning of each file outlining the 
>> PMU boxes exported to a minimum.

Most of hardware specific codes in the Intel uncore driver are for SandyBridge/IvyBridge/Haswell. Uncore subsystem in these CPUs are similar. One module per CPU type means we have to duplicate lots of code. I don't think it's a good idea.

Regards
Yan, Zheng

> 
> This structure you outline sounds like a good first step, I like it.
> 
> To simplify this restructuring, initially we could even keep the core 
> uncore bits in the core (ha!), to not have module-on-module 
> dependencies.
> 
> Thanks,
> 
> 	Ingo
> 

