Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab3CSTFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:05:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47235 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3CSTFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:05:05 -0400
Date: Tue, 19 Mar 2013 15:05:03 -0400 (EDT)
Message-Id: <20130319.150503.2117399908921757735.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 12:05:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2JJ5DAb027967


1) Fix ARM BPF JIT handling of negative 'k' values, from Chen Gang.

2) Insufficient space reserved for bridge netlink values, fix from
   Stephen Hemminger.

3) Some dst_neigh_lookup*() callers don't interpret error pointer
   correctly, fix from Zhouyi Zhou.

4) Fix transport match in SCTP active_path loops, from Xugeng Zhang.

5) Fix qeth driver handling of multi-order SKB frags, from Frank
   Blaschka.

6) fec driver is missing napi_disable() call, resulting in crashes
   on unload, from Georg Hofmann.

7) Don't try to handle PMTU events on a listening socket, fix
   from Eric Dumazet.

8) Fix timestamp location calculations in IP option processing,
   from David Ward.

9) FIB_TABLE_HASHSZ setting is not controlled by the correct
   kconfig tests, from Denis V. Lunev.

10) Fix TX descriptor push handling in SFC driver, from Ben Hutchings.

11) Fix isdn/hisax and tulip/de4x5 kconfig dependencies, from Arnd
    Bergmann.

12) bnx2x statistics don't handle 4GB rollover correctly, fix from
    Maciej ≈ªenczykowski.

13) Openvswitch bug fixes for vport del/new error reporting, missing
    genlmsg_end() call in netlink processing, and mis-parsing of
    LLC/SNAP ethernet types.  From Rich Lane.

14) SKB pfmemalloc state should only be propagated from the head
    page of a compound page, fix from Pavel Emelyanov.

15) Fix link handling in tg3 driver for 5715 chips when autonegotation
    is disabled.  From Nithin Sujir.

16) Fix inverted test of cpdma_check_free_tx_desc return value in
    davinci_emac driver, from Mugunthan V N.

17) vlan_depth is incorrectly calculated in skb_network_protocol(),
    from Li RongQing.

18) Fix probing of Gobi 1K devices in qmi_wwan driver, and fix NCM
    device mode backwards compat in cdc_ncm driver.  From Bj√∏rn Mork.

Please pull, thanks a lot!

The following changes since commit 7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b:

  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-03-11 07:54:29 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to 5a3da1fe9561828d0ca7eca664b16ec2b9bf0055:

  inet: limit length of fragment queue hash table bucket lists (2013-03-19 10:28:36 -0400)

----------------------------------------------------------------
Arnd Bergmann (2):
      isdn: hisax: netjet requires VIRT_TO_BUS
      ethernet/tulip: DE4x5 needs VIRT_TO_BUS

Ben Hutchings (1):
      sfc: Only use TX push if a single descriptor is to be written

Bing Zhao (1):
      mwifiex: fix potential out-of-boundary access to ibss rate table

Bj√∏rn Mork (2):
      net: qmi_wwan: set correct altsetting for Gobi 1K devices
      net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards compatibility

Chen Gang (1):
      ARM:net: an issue for k which is u32, never < 0

Cong Wang (2):
      openvswitch: fix the calculation of checksum for vlan header
      openvswitch: remove some useless comments

Daniel Mack (1):
      net: ethernet: cpsw: fix usage of cpdma_check_free_tx_desc()

David S. Miller (4):
      Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'sfc-3.9' of git://git.kernel.org/.../bwh/sfc
      Merge branch 'fixes' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is stored

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ

Eric Dumazet (2):
      tcp: fix skb_availroom()
      tcp: dont handle MTU reduction on LISTEN socket

Frank Blaschka (1):
      qeth: Fix scatter-gather regression

Georg Hofmann (1):
      net: fec: fix missing napi_disable call

Hannes Frederic Sowa (1):
      inet: limit length of fragment queue hash table bucket lists

John Crispin (1):
      rt2x00: fix rt2x00 to work with the new ralink SoC config symbols

John W. Linville (3):
      Merge tag 'nfc-fixes-3.9-1' of git://git.kernel.org/.../sameo/nfc-fixes
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Josh Boyer (1):
      Bluetooth: Add support for atheros 04ca:3004 device to ath3k

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
      rtlwifi: rtl8192cu: Fix problem that prevents reassociation

Li RongQing (1):
      net/core: move vlan_depth out of while loop in skb_network_protocol()

Lucas Stach (1):
      net: fec: restart the FEC when PHY speed changes

Maciej ≈ªenczykowski (1):
      bnx2x: fix occasional statistics off-by-4GB error

Marek Lindner (1):
      batman-adv: verify tt len does not exceed packet len

Michael S. Tsirkin (1):
      vhost/net: fix heads usage of ubuf_info

Michal Schmidt (1):
      bnx2x: add missing napi deletion in error path

Mugunthan V N (1):
      drivers: net: ethernet: ti: davinci_emac: fix usage of cpdma_check_free_tx_desc()

Nithin Sujir (1):
      tg3: 5715 does not link up when autoneg off

Pavel Emelyanov (1):
      skb: Propagate pfmemalloc on skb from head page only

Rich Lane (4):
      openvswitch: Fix ovs_vport_cmd_del return value on success
      openvswitch: Fix ovs_vport_cmd_new return value on success
      openvswitch: Call genlmsg_end in queue_userspace_packet
      openvswitch: Fix parsing invalid LLC/SNAP ethertypes

