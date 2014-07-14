Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbaGNVtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:49:53 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:54585 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaGNVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:49:50 -0400
Date: Mon, 14 Jul 2014 18:49:44 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-07-14
Message-ID: <20140714214944.GA4374@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Some more patches for 3.17. The most important change here is the move of
the 6lowpan code to net/6lowpan. It has been agreed with Davem that this
change will go through the bluetooth tree. The rest are mostly clean up and
fixes.

Please pull! or let me know of any issues. Thanks!

	Gustavo

---
The following changes since commit 6fea7ad1d338dba592d65423427a997f1b7ff485:

  Bluetooth: Don't send ERTM configuration option when disabled (2014-07-09 13:53:36 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 4d042654afb342386cb5c33e29843b76d598ab61:

  Bluetooth: cmtp: Remove unnecessary null test (2014-07-14 23:00:13 +0200)

----------------------------------------------------------------
Alexander Aring (2):
      6lowpan: introduce new net/6lowpan directory
      MAINTAINERS: add net/6lowpan/ maintainer entry

Himangi Saraogi (1):
      Bluetooth: cmtp: Remove unnecessary null test

Johan Hedberg (12):
      Bluetooth: Always confirm incoming SMP just-works requests
      Bluetooth: Fix forcing SMP just-works with no-bonding
      Bluetooth: Fix incorrect clearing of SMP_FLAG_INITIATOR
      Bluetooth: Fix advertising parameter update when toggling connectable
      Bluteooth: Reject SMP bonding if HCI_PAIRABLE is not set
      Bluetooth: Fix using test_and_clear instead of test_and_set
      Bluetooth: Remove unneeded mgmt_connectable function
      Bluetooth: Refactor ioctl scan state update to its own function
      Bluetooth: Remove unneeded mgmt_discoverable function
      Bluetooth: Remove unneeded mgmt_write_scan_failed function
      Bluetooth: Fix tracking local SSP authentication requirement
      Bluetooth: Fix trying LTK re-encryption when we don't have an LTK

Marcel Holtmann (23):
      Bluetooth: Mark controller is down when HCI_AUTO_OFF is set
      Bluetooth: Set HCI_PAIRABLE during power on for legacy ioctl
      Bluetooth: Move HCI socket definitions into its own header file
      Bluetooth: Move struct hci_sec_filter next to its user
      Bluetooth: Delcare the hci_sec_filter as const
      Bluetooth: Move struct hci_pinfo into net/bluetooth/hci_sock.c
      Bluetooth: Move HCI request internals to net/bluetooth/hci_core.c
      Bluetooth: Update the list of L2CAP fixed channels
      Bluetooth: Move struct sco_pinfo into net/bluetooth/sco.c
      Bluetooth: Move struct sco_conn into net/bluetooth/sco.c
      Bluetooth: Remove unused SCO_DEFAULT_FLUSH_TO constant
      Bluetooth: Move SCO timeout constants into net/bluetooth/sco.c
      Bluetooth: Check for valid HCI UART driver flags
      Bluetooth: Add support for external configuration with UART driver
      Bluetooth: Fix HCIUARTGETDEVICE ioctl when UART is not registered
      Bluetooth: Read LE Advertising Channel TX Power only when available
      Bluetooth: Enable LE encryption events only when supported
      Bluetooth: Enable LE Long Term Key Request event only when supported
      Bluetooth: Allocate struct inquiry_entry with GFP_KERNEL
      Bluetooth: Remove unneeded forward declaration of __sco_chan_add
      Bluetooth: Remove unneeded forward declaration of sco_chan_del
      Bluetooth: Convert L2CAP ident spinlock into a mutex
      Bluetooth: Remove sco_chan_get helper function

 MAINTAINERS                                       |   7 ++
 drivers/bluetooth/hci_ldisc.c                     |  25 +++++-
 drivers/bluetooth/hci_uart.h                      |   1 +
 fs/compat_ioctl.c                                 |   2 +-
 include/net/bluetooth/hci.h                       | 150 +------------------------------
 include/net/bluetooth/hci_core.h                  |  34 +------
 include/net/bluetooth/hci_sock.h                  | 175 +++++++++++++++++++++++++++++++++++++
 include/net/bluetooth/l2cap.h                     |   8 +-
 include/net/bluetooth/sco.h                       |  30 -------
 net/6lowpan/Kconfig                               |   6 ++
 net/6lowpan/Makefile                              |   3 +
 net/{ieee802154/6lowpan_iphc.c => 6lowpan/iphc.c} |   0
 net/Kconfig                                       |   1 +
 net/Makefile                                      |   3 +-
 net/bluetooth/Kconfig                             |   3 +-
 net/bluetooth/cmtp/capi.c                         |   6 --
 net/bluetooth/hci_core.c                          | 134 ++++++++++++++++++++--------
 net/bluetooth/hci_event.c                         |  45 ++++------
 net/bluetooth/hci_sock.c                          |  21 ++++-
 net/bluetooth/l2cap_core.c                        |   8 +-
 net/bluetooth/mgmt.c                              | 116 ++++++------------------
 net/bluetooth/sco.c                               | 119 +++++++++++++++----------
 net/bluetooth/smp.c                               |  40 +++++----
 net/ieee802154/Kconfig                            |   9 +-
 net/ieee802154/Makefile                           |   5 +-
 25 files changed, 492 insertions(+), 459 deletions(-)
 create mode 100644 include/net/bluetooth/hci_sock.h
 create mode 100644 net/6lowpan/Kconfig
 create mode 100644 net/6lowpan/Makefile
 rename net/{ieee802154/6lowpan_iphc.c => 6lowpan/iphc.c} (100%)


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxFB4AAoJEPs3PUX4s20ozJMQALUn8JE8hnJWcXgChJxLDeKZ
ldYdlsnRoA6+E4OsY7b9Qh1KdJzJC2ZW0fGrXa4wuvfoA5bYnMPx6J1wIzSw+/GV
YkMurLXZHlMRYIznAoBcPq4MOb1kNibQtPLa0B0eHP3/i0diDTgZ6nH+r8io0+Zx
KX3jR5PDcFapczSF1MU2bDNTSj9Kj3jlpTcG1p+h3byqiup8kju+priX4cnAwPLu
7oYqzIOzfHskX7jd61Qaz3Vgri/IXAJBGf7X+vxelv7jWGatGaIT4np0K7P3tmPD
I8fLyY5QjJ5lAIcbT8DRT9RFsrCrLmXW0lW3daLvBf061fsakqaA/nGhsH/rOvjp
V9kHGA8oMClRhqCgb2yrnABJ5u1kz8GGAJTPdkhuvnku0B9wnEX4J8N/fpr1+Wij
e0HAyPUm0inARP3mU4n7J8l6npxVkhoK10zAuLfx+pdNM9dgmH2ft03Ntgrf3fLS
YJg8khElf9wNklyQT7yn9wqDMP+VHCBuYcE3Y8RcC1dz2JBMp9/bflXtAOKBcgBx
wFc5NHGMm2jHS2HxZOSozdq+QrqN19/BAl2REE5Te2Vi6TYwZ+/3mBfWEnvO/T95
iISZ0sJ0cUHZnugxfZodbNLMCGwiiFV22vu39+siq6WbICAOtxwVhDaY+4noqvTP
W3YpdNYJ3UxiCiVrlQBX
=LKjk
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
