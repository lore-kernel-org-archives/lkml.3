Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaCaNja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:39:30 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:39209 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbaCaNj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:39:27 -0400
Date: Mon, 31 Mar 2014 14:39:25 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Kent Overstreet <kmo@daterainc.com>, Nicholas Swenson <nks@daterainc.com>
Cc: Daniel Smedegaard Buus <danielbuus@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Correct way to remove a cache device?
Message-ID: <20140331133918.GA2142@sucs.org>
References: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHnuAexDhxuzPrdA5OqOudL6-reAceM0CfAzKH=vQ+S2_++OYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any ideas about this oops Kent? I've seen similar problems too...

On Mon, Mar 31, 2014 at 01:47:21PM +0200, Daniel Smedegaard Buus wrote:
> 
> Still having issues with bcache on my AWS EC2 adventure...
> 
> I'm trying to figure out what the correct way of taking down a bcache
> cache device is.
> 
> If I echo 1 to /sys/block/BACKING_DEVICE/bcache/detach, and then to
> /sys/fs/bcache/*/unregister, the system will hang. The detach part
> goes well, but immediately after unregistering, it will crash.
> 
> I only have SSH access to this instance, and get no output from the
> shell, but if I do this in a startup script, what I see from the
> system log in the AWS console is the below output.
> 
> Any ideas?
> 
> Output:
> 
>     [   20.756111] BUG: unable to handle kernel NULL pointer
> dereference at 0000000000000a00
>     [   20.756125] IP: [<ffffffffa0066280>]
> journal_write_unlocked+0x130/0x540 [bcache]
>     [   20.756137] PGD 0
>     [   20.756139] Oops: 0000 [#1] SMP
>     [   20.756143] Modules linked in: dm_crypt isofs raid10 raid456
> async_memcpy async_raid6_recov async_pq async_xor async_tx xor
> raid6_pq raid1 multipath linear bcache raid0 crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul
> glue_helper ablk_helper cryptd
>     [   20.756165] CPU: 0 PID: 30 Comm: kworker/0:1 Not tainted
> 3.13.0-19-generic #39-Ubuntu
>     [   20.756173] Workqueue: events journal_write_work [bcache]
>     [   20.756176] task: ffff8800e8eedfc0 ti: ffff8800e8fe4000
> task.ti: ffff8800e8fe4000
>     [   20.756179] RIP: e030:[<ffffffffa0066280>]
> [<ffffffffa0066280>] journal_write_unlocked+0x130/0x540 [bcache]
>     [   20.756187] RSP: e02b:ffff8800e8fe5d90  EFLAGS: 00010202
>     [   20.756189] RAX: 0000000000000000 RBX: 0000000000000001 RCX:
> 0000000000000000
>     [   20.756192] RDX: ffff8800e60c0c48 RSI: ffff8800e60ccad8 RDI:
> ffff8800e60f8040
>     [   20.756194] RBP: ffff8800e8fe5de8 R08: 200398332f400000 R09:
> 5e80000000000000
>     [   20.756197] R10: dffbefcdb6cccbd0 R11: 0000000000000000 R12:
> 0000000000000001
>     [   20.756200] R13: ffff8800e60ccba0 R14: ffff8800e60ccce8 R15:
> ffff8800e60c0000
>     [   20.756206] FS:  00007f65089c7740(0000)
> GS:ffff8800ef600000(0000) knlGS:0000000000000000
>     [   20.756209] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
>     [   20.756211] CR2: 0000000000000a00 CR3: 00000000e70f6000 CR4:
> 0000000000002660
>     [   20.756214] Stack:
>     [   20.756216]  ffff8800e8fe5db0 ffff8800e60c0000 ffffffff81c15480
> ffffffff81c15480
>     [   20.756221]  ffff8800e8fe5dc8 ffffffff8109cb2d ffff8800e60c0000
> ffff8800e60ccba0
>     [   20.756225]  ffff8800e60ccbd0 0000000000000000 0000000000000000
> ffff8800e8fe5e08
>     [   20.756229] Call Trace:
>     [   20.756237]  [<ffffffff8109cb2d>] ? vtime_common_task_switch+0x3d/0x40
>     [   20.756243]  [<ffffffffa00666e0>] journal_try_write+0x50/0x60 [bcache]
>     [   20.756248]  [<ffffffffa0066712>] journal_write_work+0x22/0x30 [bcache]
>     [   20.756253]  [<ffffffff810824a2>] process_one_work+0x182/0x450
>     [   20.756257]  [<ffffffff81083241>] worker_thread+0x121/0x410
>     [   20.756260]  [<ffffffff81083120>] ? rescuer_thread+0x3e0/0x3e0
>     [   20.756264]  [<ffffffff81089ed2>] kthread+0xd2/0xf0
>     [   20.756267]  [<ffffffff81089e00>] ? kthread_create_on_node+0x190/0x190
>     [   20.756273]  [<ffffffff817219bc>] ret_from_fork+0x7c/0xb0
>     [   20.756276]  [<ffffffff81089e00>] ? kthread_create_on_node+0x190/0x190
>     [   20.756278] Code: 00 00 e8 04 03 30 e1 31 c0 66 41 83 bd 94 38
> ff ff 00 49 8b 8d a0 40 ff ff 49 8d 97 48 0c 00 00 74 3c 66 0f 1f 84
> 00 00 00 00 00 <48> 8b b9 00 0a 00 00 0f b7 89 ce 00 00 00 83 c0 01 49
> 8b 36 48
>     [   20.756310] RIP  [<ffffffffa0066280>]
> journal_write_unlocked+0x130/0x540 [bcache]
>     [   20.756316]  RSP <ffff8800e8fe5d90>
>     [   20.756317] CR2: 0000000000000a00
>     [   20.756320] ---[ end trace 84c8ace3e9ccb27e ]---
>     [   20.756384] BUG: unable to handle kernel paging request at
> ffffffffffffffd8
>     [   20.756390] IP: [<ffffffff8108a570>] kthread_data+0x10/0x20
>     [   20.756396] PGD 1c11067 PUD 1c13067 PMD 0
>     [   20.756401] Oops: 0000 [#2] SMP
>     [   20.756405] Modules linked in: dm_crypt isofs raid10 raid456
> async_memcpy async_raid6_recov async_pq async_xor async_tx xor
> raid6_pq raid1 multipath linear bcache raid0 crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul
> glue_helper ablk_helper cryptd
>     [   20.756434] CPU: 0 PID: 30 Comm: kworker/0:1 Tainted: G      D
>     3.13.0-19-generic #39-Ubuntu
>     [   20.756450] task: ffff8800e8eedfc0 ti: ffff8800e8fe4000
> task.ti: ffff8800e8fe4000
>     [   20.756455] RIP: e030:[<ffffffff8108a570>]
> [<ffffffff8108a570>] kthread_data+0x10/0x20
>     [   20.756461] RSP: e02b:ffff8800e8fe59e8  EFLAGS: 00010002
>     [   20.756464] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> 0000000000000005
>     [   20.756468] RDX: 0000000000000004 RSI: 0000000000000000 RDI:
> ffff8800e8eedfc0
>     [   20.756472] RBP: ffff8800e8fe59e8 R08: 0000000000000000 R09:
> ffff8800ef618580
>     [   20.756476] R10: ffffffff8133443a R11: ffffea0003996900 R12:
> ffff8800ef614440
>     [   20.756481] R13: 0000000000000000 R14: ffff8800e8eedfb0 R15:
> ffff8800e8eedfc0
>     [   20.756487] FS:  00007f65089c7740(0000)
> GS:ffff8800ef600000(0000) knlGS:0000000000000000
>     [   20.756492] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
>     [   20.756497] CR2: 0000000000000028 CR3: 00000000e70f6000 CR4:
> 0000000000002660
>     [   20.756501] Stack:
>     [   20.756504]  ffff8800e8fe5a00 ffffffff81083951 ffff8800e8eedfc0
> ffff8800e8fe5a60
>     [   20.756511]  ffffffff81715249 ffff8800e8eedfc0 ffff8800e8fe5fd8
> 0000000000014440
>     [   20.756518]  0000000000014440 ffff8800e8eedfc0 ffff8800e8eee5f8
> ffff8800e8eedfb0
>     [   20.756525] Call Trace:
>     [   20.756530]  [<ffffffff81083951>] wq_worker_sleeping+0x11/0x90
>     [   20.756536]  [<ffffffff81715249>] __schedule+0x589/0x7d0
>     [   20.756541]  [<ffffffff817154b9>] schedule+0x29/0x70
>     [   20.756547]  [<ffffffff81068c3f>] do_exit+0x6df/0xa50
>     [   20.756553]  [<ffffffff8171a539>] oops_end+0xa9/0x150
>     [   20.756559]  [<ffffffff81709614>] no_context+0x27e/0x28b
>     [   20.756564]  [<ffffffff81709694>] __bad_area_nosemaphore+0x73/0x1ca
>     [   20.756570]  [<ffffffff817097fe>] bad_area_nosemaphore+0x13/0x15
>     [   20.756576]  [<ffffffff8171cf07>] __do_page_fault+0xa7/0x560
>     [   20.756582]  [<ffffffff81718eb0>] ? _raw_spin_unlock_irqrestore+0x20/0x40
>     [   20.756589]  [<ffffffff810a95f4>] ? __wake_up+0x44/0x50
>     [   20.756595]  [<ffffffff81641479>] ?
> netlink_broadcast_filtered+0x129/0x3b0
>     [   20.756602]  [<ffffffff8135c510>] ? kobj_ns_drop+0x50/0x50
>     [   20.756607]  [<ffffffff8171d3da>] do_page_fault+0x1a/0x70
>     [   20.756611]  [<ffffffff81719848>] page_fault+0x28/0x30
>     [   20.756616]  [<ffffffffa0066280>] ?
> journal_write_unlocked+0x130/0x540 [bcache]
>     [   20.756620]  [<ffffffff8109cb2d>] ? vtime_common_task_switch+0x3d/0x40
>     [   20.756625]  [<ffffffffa00666e0>] journal_try_write+0x50/0x60 [bcache]
>     [   20.756630]  [<ffffffffa0066712>] journal_write_work+0x22/0x30 [bcache]
>     [   20.756634]  [<ffffffff810824a2>] process_one_work+0x182/0x450
>     [   20.756638]  [<ffffffff81083241>] worker_thread+0x121/0x410
>     [   20.756641]  [<ffffffff81083120>] ? rescuer_thread+0x3e0/0x3e0
>     [   20.756644]  [<ffffffff81089ed2>] kthread+0xd2/0xf0
>     [   20.756648]  [<ffffffff81089e00>] ? kthread_create_on_node+0x190/0x190
>     [   20.756651]  [<ffffffff817219bc>] ret_from_fork+0x7c/0xb0
>     [   20.756654]  [<ffffffff81089e00>] ? kthread_create_on_node+0x190/0x190
>     [   20.756657] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0
> 01 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 a8 03 00
> 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
> 44 00 00
>     [   20.756688] RIP  [<ffffffff8108a570>] kthread_data+0x10/0x20
>     [   20.756691]  RSP <ffff8800e8fe59e8>
>     [   20.756693] CR2: ffffffffffffffd8
>     [   20.756695] ---[ end trace 84c8ace3e9ccb27f ]---
>     [   20.756697] Fixing recursive fault but reboot is needed!

-- 
Sitsofe | http://sucs.org/~sits/
