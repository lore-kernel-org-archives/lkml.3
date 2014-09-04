Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaIDFlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:41:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59374 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaIDFlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:41:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5407FB37.2070306@jp.fujitsu.com>
Date: Thu, 4 Sep 2014 14:40:07 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Wanpeng Li <wanpeng.li@linux.intel.com>
CC: <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        <linux-kernel@vger.kernel.org>, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com> <20140904052034.GA29146@gmail.com>
In-Reply-To: <20140904052034.GA29146@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/04 14:20), Ingo Molnar wrote:
>
> * Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>> IP: [..] find_busiest_group
>> PGD 5a9d5067 PUD 13067 PMD 0
>> Oops: 0000 [#3] SMP
>> [...]
>> Call Trace:
>> load_balance
>> ? _raw_spin_unlock_irqrestore
>> idle_balance
>> __schedule
>> schedule
>> schedule_timeout
>> ? lock_timer_base
>> schedule_timeout_uninterruptible
>> msleep
>> lock_device_hotplug_sysfs
>> online_store
>> dev_attr_store
>> sysfs_write_file
>> vfs_write
>> SyS_write
>> system_call_fastpath
>>
>> Last level cache shared map is built during cpu up and build sched domain
>> routine takes advantage of it to setup sched domain cpu topology, however,
>> llc shared map is unreleased during cpu disable which lead to invalid sched
>> domain cpu topology. This patch fix it by release llc shared map correctly
>> during cpu disable.
>
> Very little is said in this changelog about how the bug was
> found, how likely it is to occur for others, what systems are
> affected, etc.

Hi Wanpeng,

In my understanding, the panic occurs by just onlining CPU as follows:
echo 1 > /sys/devices/system/cpu/cpuX/online

So, how about add the information?

Thanks,
Yasuaki Ishimatsu


>
> Thanks,
>
> 	Ingo
>


