Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3JCRpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:45:32 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:45255 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3JCRpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:45:30 -0400
Date: Thu, 3 Oct 2013 14:45:24 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2013-10-03
Message-ID: <20131003174524.GA22728@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

A series of patches for 3.12. The big work here is from Marcel and Johan. They
did a lot of work in the L2CAP, HCI and MGMT layers. The most important ones
are the addition of a new MGMT command to enable/disable LE advertisement and
the introduction of the HCI user channel to allow applications to get directly
and exclusive access to Bluetooth devices.

Please pull, or let me know of any issues. Thanks!

	Gustavo

--
The following changes since commit f4e1a4d3ecbb9e42bdf8e7869ee8a4ebfa27fb20:

  rt2800: change initialization sequence to fix system freeze (2013-09-09 14:44:34 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream

for you to fetch changes up to 4f3e219d95a3c31b916dcd5e2631c4e440736f79:

  Bluetooth: Only one command per L2CAP LE signalling is supported (2013-10-03 16:09:59 +0300)

----------------------------------------------------------------
Amitkumar Karwar (4):
      Bluetooth: btmrvl: add btmrvl_send_sync_cmd() function
      Bluetooth: btmrvl: get rid of struct btmrvl_cmd
      Bluetooth: btmrvl: add setup handler
      Bluetooth: btmrvl: add calibration data download support

Andre Guedes (2):
      Bluetooth: Fix security level for peripheral role
      Bluetooth: Fix encryption key size for peripheral role

DoHyun Pyun (8):
      Bluetooth: Add the definition and structure for Set Reserved LT_ADDR
      Bluetooth: Add the definition and structure for Delete Reserved LT_ADDR
      Bluetooth: Add the definition and structure for Set CSB Data
      Bluetooth: Add the structure for Write Sync Train Parameters
      Bluetooth: Add the definition and structure for Set CSB
      Bluetooth: Add the definition for Start Synchronization Train
      Bluetooth: Add the definition and stcuture for Sync Train Complete
      Bluetooth: Add the definition for Slave Page Response Timeout

Gianluca Anzolin (1):
      Bluetooth: don't release the port in rfcomm_dev_state_change()

Gustavo Padovan (1):
      Merge git://git.kernel.org/.../bluetooth/bluetooth

Johan Hedberg (25):
      Bluetooth: Introduce a new HCI_RFKILLED flag
      Bluetooth: Fix rfkill functionality during the HCI setup stage
      Bluetooth: Remove unused event mask struct
      Bluetooth: Fix double error response for l2cap_create_chan_req
      Bluetooth: Fix L2CAP error return used for failed channel lookups
      Bluetooth: Fix L2CAP Disconnect response for unknown CID
      Bluetooth: Fix L2CAP command reject reason
      Bluetooth: Fix sending responses to identified L2CAP response packets
      Bluetooth: Fix responding to invalid L2CAP signaling commands
      Bluetooth: Fix waiting for clearing of BT_SK_SUSPEND flag
      Bluetooth: Add synchronization train parameters reading support
      Bluetooth: Add event mask page 2 setting support
      Bluetooth: Add clarifying comment to bt_sock_wait_state()
      Bluetooth: Clean up socket locking in l2cap_sock_recvmsg
      Bluetooth: Fix busy return for mgmt_set_powered in some cases
      Bluetooth: Move mgmt response convenience functions to a better location
      Bluetooth: Use async request for LE enable/disable
      Bluetooth: Add new mgmt setting for LE advertising
      Bluetooth: Add new mgmt_set_advertising command
      Bluetooth: Refactor hci_dev_open to a separate hci_dev_do_open function
      Bluetooth: Fix workqueue synchronization in hci_dev_open
      Bluetooth: Introduce a new HCI_BREDR_ENABLED flag
      Bluetooth: Add a new mgmt_set_bredr command
      Bluetooth: Fix REJECTED vs NOT_SUPPORTED mgmt responses
      Bluetooth: Fix advertising data flags with disabled BR/EDR

Ken O'Brien (1):
      Bluetooth: btusb: Add support for Belkin F8065bf

Marcel Holtmann (35):
      Bluetooth: Refactor raw socket filter into more readable code
      Bluetooth: Fix handling of getpeername() for HCI sockets
      Bluetooth: Fix handling of getsockname() for HCI sockets
      Bluetooth: Report error for HCI reset ioctl when device is down
      Bluetooth: Fix error handling for HCI socket options
      Bluetooth: Restrict ioctls to HCI raw channel sockets
      Bluetooth: Introduce user channel flag for HCI devices
      Bluetooth: Introduce new HCI socket channel for user operation
      Bluetooth: Use devname:vhci module alias for virtual HCI driver
      Bluetooth: Add support creating virtual AMP controllers
      Bluetooth: Disable upper layer connections when user channel is active
      Bluetooth: Use GFP_KERNEL when cloning SKB in a workqueue
      Bluetooth: Only schedule raw queue when user channel is active
      Bluetooth: Use only 2 bits for controller type information
      Bluetooth: Replace BDADDR_LOCAL with BDADDR_NONE
      Bluetooth: Provide high speed configuration option
      Bluetooth: Send new settings event when changing high speed option
      Bluetooth: Require CAP_NET_ADMIN for HCI User Channel operation
      Bluetooth: Enable -D__CHECK_ENDIAN__ for sparse by default
      Bluetooth: Restrict disabling of HS when controller is powered off
      Bluetooth: Add management command for setting static address
      Bluetooth: Increment management interface revision
      Bluetooth: Fix memory leak with L2CAP signal channels
      Bluetooth: Restrict SSP setting changes to BR/EDR enabled controllers
      Bluetooth: Allow setting static address even if LE is disabled
      Bluetooth: Restrict loading of link keys to BR/EDR capable controllers
      Bluetooth: Restrict loading of long term keys to LE capable controllers
      Bluetooth: Allow changing device class when BR/EDR is disabled
      Bluetooth: Fix switch statement order for L2CAP fixed channels
      Bluetooth: Don't copy L2CAP LE signalling to raw sockets
      Bluetooth: SMP packets are only valid on LE connections
      Bluetooth: L2CAP connectionless channels are only valid for BR/EDR
      Bluetooth: Drop packets on ATT fixed channel on BR/EDR
      Bluetooth: Check minimum length of SMP packets
      Bluetooth: Only one command per L2CAP LE signalling is supported

Peng Chen (1):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Peter Senna Tschudin (1):
      Bluetooth: Fix assignment of 0/1 to bool variables

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Syam Sidhardhan (1):
      Bluetooth: Fix ACL alive for long in case of non pariable devices

 drivers/bluetooth/Makefile        |   2 +
 drivers/bluetooth/ath3k.c         |   2 +
 drivers/bluetooth/btmrvl_drv.h    |  12 +-
 drivers/bluetooth/btmrvl_main.c   | 269 +++++++++++++++---------
 drivers/bluetooth/btmrvl_sdio.c   |  15 +-
 drivers/bluetooth/btmrvl_sdio.h   |   2 +
 drivers/bluetooth/btusb.c         |   5 +
 drivers/bluetooth/hci_vhci.c      | 170 ++++++++++-----
 include/net/bluetooth/bluetooth.h |   5 +-
 include/net/bluetooth/hci.h       |  82 +++++++-
 include/net/bluetooth/hci_core.h  |   2 +-
 include/net/bluetooth/l2cap.h     |   1 +
 include/net/bluetooth/mgmt.h      |  11 +
 net/bluetooth/Makefile            |   2 +
 net/bluetooth/af_bluetooth.c      |  41 ++++
 net/bluetooth/hci_conn.c          |   4 +
 net/bluetooth/hci_core.c          | 213 +++++++++++++++----
 net/bluetooth/hci_event.c         |  23 ++-
 net/bluetooth/hci_sock.c          | 204 ++++++++++++++----
 net/bluetooth/l2cap_core.c        | 169 +++++++++------
 net/bluetooth/l2cap_sock.c        |  20 +-
 net/bluetooth/mgmt.c              | 562 ++++++++++++++++++++++++++++++++++++++++----------
 net/bluetooth/rfcomm/sock.c       |   7 +-
 net/bluetooth/rfcomm/tty.c        |  35 +---
 net/bluetooth/smp.c               |  15 +-
 25 files changed, 1390 insertions(+), 483 deletions(-)


