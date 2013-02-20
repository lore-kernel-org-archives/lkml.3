Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3BTWJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:09:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3BTWJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:09:08 -0500
Date: Wed, 20 Feb 2013 17:09:01 -0500 (EST)
Message-Id: <20130220.170901.343210063003534302.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Feb 2013 14:09:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1KM9o3Y006435


I did a test merge into your tree as of 2 hours ago and there were no
non-trivial merge conflicts, git took care of everything.

1) Checkpoint/restarted TCP sockets now can properly propagate the TCP
   timestamp offset.  From Andrey Vagin.

2) VMWARE VM VSOCK layer, from Andy King.

3) Much improved support for virtual functions and SR-IOV in bnx2x,
   from Ariel ELior.

4) All protocols on ipv4 and ipv6 are now network namespace aware,
   and all the compatability checks for initial-namespace-only
   protocols is removed.  Thanks to Tom Parkin for helping deal
   with the last major holdout, L2TP.

5) IPV6 support in netpoll and network namespace support in pktgen,
   from Cong Wang.

6) Multiple Registration Protocol (MRP) and Multiple VLAN Registration
   Protocol (MVRP) support, from David Ward.

7) Compute packet lengths more accurately in the packet scheduler, from
   Eric Dumazet.

8) Use per-task page fragment allocator in skb_append_datato_frags(),
   also from Eric Dumazet.

9) Add support for connection tracking labels in netfilter, from Florian
   Westphal.

10) Fix default multicast group joining on ipv6, and add anti-spoofing
    checks to 6to4 and 6rd.  From Hannes Frederic Sowa.

11) Make ipv4/ipv6 fragmentation memory limits more reasonable in
    modern times, rearrange inet frag datastructures for better
    cacheline locality, and move more operations outside of locking.
    From Jesper Dangaard Brouer.

12) Instead of strict master <--> slave relationships, allow arbitrary
    scenerios with "upper device lists".  From Jiri Pirko.

13) Improve rate limiting accuracy in TBF and act_police, also from Jiri
    Pirko.

14) Add a BPF filter netfilter match target, from Willem de Bruijn.

15) Orphan and delete a bunch of pre-historic networking drivers from
    Paul Gortmaker.

16) Add TSO support for GRE tunnels, from Pravin B SHelar.  Although this
    still needs some minor bug fixing before it's %100 correct in all
    cases.

17) Handle unresolved IPSEC states like ARP, with a resolution packet
    queue.  From Steffen Klassert.

18) Remove TCP Appropriate Byte Count support (ABC), from Stephen
    Hemminger.  This was long overdue.

19) Support SO_REUSEPORT, from Tom Herbert.

20) Allow locking a socket BPF filter, so that it cannot change after
    a process drops capabilities.

21) Add VLAN filtering to bridge, from Vlad Yasevich.

22) Bring ipv6 on-par with ipv4 and do not cache neighbour entries in
    the ipv6 routes, from YOSHIFUJI Hideaki.

Please pull, thanks a lot!

The following changes since commit 323a72d83c9b2963bd1e46c8e6963e468d4658d7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-02-13 12:21:07 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to ecd9883724b78cc72ed92c98bcb1a46c764fff21:

  ipv6: fix race condition regarding dst->expires and dst->from. (2013-02-20 15:11:45 -0500)

----------------------------------------------------------------
Akeem G. Abodunrin (5):
      igb: Copyright string update to year 2013
      igb: Initialize PHY function pointers
      igb: Initialize NVM function pointers
      igb: Intialize MAC function pointers
      igb: Refractoring function pointers in igb_get_invariants function

Akinobu Mita (1):
      batman-adv: rename random32() to prandom_u32()

Alan Ott (2):
      6lowpan: Refactor packet delivery into a function
      6lowpan: Handle uncompressed IPv6 packets over 6LoWPAN

Alexander Aring (3):
      wpan: whitespace fix
      6lowpan: use stack buffer instead of heap
      wpan: use stack buffer instead of heap

Alexander Bondar (1):
      mac80211: add vif debugfs driver callbacks

Alexander Duyck (25):
      net: Split core bits of netdev_pick_tx into __netdev_pick_tx
      net: Add functions netif_reset_xps_queue and netif_set_xps_queue
      net: Rewrite netif_reset_xps_queue to allow for better code reuse
      net: Rewrite netif_set_xps_queues to address several issues
      net: Add support for XPS without sysfs being defined
      net: Export __netdev_pick_tx so that it can be used in modules
      ixgbe: Make TSO check for CHECKSUM_PARTIAL to avoid skb_is_gso check
      ixgbe: Always use context 0, even for FCoE and TSO
      ixgbe: Update ixgbe Tx flags to improve code efficiency
      ixgbe: Improve performance and reduce size of ixgbe_tx_map
      igb: Replace rmb in Tx cleanup with read_barrier_depends
      ixgbe: Inline Rx PTP descriptor handling
      ixgbe: Replace rmb in Tx cleanup with read_barrier_depends
      ixgbe: Fix SR-IOV MTU warning
      skbuff: Move definition of NETDEV_FRAG_PAGE_MAX_SIZE
      igb: Support using build_skb in the case that jumbo frames are disabled
      igb: Update igb to use a path similar to ixgbe to determine when to stop Tx
      igbvf: Make next_to_watch a pointer and adjust memory barriers to avoid races
      ixgbe: Define FCoE and Flow director limits much sooner to allow for changes
      ixgbe: Add function for setting XPS queue mapping
      ixgbe: Update ixgbe driver to use __netdev_pick_tx in ixgbe_select_queue
      ixgbe: Make ixgbe_setup_tc usable even when DCB is not enabled
      ixgbe: Add support for displaying the number of Tx/Rx channels
      ixgbe: Add support for set_channels ethtool operation
      ixgbe: Update DESC_NEEDED define to adjust for changes to MAX_SKB_FRAGS

Alexey Khoroshilov (5):
      p54pci: don't return zero on failure paths in p54p_probe()
      mwl8k: don't return zero on failure paths in mwl8k_probe[_hw]()
      iwlegacy: don't return zero on failure paths in il4965_pci_probe()
      mwifiex: don't return zero on failure paths in mwifiex_pcie_init()
      stmmac: don't return zero on failure path in stmmac_pci_probe()

Amerigo Wang (2):
      ipv6: fix a RCU warning in net/ipv6/ip6_flowlabel.c
      net: fix a wrong assignment in skb_split()

Amir Hanania (1):
      ixgbe: Reset the NIC if up2tc has changed

Amir Vadai (3):
      net/mlx4_en: Fix a race when closing TX queue
      net/mlx4_en: Initialize RFS filters lock and list in init_netdev
      net/mlx4_en: Fix transmit timeout when driver restarts port

Amitkumar Karwar (4):
      mwifiex: use correct htcapinfo for HT20 ibss network
      mwifiex: correction in status codes used for association failure
      nl80211: minor correction in sample wowlan mask calculation
      nl80211: add packet offset information for wowlan pattern

Amos Kong (2):
      move virtnet_send_command() above virtnet_set_mac_address()
      virtio-net: introduce a new control to set macaddr

Anatol Pomozov (1):
      rtl8723ae: Fix misspellings sucess->success

Andre Guedes (3):
      Bluetooth: Reduce critical section in sco_conn_ready
      Bluetooth: Remove unneeded locking
      Bluetooth: Refactor mgmt_pending_foreach

Andrei Emeltchenko (4):
      Bluetooth: AMP: Send A2MP Create Phylink Rsp after Assoc write
      Bluetooth: AMP: Clean up logical link create / accept
      Bluetooth: AMP: Remove dead code
      Bluetooth: AMP: Use set_bit / test_bit for amp_mgr state

Andrew Jones (1):
      xen: netback: remove redundant xenvif_put

Andrey Vagin (3):
      tcp: adding a per-socket timestamp offset
      tcp: set and get per-socket timestamp
      tcp: send packets with a socket timestamp

Andy King (3):
      VSOCK: Introduce VM Sockets
      VSOCK: Remove hypervisor-only socket option
      VSOCK: Don't reject PF_VSOCK protocol

Antonio Quartulli (15):
      batman-adv: reduce local TT entry timeout to 10 minutes
      batman-adv: improve local translation table output
      batman-adv: print the CRC together with the translation tables
      batman-adv: unify and properly print hex values
      batman-adv: remove useless assignment in tt_local_add()
      batman-adv: Initialize lockdep class keys for hashes
      batman-adv: remove useless blank lines before and after brackets
      batman-adv: remove useless NULL check
      batman-adv: don't compile the BLA switch if not requested
      batman-adv: use the const qualifier in hash functions
      batman-adv: fix typo in debug message
      batman-adv: a delayed_work has to be initialised once
      batman-adv: update copyright years
      batman-adv: Start new development cycle
      batman-adv: fix local translation table output

Arend van Spriel (19):
      brcmsmac: use perimeter lock in add_interface() callback
      brcmsmac: allow user-space setting of interface address
      brcmfmac: assure USB dongle firmware is reset upon module unload
      brcmfmac: define pr_fmt in one place
      brcmfmac: remove rx helper function from bus interface
      brcmfmac: remove brcmf_proto_hdrpull() from bus interface
      brcmfmac: remove unused event related definitions
      brcmfmac: cleanup netdev transmit callback
      brcmfmac: remove unnecessary curly braces in dhd_attach()
      nl80211: allow user-space to set address for P2P_DEVICE
      brcmfmac: add chip information to the bus interface
      brcmfmac: add function to retrieve chip information
      brcmfmac: fix problem connecting to AP without security
      brcmfmac: add peer-to-peer group discovery support
      brcmfmac: add support for creating P2P client/GO interface
      brcmfmac: fix compiler warning on printf format
      brcmfmac: fix generation of the p2p related mac addresses
      brcmfmac: implement support for deleting virtual interfaces
      brcmfmac: change function signatures

Ariel Elior (25):
      bnx2x: Support probing and removing of VF device
      bnx2x: VF <-> PF channel 'acquire' at vf probe
      bnx2x: Add to VF <-> PF channel the release request
      bnx2x: Separate VF and PF logic
      bnx2x: Add init, setup_q, set_mac to VF <-> PF channel
      bnx2x: Add teardown_q and close to VF <-> PF channel
      bnx2x: Support ndo_set_rxmode in VF driver
      bnx2x: VF fastpath
      bnx2x: Allocate VF database in PF when VFs are present
      bnx2x: Prepare device and initialize VF database
      bnx2x: Infrastructure for VF <-> PF request on PF side
      bnx2x: Support of PF driver of a VF acquire request
      bnx2x: Support of PF driver of a VF init request
      bnx2x: Support statistics collection for VFs by the PF
      bnx2x: Support of PF driver of a VF setup_q request
      bnx2x: Support of PF driver of a VF q_filters request
      bnx2x: Support of PF driver of a VF q_teardown request
      bnx2x: Support of PF driver of a VF close request
      bnx2x: Support of PF driver of a VF release request
      bnx2x: Support VF FLR
      bnx2x: Support PF <-> VF Bulletin Board
      bnx2x: Add VF device ids and enable feature
      bnx2x: Segregate SR-IOV code
      bnx2x: align define usage to satisfy static checkers
      bnx2x: SR-IOV version compatibility bugfix

Arik Nemtsov (23):
      wlcore: use new set bandwidth command to adjusting channel BW
      wlcore/wl18xx/wl12xx: separate channel count between chips
      wlcore/wl12xx: make sure session id is always zero for AP
      wlcore: clear roc_vif on iface removal
      wlcore: take the mutex before resetting Tx queues
      wlcore: consolidate free_link and always call it
      wlcore: initialize per-link FW freed blocks correctly
      wlcore: track wlvif inside per-link structure
      wlcore: count packets held per AC in each vif
      wlcore: track FW-allocated packets per link
      wlcore: improved Tx scheduling algorithm
      wl18xx: set last Tx rate from FW status
      wlcore: remove support for injected Tx
      wlcore: improve handling for Rx errors
      wlcore: set 5Ghz probe-req template for DFS channels
      wlcore/wl18xx: change priority calculations for links
      wl18xx: limit Tx for the AP single-STA-in-PSM case
      wlcore: use link count for single-STA-PSM optimization
      wlcore: use separate HW queue for each AC in each vif
      wlcore: don't take mutex before stopping queues
      wlcore: consolidate Rx BA bitmap management to links struct
      wl18xx: support MIMO only if HT mode is not forced to SISO
      wl18xx: count HW block spare based correctly on keys

Arnd Bergmann (1):
      mac80211: avoid a build warning

Aur√©lien Guillaume (1):
      ixgbe: implement SFF diagnostic monitoring via ethtool

Aviad Yehezkel (1):
      net/mlx4_en: Fix traffic loss under promiscuous mode

Avinash Patil (13):
      mwifiex: parse WMM IEs from hostapd for mwifiex AP
      mwifiex: access interrupt status only while holding lock
      mwifiex: add init_fw_port handler for PCIe interface
      mwifiex: use pci_alloc/free_consistent APIs for PCIe
      mwifiex: flush TX ring for PCIe after disconnect or bss stop
      mwifiex: use map/unmap APIs in TX and RX to reduce memcpy
      mwifiex: fix invalid access of PCIe RxBD ring buffer descriptor
      mwifiex: store card specific data in PCI device table entry
      mwifiex: separate ring initialization and ring creation routines
      mwifiex: define generic data type for PCIe ring buffers
      mwifiex: add PCIe8897 support
      mwifiex: device specific sleep cookie handling for PCIe
      mwifiex: fix empty TX ring check for PCIe8897 while unloading driver

Barry Grussling (5):
      DSA: Convert DSA comments to network-style comments
      DSA: Convert repeated msleep calls to timeouts
      DSA: Convert printk calls to netdev_info calls
      DSA: Convert spaces to tabs where appropriate
      ethoc: Cleanup driver format

Ben Greear (1):
      mac80211: Allow disabling SGI-20

Beni Lev (1):
      iwlwifi: mvm: fix TKIP key updating

Benjamin LaHaise (1):
      pkt_sched: namespace aware act_mirred

Bernd Krumboeck (2):
      can: usb_8dev: Add support for USB2CAN interface from 8 devices
      can: usb_8dev: add LED trigger support

Bing Zhao (4):
      ieee80211: define AKM suite selectors type 5, 6 and 7
      mwifiex: do not overwrite error code from lower layer driver
      mwifiex: do not reconfigure tx buffer size in firmware while associating
      mwifiex: remove max_tx_buf_size

Bjorn Helgaas (1):
      e1000e: Use standard #defines for PCIe Capability ASPM fields

Bj√∏rn Mork (1):
      net: cdc_ncm: fix probing of devices with multiple control interface altsettings

Bob Copeland (2):
      mac80211: fix mesh_hwmp kerneldoc
      mac80211: enable vif.cab_queue for mesh

Bruce Allan (57):
      e1000e: SerDes autoneg flow control
      e1000e: Acquire/release semaphore when writing each EEPROM page
      e1000e: Invalid Image CSUM bit changed for I217
      e1000e: helper functions for accessing EMI registers
      e1000e: 82577: workaround for link drop issue
      e1000e: fix enabling of EEE on 82579 and I217
      e1000e: unexpected "Reset adapter" message when cable pulled
      e1000e: add missing bailout on error
      e1000e: resolve checkpatch PREFER_PR_LEVEL warning
      e1000e: cleanup redundant statistics counter
      e1000e: cleanup unusual comment placement
      e1000e: cleanup unnecessary line wrap
      e1000e: cleanup magic number
      e1000e: cleanup code duplication
      e1000e: merge multiple conditional statements into one
      e1000e: add ethtool .get_eee/.set_eee
      e1000e: add support for hardware timestamping on some devices
      e1000e: fix ethtool offline register test for I217
      e1000e: fix flow-control thresholds for jumbo frames on 82579/I217/I218
      e1000e: add support for IEEE-1588 PTP
      e1000e: enable ECC on I217/I218 to catch packet buffer memory errors
      e1000e: prevent hardware from automatically configuring PHY on I217/I218
      e1000e: remove prototype of non-existent function
      e1000e: update copyright date
      e1000e: correct maximum frame size on i217/i218
      e1000e: fix PHY init workarounds for i217/i218
      e1000e: remove definition of struct which is no longer used
      e1000e: add comment to spinlock_t definition
      e1000e: cleanup: remove unnecessary function prototypes
      e1000e: do not ignore variables which get set a value
      e1000e: cleanup: do not assign a variable a value when not necessary
      e1000e: cleanup: remove e1000_set_d0_lplu_state()
      e1000e: cleanup: remove e1000_force_speed_duplex()
      e1000e: cleanup: rename e1000_get_cfg_done()
      e1000e: cleanup: remove e1000_get_phy_cfg_done()
      e1000e: cleanup: remove e1000_get_cable_length()
      e1000e: cleanup: remove e1000e_commit_phy()
      e1000e: correct maximum frame size on 82579
      e1000e: adjust PM QoS request
      e1000e: cleanup: remove unused #define
      e1000e: cleanup hw.h
      e1000e: cleanup: remove comments which are no longer applicable
      e1000e: cleanup defines.h
      e1000e: cleanup: group OR'ed bit settings with parens
      e1000e: cleanup some whitespace and indentation issues
      e1000e: update driver version string
      e1000e: resolve -Wunused-parameter compile warnings
      e1000e: use generic IEEE MII definitions
      e1000e: cosmetic move of #defines and prototypes to the new 82571.h
      e1000e: cosmetic move of #defines to the new 80003es2lan.h
      e1000e: cosmetic move of #defines and prototypes to the new ich8lan.h
      e1000e: cosmetic move of function prototypes to the new mac.h
      e1000e: cosmetic move of #defines and function prototypes to the new phy.h
      e1000e: cosmetic move of #defines and function prototypes to the new nvm.h
      e1000e: cosmetic move of #defines and prototypes to the new manage.h
      e1000e: convert enums of register offsets and move #defines to regs.h
      e1000e: cleanup checkpatch braces checks

Carolyn Wyborny (6):
      igb: Add i2c interface to igb.
      igb: Add support functions to access thermal data.
      igb: Enable hwmon data output for thermal sensors via I2C.
      igb: Fix for improper exit in igb_get_i2c_client
      igb: Fix for improper allocation flag in igb_get_i2c_client
      igb: Refix sparse warning in igb_get_i2c_client

Catalin Iacob (1):
      rtlwifi: Initialize rate_init member of struct rate_control_ops

Chen Gang (1):
      drivers/net/wireless: need consider the not '\0' terminated string.

Christian Lamparter (12):
      carl9170: advertise support for TDLS
      carl9170: import 1.9.7 firmware headers
      carl9170: allow P2P_GO interface creation after P2P_CLIENT
      carl9170: Only specify interface combinations if more than one interface is possible
      carl9170: don't enable hw crypto offload, if the fw doesn't support it
      carl9170: disable hw crypto for p2p networks
      carl9170: remove custom NUM_TID and friends
      carl9170: refactor carl9170_update_beacon
      iwlegacy: fix antenna bitmask
      iwl4965: report A-MPDU status
      ath9k: report A-MPDU status
      mac80211: protect rx-path with spinlock

Chuansheng Liu (1):
      wlcore: Fix the usage of wait_for_completion_timeout

Chun-Yeow Yeoh (3):
      mac80211: use short slot time in mesh for 5GHz
      mac80211: allow disable power save in mesh
      rt2x00: allow AP and mesh mode to operate simultaneously

Claudiu Manoil (11):
      gianfar: Restore promisc mode on gfar_init_mac()
      gianfar: Optimize struct gfar_priv_tx_q for two cache lines
      gianfar: Cleanup gfar_parse_group() code
      gianfar: Pack struct gfar_priv_grp into three cachelines
      gianfar: Remove unused device_node ref in gfar_private
      gianfar: Add device ref (dev) in gfar_private
      gianfar: Cleanup and optimize struct gfar_private
      gianfar: GRO_DROP is unlikely
      gianfar: gfar_process_frame returns void
      gianfar: Remove wrong buffer size conditioning to VLAN h/w offload
      gianfar: Fix and cleanup Rx FCB indication

Cong Ding (2):
      net: wireless/rtlwifi: fix uninitialized variable issue
      net: wireless/rtlwifi: fix uninitialized variable issue

Cong Wang (25):
      netpoll: prepare for ipv6
      ipv6: move csum_ipv6_magic() and udp6_csum_init() into static library
      netpoll: add IPv6 support
      netconsole: add IPv6 example in doc
      xfrm: replace rwlock on xfrm_state_afinfo with rcu
      xfrm: replace rwlock on xfrm_km_list with rcu
      netpoll: fix a rtnl lock assertion failure
      netpoll: fix a missing dev refcounting
      xfrm: use separated locks to protect pointers of struct xfrm_state_afinfo
      net: move rx and tx hash functions to net/core/flow_dissector.c
      ipv6: remove duplicated declaration of ip6_fragment()
      netpoll: fix an uninitialized variable
      decnet: use correct RCU API to deref sk_dst_cache field
      net: add RCU annotation to sk_dst_cache field
      af_key: remove a duplicated skb_orphan()
      netpoll: add RCU annotation to npinfo field
      netpoll: use ipv6_addr_equal() to compare ipv6 addr
      netpoll: use the net namespace of current process instead of init_net
      pktgen: support net namespace
      net: adjust skb_gso_segment() for calling in rx path
      bridge: use __u16 in if_bridge.h
      bridge: make ifla_br_policy and br_af_ops static
      net: move ioctl functions into a separated file
      net: move procfs code to net/core/net-procfs.c
      net: fix a build failure when !CONFIG_PROC_FS

Cyril Roelandt (2):
      mwifiex: avoid out of bounds access in mwifiex_get_common_rates.
      net: ethernet: ti: remove redundant NULL check.

Dan Carpenter (9):
      bnx2x: NULL dereference on error in debug code
      tg3: missing break statement in tg3_get_5720_nvram_info()
      enic: change sprintf() to snprintf()
      b43: N-PHY: fix gain in b43_nphy_get_gain_ctl_workaround_ent()
      prism54: bug in getting auth type
      irda: buffer overflow in irnet_ctrl_read()
      qlcnic: silence false positive overflow warning
      NFC: llcp: integer underflow in nfc_llcp_set_remote_gb()
      brcmsmac: fix brcms_c_country_valid()

Dan Williams (1):
      qmi_wwan, cdc-ether: add ADU960S

Daniel Borkmann (7):
      net: filter: return -EINVAL if BPF_S_ANC* operation is not supported
      sctp: sctp_close: fix release of bindings for deferred call_rcu's
      net: sctp: sctp_auth_make_key_vector: remove duplicate ntohs calls
      net: sctp: sctp_auth_make_key_vector: use sctp_auth_create_key
      net: sctp: remove unused multiple cookie keys
      net: sctp: minor: make jsctp_sf_eat_sack static
      net: sctp: add build check for sctp_sf_eat_sack_6_2/jsctp_sf_eat_sack

Dave Young (1):
      net: ehea module param description fix

David J. Choi (1):
      drivers/net/phy/micrel_phy: Add support for new PHYs

