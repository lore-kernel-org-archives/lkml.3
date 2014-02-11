Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaBKHEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:04:23 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49561 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKHEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:04:22 -0500
Message-ID: <52F9CA2D.6070705@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 12:28:53 +0530
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
Subject: Re: [PATCH 16/51] x86, vsyscall: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220727.19080.71911.stgit@srivatsabhat.in.ibm.com> <20140210185056.GB3416@in.ibm.com>
In-Reply-To: <20140210185056.GB3416@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021107-0260-0000-0000-00000456EA8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 12:20 AM, Gautham R Shenoy wrote:
> Hi,
> 
> On Thu, Feb 06, 2014 at 03:37:27AM +0530, Srivatsa S. Bhat wrote:
>> @@ -393,9 +393,13 @@ static int __init vsyscall_init(void)
>>  {
>>  	BUG_ON(VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE));
>>
>> +	cpu_maps_update_begin();
>> +
>>  	on_each_cpu(cpu_vsyscall_init, NULL, 1);
>>  	/* notifier priority > KVM */
>> -	hotcpu_notifier(cpu_vsyscall_notifier, 30);
>> +	__hotcpu_notifier(cpu_vsyscall_notifier, 30);
> 
> While we're at it, we could also #define the VSYSCALL_PRIO relative to
> KVM_PRIO instead of hard-coding the value here, no ?
> 

Yeah, that sounds like a good idea, but I guess we can do these
cleanups in a separate patch series.

>> +
>> +	cpu_maps_update_done();
>>
>>  	return 0;
>>  }
>>
 
Regards,
Srivatsa S. Bhat

