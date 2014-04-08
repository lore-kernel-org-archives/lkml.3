Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbaDHSqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:46:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45424 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbaDHSql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:46:41 -0400
Date: Tue, 08 Apr 2014 14:46:39 -0400 (EDT)
Message-Id: <20140408.144639.985847937288705728.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s38IkrDt013683


1) If a VXLAN interface is created with no groups, we can crash on
   reception of packets.  Fix from Mike Rapoport.

2) Missing includes in CPTS driver, from Alexei Starovoitov.

3) Fix string validations in isdnloop driver, from YOSHIFUJI Hideaki
   and Dan Carpenter.

4) Missing irq.h include in bnxw2x, enic, and qlcnic drivers.  From
   Josh Boyer.

5) AF_PACKET transmit doesn't statistically count TX drops, from
   Daniel Borkmann.

6) Byte-Queue-Limit enabled drivers aren't handled properly in
   AF_PACKET transmit path, also from Daniel Borkmann.

   Same problem exists in pktgen, and Daniel fixed it there too.

7) Fix resource leaks in driver probe error paths of new sxgbe driver,
   from Francois Romieu.

8) Truesize of SKBs can gradually get more and more corrupted in NAPI
   packet recycling path, fix from Eric Dumazet.

9) Fix uniprocessor netfilter build, from Florian Westphal.  In the longer
   term we should perhaps try to find a way for ARRAY_SIZE() to work
   even with zero sized array elements.

10) Fix crash in netfilter conntrack extensions due to mis-estimation of
    required extension space.  From Andrey Vagin.

11) Since we commit table rule updates before trying to copy the
    counters back to userspace (it's the last action we perform), we
    really can't signal the user copy with an error as we are beyond
    the point from which we can unwind everything.  This causes all
    kinds of use after free crashes and other mysterious behavior.

    From Thomas Graf.

12) Restore previous behvaior of div/mod by zero in BPF filter
    processing.  From Daniel Borkmann.

Please pull, thanks a lot!

The following changes since commit cd6362befe4cc7bf589a5236d2a780af2d47bcc9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-04-02 20:53:45 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to 52c35befb69b005c3fc5afdaae3a5717ad013411:

  net: sctp: wake up all assocs if sndbuf policy is per socket (2014-04-08 13:06:07 -0400)

----------------------------------------------------------------
Alexander Aring (1):
      at86rf230: fix MAX_CSMA_RETRIES parameter

Alexei Starovoitov (1):
      net: ti: fix CPTS driver build on arm

Alexey Perevalov (1):
      netfilter: x_tables: allow to use cgroup match for LOCAL_IN nf hooks

Andrey Vagin (1):
      netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Dan Carpenter (1):
      isdnloop: several buffer overflows

Daniel Borkmann (5):
      packet: report tx_dropped in packet_direct_xmit
      packet: fix packet_direct_xmit for BQL enabled drivers
      net: filter: be more defensive on div/mod by X==0
      pktgen: fix xmit test for BQL enabled devices
      net: sctp: wake up all assocs if sndbuf policy is per socket

David S. Miller (1):
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf

Eric Dumazet (1):
      net-gro: reset skb->truesize in napi_reuse_skb()

Erik Hugne (1):
      tipc: fix regression bug where node events are not being generated

Florian Westphal (2):
      netfilter: connlimit: fix UP build
      netfilter: connlimit: move lock array out of struct connlimit_data

Geert Uytterhoeven (1):
      tipc: Let tipc_release() return 0

Gilles Chanteperdrix (1):
      net/at91_ether: avoid NULL pointer dereference

Jean Sacren (2):
      sxgbe: fix duplicate #include headers
      mac802154: fix duplicate #include headers

Jiri Pirko (1):
      net: add busy_poll device feature

Josh Boyer (3):
      net: bnx2x: include irq.h for irqreturn_t definitions
      net: enic: include irq.h for irqreturn_t definitions
      net: qlcnic: include irq.h for irq definitions