David S. Miller (55):
      net: introduce upper device lists and remove dev->master
      Merge branch 'delete-8390-EISA' of git://git.kernel.org/.../paulg/linux
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'intel'
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'ipv6_ndisc'
      Merge branch 'qeth'
      Merge branch 'mcast'
      Merge branch 'virtio_mac'
      Merge branch 'dsa'
      Merge branch 'legacy-isa-delete' of git://git.kernel.org/.../paulg/linux
      Merge branch 'soreuseport'
      Merge branch 'testing' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'intel'
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'ipfrags'
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'mlx4'
      Merge branch 'intel'
      Merge branch 'delete-wanrouter' of git://git.kernel.org/.../paulg/linux
      ipcomp: Mark as netns_ok.
      Merge git://git.kernel.org/.../davem/net
      l2tp: Make ipv4 protocol handler namespace aware.
      ipv4: Disallow non-namespace aware protocols to register.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      6lowpan: Remove __init tag from lowpan_netlink_fini().
      Merge branch 'mlx4'
      Merge branch 'tg3'
      Merge branch 'wireless'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'vsock'
      Merge branch 'mvrp'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'gfar-ethtool-atomic' of git://git.kernel.org/.../paulg/linux
      Merge branch 'tcp_tsoffset'
      Merge branch 'bridge_vlan'
      Merge branch 'master' of git://1984.lsi.us.es/nf
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      net: Don't write to current task flags on every packet received.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'tipc_net-next' of git://git.kernel.org/.../paulg/linux
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge git://git.kernel.org/.../davem/net into net
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Revert "xen: netback: remove redundant xenvif_put"
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next

David Vrabel (2):
      xen-netback: correctly return errors from netbk_count_requests()
      xen-netback: cancel the credit timer when taking the vif down

David Ward (3):
      ip_gre: When TOS is inherited, use configured TOS value for non-IP packets
      net/802: Implement Multiple Registration Protocol (MRP)
      net/8021q: Implement Multiple VLAN Registration Protocol (MVRP)

Dmitry Kravkov (5):
      bnx2x: Add an additional fatal hw assertion - BRB_HW_INTERRUPT
      bnx2x: use SAN Mac for FCoE.
      bnx2x: Correct memory preparation and release
      ip_gre: allow CSUM capable devices to handle packets
      ip_gre: propogate target device GSO capability to the tunnel device

Dmitry Torokhov (2):
      VSOCK: get rid of EXPORT_SYMTAB
      VSOCK: get rid of vsock_version.h

Don Skidmore (1):
      ixgbe: update date to 2013

Donald Dutile (1):
      ixgbe: Limit number of reported VFs to device specific value

Doug Goldstein (1):
      bonding: set sysfs device_type to 'bond'

Eliad Peller (36):
      wlcore: start sta role on CHANGED_BSSID
      wlcore: workaround start_sta problem in wl12xx fw
      wlcore: implement .remain_on_channel() callback
      wlcore: get channel from bss_conf instead of hw->conf
      wlcore: add chanctx implementation
      wlcore: initiate ROC/CROC on sta state updates
      wlcore: set active psm on association
      wlcore: specify correct supported_rates
      wlcore: reconfigure rate policy on association
      wlcore: refactor CHANGED_HT handling
      wlcore: configure the remote rates with our own rates
      wlcore: print role_id on bss_info_changed
      wlcore: don't leak wl->mbox
      wlcore: don't call ieee80211_sched_scan_stopped directly
      wlcore: make scan scan configuration functions more generic
      wl18xx: change fw name and temporarily fail loading
      wlcore: update commands enum to new fw api
      wlcore: split 18xx and 12xx scan mechanism
      wl18xx: increase MAX_CHANNELS_5GHZ
      wlcore: update acx enum
      wlcore: update channel_switch/stop_channel_switch commands
      wlcore: update events enum/struct to new fw api
      wlcore: pass wmm configuration to the fw
      wlcore: save session_id per-link
      wlcore: call ieee80211_sched_scan_stopped on interface removal
      wl18xx: make driver operational again
      wlcore: configure dwell times according to scan type
      wlcore: don't stop fwlog if dbgpins are used
      wlcore: use sta_state-based ROCs for AP mode
      wlcore: mask out CCK rates when starting GO
      wlcore: move ps change handling to .bss_info_changed()
      wlcore: allow fw commands to fail
      wlcore: allow ACX_BA_SESSION_RX_SETUP to fail
      wlcore: remove WLCORE_QUIRK_NO_ELP
      wl18xx: declare support for greenfield ht_cap
      wlcore: add ACX_PEER_CAP command

Emanuel Taube (1):
      mac80211: Add the DS Params for mesh to every band

Emil Tantilov (5):
      ixgbe: allow reading of SFF-8472 data over i2c
      ixgbe: refactor initialization of feature flags
      ixgbe: fix possible data corruption in read_i2c_byte
      ixgbe: cleanup error checking in ixgbe_identify_sfp_module_generic()
      ixgbe: fix Tx timeouts with BQL

Emmanuel Grumbach (21):
      mac82011: use frame control to differentiate probe resp/beacon
      iwlwifi: make the BC table layout configurable
      iwlwifi: clean up code in AGG
      iwlwifi: don't verify fw after download
      iwlwifi: let the op_mode run a FW while in RFKILL
      iwlwifi: virtualize iwl_{grab,release}_nic_access
      iwlwifi: virtualize SRAM access
      iwlwifi: don't treat a bool as an error code
      iwlwifi: always check that grab_nic_access succeeds
      iwlwifi: allow to zero SRAM
      iwlwifi: improve the reports in TX path
      iwlwifi: provide RX page order
      mac80211: provide the vif in rssi_callback
      mac80211: inform the driver about update of dtim_period
      iwlwifi: don't ack the card state notification
      iwlwifi: mvm: fix the keyidx assignment
      iwlwifi: mvm: fix locking in iwl_mvm_ipv6_addr_change
      mac80211: allow driver to be stateless wrt. SMSP requests
      iwlwifi: mvm: use atomic interface iteration to avoid deadlock
      iwlwifi: mvm: beautify code in rx_handlers
      iwlwifi: dvm: improve (again) the prints in reclaim path

Eric Dumazet (25):
      net: use per task frag allocator in skb_append_datato_frags
      veth: reduce stat overhead
      veth: extend device features
      net: splice: avoid high order page splitting
      veth: avoid a NULL deref in veth_stats_one
      net: introduce skb_transport_header_was_set()
      veth: fix a NULL deref in netif_carrier_off
      net_sched: more precise pkt_len computation
      softirq: reduce latencies
      net: splice: fix __splice_segment()
      ifb: dont hard code inet_net use
      net_sched: fix qdisc_pkt_len_init()
      net/mlx4_en: remove redundant code
      net: fix possible wrong checksum generation
      x86: bpf_jit_comp: add pkt_type support
      net: reset mac header in dev_start_xmit()
      macvlan: add multicast filter
      macvlan: broadcast addr should be part of mc_filter
      macvlan: add a salt to mc_hash()
      veth: fix NULL dereference in veth_dellink()
      net: use skb_reset_mac_len() in dev_gro_receive()
      ipv6: optimize inet6_hash_frag()
      ipv6: fix a sparse warning
      ppp: set qdisc_tx_busylock to avoid LOCKDEP splat
      ip_gre: remove an extra dst_release()

Eric Lapuyade (7):
      NFC: Fixed nfc core and hci unregistration and cleanup
      NFC: Added error handling in event_received hci ops
      NFC: Changed event_received hci ops result semantic
      NFC: Fixed skb leak in tm_send() nfc and hci ops implementations
      NFC: Add HCI quirks to support driver (non)standard implementations
      NFC: update HCI documentation
      NFC: Initial support for Inside Secure microread

Eric W. Biederman (1):
      ipv6: Fix inet6_csk_bind_conflict so it builds with user namespaces enabled

Erik Hugne (1):
      tipc: fix missing spinlock init in broadcast code

Eugenia Emantayev (2):
      net/mlx4_en: Issue the dump eth statistics command under lock
      net/mlx4_en: Use the correct netif lock on ndo_set_rx_mode

Eyal Shapira (2):
      wlcore: increase scan dwell times if no activity
      wlcore: support scan reports during periodic scan

Eytan Lifshitz (2):
      iwlwifi: fix spelling and value in LED registers.
      iwlwifi: dvm: fix delayed enter to CT-kill bug

Fabio Baltieri (8):
      ipv6: fix ipv6_prefix_equal64_half mask conversion
      can: add tx/rx LED trigger support
      can: flexcan: add LED trigger support
      can: at91_can: add LED trigger support
      can: ti_hecc: add LED trigger support
      can: c_can: add LED trigger support
      can: mcp251x: add LED trigger support
      can: sja1000: add LED trigger support

Fabio Estevam (3):
      net: fec: Remove 'inline' declarations
      smsc: smc911x: Fix sparse warnings
      net: fec: Do a sanity check on the gpio number

Felipe Balbi (1):
      net: ks8851: convert to threaded IRQ

Felix Fietkau (15):
      ath9k: use the devres API for allocations/mappings
      ath9k_hw: use the devres API for allocations
      wireless: fix regulatory HT40 allowed check
      ath9k_hw: add tx gain tables for newer devices
      ath9k_hw: fix RF bank initialization
      ath9k: stop rx after tx
      ath9k: clean up processing of pending tx frames on reset
      ath9k: use ath_tx_process_buffer instead of open-coding similar code
      ath9k_hw: make the initval parameter to ath9k_hw_write_array const
      ath9k_hw: remove ath9k_hw_ani_setup and its variables
      ath9k_hw: reduce struct ar5416AniState size
      ath9k_hw: remove a useless WARN_ON
      mac80211/minstrel_ht: show the number of retries for each rate in debugfs
      mac80211/minstrel_ht: remove the sampling bypass check for the lowest rate
      mac80211/minstrel_ht: add support for using CCK rates

Fengguang Wu (1):
      ath9k_hw: ar9002_hw_spectral_scan_config() can be static

Flavio Leitner (5):
      team: implement carrier change
      team: add ethtool support
      team: update master carrier state
      team: use strlcpy with ethtool_drvinfo fields
      team: allow userspace to take control over carrier

Florian Fainelli (3):
      net: phy: remove flags argument from phy_{attach, connect, connect_direct}
      dsa: use an unique and non conflicting bus name for the slave MII bus
      dsa: make dsa_switch_setup check for valid port names

Florian Westphal (6):
      netfilter: add connlabel conntrack extension
      netfilter: ctnetlink: deliver labels to userspace
      netfilter: ctnetlink: allow userspace to modify labels
      netfilter: fix missing dependencies for NETFILTER_XT_MATCH_CONNLABEL
      netfilter: ctnetlink: don't permit ct creation with random tuple
      netfilter: nf_ct_helper: don't discard helper if it is actually the same

Frank Li (7):
      NET: FEC: dynamtic check DMA desc buff type
      net: fec: report correct hardware stamping info to ethtool
      net: fec: enable pause frame to improve rx prefomance for 1G network
      net: fec: add napi support to improve proformance
      net: fec: fix miss init spinlock
      net: fec: correct fix method about miss init spinlock
      net: fec: fix spin_lock dead lock

Gabor Juhos (2):
      ath9k: fix column header comments for some initval arrays
      rt2x00: rt2800: convert read_eeprom functions to return an int value

Gao feng (21):
      netfilter: nf_conntrack: move initialization out of pernet operations
      netfilter: nf_ct_expect: move initialization out of pernet_operations
      netfilter: nf_ct_acct: move initialization out of pernet_operations
      netfilter: nf_ct_tstamp: move initialization out of pernet_operations
      netfilter: nf_ct_ecache: move initialization out of pernet_operations
      netfilter: nf_ct_timeout: move initialization out of pernet_operations
      netfilter: nf_ct_helper: move initialization out of pernet_operations
      netfilter: nf_ct_labels: move initialization out of pernet_operations
      netfilter: nf_ct_proto: move initialization out of pernet_operations
      netfilter: nf_conntrack: refactor l3proto support for netns
      netfilter: nf_conntrack: refactor l4proto support for netns
      netns: fdb: allow unprivileged users to add/del fdb entries
      netns: ebtable: allow unprivileged users to operate ebtables
      netns: bridge: allow unprivileged users add/delete mdb entry
      netns: bond: allow unprivileged users to control bond device
      net: proc: change proc_net_fops_create to proc_create
      net: proc: remove proc_net_fops_create
      net: proc: change proc_net_remove to remove_proc_entry
      net: proc: remove proc_net_remove
      net: proc: fix build failed when procfs is not configured
      net: ipv4: fix waring -Wunused-variable

Geert Uytterhoeven (1):
      brcmsmac: initialize morepending in brcms_b_recv()

Giuseppe CAVALLARO (2):
      net: phy: realtek: add rtl8211e driver
      stmmac: fix the parsing of the eee_timer parameter

Greg Rose (10):
      igb: Enable SR-IOV configuration via PCI sysfs interface
      ixgbevf: Synch out of tree and in tree mailbox interrupt handlers
      ixgbevf: Fix link up messages
      ixgbevf: Fix statistics corruption
      ixgbe: Make mailbox ops initialization unconditional
      ixgbe: Modularize SR-IOV enablement code
      ixgbe: Implement PCI SR-IOV sysfs callback operation
      ixgbevf: Fix link speed message to support 100Mbps
      ixgbevf: Make sure link status and speed are fetched
      ixgbe: Fix device ref count bug

Guenter Roeck (1):
      net: iwlegacy: remove unused variable

Gustavo Padovan (1):
      Bluetooth: Fix uuid output in debugfs

Hadar Hen Zion (10):
      net/mlx4_core: Directly expose fields of HW flow steering rule control segment
      net/mlx4_core: Set correctly allow_loopback flag
      net/mlx4_en: Fix ip/udp steering rules multicast mac when attached via ethtool
      net/mlx4_en: Validate VLAN IDs provided in ethtool flow steering rules
      net/mlx4_en: Fix vlan mask for ethtool steering rules
      net/mlx4_en: Block insertion of ethtool steering rules while the interface is down
      net/mlx4_en: Fix ethtool rules leftovers after module unloaded
      net/mlx4_core: Use firmware driven flow steering hash mode
      net/mlx4_en: Fix error propagation for ethtool helper function
      net/mlx4_en: Fix compilation error when CONFIG_INET isn't defined

Hannes Frederic Sowa (6):
      tcp: make sysctl_tcp_ecn namespace aware
      ipv6: remove unneeded check to pskb_may_pull in ipip6_rcv
      ipv6: add anti-spoofing checks for 6to4 and 6rd
      ipv6: don't let node/interface scoped multicast traffic escape on the wire
      ipv6: don't accept multicast traffic with scope 0
      ipv6: by default join ff01::1 and in case of forwarding ff01::2 and ff05:2

Hante Meuleman (39):
      brcmfmac: do not reconfigure refill rx on 0-length packet.
      brcmfmac: removed deprecated set_bitrate_mask support
      brcmfmac: Use dedicated trace level for CDC.
      brcmfmac: Remove unused caching dongle error.
      brcmfmac: Return correct error on netdev xmit.
      brcmfmac: Removing obsolete variables and inline functions.
      brcmfmac: Update init code routines from interface up.
      brcmfmac: Remove drvr_up from bus interface.
      brcmfmac: Remove copy mac address from drvr at netdev up.
      brcmfmac: Use struct brcmf_if in brcmf_configure_opensecurity.
      brcmfmac: Track pending 8021x frames per ifp.
      brcmfmac: Add logging for FIL int set/get cmds.
      brcmfmac: Track statistics per ifp.
      brcmfmac: Update tracelogging for multiple netdevs.
      brcmfmac: Cleanup function brcmf_notifiy_connect_status_ap.
      brcmfmac: Use single function for channel to chanspec.
      brcmfmac: use brcmf_if::bssidx as index in interface list
      brcmfmac: Check null pointer on brcmf_dev_reset.
      brcmfmac: add support for P2P listen mode.
      brcmfmac: update escan for multiple bss and simplify.
      brcmfmac: update p2p add and delete vif routines.
      brcmfmac: add p2p change vif routines.
      brcmfmac: Fix bug mgmt_rx_register
      brcmfmac: Update connect setup/handling routines for multiple bss.
      brcmfmac: Update AP mode for GO creation.
      brcmfmac: Add handling of receiving P2P action frames.
      brcmfmac: P2P action frame tx.
      brcmfmac: Use real cookie value for p2p remain on channel.
      brcmfmac: Create p2p0 netdev via module variable.
      brcmfmac: Use role from wdev on AP commands and fix stop_ap.
      brcmfmac: Put printing action frames code under debug flag.
      brcmfmac: Ignore E_ADD_IF for ifidx 0.
      brcmfmac: Reject change vif for p2p if.
      brcmfmac: Update netdev configuration in wiphy for p2p.
      brcmfmac: Remove sleep on del_station.
      brcmfmac: Fix rtnl_lock lockup when registering netdev.
      brcmfmac: Cleanup of unused defines.
      brcmfmac: Create netdev before returning from add_virtual_intf.
      brcmfmac: Add tx p2p off-channel support.

Hauke Mehrtens (18):
      bcma: make bcma_find_core_unit() accessible
      bcma: mips: explicit assign IRQ numbers
      bcma: mips: make some info messages debug messages
      bcma: mips: show also disabled IRQs
      bcma: mips: remove assigned_irqs from structure
      bcma: mips: rename oldirqflag to irqinitmask
      bcma: fix compile error
      ssb: add gpio_to_irq
      bcma: add gpio_to_irq
      bgmac: implement missing code for BCM53572
      bgmac: write mac address to hardware in ndo_set_mac_address
      bgmac: add generic ndo_validate_addr netdev ops
      bgmac: add ndo_set_rx_mode netdev ops
      ssb: get mac address from sprom struct for gige driver
      tg3: make it possible to provide phy_id in ioctl
      tg3: add support for Ethernet core in bcm4785
      bgmac: fix unaligned accesses to network headers
      b44: use netdev_alloc_skb_ip_align()

Helmut Schaa (1):
      rt2x00: Improve TX status handling for BlockAckReq frames

Himanshu Madhani (4):
      qlcnic: macros for common register access
      qlcnic: Fix LED/Beaconing tests to work on all ports of an adapter.
      qlcnic: fix initialize NIC mailbox command
      qlcnic: refactor Legacy interrupt handling for 83xx

Huang, Xiong (1):
      atl1c: restore buffer state

Ido Reis (1):
      wl18xx: update default mac/phy parameters

Ido Yariv (1):
      wlcore: Always pass DMA-able buffers to mmc functions

Ilan Peer (6):
      iwlwifi: mvm: Update quota settings for all bindings
      iwlwifi: mvm: Change the Time Event type used for ROC
      cfg80211: fix radar check for P2P_DEVICE
      iwlwifi: mvm: Set the scan type according to the vif type
      iwlwifi: mvm: Fix resource allocation for P2P Device
      iwlwifi: mvm: Reserve MAC id 0 for managed interfaces

Jack Morgenstein (1):
      net/mlx4_core: Return proper error code when __mlx4_add_one fails

Jacob Keller (8):
      ixgbe: ethtool ixgbe_diag_test cleanup
      ixgbe: add missing supported filters to get_ts_info
      ixgbe: Update ptp_overflow check comment and jiffies
      ixgbe: Use watchdog check in favor of BPF for detecting latched timestamp
      ixgbe: Add ptp work item to poll for the Tx timestamp
      ixgbe: add warning when scheduling reset
      ixgbe: Fix overwriting of rx_mtrl in ixgbe_ptp_hwtstamp_ioctl
      ixgbe: only compile ixgbe_debugfs.o when enabled

James Hogan (1):
      net: skbuff: fix compile error in skb_panic()

Jamie Gloudon (1):
      via-rhine: add 64bit statistics.

Janusz.Dziedzic@tieto.com (1):
      wlcore: SPI - fix spi transfer_list

Jean Sacren (2):
      mcast: do not check 'rv' twice in a row
      skbuff: create skb_panic() function and its wrappers

Jeff Kirsher (1):
      e1000: fix whitespace issues and multi-line comments

Jesper Dangaard Brouer (7):
      net: increase fragment memory usage limits
      net: cacheline adjust struct netns_frags for better frag performance
      net: cacheline adjust struct inet_frags for better frag performance
      net: cacheline adjust struct inet_frag_queue
      net: frag helper functions for mem limit tracking
      net: use lib/percpu_counter API for fragmentation mem accounting
      net: frag, move LRU list maintenance outside of rwlock

Jiri Pirko (49):
      net: add change_carrier netdev op
      net: allow to change carrier via sysfs
      rtnl: expose carrier value with possibility to set it
      dummy: implement carrier change
      rtnl: use dev_set_mac_address() instead of plain ndo_
      net: call add_device_randomness() only after successful mac change
      net: set dev->addr_assign_type correctly
      net: add address assign type "SET"
      net: remove unnecessary NET_ADDR_RANDOM "bitclean"
      um: net: use eth_hw_addr_random() to generate random mac
      ll_temac: fix mac address setting
      net: introduce upper device lists
      macvlan: add link to upper device
      vlan: add link to upper device
      rtnetlink: remove usage of dev->master
      team: remove usage of netdev_set_master()
      bridge: remove usage of netdev_set_master()
      netpoll: remove usage of dev->master
      cxgb3: remove usage of dev->master
      qlcnic: guard __vlan_find_dev_deep() by rcu_read_lock
      qeth: ensure that __vlan_find_dev_deep() is called with rcu_read_lock
      vlan: remove usage of dev->master in __vlan_find_dev_deep()
      nes: remove usage of dev->master
      bonding: remove usage of dev->master
      net: remove no longer used netdev_set_bond_master() and netdev_set_master()
      net: kill dev->master
      ethoc: fix mac address set
      ethtool: set addr_assign_type to NET_ADDR_SET when addr is passed on create
      ethtool: fix drvinfo strings set in drivers
      net: use ETHTOOL_FWVERS_LEN instead of ETHTOOL_BUSINFO_LEN for fw_ver strings
      ethtool: consolidate work with ethtool_ops
      net: init perm_addr in register_netdevice()
      remove init of dev->perm_addr in drivers
      netfilter: doc: add nf_conntrack sysctl api documentation
      ipv4: introduce address lifetime
      bond: have random dev address by default instead of zeroes
      team: handle sending port list in the same way option list is sent
      team: move netlink event notifiers after team_port_leave()
      team: ab: set active port option as changed when port is leaving
      bridge: use dev->addr_assign_type to see if user change mac
      htb: use PSCHED_TICKS2NS()
      htb: remove pointless first initialization of buffer and cbuffer
      htb: initialize cl->tokens and cl->ctokens correctly
      sch: make htb_rate_cfg and functions around that generic
      sch_api: introduce qdisc_watchdog_schedule_ns()
      tbf: improved accuracy at high rates
      act_police: move struct tcf_police to act_police.c
      act_police: improved accuracy at high rates
      MAINTAINERS: Jiri Pirko email change

Jiri Slaby (1):
      NET: ath5k, check ath5k_eeprom_mode_from_channel retval

Jitendra Kalsaria (13):
      qlcnic: sleeping function called from invalid context
      qlcnic: add support for FDB netdevice ops.
      qlcnic: Bump up the version to 5.1.32
      qlcnic: Bump up the version to 5.1.33
      qlcnic: Updating copyright information.
      qlcnic: fix firmware based IDC participation
      qlcnic: helper routine to handle async events
      qlcnic: refactor 83xx diagnostic loopback test
      qlcnic: refactor 83xx diagnostic IRQ test
      qlcnic: fix async event handling during diagnostic loopback test
      qlcnic: fix mailbox response handling
      qlcnic: fix unsupported CDRP command error message.
      qlcnic: Bump up the version to 5.1.34

