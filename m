Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901Ab3BMTWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:22:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43347 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3BMTWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:22:01 -0500
Date: Wed, 13 Feb 2013 14:21:55 -0500 (EST)
Message-Id: <20130213.142155.203725388752600954.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1DJM6K1032661


This is primarily to get those r8169 reverts sorted, but other
fixes have accumulated meanwhile.

1) Revert two r8169 changes to fix suspend/resume for some users,
   from Francois Romieu.

2) PCI dma mapping errors in atl1c are not checked for and this cause
   hard crashes for some users, from Xiong Huang.

3) In 3.8.x we merged the removal of the EXPERIMENTAL dependency for
   'dlm' but the same patch for 'sctp' got lost somewhere, resulting
   in the potential for build errors since there are cross dependencies.
   From Kees Cook.

4) SCTP's ipv6 socket route validation makes boolean tests incorrectly,
   fix from Daniel Borkmann.

5) mac80211 does sizeof(ptr) instead of (sizeof(ptr) * nelem), from Cong
   Ding.

6) arp_rcv() can crash on shared non-linear packets, from Eric Dumazet.

7) Avoid crashes in macvtap by setting ->gso_type consistently in ixgbe,
   qlcnic, and bnx2x drivers.  From Michael S. Tsirkin and Alexander Duyck.

8) Trinity fuzzer spots infinite loop in __skb_recv_datagram(), fix from
   Eric Dumazet.

9) STP protocol frames should use high packet priority, otherwise an
   overloaded bridge can get stuck.  From Stephen Hemminger.

10) The HTB packet scheduler was converted some time ago to store
    internal timestamps in nanoseconds, but we don't convert back into
    psched ticks for the user during dumps.  Fix from Jiri Pirko.

11) mwl8k channel table doesn't set the .band field properly, resulting
    in NULL pointer derefs.  Fix from Jonas Gorski.

12) mac80211 doesn't accumulate channels properly during a scan so we
    can downgrade heavily to a much less desirable connection speed.
    Fix from Johannes Berg.

13) PHY probe failure in stmmac can result in resource leaks and
    double MDIO registery later, from Giuseppe CAVALLARO.

14) Correct ipv6 checksumming in ip6t_NPT netfilter module, also fix
    address prefix mangling, from YOSHIFUJI Hideaki.

Please pull, thanks a lot!

The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39:

  Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to 3bdb1a443a53a4058b95c8a67c856cc8b8393411:

  net, sctp: remove CONFIG_EXPERIMENTAL (2013-02-13 13:57:27 -0500)

----------------------------------------------------------------
Alexander Duyck (1):
      ixgbe: Only set gso_type to SKB_GSO_TCPV4 as RSC does not support IPv6

Bj√∏rn Mork (1):
      net: qmi_wwan: add Yota / Megafon M100-1 4g modem

Cong Ding (1):
      mac80211: fix error in sizeof() usage

Dan Carpenter (1):
      ipvs: freeing uninitialized pointer on error

Daniel Borkmann (2):
      ipvs: sctp: fix checksumming on snat and dnat handlers
      net: sctp: sctp_v6_get_dst: fix boolean test in dst cache

David S. Miller (4):
      Merge branch 'davem.r8169' of git://violet.fr.zoreil.com/romieu/linux
      Merge branch 'gso_type'
      Merge branch 'master' of git://1984.lsi.us.es/nf
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless

Eric Dumazet (2):
      arp: fix possible crash in arp_rcv()
      net: fix infinite loop in __skb_recv_datagram()

Francois Romieu (2):
      Revert "r8169: enable ALDPS for power saving".
      Revert "r8169: enable internal ASPM and clock request settings".

Giuseppe CAVALLARO (2):
      stmmac: fix macro used for debugging the xmit
      stmmac: mdio register has to fail if the phy is not found

Huang, Xiong (1):
      atl1c: add error checking for pci_map_single functions

Jiri Pirko (1):
      htb: fix values in opt dump

Johannes Berg (2):
      mac80211: fix managed mode channel context use
      mac80211: fix channel selection bug

John W. Linville (2):
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Jonas Gorski (1):
      mwl8k: fix band for supported channels

Kees Cook (1):
      net, sctp: remove CONFIG_EXPERIMENTAL

Michael S. Tsirkin (3):
      ixgbe: fix gso type
      qlcnic: set gso_type
      bnx2x: set gso_type

Nicolas Ferre (1):
      net/macb: fix race with RX interrupt while doing NAPI

Pau Koning (1):
      batman-adv: Fix NULL pointer dereference in DAT hash collision avoidance

Stephen Hemminger (1):
      bridge: set priority of STP packets

YOSHIFUJI Hideaki / ÂêâËó§Ëã±Êòé (3):
      netfilter: ip6t_NPT: Fix adjustment calculation
      netfilter: ip6t_NPT: Fix prefix mangling
      netfilter: ip6t_NPT: Ensure to check lower part of prefixes are zero

 drivers/net/ethernet/atheros/atl1c/atl1c_main.c   | 71 +++++++++++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 12 ++--
 drivers/net/ethernet/cadence/macb.c               |  5 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |  1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  7 +-
 drivers/net/ethernet/realtek/r8169.c              | 86 +++++------------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 10 ++-
 drivers/net/usb/qmi_wwan.c                        |  1 +
 drivers/net/wireless/mwl8k.c                      | 36 +++++-----
 net/batman-adv/distributed-arp-table.c            |  2 +-
 net/bridge/br_stp_bpdu.c                          |  2 +
 net/core/datagram.c                               |  2 +-
 net/ipv4/arp.c                                    | 21 +++---
 net/ipv6/netfilter/ip6t_NPT.c                     | 18 +++--
 net/mac80211/cfg.c                                |  3 +-
 net/mac80211/mlme.c                               | 11 +--
 net/netfilter/ipvs/ip_vs_proto_sctp.c             | 35 +++++----
 net/netfilter/ipvs/ip_vs_sync.c                   |  2 +
 net/sched/sch_htb.c                               |  4 +-
 net/sctp/Kconfig                                  |  4 +-
 net/sctp/ipv6.c                                   |  5 +-
 22 files changed, 191 insertions(+), 149 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
