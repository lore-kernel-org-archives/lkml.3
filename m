Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaAMTef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:34:35 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64050 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752394AbaAMTe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:34:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [intel_idle] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
Date: Mon, 13 Jan 2014 20:48:25 +0100
Message-ID: <2707526.hmly97vKq5@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140113132734.GA32268@localhost>
References: <20140113132734.GA32268@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 13, 2014 09:27:34 PM Fengguang Wu wrote:
> 
> --4Ckj6UjgE2iN1+kY
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> 
> Greetings,

Hi,

> We find commit 38207484cc9 ("intel_idle: use the common
> cpuidle_[un]register() routines") triggered oops in one of our
> servers:
> 
> [   12.788616] intel_idle: MWAIT substates: 0x2120
> [   12.794106] intel_idle: v0.4 model 0x3F
> [   12.798820] intel_idle: lapic_timer_reliable_states 0xffffffff
> [   12.807169] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> [   12.816854] IP: [<ffffffff814f02f1>] kobject_get+0x12/0x44
> [   12.823487] PGD 0
> [   12.826228] Oops: 0002 [#1] SMP
> [   12.830406] Modules linked in:
> [   12.834310] CPU: 18 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc7-03669-ga961e1e #1
> [   12.843645] Hardware name: Intel Corporation S2600WT/S2600WT, BIOS GRNDSDP1.86B.0018.R02.1310250658 10/25/2013
> [   12.855602] task: ffff880469ff8000 ti: ffff880469810000 task.ti: ffff880469810000
> [   12.864737] RIP: 0010:[<ffffffff814f02f1>]  [<ffffffff814f02f1>] kobject_get+0x12/0x44
> [   12.874442] RSP: 0000:ffff880469811d08  EFLAGS: 00010202
> [   12.880803] RAX: 0000000000000001 RBX: 0000000000000010 RCX: 0000000000000000
> [   12.889209] RDX: ffffffff81f8e2ad RSI: 000000000000002f RDI: 0000000000000010
> [   12.897613] RBP: ffff880469811d10 R08: 0000000000000007 R09: ffffffff81f8e2ad
> [   12.906016] R10: ffff88084d2e8630 R11: 0000000000000001 R12: 0000000000000000
> [   12.914419] R13: 0000000000000010 R14: 000000000000fc20 R15: 0000000000000000
> [   12.922824] FS:  0000000000000000(0000) GS:ffff88086ec80000(0000) knlGS:0000000000000000
> [   12.932645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   12.939495] CR2: 0000000000000048 CR3: 000000000220c000 CR4: 00000000001407e0
> [   12.947900] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   12.956302] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   12.964704] Stack:
> [   12.967367]  ffff88084d2e86a8 ffff880469811d58 ffffffff814f084d ffff88084d2e86a8
> [   12.976724]  0000000000000000 ffff88084d2e86a8 0000000000000000 0000000000000010
> [   12.986080]  000000000000fc20 0000000000000000 ffff880469811dc8 ffffffff814f0a90
> [   12.995443] Call Trace:
> [   12.998594]  [<ffffffff814f084d>] kobject_add_internal+0x5a/0x22a
> [   13.005832]  [<ffffffff814f0a90>] kobject_init_and_add+0x73/0x7e
> [   13.012975]  [<ffffffff811b0c7f>] ? kmem_cache_alloc_trace+0x4c/0x1b8
> [   13.020602]  [<ffffffff818d55ac>] ? cpuidle_add_sysfs+0x32/0xb1
> [   13.027645]  [<ffffffff8122a96d>] ? sysfs_new_dirent+0x51/0x102
> [   13.034686]  [<ffffffff818d55fd>] cpuidle_add_sysfs+0x83/0xb1
> [   13.041534]  [<ffffffff818d4745>] cpuidle_register_device+0xab/0xfb
> [   13.048964]  [<ffffffff818d48eb>] cpuidle_register+0x79/0xae
> [   13.055719]  [<ffffffff8238ff8b>] intel_idle_init+0x2c8/0x313
> 
> Full dmesg and kconfig are attached.

Thanks for the report.

I've dropped the commit in question from linux-next for now.

Rafael

