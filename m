Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaKGJ2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:28:10 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64412 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaKGJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:28:05 -0500
Date: Fri, 7 Nov 2014 11:27:54 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-11-07
Message-ID: <20141107092754.GA6995@t440s.lan>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John

Here's another set of patches for 3.19. Most of it is again fixes and
cleanups to ieee802154 related code from Alexander Aring. We've also got
better handling of hardware error events along with a proper API for HCI
drivers to notify the HCI core of such situations. There's also a minor
fix for mgmt events as well as a sparse warning fix. The code for
sending HCI commands synchronously also gets a fix where we might loose
the completion event in the case of very fast HW (particularly easily
reproducible with an emulated HCI device).

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 6bc6c49f1e2f3ab1bec05d1c08aad219ab4eb5d0:

  mwifiex: add cfg80211 dump_survey handler (2014-10-31 16:07:49 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 56b2c3eea398c772dd895dc62c18cbdd1ba127b1:

  6lowpan: move skb_free from error paths in decompression (2014-11-06 22:09:48 +0100)

----------------------------------------------------------------
Alexander Aring (41):
      at86rf230: fix page parameter constraints
      ieee802154: remove default channel settings
      at86rf230: add default channel settings
      cfg802154: introduce cfg802154_registered_device
      mac802154: introduce mac802154_config_ops
      ieee802154: add helper wpan_phy_to_rdev function
      cfg802154: convert deprecated iface add and del
      ieee802154: don't allow to change addr while netif_running
      mac802154: add helper for converting dev_addr
      mac802154: set extended address filter on ifup
      mac802154: set short address filter on ifup
      mac802154: set panid address filter on ifup
      mac802154: move phy settings into netlink receive
      ieee802154: add extended address validation helper
      mac802154: iface: add validation for extended address
      ieee802154: 6lowpan: remove set of mac address
      ieee802154: add missing ULL definition
      ieee802154: fix byteorder issues
      mac802154: fix byteorder issues
      ieee802154: sysfs: add missing include
      mac802154: cfg: add missing include
      ieee802154: remove unnecessary functions
      netdevice: add ieee802154_ptr to net_device
      ieee802154: rework wpan_phy index assignment
      ieee802154: remove nl802154 unused functions
      mac802154: move interface del handling in iface
      mac802154: move interface add handling in iface
      mac802154: move dev_hold out of ieee802154_if_add
      ieee802154: rework interface registration
      ieee802154: remove mlme get_phy callback
      mac802154: add default interface registration
      mac802154: add ieee802154_vif struct
      ieee802154: add IEEE802154_EXTENDED_ADDR_LEN
      ieee802154: add ieee802154_random_extended_addr
      mac802154: add ieee802154_le64_to_be64
      mac802154: cleanup ieee802154_netdev_to_extended_addr
      mac802154: add support for perm_extended_addr
      at86rf230: generate random perm extended address
      at86rf230: add force slotted operation bit
      mac802154: use IEEE802154_EXTENDED_ADDR_LEN
      mac802154: fix typo promisuous to promiscuous

Chan-yeol Park (1):
      Bluetooth: Fix hci_sync missing wakeup interrupt

Dan Carpenter (1):
      ieee802154: || vs && in ieee802154_is_valid_extended_addr()

Fengguang Wu (1):
      at86rf230: fix simple_return.cocci warnings

Johan Hedberg (1):
      Bluetooth: Fix sparse warnings in RFCOMM

Kuba Pawlak (2):
      Bluetooth: Clear role switch pending flag
      Bluetooth: Sort switch cases by opcode's numeric value

Marcel Holtmann (11):
      Bluetooth: Check status of command complete for HCI_Reset
      Bluetooth: Print error message for HCI_Hardware_Error event
      Bluetooth: Use HCI_EV_HARDWARE_ERROR define for event payload
      Bluetooth: Introduce BT_BREDR and BT_LE config options
      Bluetooth: Add hci_reset_dev() for driver triggerd stack reset
      Bluetooth: Switch HCI H5 driver to use hci_reset_dev() function
      Bluetooth: Introduce HCI_QUIRK_STRICT_DUPLICATE_FILTER
      Bluetooth: Set HCI_QUIRK_STRICT_DUPLICATE_FILTER for Broadcom devices
      Bluetooth: Consolidate whitelist debugfs entry into device_list
      Bluetooth: btusb: Add internal callback for USB bulk rx data
      Bluetooth: Add hci_conn_lookup_type() helper function

Martin Townsend (1):
      6lowpan: move skb_free from error paths in decompression

Simon Vincent (1):
      6lowpan: fix udp header compression when using raw sockets

Szymon Janc (1):
      Bluetooth: Fix invalid response for 'Start Discovery' command

 MAINTAINERS                        |   1 -
 drivers/bluetooth/btusb.c          |   7 +-
 drivers/bluetooth/hci_h5.c         |  13 +--
 drivers/net/ieee802154/at86rf230.c |  13 ++-
 drivers/net/ieee802154/cc2520.c    |   1 +
 include/linux/ieee802154.h         |  32 ++++++
 include/linux/netdevice.h          |   3 +
 include/net/bluetooth/hci.h        |  15 +++
 include/net/bluetooth/hci_core.h   |  21 ++++
 include/net/cfg802154.h            |  24 +++--
 include/net/ieee802154_netdev.h    |  12 ---
 include/net/mac802154.h            |  33 ++++++
 include/net/nl802154.h             | 122 ---------------------
 net/6lowpan/iphc.c                 |  41 +++----
 net/bluetooth/6lowpan.c            |  15 ++-
 net/bluetooth/Kconfig              |  20 +++-
 net/bluetooth/bnep/Kconfig         |   2 +-
 net/bluetooth/cmtp/Kconfig         |   2 +-
 net/bluetooth/hci_core.c           |  72 ++++++-------
 net/bluetooth/hci_event.c          |  61 +++++++++--
 net/bluetooth/hidp/Kconfig         |   2 +-
 net/bluetooth/mgmt.c               |  56 ++++++----
 net/bluetooth/rfcomm/Kconfig       |   2 +-
 net/bluetooth/rfcomm/core.c        |   6 +-
 net/ieee802154/6lowpan_rtnl.c      |  38 ++-----
 net/ieee802154/core.c              |  64 +++++------
 net/ieee802154/core.h              |  29 +++++
 net/ieee802154/nl-mac.c            | 203 ++++-------------------------------
 net/ieee802154/nl-phy.c            |  23 ++--
 net/ieee802154/rdev-ops.h          |  23 ++++
 net/ieee802154/sysfs.c             |  16 ++-
 net/mac802154/Makefile             |   2 +-
 net/mac802154/cfg.c                |  47 ++++++++
 net/mac802154/cfg.h                |   9 ++
 net/mac802154/ieee802154_i.h       |  17 ++-
 net/mac802154/iface.c              | 195 +++++++++++++++++++++------------
 net/mac802154/mac_cmd.c            |  42 ++++----
 net/mac802154/main.c               | 102 +++---------------
 net/mac802154/mib.c                |  71 ------------
 net/mac802154/rx.c                 |   4 +-
 40 files changed, 678 insertions(+), 783 deletions(-)
 delete mode 100644 include/net/nl802154.h
 create mode 100644 net/ieee802154/core.h
 create mode 100644 net/ieee802154/rdev-ops.h
 create mode 100644 net/mac802154/cfg.c
 create mode 100644 net/mac802154/cfg.h


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXJCaAAoJECQj9vv5qNQSXyAQAJj2kpekYfoB8gB1s/5x8qTO
6Qr832BIJZ13BOmL2jszTrAcY1Pq9LBFTiBvzshizefbA93O9o0xoT357yEFrJZG
YC7oV6O+mrNFxFPUDbkcEtIoNxAEpWd/+pXYmJZZ9ZMfTjMcN3HGcalud+fRiFlM
M/Av+n68wjvN7DItmWuLgWJenOqAZJ4+gEkHtYz5u6n9Uz8DAsOY5U6QSlmastw1
ESjH6C2SwpDecBHIO+J9Zp5k2o2j3VovNanu8rtDD1X1gqbLWKR/nDvqjNDxtNeB
YqXV23af+CDPltMeBUn1quIS+MDQGHUdQEH0jJvLsz8/STMQi10uTpxFG8Sxckuw
bXuifdEEIN/EHpTeEEg1U4JRCnzhTbQkYFWNiIUG/4caGm2TBYdkEAgkY5zbEDtk
TOi8zKIu1SEUz79iQ1iLb6bF+06HkXWNAN6FDW9sWeSnoFUmBS+9b4pqywH2sMdT
yoRMAkGYDdj85meTkOrR7JbpYUqduocYAzCcW52CEzZZ3xsmcgtIme3IzU368rAX
MsCMlAyz8exKc8iksL2L4LAPQKO7Am93oKYWUKp5uarvcspxGGiS/OGIvi5wlGU8
aH8dRTlMY+Odq+F4pbfvo2cDF7YbYtJ84IpTvP+fyIQFAOGxuKvDuqXGCBJoBZ8z
845T4eIWdDiuiOZKiw1F
=DttJ
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
