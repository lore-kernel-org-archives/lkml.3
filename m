Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbaJaS2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:28:16 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:46529 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbaJaS2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:28:13 -0400
Date: Fri, 31 Oct 2014 20:28:03 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-10-31
Message-ID: <20141031182803.GA5772@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here's the first bluetooth-next pull request for 3.19. The vast majority
of patches are for ieee802154 from Alexander Aring with various fixes
and cleanups. There are also several LE/SMP fixes as well as improved
support for handling LE devices that have lost their pairing information
(the patches from Alfonso). Jukka provides a couple of stability fixes
for 6lowpan and Szymon conformance fixes for RFCOMM. For the HCI drivers
we have one new USB ID for an Acer controller as well as a reset
handling fix for H5.

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 61ed53deb1c6a4386d8710dbbfcee8779c381931:

  Merge tag 'ntb-3.18' of git://github.com/jonmason/ntb (2014-10-19 12:58:22 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to b509c02d0f31639dda90f9b7269668b86c9b25ef:

  Bluetooth: HCI H5 peer reset detection (2014-10-31 19:54:34 +0200)

----------------------------------------------------------------
Alexander Aring (103):
      ieee802154: 6lowpan: fix byteorder for frag tag
      ieee802154: reassembly: fix tag byteorder
      ieee802154: 6lowpan: fix sign of errno return val
      at86rf230: fix errno on tx timeout handling
      at86rf230: add missing error handling
      at86rf230: correct aret lifs and sifs handling
      at86rf230: correct at86rf2xx lifs timings
      at86rf230: squash unnecessary dereferencing
      at86rf230: add missing enable_irq
      at86rf230: fix race condition
      at86rf230: fix enable_irq handling on async spi
      at86rf230: remove unnecessary print of async error
      ieee802154: 6lowpan: improve packet registration
      ieee802154: 6lowpan: add RTNL assertion
      ieee802154: mac802154: remove FSF address
      ieee802154: ieee802154_dev: fix align typo
      mac802154: fix typo IEEE802515 to IEEE802154
      ieee802154: wpan-phy: change to __aligned(size)
      ieee802154: wpan-phy: use blank line after function
      ieee802154: wpan-class: fix trailing semicolon
      mac802154: move ieee802154_dev.c to main.c
      mac802154: move mac802154.h to ieee802154_i.h
      mac802154: move wpan.c to iface.c
      ieee802154: move wpan-phy.h to cfg802154.h
      ieee802154: move wpan-class.c to core.c
      ieee802154: move ieee802154 header
      MAINTAINERS: add missing headers in 802.15.4
      ieee802154: remove fakehard driver
      ieee802154: rename ieee802154_dev to ieee802154_hw
      mac802154: rename mac802154_priv to ieee802154_local
      mac802154: rename mac802154_sub_if_data
      mac802154: rename hw subif_data variable to local
      mac802154: rename sdata slaves and slaves_mtx
      mac802154: introduce hw_to_local function
      mac802154: introduce IEEE802154_DEV_TO_SUB_IF
      mac802154: rename dev_workqueue to workqueue
      mac802154: remove ieee802154_addr from driver_ops
      mac802154: tx: move xmit callback to tx file
      mac802154: tx: remove kmalloc in xmit hotpath
      mac802154: tx: squash multiple dereferencing
      mac802154: tx: remove xmit channel context switch
      mac802154: add netdev qeue helpers
      mac802154: tx: use queue helpers in xmit worker
      mac802154: tx: fix error handling while xmit
      mac802154: tx: add support for xmit_async callback
      mac802154: tx: don't allow if down while sync tx
      mac802154: tx: use netdev print helpers
      mac802154: tx: cleanup crc calculation
      mac802154: tx: move stats tx increment
      mac802154: tx: change naming convention
      mac802154: tx: add comment at sync xmit callback
      at86rf230: asynchronous xmit handling
      mac802154: tx: make worker information static
      mac802154: tx: use put_unaligned_le16 for copy crc
      ieee802154: drivers: use dev_alloc_skb
      mac802154: rx: use tasklet instead workqueue
      mac802154: rx: document ieee802154_rx() context requirement
      mac802154: rx: move receive handling into rx.c
      mac802154: tx: remove monitor receive while xmit
      mac802154: rx: rename remove mac802154_subif_rx
      mac802154: rx: move skb->protocol setting
      mac802154: rx: add CHECKSUM_UNNECESSARY
      mac802154: rx: add monitor pkt_type information
      mac802154: rx: move skb_reset_mac_header
      mac802154: rx: move rcu locking
      ieee802154: add valid psdu length helper
      at86rf230: use ieee802154_is_valid_psdu_len helper
      at86rf230: improve receive handling
      mac802154: rx: change naming convention
      mac802154: monitor: merge into iface implementation
      mac802154: main: move open and close into iface
      mac802154: declare struct ieee802154_ops as const
      mac802154: ops: declare channel and page as u8
      mac802154: introduce driver-ops header
      mac802154: use driver-ops function wrappers
      mac802154: remove might_sleep from driver layer
      mac802154: remove driver ops in wpan-phy
      mac802154: rework sdata state change to running
      mac802154: rename running to started
      mac802154: move local started handling
      mac802154: add synchronization handling
      mac802154: iface: remove assign to zero
      mac802154: remove channel attributes from sdata
      mac802154: move mac_params functions into mac_cmd
      mac802154: cleanup open count handling
      ieee802154: introduce sysfs file
      mac802154: main: remove unnecessary include
      mac802154: remove tab after define
      mac802154: add IEEE802154_HW_ARET hw flag
      mac802154: add hardware address filter flag
      mac802154: add support for promiscuous mode
      at86rf230: add support for promiscuous mode
      mac802154: separate omit tx/rx flags
      mac802154: rx: remove unnecessary parameter
      mac802154: rx: simplify crc receive handling
      mac802154: rx: add software checksum filtering check
      mac802154: rx: remove override pkt_type set to PACKET_HOST
      mac802154: rx: use netif_receive_skb
      mac802154: rx: add rx stats incrementation
      mac802154: rx: monitor receive cleanup
      mac802154: rx: add error handling after skb_clone
      at86rf230: deliver with checksum
      mac802154: add basic support for monitor

