Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaH1Ms4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:48:56 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40137 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaH1Msy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:48:54 -0400
Date: Thu, 28 Aug 2014 13:48:46 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Message-ID: <20140828124846.GA20494@sucs.org>
References: <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827161900.GA25326@sucs.org>
 <51ae44fcae424365a6d78f3597175d77@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140827225739.GA24590@sucs.org>
 <ec859d8c8f8743a0b72e5e578472f45d@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <EE124450C0AAF944A40DD71E61F878C9973DAC@SINEX14MBXC418.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C9973DAC@SINEX14MBXC418.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dexuan,

On Thu, Aug 28, 2014 at 03:21:59AM +0000, Dexuan Cui wrote:

> > > > First let me thank you guys for looking into this issue. Looking at

Feel free to add
Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
to your patches (it's useful too me because it makes it easier for me to show
what I've been doing to others :-)

> > > The only issue seen on boot now is similar to
> > > https://lkml.org/lkml/2014/8/19/227 ...

> I don't see this issue.  Do you still see the issue for EVERY boot
> after you applied KY's always-use-page-allocation patch?  I doubt that
> because in the log of the above link:

I think it depends on if I do a UP or SMP boot. With
f1bd473f95e02bc382d4dae94d7f82e2a455e05d (post v3.17-rc2) with the V2 BUG_ON
patch set coupled with the allocation change patch set a UP boot was able to
run a small bunch of CPU and network stress tests without any issue. However,
when doing an SMP boot the following happened:

[  OK  ] Started Getty on tty1.
[  OK  ] Reached target Login Prompts.
[  OK  ] Started Login Service.
[   36.023957] hv_netvsc vmbus_0_15: net device safe to remove
[   36.078386] hv_netvsc: hv_netvsc channel opened successfully

Fedora release 20 ([   36.964636] hv_netvsc vmbus_0_15: Send section size: 6144, Section count:2560
[   37.014857] hv_netvsc vmbus_0_15: Device MAC 00:15:5d:6f:02:a5 link state up
Heisenbug)[   37.180170] BUG: unable to handle kernel
pKageing reqruestn at ffff8801f2ec4068
[   37.181156] IP: el[ 3.1<7.0-ffrc2.x8ffffff814e77dc>] netvsc_start_xmit+0x6ac/0x7c0
[ 6_ 64- 00044-g0bb037.181156] PGD 2db0067 PUa5Dd on 2 an x86_6407dc0067 PM (ttyDS0)

 207c280ara67refedora PTE 8 0000001f2eclo4gin0: 60
[   37.181156] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   37.181156] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.17.0-rc2.x86_64-00044-g0bb0a5d #132
[   37.181156] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   37.181156] task: ffff8801fb27b9f0 ti: ffff8801fb310000 task.ti: ffff8801fb310000
[   37.181156] RIP: 0010:[<ffffffff814e77dc>]  [<ffffffff814e77dc>] netvsc_start_xmit+0x6ac/0x7c0
[   37.181156] RSP: 0018:ffff880206c43960  EFLAGS: 00010246
[   37.181156] RAX: 0000000000000000 RBX: ffff8801f2e9f2d8 RCX: 000000000007f000
[   37.181156] RDX: 000000000007da20 RSI: 0000000000034f70 RDI: 000000000007efc8
[   37.181156] RBP: ffff880206c439a8 R08: 0000000000000000 R09: 0000000000000000
[   37.181156] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   37.181156] R13: ffff8801f2ec4000 R14: ffff8800f1335680 R15: ffff8801f2e9c4ea
[   37.181156] FS:  0000000000000000(0000) GS:ffff880206c40000(0000) knlGS:0000000000000000
[   37.181156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.181156] CR2: ffff8801f2ec4068 CR3: 0000000001c0e000 CR4: 00000000000406e0
[   37.181156] Stack:
[   37.181156]  ffff8801f2e9f344 ffffffff00000062 ffff8800f1335680 0000000081d23300
[   37.181156]  0000000000000062 ffff8800f1335680 0000000400014883 ffff8800ecc56fa0
[   37.181156]  ffff8801f2ec4000 ffff880206c43a00 ffffffff815ce458 ffff8800f13311c8
[   37.181156] Call Trace:
[   37.181156]  <IRQ>
[   37.181156]  [<ffffffff815ce458>] dev_hard_start_xmit+0x348/0x630
[   37.181156]  [<ffffffff815ef5aa>] sch_direct_xmit+0x7a/0x290

