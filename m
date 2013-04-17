Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab3DQTe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:34:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758367Ab3DQTeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:34:25 -0400
Date: Wed, 17 Apr 2013 15:34:20 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: WARNING: at kernel/watchdog.c:245
 watchdog_overflow_callback+0x98/0xc0()
Message-ID: <20130417193420.GA12217@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slightly old kernel, but likely still relevant judging by recent commits.
Hit an oom condition while fuzz testing, but what's interesting is what
happened immediately afterwards.. (the lockup)

Could this just be that the kernel was so busy recovering from swapping etc
that watchdog perceived that as a lockup ?

	Dave

[30083.362814] Out of memory: Kill process 206183 (trinity-child6) score 710 or sacrifice child
[30083.365905] Killed process 206183 (trinity-child6) total-vm:2169612kB, anon-rss:505916kB, file-rss:1556kB
[30594.491504] htop invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
[30594.493956] htop cpuset=/ mems_allowed=0
[30594.495921] Pid: 1270, comm: htop Not tainted 3.9.0-rc6+ #21
[30594.498051] Call Trace:
[30594.500947]  [<ffffffff8114823f>] dump_header+0x7f/0x3f0
[30594.502961]  [<ffffffff810b6ac5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[30594.505094]  [<ffffffff810b6b5d>] ? trace_hardirqs_on+0xd/0x10
[30594.507120]  [<ffffffff816c55c2>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[30594.509330]  [<ffffffff81148a6a>] oom_kill_process+0x2fa/0x4b0
[30594.511367]  [<ffffffff81349fe0>] ? delay_tsc+0x90/0xe0
[30594.513301]  [<ffffffff81149480>] out_of_memory+0x600/0x680
[30594.515283]  [<ffffffff8114f9b9>] __alloc_pages_nodemask+0xa59/0xb70
[30594.517369]  [<ffffffff81191088>] alloc_pages_current+0xb8/0x180
[30594.519442]  [<ffffffff811443ef>] __page_cache_alloc+0xbf/0x100
[30594.521491]  [<ffffffff81144c15>] ? find_get_page+0x5/0x280
[30594.523502]  [<ffffffff81146f10>] filemap_fault+0x1a0/0x430
[30594.525494]  [<ffffffff8116fee1>] __do_fault+0x71/0x570
[30594.527427]  [<ffffffff8100a144>] ? native_sched_clock+0x24/0x80
[30594.529478]  [<ffffffff81172f83>] handle_pte_fault+0xa3/0x8f0
[30594.531475]  [<ffffffff81349ec6>] ? __const_udelay+0x36/0x40
[30594.533465]  [<ffffffff8106d694>] ? __rcu_read_unlock+0x54/0xa0
[30594.535484]  [<ffffffff81174548>] handle_mm_fault+0x288/0x590
[30594.537484]  [<ffffffff816c93e4>] __do_page_fault+0x164/0x5b0
[30594.539497]  [<ffffffff8114e36a>] ? __free_pages+0x5a/0x90
[30594.541460]  [<ffffffff8134b3ad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[30594.543550]  [<ffffffff816c983e>] do_page_fault+0xe/0x10
[30594.545492]  [<ffffffff816c64a2>] page_fault+0x22/0x30
[30594.547436] Mem-Info:
[30594.549049] Node 0 DMA per-cpu:
[30594.550770] CPU    0: hi:    0, btch:   1 usd:   0
[30594.552653] CPU    1: hi:    0, btch:   1 usd:   0
[30594.554520] CPU    2: hi:    0, btch:   1 usd:   0
[30594.556366] CPU    3: hi:    0, btch:   1 usd:   0
[30594.558237] Node 0 DMA32 per-cpu:
[30594.559935] CPU    0: hi:  186, btch:  31 usd:   0
[30594.561771] CPU    1: hi:  186, btch:  31 usd:  30
[30594.563594] CPU    2: hi:  186, btch:  31 usd:  32
[30594.565415] CPU    3: hi:  186, btch:  31 usd:  31
[30594.567220] Node 0 Normal per-cpu:
[30594.568921] CPU    0: hi:  186, btch:  31 usd:   0
[30594.570737] CPU    1: hi:  186, btch:  31 usd:   0
[30594.572541] CPU    2: hi:  186, btch:  31 usd:   0
[30594.574334] CPU    3: hi:  186, btch:  31 usd:   0
[30594.576119] active_anon:722548 inactive_anon:192114 isolated_anon:0
[30594.576119]  active_file:72 inactive_file:0 isolated_file:0
[30594.576119]  unevictable:0 dirty:9 writeback:44725 unstable:0
[30594.576119]  free:21439 slab_reclaimable:8412 slab_unreclaimable:33937
[30594.576119]  mapped:340 shmem:332 pagetables:5989 bounce:0
[30594.576119]  free_cma:0
[30594.587225] Node 0 DMA free:15828kB min:264kB low:328kB high:396kB active_anon:0kB inactive_anon:48kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15964kB managed:15880kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:4kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:12 all_unreclaimable? yes
[30594.596120] lowmem_reserve[]: 0 3210 3898 3898
[30594.598141] Node 0 DMA32 free:58072kB min:55432kB low:69288kB high:83148kB active_anon:2652376kB inactive_anon:530556kB active_file:20kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3388932kB managed:3287044kB mlocked:0kB dirty:16kB writeback:140528kB mapped:20kB shmem:24kB slab_reclaimable:536kB slab_unreclaimable:28408kB kernel_stack:48kB pagetables:16064kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:425 all_unreclaimable? yes
[30594.609778] lowmem_reserve[]: 0 0 688 688
[30594.611970] Node 0 Normal free:11856kB min:11880kB low:14848kB high:17820kB active_anon:237816kB inactive_anon:237852kB active_file:268kB inactive_file:212kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:786432kB managed:704576kB mlocked:0kB dirty:20kB writeback:38372kB mapped:1340kB shmem:1304kB slab_reclaimable:33112kB slab_unreclaimable:107340kB kernel_stack:1080kB pagetables:7888kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:2700 all_unreclaimable? yes
[30594.624513] lowmem_reserve[]: 0 0 0 0
[30594.626829] Node 0 DMA: 1*4kB (U) 0*8kB 1*16kB (M) 0*32kB 3*64kB (UM) 2*128kB (UM) 2*256kB (UM) 1*512kB (M) 2*1024kB (UM) 2*2048kB (MR) 2*4096kB (M) = 15828kB
[30594.632942] Node 0 DMA32: 10*4kB (UEM) 59*8kB (UEM) 170*16kB (UEM) 285*32kB (UEM) 203*64kB (UEM) 78*128kB (UEM) 31*256kB (UEM) 17*512kB (UEM) 2*1024kB (U) 2*2048kB (R) 0*4096kB = 58112kB
[30594.639577] Node 0 Normal: 188*4kB (UEM) 56*8kB (EM) 179*16kB (UEMR) 139*32kB (UEMR) 4*64kB (MR) 2*128kB (R) 2*256kB (R) 2*512kB (R) 2*1024kB (R) 0*2048kB 0*4096kB = 12608kB
[30594.646193] 46310 total pagecache pages
[30594.648789] 45867 pages in swap cache
[30594.651305] Swap cache stats: add 25367557, delete 25321690, find 29087/36684
[30594.654251] Free swap  = 0kB
[30594.656690] Total swap = 6160380kB
[30594.678170] 1048575 pages RAM
[30594.680744] 46700 pages reserved
[30594.683208] 1051159 pages shared
[30594.685658] 975076 pages non-shared
[30594.688136] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[30594.691227] [  175]     0   175    10364        1      22      213         -1000 systemd-udevd
[30594.693360] [  177]     0   177    74750       77     153       71             0 systemd-journal
[30594.695492] [  290]     0   290     6074        1      15      168             0 smartd
[30594.697616] [  291]     0   291    66293       16      32      168             0 rsyslogd
[30594.699777] [  293]     0   293    86473       54      83      218             0 NetworkManager
[30594.701904] [  294]    38   294     8877       30      21      122             0 ntpd
[30594.704028] [  296]     0   296     8270        1      20       79             0 systemd-logind
[30594.706161] [  299]    70   299     7050       54      30       46             0 avahi-daemon
[30594.708337] [  300]    81   300     6080        1      27       99          -900 dbus-daemon
[30594.710470] [  307]     0   307    31012       24      16      126             0 crond
[30594.712596] [  322]     0   322    28807       41      11       18             0 ksmtuned
[30594.714721] [  327]     0   327    27498        1      12       27             0 agetty
[30594.716835] [  341]    70   341     6985        0      22       50             0 avahi-daemon
[30594.719006] [  344]   997   344    92850        1      45     1151             0 polkitd
[30594.721130] [  351]     0   351    21460        1      63      190          -900 modem-manager
[30594.723272] [  355]    32   355     4801       16      14       52             0 rpcbind
[30594.725424] [  367]     0   367    20090        1      41      202         -1000 sshd
[30594.727590] [  378]    29   378     5894        1      16      117             0 rpc.statd
[30594.729795] [  380]     0   380    23174        1      45     2999             0 dhclient
[30594.731964] [  384]     0   384    32750       10      67      271             0 sshd
[30594.734140] [  406]  1000   406    32779       46      65      252             0 sshd
[30594.736322] [  421]  1000   421    29247        1      18      499             0 bash
[30594.738547] [  465]     0   465    23112       42      43      399             0 sendmail
[30594.740743] [  509]    51   509    21453        1      41      380             0 sendmail
[30594.742932] [  687]  1000   687     4992        6      24       77             0 tmux
[30594.745132] [  689]  1000   689     5710      137      24      144             0 tmux
[30594.747336] [  690]  1000   690    29251        1      17      501             0 bash
[30594.749587] [  831]  1000   831    28283        2      16       49             0 test-multi.sh
[30594.751800] [ 1034]  1000  1034    29216        1      18      465             0 bash
[30594.754000] [ 1270]  1000  1270    30273      364      21       33             0 htop
[30594.756192] [10500]  1000 10500    29249        1      18      502             0 bash
[30594.758406] [10917]     0 10917    46745        1      45      155             0 sudo
[30594.760582] [10942]     0 10942    26979       13      11       11             0 tail
[30594.762752] [200455]  1000 200455     8572      329      13      543             0 trinity
[30594.764880] [200457]  1000 200457     8572       21      12      534             0 trinity-watchdo
[30594.766951] [200458]  1000 200458     8572       13      11      540             0 trinity-main
[30594.768993] [206179]  1000 206179   590596    97474    1152   485403           500 trinity-child2
[30594.770971] [206180]  1000 206180   598137   120929    1166   469510           500 trinity-child3
[30594.772894] [206184]  1000 206184   576302   111835    1124   456746           500 trinity-child7
[30594.774759] [206310]  1000 206310   205383   153820     399    43863           500 trinity-child0
[30594.776572] [206317]  1000 206317   158940   120015     309    31234           500 trinity-child5
[30594.778355] [206325]  1000 206325   124850    97321     242    19832           500 trinity-child1
[30594.780141] [206326]  1000 206326   130869   103662     254    19494           500 trinity-child4
[30594.781848] [206362]  1000 206362    79865    65226     153     6920           500 trinity-child6
[30594.783497] [206411]     0 206411    26970       20      11        0             0 sleep
[30594.785107] Out of memory: Kill process 206180 (trinity-child3) score 732 or sacrifice child
[30594.787665] Killed process 206180 (trinity-child3) total-vm:2392548kB, anon-rss:482396kB, file-rss:1316kB
[30657.402029] ------------[ cut here ]------------
[30657.403625] WARNING: at kernel/watchdog.c:245 watchdog_overflow_callback+0x98/0xc0()
[30657.405127] Hardware name: GA-MA78GM-S2H
[30657.406572] Watchdog detected hard LOCKUP on cpu 3
[30657.406603] Modules linked in: vmw_vsock_vmci_transport vmw_vmci vsock 8021q garp stp mrp hidp rfcomm bnep ipt_ULOG nfnetlink cmtp kernelcapi can_raw can_bcm can caif_socket caif scsi_transport_iscsi llc2 irda crc_ccitt decnet l2tp_ppp l2tp_netlink l2tp_core pppoe pppox ppp_generic slhc ipx af_802154 p8023 p8022 nfc af_key atm x25 rose netrom ax25 af_rxrpc rds appletalk psnap llc phonet dccp_ipv6 dccp_ipv4 dccp sctp libcrc32c lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec kvm_amd kvm raid0 snd_pcm btusb microcode bluetooth serio_raw snd_page_alloc snd_timer pcspkr snd edac_core rfkill soundcore r8169 mii radeon backlight drm_kms_helper ttm
[30657.415828] Pid: 290, comm: smartd Not tainted 3.9.0-rc6+ #21
[30657.417415] Call Trace:
[30657.418994]  <NMI>  [<ffffffff810450a5>] warn_slowpath_common+0x75/0xa0
[30657.420626]  [<ffffffff8104511c>] warn_slowpath_fmt+0x4c/0x50
[30657.422260]  [<ffffffff810b3268>] ? trace_hardirqs_off_caller+0x28/0xc0
[30657.423909]  [<ffffffff810f56d0>] ? watchdog_enable+0x1f0/0x1f0
[30657.425562]  [<ffffffff810f5768>] watchdog_overflow_callback+0x98/0xc0
[30657.427207]  [<ffffffff811396dd>] __perf_event_overflow+0x9d/0x320
[30657.428836]  [<ffffffff81137fea>] ? perf_event_update_userpage+0x16a/0x2b0
[30657.430471]  [<ffffffff81137e80>] ? perf_event_task_disable+0x90/0x90
[30657.432101]  [<ffffffff8113ac44>] perf_event_overflow+0x14/0x20
[30657.433736]  [<ffffffff810139a4>] x86_pmu_handle_irq+0x124/0x170
[30657.435373]  [<ffffffff816c7cad>] perf_event_nmi_handler+0x1d/0x20
[30657.437010]  [<ffffffff816c727e>] nmi_handle.isra.2+0xae/0x200
[30657.438647]  [<ffffffff816c71d5>] ? nmi_handle.isra.2+0x5/0x200
[30657.440285]  [<ffffffff816c74d8>] do_nmi+0x108/0x360
[30657.441917]  [<ffffffff816c6857>] end_repeat_nmi+0x1e/0x2e
[30657.443551]  [<ffffffff813108fd>] ? elv_dispatch_sort+0x7d/0xe0
[30657.445187]  [<ffffffff813108fd>] ? elv_dispatch_sort+0x7d/0xe0
[30657.446814]  [<ffffffff813108fd>] ? elv_dispatch_sort+0x7d/0xe0
[30657.448425]  <<EOE>>  [<ffffffff81335c49>] cfq_dispatch_insert+0x149/0x2e0
[30657.450063]  [<ffffffff81335b50>] ? cfq_dispatch_insert+0x50/0x2e0
[30657.451701]  [<ffffffff8133002f>] ? throtl_trim_slice.isra.21+0x26f/0x3a0
[30657.453344]  [<ffffffff8100a144>] ? native_sched_clock+0x24/0x80
[30657.454986]  [<ffffffff8100a144>] ? native_sched_clock+0x24/0x80
[30657.456613]  [<ffffffff810b3268>] ? trace_hardirqs_off_caller+0x28/0xc0
[30657.458250]  [<ffffffff8133854e>] cfq_dispatch_requests+0xb6e/0xca0
[30657.459890]  [<ffffffff810b3382>] ? get_lock_stats+0x22/0x70
[30657.461535]  [<ffffffff810b3aae>] ? put_lock_stats.isra.27+0xe/0x40
[30657.463183]  [<ffffffff816c562c>] ? _raw_spin_unlock_irq+0x2c/0x60
[30657.464835]  [<ffffffff8131178a>] elv_drain_elevator+0x2a/0xa0
[30657.466491]  [<ffffffff81311883>] __elv_add_request+0x83/0x370
[30657.468147]  [<ffffffff8131eef1>] blk_execute_rq_nowait+0x71/0xf0
[30657.469814]  [<ffffffff8131f063>] blk_execute_rq+0xb3/0x140
[30657.471477]  [<ffffffff810b3382>] ? get_lock_stats+0x22/0x70
[30657.473142]  [<ffffffff810b3382>] ? get_lock_stats+0x22/0x70
[30657.474792]  [<ffffffff8116fdd3>] ? might_fault+0x53/0xb0
[30657.476440]  [<ffffffff8116fdd3>] ? might_fault+0x53/0xb0
[30657.478076]  [<ffffffff812d7228>] ? security_capable+0x18/0x20
[30657.479717]  [<ffffffff81053034>] ? ns_capable+0x44/0x80
[30657.481359]  [<ffffffff81325af3>] sg_io+0x2b3/0x490
[30657.482989]  [<ffffffff81325f8f>] scsi_cmd_ioctl+0x2bf/0x470
[30657.484627]  [<ffffffff810b3268>] ? trace_hardirqs_off_caller+0x28/0xc0
[30657.486282]  [<ffffffff810b3382>] ? get_lock_stats+0x22/0x70
[30657.487931]  [<ffffffff8132618f>] scsi_cmd_blk_ioctl+0x4f/0x70
[30657.489584]  [<ffffffff8147e64e>] sd_ioctl+0xce/0x150
[30657.491236]  [<ffffffff81321cc4>] blkdev_ioctl+0x234/0x820
[30657.492890]  [<ffffffff810b3aae>] ? put_lock_stats.isra.27+0xe/0x40
[30657.494556]  [<ffffffff810b40f5>] ? lock_release_holdtime.part.28+0xe5/0x150
[30657.496235]  [<ffffffff811fbc17>] block_ioctl+0x47/0x50
[30657.497915]  [<ffffffff811cfc0d>] do_vfs_ioctl+0x2ed/0x520
[30657.499596]  [<ffffffff811dbbac>] ? fget_light+0x38c/0x500
[30657.501267]  [<ffffffff811cfed1>] sys_ioctl+0x91/0xb0
[30657.502916]  [<ffffffff816cde42>] system_call_fastpath+0x16/0x1b
[30657.504543] ---[ end trace 5bd910c4d31e830c ]---

