Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaLEQmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:42:05 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63749 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaLEQmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:42:00 -0500
Date: Fri, 5 Dec 2014 18:41:49 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-12-05
Message-ID: <20141205164149.GA1087@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20141205125318.GA24487@t440s.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20141205125318.GA24487@t440s.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Marcel had a couple more patches that were supposed to be in the pull
request, so here's a new one that supersedes the one I made earlier
today.

In addition to the previous one this contains two more cleanups to
mac802154 as well as support for some new HCI features from the
Bluetooth 4.2 specification.

=46rom the original request:

"Here's what should be the last bluetooth-next pull request for 3.19.
It's rather large but the majority of it is the Low Energy Secure
Connections feature that's part of the Bluetooth 4.2 specification. The
specification went public only this week so we couldn't publish the
corresponding code before that. The code itself can nevertheless be
considered fairly mature as it's been in development for over 6 months
and gone through several interoperability test events.

Besides LE SC the pull request contains an important fix for command
complete events for mgmt sockets which also fixes some leaks of hci_conn
objects when powering off or unplugging Bluetooth adapters.

A smaller feature that's part of the pull request is service discovery
support. This is like normal device discovery except that devices not
matching specific UUIDs or strong enough RSSI are filtered out.

Other changes that the pull request contains are firmware dump support
to the btmrvl driver, firmware download support for Broadcom BCM20702A0
variants, as well as some coding style cleanups in 6lowpan &
ieee802154/mac802154 code."

Please let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit f6af675ef5489c69fc3d4faf8c6f477df3cbf8b9:

  Bluetooth: Automatically flushable packets aren't allowed on LE links (20=
14-11-27 12:12:27 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 5a34bd5f5d8119def4feb1d2b4e3906b71059416:

  Bluetooth: Enable events for P-256 Public Key and DHKey commands (2014-12=
-05 18:17:49 +0200)

----------------------------------------------------------------
Amitkumar Karwar (1):
      Bluetooth: btmrvl: remove extra newline character

Heinrich Siebmanns (1):
      Bluetooth: Add support for Broadcom BCM20702A0 variants firmware down=
load

Jakub Pawlowski (4):
      Bluetooth: Add definitions for MGMT_OP_START_SERVICE_DISCOVERY
      Bluetooth: Add extra discovery fields for storing filter information
      Bluetooth: Add logic for UUID filter handling
      Bluetooth: Add support for Start Service Discovery command

