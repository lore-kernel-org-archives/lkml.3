Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaFLTO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:14:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53784 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFLTOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:14:50 -0400
Date: Thu, 12 Jun 2014 12:14:45 -0700 (PDT)
Message-Id: <20140612.121445.484288603919840829.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Jun 2014 12:14:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5CJFEU0008609


1) Seccomp BPF filters can now be JIT'd, from Alexei Starovoitov.

2) Multiqueue support in xen-netback and xen-netfront, from Andrew
   J. Benniston.

3) Allow tweaking of aggregation settings in cdc_ncm driver, from
   Bj√∏rn Mork.

4) BPF now has a "random" opcode, from Chema Gonzalez.

5) Add more BPF documentation and improve test framework, from Daniel
   Borkmann.

6) Support TCP fastopen over ipv6, from Daniel Lee.

7) Add software TSO helper functions and use them to support software TSO
   in mvneta and mv643xx_eth drivers.  From Ezequiel Garcia.

8) Support software TSO in fec driver too, from Nimrod Andy.

9) Add Broadcom SYSTEMPORT driver, from Florian Fainelli.

10) Handle broadcasts more gracefully over macvlan when there are
    large numbers of interfaces configured, from Herbert Xu.

11) Allow more control over fwmark used for non-socket based responses,
    from Lorenzo Colitti.

12) Do TCP congestion window limiting based upon measurements, from Neal
    Cardwell.

13) Support busy polling in SCTP, from Neal Horman.

14) Allow RSS key to be configured via ethtool, from Venkata Duvvuru.

15) Bridge promisc mode handling improvements from Vlad Yasevich.

16) Don't use inetpeer entries to implement ID generation any more, it
    performs poorly, from Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit cae61ba37b4c2672704cbd8a626fbd85be7e67d9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-06-02 18:16:41 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to e5eca6d41f53db48edd8cf88a3f59d2c30227f8e:

  rtnetlink: fix userspace API breakage for iproute2 < v3.9.0 (2014-06-12 11:07:42 -0700)

----------------------------------------------------------------
Adam Lee (6):
      Revert "rtlwifi: rtl8188ee: enable MSI interrupts mode"
      rtlwifi: rtl8723be: disable MSI interrupts mode
      rtlwifi: make MSI support a module parameter
      rtlwifi: rtl8188ee: add msi module parameter
      rtlwifi: rtl8723be: add msi module parameter
      Bluetooth: ath3k: no need to set same pipe multiple times

Akeem G Abodunrin (4):
      i40e: Tx/Rx rings declaration
      i40e: Clear recovery pending, if reset failed
      i40e/i40evf: Clean up a few things
      i40e: Fix incorrect feature configuration status

Alexander Aring (16):
      at86rf230: use irq_get_trigger_type
      devicetree: add at86rf230 bindings
      at86rf230: remove irq_type in request_irq
      at86rf230: use devm_request_irq
      at86rf230: use devm_gpio_request_one
      at86rf230: add missing MODULE_DEVICE_TABLE
      at86rf230: make of_device_id const
      at86rf230: add at86rf230_device_id table
      at86rf230: remove #ifdef CONFIG_OF
      at86rf230: remove unnecessary assign
      at86rf230: reset irq line before irq request
      at86rf230: remove unnecessary spi_set_drvdata
      at86rf230: remove unnecessary state read
      at86rf230: remove function for setting irq polarity
      6lowpan_rtnl: fix fragmentation with two fragments
      6lowpan_rtnl: fix off by one while fragmentation

Alexander Duyck (2):
      net: Add support for device specific address syncing
      enic: Update driver to use __dev_uc/mc_sync/unsync calls

Alexander Gordeev (2):
      qlcnic: Use pci_enable_msix_exact() instead of pci_enable_msix()
      i40evf: Use pci_enable_msix_range() instead of pci_enable_msix()

Alexander Shiyan (3):
      can: mcp251x: Check return value of spi_setup()
      can: mcp251x: Improve mcp251x_hw_reset()
      can: mcp251x: Improve mcp251x_hw_probe()

Alexander Stein (1):
      can: c_can: Add support for eg20t (pch_can)

Alexei Starovoitov (19):
      net: filter: doc: expand and improve BPF documentation
      net: filter: make BPF conversion more readable
      net: filter: BPF testsuite
      net: filter: additional BPF tests
      net: filter: x86: split bpf_jit_compile()
      net: filter: x86: internal BPF JIT
      seccomp: JIT compile seccomp filter
      tools: bpf_jit_disasm: ignore image address for disasm
      tools: bpf_jit_disasm: increase image buffer size
      net: bridge: fix build
      net: filter: cleanup invocation of internal BPF
      net: filter: fix SKF_AD_PKTTYPE extension on big-endian
      net: filter: fix typo in sparc BPF JIT
      net: filter: fix sparc32 typo
      net: filter: cleanup A/X name usage
      net: filter: fix nlattr and nlattr_nest BPF tests
      net: filter: fix warning on 32-bit arch
      net: filter: mention eBPF terminology as well
      net: filter: document internal instruction encoding

Alexey Charkov (5):
      net: via-rhine: switch to generic DMA functions
      net: via-rhine: reduce usage of the PCI-specific struct
      net: via-rhine: add OF bus binding
      net: via-rhine: Drop revision property, use quirks instead
      net: via-rhine: Convert #ifdef USE_MMIO to a runtime flag

Alexey Khoroshilov (1):
      carl9170: fix leaks at failure path in carl9170_usb_probe()

Amir Vadai (4):
      net/mlx4_core: Deprecate use_prio module parameter
      net/mlx4_core: Replace pr_warning() with pr_warn()
      cpumask: Utility function to set n'th cpu - local cpu first
      cpumask: Utility function to set n'th cpu - local cpu first

Amitkumar Karwar (12):
      mwifiex: increase SDIO multiport aggregation buffer sizes
      mwifiex: improve AMSDU packet aggregation for PCIe and SDIO
      mwifiex: increase the number of nodes in command pool
      mwifiex: use USB core's soft_unbind option
      mwifiex: remove redundant 'fw_load' completion structure
      mwifiex: fix IE parsing issues
      mwifiex: don't clear cmd_sent flag in timeout handler
      mwifiex: add fw_dump debugfs file
      mwifiex: add firmware dump feature for PCIe
      mwifiex: increase tx/rx AMPDU window sizes for STA 11n mode
      mwifiex: increase tx/rx AMPDU window sizes for STA 11ac mode
      mwifiex: enable aggregation for TID 6 and 7 streams

Amos Kong (2):
      mvme147: fix ram size in comment
      hplance: fix ram size in comment

Andi Kleen (1):
      e1000e: Out of line __ew32_prepare/__ew32

Andre Guedes (1):
      Bluetooth: Use memdup_user in le_auto_conn_write()

Andrea Merello (10):
      rtl8180: fix enabled interrupt mask for rtl8187se
      rtl8180: add parentheses to REG_ADDR macros
      rtl8180: be paranoid in stopping unused queues.
      rtl8187: report mac80211 short preamble RX flag
      rtl8180: report mac80211 short preamble RX flag
      rtl8180: make CTS-to-self protection work
      rtl8187: make CTS-to-self protection work
      at76c50x-usb: Don't perform DMA from stack memory
      at76c50x-usb: Make WEP encryption working.
      at76c50x: fix scan does not work with latest mac80211

Andrei Otcheretianski (7):
      iwlwifi:mvm: Add AP/GO channel switch support
      cfg80211: Add API to update CSA counters in mgmt frames
      mac80211: Update CSA counters in mgmt frames
      cfg80211: Support multiple CSA counters
      mac80211: Support multiple CSA counters
      mac80211: Provide ieee80211_beacon_get_template API
      mac80211: Handle the CSA counters correctly

Andrew J. Bennieston (5):
      xen-netback: Move grant_copy_op array back into struct xenvif.
      xen-netback: Add support for multiple queues
      xen-netfront: Factor queue-specific data into queue struct.
      xen-netfront: Add support for multiple queues
      xen-net{back, front}: Document multi-queue feature in netif.h

Andrew Morton (1):
      lib/test_bpf.c: don't use gcc union shortcut

Andrew Ruder (6):
      dm9000: acquire irq flags from device tree
      dm9000: clean up reset code
      dm9000: clean up edge-triggered irq compatibility
      dm9000: remove redundant ISR status clear
      dm9000: handle initial link status
      dm9000: avoid sleeping in dm9000_timeout callback

Andrzej Kaczmarek (8):
      Bluetooth: Store RSSI for connection
      Bluetooth: Store TX power level for connection
      Bluetooth: Add conn info lifetime parameters to debugfs
      Bluetooth: Add support to get connection information
      Bluetooth: Avoid polling TX power for LE links
      Bluetooth: Store max TX power level for connection
      Bluetooth: Add support for max_tx_power in Get Conn Info
      Bluetooth: Add missing msecs to jiffies conversion

Andy Fleming (1):
      net/fsl: xgmac_mdio is dependent on OF_MDIO

Andy Spencer (1):
      RTL8192CU: Increase max APFM_ONMAC polling count

Anjali Singhai Jain (12):
      i40e: Fix an issue with displaying IPv4 FD filters
      i40e: Do not enable NTUPLE feature control in MFP mode
      i40e: Do not expose fd-sb commands from debugfs
      i40e: Report cmd->data in ETHTOOL_GRXCLSRLCNT instead of ETHTOOL_GRXCLSRULE
      i40e: Use the new i40e_get_fd_cnt_all function in other places
      i40e/i40evf: Fix code to accommodate i40e_register.h changes
      i40e: Changes to Interrupt distribution policy
      i40e: Do not fall back to one queue model if the only feature enabled is ATR
      i40e: Allow RSS table entry range and GPS to be any number, not necessarily power of 2
      i40e: Change the notion of src and dst for FD_SB in ethtool
      i40e/i40evf: Add Flow director stats to PF stats
      i40e: Fix a bug in ethtool for FD drop packet filter action

Antonio Ospite (1):
      trivial: drivers/net/ethernet/nvidia/forcedeth.c: fix typo s/SUBSTRACT1/SUBTRACT1/

Antonio Quartulli (5):
      batman-adv: add blank line between declarations and the rest of the code
      batman-adv: remove semi-colon after macro definition
      cfg80211: export expected throughput through get_station()
      mac80211: export the expected throughput
      cfg80211: implement cfg80211_get_station cfg80211 API

Arend van Spriel (21):
      brcmfmac: enhance nvram processing
      brcmfmac: remove usage of cfg80211_get_chandef_type()
      brcm80211: extend channel conversion functions for 80MHz support
      brcmfmac: provide VHT capability information to user-space
      brcmfmac: enable 80Mhz in 5G custom regulatory rules
      brcmfmac: get rid of brcmf_cfg80211_set_channel() function
      brcmfmac: handle 80MHz chanspecs in construct_reg_info() function
      brcmfmac: determine chanspec from struct cfg80211_chan_def info
      brcmfmac: reduce log level for invalid scheduled scan request
      brcmfmac: restore mpc before passing scan status to cfg80211
      brcmfmac: make chandef_to_chanspec() function static
      brcmfmac: remove .init() callback for internal bus interface
      brcmfmac: rename nvram.[ch] for upcoming firmware handling functions
      brcmfmac: call brcmf_detach() unconditional in sdio .remove() callback
      brcmfmac: rework usb callback operations
      brcmfmac: introduce asynchronous firmware loading
      brcmfmac: use asynchronous firmware request in SDIO
      brcmfmac: use asynchronous firmware request in USB
      brcmfmac: make brcmf_fw_nvram_strip() static
      brcmutil: assure unused bits are cleared in 11n chanspec
      brcmfmac: remove firmware list from USB driver

Ariel Elior (2):
      bnx2x: update MAINTAINERS for bnx2x and e-mail addresses
      bnx2x: Enlarge the dorq threshold for VFs

Arik Nemtsov (6):
      cfg80211: avoid freeing last_request while in flight
      mac80211: set an external flag for TDLS stations
      mac80211: move TDLS code to another file
      cfg80211: don't set reg timeout for user-handled hint
      iwlwifi: mvm: remove vif argument from power_update_mac
      mac80211: don't check netdev state for debugfs read/write

Arnaldo Carvalho de Melo (1):
      tipc: Don't reset the timeout when restarting

Arnd Bergmann (2):
      mdio_bus: fix devm_mdiobus_alloc_size export
      net: xen-netback: include linux/vmalloc.h again

Arturo Borrero (1):
      netfilter: nf_tables: add set_elem notifications

Ashish Shah (1):
      i40e/i40evf: set headwb Tx context flags and use them

Avinash Patil (13):
      mwifiex: update timestamp information for aggregation packets
      mwifiex: configure inactivity timeout for TDLS link
      mwifiex: disable TDLS link upon tear down event
      mwifiex: add HT operation IE in TDLS setup confirm
      mwifiex: restore current SDIO write port in failure cases
      mwifiex: set valid tx_param during mwifiex_send_null_packet
      mwifiex: avoid TDLS check for packets destined to AP
      mwifiex: silence TDLS link delete failure for nonexistent link
      mwifiex: delete TDLS link upon Teardown event
      mwifiex: set TDLS flags for AMSDU packets
      mwifiex: update seq number correctly for packets from TDLS peer
      mwifiex: fix a crash in extended scan event processing
      mwifiex: set TDLS link for newly created RA list

Avraham Stern (1):
      mac80211: set new interfaces as idle upon init

Avri Altman (6):
      iwlwifi: mvm: Handle power management constraints for additional use-cases
      iwlwifi: mvm: Re-factor enabling uAPSD logic
      iwlwifi: mvm: Add power management support for P2P DCM
      iwlwifi: mvm: Disable uAPSD for a DCM client
      iwlwifi: mvm: Remove redundant initialization
      iwlwifi: mvm: don't filter out the first beacon

Balakumaran Kannan (1):
      net: driver: smsc: set NOCARRIER flag in dev at driver initialization

Bartosz Markowski (2):
      ath10k: update wal_dbg_tx_stats structure with missing parameter.
      ath10k: get rid of pci_assign_resource() call from pci_probe

Ben Dooks (1):
      sh_eth: use RNC mode for packet reception

Ben Greear (8):
      ath10k: better firmware loading error messages
      ath10k: add otp and firmware boot error messages
      ath10k: fix getting stats from firmware
      ath10k: add the Rx rate in FW stats
      ath9k: Prevent divide-by-zero upon bad beacon_interval.
      ath10k: fix spelling mistake in comments
      ath10k: support get/set antenna configurations.
      ath10k: ensure rx-frag ignores rssi

Ben Hutchings (9):
      ethtool: Return immediately on error in ethtool_copy_validate_indir()
      ethtool: Name the 'no change' value for setting RSS hash key but not indir table
      ethtool: Improve explanation of the two arrays following struct ethtool_rxfh
      ethtool: Expand documentation of ethtool_ops::{get,set}_rxfh()
      ethtool: Disallow ETHTOOL_SRSSH with both indir table and hash key unchanged
      ethtool, be2net: constify array pointer parameters to ethtool_ops::set_rxfh
      ethtool: Replace ethtool_ops::{get,set}_rxfh_indir() with {get,set}_rxfh()
      ethtool: Check that reserved fields of struct ethtool_rxfh are 0
      farsync: Fix confusion about DMA address and buffer offset types

Beniamino Galvani (2):
      arc_emac: implement promiscuous mode and multicast filtering
      arc_emac: add netpoll support

Benoit Taine (3):
      wcn36xx: Use kmemdup instead of kmalloc + memcpy
      r8152: Use kmemdup instead of kmalloc + memcpy
      lpc_eth: Use resource_size instead of computation

Bing Zhao (3):
      Bluetooth: btmrvl: separate write-to-clear function from interrupt handler
      Bluetooth: btmrvl: implement read-to-clear for SD8897 interrupts
      mwifiex: change hscfg gap parameter to avoid potential firmware deadlock

Bj√∏rn Mork (26):
      net: cdc_mbim: optionally use VLAN ID 4094 for IP session 0
      net: cdc_mbim: reject IP packets on DSS VLANs
      net: cdc_mbim: add driver documentation
      net: cdc_ncm/cdc_mbim: rework probing of NCM/MBIM functions
      net: cdc_ncm: split out rx_max/tx_max update of setup
      net: cdc_ncm: factor out one-time device initialization
      net: cdc_ncm: split .bind device initialization
      net: cdc_ncm: support rx_max/tx_max updates when running
      net: cdc_ncm: use ethtool to tune coalescing settings
      net: cdc_ncm: use true max dgram count for header estimates
      net: cdc_ncm: set reasonable padding limits
      net: cdc_ncm/cdc_mbim: adding NCM protocol statistics
      net: cdc_ncm: use sane defaults for rx/tx buffers
      net: cdc_ncm: fix argument alignment
      net: cdc_ncm: remove redundant "disconnected" flag
      net: cdc_ncm: do not start timer on an empty skb
      net: cdc_ncm: fix 64bit division build error
      net: cdc_ncm: reduce skb truesize in rx path
      net: cdc_ncm: always reallocate tx_curr_skb when tx_max increases
      net: cdc_ncm: inform usbnet when rx buffers are reduced
      net: cdc_ncm: use sysfs for rx/tx aggregation tuning
      net: cdc_ncm: drop ethtool coalesce support
      net: cdc_ncm: export NCM Transfer Block (NTB) parameters
      net: cdc_ncm: allow tuning min_tx_pkt
      net: cdc_ncm: document the sysfs API
      net: qmi_wwan: add Olivetti Olicard modems

Bob Copeland (3):
      mac80211: mesh: use u16 return type for u16 getter
      mac80211: fix mesh_add_rsn_ie IE finding loop
      mac80211: mesh: always use the latest target_sn

Carolyn Wyborny (16):
      igb: Cleanups for messaging
      igb: Cleanups to fix braces location warnings
      igb: Cleanups to fix incorrect indentation
      igb: Cleanups to fix pointer location error
      igb: Cleanups to fix for trailing statement
      igb: Cleanups to change comment style on license headers
      igb: Cleanups to fix assignment in if error
      igb: Cleanups to fix missing break in switch statements
      igb: Cleanups to remove return parentheses
      igb: Cleanups to fix line length warnings
      igb: Cleanups to fix msleep warnings
      igb: Cleanups to fix static initialization
      igb: Cleanups to replace deprecated DEFINE_PCI_DEVICE_TABLE
      igb: Cleanups to remove unneeded extern declaration
      igb: Replace 1/0 return values with true/false
      igb: Change memcpy to struct assignment

Catherine Sullivan (11):
      i40e/i40evf: Bump build versions
      i40e: Remove a FW workaround
      i40e: Cleanup if/else statements
      i40e: Tweak for-loop in i40e_ethtool.c
      i40e/i40evf: Bump build versions
      i40e/i40evf: Bump build version
      i40evf: Remove unused defines
      i40e/i40evf: Bump build version
      i40e/i40evf: Bump build version
      i40evf: Fix function header
      i40e/i40evf: Bump i40e to version 0.4.10 and i40evf to 0.9.34

Chema Gonzalez (2):
      filter: added BPF random opcode
      net: filter: fix length calculation in BPF testsuite

Chen Gang (1):
      net/dccp/timer.c: use 'u64' instead of 's64' to avoid compiler's warning

Chen-Yu Tsai (1):
      net: stmmac: Handle different error codes from platform_get_irq_byname

Christian Engelmayer (3):
      wlcore: fix usage of platform_device_add_data()
      net/mlx4_en: Fix uninitialized use of 'port_up' in mlx4_en_set_channels()
      of: mdio: fix compile warning in of_mdiobus_register_phy()

Christian Riesch (1):
      net: davinci_emac: Remove unwanted debug/error message

Christophe Ricard (23):
      NFC: ST21NFCA: Add driver for STMicroelectronics ST21NFCA NFC Chip
      NFC: hci: Extend command execution delay
      NFC: hci: Add load_session HCI operand
      NFC: st21nfca: Implement load_session HCI hook
      NFC: st21nfca: Fix sparse: cast to restricted __be16
      NFC: hci: Fix sparse: cast to restricted __be16
      NFC: st21nfca: Fix warning: array subscript is above array bounds
      NFC: st21nfca: Remove sporadic wait_tab variable from functions.
      NFC: st21nfca: Add __packed to struct st21nfca_pipe_info
      NFC: st21nfca: st21nfca_hci_i2c_probe returns st21nfca_hci_probe result.
      NFC: st21nfca: Reworked st21nfca_request_resources
      NFC: st21nfca: Improve st21nfca initialization by handling reboot properly
      NFC: st21nfca: Remove few useless include
      NFC: st21nfca: Fix incorrect byte stuffing revocation
      NFC: st21nfca: Fix st21nfca_hci_remove_len_crc tail room handling
      NFC: st21nfca: Improved i2c Rx data correctness check
      NFC: st21nfca: Synchronize i2c Tx and Rx path
      NFC: st21nfca: Free buffer when a bad frame is detected
      NFC: dts: st21nfca: Add device-tree (Open Firmware) support to st21nfca
      NFC: dts: st21nfca_i2c: Add DTS Documentation
      NFC: st21nfca: Improve load_session
      NFC: st21nfca: Add ISO15693 Reader/Writer support
      NFC: dts: st21nfca_i2c: Correct minor typo in documentation

Chun-Yeow Yeoh (3):
      ath10k: allow the supported rate change by reassociate peer
      ath10k: fix the peer mac address in getting stats
      ath10k: add extra pdev stats on 10.1 firmware

Clement Perrochaud (3):
      NFC: pn544: i2c: Add device-tree (Open Firmware) support to PN544
      NFC: pn544: i2c: Add DTS Documentation
      NFC: pn544_i2c: Fix null pointer exception when not using platform data

Cong Wang (4):
      sched, cls: check if we could overwrite actions when changing a filter
      sched, act: allow to clear all actions as well
      bridge: make br_device_notifier static
      rtnetlink: fix a memory leak when ->newlink fails

