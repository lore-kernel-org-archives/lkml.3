Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbbAHMwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:52:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbbAHMwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:52:04 -0500
Message-ID: <54AE7D53.2020305@redhat.com>
Date: Thu, 08 Jan 2015 06:51:31 -0600
From: Mark Langsdorf <mlangsdo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Linux 3.19-rc3
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
In-Reply-To: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 07:46 PM, Linus Torvalds wrote:
> It's a day delayed - not because of any particular development issues,
> but simply because I was tiling a bathroom yesterday. But rc3 is out
> there now, and things have stayed reasonably calm. I really hope that
> implies that 3.19 is looking good, but it's equally likely that it's
> just that people are still recovering from the holiday season.

I'm consistently getting an out of memory killer triggered when
compiling the kernel (make -j 16 -s) on a 16 core ARM64 system
with 16 GB of memory. This doesn't happen when running a 3.18
kernel.

I'm going to start bisecting the failure now, but here's the crash
log in case someone can see something obvious in it.

--Mark Langsdorf

[  137.440443] random: nonblocking pool is initialized
[ 1053.720094] cc1 invoked oom-killer: gfp_mask=0x200da, order=0, 
oom_score_adj=0
[ 1053.727292] cc1 cpuset=/ mems_allowed=0
[ 1053.731169] CPU: 5 PID: 32180 Comm: cc1 Not tainted 3.19.0-rc3+ #2
[ 1053.737321] Hardware name: APM X-Gene Mustang board (DT)
[ 1053.742627] Call trace:
[ 1053.745073] [<fffffe0000096954>] dump_backtrace+0x0/0x16c
[ 1053.750465] [<fffffe0000096ad0>] show_stack+0x10/0x1c
[ 1053.755498] [<fffffe000062911c>] dump_stack+0x74/0x98
[ 1053.760543] [<fffffe0000626550>] dump_header.isra.11+0x98/0x1d0
[ 1053.766439] [<fffffe000017c4e0>] oom_kill_process+0x3ac/0x408
[ 1053.772182] [<fffffe000017c9d4>] out_of_memory+0x2a4/0x2d4
[ 1053.777647] [<fffffe0000180b78>] __alloc_pages_nodemask+0x808/0x8d8
[ 1053.783898] [<fffffe00001a443c>] handle_mm_fault+0x938/0xd1c
[ 1053.789544] [<fffffe00000a01c8>] do_page_fault+0x214/0x338
[ 1053.795004] [<fffffe000009022c>] do_mem_abort+0x38/0x9c
[ 1053.800211] Exception stack(0xfffffe0010b1fe30 to 0xfffffe0010b1ff50)
[ 1053.806622] fe20:                                     00000200 
00000000 00f886a8 00000000
[ 1053.814771] fe40: ffffffff ffffffff aa924620 000003ff 00b11000 
fffffe00 000f7c84 fffffe00
[ 1053.822915] fe60: 10b1fea0 fffffe00 000903b4 fffffe00 10b1fed0 
fffffe00 0002000c fffffc00
[ 1053.831063] fe80: 00b686b8 fffffe00 00020010 fffffc00 10b1feb0 
fffffe00 000964e8 fffffe00
[ 1053.839211] fea0: 00000208 00000000 00092f90 fffffe00 cac18530 
000003ff 0009308c fffffe00
[ 1053.847348] fec0: 00000200 00000000 00093094 fffffe00 a28e0000 
000003ff 00000000 00000000
[ 1053.855489] fee0: 00000248 00000000 a28e0000 000003ff 00000000 
00000000 a28e0000 000003ff
[ 1053.863630] ff00: 00000009 00000000 00000009 00000000 00fe8000 
00000000 00000480 00000000
[ 1053.871779] ff20: 008213c8 00000000 000000a2 00000000 00000006 
00000000 00000018 00000000
[ 1053.879921] ff40: 00000008 00000000 00000000 00000000
[ 1053.884946] Mem-Info:
[ 1053.887206] DMA per-cpu:
[ 1053.889731] CPU    0: hi:    6, btch:   1 usd:   0
[ 1053.894496] CPU    1: hi:    6, btch:   1 usd:   0
[ 1053.899268] CPU    2: hi:    6, btch:   1 usd:   0
[ 1053.904034] CPU    3: hi:    6, btch:   1 usd:   0
[ 1053.908809] CPU    4: hi:    6, btch:   1 usd:   0
[ 1053.913576] CPU    5: hi:    6, btch:   1 usd:   0
[ 1053.918350] CPU    6: hi:    6, btch:   1 usd:   0
[ 1053.923115] CPU    7: hi:    6, btch:   1 usd:   0
[ 1053.927880] Normal per-cpu:
[ 1053.930663] CPU    0: hi:    6, btch:   1 usd:   0
[ 1053.935428] CPU    1: hi:    6, btch:   1 usd:   0
[ 1053.940198] CPU    2: hi:    6, btch:   1 usd:   0
[ 1053.944963] CPU    3: hi:    6, btch:   1 usd:   0
[ 1053.949732] CPU    4: hi:    6, btch:   1 usd:   0
[ 1053.954497] CPU    5: hi:    6, btch:   1 usd:   0
[ 1053.959271] CPU    6: hi:    6, btch:   1 usd:   0
[ 1053.964038] CPU    7: hi:    6, btch:   1 usd:   0
[ 1053.968815] active_anon:207417 inactive_anon:25722 isolated_anon:0
[ 1053.968815]  active_file:1300 inactive_file:21234 isolated_file:0
[ 1053.968815]  unevictable:0 dirty:0 writeback:0 unstable:0
[ 1053.968815]  free:1014 slab_reclaimable:1047 slab_unreclaimable:1758
[ 1053.968815]  mapped:733 shmem:58 pagetables:267 bounce:0
[ 1053.968815]  free_cma:1
[ 1054.000398] DMA free:52928kB min:4032kB low:4992kB high:6016kB 
active_anon:3025728kB inactive_anon:612608kB active_file:20992kB 
inactive_file:323072kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:15168kB shmem:1792kB 
slab_reclaimable:26368kB slab_unreclaimable:36160kB kernel_stack:464kB 
pagetables:6976kB unstable:0kB bounce:0kB free_cma:64kB 
writeback_tmp:0kB pages_scanned:26151872 all_unreclaimable? yes
[ 1054.043628] lowmem_reserve[]: 0 765 765
[ 1054.047498] Normal free:12032kB min:12224kB low:15232kB high:18304kB 
active_anon:10248960kB inactive_anon:1033728kB active_file:62208kB 
inactive_file:1036032kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:12582912kB managed:12538176kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:31744kB shmem:1920kB 
slab_reclaimable:40640kB slab_unreclaimable:76352kB kernel_stack:2992kB 
pagetables:10112kB unstable:0kB bounce:0kB free_cma:0kB 
writeback_tmp:0kB pages_scanned:82150272 all_unreclaimable? yes
[ 1054.091760] lowmem_reserve[]: 0 0 0
[ 1054.095277] DMA: 109*64kB (UR) 53*128kB (R) 8*256kB (R) 0*512kB 
0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 
0*65536kB = 52672kB
[ 1054.108621] Normal: 191*64kB (MR) 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 12224kB
[ 1054.120708] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=524288kB
[ 1054.129280] 43732 total pagecache pages
[ 1054.133096] 25736 pages in swap cache
[ 1054.136739] Swap cache stats: add 27971, delete 2235, find 0/1
[ 1054.142545] Free swap  = 6598400kB
[ 1054.145928] Total swap = 8388544kB
[ 1054.149317] 262112 pages RAM
[ 1054.152180] 0 pages HighMem/MovableOnly
[ 1054.155995] 18446744073709544361 pages reserved
[ 1054.160505] 8192 pages cma reserved
[ 1054.163974] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[ 1054.171784] [  481]     0   481      233       89       3       39 
           0 systemd-journal
[ 1054.180534] [  487]     0   487     1420       32       3       80 
           0 lvmetad
[ 1054.188591] [  512]     0   512      216       40       2       46 
       -1000 systemd-udevd
[ 1054.197162] [  598]     0   598      258       45       3       38 
       -1000 auditd
[ 1054.205133] [  620]     0   620     6825      213       3      114 
           0 NetworkManager
[ 1054.213794] [  623]     0   623     2028       83       3      100 
           0 abrtd
[ 1054.221678] [  624]     0   624     2019       78       3       92 
           0 abrt-watch-log
[ 1054.230338] [  628]    70   628       87       38       4       34 
           0 avahi-daemon
[ 1054.238826] [  629]   998   629       40       13       2        0 
           0 lsmd
[ 1054.246617] [  631]    70   631       87        0       4       32 
           0 avahi-daemon
[ 1054.255106] [  641]     0   641     2687       48       3       77 
           0 rsyslogd
[ 1054.263248] [  642]     0   642       86       42       3        9 
           0 irqbalance
[ 1054.271563] [  643]     0   643     6821      196       5      241 
           0 tuned
[ 1054.279447] [  647]     0   647      109       44       2       31 
           0 smartd
[ 1054.287411] [  651]   997   651       83       45       2       18 
           0 chronyd
[ 1054.295466] [  652]     0   652       99       38       3       36 
           0 systemd-logind
[ 1054.304129] [  653]    81   653      222       35       2       37 
        -900 dbus-daemon
[ 1054.312531] [  667]     0   667       79       27       3       29 
           0 atd
[ 1054.320242] [  675]     0   675     1846       68       4       86 
           0 login
[ 1054.328125] [  676]     0   676     1717       23       5       10 
           0 agetty
[ 1054.336089] [  710]     0   710     1761       47       3       36 
           0 bash
[ 1054.343887] [  727]     0   727      240       84       2       74 
       -1000 sshd
[ 1054.351684] [  733]     0   733     1739       34       3        9 
           0 rhsmcertd
[ 1054.359913] [  741]   999   741     7276      118       4      122 
           0 polkitd
[ 1054.367964] [  747]     0   747      502      102       3      281 
           0 dhclient
[ 1054.376106] [ 1323]     0  1323      334       69       3       69 
           0 master
[ 1054.384075] [ 1325]    89  1325      337       82       2       78 
           0 qmgr
[ 1054.391872] [ 1328]     0  1328      358      130       3      111 
           0 sshd
[ 1054.399669] [ 1331]     0  1331     1762       48       5       39 
           0 bash
[ 1054.407460] [ 1373]    89  1373      336       89       2       69 
           0 pickup
[ 1054.415430] [ 2944]     0  2944     1734       50       4        3 
           0 make
[ 1054.423228] [31425]     0 31425     1760       79       3        0 
           0 make
[ 1054.431028] [32092]     0 32092     1736       51       4        0 
           0 sh
[ 1054.438652] [32103]     0 32103     1736       51       4        0 
           0 sh
[ 1054.446271] [32108]     0 32108     1737       42       4        0 
           0 gcc
[ 1054.453981] [32110]     0 32110     1736       52       4        0 
           0 sh
[ 1054.461605] [32111]     0 32111     2479      373       4        0 
           0 cc1
[ 1054.469315] [32118]     0 32118     1736       52       4        0 
           0 sh
[ 1054.476934] [32120]     0 32120     1737       42       4        0 
           0 gcc
[ 1054.484644] [32123]     0 32123     1736       51       4        0 
           0 sh
[ 1054.492269] [32125]     0 32125     2479      373       4        0 
           0 cc1
[ 1054.499980] [32127]     0 32127     1737       43       4        0 
           0 gcc
[ 1054.507684] [32132]     0 32132     1736       52       4        0 
           0 sh
[ 1054.515308] [32134]     0 32134     1737       42       5        0 
           0 gcc
[ 1054.523019] [32135]     0 32135     2472      304       4        0 
           0 cc1
[ 1054.530730] [32136]     0 32136     2474      314       4        0 
           0 cc1
[ 1054.538440] [32140]     0 32140     1736       52       3        0 
           0 sh
[ 1054.546058] [32141]     0 32141     1737       42       4        0 
           0 gcc
[ 1054.553768] [32142]     0 32142     1736       51       3        0 
           0 sh
[ 1054.561394] [32146]     0 32146     1737       42       4        0 
           0 gcc
[ 1054.569105] [32150]     0 32150     1736       52       4        0 
           0 sh
[ 1054.576723] [32151]     0 32151     2474      314       3        0 
           0 cc1
