Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaAYJe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 04:34:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43292 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaAYJd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 04:33:59 -0500
Date: Sat, 25 Jan 2014 01:33:54 -0800 (PST)
Message-Id: <20140125.013354.194644529119874096.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0P9Zbg1002153


Two files have conflicts when I did a test merge of this stuff into
your tree.  These are almost entirely simple overlapping changes.

The one that needs special attention is in
include/linux/mlx4/device.h, two MLX4_DEV_CAP_FLAG2_* capability flags
are being added with the same value ("1LL << 9"), change the second
one of them to be ("1LL << 10") and add the necessary trailing comma
at the end of the previous line.

1) BPF debugger and asm tool by Daniel Borkmann.

2) Speed up create/bind in AF_PACKET, also from Daniel Borkmann.

3) Correct reciprocal_divide and update users, from Hannes Frederic
   Sowa and Daniel Borkmann.

4) Currently we only have a "set" operation for the hw timestamp
   socket ioctl, add a "get" operation to match.  From Ben Hutchings.

5) Add better trace events for debugging driver datapath problems,
   also from Ben Hutchings.

6) Implement auto corking in TCP, from Eric Dumazet.  Basically, if we
   have a small send and a previous packet is already in the qdisc or
   device queue, defer until TX completion or we get more data.

7) Allow userspace to manage ipv6 temporary addresses, from Jiri Pirko.

8) Add a qdisc bypass option for AF_PACKET sockets, from Daniel Borkmann.

9) Share IP header compression code between Bluetooth and IEEE802154
   layers, from Jukka Rissanen.

10) Fix ipv6 router reachability probing, from Jiri Benc.

11) Allow packets to be captured on macvtap devices, from Vlad
    Yasevich.

12) Support tunneling in GRO layer, from Jerry Chu.

13) Allow bonding to be configured fully using netlink, from Scott
    Feldman.

14) Allow AF_PACKET users to obtain the VLAN TPID, just like they
    can already get the TCI.  From Atzm Watanabe.

15) New "Heavy Hitter" qdisc, from Terry Lam.

16) Significantly improve the IPSEC support in pktgen, from Fan Du.

17) Allow ipv4 tunnels to cache routes, just like sockets.  From Tom
    Herbert.

18) Add Proportional Integral Enhanced packet scheduler, from Vijay
    Subramanian.

19) Allow openvswitch to mmap'd netlink, from Thomas Graf.

20) Key TCP metrics blobs also by source address, not just destination
    address.  From Christoph Paasch.

21) Support 10G in generic phylib.  From Andy Fleming.

22) Try to short-circuit GRO flow compares using device provided RX hash,
    if provided.  From Tom Herbert.

The wireless and netfilter folks have been busy little bees too.

Please pull, thanks a lot.

The following changes since commit 7d0d46da750a252371cb747b48ddda27d1047881:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-01-17 22:19:28 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to 8b662fe70c68282f78482dc272df0c4f355e49f5:

  net/cxgb4: Fix referencing freed adapter (2014-01-24 16:00:37 -0800)

----------------------------------------------------------------
Aaron Sierra (1):
      igb: Support ports mapped in 64-bit PCI space

Alan Cox (1):
      i40e: Fix off by one in i40e_dbg_command_write

Alex Gal (1):
      wl12xx: fix tx power setting

Alexander Aring (9):
      6lowpan: fix/move/cleanup debug functions
      6lowpan: introduce lowpan_push_hc_data function
      6lowpan: udp use lowpan_push_hc_data function
      6lowpan: fix udp compress ordering
      6lowpan: fix udp byte ordering
      6lowpan: add udp warning for elided checksum
      6lowpan: udp use lowpan_fetch_skb function
      6lowpan: udp use subtraction on both conditions
      6lowpan: cleanup udp compress function

Alexander Bondar (7):
      iwlwifi: mvm: Add debugfs entry to generate NMI to NIC
      iwlwifi: mvm: Add uAPSD misbehaving AP notification handling
      iwlwifi: mvm: Change power management dependency on multi MAC
      iwlwifi: mvm: Disable power save for monitor interface
      iwlwifi: mvm: Enable power save on a single P2P client interface
      iwlwifi: mvm: add per-vif power debugfs hooks
      iwlwifi: mvm: Add and examine TLV flag for P2P client uAPSD support

Alexander Duyck (2):
      ixgbe: Force QDE via PFQDE for VFs during reset
      ixgbe: Clear head write-back registers on VF reset

Alexander Shiyan (2):
      can: mcp251x: Convert to devm-* API
      can: mcp251x: Add device tree support

Alexey Khoroshilov (2):
      libertas sdio: claim device before calling sdio_disable_func()
      NFC: port100: Fix device leak

Amitkumar Karwar (13):
      mwifiex: improvements in mwifiex_ret_tx_power_cfg()
      mwifiex: declare snap_type as __be16 variable
      mwifiex: remove rfc1042_eth_hdr variable
      mwifiex: fix an issue with Appletalk devices
      mwifiex: remove redundant goto exit_remove statement
      NFC: NCI: Cancel cmd_timer in nci_close_device()
      NFC: NCI: Don't reverse local general bytes
      NFC: NCI: Add setup handler
      NFC: NCI: Add set_config API
      NFC: nfcmrvl: Initial commit for Marvell NFC driver
      NFC: nfcmrvl: Add setup handler
      NFC: nfcmrvl: Fix possible memory leak issue
      mwifiex: add missing endian conversion for fw_tsf

Andre Guedes (5):
      Bluetooth: Check address in mgmt_disconnect_failed()
      Bluetooth: Add an extra check in mgmt_device_disconnected()
      Bluetooth: Remove link type check in hci_disconn_complete_evt()
      Bluetooth: Remove unneeded check in hci_disconn_complete_evt()
      Bluetooth: Refactor hci_disconn_complete_evt

Andreas Fenkart (1):
      mwifiex: fix wakeup on magic packet

Andrei Otcheretianski (1):
      cfg80211: aggregate mgmt_tx parameters into a struct

Andrew Rybchenko (3):
      sfc: Change efx_nic_type::rx_push_indir_table to push hash key as well
      sfc: remove unused 'refcnt' from efx_rx_page_state
      sfc: remove unused 'enum efx_rx_alloc_method'

Andy Fleming (5):
      phylib: Add Clause 45 read/write functions
      phylib: introduce PHY_INTERFACE_MODE_XGMII for 10G PHY
      phylib: Add generic 10G driver
      phylib: Support attaching to generic 10g driver
      phylib: Add of_phy_attach

Andy Zhou (1):
      openvswitch: Change ovs_flow_tbl_lookup_xx() APIs

Anjali Singhai Jain (27):
      i40e: sync header files with hardware
      i40e: refactor reset code
      i40e: Enable all PCTYPEs except FCOE for RSS.
      i40e: add num_VFs message
      i40e: Add a new variable to track number of pf instances
      i40e: Tell the stack about our actual number of queues
      i40e: reinit flow for the main VSI
      i40e: function to reconfigure RSS queues and rebuild
      i40e: Add basic support for get/set channels for RSS
      i40e: rtnl_lock in reset path fixes
      i40e: Fix wrong mask bits being used in misc interrupt
      i40e: Suppress HMC error to Interrupt message level
      i40e: Dump the whole NVM, not half
      i40e: Change the ethtool NVM read method to use AQ
      i40e: Remove unnecessary prototypes
      i40e: remove un-necessary io-write
      i40e: Record dma buffer info for dummy packets
      i40e: Admin queue shutdown fixes
      i40e: check asq alive before notify
      i40e: Do not allow AQ calls from ndo-ops
      i40e: Expose AQ debugfs hooks
      i40e: Re-enable interrupt on ICR0
      i40e: Cleanup reconfig rss path
      i40e: Update the Current NVM version Low value
      i40e: Setting queue count to 1 using ethtool is valid
      i40e: do not bail when disabling if Tx queue disable fails
      i40e: refactor flow director

Anjali Singhai jain (2):
      i40e: register file updates
      i40e: firmware version fields offsets update

Antonio Quartulli (16):
      batman-adv: properly rename define in distributed arp table header file
      batman-adv: don't switch byte order too often if not needed
      batman-adv: remove FSF address from GPL disclaimer
      batman-adv: deselect current GW on client mode switch off
      batman-adv: rename gw_deselect() to gw_reselect()
      batman-adv: remove parenthesis from return statements
      batman-adv: send every DHCP packet as bat-unicast
      batman-adv: add isolation_mark sysfs attribute
      batman-adv: mark a local client as isolated when needed
      batman-adv: print the new BATADV_TT_CLIENT_ISOLA flag
      batman-adv: extend the ap_isolation mechanism
      batman-adv: create helper function to get AP isolation status
      batman-adv: set the isolation mark in the skb if needed
      batman-adv: remove returns at the end of void functions
      batman-adv: add missing sysfs attributes to README
      batman-adv: drop dependency against CRC16

Arend van Spriel (51):
      brcmfmac: add separate function for passing bus tx overhead
      brcmfmac: replace dongle command list with .preinit() callback
      brcmfmac: start netif queues only when setup is completed successful
      brcmfmac: reduce logging noise accessing SDIO SleepCSR register
      brcmsmac: select CONFIG_BCMA when possible
      brcmfmac: support hardware extension header in trace_brcmf_sdpcm_hdr()
      brcmfmac: determine sd host controller related variable earlier
      brcmfmac: fix driver build issue when CONFIG_BRCMDBG is not set
      brcmfmac: determine alignment values during probe
      brcmfmac: use platform specific alignment in SDIO
      brcmfmac: remove redundant ioctl handlers
      brcmfmac: provide firmware version in ethtool driver info
      brcmfmac: remove unnecessary EXPORT_SYMBOL() usage
      brcmfmac: move firmware related structures to fwil_types.h
      brcmfmac: move firmware command code definitions
      brcmfmac: remove some unused definitions
      brcmfmac: move firmware event related defines to fweh.h
      brcmfmac: expose chip information through debugfs
      brcmfmac: add missing curly braces in brcmf_fws_txstatus_suppressed()
      brcmfmac: combine bcmsdh source files into one
      brcmfmac: remove unnecessary function prototypes
      brcmfmac: remove unused struct brcmf_sdio_dev::func_cis_ptr attribute
      brcmfmac: use sdio functions to enable/disable F2
      brcmfmac: remove brcmf_sdio_regrw_helper() from header file
      brcmfmac: remove regs parameter from sdio probe functions
      brcmfmac: get rid of some void pointer parameters
      brcmfmac: remove brcmf_sdio_wdtimer_enable() function
      brcmfmac: use consistent function names in bcmsdh.c
      brcmfmac: reduce function parameters in sdio send/receive calls
      brcmfmac: use consistent function names in dhd_sdio.c
      brcmfmac: remove brcmf_sdio_disconnect() function
      brcmfmac: clarify struct brcmf_sdio_dev::func[0] reference
      brcmfmac: rework SDIO register access functions
      brcmfmac: cleanup helper functions in sdio remove path
      brcmfmac: cleanup helper functions in sdio probe path
      brcmfmac: correct reporting HT40 support in wiphy htcap
      brcmfmac: add sdio drive strength programming for bcm4334 chipset
      brcmfmac: correct detection of save&restore device capability
      brcmfmac: enable watchdog when bus initialization is complete
      brcmfmac: only disable clock when brcmf_sdio_bus_init() fails
      brcmfmac: inform cfg80211 when changing the CONNECTED state
      brcmfmac: move wiphy_unregister() call to brcmf_cfg80211_detach()
      brcmfmac: call brcmf_cfg80211_detach() after removal of interfaces
      brcmfmac: use custom destructor callback for all netdevice interfaces
      mmc: add SDIO identifiers for Broadcom WLAN devices
      brcmfmac: add support for bcm43362 device
      brcmfmac: rework firmware download code
      brcmfmac: restructure brcmf_sdio_chip_recognition()
      brcmfmac: rename chip and core related structures
      brcmfmac: initialize escan function pointer during scheduled scan
      brcmfmac: handle SDIO card removal

Ariel Elior (1):
      bnx2x: Fix VF flr flow

Arik Nemtsov (8):
      nl80211: better document NL80211_CMD_TDLS_MGMT
      iwlwifi: trans: divide stop_hw into stop_device/op_mode_leave
      iwlwifi: trans: use a unified transport status
      iwlwifi: trans: prevent tx and cmds during FW error
      iwlwifi: trans: prevent reprobe on repeated FW errors before restart
      iwlwifi: trans: clear FW_ERROR status in common code
      iwlwifi: trans: turn set_pmi into an optional callback
      iwlwifi: mvm: squash a spurious warning on chnctx change

Arman Uguray (1):
      NFC: pn544: Refactor hw_config values

Arnaud Ebalard (2):
      net: mvneta: mvneta_tx_done_gbe() cleanups
      net: mvneta: make mvneta_txq_done() return void

Arturo Borrero Gonzalez (1):
      netfilter: nf_tables: nft_meta module get/set ops

Aruna-Hewapathirane (1):
      net: replace macros net_random and net_srandom with direct calls to prandom

Atzm Watanabe (4):
      packet: make aligned size of struct tpacket{2,3}_hdr clear
      packet: fill the gap of TPACKET_ALIGNMENT with zeros
      packet: deliver VLAN TPID to userspace
      packet: doc: add documentation for VLAN TPID delivery

Avinash Patil (2):
      ieee80211: add definition for TDLS wide band extended capability
      ieee80211: add definition for SMS4 key len

Avri Altman (2):
      mac80211: update ht flag if bss configuration changed
      iwlwifi: mvm: fix ht protection flags

Barak Bercovitz (1):
      cfg80211: stop sched scan only when needed

Barry Song (1):
      dm9000: fix a lot of checkpatch issues

Bartosz Markowski (4):
      ath10k: expand the wmi mgmt queue limit to 128
      ath10k: split the if_limits and if_comb
      ath10k: introduce NO_P2P fw feature flag
      ath10k: track number of existing peers

Ben Greear (3):
      ath10k: Initialize list-head on vif creation.
      ath10k: Fix un-initialized debug objects.
      ath10k: add logging to better determine some VIF/STA creation failures

Ben Hutchings (49):
      net_tstamp: Improve kernel-doc for struct hwtstamp_config
      net/compat: Fix minor information leak in siocdevprivate_ioctl()
      net/compat: Merge multiple implementations of ifreq::ifr_data conversion
      net_tstamp: Add SIOCGHWTSTAMP ioctl to match SIOCSHWTSTAMP
      sfc: Implement the SIOCGHWTSTAMP ioctl
      bfin_mac: Implement the SIOCGHWTSTAMP ioctl
      tg3: Implement the SIOCGHWTSTAMP ioctl
      fec: Implement the SIOCGHWTSTAMP ioctl
      gianfar: Implement the SIOCGHWTSTAMP ioctl
      e1000e: Implement the SIOCGHWTSTAMP ioctl
      mlx4_en: Implement the SIOCGHWTSTAMP ioctl
      vxge: Implement the SIOCGHWTSTAMP ioctl
      ti_cpsw: Implement the SIOCGHWTSTAMP ioctl
      tile_net: Implement the SIOCGHWTSTAMP ioctl
      ixp4xx_eth: Implement the SIOCGHWTSTAMP ioctl
      net_tstamp,doc: Add test program for SIOC{G,S}HWTSTAMP
      Merge branch 'sfc-3.13' into master
      sfc: Update MCDI protocol definitions
      sfc: Tighten the check for RX merged completion events
      sfc: Add new sensor names
      sfc: Map MCDI error MC_CMD_ERR_ENOTSUP to Linux EOPNOTSUPP
      sfc: Fold efx_flush_all() into efx_stop_port() and update comments
      sfc: Expose NVRAM_PARTITION_TYPE_LICENSE on EF10
      sfc: Return EBUSY for filter insertion on EF10, matching Falcon/Siena
      sfc: Split PTP multicast filter insertion/removal out of efx_ptp_{start,stop}()
      sfc: Remove dependency of PTP on having a dedicated channel
      sfc: Store flags from MC_CMD_DRV_ATTACH for later use
      sfc: Do not use MAC address as clock name
      sfc: Initialise efx_ptp_data::phc_clock_info from a static template
      sfc: Remove kernel-doc for efx_ptp_data fields not present in this version
      sfc: Copy RX prefix into skb head area in efx_rx_mk_skb()
      sfc: Store VPD serial number at probe time
      sfc: Associate primary and secondary functions of controller
      sfc: Enable PTP clock and timestamping for all functions on EF10
      sfc: Don't clear timestamps in efx_ptp_rx()
      sfc: Remove unnecessary condition for processing the TX timestamp queue
      sfc: Add more information to many warnings using WARN() and netdev_WARN()
      sfc: Change priority and flags for automatic MAC filters
      sfc: Don't refer to 'stack' in filter implementation
      sfc: Allow filter removal only with exactly matching priority
      sfc: Implement efx_nic_type::filter_clear_rx operation for EF10
      sfc: Add PTP counters to ethtool stats
      sfc: Fix RX drop filters for EF10
      tile_net: Always enable PTP clock support on TILE-Gx
      net: Fix indentation in dev_hard_start_xmit()
      net: Add net_dev_start_xmit trace event, exposing more skb fields
      net: Add trace events for all receive entry points, exposing more skb fields
      sfc: Fix transposed ptp_{under, over}size_sync_windows statistics
      sfc: Use the correct maximum TX DMA ring size for SFC9100

Ben Pfaff (2):
      openvswitch: Correct comment.
      openvswitch: Shrink sw_flow_mask by 8 bytes (64-bit) or 4 bytes (32-bit).

Benjamin Poirier (1):
      net: Do not enable tx-nocache-copy by default

Bing Zhao (11):
      Bluetooth: btmrvl: operate on 16-bit opcodes instead of ogf/ocf
      Bluetooth: btmrvl: use cal-data from device-tree instead of conf file
      Bluetooth: btmrvl: remove cal-data byte swapping and redundant mem copy
      mwifiex: avoid using variable name eth_hdr
      mwifiex: send regulatory domain info to firmware only if alpha2 changed
      mwifiex: remove cfg_data construction
      mwifiex: download cal-data from device-tree to firmware
      mwifiex: download per country tx power table to firmware
      mwifiex: fix potential buffer overflow in dt configuration
      mwifiex: use a function to replace two copies of a code fragment
      mwifiex: fix wrong 11ac bits setting in fw_cap_info

Bob Copeland (10):
      mac80211: fix off-by-one in llid check.
      mac80211: hold sta->lock across plink switch statements
      mac80211: mesh: factor out common plink close/estab code
      mac80211: mesh_plink: group basic fitness checks
      mac80211: mesh: rewrite rssi_threshold_check in C
      mac80211: mesh_plink: collapse the two switch statements together
      mac80211: mesh_plink: don't ignore holding timer
      mac80211: return -ENOMEM in mesh_plink_frame_tx
      mac80211: remove unused mesh_mgmt_ies_add() prototype
      mac80211: mesh: only get tsf if we need it

Carolyn Wyborny (4):
      igb: Add media switching feature for i354 PHY's
      igb: Add new feature Media Auto Sense for 82580 devices only
      igb: Fix queue allocation method to accommodate changing during runtime
      igb: Change to use statically allocated array for MSIx entries

Catherine Sullivan (9):
      i40e: Bump version
      i40e: Bump version number
      i40e: Bump version number
      i40e: Populate and check pci bus speed and width
      i40e: Bump version
      i40e: Turn flow director off in MFP mode
      i40e: Bump version
      i40e: Bump version
      i40e: Bump version number

Chen-Yu Tsai (8):
      net: stmmac: Enable stmmac main clock when probing hardware
      net: stmmac: Add support for optional reset control
      net: stmmac: Allocate and pass soc/board specific data to callbacks
      blackfin: Update stmmac callback signatures
      net: stmmac: Honor DT parameter to force DMA store and forward mode
      net: stmmac: Deprecate snps, phy-addr and auto-detect PHY address
      net: stmmac: Use driver data and callbacks tied with compatible strings
      net: stmmac: sunxi platform extensions for GMAC in Allwinner A20 SoC's

Christian Engelmayer (1):
      wireless: cw1200: Fix memory leak in cw1200_wow_suspend()

Christoph Paasch (7):
      tcp: metrics: rename tcpm_addr to tcpm_daddr
      tcp: metrics: Add source-address to tcp-metrics
      tcp: metrics: New netlink attribute for src IP and dumped in netlink reply
      tcp: metrics: Delete all entries matching a certain destination
      tcp: metrics: Allow selective get/del of tcp-metrics based on src IP
      tcp: metrics: Fix rcu-race when deleting multiple entries
      tcp: metrics: Handle v6/v4-mapped sockets in tcp-metrics

Christopher Pau (1):
      i40e: set pf_id based on device and function numbers

Chun-Yeow Yeoh (10):
      mac80211: use put_unaligned_le16 for precedence value in mesh
      mac80211: use put_unaligned_le16 in mesh_plink_frame_tx
      mac80211: use put_unaligned_le in mesh when necessary
      nl80211: allow the use of DFS channel in mesh
      wcn36xx: enable beacon change using BSS_CHANGED_BEACON
      wcn36xx: set self STA default HT parameters
      wcn36xx: fix typo error
      ath9k: enable dfs for mesh mode
      wcn36xx: enable the beaconing in mesh mode
      mac80211: enable WME for peer mesh STA

Claudio Takahasi (2):
      Bluetooth: Fix setting Universal/Local bit
      Bluetooth: Fix 6loWPAN peer lookup

Claudiu Manoil (1):
      gianfar: Fix portabilty issues for ethtool and ptp

Cong Wang (1):
      net: revert "sched classifier: make cgroup table local"

Dan Carpenter (6):
      ath9k: fix SC_OP_INVALID test in ath9k_tx99_init()
      isdn: use strlcpy() instead strcpy()
      p54: clamp properly instead of just truncating
      sctp: remove a redundant NULL check
      rxrpc: out of bound read in debug code
      tulip: cleanup by using ARRAY_SIZE()

Daniel Borkmann (33):
      net: dev: move inline skb_needs_linearize helper to header
      packet: introduce PACKET_QDISC_BYPASS socket option
      filter: bpf_dbg: add minimal bpf debugger
      filter: bpf_asm: add minimal bpf asm tool
      filter: doc: improve BPF documentation
      bpf_dbg: always close socket in bpf_runnable
      bpf_exp: free duplicated labels at exit time
      net: skbuff: improve comment on checksumming
      net: vxlan: use custom ndo_change_mtu handler
      netlink: only do not deliver to tap when both sides are kernel sks
      netlink: specify netlink packet direction for nlmon
      netfilter: nf_tables: fix type in parsing in nf_tables_set_alloc_name()
      netfilter: nf_nat: add full port randomization support
      net: net_cls: move cgroupfs classid handling into core
      net: netprio: rename config to be more consistent with cgroup configs
      netfilter: x_tables: lightweight process control group matching
      net: netdev_kobject_init: annotate with __init
      netfilter: nf_conntrack_dccp: use %s format string for buffer
      netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages
      net: ovs: use kfree_rcu instead of rcu_free_{sw_flow_mask_cb,acts_callback}
      net: xfrm: xfrm_policy: fix inline not at beginning of declaration
      net: skbuff: const-ify casts in skb_queue_* functions
      net: vxlan: when lower dev unregisters remove vxlan dev as well
      net: vxlan: properly cleanup devs on module unload
      packet: improve socket create/bind latency in some cases
      packet: don't unconditionally schedule() in case of MSG_DONTWAIT
      packet: use percpu mmap tx frame pending refcount
      net: vxlan: do not use vxlan_net before checking event type
      packet: fix a couple of cppcheck warnings
      net: filter: let bpf_tell_extensions return SKF_AD_MAX
      random32: add prandom_u32_max and convert open coded users
      net: introduce reciprocal_scale helper and convert users
      net: vxlan: convert to act as a pernet subsystem

Daniel Pieczko (1):
      sfc: split setup of hardware timestamping into NIC-type operation

David Cassard (1):
      i40e: keep allocated memory in structs

David Gnedt (11):
      wl1251: fix scan behaviour while not associated
      wl1251: retry power save entry
      wl1251: implement hardware ARP filtering
      wl1251: split RX and TX data path initialisation
      wl1251: configure hardware en-/decryption for monitor mode
      wl1251: implement multicast address filtering (fwd)
      wl1251: disable power saving in monitor mode
      wl1251: fix channel switching in monitor mode
      wl1251: enable tx path in monitor mode if necessary for packet injection
      wl1251: disable retry and ACK policy for injected packets
      wl1251: enforce changed hw encryption support on monitor state change

David S. Miller (123):
      Merge branch 'siocghwtstamp' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'of_mdio'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'phy_reset'
      Merge branch 'neigh'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'ifla_flags'
      Revert "tun: remove useless codes in tun_chr_aio_read() and tun_recvmsg()"
      Revert "macvtap: remove useless codes in macvtap_aio_read() and macvtap_recvmsg()"
      Merge branch 'macb'
      Merge branch 'tipc'
      Merge branch 'bpf'
      Merge branch 'macvtap_capture'
      Merge branch 'bonding_netlink'
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'bonding_rcu'
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'ovs_hash'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'phy_power'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'bonding_netlink'
      Merge branch 'skb_hash'
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'qlcnic'
      lib: Add missing arch generic-y entries for asm-generic/hash.h
      Merge branch 'bna'
      Merge branch 'vlan_tpid'
      Merge branch 'phy_checkpatch'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'bonding_nl'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'mlx4'
      Merge branch 'sh_eth'
      Merge branch 'bridge_cleanups'
      Merge branch 'b44'
      Revert "sctp: fix missing include file"
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'addr_compare'
      Merge branch 'bnx2x'
      bnx2x: Fix build with SRIOV disabled.
      Merge branch 'tun_rfs'
      Merge branch 'sctp_logspam'
      Merge branch 'addr_compare'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'r8152'
      Merge branch 'bonding'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'tunnel_dst_caching'
      Merge branch 'tg3'
      Merge branch 'bonding'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'bgmac'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../pablo/nftables
      netfilter: Fix build failure in nfnetlink_queue_core.c.
      Merge branch 'master' of git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      bna: Fix build due to missing use of dma_unmap_len_set()
      Merge branch 'tipc'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../pablo/nftables
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'tcp_metrics_saddr'
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'alx_stats'
      Merge branch 'ip_forward_pmtu'
      Merge branch 'qlcnic'
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'bonding_rcu'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'skb_checksum_help'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'netdev_tracing'
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'atl_stats'
      Merge branch 'r8152'
      Merge branch 'dev_get_by_index'
      Merge branch 'i40e'
      Merge branch 'intel-next'
      Merge branch 'vxlan_lower_dev_unregister'
      Merge branch 'i40e-next'
      Merge branch 'netdev_sysfs_symlink_rename'
      Merge branch 'be2net'
      Revert "batman-adv: drop dependency against CRC16"
      Merge branch 'noprefixroute'
      Merge branch 'ixgbe'
      Merge branch 'master' of git://git.kernel.org/.../pablo/nftables
      Merge branch 'mvneta'
      Merge branch 'stmmac_pm'
      Merge branch 'ixgbe-next'
      i40e: Remove autogenerated Module.symvers file.
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'tipc'
      Merge branch 'virtio_rx_merging'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'ixgbe'
      Merge branch 'bonding_slave_sysfs'
      Merge branch 'ixgbe'
      Merge branch 'i40e'
      Merge branch 'ixgbevf'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'sfc'
      Merge branch 'gro_udp_encap'
      Merge branch 'sctp'
      net: Fix some fallout from the etner_addr_copy() changes.
      net: Missing change from the ether_addr_copy() fixups.
      Merge branch 'reciprocal'
      Merge branch 'bonding_option_api'
      Merge branch 'bonding'
      Merge branch 'qlcnic'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next

David Spinadel (2):
      mac80211: reschedule sched scan after HW restart
      iwlwifi: mvm: add REPLY_SF_CFG_CMD to cmd strings

Dmitry Eremin-Solenikov (1):
      net: move 6lowpan compression code to separate module

Dominic Curran (1):
      tuntap: Fix for a race in accessing numqueues

Don Skidmore (7):
      ixgbe: Focus config of head, tail ntc, and ntu all into a single function
      ixgbevf: add DCB configuration into queue setup
      ixgbevf: Convert ring storage form pointer to an array to array of pointers
      ixgbevf: create function for all of ring init
      ixgbe: Fix incorrect logic for fixed fiber eeprom write
      ixgbe: bump version number
      ixgbevf: bump version

Duan Jiong (3):
      packet: use macro GET_PBDQC_FROM_RB to simplify the codes
      ipv4: remove the useless argument from ip_tunnel_hash()
      ip_tunnel: clear IPCB in ip_tunnel_xmit() in case dst_link_failure() is called

Eddie Wai (1):
      cnic: Add a signature to indicate valid doorbell offset.

Edward Cree (3):
      sfc: Report units in sensor warnings
      sfc: Revise sensor names to be more understandable and consistent
      sfc: Log all unexpected MCDI errors