Dan Carpenter (8):
      isdn: hisax: remove some dead code
      can: mcp251x: fix coccinelle warnings
      net: cdc_ncm: fix typo in test for supported formats
      ieee802154: missing put_dev() on error
      qlcnic: remove duplicate QLC_83XX_GET_LSO_CAPABILITY define
      net: sxgbe: remove duplicate SXGBE_CORE_L34_ADDCTL_REG define
      amd-xgbe: unwind on error in xgbe_mdio_register()
      drivers: net: davinci_cpdma: double free on error

Dan Williams (1):
      libertas: fix return value when processing invalid packet

Daniel Borkmann (21):
      net: filter: simplify label names from jump-table
      net: filter: make register naming more comprehensible
      net: filter: misc/various cleanups
      net: filter: remove DL macro
      net: filter: let unattached filters use sock_fprog_kern
      net: filter: doc: add section for BPF test suite
      net: filter: improve test case framework
      net: filter: add test case for jump with holes and ret x variants
      team: lb: use sizeof(*fprog) in __fprog_create
      net: filter: test fill/spill of all M[] regs
      net: filter: use block statements in tcpdump tests
      net: filter: add slot overlapping test with fully filled M[]
      net: filter: add test for loading SKF_AD_OFF limits
      net: filter: get rid of BPF_S_* enum
      net: filter: improve filter block macros
      ktime: add ktime_after and ktime_before helper
      net: sctp: refactor active path selection
      net: sctp: migrate most recently used transport to ktime
      net: sctp: improve sctp_select_active_and_retran_path selection
      net: sctp: fix incorrect type in gfp initializer
      net: filter: add test_bpf module under MAINTAINERS' networking section

Daniel Kim (4):
      brcmfmac: Give priority to 5GHz band in selecting target BSS
      brcmfmac: Report the support of firmware roaming
      brcmfmac: Fix reconnect failure after beacon timeout
      brcmfmac: Increase max buffer size for receiving control message from dongle

Daniel Lee (1):
      tcp: IPv6 support for fastopen server

Daniel Mack (7):
      net: phy: export genphy_config_init()
      net: phy: at803x: use genphy_config_init()
      net: of_mdio: factor out code to parse a phy's 'reg' property
      net: of_mdio: add of_mdiobus_link_phydev()
      net: of_mdio: don't store the length of a property if we don't need to
      net: of_mdio: use int type for address variable
      of: of_mdio: export symbol of_mdiobus_link_phydev

Daniele Di Proietto (4):
      openvswitch: use const in some local vars and casts
      openvswitch: avoid warnings in vport_from_priv
      openvswitch: avoid cast-qual warning in vport_priv
      openvswitch: Added (unsigned long long) cast in printf

Darek Marcinkiewicz (1):
      driver/net/ethernet/ec_bhf.c: fix sparse warnings

David Ahern (1):
      fib_trie: use seq_file_net rather than seq->private

David Ertman (7):
      e1000e: Cleanup return values in ethtool
      e1000e: Cleanup to fix checkpatch missing blank lines
      e1000e: Cleanup checkpatch extra space
      e1000e: Cleanup use of deprecated DEFINE_PCI_DEVICE_TABLE
      e1000e: Failure to write SHRA turns on PROMISC mode
      e1000e: Cleanup parenthesis around return value
      e1000e: Fix expand setting EEE link info to all affected parts

David S. Miller (121):
      Merge branch 'ndo_set_config'
      Merge branch 'tipc-next'
      Merge branch 'netlink-bind'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'gre_netns'
      Merge branch 'via-rhine'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'tipc-next'
      Merge branch 'at86rf230-next'
      Merge tag 'linux-can-next-for-3.16-20140425' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'systemport'
      Merge branch 'qlcnic-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'davinci_mdio'
      Merge branch 'filter-cleanups'
      Merge branch 'am437x'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'inet_csums'
      Merge branch 'tipc-next'
      Merge branch 'micrel_ksz9031'
      Merge branch 'inet_csums_part2'
      Merge branch 'tipc-next'
      Merge branch 'qlcnic-next'
      Merge branch 'be2net-next'
      Merge branch 'sctp_sysctl'
      Merge branch 'filter-next'
      Merge branch 'cxgb4'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'cpsw'
      net: filter: Fix redefinition warnings on x86-64.
      Merge branch 'cdc_mbim-next'
      Merge branch 'tcp-fastopen-ipv6'
      Merge branch 'arc_emac-next'
      Merge branch 'inet_fwmark_reflect'
      Merge branch 'tg3-next'
      Merge branch 'tipc-next'
      Merge branch 'mlx4-next'
      Merge branch 'cpsw_cleanups'
      net: Fix CONFIG_SYSCTL ifdef test.
      Merge branch 'ieee802154-next'
      Merge branch 'filter-next'
      Merge branch 'bonding-next'
      Merge branch 'systemport-next'
      Merge branch 'bridge-non-promisc'
      Merge branch 'dt_fixed_phy'
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'ieee802154-next'
      Merge branch 'cdc_ncm-coalesce'
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge tag 'linux-can-next-for-3.16-20140519' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'enic-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../pablo/nftables
      Merge branch 'sw_tso'
      Merge branch 'vlan_features'
      Merge branch 'fixed_phy'
      Merge branch 'mac80211'
      Merge tag 'linux-can-next-for-3.16-20140521' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'genphy'
      Merge branch 'bonding'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'mlx4-next'
      Merge branch 'master' of git://git.kernel.org/.../pshelar/openvswitch
      Merge branch 'mvneta-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'inet_csums_part3'
      Merge branch 'filter-next'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'ks8851'
      Merge branch 'net-sysfs-docs'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'of_mdio'
      Merge tag 'linux-can-next-for-3.16-20140526' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'be2net-next'
      Merge branch 's390-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'mlx4-next'
      net: Revert mlx4 cpumask changes.
      Merge branch 'filter-next'
      Revert "net/mlx4_en: Use affinity hint"
      Merge branch '6lowpan-next'
      Merge branch 'netdevsync'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'cdc_ncm'
      Merge branch 'mvneta'
      Merge branch 'ethtool-rssh-fixes' of git://git.kernel.org/.../bwh/net-next
      Merge branch 'cnic'
      Merge branch 'hsilicon'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'xen-netback-netfront-multiqueue'
      Merge branch 'bonding-macvlan'
      Merge branch 'inet_csums'
      Merge branch 'isdn-capi'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'dm9000-next'
      Merge branch 'amd-xgbe'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'systemport-next'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'cxgb4'
      Merge branch 'bridge_multicast_exports'
      Merge branch 'mlx4'
      Merge branch 'mac802154'
      Merge branch 'sctp-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'mlx4'
      Merge branch 'bridge-next'
      Merge branch 'qlcnic-next'
      Merge branch 'inet_csums'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'bnx2x'
      Merge branch 'fec'

David Spinadel (3):
      cfg80211: Add indoor only and GO concurrent channel attributes
      iwlwifi: mvm: notify sched scan complete from stop routine
      iwlwifi: mvm: stop sched scan before association

Denis ChengRq (1):
      genetlink: remove superfluous assignment

Dinh Nguyen (1):
      net: stmmac: set phy to use polling by default

Dmitry Popov (5):
      ip_tunnel: fix possible rtable leak
      ipip, sit: fix ipv4_{update_pmtu,redirect} calls
      ip_vti: Fix 'ip tunnel add' with 'key' parameters
      ip_tunnel: fix i_key matching in ip_tunnel_find
      ip_vti: fix sparse warnings for VTI_ISVTI

Doug Ledford (1):
      net/core: Add VF link state control policy

Duan Jiong (4):
      lcs: replace PTR_RET with PTR_ERR_OR_ZERO
      qeth: replace PTR_RET with PTR_ERR_OR_ZERO
      ipv6: remove parameter rt from fib6_prune_clones()
      ip_tunnel: don't add tunnel twice

Eliad Peller (6):
      iwlwifi: mvm: add lq_cmd/tx_resp reduced_tpc field
      iwlwifi: mvm: add ATPC implementation
      iwlwifi: mvm: add debugfs file for fixed reduced tx power
      iwlwifi: mvm: don't use d3 fw if d0i3 is used
      iwlwifi: mvm: wait for d0i3 exit in some more ampdu actions
      iwlwifi: mvm: set SKIP_OVER_DTIM flag only if needed

Emil Goode (1):
      stmmac: Remove spin_lock call in stmmac_get_pauseparam()

Emil Tantilov (3):
      ixgbevf: remove 82599 from the module description
      ixgbe: fix linking at 100Mbps on copper devices with MNG FW enabled
      ixgbe: fix detection of SFP+ capable interfaces

Emmanuel Grumbach (46):
      iwlwifi: pcie: don't leave the new NICs awake for commands
      mac80211: add vif to flush call
      iwlwifi: pcie: unify iwl_rx_replenish and iwl_rx_replenish_now
      iwlwifi: mvm: remove redundant empty line
      iwlwifi: mvm: propagate the beamforming status from firmware
      iwlwifi: mvm: don't set AP STA to EINVAL
      iwlwifi: allow to wait for a subset of the queues
      iwlwifi: pcie: WARN upon traffic while flushing TX queues
      iwlwifi: mvm: dump Rx FIFO when the firmware asserts
      iwlwifi: mvm: don't enable bcast filtering on P2P client
      iwlwifi: mvm: replace BUG_ON by WARN_ON in scan.c
      iwlwifi: mvm: deprecate -7 firmware
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_NEWBT_COEX TLV flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_RX_ENERGY_API flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2 flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_BF_UPDATED flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_SCHED_SCAN flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_STA_KEY_CMD flag
      iwlwifi: remove IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD flag
      iwlwifi: mvm: BT Coex - don't use comma operator
      iwlwifi: mvm: BT Coex - minor API change
      iwlwifi: mvm: BT Coex - send priority tables from iwl_send_bt_init_conf
      iwlwifi: 7000: bump firmware API version to 9
      iwlwifi: mvm: replace leading spaces by tabs
      iwlwifi: don't disable SCD chain extension on newer devices
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: implement mac80211's flush callback
      iwlwifi: mvm: fix sparse warning when _DEBUGFS isn't set
      iwlwifi: dvm: don't use _ni mac80211's callbacks
      iwlwifi: pcie: try to get ownership several times
      Merge remote-tracking branch 'iwlwifi-fixes/master' into HEAD
      iwlwifi: remove CMD_SYNC
      iwlwifi: pcie: disable BHs in iwl_pcie_txq_check_wrptrs
      iwlwifi: mvm: BT Coex - fix boost register / LUT values
      iwlwifi: mvm: BT Coex - send channel inhibition before association
      iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      iwlwifi: mvm: disable reduced Tx power when not applicable
      iwlwifi: mvm: remove debugfs hook for reduced tx power
      iwlwifi: mvm: make iwl_mvm_update_beacon_abort static
      cfg80211: allow RSSI compensation
      mac80211: fix virtual monitor interface addition

Eran Harary (11):
      iwlwifi: mvm: fix the number of channels in family 8000
      iwlwifi: move CPU1_CPU2_SEPARATOR_SECTION to iwl-fw.h
      iwlwifi: mvm: fix bug with OTP memory size
      iwlwifi: mvm: prevent nic to powered up at driver load
      iwlwifi: mvm: Prioritize external nvm values on top of the OTP values
      iwlwifi: mvm: select the MAC address according to priority
      iwlwifi: mvm: fix bug in parse_nvm_sections
      iwlwifi: 8000: add default NVM file name in family 8000
      iwlwifi: mvm: add channel 14 to the low band list
      iwlwifi: mvm: revisit the NVM handling code
      iwlwifi: allow dynamic configuration of internal memory

Eric Dumazet (6):
      tcp: avoid retransmits of TCP packets hanging in host queues
      tcp: fix cwnd limited checking to improve congestion control
      tcp: remove in_flight parameter from cong_avoid() methods
      inetpeer: get rid of ip_id_count
      net: force a list_del() in unregister_netdevice_many()
      ipv4: fix a race in ip4_datagram_release_cb()

Erik Hugne (3):
      tipc: add support for link state subscriptions
      tipc: add ioctl to fetch link names
      tipc: fix out of bounds indexing

Eyal Perry (4):
      net/mlx4_core: Fix smatch error - possible access to a null variable
      net/mlx4_core: Removed unnecessary bit operation condition
      net/mlx4_en: Using positive error value for unsigned
      net/mlx4_core: Fix inaccurate return value of mlx4_flow_attach()

Eyal Shapira (7):
      iwlwifi: mvm: add per rate tx stats
      iwlwifi: mvm: rs: revert changes to search cycle rules
      iwlwifi: mvm: rs: overhaul rs_get_best_rate
      iwlwifi: mvm: rs: don't allow TPC when power save is disabled
      iwlwifi: mvm: rs: avoid TPC while in search cycle
      iwlwifi: mvm: rs: choose correct expected tpt table
      iwlwifi: mvm: rs: enable MCS9 for Tx

Eytan Lifshitz (2):
      iwlwifi: mvm: Fix warning message when exit thermal throttling
      iwlwifi: mvm: Fix tx-backoff when NIC exit thermal throttling

Ezequiel Garcia (25):
      net: Add a software TSO helper API
      net: mvneta: Factorize feature setting
      net: mvneta: Clean mvneta_tx() sk_buff handling
      net: mvneta: Implement software TSO
      net: mv643xx_eth: Factorize initial checksum and command preparation
      net: mv643xx_eth: Avoid setting the initial TCP checksum
      net: mv643xx_eth: Factorize feature setting
      net: mv643xx_eth: Use dma_map_single() to map the skb fragments
      net: mv643xx_eth: Implement software TSO
      net: mv643xx_eth: Simplify mv643xx_eth_adjust_link()
      net: mvneta: Clean-up mvneta_tx_frag_process()
      net: mvneta: Check tx queue setup error in mvneta_change_mtu()
      net: mvneta: Clean-up mvneta_init()
      net: mvneta: Use prepare/commit API to simplify MAC address setting
      net: mvneta: Change the number of default rx queues to one
      net: mvmdio: Use devm_* API to simplify the code
      net: mvneta: Remove unneeded 'weigth' field
      net: mvneta: Use default NAPI weight instead of a custom one
      net: mvneta: Limit the TSO segments and adjust stop/wake thresholds
      net: mvneta: Fix missing DMA region unmap
      net: mvneta: Avoid unmapping the TSO header buffers
      net: mv643xx_eth: Count dropped packets properly
      net: mv643xx_eth: Limit the TSO segments and adjust stop/wake thresholds
      net: mv643xx_eth: Drop the NETDEV_TX_BUSY return path
      net: mv643xx_eth: Avoid unmapping the TSO header buffers

Fabian Frederick (1):
      net/xfrm/xfrm_output.c: move EXPORT_SYMBOL

Fabio Estevam (2):
      fec: Include pinctrl header file
      gianfar: Call netif_carrier_off() prior to registration

Felix Fietkau (7):
      ath9k: support only one P2P interface
      ath9k: implement p2p client powersave support
      ath9k_hw: get QCA953x WMAC revision via platform_data
      cfg80211: allow restricting supported dfs regions
      mac80211: fix a memory leak on sta rate selection table
      mac80211: reduce packet loss notifications under load
      ath9k: avoid passing buffers to the hardware during flush

Fengguang Wu (2):
      NFC: digital: digital_in_send_attrib_req() can be static
      NFC: nfc_sock_link() can be static

Florian Fainelli (30):
      net: ethoc: remove ethoc_config
      net: cpmac: remove cpmac_config
      net: sxgbe: remove sxgbe_config
      stmmac: remove stmmac_config
      net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver
      Documentation: add Broadcom SYSTEMPORT Device Tree bindings
      net: systemport: hook SYSTEMPORT driver in the build
      MAINTAINERS: add Broadcom SYSTEMPORT driver entry
      net: dsa: add ds_to_priv
      net: dsa: update DSA drivers to use ds_to_priv
      net: systemport: only update UMAC_CMD if something changed
      net: systemport: pad packets to a minimum of 68 bytes
      net: systemport: fix dma_unmap_single() len
      net: systemport: wait for packet in umac_enable_set()
      Documentation: devicetree: add old and deprecated 'fixed-link'
      Documentation: devicetree: net: refer to fixed-link.txt
      net: bcmgenet: use the new fixed PHY helpers
      net: systemport: use the new fixed PHY helpers
      fs_enet: use the new fixed PHY helpers
      gianfar: use the new fixed PHY helpers
      ucc_geth: use the new fixed PHY helpers
      of: mdio: remove of_phy_connect_fixed_link
      powerpc/fsl: fsl_soc: remove 'fixed-link' parsing code
      net: sysfs: add missing phys_port_id documentation
      net: sysfs: add documentation entries for /sys/class/<iface>/queues
      net: sysfs: document /sys/class/net/statistics/*
      net: systemport: fix transmit locking scheme
      net: systemport: correctly check for RX_STATUS_OVFLOW flag
      net: systemport: fix comment about HW prepending 2bytes
      net: systemport: start with carrier off

Florian Westphal (2):
      netfilter: add helper for adding nat extension
      net_sched: drr: warn when qdisc is not work conserving

Frank Blaschka (2):
      claw: replace PTR_RET with PTR_ERR_OR_ZERO
      ctc: replace PTR_RET with PTR_ERR_OR_ZERO

Frank Zhang (1):
      i40e: keep SR-IOV enabled in the case that RSS, VMDQ, FD_SB and DCB are disabled

Fran√ßois Cachereul (1):
      via-rhine: fix full-duplex with autoneg disable

Frederic Danis (1):
      ath10k: fix ath10k_bmi_read32 macro

George Cherian (9):
      ARM: dts: am33xx: Add clock names for cpsw and cpts
      drivers: net: cpts: Remove hardcoded clock name for CPTS
      drivers: net: cpsw: Enable CPTS for DRA7xx and AM4372
      drivers: net: cpsw: Enable Annexe F Time sync
      ARM: AM43xx: clk: Change the cpts ref clock source to dpll_core_m5 clk
      ARM: dts: am4372: Add clock names for cpsw and cpts
      driver net: cpsw: Convert pr_*() to dev_*() calls
      net: davinci_mdio: Convert pr_err() to dev_err() call
      drivers: net: davinci_cpdma: Convert kzalloc() to devm_kzalloc().

George Spelvin (3):
      lib/crc7: Shift crc7() output left 1 bit
      drivers/mmc/host/mmc_spi.c: Use get/put_unaligned_be32
      drivers/net/wireless/ti/wl*/spi.c: Simplify CRC computation

Govindarajulu Varadarajan (2):
      MAINTAINERS: Update enic maintainers
      enic: Fix 64 bit divide on 32bit system

Grazvydas Ignotas (4):
      Revert "wl1251: enforce changed hw encryption support on monitor state change"
      wl1251: fix null data for IBSS
      wl1251: fix mixed up args for join
      wl1251: only call ieee80211_beacon_loss in managed mode

Greg Rose (9):
      i40e: Add bridge FDB add/del/dump ops
      i40e: Reset the VF upon conflicting VLAN configuration
      i40e: Retain MAC filters when changing port VLAN
      i40e: Use port VLAN in MAC/VLAN filter configuration
      i40e: Check PCI_IOV config to avoid compile error
      i40e/i40evf: Change type to u32 to avoid sparse error
      i40e: Delete stale MAC filters after change
      i40e: Do not accept tagged packets by default
      i40e/i40evf: User ether_addr_copy instead of memcpy

Grygorii Strashko (4):
      mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
      net: davinci_mdio: use devm_* api
      net: davinci_mdio: drop pinctrl_pm_select_default_state from probe
      net: davinci_mdio: simplify IO memory mapping

Haim Dreyfuss (1):
      iwlwifi: mvm: Add support for Energy based scan (EBS)

Haiyang Zhang (5):
      hyperv: Add support for virtual Receive Side Scaling (vRSS)
      hyperv: Remove recv_pkt_list and lock
      hyperv: Simplify the send_completion variables
      Add support for netvsc build without CONFIG_SYSFS flag
      hyperv: Add hash value into RNDIS Per-packet info

Hante Meuleman (5):
      brcmfmac: Move out hdrpull from tx_finalize.
      brcmfmac: Move handling 802.1x frames to dhd_linux.
      brcmfmac: Make FWS queueing configurable.
      brcmfmac: Add log of superspeed device detection to USB probe.
      brcmfmac: Remove interrupt endpoint usage from USB driver.

Hariprasad Shenai (7):
      cxgb4: Decode the firmware port and module type a bit more for ethtool
      cxgb4: Check if rx checksum offload is enabled, while reading hardware calculated checksum
      cxgb4vf: Check if rx checksum offload is enabled, while reading hardware calculated checksum
      iw_cxgb4: Allocate and use IQs specifically for indirect interrupts
      iw_cxgb4: Choose appropriate hw mtu index and ISS for iWARP connections
      iw_cxgb4: don't truncate the recv window size
      cxgb4: Change default Interrupt Holdoff Packet Count Threshold

Harish Patil (2):
      qlcnic: Add hwmon interface to export board temperature.
      qlcnic: Fix Kconfig dependency on HWMON

Heikki Krogerus (5):
      ARM: tegra: remove obsolete gpio entries
      net: rfkill: gpio: remove unused and obsolete platform parameters
      net: rfkill: gpio: add ACPI ID for GPS module on Lenovo Miix2
      net: rfkill: gpio: add ACPI IDs for a Broadcom bluetooth chip
      net: rfkill: gpio: hard-code the gpio names

Heiner Kallweit (1):
      ipv6: support IFA_F_MANAGETEMPADDR for address deletion too

Helmut Schaa (2):
      ath9k: Allow platform override without EEPROM override
      amend "ath9k: Allow platform override without EEPROM override"

Herbert Xu (3):
      net: Add __dev_forward_skb
      macvlan: Move broadcasts into a work queue
      macvlan: Fix leak and NULL dereference on error path

Himangi Saraogi (6):
      ieee802154: Introduce the use of the managed version of kzalloc
      ehea: Introduce the use of the managed version of kzalloc
      ipmr: Replace comma with semicolon
      RDS/RDMA: Replace comma with semicolon
      rds/tcp_listen: Replace comma with semicolon
      af_key: Replace comma with semicolon

