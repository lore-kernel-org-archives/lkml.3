Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3CCLvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 06:51:39 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:58102 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3CCLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 06:51:38 -0500
Message-ID: <51333947.2070207@xs4all.nl>
Date: Sun, 03 Mar 2013 12:51:35 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.6.11 SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Below is a dmesg of a SLAB issue I did not yet see before.
A 3.6.11 kernel on a x86_64 Fedora 17 box from kernel.org.
I attached a SATA disk and mounted the encrypted FS after using luksOpen.

So what went wrong?
I do have another instance of this failure below.


[2752132.099772] sd 7:0:0:0: [sde] Attached SCSI disk
[2752141.256433] mount: page allocation failure: order:5, mode:0xd0
[2752141.256441] Pid: 29031, comm: mount Not tainted 3.6.11 #22
[2752141.256444] Call Trace:
[2752141.256455]  [<ffffffff810b5346>] ? warn_alloc_failed+0xf6/0x150
[2752141.256463]  [<ffffffff81421361>] ? _raw_spin_unlock+0x11/0x30
[2752141.256467]  [<ffffffff810b7905>] ? drain_pages+0x25/0x80
[2752141.256472]  [<ffffffff810b7f89>] ? __alloc_pages_nodemask+0x609/0x820
[2752141.256478]  [<ffffffff810681f1>] ? cpuacct_charge+0x21/0x90
[2752141.256484]  [<ffffffff810e8796>] ? cache_alloc_refill+0x356/0x660
[2752141.256488]  [<ffffffff810e8b8d>] ? __kmalloc+0xed/0x130
[2752141.256494]  [<ffffffff81186b9d>] ? ext4_kvzalloc+0x1d/0x60
[2752141.256500]  [<ffffffff8118b794>] ? ext4_fill_super+0x15f4/0x28f0
[2752141.256505]  [<ffffffff81207829>] ? snprintf+0x39/0x40
[2752141.256511]  [<ffffffff8118a1a0>] ? ext4_calculate_overhead+0x410/0x410
[2752141.256517]  [<ffffffff810f35b7>] ? mount_bdev+0x1b7/0x200
[2752141.256522]  [<ffffffff810f3fa5>] ? mount_fs+0x45/0x1c0
[2752141.256528]  [<ffffffff8110d54c>] ? vfs_kern_mount+0x5c/0xf0
[2752141.256533]  [<ffffffff8110da33>] ? do_kern_mount+0x53/0x110
[2752141.256537]  [<ffffffff8110f57c>] ? do_mount+0x32c/0x900
[2752141.256544]  [<ffffffff810c561a>] ? memdup_user+0x3a/0x80
[2752141.256549]  [<ffffffff8110fbe7>] ? sys_mount+0x97/0xf0
[2752141.256554]  [<ffffffff814221a2>] ? system_call_fastpath+0x16/0x1b
[2752141.256556] Mem-Info:
[2752141.256558] DMA per-cpu:
[2752141.256561] CPU    0: hi:    0, btch:   1 usd:   0
[2752141.256564] CPU    1: hi:    0, btch:   1 usd:   0
[2752141.256566] CPU    2: hi:    0, btch:   1 usd:   0
[2752141.256569] CPU    3: hi:    0, btch:   1 usd:   0
[2752141.256571] DMA32 per-cpu:
[2752141.256573] CPU    0: hi:  186, btch:  31 usd:   0
[2752141.256576] CPU    1: hi:  186, btch:  31 usd:   0
[2752141.256578] CPU    2: hi:  186, btch:  31 usd:   0
[2752141.256581] CPU    3: hi:  186, btch:  31 usd:   0
[2752141.256583] Normal per-cpu:
[2752141.256585] CPU    0: hi:  186, btch:  31 usd:   0
[2752141.256587] CPU    1: hi:  186, btch:  31 usd:   0
[2752141.256590] CPU    2: hi:  186, btch:  31 usd:   0
[2752141.256592] CPU    3: hi:  186, btch:  31 usd:   0
[2752141.256599] active_anon:422718 inactive_anon:136139 isolated_anon:0
[2752141.256599]  active_file:406187 inactive_file:342142 isolated_file:0
[2752141.256599]  unevictable:0 dirty:341 writeback:0 unstable:0
[2752141.256599]  free:412313 slab_reclaimable:29780
slab_unreclaimable:19018
[2752141.256599]  mapped:27128 shmem:4325 pagetables:11910 bounce:0
[2752141.256611] DMA free:15904kB min:136kB low:168kB high:204kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15680kB mloc
ked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? y
es
[2752141.256613] lowmem_reserve[]: 0 2448 7483 7483
[2752141.256627] DMA32 free:647920kB min:22072kB low:27588kB
high:33108kB active_anon:310292kB inactive_anon:183372kB
active_file:546236kB inactive_file:541564kB unevictable:0kB
isolated(anon):0kB isolated(f
ile):0kB present:2507728kB mlocked:0kB dirty:16kB writeback:0kB
mapped:35856kB shmem:4468kB slab_reclaimable:45788kB
slab_unreclaimable:13956kB kernel_stack:824kB pagetables:6612kB
unstable:0kB bounce:0kB wr
iteback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[2752141.256630] lowmem_reserve[]: 0 0 5034 5034
[2752141.256642] Normal free:985428kB min:45372kB low:56712kB
high:68056kB active_anon:1380580kB inactive_anon:361184kB
active_file:1078512kB inactive_file:827004kB unevictable:0kB
isolated(anon):0kB isolate
d(file):0kB present:5155036kB mlocked:0kB dirty:1348kB writeback:0kB
mapped:72656kB shmem:12832kB slab_reclaimable:73332kB
slab_unreclaimable:62116kB kernel_stack:3456kB pagetables:41028kB
unstable:0kB bounc
e:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[2752141.256645] lowmem_reserve[]: 0 0 0 0
[2752141.256650] DMA: 0*4kB 0*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15904kB
[2752141.256662] DMA32: 68830*4kB 33795*8kB 6018*16kB 164*32kB 9*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 647920kB
[2752141.256674] Normal: 131253*4kB 49344*8kB 3980*16kB 62*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 985428kB
[2752141.256685] 765564 total pagecache pages
[2752141.256688] 12825 pages in swap cache
[2752141.256690] Swap cache stats: add 106275, delete 93450, find
418139/423494
[2752141.256692] Free swap  = 3951672kB
[2752141.256694] Total swap = 4095984kB
[2752141.281946] 1961968 pages RAM
[2752141.281948] 75067 pages reserved
[2752141.281949] 160668 pages shared
[2752141.281950] 1401377 pages non-shared
[2752141.281952] SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
[2752141.281953]   cache: size-131072, object size: 131072, order: 5
[2752141.281955]   node 0: slabs: 5/5, objs: 5/5, free: 0
[2752141.305744] EXT4-fs (dm-13): mounted filesystem with ordered data
mode. Opts: (null)
[2753111.882314] ata8: exception Emask 0x10 SAct 0x0 SErr 0x10200 action
0xe frozen





