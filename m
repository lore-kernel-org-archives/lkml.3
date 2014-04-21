Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaDUCTE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 22:19:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:48860 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaDUCTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 22:19:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,895,1389772800"; 
   d="scan'208";a="516457808"
Message-ID: <53548008.3040504@intel.com>
Date: Mon, 21 Apr 2014 10:18:48 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
References: <1395295426-12391-1-git-send-email-zheng.z.yan@intel.com> <20140418105354.GA29167@gmail.com>
In-Reply-To: <20140418105354.GA29167@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 06:53 PM, Ingo Molnar wrote:
> 
> * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> 
>> This patch adds support for building Intel uncore driver as module.
>> It adds clean-up code and config option for the Intel uncore driver
>>
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>> Changes since v1:
>>  move config option to "General setup/Kernel Performance Events and Counters"
>>
>>  arch/x86/kernel/cpu/Makefile                  |  3 +-
>>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 48 ++++++++++++++++++++++++---
>>  init/Kconfig                                  | 10 ++++++
>>  3 files changed, 56 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
>> index 7fd54f0..5d3da70 100644
>> --- a/arch/x86/kernel/cpu/Makefile
>> +++ b/arch/x86/kernel/cpu/Makefile
>> @@ -36,7 +36,8 @@ obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_iommu.o
>>  endif
>>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
>>  obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
>> -obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_rapl.o
>> +obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_rapl.o
>> +obj-$(CONFIG_PERF_X86_INTEL_UNCORE)	+= perf_event_intel_uncore.o
>>  endif
>>  
>>  
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> index 618d502..fd5e883 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> 
> So I'm not willing to apply this patch until the documentation of 
> perf_event_intel_uncore.c is improved. Right now the file starts 
> without a single comment (!). Just lines after lines of code, without 
> any explanation what it does, what its scope is, etc.

there are comments mark the scope of code for different CPU.

> 
> How should even a knowledgable user know about what it's all about?
> 
> That problem percolates to the Kconfig entry as well:
> 

Most of the codes without comments are hardware specific codes. The corresponding
contents in Intel uncore documents are big tables/lists, nothing tricky/interesting.
I really don't know how to comment these code.

Regards
Yan, Zheng
 

>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1502,6 +1502,16 @@ config PERF_EVENTS
>>  
>>  	  Say Y if unsure.
>>  
>> +config PERF_X86_INTEL_UNCORE
>> +	default y
>> +	tristate "Intel uncore performance monitoring support"
>> +	depends on PERF_EVENTS && CPU_SUP_INTEL && PCI
>> +	help
>> +	  This option allows kernel to access the Uncore performance
>> +	  monitoring units of Intel processors.
>> +
>> +	  Say Y if unsure.
> 
> Firstly, it should probably not be 'default y'.
> 
> Secondly, the description is essentially non-existent. What does the 
> hardware do? Why should users care about uncore PMUs?
> 
> This needs to be fixed before we can make this modular.
> 
> Thanks,
> 
> 	Ingo
> 