[ 1054.584433] [32154]     0 32154     1737       42       4        0 
           0 gcc
[ 1054.592143] [32157]     0 32157     1736       51       3        0 
           0 sh
[ 1054.599767] [32158]     0 32158     2479      373       4        0 
           0 cc1
[ 1054.607472] [32164]     0 32164     1737       43       5        0 
           0 gcc
[ 1054.615183] [32165]     0 32165     1736       52       3        0 
           0 sh
[ 1054.622808] [32166]     0 32166     1737       42       4        0 
           0 gcc
[ 1054.630524] [32170]     0 32170     2466      232       3        0 
           0 cc1
[ 1054.638236] [32173]     0 32173     2470      232       4        0 
           0 cc1
[ 1054.645941] [32176]     0 32176     1736       52       4        0 
           0 sh
[ 1054.653566] [32178]     0 32178     1737       42       4        0 
           0 gcc
[ 1054.661276] [32180]     0 32180     2474      313       3        0 
           0 cc1
[ 1054.668986] [32182]     0 32182     1736       51       3        0 
           0 sh
[ 1054.676604] [32184]     0 32184     1737       42       3        0 
           0 gcc
[ 1054.684314] [32185]     0 32185     1736       52       5        0 
           0 sh
[ 1054.691940] [32186]     0 32186     1737       42       4        0 
           0 gcc
[ 1054.699650] [32188]     0 32188     2464      199       4        0 
           0 cc1
[ 1054.707354] [32190]     0 32190     1736       51       4        0 
           0 sh
[ 1054.714978] [32194]     0 32194     2466      232       4        0 
           0 cc1
[ 1054.722688] [32195]     0 32195     1737       43       4        0 
           0 gcc
[ 1054.730397] [32197]     0 32197     1736       13       4        0 
           0 sh
[ 1054.738015] [32199]     0 32199     2464      199       4        0 
           0 cc1
[ 1054.745725] [32200]     0 32200       70       34       3        0 
           0 mv
[ 1054.753349] [32201]     0 32201     1760       79       3        0 
           0 make
[ 1054.761146] [32202]     0 32202     1909      157       4        0 
           0 as
[ 1054.768770] Out of memory: Kill process 643 (tuned) score 1 or 
sacrifice child
[ 1054.775957] Killed process 643 (tuned) total-vm:436544kB, 
anon-rss:2496kB, file-rss:10048kB
[ 1054.828700] cc1 invoked oom-killer: gfp_mask=0x200da, order=0, 
oom_score_adj=0
[ 1054.835892] cc1 cpuset=/ mems_allowed=0
[ 1054.839764] CPU: 0 PID: 32125 Comm: cc1 Not tainted 3.19.0-rc3+ #2
[ 1054.845913] Hardware name: APM X-Gene Mustang board (DT)
[ 1054.851209] Call trace:
[ 1054.853651] [<fffffe0000096954>] dump_backtrace+0x0/0x16c
[ 1054.859033] [<fffffe0000096ad0>] show_stack+0x10/0x1c
[ 1054.864060] [<fffffe000062911c>] dump_stack+0x74/0x98
[ 1054.869094] [<fffffe0000626550>] dump_header.isra.11+0x98/0x1d0
[ 1054.874986] [<fffffe000017c4e0>] oom_kill_process+0x3ac/0x408
[ 1054.880710] [<fffffe000017c9d4>] out_of_memory+0x2a4/0x2d4
[ 1054.886169] [<fffffe0000180b78>] __alloc_pages_nodemask+0x808/0x8d8
[ 1054.892413] [<fffffe00001a443c>] handle_mm_fault+0x938/0xd1c
[ 1054.898045] [<fffffe00000a01c8>] do_page_fault+0x214/0x338
[ 1054.903509] [<fffffe000009022c>] do_mem_abort+0x38/0x9c
[ 1054.908713] Exception stack(0xfffffe011be67e30 to 0xfffffe011be67f50)
[ 1054.915122] 7e20:                                     00000200 
00000000 9d060000 000003ff
[ 1054.923266] 7e40: ffffffff ffffffff a4e64f54 000003ff 00b11000 
fffffe00 000f7c84 fffffe00
[ 1054.931408] 7e60: 1be67ea0 fffffe01 000903b4 fffffe00 1be67ed0 
fffffe01 0002000c fffffc00
[ 1054.939553] 7e80: 00b686b8 fffffe00 00096520 fffffe00 1be67eb0 
fffffe01 000964e8 fffffe00
[ 1054.947689] 7ea0: 00000208 00000000 00092f90 fffffe00 cc09e9e0 
000003ff 0009308c fffffe00
[ 1054.955832] 7ec0: 00000200 00000000 007a7d08 00000000 9d05ffe0 
000003ff 9cf68c58 000003ff
[ 1054.963977] 7ee0: 00000018 00000000 00000003 00000000 00000004 
00000004 a4e64fac 000003ff
[ 1054.972119] 7f00: a4e64fac 000003ff 00000000 00000000 00fe8000 
00000000 000005a0 00000000
[ 1054.980262] 7f20: 00a46f60 00000000 0000009d 00000000 00000006 
00000000 00000018 00000000
[ 1054.988404] 7f40: 00000008 00000000 00000000 00000000
[ 1054.993428] Mem-Info:
[ 1054.995687] DMA per-cpu:
[ 1054.998213] CPU    0: hi:    6, btch:   1 usd:   0
[ 1055.002978] CPU    1: hi:    6, btch:   1 usd:   0
[ 1055.007743] CPU    2: hi:    6, btch:   1 usd:   0
[ 1055.012514] CPU    3: hi:    6, btch:   1 usd:   0
[ 1055.017279] CPU    4: hi:    6, btch:   1 usd:   0
[ 1055.022050] CPU    5: hi:    6, btch:   1 usd:   0
[ 1055.026815] CPU    6: hi:    6, btch:   1 usd:   0
[ 1055.031586] CPU    7: hi:    6, btch:   1 usd:   0
[ 1055.036350] Normal per-cpu:
[ 1055.039133] CPU    0: hi:    6, btch:   1 usd:   0
[ 1055.043898] CPU    1: hi:    6, btch:   1 usd:   0
[ 1055.048668] CPU    2: hi:    6, btch:   1 usd:   0
[ 1055.053432] CPU    3: hi:    6, btch:   1 usd:   0
[ 1055.058203] CPU    4: hi:    6, btch:   1 usd:   0
[ 1055.062969] CPU    5: hi:    6, btch:   1 usd:   0
[ 1055.067733] CPU    6: hi:    6, btch:   1 usd:   0
[ 1055.072504] CPU    7: hi:    6, btch:   1 usd:   0
[ 1055.077274] active_anon:207422 inactive_anon:25737 isolated_anon:0
[ 1055.077274]  active_file:1301 inactive_file:21246 isolated_file:0
[ 1055.077274]  unevictable:0 dirty:0 writeback:0 unstable:0
[ 1055.077274]  free:1013 slab_reclaimable:1047 slab_unreclaimable:1758
[ 1055.077274]  mapped:734 shmem:58 pagetables:267 bounce:0
[ 1055.077274]  free_cma:0
[ 1055.108845] DMA free:52672kB min:4032kB low:4992kB high:6016kB 
active_anon:3026048kB inactive_anon:612608kB active_file:20992kB 
inactive_file:323136kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:15040kB shmem:1792kB 
slab_reclaimable:26368kB slab_unreclaimable:36160kB kernel_stack:464kB 
pagetables:6976kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:26608000 all_unreclaimable? yes
[ 1055.151981] lowmem_reserve[]: 0 765 765
[ 1055.155847] Normal free:11904kB min:12224kB low:15232kB high:18304kB 
active_anon:10248960kB inactive_anon:1034816kB active_file:62272kB 
inactive_file:1036608kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:12582912kB managed:12538176kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:31936kB shmem:1920kB 
slab_reclaimable:40640kB slab_unreclaimable:76352kB kernel_stack:2992kB 
pagetables:10112kB unstable:0kB bounce:0kB free_cma:0kB 
writeback_tmp:0kB pages_scanned:82908864 all_unreclaimable? yes
[ 1055.200104] lowmem_reserve[]: 0 0 0
[ 1055.203616] DMA: 109*64kB (UR) 53*128kB (R) 8*256kB (R) 0*512kB 
0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 
0*65536kB = 52672kB
[ 1055.216957] Normal: 182*64kB (MR) 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 11648kB
[ 1055.229048] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=524288kB
[ 1055.237614] 43737 total pagecache pages
[ 1055.241438] 25743 pages in swap cache
[ 1055.245081] Swap cache stats: add 27980, delete 2237, find 2297/2303
[ 1055.251407] Free swap  = 6598528kB
[ 1055.254789] Total swap = 8388544kB
[ 1055.258176] 262112 pages RAM
[ 1055.261040] 0 pages HighMem/MovableOnly
[ 1055.264855] 18446744073709544361 pages reserved
[ 1055.269366] 8192 pages cma reserved
[ 1055.272835] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[ 1055.280640] [  481]     0   481      233       89       3       39 
           0 systemd-journal
[ 1055.289389] [  487]     0   487     1420       32       3       80 
           0 lvmetad
[ 1055.297440] [  512]     0   512      216       40       2       46 
       -1000 systemd-udevd
[ 1055.306017] [  598]     0   598      258       45       3       38 
       -1000 auditd
[ 1055.313989] [  620]     0   620     6825      213       3      114 
           0 NetworkManager
[ 1055.322650] [  623]     0   623     2028       83       3      100 
           0 abrtd
[ 1055.330534] [  624]     0   624     2019       78       3       92 
           0 abrt-watch-log
[ 1055.339195] [  628]    70   628       87       38       4       34 
           0 avahi-daemon
[ 1055.347677] [  629]   998   629       40       13       2        0 
           0 lsmd
[ 1055.355474] [  631]    70   631       87        0       4       32 
           0 avahi-daemon
[ 1055.363963] [  641]     0   641     2687       48       3       77 
           0 rsyslogd
[ 1055.372106] [  642]     0   642       86       42       3        9 
           0 irqbalance
[ 1055.380423] [  681]     0   643     6821      210       5      236 
           0 tuned
[ 1055.388306] [  647]     0   647      109       44       2       31 
           0 smartd
[ 1055.396270] [  651]   997   651       83       45       2       18 
           0 chronyd
[ 1055.404326] [  652]     0   652       99       38       3       36 
           0 systemd-logind
[ 1055.412987] [  653]    81   653      222       35       2       37 
        -900 dbus-daemon
[ 1055.421389] [  667]     0   667       79       27       3       29 
           0 atd
[ 1055.429100] [  675]     0   675     1846       68       4       86 
           0 login
[ 1055.436978] [  676]     0   676     1717       23       5       10 
           0 agetty
[ 1055.444948] [  710]     0   710     1761       47       3       36 
           0 bash
[ 1055.452752] [  727]     0   727      240       84       2       74 
       -1000 sshd
[ 1055.460553] [  733]     0   733     1739       34       3        9 
           0 rhsmcertd
[ 1055.468784] [  741]   999   741     7276      118       4      122 
           0 polkitd
[ 1055.476834] [  747]     0   747      502      102       3      281 
           0 dhclient
[ 1055.484977] [ 1323]     0  1323      334       69       3       69 
           0 master
[ 1055.492947] [ 1325]    89  1325      337       82       2       78 
           0 qmgr
[ 1055.500746] [ 1328]     0  1328      358      130       3      111 
           0 sshd
[ 1055.508544] [ 1331]     0  1331     1762       48       5       39 
           0 bash
[ 1055.516335] [ 1373]    89  1373      336       89       2       69 
           0 pickup
[ 1055.524305] [ 2944]     0  2944     1734       50       4        3 
           0 make
[ 1055.532102] [31425]     0 31425     1760       79       3        0 
           0 make
[ 1055.539900] [32092]     0 32092     1736       51       4        0 
           0 sh
[ 1055.547518] [32103]     0 32103     1736       51       4        0 
           0 sh
[ 1055.555142] [32108]     0 32108     1737       42       4        0 
           0 gcc
[ 1055.562852] [32110]     0 32110     1736       52       4        0 
           0 sh
[ 1055.570477] [32111]     0 32111     2479      373       4        0 
           0 cc1
