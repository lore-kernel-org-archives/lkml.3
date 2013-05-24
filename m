Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab3EXH5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:57:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41351 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013Ab3EXH5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:57:14 -0400
Date: Fri, 24 May 2013 00:57:10 -0700 (PDT)
Message-Id: <20130524.005710.1887403608413950326.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4O7vNZO010059


It's been a while since my last pull request so quite a few
fixes have piled up.

1) Fix nf_{log,queue} compilation with PROC_FS disabled, from
   Pablo Neira Ayuso.

2) Fix data corruption on some tg3 chips with TSO enabled, from
   Michael Chan.

3) Fix double insertion of VLAN tags in be2net driver, from Sarveshwar
   Bandi.

4) Don't have TCP's MD5 support pass > PAGE_SIZE page offsets in
   scatter-gather entries into the crypto layer, the crypto layer
   can't handle that.  From Eric Dumazet.

5) Fix lockdep splat in 802.1Q MRP code, also from Eric Dumazet.

6) Fix OOPS in netfilter log module when called from conntrack,
   from Hans Schillstrom.

7) FEC driver needs to use netif_tx_{lock,unlock}_bh() rather than the
   non-BH disabling variants.  From Fabio Estevam.

8) TCP GSO can generate out-of-order packets, fix from Eric Dumazet.

9) vxlan driver doesn't update 'used' field of fdb entries when it should,
   from Sridhar Samudrala.

10) ipv6 should use kzalloc() to allocate inet6 socket cork options,
    otherwise we can OOPS in ip6_cork_release().  From Eric Dumazet.

11) Fix races in bonding set mode, from Nikolay Aleksandrov.

12) Fix checksum generation regression added by "r8169: fix 8168evl
    frame padding.", from Francois Romieu.

13) ip_gre can look at stale SKB data pointer, fix from Eric Dumazet.

14) Fix checksum handling when GSO is enabled in bnx2x driver with
    certain chips, from Yuval Mintz.

15) Fix double free in batman-adv, from Martin Hundeb√∏ll.

16) Fix device startup synchronization with firmware in tg3 driver,
    from Nithin Sujit.

17) perf networking dropmonitor doesn't work at all due to mixed up
    trace parameter ordering, from Ben Hutchings.

18) Fix proportional rate reduction handling in tcp_ack(), from
    Nandita Dukkipati.

19) IPSEC layer doesn't return an error when a valid state is
    detected, causing an OOPS.  Fix from Timo Ter√§s.

Please pull, thanks a lot!

The following changes since commit dbbffe6898fd0d7bac66ded5d3c58835b13ddefc:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-05-13 13:25:36 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to 950e2958a5e96406e6e5ff4190a638a54769f89b:

  be2net: bug fix on returning an invalid nic descriptor (2013-05-23 18:56:40 -0700)

----------------------------------------------------------------
Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID

Alexander Bondar (1):
      iwlwifi: mvm: Prevent setting assoc flag in MAC_CONTEXT_CMD

Andrew Lunn (1):
      mv643xx_eth: fix NAPI weight being > 64

Arend van Spriel (1):
      brcmfmac: announce P2P_DEVICE support in wiphy structure

Ben Hutchings (7):
      sfc: Delete EFX_PAGE_IP_ALIGN, equivalent to NET_IP_ALIGN
      sfc: Reduce RX scatter buffer size, and reduce alignment if appropriate
      perf: net_dropmonitor: Fix trace parameter order
      perf: net_dropmonitor: Fix symbol-relative addresses
      perf: net_dropmonitor: Do not assume ordering of dictionaries
      perf: net_dropmonitor: Use bisection in symbol lookup
      perf: net_dropmonitor: Remove progress indicator

Chen Gang (1):
      net: irda: using kzalloc() instead of kmalloc() to avoid strncpy() issue.

Dan Carpenter (2):
      ipg: fix an unsigned widening cast of '~' truncation issue
      isdn/kcapi: fix a small underflow

David S. Miller (6):
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf
      Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless
      Merge branch 'perf_net_dropmonitor'
      Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
      net: Revert unused variable changes.

Denis Efremov (1):
      iwlegacy: remove inline marking of EXPORT_SYMBOL functions

Emilio L√≥pez (3):
      net: ethernet: apple: drop unused variable
      net: ethernet: korina: drop unused variable
      net: ethernet: sun: drop unused variable

Emmanuel Grumbach (2):
      iwlwifi: mvm: tell firmware to let multicast frames in
      iwlwifi: mvm: fix aggregation drain flow

Eric Dumazet (7):
      tcp: fix tcp_md5_hash_skb_data()
      net/802/mrp: fix lockdep splat
      tcp: gso: do not generate out of order packets
      bonding: allow TSO being set on bonding master
      ipv6: fix possible crashes in ip6_cork_release()
      ip_gre: fix a possible crash in ipgre_err()
      tcp: xps: fix reordering issues

Fabio Estevam (2):
      fec: Fix inconsistent lock state
      fec: Invert the order of function calls in fec_restart()