Alfonso Acosta (4):
      Bluetooth: Refactor arguments of mgmt_device_connected
      Bluetooth: Include ADV_IND report in Device Connected event
      Bluetooth: Remove redundant check on hci_conn's device class
      Bluetooth: Defer connection-parameter removal when unpairing

Anantha Krishnan (1):
      Bluetooth: Add support for Acer [0489:e078]

Dan Carpenter (1):
      Bluetooth: 6lowpan: use after free in disconnect_devices()

Fabian Frederick (1):
      Bluetooth: fix shadow warning in hci_disconnect()

Johan Hedberg (6):
      Bluetooth: Pass only crypto context to SMP crypto functions
      Bluetooth: Add skeleton for SMP self-tests
      Bluetooth: Add self-tests for SMP crypto functions
      Bluetooth: Revert SMP self-test patches
      Bluetooth: Fix LE connection timeout deadlock
      Bluetooth: Fix check for direct advertising

Jukka Rissanen (3):
      Bluetooth: 6lowpan: Converting rwlocks to use RCU
      Bluetooth: 6lowpan: Fix lockdep splats
      Bluetooth: Wrong style spin lock used

Julien Catalano (1):
      trivial: net/mac802154: Fix Kconfig typo

Li RongQing (1):
      Bluetooth: 6lowpan: remove unnecessary codes in give_skb_to_upper

Loic Poulain (1):
      Bluetooth: HCI H5 peer reset detection

Marcel Holtmann (1):
      Bluetooth: Clear LE white list when resetting controller

Martin Townsend (6):
      6lowpan: Use skb_cow in IPHC decompression.
      Bluetooth: Fix missing channel unlock in l2cap_le_credits
      6lowpan: remove skb_deliver from IPHC
      6lowpan: fix process_data return values
      bluetooth:6lowpan: use consume_skb when packet processed successfully
      ieee802154: 6lowpan: rename process_data and lowpan_process_data

Simon Vincent (2):
      ieee802154: 6lowpan: Drop PACKET_OTHERHOST skbs in 6lowpan
      ieee802154: mrf24j40: Add support for MRF24J40MC

Stephen Hemminger (1):
      Bluetooth: spelling fixes

Szymon Janc (2):
      Bluetooth: Fix RFCOMM NSC response
      Bluetooth: Improve RFCOMM __test_pf macro robustness

