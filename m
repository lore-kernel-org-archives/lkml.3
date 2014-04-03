Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbaDCDYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 23:24:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40142 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923AbaDCDYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 23:24:33 -0400
Date: Wed, 02 Apr 2014 23:25:51 -0400 (EDT)
Message-Id: <20140402.232551.1759364188114803618.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Apr 2014 20:24:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s333P7ni015341


Here is my initial pull request for the networking subsystem during
this merge window:

1) Support for ESN in AH (RFC 4302) from Fan Du.

2) Add full kernel doc for ethtool command structures, from Ben Hutchings.

3) Add BCM7xxx PHY driver, from Florian Fainelli.

4) Export computed TCP rate information in netlink socket dumps, from Eric
   Dumazet.

5) Allow IPSEC SA to be dumped partially using a filter, from Nicolas
   Dichtel.

6) Convert many drivers to pci_enable_msix_range(), from Alexander Gordeev.

7) Record SKB timestamps more efficiently, from Eric Dumazet.

8) Switch to microsecond resolution for TCP round trip times, also from Eric
   Dumazet.

9) Clean up and fix 6lowpan fragmentation handling by making use of
   the existing inet_frag api for it's implementation.

10) Add TX grant mapping to xen-netback driver, from Zoltan Kiss.

11) Auto size SKB lengths when composing netlink messages based upon
    past message sizes used, from Eric Dumazet.

12) qdisc dumps can take a long time, add a cond_resched(),  From Eric
    Dumazet.

13) Sanitize netpoll core and drivers wrt. SKB handling semantics.  Get rid
    of never-used-in-tree netpoll RX handling.  From Eric W. Biederman.

14) Support inter-address-family and namespace changing in VTI tunnel
    driver(s).  From Steffen Klassert.

15) Add Altera TSE driver, from Vince Bridgers.

16) Optimizing csum_replace2() so that it doesn't adjust the checksum
    by checksumming the entire header, from Eric Dumazet.

17) Expand BPF internal implementation for faster interpreting, more
    direct translations into JIT'd code, and much cleaner uses of BPF
    filtering in non-socket ocntexts.  From Daniel Borkmann and Alexei
    Starovoitov.

I did a test merge just now and there were three conflicts:

1) drivers/of/of_net.c, simple keep the addition of phy_modes[].

2) drivers/staging/wlags49_h2/wl_netdev.c, Eric Biederman changed this
   driver to properly use "consume" and "any" variants of SKB freeing
   functions.  They are all in similar locations at the conflict
   points, but indented differently, etc.

3) drivers/staging/wlan-ng/cfg80211.c, use the ieee80211_get_channel()
   invocation that uses the value already computed in 'freq'.

Please pull, thanks a lot.

The following changes since commit 49d8137a4039c63c834827f4bfe875e27bb9c521:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-03-28 15:09:37 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to b1586f099ba897542ece36e8a23c1a62907261ef:

  netpoll: Use skb_irq_freeable to make zap_completion_queue safe. (2014-04-01 17:53:36 -0400)

----------------------------------------------------------------
Aaron Durbin (2):
      mwifiex: balance dma map/unmap sizes
      mwifiex: don't leak DMA command skbuffs

Adam Lee (2):
      rtlwifi: add MSI interrupts mode support
      rtlwifi: rtl8188ee: enable MSI interrupts mode

Akeem G Abodunrin (3):
      i40e: Setting i40e_down bit for tx_timeout
      i40e: Prevent overflow due to kzalloc
      i40e: Fix function comments

Alexander Aring (26):
      6lowpan: add frag information struct
      6lowpan: add uncompress header size function
      6lowpan: fix fragmentation on sending side
      6lowpan: change tag type to __be16
      6lowpan: move 6lowpan.c to 6lowpan_rtnl.c
      6lowpan: fix some checkpatch issues
      net: ns: add ieee802154_6lowpan namespace
      6lowpan: handling 6lowpan fragmentation via inet_frag api
      6lowpan: fix type of datagram size parameter
      6lowpan: remove initialization of tag value
      6lowpan: use memcpy to set tag value in fraghdr
      at86rf230: add help and 212 to Kconfig menu entry
      ieee802154: fix whitespace issues in Kconfig
      6lowpan: add missing include of net/ipv6.h
      6lowpan: move 6lowpan header to include/net
      6lowpan: reassembly: fix return of init function
      6lowpan: reassembly: fix access of ctl table entry
      Bluetooth: make bluetooth 6lowpan as an option
      at86rf230: fix unexpected state change
      at86rf230: move locking state in xmit
      at86rf230: change reset timings
      at86rf230: make reset pin optionally
      at86rf230: add support for devicetree
      af_ieee802154: fix check on broadcast address
      ieee802154: dgram: cleanup set of broadcast panid
      at86rf230: mask irq's before deregister device

Alexander Bondar (6):
      iwlwifi: mvm: Enable power save on BSS and P2P client in DCM
      iwlwifi: pcie: enable LP XTAL to reduce power consumption
      iwlwifi: mvm: Change beacon filter enablement condition
      iwlwifi: mvm: restructure scan parameters calculation
      iwlwifi: mvm: configure low latency dependent scan parameters
      mac80211: release sched_scan_sdata when stopping sched scan

Alexander Gordeev (38):
      ath10k: Get rid of superfluous call to pci_disable_msi()
      ath10k: Disable MSI in case IRQ configuration is unknown
      ath10k: Use pci_enable_msi_range()
      bnx2: Use pci_enable_msix_range() instead of pci_enable_msix()
      bnx2x: Use pci_enable_msix_range() instead of pci_enable_msix()
      tg3: Use pci_enable_msix_range() instead of pci_enable_msix()
      bna: Use pci_enable_msix_range() instead of pci_enable_msix()
      cxgb3: Remove superfluous call to pci_disable_msix()
      cxgb3: Use pci_enable_msix_range() instead of pci_enable_msix()
      cxgb4: Use pci_enable_msix_range() instead of pci_enable_msix()
      cxgb4vf: Remove superfluous call to pci_disable_msix()
      cxgb4vf: Use pci_enable_msix_range() instead of pci_enable_msix()
      enic: Use pci_enable_msix_range() instead of pci_enable_msix()
      benet: Use pci_enable_msix_range() instead of pci_enable_msix()
      e1000e: Use pci_enable_msix_range() instead of pci_enable_msix()
      i40e: Use pci_enable_msix_range() instead of pci_enable_msix()
      igb: Use pci_enable_msix_range() instead of pci_enable_msix()
      igbvf: Use pci_enable_msix_range() instead of pci_enable_msix()
      ixgbe: Use pci_enable_msix_range() instead of pci_enable_msix()
      ixgbevf: Use pci_enable_msix_range() instead of pci_enable_msix()
      mlx4: Use pci_enable_msix_range() instead of pci_enable_msix()
      mlx5: Use pci_enable_msix_range() instead of pci_enable_msix()
      myri10ge: Use pci_enable_msix_range() instead of pci_enable_msix()
      s2io: Use pci_enable_msix_range() instead of pci_enable_msix()
      vxge: Use pci_enable_msix_range() instead of pci_enable_msix()
      forcedeth: Fix invalid errno reporting in nv_request_irq()
      forcedeth: Cleanup MSI-X to MSI to INTx fallback code
      forcedeth: Use pci_enable_msix_range() instead of pci_enable_msix()
      netxen: Use pci_enable_msix_range() instead of pci_enable_msix()
      qlcnic: Cleanup qlcnic_enable_msix() return values
      qlcnic: Use pci_enable_msix_range() instead of pci_enable_msix()
      qlge: Get rid of an redundant assignment
      qlge: Use pci_enable_msix_range() instead of pci_enable_msix()
      sfc: Use pci_enable_msix_range() instead of pci_enable_msix()
      niu: Use pci_enable_msix_range() instead of pci_enable_msix()
      vmxnet3: Fix MSI-X/MSI enablement code
      vmxnet3: Use pci_enable_msix_range() instead of pci_enable_msix()
      wil6210: Use pci_enable_msi_range() instead of pci_enable_msi_block()

Alexander Shiyan (3):
      can: mcp251x: Make driver more quiet
      can: mcp251x: Remove #ifdef CONFIG_PM_SLEEP
      can: mcp251x: Fix regulators operation without CONFIG_REGULATOR

Alexei Starovoitov (2):
      net: filter: rework/optimize internal BPF interpreter's instruction set
      doc: filter: extend BPF documentation to document new internals

Alexey Khoroshilov (3):
      connector: remove duplicated code in cn_call_callback()
      p54usb: fix leaks at failure path in p54u_probe()
      rtl8187: fix use after free on failure path in rtl8187_probe()

Amir Vadai (6):
      net: Add sysfs file for port number
      net/mlx4_en: Expose port number through sysfs
      net/mlx4_en: Fix bad use of dev_id
      net/mlx4_en: Fix UP limit in ieee_ets->prio_tc
      net/mlx4_en: Fix selftest failing on non 10G link speed
      net/mlx4_en: Use union for BlueFlame WQE

Amitkumar Karwar (30):
      mwifiex: change beacon parameter structure
      mwifiex: separate out response buffer parsing code
      mwifiex: separate out next scan command queueing logic
      mwifiex: implement extended scan feature
      mwifiex: update beamforming capability field for HT
      mwifiex: advertise correct beamforming information for VHT
      mwifiex: cleanup in mwifiex_fill_cap_info()
      mwifiex: enable obss scan offload feature flag
      mwifiex: change transmit buffer size for 8897
      mwifiex: abort scan while cancelling pending command
      mwifiex: skipping pending commands after unload
      mwifiex: stop AP at shutdown time
      mwifiex: block further commands after timeout
      mwifiex: get rid of extra num_cmd_timeout variable
      mwifiex: replace num_cmd_timeout with is_cmd_timedout
      mwifiex: update MCS information as per antenna settings
      mwifiex: extract firmware API version number
      mwifiex: add VHT MCS rate configuration support
      mwifiex: use VHT MCS mask in set bitrate mask handler
      mwifiex: code rearrangement for better readability
      mwifiex: create separate function mwifiex_11n_dispatch_pkt()
      mwifiex: add AMSDU inside AMPDU support
      Bluetooth: btmrvl: don't consume all vendor specific events
      mwifiex: corner case NULL pointer dereference fix
      mwifiex: correction in sleep confirm command sequence number
      mwifiex: cancel pending commands during host sleep
      mwifiex: scan command preparation failure handling
      mwifiex: cancel pending commands for signal
      mwifiex: use timeout variant for wait_event_interruptible
      mwifiex: fix spinlock bad magic bug

Andi Kleen (1):
      sections, ipvs: Remove useless __read_mostly for ipvs genl_ops

Andre Guedes (23):
      Bluetooth: Save connection interval parameters in hci_conn
      Bluetooth: Group list_head fields from strcut hci_dev together
      Bluetooth: Introduce le_conn_failed() helper
      Bluetooth: Introduce connection parameters list
      Bluetooth: Use connection parameters if any
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
      Bluetooth: Enable duplicates filter in background scan

Andrea Merello (30):
      rtl8180: prepare to handle more than two chip types
      rtl8180: remove too-early-added rtl8187se enum value
      rtl8180: support for BSS_CHANGED_BASIC_RATES
      rtl8180: make *IFS and CW tunable by mac80211, and set them in the proper place
      rtl8180: move eeprom read stuff in a separate function
      rtl818x: remove unused conf_erp callback from RF ops struct
      rtl8180: fix DMA register are written two times
      rtl8180: rationalize TX queues
      rtl818x: add registers for rtl8187se
      rtl8180: add rtl8187se chip type
      rtl8180: add rtl8187se fields to TX descriptor
      rtl8180: add basic rate configuration support for rtl8187se
      rtl8180: support for rtl8187se RX descriptors
      rtl8180: add ISR for rtl8187se
      rtl8180: introduce functions to enable/disable ints and add support for rtl8187se
      rtl8180: don't write MAR registers for rtl8187se
      rtl8180: add TX queue mapping and support for rtl8187se
      rtl8180: config carbus register for rtl8187se
      rtl8180: add rtl8187se params to eeprom reading
      rtl8180: introduce functions for setting ANAPARAM 2 and 3 params
      rtl8180: add RF code for rtl8225 zebra v4
      rtl8180: add rtl8187se HW initialization
      rtl8180: add ERP configuration for rtl8187se
      rtl8180: make sure RTL818X_MSR_ENEDCA is set for rtl8187se
      rtl8180: add WMM parameters configuration for rtl8187se
      rtl8180: detect rtl8187se card
      rtl8180: enable rtl8187se support
      rtl818x: Update Kconfig for rtl8187se
      rtl8187: fix compile warning
      rtl8180: don't use weird trick to access "far" registers

Andreas Bofj√§ll (1):
      tipc: explicitly include core.h in addr.h

Andrei Otcheretianski (1):
      mac80211_hwsim: add channel switch support

Andrew Earl (1):
      Bluetooth: Fix aborting eSCO connection in case of error 0x20

Andrzej Kaczmarek (2):
      Bluetooth: Fix channel check when binding RFCOMM sock
      Bluetooth: Fix NULL pointer dereference when sending data

Andy Shevchenko (2):
      Bluetooth: sort the list of IDs in the source code
      Bluetooth: append new supported device to the list [0b05:17d0]

Anjali Singhai Jain (16):
      i40e: Remove a FW workaround for Number of MSIX vectors
      i40e: Remove a redundant filter addition
      i40e: Fix a bug in the update logic for FDIR SB filter.
      i40e/i40evf: Some flow director HW definition fixes
      i40e: Define a new state variable to keep track of feature auto disable
      i40e: Add code to handle FD table full condition
      i40e: Bug fix for FDIR replay logic
      i40e: Let MDD events be handled by MDD handler
      i40e: Patch to enable Ethtool/netdev feature flag for NTUPLE control
      i40e/i40evf: Add EEE LPI stats
      i40e: Fix a message string
      i40e: Delete ATR filter on RST
      i40e: Cleanup in FDIR SB ethtool code
      i40e: Add functionality for FD SB to drop packets
      i40e/i40evf: Add an FD message level
      i40e: Use DEBUG_FD message level for an FD message

Antonio Quartulli (5):
      cfg80211: fix channel configuration in IBSS join
      batman-adv: prefer ether_addr_copy to memcpy
      batman-adv: add kerneldoc for dst_hint argument
      batman-adv: improve the TT flags documentation
      batman-adv: improve DAT documentation

Ard Biesheuvel (1):
      mac80211: drop unused param 'encrypted' from ccmp_special_blocks()

Arend van Spriel (17):
      brcmfmac: move SDIO specific functions
      brcmfmac: rename sdio_chip.[ch]
      brcmfmac: make chip related functions host interface independent
      brcmfmac: remove TRACE level debug message from brcmf_sdio_bus_sleep()
      brcmfmac: remove unintended error logging
      brcmfmac: get chip core information from the device
      brcmfmac: CR4 takes precedence over CM3 in brcmf_chip_enter_download()
      brcmfmac: fix use of skb control buffer in SDIO driver part
      brcmfmac: remove unused variable data_len from brcmf_sdio_bus_txdata()
      brcmfmac: use pre-allocated scatter-gather table for txglomming
      brcmfmac: reset suspend flag upon sdio suspend failure
      Revert "brcmfmac: Use atomic functions for intstatus update."
      brcmfmac: assure active clock request upon entering SLEEP state
      brcmfmac: remove mode field from brcmf_cfg80211_vif structure
      brcmfmac: reinit watchdog completion after handling watchdog
      brcmfmac: only show error message when brcmf_sdiod_regrw_helper() fails
      brcmfmac: fallback to mimo_bw_cap for older firmwares

Ariej Marjieh (3):
      iwlwifi: mvm: remove upper limit for error log base pointer
      iwlwifi: 8000: add 11n only SKU of 8000 devices
      iwlwifi: change number of PAPD groups in PHY DB

Ariel Elior (1):
      bnx2x: Remove unnecessary internal mem config

Arik Nemtsov (10):
      iwlwifi: add very first D0i3 support
      iwlwifi: mvm: add D0i3 ref/unref for scan
      wlcore: cancel Tx watchdog on suspend and rearm on first Tx after
      wlcore: AP: don't start mac80211 PS on non-peer HLIDs
      wlcore: wl18xx: allow CCK rates for AP mode
      wlcore: decrease warning verbosity during recovery
      wlcore: add support for STA CSA with chan contexts
      iwlwifi: mvm: wait for stop sched-scan completion
      iwlwifi: mvm: abort scan on sched_scan request
      iwlwifi: mvm: reconfigure qos seq on D0i3 exit

Arnd Bergmann (8):
      atm: firestream: fix interruptible_sleep_on race
      isdn: pcbit: fix interruptible_sleep_on race
      isdn: hisax/elsa: fix sleep_on race in elsa FSM
      isdn: divert, hysdn: fix interruptible_sleep_on race
      isdn: fix multiple sleep_on races
      atm: nicstar: remove interruptible_sleep_on_timeout
      Bluetooth: make sure 6LOWPAN_IPHC is built-in if needed
      wireless: Kconfig: add missing dependency for airo_cs

Arron Wang (2):
      NFC: pn544: Pass hardware variant information when downloading firmware
      NFC: pn544: i2c: Support PN544 C3 secure firmware download

Avinash Patil (21):
      mwifiex: handle AMPDU supported check for AP interface
      mwifiex: make tos_to_tid_inv part of mwifiex_private structure
      mwifiex: move station list functions to common code
      mwifiex: add tdls_mgmt handler support
      mwifiex: parse TDLS action frames during RX
      mwifiex: add cfg80211 tdls_oper handler support
      mwifiex: add cfg80211 add_station handler support
      mwifiex: add cfg80211 change_station handler support
      mwifiex: provision for holding and restoring packets during TDLS setup
      mwifiex: tdls related handling for data packets addressed to TDLS peer
      mwifiex: AMPDU support for TDLS link
      mwifiex: pass ieee80211_vht_cap to mwifiex_fill_vht_cap_tlv
      mwifiex: add VHT support for TDLS
      mwifiex: separate BA params for TDLS link if 11ac is supported
      mwifiex: disable all TDLS link during disconnection
      mwifiex: parse API version from FW
      mwifiex: add key material v2 support
      mwifiex: use del_timer_sync instead of del_timer
      mwifiex: remove redundant del_timer
      mwifiex: handle extended scan event for AP interface
      mwifiex: add support for sleep cookie in PCIe

Avinash kumar (1):
      drivers:net:wireless:airo.c:checkpatch.pl cleanup

Avri Altman (1):
      iwlwifi: mvm: disable power on P2P client when BSS is added

Axel Lin (9):
      NFC: NCI: Use reinit_completion() at appropriate places
      NFC: port100: Convert to use USB_DEVICE macro
      NFC: pn533: Convert to use USB_DEVICE macro
      NFC: Use list_for_each_entry in nfc_find_se()
      NFC: digital: Use matching_[im|tm]_protocols to check with NFC protocols masks
      NFC: Use LIST_HEAD() at appropriate places
      NFC: Remove redundant test for dev->n_targets in nfc_find_target
      NFC: Move checking valid gb_len value to nfc_llcp_set_remote_gb
      NFC: llcp: Use list_for_each_entry in nfc_llcp_find_local()

Barak Bercovitz (2):
      wlcore: block read/writes to FW during ELP
      wlcore: don't stop sched_scan on interface removal

Bartosz Markowski (2):
      ath10k: remove excessive rx msdu len check
      ath10k: AP: handle HT station which does not have HT RX MCS

Ben Chan (2):
      USB: cdc: add MBIM extended functional descriptor structure
      net: cdc_ncm: respect operator preferred MTU reported by MBIM

Ben Dooks (3):
      phy: micrel: add of configuration for LED mode
      sh_eth: update OF PHY registeration
      sh_eth: ensure pm_runtime cannot suspend the device during init

Ben Greear (7):
      ath10k:  Print out firmware feature bits from IE.
      ath10k: print out size of wmi-ready-event message
      ath10k: add more debugging for receive errors
      ath10k: better tx/rx debugging
      ath10k:  add more details to some debug messages
      ath10k: add vdev-id, return code to error codes
      ath10k: support msdu chaining

Ben Hutchings (27):
      ethtool: Expand documentation of struct ethtool_cmd
      ethtool: Expand documentation of struct ethtool_drvinfo
      ethtool: Expand documentation of struct ethtool_wol
      ethtool: Expand documentation of struct ethtool_regs
      ethtool: Expand documentation of struct ethtool_eeprom
      ethtool: Expand documentation of struct ethtool_ringparam
      ethtool: Update documentation of struct ethtool_pauseparam
      ethtool: Expand documentation of string set types
      ethtool: Expand documentation of struct ethtool_test
      ethtool: Expand documentation of struct ethtool_stats
      ethtool: Expand documentation of struct ethtool_perm_addr
      ethtool: Document the general convention for VLAs in kernel space
      ethtool: Move kernel-doc comment next to struct ethtool_dump definition
      ethtool: Fix unwanted section breaks in kernel-doc
      sfc: Cache skb->data in local variable in efx_ptp_rx()
      sfc: Rewrite adjustment of PPS event in a clearer way
      sfc: Replace TSOH_OFFSET with the equivalent NET_IP_ALIGN
      sfc: Remove unused definitions of EF10 user-mode DMA descriptors
      sfc: Correct comment about number of TX queues used on EF10
      sfc: Preserve rx_frm_trunc counters when resizing DMA rings
      sfc: Rename 'use_options' variable in tso_start() to clearer 'use_opt_desc'
      sfc: Use canonical pointer type for MAC address in efx_set_mac_address()
      sfc: Update product naming
      sfc: Cosmetic changes to self-test from the out-of-tree driver
      sfc: Fail self-test with -EBUSY, not -EIO, if the device is busy
      sfc: Add/remove blank lines to taste
      cgxb4: Stop using ethtool SPEED_* constants

Bing Zhao (5):
      mwifiex: make use of IEEE80211_VHT_MCS_NOT_SUPPORTED
      mwifiex: make 11ac mcs rate tables global and const
      mwifiex: improve readability in 11ac mcsmap to maxrate conversion
      mwifiex: remove unsupported code in 11ac
      mwifiex: remove global variable cmd_wait_q_required

Bjorn Van Tilt (1):
      can: usb_8dev: Fix memory leak in usb_8dev_start_xmit

Bj√∏rn Mork (2):
      ipv6: log src and dst along with "udp checksum is 0"
      ipv6: addrconf: silence sparse endianness warnings

Byungho An (3):
      MAINTAINERS: add maintainer for Samsung sxgbe driver
      net: sxgbe: fix sparse warnings about static declaration
      net: sxgbe: fix potential null dereference

Calvin Owens (1):
      ieee80211: Print human-readable disassoc/deauth reason codes

Carolyn Wyborny (3):
      igb: Update license text to remove FSF address and update copyright.
      igb: Fix for devices using ethtool for EEE settings
      igb: Add register defines needed for time sync functions

Catherine Sullivan (4):
      i40e: Change MSIX to MSI-X
      i40e and i40evf: Bump driver versions
      i40e/i40evf: Bump pf&vf build versions
      i40e/i40evf: Bump build versions

Christian Engelmayer (1):
      igb: Fix memory leak in igb_get_module_eeprom()

Christian Riesch (2):
      ptp: Fix compiler warnings in the testptp utility
      ptp: Fix compiler warnings in the testptp utility

Christoph Paasch (2):
      igb: Fix Null-pointer dereference in igb_reset_q_vector
      igb: Unset IGB_FLAG_HAS_MSIX-flag when falling back to msi-only

Christopher R. Baker (1):
      can: populate netdev::dev_id for udev discrimination

Chun-Yeow Yeoh (5):
      ath10k: fix the printing of 10.x FW version when FW crashed
      mac80211: fix the increment of mesh precedence value
      ath10k: implement drv_get_tsf for ibss merging
      ath10k: set the mactime of ieee80211_rx_status
      mac80211: add missing update on rx status VHT flag

Claudio Takahasi (1):
      Bluetooth: Fix removing Long Term Key

Claudiu Manoil (15):
      gianfar: Cleanup/Fix gfar_probe and the hw init code
      gianfar: Remove sysfs stubs for FIFOCFG and stashing
      gianfar: Remove useless HAS_PADDING device flag
      gianfar: Factor out enabling/disabling of hw interrupts
      gianfar: Add missing graceful reset steps and fixes
      gianfar: Remove clean_rx_ring race from gfar_ethtool
      gianfar: Implement MAC reset and reconfig procedure
      gianfar: Fix on-the-fly vlan and mtu updates
      gianfar: Don't free/request irqs on device reset
      gianfar: Fix device reset races (oops) for Tx
      gianfar: Fix Tx int miss, dont write IC on-the-fly
      gianfar: Separate out the Tx interrupt handling (Tx NAPI)
      gianfar: Use Single-Queue polling for "fsl,etsec2"
      gianfar: Fix multi-queue support checks @probe()
      gianfar: Fix P1010 config regression (SQ polling)

