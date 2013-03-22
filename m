Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab3CVIbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:31:34 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:43377 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3CVIbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:31:11 -0400
Date: Fri, 22 Mar 2013 09:31:00 +0100
From: Nico Schottelius <nico-lkml-20130322@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] 3.8.3-2-ARCH
Message-ID: <20130322083100.GA12654@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-lkml-20130322@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: bento (Linux 3.8.3-2-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

when attaching an external USB disk I get the following
traceback and the kernel does not see the partitions [0].

sgdisk however is able to access the partition table [1]

Plugging it in again, makes the kernel see the partition table
(full dmesg attached)

Hardware this time is Lenovo X1 carbon - no more Apple stuff
coming from my side for a while.

Cheers,

Nico

p.s.: please cc on reply

[0]

[52536.209629] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[52536.311108] ehci-pci 0000:00:1a.0: setting latency timer to 64
[52536.311475] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[52536.414356] ehci-pci 0000:00:1d.0: setting latency timer to 64
[52536.414561] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[52536.427470] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[52536.517536] xhci_hcd 0000:00:14.0: setting latency timer to 64
[52536.524237] usb 3-1.2: new high-speed USB device number 7 using ehci-pci
[52536.723735] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[52536.770034] Initializing USB Mass Storage driver...
[52536.770549] scsi6 : usb-storage 3-1.2:1.0
[52536.770758] usbcore: registered new interface driver usb-storage
[52536.770762] USB Mass Storage support registered.
[52544.272683] scsi 6:0:0:0: Direct-Access     Samsung  STORY Station 3  1AJ1 PQ: 0 ANSI: 0
[52544.274383] sd 6:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[52544.275988] sd 6:0:0:0: [sdb] Write Protect is off
[52544.276002] sd 6:0:0:0: [sdb] Mode Sense: 23 00 00 00
[52544.277876] sd 6:0:0:0: [sdb] No Caching mode page present
[52544.277889] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[52544.282306] sd 6:0:0:0: [sdb] No Caching mode page present
[52544.282315] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[52544.284699] kworker/u:1: page allocation failure: order:4, mode:0x10c0d0
[52544.284711] Pid: 12117, comm: kworker/u:1 Tainted: G        W    3.8.3-2-ARCH #1
[52544.284716] Call Trace:
[52544.284739]  [<ffffffff811292f9>] warn_alloc_failed+0xe9/0x140
[52544.284753]  [<ffffffff8112c776>] ? drain_local_pages+0x16/0x20
[52544.284766]  [<ffffffff8112cf88>] __alloc_pages_nodemask+0x7b8/0xa40
[52544.284782]  [<ffffffff8116a7a8>] alloc_pages_current+0xb8/0x180
[52544.284793]  [<ffffffff811285ce>] __get_free_pages+0xe/0x50
[52544.284803]  [<ffffffff81171e59>] kmalloc_order_trace+0x39/0xf0
[52544.284818]  [<ffffffff8125f620>] check_partition+0x30/0x210
[52544.284829]  [<ffffffff8125f35d>] rescan_partitions+0xad/0x290
[52544.284843]  [<ffffffff811c68f6>] __blkdev_get+0x306/0x4d0
[52544.284854]  [<ffffffff811a5d48>] ? find_inode+0x38/0xb0
[52544.284865]  [<ffffffff811c6c55>] blkdev_get+0x195/0x2f0
[52544.284873]  [<ffffffff811a6069>] ? unlock_new_inode+0x59/0x80
[52544.284884]  [<ffffffff811c5410>] ? bdget+0x130/0x150
[52544.284895]  [<ffffffff8125cbc4>] add_disk+0x3a4/0x490
[52544.284932]  [<ffffffffa004b3c9>] sd_probe_async+0x129/0x1e0 [sd_mod]
[52544.284954]  [<ffffffff810831ba>] async_run_entry_fn+0xaa/0x1c0
[52544.284966]  [<ffffffff81075e6a>] process_one_work+0x15a/0x4e0
[52544.284976]  [<ffffffff810765cd>] worker_thread+0x15d/0x400
[52544.284986]  [<ffffffff81076470>] ? rescuer_thread+0x240/0x240
[52544.284998]  [<ffffffff8107b2f0>] kthread+0xc0/0xd0
[52544.285011]  [<ffffffff81010000>] ? perf_trace_xen_mmu_set_pte_at+0x10/0x100
[52544.285023]  [<ffffffff8107b230>] ? kthread_freezable_should_stop+0x70/0x70
[52544.285035]  [<ffffffff814da6ec>] ret_from_fork+0x7c/0xb0
[52544.285046]  [<ffffffff8107b230>] ? kthread_freezable_should_stop+0x70/0x70
[52544.285052] Mem-Info:
[52544.285057] Node 0 DMA per-cpu:
[52544.285065] CPU    0: hi:    0, btch:   1 usd:   0
[52544.285071] CPU    1: hi:    0, btch:   1 usd:   0
[52544.285076] CPU    2: hi:    0, btch:   1 usd:   0
[52544.285080] CPU    3: hi:    0, btch:   1 usd:   0
[52544.285084] Node 0 DMA32 per-cpu:
[52544.285091] CPU    0: hi:  186, btch:  31 usd:   0
[52544.285097] CPU    1: hi:  186, btch:  31 usd:   0
[52544.285102] CPU    2: hi:  186, btch:  31 usd:   0
[52544.285107] CPU    3: hi:  186, btch:  31 usd:   0
[52544.285110] Node 0 Normal per-cpu:
[52544.285117] CPU    0: hi:  186, btch:  31 usd:   0
[52544.285122] CPU    1: hi:  186, btch:  31 usd:   0
[52544.285127] CPU    2: hi:  186, btch:  31 usd:   0
[52544.285132] CPU    3: hi:  186, btch:  31 usd:   0
[52544.285146] active_anon:325339 inactive_anon:53539 isolated_anon:0
 active_file:396016 inactive_file:376501 isolated_file:0
 unevictable:2261 dirty:142 writeback:0 unstable:0
 free:142486 slab_reclaimable:661015 slab_unreclaimable:10370
 mapped:21500 shmem:54173 pagetables:8360 bounce:0
 free_cma:0
[52544.285160] Node 0 DMA free:15844kB min:128kB low:160kB high:192kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15308kB managed:15844kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52544.285177] lowmem_reserve[]: 0 3359 7870 7870
[52544.285188] Node 0 DMA32 free:502696kB min:28796kB low:35992kB high:43192kB active_anon:110992kB inactive_anon:2412kB active_file:541116kB inactive_file:436276kB unevictable:1340kB isolated(anon):0kB isolated(file):0kB present:3440584kB managed:3413984kB mlocked:1340kB dirty:36kB writeback:0kB mapped:10388kB shmem:2640kB slab_reclaimable:1818528kB slab_unreclaimable:1892kB kernel_stack:352kB pagetables:1988kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[52544.285207] lowmem_reserve[]: 0 0 4510 4510
[52544.285217] Node 0 Normal free:51404kB min:38656kB low:48320kB high:57984kB active_anon:1190364kB inactive_anon:211744kB active_file:1042948kB inactive_file:1069728kB unevictable:7704kB isolated(anon):0kB isolated(file):0kB present:4618656kB managed:4559244kB mlocked:7704kB dirty:532kB writeback:0kB mapped:75612kB shmem:214052kB slab_reclaimable:825532kB slab_unreclaimable:39588kB kernel_stack:2600kB pagetables:31452kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[52544.285234] lowmem_reserve[]: 0 0 0 0
[52544.285244] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 3*64kB (U) 2*128kB (U) 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15844kB
[52544.285283] Node 0 DMA32: 29021*4kB (UEMR) 22970*8kB (UEMR) 12419*16kB (UEMR) 102*32kB (UEMR) 18*64kB (UEM) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 502964kB
[52544.285317] Node 0 Normal: 12354*4kB (UEM) 275*8kB (UEM) 5*16kB (UEM) 4*32kB (UEM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 51824kB
[52544.285350] 827517 total pagecache pages
[52544.285355] 0 pages in swap cache
[52544.285361] Swap cache stats: add 0, delete 0, find 0/0
[52544.285365] Free swap  = 0kB
[52544.285369] Total swap = 0kB
[52544.367333] 2090480 pages RAM
[52544.367340] 91490 pages reserved
[52544.367345] 2452953 pages shared
[52544.367350] 1171799 pages non-shared
[52544.371026] sd 6:0:0:0: [sdb] No Caching mode page present
[52544.371036] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[52544.371042] sd 6:0:0:0: [sdb] Attached SCSI disk

[1]

[root@bento cups]# gdisk -l /dev/sdb 
GPT fdisk (gdisk) version 0.8.6

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdb: 1953525168 sectors, 931.5 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 2E559C3A-84AE-4A21-B658-0B286B9A72AF
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 1953525134
Partitions will be aligned on 8-sector boundaries
Total free space is 262157 sectors (128.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1              40          409639   200.0 MiB   EF00  EFI System Partition
   2          409640       977172223   465.8 GiB   AF05  mac
   3       977172224       977434367   128.0 MiB   AB00  Booter 0x43773a38
   4       977434368      1953262983   465.3 GiB   AF00  linux
[root@bento cups]# 


-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.3.8.3-no-partition-table"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.3-2-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2 (GCC) ) #1 SMP PREEMPT Sun Mar 17 13:04:22 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-linux root=UUID=b6447d93-d19f-4f08-bb5f-e0b02825e43a ro cryptdevice=/dev/sda3:root video=SVIDEO-1:d
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d0025fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d0026000-0x00000000d0227fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d0228000-0x00000000d6949fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d694a000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000021e600000-0x000000021e7fffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by Lenovo
[    0.000000] efi:  ACPI=0xdaffe000  ACPI 2.0=0xdaffe014  SMBIOS=0xdae9e000 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x000000000005a000) (0MB)
[    0.000000] efi: mem02: type=4, attr=0xf, range=[0x000000000005a000-0x000000000005c000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x000000000005c000-0x0000000000087000) (0MB)
[    0.000000] efi: mem04: type=4, attr=0xf, range=[0x0000000000087000-0x0000000000088000) (0MB)
[    0.000000] efi: mem05: type=3, attr=0xf, range=[0x0000000000088000-0x0000000000090000) (0MB)
[    0.000000] efi: mem06: type=0, attr=0xf, range=[0x0000000000090000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem07: type=3, attr=0xf, range=[0x0000000000100000-0x0000000000110000) (0MB)
[    0.000000] efi: mem08: type=2, attr=0xf, range=[0x0000000000110000-0x0000000001011000) (15MB)
[    0.000000] efi: mem09: type=7, attr=0xf, range=[0x0000000001011000-0x0000000002000000) (15MB)
[    0.000000] efi: mem10: type=2, attr=0xf, range=[0x0000000002000000-0x0000000002f01000) (15MB)
[    0.000000] efi: mem11: type=7, attr=0xf, range=[0x0000000002f01000-0x0000000020000000) (464MB)
[    0.000000] efi: mem12: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x0000000020200000-0x000000003773a000) (373MB)
[    0.000000] efi: mem14: type=2, attr=0xf, range=[0x000000003773a000-0x0000000037b95000) (4MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x0000000037b95000-0x0000000040004000) (132MB)
[    0.000000] efi: mem16: type=0, attr=0xf, range=[0x0000000040004000-0x0000000040005000) (0MB)
[    0.000000] efi: mem17: type=7, attr=0xf, range=[0x0000000040005000-0x0000000099154000) (1425MB)
[    0.000000] efi: mem18: type=2, attr=0xf, range=[0x0000000099154000-0x00000000cd9f7000) (840MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x00000000cd9f7000-0x00000000cda17000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x00000000cda17000-0x00000000d0010000) (37MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x00000000d0010000-0x00000000d0026000) (0MB)
[    0.000000] efi: mem22: type=0, attr=0xf, range=[0x00000000d0026000-0x00000000d0228000) (2MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x00000000d0228000-0x00000000d09e7000) (7MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x00000000d09e7000-0x00000000d0bd9000) (1MB)
[    0.000000] efi: mem25: type=1, attr=0xf, range=[0x00000000d0bd9000-0x00000000d0bf6000) (0MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x00000000d0bf6000-0x00000000d2c40000) (32MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x00000000d2c40000-0x00000000d30c1000) (4MB)
[    0.000000] efi: mem28: type=7, attr=0xf, range=[0x00000000d30c1000-0x00000000d3295000) (1MB)
[    0.000000] efi: mem29: type=4, attr=0xf, range=[0x00000000d3295000-0x00000000d404a000) (13MB)
[    0.000000] efi: mem30: type=7, attr=0xf, range=[0x00000000d404a000-0x00000000d4092000) (0MB)
[    0.000000] efi: mem31: type=4, attr=0xf, range=[0x00000000d4092000-0x00000000d40bc000) (0MB)
[    0.000000] efi: mem32: type=7, attr=0xf, range=[0x00000000d40bc000-0x00000000d40bd000) (0MB)
[    0.000000] efi: mem33: type=4, attr=0xf, range=[0x00000000d40bd000-0x00000000d4167000) (0MB)
[    0.000000] efi: mem34: type=7, attr=0xf, range=[0x00000000d4167000-0x00000000d4170000) (0MB)
[    0.000000] efi: mem35: type=4, attr=0xf, range=[0x00000000d4170000-0x00000000d4171000) (0MB)
[    0.000000] efi: mem36: type=7, attr=0xf, range=[0x00000000d4171000-0x00000000d4172000) (0MB)
[    0.000000] efi: mem37: type=4, attr=0xf, range=[0x00000000d4172000-0x00000000d45cc000) (4MB)
[    0.000000] efi: mem38: type=7, attr=0xf, range=[0x00000000d45cc000-0x00000000d45de000) (0MB)
[    0.000000] efi: mem39: type=4, attr=0xf, range=[0x00000000d45de000-0x00000000d5f4a000) (25MB)
[    0.000000] efi: mem40: type=7, attr=0xf, range=[0x00000000d5f4a000-0x00000000d6080000) (1MB)
[    0.000000] efi: mem41: type=2, attr=0xf, range=[0x00000000d6080000-0x00000000d608a000) (0MB)
[    0.000000] efi: mem42: type=3, attr=0xf, range=[0x00000000d608a000-0x00000000d694a000) (8MB)
[    0.000000] efi: mem43: type=5, attr=0x800000000000000f, range=[0x00000000d694a000-0x00000000d6a1f000) (0MB)
[    0.000000] efi: mem44: type=5, attr=0x800000000000000f, range=[0x00000000d6a1f000-0x00000000d6b4a000) (1MB)
[    0.000000] efi: mem45: type=6, attr=0x800000000000000f, range=[0x00000000d6b4a000-0x00000000d76f8000) (11MB)
[    0.000000] efi: mem46: type=6, attr=0x800000000000000f, range=[0x00000000d76f8000-0x00000000da59f000) (46MB)
[    0.000000] efi: mem47: type=0, attr=0xf, range=[0x00000000da59f000-0x00000000dabf0000) (6MB)
[    0.000000] efi: mem48: type=0, attr=0xf, range=[0x00000000dabf0000-0x00000000dae9b000) (2MB)
[    0.000000] efi: mem49: type=0, attr=0xf, range=[0x00000000dae9b000-0x00000000dae9d000) (0MB)
[    0.000000] efi: mem50: type=0, attr=0xf, range=[0x00000000dae9d000-0x00000000dae9f000) (0MB)
[    0.000000] efi: mem51: type=10, attr=0xf, range=[0x00000000dae9f000-0x00000000daef5000) (0MB)
[    0.000000] efi: mem52: type=10, attr=0xf, range=[0x00000000daef5000-0x00000000daf9f000) (0MB)
[    0.000000] efi: mem53: type=9, attr=0xf, range=[0x00000000daf9f000-0x00000000dafd9000) (0MB)
[    0.000000] efi: mem54: type=9, attr=0xf, range=[0x00000000dafd9000-0x00000000dafff000) (0MB)
[    0.000000] efi: mem55: type=4, attr=0xf, range=[0x00000000dafff000-0x00000000db000000) (0MB)
[    0.000000] efi: mem56: type=7, attr=0xf, range=[0x0000000100000000-0x000000021e600000) (4582MB)
[    0.000000] efi: mem57: type=0, attr=0x0, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
[    0.000000] efi: mem58: type=0, attr=0x0, range=[0x00000000db000000-0x00000000dfa00000) (74MB)
[    0.000000] efi: mem59: type=11, attr=0x8000000000000001, range=[0x00000000f80f8000-0x00000000f80f9000) (0MB)
[    0.000000] efi: mem60: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem61: type=0, attr=0x0, range=[0x000000021e600000-0x000000021e800000) (2MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: LENOVO 34601K4/34601K4, BIOS G6ET90WW (2.50 ) 12/26/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21F000000 mask FFF000000 uncachable
[    0.000000]   9 base 21E800000 mask FFF800000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000050000] 50000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xdaffffff]
[    0.000000]  [mem 0x00000000-0xdaffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xdaffffff @ [mem 0x1fffb000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x21e5fffff]
[    0.000000]  [mem 0x100000000-0x21e5fffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x21e5fffff @ [mem 0xd6084000-0xd6089fff]
[    0.000000] RAMDISK: [mem 0x3773a000-0x37b94fff]
[    0.000000] ACPI: RSDP 00000000daffe014 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe170 000C4 (v01 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: FACP 00000000dafe8000 0010C (v05 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafea000 0FC06 (v01 LENOVO TP-G6    00002500 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf5a000 00040
[    0.000000] ACPI: TCPA 00000000daffd000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000daffc000 00408 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffb000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 00797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe6000 00038 (v01 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe5000 00098 (v01 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe4000 0003C (v01 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe3000 00052 (v01 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: FPDT 00000000dafe2000 00064 (v01 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafe9000 000A5 (v32 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafe1000 0003E (v01 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafe0000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: POAT 00000000dafdf000 00055 (v03 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: SSDT 00000000dafde000 00C1A (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafdd000 00A83 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dafdc000 000B8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dafdb000 002A6 (v01 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: SSDT 00000000dafda000 00379 (v01 LENOVO AoacTabl 00001000 INTL 20061109)
[    0.000000] ACPI: DBG2 00000000dafd9000 000B4 (v00 LENOVO TP-G6    00002500 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21e5fffff]
[    0.000000]   NODE_DATA [mem 0x21e5fb000-0x21e5fffff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880215c00000-ffff88021dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0008ffff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd0025fff]
[    0.000000]   node   0: [mem 0xd0228000-0xd6949fff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21e5fffff]
[    0.000000] On node 0 totalpages: 2050760
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 77 pages reserved
[    0.000000]   DMA zone: 3827 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13654 pages used for memmap
[    0.000000]   DMA32 zone: 860146 pages, LIFO batch:31
[    0.000000]   Normal zone: 18328 pages used for memmap
[    0.000000]   Normal zone: 1154664 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000090000 - 00000000000c0000
[    0.000000] PM: Registered nosave memory: 00000000000c0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040004000 - 0000000040005000
[    0.000000] PM: Registered nosave memory: 00000000d0026000 - 00000000d0228000
[    0.000000] PM: Registered nosave memory: 00000000d694a000 - 00000000dae9f000
[    0.000000] PM: Registered nosave memory: 00000000dae9f000 - 00000000daf9f000
[    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
[    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f80f8000
[    0.000000] PM: Registered nosave memory: 00000000f80f8000 - 00000000f80f9000
[    0.000000] PM: Registered nosave memory: 00000000f80f9000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 0000000100000000
[    0.000000] e820: [mem 0xdfa00000-0xf80f7fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88021e200000 s85056 r8192 d21440 u262144
[    0.000000] pcpu-alloc: s85056 r8192 d21440 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2018637
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-linux root=UUID=b6447d93-d19f-4f08-bb5f-e0b02825e43a ro cryptdevice=/dev/sda3:root video=SVIDEO-1:d
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7921692k/8886272k available (4985k kernel code, 683232k absent, 281348k reserved, 3946k data, 820k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 2494.193 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4990.23 BogoMIPS (lpj=8313976)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.037008] Security Framework initialized
[    0.037018] AppArmor: AppArmor disabled by boot time parameter
[    0.037578] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.040148] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.041294] Mount-cache hash table entries: 256
[    0.041488] Initializing cgroup subsys cpuacct
[    0.041491] Initializing cgroup subsys memory
[    0.041499] Initializing cgroup subsys devices
[    0.041501] Initializing cgroup subsys freezer
[    0.041502] Initializing cgroup subsys net_cls
[    0.041504] Initializing cgroup subsys blkio
[    0.041533] CPU: Physical Processor ID: 0
[    0.041534] CPU: Processor Core ID: 0
[    0.041539] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.042006] mce: CPU supports 7 MCE banks
[    0.042019] CPU0: Thermal monitoring enabled (TM1)
[    0.042026] process: using mwait in idle threads
[    0.042030] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 1
[    0.042236] Freeing SMP alternatives: 20k freed
[    0.043423] ACPI: Core revision 20121018
[    0.055106] ftrace: allocating 19367 entries in 76 pages
[    0.066130] dmar: Host address width 36
[    0.066132] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.066141] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.066143] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.066148] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.066150] dmar: RMRR base: 0x000000da3ba000 end: 0x000000da3d0fff
[    0.066151] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.066225] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.066227] HPET id 0 under DRHD base 0xfed91000
[    0.066405] Enabled IRQ remapping in x2apic mode
[    0.066407] Enabling x2apic
[    0.066408] Enabled x2apic
[    0.066418] Switched APIC routing to cluster x2apic.
[    0.066887] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.099848] smpboot: CPU0: Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz (fam: 06, model: 3a, stepping: 09)
[    0.099859] TSC deadline timer enabled
[    0.099863] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.099870] ... version:                3
[    0.099871] ... bit width:              48
[    0.099872] ... generic registers:      4
[    0.099873] ... value mask:             0000ffffffffffff
[    0.099874] ... max period:             000000007fffffff
[    0.099876] ... fixed-purpose events:   3
[    0.099877] ... event mask:             000000070000000f
[    0.137115] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.123270] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.177734] Brought up 4 CPUs
[    0.177739] smpboot: Total of 4 processors activated (19961.94 BogoMIPS)
[    0.182582] devtmpfs: initialized
[    0.184007] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.184783] RTC time:  4:44:31, date: 03/21/13
[    0.184827] NET: Registered protocol family 16
[    0.184972] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.184974] ACPI: bus type pci registered
[    0.185180] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.185183] PCI: not using MMCONFIG
[    0.185185] PCI: Using configuration type 1 for base access
[    0.185818] bio: create slab <bio-0> at 0
[    0.185876] ACPI: Added _OSI(Module Device)
[    0.185878] ACPI: Added _OSI(Processor Device)
[    0.185880] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.185881] ACPI: Added _OSI(Processor Aggregator Device)
[    0.187667] ACPI: EC: EC description table is found, configuring boot EC
[    0.192830] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.196463] ACPI: SSDT 00000000dae3a018 00A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.196919] ACPI: Dynamic OEM Table Load:
[    0.196922] ACPI: SSDT           (null) 00A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.197214] ACPI: SSDT 00000000dae3ba98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.197699] ACPI: Dynamic OEM Table Load:
[    0.197701] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.197838] ACPI: SSDT 00000000dae39d98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.198284] ACPI: Dynamic OEM Table Load:
[    0.198286] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.198949] ACPI: Interpreter enabled
[    0.198952] ACPI: (supports S0 S3 S4 S5)
[    0.198971] ACPI: Using IOAPIC for interrupt routing
[    0.198987] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.199514] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.210316] ACPI: Power Resource [PUBS] (on)
[    0.213781] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.214680] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.214685] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.214706] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.214708] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.214888] pci_root PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.214988] pci_root PNP0A08:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.215047] PCI host bridge to bus 0000:00
[    0.215050] pci_bus 0000:00: root bus resource [bus 00-3f]
[    0.215052] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.215054] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.215056] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.215058] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.215060] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.215069] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.215118] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.215130] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.215137] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.215143] pci 0000:00:02.0: reg 20: [io  0x4000-0x403f]
[    0.215203] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.215228] pci 0000:00:14.0: reg 10: [mem 0xf1500000-0xf150ffff 64bit]
[    0.215306] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.215334] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.215359] pci 0000:00:16.0: reg 10: [mem 0xf1515000-0xf151500f 64bit]
[    0.215443] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.215472] pci 0000:00:16.3: [8086:1e3d] type 00 class 0x070002
[    0.215493] pci 0000:00:16.3: reg 10: [io  0x4090-0x4097]
[    0.215504] pci 0000:00:16.3: reg 14: [mem 0xf151b000-0xf151bfff]
[    0.215615] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.215645] pci 0000:00:1a.0: reg 10: [mem 0xf151a000-0xf151a3ff]
[    0.215743] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.215771] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.215788] pci 0000:00:1b.0: reg 10: [mem 0xf1510000-0xf1513fff 64bit]
[    0.215864] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.215895] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.216025] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.216065] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.216195] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.216248] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.216272] pci 0000:00:1d.0: reg 10: [mem 0xf1519000-0xf15193ff]
[    0.216370] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.216400] pci 0000:00:1f.0: [8086:1e56] type 00 class 0x060100
[    0.216534] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.216554] pci 0000:00:1f.2: reg 10: [io  0x4088-0x408f]
[    0.216563] pci 0000:00:1f.2: reg 14: [io  0x409c-0x409f]
[    0.216573] pci 0000:00:1f.2: reg 18: [io  0x4080-0x4087]
[    0.216582] pci 0000:00:1f.2: reg 1c: [io  0x4098-0x409b]
[    0.216591] pci 0000:00:1f.2: reg 20: [io  0x4060-0x407f]
[    0.216600] pci 0000:00:1f.2: reg 24: [mem 0xf1518000-0xf15187ff]
[    0.216649] pci 0000:00:1f.2: PME# supported from D3hot
[    0.216672] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.216690] pci 0000:00:1f.3: reg 10: [mem 0xf1514000-0xf15140ff 64bit]
[    0.216713] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.216920] pci 0000:02:00.0: [1180:e822] type 00 class 0x088001
[    0.216940] pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[    0.216968] pci 0000:02:00.0: reg 10: [mem 0xf0d00000-0xf0d000ff]
[    0.217173] pci 0000:02:00.0: supports D1 D2
[    0.217175] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.225825] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.225831] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.225836] pci 0000:00:1c.0:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.225846] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.226082] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.226264] pci 0000:03:00.0: reg 10: [mem 0xf0c00000-0xf0c01fff 64bit]
[    0.226992] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.235758] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.235768] pci 0000:00:1c.1:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.235811] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.235844] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.235884] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.237738] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.237794] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.237846] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.237898] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.237946] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.237997] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.238047] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.238096] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.238187] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.238191] vgaarb: loaded
[    0.238192] vgaarb: bridge control possible 0000:00:02.0
[    0.238228] PCI: Using ACPI for IRQ routing
[    0.239963] PCI: pci_cache_line_size set to 64 bytes
[    0.240304] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.240306] e820: reserve RAM buffer [mem 0xd0026000-0xd3ffffff]
[    0.240307] e820: reserve RAM buffer [mem 0xd694a000-0xd7ffffff]
[    0.240309] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.240310] e820: reserve RAM buffer [mem 0x21e600000-0x21fffffff]
[    0.240405] NetLabel: Initializing
[    0.240406] NetLabel:  domain hash size = 128
[    0.240407] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.240419] NetLabel:  unlabeled traffic allowed by default
[    0.240440] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.240445] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.243457] Switching to clocksource hpet
[    0.248094] pnp: PnP ACPI init
[    0.248108] ACPI: bus type pnp registered
[    0.248513] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.248517] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.248519] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.248521] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.248523] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.248525] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.248527] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.248530] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.248532] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.248535] system 00:00: [mem 0x000e0000-0x000e3fff] has been reserved
[    0.248538] system 00:00: [mem 0x000e4000-0x000e7fff] has been reserved
[    0.248540] system 00:00: [mem 0x000e8000-0x000ebfff] has been reserved
[    0.248542] system 00:00: [mem 0x000ec000-0x000effff] has been reserved
[    0.248544] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.248546] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.248549] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.248551] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.248555] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.248604] pnp 00:01: Plug and Play ACPI device, IDs PNP0c40 (active)
[    0.248644] pnp 00:02: Plug and Play ACPI device, IDs PNP0c60 (active)
[    0.248744] system 00:03: [io  0x0400-0x047f] has been reserved
[    0.248747] system 00:03: [io  0x0500-0x057f] has been reserved
[    0.248749] system 00:03: [io  0x0800-0x080f] has been reserved
[    0.248751] system 00:03: [io  0x15e0-0x15ef] has been reserved
[    0.248753] system 00:03: [io  0x1600-0x167f] has been reserved
[    0.248756] system 00:03: [mem 0xf8000000-0xfbffffff] could not be reserved
[    0.248759] system 00:03: [mem 0xfffff000-0xffffffff] has been reserved
[    0.248761] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.248763] system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.248765] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.248768] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.248770] system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.248773] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.248835] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.248846] pnp 00:05: [dma 4]
[    0.248866] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.248890] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.248927] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.248959] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.248992] pnp 00:09: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
[    0.249025] pnp 00:0a: Plug and Play ACPI device, IDs LEN0030 PNP0f13 (active)
[    0.249075] pnp 00:0b: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.249445] pnp: PnP ACPI: found 12 devices
[    0.249447] ACPI: ACPI bus type pnp unregistered
[    0.256233] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.256242] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.256249] pci 0000:00:1c.0:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.256255] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.256264] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.256271] pci 0000:00:1c.1:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.256314] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.256316] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.256318] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.256320] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.256322] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.256324] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.256326] pci_bus 0000:02: resource 1 [mem 0xf0d00000-0xf14fffff]
[    0.256328] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.256330] pci_bus 0000:03: resource 1 [mem 0xf0c00000-0xf0cfffff]
[    0.256365] NET: Registered protocol family 2
[    0.256557] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.256771] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.256921] TCP: Hash tables configured (established 65536 bind 65536)
[    0.256940] TCP: reno registered
[    0.256954] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.256985] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.257062] NET: Registered protocol family 1
[    0.257073] pci 0000:00:02.0: Boot video device
[    0.257336] PCI: CLS 64 bytes, default 64
[    0.257372] Unpacking initramfs...
[    0.348619] Freeing initrd memory: 4460k freed
[    0.349183] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.349186] software IO TLB [mem 0xc99f7000-0xcd9f7000] (64MB) mapped at [ffff8800c99f7000-ffff8800cd9f6fff]
[    0.349566] audit: initializing netlink socket (disabled)
[    0.349576] type=2000 audit(1363841071.309:1): initialized
[    0.364671] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.366295] VFS: Disk quotas dquot_6.5.2
[    0.366338] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.366519] msgmni has been set to 15612
[    0.366791] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.366835] io scheduler noop registered
[    0.366838] io scheduler deadline registered
[    0.366844] io scheduler cfq registered (default)
[    0.367138] efifb: invalid framebuffer address
[    0.367157] ------------[ cut here ]------------
[    0.367163] WARNING: at drivers/base/core.c:228 device_release+0xa2/0xb0()
[    0.367164] Hardware name: 34601K4
[    0.367165] Device 'efifb.0' does not have a release() function, it is broken and must be fixed.
[    0.367171] Modules linked in:
[    0.367174] Pid: 1, comm: swapper/0 Not tainted 3.8.3-2-ARCH #1
[    0.367176] Call Trace:
[    0.367181]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[    0.367184]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[    0.367187]  [<ffffffff81355fa2>] device_release+0xa2/0xb0
[    0.367191]  [<ffffffff812751db>] kobject_release+0x8b/0x1d0
[    0.367195]  [<ffffffff81900169>] ? efifb_probe+0x498/0x498
[    0.367197]  [<ffffffff8127505c>] kobject_put+0x2c/0x60
[    0.367201]  [<ffffffff81355c77>] put_device+0x17/0x20
[    0.367204]  [<ffffffff8135c917>] platform_device_put+0x17/0x20
[    0.367207]  [<ffffffff8135c93e>] platform_device_unregister+0x1e/0x30
[    0.367210]  [<ffffffff819003ef>] efifb_init+0x286/0x292
[    0.367214]  [<ffffffff81900169>] ? efifb_probe+0x498/0x498
[    0.367217]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
[    0.367221]  [<ffffffff818d0d96>] kernel_init_freeable+0x13e/0x1c8
[    0.367224]  [<ffffffff818d0611>] ? do_early_param+0x8d/0x8d
[    0.367227]  [<ffffffff814b5d10>] ? rest_init+0x90/0x90
[    0.367230]  [<ffffffff814b5d1e>] kernel_init+0xe/0xf0
[    0.367233]  [<ffffffff814da6ec>] ret_from_fork+0x7c/0xb0
[    0.367236]  [<ffffffff814b5d10>] ? rest_init+0x90/0x90
[    0.367241] ---[ end trace 75372ac7934791a2 ]---
[    0.367244] intel_idle: MWAIT substates: 0x21120
[    0.367246] intel_idle: v0.4 model 0x3A
[    0.367247] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.367284] GHES: HEST is not enabled!
[    0.367338] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.388123] 0000:00:16.3: ttyS0 at I/O 0x4090 (irq = 19) is a 16550A
[    0.388337] Linux agpgart interface v0.103
[    0.388409] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.390036] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.390055] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.390178] mousedev: PS/2 mouse device common for all mice
[    0.390214] rtc_cmos 00:08: RTC can wake from S4
[    0.390348] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    0.390380] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.390476] cpuidle: using governor ladder
[    0.390600] cpuidle: using governor menu
[    0.390601] EFI Variables Facility v0.08 2004-May-17
[    0.392174] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.404020] drop_monitor: Initializing network drop monitor service
[    0.404096] TCP: cubic registered
[    0.404192] NET: Registered protocol family 10
[    0.404349] NET: Registered protocol family 17
[    0.404358] Key type dns_resolver registered
[    0.404621] PM: Hibernation image not present or could not be loaded.
[    0.404631] registered taskstats version 1
[    0.405487]   Magic number: 5:664:717
[    0.405588] rtc_cmos 00:08: setting system clock to 2013-03-21 04:44:31 UTC (1363841071)
[    0.407316] Freeing unused kernel memory: 820k freed
[    0.407434] Write protecting the kernel read-only data: 8192k
[    0.410929] Freeing unused kernel memory: 1148k freed
[    0.412434] Freeing unused kernel memory: 440k freed
[    0.419967] systemd-udevd[56]: starting version 198
[    0.422528] [drm] Initialized drm 1.1.0 20060810
[    0.423799] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.423961] ACPI: Lid Switch [LID]
[    0.424037] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.424044] ACPI: Sleep Button [SLPB]
[    0.424227] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.424232] ACPI: Power Button [PWRF]
[    0.428308] [drm] Memory usable by graphics device = 2048M
[    0.428315] i915 0000:00:02.0: setting latency timer to 64
[    0.470539] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.470547] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.470549] [drm] Driver supports precise vblank timestamp query.
[    0.470583] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.683007] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    0.749591] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    0.788281] fbcon: inteldrmfb (fb0) is primary device
[    1.348807] tsc: Refined TSC clocksource calibration: 2494.334 MHz
[    1.348811] Switching to clocksource tsc
[    1.611825] Console: switching to colour frame buffer device 200x56
[    1.615337] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.615340] i915 0000:00:02.0: registered panic notifier
[    1.637233] acpi device:00: registered as cooling_device0
[    1.637335] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.637439] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    1.637489] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.667612] sdhci: Secure Digital Host Controller Interface driver
[    1.667615] sdhci: Copyright(c) Pierre Ossman
[    1.667938] sdhci-pci 0000:02:00.0: SDHCI controller found [1180:e822] (rev 7)
[    1.668703] ACPI: bus type usb registered
[    1.668743] usbcore: registered new interface driver usbfs
[    1.668760] usbcore: registered new interface driver hub
[    1.668999] usbcore: registered new device driver usb
[    1.669523] SCSI subsystem initialized
[    1.669813] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    1.669822] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.669831] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.669940] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.669950] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf1500000
[    1.670026] xhci_hcd 0000:00:14.0: irq 43 for MSI/MSI-X
[    1.670130] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.670248] xHCI xhci_add_endpoint called for root hub
[    1.670251] xHCI xhci_check_bandwidth called for root hub
[    1.670305] hub 1-0:1.0: USB hub found
[    1.670319] hub 1-0:1.0: 4 ports detected
[    1.670466] ehci-pci: EHCI PCI platform driver
[    1.671777] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.671785] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.671964] xHCI xhci_add_endpoint called for root hub
[    1.671967] xHCI xhci_check_bandwidth called for root hub
[    1.672007] hub 2-0:1.0: USB hub found
[    1.672018] hub 2-0:1.0: 4 ports detected
[    1.672391] ACPI: bus type scsi registered
[    1.672447] libata version 3.00 loaded.
[    1.678542] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    1.678552] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.678565] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.678589] ehci-pci 0000:00:1a.0: debug port 2
[    1.682502] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.682515] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf151a000
[    1.691659] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.691922] hub 3-0:1.0: USB hub found
[    1.691929] hub 3-0:1.0: 3 ports detected
[    1.692122] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    1.692127] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.692132] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.692148] ehci-pci 0000:00:1d.0: debug port 2
[    1.696030] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.696051] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf1519000
[    1.698357] mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
[    1.704958] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.705198] hub 4-0:1.0: USB hub found
[    1.705203] hub 4-0:1.0: 3 ports detected
[    1.705377] ahci 0000:00:1f.2: version 3.0
[    1.705473] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    1.705541] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    1.705547] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    1.705555] ahci 0000:00:1f.2: setting latency timer to 64
[    1.706783] scsi0 : ahci
[    1.706878] scsi1 : ahci
[    1.706956] scsi2 : ahci
[    1.707031] scsi3 : ahci
[    1.707095] scsi4 : ahci
[    1.707155] scsi5 : ahci
[    1.707204] ata1: SATA max UDMA/133 abar m2048@0xf1518000 port 0xf1518100 irq 44
[    1.707206] ata2: DUMMY
[    1.707207] ata3: DUMMY
[    1.707208] ata4: DUMMY
[    1.707210] ata5: DUMMY
[    1.707211] ata6: DUMMY
[    1.997976] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    2.024606] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.025308] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.025313] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.028899] ata1.00: ATA-8: SanDisk SD5SG2256G1052E, 10.04.01, max UDMA/133
[    2.028904] ata1.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    2.029740] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.029746] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.030656] ata1.00: configured for UDMA/133
[    2.030919] scsi 0:0:0:0: Direct-Access     ATA      SanDisk SD5SG225 10.0 PQ: 0 ANSI: 5
[    2.035374] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    2.035488] sd 0:0:0:0: [sda] Write Protect is off
[    2.035493] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.035523] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.037523]  sda: sda1 sda2 sda3 sda4
[    2.038004] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.073642] device-mapper: uevent: version 1.0.3
[    2.073887] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    2.122832] hub 3-1:1.0: USB hub found
[    2.123108] hub 3-1:1.0: 6 ports detected
[    2.231008] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    2.355211] hub 4-1:1.0: USB hub found
[    2.355334] hub 4-1:1.0: 8 ports detected
[    2.387749] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    2.424443] usb 3-1.3: new full-speed USB device number 3 using ehci-pci
[    2.577439] usb 3-1.4: new full-speed USB device number 4 using ehci-pci
[    2.734056] usb 3-1.6: new high-speed USB device number 5 using ehci-pci
[    6.605100] bio: create slab <bio-1> at 1
[    6.689917] bio: create slab <bio-1> at 1
[    6.711738] Btrfs loaded
[    6.712282] device fsid b6447d93-d19f-4f08-bb5f-e0b02825e43a devid 1 transid 4496 /dev/dm-0
[    6.731346] device fsid b6447d93-d19f-4f08-bb5f-e0b02825e43a devid 1 transid 4496 /dev/mapper/root
[    6.732059] btrfs: disk space caching is enabled
[    6.796647] Btrfs detected SSD devices, enabling SSD mode
[    6.851761] systemd[1]: Smack is not enabled in the kernel, not loading access rules.
[    6.895046] systemd[1]: systemd 198 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    6.896051] systemd[1]: Set hostname to <bento>.
[    6.935600] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory. See system logs and 'systemctl status display-manager.service' for details.
[    6.935802] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    6.935859] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    6.935873] systemd[1]: Starting Remote File Systems.
[    6.936055] systemd[1]: Reached target Remote File Systems.
[    6.936066] systemd[1]: Starting LVM2 metadata daemon socket.
[    6.936178] systemd[1]: Listening on LVM2 metadata daemon socket.
[    6.936189] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    6.936292] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    6.936302] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    6.936398] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    6.936408] systemd[1]: Starting Delayed Shutdown Socket.
[    6.936503] systemd[1]: Listening on Delayed Shutdown Socket.
[    6.936515] systemd[1]: Starting Journal Socket.
[    6.936626] systemd[1]: Listening on Journal Socket.
[    6.937197] systemd[1]: Starting Apply Kernel Variables...
[    6.941676] systemd[1]: Starting Journal Service...
[    6.945306] systemd[1]: Started Journal Service.
[    6.945343] systemd[1]: Starting Setup Virtual Console...
[    6.954945] systemd[1]: Mounting Debug File System...
[    6.965574] systemd[1]: Started Load Kernel Modules.
[    6.965603] systemd[1]: Mounted FUSE Control File System.
[    6.965677] systemd[1]: Starting udev Kernel Socket.
[    6.965819] systemd[1]: Listening on udev Kernel Socket.
[    6.965881] systemd[1]: Starting udev Control Socket.
[    6.965977] systemd[1]: Listening on udev Control Socket.
[    6.966049] systemd[1]: Starting udev Kernel Device Manager...
[    6.991667] systemd[1]: Starting udev Coldplug all Devices...
[    7.014964] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    7.015005] systemd-udevd[197]: starting version 198
[    7.015282] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    7.015678] systemd[1]: Started Set Up Additional Binary Formats.
[    7.015704] systemd[1]: Mounting POSIX Message Queue File System...
[    7.029231] systemd[1]: Mounting Configuration File System...
[    7.031603] systemd[1]: Mounting Huge Pages File System...
[    7.038148] systemd[1]: Expecting device dev-mapper-root.device...
[    7.038270] systemd[1]: Expecting device dev-sda3.device...
[    7.038373] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    7.038455] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    7.038474] systemd[1]: Starting Swap.
[    7.038580] systemd[1]: Reached target Swap.
[    7.038639] systemd[1]: Starting File System Check on Root Device...
[    7.044876] systemd[1]: Expecting device dev-sda1.device...
[    7.044987] systemd[1]: Expecting device dev-sda4.device...
[    7.045414] systemd[1]: Started udev Kernel Device Manager.
[    7.054164] systemd[1]: Started Apply Kernel Variables.
[    7.054521] systemd[1]: Started Setup Virtual Console.
[    7.054725] systemd[1]: Mounted Debug File System.
[    7.061777] systemd[1]: Mounted POSIX Message Queue File System.
[    7.061931] systemd[1]: Mounted Configuration File System.
[    7.062076] systemd[1]: Mounted Huge Pages File System.
[    7.068233] systemd[1]: Started File System Check on Root Device.
[    7.068303] systemd[1]: Starting Remount Root and Kernel File Systems...
[    7.088807] btrfs: use ssd allocation scheme
[    7.088813] btrfs: disk space caching is enabled
[    7.094696] mei 0000:00:16.0: setting latency timer to 64
[    7.094803] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[    7.098275] systemd[1]: Started udev Coldplug all Devices.
[    7.104824] ACPI: Requesting acpi_cpufreq
[    7.120782] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    7.124772] systemd[1]: Started Remount Root and Kernel File Systems.
[    7.124824] systemd[1]: Starting Local File Systems (Pre).
[    7.124925] systemd[1]: Reached target Local File Systems (Pre).
[    7.124944] systemd[1]: Mounting /tmp...
[    7.125334] wmi: Mapper loaded
[    7.135274] systemd[1]: Starting Load Random Seed...
[    7.136618] thermal LNXTHERM:00: registered as thermal_zone0
[    7.136624] ACPI: Thermal Zone [THM0] (42 C)
[    7.140040] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[    7.152746] tpm_tis 00:0b: 1.2 TPM (device-id 0x0, rev-id 78)
[    7.153577] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    7.153761] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    7.153934] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    7.154856] Non-volatile memory driver v1.3
[    7.158220] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    7.158223] thinkpad_acpi: http://ibm-acpi.sf.net/
[    7.158225] thinkpad_acpi: ThinkPad BIOS G6ET90WW (2.50 ), EC unknown
[    7.158226] thinkpad_acpi: Lenovo ThinkPad X1 Carbon, model 34601K4
[    7.158672] systemd[1]: Mounted /tmp.
[    7.159641] ACPI: Battery Slot [BAT0] (battery present)
[    7.160214] ACPI: AC Adapter [AC] (on-line)
[    7.163257] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    7.163438] thinkpad_acpi: radio switch found; radios are enabled
[    7.163457] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[    7.163481] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    7.163483] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    7.166930] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    7.167595] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    7.168623] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    7.169334] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input9
[    7.174341] input: PC Speaker as /devices/platform/pcspkr/input/input10
[    7.178742] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    7.180373] media: Linux media interface: v0.10
[    7.183451] Linux video capture interface: v2.00
[    7.183791] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x16
[    7.187978] Bluetooth: Core ver 2.16
[    7.187992] NET: Registered protocol family 31
[    7.187993] Bluetooth: HCI device and connection manager initialized
[    7.188000] Bluetooth: HCI socket layer initialized
[    7.188002] Bluetooth: L2CAP socket layer initialized
[    7.188007] Bluetooth: SCO socket layer initialized
[    7.189144] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b315)
[    7.190443] usbcore: registered new interface driver btusb
[    7.198597] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.6/3-1.6:1.0/input/input11
[    7.198865] usbcore: registered new interface driver uvcvideo
[    7.198867] USB Video Class driver (1.1.1)
[    7.201803] systemd[1]: Found device SanDisk_SD5SG2256G1052E.
[    7.201823] systemd[1]: Starting Cryptography Setup for root...
[    7.214869] systemd[1]: Starting Sound Card.
[    7.215091] systemd[1]: Reached target Sound Card.
[    7.216108] systemd[1]: Found device SanDisk_SD5SG2256G1052E.
[    7.216133] systemd[1]: Starting File System Check on /dev/sda1...
[    7.227479] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x16
[    7.229326] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x16
[    7.229704] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x16
[    7.230054] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.236158] systemd[1]: Found device SanDisk_SD5SG2256G1052E.
[    7.236200] systemd[1]: Starting File System Check on /dev/sda4...
[    7.241283] device fsid b6447d93-d19f-4f08-bb5f-e0b02825e43a devid 1 transid 4496 /dev/dm-0
[    7.258809] systemd[1]: Started Cryptography Setup for root.
[    7.261938] systemd[1]: Started File System Check on /dev/sda1.
[    7.261966] systemd[1]: Mounting /boot...
[    7.271207] systemd[1]: Starting Encrypted Volumes.
[    7.272453] systemd[1]: Reached target Encrypted Volumes.
[    7.274562] systemd[1]: Starting Bluetooth.
[    7.276079] systemd[1]: Reached target Bluetooth.
[    7.278482] systemd[1]: Found device /dev/mapper/root.
[    7.288812] systemd[1]: Started File System Check on /dev/sda4.
[    7.296204] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: data=ordered
[    7.297172] systemd[1]: Mounted /boot.
[    7.297194] systemd[1]: Mounting /boot/efi...
[    7.332994] systemd[1]: Mounted /boot/efi.
[    7.333072] systemd[1]: Starting Local File Systems.
[    7.335625] systemd[1]: Reached target Local File Systems.
[    7.336212] systemd[1]: Starting Recreate Volatile Files and Directories...
[    7.347977] systemd[1]: Starting Trigger Flushing of Journal to Persistent Storage...
[    7.368547] systemd-journald[191]: Received SIGUSR1
[    7.376932] systemd[1]: Started Trigger Flushing of Journal to Persistent Storage.
[    7.393255] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20121018/utaddress-251)
[    7.393287] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.393307] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20121018/utaddress-251)
[    7.393333] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.393342] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20121018/utaddress-251)
[    7.393362] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    7.393370] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    7.421684] systemd[1]: Started Load Random Seed.
[    7.422954] iTCO_vendor_support: vendor-support=0
[    7.439805] cfg80211: Calling CRDA to update world regulatory domain
[    7.441278] systemd[1]: Started Recreate Volatile Files and Directories.
[    7.441378] systemd[1]: Starting System Initialization.
[    7.443598] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    7.443722] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    7.444119] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.444575] systemd[1]: Reached target System Initialization.
[    7.444629] systemd[1]: Starting D-Bus System Message Bus Socket.
[    7.451253] systemd[1]: Listening on D-Bus System Message Bus Socket.
[    7.451357] systemd[1]: Starting Sockets.
[    7.455615] systemd[1]: Reached target Sockets.
[    7.455653] systemd[1]: Starting Daily Cleanup of Temporary Directories.
[    7.455707] systemd[1]: Started Daily Cleanup of Temporary Directories.
[    7.455731] systemd[1]: Starting Restore Sound Card State...
[    7.470958] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    7.470965] Copyright(c) 2003-2012 Intel Corporation
[    7.471597] iwlwifi 0000:03:00.0: irq 47 for MSI/MSI-X
[    7.472956] systemd[1]: Starting Basic System.
[    7.475524] systemd[1]: Reached target Basic System.
[    7.494052] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
[    7.495528] systemd[1]: Started SSH Key Generation.
[    7.495670] systemd[1]: Starting OpenSSH Daemon...
[    7.531944] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    7.531949] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    7.531953] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[    7.531956] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    7.531960] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[    7.531966] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205S AGN, REV=0xB0
[    7.532100] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    7.533647] systemd[1]: Started OpenSSH Daemon.
[    7.533720] systemd[1]: Starting Wicd a wireless and wired network manager for Linux...
[    7.557619] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    7.559760] systemd[1]: Starting D-Bus System Message Bus...
[    7.580703] systemd-udevd[214]: renamed network interface wlan0 to wlp3s0
[    7.587847] systemd[1]: Started D-Bus System Message Bus.
[    7.588308] systemd[1]: Starting Permit User Sessions...
[    7.595602] systemd-journald[191]: File /var/log/journal/bbccba723cc6411ca206fb22d7313d31/system.journal corrupted or uncleanly shut down, renaming and replacing.
[    7.597683] systemd[1]: Starting Login Service...
[    7.621576] systemd[1]: Started Restore Sound Card State.
[    7.629950] systemd[1]: Started Permit User Sessions.
[    7.630045] systemd[1]: Starting Getty on tty1...
[    7.636762] systemd[1]: Started Getty on tty1.
[    7.636841] systemd[1]: Starting Login Prompts.
[    7.639297] systemd[1]: Reached target Login Prompts.
[    8.022481] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x127c00, board id: 2182, fw id: 1164733
[    8.022496] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    8.060005] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input12
[   10.402120] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   10.409008] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   10.811443] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   10.818389] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   11.046975] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[   13.185541] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.378483] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input13
[   20.294203] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   20.301199] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   20.537362] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[   20.571187] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   20.578121] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   20.813498] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[   26.041656] wlp3s0: authenticate with 0e:b0:5d:9c:37:13
[   26.048552] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[   26.052790] wlp3s0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[   26.055704] wlp3s0: authenticated
[   26.056825] wlp3s0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[   26.061575] wlp3s0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=3)
[   26.081813] wlp3s0: associated
[   26.081894] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[  109.065507] wlp3s0: deauthenticating from 0e:b0:5d:9c:37:13 by local choice (reason=3)
[  109.095260] cfg80211: Calling CRDA for country: CH
[  113.328495] PM: Syncing filesystems ... done.
[  113.441872] PM: Preparing system for mem sleep
[  113.902513] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  113.913176] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  113.926586] PM: Entering mem sleep
[  113.926731] Suspending console(s) (use no_console_suspend to debug)
[  114.062618] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  114.066861] sd 0:0:0:0: [sda] Stopping disk
[  114.642205] ACPI: Cannot transition to non-D0 state from D3
[  114.642288] PM: suspend of devices complete after 715.785 msecs
[  114.642809] PM: late suspend of devices complete after 0.517 msecs
[  114.655663] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[  114.668789] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[  114.668897] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[  114.682089] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[  114.695473] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  114.708715] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[  114.708866] PM: noirq suspend of devices complete after 66.137 msecs
[  114.709744] ACPI: Preparing to enter system sleep state S3
[  114.858570] PM: Saving platform NVS memory
[  114.868172] Disabling non-boot CPUs ...
[  114.971703] smpboot: CPU 1 is now offline
[  115.074903] smpboot: CPU 2 is now offline
[  115.178101] smpboot: CPU 3 is now offline
[  115.178732] Extended CMOS year: 2000
[  115.182039] ACPI: Low-level resume complete
[  115.182117] PM: Restoring platform NVS memory
[  115.182771] Extended CMOS year: 2000
[  115.182917] Enabling non-boot CPUs ...
[  115.186395] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  115.252239] CPU1 is up
[  115.252400] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  115.318817] CPU2 is up
[  115.318937] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  115.385453] CPU3 is up
[  115.394456] ACPI: Waking up from system sleep state S3
[  115.671753] i915 0000:00:02.0: power state changed by ACPI to D0
[  115.684888] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[  115.698253] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  115.724859] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[  115.738178] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  115.751712] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[  115.764809] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  115.791506] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  115.806001] PM: noirq resume of devices complete after 134.595 msecs
[  115.806451] PM: early resume of devices complete after 0.351 msecs
[  115.806516] i915 0000:00:02.0: setting latency timer to 64
[  115.806520] xhci_hcd 0000:00:14.0: setting latency timer to 64
[  115.806643] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[  115.806662] ehci-pci 0000:00:1a.0: setting latency timer to 64
[  115.806695] ehci-pci 0000:00:1d.0: setting latency timer to 64
[  115.806747] ahci 0000:00:1f.2: setting latency timer to 64
[  115.806932] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[  116.018137] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[  116.124370] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  116.125322] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  116.125329] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  116.127197] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  116.127204] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  116.127925] ata1.00: configured for UDMA/133
[  116.128112] sd 0:0:0:0: [sda] Starting disk
[  116.181106] usb 3-1.4: reset full-speed USB device number 4 using ehci-pci
[  116.266688] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[  116.266692] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[  116.310114] PM: resume of devices complete after 504.304 msecs
[  116.311821] PM: Finishing wakeup.
[  116.311824] Restarting tasks ... done.
[  116.318766] video LNXVIDEO:00: Restoring backlight state
[  117.219894] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[  389.396538] iwlwifi 0000:03:00.0: RF_KILL bit toggled to disable radio.
[  389.628639] usb 3-1.4: USB disconnect, device number 4
[  395.002587] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[  395.440046] usb 3-1.4: new full-speed USB device number 6 using ehci-pci
[  395.665228] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  395.672125] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  395.907986] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[  410.203574] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  410.210527] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  410.447805] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[  410.509247] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  410.516181] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  410.750123] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[  412.907166] wlp3s0: authenticate with 0e:b0:5d:9c:37:13
[  412.911017] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[  412.915301] wlp3s0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[  412.925105] wlp3s0: authenticated
[  412.927011] wlp3s0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[  412.944412] wlp3s0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=3)
[  412.980813] wlp3s0: associated
[  412.980884] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[ 1907.614458] fuse init (API version 7.20)
[ 6332.268253] PM: Syncing filesystems ... done.
[ 6332.475653] PM: Preparing system for mem sleep
[ 6332.914882] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 6332.928172] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 6332.941511] PM: Entering mem sleep
[ 6332.941656] Suspending console(s) (use no_console_suspend to debug)
[ 6333.097736] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 6333.102003] sd 0:0:0:0: [sda] Stopping disk
[ 6333.690395] i915 0000:00:02.0: power state changed by ACPI to D3hot
[ 6333.690477] PM: suspend of devices complete after 749.012 msecs
[ 6333.691004] PM: late suspend of devices complete after 0.522 msecs
[ 6333.703813] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[ 6333.716944] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[ 6333.717202] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[ 6333.730241] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[ 6333.743625] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[ 6333.756867] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[ 6333.757018] PM: noirq suspend of devices complete after 66.093 msecs
[ 6333.757895] ACPI: Preparing to enter system sleep state S3
[ 6333.906724] PM: Saving platform NVS memory
[ 6333.916666] Disabling non-boot CPUs ...
[ 6334.019857] smpboot: CPU 1 is now offline
[ 6334.123055] smpboot: CPU 2 is now offline
[ 6334.226261] smpboot: CPU 3 is now offline
[ 6334.226811] Extended CMOS year: 2000
[ 6334.230117] ACPI: Low-level resume complete
[ 6334.230185] PM: Restoring platform NVS memory
[ 6334.230829] Extended CMOS year: 2000
[ 6334.230970] Enabling non-boot CPUs ...
[ 6334.234453] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 6334.300379] CPU1 is up
[ 6334.303871] smpboot: Booting Node 0 Processor 2 APIC 0x2
[ 6334.370279] CPU2 is up
[ 6334.373755] smpboot: Booting Node 0 Processor 3 APIC 0x3
[ 6334.440227] CPU3 is up
[ 6334.449558] ACPI: Waking up from system sleep state S3
[ 6334.726512] i915 0000:00:02.0: power state changed by ACPI to D0
[ 6334.739675] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[ 6334.753042] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[ 6334.779645] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[ 6334.792965] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[ 6334.806502] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[ 6334.819595] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[ 6334.846305] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[ 6334.860807] PM: noirq resume of devices complete after 134.644 msecs
[ 6334.861213] PM: early resume of devices complete after 0.354 msecs
[ 6334.861284] i915 0000:00:02.0: setting latency timer to 64
[ 6334.861294] xhci_hcd 0000:00:14.0: setting latency timer to 64
[ 6334.861363] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[ 6334.861389] ehci-pci 0000:00:1a.0: setting latency timer to 64
[ 6334.861435] ehci-pci 0000:00:1d.0: setting latency timer to 64
[ 6334.861440] ahci 0000:00:1f.2: setting latency timer to 64
[ 6334.861619] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[ 6335.072846] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[ 6335.179117] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 6335.180096] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 6335.180102] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 6335.182040] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 6335.182046] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 6335.182869] ata1.00: configured for UDMA/133
[ 6335.183056] sd 0:0:0:0: [sda] Starting disk
[ 6335.222708] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[ 6335.307827] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[ 6335.307832] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[ 6335.870992] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 6335.877846] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 6336.109392] PM: resume of devices complete after 1249.787 msecs
[ 6336.110830] PM: Finishing wakeup.
[ 6336.110834] Restarting tasks ... done.
[ 6336.118987] video LNXVIDEO:00: Restoring backlight state
[ 6336.124499] wlp3s0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 7)
[ 6336.144062] cfg80211: Calling CRDA to update world regulatory domain
[ 6336.198508] ------------[ cut here ]------------
[ 6336.198575] WARNING: at drivers/gpu/drm/i915/intel_display.c:5374 ironlake_crtc_mode_set+0x8d0/0x900 [i915]()
[ 6336.198580] Hardware name: 34601K4
[ 6336.198584] Modules linked in: fuse joydev arc4 iwldvm mac80211 iwlwifi iTCO_wdt cfg80211 iTCO_vendor_support lpc_ich nls_cp437 vfat fat ext4 jbd2 mbcache coretemp kvm_intel kvm btusb uvcvideo bluetooth videobuf2_vmalloc videobuf2_memops videobuf2_core microcode videodev psmouse media i2c_i801 serio_raw pcspkr crc16 thinkpad_acpi nvram ac battery tpm_tis rfkill tpm snd_hda_codec_hdmi tpm_bios snd_hda_codec_realtek thermal wmi snd_hda_intel acpi_cpufreq snd_hda_codec mperf snd_hwdep snd_pcm evdev snd_page_alloc snd_timer snd mei soundcore processor btrfs libcrc32c zlib_deflate dm_crypt dm_mod sd_mod crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 xts lrw gf128mul ablk_helper cryptd ahci libahci ehci_pci libata ehci_hcd xhci_hcd sdhci_pci sdhci scsi_mod mmc_core usbcore usb_common i915 video
[ 6336.198729]  button i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
[ 6336.198748] Pid: 5284, comm: X Tainted: G        W    3.8.3-2-ARCH #1
[ 6336.198753] Call Trace:
[ 6336.198770]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[ 6336.198781]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[ 6336.198814]  [<ffffffffa00bda80>] ironlake_crtc_mode_set+0x8d0/0x900 [i915]
[ 6336.198847]  [<ffffffffa00c208b>] intel_set_mode+0x63b/0xa30 [i915]
[ 6336.198859]  [<ffffffff814d16d5>] ? __schedule+0x435/0x920
[ 6336.198893]  [<ffffffffa00c2bc6>] intel_crtc_set_config+0x746/0x990 [i915]
[ 6336.198923]  [<ffffffffa0020b85>] drm_mode_setcrtc+0x115/0x5a0 [drm]
[ 6336.198948]  [<ffffffffa00113f3>] drm_ioctl+0x4c3/0x570 [drm]
[ 6336.198975]  [<ffffffffa0020a70>] ? drm_mode_setplane+0x370/0x370 [drm]
[ 6336.198991]  [<ffffffff8119eb07>] do_vfs_ioctl+0x97/0x530
[ 6336.199002]  [<ffffffff8119f031>] sys_ioctl+0x91/0xb0
[ 6336.199013]  [<ffffffff8118d242>] ? sys_write+0x52/0xa0
[ 6336.199024]  [<ffffffff814dac53>] ? stub_iopl+0x13/0x20
[ 6336.199034]  [<ffffffff814da79d>] system_call_fastpath+0x1a/0x1f
[ 6336.199041] ---[ end trace 75372ac7934791a4 ]---
[ 6336.211364] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[ 6336.413194] [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 1 fail!
[ 6336.415367] [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 2 fail!
[ 6339.492561] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 6339.499484] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 6339.733446] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 6342.879773] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 6342.886648] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 6343.124694] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 6347.246785] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 6347.253728] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 6347.492370] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 6347.548564] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 6347.555574] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 6347.785774] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 6349.943051] wlp3s0: authenticate with 0e:b0:5d:9c:37:13
[ 6349.948661] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[ 6349.951481] wlp3s0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[ 6349.953816] wlp3s0: authenticated
[ 6349.956671] wlp3s0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[ 6349.962079] wlp3s0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=4)
[ 6349.984236] wlp3s0: associated
[ 6349.984325] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[ 8093.739315] [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 1 fail!
[ 8093.741904] [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 2 fail!
[ 9122.156737] ------------[ cut here ]------------
[ 9122.156796] WARNING: at drivers/gpu/drm/i915/intel_display.c:7877 intel_modeset_check_state+0x4bb/0x610 [i915]()
[ 9122.156800] Hardware name: 34601K4
[ 9122.156803] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[ 9122.156806] Modules linked in: fuse joydev arc4 iwldvm mac80211 iwlwifi iTCO_wdt cfg80211 iTCO_vendor_support lpc_ich nls_cp437 vfat fat ext4 jbd2 mbcache coretemp kvm_intel kvm btusb uvcvideo bluetooth videobuf2_vmalloc videobuf2_memops videobuf2_core microcode videodev psmouse media i2c_i801 serio_raw pcspkr crc16 thinkpad_acpi nvram ac battery tpm_tis rfkill tpm snd_hda_codec_hdmi tpm_bios snd_hda_codec_realtek thermal wmi snd_hda_intel acpi_cpufreq snd_hda_codec mperf snd_hwdep snd_pcm evdev snd_page_alloc snd_timer snd mei soundcore processor btrfs libcrc32c zlib_deflate dm_crypt dm_mod sd_mod crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 xts lrw gf128mul ablk_helper cryptd ahci libahci ehci_pci libata ehci_hcd xhci_hcd sdhci_pci sdhci scsi_mod mmc_core usbcore usb_common i915 video
[ 9122.156903]  button i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
[ 9122.156918] Pid: 5284, comm: X Tainted: G        W    3.8.3-2-ARCH #1
[ 9122.156921] Call Trace:
[ 9122.156936]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[ 9122.156943]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[ 9122.156970]  [<ffffffffa00c188b>] intel_modeset_check_state+0x4bb/0x610 [i915]
[ 9122.156992]  [<ffffffffa00c1a24>] intel_connector_dpms+0x44/0x70 [i915]
[ 9122.157013]  [<ffffffffa00228dd>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[ 9122.157030]  [<ffffffffa0022920>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[ 9122.157048]  [<ffffffffa00113f3>] drm_ioctl+0x4c3/0x570 [drm]
[ 9122.157068]  [<ffffffffa00228f0>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[ 9122.157076]  [<ffffffff8112d437>] ? __free_pages+0x57/0x70
[ 9122.157087]  [<ffffffff8119eb07>] do_vfs_ioctl+0x97/0x530
[ 9122.157096]  [<ffffffff8118e41e>] ? ____fput+0xe/0x10
[ 9122.157103]  [<ffffffff8119f031>] sys_ioctl+0x91/0xb0
[ 9122.157113]  [<ffffffff81015d1c>] ? do_notify_resume+0x9c/0xb0
[ 9122.157122]  [<ffffffff814da79d>] system_call_fastpath+0x1a/0x1f
[ 9122.157127] ---[ end trace 75372ac7934791a5 ]---
[ 9122.179581] ------------[ cut here ]------------
[ 9122.179645] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1987 intel_dp_link_down+0x1c0/0x1d0 [i915]()
[ 9122.179650] Hardware name: 34601K4
[ 9122.179653] Modules linked in: fuse joydev arc4 iwldvm mac80211 iwlwifi iTCO_wdt cfg80211 iTCO_vendor_support lpc_ich nls_cp437 vfat fat ext4 jbd2 mbcache coretemp kvm_intel kvm btusb uvcvideo bluetooth videobuf2_vmalloc videobuf2_memops videobuf2_core microcode videodev psmouse media i2c_i801 serio_raw pcspkr crc16 thinkpad_acpi nvram ac battery tpm_tis rfkill tpm snd_hda_codec_hdmi tpm_bios snd_hda_codec_realtek thermal wmi snd_hda_intel acpi_cpufreq snd_hda_codec mperf snd_hwdep snd_pcm evdev snd_page_alloc snd_timer snd mei soundcore processor btrfs libcrc32c zlib_deflate dm_crypt dm_mod sd_mod crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 xts lrw gf128mul ablk_helper cryptd ahci libahci ehci_pci libata ehci_hcd xhci_hcd sdhci_pci sdhci scsi_mod mmc_core usbcore usb_common i915 video
[ 9122.179773]  button i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
[ 9122.179792] Pid: 5284, comm: X Tainted: G        W    3.8.3-2-ARCH #1
[ 9122.179796] Call Trace:
[ 9122.179812]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[ 9122.179820]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[ 9122.179851]  [<ffffffffa00cb800>] intel_dp_link_down+0x1c0/0x1d0 [i915]
[ 9122.179881]  [<ffffffffa00ce401>] intel_disable_dp+0x51/0x80 [i915]
[ 9122.179907]  [<ffffffffa00ba62e>] ironlake_crtc_disable+0x6de/0x850 [i915]
[ 9122.179929]  [<ffffffffa00bfba7>] intel_crtc_update_dpms+0x77/0xb0 [i915]
[ 9122.179950]  [<ffffffffa00bfc9a>] intel_encoder_dpms+0x1a/0x30 [i915]
[ 9122.179973]  [<ffffffffa00c1a1c>] intel_connector_dpms+0x3c/0x70 [i915]
[ 9122.179995]  [<ffffffffa00228dd>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[ 9122.180013]  [<ffffffffa0022920>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[ 9122.180030]  [<ffffffffa00113f3>] drm_ioctl+0x4c3/0x570 [drm]
[ 9122.180050]  [<ffffffffa00228f0>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[ 9122.180060]  [<ffffffff81020255>] ? __restore_xstate_sig+0x95/0x600
[ 9122.180070]  [<ffffffff8119eb07>] do_vfs_ioctl+0x97/0x530
[ 9122.180079]  [<ffffffff8106a9b7>] ? __set_task_blocked+0x37/0x80
[ 9122.180086]  [<ffffffff8119f031>] sys_ioctl+0x91/0xb0
[ 9122.180095]  [<ffffffff814da79d>] system_call_fastpath+0x1a/0x1f
[ 9122.180100] ---[ end trace 75372ac7934791a6 ]---
[ 9127.310554] PM: Syncing filesystems ... done.
[ 9127.647601] PM: Preparing system for mem sleep
[ 9127.881122] [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 1 fail!
[ 9127.883299] [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 2 fail!
[ 9128.499046] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 9128.511536] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 9128.524817] PM: Entering mem sleep
[ 9128.524987] Suspending console(s) (use no_console_suspend to debug)
[ 9128.677900] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 9128.678029] sd 0:0:0:0: [sda] Stopping disk
[ 9129.277064] i915 0000:00:02.0: power state changed by ACPI to D3hot
[ 9129.277177] PM: suspend of devices complete after 752.458 msecs
[ 9129.277702] PM: late suspend of devices complete after 0.521 msecs
[ 9129.290476] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[ 9129.303597] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[ 9129.303857] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[ 9129.316911] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[ 9129.330293] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[ 9129.343536] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[ 9129.343686] PM: noirq suspend of devices complete after 66.064 msecs
[ 9129.344564] ACPI: Preparing to enter system sleep state S3
[ 9129.493397] PM: Saving platform NVS memory
[ 9129.503490] Disabling non-boot CPUs ...
[ 9129.505133] smpboot: CPU 1 is now offline
[ 9129.507558] smpboot: CPU 2 is now offline
[ 9129.509986] smpboot: CPU 3 is now offline
[ 9129.510578] Extended CMOS year: 2000
[ 9129.513893] ACPI: Low-level resume complete
[ 9129.513963] PM: Restoring platform NVS memory
[ 9129.514623] Extended CMOS year: 2000
[ 9129.514756] Enabling non-boot CPUs ...
[ 9129.518234] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 9129.584129] CPU1 is up
[ 9129.584296] smpboot: Booting Node 0 Processor 2 APIC 0x2
[ 9129.650700] CPU2 is up
[ 9129.650822] smpboot: Booting Node 0 Processor 3 APIC 0x3
[ 9129.717321] CPU3 is up
[ 9129.726489] ACPI: Waking up from system sleep state S3
[ 9130.003602] i915 0000:00:02.0: power state changed by ACPI to D0
[ 9130.016770] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[ 9130.030135] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[ 9130.056740] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[ 9130.070061] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[ 9130.083597] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[ 9130.096691] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[ 9130.123389] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[ 9130.137904] PM: noirq resume of devices complete after 134.648 msecs
[ 9130.138311] PM: early resume of devices complete after 0.353 msecs
[ 9130.138376] i915 0000:00:02.0: setting latency timer to 64
[ 9130.138400] xhci_hcd 0000:00:14.0: setting latency timer to 64
[ 9130.138469] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[ 9130.138497] ehci-pci 0000:00:1a.0: setting latency timer to 64
[ 9130.138533] ehci-pci 0000:00:1d.0: setting latency timer to 64
[ 9130.138685] ahci 0000:00:1f.2: setting latency timer to 64
[ 9130.138698] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[ 9130.190647] Extended CMOS year: 2000
[ 9130.349945] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[ 9130.456252] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 9130.457225] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 9130.457231] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 9130.459196] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[ 9130.459202] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[ 9130.459974] ata1.00: configured for UDMA/133
[ 9130.460111] sd 0:0:0:0: [sda] Starting disk
[ 9130.499834] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[ 9130.585070] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[ 9130.585074] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[ 9130.641949] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 9130.648853] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 9130.880967] PM: resume of devices complete after 743.610 msecs
[ 9130.882601] PM: Finishing wakeup.
[ 9130.882604] Restarting tasks ... done.
[ 9130.890370] video LNXVIDEO:00: Restoring backlight state
[ 9132.137721] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[ 9132.883061] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[ 9134.887203] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[ 9134.920660] cfg80211: Calling CRDA to update world regulatory domain
[ 9137.962648] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 9137.969568] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 9138.210868] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 9140.811128] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 9140.818048] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 9141.050591] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 9145.261306] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 9145.264299] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 9145.501581] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 9145.544068] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[ 9145.550988] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[ 9145.786446] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[ 9147.994291] wlp3s0: authenticate with d4:a0:2a:98:a6:af
[ 9147.999735] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[ 9148.003665] wlp3s0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[ 9148.007391] wlp3s0: authenticated
[ 9148.010168] wlp3s0: associate with d4:a0:2a:98:a6:af (try 1/3)
[ 9148.012447] wlp3s0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=105)
[ 9148.032729] wlp3s0: associated
[ 9148.032821] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[14232.102520] wlp3s0: deauthenticating from d4:a0:2a:98:a6:af by local choice (reason=3)
[14232.137139] cfg80211: Calling CRDA for country: CH
[14233.089192] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[14233.096177] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[14233.333433] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[14234.001534] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[14234.008543] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[14234.249652] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[14237.296407] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[14237.303382] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[14237.544679] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[14240.214710] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[14240.221618] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[14240.461412] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[14244.986423] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[14244.993368] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[14245.227789] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[14245.265671] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[14245.266707] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[14245.502722] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[14247.710601] wlp3s0: authenticate with d4:a0:2a:98:a6:af
[14247.716628] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[14247.719851] wlp3s0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[14247.920893] wlp3s0: send auth to d4:a0:2a:98:a6:af (try 2/3)
[14247.921849] wlp3s0: authenticated
[14247.924284] wlp3s0: associate with d4:a0:2a:98:a6:af (try 1/3)
[14247.926227] wlp3s0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=105)
[14247.946206] wlp3s0: associated
[14247.946295] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[22990.262180] ------------[ cut here ]------------
[22990.262242] WARNING: at drivers/gpu/drm/i915/intel_display.c:7877 intel_modeset_check_state+0x4bb/0x610 [i915]()
[22990.262246] Hardware name: 34601K4
[22990.262249] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[22990.262251] Modules linked in: fuse joydev arc4 iwldvm mac80211 iwlwifi iTCO_wdt cfg80211 iTCO_vendor_support lpc_ich nls_cp437 vfat fat ext4 jbd2 mbcache coretemp kvm_intel kvm btusb uvcvideo bluetooth videobuf2_vmalloc videobuf2_memops videobuf2_core microcode videodev psmouse media i2c_i801 serio_raw pcspkr crc16 thinkpad_acpi nvram ac battery tpm_tis rfkill tpm snd_hda_codec_hdmi tpm_bios snd_hda_codec_realtek thermal wmi snd_hda_intel acpi_cpufreq snd_hda_codec mperf snd_hwdep snd_pcm evdev snd_page_alloc snd_timer snd mei soundcore processor btrfs libcrc32c zlib_deflate dm_crypt dm_mod sd_mod crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 xts lrw gf128mul ablk_helper cryptd ahci libahci ehci_pci libata ehci_hcd xhci_hcd sdhci_pci sdhci scsi_mod mmc_core usbcore usb_common i915 video
[22990.262348]  button i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
[22990.262364] Pid: 5284, comm: X Tainted: G        W    3.8.3-2-ARCH #1
[22990.262367] Call Trace:
[22990.262381]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[22990.262388]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[22990.262415]  [<ffffffffa00c188b>] intel_modeset_check_state+0x4bb/0x610 [i915]
[22990.262436]  [<ffffffffa00c1a24>] intel_connector_dpms+0x44/0x70 [i915]
[22990.262458]  [<ffffffffa00228dd>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[22990.262475]  [<ffffffffa0022920>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[22990.262492]  [<ffffffffa00113f3>] drm_ioctl+0x4c3/0x570 [drm]
[22990.262511]  [<ffffffffa00228f0>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[22990.262519]  [<ffffffff8112d437>] ? __free_pages+0x57/0x70
[22990.262529]  [<ffffffff8119eb07>] do_vfs_ioctl+0x97/0x530
[22990.262538]  [<ffffffff8118e41e>] ? ____fput+0xe/0x10
[22990.262546]  [<ffffffff8119f031>] sys_ioctl+0x91/0xb0
[22990.262555]  [<ffffffff81015d1c>] ? do_notify_resume+0x9c/0xb0
[22990.262564]  [<ffffffff814da79d>] system_call_fastpath+0x1a/0x1f
[22990.262569] ---[ end trace 75372ac7934791a7 ]---
[22990.285033] ------------[ cut here ]------------
[22990.285098] WARNING: at drivers/gpu/drm/i915/intel_dp.c:1987 intel_dp_link_down+0x1c0/0x1d0 [i915]()
[22990.285102] Hardware name: 34601K4
[22990.285105] Modules linked in: fuse joydev arc4 iwldvm mac80211 iwlwifi iTCO_wdt cfg80211 iTCO_vendor_support lpc_ich nls_cp437 vfat fat ext4 jbd2 mbcache coretemp kvm_intel kvm btusb uvcvideo bluetooth videobuf2_vmalloc videobuf2_memops videobuf2_core microcode videodev psmouse media i2c_i801 serio_raw pcspkr crc16 thinkpad_acpi nvram ac battery tpm_tis rfkill tpm snd_hda_codec_hdmi tpm_bios snd_hda_codec_realtek thermal wmi snd_hda_intel acpi_cpufreq snd_hda_codec mperf snd_hwdep snd_pcm evdev snd_page_alloc snd_timer snd mei soundcore processor btrfs libcrc32c zlib_deflate dm_crypt dm_mod sd_mod crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 xts lrw gf128mul ablk_helper cryptd ahci libahci ehci_pci libata ehci_hcd xhci_hcd sdhci_pci sdhci scsi_mod mmc_core usbcore usb_common i915 video
[22990.285205]  button i2c_algo_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
[22990.285221] Pid: 5284, comm: X Tainted: G        W    3.8.3-2-ARCH #1
[22990.285225] Call Trace:
[22990.285239]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[22990.285246]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[22990.285270]  [<ffffffffa00cb800>] intel_dp_link_down+0x1c0/0x1d0 [i915]
[22990.285293]  [<ffffffffa00ce401>] intel_disable_dp+0x51/0x80 [i915]
[22990.285316]  [<ffffffffa00ba62e>] ironlake_crtc_disable+0x6de/0x850 [i915]
[22990.285339]  [<ffffffffa00bfba7>] intel_crtc_update_dpms+0x77/0xb0 [i915]
[22990.285360]  [<ffffffffa00bfc9a>] intel_encoder_dpms+0x1a/0x30 [i915]
[22990.285383]  [<ffffffffa00c1a1c>] intel_connector_dpms+0x3c/0x70 [i915]
[22990.285406]  [<ffffffffa00228dd>] drm_mode_obj_set_property_ioctl+0x32d/0x340 [drm]
[22990.285424]  [<ffffffffa0022920>] drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
[22990.285441]  [<ffffffffa00113f3>] drm_ioctl+0x4c3/0x570 [drm]
[22990.285461]  [<ffffffffa00228f0>] ? drm_mode_obj_set_property_ioctl+0x340/0x340 [drm]
[22990.285472]  [<ffffffff81020255>] ? __restore_xstate_sig+0x95/0x600
[22990.285482]  [<ffffffff8119eb07>] do_vfs_ioctl+0x97/0x530
[22990.285492]  [<ffffffff8106a9b7>] ? __set_task_blocked+0x37/0x80
[22990.285499]  [<ffffffff8119f031>] sys_ioctl+0x91/0xb0
[22990.285508]  [<ffffffff814da79d>] system_call_fastpath+0x1a/0x1f
[22990.285513] ---[ end trace 75372ac7934791a8 ]---
[22991.537403] PM: Syncing filesystems ... done.
[22991.864638] PM: Preparing system for mem sleep
[22992.291475] Freezing user space processes ... (elapsed 0.01 seconds) done.
[22992.305747] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[22992.319244] PM: Entering mem sleep
[22992.319405] Suspending console(s) (use no_console_suspend to debug)
[22992.472355] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[22992.472477] sd 0:0:0:0: [sda] Stopping disk
[22993.064758] i915 0000:00:02.0: power state changed by ACPI to D3hot
[22993.064871] PM: suspend of devices complete after 745.704 msecs
[22993.065397] PM: late suspend of devices complete after 0.522 msecs
[22993.078176] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[22993.091300] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[22993.091555] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[22993.104601] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[22993.117989] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[22993.131228] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[22993.131378] PM: noirq suspend of devices complete after 66.061 msecs
[22993.132255] ACPI: Preparing to enter system sleep state S3
[22993.281088] PM: Saving platform NVS memory
[22993.291047] Disabling non-boot CPUs ...
[22993.292701] smpboot: CPU 1 is now offline
[22993.295126] smpboot: CPU 2 is now offline
[22993.297523] smpboot: CPU 3 is now offline
[22993.298122] Extended CMOS year: 2000
[22993.301438] ACPI: Low-level resume complete
[22993.301508] PM: Restoring platform NVS memory
[22993.302170] Extended CMOS year: 2000
[22993.302311] Enabling non-boot CPUs ...
[22993.305797] smpboot: Booting Node 0 Processor 1 APIC 0x1
[22993.345214] CPU1 is up
[22993.345374] smpboot: Booting Node 0 Processor 2 APIC 0x2
[22993.385173] CPU2 is up
[22993.385301] smpboot: Booting Node 0 Processor 3 APIC 0x3
[22993.425094] CPU3 is up
[22993.434979] ACPI: Waking up from system sleep state S3
[22993.588325] thinkpad_acpi: EC reports that Thermal Table has changed
[22993.744701] i915 0000:00:02.0: power state changed by ACPI to D0
[22993.757861] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[22993.771229] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[22993.797832] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[22993.811153] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[22993.824687] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[22993.837781] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[22993.864543] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[22993.878980] PM: noirq resume of devices complete after 134.623 msecs
[22993.879430] PM: early resume of devices complete after 0.354 msecs
[22993.879485] i915 0000:00:02.0: setting latency timer to 64
[22993.879517] xhci_hcd 0000:00:14.0: setting latency timer to 64
[22993.879577] ehci-pci 0000:00:1a.0: setting latency timer to 64
[22993.879645] ehci-pci 0000:00:1d.0: setting latency timer to 64
[22993.879668] ahci 0000:00:1f.2: setting latency timer to 64
[22993.879703] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[22993.880027] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[22993.931761] Extended CMOS year: 2000
[22994.091074] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[22994.197357] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[22994.198322] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[22994.198328] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[22994.200162] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[22994.200169] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[22994.200960] ata1.00: configured for UDMA/133
[22994.201156] sd 0:0:0:0: [sda] Starting disk
[22994.240878] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[22994.326112] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[22994.326116] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[22994.383168] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[22994.390088] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[22994.621658] PM: resume of devices complete after 743.173 msecs
[22994.623405] PM: Finishing wakeup.
[22994.623411] Restarting tasks ... done.
[22994.639865] video LNXVIDEO:00: Restoring backlight state
[22995.143070] cfg80211: Calling CRDA to update world regulatory domain
[22995.182953] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[23000.048833] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[23000.055751] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[23000.296606] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[23004.880742] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[23004.887652] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[23005.126698] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[23009.511511] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[23009.518389] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[23009.752741] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[23009.819111] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[23009.826014] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[23010.060119] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[23012.307196] wlp3s0: authenticate with 0e:b0:5d:9c:37:13
[23012.314663] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[23012.318023] wlp3s0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[23012.320254] wlp3s0: authenticated
[23012.320302] wlp3s0: waiting for beacon from 0e:b0:5d:9c:37:13
[23012.410353] wlp3s0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[23012.413915] wlp3s0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=1)
[23012.434928] wlp3s0: associated
[23012.435019] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[23527.262237] hda-intel 0000:00:1b.0: Unstable LPIB (130976 >= 8192); disabling LPIB delay counting
[24320.587751] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[24323.074475] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[24323.627144] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[25424.898292] PM: Syncing filesystems ... done.
[25425.322384] PM: Preparing system for mem sleep
[25425.490367] Freezing user space processes ... (elapsed 0.01 seconds) done.
[25425.504776] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[25425.518097] PM: Entering mem sleep
[25425.518245] Suspending console(s) (use no_console_suspend to debug)
[25425.518491] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[25425.621311] xhci_hcd 0000:00:14.0: setting latency timer to 64
[25425.621452] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[25425.724504] ehci-pci 0000:00:1a.0: setting latency timer to 64
[25425.724545] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[25425.827717] ehci-pci 0000:00:1d.0: setting latency timer to 64
[25425.980685] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[25425.994705] sd 0:0:0:0: [sda] Stopping disk
[25426.496664] i915 0000:00:02.0: power state changed by ACPI to D3hot
[25426.496759] PM: suspend of devices complete after 669.388 msecs
[25426.497293] PM: late suspend of devices complete after 0.529 msecs
[25426.510063] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[25426.523192] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[25426.523451] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[25426.536490] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[25426.549876] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[25426.563118] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[25426.563269] PM: noirq suspend of devices complete after 66.056 msecs
[25426.564146] ACPI: Preparing to enter system sleep state S3
[25426.706313] PM: Saving platform NVS memory
[25426.716454] Disabling non-boot CPUs ...
[25426.819447] smpboot: CPU 1 is now offline
[25426.922646] smpboot: CPU 2 is now offline
[25427.025849] smpboot: CPU 3 is now offline
[25427.026603] Extended CMOS year: 2000
[25427.029914] ACPI: Low-level resume complete
[25427.029989] PM: Restoring platform NVS memory
[25427.030674] Extended CMOS year: 2000
[25427.030826] Enabling non-boot CPUs ...
[25427.034336] smpboot: Booting Node 0 Processor 1 APIC 0x1
[25427.103344] CPU1 is up
[25427.103536] smpboot: Booting Node 0 Processor 2 APIC 0x2
[25427.169924] CPU2 is up
[25427.170090] smpboot: Booting Node 0 Processor 3 APIC 0x3
[25427.236575] CPU3 is up
[25427.245742] ACPI: Waking up from system sleep state S3
[25427.409753] thinkpad_acpi: EC reports that Thermal Table has changed
[25427.566137] i915 0000:00:02.0: power state changed by ACPI to D0
[25427.579260] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[25427.592631] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[25427.619234] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[25427.632550] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[25427.646088] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[25427.659169] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[25427.685906] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[25427.700400] PM: noirq resume of devices complete after 134.612 msecs
[25427.700805] PM: early resume of devices complete after 0.355 msecs
[25427.700884] i915 0000:00:02.0: setting latency timer to 64
[25427.700893] xhci_hcd 0000:00:14.0: setting latency timer to 64
[25427.700932] ehci-pci 0000:00:1a.0: setting latency timer to 64
[25427.700998] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[25427.701004] ehci-pci 0000:00:1d.0: setting latency timer to 64
[25427.701045] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[25427.701054] ahci 0000:00:1f.2: setting latency timer to 64
[25427.743220] Extended CMOS year: 2000
[25427.912412] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[25428.018748] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[25428.019713] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[25428.019719] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[25428.021680] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[25428.021686] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[25428.022484] ata1.00: configured for UDMA/133
[25428.035707] sd 0:0:0:0: [sda] Starting disk
[25428.062217] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[25428.147303] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[25428.147310] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[25428.204700] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[25428.211631] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[25428.446879] PM: resume of devices complete after 747.026 msecs
[25428.448804] PM: Finishing wakeup.
[25428.448807] Restarting tasks ... done.
[25428.455162] video LNXVIDEO:00: Restoring backlight state
[25428.461405] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[25428.464746] wlp3s0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 7)
[25428.491362] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[25428.525714] cfg80211: Calling CRDA for country: CH
[25429.067675] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[25429.121617] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[25429.128600] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[25429.353216] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[25431.124774] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[25433.743480] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[25433.750437] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[25433.992166] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[25438.026177] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[25438.033106] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[25438.275318] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[25438.327103] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[25438.334036] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[25438.575445] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[25440.737354] wlp3s0: authenticate with 0e:b0:5d:9c:37:13
[25440.744195] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[25440.747342] wlp3s0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[25440.749663] wlp3s0: authenticated
[25440.752266] wlp3s0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[25440.756404] wlp3s0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=1)
[25440.777362] wlp3s0: associated
[25440.777420] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[26637.084399] tun: Universal TUN/TAP device driver, 1.6
[26637.084407] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[42060.510497] PM: Syncing filesystems ... done.
[42060.765645] PM: Preparing system for mem sleep
[42060.898501] Freezing user space processes ... (elapsed 0.01 seconds) done.
[42060.912473] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[42060.925944] PM: Entering mem sleep
[42060.926096] Suspending console(s) (use no_console_suspend to debug)
[42060.926339] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[42061.029180] xhci_hcd 0000:00:14.0: setting latency timer to 64
[42061.029309] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[42061.132383] ehci-pci 0000:00:1a.0: setting latency timer to 64
[42061.132424] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[42061.235595] ehci-pci 0000:00:1d.0: setting latency timer to 64
[42061.388255] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[42061.394501] sd 0:0:0:0: [sda] Stopping disk
[42061.894563] i915 0000:00:02.0: power state changed by ACPI to D3hot
[42061.894646] PM: suspend of devices complete after 659.382 msecs
[42061.895183] PM: late suspend of devices complete after 0.532 msecs
[42061.907980] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[42061.921113] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[42061.921374] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[42061.934409] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[42061.947796] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[42061.961037] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[42061.961187] PM: noirq suspend of devices complete after 66.084 msecs
[42061.962065] ACPI: Preparing to enter system sleep state S3
[42062.110894] PM: Saving platform NVS memory
[42062.120870] Disabling non-boot CPUs ...
[42062.224033] smpboot: CPU 1 is now offline
[42062.327223] smpboot: CPU 2 is now offline
[42062.430425] smpboot: CPU 3 is now offline
[42062.431121] Extended CMOS year: 2000
[42062.434428] ACPI: Low-level resume complete
[42062.434509] PM: Restoring platform NVS memory
[42062.435173] Extended CMOS year: 2000
[42062.435319] Enabling non-boot CPUs ...
[42062.438805] smpboot: Booting Node 0 Processor 1 APIC 0x1
[42062.504586] CPU1 is up
[42062.504749] smpboot: Booting Node 0 Processor 2 APIC 0x2
[42062.571163] CPU2 is up
[42062.571286] smpboot: Booting Node 0 Processor 3 APIC 0x3
[42062.637774] CPU3 is up
[42062.647101] ACPI: Waking up from system sleep state S3
[42062.917406] i915 0000:00:02.0: power state changed by ACPI to D0
[42062.930557] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[42062.943937] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[42062.970537] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[42062.983856] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[42062.997392] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[42063.010493] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[42063.037187] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[42063.051718] PM: noirq resume of devices complete after 134.656 msecs
[42063.052134] PM: early resume of devices complete after 0.364 msecs
[42063.052210] i915 0000:00:02.0: setting latency timer to 64
[42063.052221] xhci_hcd 0000:00:14.0: setting latency timer to 64
[42063.052297] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[42063.052312] ehci-pci 0000:00:1a.0: setting latency timer to 64
[42063.052393] ahci 0000:00:1f.2: setting latency timer to 64
[42063.052395] ehci-pci 0000:00:1d.0: setting latency timer to 64
[42063.052409] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[42063.087846] Extended CMOS year: 2000
[42063.263694] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[42063.370059] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[42063.371003] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[42063.371009] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[42063.372894] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[42063.372901] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[42063.373684] ata1.00: configured for UDMA/133
[42063.386986] sd 0:0:0:0: [sda] Starting disk
[42063.413571] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[42063.498665] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[42063.498669] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[42063.555896] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[42063.562833] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[42063.794805] PM: resume of devices complete after 743.620 msecs
[42063.796519] PM: Finishing wakeup.
[42063.803232] wlp3s0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 7)
[42063.796523] Restarting tasks ... done.
[42063.808183] video LNXVIDEO:00: Restoring backlight state
[42063.826057] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[42063.850198] cfg80211: Calling CRDA to update world regulatory domain
[42063.852682] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[42064.533596] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[42064.540717] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[42064.540764] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[42064.772109] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[42068.596647] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[42069.221509] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[42069.228437] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[42069.464451] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[42073.631122] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[42073.638036] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[42073.875598] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[42073.920205] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[42073.927075] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[42074.161927] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[42076.267163] wlp3s0: authenticate with 0e:b0:5d:9c:37:13
[42076.273987] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[42076.276238] wlp3s0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[42076.278915] wlp3s0: authenticated
[42076.279966] wlp3s0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[42076.284057] wlp3s0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=1)
[42076.303530] wlp3s0: associated
[42076.303625] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[45902.961166] PM: Syncing filesystems ... done.
[45903.263574] PM: Preparing system for mem sleep
[45903.383549] Freezing user space processes ... (elapsed 0.01 seconds) done.
[45903.397866] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[45903.411188] PM: Entering mem sleep
[45903.411355] Suspending console(s) (use no_console_suspend to debug)
[45903.411603] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[45903.514419] xhci_hcd 0000:00:14.0: setting latency timer to 64
[45903.514541] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[45903.617617] ehci-pci 0000:00:1a.0: setting latency timer to 64
[45903.617659] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[45903.720833] ehci-pci 0000:00:1d.0: setting latency timer to 64
[45903.877197] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[45903.883429] sd 0:0:0:0: [sda] Stopping disk
[45904.403106] i915 0000:00:02.0: power state changed by ACPI to D3hot
[45904.403203] PM: suspend of devices complete after 682.731 msecs
[45904.403737] PM: late suspend of devices complete after 0.530 msecs
[45904.416519] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[45904.429650] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[45904.429908] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[45904.442956] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[45904.456338] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[45904.469580] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[45904.469729] PM: noirq suspend of devices complete after 66.072 msecs
[45904.470606] ACPI: Preparing to enter system sleep state S3
[45904.619430] PM: Saving platform NVS memory
[45904.629504] Disabling non-boot CPUs ...
[45904.732565] smpboot: CPU 1 is now offline
[45904.835764] smpboot: CPU 2 is now offline
[45904.938968] smpboot: CPU 3 is now offline
[45904.939611] Extended CMOS year: 2000
[45904.942917] ACPI: Low-level resume complete
[45904.942990] PM: Restoring platform NVS memory
[45904.943665] Extended CMOS year: 2000
[45904.943808] Enabling non-boot CPUs ...
[45904.947293] smpboot: Booting Node 0 Processor 1 APIC 0x1
[45905.013125] CPU1 is up
[45905.013289] smpboot: Booting Node 0 Processor 2 APIC 0x2
[45905.079706] CPU2 is up
[45905.079827] smpboot: Booting Node 0 Processor 3 APIC 0x3
[45905.146323] CPU3 is up
[45905.155444] ACPI: Waking up from system sleep state S3
[45905.432596] i915 0000:00:02.0: power state changed by ACPI to D0
[45905.445763] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[45905.459131] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[45905.485732] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[45905.499056] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[45905.512591] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[45905.525685] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[45905.552419] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[45905.566917] PM: noirq resume of devices complete after 134.666 msecs
[45905.567331] PM: early resume of devices complete after 0.360 msecs
[45905.567410] i915 0000:00:02.0: setting latency timer to 64
[45905.567414] xhci_hcd 0000:00:14.0: setting latency timer to 64
[45905.567463] ehci-pci 0000:00:1a.0: setting latency timer to 64
[45905.567525] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[45905.567532] ehci-pci 0000:00:1d.0: setting latency timer to 64
[45905.567576] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[45905.567591] ahci 0000:00:1f.2: setting latency timer to 64
[45905.612917] Extended CMOS year: 2000
[45905.778939] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[45905.864041] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[45905.864045] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[45905.885273] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[45905.886247] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45905.886253] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45905.888201] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45905.888208] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45905.888988] ata1.00: configured for UDMA/133
[45905.902135] sd 0:0:0:0: [sda] Starting disk
[45905.928717] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[45906.135645] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[45906.142655] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[45906.374981] PM: resume of devices complete after 808.688 msecs
[45906.376515] PM: Finishing wakeup.
[45906.381412] wlp3s0: deauthenticated from 0e:b0:5d:9c:37:13 (Reason: 7)
[45906.376518] Restarting tasks ... done.
[45906.381992] video LNXVIDEO:00: Restoring backlight state
[45906.387986] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[45906.417824] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[45906.431185] cfg80211: Calling CRDA to update world regulatory domain
[45906.999339] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[45907.006269] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[45907.235171] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[45907.566701] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[45907.961925] PM: Syncing filesystems ... done.
[45908.269977] PM: Preparing system for mem sleep
[45908.377438] Freezing user space processes ... (elapsed 0.01 seconds) done.
[45908.392130] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[45908.405492] PM: Entering mem sleep
[45908.405642] Suspending console(s) (use no_console_suspend to debug)
[45908.405894] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[45908.508644] xhci_hcd 0000:00:14.0: setting latency timer to 64
[45908.508774] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[45908.611894] ehci-pci 0000:00:1d.0: setting latency timer to 64
[45909.181911] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[45909.188186] sd 0:0:0:0: [sda] Stopping disk
[45909.696988] i915 0000:00:02.0: power state changed by ACPI to D3hot
[45909.697100] PM: suspend of devices complete after 1086.084 msecs
[45909.697636] PM: late suspend of devices complete after 0.531 msecs
[45909.710408] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[45909.723532] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[45909.723791] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[45909.736836] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[45909.750220] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[45909.763459] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[45909.763611] PM: noirq suspend of devices complete after 66.055 msecs
[45909.764488] ACPI: Preparing to enter system sleep state S3
[45909.913317] PM: Saving platform NVS memory
[45909.923330] Disabling non-boot CPUs ...
[45910.026455] smpboot: CPU 1 is now offline
[45910.129648] smpboot: CPU 2 is now offline
[45910.232848] smpboot: CPU 3 is now offline
[45910.233434] Extended CMOS year: 2000
[45910.236737] ACPI: Low-level resume complete
[45910.236811] PM: Restoring platform NVS memory
[45910.237489] Extended CMOS year: 2000
[45910.237635] Enabling non-boot CPUs ...
[45910.241116] smpboot: Booting Node 0 Processor 1 APIC 0x1
[45910.307011] CPU1 is up
[45910.310520] smpboot: Booting Node 0 Processor 2 APIC 0x2
[45910.376920] CPU2 is up
[45910.380411] smpboot: Booting Node 0 Processor 3 APIC 0x3
[45910.446868] CPU3 is up
[45910.456031] ACPI: Waking up from system sleep state S3
[45910.733153] i915 0000:00:02.0: power state changed by ACPI to D0
[45910.746309] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[45910.759676] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[45910.786277] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[45910.799599] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[45910.813130] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[45910.826228] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[45910.853074] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[45910.867368] PM: noirq resume of devices complete after 134.564 msecs
[45910.867780] PM: early resume of devices complete after 0.359 msecs
[45910.867852] i915 0000:00:02.0: setting latency timer to 64
[45910.867855] xhci_hcd 0000:00:14.0: setting latency timer to 64
[45910.868021] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[45910.868219] ehci-pci 0000:00:1a.0: setting latency timer to 64
[45910.868433] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[45910.868719] ehci-pci 0000:00:1d.0: setting latency timer to 64
[45910.868903] ahci 0000:00:1f.2: setting latency timer to 64
[45910.933632] Extended CMOS year: 2000
[45911.079478] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[45911.189155] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[45911.190112] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45911.190118] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45911.192004] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45911.192011] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45911.192769] ata1.00: configured for UDMA/133
[45911.206027] sd 0:0:0:0: [sda] Starting disk
[45911.229312] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[45911.314816] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[45911.314820] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[45911.371604] PM: resume of devices complete after 504.466 msecs
[45911.373193] PM: Finishing wakeup.
[45911.385461] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[45911.373197] Restarting tasks ... done.
[45911.386969] video LNXVIDEO:00: Restoring backlight state
[45911.408641] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[45911.415517] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[45911.415567] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[45911.645666] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[45912.564285] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[45915.626672] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[45915.653260] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[45915.660217] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[45915.898974] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[45915.953545] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[45915.962963] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[45916.200456] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[45918.333461] wlp3s0: authenticate with 0e:b0:5d:9c:37:13
[45918.338616] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[45918.341330] wlp3s0: send auth to 0e:b0:5d:9c:37:13 (try 1/3)
[45918.343529] wlp3s0: authenticated
[45918.346492] wlp3s0: associate with 0e:b0:5d:9c:37:13 (try 1/3)
[45918.350089] wlp3s0: RX AssocResp from 0e:b0:5d:9c:37:13 (capab=0x411 status=0 aid=1)
[45918.370778] wlp3s0: associated
[45918.370863] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[49251.428969] PM: Syncing filesystems ... done.
[49324.990885] PM: Preparing system for mem sleep
[49325.200665] Freezing user space processes ... (elapsed 0.01 seconds) done.
[49325.214716] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[49325.228119] PM: Entering mem sleep
[49325.228282] Suspending console(s) (use no_console_suspend to debug)
[49325.228522] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[49325.331400] xhci_hcd 0000:00:14.0: setting latency timer to 64
[49325.331536] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[49325.434595] ehci-pci 0000:00:1a.0: setting latency timer to 64
[49325.434637] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[49325.537817] ehci-pci 0000:00:1d.0: setting latency timer to 64
[49325.697421] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[49325.703603] sd 0:0:0:0: [sda] Stopping disk
[49326.203427] i915 0000:00:02.0: power state changed by ACPI to D3hot
[49326.203508] PM: suspend of devices complete after 666.020 msecs
[49326.204042] PM: late suspend of devices complete after 0.530 msecs
[49326.216865] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[49326.229996] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[49326.230259] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[49326.243295] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[49326.256679] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[49326.269917] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[49326.270066] PM: noirq suspend of devices complete after 66.104 msecs
[49326.270943] ACPI: Preparing to enter system sleep state S3
[49326.419772] PM: Saving platform NVS memory
[49326.429721] Disabling non-boot CPUs ...
[49326.532904] smpboot: CPU 1 is now offline
[49326.636102] smpboot: CPU 2 is now offline
[49326.739303] smpboot: CPU 3 is now offline
[49326.739986] Extended CMOS year: 2000
[49326.743291] ACPI: Low-level resume complete
[49326.743370] PM: Restoring platform NVS memory
[49326.744024] Extended CMOS year: 2000
[49326.744165] Enabling non-boot CPUs ...
[49326.747654] smpboot: Booting Node 0 Processor 1 APIC 0x1
[49326.786837] CPU1 is up
[49326.787003] smpboot: Booting Node 0 Processor 2 APIC 0x2
[49326.826796] CPU2 is up
[49326.826923] smpboot: Booting Node 0 Processor 3 APIC 0x3
[49326.866738] CPU3 is up
[49326.876599] ACPI: Waking up from system sleep state S3
[49327.029932] thinkpad_acpi: EC reports that Thermal Table has changed
[49327.186321] i915 0000:00:02.0: power state changed by ACPI to D0
[49327.199481] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[49327.212845] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[49327.239447] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[49327.252768] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[49327.266308] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[49327.279398] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[49327.306262] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[49327.320617] PM: noirq resume of devices complete after 134.645 msecs
[49327.321042] PM: early resume of devices complete after 0.372 msecs
[49327.321111] i915 0000:00:02.0: setting latency timer to 64
[49327.321115] xhci_hcd 0000:00:14.0: setting latency timer to 64
[49327.321242] ehci-pci 0000:00:1a.0: setting latency timer to 64
[49327.321247] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[49327.321386] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[49327.321447] ehci-pci 0000:00:1d.0: setting latency timer to 64
[49327.321490] ahci 0000:00:1f.2: setting latency timer to 64
[49327.532565] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[49327.638968] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[49327.639930] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[49327.639936] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[49327.641782] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[49327.641788] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[49327.642623] ata1.00: configured for UDMA/133
[49327.655891] sd 0:0:0:0: [sda] Starting disk
[49327.682378] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[49327.767518] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[49327.767523] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[49327.824732] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49327.831652] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49328.063770] PM: resume of devices complete after 743.677 msecs
[49328.065697] PM: Finishing wakeup.
[49328.078330] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[49328.065700] Restarting tasks ... done.
[49328.086938] video LNXVIDEO:00: Restoring backlight state
[49328.114951] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[49329.160588] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[49329.970113] cfg80211: Calling CRDA for country: CH
[49332.209637] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[49333.998136] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49334.005030] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49334.244751] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[49338.827511] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49338.834446] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49339.073716] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[49499.476490] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49499.483412] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49499.722025] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[49499.778637] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49499.785544] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49500.020697] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[49502.151120] wlp3s0: authenticate with 5c:ff:35:75:05:89
[49502.154101] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[49502.157804] wlp3s0: send auth to 5c:ff:35:75:05:89 (try 1/3)
[49502.159837] wlp3s0: authenticated
[49502.163160] wlp3s0: associate with 5c:ff:35:75:05:89 (try 1/3)
[49502.171126] wlp3s0: RX AssocResp from 5c:ff:35:75:05:89 (capab=0x431 status=0 aid=1)
[49502.178435] wlp3s0: associated
[49502.178542] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[49924.962053] PM: Syncing filesystems ... done.
[49925.226351] PM: Preparing system for mem sleep
[49925.344461] Freezing user space processes ... (elapsed 0.01 seconds) done.
[49925.358844] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[49925.372310] PM: Entering mem sleep
[49925.372459] Suspending console(s) (use no_console_suspend to debug)
[49925.372706] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[49925.475537] xhci_hcd 0000:00:14.0: setting latency timer to 64
[49925.475632] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[49925.578742] ehci-pci 0000:00:1a.0: setting latency timer to 64
[49925.578785] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[49925.681954] ehci-pci 0000:00:1d.0: setting latency timer to 64
[49925.821447] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[49925.827757] sd 0:0:0:0: [sda] Stopping disk
[49926.330933] i915 0000:00:02.0: power state changed by ACPI to D3hot
[49926.331021] PM: suspend of devices complete after 649.379 msecs
[49926.331556] PM: late suspend of devices complete after 0.531 msecs
[49926.344317] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[49926.357471] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3hot
[49926.357731] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[49926.370784] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3hot
[49926.384163] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[49926.397405] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[49926.397544] PM: noirq suspend of devices complete after 66.070 msecs
[49926.398422] ACPI: Preparing to enter system sleep state S3
[49926.540614] PM: Saving platform NVS memory
[49926.550629] Disabling non-boot CPUs ...
[49926.653737] smpboot: CPU 1 is now offline
[49926.756933] smpboot: CPU 2 is now offline
[49926.860130] smpboot: CPU 3 is now offline
[49926.860841] Extended CMOS year: 2000
[49926.864139] ACPI: Low-level resume complete
[49926.864209] PM: Restoring platform NVS memory
[49926.864889] Extended CMOS year: 2000
[49926.865035] Enabling non-boot CPUs ...
[49926.868520] smpboot: Booting Node 0 Processor 1 APIC 0x1
[49926.907681] CPU1 is up
[49926.907847] smpboot: Booting Node 0 Processor 2 APIC 0x2
[49926.947627] CPU2 is up
[49926.947800] smpboot: Booting Node 0 Processor 3 APIC 0x3
[49926.987570] CPU3 is up
[49926.997657] ACPI: Waking up from system sleep state S3
[49927.263887] i915 0000:00:02.0: power state changed by ACPI to D0
[49927.277042] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[49927.290408] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[49927.316998] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[49927.330334] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[49927.343865] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[49927.356963] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[49927.383659] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[49927.398182] PM: noirq resume of devices complete after 134.645 msecs
[49927.398598] PM: early resume of devices complete after 0.362 msecs
[49927.398665] i915 0000:00:02.0: setting latency timer to 64
[49927.398670] xhci_hcd 0000:00:14.0: setting latency timer to 64
[49927.398795] ehci-pci 0000:00:1a.0: setting latency timer to 64
[49927.398803] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[49927.398941] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[49927.399019] ehci-pci 0000:00:1d.0: setting latency timer to 64
[49927.399040] ahci 0000:00:1f.2: setting latency timer to 64
[49927.610134] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[49927.716530] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[49927.717529] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[49927.717535] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[49927.719529] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[49927.719536] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[49927.720411] ata1.00: configured for UDMA/133
[49927.733438] sd 0:0:0:0: [sda] Starting disk
[49927.759947] usb 3-1.4: reset full-speed USB device number 6 using ehci-pci
[49927.845140] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[49927.845144] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[49927.902384] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49927.909276] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49928.139676] PM: resume of devices complete after 742.026 msecs
[49928.141307] PM: Finishing wakeup.
[49928.141310] Restarting tasks ... done.
[49928.155979] video LNXVIDEO:00: Restoring backlight state
[49928.162542] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[49928.185844] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[49928.285942] cfg80211: Calling CRDA to update world regulatory domain
[49929.387980] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[49932.437115] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[49934.198490] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49934.205385] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49934.444853] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[49939.055297] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49939.062186] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49939.302675] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[49942.847227] thinkpad_acpi: unknown possible thermal alarm or keyboard event received
[49942.847236] thinkpad_acpi: unhandled HKEY event 0x6040
[49942.847240] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net
[49942.847922] thinkpad_acpi: EC reports that Thermal Table has changed
[49943.596189] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49943.603110] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49943.845035] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[49943.882488] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[49943.889380] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[49944.124001] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[49946.380088] wlp3s0: authenticate with d4:a0:2a:98:a6:af
[49946.385534] wlp3s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
[49946.388122] wlp3s0: send auth to d4:a0:2a:98:a6:af (try 1/3)
[49946.391392] wlp3s0: authenticated
[49946.392262] wlp3s0: associate with d4:a0:2a:98:a6:af (try 1/3)
[49946.394073] wlp3s0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=133)
[49946.412637] wlp3s0: associated
[49946.412699] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[52536.209629] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[52536.311108] ehci-pci 0000:00:1a.0: setting latency timer to 64
[52536.311475] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[52536.414356] ehci-pci 0000:00:1d.0: setting latency timer to 64
[52536.414561] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[52536.427470] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[52536.517536] xhci_hcd 0000:00:14.0: setting latency timer to 64
[52536.524237] usb 3-1.2: new high-speed USB device number 7 using ehci-pci
[52536.723735] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[52536.770034] Initializing USB Mass Storage driver...
[52536.770549] scsi6 : usb-storage 3-1.2:1.0
[52536.770758] usbcore: registered new interface driver usb-storage
[52536.770762] USB Mass Storage support registered.
[52544.272683] scsi 6:0:0:0: Direct-Access     Samsung  STORY Station 3  1AJ1 PQ: 0 ANSI: 0
[52544.274383] sd 6:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[52544.275988] sd 6:0:0:0: [sdb] Write Protect is off
[52544.276002] sd 6:0:0:0: [sdb] Mode Sense: 23 00 00 00
[52544.277876] sd 6:0:0:0: [sdb] No Caching mode page present
[52544.277889] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[52544.282306] sd 6:0:0:0: [sdb] No Caching mode page present
[52544.282315] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[52544.284699] kworker/u:1: page allocation failure: order:4, mode:0x10c0d0
[52544.284711] Pid: 12117, comm: kworker/u:1 Tainted: G        W    3.8.3-2-ARCH #1
[52544.284716] Call Trace:
[52544.284739]  [<ffffffff811292f9>] warn_alloc_failed+0xe9/0x140
[52544.284753]  [<ffffffff8112c776>] ? drain_local_pages+0x16/0x20
[52544.284766]  [<ffffffff8112cf88>] __alloc_pages_nodemask+0x7b8/0xa40
[52544.284782]  [<ffffffff8116a7a8>] alloc_pages_current+0xb8/0x180
[52544.284793]  [<ffffffff811285ce>] __get_free_pages+0xe/0x50
[52544.284803]  [<ffffffff81171e59>] kmalloc_order_trace+0x39/0xf0
[52544.284818]  [<ffffffff8125f620>] check_partition+0x30/0x210
[52544.284829]  [<ffffffff8125f35d>] rescan_partitions+0xad/0x290
[52544.284843]  [<ffffffff811c68f6>] __blkdev_get+0x306/0x4d0
[52544.284854]  [<ffffffff811a5d48>] ? find_inode+0x38/0xb0
[52544.284865]  [<ffffffff811c6c55>] blkdev_get+0x195/0x2f0
[52544.284873]  [<ffffffff811a6069>] ? unlock_new_inode+0x59/0x80
[52544.284884]  [<ffffffff811c5410>] ? bdget+0x130/0x150
[52544.284895]  [<ffffffff8125cbc4>] add_disk+0x3a4/0x490
[52544.284932]  [<ffffffffa004b3c9>] sd_probe_async+0x129/0x1e0 [sd_mod]
[52544.284954]  [<ffffffff810831ba>] async_run_entry_fn+0xaa/0x1c0
[52544.284966]  [<ffffffff81075e6a>] process_one_work+0x15a/0x4e0
[52544.284976]  [<ffffffff810765cd>] worker_thread+0x15d/0x400
[52544.284986]  [<ffffffff81076470>] ? rescuer_thread+0x240/0x240
[52544.284998]  [<ffffffff8107b2f0>] kthread+0xc0/0xd0
[52544.285011]  [<ffffffff81010000>] ? perf_trace_xen_mmu_set_pte_at+0x10/0x100
[52544.285023]  [<ffffffff8107b230>] ? kthread_freezable_should_stop+0x70/0x70
[52544.285035]  [<ffffffff814da6ec>] ret_from_fork+0x7c/0xb0
[52544.285046]  [<ffffffff8107b230>] ? kthread_freezable_should_stop+0x70/0x70
[52544.285052] Mem-Info:
[52544.285057] Node 0 DMA per-cpu:
[52544.285065] CPU    0: hi:    0, btch:   1 usd:   0
[52544.285071] CPU    1: hi:    0, btch:   1 usd:   0
[52544.285076] CPU    2: hi:    0, btch:   1 usd:   0
[52544.285080] CPU    3: hi:    0, btch:   1 usd:   0
[52544.285084] Node 0 DMA32 per-cpu:
[52544.285091] CPU    0: hi:  186, btch:  31 usd:   0
[52544.285097] CPU    1: hi:  186, btch:  31 usd:   0
[52544.285102] CPU    2: hi:  186, btch:  31 usd:   0
[52544.285107] CPU    3: hi:  186, btch:  31 usd:   0
[52544.285110] Node 0 Normal per-cpu:
[52544.285117] CPU    0: hi:  186, btch:  31 usd:   0
[52544.285122] CPU    1: hi:  186, btch:  31 usd:   0
[52544.285127] CPU    2: hi:  186, btch:  31 usd:   0
[52544.285132] CPU    3: hi:  186, btch:  31 usd:   0
[52544.285146] active_anon:325339 inactive_anon:53539 isolated_anon:0
 active_file:396016 inactive_file:376501 isolated_file:0
 unevictable:2261 dirty:142 writeback:0 unstable:0
 free:142486 slab_reclaimable:661015 slab_unreclaimable:10370
 mapped:21500 shmem:54173 pagetables:8360 bounce:0
 free_cma:0