Kirill Tkhai (1):
      netfilter: Add {ipt,ip6t}_osf aliases for xt_osf

Laurent Pinchart (1):
      net: smc911x: Remove unused local variable

Mike Rapoport (1):
      net: vxlan: fix crash when interface is created with no group

Pablo Neira Ayuso (2):
      netfilter: nf_tables: set names cannot be larger than 15 bytes
      netfilter: nf_tables: fix wrong format in request_module()

Philipp Zabel (1):
      net: Micrel KSZ8864RMN 4-port managed switch support

Sachin Kamat (1):
      net: bcmgenet: Remove unnecessary version.h inclusion

Thomas Graf (1):
      netfilter: Can't fail and free after table replacement

Veaceslav Falico (1):
      netdev: remove potentially harmful checks

YOSHIFUJI Hideaki / å‰è—¤è‹±æ˜ (1):
      isdnloop: Validate NUL-terminated strings from user.

Zoltan Kiss (3):
      xen-netback: Rename map ops
      xen-netback: Grant copy the header instead of map and memcpy
      xen-netback: Trivial format string fix

franÃ§ois romieu (2):
      sxgbe: use common NET_VENDOR_FOO style.
      sxgbe: fix driver probe error path and driver removal leaks

zheng.li (1):
      bonding: Inactive slaves should keep inactive flag's value

 drivers/isdn/isdnloop/isdnloop.c                |  23 +++++++-----
 drivers/net/bonding/bond_main.c                 |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h |   1 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c  |   1 -
 drivers/net/ethernet/cadence/at91_ether.c       |   3 ++
 drivers/net/ethernet/cisco/enic/enic.h          |   1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h     |   1 +
 drivers/net/ethernet/samsung/Kconfig            |  24 ++++++++++---
 drivers/net/ethernet/samsung/sxgbe/Kconfig      |   9 -----
 drivers/net/ethernet/samsung/sxgbe/sxgbe_dma.c  |   1 -
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c |  27 +++++++++------
 drivers/net/ethernet/smsc/smc911x.c             |   1 -
 drivers/net/ethernet/ti/cpts.c                  |   2 ++
 drivers/net/ieee802154/at86rf230.c              |   2 +-
 drivers/net/phy/spi_ks8995.c                    |  52 +++++++++++++++++++++-------
 drivers/net/vxlan.c                             |   6 +++-
 drivers/net/xen-netback/common.h                |   1 +
 drivers/net/xen-netback/netback.c               | 146 +++++++++++++++++++++++++++++++++++++++++++----------------------------------
 include/linux/netdev_features.h                 |   2 ++
 include/linux/netdevice.h                       |  24 ++++++++++---
 include/net/netfilter/nf_conntrack_extend.h     |   4 +--
 net/bridge/netfilter/ebtables.c                 |   5 ++-
 net/core/dev.c                                  |  14 +++++---
 net/core/ethtool.c                              |   1 +
 net/core/filter.c                               |  32 ++++++++---------
 net/core/pktgen.c                               |   2 +-
 net/ipv4/netfilter/arp_tables.c                 |   6 ++--
 net/ipv4/netfilter/ip_tables.c                  |   6 ++--
 net/ipv6/netfilter/ip6_tables.c                 |   6 ++--
 net/mac802154/mib.c                             |   1 -
 net/netfilter/nf_tables_api.c                   |   7 ++--
 net/netfilter/xt_cgroup.c                       |   3 +-
 net/netfilter/xt_connlimit.c                    |  25 +++++++++-----
 net/netfilter/xt_osf.c                          |   2 ++
 net/packet/af_packet.c                          |   3 +-
 net/sctp/socket.c                               |  36 ++++++++++++++++++-
 net/tipc/net.c                                  |   3 ++
 net/tipc/socket.c                               |   3 +-
 38 files changed, 320 insertions(+), 168 deletions(-)
 delete mode 100644 drivers/net/ethernet/samsung/sxgbe/Kconfig
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
