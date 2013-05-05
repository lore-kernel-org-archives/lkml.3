Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3EECm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 22:42:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35191 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3EECm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 22:42:26 -0400
Date: Sat, 04 May 2013 22:42:25 -0400 (EDT)
Message-Id: <20130504.224225.1329294730869442752.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 04 May 2013 19:42:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Several routines do not use netdev_features_t to hold such bitmasks,
   fixes from Patrick McHardy and Bjørn Mork.

2) Update cpsw IRQ software state and the actual HW irq enabling in
   the correct order.  From Mugunthan V N.

3) When sending tipc packets to multiple bearers, we have to make copies
   of the SKB rather than just giving the original SKB directly.  Fix
   from Gerlando Falauto.

4) Fix race with bridging topology change timer, from Stephen
   Hemminger.

5) Fix TCPv6 segmentation handling in GRE and VXLAN, from Pravin B
   Shelar.

6) Endian bug in USB pegasus driver, from Dan Carpenter.

7) Fix crashes on MTU reduction in USB asix driver, from Holger
   Eitzenberger.

8) Don't allow the kernel to BUG() just because the user puts some
   crap in an AF_PACKET mmap() ring descriptor.  Fix from Daniel
   Borkmann.

9) Don't use variable sized arrays on the stack in xen-netback, from
   Wei Liu.

10) Fix stats reporting and an unbalanced napi_disable() in be2net
    driver.  From Somnath Kotur and Ajit Khaparde.

Please pull, thanks a lot!

The following changes since commit 99c6bcf46d2233d33e441834e958ed0bc22b190a:

  Merge tag 'multiplatform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2013-05-02 09:38:16 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to 777c2300865cb9b1b1791862ed23da677abfe6dc:

  cxgb4: fix error recovery when t4_fw_hello returns a positive value (2013-05-03 16:10:34 -0400)

----------------------------------------------------------------
Ajit Khaparde (4):
      be2net: Fix to use version 2 of cq_create for SkyHawk-R devices
      be2net: Fix to use 32-bit stats to report rx_drops_no_fragment
      be2net: Fix to show tx priority pause counter in ethtool -S
      be2net: Fix to receive Multicast Packets when Promiscuous mode is enabled on certain devices

Bjørn Mork (1):
      net: vlan,ethtool: netdev_features_t is more than 32 bit

Dan Carpenter (1):
      usbnet: pegasus: endian bug in write_mii_word()

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong header status

Gerlando Falauto (3):
      tipc: cosmetic: clean up comments and break a long line
      tipc: tipc_bcbearer_send(): simplify bearer selection
      tipc: pskb_copy() buffers when sending on more than one bearer

Kirill Smelkov (1):
      sky2: Fix crash on receiving VLAN frames

Mugunthan V N (1):
      drivers: net: cpsw: irq not disabled in cpsw isr in particular sequence

Patrick McHardy (1):
      net: use netdev_features_t in skb_needs_linearize()

Pravin B Shelar (2):
      gre: Fix GREv4 TCPv6 segmentation.
      vxlan: Fix TCPv6 segmentation.

Somnath Kotur (3):
      be2net: Fix firmware download for Lancer
      be2net: avoid napi_disable() when it has not been enabled
      be2net: Fix to fail probe if MSI-X enable fails for a VF

Teppo Kotilainen (1):
      net: qmi_wwan: Add Telewell TW-LTE 4G

Thadeu Lima de Souza Cascardo (1):
      cxgb4: fix error recovery when t4_fw_hello returns a positive value

Wei Liu (3):
      xen-netback: remove redundent parameter in netbk_count_requests
      xen-netback: avoid allocating variable size array on stack
      xen-netback: better names for thresholds

holger@eitzenberger.org (1):
      asix: fix BUG in receive path when lowering MTU

stephen hemminger (1):
      bridge: fix race with topology change timer

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  2 +-
 drivers/net/ethernet/emulex/benet/be.h          |  1 +
 drivers/net/ethernet/emulex/benet/be_cmds.c     | 35 +++++++++++++++++---------------
 drivers/net/ethernet/emulex/benet/be_cmds.h     |  2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c  |  1 +
 drivers/net/ethernet/emulex/benet/be_main.c     | 54 +++++++++++++++++++++++++++++++++++--------------
 drivers/net/ethernet/marvell/sky2.c             |  2 ++
 drivers/net/ethernet/ti/cpsw.c                  |  2 +-
 drivers/net/usb/asix_common.c                   |  3 +++
 drivers/net/usb/pegasus.c                       |  3 ++-
 drivers/net/usb/qmi_wwan.c                      |  1 +
 drivers/net/xen-netback/netback.c               | 69 ++++++++++++++++++++++++++++++++++++++++-----------------------
 net/8021q/vlan_dev.c                            |  2 +-
 net/bridge/br_stp_timer.c                       |  2 +-
 net/core/dev.c                                  |  2 +-
 net/core/ethtool.c                              |  2 +-
 net/ipv4/af_inet.c                              |  1 +
 net/ipv4/gre.c                                  |  4 +++-
 net/ipv4/udp.c                                  |  7 ++++++-
 net/packet/af_packet.c                          | 53 +++++++++++++++++++++---------------------------
 net/tipc/bcast.c                                | 40 +++++++++++++++++++++++-------------
 21 files changed, 178 insertions(+), 110 deletions(-)