Hiren Tandel (3):
      NFC: NCI: No need to reverse ATR_RES Response
      NFC: Add RAW socket type support for SOCKPROTO_RAW
      NFC: NCI: Send all NCI frames to raw sockets

Hisao Tanabe (1):
      ipv4: Use predefined value for readability

Hubert Chaumette (2):
      Update Micrel KSZ90x1 binding documentation
      ARM: i.MX6: Add OF configuration support for ksz9031

Ido Shamay (1):
      net/mlx4_en: User prio mapping gets corrupted when changing number of channels

Ilan Peer (5):
      cfg80211: Add Kconfig option for cellular BS hints
      cfg80211: Enable GO operation on additional channels
      cfg80211: Add an option to hint indoor operation
      cfg80211: Enable GO operation on indoor channels
      cfg80211: Fix GO Concurrent relaxation on UNII-3

Jack Morgenstein (1):
      net/mlx4_core: Fix SRIOV free-pool management when enforcing resource quotas

Jacob Keller (22):
      ixgbe: convert low_water into an array
      ixgbe: remove vlan_filter_disable and enable functions
      ixgbe: change handling of multicast filters
      ixgbe: improve mac filter handling
      i40e: remove ptp_tx_work timestamp work item
      ixgbe: clean up checkpatch warnings about CODE_INDENT and LEADING_SPACE
      ixgbe: fix function-like macro, remove semicolon
      ixgbe: fix checkpatch style of blank line after declaration
      ixgbe: fix several concatenated strings to single line
      ixgbe: add braces around else block
      ixgbe: don't check NULL for debugfs_remove_recursive
      ixgbe: add space between operands to &
      ixgbe: add /* fallthrough */ comment to case statements
      ixgbe: rename ixgbe_ptp_enable to ixgbe_ptp_feature_enable
      ixgbe: extract the hardware setup from the ixgbe_ptp_set_ts_config
      ixgbe: allow ixgbe_ptp_reset to maintain current hwtstamp config
      ixgbe: extract PTP clock device from ptp_init
      ixgbe: separate the PTP suspend and stop actions
      ixgbe: avoid duplicate code in suspend and stop paths
      ixgbe: remove linux/export.h header from ixgbe_ptp.c
      igb: rename igb_ptp_enable to igb_ptp_feature_enable
      igb: separate hardware setting from the set_ts_config ioctl

Jahnavi Meher (2):
      rsi: Changing opcode for sta mode according to changes in firmware
      rsi: Changed the return value to enable BA set-up

Jan-Simon M√∂ller (1):
      mac80211: remove VLAIS usage from mac80211

Janusz Dziedzic (16):
      ath10k: add ath10k_htt_rx_amsdu_allowed function
      ath10k: Fill per-ppdu info in rx_info only once
      ath10k: move rx related functions to htt_rx.c
      ath10k: rename process_rx_rates to ath10k_htt_rx_h_rates
      ath10k: introduce ieee80211_rx_status to htt_rx_info
      ath10k: setup rx channel per ppdu
      ath10k: kill not needed fields from htt_rx_info
      ath10k: return error when ath10k_htt_rx_amsdu_pop() fail
      ath10k: improve way we play with attention flags
      ath10k: finally kill htt_rx_info
      ath10k: introduce rx_status htt template
      ath10k: fix rssi and rate reporting
      cfg80211: reg: set DFS CAC time in case of custom regd
      cfg80211: fix start_radar_detection issue
      ath: add DFS FCC pattern detector
      ath: add JP DFS pattern detector

Jarno Rajahalme (16):
      openvswitch: Remove 5-tuple optimization.
      openvswitch: Per NUMA node flow stats.
      openvswitch: Fix output of SCTP mask.
      openvswitch: Use TCP flags in the flow key for stats.
      openvswitch: Compact sw_flow_key.
      openvswitch: Avoid assigning a NULL pointer to flow actions.
      openvswitch: Clarify locking.
      openvswitch: Build flow cmd netlink reply only if needed.
      openvswitch: Make flow mask removal symmetric.
      openvswitch: Minimize dp and vport critical sections.
      openvswitch: Fix typo.
      openvswitch: Fix ovs_flow_stats_get/clear RCU dereference.
      openvswitch: Reduce locking requirements.
      openvswitch: Minimize ovs_flow_cmd_del critical section.
      openvswitch: Split ovs_flow_cmd_new_or_set().
      openvswitch: Minimize ovs_flow_cmd_new|set critical sections.

Jean Delvare (4):
      net: pch_gbe depends on x86_32
      can: at91_can: Fix Kconfig dependencies
      can: mscan: Fix Kconfig dependencies
      can: pch_can: Fix Kconfig dependencies

Jean Sacren (2):
      ethtool: exit the loop when invalid index occurs
      i40e: fix passing wrong error code to i40e_open()

Jeff Kirsher (1):
      igb/ixgbe: remove return statements for void functions

Jes Sorensen (1):
      wireless: add missing WLAN_EID_BSS_INTOLERANT_CHL_REPORT

Jesse Brandeburg (16):
      i40e/i40evf: unhide and enable to one prefena field
      i40evf: Fix the headers and update copyright year.
      i40e: remove Tx work for ptp
      i40e/i40evf: remove storm control
      i40e: don't use OR to check a value
      i40e/i40evf: remove unused RX_LRO define
      i40e: clamp jumbo frame size
      i40e: refactor send version
      i40e: print message for pre-production hardware
      i40e: print full link message
      i40e/i40evf: fix rx descriptor status
      i40e/i40evf: fix TSO accounting
      i40e/i40evf: fix poll weight
      i40e/i40evf: remove deprecated device IDs
      i40e/i40evf: add PPRS bit to error bits and fix bug in Rx checksum
      i40e/i40evf: remove FTYPE

Jingoo Han (2):
      net: sxgbe: make local functions static
      net: systemport: Use devm_ioremap_resource()

Jiri Pirko (2):
      net: use SPEED_UNKNOWN and DUPLEX_UNKNOWN when appropriate
      net: use ethtool_cmd_speed_set helper to set ethtool speed value

Jitendra Kalsaria (1):
      qlcnic: Update version to 5.3.58

Joe Perches (9):
      qlge: Convert /n to \n
      iwlegacy: Convert /n to \n
      mellanox: Logging message cleanups
      net: Use a more standard macro for INET_ADDR_COOKIE
      ti: Remove trailing semicolon from do {...} while (0) macro
      wlcore: Remove trailing semicolon from do {...} while (0) macro
      openvswitch: Use net_ratelimit in OVS_NLERR
      openvswitch: flow_netlink: Use pr_fmt to OVS_NLERR output
      openvswitch: Use ether_addr_copy

Johan Hedberg (27):
      Bluetooth: Refactor advertising report processing into its own function
      Bluetooth: Move local identity address setting to a central place
      Bluetooth: Fix LE responder/initiator address setting
      Bluetooth: Add error mapping for Directed Advertising Timeout
      Bluetooth: Don't send device found events during passive scanning
      Bluetooth: Add scan_rsp parameter to mgmt_device_found()
      Bluetooth: Add directed advertising support through connect()
      Bluetooth: Merge ADV_IND/ADV_SCAN_IND and SCAN_RSP together
      Bluetooth: Remove redundant NULL check
      Bluetooth: Fix line splitting of mgmt_device_found parameters
      Bluetooth: Don't send device found events for duplicate reports
      Bluetooth: Store also RSSI for pending advertising reports
      Bluetooth: Fix RSSI value in device found event from disabling scan
      Bluetooth: Remove unnecessary NULL check in hci_inquiry_cache_update
      Bluetooth: Fix address in unmergeable device found events
      Bluetooth: Add support for SMP Invalid Parameters error code
      Bluetooth: Make SMP context private to smp.c
      Bluetooth: Fix setting initial local auth_req value
      Bluetooth: Remove unnecessary work structs from SMP code
      Bluetooth: Rename smp->smp_flags to smp->flags
      Bluetooth: Update smp_random to return a response code
      Bluetooth: Update smp_confirm to return a response code
      Bluetooth: Clearly distinguish mgmt LTK type from authenticated property
      Bluetooth: Fix properly ignoring LTKs of unknown types
      Bluetooth: Fix authentication check for FIPS security level
      Bluetooth: Fix requiring SMP MITM for outgoing connections
      Bluetooth: Fix missing check for FIPS security level

Johannes Berg (27):
      cfg80211: allow userspace to take ownership of interfaces
      cfg80211: reject invalid IBSS BSSIDs in wext compat code
      cfg80211: ignore invalid BSSIDs when looking for BSSes
      iwlwifi: pcie: implement GRO without NAPI
      iwlwifi: pcie: clarify RX queue need_update handling and locking
      iwlwifi: pcie: use bool for TX queue where appropriate
      iwlwifi: pcie: fix TX queue locking
      iwlwifi: pcie: clarify TX queue need_update handling
      cfg80211: remove BUG_ON usage
      mac80211: remove BUG_ON usage
      mac80211: mark local variable __maybe_unused
      iwlwifi: mvm: remove useless variable
      iwlwifi: make LED support optional
      iwlwifi: pcie: use bool for iwl_pcie_txq_build_tfd() argument
      iwlwifi: pcie: get rid of q->n_bd
      iwlwifi: mvm/pcie: capture last commands on firmware error
      mac80211: handle failed restart/resume better
      iwlwifi: add missing trailing newlines to debug messages
      iwlwifi: cause build error on missing newline
      iwlwifi: remove spurious newline in Kconfig
      iwlwifi: mvm: enable RX chain diversity if needed
      iwlwifi: fix LED support Kconfig dependencies
      mac80211: minstrel-ht: small clarifications
      cfg80211: constify MAC addresses in cfg80211 ops
      cfg80211: constify more pointers in the cfg80211 API
      cfg80211: constify wowlan/coalesce mask/pattern pointers
      cfg80211: send events when devices are added/removed

John W. Linville (25):
      Merge branch 'master' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Revert "mwifiex: add firmware dump feature for PCIe"
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'rfkill-gpio-cleanups' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge branch 'master' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      ath9k: fixup "ath9k_htc: fix build with disabled debug"
      Merge tag 'nfc-next-3.16-1' of git://git.kernel.org/.../sameo/nfc-next
      Merge git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      mwifiex: use 'const' qualifier for 2nd arg of mwifiex_tdls_add_ht_oper
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge tag 'nfc-next-3.16-2' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jon Cooper (1):
      sfc: PIO:Restrict to 64bit arch and use 64-bit writes.

Jon Paul Maloy (9):
      tipc: decrease connection flow control window
      tipc: compensate for double accounting in socket rcv buffer
      tipc: don't record link RESET or ACTIVATE messages as traffic
      tipc: mark head of reassembly buffer as non-linear
      tipc: rename and move message reassembly function
      tipc: improve and extend media address conversion functions
      tipc: clean up neigbor discovery message reception
      tipc: merge port message reception into socket reception function
      tipc: fix potential bug in function tipc_backlog_rcv

Jongsung Kim (1):
      net: phy: realtek: register/unregister multiple drivers properly

Jouni Malinen (4):
      mac80211: Allow HT capa override to add 40 MHz intolerant
      cfg80211: Dynamic channel bandwidth changes in AP mode
      mac80211: Support dynamic AP mode channel width changes
      mac80211_hwsim: Advertise support for AP mode channel width changes

Jukka Rissanen (2):
      Bluetooth: 6LoWPAN: Fix MAC address universal/local bit handling
      Bluetooth: l2cap: Set more channel defaults

Jukka Taimisto (1):
      Bluetooth: Fix L2CAP deadlock

Julia Lawall (7):
      ray_cs: replace del_timer by del_timer_sync
      drivers/net/wan: delete unneeded call to netdev_priv
      net/ariadne: delete unneeded call to netdev_priv
      ip_tunnel: delete unneeded call to netdev_priv
      vti6: delete unneeded call to netdev_priv
      brcmsmac: make return of 0 explicit
      wimax/i2400m: make return of 0 explicit

KY Srinivasan (1):
      hyperv: Enable sendbuf mechanism on the send path

Kalesh AP (5):
      be2net: remove unused code in be_cmd_vlan_config()
      be2net: include rx-compl error counter in ethtool stats
      be2net: use MCCQ instead of MBOX in be_cmd_rss_config()
      be2net: skip multicast promiscuos setting in already set
      be2net: re-factor MCCQ error status handling code

Kalle Valo (20):
      ath6kl: fix struct hif_scatter_req list handling
      ath6kl: fix blank lines before and after braces
      ath6kl: use braces on both arms of if statement
      ath6kl: remove spaces before semicolon
      ath6kl: remove unnecessary line continuations
      ath6kl: update Kconfig descriptions
      ath10k: separate result parameter in ath10k_bmi_execute()
      ath10k: check otp.bin result
      ath10k: unify warning messages in mac.c
      ath10k: cleanup ath10k_pci_wait_for_target_init()
      ath10k: add module parameter to disable cold reset
      ath10k: fix name of target_ps module parameter
      ath10k: advertise only firmware API 2 files
      ath10k: delete ar_pci->fw_indicator_address
      ath10k: improve pci debug messages
      ath10k: add module parameter values to the pci info print
      ath10k: print chip id during boot
      ath10k: cleanup debug messages in ath10k_wmi_event_host_swba()
      cfg80211: update comment about WIPHY_FLAG_CUSTOM_REGULATORY
      Merge remote-tracking branch 'wireless-next/master' into ath-next

Kamil Krawczyk (4):
      i40e: Rework register diagnostic
      i40e: remove check for large buffer
      i40e/i40evf: VEB structure added, GTIME macro update
      i40e/i40evf: check AQ register for valid data

Kedareswara rao Appana (2):
      can: Add xilinx CAN device tree bindings documentation
      can: xilinx CAN controller support

Kees Cook (1):
      rsi: avoid format string leak to thread name

Kenjiro Nakayama (1):
      tcp: Add a TCP_FASTOPEN socket option to get a max backlog on its listner

Kevin Scott (4):
      i40e: Change variable type to avoid typecheck failure
      i40e: Update function formal parameters
      i40e/i40evf: Update check for AQ aliveness
      i40e/i40evf: Remove reserved PCTYPE defines

Kirill Tkhai (1):
      net: unix: Align send data_len up to PAGE_SIZE

Konrad Zapalowicz (1):
      net: phy: fix sparse warning in fixed.c

Krzysztof Ha≈Çasa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Kurt Van Dijck (2):
      can: softing: drop 'channel' sysfs attribute
      can: softing: remove unused sysfs attributes

Larry Finger [ original patch ] (1):
      rtl8180: change module name in rtl818x_pci

Laurent Pinchart (1):
      irda: sh_irda: Enable driver compilation with COMPILE_TEST

Lendacky, Thomas (6):
      amd-xgbe: AMD 10GbE device bindings documentation
      amd-xgbe: Initial AMD 10GbE platform driver
      amd-xgbe: Initial AMD 10GbE phylib driver
      amd-xgbe: Configuration and build support
      amd-xgbe: Maintainer information
      amd-xgbe: Rename MAX_DMA_CHANNELS to avoid powerpc conflict

Li RongQing (2):
      vlan: unnecessary to check if vlan_pcpu_stats is NULL
      ipv6: slight optimization in ip6_dst_gc

Liad Kaufman (2):
      iwlwifi: use dev_printk instead of dev_dbg for debug logs
      iwlwifi: update nmi register

Libor Pechacek (1):
      Bluetooth: Convert RFCOMM spinlocks into mutexes

Linus L√ºssing (6):
      bridge: rename struct bridge_mcast_query/querier
      bridge: adhere to querier election mechanism specified by RFCs
      bridge: add export of multicast database adjacent to net_dev
      bridge: memorize and export selected IGMP/MLD querier port
      bridge: fix smatch warning / potential null pointer dereference
      bridge: fix compile error when compiling without IPv6 support

Loic Poulain (1):
      rfkill-gpio: Use gpio cansleep version

Lorenzo Colitti (4):
      net: ipv6: Introduce ip6_sk_dst_hoplimit.
      net: add a sysctl to reflect the fwmark on replies
      net: Use fwmark reflection in PMTU discovery.
      net: support marking accepting TCP sockets

Luciano Coelho (21):
      cfg80211: refactor cfg80211_can_use_iftype_chan()
      cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
      cfg80211/mac80211: move interface counting for combination check to mac80211
      cfg80211/mac80211: move combination check to mac80211 for ibss
      cfg80211/mac80211: move more combination checks to mac80211
      mac80211: split ieee80211_vif_change_channel in two
      mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
      mac80211: implement chanctx reservation
      mac80211: allow reservation of a running chanctx
      cfg80211: fix docbook warning
      mac80211: fix sparse warning caused by __ieee80211_channel_switch()
      cfg80211: pass the actual iftype when calling cfg80211_chandef_dfs_required()
      iwlwifi: mvm: combine p2p and station mac context functions
      cfg80211: add documentation for max_num_csa_counters
      mac80211: fix csa_counter_offs argument name in docbook
      iwlwifi: mvm: update power after phy_ctxt is NULL when unassigning chanctx
      iwlwifi: mvm: enable MAC_FILTER_IN_BEACON when forced_assoc_off is set
      iwlwifi: mvm: set the MAC_FILTER_IN_BEACON flag also for P2P
      iwlwifi: mvm: pass force_assoc_off all the way down to avoid hacks
      ath9k/ath10k: remove unnecessary channel_switch_beacon callbacks
      mac80211: add a single-transaction driver op to switch contexts

Luis R. Rodriguez (5):
      6lowpan: add helper to get 6lowpan namespace
      6lowpan: make lowpan_cb static
      6lowpan: include net/net_namespace.h on 6lowpan namepsace header
      cfg80211: fix processing world regdomain when non modular
      6lowpan: nuke net_ieee802154_lowpan() accessor when 6lowpan is disabled

Lukasz Rymanowski (3):
      Bluetooth: Keep msec in DISCOV_INTERLEAVED_TIMEOUT
      Bluetooth: Add new debugfs parameter
      Bluetooth: Keep msec in DISCOV_LE_TIMEOUT

Maciej W. Rozycki (1):
      FDDI: Reformat <linux/if_fddi.h> for 8-character tabs

Mahesh Bandewar (4):
      bonding: Changed hashing function to just provide hash
      bonding: Reorg bond_alb_xmit code
      bonding: Added bond_tlb_xmit() for tlb mode.
      bonding: Add tlb_dynamic_lb parameter for tlb mode

Maithili Hinge (1):
      mwifiex: change memset to simple assignment for ht_cap.mcs.rx_mask

Manuel Sch√∂lling (13):
      net: 8390: use time_after() for time comparison
      net: rds: Use time_after() for time comparison
      vxge: Use time_before()
      qlogic: Use time_before()
      mISDN: Use time_before()
      mISDN: Use mod_timer()
      micrel: Use time_before_eq()
      xilinx: Use time_before_eq()
      mwifiex: use time_after()
      wan: Use usleep_range()
      e1000: Use time_after() for time comparison
      dns_resolver: Do not accept domain names longer than 255 chars
      dns_resolver: assure that dns_query() result is null-terminated

Marc Kleine-Budde (1):
      can: gs_usb: gs_destroy_candev(): fix use after free

Marcel Holtmann (2):
      Bluetooth: Return EOPNOTSUPP for HCISETRAW ioctl command
      Bluetooth: Increment management interface revision

Marek Kwaczynski (3):
      ath10k: add recalc RTS/CTS protection method
      mac80211: add option to generate CCMP IVs only for mgmt frames
      ath10k: fix pmf for action frames

Marek Puzyniak (2):
      ath10k: add soft/hard firmware crash option to simulate_fw_crash
      ath10k: update regulatory domain settings for 10.x firmware

Mark A. Greer (19):
      NFC: trf7970a: Increase TRF7970A_WAIT_FOR_RX_DATA_TIMEOUT to 20 ms
      NFC: trf7970a: Only abort a command if one is active
      NFC: trf7970a: Clear 'NFC Target Detection Level' register
      NFC: trf7970a: Reset FIFO when 'End of TX' Interrupt Occurs
      NFC: trf7970a: Only write 'ISO Control' when its changing
      NFC: trf7970a: Set 'Modulator and SYS_CLK Control' after 'ISO Control'
      NFC: trf7970a: Allow different Modulator and SYS_CLK Control register values
      NFC: trf7970a: Set correct Vin voltage in Chip Status Control register
      NFC: trf7970a: Turn RF on after hardware is configured
      NFC: trf7970a: Add pm_runtime support
      NFC: trf7970a: Don't return value from trf7970a_switch_rf_on()
      NFC: trf7970a: Add 'autosuspend-delay' DTS property
      NFC: trf7970a: Document the 'autosuspend-delay' DTS property
      NFC: digital: Add macros for the ISO/IEC 14443-B Protocol
      NFC: digital: Add support for ISO/IEC 14443-B Protocol
      NFC: trf7970a: Add support for the ISO/IEC 14443-B and Type 4B tags
      NFC: digital: SENSF_RES excludes RD when SENSF_REQ RC is zero
      NFC: digital: Handle multiple SENSF_REQ frames
      NFC: trf7970a: Add support for Felica Type 3 tags

Mark Rustad (1):
      ixgbe: Use out-of-line function for register reads

Markus Lottmann (1):
      drivers: net: Register Micrel ksz884x network devices in PCI device tree.

Masanari Iida (1):
      netfilter: Fix format string mismatch in ip_vs_proto_name()

Mathias Krause (1):
      net: ptp: mark filter as __initdata

Mathieu Poirier (2):
      netfilter: nfnetlink_acct: Adding quota support to accounting framework
      netfilter: nfnetlink_acct: Fix memory leak

Matt Chen (1):
      iwlwifi: mvm: add uapsd_disable module parameter

Matt Jared (1):
      i40e/i40evf: add Tx pre queue disable function

Maximilian Schneider (1):
      can: gs_usb: Added support for the GS_USB CAN devices

