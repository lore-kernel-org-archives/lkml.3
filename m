Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaBKWB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:01:26 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34793 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaBKWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:01:22 -0500
Message-ID: <52FA9DAE.1040603@linaro.org>
Date: Tue, 11 Feb 2014 23:01:18 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>, linux-pm@vger.kernel.org,
        peterz@infradead.org, benh@kernel.crashing.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, paulus@samba.org, srivatsa.bhat@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V4 2/3] tick/cpuidle: Initialize hrtimer mode of broadcast
References: <20140207075618.17187.20149.stgit@preeti.in.ibm.com> <20140207080632.17187.80532.stgit@preeti.in.ibm.com> <52F9F896.4020402@linaro.org> <alpine.DEB.2.02.1402111654190.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402111654190.21991@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 04:58 PM, Thomas Gleixner wrote:
> On Tue, 11 Feb 2014, Daniel Lezcano wrote:
>> On 02/07/2014 09:06 AM, Preeti U Murthy wrote:
>> Setting the smp affinity on the earliest timer should be handled automatically
>> with the CLOCK_EVT_FEAT_DYNIRQ flag. Did you look at using this flag ?
>
> How should this flag help? Not at all, because the hrtimer based
> broadcast device cannot assign affinities.
>
>> Another comment is the overall approach. We enter the cpuidle idle framework
>> with a specific state to go to and it is the tick framework telling us we
>> mustn't go to this state. IMO the logic is wrong, the decision to not enter
>> this state should be moved somewhere else.
>>
>> Why don't you create a cpuidle driver with the shallow idle states assigned to
>> a cpu (let's say cpu0) and another one with all the deeper idle states for the
>> rest of the cpus ? Using the multiple cpuidle driver support makes it
>> possible. The timer won't be moving around and a cpu will be dedicated to act
>> as the broadcast timer.
>>
>> Wouldn't make sense and be less intrusive than the patchset you proposed ?
>
> How do you arm the broadcast timer on CPU0 from CPU1? You can't!
>
> You cannot access the cpu local timer on a different cpu. So you would
> have to send an IPI over to CPU0 so that it can reevaluate and
> schedule the broadcast. That's even more backwards than telling the
> cpuidle code that the CPU is not in a state to go deep.

Indeed :)

Thanks for the clarification.

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

