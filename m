Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaG2Hcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:32:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49115 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaG2Hcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:32:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53D74DD2.6040306@jp.fujitsu.com>
Date: Tue, 29 Jul 2014 16:31:30 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Yong Wang <yong.y.wang@linux.intel.com>
Subject: Re: [PATCH v2] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
References: <1406016292-55968-1-git-send-email-wanpeng.li@linux.intel.com> <53CF78A7.5070302@jp.fujitsu.com> <20140729070626.GA9635@kernel>
In-Reply-To: <20140729070626.GA9635@kernel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanpeng,

(2014/07/29 16:06), Wanpeng Li wrote:
> Hi Yasuaki,
> On Wed, Jul 23, 2014 at 05:56:07PM +0900, Yasuaki Ishimatsu wrote:
>> (2014/07/22 17:04), Wanpeng Li wrote:
>>> [  220.262093] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>>> [  220.262104] IP: [<ffffffff810e7ac9>] find_busiest_group+0x2b9/0xa30
>>> [  220.262111] PGD 5a9d5067 PUD 13067 PMD 0
>>> [  220.262117] Oops: 0000 [#3] SMP
>>> [...]
>>> [  220.262245] Call Trace:
>>> [  220.262252]  [<ffffffff810e8396>] load_balance+0x156/0x980
>>> [  220.262259]  [<ffffffff816eeffe>] ? _raw_spin_unlock_irqrestore+0x2e/0xa0
>>> [  220.262266]  [<ffffffff810e9aa3>] idle_balance+0xe3/0x150
>>> [  220.262270]  [<ffffffff816ec4e7>] __schedule+0x797/0x8d0
>>> [  220.262277]  [<ffffffff816ec934>] schedule+0x24/0x70
>>> [  220.262283]  [<ffffffff816e9cd9>] schedule_timeout+0x119/0x1f0
>>> [  220.262294]  [<ffffffff810bb6e0>] ? lock_timer_base+0x70/0x70
>>> [  220.262301]  [<ffffffff816e9dc9>] schedule_timeout_uninterruptible+0x19/0x20
>>> [  220.262308]  [<ffffffff810bd3e8>] msleep+0x18/0x20
>>> [  220.262317]  [<ffffffff813aa11a>] lock_device_hotplug_sysfs+0x2a/0x50
>>> [  220.262323]  [<ffffffff813aa16e>] online_store+0x2e/0x80
>>> [  220.262358]  [<ffffffff813a873b>] dev_attr_store+0x1b/0x20
>>> [  220.262366]  [<ffffffff812292fd>] sysfs_write_file+0xdd/0x160
>>> [  220.262377]  [<ffffffff811b7e78>] vfs_write+0xc8/0x170
>>> [  220.262384]  [<ffffffff811b83ca>] SyS_write+0x5a/0xa0
>>> [  220.262388]  [<ffffffff816f76b9>] system_call_fastpath+0x16/0x1b
>>>
>>> Last level cache shared map is built during cpu up and build sched domain
>>> routine takes advantage of it to setup sched domain cpu topology, however,
>>> llc shared map is unreleased during cpu disable which lead to invalid sched
>>> domain cpu topology. This patch fix it by release llc shared map correctly
>>> during cpu disable.
>>>
>>
>> I posted a latest patch as follows:
>> https://lkml.org/lkml/2014/7/22/1018
>>
>> Could you confirm the patch fixes your issue?
>
> Sorry for the late, there is still call trace w/ your patch applied. The
> call trace is in attachment.

Thank you for reporting the result. As Borislav said, your v2 patch
is necessary for fixing your issue.

>
> Regards,
> Wanpeng Li
>
>>
>> Thanks,
>> Yasuaki Ishimatsu
>>
>>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>>> ---
>>> v1 -> v2:
>>>    * fix subject line
>>>
>>>    arch/x86/kernel/smpboot.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>>> index 5492798..0134ec7 100644
>>> --- a/arch/x86/kernel/smpboot.c
>>> +++ b/arch/x86/kernel/smpboot.c
>>> @@ -1292,6 +1292,9 @@ static void remove_siblinginfo(int cpu)
>>>
>>>    	for_each_cpu(sibling, cpu_sibling_mask(cpu))
>>>    		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
>>> +	for_each_cpu(sibling, cpu_llc_shared_mask(cpu))
>>> +		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(sibling));
>>> +	cpumask_clear(cpu_llc_shared_mask(cpu));
>>>    	cpumask_clear(cpu_sibling_mask(cpu));
>>>    	cpumask_clear(cpu_core_mask(cpu));
>>>    	c->phys_proc_id = 0;
>>>
>>


