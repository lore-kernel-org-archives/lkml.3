Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaDQRkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:40:22 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62206 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDQRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:40:14 -0400
MIME-Version: 1.0
Date: Thu, 17 Apr 2014 19:40:13 +0200
Message-ID: <CAGKO+34TVekC5v_qVpsX1cmD4C5mUDY7=9Fo0HC2ObM1s3R5Tg@mail.gmail.com>
Subject: skb_warn_bad_offload+0xc8/0xd5() at net/core/dev.c:2218
From: Marcin Gibula <m.gibula@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've encountered these warnings on one of my servers running 3.12.17.
Warning probably originates from bridge connecting virtual machines
with bonded interface.

Is this something I should worry about? Is turning GSO/GRO off
recommended for network bridges?

[340917.510968] WARNING: CPU: 8 PID: 4487 at net/core/dev.c:2218
skb_warn_bad_offload+0xc8/0xd5()
[340917.511633] : caps=(0x0000000000195ba9, 0x0000000000000000)
len=1610 data_len=0 gso_size=1448 gso_type=5 ip_summed=0
[340917.512305] Modules linked in: ebt_dnat ebt_ip ebt_arp act_police
cls_u32 sch_ingress cls_fw sch_sfq sch_htb iptable_raw xt_CT
iptable_filter ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi x86_pkg_temp_thermal hpsa
[340917.513763] CPU: 8 PID: 4487 Comm: qemu-system-x86 Tainted: G
  W    3.12.17-gentoo #4
[340917.514105] Hardware name: HP ProLiant BL460c Gen8, BIOS I31 12/20/2013
[340917.514440]  0000000000000009 ffff8817dfc03b98 ffffffff81557bf8
ffff8817dfc03be0
[340917.514797]  ffff8817dfc03bd0 ffffffff81072623 ffff8817b3e4ed00
ffff8817ba824000
[340917.515162]  0000000000000005 0000000000000000 ffffffff815c6800
ffff8817dfc03c30
[340917.515523] Call Trace:
[340917.515856]  <IRQ>  [<ffffffff81557bf8>] dump_stack+0x45/0x56
[340917.516213]  [<ffffffff81072623>] warn_slowpath_common+0x73/0x90
[340917.516557]  [<ffffffff81072687>] warn_slowpath_fmt+0x47/0x50
[340917.516900]  [<ffffffff8128b81c>] ? ___ratelimit+0x7c/0xf0
[340917.517239]  [<ffffffff81559f67>] skb_warn_bad_offload+0xc8/0xd5
[340917.517586]  [<ffffffff8147b581>] __skb_gso_segment+0x71/0xc0
[340917.517928]  [<ffffffff8147b89b>] dev_hard_start_xmit+0x19b/0x4a0
[340917.518265]  [<ffffffff8147bec2>] dev_queue_xmit+0x322/0x460
[340917.518606]  [<ffffffff815200b0>] ? br_forward_finish+0x60/0x60
[340917.518946]  [<ffffffff81520017>] br_dev_queue_push_xmit+0x87/0xc0
[340917.519308]  [<ffffffff8152006d>] br_forward_finish+0x1d/0x60
[340917.519653]  [<ffffffff81520106>] __br_forward+0x56/0xc0
[340917.519996]  [<ffffffff8151ff6e>] deliver_clone+0x2e/0x50
[340917.520335]  [<ffffffff81520539>] br_forward+0x39/0x60
[340917.520680]  [<ffffffff815212b1>] br_handle_frame_finish+0x201/0x310
[340917.521021]  [<ffffffff8152154d>] br_handle_frame+0x18d/0x250
[340917.521360]  [<ffffffff81478de2>] __netif_receive_skb_core+0x212/0x800
[340917.521704]  [<ffffffff81095658>] ? __wake_up_common+0x58/0x90
[340917.522048]  [<ffffffff814793e3>] __netif_receive_skb+0x13/0x60
[340917.522386]  [<ffffffff8147a658>] process_backlog+0x98/0x170
[340917.522727]  [<ffffffff8147a521>] net_rx_action+0x101/0x1a0
[340917.523062]  [<ffffffff81076489>] __do_softirq+0xd9/0x1a0
[340917.523404]  [<ffffffff81565afc>] call_softirq+0x1c/0x30
[340917.523750]  <EOI>  [<ffffffff81039225>] do_softirq+0x35/0x70
[340917.524111]  [<ffffffff81477d48>] netif_rx_ni+0x28/0x30
[340917.524456]  [<ffffffff813859d1>] tun_get_user+0x3f1/0x7f0
[340917.524798]  [<ffffffff81385ecb>] tun_chr_aio_write+0x7b/0xa0
[340917.525142]  [<ffffffff811396d7>] do_sync_readv_writev+0x47/0x80
[340917.525487]  [<ffffffff8113a9bf>] do_readv_writev+0xcf/0x230
[340917.525824]  [<ffffffff81173161>] ? fsnotify+0x231/0x310
[340917.526161]  [<ffffffff810d1eab>] ? __secure_computing+0x6b/0x1d0
[340917.526496]  [<ffffffff8113aba0>] vfs_writev+0x30/0x60
[340917.526829]  [<ffffffff8113acb4>] SyS_writev+0x44/0xa0
[340917.527158]  [<ffffffff81564ad9>] tracesys+0xd0/0xd5
[340917.527498] ---[ end trace 11d4549ee4aa7812 ]---

Driver information:
# ethtool -i eth0
driver: ixgbe
version: 3.15.1-k
firmware-version: 0x80000684
bus-info: 0000:04:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no

Offloads configuration:
# ethtool -k eth0
Features for eth0:
rx-checksumming: on
tx-checksumming: on
        tx-checksum-ipv4: on
        tx-checksum-ip-generic: off [fixed]
        tx-checksum-ipv6: on
        tx-checksum-fcoe-crc: off [fixed]
        tx-checksum-sctp: on
scatter-gather: on
        tx-scatter-gather: on
        tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: off
        tx-tcp-segmentation: off
        tx-tcp-ecn-segmentation: off [fixed]
        tx-tcp6-segmentation: off
udp-fragmentation-offload: off [fixed]
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off
rx-vlan-offload: on
tx-vlan-offload: on
ntuple-filters: off
receive-hashing: on
highdma: on [fixed]
rx-vlan-filter: on
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: off [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: off [fixed]
tx-udp_tnl-segmentation: off [fixed]
tx-mpls-segmentation: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: on
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]

-- 
mg
