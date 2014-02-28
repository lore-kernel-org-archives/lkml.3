Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaB1Ti2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:38:28 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:47952 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaB1Ti0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:38:26 -0500
Date: Fri, 28 Feb 2014 16:38:19 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-02-28
Message-ID: <20140228193819.GA1700@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Another pull request to 3.15. Here we have the second part of the LE private
feature, the LE auto-connect feature and improvements to the power off
procedures. The rest are small improvements, clean up, and fixes.

Please pull or let me know of any problem. Thanks.

	Gustavo

---

The following changes since commit 668b7b19820b0801c425d31cc27fd6f499050e5c:

  Bluetooth: Fix iterating wrong list in hci_remove_irk() (2014-02-21 11:07:46 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 81ad6fd9698f659dbabdc6cd3e1667a98eb2be3b:

  Bluetooth: Remove unnecessary stop_scan_complete function (2014-02-28 10:28:17 -0800)

----------------------------------------------------------------
Andre Guedes (17):
      Bluetooth: Create hci_req_add_le_scan_disable helper
      Bluetooth: Declare le_conn_failed in hci_core.h
      Bluetooth: Stop scanning on LE connection
      Bluetooth: Remove unused function
      Bluetooth: Refactor HCI connection code
      Bluetooth: Move address type conversion to outside hci_connect_le
      Bluetooth: Introduce hdev->pend_le_conn list
      Bluetooth: Introduce LE auto connection infrastructure
      Bluetooth: Introduce LE auto connect options
      Bluetooth: Connection parameters and auto connection
      Bluetooth: Temporarily stop background scanning on discovery
      Bluetooth: Auto connection and power on
      Bluetooth: Connection parameters and resolvable address
      Bluetooth: Support resolvable private addresses
      Bluetooth: Add le_auto_conn file on debugfs
      Bluetooth: Create hci_req_add_le_passive_scan helper
      Bluetooth: Update background scan parameters

Andrzej Kaczmarek (1):
      Bluetooth: Fix NULL pointer dereference when sending data

Johan Hedberg (47):
      Bluetooth: Add helper variables to smp_distribute_keys()
      Bluetooth: Add initial code for distributing local IRK
      Bluetooth: Move enable/disable_advertising higher up in mgmt.c
      Bluetooth: Add mgmt defines for privacy
      Bluetooth: Add Privacy flag to mgmt supported/current settings
      Bluetooth: Ensure hci_conn always contains the local identity address
      Bluetooth: Set the correct values for Identity Address Information
      Bluetooth: Add SMP function for generating RPAs
      Bluetooth: Add timer for regenerating local RPA
      Bluetooth: Add hci_update_random_address() convenience function
      Bluetooth: Use hci_update_random_address() when connecting LE
      Bluetooth: Use hci_update_random_address() for enabling advertising
      Bluetooth: Use hci_update_random_address() for initiating LE scan
      Bluetooth: Don't write static address during power on
      Bluetooth: Add debugfs entry for RPA regeneration timeout
      Bluetooth: Add support for Set Privacy command
      Bluetooth: Fix setting correct src_type when connecting LE
      Bluetooth: Remove unneeded hdev->own_addr_type
      Bluetooth: Enable RPA resolving if mgmt_set_privacy is called
      Bluetooth: Fix canceling RPA expiry timer
      Bluetooth: Add convenience function for getting total connection count
      Bluetooth: Move HCI_ADVERTISING handling into mgmt.c
      Bluetooth: Move check for MGMT_CONNECTED flag into mgmt.c
      Bluetooth: Don't clear HCI_DISCOVERABLE when powering off
      Bluetooth: Don't clear HCI_CONNECTABLE when powering off
      Bluetooth: Don't clear HCI_ADVERTISING when powering off
      Bluetooth: Clean up HCI state when doing power off
      Bluetooth: Fix advertising address type when toggling connectable
      Bluetooth: Ignore IRKs with no Identity Address
      Bluetooth: Track not yet received keys in SMP
      Bluetooth: Simplify logic for checking for SMP completion
      Bluetooth: Remove unneeded "force" parameter from smp_distribute_keys()
      Bluetooth: Add tracking of advertising address type
      Bluetooth: Add hci_copy_identity_address convenience function
      Bluetooth: Fix disconnecting connections in non-connected states
      Bluetooth: Add timer to force power off
      Bluetooth: Fix clearing SMP keys if pairing fails
      Bluetooth: Add protections for updating local random address
      Bluetooth: Fix updating connection state to BT_CONNECT too early
      Bluetooth: Track LE initiator and responder address information
      Bluetooth: Use hdev->init/resp_addr values for smp_c1 function
      Bluetooth: Add defines for LE initiator filter policy
      Bluetooth: Add timeout for LE connection attempts
      Bluetooth: Re-encrypt link after receiving an LTK
      Bluetooth: Delay LTK encryption to let remote receive all keys
      Bluetooth: Fix trying to disable scanning twice
      Bluetooth: Remove unnecessary stop_scan_complete function

Lukasz Rymanowski (1):
      Bluetooth: Fix response on confirm_name

Marcel Holtmann (12):
      Bluetooth: Fix issue with missing management event opcode
      Bluetooth: Expose current identity information in debugfs
      Bluetooth: Use unresolvable private address for active scanning
      Bluetooth: Use privacy mode for non-connectable advertising
      Bluetooth: Store current RPA and update it if needed
      Bluetooth: Export current local RPA with identity information
      Bluetooth: Make hci_blacklist_clear function static
      Bluetooth: Add definitions for LE white list HCI commands
      Bluetooth: Clear all LE white list entries when powering controller
      Bluetooth: Add support for storing LE white list entries
      Bluetooth: Track LE white list modification via HCI commands
      Bluetooth: Use __le64 type for LE random numbers

 include/net/bluetooth/hci.h      |  27 +-
 include/net/bluetooth/hci_core.h |  78 ++++-
 include/net/bluetooth/mgmt.h     |  10 +-
 net/bluetooth/hci_conn.c         | 116 ++++----
 net/bluetooth/hci_core.c         | 679 ++++++++++++++++++++++++++++++++++++++++---
 net/bluetooth/hci_event.c        | 274 ++++++++++++++++-
 net/bluetooth/l2cap_core.c       |  37 ++-
 net/bluetooth/mgmt.c             | 425 ++++++++++++++++++++++-----
 net/bluetooth/smp.c              | 180 +++++++++---
 net/bluetooth/smp.h              |  11 +-
 10 files changed, 1585 insertions(+), 252 deletions(-)


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTEOWrAAoJEPs3PUX4s20o/ZkP/1GI1GZhhGTKcp+lnwd2Z2t1
0LzZy5+N7mJx/TPCp2R6svyypSKGLOkwsDOHgDfOePYxbH+YgEH0FaLe22gM3dhX
H4FsGXhNzJQtpP/rvW/Pzzx428hYC9jC8am2eqKTm4LqpdrxzBtic7/5ymf2g6vB
K+V6ud+Inp+t/oU7KAZOFb3H0m63/2sb4bH4XrvrjokZYIyoQDR0tZzAAqfQIEuu
wQkvl0gEDvM7H8152MmbuGv9FIGP+SK/0wO/ZUUiiPtfrZT24GZgLGf1Jzag41dC
BeQrvNbpXSOSWFXbYqj2Tc4aVRx2HpEaiOkHWq7uutaN3I0Iygo13aH/OjbCllXK
xzlPXHT6N83MRAxQ9mo3ZbfaNCn1awBB4kif/BJKf4x8/00wuK/HlnyyC5Fq8Xol
E1Ivu3UFPYiSfXjFkOWgRdSh3by1bZfGcq89xa9kFPIvO1inB3HNfRrhDf7z3usO
Ke+1eYMRG6BUOKTUspYJob3omLbmJBCWmJLOCH6QOgAhiJQq32RiIvZMNkVXKG5x
84fdA14UXz5IiSNQUOGOq+WReR6Qw+5BGks+X99wWrBX8yXjrtRzcT9Tggv99FYg
FhBkLVNMQkL8jDV2PugnVquj5AbnGPZ+7t6yM+jy6buejDBBIVbdDjSjXeqOvSIj
fA2/ImQWpzVfIDxCulSh
=2srC
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