Varka Bhadram (1):
      MAINTAINERS: add cc2520 driver maintainer

 MAINTAINERS                                   |  15 +
 drivers/bluetooth/ath3k.c                     |   2 +
 drivers/bluetooth/btusb.c                     |   1 +
 drivers/bluetooth/hci_h5.c                    |  34 ++
 drivers/net/ieee802154/Kconfig                |  10 -
 drivers/net/ieee802154/Makefile               |   1 -
 drivers/net/ieee802154/at86rf230.c            | 392 ++++++++--------
 drivers/net/ieee802154/cc2520.c               |  70 +--
 drivers/net/ieee802154/fakehard.c             | 427 ------------------
 drivers/net/ieee802154/fakelb.c               |  92 ++--
 drivers/net/ieee802154/mrf24j40.c             | 104 +++--
 include/{net => linux}/ieee802154.h           |  23 +-
 include/linux/nl802154.h                      |   4 -
 include/net/6lowpan.h                         |  12 +-
 include/net/af_ieee802154.h                   |   4 -
 include/net/bluetooth/hci_core.h              |   8 +-
 include/net/{wpan-phy.h => cfg802154.h}       |  22 +-
 include/net/ieee802154_netdev.h               |   6 +-
 include/net/mac802154.h                       | 124 +++--
 include/net/nl802154.h                        |   4 -
 net/6lowpan/iphc.c                            |  71 +--
 net/bluetooth/6lowpan.c                       | 284 +++++++-----
 net/bluetooth/hci_conn.c                      |  14 +-
 net/bluetooth/hci_core.c                      |  16 +-
 net/bluetooth/hci_event.c                     |  50 ++-
 net/bluetooth/hci_sock.c                      |   2 +-
 net/bluetooth/l2cap_core.c                    |   7 +-
 net/bluetooth/mgmt.c                          |  83 +++-
 net/bluetooth/rfcomm/core.c                   |   6 +-
 net/bluetooth/smp.c                           |  34 +-
 net/ieee802154/6lowpan_rtnl.c                 | 108 +++--
 net/ieee802154/Makefile                       |   4 +-
 net/ieee802154/af802154.h                     |   4 -
 net/ieee802154/af_ieee802154.c                |   4 -
 net/ieee802154/{wpan-class.c => core.c}       |  79 +---
 net/ieee802154/dgram.c                        |   6 +-
 net/ieee802154/header_ops.c                   |   3 +-
 net/ieee802154/ieee802154.h                   |   4 -
 net/ieee802154/netlink.c                      |   4 -
 net/ieee802154/nl-mac.c                       |  27 +-
 net/ieee802154/nl-phy.c                       |   6 +-
 net/ieee802154/nl_policy.c                    |   4 -
 net/ieee802154/raw.c                          |   4 -
 net/ieee802154/reassembly.c                   |   8 +-
 net/ieee802154/reassembly.h                   |   4 +-
 net/ieee802154/sysfs.c                        |  94 ++++
 net/ieee802154/sysfs.h                        |   9 +
 net/mac802154/Kconfig                         |   2 +-
 net/mac802154/Makefile                        |   4 +-
 net/mac802154/driver-ops.h                    | 226 ++++++++++
 net/mac802154/ieee802154_dev.c                | 415 -----------------
 net/mac802154/{mac802154.h => ieee802154_i.h} |  87 ++--
 net/mac802154/iface.c                         | 466 +++++++++++++++++++
 net/mac802154/llsec.c                         |   4 +-
 net/mac802154/mac_cmd.c                       |  36 +-
 net/mac802154/main.c                          | 265 +++++++++++
 net/mac802154/mib.c                           | 240 +++++-----
 net/mac802154/monitor.c                       | 117 -----
 net/mac802154/rx.c                            | 311 ++++++++++---
 net/mac802154/tx.c                            | 154 ++++---
 net/mac802154/util.c                          |  55 +++
 net/mac802154/wpan.c                          | 599 -------------------------
 62 files changed, 2542 insertions(+), 2733 deletions(-)
 delete mode 100644 drivers/net/ieee802154/fakehard.c
 rename include/{net => linux}/ieee802154.h (94%)
 rename include/net/{wpan-phy.h => cfg802154.h} (77%)
 rename net/ieee802154/{wpan-class.c => core.c} (60%)
 create mode 100644 net/ieee802154/sysfs.c
 create mode 100644 net/ieee802154/sysfs.h
 create mode 100644 net/mac802154/driver-ops.h
 delete mode 100644 net/mac802154/ieee802154_dev.c
 rename net/mac802154/{mac802154.h => ieee802154_i.h} (73%)
 create mode 100644 net/mac802154/iface.c
 create mode 100644 net/mac802154/main.c
 delete mode 100644 net/mac802154/monitor.c
 create mode 100644 net/mac802154/util.c
 delete mode 100644 net/mac802154/wpan.c


--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU9SzAAoJECQj9vv5qNQSVuoP/2sWKC4kBcbjDgKj60WMmrM2
7DqZD5KGCMmhencRJL2a+hTM6kbS+tANXTSGTYVz5qAZ2BrGPqfz2aVcFOrbJGm9
gZrtjFOc9NmZNafle/vmjj9pdKsPJTNeOr9xRHUDkPl7LcdnCX5wRfxsGkaUnO/+
ajRof33n/T0tR3BYG01klllU+dEknCi4rEjefCBxt+jNnGlefGptp5ubmr17qLVf
ixhk0WxMec4/W+U3Eb4NroI8f77veRD18DtH2e1D/wsZ2Ac8b6lxM6soXNgn8IRm
Ek/YZzjiFnsVsfxj8gE4LJuDXbvUuLh2RFzQW9kaPzjfLCzZCoo3Tzs1glI/gavq
6J/S0id5dG4+rfgnHEE7sIzMyoEOvWPljFpKlUrwOIJMDKxDOui6Aw4fhc20/Y/M
Zr1rY1/CoYtB39hy4OD2bgSc2APRQqXY+7jj4rV1Wq1lPL92UsOuTvH6aZ5y/sZS
q2ZhVPMnCF45Dq/Qc7xno1Hb8Trwt2Tc0jXWH6tXhW3HzPxitN+lij4obDDLMLM8
xVkpahsPSy/zxtW+mAe5b74vruHIfQcmP8dy8ags4S0bUo4YtkKR1yMURcskomjG
T8v+wA02MlA9+MYX4Rtf2kAKjjYcwOaOKLnPQmj/lL3dWem8T56+lrHvV5tHNK9L
iq1ureA4tQLI/Tu9B/C7
=TaUw
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
