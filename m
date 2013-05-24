Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab3EXA5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 20:57:52 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:53148 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757921Ab3EXA5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 20:57:50 -0400
Message-ID: <519EBB05.1050804@free.fr>
Date: Fri, 24 May 2013 02:57:41 +0200
From: laurent.jourden@free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel Oops on xfrm_output_resume
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I don't know how to handle this, not a lkml subscriber, just reporting 
this bug to the devs.
All 3.9.y kernels crash after about 6 to 9 hours running without error 
messages before the Oops. I'm running 3.8.13 kernel so far without problem.

Even tried 3.10-rc2, same issue.

Context : two machines running with drbd block devices mirrored over 
ipsec. No Oops with kernels < 3.9.y

[29545.764401] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000020
[29545.764419] IP: [<ffffffff815cb873>] xfrm_output_resume+0x293/0x380
[29545.764433] PGD 0
[29545.764439] Oops: 0000 [#1] SMP
[29545.764446] Modules linked in: authenc esp4 xfrm4_mode_transport 
xt_sctp ip6t_REJECT nf_conntrack_ipv6 ip6table_raw ip6table_mangle 
ip6table_filter ip6_tables xt_TCPMSS act_police cls_basic cls_flow 
cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq 
bridge stp llc xt_statistic xt_CT xt_LOG xt_time xt_connlimit xt_realm 
xt_addrtype iptable_raw xt_comment xt_recent xt_policy xt_nat ipt_ULOG 
ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set ip_set 
nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp 
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp 
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip 
nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp 
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 
nf_conntrack_ftp xt_TPROXY nf_defrag_ipv6 nf_tproxy_core xt_tcpmss 
xt_pkttype xt_physdev xt_owner xt_NF
QUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit 
xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp 
xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp xt_state 
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables 
deflate ctr twofish_generic twofish_avx_x86_64 twofish_x86_64_3way 
twofish_x86_64 twofish_common camellia_generic camellia_aesni_avx_x86_64 
camellia_x86_64 cast5_avx_x86_64 cast5_generic cast_common des_generic 
xcbc rmd160 crypto_null af_key xfrm_algo ipv6 drbd lru_cache btrfs xor 
zlib_deflate raid6_pq libcrc32c crc32_pclmul crc32c_intel 
ghash_clmulni_intel
[29545.765130] CPU 3
[29545.765135] Pid: 3245, comm: drbd_r_bdata Not tainted 3.9.3-051922 
#14                  /DH67BL
[29545.765182] RIP: 0010:[<ffffffff815cb873>]  [<ffffffff815cb873>] 
xfrm_output_resume+0x293/0x380
[29545.765220] RSP: 0018:ffff8803faa21af0  EFLAGS: 00010246
[29545.765240] RAX: 0000000000000000 RBX: ffff8804071258f8 RCX: 
0000000000000770
[29545.765263] RDX: 000000000000076f RSI: ffff8803fe126000 RDI: 
ffff8804071258f8
[29545.765285] RBP: ffff8803faa21b18 R08: 000000000001a8f0 R09: 
ffffffffa0298313
[29545.765308] R10: ffffea000ff84980 R11: ffff88040e801300 R12: 
0000000000000000
[29545.765330] R13: ffff88040728b400 R14: ffff88040728b43c R15: 
0000000000000000
[29545.765353] FS:  0000000000000000(0000) GS:ffff88041f380000(0000) 
knlGS:0000000000000000
[29545.765388] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[29545.765409] CR2: 0000000000000020 CR3: 00000000017d2000 CR4: 
00000000000407e0
[29545.765432] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[29545.765454] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[29545.765477] Process drbd_r_bdata (pid: 3245, threadinfo 
ffff8803faa20000, task ffff880403791000)
[29545.765513] Stack:
[29545.765527]  0000000000000000 ffff8804071258f8 ffff8804071258f8 
ffff8804077cc89c
[29545.765563]  ffff88040751ec00 ffff8803faa21b28 ffffffff815cb96e 
ffff8803faa21b50
[29545.765599]  ffffffff815cb9a6 ffff8804071258f8 ffff8804071258f8 
ffffffff815c0aa0
[29545.765635] Call Trace:
[29545.765652]  [<ffffffff815cb96e>] xfrm_output2+0xe/0x10
[29545.765673]  [<ffffffff815cb9a6>] xfrm_output+0x36/0xe0
[29545.765694]  [<ffffffff815c0aa0>] ? xfrm4_extract_output+0xd0/0xd0
[29545.765717]  [<ffffffff815c0ac2>] xfrm4_output_finish+0x22/0x40
[29545.765738]  [<ffffffff815c0b26>] xfrm4_output+0x46/0x80
[29545.765760]  [<ffffffff81575100>] ip_local_out+0x20/0x30
[29545.765780]  [<ffffffff8157526a>] ip_queue_xmit+0x15a/0x3d0
[29545.765803]  [<ffffffff8158d636>] tcp_transmit_skb+0x406/0x920
[29545.765824]  [<ffffffff8158dd89>] tcp_write_xmit+0x189/0xaa0
[29545.765847]  [<ffffffff81534ae7>] ? __kmalloc_reserve.isra.53+0x37/0xa0
[29545.765870]  [<ffffffff8158e6f9>] __tcp_push_pending_frames+0x29/0x90
[29545.765892]  [<ffffffff8158f36a>] tcp_send_fin+0x6a/0x190
[29545.765913]  [<ffffffff8157de2e>] tcp_shutdown+0x5e/0x70
[29545.765934]  [<ffffffff815a7602>] inet_shutdown+0x92/0x130
[29545.765955]  [<ffffffff81529f6b>] kernel_sock_shutdown+0xb/0x10
[29545.765983]  [<ffffffffa015c89d>] drbd_free_sock+0x7d/0xb0 [drbd]
[29545.766008]  [<ffffffffa016f2b3>] conn_disconnect.part.48+0x49/0x444 
[drbd]
[29545.766035]  [<ffffffffa016f0f3>] ? conn_request_state+0x53/0x80 [drbd]
[29545.766061]  [<ffffffffa0151705>] drbdd_init+0x225/0x230 [drbd]
[29545.766087]  [<ffffffffa0158ae8>] drbd_thread_setup+0x58/0x130 [drbd]
[29545.766112]  [<ffffffffa0158a90>] ? drbd_open+0xa0/0xa0 [drbd]
[29545.766135]  [<ffffffff810a2f5b>] kthread+0xbb/0xc0
[29545.766155]  [<ffffffff810a2ea0>] ? kthread_create_on_node+0x120/0x120
[29545.766178]  [<ffffffff81606f3c>] ret_from_fork+0x7c/0xb0
[29545.766199]  [<ffffffff810a2ea0>] ? kthread_create_on_node+0x120/0x120
[29545.766221] Code: 00 48 85 ff 74 0f f0 ff 0f 0f 94 c0 84 c0 74 05 e8 
43 f7 b7 ff 48 8b 43 58 48 89 df 48 c7 83 98 00 00 00 00 00 00 00 48 83 
e0 fe <48> 8b 40 20 ff 50 60 83 f8 01 41 89 c4 0f 85 13 fe ff ff 48 8b
[29545.766324] RIP  [<ffffffff815cb873>] xfrm_output_resume+0x293/0x380
[29545.766346]  RSP <ffff8803faa21af0>
[29545.766363] CR2: 0000000000000020
[29545.766407] ---[ end trace 75eb563333dd96e1 ]---
[29545.991903] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000020
[29545.991964] IP: [<ffffffff815cb873>] xfrm_output_resume+0x293/0x380
[29545.991993] PGD 0
[29545.992014] Oops: 0000 [#2] SMP
[29545.992040] Modules linked in: authenc esp4 xfrm4_mode_transport 
xt_sctp ip6t_REJECT nf_conntrack_ipv6 ip6table_raw ip6table_mangle 
ip6table_filter ip6_tables xt_TCPMSS act_police cls_basic cls_flow 
cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq 
bridge stp llc xt_statistic xt_CT xt_LOG xt_time xt_connlimit xt_realm 
xt_addrtype iptable_raw xt_comment xt_recent xt_policy xt_nat ipt_ULOG 
ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set ip_set 
nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp 
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp 
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip 
nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp 
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 
nf_conntrack_ftp xt_TPROXY nf_defrag_ipv6 nf_tproxy_core xt_tcpmss 
xt_pkttype xt_physdev xt_owner xt_NF
QUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit 
xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp 
xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp xt_state 
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables 
deflate ctr twofish_generic twofish_avx_x86_64 twofish_x86_64_3way 
twofish_x86_64 twofish_common camellia_generic camellia_aesni_avx_x86_64 
camellia_x86_64 cast5_avx_x86_64 cast5_generic cast_common des_generic 
xcbc rmd160 crypto_null af_key xfrm_algo ipv6 drbd lru_cache btrfs xor 
zlib_deflate raid6_pq libcrc32c crc32_pclmul crc32c_intel 
ghash_clmulni_intel
[29545.992974] CPU 0
[29545.992981] Pid: 3290, comm: drbd_a_build Tainted: G      D 
3.9.3-051922 #14                  /DH67BL
[29545.993035] RIP: 0010:[<ffffffff815cb873>]  [<ffffffff815cb873>] 
xfrm_output_resume+0x293/0x380
[29545.993078] RSP: 0018:ffff8803faa0b810  EFLAGS: 00010246
[29545.993101] RAX: 0000000000000000 RBX: ffff8803faa4d8f8 RCX: 
00000001801c0006
[29545.993126] RDX: 00000001801c0007 RSI: 00000000801c0006 RDI: 
ffff8803faa4d8f8
[29545.993152] RBP: ffff8803faa0b838 R08: 0000000000000000 R09: 
0000000000000001
[29545.993177] R10: ffffea000ff61300 R11: ffff88040e801300 R12: 
0000000000000000
[29545.993202] R13: ffff88040728b400 R14: ffff88040728b43c R15: 
0000000000000000
[29545.993228] FS:  0000000000000000(0000) GS:ffff88041f200000(0000) 
knlGS:0000000000000000
[29545.993266] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[29545.993289] CR2: 0000000000000020 CR3: 00000000017d2000 CR4: 
00000000000407f0
[29545.993315] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[29545.993340] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[29545.993366] Process drbd_a_build (pid: 3290, threadinfo 
ffff8803faa0a000, task ffff8803fab02000)
[29545.993404] Stack:
[29545.993421]  0000000000000000 ffff8803faa4d8f8 ffff8803faa4d8f8 
ffff88040410709c
[29545.993470]  ffff8804074a6800 ffff8803faa0b848 ffffffff815cb96e 
ffff8803faa0b870
[29545.993519]  ffffffff815cb9a6 ffff8803faa4d8f8 ffff8803faa4d8f8 
ffffffff815c0aa0
[29545.993569] Call Trace:
[29545.993588]  [<ffffffff815cb96e>] xfrm_output2+0xe/0x10
[29545.993611]  [<ffffffff815cb9a6>] xfrm_output+0x36/0xe0
[29545.993635]  [<ffffffff815c0aa0>] ? xfrm4_extract_output+0xd0/0xd0
[29545.993660]  [<ffffffff815c0ac2>] xfrm4_output_finish+0x22/0x40
[29545.993684]  [<ffffffff815c0b26>] xfrm4_output+0x46/0x80
[29545.993708]  [<ffffffff81575100>] ip_local_out+0x20/0x30
[29545.993731]  [<ffffffff8157526a>] ip_queue_xmit+0x15a/0x3d0
[29545.993755]  [<ffffffff8158d636>] tcp_transmit_skb+0x406/0x920
[29545.993779]  [<ffffffff8158dd89>] tcp_write_xmit+0x189/0xaa0
[29545.993804]  [<ffffffff8158e6f9>] __tcp_push_pending_frames+0x29/0x90
[29545.993829]  [<ffffffff8157f3f6>] tcp_sendmsg+0x116/0xdc0
[29545.993853]  [<ffffffff8160358e>] ? schedule_timeout+0x12e/0x1b0
[29545.993877]  [<ffffffff815a7dde>] inet_sendmsg+0x5e/0xa0
[29545.993901]  [<ffffffff81530259>] ? release_sock+0x119/0x170
[29545.993925]  [<ffffffff8152bc6b>] sock_sendmsg+0xab/0xe0
[29545.993948]  [<ffffffff8158144e>] ? tcp_recvmsg+0x75e/0xcd0
[29545.993973]  [<ffffffff8152c06b>] kernel_sendmsg+0x3b/0x50
[29545.994001]  [<ffffffffa0159de5>] drbd_send+0x85/0x1b0 [drbd]
[29545.994029]  [<ffffffffa0159f1d>] drbd_send_all+0xd/0x30 [drbd]
[29545.994057]  [<ffffffffa0159fee>] __send_command.isra.32+0xae/0x170 
[drbd]
[29545.994086]  [<ffffffffa015a0e6>] conn_send_command+0x36/0x50 [drbd]
[29545.994115]  [<ffffffffa015a33f>] drbd_send_ping+0x3f/0x60 [drbd]
[29545.994143]  [<ffffffffa0151ac8>] drbd_asender+0x3b8/0x6f0 [drbd]
[29545.994168]  [<ffffffff813c8729>] ? snprintf+0x39/0x40
[29545.994195]  [<ffffffffa0158a90>] ? drbd_open+0xa0/0xa0 [drbd]
[29545.994223]  [<ffffffffa0158ae8>] drbd_thread_setup+0x58/0x130 [drbd]
[29545.994251]  [<ffffffffa0158a90>] ? drbd_open+0xa0/0xa0 [drbd]
[29545.994275]  [<ffffffff810a2f5b>] kthread+0xbb/0xc0
[29545.994298]  [<ffffffff810a2ea0>] ? kthread_create_on_node+0x120/0x120
[29545.994324]  [<ffffffff81606f3c>] ret_from_fork+0x7c/0xb0
[29545.994347]  [<ffffffff810a2ea0>] ? kthread_create_on_node+0x120/0x120
[29545.994372] Code: 00 48 85 ff 74 0f f0 ff 0f 0f 94 c0 84 c0 74 05 e8 
43 f7 b7 ff 48 8b 43 58 48 89 df 48 c7 83 98 00 00 00 00 00 00 00 48 83 
e0 fe <48> 8b 40 20 ff 50 60 83 f8 01 41 89 c4 0f 85 13 fe ff ff 48 8b
[29545.994653] RIP  [<ffffffff815cb873>] xfrm_output_resume+0x293/0x380
[29545.994681]  RSP <ffff8803faa0b810>
[29545.994701] CR2: 0000000000000020
[29545.994721] ---[ end trace 75eb563333dd96e2 ]---
[29546.502319] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000808
[29546.502364] IP: [<ffffffff8105ed79>] __ticket_spin_lock+0x9/0x30
[29546.502393] PGD 0
[29546.502416] Oops: 0002 [#3] SMP
[29546.502442] Modules linked in: authenc esp4 xfrm4_mode_transport 
xt_sctp ip6t_REJECT nf_conntrack_ipv6 ip6table_raw ip6table_mangle 
ip6table_filter ip6_tables xt_TCPMSS act_police cls_basic cls_flow 
cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq 
bridge stp llc xt_statistic xt_CT xt_LOG xt_time xt_connlimit xt_realm 
xt_addrtype iptable_raw xt_comment xt_recent xt_policy xt_nat ipt_ULOG 
ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set ip_set 
nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp 
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp 
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip 
nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp 
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 
nf_conntrack_ftp xt_TPROXY nf_defrag_ipv6 nf_tproxy_core xt_tcpmss 
xt_pkttype xt_physdev xt_owner xt_NF
QUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit 
xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp 
xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp xt_state 
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables 
deflate ctr twofish_generic twofish_avx_x86_64 twofish_x86_64_3way 
twofish_x86_64 twofish_common camellia_generic camellia_aesni_avx_x86_64 
camellia_x86_64 cast5_avx_x86_64 cast5_generic cast_common des_generic 
xcbc rmd160 crypto_null af_key xfrm_algo ipv6 drbd lru_cache btrfs xor 
zlib_deflate raid6_pq libcrc32c crc32_pclmul crc32c_intel 
ghash_clmulni_intel
[29546.503389] CPU 3
[29546.503397] Pid: 3251, comm: drbd_r_build Tainted: G      D 
3.9.3-051922 #14                  /DH67BL
[29546.503450] RIP: 0010:[<ffffffff8105ed79>]  [<ffffffff8105ed79>] 
__ticket_spin_lock+0x9/0x30
[29546.503493] RSP: 0018:ffff8803faa4fcf0  EFLAGS: 00010082
[29546.503516] RAX: 0000000000000100 RBX: 0000000000000082 RCX: 
0000000000000001
[29546.503541] RDX: ffff8803fab02000 RSI: 0000000000000082 RDI: 
0000000000000808
[29546.503566] RBP: ffff8803faa4fcf0 R08: 0000000000000000 R09: 
0000000000000000
[29546.503591] R10: 000000000000055f R11: 0000000000000000 R12: 
0000000000000002
[29546.503617] R13: 0000000000000000 R14: 0000000000000001 R15: 
0000000000000001
[29546.503643] FS:  0000000000000000(0000) GS:ffff88041f380000(0000) 
knlGS:0000000000000000
[29546.503680] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[29546.503704] CR2: 0000000000000808 CR3: 00000000017d2000 CR4: 
00000000000407e0
[29546.503729] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[29546.503754] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[29546.503780] Process drbd_r_build (pid: 3251, threadinfo 
ffff8803faa4e000, task ffff88040784a000)
[29546.503818] Stack:
[29546.503836]  ffff8803faa4fd00 ffffffff8105ee29 ffff8803faa4fd20 
ffffffff81606529
[29546.503885]  ffff8803fab02000 0000000000000002 ffff8803faa4fd58 
ffffffff81095238
[29546.503935]  ffff8803fe188b98 0000000000000002 0000000000000000 
0000000000000001
[29546.503984] Call Trace:
[29546.504004]  [<ffffffff8105ee29>] default_spin_lock_flags+0x9/0x10
[29546.504029]  [<ffffffff81606529>] _raw_spin_lock_irqsave+0x29/0x40
[29546.504055]  [<ffffffff81095238>] force_sig_info+0x38/0x100
[29546.504079]  [<ffffffff81095311>] force_sig+0x11/0x20
[29546.504106]  [<ffffffffa01596b3>] _drbd_thread_stop+0x93/0x100 [drbd]
[29546.504134]  [<ffffffffa016f2aa>] conn_disconnect.part.48+0x40/0x444 
[drbd]
[29546.504164]  [<ffffffffa016f0f3>] ? conn_request_state+0x53/0x80 [drbd]
[29546.504193]  [<ffffffffa0151705>] drbdd_init+0x225/0x230 [drbd]
[29546.504221]  [<ffffffffa0158a90>] ? drbd_open+0xa0/0xa0 [drbd]
[29546.504249]  [<ffffffffa0158ae8>] drbd_thread_setup+0x58/0x130 [drbd]
[29546.504277]  [<ffffffffa0158a90>] ? drbd_open+0xa0/0xa0 [drbd]
[29546.504301]  [<ffffffff810a2f5b>] kthread+0xbb/0xc0
[29546.504325]  [<ffffffff810a2ea0>] ? kthread_create_on_node+0x120/0x120
[29546.504350]  [<ffffffff81606f3c>] ret_from_fork+0x7c/0xb0
[29546.504374]  [<ffffffff810a2ea0>] ? kthread_create_on_node+0x120/0x120
[29546.504398] Code: 00 00 48 c7 c1 91 eb 05 81 48 c7 c2 8e eb 05 81 e9 
dd fe ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 55 b8 00 01 00 00 48 
89 e5 <f0> 66 0f c1 07 0f b6 d4 38 c2 74 0c 0f 1f 00 f3 90 0f b6 07 38
[29546.504683] RIP  [<ffffffff8105ed79>] __ticket_spin_lock+0x9/0x30
[29546.504711]  RSP <ffff8803faa4fcf0>
[29546.504730] CR2: 0000000000000808
[29546.504750] ---[ end trace 75eb563333dd96e3 ]---

Cheers
-- 
Laurent