Johan Hedberg (62):
      Bluetooth: Track both local and remote L2CAP fixed channel mask
      Bluetooth: Simplify Link Key Notification event handling logic
      Bluetooth: Add basic SMP defines for LE Secure Connections
      Bluetooth: Make auth_req mask dependent on SC enabled or not
      Bluetooth: Add SMP flag for SC and set it when necessary.
      Bluetooth: Update SMP security level to/from auth_req for SC
      Bluetooth: Add mgmt support for LE Secure Connections LTK types
      Bluetooth: Set the correct security level for SC LTKs
      Bluetooth: Use custom macro for testing BR/EDR SC enabled
      Bluetooth: Add mgmt_set_secure_conn support for any LE adapter
      Bluetooth: Update LTK lookup to correctly deal with SC LTKs
      Bluetooth: Remove unused hci_find_ltk function
      Bluetooth: Rename hci_find_ltk_by_addr to hci_find_ltk
      Bluetooth: Set link key generation bit if necessary for LE SC
      Bluetooth: Add basic support for AES-CMAC
      Bluetooth: Add ECC library for LE Secure Connections
      Bluetooth: Add basic support for sending our LE SC public key
      Bluetooth: Add handler function for receiving LE SC public key
      Bluetooth: Add support for sending LE SC Confirm value
      Bluetooth: Add LE SC support for responding to Pairing Confirm PDU
      Bluetooth: Add support for LE SC numeric comparison
      Bluetooth: Add support for handling LE SC user response
      Bluetooth: Add support for LE SC DHKey check PDU
      Bluetooth: Add support for LE SC key generation
      Bluetooth: Track authentication method in SMP context
      Bluetooth: Add selection of the SC authentication method
      Bluetooth: Detect SMP SC debug keys
      Bluetooth: Add check for accidentally generating a debug key
      Bluetooth: Set correct LTK type and authentication for SC
      Bluetooth: Add support for SC just-works pairing
      Bluetooth: Fix BR/EDR Link Key type when derived through LE SC
      Bluetooth: Add passkey entry support for LE SC
      Bluetooth: Fix DHKey Check sending order for slave role
      Bluetooth: Add dummy handler for LE SC keypress notification
      Bluetooth: Use debug keys for SMP when HCI_USE_DEBUG_KEYS is set
      Bluetooth: Add hci_conn flag for new link key generation
      Bluetooth: Add debugfs switch for forcing SMP over BR/EDR
      Bluetooth: Add skeleton for BR/EDR SMP channel
      Bluetooth: Add full SMP BR/EDR support
      Bluetooth: Add SC-only mode support for SMP
      Bluetooth: Unify remote OOB data functions
      Bluetooth: Store address type with OOB data
      Bluetooth: Add support for adding remote OOB data for LE
      Bluetooth: Set SMP OOB flag if OOB data is available
      Bluetooth: Add basic LE SC OOB support for remote OOB data
      Bluetooth: Introduce SMP_DBG macro for low-level debuging
      Bluetooth: Fix missing const declarations in SMP functions
      Bluetooth: Organize SMP crypto functions to logical sections
      Bluetooth: Fix SMP debug key handling
      Bluetooth: Fix minor coding style issue in smp.c
      Bluetooth: Fix false-positive "uninitialized" compiler warning
      Bluetooth: Add callback to create proper cmd_complete events
      Bluetooth: Store parameter length with pending mgmt commands
      Bluetooth: Convert Disconnect mgmt command to use cmd_complete callba=
ck
      Bluetooth: Use cmd_complete callback for authentication mgmt commands
      Bluetooth: Convert Pair Device to use cmd_complete callback
      Bluetooth: Convert Unpair Device to use cmd_complete callback
      Bluetooth: Convert discovery commands to use cmd_complete callback
      Bluetooth: Convert Get Clock Info to use cmd_complete callback
      Bluetooth: Fix initializing hci_conn RSSI to invalid value
      Bluetooth: Fix Get Conn Info to use cmd_complete callback
      Bluetooth: Remove redundant reverse_base_uuid variable

Marcel Holtmann (19):
      Bluetooth: Increase minor version of core module
      Bluetooth: Increment management interface revision
      Bluetooth: Simplify the error handling of Start Discovery command
      Bluetooth: Use {start,stop}_discovery_complete handler for cmd_comple=
te
      Bluetooth: Split triggering of discovery commands into separate funct=
ion
      Bluetooth: Add HCI_RSSI_INVALID for unknown RSSI value
      Bluetooth: Filter device found events based on RSSI threshold
      Bluetooth: Add framework for device found filtering based on UUID
      Bluetooth: Add helper function for clearing the discovery filter
      Bluetooth: Fix memory leaks from discovery filter UUID list
      Bluetooth: Clear discovery filter before starting background scan
      Bluetooth: Fix discovery filter when no RSSI is available
      Bluetooth: Report invalid RSSI for service discovery and background s=
can
      Bluetooth: Move LE advertising report defines to the right location
      Bluetooth: Add definitions for LE Direct Advertising Report event
      Bluetooth: Enabled LE Direct Advertising Report event if supported
      Bluetooth: Add support for handling LE Direct Advertising Report even=
ts
      Bluetooth: Add support for enabling Extended Scanner Filter Policies
      Bluetooth: Enable events for P-256 Public Key and DHKey commands

Stefan Schmidt (5):
      net/6lowpan: Remove FSF address from GPL statement.
      net/ieee802154: Make sure alignment matches parenthesis..
      net/ieee802154: Remove and add extra blank lines as needed.
      net/mac802154: Remove extra blank lines.
      net/mac802154: No need for an extra space when casting

Varka Bhadram (2):
      mac802154: use goto label on failure
      cc2520: adds terminating newline