Michael Chan (6):
      tg3: Don't modify ip header fields when doing GSO
      tg3: Prevent page allocation failure during TSO workaround
      tg3: Update copyright and version to 3.137
      cnic: Don't take rcu_read_lock in cnic_rcv_netevent()
      cnic: Don't take cnic_dev_lock in cnic_alloc_uio_rings()
      cnic: Fix missing ISCSI_KEVENT_IF_DOWN message

Michal Kazior (51):
      ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()
      ath10k: split ce initialization and allocation
      ath10k: deinit copy engine before resetting
      ath10k: refactor monitor code
      mac80211: protect AP VLAN list with local->mtx
      cfg80211: fix radar_detect combination checking
      ath10k: reorder functions
      ath10k: refactor radar detection code
      ath10k: improve htc tx credit debugging prints
      ath10k: differentiate between target init failures
      ath10k: don't wait for device init if it crashed
      ath10k: skip suspending when recovering
      ath10k: make sure to not leak beacon dma mapping
      ath10k: make sure to not use invalid beacon pointer
      ath10k: prevent beacon memory leak
      ath10k: fix firmware recovery with ap interface
      cfg80211: allow drivers to iterate over matching combinations
      mac80211: add max channel calculation utility function
      mac80211: prevent chanctx overcommit
      mac80211: add support for radar detection for reservations
      mac80211: track assigned vifs in chanctx
      mac80211: track reserved vifs in chanctx
      mac80211: improve find_chanctx() for reservations
      mac80211: improve chanctx reservation lookup
      mac80211: split ieee80211_new_chanctx()
      mac80211: split ieee80211_free_chanctx()
      mac80211: fix racy usage of chanctx->refcount
      mac80211: compute chanctx refcount on-the-fly
      mac80211: fix CSA tx queue stopping
      mac80211: split CSA finalize function
      cfg80211: export interface stopping function
      mac80211: ignore cqm during csa
      mac80211: disconnect iface if CSA unexpectedly fails
      ath10k: fix htt rx ring clean up
      ath10k: fix handling of wierd MSDU chaining cases
      ath10k: improve warm reset reliability
      ath10k: retry warm reset a few times
      ath10k: enable early device dumps
      ath10k: fix core start sequence
      ath10k: prevent hif_stop being called twice
      ath10k: fix protected flag stripping
      ath10k: relocate core create/destroy functions
      ath10k: remove unnecessary tasklet_kill()
      ath10k: make core registering async
      ath10k: clean up start() callback
      ath10k: perform hw restart lazily
      ath10k: drain tx before restarting hw
      ath10k: protect wep tx key setup
      ath10k: dont configure bssid for ap mode
      ath10k: protect src_ring state with ce_lock in tx_sg()
      ath10k: abort incomplete scatter-gather pci tx properly

Michal Kubecek (1):
      xfrm: fix race between netns cleanup and state expire notification

Michal Kubeƒçek (3):
      vlan: more careful checksum features handling
      bonding: fix vlan_features computing
      teaming: fix vlan_features computing

Michal Schmidt (1):
      rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Mikel Astiz (3):
      Bluetooth: Refactor hci_get_auth_req()
      Bluetooth: Refactor code for outgoing dedicated bonding
      Bluetooth: Request MITM Protection when initiator

Mitch A Williams (1):
      i40evf: support ethtool RSS options

Mitch Williams (29):
      i40e: Enable VF Tx bandwidth setting
      i40e: report VF link state correctly
      i40evf: fix panic on PF driver fail
      i40evf: remove debugging message
      i40e: add required include
      i40evf: Use macro param for ethtool stats
      i40evf: don't lie to ethtool
      i40evf: make ethtool_ops const
      i40e/i40evf: set proper default for ITR registers
      i40e/i40evf: control auto ITR through ethtool
      i40e: Don't disable SR-IOV when VFs are assigned
      i40e: enable descriptor prefetch for VFs
      i40evf: don't round Tx rate down to 0
      i40evf: tweak Tx rate params and de-magic-ify
      i40evf: don't use RESETTING state during reinit
      i40evf: set descriptor multiple to 32
      i40evf: fix crash when changing ring sizes
      i40e: notify VF of all types of resets
      i40evf: make messages less dire
      i40evf: remove unnecessary log messages
      i40evf: remove bogus comment
      i40evf: clean up log message formatting
      i40evf: use correct format for printing MAC addresses
      i40e: not all VSIs have rings
      i40e/i40evf: remove chatty reset messages
      i40e: allow for more VSIs
      i40e: implement anti-spoofing for VFs
      i40evf: don't go further down
      i40evf: check admin queue error bits

Monam Agarwal (4):
      cfg80211: regulatory: use RCU_INIT_POINTER
      mac80211: use RCU_INIT_POINTER
      iwlwifi: mvm: Use RCU_INIT_POINTER(x, NULL)
      net/openvswitch: Use with RCU_INIT_POINTER(x, NULL) in vport-gre.c

Mugunthan V N (3):
      drivers: net: cpsw-phy-sel: initialize priv->dev
      drivers: net: cpsw-phy-sel: add dra7xx support for phy sel
      drivers: net: cpsw-phy-sel: add am43xx platform support

Neal Cardwell (2):
      tunnel: fix RFC number in comment for INET_ECN_decapsulate()
      tcp: make cwnd-limited checks measurement-based, and gentler

Neerav Parikh (4):
      i40e: Redistribute queue vectors after DCB reconfiguration
      i40e: Don't stop driver probe when querying DCB config fails
      i40e/i40evf: Retrieve and store missing link config information
      i40e: Separate out DCB capability and enabled flags

Neil Horman (1):
      sctp: add support for busy polling to sctp protocol

Nickolay Ledovskikh (1):
      ath5k: Fix AR5K_PHY_TXPOWER_RATE_MAX register value setting.

Nicolas Dichtel (3):
      gre: add x-netns support
      ip6gre: add x-netns support
      vxlan: add x-netns support

Nikolay Aleksandrov (1):
      bonding: make a generic sysfs option store and fix comments

Nimrod Andy (9):
      net: fec: optimize the clock management to save power
      net: fec: correct the MDIO clock source
      net: fec: use pinctrl PM helpers
      net: fec: Factorize the .xmit transmit function
      net: fec: Enable IP header hardware checksum
      net: fec: Factorize feature setting
      net: fec: Increase buffer descriptor entry number
      net: fec: Add Scatter/gather support
      net: fec: Add software TSO support

Octavian Purdila (2):
      tcp: add gfp parameter to tcp_fragment
      net: add __pskb_copy_fclone and pskb_copy_for_clone

Oleksij Rempel (11):
      ath9k-common: create common-debug and move modal_eeprom to cmn
      ath9k_htc: use ath9k_cmn_debug_modal_eeprom
      ath9k: move base_eeprom debug code to ath9k_cmn_debug_base_eeprom
      ath9k_htc: use ath9k_cmn_debug_base_eeprom
      ath9k: reorder or remove some includes
      ath9k & ath9k_htc: move ath_rx_stats to cmn
      ath9k: move recv to ath9k_cmn_debug_recv
      ath9k_htc: use ath9k_cmn_debug_recv
      ath9k: move phy_err to ath9k_cmn_debug_phy_err
      ath9k_htc: use ath9k_cmn_debug_phy_err
      ath9k_htc: fix build with disabled debug

Oliver Hartkopp (4):
      can: unify identifiers to ensure unique include processing
      can: proc: make array printing function indenpendent from sff frames
      can: add hash based access to single EFF frame filters
      can: add documentation for CAN filter usage optimisation

Olivier Sobrie (3):
      can: kvaser_usb: add retries/timeout to kvaser_usb_wait_msg()
      can: kvaser_usb: add support for Kvaser Leaf v2 and usb mini PCIe
      can: usb: Kconfig: Improve help for CAN_KVASER_USB

Ondrej Zary (1):
      orinoco_usb: Fix broken firmware load error checking

Pablo Neira (2):
      netfilter: nf_tables: relax string validation of NFTA_CHAIN_TYPE
      netfilter: bridge: fix Kconfig unmet dependencies

Pablo Neira Ayuso (19):
      netfilter: nf_tables: deconstify table and chain in context structure
      netfilter: nf_tables: generalise transaction infrastructure
      netfilter: nf_tables: relocate commit and abort routines in the source file
      netfilter: nf_tables: add message type to transactions
      netfilter: nf_tables: use new transaction infrastructure to handle sets
      netfilter: nf_tables: refactor chain statistic routines
      netfilter: nf_tables: use new transaction infrastructure to handle chain
      netfilter: nf_tables: disabling table hooks always succeeds
      netfilter: nf_tables: pass context to nf_tables_updtable()
      netfilter: nf_tables: use new transaction infrastructure to handle table
      netfilter: nf_tables: use new transaction infrastructure to handle elements
      netfilter: nf_tables: simplify nf_tables_*_notify
      netfilter: nf_tables: remove skb and nlh from context structure
      netfilter: nf_tables: defer all object release via rcu
      netfilter: nf_tables: fix wrong transaction ordering in set elements
      netfilter: nf_tables: release objects in reverse order in the abort path
      netfilter: nft_rbtree: introduce locking
      netfilter: nf_tables: allow to delete several objects from a batch
      netfilter: nf_tables: atomic allocation in set notifications from rcu callback

Patrick McHardy (6):
      netfilter: nft_ct: add missing ifdef for NFT_MARK setting
      netfilter: nft_meta: split nft_meta_init() into two functions for get/set
      netfilter: nft_ct: split nft_ct_init() into two functions for get/set
      netfilter: nf_tables: implement proper set selection
      netfilter: nft_hash: use set global element counter instead of private one
      netfilter: nf_tables: handle more than 8 * PAGE_SIZE set name allocations

Paul Bolle (6):
      w83977af_ir: remove two faux Kconfig macros
      rtlwifi: rtl8192cu: remove check for CONFIG_AUTOSUSPEND
      atm: remove commented out check
      isdn/capi: move capi_info2str to capidrv.c
      isdn/capi: Make verbose reporting depend on capidrv
      isdn/capi: fix (middleware) device nodes

Paul Gortmaker (1):
      drivers/net: fix broadcom/bcmsysport.c compile fail on SPARC

Pavel Machek (3):
      can: c_can: make {read,write}_reg functions const
      can: c_can: Add and make use of 32-bit accesses functions
      can: c_can: add hwinit support for non-TI devices

Pawel Kulakowski (1):
      mac80211: Allow disabling LDPC

Per Hurtig (1):
      tcp: fixing TLP's FIN recovery

Peter Senna Tschudin (4):
      atm: idt77252: Remove redundant error check
      bnx2x: Remove useless return variables
      vxge: Remove useless return variables
      via-ircc: Remove useless return variables

Peter Wu (1):
      rtlwifi: remove unused allow_all_destaddr functions

Petri Gynther (2):
      Bluetooth: btmrvl: Fix btmrvl_send_module_cfg_cmd()
      Bluetooth: btusb: Add Broadcom patch RAM support

Philipp Hachtmann (1):
      af_iucv: Add automatic (source) iucv_name to bind

Phoebe Buckheister (23):
      ieee802154: add definitions for link-layer security and header functions
      mac802154: account for all header parts during wpan header creationg
      ieee802154: change _cb handling slightly
      6lowpan: fix fragmentation
      ieee802154: fix dgram socket sendmsg()
      mac802154: make mac802154_wpan_open static
      ieee802154: add types for link-layer security
      mac802154: update Kconfig
      mac802154: add llsec structures and mutators
      mac802154: add llsec encryption method
      mac802154: add llsec decryption method
      mac802154: integrate llsec with wpan devices
      ieee802154: add dgram sockopts for security control
      mac802154: add llsec configuration functions
      mac802154: propagate device address changes to llsec
      ieee802154: add netlink interfaces for llsec
      ieee802154, mac802154: implement devkey record option
      mac802154: llsec: fix incorrect lock pairing
      mac802154: llsec: fold useless return value check
      mac802154: llsec: correctly lookup implicit-indexed keys
      mac802154: llsec: add forgotten list_del_rcu in key removal
      mac802154: properly free incoming skbs on decryption failure
      mac802154: don't deliver packets to devices that are down

Poulain, Loic (1):
      Bluetooth: Remove hci_h4 unused defines

Prashant Sreedharan (1):
      tg3: Override clock, link aware and link idle mode during NVRAM dump

Pravin B Shelar (1):
      openvswitch: Simplify genetlink code.

Rafa≈Ç Mi≈Çecki (33):
      b43: G-PHY: fix random mistakes to match specs
      b43: N-PHY: drop second noise variance table
      b43: N-PHY: rev3+: complete workarounds
      b43: N-PHY: random updates and typo fixes all around
      b43: N-PHY: implement reading support for radio 0x2057
      b43: N-PHY: implement RF control INTC for revs 7+
      b43: N-PHY: prepare for rev 7+ RSSI calibration
      b43: N-PHY: add init & calib values for radio 0x2056 rev 11
      b43: N-PHY: fix selection of init & calib values
      b43: N-PHY: enable forgotten write of hw power adjust table
      b43: ssb: refuse to support more than IEEE 802.11 core
      b43: remove list of IEEE 802.11 devices
      b43: bcma: respect GMODE (band choice) during core reset
      b43: use b43_software_rfkill helper
      b43: don't pre-set radio_on variable to true
      b43: N-PHY: complete radio 0x2056 setup
      b43: adjust code to compile without SSB
      b43: drop SSB dependency
      b43: split upload of init values into 2 functions
      b43: move PHY reset code into PHY specific file
      b43: complete PHY reset
      b43: rework band switching
      ssb: sprom: add dev_id field for value overriding standard ID
      b43: make B43_PCMCIA and B43_SDIO depend on B43_SSB
      b43: move bands detection to a separated function
      b43: add more devices to the bands database
      b43: xmit: set 5 GHz bit depending on current band
      b43: fix typo in define name for 2 GHz channels (s/CHAN4G/CHAN2G/)
      b43: fix list of 5 GHz channels for 802.11n cards
      b43: N-PHY: add missing calib values for radio 0x2026 rev 11
      b43: PHY: allow init optimizations by tracking PHY state
      b43: N-PHY: optimize init by doing some ops just once
      b43: N-PHY: optimize radio switching on/off

Rajesh Borundia (5):
      qlcnic: Allow SR-IOV VF probe in hypervisor.
      qlcnic: Add support to process commands in atomic context
      qlcnic: Add mac learning support to SR-IOV VF.
      qlcnic: Update version to 5.3.59
      qlcnic: Initialize mailbox cmd structure to zero

Rajkumar Manoharan (8):
      ath9k_hw: update ar9300 initvals
      ath9k_hw: fix worse EVM for 11b rates
      ath9k: Advertise support for AP mode channel width changes
      ath9k_hw: Abort transmission for sleeping station
      ath9k: Handle multiple keys while setting tx filters
      ath9k: fix sleep timer during suspend
      ath9k: Fix deadlock while updating p2p beacon timer
      ath9k: Fix interface combinations for multi-channel concurrency

Randy Dunlap (2):
      bnx2x: fix build when BNX2X_SRIOV is not enabled
      net: fix test_bpf build to depend on NET

Ravikumar Nelavelli (2):
      be2net: covert vlan array to bit-map
      be2net: fixup TX-rate setting code for Skyhawk-R

Richard Cochran (1):
      ptp: validate the requested frequency adjustment.

Richard Genoud (1):
      rt2x00: Endless loop on hub port power down

Richard Guy Briggs (6):
      netlink: simplify nfnetlink_bind
      netlink: have netlink per-protocol bind function return an error code.
      netlink: implement unbind to netlink_setsockopt NETLINK_DROP_MEMBERSHIP
      audit: add netlink audit protocol bind to check capabilities on multicast join
      audit: add netlink multicast group for log read
      audit: send multicast messages only if there are listeners

Rickard Strandqvist (5):
      net: ethernet: ibm: ehea: ehea_qmr.c: Fix for possible null pointer dereference
      qeth: Fix for possible null pointer dereference
      atm: fore200e.c: Cleaning up uninitialized variables
      net: ethernet: toshiba: ps3_gelic_net.c: Cleaning up a check on a memory allocation
      net: wimax: i2400m: control.c: Cleaning up conjunction always evaluates to false

Roopa Prabhu (2):
      unregister_netdevice : move RTM_DELLINK to until after ndo_uninit
      bridge: Add bridge ifindex to bridge fdb notify msgs

Rostislav Lisovy (3):
      mac80211: Update conf_is_ht() to work properly with 5/10MHz channels
      cfg80211: Add attributes describing prohibited channel bandwidth
      cfg80211: Use 5MHz bandwidth by default when checking usable channels

Sachin Kamat (3):
      rtlwifi: rtl8723be: Remove duplicate inclusion of phy.h
      rtlwifi: rtl8723ae: Remove duplicate inclusion of fw_common.h
      net: tso: Export symbols for modular build

Sascha Hauer (2):
      net: phy: genphy: Allow overwriting features
      net: phy: make of_set_phy_supported work with genphy driver

Sasha Levin (1):
      net: Revert "fib_trie: use seq_file_net rather than seq->private"

Sathya Perla (5):
      be2net: fix line wrap and function call indentation in be_main.c
      be2net: fix function call indentation in be_cmds.c
      be2net: fix line wrap and function call indentation in be_ethtool.c
      be2net: move async cmd processing to a separate routine
      be2net: cleanup MCC async event processing code

Sekhar Nori (1):
      net: davinci_emac: fix oops caused by uninitialized ndev->dev

Sergei Shtylyov (3):
      sh_eth: replace devm_kzalloc() with devm_kmalloc_array()
      can: add Renesas R-Car CAN driver
      sh_eth: fix SH7619/771x support

Shahed Shaikh (5):
      qlcnic: Optimize MAC learning code
      qlcnic: Collect firmware dump using DMA on 82xx adapters
      qlcnic: Pre-allocate DMA buffer used for minidump collection
      qlcnic: Optimize ring count validations
      qlcnic: Update version to 5.3.60

Shani Michaelli (2):
      net/mlx4_en: Fix errors in MAC address changing when port is down
      net/mlx4_en: Protect MAC address modification with the state_lock mutex

Shannon Nelson (28):
      i40e/i40evf: add tracking to NVM busy state
      i40e/i40evf: update AdminQ API
      i40e: prep vsi_open logic for non-netdev cases
      i40e: abstract the close path for better netdev vsis
      i40e: use generic vsi_open to unquiesce vsi
      i40e: rework fdir setup and teardown
      i40e/i40evf: add driver version string to driver version command
      i40evf: Update AdminQ interface
      i40e: remove hardcode of stats struct size in ethtool
      i40e: add clear_pxe AdminQ request
      i40e: relax the firmware API version check
      i40e: refactor stats collection
      i40e/i40evf: remove rx_errors and rx_missed
      i40e: add missing VSI statistics
      i40e: set lan_veb index
      i40e: add VEB stats to ethtool
      i40e: increase reset wait time
      i40e: add vsi x-cast stats
      i40e: add xcast stats for port
      i40e: don't remove HMC that doesn't exist
      i40e: remove irqs only when they are set up
      i40e: clear pxe after adminq is rebuilt
      i40e: add checks for AQ error status bits
      i40e: remove unused variable and memory allocation
      i40e: don't complain about removing non-existent addresses
      i40e/i40evf: bump version to 0.4.7 for i40e and 0.9.31 for i40evf
      i40e/i40evf: AdminQ API update for new FW
      i40e: use stored base_queue value

Shruti Kanetkar (2):
      net/phy: Remove return value for void function
      net/fsl: Make xgmac_mdio read error message useful

Simon Horman (1):
      MPLS: Use mpls_features to activate software MPLS GSO segmentation

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Stanislaw Gruszka (1):
      rt2x00: restore original beaconing state

Stefan Raspl (3):
      qeth: Fix default queue setting in priority queueing
      qeth: Extend priority queueing to IPv6
      qeth: Add new priority queueing options

Stefano Babic (1):
      can: move SPI drivers into a separate directory

Stephen Boyd (6):
      devicetree: bindings: Properly document micrel ks8851 SPI chips
      net: ks8851: Use devm_regulator_get_optional()
      net: ks8851: Add optional vdd_io regulator and reset gpio
      net: ks8851: Add of match table
      net: ks8851: Don't use regulator_get_optional()
      net: ks8851: Don't use regulator_get_optional()

Stephen Hemminger (1):
      i40e,igb,ixgbe: remove usless return statements

St√©phane Graber (1):
      net: Allow tc changes in user namespaces

Sucheta Chakraborty (4):
      qlcnic: Allow setting TX interrupt coalescing parameters from VF.
      qlcnic: Add driver logs in error path.
      qlcnic: Limit vNIC support in legacy interrupt mode
      net-next:v4: Add support to configure SR-IOV VF minimum and maximum Tx rate through ip tool.

Sujith Sankar (1):
      enic: Add support for adaptive interrupt coalescing

Sven Wegener (2):
      ipv6: Fix regression caused by efe4208 in udp_v6_mcast_next()
      ipv6: Shrink udp_v6_mcast_next() to one socket variable

Tetsuo Handa (2):
      xfrm: Remove useless secid field from xfrm_audit.
      xfrm: Remove useless xfrm_audit struct.

Thierry Escande (3):
      NFC: port100: Add support for type 4B tag
      NFC: digital: Return proper error code when sending ATR_REQ
      NFC: digital: Randomize poll cycles

Thomas Graf (1):
      pktgen: Use seq_puts() where seq_printf() is not needed

Thomas Petazzoni (5):
      net: phy: decouple PHY id and PHY address in fixed PHY driver
      net: phy: extend fixed driver with fixed_phy_register()
      of: provide a binding for fixed link PHYs
      net: mvneta: add support for fixed links
      ARM: mvebu: use the fixed-link PHY DT binding for the Armada XP Matrix board

Timo Mueller (1):
      Bluetooth: Use MITM Protection when IO caps allow it

