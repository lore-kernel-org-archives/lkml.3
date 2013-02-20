Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab3BTRB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:01:29 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56426 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3BTRB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:01:28 -0500
Date: Wed, 20 Feb 2013 09:01:24 -0800
From: Tejun Heo <tj@kernel.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL dereference on idr_find() in perf_init_event() on
 next-20130220
Message-ID: <20130220170124.GA3570@htj.dyndns.org>
References: <20130220113248.A4AA0E0085@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220113248.A4AA0E0085@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 01:32:48PM +0200, Kirill A. Shutemov wrote:
> [    0.115053] Performance Events: unsupported p6 CPU model 45 no PMU driver, software events only.
> [    0.116656] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.117000] IP: [<ffffffff810f8b7c>] perf_init_event+0xbc/0x330
> [    0.117000] PGD 0 
> [    0.117000] Oops: 0000 [#1] SMP 
> [    0.117000] CPU 0 
> [    0.117000] Pid: 11, comm: watchdog/0 Not tainted 3.8.0-next-20130220 #312  
> [    0.117000] RIP: 0010:[<ffffffff810f8b7c>]  [<ffffffff810f8b7c>] perf_init_event+0xbc/0x330
> [    0.117000] RSP: 0000:ffff880012db7cb8  EFLAGS: 00010246
> [    0.117000] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
> [    0.117000] RDX: ffff880012db7fd8 RSI: ffffffff81832480 RDI: ffff880012dab790
> [    0.117000] RBP: ffff880012db7cf8 R08: 0000000000000000 R09: ffff880012dab768
> [    0.117000] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880012c24800
> [    0.117000] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [    0.117000] FS:  0000000000000000(0000) GS:ffff880013c00000(0000) knlGS:0000000000000000
> [    0.117000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.117000] CR2: 0000000000000000 CR3: 000000000180b000 CR4: 00000000000406f0
> [    0.117000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.117000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.117000] Process watchdog/0 (pid: 11, threadinfo ffff880012db6000, task ffff880012dab0c0)
> [    0.117000] Stack:
> [    0.117000]  ffffffff810f8ac0 ffffffff82251360 ffff880012db7cf8 ffffffff8106a6bc
> [    0.117000]  ffff880012c24800 ffffffff81839da0 ffff880012c24800 0000000000000000
> [    0.117000]  ffff880012db7d58 ffffffff810f9160 0000000000000001 0000000000000000
> [    0.117000] Call Trace:
> [    0.117000]  [<ffffffff810f8ac0>] ? perf_pmu_unregister+0x140/0x140
> [    0.117000]  [<ffffffff8106a6bc>] ? __mutex_init+0x5c/0x70
> [    0.117000]  [<ffffffff810f9160>] perf_event_alloc+0x370/0x480
> [    0.117000]  [<ffffffff810ca3d0>] ? watchdog_should_run+0x30/0x30
> [    0.117000]  [<ffffffff810fa01f>] perf_event_create_kernel_counter+0x2f/0xe0
> [    0.117000]  [<ffffffff810725c3>] ? finish_task_switch+0x83/0xe0
> [    0.117000]  [<ffffffff810ca5bd>] watchdog_enable+0xfd/0x1e0
> [    0.117000]  [<ffffffff814d4642>] ? __schedule+0x3e2/0x950
> [    0.117000]  [<ffffffff810702bd>] smpboot_thread_fn+0xbd/0x1d0
> [    0.117000]  [<ffffffff814d4bd4>] ? schedule+0x24/0x70
> [    0.117000]  [<ffffffff81070200>] ? lg_global_unlock+0x80/0x80
> [    0.117000]  [<ffffffff81066f06>] kthread+0xd6/0xe0
> [    0.117000]  [<ffffffff81066e30>] ? __kthread_bind+0x40/0x40
> [    0.117000]  [<ffffffff814d782c>] ret_from_fork+0x7c/0xb0
> [    0.117000]  [<ffffffff81066e30>] ? __kthread_bind+0x40/0x40
> [    0.117000] Code: 00 00 41 8b 9c 24 a0 00 00 00 4c 8b 35 fe 85 15 01 e8 69 b6 f6 ff 85 c0 74 0d 80 3d 7a 04 79 00 00 0f 84 88 01 00 00 89 d8 30 c0 <41> 3b 06 0f 84 1b 01 00 00 89 de 48 c7 c7 60 11 25 82 e8 dd 50 
> [    0.117000] RIP  [<ffffffff810f8b7c>] perf_init_event+0xbc/0x330
> [    0.117000]  RSP <ffff880012db7cb8>
> [    0.117000] CR2: 0000000000000000
> [    0.118008] ---[ end trace fa6ba2ddf54083dc ]---

Reverting cc5b5f68d7 ("events: convert to idr_alloc()") doens't make
any difference, so the conversion itself isn't the problem.

Bisecting.... heh, it's the lookup hint implementation.  Maybe it gets
out of sync.  I'll investigate further.

Thanks.

-- 
tejun
