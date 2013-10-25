Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3JYQPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:15:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab3JYQPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:15:21 -0400
Date: Fri, 25 Oct 2013 14:15:55 -0200
From: Flavio Leitner <fbl@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: RIP: mem_cgroup_move_account+0xf4/0x290
Message-ID: <20131025161555.GA4398@plex.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While playing with guests and net-next kernel, I've triggered
this with some frequency.  Even Fedora 19 kernel reproduces.

It it a known issue?

Thanks,
fbl

[ 6790.349763] kvm: zapping shadow pages for mmio generation wraparound
[ 6792.283879] kvm: zapping shadow pages for mmio generation wraparound
[ 7535.654438] perf samples too long (2719 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 7535.665948] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 11.560 msecs
[ 7691.048392] virbr0: port 1(vnet0) entered disabled state
[ 7691.056281] device vnet0 left promiscuous mode
[ 7691.061674] virbr0: port 1(vnet0) entered disabled state
[ 7691.163363] BUG: unable to handle kernel paging request at 000060fbc0002a20
[ 7691.171145] IP: [<ffffffff8119dcb4>] mem_cgroup_move_account+0xf4/0x290
[ 7691.178574] PGD 0 
[ 7691.181042] Oops: 0000 [#1] SMP 
[ 7691.184761] Modules linked in: vhost_net vhost macvtap macvlan tun veth openvswitch xt_CHECKSUM nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 vxlan ip_tunnel gre libcrc32c ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw coretemp kvm_intel snd_hda_codec_realtek snd_hda_intel nfsd snd_hda_codec kvm auth_rpcgss nfs_acl snd_hwdep lockd snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc sunrpc snd_timer crc32c_intel i7core_edac bnx2 shpchp ptp snd iTCO_wdt joydev pps_core iTCO_vendor_support pcspkr soundcore microcode serio_raw lpc_ich edac_core mfd_core i2c_i801 acpi_cpufreq hid_logitech_dj nouveau ata_generic pata_acpi video i2c_algo_bit drm_kms_helper ttm drm mxm_wmi i2c_core pata_marvell wmi [last unloaded: openvswitch]
[ 7691.285989] CPU: 1 PID: 14 Comm: kworker/1:0 Tainted: G          I  3.12.0-rc6-01188-gb45bd46 #1
[ 7691.295779] Hardware name:                  /DX58SO, BIOS SOX5810J.86A.5599.2012.0529.2218 05/29/2012
[ 7691.306066] Workqueue: events css_killed_work_fn
[ 7691.311303] task: ffff880429555dc0 ti: ffff88042957a000 task.ti: ffff88042957a000
[ 7691.319673] RIP: 0010:[<ffffffff8119dcb4>]  [<ffffffff8119dcb4>] mem_cgroup_move_account+0xf4/0x290
[ 7691.329728] RSP: 0018:ffff88042957bcc8  EFLAGS: 00010002
[ 7691.335747] RAX: 0000000000000246 RBX: ffff88042b17bc30 RCX: 0000000000000004
[ 7691.343720] RDX: ffff880424cd6000 RSI: 000060fbc0002a08 RDI: ffff880424cd622c
[ 7691.351735] RBP: ffff88042957bd20 R08: ffff880424cd4000 R09: 0000000000000001
[ 7691.359751] R10: 0000000000000001 R11: 0000000000000001 R12: ffffea00103ef0c0
[ 7691.367745] R13: ffff880424cd6000 R14: 0000000000000000 R15: ffff880424cd622c
[ 7691.375738] FS:  0000000000000000(0000) GS:ffff88043fc20000(0000) knlGS:0000000000000000
[ 7691.384755] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7691.391238] CR2: 000060fbc0002a20 CR3: 0000000001c0c000 CR4: 00000000000027e0
[ 7691.399235] Stack:
[ 7691.401672]  ffff88042957bce8 ffff88042957bce8 ffffffff81312b6d ffff880424cd4000
[ 7691.409968]  ffff880400000001 ffff880424cd6000 ffffea00103ef0c0 ffff880424cd0430
[ 7691.418264]  ffff88042b17bc30 ffffea00103ef0e0 ffff880424cd6000 ffff88042957bda8
[ 7691.426578] Call Trace:
[ 7691.429513]  [<ffffffff81312b6d>] ? list_del+0xd/0x30
[ 7691.435250]  [<ffffffff8119f5e7>] mem_cgroup_reparent_charges+0x247/0x460
[ 7691.442874]  [<ffffffff8119f9af>] mem_cgroup_css_offline+0xaf/0x1b0
[ 7691.449942]  [<ffffffff810da877>] offline_css+0x27/0x50
[ 7691.455874]  [<ffffffff810dcf8d>] css_killed_work_fn+0x2d/0xa0
[ 7691.462466]  [<ffffffff810821f5>] process_one_work+0x175/0x430
[ 7691.469041]  [<ffffffff81082e1b>] worker_thread+0x11b/0x3a0
[ 7691.475345]  [<ffffffff81082d00>] ? rescuer_thread+0x340/0x340
[ 7691.481919]  [<ffffffff81089860>] kthread+0xc0/0xd0
[ 7691.487478]  [<ffffffff810897a0>] ? insert_kthread_work+0x40/0x40
[ 7691.494352]  [<ffffffff8166ea3c>] ret_from_fork+0x7c/0xb0
[ 7691.500464]  [<ffffffff810897a0>] ? insert_kthread_work+0x40/0x40
[ 7691.507335] Code: 85 f6 48 8b 55 d0 44 8b 4d c8 4c 8b 45 c0 0f 85 b3 00 00 00 41 8b 4c 24 18 85 c9 0f 88 a6 00 00 00 48 8b b2 30 02 00 00 45 89 ca <4c> 39 56 18 0f 8c 36 01 00 00 44 89 c9 f7 d9 89 cf 65 48 01 7e 
[ 7691.528638] RIP  [<ffffffff8119dcb4>] mem_cgroup_move_account+0xf4/0x290
