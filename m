Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3DBEG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:06:29 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46009 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3DBEG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:06:27 -0400
Date: Tue, 2 Apr 2013 00:06:24 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        linux-ext4@vger.kernel.org
Message-ID: <874841142.414482.1364875584266.JavaMail.root@redhat.com>
In-Reply-To: <87fvzaspr8.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org>
Subject: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
Thread-Index: XxAXKs9TrPCMlUs6Y9kzmw0IZf+xmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bisect indicated this is the culprit,

0e401101db49959f5783f6ee9e676124b5a183ac
ext4: fix memory leakage in mext_check_coverage

This following with Dmitry's debug patch applied,

CAI Qian

Ý  101.408610¨ ES cache assertation failed for inode: 753 es_cached ex Ý56/5/744
81/20¨ != found ex Ý56/5/3396400/0¨ retval 0 flags 5
Ý  209.858899¨ ES cache assertation failed for inode: 384 es_cached ex Ý57/7/332
82/20¨ != found ex Ý57/7/3396400/0¨ retval 0 flags 5
Ý  209.860656¨ ES cache assertation failed for inode: 384 es_cached ex Ý25/1/332
50/20¨ != found ex Ý25/1/0/0¨ retval 0 flags 0
Ý  209.893587¨ ES cache assertation failed for inode: 384 es_cached ex Ý22/1/332
47/20¨ != found ex Ý22/1/34838/1000¨ retval 1 flags 0
Ý  209.913482¨ ES cache assertation failed for inode: 384 es_cached ex Ý27/1/329
40/20¨ != found ex Ý27/1/0/0¨ retval 0 flags 0
Ý  209.919950¨ ES cache assertation failed for inode: 384 es_cached ex Ý59/5/338
48/20¨ != found ex Ý59/5/3396400/0¨ retval 0 flags 5
Ý  209.931856¨ ES cache assertation failed for inode: 384 es_cached ex Ý7/1/3292
0/20¨ != found ex Ý7/1/35879/20¨ retval 1 flags 43
Ý  209.969282¨ ES cache assertation failed for inode: 384 es_cached ex Ý35/1/361
97/20¨ != found ex Ý35/1/36197/1000¨ retval 1 flags 0
Ý  209.969290¨ ES cache assertation failed for inode: 384 es_cached ex Ý48/1/362
10/20¨ != found ex Ý48/1/0/0¨ retval 0 flags 0
Ý  209.980724¨ ES cache assertation failed for inode: 384 es_cached ex Ý13/4/334
89/20¨ != found ex Ý13/4/2161372/0¨ retval 0 flags 5
Ý  209.980744¨ ES cache assertation failed for inode: 384 es_cached ex Ý61/3/335
37/20¨ != found ex Ý61/3/3396400/0¨ retval 0 flags 5
Ý  209.983848¨ ES cache assertation failed for inode: 384 es_cached ex Ý44/2/335
20/20¨ != found ex Ý44/2/36216/20¨ retval 2 flags 43
Ý  210.020041¨ ES cache assertation failed for inode: 384 es_cached ex Ý61/3/341
91/20¨ != found ex Ý61/3/3396400/0¨ retval 0 flags 5
Ý  210.050100¨ ES cache assertation failed for inode: 384 es_cached ex Ý22/11/34
565/20¨ != found ex Ý22/11/3396400/0¨ retval 0 flags 5
Ý  210.053271¨ ES cache assertation failed for inode: 384 es_cached ex Ý15/1/334
90/20¨ != found ex Ý15/1/33579/1000¨ retval 1 flags 1
Ý  210.053275¨ mpage_da_submit_io failed block=33490 != b_blocknr=33579
Ý  210.053277¨ ino:384 lbkl:15, b_state=0x00001023, b_size=4096
Ý  210.053320¨ ------------Ý cut here ¨------------
Ý  210.053323¨ kernel BUG at fs/ext4/inode.c:1639!
Ý  210.053402¨ illegal operation: 0001 Ý#1¨ SMP
Ý  210.053405¨ Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast
 ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ipt
