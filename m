Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3CKCQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:16:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51206 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab3CKCQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:16:34 -0400
X-IronPort-AV: E=Sophos;i="4.84,820,1355068800"; 
   d="scan'208";a="6847018"
Message-ID: <513D3EA9.4010308@cn.fujitsu.com>
Date: Mon, 11 Mar 2013 10:17:13 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: gregkh@linuxfoundation.org
Subject: sysfs: Kernel OOPS  when install and remove modules
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 10:15:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 10:15:14,
	Serialize complete at 2013/03/11 10:15:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the below stack when I execute the shell program

#!/bin/bash

while :;
do
modprobe 8139too&
rmmod 8139too&
done

I trust it is not the problem of 8139too, the other modules have the same problems too.
Is this an already known problem?

[   53.328212] 8139too: 8139too Fast Ethernet driver 0.9.28
[   53.368029] 8139too: module is already loaded
[   53.456339] 8139too: 8139too Fast Ethernet driver 0.9.28
[   53.510611] 8139too: 8139too Fast Ethernet driver 0.9.28
[   53.551713] ------------[ cut here ]------------
[   53.551721] WARNING: at include/linux/kref.h:42 kobject_get+0x33/0x40()
[   53.551722] Hardware name: Bochs
[   53.551723] Modules linked in: 8139too(+) ebtable_nat ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat
iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter bnep ebtables bluetooth rfkill ip6table_filter ip6_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4
cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device
snd_pcm snd_page_alloc snd_timer microcode snd i2c_piix4 virtio_balloon 8139cp soundcore mii i2c_core uinput [last unloaded: 8139too]
[   53.551757] Pid: 1158, comm: modprobe Not tainted 3.6.10-4.fc18.x86_64 #1
[   53.551758] Call Trace:
[   53.551763]  [<ffffffff8105c8df>] warn_slowpath_common+0x7f/0xc0
[   53.551766]  [<ffffffff8105c93a>] warn_slowpath_null+0x1a/0x20
[   53.551768]  [<ffffffff812de3a3>] kobject_get+0x33/0x40
[   53.551770]  [<ffffffff812df1c0>] kset_find_obj+0x70/0x80
[   53.551774]  [<ffffffff810bfb38>] sys_init_module+0x1878/0x21f0
[   53.551776]  [<ffffffff812fb480>] ? ddebug_proc_open+0xd0/0xd0
[   53.551780]  [<ffffffff8162bae9>] system_call_fastpath+0x16/0x1b
[   53.551781] ---[ end trace 21e295d38d313e02 ]---
[   53.551783] 8139too: module is already loaded
[   53.581586] BUG: unable to handle kernel paging request at ffffffffa02f666c
[   53.581592] IP: [<ffffffff812de546>] kobject_del+0x16/0x40
[   53.581595] PGD 1c0d067 PUD 1c11063 PMD 3a085067 PTE 0
[   53.581596] Oops: 0002 [#1] SMP
[   53.581616] Modules linked in: 8139too(+) ebtable_nat ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat
iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter bnep ebtables bluetooth rfkill ip6table_filter ip6_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4
cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device
snd_pcm snd_page_alloc snd_timer microcode snd i2c_piix4 virtio_balloon 8139cp soundcore mii i2c_core uinput [last unloaded: 8139too]
[   53.581619] CPU 0
[   53.581619] Pid: 1158, comm: modprobe Tainted: G        W    3.6.10-4.fc18.x86_64 #1 Bochs Bochs
[   53.581621] RIP: 0010:[<ffffffff812de546>]  [<ffffffff812de546>] kobject_del+0x16/0x40
[   53.581622] RSP: 0018:ffff88003d747de8  EFLAGS: 00010296
[   53.581623] RAX: 0000000000002000 RBX: ffffffffa02f6630 RCX: 0000000000000036
[   53.581624] RDX: ffff88003ab738d8 RSI: ffff88003da87448 RDI: ffff880036f7de70
[   53.581624] RBP: ffff88003d747df8 R08: 0000000000000000 R09: ffff88003fbe8fe8
[   53.581625] R10: 000000000000003c R11: 0000000000000000 R12: ffffffff81c2fba0
[   53.581625] R13: ffff88003caf1b48 R14: ffffffffa02f6630 R15: 00000000ffffffea
[   53.581628] FS:  00007ff06f76d740(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   53.581629] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   53.581630] CR2: ffffffffa02f666c CR3: 0000000039f3f000 CR4: 00000000000006f0
[   53.581634] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   53.581639] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   53.581640] Process modprobe (pid: 1158, threadinfo ffff88003d746000, task ffff88003c52dc40)
[   53.581640] Stack:
[   53.581642]  ffff88003d747e48 ffffffffa02f6630 ffff88003d747e28 ffffffff812de5d2
[   53.581643]  ffff88003d747e58 ffffffffa02f6630 ffffffffa00635f8 ffffffffa0063818
[   53.581644]  ffff88003d747e48 ffffffff812de47b 000000000000000a ffffffffa00635e0
[   53.581645] Call Trace:
[   53.581648]  [<ffffffff812de5d2>] kobject_cleanup+0x62/0x1b0
[   53.581650]  [<ffffffff812de47b>] kobject_put+0x2b/0x60
[   53.581653]  [<ffffffff810c01bb>] sys_init_module+0x1efb/0x21f0
[   53.581655]  [<ffffffff812fb480>] ? ddebug_proc_open+0xd0/0xd0
[   53.581658]  [<ffffffff8162bae9>] system_call_fastpath+0x16/0x1b
[   53.581670] Code: ff ff ff 48 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 22 e8 aa 48 f2 ff <80> 63 3c fd 48 89 df e8 7e ff ff ff 48 8b 7b 18
e8 f5 fe ff ff
[   53.581671] RIP  [<ffffffff812de546>] kobject_del+0x16/0x40
[   53.581672]  RSP <ffff88003d747de8>
[   53.581672] CR2: ffffffffa02f666c
[   53.581674] ---[ end trace 21e295d38d313e03 ]---

