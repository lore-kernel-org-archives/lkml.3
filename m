Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3FMLWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 07:22:34 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:48157 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3FMLWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 07:22:32 -0400
Date: Thu, 13 Jun 2013 12:22:28 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2013-06-13
Message-ID: <20130613112228.GB17870@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

A few important fixes to 3.10. The first one is a crash fix and talks by itself.
Then we have the support for a device id, it should be fine if you want to
remove this. Next there are two btmrvl fixes, one for a potential race
condition that could make its main thread never stop and the other to fix the
return code when a memory allocation fails. It was returning 0 instead of
-ENOMEM. Last is a fix to an issue that affects at least some Thinkpad X60,
Initialization on those laptops were failing due by unsupported cmd we were
sending to the device. The patch fixes this by checking if the cmd is
supported first.

Please pull or let me know of any concerns you may have.

	Gustavo

---
The following changes since commit d90b9e29ec5fe7a08eb7965386ebb47615306584:

  Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2013-06-12 14:28:21 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to 0e1aba9361bf292fbdca781d419dca67d6b9911f:

  Bluetooth: btmrvl: fix thread stopping race (2013-06-13 11:48:38 +0100)

----------------------------------------------------------------
Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Cho, Yu-Chen (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

Daniel Drake (1):
      Bluetooth: btmrvl: fix thread stopping race

Johan Hedberg (1):
      Bluetooth: Fix conditions for HCI_Delete_Stored_Link_Key

Wei Yongjun (1):
      Bluetooth: btmrvl: fix error return code in btmrvl_sdio_card_to_host()

 drivers/bluetooth/btmrvl_main.c |  9 ++++-----
 drivers/bluetooth/btmrvl_sdio.c |  1 +
 drivers/bluetooth/btusb.c       |  3 +++
 net/bluetooth/hci_core.c        | 15 ++++++++++-----
 net/bluetooth/l2cap_core.c      |  3 +++
 5 files changed, 21 insertions(+), 10 deletions(-)


--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRuat0AAoJEPs3PUX4s20omJwP/iqoxp1m7A3mtRWi5VdcclWM
1G/Lyo/gHPK/0tW11ypI6ppogp25B6mxhyhFXHYRK6dVBo3t36ag0ABTcvNgzp1J
TGBsKUn0+GzyBqcUmRuRj+3X4m9F6fbLcWcU22vmNfJ0s+lhsgi08D7tN01G7NdU
Bj5ASouMplFj1GHdqThDtFD7YMTbxohOOVkrW7M2ZdSfYX0f0wLFAimReaA9a41U
GBaTBi/xBAq50NeZGmDC57e6/kJHdX1CG3+/NYfwwFEHfI4uCmNwnQPkhnHkbVmO
gZ0DNZ0/P5svbocNCi1Z4GUJtnL3WLrMiH17rvlUR0QPSa0P/C7AUoyKm6au4SSk
Z/xaKsmgRbdAE9cX6C702IqkhWhwz3DXqUm7Bk4T/7x1J7Yep5jnYvTAxDZukKYN
SYOeUVB2aGHzTEBLH2ZhK+qFJKiUVtsLo2w73xODi0rFcv7aTL1D/MognvqokzsM
1qD5VXk+UEFMzSoBLpkvkaI+J4mxcBitzyHNY3Y55lqXSNd4nRCNrVyLWJpFhGHw
SyCFQ4gDQ+b/9rI1Y732ZU32t+qA8UBtnnfu41sRi1itFPr+h1GYuK0qtbvPblom
OBJXLxavVS5vIFlXcY8I19UHmENFLAfAhVdJePZo/UQvCXCVF8PS2jAIRU857rgs
/KUyaA8rBYxeh/ZFl1Z/
=dRCI
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
