Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbaJ1Iyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:54:31 -0400
Received: from [62.179.121.35] ([62.179.121.35]:64068 "EHLO
	fep15.mx.upcmail.net" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756212AbaJ1IyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:54:25 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <544F59A2.8040305@odi.ch>
Date: Tue, 28 Oct 2014 09:53:54 +0100
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.18-rc2 sudden strike of OOM killer
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happened right after boot when launching Firefox. There is plenty of RAM, 
but no swap with vm.overcommit_memory=0:

$ free -m
              total       used       free     shared    buffers     cached
Mem:          3569        656       2912        128         16        258
-/+ buffers/cache:        382       3187
Swap:            0          0          0

[   97.290091] Purging GPU memory, 0 bytes freed, 12468224 bytes still pinned.
[   97.290195] X invoked oom-killer: gfp_mask=0x0, order=0, oom_score_adj=0
[   97.290198] CPU: 2 PID: 1383 Comm: X Not tainted 3.18.0-rc2 #2
[   97.290199] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 
900X3C/900X3D/900X4C/900X4D/NP900X3D-A03CH, BIOS P02ABK 09/19/2012
[   97.290200]  ffff8800c48b96f8 ffff8800bfb93c18 ffffffff8192e82e 0000000000000000
[   97.290203]  ffff8800c48b9080 ffff8800bfb93cb8 ffffffff8192c5be ffff8800bfb93c88
[   97.290205]  ffffffff8148e9ee ffff880055aad840 0000000000000000 ffff8800bfb93ca8
[   97.290207] Call Trace:
[   97.290214]  [<ffffffff8192e82e>] dump_stack+0x4e/0x71
[   97.290216]  [<ffffffff8192c5be>] dump_header.isra.12+0x6e/0x1f0
[   97.290221]  [<ffffffff8148e9ee>] ? i915_gem_shrinker_oom+0x18e/0x200
[   97.290225]  [<ffffffff8135ee46>] ? ___ratelimit+0x96/0x110
[   97.290229]  [<ffffffff811b8be2>] oom_kill_process+0x222/0x3b0
[   97.290232]  [<ffffffff810f6c27>] ? has_capability_noaudit+0x17/0x20
[   97.290234]  [<ffffffff811b91df>] out_of_memory+0x2af/0x320
[   97.290237]  [<ffffffff811b9280>] pagefault_out_of_memory+0x30/0x50
[   97.290239]  [<ffffffff8192b783>] mm_fault_error+0xb8/0x160
[   97.290241]  [<ffffffff81088d71>] __do_page_fault+0x441/0x4d0
[   97.290245]  [<ffffffff81138503>] ? rcu_eqs_enter+0x73/0xa0
[   97.290249]  [<ffffffff81178ccc>] ? acct_account_cputime+0x1c/0x20
[   97.290252]  [<ffffffff811192fb>] ? account_user_time+0x8b/0xa0
[   97.290254]  [<ffffffff8111986d>] ? vtime_account_user+0x5d/0x70
[   97.290255]  [<ffffffff81088e8b>] do_page_fault+0x5b/0x80
[   97.290259]  [<ffffffff81938c22>] page_fault+0x22/0x30
[   97.290260] Mem-Info:
[   97.290261] DMA per-cpu:
[   97.290262] CPU    0: hi:    0, btch:   1 usd:   0
[   97.290263] CPU    1: hi:    0, btch:   1 usd:   0
[   97.290263] CPU    2: hi:    0, btch:   1 usd:   0
[   97.290264] CPU    3: hi:    0, btch:   1 usd:   0
[   97.290265] DMA32 per-cpu:
[   97.290265] CPU    0: hi:  186, btch:  31 usd:   0
[   97.290266] CPU    1: hi:  186, btch:  31 usd:   0
[   97.290267] CPU    2: hi:  186, btch:  31 usd:  41
[   97.290268] CPU    3: hi:  186, btch:  31 usd:   0
[   97.290268] Normal per-cpu:
[   97.290269] CPU    0: hi:  186, btch:  31 usd:   0
[   97.290270] CPU    1: hi:  186, btch:  31 usd:   0
[   97.290271] CPU    2: hi:  186, btch:  31 usd:   0
[   97.290271] CPU    3: hi:  186, btch:  31 usd:   0
[   97.290274] active_anon:147835 inactive_anon:719262 isolated_anon:0
  active_file:1533 inactive_file:1728 isolated_file:64
  unevictable:0 dirty:1654 writeback:0 unstable:0
  free:20872 slab_reclaimable:5177 slab_unreclaimable:4623
  mapped:11728 shmem:722103 pagetables:5799 bounce:0
  free_cma:0
[   97.290278] DMA free:14492kB min:292kB low:364kB high:436kB active_anon:272kB 
inactive_anon:852kB active_file:12kB inactive_file:12kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:868kB slab_reclaimable:32kB 
slab_unreclaimable:24kB kernel_stack:48kB pagetables:16kB unstable:0kB 
bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:8 all_unreclaimable? no
[   97.290279] lowmem_reserve[]: 0 3118 3551 3551
[   97.290285] DMA32 free:60892kB min:59092kB low:73864kB high:88636kB 
active_anon:521180kB inactive_anon:2533616kB active_file:5248kB 
inactive_file:5492kB unevictable:0kB isolated(anon):0kB isolated(file):256kB 
present:3276724kB managed:3196196kB mlocked:0kB dirty:5332kB writeback:0kB 
mapped:43348kB shmem:2543532kB slab_reclaimable:17536kB 
slab_unreclaimable:13132kB kernel_stack:3904kB pagetables:19656kB unstable:0kB 
bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:1916 all_unreclaimable? no
[   97.290285] lowmem_reserve[]: 0 0 432 432
[   97.290290] Normal free:8104kB min:8192kB low:10240kB high:12288kB 
active_anon:69888kB inactive_anon:342580kB active_file:872kB 
inactive_file:1408kB unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:514048kB managed:442908kB mlocked:0kB dirty:1284kB writeback:0kB 
mapped:3560kB shmem:344012kB slab_reclaimable:3140kB slab_unreclaimable:5336kB 
kernel_stack:1552kB pagetables:3524kB unstable:0kB bounce:0kB free_cma:0kB 
writeback_tmp:0kB pages_scanned:852 all_unreclaimable? no
[   97.290291] lowmem_reserve[]: 0 0 0 0
[   97.290293] DMA: 15*4kB (M) 17*8kB (UEM) 8*16kB (EM) 5*32kB (EM) 7*64kB (UEM) 
0*128kB 1*256kB (U) 0*512kB 3*1024kB (UEM) 3*2048kB (EMR) 1*4096kB (M) = 14500kB
[   97.290302] DMA32: 2454*4kB (UEM) 1333*8kB (UEM) 816*16kB (UEM) 464*32kB 
(UEM) 103*64kB (M) 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 1*4096kB (R) = 
61120kB
[   97.290309] Normal: 499*4kB (UEM) 172*8kB (UEM) 91*16kB (UEM) 4*32kB (EM) 
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) = 9052kB
[   97.290317] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 
hugepages_size=2048kB
[   97.290318] 725378 total pagecache pages
[   97.290319] 0 pages in swap cache
[   97.290320] Swap cache stats: add 0, delete 0, find 0/0
[   97.290320] Free swap  = 0kB
[   97.290321] Total swap = 0kB
[   97.290321] 951689 pages RAM
[   97.290322] 0 pages HighMem/MovableOnly
[   97.290323] 17785 pages reserved
[   97.290323] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents 
oom_score_adj name
[   97.290328] [  341]     0   341     8258      285      19        0 
-1000 systemd-udevd
[   97.290329] [ 1080]   101  1080     4527      250      14        0 
   0 dbus-daemon