Felix Fietkau (4):
      mac80211: fix spurious RCU warning and update documentation
      ath9k: fix aggregation stop/flush handling
      ath9k: fix rate handling/reporting
      ath9k: fix draining aggregation tid buffers

Florian Fainelli (1):
      broadcom: add include guards to include/linux/brcmphy.h

Geert Uytterhoeven (1):
      net/wireless: ATH9K should depend on HAS_DMA

Hans Schillstrom (1):
      netfilter: log: netns NULL ptr bug when calling from conntrack

Hans-Christoph Schemmel (1):
      qmi_wwan: Added support for Cinterion's PLxx WWAN Interface

Ilan Peer (2):
      nl80211: Add wdev identifier to some nl80211 notifications
      iwlwifi: mvm: Always use SCAN_TYPE_FORCED

Jason Wang (1):
      virtio_net: enable napi for all possible queues during open

Johannes Berg (9):
      cfg80211: fix wiphy_register error path
      cfg80211: fix WoWLAN wakeup tracing
      mac80211: fix IEEE80211_SDATA_DISCONNECT_RESUME
      mac80211: fix HT beacon-based channel switch handling
      mac80211: use just spin_lock() in ieee80211_get_tkip_p2k()
      mac80211: fix AP-mode frame matching
      cfg80211: fix interface down/disconnect state handling
      mac80211: report deauth to cfg80211 for local state change
      cfg80211: fix sending WoWLAN TCP wakeup settings

John W. Linville (2):
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Larry Finger (1):
      rtlwifi: rtl8188ee: Fix warning when building on big-endian systems

Linus L√ºssing (1):
      batman-adv: Fix rcu_barrier() miss due to double call_rcu() in TT code

Martin Hundeb√∏ll (1):
      batman-adv: Avoid double freeing of bat_counters

Michael Chan (1):
      tg3: Fix data corruption on 5725 with TSO

Nandita Dukkipati (1):
      tcp: bug fix in proportional rate reduction.

Nicolas Ferre (1):
      net/macb: fix ISR clear-on-write behavior only for some SoC

Nithin Sujir (3):
      tg3: Skip powering down function 0 on certain serdes devices
      tg3: Ensure boot code has completed initialization before accessing hardware
      tg3: Update version to 3.132

Pablo Neira Ayuso (3):
      netfilter: nf_{log,queue}: fix compilation without CONFIG_PROC_FS
      netfilter: update MAINTAINERS file
      netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary

Paul Moore (1):
      netlabel: improve domain mapping validation

Petko Manolov (1):
      drivers: net: usb: rtl8150: concurrent URB bugfix

Rafa≈Ç Mi≈Çecki (1):
      bcma: add more core IDs

Russell King (1):
      NET: mv643xx_eth: avoid lockdep dump on interface down

Sarveshwar Bandi (1):
      be2net: Avoid double insertion of vlan tags.

Sasha Levin (1):
      mac80211_hwsim: correctly register the platform driver

Shahed Shaikh (1):
      qlcnic: Fix updating netdev->features

Shawn Guo (1):
      net: fec: use a more proper compatible string for MVF type device

Sony Chacko (2):
      qlcnic: Return proper error codes from probe failure paths
      qlcnic: remove netdev->trans_start updates within the driver

Sridhar Samudrala (1):
      vxlan: Update vxlan fdb 'used' field after each usage

Sujith Manoharan (2):
      ath9k: Fix crash on module unload
      ath9k_hw: Enable manual peak calibration for AR9485

Timo Ter√§s (1):
      xfrm: properly handle invalid states as an error

Wei Yang (1):
      be2net: bug fix on returning an invalid nic descriptor

Wei Yongjun (1):
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Yuval Mintz (1):
      bnx2x: Fix GSO for 57710/57711 chips

fran√ßois romieu (1):
      r8169: fix offloaded tx checksum for small packets.

nikolay@redhat.com (4):
      bonding: fix set mode race conditions
      bonding: replace %x with %pI4 for IPv4 addresses
      bonding: arp_ip_count and arp_targets can be wrong
      bonding: fix multiple 3ad mode sysfs race conditions

