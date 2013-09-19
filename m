Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3ISSzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:55:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53784 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3ISSzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:55:40 -0400
Date: Thu, 19 Sep 2013 14:55:36 -0400 (EDT)
Message-Id: <20130919.145536.1928298807165270176.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Sep 2013 11:55:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8JIu8Sp027929


1) If the local_df boolean is set on an SKB we have to allocate a
   unique ID even if IP_DF is set in the ipv4 headers, from Ansis
   Atteka.

2) Some fixups for the new chipset support that went into the sfc
   driver, from Ben Hutchings.

3) Because SCTP bypasses a good chunk of, and actually duplicates, the
   logic of the ipv6 output path, some IPSEC things don't get done
   properly.  Integrate SCTP better into the ipv6 output path so
   that these problems are fixed and such issues don't get missed
   in the future either.  From Daniel Borkmann.

4) Fix skge regressions added by the DMA mapping error return
   checking added in v3.10, from Mikulas Patocka.

5) Kill some more IRQF_DISABLED references, from Michael Opdenacker.

6) Fix races and deadlocks in the bridging code, from Hong Zhiguo.

7) Fix error handling in tun_set_iff(), in particular don't leak
   resources.  From Jason Wang.

8) Prevent format-string injection into xen-netback driver, from
   Kees Cook.

9) Fix regression added to netpoll ARP packet handling, in particular
   check for the right ETH_P_ARP protocol code.  From Sonic Zhang.

10) Try to deal with AMD IOMMU errors when using r8169 chips, from
    Francois Romieu.

11) Cure freezes due to recent changes in the rt2x00 wireless driver,
    from Stanislaw Gruszka.

12) Don't do SPI transfers (which can sleep) in interrupt context
    in cw1200 driver, from Solomon Peachy.

13) Fix LEDs handling bug in 5720 tg3 chips already handled for 5719.
    From Nithin Sujir.

14) Make xen_netbk_count_skb_slots() count the actual number of slots
    that will be used, taking into consideration packing and other
    issues that the transmit path will run into.  From David
    Vrabel.

15) Use the correct maximum age when calculating the bridge
    message_age_timer, from Chris Healy.

16) Get rid of memory leaks in mcs7780 IRDA driver, from Alexey
    Khoroshilov.

17) Netfilter conntrack extensions were converted to RCU but
    are not always freed properly using kfree_rcu().  Fix
    from Michal Kubecek.

18) VF reset recovery not being done correctly in qlcnic driver,
    from Manish Chopra.

19) Fix inverted test in ATM nicstar driver, from Andy Shevchenko.

20) Missing workqueue destroy in cxgb4 error handling, from Wei Yang.

21) Internal switch not initialized properly in bgmac driver, from
    Rafa≈Ç Mi≈Çecki.

22) Netlink messages report wrong local and remote addresses in
    IPv6 tunneling, from Ding Zhi.

23) ICMP redirects should not generate socket errors in DCCP and
    SCTP.  We're still working out how this should be handled
    for RAW and UDP sockets.  From Daniel Borkmann and Duan Jiong.

24) We've had several bugs wherein the network namespace's loopback
    device gets accessed after it is free'd, NULL it out so that we
    can catch these problems more readily.  From Eric W. Biederman.

25) Fix regression in TCP RTO calculations, from Neal Cardwell.

26) Fix too early free of xen-netback network device when VIFs
    still exist.  From Paul Durrant.

Please pull, thanks a lot.

