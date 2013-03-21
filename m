Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3CUWYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:24:54 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:54623 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab3CUWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:24:53 -0400
Date: Thu, 21 Mar 2013 19:24:08 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-03-21
Message-ID: <20130321222408.GA8890@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

This is our first batch of patches for 3.10. The biggest changes of this pu=
ll
request are from Johan Hedberg, he implemented a HCI request framework to m=
ake
life easier when we have to send many HCI commands and a block and wait for
all of the to finish, we were able to fix a few issues in stack with the
introduction of this framework.

Other than that Dean Jenkins did a good work cleaning the RFCOMM code, the
refcnt infrastructure was removed and now we use NULL pointer checks to know
when a object was freed or not. That code was buggy and now it looks a way
better.

The rest of changes are clean ups, fixes and small improvements all over the
Bluetooth subsystem.=20

Please pull, or let me know of any issues! Thanks.

	Gustavo

---
The following changes since commit 7da060c1c01b103d181dba39bce9bd141a945f99:

  mwifiex: add WOWLAN support (2013-03-06 16:29:17 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream

for you to fetch changes up to 0227c7b56959cd8f5edd20b6a47db86fa553e91a:

  Bluetooth: fix error return code in rfcomm_add_listener() (2013-03-20 14:=
17:52 -0300)

----------------------------------------------------------------
Alexandru Gheorghiu (2):
      Bluetooth: Use PTR_RET function
      Bluetooth: Replaced kzalloc and memcpy with kmemdup

Andre Guedes (7):
      Bluetooth: Rename hci_acl_disconn
      Bluetooth: Fix __hci_req_sync
      Bluetooth: Return ENODATA in hci_req_run
      Bluetooth: Check hci_req_run returning value in __hci_req_sync
      Bluetooth: HCI request error handling
      Bluetooth: Make hci_req_add returning void
      Bluetooth: Check req->err in hci_req_add

David Herrmann (2):
      Bluetooth: discard bt_sock_unregister() errors
      Bluetooth: change bt_sock_unregister() to return void

Dean Jenkins (6):
      Bluetooth: Avoid rfcomm_session_timeout using freed session
      Bluetooth: Check rfcomm session and DLC exists on socket close
      Bluetooth: Return RFCOMM session ptrs to avoid freed session
      Bluetooth: Remove RFCOMM session refcnt
      Bluetooth: Remove redundant call to rfcomm_send_disc
      Bluetooth: Remove redundant RFCOMM BT_CLOSED settings

Johan Hedberg (38):
      Bluetooth: Rename hci_request to hci_req_sync
      Bluetooth: Fix __hci_req_sync() handling of empty requests
      Bluetooth: Split HCI init sequence into three stages
      Bluetooth: Add initial skeleton for asynchronous HCI requests
      Bluetooth: Refactor HCI command skb creation
      Bluetooth: Introduce new hci_req_add function
      Bluetooth: Fix stand-alone HCI command handling
      Bluetooth: Add request cmd_complete and cmd_status functions
      Bluetooth: Use async requests internally in hci_req_sync
      Bluetooth: Remove unused hdev->init_last_cmd
      Bluetooth: Remove empty HCI event handlers
      Bluetooth: Fix endianness handling of cmd_status/complete opcodes
      Bluetooth: Move power on HCI command updates to their own function
      Bluetooth: Update mgmt powered HCI commands to use async requests
      Bluetooth: Wait for HCI command completion with mgmt_set_powered
      Bluetooth: Fix busy condition testing for EIR and class updates
      Bluetooth: Fix UUID/class mgmt command response synchronization
      Bluetooth: Remove useless HCI_PENDING_CLASS flag
      Bluetooth: Add a define for the HCI persistent flags mask
      Bluetooth: Clear non-persistent flags when closing HCI device
      Bluetooth: Fix clearing flags on power off before notifying mgmt
      Bluetooth: Fix waiting for EIR update when setting local name
      Bluetooth: Handle AD updating through an async request
      Bluetooth: Fix local name setting for LE-only controllers
      Bluetooth: Fix setting local name to the existing value
      Bluetooth: Use an async request for mgmt_set_connectable
      Bluetooth: Fix fast connectable response sending
      Bluetooth: Limit fast connectable support to >=3D 1.2 controllers
      Bluetooth: Fix error response for simultaneous fast connectable comma=
nds
      Bluetooth: Add proper flag for fast connectable mode
      Bluetooth: Refactor fast connectable HCI commands
      Bluetooth: Disable fast connectable when disabling connectable
      Bluetooth: Add reading of page scan parameters
      Bluetooth: Update page scan parameters after successful write commands
      Bluetooth: Fix updating page scan parameters when not necessary
      Bluetooth: Fix fast connectable state when enabling page scan
      Bluetooth: Simplify address parameters of user_pairing_resp()
      Bluetooth: Fix PIN/Confirm/Passkey response parameters

Karl Relton (1):
      Bluetooth: Make hidp_get_raw_report abort if the session is terminati=
ng

Lubomir Rintel (1):
      bluetooth: btmrvl_sdio: look for sd8688 firmware in proper location

Wei Yongjun (1):
      Bluetooth: fix error return code in rfcomm_add_listener()

 drivers/bluetooth/btmrvl_sdio.c   |   8 +-
 include/net/bluetooth/bluetooth.h |  12 +-
 include/net/bluetooth/hci.h       |  21 +-
 include/net/bluetooth/hci_core.h  |  28 +-
 include/net/bluetooth/rfcomm.h    |   6 -
 net/bluetooth/a2mp.c              |   6 +-
 net/bluetooth/af_bluetooth.c      |  15 +-
 net/bluetooth/bnep/sock.c         |   4 +-
 net/bluetooth/cmtp/sock.c         |   4 +-
 net/bluetooth/hci_conn.c          |   4 +-
 net/bluetooth/hci_core.c          | 727 +++++++++++++++++++++++++++++++++-=
------
 net/bluetooth/hci_event.c         | 605 ++++++---------------------------
 net/bluetooth/hci_sock.c          |   9 +-
 net/bluetooth/hci_sysfs.c         |   4 +-
 net/bluetooth/hidp/core.c         |   4 +
 net/bluetooth/hidp/sock.c         |   4 +-
 net/bluetooth/l2cap_sock.c        |   4 +-
 net/bluetooth/mgmt.c              | 680 +++++++++++++++++++++++++---------=
---
 net/bluetooth/rfcomm/core.c       | 167 +++++----
 net/bluetooth/rfcomm/sock.c       |   3 +-
 net/bluetooth/sco.c               |   3 +-
 21 files changed, 1329 insertions(+), 989 deletions(-)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRS4iIAAoJEPs3PUX4s20oepkP/RmlS8vtEr1v7el8WAgUaCFB
sZafm95zZb9ylhTU3Mp9/DFwWTT7aY7i80M02etws+htwWJ7sq+NpQf5l6KxqZc0
gytpg0STLcMYSnyoOGhXgnC8zuPglc4OuPbDEKlJbCmlsoZ8ImVYQJ2EpwzoXsNE
wmxTyEBWlr0qqsDVw2t3W6J6bmJl/cRPelcC1ZZq4EVjyR6vH6JWUOfQVzU7ESqA
ndEWXn4B44kjaQKW4EqJyW7SIzEPm1dgF5KisgTzOW/7uMU6siEbfc59duGlunJD
RMkv576U0P3xdmb/zYz5RROqWihlmmF4qUr/n0y/l2e1xcnBR4VmhS2t3wPk1AM3
ihJKHVg8jhgQMo7H8troE1x1dquJojHYh30nrFzH+gWL9z/IAmrBYpYJI5T+Hsjm
0qiKpp/pTV1F35W0pRwJt+VzpOKxQiuhvBexujju3oppvjG3igXRMpq7TZBzh1gh
K4LB0lX5ZP4v9WTfjEycfpE4+GtobPNx7MxknMSCJMib2zXPCZBBAmaa3U+ZTpe8
Rp7bb/ljelDWnd2cJMhMCTZ3EgQUbuDLj255xugYjtduGvQ0nx9YY63cki2z6QbV
dyC0uk2lZQujxuhbaAAH7s5J2ygSTAmk3PdNUBiBEbZ6bSLT7eSooSAxwbOqpzIu
abL3ylVgcbukt0i6AH3z
=n2wf
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
