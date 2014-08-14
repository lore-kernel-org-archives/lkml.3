Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaHNOuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:50:15 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:61794 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaHNOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:50:13 -0400
Date: Thu, 14 Aug 2014 17:50:00 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-08-14
Message-ID: <20140814145000.GA14226@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here's our first bluetooth-next pull request for the 3.18 kernel. Our
tree is based on net-next so you'd need to pull from there first before
pulling from our tree.

The changes consists of:

	- Coding style fixes to HCI drivers
	- Corrupted ack value fix for the H5 HCI driver
	- A couple of Enhanced L2CAP fixes
	- Conversion of SMP code to use common L2CAP channel API
	- Page scan optimizations when using the kernel-side whitelist
	- Various mac802154 and and ieee802154 6lowpan cleanups
	- One new Atheros USB ID

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit f0094b28f3038936c1985be64dbe83f0e950b671:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-08-13 18:27:40 -0600)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 13cac15296afe7e42088ecfcd0f1d4b658248c46:

  Bluetooth: Fix ERTM L2CAP resend packet (2014-08-14 09:47:02 +0200)

----------------------------------------------------------------
Alexander Aring (1):
      ieee802154: 6lowpan: remove unused function

Himangi Saraogi (4):
      Bluetooth: Remove typedef bluecard_info_t
      Bluetooth: Remove typedef btuart_info_t
      Bluetooth: Remove typedefs nsh_t and dtl1_info_t
      Bluetooth: Remove typedef bt3c_info_t

Johan Hedberg (35):
      Bluetooth: Add convenience function to check for pending power off
      Bluetooth: Create unified helper function for updating page scan
      Bluetooth: Disable page scan if all whitelisted devices are connected
      Bluetooth: Remove redundant check for remote_key_dist
      Bluetooth: Fix confusion between parent and child channel for 6lowpan
      Bluetooth: Fix reference counting of global L2CAP channels
      Bluetooth: Fix __l2cap_no_conn_pending() usage with all channels
      Bluetooth: Resume BT_CONNECTED state after LE security elevation
      Bluetooth: Remove special handling of ATT in l2cap_security_cfm()
      Bluetooth: Refactor l2cap_connect_cfm
      Bluetooth: Move L2CAP fixed channel creation into l2cap_conn_cfm
      Bluetooth: Improve fixed channel lookup based on link type
      Bluetooth: Remove special ATT data channel handling
      Bluetooth: Move parts of fixed channel initialization to l2cap_add_scid
      Bluetooth: Call L2CAP teardown callback before clearing chan->conn
      Bluetooth: Call l2cap_le_conn_ready after notifying channels
      Bluetooth: Fix using HCI_CONN_LE_SMP_PEND to check for SMP context
      Bluetooth: Fix hci_update_random_address() error return for no crypto
      Bluetooth: Fix IRK lookup when tfm_aes is not available
      Bluetooth: Refactor SMP (de)initialization into separate functions
      Bluetooth: Move SMP initialization after HCI init
      Bluetooth: Move SMP (de)initialization to smp.c
      Bluetooth: Add more L2CAP convenience callbacks
      Bluetooth: Add SMP L2CAP channel skeleton
      Bluetooth: Make AES crypto context private to SMP
      Bluetooth: Convert SMP to use l2cap_chan infrastructure
      Bluetooth: Use L2CAP resume callback to call smp_distribute_keys
      Bluetooth: Add public l2cap_conn_shutdown() API to request disconnection
      Bluetooth: Call l2cap_conn_shutdown() when SMP recv callback fails
      Bluetooth: Fix double free of SMP data skb
      Bluetooth: Add SMP-internal timeout callback
      Bluetooth: Remove unused l2cap_conn->security_timer
      Bluetooth: Move canceling security_timer into smp_chan_destroy()
      Bluetooth: Always call smp_distribute_keys() from a workqueue
      Bluetooth: Make smp_chan_destroy() private to smp.c

Loic Poulain (1):
      Bluetooth: Fix HCI H5 corrupted ack value

Lukasz Rymanowski (2):
      Bluetooth: Improve data packing in SAR mode
      Bluetooth: Fix ERTM L2CAP resend packet

Varka Bhadram (4):
      MAINTAINERS: update maintainers info
      mac802154: cleanup in rx path
      mac802154: common error path
      mac802154: common tx error path

Vincent Zwanenburg (1):
      Add a new PID/VID 0227/0930 for AR3012.

 MAINTAINERS                      |   9 +-
 drivers/bluetooth/ath3k.c        |   2 +
 drivers/bluetooth/bluecard_cs.c  |  35 +-
 drivers/bluetooth/bt3c_cs.c      |  27 +-
 drivers/bluetooth/btuart_cs.c    |  27 +-
 drivers/bluetooth/btusb.c        |   1 +
 drivers/bluetooth/dtl1_cs.c      |  36 +-
 drivers/bluetooth/hci_h5.c       |   2 +-
 include/net/bluetooth/hci_core.h |   8 +-
 include/net/bluetooth/l2cap.h    |  33 +-
 net/bluetooth/6lowpan.c          |  10 +-
 net/bluetooth/hci_core.c         |  71 +++-
 net/bluetooth/hci_event.c        |  11 +-
 net/bluetooth/l2cap_core.c       | 309 +++++++--------
 net/bluetooth/l2cap_sock.c       |  15 +-
 net/bluetooth/mgmt.c             | 124 ++----
 net/bluetooth/smp.c              | 726 +++++++++++++++++++++++------------
 net/bluetooth/smp.h              |  10 +-
 net/ieee802154/6lowpan_rtnl.c    |   8 -
 net/mac802154/rx.c               |   5 +-
 net/mac802154/tx.c               |  15 +-
 net/mac802154/wpan.c             |  10 +-
 22 files changed, 877 insertions(+), 617 deletions(-)


--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT7MyYAAoJECQj9vv5qNQSMSYP/3SVBPoV3hkWmnfRY9l/C64h
NsK1dnztqqvq8Z+wpZ0JmhkfmYnGz7QHXlhBdx7IKXqwYF/Xsz0MLvCj6n//kGRC
mC+sPuBJSgZ0yqRSDa7CYh5VlhSled+cn09ffnwS1po+tgvLOs4saGts8NN7annN
2gF5wRZysRZh7nCF/A11nttiL26RhHMDvRb70Fo66Gr4GE+O7ps8GXLOq6e1VuFn
1X3nC1a8lzxFctdoqXmiKAd0Emv7D7HSagERWZtdnw9ugAX7bzh1HXvAfeUQNNcC
Xj/MYErYkiOJKEncWIpwNDoXzLoL9j25S04khWrGB8s+yGR3SsH1ITzDPvo9Tv3U
2MfkrdmXdIOZct8suwi/o4WMR1u05KmuKi80ntMyDtxkVPBovFQ0s+2vj/D2XkmV
r54GbeqdG/iwJ2zvwakFSpSH9ERZQ4ryty66FcbR0yRU9Q+UFc9fUhSQBFa45esd
DdRadC48iCUcOmyf7rF7L6diZMVQK+STk+MUJ/xgID7/V6weImBuvBt/+pgIXRey
U4DliilN4Zr5v4aLw4V6v1HPExPrR98oEYVeyfGHD0MQFvrzCc1FhDztdYZivljv
4L7pwfWaddMkMOeAuFNppOdJOx9A2feaTlZxgRMs5VEAyNB3Ix9MTssypWH5DvKn
YKGjm77oiZfj14zevxB9
=Jbds
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