[   97.290331] [ 1144]     0  1144     6815       64      17        0 
   0 syslog-ng
[   97.290333] [ 1145]     0  1145    90720      470      44        0 
   0 syslog-ng
[   97.290334] [ 1171]     0  1171     2567       29       9        0 
   0 rdnssd
[   97.290336] [ 1172] 65534  1172     4672       75      13        0 
   0 rdnssd
[   97.290337] [ 1212]     0  1212    73410      509      63        0 
   0 NetworkManager
[   97.290339] [ 1221]   107  1221   126846     1465      45        0 
   0 polkitd
[   97.290340] [ 1236]     0  1236     7385      186      19        0 
   0 wpa_supplicant
[   97.290342] [ 1278]     0  1278   522398      329      57        0 
   0 console-kit-dae
[   97.290343] [ 1379]     0  1379     6695      100      18        0 
   0 kdm
[   97.290344] [ 1383]     0  1383   762442    13288    1456        0 
   0 X
[   97.290346] [ 1430]     0  1430     5288      141      13        0 
   0 bluetoothd
[   97.290347] [ 1452]   102  1452     8047      127      22        0 
   0 avahi-daemon
[   97.290348] [ 1453]   102  1453     8016       61      21        0 
   0 avahi-daemon
[   97.290350] [ 1479]     0  1479    11578      283      26        0 
   0 cupsd
[   97.290351] [ 1498]     0  1498    10745      243      25        0 
   0 cups-browsed
[   97.290353] [ 1537]     0  1537     9905      196      23        0 
   0 ntpd