Joe Perches (18):
      chelsio: Use netdev_<level> and pr_<level>
      gro: Fix kcalloc argument order
      caif: Remove unnecessary alloc/OOM messages
      can: Remove unnecessary alloc/OOM messages
      ethernet: Remove unnecessary alloc/OOM messages, alloc cleanups
      drivers: net: usb: Remove unnecessary alloc/OOM messages
      wan: Remove unnecessary alloc/OOM messages
      wimax: Remove unnecessary alloc/OOM messages, alloc cleanups
      wireless: Remove unnecessary alloc/OOM messages, alloc cleanups
      drivers:net:misc: Remove unnecessary alloc/OOM messages
      net: core: Remove unnecessary alloc/OOM messages
      drivers: net: misc: Remove unused OOM variables
      mwl8k: Remove unnecessary alloc/OOM messages
      drivers: net: Remove remaining alloc/OOM messages
      brcmsmac: Downgrade d11hdrs_mac80211 error messages to warnings.
      brcmsmac: Remove unnecessary memset casts
      tg3: Remove define and single use of GET_CHIP_REV_ID
      tg3: Use different macros for pci_chip_rev_id accesses

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
      Bluetooth: Fix checking for valid disconnect parameters in unpair_device
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

Johannes Berg (162):
      Merge remote-tracking branch 'mac80211/master' into HEAD
      mac80211_hwsim: allow testing paged RX
      mac80211: remove final sta_info_flush()
      mac80211: warn if unexpectedly removing stations
      mac80211: optimise roaming time again
      mac80211: remove a bit of dead mesh code
      regulatory: don't write past array when intersecting rules
      regulatory: don't allocate too much memory
      regulatory: clean up regdom_intersect
      regulatory: clean up reg_copy_regd()
      regulatory: don't test list before iterating
      regulatory: simplify regulatory_hint_11d
      regulatory: code cleanup
      regulatory: remove useless locking on exit
      regulatory: use proper enum for return values
      cfg80211: remove wiphy_idx_valid
      regulatory: remove BUG_ON
      regulatory: simplify restore_regulatory_settings
      regulatory: remove redundant isalpha() check
      regulatory: remove useless warning
      regulatory: simplify freq_reg_info_regd
      regulatory: clarify locking rules and assertions
      regulatory: remove locking from wiphy_apply_custom_regulatory
      regulatory: fix reg_is_valid_request handling
      regulatory: remove handling of channel bandwidth
      regulatory: pass new regdomain to reset function
      regulatory: use RCU to protect global and wiphy regdomains
      regulatory: use RCU to protect last_request
      regulatory: use IS_ERR macro family for freq_reg_info
      mac80211: optimise AP stop RCU handling
      cfg80211: adjacent 80+80 MHz channel segments are invalid
      mac80211: fix ieee80211_ie_build_vht_cap indentation
      mac80211: clean up ieee80211_quiesce
      mac80211: clean up association better in suspend
      mac80211: fix channel context iteration
      mac80211: track enable_beacon explicitly
      mac80211: reconfig bss_info_changed only if beaconing
      mac80211: further simplify ieee80211_bss_info_change_notify
      mac80211: assign bss_conf.bssid only once
      mac80211: restrict assoc request VHT capabilities
      cfg80211: move some AP code to right file
      nl80211/mac80211: support full station state in AP mode
      mac80211: split aggregation stop by reason
      mac80211: split out aggregation TX removal
      mac80211: move ieee80211_remove_tid_tx function
      mac80211: split TX aggregation stop action
      wireless: use __packed in ieee80211.h
      mac80211: support HT notify channel width action
      wireless: use __aligned
      mac80211: unset peer's HT 40 MHz support if not usable
      cfg80211: disallow more station changes
      iwlwifi: use __packed
      iwlwifi: request IRQ only once
      iwlwifi: move some PCIe calls to better places
      regulatory: fix uevent
      regulatory: fix restore_regulatory_settings
      mac80211: fix HT40 connections
      iwlwifi: don't memset scalar values
      iwlwifi: don't enable all interrupts on resuming
      iwlwifi: simplify scheduler memory clearing
      iwlwifi: enable communication with WoWLAN firmware
      mac80211: fix resume from WoWLAN
      mac80211: call restart complete at wowlan resume time
      mac80211: split out chandef tracing macros
      mac80211: remove ARP filter enable/disable logic
      mac80211: improve aggregation debug messages
      mac80211: allow drivers to access IPv6 information
      iwlwifi: update copyright
      mac80211: fix aggregation state with current drivers
      mac80211: remove redundant check
      iwlwifi: include debugfs.h
      Merge remote-tracking branch 'wireless-next/master' into HEAD
      cfg80211: add SME state to warning in __cfg80211_mlme_disassoc
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: add 7000 series device configuration
      iwlwifi: clean up CMD_MODE enum
      iwlwifi: fix calibration parser
      iwlwifi: add NVM and PHY DB code for new MVM driver
      cfg80211/mac80211: support reporting wakeup reason
      mac80211: remove assoc data "sent_assoc"
      mac80211: remove last_probe_resp from bss
      mac80211: remove unused mesh data from bss
      cfg80211: remove free_priv BSS API
      mac80211: start auth/assoc timeout on frame status
      iwlwifi: add the MVM driver
      iwlwifi: lower BT coex aggregation message severity
      mac80211: send deauth when connection is lost
      mac80211: always allow calling ieee80211_connection_loss()
      cfg80211: refactor hidden SSID finding
      cfg80211: fix BSS list hidden SSID lookup
      cfg80211: simplify mesh BSS comparison
      cfg80211: remove unused cfg80211_get_mesh
      mac80211: remove unused SSID from BSS
      cfg80211: fix BSS IE allocation comment
      cfg80211: move locking into cfg80211_bss_age
      mac80211: allow transmitting deauth with tainted key
      mac80211: send deauth if connection was lost during suspend
      cfg80211: use lockdep to assert lock is held
      cfg80211: remove a local variable
      cfg80211: wrap BSS kref
      iwlwifi: use threaded interrupt handler
      Merge remote-tracking branch 'wireless-next/master' into HEAD
      cfg80211: pass wiphy to cfg80211_ref_bss/put_bss
      wireless: fix kernel-doc
      mac80211: fix AP beacon loss messages
      mac80211: fix chandef tracing bug
      mac80211: explicitly copy channels to VLANs where needed
      cfg80211: track hidden SSID networks properly
      cfg80211: remove scan ies NULL check
      cfg80211: move TSF into IEs
      mac80211: introduce beacon-only timing data
      mac80211: remove dynamic PS driver interface
      mac80211: remove IEEE80211_HW_SCAN_WHILE_IDLE
      mac80211: simplify idle handling
      mac80211: remove unused code to mark AP station authenticated
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: dvm: query and report WoWLAN wakeup reason
      iwlwifi: mvm: report wakeup reasons
      iwlwifi: dvm: apply beacon changes immediately
      iwlwifi: mvm: don't delay the association until after beacon
      iwlwifi: mvm: don't wait for session protection to start
      iwlwifi: mvm: update station when marked associated
      cfg80211: configuration for WoWLAN over TCP
      mac80211: fix auth/assoc timeout handling
      mac80211: don't call bss_info_changed on p2p-device/monitor
      mac80211: always unblock CSA queue stop when disconnecting
      mac80211: don't pick up WPA vendor IE
      mac80211: use spin_lock_bh() for tim_lock
      mac80211: use spin_lock_bh() for TKIP lock
      Merge remote-tracking branch 'mac80211/master' into HEAD
      mac80211: pass station to ieee80211_vht_cap_ie_to_sta_vht_cap
      mac80211: stop toggling IEEE80211_HT_CAP_SUP_WIDTH_20_40
      wireless: define operating mode action frame
      mac80211: track number of spatial streams
      mac80211: handle VHT operating mode notification
      mac80211: init HT TX data before rate control
      mac80211: fix HT/VHT disable flags
      mac80211: fix ieee80211_change_chandef name
      mac80211: handle operating mode notif in beacon/assoc response
      mac80211: disable HT/VHT if AP has no HT/VHT capability
      mac80211: clean up channel use in ieee80211_config_ht_tx
      mac80211: add ieee80211_vif_change_bandwidth
      mac80211: move ieee80211_determine_chantype function
      mac80211: properly track HT/VHT operation changes
      cfg80211: allow drivers to selectively disable 80/160 MHz
      nl80211: advertise HT/VHT channel limitations
      mac80211: constify IE parsing
      mac80211: stop modifying HT SMPS capability
      cfg80211: advertise extended capabilities to userspace
      mac80211: advertise operating mode notification capability
      nl80211: renumber NL80211_FEATURE_FULL_AP_CLIENT_STATE
      mac80211: prevent spurious HT/VHT downgrade message
      mac80211: clean up mesh code
      cfg80211: add correct docbook entries
      mac80211: fix harmless station flush warning
      cfg80211: fix station change if TDLS isn't supported
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: fix merge error
      iwlwifi: mvm: program DTIM timings properly
      iwlwifi: mvm: fix GO powersave client manipulation
      iwlwifi: mvm: add debug statement to time event add
      iwlwifi: mvm: fix time event command handling race

John Fastabend (1):
      ixgbe: SR-IOV: dynamic IEEE DCBx default priority changes

John W. Linville (25):
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.sipsolutions.net/mac80211-next
      Merge tag 'nfc-next-3.9-1' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge tag 'nfc-next-3.9-2' of git://git.kernel.org/.../sameo/nfc-next
      Merge tag 'nfc-next-3.9-3' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jonas Gorski (1):
      mwl8k: add single band 88W8366 PCI device IDs

Josh Hay (5):
      ixgbe: rename autoneg variables
      ixgbe: removed unused variable from setup_link_speed
      ixgbe: autoneg variable refactoring
      ixgbe: fix potential null dereference
      ixgbe: fix return values and memcpy parameters to eliminate Smatch warnings

Jouni Malinen (3):
      cfg80211: Allow use_mfp to be specified with the connect command
      cfg80211: Pass station (extended) capability info to kernel
      cfg80211: Pass TDLS peer's QoS/HT/VHT information during set_station

Jozsef Kadlecsik (1):
      netfilter: xt_conntrack: Add flag to support aliases

Julia Lawall (6):
      drivers/net/wireless/ath/ath6kl/hif.c: drop if around WARN_ON
      drivers/net/wireless/ti/wlcore/main.c: eliminate possible double power off
      NFC: nfcwilink: Use devm_kzalloc
      drivers/nfc/nfcwilink.c: use devm_kzalloc
      drivers/net/ethernet/sfc/ptp.c: adjust duplicate test
      drivers/net/wireless/iwlegacy/4965-mac.c: adjust duplicate test

Jussi Kivilinna (5):
      xfrm_algo: probe asynchronous block ciphers instead of synchronous
      crypto: ctr - make rfc3686 asynchronous block cipher
      crypto: aesni-intel - remove rfc3686(ctr(aes)), utilize rfc3686 from ctr-module instead
      pf_key/xfrm_algo: prepare pf_key and xfrm_algo for new algorithms without pfkey support
      rtlwifi: usb: allocate URB control message setup_packet and data buffer separately

Karl Beldan (1):
      mac80211_hwsim: ask mac80211 to reserve space for chanctx.drv_priv

Kees Cook (1):
      drivers/net/wireless/ti/wl1251: remove CONFIG_EXPERIMENTAL

Kevin Cernekee (1):
      netfilter: nf_ct_sip: support Cisco 7941/7945 IP phones

Kim Phillips (1):
      gianfar: use more portable i/o accessors

Koki Sanagi (1):
      e1000e: display a warning message when SmartSpeed works

Kumar Amit Mehta (2):
      net: wireless: orinoco: orinoco_usb.c: fix DMA buffers on stack
      net: wireless: hostap: hostap_ap.c: Return -ENOMEM instead of -1 for if kmalloc() fails.

Kurt Van Dijck (2):
      can: export a safe netdev_priv wrapper for candev
      can: rename LED trigger name on netdev renames

Larry Finger (12):
      rtlwifi: Eliminate two empty routines
      rtlwifi: Fix many compile warnings when using W=1
      rtlwifi: Fix warnings in usb.c
      rtlwifi: rtl8192c: Fix W=1 warning
      rtlwifi: rtl8192cu: Fix W=1 build warning
      rtlwifi: rtl8192de: Fix W=1 build warnings
      rtlwifi: rtl8723ae: Fix W=1 compile warnings
      rtlwifi: rtl8192cu: Fix NULL dereference BUG when using new_id
      rtlwifi: rtl8192cu: Add new USB ID
      cfg80211: Fix memory leak
      rtlwifi: Rework Kconfig
      b43: Increase number of RX DMA slots

Lars-Peter Clausen (1):
      ieee802154: at86rf230: Remove empty suspend/resume callbacks

Lauro Ramos Venancio (1):
      NFC: Change nfc.h license

Li RongQing (2):
      xfrm: removes a superfluous check and add a statistic
      xfrm: fix a unbalanced lock

Lilach Edelstein (2):
      iwlwifi: add iwl_set_bits_mask to transport API
      iwlwifi: move register access lock into transport

Linus L√ºssing (1):
      batman-adv: Do not add multicast MAC addresses to translation table

Lucas Stach (2):
      net: asix: init ASIX AX88772B MAC from EEPROM
      net: asix: handle packets crossing URB boundaries

Luciano Coelho (21):
      wlcore: avoid using goto in normal code flow
      wlcore: remove a bunch of unnecessary parentheses
      wlcore: gather information about firmware stability
      wlcore/wl12xx: move wl12xx chip ID defines to the lower driver
      wlcore/wl12xx: remove deprecated FW version check
      wlcore: change way of checking the firmware version
      wl12xx: ignore some of the firmware version fields
      wlcore/wl12xx/wl18xx: verify multi-role and single-role fw versions
      wl18xx: ignore irrelevant firmware version fields
      Merge branch 'wl12xx-next' into for-linville
      Merge branch 'wl12xx-next' into for-linville
      wlcore: use single-role version when verifying the PLT firmware
      wlcore: remove unused set_power method
      wlcore: remove if_ops from platform_data
      wlcore: use wl12xx_platform_data pointer from wlcore_pdev_data
      wlcore: use PLATFORM_DEVID_AUTO for plat dev creation to avoid conflicts
      wlcore: move wl12xx_platform_data up and make it truly optional
      wlcore: don't hide real error code when booting fails
      wlcore: fix wrong remote rates when starting STA role
      wlcore: remove newly introduced alloc/OOM messages
      cfg80211: check vendor IE length to avoid overrun

Luis R. Rodriguez (4):
      cfg80211: do not process beacon hints if one is already queued
      cfg80211: move reg_is_world_roaming()
      cfg80211: move world roaming check for beacon hints
      wireless: make the reg_notifier() void

Mahesh Bandewar (1):
      bnx2x: Force link UP when the interface is in LOOPBACK mode

Manish Chopra (1):
      qlcnic: enhance MSIX allocation failure log message

Manish chopra (5):
      qlcnic: avoid mixed mode interrupts for some adapter types
      qlcnic: Fix bug in reading HW reset template
      qlcnic: Free irq for mailbox interrupts
      qlcnic: driver LRO bug fix
      qlcnic: Fix RX/TX checksum setting for some adapter types

Marc Kleine-Budde (4):
      can: Kconfig: convert 'depends on CAN' into 'if CAN...endif' block
      can: Kconfig: convert 'depends on CAN_DEV' into 'if CAN_DEV...endif' block
      can: Kconfig: switch on all CAN protocolls by default
      can: sja1000: correct indention of Kconfig help text

Marco Porsch (6):
      nl80211: add range checks to mesh parameters
      mac80211: update mesh peer link counter during userspace peering
      mac80211: move add_tim to subfunction
      {cfg,nl,mac}80211: set beacon interval and DTIM period on mesh join
      {cfg,nl}80211: mesh power mode primitives and userspace access
      mac80211: mesh power save basics

Marek Lindner (10):
      batman-adv: remove unused variable from orig_node struct
      batman-adv: unbloat batadv_priv if debug is not enabled
      batman-adv: align kernel doc properly
      batman-adv: mark debug_log struct as bat_priv only struct
      batman-adv: group tt type definitions together
      batman-adv: rename batadv_if_list_entry struct to make clear it is used by vis
      batman-adv: rename batadv_recvlist_node struct to make clear it is used by vis
      batman-adv: rename batadv_backbone_gw struct to make clear it is used by bla
      batman-adv: rename batadv_claim struct to make clear it is used by bla
      batman-adv: kernel doc for types.h

Matan Barak (1):
      net/mlx4_en: Don't reassign port mac address on firmware that supports it

Matt Carlson (1):
      tg3: Add 57766 device support.

Matt Wilson (1):
      xen-netback: allow changing the MAC address of the interface

Matthew Vick (5):
      igb: Add support for SW timestamping
      igb: Add timeout for PTP Tx work item
      igb: Add mechanism for detecting latched hardware Rx timestamp
      igb: Free any held skb that should have been timestamped on remove
      igb: Use in-kernel PTP_EV_PORT #define

Michael Braun (2):
      mac80211: free ps->bc_buf skbs on vlan device stop
      mac80211: fix WPA with VLAN on AP side with ps-sta

Michael Chan (8):
      tg3: Add support for new 5762 ASIC
      tg3: Add NVRAM support for 5762
      tg3: Improve PCI function number detection.
      cnic, bnx2x: Add CNIC_DRV_STATE_HANDLES_IRQ to ethdev->drv_state
      tg3: Expand EEE support for all 5717 B0
      tg3: Fix 5762 NVRAM sizing
      tg3: Set initial carrier state to off.
      tg3: Update version to 3.130

Michal Kubecek (2):
      xfrm: remove unused xfrm4_policy_fini()
      xfrm: make gc_thresh configurable in all namespaces

Michal Kubeƒçek (1):
      netfilter: nf_ct_reasm: fix per-netns sysctl initialization

Micha≈Ç Miros≈Çaw (1):
      net: disallow drivers with buggy VLAN accel to register_netdevice()

Ming Lei (1):
      usbnet: pegasus: set wakeup enable in set_wol

