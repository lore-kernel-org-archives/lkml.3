Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaGaHoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:44:16 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:59298 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaGaHoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:44:10 -0400
Date: Thu, 31 Jul 2014 10:43:57 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-07-31
Message-ID: <20140731074357.GA26071@t440s.lan>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here's one more (hopefully last) pull request for 3.17.

We've got:

- 6lowpan fixes/cleanups
- A couple crash fixes, one for the Marvell HCI driver and another in LE SMP.
- Fix for an incorrect connected state check
- Fix for the bondable requirement during pairing (an issue which had
  crept in because of using "pairable" when in fact the actual meaning
  was "bondable" (these have different meanings in Bluetooth)

Let me know if there are any issues. Thanks.

Johan

---
The following changes since commit 568ba389be505f505b7fbeedb9ab4ece27603fc9:

  brcmfmac: Fix OOB interrupt not working for BCM43362 (2014-07-29 10:32:57 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 8500d791c458ccbbb3e2d3fa9a0320ffd5729069:

  Bluetooth: Fix crash in the Marvell driver initialization codepath (2014-07-31 01:07:28 +0200)

----------------------------------------------------------------
Alexander Aring (7):
      6lowpan: iphc: rename hc06_ptr pointer to hc_ptr
      6lowpan: iphc: use sizeof in udp uncompression
      6lowpan: iphc: cleanup use of lowpan_fetch_skb
      6lowpan: iphc: cleanup use of lowpan_push_hc_data
      6lowpan: iphc: use ipv6 api to check address scope
      6lowpan: iphc: remove check on null
      6lowpan: remove unused LOWPAN_FRAG_SIZE define

Anatol Pomozov (1):
      Bluetooth: Fix crash in the Marvell driver initialization codepath

Johan Hedberg (5):
      Bluetooth: Fix SMP context tracking leading to a kernel crash
      Bluetooth: Fix check for connected state when pairing
      Bluetooth: Rename HCI_PAIRABLE to HCI_BONDABLE
      Bluetooth: Rename pairable mgmt setting to bondable
      Bluetooth: Always use non-bonding requirement when not bondable

Marcel Holtmann (6):
      6lowpan: iphc: Fix block comments to match networking style
      6lowpan: iphc: Fix issues with alignment matching open parenthesis
      6lowpan: iphc: Fix missing blank line after variable declarations
      6lowpan: iphc: Fix missing braces for if statement
      6lowpan: iphc: Fix parenthesis alignments which off-by-one
      Bluetooth: Fix sparse warning from HID new leds handling

Varka Bhadram (2):
      6lowpan: remove unused macros
      6lowpan: remove unused function

 drivers/bluetooth/btmrvl_main.c |   5 +
 include/net/6lowpan.h           |  50 ------
 include/net/bluetooth/hci.h     |   2 +-
 include/net/bluetooth/mgmt.h    |   4 +-
 net/6lowpan/iphc.c              | 295 +++++++++++++++++-------------------
 net/bluetooth/hci_core.c        |   4 +-
 net/bluetooth/hci_event.c       |  15 +-
 net/bluetooth/hidp/core.c       |   2 +-
 net/bluetooth/mgmt.c            |  24 +--
 net/bluetooth/smp.c             |  17 ++-
 10 files changed, 185 insertions(+), 233 deletions(-)


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2fO9AAoJECQj9vv5qNQS3e0P/1GLtWm1uJBLJXMm5VlpkT2t
tq1aQoOMvFFx6XRwyD6ZKzQ28QyB4sIg580NTU+DQYt47eO4Bru+Gu1Bd7KzWX8p
qBQNx9+W8CQUfEXG8RwkO0xJQ1P6hezLUYJOs1fFpTS6x9cpP6bQWK8sK/jB8SWB
nyC5+uei3nFVpH4jMZtNxD1xv9O+LUxPalmA9OZIXk5DOPlZmjK4uilKwSYAmR1T
DtFqQd3J8VOyxFoXjXK4+cp6l4Zz/YZ7bohI2YhaHw2gDU5Jf0joRxqqRutoboLA
29CIJtblq21DSME2NTfb5/3iZ/0Gnlf76LV8TWgrN5WTfgiAgNErSigGsaygfGpz
GnFZm42CbH74GlQ4Y5fQkdeXJ1bAAOraSgBpMBvCBmZI6ClTaHbOl+vEeLayltJd
8UlJL9dOlummDvzpVcOPurzsnAAqA/WqWr3766KlgGqTmRLtlZZzgvcvyAkUdK2k
LRfMguoPFbNDePVtmQQGUUl8WLldV4z29g+f14Us57o5niiyO3Fsp4dyMrbcku0d
Bz39u5+iKT7Yi62D4U2h01Po/4LPhwT9U9hANtmj729/dIJWLbBUPuxbw7sCt7Ft
hGCCls/6DvDwDkio+kCdJifol0+aSfJHRZhXdlTfmllGY04x5U8GL4IN2xz2kOd4
SvKRMQ/h7bKCFWdWbSP/
=1mbE
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
