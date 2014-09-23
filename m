Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaIWJiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:38:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44596 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbaIWJiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:38:00 -0400
Date: Tue, 23 Sep 2014 11:37:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        x86@kernel.org, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] x86, cpu-hotplug: fix llc shared map unreleased
 during cpu hotplug
Message-ID: <20140923093753.GA22644@pd.tnic>
References: <1410938272-7217-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410938272-7217-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 03:17:52PM +0800, Wanpeng Li wrote:
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> IP: [..] find_busiest_group
> PGD 5a9d5067 PUD 13067 PMD 0
> Oops: 0000 [#3] SMP
> [...]
> Call Trace:
> load_balance
> ? _raw_spin_unlock_irqrestore
> idle_balance
> __schedule
> schedule
> schedule_timeout
> ? lock_timer_base
> schedule_timeout_uninterruptible
> msleep
> lock_device_hotplug_sysfs
> online_store
> dev_attr_store
> sysfs_write_file
> vfs_write
> SyS_write
> system_call_fastpath
> 
> This bug can be triggered by hot add and remove large number of xen
> domain0's vcpus repeatedly.
> 
> Last level cache shared map is built during cpu up and build sched domain 
> routine takes advantage of it to setup sched domain cpu topology, however, 
> llc shared map is unreleased during cpu disable which lead to invalid sched 
> domain cpu topology. This patch fix it by release llc shared map correctly
> during cpu disable.
> 
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Tested-by: Linn Crosetto <linn@hp.com>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