stephen hemminger (1):
      8139cp: reset BQL when ring tx ring cleared

 MAINTAINERS                                              |  10 +++---
 drivers/bcma/scan.c                                      |   2 ++
 drivers/isdn/capi/kcapi.c                                |   6 ++--
 drivers/net/bonding/bond_3ad.c                           |  21 ++++++++---
 drivers/net/bonding/bond_3ad.h                           |   2 ++
 drivers/net/bonding/bond_main.c                          |  26 +++++++-------
 drivers/net/bonding/bond_procfs.c                        |   2 +-
 drivers/net/bonding/bond_sysfs.c                         |  13 ++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c          |   9 +++--
 drivers/net/ethernet/broadcom/tg3.c                      |  61 ++++++++++++++++++++++++-------
 drivers/net/ethernet/cadence/macb.c                      |  18 ++++++++--
 drivers/net/ethernet/cadence/macb.h                      |   7 ++++
 drivers/net/ethernet/emulex/benet/be_cmds.c              |  13 +++----
 drivers/net/ethernet/emulex/benet/be_main.c              |  18 +++-------
 drivers/net/ethernet/freescale/fec_main.c                |  14 ++++----
 drivers/net/ethernet/freescale/gianfar_ptp.c             |   1 +
 drivers/net/ethernet/icplus/ipg.h                        |  86 ++++++++++++++++++++++----------------------
 drivers/net/ethernet/marvell/mv643xx_eth.c               |   6 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h              |   6 ++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c    |   2 --
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c           |  49 ++++++++++++++++++++++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c         |  65 +++++++++------------------------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c |   1 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c        |   3 ++
 drivers/net/ethernet/realtek/8139cp.c                    |   1 +
 drivers/net/ethernet/realtek/r8169.c                     |  41 +++++++++++++--------
 drivers/net/ethernet/sfc/efx.c                           |   8 +++--
 drivers/net/ethernet/sfc/net_driver.h                    |  31 ++++++++--------
 drivers/net/ethernet/sfc/rx.c                            |   8 ++---
 drivers/net/usb/qmi_wwan.c                               |   1 +
 drivers/net/usb/rtl8150.c                                | 100 ++++++++++++++++++++++++---------------------------
 drivers/net/virtio_net.c                                 |   9 ++---
 drivers/net/vxlan.c                                      |  17 +++++++--
 drivers/net/wireless/ath/ath9k/ar9003_calib.c            |   2 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h         |   2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h                   |   4 ++-
 drivers/net/wireless/ath/ath9k/debug.c                   |   8 +++++
 drivers/net/wireless/ath/ath9k/debug.h                   |   5 +++
 drivers/net/wireless/ath/ath9k/init.c                    |  10 +++---
 drivers/net/wireless/ath/ath9k/main.c                    |   8 +++--
 drivers/net/wireless/ath/ath9k/xmit.c                    |  74 ++++++++++++++++++++++++--------------
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c    |   7 +++-
 drivers/net/wireless/iwlegacy/common.c                   |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                |  27 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c              |  12 ++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c              |  17 ++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h                   |   1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c                   |   1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c                  |   6 ++++
 drivers/net/wireless/iwlwifi/mvm/sta.c                   |  13 +++++--
 drivers/net/wireless/iwlwifi/mvm/sta.h                   |   2 --
 drivers/net/wireless/iwlwifi/mvm/tx.c                    |  48 ++++++++++++++++++-------
 drivers/net/wireless/mac80211_hwsim.c                    |  18 +++++-----
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.h             |   4 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c              |   1 +
 include/linux/bcma/bcma.h                                |   5 ++-
 include/linux/brcmphy.h                                  |   5 +++
 include/linux/netdevice.h                                |  11 ++++++
 include/net/mac80211.h                                   |  12 ++++---
 include/net/netfilter/nf_log.h                           |   3 +-
 include/net/netfilter/nfnetlink_log.h                    |   3 +-
 net/802/mrp.c                                            |   4 +--
 net/batman-adv/main.c                                    |   1 +
 net/batman-adv/originator.c                              |  16 +++++++++
 net/batman-adv/originator.h                              |   1 +
 net/batman-adv/soft-interface.c                          |   1 +
 net/batman-adv/translation-table.c                       |   7 +++-
 net/bridge/netfilter/ebt_log.c                           |  11 +++---
 net/bridge/netfilter/ebt_ulog.c                          |  18 ++++++----
 net/ipv4/ip_gre.c                                        |   3 +-
 net/ipv4/netfilter/ipt_ULOG.c                            |  13 ++++---
 net/ipv4/tcp.c                                           |  29 +++++++++++++--
 net/ipv4/tcp_input.c                                     |  23 ++++++------
 net/ipv4/tcp_output.c                                    |  10 +++---
 net/ipv6/ip6_output.c                                    |   2 +-
 net/irda/irlap_frame.c                                   |   2 +-
 net/mac80211/ieee80211_i.h                               |   1 +
 net/mac80211/mlme.c                                      |  61 +++++++++++++++++++++++++------
 net/mac80211/rate.c                                      |   9 ++++-
 net/mac80211/rx.c                                        |   3 ++
 net/mac80211/tkip.c                                      |   4 +--
 net/mac80211/util.c                                      |   7 ++++
 net/netfilter/nf_log.c                                   |   7 ++--
 net/netfilter/nfnetlink_log.c                            |   6 ++--
 net/netfilter/nfnetlink_queue_core.c                     |   2 ++
 net/netfilter/xt_LOG.c                                   |  13 +++----
 net/netfilter/xt_NFLOG.c                                 |   3 +-
 net/netfilter/xt_TCPOPTSTRIP.c                           |  17 +++++++--
 net/netlabel/netlabel_domainhash.c                       |  69 +++++++++++++++++++++++++++++++++++
 net/wireless/core.c                                      |  17 +++++----
 net/wireless/nl80211.c                                   |   4 +++
 net/wireless/sme.c                                       |   3 +-
 net/wireless/trace.h                                     |  23 ++++++------
 net/xfrm/xfrm_output.c                                   |   1 +
 tools/perf/scripts/python/net_dropmonitor.py             |  39 ++++++++++----------
 95 files changed, 937 insertions(+), 461 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
