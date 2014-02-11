Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaBKHO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:14:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59249 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKHOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:14:53 -0500
Date: Mon, 10 Feb 2014 23:14:51 -0800 (PST)
Message-Id: <20140210.231451.1429732790703282821.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1B7FD6n004895


1) Fix flexcan build on big endian, from Arnd Bergmann.

2) Correctly attach cpsw to GPIO bitbang MDIO drive, from Stefan Roese.

3) udp_add_offload has to use GFP_ATOMIC since it can be invoked from
   non-sleepable contexts.  From Or Gerlitz.

4) vxlan_gro_receive() does not iterate over all possible flows properly,
   fix also from Or Gerlitz.

5) CAN core doesn't use a proper SKB destructor when it hooks up sockets
   to SKBs.  Fix from Oliver Hartkopp.

6) ip_tunnel_xmit() can use an uninitialized route pointer, fix from
   Eric Dumazet.

7) Fix address family assignment in IPVS, from Michal Kubecek.

8) Fix ath9k build on ARM, from Sujith Manoharan.

9) Make sure fail_over_mac only applies for the correct bonding modes,
   from Ding Tianhong.

10) The udp offload code doesn't use RCU correctly, from Shlomo Pongratz.

11) Handle gigabit features properly in generic PHY code, from Florian
    Fainelli.

12) Don't blindly invoke link operations in
    rtnl_link_get_slave_info_data_size, they are optional.  Fix from
    Fernando Luis Vazquez Cao.

13) Add USB IDs for Netgear Aircard 340U, from Bj√∏rn Mork.

14) Handle netlink packet padding properly in openvswitch, from Thomas
    Graf.

15) Fix oops when deleting chains in nf_tables, from Patrick McHardy.

16) Fix RX stalls in xen-netback driver, from Zoltan Kiss.

17) Fix deadlock in mac80211 stack, from Emmanuel Grumbach.

18) inet_nlmsg_size() forgets to consider ifa_cacheinfo, fix from Geert
    Uytterhoeven.

19) tg3_change_mtu() can deadlock, fix from Nithin Sujir.

20) Fix regression in setting SCTP local source addresses on accepted
    sockets, caused by some generic ipv6 socket changes.  Fix from
    Matija Glavinic Pecotic.

21) IPPROTO_* must be pure defines, otherwise module aliases don't get
    constructed properly.  Fix from Jan Moskyto.

22) IPV6 netconsole setup doesn't work properly unless an explicit
    source address is specified, fix from Sabrina Dubroca.

23) Use __GFP_NORETRY for high order skb page allocations in sock_alloc_send_pskb
    and skb_page_frag_refill.  From Eric Dumazet.

24) Fix a regression added in netconsole over bridging, from Cong Wang.

25) TCP uses an artificial offset of 1ms for SRTT, but this doesn't jive
    well with TCP pacing which needs the SRTT to be accurate.  Fix from
    Eric Dumazet.

26) Several cases of missing header file includes from Rashika Kheria.

27) Add ZTE MF667 device ID to qmi_wwan driver, from Raymond Wanyoike.

28) TCP Small Queues doesn't handle nonagle properly in some corner cases,
    fix from Eric Dumazet.

29) Remove extraneous read_unlock in bond_enslave, whoops.  From Ding
    Tianhong.

30) Fix 9p trans_virtio handling of vmalloc buffers, from Richard Yao.

Please pull, thanks a lot!

The following changes since commit 53d8ab29f8f6d67e37857b68189b38fa3d87dd8e:

  Merge branch 'for-3.14/drivers' of git://git.kernel.dk/linux-block (2014-01-30 11:40:10 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net master

for you to fetch changes up to 20e7c4e80dcd01dad5e6c8b32455228b8fe9c619:

  6lowpan: fix lockdep splats (2014-02-10 17:51:29 -0800)

----------------------------------------------------------------
Alexander Shiyan (1):
      net: irda: ep7211-sir: Remove driver

