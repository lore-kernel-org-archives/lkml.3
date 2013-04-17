Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966172Ab3DQJsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:48:03 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36243 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965780Ab3DQJr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:47:58 -0400
Date: Wed, 17 Apr 2013 17:47:50 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130417094750.GB2672@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20130416110009.GA2664@localhost.localdomain>
 <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041709-7182-0000-0000-00000646F3E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 01:16:42PM -0700, David Rientjes wrote:
> On Tue, 16 Apr 2013, Han Pingtian wrote:
> 
> > Hi list,
> > 
> > On a power7 system, we have installed 3.9-rc7 and crash 6.1.6. If I run
> > something like "make -j 64" to compile linux kernel from source, sooner
> > or latter, oom-killer will be triggered. Before that, when I trying to
> > analyse the live system with crash, some processes' %MEM and RSS looks
> > too big:
> > 
> 
> Do you have the oom killer log from /var/log/messages with 
> /proc/sys/vm/oom_dump_tasks enabled?  Have you tried to reproduce this 
> issue with CONFIG_DEBUG_VM and CONFIG_DEBUG_PAGEALLOC enabled (you may 
> even want to consider CONFIG_KMEMLEAK)?
> 
I also enabled CONFIG_DEBUG_PAGEALLOC and oom_dump_tasks is actived.
This is part of the oom killer log:


