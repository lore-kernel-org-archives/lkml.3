Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaIOBcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 21:32:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60462 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaIOBce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 21:32:34 -0400
Message-ID: <541641A9.1060300@gmail.com>
Date: Mon, 15 Sep 2014 09:32:25 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com> <20140904052034.GA29146@gmail.com> <20140904085641.GA6311@kernel> <20140904093414.GA7296@kernel>
In-Reply-To: <20140904093414.GA7296@kernel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Ingo, HPA, PeterZ
于 14-9-4 下午5:34, Wanpeng Li 写道:
> Hi Ingo,
> On Thu, Sep 04, 2014 at 04:56:41PM +0800, Wanpeng Li wrote:
>> On Thu, Sep 04, 2014 at 07:20:34AM +0200, Ingo Molnar wrote:
>>> * Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
>>>
>>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>>>> IP: [..] find_busiest_group
>>>> PGD 5a9d5067 PUD 13067 PMD 0
>>>> Oops: 0000 [#3] SMP
>>>> [...]
>>>> Call Trace:
>>>> load_balance
>>>> ? _raw_spin_unlock_irqrestore
>>>> idle_balance
>>>> __schedule
>>>> schedule
>>>> schedule_timeout
>>>> ? lock_timer_base
>>>> schedule_timeout_uninterruptible
>>>> msleep
>>>> lock_device_hotplug_sysfs
>>>> online_store
>>>> dev_attr_store
>>>> sysfs_write_file
>>>> vfs_write
>>>> SyS_write
>>>> system_call_fastpath
>>>>
>>>> Last level cache shared map is built during cpu up and build sched domain
>>>> routine takes advantage of it to setup sched domain cpu topology, however,
>>>> llc shared map is unreleased during cpu disable which lead to invalid sched
>>>> domain cpu topology. This patch fix it by release llc shared map correctly
>>>> during cpu disable.
>>> Very little is said in this changelog about how the bug was
>>> found, how likely it is to occur for others, what systems are
>>> affected, etc.
>> This bug can be triggered by hot add and remove large number of xen
>> domain0's vcpus repeated.
>>
> If I need to send a new version of the patch or you can pick the patch
> w/ the updated changelog for me? ;-)
>
> Regards,
> Wanpeng Li
>
>> Regards,
>> Wanpeng Li
>>
>>> Thanks,
>>>
>>> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

