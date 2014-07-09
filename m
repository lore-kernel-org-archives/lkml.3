Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaGIOuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:50:07 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53368 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGIOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:50:03 -0400
Date: Wed, 9 Jul 2014 11:49:57 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-07-09
Message-ID: <20140709144957.GA1932@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

A lot of patches to 3.17. The bulk of changes here are for LE support.
The 6loWPAN over Bluetooth now has it own module, we also have support for
background auto-connection and passive scanning, Bluetooth device address
provisioning, support for reading Bluetooth clock values and LE connection
parameters plus many many fixes.

Also you will note that we have some wireless.git patches in here, we had to
pull bluetooth.git into bluetooth-next. You may want to pull from wireless.=
git
first.

Please pull! or let me know of any issues. Thanks!

	Gustavo

---
The following changes since commit 15be8e89cdd999124a2307ffd6dacb895c3b802e:

  b43: add more bcma cores (2014-07-01 14:29:39 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to 6fea7ad1d338dba592d65423427a997f1b7ff485:

  Bluetooth: Don't send ERTM configuration option when disabled (2014-07-09=
 13:53:36 +0300)

----------------------------------------------------------------
Adam Lee (1):
      Bluetooth: ath3k: reduce pipe setting times in ath3k_load_fwfile()

Anantha Krishnan (1):
      Bluetooth: Add support for Acer [13D3:3432]

Andre Guedes (6):
      Bluetooth: Use macro instead of hard-coded value
      Bluetooth: Connection parameters check helper
      Bluetooth: Connection Parameter Update Procedure
      Bluetooth: Move LE event mask setting into init3 phase
      Bluetooth: Enable new LE meta event
      Bluetooth: Introduce "New Connection Parameter" Event

Bing Zhao (1):
      Bluetooth: btmrvl: indicate pscan scheduling instant in a debug event

Chin-Ran Lo (2):
      mwifiex: fix tx_info/rx_info overlap with PCIe dma_mapping
      Bluetooth: btmrvl: wait for HOST_SLEEP_ENABLE event in suspend

Fabian Frederick (1):
      Bluetooth: constify seq_operations

Johan Hedberg (113):
      Bluetooth: Fix incorrectly overriding conn->src_type
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Add clarifying comment for conn->auth_type
      Bluetooth: Fix setting correct authentication information for SMP STK
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Refactor discovery stopping into its own function
      Bluetooth: Reuse hci_stop_discovery function when cleaning up HCI sta=
te
      Bluetooth: Fix locking of hdev when calling into SMP code
      Bluetooth: Fix overriding higher security level in SMP
      Bluetooth: Refactor authentication method lookup into its own function
      Bluetooth: Fix rejecting pairing in case of insufficient capabilities
      Bluetooth: Fix missing NULL check for smp_chan_create() return value
      Bluetooth: Remove unnecessary SMP STK define
      Bluetooth: Remove HCI prefix from SMP LTK defines
      Bluetooth: Remove unused LTK authentication defines
      Bluetooth: Convert SMP flags into an enum
      Bluetooth: Add flexible buffer byte order swapping function
      Bluetooth: Fix validating IO capability values in mgmt commands
      Bluetooth: Fix checking for master LTKs
      Bluetooth: Update hci_add_link_key() to return pointer to key
      Bluetooth: Move mgmt event sending out from hci_add_link_key()
      Bluetooth: Rename HCI_DEBUG_KEYS to HCI_KEEP_DEBUG_KEYS
      Bluetooth: Don't store debug keys if flag for them is not set
      Bluetooth: Convert hcon->flush_key to a proper flag
      Bluetooth: Fix ignoring debug keys in mgmt_load_link_keys
      Bluetooth: Add a new HCI_USE_DEBUG_KEYS flag
      Bluetooth: Add support for mode 0x02 for mgmt_set_debug_keys
      Bluetooth: Convert hci_conn->link_mode into flags
      Bluetooth: Fix missing hdev locking in smp_cmd_ident_addr_info
      Bluetooth: Add dedicated AES instance for each SMP context
      Bluetooth: Update SMP crypto functions to take the SMP context
      Bluetooth: Remove unnecessary hci_dev_unlock for smp_user_confirm_rep=
