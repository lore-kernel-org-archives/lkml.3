Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab3BARlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:41:00 -0500
Received: from mail-ye0-f169.google.com ([209.85.213.169]:53736 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3BARk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:40:57 -0500
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 12:40:57 EST
Date: Fri, 1 Feb 2013 15:40:19 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-02-01
Message-ID: <20130201174019.GD4733@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Here goes another batch intended for 3.9, the majority of the patch here are
=66rom Johan who is fixing many issues in the management interface that have
appeared lately. The rest of the patches are just small improvements, fixes
and clean ups.

Please pull! Thanks a lot!

	Gustavo

---

wing changes since commit e7f767a7d9f809c494bfffffeda2bbdbfec110b4:

  mwifiex: use map/unmap APIs in TX and RX to reduce memcpy (2013-01-07 15:=
18:30 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next ma=
ster

for you to fetch changes up to 6f02fc91b645ac909bec2d55ee1f345177282f37:

  Bluetooth: Refactor mgmt_pending_foreach (2013-02-01 14:49:24 -0200)

----------------------------------------------------------------
Andre Guedes (3):
      Bluetooth: Reduce critical section in sco_conn_ready
      Bluetooth: Remove unneeded locking
      Bluetooth: Refactor mgmt_pending_foreach

Andrei Emeltchenko (4):
      Bluetooth: AMP: Send A2MP Create Phylink Rsp after Assoc write
      Bluetooth: AMP: Clean up logical link create / accept
      Bluetooth: AMP: Remove dead code
      Bluetooth: AMP: Use set_bit / test_bit for amp_mgr state

Gustavo Padovan (1):
      Bluetooth: Fix uuid output in debugfs

Johan Hedberg (36):
      Bluetooth: Fix missing command complete event for mgmt_confirm_name
      Bluetooth: Fix missing command complete for mgmt_load_long_term_keys
      Bluetooth: Fix checking for valid device class values
      Bluetooth: Fix accepting set_dev_class for non-BR/EDR controllers
      Bluetooth: Move non-critical sections outside of the dev lock
      Bluetooth: Fix checking for exact values of boolean mgmt parameters
      Bluetooth: Fix returning proper command status for start_discovery
      Bluetooth: Fix sending incorrect new_settings for mgmt_set_powered
      Bluetooth: Add a new workqueue for hci_request operations
      Bluetooth: Use req_workqueue for hci_request operations
      Bluetooth: Fix using system-global workqueue when not necessary
      Bluetooth: Fix Class of Device indication when powering off
      Bluetooth: Fix checking for correct mgmt_load_link_keys parameters
      Bluetooth: Fix returning proper mgmt status for Load LTKs
      Bluetooth: Fix checking for proper key->master value in Load LTKs
      Bluetooth: Refactor valid LTK data testing into its own function
      Bluetooth: Check for valid key->authenticated value for LTKs
      Bluetooth: Add helper functions for testing bdaddr types
      Bluetooth: Fix checking for valid address type values in mgmt commands
      Bluetooth: Fix checking for valid disconnect parameters in unpair_dev=
ice
      Bluetooth: Fix returning proper cmd_complete for mgmt_disconnect
      Bluetooth: Fix returning proper cmd_complete for mgmt_block/unblock
      Bluetooth: Add LE Local Features reading support
      Bluetooth: Add support for reading LE White List Size
      Bluetooth: Add support for reading LE supported states
      Bluetooth: Store UUIDs in the same order that they were added
      Bluetooth: Simplify UUIDs clearing code
      Bluetooth: Keep track of UUID type upon addition
      Bluetooth: Simplify UUID removal code
      Bluetooth: Simplify UUID16 list generation for EIR
      Bluetooth: Remove useless eir_len variable from EIR creation
      Bluetooth: Refactor UUID-16 list generation into its own function
      Bluetooth: Add support for 32-bit UUIDs in EIR data
      Bluetooth: Add support for 128-bit UUIDs in EIR data
      Bluetooth: Fix link security setting when powering on
      Bluetooth: Increment Management interface revision

Rami Rosen (2):
      Bluetooth: Remove unnecessary include l2cap.h
      Bluetooth: remove an unused variable in a header file

Szymon Janc (3):
      Bluetooth: mgmt: Remove not needed restriction on add/remove OOB data
      Bluetooth: mgmt: Avoid using magic number in status code
      Bluetooth: Fix pair device command reply if adapter is powered off

 include/net/bluetooth/a2mp.h      |   4 +-
 include/net/bluetooth/bluetooth.h |  23 ++
 include/net/bluetooth/hci.h       |  18 ++
 include/net/bluetooth/hci_core.h  |   5 +
 include/net/bluetooth/l2cap.h     |   1 -
 net/bluetooth/a2mp.c              |  42 +++-
 net/bluetooth/amp.c               |  25 +-
 net/bluetooth/bnep/core.c         |   1 -
 net/bluetooth/hci_core.c          |  30 ++-
 net/bluetooth/hci_event.c         |  64 +++++-
 net/bluetooth/hci_sysfs.c         |  22 +-
 net/bluetooth/l2cap_core.c        |   5 -
 net/bluetooth/mgmt.c              | 489 +++++++++++++++++++++++++++-------=
------
 net/bluetooth/sco.c               |  18 +-
 14 files changed, 525 insertions(+), 222 deletions(-)


--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRC/4DAAoJEPs3PUX4s20oVqUP/0Uma5LsUolQT6S9y2R7tdYc
lLuSltlsVYTquXqFXfebj528CmG7n1CJ3srzy9VtmehfT6ATiHv1KicyCpvbcQ1F
GpcR5X0ngWFUnF7SpdzTLfj37T6i5s3Fbm/M4yI0VlX3mSXcsHPZABbeOzyh6lu/
pScEqZCJUK6jE8ZVagoCF0tZaVwZXNjAFhFKGBtqMXy+JL+fOqcEKkPIvJtMBxhn
pPp0+J8hrfMKjIaR+8t1wcASrZOOuT01+KmLWO9bLxySa63P8K7ud6V2r776iq9T
/eFEqDzsF9+eYeQu9LDAGLUgxRuxB5P32T5hd1Qg8+OMHdOfauHDi3GmpXbmrtbw
rFmpVY64m8tkG2ZrpVAjAOFt5AM9T3S2dvujAwxYXxUOWBvmqkxkBhypWI3Yf+RT
h3O4rj7Js/nahx3rpWbuXQPor45qaP9lFbRQaiZdsa3SZX9Q1rMG7ZqoaYdgth20
h2aUK3iUo86HqtVi1h7X6QLoh9CWobyHBSmDu4lza99aP+x435a5PcggH8CP6mMJ
O9VCydygQ0xjt3kEr+k9JXewkfmt7FHI1U2Sb0w4TG1hBc3CPONr0aztPe1QNP62
c4DEAeDZbz00Ga1stmypQcMnhY43BqfdW4NuHFKBXpxyr12vH6X1nR5f8qmaqYG4
7SdvxnNkmJnrsWumrO8N
=54hz
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
