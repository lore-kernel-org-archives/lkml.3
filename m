Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaGVHwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:52:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGVHwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:52:16 -0400
Date: Tue, 22 Jul 2014 09:52:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix llc shared map unreleased during cpu hotplug
Message-ID: <20140722075200.GW3935@laptop>
References: <1406013391-46548-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406013391-46548-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:16:31PM +0800, Wanpeng Li wrote:
> [  220.262093] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> [  220.262104] IP: [<ffffffff810e7ac9>] find_busiest_group+0x2b9/0xa30
> [  220.262111] PGD 5a9d5067 PUD 13067 PMD 0
> [  220.262117] Oops: 0000 [#3] SMP
> [...]
> [  220.262245] Call Trace:
> [  220.262252]  [<ffffffff810e8396>] load_balance+0x156/0x980
> [  220.262259]  [<ffffffff816eeffe>] ? _raw_spin_unlock_irqrestore+0x2e/0xa0
> [  220.262266]  [<ffffffff810e9aa3>] idle_balance+0xe3/0x150
> [  220.262270]  [<ffffffff816ec4e7>] __schedule+0x797/0x8d0
> [  220.262277]  [<ffffffff816ec934>] schedule+0x24/0x70
> [  220.262283]  [<ffffffff816e9cd9>] schedule_timeout+0x119/0x1f0
> [  220.262294]  [<ffffffff810bb6e0>] ? lock_timer_base+0x70/0x70
> [  220.262301]  [<ffffffff816e9dc9>] schedule_timeout_uninterruptible+0x19/0x20
> [  220.262308]  [<ffffffff810bd3e8>] msleep+0x18/0x20
> [  220.262317]  [<ffffffff813aa11a>] lock_device_hotplug_sysfs+0x2a/0x50
> [  220.262323]  [<ffffffff813aa16e>] online_store+0x2e/0x80
> [  220.262358]  [<ffffffff813a873b>] dev_attr_store+0x1b/0x20
> [  220.262366]  [<ffffffff812292fd>] sysfs_write_file+0xdd/0x160
> [  220.262377]  [<ffffffff811b7e78>] vfs_write+0xc8/0x170
> [  220.262384]  [<ffffffff811b83ca>] SyS_write+0x5a/0xa0
> [  220.262388]  [<ffffffff816f76b9>] system_call_fastpath+0x16/0x1b
> 
> Last level cache shared map is built during cpu up and build sched domain 
> routine takes advantage of it to setup sched domain cpu topology, however, 
> llc shared map is unreleased during cpu disable which lead to invalid sched 
> domain cpu topology. This patch fix it by release llc shared map correctly
> during cpu disable.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kernel/smpboot.c | 3 +++
>  1 file changed, 3 insertions(+)

While the scheduler uses this information, the code you're patching is
very much not scheduler code, therefore your subject line is entirely
wrong.