Tobias Klauser (6):
      bcm63xx_enet: Use ARRAY_SIZE instead of open coding it
      Altera TSE: Remove unnecessary cast of void pointers
      e1000: Use is_broadcast_ether_addr/is_multicast_ether_addr helpers
      i40evf: Use is_multicast_ether_addr helper
      net: tile: Use helpers from linux/etherdevice.h to check/set MAC
      net: tile: Remove unnecessary memset of netdev private data

Todd Fujinaka (5):
      e1000e: 82574/82583 TimeSync errata for SYSTIM read
      igb: remove redundant PHY power down register write
      igb: use mac loopback for i354 backplane
      igb: add defaults for i210 TX/RX PBSIZE
      igb: unhide invariant returns

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Tom Herbert (31):
      net: Allow csum_add to be provided in arch
      x86_64: csum_add for x86_64
      net: Change x86_64 add32_with_carry to allow memory operand
      sparc: csum_add for Sparc
      net: Generalize checksum_init functions
      net: Call skb_checksum_init in IPv4
      net: Call skb_checksum_init in IPv6
      net: Implmement RFC 6936 (zero RX csums for UDP/IPv6)
      ipv6: Need to sock_put on csum error
      gre: Call skb_checksum_simple_validate
      gre6: Call skb_checksum_simple_validate
      igmp: Call skb_checksum_simple_validate
      icmp: Call skb_checksum_simple_validate
      icmp6: Call skb_checksum_validate
      net: Verify UDP checksum before handoff to encap
      l2tp: Remove UDP checksum verification
      sunrpc: Remove sk_no_check setting
      net: Eliminate no_check from protosw
      net: Split sk_no_check into sk_no_check_{rx,tx}
      net: Make enabling of zero UDP6 csums more restrictive
      l2tp: Add support for zero IPv6 checksums
      udp: Generic functions to set checksum
      l2tp: call udp{6}_set_csum
      net: Support for multiple checksums with gso
      tcp: Call gso_make_checksum
      net: Add GSO support for UDP tunnels with checksum
      gre: Call gso_make_checksum
      vxlan: Add support for UDP checksums (v4 sending, v6 zero csums)
      net: Preserve CHECKSUM_COMPLETE at validation
      net: Save software checksum complete
      net: Add skb_gro_postpull_rcsum to udp and vxlan

Tom Lendacky (1):
      amd-xgbe: Remove unnecessary include

Tomasz Bursztyka (3):
      netfilter: nf_tables: Stack expression type depending on their family
      netfilter: nf_tables: Make meta expression core functions public
      netfilter: nf_tables: Add meta expression key for bridge interface name

Toshiaki Makita (5):
      bridge: Fix incorrect judgment of promisc
      bridge: Add 802.1ad tx vlan acceleration
      bridge: Prepare for 802.1ad vlan filtering support
      bridge: Prepare for forwarding another bridge group addresses
      bridge: Support 802.1ad vlan filtering

Ursula Braun (2):
      af_iucv: correct cleanup if listen backlog is full
      s390/net: fix format string mismatches

Varka Bhadram (1):
      mrf24j40: add device managed APIs

Vasu Dev (1):
      i40: disable FCoE for MFP modes

Vasundhara Volam (1):
      be2net: support flashing new regions on Skyhawk-R

Veaceslav Falico (11):
      bonding: remove BOND_MODE_IS_LB macro
      bonding: make TX_QUEUE_OVERRIDE() macro an inline function
      bonding: make BOND_NO_USES_ARP an inline function
      bonding: make USES_PRIMARY inline functions
      bonding: create a macro for bond mode and use it
      bonding: make IS_IP_TARGET_UNUSABLE_ADDRESS an inline function
      bonding: convert IS_UP(slave->dev) to inline function
      bonding: rename {, bond_}slave_can_tx and clean it up
      bonding: replace SLAVE_IS_OK() with bond_slave_can_tx()
      bonding: populate essential new_slave->bond/dev early
      bonding: remove NULL verification from bond_get_bond_by_slave()

Venkata Duvvuru (2):
      ethtool: Support for configurable RSS hash key
      be2net: Support for configurable RSS hash key

Vlad Yasevich (9):
      bridge: Turn flag change macro into a function.
      bridge: Keep track of ports capable of automatic discovery.
      bridge: Add functionality to sync static fdb entries to hw
      bridge: Introduce BR_PROMISC flag
      bridge: Add addresses from static fdbs to non-promisc ports
      bridge: Automatically manage port promiscuous mode.
      bonding: Turn on IFF_UNICAST_FLT on bond devices
      macvlan: Support bonding events
      bonding: Support macvlans on top of tlb/rlb mode bonds

Vladimir Kondratiev (11):
      wil6210: fix printouts for better readability
      wil6210: sync with the latest FW API
      wil6210: relaxed check for BACK start sequence
      wil6210: Use larger Tx rings
      wil6210: limit MTU
      wil6210: limit fw error recovery attempts
      wil6210: inline functions for vring hi/lo watermarks
      wil6210: detect scan timeouts
      wil6210: improve pointers printing
      wil6210: optimize wil_release_reorder_frames
      wil6210: improve debug for WMI receive

WANG Cong (9):
      ipv6: remove unused function ipv6_inherit_linklocal()
      net: clean up snmp stats code
      ipv4: remove inet_addr_hash_lock in devinet.c
      net: rename local_df to ignore_df
      ipv4: make ip_local_reserved_ports per netns
      snmp: fix some left over of snmp stats
      net: remove some unless free on failure in alloc_netdev_mqs()
      net: use the new API kvfree()
      ipv4: use skb frags api in udp4_hwcsum()

Wei Liu (2):
      xen-netback: Factor queue-specific data into queue struct
      xen-netfront: initialise queue name in xennet_init_queue

Wei Yang (1):
      net/mlx4_core: Keep only one driver entry release mlx4_priv

Wei-Chun Chao (1):
      net: fix UDP tunnel GSO of frag_list GRO packets

Weiping Pan (1):
      tcp: make tcp_cwnd_application_limited() static

Wilfried Klaebe (1):
      net: get rid of SET_ETHTOOL_OPS

Xi Wang (1):
      net-tun: restructure tun_do_read for better sleep/wakeup efficiency

Xiubo Li (1):
      gianfar: Fix the section mismatch warnings.

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem

Yang Wei (1):
      net: driver: stmicro: Remove some useless the lock protection

Yang Yingliang (1):
      sch_hhf: fix comparison of qlen and limit

Yaniv Rosner (2):
      bnx2x: Fix link for KR with swapped polarity lane
      bnx2x: Fix 1G-baseT link

Ying Xue (27):
      tipc: replace config_mutex lock with RTNL lock
      tipc: adjust locking policy of protecting tipc_ptr pointer of net_device
      tipc: use RTNL lock to protect tipc_net_stop routine
      tipc: convert bearer_list to RCU list
      tipc: decouple the relationship between bearer and link
      tipc: use RCU to protect media_ptr pointer
      tipc: purge tipc_net_lock lock
      tipc: make media_ptr pointed netdevice valid
      tipc: use bearer_disable to disable bearer in tipc_l2_device_event
      tipc: use bc_lock to protect node map in bearer structure
      tipc: fix race in disc create/delete
      neterion/s2io: remove unused s2io_start_tx_queue routine
      tipc: fix a possible memory leak
      tipc: move the delivery of named messages out of nametbl lock
      tipc: fix memory leak of publications
      tipc: always use tipc_node_lock() to hold node lock
      tipc: adjust order of variables in tipc_node structure
      tipc: rename setup_blocked variable of node struct to flags
      tipc: avoid to asynchronously notify subscriptions
      tipc: remove TIPC_NAMES_GONE node flag
      tipc: avoid to asynchronously deliver name tables to peer node
      tipc: define new functions to operate bc_lock
      tipc: convert allocations of global variables associated with bclink
      tipc: avoid to asynchronously reset all links
      tipc: purge signal handler infrastructure
      tipc: rename enum names of node flags
      tipc: don't directly overwrite node action_flags

Yongjian Xu (1):
      e1000: remove the check: skb->len<=0

Yoshihiro Shimoda (2):
      net: sh_eth: Fix receive packet "exceeded" condition in sh_eth_rx()
      net: sh_eth: Fix timing of RACT setting in sh_eth_rx()

Yuchung Cheng (4):
      tcp: move fastopen functions to tcp_fastopen.c
      tcp: simplify fast open cookie processing
      tcp: use tcp_v4_send_synack on first SYN-ACK
      tcp: improve fastopen icmp handling

Yuval Atias (3):
      net/mlx4_core: Enforce irq affinity changes immediatly
      net/mlx4_en: Use affinity hint
      net/mlx4_en: Use affinity hint

Yuval Mintz (1):
      bnx2x: Check for UNDI in uncommon branch

Zefir Kurtisi (3):
      ath9k: non-functional: calculate DFS pulse interval per-wiphy
      ath9k: fix build error with disabled debug
      ath9k: simplify DFS pulse interval debug printing

Zhangfei Gao (2):
      Documentation: add Device tree bindings for Hisilicon hix5hd2 ethernet
      net: hisilicon: add hix5hd2 mac driver

Zhangjie \(HZ\) (1):
      virtio-net: Set needed_headroom for virtio-net when VIRTIO_F_ANY_LAYOUT is true

Zhao, Gang (11):
      cfg80211: slightly clean up of cfg80211_sme_connect()
      mac80211: fix some missing includes
      cfg80211: remove unused wiphy argument from cfg80211_wext_freq()
      mac80211: return bool instead of numbers in yes/no function
      mac80211: remove unnecessary BUG_ON()
      cfg80211: change registered device pointer name
      cfg80211: change wiphy_to_dev function name
      cfg80211: change return value of notifier function
      mac80211: change return value of notifier function
      mac80211: avoid calling useless channel context code
      mac80211: remove unnecessary assignment

Zoltan Kiss (1):
      xen-netback: Fix handling of skbs requiring too many slots

chaitanya.mgit@gmail.com (1):
      regdb: Generalize the mW to dBm power conversion

dingtianhong (9):
      bonding: remove the unnecessary struct bond_net
      bonding: simplify the slave_do_arp_validate_only()
      bonding: remove the unused macro
      vlan: rename __vlan_find_dev_deep() to __vlan_find_dev_deep_rcu()
      bonding: alloc the structure ad_info dynamically in per slave
      macvlan: Propagate lowerdev MTU changes
      macvlan: simplify the structure port
      macvlan: fix the problem when mac address changes for passthru mode
      macvlan: add netpoll support

fran√ßois romieu (1):
      amd-xgbe: fix unused variable compilation warning in phylib driver

huizhang (1):
      net: ipv6: Fixed up ipsec packet be re-routing issue

stephen hemminger (5):
      bridge: fix spelling of promiscuous
      ipv4: minor spelling fix
      hyper-v: make uuid_le const
      gre: allow changing mac address when device is up
      ceph: remove bogus extern

wangweidong (5):
      rds: remove the unneed NULL checking
      Revert "sctp: optimize the sctp_sysctl_net_register"
      sctp: add a checking for sctp_sysctl_net_register
      dccp: make the request_retries minimum is 1
      bridge: fix the unbalanced promiscuous count when add_if failed

wenxiong@linux.vnet.ibm.com (2):
      bnx2x: Adapter not recovery from EEH error injection
      bnx2x: Fix kernel crash and data miscompare after EEH recovery