[root@riblp3 ~]# [ 5233.949303] systemd-journal invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
[ 5233.949322] systemd-journal cpuset=/ mems_allowed=1
[ 5233.949326] Call Trace:
[ 5233.949334] [c0000000909832d0] [c0000000000151b8] .show_stack+0x78/0x1e0 (unreliable)
[ 5233.949343] [c0000000909833a0] [c0000000007132b0] .dump_header+0xb4/0x224
[ 5233.949349] [c000000090983470] [c000000000184ec8] .oom_kill_process+0x378/0x530
[ 5233.949354] [c000000090983560] [c0000000001858d8] .out_of_memory+0x528/0x560
[ 5233.949359] [c000000090983640] [c00000000018b84c] .__alloc_pages_nodemask+0x9dc/0xa10
[ 5233.949365] [c0000000909837f0] [c0000000001d69e8] .alloc_pages_current+0xb8/0x1b0
[ 5233.949369] [c000000090983890] [c000000000181078] .__page_cache_alloc+0x108/0x150
[ 5233.949374] [c000000090983920] [c000000000183520] .filemap_fault+0x250/0x500
[ 5233.949379] [c000000090983a00] [c0000000001ae56c] .__do_fault+0xbc/0x780
[ 5233.949384] [c000000090983b00] [c0000000001b25ec] .handle_pte_fault+0xbc/0xc20
[ 5233.949388] [c000000090983c00] [c000000000708690] .do_page_fault+0x440/0x880
[ 5233.949393] [c000000090983e30] [c000000000009268] handle_page_fault+0x10/0x30
[ 5233.949397] Mem-Info:
[ 5233.949399] Node 1 DMA per-cpu:
[ 5233.949402] CPU    0: hi:    6, btch:   1 usd:   0
[ 5233.949406] CPU    1: hi:    6, btch:   1 usd:   0
[ 5233.949409] CPU    2: hi:    6, btch:   1 usd:   0
[ 5233.949411] CPU    3: hi:    6, btch:   1 usd:   0
[ 5233.949414] CPU    4: hi:    6, btch:   1 usd:   0
[ 5233.949417] CPU    5: hi:    6, btch:   1 usd:   0
[ 5233.949420] CPU    6: hi:    6, btch:   1 usd:   0
[ 5233.949423] CPU    7: hi:    6, btch:   1 usd:   0
[ 5233.949426] CPU    8: hi:    6, btch:   1 usd:   0
[ 5233.949429] CPU    9: hi:    6, btch:   1 usd:   0
[ 5233.949432] CPU   10: hi:    6, btch:   1 usd:   0
[ 5233.949435] CPU   11: hi:    6, btch:   1 usd:   0
[ 5233.949438] CPU   12: hi:    6, btch:   1 usd:   0
[ 5233.949441] CPU   13: hi:    6, btch:   1 usd:   0
[ 5233.949444] CPU   14: hi:    6, btch:   1 usd:   0
[ 5233.949447] CPU   15: hi:    6, btch:   1 usd:   0
[ 5233.949450] CPU   16: hi:    6, btch:   1 usd:   0
[ 5233.949452] CPU   17: hi:    6, btch:   1 usd:   0
[ 5233.949455] CPU   18: hi:    6, btch:   1 usd:   0
[ 5233.949458] CPU   19: hi:    6, btch:   1 usd:   0
[ 5233.949461] CPU   20: hi:    6, btch:   1 usd:   0
[ 5233.949464] CPU   21: hi:    6, btch:   1 usd:   0
[ 5233.949467] CPU   22: hi:    6, btch:   1 usd:   0
[ 5233.949470] CPU   23: hi:    6, btch:   1 usd:   0
[ 5233.949473] CPU   24: hi:    6, btch:   1 usd:   0
[ 5233.949476] CPU   25: hi:    6, btch:   1 usd:   0
[ 5233.949478] CPU   26: hi:    6, btch:   1 usd:   0
[ 5233.949481] CPU   27: hi:    6, btch:   1 usd:   0
[ 5233.949484] CPU   28: hi:    6, btch:   1 usd:   0
[ 5233.949487] CPU   29: hi:    6, btch:   1 usd:   0
[ 5233.949490] CPU   30: hi:    6, btch:   1 usd:   0
[ 5233.949493] CPU   31: hi:    6, btch:   1 usd:   0
[ 5233.949496] CPU   32: hi:    6, btch:   1 usd:   0
[ 5233.949499] CPU   33: hi:    6, btch:   1 usd:   0
[ 5233.949502] CPU   34: hi:    6, btch:   1 usd:   0
[ 5233.949504] CPU   35: hi:    6, btch:   1 usd:   0
[ 5233.949507] CPU   36: hi:    6, btch:   1 usd:   0
[ 5233.949510] CPU   37: hi:    6, btch:   1 usd:   0
[ 5233.949513] CPU   38: hi:    6, btch:   1 usd:   0
[ 5233.949516] CPU   39: hi:    6, btch:   1 usd:   0
[ 5233.949519] CPU   40: hi:    6, btch:   1 usd:   0
[ 5233.949564] CPU   41: hi:    6, btch:   1 usd:   0
[ 5233.949567] CPU   42: hi:    6, btch:   1 usd:   0
[ 5233.949570] CPU   43: hi:    6, btch:   1 usd:   0
[ 5233.949573] CPU   44: hi:    6, btch:   1 usd:   0
[ 5233.949576] CPU   45: hi:    6, btch:   1 usd:   0
[ 5233.949579] CPU   46: hi:    6, btch:   1 usd:   0
[ 5233.949582] CPU   47: hi:    6, btch:   1 usd:   0
[ 5233.949586] CPU   48: hi:    6, btch:   1 usd:   0
[ 5233.949589] CPU   49: hi:    6, btch:   1 usd:   0
[ 5233.949592] CPU   50: hi:    6, btch:   1 usd:   0
[ 5233.949596] CPU   51: hi:    6, btch:   1 usd:   0
[ 5233.949599] CPU   52: hi:    6, btch:   1 usd:   0
[ 5233.949602] CPU   53: hi:    6, btch:   1 usd:   0
[ 5233.949606] CPU   54: hi:    6, btch:   1 usd:   0
[ 5233.949610] CPU   55: hi:    6, btch:   1 usd:   0
[ 5233.949613] CPU   56: hi:    6, btch:   1 usd:   0
[ 5233.949616] CPU   57: hi:    6, btch:   1 usd:   0
[ 5233.949619] CPU   58: hi:    6, btch:   1 usd:   0
[ 5233.949622] CPU   59: hi:    6, btch:   1 usd:   0
[ 5233.949633] CPU   60: hi:    6, btch:   1 usd:   0
[ 5233.949636] CPU   61: hi:    6, btch:   1 usd:   0
[ 5233.949639] CPU   62: hi:    6, btch:   1 usd:   0
[ 5233.949642] CPU   63: hi:    6, btch:   1 usd:   0
[ 5233.949647] CPU   64: hi:    6, btch:   1 usd:   0
[ 5233.949650] CPU   65: hi:    6, btch:   1 usd:   0
[ 5233.949654] CPU   66: hi:    6, btch:   1 usd:   0
[ 5233.949657] CPU   67: hi:    6, btch:   1 usd:   0
[ 5233.949660] CPU   68: hi:    6, btch:   1 usd:   0
[ 5233.949663] CPU   69: hi:    6, btch:   1 usd:   0
[ 5233.949666] CPU   70: hi:    6, btch:   1 usd:   0
[ 5233.949670] CPU   71: hi:    6, btch:   1 usd:   0
[ 5233.949673] CPU   72: hi:    6, btch:   1 usd:   0
[ 5233.949676] CPU   73: hi:    6, btch:   1 usd:   0
[ 5233.949680] CPU   74: hi:    6, btch:   1 usd:   0
[ 5233.949683] CPU   75: hi:    6, btch:   1 usd:   0
[ 5233.949687] CPU   76: hi:    6, btch:   1 usd:   0
[ 5233.949690] CPU   77: hi:    6, btch:   1 usd:   0
[ 5233.949694] CPU   78: hi:    6, btch:   1 usd:   0
[ 5233.949697] CPU   79: hi:    6, btch:   1 usd:   0
[ 5233.949702] active_anon:0 inactive_anon:56 isolated_anon:0
[ 5233.949702]  active_file:35 inactive_file:9 isolated_file:0
[ 5233.949702]  unevictable:0 dirty:1 writeback:7 unstable:0
[ 5233.949702]  free:62 slab_reclaimable:1664 slab_unreclaimable:57109
[ 5233.949702]  mapped:0 shmem:1 pagetables:289 bounce:0
[ 5233.949702]  free_cma:0
[ 5233.949714] Node 1 DMA free:3968kB min:7808kB low:9728kB high:11712kB active_anon:0kB inactive_anon:3584kB active_file:2240kB inactive_file:576kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4194304kB managed:3854464kB mlocked:0kB dirty:64kB writeback:448kB mapped:0kB shmem:64kB slab_reclaimable:106496kB slab_unreclaimable:3654976kB kernel_stack:14912kB pagetables:18496kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:531 all_unreclaimable? yes
[ 5233.949731] lowmem_reserve[]: 0 0 0
[ 5233.949736] Node 1 DMA: 158*64kB (MR) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 10112kB
[ 5233.949748] 140 total pagecache pages
[ 5233.949752] 48 pages in swap cache
[ 5233.949755] Swap cache stats: add 344091, delete 344043, find 186543/226974
[ 5233.949758] Free swap  = 3891840kB
[ 5233.949760] Total swap = 4128704kB
[ 5233.950850] 65536 pages RAM
[ 5233.950857] 4923 pages reserved
[ 5233.950859] 131794 pages shared
[ 5233.950861] 60324 pages non-shared
[ 5233.950863] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[ 5233.950958] [  805]     0   805      218        2       4       49         -1000 systemd-udevd
[ 5233.950965] [  826]     0   826      477        0       4       51             0 systemd-journal
[ 5233.950977] [ 1283]     0  1283      278        0       4       77         -1000 auditd
[ 5233.950983] [ 1303]     0  1303     2263        0       5      303             0 firewalld
[ 5233.950987] [ 1304]     0  1304     1826        2       5       27             0 abrtd
[ 5233.950994] [ 1327]     0  1327     3578        0       4       53             0 rsyslogd
[ 5233.950998] [ 1333]     0  1333       85        0       5       16             0 rtas_errd
[ 5233.951003] [ 1336]     0  1336      107        0       5       18             0 irqbalance
[ 5233.951008] [ 1338]     0  1338     1784        0       4       38             0 smartd
[ 5233.951012] [ 1339]     0  1339      118        2       4       38             0 systemd-logind
[ 5233.951017] [ 1340]    81  1340       98        1       6       22          -900 dbus-daemon
[ 5233.951022] [ 1348]   998  1348       95        0       4       33             0 chronyd
[ 5233.951027] [ 1353]     0  1353     4434        0       6       71             0 NetworkManager
[ 5233.951032] [ 1364]   999  1364     3652        0       5       80             0 polkitd
[ 5233.951037] [ 1635]     0  1635      505        2       5      272             0 dhclient
[ 5233.951041] [ 1646]     0  1646     1737        0       6       21             0 rhsmcertd
[ 5233.951046] [ 1686]    32  1686       74        0       4       31             0 rpcbind
[ 5233.951051] [ 1690]     0  1690      117        1       4       32             0 xinetd
[ 5233.951056] [ 1695]     0  1695      292        0       4       88         -1000 sshd
[ 5233.951061] [ 1722]     0  1722       75        0       4       22             0 rpc.rstatd
[ 5233.951066] [ 1730]    29  1730       85        2       4       32             0 rpc.statd
[ 5233.951071] [ 1769]     0  1769       83        0       4       28             0 rpc.idmapd
[ 5233.951076] [ 1775]     0  1775     1715        0       4       16             0 rpc.rquotad
[ 5233.951081] [ 1785]     0  1785     2772        1       7      131             0 smbd
[ 5233.951086] [ 1793]     0  1793       94        0       4       36             0 rpc.mountd
[ 5233.951090] [ 1817]     0  1817     2772        0       7      138             0 smbd
[ 5233.951095] [ 1860]     0  1860      404        0       4      107             0 master
[ 5233.951100] [ 1861]    89  1861      406        0       4      100             0 pickup
[ 5233.951104] [ 1862]    89  1862      407        0       4      100             0 qmgr
[ 5233.951109] [ 1934]     0  1934     1751        0       5       39             0 crond
[ 5233.951114] [ 1936]     0  1936       87        0       4       38             0 atd
[ 5233.951119] [ 1984]     0  1984     1845        2       8       79             0 login
[ 5233.951123] [ 2002]     0  2002     1707        1       6       10             0 agetty
[ 5233.951128] [ 2009]     0  2009     9275        0       8      121             0 STAFProc
[ 5233.951132] [ 2013]     0  2013       52        0       4       11             0 iprinit
[ 5233.951137] [ 2014]     0  2014       52        0       4       24             0 iprupdate
[ 5233.951142] [ 2019]     0  2019       61        0       3       21             0 sendStatus
[ 5233.951146] [ 2036]     0  2036      561        0       3       15             0 iprdump
[ 5233.951152] [ 2171]     0  2171   125132        0      34     1026             0 java
[ 5233.951157] [ 2327]     0  2327     1735        0       6       16             0 report_results
[ 5233.951162] [ 2395]     0  2395      407        0       5      135             0 sshd
[ 5233.951166] [ 2397] 10001  2397      410        0       5      140             0 sshd
[ 5233.951171] [ 2398] 10001  2398     1819        5       7       64             0 zsh
[ 5233.951178] [ 5626]     0  5626     1736        6       7       11             0 bash
[ 5233.951186] [12472]     0 12472     1704        0       6        9             0 sleep
[ 5233.951193] [13808] 10001 13808     1802        5       7       48             0 zsh
[ 5233.951197] [13828]     0 13828     1889        2       4       85             0 sudo
[ 5233.951202] [13829]     0 13829     1779        9       5       22             0 reboot
[ 5233.951207] [13830]     0 13830       77        1       4       22             0 systemd-tty-ask
[ 5233.951212] [13831]     0 13831       37        0       4        9             0 swapoff
[ 5233.951216] [13832]     0 13832       71        0       5       11             0 iprdump
[ 5233.951221] [13833]     0 13833       71        0       5       11             0 iprupdate
[ 5233.951226] [13834]     0 13834       71        0       5        9             0 abrt-install-cc
[ 5233.951234] [13835]     0 13835       66        0       3       13             0 systemd-cgroups
[ 5233.951239] [13836]     0 13836      197        0       4       93             0 (tas_errd)

