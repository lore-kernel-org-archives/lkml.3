Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaIYLgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:36:06 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38072 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaIYLgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:36:03 -0400
Date: Thu, 25 Sep 2014 14:35:53 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-09-25
Message-ID: <20140925113553.GA9506@t440s.kiipula.fi>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

This 3.18 pull request replaces the one I did on Monday ("bluetooth-next
2014-09-22", which hasn't been pulled yet). The additions since the last
request are:

 - SCO connection fix for devices not supporting eSCO
 - Cleanups regarding the SCO establishment logic
 - Remove unnecessary return value from logging functions
 - Header compression fix for 6lowpan
 - Cleanups to the ieee802154/mrf24j40 driver

Here's a copy from previous request that this one replaces:

"
Here are some more patches for 3.18. They include various fixes to the
btusb HCI driver, a fix for LE SMP, as well as adding Jukka to the
MAINTAINERS file for generic 6LoWPAN (as requested by Alexander Aring).

I've held on to this pull request a bit since we were waiting for a SCO
related fix to get sorted out first. However, since the merge window is
getting closer I decided not to wait for it. If we do get the fix sorted
out there'll probably be a second small pull request later this week.
"

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 9a783a139c32a905825ee0aa9597f485ea461f76:

  Bluetooth: Fix re-setting RPA as expired when deferring update (2014-09-12 18:34:25 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 565766b087a6d6ff257f5b79c8ceda0188c9169f:

  Bluetooth: Rename sco_param_wideband table to esco_param_msbc (2014-09-25 10:35:08 +0200)

----------------------------------------------------------------
Bernhard Thaler (1):
      Bluetooth: Check for SCO type before setting retransmission effort

Joe Perches (1):
      Bluetooth: Convert bt_<level> logging functions to return void

Johan Hedberg (5):
      Bluetooth: btusb: Use GFP_KERNEL in btusb_send_frame()
      Bluetooth: Fix setting correct security level when initiating SMP
      Bluetooth: Fix reason code used for rejecting SCO connections
      Bluetooth: Add retransmission effort into SCO parameter table
      Bluetooth: Rename sco_param_wideband table to esco_param_msbc

Jukka Rissanen (1):
      MAINTAINERS: add maintainer for generic 6LoWPAN

Marcel Holtmann (7):
      Bluetooth: btusb: Separate TX URB allocation and submission
      Bluetooth: Add BUILD_BUG_ON check for SKB control buffer size
      Bluetooth: Provide HCI command opcode information to driver
      Bluetooth: btusb: Fix old coding style issues
      Bluetooth: btusb: Split fragement receiption into separate functions
      Bluetooth: btusb: Implement driver internal packet reassembly
      Bluetooth: Remove exported hci_recv_fragment function

Simon Vincent (1):
      ieee802154: 6lowpan: ensure header compression does not corrupt ipv6 header

Varka Bhadram (3):
      mrf24j40: fix Missing a blank line after declarations
      mrf24j40: remove unnecessary return statement
      mrf24j40: use pr_* / dev_* instead of printk()

 MAINTAINERS                       |   1 +
 drivers/bluetooth/btusb.c         | 511 ++++++++++++++++++++++++++----------
 drivers/net/ieee802154/mrf24j40.c |  19 +-
 include/net/bluetooth/bluetooth.h |   5 +-
 include/net/bluetooth/hci.h       |   1 +
 include/net/bluetooth/hci_core.h  |   1 -
 net/bluetooth/af_bluetooth.c      |   3 +
 net/bluetooth/hci_conn.c          |  43 +--
 net/bluetooth/hci_core.c          |  21 +-
 net/bluetooth/lib.c               |  14 +-
 net/bluetooth/smp.c               |   5 +-
 net/ieee802154/6lowpan_rtnl.c     | 125 ++++++---
 12 files changed, 518 insertions(+), 231 deletions(-)


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUI/4ZAAoJECQj9vv5qNQSio0QAKgB13Yewcyq0ie5QosxhELz
nAkseFnTgvxpFIJiwkEtCJ5GvHnFDenPskIjPQGy1vOxukklxKqYxoajBwO2yrxK
eAEwAofP3u+PsAVDrUtKWeYuyQP6DAR35gCvRF1w4MZqpCKBydAMkWMn4qxH8cl7
UGBwTd72gDCZcNmEPxX72aDEDX1a7AgKhtevvznQv+92JyLtTIXiKvNKgckQNG5q
01r8QlAXQs2aNZuaZ0tAM7E1m8Q8XzTnG16ABMUmMi+XMSeuCJphHBjjKEJeNDN3
tXquRS7KbQNxplFG77OO34Iwe5dNYyTslQFaaO5vffrNeztBm83UczcrAPQrdGDZ
+9yDO6J5vLS4kGni+f9tsTVEEx9/oJezBZtdYTi2zKuIZCtjHsUBylYzRelEvUlb
2JZVXdxrkttRK/jFnYSa+Gr2yGWgQVY1p3FUIGzOCwjG2JKSYNeQfw6ldF9Lk2RG
AXnAX0Wi/aQkvL5dPPUwEe9/GboPF+hh0QRGwv8Ta8agS4ZytLFuIdLMMTskFrj2
Bcav3MqWrvg+aFnhkLpzWxw00uCWV/Rak5uah5vNfV87yIqFgjuVaJ/ZvjqvQt52
6o5BB1Sn5OWPwMeu1pkhfUW+OPHFALiD05t4GskKGPBSkg0kPF/b6ltvZB3+67nM
uovz3FyEz4A8hfFVr9ez
=lAtS
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