[52544.285160] Node 0 DMA free:15844kB min:128kB low:160kB high:192kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15308kB managed:15844kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52544.285177] lowmem_reserve[]: 0 3359 7870 7870
[52544.285188] Node 0 DMA32 free:502696kB min:28796kB low:35992kB high:43192kB active_anon:110992kB inactive_anon:2412kB active_file:541116kB inactive_file:436276kB unevictable:1340kB isolated(anon):0kB isolated(file):0kB present:3440584kB managed:3413984kB mlocked:1340kB dirty:36kB writeback:0kB mapped:10388kB shmem:2640kB slab_reclaimable:1818528kB slab_unreclaimable:1892kB kernel_stack:352kB pagetables:1988kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[52544.285207] lowmem_reserve[]: 0 0 4510 4510
[52544.285217] Node 0 Normal free:51404kB min:38656kB low:48320kB high:57984kB active_anon:1190364kB inactive_anon:211744kB active_file:1042948kB inactive_file:1069728kB unevictable:7704kB isolated(anon):0kB isolated(file):0kB present:4618656kB managed:4559244kB mlocked:7704kB dirty:532kB writeback:0kB mapped:75612kB shmem:214052kB slab_reclaimable:825532kB slab_unreclaimable:39588kB kernel_stack:2600kB pagetables:31452kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[52544.285234] lowmem_reserve[]: 0 0 0 0
[52544.285244] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 3*64kB (U) 2*128kB (U) 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15844kB
[52544.285283] Node 0 DMA32: 29021*4kB (UEMR) 22970*8kB (UEMR) 12419*16kB (UEMR) 102*32kB (UEMR) 18*64kB (UEM) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 502964kB
[52544.285317] Node 0 Normal: 12354*4kB (UEM) 275*8kB (UEM) 5*16kB (UEM) 4*32kB (UEM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 51824kB
[52544.285350] 827517 total pagecache pages
[52544.285355] 0 pages in swap cache
[52544.285361] Swap cache stats: add 0, delete 0, find 0/0
[52544.285365] Free swap  = 0kB
[52544.285369] Total swap = 0kB
[52544.367333] 2090480 pages RAM
[52544.367340] 91490 pages reserved
[52544.367345] 2452953 pages shared
[52544.367350] 1171799 pages non-shared
[52544.371026] sd 6:0:0:0: [sdb] No Caching mode page present
[52544.371036] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[52544.371042] sd 6:0:0:0: [sdb] Attached SCSI disk
[53028.473001] usb 3-1.2: USB disconnect, device number 7
[53028.633950] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
[53033.939910] ehci-pci 0000:00:1a.0: power state changed by ACPI to D0
[53034.040415] ehci-pci 0000:00:1a.0: setting latency timer to 64
[53034.040720] ehci-pci 0000:00:1d.0: power state changed by ACPI to D0
[53034.143616] ehci-pci 0000:00:1d.0: setting latency timer to 64
[53034.143829] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[53034.156833] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
[53034.248274] xhci_hcd 0000:00:14.0: setting latency timer to 64
[53034.253526] usb 3-1.2: new high-speed USB device number 8 using ehci-pci
[53034.441346] scsi7 : usb-storage 3-1.2:1.0
[53034.453085] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[53041.897461] scsi 7:0:0:0: Direct-Access     Samsung  STORY Station 3  1AJ1 PQ: 0 ANSI: 0
[53041.898979] sd 7:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[53041.900292] sd 7:0:0:0: [sdb] Write Protect is off
[53041.900303] sd 7:0:0:0: [sdb] Mode Sense: 23 00 00 00
[53041.901618] sd 7:0:0:0: [sdb] No Caching mode page present
[53041.901625] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[53041.907391] sd 7:0:0:0: [sdb] No Caching mode page present
[53041.907399] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[53041.951590]  sdb: sdb1 sdb2 sdb3 sdb4
[53041.956602] sd 7:0:0:0: [sdb] No Caching mode page present
[53041.956613] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[53041.956622] sd 7:0:0:0: [sdb] Attached SCSI disk

--k+w/mQv8wyuph6w0--