ly
      Bluetooth: Fix missing check for SMP session in smp_user_confirm_reply
      Bluetooth: Remove unnecessary hcon->smp_conn variable
      Bluetooth: Use kzalloc instead of kmalloc for pending mgmt commands
      Bluetooth: Add tracking of local and piconet clock values
      Bluetooth: Add support for Get Clock Info mgmt command
      Bluetooth: Allow L2CAP getpeername() for BT_CONFIG state
      Bluetooth: Fix redundant encryption when receiving Security Request
      Bluetooth: Add flag to track STK encryption
      Bluetooth: Allow re-encryption with LTK when STK is in use
      Bluetooth: Fix redundant device (un)blocked events
      Bluetooth: Centralize looking up blocked devices to l2cap_recv_frame
      Bluetooth: Drop LE connections for blocked devices
      Bluetooth: Fix sparse warning with btmrvl driver
      Bluetooth: Rename hci_conn_params_clear to hci_conn_params_clear_all
      Bluetooth: Add specific connection parameter clear functions
      Bluetooth: Add new auto_conn value matching mgmt action 0x00
      Bluetooth: Remove only enabled entries with Remove Device command
      Bluetooth: Add Load Connection Parameters command
      Bluetooth: Fix missing update of conn params
      Bluetooth: Make hci_le_conn_update return the store hint
      Bluetooth: Pass store hint to mgmt_new_conn_param
      Bluetooth: Make is_identity_address a global function
      Bluetooth: Don't send connection parameters without identity address
      Bluetooth: Track number of added devices with HCI_AUTO_CONN_REPORT
      Bluetooth: Allow mgmt_device_found events for kernel-side scanning
      Bluetooth: Add support for background LE scanning
      Bluetooth: Support scanning for devices using RPA
      Bluetooth: Fix buffer overflow with variable length commands
      Bluetooth: Fix missing update of pend_le_reports
      Bluetooth: Remove redundant IRK lookup
      Bluetooth: Use hci_conn_params in pend_le_conns
      Bluetooth: Remove unnecessary checks for auto-connected devices
      Bluetooth: Add identity address check in param lookup functions
      Bluetooth: Fix missing return statement in process_adv_report
      Bluetooth: Convert pend_le_conn list to a generic action list
      Bluetooth: Convert pend_le_reports into a list
      Bluetooth: Simplify use of hci_pend_le_conns_clear()
      Bluetooth: Don't bother doing anything if auto_connect doesn't change
      Bluetooth: Simplify hci_conn_params->action list usage
      Bluetooth: Remove unused hci_pend_le_conn_del() function
      Bluetooth: Fix clearing and restarting all LE actions on power cycle
      Bluetooth: Remove unnecessary usage of hci_pend_le_conn_add
      Bluetooth: Remove unused hci_pend_le_conn_add function
      Bluetooth: Make hci_pend_le_conn_lookup more general purposed
      Bluetooth: Use hci_pend_le_action_lookup to look up report entries
      Bluetooth: Don't take actions on blocked devices when scanning
      Bluetooth: Use list_del when freeing the list entry
      Bluetooth: Restrict blocked device check in l2cap_recv_frame to LE
      Bluetooth: Fix sending Device Removed when clearing all parameters
      Bluetooth: Use lower timeout for LE auto-connections
      Bluetooth: Fix updating background scan for LE connect complete
      Bluetooth: Fix connecting devices during LE device discovery
      Bluetooth: Remove redundant IRK lookup in mgmt_device_found()
      Bluetooth: Remove unnecessary return value from check_pending_le_conn
      Bluetooth: Update discovery state earlier in hci_discovery_set_state
      Bluetooth: Don't let background scanning interfering with discovery
      Bluetooth: Enable passive scanning whenever we're connectable
      Bluetooth: Remove auth_type parameter from hci_connect_le()
      Bluetooth: Pass desired connection role to hci_connect_le()
      Bluetooth: Don't try background scanning if LE is not enabled
      Bluetooth: Add flag to track the real advertising state
      Bluetooth: Remove unnecessary mgmt_advertising function
      Bluetooth: Use real advertising state to random address update decisi=