C√©dric Le Goater (1):
      hostap: add Netgear MA401 card

Daeseok Youn (3):
      atm: ambassador: use NULL instead of 0 for pointer
      atm: nicstar: use NULL instead of 0 for pointer
      atm: solos-pci: make solos_bh() as static

Dan Carpenter (6):
      mwifiex: memory corruption in mwifiex_tdls_add_vht_capab()
      i40e: potential array underflow in i40e_vc_process_vf_msg()
      rsi: rsi_91x: misleading debug printk
      net: sxgbe: sxgbe_mdio_register() frees the bus
      net: sxgbe: fix logical vs bitwise operation
      net: sxgbe: make "core_ops" static

Daniel Baluta (1):
      net: remove empty lines from tcp_syn_flood_action

Daniel Borkmann (15):
      loopback: sctp: add NETIF_F_SCTP_CSUM to device features
      tools: bpf_dbg: various misc code cleanups
      packet: allow to transmit +4 byte in TX_RING slot for VLAN case
      net: sctp: remove NULL check in sctp_assoc_update_retran_path
      net: nlmon: flag nlmon devs with LLTX/SG
      packet: respect devices with LLTX flag in direct xmit
      net: filter: add jited flag to indicate jit compiled filters
      net: filter: keep original BPF program around
      net: filter: move filter accounting to filter core
      net: ptp: use sk_unattached_filter_create() for BPF
      net: ptp: do not reimplement PTP/BPF classifier
      net: ppp: use sk_unattached_filter api
      net: isdn: use sk_unattached_filter api
      net: filter: minor: fix kdoc in __sk_run_filter
      net: ptp: move PTP classifier in its own file

Daniel Kim (5):
      brcmfmac: enable firmware console logging functionality
      brcmfmac: correct setting of WEP broadcast/unicast keys
      brcmfmac: Correct mcs index report
      brcmfmac: Enable 40MHz bandwidth in 2GHz band and OBSS scanning operations
      brcmfmac: use mfp if required from user-space

Daniel Pieczko (1):
      Call efx_set_channels() before efx->type->dimension_resources()

David Ertman (14):
      e1000e: Cleanup unecessary references
      e1000e: Resolve issues with Management Engine (ME) briefly blocking PHY resets
      e1000e: Fix 82579 sets LPI too early.
      e1000e: Cleanup - Update GPL header and Copyright
      e1000e: Add missing branding strings in ich8lan.c
      e1000e: Refactor PM flows
      e1000e Refactor of Runtime Power Management
      e1000e: Feature Enable PHY Ultra Low Power Mode (ULP)
      e1000e: Fix not generating an error on invalid load parameter
      e1000e: Fix ethtool offline tests for 82579 parts
      e1000e: Fix SHRA register access for 82579
      e1000e: Fix Hardware Unit Hang
      e1000e: Fix Explicitly set Transmit Control Register
      e1000e: Fix no connectivity when driver loaded with cable out

David Howells (5):
      af_rxrpc: Fix UDP MTU calculation from ICMP_FRAG_NEEDED
      af_rxrpc: Add sysctls for configuring RxRPC parameters
      af_rxrpc: Improve ACK production
      af_rxrpc: Expose more RxRPC parameters via sysctls
      af_rxrpc: Request an ACK for every alternate DATA packet

David S. Miller (105):
      Merge branch 'ethtool_docs'
      Merge branch 'sfc'
      Merge branch 'bnx2x'
      Merge branch 'net_sched'
      Merge branch 'i40e'
      Merge branch 'tipc'
      Merge tag 'linux-can-next-for-3.15-20140212' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'bcmgenet'
      Merge branch 'phy'
      Merge branch 'ieee802154'
      Merge branch 'gianfar'
      Merge branch 'msix'
      Merge branch 'cxgb4'
      Merge branch 'r8152'
      Merge branch 'bonding'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'i40evf'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'mlx4'
      Merge branch 'qlcnic-next'
      bcmgenet: Deleted unnecessary select_queue method.
      Merge branch 'gianfar'
      Merge branch 'bnx2x'
      Merge branch 'mlx4'
      Merge branch 'intel-next'
      Merge branch 'kdoc'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'intel-next'
      Merge branch '6lowpan'
      Merge branch 'intel-next'
      Merge branch '6lowpan'
      Merge branch 'mlx4'
      Merge branch 'mpls_tc'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'r8152'
      tcp: Use NET_ADD_STATS instead of NET_ADD_STATS_BH in tcp_event_new_data_sent()
      Merge branch '6lowpan'
      Merge branch 'xen-netback-next'
      Merge tag 'rxrpc-devel-20140304' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'r8152'
      Merge tag 'linux-can-next-for-3.15-20140307' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'gianfar-next'
      Merge branch 'hyperv-next'
      Merge branch 'pkt_sched_cond_resched'
      Merge branch 'tipc'
      Merge branch 'mlx4-next'
      Merge branch 'dev_kfree_skb_any'
      Merge branch 'cxgb4-next'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'napi_budget_zero'
      Merge branch 'ieee802154-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'alb_learning'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'cxgb4-next'
      Merge branch 'napi_budget_zero'
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge branch 'netpoll-next'
      Merge branch 'sh_eth'
      Merge branch 'at86rf230'
      Merge branch 'altera_tse'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge tag 'linux-can-next-for-3.15-20140317' of git://gitorious.org/linux-can/linux-can-next
      netfilter: Add missing vmalloc.h include to nft_hash.c
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'mlx4-next'
      Merge branch 'cdc-next'
      Merge branch 'sh_eth-next'
      Merge branch 'bcmgenet-next'
      Merge branch 'ptp-next'
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'qlcnic-next'
      Merge git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../ebiederm/net-next
      xen-netback: Proper printf format for ptrdiff_t is 't'.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'bnx2x-next'
      Merge branch 'bcm7xxx-next'
      Merge branch 'bonding-next'
      Merge branch 'bonding-next'
      Merge branch 'sxgbe'
      Merge branch 'tipc-next'
      Revert "ptp: Fix compiler warnings in the testptp utility"
      Merge branch 'mdio_reset-next'
      Merge branch 'be2net-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'tipc-next'
      Merge branch 'mlx4_vxlan'
      Merge branch 'skb_cow_head'
      Merge branch 'netpoll-next'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'xen-netback'
      Merge branch 'filter-next'
      Merge branch 'bridge_8021AD'
      Merge branch 'net_sysfs_doc'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge tag 'linux-can-fixes-for-3.15-20140401' of git://gitorious.org/linux-can/linux-can

David Spinadel (3):
      iwlwifi: mvm: don't stop sched scan in restart
      iwlwifi: mvm: notify scan completed even if no fw_restart
      mac80211: fix IE buffer len

Denis Kirjanov (1):
      ipv4: ip_forward: perform skb->pkt_type check at the beginning

Dinh Nguyen (1):
      net: stmmac: Add SOCFPGA glue driver

Dmitry Kravkov (1):
      bnx2x: utilize FW 7.8.19

Don Fry (2):
      pcnet32: fix reallocation error
      pcnet32: add missing check for pci_dma_mapping_error

Don Skidmore (7):
      ixgbe: modify behavior on receiving a HW ECC error.
      ixgbe: fix to use correct timeout interval for memory read completion
      ixgbe: collect all 82599 AUTOC code in one function
      ixgbe: fix bit toggled for 82599 reset fix.
      ixgbe: Add check for FW veto bit
      ixgbe: fix errors related to protected AUTOC calls
      ixgbe: Stop cacheing if the MNG FW enabled

Duan Jiong (1):
      neigh: directly goto out after setting nud_state to NUD_FAILED

Edward Cree (1):
      sfc: Use ether_addr_copy and eth_broadcast_addr

Eliad Peller (35):
      iwlwifi: mvm: add basic bcast filtering implementation
      iwlwifi: mvm: add predefined broadcast filter configuration
      iwlwifi: mvm: add dest ip to bcast filter configuration
      iwlwifi: mvm: add bcast_filtering debugfs entries
      iwlwifi: add D0i3 references boiler plate
      iwlwifi: add enter/exit D0i3 ops
      iwlwifi: mvm: add D0i3 power configurations
      iwlwifi: mvm: configure vifs upon D0i3 entry/exit
      iwlwifi: mvm: allow transport sleep when FW is operational
      iwlwifi: mvm: add D0i3 ref/unref for ROC commands
      iwlwifi: mvm: add D0i3 ref/unref when ap, ibss or p2p_cli vifs are running
      iwlwifi: mvm: add d0i3_refs debugfs file
      iwlwifi: mvm: configure WOWLAN_CONFIGURATION on D0i3 entry
      iwlwifi: mvm: get status on D0i3 exit
      iwlwifi: mvm: add debugfs hook to take an mvm ref
      iwlwifi: mvm: reserve sta_id 0 to station
      mac80211: reset probe_send_count also in HW_CONNECTION_MONITOR case
      mac80211: add beacon_loss debugfs file
      iwlwifi: pcie: clean iwl_pcie_[rt]xq_inc_wr_ptr a bit
      iwlwifi: mvm: add debugfs for prph reg read/write
      wlcore/wl12xx/wl18xx: simplify fw_status handling
      wlcore/wl12xx/wl18xx: configure num_links per-hw
      wlcore/wl12xx/wl18xx: configure max_stations per-hw
      wlcore/wl12xx/wl18xx: configure iface_combinations per-hw
      wl18xx: move to new firmware (wl18xx-fw-3.bin)
      wlcore: don't handle unsetting of default wep key
      wlcore: consider multiple APs when checking active_link_count
      wlcore: enable beacon filtering only after receiving a beacon
      iwlwifi: mvm: fix a few wd_disable comments
      iwlwifi: mvm: check for d0i3 fw capability
      iwlwifi: rs: split rs_collect_tx_data
      iwlwifi: add rs_rate_scale_clear_tbl_windows helper function
      iwlwifi: mvm: configure seq_num to D0i3
      iwlwifi: mvm: configure protocol offloading on D0i3
      mac80211: add status_driver_data array to ieee80211_tx_info

Elizabeth Kappler (1):
      i40e: Refactor and cleanup i40e_open(), adding i40e_vsi_open()

Emil Goode (2):
      brcmsmac: fix deadlock on missing firmware
      brcmsmac: update comment to reflect the code

Emil Tantilov (3):
      ixgbevf: fix handling of tx checksumming
      ixgbevf: add check for CHECKSUM_PARTIAL when doing TSO
      ixgbe: enable tx queues after link up

Emmanuel Grumbach (44):
      iwlwifi: 7000: warn about old firmware
      iwlwifi: remove obsolete TODO
      iwlwifi: mvm: provide helper to fetch the iwl_mvm_sta from sta_id
      iwlwifi: mvm: check ARRAY_SIZE(mvm->fw_id_to_mac_id) = IWL_MVM_STATION_COUNT
      iwlwifi: pcie: fix unused variable gcc warning
      iwlwifi: mvm: BT Coex - set low latency vif as primary
      iwlwifi: mvm: BT Coex - change SMPS settings in AP mode
      iwlwifi: mvm: change the format of the SRAM dump
      iwlwifi: mvm: allow to force reduced tx power from debugfs
      iwlwifi: mvm: add vif type in debugfs output
      iwlwifi: fix kerneldoc format
      iwlwifi: mvm: BT Coex - fix SYNC2SCO flags
      iwlwifi: mvm: remove duplicate assignment to ap_ibss_active
      iwlwifi: mvm: clean up in power code
      iwlwifi: mvm: don't look at power commmand to decide if power is enabled
      iwlwifi: mvm: don't send the beacon filtering command from iterator
      iwlwifi: mvm: store latest power command for debugfs read
      iwlwifi: mvm: remove support for legacy power API
      iwlwifi: mvm: remove iwl_mvm_power_mac_disable
      iwlwifi: mvm: refactor power code
      mac80211: remove unused radiotap vendor fields in ieee80211_rx_status
      mac80211: move VHT related RX_FLAG to another variable
      mac80211: propagate STBC / LDPC flags to radiotap
      iwlwifi: mvm: fix typo in WARNING in rs.c
      iwlwifi: mvm: propagate LDPC / STBC status to radiotap
      iwlwifi: mvm: don't dump log of second CPU when not relevant
      iwlwifi: pcie: stop the firmware when we restart it
      iwlwifi: mvm: set immediate apply time bit in time events
      iwlwifi: mvm: fix quota for D3 image
      iwlwifi: mvm: fix scan offload for BGN SKU
      iwlwifi: dvm: take mutex when sending SYNC BT config command
      iwlwifi: mvm: BT Coex add support for Co-running block
      iwlwifi: mvm: make bt-coex.c generic
      iwlwifi: mvm: BT Coex - classify packet priority in BT code
      iwlwifi: mvm: BT Coex - enable per-AC BT priority
      iwlwifi: mvm: fix merge damage
      iwlwifi: mvm: don't fail completely if led mode is not supported
      iwlwifi: mvm: send udev event upon firmware error to dump logs
      iwlwifi: mvm: BT Coex - add debugfs hook to set BT Tx priority
      iwlwifi: mvm: fix theoretical NULL ptr dereference
      iwlwifi: mvm: disable uAPSD due to bugs in the firmware
      iwlwifi: mvm: add missing include
      cfg80211/mac80211: ignore signal if the frame was heard on wrong channel
      mac80211: set beamforming bit in radiotap

Eran Harary (10):
      iwlwifi: Add 8000 HW family support
      iwlwifi: mvm: support NVM sections for family 8000
      iwlwifi: pcie: disable APMG configurations for family 8000
      iwlwifi: pcie: change CSR reset in family 8000
      iwlwifi: pcie: Disable L0S exit timer for 8000 HW family
      iwlwifi: pcie: fix secure section / dual cpu firmware loading
      iwlwifi: mvm: support multiple firmware sections
      iwlwifi: mvm: support alive notification api version2
      iwlwifi: mvm: new NVM format in family 8000
      iwlwifi: mvm: prepare infrastructure for more TLV flags

Eric Dumazet (20):
      net-sysfs: get_netdev_queue_index() cleanup
      tcp: add pacing_rate information into tcp_info
      net: add skb_mstamp infrastructure
      tcp: switch rtt estimations to usec resolution
      net_sched: htb: do not acquire qdisc lock in dump operations
      tcp: do not leak non zero tstamp in output packets
      l2tp: keep original skb ownership
      pkt_sched: fq: do not hold qdisc lock while allocating memory
      netlink: autosize skb lengthes
      l2tp: fix unused variable warning
      tcp: timestamp SYN+DATA messages
      flowcache: restore a single flow_cache kmem_cache
      pkt_sched: do not use rcu in tc_dump_qdisc()
      pkt_sched: add cond_resched() to class and qdisc dump
      netfilter: conntrack: Fix UP builds
      net: sched: use no more than one page in struct fw_head
      net: optimize csum_replace2()
      tcp: tcp_make_synack() minor changes
      net: net: add a core netdev->tx_dropped counter
      net-gro: restore frag0 optimization

Eric W Biederman (1):
      i40evf: Rename i40e_ptype_lookup i40evf_ptype_lookup

Eric W. Biederman (102):
      8139cp: Call dev_kfree_skby_any instead of kfree_skb.
      8139too: Call dev_kfree_skby_any instead of dev_kfree_skb.
      r8169: Call dev_kfree_skby_any instead of dev_kfree_skb.
      bonding: Call dev_kfree_skby_any instead of kfree_skb.
      bnx2: Call dev_kfree_skby_any instead of dev_kfree_skb.
      tg3: Call dev_kfree_skby_any instead of dev_kfree_skb.
      ixgb: Call dev_kfree_skby_any instead of dev_kfree_skb.
      mlx4: Call dev_kfree_skby_any instead of dev_kfree_skb.
      benet: Call dev_kfree_skby_any instead of kfree_skb.
      gianfar: Carefully free skbs in functions called by netpoll.
      bnx2: Don't receive packets when the napi budget == 0
      8139cp: Don't receive packets when the napi budget == 0
      bcm63xx_enet: Stop pretending to support netpoll
      net: Replace u64_stats_fetch_begin_bh to u64_stats_fetch_begin_irq
      bnx2x: Don't receive packets when the napi budget == 0
      i40e: Don't receive packets when the napi budget == 0
      igb: Don't receive packets when the napi budget == 0
      ixgbe: Don't receive packets when the napi budget == 0
      amd8111e: Don't receive packets when the napi budget == 0
      enic: Don't receive packets when the napi budget == 0
      fs_enet: Don't receive packets when the napi budget == 0
      ibmveth: Don't receive packets when the napi budget == 0
      sky2: Don't receive packets when the napi budget == 0
      mlx4: Don't receive packets when the napi budget == 0
      s2io: Don't receive packets when the napi budget == 0
      tilegx: Don't receive packets when the napi budget == 0
      tilepro: Don't receive packets when the napi budget == 0
      tc35815: Don't receive packets when the napi budget == 0
      vxge: Don't receive packets when the napi budget == 0
      sfc: Don't receive packets when the napi budget == 0
      netpoll: move setting of NETPOLL_RX_DROP into netpoll_poll_dev
      netpoll: Pass budget into poll_napi
      netpoll: Visit all napi handlers in poll_napi
      netpoll: Warn if more packets are processed than are budgeted
      netpoll: Add netpoll_rx_processing
      netpoll: Don't drop all received packets.
      netpoll: Move netpoll_trap under CONFIG_NETPOLL_TRAP
      netpoll: Consolidate neigh_tx processing in service_neigh_queue
      netpoll: Move all receive processing under CONFIG_NETPOLL_TRAP
      netpoll: Remove dead packet receive code (CONFIG_NETPOLL_TRAP)
      uml/net_kern: Call dev_consume_skb_any instead of dev_kfree_skb.
      3c509: Call dev_consume_skb_any instead of dev_kfree_skb.
      3c59x: Call dev_consume_skb_any instead of dev_kfree_skb.
      8390: Call dev_consume_skb_any instead of dev_kfree_skb.
      bfin_mac: Call dev_consume_skb_any instead of dev_kfree_skb.
      sun4i-emac: Call dev_consume_skb_any instead of dev_kfree_skb.
      am79c961a: Call dev_consume_skb_any instead of dev_kfree_skb.
      lance: Call dev_consume_skb_any instead of dev_kfree_skb.
      pcnet32: Call dev_kfree_skb_any instead of dev_kfree_skb.
      alx: Call dev_kfree_skb_any instead of dev_kfree_skb.
      atl1c: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      bnad: Call dev_kfree_skb_any instead of dev_kfree_skb.
      macb: Call dev_kfree_skb_any instead of kfree_skb.
      xgmac: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      cxgb3: Call dev_kfree/consume_skb_any instead of [dev_]kfree_skb.
      cxgb4: Call dev_kfree/consume_skb_any instead of [dev_]kfree_skb.
      cxfb4vf: Call dev_kfree/consume_skb_any instead of [dev_]kfree_skb.
      cs89x0: Call dev_consume_skb_any instead of dev_kfree_skb.
      enic: Call dev_kfree_skb_any instead of dev_kfree_skb.
      dm9000: Call dev_consume_skb_any instead of dev_kfree_skb.
      dmfe: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      uli526x: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      sundance: Call dev_kfree_skb_any instead of dev_kfree_skb.
      fec: Call dev_kfree_skb_any instead of kfree_skb.
      ucc_geth: Call dev_consume_skb_any instead of dev_kfree_skb.
      i825xx: Call dev_kfree_skb_any instead of dev_kfree_skb.
      ehea: Call dev_consume_skb_any instead of dev_kfree_skb.
      ibmveth: Call dev_consume_skb_any instead of dev_kfree_skb.
      jme: Call dev_kfree_skb_any instead of dev_kfree_skb.
      mv643xx_eth: Call dev_kfree_skb_any instead of dev_kfree_skb.
      skge: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      sky2: Call dev_kfree_skb_any instead of dev_kfree_skb.
      ksz884x: Call dev_consume_skb_any instead of dev_kfree_skb.
      s2io: Call dev_kfree_skb_any instead of dev_kfree_skb.
      vxge: Call dev_kfree_skb_any instead of dev_kfree_skb.
      forcedeth: Call dev_kfree_skb_any instead of kfree_skb.
      sc92031: Call dev_consume_skb_any instead of dev_kfree_skb.
      sis900: Call dev_kfree_skb_any instead of dev_kfree_skb.
      smc911x: Call dev_kfree_skb_any instead of dev_kfree_skb.
      smc91x: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      smsc911x: Call dev_consume_skb_any instead of dev_kfree_skb.
      stmmac: Call dev_consume_skb_any instead of dev_kfree_skb.
      sungem: Call dev_consume_skb_any instead of dev_kfree_skb.
      tilepro: Call dev_consume_skb_any instead of kfree_skb.
      spider_net: Call dev_consume_skb_any instead of dev_kfree_skb.
      via-rhine: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      via-velocity: Call dev_kfree_skb_any instead of kfree_skb.
      xilinx_emaclite: Call dev_consume_skb_any instead of dev_kfree_skb.
      vmxnet3: Call dev_kfree_skb_any instead of dev_kfree_skb.
      xen-netfront: Call dev_kfree_skb_any instead of dev_kfree_skb.
      wlags49_h2: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      staging/octeon-ethernet: Call dev_kfree/consume_skb_any instead of dev_kfree_skb.
      virtio_net: Call dev_kfree_skb_any instead of dev_kfree_skb.
      if_vlan: Call dev_kfree_skb_any instead of kfree_skb.
      netpoll: Remove gfp parameter from __netpoll_setup
      netpoll: Only call ndo_start_xmit from a single place
      netpoll: Move rx enable/disable into __dev_close_many
      netpoll: Rename netpoll_rx_enable/disable to netpoll_poll_disable/enable
      netpoll: Remove strong unnecessary assumptions about skbs
      netpoll: Respect NETIF_F_LLTX
      net: Add a test to see if a skb is freeable in irq context
      netpoll: Use skb_irq_freeable to make zap_completion_queue safe.

Erik Hugne (3):
      tipc: failed transmissions should return error
      tipc: fix neighbor detection problem after hw address change
      tipc: make discovery domain a bearer attribute

Eugenia Emantayev (4):
      net/mlx4_en: Verify mlx4_en module parameters
      net/mlx4_en: Pad ethernet packets smaller than 17 bytes
      net/mlx4_en: Move queue stopped/waked counters to be per ring
      net/mlx4: Replace mlx4_en_mac_to_u64() with mlx4_mac_to_u64()

Eyal Perry (2):
      net/mlx4_core: Fix sparse warning
      net/mlx4_en: Change Connect-X description in kconfig

Eyal Shapira (5):
      mac80211: advertise BF STS according to AP support
      iwlwifi: mvm: add Rx frames statistics via debugfs
      iwlwifi: mvm: cleanups in iwl_dbgfs_frame_stats_read
      iwlwifi: mvm: rs: fix search cycle rules
      iwlwifi: mvm: don't enable protection for all AMPDUs

Eytan Lifshitz (1):
      iwlwifi: mvm: fix possible memory leak

Fabio Estevam (4):
      net: bcmgenet: Use devm_ioremap_resource()
      smsc911x: Change clock warning message to debug level
      smsc911x: Do not use netdev_dbg() when device is not registered
      smsc911x: No need to print driver version

Fan Du (8):
      skbuff: Introduce skb_to_sgvec_nomark to map skb without mark new end
      {IPv4,xfrm} Add ESN support for AH egress part
      {IPv4,xfrm} Add ESN support for AH ingress part
      {IPv6,xfrm} Add ESN support for AH egress part
      {IPv6,xfrm} Add ESN support for AH ingress part
      xfrm: Don't prohibit AH from using ESN feature
      flowcache: Make flow cache name space aware
      flowcache: Bring net/core/flow.c under IPsec maintain scope

Fariya Fatima (1):
      rsi: Add RS9113 wireless driver

Felix Fietkau (11):
      ath9k: list more reset causes in debugfs
      ath9k: do not set half/quarter channel flags in AR_PHY_MODE
      ath9k: make some hardware reset log messages debug-only
      ath5k: set SURVEY_INFO_IN_USE on get_survey
      ath9k_hw: toggle weak signal detection in AP mode on older chipsets
      ath9k_hw: tweak noise immunity thresholds for older chipsets
      ath9k: fix ready time of the multicast buffer queue
      ath9k: clean up and enhance ANI debugfs file
      ath9k_hw: remove ANI function restrictions for AP mode
      ath9k_hw: set ANI cycpwr_thr1 as absolute values instead of relative
      ath9k_hw: set ANI firstep as absolute values instead of relative

Fengguang Wu (3):
      netfilter: ipset: Add hash: fix coccinelle warnings
      net/mlx4_en: mlx4_en_verify_params() can be static
      batman-adv: fix coccinelle warnings

Fernando Luis Vazquez Cao (1):
      igb: remove references to long gone command line parameters

Florent Fourcot (1):
      ipv6: remove some unused include in flowlabel