Alexey Dobriyan (1):
      netfilter: nf_nat_h323: fix crash in nf_ct_unlink_expect_report()

Andrey Vagin (1):
      netfilter: nf_conntrack: fix RCU race in nf_conntrack_find_get

Andy Zhou (2):
      openvswitch: Fix kernel panic on ovs_flow_free
      openvswitch: Suppress error messages on megaflow updates

Arnd Bergmann (1):
      can: flexcan: fix flexcan driver build for big endian on ARM and little endian on PowerPc

Arturo Borrero (1):
      netfilter: nft_ct: fix unconditional dump of 'dir' attr

Bj√∏rn Mork (1):
      net: qmi_wwan: add Netgear Aircard 340U

Christian Engelmayer (4):
      6lowpan: Remove unused pointer in lowpan_header_create()
      wan: dlci: Remove unused netdev_priv pointer
      3c59x: Remove unused pointer in vortex_eisa_cleanup()
      net: vxge: Remove unused device pointer

Cong Wang (1):
      bridge: fix netconsole setup over bridge

Dan Carpenter (3):
      tg3: cleanup an error path in tg3_phy_reset_5703_4_5()
      isdn/hisax: hex vs decimal typo in prfeatureind()
      hso: remove some dead code

Daniel Baluta (1):
      vxlan: remove extra newline after function definition

Daniele Di Proietto (1):
      openvswitch: Fix ovs_dp_cmd_msg_size()

David S. Miller (7):
      Merge tag 'linux-can-fixes-for-3.14-20140129' of git://gitorious.org/linux-can/linux-can
      Merge branch 'ethoc'
      Merge branch 'bonding_fail_over_mac'
      Merge branch 'fixes' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless
      Merge branch 'bridge'

David Spinadel (1):
      iwlwifi: mvm: notify match found without filtering

David Vrabel (1):
      xen-netfront: handle backend CLOSED without CLOSING

Dmitry Kravkov (1):
      bnx2x: fix L2-GRE TCP issues

Eliad Peller (1):
      mac80211: move roc cookie assignment earlier

Emmanuel Grumbach (6):
      iwlwifi: mvm: print the version of the firmware when it asserts
      iwlwifi: mvm: don't leak a station when we drain
      iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan
      iwlwifi: mvm: don't allow A band if SKU forbids it
      mac80211: avoid deadlock revealed by lockdep
      mac80211: release the channel in error path in start_ap

Eric Dumazet (4):
      ip_tunnel: fix panic in ip_tunnel_xmit()
      net: use __GFP_NORETRY for high order allocations
      tcp: remove 1ms offset in srtt computation
      6lowpan: fix lockdep splats

FX Le Bail (1):
      ipv6: icmp6_send: fix Oops when pinging a not set up IPv6 peer on a sit tunnel

Fernando Luis Vazquez Cao (1):
      rtnetlink: fix oops in rtnl_link_get_slave_info_data_size

Florian Fainelli (1):
      net: phy: ensure Gigabit features are masked off if requested

Geert Uytterhoeven (1):
      ipv4: Fix runtime WARNING in rtmsg_ifa()

Ira W. Snyder (1):
      can: janz-ican3: fix uninitialized variable warnings

James M Leddy (1):
      bnx2[x]: Make module parameters readable

Jan Moskyto Matejka (1):
      inet: defines IPPROTO_* needed for module alias generation

Jesper Juhl (1):
      tcp: correct code comment stating 3 min timeout for FIN_WAIT2, we only do 1 min

Johannes Berg (7):
      iwlwifi: mvm: make local pointer non-static
      iwlwifi: mvm: disable scheduled scan
      cfg80211: re-enable 5/10 MHz support
      cfg80211: fix scan done race
      cfg80211: send scan results from work queue
      mac80211: fix fragmentation code, particularly for encryption
      mac80211: fix virtual monitor interface iteration