Miriam Shitrit (1):
      bnx2x: add `ethtool -w' support.

Mitch A Williams (2):
      igb: Don't give VFs random MAC addresses
      igbvf: be sane about random MAC addresses

Mohammed Shafi Shajakhan (9):
      ath6kl: Fix a mismatch in power management debug message
      ath6kl: Remove erroneous flag clearing
      ath6kl: Use standard way to assign the boolean variable
      ath6kl: remove unnecessary check for NULL skb
      ath6kl: Fix kernel panic on continuous driver load/unload
      ath6kl: trivial cleanup on interface type selection
      ath6kl: Parse beacon interval from userspace
      ath6kl: Move and rename ath6kl_cleanup_vif function
      ath6kl: minor optimization using if, else if

Mugunthan V N (7):
      net: ethernet: davinci_cpdma: Add boundary for rx and tx descriptors
      drivers: net: cpsw: Add helper functions for VLAN ALE implementation
      drivers: net:ethernet: cpsw: add support for VLAN
      driver: net: ethernet: davinci_cpdma: add support for directed packet and source port detection
      driver: net: ethernet: cpsw: make cpts as pointer
      driver: net: ethernet: cpsw: dual emac interface implementation
      drivers: net: davinci_cpdma: acknowledge interrupt properly

Nathan Hintz (9):
      bcma: return the mips irq number in bcma_core_irq
      bcma: update pci configuration for bcm4706/bcm4716
      bcma: fix bcm4716/bcm4748 i2s irqflag
      bcma: delete duplicate readl
      bcma: jump to 'out' label for invalid 'func' value
      bcma: don't map/unmap a subset of the PCI config space
      bcma: add support for 1 and 2 byte extended config space access
      bcma: use consistent case for 'hex' constants
      bgmac: add read of interrupt mask after disabling interrupts

Neil Horman (4):
      netpoll: protect napi_poll and poll_controller during dev_[open|close]
      netpoll: Fix __netpoll_rcu_free so that it can hold the rtnl lock
      netpoll: cleanup sparse warnings
      netpoll: fix smatch warnings in netpoll core code

Nicolas Dichtel (3):
      mcast: define and use MRT[6]_MAX in ip[6]_mroute_opt()
      mcast: add multicast proxy support (IPv4 and IPv6)
      ipmr: fix sparse warning when testing origin or group

Nicolas Schichan (1):
      ARM: net: bpf_jit: fix emit_swap16() for non ARMv6+.

Nishant Sarmukadam (2):
      mwl8k: Disable tx_wait completion
      mwl8k: Wake up queues in mwl8k_start

Nithin Nayak Sujir (1):
      tg3: Remove IS_ENABLED(CONFIG_HWMON) check

Oliver Hartkopp (5):
      can: add private data space for CAN sk_buffs
      can: gw: make routing to the incoming CAN interface configurable
      can: gw: add a variable limit for CAN frame routings
      can: gw: indicate and count deleted frames due to misconfiguration
      can: rework skb reserved data handling

Pablo Neira Ayuso (7):
      netfilter: add missing xt_bpf.h header in installation
      netfilter: add missing xt_connlabel.h header in installation
      netfilter: nf_conntrack: fix compilation if sysctl are disabled
      netfilter: xt_CT: merge common code of revision 0 and 1
      netfilter: xt_CT: add alias flag
      netfilter: nfnetlink: add mutex per subsystem
      netfilter: nf_ct_helper: better logging for dropped packets

Paul Gortmaker (26):
      drivers/net: remove orphaned references to micro channel
      drivers/net: delete 8390 based EISA drivers.
      networking/cs89x0.txt: delete stale information about hand patching
      drivers/net: Clean up orphaned probes in Space.c
      drivers/net: delete orphaned MCA ibmlana driver content
      Documentation: remove obsolete networking/multicast.txt file
      drivers/net: delete 486 Apricot support
      drivers/net: delete intel 486 panther onboard ethernet support
      drivers/net: delete old 8bit ISA 3c501 driver.
      drivers/net: delete old parallel port de600/de620 drivers
      drivers/net: delete the 3Com 3c505/3c507 intel i825xx support
      drivers/net: delete ISA intel eexpress and eepro i825xx drivers
      drivers/net: delete intel i825xx based znet notebook driver
      drivers/net: delete Racal Interlan ISA ni52 (i825xx) driver
      drivers/net: delete old 8 bit ISA Racal ni5010 support.
      drivers/net: delete at1700 ISA 10Mbit driver
      drivers/net: delete old fujitsu based eth16i driver
      drivers/net: delete the really obsolete 8390 based 10Mbit ISA drivers
      drivers/net: delete old DEC depca ISA drivers support.
      drivers/net: delete Digital EtherWorks-3 support.
      drivers/net: delete old x86 variant of the seeq8005 driver
      wanrouter: completely decouple obsolete code from kernel.
      wanrouter: delete now orphaned header content, files/drivers
      gianfar: dont conditionally alloc Rx/Err irq structs
      gianfar: remove largely unused gfar_stats struct
      gianfar: convert u64 status counters to atomic64_t

Peter H√ºwe (1):
      ethernet/broadcom/tg3: Fix sparse warning: constant 0x7fffffffffffffff is so big it is long long

Piotr Haber (5):
      brcmsmac: increase timer reference count for new timers only
      brcmsmac: remove dead code
      brcmfmac: fix mmc host locking issue
      brcmfmac: turn clocks on when reading shared info
      brcmfmac: remove unnecessary locking in trap info processing

Pravin B Shelar (4):
      net: Fix possible wrong checksum generation.
      net: Add skb_unclone() helper function.
      net: factor out skb_mac_gso_segment() from skb_gso_segment()
      v4 GRE: Add TCP segmentation offload for GRE

Rafa≈Ç Mi≈Çecki (11):
      ssb: add place for serial flash driver
      bgmac: driver for GBit MAC core on BCMA bus
      ssb: add database of serial flash memories
      ssb: trivial: use pflash helper variable
      ssb: register platform device for parallel flash
      bcma: register platform device for parallel flash
      bcma: Xflash: reorder includes to make pr_fmt work
      bcma: cc: fix (and rename) define of NAND flash type
      bgmac: validate (and random if needed) MAC addr
      bgmac: fix "cmdcfg" calls for promisc and loopback modes
      bgmac: return error on failed PHY write

Rami Rosen (3):
      Bluetooth: Remove unnecessary include l2cap.h
      Bluetooth: remove an unused variable in a header file
      ipv4: fib: fix a comment.

Reese Moore (1):
      netfilter: nf_ct_pptp: Fix comment referring to incorrect RFC

Romain KUNTZ (1):
      xfrm: release neighbor upon dst destruction

Samuel Ortiz (12):
      NFC: llcp: Remove the tx backlog queue
      NFC: llcp: Fix Rx memory leak
      NFC: pn544: Separate the core code and the i2c one into different modules
      NFC: pn544: Use module_i2c_driver
      NFC: pn544: Use devm_kzalloc API
      NFC: Initial Secure Element API
      NFC: Update pn544 documentation
      NFC: Avoid memcpy on LLCP connection less Rx path
      NFC: Use skb_copy_datagram_iovec
      NFC: microread: Add i2c physical layer
      NFC: microread: Add MEI physical layer
      NFC: microread: Fix mei physical layer

Sasha Levin (2):
      bnx2x: use ARRAY_SIZE where possible
      wireless: mwifiex: remove unreachable paths

Sathya Perla (3):
      be2net: fix re-loaded PF driver to re-gain control of its VFs
      be2net: update driver version to 4.6.x
      be2net: remove BUG_ON() in be_mcc_compl_is_new()

Seth Forshee (3):
      mac80211: Fix tx queue handling during scans
      mac80211: Add flushes before going off-channel
      mac80211: Fix incorrect use of STA_PR_FMT in trace points

Shahed Shaikh (7):
      qlcnic: remove unused definitions from header file
      qlcnic: enable LRO on IPv6 without dest ip check
      qlcnic: enable RSS for TCP over IPv6
      qlcnic: Fix sparse check endian warnings
      qlcnic: Fix minidump in NPAR mode
      qlcnic: fix estimation of receive MSS in case of LRO for 83xx adapter
      qlcnic: fix ping resumption to a VM after a live migration

Shan Wei (1):
      batman-adv: use per_cpu_add helper

Signed-off-by: Sony Chacko (1):
      qlcnic: update driver version

Simon Que (1):
      net: usb: initialize tmp in dm9601.c to avoid warning

Simon Wunderlich (10):
      ath9k: add spectral scan feature
      ath9k: fix spectral scan endless mode on AR9002
      cfg80211: check radar interface combinations
      batman-adv: postpone sysfs removal when unregistering
      cfg80211: fix channel check in cfg80211_can_use_iftype_chan
      ath9k: add debug parameters for spectral scan
      ath9k: drop spectral packets after processing them
      ath9k: reorder error codes for spectral
      nl80211/cfg80211: add radar detection command/event
      mac80211: add radar detection command/event

Sony Chacko (12):
      qlcnic: change driver hardware interface mechanism
      qlcnic: 83xx memory map and HW access routines
      qlcnic: 83xx data path routines
      qlcnic: 83xx base driver
      qlcnic: 83xx sysfs routines
      qlcnic: 83xx adpater flash interface routines
      qlcnic: 83xx CNA inter driver communication mechanism
      qlcnic: flash template based firmware reset recovery
      qlcnic: enable 83xx virtual NIC mode
      qlcnic: 83xx register dump routines
      qlcnic: 83xx ethtool interface routines
      qlcnic: fix build error

Sritej Velaga (1):
      qlcnic: set driver version in firmware

Stanislaw Gruszka (12):
      rt2800: refactor RFCSR initialization
      iwlegacy: add flush callback
      iwlegacy: allow to enable PS
      mac80211: remove IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
      rt2x00: print chip and firmware version by default
      rt2x00: print warning, notice and info as default
      rt2800usb: move "TX status missed" messages to debug level
      rt2x00: remove NOTICE
      mac80211: improve latency and throughput while software scanning
      iwlegacy: check for dma mapping errors
      rt2x00: check for dma mappings errors
      iwlegacy: more checks for dma mapping errors

Stefan Assmann (1):
      igb: increase timeout for ethtool offline self-test

Stefan Hajnoczi (1):
      net: split eth_mac_addr for better error handling

Stefan Raspl (6):
      qeth: Fix retry logic in hardsetup
      qeth: Remove unused exports
      qeth: Support VEPA mode
      qeth: Update Kconfig wording
      qeth: Make s390dbf card entries persistent
      qeth: Fix HiperSockets performance regression

Stefan Roese (1):
      net: fec_mpc52xx: Read MAC address from device-tree

Steffen Klassert (4):
      xfrm: Remove unused defines
      xfrm: Add a state resolution packet queue
      ipv6: Don't send packet to big messages to self
      xfrm: Allow inserting policies with matching mark and different priorities

Stephen Hemminger (14):
      vmxnet3: use netdev_alloc_skb_ip_align
      vmxnet3: remove unnecessary bookkeeping
      vmxnet3: fix messages printed before registration
      vmxnet3: use netdev_dbg
      vmxnet3: use netdev_ printk wrappers
      vmxnet3: remove VMXNET3_MAX_DEVICES
      vmxnet3: remove device counter
      vmxnet3: remove unused irq_share_mode
      vmxnet3: use static RSS key
      vmxnet3: better RSS support
      qlcnic: make pci_error_handlers const
      tcp: remove Appropriate Byte Count support
      ethtool: fix sparse warning
      mrp: make mrp_rcv static

Stephen Rothwell (1):
      qlcnic: do not duplicate infrastructure functions

Steve Glendinning (2):
      smsc95xx: eliminate duplicate warnings on io failure
      smsc95xx: enable dynamic autosuspend

Sucheta Chakraborty (1):
      qlcnic: fix mailbox interrupt.

Sujith Manoharan (12):
      ath9k_hw: Remove AR9485 1.0 macro
      ath9k_hw: Enable calibration types in init_cal_settings
      ath9k_hw: Remove TEMP_COMP_CAL
      ath9k_hw: Fix calibration for AR9340
      ath9k_hw: Do not enable IQ-CAL for half/quarter rates
      ath9k_hw: Fix MCI init for AGC calibration
      ath9k_hw: Use helper routines to simplify ar9003_hw_init_cal()
      ath9k_hw: Update initvals for QCA955x
      ath9k_hw: Add TempCompensation feature for AR9550
      ath9k_hw: Fix radio programming for AR9550
      ath9k: Fix ATH9K_HW_CAP_HT usage
      ath9k: Fix IBSS joiner mode

Sven Eckelmann (7):
      ath9k: Update spectral scan output data
      ath9k: Select RELAY for ATH9K_DEBUGFS
      ath9k: Only process fft samples when ATH9K_DEBUGFS is enabled
      ath9k: Only add fix_rssi_inv_only when spectral code is used
      ath9k: Only remove spectral scan relay file when it was created
      ath9k: Fix sparse __CHECK_ENDIAN__ for spectral code
      ath9k: Remove unused variables in ath_mci_cleanup

Szymon Janc (3):
      Bluetooth: mgmt: Remove not needed restriction on add/remove OOB data
      Bluetooth: mgmt: Avoid using magic number in status code
      Bluetooth: Fix pair device command reply if adapter is powered off

Thierry Escande (3):
      NFC: Add support for SO_TIMESTAMP LLCP socket option
      NFC: pn533: Fix bad allocation size
      NFC: pn533: Fix target polling mode

Thierry Reding (1):
      net: ethernet: davinci: Fix build breakage

Thomas Graf (1):
      Remove leftover #endif after introducing SO_REUSEPORT

Thomas Pedersen (16):
      mac80211_hwsim: fix tsf adjustment
      mac80211_hwsim: hrtimer beacon
      mac80211_hwsim: fix beacon timing
      mac80211_hwsim: fix beacon timestamp and mactime
      mac80211: clean up mesh sta allocation warning
      mac80211: support mesh rate updates
      mac80211: fix mesh_sta_info_get() reshuffle damage
      mac80211: dynamic short slot time for MBSSs
      mac80211: stop plink timer only on mesh interfaces
      mac80211: fix mesh sta teardown
      mac80211: consolidate MBSS change notification
      mac80211: cache mesh beacon
      mac80211: generate mesh probe responses
      mac80211: clean up mesh HT operation
      mac80211: stringify mesh peering events
      mac80211: don't spam mesh probe response messages

Tilman Schmidt (5):
      isdn/divert: fix readability damage
      isdn/gigaset: leave DLE mode before hanging up
      isdn/gigaset: beautify interface.c
      isdn/gigaset: beautify common.c
      isdn/gigaset: beautify ev-layer.c

Tim Gardner (2):
      brcmsmac: fix u16 overflow warning
      brcmsmac: avoid 512 byte stack variable

Timo Ter√§s (1):
      r8169: remove unneeded dirty_rx index

Tom Herbert (7):
      soreuseport: infrastructure
      soreuseport: TCP/IPv4 implementation
      soreuseport: UDP/IPv4 implementation
      soreuseport: TCP/IPv6 implementation
      soreuseport: UDP/IPv6 implementation
      soreuseport: fix use of uid in tb->fastuid
      mlx4_en: Fix BQL reset TX queue call point

Tom Parkin (4):
      l2tp: put tunnel socket release on a workqueue
      l2tp: set netnsok flag for netlink messages
      l2tp: prevent tunnel creation on netns mismatch
      l2tp: create tunnel sockets in the right namespace

Tomasz Guszkowski (1):
      p54usb: corrected USB ID for T-Com Sinus 154 data II

Tushar Behera (1):
      wlcore: Remove redundant check on unsigned variable

Vasanthakumar Thiagarajan (2):
      cfg80211: Move the definition of struct mac_address up
      cfg80211/nl80211: add API for MAC address ACLs

Victor Goldenshtein (4):
      wlcore: add new reg-domain configuration command
      wlcore: remove unnecessary WARN_ON in wl12xx_tx_reset
      wlcore: restore default channel configuration
      wl18xx: add new phy configuration parameters for telec support

Vijay Subramanian (1):
      doc: Clarify behavior when sysctl tcp_ecn = 1

Vincent Bernat (1):
      sk-filter: Add ability to lock a socket filter program

Vipul Pandya (5):
      cxgb4: Fix incorrect PFVF CMASK
      cxgb3: Fix Tx csum stats
      cxgb3: Update VLAN extraction stats in the GRO path
      cxgb4vf: Fix extraction of cpl_rx_pkt from the response queue descriptor
      cxgb4vf: Fix VLAN extraction counter increment

Vlad Yasevich (12):
      bridge: Add vlan filtering infrastructure
      bridge: Validate that vlan is permitted on ingress
      bridge: Verify that a vlan is allowed to egress on given port
      bridge: Add netlink interface to configure vlans on bridge ports
      bridge: Dump vlan information from a bridge port
      bridge: Implement vlan ingress/egress policy with PVID.
      bridge: Add the ability to configure pvid
      bridge: Add vlan to unicast fdb entries
      bridge: Add vlan id to multicast groups
      bridge: Add vlan support to static neighbors
      bridge: Add vlan support for local fdb entries
      bridge: Separate egress policy bitmap

Vladimir Kondratiev (17):
      wireless: more 'capability info' bits
      wil6210: Detect FW error
      wil6210: rearrange IRQ debug printing
      wil6210: remove raw wil_dbg() calls
      wil6210: Refactor rx init/fini
      wil6210: Count Tx statistics on Tx completion
      wil6210: Fix: Tx stall
      wil6210: Call skb_orphan() right before Rx indication
      wil6210: Fix "don't scan after connect" logic
      wil6210: Separate common code for mbox regs caching to function
      wil6210: Reorder reset preparation sequence
      wil6210: fix checkpatch CamelCase warnings
      wil6210: checkpatch warnings
      wil6210: Never delete Rx chain with firmware
      wil6210: fix wil_vring_init_tx status
      cfg80211: expand per-station byte counters to 64bit
      ath6kl: provide 64-bit per-station byte counters

Waldemar Rymarkiewicz (30):
      NFC: pn533: Remove in/out_maxlen as it is not used
      NFC: pn533: Remove unused definitions
      NFC: pn533: Add frame header length define
      NFC: pn533: Remove pointless flags param
      NFC: pn533: Add a new pn533_send_cmd_async iface
      NFC: pn533: Add a new pn533_send_data_async iface
      NFC: pn533: Add a new pn533_send_sync iface
      NFC: pn533: Add pn533_alloc_skb for req allocation
      NFC: pn533: Remove pn533_send_cmd_frame_sync
      NFC: pn533: Del frame logic from TgGet/SetData cmd
      NFC: pn533: Del frame logic from InJumForDep cmd
      NFC: pn533: Del frame logic from Data Exchange cmd
      NFC: pn533: Dump tx and rx data in debug mode
      NFC: pn533: Remove frame logic from poll cmds
      NFC: pn533: Fix quoted strings split across lines
      NFC: pn533: Fix spacing issues
      NFC: pn533: Fix open parenthesis alignment
      NFC: pn533: Fix minor style issues
      NFC: pn533: Remove unused pn533_send_cmd_frame_asy
      NFC: pn533: Fix urb->status handling
      NFC: pn533: Cleanup debug messages
      NFC: pn533: Don't use out_frame in pn533_send_ack
      NFC: pn533: Use skb in __pn533_send_cmd_frame_asyn
      NFC: pn533: Remove deprecated dev->out_frame buff
      NFC: pn533: Cleanup pn533_cmd_complete_t
      NFC: pn533: Remove unused dev->wq_in_frame
      NFC: pn533: Introduce ops for frame logic
      NFC: pn533: Fix missing parenthesis
      nfc: pn533: Use static poll_mod and std_frame_ops
      nfc: pn533: Remove unreachable code

Wei Yongjun (2):
      wlcore: spi: use platform_device_unregister in wl1271_remove()
      wlcore: sdio: use platform_device_unregister in wl1271_remove()

Willem de Bruijn (1):
      netfilter: x_tables: add xt_bpf match

Wojciech Dubowik (1):
      mac80211: fix ieee80211_sta_tx_notify for nullfunc

Wu Fengguang (1):
      net: asix: ax88772_unbind() can be static

Xose Vazquez Perez (4):
      wireless: rt2x00: rt2800usb add/identify ids
      wireless: rt2x00: rt2800pci add id
      wireless: rt2x00: rt2800usb add Sweex ids
      wireless: rt2x00: rt2800usb add "unknown" devices

YOSHIFUJI Hideaki (2):
      ipv6: Fix endianess warning in ip6_flow_hdr().
      ipv6: Make ipv6_addr_is_XXX() return boolean.

YOSHIFUJI Hideaki / ÂêâËó§Ëã±Êòé (82):
      ndisc: Remove unused space at tail of skb for ndisc messages. (TAKE 3)
      ndisc: Use struct rd_msg for redirect message.
      ipv4: Use FIELD_SIZEOF() in inet_init().
      ipv6: Use FIELD_SIZEOF() in inet6_init().
      netlink: Use FIELD_SIZEOF() in netlink_proto_init().
      openvswitch: Use FIELD_SIZEOF() in dp_init().
      rxrpc: Use FIELD_SIZEOF() in af_rxrpc_init().
      unix: Use FIELD_SIZEOF() in af_unix_init().
      ipv6: Use container_of macro instead of magic number to get ipv6 header.
      ipv6: Optimize ipv6_change_dsfield().
      ipv6: Introduce ip6_flow_hdr() to fill version, tclass and flowlabel.
      ipv6: Introduce ip6_flowinfo() to extract flowinfo (tclass + flowlabel).
      ipv6: Use ipv6_get_dsfield() instead of ipv6_tclass().
      ipv6: Make ipv6_is_mld() inline and use it from ip6_mc_input().
      ipv6 route: Use ipv6_addr_hash() in rt6_info_hash_nhsfn().
      ipv6 xfrm: Use ipv6_addr_hash() in xfrm6_tunnel_spi_hash_byaddr().
      ipv6: Store Router Alert option in IP6CB directly.
      ipv6: Move comment to right place.
      ipv6: 64bit version of ipv6_addr_diff().
      ipv6: 64bit version of ipv6_addr_loopback().
      ipv6: 64bit version of ipv6_addr_v4mapped().
      ipv6: 64bit version of ipv6_addr_set().
      ipv6: Remove __ipv6_prefix_equal().
      ipv6: 64bit version of ipv6_prefix_equal().
      ipv6 netevent: Remove old_neigh from netevent_redirect.
      ndisc: Update neigh->updated with write lock.
      ndisc: Remove tbl argument for __ipv6_neigh_lookup().
      ipv6 route: Dump gateway based on RTF_GATEWAY flag and rt->rt6i_gateway.
      ndisc: Introduce __ipv6_neigh_lookup_noref().
      ipv6: Do not depend on rt->n in ip6_pol_route().
      ipv6: Do not depend on rt->n in rt6_check_neigh().
      ipv6: Do not depend on rt->n in rt6_probe().
      ipv6: Introduce rt6_nexthop() to select nexthop address.
      ipv6: Do not depend on rt->n in ip6_dst_lookup_tail().
      ipv6: Do not depend on rt->n in ip6_finish_output2().
      ipv6: Complete neighbour entry removal from dst_entry.
      ipv6: Remove unused neigh argument for icmp6_dst_alloc() and its callers.
      ndisc: Check NS message length before access.
      ipv6: Introduce ipv6_addr_is_solict_mult() to check Solicited Node Multicast Addresses.
      ipv6: Optimize ipv6_addr_is_solict_mult().
      ipv6: Optimize ipv6_addr_is_ll_all_{nodes,routers}().
      ndisc: Make several arguments for ndisc_send_na() boolean.
      firewire net: Ensure checksumming in upper layer.
      firewire net: Use LL_RESERVED_SPACE(), HH_DATA_OFF().
      ndisc: Reduce number of arguments for ndisc_fill_addr_option().
      ndisc: Move ndisc_opt_addr_space() to include/net/ndisc.h.
      ndisc: Use skb_linearize() instead of pskb_may_pull(skb, skb->len).
      ndisc: Introduce ndisc_fill_redirect_hdr_option().
      ndisc: Introduce ndisc_alloc_skb() helper.
      ipv6: Unshare ip6_nd_hdr() and change return type to void.
      ndisc: Simplify arguments for ip6_nd_hdr().
      ndisc: Set skb->dev and skb->protocol inside ndisc_alloc_skb().
      ndisc: Remove dev argument for ndisc_send_skb().
      ndisc: Defer building IPv6 header.
      ndisc: Reset skb->trasport_headner inside ndisc_alloc_send_skb().
      ndisc: Calculate message body length and option length separately.
      ndisc: Make ndisc_fill_xxx_option() for sk_buff.
      ndisc: Remove icmp6h argument from ndisc_send_skb().
      ndisc: Use ndisc_send_skb() for redirect.
      ndisc: Fill in ICMPv6 checksum and IPv6 header in ndisc_send_skb().
      ndisc: Break down __ndisc_send().
      ndisc: Break down ndisc_build_skb() and build message directly.
      ndisc: Use compound literals to build redirect message.
      ndisc: Do not try to update "updated" time if neighbour has already gone.
      neigh: Keep neighbour cache entries if number of them is small enough.
      net: Use IS_ERR_OR_NULL().
      ipv4: Use IS_ERR_OR_NULL().
      ipv6: Use IS_ERR_OR_NULL().
      netfilter: Use IS_ERR_OR_NULL().
      net neigh: Optimize neighbor entry size calculation.
      ipv6 mcast: Use ipv6_addr_equal() in ip6_mc_source().
      xfrm: Use ipv6_addr_equal() where appropriate.
      xfrm: Convert xfrm_addr_cmp() to boolean xfrm_addr_equal().
      netfilter ip6table_mangle: Use ipv6_addr_equal() where appropriate.
      netfilter ipset: Use ipv6_addr_equal() where appropriate.
      ipv6 flowlabel: Ensure to take lock when modifying np->ip6_sk_fl_list.
      ipv6 flowlabel: Convert hash list to RCU.
      ipv6 flowlabel: Convert np->ipv6_fl_list to RCU.
      ipv6 anycast: Convert ipv6_sk_ac_lock to spinlock.
      ipv6 mcast: Do not join device multicast for interface-local multicasts.
      net neighbour, decnet: Ensure to align device private data on preferred alignment.
      ipv6: fix race condition regarding dst->expires and dst->from.

Yacine Belkadi (1):
      {cfg,mac}80211.h: fix some kernel-doc warnings

Yair Shapira (3):
      wlcore/wl18xx/wl12xx: add recovery settings to conf
      wl18xx: support 2nd set of mac/phy tx-power params
      wl18xx: fix a bug in wl->num_rx_desc initialization

Yan Burman (10):
      net/vxlan: Add ethtool drvinfo
      net/mlx4_en: Optimize loopback related checks in data path
      net/mlx4_en: Optimize Rx fast path filter checks
      net/mlx4_en: Cleanup multiline strings
      net/mlx4: Move Ethernet related functionality from mlx4_core to mlx4_en
      net/mlx4_en: Re-arrange ndo_set_rx_mode related code
      net/mlx4_en: Save previous MAC address of the port so we can replace it later
      net/mlx4_en: Manage hash of MAC addresses per port
      net/mlx4_en: Add unicast MAC filtering
      net/mlx4_en: Implement ndo fdb functionality

Yaniv Rosner (1):
      bnx2x: Fix rare self-test failures

Ying Xue (5):
      net: remove redundant check for timer pending state before del_timer
      tipc: eliminate duplicated discard_rx_queue routine
      tipc: byte-based overload control on socket receive queue
      tipc: remove redundant checking for the number of iovecs in a send request
      net: fix a compile error when SOCK_REFCNT_DEBUG is enabled

Yogesh Ashok Powar (20):
      mwl8k: Remove redundant txq_idx
      mwl8k: set ack policy to normal
      mwl8k: Enable support to support additional ampdu streams
      mwl8k: changing mwl8k_destroy_ba prototype
      mwl8k: Handle Watchdog events for the new ampdu streams
      mwl8k: Handle watchdog event with highest prioriry
      mwl8k: bump firmware API to 3
      mwl8k: Delete ampdu streams with state AMPDU_STREAM_NEW in sta remove
      mwl8k: Stop bsses before hw specific commands
      mwl8k: Do not call mwl8k_cmd_set_rf_channel unconditionally
      mwl8k: Move tx/rx antenna configuration to mwl8k_probe_hw
      mwl8k: Announce simultaneous AP-STA support on AP fw
      mwl8k: Allow adding station interface on AP firmware
      mwl8k: set mac type to MWL8K_MAC_TYPE_SECONDARY_CLIENT
      mwl8k: Enable hw encryption for STA mode on AP fw
      mwl8k: Add/Del self entry for AP interface only
      mwl8k: Choose interface specific calls on vif type
      mwl8k: Do not call STA specific cmds not supported by the AP fw
      mwifiex: coding style cleanup in bss parameter update
      mwifiex: add 802.11AC support

Yoni Divinsky (1):
      mac80211: add op to configure default key id

Yuval Mintz (16):
      bnx2x: Clear dirty status when booting after UNDI
      bnx2x: Added nvram personalities support
      bnx2x: improve stop-on-error
      bnx2x: Clean previous IGU status before ack
      bnx2x: Added FW GRO bridging support
      bnx2x: Introduce 2013 and advance version to 1.78.02
      bnx2x: fix GRO parameters
      bnx2x: Semantic renovation
      bnx2x: reorganization and beautification
      bnx2x: correct usleep_range usage
      bnx2x: Add additional debug information
      bnx2x: Add missing VFs reference in macros
      bnx2x: Modify unload conditions
      bnx2x: Remove many sparse warnings
      bnx2x: correct memory release scheme
      bnx2x: Fix compilation with stop-on-error

bingtian.ly@taobao.com (1):
      net: avoid to hang up on sending due to sysctl configuration overflow.

nikolay@redhat.com (3):
      bonding: Fix race condition between bond_enslave() and bond_3ad_update_lacp_rate()
      bonding: Fix initialize after use for 3ad machine state spinlock
      bonding: fix bond_release_all inconsistencies

stephen hemminger (7):
      sctp: make sctp_addr_wq_timeout_handler static
      tcp: make proc_tcp_fastopen_key static
      skbuff: make __kmalloc_reserve static
      bridge: respect RFC2863 operational state
      netfilter: nf_ct_snmp: add include file
      ipv6: fix warning in xfrm6_mode_tunnel_input
      ip: fix warning in xfrm4_mode_tunnel_input

 Documentation/DocBook/80211.tmpl                                                  |    4 +-
 Documentation/devicetree/bindings/net/cpsw.txt                                    |    2 +
 Documentation/ioctl/ioctl-number.txt                                              |    2 +-
 Documentation/magic-number.txt                                                    |    2 +-
 Documentation/networking/00-INDEX                                                 |    6 -
 Documentation/networking/DLINK.txt                                                |  203 ---
 Documentation/networking/LICENSE.qlcnic                                           |    2 +-
 Documentation/networking/cs89x0.txt                                               |   79 -
 Documentation/networking/depca.txt                                                |   92 --
 Documentation/networking/ewrk3.txt                                                |   46 -
 Documentation/networking/filter.txt                                               |   11 +-
 Documentation/networking/ip-sysctl.txt                                            |   19 +-
 Documentation/networking/multicast.txt                                            |   63 -
 Documentation/networking/netconsole.txt                                           |    7 +-
 Documentation/networking/nf_conntrack-sysctl.txt                                  |  176 +++
 Documentation/networking/operstates.txt                                           |    4 +
 Documentation/networking/phy.txt                                                  |   11 +-
 Documentation/nfc/nfc-hci.txt                                                     |  129 +-
 Documentation/nfc/nfc-pn544.txt                                                   |   84 +-
 Documentation/zh_CN/magic-number.txt                                              |    2 +-
 MAINTAINERS                                                                       |   14 +-
 arch/alpha/include/uapi/asm/socket.h                                              |    3 +-
 arch/arm/mach-omap2/board-omap3evm.c                                              |   10 +-
 arch/arm/net/bpf_jit_32.c                                                         |   15 +-
 arch/avr32/include/uapi/asm/socket.h                                              |    4 +-
 arch/cris/include/uapi/asm/socket.h                                               |    4 +-
 arch/frv/include/uapi/asm/socket.h                                                |    4 +-
 arch/h8300/include/uapi/asm/socket.h                                              |    4 +-
 arch/ia64/include/uapi/asm/socket.h                                               |    4 +-
 arch/m32r/include/uapi/asm/socket.h                                               |    4 +-
 arch/mips/bcm47xx/serial.c                                                        |    2 +-
 arch/mips/include/uapi/asm/socket.h                                               |    5 +-
 arch/mn10300/include/uapi/asm/socket.h                                            |    4 +-
 arch/parisc/include/uapi/asm/socket.h                                             |    3 +-
 arch/powerpc/include/uapi/asm/socket.h                                            |    4 +-
 arch/s390/include/uapi/asm/socket.h                                               |    4 +-
 arch/sparc/include/uapi/asm/socket.h                                              |    3 +-
 arch/um/drivers/net_kern.c                                                        |   26 +-
 arch/um/include/shared/net_kern.h                                                 |    1 -
 arch/x86/crypto/aesni-intel_glue.c                                                |   37 -
 arch/x86/net/bpf_jit_comp.c                                                       |   40 +-
 arch/xtensa/include/uapi/asm/socket.h                                             |    4 +-
 crypto/ctr.c                                                                      |  173 ++-
 crypto/tcrypt.c                                                                   |    4 +
 crypto/tcrypt.h                                                                   |    1 +
 drivers/bcma/bcma_private.h                                                       |    3 +
 drivers/bcma/driver_chipcommon.c                                                  |    2 +-
 drivers/bcma/driver_chipcommon_nflash.c                                           |    4 +-
 drivers/bcma/driver_chipcommon_pmu.c                                              |    3 +-
 drivers/bcma/driver_chipcommon_sflash.c                                           |    4 +-
 drivers/bcma/driver_gpio.c                                                        |   11 +
 drivers/bcma/driver_mips.c                                                        |  195 ++-
 drivers/bcma/driver_pci_host.c                                                    |   62 +-
 drivers/bcma/main.c                                                               |   12 +-
 drivers/connector/connector.c                                                     |    4 +-
 drivers/firewire/net.c                                                            |   14 +-
 drivers/infiniband/hw/nes/nes.c                                                   |    8 +-
 drivers/infiniband/hw/nes/nes_cm.c                                                |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c                                               |   13 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c                                      |    2 +-
 drivers/isdn/divert/divert_init.c                                                 |   33 +-
 drivers/isdn/divert/isdn_divert.c                                                 |  423 +++---
 drivers/isdn/divert/isdn_divert.h                                                 |   28 +-
 drivers/isdn/gigaset/common.c                                                     |   31 +-
 drivers/isdn/gigaset/ev-layer.c                                                   |  124 +-
 drivers/isdn/gigaset/gigaset.h                                                    |    9 +-
 drivers/isdn/gigaset/interface.c                                                  |   46 +-
 drivers/isdn/i4l/isdn_x25iface.h                                                  |    1 -
 drivers/net/Space.c                                                               |  106 +-
 drivers/net/bonding/bond_3ad.c                                                    |   45 +-
 drivers/net/bonding/bond_alb.c                                                    |    6 +-
 drivers/net/bonding/bond_main.c                                                   |  285 ++--
 drivers/net/bonding/bonding.h                                                     |   15 +-
 drivers/net/caif/caif_shmcore.c                                                   |    6 -
 drivers/net/can/Kconfig                                                           |   37 +-
 drivers/net/can/Makefile                                                          |    2 +
 drivers/net/can/at91_can.c                                                        |   10 +
 drivers/net/can/c_can/Kconfig                                                     |    2 +-
 drivers/net/can/c_can/c_can.c                                                     |   10 +
 drivers/net/can/cc770/Kconfig                                                     |    2 +-
 drivers/net/can/dev.c                                                             |   26 +-
 drivers/net/can/flexcan.c                                                         |   11 +
 drivers/net/can/led.c                                                             |  124 ++
 drivers/net/can/mcp251x.c                                                         |   23 +-
 drivers/net/can/mscan/Kconfig                                                     |    2 +-
 drivers/net/can/sja1000/Kconfig                                                   |   14 +-
 drivers/net/can/sja1000/ems_pci.c                                                 |    1 -
 drivers/net/can/sja1000/peak_pci.c                                                |    5 +-
 drivers/net/can/sja1000/peak_pcmcia.c                                             |    1 -
 drivers/net/can/sja1000/plx_pci.c                                                 |    1 -
 drivers/net/can/sja1000/sja1000.c                                                 |   17 +-
 drivers/net/can/slcan.c                                                           |    8 +-
 drivers/net/can/softing/Kconfig                                                   |    2 +-
 drivers/net/can/ti_hecc.c                                                         |   10 +
 drivers/net/can/usb/Kconfig                                                       |    8 +-
 drivers/net/can/usb/Makefile                                                      |    1 +
 drivers/net/can/usb/ems_usb.c                                                     |    8 +-
 drivers/net/can/usb/kvaser_usb.c                                                  |    2 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                                      |    5 -
 drivers/net/can/usb/usb_8dev.c                                                    | 1031 +++++++++++++
 drivers/net/cris/eth_v10.c                                                        |    8 +-
 drivers/net/dsa/mv88e6060.c                                                       |   54 +-
 drivers/net/dsa/mv88e6123_61_65.c                                                 |  125 +-
 drivers/net/dsa/mv88e6131.c                                                       |  114 +-
 drivers/net/dsa/mv88e6xxx.c                                                       |  141 +-
 drivers/net/dsa/mv88e6xxx.h                                                       |   11 +-
 drivers/net/dummy.c                                                               |   10 +
 drivers/net/ethernet/3com/3c501.c                                                 |  896 ------------
 drivers/net/ethernet/3com/3c501.h                                                 |   91 --
 drivers/net/ethernet/3com/3c509.c                                                 |    4 +-
 drivers/net/ethernet/3com/3c515.c                                                 |    7 +-
 drivers/net/ethernet/3com/3c59x.c                                                 |    1 -
 drivers/net/ethernet/3com/Kconfig                                                 |   20 +-
 drivers/net/ethernet/3com/Makefile                                                |    1 -
 drivers/net/ethernet/8390/3c503.c                                                 |  777 ----------
 drivers/net/ethernet/8390/3c503.h                                                 |   91 --
 drivers/net/ethernet/8390/Kconfig                                                 |  119 +-
 drivers/net/ethernet/8390/Makefile                                                |   10 -
 drivers/net/ethernet/8390/ac3200.c                                                |  431 ------
 drivers/net/ethernet/8390/ax88796.c                                               |    8 +-
 drivers/net/ethernet/8390/e2100.c                                                 |  489 -------
 drivers/net/ethernet/8390/es3210.c                                                |  445 ------
 drivers/net/ethernet/8390/hp-plus.c                                               |  505 -------
 drivers/net/ethernet/8390/hp.c                                                    |  438 ------
 drivers/net/ethernet/8390/lne390.c                                                |  433 ------
 drivers/net/ethernet/8390/ne2k-pci.c                                              |    1 -
 drivers/net/ethernet/8390/ne3210.c                                                |  346 -----
 drivers/net/ethernet/8390/smc-ultra32.c                                           |  463 ------
 drivers/net/ethernet/Kconfig                                                      |    1 -
 drivers/net/ethernet/Makefile                                                     |    1 -
 drivers/net/ethernet/adi/bfin_mac.c                                               |   13 +-
 drivers/net/ethernet/aeroflex/greth.c                                             |   13 +-
 drivers/net/ethernet/amd/Kconfig                                                  |   15 +-
 drivers/net/ethernet/amd/Makefile                                                 |    1 -
 drivers/net/ethernet/amd/au1000_eth.c                                             |   12 +-
 drivers/net/ethernet/amd/depca.c                                                  | 1910 ------------------------
 drivers/net/ethernet/amd/depca.h                                                  |  183 ---
 drivers/net/ethernet/amd/pcnet32.c                                                |   50 +-
 drivers/net/ethernet/amd/sunlance.c                                               |    4 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c                                   |   12 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c                                   |    3 -
 drivers/net/ethernet/atheros/atlx/atl1.c                                          |    2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c                                          |    7 -
 drivers/net/ethernet/atheros/atlx/atlx.c                                          |    1 -
 drivers/net/ethernet/broadcom/Kconfig                                             |   18 +
 drivers/net/ethernet/broadcom/Makefile                                            |    1 +
 drivers/net/ethernet/broadcom/b44.c                                               |    9 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c                                      |   17 +-
 drivers/net/ethernet/broadcom/bgmac.c                                             | 1461 +++++++++++++++++++
 drivers/net/ethernet/broadcom/bgmac.h                                             |  453 ++++++
 drivers/net/ethernet/broadcom/bnx2.c                                              |    1 -
 drivers/net/ethernet/broadcom/bnx2x/Makefile                                      |    3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                                       |  174 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                                   |  993 ++++++++-----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                                   |  123 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c                                   |    7 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h                                   |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dump.h                                  | 3274 ++++++++++++++++++++++++++++--------------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c                               |  456 ++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h                               |    8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_file_hdr.h                           |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h                                   |   32 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h                                  |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h                              |    8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c                                  |   22 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h                                  |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                                  | 1669 ++++++++++++---------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_mfw_req.h                               |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h                                   |   58 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c                                    |  203 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h                                    |   30 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c                                 | 3198 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h                                 |  809 +++++++++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c                                 |  134 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h                                 |   13 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c                                  | 1651 +++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h                                  |  360 +++++
 drivers/net/ethernet/broadcom/cnic.c                                              |   10 +-
 drivers/net/ethernet/broadcom/cnic_if.h                                           |    1 +
 drivers/net/ethernet/broadcom/sb1250-mac.c                                        |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                                               | 1099 ++++++++------
 drivers/net/ethernet/broadcom/tg3.h                                               |   65 +-
 drivers/net/ethernet/cadence/macb.c                                               |    2 +-
 drivers/net/ethernet/calxeda/xgmac.c                                              |    1 -
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                                         |   28 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c                                           |    6 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c                                   |   42 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c                                |   92 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c                                          |    6 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c                                        |    2 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                                   |    5 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                                        |    1 -
 drivers/net/ethernet/chelsio/cxgb4vf/adapter.h                                    |    1 -
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                               |   23 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c                                        |    6 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c                                          |    4 +-
 drivers/net/ethernet/cisco/enic/enic_main.c                                       |   13 +-
 drivers/net/ethernet/davicom/dm9000.c                                             |    7 +-
 drivers/net/ethernet/dec/Kconfig                                                  |   16 -
 drivers/net/ethernet/dec/Makefile                                                 |    1 -
 drivers/net/ethernet/dec/ewrk3.c                                                  | 1961 -------------------------
 drivers/net/ethernet/dec/ewrk3.h                                                  |  322 -----
 drivers/net/ethernet/dlink/Kconfig                                                |   32 +-
 drivers/net/ethernet/dlink/Makefile                                               |    2 -
 drivers/net/ethernet/dlink/de600.c                                                |  529 -------
 drivers/net/ethernet/dlink/de600.h                                                |  168 ---
 drivers/net/ethernet/dlink/de620.c                                                |  987 -------------
 drivers/net/ethernet/dlink/de620.h                                                |  117 --
 drivers/net/ethernet/dlink/dl2k.c                                                 |    7 +-
 drivers/net/ethernet/dlink/sundance.c                                             |    1 -
 drivers/net/ethernet/dnet.c                                                       |    4 +-
 drivers/net/ethernet/emulex/benet/be.h                                            |    2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                                       |   46 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h                                       |   20 +
 drivers/net/ethernet/emulex/benet/be_ethtool.c                                    |   12 +-
 drivers/net/ethernet/emulex/benet/be_main.c                                       |  164 ++-
 drivers/net/ethernet/ethoc.c                                                      |   63 +-
 drivers/net/ethernet/faraday/ftgmac100.c                                          |    9 +-
 drivers/net/ethernet/faraday/ftmac100.c                                           |    6 +-
 drivers/net/ethernet/freescale/Kconfig                                            |    9 +-
 drivers/net/ethernet/freescale/Makefile                                           |    3 +-
 drivers/net/ethernet/freescale/fec.c                                              |  356 +++--
 drivers/net/ethernet/freescale/fec.h                                              |   23 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c                                      |   62 +-
 drivers/net/ethernet/freescale/fec_ptp.c                                          |    4 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c                             |    4 +-
 drivers/net/ethernet/freescale/gianfar.c                                          |  252 ++--
 drivers/net/ethernet/freescale/gianfar.h                                          |  210 +--
 drivers/net/ethernet/freescale/gianfar_ethtool.c                                  |   35 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c                                 |    8 +-
 drivers/net/ethernet/fujitsu/Kconfig                                              |   25 +-
 drivers/net/ethernet/fujitsu/Makefile                                             |    2 -
 drivers/net/ethernet/fujitsu/at1700.c                                             |  791 ----------
 drivers/net/ethernet/fujitsu/eth16i.c                                             | 1483 -------------------
 drivers/net/ethernet/i825xx/3c505.c                                               | 1671 ---------------------
 drivers/net/ethernet/i825xx/3c505.h                                               |  292 ----
 drivers/net/ethernet/i825xx/3c507.c                                               |  938 ------------
 drivers/net/ethernet/i825xx/82596.c                                               |   94 +-
 drivers/net/ethernet/i825xx/Kconfig                                               |   92 +-
 drivers/net/ethernet/i825xx/Makefile                                              |    8 -
 drivers/net/ethernet/i825xx/eepro.c                                               | 1822 -----------------------
 drivers/net/ethernet/i825xx/eexpress.c                                            | 1661 ---------------------
 drivers/net/ethernet/i825xx/eexpress.h                                            |  179 ---
 drivers/net/ethernet/i825xx/lp486e.c                                              | 1337 -----------------
 drivers/net/ethernet/i825xx/ni52.c                                                | 1346 -----------------
 drivers/net/ethernet/i825xx/ni52.h                                                |  310 ----
 drivers/net/ethernet/i825xx/znet.c                                                |  928 ------------
 drivers/net/ethernet/ibm/ehea/ehea_main.c                                         |   12 +-
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c                                          |   19 +-
 drivers/net/ethernet/ibm/emac/core.c                                              |    9 +-
 drivers/net/ethernet/ibm/emac/mal.c                                               |    7 +-
 drivers/net/ethernet/ibm/ibmveth.c                                                |    6 +-
 drivers/net/ethernet/intel/Kconfig                                                |   16 +-
 drivers/net/ethernet/intel/e100.c                                                 |    3 +-
 drivers/net/ethernet/intel/e1000/e1000.h                                          |   65 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c                                  |  140 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c                                       |  558 +++----
 drivers/net/ethernet/intel/e1000/e1000_main.c                                     |  339 +++--
 drivers/net/ethernet/intel/e1000/e1000_param.c                                    |   29 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.c                                   |  117 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.h                                   |   95 ++
 drivers/net/ethernet/intel/e1000e/82571.c                                         |   57 +-
 drivers/net/ethernet/intel/e1000e/82571.h                                         |   58 +
 drivers/net/ethernet/intel/e1000e/Makefile                                        |    4 +-
 drivers/net/ethernet/intel/e1000e/defines.h                                       |  186 +--
 drivers/net/ethernet/intel/e1000e/e1000.h                                         |  280 +---
 drivers/net/ethernet/intel/e1000e/ethtool.c                                       |  252 +++-
 drivers/net/ethernet/intel/e1000e/hw.h                                            |  367 +----
 drivers/net/ethernet/intel/e1000e/ich8lan.c                                       |  415 +++---
 drivers/net/ethernet/intel/e1000e/ich8lan.h                                       |  268 ++++
 drivers/net/ethernet/intel/e1000e/mac.c                                           |  164 ++-
 drivers/net/ethernet/intel/e1000e/mac.h                                           |   74 +
 drivers/net/ethernet/intel/e1000e/manage.c                                        |   15 +-
 drivers/net/ethernet/intel/e1000e/manage.h                                        |   72 +
 drivers/net/ethernet/intel/e1000e/netdev.c                                        |  699 +++++++--
 drivers/net/ethernet/intel/e1000e/nvm.c                                           |   28 +-
 drivers/net/ethernet/intel/e1000e/nvm.h                                           |   47 +
 drivers/net/ethernet/intel/e1000e/param.c                                         |    8 +-
 drivers/net/ethernet/intel/e1000e/phy.c                                           |  354 ++---
 drivers/net/ethernet/intel/e1000e/phy.h                                           |  242 ++++
 drivers/net/ethernet/intel/e1000e/ptp.c                                           |  277 ++++
 drivers/net/ethernet/intel/e1000e/regs.h                                          |  252 ++++
 drivers/net/ethernet/intel/igb/Makefile                                           |    4 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                                      |  630 +++++---
 drivers/net/ethernet/intel/igb/e1000_82575.h                                      |   19 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h                                    |   15 +-
 drivers/net/ethernet/intel/igb/e1000_hw.h                                         |   22 +-
 drivers/net/ethernet/intel/igb/e1000_i210.c                                       |    2 +-
 drivers/net/ethernet/intel/igb/e1000_i210.h                                       |    2 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c                                        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_mac.h                                        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_mbx.c                                        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_mbx.h                                        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.c                                        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.h                                        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c                                        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.h                                        |    2 +-
 drivers/net/ethernet/intel/igb/e1000_regs.h                                       |   18 +-
 drivers/net/ethernet/intel/igb/igb.h                                              |   69 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c                                      |   15 +-
 drivers/net/ethernet/intel/igb/igb_hwmon.c                                        |  242 ++++
 drivers/net/ethernet/intel/igb/igb_main.c                                         |  865 ++++++++---
 drivers/net/ethernet/intel/igb/igb_ptp.c                                          |   65 +-
 drivers/net/ethernet/intel/igbvf/igbvf.h                                          |    2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c                                         |   87 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c                                       |   13 +-
 drivers/net/ethernet/intel/ixgbe/Makefile                                         |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                                          |   82 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c                                    |   59 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c                                    |   57 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                                   |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h                                   |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.c                                      |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.h                                      |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c                                |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.h                                |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82599.c                                |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82599.h                                |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c                                   |   65 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c                                  |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c                                  |  320 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c                                     |   13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h                                     |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                                      |   23 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                                     |  410 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.c                                      |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h                                      |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                                      |   56 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h                                      |   12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                                      |  219 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                                    |  203 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h                                    |   16 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c                                    |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                                     |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c                                     |   10 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c                                      |    1 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c                                 |   56 +-
 drivers/net/ethernet/korina.c                                                     |    6 +-
 drivers/net/ethernet/lantiq_etop.c                                                |   12 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c                                        |   10 +-
 drivers/net/ethernet/marvell/mvmdio.c                                             |    1 -
 drivers/net/ethernet/marvell/pxa168_eth.c                                         |   11 +-
 drivers/net/ethernet/marvell/skge.c                                               |    6 +-
 drivers/net/ethernet/marvell/sky2.c                                               |    5 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                                   |  174 ++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c                                      |   26 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                                    |  869 ++++++++---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                                        |   59 +-
 drivers/net/ethernet/mellanox/mlx4/en_selftest.c                                  |    3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                                        |   24 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                                           |   11 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h                                           |    1 -
 drivers/net/ethernet/mellanox/mlx4/main.c                                         |   32 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                                          |    4 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                                         |   19 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                                      |   38 +-
 drivers/net/ethernet/mellanox/mlx4/port.c                                         |  193 +--
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c                             |    2 +-
 drivers/net/ethernet/micrel/ks8842.c                                              |    1 -
 drivers/net/ethernet/micrel/ks8851.c                                              |   44 +-
 drivers/net/ethernet/micrel/ks8851_mll.c                                          |    1 -
 drivers/net/ethernet/microchip/enc28j60.c                                         |    1 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                                  |    5 +-
 drivers/net/ethernet/natsemi/ibmlana.c                                            | 1075 --------------
 drivers/net/ethernet/natsemi/ibmlana.h                                            |  278 ----
 drivers/net/ethernet/natsemi/natsemi.c                                            |    3 -
 drivers/net/ethernet/neterion/s2io.c                                              |    1 -
 drivers/net/ethernet/neterion/vxge/vxge-ethtool.c                                 |    6 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c                                    |    1 -
 drivers/net/ethernet/nuvoton/w90p910_ether.c                                      |    4 +-
 drivers/net/ethernet/nvidia/forcedeth.c                                           |    4 +-
 drivers/net/ethernet/nxp/lpc_eth.c                                                |    9 +-
 drivers/net/ethernet/octeon/octeon_mgmt.c                                         |   14 +-
 drivers/net/ethernet/packetengines/hamachi.c                                      |    7 +-
 drivers/net/ethernet/packetengines/yellowfin.c                                    |    7 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c                               |    5 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c                                |   18 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c                              |   28 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c                              |    8 +-
 drivers/net/ethernet/qlogic/qla3xxx.c                                             |   11 +-
 drivers/net/ethernet/qlogic/qlcnic/Makefile                                       |    4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                                       |  544 +++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c                               | 3011 ++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h                               |  438 ++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c                             | 2054 ++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c                             |  225 +++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c                                   |  727 +++++-----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c                               |  550 ++++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hdr.h                                   |  108 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c                                    |  245 +++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h                                    |  194 +++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c                                  |   97 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c                                    |  816 +++++++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                                  | 1215 +++++++++++-----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c                              |  650 +++++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c                                 |  271 ++--
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                                      |   24 +-
 drivers/net/ethernet/racal/Kconfig                                                |   33 -
 drivers/net/ethernet/racal/Makefile                                               |    5 -
 drivers/net/ethernet/racal/ni5010.c                                               |  771 ----------
 drivers/net/ethernet/racal/ni5010.h                                               |  144 --
 drivers/net/ethernet/rdc/r6040.c                                                  |   14 +-
 drivers/net/ethernet/realtek/8139cp.c                                             |    1 -
 drivers/net/ethernet/realtek/8139too.c                                            |    1 -
 drivers/net/ethernet/realtek/r8169.c                                              |   14 +-
 drivers/net/ethernet/renesas/sh_eth.c                                             |   12 +-
 drivers/net/ethernet/s6gmac.c                                                     |    2 +-
 drivers/net/ethernet/seeq/Kconfig                                                 |   11 -
 drivers/net/ethernet/seeq/Makefile                                                |    1 -
 drivers/net/ethernet/seeq/seeq8005.c                                              |  749 ----------
 drivers/net/ethernet/seeq/seeq8005.h                                              |  156 --
 drivers/net/ethernet/sfc/ptp.c                                                    |    2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                                               |    6 +-
 drivers/net/ethernet/silan/sc92031.c                                              |   12 +-
 drivers/net/ethernet/sis/sis900.c                                                 |   22 +-
 drivers/net/ethernet/smsc/smc911x.c                                               |    9 +-
 drivers/net/ethernet/smsc/smc91x.c                                                |    7 +-
 drivers/net/ethernet/smsc/smsc911x.c                                              |    6 +-
 drivers/net/ethernet/smsc/smsc9420.c                                              |   11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c                              |    3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                                 |   16 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c                                  |    1 +
 drivers/net/ethernet/sun/niu.c                                                    |   48 +-
 drivers/net/ethernet/sun/sunbmac.c                                                |    4 +-
 drivers/net/ethernet/sun/sunqe.c                                                  |    7 +-
 drivers/net/ethernet/sun/sunvnet.c                                                |    6 +-
 drivers/net/ethernet/tehuti/tehuti.c                                              |    8 +-
 drivers/net/ethernet/ti/cpmac.c                                                   |   11 +-
 drivers/net/ethernet/ti/cpsw.c                                                    |  530 +++++--
 drivers/net/ethernet/ti/cpsw_ale.c                                                |  107 +-
 drivers/net/ethernet/ti/cpsw_ale.h                                                |   24 +-
 drivers/net/ethernet/ti/davinci_cpdma.c                                           |   74 +-
 drivers/net/ethernet/ti/davinci_cpdma.h                                           |   12 +-
 drivers/net/ethernet/ti/davinci_emac.c                                            |   26 +-
 drivers/net/ethernet/ti/davinci_mdio.c                                            |    4 +-
 drivers/net/ethernet/tile/tilepro.c                                               |    1 -
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                                      |    4 +-
 drivers/net/ethernet/toshiba/spider_net_ethtool.c                                 |   12 +-
 drivers/net/ethernet/toshiba/tc35815.c                                            |   13 +-
 drivers/net/ethernet/via/via-rhine.c                                              |   48 +-
 drivers/net/ethernet/wiznet/w5100.c                                               |    1 -
 drivers/net/ethernet/wiznet/w5300.c                                               |    1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c                                       |   37 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                                 |    5 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c                                          |    3 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c                                          |    7 +-
 drivers/net/hamradio/bpqether.c                                                   |    5 +-
 drivers/net/hamradio/dmascc.c                                                     |    7 +-
 drivers/net/hamradio/scc.c                                                        |    4 +-
 drivers/net/hamradio/yam.c                                                        |    4 +-
 drivers/net/hyperv/netvsc_drv.c                                                   |    6 +-
 drivers/net/ieee802154/at86rf230.c                                                |   12 -
 drivers/net/ieee802154/fakehard.c                                                 |    1 -
 drivers/net/ifb.c                                                                 |    2 +-
 drivers/net/macvlan.c                                                             |   51 +-
 drivers/net/macvtap.c                                                             |    1 +
 drivers/net/netconsole.c                                                          |   44 +-
 drivers/net/phy/micrel.c                                                          |   64 +-
 drivers/net/phy/phy_device.c                                                      |   15 +-
 drivers/net/phy/realtek.c                                                         |   50 +-
 drivers/net/phy/spi_ks8995.c                                                      |    4 +-
 drivers/net/ppp/ppp_generic.c                                                     |   11 +-
 drivers/net/ppp/pppoe.c                                                           |    4 +-
 drivers/net/rionet.c                                                              |    8 +-
 drivers/net/team/team.c                                                           |  261 ++--
 drivers/net/team/team_mode_activebackup.c                                         |   13 +-
 drivers/net/tun.c                                                                 |    1 +
 drivers/net/usb/asix.h                                                            |   18 +-
 drivers/net/usb/asix_common.c                                                     |   94 +-
 drivers/net/usb/asix_devices.c                                                    |   51 +-
 drivers/net/usb/ax88172a.c                                                        |   19 +-
 drivers/net/usb/catc.c                                                            |    6 +-
 drivers/net/usb/cdc_ether.c                                                       |    7 +
 drivers/net/usb/cdc_ncm.c                                                         |   17 +-
 drivers/net/usb/dm9601.c                                                          |    4 +-
 drivers/net/usb/hso.c                                                             |   25 +-
 drivers/net/usb/kalmia.c                                                          |    1 -
 drivers/net/usb/pegasus.c                                                         |   19 +-
 drivers/net/usb/qmi_wwan.c                                                        |    7 +
 drivers/net/usb/rndis_host.c                                                      |    1 -
 drivers/net/usb/rtl8150.c                                                         |    6 +-
 drivers/net/usb/sierra_net.c                                                      |   14 +-
 drivers/net/usb/smsc75xx.c                                                        |    6 +-
 drivers/net/usb/smsc95xx.c                                                        |  441 +++---
 drivers/net/usb/usbnet.c                                                          |    5 +-
 drivers/net/veth.c                                                                |  177 +--
 drivers/net/virtio_net.c                                                          |  115 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                                                 |  227 ++-
 drivers/net/vmxnet3/vmxnet3_ethtool.c                                             |   15 +-
 drivers/net/vmxnet3/vmxnet3_int.h                                                 |    3 -
 drivers/net/vxlan.c                                                               |   18 +-
 drivers/net/wan/Kconfig                                                           |   54 -
 drivers/net/wan/Makefile                                                          |    5 -
 drivers/net/wan/cosa.c                                                            |    9 +-
 drivers/net/wan/cycx_drv.c                                                        |  569 --------
 drivers/net/wan/cycx_main.c                                                       |  346 -----
 drivers/net/wan/cycx_x25.c                                                        | 1602 ---------------------
 drivers/net/wan/farsync.c                                                         |    6 +-
 drivers/net/wan/hdlc.c                                                            |    9 +-
 drivers/net/wan/x25_asy.c                                                         |    1 -
 drivers/net/wimax/i2400m/fw.c                                                     |    1 -
 drivers/net/wimax/i2400m/netdev.c                                                 |   10 +-
 drivers/net/wimax/i2400m/rx.c                                                     |   17 +-
 drivers/net/wimax/i2400m/usb-notif.c                                              |    1 -
 drivers/net/wimax/i2400m/usb.c                                                    |    6 +-
 drivers/net/wireless/airo_cs.c                                                    |    5 +-
 drivers/net/wireless/at76c50x-usb.c                                               |    4 +-
 drivers/net/wireless/ath/ath5k/base.c                                             |    5 +-
 drivers/net/wireless/ath/ath5k/phy.c                                              |    4 +
 drivers/net/wireless/ath/ath5k/reset.c                                            |    2 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c                                        |  133 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.h                                        |    2 -
 drivers/net/wireless/ath/ath6kl/core.h                                            |    2 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c                                        |   26 +-
 drivers/net/wireless/ath/ath6kl/init.c                                            |   36 +-
 drivers/net/wireless/ath/ath6kl/usb.c                                             |    6 +-
 drivers/net/wireless/ath/ath6kl/wmi.c                                             |   30 +-
 drivers/net/wireless/ath/ath6kl/wmi.h                                             |    6 +
 drivers/net/wireless/ath/ath9k/Kconfig                                            |    1 +
 drivers/net/wireless/ath/ath9k/ahb.c                                              |   22 +-
 drivers/net/wireless/ath/ath9k/ani.c                                              |   33 +-
 drivers/net/wireless/ath/ath9k/ani.h                                              |    8 -
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h                                  |    8 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c                                       |   50 +-
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h                                  |    4 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c                                        |   23 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c                                       |   66 +-
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h                              |  180 +++
 drivers/net/wireless/ath/ath9k/ar9003_calib.c                                     |  143 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                                    |  128 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                                        |   69 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                                       |   95 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                                       |    2 +-
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h                                  |  100 ++
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h                                  |  146 ++
 drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h                              |  132 +-
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h                              |   76 +
 drivers/net/wireless/ath/ath9k/ath9k.h                                            |  166 ++-
 drivers/net/wireless/ath/ath9k/beacon.c                                           |  115 +-
 drivers/net/wireless/ath/ath9k/debug.c                                            |  304 ++++
 drivers/net/wireless/ath/ath9k/debug.h                                            |    7 +
 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c                             |    6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                                     |   10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c                                     |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                                     |   11 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h                                           |   16 -
 drivers/net/wireless/ath/ath9k/hw.c                                               |   55 +-
 drivers/net/wireless/ath/ath9k/hw.h                                               |   58 +-
 drivers/net/wireless/ath/ath9k/init.c                                             |  123 +-
 drivers/net/wireless/ath/ath9k/mac.c                                              |    8 +-
 drivers/net/wireless/ath/ath9k/mac.h                                              |    3 +-
 drivers/net/wireless/ath/ath9k/main.c                                             |  149 +-
 drivers/net/wireless/ath/ath9k/mci.c                                              |    9 +-
 drivers/net/wireless/ath/ath9k/pci.c                                              |   39 +-
 drivers/net/wireless/ath/ath9k/rc.c                                               |   14 +-
 drivers/net/wireless/ath/ath9k/recv.c                                             |  151 +-
 drivers/net/wireless/ath/ath9k/reg.h                                              |    7 +-
 drivers/net/wireless/ath/ath9k/xmit.c                                             |  150 +-
 drivers/net/wireless/ath/carl9170/carl9170.h                                      |   19 +-
 drivers/net/wireless/ath/carl9170/fw.c                                            |   37 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h                                         |    8 +
 drivers/net/wireless/ath/carl9170/hw.h                                            |    2 +-
 drivers/net/wireless/ath/carl9170/main.c                                          |  115 +-
 drivers/net/wireless/ath/carl9170/tx.c                                            |  133 +-
 drivers/net/wireless/ath/carl9170/version.h                                       |    6 +-
 drivers/net/wireless/ath/regd.c                                                   |   37 +-
 drivers/net/wireless/ath/regd.h                                                   |   10 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c                                       |   11 +-
 drivers/net/wireless/ath/wil6210/interrupt.c                                      |   55 +-
 drivers/net/wireless/ath/wil6210/main.c                                           |   63 +-
 drivers/net/wireless/ath/wil6210/netdev.c                                         |   31 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c                                       |    4 +-
 drivers/net/wireless/ath/wil6210/txrx.c                                           |  109 +-
 drivers/net/wireless/ath/wil6210/wil6210.h                                        |   22 +-
 drivers/net/wireless/ath/wil6210/wmi.c                                            |  119 +-
 drivers/net/wireless/atmel_cs.c                                                   |    5 +-
 drivers/net/wireless/b43/dma.h                                                    |    2 +-
 drivers/net/wireless/b43/tables_nphy.c                                            |   30 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                                  |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c                                  |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c                            |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                                     |   96 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h                                 |   38 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c                                 |   56 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c                              |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h                                 |   35 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c                               |  395 +++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c                                |   54 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c                                    |   11 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h                                    |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c                                    |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h                              |   66 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                                     | 2277 +++++++++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h                                     |  183 +++
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c                               |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                                     |   43 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c                             | 1463 +++++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h                             |  113 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c                                   |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c                                 |   16 +-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c                             |   12 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c                                    |   74 +-
 drivers/net/wireless/brcm80211/brcmsmac/scb.h                                     |    1 -
 drivers/net/wireless/hostap/hostap_ap.c                                           |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c                                            |    9 +-
 drivers/net/wireless/ipw2x00/ipw2200.c                                            |    1 -
 drivers/net/wireless/iwlegacy/3945-mac.c                                          |   96 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                                          |  105 +-
 drivers/net/wireless/iwlegacy/4965-rs.c                                           |    3 +-
 drivers/net/wireless/iwlegacy/4965.c                                              |    3 -
 drivers/net/wireless/iwlegacy/commands.h                                          |    3 +-
 drivers/net/wireless/iwlegacy/common.c                                            |   68 +-
 drivers/net/wireless/iwlegacy/common.h                                            |    2 +
 drivers/net/wireless/iwlwifi/Kconfig                                              |   14 +-
 drivers/net/wireless/iwlwifi/Makefile                                             |    3 +
 drivers/net/wireless/iwlwifi/dvm/agn.h                                            |    6 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c                                          |    4 +-
 drivers/net/wireless/iwlwifi/dvm/calib.h                                          |    4 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h                                       |   31 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c                                        |    6 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h                                            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c                                        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/led.c                                            |    4 +-
 drivers/net/wireless/iwlwifi/dvm/led.h                                            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c                                            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                                       |  183 ++-
 drivers/net/wireless/iwlwifi/dvm/main.c                                           |   55 +-
 drivers/net/wireless/iwlwifi/dvm/power.c                                          |    2 +-
 drivers/net/wireless/iwlwifi/dvm/power.h                                          |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c                                             |   19 +-
 drivers/net/wireless/iwlwifi/dvm/rs.h                                             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c                                             |    4 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c                                           |    7 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c                                           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c                                            |   42 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c                                       |    4 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c                                             |   10 +-
 drivers/net/wireless/iwlwifi/dvm/tt.h                                             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                                             |  107 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c                                          |   98 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h                                         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                                         |    5 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h                                            |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h                                          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c                                       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h                                       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                                            |   27 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h                                            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c                                   |   18 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h                                   |   13 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c                                    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h                                    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h                                             |    9 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h                                        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h                                             |   22 +-
 drivers/net/wireless/iwlwifi/iwl-io.c                                             |  229 +--
 drivers/net/wireless/iwlwifi/iwl-io.h                                             |   32 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h                                      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c                                     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h                                     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                                      |  346 +++++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h                                      |   80 ++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                                        |   16 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c                                         |  514 +++++++
 drivers/net/wireless/iwlwifi/iwl-phy-db.h                                         |   82 ++
 drivers/net/wireless/iwlwifi/iwl-prph.h                                           |    7 +-
 drivers/net/wireless/iwlwifi/iwl-test.c                                           |   56 +-
 drivers/net/wireless/iwlwifi/iwl-test.h                                           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.h                                       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h                                          |  164 ++-
 drivers/net/wireless/iwlwifi/mvm/Makefile                                         |   10 +
 drivers/net/wireless/iwlwifi/mvm/binding.c                                        |  197 +++
 drivers/net/wireless/iwlwifi/mvm/d3.c                                             |  955 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                                        |  378 +++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h                                      |  282 ++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h                                     |  369 +++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h                                   |  140 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h                                      |  312 ++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h                                    |  561 ++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h                                     |  380 +++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                                      |  580 ++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                                         |  952 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c                                             |  640 +++++++++
 drivers/net/wireless/iwlwifi/mvm/led.c                                            |  134 ++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                                       |  992 +++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                                       | 1314 +++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h                                            |  500 +++++++
 drivers/net/wireless/iwlwifi/mvm/nvm.c                                            |  311 ++++
 drivers/net/wireless/iwlwifi/mvm/ops.c                                            |  682 +++++++++
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                                       |  292 ++++
 drivers/net/wireless/iwlwifi/mvm/power.c                                          |  207 +++
 drivers/net/wireless/iwlwifi/mvm/quota.c                                          |  197 +++
 drivers/net/wireless/iwlwifi/mvm/rs.c                                             | 3080 +++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/rs.h                                             |  393 +++++
 drivers/net/wireless/iwlwifi/mvm/rx.c                                             |  356 +++++
 drivers/net/wireless/iwlwifi/mvm/scan.c                                           |  442 ++++++
 drivers/net/wireless/iwlwifi/mvm/sta.c                                            | 1241 ++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.h                                            |  374 +++++
 drivers/net/wireless/iwlwifi/mvm/time-event.c                                     |  519 +++++++
 drivers/net/wireless/iwlwifi/mvm/time-event.h                                     |  214 +++
 drivers/net/wireless/iwlwifi/mvm/tx.c                                             |  916 ++++++++++++
 drivers/net/wireless/iwlwifi/mvm/utils.c                                          |  472 ++++++
 drivers/net/wireless/iwlwifi/pcie/1000.c                                          |    2 +-
 drivers/net/wireless/iwlwifi/pcie/2000.c                                          |    2 +-
 drivers/net/wireless/iwlwifi/pcie/5000.c                                          |    2 +-
 drivers/net/wireless/iwlwifi/pcie/6000.c                                          |    2 +-
 drivers/net/wireless/iwlwifi/pcie/7000.c                                          |  111 ++
 drivers/net/wireless/iwlwifi/pcie/cfg.h                                           |    6 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c                                           |   10 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h                                      |   17 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c                                            |   57 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c                                         |  361 ++++-
 drivers/net/wireless/iwlwifi/pcie/tx.c                                            |   89 +-
 drivers/net/wireless/libertas/cfg.c                                               |   45 +-
 drivers/net/wireless/libertas/cfg.h                                               |    3 -
 drivers/net/wireless/mac80211_hwsim.c                                             |  178 ++-
 drivers/net/wireless/mwifiex/11ac.c                                               |  261 ++++
 drivers/net/wireless/mwifiex/11ac.h                                               |   26 +
 drivers/net/wireless/mwifiex/11n.c                                                |   55 +-
 drivers/net/wireless/mwifiex/11n.h                                                |    6 +-
 drivers/net/wireless/mwifiex/11n_aggr.c                                           |    6 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c                                      |    5 +-
 drivers/net/wireless/mwifiex/Kconfig                                              |    4 +-
 drivers/net/wireless/mwifiex/Makefile                                             |    1 +
 drivers/net/wireless/mwifiex/README                                               |    1 -
 drivers/net/wireless/mwifiex/cfg80211.c                                           |  192 ++-
 drivers/net/wireless/mwifiex/cfp.c                                                |  159 +-
 drivers/net/wireless/mwifiex/cmdevt.c                                             |   30 +-
 drivers/net/wireless/mwifiex/debugfs.c                                            |    2 -
 drivers/net/wireless/mwifiex/decl.h                                               |   18 +
 drivers/net/wireless/mwifiex/fw.h                                                 |  141 +-
 drivers/net/wireless/mwifiex/init.c                                               |   12 +-
 drivers/net/wireless/mwifiex/ioctl.h                                              |    8 +-
 drivers/net/wireless/mwifiex/join.c                                               |   44 +-
 drivers/net/wireless/mwifiex/main.h                                               |   30 +-
 drivers/net/wireless/mwifiex/pcie.c                                               | 1262 +++++++++++-----
 drivers/net/wireless/mwifiex/pcie.h                                               |  228 ++-
 drivers/net/wireless/mwifiex/scan.c                                               |   92 +-
 drivers/net/wireless/mwifiex/sdio.c                                               |   21 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                                            |   12 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c                                        |    6 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                                          |   27 +-
 drivers/net/wireless/mwifiex/txrx.c                                               |    6 +-
 drivers/net/wireless/mwifiex/uap_cmd.c                                            |   44 +
 drivers/net/wireless/mwifiex/usb.c                                                |   34 +-
 drivers/net/wireless/mwifiex/util.c                                               |    2 +-
 drivers/net/wireless/mwifiex/util.h                                               |    8 +-
 drivers/net/wireless/mwifiex/wmm.c                                                |   15 +-
 drivers/net/wireless/mwl8k.c                                                      |  322 ++++-
 drivers/net/wireless/orinoco/main.c                                               |   17 +-
 drivers/net/wireless/orinoco/orinoco_usb.c                                        |   11 +-
 drivers/net/wireless/orinoco/scan.c                                               |    4 +-
 drivers/net/wireless/p54/p54pci.c                                                 |    7 +-
 drivers/net/wireless/p54/p54usb.c                                                 |   12 +-
 drivers/net/wireless/prism54/isl_ioctl.c                                          |    1 +
 drivers/net/wireless/prism54/islpci_mgt.c                                         |   14 +-
 drivers/net/wireless/ray_cs.c                                                     |   19 +-
 drivers/net/wireless/rndis_wlan.c                                                 |    9 +-
 drivers/net/wireless/rt2x00/rt2400pci.c                                           |   12 +-
 drivers/net/wireless/rt2x00/rt2500pci.c                                           |    7 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                                           |  816 ++++++-----
 drivers/net/wireless/rt2x00/rt2800lib.h                                           |    8 +-
 drivers/net/wireless/rt2x00/rt2800pci.c                                           |   36 +-
 drivers/net/wireless/rt2x00/rt2800usb.c                                           |   53 +-
 drivers/net/wireless/rt2x00/rt2x00.h                                              |   30 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c                                           |  108 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                                           |    6 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c                                         |   78 +-
 drivers/net/wireless/rtlwifi/Kconfig                                              |   50 +-
 drivers/net/wireless/rtlwifi/base.c                                               |    7 +-
 drivers/net/wireless/rtlwifi/core.c                                               |    4 +-
 drivers/net/wireless/rtlwifi/rc.c                                                 |   13 +-
 drivers/net/wireless/rtlwifi/regd.c                                               |   37 +-
 drivers/net/wireless/rtlwifi/regd.h                                               |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c                                 |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                                       |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c                                      |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c                                      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c                                       |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c                                       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c                                       |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c                                      |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c                                       |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c                                      |    5 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c                                       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c                                  |    2 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c                                       |   11 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c                                      |   20 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c                                      |    7 +-
 drivers/net/wireless/rtlwifi/usb.c                                                |   53 +-
 drivers/net/wireless/rtlwifi/usb.h                                                |    3 +-
 drivers/net/wireless/rtlwifi/wifi.h                                               |    2 +-
 drivers/net/wireless/ti/Kconfig                                                   |    9 +
 drivers/net/wireless/ti/Makefile                                                  |    4 +-
 drivers/net/wireless/ti/{wlcore/wl12xx_platform_data.c => wilink_platform_data.c} |    0
 drivers/net/wireless/ti/wl1251/Kconfig                                            |    2 +-
 drivers/net/wireless/ti/wl1251/event.c                                            |    6 +-
 drivers/net/wireless/ti/wl1251/main.c                                             |   24 +-
 drivers/net/wireless/ti/wl12xx/Makefile                                           |    2 +-
 drivers/net/wireless/ti/wl12xx/cmd.c                                              |   37 +
 drivers/net/wireless/ti/wl12xx/cmd.h                                              |   20 +
 drivers/net/wireless/ti/wl12xx/event.c                                            |  116 ++
 drivers/net/wireless/ti/wl12xx/event.h                                            |  111 ++
 drivers/net/wireless/ti/wl12xx/main.c                                             |  195 ++-
 drivers/net/wireless/ti/wl12xx/scan.c                                             |  501 +++++++
 drivers/net/wireless/ti/wl12xx/scan.h                                             |  140 ++
 drivers/net/wireless/ti/wl12xx/wl12xx.h                                           |   40 +-
 drivers/net/wireless/ti/wl18xx/Makefile                                           |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.c                                              |   87 +-
 drivers/net/wireless/ti/wl18xx/acx.h                                              |   55 +-
 drivers/net/wireless/ti/wl18xx/cmd.c                                              |   80 ++
 drivers/net/wireless/ti/wl18xx/cmd.h                                              |   52 +
 drivers/net/wireless/ti/wl18xx/conf.h                                             |   22 +-
 drivers/net/wireless/ti/wl18xx/event.c                                            |  111 ++
 drivers/net/wireless/ti/wl18xx/event.h                                            |   77 +
 drivers/net/wireless/ti/wl18xx/main.c                                             |  272 +++-
 drivers/net/wireless/ti/wl18xx/scan.c                                             |  326 +++++
 drivers/net/wireless/ti/wl18xx/scan.h                                             |  127 ++
 drivers/net/wireless/ti/wl18xx/tx.c                                               |   54 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h                                           |   50 +-
 drivers/net/wireless/ti/wlcore/Kconfig                                            |    5 -
 drivers/net/wireless/ti/wlcore/Makefile                                           |    3 -
 drivers/net/wireless/ti/wlcore/acx.c                                              |   15 +-
 drivers/net/wireless/ti/wlcore/acx.h                                              |    1 -
 drivers/net/wireless/ti/wlcore/boot.c                                             |   77 +-
 drivers/net/wireless/ti/wlcore/cmd.c                                              |  423 ++++--
 drivers/net/wireless/ti/wlcore/cmd.h                                              |   81 +-
 drivers/net/wireless/ti/wlcore/conf.h                                             |  110 +-
 drivers/net/wireless/ti/wlcore/debugfs.c                                          |   10 +-
 drivers/net/wireless/ti/wlcore/event.c                                            |  326 ++---
 drivers/net/wireless/ti/wlcore/event.h                                            |   99 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h                                           |   41 +
 drivers/net/wireless/ti/wlcore/init.c                                             |   19 +-
 drivers/net/wireless/ti/wlcore/io.h                                               |   12 +-
 drivers/net/wireless/ti/wlcore/main.c                                             | 1610 +++++++++++++--------
 drivers/net/wireless/ti/wlcore/ps.c                                               |   11 +-
 drivers/net/wireless/ti/wlcore/rx.c                                               |   33 +-
 drivers/net/wireless/ti/wlcore/rx.h                                               |    3 +-
 drivers/net/wireless/ti/wlcore/scan.c                                             |  696 +++------
 drivers/net/wireless/ti/wlcore/scan.h                                             |  144 +-
 drivers/net/wireless/ti/wlcore/sdio.c                                             |   34 +-
 drivers/net/wireless/ti/wlcore/spi.c                                              |   31 +-
 drivers/net/wireless/ti/wlcore/tx.c                                               |  298 ++--
 drivers/net/wireless/ti/wlcore/tx.h                                               |   35 +-
 drivers/net/wireless/ti/wlcore/wlcore.h                                           |  119 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h                                         |   58 +-
 drivers/net/wireless/zd1211rw/zd_usb.c                                            |    1 -
 drivers/net/xen-netback/interface.c                                               |    5 +-
 drivers/net/xen-netback/netback.c                                                 |    8 +-
 drivers/nfc/Kconfig                                                               |   16 +-
 drivers/nfc/Makefile                                                              |    3 +-
 drivers/nfc/microread/Kconfig                                                     |   35 +
 drivers/nfc/microread/Makefile                                                    |   10 +
 drivers/nfc/microread/i2c.c                                                       |  340 +++++
 drivers/nfc/microread/mei.c                                                       |  246 ++++
 drivers/nfc/microread/microread.c                                                 |  728 ++++++++++
 drivers/nfc/microread/microread.h                                                 |   33 +
 drivers/nfc/nfcwilink.c                                                           |   10 +-
 drivers/nfc/pn533.c                                                               | 1593 ++++++++++----------
 drivers/nfc/pn544/Kconfig                                                         |   23 +
 drivers/nfc/pn544/Makefile                                                        |    5 +-
 drivers/nfc/pn544/i2c.c                                                           |   44 +-
 drivers/nfc/pn544/pn544.c                                                         |   65 +-
 drivers/of/of_mdio.c                                                              |    4 +-
 drivers/s390/net/Kconfig                                                          |    4 +-
 drivers/s390/net/qeth_core.h                                                      |    8 +-
 drivers/s390/net/qeth_core_main.c                                                 |  256 ++--
 drivers/s390/net/qeth_core_mpc.c                                                  |    1 +
 drivers/s390/net/qeth_core_mpc.h                                                  |    5 +
 drivers/s390/net/qeth_core_sys.c                                                  |    3 +-
 drivers/s390/net/qeth_l2_main.c                                                   |   16 +-
 drivers/s390/net/qeth_l3_main.c                                                   |   35 +-
 drivers/ssb/Kconfig                                                               |    5 +
 drivers/ssb/Makefile                                                              |    1 +
 drivers/ssb/driver_chipcommon_sflash.c                                            |  140 ++
 drivers/ssb/driver_gpio.c                                                         |   22 +
 drivers/ssb/driver_mipscore.c                                                     |   51 +-
 drivers/ssb/main.c                                                                |    8 +
 drivers/ssb/ssb_private.h                                                         |   15 +
 drivers/staging/bcm/Bcmnet.c                                                      |    4 +-
 drivers/staging/ccg/u_ether.c                                                     |   10 +-
 drivers/staging/et131x/et131x.c                                                   |   10 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c                                  |    9 +-
 drivers/staging/octeon/ethernet-mdio.c                                            |    6 +-
 drivers/staging/octeon/ethernet.c                                                 |    6 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c                                   |    6 +-
 drivers/staging/wlags49_h2/wl_netdev.c                                            |   14 +-
 drivers/staging/wlan-ng/cfg80211.c                                                |    2 +-
 drivers/usb/gadget/u_ether.c                                                      |   10 +-
 fs/proc/proc_net.c                                                                |   14 -
 include/linux/bcma/bcma_driver_chipcommon.h                                       |    4 +-
 include/linux/bcma/bcma_driver_mips.h                                             |   11 +-
 include/linux/bcma/bcma_driver_pci.h                                              |    2 +
 include/linux/can/dev.h                                                           |   11 +
 include/linux/can/led.h                                                           |   51 +
 include/linux/can/skb.h                                                           |   45 +
 include/linux/cyclomx.h                                                           |   77 -
 include/linux/cycx_drv.h                                                          |   64 -
 include/linux/etherdevice.h                                                       |    4 +-
 include/linux/ieee80211.h                                                         |  155 +-
 include/linux/if_macvlan.h                                                        |    6 +
 include/linux/if_team.h                                                           |    1 +
 include/linux/in6.h                                                               |   13 +
 include/linux/inetdevice.h                                                        |    6 +
 include/linux/ipv6.h                                                              |   10 +-
 include/linux/micrel_phy.h                                                        |    9 +-
 include/linux/mlx4/device.h                                                       |    8 +-
 include/linux/mroute.h                                                            |    2 +-
 include/linux/mroute6.h                                                           |    2 +-
 include/linux/netdev_features.h                                                   |    3 +-
 include/linux/netdevice.h                                                         |  113 +-
 include/linux/netfilter/nf_conntrack_sip.h                                        |    3 +
 include/linux/netfilter/nfnetlink.h                                               |    4 +-
 include/linux/netpoll.h                                                           |   28 +-
 include/linux/pci_ids.h                                                           |    1 +
 include/linux/phy.h                                                               |    6 +-
 include/linux/platform_data/cpsw.h                                                |    4 +
 include/linux/platform_data/microread.h                                           |   35 +
 include/linux/proc_fs.h                                                           |   15 +-
 include/linux/random.h                                                            |    6 +
 include/linux/skbuff.h                                                            |   61 +
 include/linux/socket.h                                                            |    4 +-
 include/linux/ssb/ssb_driver_gige.h                                               |   23 +-
 include/linux/ssb/ssb_driver_mips.h                                               |    5 +
 include/linux/tcp.h                                                               |    4 +-
 include/linux/wanrouter.h                                                         |  127 +-
 include/linux/wl12xx.h                                                            |   16 +-
 include/net/act_api.h                                                             |   27 +-
 include/net/addrconf.h                                                            |   63 +-
 include/net/bluetooth/a2mp.h                                                      |    4 +-
 include/net/bluetooth/bluetooth.h                                                 |   23 +
 include/net/bluetooth/hci.h                                                       |   18 +
 include/net/bluetooth/hci_core.h                                                  |    5 +
 include/net/bluetooth/l2cap.h                                                     |    1 -
 include/net/cfg80211.h                                                            |  480 +++++--
 include/net/dn_route.h                                                            |    2 +-
 include/net/dsfield.h                                                             |    6 +-
 include/net/dst.h                                                                 |    9 +-
 include/net/gro_cells.h                                                           |    4 +-
 include/net/inet6_hashtables.h                                                    |    5 +-
 include/net/inet_frag.h                                                           |   84 +-
 include/net/inet_hashtables.h                                                     |   13 +-
 include/net/ip6_checksum.h                                                        |   62 +-
 include/net/ip6_fib.h                                                             |   41 +-
 include/net/ip6_route.h                                                           |    9 +-
 include/net/ipv6.h                                                                |  140 +-
 include/net/mac80211.h                                                            |  313 ++--
 include/net/mrp.h                                                                 |  143 ++
 include/net/ndisc.h                                                               |   32 +-
 include/net/neighbour.h                                                           |    3 +-
 include/net/netevent.h                                                            |    3 +-
 include/net/netfilter/nf_conntrack_acct.h                                         |    6 +-
 include/net/netfilter/nf_conntrack_core.h                                         |   15 +-
 include/net/netfilter/nf_conntrack_ecache.h                                       |   19 +-
 include/net/netfilter/nf_conntrack_expect.h                                       |    7 +-
 include/net/netfilter/nf_conntrack_extend.h                                       |    4 +
 include/net/netfilter/nf_conntrack_helper.h                                       |   11 +-
 include/net/netfilter/nf_conntrack_l3proto.h                                      |   11 +-
 include/net/netfilter/nf_conntrack_l4proto.h                                      |   10 +-
 include/net/netfilter/nf_conntrack_labels.h                                       |   58 +
 include/net/netfilter/nf_conntrack_timeout.h                                      |    8 +-
 include/net/netfilter/nf_conntrack_timestamp.h                                    |   21 +-
 include/net/netfilter/nf_tproxy_core.h                                            |    2 +
 include/net/netns/conntrack.h                                                     |    4 +
 include/net/netns/ipv4.h                                                          |    3 +
 include/net/netns/ipv6.h                                                          |    1 +
 include/net/nfc/hci.h                                                             |   22 +-
 include/net/nfc/nci_core.h                                                        |    1 +
 include/net/nfc/nfc.h                                                             |    8 +
 include/net/pkt_cls.h                                                             |    7 +-
 include/net/pkt_sched.h                                                           |   10 +-
 include/net/regulatory.h                                                          |    4 +
 include/net/sch_generic.h                                                         |   21 +-
 include/net/sctp/constants.h                                                      |    2 +-
 include/net/sctp/structs.h                                                        |    5 +-
 include/net/sock.h                                                                |   10 +-
 include/net/tcp.h                                                                 |   10 +-
 include/net/xfrm.h                                                                |   40 +-
 include/uapi/asm-generic/socket.h                                                 |    5 +-
 include/uapi/linux/can/gw.h                                                       |    2 +
 include/uapi/linux/if_bridge.h                                                    |   11 +
 include/uapi/linux/if_ether.h                                                     |    1 +
 include/uapi/linux/if_link.h                                                      |    1 +
 include/uapi/linux/if_vlan.h                                                      |    1 +
 include/uapi/linux/in6.h                                                          |   20 +-
 include/uapi/linux/ipv6.h                                                         |    2 +
 include/uapi/linux/mroute.h                                                       |    3 +
 include/uapi/linux/mroute6.h                                                      |    3 +
 include/uapi/linux/neighbour.h                                                    |    1 +
 include/uapi/linux/netfilter/Kbuild                                               |    2 +
 include/uapi/linux/netfilter/nf_conntrack_common.h                                |    1 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h                                |    2 +
 include/uapi/linux/netfilter/xt_CT.h                                              |    6 +-
 include/uapi/linux/netfilter/xt_bpf.h                                             |   17 +
 include/uapi/linux/netfilter/xt_connlabel.h                                       |   12 +
 include/uapi/linux/netfilter/xt_conntrack.h                                       |    1 +
 include/uapi/linux/nfc.h                                                          |   37 +-
 include/uapi/linux/nl80211.h                                                      |  395 ++++-
 include/uapi/linux/rtnetlink.h                                                    |    1 +
 include/uapi/linux/snmp.h                                                         |    1 +
 include/uapi/linux/tcp.h                                                          |    1 +
 include/uapi/linux/virtio_net.h                                                   |    8 +-
 include/uapi/linux/vm_sockets.h                                                   |  163 +++
 include/uapi/linux/wanrouter.h                                                    |  443 +-----
 kernel/softirq.c                                                                  |   17 +-
 kernel/sysctl_binary.c                                                            |    1 -
 net/802/Kconfig                                                                   |    3 +
 net/802/Makefile                                                                  |    1 +
 net/802/mrp.c                                                                     |  895 ++++++++++++
 net/8021q/Kconfig                                                                 |   11 +
 net/8021q/Makefile                                                                |    1 +
 net/8021q/vlan.c                                                                  |   42 +-
 net/8021q/vlan.h                                                                  |   16 +
 net/8021q/vlan_core.c                                                             |   25 +-
 net/8021q/vlan_dev.c                                                              |   20 +-
 net/8021q/vlan_mvrp.c                                                             |   72 +
 net/8021q/vlan_netlink.c                                                          |    2 +-
 net/8021q/vlanproc.c                                                              |    2 +-
 net/Kconfig                                                                       |    4 +-
 net/Makefile                                                                      |    2 +-
 net/atm/proc.c                                                                    |    2 +-
 net/ax25/af_ax25.c                                                                |   13 +-
 net/batman-adv/bat_algo.h                                                         |    2 +-
 net/batman-adv/bat_iv_ogm.c                                                       |   14 +-
 net/batman-adv/bitarray.c                                                         |    2 +-
 net/batman-adv/bitarray.h                                                         |    2 +-
 net/batman-adv/bridge_loop_avoidance.c                                            |  135 +-
 net/batman-adv/bridge_loop_avoidance.h                                            |    2 +-
 net/batman-adv/debugfs.c                                                          |   23 +-
 net/batman-adv/debugfs.h                                                          |    2 +-
 net/batman-adv/distributed-arp-table.c                                            |    2 +-
 net/batman-adv/distributed-arp-table.h                                            |    2 +-
 net/batman-adv/gateway_client.c                                                   |    2 +-
 net/batman-adv/gateway_client.h                                                   |    2 +-
 net/batman-adv/gateway_common.c                                                   |    2 +-
 net/batman-adv/gateway_common.h                                                   |    2 +-
 net/batman-adv/hard-interface.c                                                   |   26 +-
 net/batman-adv/hard-interface.h                                                   |    2 +-
 net/batman-adv/hash.c                                                             |    2 +-
 net/batman-adv/hash.h                                                             |    4 +-
 net/batman-adv/icmp_socket.c                                                      |    2 +-
 net/batman-adv/icmp_socket.h                                                      |    2 +-
 net/batman-adv/main.c                                                             |    2 +-
 net/batman-adv/main.h                                                             |   12 +-
 net/batman-adv/originator.c                                                       |   28 +-
 net/batman-adv/originator.h                                                       |    2 +-
 net/batman-adv/packet.h                                                           |    2 +-
 net/batman-adv/ring_buffer.c                                                      |    2 +-
 net/batman-adv/ring_buffer.h                                                      |    2 +-
 net/batman-adv/routing.c                                                          |    6 +-
 net/batman-adv/routing.h                                                          |    2 +-
 net/batman-adv/send.c                                                             |    9 +-
 net/batman-adv/send.h                                                             |    2 +-
 net/batman-adv/soft-interface.c                                                   |   50 +-
 net/batman-adv/soft-interface.h                                                   |    2 +-
 net/batman-adv/sysfs.c                                                            |    2 +-
 net/batman-adv/sysfs.h                                                            |    2 +-
 net/batman-adv/translation-table.c                                                |   89 +-
 net/batman-adv/translation-table.h                                                |    2 +-
 net/batman-adv/types.h                                                            |  571 ++++++--
 net/batman-adv/unicast.c                                                          |    4 +-
 net/batman-adv/unicast.h                                                          |    2 +-
 net/batman-adv/vis.c                                                              |   40 +-
 net/batman-adv/vis.h                                                              |    2 +-
 net/bluetooth/a2mp.c                                                              |   42 +-
 net/bluetooth/af_bluetooth.c                                                      |    4 +-
 net/bluetooth/amp.c                                                               |   25 +-
 net/bluetooth/bnep/core.c                                                         |    1 -
 net/bluetooth/hci_core.c                                                          |   30 +-
 net/bluetooth/hci_event.c                                                         |   64 +-
 net/bluetooth/hci_sysfs.c                                                         |   22 +-
 net/bluetooth/l2cap_core.c                                                        |    5 -
 net/bluetooth/mgmt.c                                                              |  489 ++++---
 net/bluetooth/rfcomm/core.c                                                       |    4 +-
 net/bluetooth/sco.c                                                               |   18 +-
 net/bridge/Kconfig                                                                |   14 +
 net/bridge/Makefile                                                               |    2 +
 net/bridge/br_device.c                                                            |   19 +-
 net/bridge/br_fdb.c                                                               |  258 +++-
 net/bridge/br_forward.c                                                           |    9 +
 net/bridge/br_if.c                                                                |   16 +-
 net/bridge/br_input.c                                                             |   28 +-
 net/bridge/br_mdb.c                                                               |    3 -
 net/bridge/br_multicast.c                                                         |   69 +-
 net/bridge/br_netlink.c                                                           |  247 +++-
 net/bridge/br_notify.c                                                            |    2 +-
 net/bridge/br_private.h                                                           |  178 ++-
 net/bridge/br_stp_if.c                                                            |    4 +-
 net/bridge/br_sysfs_br.c                                                          |   21 +
 net/bridge/br_vlan.c                                                              |  415 ++++++
 net/bridge/netfilter/ebt_ulog.c                                                   |    6 +-
 net/bridge/netfilter/ebtables.c                                                   |   24 +-
 net/can/Kconfig                                                                   |   13 +-
 net/can/bcm.c                                                                     |   14 +-
 net/can/gw.c                                                                      |   72 +-
 net/can/proc.c                                                                    |    2 +-
 net/can/raw.c                                                                     |    8 +-
 net/core/Makefile                                                                 |    3 +-
 net/core/dev.c                                                                    | 1724 ++++++++--------------
 net/core/dev_addr_lists.c                                                         |   74 -
 net/core/dev_ioctl.c                                                              |  576 ++++++++
 net/core/dst.c                                                                    |    1 +
 net/core/ethtool.c                                                                |   46 +-
 net/core/filter.c                                                                 |   13 +
 net/core/flow.c                                                                   |    2 +-
 net/core/flow_dissector.c                                                         |  173 +++
 net/core/neighbour.c                                                              |   20 +-
 net/core/net-procfs.c                                                             |  412 ++++++
 net/core/net-sysfs.c                                                              |  175 +--
 net/core/netpoll.c                                                                |  721 +++++++---
 net/core/netprio_cgroup.c                                                         |    4 +-
 net/core/pktgen.c                                                                 |  196 ++-
 net/core/rtnetlink.c                                                              |  214 ++-
 net/core/skbuff.c                                                                 |  111 +-
 net/core/sock.c                                                                   |   24 +-
 net/core/sysctl_net_core.c                                                        |   14 +-
 net/dccp/probe.c                                                                  |    6 +-
 net/decnet/af_decnet.c                                                            |   10 +-
 net/decnet/dn_dev.c                                                               |    4 +-
 net/decnet/dn_neigh.c                                                             |    7 +-
 net/decnet/dn_nsp_out.c                                                           |    2 +-
 net/decnet/dn_route.c                                                             |    7 +-
 net/dsa/dsa.c                                                                     |    6 +
 net/dsa/slave.c                                                                   |   14 +-
 net/ethernet/eth.c                                                                |   43 +-
 net/ieee802154/6lowpan.c                                                          |   94 +-
 net/ipv4/af_inet.c                                                                |   25 +-
 net/ipv4/ah4.c                                                                    |    3 +-
 net/ipv4/arp.c                                                                    |    4 +-
 net/ipv4/devinet.c                                                                |  215 ++-
 net/ipv4/fib_frontend.c                                                           |    2 +-
 net/ipv4/fib_trie.c                                                               |   18 +-
 net/ipv4/gre.c                                                                    |  118 ++
 net/ipv4/igmp.c                                                                   |   11 +-
 net/ipv4/inet_connection_sock.c                                                   |   45 +-
 net/ipv4/inet_fragment.c                                                          |   39 +-
 net/ipv4/inet_hashtables.c                                                        |   28 +-
 net/ipv4/ip_fragment.c                                                            |   52 +-
 net/ipv4/ip_gre.c                                                                 |   91 +-
 net/ipv4/ip_input.c                                                               |    7 -
 net/ipv4/ip_output.c                                                              |    1 +
 net/ipv4/ipcomp.c                                                                 |    1 +
 net/ipv4/ipconfig.c                                                               |    2 +-
 net/ipv4/ipip.c                                                                   |    4 +-
 net/ipv4/ipmr.c                                                                   |  130 +-
 net/ipv4/netfilter/arp_tables.c                                                   |   10 +-
 net/ipv4/netfilter/ip_tables.c                                                    |   10 +-
 net/ipv4/netfilter/ipt_ULOG.c                                                     |   12 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                                    |   92 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c                             |   14 +-
 net/ipv4/ping.c                                                                   |    4 +-
 net/ipv4/proc.c                                                                   |   17 +-
 net/ipv4/protocol.c                                                               |    6 +
 net/ipv4/raw.c                                                                    |    4 +-
 net/ipv4/route.c                                                                  |   13 +-
 net/ipv4/syncookies.c                                                             |    7 +-
 net/ipv4/sysctl_net_ipv4.c                                                        |   38 +-
 net/ipv4/tcp.c                                                                    |   16 +-
 net/ipv4/tcp_cong.c                                                               |   30 +-
 net/ipv4/tcp_input.c                                                              |   25 +-
 net/ipv4/tcp_ipv4.c                                                               |   21 +-
 net/ipv4/tcp_minisocks.c                                                          |    4 +-
 net/ipv4/tcp_output.c                                                             |    8 +-
 net/ipv4/tcp_probe.c                                                              |    6 +-
 net/ipv4/udp.c                                                                    |   68 +-
 net/ipv4/xfrm4_input.c                                                            |    2 +-
 net/ipv4/xfrm4_mode_tunnel.c                                                      |    4 +-
 net/ipv4/xfrm4_policy.c                                                           |   58 +-
 net/ipv6/Makefile                                                                 |    2 +-
 net/ipv6/addrconf.c                                                               |   27 +-
 net/ipv6/af_inet6.c                                                               |    3 +-
 net/ipv6/ah6.c                                                                    |    3 +-
 net/ipv6/anycast.c                                                                |   20 +-
 net/ipv6/datagram.c                                                               |   19 +-
 net/ipv6/exthdrs.c                                                                |    3 +-
 net/ipv6/inet6_connection_sock.c                                                  |   19 +-
 net/ipv6/inet6_hashtables.c                                                       |   19 +-
 net/ipv6/ip6_checksum.c                                                           |   97 ++
 net/ipv6/ip6_flowlabel.c                                                          |  167 ++-
 net/ipv6/ip6_gre.c                                                                |    6 +-
 net/ipv6/ip6_input.c                                                              |   35 +-
 net/ipv6/ip6_offload.c                                                            |    1 +
 net/ipv6/ip6_output.c                                                             |   77 +-
 net/ipv6/ip6_tunnel.c                                                             |    4 +-
 net/ipv6/ip6mr.c                                                                  |  136 +-
 net/ipv6/mcast.c                                                                  |   91 +-
 net/ipv6/ndisc.c                                                                  |  362 ++---
 net/ipv6/netfilter/ip6_tables.c                                                   |   10 +-
 net/ipv6/netfilter/ip6t_REJECT.c                                                  |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c                                              |    5 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c                                    |   94 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c                                           |   19 +-
 net/ipv6/proc.c                                                                   |   16 +-
 net/ipv6/raw.c                                                                    |    4 +-
 net/ipv6/reassembly.c                                                             |   28 +-
 net/ipv6/route.c                                                                  |  201 +--
 net/ipv6/sit.c                                                                    |   61 +-
 net/ipv6/syncookies.c                                                             |    2 +-
 net/ipv6/tcp_ipv6.c                                                               |   34 +-
 net/ipv6/udp.c                                                                    |   64 +-
 net/ipv6/udp_offload.c                                                            |    3 +-
 net/ipv6/xfrm6_mode_tunnel.c                                                      |    4 +-
 net/ipv6/xfrm6_policy.c                                                           |   53 +-
 net/ipv6/xfrm6_tunnel.c                                                           |    6 +-
 net/irda/af_irda.c                                                                |    3 +-
 net/irda/irnet/irnet_ppp.c                                                        |  117 +-
 net/key/af_key.c                                                                  |   52 +-
 net/l2tp/l2tp_core.c                                                              |  179 ++-
 net/l2tp/l2tp_core.h                                                              |    2 +
 net/l2tp/l2tp_ip.c                                                                |   16 +-
 net/l2tp/l2tp_netlink.c                                                           |    1 +
 net/l2tp/l2tp_ppp.c                                                               |    5 +-
 net/mac80211/Kconfig                                                              |   11 +
 net/mac80211/Makefile                                                             |    3 +-
 net/mac80211/agg-rx.c                                                             |   14 +-
 net/mac80211/agg-tx.c                                                             |  300 ++--
 net/mac80211/cfg.c                                                                |  270 +++-
 net/mac80211/chan.c                                                               |  158 +-
 net/mac80211/debug.h                                                              |   10 +
 net/mac80211/debugfs.c                                                            |    6 +-
 net/mac80211/debugfs_netdev.c                                                     |    5 +
 net/mac80211/debugfs_sta.c                                                        |    5 +-
 net/mac80211/driver-ops.h                                                         |   99 +-
 net/mac80211/ht.c                                                                 |  115 +-
 net/mac80211/ibss.c                                                               |  110 +-
 net/mac80211/ieee80211_i.h                                                        |  222 +--
 net/mac80211/iface.c                                                              |  181 +--
 net/mac80211/key.c                                                                |    5 +-
 net/mac80211/main.c                                                               |  173 +--
 net/mac80211/mesh.c                                                               |  405 +++++-
 net/mac80211/mesh.h                                                               |  143 +-
 net/mac80211/mesh_hwmp.c                                                          |  120 +-
 net/mac80211/mesh_pathtbl.c                                                       |   95 +-
 net/mac80211/mesh_plink.c                                                         |  410 ++++--
 net/mac80211/mesh_ps.c                                                            |  598 ++++++++
 net/mac80211/mesh_sync.c                                                          |   47 +-
 net/mac80211/mlme.c                                                               | 1189 +++++++++------
 net/mac80211/offchannel.c                                                         |   50 +-
 net/mac80211/pm.c                                                                 |   76 +-
 net/mac80211/rate.h                                                               |    2 +
 net/mac80211/rc80211_minstrel.c                                                   |   29 +
 net/mac80211/rc80211_minstrel.h                                                   |    2 +
 net/mac80211/rc80211_minstrel_ht.c                                                |  181 ++-
 net/mac80211/rc80211_minstrel_ht.h                                                |    5 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c                                        |  112 +-
 net/mac80211/rx.c                                                                 |  178 ++-
 net/mac80211/scan.c                                                               |   75 +-
 net/mac80211/sta_info.c                                                           |   91 +-
 net/mac80211/sta_info.h                                                           |   64 +-
 net/mac80211/status.c                                                             |   25 +-
 net/mac80211/tkip.c                                                               |   10 +-
 net/mac80211/trace.h                                                              |  104 +-
 net/mac80211/tx.c                                                                 |  180 ++-
 net/mac80211/util.c                                                               |  107 +-
 net/mac80211/vht.c                                                                |  172 ++-
 net/mac80211/wme.c                                                                |   13 +-
 net/mac80211/wpa.c                                                                |    5 +-
 net/mac802154/wpan.c                                                              |    9 +-
 net/netfilter/Kconfig                                                             |   28 +
 net/netfilter/Makefile                                                            |    3 +
 net/netfilter/ipset/ip_set_core.c                                                 |   26 +-
 net/netfilter/ipset/ip_set_hash_ip.c                                              |    2 +-
 net/netfilter/ipset/ip_set_hash_ipport.c                                          |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c                                        |    4 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c                                       |    4 +-
 net/netfilter/ipset/ip_set_hash_net.c                                             |    2 +-
 net/netfilter/ipset/ip_set_hash_netiface.c                                        |    2 +-
 net/netfilter/ipset/ip_set_hash_netport.c                                         |    2 +-
 net/netfilter/ipvs/ip_vs_app.c                                                    |    4 +-
 net/netfilter/ipvs/ip_vs_conn.c                                                   |   11 +-
 net/netfilter/ipvs/ip_vs_ctl.c                                                    |   14 +-
 net/netfilter/nf_conntrack_acct.c                                                 |   36 +-
 net/netfilter/nf_conntrack_amanda.c                                               |    5 +-
 net/netfilter/nf_conntrack_core.c                                                 |  191 +--
 net/netfilter/nf_conntrack_ecache.c                                               |   37 +-
 net/netfilter/nf_conntrack_expect.c                                               |   58 +-
 net/netfilter/nf_conntrack_ftp.c                                                  |   10 +-
 net/netfilter/nf_conntrack_h323_main.c                                            |    6 +-
 net/netfilter/nf_conntrack_helper.c                                               |   76 +-
 net/netfilter/nf_conntrack_irc.c                                                  |    7 +-
 net/netfilter/nf_conntrack_labels.c                                               |  112 ++
 net/netfilter/nf_conntrack_netlink.c                                              |  103 +-
 net/netfilter/nf_conntrack_pptp.c                                                 |    2 +-
 net/netfilter/nf_conntrack_proto.c                                                |   92 +-
 net/netfilter/nf_conntrack_proto_dccp.c                                           |   43 +-
 net/netfilter/nf_conntrack_proto_gre.c                                            |   23 +-
 net/netfilter/nf_conntrack_proto_sctp.c                                           |   43 +-
 net/netfilter/nf_conntrack_proto_udplite.c                                        |   40 +-
 net/netfilter/nf_conntrack_sane.c                                                 |    5 +-
 net/netfilter/nf_conntrack_sip.c                                                  |   90 +-
 net/netfilter/nf_conntrack_snmp.c                                                 |    1 +
 net/netfilter/nf_conntrack_standalone.c                                           |   69 +-
 net/netfilter/nf_conntrack_tftp.c                                                 |    8 +-
 net/netfilter/nf_conntrack_timeout.c                                              |   23 +-
 net/netfilter/nf_conntrack_timestamp.c                                            |   39 +-
 net/netfilter/nf_nat_amanda.c                                                     |    8 +-
 net/netfilter/nf_nat_ftp.c                                                        |    5 +-
 net/netfilter/nf_nat_irc.c                                                        |    8 +-
 net/netfilter/nf_nat_sip.c                                                        |   72 +-
 net/netfilter/nf_nat_tftp.c                                                       |    4 +-
 net/netfilter/nfnetlink.c                                                         |   52 +-
 net/netfilter/x_tables.c                                                          |   10 +-
 net/netfilter/xt_CT.c                                                             |  177 ++-
 net/netfilter/xt_bpf.c                                                            |   73 +
 net/netfilter/xt_connlabel.c                                                      |   99 ++
 net/netfilter/xt_hashlimit.c                                                      |    6 +-
 net/netfilter/xt_recent.c                                                         |    2 +-
 net/netlink/af_netlink.c                                                          |    7 +-
 net/netrom/af_netrom.c                                                            |   12 +-
 net/nfc/core.c                                                                    |   50 +-
 net/nfc/hci/command.c                                                             |    7 +-
 net/nfc/hci/core.c                                                                |   57 +-
 net/nfc/hci/hcp.c                                                                 |    7 +
 net/nfc/llcp/commands.c                                                           |    2 +
 net/nfc/llcp/llcp.c                                                               |   49 +-
 net/nfc/llcp/llcp.h                                                               |    1 -
 net/nfc/llcp/sock.c                                                               |   22 +-
 net/nfc/nci/core.c                                                                |    2 +
 net/nfc/netlink.c                                                                 |    1 +
 net/openvswitch/datapath.c                                                        |    5 +-
 net/openvswitch/vport-internal_dev.c                                              |    3 +-
 net/packet/af_packet.c                                                            |    4 +-
 net/phonet/pn_dev.c                                                               |    8 +-
 net/rose/af_rose.c                                                                |   19 +-
 net/rxrpc/af_rxrpc.c                                                              |   13 +-
 net/sched/act_api.c                                                               |   18 +-
 net/sched/act_csum.c                                                              |    2 +-
 net/sched/act_gact.c                                                              |    5 +-
 net/sched/act_ipt.c                                                               |    8 +-
 net/sched/act_mirred.c                                                            |    7 +-
 net/sched/act_nat.c                                                               |    2 +-
 net/sched/act_pedit.c                                                             |    8 +-
 net/sched/act_police.c                                                            |  105 +-
 net/sched/act_simple.c                                                            |    5 +-
 net/sched/act_skbedit.c                                                           |    5 +-
 net/sched/cls_api.c                                                               |   11 +-
 net/sched/cls_basic.c                                                             |   13 +-
 net/sched/cls_cgroup.c                                                            |    5 +-
 net/sched/cls_flow.c                                                              |    4 +-
 net/sched/cls_fw.c                                                                |   10 +-
 net/sched/cls_route.c                                                             |   15 +-
 net/sched/cls_rsvp.h                                                              |    4 +-
 net/sched/cls_tcindex.c                                                           |   14 +-
 net/sched/cls_u32.c                                                               |   13 +-
 net/sched/sch_api.c                                                               |   10 +-
 net/sched/sch_generic.c                                                           |   37 +
 net/sched/sch_htb.c                                                               |   76 +-
 net/sched/sch_tbf.c                                                               |   76 +-
 net/sctp/associola.c                                                              |    5 +-
 net/sctp/auth.c                                                                   |   29 +-
 net/sctp/endpointola.c                                                            |    9 +-
 net/sctp/input.c                                                                  |    3 +-
 net/sctp/outqueue.c                                                               |    4 +-
 net/sctp/probe.c                                                                  |   27 +-
 net/sctp/protocol.c                                                               |    2 +-
 net/sctp/sm_make_chunk.c                                                          |   31 +-
 net/sctp/sm_sideeffect.c                                                          |    6 +-
 net/sctp/transport.c                                                              |   20 +-
 net/socket.c                                                                      |   19 +-
 net/tipc/bcast.c                                                                  |    1 +
 net/tipc/socket.c                                                                 |  103 +-
 net/unix/af_unix.c                                                                |    7 +-
 net/vmw_vsock/Kconfig                                                             |   28 +
 net/vmw_vsock/Makefile                                                            |    7 +
 net/vmw_vsock/af_vsock.c                                                          | 2012 ++++++++++++++++++++++++++
 net/vmw_vsock/af_vsock.h                                                          |  175 +++
 net/vmw_vsock/vmci_transport.c                                                    | 2155 +++++++++++++++++++++++++++
 net/vmw_vsock/vmci_transport.h                                                    |  139 ++
 net/vmw_vsock/vmci_transport_notify.c                                             |  680 +++++++++
 net/vmw_vsock/vmci_transport_notify.h                                             |   83 ++
 net/vmw_vsock/vmci_transport_notify_qstate.c                                      |  438 ++++++
 net/vmw_vsock/vsock_addr.c                                                        |   86 ++
 net/vmw_vsock/vsock_addr.h                                                        |   32 +
 net/wanrouter/Kconfig                                                             |   27 -
 net/wanrouter/Makefile                                                            |    7 -
 net/wanrouter/patchlevel                                                          |    1 -
 net/wanrouter/wanmain.c                                                           |  782 ----------
 net/wanrouter/wanproc.c                                                           |  380 -----
 net/wireless/ap.c                                                                 |   62 +
 net/wireless/chan.c                                                               |  146 +-
 net/wireless/core.c                                                               |   39 +-
 net/wireless/core.h                                                               |   60 +-
 net/wireless/ethtool.c                                                            |    4 +-
 net/wireless/ibss.c                                                               |    4 +-
 net/wireless/mesh.c                                                               |    8 +
 net/wireless/mlme.c                                                               |  162 ++-
 net/wireless/nl80211.c                                                            | 1148 +++++++++++++--
 net/wireless/nl80211.h                                                            |    7 +
 net/wireless/rdev-ops.h                                                           |   12 +
 net/wireless/reg.c                                                                | 1142 +++++++--------
 net/wireless/reg.h                                                                |    7 +-
 net/wireless/scan.c                                                               |  630 ++++----
 net/wireless/sme.c                                                                |   25 +-
 net/wireless/sysfs.c                                                              |    2 -
 net/wireless/trace.h                                                              |   98 ++
 net/wireless/util.c                                                               |   42 +-
 net/wireless/wext-proc.c                                                          |    5 +-
 net/xfrm/xfrm_algo.c                                                              |   68 +-
 net/xfrm/xfrm_output.c                                                            |    6 +
 net/xfrm/xfrm_policy.c                                                            |  271 +++-
 net/xfrm/xfrm_proc.c                                                              |    7 +-
 net/xfrm/xfrm_state.c                                                             |  165 +--
 net/xfrm/xfrm_user.c                                                              |    2 +-
 1403 files changed, 99823 insertions(+), 60775 deletions(-)
 delete mode 100644 Documentation/networking/DLINK.txt
 delete mode 100644 Documentation/networking/depca.txt
 delete mode 100644 Documentation/networking/ewrk3.txt
 delete mode 100644 Documentation/networking/multicast.txt
 create mode 100644 Documentation/networking/nf_conntrack-sysctl.txt
 create mode 100644 drivers/net/can/led.c
 create mode 100644 drivers/net/can/usb/usb_8dev.c
 delete mode 100644 drivers/net/ethernet/3com/3c501.c
 delete mode 100644 drivers/net/ethernet/3com/3c501.h
 delete mode 100644 drivers/net/ethernet/8390/3c503.c
 delete mode 100644 drivers/net/ethernet/8390/3c503.h
 delete mode 100644 drivers/net/ethernet/8390/ac3200.c
 delete mode 100644 drivers/net/ethernet/8390/e2100.c
 delete mode 100644 drivers/net/ethernet/8390/es3210.c
 delete mode 100644 drivers/net/ethernet/8390/hp-plus.c
 delete mode 100644 drivers/net/ethernet/8390/hp.c
 delete mode 100644 drivers/net/ethernet/8390/lne390.c
 delete mode 100644 drivers/net/ethernet/8390/ne3210.c
 delete mode 100644 drivers/net/ethernet/8390/smc-ultra32.c
 delete mode 100644 drivers/net/ethernet/amd/depca.c
 delete mode 100644 drivers/net/ethernet/amd/depca.h
 create mode 100644 drivers/net/ethernet/broadcom/bgmac.c
 create mode 100644 drivers/net/ethernet/broadcom/bgmac.h
 create mode 100644 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
 create mode 100644 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
 create mode 100644 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
 create mode 100644 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h
 delete mode 100644 drivers/net/ethernet/dec/ewrk3.c
 delete mode 100644 drivers/net/ethernet/dec/ewrk3.h
 delete mode 100644 drivers/net/ethernet/dlink/de600.c
 delete mode 100644 drivers/net/ethernet/dlink/de600.h
 delete mode 100644 drivers/net/ethernet/dlink/de620.c
 delete mode 100644 drivers/net/ethernet/dlink/de620.h
 delete mode 100644 drivers/net/ethernet/fujitsu/at1700.c
 delete mode 100644 drivers/net/ethernet/fujitsu/eth16i.c
 delete mode 100644 drivers/net/ethernet/i825xx/3c505.c
 delete mode 100644 drivers/net/ethernet/i825xx/3c505.h
 delete mode 100644 drivers/net/ethernet/i825xx/3c507.c
 delete mode 100644 drivers/net/ethernet/i825xx/eepro.c
 delete mode 100644 drivers/net/ethernet/i825xx/eexpress.c
 delete mode 100644 drivers/net/ethernet/i825xx/eexpress.h
 delete mode 100644 drivers/net/ethernet/i825xx/lp486e.c
 delete mode 100644 drivers/net/ethernet/i825xx/ni52.c
 delete mode 100644 drivers/net/ethernet/i825xx/ni52.h
 delete mode 100644 drivers/net/ethernet/i825xx/znet.c
 create mode 100644 drivers/net/ethernet/intel/e1000e/80003es2lan.h
 create mode 100644 drivers/net/ethernet/intel/e1000e/82571.h
 create mode 100644 drivers/net/ethernet/intel/e1000e/ich8lan.h
 create mode 100644 drivers/net/ethernet/intel/e1000e/mac.h
 create mode 100644 drivers/net/ethernet/intel/e1000e/manage.h
 create mode 100644 drivers/net/ethernet/intel/e1000e/nvm.h
 create mode 100644 drivers/net/ethernet/intel/e1000e/phy.h
 create mode 100644 drivers/net/ethernet/intel/e1000e/ptp.c
 create mode 100644 drivers/net/ethernet/intel/e1000e/regs.h
 create mode 100644 drivers/net/ethernet/intel/igb/igb_hwmon.c
 delete mode 100644 drivers/net/ethernet/natsemi/ibmlana.c
 delete mode 100644 drivers/net/ethernet/natsemi/ibmlana.h
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h
 delete mode 100644 drivers/net/ethernet/racal/Kconfig
 delete mode 100644 drivers/net/ethernet/racal/Makefile
 delete mode 100644 drivers/net/ethernet/racal/ni5010.c
 delete mode 100644 drivers/net/ethernet/racal/ni5010.h
 delete mode 100644 drivers/net/ethernet/seeq/seeq8005.c
 delete mode 100644 drivers/net/ethernet/seeq/seeq8005.h
 delete mode 100644 drivers/net/wan/cycx_drv.c
 delete mode 100644 drivers/net/wan/cycx_main.c
 delete mode 100644 drivers/net/wan/cycx_x25.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/p2p.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/p2p.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/Makefile
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/binding.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/d3.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/debugfs.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/led.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/mac80211.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/mvm.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/nvm.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/ops.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/power.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/quota.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/rs.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/rs.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/rx.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/scan.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/sta.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/sta.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/time-event.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/time-event.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tx.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/utils.c
 create mode 100644 drivers/net/wireless/iwlwifi/pcie/7000.c
 create mode 100644 drivers/net/wireless/mwifiex/11ac.c
 create mode 100644 drivers/net/wireless/mwifiex/11ac.h
 rename drivers/net/wireless/ti/{wlcore/wl12xx_platform_data.c => wilink_platform_data.c} (100%)
 create mode 100644 drivers/net/wireless/ti/wl12xx/event.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/event.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/scan.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/scan.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/cmd.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/cmd.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/event.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/event.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/scan.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/scan.h
 create mode 100644 drivers/nfc/microread/Kconfig
 create mode 100644 drivers/nfc/microread/Makefile
 create mode 100644 drivers/nfc/microread/i2c.c
 create mode 100644 drivers/nfc/microread/mei.c
 create mode 100644 drivers/nfc/microread/microread.c
 create mode 100644 drivers/nfc/microread/microread.h
 create mode 100644 drivers/nfc/pn544/Kconfig
 create mode 100644 drivers/ssb/driver_chipcommon_sflash.c
 create mode 100644 include/linux/can/led.h
 create mode 100644 include/linux/can/skb.h
 delete mode 100644 include/linux/cyclomx.h
 delete mode 100644 include/linux/cycx_drv.h
 create mode 100644 include/linux/platform_data/microread.h
 create mode 100644 include/net/mrp.h
 create mode 100644 include/net/netfilter/nf_conntrack_labels.h
 create mode 100644 include/uapi/linux/netfilter/xt_bpf.h
 create mode 100644 include/uapi/linux/netfilter/xt_connlabel.h
 create mode 100644 include/uapi/linux/vm_sockets.h
 create mode 100644 net/802/mrp.c
 create mode 100644 net/8021q/vlan_mvrp.c
 create mode 100644 net/bridge/br_vlan.c
 create mode 100644 net/core/dev_ioctl.c
 create mode 100644 net/core/net-procfs.c
 create mode 100644 net/ipv6/ip6_checksum.c
 create mode 100644 net/mac80211/mesh_ps.c
 create mode 100644 net/netfilter/nf_conntrack_labels.c
 create mode 100644 net/netfilter/xt_bpf.c
 create mode 100644 net/netfilter/xt_connlabel.c
 create mode 100644 net/vmw_vsock/Kconfig
 create mode 100644 net/vmw_vsock/Makefile
 create mode 100644 net/vmw_vsock/af_vsock.c
 create mode 100644 net/vmw_vsock/af_vsock.h
 create mode 100644 net/vmw_vsock/vmci_transport.c
 create mode 100644 net/vmw_vsock/vmci_transport.h
 create mode 100644 net/vmw_vsock/vmci_transport_notify.c
 create mode 100644 net/vmw_vsock/vmci_transport_notify.h
 create mode 100644 net/vmw_vsock/vmci_transport_notify_qstate.c
 create mode 100644 net/vmw_vsock/vsock_addr.c
 create mode 100644 net/vmw_vsock/vsock_addr.h
 delete mode 100644 net/wanrouter/Kconfig
 delete mode 100644 net/wanrouter/Makefile
 delete mode 100644 net/wanrouter/patchlevel
 delete mode 100644 net/wanrouter/wanmain.c
 delete mode 100644 net/wanrouter/wanproc.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