on
      Bluetooth: Simplify usage of the enable_advertising function
      Bluetooth: Use the correct flag to decide to disable advertising
      Bluetooth: Stop advertising always before initiating a connection
      Bluetooth: Fix advertising and active scanning co-existence
      Bluetooth: Fix check for re-enabling advertising
      Bluetooth: Fix setting STOPPING state for discovery
      Bluetooth: Fix connectable and discoverable supported settings values
      Bluetooth: Fix toggling background scan when changing connectable sta=
te
      Bluetooth: Fix clearing HCI_LE_ADV for LE connections
      Bluetooth: Unify helpers for bdaddr_list manipulations
      Bluetooth: Introduce a whitelist for BR/EDR devices
      Bluetooth: Update page scan when necessary for Add/Remove Device
      Bluetooth: Fix incorrectly setting HCI_CONNECTABLE
      Bluetooth: Refactor connection request handling
      Bluetooth: Enable page scan also if there are white list entries
      Bluetooth: Add white list lookup for incoming connection requests
      Bluetooth: Fix setting HCI_CONNECTABLE from ioctl code

John W. Linville (1):
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/blu=
etooth

Jukka Rissanen (5):
      Bluetooth: Provide L2CAP ops callback for memcpy_fromiovec
      Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed o=
ne
      Bluetooth: 6LoWPAN: Create a kernel module
      Bluetooth: 6LoWPAN: Count module usage
      Bluetooth: 6LoWPAN: Remove network devices when unloading

Jukka Taimisto (1):
      Bluetooth: Fix deadlock in l2cap_conn_del()

Loic Poulain (2):
      Bluetooth: Ignore H5 non-link packets in non-active state
      Bluetooth: Remove redundant calls to h5_reset_rx

Lukasz Rymanowski (1):
      Bluetooth: Fix for ACL disconnect when pairing fails

Marcel Holtmann (82):
      Revert "Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012."
      Merge git://git.kernel.org/.../bluetooth/bluetooth
      Bluetooth: Use const for struct l2cap_ops field
      Bluetooth: Assign L2CAP socket priority when allocating SKB
      Bluetooth: Shrink size of struct l2cap_ctrl fields
      Bluetooth: Use explicit header and body length for L2CAP SKB allocati=
on
      Bluetooth: Use struct delayed_work for HCI command timeout
      Bluetooth: Use separate dbg_flags to special debugfs options
      Bluetooth: Store current LE connection parameters in hci_conn struct
      Bluetooth: Track LE connection parameter update event
      Bluetooth: Set default min/max connection interval for LE slaves
      Bluetooth: Add support LE slave connection update procedure
      Bluetooth: Remove ssp_debug_mode debugfs option
      Bluetooth: Remove reason parameter from hci_amp_disconn function
      Bluetooth: Remove unneeded hci_conn_disconnect abstraction
      Bluetooth: Send HCI_Read_Clock_Offset before disconnecting
      Bluetooth: Increment management interface revision
      Bluetooth: Restrict access for raw-only controllers
      Bluetooth: Don't use non-resolvable private address for passive scann=
ing
      Bluetooth: Move hci_pend_le_conn_* functions to different location
      Bluetooth: Clear pending connections from hci_conn_params_clear
      Bluetooth: Update background scanning from hci_conn_params_clear
      Bluetooth: Store latency and supervision timeout in connection params
      Bluetooth: Use LE connection parameters if known
      Bluetooth: Add support for Add/Remove Device management commands
      Bluetooth: Replace le_auto_conn debugfs with device_list entry
      Bluetooth: Add Device Added and Device Removed management events
      Bluetooth: Provide defaults for LE connection latency and timeout
      Bluetooth: Expose default connection latency setting via debugfs
      Bluetooth: Expose default supervision timeout setting via debugfs
      Bluetooth: Provide function to create and set connection parameters
      Bluetooth: Add default connection parameters before pairing
      Bluetooth: Start background scanning only when controller is ready
      Bluetooth: Use bool for smp_ltk_encrypt return value
      Bluetooth: Change hci_conn_params_add to return the parameter struct
      Bluetooth: Use hci_conn_params_add within hci_conn_params_set
      Bluetooth: Remove connection interval parameters from hci_conn_params=
