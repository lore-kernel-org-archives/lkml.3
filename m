Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3EVIkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:40:06 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:43416 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3EVIkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:40:00 -0400
Date: Wed, 22 May 2013 04:39:58 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: xfs@oss.sgi.com, stable@vger.kernel.org
Message-ID: <1805266998.4499261.1369211998387.JavaMail.root@redhat.com>
In-Reply-To: <40971621.4497871.1369211701112.JavaMail.root@redhat.com>
Subject: 3.9.2: xfstests triggered panic
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.2: xfstests triggered panic
Thread-Index: SAHC0wroGuqbIoKf+9YGsuTDL+slZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reproduced on almost all s390x guests by running xfstests.

14634.396658¨ XFS (dm-1): Mounting Filesystem 
14634.525522¨ XFS (dm-1): Ending clean mount 
14640.413007¨  <000000000017c6d4>¨ idle_balance+0x1a0/0x340 
14640.413010¨  <000000000063303e>¨ __schedule+0xa22/0xaf0 
14640.428279¨  <0000000000630da6>¨ schedule_timeout+0x186/0x2c0 
14640.428289¨  <00000000001cf864>¨ rcu_gp_kthread+0x1bc/0x298 
14640.428300¨  <0000000000158c5a>¨ kthread+0xe6/0xec 
14640.428304¨  <0000000000634de6>¨ kernel_thread_starter+0x6/0xc 
14640.428308¨  <0000000000634de0>¨ kernel_thread_starter+0x0/0xc 
14640.428311¨ Last Breaking-Event-Address: 
14640.428314¨  <000000000016bd76>¨ walk_tg_tree_from+0x3a/0xf4 
14640.428319¨  list_add corruption. next->prev should be prev (0000000000000918 
), but was           (null). (next=          (null)). 
14640.508240¨ ------------�  cut here ¨------------ 
14640.508256¨ WARNING: at lib/list_debug.c:29 
14640.508259¨ Modules linked in: binfmt_misc(F) tun(F) ipt_ULOG(F) af_802154(F) 
 scsi_transport_iscsi(F) af_iucv(F) af_key(F) nfc(F) rds(F) atm(F) btrfs(F) zlib 
_deflate(F) raid6_pq(F) xor(F) vfat(F) fat(F) nfsv3(F) nfs_acl(F) nfs(F) lockd(F 
) sunrpc(F) fscache(F) nfnetlink_log(F) nfnetlink(F) arc4(F) md4(F) nls_utf8(F) 
cifs(F) dns_resolver(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F) s 
ctp(F) fuse(F) nf_conntrack_netbios_ns(F) nf_conntrack_broadcast(F) ipt_MASQUERA 
DE(F) ip6table_nat(F) nf_nat_ipv6(F) ip6table_mangle(F) ip6t_REJECT(F) nf_conntr 
ack_ipv6(F) nf_defrag_ipv6(F) iptable_nat(F) nf_nat_ipv4(F) nf_nat(F) iptable_ma 
ngle(F) ipt_REJECT(F) nf_conntrack_ipv4(F) nf_defrag_ipv4(F) xt_conntrack(F) nf_ 
conntrack(F) ebtable_filter(F) ebtables(F) ip6table_filter(F) ip6_tables(F) ipta 
ble_filter(F) ip_tables(F) sg(F) qeth_l2(F) vmur(F) xfs(F) libcrc32c(F) dasd_fba 
_mod(F) dasd_eckd_mod(F) dasd_mod(F) qeth(F) qdio(F) lcs(F) ctcm(F) ccwgroup(F) 
fsm(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) � last unloaded: brd¨ 
14640.508358¨ CPU: 0 Tainted: GF     D      3.9.2 #1 
14640.508361¨ Process rcu_sched (pid: 10, task: 000000003ffc60c0, ksp: 00000000 
3ffe3ba0) 
14640.508363¨ Krnl PSW : 0404c00180000000 0000000000426544 (__list_add+0xd0/0xd 
4) 
14640.508378¨            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA: 
3 
Krnl GPRS: 0000000000000002 0400000000a0a500 0000000000000075 0000000000000000 
14640.508383¨            0000000000426540 00000000026af440 000000003da430a8 000 
0000000915c90 
14640.508385¨            00000000009cd800 00000000026b2800 0000000000915c90 000 
0000000000000 
14640.508388¨            0000000000000918 000000003da430d0 000000000 
14640.516392¨  � <0000000000634de6>¨ kernel_thread_starter+0x6/0xc 
14640.516395¨  � <0000000000634de0>¨ kernel_thread_starter+0x0/0xc 
14640.516398¨ Last Breaking-Event-Address: 
14640.516400¨  � <0000000000426544>¨ __list_add+0xd0/0xd4 
14640.516402¨ 
14640.516544¨ Kernel panic - not syncing: Fatal exception in interrupt 
00: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 0010F2AC