Florian Fainelli (53):
      net: phy: use network device in phy_print_status
      net: phy: update phy_print_status to show pause settings
      net: phy: display human readable PHY speed settings
      net: phy: add genphy_aneg_done()
      net: phy: allow driver to implement their own aneg_done
      net: phy: fix phy_{clear,config}_interrupt comment typos
      net: phy: re-design phy_modes to be self-contained
      net: phy: expose PHY device interface mode
      net: phy: add "has_fixups" boolean property
      net: phy: expose phydev->has_fixups to sysfs
      net: phy: add MoCA PHY type
      net: phy: update port type for MoCA PHYs
      net: phy: broadcom: extract register definitions
      net: phy: add Broadcom BCM7xxx internal PHY driver
      net: bcmgenet: add driver definitions and private structure
      net: bcmgenet: add main driver file
      net: bcmgenet: add MDIO routines
      net: bcmgenet: hook into the build system
      Documentation: add Device tree bindings for Broadcom GENET
      MAINTAINERS: add entry for the Broadcom GENET driver
      Documentation: broadcom-bcmgenet: add better clocks documentation
      net: phy: move PHY software reset to genphy_soft_reset
      net: phy: allow PHY drivers to implement their own software reset
      Documentation: networking: update phy.txt with recent changes
      Documentation: broadcom-bcmgenet: fix address and cells properties
      net: bcmgenet: drop checks on priv->phydev
      net: bcmgenet: remove commented code in bcmgenet_xmit()
      net: bcmgenet: remove unused bh_lock member
      ixgbevf: fix skb->pkt_type checks
      net: bcmgenet: remove unused spinlock member
      net: bcmgenet: add skb_tx_timestamp call
      net: bcmgenet: remove bogus tx queue checks
      net: bcmgenet: manipulate netdev_queue directly
      net: phy: bcm7xxx: define constants for our registers
      net: phy: bcm7xxx: fix spurious MDIO failures during workaround
      net: phy: bcm7xxx: properly clear AFE_RX_LP_COUNTER
      net: bcmgenet: set RBUF_SKIP_FCS based on UniMAC CRC forwarding
      net: greth: remove empty MDIO bus reset function
      tg3: remove empty MDIO bus reset function
      macb: remove empty MDIO bus reset function
      dnet: remove empty MDIO bus reset function
      net: ethoc: remove empty MDIO bus function
      fec: remove empty MDIO bus function
      fs_enet: remove empty MDIO bus function
      net: mvmdio: remove empty MDIO bus reset function
      net: emaclite: remove empty MDIO bus reset function
      net: sun4i: remove empty MDIO bus reset function
      net: ftgmac100: remove empty MDIO bus reset function
      r6040: remove empty MDIO bus reset function
      bfin_mac: remove empty MDIO bus reset function
      Documentation: networking: phy.txt: MDIO bus reset is optional
      net: sysfs: add Documentation entries for basic set of attributes
      net: export NET_ADDR_* values to user-space API

Florian Vaussard (5):
      can: sja1000: convert printk to use netdev API
      can: sja1000: platform: use devm_* APIs
      can: sja1000: fuse of_platform into platform
      Documentation: devicetree: sja1000: add reg-io-width binding
      can: sja1000: of: add reg-io-width property for 8, 16 and 32-bit register access

Florian Westphal (14):
      ip_tunnel: return more precise errno value when adding tunnel fails
      netfilter: nft_ct: labels get support
      tcp: use zero-window when free_space is low
      netfilter: nfnetlink_log: remove unused code
      net: tcp: add mib counters to track zero window transitions
      netfilter: ipset: kernel: uapi: fix MARKMASK attr ABI breakage
      netfilter: connlimit: factor hlist search into new function
      netfilter: connlimit: improve packet-to-closed-connection logic
      netfilter: connlimit: move insertion of new element out of count function
      netfilter: connlimit: use kmem_cache for conn objects
      6lowpan: reassembly: un-export local functions
      netfilter: connlimit: use keyed locks
      netfilter: connlimit: make same_source_net signed
      netfilter: connlimit: use rbtree for per-host conntrack obj storage

Franky Lin (2):
      brcmfmac: add owner info to sdio_driver structure
      brcmfmac: add BCM4354 SDIO interface support

Fujinaka, Todd (1):
      igb: add register rd/wr for surprise removal

Geert Uytterhoeven (1):
      ath9k: Fix uninitialized variable in ath9k_has_tx_pending()

Girish K S (1):
      net: sxgbe: add EEE(Energy Efficient Ethernet) for Samsung sxgbe

Greg Rose (2):
      i40evf: Enable the ndo_set_features netdev op
      i40e: Make the alloc and free queue vector calls orthogonal

Gu Zheng (1):
      net: add a pre-check of net_ns in sk_change_net()

Gustavo Padovan (1):
      Bluetooth: Fix skb allocation check for A2MP

Haiyang Zhang (2):
      hyperv: Add latest NetVSP versions to auto negotiation
      hyperv: Change the receive buffer size for legacy hosts

Hannes Frederic Sowa (7):
      ipv6: honor IPV6_PKTINFO with v4 mapped addresses on sendmsg
      ipv4: use ip_skb_dst_mtu to determine mtu in ip_fragment
      ipv4: yet another new IP_MTU_DISCOVER option IP_PMTUDISC_OMIT
      ipv6: yet another new IPV6_MTU_DISCOVER option IPV6_PMTUDISC_OMIT
      inet: remove now unused flag DST_NOPEER
      ipv6: strengthen fallback fragmentation id generation
      ipv6: some ipv6 statistic counters failed to disable bh

Hante Meuleman (15):
      brcmfmac: expand sta info to report dtim and beacon period.
      brcmfmac: fix sdio sending of large buffers.
      brcmfmac: simplify sdio code download routine.
      brcmfmac: on sdio remove first detach bus then stop worker.
      brcmfmac: Make firmeware roaming a module param.
      brcmfmac: Correct header debug dump for sdio tx hdrs.
      brcmfmac: de-init driver layers in correct order.
      brcmfmac: Minimize SDIO dpc scheduling.
      brcmfmac: Remove immediate sleep support from SDIO.
      brcmfmac: Small cleanup of redundant code.
      brcmfmac: Use atomic functions for intstatus update.
      brcmfmac: Put frame sdio tx error handling in sub function.
      brcmfmac: Use atomic functions for intstatus update.
      brcmfmac: Protect tx seq number for data and control
      brcmfmac: Improve scanning settings for connect.

Hariprasad Shenai (3):
      cxgb4: Add more PCI device ids.
      cxgb4: Adds device ID for few more Chelsio Adapters
      cxgb4vf: Adds device Id for few more Chelsio adapters

Harish Patil (1):
      qlcnic: Enhance semaphore lock access failure error message

Heiko Carstens (1):
      qeth: make qeth_query_card_info_cb() static

Heinrich Schuchardt (1):
      rtlwifi: Remove redundant if clause

Hiroaki SHIMODA (1):
      sch_tbf: Remove holes in struct tbf_sched_data.

Horia Geanta (1):
      xfrm: avoid creating temporary SA when there are no listeners

Ido Shamay (2):
      net/mlx4: Set number of RX rings in a utility function
      net/mlx4: Fix limiting number of IRQ's instead of RSS queues

Ido Yariv (3):
      iwlwifi: pcie: retrieve and parse ACPI power limitations
      iwlwifi: mvm: handle platform PCIe power limitation
      iwlwifi: 7265: add power limit/tx backoff translation table

Igal Chernobelsky (1):
      wlcore: send EAPOL frames with voice priority

Ilan Peer (6):
      iwlwifi: mvm: add the quota remainder to a data binding
      iwlwifi: mvm: fix quota allocation
      cfg80211: fix few minor issues in reg_process_hint()
      mac80211: Fix ROC duration == 0 handling
      iwlwifi: mvm: modify the tsf_id master/slave logic
      cfg80211: send stop AP event only due to internal reason

Ilia Mirkin (1):
      netfilter: ipset: move registration message to init from net_init

Inbal Hacohen (1):
      iwlwifi: mvm: remove redundant define in fw.c

Ivan Vecera (1):
      be2net: do external loopback test only when it is requested

Ivaylo Dimitrov (1):
      wl1251: use skb_trim to make skb shorter

Jack Morgenstein (6):
      mlx4: Adjust QP1 multiplexing for RoCE/SRIOV
      mlx4_core: For RoCE, allow slaves to set the GID entry at that slave's index
      mlx4: In RoCE allow guests to have multiple GIDS
      mlx4: Add ref counting to port MAC table for RoCE
      mlx4: Implement IP based gids support for RoCE/SRIOV
      mlx4: Activate RoCE/SRIOV

Jacob Keller (14):
      ixgbe: don't use magic size number to assign ptp_caps.name
      ixgbe: implement SIOCGHWTSTAMP ioctl
      ixgbe: move setting rx_pb_size into get_invariants
      ixgbe: add Linux NICS mailing list to contact info
      ixgbe: fixup header for ixgbe_set_rxpba_82598
      ixgbe: fix some multiline hw_dbg prints
      ixgbe: add ixgbe_write_pci_cfg_word with ixgbe_removed check
      ixgbe: check Core Clock Disable bit
      ixgbe: fix ixgbe_stop_mac_link_on_d3_82599 to check mng correctly
      ixgbe: fix ixgbe_setup_mac_link_82599 autoc variables
      ixgbe: remove unused media type
      ixgbe: use ixgbe_read_pci_cfg_word
      ixgbe: clean up ixgbe_atr_compute_perfect_hash_82599
      igb: implement SIOCGHWTSTAMP ioctl

Jakub Kicinski (8):
      doc: update driver TX algorithm in timestamping.txt
      e1000e: add timeout for TX HW time stamping work
      e1000e: remove redundant if clause from PTP work
      igb: never generate both software and hardware timestamps
      igb: fix race conditions on queuing skb for HW time stamp
      ixgbe: remove redundant if clause from PTP work
      ixgbe: never generate both software and hardware timestamps
      ixgbe: fix race conditions on queuing skb for HW time stamp

Jan Beulich (1):
      consolidate duplicate code is skb_checksum_setup() helpers

Janusz Dziedzic (14):
      ath10k: enable wmi ps peer param command for 10.x FW
      ath10k: AP mode, set UAPSD params correctly
      nl80211: add Guard Interval support for set_bitrate_mask
      cfg80211: set preset_chandef after channel switch
      cfg80211: add helper reg_get_regdomain() function
      cfg80211: regulatory introduce maximum bandwidth calculation
      ath10k: pass frames with invalid peer status to upper layer
      cfg80211: regulatory: introduce NL80211_RRF_AUTO_BW rule flag
      cfg80211: regulatory: allow user to set world regdomain
      cfg80211: regulatory: allow getting DFS CAC time from userspace
      cfg80211: DFS get CAC time from regulatory database
      ath10k: enable spectrum management support
      ath10k: bitrate_mask add force_sgi support
      ath10k: skip management frames in HTT path

Jason Gunthorpe (2):
      dt: Document a compatible entry for MDIO ethernet Phys
      of_mdio: Allow the DT to specify the phy ID and avoid autoprobing

Jean Delvare (1):
      brcmfmac: Make probe function __init

Jean Sacren (5):
      ieee802154: fix new function declaration
      ieee802154: fix at86rf212_set_txpower() exit path
      ixgbe: fix ixgbe_check_reset_blocked() declaration
      i40e: fix function kernel doc description
      i40e/i40evf: fix error checking path

Jeff Kirsher (3):
      igb: make local functions static and remove dead code
      igb: fix warning if !CONFIG_IGB_HWMON
      igb: Fix code comment

Jesper Dangaard Brouer (5):
      netfilter: trivial code cleanup and doc changes
      netfilter: conntrack: spinlock per cpu to protect special lists.
      netfilter: avoid race with exp->master ct
      netfilter: conntrack: seperate expect locking from nf_conntrack_lock
      netfilter: conntrack: remove central spinlock nf_conntrack_lock

Jesse Brandeburg (13):
      i40e: spelling error
      i40e: bump driver version
      i40evf: trivial fixes
      i40e/i40evf: i40e implementation for skb_set_hash
      i40e: count timeout events
      i40e: fix nvm version and remove firmware report
      i40e/i40evf: carefully fill tx ring
      i40e: make string references to q be queue
      i40e: cleanup strings
      i40e: simplified init string
      i40e/i40evf: enable hardware feature head write back
      i40e/i40evf: reduce context descriptors
      i40evf: remove double space after return

Jingoo Han (2):
      net: w5300: Use devm_ioremap_resource()
      net: w5100: Use devm_ioremap_resource()

Jiri Pirko (1):
      rtnl: make ifla_policy static

Jitendra Kalsaria (1):
      qlcnic: Updates to QLogic application/driver interface for virtual NIC configuration

Joe Perches (38):
      bonding: Convert pr_warning to pr_warn, neatening
      bonding: Neaten pr_<level>
      bonding: Convert c99 comments
      bonding: Convert memcpy(foo, bar, ETH_ALEN) to ether_addr_copy(foo, bar)
      hsr: Use ether_addr_copy
      bonding: More use of ether_addr_copy
      bonding: Remove unnecessary else
      bonding: Invert test
      ath9k: Use static const
      bridge: Use ether_addr_copy and ETH_ALEN
      bridge: netfilter: Use ether_addr_copy
      bnx2x: Remove hidden flow control goto from BNX2X_ALLOC macros
      Bluetooth: Convert uses of __constant_<foo> to <foo>
      8021q: Convert uses of __constant_<foo> to <foo>
      net: Convert uses of __constant_<foo> to <foo>
      ieee802154: Convert uses of __constant_<foo> to <foo>
      tipc: Convert uses of __constant_<foo> to <foo>
      brocade: Convert uses of __constant_<foo> to <foo>
      xilinx: Convert uses of __constant_<foo> to <foo>
      lg-vl600: Convert uses of __constant_<foo> to <foo>
      netfilter: Convert uses of __constant_<foo> to <foo>
      ath9k: Convert uses of __constant_<foo> to <foo>
      rsi: Add pr_fmt,__printf, fix format & arg mismatch
      e100: Convert uses of __constant_<foo> to <foo>
      igb: Convert uses of __constant_<foo> to <foo>
      igbvf: Convert uses of __constant_<foo> to <foo>
      ixgbe: Convert uses of __constant_<foo> to <foo>
      ixgbevf: Convert uses of __constant_<foo> to <foo>
      chelsio: Remove addressof casts to same type
      altera: Remove casts of pointer to same type
      alx: Remove casts of pointer to same type
      qlcnic: Remove casts of pointer to same type
      rtlwifi: Remove addressof casts to same type
      carl9170: Remove casts of pointer to same type
      mwifiex: Remove casts of pointer to same type
      rtlwifi: Remove casts of pointer to same type
      i40e/i40evf: Remove addressof casts to same type
      i40e: Remove casts of pointer to same type

Johan Hedberg (120):
      Bluetooth: Fix outgoing authentication requirement check
      Bluetooth: Fix mgmt error code for negative PIN response
      Bluetooth: Reorder L2CAP functions to avoid forward declarations
      Bluetooth: Queue incoming ACL data until BT_CONNECTED state is reached
      Bluetooth: Remove useless l2cap_seq_list_remove function
      Bluetooth: Rename L2CAP_CHAN_CONN_FIX_A2MP to L2CAP_CHAN_FIXED
      Bluetooth: Switch ATT channels to use L2CAP_CHAN_FIXED
      Bluetooth: Fix BT_SECURITY socket option for fixed channels (ATT)
      Bluetooth: Fix CID initialization for fixed channels
      Bluetooth: Fix respecting le_default_mps value
      Bluetooth: Fix disconnecting L2CAP channel for credits violation
      Bluetooth: Fix disconnecting L2CAP when a credits overflow occurs
      Bluetooth: Free up l2cap_chan->sport when initiating a connection
      Bluetooth: Refuse peer L2CAP address reading when not connected
      Bluetooth: Refuse peer RFCOMM address reading when not connected
      Bluetooth: Always use l2cap_chan->psm for returning PSM to user space
      Bluetooth: Remove unnecessary check for chan->psm
      Bluetooth: Enable LTK distribution to slave devices
      Bluetooth: Remove Simultaneous LE & BR/EDR flags from AD
      Bluetooth: Fix long_term_keys debugfs output
      Bluetooth: Make LTK key type check more readable
      Bluetooth: Remove unnecessary LTK type check from hci_add_ltk
      Bluetooth: Fix differentiating stored master vs slave LTK types
      Bluetooth: Enable LE L2CAP CoC support by default
      Bluetooth: Fix missing PDU length checks for SMP
      Bluetooth: Fix minor whitespace issues in SMP code
      Bluetooth: Add smp_irk_matches helper function
      Bluetooth: Add AES crypto context for each HCI device
      Bluetooth: Add basic IRK management support
      Bluetooth: Add hci_bdaddr_is_rpa convenience function
      Bluetooth: Implement mgmt_load_irks command
      Bluetooth: Enable support for remote IRK distribution
      Bluetooth: Fix properly ignoring unexpected SMP PDUs
      Bluetooth: Fix missing address type check for removing LTKs
      Bluetooth: Remove return values from functions that don't need them
      Bluetooth: Fix hci_remove_ltk failure when no match is found
      Bluetooth: Fix completing SMP as peripheral when no keys are expected
      Bluetooth: Fix removing any IRKs when unpairing devices
      Bluetooth: Add convenience function for fetching IRKs
      Bluetooth: Remove SMP data specific crypto context
      Bluetooth: Track the LE Identity Address in struct hci_conn
      Bluetooth: Fix updating Identity Address in L2CAP channels
      Bluetooth: Wait for SMP key distribution completion when pairing
      Bluetooth: Don't try to look up private addresses as Identity Address
      Bluetooth: Look up RPA for connection requests with Identity Address
      Bluetooth: Use Identity Address in Device Found event
      Bluetooth: Avoid using GFP_ATOMIC where not necessary
      Bluetooth: Return added key when adding LTKs and IRKs
      Bluetooth: Move New LTK store hint evaluation into mgmt_new_ltk
      Bluetooth: Track SMP keys in the SMP context
      Bluetooth: Move SMP LTK notification after key distribution
      Bluetooth: Add support for sending New IRK event
      Bluetooth: Fix iterating wrong list in hci_remove_irk()
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
      Bluetooth: Fix expected key count debug logs
      Bluetooth: Fix updating SMP remote key distribution information
      Bluetooth: Fix const declaration for swap function src parameter
      Bluetooth: Fix smp_e byte order to be consistent with SMP specification
      Bluetooth: Fix MITM flag when initiating SMP pairing
      Bluetooth: Simplify logic when checking SMP_FLAG_TK_VALID
      Bluetooth: Increase SMP re-encryption delay to 500ms
      Bluetooth: Fix SMP user passkey notification mgmt event
      Bluetooth: Fix Pair Device response parameters for pairing failure
      Bluetooth: Fix passkey endianess in user_confirm and notify_passkey
      Bluetooth: Fix address value for early disconnection events
      Bluetooth: Fix potential NULL pointer dereference in SMP
      Bluetooth: Add missing cmd_status handler for LE_Start_Encryption
      Bluetooth: Fix SMP confirmation callback handling
      Bluetooth: Add SMP flag to track which side is the initiator
      Bluetooth: Don't try to confirm locally initiated SMP pairing
      Bluetooth: Remove LTK re-encryption procedure
      Bluetooth: Fix potential NULL pointer dereference in smp_conn_security
      Bluetooth: Remove unnecessary assignment in SMP
      Bluetooth: Fix returning peer address in pending connect state

Johannes Berg (57):
      iwlwifi: mvm: implement AP/GO uAPSD support
      iwlwifi: pcie: make FH debugfs file code easier to understand
      iwlwifi: mvm: add low-latency framework
      iwlwifi: mvm: disable powersave in low-latency
      iwlwifi: mvm: reserve bandwidth for low-latency interface
      iwlwifi: mvm: limit non-low-latency binding scheduling duration
      iwlwifi: rs: use const u16 for throughput tables
      iwlwifi: mvm: remove unneeded calculations
      iwlwifi: mvm: abort scheduled scan on scan request
      iwlwifi: mvm: clean up iwl_mvm_bss_info_changed_ap_ibss
      cfg80211: make connect ie param const
      nl80211: check channel switch validity better
      mac80211: mesh: remove mesh_id check
      mac80211: use sdata mesh_id_len instead of wdev's
      mac80211: fix agg_status debugfs file write
      mac80211: make rate control ops const
      mac80211: make cfg80211 ops and privid const
      nl80211: make netlink attribute policies const
      cfg80211: make device_type const
      mac80211_hwsim: make netlink policy const
      mac80211: minstrel_ht: sample_table can be __read_mostly
      mac80211: remove module handling from rate control ops
      mac80211_hwsim: make P2P-Device support optional
      nl80211: check nla_parse() return values
      mac80211: add length check in ieee80211_is_robust_mgmt_frame()
      nl80211: send event when AP operation is stopped
      nl80211: fix scheduled scan RSSI matchset attribute confusion
      mac80211: remove set but unused variables
      mac80211: fix bufferable MMPDU RX handling
      wireless: sort and extend element ID list
      mac80211: order IEs in probe request correctly
      mac80211: order IEs in association request correctly
      mac80211: remove superfluous band variable
      mac80211_hwsim: fix number of channels in interface combinations
      mac80211: simplify roc check in idle calculation
      cfg80211: remove NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL
      nl80211: use ie_len in scheduled scan
      mac80211: add NAPI support back
      iwlwifi: make various things const
      iwlwifi: mvm: use IEEE80211_TX_CTRL_PORT_CTRL_PROTO flag
      iwlwifi: remove iwl_fw_valid_(tx|rx)_ant inlines
      mac80211: remove erroneous comment about RX radiotap header
      Merge remote-tracking branch 'wireless-next/master' into mac80211-next
      cfg80211: document sched_scan_stop synchronous behaviour
      mac80211: allow driver to return error from sched_scan_stop
      iwlwifi: nvm: remove reading valid antennas from NVM
      cfg80211: regulatory: simplify uevent sending
      iwlwifi: mvm: init drv_stats_lock
      iwlwifi: pcie: suppress ACPI related error message
      iwlwifi: nvm: fix VHT capability antenna-dependent fields
      iwlwifi: return whether to stop from rfkill method
      iwlwifi: mvm: remove using max_duration in firmware API
      iwlwifi: mvm: remove spurious blank line
      iwlwifi: mvm: ignore unchanged low-latency flag
      mac80211: fix potential use-after-free
      mac80211: verify deauthentication and return error on failure
      mac80211: fix suspend vs. authentication race

John Greene (1):
      ath5k: add missing dma_map_error call

John W. Linville (26):
      Merge git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Revert "Staging: rtl8812ae: remove modules field of rate_control_ops"
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Revert "Revert "Staging: rtl8812ae: remove modules field of rate_control_ops""
      rtl8821ae: fixup staging driver for revised ieee80211_is_robust_mgmt_frame
      wlan-ng: fixup staging driver for removal of ieee80211_dsss_chan_to_freq
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge tag 'nfc-next-3.15-1' of git://git.kernel.org/.../sameo/nfc-next
      rsi: make rsi_dbg a regular function
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jon Paul Maloy (18):
      tipc: stricter behavior of message reassembly function
      tipc: change reception of tunnelled duplicate packets
      tipc: change reception of tunnelled failover packets
      tipc: change signature of tunnelling reception function
      tipc: more cleanup of tunnelling reception function
      tipc: rename stack variables in function tipc_link_tunnel_rcv
      tipc: changes to general packet reception algorithm
      tipc: delay delete of link when failover is needed
      tipc: add node_lock protection to link lookup function
      tipc: fix a loop style problem
      tipc: correct usage of spin_lock() vs spin_lock_bh()
      tipc: replace reference table rwlock with spinlock
      tipc: remove redundant 'peer_name' field in struct tipc_sock
      tipc: aggregate port structure into socket structure
      tipc: eliminate upcall function pointers between port and socket
      tipc: eliminate redundant locking
      tipc: align usage of variable names and macros in socket
      tipc: eliminate redundant lookups in registry

Joseph Gasparakis (1):
      i40e: Flow Director sideband accounting

Josh Hunt (1):
      netfilter: ipset: add forceadd kernel support for hash set types

Jouni Malinen (4):
      cfg80211: Allow BSS hint to be provided for connect
      cfg80211: Advertise maximum associated STAs in AP mode
      cfg80211: Clean up connect params and channel fetching
      ath9k: Enable U-APSD AP mode support

Jozsef Kadlecsik (1):
      netfilter: ipset: Prepare the kernel for create option flags when no extension is needed

Julia Lawall (6):
      caif: delete unnecessary field initialization
      ixgbevf: delete unneeded call to pci_set_power_state
      isdn: replace del_timer by del_timer_sync
      atm: replace del_timer by del_timer_sync
      hsr: replace del_timer by del_timer_sync
      yam: replace del_timer by del_timer_sync

Julien Massot (2):
      ath6kl: increase usb rx buffer size to 4096
      ath6kl: set rx urb count threshold to 1