John Greene (1):
      alx: add missing stats_lock spinlock init

John Ogness (1):
      tcp: tsq: fix nonagle handling

John W. Linville (3):
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Liu Junliang (1):
      USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800 Device Driver Support

Maciej ≈ªenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Matija Glavinic Pecotic (1):
      net: sctp: fix initialization of local source address on accepted ipv6 sockets

Max Filippov (6):
      net: ethoc: implement basic ethtool operations
      net: ethoc: implement ethtool get/set settings
      net: ethoc: implement ethtool get registers
      net: ethoc: implement ethtool get/set ring parameters
      net: ethoc: don't advertise gigabit speed on attached PHY
      net: ethoc: set up MII management bus clock

Maxime Ripard (3):
      net: ethernet: sunxi: Add new compatibles
      net: phy: sunxi: Add new compatibles
      ARM: sunxi: dt: Convert to the new net compatibles

Michal Kubecek (1):
      ipvs: fix AF assignment in ip_vs_conn_new()

Michele Baldessari (1):
      e100: Fix "disabling already-disabled device" warning

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Oleksij Rempel (2):
      ath9k_htc: Do not support PowerSave by default
      ar5523: fix usb id for Gigaset.

Oliver Hartkopp (1):
      can: add destructor for self generated skbs

Or Gerlitz (2):
      net/ipv4: Use non-atomic allocation of udp offloads structure instance
      net/vxlan: Go over all candidate streams for GRO matching

Oren Givon (1):
      iwlwifi: add more 7265 HW IDs

Pablo Neira Ayuso (5):
      netfilter: nf_conntrack: don't release a conntrack with non-zero refcnt
      netfilter: nf_tables: fix racy rule deletion
      netfilter: nf_tables: do not allow NFT_SET_ELEM_INTERVAL_END flag and data
      netfilter: nft_rbtree: fix data handling of end interval elements
      netfilter: nf_tables: fix loop checking with end interval elements

Patrick McHardy (9):
      netfilter: nf_tables: fix oops when deleting a chain with references
      netfilter: nf_tables: fix overrun in nf_tables_set_alloc_name()
      netfilter: nf_tables: fix potential oops when dumping sets
      netfilter: nft_ct: fix missing NFT_CT_L3PROTOCOL key in validity checks
      netfilter: nf_tables: add AF specific expression support
      netfilter: nft_reject: split up reject module into IPv4 and IPv6 specifc parts
      netfilter: nf_tables: add reject module for NFPROTO_INET
      netfilter: nf_tables: fix log/queue expressions for NFPROTO_INET
      netfilter: nf_tables: unininline nft_trace_packet()

Paul Gortmaker (1):
      drivers/net: fix build warning in ethernet/sfc/tx.c

Pontus Fuchs (1):
      nl80211: Reset split_start when netlink skb is exhausted

Pravin B Shelar (1):
      openvswitch: Fix ovs_flow_free() ovs-lock assert.

Rashika Kheria (12):
      net: Mark function as static in 9p/client.c
      net: Include appropriate header file in caif/caif_dev.c
      net: Include appropriate header file in caif/cfsrvl.c
      net: Mark functions as static in core/dev.c
      net: Move prototype declaration to appropriate header file from decnet/af_decnet.c
      net: Move prototype declaration to header file include/net/dn.h from net/decnet/af_decnet.c
      net: Move prototype declaration to include/net/ipx.h from net/ipx/ipx_route.c
      net: Move prototype declaration to header file include/net/ipx.h from net/ipx/af_ipx.c
      net: Move prototype declaration to header file include/net/datalink.h from net/ipx/af_ipx.c
      net: Move prototype declaration to header file include/net/net_namespace.h from net/ipx/af_ipx.c
      net: Include appropriate header file in netfilter/nft_lookup.c
      net: Mark functions as static in net/sunrpc/svc_xprt.c