able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defra
g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tab
les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c dasd_fba_mod dasd_eck
d_mod lcs dasd_mod qeth ctcm qdio ccwgroup fsm dm_mirror dm_region_hash dm_log d
m_mod
Ý  210.053434¨ CPU: 0 Not tainted 3.8.0-rc3+ #16
Ý  210.053436¨ Process fsx (pid: 20565, task: 000000002c358000, ksp: 000000002c0
8f480)
Ý  210.053439¨ Krnl PSW : 0704f00180000000 00000000003033e8 (mpage_da_submit_io
0x3d4/0x408)
Ý  210.053450¨            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:3 PM:0 EA:
3
Krnl GPRS: 0000000000000015 0000000000000001 0000000000000030 00000000031b4508
Ý  210.053455¨            00000000003033e4 0000000000000000 0000000000001000 000
7ffff00001000
Ý  210.053457¨            000000002c08fa98 000003d100a8c6c0 000000002c08fb68 000
000000000000f
Ý  210.053460¨            00000000000082d2 000000002204d068 00000000003033e4 000
000002c08f970
Ý  210.053473¨ Krnl Code: 00000000003033d8: c02000215447        larl    %r2,72dc
66
           00000000003033de: c0e50016788f       brasl   %r14,5d24fc
          #00000000003033e4: a7f40001           brc     15,3033e6
          >00000000003033e8: a7f40001           brc     15,3033ea
           00000000003033ec: a7f40001           brc     15,3033ee
           00000000003033f0: 4120f0e8           la      %r2,232(%r15)
           00000000003033f4: a7180000           lhi     %r1,0
           00000000003033f8: 5010f0d8           st      %r1,216(%r15)
Ý  210.053497¨ Call Trace:
Ý  210.053498¨ (Ý<00000000003033e4>¨ mpage_da_submit_io+0x3d0/0x408)
Ý  210.053501¨  Ý<0000000000309a48>¨ mpage_da_map_and_submit+0x150/0x41c
Ý  210.053505¨  Ý<000000000030a212>¨ write_cache_pages_da+0x4fe/0x530
Ý  210.053509¨  Ý<000000000030a584>¨ ext4_da_writepages+0x340/0x628
Ý  210.053512¨  Ý<00000000002024d2>¨ __filemap_fdatawrite_range+0x6e/0x7c
Ý  210.053518¨  Ý<00000000002025fc>¨ filemap_write_and_wait_range+0x54/0x8c
Ý  210.053521¨  Ý<00000000002fe0f8>¨ ext4_sync_file+0x7c/0x3d8
Ý  210.053524¨  Ý<000000000023c932>¨ SyS_msync+0x14e/0x1d8
Ý  210.053528¨  Ý<00000000005de66e>¨ sysc_tracego+0x14/0x1a
Ý  210.053533¨  Ý<000003fffd0e1240>¨ 0x3fffd0e1240
Ý  210.053536¨ Last Breaking-Event-Address:
Ý  210.053537¨  Ý<00000000003033e4>¨ mpage_da_submit_io+0x3d0/0x408
Ý  210.053540¨
Ý  210.053542¨ ---Ý end trace f387176e9fcb98d0 ¨---
Ý  210.053546¨ ------------Ý cut here ¨------------
Ý  210.053548¨ WARNING: at kernel/exit.c:713
Ý  210.053550¨ Modules linked in: nf_conntrack_netbios_ns nf_conntrack_broadcast
 ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ipt
able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defra
g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tab
les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c dasd_fba_mod dasd_eck
d_mod lcs dasd_mod qeth ctcm qdio ccwgroup fsm dm_mirror dm_region_hash dm_log d
m_mod
Ý  210.053571¨ CPU: 0 Tainted: G      D      3.8.0-rc3+ #16