Xinming Hu (1):
      Bluetooth: btmrvl add firmware dump support

 drivers/bluetooth/Kconfig          |    1 +
 drivers/bluetooth/btmrvl_debugfs.c |   31 +
 drivers/bluetooth/btmrvl_drv.h     |   20 +
 drivers/bluetooth/btmrvl_main.c    |   21 +-
 drivers/bluetooth/btmrvl_sdio.c    |  304 ++++++-
 drivers/bluetooth/btmrvl_sdio.h    |    5 +
 drivers/bluetooth/btusb.c          |    3 +-
 drivers/net/ieee802154/cc2520.c    |    2 +-
 include/net/bluetooth/hci.h        |   41 +-
 include/net/bluetooth/hci_core.h   |   38 +-
 include/net/bluetooth/l2cap.h      |    6 +-
 include/net/bluetooth/mgmt.h       |   12 +
 net/6lowpan/iphc.c                 |    3 -
 net/bluetooth/Kconfig              |    1 +
 net/bluetooth/Makefile             |    2 +-
 net/bluetooth/af_bluetooth.c       |    2 +-
 net/bluetooth/ecc.c                |  816 ++++++++++++++++++
 net/bluetooth/ecc.h                |   54 ++
 net/bluetooth/hci_conn.c           |    1 +
 net/bluetooth/hci_core.c           |  200 +++--
 net/bluetooth/hci_event.c          |  110 ++-
 net/bluetooth/l2cap_core.c         |   41 +-
 net/bluetooth/mgmt.c               |  869 ++++++++++++--------
 net/bluetooth/smp.c                | 1543 ++++++++++++++++++++++++++++++++=
---
 net/bluetooth/smp.h                |   51 +-
 net/ieee802154/6lowpan_rtnl.c      |    1 -
 net/ieee802154/af_ieee802154.c     |    4 +-
 net/ieee802154/dgram.c             |    1 -
 net/ieee802154/netlink.c           |    3 +-
 net/ieee802154/nl-mac.c            |   14 -
 net/ieee802154/nl-phy.c            |    1 -
 net/ieee802154/raw.c               |    1 -
 net/mac802154/llsec.c              |   19 +-
 net/mac802154/mib.c                |    6 -
 net/mac802154/rx.c                 |    3 +-
 35 files changed, 3576 insertions(+), 654 deletions(-)
 create mode 100644 net/bluetooth/ecc.c
 create mode 100644 net/bluetooth/ecc.h


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgeBNAAoJECQj9vv5qNQSm+kP/1R1Mm3M6x40bQKFP95VPPsM
mWRKGv6YP74xXWadJZFUbMigmY5KDChVp+XpXaSRNR53gNDJ7uPc9IQ040J/GpdN
GK5kqwNzImV+ppb6FFd3UkGElJgZVk9AjM2t6x6A/pQJIUfaAOrsqO0g7cjtWT4E
EnkE//ZLzFkTluXQ8/vmn7QyD4W4QXY7g82KpKQmo8kfFdcZcCB4OeNxWr1V8r1G
LpN4leCiplELtQRIU1Bg3IojX2L75XNb4b+nYsfx0C6ogm//FAFtQ2qe06KyBKI6
WBCjvJgbabTR2D4lziuQhNwX0KePS8atvMwtGj9Tg/ldkcIZMUAqc1VwVRgzTsBp
Il/mDfHU3pfJ87fLE5AXQioFqm4MXplsF0vhK6U1vS3adxID7+QwjsBN55xlRjvM
75zzEu+runOKun5Rb/BZmShyVhowCBEYe6Md7eu3QzBjvgS2gROfFWO9PUYHtjJ3
UnU8UC9UxTAjzRrlv05HSfjU8NpDBH96/GKj7VX004fxOAFXH8I9muo72PJr1PL4
mD0jSeHfYbg3X2BFHEKfc5Ktx3kjZeXupMmlbv7PaTd7bkOtGZmwftcRG3u5q7ki
qZLfrQNPF5M3hmiugLSFhy0SmWBmAGAAcXAVn0RJlfUoOz9jH9m2P29yd5n97h2L
35GjwOvrHXXICZb0lJ19
=0J+Z
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
