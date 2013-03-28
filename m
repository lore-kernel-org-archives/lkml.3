Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3C1JoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:44:19 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60549 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab3C1JoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:44:17 -0400
Date: Thu, 28 Mar 2013 05:44:15 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-s390 <linux-s390@vger.kernel.org>, Steve Best <sbest@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Message-ID: <1878403449.7692080.1364463855313.JavaMail.root@redhat.com>
In-Reply-To: <356372233.7624880.1364452833412.JavaMail.root@redhat.com>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.66.13.149]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "CAI Qian" <caiqian@redhat.com>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "linux-s390" <linux-s390@vger.kernel.org>, "Steve Best" <sbest@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
> linux-ext4@vger.kernel.org
> Sent: Thursday, March 28, 2013 2:40:33 PM
> Subject: s390x: kernel BUG at fs/ext4/inode.c:1591!
> 
> System hung when running xfstests-dev 013 test case on an s390x
> guest. Never saw
> this on 3.9-rc3 before but need to double-check. Any idea?
Reproduced; bisect data so far,
# git bisect log
git bisect start
# good: [a937536b868b8369b98967929045f1df54234323] Linux 3.9-rc3
git bisect good a937536b868b8369b98967929045f1df54234323
# bad: [9064171268d838b8f283fe111ef086b9479d059a] Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes
git bisect bad 9064171268d838b8f283fe111ef086b9479d059a
# bad: [38d78e587d4960d0db94add518d27ee74bad2301] mqueue: sys_mq_open: do not call mnt_drop_write() if read-only
git bisect bad 38d78e587d4960d0db94add518d27ee74bad2301
> 
> CAI Qian
> 
> Ý 1113.795759¨ ------------Ý cut here ¨------------
> Ý 1113.795771¨ kernel BUG at fs/ext4/inode.c:1591!
> Ý 1113.795845¨ illegal operation: 0001 Ý#1¨ SMP
> Ý 1113.795848¨ Modules linked in: nf_conntrack_netbios_ns
> nf_conntrack_broadcast
>  ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6
>  nf_defrag_ipv6 ipt
> able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT
> nf_conntrack_ipv4 nf_defra
> g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables
> ip6table_filter ip6_tab
> les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c
> dasd_fba_mod dasd_eck
> d_mod dasd_mod lcs ctcm qeth fsm qdio ccwgroup dm_mirror
> dm_region_hash dm_log d
> m_mod
> Ý 1113.795880¨ CPU: 1 Not tainted 3.9.0-rc4+ #2
> Ý 1113.795882¨ Process flush-253:1 (pid: 12418, task:
> 0000000003f04890, ksp: 000
> 0000032eab3b8)
> Ý 1113.795885¨ Krnl PSW : 0704e00180000000 000000000030bc62
> (mpage_da_submit_io+
> 0x38e/0x3c0)
> Ý 1113.795895¨            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3
> CC:2 PM:0 EA:
> 3
> Krnl GPRS: 0000000001000000 000000001b5823a8 0000000000000010
> 000000001b5823a8
> Ý 1113.795900¨            0000000000000000 00000000000000af
> 0000000000001000 000
> 0000032eab9c8
> Ý 1113.795902¨            000003d10053bb40 0000000032eaba30
> 00000000000000a1 000
> 0000032eaba98
> Ý 1113.795905¨            00000000000100b0 00000000000000a1
> 000000000030b9a8 000
> 0000032eab8a0
> Ý 1113.795921¨ Krnl Code: 000000000030bc54: f0dca7f4fecf        srp
>     2036(14,
> %r10),3791(%r15),12
> 
>                                                             MORE...
>                                                               ZVM-RHTS
> ================================================================================
>            000000000030bc5a: a7f40001           brc     15,30bc5c
>           #000000000030bc5e: a7f40001           brc     15,30bc60
>           >000000000030bc62: a7f40001           brc     15,30bc64
>            000000000030bc66: a7f40001           brc     15,30bc68
>            000000000030bc6a: 4120f0e8           la      %r2,232(%r15)
>            000000000030bc6e: a7180000           lhi     %r1,0
> Ý 1113.796303¨ Call Trace:
> Ý 1113.796306¨ (Ý<000000000030b9a8>¨ mpage_da_submit_io+0xd4/0x3c0)
> Ý 1113.796311¨  Ý<000000000031204c>¨
> mpage_da_map_and_submit+0x150/0x41c
> Ý 1113.796314¨  Ý<0000000000312bac>¨ ext4_da_writepages+0x364/0x628
> Ý 1113.796317¨  Ý<00000000002a08c8>¨
> __writeback_single_inode+0x54/0x27c
> Ý 1113.796322¨  Ý<00000000002a2c6c>¨ writeback_sb_inodes+0x284/0x4d8
> Ý 1113.796325¨  Ý<00000000002a30b6>¨ wb_writeback+0x10e/0x374
> Ý 1113.796327¨  Ý<00000000002a3d22>¨ wb_do_writeback+0x102/0x2e0
> Ý 1113.796330¨  Ý<00000000002a3fa2>¨ bdi_writeback_thread+0xa2/0x270
> Ý 1113.796333¨  Ý<00000000001581b2>¨ kthread+0xda/0xe4
> Ý 1113.796338¨  Ý<0000000000629836>¨ kernel_thread_starter+0x6/0xc
> Ý 1113.796342¨  Ý<0000000000629830>¨ kernel_thread_starter+0x0/0xc
> Ý 1113.796345¨ Last Breaking-Event-Address:
> Ý 1113.796346¨  Ý<000000000030bc5e>¨ mpage_da_submit_io+0x38a/0x3c0
> Ý 1113.796349¨
> Ý 1113.796351¨ ---Ý end trace 45df5089b835470e ¨---
> Ý 1113.796365¨ ------------Ý cut here ¨------------
> Ý 1113.796367¨ WARNING: at kernel/exit.c:715
> Ý 1113.796369¨ Modules linked in: nf_conntrack_netbios_ns
> nf_conntrack_broadcast
>  ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6
>  nf_defrag_ipv6 ipt
> able_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT
> nf_conntrack_ipv4 nf_defra
> g_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables
> ip6table_filter ip6_tab
> les iptable_filter ip_tables sg qeth_l2 vmur xfs libcrc32c
> dasd_fba_mod dasd_eck
> d_mod dasd_mod lcs ctcm qeth fsm qdio ccwgroup dm_mirror
> dm_region_hash dm_log d
> m_mod
> Ý 1113.796393¨ CPU: 1 Tainted: G      D      3.9.0-rc4+ #2
> Ý 1113.796396¨ Process flush-253:1 (pid: 12418, task:
> 0000000003f04890, ksp: 000
> 0000032eab3b8)
> Ý 1113.796398¨ Krnl PSW : 0704e00180000000 0000000000133074
> (do_exit+0x54/0xab8)
> 
> Ý 1113.796404¨            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3
> CC:2 PM:0 EA:
> 3
> Krnl GPRS: 0000000000000015 0000000032eabb60 0000000032eabb68
> 0000000000000000
> Ý 1113.796408¨            0000000000133058 ffffffffffffffff
> 0000000000000001 00
> 
>                                                             MORE...
>                                                               ZVM-RHTS
> ================================================================================
> 0000032eab9c8
> Ý 1113.796411¨            0704e00180000000 000000000030bc62
> 0000000003f04890 000
> 0000000778d38
> Ý 1113.796413¨            000000000000000b 0000000000634140
> 0000000000133058 000
> 0000032eab4a0
> Ý 1113.796423¨ Krnl Code: 0000000000133066: e32010080020        cg
>      %r2,8(%r
> 1)
>            000000000013306c: a78403fa           brc     8,133860
>           #0000000000133070: a7f40001           brc     15,133072
>           >0000000000133074: e31003180004       lg      %r1,792
>            000000000013307a: 5810101c           l       %r1,28(%r1)
>            000000000013307e: c01b01ffff00       nilf    %r1,33554176
>            0000000000133084: a7740481           brc     7,133986
>            0000000000133088: e310a2bc0012       lt      %r1,700(%r10)
> Ý 1113.796447¨ Call Trace:
> Ý 1113.796449¨ (Ý<0000000000133058>¨ do_exit+0x38/0xab8)
> Ý 1113.796451¨  Ý<0000000000100ea4>¨ die+0x158/0x180
> Ý 1113.796455¨  Ý<00000000006291fa>¨ do_trap+0x1a2/0x1a4
> Ý 1113.796459¨  Ý<00000000006293ac>¨ illegal_op+0xfc/0x144
> Ý 1113.796462¨  Ý<0000000000629974>¨ pgm_check_handler+0x138/0x13c
> Ý 1113.796464¨  Ý<000000000030bc62>¨ mpage_da_submit_io+0x38e/0x3c0
> Ý 1113.796467¨ (Ý<000000000030b9a8>¨ mpage_da_submit_io+0xd4/0x3c0)
> Ý 1113.796470¨  Ý<000000000031204c>¨
> mpage_da_map_and_submit+0x150/0x41c
> Ý 1113.796472¨  Ý<0000000000312bac>¨ ext4_da_writepages+0x364/0x628
> Ý 1113.829664¨  Ý<00000000002a08c8>¨
> __writeback_single_inode+0x54/0x27c
> Ý 1113.829674¨  Ý<00000000002a2c6c>¨ writeback_sb_inodes+0x284/0x4d8
> Ý 1113.829681¨  Ý<00000000002a30b6>¨ wb_writeback+0x10e/0x374
> Ý 1113.829691¨  Ý<00000000002a3d22>¨ wb_do_writeback+0x102/0x2e0
> Ý 1113.829706¨  Ý<00000000002a3fa2>¨ bdi_writeback_thread+0xa2/0x270
> Ý 1113.829715¨  Ý<00000000001581b2>¨ kthread+0xda/0xe4
> Ý 1113.829725¨  Ý<0000000000629836>¨ kernel_thread_starter+0x6/0xc
> Ý 1113.829736¨  Ý<0000000000629830>¨ kernel_thread_starter+0x0/0xc
> Ý 1113.829753¨ Last Breaking-Event-Address:
> Ý 1113.829759¨  Ý<0000000000133070>¨ do_exit+0x50/0xab8
> Ý 1113.829771¨ ---Ý end trace 45df5089b835470f ¨---