[3339288.581110] sd 7:0:0:0: [sde] Attached SCSI disk
[3339303.677284] mount: page allocation failure: order:5, mode:0xd0
[3339303.677289] Pid: 28786, comm: mount Not tainted 3.6.11 #22
[3339303.677291] Call Trace:
[3339303.677297]  [<ffffffff810b5346>] ? warn_alloc_failed+0xf6/0x150
[3339303.677301]  [<ffffffff81421361>] ? _raw_spin_unlock+0x11/0x30
[3339303.677304]  [<ffffffff810b7905>] ? drain_pages+0x25/0x80
[3339303.677306]  [<ffffffff810b7f89>] ? __alloc_pages_nodemask+0x609/0x820
[3339303.677309]  [<ffffffff810e8796>] ? cache_alloc_refill+0x356/0x660
[3339303.677311]  [<ffffffff810e8b8d>] ? __kmalloc+0xed/0x130
[3339303.677315]  [<ffffffff81186b9d>] ? ext4_kvzalloc+0x1d/0x60
[3339303.677317]  [<ffffffff8118b794>] ? ext4_fill_super+0x15f4/0x28f0
[3339303.677320]  [<ffffffff81207829>] ? snprintf+0x39/0x40
[3339303.677322]  [<ffffffff8118a1a0>] ? ext4_calculate_overhead+0x410/0x410
[3339303.677325]  [<ffffffff810f35b7>] ? mount_bdev+0x1b7/0x200
[3339303.677327]  [<ffffffff810f3fa5>] ? mount_fs+0x45/0x1c0
[3339303.677330]  [<ffffffff8110d54c>] ? vfs_kern_mount+0x5c/0xf0
[3339303.677332]  [<ffffffff8110da33>] ? do_kern_mount+0x53/0x110
[3339303.677334]  [<ffffffff8110f57c>] ? do_mount+0x32c/0x900
[3339303.677337]  [<ffffffff810c561a>] ? memdup_user+0x3a/0x80
[3339303.677339]  [<ffffffff8110fbe7>] ? sys_mount+0x97/0xf0
[3339303.677341]  [<ffffffff814221a2>] ? system_call_fastpath+0x16/0x1b
[3339303.677342] Mem-Info:
[3339303.677344] DMA per-cpu:
[3339303.677345] CPU    0: hi:    0, btch:   1 usd:   0
[3339303.677346] CPU    1: hi:    0, btch:   1 usd:   0
[3339303.677347] CPU    2: hi:    0, btch:   1 usd:   0
[3339303.677348] CPU    3: hi:    0, btch:   1 usd:   0
[3339303.677349] DMA32 per-cpu:
[3339303.677350] CPU    0: hi:  186, btch:  31 usd:   0
[3339303.677351] CPU    1: hi:  186, btch:  31 usd:   0
[3339303.677352] CPU    2: hi:  186, btch:  31 usd:   0
[3339303.677353] CPU    3: hi:  186, btch:  31 usd:   0
[3339303.677354] Normal per-cpu:
[3339303.677355] CPU    0: hi:  186, btch:  31 usd:   0
[3339303.677356] CPU    1: hi:  186, btch:  31 usd:   0
[3339303.677357] CPU    2: hi:  186, btch:  31 usd:   0
[3339303.677359] CPU    3: hi:  186, btch:  31 usd:   0
[3339303.677362] active_anon:449191 inactive_anon:150255 isolated_anon:0
[3339303.677362]  active_file:396149 inactive_file:328223 isolated_file:0
[3339303.677362]  unevictable:0 dirty:40 writeback:0 unstable:0
[3339303.677362]  free:340389 slab_reclaimable:37797
slab_unreclaimable:19313
[3339303.677362]  mapped:29856 shmem:4393 pagetables:11977 bounce:0
[3339303.677367] DMA free:15904kB min:136kB low:168kB high:204kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15680kB mloc
ked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? y
es
[3339303.677368] lowmem_reserve[]: 0 2448 7483 7483
[3339303.677375] DMA32 free:643040kB min:22072kB low:27588kB
high:33108kB active_anon:301780kB inactive_anon:206324kB
active_file:460716kB inactive_file:591908kB unevictable:0kB
isolated(anon):0kB isolated(f
ile):0kB present:2507728kB mlocked:0kB dirty:44kB writeback:0kB
mapped:31052kB shmem:3608kB slab_reclaimable:48480kB
slab_unreclaimable:14636kB kernel_stack:424kB pagetables:5368kB
unstable:0kB bounce:0kB wr
iteback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[3339303.677376] lowmem_reserve[]: 0 0 5034 5034
[3339303.677381] Normal free:702612kB min:45372kB low:56712kB
high:68056kB active_anon:1494984kB inactive_anon:394696kB
active_file:1123880kB inactive_file:720984kB unevictable:0kB
isolated(anon):0kB isolate
d(file):0kB present:5155036kB mlocked:0kB dirty:116kB writeback:0kB
mapped:88372kB shmem:13964kB slab_reclaimable:102708kB
slab_unreclaimable:62616kB kernel_stack:3760kB pagetables:42540kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[3339303.677383] lowmem_reserve[]: 0 0 0 0
[3339303.677385] DMA: 0*4kB 0*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15904kB
[3339303.677391] DMA32: 58639*4kB 34494*8kB 7486*16kB 400*32kB 1*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 643148kB
[3339303.677396] Normal: 105233*4kB 31512*8kB 1833*16kB 12*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 702740kB
[3339303.677401] 737085 total pagecache pages
[3339303.677402] 8248 pages in swap cache
[3339303.677404] Swap cache stats: add 115920, delete 107672, find
500538/506382
[3339303.677405] Free swap  = 3925036kB
[3339303.677405] Total swap = 4095984kB
[3339303.698299] 1961968 pages RAM
[3339303.698302] 75067 pages reserved
[3339303.698303] 201538 pages shared
[3339303.698304] 1418908 pages non-shared
[3339303.698306] SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
[3339303.698308]   cache: size-131072, object size: 131072, order: 5
[3339303.698310]   node 0: slabs: 5/5, objs: 5/5, free: 0
[3339303.724182] EXT4-fs (dm-13): mounted filesystem with ordered data
mode. Opts: (null)
[3339635.981847] ata8: exception Emask 0x10 SAct 0x0 SErr 0x10200 action
0xe frozen





Udo
