Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929Ab3DOFg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:36:27 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:37019 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933610Ab3DOFg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:36:26 -0400
Date: Mon, 15 Apr 2013 07:33:36 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel mlist <linux-kernel@vger.kernel.org>
Cc: linux-stable mlist <stable@kernel.org>
Subject: 3.0.60: general protection fault: 0000, Fixing recursive fault but
 reboot is needed
Message-ID: <20130415053336.GB1155@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 9561299 records (last update: 20130415)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 9561299 records (last update: 20130415)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 9561299 records (last update: 20130415)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

one of our servers keeps spitting GPF messages:
(sorry for long message)

[34110.179005] general protection fault: 0000 [#1] PREEMPT SMP=20
[34110.185000] CPU 0=20
[34110.186872] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler ip6t=
able_filter ip6_tables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM vhost_net macv=
tap macvlan tun virtio_net virtio virtio_ring kvm_intel kvm sch_htb xt_IMQ =
imq xt_physdev xt_comment ipt_REDIRECT xt_tcpudp xt_mark xt_multiport xt_co=
nntrack nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat nf_nat nf_co=
nntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables capi ipt_=
ULOG x_tables nfs lockd auth_rpcgss nfs_acl autofs4 sunrpc bridge stp llc i=
pv6 ext3 jbd kernelcapi avmfritz mISDNipac mISDN_core joydev processor ther=
mal_sys pcspkr ghes hed i7core_edac edac_core i2c_i801 i2c_core iTCO_wdt e1=
000e sg usbhid ext4 jbd2 crc16 sd_mod crc_t10dif ehci_hcd arcmsr scsi_mod b=
utton dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_msghandle=
r]
[34110.265159]=20
[34110.266744] Pid: 5628, comm: kavupdater Not tainted 3.0.60lb6.01 #1 Supe=
rmicro X8SIA/X8SIA
[34110.276854] RIP: 0010:[<ffffffff8115c730>]  [<ffffffff8115c730>] dup_fd+=
0x170/0x320
[34110.284698] RSP: 0018:ffff880230e2bd90  EFLAGS: 00010206
[34110.290251] RAX: 00000000000007f8 RBX: ffff880040fd9600 RCX: bffffffffff=
fffff
[34110.297470] RDX: 0000880233743f00 RSI: 00000000000000ff RDI: 00000000000=
00800
[34110.304687] RBP: ffff880230e2bde0 R08: ffff88003c25fe40 R09: 00000000000=
00003
[34110.311990] R10: 0000000000000001 R11: 4000000000000000 R12: ffff88003c0=
f2000
[34110.319286] R13: ffff88022e92b800 R14: ffff88003c25fa40 R15: 00000000000=
00100
[34110.326521] FS:  00007f2badf40700(0000) GS:ffff88023fc00000(0000) knlGS:=
0000000000000000
[34110.334819] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[34110.340651] CR2: 0000000001c5f710 CR3: 00000002300ef000 CR4: 00000000000=
026e0
[34110.348015] DR0: 00000000000000a0 DR1: 0000000000000000 DR2: 00000000000=
00003
[34110.355300] DR3: 00000000000000b0 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[34110.362560] Process kavupdater (pid: 5628, threadinfo ffff880230e2a000, =
task ffff880231c2c5f0)
[34110.371412] Stack:
[34110.373507]  0000000000000020 ffff880233753940 ffff880040fd9610 ffff8802=
2eb6a180
[34110.381260]  00007f2badf409d0 0000000001200011 ffff8800487245f0 00000000=
00000000
[34110.389065]  00007f2badf409d0 0000000000000000 ffff880230e2be80 ffffffff=
8104f77b
[34110.396941] Call Trace:
[34110.399478]  [<ffffffff8104f77b>] copy_process+0xd1b/0x13b0
[34110.405234]  [<ffffffff8102f410>] ? do_page_fault+0x1d0/0x480
[34110.411062]  [<ffffffff8104fe65>] do_fork+0x55/0x380
[34110.416126]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34110.422304]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34110.428621]  [<ffffffff81064f83>] ? set_current_blocked+0x53/0x60
[34110.434801]  [<ffffffff8100b358>] sys_clone+0x28/0x30
[34110.440000]  [<ffffffff813c10a3>] stub_clone+0x13/0x20
[34110.445253]  [<ffffffff813c0d82>] ? system_call_fastpath+0x16/0x1b
[34110.451584] Code: 7e 10 48 8b 71 10 4c 89 c2 e8 ed ba 0a 00 45 85 ff 74 =
71 41 8d 47 ff 31 f6 41 ba 01 00 00 00 48 8d 3c c5 08 00 00 00 31 c0 eb 15 =
<f0> 48 ff 42 48 49 89 14 04 48 83 c0 08 83 c6 01 48 39 f8 74 3b=20
[34110.475183] RIP  [<ffffffff8115c730>] dup_fd+0x170/0x320
[34110.480626]  RSP <ffff880230e2bd90>
[34110.484409] ---[ end trace 771117da60ee2556 ]---
[34110.489357] note: kavupdater[5628] exited with preempt_count 1
[34110.495660] BUG: sleeping function called from invalid context at kernel=
/rwsem.c:21
[34110.503891] in_atomic(): 1, irqs_disabled(): 0, pid: 5628, name: kavupda=
ter
[34110.511132] Pid: 5628, comm: kavupdater Tainted: G      D     3.0.60lb6.=
01 #1
[34110.518657] Call Trace:
[34110.521436]  [<ffffffff8103e278>] __might_sleep+0xe8/0x110
[34110.527216]  [<ffffffff813bef54>] down_read+0x24/0x40
[34110.532527]  [<ffffffff810985b8>] acct_collect+0x48/0x1b0
[34110.538133]  [<ffffffff810559c6>] do_exit+0x836/0x8a0
[34110.543404]  [<ffffffff813c01c7>] ? _raw_spin_unlock_irqrestore+0x47/0x50
[34110.550416]  [<ffffffff81051252>] ? kmsg_dump+0xd2/0x110
[34110.555940]  [<ffffffff81005a01>] oops_end+0x81/0xb0
[34110.561152]  [<ffffffff81005b3b>] die+0x5b/0x90
[34110.565875]  [<ffffffff81003562>] do_general_protection+0x162/0x170
[34110.572322]  [<ffffffff813c07a5>] general_protection+0x25/0x30
[34110.578358]  [<ffffffff8115c730>] ? dup_fd+0x170/0x320
[34110.583677]  [<ffffffff8104f77b>] copy_process+0xd1b/0x13b0
[34110.589446]  [<ffffffff8102f410>] ? do_page_fault+0x1d0/0x480
[34110.595380]  [<ffffffff8104fe65>] do_fork+0x55/0x380
[34110.600539]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34110.606821]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34110.613110]  [<ffffffff81064f83>] ? set_current_blocked+0x53/0x60
[34110.619393]  [<ffffffff8100b358>] sys_clone+0x28/0x30
[34110.624670]  [<ffffffff813c10a3>] stub_clone+0x13/0x20
[34110.630012]  [<ffffffff813c0d82>] ? system_call_fastpath+0x16/0x1b
[34110.636449] BUG: scheduling while atomic: kavupdater/5628/0x10000002
[34110.642956] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler ip6t=
able_filter ip6_tables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM vhost_net macv=
tap macvlan tun virtio_net virtio virtio_ring kvm_intel kvm sch_htb xt_IMQ =
imq xt_physdev xt_comment ipt_REDIRECT xt_tcpudp xt_mark xt_multiport xt_co=
nntrack nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat nf_nat nf_co=
nntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables capi ipt_=
ULOG x_tables nfs lockd auth_rpcgss nfs_acl autofs4 sunrpc bridge stp llc i=
pv6 ext3 jbd kernelcapi avmfritz mISDNipac mISDN_core joydev processor ther=
mal_sys pcspkr ghes hed i7core_edac edac_core i2c_i801 i2c_core iTCO_wdt e1=
000e sg usbhid ext4 jbd2 crc16 sd_mod crc_t10dif ehci_hcd arcmsr scsi_mod b=
utton dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_msghandle=
r]
[34110.724767] Pid: 5628, comm: kavupdater Tainted: G      D     3.0.60lb6.=
01 #1
[34110.732100] Call Trace:
[34110.734665]  [<ffffffff81043606>] __schedule_bug+0x66/0x70
[34110.740338]  [<ffffffff813bd324>] __schedule+0x914/0x9d0
[34110.745797]  [<ffffffff811385ab>] ? mem_cgroup_update_page_stat+0xfb/0x1=
90
[34110.752911]  [<ffffffff8104a3ca>] __cond_resched+0x2a/0x40
[34110.758588]  [<ffffffff813bd470>] _cond_resched+0x30/0x40
[34110.764231]  [<ffffffff8110e947>] unmap_vmas+0x5c7/0x860
[34110.769791]  [<ffffffff81005db5>] ? print_context_stack+0x85/0x140
[34110.776167]  [<ffffffff81051c12>] ? vprintk+0x312/0x4a0
[34110.781585]  [<ffffffff81110f56>] exit_mmap+0x96/0x140
[34110.786938]  [<ffffffff8104e3a4>] mmput+0x74/0x150
[34110.791925]  [<ffffffff8105335b>] exit_mm+0x12b/0x170
[34110.797133]  [<ffffffff810552f6>] do_exit+0x166/0x8a0
[34110.802361]  [<ffffffff813c01c7>] ? _raw_spin_unlock_irqrestore+0x47/0x50
[34110.809341]  [<ffffffff81051252>] ? kmsg_dump+0xd2/0x110
[34110.814873]  [<ffffffff81005a01>] oops_end+0x81/0xb0
[34110.820063]  [<ffffffff81005b3b>] die+0x5b/0x90
[34110.824838]  [<ffffffff81003562>] do_general_protection+0x162/0x170
[34110.831303]  [<ffffffff813c07a5>] general_protection+0x25/0x30
[34110.837344]  [<ffffffff8115c730>] ? dup_fd+0x170/0x320
[34110.842712]  [<ffffffff8104f77b>] copy_process+0xd1b/0x13b0
[34110.848470]  [<ffffffff8102f410>] ? do_page_fault+0x1d0/0x480
[34110.854348]  [<ffffffff8104fe65>] do_fork+0x55/0x380
[34110.859462]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34110.865676]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34110.871888]  [<ffffffff81064f83>] ? set_current_blocked+0x53/0x60
[34110.878182]  [<ffffffff8100b358>] sys_clone+0x28/0x30
[34110.883435]  [<ffffffff813c10a3>] stub_clone+0x13/0x20
[34110.888793]  [<ffffffff813c0d82>] ? system_call_fastpath+0x16/0x1b
[34110.895360] general protection fault: 0000 [#2] PREEMPT SMP=20
[34110.901297] CPU 1=20
[34110.903175] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler ip6t=
able_filter ip6_tables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM vhost_net macv=
tap macvlan tun virtio_net virtio virtio_ring kvm_intel kvm sch_htb xt_IMQ =
imq xt_physdev xt_comment ipt_REDIRECT xt_tcpudp xt_mark xt_multiport xt_co=
nntrack nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat nf_nat nf_co=
nntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables capi ipt_=
ULOG x_tables nfs lockd auth_rpcgss nfs_acl autofs4 sunrpc bridge stp llc i=
pv6 ext3 jbd kernelcapi avmfritz mISDNipac mISDN_core joydev processor ther=
mal_sys pcspkr ghes hed i7core_edac edac_core i2c_i801 i2c_core iTCO_wdt e1=
000e sg usbhid ext4 jbd2 crc16 sd_mod crc_t10dif ehci_hcd arcmsr scsi_mod b=
utton dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_msghandle=
r]
[34110.980682]=20
[34110.982267] Pid: 5628, comm: kavupdater Tainted: G      D     3.0.60lb6.=
01 #1 Supermicro X8SIA/X8SIA
[34110.991724] RIP: 0010:[<ffffffff8113de59>]  [<ffffffff8113de59>] filp_cl=
ose+0x19/0x90
[34110.999751] RSP: 0018:ffff880230e2bb18  EFLAGS: 00010286
[34111.005145] RAX: ffff88022e92bff8 RBX: 0000000000000003 RCX: 00000000000=
00000
[34111.012362] RDX: ffff88022eb63040 RSI: ffff88022eb6a100 RDI: 00008802337=
43f00
[34111.019613] RBP: ffff880230e2bb38 R08: 00007ffffffff000 R09: 00000000000=
00000
[34111.026866] R10: 0000000000000040 R11: ffff880059f5bbc8 R12: 00000000000=
00001
[34111.034082] R13: ffff880233753940 R14: ffff88022eb6a100 R15: 00000000000=
000ff
[34111.041300] FS:  00007f2badf40700(0000) GS:ffff88023fc40000(0000) knlGS:=
0000000000000000
[34111.049555] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[34111.055422] CR2: 00007f7e4376e000 CR3: 000000022fae9000 CR4: 00000000000=
026e0
[34111.062638] DR0: 00000000000000a0 DR1: 0000000000000000 DR2: 00000000000=
00003
[34111.069854] DR3: 00000000000000b0 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[34111.077063] Process kavupdater (pid: 5628, threadinfo ffff880230e2a000, =
task ffff880231c2c5f0)
[34111.085801] Stack:
[34111.087896]  00000001000015fc 0000000000000003 0000000000000001 ffff8802=
33753940
[34111.095624]  ffff880230e2bb88 ffffffff810535b7 0000000000008573 00000000=
00000000
[34111.103429]  ffff88022eb6a100 ffff880231c2c5f0 ffff88022eb6a100 ffff8802=
31c2cbc8
[34111.111156] Call Trace:
[34111.113686]  [<ffffffff810535b7>] put_files_struct+0x97/0x120
[34111.119516]  [<ffffffff81053692>] exit_files+0x52/0x60
[34111.124742]  [<ffffffff8105531e>] do_exit+0x18e/0x8a0
[34111.129874]  [<ffffffff813c01c7>] ? _raw_spin_unlock_irqrestore+0x47/0x50
[34111.136746]  [<ffffffff81051252>] ? kmsg_dump+0xd2/0x110
[34111.142138]  [<ffffffff81005a01>] oops_end+0x81/0xb0
[34111.147182]  [<ffffffff81005b3b>] die+0x5b/0x90
[34111.151793]  [<ffffffff81003562>] do_general_protection+0x162/0x170
[34111.158145]  [<ffffffff813c07a5>] general_protection+0x25/0x30
[34111.164063]  [<ffffffff8115c730>] ? dup_fd+0x170/0x320
[34111.169283]  [<ffffffff8104f77b>] copy_process+0xd1b/0x13b0
[34111.175038]  [<ffffffff8102f410>] ? do_page_fault+0x1d0/0x480
[34111.180869]  [<ffffffff8104fe65>] do_fork+0x55/0x380
[34111.185913]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34111.192083]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34111.198263]  [<ffffffff81064f83>] ? set_current_blocked+0x53/0x60
[34111.204476]  [<ffffffff8100b358>] sys_clone+0x28/0x30
[34111.209606]  [<ffffffff813c10a3>] stub_clone+0x13/0x20
[34111.214833]  [<ffffffff813c0d82>] ? system_call_fastpath+0x16/0x1b
[34111.221096] Code: 4c 8b 6d f8 c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 =
55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 4c 89 6d f8 66 66 66 66 90=
=20
[34111.236734]  8b 47 48 48 89 fb 49 89 f4 48 85 c0 74 55 48 8b 47 20 48 85=
=20
[34111.245196] RIP  [<ffffffff8113de59>] filp_close+0x19/0x90
[34111.250855]  RSP <ffff880230e2bb18>
[34111.254733] ---[ end trace 771117da60ee2557 ]---
[34111.259518] Fixing recursive fault but reboot is needed!
[34111.264954] BUG: scheduling while atomic: kavupdater/5628/0x00000002
[34111.271504] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler ip6t=
able_filter ip6_tables ipt_MASQUERADE ipt_REJECT xt_CHECKSUM vhost_net macv=
tap macvlan tun virtio_net virtio virtio_ring kvm_intel kvm sch_htb xt_IMQ =
imq xt_physdev xt_comment ipt_REDIRECT xt_tcpudp xt_mark xt_multiport xt_co=
nntrack nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat nf_nat nf_co=
nntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables capi ipt_=
ULOG x_tables nfs lockd auth_rpcgss nfs_acl autofs4 sunrpc bridge stp llc i=
pv6 ext3 jbd kernelcapi avmfritz mISDNipac mISDN_core joydev processor ther=
mal_sys pcspkr ghes hed i7core_edac edac_core i2c_i801 i2c_core iTCO_wdt e1=
000e sg usbhid ext4 jbd2 crc16 sd_mod crc_t10dif ehci_hcd arcmsr scsi_mod b=
utton dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ipmi_msghandle=
r]
[34111.356102] Pid: 5628, comm: kavupdater Tainted: G      D     3.0.60lb6.=
01 #1
[34111.363440] Call Trace:
[34111.366129]  [<ffffffff81043606>] __schedule_bug+0x66/0x70
[34111.371843]  [<ffffffff813bd324>] __schedule+0x914/0x9d0
[34111.377397]  [<ffffffff81051c12>] ? vprintk+0x312/0x4a0
[34111.382864]  [<ffffffff813bc55d>] ? printk+0x41/0x44
[34111.388110]  [<ffffffff813bd58f>] schedule+0x3f/0x60
[34111.393426]  [<ffffffff81055896>] do_exit+0x706/0x8a0
[34111.398713]  [<ffffffff81051252>] ? kmsg_dump+0xd2/0x110
[34111.404246]  [<ffffffff81005a01>] oops_end+0x81/0xb0
[34111.409430]  [<ffffffff81005b3b>] die+0x5b/0x90
[34111.414197]  [<ffffffff81003562>] do_general_protection+0x162/0x170
[34111.420690]  [<ffffffff813c07a5>] general_protection+0x25/0x30
[34111.426725]  [<ffffffff8113de59>] ? filp_close+0x19/0x90
[34111.432284]  [<ffffffff8113dea3>] ? filp_close+0x63/0x90
[34111.437764]  [<ffffffff810535b7>] put_files_struct+0x97/0x120
[34111.443752]  [<ffffffff81053692>] exit_files+0x52/0x60
[34111.449098]  [<ffffffff8105531e>] do_exit+0x18e/0x8a0
[34111.454352]  [<ffffffff813c01c7>] ? _raw_spin_unlock_irqrestore+0x47/0x50
[34111.461352]  [<ffffffff81051252>] ? kmsg_dump+0xd2/0x110
[34111.466897]  [<ffffffff81005a01>] oops_end+0x81/0xb0
[34111.472093]  [<ffffffff81005b3b>] die+0x5b/0x90
[34111.476852]  [<ffffffff81003562>] do_general_protection+0x162/0x170
[34111.483305]  [<ffffffff813c07a5>] general_protection+0x25/0x30
[34111.489365]  [<ffffffff8115c730>] ? dup_fd+0x170/0x320
[34111.494732]  [<ffffffff8104f77b>] copy_process+0xd1b/0x13b0
[34111.500540]  [<ffffffff8102f410>] ? do_page_fault+0x1d0/0x480
[34111.506529]  [<ffffffff8104fe65>] do_fork+0x55/0x380
[34111.511794]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34111.518172]  [<ffffffff813c014e>] ? _raw_spin_unlock_irq+0xe/0x40
[34111.524487]  [<ffffffff81064f83>] ? set_current_blocked+0x53/0x60
[34111.530824]  [<ffffffff8100b358>] sys_clone+0x28/0x30
[34111.536117]  [<ffffffff813c10a3>] stub_clone+0x13/0x20
[34111.541494]  [<ffffffff813c0d82>] ? system_call_fastpath+0x16/0x1b

Could somebody please give me a hint on how could I find culprit of this?
what is weird is that kavupdater is just shell script..

I'd be grateful for any help

thanks a lot in advance

BR

nik

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlFrkTAACgkQ3xdJJrLygV68awCaA85hSEAvtyIG+jKbX2K+cbDf
fZ8Amwaa7QZ58YLRGP+cGW2tZDaeRL8v
=VU2S
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