Raymond Wanyoike (1):
      net: qmi_wwan: add ZTE MF667

Richard Yao (1):
      9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Rostislav Lisovy (1):
      can: Propagate SO_PRIORITY of raw sockets to skbs

Sabrina Dubroca (1):
      netpoll: fix netconsole IPv6 setup

Shlomo Pongratz (1):
      net/ipv4: Use proper RCU APIs for writer-side in udp_offload.c

Stanislaw Gruszka (4):
      ath9k_htc: make ->sta_rc_update atomic for most calls
      rt2800: disable PS by default on USB
      rt2500: disable PS by default
      ath9k_htc: avoid scheduling while atomic on sta_rc_update

Stefan Roese (1):
      net: eth: cpsw: Correctly attach to GPIO bitbang MDIO driver

Stefan S√∏rensen (4):
      net:phy:dp83640: Declare that TX timestamping possible
      net:phy:dp83640: Do not hardcode timestamping event edge
      net:phy:dp83640: Initialize PTP clocks at device init.
      ptp: Allow selecting trigger/event index in testptp

Sujith Manoharan (4):
      ath9k: Fix build error on ARM
      ath9k: Do not support PowerSave by default
      ath9k: Fix TX power calculation
      mac80211: Fix IBSS disconnect

Thomas Graf (1):
      openvswitch: Pad OVS_PACKET_ATTR_PACKET if linear copy was performed

Toshiaki Makita (9):
      bridge: Fix the way to find old local fdb entries in br_fdb_changeaddr
      bridge: Fix the way to insert new local fdb entries in br_fdb_changeaddr
      bridge: Fix the way to find old local fdb entries in br_fdb_change_mac_address
      bridge: Change local fdb entries whenever mac address of bridge device changes
      bridge: Fix the way to check if a local fdb entry can be deleted
      bridge: Properly check if local fdb entry can be deleted in br_fdb_change_mac_address
      bridge: Properly check if local fdb entry can be deleted in br_fdb_delete_by_port
      bridge: Properly check if local fdb entry can be deleted when deleting vlan
      bridge: Prevent possible race condition in br_fdb_change_mac_address

Venkat Venkatsubra (1):
      rds: The maintainer needs to be updated.

Yuval Mintz (1):
      bnx2x: Allow VF rss on higher PFs

Zoltan Kiss (1):
      xen-netback: Fix Rx stall due to race condition

andrea.merello (2):
      rtl8180: Add error check for pci_map_single return value in RX path
      rtl8180: Add error check for pci_map_single return value in TX path

dingtianhong (3):
      bonding: fail_over_mac should only affect AB mode at enslave and removal processing
      bonding: fail_over_mac should only affect AB mode in bond_set_mac_address()
      bonding: remove unwanted bond lock for enslave processing