[ 1055.578187] [32118]     0 32118     1736       52       4        0 
           0 sh
[ 1055.585805] [32120]     0 32120     1737       42       4        0 
           0 gcc
[ 1055.593515] [32123]     0 32123     1736       51       4        0 
           0 sh
[ 1055.601137] [32125]     0 32125     2479      373       4        0 
           0 cc1
[ 1055.608848] [32127]     0 32127     1737       43       4        0 
           0 gcc
[ 1055.616552] [32132]     0 32132     1736       52       4        0 
           0 sh
[ 1055.624177] [32134]     0 32134     1737       42       5        0 
           0 gcc
[ 1055.631890] [32135]     0 32135     2472      304       4        0 
           0 cc1
[ 1055.639601] [32136]     0 32136     2474      314       4        0 
           0 cc1
[ 1055.647305] [32140]     0 32140     1736       52       3        0 
           0 sh
[ 1055.654930] [32141]     0 32141     1737       42       4        0 
           0 gcc
[ 1055.662640] [32142]     0 32142     1736       51       3        0 
           0 sh
[ 1055.670264] [32146]     0 32146     1737       42       4        0 
           0 gcc
[ 1055.677968] [32150]     0 32150     1736       52       4        0 
           0 sh
[ 1055.685591] [32151]     0 32151     2474      314       3        0 
           0 cc1
[ 1055.693302] [32154]     0 32154     1737       42       4        0 
           0 gcc
[ 1055.701012] [32157]     0 32157     1736       51       3        0 
           0 sh
[ 1055.708636] [32158]     0 32158     2479      373       4        0 
           0 cc1
[ 1055.716340] [32164]     0 32164     1737       43       5        0 
           0 gcc
[ 1055.724051] [32165]     0 32165     1736       52       3        0 
           0 sh
[ 1055.731673] [32166]     0 32166     1737       42       4        0 
           0 gcc
[ 1055.739383] [32170]     0 32170     2466      232       3        0 
           0 cc1
[ 1055.747087] [32173]     0 32173     2470      232       4        0 
           0 cc1
[ 1055.754799] [32176]     0 32176     1736       52       4        0 
           0 sh
[ 1055.762424] [32178]     0 32178     1737       42       4        0 
           0 gcc
[ 1055.770134] [32180]     0 32180     2474      313       3        0 
           0 cc1
[ 1055.777839] [32182]     0 32182     1736       51       3        0 
           0 sh
[ 1055.785462] [32184]     0 32184     1737       42       3        0 
           0 gcc
[ 1055.793172] [32185]     0 32185     1736       52       5        0 
           0 sh
[ 1055.800795] [32186]     0 32186     1737       42       4        0 
           0 gcc
[ 1055.808505] [32188]     0 32188     2464      199       4        0 
           0 cc1
[ 1055.816209] [32190]     0 32190     1736       51       4        0 
           0 sh
[ 1055.823833] [32194]     0 32194     2466      232       4        0 
           0 cc1
[ 1055.831544] [32195]     0 32195     1737       43       4        0 
           0 gcc
[ 1055.839254] [32197]     0 32197     1736       13       4        0 
           0 sh
[ 1055.846872] [32199]     0 32199     2464      199       4        0 
           0 cc1
[ 1055.854582] [32200]     0 32200       70       34       3        0 
           0 mv
[ 1055.862207] [32201]     0 32201     1760       79       3        0 
           0 make
[ 1055.870002] [32202]     0 32202     1909      157       4        0 
           0 as
[ 1055.877620] Out of memory: Kill process 681 (tuned) score 1 or 
sacrifice child
[ 1055.884812] Killed process 681 (tuned) total-vm:436544kB, 
anon-rss:3200kB, file-rss:10240kB

Message from syslogd@localhost at Jan  8 07:46:37 ...
  kernel:Call trace:

Message from syslogd@localhost at Jan  8 07:46:37 ...
  kernel:Call trace:
[ 1057.551522] cc1 invoked oom-killer: gfp_mask=0x200da, order=0, 
oom_score_adj=0
[ 1057.558741] cc1 cpuset=/ mems_allowed=0
[ 1057.562589] CPU: 3 PID: 32236 Comm: cc1 Not tainted 3.19.0-rc3+ #2
[ 1057.568761] Hardware name: APM X-Gene Mustang board (DT)
[ 1057.574049] Call trace:
[ 1057.576494] [<fffffe0000096954>] dump_backtrace+0x0/0x16c
[ 1057.581888] [<fffffe0000096ad0>] show_stack+0x10/0x1c
[ 1057.586927] [<fffffe000062911c>] dump_stack+0x74/0x98
[ 1057.591973] [<fffffe0000626550>] dump_header.isra.11+0x98/0x1d0
[ 1057.597869] [<fffffe000017c4e0>] oom_kill_process+0x3ac/0x408
[ 1057.603597] [<fffffe000017c9d4>] out_of_memory+0x2a4/0x2d4
[ 1057.609070] [<fffffe0000180b78>] __alloc_pages_nodemask+0x808/0x8d8
[ 1057.615310] [<fffffe00001a1fc8>] do_wp_page+0x444/0x904
[ 1057.620519] [<fffffe00001a3fc8>] handle_mm_fault+0x4c4/0xd1c
[ 1057.626152] [<fffffe00000a01c8>] do_page_fault+0x214/0x338
[ 1057.631625] [<fffffe000009022c>] do_mem_abort+0x38/0x9c
[ 1057.636825] Exception stack(0xfffffe00419e3e30 to 0xfffffe00419e3f50)
[ 1057.643241] 3e20:                                     00000200 
00000000 1ffe5c60 00000000
[ 1057.651385] 3e40: ffffffff ffffffff 006f0560 00000000 00b11000 
fffffe00 000f7c84 fffffe00
[ 1057.659528] 3e60: 419e3ea0 fffffe00 000903b4 fffffe00 419e3ed0 
fffffe00 0002000c fffffc00
[ 1057.667664] 3e80: 00b686b8 fffffe00 af976004 000003ff 419e3eb0 
fffffe00 000964e8 fffffe00
[ 1057.675805] 3ea0: 00000208 00000000 00092f90 fffffe00 e1ae3770 
000003ff 0009308c fffffe00
[ 1057.683947] 3ec0: 00000200 00000000 00093094 fffffe00 20006cf0 
00000000 20006ce0 00000000
[ 1057.692092] 3ee0: a727db78 000003ff a727db77 000003ff fffffffe 
00000000 00000000 00000000
[ 1057.700234] 3f00: 00007fff 00000000 00004000 00000000 4c9abfcd 
00000000 00003fcd 00000000
[ 1057.708374] 3f20: 00003fcd 00000000 0000bf97 00000000 00007ffe 
00000000 00000000 00000000
[ 1057.716510] 3f40: 1fffffff 00000000 0000ddd0 00000000
[ 1057.721539] Mem-Info:
[ 1057.723800] DMA per-cpu:
[ 1057.726319] CPU    0: hi:    6, btch:   1 usd:   0
[ 1057.731089] CPU    1: hi:    6, btch:   1 usd:   0
[ 1057.735855] CPU    2: hi:    6, btch:   1 usd:   0
[ 1057.740625] CPU    3: hi:    6, btch:   1 usd:   0
[ 1057.745389] CPU    4: hi:    6, btch:   1 usd:   0
[ 1057.750159] CPU    5: hi:    6, btch:   1 usd:   0
[ 1057.754924] CPU    6: hi:    6, btch:   1 usd:   0
[ 1057.759693] CPU    7: hi:    6, btch:   1 usd:   0
[ 1057.764458] Normal per-cpu:
[ 1057.767235] CPU    0: hi:    6, btch:   1 usd:   0
[ 1057.772004] CPU    1: hi:    6, btch:   1 usd:   0
[ 1057.776769] CPU    2: hi:    6, btch:   1 usd:   0
[ 1057.781538] CPU    3: hi:    6, btch:   1 usd:   0
[ 1057.786302] CPU    4: hi:    6, btch:   1 usd:   0
[ 1057.791072] CPU    5: hi:    6, btch:   1 usd:   0
[ 1057.795837] CPU    6: hi:    6, btch:   1 usd:   0
[ 1057.800606] CPU    7: hi:    6, btch:   1 usd:   0
[ 1057.805375] active_anon:207677 inactive_anon:25723 isolated_anon:0
[ 1057.805375]  active_file:1246 inactive_file:21239 isolated_file:0
[ 1057.805375]  unevictable:0 dirty:0 writeback:0 unstable:0
[ 1057.805375]  free:850 slab_reclaimable:1045 slab_unreclaimable:1748
[ 1057.805375]  mapped:667 shmem:63 pagetables:232 bounce:0
[ 1057.805375]  free_cma:6
[ 1057.836860] DMA free:48576kB min:4032kB low:4992kB high:6016kB 
active_anon:3035200kB inactive_anon:612608kB active_file:17856kB 
inactive_file:323136kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:11520kB shmem:2048kB 
slab_reclaimable:26304kB slab_unreclaimable:36096kB kernel_stack:352kB 
pagetables:5120kB unstable:0kB bounce:0kB free_cma:384kB 
writeback_tmp:0kB pages_scanned:25701184 all_unreclaimable? yes
[ 1057.880173] lowmem_reserve[]: 0 765 765
[ 1057.884043] Normal free:5824kB min:12224kB low:15232kB high:18304kB 
active_anon:10256128kB inactive_anon:1033664kB active_file:61888kB 
inactive_file:1036160kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:12582912kB managed:12538176kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:31168kB shmem:1984kB 
slab_reclaimable:40576kB slab_unreclaimable:75776kB kernel_stack:3072kB 
pagetables:9728kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:80137088 all_unreclaimable? yes
[ 1057.928132] lowmem_reserve[]: 0 0 0
[ 1057.931662] DMA: 55*64kB (UMRC) 49*128kB (R) 8*256kB (R) 0*512kB 
0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 
0*65536kB = 48704kB
[ 1057.945093] Normal: 62*64kB (MR) 9*128kB (R) 4*256kB (R) 0*512kB 
0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 6144kB
[ 1057.957726] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=524288kB
[ 1057.966305] 43758 total pagecache pages
[ 1057.970133] 25806 pages in swap cache
[ 1057.973778] Swap cache stats: add 28140, delete 2334, find 2447/2608
[ 1057.980108] Free swap  = 6619264kB
[ 1057.983491] Total swap = 8388544kB
[ 1057.986874] 262112 pages RAM
[ 1057.989750] 0 pages HighMem/MovableOnly
[ 1057.993567] 18446744073709544361 pages reserved
[ 1057.998072] 8192 pages cma reserved
[ 1058.001550] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[ 1058.009370] [  481]     0   481      233      106       3       26 
           0 systemd-journal
[ 1058.018115] [  487]     0   487     1420       32       3       80 
           0 lvmetad
[ 1058.026179] [  512]     0   512      216       40       2       46 
       -1000 systemd-udevd
[ 1058.034756] [  598]     0   598      258       45       3       38 
       -1000 auditd
[ 1058.042728] [  620]     0   620     6825      224       3      106 
           0 NetworkManager
[ 1058.051400] [  623]     0   623     2028       83       3      100 
           0 abrtd
[ 1058.059289] [  624]     0   624     2019       78       3       92 
           0 abrt-watch-log
[ 1058.067944] [  628]    70   628       87       38       4       34 
           0 avahi-daemon
[ 1058.076440] [  629]   998   629       40       13       2        0 
           0 lsmd
[ 1058.084238] [  631]    70   631       87        0       4       32 
           0 avahi-daemon
[ 1058.092736] [  641]     0   641     2687       82       3       56 
           0 rsyslogd
[ 1058.100881] [  642]     0   642       86       42       3        9 
           0 irqbalance
[ 1058.109202] [  647]     0   647      109       44       2       31 
           0 smartd
[ 1058.117169] [  651]   997   651       83       45       2       18 
           0 chronyd
[ 1058.125230] [  652]     0   652       99       38       3       36 
           0 systemd-logind
[ 1058.133900] [  653]    81   653      222       53       2       21 
        -900 dbus-daemon
[ 1058.142303] [  667]     0   667       79       27       3       29 
           0 atd
[ 1058.150020] [  675]     0   675     1846       68       4       86 
           0 login
[ 1058.157900] [  676]     0   676     1717       23       5       10 
           0 agetty
