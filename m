Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaKRJUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:20:07 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51335 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbaKRJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:20:03 -0500
Date: Tue, 18 Nov 2014 11:19:52 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-11-18
Message-ID: <20141118091952.GA14015@t440s.lan>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here's another bluetooth-next pull request for 3.19. We've got:

 - Various fixes, cleanups and improvements to ieee802154/mac802154
 - Support for a Broadcom BCM20702A1 variant
 - Lots of lockdep fixes
 - Fixed handling of LE CoC errors that should trigger SMP

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 56b2c3eea398c772dd895dc62c18cbdd1ba127b1:

  6lowpan: move skb_free from error paths in decompression (2014-11-06 22:09:48 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to a86c02ea38c53b695209b1181f9e2e18d73eb4e8:

  Bluetooth: Add support for Broadcom BCM20702A1 variant (2014-11-18 08:32:14 +0100)

----------------------------------------------------------------
Alexander Aring (49):
      Bluetooth: 6lowpan: fix skb_unshare behaviour
      mac802154: move mac pib attributes into wpan_dev
      mac802154: remove mac_params in sdata
      ieee802154: rename wpan_phy_alloc
      ieee802154: add cfg802154_registered_device list
      ieee802154: add iftype to wpan_dev
      ieee802154: add wpan_dev_list
      ieee802154: sysfs add wpan_phy index and name
      ieee802154: add new nl802154 header
      ieee802154: add nl802154 framework
      ieee802154: add wpan_phy dump support
      ieee802154: add wpan_dev dump support
      mac820154: don't set monitor dev_addr
      ieee802154: netlink add rtnl lock
      ieee802154: fix iface dump with lowpan
      mac802154: protect address changes via ioctl
      mac820154: move interface unregistration into iface
      mac820154: rename sdata next to tmp
      mac820154: move mutex locks out of loop
      mac802154: add wpan_phy priv id
      mac802154: change module description
      mac802154: add ifname change notifier
      ieee802154: cleanup cfg802154 intendation
      ieee820154: add channel set support
      ieee820154: remove valid page and channel checks
      ieee820154: add pan_id setting support
      ieee820154: add short_addr setting support
      ieee820154: add backoff exponent setting support
      at86rf230: remove invalid backoff exponent check
      ieee820154: add max csma backoffs setting support
      at86rf230: remove invalid max csma backoffs check
      ieee820154: add max frame retries setting support
      at86rf230: remove invalid max frame retries check
      ieee820154: add lbt setting support
      mac802154: add interframe spacing time handling
      at86rf230: remove interframe spacing time workaround
      mac802154: remove unused prototypes
      at86rf230: fix commentation for symbol duration
      mac802154: remove const for non pointer in driver-ops
      mac802154: remove const for non pointer in cfg ops
      mac802154: remove const for non pointer in rdev-ops
      mac802154: remove deprecated linux-zigbee info
      mac802154: use new nl802154 iftype types
      mac802154: remove wpan_dev parameter in if_add
      ieee802154: add new interface command
      ieee802154: setting extended address while iface add
      ieee802154: add del interface command
      ieee802154: rename and move WPAN_NUM_ defines
      ieee802154: fix byteorder for short address and panid

Fabian Frederick (1):
      Bluetooth: hidp: replace kzalloc/copy_from_user by memdup_user

Fabio K (1):
      Bluetooth: Add support for Broadcom BCM20702A1 variant

Fugang Duan (1):
      Bluetooth: hci-uart-ath: Correct the comments in this driver

Jaganath Kanakkassery (1):
      Bluetooth: Send mgmt_connected only if state is BT_CONFIG

Johan Hedberg (20):
      Bluetooth: Fix sparse warning in amp.c
      Bluetooth: Fix mgmt connected notification
      Bluetooth: 6lowpan: Remove unnecessary RCU callback
      Bluetooth: Fix l2cap_sock_teardown_cb lockdep warning
      Bluetooth: Remove unnecessary hci_dev_lock/unlock in smp.c
      Bluetooth: Use proper nesting annotation for l2cap_chan lock
      Bluetooth: Fix L2CAP socket lock nesting level
      Bluetooth: Fix L2CAP nesting level initialization location
      Bluetooth: Fix correct nesting for 6lowpan server channel
      Bluetooth: Fix sending incorrect LE CoC PDU in BT_CONNECT2 state
      Bluetooth: Add key preference parameter to smp_sufficient_security
      Bluetooth: Trigger SMP for the appropriate LE CoC errors
      Bluetooth: Convert LTK list to RCU
      Bluetooth: Convert IRK list to RCU
      Bluetooth: Remove unnecessary hdev locking in smp.c
      Bluetooth: Add debug logs to help track locking issues
      Bluetooth: Fix clearing remote OOB data through mgmt
      Bluetooth: Fix BR/EDR-only address checks for remote OOB data
      Bluetooth: Use shorter "rand" name for "randomizer"
      Bluetooth: Call drain_workqueue() before resetting state

 MAINTAINERS                        |   1 +
 drivers/bluetooth/btusb.c          |   2 +
 drivers/bluetooth/hci_ath.c        |   2 +-
 drivers/net/ieee802154/at86rf230.c |  80 ++-
 drivers/net/ieee802154/fakelb.c    |   3 -
 include/linux/ieee802154.h         |  10 +
 include/net/bluetooth/hci.h        |  12 +-
 include/net/bluetooth/hci_core.h   |  16 +-
 include/net/bluetooth/l2cap.h      |  15 +-
 include/net/bluetooth/mgmt.h       |  12 +-
 include/net/cfg802154.h            |  86 +++-
 include/net/mac802154.h            |   3 +-
 include/net/nl802154.h             | 122 +++++
 net/bluetooth/6lowpan.c            |  21 +-
 net/bluetooth/amp.c                |  25 +-
 net/bluetooth/hci_core.c           | 112 ++--
 net/bluetooth/hci_event.c          |  30 +-
 net/bluetooth/hidp/core.c          |  10 +-
 net/bluetooth/l2cap_core.c         |  35 +-
 net/bluetooth/l2cap_sock.c         |  29 +-
 net/bluetooth/mgmt.c               |  52 +-
 net/bluetooth/smp.c                |  61 ++-
 net/bluetooth/smp.h                |   9 +-
 net/ieee802154/Makefile            |   2 +-
 net/ieee802154/core.c              | 166 +++++-
 net/ieee802154/core.h              |  17 +
 net/ieee802154/ieee802154.h        |   2 +-
 net/ieee802154/netlink.c           |   2 +-
 net/ieee802154/nl-mac.c            |  23 +-
 net/ieee802154/nl802154.c          | 957 +++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h          |   7 +
 net/ieee802154/rdev-ops.h          |  66 +++
 net/ieee802154/sysfs.c             |  24 +
 net/mac802154/cfg.c                | 165 +++++-
 net/mac802154/driver-ops.h         |  46 +-
 net/mac802154/ieee802154_i.h       |  38 +-
 net/mac802154/iface.c              | 165 ++++--
 net/mac802154/mac_cmd.c            |  36 +-
 net/mac802154/main.c               |  54 +-
 net/mac802154/mib.c                |  10 +-
 net/mac802154/rx.c                 |  14 +-
 net/mac802154/tx.c                 |   2 +-
 net/mac802154/util.c               |  35 +-
 43 files changed, 2214 insertions(+), 365 deletions(-)
 create mode 100644 include/net/nl802154.h
 create mode 100644 net/ieee802154/nl802154.c
 create mode 100644 net/ieee802154/nl802154.h


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUaw84AAoJECQj9vv5qNQSw4kP/ifdpwsxh7tLoyhzj15ucelH
cb5rpSJVM3wwQAWbnf+xAPofyUzkC0yJC+sMXZydw4R0zOtQEpomvhn8i4bDT3W9
M+HWMk1HLlDnyZWmFHAXlSIG6DUtAy3RQxS3GsMqUwGhT/xmDtcCUdOD43iJXqor
KE4eePPAHkVjhDJ701Xl8/wwxjR79H6k/r8VXOG9Jz8/8yyoMB+QG7klmF4Hu/G8
CmOz2mynn/T3/zWhG930rro6Ho6/uyAcWrVwSHT4yP8BD0KKo5cOILL3gV4rPnh2
YPUMPYf3ME/N4DC74GB8f87vxoDOvnmauecefrv7jnA8afabsK2EdjuFncRjXBZM
J7q4OhvXKml6pMF6PalDmZ8WELGFNL0TKy7eaZbVvq7ra+dMncvBN3Vz4u+lqV/z
bJma4UMRS+nEnm554lmL6LNz2pavJ9jrFWXNaFKatsp0SLe8Cp+bEGgjlnoYYdry
2uxZzIqLKwG6jrCcpyVqYYpcFkljz+K992d3sl50dxGkbwLHbWZP6Wwwrtv8Ax7o
MHIw/KIKfB4yL0sDperyi87FE5oriJ0/pf9HzfFApJoTDzmlSd8HLM4KbFTInRIr
A0YM/8TNqJZBTYrkvaGUh4P7kdWUcfbg8fqvNI7KKH1XV0aIrmYy9wZROsZfpmJL
MSS3OzMAJg60/MT6Qt4s
=1ULF
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
