Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaBKHFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:05:06 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53725 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaBKHFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:05:02 -0500
Message-ID: <52F9CA58.1080404@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 12:29:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: ego@linux.vnet.ibm.com
CC: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 24/51] x86, hpet: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220859.19080.7550.stgit@srivatsabhat.in.ibm.com> <20140210185843.GC3416@in.ibm.com>
In-Reply-To: <20140210185843.GC3416@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021107-5140-0000-0000-00000489DAFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 12:28 AM, Gautham R Shenoy wrote:
> Hi,
> 
> On Thu, Feb 06, 2014 at 03:39:00AM +0530, Srivatsa S. Bhat wrote:
>> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
>> index da85a8e..199aaae 100644
>> --- a/arch/x86/kernel/hpet.c
>> +++ b/arch/x86/kernel/hpet.c
>> @@ -943,12 +943,14 @@ static __init int hpet_late_init(void)
>>  	if (boot_cpu_has(X86_FEATURE_ARAT))
>>  		return 0;
>>
>> +	cpu_maps_update_begin();
>>  	for_each_online_cpu(cpu) {
>>  		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
>>  	}
>>
>>  	/* This notifier should be called after workqueue is ready */
>> -	hotcpu_notifier(hpet_cpuhp_notify, -20);
>> +	__hotcpu_notifier(hpet_cpuhp_notify, -20);
> 
> We could #define HPET_CPUHP_PRIO relative to the workqueue priority instead of
> hardcoding this it this way.
> 

Sure, we can do that. Thanks for pointing that out!
 
Regards,
Srivatsa S. Bhat