[ 1058.165874] [  710]     0   710     1761       47       3       36 
           0 bash
[ 1058.173679] [  727]     0   727      240       84       2       74 
       -1000 sshd
[ 1058.181476] [  733]     0   733     1739       34       3        9 
           0 rhsmcertd
[ 1058.189712] [  741]   999   741     7276      132       4      105 
           0 polkitd
[ 1058.197764] [  747]     0   747      502      102       3      281 
           0 dhclient
[ 1058.205912] [ 1323]     0  1323      334       69       3       69 
           0 master
[ 1058.213891] [ 1325]    89  1325      337       82       2       78 
           0 qmgr
[ 1058.221691] [ 1328]     0  1328      358      130       3      111 
           0 sshd
[ 1058.229495] [ 1331]     0  1331     1762       48       5       39 
           0 bash
[ 1058.237289] [ 1373]    89  1373      336       89       2       69 
           0 pickup
[ 1058.245264] [ 2944]     0  2944     1734       50       4        3 
           0 make
[ 1058.253069] [31425]     0 31425     1760       79       3        0 
           0 make
[ 1058.260869] [32190]     0 32190     1736       51       4        0 
           0 sh
[ 1058.268493] [32195]     0 32195     1737       43       4        0 
           0 gcc
[ 1058.276199] [32199]     0 32199     2479      382       4        0 
           0 cc1
[ 1058.283915] [32224]     0 32224     1736       51       4        0 
           0 sh
[ 1058.291548] [32230]     0 32230     1737       42       4        0 
           0 gcc
[ 1058.299264] [32232]     0 32232     1736       51       3        0 
           0 sh
[ 1058.306883] [32236]     0 32236     2479      314       4        0 
           0 cc1
[ 1058.314594] [32237]     0 32237     1736       52       5        0 
           0 sh
[ 1058.322217] [32239]     0 32239     1737       42       5        0 
           0 gcc
[ 1058.329934] [32241]     0 32241     1737       43       5        0 
           0 gcc
[ 1058.337642] [32245]     0 32245     1736       51       4        0 
           0 sh
[ 1058.345271] [32246]     0 32246     2474      313       4        0 
           0 cc1
[ 1058.352992] [32248]     0 32248     1737       42       4        0 
           0 gcc
[ 1058.360704] [32249]     0 32249     2479      373       3        0 
           0 cc1
[ 1058.368414] [32250]     0 32250     1736       52       3        0 
           0 sh
[ 1058.376032] [32252]     0 32252     1737       43       4        0 
           0 gcc
[ 1058.383750] [32253]     0 32253     1736       51       5        0 
           0 sh
[ 1058.391376] [32254]     0 32254     2472      303       4        0 
           0 cc1
[ 1058.399087] [32257]     0 32257     2473      296       3        0 
           0 cc1
[ 1058.406791] [32258]     0 32258     1737       42       4        0 
           0 gcc
[ 1058.414501] [32260]     0 32260     1736       51       3        0 
           0 sh
[ 1058.422132] [32261]     0 32261     1737       42       3        0 
           0 gcc
[ 1058.429844] [32264]     0 32264     2470      232       3        0 
           0 cc1
[ 1058.437549] [32268]     0 32268     2479      373       3        0 
           0 cc1
[ 1058.445259] [32273]     0 32273     1736       51       5        0 
           0 sh
[ 1058.452890] [32276]     0 32276     1737       43       4        0 
           0 gcc
[ 1058.460602] [32278]     0 32278     1736       51       4        0 
           0 sh
[ 1058.468220] [32280]     0 32280     1737       43       4        0 
           0 gcc
[ 1058.475930] [32282]     0 32282     2470      296       4        0 
           0 cc1
[ 1058.483652] [32286]     0 32286     1736       52       4        0 
           0 sh
[ 1058.491278] [32287]     0 32287     2474      313       5        0 
           0 cc1
[ 1058.498992] [32291]     0 32291     1737       42       3        0 
           0 gcc
[ 1058.506691] [32294]     0 32294     2470      233       4        0 
           0 cc1
[ 1058.514405] [32299]     0 32299     1736       51       3        0 
           0 sh
[ 1058.522036] [32300]     0 32300     1737       42       3        0 
           0 gcc
[ 1058.529747] [32301]     0 32301     1737       42       3        0 
           0 gcc
[ 1058.537452] [32302]     0 32302     1760       79       3        0 
           0 make
[ 1058.545255] Out of memory: Kill process 747 (dhclient) score 0 or 
sacrifice child
[ 1058.552708] Killed process 747 (dhclient) total-vm:32128kB, 
anon-rss:192kB, file-rss:6336kB
[ 1059.379317] NetworkManager invoked oom-killer: gfp_mask=0xd0, 
order=0, oom_score_adj=0
[ 1059.387206] NetworkManager cpuset=/ mems_allowed=0
[ 1059.392022] CPU: 6 PID: 620 Comm: NetworkManager Not tainted 
3.19.0-rc3+ #2
[ 1059.398964] Hardware name: APM X-Gene Mustang board (DT)
[ 1059.404251] Call trace:
[ 1059.406694] [<fffffe0000096954>] dump_backtrace+0x0/0x16c
[ 1059.412088] [<fffffe0000096ad0>] show_stack+0x10/0x1c
[ 1059.417121] [<fffffe000062911c>] dump_stack+0x74/0x98
[ 1059.422162] [<fffffe0000626550>] dump_header.isra.11+0x98/0x1d0
[ 1059.428057] [<fffffe000017c4e0>] oom_kill_process+0x3ac/0x408
[ 1059.433788] [<fffffe000017c9d4>] out_of_memory+0x2a4/0x2d4
[ 1059.439264] [<fffffe0000180b78>] __alloc_pages_nodemask+0x808/0x8d8
[ 1059.445504] [<fffffe0000180c5c>] __get_free_pages+0x14/0x48
[ 1059.451063] [<fffffe00001e8454>] __pollwait+0x4c/0xf4
[ 1059.456091] [<fffffe00004ff568>] datagram_poll+0x24/0x11c
[ 1059.461479] [<fffffe0000535a70>] netlink_poll+0xac/0x180
[ 1059.466767] [<fffffe00004ef3dc>] sock_poll+0xf8/0x110
[ 1059.471800] [<fffffe00001e97b0>] do_sys_poll+0x220/0x484
[ 1059.477085] [<fffffe00001e9d24>] SyS_ppoll+0x1c4/0x1dc
[ 1059.482213] Mem-Info:
[ 1059.484476] DMA per-cpu:
[ 1059.486996] CPU    0: hi:    6, btch:   1 usd:   0
[ 1059.491767] CPU    1: hi:    6, btch:   1 usd:   0
[ 1059.496532] CPU    2: hi:    6, btch:   1 usd:   0
[ 1059.501301] CPU    3: hi:    6, btch:   1 usd:   0
[ 1059.506066] CPU    4: hi:    6, btch:   1 usd:   0
[ 1059.510842] CPU    5: hi:    6, btch:   1 usd:   0
[ 1059.515609] CPU    6: hi:    6, btch:   1 usd:   0
[ 1059.520383] CPU    7: hi:    6, btch:   1 usd:   0
[ 1059.525149] Normal per-cpu:
[ 1059.527927] CPU    0: hi:    6, btch:   1 usd:   0
[ 1059.532706] CPU    1: hi:    6, btch:   1 usd:   0
[ 1059.537471] CPU    2: hi:    6, btch:   1 usd:   0
[ 1059.542242] CPU    3: hi:    6, btch:   1 usd:   0
[ 1059.547006] CPU    4: hi:    6, btch:   1 usd:   0
[ 1059.551783] CPU    5: hi:    6, btch:   1 usd:   0
[ 1059.556549] CPU    6: hi:    6, btch:   1 usd:   0
[ 1059.561321] CPU    7: hi:    6, btch:   1 usd:   1
[ 1059.566092] active_anon:207642 inactive_anon:25756 isolated_anon:0
[ 1059.566092]  active_file:1244 inactive_file:21227 isolated_file:0
[ 1059.566092]  unevictable:0 dirty:0 writeback:0 unstable:0
[ 1059.566092]  free:864 slab_reclaimable:1045 slab_unreclaimable:1748
[ 1059.566092]  mapped:642 shmem:63 pagetables:229 bounce:0
[ 1059.566092]  free_cma:6
[ 1059.597581] DMA free:48768kB min:4032kB low:4992kB high:6016kB 
active_anon:3035200kB inactive_anon:612608kB active_file:17792kB 
inactive_file:322944kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:11520kB shmem:2048kB 
slab_reclaimable:26304kB slab_unreclaimable:36096kB kernel_stack:336kB 
pagetables:5056kB unstable:0kB bounce:0kB free_cma:384kB 
writeback_tmp:0kB pages_scanned:24814080 all_unreclaimable? yes
[ 1059.640895] lowmem_reserve[]: 0 765 765
[ 1059.644766] Normal free:6528kB min:12224kB low:15232kB high:18304kB 
active_anon:10253888kB inactive_anon:1035776kB active_file:61824kB 
inactive_file:1035584kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:12582912kB managed:12538176kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:29568kB shmem:1984kB 
slab_reclaimable:40576kB slab_unreclaimable:75776kB kernel_stack:2992kB 
pagetables:9600kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:79671936 all_unreclaimable? yes
[ 1059.688856] lowmem_reserve[]: 0 0 0
[ 1059.692375] DMA: 57*64kB (UMRC) 49*128kB (R) 8*256kB (R) 0*512kB 
0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 
0*65536kB = 48832kB
[ 1059.705808] Normal: 68*64kB (MR) 9*128kB (R) 4*256kB (R) 0*512kB 
0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 6528kB
[ 1059.718443] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=524288kB
[ 1059.727021] 43784 total pagecache pages
[ 1059.730850] 25838 pages in swap cache
[ 1059.734493] Swap cache stats: add 28173, delete 2335, find 2447/2609
[ 1059.740820] Free swap  = 6635136kB
[ 1059.744204] Total swap = 8388544kB
[ 1059.747587] 262112 pages RAM
[ 1059.750463] 0 pages HighMem/MovableOnly
[ 1059.754280] 18446744073709544361 pages reserved
[ 1059.758794] 8192 pages cma reserved
[ 1059.762265] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[ 1059.770084] [  481]     0   481      233      106       3       26 
           0 systemd-journal
[ 1059.778838] [  487]     0   487     1420       32       3       80 
           0 lvmetad
[ 1059.786890] [  512]     0   512      216       40       2       46 
       -1000 systemd-udevd
[ 1059.795474] [  598]     0   598      258       45       3       38 
       -1000 auditd
[ 1059.803446] [  620]     0   620     6825      224       3      106 
           0 NetworkManager
[ 1059.812116] [  623]     0   623     2028       83       3      100 
           0 abrtd
[ 1059.820004] [  624]     0   624     2019       78       3       92 
           0 abrt-watch-log
[ 1059.828667] [  628]    70   628       87       38       4       34 
           0 avahi-daemon
[ 1059.837151] [  629]   998   629       40       13       2        0 
           0 lsmd
[ 1059.844954] [  631]    70   631       87        0       4       32 
           0 avahi-daemon
[ 1059.853450] [  641]     0   641     2687       82       3       56 
           0 rsyslogd
[ 1059.861594] [  642]     0   642       86       42       3        9 
           0 irqbalance
[ 1059.869918] [  647]     0   647      109       44       2       31 
           0 smartd
[ 1059.877885] [  651]   997   651       83       45       2       18 
           0 chronyd
[ 1059.885945] [  652]     0   652       99       38       3       36 
           0 systemd-logind
[ 1059.894614] [  653]    81   653      222       53       2       21 
        -900 dbus-daemon
[ 1059.903021] [  667]     0   667       79       27       3       29 
           0 atd
[ 1059.910740] [  675]     0   675     1846       68       4       86 
           0 login
[ 1059.918629] [  676]     0   676     1717       23       5       10 
           0 agetty
[ 1059.926594] [  710]     0   710     1761       47       3       36 
           0 bash
[ 1059.934392] [  727]     0   727      240       84       2       74 
       -1000 sshd
[ 1059.942197] [  733]     0   733     1739       34       3        9 
           0 rhsmcertd
[ 1059.950427] [  741]   999   741     7276      132       4      105 
           0 polkitd