That's all I got - all my consoles froze and not even sysrq worked any more.

Here's another splat that also just happened:
[  OK  ] Started NTP client/server.
[  OK  ] Started Login Service.
[   32.558951] hv_netvsc vmbus_0_15: net device safe to remove
[   32.599919] hv_netvsc: hv_netvsc channel opened successfully
[   33.728294] hv_netvsc vmbus_0_15: Send section size: 6144, Section count:2560
[   33.782371] hv_netvsc vmbus_0_15: Device MAC 00:15:5d:6f:02:a5 link state up

Fedora release 20 (Heisenbug)
Kernel 3.17.0-rc2.x86_64-00044-g0bb0a5d on an x86_64 (ttyS0)

ararefedora login: [   35.301491] BUG: unable to handle kernel paging request at ffff8800ef0df973
[   35.302392] IP: [<ffffffff814e701d>] netvsc_select_queue+0x3d/0x150
[   35.302392] PGD 2db0067 PUD 2075be067 PMD 207445067 PTE 80000000ef0df060
[   35.302392] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   35.302392] CPU: 1 PID: 723 Comm: arping Not tainted 3.17.0-rc2.x86_64-00044-g0bb0a5d #132
[   35.302392] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   35.302392] task: ffff8800eea68000 ti: ffff8801f5af0000 task.ti: ffff8801f5af0000
[   35.302392] RIP: 0010:[<ffffffff814e701d>]  [<ffffffff814e701d>] netvsc_select_queue+0x3d/0x150
[   35.302392] RSP: 0018:ffff8801f5af3c60  EFLAGS: 00010206
[   35.302392] RAX: 0000000000000000 RBX: ffff8800f0c49160 RCX: 000000000000ffff
[   35.302392] RDX: ffff8800ef0cf968 RSI: ffff8801fa42a1c0 RDI: ffff8800f0c49160
[   35.302392] RBP: ffff8801f5af3c88 R08: 000000000000002a R09: 0000000000000000
[   35.302392] R10: ffff8801f372b3d8 R11: 000000000000000a R12: ffff8801fa42a1c0
[   35.302392] R13: 0000000000000000 R14: ffff8801f3832e68 R15: ffff8801fa42a1c0
[   35.302392] FS:  00007f3359e96740(0000) GS:ffff880206c20000(0000) knlGS:0000000000000000
[   36.090561] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.090561] CR2: ffff8800ef0df973 CR3: 00000000ef1fe000 CR4: 00000000000406e0
[   36.090561] Stack:
[   36.090561]  ffffffff8167f591 ffff8800f0c49160 000000000000001c 0000000000000000
[   36.090561]  ffff8801f3832e68 ffff8801f5af3d48 ffffffff816832fc ffff8800eea68740
[   36.090561]  0000000000000000 ffff8801f5af3d68 0000000000000046 000000000000001c
[   36.090561] Call Trace:
[   36.090561]  [<ffffffff8167f591>] ? packet_pick_tx_queue+0x31/0xa0
[   36.090561]  [<ffffffff816832fc>] packet_sendmsg+0xc1c/0xdd0
[   36.090561]  [<ffffffff810bd106>] ? lock_release_non_nested+0xc6/0x330
[   36.090561]  [<ffffffff815b42a8>] sock_sendmsg+0x88/0xb0
[   36.090561]  [<ffffffff81185443>] ? might_fault+0xa3/0xb0
[   36.090561]  [<ffffffff811853fa>] ? might_fault+0x5a/0xb0
[   36.090561]  [<ffffffff815b43de>] SYSC_sendto+0x10e/0x150
[   36.090561]  [<ffffffff811853fa>] ? might_fault+0x5a/0xb0
[   36.090561]  [<ffffffff816a3215>] ? sysret_check+0x22/0x5d
[   36.090561]  [<ffffffff810b97fd>] ? trace_hardirqs_on_caller+0x17d/0x210
[   36.090561]  [<ffffffff8139c09e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   36.090561]  [<ffffffff815b53be>] SyS_sendto+0xe/0x10
[   36.090561]  [<ffffffff816a31e9>] system_call_fastpath+0x16/0x1b
[   36.090561] Code: 00 4d 85 d2 0f 84 1c 01 00 00 44 8b 9f 8c 03 00 00 31 c0 41 83 fb 01 0f 86 1b 01 00 00 0f b7 8e b4 00 00 00 48 8b 96 c0 00 00 00 <66> 83 7c 0a 0c 08 0f 85 01 01 00 00 55 48 89 e5 41 55 41 54 53
[   36.090561] RIP  [<ffffffff814e701d>] netvsc_select_queue+0x3d/0x150
[   36.090561]  RSP <ffff8801f5af3c60>
[   36.090561] CR2: ffff8800ef0df973
[   36.090561] ---[ end trace 7e294eb7f2c54206 ]---
[   36.090561] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:41
[   36.090561] in_atomic(): 0, irqs_disabled(): 1, pid: 723, name: arping
[   36.090561] INFO: lockdep is turned off.
[   36.090561] irq event stamp: 4692
[   36.090561] hardirqs last  enabled at (4691): [<ffffffff81698bf4>] __slab_alloc+0x50b/0x576
[   36.090561] hardirqs last disabled at (4692): [<ffffffff816a5266>] error_sti+0x5/0x6
[   36.090561] softirqs last  enabled at (4542): [<ffffffff815cecf0>] __dev_queue_xmit+0x5b0/0x690
[   36.090561] softirqs last disabled at (4508): [<ffffffff815ce798>] __dev_queue_xmit+0x58/0x690
[   36.090561] CPU: 1 PID: 723 Comm: arping Tainted: G      D        3.17.0-rc2.x86_64-00044-g0bb0a5d #132
[   36.090561] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   36.090561]  0000000000000046 ffff8801f5af38e0 ffffffff8169a64b ffff8800eea68000
[   36.090561]  ffff8801f5af38f8 ffffffff8109ec65 ffff8801f3bc5c18 ffff8801f5af3918
[   36.090561]  ffffffff816a0c84 ffffffff81090f38 ffff8800eea68000 ffff8801f5af3938
[   36.090561] Call Trace:
[   36.090561]  [<ffffffff8169a64b>] dump_stack+0x4d/0x66
[   36.090561]  [<ffffffff8109ec65>] __might_sleep+0x115/0x120
[   36.090561]  [<ffffffff816a0c84>] down_read+0x24/0x70
[   36.090561]  [<ffffffff81090f38>] ? __validate_process_creds+0xd8/0xf0
[   36.090561]  [<ffffffff8107f9d4>] exit_signals+0x24/0x140
[   36.090561]  [<ffffffff810737d9>] do_exit+0x129/0xa20
[   36.090561]  [<ffffffff810c4bcc>] ? kmsg_dump+0xfc/0x110
[   36.090561]  [<ffffffff810c4af5>] ? kmsg_dump+0x25/0x110
[   36.090561]  [<ffffffff81006348>] oops_end+0xa8/0xc0
[   36.090561]  [<ffffffff816951c8>] no_context+0x322/0x36b
[   36.090561]  [<ffffffff810b97fd>] ? trace_hardirqs_on_caller+0x17d/0x210
[   36.090561]  [<ffffffff816953dc>] __bad_area_nosemaphore+0x1cb/0x1e8
[   36.090561]  [<ffffffff810b97fd>] ? trace_hardirqs_on_caller+0x17d/0x210
[   36.090561]  [<ffffffff8169540c>] bad_area_nosemaphore+0x13/0x15
[   36.090561]  [<ffffffff8104040e>] __do_page_fault+0x1ee/0x4f0
[   36.090561]  [<ffffffff815bccae>] ? __alloc_skb+0x4e/0x240
[   36.090561]  [<ffffffff810bd106>] ? lock_release_non_nested+0xc6/0x330
[   36.090561]  [<ffffffff8139c0dd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   36.090561]  [<ffffffff81040762>] do_page_fault+0x22/0x30
[   36.090561]  [<ffffffff816a5048>] page_fault+0x28/0x30
[   36.090561]  [<ffffffff814e701d>] ? netvsc_select_queue+0x3d/0x150
[   36.090561]  [<ffffffff8167f591>] ? packet_pick_tx_queue+0x31/0xa0
[   36.090561]  [<ffffffff816832fc>] packet_sendmsg+0xc1c/0xdd0
[   36.090561]  [<ffffffff810bd106>] ? lock_release_non_nested+0xc6/0x330
[   36.090561]  [<ffffffff815b42a8>] sock_sendmsg+0x88/0xb0
[   36.090561]  [<ffffffff81185443>] ? might_fault+0xa3/0xb0
[   36.090561]  [<ffffffff811853fa>] ? might_fault+0x5a/0xb0
[   36.090561]  [<ffffffff815b43de>] SYSC_sendto+0x10e/0x150
[   36.090561]  [<ffffffff811853fa>] ? might_fault+0x5a/0xb0
[   36.090561]  [<ffffffff816a3215>] ? sysret_check+0x22/0x5d
[   36.090561]  [<ffffffff810b97fd>] ? trace_hardirqs_on_caller+0x17d/0x210
[   36.090561]  [<ffffffff8139c09e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   36.090561]  [<ffffffff815b53be>] SyS_sendto+0xe/0x10
[   36.090561]  [<ffffffff816a31e9>] system_call_fastpath+0x16/0x1b

