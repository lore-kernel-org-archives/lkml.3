Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaBYVbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:31:38 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:58466 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaBYVbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:31:35 -0500
Message-ID: <530D0BA1.90609@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 13:31:13 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Lijun Pan <Lijun.Pan@freescale.com>, Li Yang <leoli@freescale.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Tang Yuantian <yuantian.tang@freescale.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 10/11] powerpc/perf: add kconfig option for hypervisor
 provided counters
References: <20140225033330.54F332C02FB@ozlabs.org>
In-Reply-To: <20140225033330.54F332C02FB@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022521-1344-0000-0000-000006111AA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 07:33 PM, Michael Ellerman wrote:
> On Fri, 2014-14-02 at 22:02:14 UTC, Cody P Schafer wrote:
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> ---
>>   arch/powerpc/perf/Makefile             | 2 ++
>>   arch/powerpc/platforms/Kconfig.cputype | 6 ++++++
>>   2 files changed, 8 insertions(+)
>>
>> diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
>> index 60d71ee..f9c083a 100644
>> --- a/arch/powerpc/perf/Makefile
>> +++ b/arch/powerpc/perf/Makefile
>> @@ -11,5 +11,7 @@ obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
>>   obj-$(CONFIG_FSL_EMB_PERF_EVENT) += core-fsl-emb.o
>>   obj-$(CONFIG_FSL_EMB_PERF_EVENT_E500) += e500-pmu.o e6500-pmu.o
>>
>> +obj-$(CONFIG_HV_PERF_CTRS) += hv-24x7.o hv-gpci.o hv-common.o
>> +
>>   obj-$(CONFIG_PPC64)		+= $(obj64-y)
>>   obj-$(CONFIG_PPC32)		+= $(obj32-y)
>> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
>> index 434fda3..dcc67cd 100644
>> --- a/arch/powerpc/platforms/Kconfig.cputype
>> +++ b/arch/powerpc/platforms/Kconfig.cputype
>> @@ -364,6 +364,12 @@ config PPC_PERF_CTRS
>>          help
>>            This enables the powerpc-specific perf_event back-end.
>>
>> +config HV_PERF_CTRS
>> +       def_bool y
>
> This was bool, why did you change it?

No, it wasn't. v1 also had def_bool. https://lkml.org/lkml/2014/1/16/518
Maybe you're confusing v2.1 and v2 of this patch?

>
>> +       depends on PERF_EVENTS && PPC_HAVE_PMU_SUPPORT
>
> Should be:
>
> 	depends on PERF_EVENTS && PPC_PSERIES
>
>> +       help
>> +         Enable access to perf counters provided by the hypervisor
>> +

Yep, the v2.1 patch (which I bungled and labeled as 9/11) already 
changes both of these.
It'll end up rolled into v3.

