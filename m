Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaBRDCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 22:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbaBRDCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 22:02:47 -0500
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: WARNING: CPU: 0 PID: 0 at lib/dma-debug.c:491
Date: Tue, 18 Feb 2014 11:02:41 +0800
Message-ID: <87zjlpcecu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy all,
  Meet following warning and call trace:

[307001.720980] ------------[ cut here ]------------
[307001.720994] WARNING: CPU: 0 PID: 0 at lib/dma-debug.c:491 add_dma_entry+0x127/0x130()
[307001.720996] DMA-API: exceeded 7 overlapping mappings of pfn 1932f8
[307001.720998] Modules linked in: ip6t_rpfilter ip6t_REJECT ipt_REJECT xt_conntrack ebtable_nat ebtable_broute ebtable_filter ebtables ip6table_nat nf_conntra
ck_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_na
t_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ip_tables cfg80211 bridge stp llc vfat fat x86_pkg_temp_thermal nfsd core
temp kvm_intel kvm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec auth_rpcgss crct10dif_pclmul crc32_pclmul crc32c_
intel snd_hwdep nfs_acl lockd snd_seq ghash_clmulni_intel e1000e aesni_intel snd_seq_device snd_pcm lrw snd_timer sunrpc gf128mul glue_helper hp_wmi ablk_helpe
r snd sparse_keymap
[307001.721056]  iTCO_wdt cryptd rfkill iTCO_vendor_support ppdev serio_raw microcode parport_pc parport soundcore lpc_ich wmi ptp i2c_i801 pcspkr pps_core tpm
_infineon mfd_core xfs libcrc32c sd_mod sr_mod cdrom crc_t10dif crct10dif_common i915 i2c_algo_bit drm_kms_helper drm ahci libahci libata i2c_core video dm_mir
ror dm_region_hash dm_log dm_mod [last unloaded: ip_tables]
[307001.721093] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc2+ #14
[307001.721095] Hardware name: Hewlett-Packard HP Compaq Elite 8300 SFF/3397, BIOS K01 v02.05 05/07/2012
[307001.721098]  0000000000000009 ffff880215c03660 ffffffff816b6049 ffff880215c036a8
[307001.721103]  ffff880215c03698 ffffffff8107782d 00000000001932f8 ffff880011b030c0
[307001.721108]  0000000000000296 ffffffff82eb1b80 0000000000000296 ffff880215c036f8
[307001.721113] Call Trace:
[307001.721115]  <IRQ>  [<ffffffff816b6049>] dump_stack+0x4d/0x66
[307001.721129]  [<ffffffff8107782d>] warn_slowpath_common+0x7d/0xa0
[307001.721134]  [<ffffffff8107789c>] warn_slowpath_fmt+0x4c/0x50
[307001.721138]  [<ffffffff81362f5d>] ? active_pfn_read_overlap+0x2d/0x50
[307001.721142]  [<ffffffff81363507>] add_dma_entry+0x127/0x130
[307001.721146]  [<ffffffff8136384a>] debug_dma_map_page+0x11a/0x140
[307001.721161]  [<ffffffffa0554e63>] e1000_xmit_frame+0x723/0xfd0 [e1000e]
[307001.721168]  [<ffffffff81579996>] dev_hard_start_xmit+0x2e6/0x8d0
[307001.721174]  [<ffffffff8159fdde>] sch_direct_xmit+0xee/0x290
[307001.721178]  [<ffffffff8157a1c2>] __dev_queue_xmit+0x242/0x920
[307001.721183]  [<ffffffff81579f85>] ? __dev_queue_xmit+0x5/0x920
[307001.721187]  [<ffffffff8157a8b0>] dev_queue_xmit+0x10/0x20
[307001.721194]  [<ffffffff815c2cf0>] ip_finish_output+0x680/0x930
[307001.721198]  [<ffffffff815c472c>] ? ip_output+0x5c/0x100
[307001.721203]  [<ffffffff815c472c>] ip_output+0x5c/0x100
[307001.721207]  [<ffffffff815c3ac9>] ip_local_out+0x29/0x90
[307001.721212]  [<ffffffff815c3f99>] ip_queue_xmit+0x1e9/0x650
[307001.721216]  [<ffffffff815c3db5>] ? ip_queue_xmit+0x5/0x650
[307001.721222]  [<ffffffff815dce97>] tcp_transmit_skb+0x467/0xa90
[307001.721227]  [<ffffffff815dd65e>] tcp_write_xmit+0x19e/0xc10
[307001.721231]  [<ffffffff815de33e>] __tcp_push_pending_frames+0x2e/0xc0
[307001.721236]  [<ffffffff815d95df>] tcp_rcv_established+0x1df/0x650
[307001.721240]  [<ffffffff815e4a85>] tcp_v4_do_rcv+0x195/0x4b0
[307001.721243]  [<ffffffff815e73be>] tcp_v4_rcv+0xa9e/0xb90
[307001.721248]  [<ffffffff815bd103>] ? ip_local_deliver_finish+0x43/0x460
[307001.721253]  [<ffffffff815bd1ff>] ip_local_deliver_finish+0x13f/0x460
[307001.721257]  [<ffffffff815bd103>] ? ip_local_deliver_finish+0x43/0x460
[307001.721261]  [<ffffffff815bd7b8>] ip_local_deliver+0x48/0x80
[307001.721266]  [<ffffffff815bcb10>] ip_rcv_finish+0x160/0x710
[307001.721270]  [<ffffffff815bda84>] ip_rcv+0x294/0x3d0
[307001.721275]  [<ffffffff81575a32>] __netif_receive_skb_core+0x9f2/0xdb0
[307001.721279]  [<ffffffff8157517b>] ? __netif_receive_skb_core+0x13b/0xdb0
[307001.721283]  [<ffffffff81575e08>] __netif_receive_skb+0x18/0x60
[307001.721288]  [<ffffffff815777b3>] netif_receive_skb_internal+0x33/0x200
[307001.721292]  [<ffffffff8157869d>] napi_gro_receive+0x9d/0x1a0
[307001.721302]  [<ffffffffa0551adf>] e1000_receive_skb+0x7f/0xe0 [e1000e]
[307001.721311]  [<ffffffffa05530f1>] e1000_clean_rx_irq+0x281/0x440 [e1000e]
[307001.721321]  [<ffffffffa055b2bd>] e1000e_poll+0x6d/0x310 [e1000e]
[307001.721326]  [<ffffffff815789ba>] net_rx_action+0x15a/0x370
[307001.721331]  [<ffffffff8107e4b5>] __do_softirq+0x135/0x4d0
[307001.721335]  [<ffffffff8107ebfd>] irq_exit+0x12d/0x150
[307001.721339]  [<ffffffff816cc018>] do_IRQ+0x58/0xf0
[307001.721346]  [<ffffffff816bfff2>] common_interrupt+0x72/0x72
[307001.721347]  <EOI>  [<ffffffff81523310>] ? cpuidle_enter_state+0x50/0xd0
[307001.721355]  [<ffffffff81523317>] ? cpuidle_enter_state+0x57/0xd0
[307001.721359]  [<ffffffff81523449>] cpuidle_idle_call+0xb9/0x380
[307001.721366]  [<ffffffff810263be>] arch_cpu_idle+0xe/0x40
[307001.721373]  [<ffffffff810f06ae>] cpu_startup_entry+0x9e/0x410
[307001.721379]  [<ffffffff816a295d>] rest_init+0x13d/0x150
[307001.721383]  [<ffffffff816a2825>] ? rest_init+0x5/0x150
[307001.721389]  [<ffffffff81d68f68>] start_kernel+0x445/0x450
[307001.721393]  [<ffffffff81d6892c>] ? repair_env_string+0x5c/0x5c
[307001.721397]  [<ffffffff81d68120>] ? early_idt_handlers+0x120/0x120
[307001.721401]  [<ffffffff81d685de>] x86_64_start_reservations+0x2a/0x2c
[307001.721405]  [<ffffffff81d6871e>] x86_64_start_kernel+0x13e/0x14d
[307001.721408] ---[ end trace 1f133d9f413c7e07 ]---

-- 
Sent with my mu4e

