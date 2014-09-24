Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaIXHwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:52:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61583 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaIXHwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:52:15 -0400
Date: Wed, 24 Sep 2014 09:52:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] x86, cpu-hotplug: fix llc shared map unreleased
 during cpu hotplug
Message-ID: <20140924075210.GC3797@gmail.com>
References: <1410938272-7217-1-git-send-email-wanpeng.li@linux.intel.com>
 <20140923093753.GA22644@pd.tnic>
 <542206DB.9080102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <542206DB.9080102@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wanpeng Li <kernellwp@gmail.com> wrote:

> 
> 于 14-9-23 下午5:37, Borislav Petkov 写道:
> >On Wed, Sep 17, 2014 at 03:17:52PM +0800, Wanpeng Li wrote:
> >>BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> >>IP: [..] find_busiest_group
> >>PGD 5a9d5067 PUD 13067 PMD 0
> >>Oops: 0000 [#3] SMP
> >>[...]
> >>Call Trace:
> >>load_balance
> >>? _raw_spin_unlock_irqrestore
> >>idle_balance
> >>__schedule
> >>schedule
> >>schedule_timeout
> >>? lock_timer_base
> >>schedule_timeout_uninterruptible
> >>msleep
> >>lock_device_hotplug_sysfs
> >>online_store
> >>dev_attr_store
> >>sysfs_write_file
> >>vfs_write
> >>SyS_write
> >>system_call_fastpath
> >>
> >>This bug can be triggered by hot add and remove large number of xen
> >>domain0's vcpus repeatedly.
> >>
> >>Last level cache shared map is built during cpu up and build sched domain
> >>routine takes advantage of it to setup sched domain cpu topology, however,
> >>llc shared map is unreleased during cpu disable which lead to invalid sched
> >>domain cpu topology. This patch fix it by release llc shared map correctly
> >>during cpu disable.
> >>
> >>Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> >>Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> >>Tested-by: Linn Crosetto <linn@hp.com>
> >>Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> >Reviewed-by: Borislav Petkov <bp@suse.de>
> >
> 
> Thanks.
> 
> 
> Ingo, Peter Z, HPA,
> 
> 
> Could this patch catch up with 3.18 merge window?

Please also add the real-hardware reports to the changelog.

Thanks,

	Ingo
