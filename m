Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab3BTDgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 22:36:06 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:47745 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3BTDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 22:36:04 -0500
Message-ID: <5124449D.3060808@numascale-asia.com>
Date: Wed, 20 Feb 2013 11:35:57 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Steffen Persvold <sp@numascale.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: False-positive RCU stall warnings on large systems...
References: <5123A984.4000704@numascale-asia.com> <20130219181624.GG3093@linux.vnet.ibm.com>
In-Reply-To: <20130219181624.GG3093@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/2013 02:16, Paul E. McKenney wrote:
> On Wed, Feb 20, 2013 at 12:34:12AM +0800, Daniel J Blueman wrote:
>> Hi Paul,
>>
>> On some of our larger servers with many hundreds of cores and when
>> under high duress, we can see scheduler RCU stall warnings [1], so
>> find we have to increase the hardcoded RCU_STALL_RAT_DELAY up from 2
>> and RCU_JIFFIES_TILL_FORCE_QS up from 3.
>>
>> Is there a more sustainable way to account for this to avoid it
>> being hard-coded, such as making it and dependent timeouts a
>> fraction of CONFIG_RCU_CPU_STALL_TIMEOUT?
>>
>> On the other hand, perhaps this is just caused by clock jitter (eg
>> due to distance from a contended clock source)? So increasing these
>> a bit may just be adequate in general...
>
> Hmmm...  What version of the kernel are you running?

The example below occurs with v3.8, but we see the same with previous 
kernels eg v3.5.

Of course, when using the local TSC, you'd see no jitter relative to 
coherent transactions (eg memory writes), but when the HPET is used 
across a large system, coherent transactions to distant cores are just 
so much faster, as there's massive congestion to the shared HPET behind 
various HT and PCIe bridges. This could be where the jitter arises from, 
if I'm guessing jitter is the problem here.

Thanks,
   Daniel

>> --- [1]
>>
>> [ 3939.010085] INFO: rcu_sched detected stalls on CPUs/tasks: {}
>> (detected by 1, t=29662 jiffies, g=3053, c=3052, q=598)
>> [ 3939.020008] INFO: Stall ended before state dump start
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
