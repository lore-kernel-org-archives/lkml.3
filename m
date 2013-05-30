Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab3E3Wwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:52:47 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45042 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3E3Wwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:52:39 -0400
Date: Thu, 30 May 2013 19:52:32 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-05-30
Message-ID: <20130530225232.GB14083@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

The following patches are important bug fixes for 3.10, plus the support for a
new device. We do have three fixes from Johan. The first one is a fix to avoid
LE-only devices to rely on the (inexistent) extended features data. The second
patch fixes length checks on incoming L2CAP signalling PDUs so we can discard
PDU whose size doesn't match the one reported in the header.
The last one fixes the handling of power on failures, we now report proper
errors to mgmt when hci_dev_open().

Please pull or let me know of any issues! Thanks.

	Gustavo

---

The following changes since commit f942d116b80feb3ae618a0d8ce2df6e853526d3c:

  brcmsmac: fix regression observed in 3.10-rc1 (2013-05-29 14:46:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to 0f9e216b0e12971af8a1d39c98c353c76533283b:

  Bluetooth: Fix mgmt handling of power on failures (2013-05-30 18:36:08 -0300)

----------------------------------------------------------------
Bing Zhao (1):
      Bluetooth: btmrvl: support Marvell Bluetooth device SD8897

Johan Hedberg (3):
      Bluetooth: Fix checks for LE support on LE-only controllers
      Bluetooth: Fix missing length checks for L2CAP signalling PDUs
      Bluetooth: Fix mgmt handling of power on failures

 drivers/bluetooth/Kconfig        |  4 +--
 drivers/bluetooth/btmrvl_sdio.c  | 28 ++++++++++++++++++
 include/net/bluetooth/hci_core.h |  1 +
 include/net/bluetooth/mgmt.h     |  1 +
 net/bluetooth/hci_core.c         |  6 +++-
 net/bluetooth/l2cap_core.c       | 70 ++++++++++++++++++++++++++++++++------------
 net/bluetooth/mgmt.c             | 23 ++++++++++++++-
 net/bluetooth/smp.c              |  4 +--
 8 files changed, 113 insertions(+), 24 deletions(-)


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRp9gwAAoJEPs3PUX4s20ozpEP/0rBewYThcZk/uSEA2lu1011
eOaj7LXxiMKVKesNGrpbmDyPiVwy5MiQUthPt3DOGt9TSwHOO3zndlt9mCJtuqeg
/yyhT2ApNyLN58sGfsg2mFYuq4TAlKjLOgjJxGdq0zLQo5Ip+T4dagFmdeYaMEgG
agH+aIbmrBqU5/rz3YsTvDFbK4ww0roLuHtthVP7W4iFd5JwETSGn/u2xGbH3z7p
X1p/3JvrGmen/fuTIhS1kfCeigKob9c/tXjTyjpS4pFzBZq4BIYxRYJmhnlri0Hv
+8JKvfDA6cxyZ7Hsnr9W/ZkKPQmQw5xmqL7b+Ui2jnxf0HKnDYxd6aY62r1kELFZ
cJfO6VicQXNcUbwuCnR/28DRJ2giKa7pZOzY9dq2r1OH0DJYn65+b4XetUBAD1Kk
8gUFxks5/rYKNRt2tTEa6ZPFzcm0JqMEoZTpI1d2UDRvMKQoQiuytfLqGSW+5mAB
wAArBED1kv6qxkpXUq1KPeWbQ3r4TpUZk38NhDqAn00BOWb4FMvNRwcqoPoq/iVS
n2+CZw7tDqi192nWCrqSELkLRkP+03eh07XMzahDThk7lr32KFkJlJlJO1YbLa7z
Zf/72A4BfKfUV4hJT2nppD42Ju6WVSkRvnI7ygGafinUIEVS8X079VOeuDUrAQSY
xsSGZBcu3YAkwt/PHMso
=hu5I
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
