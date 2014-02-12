Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaBLWRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:17:47 -0500
Received: from smtp3.Stanford.EDU ([171.67.219.83]:34736 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752552AbaBLWRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:17:45 -0500
Message-ID: <52FBF2F1.8040504@localhost>
Date: Wed, 12 Feb 2014 14:17:21 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-rt-users <linux-rt-users@vger.kernel.org>
CC: nando@ccrma.Stanford.EDU,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: 3.12.9-rt13: BUG: soft lockup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm seeing these BUGs with 3.12.9-rt13.... finally caught the messages. 
I was getting frozen machines with no traces left behind, this could 
possibly be it (see below - I have to retest with rt15)

-- Fernando


[771508.546420] BUG: soft lockup - CPU#5 stuck for 23s! [SweepSinVsUsm:1421]
[771508.546431] Modules linked in: bnep bluetooth fuse tun act_police 
cls_basic cls_flow cls_fw cls_u32 sch_fq_codel sch_tbf sch_prio sch_htb 
sch_hfsc sch_ingress sch_sfq nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss 
nfsv4 dns_resolver nfs lockd sunrpc fscache bridge stp llc xt_CHECKSUM 
ipt_rpfilter xt_statistic xt_CT xt_LOG xt_connlimit xt_realm xt_addrtype 
xt_comment xt_recent xt_nat ipt_ULOG ipt_MASQUERADE ipt_ECN 
ipt_CLUSTERIP ipt_ah xt_set ip_set nf_nat_tftp nf_nat_snmp_basic 
nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc 
nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda 
nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip 
nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp 
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns 
nf_conntrack_broadcast
[771508.546441]  nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp 
xt_TPROXY xt_time xt_TCPMSS xt_tcpmss xt_sctp xt_policy xt_pkttype 
xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport 
xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit 
xt_DSCP xt_dscp xt_dccp xt_connmark ebtable_nat xt_CLASSIFY ebtables 
xt_AUDIT xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 iptable_mangle nfnetlink ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack 
ip6table_filter ip6_tables hwmon_vid iTCO_wdt iTCO_vendor_support 
gpio_ich eeepc_wmi asus_wmi sparse_keymap rfkill snd_ice1712 snd_cs8427 
x86_pkg_temp_thermal snd_i2c snd_ice17xx_ak4xxx snd_ak4xxx_adda coretemp 
snd_mpu401_uart snd_rawmidi snd_ac97_codec kvm ac97_bus crct10dif_pclmul
[771508.546446]  crc32_pclmul snd_seq crc32c_intel snd_seq_device 
ghash_clmulni_intel snd_pcm microcode snd_page_alloc snd_timer snd 
serio_raw soundcore r8169 i2c_i801 lpc_ich mfd_core mii mei_me mei 
shpchp binfmt_misc usb_storage nouveau i2c_algo_bit drm_kms_helper ttm 
drm i2c_core mxm_wmi video wmi
[771508.546447] CPU: 5 PID: 1421 Comm: SweepSinVsUsm Tainted: G        W 
    3.12.9-301.rt13.1.fc20.ccrma.x86_64+rt #1
[771508.546447] Hardware name: System manufacturer System Product 
Name/P8Z77-M, BIOS 1406 07/19/2012
[771508.546447] task: ffff8804af8b8000 ti: ffff8807ab410000 task.ti: 
ffff8807ab410000
[771508.546449] RIP: 0010:[<ffffffff810dc60a>]  [<ffffffff810dc60a>] 
smp_call_function_many+0x2ca/0x330
[771508.546449] RSP: 0018:ffff8807ab411cf0  EFLAGS: 00000202
[771508.546450] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 
ffff8807fe2e9918
[771508.546450] RDX: 0000000000000001 RSI: 0000000000000400 RDI: 
0000000000000000
[771508.546450] RBP: ffff8807ab411d50 R08: ffff8807fe4e6108 R09: 
0000000000000010
[771508.546451] R10: ffff8807fe4e6108 R11: 0000000000000246 R12: 
0000000000000000
[771508.546451] R13: 0000000000000000 R14: 00000000000000df R15: 
ffffffff810432e4
[771508.546452] FS:  00007faf34514700(0000) GS:ffff8807fe480000(0000) 
knlGS:0000000000000000
[771508.546452] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[771508.546453] CR2: 00007faebb93d000 CR3: 00000006bafd8000 CR4: 
00000000001407e0
[771508.546453] Stack:
[771508.546454]  ffff8807fe4e6188 0000000100000000 00000000000660c0 
ffff8807ab411d60
[771508.546455]  ffffffff8105adb0 ffff8807fe5660c0 0000000000000202 
ffff880077268480
[771508.546456]  ffff880077268780 00007faebb93f000 00007faebafea000 
ffff880077268480
[771508.546456] Call Trace:
[771508.546458]  [<ffffffff8105adb0>] ? leave_mm+0x80/0x80
[771508.546459]  [<ffffffff8105af07>] native_flush_tlb_others+0x37/0x40
[771508.546460]  [<ffffffff8105b084>] flush_tlb_mm_range+0xb4/0x280
[771508.546461]  [<ffffffff81177173>] tlb_flush_mmu.part.50+0x33/0x90
[771508.546462]  [<ffffffff81177d15>] tlb_finish_mmu+0x55/0x60
[771508.546463]  [<ffffffff8117a072>] zap_page_range+0x112/0x150
[771508.546465]  [<ffffffff81176bc1>] SyS_madvise+0x381/0x7b0
[771508.546466]  [<ffffffff81696169>] system_call_fastpath+0x16/0x1b
[771508.546475] Code: 4d ea 24 00 3b 05 9f e5 c2 00 89 c2 0f 8d c3 fd ff 
ff 48 98 49 8b 4d 00 48 03 0c c5 e0 64 d0 81 f6 41 20 01 74 cb 0f 1f 00 
f3 90 <f6> 41 20 01 75 f8 eb be 0f b6 4d ac 48 8b 55 b8 44 89 ef 48 8b
