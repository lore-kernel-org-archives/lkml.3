Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaG2JGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:06:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52173 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaG2JGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:06:02 -0400
Date: Tue, 29 Jul 2014 11:05:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140729090556.GE11179@pd.tnic>
References: <1406624353-4782-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406624353-4782-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:59:13PM +0800, Wanpeng Li wrote:
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

No, this is not what I meant. See, those numbers above only make the
commit message unreadable and don't say a lot after time has passed or
on another user's machine. What we rather want is this below, which
shows how we ended up here but doesn't contain unnecessary and useless
information.

Ok?

BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [..] find_busiest_group
PGD 5a9d5067 PUD 13067 PMD 0
Oops: 0000 [#3] SMP
[...]
Call Trace:
load_balance
? _raw_spin_unlock_irqrestore
idle_balance
__schedule
schedule
schedule_timeout
? lock_timer_base
schedule_timeout_uninterruptible
msleep
lock_device_hotplug_sysfs
online_store
dev_attr_store
sysfs_write_file
vfs_write
SyS_write
system_call_fastpath

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
