Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaCXTue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:50:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43834 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaCXTub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:50:31 -0400
Date: Mon, 24 Mar 2014 15:50:28 -0400 (EDT)
Message-Id: <20140324.155028.938038104862556076.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Mar 2014 12:50:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) OpenVswitch's lookup_datapath() returns error pointers, so don't check
   against NULL.  From Jiri Pirko.

2) pfkey_compile_policy() code path tries to do a GFP_KERNEL allocation
   under RCU locks, fix by using GFP_ATOMIC when necessary.  From
   Nikolay Aleksandrov.

3) phy_suspend() indirectly passes uninitialized data into the ethtool get
   wake-on-land implementations.  Fix from Sebastian Hesselbarth.

4) CPSW driver unregisters CPTS twice, fix from Benedikt Spranger.

5) If SKB allocation of reply packet fails, vxlan's arp_reduce() defers
   a NULL pointer.  Fix from David Stevens.

6) IPV6 neigh handling in vxlan doesn't validate the destination address
   properly, and it builds a packet with the src and dst reversed.  Fix
   also from David Stevens.

7) Fix spinlock recursion during subscription failures in TIPC stack, from	
   Erik Hugne.

8) Revert buggy conversion of davinci_emac to devm_request_irq, from Chrstian
   Riesch.

9) Wrong flags passed into forwarding database netlink notifications, from
   Nicolas Dichtel.

10) The netpoll neighbour soliciation handler checks wrong ethertype,
    needs to be ETH_P_IPV6 rather than ETH_P_ARP.  Fix from Li RongQing.

Please pull, thanks a lot!

The following changes since commit a4ecdf82f8ea49f7d3a072121dcbd0bf3a7cb93a:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-03-14 18:07:51 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to a5d0e7c037119484a7006b883618bfa87996cb41:

  tipc: fix spinlock recursion bug for failed subscriptions (2014-03-24 15:36:56 -0400)

----------------------------------------------------------------
Ben Pfaff (1):
      openvswitch: Correctly report flow used times for first 5 minutes after boot.

Benedikt Spranger (1):
      net: cpsw: do not register cpts twice

Bjørn Mork (1):
      net: cdc_ncm: fix control message ordering

Christian Riesch (2):
      net: davinci_emac: Replace devm_request_irq with request_irq
      net: davinci_emac: Fix rollback of emac_dev_open()

Dave Jones (1):
      brcmfmac: fix skb leak in brcmf_sdio_txpkt_prep_sg error path.

David S. Miller (5):
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge branch 'cnic-net'
      Merge branch 'fixes' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'davinci_emac'

David Stevens (2):
      vxlan: fix potential NULL dereference in arp_reduce()
      vxlan: fix nonfunctional neigh_reduce()

Eric Dumazet (1):
      tcp: syncookies: do not use getnstimeofday()

Erik Hugne (1):
      tipc: fix spinlock recursion bug for failed subscriptions

Felix Fietkau (1):
      ath9k_hw: fix unreachable code in baseband hang detection code

Helmut Schaa (1):
      ath9k: Fix sequence number assignment for non-data frames

Jarno Rajahalme (2):
      openvswitch: Read tcp flags only then the tranport header is present.
      openvswitch: Fix race.

Jiri Pirko (1):
      ovs: fix dp check in ovs_dp_reset_user_features

Joe Perches (1):
      MAINTAINERS: Add linux.nics@intel.com to INTEL ETHERNET DRIVERS

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Li RongQing (1):
      netpoll: fix the skb check in pkt_is_ns

Michael Chan (3):
      cnic: Use proper ulp_ops for per device operations.
      cnic,bnx2i,bnx2fc: Fix inconsistent use of page size
      cnic: Update version to 2.5.20 and copyright year.

Nicolas Dichtel (3):
      rtnetlink: fix fdb notification flags
      ipmr: fix mfc notification flags
      ip6mr: fix mfc notification flags

Nikolay Aleksandrov (2):
      net: af_key: fix sleeping under rcu
      selinux: add gfp argument to security_xfrm_policy_alloc and fix callers