Jurgen Kramer (1):
      Bluetooth: btusb: Add IMC Networks (Broadcom based)

Justin van Wijngaarden (1):
      Drivers: net: ethernet: 3com: 3c589_cs fixed coding style issues

KY Srinivasan (9):
      Drivers: net: hyperv: Get rid of the rndis_filter_packet structure
      Drivers: net: hyperv: Cleanup the receive path
      Drivers: net: hyperv: Cleanup the netvsc receive callback functio
      Drivers: net: hyperv: Enable scatter gather I/O
      Drivers: net: hyperv: Cleanup the send path
      Drivers: net: hyperv: Enable offloads on the host
      Drivers: net: hyperv: Enable receive side IP checksum offload
      Drivers: net: hyperv: Enable send side checksum offload
      Drivers: net: hyperv: Enable large send offload

Kalle Valo (5):
      ath10k: enable firmware STA quick kickout
      Merge remote-tracking branch 'wireless-next/master' into ath-next
      ath10k: fix alignment in ath10k_dbg()
      ath: remove camel case from struct reg_dmn_pair_mapping
      ath10k: release conf_mutex if vdev_start() fails

Karl Beldan (1):
      mac80211: send {ADD,DEL}BA on AC_VO like other mgmt frames, as per spec

Ken ICHIKAWA (1):
      igb: specify phc_index of 82575 for get_ts_info

Kevin Hao (1):
      e1000e: fix the build error when PM is disabled

Kleber Sacilotto de Souza (1):
      IB/mlx5_core: remove unreachable function call in module init

Kumar Sanghvi (12):
      cxgb4: Add support to recognize 40G links
      cxgb4: Print adapter VPD Part Number instead of Engineering Change field
      cxgb4: Allow >10G ports to have multiple queues
      cxgb4: LE-Workaround is not atomic in firmware
      cxgb4: Query firmware for T5 ULPTX MEMWRITE DSGL capabilities
      cxgb4: Remove unused registers and add missing ones
      cxgb4: Don't assume LSO only uses SGL path in t4_eth_xmit()
      cxgb4: Fix some small bugs in t4_sge_init_soft() when our Page Size is 64KB
      cxgb4: Add code to dump SGE registers when hitting idma hangs
      cxgb4: Rectify emitting messages about SGE Ingress DMA channels being potentially stuck
      cxgb4: Updates for T5 SGE's Egress Congestion Threshold
      cxgb4: Calculate len properly for LSO path

Larry Finger (17):
      rtlwifi: btcoexist: Add new mini driver
      rtlwifi: Prepare existing drivers for new driver
      rtlwifi: rtl8723ae: rtl8723-common: Create new driver for common code
      rtlwifi: rtl8723ae: rtl8723-common: Copy common firmware code
      rtlwifi: rtl8723ae: rtl8723-common: Copy common dynamic power management code
      rtlwifi: rtl8723be: Add new driver
      rtlwifi: rtl8192ce: rtl8192cu: rtl8192de: rtl8192se: rtl8723ae: rtl8723be: rtl8188eu: Modify for new API
      rtlwifi: Move common routines to core
      rtlwifi: rtl8723be: rtl8723com: Remove unused allow_all_destaddr functions
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix too long disable of IRQs
      rtlwifi: rtl8188ee: Fix too long disable of IRQs
      rtlwifi: rtl8723ae: Fix too long disable of IRQs
      rtlwifi: rtl8192ce: Handle unused switch case
      rtlwifi: rtl8723be: Fix sparse errors
      rtlwifi: rtl8723be: Fix smatch warnings
      rtlwifi: rtl8723be: Fix array dimension problems

Laurence Evans (1):
      sfc: Removed adhoc scheme to rate limit PTP event queue overflow message

Laurent Pinchart (5):
      sh_eth: Use the platform device for memory allocation
      sh_eth: Use the platform device as the MDIO bus parent
      sh_eth: Simplify MDIO bus initialization and release
      sh_eth: Register MDIO bus before registering the network device
      sh_eth: Remove goto statements that jump straight to a return

Li RongQing (3):
      ipv6: ip6_forward: perform skb->pkt_type check at the beginning
      ipv4: remove ipv4_ifdown_dst from route.c
      ipv4: remove ip_rt_dump from route.c

Liad Kaufman (1):
      iwlwifi: fix potential buffer overrun in fw name

Linus L√ºssing (8):
      batman-adv: use vlan_/eth_hdr() instead of skb->data in interface_tx path
      batman-adv: remove obsolete skb_reset_mac_header() in batadv_bla_tx()
      batman-adv: Multicast Listener Announcements via Translation Table
      batman-adv: introduce capability initialization bitfield
      batman-adv: Announce new capability via multicast TVLV
      batman-adv: Modified forwarding behaviour for multicast packets
      batman-adv: Add IPv4 link-local/IPv6-ll-all-nodes multicast support
      batman-adv: Send multicast packets to nodes with a WANT_ALL flag

Lucas De Marchi (1):
      Bluetooth: allocate static minor for vhci

Lucas Stach (1):
      net: fec: make sure to init MAC address

Luciano Coelho (12):
      mac80211: refactor ieee80211_mesh_process_chanswitch()
      mac80211: align ieee80211_mesh_csa_beacon() with ieee80211_assign_beacon()
      mac80211: only set CSA beacon when at least one beacon must be transmitted
      mac80211: ibss: remove unnecessary call to release channel
      mac80211_hwsim: allow creation of single-channel radios with chanctx
      cfg80211: docbook: fix small formatting error
      cfg80211: docbook: add interface combinations documentation
      mac80211: allow drivers to request SMPS off
      nl80211: make sure we check for DFS with mesh channel switch
      cfg80211: remove radar requirements check from cfg80211_can_use_iftype_chan()
      mac80211: ibss: handle cfg80211_chandef_dfs_required() error codes
      wl1251: split wl251 platform data to a separate structure

Luis R. Rodriguez (3):
      net: kdoc struct net_device flags and priv_flags
      net: move net_device priv_flags out from UAPI
      cfg80211: allow reprocessing of pending requests

Lukasz Rymanowski (1):
      Bluetooth: Fix response on confirm_name

Maithili Hinge (1):
      mwifiex: update MCS set as per RX-STBC bit from hostapd

Manfred Rudigier (1):
      ptp: Add a command line option in testptp to set a specific PTP time

Marc Kleine-Budde (5):
      can: flexcan: Remove #ifdef CONFIG_PM_SLEEP
      can: flexcan: make use of platform_get_device_id()
      can: janz-ican3: convert dev_<level> printing to netdev_<level>
      can: c_can: free_c_can_dev(): add missing netif_napi_del()
      can: c_can: check return value to users of c_can_set_bittiming()

Marcel Holtmann (64):
      Bluetooth: Add LMP feature definitions for Secure Connections support
      Bluetooth: Add HCI command definition for Secure Connections enabling
      Bluetooth: Add HCI command definition for extended OOB data
      Bluetooth: Add definitions for new link key types
      Bluetooth: Add support for handling P-256 derived link keys
      Bluetooth: Enable Authenticated Payload Timeout Expired event
      Bluetooth: Add flags and setting for Secure Connections support
      Bluetooth: Add management command for enabling Secure Connections
      Bluetooth: Enable Secure Connection during power on if configured
      Bluetooth: Limit acceptable link key types to only supported ones
      Bluetooth: Add support for local OOB data with Secure Connections
      Bluetooth: Add debugfs quirk for forcing Secure Connections support
      Bluetooth: Provide remote OOB data for Secure Connections
      Bluetooth: Add internal function for storing P-192 and P-256 data
      Bluetooth: Add support for remote OOB input of P-256 data
      Bluetooth: Track Secure Connections support of remote devices
      Bluetooth: Introduce requirements for security level 4
      Bluetooth: Handle security level 4 for L2CAP connections
      Bluetooth: Handle security level 4 for RFCOMM connections
      Bluetooth: Add debugfs entry to show Secure Connections Only mode
      Bluetooth: Increment management interface revision
      Bluetooth: Add management setting for use of debug keys
      Bluetooth: Add management command to allow use of debug keys
      Bluetooth: Remove use_debug_keys debugfs entry
      Bluetooth: Remove one level of indentation from hci_encrypt_change_evt
      Bluetooth: Track the AES-CCM encryption status of LE and BR/EDR links
      Bluetooth: Remove check for valid LTK authenticated parameter
      Bluetooth: Rename authentication to key_type in mgmt_ltk_info
      Bluetooth: Remove __packed from struct smp_ltk
      Bluetooth: Add management command for Secure Connection Only Mode
      Bluetooth: Include security level 4 in connections check
      Bluetooth: Track if link is using P-256 authenticated combination key
      Bluetooth: Add constants for LTK key types
      Bluetooth: Restrict long term keys to public and static addresses
      Bluetooth: Fix sending wrong store hint for new long term keys
      Bluetooth: Add missing index added event on user channel failure
      Bluetooth: Allow HCI User Channel usage for controllers without address
      Bluetooth: Report identity address when remote device connects
      Bluetooth: Use connection address for reporting connection failures
      Bluetooth: Fix wrong identity address during connection failures
      Bluetooth: Expose current list of identity resolving keys via debugfs
      Bluetooth: Use same LE min/max connection event length during update
      Bluetooth: Don't send store hint for devices using identity addresses
      Bluetooth: Add comment explainging store hint for long term keys
      Bluetooth: Replace own_address_type with force_static_address debugfs
      Bluetooth: Track the current configured random address
      Bluetooth: Provide option for changing LE advertising channel map
      Bluetooth: Increase minor version of core module
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
      Bluetooth: Add support for handling signature resolving keys
      Bluetooth: Make LTK and CSRK only persisent when bonding
      Bluetooth: Enforce strict Secure Connections Only mode security
      Bluetooth: Track current configured LE scan type parameter

Marek Kwaczynski (2):
      mac80211: update opmode when adding new station
      ath10k: Set proper nss value for the peer

Marek Lindner (1):
      batman-adv: call unregister_netdev() to have it handle the locking for us

Marek Puzyniak (4):
      ath10k: configure access category for arp
      ath10k: refactor suspend/resume functions
      ath10k: suspend hardware before reset
      ath10k: do not overwrite max_antenna_gain

Mark A. Greer (8):
      NFC: Add ISO/IEC 15693 header definitions
      NFC: digital: Add Digital Layer support for ISO/IEC 15693
      NFC: Add netlink support for ISO/IEC 15693
      NFC: digital: Rename Type V tags to Type 5 tags
      NFC: trf7970a: Add driver with ISO/IEC 14443 Type 2 Tag Support
      NFC: trf7970a: Add support for Type 4A Tags
      NFC: trf7970a: Add ISO/IEC 15693 and Type 5 tag Support
      NFC: trf7970a: Add DTS Documentation

Mark Rustad (15):
      ixgbe: Add WoL support for a new device
      ixgbe: Restore hw_addr in LER recovery paths
      ixgbe: Fix up some ethtool results when adapter is removed
      ixgbe: Check config reads for removal
      ixgbevf: Indicate removal state explicitly
      ixgbevf: Protect ixgbevf_down with __IXGBEVF_DOWN bit
      ixgbe: Break recursion in case of removal
      ixgbevf: Use static inlines instead of macros
      ixgbevf: Make the ethtool register test use accessors
      ixgbevf: Check register reads for adapter removal
      ixgbevf: Check for adapter removal on register writes
      ixgbevf: Additional adapter removal checks
      ixgbevf: Change ixgbe_read_reg to ixgbevf_read_reg
      ixgbe: Fix rcu warnings induced by LER
      ixgbevf: Fix rcu warnings induced by LER

Masaki TAGAWA (1):
      ath9k_htc: Add device ID for Buffalo WLI-UV-AG300P

Masanari Iida (1):
      ixgbe: Fix format string in ixgbe_fcoe.c

Matan Barak (6):
      IB/mlx4_ib: Adapt code to use caps.num_ports instead of a constant
      net/mlx4: Add data structures to support N-Ports per VF
      net/mlx4: Add utils for N-Port VFs
      net/mlx4: Adapt code for N-Port VF
      net/mlx4: Adapt num_vfs/probed_vf params for single port VF
      mlx4: Use actual number of PCI functions (PF + VFs) for alias GUID logic

Mathias Krause (3):
      pktgen: fix out-of-bounds access in pgctrl_write()
      pktgen: simplify error handling in pgctrl_write()
      pktgen: document all supported flags

Michael Braun (1):
      mac80211: fix WPA with VLAN on AP side with ps-sta again

Michael Knudsen (1):
      Bluetooth: Stop BCSP/H5 timer before cleaning up

Michal Kalderon (1):
      bnx2x: Add support in PF driver for RSC

Michal Kazior (25):
      ath10k: implement channel switching
      ath10k: implement AP CSA
      ath10k: implement and use new beacon method
      ath10k: properly return err from start()
      mac80211: batch CSA bss info notification
      mac80211: fix possible memory leak on AP CSA failure
      mac80211: move csa_active setting in STA CSA
      mac80211: fix sdata->radar_required locking
      mac80211: add missing CSA locking
      cfg80211: consider existing DFS interfaces
      ath9k: prepare for multi-interface CSA support
      ath10k: fix device initialization routine
      ath10k: fix SMPS support
      ath10k: implement sta_rc_update()
      ath10k: fix 4addr rx
      ath10k: fix sta_rc_update for non-ap iftype
      ath10k: remove DMA mapping wrappers
      ath10k: remove is_aborted from skb_cb
      ath10k: replace send_head() with tx_sg()
      ath10k: bypass htc for htt tx path
      ath10k: batch htt tx/rx completions
      ath10k: reduce htt tx/rx spinlock overhead
      ath10k: remove pci completion list
      ath10k: minimize coherent dma accesses
      mac80211: refactor channel switch function

Michal Kubeƒçek (1):
      ipv6: do not overwrite inetpeer metrics prematurely

Michal Schmidt (3):
      bnx2x: clamp num_queues to prevent passing a negative value
      bnx2x: save RAM in kdump kernel by using a single queue
      bnx2x: save RAM in kdump kernel by disabling TPA

Mitch A Williams (1):
      i40evf: remove errant space

Mitch Williams (30):
      i40evf: clean up memsets
      i40e: remove dead code
      i40e: set VF state to active when reset is complete
      i40e: reset VFs after PF reset
      i40e: enable extant VFs
      i40e: don't handle VF reset on unload
      i40evf: clean up adapter struct
      i40evf: fix bogus comment
      i40evf: don't store unnecessary array of strings
      i40evf: change type of flags variable
      i40evf: refactor reset handling
      i40evf: request reset on tx hang
      i40evf: remove VLAN filters on close
      i40evf: fix multiple crashes on remove
      i40evf: get rid of pci_using_dac
      i40evf: fix up strings in init task
      i40evf: remove bogus comment
      i40evf: don't guess device name
      i40evf: store ring size in ring structs
      i40evf: update version and copyright date
      i40e: remove unnecessary delay
      i40e: tighten up ring enable/disable flow
      i40e/i40evf: Use correct number of VF vectors
      i40e/i40evf: Use dma_set_mask_and_coherent
      i40e: support VF link state ndo
      i40evf: correctly program RSS HLUT table
      i40evf: use min_t
      i40evf: don't shut down admin queue on error
      i40evf: clean up init error messages
      i40evf: fix oops in watchdog handler

Monam Agarwal (4):
      drivers/net: Use RCU_INIT_POINTER(x, NULL) in bonding/bond_options.c
      drivers/net: Use RCU_INIT_POINTER(x, NULL) in tun.c
      net/bridge: Use RCU_INIT_POINTER(x, NULL) in br_vlan.c
      net/core: Use RCU_INIT_POINTER(x, NULL) in netpoll.c

Nadim Zubidat (1):
      wlcore: memset wl->rx_filter_enabled to zero after recovery

Neerav Parikh (1):
      i40e: Fix static checker warning

Neil Jerram (1):
      net: order MPLS ethertypes numerically

Nicolas Dichtel (3):
      ipsec: add support of limited SA dump
      pfkey: fix SADB_X_EXT_FILTER length check
      xfrm: rename struct xfrm_filter

Oleksij Rempel (46):
      ath: add last_rssi to ath_common
      ath9k: move ath9k_process_rssi to common.c
      ath9k: move ath9k_process_rate to common.c
      ath9k: move ath9k_rx_accept to common.c
      ath9k_htc: add rx header converter to make it usable by ath9k
      ath9k_htc: use ath9k_cmn_process_rssi
      ath9k_htc: use ath9k_cmn_process_rate
      ath9k_htc: use ath9k_cmn_rx_accept
      ath9k_htc: sync rx_status-> related code with ath9k
      ath9k: move ath9k_rx_skb_postprocess to common.c
      ath9k_htc: use ath9k_cmn_rx_skb_postprocess
      ath9k_htc: remove useless memcpy
      ath9k_htc: catch fw panic pattern
      ath9k: move ath9k_init_channels_rates to common-init
      ath9k_htc: use ath9k_cmn_init_channels_rates
      ath9k: move setup_ht_cap to common-init
      ath9k_htc: use ath9k_cmn_setup_ht_cap
      ath9k-common: set maxstream=1 for ar9271
      ath9k: move ath9k_reload_chainmask_settings to common
      ath9k_htc: use ath9k_cmn_reload_chainmask
      ath9k: remove unused listen_interval and sleepduration.
      ath9k_htc: remove unused variable sleepduration
      ath9k_htc: add function ath9k_regwrite_multi
      ath9k: move struct ath_beacon_config to common
      ath9k_htc: use common ath_beacon_config
      ath9k_htc: move beaconq to struct htc_beacon
      ath9k_htc: use ath_beacon_conf.enable_beacon
      ath9k: move sc_flags to ath_common
      ath9k_htc: use common->op_flags
      ath9k_htc: add ATH_OP_PRIM_STA_VIF
      ath9k: remove unused bc_tstamp
      ath9k_htc: sync beacon slot code with ath9k
      ath9k: remove unused beacon_qi
      ath9k|ath9k_htc: move IEEE80211_MS_TO_TU to common
      ath9k-common: add nexttbtt and intval to ath_beacon_config
      ath9k: move ath9k_beacon_config_sta to common-beacon
      ath9k_htc: use ath9k_cmn_beacon_config_sta
      ath9k: move ath9k_beacon_config_adhoc to common
      ath9k_htc: add ath9k_htc_beacon_init (but not use it)
      ath9k_htc: use ath9k_htc_beacon_init in ath9k_htc_beacon_config_ap
      ath9k_htc: use ath9k_htc_beacon_init in ath9k_htc_beacon_config_adhoc
      ath9k_htc: use ath9k_cmn_beacon_config_adhoc
      ath9k: move ath9k_beacon_config_ap common
      ath9k: remove unused ath9k_get_next_tbtt
      ath9k_htc: use ath9k_cmn_beacon_config_ap
      ath9k_htc: move DEFAULT_SWBA_RESPONSE check to ath9k_htc_beacon_init

Oliver Hartkopp (8):
      can: preserve skbuff protocol in can_put_echo_skb
      can: only send bitrate data via netlink when available
      can: move sanity check for bitrate and tq into can_get_bittiming
      can: provide a separate bittiming_const parameter to bittiming functions
      can: introduce the data bitrate configuration for CAN FD
      can: allow to change the device mtu for CAN FD capable devices
      can: add bittiming check at interface open for CAN FD
      can: Unify MTU settings for CAN interfaces

Oliver Neukum (2):
      Bluetooth: Enable Atheros 0cf3:311e for firmware upload
      Bluetooth: Add firmware update for Atheros 0cf3:311f

Or Gerlitz (5):
      net/i40e: Avoid double setting of NETIF_F_SG for the HW encapsulation feature mask
      net/mlx4: USe one wrapper that returns -EPERM
      mlx4: Add support for CONFIG_DEV command
      net/mlx4: Implement vxlan ndo calls
      net/mlx4: Set proper build dependancy with vxlan

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Pablo Neira Ayuso (4):
      netfilter: xt_ipcomp: Use ntohs to ease sparse warning
      vxlan: remove unused port variable in vxlan_udp_encap_recv()
      netfilter: nf_tables: add optional user data area to rules
      Merge git://git.kernel.org/.../horms/ipvs-next

Patrick McHardy (10):
      netfilter: ip_set: rename nfnl_dereference()/nfnl_set()
      netfilter: nfnetlink: add rcu_dereference_protected() helpers
      netfilter: nf_tables: add nft_dereference() macro
      netfilter: nf_tables: accept QUEUE/DROP verdict parameters
      netfilter: nft_hash: bug fixes and resizing
      netfilter: nf_tables: clean up nf_tables_trans_add() argument order
      netfilter: nf_tables: restore context for expression destructors
      netfilter: nf_tables: restore notifications for anonymous set destruction
      netfilter: nft_ct: remove family from struct nft_ct
      netfilter: nft_nat: fix family validation

Paul Durrant (3):
      xen-netback: remove pointless clause from if statement
      xen-netback: worse-case estimate in xenvif_rx_action is underestimating
      xen-netback: BUG_ON in xenvif_rx_action() not catching overflow

Paul Stewart (1):
      mwifiex: Track BA sequence number reset

Peng Chen (2):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.
      Bluetooth: Fix endianess issue in the ath3k driver

Peter Hurley (24):
      Revert "Bluetooth: Remove rfcomm_carrier_raised()"
      Revert "Bluetooth: Always wait for a connection on RFCOMM open()"
      Revert "Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()"
      tty: Fix ref counting for port krefs
      Bluetooth: Fix racy acquire of rfcomm_dev reference
      Bluetooth: Exclude released devices from RFCOMMGETDEVLIST ioctl
      Bluetooth: Release rfcomm_dev only once
      Bluetooth: Fix unreleased rfcomm_dev reference
      Bluetooth: Fix RFCOMM tty teardown race
      Bluetooth: Verify dlci not in use before rfcomm_dev create
      Bluetooth: Simplify RFCOMM session state eval
      Bluetooth: Refactor deferred setup test in rfcomm_dlc_close()
      Bluetooth: Refactor dlc disconnect logic in rfcomm_dlc_close()
      Bluetooth: Directly close dlc for not yet started RFCOMM session
      Bluetooth: Fix unsafe RFCOMM device parenting
      Bluetooth: Fix RFCOMM parent device for reused dlc
      Bluetooth: Rename __rfcomm_dev_get() to __rfcomm_dev_lookup()
      Bluetooth: Serialize RFCOMMCREATEDEV and RFCOMMRELEASEDEV ioctls
      Bluetooth: Refactor rfcomm_dev_add()
      Bluetooth: Cleanup RFCOMM device registration error handling
      Bluetooth: Force -EIO from tty read/write if .activate() fails
      Bluetooth: Don't fail RFCOMM tty writes
      Bluetooth: Refactor write_room() calculation
      Bluetooth: Fix write_room() calculation

Peter Pan(ÊΩòÂç´Âπ≥) (1):
      tcp: delete unused parameter in tcp_nagle_check()

Peter Senna Tschudin (1):
      INTEL-IGB: Convert iounmap to pci_iounmap

Peter Wu (2):
      rtlwifi: avoid accessing RCR directly
      rtlwifi: properly apply filter flags

Phoebe Buckheister (22):
      ieee802154: add basic support for RF212 to at86rf230 driver
      ieee802154: default to AACK in at86rf230
      ieee802154: add TX power control to wpan_phy
      ieee802154: support 100kbps QPSK/EU in at86rf230
      ieee802154: add support for listen-before-talk in wpan_phy
      ieee802154: add support for CCA mode in wpan phys
      ieee802154: add support for setting CCA energy detection levels
      ieee802154: ensure that first RF212 state comes from TRX_OFF
      ieee802154: add netlink APIs for smartMAC configuration
      ieee802154: enable smart transmitter features of RF212
      ieee802154: fix faulty check in set_phy_params api
      ieee802154: rename struct ieee802154_addr to *_sa
      ieee802154: add address struct with proper endiannes and some operations
      ieee802154: enforce consistent endianness in the 802.15.4 stack
      ieee802154: add header structs with endiannes and operations
      mac802154: use header operations to create/parse headers
      ieee802154: use ieee802154_addr instead of *_sa variants
      6lowpan: move lowpan frag_info out of 802.15.4 headers
      ieee802154: add proper length checks to header creations
      ieee802154: properly unshare skbs in ieee802154 *_rcv functions
      mac802154: allow only one WPAN to be up at any given time
      mac802154: make csma/cca parameters per-wpan

Pontus Fuchs (9):
      wcn36xx: Fix copy paste error hal_exit_bmps -> hal_keep_alive
      wcn36xx: Improve feature caps exchange
      wcn36xx: Wait longer for SMD commands to complete
      wcn36xx: Cache nv to avoid request_firmware on resume path
      wcn36xx: Print FW capabilities
      wcn36xx: Add support for 3680
      wcn36xx: Rename wcn36xx_vif.ucast_dpu_signature to self_ucast_dpu_sign
      wcn36xx: Track dpu signature per sta
      wcn36xx: Update dtim period before starting BSS