Robert de Vries (1):
      smsc75xx: configuration help incorrectly mentions smsc95xx

Samuel Ortiz (4):
      NFC: llcp: Decrease socket ack log when accepting a connection
      NFC: llcp: Clean local timers and works when removing a device
      NFC: llcp: Clean raw sockets from nfc_llcp_socket_release
      NFC: llcp: Report error to pending sockets when a device is removed

Santosh Rastapur (1):
      cxgb4: Allow for backward compatibility with new VPD scheme.

Stefan Raspl (2):
      qeth: delay feature trace
      qeth: Fix invalid router settings handling

Sunguk Lee (1):
      Bluetooth: Device 0cf3:3008 should map AR 3012

Timo Ter√§s (1):
      Revert "ip_gre: make ipgre_tunnel_xmit() not parse network header as IP unconditionally"

Veaceslav Falico (2):
      netconsole: don't call __netpoll_cleanup() while atomic
      bonding: don't call update_speed_duplex() under spinlocks

Vlad Yasevich (3):
      sctp: Use correct sideffect command in duplicate cookie handling
      rtnetlink: Mask the rta_type when range checking
      bridge: Add support for setting BR_ROOT_BLOCK flag.

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the active_path so as to find the matched transport

Zhouyi Zhou (1):
      Fix dst_neigh_lookup/dst_neigh_lookup_skb return value handling bug

stephen hemminger (1):
      bridge: reserve space for IFLA_BRPORT_FAST_LEAVE

 arch/arm/net/bpf_jit_32.c                         |  2 +-
 drivers/bluetooth/ath3k.c                         |  4 +++
 drivers/bluetooth/btusb.c                         |  2 ++
 drivers/infiniband/hw/cxgb4/cm.c                  | 12 ++++++++
 drivers/isdn/hisax/Kconfig                        |  6 ++--
 drivers/net/bonding/bond_main.c                   |  6 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h |  3 +-
 drivers/net/ethernet/broadcom/tg3.c               |  8 ++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c        | 12 ++++++--
 drivers/net/ethernet/dec/tulip/Kconfig            |  1 +
 drivers/net/ethernet/freescale/fec.c              | 27 ++++++++++--------
 drivers/net/ethernet/freescale/fec.h              |  1 +
 drivers/net/ethernet/sfc/nic.c                    |  3 +-
 drivers/net/ethernet/ti/cpsw.c                    |  2 +-
 drivers/net/ethernet/ti/davinci_emac.c            |  2 +-
 drivers/net/netconsole.c                          | 15 ++++++----
 drivers/net/usb/Kconfig                           |  2 +-
 drivers/net/usb/cdc_mbim.c                        | 11 +-------
 drivers/net/usb/cdc_ncm.c                         | 49 +++++++++++++++++++++------------
 drivers/net/usb/qmi_wwan.c                        | 49 +++++++++++----------------------
 drivers/net/wireless/mwifiex/join.c               |  7 ++---
 drivers/net/wireless/rt2x00/Kconfig               |  4 +--
 drivers/net/wireless/rt2x00/rt2800pci.c           | 14 +++++-----
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       | 89 ++++++++++++++++++++++++------------------------------------
 drivers/s390/net/qeth_core.h                      |  1 +
 drivers/s390/net/qeth_core_main.c                 | 45 +++++++++++++++++++++++++-----
 drivers/s390/net/qeth_l3_main.c                   | 23 ++++++++++------
 drivers/s390/net/qeth_l3_sys.c                    |  2 ++
 drivers/vhost/net.c                               |  3 +-
 include/linux/skbuff.h                            | 13 ++++++---
 include/linux/usb/cdc_ncm.h                       |  1 +
 include/net/dst.h                                 |  6 ++--
 include/net/inet_frag.h                           |  9 ++++++
 include/net/ip_fib.h                              | 12 ++++----
 net/batman-adv/bat_iv_ogm.c                       |  6 ++--
 net/bridge/br_netlink.c                           |  2 ++
 net/core/dev.c                                    |  2 +-
 net/core/rtnetlink.c                              |  2 +-
 net/ipv4/inet_fragment.c                          | 20 +++++++++++++-
 net/ipv4/ip_fragment.c                            | 11 +++-----
 net/ipv4/ip_gre.c                                 |  5 +---
 net/ipv4/ip_options.c                             |  5 +---
 net/ipv4/tcp.c                                    |  2 +-
 net/ipv4/tcp_ipv4.c                               | 14 +++++-----
 net/ipv4/tcp_output.c                             |  1 -
 net/ipv6/netfilter/nf_conntrack_reasm.c           | 12 ++++----
 net/ipv6/reassembly.c                             |  8 ++++--
 net/ipv6/tcp_ipv6.c                               |  7 +++++
 net/nfc/llcp/llcp.c                               | 62 ++++++++++++++++++++++++++++++++++++------
 net/nfc/llcp/sock.c                               |  2 ++
 net/openvswitch/actions.c                         |  4 +--
 net/openvswitch/datapath.c                        |  3 ++
 net/openvswitch/flow.c                            |  6 +++-
 net/openvswitch/vport-netdev.c                    |  3 +-
 net/openvswitch/vport.c                           |  3 +-
 net/sctp/associola.c                              |  2 +-
 net/sctp/sm_statefuns.c                           |  2 +-
 58 files changed, 387 insertions(+), 244 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