[ 1059.958478] [ 1323]     0  1323      334       69       3       69 
           0 master
[ 1059.966457] [ 1325]    89  1325      337       82       2       78 
           0 qmgr
[ 1059.974256] [ 1328]     0  1328      358      130       3      111 
           0 sshd
[ 1059.982061] [ 1331]     0  1331     1762       48       5       39 
           0 bash
[ 1059.989859] [ 1373]    89  1373      336       89       2       69 
           0 pickup
[ 1059.997824] [ 2944]     0  2944     1734       50       4        3 
           0 make
[ 1060.005622] [31425]     0 31425     1760       79       3        0 
           0 make
[ 1060.013426] [32190]     0 32190     1736       51       4        0 
           0 sh
[ 1060.021052] [32195]     0 32195     1737       43       4        0 
           0 gcc
[ 1060.028768] [32199]     0 32199     2479      382       4        0 
           0 cc1
[ 1060.036475] [32224]     0 32224     1736       51       4        0 
           0 sh
[ 1060.044104] [32230]     0 32230     1737       42       4        0 
           0 gcc
[ 1060.051824] [32232]     0 32232     1736       51       3        0 
           0 sh
[ 1060.059450] [32236]     0 32236     2479      314       4        0 
           0 cc1
[ 1060.067155] [32237]     0 32237     1736       52       5        0 
           0 sh
[ 1060.074786] [32239]     0 32239     1737       42       5        0 
           0 gcc
[ 1060.082496] [32241]     0 32241     1737       43       5        0 
           0 gcc
[ 1060.090215] [32245]     0 32245     1736       51       4        0 
           0 sh
[ 1060.097836] [32246]     0 32246     2474      313       4        0 
           0 cc1
[ 1060.105550] [32248]     0 32248     1737       42       4        0 
           0 gcc
[ 1060.113274] [32249]     0 32249     2479      373       3        0 
           0 cc1
[ 1060.120986] [32250]     0 32250     1736       52       3        0 
           0 sh
[ 1060.128610] [32252]     0 32252     1737       43       4        0 
           0 gcc
[ 1060.136316] [32253]     0 32253     1736       51       5        0 
           0 sh
[ 1060.143945] [32254]     0 32254     2472      303       4        0 
           0 cc1
[ 1060.151664] [32257]     0 32257     2473      296       3        0 
           0 cc1
[ 1060.159383] [32258]     0 32258     1737       42       4        0 
           0 gcc
[ 1060.167088] [32260]     0 32260     1736       51       3        0 
           0 sh
[ 1060.174720] [32261]     0 32261     1737       42       3        0 
           0 gcc
[ 1060.182432] [32264]     0 32264     2470      232       3        0 
           0 cc1
[ 1060.190149] [32268]     0 32268     2479      373       3        0 
           0 cc1
[ 1060.197856] [32273]     0 32273     1736       51       5        0 
           0 sh
[ 1060.205484] [32276]     0 32276     1737       43       4        0 
           0 gcc
[ 1060.213202] [32278]     0 32278     1736       51       4        0 
           0 sh
[ 1060.220827] [32280]     0 32280     1737       43       4        0 
           0 gcc
[ 1060.228532] [32282]     0 32282     2470      296       4        0 
           0 cc1
[ 1060.236248] [32286]     0 32286     1736       52       4        0 
           0 sh
[ 1060.243874] [32287]     0 32287     2474      313       5        0 
           0 cc1
[ 1060.251591] [32291]     0 32291     1737       42       3        0 
           0 gcc
[ 1060.259303] [32294]     0 32294     2470      233       4        0 
           0 cc1
[ 1060.267008] [32299]     0 32299     1736       51       3        0 
           0 sh
[ 1060.274638] [32300]     0 32300     1737       42       3        0 
           0 gcc
[ 1060.282349] [32301]     0 32301     1737       42       3        0 
           0 gcc
[ 1060.290072] [32302]     0 32302     1760       79       3        0 
           0 make
[ 1060.297866] Out of memory: Kill process 32199 (cc1) score 0 or 
sacrifice child
[ 1060.305063] Killed process 32199 (cc1) total-vm:158656kB, 
anon-rss:14912kB, file-rss:9536kB

Message from syslogd@localhost at Jan  8 07:46:41 ...
  kernel:Call trace:

Message from syslogd@localhost at Jan  8 07:46:41 ...
  kernel:Call trace:
[ 1061.074807] cc1 invoked oom-killer: gfp_mask=0x200da, order=0, 
oom_score_adj=0
[ 1061.082033] cc1 cpuset=/ mems_allowed=0
[ 1061.085881] CPU: 3 PID: 32257 Comm: cc1 Not tainted 3.19.0-rc3+ #2
[ 1061.092051] Hardware name: APM X-Gene Mustang board (DT)
[ 1061.097339] Call trace:
[ 1061.099794] [<fffffe0000096954>] dump_backtrace+0x0/0x16c
[ 1061.105169] [<fffffe0000096ad0>] show_stack+0x10/0x1c
[ 1061.110205] [<fffffe000062911c>] dump_stack+0x74/0x98
[ 1061.115233] [<fffffe0000626550>] dump_header.isra.11+0x98/0x1d0
[ 1061.121131] [<fffffe000017c4e0>] oom_kill_process+0x3ac/0x408
[ 1061.126848] [<fffffe000017c9d4>] out_of_memory+0x2a4/0x2d4
[ 1061.132314] [<fffffe0000180b78>] __alloc_pages_nodemask+0x808/0x8d8
[ 1061.138550] [<fffffe00001a443c>] handle_mm_fault+0x938/0xd1c
[ 1061.144188] [<fffffe00000a01c8>] do_page_fault+0x214/0x338
[ 1061.149652] [<fffffe000009022c>] do_mem_abort+0x38/0x9c
[ 1061.154849] Exception stack(0xfffffe011be2fe30 to 0xfffffe011be2ff50)
[ 1061.161264] fe20:                                     00000200 
00000000 00f886a8 00000000
[ 1061.169407] fe40: ffffffff ffffffff 969b4620 000003ff 0000011a 
00000000 00000015 00000000
[ 1061.177543] fe60: 1be2fea0 fffffe01 00000000 00000000 1be2fe80 
fffffe01 000ce950 fffffe00
[ 1061.185685] fe80: 1be2feb0 fffffe01 00096520 fffffe00 00000204 
00000000 00000d7e 00000000
[ 1061.193826] fea0: ffffffff ffffffff 969fc628 000003ff ed276070 
000003ff 0009308c fffffe00
[ 1061.201968] fec0: 00000200 00000000 000931cc fffffe00 8e7c0000 
000003ff 00000000 00000000
[ 1061.210112] fee0: 00000248 00000000 8e7c0000 000003ff 00000000 
00000000 8e7c0000 000003ff
[ 1061.218248] ff00: 00000009 00000000 00000009 00000000 00fe8000 
00000000 000003a8 00000000
[ 1061.226390] ff20: 006528e0 00000000 0000008e 00000000 00000006 
00000000 00000018 00000000
[ 1061.234531] ff40: 00000008 00000000 00000000 00000000
[ 1061.239560] Mem-Info:
[ 1061.241820] DMA per-cpu:
[ 1061.244339] CPU    0: hi:    6, btch:   1 usd:   0
[ 1061.249110] CPU    1: hi:    6, btch:   1 usd:   0
[ 1061.253875] CPU    2: hi:    6, btch:   1 usd:   0
[ 1061.258644] CPU    3: hi:    6, btch:   1 usd:   0
[ 1061.263409] CPU    4: hi:    6, btch:   1 usd:   0
[ 1061.268174] CPU    5: hi:    6, btch:   1 usd:   0
[ 1061.272944] CPU    6: hi:    6, btch:   1 usd:   0
[ 1061.277709] CPU    7: hi:    6, btch:   1 usd:   0
[ 1061.282479] Normal per-cpu:
[ 1061.285257] CPU    0: hi:    6, btch:   1 usd:   0
[ 1061.290027] CPU    1: hi:    6, btch:   1 usd:   0
[ 1061.294792] CPU    2: hi:    6, btch:   1 usd:   0
[ 1061.299562] CPU    3: hi:    6, btch:   1 usd:   0
[ 1061.304327] CPU    4: hi:    6, btch:   1 usd:   0
[ 1061.309096] CPU    5: hi:    6, btch:   1 usd:   0
[ 1061.313861] CPU    6: hi:    6, btch:   1 usd:   0
[ 1061.318625] CPU    7: hi:    6, btch:   1 usd:   0
[ 1061.323400] active_anon:207507 inactive_anon:25760 isolated_anon:0
[ 1061.323400]  active_file:1223 inactive_file:21249 isolated_file:0
[ 1061.323400]  unevictable:0 dirty:0 writeback:0 unstable:0
[ 1061.323400]  free:1016 slab_reclaimable:1044 slab_unreclaimable:1748
[ 1061.323400]  mapped:652 shmem:65 pagetables:229 bounce:0
[ 1061.323400]  free_cma:1
[ 1061.354973] DMA free:52992kB min:4032kB low:4992kB high:6016kB 
active_anon:3030912kB inactive_anon:612608kB active_file:17920kB 
inactive_file:323328kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:11648kB shmem:2112kB 
slab_reclaimable:26240kB slab_unreclaimable:36096kB kernel_stack:336kB 
pagetables:5056kB unstable:0kB bounce:0kB free_cma:64kB 
writeback_tmp:0kB pages_scanned:24781760 all_unreclaimable? yes
[ 1061.398197] lowmem_reserve[]: 0 765 765
[ 1061.402072] Normal free:12032kB min:12224kB low:15232kB high:18304kB 
active_anon:10249536kB inactive_anon:1036032kB active_file:60352kB 
inactive_file:1036608kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:12582912kB managed:12538176kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:30080kB shmem:2048kB 
slab_reclaimable:40576kB slab_unreclaimable:75776kB kernel_stack:2992kB 
pagetables:9600kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:76284480 all_unreclaimable? yes
[ 1061.446244] lowmem_reserve[]: 0 0 0
[ 1061.449762] DMA: 122*64kB (UEMR) 49*128kB (R) 8*256kB (R) 0*512kB 
0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 
0*65536kB = 52992kB
[ 1061.463271] Normal: 134*64kB (MR) 14*128kB (MR) 5*256kB (R) 1*512kB 
(M) 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 
12160kB
[ 1061.476597] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=524288kB
[ 1061.485172] 43768 total pagecache pages
[ 1061.488993] 25841 pages in swap cache
[ 1061.492636] Swap cache stats: add 28188, delete 2347, find 2460/2635
[ 1061.498962] Free swap  = 6635968kB
[ 1061.502345] Total swap = 8388544kB
[ 1061.505729] 262112 pages RAM
[ 1061.508592] 0 pages HighMem/MovableOnly
[ 1061.512412] 18446744073709544361 pages reserved
[ 1061.516917] 8192 pages cma reserved
[ 1061.520390] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[ 1061.528192] [  481]     0   481      234      111       3       26 
           0 systemd-journal
[ 1061.536940] [  487]     0   487     1420       32       3       80 
           0 lvmetad
[ 1061.544998] [  512]     0   512      216       40       2       46 
       -1000 systemd-udevd
[ 1061.553575] [  598]     0   598      258       45       3       38 
       -1000 auditd
[ 1061.561545] [  620]     0   620     6825      224       3      106 
           0 NetworkManager
[ 1061.570206] [  623]     0   623     2028       83       3      100 
           0 abrtd
[ 1061.578083] [  624]     0   624     2019       87       3       84 
           0 abrt-watch-log
[ 1061.586744] [  628]    70   628       87       38       4       34 
           0 avahi-daemon
[ 1061.595232] [  629]   998   629       40       13       2        0 
           0 lsmd
[ 1061.603030] [  631]    70   631       87        0       4       32 
           0 avahi-daemon
[ 1061.611520] [  641]     0   641     2687       82       3       56 
           0 rsyslogd
[ 1061.619662] [  642]     0   642       86       42       3        9 
           0 irqbalance
[ 1061.627972] [  647]     0   647      109       44       2       31 
           0 smartd
[ 1061.635942] [  651]   997   651       83       45       2       18 
           0 chronyd
[ 1061.643997] [  652]     0   652       99       38       3       36 
           0 systemd-logind
