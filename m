Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab3B0L5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:57:40 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:37158 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759797Ab3B0L5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:57:38 -0500
Date: Wed, 27 Feb 2013 12:57:32 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-watchdog@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [next-20130227] kernel NULL pointer dereference [ watchdog | perf related ? ]
Message-ID: <20130227115732.GA7867@spo001.leaseweb.com>
References: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sedat,

> I have reported this issue several times (first for next-20130223) to
> LKML and Linux-Next MLs but got no answer.
> I am unsure which is the root cause for all this trouble.
> 
> Can someone have a look at this, please?
> 
> [    0.065787] smpboot: CPU0: Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz
> (fam: 06, model: 2a, stepping: 07)
> [    0.065799] TSC deadline timer enabled
> [    0.065811] Performance Events: PEBS fmt1+, 16-deep LBR,
> SandyBridge events, Intel PMU driver.
> [    0.065822] ... version:                3
> [    0.065824] ... bit width:              48
> [    0.065826] ... generic registers:      4
> [    0.065829] ... value mask:             0000ffffffffffff
> [    0.065831] ... max period:             000000007fffffff
> [    0.065834] ... fixed-purpose events:   3
> [    0.065836] ... event mask:             000000070000000f
> [    0.066888] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [    0.066894] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.066900] PGD 0
> [    0.066903] Oops: 0000 [#1] SMP
> [    0.066906] Modules linked in:
> [    0.066908] CPU 0
> [    0.066912] Pid: 11, comm: watchdog/0 Not tainted
> 3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD.
> 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
> [    0.066918] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>]
> perf_init_event+0x32/0x100
> [    0.066924] RSP: 0000:ffff880119b59d58  EFLAGS: 00010246
> [    0.066927] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
> [    0.066930] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
> [    0.066933] RBP: ffff880119b59d88 R08: ffff88011fa16fa0 R09: ffffffff810ec0e0
> [    0.066936] R10: ffff88011b012000 R11: 0000000000000000 R12: ffff88011b012000
> [    0.066939] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88011b012000
> [    0.066942] FS:  0000000000000000(0000) GS:ffff88011fa00000(0000)
> knlGS:0000000000000000
> [    0.066946] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.066949] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407f0
> [    0.066952] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.066955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.066959] Process watchdog/0 (pid: 11, threadinfo
> ffff880119b58000, task ffff880119b50000)
> [    0.066962] Stack:
> [    0.066964]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000
> ffffffff81c4d760
> [    0.066970]  ffff88011b012000 0000000000000000 ffff880119b59de8
> ffffffff8112a6b8
> [    0.066975]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0
> 0000000000000000
> [    0.066980] Call Trace:
> [    0.066985]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
> [    0.066990]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
> [    0.066995]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
> [    0.066999]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
> [    0.067004]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
> [    0.067009]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
> [    0.067013]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
> [    0.067017]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.067021]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
> [    0.067025]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.067027] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18
> e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00
> 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3
> 48 85
> [    0.067063] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.067067]  RSP <ffff880119b59d58>
> [    0.067069] CR2: 0000000000000000
> [    0.067077] ---[ end trace 3cbbfd94f0f8f035 ]---

touch_nmi_watchdog is defined in kernel/watchdog.c (which is the kernels watchdog and has nothing to do with the watchdog device drivers).

Kind regards,
Wim.