Eliad Peller (14):
      mac80211: add min required channel definition field
      mac80211: remove duplicate code
      mac80211: determine completed scan type by defined ops
      mac80211: start_next_roc only if scan was actually running
      cfg80211: don't "leak" uncompleted scans
      iwlwifi: mvm: enable d3_test even if d3_test_pme_ptr is not available
      iwlwifi: mvm: disconnect on disconnection wakeup event
      iwlwifi: mvm: allow keeping connections in d3_test
      iwlwifi: mvm: fix scan offloading flag definition
      iwlwifi: mvm: add multicast filtering support
      iwlwifi: mvm: configure phy_ctxt with min_def
      iwlwifi: mvm: check iwl_nvm_init return value
      iwlwifi: mvm: fix missing cleanup in .start() error path
      iwlwifi: mvm: fix tx seq_ctrl debug print

Emil Tantilov (7):
      ixgbevf: make use of the dev pointer in the ixgbevf_ring struct
      ixgbevf: move ring specific stats into ring specific structure
      ixgbevf: remove counters for Tx/Rx checksum offload
      ixgbevf: add tx counters
      ixgbevf: make the first tx_buffer a repository for most of the skb info
      ixgbevf: redo dma mapping using the tx buffer info
      ixgbevf: merge ixgbevf_tx_map and ixgbevf_tx_queue into a single function

Emmanuel Grumbach (40):
      iwlwifi: remove TX_CMD id from transport layer
      iwlwifi: mvm: BT Coex - fine tune the aggregation size
      iwlwifi: mvm: a few more SKUs for 7260 and 3160
      iwlwifi: mvm: dump NVM from debugfs
      iwlwifi: mvm: BT Coex - enable Sync to SCO
      iwlwifi: mvm: rs: fix compilation without CONFIG_MAC80211_DEBUGFS
      iwlwifi: mvm: don't send SMPS action frame with single RX antenna
      iwlwifi: mvm: move iwl_mvm_set_tx_power to PHY area
      iwlwifi: remove pointer to transport from op_mode
      iwlwifi: mvm: fixup Makefile
      iwlwifi: pcie: clean up ICT allocation code
      iwlwifi: pcie: track interrupt mask in SW
      iwlwifi: pcie: re-organize the PCIe ISR code
      iwlwifi: pcie: move the ICT / non-ICT handling functions
      iwlwifi: pcie: read the interrupt cause from the handler
      iwlwifi: pcie: determine the interrupt type in the handler
      iwlwifi: pcie: return inta from iwl_pcie_int_cause_{non_}ict
      iwlwifi: pcie: no need to save inta in trans_pcie
      iwlwifi: pcie: move interrupt prints to the common handler
      iwlwifi: pcie: use don't disable interrupt when irq_lock is taken
      iwlwifi: pcie: use don't disable interrupt when rxq->lock is taken
      iwlwifi: mvm: fix AC / FIFO mapping
      iwlwifi: pcie: keep the NIC awake when commands are in flight
      iwlwifi: pcie: don't update the op_mode if rfkill hasn't changed
      iwlwifi: pcie: allow the op_mode to call stop_device whenever it wants
      iwlwifi: mvm: disable the device as soon as RFKILL fires
      iwlwifi: mvm: fix harmless smatch / coccinelle warnings
      iwlwifi: mvm: BT Coex - update channel inihibition for channel 14
      iwlwifi: mvm: dump to debugfs the SRAM as binary
      iwlwifi: Update Copyright to 2014
      mac80211: clean up garbage in comment
      mac80211: simplify code in ieee80211_prepare_and_rx_handle
      mac80211: allow to set smps mode to OFF in AP mode
      iwlwifi: mvm: don't set the drain bit when we flush the AP station
      iwlwifi: pcie: enable oscillator for L1 exit
      iwlwifi: mvm: send all the NVM sections to the NIC
      iwlwifi: mvm: fix SRAM dump debugfs handler
      iwlwifi: mvm: remove unused flags from add station command
      iwlwifi: mvm: reset Thermal Throttling's SMPS request upon disassociation
      iwlwifi: pcie: don't panic on host commands in iwldvm

Eran Harary (1):
      iwlwifi: pcie: Fix CSR_RESET operation access type

Eric Dumazet (24):
      ipv6: consistent use of IP6_INC_STATS_BH() in ip6_forward()
      gro: small napi_get_frags() optim
      tcp: optimize some skb_shinfo(skb) uses
      tcp: auto corking
      net: introduce dev_consume_skb_any()
      pkt_sched: give visibility to mq slave qdiscs
      pkt_sched: set root qdisc before change() in attach_default_qdiscs()
      tcp: refine TSO splits
      pkt_sched: fq: more robust memory allocation
      rps: NUMA flow limit allocations
      net_sched: fix a regression in tcf_proto_lookup_ops()
      net_sched: fix regression in tc_action_ops
      tcp: autocork should not hold first packet in write queue
      net: use kfree_skb_list() helper
      tcp: out_of_order_queue do not use its lock
      vxlan: keep original skb ownership
      gre_offload: statically build GRE offloading support
      net/mlx4_en: call gro handler for encapsulated frames
      net: gro: change GRO overflow strategy
      tcp: do not export tcp_gso_segment() and tcp_gro_receive()
      net: eth_type_trans() should use skb_header_pointer()
      ipv4: fix a dst leak in tunnels
      net: ftgmac100: use kfree_skb() where appropriate
      ipv4: be friend with drop monitor

Eric Leblond (7):
      netfilter: nf_tables: fix issue with verdict support
      netfilter: xt_NFQUEUE: separate reusable code
      netfilter: nft: add queue module
      netfilter: select NFNETLINK when enabling NF_TABLES
      netfilter: REJECT: separate reusable code
      netfilter: nft_reject: support for IPv6 and TCP reset
      netfilter: xt_CT: fix error value in xt_ct_tg_check()

Erik Hugne (1):
      tipc: remove interface state mirroring in bearer

Eugene Crosser (4):
      qeth: Accurate ethtool output
      qeth: bridgeport support - basic control
      s390/qdio: bridgeport support - CHSC part
      qeth: bridgeport support - address notifications

Eugene Krasnikov (1):
      wcn36xx: Fix logging macro with unnecessary semicolon

Eugenia Emantayev (2):
      net/mlx4_en: Ignore irrelevant hypervisor events
      net/mlx4_en: Add NAPI support for transmit side

Eyal Perry (2):
      net/mlx4_core: Set CQE/EQE size to 64B by default
      net/mlx4_core: Warn if device doesn't have enough PCI bandwidth

Eyal Shapira (39):
      mac80211: enable easier manipulation of VHT beamforming caps
      iwlwifi: mvm: fix and improve printing of rate scale table
      iwlwifi: mvm: simplify iwl_mvm_send_lq_cmd
      iwlwifi: mvm: refactor iwl_mvm_rs_rate_init
      iwlwifi: mvm: implement rate_update hook in rs
      iwlwifi: mvm: add LQ flags definitions
      iwlwifi: fix check for a single rx antenna
      iwlwifi: mvm: stop using MIMO in case BT doesn't allow it
      iwlwifi: mvm: don't enable VHT MCS9 in 20Mhz
      iwlwifi: mvm: don't configure mimo rates if nss is limited to 1
      iwlwifi: mvm: rs: improve debug prints
      iwlwifi: mvm: rs: reduce min failures to end test window
      iwlwifi: mvm: rs: update expected TPT tables if aggregation changed
      iwlwifi: mvm: rs: rename thresholds defines
      iwlwifi: mvm: rs: increase stay in column timeout
      iwlwifi: mvm: rs: remove unused timestamp field
      iwlwifi: mvm: rs: refactor to use rs_rate
      iwlwifi: mvm: rs: remove unused parameter to rs_get_supported_rates
      iwlwifi: mvm: rs: set dual_stream_ant_msk to ANT_AB always
      iwlwifi: mvm: rs: fix mapping from HT/VHT rates to legacy
      iwlwifi: mvm: rs: use the proper channel width define for legacy rate
      iwlwifi: mvm: rs: overhaul search cycle state machine
      iwlwifi: publish STBC support in HT
      iwlwifi: set VHT beamformee STS cap correctly
      iwlwifi: publish Tx STBC support in VHT
      iwlwifi: mvm: rs: move rs_program_fix_rate to cleanup ifdefs
      iwlwifi: mvm: rs: refactor building the LQ command
      iwlwifi: mvm: rs: avoid recalc of supported legacy rate mask
      iwlwifi: mvm: rs: improve rates table algo
      iwlwifi: mvm: rs: remove unnecessary debug logs
      iwlwifi: mvm: rs: refactor rate scale action decision
      iwlwifi: mvm: rs: disable MCS9 Tx workaround
      iwlwifi: mvm: set highest rate in VHT MCS Set
      iwlwifi: mvm: rs: fix RTS protection being set indefinitely
      iwlwifi: mvm: rs: fix a potential NULL deref
      iwlwifi: mvm: rs: fix handling of column switch error
      iwlwifi: mvm: rs: fix a theoretical out of bounds access
      iwlwifi: change beamformee STS cap
      iwlwifi: mvm: don't use highest rate in VHT MCS Set

Eytan Lifshitz (2):
      iwlwifi: mvm: fix possible memory leak
      iwlwifi: mvm: fix theoretical uninitialized function return value

Ezequiel Garcia (1):
      can: ti_hecc: Replace platform dependency with ARM dependency

FX Le Bail (5):
      IPv6: add the option to use anycast addresses as source addresses in echo reply
      IPv6: move the anycast_src_echo_reply sysctl to netns_sysctl_ipv6
      ipv6: enable anycast addresses as source addresses in ICMPv6 error messages
      net: update comments of "struct msghdr" with the more accurate RFC3542 ones
      ipv6: enable anycast addresses as source addresses for datagrams

Fan Du (15):
      xfrm: Try to honor policy index if it's supplied by user
      xfrm: Using the right namespace to migrate key info
      xfrm: Namespacify xfrm state/policy locks
      xfrm: check user specified spi for IPComp
      xfrm: export verify_userspi_info for pkfey and netlink interface
      xfrm: Add file to document IPsec corner case
      {pktgen, xfrm} Correct xfrm state lock usage when transforming
      {pktgen, xfrm} Add statistics counting when transforming
      {pktgen, xfrm} Correct xfrm_state_lock usage in xfrm_stateonly_find
      {pktgen, xfrm} Using "pgset spi xxx" to spedifiy SA for a given flow
      {pktgen, xfrm} Construct skb dst for tunnel mode transformation
      {pktgen, xfrm} Introduce xfrm_state_lookup_byspi for pktgen
      {pktgen, xfrm} Show spi value properly when ipsec turned on
      {pktgen, xfrm} Document IPsec usage in pktgen.txt
      {xfrm,pktgen} Fix compiling error when CONFIG_XFRM is not set

Felix Fietkau (25):
      cfg80211: fix reporting 5/10 MHz support to user space
      ath9k: use a timer to put hardware into full sleep
      ath9k: optimize ath_drain_all_txq
      ath9k: optimize ath9k_flush
      ath9k_hw: fix TSF save/restore around chip reset
      ath9k_hw: allow fast channel change when only CHANNEL_HT changes
      mac80211: let the driver reserve extra tailroom in beacons
      ath9k_common: get rid of an unnecessary variable
      ath9k: add support for reporting per-chain signal strength
      ath9k_hw: use a software timer for btcoex no_stomp_timer
      ath9k_hw: clean up generic timer code
      ath9k_hw: remove defunct ad-hoc mode ATIM window handling code
      ath9k_hw: remove ah->config.pcie_clock_req
      ath9k_hw: simplify spur channel handling
      ath9k_hw: remove additional_swba_backoff
      ath9k_hw: remove spur related unused defines
      ath9k_hw: clean up station beacon timer API
      ath9k: properly preserve TSF across reset
      mac80211: add helper functions for tracking P2P NoA state
      ath9k: move ath9k_debug_sync_cause out of ath9k_hw
      ath9k: call ath9k_set_tsfadjust from ath9k_beacon_config
      ath9k: fix TSF offset precision issue
      ath9k: simplify/fix tx packet TID handling
      ath9k_hw: fix gentimer callback without overflow handler
      ath9k_hw: fix TSF offset calculation

Fengguang Wu (3):
      iwlwifi: mvm: fix coccinelle warnings
      pktgen_dst_metrics[] can be static
      qlcnic: fix sparse warnings

Flavio Leitner (1):
      ipv6: send Change Status Report after DAD is completed

Florent Fourcot (10):
      ipv6: add flowinfo for tcp6 pkt_options for all cases
      ipv6: move IPV6_TCLASS_MASK definition in ipv6.h
      ipv6: remove rcv_tclass of ipv6_pinfo
      ipv6: add ip6_flowlabel helper
      ipv6: use ip6_flowinfo helper
      ipv6: fix incorrect type in declaration
      ipv6: tcp: fix flowlabel value in ACK messages send from TIME_WAIT
      ipv6: add the IPV6_FL_F_REFLECT flag to IPV6_FL_A_GET
      ipv6: add a flag to get the flow label used remotly
      ipv6: add flowlabel_consistency sysctl

Florian Fainelli (28):
      net: of_mdio: factor PHY registration from of_mdiobus_register
      net: of_mdio: use PHY_MAX_ADDR constant
      net: of_mdio: do not overwrite PHY interrupt configuration
      net: phy: breakdown PHY_*_FEATURES defines
      net: of_mdio: parse "max-speed" property to set PHY supported features
      arc_emac: remove custom "max-speed" parsing code
      Documentation: update Ethernet PHY devices binding with 'max-speed'
      net: phy: report link partner features through ethtool
      net: phy: use phy_init_hw instead of open-coding it
      net: greth: use phy_read_status()
      net: bfin_mac: do not reset PHY after phy_start()
      net: phy: consolidate PHY reset in phy_init_hw()
      net: mv643xx_eth: use phy_init_hw to reset PHY
      net: pxa168_eth: use phy_init_hw for PHY reset
      net: tc35815: use phy_init_hw for PHY reset
      net: sh_eth: do not issue a wild PHY reset through BMCR
      net: phy: cicada: fix checkpath errors
      net: phy: davicom: fix checkpath errors
      net: phy: dp83640: fix checkpath error
      net: phy: icplus: fix checkpath error
      net: phy: lxt: fix checkpath errors
      net: phy: mdio_bus: fix checkpath error
      net: phy: micrel: fix checkpath errors
      net: phy: fix checkpatch errors
      net: phy: spi_ks8995: fix checkpatch errors
      bgmac: propagate error codes in bgmac_probe()
      r6040: add delays in MDIO read/write polling loops
      r6040: use ETH_ZLEN instead of MISR for SKB length checking

Florian Westphal (2):
      netfilter: avoid get_random_bytes calls
      netfilter: ctnetlink: honor CTA_MARK_MASK when setting ctmark

Francesco Fusco (3):
      lib: introduce arch optimized hash library
      net: ovs: use CRC32 accelerated flow hash if available
      lib: hash: follow-up fixups for arch hash

Franky Lin (3):
      brcmfmac: remove empty brcmf_proto_stop
      brcmfmac: add firmware and nvram file name for bcm4339
      brcmfmac: add host tx glomming support

Gao feng (3):
      vxlan: remove vxlan_group_used in vxlan_open
      vxlan: leave multicast group when vxlan device down
      ipv6: reallocate addrconf router for ipv6 address when lo device up

Gavin Shan (3):
      net/cxgb4: Avoid disabling PCI device for towice
      net/cxgb4: Don't retrieve stats during recovery
      net/cxgb4: Fix referencing freed adapter

Geert Uytterhoeven (5):
      ipvs: Remove unused variable ret from sync_thread_master()
      net/7990: Fix whitespace errors
      net/7990: Make lance_private.name const
      net: amd8111e: Spelling s/recive/receive/
      net: Spelling s/transmition/transmission/

Gianluca Anzolin (4):
      Bluetooth: Release RFCOMM port when the last user closes the TTY
      Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()
      Bluetooth: Always wait for a connection on RFCOMM open()
      Bluetooth: Remove rfcomm_carrier_raised()

Greg Rose (20):
      i40evf: main driver core
      i40evf: transmit and receive functionality
      i40evf: core ethtool functionality
      i40evf: virtual channel interface
      i40evf: driver core headers
      i40evf: init code and hardware support
      i40evf: add driver to kernel build system
      i40evf: A0 silicon specific
      i40e: Fix SR-IOV VF port VLAN
      i40e: Do not enable default port on the VEB
      i40e: Fix VF driver MAC address configuration
      i40e: Hide the Port VLAN VLAN ID
      i40e: Do not enable broadcast promiscuous by default
      i40e: Stop accepting any VLAN tag on VLAN 0 filter set
      i40e: Allow VF to set already assigned MAC address
      i40e: Enable/Disable PF switch LB on SR-IOV configure changes
      i40e: Fix GPL header
      i40e: add a comment on barrier and fix panic on reset
      i40e: Warn admin to reload VF driver on port VLAN configuration
      i40e: Retain MAC filters on port VLAN deletion

Guenter Roeck (5):
      igb: Convert to use devm_hwmon_device_register_with_groups
      igb: Start temperature sensor attribute index with 1
      ixgbe: Convert to use devm_hwmon_device_register_with_groups
      ixgbe: Start temperature sensor attribute index with 1
      can: Disable flexcan driver build for big endian CPU on ARM

Hadar Hen Zion (5):
      net/mlx4_core: Remove zeroed out of explicit QUERY_FUNC_CAP fields
      net/mlx4_core: Rename QUERY_FUNC_CAP fields
      net/mlx4_core: Introduce nic_info new flag in QUERY_FUNC_CAP
      net/mlx4_core: Expose physical port id as PF/VF capability
      net/mlx4_en: Implement ndo_get_phys_port_id

Haim Dreyfuss (1):
      iwlwifi: mvm: Implement low-priority scan

Hannes Frederic Sowa (14):
      ipv6: fix compiler warning in ipv6_exthdrs_len
      inet: make no_pmtu_disc per namespace and kill ipv4_config
      ipv4: new ip_no_pmtu_disc mode to always discard incoming frag needed msgs
      ipv6: support IPV6_PMTU_INTERFACE on sockets
      ipv6: move ip6_sk_accept_pmtu from generic pmtu update path to ipv6 one
      8021q: make vlan_pcpu_stats visible without CONFIG_VLAN_8021Q
      ipv4: introduce ip_dst_mtu_maybe_forward and protect forwarding path against pmtu spoofing
      ipv6: introduce ip6_dst_mtu_forward and protect forwarding path with it
      ipv4: introduce hardened ip_no_pmtu_disc mode
      ipv6: copy traffic class from ping request to reply
      ipv6: make IPV6_RECVPKTINFO work for ipv4 datagrams
      ipv6: optimize link local address search
      ipv6: protect protocols not handling ipv4 from v4 connection/bind attempts
      reciprocal_divide: update/correction of the algorithm

Hante Meuleman (13):
      brcmfmac: Update fwsignal to fix out of order tx.
      brcmfmac: rename dhd_cdc to bcdc
      brcmfmac: removed dhd_proto.h.
      brcmfmac: Dynamically register a protocol layer.
      brcmfmac: Use consistent naming for BCDC.
      brcmfmac: Move common BCDC code in single function.
      brcmfmac: Fix hex dump for FWIL.
      brcmfmac: Add definition of new protocol layer msgbuf.
      brcmfmac: Combine protocol push hdr and bus txdata.
      brcmfmac: Remove some obsolete definitions and variables.
      brcmfmac: Limit control message length from host to device.
      brcmfmac: Create common nvram parsing routines.
      brcmfmac: update core reset and disable routines.

Hariprasad Shenai (1):
      cxgb4: Changed FW check version to match FW binary version

Harry Mason (1):
      sch_htb: let skb->priority refer to non-leaf class

Hauke Mehrtens (18):
      brcmsmac: remove dependency on CRC8 and CRC_CCITT
      b44: check register instead of PHY address to detect external PHY
      b44: rename B44_PHY_ADDR_NO_PHY to B44_PHY_ADDR_NO_LOCAL_PHY
      b44: abort when no PHY is available at all
      b44: rename b44_mii_{read, write} to b44_mdio_{read, write}_mii
      b44: add phylib support
      b44: activate PHY when MAC is off
      b44: do not set PHY address to 30 for every ext PHY
      b44: use fixed PHY device if we do not find any
      bgmac: use phy_mii_ioctl in ioctl handler
      bcma: fix sparse warnings in driver_chipcommon_sflash.c
      ssb: fix sparse warnings in driver_chipcommon_sflash.c
      bcma: export bcma_find_core_unit()
      bgmac: initialize the DMA controller of core rev >= 4
      bgmac: add support for new BGMAC_CMDCFG_SR position on core rev >= 4
      bgmac: reset all cores on Northstar SoC
      bgmac: add support for Northstar SoC (BCM4707, BCM53018)
      bgmac: fix typos

Hayes Wang (1):
      r8152: correct some messages

Himanshu Madhani (6):
      qlcnic: Allow single Tx/Rx queue for all adapters.
      qlcnic: Enable beaconing for 83xx/84xx Series adapter.
      qlcnic: Enhance Tx timeout debugging.
      qlcnic: Refactor interrupt coalescing code for all adapters.
      qlcnic: Enhance logic to calculate msix vectors.
      qlcnic: update version to 5.3.55

Ido Shamay (1):
      net/mlx4_en: Configure the XPS queue mapping on driver load

Ilan Peer (7):
      iwlwifi: mvm: Do not allow AP MAC context update if not active
      iwlwifi: mvm: Add a missed beacons threshold
      iwlwifi: mvm: change the parameters for calculating an AP TBTT
      iwlwifi: mvm: dynamically update tsf_id
      cfg80211: Add a function to get the number of supported channels
      iwlwifi: mvm: clear ap_ibss_active in case of failure
      iwlwifi: mvm: update power after binding in start_ap_ibss()

Jack Morgenstein (1):
      mlx4_core: Roll back round robin bitmap allocation commit for CQs, SRQs, and MPTs

Jacob Keller (5):
      i40e: separate TSYNVALID and TSYNINDX fields in Rx descriptor
      ixgbevf: update Kconfig description
      i40e: enable PTP
      ixgbevf: set the disable state when ixgbevf_qv_disable is called
      ixgbe: add braces around else condition in ixgbe_qv_lock_* calls

Jamal Hadi Salim (2):
      net_sched: Remove unnecessary checks for act->ops
      net_sched: act: action flushing missaccounting

James Chapman (1):
      netfilter: introduce l2tp match extension

Janusz Dziedzic (15):
      ath10k: add phyerr/dfs handling
      mac80211_hwsim: use debugfs_remove_recursive
      mac80211_hwsim: Add iface comb for DFS
      mac80211_hwsim: VHT add 160MHz width support
      cfg80211: add helper functions for start/end freq
      cfg80211: DFS check chandef usable before CAC
      cfg80211/mac80211: DFS setup chandef for cac event
      cfg80211: allow beaconing after DFS CAC
      nl80211: don't clear bitrate_mask twice
      nl80211: allow setting bitrate mask back to default
      cfg80211: in bitrate_mask, rename mcs to ht_mcs
      ath10k: handle TKIP MIC error correctly
      nl80211: add VHT support for set_bitrate_mask
      ath10k: add DFS_CERTIFIED option
      ath10k: add set_bitrate_mask callback

Jason Wang (2):
      virtio-net: drop rq->max and rq->num
      net: document accel_priv parameter for __dev_queue_xmit()

Jean Sacren (1):
      sctp: fix missing SCTP mailing list address update