[ 1061.652658] [  653]    81   653      222       53       2       21 
        -900 dbus-daemon
[ 1061.661059] [  667]     0   667       79       27       3       29 
           0 atd
[ 1061.668769] [  675]     0   675     1846       68       4       86 
           0 login
[ 1061.676647] [  676]     0   676     1717       23       5       10 
           0 agetty
[ 1061.684616] [  710]     0   710     1761       47       3       36 
           0 bash
[ 1061.692413] [  727]     0   727      240       84       2       74 
       -1000 sshd
[ 1061.700209] [  733]     0   733     1739       34       3        9 
           0 rhsmcertd
[ 1061.708432] [  741]   999   741     7276      132       4      105 
           0 polkitd
[ 1061.716488] [ 1323]     0  1323      334       69       3       69 
           0 master
[ 1061.724457] [ 1325]    89  1325      337       82       2       78 
           0 qmgr
[ 1061.732254] [ 1328]     0  1328      358      130       3      111 
           0 sshd
[ 1061.740052] [ 1331]     0  1331     1762       48       5       39 
           0 bash
[ 1061.747843] [ 1373]    89  1373      336       89       2       69 
           0 pickup
[ 1061.755813] [ 2944]     0  2944     1734       50       4        3 
           0 make
[ 1061.763611] [31425]     0 31425     1760       79       3        0 
           0 make
[ 1061.771408] [32190]     0 32190     1736       51       4        0 
           0 sh
[ 1061.779032] [32195]     0 32195     1751       52       4        0 
           0 gcc
[ 1061.786738] [32224]     0 32224     1736       51       4        0 
           0 sh
[ 1061.794362] [32230]     0 32230     1737       42       4        0 
           0 gcc
[ 1061.802073] [32232]     0 32232     1736       51       3        0 
           0 sh
[ 1061.809696] [32236]     0 32236     2479      373       4        0 
           0 cc1
[ 1061.817401] [32237]     0 32237     1736       52       5        0 
           0 sh
[ 1061.825024] [32239]     0 32239     1737       42       5        0 
           0 gcc
[ 1061.832734] [32241]     0 32241     1737       43       5        0 
           0 gcc
[ 1061.840445] [32245]     0 32245     1736       51       4        0 
           0 sh
[ 1061.848063] [32246]     0 32246     2474      313       4        0 
           0 cc1
[ 1061.855773] [32248]     0 32248     1737       42       4        0 
           0 gcc
[ 1061.863483] [32249]     0 32249     2479      383       3        0 
           0 cc1
[ 1061.871195] [32250]     0 32250     1736       52       3        0 
           0 sh
[ 1061.878820] [32252]     0 32252     1737       43       4        0 
           0 gcc
[ 1061.886525] [32253]     0 32253     1736       51       5        0 
           0 sh
[ 1061.894148] [32254]     0 32254     2472      303       4        0 
           0 cc1
[ 1061.901858] [32257]     0 32257     2472      304       3        0 
           0 cc1
[ 1061.909570] [32258]     0 32258     1737       42       4        0 
           0 gcc
[ 1061.917274] [32260]     0 32260     1736       51       3        0 
           0 sh
[ 1061.924898] [32261]     0 32261     1737       42       3        0 
           0 gcc
[ 1061.932607] [32264]     0 32264     2470      232       3        0 
           0 cc1
[ 1061.940317] [32268]     0 32268     2479      373       3        0 
           0 cc1
[ 1061.948022] [32273]     0 32273     1736       51       5        0 
           0 sh
[ 1061.955646] [32276]     0 32276     1737       43       4        0 
           0 gcc
[ 1061.963355] [32278]     0 32278     1736       51       4        0 
           0 sh
[ 1061.970979] [32280]     0 32280     1737       43       4        0 
           0 gcc
[ 1061.978683] [32282]     0 32282     2473      296       4        0 
           0 cc1
[ 1061.986394] [32286]     0 32286     1736       52       4        0 
           0 sh
[ 1061.994017] [32287]     0 32287     2474      313       5        0 
           0 cc1
[ 1062.001729] [32291]     0 32291     1737       42       3        0 
           0 gcc
[ 1062.009440] [32294]     0 32294     2470      233       4        0 
           0 cc1
[ 1062.017144] [32299]     0 32299     1736       51       3        0 
           0 sh
[ 1062.024768] [32300]     0 32300     1737       42       3        0 
           0 gcc
[ 1062.032479] [32301]     0 32301      208       11       3        0 
           0 cc1
[ 1062.040189] [32302]     0 32302       32       11       3        0 
           0 sh
[ 1062.047807] [32303]     0 32303     1760       79       3        0 
           0 make
[ 1062.055607] Out of memory: Kill process 32249 (cc1) score 0 or 
sacrifice child
[ 1062.062801] Killed process 32249 (cc1) total-vm:158656kB, 
anon-rss:14976kB, file-rss:9536kB

Message from syslogd@localhost at Jan  8 07:46:43 ...
  kernel:Call trace:
[ 1063.003783] systemd invoked oom-killer: gfp_mask=0x200da, order=0, 
oom_score_adj=0
[ 1063.011343] systemd cpuset=/ mems_allowed=0
[ 1063.015536] CPU: 2 PID: 1 Comm: systemd Not tainted 3.19.0-rc3+ #2
[ 1063.021707] Hardware name: APM X-Gene Mustang board (DT)
[ 1063.026995] Call trace:
[ 1063.029450] [<fffffe0000096954>] dump_backtrace+0x0/0x16c
[ 1063.034829] [<fffffe0000096ad0>] show_stack+0x10/0x1c
[ 1063.039872] [<fffffe000062911c>] dump_stack+0x74/0x98
[ 1063.044901] [<fffffe0000626550>] dump_header.isra.11+0x98/0x1d0
[ 1063.050808] [<fffffe000017c4e0>] oom_kill_process+0x3ac/0x408
[ 1063.056531] [<fffffe000017c9d4>] out_of_memory+0x2a4/0x2d4
[ 1063.062007] [<fffffe0000180b78>] __alloc_pages_nodemask+0x808/0x8d8
[ 1063.068246] [<fffffe00001a1c54>] do_wp_page+0xd0/0x904
[ 1063.073374] [<fffffe00001a3fc8>] handle_mm_fault+0x4c4/0xd1c
[ 1063.079020] [<fffffe00000a01c8>] do_page_fault+0x214/0x338
[ 1063.084480] [<fffffe000009022c>] do_mem_abort+0x38/0x9c
[ 1063.089691] Exception stack(0xfffffe03dbe83e30 to 0xfffffe03dbe83f50)
[ 1063.096102] 3e20:                                     00000000 
00000000 00007e36 00000000
[ 1063.104253] 3e40: ffffffff ffffffff b5728d14 000003ff dbe83e60 
fffffe03 001a8b80 fffffe00
[ 1063.112403] 3e60: dbe83ea0 fffffe03 001a9968 fffffe00 b4f60000 
000003ff 00000000 00000000
[ 1063.120554] 3e80: ffffffff ffffffff 001055ac fffffe00 dbe83ea0 
fffffe03 00010000 00000000
[ 1063.128693] 3ea0: e6cf3e80 000003ff 00093170 fffffe00 00000000 
00000000 0009308c fffffe00
[ 1063.136843] 3ec0: 00000000 00000000 00010000 00000000 d6cb9ee0 
000003ff d6d2fd70 000003ff
[ 1063.144994] 3ee0: d6d307f0 000003ff d6e03e80 000003ff 00000000 
00000000 d6de9ea0 000003ff
[ 1063.153148] 3f00: 00000006 00000000 00000006 00000000 0002edc2 
00000000 00000030 00000000
[ 1063.161299] 3f20: 00000426 00000000 1009a555 00000000 00000018 
00000000 ab5187f2 ffffffff
[ 1063.169446] 3f40: bc000000 003103cf 00000000 003b9aca
[ 1063.174472] Mem-Info:
[ 1063.176732] DMA per-cpu:
[ 1063.179262] CPU    0: hi:    6, btch:   1 usd:   0
[ 1063.184030] CPU    1: hi:    6, btch:   1 usd:   0
[ 1063.188797] CPU    2: hi:    6, btch:   1 usd:   0
[ 1063.193573] CPU    3: hi:    6, btch:   1 usd:   0
[ 1063.198341] CPU    4: hi:    6, btch:   1 usd:   0
[ 1063.203116] CPU    5: hi:    6, btch:   1 usd:   0
[ 1063.207883] CPU    6: hi:    6, btch:   1 usd:   0
[ 1063.212659] CPU    7: hi:    6, btch:   1 usd:   0
[ 1063.217426] Normal per-cpu:
[ 1063.220213] CPU    0: hi:    6, btch:   1 usd:   0
[ 1063.224981] CPU    1: hi:    6, btch:   1 usd:   1
[ 1063.229755] CPU    2: hi:    6, btch:   1 usd:   0
[ 1063.234521] CPU    3: hi:    6, btch:   1 usd:   0
[ 1063.239295] CPU    4: hi:    6, btch:   1 usd:   0
[ 1063.244061] CPU    5: hi:    6, btch:   1 usd:   0
[ 1063.248834] CPU    6: hi:    6, btch:   1 usd:   0
[ 1063.253602] CPU    7: hi:    6, btch:   1 usd:   0
[ 1063.258374] active_anon:207481 inactive_anon:25761 isolated_anon:0
[ 1063.258374]  active_file:1241 inactive_file:21246 isolated_file:3
[ 1063.258374]  unevictable:0 dirty:0 writeback:0 unstable:0
[ 1063.258374]  free:1015 slab_reclaimable:1044 slab_unreclaimable:1748
[ 1063.258374]  mapped:660 shmem:66 pagetables:236 bounce:0
[ 1063.258374]  free_cma:0
[ 1063.289954] DMA free:52864kB min:4032kB low:4992kB high:6016kB 
active_anon:3030784kB inactive_anon:612608kB active_file:18304kB 
inactive_file:323456kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:11968kB shmem:2112kB 
slab_reclaimable:26240kB slab_unreclaimable:36096kB kernel_stack:352kB 
pagetables:4928kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:26407104 all_unreclaimable? yes
[ 1063.333094] lowmem_reserve[]: 0 765 765
[ 1063.336965] Normal free:12096kB min:12224kB low:15232kB high:18304kB 
active_anon:10248000kB inactive_anon:1036096kB active_file:61120kB 
inactive_file:1036288kB unevictable:0kB isolated(anon):0kB 
isolated(file):192kB present:12582912kB managed:12538176kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:30272kB shmem:2112kB 
slab_reclaimable:40576kB slab_unreclaimable:75776kB kernel_stack:2944kB 
pagetables:10176kB unstable:0kB bounce:0kB free_cma:0kB 
writeback_tmp:0kB pages_scanned:81586304 all_unreclaimable? yes
[ 1063.381407] lowmem_reserve[]: 0 0 0
[ 1063.384924] DMA: 120*64kB (UR) 49*128kB (R) 8*256kB (R) 0*512kB 
0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 
0*65536kB = 52864kB
[ 1063.398274] Normal: 144*64kB (EMR) 9*128kB (R) 6*256kB (R) 0*512kB 
0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 11904kB
[ 1063.411177] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=524288kB
[ 1063.419760] 43809 total pagecache pages
[ 1063.423578] 25864 pages in swap cache
[ 1063.427222] Swap cache stats: add 28224, delete 2360, find 2495/2705
[ 1063.433558] Free swap  = 6636800kB
[ 1063.436942] Total swap = 8388544kB
[ 1063.440333] 262112 pages RAM
[ 1063.443199] 0 pages HighMem/MovableOnly
[ 1063.447014] 18446744073709544361 pages reserved
[ 1063.451530] 8192 pages cma reserved
[ 1063.455000] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[ 1063.462815] [  481]     0   481      234      112       3       26 
           0 systemd-journal
[ 1063.471568] [  487]     0   487     1420       32       3       80 
           0 lvmetad
[ 1063.479630] [  512]     0   512      216       40       2       46 
       -1000 systemd-udevd
[ 1063.488204] [  598]     0   598      258       45       3       38 
       -1000 auditd
[ 1063.496181] [  620]     0   620     6830      252       3       82 
           0 NetworkManager
[ 1063.504847] [  623]     0   623     2028       83       3      100 
           0 abrtd