[   97.290354] [ 1561]     0  1561     8685      173      20        0 
-1000 sshd
[   97.290355] [ 1581]     0  1581     4658       71      14        0 
   0 cron
[   97.290357] [ 1604]     0  1604    18711      214      43        0 
   0 kdm
[   97.290358] [ 1619]     0  1619     5699       82      16        0 
   0 agetty
[   97.290360] [ 1620]     0  1620     5699       81      15        0 
   0 agetty
[   97.290361] [ 1621]     0  1621     5699       83      16        0 
   0 agetty
[   97.290362] [ 1622]     0  1622     5699       83      16        0 
   0 agetty
[   97.290364] [ 1623]     0  1623     5699       80      15        0 
   0 agetty
[   97.290365] [ 1624]     0  1624     5699       80      16        0 
   0 agetty
[   97.290366] [ 1643]  1000  1643     3396      107      11        0 
   0 startkde
[   97.290368] [ 1655]  1000  1655     6083       61      16        0 
   0 dbus-launch
[   97.290369] [ 1656]  1000  1656     4456      179      13        0 
   0 dbus-daemon
[   97.290371] [ 1689]  1000  1689     3700       84      11        0 
   0 ssh-agent
[   97.290372] [ 1702]  1000  1702    78908     1632     131        0 
   0 kdeinit4
[   97.290373] [ 1703]  1000  1703    79881     1601     119        0 
   0 klauncher
[   97.290375] [ 1705]  1000  1705   313641     4086     227        0 
   0 kded4
[   97.290376] [ 1707]  1000  1707     4535      106      15        0 
   0 gam_server
[   97.290377] [ 1710]  1000  1710     4746       55      14        0 
   0 obexd
[   97.290379] [ 1712]     0  1712    90976      367      42        0 
   0 udisksd
[   97.290381] [ 1732]     0  1732    50634      275      31        0 
   0 upowerd
[   97.290382] [ 1783]  1000  1783    66855     1001     110        0 
   0 bluedevil-monol
[   97.290384] [ 1844]  1000  1844    97083     2400     149        0 
   0 kglobalaccel
[   97.290385] [ 1859]  1000  1859   143111     1687     127        0 
   0 kactivitymanage
[   97.290386] [ 1863]  1000  1863     1050       19       8        0 
   0 kwrapper4
[   97.290388] [ 1864]  1000  1864   120041     2199     161        0 
   0 ksmserver
[   97.290389] [ 1869]  1000  1869   100809     1841     123        0 
   0 kio_trash
[   97.290390] [ 1872]  1000  1872   724415     8240     219        0 
   0 kwin
[   97.290392] [ 1878]  1000  1878   196304     3615     238        0 
   0 krunner
[   97.290393] [ 1880]  1000  1880   792688    19708     304        0 
   0 plasma-desktop
[   97.290394] [ 1884]  1000  1884     2469      166      11        0 
   0 ksysguardd
[   97.290396] [ 1902]  1000  1902   100809     1844     123        0 
   0 kio_trash
[   97.290397] [ 1905]  1000  1905   100810     1844     123        0 
   0 kio_trash
[   97.290398] [ 1906]  1000  1906    80129     1747     118        0 
   0 kio_desktop
[   97.290400] [ 1922]  1000  1922    81583     1614     119        0 
   0 kio_file
[   97.290401] [ 1941]     0  1941     1624       64       8        0 
   0 dhcpcd
[   97.290402] [ 1954]  1000  1954   140303     3453     165        0 
   0 kmix
[   97.290404] [ 1957]  1000  1957   123479     3654     169        0 
   0 konsole
[   97.290405] [ 1961]  1000  1961    92116     1311     135        0 
   0 polkit-kde-auth
[   97.290407] [ 1964]  1000  1964    11165      334      26        0 
   0 xconsole
[   97.290408] [ 1966]  1000  1966    87379     1776     122        0 
   0 knotify4
[   97.290409] [ 1968]  1000  1968     5536      128      15        0 
   0 bash
[   97.290411] [ 1973]  1000  1973     5536      128      15        0 
   0 bash
[   97.290412] [ 2242]  1000  2242   145596    23921     219        0 
   0 thunderbird
[   97.290413] [ 2252]  1000  2252    47700      105      30        0 
   0 at-spi-bus-laun
[   97.290415] [ 2254]  1000  2254    11317      169      27        0 
   0 gconfd-2
[   97.290416] [ 2285]  1000  2285   211595    68281     309        0 
   0 firefox
[   97.290417] Out of memory: Kill process 2285 (firefox) score 75 or sacrifice 
child
[   97.290419] Killed process 2285 (firefox) total-vm:846380kB, 
anon-rss:270712kB, file-rss:2412kB