Jeff Kirsher (22):
      ethernet: Fix FSF address in file headers
      irda: Fix FSF address in file headers
      usb: Fix FSF address in file headers
      drivers/net/*: Fix FSF address in file headers
      sctp: Fix FSF address in file headers
      ipv4/ipv6: Fix FSF address in file headers
      include/net/: Fix FSF address in file headers
      netlabel: Fix FSF address in file headers
      netfilter: Fix FSF address in file headers
      net/irda: Fix FSF address in file headers
      net/*: Fix FSF address in file headers
      i40e: whitespace
      zd1211rw: Fix FSF address in file headers
      rt2x00: Fix FSF address in file headers
      prism54: Fix FSF address in file headers
      drivers/net/wireless: Fix FSF address in file headers
      rfkill: Fix FSF address in file headers
      nfc: Fix FSF address in file headers
      can: Fix FSF address in file headers
      pci_regs.h: Add PCI bus link speed and width defines
      i40e: Implementation of VXLAN ndo's
      i40e: Cleanup Doxygen warnings

Jerry Chu (3):
      net-gro: Prepare GRO stack for the upcoming tunneling support
      net-ipv6: Fix alleged compiler warning in ipv6_exthdrs_len()
      net-gre-gro: Add GRE support to the GRO stack

Jesper Dangaard Brouer (1):
      net: reorder struct netns_ct for better cache-line usage

Jesse Brandeburg (24):
      i40e: check multi-bit state correctly
      i40e: get media type during link info
      i40e: enable early hardware support
      i40e: remove and fix confusing define name
      i40e: fix up some of the ethtool connection reporting
      i40e: init flow control settings to disabled
      i40e: trivial fixes
      i40e: use same number of queues as CPUs
      i40e: update led set args
      i40e: fix mac address checking
      i40e: fix constant cast issues
      i40e: fix whitespace
      i40e: use kernel specific defines
      i40e: disable packet split
      i40e: fix spelling errors
      i40e: Add a dummy packet template
      i40e: drop unused macros
      i40e: whitespace fixes
      i40e: trivial cleanup
      i40e: fix compile warning on checksum_local
      i40e: Change firmware workaround
      i40e: whitespace fixes
      i40e: rename defines
      net: add vxlan description

Jesse Gross (1):
      openvswitch: Silence RCU lockdep checks from flow lookup.

Jing Wang (1):
      wl1251: return -ENOMEM if kzalloc fails

Jingoo Han (25):
      wireless: ipw2100: remove unnecessary pci_set_drvdata()
      wireless: prism54: remove unnecessary pci_set_drvdata()
      wireless: rt2x00: remove unnecessary pci_set_drvdata()
      wireless: libertas: remove unnecessary spi_set_drvdata()
      bcma: pci: remove unnecessary pci_set_drvdata()
      bcma: pci: remove DEFINE_PCI_DEVICE_TABLE macro
      net: sfc: remove unnecessary pci_set_drvdata()
      net: sis900: remove unnecessary pci_set_drvdata()
      net: bna: remove unnecessary pci_set_drvdata()
      net: ns83820: remove unnecessary pci_set_drvdata()
      net: forcedeth: remove unnecessary pci_set_drvdata()
      irda: via-ircc: remove unnecessary pci_set_drvdata()
      irda: vlsi_ir: remove unnecessary pci_set_drvdata()
      wan: dscc4: remove unnecessary pci_set_drvdata()
      wan: lmc: remove unnecessary pci_set_drvdata()
      wan: pc300too: remove unnecessary pci_set_drvdata()
      wan: pci200syn: remove unnecessary pci_set_drvdata()
      wan: wanxl: remove unnecessary pci_set_drvdata()
      net: hippi: remove unnecessary pci_set_drvdata()
      net: fddi: remove unnecessary pci_set_drvdata()
      net: vmxnet3: remove unnecessary pci_set_drvdata()
      net: phy: spi_ks8995: remove unnecessary spi_set_drvdata()
      net: ieee802154: remove unnecessary spi_set_drvdata()
      atm: he: remove unnecessary pci_set_drvdata()
      atm: solos-pci: remove unnecessary pci_set_drvdata()

Jiri Benc (1):
      ipv6: router reachability probing

Jiri Pirko (23):
      ipv6 addrconf: extend ifa_flags to u32
      ipv6 addrconf: introduce IFA_F_MANAGETEMPADDR to tell kernel to manage temporary addresses
      neigh: convert parms to an array
      neigh: wrap proc dointvec functions
      neigh: use tbl->family to distinguish ipv4 from ipv6
      neigh: restore old behaviour of default parms values
      neigh: ipv6: respect default values set before an address is assigned to device
      ipv6 addrconf: revert /proc/net/if_inet6 ifa_flag format
      neigh: use neigh_parms_net() to get struct neigh_parms->net pointer
      dn_dev: add support for IFA_FLAGS nl attribute
      ipv4: add support for IFA_FLAGS nl attribute
      bondnl: use be32 nla put/get for be32 values
      ipv4: loopback device: ignore value changes after device is upped
      neigh: split lines for NEIGH_VAR_SET so they are not too long
      neigh: use NEIGH_VAR_INIT in ndo_neigh_setup functions.
      bonding: change name of sysfs dir for bonding slaves
      rtnetlink: put "BOND" into nl attribute names which are related to bonding
      rtnetlink: provide api for getting and setting slave info
      bonding: convert netlink to use slave data info api
      rtnetlink: remove ndo_get_slave
      rtnetlink: add missing IFLA_BOND_AD_INFO_UNSPEC
      rtnetlink: remove check for fill_slave_info in rtnl_have_link_slave_info
      rtnetlink: remove IFLA_BOND_SLAVE definition

Jitendra Kalsaria (1):
      qlcnic: Support for 16 virtual NIC functions.

Joe Perches (14):
      ether_addr_equal: Optimize implementation, remove unused compare_ether_addr
      etherdevice: Add ether_addr_equal_unaligned
      batadv: Slight optimization of batadv_compare_eth
      etherdevice: Optimize a few is_<foo>_ether_addr functions
      mac80211: align struct ps_data.tim to unsigned long
      qlcnic: Convert vmalloc/memset to kcalloc
      etherdevice: Use ether_addr_copy to copy an Ethernet address
      8021q: Use ether_addr_copy
      appletalk: Use ether_addr_copy
      atm: Use ether_addr_copy
      caif_usb: Use ether_addr_copy
      netpoll: Use ether_addr_copy
      pktgen: Use ether_addr_copy
      dsa: Use ether_addr_copy

Johan Hedberg (42):
      Bluetooth: Remove unnecessary 'send' parameter from smp_failure()
      Bluetooth: Remove useless smp_rand function
      Bluetooth: Remove dead code from SMP encryption function
      Bluetooth: Remove unnecessary braces from one-line if-statement
      Bluetooth: Add module parameter to enable LE CoC support
      Bluetooth: Update l2cap_global_chan_by_psm() to take a link type
      Bluetooth: Allow l2cap_chan_check_security() to be used for LE links.
      Bluetooth: Pass command length to LE signaling channel handlers
      Bluetooth: Move LE L2CAP initiator procedure to its own function
      Bluetooth: Add definitions for LE connection oriented channels
      Bluetooth: Add initial code for LE L2CAP Connect Request
      Bluetooth: Add smp_sufficient_security helper function
      Bluetooth: Refactor L2CAP connect rejection to its own function
      Bluetooth: Add basic LE L2CAP connect request receiving support
      Bluetooth: Fix L2CAP channel closing for LE connections
      Bluetooth: Add L2CAP Disconnect suppport for LE
      Bluetooth: Make l2cap_le_sig_cmd logic consistent
      Bluetooth: Add LE L2CAP flow control mode
      Bluetooth: Track LE L2CAP credits in l2cap_chan
      Bluetooth: Limit L2CAP_OPTIONS socket option usage with LE
      Bluetooth: Add new BT_SNDMTU and BT_RCVMTU socket options
      Bluetooth: Implement returning of LE L2CAP credits
      Bluetooth: Add LE flow control discipline
      Bluetooth: Reject LE CoC commands when the feature is not enabled
      Bluetooth: Introduce L2CAP channel callback for suspending
      Bluetooth: Add LE L2CAP segmentation support for outgoing data
      Bluetooth: Implement LE L2CAP reassembly
      Bluetooth: Fix LE L2CAP Connect Request handling together with SMP
      Bluetooth: Fix suspending the L2CAP socket if we start with 0 credits
      Bluetooth: Limit LE MPS to the MTU value
      Bluetooth: Fix clearing of chan->omtu for LE CoC channels
      Bluetooth: Fix CID ranges for LE CoC CID allocations
      Bluetooth: Fix validating LE PSM values
      Bluetooth: Add debugfs controls for LE CoC MPS and Credits
      Bluetooth: Simplify l2cap_chan initialization for LE CoC
      Bluetooth: Use min_t for calculating chan->mps
      Bluetooth: Fix valid LE PSM check
      Bluetooth: Fix handling of L2CAP Command Reject over LE
      Bluetooth: Add missing 6lowpan.h include
      Bluetooth: Fix test for lookup_dev return value
      Bluetooth: Fix NULL pointer dereference when disconnecting
      Bluetooth: Default to no security with L2CAP RAW sockets

Johannes Berg (61):
      mac80211: remove useless tests for array
      cfg80211: add missing break in cfg80211_get_chan_state()
      cfg80211: don't allow drivers to unset NL80211_FEATURE_SCAN_FLUSH
      mac80211: verify ieee80211_key_replace() arguments
      mac80211_hwsim: use CLOCK_MONOTONIC_RAW
      mac80211: remove sta_info_flush() from interface teardown
      Revert "mac80211: add driver callback for per-interface multicast filter"
      mac80211: move align variable to remove __maybe_unused
      nl80211: vendor command support
      mac80211: neaten ieee80211_deliver_skb
      mac80211: warn if unhashing station fails
      iwlwifi: pcie: remove useless condition test
      iwlwifi: mvm: small debugfs cleanups
      iwlwifi: mvm: move interface-specific debugfs to a new file
      iwlwifi: mvm: don't use void pointers in debugfs
      iwlwifi: mvm: refactor debugfs copy_from_user()
      iwlwifi: mvm: add iwl_mvm_sta_from_mac80211
      iwlwifi: mvm: quota command max_duration should be zero
      Merge remote-tracking branch 'wireless-next/master' into mac80211-next
      mac80211: add pre-RCU-sync sta removal driver operation
      iwlwifi: mvm: use pre-RCU-sync sta removal operation
      mac80211: move 4-addr sta pointer clearing before synchronize_rcu()
      mac80211: don't delay station destruction
      mac80211: move synchronize_net() before sta key removal
      mac80211: optimise synchronize_net() for sta_info_flush
      mac80211: optimise mixed AP/VLAN station removal
      mac80211: free all AP/VLAN keys at once
      iwlwifi: mvm: clarify smps_requests documentation
      iwlwifi: mvm: rs: fix variable shadowing
      mac80211: make ieee80211_recalc_radar_chanctx static
      mac80211: remove unnecessary iflist_mtx locking
      mac80211: fix iflist_mtx/mtx locking in radar detection
      nl80211: support vendor-specific events
      cfg80211/mac80211: correct qos-map locking
      mac80211: add tracing for ieee80211_sta_set_buffered
      nl80211: move vendor/testmode event skb functions out of ifdef
      mac80211: clean up netdev debugfs macros a bit
      mac80211: handle station TX latency allocation errors
      mac80211: fix memory leak in register_hw() error path
      mac80211_hwsim: fix a print message
      mac80211: clean up prepare_for_handlers() return value
      mac80211: remove channel_change_time
      mac80211: fix PS-Poll driver release TID
      mac80211: release multiple ACs in uAPSD, fix more-data bug
      mac80211: reset TX info flags when frame will be reprocessed
      mac80211: handle MMPDUs at EOSP correctly
      mac80211_hwsim: clean up netlink exit code
      mac80211_hwsim: prepare for different channel support
      mac80211_hwsim: remove regtest for now
      mac80211_hwsim: refactor radio registration
      mac80211_hwsim: refactor radio cleanup
      mac80211_hwsim: minimize rctbl module parameter usage
      mac80211_hwsim: assign index from separate counter
      mac80211_hwsim: minor netlink cleanups
      mac80211_hwsim: shuffle code to prepare for dynamic radios
      mac80211_hwsim: verify wmediumd socket
      mac80211_hwsim: register netlink even with multi-channel
      mac80211_hwsim: allow creating/destroying radios on the fly
      mac80211_hwsim: restore regulatory testing functionality
      iwlwifi: mvm: use array indexing instead of treating it as a pointer
      iwlwifi: add inline helper for packet lengths

John Fastabend (1):
      ixgbe: reinit_locked() should be called with rtnl_lock

John W. Linville (22):
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge tag 'for-linville-20131203' of git://github.com/kvalo/ath
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge tag 'nfc-next-3.14-1' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

John Whitmore (1):
      can: update MAINTAINERS and Documentation

Jon Cooper (5):
      sfc: Add MC BISTs to ethtool offline self test on EF10
      sfc: Make initial fill of RX descriptors synchronous
      sfc: Correct RX dropped count for drops while interface is down
      sfc: Add RX packet timestamping for EF10
      sfc: Change efx_mcdi_reset_port to use ENTITY_RESET MC command.

Jon Paul Maloy (5):
      tipc: initiate media type array at compile time
      tipc: improve naming and comment consistency in media layer
      tipc: rename functions related to link failover and improve comments
      tipc: remove 'has_redundant_link' flag from STATE link protocol messages
      tipc: make link start event synchronous

Joseph Gasparakis (1):
      i40e: Rx checksum offload for VXLAN

Josh Triplett (1):
      net: wireless: brcm80211: Drop debug version with build date/time

Jukka Rissanen (5):
      6lowpan: Moving generic compression code into 6lowpan_iphc.c
      net: if_arp: add ARPHRD_6LOWPAN type
      ipv6: Add checks for 6LOWPAN ARP type
      Bluetooth: Enable 6LoWPAN support for BT LE devices
      Bluetooth: Manually enable or disable 6LoWPAN between devices

Julia Lawall (16):
      net: fix error return code
      hamradio: 6pack: fix error return code
      rt2x00: use ether_addr_equal_64bits
      ath5k: use ether_addr_equal_64bits
      p54: use ether_addr_equal_64bits
      mwl8k: use ether_addr_equal_64bits
      rtlwifi: use ether_addr_equal_64bits
      iwlegacy: use ether_addr_equal_64bits
      ath9k: use ether_addr_equal_64bits
      ipw2x00: use ether_addr_equal_64bits
      at76c50x-usb: use ether_addr_equal_64bits
      carl9170: use ether_addr_equal_64bits
      net: tulip: delete useless tests on netdev_priv
      smsc9420: use named constants for pci_power_t values
      brcmsmac: delete useless variable
      ksz884x: delete useless variable

Kalle Valo (10):
      ath10k: implement ath10k_pci_soc_read/write32()
      ath10k: add error handling to ath10k_pci_wait()
      ath10k: remove htt rx amsdu clear retry bit hack
      ath10k: don't show MSI registration warnings
      ath10k: make core boot messages more compact
      ath10k: show hardware and firmware info prints only once
      Merge remote-tracking branch 'wireless-next/master' into ath-next
      ath10k: handle WMI debug print events
      ath10k: add trace event for WMI_DEBUG_MESG_EVENTID
      ath10k: add debugfs file to control firmware dbglog

Kamil Krawczyk (4):
      i40e: restrict diag test length
      i40e: loopback info and set loopback fix
      i40e: remove redundant AQ enable
      i40e: Fix MAC format in Write MAC address AQ cmd

Karl Beldan (5):
      mac80211: do not compute offset from ssn in Rx AMPDU reordering buffer
      mac80211_hwsim: claim CCK support for HT clients
      mac80211: minstrel_ht: replace some occurences of MCS_GROUP_RATES
      mac80211: minstrels: spare numerous useless calls to get_random_bytes
      mac80211: minstrel_ht: do not sample unsupported rates

Kevin Lo (3):
      rt2x00: rt2800lib: Update BBP register initialization for RT53xx
      rt2x00: rt2800lib: update RF registers for RT5390
      rt2x00: rt2800lib: no need to write RF register 3 twice for RT5592

Kevin Scott (1):
      i40e: Add flag for L2 VEB filtering

Kevin Wallace (1):
      macvlan: Support creating macvtaps from macvlans

Kristian Evensen (2):
      netfilter: nft_ct: Add support to set the connmark
      netfilter: nft_ct: fix compilation warning if NF_CONNTRACK_MARK is not set

Kuninori Morimoto (3):
      irda: fixup SH_SIR position on Kconfig
      irda: sh_irda: use devm_request_irq()
      irda: sh_sir: use devm_request_irq()

Kyeyoon Park (2):
      cfg80211: Add support for QoS mapping
      mac80211: Add support for QoS mapping

Lad, Prabhakar (1):
      net: davinci_mdio: Fix sparse warning

Larry Finger (20):
      rtl8187: Increase RX queue depth
      rtlwifi: Remove unused calls to rtl_is_special_data()
      rtlwifi: rtl8192c: Prevent reconnect attempts if not connected
      rtlwifi: rtl8192cu: Add new firmware
      rtlwifi: Redo register save locations
      rtlwifi: Set the link state
      rtlwifi: rtl8192c: Add new definitions in the dm_common header
      rtlwifi: Increase the RX queue length for USB drivers
      rtlwifi: Update beacon statistics for USB driver
      rtlwifi: rtl8192c: Add routines to save/restore power index registers
      rtlwifi: rtl8192cu: Update the power index registers
      rtlwifi: rtl8192cu: Fix some code in RF handling
      rtlwifi: Add missing code to PWDB statics routine
      rtlwifi: rtl8192c: Update dynamic gain calculations
      rtlwifi: rtl8188ee: Fix typo in code
      rtlwifi: rtl8192c-common: Fix sparse warning
      rtlwifi: rtl8192cu: Add new device ID
      b43: Fix lockdep splat
      b43: Fix unload oops if firmware is not available
      b43legacy: Fix unload oops if firmware is not available

Laurence Evans (3):
      sfc: PTP - tidy up unused/useless variables
      sfc: Tidy up PTP synchronization code
      sfc: Add support for SFC9100 timestamp format

Levente Kurusa (1):
      bcma: add missing put_device call

Li RongQing (5):
      ipv6: unneccessary to get address prefix in addrconf_get_prefix_route
      ipv6: remove prune parameter for fib6_clean_all
      net: unify the pcpu_tstats and br_cpu_netstats as one
      macvlan: unify macvlan_pcpu_stats and vlan_pcpu_stats
      ipv6: move IPV6_TCLASS_SHIFT into ipv6.h and define a helper

Li Zhong (1):
      packet: fix using smp_processor_id() in preemptible code

Lilach Edelstein (1):
      iwlwifi: mvm: Add Smart FIFO support

Lorenzo Bianconi (3):
      ath9k: fix retry chain initialization in tx99 code
      ath9k: initialize retry chain flags in tx99 code
      ath9k: fix 5/10MHz channel width initialization on ar9003

Luciano Coelho (7):
      mac80211: move csa_chandef to sdata
      iwlwifi: mvm: don't restart HW if suspending fails before D3 image is loaded
      MAINTAINERS: remove myself as maintainer of TI WiLink drivers
      mac80211: lock sdata in ieee80211_csa_connection_drop_work()
      mac80211: make ieee80211_assign_beacon() static
      mac80211: refactor ieee80211_ibss_process_chanswitch()
      mac80211: align ieee80211_ibss_csa_beacon() with ieee80211_assign_beacon()

Luis R. Rodriguez (45):
      cfg80211: consolidate passive-scan and no-ibss flags
      cfg80211: force WIPHY_FLAG_CUSTOM_REGULATORY on wiphy_apply_custom_regulatory()
      cfg80211: remove second argument from reg_process_hint()
      cfg80211: add function helpers to genregdb.awk
      cfg80211: fix parsing when db.txt ends on a rule
      cfg80211: enforce disabling channels by custom or strict settings
      cfg80211: check regulatory request alpha2 early
      cfg80211: processing core regulatory hints on its own
      cfg80211: process user regulatory requests on its own
      cfg80211: process driver regulatory requests on its own
      cfg80211: process country IE regulatory requests on their own
      cfg80211: process non country IE conflicting first
      cfg80211: add helper for kfree'ing last_request
      cfg80211: add helper for kfree'ing and assigning last_request
      cfg80211: add helper for calling CRDA
      cfg80211: allow only the core to request to update the world regdom
      cfg80211: move core reg_notfier() check to source
      cfg80211: pass the last_request to __set_regdom()
      cfg80211: set core regulatory updates on its own
      cfg80211: set user regulatory updates on its own
      cfg80211: set driver regulatory updates on its own
      cfg80211: rename __set_regdom() to reg_set_rd_country_ie()
      cfg80211: move regulatory flags to their own variable
      cfg80211: add flags to define country IE processing rules
      cfg80211: add an option to disable processing country IEs
      cfg80211: use enum nl80211_dfs_regions for dfs_region everywhere
      cfg80211: intersection dfs regions when intersecting regdomains
      cfg80211: distinguish unset DFS region from unknown
      cfg80211: replace print_dfs_region() with reg_dfs_region_str() helper
      cfg80211: add reg_get_dfs_region()
      cfg80211: DFS check dfs_region before usage
      brcm80211: fix usage of freq_reg_info()
      rtlwifi: fix usage of freq_reg_info()
      ath: fix logic on ath_reg_apply_active_scan_flags()
      ath: clean up ath_reg_apply_active_scan_flags()
      ath: rename ath_reg_apply_active_scan_flags() to ath_reg_apply_ir_flags()
      ath: simplify ath_reg_apply_beaconing_flags()
      ath: move the channel for ath_reg_apply_beaconing_flags() into helper
      ath: fix usage of freq_reg_info()
      ath: move dynamic_country_user_possible() to the top
      ath: dynamic user allow check helper to the top
      ath: fix dynamic user regulatory domain support
      wireless: update MAINTAINERS
      ath: fix warning on usage of REGULATORY_CUSTOM_REG
      cfg80211: make regulatory_hint() remove REGULATORY_CUSTOM_REG

Manish Chopra (3):
      qlcnic: VLAN enhancement for 84XX adapters
      qlcnic: update version to 5.3.53
      qlcnic: Fix SR-IOV cleanup code path

Manish chopra (2):
      qlcnic: Interrupt code cleanup
      qlcnic: Update poll controller code path

Marc Kleine-Budde (1):
      can: ti_hecc: fix endianness related sparse warning

Marcel Holtmann (11):
      Bluetooth: Fix limited discoverable mode for Zeevo modules
      Bluetooth: Set default own address type only during controller setup
      Bluetooth: Remove debug statement for features complete event
      Bluetooth: Store supported commands only during setup procedure
      Bluetooth: Increase minor version of core module
      Bluetooth: Use macros for connectionless slave broadcast features
      Bluetooth: Set HCI_QUIRK_RESET_ON_CLOSE for Socket SDIO cards
      Bluetooth: Add support for vectored writes to virtual HCI driver
      Bluetooth: Use MD SET register for changing SDIO Type-B to Type-A
      Bluetooth: Add quirk for disabling Delete Stored Link Key command
      Bluetooth: Deal with USB devices that are faking CSR vendor

Marek Kwaczynski (1):
      nl80211/cfg80211: Set Operating Mode Notification

Marek Puzyniak (3):
      ath10k: introduce DFS implementation
      ath10k: add debugfs file to control radar events blocking
      ath10k: disable STA kickout in FW

Mark Cave-Ayland (3):
      rtlwifi: Bring _rtl92c_phy_iq_calibrate() in line with the vendor driver
      rtlwifi: rtl8192cu: Bring rtl92cu_phy_bb_config() up to date
      rtlwifi: rtl8192cu: Update table.c

Mark Rustad (7):
      ixgbe: Indicate removal state explicitly
      ixbge: Protect ixgbe_down with __IXGBE_DOWN bit
      ixgbe: Use static inlines instead of macros
      ixgbe: Make ethtool register test use accessors
      ixgbe: Check register reads for adapter removal
      ixgbe: Check for adapter removal on register writes
      ixgbe: Additional adapter removal checks

Markus Pargmann (1):
      can: c_can: Speed up rx_poll function

Matan Barak (1):
      net/mlx4_core: Check port number for validity before accessing data

Matthew Whitehead (2):
      8390 : Replace ei_debug with msg_enable/NETIF_MSG_* feature
      3c59x: Add software timestamping

Matti Gottlieb (1):
      mac80211: Tx frame latency statistics

Max Stepanov (4):
      mac80211: add generic cipher scheme support
      mac80211: check pairwise key_idx on get_key call
      mac80211: read station mgmt keys via get_key call
      iwlwifi: mvm: add a generic cipher scheme support

Michael Chan (6):
      bnx2: Advertise nothing when speed is forced
      bnx2: Enable auto-mdix when autoneg is disabled.
      bnx2: Report MDI/MDIX status to ethtool.
      bnx2: Update version to 2.2.5.
      tg3: Refactor __tg3_set_mac_addr()
      tg3: Add unicast filtering support.

Michael Dalton (7):
      net: allow > 0 order atomic page alloc in skb_page_frag_refill
      virtio-net: use per-receive queue page frag alloc for mergeable bufs
      virtio-net: auto-tune mergeable rx buffer size for improved performance
      net-sysfs: add support for device-specific rx queue sysfs attributes
      lib: Ensure EWMA does not store wrong intermediate values
      virtio-net: initial rx sysfs support, export mergeable rx buffer size
      virtio-net: fix build error when CONFIG_AVERAGE is not enabled

Michal Kazior (40):
      ath10k: prevent starting monitor without a vdev
      ath10k: add sanity checks for monitor management
      ath10k: fix endianess in prints
      ath10k: fix NSS reporting in RX
      ath10k: fix NULL deref upon early FW crash
      ath10k: fix FW crashes on heavy TX on 10.1.389 AP FW
      ath10k: setup min channel power to a reasonable value
      ath10k: use proper tx power unit
      ath10k: respect power_level values
      ath10k: plug memory leak in wmi mgmt tx worker
      ath10k: plug memory leak on beacon tx
      ath10k: remove ar_pci->ce_count
      ath10k: don't forget to kill fw error tasklet
      ath10k: split tasklet killing function
      ath10k: rename ath10k_pci_reset_target()
      ath10k: make sure to mask all CE irqs
      ath10k: fix ath10k_ce_init() failpath
      ath10k: remove meaningless check
      ath10k: use ath10k_do_pci_wake/sleep
      ath10k: propagate ath10k_ce_disable_interrupts() errors
      ath10k: guard against CE corruption from firmware
      ath10k: re-arrange PCI init code
      ath10k: add and fix some PCI prints
      ath10k: reset device upon stopping/power down
      ath10k: fix core init failpath
      ath10k: allow dynamic bandwidth in hw rate control
      ath10k: clear tx status before submitting to mac80211
      ath10k: don't consume other's shared interrupts
      ath10k: split up pci irq code
      ath10k: don't use interrupts for BMI
      ath10k: decouple ath10k_pci_start_ce()
      ath10k: defer irq registration until hif start()
      ath10k: extract functions for legacy irq handling
      ath10k: re-add support for early fw indication
      ath10k: allow explicit MSI/MSI-X disabling
      ath10k: fix Tx status clearing
      mac80211: fix rx_nss calculation for drivers with hw rc
      ath10k: fix multi BSSID with WPA on FW 10.1
      ath10k: fix WEP Shared authentication
      ath10k: fix band reporting for mgmt CCK frames on 5GHz

Michal Nazarewicz (3):
      iwlwifi: pcie: remove minor dead code
      net: wirelesse: wcn36xx: pull allocation outside of critical section
      netfilter: nf_tables: remove unused variable in nf_tables_dump_set()

Michal Schmidt (1):
      vmxnet3: use initialized skb pointer to set hash

Michal Sekletar (1):
      net: introduce SO_BPF_EXTENSIONS

Mitch Williams (27):
      i40e: allow one more vector for VFs
      i40e: properly add VF MAC addresses
      i40e: fix debugging messages
      i40e: move i40e_reset_vf
      i40e: refactor VF reset flow
      i40e: remove redundant code
      i40e: remove chatty log messages
      i40e: fix error return
      i40e: be more informative
      i40e: make a define from a large constant
      i40e: report VF MAC addresses correctly
      i40e: guard against vf message races
      i40e: use functions to enable and disable icr 0
      i40e: reinit buffer size each time
      i40e: avoid unnecessary register read
      i40e: use struct assign instead of memcpy
      i40e: don't allocate zero size
      i40e: acknowledge VFLR when disabling SR-IOV
      i40e: support VFs on PFs other than 0
      i40e: correctly setup ARQ descriptors
      i40e: shorten wordy fields
      i40e: trivial: formatting and checkpatch fixes
      i40e: use assignment instead of memcpy
      i40e: fix long lines
      i40e: allow VF to remove any MAC filter
      i40e: remove extra register write
      i40e: make message meaningful

Moni Shoua (1):
      net/mlx4_core: Remove unnecessary validation for port number

Mugunthan V N (1):
      drivers: net: cpsw: enable promiscuous mode support

Neal Cardwell (1):
      gre_offload: simplify GRE header length calculation in gre_gso_segment()

Neerav Parikh (7):
      i40e: Remove FCoE in i40e_virtchnl_pf.c code
      i40e: Fix dump output from debugfs calls
      i40e: Fix ring allocation
      i40e: I40E_FLAG_MQ_ENABLED is not used
      i40e: implement DCB support infastructure
      i40e: add DCB and DCBNL support
      i40e: add DCB option to Kconfig

Neil Horman (4):
      printk: Add a DEPRECATED macro
      SCTP: Reduce log spamming for sctp setsockopt
      sctp: Add process name and pid to deprecation warnings
      af_packet: Add Queue mapping mode to af_packet fanout operation

NeilBrown (1):
      libertas/sdio: make sure card enters power-off when firmware is loaded.

Nick Kossifidis (1):
      ath5k: Reset Tx interrupt bits also on PISR

Nicolas Dichtel (1):
      ipv4: fix wildcard search with inet_confirm_addr()

Nikolay Aleksandrov (26):
      bonding: add infrastructure for an option API
      bonding: convert mode setting to use the new option API
      bonding: convert packets_per_slave to use the new option API
      bonding: convert xmit_hash_policy to use the new option API
      bonding: convert arp_validate to use the new option API
      bonding: convert arp_all_targets to use the new option API
      bonding: convert fail_over_mac to use the new option API
      bonding: convert arp_interval to use the new option API
      bonding: convert arp_ip_target to use the new option API
      bonding: convert downdelay to use the new option API
      bonding: convert updelay to use the new option API
      bonding: convert lacp_rate to use the new option API
      bonding: convert min_links to use the new option API
      bonding: convert ad_select to use the new option API
      bonding: convert num_peer_notif to use the new option API
      bonding: convert miimon to use the new option API
      bonding: convert primary to use the new option API
      bonding: convert primary_reselect to use the new option API
      bonding: convert use_carrier to use the new option API
      bonding: convert active_slave to use the new option API
      bonding: convert queue_id to use the new option API
      bonding: convert all_slaves_active to use the new option API
      bonding: convert resend_igmp to use the new option API
      bonding: convert lp_interval to use the new option API
      bonding: convert slaves to use the new option API
      bonding: fix u64 division

Nithin Sujir (8):
      tg3: Don't add rxbds_empty to rx_over_errors
      tg3: Add flag to disable 1G Half Duplex advertisement
      tg3: Fix bit definition for the nvram Auto Power Down setting
      tg3: Expand multicast drop counter miscounting fix to 5762
      tg3: Update version to 3.135
      tg3: Set the MAC clock to the fastest speed during boot code load
      tg3: Poll cpmu link state on APE + ASF enabled devices
      tg3: Update version to 3.136

Norbert van Bolhuis (1):
      packet: doc: describe PACKET_MMAP with one packet socket for rx and tx

Oleg Moroz (1):
      can: sja1000: add support for Elcus CAN200PCI

Oleksij Rempel (6):
      ath9k_htc: reconfigure led_gpios after resume
      ath: add common function ath_is_mybeacon
      ath9k: use ath_is_mybeacon
      ath9k_htc: use ath_is_mybeacon
      ath5k: use ath_is_mybeacon
      carl9170: use ath_is_mybeacon

Oliver Hartkopp (2):
      can: gw: remove obsolete checks
      fib_frontend: fix possible NULL pointer dereference

Olof Johansson (4):
      net: eth: davinci_cpdma: 64-bit phys/dma_addr_t cleanup
      net: eth: davinci_cpdma: Mark a local variable static
      net: eth: cpsw: 64-bit phys_addr_t and sparse cleanup
      net: eth: 8390: remove section warning in etherh.c

Or Gerlitz (6):
      net/mlx4_core: Add basic support for TCP/IP offloads under tunneling
      net/mlx4_en: Add netdev support for TCP/IP offloads of vxlan tunneling
      net: Add GRO support for UDP encapsulating protocols
      net: Export gro_find_by_type helpers
      net: Add GRO support for vxlan traffic
      net/vxlan: Share RX skb de-marking and checksum checks with ovs

Pablo Neira Ayuso (8):
      netfilter: nf_tables: remove nft_meta_target
      netfilter: add help information to new nf_tables Kconfig options
      netfilter: nf_tables: dump sets in all existing families
      Revert "netfilter: avoid get_random_bytes calls"
      netfilter: nft_reject: fix compilation warning if NF_TABLES_IPV6 is disabled
      netfilter: nft_meta: fix lack of validation of the input register
      netfilter: nf_tables: fix error path in the init functions
      netfilter: nf_tables: fix missing byteorder conversion in policy

Pankaj Dubey (1):
      drivers: net: silence compiler warning in smc91x.c

Patrick McHardy (19):
      netfilter: nf_tables: make chain types override the default AF functions
      netfilter: nf_tables: add hook ops to struct nft_pktinfo
      netfilter: nf_tables: add support for multi family tables
      netfilter: nf_tables: add "inet" table for IPv4/IPv6
      netfilter: nf_tables: add nfproto support to meta expression
      netfilter: nft_meta: add l4proto support
      netfilter: nft_ct: load both IPv4 and IPv6 conntrack modules for NFPROTO_INET
      netfilter: nf_tables: split chain policy validation from actually setting it
      netfilter: nf_tables: restore chain change atomicity
      netfilter: nf_tables: fix check for table overflow
      netfilter: nf_tables: fix chain type module reference handling
      netfilter: nf_tables: add missing module references to chain types
      netfilter: nf_tables: replay request after dropping locks to load chain type
      netfilter: nf_tables: constify chain type definitions and pointers
      netfilter: nf_tables: minor nf_chain_type cleanups
      netfilter: nf_tables: perform flags validation before table allocation
      netfilter: nf_tables: take AF module reference when creating a table
      netfilter: nf_tables: prohibit deletion of a table with existing sets
      netfilter: nf_tables: rename nft_do_chain_pktinfo() to nft_do_chain()

Paul Bolle (2):
      net/mlx4_core: clean up cq_res_start_move_to()
      net/mlx4_core: clean up srq_res_start_move_to()

Paul Durrant (7):
      xen-netback: improve guest-receive-side flow control
      xen-netback: add gso_segs calculation
      xen-netback: stop vif thread spinning if frontend is unresponsive
      net: add skb_checksum_setup
      xen-netback: use new skb_checksum_setup function
      xen-netfront: use new skb_checksum_setup function
      xen-netfront: add support for IPv6 offloads

Paul Gortmaker (5):
      wireless: delete non-required instances of include <linux/init.h>
      i40evf: fix s390 build failure due to implicit prefetch.h
      netfilter: Add dependency on IPV6 for NF_TABLES_INET
      drivers/net: delete non-required instances of include <linux/init.h>
      net/ipv4: don't use module_init in non-modular gre_offload

Paul Moore (1):
      cipso: cleanup cipso_v4_translate() when !CONFIG_NETLABEL

Pavel Machek (2):
      wl1251: add nvs file name to module firmware list
      wl1251: fix NULL pointer dereference

Peter Pan(潘卫平) (1):
      tcp: delete redundant calls of tcp_mtup_init()

Pravin B Shelar (1):
      openvswitch: Per cpu flow stats.

Rafał Miłecki (5):
      bgmac: connect to PHY and make use of PHY device
      bgmac: start/stop PHY on netdev open/stop
      bgmac: reset cached MAC state during chip reset
      bgmac: replace some magic values with defines
      bgmac: drop duplicated PHY defines

Rasesh Mody (12):
      bna: Add software timestamping support
      bna: Set Get IOC fw State
      bna: Fix Filter Add Del
      bna: RX Filter Enhancements
      bna: Enable Multi Buffer RX
      bna: RX Processing and Config Changes
      bna: CQ Read Fix
      bna: Add NULL Check Before Dereferencing TCB
      bna: Handle the TX Setup Failures
      bna: Embed SKB Length in TX Vector
      bna: Firmware Patch Simplification
      bna: Update the Driver Version to 3.2.23.0

Rashika Kheria (10):
      drivers: net: Mark functions as static in 3945-debug.c
      drivers: net: Mark functions as static in 4965-debug.c
      drivers: net: Mark functions as static in debug.c
      drivers: net: Mark functions as static in qlcnic_io.c
      drivers: net: Mark functions as static in qlcnic_83xx_hw.c
      drivers: net: Mark functions as static in stmmac_platform.c
      drivers: net: Include new header file in sbni.c
      drivers: net: Mark functions as static in 3945-debug.c
      drivers: net: Mark functions as static in 4965-debug.c
      drivers: net: Mark functions as static in debug.c

Richard Weinberger (7):
      ptp_pch: Add dependency on HAS_IOMEM
      staging,dgap: Add dependency on HAS_IOMEM
      staging,spear_adc: Add dependency on HAS_IOMEM
      phy,exynos: Add dependency on HAS_IOMEM
      net,marvell: Add dependency on HAS_IOMEM
      power,goldfish: Add dependency on HAS_IOMEM
      staging,lpc32xx_adc: Add dependency on HAS_IOMEM

Robert Stonehouse (1):
      sfc: Demote "MC Scheduler error" messages

Roman Dubtsov (1):
      rt2x00: rt2800usb: mark D-Link DWA-137 as supported

Sabrina Dubroca (9):
      alx: add a hardware stats structure
      alx: add constants for the stats fields
      alx: add stats update function
      alx: add alx_get_stats64 operation
      alx: add stats to ethtool
      atl1c: update statistics code
      atl1e: update statistics code
      atl1: update statistics code
      net: remove unnecessary initializations in net_dev_init

Sachin Kamat (1):
      net: Cleanup in eth-netx.h

Salam Noureddine (1):
      ipv4: arp: update neighbour address when a gratuitous arp is received and arp_accept is set

Salil Kapur (1):
      NFC: mei_phy: Using kfree_skb() instead of kfree()

Samuel Ortiz (3):
      NFC: Return driver failure upon unknown event reception
      NFC: Only warn on SE discovery error
      NFC: pn533: Frame is invalid if ccid.datalen is 0

Sathya Perla (1):
      be2net: update driver version to 10.0.x

Sebastian Hesselbarth (5):
      net: mv643xx_eth: properly start/stop phy device
      net: phy: marvell: provide genphy suspend/resume
      net: phy: provide phy_resume/phy_suspend helpers
      net: phy: resume/suspend PHYs on attach/detach
      net: phy: suspend phydev when going to HALTED

Sergei Shtylyov (14):
      sh_eth: add R8A7791 support
      sh_eth: add PHY IRQ to platform data
      sh_eth: do not reset PHY needlessly
      sh_eth: coding style fixes
      phy: coding style fixes
      mdio_bus: coding style fixes
      <linux/phy.h>: coding style fixes
      phy: kill useless local variables
      phy: kill excess code
      phy: kill excess empty lines
      phylib: remove unused adjust_state() callback
      phylib: make phy_scan_fixups() static
      sh_eth: fix garbled TX error message
      DT: net: davinci_emac: "phy-handle" property is actually optional

Shahed Shaikh (2):
      qlcnic: Enable IPv6 LRO even if IP address is not programmed
      qlcnic: Update version to 5.3.54

Shannon Nelson (42):
      i40e: clear AQ head and tail registers
      i40e: simplify aq head-tail-len setups
      i40e: select reset counters correctly
      i40e: retry call on timeout
      i40e: default debug mask setting
      i40e: add interrupt test
      i40e: add support for triggering EMPR
      i40e: only set up the rings to be used
      i40e: clear test state bit after all ethtool tests
      i40e: refactor ethtool tests
      i40e: restrict diag test messages
      i40e: complain about out-of-range descriptor request
      i40e: fix pf reset after offline test
      i40e: support for suspend and resume
      i40e: prevent null pointer exception in dump descriptor
      i40e: simplify error messages for dump descriptor
      i40e: fix up scanf decoders
      i40e: more print_hex_dump use
      i40e: add wake-on-lan support
      i40e: fix curly brace use and return type
      i40e: fix error handling when alloc of vsi array fails
      i40e: catch unset q_vector
      i40e: use correct struct for get and update vsi params
      i40e: Add code to wait for FW to complete in reset path
      i40e: update firmware api to 1.1
      i40e: Reduce range of interrupt reg in reg test
      i40e: move PF ID init from PF reset to SC init
      i40e: check MAC type before any REG access
      i40e: rework shadow ram read functions
      i40e: whitespace paren and comment tweaks
      i40e: release NVM resource reservation on startup
      i40e: remove interrupt on AQ error
      i40e: accept pf to pf adminq messages
      i40e: check for possible incorrect ipv6 checksum
      i40e: adjust ITR max and min values
      i40e: clear qtx_head before enabling Tx queue
      i40e: call clear_pxe after adminq is initialized
      i40e: fix log message wording
      i40e: associate VMDq queue with VM type
      i40e: check desc pointer before printing
      i40e: updates to AdminQ interface
      i40e: Fix device ID define names to align to standard

Shaohui Xie (1):
      phylib: turn genphy_driver to an array

Shawn Bohrer (3):
      mlx4_en: Add PTP hardware clock
      mlx4_en: Only cycle port if HW timestamp config changes
      mlx4_en: Select PTP_1588_CLOCK

Shlomo Pongratz (1):
      net/udp_offload: Handle static checker complaints

Shradha Shah (2):
      sfc: Changed the statistic name emerg_{fetch,wait} to hlb_{fetch,wait}
      Add Shradha Shah as the sfc driver maintainer.

Simon Horman (2):
      sh_eth: Use bool as return type of sh_eth_is_gether()
      sh_eth: Add support for r7s72100

Simon Wunderlich (18):
      cfg80211: protect beacon changing functions with wdev-lock
      mac80211: modify beacon using sdata/wdev-lock, not rtnl lock
      cfg80211/mac80211/ath6kl: acquire wdev lock outside ch_switch_notify
      mac80211: don't cancel csa finalize work within stop_ap
      mac80211: don't leak next beacon when csa is aborted
      mac80211: fix nested sdata lock for IBSS/CSA
      batman-adv: remove bonding and interface alternating
      batman-adv: split tq information in neigh_node struct
      batman-adv: split out router from orig_node
      batman-adv: add WiFi penalty
      batman-adv: consider outgoing interface in OGM sending
      batman-adv: add bonding again
      batman-adv: add debugfs structure for information per interface
      batman-adv: add debugfs support to view multiif tables
      batman-adv: add build checks for packet sizes
      batman-adv: update copyright years for 2014
      batman-adv: Start new development cycle
      batman-adv: use consistent kerneldoc style

Solomon Peachy (2):
      cw1200: Make the "scan failed" message into a warning
      wireless: cw1200: Use consistent internal locking conventions

Somnath Kotur (1):
      be2net: Fix be_vlan_add/rem_vid() routines

Soren Brinkmann (6):
      net: macb: Migrate to dev_pm_ops
      net: macb: Migrate to devm clock interface
      net: macb: Use devm_ioremap()
      net: macb: Use devm_request_irq()
      net: macb: Adjust tx_clk when link speed changes
      net: macb: Fix build warning

Srinivas Kandagatla (9):
      net: stmmac: support max-speed device tree property
      net: stmmac: mdio: remove reset gpio free
      net: stmmac: move dma allocation to new function
      net: stmmac: move hardware setup for stmmac_open to new function
      net: stmmac: make stmmac_mdio_reset non-static
      net: stmmac: fix power management suspend-resume case
      net: stmmac: use suspend functions for hibernation
      net: stmmac: restore pinstate in pm resume.
      net: stmmac: notify the PM core of a wakeup event.

Stanislaw Gruszka (1):
      iwl3945: do not print RFKILL message

Steffen Hurrle (1):
      net: add build-time checks for msg->msg_name size

Steffen Klassert (2):
      xfrm: Remove ancient sleeping when the SA is in acquire state
      net: Remove FLOWI_FLAG_CAN_SLEEP

Stephen Hemminger (6):
      i40e: make functions static and remove dead code
      ipv4: make fib_detect_death static
      arp: make arp_invalidate static
      ipv4: remove unused function
      ipv4: ping make local stuff static
      ovs: make functions local

Stephen Rothwell (1):
      net: resort some Kbuild files to hopefully help avoid some conflicts

Stephen Warren (2):
      Bluetooth: remove direct compilation of 6lowpan_iphc.c
      Bluetooth: remove direct compilation of 6lowpan_iphc.c

Sucheta Chakraborty (8):
      qlcnic: Disable DCB operations from SR-IOV VFs.
      qlcnic: Issue INIT_NIC command only once.
      qlcnic: Refactor initialize nic code path.
      qlcnic: Restrict VF from configuring any VLAN mode.
      qlcnic: Enable VF flood bit on PF.
      qlcnic: Turn on promiscous mode for SRIOV PF.
      qlcnic: Do MAC learning for SRIOV PF.
      qlcnic: Use bool for rx_mac_learn.

Sujith Manoharan (92):
      ath9k: Add WB335 PCI IDs
      ath9k: Identify Killer Wireless cards
      ath9k: Fix TX99 config option usage
      ath9k: Fix wow.c compilation
      ath9k: Add a config option for WoW
      ath9k: Use CONFIG_ATH9K_WOW
      ath9k: Add an initialization routine for WoW
      ath9k: Add SERDES initvals for AR9462 2.1
      ath9k: Remove unused AR9462 2.0 initvals
      ath9k: Remove pcieSerDesWrite
      ath9k: Apply CUS227 specific TX gain values
      ath9k: Update MAINTAINERS
      ath9k: Separate routines for PCOEM and SoC calibration
      ath9k: Remove RTT/MCI code from SoC calibration
      ath9k: Remove unnecessary check
      ath9k: Fix Carrier Leak calibration for SoC chips
      ath9k: Fix TX IQ calibration for SoC chips
      ath9k: Cleanup IQ calibration for PCOEM chips
      ath9k: Add initvals for AR9565 1.1
      ath9k: Add version macros for AR9565 1.1
      ath9k: Attach INI arrays for AR9565 v1.1
      ath9k: Remove duplicate initvals for AR9462 v2.1
      ath9k: Update initvals for AR9300 v2.2
      ath9k: Update initvals for AR9580 v1.0
      ath9k: Update AR9340 initvals
      ath9k: Fix initvals for freq 2484
      Bluetooth: ath3k: Add support for another AR3012 card
      Bluetooth: ath3k: Add support for a new AR3012 device
      ath9k: Add initval arrays for DFS channels
      ath9k: Initialize baseband for DFS channels
      ath9k: Update mac_postamble for AR9003 family
      ath9k: Remove AR955x INI duplicates
      ath9k: Update AR9331 v1.1 initvals
      ath9k: Update AR9331 v1.2 initvals
      ath9k: Use a separate TX gain table for WZR-HP-G450H
      ath9k: Update high power gain table for AR9300
      ath9k: Identify duplicate AR9485 initvals
      ath9k: Identify duplicate AR9462 v2.0 initvals
      ath9k: Identify duplicate AR9565 v1.0 initvals
      ath9k: Fix regulatory compliance
      ath9k: Remove AR9330 v1.0 macro as it's not supported
      ath9k: Enable manual peak calibration for AR9331 v1.1
      ath9k: Fix internal regulator for AR955x
      ath9k: Apply tuning caps for AR9330 and AR9485
      ath9k: Cleanup spectral scan code
      ath9k: Cleanup ath9k.h
      ath9k: Remove unneeded ref. count initialization
      ath9k: Initialize "switchcomspdt" eeprom field explicitly
      ath9k: Update BaseExtension_1 eeprom structure
      ath9k: Fix regulatory compliance
      ath9k: Add a delay between RTC reset/clear for AR9003
      ath9k: Fix RTC reset delay
      ath9k: Use a subroutine for the AR9330 reset WAR
      ath9k: Fix max AMPDU size calculation
      ath9k: Register supported HW hang checks
      ath9k: Add HW callbacks for MAC/BB hang checks
      ath9k: Fix MAC HW hang check for AR9003
      ath9k: Fix PHY restart workaround
      ath9k: Fix baseband watchdog interrupts
      ath9k: Identify baseband watchdog signatures
      ath9k: Fix baseband watchdog reset
      ath9k: Remove RX Poll
      ath9k: Process BB watchdog events in the tasklet
      ath9k: Fix "cc_lock" usage
      ath9k: Remove unused functions
      ath9k: Move private HW callbacks to hw-ops.h
      ath9k: Handle unsupported MAC versions early
      ath9k: Cleanup __ath9k_hw_init()
      ath9k: Fix AR9100 chip power-on
      ath9k: Remove unused config option ack_6mb
      ath9k: Fix interrupt statistics
      ath9k: Add version/revision macros for QCA9531
      ath9k: Assign macVersion for QCA9531
      ath9k: Add QCA953x initvals
      ath9k: Initialize QCA953x INI arrays
      ath9k: Add hardware support for QCA9531
      ath9k: Fix AR955x RX sensitivity
      ath9k: Fix regulatory compliance
      ath9k: Update WB335 PCI IDs
      ath9k: Use correct channel for RX packets
      ath9k: Disable cross-band FCC
      ath9k: Add an option for station statistics
      ath9k: Show only active TIDs in node_aggr
      ath9k: Use a separate debugfs file for PHY errors
      ath9k: Add a debugfs file "node_recv"
      ath9k: Remove debug print in ISR
      ath9k: Process GTT interrupts
      ath9k: Fix error reported by smatch
      ath9k: Fix IQ calibration
      ath9k: Fix possible overflow condition
      ath9k: Fix code mistake
      ath9k: Fix RX interrupt mitigation

Suresh Reddy (5):
      be2net: fix incorrect setting of cmd_privileges for VFs
      be2net: Remove "10Gbps" from driver description string
      be2net: do not use frag index in the RX-compl entry
      be2net: use GET_MAC_LIST cmd to query mac-address from a pmac-id
      be2net: cleanup wake-on-lan code

Szymon Janc (2):
      NFC: llcp: Fix possible memory leak while sending I frames
      NFC: llcp: Use default MIU if none was specified on connect

Tedd Ho-Jeong An (2):
      Bluetooth: Add support for Intel Bluetooth device [8087:0a2a]
      Bluetooth: Enable autosuspend for Intel Bluetooth device

Terry Lam (2):
      net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc
      HHF qdisc: fix jiffies-time conversion.

Thierry Escande (5):
      NFC: digital: Add a note about asynchronous functions
      NFC: digital: Fix incorrect use of ERR_PTR and PTR_ERR macros
      NFC: digital: Use NFC_NFCID3_MAXSIZE from nfc.h
      NFC: digital: Set current target active on activate_target() call
      NFC: digital: Set rf tech and crc functions when receiving a PSL_REQ

Thomas Graf (9):
      genl: Add genlmsg_new_unicast() for unicast message allocation
      netlink: Avoid netlink mmap alloc if msg size exceeds frame size
      openvswitch: Enable memory mapped Netlink i/o
      net: Export skb_zerocopy() to zerocopy from one skb to another
      openvswitch: Allow user space to announce ability to accept unaligned Netlink messages
      openvswitch: Drop user features if old user space attempted to create datapath
      openvswitch: Pass datapath into userspace queue functions
      openvswitch: Use skb_zerocopy() for upcall
      openvswitch: Compute checksum in skb_gso_segment() if needed

Thomas Haller (2):
      ipv6 addrconf: add IFA_F_NOPREFIXROUTE flag to suppress creation of IP6 routes
      ipv6 addrconf: don't cleanup prefix route for IFA_F_NOPREFIXROUTE

Thomas Pedersen (9):
      mac80211: consolidate calls to plink_frame_tx
      mac80211: factor peering frame processing into own function
      mac80211: consolidate rcu unlocks in plink frame rx
      mac80211: assign sta plid early
      mac80211: factor out peering FSM
      mac80211: factor out plink event gathering
      mac80211: clean up mesh local link ID generation
      mac80211: update adjusting TBTT bit in beacon
      mac80211: sync dtim_count to TSF

Tom Herbert (22):
      net: Change skb_get_rxhash to skb_get_hash
      net: Add utility functions to clear rxhash
      net: Add function to set the rxhash
      net: Add utility function to copy skb hash
      net: bnx2 calls skb_set_hash
      net: bnx2x calls skb_set_hash
      net: cxgb4 calls skb_set_hash
      net: cisco-enic calls skb_set_hash
      net: emulex-benet calls skb_set_hash
      net: sky2 calls skb_set_hash
      net: mlx4 calls skb_set_hash
      net: vxge calls skb_set_hash
      net: sfc calls skb_set_hash
      net: sun-niu calls skb_set_hash
      net: vmxnet3 calls skb_set_hash
      bnx2x: cleanup skb_set_hash
      net: Allow setting sock flow hash without a sock
      tun: Add support for RFS on tun flows
      ipv4: Cache dst in tunnels
      ipv4: Use percpu Cache route in IP tunnels
      net: Add skb_get_hash_raw
      net: Check skb->rxhash in gro_receive

Tomasz Bursztyka (1):
      netfilter: nf_tables: Expose the table usage counter via netlink

Toshiaki Makita (1):
      bridge: Remove unnecessary vlan_put_tag in br_handle_vlan

Ujjal Roy (9):
      mwifiex: use little-endian variables in firmware structures
      mwifiex: fix rx_pending count imbalance
      mwifiex: correct RX byte count statistics
      mwifiex: correct TX byte count statistics
      mwifiex: update statistics for bridged packets on AP interface
      mwifiex: do not flood kmsg/dmesg with USB debug messages
      cfg80211: fix wext-compat for getting retry value
      cfg80211: add sanity check for retry limit in wext-compat
      mwifiex: export threshold value and retry limit to cfg80211

Ursula Braun (1):
      netiucv: improve state checking in conn_action_txdone

Valentina Giusti (1):
      netfilter: nfnetlink_queue: enable UID/GID socket info retrieval

Vasu Dev (1):
      i40e: add header file flag _I40E_TXRX_H_

Vasundhara Volam (5):
      be2net: Use MCC_CREATE_EXT_V1 cmd for Skyhawk-R
      be2net: don't set "pport" field when querying "pvid"
      be2net: Log the profile-id used by FW during driver initialization
      be2net: do not call be_set/get_fw_log_level() on Skyhawk-R
      be2net: ignore mac-addr set call for an already programmed mac-addr

Veaceslav Falico (13):
      bonding: fix kstrtou8() return value verification in num_peer_notif
      bonding: clean up style for bond_3ad.c
      bonding: convert 3ad to use pr_warn instead of pr_warning
      bonding: remove dead code from 3ad
      net: make dev_set_mtu() honor notification return code
      bonding: fix bond_3ad_set_carrier() RCU usage
      bonding: fix __get_first_agg RCU usage
      bonding: fix __get_active_agg() RCU logic
      net: add sysfs helpers for netdev_adjacent logic
      net: rename sysfs symlinks on device name change
      net: add NETDEV_PRECHANGEMTU to notify before mtu change happens
      team: block mtu change before it happens via NETDEV_PRECHANGEMTU
      bonding: handle slave's name change with primary_slave logic

Vijay Subramanian (1):
      net: pkt_sched: PIE AQM scheme

Vince Bridgers (3):
      stmmac: Add vlan rx for better GRO performance.
      dts: Add a binding for Synopsys emac max-frame-size
      stmmac: Fix kernel crashes for jumbo frames

Vlad Yasevich (3):
      macvtap: Add support of packet capture on macvtap device.
      macvlan: Remove custom recieve and forward handlers
      net: Correctly sync addresses from multiple sources to single device

Vladimir Kondratiev (4):
      wil6210: interrupt moderation
      wil6210: Fix IP version indication for Tx csum offload
      wil6210: prefetch head of packet
      wil6210: correct #include for prefetch()

WANG Cong (21):
      net_sched: remove get_stats from tc_action_ops
      net_sched: act: use standard struct list_head
      net_sched: cls: refactor out struct tcf_ext_map
      net_sched: init struct tcf_hashinfo at register time
      net_sched: convert tcf_hashinfo to hlist and use spinlock
      net_sched: convert tc_action_ops to use struct list_head
      net_sched: convert tcf_proto_ops to use struct list_head
      net_sched: fix a regression in tc actions
      net_sched: act: move idx_gen into struct tcf_hashinfo
      net_sched: act: clean up notification functions
      net_sched: add struct net pointer to tcf_proto_ops->dump
      net_sched: optimize tcf_match_indev()
      net_sched: avoid casting void pointer
      net_sched: act: remove struct tcf_act_hdr
      bridge: move br_net_exit() to br.c
      ipv4: register igmp_notifier even when !CONFIG_PROC_FS
      net_sched: act: use tcf_hash_release() in net/sched/act_police.c
      net_sched: act: pick a different type for act_xt
      net_sched: act: remove capab from struct tc_action_ops
      net_sched: act: fetch hinfo from a->ops->hinfo
      net_sched: act: export tcf_hash_search() instead of tcf_hash_lookup()

Wei Yongjun (14):
      ath10k: fix possible memory leak in ath10k_pci_probe()
      Bluetooth: remove unused including <linux/version.h>
      Bluetooth: fix return value check
      net/hsr: using kfree_rcu() to simplify the code
      sfc: fix sparse non static symbol warning
      ath9k: fix sparse non static symbol warning
      i40e: using for_each_set_bit to simplify the code
      openvswitch: remove duplicated include from flow_table.c
      net/mlx4_en: fix error return code in mlx4_en_get_qp()
      openvswitch: Use kmem_cache_free() instead of kfree()
      ip_tunnel: fix sparse non static symbol warning
      gre_offload: fix sparse non static symbol warning
      ixgbevf: use pci drvdata correctly in ixgbevf_suspend()
      net_sched: fix error return code in fw_change_attrs()

Weilong Chen (24):
      mac80211: fix checkpatch errors
      mac802154: fix following checkpath.pl warning Prefer pr_warn(... to pr_warning(...
      rose: cleanup checkpatch errors,spaces required
      ipv4: do clean up with spaces
      ipv4: fix checkpatch error "space prohibited"
      ipv4: fix checkpatch error with foo * bar
      ipv4: fix all space errors in file igmp.c
      ipv4: ERROR: do not initialise globals to 0 or NULL
      ipv4: ERROR: code indent should use tabs where possible
      ipv4: ipv4: Cleanup the comments in tcp_yeah.c
      ipv6: cleanup for tcp_ipv6.c
      llc: "foo* bar" should be "foo *bar"
      ieee802154: space prohibited before that close parenthesis
      packet: fix "foo * bar" and "(foo*)" problems
      xfrm: checkpatch errors with space
      xfrm: checkpatch errors with foo * bar
      xfrm: checkpatch erros with space prohibited
      xfrm: fix checkpatch error
      xfrm: checkpatch erros with inline keyword position
      ipv4: spaces required around that '='
      ipv4: switch and case should be at the same indent
      net: fix "queues" uevent between network namespaces
      bonding: Don't allow bond devices to change network namespaces.
      team: Don't allow team devices to change network namespaces.

Wenliang Fan (1):
      drivers/net/wireless/hostap: Integer overflow

Yang Yingliang (16):
      net_sched: remove unnecessary parentheses while return
      net_sched: cls_bpf: use tabs to do indent
      net_sched: change "foo* bar" to "foo *bar"
      net_sched: add space around '>' and before '('
      net_sched: sfq: put sfq_unlink in a do - while loop
      net_sched: expand control flow of macro SKIP_NONLOCAL
      sch_htb: remove unnecessary NULL pointer judgment
      act_police: remove unnecessary null pointer check
      sch_cbq: remove unnecessary null pointer check
      sch_tbf: add TBF_BURST/TBF_PBURST attribute
      net_sched: replace pr_warning with pr_warn
      sch_htb: use /* comments
      sch_dsmark: use correct func name in print messages
      sch_netem: more precise length of packets
      sch_netem: support of 64bit rates
      sch_netem: replace magic numbers with enumerate

Yann Droneaud (2):
      net: handle error more gracefully in socketpair()
      6lowpan: add a license to 6lowpan_iphc module

Yegor Yefremov (1):
      8021q: update description

Yijing Wang (2):
      net/fddi: Replace local macro with PCI standard macro
      3c59x/net: Use dev_is_pci() instead of hardcoding

Ying Xue (22):
      tipc: eliminate redundant code with kfree_skb_list routine
      tipc: remove TIPC usage of field af_packet_priv in struct net_device
      tipc: relocate common functions from media to bearer
      tipc: eliminate code duplication in media layer
      tipc: remove unused 'blocked' flag from tipc_link struct
      tipc: introduce new spinlock to protect struct link_req
      net: xfrm: xfrm_policy: silence compiler warning
      Drivers: Staging: cxt1e1: use __dev_get_name instead of dev_get_name to find interfaces
      bonding: use __dev_get_by_name instead of dev_get_by_name to find interface
      eql: use __dev_get_by_name instead of dev_get_by_name to find interface
      dcb: use __dev_get_by_name instead of dev_get_by_name to find interface
      decnet: use __dev_get_by_index instead of dev_get_by_index to find interface
      vxlan: use __dev_get_by_index instead of dev_get_by_index to find interface
      batman-adv: use __dev_get_by_index instead of dev_get_by_index to find interface
      caif: __dev_get_by_index instead of dev_get_by_index to find interface
      can: use __dev_get_by_index instead of dev_get_by_index to find interface
      net: nl80211: __dev_get_by_index instead of dev_get_by_index to find interface
      tipc: standardize connect routine
      tipc: standardize accept routine
      tipc: standardize sendmsg routine of connectionless socket
      tipc: standardize sendmsg routine of connected socket
      tipc: standardize recvmsg routine

Yogesh Ashok Powar (1):
      mwifiex: add USB8897 support

Yuval Mintz (7):
      bnx2x: Add support for Multi-Function UNDI
      bnx2x: Add AER support (missing bits)
      bnx2x: add Big-Endian ethtool comment
      bnx2x: no error when RSS configuration fails
      bnx2x: Add num of VFs to Management statistics
      bnx2x: add VF Multicast filters support
      bnx2x: Correct default Tx switching behaviour

ZHAO Gang (1):
      b43: fix the wrong assignment of status.freq in b43_rx()

Zhi Yong Wu (10):
      vhost: remove the dead branch
      macvtap: remove the dead branch
      macvtap: remove unused parameter in macvtap_do_read()
      tun: remove unused parameter in tun_do_read()
      macvtap: remove useless codes in macvtap_aio_read() and macvtap_recvmsg()
      tun: remove useless codes in tun_chr_aio_read() and tun_recvmsg()
      net, rps: fix build failure when CONFIG_RPS isn't set
      net, rps: fix the comment of net_rps_action_and_irq_enable()
      net, sch: fix the typo in register_qdisc()
      tun, rfs: fix the incorrect hash value

damuzi000 (1):
      net: stmmac: fix NULL pointer dereference in stmmac_get_tx_hwtstamp

dingtianhong (63):
      bonding: remove the no effect lock for bond_select_active_slave()
      bonding: rebuild the lock use for bond_mii_monitor()
      bonding: rebuild the lock use for bond_alb_monitor()
      bonding: rebuild the lock use for bond_loadbalance_arp_mon()
      bonding: create bond_first_slave_rcu()
      bonding: rebuild the lock use for bond_activebackup_arp_mon()
      bonding: remove unwanted lock for bond enslave and release
      bonding: add RCU for bond_3ad_state_machine_handler()
      bonding: remove unwanted lock for bond_option_active_slave_set()
      bonding: remove unwanted lock for bond_store_primaryxxx()
      bonding: rebuild the bond_resend_igmp_join_requests_delayed()
      net: freescale: remove unused compare_addr()
      net: pcnet: slight optimization of addr compare
      net: atl1: slight optimization of addr compare
      hamradio: slight optimization of addr compare
      ppp: slight optimization of addr compare
      batman-adv: use batadv_compare_eth for concise
      zd1211rw: slight optimization of addr compare
      ozwpan: slight optimization of addr compare
      infiniband: slight optimization of addr compare
      mac8011: slight optimization of addr compare
      atm: slight optimization of addr compare
      isdn: slight optimization of addr compare
      media: dvb_core: slight optimization of addr compare
      hostap: slight optimization of addr compare
      cw1200: slight optimization of addr compare
      ipw2x00: slight optimization of addr compare
      mwifiex: slight optimization of addr compare
      rtlwifi: slight optimization of addr compare
      wireless: slight optimization of addr compare
      bonding: add option lp_interval for loading module
      bonding: ust micro BOND_NO_USE_ARP to simplify the mode check
      bonding: update Documentation/networking/bonding.txt for option lp_interval
      net: 3com: slight optimization of addr compare
      net: bnx2x: slight optimization of addr compare
      net: cxgb3: slight optimization of addr compare
      net: enic: slight optimization of addr compare
      net: benet: slight optimization of addr compare
      net: igbvf: slight optimization of addr compare
      net: ixgbe: slight optimization of addr compare
      net: mlx4: slight optimization of addr compare
      net: ksz884x: slight optimization of addr compare
      net: vxge: slight optimization of addr compare
      net: packetengines: slight optimization of addr
      net: netxen: slight optimization of addr compare
      net: qlcnic: slight optimization of addr compare
      net: renesas: slight optimization of addr compare
      net: seeq: slight optimization of addr compare
      net: sun: optimization of addr compare
      net: ti: slight optimization of addr compare
      net: fddi: slight optimization of addr compare
      net: plip: slight optimization of addr compare
      bonding: use ether_addr_equal_unaligned for bond addr compare
      bonding: slight optimization for bond_3ad_xmit_xor()
      bonding: slight optimization for bond_alb_xmit()
      bonding: slight optimizztion for bond_slave_override()
      bonding: remove unwanted return value for bond_dev_queue_xmit()
      bonding: remove the return value for bond_3ad_bind_slave()
      bonding: use ether_addr_equal_64bits to instead of ether_addr_equal
      net: qlcnic: fix warning for incorrect type in argument
      net: 3com: fix warning for incorrect type in argument
      bonding: clean the primary slave if there is no slave matching new primary
      bonding: update bonding.txt for primary description

ethan.zhao (2):
      ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and cleanup const 63
      ixgbe: set driver_max_VFs should be done before enabling SRIOV

fan.du (1):
      netfilter: add IPv4/6 IPComp extension match support

hayeswang (13):
      r8152: move rtl8152_unload and ocp_reg_write
      r8152: modify the method of accessing PHY
      r8152: change some definitions
      r8152: add rtl_ops
      r8152: split rtl8152_enable
      r8152: support RTL8153
      r8152: fix the wrong return value
      r8152: replace some tabs with spaces
      r8152: move the actions of saving the information of the device
      r8152: replace the return value of rtl_ops_init
      r8152: change the descriptor
      r8152: fix the warnings and a error from checkpatch.pl
      r8152: ecm and vendor modes coexist

sfeldma@cumulusnetworks.com (27):
      bonding: add miimon netlink support
      bonding: add updelay netlink support
      bonding: add downdelay netlink support
      bonding: add use_carrier netlink support
      bonding: add arp_interval netlink support
      bonding: add arp_ip_target netlink support
      bonding: add arp_validate netlink support
      bonding: add arp_all_targets netlink support
      bonding: add primary attribute netlink support
      bonding: add primary_select attribute netlink support
      bonding: add fail_over_mac attribute netlink support
      bonding: add xmit_hash_policy attribute netlink support
      bonding: add resend_igmp attribute netlink support
      bonding: add num_grat_arp attribute netlink support
      bonding: add all_slaves_active attribute netlink support
      bonding: add min_links attribute netlink support
      bonding: add lp_interval attribute netlink support
      bonding: add packets_per_slave attribute netlink support
      sctp: fix missing include file
      bonding: add lacp_rate attribute netlink support
      bonding: add ad_select attribute netlink support
      bonding: add ad_info attribute netlink support
      bonding: fix netlink msg size
      bonding: add bounds checking for tbl params
      bridge: use DEVICE_ATTR_xx macros
      bonding: add sysfs /slave dir for bond slave devices.
      bonding: add netlink attributes to slave link dev

stephen hemminger (45):
      tun: spelling fixes
      net: more spelling fixes
      virtio_net: remove unused parameter to send_command
      virtio_net: spelling fixes
      netconf: add proxy-arp support
      net: remove dead code for add/del multiple
      bnad: make local variable static
      netconf: rename PROXY_ARP to NEIGH_PROXY
      netconf: add support for IPv6 proxy_ndp
      cxgb4: make functions static and remove dead code
      hhf: make qdisc ops static
      mdio: unused ethtool functions
      qlge: make local function static
      macvlan: make start_xmit local
      tcp: make local functions static
      bonding: make local function static
      lro: remove dead code
      stmicro: make local variables static
      netlink: cleanup rntl_af_register
      bonding: make more functions static
      netlink: cleanup tap related functions
      net: core functions cleanup
      ipv6: namespace cleanups
      sched action: make local function static
      sched classifier: make cgroup table local
      netfilter: ipset: remove unused code
      netfilter: nf_conntrack: remove dead code
      socket: cleanups
      llc: make lock static
      dccp: remove obsolete code
      dccp: make local variable static
      tipc: make local function static
      tipc: remove unused code
      bnx2x: namespace and dead code cleanups
      l2tp: make local functions static
      sctp: make sctp_addto_chunk_fixed local
      ipv6: addrconf spelling fixes
      tipc: spelling fixes
      bnx2x: fix sparse warning
      bnad: code cleanup
      vxge: make local functions static
      qlcnic: make local functions static
      qlcnic: remove unused code
      phy: cleanup 10g code
      bond: make slave_sysfs_ops static

tanxiaojun (7):
      fddi: cleanup unsigned to unsigned int/short
      bridge: spelling fixes
      bridge: remove unnecessary condition judgment
      bridge: remove unnecessary parentheses
      bridge: add space before '(/{', after ',', etc.
      bridge: change "foo* bar" to "foo *bar"
      bridge: change the position of '{' to the pre line

viresh kumar (2):
      net/ipv4: queue work on power efficient wq
      net/neighbour: queue work on power efficient wq

wangweidong (30):
      sctp: remove the duplicate initialize
      sctp: remove the else path
      sctp: convert sctp_peer_needs_update to boolean
      sctp: fix some comments in associola.c
      unix: convert printks to pr_<level>
      x25: convert printks to pr_<level>
      sctp: remove redundant null check on asoc
      tipc: remove unnecessary variables and conditions
      tipc: kill unnecessary goto's
      tipc: Use <linux/uaccess.h> instead of <asm/uaccess.h>
      tipc: change lock_sock order in connect()
      sctp: Reorder 'struc association' members to reduce its size
      sctp: remove casting from function calls through ops structure
      sctp: remove the never used 'return' and redundant 'break'
      sctp: fix checkpatch errors with space required or prohibited
      sctp: fix checkpatch errors with (foo*)|foo * bar|foo* bar
      sctp: fix checkpatch errors with indent
      sctp: fix checkpatch errors with open brace '{' and trailing statements
      sctp: fix checkpatch errors with //commen
      sctp: move skb_dst_set() a bit downwards in sctp_packet_transmit()
      tipc: make the code look more readable
      sctp: create helper function to enable|disable sackdelay
      sctp: remove the unnecessary assignment
      sctp: remove macros sctp_spin_[un]lock_irqrestore
      sctp: remove macros sctp_local_bh_{disable|enable}
      sctp: remove macros sctp_spin_[un]lock
      sctp: remove macros sctp_write_[un]_lock
      sctp: remove macros sctp_read_[un]lock
      sctp: remove macros sctp_{lock|release}_sock
      sctp: remove macros sctp_bh_[un]lock_sock

willy tarreau (11):
      net: mvneta: increase the 64-bit rx/tx stats out of the hot path
      net: mvneta: use per_cpu stats to fix an SMP lock up
      net: mvneta: do not schedule in mvneta_tx_timeout
      net: mvneta: add missing bit descriptions for interrupt masks and causes
      net: mvneta: replace Tx timer with a real interrupt
      net: mvneta: remove tests for impossible cases in the tx_done path
      net: mvneta: factor rx refilling code
      net: mvneta: simplify access to the rx descriptor status
      net: mvneta: prefetch next rx descriptor instead of current one
      net: mvneta: convert to build_skb()
      net: mvneta: implement rx_copybreak

 Documentation/ABI/testing/sysfs-class-net-mesh                     |    8 +
 Documentation/cgroups/net_cls.txt                                  |    5 +
 Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt |   27 +
 Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt    |   25 +
 Documentation/devicetree/bindings/net/davinci_emac.txt             |    4 +-
 Documentation/devicetree/bindings/net/phy.txt                      |    1 +
 Documentation/devicetree/bindings/net/stmmac.txt                   |    7 +-
 Documentation/networking/batman-adv.txt                            |    9 +-
 Documentation/networking/bonding.txt                               |   11 +-
 Documentation/networking/can.txt                                   |   94 +-
 Documentation/networking/filter.txt                                |  608 +++-
 Documentation/networking/i40evf.txt                                |   47 +
 Documentation/networking/ip-sysctl.txt                             |   59 +-
 Documentation/networking/ipsec.txt                                 |   38 +
 Documentation/networking/packet_mmap.txt                           |   48 +-
 Documentation/networking/phy.txt                                   |    3 +-
 Documentation/networking/pktgen.txt                                |   15 +
 Documentation/networking/regulatory.txt                            |    4 +-
 Documentation/networking/stmmac.txt                                |   12 +-
 Documentation/networking/timestamping.txt                          |    9 +-
 Documentation/networking/timestamping/.gitignore                   |    1 +
 Documentation/networking/timestamping/Makefile                     |    5 +-
 Documentation/networking/timestamping/hwtstamp_config.c            |  134 +
 Documentation/s390/qeth.txt                                        |   50 +
 Documentation/unaligned-memory-access.txt                          |   28 +-
 MAINTAINERS                                                        |   33 +-
 arch/alpha/include/asm/Kbuild                                      |    1 +
 arch/alpha/include/uapi/asm/socket.h                               |    2 +
 arch/arc/include/asm/Kbuild                                        |    1 +
 arch/arm/include/asm/Kbuild                                        |    1 +
 arch/arm64/include/asm/Kbuild                                      |    1 +
 arch/avr32/include/asm/Kbuild                                      |    1 +
 arch/avr32/include/uapi/asm/socket.h                               |    2 +
 arch/blackfin/include/asm/Kbuild                                   |    1 +
 arch/blackfin/mach-bf609/boards/ezkit.c                            |    2 +-
 arch/c6x/include/asm/Kbuild                                        |    1 +
 arch/cris/include/asm/Kbuild                                       |    1 +
 arch/cris/include/uapi/asm/socket.h                                |    2 +
 arch/frv/include/asm/Kbuild                                        |    1 +
 arch/frv/include/uapi/asm/socket.h                                 |    2 +
 arch/hexagon/include/asm/Kbuild                                    |    1 +
 arch/ia64/include/asm/Kbuild                                       |    3 +-
 arch/ia64/include/uapi/asm/socket.h                                |    2 +
 arch/m32r/include/asm/Kbuild                                       |    1 +
 arch/m32r/include/uapi/asm/socket.h                                |    2 +
 arch/m68k/include/asm/Kbuild                                       |    1 +
 arch/metag/include/asm/Kbuild                                      |    1 +
 arch/microblaze/include/asm/Kbuild                                 |    1 +
 arch/mips/bcm47xx/setup.c                                          |   10 +
 arch/mips/include/asm/Kbuild                                       |    1 +
 arch/mips/include/uapi/asm/socket.h                                |    2 +
 arch/mn10300/include/asm/Kbuild                                    |    1 +
 arch/mn10300/include/uapi/asm/socket.h                             |    2 +
 arch/openrisc/include/asm/Kbuild                                   |    1 +
 arch/parisc/include/asm/Kbuild                                     |    1 +
 arch/parisc/include/uapi/asm/socket.h                              |    2 +
 arch/powerpc/include/asm/Kbuild                                    |    3 +-
 arch/powerpc/include/uapi/asm/socket.h                             |    2 +
 arch/s390/include/asm/Kbuild                                       |    1 +
 arch/s390/include/asm/css_chars.h                                  |    2 +
 arch/s390/include/asm/qdio.h                                       |   33 +
 arch/s390/include/uapi/asm/socket.h                                |    2 +
 arch/score/include/asm/Kbuild                                      |    2 +
 arch/sh/include/asm/Kbuild                                         |    1 +
 arch/sparc/include/asm/Kbuild                                      |    1 +
 arch/sparc/include/uapi/asm/socket.h                               |    2 +
 arch/tile/include/asm/Kbuild                                       |    1 +
 arch/um/include/asm/Kbuild                                         |    1 +
 arch/unicore32/include/asm/Kbuild                                  |    1 +
 arch/x86/include/asm/hash.h                                        |    7 +
 arch/x86/lib/Makefile                                              |    2 +-
 arch/x86/lib/hash.c                                                |   88 +
 arch/xtensa/include/asm/Kbuild                                     |    1 +
 arch/xtensa/include/uapi/asm/socket.h                              |    2 +
 drivers/atm/he.c                                                   |    1 -
 drivers/atm/nicstar.c                                              |    4 +-
 drivers/atm/solos-pci.c                                            |    2 -
 drivers/bcma/bcma_private.h                                        |    2 -
 drivers/bcma/driver_chipcommon_sflash.c                            |    6 +-
 drivers/bcma/host_pci.c                                            |    3 +-
 drivers/bcma/main.c                                                |   14 +-
 drivers/bluetooth/ath3k.c                                          |    4 +
 drivers/bluetooth/btmrvl_drv.h                                     |   25 +-
 drivers/bluetooth/btmrvl_main.c                                    |  130 +-
 drivers/bluetooth/btmrvl_sdio.c                                    |    9 +-
 drivers/bluetooth/btmrvl_sdio.h                                    |    2 -
 drivers/bluetooth/btsdio.c                                         |    6 +-
 drivers/bluetooth/btusb.c                                          |   53 +-
 drivers/bluetooth/hci_vhci.c                                       |   29 +-
 drivers/infiniband/core/cma.c                                      |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c                                 |    3 +-
 drivers/isdn/i4l/isdn_net.c                                        |    4 +-
 drivers/isdn/mISDN/socket.c                                        |    5 +-
 drivers/isdn/sc/event.c                                            |    2 +-
 drivers/media/dvb-core/dvb_net.c                                   |   10 +-
 drivers/net/Kconfig                                                |    1 +
 drivers/net/Space.c                                                |   29 +-
 drivers/net/arcnet/com20020_cs.c                                   |    1 -
 drivers/net/bonding/Makefile                                       |    2 +-
 drivers/net/bonding/bond_3ad.c                                     |  900 +++---
 drivers/net/bonding/bond_3ad.h                                     |    2 +-
 drivers/net/bonding/bond_alb.c                                     |   49 +-
 drivers/net/bonding/bond_alb.h                                     |    3 +-
 drivers/net/bonding/bond_main.c                                    |  569 ++--
 drivers/net/bonding/bond_netlink.c                                 |  464 ++-
 drivers/net/bonding/bond_options.c                                 | 1191 +++++++-
 drivers/net/bonding/bond_options.h                                 |  170 ++
 drivers/net/bonding/bond_procfs.c                                  |   37 +-
 drivers/net/bonding/bond_sysfs.c                                   |  896 +-----
 drivers/net/bonding/bond_sysfs_slave.c                             |  144 +
 drivers/net/bonding/bonding.h                                      |   38 +-
 drivers/net/caif/caif_spi_slave.c                                  |    1 -
 drivers/net/can/Kconfig                                            |    4 +-
 drivers/net/can/at91_can.c                                         |    1 -
 drivers/net/can/bfin_can.c                                         |    1 -
 drivers/net/can/c_can/c_can.c                                      |   22 +-
 drivers/net/can/dev.c                                              |    3 +-
 drivers/net/can/janz-ican3.c                                       |    1 -
 drivers/net/can/mcp251x.c                                          |  121 +-
 drivers/net/can/mscan/mpc5xxx_can.c                                |    3 +-
 drivers/net/can/mscan/mscan.c                                      |    3 +-
 drivers/net/can/mscan/mscan.h                                      |    3 +-
 drivers/net/can/pch_can.c                                          |    4 +-
 drivers/net/can/sja1000/ems_pci.c                                  |    3 +-
 drivers/net/can/sja1000/kvaser_pci.c                               |    3 +-
 drivers/net/can/sja1000/plx_pci.c                                  |   26 +-
 drivers/net/can/sja1000/sja1000_isa.c                              |    3 +-
 drivers/net/can/sja1000/sja1000_of_platform.c                      |    3 +-
 drivers/net/can/sja1000/sja1000_platform.c                         |    3 +-
 drivers/net/can/slcan.c                                            |    4 +-
 drivers/net/can/softing/softing_cs.c                               |    3 +-
 drivers/net/can/softing/softing_fw.c                               |    3 +-
 drivers/net/can/softing/softing_main.c                             |    4 +-
 drivers/net/can/ti_hecc.c                                          |   11 +-
 drivers/net/can/usb/ems_usb.c                                      |    1 -
 drivers/net/can/usb/esd_usb2.c                                     |    1 -
 drivers/net/can/usb/kvaser_usb.c                                   |    1 -
 drivers/net/can/usb/usb_8dev.c                                     |    1 -
 drivers/net/eql.c                                                  |   95 +-
 drivers/net/ethernet/3com/3c509.c                                  |    3 +-
 drivers/net/ethernet/3com/3c574_cs.c                               |    1 -
 drivers/net/ethernet/3com/3c589_cs.c                               |    1 -
 drivers/net/ethernet/3com/3c59x.c                                  |    6 +-
 drivers/net/ethernet/8390/8390.h                                   |    7 +-
 drivers/net/ethernet/8390/apne.c                                   |   62 +-
 drivers/net/ethernet/8390/ax88796.c                                |   23 +-
 drivers/net/ethernet/8390/axnet_cs.c                               |  120 +-
 drivers/net/ethernet/8390/etherh.c                                 |   53 +-
 drivers/net/ethernet/8390/hydra.c                                  |   11 +-
 drivers/net/ethernet/8390/lib8390.c                                |   77 +-
 drivers/net/ethernet/8390/mac8390.c                                |   19 +-
 drivers/net/ethernet/8390/mcf8390.c                                |    9 +-
 drivers/net/ethernet/8390/ne.c                                     |   96 +-
 drivers/net/ethernet/8390/ne2k-pci.c                               |   54 +-
 drivers/net/ethernet/8390/pcnet_cs.c                               |   63 +-
 drivers/net/ethernet/8390/smc-ultra.c                              |   48 +-
 drivers/net/ethernet/8390/stnic.c                                  |   28 +-
 drivers/net/ethernet/8390/wd.c                                     |   42 +-
 drivers/net/ethernet/8390/zorro8390.c                              |   22 +-
 drivers/net/ethernet/adi/bfin_mac.c                                |   22 +-
 drivers/net/ethernet/aeroflex/greth.c                              |    3 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c                        |    1 -
 drivers/net/ethernet/alteon/acenic.c                               |    1 -
 drivers/net/ethernet/amd/7990.c                                    |  837 +++---
 drivers/net/ethernet/amd/7990.h                                    |  268 +-
 drivers/net/ethernet/amd/amd8111e.c                                |    5 +-
 drivers/net/ethernet/amd/amd8111e.h                                |    6 +-
 drivers/net/ethernet/amd/au1000_eth.c                              |    4 +-
 drivers/net/ethernet/amd/au1000_eth.h                              |    3 +-
 drivers/net/ethernet/amd/hplance.c                                 |   96 +-
 drivers/net/ethernet/amd/mvme147.c                                 |   36 +-
 drivers/net/ethernet/amd/nmclan_cs.c                               |    1 -
 drivers/net/ethernet/amd/pcnet32.c                                 |    2 +-
 drivers/net/ethernet/amd/sunlance.c                                |    1 -
 drivers/net/ethernet/arc/emac.h                                    |    2 -
 drivers/net/ethernet/arc/emac_main.c                               |   20 +-
 drivers/net/ethernet/atheros/alx/alx.h                             |    3 +
 drivers/net/ethernet/atheros/alx/ethtool.c                         |  101 +
 drivers/net/ethernet/atheros/alx/hw.c                              |   58 +
 drivers/net/ethernet/atheros/alx/hw.h                              |   71 +
 drivers/net/ethernet/atheros/alx/main.c                            |   50 +
 drivers/net/ethernet/atheros/alx/reg.h                             |   52 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h                         |    1 -
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c                    |   31 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h                         |    1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c                    |   30 +-
 drivers/net/ethernet/atheros/atlx/atl1.c                           |   46 +-
 drivers/net/ethernet/atheros/atlx/atl1.h                           |    1 +
 drivers/net/ethernet/broadcom/Kconfig                              |    1 +
 drivers/net/ethernet/broadcom/b44.c                                |  250 +-
 drivers/net/ethernet/broadcom/b44.h                                |   15 +-
 drivers/net/ethernet/broadcom/bgmac.c                              |  364 ++-
 drivers/net/ethernet/broadcom/bgmac.h                              |   94 +-
 drivers/net/ethernet/broadcom/bnx2.c                               |   60 +-
 drivers/net/ethernet/broadcom/bnx2.h                               |   10 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                        |    8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                    |  101 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                    |  124 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c                |    6 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c                   |   66 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h                   |   10 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                   |  209 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h                    |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c                     |  277 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h                     |   17 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c                  |  181 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h                  |   15 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c                   |   39 +-
 drivers/net/ethernet/broadcom/cnic.c                               |    1 +
 drivers/net/ethernet/broadcom/cnic.h                               |    2 +
 drivers/net/ethernet/broadcom/cnic_if.h                            |    4 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c                         |    4 +-
 drivers/net/ethernet/broadcom/tg3.c                                |  230 +-
 drivers/net/ethernet/broadcom/tg3.h                                |   11 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c                         |  625 +++-
 drivers/net/ethernet/brocade/bna/bfa_ioc.h                         |    8 +
 drivers/net/ethernet/brocade/bna/bfa_ioc_ct.c                      |   40 +
 drivers/net/ethernet/brocade/bna/bfi.h                             |   33 +-
 drivers/net/ethernet/brocade/bna/bfi_enet.h                        |    3 +-
 drivers/net/ethernet/brocade/bna/bna.h                             |   24 +-
 drivers/net/ethernet/brocade/bna/bna_enet.c                        |   58 +-
 drivers/net/ethernet/brocade/bna/bna_hw_defs.h                     |    4 +
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c                       |  251 +-
 drivers/net/ethernet/brocade/bna/bna_types.h                       |   57 +-
 drivers/net/ethernet/brocade/bna/bnad.c                            |  559 +++-
 drivers/net/ethernet/brocade/bna/bnad.h                            |   26 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c                    |    1 +
 drivers/net/ethernet/brocade/bna/cna.h                             |    4 +-
 drivers/net/ethernet/cadence/macb.c                                |  126 +-
 drivers/net/ethernet/cadence/macb.h                                |    1 +
 drivers/net/ethernet/calxeda/xgmac.c                               |    1 -
 drivers/net/ethernet/chelsio/cxgb/common.h                         |    4 +-
 drivers/net/ethernet/chelsio/cxgb/cphy.h                           |    3 +-
 drivers/net/ethernet/chelsio/cxgb/cpl5_cmd.h                       |    3 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                          |    4 +-
 drivers/net/ethernet/chelsio/cxgb/elmer0.h                         |    3 +-
 drivers/net/ethernet/chelsio/cxgb/espi.c                           |    3 +-
 drivers/net/ethernet/chelsio/cxgb/espi.h                           |    3 +-
 drivers/net/ethernet/chelsio/cxgb/gmac.h                           |    3 +-
 drivers/net/ethernet/chelsio/cxgb/mv88x201x.c                      |    3 +-
 drivers/net/ethernet/chelsio/cxgb/pm3393.c                         |    3 +-
 drivers/net/ethernet/chelsio/cxgb/regs.h                           |    3 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c                            |    4 +-
 drivers/net/ethernet/chelsio/cxgb/sge.h                            |    3 +-
 drivers/net/ethernet/chelsio/cxgb/subr.c                           |    3 +-
 drivers/net/ethernet/chelsio/cxgb/suni1x10gexp_regs.h              |    3 +-
 drivers/net/ethernet/chelsio/cxgb3/common.h                        |    1 -
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c                 |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.c                           |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                         |   21 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                    |   35 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                           |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                         |  139 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h                 |    1 -
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c                     |    4 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c                           |    1 -
 drivers/net/ethernet/cisco/enic/enic_main.c                        |   11 +-
 drivers/net/ethernet/cisco/enic/enic_pp.c                          |    2 +-
 drivers/net/ethernet/davicom/dm9000.c                              |   24 +-
 drivers/net/ethernet/dec/tulip/eeprom.c                            |    1 -
 drivers/net/ethernet/dec/tulip/media.c                             |    3 +-
 drivers/net/ethernet/dec/tulip/uli526x.c                           |    6 -
 drivers/net/ethernet/dec/tulip/xircom_cb.c                         |    1 -
 drivers/net/ethernet/dlink/dl2k.h                                  |    1 -
 drivers/net/ethernet/dnet.c                                        |    1 -
 drivers/net/ethernet/emulex/benet/be.h                             |    7 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                        |  178 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h                        |   33 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c                     |   73 +-
 drivers/net/ethernet/emulex/benet/be_main.c                        |  164 +-
 drivers/net/ethernet/faraday/ftgmac100.c                           |    7 +-
 drivers/net/ethernet/freescale/fec.h                               |    3 +-
 drivers/net/ethernet/freescale/fec_main.c                          |    9 +-
 drivers/net/ethernet/freescale/fec_ptp.c                           |   17 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c              |    1 -
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c                   |    1 -
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c                   |    1 -
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c                   |    1 -
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c               |    1 -
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c                   |    1 -
 drivers/net/ethernet/freescale/fsl_pq_mdio.c                       |    1 -
 drivers/net/ethernet/freescale/gianfar.c                           |   23 +-
 drivers/net/ethernet/freescale/gianfar.h                           |    1 -
 drivers/net/ethernet/freescale/gianfar_ethtool.c                   |   99 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c                       |    3 +-
 drivers/net/ethernet/freescale/gianfar_sysfs.c                     |    1 -
 drivers/net/ethernet/freescale/ucc_geth.c                          |    5 -
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c                  |    1 -
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c                          |    1 -
 drivers/net/ethernet/i825xx/lasi_82596.c                           |    1 -
 drivers/net/ethernet/i825xx/lib82596.c                             |    1 -
 drivers/net/ethernet/i825xx/sni_82596.c                            |    1 -
 drivers/net/ethernet/ibm/emac/core.h                               |    1 -
 drivers/net/ethernet/ibm/ibmveth.c                                 |    3 +-
 drivers/net/ethernet/ibm/ibmveth.h                                 |    3 +-
 drivers/net/ethernet/icplus/ipg.h                                  |    1 -
 drivers/net/ethernet/intel/Kconfig                                 |   49 +-
 drivers/net/ethernet/intel/Makefile                                |    1 +
 drivers/net/ethernet/intel/e1000/e1000.h                           |    1 -
 drivers/net/ethernet/intel/e1000e/netdev.c                         |   14 +-
 drivers/net/ethernet/intel/i40e/Makefile                           |   10 +-
 drivers/net/ethernet/intel/i40e/i40e.h                             |  127 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c                      |  237 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.h                      |   21 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h                  |  136 +-
 drivers/net/ethernet/intel/i40e/i40e_alloc.h                       |    7 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c                      |  666 +++--
 drivers/net/ethernet/intel/i40e/i40e_dcb.c                         |  469 +++
 drivers/net/ethernet/intel/i40e/i40e_dcb.h                         |  107 +
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c                      |  316 ++
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c                     |  400 ++-
 drivers/net/ethernet/intel/i40e/i40e_diag.c                        |   23 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h                        |   15 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                     |  432 ++-
 drivers/net/ethernet/intel/i40e/i40e_hmc.c                         |   17 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.h                         |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c                     |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h                     |   11 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c                        | 1777 +++++++++---
 drivers/net/ethernet/intel/i40e/i40e_nvm.c                         |   77 +-
 drivers/net/ethernet/intel/i40e/i40e_osdep.h                       |    7 +-
 drivers/net/ethernet/intel/i40e/i40e_prototype.h                   |   53 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c                         |  662 +++++
 drivers/net/ethernet/intel/i40e/i40e_register.h                    |  170 +-
 drivers/net/ethernet/intel/i40e/i40e_status.h                      |    7 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                        |  195 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h                        |   64 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h                        |  152 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl.h                    |   11 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                 |  876 +++---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h                 |   11 +-
 drivers/net/ethernet/intel/i40evf/Makefile                         |   33 +
 drivers/net/ethernet/intel/i40evf/i40e_adminq.c                    |  927 ++++++
 drivers/net/ethernet/intel/i40evf/i40e_adminq.h                    |  106 +
 drivers/net/ethernet/intel/i40evf/i40e_adminq_cmd.h                | 2153 ++++++++++++++
 drivers/net/ethernet/intel/i40evf/i40e_alloc.h                     |   55 +
 drivers/net/ethernet/intel/i40evf/i40e_common.c                    |  254 ++
 drivers/net/ethernet/intel/i40evf/i40e_hmc.h                       |  238 ++
 drivers/net/ethernet/intel/i40evf/i40e_lan_hmc.h                   |  165 ++
 drivers/net/ethernet/intel/i40evf/i40e_osdep.h                     |   72 +
 drivers/net/ethernet/intel/i40evf/i40e_prototype.h                 |   84 +
 drivers/net/ethernet/intel/i40evf/i40e_register.h                  | 4667 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/i40evf/i40e_status.h                    |   97 +
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c                      | 1575 ++++++++++
 drivers/net/ethernet/intel/i40evf/i40e_txrx.h                      |  296 ++
 drivers/net/ethernet/intel/i40evf/i40e_type.h                      | 1152 ++++++++
 drivers/net/ethernet/intel/i40evf/i40e_virtchnl.h                  |  364 +++
 drivers/net/ethernet/intel/i40evf/i40evf.h                         |  321 ++
 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c                 |  390 +++
 drivers/net/ethernet/intel/i40evf/i40evf_main.c                    | 2353 +++++++++++++++
 drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c                |  772 +++++
 drivers/net/ethernet/intel/igb/e1000_82575.c                       |   89 +
 drivers/net/ethernet/intel/igb/e1000_defines.h                     |   16 +
 drivers/net/ethernet/intel/igb/e1000_hw.h                          |    3 +
 drivers/net/ethernet/intel/igb/igb.h                               |   28 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c                       |   10 +-
 drivers/net/ethernet/intel/igb/igb_hwmon.c                         |  108 +-
 drivers/net/ethernet/intel/igb/igb_main.c                          |  303 +-
 drivers/net/ethernet/intel/igbvf/netdev.c                          |    2 +-
 drivers/net/ethernet/intel/ixgb/ixgb.h                             |    1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                           |   21 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c                     |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h                    |   65 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c                   |  120 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                      |   82 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.c                       |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                       |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                     |   30 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h                     |    5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c                     |   84 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                      |   15 +-
 drivers/net/ethernet/intel/ixgbevf/defines.h                       |   18 +
 drivers/net/ethernet/intel/ixgbevf/ethtool.c                       |   76 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h                       |   96 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c                  | 1276 ++++----
 drivers/net/ethernet/korina.c                                      |    1 -
 drivers/net/ethernet/lantiq_etop.c                                 |    3 +-
 drivers/net/ethernet/marvell/Kconfig                               |    1 +
 drivers/net/ethernet/marvell/mv643xx_eth.c                         |   28 +-
 drivers/net/ethernet/marvell/mvmdio.c                              |    1 -
 drivers/net/ethernet/marvell/mvneta.c                              |  387 +--
 drivers/net/ethernet/marvell/pxa168_eth.c                          |   24 +-
 drivers/net/ethernet/marvell/sky2.c                                |    6 +-
 drivers/net/ethernet/mellanox/mlx4/Kconfig                         |    1 +
 drivers/net/ethernet/mellanox/mlx4/alloc.c                         |   12 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c                            |    5 +-
 drivers/net/ethernet/mellanox/mlx4/en_clock.c                      |  198 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c                         |   12 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                    |    3 +
 drivers/net/ethernet/mellanox/mlx4/en_main.c                       |    6 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                     |  142 +-
 drivers/net/ethernet/mellanox/mlx4/en_resources.c                  |    6 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                         |   30 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                         |   62 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c                            |    5 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                            |   93 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h                            |    2 +
 drivers/net/ethernet/mellanox/mlx4/main.c                          |  109 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                           |   45 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                          |   10 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                       |   19 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c                            |    3 +-
 drivers/net/ethernet/mellanox/mlx4/pd.c                            |    7 +-
 drivers/net/ethernet/mellanox/mlx4/port.c                          |   41 +
 drivers/net/ethernet/mellanox/mlx4/qp.c                            |    3 +-
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c              |  100 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c                           |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                      |    1 -
 drivers/net/ethernet/micrel/ks8695net.c                            |    1 -
 drivers/net/ethernet/micrel/ksz884x.c                              |   12 +-
 drivers/net/ethernet/moxa/moxart_ether.c                           |    1 -
 drivers/net/ethernet/natsemi/jazzsonic.c                           |    1 -
 drivers/net/ethernet/natsemi/macsonic.c                            |    1 -
 drivers/net/ethernet/natsemi/ns83820.c                             |    5 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c                   |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c                     |   35 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h                     |    1 -
 drivers/net/ethernet/neterion/vxge/vxge-traffic.c                  |   37 +-
 drivers/net/ethernet/neterion/vxge/vxge-traffic.h                  |    8 -
 drivers/net/ethernet/netx-eth.c                                    |    3 +-
 drivers/net/ethernet/nvidia/forcedeth.c                            |    6 +-
 drivers/net/ethernet/nxp/lpc_eth.c                                 |    1 -
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h                    |    3 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_api.c                |    3 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_api.h                |    3 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c            |    3 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c               |    3 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c              |    3 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c                |    3 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.h                |    3 +-
 drivers/net/ethernet/packetengines/yellowfin.c                     |   17 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c                           |    4 +-
 drivers/net/ethernet/pasemi/pasemi_mac.h                           |    3 +-
 drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c                   |    3 +-
 drivers/net/ethernet/qlogic/netxen/Makefile                        |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h                    |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c                |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c            |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hdr.h                |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c                 |    6 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.h                 |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c               |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c               |    4 +-
 drivers/net/ethernet/qlogic/qla3xxx.c                              |    1 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                        |  197 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c                |  425 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h                |   45 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c              |   28 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c              |   14 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c                    |   49 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c                    |   31 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h                    |   14 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c                |  144 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hdr.h                    |    1 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c                     |  127 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h                     |    9 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c                     |  167 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                   |  435 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h                  |   15 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c           |  257 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c               |  236 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c                  |  133 +-
 drivers/net/ethernet/qlogic/qlge/qlge.h                            |    1 -
 drivers/net/ethernet/qlogic/qlge/qlge_dbg.c                        |    4 +-
 drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c                    |    1 -
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                       |    1 -
 drivers/net/ethernet/rdc/r6040.c                                   |    7 +-
 drivers/net/ethernet/realtek/r8169.c                               |    1 -
 drivers/net/ethernet/renesas/Kconfig                               |    2 +-
 drivers/net/ethernet/renesas/sh_eth.c                              |  263 +-
 drivers/net/ethernet/renesas/sh_eth.h                              |   56 +-
 drivers/net/ethernet/s6gmac.c                                      |    1 -
 drivers/net/ethernet/seeq/sgiseeq.c                                |    3 +-
 drivers/net/ethernet/sfc/ef10.c                                    |  549 +++-
 drivers/net/ethernet/sfc/efx.c                                     |  201 +-
 drivers/net/ethernet/sfc/efx.h                                     |   16 +-
 drivers/net/ethernet/sfc/enum.h                                    |    1 +
 drivers/net/ethernet/sfc/ethtool.c                                 |   16 +-
 drivers/net/ethernet/sfc/falcon.c                                  |   38 +-
 drivers/net/ethernet/sfc/farch.c                                   |   48 +-
 drivers/net/ethernet/sfc/filter.h                                  |   17 +-
 drivers/net/ethernet/sfc/mcdi.c                                    |  444 +--
 drivers/net/ethernet/sfc/mcdi.h                                    |   21 +
 drivers/net/ethernet/sfc/mcdi_mon.c                                |   76 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h                               |  733 ++++-
 drivers/net/ethernet/sfc/mcdi_port.c                               |   89 +-
 drivers/net/ethernet/sfc/net_driver.h                              |   75 +-
 drivers/net/ethernet/sfc/nic.c                                     |   12 +
 drivers/net/ethernet/sfc/nic.h                                     |   34 +-
 drivers/net/ethernet/sfc/ptp.c                                     |  854 ++++--
 drivers/net/ethernet/sfc/rx.c                                      |   24 +-
 drivers/net/ethernet/sfc/selftest.c                                |    2 +-
 drivers/net/ethernet/sfc/selftest.h                                |    1 +
 drivers/net/ethernet/sfc/siena.c                                   |  119 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                                |    1 -
 drivers/net/ethernet/sgi/meth.c                                    |    1 -
 drivers/net/ethernet/sis/sis900.c                                  |    2 -
 drivers/net/ethernet/smsc/smc911x.c                                |    4 +-
 drivers/net/ethernet/smsc/smc911x.h                                |    3 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c                            |    1 -
 drivers/net/ethernet/smsc/smc91x.c                                 |    6 +-
 drivers/net/ethernet/smsc/smc91x.h                                 |    3 +-
 drivers/net/ethernet/smsc/smsc911x.c                               |    3 +-
 drivers/net/ethernet/smsc/smsc911x.h                               |    3 +-
 drivers/net/ethernet/smsc/smsc9420.c                               |    5 +-
 drivers/net/ethernet/smsc/smsc9420.h                               |    3 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig                        |   12 +
 drivers/net/ethernet/stmicro/stmmac/Makefile                       |    1 +
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c                   |    3 +-
 drivers/net/ethernet/stmicro/stmmac/common.h                       |    5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c                  |  140 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h                    |    7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c               |    7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c                |    2 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c                    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                       |   11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                  |  471 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c                  |    3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c                   |   10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c              |  135 +-
 drivers/net/ethernet/sun/cassini.c                                 |    4 +-
 drivers/net/ethernet/sun/cassini.h                                 |    4 +-
 drivers/net/ethernet/sun/niu.c                                     |   10 +-
 drivers/net/ethernet/sun/sunbmac.c                                 |    1 -
 drivers/net/ethernet/sun/sungem.c                                  |    1 -
 drivers/net/ethernet/sun/sunvnet.c                                 |    2 +-
 drivers/net/ethernet/tehuti/tehuti.c                               |    2 +-
 drivers/net/ethernet/ti/cpmac.c                                    |    1 -
 drivers/net/ethernet/ti/cpsw.c                                     |  137 +-
 drivers/net/ethernet/ti/cpsw_ale.c                                 |   18 +-
 drivers/net/ethernet/ti/cpsw_ale.h                                 |    2 +
 drivers/net/ethernet/ti/davinci_cpdma.c                            |    7 +-
 drivers/net/ethernet/ti/davinci_mdio.c                             |    2 +-
 drivers/net/ethernet/tile/Kconfig                                  |   12 +-
 drivers/net/ethernet/tile/tilegx.c                                 |   38 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                       |   18 +-
 drivers/net/ethernet/toshiba/tc35815.c                             |   16 +-
 drivers/net/ethernet/tundra/tsi108_eth.c                           |    1 -
 drivers/net/ethernet/tundra/tsi108_eth.h                           |    4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c                        |    1 -
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                  |    1 -
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                      |    1 -
 drivers/net/ethernet/xircom/xirc2ps_cs.c                           |    3 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c                           |   36 +-
 drivers/net/fddi/defxx.c                                           |   21 +-
 drivers/net/fddi/skfp/fplustm.c                                    |   27 +-
 drivers/net/fddi/skfp/h/supern_2.h                                 |   96 +-
 drivers/net/fddi/skfp/h/targetos.h                                 |    1 -
 drivers/net/fddi/skfp/skfddi.c                                     |    1 -
 drivers/net/fddi/skfp/smt.c                                        |    2 +-
 drivers/net/fddi/skfp/srf.c                                        |   24 +-
 drivers/net/hamradio/6pack.c                                       |    3 +-
 drivers/net/hamradio/bpqether.c                                    |    2 +-
 drivers/net/hamradio/mkiss.c                                       |    3 +-
 drivers/net/hippi/rrunner.c                                        |    6 +-
 drivers/net/hyperv/hyperv_net.h                                    |    3 +-
 drivers/net/hyperv/netvsc.c                                        |    3 +-
 drivers/net/hyperv/netvsc_drv.c                                    |    3 +-
 drivers/net/hyperv/rndis_filter.c                                  |    3 +-
 drivers/net/ieee802154/at86rf230.c                                 |    2 -
 drivers/net/ieee802154/mrf24j40.c                                  |    1 -
 drivers/net/irda/Kconfig                                           |    4 +-
 drivers/net/irda/au1k_ir.c                                         |    4 +-
 drivers/net/irda/esi-sir.c                                         |    4 +-
 drivers/net/irda/irda-usb.c                                        |    1 -
 drivers/net/irda/kingsun-sir.c                                     |    1 -
 drivers/net/irda/ks959-sir.c                                       |    1 -
 drivers/net/irda/ksdazzle-sir.c                                    |    1 -
 drivers/net/irda/litelink-sir.c                                    |    4 +-
 drivers/net/irda/ma600-sir.c                                       |    4 +-
 drivers/net/irda/mcs7780.c                                         |    1 -
 drivers/net/irda/old_belkin-sir.c                                  |    4 +-
 drivers/net/irda/sh_irda.c                                         |    2 +-
 drivers/net/irda/sh_sir.c                                          |    2 +-
 drivers/net/irda/sir_dongle.c                                      |    1 -
 drivers/net/irda/smsc-ircc2.c                                      |    4 +-
 drivers/net/irda/smsc-ircc2.h                                      |    4 +-
 drivers/net/irda/stir4200.c                                        |    1 -
 drivers/net/irda/via-ircc.c                                        |    5 +-
 drivers/net/irda/via-ircc.h                                        |    3 +-
 drivers/net/irda/vlsi_ir.c                                         |    7 +-
 drivers/net/irda/vlsi_ir.h                                         |    4 +-
 drivers/net/loopback.c                                             |    1 -
 drivers/net/macvlan.c                                              |   38 +-
 drivers/net/macvtap.c                                              |   77 +-
 drivers/net/mdio.c                                                 |   28 -
 drivers/net/phy/cicada.c                                           |    4 +-
 drivers/net/phy/davicom.c                                          |    2 +-
 drivers/net/phy/dp83640.c                                          |    4 +-
 drivers/net/phy/icplus.c                                           |    2 +-
 drivers/net/phy/lxt.c                                              |    4 +-
 drivers/net/phy/marvell.c                                          |   22 +
 drivers/net/phy/mdio-gpio.c                                        |    1 -
 drivers/net/phy/mdio-moxart.c                                      |    1 -
 drivers/net/phy/mdio-mux-gpio.c                                    |    1 -
 drivers/net/phy/mdio-mux-mmioreg.c                                 |    1 -
 drivers/net/phy/mdio-octeon.c                                      |    1 -
 drivers/net/phy/mdio-sun4i.c                                       |    1 -
 drivers/net/phy/mdio_bus.c                                         |   35 +-
 drivers/net/phy/micrel.c                                           |    4 +-
 drivers/net/phy/phy.c                                              |  429 ++-
 drivers/net/phy/phy_device.c                                       |  419 ++-
 drivers/net/phy/spi_ks8995.c                                       |    7 +-
 drivers/net/plip/plip.c                                            |    4 +-
 drivers/net/ppp/ppp_mppe.c                                         |    3 +-
 drivers/net/ppp/pppoe.c                                            |    4 +-
 drivers/net/team/team.c                                            |    6 +-
 drivers/net/team/team_mode_random.c                                |    8 +-
 drivers/net/tun.c                                                  |   68 +-
 drivers/net/usb/Kconfig                                            |    5 +-
 drivers/net/usb/asix.h                                             |    4 +-
 drivers/net/usb/asix_common.c                                      |    3 +-
 drivers/net/usb/asix_devices.c                                     |    3 +-
 drivers/net/usb/ax88172a.c                                         |    3 +-
 drivers/net/usb/ax88179_178a.c                                     |    3 +-
 drivers/net/usb/catc.c                                             |    4 +-
 drivers/net/usb/cdc_eem.c                                          |    4 +-
 drivers/net/usb/cdc_ether.c                                        |    5 +-
 drivers/net/usb/cdc_ncm.c                                          |    1 -
 drivers/net/usb/cdc_subset.c                                       |    4 +-
 drivers/net/usb/cx82310_eth.c                                      |    4 +-
 drivers/net/usb/dm9601.c                                           |    1 -
 drivers/net/usb/gl620a.c                                           |    4 +-
 drivers/net/usb/int51x1.c                                          |    3 +-
 drivers/net/usb/ipheth.c                                           |    1 -
 drivers/net/usb/kalmia.c                                           |    1 -
 drivers/net/usb/kaweth.c                                           |    4 +-
 drivers/net/usb/lg-vl600.c                                         |    3 +-
 drivers/net/usb/mcs7830.c                                          |    4 +-
 drivers/net/usb/net1080.c                                          |    4 +-
 drivers/net/usb/plusb.c                                            |    4 +-
 drivers/net/usb/r8152.c                                            |  916 +++++-
 drivers/net/usb/r815x.c                                            |    8 -
 drivers/net/usb/rndis_host.c                                       |    4 +-
 drivers/net/usb/rtl8150.c                                          |    1 -
 drivers/net/usb/sierra_net.c                                       |    3 +-
 drivers/net/usb/smsc75xx.c                                         |    4 +-
 drivers/net/usb/smsc75xx.h                                         |    3 +-
 drivers/net/usb/smsc95xx.c                                         |    4 +-
 drivers/net/usb/smsc95xx.h                                         |    3 +-
 drivers/net/usb/sr9700.c                                           |    1 -
 drivers/net/usb/usbnet.c                                           |    3 +-
 drivers/net/usb/zaurus.c                                           |    4 +-
 drivers/net/virtio_net.c                                           |  254 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                                  |    5 +-
 drivers/net/vmxnet3/vmxnet3_int.h                                  |    1 -
 drivers/net/vxlan.c                                                |  308 +-
 drivers/net/wan/dscc4.c                                            |    2 -
 drivers/net/wan/hd64570.c                                          |    1 -
 drivers/net/wan/hd64570.h                                          |    4 +-
 drivers/net/wan/hd64572.c                                          |    1 -
 drivers/net/wan/hd64572.h                                          |    2 +-
 drivers/net/wan/lmc/lmc_main.c                                     |    3 -
 drivers/net/wan/pc300too.c                                         |    1 -
 drivers/net/wan/pci200syn.c                                        |    1 -
 drivers/net/wan/sbni.c                                             |    1 +
 drivers/net/wan/wanxl.c                                            |    1 -
 drivers/net/wireless/adm8211.c                                     |    4 +-
 drivers/net/wireless/airo_cs.c                                     |    1 -
 drivers/net/wireless/at76c50x-usb.c                                |    3 +-
 drivers/net/wireless/ath/ar5523/ar5523.c                           |    1 -
 drivers/net/wireless/ath/ath.h                                     |    2 +
 drivers/net/wireless/ath/ath10k/Kconfig                            |    7 +
 drivers/net/wireless/ath/ath10k/ce.c                               |   53 +-
 drivers/net/wireless/ath/ath10k/ce.h                               |    2 +-
 drivers/net/wireless/ath/ath10k/core.c                             |   43 +-
 drivers/net/wireless/ath/ath10k/core.h                             |   34 +-
 drivers/net/wireless/ath/ath10k/debug.c                            |  160 +
 drivers/net/wireless/ath/ath10k/debug.h                            |    6 +
 drivers/net/wireless/ath/ath10k/htc.c                              |   31 +-
 drivers/net/wireless/ath/ath10k/htt.c                              |    4 +-
 drivers/net/wireless/ath/ath10k/htt.h                              |    2 +
 drivers/net/wireless/ath/ath10k/htt_rx.c                           |   40 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c                           |   11 +-
 drivers/net/wireless/ath/ath10k/hw.h                               |    2 +
 drivers/net/wireless/ath/ath10k/mac.c                              |  677 ++++-
 drivers/net/wireless/ath/ath10k/pci.c                              |  791 +++--
 drivers/net/wireless/ath/ath10k/pci.h                              |   14 +-
 drivers/net/wireless/ath/ath10k/trace.h                            |   21 +
 drivers/net/wireless/ath/ath10k/txrx.c                             |    8 +-
 drivers/net/wireless/ath/ath10k/wmi.c                              |  408 ++-
 drivers/net/wireless/ath/ath10k/wmi.h                              |  157 +-
 drivers/net/wireless/ath/ath5k/base.c                              |   34 +-
 drivers/net/wireless/ath/ath5k/dma.c                               |   11 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                         |   11 +-
 drivers/net/wireless/ath/ath6kl/wmi.c                              |    6 +-
 drivers/net/wireless/ath/ath9k/Kconfig                             |   18 +-
 drivers/net/wireless/ath/ath9k/Makefile                            |   14 +-
 drivers/net/wireless/ath/ath9k/antenna.c                           |    8 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c                         |   23 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c                        |    6 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c                        |    1 -
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h               |  222 +-
 drivers/net/wireless/ath/ath9k/ar9003_buffalo_initvals.h           |  126 +
 drivers/net/wireless/ath/ath9k/ar9003_calib.c                      |  385 ++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                     |   65 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h                     |   14 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                         |  297 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c                        |   18 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                        |  106 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                        |   24 +-
 drivers/net/wireless/ath/ath9k/ar9003_wow.c                        |  422 +++
 drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h               |  128 +-
 drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h               |  401 ++-
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h                   |  392 +--
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h               |  723 +----
 drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h               | 1559 +---------
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h                   |  117 +-
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h                   |  718 +++++
 drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h               |  540 +---
 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h               |   85 +-
 drivers/net/wireless/ath/ath9k/ar9565_1p1_initvals.h               |   64 +
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h               |  572 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h                             |  434 +--
 drivers/net/wireless/ath/ath9k/beacon.c                            |  147 +-
 drivers/net/wireless/ath/ath9k/btcoex.c                            |    6 -
 drivers/net/wireless/ath/ath9k/common.c                            |    4 +-
 drivers/net/wireless/ath/ath9k/debug.c                             |  632 +---
 drivers/net/wireless/ath/ath9k/debug.h                             |   44 +-
 drivers/net/wireless/ath/ath9k/debug_sta.c                         |  269 ++
 drivers/net/wireless/ath/ath9k/dfs.c                               |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c                         |   26 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c                       |   26 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c                        |   26 +-
 drivers/net/wireless/ath/ath9k/gpio.c                              |   89 +-
 drivers/net/wireless/ath/ath9k/htc.h                               |    5 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c                    |   39 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c                      |   17 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                      |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                      |    4 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h                            |   47 +-
 drivers/net/wireless/ath/ath9k/hw.c                                |  608 ++--
 drivers/net/wireless/ath/ath9k/hw.h                                |   75 +-
 drivers/net/wireless/ath/ath9k/init.c                              |   72 +-
 drivers/net/wireless/ath/ath9k/link.c                              |   67 +-
 drivers/net/wireless/ath/ath9k/mac.c                               |   51 +-
 drivers/net/wireless/ath/ath9k/mac.h                               |    8 +-
 drivers/net/wireless/ath/ath9k/main.c                              |  671 +----
 drivers/net/wireless/ath/ath9k/mci.c                               |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c                               |  134 +-
 drivers/net/wireless/ath/ath9k/recv.c                              |  247 +-
 drivers/net/wireless/ath/ath9k/reg.h                               |   29 +-
 drivers/net/wireless/ath/ath9k/spectral.c                          |  543 ++++
 drivers/net/wireless/ath/ath9k/spectral.h                          |  212 ++
 drivers/net/wireless/ath/ath9k/tx99.c                              |  272 ++
 drivers/net/wireless/ath/ath9k/wow.c                               |  588 ++--
 drivers/net/wireless/ath/ath9k/xmit.c                              |   27 +-
 drivers/net/wireless/ath/carl9170/debug.c                          |    1 -
 drivers/net/wireless/ath/carl9170/main.c                           |   13 -
 drivers/net/wireless/ath/carl9170/rx.c                             |   14 +-
 drivers/net/wireless/ath/carl9170/tx.c                             |    1 -
 drivers/net/wireless/ath/main.c                                    |    8 +
 drivers/net/wireless/ath/regd.c                                    |  379 +--
 drivers/net/wireless/ath/wcn36xx/hal.h                             |    2 +-
 drivers/net/wireless/ath/wcn36xx/main.c                            |    3 +-
 drivers/net/wireless/ath/wcn36xx/smd.c                             |   65 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h                         |    2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c                       |   13 +
 drivers/net/wireless/ath/wil6210/txrx.c                            |    8 +-
 drivers/net/wireless/ath/wil6210/wil6210.h                         |    1 +
 drivers/net/wireless/atmel.c                                       |    8 +-
 drivers/net/wireless/atmel.h                                       |    4 +-
 drivers/net/wireless/atmel_cs.c                                    |    5 +-
 drivers/net/wireless/atmel_pci.c                                   |    5 +-
 drivers/net/wireless/b43/b43.h                                     |    4 +-
 drivers/net/wireless/b43/main.c                                    |   27 +-
 drivers/net/wireless/b43/xmit.c                                    |    4 +-
 drivers/net/wireless/b43legacy/main.c                              |    1 +
 drivers/net/wireless/brcm80211/Kconfig                             |    5 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                   |    5 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c                     |  375 +++
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.h                     |   24 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c                   |  737 +++--
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c             |  539 ----
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                      |  487 +---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h                  |   44 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c                  |  392 ---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c               |   31 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c                  |   36 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h                  |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c                |  207 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h                |   42 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c                 | 1596 +++++-----
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h                     |   54 +
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c                     |   19 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h                     |   61 +
 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h               |  304 ++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c                 |  216 +-
 drivers/net/wireless/brcm80211/brcmfmac/nvram.c                    |   94 +
 drivers/net/wireless/brcm80211/brcmfmac/nvram.h                    |   24 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                      |   52 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.c                    |   62 +
 drivers/net/wireless/brcm80211/brcmfmac/proto.h                    |   57 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c                |  827 +++---
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h                |   39 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h                |   83 +-
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h               |   33 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                      |    9 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c              |  194 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h              |    5 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c                  |   38 +-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c              |   67 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c                     |    2 -
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h               |    1 +
 drivers/net/wireless/brcm80211/include/brcmu_wifi.h                |   14 +
 drivers/net/wireless/cw1200/cw1200_sdio.c                          |    4 +-
 drivers/net/wireless/cw1200/fwio.c                                 |    1 -
 drivers/net/wireless/cw1200/main.c                                 |    2 -
 drivers/net/wireless/cw1200/pm.c                                   |   11 +-
 drivers/net/wireless/cw1200/scan.c                                 |   15 +-
 drivers/net/wireless/cw1200/sta.c                                  |    5 +-
 drivers/net/wireless/cw1200/txrx.c                                 |    3 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c                      |    8 +-
 drivers/net/wireless/hostap/hostap_80211_tx.c                      |    4 +-
 drivers/net/wireless/hostap/hostap_ap.c                            |   28 +-
 drivers/net/wireless/hostap/hostap_cs.c                            |    1 -
 drivers/net/wireless/hostap/hostap_hw.c                            |    2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c                         |    6 +-
 drivers/net/wireless/hostap/hostap_main.c                          |    8 +-
 drivers/net/wireless/hostap/hostap_pci.c                           |    1 -
 drivers/net/wireless/hostap/hostap_plx.c                           |    1 -
 drivers/net/wireless/ipw2x00/ipw2100.c                             |    5 +-
 drivers/net/wireless/ipw2x00/ipw2200.c                             |   42 +-
 drivers/net/wireless/ipw2x00/ipw2200.h                             |    1 -
 drivers/net/wireless/ipw2x00/libipw_rx.c                           |   12 +-
 drivers/net/wireless/iwlegacy/3945-debug.c                         |    6 +-
 drivers/net/wireless/iwlegacy/3945-mac.c                           |   11 +-
 drivers/net/wireless/iwlegacy/3945-rs.c                            |    1 -
 drivers/net/wireless/iwlegacy/3945.c                               |    5 +-
 drivers/net/wireless/iwlegacy/4965-debug.c                         |    6 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                           |    8 +-
 drivers/net/wireless/iwlegacy/4965-rs.c                            |    1 -
 drivers/net/wireless/iwlegacy/4965.c                               |    1 -
 drivers/net/wireless/iwlegacy/common.c                             |   13 +-
 drivers/net/wireless/iwlegacy/debug.c                              |   10 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h                             |    4 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c                           |    4 +-
 drivers/net/wireless/iwlwifi/dvm/calib.h                           |    4 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h                        |    4 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c                         |   10 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h                             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c                         |    2 +-
 drivers/net/wireless/iwlwifi/dvm/led.c                             |    3 +-
 drivers/net/wireless/iwlwifi/dvm/led.h                             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c                             |    3 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                        |   18 +-
 drivers/net/wireless/iwlwifi/dvm/main.c                            |    6 +-
 drivers/net/wireless/iwlwifi/dvm/power.c                           |    3 +-
 drivers/net/wireless/iwlwifi/dvm/power.h                           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c                              |    3 +-
 drivers/net/wireless/iwlwifi/dvm/rs.h                              |    9 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c                              |    9 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c                            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c                            |    4 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c                             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c                              |    3 +-
 drivers/net/wireless/iwlwifi/dvm/tt.h                              |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                              |    4 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c                           |   10 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c                            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c                            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c                            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c                            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c                            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h                          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                          |   12 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h                             |    7 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h                           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c                        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h                        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                             |   43 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h                             |    6 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c                    |   15 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h                    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c                     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h                     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h                              |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h                         |    5 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h                              |   50 +-
 drivers/net/wireless/iwlwifi/iwl-io.c                              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h                              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h                       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c                      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h                      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                       |   17 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h                       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c                          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.h                          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h                            |   11 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h                           |   87 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile                          |    4 +-
 drivers/net/wireless/iwlwifi/mvm/binding.c                         |   20 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c                         |   21 +-
 drivers/net/wireless/iwlwifi/mvm/constants.h                       |    4 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c                              |   57 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c                     |  546 ++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                         |  689 +----
 drivers/net/wireless/iwlwifi/mvm/debugfs.h                         |  101 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h                  |    5 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h                       |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h                      |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h                    |   20 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h                       |   31 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h                     |    9 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h                      |   17 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                       |    5 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                          |   69 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c                              |   32 +-
 drivers/net/wireless/iwlwifi/mvm/led.c                             |    6 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                        |  211 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                        |  342 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h                             |   63 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c                             |   51 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c                             |   28 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                        |    4 +-
 drivers/net/wireless/iwlwifi/mvm/power.c                           |  400 ++-
 drivers/net/wireless/iwlwifi/mvm/power_legacy.c                    |    4 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c                           |    7 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c                              | 2248 +++++++-------
 drivers/net/wireless/iwlwifi/mvm/rs.h                              |  154 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c                              |   10 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c                            |   72 +-
 drivers/net/wireless/iwlwifi/mvm/sf.c                              |  291 ++
 drivers/net/wireless/iwlwifi/mvm/sta.c                             |   50 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h                             |   10 +-
 drivers/net/wireless/iwlwifi/mvm/testmode.h                        |    4 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c                      |    8 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h                      |    4 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c                              |    8 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c                              |   27 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c                           |   21 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c                            |    9 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h                       |   65 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c                             |  437 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c                          |  183 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c                             |  172 +-
 drivers/net/wireless/libertas/README                               |    5 +-
 drivers/net/wireless/libertas/cfg.c                                |    7 +-
 drivers/net/wireless/libertas/if_sdio.c                            |    6 +-
 drivers/net/wireless/libertas/if_spi.c                             |    1 -
 drivers/net/wireless/mac80211_hwsim.c                              | 1227 ++++----
 drivers/net/wireless/mac80211_hwsim.h                              |   18 +
 drivers/net/wireless/mwifiex/11n.c                                 |    2 +-
 drivers/net/wireless/mwifiex/11n_aggr.c                            |    6 +-
 drivers/net/wireless/mwifiex/Kconfig                               |    4 +-
 drivers/net/wireless/mwifiex/cfg80211.c                            |   70 +-
 drivers/net/wireless/mwifiex/cmdevt.c                              |    4 +-
 drivers/net/wireless/mwifiex/decl.h                                |    1 +
 drivers/net/wireless/mwifiex/fw.h                                  |   41 +-
 drivers/net/wireless/mwifiex/init.c                                |    3 +-
 drivers/net/wireless/mwifiex/main.c                                |   11 +-
 drivers/net/wireless/mwifiex/main.h                                |    7 +-
 drivers/net/wireless/mwifiex/scan.c                                |    8 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                             |   80 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c                         |   38 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                           |   20 +
 drivers/net/wireless/mwifiex/sta_rx.c                              |   46 +-
 drivers/net/wireless/mwifiex/sta_tx.c                              |    1 +
 drivers/net/wireless/mwifiex/txrx.c                                |   15 +-
 drivers/net/wireless/mwifiex/uap_txrx.c                            |   39 +-
 drivers/net/wireless/mwifiex/usb.c                                 |   58 +-
 drivers/net/wireless/mwifiex/usb.h                                 |   12 +-
 drivers/net/wireless/mwifiex/util.c                                |    5 +-
 drivers/net/wireless/mwl8k.c                                       |    5 +-
 drivers/net/wireless/orinoco/hermes.c                              |    1 -
 drivers/net/wireless/orinoco/orinoco_cs.c                          |    1 -
 drivers/net/wireless/orinoco/orinoco_usb.c                         |    1 -
 drivers/net/wireless/orinoco/spectrum_cs.c                         |    1 -
 drivers/net/wireless/p54/eeprom.c                                  |    1 -
 drivers/net/wireless/p54/fwio.c                                    |    1 -
 drivers/net/wireless/p54/led.c                                     |    1 -
 drivers/net/wireless/p54/main.c                                    |    2 -
 drivers/net/wireless/p54/net2280.h                                 |    3 +-
 drivers/net/wireless/p54/p54pci.c                                  |    1 -
 drivers/net/wireless/p54/p54usb.c                                  |    1 -
 drivers/net/wireless/p54/txrx.c                                    |    5 +-
 drivers/net/wireless/prism54/isl_38xx.c                            |    3 +-
 drivers/net/wireless/prism54/isl_38xx.h                            |    3 +-
 drivers/net/wireless/prism54/isl_ioctl.c                           |    6 +-
 drivers/net/wireless/prism54/isl_ioctl.h                           |    3 +-
 drivers/net/wireless/prism54/isl_oid.h                             |    3 +-
 drivers/net/wireless/prism54/islpci_dev.c                          |    4 +-
 drivers/net/wireless/prism54/islpci_dev.h                          |    3 +-
 drivers/net/wireless/prism54/islpci_eth.c                          |    3 +-
 drivers/net/wireless/prism54/islpci_eth.h                          |    3 +-
 drivers/net/wireless/prism54/islpci_hotplug.c                      |    5 +-
 drivers/net/wireless/prism54/islpci_mgt.c                          |    3 +-
 drivers/net/wireless/prism54/islpci_mgt.h                          |    3 +-
 drivers/net/wireless/prism54/oid_mgt.c                             |    3 +-
 drivers/net/wireless/prism54/oid_mgt.h                             |    3 +-
 drivers/net/wireless/prism54/prismcompat.h                         |    3 +-
 drivers/net/wireless/ray_cs.c                                      |    3 +-
 drivers/net/wireless/rndis_wlan.c                                  |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.c                            |    5 +-
 drivers/net/wireless/rt2x00/rt2400pci.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2500pci.c                            |    5 +-
 drivers/net/wireless/rt2x00/rt2500pci.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c                            |    5 +-
 drivers/net/wireless/rt2x00/rt2500usb.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2800.h                               |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                            |   41 +-
 drivers/net/wireless/rt2x00/rt2800lib.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2800mmio.c                           |    4 +-
 drivers/net/wireless/rt2x00/rt2800mmio.h                           |    4 +-
 drivers/net/wireless/rt2x00/rt2800pci.c                            |    4 +-
 drivers/net/wireless/rt2x00/rt2800pci.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2800soc.c                            |    4 +-
 drivers/net/wireless/rt2x00/rt2800usb.c                            |    6 +-
 drivers/net/wireless/rt2x00/rt2800usb.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h                               |    4 +-
 drivers/net/wireless/rt2x00/rt2x00config.c                         |    4 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c                         |    4 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c                          |    4 +-
 drivers/net/wireless/rt2x00/rt2x00debug.h                          |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c                            |    8 +-
 drivers/net/wireless/rt2x00/rt2x00dump.h                           |    4 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c                       |    4 +-
 drivers/net/wireless/rt2x00/rt2x00leds.c                           |    4 +-
 drivers/net/wireless/rt2x00/rt2x00leds.h                           |    4 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00link.c                           |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mmio.c                           |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mmio.h                           |    4 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c                            |    7 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c                          |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h                          |    4 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00soc.c                            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00soc.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c                            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h                            |    4 +-
 drivers/net/wireless/rt2x00/rt61pci.c                              |    5 +-
 drivers/net/wireless/rt2x00/rt61pci.h                              |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c                              |    5 +-
 drivers/net/wireless/rt2x00/rt73usb.h                              |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c                         |    1 -
 drivers/net/wireless/rtl818x/rtl8180/grf5101.c                     |    1 -
 drivers/net/wireless/rtl818x/rtl8180/max2820.c                     |    1 -
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c                     |    1 -
 drivers/net/wireless/rtl818x/rtl8180/sa2400.c                      |    1 -
 drivers/net/wireless/rtl818x/rtl8187/dev.c                         |    3 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.c                     |    1 -
 drivers/net/wireless/rtlwifi/base.c                                |    8 +-
 drivers/net/wireless/rtlwifi/cam.c                                 |    4 +-
 drivers/net/wireless/rtlwifi/core.c                                |   11 +
 drivers/net/wireless/rtlwifi/pci.c                                 |    2 -
 drivers/net/wireless/rtlwifi/ps.c                                  |    4 +-
 drivers/net/wireless/rtlwifi/regd.c                                |   61 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c                        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c                  |  327 ++-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h                  |   14 +
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c                 |   39 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c                        |    9 +
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h                        |    3 +
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c                        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c                       |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c                        |   29 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c                        |   17 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/table.c                     |   40 +-
 drivers/net/wireless/rtlwifi/stats.c                               |   14 +
 drivers/net/wireless/rtlwifi/usb.c                                 |    8 +-
 drivers/net/wireless/rtlwifi/wifi.h                                |   33 +-
 drivers/net/wireless/ti/wl1251/acx.c                               |  258 +-
 drivers/net/wireless/ti/wl1251/acx.h                               |   26 +-
 drivers/net/wireless/ti/wl1251/boot.c                              |    3 +-
 drivers/net/wireless/ti/wl1251/cmd.c                               |   58 +-
 drivers/net/wireless/ti/wl1251/cmd.h                               |    8 +-
 drivers/net/wireless/ti/wl1251/event.c                             |   46 +-
 drivers/net/wireless/ti/wl1251/event.h                             |    7 +
 drivers/net/wireless/ti/wl1251/init.c                              |   13 +-
 drivers/net/wireless/ti/wl1251/main.c                              |  153 +-
 drivers/net/wireless/ti/wl1251/rx.c                                |    2 +-
 drivers/net/wireless/ti/wl1251/tx.c                                |   35 +-
 drivers/net/wireless/ti/wl1251/wl1251.h                            |    6 +
 drivers/net/wireless/ti/wl12xx/scan.c                              |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.c                               |    2 +-
 drivers/net/wireless/ti/wlcore/main.c                              |   14 +-
 drivers/net/wireless/ti/wlcore/scan.c                              |   12 +-
 drivers/net/wireless/wl3501_cs.c                                   |    5 +-
 drivers/net/wireless/zd1211rw/zd_chip.c                            |    3 +-
 drivers/net/wireless/zd1211rw/zd_chip.h                            |    3 +-
 drivers/net/wireless/zd1211rw/zd_def.h                             |    3 +-
 drivers/net/wireless/zd1211rw/zd_mac.c                             |    8 +-
 drivers/net/wireless/zd1211rw/zd_mac.h                             |    3 +-
 drivers/net/wireless/zd1211rw/zd_rf.c                              |    3 +-
 drivers/net/wireless/zd1211rw/zd_rf.h                              |    3 +-
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c                       |    3 +-
 drivers/net/wireless/zd1211rw/zd_rf_al7230b.c                      |    3 +-
 drivers/net/wireless/zd1211rw/zd_rf_rf2959.c                       |    3 +-
 drivers/net/wireless/zd1211rw/zd_rf_uw2453.c                       |    3 +-
 drivers/net/wireless/zd1211rw/zd_usb.c                             |    3 +-
 drivers/net/wireless/zd1211rw/zd_usb.h                             |    3 +-
 drivers/net/xen-netback/common.h                                   |   28 +-
 drivers/net/xen-netback/interface.c                                |   47 +-
 drivers/net/xen-netback/netback.c                                  |  506 +---
 drivers/net/xen-netback/xenbus.c                                   |    3 +-
 drivers/net/xen-netfront.c                                         |   96 +-
 drivers/nfc/Kconfig                                                |    1 +
 drivers/nfc/Makefile                                               |    1 +
 drivers/nfc/mei_phy.c                                              |    6 +-
 drivers/nfc/microread/i2c.c                                        |    4 +-
 drivers/nfc/microread/mei.c                                        |    4 +-
 drivers/nfc/microread/microread.c                                  |    4 +-
 drivers/nfc/microread/microread.h                                  |    4 +-
 drivers/nfc/nfcmrvl/Kconfig                                        |   23 +
 drivers/nfc/nfcmrvl/Makefile                                       |    9 +
 drivers/nfc/nfcmrvl/main.c                                         |  165 ++
 drivers/nfc/nfcmrvl/nfcmrvl.h                                      |   48 +
 drivers/nfc/nfcmrvl/usb.c                                          |  459 +++
 drivers/nfc/nfcwilink.c                                            |    3 +-
 drivers/nfc/pn533.c                                                |    7 +-
 drivers/nfc/pn544/i2c.c                                            |    4 +-
 drivers/nfc/pn544/mei.c                                            |    4 +-
 drivers/nfc/pn544/pn544.c                                          |   50 +-
 drivers/nfc/pn544/pn544.h                                          |    4 +-
 drivers/nfc/port100.c                                              |    1 +
 drivers/of/of_mdio.c                                               |  155 +-
 drivers/of/of_net.c                                                |    1 +
 drivers/phy/Kconfig                                                |    1 +
 drivers/power/Kconfig                                              |    1 +
 drivers/ptp/Kconfig                                                |    1 +
 drivers/s390/cio/chsc.c                                            |   33 +
 drivers/s390/cio/chsc.h                                            |   51 +-
 drivers/s390/cio/qdio_main.c                                       |   91 +
 drivers/s390/net/Makefile                                          |    2 +-
 drivers/s390/net/netiucv.c                                         |    8 +-
 drivers/s390/net/qeth_core.h                                       |   38 +
 drivers/s390/net/qeth_core_main.c                                  |  215 +-
 drivers/s390/net/qeth_core_mpc.c                                   |    2 +
 drivers/s390/net/qeth_core_mpc.h                                   |  150 +-
 drivers/s390/net/qeth_l2.h                                         |   15 +
 drivers/s390/net/qeth_l2_main.c                                    |  594 ++++
 drivers/s390/net/qeth_l2_sys.c                                     |  223 ++
 drivers/ssb/driver_chipcommon_sflash.c                             |    6 +-
 drivers/staging/cxt1e1/linux.c                                     |   15 +-
 drivers/staging/dgap/Kconfig                                       |    2 +-
 drivers/staging/iio/adc/Kconfig                                    |    2 +
 drivers/staging/ozwpan/ozcdev.c                                    |    2 +-
 drivers/staging/ozwpan/ozproto.c                                   |    5 +-
 drivers/staging/winbond/wbusb.c                                    |    1 -
 drivers/vhost/net.c                                                |    9 +-
 drivers/vhost/scsi.c                                               |    7 +-
 drivers/vhost/test.c                                               |    8 +-
 drivers/vhost/vhost.c                                              |    4 +-
 drivers/vhost/vhost.h                                              |    2 +-
 fs/dlm/lowcomms.c                                                  |    4 +-
 include/asm-generic/hash.h                                         |    9 +
 include/linux/ath9k_platform.h                                     |    2 +
 include/linux/bcma/bcma.h                                          |    9 +-
 include/linux/cgroup_subsys.h                                      |    4 +-
 include/linux/etherdevice.h                                        |  118 +-
 include/linux/filter.h                                             |    5 +
 include/linux/flex_array.h                                         |    3 +-
 include/linux/hash.h                                               |   36 +
 include/linux/ieee80211.h                                          |   10 +-
 include/linux/if_macvlan.h                                         |   37 +-
 include/linux/if_tunnel.h                                          |    9 -
 include/linux/if_vlan.h                                            |   38 +-
 include/linux/inet_lro.h                                           |   23 -
 include/linux/inetdevice.h                                         |   14 +-
 include/linux/ipv6.h                                               |    8 +-
 include/linux/kernel.h                                             |   19 +
 include/linux/mdio.h                                               |    3 -
 include/linux/mlx4/cmd.h                                           |    1 +
 include/linux/mlx4/cq.h                                            |    5 +
 include/linux/mlx4/device.h                                        |   39 +-
 include/linux/mlx4/qp.h                                            |    6 +
 include/linux/mmc/sdio_ids.h                                       |    9 +
 include/linux/net.h                                                |    3 -
 include/linux/netdevice.h                                          |  156 +-
 include/linux/netfilter/ipset/ip_set.h                             |    1 -
 include/linux/netlink.h                                            |    2 -
 include/linux/of_mdio.h                                            |   10 +
 include/linux/phy.h                                                |  116 +-
 include/linux/platform_data/eth-netx.h                             |    6 +-
 include/linux/platform_data/pn544.h                                |    3 +-
 include/linux/printk.h                                             |    7 +
 include/linux/random.h                                             |   18 +-
 include/linux/reciprocal_div.h                                     |   39 +-
 include/linux/sctp.h                                               |    7 +-
 include/linux/sh_eth.h                                             |    1 +
 include/linux/skbuff.h                                             |  229 +-
 include/linux/slab_def.h                                           |    4 +-
 include/linux/socket.h                                             |   16 +-
 include/linux/stmmac.h                                             |   26 +-
 include/linux/tcp.h                                                |    5 +-
 include/net/Space.h                                                |   31 +
 include/net/act_api.h                                              |   63 +-
 include/net/addrconf.h                                             |   16 +-
 include/net/arp.h                                                  |    1 -
 include/net/bluetooth/bluetooth.h                                  |    3 +
 include/net/bluetooth/hci.h                                        |   10 +-
 include/net/bluetooth/hci_core.h                                   |    7 +
 include/net/bluetooth/l2cap.h                                      |   46 +
 include/net/cfg80211.h                                             |  323 ++-
 include/net/cipso_ipv4.h                                           |    5 +-
 include/net/cls_cgroup.h                                           |   40 +-
 include/net/codel.h                                                |    4 +-
 include/net/dcbevent.h                                             |    3 +-
 include/net/dcbnl.h                                                |    3 +-
 include/net/dn_dev.h                                               |    2 +-
 include/net/dst.h                                                  |    5 +-
 include/net/flow.h                                                 |    3 +-
 include/net/genetlink.h                                            |    4 +
 include/net/gre.h                                                  |    3 -
 include/net/if_inet6.h                                             |    2 +-
 include/net/inet_timewait_sock.h                                   |    6 +-
 include/net/inetpeer.h                                             |    1 -
 include/net/ip.h                                                   |   42 +-
 include/net/ip6_fib.h                                              |    2 +-
 include/net/ip6_route.h                                            |   34 +-
 include/net/ip6_tunnel.h                                           |    2 +-
 include/net/ip_tunnels.h                                           |   10 +-
 include/net/ipv6.h                                                 |   26 +-
 include/net/irda/discovery.h                                       |    4 +-
 include/net/irda/ircomm_core.h                                     |    4 +-
 include/net/irda/ircomm_event.h                                    |    4 +-
 include/net/irda/ircomm_lmp.h                                      |    4 +-
 include/net/irda/ircomm_param.h                                    |    4 +-
 include/net/irda/ircomm_ttp.h                                      |    4 +-
 include/net/irda/ircomm_tty.h                                      |    4 +-
 include/net/irda/ircomm_tty_attach.h                               |    4 +-
 include/net/irda/irda_device.h                                     |    4 +-
 include/net/irda/irlap_event.h                                     |    4 +-
 include/net/irda/irlap_frame.h                                     |    4 +-
 include/net/irda/parameters.h                                      |    4 +-
 include/net/irda/qos.h                                             |    4 +-
 include/net/llc.h                                                  |    1 -
 include/net/mac80211.h                                             |  138 +-
 include/net/mip6.h                                                 |    3 +-
 include/net/neighbour.h                                            |   83 +-
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h                     |    2 -
 include/net/netfilter/ipv4/nf_reject.h                             |  128 +
 include/net/netfilter/ipv6/nf_reject.h                             |  171 ++
 include/net/netfilter/nf_conntrack_l3proto.h                       |    1 -
 include/net/netfilter/nf_queue.h                                   |   62 +
 include/net/netfilter/nf_tables.h                                  |   47 +-
 include/net/netfilter/nf_tables_ipv4.h                             |    5 +-
 include/net/netfilter/nf_tables_ipv6.h                             |    3 +
 include/net/netlabel.h                                             |    3 +-
 include/net/netns/conntrack.h                                      |   33 +-
 include/net/netns/ipv4.h                                           |    2 +
 include/net/netns/ipv6.h                                           |    2 +
 include/net/netns/nftables.h                                       |    1 +
 include/net/netns/xfrm.h                                           |    6 +-
 include/net/netprio_cgroup.h                                       |   18 +-
 include/net/nfc/digital.h                                          |   10 +
 include/net/nfc/hci.h                                              |    4 +-
 include/net/nfc/llc.h                                              |    4 +-
 include/net/nfc/nci.h                                              |    3 +-
 include/net/nfc/nci_core.h                                         |    5 +-
 include/net/nfc/nfc.h                                              |    4 +-
 include/net/ping.h                                                 |   16 +-
 include/net/pkt_cls.h                                              |   67 +-
 include/net/pkt_sched.h                                            |    1 +
 include/net/protocol.h                                             |   10 +-
 include/net/red.h                                                  |    5 +-
 include/net/regulatory.h                                           |   84 +-
 include/net/route.h                                                |   27 +-
 include/net/rtnetlink.h                                            |   17 +-
 include/net/sch_generic.h                                          |    4 +-
 include/net/sctp/auth.h                                            |    5 +-
 include/net/sctp/checksum.h                                        |    5 +-
 include/net/sctp/command.h                                         |    5 +-
 include/net/sctp/constants.h                                       |    5 +-
 include/net/sctp/sctp.h                                            |   32 +-
 include/net/sctp/sm.h                                              |    5 +-
 include/net/sctp/structs.h                                         |   65 +-
 include/net/sctp/tsnmap.h                                          |    5 +-
 include/net/sctp/ulpevent.h                                        |    5 +-
 include/net/sctp/ulpqueue.h                                        |    5 +-
 include/net/sock.h                                                 |   26 +-
 include/net/tc_act/tc_skbedit.h                                    |    3 +-
 include/net/tcp.h                                                  |   11 +-
 include/net/transp_v6.h                                            |    9 +-
 include/net/vxlan.h                                                |    1 +
 include/net/xfrm.h                                                 |   16 +-
 include/trace/events/net.h                                         |  158 +
 include/uapi/asm-generic/socket.h                                  |    2 +
 include/uapi/linux/if_addr.h                                       |    6 +
 include/uapi/linux/if_arp.h                                        |    1 +
 include/uapi/linux/if_link.h                                       |   48 +
 include/uapi/linux/if_packet.h                                     |   29 +-
 include/uapi/linux/in6.h                                           |    6 +
 include/uapi/linux/net_tstamp.h                                    |   16 +-
 include/uapi/linux/netconf.h                                       |    1 +
 include/uapi/linux/netfilter.h                                     |    1 +
 include/uapi/linux/netfilter/Kbuild                                |    3 +
 include/uapi/linux/netfilter/nf_nat.h                              |   12 +-
 include/uapi/linux/netfilter/nf_tables.h                           |   30 +
 include/uapi/linux/netfilter/nfnetlink_queue.h                     |    5 +-
 include/uapi/linux/netfilter/xt_cgroup.h                           |   11 +
 include/uapi/linux/netfilter/xt_ipcomp.h                           |   16 +
 include/uapi/linux/netfilter/xt_l2tp.h                             |   27 +
 include/uapi/linux/netfilter/xt_osf.h                              |    3 +-
 include/uapi/linux/nl80211.h                                       |  129 +-
 include/uapi/linux/openvswitch.h                                   |   14 +-
 include/uapi/linux/pci_regs.h                                      |    5 +
 include/uapi/linux/pkt_sched.h                                     |   53 +
 include/uapi/linux/sctp.h                                          |    5 +-
 include/uapi/linux/snmp.h                                          |    1 +
 include/uapi/linux/sockios.h                                       |    3 +-
 include/uapi/linux/tc_act/tc_ipt.h                                 |    1 +
 include/uapi/linux/tcp_metrics.h                                   |    2 +
 lib/Makefile                                                       |    2 +-
 lib/average.c                                                      |    6 +-
 lib/flex_array.c                                                   |    7 +-
 lib/hash.c                                                         |   39 +
 lib/kobject_uevent.c                                               |   10 +-
 lib/reciprocal_div.c                                               |   24 +-
 net/802/garp.c                                                     |    2 +-
 net/802/hippi.c                                                    |    4 +-
 net/802/mrp.c                                                      |    2 +-
 net/8021q/Kconfig                                                  |   10 +-
 net/8021q/vlan.c                                                   |    2 +-
 net/8021q/vlan_dev.c                                               |    6 +-
 net/Kconfig                                                        |   11 +-
 net/Makefile                                                       |    2 +-
 net/appletalk/aarp.c                                               |   13 +-
 net/appletalk/ddp.c                                                |    4 +-
 net/atm/lec.c                                                      |    9 +-
 net/atm/mpc.c                                                      |    2 +-
 net/ax25/af_ax25.c                                                 |    4 +-
 net/batman-adv/Makefile                                            |    6 +-
 net/batman-adv/bat_algo.h                                          |    6 +-
 net/batman-adv/bat_iv_ogm.c                                        |  888 ++++--
 net/batman-adv/bitarray.c                                          |    6 +-
 net/batman-adv/bitarray.h                                          |    6 +-
 net/batman-adv/bridge_loop_avoidance.c                             |   30 +-
 net/batman-adv/bridge_loop_avoidance.h                             |    6 +-
 net/batman-adv/debugfs.c                                           |   95 +-
 net/batman-adv/debugfs.h                                           |    8 +-
 net/batman-adv/distributed-arp-table.c                             |   15 +-
 net/batman-adv/distributed-arp-table.h                             |   12 +-
 net/batman-adv/fragmentation.c                                     |    6 +-
 net/batman-adv/fragmentation.h                                     |    6 +-
 net/batman-adv/gateway_client.c                                    |  303 +-
 net/batman-adv/gateway_client.h                                    |   12 +-
 net/batman-adv/gateway_common.c                                    |    8 +-
 net/batman-adv/gateway_common.h                                    |    6 +-
 net/batman-adv/hard-interface.c                                    |   19 +-
 net/batman-adv/hard-interface.h                                    |   24 +-
 net/batman-adv/hash.c                                              |    6 +-
 net/batman-adv/hash.h                                              |    6 +-
 net/batman-adv/icmp_socket.c                                       |    9 +-
 net/batman-adv/icmp_socket.h                                       |    6 +-
 net/batman-adv/main.c                                              |   56 +-
 net/batman-adv/main.h                                              |   19 +-
 net/batman-adv/network-coding.c                                    |   55 +-
 net/batman-adv/network-coding.h                                    |   13 +-
 net/batman-adv/originator.c                                        |  542 +++-
 net/batman-adv/originator.h                                        |   26 +-
 net/batman-adv/packet.h                                            |    7 +-
 net/batman-adv/routing.c                                           |  441 +--
 net/batman-adv/routing.h                                           |   18 +-
 net/batman-adv/send.c                                              |   41 +-
 net/batman-adv/send.h                                              |   16 +-
 net/batman-adv/soft-interface.c                                    |  111 +-
 net/batman-adv/soft-interface.h                                    |    6 +-
 net/batman-adv/sysfs.c                                             |   94 +-
 net/batman-adv/sysfs.h                                             |    6 +-
 net/batman-adv/translation-table.c                                 |   94 +-
 net/batman-adv/translation-table.h                                 |   10 +-
 net/batman-adv/types.h                                             |  150 +-
 net/bluetooth/6lowpan.c                                            |  860 ++++++
 net/bluetooth/6lowpan.h                                            |   26 +
 net/bluetooth/Kconfig                                              |    1 +
 net/bluetooth/Makefile                                             |    2 +-
 net/bluetooth/af_bluetooth.c                                       |    2 +-
 net/bluetooth/bnep/bnep.h                                          |    3 +-
 net/bluetooth/hci_core.c                                           |   78 +-
 net/bluetooth/hci_event.c                                          |   75 +-
 net/bluetooth/l2cap_core.c                                         |  756 ++++-
 net/bluetooth/l2cap_sock.c                                         |  186 +-
 net/bluetooth/mgmt.c                                               |   17 +-
 net/bluetooth/rfcomm/tty.c                                         |  103 +-
 net/bluetooth/smp.c                                                |   56 +-
 net/bluetooth/smp.h                                                |    1 +
 net/bridge/br.c                                                    |   21 +-
 net/bridge/br_device.c                                             |   10 +-
 net/bridge/br_fdb.c                                                |    3 +-
 net/bridge/br_forward.c                                            |    6 +-
 net/bridge/br_if.c                                                 |   17 +-
 net/bridge/br_input.c                                              |    2 +-
 net/bridge/br_ioctl.c                                              |    2 +-
 net/bridge/br_netfilter.c                                          |    2 +-
 net/bridge/br_netlink.c                                            |   12 +-
 net/bridge/br_private.h                                            |   13 +-
 net/bridge/br_stp_timer.c                                          |    2 +-
 net/bridge/br_sysfs_br.c                                           |  249 +-
 net/bridge/br_sysfs_if.c                                           |   20 +-
 net/bridge/br_vlan.c                                               |   23 +-
 net/bridge/netfilter/ebt_log.c                                     |    2 +-
 net/bridge/netfilter/ebt_snat.c                                    |    2 +-
 net/bridge/netfilter/ebt_vlan.c                                    |    3 +-
 net/bridge/netfilter/ebtable_broute.c                              |    6 +-
 net/bridge/netfilter/ebtable_filter.c                              |    9 +-
 net/bridge/netfilter/ebtable_nat.c                                 |    9 +-
 net/bridge/netfilter/ebtables.c                                    |   17 +-
 net/bridge/netfilter/nf_tables_bridge.c                            |   44 +-
 net/caif/caif_usb.c                                                |    5 +-
 net/caif/chnl_net.c                                                |    3 +-
 net/can/bcm.c                                                      |    4 +-
 net/can/gw.c                                                       |   21 +-
 net/can/raw.c                                                      |    4 +-
 net/core/Makefile                                                  |    3 +-
 net/core/dev.c                                                     |  562 ++--
 net/core/dev_addr_lists.c                                          |  115 +-
 net/core/dev_ioctl.c                                               |    2 +
 net/core/flow_dissector.c                                          |    6 +-
 net/core/neighbour.c                                               |  477 +--
 net/core/net-sysfs.c                                               |   82 +-
 net/core/net-sysfs.h                                               |    2 +-
 net/core/netclassid_cgroup.c                                       |  120 +
 net/core/netpoll.c                                                 |    4 +-
 net/core/netprio_cgroup.c                                          |    2 +-
 net/core/pktgen.c                                                  |   88 +-
 net/core/rtnetlink.c                                               |  176 +-
 net/core/skbuff.c                                                  |  366 ++-
 net/core/sock.c                                                    |   43 +-
 net/core/stream.c                                                  |    2 +-
 net/core/sysctl_net_core.c                                         |    3 +-
 net/dcb/dcbevent.c                                                 |    3 +-
 net/dcb/dcbnl.c                                                    |   18 +-
 net/dccp/ccids/lib/tfrc.c                                          |    2 +-
 net/dccp/ccids/lib/tfrc.h                                          |    1 -
 net/dccp/dccp.h                                                    |    1 -
 net/dccp/ipv4.c                                                    |    3 +-
 net/dccp/ipv6.c                                                    |   11 +-
 net/dccp/options.c                                                 |   32 -
 net/decnet/af_decnet.c                                             |    3 +-
 net/decnet/dn_dev.c                                                |   13 +-
 net/decnet/dn_neigh.c                                              |   28 +-
 net/decnet/dn_route.c                                              |   12 +-
 net/dns_resolver/dns_key.c                                         |    3 +-
 net/dns_resolver/dns_query.c                                       |    3 +-
 net/dns_resolver/internal.h                                        |    3 +-
 net/dsa/slave.c                                                    |    2 +-
 net/ethernet/eth.c                                                 |    7 +-
 net/hsr/hsr_framereg.c                                             |   13 +-
 net/ieee802154/6lowpan.c                                           |  796 +----
 net/ieee802154/6lowpan.h                                           |   72 +
 net/ieee802154/6lowpan_iphc.c                                      |  802 +++++
 net/ieee802154/Kconfig                                             |    7 +
 net/ieee802154/Makefile                                            |    1 +
 net/ieee802154/dgram.c                                             |    4 +-
 net/ieee802154/wpan-class.c                                        |    2 +-
 net/ipv4/Makefile                                                  |    4 +-
 net/ipv4/af_inet.c                                                 |   43 +-
 net/ipv4/arp.c                                                     |   53 +-
 net/ipv4/cipso_ipv4.c                                              |   12 +-
 net/ipv4/datagram.c                                                |    2 +-
 net/ipv4/devinet.c                                                 |   76 +-
 net/ipv4/fib_frontend.c                                            |    2 +
 net/ipv4/fib_lookup.h                                              |    2 -
 net/ipv4/fib_semantics.c                                           |    5 +-
 net/ipv4/gre_demux.c                                               |    9 -
 net/ipv4/gre_offload.c                                             |  185 +-
 net/ipv4/icmp.c                                                    |   26 +-
 net/ipv4/igmp.c                                                    |   84 +-
 net/ipv4/inet_connection_sock.c                                    |    2 +-
 net/ipv4/inet_lro.c                                                |  173 --
 net/ipv4/inetpeer.c                                                |   11 +-
 net/ipv4/ip_forward.c                                              |    7 +-
 net/ipv4/ip_fragment.c                                             |    2 +-
 net/ipv4/ip_gre.c                                                  |    4 +-
 net/ipv4/ip_options.c                                              |   42 +-
 net/ipv4/ip_output.c                                               |   12 +-
 net/ipv4/ip_sockglue.c                                             |   11 +-
 net/ipv4/ip_tunnel.c                                               |  150 +-
 net/ipv4/ip_tunnel_core.c                                          |    5 +-
 net/ipv4/ip_vti.c                                                  |    4 +-
 net/ipv4/ipip.c                                                    |    2 +-
 net/ipv4/ipmr.c                                                    |    2 +
 net/ipv4/netfilter/Kconfig                                         |   18 +-
 net/ipv4/netfilter/Makefile                                        |    1 -
 net/ipv4/netfilter/ipt_REJECT.c                                    |  140 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                     |    6 -
 net/ipv4/netfilter/nf_nat_snmp_basic.c                             |   15 +-
 net/ipv4/netfilter/nf_tables_arp.c                                 |   44 +-
 net/ipv4/netfilter/nf_tables_ipv4.c                                |   60 +-
 net/ipv4/netfilter/nft_chain_nat_ipv4.c                            |   10 +-
 net/ipv4/netfilter/nft_chain_route_ipv4.c                          |   10 +-
 net/ipv4/ping.c                                                    |   27 +-
 net/ipv4/proc.c                                                    |    9 +-
 net/ipv4/raw.c                                                     |    6 +-
 net/ipv4/route.c                                                   |    3 -
 net/ipv4/syncookies.c                                              |    2 +-
 net/ipv4/sysctl_net_ipv4.c                                         |   32 +-
 net/ipv4/tcp.c                                                     |   71 +-
 net/ipv4/tcp_input.c                                               |    6 +-
 net/ipv4/tcp_ipv4.c                                                |    5 +-
 net/ipv4/tcp_metrics.c                                             |  194 +-
 net/ipv4/tcp_minisocks.c                                           |    3 +-
 net/ipv4/tcp_offload.c                                             |   18 +-
 net/ipv4/tcp_output.c                                              |  141 +-
 net/ipv4/tcp_probe.c                                               |    4 +-
 net/ipv4/tcp_yeah.c                                                |   20 +-
 net/ipv4/udp.c                                                     |    8 +-
 net/ipv4/udp_offload.c                                             |  143 +
 net/ipv4/xfrm4_mode_beet.c                                         |    2 +-
 net/ipv4/xfrm4_state.c                                             |    2 +-
 net/ipv6/addrconf.c                                                |  513 ++--
 net/ipv6/af_inet6.c                                                |    8 +-
 net/ipv6/ah6.c                                                     |    3 +-
 net/ipv6/anycast.c                                                 |   11 +
 net/ipv6/datagram.c                                                |   60 +-
 net/ipv6/esp6.c                                                    |    3 +-
 net/ipv6/fib6_rules.c                                              |    2 +-
 net/ipv6/icmp.c                                                    |   20 +-
 net/ipv6/inet6_connection_sock.c                                   |    4 +-
 net/ipv6/ip6_fib.c                                                 |    6 +-
 net/ipv6/ip6_flowlabel.c                                           |   38 +-
 net/ipv6/ip6_gre.c                                                 |   15 +-
 net/ipv6/ip6_offload.c                                             |   53 +-
 net/ipv6/ip6_output.c                                              |   66 +-
 net/ipv6/ip6_tunnel.c                                              |   17 +-
 net/ipv6/ip6_vti.c                                                 |    7 +-
 net/ipv6/ipcomp6.c                                                 |    3 +-
 net/ipv6/ipv6_sockglue.c                                           |   19 +-
 net/ipv6/mcast.c                                                   |   67 +-
 net/ipv6/mip6.c                                                    |    3 +-
 net/ipv6/ndisc.c                                                   |   55 +-
 net/ipv6/netfilter/Kconfig                                         |   12 +
 net/ipv6/netfilter/ip6t_REJECT.c                                   |  179 +-
 net/ipv6/netfilter/nf_tables_ipv6.c                                |   65 +-
 net/ipv6/netfilter/nft_chain_nat_ipv6.c                            |   10 +-
 net/ipv6/netfilter/nft_chain_route_ipv6.c                          |   10 +-
 net/ipv6/ping.c                                                    |   16 +-
 net/ipv6/raw.c                                                     |   12 +-
 net/ipv6/route.c                                                   |   68 +-
 net/ipv6/sit.c                                                     |   10 +-
 net/ipv6/syncookies.c                                              |    2 +-
 net/ipv6/sysctl_net_ipv6.c                                         |   16 +
 net/ipv6/tcp_ipv6.c                                                |   67 +-
 net/ipv6/tcpv6_offload.c                                           |    6 +-
 net/ipv6/tunnel6.c                                                 |    3 +-
 net/ipv6/udp.c                                                     |   19 +-
 net/ipv6/xfrm6_mode_ro.c                                           |    3 +-
 net/ipv6/xfrm6_tunnel.c                                            |    3 +-
 net/ipx/af_ipx.c                                                   |    4 +-
 net/irda/af_irda.c                                                 |    6 +-
 net/irda/discovery.c                                               |    4 +-
 net/irda/ircomm/ircomm_core.c                                      |    4 +-
 net/irda/ircomm/ircomm_event.c                                     |    4 +-
 net/irda/ircomm/ircomm_lmp.c                                       |    4 +-
 net/irda/ircomm/ircomm_param.c                                     |    4 +-
 net/irda/ircomm/ircomm_ttp.c                                       |    4 +-
 net/irda/ircomm/ircomm_tty.c                                       |    4 +-
 net/irda/ircomm/ircomm_tty_attach.c                                |    4 +-
 net/irda/ircomm/ircomm_tty_ioctl.c                                 |    4 +-
 net/irda/irda_device.c                                             |    4 +-
 net/irda/irlap.c                                                   |    4 +-
 net/irda/parameters.c                                              |    4 +-
 net/irda/qos.c                                                     |    4 +-
 net/key/af_key.c                                                   |   29 +-
 net/l2tp/l2tp_core.c                                               |    6 +-
 net/l2tp/l2tp_core.h                                               |    2 -
 net/l2tp/l2tp_ip.c                                                 |    4 +-
 net/l2tp/l2tp_ip6.c                                                |   10 +-
 net/llc/af_llc.c                                                   |    4 +-
 net/llc/llc_conn.c                                                 |    4 +-
 net/llc/llc_core.c                                                 |    5 +-
 net/llc/llc_sap.c                                                  |    4 +-
 net/mac80211/aes_cmac.c                                            |    2 +-
 net/mac80211/aes_cmac.h                                            |    2 +-
 net/mac80211/cfg.c                                                 |  208 +-
 net/mac80211/chan.c                                                |  208 +-
 net/mac80211/debugfs.c                                             |  168 ++
 net/mac80211/debugfs_netdev.c                                      |   61 +-
 net/mac80211/debugfs_sta.c                                         |  134 +
 net/mac80211/driver-ops.h                                          |   32 +-
 net/mac80211/ht.c                                                  |    5 +-
 net/mac80211/ibss.c                                                |   85 +-
 net/mac80211/ieee80211_i.h                                         |   77 +-
 net/mac80211/iface.c                                               |   78 +-
 net/mac80211/key.c                                                 |  122 +-
 net/mac80211/key.h                                                 |   16 +-
 net/mac80211/main.c                                                |  177 +-
 net/mac80211/mesh.c                                                |   13 +-
 net/mac80211/mesh.h                                                |    6 +-
 net/mac80211/mesh_hwmp.c                                           |   91 +-
 net/mac80211/mesh_pathtbl.c                                        |    7 +-
 net/mac80211/mesh_plink.c                                          |  709 ++---
 net/mac80211/mesh_ps.c                                             |    3 +-
 net/mac80211/mesh_sync.c                                           |   37 +-
 net/mac80211/mlme.c                                                |   64 +-
 net/mac80211/pm.c                                                  |    3 +-
 net/mac80211/rate.h                                                |    4 +-
 net/mac80211/rc80211_minstrel.c                                    |   11 +-
 net/mac80211/rc80211_minstrel_ht.c                                 |   24 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c                         |    3 +-
 net/mac80211/rx.c                                                  |  161 +-
 net/mac80211/scan.c                                                |   90 +-
 net/mac80211/sta_info.c                                            |  346 ++-
 net/mac80211/sta_info.h                                            |   68 +-
 net/mac80211/status.c                                              |   78 +
 net/mac80211/tkip.c                                                |    2 +-
 net/mac80211/trace.h                                               |  108 +-
 net/mac80211/tx.c                                                  |   59 +-
 net/mac80211/util.c                                                |  320 +-
 net/mac80211/vht.c                                                 |    7 +-
 net/mac80211/wme.c                                                 |    7 +-
 net/mac80211/wpa.c                                                 |  118 +-
 net/mac80211/wpa.h                                                 |    2 +
 net/mac802154/wpan.c                                               |    4 +-
 net/netfilter/Kconfig                                              |   96 +-
 net/netfilter/Makefile                                             |    7 +-
 net/netfilter/ipset/ip_set_core.c                                  |   28 -
 net/netfilter/ipvs/ip_vs_conn.c                                    |    2 +-
 net/netfilter/ipvs/ip_vs_nfct.c                                    |    3 +-
 net/netfilter/ipvs/ip_vs_sync.c                                    |    5 +-
 net/netfilter/nf_conntrack_core.c                                  |   15 -
 net/netfilter/nf_conntrack_netlink.c                               |   12 +-
 net/netfilter/nf_conntrack_proto.c                                 |    6 -
 net/netfilter/nf_conntrack_proto_dccp.c                            |   10 +-
 net/netfilter/nf_nat_core.c                                        |    4 +-
 net/netfilter/nf_nat_proto_common.c                                |   10 +-
 net/netfilter/nf_tables_api.c                                      |  327 ++-
 net/netfilter/nf_tables_core.c                                     |   11 +-
 net/netfilter/nf_tables_inet.c                                     |  104 +
 net/netfilter/nfnetlink_queue_core.c                               |   94 +-
 net/netfilter/nft_compat.c                                         |    8 +-
 net/netfilter/nft_ct.c                                             |  201 +-
 net/netfilter/nft_log.c                                            |    2 +-
 net/netfilter/nft_meta.c                                           |  157 +-
 net/netfilter/nft_meta_target.c                                    |  117 -
 net/netfilter/nft_queue.c                                          |  134 +
 net/{ipv4/netfilter/nft_reject_ipv4.c => netfilter/nft_reject.c}   |   26 +-
 net/netfilter/xt_CT.c                                              |    4 +-
 net/netfilter/xt_NFQUEUE.c                                         |   80 +-
 net/netfilter/xt_cgroup.c                                          |   71 +
 net/netfilter/xt_connmark.c                                        |    3 +-
 net/netfilter/xt_ipcomp.c                                          |  111 +
 net/netfilter/xt_l2tp.c                                            |  354 +++
 net/netfilter/xt_osf.c                                             |    3 +-
 net/netfilter/xt_statistic.c                                       |    2 +-
 net/netlabel/netlabel_addrlist.c                                   |    3 +-
 net/netlabel/netlabel_addrlist.h                                   |    3 +-
 net/netlabel/netlabel_cipso_v4.c                                   |    3 +-
 net/netlabel/netlabel_cipso_v4.h                                   |    3 +-
 net/netlabel/netlabel_domainhash.c                                 |    3 +-
 net/netlabel/netlabel_domainhash.h                                 |    3 +-
 net/netlabel/netlabel_kapi.c                                       |    3 +-
 net/netlabel/netlabel_mgmt.c                                       |    3 +-
 net/netlabel/netlabel_mgmt.h                                       |    3 +-
 net/netlabel/netlabel_unlabeled.c                                  |    3 +-
 net/netlabel/netlabel_unlabeled.h                                  |    3 +-
 net/netlabel/netlabel_user.c                                       |    3 +-
 net/netlabel/netlabel_user.h                                       |    3 +-
 net/netlink/af_netlink.c                                           |   41 +-
 net/netlink/genetlink.c                                            |   21 +
 net/netrom/af_netrom.c                                             |    4 +-
 net/nfc/af_nfc.c                                                   |    4 +-
 net/nfc/core.c                                                     |   11 +-
 net/nfc/digital_core.c                                             |   28 +-
 net/nfc/digital_dep.c                                              |   54 +-
 net/nfc/hci/command.c                                              |    4 +-
 net/nfc/hci/core.c                                                 |   11 +-
 net/nfc/hci/hci.h                                                  |    4 +-
 net/nfc/hci/hcp.c                                                  |    4 +-
 net/nfc/hci/llc.c                                                  |    4 +-
 net/nfc/hci/llc.h                                                  |    4 +-
 net/nfc/hci/llc_nop.c                                              |    4 +-
 net/nfc/hci/llc_shdlc.c                                            |    6 +-
 net/nfc/llcp.h                                                     |    4 +-
 net/nfc/llcp_commands.c                                            |   10 +-
 net/nfc/llcp_core.c                                                |    5 +-
 net/nfc/llcp_sock.c                                                |   13 +-
 net/nfc/nci/core.c                                                 |   30 +-
 net/nfc/nci/data.c                                                 |    3 +-
 net/nfc/nci/lib.c                                                  |    3 +-
 net/nfc/nci/ntf.c                                                  |    3 +-
 net/nfc/nci/rsp.c                                                  |    3 +-
 net/nfc/netlink.c                                                  |    4 +-
 net/nfc/nfc.h                                                      |    4 +-
 net/nfc/rawsock.c                                                  |    4 +-
 net/openvswitch/actions.c                                          |   12 +-
 net/openvswitch/datapath.c                                         |  231 +-
 net/openvswitch/datapath.h                                         |    6 +-
 net/openvswitch/flow.c                                             |   96 +-
 net/openvswitch/flow.h                                             |   33 +-
 net/openvswitch/flow_netlink.c                                     |   66 +-
 net/openvswitch/flow_netlink.h                                     |    1 +
 net/openvswitch/flow_table.c                                       |   64 +-
 net/openvswitch/flow_table.h                                       |    6 +-
 net/openvswitch/vport.c                                            |   18 +-
 net/openvswitch/vport.h                                            |    3 +-
 net/packet/af_packet.c                                             |  299 +-
 net/packet/diag.c                                                  |    1 +
 net/packet/internal.h                                              |    3 +-
 net/phonet/datagram.c                                              |    6 +-
 net/rds/bind.c                                                     |    2 +-
 net/rds/recv.c                                                     |    3 +-
 net/rds/send.c                                                     |    2 +-
 net/rfkill/core.c                                                  |    4 +-
 net/rose/af_rose.c                                                 |    7 +-
 net/rose/rose_dev.c                                                |    2 +-
 net/rxrpc/ar-ack.c                                                 |   21 +-
 net/rxrpc/ar-output.c                                              |    4 +-
 net/sched/Kconfig                                                  |   23 +
 net/sched/Makefile                                                 |    2 +
 net/sched/act_api.c                                                |  435 ++-
 net/sched/act_csum.c                                               |   24 +-
 net/sched/act_gact.c                                               |   28 +-
 net/sched/act_ipt.c                                                |   33 +-
 net/sched/act_mirred.c                                             |   27 +-
 net/sched/act_nat.c                                                |   25 +-
 net/sched/act_pedit.c                                              |   25 +-
 net/sched/act_police.c                                             |   93 +-
 net/sched/act_simple.c                                             |   29 +-
 net/sched/act_skbedit.c                                            |   27 +-
 net/sched/cls_api.c                                                |  130 +-
 net/sched/cls_basic.c                                              |   25 +-
 net/sched/cls_bpf.c                                                |   17 +-
 net/sched/cls_cgroup.c                                             |  127 +-
 net/sched/cls_flow.c                                               |   17 +-
 net/sched/cls_fw.c                                                 |   50 +-
 net/sched/cls_route.c                                              |   21 +-
 net/sched/cls_rsvp.h                                               |   15 +-
 net/sched/cls_tcindex.c                                            |   36 +-
 net/sched/cls_u32.c                                                |   38 +-
 net/sched/em_meta.c                                                |  159 +-
 net/sched/sch_api.c                                                |   10 +-
 net/sched/sch_cbq.c                                                |   10 +-
 net/sched/sch_choke.c                                              |    9 +-
 net/sched/sch_dsmark.c                                             |   39 +-
 net/sched/sch_fq.c                                                 |   36 +-
 net/sched/sch_fq_codel.c                                           |    2 +-
 net/sched/sch_generic.c                                            |    6 +-
 net/sched/sch_gred.c                                               |    4 +-
 net/sched/sch_hhf.c                                                |  745 +++++
 net/sched/sch_htb.c                                                |   46 +-
 net/sched/sch_mq.c                                                 |   13 +-
 net/sched/sch_mqprio.c                                             |   10 +-
 net/sched/sch_multiq.c                                             |    3 +-
 net/sched/sch_netem.c                                              |   91 +-
 net/sched/sch_pie.c                                                |  555 ++++
 net/sched/sch_sfb.c                                                |    4 +-
 net/sched/sch_sfq.c                                                |   16 +-
 net/sched/sch_tbf.c                                                |   29 +-
 net/sctp/associola.c                                               |   70 +-
 net/sctp/auth.c                                                    |   32 +-
 net/sctp/bind_addr.c                                               |    5 +-
 net/sctp/chunk.c                                                   |    9 +-
 net/sctp/command.c                                                 |    5 +-
 net/sctp/debug.c                                                   |    5 +-
 net/sctp/endpointola.c                                             |    9 +-
 net/sctp/input.c                                                   |  136 +-
 net/sctp/inqueue.c                                                 |    5 +-
 net/sctp/ipv6.c                                                    |   14 +-
 net/sctp/objcnt.c                                                  |    7 +-
 net/sctp/output.c                                                  |   24 +-
 net/sctp/outqueue.c                                                |   13 +-
 net/sctp/primitive.c                                               |    5 +-
 net/sctp/proc.c                                                    |   25 +-
 net/sctp/protocol.c                                                |   15 +-
 net/sctp/sm_make_chunk.c                                           |   82 +-
 net/sctp/sm_sideeffect.c                                           |   27 +-
 net/sctp/sm_statefuns.c                                            |   32 +-
 net/sctp/sm_statetable.c                                           |    7 +-
 net/sctp/socket.c                                                  |  239 +-
 net/sctp/ssnmap.c                                                  |    5 +-
 net/sctp/sysctl.c                                                  |    7 +-
 net/sctp/transport.c                                               |    5 +-
 net/sctp/tsnmap.c                                                  |    5 +-
 net/sctp/ulpevent.c                                                |    5 +-
 net/sctp/ulpqueue.c                                                |   16 +-
 net/socket.c                                                       |  106 +-
 net/sunrpc/cache.c                                                 |    2 +-
 net/sunrpc/xprt.c                                                  |    2 +-
 net/sunrpc/xprtsock.c                                              |    2 +-
 net/tipc/bcast.c                                                   |    8 +-
 net/tipc/bearer.c                                                  |  342 ++-
 net/tipc/bearer.h                                                  |   56 +-
 net/tipc/core.c                                                    |    8 +-
 net/tipc/core.h                                                    |    2 +-
 net/tipc/discover.c                                                |   28 +-
 net/tipc/eth_media.c                                               |  326 +--
 net/tipc/ib_media.c                                                |  319 +-
 net/tipc/link.c                                                    |  222 +-
 net/tipc/link.h                                                    |   25 +-
 net/tipc/name_table.c                                              |    3 +-
 net/tipc/node.c                                                    |   15 +-
 net/tipc/node.h                                                    |    3 -
 net/tipc/port.c                                                    |    9 +-
 net/tipc/server.c                                                  |    2 +-
 net/tipc/socket.c                                                  |  330 ++-
 net/tipc/subscr.c                                                  |    2 +-
 net/unix/af_unix.c                                                 |   13 +-
 net/vmw_vsock/vmci_transport.c                                     |    4 +-
 net/wireless/ap.c                                                  |    1 +
 net/wireless/chan.c                                                |  203 +-
 net/wireless/core.c                                                |   31 +-
 net/wireless/core.h                                                |   24 +-
 net/wireless/genregdb.awk                                          |   45 +-
 net/wireless/ibss.c                                                |    6 +-
 net/wireless/mesh.c                                                |   17 +-
 net/wireless/mlme.c                                                |   20 +-
 net/wireless/nl80211.c                                             |  766 +++--
 net/wireless/nl80211.h                                             |    2 +-
 net/wireless/rdev-ops.h                                            |   27 +-
 net/wireless/reg.c                                                 |  831 +++---
 net/wireless/reg.h                                                 |    4 +-
 net/wireless/scan.c                                                |   23 +-
 net/wireless/sme.c                                                 |   15 +-
 net/wireless/trace.h                                               |   55 +-
 net/wireless/util.c                                                |   34 +-
 net/wireless/wext-compat.c                                         |    6 +-
 net/x25/af_x25.c                                                   |    8 +-
 net/x25/x25_dev.c                                                  |   10 +-
 net/x25/x25_facilities.c                                           |   14 +-
 net/x25/x25_forward.c                                              |    5 +-
 net/x25/x25_in.c                                                   |    4 +-
 net/x25/x25_link.c                                                 |    6 +-
 net/x25/x25_subr.c                                                 |    6 +-
 net/xfrm/xfrm_input.c                                              |    6 +-
 net/xfrm/xfrm_policy.c                                             |  195 +-
 net/xfrm/xfrm_proc.c                                               |    2 +-
 net/xfrm/xfrm_state.c                                              |  191 +-
 net/xfrm/xfrm_user.c                                               |   62 +-
 tools/net/Makefile                                                 |   23 +-
 tools/net/bpf_asm.c                                                |   52 +
 tools/net/bpf_dbg.c                                                | 1404 +++++++++
 tools/net/bpf_exp.l                                                |  143 +
 tools/net/bpf_exp.y                                                |  762 +++++
 1829 files changed, 83721 insertions(+), 38493 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
 create mode 100644 Documentation/networking/i40evf.txt
 create mode 100644 Documentation/networking/ipsec.txt
 create mode 100644 Documentation/networking/timestamping/hwtstamp_config.c
 create mode 100644 Documentation/s390/qeth.txt
 create mode 100644 arch/x86/include/asm/hash.h
 create mode 100644 arch/x86/lib/hash.c
 create mode 100644 drivers/net/bonding/bond_options.h
 create mode 100644 drivers/net/bonding/bond_sysfs_slave.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_dcb.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_dcb.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_ptp.c
 create mode 100644 drivers/net/ethernet/intel/i40evf/Makefile
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_adminq.c
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_adminq.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_adminq_cmd.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_alloc.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_common.c
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_hmc.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_lan_hmc.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_osdep.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_prototype.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_register.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_status.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_txrx.c
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_txrx.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_type.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40e_virtchnl.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40evf.h
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40evf_main.c
 create mode 100644 drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_buffalo_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_wow.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar953x_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9565_1p1_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/debug_sta.c
 create mode 100644 drivers/net/wireless/ath/ath9k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath9k/spectral.h
 create mode 100644 drivers/net/wireless/ath/ath9k/tx99.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcdc.h
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/nvram.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/nvram.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/proto.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/proto.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/debugfs.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/sf.c
 create mode 100644 drivers/nfc/nfcmrvl/Kconfig
 create mode 100644 drivers/nfc/nfcmrvl/Makefile
 create mode 100644 drivers/nfc/nfcmrvl/main.c
 create mode 100644 drivers/nfc/nfcmrvl/nfcmrvl.h
 create mode 100644 drivers/nfc/nfcmrvl/usb.c
 create mode 100644 drivers/s390/net/qeth_l2.h
 create mode 100644 drivers/s390/net/qeth_l2_sys.c
 create mode 100644 include/asm-generic/hash.h
 create mode 100644 include/net/Space.h
 create mode 100644 include/net/netfilter/ipv4/nf_reject.h
 create mode 100644 include/net/netfilter/ipv6/nf_reject.h
 create mode 100644 include/uapi/linux/netfilter/xt_cgroup.h
 create mode 100644 include/uapi/linux/netfilter/xt_ipcomp.h
 create mode 100644 include/uapi/linux/netfilter/xt_l2tp.h
 create mode 100644 lib/hash.c
 create mode 100644 net/bluetooth/6lowpan.c
 create mode 100644 net/bluetooth/6lowpan.h
 create mode 100644 net/core/netclassid_cgroup.c
 create mode 100644 net/ieee802154/6lowpan_iphc.c
 create mode 100644 net/netfilter/nf_tables_inet.c
 delete mode 100644 net/netfilter/nft_meta_target.c
 create mode 100644 net/netfilter/nft_queue.c
 rename net/{ipv4/netfilter/nft_reject_ipv4.c => netfilter/nft_reject.c} (78%)
 create mode 100644 net/netfilter/xt_cgroup.c
 create mode 100644 net/netfilter/xt_ipcomp.c
 create mode 100644 net/netfilter/xt_l2tp.c
 create mode 100644 net/sched/sch_hhf.c
 create mode 100644 net/sched/sch_pie.c
 create mode 100644 tools/net/bpf_asm.c
 create mode 100644 tools/net/bpf_dbg.c
 create mode 100644 tools/net/bpf_exp.l
 create mode 100644 tools/net/bpf_exp.y
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
