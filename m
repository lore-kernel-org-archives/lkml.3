Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3JaGNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:13:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:55930 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3JaGM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:12:58 -0400
X-Spam-Score: -100.8
Message-ID: <5271F4A9.40804@asianux.com>
Date: Thu, 31 Oct 2013 14:11:53 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        realmz paranoid <realmz6@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] arch: *: remove '__init' for setup_profiling_timer()
References: <52672ECD.9010800@asianux.com> <C2D7FE5348E1B147BCA15975FBA23075153861@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075153861@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 01:45 PM, Vineet Gupta wrote:
> On 10/23/2013 07:36 AM, Chen Gang wrote:
>> Most of architectures not use '__init' for setup_profiling_timer(), so
>> need remove it, or can generate warning (e.g. arc with allmodconfig):
>>
>>     MODPOST vmlinux.o
>>   WARNING: vmlinux.o(.text+0x3c682): Section mismatch in reference from the function write_profile() to the function .init.text:setup_profiling_timer()
>>   The function write_profile() references
>>   the function __init setup_profiling_timer().
>>   This is often because write_profile lacks a __init
>>   annotation or the annotation of setup_profiling_timer is wrong.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/arc/kernel/smp.c          |    2 +-
>>  arch/blackfin/mach-bf561/smp.c |    2 +-
>>  arch/parisc/kernel/smp.c       |    2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
>> index bca3052..3bdac11 100644
>> --- a/arch/arc/kernel/smp.c
>> +++ b/arch/arc/kernel/smp.c
>> @@ -187,7 +187,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
>>  /*
>>   * not supported here
>>   */
>> -int __init setup_profiling_timer(unsigned int multiplier)
>> +int setup_profiling_timer(unsigned int multiplier)
>>  {
>>  	return -EINVAL;
>>  }
>> diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
>> index 11789be..3bef058 100644
>> --- a/arch/blackfin/mach-bf561/smp.c
>> +++ b/arch/blackfin/mach-bf561/smp.c
>> @@ -43,7 +43,7 @@ void __init platform_prepare_cpus(unsigned int max_cpus)
>>  	init_cpu_present(&mask);
>>  }
>>  
>> -int __init setup_profiling_timer(unsigned int multiplier) /* not supported */
>> +int setup_profiling_timer(unsigned int multiplier) /* not supported */
>>  {
>>  	return -EINVAL;
>>  }
>> diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
>> index 8a252f2..2e8cd36 100644
>> --- a/arch/parisc/kernel/smp.c
>> +++ b/arch/parisc/kernel/smp.c
>> @@ -433,7 +433,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
>>  }
>>  
>>  #ifdef CONFIG_PROC_FS
>> -int __init
>> +int
>>  setup_profiling_timer(unsigned int multiplier)
>>  {
>>  	return -EINVAL;
> 
> In theory this change is OK. However this is legacy code at best and it would be
> better to define a weak definition in kernel/profile.c and remove this cruft from
> relevant arches. I'll send out a patch.
> 

That sounds good to me.

> -Vineet
> 
> 


-- 
Chen Gang
