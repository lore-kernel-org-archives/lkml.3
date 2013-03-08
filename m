Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab3CHNLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:11:13 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:46529 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3CHNLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:11:11 -0500
Message-ID: <5139E36A.5000109@xs4all.nl>
Date: Fri, 08 Mar 2013 14:11:06 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.6.11: khubd issue SLAB related?
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found this in dmesg:

[3663200.373989] pwc: Philips PCVC740K (ToUCam Pro)/PCVC840 (ToUCam II)
USB webcam detected.
[3663200.779617] khubd: page allocation failure: order:4, mode:0xd0
[3663200.779621] Pid: 274, comm: khubd Not tainted 3.6.11 #22
[3663200.779622] Call Trace:
[3663200.779629]  [<ffffffff810b5346>] ? warn_alloc_failed+0xf6/0x150
[3663200.779632]  [<ffffffff8141c6de>] ?
__alloc_pages_direct_compact+0x1ac/0x1be
[3663200.779635]  [<ffffffff810b7f89>] ? __alloc_pages_nodemask+0x609/0x820
[3663200.779638]  [<ffffffff810e8796>] ? cache_alloc_refill+0x356/0x660
[3663200.779640]  [<ffffffff810e8c7b>] ? kmem_cache_alloc+0xab/0xe0
[3663200.779643]  [<ffffffffa00168da>] ? usb_pwc_probe+0x17a/0xaf0 [pwc]
[3663200.779646]  [<ffffffff812de513>] ? usb_probe_interface+0x113/0x200
[3663200.779650]  [<ffffffff8128be2e>] ? driver_probe_device+0x6e/0x210
[3663200.779652]  [<ffffffff8128c070>] ? __driver_attach+0xa0/0xa0
[3663200.779654]  [<ffffffff8128a2de>] ? bus_for_each_drv+0x3e/0x80
[3663200.779656]  [<ffffffff8128bd90>] ? device_attach+0x80/0x90
[3663200.779658]  [<ffffffff8128b370>] ? bus_probe_device+0x80/0xb0
[3663200.779659]  [<ffffffff812899d7>] ? device_add+0x5b7/0x670
[3663200.779662]  [<ffffffff812dd3a8>] ? usb_set_configuration+0x4b8/0x720
[3663200.779664]  [<ffffffff812e5a3b>] ? generic_probe+0x3b/0xa0
[3663200.779666]  [<ffffffff8128be2e>] ? driver_probe_device+0x6e/0x210
[3663200.779668]  [<ffffffff8128c070>] ? __driver_attach+0xa0/0xa0
[3663200.779670]  [<ffffffff8128a2de>] ? bus_for_each_drv+0x3e/0x80
[3663200.779672]  [<ffffffff8128bd90>] ? device_attach+0x80/0x90
[3663200.779674]  [<ffffffff8128b370>] ? bus_probe_device+0x80/0xb0
[3663200.779675]  [<ffffffff812899d7>] ? device_add+0x5b7/0x670
[3663200.779678]  [<ffffffff81282d7f>] ?
mix_pool_bytes.constprop.15+0x3f/0x60
[3663200.779681]  [<ffffffff81421300>] ? _raw_spin_unlock_bh+0x20/0x20
[3663200.779683]  [<ffffffff812d5d08>] ? usb_new_device+0x1d8/0x260
[3663200.779685]  [<ffffffff812d640a>] ? hub_thread+0x67a/0x14d0
[3663200.779687]  [<ffffffff8142021c>] ? __schedule+0x2ac/0x800
[3663200.779690]  [<ffffffff810611ec>] ? __wake_up_common+0x4c/0x80
[3663200.779693]  [<ffffffff81059b00>] ? abort_exclusive_wait+0xb0/0xb0
[3663200.779695]  [<ffffffff812d5d90>] ? usb_new_device+0x260/0x260
[3663200.779697]  [<ffffffff810591d5>] ? kthread+0x85/0x90
[3663200.779699]  [<ffffffff814231f4>] ? kernel_thread_helper+0x4/0x10
[3663200.779701]  [<ffffffff81059150>] ?
kthread_freezable_should_stop+0x50/0x50
[3663200.779703]  [<ffffffff814231f0>] ? gs_change+0xb/0xb
[3663200.779704] Mem-Info:
[3663200.779705] DMA per-cpu:
[3663200.779706] CPU    0: hi:    0, btch:   1 usd:   0
[3663200.779708] CPU    1: hi:    0, btch:   1 usd:   0
[3663200.779709] CPU    2: hi:    0, btch:   1 usd:   0
[3663200.779710] CPU    3: hi:    0, btch:   1 usd:   0
[3663200.779711] DMA32 per-cpu:
[3663200.779712] CPU    0: hi:  186, btch:  31 usd:   0
[3663200.779713] CPU    1: hi:  186, btch:  31 usd:   0
[3663200.779714] CPU    2: hi:  186, btch:  31 usd:   0
[3663200.779715] CPU    3: hi:  186, btch:  31 usd:   0
[3663200.779716] Normal per-cpu:
[3663200.779717] CPU    0: hi:  186, btch:  31 usd:   0
[3663200.779718] CPU    1: hi:  186, btch:  31 usd:   0
[3663200.779719] CPU    2: hi:  186, btch:  31 usd:   0
[3663200.779720] CPU    3: hi:  186, btch:  31 usd:   0
[3663200.779723] active_anon:367320 inactive_anon:142633 isolated_anon:0
[3663200.779723]  active_file:470023 inactive_file:522338 isolated_file:0
[3663200.779723]  unevictable:0 dirty:89 writeback:0 unstable:0
[3663200.779723]  free:87496 slab_reclaimable:79192 slab_unreclaimable:19937
[3663200.779723]  mapped:18116 shmem:3960 pagetables:11525 bounce:0
[3663200.779728] DMA free:15904kB min:136kB low:168kB high:204kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15680kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? yes
[3663200.779730] lowmem_reserve[]: 0 2448 7483 7483
[3663200.779736] DMA32 free:169684kB min:22072kB low:27588kB
high:33108kB active_anon:196000kB inactive_anon:221500kB
active_file:709152kB inactive_file:793704kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2507728kB mlocked:0kB
dirty:12kB writeback:0kB mapped:19536kB shmem:3072kB
slab_reclaimable:161628kB slab_unreclaimable:15436kB kernel_stack:488kB
pagetables:4780kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[3663200.779737] lowmem_reserve[]: 0 0 5034 5034
[3663200.779742] Normal free:164396kB min:45372kB low:56712kB
high:68056kB active_anon:1273280kB inactive_anon:349032kB
active_file:1170940kB inactive_file:1295648kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5155036kB mlocked:0kB
dirty:344kB writeback:0kB mapped:52928kB shmem:12768kB
slab_reclaimable:155140kB slab_unreclaimable:64312kB kernel_stack:3312kB
pagetables:41320kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[3663200.779744] lowmem_reserve[]: 0 0 0 0
[3663200.779746] DMA: 0*4kB 0*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15904kB
[3663200.779751] DMA32: 23335*4kB 8814*8kB 365*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 169692kB
[3663200.779757] Normal: 38925*4kB 1081*8kB 3*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 164396kB
[3663200.779762] 1007244 total pagecache pages
[3663200.779763] 10889 pages in swap cache
[3663200.779764] Swap cache stats: add 125307, delete 114418, find
564015/570538
[3663200.779765] Free swap  = 3908344kB
[3663200.779766] Total swap = 4095984kB
[3663200.799573] 1961968 pages RAM
[3663200.799575] 75067 pages reserved
[3663200.799576] 268951 pages shared
[3663200.799577] 1601656 pages non-shared
[3663200.799579] SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
[3663200.799581]   cache: size-65536, object size: 65536, order: 4
[3663200.799583]   node 0: slabs: 6/6, objs: 6/6, free: 0
[3663200.799585] pwc: Oops, could not allocate memory for pwc_device.
[3663200.799593] Philips webcam: probe of 2-4:1.0 failed with error -12
[3663200.799619] usb 2-4: adding 2-4:1.1 (config #1, interface 1)
[3663200.799807] snd-usb-audio 2-4:1.1: usb_probe_interface
[3663200.799812] snd-usb-audio 2-4:1.1: usb_probe_interface - got id
[3663200.867541] usb 2-4: adding 2-4:1.2 (config #1, interface 2)
[3663200.867614] hub 2-0:1.0: state 7 ports 5 chg 0000 evt 0010


How can we fix this?

Udo
