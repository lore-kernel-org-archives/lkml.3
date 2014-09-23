Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaIWXtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:49:13 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58259 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaIWXtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:49:11 -0400
Message-ID: <542206DB.9080102@gmail.com>
Date: Wed, 24 Sep 2014 07:48:43 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        x86@kernel.org, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] x86, cpu-hotplug: fix llc shared map unreleased during
 cpu hotplug
References: <1410938272-7217-1-git-send-email-wanpeng.li@linux.intel.com> <20140923093753.GA22644@pd.tnic>
In-Reply-To: <20140923093753.GA22644@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 14-9-23 下午5:37, Borislav Petkov 写道:
> On Wed, Sep 17, 2014 at 03:17:52PM +0800, Wanpeng Li wrote:
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
>> This bug can be triggered by hot add and remove large number of xen
>> domain0's vcpus repeatedly.
>>
>> Last level cache shared map is built during cpu up and build sched domain
>> routine takes advantage of it to setup sched domain cpu topology, however,
>> llc shared map is unreleased during cpu disable which lead to invalid sched
>> domain cpu topology. This patch fix it by release llc shared map correctly
>> during cpu disable.
>>
>> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
>> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Tested-by: Linn Crosetto <linn@hp.com>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> Reviewed-by: Borislav Petkov <bp@suse.de>
>

Thanks.


Ingo, Peter Z, HPA,


Could this patch catch up with 3.18 merge window?

Regards,
Wanpeng Li

