Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3JUWhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:37:46 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:59341 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3JUWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:37:44 -0400
Date: Mon, 21 Oct 2013 20:37:36 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-10-21
Message-ID: <20131021223736.GA2043@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

One more big pull request for 3.13. These are the patches we queued during
last week. Here you will find a lot of improvements to the HCI and L2CAP and
MGMT layers with the main ones being a better debugfs support and end of work
of splitting L2CAP into Core and Socket parts.

Please pull!

	Gustavo

---
The following changes since commit 4b836f393bd8ed111857a6ee1865e44627266ec6:

  Bluetooth: Read current IAC LAP on controller setup (2013-10-14 19:31:18 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream

for you to fetch changes up to d78a32a8fcf775111ccc9ba611a08ca5c29784b6:

  Bluetooth: Remove sk member from struct l2cap_chan (2013-10-21 13:50:56 -0700)

----------------------------------------------------------------
Gustavo Padovan (14):
      Bluetooth: Extend state_change() call to report errors too
      Bluetooth: Add l2cap_state_change_and_error()
      Bluetooth: Access sk_sndtimeo indirectly in l2cap_core.c
      Bluetooth: Add chan->ops->set_shutdown()
      Bluetooth: Move l2cap_wait_ack() to l2cap_sock.c
      Bluetooth: use l2cap_chan_ready() instead of duplicate code
      Bluetooth: Remove not used struct sock
      Bluetooth: Do not access chan->sk directly
      Bluetooth: Hold socket in defer callback in L2CAP socket
      Bluetooth: Remove socket lock from l2cap_state_change()
      Bluetooth: Remove parent socket usage from l2cap_core.c
      Bluetooth: Add L2CAP channel to skb private data
      Bluetooth: Use bt_cb(skb)->chan to send raw data back
      Bluetooth: Remove sk member from struct l2cap_chan

Johan Hedberg (20):
      Bluetooth: Fix L2CAP "Command Reject: Invalid CID" response
      Bluetooth: Remove unused command reject mapping for EMSGSIZE
      Bluetooth: Remove useless l2cap_err_to_reason function
      Bluetooth: Ignore A2MP data on non-BR/EDR links
      Bluetooth: Ignore SMP data on non-LE links
      Bluetooth: Fix updating the right variable in update_scan_rsp_data()
      Bluetooth: Reintroduce socket restrictions for LE sockets
      Bluetooth: Convert auto accept timer to use delayed work
      Bluetooth: Convert idle timer to use delayed work
      Bluetooth: Fix ATT socket backwards compatibility with user space
      Bluetooth: Check for flag instead of features in update_scan_rsp_data()
      Bluetooth: Check for flag instead of features in update_adv_data()
      Bluetooth: Add missing check for BREDR_ENABLED flag in update_class()
      Bluetooth: Refactor set_connectable settings update to separate function
      Bluetooth: Fix updating settings when there are no HCI commands to send
      Bluetooth: Move mgmt_pending_find to avoid forward declarations
      Bluetooth: Fix sending write_scan_enable when BR/EDR is disabled
      Bluetooth: Move HCI_LIMITED_DISCOVERABLE changes to a general place
      Bluetooth: Update Set Discoverable to support LE
      Bluetooth: Fix enabling fast connectable on LE-only controllers

Marcel Holtmann (71):
      Bluetooth: Fix minor coding style issue in set_connectable()
      Bluetooth: Use hci_request for discoverable timeout handling
      Bluetooth: Update advertising data based on management commands
      Bluetooth: Introduce flag for limited discoverable mode
      Bluetooth: Make mgmt_discoverable() return void
      Bluetooth: Make mgmt_connectable() return void
      Bluetooth: Make mgmt_write_scan_failed() return void
      Bluetooth: Update class of device after changing discoverable mode
      Bluetooth: Move arming of discoverable timeout to complete handler
      Bluetooth: Simplify the code for re-arming discoverable timeout
      Bluetooth: Add HCI command structure for writing current IAC LAP
      Bluetooth: Add support for entering limited discoverable mode
      Bluetooth: Make mgmt_new_link_key() return void
      Bluetooth: Move eir_append_data() function into mgmt.c
      Bluetooth: Move eir_get_length() function into hci_event.c
      Bluetooth: Update class of device on discoverable timeout
      Bluetooth: Add l2cap_chan_no_resume stub for A2MP
      Bluetooth: Make mgmt_pin_code_request() return void
      Bluetooth: Make mgmt_pin_code_reply_complete() return void
      Bluetooth: Make mgmt_pin_code_neg_reply_complete() return void
      Bluetooth: Make mgmt_auth_failed() return void
      Bluetooth: Make mgmt_auth_enable_complete() return void
      Bluetooth: Make mgmt_ssp_enable_complete() return void
      Bluetooth: Make mgmt_set_class_of_dev_complete() return void
      Bluetooth: Make mgmt_set_local_name_complete() return void
      Bluetooth: Make mgmt_read_local_oob_data_reply_complete() return void
      Bluetooth: Make mgmt_new_ltk() return void
      Bluetooth: Rename create_ad into create_adv_data
      Bluetooth: Store scan response data in HCI device
      Bluetooth: Set the scan response data when needed
      Bluetooth: Store device name in scan response data
      Bluetooth: Rename update_ad into update_adv_data
      Bluetooth: Remove duplicate definitions for advertising event types
      Bluetooth: Remove enable_hs declaration
      Bluetooth: Socket address parameter for CID is in little endian
      Bluetooth: Expose inquiry_cache debugfs only on BR/EDR controllers
      Bluetooth: Expose auto_accept_delay debugfs only when SSP is supported
      Bluetooth: Expose static address value for LE capable controllers
      Bluetooth: Expose current voice setting in debugfs
      Bluetooth: Add address type to device blacklist table
      Bluetooth: Move blacklist debugfs entry creation into hci_core.c
      Bluetooth: Move uuids debugfs entry creation into hci_core.c
      Bluetooth: Use IS_ERR_OR_NULL for checking bt_debugfs
      Bluetooth: Create HCI device debugfs directory in hci_register_dev
      Bluetooth: Create root debugfs directory during module init
      Bluetooth: Move device_add handling into hci_register_dev
      Bluetooth: Include address type in blacklist debugfs data
      Bluetooth: Move idle_timeout and sniff_{min,max}_interval to hci_core.c
      Bluetooth: Use BDADDR_BREDR type for old blacklist ioctl interface
      Bluetooth: Use hcon directly instead of conn->hcon where possible
      Bluetooth: Block ATT connection on LE when device is blocked
      Bluetooth: Move HCI device features into hci_core.c
      Bluetooth: Add workaround for buggy max_page features page value
      Bluetooth: Remove debug entry for connection features
      Bluetooth: Move manufacturer, hci_ver and hci_rev into hci_core.c
      Bluetooth: Store local version information only during setup phase
      Bluetooth: Move export of class of device information into hci_core.c
      Bluetooth: Expose current list of link keys via debugfs
      Bluetooth: Remove bus attribute in favor of hierarchy
      Bluetooth: Expose white list size information in debugfs
      Bluetooth: Expose current list of long term keys via debugfs
      Bluetooth: Select the own address type during initial setup phase
      Bluetooth: Expose debugfs entry read/write own address type
      Bluetooth: Expose setting if debug keys are used or not
      Bluetooth: Add LE features to debugfs if available
      Bluetooth: Remove interval parameter from HCI connection
      Bluetooth: Add support for setting SSP debug mode
      Bluetooth: Expose debugfs settings for LE connection interval
      Bluetooth: Add support for setting DUT mode
      Bluetooth: Fix UUID values in debugfs file
      Bluetooth: Fix minor coding style issue in hci_core.c

 include/net/bluetooth/bluetooth.h |   1 +
 include/net/bluetooth/hci.h       |  35 ++-
 include/net/bluetooth/hci_core.h  |  89 +++----
 include/net/bluetooth/l2cap.h     |  20 +-
 net/bluetooth/a2mp.c              |   9 +-
 net/bluetooth/af_bluetooth.c      |   9 +-
 net/bluetooth/hci_conn.c          |  48 ++--
 net/bluetooth/hci_core.c          | 803 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 net/bluetooth/hci_event.c         |  59 +++--
 net/bluetooth/hci_sock.c          |   4 +-
 net/bluetooth/hci_sysfs.c         | 373 ---------------------------
 net/bluetooth/l2cap_core.c        | 227 ++++++----------
 net/bluetooth/l2cap_sock.c        | 120 ++++++++-
 net/bluetooth/mgmt.c              | 637 ++++++++++++++++++++++++++++++++-------------
 net/bluetooth/rfcomm/core.c       |  14 +-
 net/bluetooth/rfcomm/sock.c       |  14 +-
 net/bluetooth/sco.c               |  13 +-
 net/bluetooth/smp.c               |   4 +-
 18 files changed, 1506 insertions(+), 973 deletions(-)


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSZaywAAoJEPs3PUX4s20oq1EP/jo1vl+/4CAZgCFgmJBh0fbq
whF5PkB8b8ceNFjGHcOQD2gdx8ulU22l1NPsTlswVLoEu4Dz7OzlcoVNBPpfw/cM
FSMSOUaxO/5FObT5EubeG561z+EzMiQtbyQol/Cm4gvICEmACMQHK6+Nyg0JIqDN
TVlNiR6nwlI4/DeAtiN/u10+AfmyQRFa8TCncSZxIbaQMCV7/0VSKsmbpXA7OGkd
PYfoJXVgYDFRDFI/WKs3UFuJf6jTKCYbkeRQXQ6LuAv+yQ8FjqFjYc9Bt7nzOtdK
hVxuuFBXI24dmBqlY3/N83aJRPpk9kVoOf6lngOxUFqAzIGc6ObsG4sKE/ovqt7O
6Er32l+ZbrbbGmNi8vWX2jdkNrfEp8nvbDazov3rhaMNGx9fTq4edDyz7DX/WWCi
jTS8jrWSDgoNIn+qmnJu2pAftzT7CmKhwIj9JO2ahpHjfw0T1BZUpImv9jeLAm0k
PqpXDir7ogl/S/V2Xu6GiJVNgjZbX5KR8NsDt8FLoa6veljp0s8Igyqrb5jsM1EJ
Fr5HEOk0AuUuHo8bworKSvp2aTN6tk1JDwXnTGCvXE2/AsmLYtsMpWZ7VpB8O6NE
ehUQICgg6R02/10ziyI9t2Q/qgMOhxd5fGddWmzhywPWr1xQahHDe23jxuS49rcK
BcwYpVkcAsUutacz0sg+
=5e6q
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
