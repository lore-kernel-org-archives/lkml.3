Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab3BGOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:25:57 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:32880 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758654Ab3BGOZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:25:54 -0500
Message-ID: <5113B963.2080100@linux.vnet.ibm.com>
Date: Thu, 07 Feb 2013 08:25:39 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 2/4] Expand the steal time msr to also contain the consigned
 time.
References: <20130205214818.4615.12937.stgit@lambeau> <20130205214920.4615.29831.stgit@lambeau> <5112C7CC.6040803@redhat.com>
In-Reply-To: <5112C7CC.6040803@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020714-9574-0000-0000-000006816871
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 03:14 PM, Rik van Riel wrote:
> On 02/05/2013 04:49 PM, Michael Wolf wrote:
>> Expand the steal time msr to also contain the consigned time.
>>
>> Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
>> ---
>>   arch/x86/include/asm/paravirt.h       |    4 ++--
>>   arch/x86/include/asm/paravirt_types.h |    2 +-
>>   arch/x86/kernel/kvm.c                 |    7 ++-----
>>   kernel/sched/core.c                   |   10 +++++++++-
>>   kernel/sched/cputime.c                |    2 +-
>>   5 files changed, 15 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/paravirt.h 
>> b/arch/x86/include/asm/paravirt.h
>> index 5edd174..9b753ea 100644
>> --- a/arch/x86/include/asm/paravirt.h
>> +++ b/arch/x86/include/asm/paravirt.h
>> @@ -196,9 +196,9 @@ struct static_key;
>>   extern struct static_key paravirt_steal_enabled;
>>   extern struct static_key paravirt_steal_rq_enabled;
>>
>> -static inline u64 paravirt_steal_clock(int cpu)
>> +static inline void paravirt_steal_clock(int cpu, u64 *steal)
>>   {
>> -    return PVOP_CALL1(u64, pv_time_ops.steal_clock, cpu);
>> +    PVOP_VCALL2(pv_time_ops.steal_clock, cpu, steal);
>>   }
>
> This may be a stupid question, but what happens if a KVM
> guest with this change, runs on a kernel that still has
> the old steal time interface?
>
> What happens if the host has the new steal time interface,
> but the guest uses the old interface?
>
> Will both cases continue to work as expected with your
> patch series?
>
> If so, could you document (in the source code) why things
> continue to work?
>
I will test the scenarios you suggest and will report back the results.