xiao jin (2):
      net_namespace: trivial cleanup
      inetpeer_gc_worker: trivial cleanup

 Documentation/ABI/testing/sysfs-class-net                                 |    8 +
 Documentation/ABI/testing/sysfs-class-net-cdc_ncm                         |  149 ++++
 Documentation/ABI/testing/sysfs-class-net-queues                          |   79 ++
 Documentation/ABI/testing/sysfs-class-net-statistics                      |  201 +++++
 Documentation/DocBook/80211.tmpl                                          |    1 +
 Documentation/devicetree/bindings/net/amd-xgbe-phy.txt                    |   17 +
 Documentation/devicetree/bindings/net/amd-xgbe.txt                        |   34 +
 Documentation/devicetree/bindings/net/broadcom-bcmgenet.txt               |    2 +-
 Documentation/devicetree/bindings/net/broadcom-systemport.txt             |   29 +
 Documentation/devicetree/bindings/net/can/xilinx_can.txt                  |   44 ++
 Documentation/devicetree/bindings/net/cpsw-phy-sel.txt                    |    4 +-
 Documentation/devicetree/bindings/net/fixed-link.txt                      |   42 +
 Documentation/devicetree/bindings/net/fsl-tsec-phy.txt                    |    5 +-
 Documentation/devicetree/bindings/net/hisilicon-hix5hd2-gmac.txt          |   36 +
 Documentation/devicetree/bindings/net/ieee802154/at86rf230.txt            |   23 +
 Documentation/devicetree/bindings/net/micrel-ks8851.txt                   |   15 +-
 Documentation/devicetree/bindings/net/micrel-ksz9021.txt                  |   49 --
 Documentation/devicetree/bindings/net/micrel-ksz90x1.txt                  |   83 ++
 Documentation/devicetree/bindings/net/nfc/pn544.txt                       |   35 +
 Documentation/devicetree/bindings/net/nfc/st21nfca.txt                    |   33 +
 Documentation/devicetree/bindings/net/nfc/trf7970a.txt                    |    2 +
 Documentation/devicetree/bindings/net/via-rhine.txt                       |   17 +
 Documentation/driver-model/devres.txt                                     |    5 +
 Documentation/networking/bonding.txt                                      |   44 +-
 Documentation/networking/can.txt                                          |   35 +
 Documentation/networking/cdc_mbim.txt                                     |  339 ++++++++
 Documentation/networking/filter.txt                                       |  423 +++++++++-
 MAINTAINERS                                                               |   19 +-
 arch/arm/boot/dts/am33xx.dtsi                                             |    2 +
 arch/arm/boot/dts/am4372.dtsi                                             |    2 +
 arch/arm/boot/dts/armada-xp-matrix.dts                                    |    4 +
 arch/arm/boot/dts/vt8500.dtsi                                             |    6 +
 arch/arm/boot/dts/wm8650.dtsi                                             |    6 +
 arch/arm/boot/dts/wm8850.dtsi                                             |    6 +
 arch/arm/mach-tegra/board-paz00.c                                         |    4 +-
 arch/arm/net/bpf_jit_32.c                                                 |  139 ++--
 arch/mips/bcm47xx/sprom.c                                                 |    1 +
 arch/powerpc/net/bpf_jit_64.S                                             |    2 +-
 arch/powerpc/net/bpf_jit_comp.c                                           |  157 ++--
 arch/powerpc/sysdev/fsl_soc.c                                             |   32 -
 arch/s390/net/bpf_jit_comp.c                                              |  163 ++--
 arch/sparc/include/asm/checksum_32.h                                      |   12 +
 arch/sparc/include/asm/checksum_64.h                                      |   12 +
 arch/sparc/net/bpf_jit_comp.c                                             |  162 ++--
 arch/x86/include/asm/checksum_64.h                                        |    9 +-
 arch/x86/net/bpf_jit.S                                                    |   77 +-
 arch/x86/net/bpf_jit_comp.c                                               | 1399 ++++++++++++++++++---------------
 drivers/atm/fore200e.c                                                    |    2 +-
 drivers/atm/idt77252.c                                                    |    8 +-
 drivers/bluetooth/ath3k.c                                                 |    3 +-
 drivers/bluetooth/btmrvl_drv.h                                            |    4 +-
 drivers/bluetooth/btmrvl_main.c                                           |   19 +-
 drivers/bluetooth/btmrvl_sdio.c                                           |  103 ++-
 drivers/bluetooth/btmrvl_sdio.h                                           |    3 +
 drivers/bluetooth/btusb.c                                                 |  155 +++-
 drivers/bluetooth/hci_h4.c                                                |    7 -
 drivers/clk/ti/clk-43xx.c                                                 |   16 +
 drivers/hv/channel_mgmt.c                                                 |    2 +-
 drivers/hv/hyperv_vmbus.h                                                 |    6 +-
 drivers/hv/vmbus_drv.c                                                    |   10 +-
 drivers/infiniband/hw/cxgb4/cm.c                                          |  127 ++-
 drivers/infiniband/hw/cxgb4/cq.c                                          |    7 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h                                    |    2 +
 drivers/infiniband/hw/cxgb4/provider.c                                    |    2 +-
 drivers/infiniband/hw/cxgb4/t4.h                                          |    1 +
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h                                 |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c                              |    2 +-
 drivers/isdn/capi/Kconfig                                                 |   18 +-
 drivers/isdn/capi/capi.c                                                  |    4 +-
 drivers/isdn/capi/capidrv.c                                               |  195 +++++
 drivers/isdn/capi/capiutil.c                                              |  200 -----
 drivers/isdn/hisax/hfc4s8s_l1.c                                           |  111 +--
 drivers/isdn/i4l/isdn_ppp.c                                               |    4 +-
 drivers/isdn/mISDN/l1oip_core.c                                           |   14 +-
 drivers/mmc/host/mmc_spi.c                                                |   18 +-
 drivers/net/bonding/bond_3ad.c                                            |   62 +-
 drivers/net/bonding/bond_alb.c                                            |  153 ++--
 drivers/net/bonding/bond_alb.h                                            |    1 +
 drivers/net/bonding/bond_debugfs.c                                        |    2 +-
 drivers/net/bonding/bond_main.c                                           |  218 ++---
 drivers/net/bonding/bond_netlink.c                                        |    8 +-
 drivers/net/bonding/bond_options.c                                        |   66 +-
 drivers/net/bonding/bond_options.h                                        |    2 +
 drivers/net/bonding/bond_procfs.c                                         |   16 +-
 drivers/net/bonding/bond_sysfs.c                                          |  567 +++----------
 drivers/net/bonding/bond_sysfs_slave.c                                    |    4 +-
 drivers/net/bonding/bonding.h                                             |  143 ++--
 drivers/net/can/Kconfig                                                   |   30 +-
 drivers/net/can/Makefile                                                  |    4 +-
 drivers/net/can/c_can/c_can.c                                             |   15 +-
 drivers/net/can/c_can/c_can.h                                             |    8 +-
 drivers/net/can/c_can/c_can_pci.c                                         |   78 +-
 drivers/net/can/c_can/c_can_platform.c                                    |   84 +-
 drivers/net/can/mscan/Kconfig                                             |    2 +-
 drivers/net/can/rcar_can.c                                                |  876 +++++++++++++++++++++
 drivers/net/can/softing/softing_main.c                                    |   20 +-
 drivers/net/can/spi/Kconfig                                               |   10 +
 drivers/net/can/spi/Makefile                                              |    8 +
 drivers/net/can/{ => spi}/mcp251x.c                                       |   95 ++-
 drivers/net/can/usb/Kconfig                                               |   12 +-
 drivers/net/can/usb/Makefile                                              |    1 +
 drivers/net/can/usb/gs_usb.c                                              |  971 +++++++++++++++++++++++
 drivers/net/can/usb/kvaser_usb.c                                          |   53 +-
 drivers/net/can/xilinx_can.c                                              | 1208 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6123_61_65.c                                         |    2 +-
 drivers/net/dsa/mv88e6131.c                                               |    4 +-
 drivers/net/dsa/mv88e6xxx.c                                               |   12 +-
 drivers/net/ethernet/3com/3c509.c                                         |    2 +-
 drivers/net/ethernet/3com/3c589_cs.c                                      |    2 +-
 drivers/net/ethernet/3com/typhoon.c                                       |    2 +-
 drivers/net/ethernet/8390/ax88796.c                                       |    4 +-
 drivers/net/ethernet/Kconfig                                              |    1 +
 drivers/net/ethernet/Makefile                                             |    1 +
 drivers/net/ethernet/adaptec/starfire.c                                   |    2 +-
 drivers/net/ethernet/alteon/acenic.c                                      |    2 +-
 drivers/net/ethernet/altera/altera_sgdma.c                                |    1 -
 drivers/net/ethernet/altera/altera_tse_ethtool.c                          |    2 +-
 drivers/net/ethernet/amd/Kconfig                                          |   14 +-
 drivers/net/ethernet/amd/Makefile                                         |    1 +
 drivers/net/ethernet/amd/amd8111e.c                                       |    2 +-
 drivers/net/ethernet/amd/ariadne.c                                        |    3 -
 drivers/net/ethernet/amd/au1000_eth.c                                     |    2 +-
 drivers/net/ethernet/amd/hplance.c                                        |    4 +-
 drivers/net/ethernet/amd/mvme147.c                                        |    6 +-
 drivers/net/ethernet/amd/nmclan_cs.c                                      |    2 +-
 drivers/net/ethernet/amd/xgbe/Makefile                                    |    6 +
 drivers/net/ethernet/amd/xgbe/xgbe-common.h                               | 1007 ++++++++++++++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c                              |  375 +++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c                                 |  556 +++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c                                  | 2182 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                                  | 1351 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c                              |  510 ++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                                 |  512 ++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                                 |  433 ++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe.h                                      |  676 ++++++++++++++++
 drivers/net/ethernet/arc/emac_main.c                                      |   49 ++
 drivers/net/ethernet/atheros/alx/main.c                                   |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c                        |    6 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c                        |    6 +-
 drivers/net/ethernet/atheros/atlx/atl1.c                                  |    4 +-
 drivers/net/ethernet/atheros/atlx/atl2.c                                  |    6 +-
 drivers/net/ethernet/broadcom/Kconfig                                     |   11 +
 drivers/net/ethernet/broadcom/Makefile                                    |    1 +
 drivers/net/ethernet/broadcom/b44.c                                       |    2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c                              |    7 +-
 drivers/net/ethernet/broadcom/bcmsysport.c                                | 1654 ++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bcmsysport.h                                |  678 ++++++++++++++++
 drivers/net/ethernet/broadcom/bgmac.c                                     |    2 +-
 drivers/net/ethernet/broadcom/bnx2.c                                      |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                               |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                           |   14 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                           |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c                           |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h                           |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c                       |   23 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_file_hdr.h                   |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h                          |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h                      |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c                          |   36 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                          |   49 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c                            |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h                            |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c                         |   15 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h                         |    8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c                         |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h                         |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c                          |    6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h                          |    4 +-
 drivers/net/ethernet/broadcom/cnic.c                                      |   29 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                            |    2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c                              |   21 +-
 drivers/net/ethernet/broadcom/tg3.c                                       |  104 ++-
 drivers/net/ethernet/broadcom/tg3.h                                       |    2 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c                           |    6 +-
 drivers/net/ethernet/calxeda/xgmac.c                                      |    2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                                 |    6 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c                           |    6 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c                        |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                                |   14 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                           |  263 +++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h                            |    7 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c                                  |   11 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h                                |    1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h                               |   10 +
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                       |    2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c                                |    7 +-
 drivers/net/ethernet/cisco/enic/enic.h                                    |   32 +-
 drivers/net/ethernet/cisco/enic/enic_dev.c                                |    4 +-
 drivers/net/ethernet/cisco/enic/enic_dev.h                                |    4 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c                            |   67 +-
 drivers/net/ethernet/cisco/enic/enic_main.c                               |  323 +++++---
 drivers/net/ethernet/cisco/enic/vnic_cq.h                                 |    9 +
 drivers/net/ethernet/cisco/enic/vnic_dev.c                                |    4 +-
 drivers/net/ethernet/cisco/enic/vnic_dev.h                                |    4 +-
 drivers/net/ethernet/davicom/dm9000.c                                     |   66 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c                               |    2 +-
 drivers/net/ethernet/dec/tulip/uli526x.c                                  |    4 +-
 drivers/net/ethernet/dlink/dl2k.c                                         |    6 +-
 drivers/net/ethernet/dlink/sundance.c                                     |    2 +-
 drivers/net/ethernet/ec_bhf.c                                             |   20 +-
 drivers/net/ethernet/emulex/benet/be.h                                    |   15 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                               |  610 +++++++-------
 drivers/net/ethernet/emulex/benet/be_cmds.h                               |   85 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c                            |  194 +++--
 drivers/net/ethernet/emulex/benet/be_hw.h                                 |   12 +-
 drivers/net/ethernet/emulex/benet/be_main.c                               |  581 ++++++++------
 drivers/net/ethernet/ethoc.c                                              |    6 -
 drivers/net/ethernet/faraday/ftgmac100.c                                  |    2 +-
 drivers/net/ethernet/faraday/ftmac100.c                                   |    2 +-
 drivers/net/ethernet/freescale/Kconfig                                    |    1 +
 drivers/net/ethernet/freescale/fec.h                                      |   13 +-
 drivers/net/ethernet/freescale/fec_main.c                                 |  661 ++++++++++++----
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c                     |   17 +-
 drivers/net/ethernet/freescale/gianfar.c                                  |   22 +-
 drivers/net/ethernet/freescale/ucc_geth.c                                 |   14 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c                         |    2 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c                               |    4 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c                                 |    2 +-
 drivers/net/ethernet/hisilicon/Kconfig                                    |   27 +
 drivers/net/ethernet/hisilicon/Makefile                                   |    5 +
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c                             | 1066 +++++++++++++++++++++++++
 drivers/net/ethernet/ibm/ehea/ehea_ethtool.c                              |    6 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c                                 |    5 +-
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c                                  |    4 +-
 drivers/net/ethernet/ibm/emac/core.c                                      |    2 +-
 drivers/net/ethernet/icplus/ipg.c                                         |    2 +-
 drivers/net/ethernet/intel/e100.c                                         |    2 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c                          |    9 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c                               |    4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c                             |    5 -
 drivers/net/ethernet/intel/e1000e/80003es2lan.c                           |    1 +
 drivers/net/ethernet/intel/e1000e/82571.c                                 |    1 +
 drivers/net/ethernet/intel/e1000e/e1000.h                                 |   41 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c                               |   17 +-
 drivers/net/ethernet/intel/e1000e/hw.h                                    |    3 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                               |   62 +-
 drivers/net/ethernet/intel/e1000e/mac.c                                   |    9 +-
 drivers/net/ethernet/intel/e1000e/mac.h                                   |    3 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                                |   88 ++-
 drivers/net/ethernet/intel/e1000e/nvm.c                                   |    1 +
 drivers/net/ethernet/intel/e1000e/param.c                                 |    4 +
 drivers/net/ethernet/intel/e1000e/phy.c                                   |    1 +
 drivers/net/ethernet/intel/i40e/i40e.h                                    |   35 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c                             |   60 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.h                             |    1 +
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h                         |  137 ++--
 drivers/net/ethernet/intel/i40e/i40e_common.c                             |  141 +++-
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c                             |    6 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c                            |   21 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.c                               |   50 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                            |  311 +++++---
 drivers/net/ethernet/intel/i40e/i40e_hmc.c                                |    7 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.h                                |    7 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c                            |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h                            |    1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c                               | 1124 ++++++++++++++++----------
 drivers/net/ethernet/intel/i40e/i40e_prototype.h                          |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c                                |   37 -
 drivers/net/ethernet/intel/i40e/i40e_register.h                           |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                               |  131 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h                               |   18 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h                               |   53 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl.h                           |    4 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                        |  209 ++++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h                        |    6 +-
 drivers/net/ethernet/intel/i40evf/Makefile                                |    5 +-
 drivers/net/ethernet/intel/i40evf/i40e_adminq.c                           |   61 +-
 drivers/net/ethernet/intel/i40evf/i40e_adminq.h                           |    6 +-
 drivers/net/ethernet/intel/i40evf/i40e_adminq_cmd.h                       |  164 ++--
 drivers/net/ethernet/intel/i40evf/i40e_alloc.h                            |    5 +-
 drivers/net/ethernet/intel/i40evf/i40e_common.c                           |   13 +-
 drivers/net/ethernet/intel/i40evf/i40e_hmc.h                              |   12 +-
 drivers/net/ethernet/intel/i40evf/i40e_lan_hmc.h                          |    6 +-
 drivers/net/ethernet/intel/i40evf/i40e_osdep.h                            |    5 +-
 drivers/net/ethernet/intel/i40evf/i40e_prototype.h                        |    5 +-
 drivers/net/ethernet/intel/i40evf/i40e_register.h                         |   17 +-
 drivers/net/ethernet/intel/i40evf/i40e_status.h                           |    5 +-
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c                             |   84 +-
 drivers/net/ethernet/intel/i40evf/i40e_txrx.h                             |   23 +-
 drivers/net/ethernet/intel/i40evf/i40e_type.h                             |   67 +-
 drivers/net/ethernet/intel/i40evf/i40e_virtchnl.h                         |    9 +-
 drivers/net/ethernet/intel/i40evf/i40evf.h                                |    7 +-
 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c                        |  423 ++++++++--
 drivers/net/ethernet/intel/i40evf/i40evf_main.c                           |  185 +++--
 drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c                       |   62 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                              |  121 ++-
 drivers/net/ethernet/intel/igb/e1000_82575.h                              |   72 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h                            |  100 ++-
 drivers/net/ethernet/intel/igb/e1000_hw.h                                 |   96 ++-
 drivers/net/ethernet/intel/igb/e1000_i210.c                               |  134 ++--
 drivers/net/ethernet/intel/igb/e1000_i210.h                               |   47 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c                                |   56 +-
 drivers/net/ethernet/intel/igb/e1000_mac.h                                |   47 +-
 drivers/net/ethernet/intel/igb/e1000_mbx.c                                |   47 +-
 drivers/net/ethernet/intel/igb/e1000_mbx.h                                |   47 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.c                                |   48 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.h                                |   49 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c                                |   66 +-
 drivers/net/ethernet/intel/igb/e1000_phy.h                                |   48 +-
 drivers/net/ethernet/intel/igb/e1000_regs.h                               |   58 +-
 drivers/net/ethernet/intel/igb/igb.h                                      |   49 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c                              |  151 ++--
 drivers/net/ethernet/intel/igb/igb_hwmon.c                                |   47 +-
 drivers/net/ethernet/intel/igb/igb_main.c                                 |  203 ++---
 drivers/net/ethernet/intel/igb/igb_ptp.c                                  |   60 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c                                |    7 +-
 drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c                            |    6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                                  |   21 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c                            |   89 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c                            |   85 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                           |   80 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h                           |   31 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.c                              |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c                        |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82599.c                        |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82599.h                        |   24 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c                           |   28 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c                          |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c                          |   96 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h                             |    2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                              |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                             |  356 ++++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.c                              |   10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h                              |    6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                              |   68 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h                              |   32 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                              |  164 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                            |   66 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h                            |    5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                             |   62 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c                             |   15 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c                              |    6 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c                         |    2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c                                |  376 ++++++---
 drivers/net/ethernet/marvell/mvmdio.c                                     |   18 +-
 drivers/net/ethernet/marvell/mvneta.c                                     |  324 ++++++--
 drivers/net/ethernet/marvell/pxa168_eth.c                                 |    2 +-
 drivers/net/ethernet/marvell/sky2.c                                       |    2 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c                                  |  112 +--
 drivers/net/ethernet/mellanox/mlx4/cq.c                                   |    3 +
 drivers/net/ethernet/mellanox/mlx4/en_cq.c                                |   15 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                           |   25 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c                              |    7 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                            |   57 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                                |   28 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                                |   14 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c                                   |  147 ++--
 drivers/net/ethernet/mellanox/mlx4/fw.c                                   |   24 +-
 drivers/net/ethernet/mellanox/mlx4/main.c                                 |  278 +++----
 drivers/net/ethernet/mellanox/mlx4/mcg.c                                  |   18 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                                 |   17 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                              |   41 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c                                   |   16 +-
 drivers/net/ethernet/mellanox/mlx4/port.c                                 |   12 +-
 drivers/net/ethernet/mellanox/mlx4/profile.c                              |   13 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c                                   |    7 +-
 drivers/net/ethernet/mellanox/mlx4/reset.c                                |   24 +-
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c                     |  124 +--
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                             |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                              |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c                            |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h                       |   30 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c                              |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                       |   15 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c                              |    4 +-
 drivers/net/ethernet/micrel/ks8695net.c                                   |    6 +-
 drivers/net/ethernet/micrel/ks8851.c                                      |   87 +-
 drivers/net/ethernet/micrel/ksz884x.c                                     |    5 +-
 drivers/net/ethernet/microchip/enc28j60.c                                 |    2 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                          |    2 +-
 drivers/net/ethernet/natsemi/natsemi.c                                    |    2 +-
 drivers/net/ethernet/natsemi/ns83820.c                                    |    2 +-
 drivers/net/ethernet/neterion/s2io.c                                      |   15 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c                          |   22 +-
 drivers/net/ethernet/neterion/vxge/vxge-ethtool.c                         |    6 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c                            |    4 +-
 drivers/net/ethernet/nvidia/forcedeth.c                                   |   16 +-
 drivers/net/ethernet/nxp/lpc_eth.c                                        |    8 +-
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig                             |    2 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c                   |    4 +-
 drivers/net/ethernet/packetengines/hamachi.c                              |    6 +-
 drivers/net/ethernet/packetengines/yellowfin.c                            |    2 +-
 drivers/net/ethernet/qlogic/Kconfig                                       |   11 +
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c                      |    2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c                                     |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                               |   36 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c                       |   44 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h                       |    5 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c                     |   14 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c                           |   13 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c                       |    9 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c                            |   42 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c                            |   31 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                          |   92 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c                      |   69 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h                         |    6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c                  |  192 +++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c                      |  171 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c                         |   68 ++
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                              |    4 +-
 drivers/net/ethernet/realtek/r8169.c                                      |    2 +-
 drivers/net/ethernet/renesas/sh_eth.c                                     |   47 +-
 drivers/net/ethernet/renesas/sh_eth.h                                     |    2 -
 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c                        |    2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c                           |   50 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_reg.h                            |    1 -
 drivers/net/ethernet/sfc/efx.c                                            |    2 +-
 drivers/net/ethernet/sfc/ethtool.c                                        |   10 +-
 drivers/net/ethernet/sfc/io.h                                             |    7 +
 drivers/net/ethernet/sfc/siena_sriov.c                                    |    3 +-
 drivers/net/ethernet/sfc/tx.c                                             |   22 +-
 drivers/net/ethernet/sis/sis190.c                                         |    2 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c                                   |    2 +-
 drivers/net/ethernet/smsc/smsc911x.c                                      |    2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c                      |   10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                         |   26 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c                         |    7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c                     |   17 +-
 drivers/net/ethernet/tehuti/tehuti.c                                      |    2 +-
 drivers/net/ethernet/ti/cpmac.c                                           |   14 -
 drivers/net/ethernet/ti/cpsw-phy-sel.c                                    |   62 +-
 drivers/net/ethernet/ti/cpsw.c                                            |  114 ++-
 drivers/net/ethernet/ti/cpts.c                                            |   11 +-
 drivers/net/ethernet/ti/davinci_cpdma.c                                   |   39 +-
 drivers/net/ethernet/ti/davinci_emac.c                                    |    9 +-
 drivers/net/ethernet/ti/davinci_mdio.c                                    |   50 +-
 drivers/net/ethernet/tile/tilegx.c                                        |   13 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                              |    2 +-
 drivers/net/ethernet/via/Kconfig                                          |    2 +-
 drivers/net/ethernet/via/via-rhine.c                                      |  511 +++++++-----
 drivers/net/ethernet/xilinx/ll_temac_main.c                               |    2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c                         |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                             |    2 +-
 drivers/net/hyperv/hyperv_net.h                                           |  163 +++-
 drivers/net/hyperv/netvsc.c                                               |  529 ++++++++-----
 drivers/net/hyperv/netvsc_drv.c                                           |  129 ++-
 drivers/net/hyperv/rndis_filter.c                                         |  193 ++++-
 drivers/net/ieee802154/at86rf230.c                                        |  133 +---
 drivers/net/ieee802154/fakelb.c                                           |    6 +-
 drivers/net/ieee802154/mrf24j40.c                                         |   33 +-
 drivers/net/irda/Kconfig                                                  |    3 +-
 drivers/net/irda/via-ircc.c                                               |    7 +-
 drivers/net/irda/w83977af_ir.c                                            |   33 +-
 drivers/net/macvlan.c                                                     |  262 +++++--
 drivers/net/ntb_netdev.c                                                  |    3 +-
 drivers/net/phy/Kconfig                                                   |    6 +
 drivers/net/phy/Makefile                                                  |    1 +
 drivers/net/phy/amd-xgbe-phy.c                                            | 1357 ++++++++++++++++++++++++++++++++
 drivers/net/phy/at803x.c                                                  |   39 +-
 drivers/net/phy/fixed.c                                                   |   81 +-
 drivers/net/phy/mdio_bus.c                                                |   73 ++
 drivers/net/phy/micrel.c                                                  |  106 ++-
 drivers/net/phy/phy_device.c                                              |   50 +-
 drivers/net/phy/realtek.c                                                 |   88 +--
 drivers/net/phy/smsc.c                                                    |    3 +-
 drivers/net/phy/vitesse.c                                                 |    3 +-
 drivers/net/ppp/ppp_generic.c                                             |    4 +-
 drivers/net/ppp/pptp.c                                                    |    2 +-
 drivers/net/rionet.c                                                      |    2 +-
 drivers/net/team/team.c                                                   |    2 +-
 drivers/net/team/team_mode_loadbalance.c                                  |   12 +-
 drivers/net/tun.c                                                         |   54 +-
 drivers/net/usb/catc.c                                                    |    2 +-
 drivers/net/usb/cdc_mbim.c                                                |  129 ++-
 drivers/net/usb/cdc_ncm.c                                                 |  740 ++++++++++++-----
 drivers/net/usb/hso.c                                                     |    2 +-
 drivers/net/usb/huawei_cdc_ncm.c                                          |   13 -
 drivers/net/usb/ipheth.c                                                  |    2 +-
 drivers/net/usb/kaweth.c                                                  |    2 +-
 drivers/net/usb/pegasus.c                                                 |    2 +-
 drivers/net/usb/qmi_wwan.c                                                |    7 +-
 drivers/net/usb/r8152.c                                                   |    6 +-
 drivers/net/usb/rtl8150.c                                                 |    2 +-
 drivers/net/virtio_net.c                                                  |    9 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c                                     |   14 +-
 drivers/net/vxlan.c                                                       |  187 +++--
 drivers/net/wan/farsync.c                                                 |   31 +-
 drivers/net/wan/sdla.c                                                    |    4 -
 drivers/net/wimax/i2400m/control.c                                        |    2 +-
 drivers/net/wimax/i2400m/driver.c                                         |    7 +-
 drivers/net/wireless/at76c50x-usb.c                                       |  180 ++++-
 drivers/net/wireless/at76c50x-usb.h                                       |   26 +-
 drivers/net/wireless/ath/ar5523/ar5523.c                                  |    3 +-
 drivers/net/wireless/ath/ath10k/bmi.c                                     |   13 +-
 drivers/net/wireless/ath/ath10k/bmi.h                                     |    5 +-
 drivers/net/wireless/ath/ath10k/ce.c                                      |  383 +++++----
 drivers/net/wireless/ath/ath10k/ce.h                                      |   17 +-
 drivers/net/wireless/ath/ath10k/core.c                                    |  366 +++++----
 drivers/net/wireless/ath/ath10k/core.h                                    |   26 +-
 drivers/net/wireless/ath/ath10k/debug.c                                   |  109 ++-
 drivers/net/wireless/ath/ath10k/htc.c                                     |   18 +-
 drivers/net/wireless/ath/ath10k/htt.c                                     |   42 +-
 drivers/net/wireless/ath/ath10k/htt.h                                     |   37 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c                                  |  587 +++++++++-----
 drivers/net/wireless/ath/ath10k/htt_tx.c                                  |    8 +-
 drivers/net/wireless/ath/ath10k/hw.h                                      |    1 +
 drivers/net/wireless/ath/ath10k/mac.c                                     |  990 ++++++++++++++---------
 drivers/net/wireless/ath/ath10k/pci.c                                     |  336 +++++---
 drivers/net/wireless/ath/ath10k/pci.h                                     |    3 -
 drivers/net/wireless/ath/ath10k/txrx.c                                    |  183 -----
 drivers/net/wireless/ath/ath10k/txrx.h                                    |    1 -
 drivers/net/wireless/ath/ath10k/wmi.c                                     |   90 ++-
 drivers/net/wireless/ath/ath10k/wmi.h                                     |  104 ++-
 drivers/net/wireless/ath/ath5k/phy.c                                      |    4 +-
 drivers/net/wireless/ath/ath6kl/Kconfig                                   |   30 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                                |   16 +-
 drivers/net/wireless/ath/ath6kl/core.c                                    |    6 +-
 drivers/net/wireless/ath/ath6kl/debug.c                                   |    4 -
 drivers/net/wireless/ath/ath6kl/debug.h                                   |    2 +-
 drivers/net/wireless/ath/ath6kl/hif.c                                     |    3 -
 drivers/net/wireless/ath/ath6kl/hif.h                                     |    4 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c                                |   23 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c                                |   10 +-
 drivers/net/wireless/ath/ath6kl/init.c                                    |    1 -
 drivers/net/wireless/ath/ath6kl/main.c                                    |   10 +-
 drivers/net/wireless/ath/ath6kl/sdio.c                                    |   17 +-
 drivers/net/wireless/ath/ath6kl/target.h                                  |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c                                    |   31 +-
 drivers/net/wireless/ath/ath6kl/usb.c                                     |    2 -
 drivers/net/wireless/ath/ath6kl/wmi.c                                     |   21 +-
 drivers/net/wireless/ath/ath6kl/wmi.h                                     |    3 +-
 drivers/net/wireless/ath/ath9k/Makefile                                   |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h                      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h                      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h                      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h                          |    8 +-
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h                          |    6 +-
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h                      |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h                                    |   16 +-
 drivers/net/wireless/ath/ath9k/beacon.c                                   |    5 +-
 drivers/net/wireless/ath/ath9k/common-debug.c                             |  253 ++++++
 drivers/net/wireless/ath/ath9k/common-debug.h                             |   72 ++
 drivers/net/wireless/ath/ath9k/common.h                                   |    1 +
 drivers/net/wireless/ath/ath9k/debug.c                                    |  214 +----
 drivers/net/wireless/ath/ath9k/debug.h                                    |   44 --
 drivers/net/wireless/ath/ath9k/dfs.c                                      |    6 +-
 drivers/net/wireless/ath/ath9k/htc.h                                      |   19 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c                            |  555 +------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                             |    3 +-
 drivers/net/wireless/ath/ath9k/hw.c                                       |    3 +-
 drivers/net/wireless/ath/ath9k/init.c                                     |   40 +-
 drivers/net/wireless/ath/ath9k/mac.c                                      |   22 +
 drivers/net/wireless/ath/ath9k/mac.h                                      |    1 +
 drivers/net/wireless/ath/ath9k/main.c                                     |  163 +++-
 drivers/net/wireless/ath/ath9k/pci.c                                      |    3 +-
 drivers/net/wireless/ath/ath9k/recv.c                                     |   29 +-
 drivers/net/wireless/ath/ath9k/reg.h                                      |    3 -
 drivers/net/wireless/ath/carl9170/main.c                                  |    4 +-
 drivers/net/wireless/ath/carl9170/usb.c                                   |    8 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c                           |   45 +-
 drivers/net/wireless/ath/wcn36xx/smd.c                                    |    3 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c                               |    5 +-
 drivers/net/wireless/ath/wil6210/debugfs.c                                |    4 +-
 drivers/net/wireless/ath/wil6210/interrupt.c                              |    2 +-
 drivers/net/wireless/ath/wil6210/main.c                                   |   43 +-
 drivers/net/wireless/ath/wil6210/netdev.c                                 |   14 +
 drivers/net/wireless/ath/wil6210/pcie_bus.c                               |    4 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c                             |   26 +-
 drivers/net/wireless/ath/wil6210/txrx.c                                   |   28 +-
 drivers/net/wireless/ath/wil6210/wil6210.h                                |   11 +-
 drivers/net/wireless/ath/wil6210/wmi.c                                    |   36 +-
 drivers/net/wireless/ath/wil6210/wmi.h                                    |   50 +-
 drivers/net/wireless/b43/Kconfig                                          |   42 +-
 drivers/net/wireless/b43/b43.h                                            |    4 -
 drivers/net/wireless/b43/bus.h                                            |   10 +
 drivers/net/wireless/b43/main.c                                           |  498 ++++++------
 drivers/net/wireless/b43/phy_common.c                                     |   96 ++-
 drivers/net/wireless/b43/phy_common.h                                     |    8 +-
 drivers/net/wireless/b43/phy_g.c                                          |    6 +-
 drivers/net/wireless/b43/phy_n.c                                          |  321 ++++++--
 drivers/net/wireless/b43/phy_n.h                                          |    1 -
 drivers/net/wireless/b43/radio_2056.c                                     | 1336 +++++++++++++++++++++++++++++--
 drivers/net/wireless/b43/tables_nphy.c                                    |  150 +---
 drivers/net/wireless/b43/tables_nphy.h                                    |    3 +-
 drivers/net/wireless/b43/wa.c                                             |    2 +-
 drivers/net/wireless/b43/xmit.c                                           |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                          |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                             |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h                         |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c                      |   18 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c                       |   39 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c                        |  283 ++++---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c                        |  332 ++++++++
 drivers/net/wireless/brcm80211/brcmfmac/{nvram.h => firmware.h}           |   24 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h                      |   24 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c                        |   80 +-
 drivers/net/wireless/brcm80211/brcmfmac/nvram.c                           |   94 ---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                             |  270 ++-----
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c                     |  213 +++--
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c                     |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c                            |   13 +-
 drivers/net/wireless/brcm80211/brcmutil/d11.c                             |   93 ++-
 drivers/net/wireless/brcm80211/include/brcmu_d11.h                        |   14 +-
 drivers/net/wireless/brcm80211/include/brcmu_wifi.h                       |    1 +
 drivers/net/wireless/cw1200/sta.c                                         |    3 +-
 drivers/net/wireless/cw1200/sta.h                                         |    3 +-
 drivers/net/wireless/hostap/hostap_main.c                                 |    2 +-
 drivers/net/wireless/iwlegacy/3945.c                                      |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                                  |    2 +-
 drivers/net/wireless/iwlegacy/common.c                                    |    3 +-
 drivers/net/wireless/iwlegacy/common.h                                    |    3 +-
 drivers/net/wireless/iwlwifi/Kconfig                                      |   13 +-
 drivers/net/wireless/iwlwifi/dvm/Makefile                                 |    3 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c                                  |    1 -
 drivers/net/wireless/iwlwifi/dvm/debugfs.c                                |    7 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h                                    |    2 +
 drivers/net/wireless/iwlwifi/dvm/devices.c                                |    2 -
 drivers/net/wireless/iwlwifi/dvm/led.h                                    |   12 +
 drivers/net/wireless/iwlwifi/dvm/lib.c                                    |   19 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                               |    5 +-
 drivers/net/wireless/iwlwifi/dvm/main.c                                   |   39 +-
 drivers/net/wireless/iwlwifi/dvm/power.c                                  |    4 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c                                     |   10 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c                                     |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c                                   |   18 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c                                   |    3 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c                                    |   29 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c                                     |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                                     |   24 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c                                  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c                                   |    1 +
 drivers/net/wireless/iwlwifi/iwl-2000.c                                   |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c                                   |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c                                   |    3 +
 drivers/net/wireless/iwlwifi/iwl-7000.c                                   |   11 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c                                   |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h                                 |    4 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                                 |   12 +
 drivers/net/wireless/iwlwifi/iwl-debug.c                                  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h                                  |   41 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                                    |    5 +
 drivers/net/wireless/iwlwifi/{mvm/fw-error-dump.h => iwl-fw-error-dump.h} |   32 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h                                     |   35 +-
 drivers/net/wireless/iwlwifi/iwl-io.c                                     |   18 +
 drivers/net/wireless/iwlwifi/iwl-io.h                                     |    1 +
 drivers/net/wireless/iwlwifi/iwl-modparams.h                              |    1 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                              |   73 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                                |   25 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c                                 |    9 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h                                   |   11 +
 drivers/net/wireless/iwlwifi/iwl-trans.h                                  |   60 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile                                 |    3 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c                                   |  114 ++-
 drivers/net/wireless/iwlwifi/mvm/d3.c                                     |  129 ++-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c                            |   61 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                                |   26 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h                            |   38 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h                              |   17 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h                              |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h                            |   26 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h                             |   46 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                              |    3 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                                 |   54 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c                                     |   31 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                               |  119 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                               |  204 +++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h                                    |   60 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c                                    |  102 +--
 drivers/net/wireless/iwlwifi/mvm/ops.c                                    |   97 ++-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                               |   23 +-
 drivers/net/wireless/iwlwifi/mvm/power.c                                  |  410 +++++-----
 drivers/net/wireless/iwlwifi/mvm/quota.c                                  |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c                                     |  491 +++++++++---
 drivers/net/wireless/iwlwifi/mvm/rs.h                                     |   24 +
 drivers/net/wireless/iwlwifi/mvm/rx.c                                     |   45 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c                                   |   33 +-
 drivers/net/wireless/iwlwifi/mvm/sf.c                                     |    3 -
 drivers/net/wireless/iwlwifi/mvm/sta.c                                    |  189 +----
 drivers/net/wireless/iwlwifi/mvm/sta.h                                    |    6 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c                             |   71 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c                                     |   11 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c                                     |   13 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c                                  |   87 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c                                   |   14 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h                              |   33 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c                                    |   86 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c                                 |  137 +++-
 drivers/net/wireless/iwlwifi/pcie/tx.c                                    |  197 ++---
 drivers/net/wireless/libertas/cfg.c                                       |    7 +-
 drivers/net/wireless/libertas/defs.h                                      |    3 +-
 drivers/net/wireless/libertas/rx.c                                        |    8 +-
 drivers/net/wireless/mac80211_hwsim.c                                     |    5 +-
 drivers/net/wireless/mwifiex/11ac.c                                       |    3 +-
 drivers/net/wireless/mwifiex/11n.c                                        |   45 +-
 drivers/net/wireless/mwifiex/11n.h                                        |    3 +-
 drivers/net/wireless/mwifiex/11n_aggr.c                                   |   28 +-
 drivers/net/wireless/mwifiex/README                                       |    7 +
 drivers/net/wireless/mwifiex/cfg80211.c                                   |   19 +-
 drivers/net/wireless/mwifiex/cmdevt.c                                     |    2 -
 drivers/net/wireless/mwifiex/debugfs.c                                    |   25 +
 drivers/net/wireless/mwifiex/decl.h                                       |    8 +-
 drivers/net/wireless/mwifiex/fw.h                                         |   25 +-
 drivers/net/wireless/mwifiex/ioctl.h                                      |    2 +-
 drivers/net/wireless/mwifiex/main.c                                       |    2 -
 drivers/net/wireless/mwifiex/main.h                                       |   26 +-
 drivers/net/wireless/mwifiex/pcie.c                                       |    4 +-
 drivers/net/wireless/mwifiex/scan.c                                       |   66 +-
 drivers/net/wireless/mwifiex/sdio.c                                       |   15 +-
 drivers/net/wireless/mwifiex/sdio.h                                       |   18 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                                    |    7 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c                                |   18 +-
 drivers/net/wireless/mwifiex/sta_event.c                                  |   44 ++
 drivers/net/wireless/mwifiex/sta_rx.c                                     |   16 +-
 drivers/net/wireless/mwifiex/sta_tx.c                                     |    4 +-
 drivers/net/wireless/mwifiex/tdls.c                                       |   97 ++-
 drivers/net/wireless/mwifiex/uap_cmd.c                                    |    8 +-
 drivers/net/wireless/mwifiex/usb.c                                        |   55 +-
 drivers/net/wireless/mwifiex/util.c                                       |    6 +-
 drivers/net/wireless/mwifiex/wmm.c                                        |   22 +-
 drivers/net/wireless/mwifiex/wmm.h                                        |    5 +-
 drivers/net/wireless/orinoco/hw.c                                         |    4 +-
 drivers/net/wireless/orinoco/hw.h                                         |    4 +-
 drivers/net/wireless/orinoco/orinoco_usb.c                                |    2 +-
 drivers/net/wireless/orinoco/wext.c                                       |    4 +-
 drivers/net/wireless/p54/main.c                                           |    3 +-
 drivers/net/wireless/ray_cs.c                                             |    2 +-
 drivers/net/wireless/rndis_wlan.c                                         |    4 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                               |    1 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                                   |    4 +-
 drivers/net/wireless/rsi/rsi_common.h                                     |    2 +-
 drivers/net/wireless/rsi/rsi_mgmt.h                                       |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c                                   |   15 +-
 drivers/net/wireless/rt2x00/rt2x00.h                                      |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                                   |    3 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c                                   |    6 +
 drivers/net/wireless/rt2x00/rt61pci.c                                     |   10 +-
 drivers/net/wireless/rt2x00/rt73usb.c                                     |   10 +-
 drivers/net/wireless/rtl818x/rtl8180/Makefile                             |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c                                |   27 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c                                |   11 +-
 drivers/net/wireless/rtl818x/rtl818x.h                                    |    6 +-
 drivers/net/wireless/rtlwifi/core.c                                       |    3 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c                               |   20 -
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.h                               |    2 -
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c                               |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                               |   21 -
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h                               |    2 -
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c                               |    1 -
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c                               |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c                               |    3 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c                               |   20 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h                               |    2 -
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c                               |    1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c                   |    1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c                               |   21 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h                               |    2 -
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c                               |    1 -
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c                               |   20 -
 drivers/net/wireless/rtlwifi/rtl8723be/hw.h                               |    2 -
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c                               |    5 +-
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c                              |    1 -
 drivers/net/wireless/rtlwifi/wifi.h                                       |    6 +-
 drivers/net/wireless/ti/wl1251/acx.c                                      |    1 -
 drivers/net/wireless/ti/wl1251/cmd.c                                      |    1 -
 drivers/net/wireless/ti/wl1251/event.c                                    |    5 +-
 drivers/net/wireless/ti/wl1251/main.c                                     |   68 +-
 drivers/net/wireless/ti/wl1251/spi.c                                      |   44 +-
 drivers/net/wireless/ti/wlcore/debugfs.h                                  |    4 +-
 drivers/net/wireless/ti/wlcore/main.c                                     |    5 +-
 drivers/net/wireless/ti/wlcore/sdio.c                                     |   28 +-
 drivers/net/wireless/ti/wlcore/spi.c                                      |   69 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h                                 |    4 +-
 drivers/net/xen-netback/common.h                                          |  107 ++-
 drivers/net/xen-netback/interface.c                                       |  523 +++++++-----
 drivers/net/xen-netback/netback.c                                         |  754 +++++++++---------
 drivers/net/xen-netback/xenbus.c                                          |  182 ++++-
 drivers/net/xen-netfront.c                                                | 1123 ++++++++++++++++----------
 drivers/nfc/Kconfig                                                       |    1 +
 drivers/nfc/Makefile                                                      |    1 +
 drivers/nfc/pn544/i2c.c                                                   |  154 +++-
 drivers/nfc/port100.c                                                     |   36 +-
 drivers/nfc/st21nfca/Kconfig                                              |   23 +
 drivers/nfc/st21nfca/Makefile                                             |    8 +
 drivers/nfc/st21nfca/i2c.c                                                |  724 +++++++++++++++++
 drivers/nfc/st21nfca/st21nfca.c                                           |  698 ++++++++++++++++
 drivers/nfc/st21nfca/st21nfca.h                                           |   87 ++
 drivers/nfc/trf7970a.c                                                    |  261 ++++--
 drivers/of/of_mdio.c                                                      |  206 +++--
 drivers/ptp/ptp_clock.c                                                   |    5 +-
 drivers/s390/net/claw.c                                                   |    2 +-
 drivers/s390/net/ctcm_main.c                                              |    2 +-
 drivers/s390/net/ctcm_sysfs.c                                             |   14 +-
 drivers/s390/net/lcs.c                                                    |   15 +-
 drivers/s390/net/qeth_core.h                                              |    6 +-
 drivers/s390/net/qeth_core_main.c                                         |  100 ++-
 drivers/s390/net/qeth_core_sys.c                                          |   22 +-
 drivers/s390/net/qeth_l2_main.c                                           |   18 +-
 drivers/s390/net/qeth_l3_main.c                                           |   21 +-
 drivers/scsi/iscsi_tcp.c                                                  |    2 +-
 drivers/staging/et131x/et131x.c                                           |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c                          |    2 +-
 drivers/staging/netlogic/xlr_net.c                                        |    2 +-
 drivers/staging/octeon/ethernet.c                                         |    2 +-
 drivers/staging/rtl8821ae/core.c                                          |   14 +-
 drivers/staging/wlan-ng/cfg80211.c                                        |    4 +-
 drivers/usb/gadget/u_ether.c                                              |    4 +-
 include/linux/ath9k_platform.h                                            |    2 +
 include/linux/can/core.h                                                  |    6 +-
 include/linux/can/dev.h                                                   |    6 +-
 include/linux/can/led.h                                                   |    6 +-
 include/linux/can/platform/cc770.h                                        |    6 +-
 include/linux/can/platform/mcp251x.h                                      |    6 +-
 include/linux/can/platform/rcar_can.h                                     |   17 +
 include/linux/can/platform/sja1000.h                                      |    6 +-
 include/linux/can/platform/ti_hecc.h                                      |    6 +-
 include/linux/can/skb.h                                                   |    6 +-
 include/linux/cpumask.h                                                   |    8 +
 include/linux/crc7.h                                                      |    8 +-
 include/linux/ethtool.h                                                   |   21 +-
 include/linux/filter.h                                                    |  384 +++++++--
 include/linux/ieee80211.h                                                 |    1 +
 include/linux/if_bridge.h                                                 |   19 +
 include/linux/if_link.h                                                   |    3 +-
 include/linux/if_macvlan.h                                                |    3 +
 include/linux/if_vlan.h                                                   |    4 +-
 include/linux/isdn/capiutil.h                                             |    5 -
 include/linux/ktime.h                                                     |   24 +
 include/linux/mlx4/device.h                                               |    4 +-
 include/linux/netdev_features.h                                           |    3 +
 include/linux/netdevice.h                                                 |   99 ++-
 include/linux/netfilter/nfnetlink_acct.h                                  |    8 +-
 include/linux/netlink.h                                                   |    3 +-
 include/linux/nl802154.h                                                  |   31 +
 include/linux/of_mdio.h                                                   |   29 +-
 include/linux/phy.h                                                       |    8 +
 include/linux/phy_fixed.h                                                 |   16 +
 include/linux/platform_data/st21nfca.h                                    |   32 +
 include/linux/rfkill-gpio.h                                               |   10 -
 include/linux/skbuff.h                                                    |  151 +++-
 include/linux/spi/at86rf230.h                                             |   14 -
 include/linux/ssb/ssb.h                                                   |    1 +
 include/linux/tcp.h                                                       |   10 +-
 include/linux/udp.h                                                       |   24 +-
 include/linux/usb/cdc_ncm.h                                               |   35 +-
 include/net/6lowpan.h                                                     |    1 +
 include/net/addrconf.h                                                    |    5 -
 include/net/af_ieee802154.h                                               |   10 +-
 include/net/bluetooth/hci.h                                               |   22 +
 include/net/bluetooth/hci_core.h                                          |   24 +-
 include/net/bluetooth/mgmt.h                                              |   15 +
 include/net/bluetooth/rfcomm.h                                            |    6 +-
 include/net/cfg80211.h                                                    |  275 +++++--
 include/net/checksum.h                                                    |    2 +
 include/net/dsa.h                                                         |    5 +
 include/net/gre.h                                                         |    5 +-
 include/net/ieee802154.h                                                  |    9 +
 include/net/ieee802154_netdev.h                                           |  187 ++++-
 include/net/inet_ecn.h                                                    |    2 +-
 include/net/inet_hashtables.h                                             |    8 +-
 include/net/inet_sock.h                                                   |   10 +
 include/net/inetpeer.h                                                    |   17 +-
 include/net/ip.h                                                          |   83 +-
 include/net/ip6_checksum.h                                                |   19 +
 include/net/ip6_route.h                                                   |    2 +-
 include/net/ipv6.h                                                        |   24 +-
 include/net/mac80211.h                                                    |  155 +++-
 include/net/net_namespace.h                                               |    8 +
 include/net/netfilter/nf_nat.h                                            |    2 +
 include/net/netfilter/nf_tables.h                                         |  130 ++-
 include/net/netfilter/nft_meta.h                                          |   36 +
 include/net/netns/ipv4.h                                                  |    7 +
 include/net/netns/ipv6.h                                                  |    1 +
 include/net/nfc/digital.h                                                 |    4 +
 include/net/nfc/hci.h                                                     |    1 +
 include/net/nfc/nfc.h                                                     |    3 +
 include/net/pkt_cls.h                                                     |    2 +-
 include/net/pkt_sched.h                                                   |    2 +-
 include/net/protocol.h                                                    |    1 -
 include/net/regulatory.h                                                  |    6 +
 include/net/sch_generic.h                                                 |    2 +-
 include/net/sctp/structs.h                                                |    6 +-
 include/net/secure_seq.h                                                  |    2 -
 include/net/snmp.h                                                        |   32 +-
 include/net/sock.h                                                        |    6 +-
 include/net/tcp.h                                                         |   47 +-
 include/net/tso.h                                                         |   20 +
 include/net/udp.h                                                         |   18 +-
 include/net/vxlan.h                                                       |   14 +-
 include/net/xfrm.h                                                        |   57 +-
 include/uapi/linux/audit.h                                                |    8 +
 include/uapi/linux/can.h                                                  |    6 +-
 include/uapi/linux/can/bcm.h                                              |    6 +-
 include/uapi/linux/can/error.h                                            |    6 +-
 include/uapi/linux/can/gw.h                                               |    6 +-
 include/uapi/linux/can/netlink.h                                          |    6 +-
 include/uapi/linux/can/raw.h                                              |    6 +-
 include/uapi/linux/capability.h                                           |    7 +-
 include/uapi/linux/ethtool.h                                              |   35 +
 include/uapi/linux/filter.h                                               |    3 +-
 include/uapi/linux/if_fddi.h                                              |   90 +--
 include/uapi/linux/if_link.h                                              |   12 +-
 include/uapi/linux/if_tunnel.h                                            |    2 +-
 include/uapi/linux/l2tp.h                                                 |    2 +
 include/uapi/linux/neighbour.h                                            |    1 +
 include/uapi/linux/netfilter/nf_tables.h                                  |   37 +
 include/uapi/linux/netfilter/nfnetlink.h                                  |    2 +
 include/uapi/linux/netfilter/nfnetlink_acct.h                             |    9 +
 include/uapi/linux/nfc.h                                                  |   16 +-
 include/uapi/linux/nl80211.h                                              |   67 +-
 include/uapi/linux/openvswitch.h                                          |    4 +-
 include/uapi/linux/tipc.h                                                 |   23 +
 include/uapi/linux/tipc_config.h                                          |   10 +-
 include/uapi/linux/udp.h                                                  |    2 +
 include/xen/interface/io/netif.h                                          |   53 ++
 kernel/audit.c                                                            |   64 +-
 kernel/seccomp.c                                                          |  110 +--
 kernel/sysctl.c                                                           |    4 +-
 lib/Kconfig.debug                                                         |   13 +
 lib/Makefile                                                              |    1 +
 lib/cpumask.c                                                             |   63 ++
 lib/crc7.c                                                                |   84 +-
 lib/test_bpf.c                                                            | 1929 +++++++++++++++++++++++++++++++++++++++++++++
 net/8021q/vlan_core.c                                                     |    6 +-
 net/8021q/vlan_dev.c                                                      |   62 +-
 net/appletalk/ddp.c                                                       |    2 +-
 net/atm/svc.c                                                             |   10 +-
 net/batman-adv/debugfs.c                                                  |   13 +-
 net/batman-adv/distributed-arp-table.c                                    |    3 +-
 net/batman-adv/main.h                                                     |    2 +-
 net/batman-adv/network-coding.c                                           |    3 +-
 net/batman-adv/soft-interface.c                                           |    2 +-
 net/batman-adv/sysfs.c                                                    |   14 +-
 net/bluetooth/6lowpan.c                                                   |   65 +-
 net/bluetooth/hci_conn.c                                                  |   84 +-
 net/bluetooth/hci_core.c                                                  |   84 +-
 net/bluetooth/hci_event.c                                                 |  311 ++++++--
 net/bluetooth/hci_sock.c                                                  |   17 +-
 net/bluetooth/l2cap_core.c                                                |    6 +
 net/bluetooth/l2cap_sock.c                                                |    5 +-
 net/bluetooth/lib.c                                                       |    1 +
 net/bluetooth/mgmt.c                                                      |  278 ++++++-
 net/bluetooth/rfcomm/core.c                                               |    2 +-
 net/bluetooth/rfcomm/tty.c                                                |   20 +-
 net/bluetooth/smp.c                                                       |  160 ++--
 net/bluetooth/smp.h                                                       |   30 +-
 net/bridge/Makefile                                                       |    4 +-
 net/bridge/br.c                                                           |   98 +++
 net/bridge/br_device.c                                                    |   16 +-
 net/bridge/br_fdb.c                                                       |  134 +++-
 net/bridge/br_if.c                                                        |  126 ++-
 net/bridge/br_input.c                                                     |    8 +-
 net/bridge/br_mdb.c                                                       |    4 +-
 net/bridge/br_multicast.c                                                 |  382 ++++++---
 net/bridge/br_netfilter.c                                                 |    2 +-
 net/bridge/br_netlink.c                                                   |    3 +
 net/bridge/br_notify.c                                                    |  118 ---
 net/bridge/br_private.h                                                   |   75 +-
 net/bridge/br_sysfs_br.c                                                  |   26 +
 net/bridge/br_sysfs_if.c                                                  |   30 +-
 net/bridge/br_vlan.c                                                      |  154 +++-
 net/bridge/netfilter/Kconfig                                              |   17 +-
 net/bridge/netfilter/Makefile                                             |    1 +
 net/bridge/netfilter/nft_meta_bridge.c                                    |  139 ++++
 net/can/af_can.c                                                          |   31 +-
 net/can/af_can.h                                                          |    9 +-
 net/can/proc.c                                                            |   76 +-
 net/ceph/osd_client.c                                                     |    2 +-
 net/core/Makefile                                                         |    2 +-
 net/core/datagram.c                                                       |   14 +-
 net/core/dev.c                                                            |   98 ++-
 net/core/dev_addr_lists.c                                                 |   85 ++
 net/core/ethtool.c                                                        |  215 ++++-
 net/core/filter.c                                                         | 1292 ++++++++++++++----------------
 net/core/net_namespace.c                                                  |    2 +-
 net/core/pktgen.c                                                         |   50 +-
 net/core/ptp_classifier.c                                                 |    4 +-
 net/core/rtnetlink.c                                                      |   73 +-
 net/core/secure_seq.c                                                     |   25 -
 net/core/skbuff.c                                                         |   28 +-
 net/core/sock.c                                                           |    4 +-
 net/core/tso.c                                                            |   77 ++
 net/dccp/ipv4.c                                                           |    1 -
 net/dccp/proto.c                                                          |    9 +-
 net/dccp/sysctl.c                                                         |    3 +-
 net/dccp/timer.c                                                          |    2 +-
 net/decnet/af_decnet.c                                                    |    2 +-
 net/dns_resolver/dns_query.c                                              |    8 +-
 net/dsa/slave.c                                                           |    2 +-
 net/ieee802154/6lowpan_rtnl.c                                             |  207 ++---
 net/ieee802154/dgram.c                                                    |  104 ++-
 net/ieee802154/header_ops.c                                               |   52 +-
 net/ieee802154/ieee802154.h                                               |   19 +
 net/ieee802154/netlink.c                                                  |   20 +
 net/ieee802154/nl-mac.c                                                   |  809 +++++++++++++++++++
 net/ieee802154/nl_policy.c                                                |   16 +
 net/ieee802154/reassembly.c                                               |   48 +-
 net/ipv4/af_inet.c                                                        |  110 +--
 net/ipv4/datagram.c                                                       |   20 +-
 net/ipv4/devinet.c                                                        |    9 +-
 net/ipv4/gre_demux.c                                                      |   27 +-
 net/ipv4/gre_offload.c                                                    |   16 +-
 net/ipv4/icmp.c                                                           |   23 +-
 net/ipv4/igmp.c                                                           |   16 +-
 net/ipv4/inet_connection_sock.c                                           |   11 +-
 net/ipv4/inet_hashtables.c                                                |    6 +-
 net/ipv4/inetpeer.c                                                       |   20 +-
 net/ipv4/ip_forward.c                                                     |    2 +-
 net/ipv4/ip_gre.c                                                         |    7 +-
 net/ipv4/ip_options.c                                                     |    6 +-
 net/ipv4/ip_output.c                                                      |   22 +-
 net/ipv4/ip_tunnel.c                                                      |   25 +-
 net/ipv4/ip_tunnel_core.c                                                 |   10 +-
 net/ipv4/ip_vti.c                                                         |    8 +-
 net/ipv4/ipip.c                                                           |    5 +-
 net/ipv4/ipmr.c                                                           |    4 +-
 net/ipv4/netfilter/iptable_nat.c                                          |   14 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                                       |    2 +-
 net/ipv4/netfilter/nft_chain_nat_ipv4.c                                   |   12 +-
 net/ipv4/proc.c                                                           |   24 +-
 net/ipv4/raw.c                                                            |    2 +-
 net/ipv4/route.c                                                          |   52 +-
 net/ipv4/syncookies.c                                                     |    3 +-
 net/ipv4/sysctl_net_ipv4.c                                                |   45 +-
 net/ipv4/tcp.c                                                            |    8 +
 net/ipv4/tcp_bic.c                                                        |    5 +-
 net/ipv4/tcp_cong.c                                                       |   24 +-
 net/ipv4/tcp_cubic.c                                                      |    5 +-
 net/ipv4/tcp_fastopen.c                                                   |  219 +++++-
 net/ipv4/tcp_highspeed.c                                                  |    4 +-
 net/ipv4/tcp_htcp.c                                                       |    4 +-
 net/ipv4/tcp_hybla.c                                                      |    7 +-
 net/ipv4/tcp_illinois.c                                                   |    5 +-
 net/ipv4/tcp_input.c                                                      |   36 +-
 net/ipv4/tcp_ipv4.c                                                       |  303 +------
 net/ipv4/tcp_lp.c                                                         |    5 +-
 net/ipv4/tcp_metrics.c                                                    |    5 +-
 net/ipv4/tcp_minisocks.c                                                  |   31 +
 net/ipv4/tcp_offload.c                                                    |    9 +-
 net/ipv4/tcp_output.c                                                     |  126 +--
 net/ipv4/tcp_scalable.c                                                   |    5 +-
 net/ipv4/tcp_vegas.c                                                      |    7 +-
 net/ipv4/tcp_veno.c                                                       |    9 +-
 net/ipv4/tcp_yeah.c                                                       |    5 +-
 net/ipv4/udp.c                                                            |  135 ++--
 net/ipv4/udp_offload.c                                                    |    8 +-
 net/ipv4/udplite.c                                                        |    1 -
 net/ipv4/xfrm4_mode_tunnel.c                                              |    2 +-
 net/ipv4/xfrm4_output.c                                                   |    2 +-
 net/ipv6/addrconf.c                                                       |   49 +-
 net/ipv6/addrconf_core.c                                                  |    2 +-
 net/ipv6/af_inet6.c                                                       |   45 +-
 net/ipv6/icmp.c                                                           |   41 +-
 net/ipv6/inet6_connection_sock.c                                          |    2 +-
 net/ipv6/ip6_checksum.c                                                   |   63 +-
 net/ipv6/ip6_fib.c                                                        |   12 +-
 net/ipv6/ip6_flowlabel.c                                                  |    1 -
 net/ipv6/ip6_gre.c                                                        |   64 +-
 net/ipv6/ip6_offload.c                                                    |    2 +
 net/ipv6/ip6_output.c                                                     |   24 +-
 net/ipv6/ip6_tunnel.c                                                     |    1 +
 net/ipv6/ip6_vti.c                                                        |    3 -
 net/ipv6/netfilter/ip6table_nat.c                                         |   14 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c                                   |    2 +-
 net/ipv6/netfilter/nft_chain_nat_ipv6.c                                   |   12 +-
 net/ipv6/output_core.c                                                    |   27 +-
 net/ipv6/ping.c                                                           |    8 +-
 net/ipv6/proc.c                                                           |   14 +-
 net/ipv6/raw.c                                                            |   11 +-
 net/ipv6/route.c                                                          |    4 +-
 net/ipv6/sit.c                                                            |    5 +-
 net/ipv6/syncookies.c                                                     |    4 +-
 net/ipv6/sysctl_net_ipv6.c                                                |    7 +
 net/ipv6/tcp_ipv6.c                                                       |   86 +-
 net/ipv6/udp.c                                                            |   66 +-
 net/ipv6/udp_offload.c                                                    |    5 +-
 net/ipv6/udplite.c                                                        |    1 -
 net/ipv6/xfrm6_output.c                                                   |    6 +-
 net/ipx/af_ipx.c                                                          |    2 +-
 net/ipx/ipx_route.c                                                       |    3 +-
 net/iucv/af_iucv.c                                                        |   32 +-
 net/key/af_key.c                                                          |   34 +-
 net/l2tp/l2tp_core.c                                                      |  118 +--
 net/l2tp/l2tp_core.h                                                      |    4 +-
 net/l2tp/l2tp_ip.c                                                        |    1 -
 net/l2tp/l2tp_ip6.c                                                       |   11 +-
 net/l2tp/l2tp_netlink.c                                                   |   10 +-
 net/mac80211/Makefile                                                     |    3 +-
 net/mac80211/aes_ccm.c                                                    |   37 +-
 net/mac80211/cfg.c                                                        |  591 +++++---------
 net/mac80211/chan.c                                                       |  614 ++++++++++++---
 net/mac80211/debugfs.c                                                    |    2 +-
 net/mac80211/debugfs.h                                                    |    2 +
 net/mac80211/debugfs_netdev.c                                             |    6 +-
 net/mac80211/debugfs_netdev.h                                             |    2 +
 net/mac80211/driver-ops.h                                                 |  178 ++++-
 net/mac80211/ht.c                                                         |   22 +-
 net/mac80211/ibss.c                                                       |   78 +-
 net/mac80211/ieee80211_i.h                                                |   50 +-
 net/mac80211/iface.c                                                      |   46 +-
 net/mac80211/key.c                                                        |    7 +-
 net/mac80211/main.c                                                       |   10 +-
 net/mac80211/mesh.c                                                       |   38 +-
 net/mac80211/mesh_hwmp.c                                                  |    5 +-
 net/mac80211/mesh_pathtbl.c                                               |    6 +-
 net/mac80211/mesh_sync.c                                                  |    2 +-
 net/mac80211/michael.h                                                    |    1 +
 net/mac80211/mlme.c                                                       |   50 +-
 net/mac80211/rc80211_minstrel.c                                           |   12 +
 net/mac80211/rc80211_minstrel_ht.c                                        |   22 +-
 net/mac80211/rx.c                                                         |   19 +-
 net/mac80211/scan.c                                                       |   25 +-
 net/mac80211/sta_info.c                                                   |    4 +-
 net/mac80211/status.c                                                     |   25 +-
 net/mac80211/tdls.c                                                       |  325 ++++++++
 net/mac80211/trace.h                                                      |  117 +++
 net/mac80211/tx.c                                                         |  189 +++--
 net/mac80211/util.c                                                       |  191 ++++-
 net/mac80211/wpa.c                                                        |    5 +-
 net/mac802154/Kconfig                                                     |    4 +
 net/mac802154/Makefile                                                    |    3 +-
 net/mac802154/llsec.c                                                     | 1070 +++++++++++++++++++++++++
 net/mac802154/llsec.h                                                     |  108 +++
 net/mac802154/mac802154.h                                                 |   44 ++
 net/mac802154/mac_cmd.c                                                   |   42 +-
 net/mac802154/mib.c                                                       |  187 +++++
 net/mac802154/monitor.c                                                   |    3 +-
 net/mac802154/rx.c                                                        |   13 +-
 net/mac802154/wpan.c                                                      |  176 +++--
 net/mpls/mpls_gso.c                                                       |    1 +
 net/netfilter/ipset/ip_set_core.c                                         |    5 +-
 net/netfilter/ipvs/ip_vs_core.c                                           |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                                           |   22 +-
 net/netfilter/nf_nat_core.c                                               |   24 +-
 net/netfilter/nf_tables_api.c                                             | 1287 +++++++++++++++++++++---------
 net/netfilter/nfnetlink.c                                                 |   10 +-
 net/netfilter/nfnetlink_acct.c                                            |   86 +-
 net/netfilter/nft_ct.c                                                    |   96 ++-
 net/netfilter/nft_hash.c                                                  |   59 +-
 net/netfilter/nft_lookup.c                                                |   10 +-
 net/netfilter/nft_meta.c                                                  |  103 ++-
 net/netfilter/nft_rbtree.c                                                |   43 +-
 net/netfilter/xt_bpf.c                                                    |    5 +-
 net/netfilter/xt_nfacct.c                                                 |    5 +-
 net/netfilter/xt_recent.c                                                 |    5 +-
 net/netlink/af_netlink.c                                                  |   70 +-
 net/netlink/af_netlink.h                                                  |    6 +-
 net/netlink/genetlink.c                                                   |    6 +-
 net/nfc/digital.h                                                         |    1 +
 net/nfc/digital_core.c                                                    |   26 +-
 net/nfc/digital_dep.c                                                     |    5 +-
 net/nfc/digital_technology.c                                              |  230 +++++-
 net/nfc/hci/command.c                                                     |    6 +-
 net/nfc/hci/core.c                                                        |   47 +-
 net/nfc/llcp_commands.c                                                   |    2 +-
 net/nfc/llcp_core.c                                                       |   13 +-
 net/nfc/nci/core.c                                                        |    9 +
 net/nfc/nci/ntf.c                                                         |    7 +-
 net/nfc/nfc.h                                                             |    6 +
 net/nfc/rawsock.c                                                         |   94 ++-
 net/openvswitch/actions.c                                                 |    4 +-
 net/openvswitch/datapath.c                                                |  778 ++++++++++--------
 net/openvswitch/datapath.h                                                |    8 +-
 net/openvswitch/flow.c                                                    |  188 +++--
 net/openvswitch/flow.h                                                    |   53 +-
 net/openvswitch/flow_netlink.c                                            |  186 ++---
 net/openvswitch/flow_netlink.h                                            |    1 -
 net/openvswitch/flow_table.c                                              |  121 +--
 net/openvswitch/flow_table.h                                              |    4 +-
 net/openvswitch/vport-gre.c                                               |    4 +-
 net/openvswitch/vport-internal_dev.c                                      |    2 +-
 net/openvswitch/vport-vxlan.c                                             |    7 +-
 net/openvswitch/vport.h                                                   |    6 +-
 net/rds/ib_send.c                                                         |    4 +-
 net/rds/iw_send.c                                                         |    4 +-
 net/rds/iw_sysctl.c                                                       |    3 +-
 net/rds/rdma_transport.c                                                  |    2 +-
 net/rds/sysctl.c                                                          |    3 +-
 net/rds/tcp_listen.c                                                      |    2 +-
 net/rfkill/rfkill-gpio.c                                                  |   59 +-
 net/sched/cls_api.c                                                       |   26 +-
 net/sched/cls_basic.c                                                     |   10 +-
 net/sched/cls_bpf.c                                                       |   14 +-
 net/sched/cls_cgroup.c                                                    |    4 +-
 net/sched/cls_flow.c                                                      |    4 +-
 net/sched/cls_fw.c                                                        |   10 +-
 net/sched/cls_route.c                                                     |   11 +-
 net/sched/cls_rsvp.h                                                      |    4 +-
 net/sched/cls_tcindex.c                                                   |    8 +-
 net/sched/cls_u32.c                                                       |   10 +-
 net/sched/sch_api.c                                                       |   10 +-
 net/sched/sch_choke.c                                                     |    7 +-
 net/sched/sch_drr.c                                                       |    4 +-
 net/sched/sch_fq.c                                                        |    5 +-
 net/sched/sch_fq_codel.c                                                  |    7 +-
 net/sched/sch_hhf.c                                                       |    9 +-
 net/sched/sch_netem.c                                                     |    7 +-
 net/sched/sch_sfq.c                                                       |    7 +-
 net/sctp/associola.c                                                      |  170 ++--
 net/sctp/endpointola.c                                                    |    2 +-
 net/sctp/ipv6.c                                                           |    4 +-
 net/sctp/output.c                                                         |    2 +-
 net/sctp/proc.c                                                           |    2 +-
 net/sctp/protocol.c                                                       |   11 +-
 net/sctp/sm_make_chunk.c                                                  |    2 +-
 net/sctp/socket.c                                                         |   13 +-
 net/sctp/sysctl.c                                                         |   21 +-
 net/sctp/transport.c                                                      |    2 +-
 net/sctp/ulpqueue.c                                                       |    4 +
 net/sunrpc/socklib.c                                                      |    3 +-
 net/sunrpc/xprtsock.c                                                     |    3 -
 net/tipc/Makefile                                                         |    2 +-
 net/tipc/bcast.c                                                          |  194 +++--
 net/tipc/bcast.h                                                          |    9 +-
 net/tipc/bearer.c                                                         |  153 ++--
 net/tipc/bearer.h                                                         |   47 +-
 net/tipc/config.c                                                         |   12 +-
 net/tipc/core.c                                                           |   14 +-
 net/tipc/core.h                                                           |   10 +-
 net/tipc/discover.c                                                       |  281 ++++---
 net/tipc/discover.h                                                       |    1 +
 net/tipc/eth_media.c                                                      |   51 +-
 net/tipc/handler.c                                                        |  134 ----
 net/tipc/ib_media.c                                                       |   34 +-
 net/tipc/link.c                                                           |  216 ++---
 net/tipc/link.h                                                           |   21 +-
 net/tipc/msg.c                                                            |   55 +-
 net/tipc/msg.h                                                            |    5 +-
 net/tipc/name_distr.c                                                     |   78 +-
 net/tipc/name_distr.h                                                     |   35 +-
 net/tipc/name_table.c                                                     |   14 +-
 net/tipc/net.c                                                            |   71 +-
 net/tipc/net.h                                                            |    4 +-
 net/tipc/node.c                                                           |  110 ++-
 net/tipc/node.h                                                           |   88 ++-
 net/tipc/node_subscr.c                                                    |    9 +-
 net/tipc/node_subscr.h                                                    |    2 +-
 net/tipc/port.c                                                           |   39 +-
 net/tipc/port.h                                                           |   10 +-
 net/tipc/socket.c                                                         |  121 ++-
 net/tipc/socket.h                                                         |    4 +-
 net/unix/af_unix.c                                                        |    8 +-
 net/wireless/Kconfig                                                      |   37 +
 net/wireless/ap.c                                                         |    4 +-
 net/wireless/chan.c                                                       |  175 ++++-
 net/wireless/core.c                                                       |  147 +++-
 net/wireless/core.h                                                       |   53 +-
 net/wireless/ethtool.c                                                    |   10 +-
 net/wireless/genregdb.awk                                                 |   14 +-
 net/wireless/ibss.c                                                       |   43 +-
 net/wireless/mesh.c                                                       |   32 +-
 net/wireless/mlme.c                                                       |   38 +-
 net/wireless/nl80211.c                                                    |  654 ++++++++-------
 net/wireless/nl80211.h                                                    |    3 +-
 net/wireless/rdev-ops.h                                                   |   15 +-
 net/wireless/reg.c                                                        |  156 +++-
 net/wireless/reg.h                                                        |   18 +
 net/wireless/scan.c                                                       |  162 ++--
 net/wireless/sme.c                                                        |   48 +-
 net/wireless/trace.h                                                      |   66 +-
 net/wireless/util.c                                                       |  209 +++--
 net/wireless/wext-compat.c                                                |   40 +-
 net/wireless/wext-compat.h                                                |    2 +-
 net/wireless/wext-sme.c                                                   |   12 +-
 net/xfrm/xfrm_output.c                                                    |    5 +-
 net/xfrm/xfrm_policy.c                                                    |   56 +-
 net/xfrm/xfrm_proc.c                                                      |    3 +-
 net/xfrm/xfrm_state.c                                                     |   37 +-
 net/xfrm/xfrm_user.c                                                      |   89 +--
 security/selinux/include/classmap.h                                       |    2 +-
 tools/net/bpf_exp.l                                                       |    1 +
 tools/net/bpf_exp.y                                                       |   11 +-
 tools/net/bpf_jit_disasm.c                                                |   20 +-
 tools/testing/selftests/net/Makefile                                      |    8 +-
 1263 files changed, 61461 insertions(+), 22887 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-cdc_ncm
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-queues
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-statistics
 create mode 100644 Documentation/devicetree/bindings/net/amd-xgbe-phy.txt
 create mode 100644 Documentation/devicetree/bindings/net/amd-xgbe.txt
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-systemport.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/fixed-link.txt
 create mode 100644 Documentation/devicetree/bindings/net/hisilicon-hix5hd2-gmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/ieee802154/at86rf230.txt
 delete mode 100644 Documentation/devicetree/bindings/net/micrel-ksz9021.txt
 create mode 100644 Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st21nfca.txt
 create mode 100644 Documentation/devicetree/bindings/net/via-rhine.txt
 create mode 100644 Documentation/networking/cdc_mbim.txt
 create mode 100644 drivers/net/can/rcar_can.c
 create mode 100644 drivers/net/can/spi/Kconfig
 create mode 100644 drivers/net/can/spi/Makefile
 rename drivers/net/can/{ => spi}/mcp251x.c (96%)
 create mode 100644 drivers/net/can/usb/gs_usb.c
 create mode 100644 drivers/net/can/xilinx_can.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/Makefile
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-common.h
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-desc.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-dev.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-drv.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-main.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe.h
 create mode 100644 drivers/net/ethernet/broadcom/bcmsysport.c
 create mode 100644 drivers/net/ethernet/broadcom/bcmsysport.h
 create mode 100644 drivers/net/ethernet/hisilicon/Kconfig
 create mode 100644 drivers/net/ethernet/hisilicon/Makefile
 create mode 100644 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
 create mode 100644 drivers/net/phy/amd-xgbe-phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-debug.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-debug.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/firmware.c
 rename drivers/net/wireless/brcm80211/brcmfmac/{nvram.h => firmware.h} (52%)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/nvram.c
 rename drivers/net/wireless/iwlwifi/{mvm/fw-error-dump.h => iwl-fw-error-dump.h} (82%)
 create mode 100644 drivers/nfc/st21nfca/Kconfig
 create mode 100644 drivers/nfc/st21nfca/Makefile
 create mode 100644 drivers/nfc/st21nfca/i2c.c
 create mode 100644 drivers/nfc/st21nfca/st21nfca.c
 create mode 100644 drivers/nfc/st21nfca/st21nfca.h
 create mode 100644 include/linux/can/platform/rcar_can.h
 create mode 100644 include/linux/platform_data/st21nfca.h
 create mode 100644 include/net/netfilter/nft_meta.h
 create mode 100644 include/net/tso.h
 create mode 100644 lib/test_bpf.c
 delete mode 100644 net/bridge/br_notify.c
 create mode 100644 net/bridge/netfilter/nft_meta_bridge.c
 create mode 100644 net/core/tso.c
 create mode 100644 net/mac80211/tdls.c
 create mode 100644 net/mac802154/llsec.c
 create mode 100644 net/mac802154/llsec.h
 delete mode 100644 net/tipc/handler.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