_set
      Bluetooth: Fix merge of advertising data and scan response data
      Bluetooth: Provide flags parameter direct to mgmt_device_found
      Bluetooth: Add support for Not Connectable flag for Device Found even=
ts
      Bluetooth: Do not trigger background scanning when HCI_AUTO_OFF is set
      Bluetooth: Ensure that background scanning gets enabled on power on
      Bluetooth: Add support for hdev->set_bdaddr callback handling
      Bluetooth: Add public address configration for Broadcom USB devices
      Bluetooth: Add public address configration for Intel USB devices
      Bluetooth: Default to internal use manufacturer identifier
      Bluetooth: Check for default address of Intel USB controllers
      Bluetooth: Check for default address of Broadcom BCM20702A0 controlle=
rs
      Bluetooth: Introduce unconfigured controller state
      Bluetooth: Add support for Unconfigured Index Added events
      Bluetooth: Add support for Unconfigured Index Removed events
      Bluetooth: Add support for Read Unconfigured Index List command
      Bluetooth: Support HCI_QUIRK_RAW_DEVICE for hci_vhci driver
      Bluetooth: Add support for controller configuration info command
      Bluetooth: Fix constant for public address configuration
      Bluetooth: Document the existing device quirks
      Bluetooth: Add quirk for invalid controller address setting
      Bluetooth: Set HCI_QUIRK_INVALID_BADDR for Intel USB default address
      Bluetooth: Set HCI_QUIRK_INVALID_BADDR for BCM20702A0 default address
      Bluetooth: Allow reading configuration info when unconfigured
      Bluetooth: Add quirk for external configuration requirement
      Bluetooth: Fix quirks that are valid during setup driver callback
      Bluetooth: Support HCI_QUIRK_EXTERNAL_CONFIG for hci_vhci driver
      Bluetooth: Add support for Set External Configuration management comm=
and
      Bluetooth: Move mgmt_event helper function to different location
      Bluetooth: Add support for New Configuration Options management event
      Bluetooth: Use a more simpler style for HCI event callbacks
      Bluetooth: Run special init procedure for unconfigured controllers
      Bluetooth: Store Bluetooth address from controller setup
      Bluetooth: Run controller setup after external configuration
      Bluetooth: Add support for changing the public device address
      Bluetooth: Clear HCI_RAW flag when controller becomes configured
      Bluetooth: Add support for Intel bootloader devices
      Bluetooth: Skip unconfigured init procedure for raw-only devices
      Bluetooth: Remove module parameters for ignoring USB devices
      Bluetooth: Handle Intel USB bootloader with buggy interrupt
      Bluetooth: Ignore isochronous endpoints for Intel USB bootloader
      Bluetooth: Fix memory leaking when hdev->send returns an error
      Bluetooth: Enforce providing hdev->send driver callback
      Bluetooth: Use BTUSB_BROKEN_ISOC flag for CSR USB sniffer devices
      Bluetooth: Fix enabling Authenticated Payload Timeout Expired event
      Bluetooth: Don't send ERTM configuration option when disabled

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

Michael Braun (2):
      rt2800usb:fix efuse detection
      rt2800usb:fix hang during firmware load

Nick Pelly (1):
      Bluetooth: Fallback to SCO on error code 0x10 (Connection Accept Time=
out)