We can spin these off into a different thread if that would be helpful.

> [   34.628072] hv_netvsc vmbus_0_15: net device safe to remove
> [   34.676573] hv_netvsc: hv_netvsc channel opened successfully
> [   34.860292] hv_netvsc vmbus_0_15 eth1: unable to establish send buffer's gpadl
> [   34.948983] hv_netvsc vmbus_0_15 eth1: unable to connect to NetVSP - 4
> 
> Here the 4 is just HV_STATUS_INVALID_ALIGNMENT -- it should be fixed
> by the patch.

I've double checked and I don't see that message any more so I must have
been mistaken.

> > That is good to hear. I was under the impression that this issue would be
> > resolved with all the cleanup we have done. The last patch-set I posted
> > earlier today has the fix for vmbus_open  bug that Dexuan had identified.
> > 
> > If you could try with the BUG_ON elimination patch-set I sent out earlier
> > today with the fix in hv.c that I had sent that would be great.

I've switched to it (see above) and a number of issues have been resolved.

> > > How come previous alignment efforts weren't working out?
> I'm not sure.
> If we trust the hypervisor, I would guess in hv_post_message()
> 1) We'd better add "aligned_msg->reserved = 0;"
> 2) Should we make sure  "aligned_msg->payload_size % 8 == 0"? IMO
>    aligned_msg->payload is an array of 8-byte.

In that case why would payload_size not be a multiple of 8 - can it
change due to debug padding? If so wouldn't its start have had to be
misaligned?

-- 
Sitsofe | http://sucs.org/~sits/