Nishanth Menon (1):
      net: micrel : ks8851-ml: add vdd-supply support

Paul Bolle (1):
      isdn/capi: Make Middleware depend on CAPI2.0

Peter Senna Tschudin (2):
      ATHEROS-ALX: Use dma_set_mask_and_coherent and fix a bug
      ATHEROS-ATL1E: Convert iounmap to pci_iounmap

Roger Luethi (1):
      via-rhine: Disable device in error path

Sebastian Hesselbarth (1):
      net: phy: fix uninitalized ethtool_wolinfo in phy_suspend

Stanislaw Gruszka (1):
      Revert "rt2x00: rt2800lib: Update BBP register initialization for RT53xx"

lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the second fragment properly

stephen hemminger (1):
      netlink: fix setsockopt in mmap examples in documentation

 Documentation/devicetree/bindings/net/micrel-ks8851.txt |   1 +
 Documentation/networking/netlink_mmap.txt               |   4 +--
 MAINTAINERS                                             |   1 +
 drivers/isdn/capi/Kconfig                               |  18 +++++-----
 drivers/net/ethernet/atheros/alx/main.c                 |  14 +++-----
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c         |   4 +--
 drivers/net/ethernet/broadcom/cnic.c                    | 111 ++++++++++++++++++++++++++++++------------------------------
 drivers/net/ethernet/broadcom/cnic.h                    |   2 +-
 drivers/net/ethernet/broadcom/cnic_defs.h               |   2 +-
 drivers/net/ethernet/broadcom/cnic_if.h                 |  16 +++++++--
 drivers/net/ethernet/micrel/ks8851.c                    |  30 ++++++++++++++++-
 drivers/net/ethernet/ti/cpsw.c                          |   4 ---
 drivers/net/ethernet/ti/davinci_cpdma.c                 |   4 +--
 drivers/net/ethernet/ti/davinci_emac.c                  |  53 +++++++++++++++++++++++------
 drivers/net/ethernet/via/via-rhine.c                    |   8 +++--
 drivers/net/phy/phy_device.c                            |   3 +-
 drivers/net/usb/cdc_ncm.c                               |  48 +++++++++++++-------------
 drivers/net/vxlan.c                                     | 130 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/hw.c                     |   3 +-
 drivers/net/wireless/ath/ath9k/xmit.c                   |   4 +--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c      |   4 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c                 |   6 ++--
 drivers/scsi/bnx2fc/bnx2fc_io.c                         |  16 ++++-----
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                        |  38 +++++++++++----------
 drivers/scsi/bnx2i/bnx2i_hwi.c                          |  52 ++++++++++++++---------------
 drivers/scsi/bnx2i/bnx2i_iscsi.c                        |  23 +++++++------
 include/linux/security.h                                |  10 ++++--
 include/linux/usb/cdc_ncm.h                             |   1 +
 include/net/tcp.h                                       |  11 +++---
 net/core/netpoll.c                                      |   2 +-
 net/core/rtnetlink.c                                    |  10 +++---
 net/ipv4/ipmr.c                                         |  13 +++++---
 net/ipv6/ip6_output.c                                   |  14 ++++----
 net/ipv6/ip6mr.c                                        |  13 +++++---
 net/key/af_key.c                                        |  19 ++++++-----
 net/openvswitch/datapath.c                              |   9 ++---
 net/openvswitch/flow.c                                  |   3 +-
 net/tipc/subscr.c                                       |  29 ++++++++--------
 net/xfrm/xfrm_user.c                                    |   6 ++--
 security/capability.c                                   |   3 +-
 security/security.c                                     |   6 ++--
 security/selinux/hooks.c                                |  13 ++++----
 security/selinux/include/security.h                     |   2 +-
 security/selinux/include/xfrm.h                         |   3 +-
 security/selinux/selinuxfs.c                            |  28 ++++++++++------
 security/selinux/ss/services.c                          |   6 ++--
 security/selinux/xfrm.c                                 |  14 ++++----
 47 files changed, 508 insertions(+), 306 deletions(-)
