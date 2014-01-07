Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaAGPXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:23:05 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:44624 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaAGPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:22:57 -0500
Date: Tue, 7 Jan 2014 13:22:51 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-01-07
Message-ID: <20140107152251.GA24183@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

More patches to 3.14. The bulk of changes here is the 6LoWPAN support for
Bluetooth LE Devices. The commits that touches net/ieee802154/ are already
acked by David Miller. Other than that we have some RFCOMM fixes and
improvements plus fixes and clean ups all over the tree.

Please pull, or let me know of any concerns you have.

	Gustavo

---
The following changes since commit 71fb419724fadab4efdf98210aa3fe053bd81d29:

  Bluetooth: Fix handling of L2CAP Command Reject over LE (2013-12-10 01:15:44 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to e825eb1d7e06f616003c17e2e8e421c2e5e44142:

  Bluetooth: Fix 6loWPAN peer lookup (2014-01-07 11:32:15 -0200)

----------------------------------------------------------------
Alexander Aring (9):
      6lowpan: fix/move/cleanup debug functions
      6lowpan: introduce lowpan_push_hc_data function
      6lowpan: udp use lowpan_push_hc_data function
      6lowpan: fix udp compress ordering
      6lowpan: fix udp byte ordering
      6lowpan: add udp warning for elided checksum
      6lowpan: udp use lowpan_fetch_skb function
      6lowpan: udp use subtraction on both conditions
      6lowpan: cleanup udp compress function

Claudio Takahasi (2):
      Bluetooth: Fix setting Universal/Local bit
      Bluetooth: Fix 6loWPAN peer lookup

Gianluca Anzolin (4):
      Bluetooth: Release RFCOMM port when the last user closes the TTY
      Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()
      Bluetooth: Always wait for a connection on RFCOMM open()
      Bluetooth: Remove rfcomm_carrier_raised()

Johan Hedberg (4):
      Bluetooth: Add missing 6lowpan.h include
      Bluetooth: Fix test for lookup_dev return value
      Bluetooth: Fix NULL pointer dereference when disconnecting
      Bluetooth: Default to no security with L2CAP RAW sockets

Jukka Rissanen (5):
      6lowpan: Moving generic compression code into 6lowpan_iphc.c
      net: if_arp: add ARPHRD_6LOWPAN type
      ipv6: Add checks for 6LOWPAN ARP type
      Bluetooth: Enable 6LoWPAN support for BT LE devices
      Bluetooth: Manually enable or disable 6LoWPAN between devices

Marcel Holtmann (5):
      Bluetooth: Set HCI_QUIRK_RESET_ON_CLOSE for Socket SDIO cards
      Bluetooth: Add support for vectored writes to virtual HCI driver
      Bluetooth: Use MD SET register for changing SDIO Type-B to Type-A
      Bluetooth: Add quirk for disabling Delete Stored Link Key command
      Bluetooth: Deal with USB devices that are faking CSR vendor

Wei Yongjun (2):
      Bluetooth: remove unused including <linux/version.h>
      Bluetooth: fix return value check

 drivers/bluetooth/btsdio.c       |   6 +-
 drivers/bluetooth/btusb.c        |  46 +++-
 drivers/bluetooth/hci_vhci.c     |  29 ++-
 include/net/bluetooth/hci.h      |   4 +-
 include/net/bluetooth/hci_core.h |   1 +
 include/net/bluetooth/l2cap.h    |   1 +
 include/uapi/linux/if_arp.h      |   1 +
 net/bluetooth/6lowpan.c          | 860 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/bluetooth/6lowpan.h          |  26 +++
 net/bluetooth/Makefile           |   6 +-
 net/bluetooth/hci_core.c         |  52 ++++-
 net/bluetooth/hci_event.c        |   3 +
 net/bluetooth/l2cap_core.c       |  12 ++
 net/bluetooth/l2cap_sock.c       |   3 +
 net/bluetooth/rfcomm/tty.c       | 103 +++++----
 net/ieee802154/6lowpan.c         | 796 ++++---------------------------------------------------------------
 net/ieee802154/6lowpan.h         |  72 +++++++
 net/ieee802154/6lowpan_iphc.c    | 799 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/ieee802154/Makefile          |   2 +-
 net/ipv6/addrconf.c              |   4 +-
 20 files changed, 2015 insertions(+), 811 deletions(-)
 create mode 100644 net/bluetooth/6lowpan.c
 create mode 100644 net/bluetooth/6lowpan.h
 create mode 100644 net/ieee802154/6lowpan_iphc.c


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSzBvLAAoJEPs3PUX4s20oJ0AQAI5V9y7IR3u58JRjICe83MRU
aIUZRF/6zsL7/5U/43CTBQlFQKb83xU4xZJYvrC0a/rbfJWJl1Hd/tc0op9LFBlL
pejWTqctTGTUmElCUo2uEBDBlkIytqAr4gTtyoZ6BhvroGnjvAfbz+4uIieF5Stu
vyPzTr6PgS/i7aoarLQjG88ncHka50h5om2LQ7C9XukDUtBTFZsIIymvysaYwFL0
aeg1VQ3MVhmSKSZAB6prM47rqgHEPmyWOyhIft3VqisFkWguC4SCc0Eb3S1GBhfm
rbt+WeuXgdOZoGM/JKOOI5LnE1gbqxZf/gLVgCXEnRR6/eMUwXfPP629Q1is6IqO
Fpf29w3FcrsDiph2bkj9EANQn5akPZlmF249CtoGheGzCLUunLyPHMsdiIDic0hY
KrTGFgObMO04kpVMxbVn/DwQj42ul2oJAmzVvCJzXMFej6Ia7xYYCHwpMuxr+jiV
p9D+aCyb+5DUqyrzLWUis6STiF6nIeZfvM7VL1oTOvpAb2XJ6YO602AN8NFsqhOX
8ReOIfBVRIDOcJESvbqTXp7fahIXCWdaNXrCacLMJ5zyLwOT947aM8IV9y2wP86k
4y2kk3C5uFu7MqnfMICR9p2h8URUME616JZvA/qOEKIjMaOug1tDw/77nI0/g/P6
bif0GD+UQrLHN8PUAj/Z
=3eir
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