Rafa=C5=82 Mi=C5=82ecki (3):
      b43: disable 5 GHz on G-PHY
      b43: fix typo in Kconfig (make B43_BUSES_BCMA_AND_SSB the default for=
 real)
      b43: fix frequency reported on G-PHY with /new/ firmware

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Stephan Gabert (1):
      Bluetooth: Remove trailing whitespaces from Kconfig

 drivers/bluetooth/Kconfig               |   12 +-
 drivers/bluetooth/ath3k.c               |    8 +-
 drivers/bluetooth/btmrvl_drv.h          |    3 +
 drivers/bluetooth/btmrvl_main.c         |   44 +-
 drivers/bluetooth/btmrvl_sdio.c         |    5 +
 drivers/bluetooth/btmrvl_sdio.h         |    2 +
 drivers/bluetooth/btusb.c               |  188 ++++++-
 drivers/bluetooth/hci_h5.c              |    5 +-
 drivers/bluetooth/hci_vhci.c            |   34 +-
 drivers/net/wireless/b43/Kconfig        |    2 +-
 drivers/net/wireless/b43/main.c         |    1 +
 drivers/net/wireless/b43/xmit.c         |   10 +-
 drivers/net/wireless/mwifiex/pcie.c     |    4 +-
 drivers/net/wireless/mwifiex/util.h     |   43 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    7 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |   39 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |   24 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +
 drivers/net/wireless/rt2x00/rt2x00usb.h |    1 +
 include/net/bluetooth/bluetooth.h       |   18 +-
 include/net/bluetooth/hci.h             |  135 ++++-
 include/net/bluetooth/hci_core.h        |  134 +++--
 include/net/bluetooth/l2cap.h           |   36 +-
 include/net/bluetooth/mgmt.h            |   99 ++++
 net/bluetooth/6lowpan.c                 |  857 ++++++++++++++++++++++-----=
--
 net/bluetooth/6lowpan.h                 |   47 --
 net/bluetooth/Kconfig                   |    6 +-
 net/bluetooth/Makefile                  |    4 +-
 net/bluetooth/a2mp.c                    |    8 +-
 net/bluetooth/af_bluetooth.c            |    2 +-
 net/bluetooth/hci_conn.c                |  181 ++++--
 net/bluetooth/hci_core.c                |  909 ++++++++++++++++-----------=
----
 net/bluetooth/hci_event.c               |  715 +++++++++++++++++-------
 net/bluetooth/hci_sock.c                |   12 +-
 net/bluetooth/l2cap_core.c              |  152 +++---
 net/bluetooth/l2cap_sock.c              |   51 +-
 net/bluetooth/mgmt.c                    | 1330 +++++++++++++++++++++++++++=
++++++++++--------
 net/bluetooth/smp.c                     |  244 +++++----
 net/bluetooth/smp.h                     |    7 +
 40 files changed, 3883 insertions(+), 1499 deletions(-)
 delete mode 100644 net/bluetooth/6lowpan.h


--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvVaVAAoJEPs3PUX4s20o60YP/026VmsHcfFq9DZVbG/wAIeZ
B1YDomUTeyROPvdHpGDK9AFhzl8473OQlnWYpO5ZLDwqGIzbxtKDU0C7y0A94TA0
nL6+pySnAoVSOt+rQIZls0qVklWIglLPyxjtv8QE8l5Tw+vGC3WwOXjb3N2oZ+BM
2y4l/4XRjIwsX6wt82f2xlWwv6+B+DGUbTymvr+JpnNDRXP+lbC66035wVBO1YPr
tyWv1JAt5fzzKwSTITamALdQ0icUIh1T1q+byXTXnJdlEDoszYe0fI7HReK9xsIY
AcPfubj9wKb4dorSY+2Fl6nVFOUC5PGcx4b99bqNQaMU9U6DvitO4WXWNY4hIYPz
EhWLlINrT1KM/mBMocAODIeaTuNokdsJ9drQtElMYgNrWT7NgyyzRwRdRkKBU28Q
7O96yqku7LG3h7GO/HlFs64SlxBJS8IVPqgMeZIwU06EsKv01lnXsUFTV2e6P76z
ok1OZkEjnus0ao8Wzu+xaOtjsrQxGwFkhCDFxbhOdc5vAWfDSyxOhhvVt8vdsUhg
LM5ZxXdgH+dWvs0d3I+F9ifL9gQ6mSfb87Dmg/bhTOMnJGaUdoVPA5ADgW7BXDod
vJEf2MFYapc/pZwWjwvtCfEjAacgOKnZIF+ARc7U+NeHjxLn6JjOiaUqqgYv+OLH
FYISXAasWtIMn8pO55NG
=kUtp
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