[ 1063.512737] [  624]     0   624     2019       87       3       84 
           0 abrt-watch-log
[ 1063.521403] [  628]    70   628       87       55       4       18 
           0 avahi-daemon
[ 1063.529896] [  629]   998   629       40       13       2        0 
           0 lsmd
[ 1063.537689] [  631]    70   631       87        0       4       32 
           0 avahi-daemon
[ 1063.546184] [  641]     0   641     2687       82       3       56 
           0 rsyslogd
[ 1063.554337] [  642]     0   642       86       42       3        9 
           0 irqbalance
[ 1063.562660] [  647]     0   647      109       44       2       31 
           0 smartd
[ 1063.570635] [  651]   997   651       83       45       2       18 
           0 chronyd
[ 1063.578687] [  652]     0   652       99       38       3       36 
           0 systemd-logind
[ 1063.587354] [  653]    81   653      222       53       2       21 
        -900 dbus-daemon
[ 1063.595761] [  667]     0   667       79       27       3       29 
           0 atd
[ 1063.603476] [  675]     0   675     1846       68       4       86 
           0 login
[ 1063.611363] [  676]     0   676     1717       23       5       10 
           0 agetty
[ 1063.619338] [  710]     0   710     1761       47       3       36 
           0 bash
[ 1063.627132] [  727]     0   727      240       84       2       74 
       -1000 sshd
[ 1063.634935] [  733]     0   733     1739       34       3        9 
           0 rhsmcertd
[ 1063.643169] [  741]   999   741     7276      132       4      105 
           0 polkitd
[ 1063.651230] [ 1323]     0  1323      334       69       3       69 
           0 master
[ 1063.659205] [ 1325]    89  1325      337       82       2       78 
           0 qmgr
[ 1063.666998] [ 1328]     0  1328      358      130       3      111 
           0 sshd
[ 1063.674802] [ 1331]     0  1331     1762       48       5       39 
           0 bash
[ 1063.682608] [ 1373]    89  1373      336       89       2       69 
           0 pickup
[ 1063.690584] [ 2944]     0  2944     1734       50       4        3 
           0 make
[ 1063.698380] [31425]     0 31425     1760       82       3        0 
           0 make
[ 1063.706184] [32224]     0 32224     1736       51       4        0 
           0 sh
[ 1063.713814] [32230]     0 32230     1737       42       4        0 
           0 gcc
[ 1063.721529] [32232]     0 32232     1736       51       3        0 
           0 sh
[ 1063.729157] [32239]     0 32239     1737       42       5        0 
           0 gcc
[ 1063.736863] [32245]     0 32245     1736       51       4        0 
           0 sh
[ 1063.744494] [32246]     0 32246     2474      313       4        0 
           0 cc1
[ 1063.752208] [32248]     0 32248     1737       42       4        0 
           0 gcc
[ 1063.759923] [32250]     0 32250     1736       52       3        0 
           0 sh
[ 1063.767544] [32252]     0 32252     1737       43       4        0 
           0 gcc
[ 1063.775260] [32253]     0 32253     1736       51       5        0 
           0 sh
[ 1063.782889] [32254]     0 32254     2474      313       4        0 
           0 cc1
[ 1063.790605] [32257]     0 32257     2474      314       3        0 
           0 cc1
[ 1063.798311] [32258]     0 32258     1737       42       4        0 
           0 gcc
[ 1063.806028] [32260]     0 32260     1736       51       3        0 
           0 sh
[ 1063.813663] [32261]     0 32261     1737       42       3        0 
           0 gcc
[ 1063.821379] [32264]     0 32264     2470      295       3        0 
           0 cc1
[ 1063.829094] [32273]     0 32273     1736       51       5        0 
           0 sh
[ 1063.836714] [32276]     0 32276     1737       43       4        0 
           0 gcc
[ 1063.844429] [32278]     0 32278     1736       51       4        0 
           0 sh
[ 1063.852058] [32280]     0 32280     1737       43       4        0 
           0 gcc
[ 1063.859774] [32282]     0 32282     2474      314       4        0 
           0 cc1
[ 1063.867480] [32286]     0 32286     1736       52       4        0 
           0 sh
[ 1063.875110] [32287]     0 32287     2474      313       5        0 
           0 cc1
[ 1063.882826] [32291]     0 32291     1737       42       3        0 
           0 gcc
[ 1063.890541] [32294]     0 32294     2473      296       4        0 
           0 cc1
[ 1063.898248] [32299]     0 32299     1736       51       3        0 
           0 sh
[ 1063.905870] [32300]     0 32300     1737       42       3        0 
           0 gcc
[ 1063.913587] [32301]     0 32301     2464      199       3        0 
           0 cc1
[ 1063.921303] [32302]     0 32302     1736       51       4        0 
           0 sh
[ 1063.928931] [32303]     0 32303     1736       51       3        0 
           0 sh
[ 1063.936552] [32304]     0 32304     1737       42       4        0 
           0 gcc
[ 1063.944272] [32305]     0 32305     1737       43       4        0 
           0 gcc
[ 1063.951993] [32306]     0 32306     2464      199       4        0 
           0 cc1
[ 1063.959708] [32307]     0 32307       45       12       3        0 
           0 as
[ 1063.967329] [32308]     0 32308     2464      200       4        0 
           0 cc1
[ 1063.975044] [32309]     0 32309     1925      222       4        0 
           0 as
[ 1063.982674] [32310]     0 32310      211       61       3       63 
           0 systemd
[ 1063.990735] Out of memory: Kill process 620 (NetworkManager) score 0 
or sacrifice child
[ 1063.998701] Killed process 620 (NetworkManager) total-vm:437120kB, 
anon-rss:3712kB, file-rss:12416kB
[ 1064.007830] NetworkManager: page allocation failure: order:0, 
mode:0x2015a
[ 1064.014689] CPU: 1 PID: 620 Comm: NetworkManager Not tainted 
3.19.0-rc3+ #2
[ 1064.021622] Hardware name: APM X-Gene Mustang board (DT)
[ 1064.026907] Call trace:
[ 1064.029355] [<fffffe0000096954>] dump_backtrace+0x0/0x16c
[ 1064.034728] [<fffffe0000096ad0>] show_stack+0x10/0x1c
[ 1064.039761] [<fffffe000062911c>] dump_stack+0x74/0x98
[ 1064.044789] [<fffffe000017dc10>] warn_alloc_failed+0xe0/0x138
[ 1064.050513] [<fffffe00001809c8>] __alloc_pages_nodemask+0x658/0x8d8
[ 1064.056748] [<fffffe000017a690>] generic_file_read_iter+0x3c4/0x534
[ 1064.063030] [<fffffdfffc196754>] xfs_file_read_iter+0xe8/0x2a0 [xfs]
[ 1064.069367] [<fffffe00001d6500>] new_sync_read+0x84/0xc8
[ 1064.074654] [<fffffe00001d6ff4>] __vfs_read+0x14/0x50
[ 1064.079694] [<fffffe00001d70ac>] vfs_read+0x7c/0x154
[ 1064.084638] [<fffffe00001d71c4>] SyS_read+0x40/0xa0
[ 1064.089503] Mem-Info:
[ 1064.091765] DMA per-cpu:
[ 1064.094285] CPU    0: hi:    6, btch:   1 usd:   0
[ 1064.099056] CPU    1: hi:    6, btch:   1 usd:   0
[ 1064.103822] CPU    2: hi:    6, btch:   1 usd:   0
[ 1064.108586] CPU    3: hi:    6, btch:   1 usd:   0
[ 1064.113368] CPU    4: hi:    6, btch:   1 usd:   0
[ 1064.118134] CPU    5: hi:    6, btch:   1 usd:   0
[ 1064.122905] CPU    6: hi:    6, btch:   1 usd:   0
[ 1064.127671] CPU    7: hi:    6, btch:   1 usd:   0
[ 1064.132442] Normal per-cpu:
[ 1064.135220] CPU    0: hi:    6, btch:   1 usd:   0
[ 1064.139991] CPU    1: hi:    6, btch:   1 usd:   1
[ 1064.144755] CPU    2: hi:    6, btch:   1 usd:   0
[ 1064.149526] CPU    3: hi:    6, btch:   1 usd:   0
[ 1064.154290] CPU    4: hi:    6, btch:   1 usd:   0
[ 1064.159061] CPU    5: hi:    6, btch:   1 usd:   0
[ 1064.163826] CPU    6: hi:    6, btch:   1 usd:   0
[ 1064.168591] CPU    7: hi:    6, btch:   1 usd:   0
[ 1064.173365] active_anon:207484 inactive_anon:25769 isolated_anon:0
[ 1064.173365]  active_file:1247 inactive_file:21260 isolated_file:3
[ 1064.173365]  unevictable:0 dirty:0 writeback:0 unstable:0
[ 1064.173365]  free:1012 slab_reclaimable:1044 slab_unreclaimable:1748
[ 1064.173365]  mapped:661 shmem:66 pagetables:233 bounce:0
[ 1064.173365]  free_cma:0
[ 1064.204935] DMA free:52864kB min:4032kB low:4992kB high:6016kB 
active_anon:3030784kB inactive_anon:612608kB active_file:18304kB 
inactive_file:323520kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:11968kB shmem:2112kB 
slab_reclaimable:26240kB slab_unreclaimable:36096kB kernel_stack:336kB 
pagetables:4928kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:32080832 all_unreclaimable? yes
[ 1064.248071] lowmem_reserve[]: 0 765 765
[ 1064.251936] Normal free:11904kB min:12224kB low:15232kB high:18304kB 
active_anon:10248192kB inactive_anon:1036608kB active_file:61504kB 
inactive_file:1037120kB unevictable:0kB isolated(anon):0kB 
isolated(file):192kB present:12582912kB managed:12538176kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:30336kB shmem:2112kB 
slab_reclaimable:40576kB slab_unreclaimable:75776kB kernel_stack:2976kB 
pagetables:9984kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:98616256 all_unreclaimable? yes
[ 1064.296280] lowmem_reserve[]: 0 0 0
[ 1064.299798] DMA: 120*64kB (UR) 49*128kB (R) 8*256kB (R) 0*512kB 
0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 
0*65536kB = 52864kB
[ 1064.313134] Normal: 142*64kB (EMR) 9*128kB (R) 6*256kB (R) 0*512kB 
0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 11776kB
[ 1064.326021] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=524288kB
[ 1064.334600] 43816 total pagecache pages
[ 1064.338418] 25866 pages in swap cache
[ 1064.342068] Swap cache stats: add 28226, delete 2360, find 2497/2709
[ 1064.348389] Free swap  = 6636800kB
[ 1064.351777] Total swap = 8388544kB
[ 1064.355161] 262112 pages RAM
[ 1064.358025] 0 pages HighMem/MovableOnly
[ 1064.361844] 18446744073709544361 pages reserved
[ 1064.366349] 8192 pages cma reserved

Message from syslogd@localhost at Jan  8 07:46:45 ...
  kernel:Call trace:

Message from syslogd@localhost at Jan  8 07:46:45 ...
  kernel:Call trace:
[ 1065.640588] systemd-journal invoked oom-killer: gfp_mask=0x200da, 
order=0, oom_score_adj=0
[ 1065.648823] systemd-journal cpuset=/ mems_allowed=0
[ 1065.653724] CPU: 7 PID: 481 Comm: systemd-journal Not tainted 
3.19.0-rc3+ #2
[ 1065.660753] Hardware name: APM X-Gene Mustang board (DT)
[ 1065.666041] Call trace:
[ 1065.668484] [<fffffe0000096954>] dump_backtrace+0x0/0x16c
[ 1065.673878] [<fffffe0000096ad0>] show_stack+0x10/0x1c
[ 1065.678910] [<fffffe000062911c>] dump_stack+0x74/0x98
[ 1065.683957] [<fffffe0000626550>] dump_header.isra.11+0x98/0x1d0
[ 1065.689867] [<fffffe000017c4e0>] oom_kill_process+0x3ac/0x408
[ 1065.695590] [<fffffe000017c9d4>] out_of_memory+0x2a4/0x2d4
[ 1065.701067] [<fffffe0000180b78>] __alloc_pages_nodemask+0x808/0x8d8
[ 1065.707307] [<fffffe00001a443c>] handle_mm_fault+0x938/0xd1c
[ 1065.712945] [<fffffe00000a01c8>] do_page_fault+0x214/0x338
[ 1065.718403] [<fffffe000009022c>] do_mem_abort+0x38/0x9c
[ 1065.723607] Exception stack(0xfffffe03d6323bf0 to 0xfffffe03d6323d10)
[ 1065.730022] 3be0:                                     d6109780 
fffffe03 00000000 00000000
[ 1065.738159] 3c00: d6323db0 fffffe03 0031c184 fffffe00 00000005 
00000000 d6323cf0 fffffe03
[ 1065.746301] 3c20: d6323d00 fffffe03 ff0a0004 ffffffff d6323c70 
fffffe03 001f8b84 fffffe00
[ 1065.754443] 3c40: d6109780 fffffe03 00100073 00000000 d6323cf0 
fffffe03 d6323cf0 fffffe03
[ 1065.762584] 3c60: d6323cc0 fffffe03 ffffffd0 00000000 d6323cb0 
fffffe03 0023d2b0 fffffe00
[ 1065.770725] 3c80: 00d7d1d8 fffffe00 00000140 00000000 94560000 
000003ff ebed0008 fffffe03
[ 1065.778861] 3ca0: 0000006d 00000000 65703a39 655f6672 9456007d 
000003ff 002b5d34 00000000
[ 1065.787002] 3cc0: d9ff1000 fffffe03 00000000 00000000 00000000 
00000000 fefefefe ff2efefe
[ 1065.795143] 3ce0: ffffffff 7f7fffff 01010101 01010101 00000038 
00000000 00000038 00000000
[ 1065.803289] 3d00: ffffffff 0fffffff ffffffed ffffffff
[ 1065.808319] [<fffffe0000092b64>] el1_da+0x14/0x70
[ 1065.813007] [<fffffe00001d6ff4>] __vfs_read+0x14/0x50
[ 1065.818032] [<fffffe00001d70ac>] vfs_read+0x7c/0x154
[ 1065.822978] [<fffffe00001d71c4>] SyS_read+0x40/0xa0
[ 1065.827829] Mem-Info:
[ 1065.830097] DMA per-cpu:
[ 1065.832617] CPU    0: hi:    6, btch:   1 usd:   0
[ 1065.837381] CPU    1: hi:    6, btch:   1 usd:   0
[ 1065.842151] CPU    2: hi:    6, btch:   1 usd:   0
[ 1065.846916] CPU    3: hi:    6, btch:   1 usd:   0
[ 1065.851684] CPU    4: hi:    6, btch:   1 usd:   0
[ 1065.856449] CPU    5: hi:    6, btch:   1 usd:   0
[ 1065.861219] CPU    6: hi:    6, btch:   1 usd:   0
[ 1065.865984] CPU    7: hi:    6, btch:   1 usd:   0
[ 1065.870752] Normal per-cpu:
[ 1065.873529] CPU    0: hi:    6, btch:   1 usd:   0
[ 1065.878294] CPU    1: hi:    6, btch:   1 usd:   0
[ 1065.883063] CPU    2: hi:    6, btch:   1 usd:   0
[ 1065.887828] CPU    3: hi:    6, btch:   1 usd:   0
[ 1065.892598] CPU    4: hi:    6, btch:   1 usd:   0
[ 1065.897362] CPU    5: hi:    6, btch:   1 usd:   0
[ 1065.902133] CPU    6: hi:    6, btch:   1 usd:   0
[ 1065.906897] CPU    7: hi:    6, btch:   1 usd:   0
[ 1065.911671] active_anon:207543 inactive_anon:25751 isolated_anon:0
[ 1065.911671]  active_file:1192 inactive_file:21238 isolated_file:0
[ 1065.911671]  unevictable:0 dirty:1 writeback:0 unstable:0
[ 1065.911671]  free:1016 slab_reclaimable:1044 slab_unreclaimable:1748
[ 1065.911671]  mapped:572 shmem:68 pagetables:224 bounce:0
[ 1065.911671]  free_cma:1
[ 1065.943242] DMA free:52928kB min:4032kB low:4992kB high:6016kB 
active_anon:3030720kB inactive_anon:612544kB active_file:18496kB 
inactive_file:323008kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:4192256kB managed:4177024kB mlocked:0kB 
dirty:64kB writeback:0kB mapped:11904kB shmem:2112kB 
slab_reclaimable:26240kB slab_unreclaimable:36096kB kernel_stack:336kB 
pagetables:4736kB unstable:0kB bounce:0kB free_cma:64kB 
writeback_tmp:0kB pages_scanned:25027136 all_unreclaimable? yes
[ 1065.986550] lowmem_reserve[]: 0 765 765
[ 1065.990433] Normal free:12480kB min:12224kB low:15232kB high:18304kB 
active_anon:10252032kB inactive_anon:1035776kB active_file:57792kB 
inactive_file:1036672kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:12582912kB managed:12538176kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:24704kB shmem:2240kB 
slab_reclaimable:40576kB slab_unreclaimable:75776kB kernel_stack:2928kB 
pagetables:9600kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:81503232 all_unreclaimable? yes
[ 1066.034608] lowmem_reserve[]: 0 0 0
[ 1066.038124] DMA: 122*64kB (UR) 49*128kB (R) 8*256kB (R) 0*512kB 
0*1024kB 0*2048kB 1*4096kB (R) 0*8192kB 0*16384kB 1*32768kB (R) 
0*65536kB = 52992kB
[ 1066.051465] Normal: 116*64kB (EMR) 18*128kB (MR) 6*256kB (R) 0*512kB 
0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB 0*65536kB = 11264kB
[ 1066.064522] Node 0 hugepages_total=0 hugepages_free=0 
hugepages_surp=0 hugepages_size=524288kB
[ 1066.073093] 43745 total pagecache pages
[ 1066.076909] 25845 pages in swap cache
[ 1066.080557] Swap cache stats: add 28232, delete 2387, find 2500/2717
[ 1066.086877] Free swap  = 6643328kB
[ 1066.090264] Total swap = 8388544kB
[ 1066.093648] 262112 pages RAM
[ 1066.096511] 0 pages HighMem/MovableOnly
[ 1066.100330] 18446744073709544361 pages reserved
[ 1066.104835] 8192 pages cma reserved
[ 1066.108305] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[ 1066.116115] [  481]     0   481      234      112       3       26 
           0 systemd-journal
[ 1066.124864] [  487]     0   487     1420       32       3       80 
           0 lvmetad
[ 1066.132920] [  512]     0   512      216       40       2       46 
       -1000 systemd-udevd
[ 1066.141498] [  598]     0   598      258       45       3       38 
       -1000 auditd
[ 1066.149467] [  623]     0   623     2028       83       3      100 
           0 abrtd
[ 1066.157345] [  624]     0   624     2019       87       3       84 
           0 abrt-watch-log
[ 1066.166006] [  628]    70   628       87       55       4       18 
           0 avahi-daemon
[ 1066.174494] [  629]   998   629       40       13       2        0 
           0 lsmd
[ 1066.182291] [  631]    70   631       87        0       4       32 
           0 avahi-daemon
[ 1066.190779] [  641]     0   641     2687       82       3       56 
           0 rsyslogd
[ 1066.198915] [  642]     0   642       86       42       3        9 
           0 irqbalance
[ 1066.207230] [  647]     0   647      109       44       2       31 
           0 smartd
[ 1066.215199] [  651]   997   651       83       45       2       18 
           0 chronyd
[ 1066.223255] [  652]     0   652       99       38       3       36 
           0 systemd-logind
[ 1066.231916] [  653]    81   653      222       53       2       21 
        -900 dbus-daemon
[ 1066.240319] [  667]     0   667       79       27       3       29 
           0 atd
[ 1066.248024] [  675]     0   675     1846       68       4       86 
           0 login
[ 1066.255907] [  676]     0   676     1717       23       5       10 
           0 agetty
[ 1066.263878] [  710]     0   710     1761       47       3       36 
           0 bash
[ 1066.271674] [  727]     0   727      240       84       2       74 
       -1000 sshd
[ 1066.279472] [  733]     0   733     1739       34       3        9 
           0 rhsmcertd
[ 1066.287695] [  741]   999   741     7276      132       4      105 
           0 polkitd
[ 1066.295750] [ 1323]     0  1323      334       69       3       69 
           0 master
[ 1066.303720] [ 1325]    89  1325      337       82       2       78 
           0 qmgr
[ 1066.311516] [ 1328]     0  1328      358      130       3      111 
           0 sshd
[ 1066.319313] [ 1331]     0  1331     1762       48       5       39 
           0 bash
[ 1066.327105] [ 1373]    89  1373      336       89       2       69 
           0 pickup
[ 1066.335073] [ 2944]     0  2944     1734       50       4        3 
           0 make
[ 1066.342871] [31425]     0 31425     1760       82       3        0 
           0 make
[ 1066.350668] [32224]     0 32224     1736       51       4        0 
           0 sh
[ 1066.358287] [32232]     0 32232     1736       51       3        0 
           0 sh
[ 1066.365912] [32239]     0 32239     1737       42       5        0 
           0 gcc
[ 1066.373624] [32245]     0 32245     1736       51       4        0 
           0 sh
[ 1066.381249] [32246]     0 32246     2474      313       4        0 
           0 cc1
[ 1066.388953] [32248]     0 32248     1737       42       4        0 
           0 gcc
[ 1066.396667] [32250]     0 32250     1736       52       3        0 
           0 sh
[ 1066.404293] [32252]     0 32252     1737       43       4        0 
           0 gcc
[ 1066.412005] [32253]     0 32253     1736       51       5        0 
           0 sh
[ 1066.419631] [32254]     0 32254     2474      313       4        0 
           0 cc1
[ 1066.427336] [32257]     0 32257     2474      314       3        0 
           0 cc1
[ 1066.435046] [32258]     0 32258     1737       42       4        0 
           0 gcc
[ 1066.442757] [32260]     0 32260     1736       51       3        0 
           0 sh
[ 1066.450387] [32261]     0 32261     1737       42       3        0 
           0 gcc
[ 1066.458092] [32264]     0 32264     2473      295       3        0 
           0 cc1
[ 1066.465802] [32273]     0 32273     1736       51       5        0 
           0 sh
[ 1066.473426] [32276]     0 32276     1737       43       4        0 
           0 gcc
[ 1066.481136] [32278]     0 32278     1736       51       4        0 
           0 sh
[ 1066.488755] [32280]     0 32280     1737       43       4        0 
           0 gcc
[ 1066.496464] [32282]     0 32282     2474      314       4        0 
           0 cc1
[ 1066.504175] [32286]     0 32286     1736       52       4        0 
           0 sh
[ 1066.511799] [32287]     0 32287     2474      313       5        0 
           0 cc1
[ 1066.519509] [32291]     0 32291     1737       42       3        0 
           0 gcc
[ 1066.527213] [32294]     0 32294     2473      296       4        0 
           0 cc1
[ 1066.534923] [32299]     0 32299     1736       51       3        0 
           0 sh
[ 1066.542547] [32300]     0 32300     1737       42       3        0 
           0 gcc
[ 1066.550257] [32301]     0 32301     2464      199       3        0 
           0 cc1
[ 1066.557961] [32302]     0 32302     1736       51       4        0 
           0 sh
[ 1066.565584] [32303]     0 32303     1736       51       3        0 
           0 sh
[ 1066.573208] [32304]     0 32304     1737       42       4        0 
           0 gcc
[ 1066.580917] [32305]     0 32305     1737       43       4        0 
           0 gcc
[ 1066.588622] [32306]     0 32306     2466      232       4        0 
           0 cc1
[ 1066.596332] [32307]     0 32307     1918      222       5        0 
           0 as
[ 1066.603955] [32308]     0 32308     2464      200       4        0 
           0 cc1
[ 1066.611666] [32310]     0 32310       42       13       2        0 
           0 nm-dispatcher
[ 1066.620239] [32311]     0 32311        7        1       1        0 
           0 systemd-cgroups
[ 1066.628980] Out of memory: Kill process 32282 (cc1) score 0 or 
sacrifice child
[ 1066.636172] Killed process 32282 (cc1) total-vm:158336kB, 
anon-rss:10816kB, file-rss:9280kB

Message from syslogd@localhost at Jan  8 07:46:47 ...
  kernel:Call trace:

