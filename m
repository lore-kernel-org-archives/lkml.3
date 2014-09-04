Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaIDJBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:01:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:6482 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbaIDJBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:01:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,464,1406617200"; 
   d="scan'208";a="586115027"
Date: Thu, 4 Sep 2014 17:02:25 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@kernel.org>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140904090225.GA6555@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
 <20140904052034.GA29146@gmail.com>
 <5407FB37.2070306@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5407FB37.2070306@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 02:40:07PM +0900, Yasuaki Ishimatsu wrote:
>(2014/09/04 14:20), Ingo Molnar wrote:
>>
>>* Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
>>
>>>BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>>>IP: [..] find_busiest_group
>>>PGD 5a9d5067 PUD 13067 PMD 0
>>>Oops: 0000 [#3] SMP
>>>[...]
>>>Call Trace:
>>>load_balance
>>>? _raw_spin_unlock_irqrestore
>>>idle_balance
>>>__schedule
>>>schedule
>>>schedule_timeout
>>>? lock_timer_base
>>>schedule_timeout_uninterruptible
>>>msleep
>>>lock_device_hotplug_sysfs
>>>online_store
>>>dev_attr_store
>>>sysfs_write_file
>>>vfs_write
>>>SyS_write
>>>system_call_fastpath
>>>
>>>Last level cache shared map is built during cpu up and build sched domain
>>>routine takes advantage of it to setup sched domain cpu topology, however,
>>>llc shared map is unreleased during cpu disable which lead to invalid sched
>>>domain cpu topology. This patch fix it by release llc shared map correctly
>>>during cpu disable.
>>
>>Very little is said in this changelog about how the bug was
>>found, how likely it is to occur for others, what systems are
>>affected, etc.
>
>Hi Wanpeng,

Hi Yasuaki,

>
>In my understanding, the panic occurs by just onlining CPU as follows:
>echo 1 > /sys/devices/system/cpu/cpuX/online
>

See my reply to Ingo.

Regards,
Wanpeng Li 

>So, how about add the information?
>
>Thanks,
>Yasuaki Ishimatsu
>
>
>>
>>Thanks,
>>
>>	Ingo
>>
>