The following changes since commit d5d04bb48f0eb89c14e76779bb46212494de0bec:

  Bye, bye, WfW flag (2013-09-11 19:55:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to c71380ff0b199f1e8be5ca46dd91262f7fbe4cb4:

  netconsole: fix a deadlock with rtnl and netconsole's mutex (2013-09-19 14:15:53 -0400)

----------------------------------------------------------------
Alexey Khoroshilov (2):
      rtl8187: fix use after free on failure path in rtl8187_init_urbs()
      net/irda/mcs7780: fix memory leaks in mcs_net_open()

Andy Shevchenko (1):
      atm: nicstar: fix regression made by previous patch

Ansis Atteka (2):
      ip: use ip_hdr() in __ip_make_skb() to retrieve IP header
      ip: generate unique IP identificator if local fragmentation is allowed

Antonio Alecrim Jr (2):
      be2net: missing variable initialization
      isdn: hfcpci_softirq: get func return to suppress compiler warning

Antonio Quartulli (1):
      batman-adv: set the TAG flag for the vid passed to BLA

Arend van Spriel (1):
      brcmfmac: fix bus interface selection in Kconfig

Avinash Kumar (1):
      drivers: net: phy: cicada.c: clears warning Use #include <linux/io.h> instead of <asm/io.h>

Ben Hutchings (5):
      sfc: Minimal support for 40G link speed
      sfc: Disable PTP on EF10 until we're ready to handle inline RX timestamps
      sfc: Reset derived rx_bad_bytes statistic when EF10 MC is rebooted
      sfc: Clean up validation of datapath capabilities
      sfc: Reinitialise and re-validate datapath caps after MC reboot

Carolyn Wyborny (1):
      igb: Add additional get_phy_id call for i354 devices

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Daniel Borkmann (2):
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit
      net: sctp: rfc4443: do not report ICMP redirects to user space

David Ertman (2):
      e1000e: cleanup boolean comparison to true
      e1000e: fix overrun of PHY RAR array

David S. Miller (5):
      Merge tag 'master-2013-09-09' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net
      Merge branch 'sfc-3.12' of git://git.kernel.org/.../bwh/sfc
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf
      Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge

David Vrabel (1):
      xen-netback: count number required slots for an skb more carefully

Ding Zhi (1):
      ip6_tunnels: raddr and laddr are inverted in nl msg

Duan Jiong (1):
      net:dccp: do not report ICMP redirects to user space

Emil Tantilov (3):
      ixgbe: fix ethtool loopback diagnostic with DCB enabled
      ixgbe: limit setting speed to only one at a time for QSFP modules
      ixgbe: fix ethtool reporting of supported links for SFP modules

Eric W. Biederman (1):
      net loopback: Set loopback_dev to NULL when freed

Eugenia Emantayev (1):
      net/mlx4_en: Check device state when setting coalescing

Fabio Porcedda (3):
      net: usb: cdc_ether: Use wwan interface for Telit modules
      net: usb: cdc_ether: fix checkpatch errors and warnings
      net: usb: cdc_ether: use usb.h macros whenever possible

Fujinaka, Todd (1):
      igb: Read flow control for i350 from correct EEPROM section

Gao feng (1):
      netfilter: nfnetlink_queue: use network skb for sequence adjustment

Hauke Mehrtens (2):
      bcma: fix error code handling on 64 Bit systems
      bgmac: allow bigger et_swtype nvram variable

Herbert Xu (1):
      bridge: Clamp forward_delay when enabling STP

Hong Zhiguo (2):
      bridge: use br_port_get_rtnl within rtnl lock
      bridge: fix NULL pointer deref of br_port_get_rcu

Jacob Keller (1):
      ixgbe: fully disable hardware RSC logic when disabling RSC

Jason Wang (1):
      tuntap: correctly handle error in tun_set_iff()

Jon Mason (2):
      bnx2x: Use pci_dev pm_cap
      tg3: Use pci_dev pm_cap

Joseph Gasparakis (1):
      vxlan: Fix sparse warnings

Jozsef Kadlecsik (3):
      netfilter: ipset: Skip really non-first fragments for IPv6 when getting port/protocol
      netfilter: ipset: Consistent userspace testing with nomatch flag
      netfilter: ipset: Validate the set family and not the set type family at swapping

Kees Cook (2):
      xen-netback: fix possible format string flaw
      isdn: clean up debug format string usage

Libo Chen (1):
      drivers/atm/he.c: convert to module_pci_driver

Manish Chopra (1):
      qlcnic: Fix VF reset recovery

Michael Chan (2):
      bnx2x, cnic, bnx2i, bnx2fc: Fix bnx2i and bnx2fc regressions.
      cnic: Fix crash in cnic_bnx2x_service_kcq()

Michael Opdenacker (13):
      bfin_mac: remove deprecated IRQF_DISABLED
      ehea: remove deprecated IRQF_DISABLED
      ethernet: amd: remove deprecated IRQF_DISABLED
      net: tulip: remove deprecated IRQF_DISABLED
      net: fec: remove deprecated IRQF_DISABLED
      net: hp100: remove deprecated IRQF_DISABLED
      net: lantiq_etop: remove deprecated IRQF_DISABLED
      net: pxa168_eth: remove deprecated IRQF_DISABLED
      net: ks8851-ml: remove deprecated IRQF_DISABLED
      net: natsemi: remove deprecated IRQF_DISABLED
      net: pasemi: remove deprecated IRQF_DISABLED
      net: smsc: remove deprecated IRQF_DISABLED
      net: ps3_gelic: remove deprecated IRQF_DISABLED

Michal Kubeƒçek (1):
      netfilter: nf_conntrack: use RCU safe kfree for conntrack extensions

Mikulas Patocka (1):
      skge: fix broken driver

Neal Cardwell (1):
      tcp: fix RTO calculated from cached RTT

Neil Horman (1):
      bonding: Make alb learning packet interval configurable

Nikolay Aleksandrov (2):
      netpoll: fix NULL pointer dereference in netpoll_cleanup
      netconsole: fix a deadlock with rtnl and netconsole's mutex

Nithin Sujir (1):
      tg3: Expand led off fix to include 5720

Olaf Hering (1):
      drivers/net/ethernet/ibm/ehea/ehea_main.c: add alias entry for portN properties

Oliver Smith (1):
      netfilter: ipset: Fix serious failure in CIDR tracking

Paul Durrant (1):
      xen-netback: Don't destroy the netdev until the vif is shut down

Phil Oester (1):
      netfilter: nf_nat_proto_icmpv6:: fix wrong comparison in icmpv6_manip_pkt

Rafa≈Ç Mi≈Çecki (2):
      bgmac: fix internal switch initialization
      bgmac: implement unaligned addressing for DMA rings that support it

Solomon Peachy (2):
      cw1200: Don't perform SPI transfers in interrupt context
      cw1200: Prevent a lock-related hang in the cw1200_spi driver

Sonic Zhang (1):
      netpoll: Should handle ETH_P_ARP other than ETH_P_IP in netpoll_neigh_reply

Sridhar Samudrala (1):
      vxlan: Avoid creating fdb entry with NULL destination

Stanislaw Gruszka (1):
      rt2800: change initialization sequence to fix system freeze

Wei Yang (1):
      cxgb4: remove workqueue when driver registration fails

Yijing Wang (1):
      alx: remove redundant D0 power state set

fran√ßois romieu (1):
      r8169: enforce RX_MULTI_EN for the 8168f.

 Documentation/networking/bonding.txt                     |   6 +++
 drivers/atm/he.c                                         |  13 +-----
 drivers/atm/nicstar.c                                    |   2 +-
 drivers/bcma/scan.c                                      |  12 +++---
 drivers/isdn/hardware/mISDN/hfcpci.c                     |   4 +-
 drivers/isdn/hisax/amd7930_fn.c                          |   4 +-
 drivers/isdn/hisax/avm_pci.c                             |   4 +-
 drivers/isdn/hisax/config.c                              |   2 +-
 drivers/isdn/hisax/diva.c                                |   4 +-
 drivers/isdn/hisax/elsa.c                                |   2 +-
 drivers/isdn/hisax/elsa_ser.c                            |   2 +-
 drivers/isdn/hisax/hfc_pci.c                             |   2 +-
 drivers/isdn/hisax/hfc_sx.c                              |   2 +-
 drivers/isdn/hisax/hscx_irq.c                            |   4 +-
 drivers/isdn/hisax/icc.c                                 |   4 +-
 drivers/isdn/hisax/ipacx.c                               |   8 ++--
 drivers/isdn/hisax/isac.c                                |   4 +-
 drivers/isdn/hisax/isar.c                                |   6 +--
 drivers/isdn/hisax/jade.c                                |  18 +++------
 drivers/isdn/hisax/jade_irq.c                            |   4 +-
 drivers/isdn/hisax/l3_1tr6.c                             |  50 +++++++++---------------
 drivers/isdn/hisax/netjet.c                              |   2 +-
 drivers/isdn/hisax/q931.c                                |   6 +--
 drivers/isdn/hisax/w6692.c                               |   8 ++--
 drivers/net/bonding/bond_alb.c                           |   2 +-
 drivers/net/bonding/bond_alb.h                           |   9 +++--
 drivers/net/bonding/bond_main.c                          |   1 +
 drivers/net/bonding/bond_sysfs.c                         |  39 ++++++++++++++++++
 drivers/net/bonding/bonding.h                            |   1 +
 drivers/net/ethernet/adi/bfin_mac.c                      |   4 +-
 drivers/net/ethernet/amd/sun3lance.c                     |   2 +-
 drivers/net/ethernet/atheros/alx/main.c                  |   9 +----
 drivers/net/ethernet/broadcom/bgmac.c                    |  44 +++++++++++++++------
 drivers/net/ethernet/broadcom/bgmac.h                    |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h              |  37 ++++++++++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c          |   8 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c      |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c         |  14 ++++---
 drivers/net/ethernet/broadcom/cnic.c                     |   6 ++-
 drivers/net/ethernet/broadcom/tg3.c                      |   6 +--
 drivers/net/ethernet/broadcom/tg3.h                      |   1 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c          |   4 +-
 drivers/net/ethernet/dec/tulip/de4x5.c                   |   2 +-
 drivers/net/ethernet/emulex/benet/be_main.c              |   2 +-
 drivers/net/ethernet/freescale/fec_main.c                |   2 +-
 drivers/net/ethernet/hp/hp100.c                          |   2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c                |  21 +++++++---
 drivers/net/ethernet/intel/e1000e/ethtool.c              |   8 ++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c              |  13 +++---
 drivers/net/ethernet/intel/e1000e/ich8lan.h              |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c               |   2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c             |   4 ++
 drivers/net/ethernet/intel/igb/e1000_mac.c               |  10 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c         |  25 ++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c            |  19 ++++++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h            |   1 +
 drivers/net/ethernet/lantiq_etop.c                       |   6 +--
 drivers/net/ethernet/marvell/pxa168_eth.c                |   3 +-
 drivers/net/ethernet/marvell/skge.c                      |   5 ++-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c          |  16 +++++---
 drivers/net/ethernet/micrel/ks8851_mll.c                 |   2 +-
 drivers/net/ethernet/natsemi/jazzsonic.c                 |   3 +-
 drivers/net/ethernet/natsemi/xtsonic.c                   |   3 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c                 |   4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c |   1 +
 drivers/net/ethernet/realtek/r8169.c                     |   1 +
 drivers/net/ethernet/sfc/Kconfig                         |   2 +-
 drivers/net/ethernet/sfc/ef10.c                          |  58 +++++++++++++++++----------
 drivers/net/ethernet/sfc/mcdi_port.c                     |   2 +
 drivers/net/ethernet/sfc/nic.h                           |   3 ++
 drivers/net/ethernet/smsc/smc91x.h                       |   2 +-
 drivers/net/ethernet/smsc/smsc9420.c                     |   3 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c             |   2 +-
 drivers/net/irda/mcs7780.c                               |  40 +++++++++++--------
 drivers/net/loopback.c                                   |   1 +
 drivers/net/netconsole.c                                 |   5 +--
 drivers/net/phy/cicada.c                                 |   4 +-
 drivers/net/ppp/pptp.c                                   |   2 +-
 drivers/net/tun.c                                        |  11 ++++--
 drivers/net/usb/cdc_ether.c                              | 115 ++++++++++++++++++++----------------------------------
 drivers/net/vxlan.c                                      |  40 ++++++++++---------
 drivers/net/wireless/brcm80211/Kconfig                   |   4 +-
 drivers/net/wireless/cw1200/cw1200_spi.c                 |  28 +++++++++++--
 drivers/net/wireless/cw1200/fwio.c                       |   2 +-
 drivers/net/wireless/cw1200/hwbus.h                      |   1 +
 drivers/net/wireless/cw1200/hwio.c                       |  15 +++++++
 drivers/net/wireless/rt2x00/rt2800lib.c                  |  11 +++---
 drivers/net/wireless/rtl818x/rtl8187/dev.c               |  15 ++++---
 drivers/net/xen-netback/common.h                         |   1 +
 drivers/net/xen-netback/interface.c                      |  28 ++++++-------
 drivers/net/xen-netback/netback.c                        |  94 ++++++++++++++++++++++++++++++--------------
 drivers/net/xen-netback/xenbus.c                         |  17 +++++---
 drivers/scsi/bnx2fc/bnx2fc.h                             |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                         |   3 +-
 drivers/scsi/bnx2i/bnx2i.h                               |   2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                           |   3 +-
 include/linux/netdevice.h                                |   8 ++--
 include/linux/netfilter/ipset/ip_set.h                   |   6 ++-
 include/net/ip.h                                         |  12 ++++--
 include/net/netfilter/nf_conntrack_extend.h              |   2 +-
 net/batman-adv/soft-interface.c                          |   2 +
 net/bridge/br_netlink.c                                  |   4 +-
 net/bridge/br_private.h                                  |   8 ++--
 net/bridge/br_stp.c                                      |  23 +++++++----
 net/bridge/br_stp_if.c                                   |  12 +++++-
 net/core/netpoll.c                                       |  11 +++---
 net/dccp/ipv6.c                                          |   1 +
 net/ipv4/igmp.c                                          |   4 +-
 net/ipv4/inetpeer.c                                      |   4 +-
 net/ipv4/ip_output.c                                     |   8 ++--
 net/ipv4/ipmr.c                                          |   2 +-
 net/ipv4/raw.c                                           |   2 +-
 net/ipv4/tcp_metrics.c                                   |   4 +-
 net/ipv4/xfrm4_mode_tunnel.c                             |   2 +-
 net/ipv6/ip6_tunnel.c                                    |   4 +-
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c                 |   4 +-
 net/netfilter/ipset/ip_set_core.c                        |   5 +--
 net/netfilter/ipset/ip_set_getport.c                     |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h                    |  28 +++++++------
 net/netfilter/ipset/ip_set_hash_ipportnet.c              |   4 +-
 net/netfilter/ipset/ip_set_hash_net.c                    |   4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c               |   4 +-
 net/netfilter/ipset/ip_set_hash_netport.c                |   4 +-
 net/netfilter/ipvs/ip_vs_xmit.c                          |   2 +-
 net/netfilter/nfnetlink_queue_core.c                     |   2 +-
 net/sctp/input.c                                         |   3 +-
 net/sctp/ipv6.c                                          |  44 +++++++--------------
 127 files changed, 751 insertions(+), 517 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
