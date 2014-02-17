Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaBQTlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:41:46 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43879 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbaBQTlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:41:45 -0500
Message-ID: <530265E6.5030906@linux.vnet.ibm.com>
Date: Mon, 17 Feb 2014 11:41:26 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Scott Wood <scottwood@freescale.com>, Paul Bolle <pebolle@tiscali.nl>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Tang Yuantian <yuantian.tang@freescale.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Lijun Pan <Lijun.Pan@freescale.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH v2 10/11] powerpc/perf: add kconfig option for hypervisor
 provided counters
References: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com> <1392415338-16288-11-git-send-email-cody@linux.vnet.ibm.com> <1392417133.6733.624.camel@snotra.buserror.net> <20140215002505.GA2991@negative> <1392621108.8740.5.camel@concordia>
In-Reply-To: <1392621108.8740.5.camel@concordia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021719-7182-0000-0000-000009DABBD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 11:11 PM, Michael Ellerman wrote:
> On Fri, 2014-02-14 at 16:25 -0800, Cody P Schafer wrote:
>> On Fri, Feb 14, 2014 at 04:32:13PM -0600, Scott Wood wrote:
>>> On Fri, 2014-02-14 at 14:02 -0800, Cody P Schafer wrote:
>>>> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
>>>> index 434fda3..dcc67cd 100644
>>>> --- a/arch/powerpc/platforms/Kconfig.cputype
>>>> +++ b/arch/powerpc/platforms/Kconfig.cputype
>>>> @@ -364,6 +364,12 @@ config PPC_PERF_CTRS
>>>>          help
>>>>            This enables the powerpc-specific perf_event back-end.
>>>>
>>>> +config HV_PERF_CTRS
>>>> +       def_bool y
>>>> +       depends on PERF_EVENTS && PPC_HAVE_PMU_SUPPORT
>>>> +       help
>>>> +         Enable access to perf counters provided by the hypervisor
>>>
>>> Please don't add default-y stuff that is platform-specific, and
>>> definitely point out that platform dependency in the config description
>>> -- I have to look elsewhere in the patchset to determine that this is
>>> for "Power Hypervisor".  PPC_HAVE_PMU_SUPPORT is enabled by all 6xx
>>> builds, even for hardware like e300 that doesn't have PMU at all (it has
>>> the FSL embedded perfmon instead), much less this hv interface.
>>>
>>> And yes, PPC_PERF_CTRS has the same problem and should be fixed. :-)
>>
>> Yep, I just based this one on what PPC_PERF_CTRS was doing.
>>
>> How about the following:
>>
>> +config HV_PERF_CTRS
>> +       bool "Perf Hypervisor supplied counters"
>
> "Support for Hypervisor supplied PMU events (24x7 & GPCI)" ?

Sounds good to me.

>
>> +       default y
>> +       depends on PERF_EVENTS && PPC_HAVE_PMU_SUPPORT && PPC_PSERIES
>
> I think you just want:
>
> 	depends on PERF_EVENTS && PPC_PSERIES
>
>
> Because you're adding two completely new PMUs, they're not a "struct power_pmu"
> backend for the existing powerpc PMU implementation.
>

Ack. I'll fix this up in v3