Rafa≈Ç Mi≈Çecki (1):
      bcma: gpio: register 32 GPIOs on BCM5357

Rajesh Borundia (1):
      qlcnic: Allow vlan0 traffic

Ravikumar Nelavelli (2):
      be2net: log LPVID used in multi-channel configs
      be2net: fix pmac_id[] allocation size

Richard Cochran (9):
      ptp: introduce programmable pins.
      ptp: add the pin GET/SETFUNC ioctls to the testptp program.
      ptp: expose the programmable pins via sysfs
      ptp: drivers: set the number of programmable pins.
      dp83640: trivial fixes
      dp83640: correct the periodic output frequency
      dp83640: implement programmable pin functions.
      dp83640: let external input pins from the module parameters be defaults.
      dp83640: let the periodic pin from the module parameter be a default.

Robert Schwebel (1):
      can: Documentation: fix parameter name "sample-point"

Sabrina Dubroca (1):
      ipx: implement shutdown()

Sachin Kamat (2):
      net: i40evf: Remove duplicate include
      net: wireless: wl3501_cs: Remove duplicate include

Sasha Levin (1):
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

Sathya Perla (5):
      be2net: dma_sync each RX frag before passing it to the stack
      be2net: update driver version to 10.2
      be2net: add FW cmds needed for VxLAN offloads
      be2net: csum, tso and rss steering offload support for VxLAN
      be2net: fix build dependency on VxLAN

Sebastian Reichel (4):
      wl1251: move power GPIO handling into the driver
      wl1251: spi: add vio regulator support
      wl1251: spi: add device tree support
      Documentation: dt: wireless: Add wl1251

Sergei Shtylyov (8):
      sh_eth: use ETH_ZLEN instead of home-grown #define
      DT: net: document Ethernet bindings in one place
      sh_eth: add device tree support
      sh_eth: exit probe with unknown register layout
      sh_eth: convert pr_*() to netdev_*() calls
      sh_eth: convert dev_*() to netdev_*() calls
      sh_eth: fold netif_msg_*() and netdev_*() calls into netif_*() invocations
      micrel: fix masking off LED bits

Sergey Popovich (1):
      netfilter: ipset: Follow manual page behavior for SET target on list:set

