Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3DRFOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 01:14:06 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:41387 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3DRFOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 01:14:04 -0400
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2013 01:14:04 EDT
Date: Thu, 18 Apr 2013 01:48:36 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-04-18
Message-ID: <20130418044836.GB29635@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A set of changes intended for 3.10. The biggest changes here are from David
Herrmann, he rewrote most of the HIDP layer making it more reliable. Marcel
added a driver setup stage for device that need special handling on their
early initialization. Other than that we have the usual clean ups, bugfixes
and small improvements.

Please pull or let me know of any problems! Thanks!

	Gustavo

---
The following changes since commit 84bcc0c3c4b8ca4c0abed2d2dd63b7ce04f8be0e:

  brcmfmac: enable sk_buff queueing when credits deplete (2013-04-03 15:07:=
09 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream

for you to fetch changes up to 76a388beaf92cc75b829d4a0b7d69afaaeaa4b0a:

  Bluetooth: Rename LE_SCANNING_* macros (2013-04-18 01:17:27 -0300)

----------------------------------------------------------------
Andre Guedes (7):
      Bluetooth: Fix HCI request framework
      Bluetooth: Fix hci_inquiry ioctl usage
      Bluetooth: Remove unneeded hci_req_cmd_status function
      Bluetooth: Change LE scanning timeout macros
      Bluetooth: Add LE scan type macros
      Bluetooth: Add macros for filter duplicates values
      Bluetooth: Rename LE_SCANNING_* macros

Chan-yeol Park (3):
      Bluetooth: Fix H4 crash from incoming UART packets
      Bluetooth: Fix possible NULL dereference in hci_uart_tty_receive
      Bluetooth: Remove trivial white space

Claudio Takahasi (5):
      Bluetooth: Fix SCO connection reference
      Bluetooth: Use GFP_KERNEL in sco_conn_add
      Bluetooth: Minor coding style fix
      Bluetooth: Remove unneeded parameter
      Bluetooth: Reject SCO when hci connection timeouts

David Herrmann (18):
      Bluetooth: hidp: remove redundant error message
      Bluetooth: hidp: verify l2cap sockets
      Bluetooth: rename hci_conn_put to hci_conn_drop
      Bluetooth: remove unneeded hci_conn_hold/put_device()
      Bluetooth: introduce hci_conn ref-counting
      Bluetooth: hidp: remove unused session->state field
      Bluetooth: hidp: test "terminate" before sleeping
      Bluetooth: allow constant arguments for bacmp()/bacpy()
      Bluetooth: hidp: move hidp_schedule() to core.c
      Bluetooth: l2cap: introduce l2cap_conn ref-counting
      Bluetooth: l2cap: add l2cap_user sub-modules
      Bluetooth: hidp: add new session-management helpers
      Bluetooth: hidp: remove old session-management
      Bluetooth: hidp: handle kernel_sendmsg() errors correctly
      Bluetooth: hidp: merge hidp_process_{ctrl,intr}_transmit()
      Bluetooth: hidp: merge 'send' functions into hidp_send_message()
      Bluetooth: hidp: don't send boot-protocol messages as HID-reports
      Bluetooth: hidp: fix sending output reports on intr channel

Fr=E9d=E9ric Dalleau (1):
      Bluetooth: Move and rename hci_conn_accept

Jaganath Kanakkassery (1):
      Bluetooth: Fix incorrect SSP mode bit for non SSP devices

Johan Hedberg (6):
      Bluetooth: Track received events in hdev
      Bluetooth: Add __hci_cmd_sync() helper function
      Bluetooth: Add support for custom event terminated commands
      Bluetooth: Add __hci_cmd_sync_ev function
      Bluetooth: Track feature pages in a single table
      Bluetooth: Add reading of all local feature pages

Marcel Holtmann (4):
      Bluetooth: Add driver setup stage for early init
      Bluetooth: Convert BCM92035 support to driver setup callback
      Bluetooth: Remove driver init queue from core
      Bluetooth: Use separate function for BCM92035 vendor setup

Noguchi Kazutosi (1):
      Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]

 drivers/bluetooth/ath3k.c         |   2 +
 drivers/bluetooth/btusb.c         |  41 +-
 drivers/bluetooth/hci_h4.c        |   3 +
 drivers/bluetooth/hci_ldisc.c     |  15 +-
 include/net/bluetooth/bluetooth.h |   5 +-
 include/net/bluetooth/hci.h       |   9 +-
 include/net/bluetooth/hci_core.h  |  98 ++--
 include/net/bluetooth/l2cap.h     |  15 +
 net/bluetooth/hci_conn.c          |  38 +-
 net/bluetooth/hci_core.c          | 239 +++++++---
 net/bluetooth/hci_event.c         | 184 ++++----
 net/bluetooth/hci_sysfs.c         |  17 +-
 net/bluetooth/hidp/core.c         | 992 +++++++++++++++++++++++-----------=
------
 net/bluetooth/hidp/hidp.h         |  67 ++-
 net/bluetooth/hidp/sock.c         |  22 +-
 net/bluetooth/l2cap_core.c        | 127 ++++-
 net/bluetooth/l2cap_sock.c        |   6 +
 net/bluetooth/mgmt.c              |  17 +-
 net/bluetooth/sco.c               |  49 +-
 net/bluetooth/smp.c               |   2 +-
 20 files changed, 1213 insertions(+), 735 deletions(-)


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRb3sjAAoJEPs3PUX4s20oKmwP+wdaZB14rFmnua4d0VtFmEJx
1PQvdvkwlqEflXLP9D5IVuEofGbhbhUkS5R2tQsGtcNtBngO5SlVxnN5J0F4+JVe
fKUovVugtGL+Dp1i2sWbPntzZ1I47JuWE53UwngHgxEIqq0xi+0w2bxu16rNWELO
fsPYX/3u9mQadB6GF+VvOfbeoUQtt+mdgfFhb+65vI90m/r184jYOrV+Y+/drw6y
90KtKRghQDmlxi6y9Jv5uQw29l9cTMMGrGzhilyxIniMc80j0vJ4ZdA0Axs2iIm2
mQoHb9PbTbKb6rOh73eo8AGbB6WKWcENZLxj+JL7NVxl0SDQL1Coz29M45u/lAvL
RI769b52PsES2ckE0FX5MfaM1xJMboO3/zP9PzZZS2kW74HL7fuq97gx9Yurakpp
MZ5Rvfd8rcKVdr8noEOjVDQFlVwHAau98vYJpHkHVaBP0BGP6TyJwF2qb/ikS0y4
/iMWpcAAX+HTdbRWPrtrv+iOxHu0EyfUPLFINLtqVkOTSlidxGOrMYt2E106mSPD
eLibVzUm3MrwJvdTUr+cCTWBqr3dP34LV+npdP2xzdSuGcaAY5nCbgQNd5dnghaU
7qMpMTDKpDygiG5QU222/XwzyjcHkRvHdZwJ6+MvIZG0wPes1NMqQJbV7I6/lz9h
3EOmtJ0uaX7AslqXPIfU
=8KLa
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