hayeswang (1):
      r8152: fix the submission of the interrupt transfer

 Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt |   5 +-
 Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt |   5 +-
 Documentation/ptp/testptp.c                                    |  11 +-
 MAINTAINERS                                                    |   2 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                               |   4 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                              |   4 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                               |   4 +-
 drivers/isdn/hisax/q931.c                                      |   2 +-
 drivers/net/bonding/bond_main.c                                |  26 +-
 drivers/net/can/Kconfig                                        |   2 +-
 drivers/net/can/dev.c                                          |  15 +-
 drivers/net/can/flexcan.c                                      |   7 +-
 drivers/net/can/janz-ican3.c                                   |  20 +-
 drivers/net/can/vcan.c                                         |   9 +-
 drivers/net/ethernet/3com/3c59x.c                              |   2 -
 drivers/net/ethernet/allwinner/sun4i-emac.c                    |   3 +
 drivers/net/ethernet/atheros/alx/main.c                        |   1 +
 drivers/net/ethernet/broadcom/bnx2.c                           |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c               |  12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c              |   6 +-
 drivers/net/ethernet/broadcom/tg3.c                            |  17 +-
 drivers/net/ethernet/ethoc.c                                   | 138 +++++-
 drivers/net/ethernet/intel/e100.c                              |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c                 |   6 -
 drivers/net/ethernet/sfc/tx.c                                  |   2 +
 drivers/net/ethernet/ti/cpsw.c                                 |  14 +-
 drivers/net/irda/Kconfig                                       |   7 -
 drivers/net/irda/Makefile                                      |   1 -
 drivers/net/irda/ep7211-sir.c                                  |  70 ---
 drivers/net/phy/dp83640.c                                      |  19 +-
 drivers/net/phy/mdio-sun4i.c                                   |   3 +
 drivers/net/phy/phy_device.c                                   |  38 +-
 drivers/net/usb/Kconfig                                        |  16 +
 drivers/net/usb/Makefile                                       |   1 +
 drivers/net/usb/hso.c                                          |  32 +-
 drivers/net/usb/qmi_wwan.c                                     |   2 +
 drivers/net/usb/r8152.c                                        |  17 +-
 drivers/net/usb/sr9800.c                                       | 870 +++++++++++++++++++++++++++++++++++
 drivers/net/usb/sr9800.h                                       | 202 ++++++++
 drivers/net/vxlan.c                                            |   3 -
 drivers/net/wan/dlci.c                                         |   5 -
 drivers/net/wireless/ath/ar5523/ar5523.c                       |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                 |   4 +
 drivers/net/wireless/ath/ath9k/htc.h                           |   2 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                  |   8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c                  |  63 ++-
 drivers/net/wireless/ath/ath9k/hw.c                            |   5 +-
 drivers/net/wireless/ath/ath9k/init.c                          |   8 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                   |   5 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h                 |   4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                    |   2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c                        |   5 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c                         |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c                          |  73 +--
 drivers/net/wireless/iwlwifi/mvm/utils.c                       |   2 +
 drivers/net/wireless/iwlwifi/pcie/drv.c                        |   7 +-
 drivers/net/wireless/rt2x00/rt2500pci.c                        |   5 +
 drivers/net/wireless/rt2x00/rt2500usb.c                        |   5 +
 drivers/net/wireless/rt2x00/rt2800lib.c                        |   5 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c                     |  23 +-
 drivers/net/xen-netback/common.h                               |   6 +-
 drivers/net/xen-netback/interface.c                            |   1 -
 drivers/net/xen-netback/netback.c                              |  16 +-
 drivers/net/xen-netfront.c                                     |   5 +-
 include/linux/can/skb.h                                        |  38 ++
 include/net/datalink.h                                         |   2 +
 include/net/dn.h                                               |   2 +
 include/net/dn_route.h                                         |   2 +
 include/net/ethoc.h                                            |   1 +
 include/net/ipx.h                                              |  11 +
 include/net/net_namespace.h                                    |   8 +
 include/net/netfilter/nf_conntrack.h                           |   2 +
 include/net/netfilter/nf_tables.h                              |   9 +-
 include/net/netfilter/nft_reject.h                             |  25 +
 include/uapi/linux/in6.h                                       |  23 +-
 net/9p/client.c                                                |   2 +-
 net/9p/trans_virtio.c                                          |   5 +-
 net/bridge/br_device.c                                         |  54 ++-
 net/bridge/br_fdb.c                                            | 137 ++++--
 net/bridge/br_if.c                                             |   6 +-
 net/bridge/br_input.c                                          |   4 +-
 net/bridge/br_private.h                                        |  13 +-
 net/bridge/br_stp_if.c                                         |   2 +
 net/bridge/br_vlan.c                                           |  27 +-
 net/caif/caif_dev.c                                            |   1 +
 net/caif/cfsrvl.c                                              |   1 +
 net/can/af_can.c                                               |   3 +-
 net/can/bcm.c                                                  |   4 +-
 net/can/raw.c                                                  |   1 +
 net/core/dev.c                                                 |   6 +-
 net/core/fib_rules.c                                           |   7 +
 net/core/netpoll.c                                             |   4 +-
 net/core/rtnetlink.c                                           |   2 +-
 net/core/sock.c                                                |   6 +-
 net/decnet/af_decnet.c                                         |   5 -
 net/ieee802154/6lowpan.c                                       |  23 +-
 net/ipv4/devinet.c                                             |   3 +-
 net/ipv4/ip_tunnel.c                                           |  29 +-
 net/ipv4/netfilter/Kconfig                                     |   5 +
 net/ipv4/netfilter/Makefile                                    |   1 +
 net/ipv4/netfilter/nf_nat_h323.c                               |   5 +-
 net/ipv4/netfilter/nft_reject_ipv4.c                           |  75 +++
 net/ipv4/tcp.c                                                 |   2 +-
 net/ipv4/tcp_input.c                                           |  18 +-
 net/ipv4/tcp_output.c                                          |  15 +-
 net/ipv4/udp_offload.c                                         |  17 +-
 net/ipv6/icmp.c                                                |   2 +-
 net/ipv6/netfilter/Kconfig                                     |   5 +
 net/ipv6/netfilter/Makefile                                    |   1 +
 net/ipv6/netfilter/nft_reject_ipv6.c                           |  76 +++
 net/ipx/af_ipx.c                                               |  22 +-
 net/ipx/ipx_route.c                                            |   4 -
 net/mac80211/cfg.c                                             |  44 +-
 net/mac80211/ht.c                                              |   4 +-
 net/mac80211/ibss.c                                            |   5 +-
 net/mac80211/iface.c                                           |  27 +-
 net/mac80211/tx.c                                              |   2 +-
 net/netfilter/Kconfig                                          |   6 +-
 net/netfilter/Makefile                                         |   1 +
 net/netfilter/ipvs/ip_vs_conn.c                                |   8 +-
 net/netfilter/nf_conntrack_core.c                              |  55 ++-
 net/netfilter/nf_synproxy_core.c                               |   5 +-
 net/netfilter/nf_tables_api.c                                  |  82 ++--
 net/netfilter/nf_tables_core.c                                 |   6 +-
 net/netfilter/nft_ct.c                                         |  16 +-
 net/netfilter/nft_log.c                                        |   5 +-
 net/netfilter/nft_lookup.c                                     |   1 +
 net/netfilter/nft_queue.c                                      |   4 +-
 net/netfilter/nft_rbtree.c                                     |  16 +-
 net/netfilter/nft_reject.c                                     |  89 +---
 net/netfilter/nft_reject_inet.c                                |  63 +++
 net/netfilter/xt_CT.c                                          |   7 +-
 net/openvswitch/datapath.c                                     |  23 +-
 net/openvswitch/flow_table.c                                   |  88 ++--
 net/openvswitch/flow_table.h                                   |   2 +-
 net/sctp/ipv6.c                                                |   2 +
 net/sunrpc/svc_xprt.c                                          |   6 +-
 net/wireless/core.c                                            |  17 +-
 net/wireless/core.h                                            |   4 +-
 net/wireless/nl80211.c                                         |  32 +-
 net/wireless/nl80211.h                                         |   8 +-
 net/wireless/scan.c                                            |  40 +-
 net/wireless/sme.c                                             |   2 +-
 144 files changed, 2454 insertions(+), 799 deletions(-)
 delete mode 100644 drivers/net/irda/ep7211-sir.c
 create mode 100644 drivers/net/usb/sr9800.c
 create mode 100644 drivers/net/usb/sr9800.h
 create mode 100644 include/net/netfilter/nft_reject.h
 create mode 100644 net/ipv4/netfilter/nft_reject_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_reject_ipv6.c
 create mode 100644 net/netfilter/nft_reject_inet.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