Shahed Shaikh (7):
      qlcnic: Re-factor firmware minidump template header handling
      qlcnic: Update version to 5.3.56
      Update MAINTAINERS for qlcnic driver
      qlcnic: Add VXLAN Tx offload support
      qlcnic: Add VXLAN Rx offload support
      qlcnic: Update version to 5.3.57
      qlcnic: Fix build failure due to undefined reference to `vxlan_get_rx_port'

Shaibal Dutta (2):
      net: wireless: move regulatory timeout work to power efficient workqueue
      net: rfkill: move poll work to power efficient workqueue

Shani Michaelli (1):
      mlx4_ib: Fix SIDR support of for UD QPs under SRIOV/RoCE

Shannon Nelson (4):
      i40e: clean up comment style
      i40e: delete netdev after deleting napi and vectors
      i40e: eeprom integrity check on load and empr
      i40e: check for netdev before debugfs use

Silvan Jegen (1):
      net: Replace min macro with min_t

Simon Wunderlich (6):
      mac80211: send ibss probe responses with noack flag
      if_ether.h: add IEEE 802.21 Ethertype
      UAPI: add MPLS label stack definition
      cfg80211: add MPLS and 802.21 classification
      batman-adv: fix a few kerneldoc inconsistencies
      batman-adv: Start new development cycle

Siva Reddy (2):
      sxgbe: Add device-tree binding support document
      net: sxgbe: add basic framework for Samsung 10Gb ethernet driver

Somnath Kotur (1):
      be2net: Log a kernel message when UE is detected in BE & Skyhawk

Stanislav Fomichev (1):
      tcp: remove unused min_cwnd member of tcp_congestion_ops

Stanislaw Gruszka (5):
      rt2x00: move frequent messages to debug level
      iwl3945: fix wakeup interrupt
      iwlegacy: merge reclaim check
      iwlegacy: properly enable power saving
      iwl4965: disable 8K A-MSDU by default

Stefan Assmann (1):
      igb: enable VLAN stripping for VMs with i350

Stefan Raspl (2):
      qeth: Removed unused parameter
      qeth: Fix IP version detection for VLAN traffic

Stefan S√∏rensen (1):
      net:cpsw: Pass unhandled ioctl's on to generic phy ioctl

Steffen Klassert (27):
      xfrm: Remove caching of xfrm_policy_sk_bundles
      xfrm: Cleanup error handling of xfrm_state_clone
      xfrm4: Add IPsec protocol multiplexer
      esp4: Use the IPsec protocol multiplexer API
      ah4: Use the IPsec protocol multiplexer API
      ipcomp4: Use the IPsec protocol multiplexer API
      xfrm: Add xfrm_tunnel_skb_cb to the skb common buffer
      ip_tunnel: Make vti work with i_key set
      vti: Update the ipv4 side to use it's own receive hook.
      xfrm4: Remove xfrm_tunnel_notifier
      vti4: Use the on xfrm_lookup returned dst_entry directly
      vti4: Support inter address family tunneling.
      vti4: Check the tunnel endpoints of the xfrm state and the vti interface
      vti4: Enable namespace changing
      flowcache: Fix resource leaks on namespace exit.
      xfrm: Introduce xfrm_input_afinfo to access the the callbacks properly
      xfrm6: Add IPsec protocol multiplexer
      esp6: Use the IPsec protocol multiplexer API
      ah6: Use the IPsec protocol multiplexer API
      ipcomp6: Use the IPsec protocol multiplexer API
      vti6: Remove dst_entry caching
      vti6: Remove caching of flow informations.
      vti6: Update the ipv6 side to use its own receive hook.
      xfrm6: Remove xfrm_tunnel_notifier
      vti6: Support inter address family tunneling.
      vti6: Check the tunnel endpoints of the xfrm state and the vti interface
      vti6: Enable namespace changing

Stephane Grosjean (1):
      can: add ability to allocate CANFD frame in skb data

Stephen Rothwell (1):
      Staging: rtl8812ae: remove modules field of rate_control_ops

Steve Wise (2):
      cxgb4/iw_cxgb4: Treat CPL_ERR_KEEPALV_NEG_ADVICE as negative advice
      cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes

Sucheta Chakraborty (1):
      qlcnic: Enhance driver message in failed state.

Sujith Manoharan (12):
      ath9k: Remove unnecessary check
      ath9k: Remove ath9k rate control
      ath9k: Fix IQ cal post processing for SoC
      ath9k: Check explicitly for IQ calibration
      ath9k: Rename ar9003_hw_tx_iqcal_load_avg_2_passes
      ath9k: Fix magnitude/phase calculation
      ath9k: Modify IQ calibration for AR955x
      ath9k: Expand the IQ coefficient array
      ath9k: Calculate IQ-CAL median
      ath9k: Add QCA953x WMAC platform support
      ath9k: Disable AR_INTR_SYNC_HOST1_FATAL for QCA953x
      ath9k: Fix temperature compensation

Sunil Dutt Undekari (1):
      cfg80211: Pass TDLS peer capability information in tdls_mgmt

Surendra Patil (1):
      Drivers:net:wireless:ti:wl1251: Fixed Sparse invalid assignment warning

Suresh Reddy (2):
      be2net: Use GET_PROFILE_CONFIG cmd for BE3-R to query max-vfs
      be2net: Add link state control for VFs

Sylvain Roger Rieunier (1):
      ath9k: fix invalid max frame length

Szymon Janc (1):
      Bluetooth: Print error when dropping L2CAP data

Tejun Heo (1):
      wireless/rt2x00: don't use PREPARE_WORK in rt2800usb.c

Thierry Escande (6):
      NFC: port100: Fix possible buffer overflow
      NFC: digital: Add poll support for type 4A tag platform
      NFC: digital: Add ISO-DEP support for data exchange
      NFC: port100: Add support for type 4A tag platform
      NFC: digital: Add missing break in switch statement
      NFC: digital: Fix a possible memory leak

Thomas Gleixner (15):
      Bluetooth: bluecard: Use del_timer_sync() in teardown path
      atm: firestream: Use del_timer_sync() in teardown path
      atm: idt77105: Use del_timer_sync() in exit path
      can: c_can: Wait for CONTROL_INIT to be cleared
      can: c_can: Fix hardware raminit function
      can: c_can: Make it SMP safe
      can: c_can: Fix buffer ordering
      can: c_can: Fix the lost message handling
      can: c_can: Remove EOB exit
      can: c_can: Provide protection in the xmit path
      can: c_can: Make the code readable
      can: c_can: Reduce register access
      can: c_can: Store dlc private
      can: c_can: Simplify TX interrupt cleanup
      can: c_can: Avoid led toggling for every packet.

Thomas Petazzoni (1):
      net: mvneta: use devm_ioremap_resource() instead of of_iomap()

Thomas Stilwell (1):
      ieee802154: at86rf230: add support for rf233 chip

Tim Harvey (1):
      sky2: allow mac to come from dt

Tim Smith (3):
      af_rxrpc: Remove incorrect checksum calculation from rxrpc_recvmsg()
      af_rxrpc: Prevent RxRPC peers from ABORT-storming one another
      af_rxrpc: Keep rxrpc_call pointers in a hashtable

Timo Ter√§s (1):
      neigh: probe application via netlink in NUD_PROBE

Tingwei Liu (1):
      ipvs: Reduce checkpatch noise in ip_vs_lblc.c

Tobias Klauser (1):
      net: eth: cpsw: Use net_device_stats from struct net_device

Todd Fujinaka (2):
      e1000e: PTP lock in e1000e_phc_adjustfreq
      igb: fix array size calculation

Tom Herbert (4):
      net: e1000e calls skb_set_hash
      net: igb calls skb_set_hash
      net: ixgbe calls skb_set_hash
      net: Rename skb->rxhash to skb->hash

Ursula Braun (1):
      af_iucv: recvmsg problem for SOCK_STREAM sockets

Uwe Kleine-K√∂nig (1):
      can: add explicit copyrights to can userspace header

Valentin Ilie (1):
      Bluetooth: Remove assignments in if-statements

Vasundhara Volam (4):
      be2net: Update copyright year
      be2net: refactor multi-channel config code for Skyhawk-R chip
      be2net: Create multiple TXQs on RSS capable multi-channel BE3-R interfaces
      be2net: Fix vlans_added counter

Veaceslav Falico (18):
      bonding: remove bond->lock from bond_arp_rcv
      bonding: permit using arp_validate with non-ab modes
      bonding: always update last_arp_rx on packet recieve
      bonding: always set recv_probe to bond_arp_rcv in arp monitor
      bonding: extend arp_validate to be able to receive unvalidated arp-only traffic
      bonding: document the new _arp options for arp_validate
      bonding: use the new options to correctly set last_arp_rx
      bonding: use last_arp_rx in slave_last_rx()
      bonding: use last_arp_rx in bond_loadbalance_arp_mon()
      bonding: remove useless updating of slave->dev->last_rx
      bonding: trivial: rename slave->jiffies to ->last_link_up
      bonding: rename last_arp_rx to last_rx
      bonding: fix bond_arp_rcv() race of curr_active_slave
      bonding: send arp requests even if there's no route to them
      bonding: make slave status notifications GFP_ATOMIC
      ether: add loopback type ETH_P_LOOPBACK
      bonding: use the correct ether type for alb
      bonding: ratelimit pr_warn()s in 802.3ad mode

Vince Bridgers (12):
      dts: Add bindings for the Altera Triple Speed Ethernet driver
      Documentation: networking: Add Altera Ethernet (TSE) Documentation
      Altera TSE: Add Altera Ethernet Driver MSGDMA File Components
      Altera TSE: Add Altera Ethernet Driver SGDMA file components
      Altera TSE: Add Miscellaneous Files for Altera Ethernet Driver
      Altera TSE: Add main and header file for Altera Ethernet Driver
      Altera TSE: Add Altera Ethernet Driver Makefile and Kconfig
      MAINTAINERS: Add entry for Altera Triple Speed Ethernet Driver
      net: ethernet: Change Ethernet Makefile and Kconfig for Altera TSE driver
      Altera TSE: Set version number by driver's get regs
      Altera TSE: Correct typecast issue detected by kbuild test robot
      Altera TSE: Correct two typos in original submission

Vipul Pandya (3):
      net: sxgbe: add TSO support for Samsung sxgbe
      net: sxgbe: add Checksum offload support for Samsung sxgbe
      net: sxgbe: add ethtool related functions support Samsung sxgbe

Vlad Yasevich (2):
      net: Allow modules to use is_skb_forwardable
      bridge: use is_skb_forwardable in forward path

Vladimir Kondratiev (40):
      wil6210: Tx management frame
      wil6210: [DEBUG] allow to query Rx and all Tx VRING descriptors
      wil6210: [DEBUG] Improve Vring printing
      wil6210: multiple connect - initial support
      wil6210: Block ACK
      wil6210: Find free vring for Tx
      wil6210: broadcast Tx
      wil6210: fix BACK status processing
      wil6210: dump_station initial support
      wil6210: per-connection statistics
      wil6210: disconnect only requested peer
      wil6210: Fill vring2cid_tid table early
      wil6210: Provide signal strength indication
      wil6210: use ether_addr_equal
      wil6210: single station disconnect
      wil6210: do not reorder groupcast Rx
      wil6210: fix buffer overflow in wil_txdesc_debugfs_show()
      wil6210: fix smatch warning in wil_cfg80211_get_station()
      wil6210: Helpers to deal with 'cidxtid' fields
      wil6210: Block data till "data port open" reported
      wil6210: enable scan while connected
      wil6210: add scatter-gather support
      wil6210: generalize tx desc mapping
      wil6210: update target reset to support new HW
      wil6210: reduce dmesg pollution after FW crash
      wil6210: report reset time
      wil6210: fix for HW bug in interrupt setup logic
      wil6210: sort HW registers definitions
      wil6210: reset on power good
      wil6210: reduce printing
      wil6210: fix memory leak in the AP flow
      wil6210: Fix kernel oops in reset flow
      wil6210: fw error recovery
      wil6210: fix secondary connect
      wil6210: serialize fw_recovery and start_ap
      wil6210: use GRO
      wil6210: target reset flow update
      wil6210: add memory barriers for the reset flow
      wil6210: fix race between disconnect and Tx NAPI
      wireless: max MSDU size for DMG networks

Vytas Dauksa (2):
      netfilter: ipset: add hash:ip,mark data type to ipset
      netfilter: ipset: add markmask for hash:ip,mark data type

WANG Cong (8):
      net_sched: act: hide struct tcf_common from API
      net_sched: act: refactor cleanup ops
      net_sched: act: move tcf_hashinfo_init() into tcf_register_action()
      net_sched: act: refuse to remove bound action outside
      net_sched: act: clean up tca_action_flush()
      net: allow setting mac address of loopback device
      net: introduce netdev_alloc_pcpu_stats() for drivers
      openvswitch: rename ->sync to ->syncp

Wang Yufen (16):
      bonding:fix checkpatch errors with foo* bar|foo * bar
      bonding:fix checkpatch errors comments and space
      bonding:fix checkpatch warnings braces {}
      bonding:fix checkpatch warnings braces {}
      bonding:fix checkpatch warnings braces {}
      bonding:fix checkpatch warnings braces {}
      netlink: fix checkpatch errors space and "foo *bar"
      ipv6: fix checkpatch errors with brace and "foo *bar"
      ipv6: fix checkpatch errors with space required or prohibited
      ipv6:fix checkpatch errors with assignment in if condition
      ipv6: fix checkpatch errors comments and space
      ipv6: fix checkpatch errors of brace and trailing statements
      ipv6: fix checkpatch errors of "foo*" and "foo * bar"
      ipv6: tcp_ipv6 do some cleanup
      ipv6: reuse rt6_need_strict
      ipv6: tcp_ipv6 policy route issue

Wei Liu (1):
      xen-netback: disable rogue vif in kthread context

Wei Yongjun (1):
      Bluetooth: Convert to use ATTRIBUTE_GROUPS macro

Yang Yingliang (6):
      socket: replace some printk with pr_*
      sch_netem: return errcode before setting params
      sch_netem: change some func's param from "struct Qdisc *" to "struct netem_sched_data *"
      sch_netem: replace magic numbers with enumerate in GE model
      sch_netem: replace magic numbers with enumerate in get_loss_clg
      net_sched: return nla_nest_end() instead of skb->len

Yaniv Machani (1):
      wlcore: increase timeout to 5000 msecs

Yann Droneaud (1):
      RDMA/cxgb4: set error code on kmalloc() failure

Yegor Yefremov (1):
      qmi_wwan/cdc_ether: move Novatel E371 (1410:9011) to qmi_wwan

Ying Xue (16):
      tipc: move code for resetting links from bearer.c to link.c
      tipc: move code for deleting links from bearer.c to link.c
      tipc: redefine 'started' flag in struct link to bitmap
      tipc: remove 'links' list from tipc_bearer struct
      tipc: remove bearer_lock from tipc_bearer struct
      tipc: align tipc function names with common naming practice in the network
      tipc: remove unnecessary checking for node object
      tipc: obsolete the remote management feature
      tipc: acquire necessary locks in named_cluster_distribute routine
      tipc: convert tipc_bearers array to pointer list
      tipc: remove active flag from tipc_bearer structure
      tipc: make broadcast bearer store in bearer_list array
      tipc: rename node create lock to protect node list and hlist
      tipc: tipc: convert node list and node hlist to RCU lists
      tipc: use node_list_lock to protect tipc_num_nodes variable
      tipc: use node list lock to protect tipc_num_links variable

Yoann DI RUZZA (1):
      can: at91_can: add listen only mode

Yogesh Ashok Powar (5):
      mwl8k: Adding support to access BBP registers
      mwl8k: Implement sw_scan start/stop cbs
      mwl8k: Adding support to gather survey per channel
      mwl8k: le32_to_cpu cast to restricted
      mwl8k: mwl8k_update_survey can be static

Yuchung Cheng (1):
      tcp: snmp stats for Fast Open, SYN rtx, and data pkts

Yuval Mintz (13):
      bnx2x: [Debug] change verbosity of some prints
      bnx2x: Remove unused iov code
      bnx2x: Semantic Validate vlan/mac changes
      bnx2x: Revise IOV vlan/mac validation
      bnx2x: Fix bnx2x_panic_dump for VFs
      bnx2x: (semantic) revise scheduling of sp_rtnl
      bnx2x: Support mng. request for driver version
      bnx2x: Create workqueue for IOV related tasks
      bnx2x: Remove the sriov VFOP mechanism
      bnx2x: Don't show port statistics for VFs
      bnx2x: Don't allow VFs to become promiscuous
      bnx2x: Fix compilation when CONFIG_BNX2X_SRIOV is not set
      bnx2x: Fix possible memory leak on iov error flow

ZHAO Gang (1):
      b43: use kernel api to replace b43 specific helper function

Zhao Qiang (1):
      phy/at8031: enable at8031 to work on interrupt mode

Zhao, Gang (13):
      b43: Kconfig: let config B43_BCMA_PIO depends on B43
      b43: return true / false instead of numbers in functions which return bool value
      airo: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
      atmel: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
      wl3501_cs: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
      rndis_wlan: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
      zd1201: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
      orinoco: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
      ieee80211: remove function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
      wireless: Kconfig: add missing dependency
      cfg80211: make __cfg80211_join_ibss() static
      cfg80211: remove unnecessary check
      cfg80211: remove macro ASSERT_RDEV_LOCK(rdev)

Zoltan Kiss (13):
      xen-netback: Use skb->cb for pending_idx
      xen-netback: Minor refactoring of netback code
      xen-netback: Handle foreign mapped pages on the guest RX path
      xen-netback: Introduce TX grant mapping
      xen-netback: Remove old TX grant copy definitons and fix indentations
      xen-netback: Add stat counters for zerocopy
      xen-netback: Handle guests with too many frags
      xen-netback: Timeout packets in RX path
      xen-netback: Aggregate TX unmap operations
      Revert "xen-netback: Aggregate TX unmap operations"
      xen-netback: Stop using xenvif_tx_pending_slots_available
      xen-netback: Non-functional follow-up patch for grant mapping series
      xen-netback: Functional follow-up patch for grant mapping series

andrea merello (9):
      mac80211: add check on hw->max_signal value on ieee80211_register_hw
      rtl818x: change misleading names for few register bit definitions
      rtl818x: Explicitly enable contetion window
      rtl818x: pci_iomap() should pair with pci_iounmap()
      rtl818x: check for pci_map_single() success when initializing RX ring
      rtl818x: make dev_alloc_skb() null pointer check to really work
      rtl818x: add comments to explain few not obvious HW configs.
      rtl818x: Make sure the TX descriptor "valid" flag is written by last
      rtl818x: make sure TX descriptor writes are done before kicking DMA

david decotigny (1):
      net-sysfs: expose number of carrier on/off changes

dingtianhong (12):
      bonding: remove the redundant judgements for bond_set_mac_address()
      bonding: remove the redundant judgements for bond_option_queue_id_set()
      bonding: netpoll: remove unwanted slave_dev_support_netpoll()
      bonding: use rcu_dereference() to access curr_active_slave
      bonding: remove no longer needed lock for bond_xxx_info_query()
      vlan: slight optimization for vlan_do_receive()
      vlan: use use ether_addr_equal_64bits to instead of ether_addr_equal
      bonding: slight optimization for bond xmit path
      bonding: ratelimit pr_err() for bond xmit broadcast
      vlan: make a new function vlan_dev_vlan_proto() and export
      bonding: support QinQ for bond arp interval
      bonding: add net_ratelimt to avoid spam in arp interval

fran√ßois romieu (8):
      atl1: remove open-coded skb_cow_head.
      atl1c: remove open-coded skb_cow_head.
      atl1e: remove open-coded skb_cow_head.
      jme: remove open-coded skb_cow_head.
      qlge: remove open-coded skb_cow_head.
      bna: remove open-coded skb_cow_head.
      tg3: remove open-coded skb_cow_head.
      wimax/i2400m: remove open-coded skb_cow_head.

hayeswang (26):
      r8152: move some functions
      r8152: add three functions
      r8152: replace some types from int to bool
      r8152: load the default MAC address
      r8152: reduce the frequency of spin_lock
      r8152: clear BMCR_PDOWN
      r8152: combine PHY reset with set_speed
      r8152: move some functions from probe to open
      r8152: support WOL
      r8152: support runtime suspend
      r8152: disable teredo for RTL8152
      r8152: replace netif_rx with netif_receive_skb
      r8152: set disable_hub_initiated_lpm
      r8152: support get_msglevel and set_msglevel
      r8152: deal with the empty line and space
      r8152: replace tp->netdev with netdev
      r8152: remove rtl8152_get_stats
      r8152: replace spin_lock_irqsave and spin_unlock_irqrestore
      r8152: check tx agg list before spin lock
      r8152: up the priority of the transmission
      r8152: calculate the dropped packets for rx
      r8152: support rx checksum
      r8152: support TSO
      r8152: support IPv6
      r8152: add skb_cow_head
      r8152: support dumping the hw counters

stephen hemminger (7):
      net: remove unnecessary return's
      netfilter: remove double colon
      bonding: remove dead code
      bonding: options handling cleanup
      bonding: fix const in options processing
      netdev: set __percpu attribute on netdev_alloc_pcpu_stats
      bonding: force cast of IP address in options

wangweidong (5):
      appletalk: fix checkpatch errors with space required or prohibited
      appletalk: fix checkpatch errors with foo* bar|foo * bar
      appletalk: fix checkpatch error with indent
      via: fix a punctuation typo
      atheros/atlx: use SET_ETHTOOL_OPS directly

 Documentation/ABI/testing/sysfs-bus-mdio           |   20 +
 Documentation/ABI/testing/sysfs-class-net          |  199 ++
 Documentation/ABI/testing/sysfs-class-net-mesh     |    9 +
 Documentation/ABI/testing/sysfs-ptp                |   20 +
 Documentation/DocBook/80211.tmpl                   |    2 +
 Documentation/devices.txt                          |    1 +
 .../bindings/net/allwinner,sun4i-emac.txt          |    6 +-
 .../devicetree/bindings/net/altera_tse.txt         |  114 +
 Documentation/devicetree/bindings/net/arc_emac.txt |   11 +-
 .../devicetree/bindings/net/broadcom-bcmgenet.txt  |  121 +
 .../devicetree/bindings/net/can/sja1000.txt        |    4 +
 .../devicetree/bindings/net/cavium-mix.txt         |    7 +-
 .../devicetree/bindings/net/cavium-pip.txt         |    7 +-
 .../devicetree/bindings/net/cdns-emac.txt          |    6 +-
 Documentation/devicetree/bindings/net/cpsw.txt     |    5 +-
 .../devicetree/bindings/net/davicom-dm9000.txt     |    2 -
 .../devicetree/bindings/net/davinci_emac.txt       |    3 +-
 Documentation/devicetree/bindings/net/ethernet.txt |   25 +
 Documentation/devicetree/bindings/net/fsl-fec.txt  |    5 +-
 .../devicetree/bindings/net/fsl-tsec-phy.txt       |   13 +-
 Documentation/devicetree/bindings/net/lpc-eth.txt  |    5 +-
 Documentation/devicetree/bindings/net/macb.txt     |    6 +-
 .../bindings/net/marvell-armada-370-neta.txt       |    6 +-
 .../devicetree/bindings/net/marvell-orion-net.txt  |    4 +-
 .../devicetree/bindings/net/micrel-ks8851.txt      |    1 -
 Documentation/devicetree/bindings/net/micrel.txt   |   18 +
 .../devicetree/bindings/net/nfc/trf7970a.txt       |   34 +
 Documentation/devicetree/bindings/net/phy.txt      |   10 +-
 .../devicetree/bindings/net/samsung-sxgbe.txt      |   52 +
 Documentation/devicetree/bindings/net/sh_eth.txt   |   55 +
 .../devicetree/bindings/net/smsc-lan91c111.txt     |    3 +-
 Documentation/devicetree/bindings/net/smsc911x.txt |    5 +-
 Documentation/devicetree/bindings/net/stmmac.txt   |    7 +-
 .../devicetree/bindings/net/wireless/ti,wl1251.txt |   39 +
 Documentation/networking/altera_tse.txt            |  263 ++
 Documentation/networking/bonding.txt               |   96 +-
 Documentation/networking/can.txt                   |    2 +-
 Documentation/networking/filter.txt                |  125 +
 Documentation/networking/gianfar.txt               |   30 -
 Documentation/networking/igb.txt                   |   48 -
 Documentation/networking/phy.txt                   |   11 +-
 Documentation/networking/pktgen.txt                |   24 +-
 Documentation/networking/rxrpc.txt                 |   81 +
 Documentation/networking/tcp.txt                   |    2 +-
 Documentation/networking/timestamping.txt          |    6 +-
 Documentation/ptp/testptp.c                        |   87 +-
 MAINTAINERS                                        |   31 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    6 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   13 +-
 arch/arm/net/bpf_jit_32.c                          |    7 +-
 arch/powerpc/net/bpf_jit_comp.c                    |    7 +-
 arch/s390/net/bpf_jit_comp.c                       |   13 +-
 arch/sparc/net/bpf_jit_comp.c                      |    5 +-
 arch/um/drivers/net_kern.c                         |    2 +-
 arch/x86/net/bpf_jit_comp.c                        |   11 +-
 block/blk-cgroup.h                                 |    8 +-
 drivers/atm/ambassador.c                           |    2 +-
 drivers/atm/firestream.c                           |    6 +-
 drivers/atm/idt77105.c                             |    6 +-
 drivers/atm/nicstar.c                              |   24 +-
 drivers/atm/solos-pci.c                            |    2 +-
 drivers/bcma/driver_gpio.c                         |    9 +-
 drivers/bluetooth/ath3k.c                          |   97 +-
 drivers/bluetooth/bfusb.c                          |   14 +-
 drivers/bluetooth/bluecard_cs.c                    |   11 +-
 drivers/bluetooth/bt3c_cs.c                        |    7 +-
 drivers/bluetooth/btmrvl_main.c                    |   11 +-
 drivers/bluetooth/btuart_cs.c                      |    6 +-
 drivers/bluetooth/btusb.c                          |   59 +-
 drivers/bluetooth/dtl1_cs.c                        |    9 +-
 drivers/bluetooth/hci_bcsp.c                       |   31 +-
 drivers/bluetooth/hci_h5.c                         |   10 +-
 drivers/bluetooth/hci_ldisc.c                      |    9 +-
 drivers/bluetooth/hci_vhci.c                       |    3 +-
 drivers/connector/connector.c                      |    1 -
 drivers/infiniband/hw/cxgb4/cm.c                   |   24 +-
 drivers/infiniband/hw/cxgb4/device.c               |  177 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    9 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   45 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  140 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |    6 +
 drivers/infiniband/hw/cxgb4/user.h                 |    5 +
 drivers/infiniband/hw/mlx4/alias_GUID.c            |    2 +-
 drivers/infiniband/hw/mlx4/cm.c                    |   80 +-
 drivers/infiniband/hw/mlx4/cq.c                    |   42 +-
 drivers/infiniband/hw/mlx4/mad.c                   |  122 +-
 drivers/infiniband/hw/mlx4/main.c                  |   31 +-
 drivers/infiniband/hw/mlx4/mcg.c                   |    5 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   24 +-
 drivers/infiniband/hw/mlx4/qp.c                    |  319 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |    5 +
 drivers/isdn/act2000/module.c                      |    2 +-
 drivers/isdn/divert/divert_procfs.c                |    7 +-
 drivers/isdn/hisax/elsa.c                          |    9 +-
 drivers/isdn/hisax/elsa_ser.c                      |    3 +-
 drivers/isdn/hysdn/hysdn_proclog.c                 |    7 +-
 drivers/isdn/i4l/isdn_common.c                     |   15 +-
 drivers/isdn/i4l/isdn_ppp.c                        |   61 +-
 drivers/isdn/pcbit/drv.c                           |    6 +-
 drivers/isdn/sc/init.c                             |    4 +-
 drivers/net/Kconfig                                |    5 -
 drivers/net/bonding/bond_3ad.c                     |   74 +-
 drivers/net/bonding/bond_3ad.h                     |  175 +-
 drivers/net/bonding/bond_alb.c                     |  138 +-
 drivers/net/bonding/bond_debugfs.c                 |   10 +-
 drivers/net/bonding/bond_main.c                    |  466 ++-
 drivers/net/bonding/bond_netlink.c                 |    8 +-
 drivers/net/bonding/bond_options.c                 |  328 +-
 drivers/net/bonding/bond_options.h                 |   62 +-
 drivers/net/bonding/bond_procfs.c                  |   14 +-
 drivers/net/bonding/bond_sysfs.c                   |   24 +-
 drivers/net/bonding/bonding.h                      |   43 +-
 drivers/net/caif/caif_serial.c                     |    1 -
 drivers/net/caif/caif_spi.c                        |    1 -
 drivers/net/can/at91_can.c                         |   10 +-
 drivers/net/can/bfin_can.c                         |    1 +
 drivers/net/can/c_can/c_can.c                      |  349 +-
 drivers/net/can/c_can/c_can.h                      |   29 +
 drivers/net/can/c_can/c_can_platform.c             |   47 +-
 drivers/net/can/cc770/cc770.c                      |    1 +
 drivers/net/can/dev.c                              |  183 +-
 drivers/net/can/flexcan.c                          |   11 +-
 drivers/net/can/grcan.c                            |    1 +
 drivers/net/can/janz-ican3.c                       |   65 +-
 drivers/net/can/mcp251x.c                          |   22 +-
 drivers/net/can/mscan/mscan.c                      |    7 +-
 drivers/net/can/pch_can.c                          |    1 +
 drivers/net/can/sja1000/Kconfig                    |   13 +-
 drivers/net/can/sja1000/Makefile                   |    1 -
 drivers/net/can/sja1000/ems_pci.c                  |    1 +
 drivers/net/can/sja1000/ems_pcmcia.c               |    1 +
 drivers/net/can/sja1000/kvaser_pci.c               |    1 +
 drivers/net/can/sja1000/peak_pci.c                 |    1 +
 drivers/net/can/sja1000/peak_pcmcia.c              |    1 +
 drivers/net/can/sja1000/plx_pci.c                  |    1 +
 drivers/net/can/sja1000/sja1000.c                  |   10 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      |  220 --
 drivers/net/can/sja1000/sja1000_platform.c         |  194 +-
 drivers/net/can/slcan.c                            |    6 +
 drivers/net/can/softing/softing_main.c             |    2 +
 drivers/net/can/ti_hecc.c                          |    1 +
 drivers/net/can/usb/ems_usb.c                      |    1 +
 drivers/net/can/usb/esd_usb2.c                     |    2 +
 drivers/net/can/usb/kvaser_usb.c                   |    2 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |    2 +
 drivers/net/can/usb/usb_8dev.c                     |    3 +-
 drivers/net/dummy.c                                |   12 +-
 drivers/net/ethernet/3com/3c509.c                  |    2 +-
 drivers/net/ethernet/3com/3c589_cs.c               | 1127 +++---
 drivers/net/ethernet/3com/3c59x.c                  |    2 +-
 drivers/net/ethernet/8390/lib8390.c                |    2 +-
 drivers/net/ethernet/Kconfig                       |    2 +
 drivers/net/ethernet/Makefile                      |    2 +
 drivers/net/ethernet/adi/bfin_mac.c                |    9 +-
 drivers/net/ethernet/aeroflex/greth.c              |    6 -
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    2 +-
 drivers/net/ethernet/altera/Kconfig                |    8 +
 drivers/net/ethernet/altera/Makefile               |    7 +
 drivers/net/ethernet/altera/altera_msgdma.c        |  202 ++
 drivers/net/ethernet/altera/altera_msgdma.h        |   34 +
 drivers/net/ethernet/altera/altera_msgdmahw.h      |  167 +
 drivers/net/ethernet/altera/altera_sgdma.c         |  509 +++
 drivers/net/ethernet/altera/altera_sgdma.h         |   35 +
 drivers/net/ethernet/altera/altera_sgdmahw.h       |  124 +
 drivers/net/ethernet/altera/altera_tse.h           |  486 +++
 drivers/net/ethernet/altera/altera_tse_ethtool.c   |  235 ++
 drivers/net/ethernet/altera/altera_tse_main.c      | 1543 ++++++++
 drivers/net/ethernet/altera/altera_utils.c         |   44 +
 drivers/net/ethernet/altera/altera_utils.h         |   27 +
 drivers/net/ethernet/amd/7990.c                    |    2 +-
 drivers/net/ethernet/amd/am79c961a.c               |    2 +-
 drivers/net/ethernet/amd/amd8111e.c                |    3 +
 drivers/net/ethernet/amd/pcnet32.c                 |  124 +-
 drivers/net/ethernet/atheros/alx/main.c            |    4 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   34 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   14 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |   15 +-
 drivers/net/ethernet/atheros/atlx/atl2.c           |   10 +-
 drivers/net/ethernet/broadcom/Kconfig              |   11 +
 drivers/net/ethernet/broadcom/Makefile             |    1 +
 drivers/net/ethernet/broadcom/b44.c                |    8 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |    3 -
 drivers/net/ethernet/broadcom/bnx2.c               |   24 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   45 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  162 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |   48 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c    |    8 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |   11 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    |    1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |   31 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  385 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |  155 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h     |   21 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  | 1876 +++-------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h  |  368 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c   |  619 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h   |   22 +
 drivers/net/ethernet/broadcom/genet/Makefile       |    2 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 2584 ++++++++++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  628 ++++
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  464 +++
 drivers/net/ethernet/broadcom/tg3.c                |   30 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   65 +-
 drivers/net/ethernet/cadence/macb.c                |    8 +-
 drivers/net/ethernet/calxeda/xgmac.c               |    6 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   26 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   16 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  230 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |    1 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  172 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  152 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |    1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |    9 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |    4 +
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   43 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c         |    6 +-
 drivers/net/ethernet/cirrus/cs89x0.c               |    2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   24 +-
 drivers/net/ethernet/davicom/dm9000.c              |    2 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |    4 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |    4 +-
 drivers/net/ethernet/dlink/sundance.c              |    2 +-
 drivers/net/ethernet/dnet.c                        |    6 -
 drivers/net/ethernet/emulex/benet/Kconfig          |    8 +
 drivers/net/ethernet/emulex/benet/be.h             |   27 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  213 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |   97 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |   30 +-
 drivers/net/ethernet/emulex/benet/be_hw.h          |    9 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |  467 ++-
 drivers/net/ethernet/emulex/benet/be_roce.c        |    2 +-
 drivers/net/ethernet/emulex/benet/be_roce.h        |    2 +-
 drivers/net/ethernet/ethoc.c                       |    6 -
 drivers/net/ethernet/faraday/ftgmac100.c           |    6 -
 drivers/net/ethernet/freescale/Makefile            |    3 +-
 drivers/net/ethernet/freescale/fec_main.c          |   19 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |    1 +
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |    3 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |    7 -
 drivers/net/ethernet/freescale/gianfar.c           | 1377 ++++----
 drivers/net/ethernet/freescale/gianfar.h           |  114 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  165 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c       |    1 +
 drivers/net/ethernet/freescale/gianfar_sysfs.c     |  340 --
 drivers/net/ethernet/freescale/ucc_geth.c          |    2 +-
 drivers/net/ethernet/i825xx/lib82596.c             |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |    6 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |    6 +-
 drivers/net/ethernet/intel/e100.c                  |    4 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.c    |   47 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.h    |   47 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |   47 +-
 drivers/net/ethernet/intel/e1000e/82571.h          |   47 +-
 drivers/net/ethernet/intel/e1000e/Makefile         |    7 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |   55 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   52 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |   64 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |   55 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  427 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   72 +-
 drivers/net/ethernet/intel/e1000e/mac.c            |   47 +-
 drivers/net/ethernet/intel/e1000e/mac.h            |   47 +-
 drivers/net/ethernet/intel/e1000e/manage.c         |   47 +-
 drivers/net/ethernet/intel/e1000e/manage.h         |   47 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  373 +-
 drivers/net/ethernet/intel/e1000e/nvm.c            |   47 +-
 drivers/net/ethernet/intel/e1000e/nvm.h            |   47 +-
 drivers/net/ethernet/intel/e1000e/param.c          |   53 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |   47 +-
 drivers/net/ethernet/intel/e1000e/phy.h            |   47 +-
 drivers/net/ethernet/intel/e1000e/ptp.c            |   53 +-
 drivers/net/ethernet/intel/e1000e/regs.h           |   48 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   50 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c      |    5 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |  370 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.c         |    9 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   87 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  476 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  546 ++-
 drivers/net/ethernet/intel/i40e/i40e_nvm.c         |  117 +-
 drivers/net/ethernet/intel/i40e/i40e_prototype.h   |    7 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  434 ++-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  135 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |    5 +
 .../net/ethernet/intel/i40evf/i40e_adminq_cmd.h    |    2 +-
 drivers/net/ethernet/intel/i40evf/i40e_common.c    |  369 +-
 drivers/net/ethernet/intel/i40evf/i40e_prototype.h |    7 +
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c      |   90 +-
 drivers/net/ethernet/intel/i40evf/i40e_type.h      |   16 +-
 drivers/net/ethernet/intel/i40evf/i40evf.h         |   48 +-
 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c |   13 +-
 drivers/net/ethernet/intel/i40evf/i40evf_main.c    |  299 +-
 .../net/ethernet/intel/i40evf/i40evf_virtchnl.c    |   27 +-
 drivers/net/ethernet/intel/igb/Makefile            |    5 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c       |   15 +-
 drivers/net/ethernet/intel/igb/e1000_82575.h       |   12 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h     |   75 +-
 drivers/net/ethernet/intel/igb/e1000_hw.h          |    5 +-
 drivers/net/ethernet/intel/igb/e1000_i210.c        |   25 +-
 drivers/net/ethernet/intel/igb/e1000_i210.h        |   14 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c         |    5 +-
 drivers/net/ethernet/intel/igb/e1000_mac.h         |    5 +-
 drivers/net/ethernet/intel/igb/e1000_mbx.c         |    5 +-
 drivers/net/ethernet/intel/igb/e1000_mbx.h         |    5 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.c         |    5 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.h         |    5 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c         |   76 +-
 drivers/net/ethernet/intel/igb/e1000_phy.h         |    6 +-
 drivers/net/ethernet/intel/igb/e1000_regs.h        |   36 +-
 drivers/net/ethernet/intel/igb/igb.h               |   18 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   76 +-
 drivers/net/ethernet/intel/igb/igb_hwmon.c         |    5 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  170 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |   64 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   10 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |    6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c     |   33 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c     |  360 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |  200 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h    |   14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82599.c |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82599.h |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c   |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   18 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |   11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h      |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |   17 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  212 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.c       |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h       |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |   45 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h       |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |   39 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h     |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c     |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   29 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c      |    6 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |  141 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h       |   12 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  161 +-
 drivers/net/ethernet/intel/ixgbevf/regs.h          |   12 +-
 drivers/net/ethernet/intel/ixgbevf/vf.h            |   33 +-
 drivers/net/ethernet/jme.c                         |   16 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    4 +-
 drivers/net/ethernet/marvell/mvmdio.c              |    6 -
 drivers/net/ethernet/marvell/mvneta.c              |   20 +-
 drivers/net/ethernet/marvell/skge.c                |    4 +-
 drivers/net/ethernet/marvell/sky2.c                |   28 +-
 drivers/net/ethernet/mellanox/mlx4/Kconfig         |    9 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |  179 +-
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_dcb_nl.c     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |   45 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  128 +-
 drivers/net/ethernet/mellanox/mlx4/en_port.c       |    6 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   28 +
 drivers/net/ethernet/mellanox/mlx4/en_selftest.c   |    6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   40 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |   48 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  108 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  174 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |    5 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   14 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   19 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |  267 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  289 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   17 +-
 drivers/net/ethernet/micrel/ksz884x.c              |    2 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   40 +-
 drivers/net/ethernet/neterion/s2io.c               |   14 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   35 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   57 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   11 +-
 drivers/net/ethernet/qlogic/Kconfig                |   10 +
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    5 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h        |  121 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   10 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h    |   11 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   91 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |   23 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c     |   22 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h     |    9 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |  179 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   85 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |  233 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |    6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c  |  102 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |   25 +-
 drivers/net/ethernet/rdc/r6040.c                   |    6 -
 drivers/net/ethernet/realtek/8139cp.c              |    7 +-
 drivers/net/ethernet/realtek/8139too.c             |   12 +-
 drivers/net/ethernet/realtek/r8169.c               |   14 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  271 +-
 drivers/net/ethernet/renesas/sh_eth.h              |    3 +-
 drivers/net/ethernet/samsung/Kconfig               |   16 +
 drivers/net/ethernet/samsung/Makefile              |    5 +
 drivers/net/ethernet/samsung/sxgbe/Kconfig         |    9 +
 drivers/net/ethernet/samsung/sxgbe/Makefile        |    4 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h  |  535 +++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c    |  262 ++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.c    |  515 +++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.h    |  298 ++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_dma.c     |  382 ++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_dma.h     |   50 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c |  524 +++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    | 2317 ++++++++++++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c    |  244 ++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_mtl.c     |  254 ++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_mtl.h     |  104 +
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |  259 ++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_reg.h     |  488 +++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_xpcs.c    |   91 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_xpcs.h    |   38 +
 drivers/net/ethernet/sfc/ef10.c                    |   27 +-
 drivers/net/ethernet/sfc/ef10_regs.h               |   61 -
 drivers/net/ethernet/sfc/efx.c                     |   33 +-
 drivers/net/ethernet/sfc/efx.h                     |    2 +-
 drivers/net/ethernet/sfc/ethtool.c                 |   39 +-
 drivers/net/ethernet/sfc/falcon.c                  |    6 +-
 drivers/net/ethernet/sfc/farch.c                   |    5 +-
 drivers/net/ethernet/sfc/filter.h                  |    2 +-
 drivers/net/ethernet/sfc/mcdi.c                    |   14 +-
 drivers/net/ethernet/sfc/mcdi_port.c               |    4 +-
 drivers/net/ethernet/sfc/net_driver.h              |    1 -
 drivers/net/ethernet/sfc/nic.c                     |    1 -
 drivers/net/ethernet/sfc/ptp.c                     |   93 +-
 drivers/net/ethernet/sfc/selftest.c                |    6 +-
 drivers/net/ethernet/sfc/siena_sriov.c             |   13 +-
 drivers/net/ethernet/sfc/tx.c                      |   21 +-
 drivers/net/ethernet/silan/sc92031.c               |    2 +-
 drivers/net/ethernet/sis/sis900.c                  |    2 +-
 drivers/net/ethernet/smsc/smc911x.c                |    2 +-
 drivers/net/ethernet/smsc/smc91x.c                 |    4 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    7 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   10 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |    1 +
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  130 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |    1 +
 drivers/net/ethernet/sun/niu.c                     |   11 +-
 drivers/net/ethernet/sun/sungem.c                  |    2 +-
 drivers/net/ethernet/ti/cpsw.c                     |   34 +-
 drivers/net/ethernet/ti/cpts.c                     |   11 +-
 drivers/net/ethernet/tile/tilegx.c                 |    4 +
 drivers/net/ethernet/tile/tilepro.c                |   11 +-
 drivers/net/ethernet/toshiba/spider_net.c          |    2 +-
 drivers/net/ethernet/toshiba/tc35815.c             |    3 +
 drivers/net/ethernet/via/via-rhine.c               |   16 +-
 drivers/net/ethernet/via/via-velocity.c            |    2 +-
 drivers/net/ethernet/wiznet/w5100.c                |    9 +-
 drivers/net/ethernet/wiznet/w5300.c                |    9 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |    4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   15 +-
 drivers/net/ethernet/xscale/Kconfig                |    1 +
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |   11 +-
 drivers/net/hamradio/yam.c                         |    2 +-
 drivers/net/hyperv/hyperv_net.h                    |  207 +-
 drivers/net/hyperv/netvsc.c                        |   93 +-
 drivers/net/hyperv/netvsc_drv.c                    |  337 +-
 drivers/net/hyperv/rndis_filter.c                  |  187 +-
 drivers/net/ieee802154/Kconfig                     |   34 +-
 drivers/net/ieee802154/at86rf230.c                 |  520 ++-
 drivers/net/ieee802154/fakehard.c                  |   22 +-
 drivers/net/ieee802154/mrf24j40.c                  |   17 +-
 drivers/net/ifb.c                                  |    8 +-
 drivers/net/loopback.c                             |   16 +-
 drivers/net/macvlan.c                              |   13 +-
 drivers/net/nlmon.c                                |   18 +-
 drivers/net/phy/Kconfig                            |    6 +
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/at803x.c                           |   30 +
 drivers/net/phy/bcm7xxx.c                          |  359 ++
 drivers/net/phy/broadcom.c                         |   52 -
 drivers/net/phy/dp83640.c                          |   94 +-
 drivers/net/phy/mdio-sun4i.c                       |    6 -
 drivers/net/phy/mdio_bus.c                         |   20 +
 drivers/net/phy/micrel.c                           |   49 +-
 drivers/net/phy/phy.c                              |   51 +-
 drivers/net/phy/phy_device.c                       |   57 +-
 drivers/net/ppp/ppp_generic.c                      |   60 +-
 drivers/net/team/team.c                            |   28 +-
 drivers/net/team/team_mode_loadbalance.c           |    4 +-
 drivers/net/tun.c                                  |    8 +-
 drivers/net/usb/cdc_ether.c                        |    7 +
 drivers/net/usb/cdc_ncm.c                          |   17 +
 drivers/net/usb/lg-vl600.c                         |    2 +-
 drivers/net/usb/qmi_wwan.c                         |    7 +
 drivers/net/usb/r8152.c                            | 1232 +++++--
 drivers/net/veth.c                                 |   23 +-
 drivers/net/virtio_net.c                           |   10 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  112 +-
 drivers/net/vxlan.c                                |   13 +-
 drivers/net/wimax/i2400m/netdev.c                  |    3 +-
 drivers/net/wireless/Kconfig                       |   11 +-
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/airo.c                        |   17 +-
 drivers/net/wireless/ath/ath.h                     |   15 +-
 drivers/net/wireless/ath/ath10k/ce.c               |   16 +-
 drivers/net/wireless/ath/ath10k/ce.h               |    9 +-
 drivers/net/wireless/ath/ath10k/core.c             |   36 +-
 drivers/net/wireless/ath/ath10k/core.h             |   81 +-
 drivers/net/wireless/ath/ath10k/debug.h            |    2 +-
 drivers/net/wireless/ath/ath10k/hif.h              |   25 +-
 drivers/net/wireless/ath/ath10k/htc.c              |   25 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   18 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  269 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |  205 +-
 drivers/net/wireless/ath/ath10k/hw.h               |    6 +
 drivers/net/wireless/ath/ath10k/mac.c              |  850 ++++-
 drivers/net/wireless/ath/ath10k/pci.c              |  536 ++-
 drivers/net/wireless/ath/ath10k/pci.h              |   28 -
 drivers/net/wireless/ath/ath10k/txrx.c             |   32 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  132 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   34 +-
 drivers/net/wireless/ath/ath5k/base.c              |    3 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    1 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   27 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |    6 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   12 -
 drivers/net/wireless/ath/ath9k/Makefile            |    5 +-
 drivers/net/wireless/ath/ath9k/ahb.c               |   11 +-
 drivers/net/wireless/ath/ath9k/ani.c               |   52 +-
 drivers/net/wireless/ath/ath9k/ani.h               |    4 +
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   85 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |  235 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   63 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    4 -
 drivers/net/wireless/ath/ath9k/ath9k.h             |   35 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |  203 +-
 drivers/net/wireless/ath/ath9k/common-beacon.c     |  180 +
 drivers/net/wireless/ath/ath9k/common-beacon.h     |   26 +
 drivers/net/wireless/ath/ath9k/common-init.c       |  244 ++
 drivers/net/wireless/ath/ath9k/common-init.h       |   20 +
 drivers/net/wireless/ath/ath9k/common.c            |  244 ++
 drivers/net/wireless/ath/ath9k/common.h            |   35 +
 drivers/net/wireless/ath/ath9k/debug.c             |   86 +-
 drivers/net/wireless/ath/ath9k/debug.h             |    1 -
 drivers/net/wireless/ath/ath9k/dfs_debug.h         |    2 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    2 +
 drivers/net/wireless/ath/ath9k/htc.h               |   27 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |  260 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  240 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   54 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  179 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   36 +
 drivers/net/wireless/ath/ath9k/htc_hst.h           |   12 +
 drivers/net/wireless/ath/ath9k/hw.c                |    4 +-
 drivers/net/wireless/ath/ath9k/init.c              |  247 +-
 drivers/net/wireless/ath/ath9k/link.c              |   16 +-
 drivers/net/wireless/ath/ath9k/mac.c               |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h               |    9 +-
 drivers/net/wireless/ath/ath9k/main.c              |   69 +-
 drivers/net/wireless/ath/ath9k/mci.c               |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    8 +-
 drivers/net/wireless/ath/ath9k/rc.c                | 1495 --------
 drivers/net/wireless/ath/ath9k/rc.h                |  248 --
 drivers/net/wireless/ath/ath9k/recv.c              |  267 +-
 drivers/net/wireless/ath/ath9k/tx99.c              |    2 +-
 drivers/net/wireless/ath/ath9k/wow.c               |    4 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   18 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    2 +-
 drivers/net/wireless/ath/regd.c                    |   10 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |   10 +-
 drivers/net/wireless/ath/wcn36xx/dxe.h             |    4 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |    4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   72 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   64 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |    5 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |    7 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   10 +-
 drivers/net/wireless/ath/wil6210/Makefile          |    1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  241 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |  181 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |   33 +-
 drivers/net/wireless/ath/wil6210/main.c            |  234 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |    5 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |   37 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |  177 +
 drivers/net/wireless/ath/wil6210/txrx.c            |  334 +-
 drivers/net/wireless/ath/wil6210/txrx.h            |    7 +
 drivers/net/wireless/ath/wil6210/wil6210.h         |  164 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |  136 +-
 drivers/net/wireless/atmel.c                       |    8 +-
 drivers/net/wireless/b43/Kconfig                   |    2 +-
 drivers/net/wireless/b43/debugfs.h                 |    2 +-
 drivers/net/wireless/b43/main.c                    |    2 +-
 drivers/net/wireless/b43/main.h                    |   35 -
 drivers/net/wireless/b43/phy_common.c              |    4 +-
 drivers/net/wireless/b43/pio.c                     |   10 +-
 drivers/net/wireless/b43/sysfs.c                   |    2 +-
 drivers/net/wireless/b43/xmit.c                    |   14 +-
 drivers/net/wireless/b43legacy/main.c              |    4 +-
 drivers/net/wireless/b43legacy/sysfs.c             |    2 +-
 drivers/net/wireless/b43legacy/xmit.c              |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  107 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     | 1034 ++++++
 drivers/net/wireless/brcm80211/brcmfmac/chip.h     |   91 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  982 +++---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    5 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |    2 +-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   10 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |    6 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  972 -----
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |  231 --
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   91 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  283 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   21 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   20 +-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |    3 +
 drivers/net/wireless/cw1200/fwio.c                 |    4 +-
 drivers/net/wireless/hostap/hostap_cs.c            |    2 +
 drivers/net/wireless/ipw2x00/ipw2100.c             |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
 drivers/net/wireless/iwlegacy/3945-mac.c           |   13 +-
 drivers/net/wireless/iwlegacy/3945-rs.c            |    3 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   15 +-
 drivers/net/wireless/iwlegacy/4965-rs.c            |    3 +-
 drivers/net/wireless/iwlegacy/commands.h           |    3 +-
 drivers/net/wireless/iwlegacy/common.c             |   83 +-
 drivers/net/wireless/iwlegacy/common.h             |   17 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   14 +
 drivers/net/wireless/iwlwifi/Makefile              |    2 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h             |    4 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c         |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   12 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c              |   23 +-
 drivers/net/wireless/iwlwifi/dvm/rs.h              |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c            |   27 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c            |  132 +
 drivers/net/wireless/iwlwifi/iwl-config.h          |   19 +
 drivers/net/wireless/iwlwifi/iwl-csr.h             |   66 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |    2 +
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   58 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h             |   14 +
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h    |    5 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h         |   17 +
 drivers/net/wireless/iwlwifi/iwl-fw.h              |   47 +-
 drivers/net/wireless/iwlwifi/iwl-io.c              |   19 +-
 drivers/net/wireless/iwlwifi/iwl-io.h              |    4 +
 drivers/net/wireless/iwlwifi/iwl-modparams.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |  270 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h         |   35 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |   69 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   40 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile          |    4 +-
 .../net/wireless/iwlwifi/mvm/{bt-coex.c => coex.c} |  474 ++-
 drivers/net/wireless/iwlwifi/mvm/constants.h       |    4 +
 drivers/net/wireless/iwlwifi/mvm/d3.c              |  226 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c     |  119 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c         |  485 ++-
 .../mvm/{fw-api-bt-coex.h => fw-api-coex.h}        |   21 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h       |   14 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h    |   33 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h       |    3 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h      |   31 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h       |    3 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |  134 +-
 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h   |  106 +
 drivers/net/wireless/iwlwifi/mvm/fw.c              |   79 +-
 drivers/net/wireless/iwlwifi/mvm/led.c             |    2 +
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c        |   78 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  601 +++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |  259 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c             |   87 +-
 drivers/net/wireless/iwlwifi/mvm/offloading.c      |  215 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c             |  481 ++-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c        |    4 +-
 drivers/net/wireless/iwlwifi/mvm/power.c           |  426 ++-
 drivers/net/wireless/iwlwifi/mvm/power_legacy.c    |  319 --
 drivers/net/wireless/iwlwifi/mvm/quota.c           |  100 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c              |  210 +-
 drivers/net/wireless/iwlwifi/mvm/rs.h              |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c              |   33 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c            |  255 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c             |  213 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h             |   62 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c      |    8 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c              |    7 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |   43 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c           |  138 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |   85 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h       |    4 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c             |   52 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  410 ++-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |   73 +-
 drivers/net/wireless/libertas/cfg.c                |    3 +-
 drivers/net/wireless/libertas/if_sdio.c            |    4 +-
 drivers/net/wireless/mac80211_hwsim.c              |  113 +-
 drivers/net/wireless/mac80211_hwsim.h              |    6 +
 drivers/net/wireless/mwifiex/11ac.c                |  192 +-
 drivers/net/wireless/mwifiex/11ac.h                |    2 +
 drivers/net/wireless/mwifiex/11h.c                 |    4 +-
 drivers/net/wireless/mwifiex/11n.c                 |  106 +-
 drivers/net/wireless/mwifiex/11n.h                 |   58 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |  203 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h       |    3 +-
 drivers/net/wireless/mwifiex/Makefile              |    1 +
 drivers/net/wireless/mwifiex/README                |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |  403 ++-
 drivers/net/wireless/mwifiex/cfp.c                 |  205 +-
 drivers/net/wireless/mwifiex/cmdevt.c              |  161 +-
 drivers/net/wireless/mwifiex/debugfs.c             |    8 +-
 drivers/net/wireless/mwifiex/decl.h                |   23 +
 drivers/net/wireless/mwifiex/fw.h                  |  202 +-
 drivers/net/wireless/mwifiex/ie.c                  |    6 +-
 drivers/net/wireless/mwifiex/init.c                |    8 +-
 drivers/net/wireless/mwifiex/ioctl.h               |   25 +-
 drivers/net/wireless/mwifiex/join.c                |   66 +-
 drivers/net/wireless/mwifiex/main.c                |   10 +-
 drivers/net/wireless/mwifiex/main.h                |  112 +-
 drivers/net/wireless/mwifiex/pcie.c                |  180 +-
 drivers/net/wireless/mwifiex/pcie.h                |    5 +
 drivers/net/wireless/mwifiex/scan.c                |  615 ++--
 drivers/net/wireless/mwifiex/sdio.c                |   11 +-
 drivers/net/wireless/mwifiex/sdio.h                |    6 +
 drivers/net/wireless/mwifiex/sta_cmd.c             |  471 ++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |  130 +-
 drivers/net/wireless/mwifiex/sta_event.c           |   52 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  164 +-
 drivers/net/wireless/mwifiex/sta_rx.c              |   34 +-
 drivers/net/wireless/mwifiex/sta_tx.c              |    3 +
 drivers/net/wireless/mwifiex/tdls.c                | 1044 ++++++
 drivers/net/wireless/mwifiex/uap_cmd.c             |   24 +-
 drivers/net/wireless/mwifiex/uap_event.c           |  130 +-
 drivers/net/wireless/mwifiex/uap_txrx.c            |   22 +-
 drivers/net/wireless/mwifiex/usb.c                 |   11 +-
 drivers/net/wireless/mwifiex/util.c                |  118 +-
 drivers/net/wireless/mwifiex/util.h                |   20 +-
 drivers/net/wireless/mwifiex/wmm.c                 |  131 +-
 drivers/net/wireless/mwifiex/wmm.h                 |   18 +
 drivers/net/wireless/mwl8k.c                       |  197 +-
 drivers/net/wireless/orinoco/cfg.c                 |    5 +-
 drivers/net/wireless/orinoco/hw.c                  |    2 +-
 drivers/net/wireless/orinoco/scan.c                |    5 +-
 drivers/net/wireless/orinoco/wext.c                |    2 +-
 drivers/net/wireless/p54/p54usb.c                  |    6 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |    2 +-
 drivers/net/wireless/rndis_wlan.c                  |    7 +-
 drivers/net/wireless/rsi/Kconfig                   |   30 +
 drivers/net/wireless/rsi/Makefile                  |   12 +
 drivers/net/wireless/rsi/rsi_91x_core.c            |  342 ++
 drivers/net/wireless/rsi/rsi_91x_debugfs.c         |  339 ++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        | 1008 ++++++
 drivers/net/wireless/rsi/rsi_91x_main.c            |  295 ++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            | 1304 +++++++
 drivers/net/wireless/rsi/rsi_91x_pkt.c             |  196 ++
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |  850 +++++
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |  566 +++
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  575 +++
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c         |  177 +
 drivers/net/wireless/rsi/rsi_boot_params.h         |  126 +
 drivers/net/wireless/rsi/rsi_common.h              |   87 +
 drivers/net/wireless/rsi/rsi_debugfs.h             |   48 +
 drivers/net/wireless/rsi/rsi_main.h                |  218 ++
 drivers/net/wireless/rsi/rsi_mgmt.h                |  285 ++
 drivers/net/wireless/rsi/rsi_sdio.h                |  129 +
 drivers/net/wireless/rsi/rsi_usb.h                 |   68 +
 drivers/net/wireless/rt2x00/rt2800usb.c            |   12 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |    2 +-
 drivers/net/wireless/rtl818x/Kconfig               |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/Makefile      |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         | 1009 +++++-
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h     |   76 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c     |   23 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c   |  475 +++
 drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h   |   61 +
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |   20 +-
 drivers/net/wireless/rtl818x/rtl818x.h             |  269 +-
 drivers/net/wireless/rtlwifi/Kconfig               |   27 +-
 drivers/net/wireless/rtlwifi/Makefile              |    3 +
 drivers/net/wireless/rtlwifi/btcoexist/Makefile    |    7 +
 .../net/wireless/rtlwifi/btcoexist/halbt_precomp.h |   75 +
 .../wireless/rtlwifi/btcoexist/halbtc8723b2ant.c   | 3698 ++++++++++++++++++++
 .../wireless/rtlwifi/btcoexist/halbtc8723b2ant.h   |  173 +
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c  | 1011 ++++++
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h  |  559 +++
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c   |  218 ++
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h   |   52 +
 drivers/net/wireless/rtlwifi/core.c                |  124 +-
 drivers/net/wireless/rtlwifi/core.h                |    4 +
 drivers/net/wireless/rtlwifi/pci.c                 |  131 +-
 drivers/net/wireless/rtlwifi/pci.h                 |   14 +
 drivers/net/wireless/rtlwifi/ps.c                  |  119 +-
 drivers/net/wireless/rtlwifi/ps.h                  |   60 +
 drivers/net/wireless/rtlwifi/rc.c                  |    3 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/Makefile    |    1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c        |   11 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c        |    4 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        |  128 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/phy.c       |   63 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h    |    1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h       |   16 -
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c        |    1 +
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |   14 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.h       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   34 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |   71 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |   16 -
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   31 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |   71 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |   50 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |   18 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |  429 +--
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h       |   14 -
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |   48 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |   87 +-
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       |   12 -
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile    |    1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/def.h       |    5 -
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c        |   47 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.h        |    1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c        |  260 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.h        |   18 +-
 .../wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c    |    2 +
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c   |    8 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        |  127 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c       |  530 +--
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.h       |   21 -
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h    |    1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h       |   16 -
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c        |   13 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |   11 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.h       |   13 +-
 drivers/net/wireless/rtlwifi/rtl8723be/Makefile    |   19 +
 drivers/net/wireless/rtlwifi/rtl8723be/def.h       |  248 ++
 drivers/net/wireless/rtlwifi/rtl8723be/dm.c        | 1325 +++++++
 drivers/net/wireless/rtlwifi/rtl8723be/dm.h        |  310 ++
 drivers/net/wireless/rtlwifi/rtl8723be/fw.c        |  620 ++++
 drivers/net/wireless/rtlwifi/rtl8723be/fw.h        |  248 ++
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c        | 2523 +++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723be/hw.h        |   64 +
 drivers/net/wireless/rtlwifi/rtl8723be/led.c       |  153 +
 drivers/net/wireless/rtlwifi/rtl8723be/led.h       |   35 +
 drivers/net/wireless/rtlwifi/rtl8723be/phy.c       | 2156 ++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723be/phy.h       |  217 ++
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.c    |  106 +
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h    |  304 ++
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c |  140 +
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.h |   95 +
 drivers/net/wireless/rtlwifi/rtl8723be/reg.h       | 2277 ++++++++++++
 drivers/net/wireless/rtlwifi/rtl8723be/rf.c        |  504 +++
 drivers/net/wireless/rtlwifi/rtl8723be/rf.h        |   43 +
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c        |  384 ++
 drivers/net/wireless/rtlwifi/rtl8723be/sw.h        |   35 +
 drivers/net/wireless/rtlwifi/rtl8723be/table.c     |  572 +++
 drivers/net/wireless/rtlwifi/rtl8723be/table.h     |   43 +
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c       |  960 +++++
 drivers/net/wireless/rtlwifi/rtl8723be/trx.h       |  617 ++++
 drivers/net/wireless/rtlwifi/rtl8723com/Makefile   |    9 +
 .../net/wireless/rtlwifi/rtl8723com/dm_common.c    |   65 +
 .../net/wireless/rtlwifi/rtl8723com/dm_common.h    |   33 +
 .../net/wireless/rtlwifi/rtl8723com/fw_common.c    |  329 ++
 .../net/wireless/rtlwifi/rtl8723com/fw_common.h    |  126 +
 drivers/net/wireless/rtlwifi/rtl8723com/main.c     |   33 +
 .../net/wireless/rtlwifi/rtl8723com/phy_common.c   |  434 +++
 .../net/wireless/rtlwifi/rtl8723com/phy_common.h   |   89 +
 drivers/net/wireless/rtlwifi/usb.c                 |    4 +-
 drivers/net/wireless/rtlwifi/wifi.h                |  518 ++-
 drivers/net/wireless/ti/wilink_platform_data.c     |   37 +-
 drivers/net/wireless/ti/wl1251/cmd.c               |    2 +-
 drivers/net/wireless/ti/wl1251/sdio.c              |   31 +-
 drivers/net/wireless/ti/wl1251/spi.c               |   71 +-
 drivers/net/wireless/ti/wl1251/wl1251.h            |    4 +-
 drivers/net/wireless/ti/wl12xx/main.c              |   67 +-
 drivers/net/wireless/ti/wl12xx/wl12xx.h            |   53 +
 drivers/net/wireless/ti/wl18xx/main.c              |   85 +-
 drivers/net/wireless/ti/wl18xx/tx.c                |    4 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h            |   62 +-
 drivers/net/wireless/ti/wlcore/acx.c               |    7 +-
 drivers/net/wireless/ti/wlcore/acx.h               |    6 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |   24 +-
 drivers/net/wireless/ti/wlcore/cmd.h               |    9 +-
 drivers/net/wireless/ti/wlcore/event.c             |    4 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h            |    9 +
 drivers/net/wireless/ti/wlcore/init.c              |    6 +-
 drivers/net/wireless/ti/wlcore/io.h                |    8 +-
 drivers/net/wireless/ti/wlcore/main.c              |  200 +-
 drivers/net/wireless/ti/wlcore/ps.c                |    6 +-
 drivers/net/wireless/ti/wlcore/rx.c                |   19 +-
 drivers/net/wireless/ti/wlcore/rx.h                |    2 +-
 drivers/net/wireless/ti/wlcore/spi.c               |    4 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   45 +-
 drivers/net/wireless/ti/wlcore/tx.h                |    1 +
 drivers/net/wireless/ti/wlcore/wlcore.h            |   27 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h          |   86 +-
 drivers/net/wireless/wl3501_cs.c                   |    6 +-
 drivers/net/wireless/zd1201.c                      |    9 +-
 drivers/net/xen-netback/common.h                   |  112 +-
 drivers/net/xen-netback/interface.c                |  141 +-
 drivers/net/xen-netback/netback.c                  |  813 +++--
 drivers/net/xen-netfront.c                         |   14 +-
 drivers/nfc/Kconfig                                |   12 +
 drivers/nfc/Makefile                               |    1 +
 drivers/nfc/pn533.c                                |   28 +-
 drivers/nfc/pn544/i2c.c                            |  194 +-
 drivers/nfc/pn544/pn544.c                          |    2 +-
 drivers/nfc/pn544/pn544.h                          |    3 +-
 drivers/nfc/port100.c                              |   25 +-
 drivers/nfc/trf7970a.c                             | 1370 ++++++++
 drivers/of/of_mdio.c                               |   23 +-
 drivers/of/of_net.c                                |   26 +-
 drivers/ptp/Kconfig                                |    1 +
 drivers/ptp/ptp_chardev.c                          |  128 +-
 drivers/ptp/ptp_clock.c                            |   23 +
 drivers/ptp/ptp_ixp46x.c                           |    1 +
 drivers/ptp/ptp_pch.c                              |    1 +
 drivers/ptp/ptp_private.h                          |    8 +
 drivers/ptp/ptp_sysfs.c                            |  115 +
 drivers/s390/net/qeth_core.h                       |    7 +-
 drivers/s390/net/qeth_core_main.c                  |    4 +-
 drivers/s390/net/qeth_l2_main.c                    |    6 +-
 drivers/staging/octeon/ethernet-tx.c               |    6 +-
 drivers/staging/rtl8821ae/rc.c                     |    1 -
 drivers/staging/rtl8821ae/rtl8821ae/trx.c          |    2 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |    6 +-
 drivers/staging/wlan-ng/cfg80211.c                 |    2 +-
 include/linux/brcmphy.h                            |   60 +
 include/linux/can/dev.h                            |    9 +-
 include/linux/ethtool.h                            |    3 +
 include/linux/filter.h                             |  118 +-
 include/linux/ieee80211.h                          |  239 +-
 include/linux/if_vlan.h                            |    9 +-
 include/linux/isdn_ppp.h                           |    5 +-
 include/linux/miscdevice.h                         |    1 +
 include/linux/mlx4/cmd.h                           |    8 +
 include/linux/mlx4/device.h                        |   50 +-
 include/linux/mlx4/driver.h                        |   12 +
 include/linux/mlx4/qp.h                            |   11 +-
 include/linux/mmc/sdio_ids.h                       |    1 +
 include/linux/mpls.h                               |    6 +
 include/linux/netdevice.h                          |  157 +-
 include/linux/netfilter/ipset/ip_set.h             |   15 +-
 include/linux/netfilter/nfnetlink.h                |   21 +
 include/linux/netpoll.h                            |   71 +-
 include/linux/nl802154.h                           |   12 +
 include/linux/phy.h                                |   56 +
 include/linux/ptp_classify.h                       |  103 +-
 include/linux/ptp_clock_kernel.h                   |   33 +
 include/linux/seccomp.h                            |    1 -
 include/linux/skbuff.h                             |  104 +-
 include/linux/sxgbe_platform.h                     |   54 +
 include/linux/tcp.h                                |    8 +-
 include/linux/tty.h                                |    6 +-
 include/linux/u64_stats_sync.h                     |   16 +-
 include/linux/usb/cdc_ncm.h                        |    1 +
 include/linux/wl12xx.h                             |   24 +-
 {net/ieee802154 => include/net}/6lowpan.h          |  115 +
 include/net/act_api.h                              |   22 +-
 include/net/addrconf.h                             |    6 +-
 include/net/af_ieee802154.h                        |    4 +-
 include/net/bluetooth/bluetooth.h                  |    1 +
 include/net/bluetooth/hci.h                        |   76 +-
 include/net/bluetooth/hci_core.h                   |  209 +-
 include/net/bluetooth/l2cap.h                      |    8 +-
 include/net/bluetooth/mgmt.h                       |   63 +-
 include/net/bluetooth/rfcomm.h                     |   10 +-
 include/net/cfg80211.h                             |   90 +-
 include/net/checksum.h                             |   23 +-
 include/net/dst.h                                  |   18 +-
 include/net/flow.h                                 |    6 +-
 include/net/flowcache.h                            |   25 +
 include/net/ieee80211_radiotap.h                   |    4 +
 include/net/ieee802154.h                           |   28 +-
 include/net/ieee802154_netdev.h                    |  195 +-
 include/net/ip.h                                   |   13 +-
 include/net/ip6_fib.h                              |    3 +-
 include/net/ip6_route.h                            |   14 +-
 include/net/mac80211.h                             |  101 +-
 include/net/mac802154.h                            |   41 +-
 include/net/net_namespace.h                        |    4 +
 include/net/netfilter/nf_conntrack.h               |   11 +-
 include/net/netfilter/nf_conntrack_core.h          |    9 +-
 include/net/netfilter/nf_conntrack_labels.h        |    4 +-
 include/net/netfilter/nf_tables.h                  |   28 +-
 include/net/netns/conntrack.h                      |   13 +-
 include/net/netns/ieee802154_6lowpan.h             |   22 +
 include/net/netns/xfrm.h                           |   11 +-
 include/net/nfc/digital.h                          |    7 +
 include/net/nfc/nfc.h                              |    3 +
 include/net/nl802154.h                             |    6 +-
 include/net/regulatory.h                           |   21 +-
 include/net/route.h                                |    1 -
 include/net/rtnetlink.h                            |    2 +-
 include/net/sock.h                                 |   39 +-
 include/net/tc_act/tc_csum.h                       |    4 +-
 include/net/tc_act/tc_defact.h                     |    4 +-
 include/net/tc_act/tc_gact.h                       |    4 +-
 include/net/tc_act/tc_ipt.h                        |    4 +-
 include/net/tc_act/tc_mirred.h                     |    4 +-
 include/net/tc_act/tc_nat.h                        |    4 +-
 include/net/tc_act/tc_pedit.h                      |    4 +-
 include/net/tc_act/tc_skbedit.h                    |    4 +-
 include/net/tcp.h                                  |   13 +-
 include/net/wpan-phy.h                             |   19 +-
 include/net/xfrm.h                                 |  128 +-
 include/trace/events/net.h                         |   12 +-
 include/uapi/linux/can.h                           |   32 +
 include/uapi/linux/can/netlink.h                   |    3 +
 include/uapi/linux/ethtool.h                       |  439 ++-
 include/uapi/linux/if.h                            |  134 +-
 include/uapi/linux/if_ether.h                      |    6 +-
 include/uapi/linux/if_link.h                       |    1 +
 include/uapi/linux/in.h                            |    4 +
 include/uapi/linux/in6.h                           |    4 +
 include/uapi/linux/mpls.h                          |   34 +
 include/uapi/linux/netdevice.h                     |    6 +
 include/uapi/linux/netfilter/ipset/ip_set.h        |   12 +
 include/uapi/linux/netfilter/nf_tables.h           |    6 +-
 include/uapi/linux/nfc.h                           |    9 +-
 include/uapi/linux/nl80211.h                       |   92 +-
 include/uapi/linux/pfkeyv2.h                       |   15 +-
 include/uapi/linux/ptp_clock.h                     |   39 +-
 include/uapi/linux/snmp.h                          |    6 +
 include/uapi/linux/tcp.h                           |    3 +
 include/uapi/linux/tcp_metrics.h                   |    7 +-
 include/uapi/linux/usb/cdc.h                       |   12 +
 include/uapi/linux/xfrm.h                          |   10 +
 kernel/seccomp.c                                   |  119 +-
 lib/nlattr.c                                       |   10 +-
 net/8021q/vlan.h                                   |    4 +-
 net/8021q/vlan_core.c                              |   10 +-
 net/8021q/vlan_dev.c                               |   22 +-
 net/8021q/vlan_netlink.c                           |    4 +-
 net/Kconfig                                        |    4 +
 net/appletalk/aarp.c                               |    4 +-
 net/appletalk/ddp.c                                |  100 +-
 net/atm/mpc.c                                      |    2 +-
 net/batman-adv/Kconfig                             |    9 +
 net/batman-adv/Makefile                            |    1 +
 net/batman-adv/bat_iv_ogm.c                        |   10 +-
 net/batman-adv/bridge_loop_avoidance.c             |   35 +-
 net/batman-adv/distributed-arp-table.c             |    9 +-
 net/batman-adv/distributed-arp-table.h             |    3 +
 net/batman-adv/fragmentation.c                     |    4 +-
 net/batman-adv/gateway_client.c                    |   10 +-
 net/batman-adv/icmp_socket.c                       |   11 +-
 net/batman-adv/main.c                              |   19 +-
 net/batman-adv/main.h                              |    4 +-
 net/batman-adv/multicast.c                         |  748 ++++
 net/batman-adv/multicast.h                         |   80 +
 net/batman-adv/network-coding.c                    |   26 +-
 net/batman-adv/originator.c                        |   11 +-
 net/batman-adv/packet.h                            |   53 +-
 net/batman-adv/routing.c                           |   17 +-
 net/batman-adv/send.c                              |   31 +-
 net/batman-adv/send.h                              |    7 +
 net/batman-adv/soft-interface.c                    |   48 +-
 net/batman-adv/sysfs.c                             |    6 +
 net/batman-adv/translation-table.c                 |  140 +-
 net/batman-adv/translation-table.h                 |    2 +
 net/batman-adv/types.h                             |   90 +-
 net/bluetooth/6lowpan.c                            |    2 +-
 net/bluetooth/6lowpan.h                            |   21 +
 net/bluetooth/Kconfig                              |    8 +-
 net/bluetooth/Makefile                             |    3 +-
 net/bluetooth/a2mp.c                               |   20 +-
 net/bluetooth/af_bluetooth.c                       |    2 +-
 net/bluetooth/hci_conn.c                           |  239 +-
 net/bluetooth/hci_core.c                           | 1473 ++++++--
 net/bluetooth/hci_event.c                          |  566 ++-
 net/bluetooth/hci_sock.c                           |   17 +-
 net/bluetooth/hci_sysfs.c                          |   18 +-
 net/bluetooth/l2cap_core.c                         |  706 ++--
 net/bluetooth/l2cap_sock.c                         |   69 +-
 net/bluetooth/mgmt.c                               |  974 +++++-
 net/bluetooth/rfcomm/core.c                        |   96 +-
 net/bluetooth/rfcomm/sock.c                        |   34 +-
 net/bluetooth/rfcomm/tty.c                         |  262 +-
 net/bluetooth/sco.c                                |   10 +-
 net/bluetooth/smp.c                                |  585 +++-
 net/bluetooth/smp.h                                |   21 +-
 net/bridge/br_device.c                             |   30 +-
 net/bridge/br_forward.c                            |    9 +-
 net/bridge/br_if.c                                 |    2 +-
 net/bridge/br_multicast.c                          |    4 +-
 net/bridge/br_netfilter.c                          |    4 +-
 net/bridge/br_private.h                            |    8 +-
 net/bridge/br_vlan.c                               |    8 +-
 net/bridge/netfilter/ebt_among.c                   |    2 +-
 net/bridge/netfilter/ebt_dnat.c                    |    2 +-
 net/bridge/netfilter/ebt_redirect.c                |    6 +-
 net/bridge/netfilter/ebt_snat.c                    |    2 +-
 net/ceph/osd_client.c                              |    2 -
 net/core/Makefile                                  |    1 +
 net/core/dev.c                                     |  153 +-
 net/core/filter.c                                  | 1567 +++++++--
 net/core/flow.c                                    |  132 +-
 net/core/flow_dissector.c                          |   24 +-
 net/core/neighbour.c                               |    9 +-
 net/core/net-sysfs.c                               |   22 +-
 net/core/netpoll.c                                 |  587 +---
 net/core/pktgen.c                                  |   32 +-
 net/core/ptp_classifier.c                          |  141 +
 net/core/request_sock.c                            |    1 -
 net/core/rtnetlink.c                               |  113 +-
 net/core/skbuff.c                                  |  166 +-
 net/core/sock_diag.c                               |   23 +-
 net/core/timestamping.c                            |   19 +-
 net/hsr/hsr_device.c                               |   10 +-
 net/hsr/hsr_framereg.c                             |   20 +-
 net/hsr/hsr_main.c                                 |    6 +-
 net/ieee802154/6lowpan_iphc.c                      |    3 +-
 net/ieee802154/{6lowpan.c => 6lowpan_rtnl.c}       |  388 +-
 net/ieee802154/Kconfig                             |    2 +-
 net/ieee802154/Makefile                            |    6 +-
 net/ieee802154/af802154.h                          |    5 +-
 net/ieee802154/af_ieee802154.c                     |   22 +-
 net/ieee802154/dgram.c                             |   60 +-
 net/ieee802154/header_ops.c                        |  287 ++
 net/ieee802154/ieee802154.h                        |    1 +
 net/ieee802154/netlink.c                           |    1 +
 net/ieee802154/nl-mac.c                            |  220 +-
 net/ieee802154/nl_policy.c                         |   10 +
 net/ieee802154/raw.c                               |   18 +-
 net/ieee802154/reassembly.c                        |  571 +++
 net/ieee802154/reassembly.h                        |   41 +
 net/ieee802154/wpan-class.c                        |    4 +-
 net/ipv4/Makefile                                  |    2 +-
 net/ipv4/af_inet.c                                 |    4 +-
 net/ipv4/ah4.c                                     |   78 +-
 net/ipv4/esp4.c                                    |   26 +-
 net/ipv4/fib_frontend.c                            |    2 +-
 net/ipv4/ip_forward.c                              |    7 +-
 net/ipv4/ip_output.c                               |   12 +-
 net/ipv4/ip_sockglue.c                             |   21 +-
 net/ipv4/ip_tunnel.c                               |   31 +-
 net/ipv4/ip_tunnel_core.c                          |    4 +-
 net/ipv4/ip_vti.c                                  |  310 +-
 net/ipv4/ipcomp.c                                  |   26 +-
 net/ipv4/netfilter.c                               |    2 +-
 net/ipv4/ping.c                                    |    2 +-
 net/ipv4/proc.c                                    |    6 +
 net/ipv4/raw.c                                     |    2 +-
 net/ipv4/route.c                                   |   12 -
 net/ipv4/tcp.c                                     |   13 +-
 net/ipv4/tcp_cong.c                                |   10 -
 net/ipv4/tcp_cubic.c                               |    4 -
 net/ipv4/tcp_highspeed.c                           |    1 -
 net/ipv4/tcp_hybla.c                               |   13 +-
 net/ipv4/tcp_illinois.c                            |    2 -
 net/ipv4/tcp_input.c                               |  187 +-
 net/ipv4/tcp_ipv4.c                                |    8 +-
 net/ipv4/tcp_lp.c                                  |    2 -
 net/ipv4/tcp_metrics.c                             |   83 +-
 net/ipv4/tcp_minisocks.c                           |    4 +-
 net/ipv4/tcp_output.c                              |   71 +-
 net/ipv4/tcp_probe.c                               |    2 +-
 net/ipv4/tcp_scalable.c                            |    1 -
 net/ipv4/tcp_timer.c                               |    3 +
 net/ipv4/tcp_vegas.c                               |    2 -
 net/ipv4/tcp_veno.c                                |    1 -
 net/ipv4/tcp_westwood.c                            |    1 -
 net/ipv4/tcp_yeah.c                                |    2 -
 net/ipv4/udp.c                                     |    3 +-
 net/ipv4/xfrm4_input.c                             |    9 -
 net/ipv4/xfrm4_mode_tunnel.c                       |   68 -
 net/ipv4/xfrm4_policy.c                            |    1 +
 net/ipv4/xfrm4_protocol.c                          |  286 ++
 net/ipv6/Makefile                                  |    2 +-
 net/ipv6/addrlabel.c                               |   59 +-
 net/ipv6/ah6.c                                     |   80 +-
 net/ipv6/esp6.c                                    |   26 +-
 net/ipv6/icmp.c                                    |    2 +-
 net/ipv6/ip6_checksum.c                            |    4 +-
 net/ipv6/ip6_fib.c                                 |  121 +-
 net/ipv6/ip6_flowlabel.c                           |    6 -
 net/ipv6/ip6_gre.c                                 |    9 +-
 net/ipv6/ip6_output.c                              |   19 +-
 net/ipv6/ip6_tunnel.c                              |   13 +-
 net/ipv6/ip6_vti.c                                 |  316 +-
 net/ipv6/ipcomp6.c                                 |   22 +-
 net/ipv6/ipv6_sockglue.c                           |    2 +-
 net/ipv6/mcast.c                                   |   11 +-
 net/ipv6/output_core.c                             |   27 +-
 net/ipv6/ping.c                                    |    4 +-
 net/ipv6/route.c                                   |   50 +-
 net/ipv6/sit.c                                     |   18 +-
 net/ipv6/tcp_ipv6.c                                |   46 +-
 net/ipv6/xfrm6_mode_tunnel.c                       |   63 -
 net/ipv6/xfrm6_policy.c                            |    7 +
 net/ipv6/xfrm6_protocol.c                          |  270 ++
 net/ipx/af_ipx.c                                   |   28 +-
 net/iucv/af_iucv.c                                 |    1 +
 net/key/af_key.c                                   |   39 +-
 net/l2tp/l2tp_core.c                               |   24 +-
 net/l2tp/l2tp_ppp.c                                |    3 -
 net/mac80211/agg-tx.c                              |    2 +-
 net/mac80211/cfg.c                                 |  306 +-
 net/mac80211/cfg.h                                 |    2 +-
 net/mac80211/chan.c                                |    2 +
 net/mac80211/debugfs_netdev.c                      |   13 +
 net/mac80211/debugfs_sta.c                         |    2 +-
 net/mac80211/driver-ops.h                          |   12 +-
 net/mac80211/ht.c                                  |    4 +-
 net/mac80211/ibss.c                                |   45 +-
 net/mac80211/ieee80211_i.h                         |   17 +-
 net/mac80211/iface.c                               |   13 +-
 net/mac80211/main.c                                |   21 +-
 net/mac80211/mesh.c                                |   96 +-
 net/mac80211/mlme.c                                |  179 +-
 net/mac80211/pm.c                                  |   14 +-
 net/mac80211/rate.c                                |   46 +-
 net/mac80211/rate.h                                |    2 +-
 net/mac80211/rc80211_minstrel.c                    |    2 +-
 net/mac80211/rc80211_minstrel.h                    |    2 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    7 +-
 net/mac80211/rc80211_pid_algo.c                    |    2 +-
 net/mac80211/rx.c                                  |  109 +-
 net/mac80211/scan.c                                |   15 +-
 net/mac80211/sta_info.h                            |    2 +
 net/mac80211/status.c                              |    3 +-
 net/mac80211/tx.c                                  |   35 +-
 net/mac80211/util.c                                |   42 +-
 net/mac80211/vht.c                                 |   26 +-
 net/mac80211/wpa.c                                 |    9 +-
 net/mac802154/Makefile                             |    2 +
 net/mac802154/ieee802154_dev.c                     |   85 +-
 net/mac802154/mac802154.h                          |   19 +-
 net/mac802154/mac_cmd.c                            |    5 +-
 net/mac802154/mib.c                                |   26 +-
 net/mac802154/rx.c                                 |    1 -
 net/mac802154/wpan.c                               |  457 ++-
 net/netfilter/ipset/Kconfig                        |    9 +
 net/netfilter/ipset/Makefile                       |    1 +
 net/netfilter/ipset/ip_set_core.c                  |   54 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   43 +
 net/netfilter/ipset/ip_set_hash_ip.c               |    3 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c           |  321 ++
 net/netfilter/ipset/ip_set_hash_ipport.c           |    3 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c         |    3 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |    3 +-
 net/netfilter/ipset/ip_set_hash_net.c              |    3 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |    3 +-
 net/netfilter/ipset/ip_set_hash_netnet.c           |   10 +-
 net/netfilter/ipset/ip_set_hash_netport.c          |    3 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c       |    3 +-
 net/netfilter/ipset/pfxlen.c                       |    4 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    6 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |   13 +-
 net/netfilter/nf_conntrack_core.c                  |  432 ++-
 net/netfilter/nf_conntrack_expect.c                |   36 +-
 net/netfilter/nf_conntrack_h323_main.c             |    4 +-
 net/netfilter/nf_conntrack_helper.c                |   41 +-
 net/netfilter/nf_conntrack_netlink.c               |  133 +-
 net/netfilter/nf_conntrack_sip.c                   |    8 +-
 net/netfilter/nf_tables_api.c                      |   80 +-
 net/netfilter/nfnetlink.c                          |    8 +
 net/netfilter/nfnetlink_log.c                      |    8 -
 net/netfilter/nft_compat.c                         |    4 +-
 net/netfilter/nft_ct.c                             |   36 +-
 net/netfilter/nft_hash.c                           |  261 +-
 net/netfilter/nft_immediate.c                      |    3 +-
 net/netfilter/nft_log.c                            |    3 +-
 net/netfilter/nft_lookup.c                         |    5 +-
 net/netfilter/nft_nat.c                            |   22 +-
 net/netfilter/xt_AUDIT.c                           |    4 +-
 net/netfilter/xt_connlimit.c                       |  311 +-
 net/netfilter/xt_ipcomp.c                          |    2 +-
 net/netlink/af_netlink.c                           |   31 +-
 net/netlink/af_netlink.h                           |    1 +
 net/nfc/core.c                                     |   10 +-
 net/nfc/digital.h                                  |    6 +
 net/nfc/digital_core.c                             |   67 +-
 net/nfc/digital_technology.c                       |  247 +-
 net/nfc/hci/llc.c                                  |    4 +-
 net/nfc/llcp_core.c                                |   16 +-
 net/nfc/nci/core.c                                 |    3 +-
 net/nfc/nci/spi.c                                  |    3 +-
 net/nfc/netlink.c                                  |    8 +
 net/openvswitch/datapath.c                         |   20 +-
 net/openvswitch/datapath.h                         |    2 +-
 net/openvswitch/vport.c                            |   14 +-
 net/packet/af_packet.c                             |   59 +-
 net/rds/iw.c                                       |    3 +-
 net/rfkill/core.c                                  |    9 +-
 net/rxrpc/Makefile                                 |    5 +-
 net/rxrpc/af_rxrpc.c                               |    9 +
 net/rxrpc/ar-ack.c                                 |   61 +-
 net/rxrpc/ar-call.c                                |  213 +-
 net/rxrpc/ar-connection.c                          |   10 +-
 net/rxrpc/ar-error.c                               |    1 +
 net/rxrpc/ar-input.c                               |  190 +-
 net/rxrpc/ar-internal.h                            |   40 +-
 net/rxrpc/ar-output.c                              |   15 +-
 net/rxrpc/ar-recvmsg.c                             |   25 +-
 net/rxrpc/ar-skbuff.c                              |    7 +-
 net/rxrpc/ar-transport.c                           |   10 +-
 net/rxrpc/sysctl.c                                 |  146 +
 net/sched/act_api.c                                |  142 +-
 net/sched/act_csum.c                               |   31 +-
 net/sched/act_gact.c                               |   34 +-
 net/sched/act_ipt.c                                |   68 +-
 net/sched/act_mirred.c                             |   56 +-
 net/sched/act_nat.c                                |   33 +-
 net/sched/act_pedit.c                              |   45 +-
 net/sched/act_police.c                             |   22 +-
 net/sched/act_simple.c                             |   64 +-
 net/sched/act_skbedit.c                            |   36 +-
 net/sched/cls_fw.c                                 |   33 +-
 net/sched/sch_api.c                                |    8 +-
 net/sched/sch_atm.c                                |    3 +-
 net/sched/sch_cbq.c                                |    6 +-
 net/sched/sch_fq.c                                 |    3 +-
 net/sched/sch_fq_codel.c                           |    3 +-
 net/sched/sch_generic.c                            |    2 +
 net/sched/sch_hfsc.c                               |    3 +-
 net/sched/sch_hhf.c                                |    3 +-
 net/sched/sch_htb.c                                |   20 +-
 net/sched/sch_ingress.c                            |    3 +-
 net/sched/sch_netem.c                              |   79 +-
 net/sched/sch_tbf.c                                |   26 +-
 net/sctp/associola.c                               |    3 +-
 net/sctp/transport.c                               |    1 -
 net/socket.c                                       |   18 +-
 net/tipc/addr.h                                    |    2 +
 net/tipc/bcast.c                                   |   41 +-
 net/tipc/bcast.h                                   |    4 +-
 net/tipc/bearer.c                                  |   96 +-
 net/tipc/bearer.h                                  |   13 +-
 net/tipc/config.c                                  |  107 +-
 net/tipc/config.h                                  |    5 -
 net/tipc/core.c                                    |   11 +-
 net/tipc/core.h                                    |    1 -
 net/tipc/discover.c                                |   23 +-
 net/tipc/discover.h                                |    5 +-
 net/tipc/link.c                                    |  620 ++--
 net/tipc/link.h                                    |   57 +-
 net/tipc/name_distr.c                              |   22 +-
 net/tipc/name_distr.h                              |    2 +-
 net/tipc/net.c                                     |   19 +-
 net/tipc/node.c                                    |  119 +-
 net/tipc/node.h                                    |    6 +-
 net/tipc/port.c                                    |  301 +-
 net/tipc/port.h                                    |  130 +-
 net/tipc/ref.c                                     |   27 +-
 net/tipc/ref.h                                     |    1 -
 net/tipc/socket.c                                  |  414 ++-
 net/tipc/socket.h                                  |   72 +
 net/wireless/ap.c                                  |   10 +-
 net/wireless/chan.c                                |   87 +-
 net/wireless/core.c                                |    4 +-
 net/wireless/core.h                                |   17 +-
 net/wireless/genregdb.awk                          |   10 +-
 net/wireless/ibss.c                                |   34 +-
 net/wireless/mesh.c                                |   12 +-
 net/wireless/mlme.c                                |    4 +-
 net/wireless/nl80211.c                             |  272 +-
 net/wireless/nl80211.h                             |    2 +
 net/wireless/rdev-ops.h                            |    9 +-
 net/wireless/reg.c                                 |  297 +-
 net/wireless/reg.h                                 |    3 +-
 net/wireless/scan.c                                |   31 +-
 net/wireless/sme.c                                 |    1 -
 net/wireless/trace.h                               |   35 +-
 net/wireless/util.c                                |   57 +-
 net/wireless/wext-sme.c                            |    2 +-
 net/xfrm/xfrm_input.c                              |   97 +-
 net/xfrm/xfrm_policy.c                             |   40 +-
 net/xfrm/xfrm_state.c                              |   72 +-
 net/xfrm/xfrm_user.c                               |   37 +-
 security/selinux/include/xfrm.h                    |    5 +-
 tools/net/bpf_dbg.c                                |  119 +-
 1388 files changed, 99887 insertions(+), 30802 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net
 create mode 100644 Documentation/devicetree/bindings/net/altera_tse.txt
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-bcmgenet.txt
 create mode 100644 Documentation/devicetree/bindings/net/ethernet.txt
 create mode 100644 Documentation/devicetree/bindings/net/micrel.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt
 create mode 100644 Documentation/devicetree/bindings/net/samsung-sxgbe.txt
 create mode 100644 Documentation/devicetree/bindings/net/sh_eth.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
 create mode 100644 Documentation/networking/altera_tse.txt
 delete mode 100644 drivers/net/can/sja1000/sja1000_of_platform.c
 create mode 100644 drivers/net/ethernet/altera/Kconfig
 create mode 100644 drivers/net/ethernet/altera/Makefile
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma.c
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma.h
 create mode 100644 drivers/net/ethernet/altera/altera_msgdmahw.h
 create mode 100644 drivers/net/ethernet/altera/altera_sgdma.c
 create mode 100644 drivers/net/ethernet/altera/altera_sgdma.h
 create mode 100644 drivers/net/ethernet/altera/altera_sgdmahw.h
 create mode 100644 drivers/net/ethernet/altera/altera_tse.h
 create mode 100644 drivers/net/ethernet/altera/altera_tse_ethtool.c
 create mode 100644 drivers/net/ethernet/altera/altera_tse_main.c
 create mode 100644 drivers/net/ethernet/altera/altera_utils.c
 create mode 100644 drivers/net/ethernet/altera/altera_utils.h
 create mode 100644 drivers/net/ethernet/broadcom/genet/Makefile
 create mode 100644 drivers/net/ethernet/broadcom/genet/bcmgenet.c
 create mode 100644 drivers/net/ethernet/broadcom/genet/bcmgenet.h
 create mode 100644 drivers/net/ethernet/broadcom/genet/bcmmii.c
 delete mode 100644 drivers/net/ethernet/freescale/gianfar_sysfs.c
 create mode 100644 drivers/net/ethernet/samsung/Kconfig
 create mode 100644 drivers/net/ethernet/samsung/Makefile
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/Kconfig
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/Makefile
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.h
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_dma.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_dma.h
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_mtl.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_mtl.h
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_reg.h
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_xpcs.c
 create mode 100644 drivers/net/ethernet/samsung/sxgbe/sxgbe_xpcs.h
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
 create mode 100644 drivers/net/phy/bcm7xxx.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-beacon.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-beacon.h
 create mode 100644 drivers/net/wireless/ath/ath9k/common-init.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-init.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/rc.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/rc.h
 create mode 100644 drivers/net/wireless/ath/wil6210/rx_reorder.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/chip.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/chip.h
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-8000.c
 rename drivers/net/wireless/iwlwifi/mvm/{bt-coex.c => coex.c} (65%)
 rename drivers/net/wireless/iwlwifi/mvm/{fw-api-bt-coex.h => fw-api-coex.h} (96%)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/offloading.c
 delete mode 100644 drivers/net/wireless/iwlwifi/mvm/power_legacy.c
 create mode 100644 drivers/net/wireless/mwifiex/tdls.c
 create mode 100644 drivers/net/wireless/rsi/Kconfig
 create mode 100644 drivers/net/wireless/rsi/Makefile
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_core.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_debugfs.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_mac80211.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_main.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_mgmt.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_pkt.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_sdio.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_usb.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_usb_ops.c
 create mode 100644 drivers/net/wireless/rsi/rsi_boot_params.h
 create mode 100644 drivers/net/wireless/rsi/rsi_common.h
 create mode 100644 drivers/net/wireless/rsi/rsi_debugfs.h
 create mode 100644 drivers/net/wireless/rsi/rsi_main.h
 create mode 100644 drivers/net/wireless/rsi/rsi_mgmt.h
 create mode 100644 drivers/net/wireless/rsi/rsi_sdio.h
 create mode 100644 drivers/net/wireless/rsi/rsi_usb.h
 create mode 100644 drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c
 create mode 100644 drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/trx.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723com/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723com/dm_common.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723com/dm_common.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723com/main.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723com/phy_common.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8723com/phy_common.h
 create mode 100644 drivers/nfc/trf7970a.c
 create mode 100644 include/linux/mpls.h
 create mode 100644 include/linux/sxgbe_platform.h
 rename {net/ieee802154 => include/net}/6lowpan.h (81%)
 create mode 100644 include/net/flowcache.h
 create mode 100644 include/net/netns/ieee802154_6lowpan.h
 create mode 100644 include/uapi/linux/mpls.h
 create mode 100644 net/batman-adv/multicast.c
 create mode 100644 net/batman-adv/multicast.h
 create mode 100644 net/core/ptp_classifier.c
 rename net/ieee802154/{6lowpan.c => 6lowpan_rtnl.c} (65%)
 create mode 100644 net/ieee802154/header_ops.c
 create mode 100644 net/ieee802154/reassembly.c
 create mode 100644 net/ieee802154/reassembly.h
 create mode 100644 net/ipv4/xfrm4_protocol.c
 create mode 100644 net/ipv6/xfrm6_protocol.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipmark.c
 create mode 100644 net/rxrpc/sysctl.c
 create mode 100644 net/tipc/socket.h
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
