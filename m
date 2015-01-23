Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbbAWSPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:15:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbbAWSPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:15:44 -0500
Date: Fri, 23 Jan 2015 19:15:38 +0100
From: Borislav Petkov <bp@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RFT] x86: move cacheinfo sysfs to generic cacheinfo
 infrastructure
Message-ID: <20150123181538.GG2041@pd.tnic>
References: <1420703406-10637-1-git-send-email-sudeep.holla@arm.com>
 <alpine.DEB.2.11.1501231453400.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501231453400.5526@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 02:55:03PM +0100, Thomas Gleixner wrote:
> Cc: Boris
> 
> On Thu, 8 Jan 2015, Sudeep Holla wrote:
> 
> > This patch removes the redundant sysfs cacheinfo code by reusing
> > the newly introduced generic cacheinfo infrastructure through the
> > commit 246246cbde5e ("drivers: base: support cpu cache information
> > interface to userspace via sysfs")
> > 
> > The private pointer provided by the cacheinfo is used to implement
> > the AMD L3 cache specific attributes.
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com> 
> > Cc: x86@kernel.org

...
[    2.878173] ACPI: processor limited to max C-state 1
[    2.884048] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.911085] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.920699] Linux agpgart interface v0.103
[    2.924908] [drm] Initialized drm 1.1.0 20060810
[    2.929719] ------------[ cut here ]------------
[    2.934419] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0xd4/0xe0()
[    2.943591] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
[    2.949024] Modules linked in:
[    2.952486] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc5+ #1
[    2.958921] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7599/870-C45 (MS-7599), BIOS V1.15 03/04/2011
[    2.968878]  ffffffff817e9f1f ffff880132183b08 ffffffff81567210 0000000000000000
[    2.976603]  ffff880132183b58 ffff880132183b48 ffffffff8107bbe5 ffff880132183b98
[    2.984333]  0000000000000096 00000000000080d0 0000000000000018 ffff880132001cc0
[    2.992063] Call Trace:
[    2.994594]  [<ffffffff81567210>] dump_stack+0x4f/0x7b
[    2.999818]  [<ffffffff8107bbe5>] warn_slowpath_common+0x95/0xe0
[    3.005909]  [<ffffffff8107bc76>] warn_slowpath_fmt+0x46/0x50
[    3.011740]  [<ffffffff810c5834>] lockdep_trace_alloc+0xd4/0xe0
[    3.017745]  [<ffffffff811ac3b1>] __kmalloc+0x51/0x230
[    3.022969]  [<ffffffff8101389d>] ? cpuid4_cache_lookup_regs+0x21d/0x480
[    3.029753]  [<ffffffff8101389d>] cpuid4_cache_lookup_regs+0x21d/0x480
[    3.036365]  [<ffffffff81013b00>] ? cpuid4_cache_lookup_regs+0x480/0x480
[    3.043149]  [<ffffffff81013b94>] _populate_cache_leaves+0x94/0x460
[    3.049498]  [<ffffffff81013b00>] ? cpuid4_cache_lookup_regs+0x480/0x480
[    3.056282]  [<ffffffff810fcec6>] generic_exec_single+0x136/0x1a0
[    3.062456]  [<ffffffff81013b00>] ? cpuid4_cache_lookup_regs+0x480/0x480
[    3.069237]  [<ffffffff810fcf93>] smp_call_function_single+0x63/0xd0
[    3.075674]  [<ffffffff811ac4e8>] ? __kmalloc+0x188/0x230
[    3.081155]  [<ffffffff81014862>] populate_cache_leaves+0x22/0x30
[    3.087329]  [<ffffffff813c342b>] detect_cache_attributes+0x7b/0x1a0
[    3.093767]  [<ffffffff81b1ed9b>] ? container_dev_init+0x2f/0x2f
[    3.099855]  [<ffffffff81b1eddd>] cacheinfo_sysfs_init+0x42/0x93
[    3.105946]  [<ffffffff81b1ed9b>] ? container_dev_init+0x2f/0x2f
[    3.112038]  [<ffffffff810002f0>] do_one_initcall+0xa0/0x1f0
[    3.117777]  [<ffffffff8109b000>] ? parse_args+0x1b0/0x420
[    3.123345]  [<ffffffff81aee001>] kernel_init_freeable+0x115/0x19d
[    3.129605]  [<ffffffff8157047f>] ? ret_from_fork+0xf/0xb0
[    3.135172]  [<ffffffff815628b0>] ? rest_init+0xd0/0xd0
[    3.140478]  [<ffffffff815628be>] kernel_init+0xe/0xf0
[    3.145699]  [<ffffffff815704ec>] ret_from_fork+0x7c/0xb0
[    3.151177]  [<ffffffff815628b0>] ? rest_init+0xd0/0xd0
[    3.156489] ---[ end trace 5a99fef82328e919 ]---
[    3.161190] BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
[    3.169248] IP: [<ffffffff81013f40>] _populate_cache_leaves+0x440/0x460
[    3.175993] PGD 0 
[    3.178141] Oops: 0002 [#1] PREEMPT SMP 
[    3.182297] Modules linked in:
[    3.185486] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.19.0-rc5+ #1
[    3.193099] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7599/870-C45 (MS-7599), BIOS V1.15 03/04/2011
[    3.203053] task: ffff880132138000 ti: ffff880132180000 task.ti: ffff880132180000
[    3.210667] RIP: 0010:[<ffffffff81013f40>]  [<ffffffff81013f40>] _populate_cache_leaves+0x440/0x460
[    3.219892] RSP: 0000:ffff880132183c88  EFLAGS: 00010086
[    3.225286] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffffff
[    3.232503] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000000
[    3.239719] RBP: ffff880132183d28 R08: ffff880136c0a0c0 R09: ffff88013196eb60
[    3.246936] R10: 0000000000000002 R11: 0000000000000212 R12: 0000000000000000
[    3.254152] R13: 000000000000a0c0 R14: ffffffff81acdad8 R15: 0000000000000001
[    3.261369] FS:  0000000000000000(0000) GS:ffff880136c00000(0000) knlGS:0000000000000000
[    3.269586] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.275414] CR2: 00000000000000f8 CR3: 0000000001a11000 CR4: 00000000000007f0
[    3.282630] Stack:
[    3.284724]  ffff880132183de4 000000000000a000 000000000000a000 ffff880136c0fbc0
[    3.292451]  0000000000000090 ffff88013197f4b0 0000000000000006 ffff88013197f520
[    3.300175]  000000000000a0c0 0000000300000000 0bc0003f14000163 00000000000007ff
[    3.307901] Call Trace:
[    3.310433]  [<ffffffff81013b00>] ? cpuid4_cache_lookup_regs+0x480/0x480
[    3.317216]  [<ffffffff810fcec6>] generic_exec_single+0x136/0x1a0
[    3.323392]  [<ffffffff81013b00>] ? cpuid4_cache_lookup_regs+0x480/0x480
[    3.330176]  [<ffffffff810fcf93>] smp_call_function_single+0x63/0xd0
[    3.336612]  [<ffffffff811ac4e8>] ? __kmalloc+0x188/0x230
[    3.342093]  [<ffffffff81014862>] populate_cache_leaves+0x22/0x30
[    3.348269]  [<ffffffff813c342b>] detect_cache_attributes+0x7b/0x1a0
[    3.354706]  [<ffffffff81b1ed9b>] ? container_dev_init+0x2f/0x2f
[    3.360795]  [<ffffffff81b1eddd>] cacheinfo_sysfs_init+0x42/0x93
[    3.366886]  [<ffffffff81b1ed9b>] ? container_dev_init+0x2f/0x2f
[    3.372976]  [<ffffffff810002f0>] do_one_initcall+0xa0/0x1f0
[    3.378717]  [<ffffffff8109b000>] ? parse_args+0x1b0/0x420
[    3.384283]  [<ffffffff81aee001>] kernel_init_freeable+0x115/0x19d
[    3.390543]  [<ffffffff8157047f>] ? ret_from_fork+0xf/0xb0
[    3.396111]  [<ffffffff815628b0>] ? rest_init+0xd0/0xd0
[    3.401416]  [<ffffffff815628be>] kernel_init+0xe/0xf0
[    3.406638]  [<ffffffff815704ec>] ret_from_fork+0x7c/0xb0
[    3.412116]  [<ffffffff815628b0>] ? rest_init+0xd0/0xd0
[    3.417422] Code: 3c dd 80 d7 ac 81 ff c2 48 63 d2 be 06 00 00 00 e8 c6 87 2b 00 3b 05 e4 ac ab 00 89 c2 7d a4 89 c0 49 0f a3 06 19 c9 85 c9 74 d0 <f0> 49 0f ab 84 24 f8 00 00 00 eb c4 4c 8b 65 98 e9 eb fd ff ff 
[    3.439789] RIP  [<ffffffff81013f40>] _populate_cache_leaves+0x440/0x460
[    3.446622]  RSP <ffff880132183c88>
[    3.450191] CR2: 00000000000000f8
[    3.453592] ---[ end trace 5a99fef82328e91a ]---
[    3.458290] Kernel panic - not syncing: Fatal exception
[    3.463659] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    3.473965] ---[ end Kernel panic - not syncing: Fatal exception

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