Sometimes, this pops up,
[16907.275002] WARNING: at kernel/rcutree.c:1960 

or this,
15316.154171¨ XFS (dm-1): Mounting Filesystem 
15316.255796¨ XFS (dm-1): Ending clean mount 
15320.364246¨            00000000006367a2: e310b0080004        lg      %r1,8(%r 
11) 
15320.364249¨            00000000006367a8: 41101010            la      %r1,16(% 
r1) 
15320.364251¨            00000000006367ac: e33010000004        lg      %r3,0(%r 
1) 
15320.364252¨ Call Trace: 
15320.364252¨ Last Breaking-Event-Address: 
15320.364253¨  � <0000000000000000>¨ Kernel stack overflow. 
15320.364308¨ CPU: 0 Tainted: GF       W    3.9.2 #1 
15320.364309¨ Process rhts-test-runne (pid: 625, task: 000000003dccc890, ksp: 0 
000000037433c78) 
15320.364310¨ Krnl PSW : 0404c00180000000 0000000000636796 (do_dat_exception+0x 
26/0x36c) 
15320.364315¨            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA: 
3 
15320.364316¨ Krnl GPRS: e500000000000000 0000000000014138 ffffffffffffffbf 000 
0000000901110 
15320.364317¨            00000000001a9fe6 0000000000124438 0000000000020001 000 
0000000000001 
15320.364318¨            00000000000141d8 00000000001a9fe6 0000000000000044 000 
00000000141d8 
0000000014028 
15320.366500¨ Krnl Code: 000000000063678a: b9040082            lgr     %r8,%r2 
15320.366502¨            000000000063678e: a729ffbf            lghi    %r2,-65 
15320.366504¨           #0000000000636792: a7840001            brc     8,636794 
 
15320.366507¨           >0000000000636796: e310f0980024        stg     %r1,152( 
%r15) 
15320.366509¨            000000000063679c: e3b003100004        lg      %r11,784 
 
15320.366512¨            00000000006367a2: e310b0080004        lg      %r1,8(%r 
11) 
15320.366515¨            00000000006367a8: 41101010            la      %r1,16(% 
r1) 
15320.366518¨            00000000006367ac: e33010000004        lg      %r3,0(%r 
1) 
15320.366518¨ Call Trace: 
15320.366518¨ Last Breaking-Event-Address: 
15320.366519¨  � <0000000000000000>¨ Kernel stack overflow. 
15320.366541¨ CPU: 0 Tainted: GF       W    3.9.2 #1 
15320.366542¨ Process rhts-test-runne (pid: 625, task: 000000003dccc890, ksp: 0 
000000037433c78) 
15320.366543¨ Krnl PSW : 0404c00180000000 0000000000636796 (do_dat_exception+0x 
26/0x36c) 
15320.366546¨            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA: 
3 
15320.366547¨ Krnl GPRS: e500000000000000 0000000000014138 ffffffffffffffbf 000 
0000000901110 
15320.366548¨            00000000001a9fe6 0000000000124438 0000000000020001 000 
0000000000001 
15320.366549¨            00000000000141d8 00000000001a9fe6 0000000000000044 000 
00000000141d8 
15320.366550¨            0000000037430000 000000000063df78 0000000000634f24 000 
0000000014028 
15320.366557¨ Krnl Code: 000000000063678a: b9040082            lgr     %r8,%r2 
15320.366560¨            000000000063678e: a729ffbf 

CAI Qian
