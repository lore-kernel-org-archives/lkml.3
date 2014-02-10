Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaBJSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:09:56 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36682 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaBJSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:09:51 -0500
Message-ID: <52F914A7.9080702@linux.vnet.ibm.com>
Date: Mon, 10 Feb 2014 23:34:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: paulus@samba.org, rusty@rustcorp.com.au, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH 19/51] x86, therm_throt.c: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220759.19080.36356.stgit@srivatsabhat.in.ibm.com> <20140210155323.GA8911@redhat.com> <52F90C8C.9050203@linux.vnet.ibm.com>
In-Reply-To: <52F90C8C.9050203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021018-5816-0000-0000-00000C329002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 10:59 PM, Srivatsa S. Bhat wrote:
> On 02/10/2014 09:23 PM, Oleg Nesterov wrote:
>> On 02/06, Srivatsa S. Bhat wrote:
>>>
>>> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
>>> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
>>> @@ -319,7 +319,7 @@ static __init int thermal_throttle_init_device(void)
>>>  	if (!atomic_read(&therm_throt_en))
>>>  		return 0;
>>>
>>> -	register_hotcpu_notifier(&thermal_throttle_cpu_notifier);
>>> +	cpu_maps_update_begin();
>>>
>>>  #ifdef CONFIG_HOTPLUG_CPU
>>>  	mutex_lock(&therm_cpu_lock);
>>> @@ -333,6 +333,9 @@ static __init int thermal_throttle_init_device(void)
>>>  	mutex_unlock(&therm_cpu_lock);
>>>  #endif
>>>
>>> +	__register_hotcpu_notifier(&thermal_throttle_cpu_notifier);
>>> +	cpu_maps_update_done();
>>
>>
>> Off-topic, but it seems that after this change therm_cpu_lock can die.
>> Of course this needs another patch (if I am right).
>>
> 
> I'm not sure I understood that clearly. Can you please explain?
> 
> I'm guessing that you are referring to some problem with the #ifdef
> CONFIG_HOTPLUG_CPU around mutex_lock/unlock(&therm_cpu_lock) ?
>

Oh, nevermind, now I see it. Basically you are suggesting that therm_cpu_lock
is useless after this patch and hence can be removed entirely. Yep, that
makes sense. (I hadn't noticed it earlier). I'll incorporate that change
in a separate patch in my v2 of the patchset. Thank you!
 
Regards,
Srivatsa S. Bhat

