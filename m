Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaHFFDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 01:03:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36059 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaHFFDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 01:03:04 -0400
Date: Tue, 05 Aug 2014 22:02:59 -0700 (PDT)
Message-Id: <20140805.220259.661326612882754033.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 22:03:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7653k6R009368


There are two conflicts you'll need to resolve by hand:

drivers/staging/cxt1e1/linux.c is removed your tree, changes are
made to it in net-next, just force the file removal to resolve.

drivers/net/wireless/ath/ath9k/hw.c is overlapping changes in net-next
alongside time conversion cleanups done by Thomas Gleixner in your
tree.  Retain Thomas's hunks and add "s32 usec = 0;" back to the local
variabels in ath9k_hw_reset()

Highlights:

1) Steady transitioning of the BPF instructure to a generic spot so all
   kernel subsystems can make use of it, from Alexei Starovoitov.

2) SFC driver supports busy polling, from Alexandre Rames.

3) Take advantage of hash table in UDP multicast delivery, from
   David Held.

4) Lighten locking, in particular by getting rid of the LRU lists,
   in inet frag handling.  From Florian Westphal.

5) Add support for various RFC6458 control messages in SCTP, from Geir
   Ola Vaagland.

6) Allow to filter bridge forwarding database dumps by device, from Jamal
   Hadi Salim.

7) virtio-net also now supports busy polling, from Jason Wang.

8) Some low level optimization tweaks in pktgen from Jesper Dangaard
   Brouer.

9) Add support for ipv6 address generation modes, so that userland can
   have some input into the process.  From Jiri Pirko.

10) Consolidate common TCP connection request code in ipv4 and ipv6,
    from Octavian Purdila.

11) New ARP packet logger in netfilter, from Pablo Neira Ayuso.

12) Generic resizable RCU hash table, with intial users in netlink
    and nftables.  From Thomas Graf.

13) Maintain a name assignment type so that userspace can see where a
    network device name came from (enumerated by kernel, assigned
    explicitly by userspace, etc.)  From Tom Gundersen.

14) Automatic flow label generation on transmit in ipv6, from Tom
    Herbert.

15) New packet timestamping facilities from Willem de Bruijn, meant to
    assist in measuring latencies going into/out-of the packet scheduler,
    latency from TCP data transmission to ACK, etc.

Please pull, thanks a lot!

The following changes since commit 26bcd8b72563b4c54892c4c2a409f6656fb8ae8b:

  Merge tag 'devicetree-for-linus' of git://git.secretlab.ca/git/linux (2014-07-30 09:01:04 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to d247b6ab3ce6dd43665780865ec5fa145d9ab6bd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-08-05 18:46:26 -0700)

----------------------------------------------------------------

Adam Lee (1):
      Bluetooth: ath3k: reduce pipe setting times in ath3k_load_fwfile()

Akeem G Abodunrin (1):
      i40e: Minor comment changes

Alex Gartrell (1):
      ipvs: Maintain all DSCP and ECN bits for ipv6 tun forwarding

Alex Wang (1):
      openvswitch: Allow each vport to have an array of 'port_id's.

Alexander Aring (23):
      mac802154: at86rf230: add hw flags and merge ops
      at86rf230: add regmap support
      at86rf230: rework detect device handling
      at86rf230: remove is212 and add driver data
      at86rf230: add support for at86rf23x desense
      at86rf230: rework transmit and receive handling
      at86rf230: move RX_SAFE_MODE setting to hw_init
      at86rf230: rework irq_pol setting
      at86rf230: rework state change and start/stop
      at86rf230: rework reset to trx_off state change
      at86rf230: add timing for channel switch
      at86rf230: add sleep cycle timing
      at86rf230: add new author
      6lowpan: introduce new net/6lowpan directory
      MAINTAINERS: add net/6lowpan/ maintainer entry
      MAINTAINERS: add 6lowpan header file
      6lowpan: iphc: rename hc06_ptr pointer to hc_ptr
      6lowpan: iphc: use sizeof in udp uncompression
      6lowpan: iphc: cleanup use of lowpan_fetch_skb
      6lowpan: iphc: cleanup use of lowpan_push_hc_data
      6lowpan: iphc: use ipv6 api to check address scope
      6lowpan: iphc: remove check on null
      6lowpan: remove unused LOWPAN_FRAG_SIZE define

Alexander Duyck (1):
      rtnetlink: Drop unnecessary return value from ndo_dflt_fdb_del

Alexander Guller (1):
      net/mlx4_core: Make sure the max number of QPs per MCG isn't exceeded

Alexandre Rames (1):
      sfc: Add support for busy polling

Alexei Starovoitov (8):
      net: filter: split filter.c into two files
      bpf: update MAINTAINERS entry
      net: filter: rename 'struct sock_filter_int' into 'struct bpf_insn'
      net: filter: simplify socket charging
      net: filter: rename sk_filter_proglen -> bpf_classic_proglen
      net: filter: rename sk_chk_filter() -> bpf_check_classic()
      net: filter: rename sk_convert_filter() -> bpf_convert_filter()
      net: filter: split 'struct sk_filter' into socket and bpf parts

Alexey Khoroshilov (4):
      rsi: Use module_usb_driver
      rsi_91x_sdio: add error handling into rsi_module_init()
      rsi: GFP_ATOMIC is not needed in rsi_init_usb_interface()
      rsi: fix memory leaks and error handling in rsi_91x_usb

Alexey Perevalov (2):
      netfilter: nfnetlink_acct: dump unmodified nfacct flags
      netfilter: nfnetlink_acct: avoid using NFACCT_F_OVERQUOTA with bit helper functions

Amir Vadai (3):
      net/mlx4_en: Disable blueflame using ethtool private flags
      net/mlx4_core: Use low memory profile on kdump kernel
      net/mlx4_en: Reduce memory consumption on kdump kernel

Amitkumar Karwar (8):
      mwifiex: add firmware dump feature for PCIe
      mwifiex: use generic 'iface_work' workqueue for SDIO interface
      mwifiex: get rid of global pointer reset_host
      mwifiex: add firmware dump feature for SDIO
      mwifiex: access rx_reorder_tbl_ptr only while holding lock
      mwifiex: fix corner case system hang issue
      Bluetooth: add public address configuration for Marvell USB devices
      Bluetooth: btmrvl: add public address configuration support

Anantha Krishnan (1):
      Bluetooth: Add support for Acer [13D3:3432]

Anatol Pomozov (1):
      Bluetooth: Fix crash in the Marvell driver initialization codepath

Andre Guedes (6):
      Bluetooth: Use macro instead of hard-coded value
      Bluetooth: Connection parameters check helper
      Bluetooth: Connection Parameter Update Procedure
      Bluetooth: Move LE event mask setting into init3 phase
      Bluetooth: Enable new LE meta event
      Bluetooth: Introduce "New Connection Parameter" Event

Andrea Merello (10):
      rtl818x_pci: make RSSI code more readable
      rtl818x_pci: provide dBm signal information for rtl8185
      rtl818x_pci: fix possible RX descriptor invalid data read
      rtl818x_pci: Fix BSSID register written incorrectly
      rtl818x_pci: Fix rtl8185 excessive IFS after CTS-to-self
      rtl818x_pci: add comment pointing to the rtl8187se reference code
      rtl8180: fix incorrect TX retry.
      rtl8180: disable buggy rate fallback mechanism
      rtl818x_pci: handle broken PIO mapping
      rtl818x_pci: fix pci probe returns success when it fails

Andreas Fenkart (1):
      mwifiex: card reset: enable rescan of non-removable card

Andrei Otcheretianski (5):
      iwlwifi: mvm: Introduce an API to set STA_FLG_DISABLE_TX flag
      iwlwifi: mvm: Use beacon_get_template instead of beacon_get
      iwlwifi: mvm: Protect mvm->csa_vif with RCU
      iwlwifi: mvm: Reflect GO channel switch in NoA
      iwlwifi: mvm: Use CS tx block bit for AP/GO

Andrew Bresticker (1):
      mac80211_hwsim: fix compiler warning on MIPS

Andrew Rybchenko (1):
      sfc: Add per-queue statistics in ethtool

Andrey Utkin (2):
      ath9k: drop negativity checks for unsigned values coming from kstrtoul()
      net/rxrpc/ar-key.c: drop negativity check on unsigned value

AndrÃ© Gaul (1):
      batman-adv: remove unnecessary logspam

Andy Lutomirski (3):
      iwlwifi: pcie: log when waking the NIC for hcmd submission fails
      iwlwifi: pcie: improve debugfs queue info
      iwlwifi: dvm: add a force_cam module parameter to fully disable power saving

Andy Zhou (2):
      openvswitch: Avoid memory corruption in queue_userspace_packet()
      openvswitch: Add skb_clone NULL check for the sampling action.

Anish Bhatt (16):
      cxgb4 : Update fw interface file for DCBx support. Adds all the required fields to fw interface to communicate DCBx info
      cxgb4 : Add DCBx support codebase and dcbnl_ops
      cxgb4 : Integrate DCBx support into cxgb4 module. Register dbcnl_ops to give access to DCBx functions
      cxgb4 : Makefile & Kconfig changes for DCBx support
      cxgb4 : Update copyright year on all cxgb4 files
      cxgb4: Fix endian bug introduced in cxgb4 dcb patchset
      Update setapp/getapp prototypes in dcbnl_rtnl_ops to return int instead of u8
      cxgb4/iw_cxgb4: Move common defines to cxgb4
      cxgb4: Export symbols required by cxgb4i for ipv6 support and required defines
      libcxgbi: Add ipv6 api to driver
      cxgb4i: Add ipv6 code to driver, call into libcxgbi ipv6 api
      libcxgbi:cxgb4i Guard ipv6 code with a config check
      dcbnl : Fix misleading dcb_app->priority explanation
      cxgb4i : remove spurious use of rcu
      cxgb4i : Move stray CPL definitions to cxgb4 driver
      cxgb4 : Disable recursive mailbox commands when enabling vi

Anjali Singhai Jain (9):
      i40e/i40evf: i40e_register.h update
      i40e: Fix dangling ring pointers upon driver removal
      i40e: Bypass timeout recovery level 0 so as to not cause MDD
      i40e: Avoid adding the TCP-IPv4 filter twice
      i40e: Fix the FD sideband logic to detect a FD table full condition
      i40e: Add debugfs hooks to print current total FD filter count
      i40e: FD filter replay logic bug fix
      i40e/i40evf: Do not free the dummy packet buffer synchronously
      i40e: Fix a boundary condition and turning off of ntuple

Antonio Ospite (1):
      trivial: net/mac80211/mesh.c: fix typo s/Substract/Subtract/

Antonio Quartulli (1):
      batman-adv: prefer kmalloc_array to kmalloc when possible

Arend van Spriel (11):
      brcmfmac: clear ht info during attach phase
      brcmfmac: correct logging levels in btcoex source
      brcmfmac: reduce log level in fwil if firmware returns error
      brcmfmac: make use of seq_file API for debugfs entries
      brcmfmac: rework debugfs functions in the driver
      brcmfmac: move attach and detach functions in wl_cfg80211.c
      brcmfmac: introduce feature and quirk handling
      brcmfmac: moving some functions around
      brcmfmac: rework wiphy structure setup
      brcmfmac: add brcmf_p2p_detach() call in brcmf_cfg80211_detach()
      dt: bindings: add bindings for Broadcom bcm43xx sdio devices

Ariej Marjieh (3):
      iwlwifi: mvm: Enabling Aux Queue
      iwlwifi: mvm: Define AUX ROC Command
      iwlwifi: mvm: add Aux ROC request/response flow

Arik Nemtsov (31):
      mac80211: clarify TDLS Tx handling
      mac80211: set auth flags after other station info
      mac80211: cleanup TDLS state during failed setup
      cfg80211: pass TDLS initiator in tdls_mgmt operations
      mac80211: use TDLS initiator in tdls_mgmt operations
      mac80211: split tdls_mgmt function
      mac80211: implement proper Tx path flushing for TDLS
      mac80211: add API to request TDLS operation from userspace
      mac80211: make sure TDLS peer STA exists during setup
      mac80211: protect TDLS discovery session
      iwlwifi: mvm: disallow new TDLS stations when appropriate
      iwlwifi: mvm: protect TDLS discovery session
      iwlwifi: disable PSM on vifs with associated TDLS peers
      iwlwifi: mvm: teardown TDLS peers when initiating DCM
      wlcore: don't switch channels on disconnected STA vifs
      wl18xx: change the number of WLAN addrs per chip
      mac80211: track TDLS initiator internally
      mac80211: fix error path for TDLS setup
      mac80211: consolidate TDLS IE treatment
      mac80211: split extra TDLS IEs in setup frames
      mac80211: avoid adding some IEs on TDLS setup failure packets
      mac80211: set TDLS capab to zero on failure frames
      mac80211: add QoS IE during TDLS setup start
      mac80211: add TDLS QoS param IE on setup-confirm
      mac80211: move TDLS data to mgd private part
      mac80211: support HT for TDLS stations
      mac80211: set Rx highest rate in ht_cap
      mac80211: disable VHT for TDLS
      cfg80211: fix TDLS setup with VHT peers
      mac80211: ignore frames between TDLS peers when operating as AP
      iwlwifi: mvm: teardown TDLS peers during chan-switch and AP DCM

Arvid Brodin (11):
      net/hsr: Better variable names and update of contact info.
      net/hsr: Switch from dev_add_pack() to netdev_rx_handler_register()
      net/hsr: Move to per-hsr device prune timer.
      net/hsr: Operstate handling cleanup.
      net/hsr: Move slave init to hsr_slave.c.
      net/hsr: Use list_head (and rcu) instead of array for slave devices.
      net/hsr: Implemented .ndo_fix_features (better device features handling).
      net/hsr: Added SET_NETDEV_DEVTYPE and features |= NETIF_F_NETNS_LOCAL to dev_setup.
      net/hsr: Better frame dispatch
      net/hsr: Fix NULL pointer dereference on incomplete hsr_newlink() params.
      net/hsr: Remove left-over never-true conditional code.

Ashish Shah (4):
      i40e: use correct vf_id offset for virtchnl message
      i40e: remove support for vf unicast promiscuous mode
      i40evf: future-proof vfr_stat state check
      i40evf: do not re-arm watchdog after remove

Avinash Patil (1):
      mwifiex: remove needless current_bssid variable

Banerjee, Debabrata (1):
      tcp: don't require root to read tcp_metrics

Ben Greear (2):
      ipv6: Add more debugging around accept-ra logic.
      ipv6: Allow accepting RA from local IP addresses.

Ben Hutchings (1):
      sfc: Use __iowrite64_copy instead of a slightly different local function

Bing Zhao (11):
      mwifiex: wowlan: do not disconnect on suspend
      mwifiex: print sleep_confirm cmd/response and power save events
      Revert "mwifiex: Use the proper interfaces"
      Bluetooth: btmrvl: indicate pscan scheduling instant in a debug event
      mwifiex: fix a cut-n-paste error in adhoc-start
      mwifiex: define TDLS idle timeout macro with units
      mwifiex: declare sta_ptr in smaller scope
      mwifiex: correct a typo in mwifiex_ret_tdls_oper
      mwifiex: remove redundant TDLS setup action frame check and avoid leaks
      mwifiex: remove redundant timestamps in debug prints
      MAINTAINERS: update for mwifiex driver maintainers

Bob Copeland (1):
      mac80211: remove ignore_plink_timer flag

Brian Norris (1):
      net: bcmgenet: correct spelling

Carolyn Wyborny (3):
      i40e/i40evf: Update RSS configuration
      i40e: Fix ethtool coalesce settings
      igb: Add message when malformed packets detected by hw

Catherine Sullivan (11):
      i40e/i40evf: Bump i40e to 0.4.13 and i40evf to 0.9.35
      i40e: Add ablitity to enable/disable link from set_link_restart_an
      i40e/i40evf: Bump i40e to 0.4.17 and i40evf to 0.9.36
      i40e/i40evf: Bump i40e to 0.4.19 and i40evf to 0.9.38
      i40e/i40evf: Add new HW link info variable an_enabled and function update_link_info
      i40e/i40evf: Add set_fc and init of FC settings
      i40e: Add set_pauseparam to ethtool
      i40e: Implement set_settings for ethtool
      i40e/i40evf: Bump i40e to 0.4.21 and i40evf to 0.9.40
      i40e: Fix firmware API version errors
      i40e: Give link more time after setting flow control

Chen-Yu Tsai (1):
      brcmfmac: add device tree support for SDIO devices

Chin-Ran Lo (2):
      Bluetooth: btmrvl: wait for HOST_SLEEP_ENABLE event in suspend
      Bluetooth: btmrvl: avoid sending data to firmware after hs_activated

Christoph Paasch (4):
      xfrm4: Remove duplicate semicolon
      tcp: Remove unnecessary arg from tcp_enter_cwr and tcp_init_cwnd_reduction
      tcp: Fix integer-overflows in TCP veno
      tcp: Fix integer-overflow in TCP vegas

Christoph Schulz (2):
      net: ppp: reset nextseq counter when enabling SC_MULTILINK
      net: ppp: access ppp->nextseq only if CONFIG_PPP_MULTILINK is defined

Christophe Ricard (10):
      NFC: st21nfcb: Add driver for STMicroelectronics ST21NFCB NFC chip
      NFC: dts: st21nfcb_i2c: Add DTS Documentation
      NFC: nci: Add T1T support notification
      NFC: st21nfcb: few code clean up
      NFC: st21nfca: Free buffer in case no data are retrieved.
      NFC: st21nfca: Improved start of frame detection
      NFC: st21nfca: Improve read length sequence for P2P mode.
      NFC: hci: Add stop_poll HCI operand.
      NFC: st21nfca: Implement stop_poll HCI hook
      NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode

Christopher Pau (1):
      i40e: limit GLLAN_TXPRE_QDIS to QINDX 0-127

Cong Wang (2):
      net_sched: cancel nest attribute on failure in tcf_exts_dump()
      net_sched: hold tcf_lock in netdevice notifier

Cyrille Pitchen (5):
      net/macb: add scatter-gather hw feature
      net/macb: add TX checksum offload feature
      net/macb: add RX checksum offload feature
      ARM: at91: change compatibility string for sama5d3x gem
      net/macb: enable scatter-gather feature and set DMA burst length for sama5d4 gem

Dan Carpenter (3):
      bonding: fix a memory leak in bond_arp_send_all()
      ISDN: pcbit: off by one bugs in pcbit_set_msn()
      dm9000: NULL dereferences on error in probe()

Daniel Borkmann (4):
      net: sctp: improve timer slack calculation for transport HBs
      net: sctp: only warn in proc_sctp_do_alpha_beta if write
      net: sctp: deprecate rfc6458, 5.3.2. SCTP_SNDRCV support
      team: fix releasing uninitialized pointer to BPF prog

Daniel Kim (3):
      brcmfmac: Don't control mpc setting during scan operation
      brcmfmac: Make firmware path a module parameter
      brcmfmac: Do not use strcpy and strcat

David Ertman (5):
      e1000e: Fix CRC errors with jumbo traffic
      e1000e: Add code to check return values on NVM accesses
      e1000e: Add support for EEE in Sx states
      e1000e: Fix EEE in S5 w/ Runtime PM enabled
      e1000e: Fix Runtime PM blocks EEE link negotiation in S5

David Held (2):
      udp: Simplify __udp*_lib_mcast_deliver.
      udp: Use hash2 for long hash1 chains in __udp*_lib_mcast_deliver.

David Laight (5):
      net: sctp: Inline the functions from command.c
      net: sctp: Optimise the way 'sctp_arg_t' values are initialised.
      net: sctp: Use pointers (not array indexes) to access sctp_cmd_seq_t.cmds[].
      net: sctp: Open out the check for Nagle
      net: sctp: Rename SCTP_XMIT_NAGLE_DELAY to SCTP_XMIT_DELAY

David S. Miller (106):
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'cxgb4-next'
      Merge branch 'cc2520'
      Merge branch 'enic'
      enic: Kill unused variable in enic_rfs_flw_tbl_init().
      Merge branch 'crc32'
      Merge branch 'broadcom_rebranding'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'xgbe-next'
      Merge branch 'tipc-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'tcp_conn_request_unification'
      Merge branch 'pktgen'
      Merge branch 'bnx2x-next'
      Merge branch 'dp83640-next'
      Merge branch 'cxgb4-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'qlcnic-next'
      Merge branch 'be2net'
      Merge branch 'sctp'
      Merge branch 'ptp-vlan'
      Merge branch 'tlan-next'
      Merge branch 'tipc-next'
      Merge branch 'systemport-next'
      Merge branch 'net-hash-tx'
      Merge branch 'fec-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'at86rf230-next'
      Merge branch 'amd-xgbe-next'
      Merge branch 'hsr-next'
      Merge git://git.kernel.org/.../linville/wireless-next
      Merge branch 'sctp_command_queue'
      Merge branch 'defxx-next'
      Merge branch 'bridge_batmanadv_exports'
      Merge branch 'mlx4-next'
      Merge branch 'fec-next'
      Merge branch 'fec-next'
      Merge branch 'systemport-next'
      ipconfig: Only bootp paths should reference ic_dev_xid.
      Merge branch 'cpmac-next'
      Merge branch 'bridge-fdb-dump-filter'
      Merge branch 'mvebu'
      Merge branch 'r8169_tso_ipv6'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'unnecessary_break'
      Merge branch 'udp_tunnel'
      Merge branch 'sfc-next'
      Merge branch 'amd811e-cleanups'
      Merge branch 'cxgb4-next'
      Merge branch 'net-break-after-goto'
      Merge branch 'amd-xgbe-next'
      Merge tag 'linux-can-next-for-3.17-20140715' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'bonding_rcu'
      Merge branch 'bonding-next'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'sctp-next'
      Merge branch 'tipc-next'
      Merge branch 'mlx4-next'
      Merge branch 'udp_hash'
      Merge branch 'davinci_mdio'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'cxgb4-next'
      Merge branch 'be2net-next'
      Merge branch 'netdev_print'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'break_after_return'
      Merge branch 'bcmgenet-next'
      Merge branch 'enic-next'
      Merge branch 'cxgb4-next'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'mlx4-next'
      Merge branch 'virtio-net-busy-poll'
      Merge branch 'bcmgenet-next'
      Merge branch 'filter-move'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'net_next_ovs' of git://git.kernel.org/.../pshelar/openvswitch
      Merge branch 'macb-next'
      Merge branch 'inet_frag_kill_lru_list'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge tag 'master-2014-07-25' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'syststamp-removal'
      Merge branch 'netdev-name'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'mlx5-next'
      Merge branch 'amd-xgbe-next'
      Merge branch 'libphy_mmd'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'stmmac-next'
      Merge branch 'xen-netfront'
      Merge branch 'filter-next'
      Merge branch 'inet-frags-next'
      Merge branch 'be2net-next'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'amd-xgbe-next'
      Merge branch 'intel-next'
      Merge branch 'concurrent_hash_tables'
      Merge tag 'master-2014-07-31' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'xen-netback-next'
      Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'qlcnic'
      Merge branch 'net-timestamp-next'
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'amd-xgbe'
      Merge git://git.kernel.org/.../davem/net

David Spinadel (9):
      iwlwifi: mvm: use ksize to memset scan_command
      iwlwifi: mvm: don't use hardcoded num of scan channels
      iwlwifi: fix NVM channel attribute map.
      iwlwifi: mvm: support extended beacon notification
      mac80211: support more than one band in scan request
      mac80211: split sched scan IEs
      iwlwifi: mvm: add unified LMAC scan API
      iwlwifi: mvm: init lmac scan command
      iwlwifi: mvm: fix endianity in scan command

David Vrabel (3):
      xen-netfront: fix locking in connect error path
      xen-netfront: release per-queue Tx and Rx resource when disconnecting
      xen-netfront: print correct number of queues

Dmitry Kravkov (2):
      bnx2x: VF can report link speed
      bnx2x: enlarge minimal alignemnt of data offset

Dmitry Popov (2):
      ip_tunnel(ipv4): fix tunnels with "local any remote $remote_ip"
      tcp: md5: remove unneeded check in tcp_v4_parse_md5_keys

Dotan Barak (1):
      net/mlx4_core: Make sure that negative array index isn't used

Duan Jiong (6):
      net: em_canid: remove useless statements from em_canid_change
      netfilter: use IS_ENABLED() macro
      netfilter: xt_LED: don't output error message redundantly
      net: fix the counter ICMP_MIB_INERRORS/ICMP6_MIB_INERRORS
      net: use inet6_iif instead of IP6CB()->iif
      ipv4: remove nested rcu_read_lock/unlock

Edward Cree (2):
      sfc: Add 40G link capability decoding
      sfc: add extra RX drop counters for nodesc_trunc and noskb_drop

Eliad Peller (18):
      iwlwifi: remove MCS32 support declaration
      iwlwifi: mvm: disable beacon filtering escape timer in d0i3
      iwlwifi: mvm: rs: don't clear persistent fields
      iwlwifi: mvm: rs: don't save debugfs files
      wlcore: save seq num only between recoveries
      wlcore: user smaller sqn padding for GEM
      wl18xx: fix last tx rate calculation
      wlcore: use correct LAA bit
      wlcore: add smart config definitions
      wlcore/wl18xx: add smart config commands
      wlcore: handle smart config vendor commands
      wlcore/wl18xx: handle smart config events
      wlcore: increase max roc duration to 30 seconds
      wlcore: register vendor commands
      wl18xx: make sure fw_status->priv exists before deref
      wlcore/wl18xx/wl12xx: convert bitmaps to unsigned longs
      iwlwifi: mvm: add some missing iwl_mvm_ref_sync() calls
      iwlwifi: mvm: wait for handlers when stopping scans

Emmanuel Grumbach (41):
      iwlwifi: bump API version for 8000 devices
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      iwlwifi: add device / firmware to fw-error-dump file
      iwlwifi: rename iwl_mvm_fw_error_next_data
      iwlwifi: pcie: add firmware monitor capabilities
      iwlwifi: mvm: BT Coex - allow to force the antenna allocation
      iwlwifi: mvm: BT Coex - allow MIMO in more cases
      iwlwifi: mvm: BT Coex - don't limit rate control if TTC is on
      iwlwifi: mvm: BT Coex - add reduced Tx power thresholds to constants
      iwlwifi: mvm: BT Coex - avoid the shared antenna for management frames
      iwlwivi: mvm: BT Coex - properly set the priority of beacons
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: fix naming mistake for the fw_monitor module parameter
      iwlwifi: remove wrong comment about alignment in iwl-fw-error-dump.h
      iwlwifi: mvm: don't collect logs in the interrupt thread
      iwlwifi: mvm: kill iwl_mvm_fw_error_rxf_dump
      iwlwifi: mvm: update layout of firmware error dump
      iwlwifi: rename iwl_fw_error_fw_mon to iwl_fw_error_dump_fw_mon
      iwlwifi: mvm: remove unused flags from TX command
      iwlwifi: mvm: BT Coex - prepare towards new API
      iwlwifi: mvm: BT Coex - new API
      iwlwifi: mvm: BT Coex - convert the sw boost update to new API
      iwlwifi: mvm: BT Coex - convert the co-running update to new API
      iwlwifi: mvm: BT Coex - convert reduced Tx power to new API
      iwlwifi: mvm: BT Coex - add High Band retention
      iwlwifi: mvm: BT Coex - fix debugfs with old API
      iwlwifi: mvm: BT Coex - relax constraints when TTC / RRC is active
      iwlwifi: mvm: minor fix in comment
      iwlwifi: mvm: BT Coex - fix TLC with old API
      iwlwifi: fix Kconfig issues
      iwlwifi: mvm: use C99 initializers for add_sta
      iwlwifi: mvm: BT Coex - fix the ACK / CTS kill mask
      iwlwifi: mvm: BT Coex - don't change AP SMPS mode
      iwlwifi: fix inconsistency about power_save module parameter
      iwlwifi: split fw-error-dump between transport and mvm
      iwlwifi: dump periphery registers to fw-error-dump
      iwlwifi: dump CSRs to fw-error-dump
      iwlwifi: mvm: reset beacon filtering and BT Coex data upon FW restart
      Merge branch 'iwlwifi-fixes' into iwlwifi-next
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next

Eran Harary (7):
      iwlwifi: mvm: fixes for 8000 NVM flow
      iwlwifi: mvm: fix bug in set_hw_address function
      iwlwifi: mvm: read the mac address in family 8000
      iwlwifi: mvm: warn about empty OTP
      iwlwifi: 8000: drop a print when the address is invalid
      iwlwifi: mvm: minor change in debug print
      iwlwifi: mvm: update smart fifo / beacon filtering upon association

Eric Dumazet (11):
      netfilter: x_tables: xt_free_table_info() cleanup
      inet: reduce TLB pressure for listeners
      inet: move ipv6only in sock_common
      net: filter: sk_chk_filter() no longer mangles filter
      bonding: get rid of bond_option_active_slave_get()
      bonding: use rcu_access_pointer() in bonding_show_mii_status()
      bonding: add proper __rcu annotation for curr_active_slave
      bonding: add proper __rcu annotation for current_arp_slave
      netfilter: xt_hashlimit: perform garbage collection from process context
      netlink: fix lockdep splats
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Erik Hugne (4):
      tipc: bump max configurable window size
      tipc: refactor message delivery out of tipc_rcv
      tipc: fix link acknowledge logic in receive path
      tipc: fix a memleak when sending data

Eugenia Emantayev (5):
      net/mlx4_en: Fix set port ratelimit for 40GE
      net/mlx4_en: Run loopback test only when port is up
      net/mlx4: Verify port number in __mlx4_unregister_mac
      net/mlx4_en: Do not disable vlan filter during promiscuous mode
      net/mlx4_core: In SR-IOV mode host should add promisc QP to default entry only

Eyal Perry (1):
      net/mlx4_en: current_mac isn't updated in port up

Eytan Lifshitz (2):
      iwlwifi: mvm: fix wrong offset while reading from NVM
      mac80211: remove useless NULL checks

Ezequiel Garcia (3):
      net: mvpp2: Fix a typo in the license
      net: mvpp2: Fix the BM pool buffer release check
      net: mvpp2: Simplify BM pool buffers freeing

Fabian Frederick (70):
      drivers/net/wireless/rt2x00/rt2x00dev.c: remove null test before kfree
      SPECTRUM_CS: ioport_map/unmap relies on HAS_IOPORT_MAP
      LIBERTAS_CS: ioport_map/unmap relies on HAS_IOPORT_MAP
      PCMCIA_HERMES: ioport_map/unmap relies on HAS_IOPORT_MAP
      drivers/net/irda/kingsun-sir.c: remove null test before kfree
      drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c: remove null test before kfree
      netfilter: ctnetlink: remove null test before kfree
      net/dsa/dsa.c: remove unnecessary null test before kfree
      drivers/net/wireless/ipw2x00/libipw_module.c: remove unnecessary null test before kfree
      drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c: remove unnecessary null test before debugfs_remove_recursive
      net/caif/caif_socket.c: remove unnecessary null test before debugfs_remove_recursive
      drivers/net/hyperv/netvsc.c: remove unnecessary null test before kfree
      Bluetooth: constify seq_operations
      ipconfig: add static to local variable
      ipconfig: move ic_dev_xid under IPCONFIG_BOOTP
      igb: remove unnecessary break after goto
      ixgbe: remove unnecessary break after goto
      i40e: remove unnecessary break after goto
      i40evf: remove unnecessary break after goto
      ps3_gelic: remove unnecessary break after goto
      orinoco_usb: remove unnecessary break after goto
      wcn36xx: remove unnecessary break after goto
      rtlwifi: remove unnecessary break after goto
      slip: remove unnecessary break after goto
      packet: remove unnecessary break after return
      tipc: remove unnecessary break after return
      9P: remove unnecessary break after return
      af_iucv: remove unnecessary break after goto
      netlabel: remove unnecessary break after goto
      pktgen: remove unnecessary break after goto
      drop_monitor: remove unnecessary break after return
      mac80211: remove unnecessary break after return
      af_key: remove unnecessary break after return
      netfilter: remove unnecessary break after return
      ipv6: remove unnecessary break after return
      NFC: remove unnecessary break after goto
      caif: remove unnecessary break after goto
      irda: remove unnecessary break after return
      ieee802154: remove unnecessary break after goto
      net: sctp: remove unnecessary break after return/goto
      ipvs: remove null test before kfree
      dlci: remove unnecessary break after return
      eth_v10: remove unnecessary break after return
      brcm80211: remove unnecessary break after return
      mwl8k: remove unnecessary break after return
      rtlwifi: remove unnecessary break after return
      rtlwifi: rtl8192ce: remove unnecessary break after return
      rtlwifi: rtl8192se: remove unnecessary break after return
      rtlwifi: rtl8723ae: remove unnecessary break after return
      rtlwifi: rtl8723be: remove unnecessary break after return
      rtlwifi: rtl8188ee: remove unnecessary break after return
      prism54: remove unnecessary break after return
      cw1200: remove unnecessary break after return
      airo: remove unnecessary break after return
      ath6kl: remove unnecessary break after return
      carl9170: remove unnecessary break after return
      e1000: remove unnecessary break after return
      ixgbe: remove unnecessary break after return
      e1000e: remove unnecessary break after return
      igb: remove unnecessary break after return
      8390: remove unnecessary break after return
      net: tulip: remove unnecessary break after return
      bna: remove unnecessary break after return
      sis900: remove unnecessary break after return
      niu: remove unnecessary break after return
      ucc_geth: remove unnecessary break after return
      atl1e: remove unnecessary break after return
      atlx: remove unnecessary break after return
      atl1c: remove unnecessary break after return
      ps3_gelic: remove unnecessary break after return

Fabio Estevam (2):
      fec: Simplify the PM related hooks
      Revert "net: phy: Set the driver when registering an MDIO bus device"

Felix Fietkau (23):
      ath9k: Add channel context structure
      ath9k: Move txpower limit to channel context
      ath9k: Move acq to channel context
      ath9k: Add channel context worker thread
      ath9k: channel context based transmission
      ath9k: send powersave frame on channel switch
      ath9k: Implement hw_scan support
      ath9k: Implement remain-on-channal support
      ath9k: Implement channel context ops
      ath9k: Move caldata into channel context
      ath9k: Add ATH_OP_MULTI_CHANNEL
      ath9k: save tsf in channel context
      ath9k: switch channel context for beaconing
      ath9k: Add p2p go NoA attribute
      ath9k: switch channel after sending beacon
      ath9k: Adjust AP beacon tsf based on station context
      ath9k: Implement mgd_prepare_tx
      ath9k: Add multi-channel scheduling support
      ath9k: Add periodic NoA support
      ath9k: Handle beacon miss on multi channel context
      ath9k: Update channel switch timer
      ath9k: Add recovery mechanism for hw TSF timer
      ath9k: fix pending tx frames accounting

Fengguang Wu (3):
      b43: b43_phyops_a can be static
      netfilter: nft_log: fix coccinelle warnings
      net/mlx4_en: mlx4_en_[gs]et_priv_flags() can be static

Florian Fainelli (26):
      net: systemport: update umac_enable_set to take a bitmask
      net: systemport: add bcm_sysport_netif_{enable,stop}
      net: systemport: add suspend and resume support
      net: systemport: rename rx_csum_en to rx_chk_en
      net: systemport: add Wake-on-LAN support
      net: provide stubs for ip6_set_txhash and ip6_make_flowlabel
      net: phy: export phy_suspend and phy_resume
      net: systemport: align multiple lines correctly
      net: systemport: use kcalloc instead of kzalloc
      net: bcmgenet: remove wol_enabled conditional code
      net: bcmgenet: add umac_enable_set helper
      net: bcmgenet: modularize bcmgenet_{open,close}
      net: bcmgenet: add suspend/resume callbacks
      net: bcmgenet: request Wake-on-LAN interrupt
      net: bcmgenet: add Wake-on-LAN support code
      net: bcmgenet: handle GENET_POWER_WOL_MAGIC
      net: bcmgenet: handle UMAC_IRQ_MPD_R interrupt bit
      net: bcmgenet: fix bcmgenet_wol_resume
      net: bcmgenet: suspend and resume from Wake-on-LAN
      net: bcmgenet: hook ethtool set/get_wol operations
      net: bcmgenet: only update UMAC_CMD if something changed
      net: bcmgenet: remove FSF mail address
      net: bcmgenet: re-align multiple lines correctly
      net: bcmgenet: add and remove missing blank lines
      net: bcmgenet: add missing braces to some if statements
      net: bcmgenet: use kcalloc instead of kzalloc

Florian Westphal (9):
      netfilter: conntrack: remove timer from ecache extension
      inet: frag: constify match, hashfn and constructor arguments
      inet: frag: remove hash size assumptions from callers
      inet: frag: move evictor calls into frag_find function
      inet: frag: move eviction of queues to work queue
      inet: frag: don't account number of fragment queues
      inet: frag: remove lru list
      inet: frag: remove periodic secret rebuild timer
      inet: frag: use seqlock for hash rebuild

Francois Romieu (2):
      net: remove spurious zd1201 rule.
      net: reduce USB network driver config options.

Franky Lin (1):
      brcmfmac: replace cfg80211 testmode with vendor command

Freddy Xin (1):
      AX88179_178A: Add ethtool ops for EEE support

Frederic Danis (1):
      ath6kl: Fix ath6kl_bmi_read_hi32 macro

Geert Uytterhoeven (1):
      enic: Make dummy rfs functions inline to fix !CONFIG_RFS_ACCEL build

Geir Ola Vaagland (4):
      net: sctp: implement rfc6458, 5.3.4. SCTP_SNDINFO cmsg support
      net: sctp: implement rfc6458, 5.3.5. SCTP_RCVINFO cmsg support
      net: sctp: implement rfc6458, 5.3.6. SCTP_NXTINFO cmsg support
      net: sctp: implement rfc6458, 8.1.31. SCTP_DEFAULT_SNDINFO support

Georg Lukas (2):
      Bluetooth: Provide defaults for LE advertising interval
      Bluetooth: Expose default LE advertising interval via debugfs

George Spelvin (3):
      lib: crc32: Greatly shrink CRC combining code
      lib: crc32: Mark test data __initconst
      lib: crc32: Add some additional __pure annotations

Govindarajulu Varadarajan (10):
      flow_keys: Record IP layer protocol in skb_flow_dissect()
      enic: fix return value in _vnic_dev_cmd
      enic: devcmd for adding IP 5 tuple hardware filters
      enic: alloc/free rx_cpu_rmap
      enic: Add Accelerated RFS support
      enic: add low latency socket busy_poll support
      enic: do tx cleanup in napi poll
      enic: fix return values in enic_set_coalesce
      enic: remove #ifdef CONFIG_RFS_ACCEL around filter structures
      enic: Add ethtool support to show classifier filters added by the driver

Greg Rose (1):
      i40e: Stop the VF device after setting its MAC address

Gregory Greenman (1):
      iwlwifi: mvm: wait for d0i3 exit in add interface flow

Grygorii Strashko (2):
      net: davinci_mdio: reuse for keystone2 arch
      net: davinci_mdio: allow to create phys from dt

Haiyang Zhang (1):
      hyperv: Add handler for RNDIS_STATUS_NETWORK_CHANGE event

Hannes Frederic Sowa (2):
      random32: mix in entropy from core to late initcall
      ipv6: data of fwmark_reflect sysctl needs to be updated on netns construction

Hans Wennborg (2):
      drivers: atm: fix %d confusingly prefixed with 0x in format strings
      net: smc911x: fix %d confusingly prefixed with 0x in format string

Hans de Goede (2):
      brcmfmac: Fix some wrong register defines
      brcmfmac: Fix OOB interrupt not working for BCM43362

Hante Meuleman (11):
      brcmfmac: Add 43569 USB support.
      brcmfmac: Add USB device 43566 to supported devices.
      brcmfmac: Change USB probe routine to support Composite USB
      brcmfmac: Cleanup used device IDs.
      brcmfmac: Export brcmf_netif_rx for new protocol msgbuf.
      brcmfmac: Add protocol addressing mode and peer deletion API.
      brcmfmac: Adding msgbuf protocol.
      brcmfmac: Adding PCIe bus layer support.
      brcmfmac: Update pcie reset device routine.
      brcmfmac: Fix msgbuf flow control.
      brcmfmac: Add TDLS support to msgbuf.

Hariprasad Shenai (18):
      rdma/cxgb4: Fixes cxgb4 probe failure in VM when PF is exposed through PCI Passthrough
      cxgb4: Use FW interface to get BAR0 value
      cxgb4: Replaced the backdoor mechanism to access the HW memory with PCIe Window method
      cxgb4: Adds device ID for few more Chelsio T4 Adapters
      cxgb4vf: Adds device ID for few more Chelsio T4 Adapters
      iw_cxgb4: Detect Ing. Padding Boundary at run-time
      cxgb4/iw_cxgb4: use firmware ord/ird resource limits
      cxgb4/iw_cxgb4: display TPTE on errors
      cxgb4/iw_cxgb4: work request logging feature
      iw_cxgb4: fix for 64-bit integer division
      cxgb4: Add the MC1 registers to read in the interrupt handler
      iw_cxgb4: log detailed warnings for negative advice
      iw_cxgb4: Support query_qp() verb
      iw_cxgb4: advertise the correct device max attributes
      iw_cxgb4: Don't limit TPTE count to 32KB
      cxgb4: Fixed incorrect check for memory operation in t4_memory_rw
      cxgb4: only free allocated fls
      cxgb4vf: Turn off SGE RX/TX Callback Timers and interrupts in PCI shutdown routine

Harish Patil (2):
      qlcnic: Enhance Tx timeout debug data collection.
      qlcnic: Update version to 5.3.61

Himangi Saraogi (16):
      batman-adv: Use kasprintf
      net: ipv6: Use BUG_ON
      ipv6: Use BUG_ON
      Bluetooth: cmtp: Remove unnecessary null test
      igmp: remove exceptional & on function name
      neigh: remove exceptional & on function name
      net_sched: remove exceptional & on function name
      isdn: use constants instead of magicnumbers
      netfilter: nf_conntrack: remove exceptional & on function name
      net/ipv4: Use IS_ERR_OR_NULL
      openvswitch: Use IS_ERR_OR_NULL
      net/udp_offload: Use IS_ERR_OR_NULL
      cirrus: cs89x0: Use managed interfaces
      net: ks8851-ml: Use devm_ioremap_resource
      net: dnet: Use managed interfaces
      net: phy: spi_ks8995: Introduce the use of devm_kzalloc

Hisashi Nakamura (1):
      net: sh_eth: Add r8a7794 support

Ivan Vecera (2):
      bna: fill the magic in bnad_get_eeprom() instead of validating
      bna: fix performance regression

JF Le Fillatre (1):
      r8152: add missing Makefile rule

Jack Morgenstein (3):
      mlx5: Move pci device handling from mlx5_ib to mlx5_core
      mlx5: minor fixes (mainly avoidance of hidden casts)
      mlx5: Adjust events to use unsigned long param instead of void *

Jacob Keller (9):
      i40e: rename i40e_ptp_enable to i40e_ptp_feature_enable
      i40e: break PTP hardware control from ioctl command for timestamp mode
      i40e: don't store user requested mode until we've validated it
      i40e: only create PTP device node once
      i40e: remove linux/export.h header from i40e_ptp.c
      ixgbe: change PTP NSECS_PER_SEC to IXGBE_PTP_PPS_HALF_SECOND
      i40e: (ptp) warn when PF_ID does not match in PRTTSYN_CTL0
      ixgbe: fix use of list_for_each in ixgbe_enumerate_functions
      ixgbe: don't check minimum link when direct assigned to virtual machine

Jahnavi Meher (18):
      rsi: Mapping the debugfs stats to the correct s/w queues.
      rsi: Fixed the kernel doc
      rsi: Using band from rsi_common to fill in ieee80211_rx_status
      rsi: Add macros for endpoints and set default value of endpoint.
      rsi: Changed the radio caps frame.
      rsi: Changed the rsi_set_channel() and rsi_program_bb_rf().
      rsi: Changed rate handling.
      rsi: Lower level debug messages and changed handling of confirm received for rsi_program_bb_rf().
      rsi: Use SGI if configured for fixed rate transmission.
      rsi: Changed the SDIO interrupt variables and some clean up.
      rsi: Changed the logic of dequeuing packets from hal queues.
      rsi: Added debug messages.
      rsi: Sending QoS null packet via the mgmt queue.
      rsi: Adding support for 5GHz
      rsi: Adding support for host based bgscan.
      rsi: Changes for 40MHz
      rsi: Fixed errors and warnings reported by static code analyzers.
      rsi: Fixed warnings reported by static code analyzers.

Jakub Kicinski (2):
      i40e: never generate both software and hardware timestamps
      i40e: fix race conditions on queuing skb for HW time stamp

Jamal Hadi Salim (2):
      bridge: fdb dumping takes a filter device
      bridge: netlink dump interface at par with brctl

Janusz Dziedzic (4):
      ath10k: print Kconfig options
      mac80211: allow tx via monitor iface when DFS
      ath10k: add implementation for configure max amsdu, ampdu
      ath10k: handle attention flags correctly when using A-MSDU

Jason Gunthorpe (1):
      sctp: Fixup v4mapped behaviour to comply with Sock API

Jason Wang (2):
      virtio-net: introduce virtnet_receive()
      virtio-net: rx busy polling support

Jeff Layton (1):
      net: clean up some sparse endianness warnings in ipv6.h

Jesper Dangaard Brouer (3):
      pktgen: document tuning for max NIC performance
      pktgen: avoid expensive set_current_state() call in loop
      pktgen: RCU-ify "if_list" to remove lock in next_to_run()

Jesse Brandeburg (9):
      i40e: workaround NVM GLQF_HKEY
      i40e/i40evf: remove reserved type
      i40e: fix fdir programming
      i40e/i40evf: initialize context descriptor
      i40e: disable TPH
      i40e: Finish implementation of ethtool get settings
      i40e: move nway reset
      i40e/i40evf: fix extension header csum logic
      i40evf: fix scan warning on sprintf

Jessica Wu (3):
      ath6kl: implement rx flush for htc pipe
      ath6kl: add support wmi rate tables with mcs15
      ath6kl: add support for ar6004 hw3.0

Jianhua Xie (2):
      bonding: enhance L2 hash helper with packet type
      bonding: update bonding.txt for Layer2 hash factors

Jiri Pirko (5):
      rtnetlink: allow to register ops without ops->setup set
      openvswitch: introduce rtnl ops stub
      bonding: allow to add vlans on top of empty bond
      bonding: remove no longer relevant vlan warnings
      ipv6: addrconf: implement address generation modes

Jiri Prchal (1):
      netfilter: xt_LED: fix too short led-always-blink

Jitendra Kalsaria (3):
      bnx2: Rebranding bnx2 driver.
      cnic: Rebranding cnic driver.
      MAINTAINERS: Update bnx2 maintainers

Joe Perches (2):
      rt2x00: Use dma_zalloc_coherent
      mac_pton: Use bool not int return

Johan Hedberg (138):
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
      Bluetooth: Remove unnecessary hci_dev_unlock for smp_user_confirm_reply
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
      Bluetooth: Use real advertising state to random address update decision
      Bluetooth: Simplify usage of the enable_advertising function
      Bluetooth: Use the correct flag to decide to disable advertising
      Bluetooth: Stop advertising always before initiating a connection
      Bluetooth: Fix advertising and active scanning co-existence
      Bluetooth: Fix check for re-enabling advertising
      Bluetooth: Fix setting STOPPING state for discovery
      Bluetooth: Fix connectable and discoverable supported settings values
      Bluetooth: Fix toggling background scan when changing connectable state
      Bluetooth: Fix clearing HCI_LE_ADV for LE connections
      Bluetooth: Unify helpers for bdaddr_list manipulations
      Bluetooth: Introduce a whitelist for BR/EDR devices
      Bluetooth: Update page scan when necessary for Add/Remove Device
      Bluetooth: Fix incorrectly setting HCI_CONNECTABLE
      Bluetooth: Refactor connection request handling
      Bluetooth: Enable page scan also if there are white list entries
      Bluetooth: Add white list lookup for incoming connection requests
      Bluetooth: Fix setting HCI_CONNECTABLE from ioctl code
      Bluetooth: Always confirm incoming SMP just-works requests
      Bluetooth: Fix forcing SMP just-works with no-bonding
      Bluetooth: Fix incorrect clearing of SMP_FLAG_INITIATOR
      Bluetooth: Fix advertising parameter update when toggling connectable
      Bluteooth: Reject SMP bonding if HCI_PAIRABLE is not set
      Bluetooth: Fix using test_and_clear instead of test_and_set
      Bluetooth: Remove unneeded mgmt_connectable function
      Bluetooth: Refactor ioctl scan state update to its own function
      Bluetooth: Remove unneeded mgmt_discoverable function
      Bluetooth: Remove unneeded mgmt_write_scan_failed function
      Bluetooth: Fix tracking local SSP authentication requirement
      Bluetooth: Fix trying LTK re-encryption when we don't have an LTK
      Bluetooth: Remove unnecessary params variable from process_adv_report()
      Bluetooth: Don't try to reject failed LE connections
      Bluetooth: Add proper defines for HCI connection role
      Bluetooth: Convert HCI_CONN_MASTER flag to a conn->role variable
      Bluetooth: Use explicit role instead of a bool in function parameters
      Bluetooth: Add a role parameter to hci_conn_add()
      Bluetooth: Track number of LE slave connections
      Bluetooth: Fix trying to initiate connections when acting as LE slave
      Bluetooth: Fix always checking the blacklist for incoming connections
      Bluetooth: Fix using uninitialized variable when pairing
      Bluetooth: Don't bother user space without IO capabilities
      Bluetooth: Fix resetting remote authentication requirement after pairing
      Bluetooth: Pass initiator/acceptor information to hci_conn_security()
      Bluetooth: Introduce a flag to track who really initiates authentication
      Bluetooth: Fix allowing initiating pairing when not pairable
      Bluetooth: Use EOPNOTSUPP instead of ENOTSUPP
      Bluetooth: Disable HCI_CONNECTABLE based passive scanning for now
      Bluetooth: Prefer sizeof(*ptr) when allocating memory
      Bluetooth: Fix clearing HCI_PSCAN flag
      Bluetooth: Fix incorrectly disabling page scan when toggling connectable
      Bluetooth: Fix SMP context tracking leading to a kernel crash
      Bluetooth: Fix check for connected state when pairing
      Bluetooth: Rename HCI_PAIRABLE to HCI_BONDABLE
      Bluetooth: Rename pairable mgmt setting to bondable
      Bluetooth: Always use non-bonding requirement when not bondable

Johannes Berg (11):
      mac80211: fix station/driver powersave race
      mac80211: remove weak WEP IV accounting
      cfg80211: make ethtool the driver's responsibility
      mac80211_hwsim: clean up own address matching
      iwlwifi: mvm: add back support for low-priority scan
      iwlwifi: mvm: handle device start failures during restart
      iwlwifi: mvm: don't send zero quota to the firmware
      iwlwifi: mvm: validate that we don't send zero quota
      iwlwifi: mvm: don't pass update type to quota iterator
      iwlwifi: mvm: remove update type argument from quota update
      mac80211: suppress unused variable warning without lockdep

John W. Linville (15):
      mac80211: remove PID rate control
      Merge git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge tag 'for-linville-20140717' of git://github.com/kvalo/ath
      Merge git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge tag 'nfc-next-3.17-1' of git://git.kernel.org/.../sameo/nfc-next
      Merge tag 'for-linville-20140725' of git://github.com/kvalo/ath
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next

Jon Paul Maloy (21):
      tipc: eliminate case of writing to freed memory
      tipc: use negative error return values in functions
      tipc: introduce send functions for chained buffers in link
      tipc: make link mtu easily accessible from socket
      tipc: introduce direct iovec to buffer chain fragmentation function
      tipc: separate building and sending of rejected messages
      tipc: introduce message evaluation function
      tipc: RDM/DGRAM transport uses new fragmenting and sending functions
      tipc: connection oriented transport uses new send functions
      tipc: let port protocol senders use new link send function
      tipc: same receive code path for connection protocol and data messages
      tipc: clean up connection protocol reception function
      tipc: simplify connection congestion handling
      tipc: make name table distributor use new send function
      tipc: let internal link users call the new link send function
      tipc: add new functions for multicast and broadcast distribution
      tipc: start using the new multicast functions
      tipc: remove unreferenced functions
      tipc: rename temporarily named functions
      tipc: ensure sequential message delivery across dual bearers
      tipc: make tipc_buf_append() more robust

Jukka Rissanen (5):
      Bluetooth: Provide L2CAP ops callback for memcpy_fromiovec
      Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one
      Bluetooth: 6LoWPAN: Create a kernel module
      Bluetooth: 6LoWPAN: Count module usage
      Bluetooth: 6LoWPAN: Remove network devices when unloading

Julia Lawall (2):
      CAPI: use correct structure type name in sizeof
      iwlegacy: use correct structure type name in sizeof

KY Srinivasan (1):
      Drivers: net-next: hyperv: Increase the size of the sendbuf region

Kalesh AP (11):
      be2net: re-enable vlan filtering mode asap
      be2net: use -ENETDOWN error status when interface is down
      be2net: fix error status for FW-download
      be2net: return -ETIMEDOUT when a FW-cmd times out
      be2net: return -ENOMEM for memory allocation failures
      be2net: fix return status of some ethtool methods
      be2net: fix return status of some ndo methods
      be2net: reduce arguments passed to FW-cmd routines
      be2net: remove unused structures in be_cmds.h
      be2net: use "if (!foo)" test style
      be2net: support deleting FW dump via ethtool (only for Lancer)

Kalle Valo (4):
      ath10k: remove unused len variables from wmi process rx functions
      ath6kl: convert ar6004 hardware flags to firmware feature flags
      ath6kl: don't set hi_refclk_hz if hardware version doesn't need it
      Merge remote-tracking branch 'wireless-next/master' into ath-next

Kamil Krawczyk (4):
      i40e/i40evf: modify debug prints to avoid seg faults
      i40e: do not take NVM ownership for SR read
      i40e/i40evf: add ASQ write back timeout variable to AQ structure
      i40e/i40evf: ARQ copy desc data even for failed commands

Karoly Kemeny (2):
      ipv4: clean up cast warning in do_ip_getsockopt
      net: kernel-doc compliant documentation for net_device

Kees Cook (1):
      rtlwifi: btcoexist: avoid format string in printk

Kevin Scott (1):
      i40e: Correct mask assignment value

Lad, Prabhakar (1):
      can: c_can: convert to use devm * api

Lendacky, Thomas (25):
      amd-xgbe: Make defines in xgbe.h unique
      amd-xgbe: VLAN Tx tag insertion fix
      amd-xgbe: VLAN Rx tag stripping fix
      amd-xgbe: Add support for VLAN filtering
      amd-xgbe: Change destination address filtering support
      amd-xgbe: Resolve checkpatch warning about sscanf usage
      amd-xgbe: Fix debugfs compatibility change with kstrtouint
      amd-xgbe: Clear the proper MTL interrupt register
      amd-xgbe: Call netif_napi_del on ndo_stop operation
      amd-xgbe: Performance enhancements
      amd-xgbe: Base AXI DMA cache settings on device tree
      phy: Expand phy speed/duplex settings array
      amd-xgbe: Remove the adjustments needed for fixed speed
      amd-xgbe: Add dma-coherent to device bindings documentation
      amd-xgbe: Add hardware timestamp support
      amd-xgbe: Update/fix 2.5GbE support
      amd-xgbe: Base queue fifo size and enablement on ring count
      amd-xgbe-phy: Updates to rate change complete check
      amd-xgbe-phy: Updates to KR training initiation
      amd-xgbe-phy: Print out the auto-negotiation method used
      amd-xgbe: Add traffic class support
      amd-xgbe: Remove unnecessary spinlocks
      amd-xgbe-phy: Allow more time for Rx/Tx to become ready
      amd-xgbe: Use dma_set_mask_and_coherent to set DMA mask
      amd-xgbe: Perform phy connect/disconnect at dev open/stop

Li RongQing (4):
      bridge: use list_for_each_entry_continue_reverse
      ipv6: fix the check when handle RA
      ipv4: remove the unnecessary variable in udp_mcast_next
      ipv6: remove obsolete comment in ip6_append_data()

Liad Kaufman (5):
      iwlwifi: update trans->hw_rev 8000 hw family format
      iwlwifi: nvm: update maximal parsed values in external nvm
      iwlwifi: mvm: assure no overflows occur while reading otp
      iwlwifi: mvm: remove 8000 HW family setting of adc sampling on nic config
      mac80211: make sure TDLS teardown packet is sent on time

Linus LÃ¼ssing (2):
      bridge: adding stubs for multicast exports
      bridge: export knowledge about the presence of IGMP/MLD queriers

Loic Poulain (1):
      Bluetooth: Remove redundant calls to h5_reset_rx

Lorenzo Bianconi (1):
      ath9k: set up tx power into the MRR

Luciano Coelho (8):
      mac80211: don't stop all queues when flushing
      mac80211: introduce refcount for queue_stop_reasons
      mac80211: add functions to stop and wake all queues assigned to a vif
      mac80211: stop only the queues assigned to the vif during channel switch
      iwlwifi: mvm: let iwl_mvm_update_quotas disregard a disabled vif
      iwlwifi: mvm: add switch_vif_chanctx operation
      iwlwifi: mvm: CSA unbind-bind flow support for client
      mac80211: remove redundant IEEE80211_STA_CSA_RECEIVED flag

Luis R. Rodriguez (2):
      p54: use request_firmware_direct() for optional EEPROM override
      wireless: fixup genregdb.awk for remove of antenna gain from wireless-regd

Maciej W. Rozycki (7):
      declance: Fix 64-bit compilation warnings
      defxx: Correct the receive DMA map size
      defxx: Discard DMA maps on buffer deallocation
      defxx: Use netdev_alloc_skb consistently
      defxx: Handle DMA mapping errors
      defxx: Add missing DMA synchronisation calls
      defxx: Fix issues with debug printk calls

Madalin Bucur (1):
      net/fsl: fix misspelled word

Mahesh Bandewar (1):
      bonding: Do not try to send packets over dead link in TLB mode.

Manuel SchÃ¶lling (1):
      xilinx: Fix compiler warning

Marc Zyngier (1):
      net: sun4i-emac: fix memory leak on bad packet

Marcel Holtmann (120):
      Merge git://git.kernel.org/.../bluetooth/bluetooth
      Bluetooth: Use const for struct l2cap_ops field
      Bluetooth: Assign L2CAP socket priority when allocating SKB
      Bluetooth: Shrink size of struct l2cap_ctrl fields
      Bluetooth: Use explicit header and body length for L2CAP SKB allocation
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
      Bluetooth: Don't use non-resolvable private address for passive scanning
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
      Bluetooth: Remove connection interval parameters from hci_conn_params_set
      Bluetooth: Fix merge of advertising data and scan response data
      Bluetooth: Provide flags parameter direct to mgmt_device_found
      Bluetooth: Add support for Not Connectable flag for Device Found events
      Bluetooth: Do not trigger background scanning when HCI_AUTO_OFF is set
      Bluetooth: Ensure that background scanning gets enabled on power on
      Bluetooth: Add support for hdev->set_bdaddr callback handling
      Bluetooth: Add public address configration for Broadcom USB devices
      Bluetooth: Add public address configration for Intel USB devices
      Bluetooth: Default to internal use manufacturer identifier
      Bluetooth: Check for default address of Intel USB controllers
      Bluetooth: Check for default address of Broadcom BCM20702A0 controllers
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
      Bluetooth: Add support for Set External Configuration management command
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
      Bluetooth: Mark controller is down when HCI_AUTO_OFF is set
      Bluetooth: Set HCI_PAIRABLE during power on for legacy ioctl
      Bluetooth: Move HCI socket definitions into its own header file
      Bluetooth: Move struct hci_sec_filter next to its user
      Bluetooth: Delcare the hci_sec_filter as const
      Bluetooth: Move struct hci_pinfo into net/bluetooth/hci_sock.c
      Bluetooth: Move HCI request internals to net/bluetooth/hci_core.c
      Bluetooth: Update the list of L2CAP fixed channels
      Bluetooth: Move struct sco_pinfo into net/bluetooth/sco.c
      Bluetooth: Move struct sco_conn into net/bluetooth/sco.c
      Bluetooth: Remove unused SCO_DEFAULT_FLUSH_TO constant
      Bluetooth: Move SCO timeout constants into net/bluetooth/sco.c
      Bluetooth: Check for valid HCI UART driver flags
      Bluetooth: Add support for external configuration with UART driver
      Bluetooth: Fix HCIUARTGETDEVICE ioctl when UART is not registered
      Bluetooth: Read LE Advertising Channel TX Power only when available
      Bluetooth: Enable LE encryption events only when supported
      Bluetooth: Enable LE Long Term Key Request event only when supported
      Bluetooth: Allocate struct inquiry_entry with GFP_KERNEL
      Bluetooth: Remove unneeded forward declaration of __sco_chan_add
      Bluetooth: Remove unneeded forward declaration of sco_chan_del
      Bluetooth: Convert L2CAP ident spinlock into a mutex
      Bluetooth: Remove sco_chan_get helper function
      Bluetooth: Fix endian and alignment issue with ath3k version handling
      Bluetooth: Remove unneeded variable assignment in hmac_sha256
      Bluetooth: Add support for Broadcom device of Asus Z97-DELUXE motherboard
      Bluetooth: Read list of local codecs supported by the controller
      Bluetooth: Get MWS transport configuration of the controller
      Bluetooth: Ignore ADV_DIRECT_IND attempts from unknown devices
      Bluetooth: Fix issue with ADV_IND reports and auto-connection handling
      Bluetooth: Add support for using controller white list filtering
      Bluetooth: Fix white list handling with resolvable private addresses
      Bluetooth: Set Simultaneous LE and BR/EDR controller option to zero
      6lowpan: iphc: Fix block comments to match networking style
      6lowpan: iphc: Fix issues with alignment matching open parenthesis
      6lowpan: iphc: Fix missing blank line after variable declarations
      6lowpan: iphc: Fix missing braces for if statement
      6lowpan: iphc: Fix parenthesis alignments which off-by-one
      Bluetooth: Fix sparse warning from HID new leds handling

Marcin Wojtas (3):
      ethernet: Add new driver for Marvell Armada 375 network unit
      net: mvpp2: Fix the periodic XON enable bit
      net: mvpp2: Enable proper PHY polling and fix port functionality

Mark A. Greer (5):
      NFC: digital: Check for NFC-DEP before checking for Type 4 tag
      NFC: digital: Clear poll_tech_count before activating target
      NFC: digital: Add digital framing calls when in target mode
      NFC: digital: Remove extra blank line
      NFC: digital: Add 'tg_listen_md' and 'tg_get_rf_tech' driver hooks

Mark Rustad (10):
      ixgbe: Fix possible null-dereference in error path
      ixgbe: Change some uses of strncpy to strlcpy
      ixgbe: Convert some udelays to usleep_range
      ixgbe: Fix spurious release of semaphore in EEPROM access
      ixgbe: Correct X540 semaphore error
      ixgbe: Fix ixgbe_write_mbx error result
      ixgbe: Delete a bunch of dead code
      ixgbevf: Remove unused get_supported_physical_layer pointer
      ixgbe: Make return values more direct
      netlink: Fix shadow warning on jiffies

Markus Pargmann (1):
      mwifiex: Remove custom world regulatory domain

Mateusz Wrzesinski (1):
      sfc: Adding PCI ID for Solarflare 7000 series 40G network adapter.

Mathias Krause (2):
      vti6: Simplify error handling in module init and exit
      vti: Simplify error handling in module init and exit

Mathy Vanhoef (2):
      ath5k: support for FIF_FCSFAIL filter
      ath5k: capture CCK and OFDM restarts

Max Stepanov (1):
      mac80211: fix a potential NULL access in ieee80211_crypto_hw_decrypt

Michael S. Tsirkin (1):
      bridge: remove a useless comment

Michal Kazior (19):
      mac80211: move csa counters from sdata to beacon/presp
      mac80211: use csa counter offsets instead of csa_active
      mac80211: implement multi-vif in-place reservations
      mac80211: make check_combinations() aware of chanctx reservation
      mac80211: use chanctx reservation for AP CSA
      mac80211: use chanctx reservation for STA CSA
      cfg80211: remove channel_switch combination check
      ath10k: fix unregister deadlock when fw probe fails
      ath10k: fix bmi exchange tx/rx race
      ath10k: sanitize tx ring index access properly
      mac80211: fix Rx reordering with RX_FLAG_AMSDU_MORE
      mac80211: add support for Rx reordering offloading
      ath10k: workaround boot issues with KVM/PCI-passthrough
      ath10k: prevent some tx flushing failures
      ath10k: simplify tx helpers
      ath10k: workaround qos nullfunc bug
      ath10k: prevent endless pci rx loop
      ath10k: fix Rx aggregation reordering
      ath10k: don't advertise IBSS iftype for 10.x

Michal Kosiarz (1):
      i40e/i40evf: Reset Head and Tail on AQ initialization

Mitch Williams (13):
      i40evf: fix off-by-one
      i40evf: don't stop watchdog if it hasn't started
      i40evf: return more useful error information
      i40evf: fix typo
      i40evf: resend FW request if no response
      i40evf: set flags before sending message
      i40evf: change branding string
      i40evf: don't violate scope
      i40e: tolerate lost interrupts
      i40evf: invite vector 0 to the interrupt party
      i40evf: don't wait so long
      i40evf: don't leak queue vectors
      i40evf: fix memory leak on unused interfaces

Mugunthan V N (3):
      drivers: net: cpsw: disable coalesce when rx_coalesce_usecs is zero
      drivers: net: cpsw: add support to dump ALE table via ethtool register dump
      drivers: net: cpsw: cleanup: remove unused function

Neal Cardwell (2):
      tcp: switch snt_synack back to measuring transmit time of first SYNACK
      tcp: reduce spurious retransmits due to transient SACK reneging

Neerav Parikh (5):
      i40e: Helper routine for Rx/Tx queue enable/disable wait
      i40e: debugfs fix to dump remote LLDPDU
      i40e: Fix scheduling while atomic bug during NAPI
      i40e: Add PF reset when Malicious driver event for PF
      i40e: Add ndo_get_phys_port_id() callback support

Nick Pelly (1):
      Bluetooth: Fallback to SCO on error code 0x10 (Connection Accept Timeout)

Nicolas Ferre (1):
      net/macb: configure for FIFO mode and non-gigabit

Nikita Edward Baruzdin (4):
      can: netlink: Remove space before tab
      can: netlink: Add CAN_CTRLMODE_PRESUME_ACK flag
      can: sja1000: Add support for CAN_CTRLMODE_LOOPBACK
      can: sja1000: Add support for CAN_CTRLMODE_PRESUME_ACK

Nikolay Aleksandrov (8):
      bonding: fix bond_option_mode_set warning
      inet: frag: set limits and make init_net's high_thresh limit global
      inet: frags: use INC_STATS_BH in the ipv6 reassembly code
      inet: frags: rename last_in to flags
      inet: frags: enum the flag definitions and add descriptions
      inet: frags: fix function declaration alignments in inet_fragment
      inet: frags: use INET_FRAG_EVICTED to prevent icmp messages
      inet: frags: use kmem_cache for inet_frag_queue

Noa Osherovich (1):
      net/mlx4_en: Fix mac_hash database inconsistency

Octavian Purdila (15):
      tcp: move ir_mark initialization to tcp_openreq_init
      tcp: cookie_v4_init_sequence: skb should be const
      tcp: tcp_v[46]_conn_request: fix snt_synack initialization
      net: remove inet6_reqsk_alloc
      tcp: add init_req method to tcp_request_sock_ops
      tcp: add init_cookie_seq method to tcp_request_sock_ops
      tcp: add route_req method to tcp_request_sock_ops
      tcp: move around a few calls in tcp_v6_conn_request
      tcp: add init_seq method to tcp_request_sock_ops
      tcp: add send_synack method to tcp_request_sock_ops
      tcp: unify tcp_v4_rtx_synack and tcp_v6_rtx_synack
      tcp: add mss_clamp to tcp_request_sock_ops
      tcp: add queue_add_hash to tcp_request_sock_ops
      tcp: add tcp_conn_request
      tcp: tcp_conn_request: fix build error when IPv6 is disabled

Oliver Neukum (1):
      cdc_subset: deal with a device that needs reset for timeout

Ondrej Zary (11):
      tlan: Enable activity LED on Olicom OC-2325 and OC-2326
      tlan: Enable link monitoring
      tlan: Add ethtool support
      tlan: Fix MAC address byte order on OC-2325/OC-2326
      tlan: Restart autonegotiation on link loss
      tlan: Don't scream if no link
      tlan: Make autonegotiation faster
      tlan: Add PHY reset timeout
      tlan: Don't disable internal PHY on cards that use it in 10 Mbps mode
      tlan: Enable device at resume
      tlan: Isolate external PHY when using internal PHY

Oren Givon (1):
      iwlwifi: add max RX aggregation size

Pablo Neira (2):
      netfilter: xt_bpf: add mising opaque struct sk_filter definition
      net: filter: don't release unattached filter through call_rcu()

Pablo Neira Ayuso (14):
      netfilter: kill ulog targets
      netfilter: nf_log: use an array of loggers instead of list
      netfilter: nf_log: move log buffering to core logging
      netfilter: log: split family specific code to nf_log_{ip,ip6,common}.c files
      netfilter: log: nf_log_packet() as real unified interface
      netfilter: add generic ARP packet logger
      netfilter: bridge: add generic packet logger
      netfilter: nft_log: request explicit logger when loading rules
      netfilter: nft_log: complete logging support
      netfilter: fix several Kconfig problems in NF_LOG_*
      netfilter: xt_LOG: add missing string format in nf_log_packet()
      netfilter: bridge: add reject support
      netfilter: nf_tables: simplify set dump through netlink
      netfilter: nf_tables: check for unset NFTA_SET_ELEM_LIST_ELEMENTS attribute

Paul Bolle (1):
      netfilter: kill remnants of ulog targets

Paul M Stillwell Jr (3):
      i40e/i40evf: Big endian fixes for handling HMC
      i40e/i40evf: Force a shifted '1' to be unsigned
      i40e/i40evf: Clean up code

Peter Pan(æ½˜å«å¹³) (1):
      net: delete duplicate dev_set_rx_mode() call

Peter Senna Tschudin (2):
      net: wireless: Remove useless return variables
      cw1200: Remove useless return variables

Prashant Sreedharan (2):
      MAINTAINERS: Update tg3 maintainer
      tg3: Modify tg3_tso_bug() to handle multiple TX rings

Pravin B Shelar (1):
      openvswitch: Enable tunnel GSO for OVS bridge.

Quentin Armitage (1):
      ipv4: Make IP_MULTICAST_ALL and IP_MSFILTER work on raw sockets

RafaÅ‚ MiÅ‚ecki (63):
      b43: drop B43_DEFAULT_CHANNEL
      b43: b43_op_config: drop check for core change
      b43: b43_op_config: use IEEE80211_CONF_CHANGE_CHANNEL
      b43: PHY: don't force default channel during init
      b43: b43_op_config: set channel info before switching band
      b43: store current channel using struct cfg80211_chan_def
      b43: PHY: drop own channel_freq (get it from chandef when needed)
      b43: PHY: drop is_40mhz (get width info from chandef)
      b43: PHY: drop channel_type (we can get this info from chandef)
      bcma: gpio: register all 32 GPIOs on BCM53572
      b43: remove leftover code from old devices support
      b43: add config for (en|dis)abling G-PHY support
      b43: N-PHY: update code for sending sample tone
      b43: N-PHY: update low-pass filter setup
      b43: update list and code making a selection of firmware files
      b43: treat LCNXN-PHY as extra N-PHY devices
      b43: N-PHY: fixes for radio 0x2057
      b43: N-PHY: complete generic support for 0x2057 radio
      b43: add more bcma cores
      b43: N-PHY: initialize hardware tables on new devices
      b43: N-PHY: rework names & picking of TX gain tables
      b43: N-PHY: add TX gains tables for radio 0x2057 rev 9
      b43: fix reading info about radio for new devices (cores 40 & 42)
      bcma: add driver for PCIe Gen 2 core
      b43: always print info about radio (manuf, id, revision)
      b43: N-PHY: drop reg 0x1 access restriction on new PHY revs
      b43: N-PHY: add TX gain tables for devices with specific EPA
      b43: N-PHY: add placeholders for new devices support
      b43; N-PHY: write most of the missing code for revs 7+
      b43: N-PHY: init and channel switching of radio 0x2057 rev 9
      b43: N-PHY: implement channel switching of radio 0x2057 rev 5
      b43: enable radio 0x2057 rev 9 (AKA BCM43228) support
      b43: don't warn about no 5 GHz support on 2.4 GHz devices
      b43: N-PHY: add missing TX gain table for radio 0x2057 rev 5
      ssb: make code for antenna gain extraction more generic
      ssb: extract antenna gains from SPROMs revs 4+ properly
      ssb: extract power info from SPROM revs 4 and 5
      bcma: extract antenna gains from SPROM correctly
      bcma: add support for BCM43217 found in Tenda W322E (14e4:43a9)
      b43: N-PHY: fix channel switching with 2 GHz radio 0x2057
      b43: N-PHY: add tables for radio 0x2057 rev 14
      b43: N-PHY: complete 0x2057 radio init calibration
      b43: N-PHY: set band on every channel switch
      b43: use one shared function for setting MAC frequency
      b43: N-PHY: update spur avoidance to support newer devices
      b43: N-PHY: add helper for setting digital filters
      b43: N-PHY: update digital filters setup
      b43: N-PHY: update generic rev7+ workarounds
      b43: N-PHY: allow applying separated workarounds per core
      b43: N-PHY: add rev7+ workarounds for radio revs 9 and 14
      b43: N-PHY: final fixes to rev7+ workarounds
      b43: enable radio 0x2057 rev 14 support (AKA BCM43217)
      b43: extract one more radio parameter: version
      b43: N-PHY: fix rev7+ typos at random places
      b43: report correct rate to mac80211 for 5 GHz packets
      b43: N-PHY: don't calculate values for TSSI if we can't transmit
      b43: register limited amount of 5G channels for BCM43228
      b43: enable 5 GHz support for N-PHY devices
      b43: add support for BCM43131 chipset with N-PHY rev 17
      bcma: add support for BCM43131 that was found in Tenda W311E
      b43: update PHY descriptions in Kconfig
      b43: N-PHY: fix "Data bus error" while working in 5 GHz
      bcma: use NS prefix for names of Northstar specific cores

Rajesh Borundia (3):
      qlcnic: Fix update of ethtool stats.
      qlcnic: Set driver version before registering netdev
      qlcnic: Initialize dcbnl_ops before register_netdev

Rajkumar Manoharan (16):
      ath9k: Fetch appropriate operating channel context
      ath9k: Move beacon config to channel context
      ath9k: Summarize hw state per channel context
      ath9k: Store current offchannel duration
      ath9k: use separate HW queue for each channel context
      ath9k: Advertise multichannel support
      ath9k: Fix build error in ath_reset_internal
      ath9k_hw: update CCK loop coefficients for AR953x 1.0
      ath9k_hw: Add QCA953x 2.0 initvals
      ath9k_hw: fix XPABIASLEVEL settings for AR9531
      ath9k_hw: fix tx gain table index for AR953x
      ath9k_hw: Fix pll2_divfrac for AR953x
      ath9k: Cache beacon config after association
      ath9k: Increase max listen interval
      ath9k: Calculate sleep duration
      ath9k: Initialize channel context ops on ahb probe

Rami Rosen (1):
      netlink: Fix do_one_broadcast() prototype.

Rasmus Villemoes (3):
      trivial: net/irda/irlmp.c: Fix closing brace followed by if
      net/wireless/brcm80211/brcmfmac: Make return type and name reflect actual semantics
      net: arcnet: Remove "#define bool int"

Ricardo Ribalda (1):
      net/usb/hso: Add support for Option GTM671WFS

Richard Weinberger (1):
      hyperv: Add netpoll support

Rickard Strandqvist (8):
      net: wireless: libertas: cmd.c: Cleaning up uninitialized variables
      net: wireless: rt2x00: rt2x00mac.c: Cleaning up uninitialized variables
      net: wireless: rtlwifi: rtl8192de: phy.c: Cleaning up uninitialized variable
      rtlwifi/rtl8192de: Fix media status register mask
      rtlwifi/rtl8192c[eu]: Fix media status register mask
      rtlwifi/rtl8188ee: Fix media status register mask
      rtlwifi/rtl8723ae: Replace magic number by macro
      rtlwifi/rtl8723be: Replace magic number by macro

Russell King (29):
      net: fec: iMX6 FEC does not support half-duplex gigabit
      net: fec: fix ethtool set_pauseparam duplex bug
      net: fec: fix interrupt handling races
      net: fec: use netif_tx_disable() rather than netif_stop_queue()
      net: fec: remove checking for NULL phy_dev in fec_enet_close()
      net: fec: ensure that a disconnected phy isn't configured
      net: fec: stop the phy before shutting down the MAC
      net: fec: remove useless fep->opened
      net: fec: make rx skb handling more robust
      net: fec: clean up transmit descriptor setup
      net: fec: ensure fec_enet_free_buffers() properly cleans the rings
      net: fec: fix missing kmalloc() failure check in fec_enet_alloc_buffers()
      net: fec: improve safety of suspend/resume/transmit timeout paths
      net: fec: ensure fec_enet_close() copes with resume failure
      net: fec: only restart or stop the device if it is present and running
      net: fec: move calls to quiesce/resume packet processing out of fec_restart()
      net: fec: remove inappropriate calls around fec_restart()
      net: fec: quiesce packet processing before stopping device in fec_suspend()
      net: fec: quiesce packet processing before stopping device in fec_set_features()
      net: fec: quiesce packet processing before changing features
      net: fec: quiesce packet processing when taking link down in fec_enet_adjust_link()
      net: fec: clean up duplex mode handling
      net: fec: better implementation of iMX6 ERR006358 quirk
      net: fec: replace delayed work with standard work
      net: fec: clear receive interrupts before processing a packet
      net: fec: reorder ethtool ops to match order in struct declaration
      net: fec: add support for dumping transmit ring on timeout
      net: fec: remove useless status check in tx reap path
      net: fec: consolidate hwtstamp implementation

Saeed Mahameed (1):
      net/mlx4_core: Remove MCG in case it is attached to promiscuous QPs only

Sasha Levin (1):
      iovec: make sure the caller actually wants anything in memcpy_fromiovecend

Sathya Perla (2):
      be2net: update driver version to 10.4
      be2net: ignore get/set profile FW cmd failures

Serey Kong (1):
      i40evf: Fixed guest OS panic when removing vf driver

Sergei Shtylyov (1):
      sh_eth: remove checks around dev_kfree_skb() calls

Shannon Nelson (16):
      i40e: clear VEB stats when pf stats are cleared
      i40e: keep service tasks out of reset process
      i40e: make prep_for_reset void
      i40e: warn on newer/older firmware API rev
      i40e: fix a stray print message
      i40e: use WoL flag when setting LAA
      i40e: allow user to set LAA again
      i40e: reapply LAA after reset
      i40e: no pf reset at pci remove
      i40e/i40evf: Add base address registers to aq struct
      i40e/i40evf: clear aq bah-bal on shutdown
      i40e: clear all queues and interrupts
      i40e/i40evf: Add nvmupdate support
      i40e: always print aqtx answer
      i40e: expose debug_write_register request
      i40e: disable local loopback on vmdq vsi

Shruti Kanetkar (1):
      net/fsl: Add format length modifier to avoid negative values

Simon Horman (1):
      openvswitch: Sample action without side effects

Simon Wunderlich (2):
      batman-adv: increase default hop penalty
      batman-adv: Start new development cycle

Sonic Zhang (1):
      bfin_mac: convert bfin Ethernet driver to NAPI framework

Sorin Dumitru (1):
      sock: remove skb argument from sk_rcvqueues_full

Stanislaw Gruszka (5):
      rt2x00: change beaconing locking
      rt2x00: change beaconing setup on RT2800
      rt2x00: change default MAC_BSSID_DW1_BSS_BCN_NUM
      rt2x00: change order when stop beaconing
      rt2x00: do not initialize BCN_OFFSET registers

Stefan Raspl (1):
      qeth: Display adjacent switch attributes

Stefan SÃ¸rensen (10):
      dp83640: Program pulsewidth2 values of perout triggers 0 and 1
      dp83640: Increase supported perout pins to 7
      dp83640: Verify calibration pin assignment
      dp83640: Get calibration pin with ptp_find_pin
      ptp: Allow reassigning calibration pin function
      net: Simplify ptp class checks
      ptp: Classify ptp over ip over vlan packets
      vlan: Pass SIOC[SG]HWTSTAMP ioctls to real device
      dp83640: Adjust ptp event timestamps
      dp83640: Fix receive timestamp race condition

Stephan Gabert (1):
      Bluetooth: Remove trailing whitespaces from Kconfig

Sven Eckelmann (1):
      batman-adv: Fix out-of-order fragmentation support

Thomas Gleixner (4):
      mwifiex: Use the proper interfaces
      mac80211: Use ktime_get_ts()
      net: Mac80211: Remove silly timespec dance
      wireless: mwifiex: Use the proper interfaces

Thomas Graf (5):
      net: Remove unlikely() for WARN_ON() conditions
      netfilter: nf_tables: Avoid duplicate call to nft_data_uninit() for same key
      lib: Resizable, Scalable, Concurrent Hash Table
      netlink: Convert netlink_lookup() to use RCU protected hash table
      nftables: Convert nft_hash to use generic rhashtable

Thomas Petazzoni (2):
      net: mvpp2: fix 10 Mbit/s usage
      net: mvpp2: implement ioctl() operation for PHY ioctls

Tobias Klauser (4):
      arc_emac: Use net_device_stats from struct net_device
      arc_emac: Remove unused pointer to net_device from arc_emac_priv
      net: skbuff: Use ALIGN macro instead of open coding it
      netlink: Use PAGE_ALIGNED macro

Todd Fujinaka (2):
      igb: bring link up when PHY is powered up
      igb: bump igb version to 5.2.13

Tom Gundersen (4):
      net: add name_assign_type netdev attribute
      net: set name assign type for renamed devices
      net: set name_assign_type in alloc_netdev()
      net: rtnetlink - make create_link take name_assign_type

Tom Herbert (12):
      flow_dissector: Abstract out hash computation
      net: Save TX flow hash in sock and set in skbuf on xmit
      net: Call skb_get_hash in get_xps_queue and __skb_tx_hash
      udp: Add function to make source port for UDP tunnels
      vxlan: Call udp_flow_src_port
      flow_dissector: Use IPv6 flow label in flow_dissector
      ipv6: Implement automatic flow label generation on transmit
      net: Only do flow_dissector hash computation once per packet
      udp: Add udp_sock_create for UDP tunnels to open listener socket
      vxlan: Call udp_sock_create
      l2tp: Call udp_sock_create
      udp: Move udp_tunnel_segment into udp_offload.c

Tony Camuso (1):
      enic: fix lockdep around devcmd_lock

Toralf FÃ¶rster (1):
      i40e: fix format mismatch in drivers/net/ethernet/intel/i40e/i40e_debugfs.c

Toshiaki Makita (3):
      bridge: Don't include NDA_VLAN for FDB entries with vid 0
      bridge: Update outdated comment on promiscuous mode
      team: Simplify return path of team_newlink

Ujjal Roy (1):
      mwifiex: do not re-associate when already connected

Ursula Braun (1):
      af_iucv: avoid path quiesce of severed path in shutdown()

Varka Bhadram (24):
      mrf24j40: separate h/w init and add checkings
      ieee802154: cc2520: adds driver for TI CC2520 radio
      ieee802154: cc2520: add driver to kernel build system
      devicetree: add device tree bindings for cc2520 driver
      6lowpan: mac802154: fix coding style issues
      net: cpmac: remove space in macro defination
      net: cpmac: fix comments
      net: cpmac: dynamic debug fixes
      net: cpmac: fix cpmac driver structure
      net: cpmac: fix missing a blank line after declarations
      net: cpmac: fix proper spacing before return statement
      net: cpmac: fix in releasing resources
      net: cpmac: fix in debug messages
      ethernet: amd: move amd111e_remove_one after probe
      ethernet: amd: use devm_ioremap()
      ethernet: amd: dynamic debug fixes
      ethernet: amd: fix comment styles
      ethernet: amd: fix pci device ids
      ethernet: amd: fix 'foo* bar'
      netlink: remove bool varible
      ethernet: realtek: use module_pci_driver
      ethernet: realtek: use pci_device_id
      6lowpan: remove unused macros
      6lowpan: remove unused function

Vasu Dev (3):
      i40e: adds FCoE code to the i40e driver
      i40e: Adds FCoE related code to i40e core driver
      i40e: adds FCoE to build and updates its documentation

Vasundhara Volam (8):
      be2net: remove be_cmd_get_profile_config_mbox/mccq() variants
      be2net: read VF's capabilities from GET_PROFILE_CONFIG cmd
      be2net: create optimal number of queues on SR-IOV config
      be2net: update UE bit description strings
      be2net: use be_max_vfs() macro to access max-vfs
      be2net: avoid SRIOV config for BE2 chip
      be2net: use adapter->flags to track SRIOV state
      be2net: ignore VF mac address setting for the same mac

Veaceslav Falico (20):
      bonding: permit enslaving interfaces without set_mac support
      bonding: convert bond_main.c to use netdev_printk instead of pr_
      bonding: remove pr_fmt from bond_main.c
      bonding: convert bond_3ad.c to use netdev_printk instead of pr_
      bonding: remove pr_fmt from bond_3ad.c
      bonding: convert bond_alb.c to use netdev_printk instead of pr_
      bonding: remove pr_fmt from bond_alb.c
      bonding: convert bond_debugfs.c to use netdev_printk instead of pr_
      bonding: convert bond_netlink.c to use netdev_printk instead of pr_
      bonding: bonding: remove pr_fmt from bond_netlink.c
      bonding: convert bond_procfs.c to use netdev_printk instead of pr_
      bonding: convert bond_options.c to use netdev_printk instead of pr_
      bonding: remove pr_fmt from bond_options.c
      bonding: use rtnl_deref in bond_change_rx_flags()
      bonding: destroy proc directory only after all bonds are gone
      bonding: make it possible to have unlimited nested upper vlans
      net: use dev->name in netdev_pr* when it's available
      net: print net_device reg_state in netdev_* unless it's registered
      net: print a notification on device rename
      bonding: use kobject_put instead of _del after kobject_add

Vignesh Raman (1):
      Bluetooth: Avoid use of session socket after the session gets freed

Vince Bridgers (9):
      net: stmmac: add platform init/exit for Altera's ARM socfpga
      net: libphy: Add phy specific function to access mmd phy registers
      net: libphy: Add stubs to hook IEEE MMD Register reads and writes
      Documentation: networking: phy.txt: Update text for indirect MMD access
      net: stmmac: Change MAC interface to support multiple filter configurations
      net: stmmac: Correct set_filter for multicast and unicast cases
      dts: Add bindings for multicast hash bins and perfect filter entries
      ARM: socfpga: Add socfpga Ethernet filter attributes entries
      net: stmmac: Support devicetree configs for mcast and ucast filter entries

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().

Vladimir Davydov (1):
      Bluetooth: never linger on process exit

Vladimir Kondratiev (33):
      wil6210: Tx mgmt frame from debugfs
      wil6210: indicate mgmt_tx status
      wil6210: print debug info when starting AP
      wil6210: trace wil->status on debugfs
      wil6210: print more info about BSS found
      wil6210: more debug info for vring
      wil6210: Tx performance monitoring
      wil6210: Allow driver load if FW not ready
      wil6210: BACK: track last dropped SSN
      wil6210: debugfs interface to send raw WMI command
      wil6210: writeable ITR registers
      wil6210: print error when notifying about FW error
      wil6210: debug print when scan request state changes
      wil6210: Use "name = value" format in the debugfs
      wil6210: add 'freq' and 'link' debugfs entries
      wil6210: Debug print GRO Rx result
      wil6210: avoid dmesg pollution by Tx errors
      wil6210: fix disconnect handling for AP
      wil6210: remove unused #include
      wil6210: map additional registers on target
      wil6210: fix for unreachable code in wmi_recv_cmd
      wil6210: work around for platforms with broken INTx
      wil6210: add 'info' debugfs entry
      wil6210: interrupt statistics
      wil6210: track Tx queue state
      wil6210: fix for 64-bit integer division
      wil6210: support for "sparrow" hardware
      wil6210: export FW/HW versions through debugfs
      wil6210: fix double definition of 'ctx'
      wil6210: fix memory leak on error path in wil_write_file_rxon()
      wil6210: use same mapping table for FW addr translation and debugfs
      wil6210: map RGF_USER_USAGE_1 on the debugfs
      wil6210: add new register region for AGC table

WANG Cong (5):
      veth: add netpoll support
      net: do not name the pointer to struct net_device net
      ipv4: fail early when creating netdev named all or default
      ipv6: fail early when creating netdev named all or default
      vlan: fail early when creating netdev named config

Wei Yongjun (4):
      tipc: fix sparse non static symbol warnings
      net: mvpp2: Remove redundant dev_err call in mvpp2_port_probe()
      net: mvpp2: Fix error return code in mvpp2_probe()
      tipc: remove duplicated include from socket.c

Willem de Bruijn (12):
      net-timestamp: SOCK_RAW and PING timestamping
      net-timestamp: document deprecated syststamp
      octeon: remove deprecated syststamp timestamp
      vxge: remove deprecated syststamp timestamp
      packet: remove deprecated syststamp timestamp
      net: remove deprecated syststamp timestamp
      net-timestamp: extend SCM_TIMESTAMPING ancillary data struct
      net-timestamp: move timestamp flags out of sk_flags
      net-timestamp: add key to disambiguate concurrent datagrams
      net-timestamp: SCHED timestamp on entering packet scheduler
      net-timestamp: TCP timestamping
      net-timestamp: ACK timestamp for bytestreams

Xinming Hu (2):
      mwifiex: add hscfg to debugfs
      mwifiex: update Copyright to 2014

Xose Vazquez Perez (2):
      wireless: rt2x00: add new rt2800usb devices
      wireless: zd1211rw: new url for fw, remove experimental

Yannick Brosseau (1):
      ipvs: Remove dead debug code

Yevgeny Petrilin (1):
      net/mlx4_core: Fix leakage of SW multicast entries

Ying Xue (1):
      net: fix some typos in comment

Yishai Hadas (1):
      net/mlx4_en: Do not count LLC/SNAP in MTU calculation

Yuval Mintz (1):
      bnx2x: Fail probe of VFs using an old incompatible driver

Zhiyuan Yang (1):
      mwifiex: support wowlan magic-packet encapsulated as UDP packet

Zi Shen Lim (1):
      net: filter: move load_pointer() into filter.h

Zoltan Kiss (3):
      xen-netback: Adding debugfs "io_ring_qX" files
      xen-netback: Using a new state bit instead of carrier
      xen-netback: Turn off the carrier if the guest is not able to receive

david decotigny (1):
      netpoll: fix use after free

franÃ§ois romieu (1):
      net: remove open-coded skb_cow_head.

hayeswang (5):
      r8152: increase the tx timeout
      r8152: support jumbo frame for RTL8153
      r8169: split rtl8169_tso_csum
      r8169: use Giant Send
      r8169: support IPv6

stephen hemminger (1):
      openvswitch: make generic netlink group const

wangweidong (1):
      appletalk: fix a coccinella warning in net/appletalk/ddp.c

 Documentation/ABI/testing/sysfs-class-net                            |   11 +
 Documentation/devicetree/bindings/net/amd-xgbe-phy.txt               |    6 +
 Documentation/devicetree/bindings/net/amd-xgbe.txt                   |   17 +-
 Documentation/devicetree/bindings/net/broadcom-systemport.txt        |    3 +-
 Documentation/devicetree/bindings/net/davinci-mdio.txt               |    8 +-
 Documentation/devicetree/bindings/net/ieee802154/cc2520.txt          |   29 +
 Documentation/devicetree/bindings/net/marvell-pp2.txt                |   61 +
 Documentation/devicetree/bindings/net/nfc/st21nfcb.txt               |   33 +
 Documentation/devicetree/bindings/net/sh_eth.txt                     |    1 +
 Documentation/devicetree/bindings/net/stmmac.txt                     |    6 +
 Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt |   41 +
 Documentation/networking/bonding.txt                                 |   31 +-
 Documentation/networking/filter.txt                                  |   12 +-
 Documentation/networking/i40e.txt                                    |    7 +-
 Documentation/networking/ip-sysctl.txt                               |   38 +-
 Documentation/networking/packet_mmap.txt                             |   18 +-
 Documentation/networking/phy.txt                                     |   18 +-
 Documentation/networking/pktgen.txt                                  |   28 +
 Documentation/networking/timestamping.txt                            |   16 +-
 Documentation/networking/timestamping/timestamping.c                 |    7 +-
 MAINTAINERS                                                          |   33 +-
 arch/arm/boot/dts/sama5d3_gmac.dtsi                                  |    2 +-
 arch/arm/boot/dts/socfpga.dtsi                                       |    4 +
 arch/arm/net/bpf_jit_32.c                                            |    8 +-
 arch/mips/net/bpf_jit.c                                              |    8 +-
 arch/powerpc/net/bpf_jit_comp.c                                      |    8 +-
 arch/s390/net/bpf_jit_comp.c                                         |    4 +-
 arch/sparc/net/bpf_jit_comp.c                                        |    4 +-
 arch/x86/net/bpf_jit_comp.c                                          |   16 +-
 drivers/atm/eni.c                                                    |    4 +-
 drivers/bcma/Makefile                                                |    1 +
 drivers/bcma/driver_chipcommon_pmu.c                                 |    2 +
 drivers/bcma/driver_gpio.c                                           |    1 +
 drivers/bcma/driver_pcie2.c                                          |  175 ++
 drivers/bcma/host_pci.c                                              |    2 +
 drivers/bcma/main.c                                                  |    8 +
 drivers/bcma/scan.c                                                  |   22 +-
 drivers/bcma/sprom.c                                                 |   43 +-
 drivers/bluetooth/Kconfig                                            |   12 +-
 drivers/bluetooth/ath3k.c                                            |   35 +-
 drivers/bluetooth/btmrvl_drv.h                                       |    4 +
 drivers/bluetooth/btmrvl_main.c                                      |   73 +-
 drivers/bluetooth/btmrvl_sdio.c                                      |   21 +-
 drivers/bluetooth/btmrvl_sdio.h                                      |    2 +
 drivers/bluetooth/btusb.c                                            |  221 +-
 drivers/bluetooth/hci_h5.c                                           |    4 -
 drivers/bluetooth/hci_ldisc.c                                        |   25 +-
 drivers/bluetooth/hci_uart.h                                         |    1 +
 drivers/bluetooth/hci_vhci.c                                         |   34 +-
 drivers/firewire/net.c                                               |    3 +-
 drivers/hsi/clients/ssi_protocol.c                                   |    2 +-
 drivers/infiniband/hw/amso1100/c2_provider.c                         |    2 +-
 drivers/infiniband/hw/cxgb4/cm.c                                     |  112 +-
 drivers/infiniband/hw/cxgb4/cq.c                                     |   14 +-
 drivers/infiniband/hw/cxgb4/device.c                                 |  192 +-
 drivers/infiniband/hw/cxgb4/ev.c                                     |   55 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h                               |   40 +-
 drivers/infiniband/hw/cxgb4/provider.c                               |   14 +-
 drivers/infiniband/hw/cxgb4/qp.c                                     |  113 +-
 drivers/infiniband/hw/cxgb4/t4.h                                     |   19 +-
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h                            |    1 -
 drivers/infiniband/hw/mlx5/cq.c                                      |   48 +-
 drivers/infiniband/hw/mlx5/mad.c                                     |    6 +-
 drivers/infiniband/hw/mlx5/main.c                                    |  295 +-
 drivers/infiniband/hw/mlx5/mem.c                                     |    2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h                                 |   14 +-
 drivers/infiniband/hw/mlx5/mr.c                                      |   48 +-
 drivers/infiniband/hw/mlx5/qp.c                                      |   88 +-
 drivers/infiniband/hw/mlx5/srq.c                                     |   26 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c                            |    4 +-
 drivers/isdn/capi/capi.c                                             |    2 +-
 drivers/isdn/i4l/isdn_net.c                                          |    7 +-
 drivers/isdn/i4l/isdn_ppp.c                                          |   26 +-
 drivers/isdn/pcbit/drv.c                                             |    4 +-
 drivers/media/dvb-core/dvb_net.c                                     |    3 +-
 drivers/misc/sgi-xp/xpnet.c                                          |    3 +-
 drivers/net/Kconfig                                                  |    1 +
 drivers/net/Makefile                                                 |   10 +-
 drivers/net/arcnet/arcnet.c                                          |    3 +-
 drivers/net/bonding/bond_3ad.c                                       |  185 +-
 drivers/net/bonding/bond_alb.c                                       |  146 +-
 drivers/net/bonding/bond_alb.h                                       |    8 +
 drivers/net/bonding/bond_debugfs.c                                   |    6 +-
 drivers/net/bonding/bond_main.c                                      |  535 ++--
 drivers/net/bonding/bond_netlink.c                                   |   32 +-
 drivers/net/bonding/bond_options.c                                   |  228 +-
 drivers/net/bonding/bond_procfs.c                                    |    4 +-
 drivers/net/bonding/bond_sysfs.c                                     |    3 +-
 drivers/net/bonding/bond_sysfs_slave.c                               |    4 +-
 drivers/net/bonding/bonding.h                                        |   22 +-
 drivers/net/caif/caif_serial.c                                       |    3 +-
 drivers/net/caif/caif_spi.c                                          |    4 +-
 drivers/net/caif/caif_virtio.c                                       |    2 +-
 drivers/net/can/c_can/c_can_platform.c                               |   43 +-
 drivers/net/can/dev.c                                                |    2 +-
 drivers/net/can/sja1000/sja1000.c                                    |   27 +-
 drivers/net/can/slcan.c                                              |    2 +-
 drivers/net/cris/eth_v10.c                                           |    1 -
 drivers/net/dummy.c                                                  |    2 +-
 drivers/net/eql.c                                                    |    3 +-
 drivers/net/ethernet/8390/lib8390.c                                  |    2 +-
 drivers/net/ethernet/8390/mac8390.c                                  |    8 -
 drivers/net/ethernet/adi/Kconfig                                     |    3 +-
 drivers/net/ethernet/adi/bfin_mac.c                                  |   79 +-
 drivers/net/ethernet/adi/bfin_mac.h                                  |    3 +
 drivers/net/ethernet/allwinner/sun4i-emac.c                          |    6 +-
 drivers/net/ethernet/amd/Kconfig                                     |   13 +
 drivers/net/ethernet/amd/amd8111e.c                                  |  363 ++-
 drivers/net/ethernet/amd/declance.c                                  |   12 +-
 drivers/net/ethernet/amd/xgbe/Makefile                               |    4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h                          |  121 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dcb.c                             |  270 ++
 drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c                         |    7 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c                            |   32 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c                             |  780 +++--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                             |  728 ++++-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c                         |   74 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                            |   66 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                            |  107 -
 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c                             |  285 ++
 drivers/net/ethernet/amd/xgbe/xgbe.h                                 |  151 +-
 drivers/net/ethernet/arc/emac.h                                      |    4 -
 drivers/net/ethernet/arc/emac_main.c                                 |   11 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c                        |    2 -
 drivers/net/ethernet/atheros/atl1e/atl1e_hw.c                        |    1 -
 drivers/net/ethernet/atheros/atlx/atl1.c                             |    1 -
 drivers/net/ethernet/atheros/atlx/atl2.c                             |    3 -
 drivers/net/ethernet/broadcom/Kconfig                                |    8 +-
 drivers/net/ethernet/broadcom/bcmsysport.c                           |  489 ++-
 drivers/net/ethernet/broadcom/bcmsysport.h                           |   14 +-
 drivers/net/ethernet/broadcom/bnx2.c                                 |    9 +-
 drivers/net/ethernet/broadcom/bnx2.h                                 |    5 +-
 drivers/net/ethernet/broadcom/bnx2_fw.h                              |    3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                          |    9 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                      |   55 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c                      |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c                  |   44 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                     |    9 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c                    |  264 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h                    |   35 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c                     |   78 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h                     |   23 +-
 drivers/net/ethernet/broadcom/cnic.c                                 |   10 +-
 drivers/net/ethernet/broadcom/cnic.h                                 |    3 +-
 drivers/net/ethernet/broadcom/cnic_defs.h                            |    3 +-
 drivers/net/ethernet/broadcom/cnic_if.h                              |    3 +-
 drivers/net/ethernet/broadcom/genet/Makefile                         |    2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                       |  573 ++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h                       |   30 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c                   |  206 ++
 drivers/net/ethernet/broadcom/genet/bcmmii.c                         |   44 +-
 drivers/net/ethernet/broadcom/tg3.c                                  |   22 +-
 drivers/net/ethernet/brocade/bna/bnad.c                              |    2 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c                      |    6 +-
 drivers/net/ethernet/brocade/bna/cna_fwimg.c                         |    4 -
 drivers/net/ethernet/cadence/macb.c                                  |  419 ++-
 drivers/net/ethernet/cadence/macb.h                                  |   53 +-
 drivers/net/ethernet/chelsio/Kconfig                                 |   11 +
 drivers/net/ethernet/chelsio/cxgb4/Makefile                          |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                           |   37 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c                       |  971 ++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h                       |  141 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                      |  487 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h                       |   14 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                             |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.h                             |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                             |   37 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                           |  364 ++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h                           |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h                          |    7 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h                         |   17 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h                        |   99 +-
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                  |   38 +-
 drivers/net/ethernet/cirrus/cs89x0.c                                 |   32 +-
 drivers/net/ethernet/cisco/enic/Makefile                             |    2 +-
 drivers/net/ethernet/cisco/enic/enic.h                               |   40 +-
 drivers/net/ethernet/cisco/enic/enic_api.c                           |    4 +-
 drivers/net/ethernet/cisco/enic/enic_clsf.c                          |  284 ++
 drivers/net/ethernet/cisco/enic/enic_clsf.h                          |   37 +
 drivers/net/ethernet/cisco/enic/enic_dev.c                           |   80 +-
 drivers/net/ethernet/cisco/enic/enic_dev.h                           |    4 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c                       |  125 +-
 drivers/net/ethernet/cisco/enic/enic_main.c                          |  245 +-
 drivers/net/ethernet/cisco/enic/enic_res.c                           |    1 +
 drivers/net/ethernet/cisco/enic/vnic_dev.c                           |   65 +-
 drivers/net/ethernet/cisco/enic/vnic_dev.h                           |    2 +
 drivers/net/ethernet/cisco/enic/vnic_devcmd.h                        |    5 +
 drivers/net/ethernet/cisco/enic/vnic_enet.h                          |    2 +
 drivers/net/ethernet/cisco/enic/vnic_rq.h                            |  122 +
 drivers/net/ethernet/davicom/dm9000.c                                |    6 +-
 drivers/net/ethernet/dec/tulip/de4x5.c                               |    1 -
 drivers/net/ethernet/dnet.c                                          |   46 +-
 drivers/net/ethernet/emulex/benet/be.h                               |   17 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                          |  297 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h                          |   54 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c                       |   29 +-
 drivers/net/ethernet/emulex/benet/be_main.c                          |  270 +-
 drivers/net/ethernet/freescale/fec.h                                 |   10 +-
 drivers/net/ethernet/freescale/fec_main.c                            |  381 +--
 drivers/net/ethernet/freescale/ucc_geth.c                            |    2 -
 drivers/net/ethernet/freescale/xgmac_mdio.c                          |    4 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c                     |    3 -
 drivers/net/ethernet/intel/e1000/e1000_hw.c                          |    2 -
 drivers/net/ethernet/intel/e1000e/82571.c                            |    4 -
 drivers/net/ethernet/intel/e1000e/defines.h                          |    1 +
 drivers/net/ethernet/intel/e1000e/ethtool.c                          |    2 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c                          |   21 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h                          |    4 +
 drivers/net/ethernet/intel/e1000e/mac.c                              |    1 -
 drivers/net/ethernet/intel/e1000e/manage.c                           |    5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                           |   55 +-
 drivers/net/ethernet/intel/e1000e/nvm.c                              |    4 +-
 drivers/net/ethernet/intel/i40e/Makefile                             |    1 +
 drivers/net/ethernet/intel/i40e/i40e.h                               |   72 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c                        |  132 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.h                        |   39 +
 drivers/net/ethernet/intel/i40e/i40e_common.c                        |  482 ++-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c                       |   29 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                       |  549 +++-
 drivers/net/ethernet/intel/i40e/i40e_fcoe.c                          | 1561 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_fcoe.h                          |  128 +
 drivers/net/ethernet/intel/i40e/i40e_hmc.h                           |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c                       |  249 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h                       |   28 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c                          |  753 ++++-
 drivers/net/ethernet/intel/i40e/i40e_nvm.c                           |  520 +++-
 drivers/net/ethernet/intel/i40e/i40e_osdep.h                         |    3 +
 drivers/net/ethernet/intel/i40e/i40e_prototype.h                     |   31 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c                           |  135 +-
 drivers/net/ethernet/intel/i40e/i40e_register.h                      | 5011 ++++++++++++-------------------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                          |  190 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h                          |   16 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h                          |  213 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                   |   40 +-
 drivers/net/ethernet/intel/i40evf/i40e_adminq.c                      |  119 +-
 drivers/net/ethernet/intel/i40evf/i40e_adminq.h                      |   39 +
 drivers/net/ethernet/intel/i40evf/i40e_common.c                      |    2 +-
 drivers/net/ethernet/intel/i40evf/i40e_hmc.h                         |    4 +-
 drivers/net/ethernet/intel/i40evf/i40e_lan_hmc.h                     |   28 +-
 drivers/net/ethernet/intel/i40evf/i40e_register.h                    | 5011 ++++++++++++-------------------
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c                        |    9 +-
 drivers/net/ethernet/intel/i40evf/i40e_txrx.h                        |    7 +-
 drivers/net/ethernet/intel/i40evf/i40e_type.h                        |   74 +-
 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c                   |    6 +-
 drivers/net/ethernet/intel/i40evf/i40evf_main.c                      |   86 +-
 drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c                  |   44 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                         |    2 -
 drivers/net/ethernet/intel/igb/e1000_regs.h                          |    1 +
 drivers/net/ethernet/intel/igb/igb_main.c                            |   31 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c                       |  213 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c                       |  315 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                      |  580 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.c                         |   39 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c                      |   46 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c                     |    2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c                        |   24 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                        |   74 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.c                         |  117 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                         |  582 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                         |   16 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                       |   31 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                        |   20 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c                        |  216 +-
 drivers/net/ethernet/intel/ixgbevf/vf.h                              |    1 -
 drivers/net/ethernet/marvell/Kconfig                                 |    8 +
 drivers/net/ethernet/marvell/Makefile                                |    1 +
 drivers/net/ethernet/marvell/mvpp2.c                                 | 6426 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                      |   57 +
 drivers/net/ethernet/mellanox/mlx4/en_main.c                         |    6 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                       |   35 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                           |    7 +-
 drivers/net/ethernet/mellanox/mlx4/en_selftest.c                     |    3 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                           |   13 +-
 drivers/net/ethernet/mellanox/mlx4/main.c                            |   28 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                             |  279 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                            |    5 -
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                         |   10 +-
 drivers/net/ethernet/mellanox/mlx4/port.c                            |   32 +-
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c                      |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                        |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                         |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/mad.c                        |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c                       |  292 +-
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                  |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c                       |    2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c                             |   59 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c                       |    1 -
 drivers/net/ethernet/octeon/octeon_mgmt.c                            |   25 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                          |    4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c                      |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c                      |    4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c                  |   18 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                     |   58 +-
 drivers/net/ethernet/realtek/8139cp.c                                |   36 +-
 drivers/net/ethernet/realtek/r8169.c                                 |  220 +-
 drivers/net/ethernet/renesas/sh_eth.c                                |   20 +-
 drivers/net/ethernet/sfc/ef10.c                                      |   14 +-
 drivers/net/ethernet/sfc/efx.c                                       |   67 +-
 drivers/net/ethernet/sfc/efx.h                                       |    5 +
 drivers/net/ethernet/sfc/ethtool.c                                   |   59 +-
 drivers/net/ethernet/sfc/falcon.c                                    |    9 +-
 drivers/net/ethernet/sfc/mcdi_port.c                                 |   11 +
 drivers/net/ethernet/sfc/net_driver.h                                |  154 +
 drivers/net/ethernet/sfc/nic.h                                       |   13 +-
 drivers/net/ethernet/sfc/rx.c                                        |   12 +-
 drivers/net/ethernet/sfc/selftest.c                                  |    5 +-
 drivers/net/ethernet/sfc/siena.c                                     |    9 +-
 drivers/net/ethernet/sfc/tx.c                                        |   28 +-
 drivers/net/ethernet/sis/sis900.c                                    |    1 -
 drivers/net/ethernet/smsc/smc911x.c                                  |    2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h                         |   47 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c                  |   69 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h                      |    3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c                 |  131 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c                  |   27 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c                 |    6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                    |   42 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c                |   67 +
 drivers/net/ethernet/sun/niu.c                                       |    1 -
 drivers/net/ethernet/ti/Kconfig                                      |    4 +-
 drivers/net/ethernet/ti/cpmac.c                                      |  279 +-
 drivers/net/ethernet/ti/cpsw.c                                       |   45 +-
 drivers/net/ethernet/ti/cpsw_ale.c                                   |   12 +-
 drivers/net/ethernet/ti/cpsw_ale.h                                   |    4 +
 drivers/net/ethernet/ti/cpts.c                                       |   24 +-
 drivers/net/ethernet/ti/davinci_mdio.c                               |   21 +-
 drivers/net/ethernet/ti/tlan.c                                       |  224 +-
 drivers/net/ethernet/ti/tlan.h                                       |    5 +-
 drivers/net/ethernet/tile/tilegx.c                                   |    4 +-
 drivers/net/ethernet/tile/tilepro.c                                  |    3 +-
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c                    |   10 -
 drivers/net/ethernet/xilinx/ll_temac_main.c                          |    2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c                    |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                        |    2 +-
 drivers/net/fddi/defxx.c                                             |  142 +-
 drivers/net/fddi/defxx.h                                             |    2 +-
 drivers/net/hamradio/6pack.c                                         |    3 +-
 drivers/net/hamradio/baycom_epp.c                                    |    2 +-
 drivers/net/hamradio/bpqether.c                                      |    4 +-
 drivers/net/hamradio/dmascc.c                                        |    4 +-
 drivers/net/hamradio/hdlcdrv.c                                       |    2 +-
 drivers/net/hamradio/mkiss.c                                         |    3 +-
 drivers/net/hamradio/scc.c                                           |    2 +-
 drivers/net/hamradio/yam.c                                           |    2 +-
 drivers/net/hyperv/hyperv_net.h                                      |    5 +-
 drivers/net/hyperv/netvsc.c                                          |   11 +-
 drivers/net/hyperv/netvsc_drv.c                                      |   41 +-
 drivers/net/hyperv/rndis_filter.c                                    |   21 +-
 drivers/net/ieee802154/Kconfig                                       |   12 +
 drivers/net/ieee802154/Makefile                                      |    1 +
 drivers/net/ieee802154/at86rf230.c                                   | 1464 +++++----
 drivers/net/ieee802154/cc2520.c                                      | 1039 +++++++
 drivers/net/ieee802154/fakehard.c                                    |    3 +-
 drivers/net/ieee802154/mrf24j40.c                                    |  115 +-
 drivers/net/ifb.c                                                    |    4 +-
 drivers/net/irda/kingsun-sir.c                                       |    4 +-
 drivers/net/loopback.c                                               |    2 +-
 drivers/net/macvlan.c                                                |    1 +
 drivers/net/phy/amd-xgbe-phy.c                                       |  136 +-
 drivers/net/phy/dp83640.c                                            |  239 +-
 drivers/net/phy/mdio_bus.c                                           |    1 -
 drivers/net/phy/micrel.c                                             |   22 +
 drivers/net/phy/phy.c                                                |   83 +-
 drivers/net/phy/phy_device.c                                         |    2 +
 drivers/net/phy/spi_ks8995.c                                         |   26 +-
 drivers/net/ppp/ppp_generic.c                                        |   35 +-
 drivers/net/slip/slhc.c                                              |    1 -
 drivers/net/slip/slip.c                                              |    2 +-
 drivers/net/team/team.c                                              |    8 +-
 drivers/net/team/team_mode_loadbalance.c                             |   18 +-
 drivers/net/tun.c                                                    |    3 +-
 drivers/net/usb/Kconfig                                              |   13 +-
 drivers/net/usb/ax88179_178a.c                                       |  264 ++
 drivers/net/usb/cdc-phonet.c                                         |    2 +-
 drivers/net/usb/cdc_subset.c                                         |   27 +-
 drivers/net/usb/hso.c                                                |    4 +-
 drivers/net/usb/r8152.c                                              |   38 +-
 drivers/net/usb/usbnet.c                                             |    8 +-
 drivers/net/veth.c                                                   |   29 +-
 drivers/net/virtio_net.c                                             |   67 +-
 drivers/net/vxlan.c                                                  |  144 +-
 drivers/net/wan/dlci.c                                               |    5 +-
 drivers/net/wan/hdlc.c                                               |    3 +-
 drivers/net/wan/hdlc_fr.c                                            |    5 +-
 drivers/net/wan/lapbether.c                                          |    4 +-
 drivers/net/wan/sbni.c                                               |    7 +-
 drivers/net/wan/sdla.c                                               |    3 +-
 drivers/net/wan/x25_asy.c                                            |    4 +-
 drivers/net/wimax/i2400m/usb.c                                       |    2 +-
 drivers/net/wireless/airo.c                                          |    6 +-
 drivers/net/wireless/at76c50x-usb.c                                  |    3 +-
 drivers/net/wireless/ath/ath.h                                       |    1 +
 drivers/net/wireless/ath/ath10k/ce.c                                 |   11 +-
 drivers/net/wireless/ath/ath10k/core.c                               |   12 +-
 drivers/net/wireless/ath/ath10k/core.h                               |    3 +
 drivers/net/wireless/ath/ath10k/debug.c                              |   73 +
 drivers/net/wireless/ath/ath10k/htc.c                                |   20 +-
 drivers/net/wireless/ath/ath10k/htt.h                                |   13 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c                             |  122 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c                             |   52 +
 drivers/net/wireless/ath/ath10k/mac.c                                |   99 +-
 drivers/net/wireless/ath/ath10k/mac.h                                |    4 +-
 drivers/net/wireless/ath/ath10k/pci.c                                |   28 +-
 drivers/net/wireless/ath/ath10k/pci.h                                |    3 +-
 drivers/net/wireless/ath/ath10k/txrx.c                               |    3 +-
 drivers/net/wireless/ath/ath10k/txrx.h                               |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c                                |    8 +-
 drivers/net/wireless/ath/ath5k/ath5k.h                               |    1 +
 drivers/net/wireless/ath/ath5k/base.c                                |   31 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c                        |    2 +
 drivers/net/wireless/ath/ath6kl/bmi.h                                |    3 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                           |    8 +-
 drivers/net/wireless/ath/ath6kl/core.c                               |   16 +
 drivers/net/wireless/ath/ath6kl/core.h                               |   36 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c                           |   32 +-
 drivers/net/wireless/ath/ath6kl/init.c                               |   91 +-
 drivers/net/wireless/ath/ath6kl/main.c                               |   17 +-
 drivers/net/wireless/ath/ath6kl/usb.c                                |    7 +-
 drivers/net/wireless/ath/ath6kl/wmi.c                                |   72 +-
 drivers/net/wireless/ath/ath6kl/wmi.h                                |    2 +-
 drivers/net/wireless/ath/ath9k/Makefile                              |    3 +-
 drivers/net/wireless/ath/ath9k/ahb.c                                 |    1 +
 drivers/net/wireless/ath/ath9k/ar9002_mac.c                          |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                       |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                           |   15 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c                          |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                          |    6 +-
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h                     |  201 +-
 drivers/net/wireless/ath/ath9k/ath9k.h                               |  162 +-
 drivers/net/wireless/ath/ath9k/beacon.c                              |   97 +-
 drivers/net/wireless/ath/ath9k/channel.c                             |  685 +++++
 drivers/net/wireless/ath/ath9k/common-beacon.c                       |    5 +-
 drivers/net/wireless/ath/ath9k/debug.c                               |   30 +-
 drivers/net/wireless/ath/ath9k/hw.c                                  |   26 +-
 drivers/net/wireless/ath/ath9k/hw.h                                  |    1 +
 drivers/net/wireless/ath/ath9k/init.c                                |   57 +-
 drivers/net/wireless/ath/ath9k/link.c                                |    6 +-
 drivers/net/wireless/ath/ath9k/mac.h                                 |   10 +-
 drivers/net/wireless/ath/ath9k/main.c                                |  892 ++++--
 drivers/net/wireless/ath/ath9k/mci.c                                 |    4 +-
 drivers/net/wireless/ath/ath9k/pci.c                                 |    1 +
 drivers/net/wireless/ath/ath9k/recv.c                                |   16 +-
 drivers/net/wireless/ath/ath9k/reg.h                                 |    4 +
 drivers/net/wireless/ath/ath9k/spectral.c                            |    8 +-
 drivers/net/wireless/ath/ath9k/tx99.c                                |    2 +-
 drivers/net/wireless/ath/ath9k/wow.c                                 |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c                                |  135 +-
 drivers/net/wireless/ath/carl9170/phy.c                              |    1 -
 drivers/net/wireless/ath/wcn36xx/main.c                              |    1 -
 drivers/net/wireless/ath/wil6210/cfg80211.c                          |   68 +-
 drivers/net/wireless/ath/wil6210/debugfs.c                           |  361 ++-
 drivers/net/wireless/ath/wil6210/interrupt.c                         |    3 +
 drivers/net/wireless/ath/wil6210/main.c                              |   64 +-
 drivers/net/wireless/ath/wil6210/netdev.c                            |    2 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c                          |   53 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c                        |    1 +
 drivers/net/wireless/ath/wil6210/txrx.c                              |   39 +-
 drivers/net/wireless/ath/wil6210/wil6210.h                           |   36 +-
 drivers/net/wireless/ath/wil6210/wmi.c                               |   59 +-
 drivers/net/wireless/b43/Kconfig                                     |   31 +-
 drivers/net/wireless/b43/Makefile                                    |    6 +-
 drivers/net/wireless/b43/main.c                                      |  459 +--
 drivers/net/wireless/b43/main.h                                      |    1 +
 drivers/net/wireless/b43/phy_a.c                                     |    2 +-
 drivers/net/wireless/b43/phy_a.h                                     |    4 -
 drivers/net/wireless/b43/phy_common.c                                |   26 +-
 drivers/net/wireless/b43/phy_common.h                                |   12 +-
 drivers/net/wireless/b43/phy_ht.c                                    |    2 +-
 drivers/net/wireless/b43/phy_lcn.c                                   |   35 +-
 drivers/net/wireless/b43/phy_n.c                                     | 1461 +++++++--
 drivers/net/wireless/b43/phy_n.h                                     |   15 +
 drivers/net/wireless/b43/radio_2057.c                                |  540 +++-
 drivers/net/wireless/b43/radio_2057.h                                |   76 +
 drivers/net/wireless/b43/tables_nphy.c                               |  626 +++-
 drivers/net/wireless/b43/tables_nphy.h                               |    4 +
 drivers/net/wireless/b43/xmit.c                                      |    7 +-
 drivers/net/wireless/brcm80211/Kconfig                               |   10 +
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                     |   11 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c                       |   20 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c                     |   43 +-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c                     |   38 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c                       |   36 +-
 drivers/net/wireless/brcm80211/brcmfmac/commonring.c                 |  273 ++
 drivers/net/wireless/brcm80211/brcmfmac/commonring.h                 |   69 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                        |   22 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h                    |   33 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c                 |    7 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c                    |  196 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h                    |  110 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c                  |   25 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c                   |  283 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c                    |  136 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h                    |   86 +
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c                   |    5 +
 drivers/net/wireless/brcm80211/brcmfmac/firmware.h                   |    5 +
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c                   |  501 ++++
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h                   |   84 +
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c                       |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h                       |    5 +
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c                       |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c                   |  100 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c                     | 1397 +++++++++
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h                     |   40 +
 drivers/net/wireless/brcm80211/brcmfmac/of.c                         |   56 +
 drivers/net/wireless/brcm80211/brcmfmac/of.h                         |   22 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                        |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c                       | 1846 ++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/pcie.h                       |   29 +
 drivers/net/wireless/brcm80211/brcmfmac/proto.c                      |   29 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.h                      |   31 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h                  |   16 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                        |  251 +-
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c                     |  115 +
 drivers/net/wireless/brcm80211/brcmfmac/vendor.h                     |   64 +
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c                | 1176 ++++----
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h                |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c                       |   37 -
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c                |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c                  |    1 -
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h                 |   71 +-
 drivers/net/wireless/cw1200/fwio.c                                   |    1 -
 drivers/net/wireless/cw1200/scan.c                                   |    3 +-
 drivers/net/wireless/cw1200/scan.h                                   |    2 +-
 drivers/net/wireless/cw1200/sta.c                                    |    3 +-
 drivers/net/wireless/ipw2x00/libipw_module.c                         |    3 +-
 drivers/net/wireless/iwlegacy/common.c                               |    6 +-
 drivers/net/wireless/iwlegacy/common.h                               |    2 +-
 drivers/net/wireless/iwlwifi/Kconfig                                 |   25 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                          |    3 +-
 drivers/net/wireless/iwlwifi/dvm/power.c                             |    9 +
 drivers/net/wireless/iwlwifi/iwl-8000.c                              |    9 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                               |   15 +
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c                      |    1 -
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h                     |   67 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h                           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h                                |   12 +
 drivers/net/wireless/iwlwifi/iwl-modparams.h                         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                         |   99 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h                              |    6 +
 drivers/net/wireless/iwlwifi/iwl-trans.h                             |   21 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile                            |    2 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c                              |  513 ++--
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c                       | 1257 ++++++++
 drivers/net/wireless/iwlwifi/mvm/constants.h                         |    2 +
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                           |  324 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h                       |  222 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h                      |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h                       |  256 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h                        |    7 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                         |   30 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                            |   78 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                          |  111 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                          |  792 ++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h                               |  150 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c                               |   35 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c                               |  128 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                          |   26 +
 drivers/net/wireless/iwlwifi/mvm/power.c                             |   39 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c                             |   38 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c                                |   96 +-
 drivers/net/wireless/iwlwifi/mvm/rs.h                                |   19 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c                                |   17 +
 drivers/net/wireless/iwlwifi/mvm/scan.c                              |  540 +++-
 drivers/net/wireless/iwlwifi/mvm/sta.c                               |   98 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h                               |   12 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c                        |  162 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h                        |   29 +
 drivers/net/wireless/iwlwifi/mvm/tt.c                                |   12 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c                                |   35 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c                             |   65 -
 drivers/net/wireless/iwlwifi/pcie/internal.h                         |    7 +
 drivers/net/wireless/iwlwifi/pcie/trans.c                            |  339 ++-
 drivers/net/wireless/iwlwifi/pcie/tx.c                               |    1 +
 drivers/net/wireless/libertas/Kconfig                                |    2 +-
 drivers/net/wireless/libertas/cmd.c                                  |    1 +
 drivers/net/wireless/libertas/main.c                                 |    2 +-
 drivers/net/wireless/libertas/mesh.c                                 |    2 +-
 drivers/net/wireless/mac80211_hwsim.c                                |   83 +-
 drivers/net/wireless/mwifiex/11ac.c                                  |    2 +-
 drivers/net/wireless/mwifiex/11ac.h                                  |    2 +-
 drivers/net/wireless/mwifiex/11h.c                                   |    2 +-
 drivers/net/wireless/mwifiex/11n.c                                   |    5 +-
 drivers/net/wireless/mwifiex/11n.h                                   |    2 +-
 drivers/net/wireless/mwifiex/11n_aggr.c                              |    2 +-
 drivers/net/wireless/mwifiex/11n_aggr.h                              |    2 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c                         |   29 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h                         |    2 +-
 drivers/net/wireless/mwifiex/Makefile                                |    2 +-
 drivers/net/wireless/mwifiex/README                                  |   32 +-
 drivers/net/wireless/mwifiex/cfg80211.c                              |   66 +-
 drivers/net/wireless/mwifiex/cfg80211.h                              |    2 +-
 drivers/net/wireless/mwifiex/cfp.c                                   |    2 +-
 drivers/net/wireless/mwifiex/cmdevt.c                                |   46 +-
 drivers/net/wireless/mwifiex/debugfs.c                               |   95 +-
 drivers/net/wireless/mwifiex/decl.h                                  |    2 +-
 drivers/net/wireless/mwifiex/ethtool.c                               |   85 +-
 drivers/net/wireless/mwifiex/fw.h                                    |    4 +-
 drivers/net/wireless/mwifiex/ie.c                                    |    2 +-
 drivers/net/wireless/mwifiex/init.c                                  |   15 +-
 drivers/net/wireless/mwifiex/ioctl.h                                 |    2 +-
 drivers/net/wireless/mwifiex/join.c                                  |   10 +-
 drivers/net/wireless/mwifiex/main.c                                  |   24 +-
 drivers/net/wireless/mwifiex/main.h                                  |   34 +-
 drivers/net/wireless/mwifiex/pcie.c                                  |  189 +-
 drivers/net/wireless/mwifiex/pcie.h                                  |   12 +-
 drivers/net/wireless/mwifiex/scan.c                                  |    2 +-
 drivers/net/wireless/mwifiex/sdio.c                                  |  235 +-
 drivers/net/wireless/mwifiex/sdio.h                                  |   14 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                               |    4 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c                           |    4 +-
 drivers/net/wireless/mwifiex/sta_event.c                             |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                             |   18 +-
 drivers/net/wireless/mwifiex/sta_rx.c                                |    2 +-
 drivers/net/wireless/mwifiex/sta_tx.c                                |    2 +-
 drivers/net/wireless/mwifiex/tdls.c                                  |   30 +-
 drivers/net/wireless/mwifiex/txrx.c                                  |    2 +-
 drivers/net/wireless/mwifiex/uap_cmd.c                               |    2 +-
 drivers/net/wireless/mwifiex/uap_event.c                             |    2 +-
 drivers/net/wireless/mwifiex/uap_txrx.c                              |    6 +-
 drivers/net/wireless/mwifiex/usb.c                                   |    2 +-
 drivers/net/wireless/mwifiex/usb.h                                   |    2 +-
 drivers/net/wireless/mwifiex/util.c                                  |    2 +-
 drivers/net/wireless/mwifiex/util.h                                  |    2 +-
 drivers/net/wireless/mwifiex/wmm.c                                   |   11 +-
 drivers/net/wireless/mwifiex/wmm.h                                   |    2 +-
 drivers/net/wireless/mwl8k.c                                         |    5 -
 drivers/net/wireless/orinoco/Kconfig                                 |    4 +-
 drivers/net/wireless/orinoco/orinoco_usb.c                           |    1 -
 drivers/net/wireless/p54/p54spi.c                                    |    2 +-
 drivers/net/wireless/prism54/oid_mgt.c                               |    1 -
 drivers/net/wireless/rsi/rsi_91x_core.c                              |   85 +-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c                           |   10 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                          |  143 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                              |  239 +-
 drivers/net/wireless/rsi/rsi_91x_pkt.c                               |   17 +
 drivers/net/wireless/rsi/rsi_91x_sdio.c                              |    6 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c                          |    8 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c                               |   88 +-
 drivers/net/wireless/rsi/rsi_main.h                                  |   12 +
 drivers/net/wireless/rsi/rsi_mgmt.h                                  |   25 +-
 drivers/net/wireless/rsi/rsi_sdio.h                                  |    8 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                              |   69 +-
 drivers/net/wireless/rt2x00/rt2800usb.c                              |    4 +
 drivers/net/wireless/rt2x00/rt2x00dev.c                              |   10 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                              |   20 +-
 drivers/net/wireless/rt2x00/rt2x00mmio.c                             |    8 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c                            |   21 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h                            |    1 +
 drivers/net/wireless/rtl818x/rtl8180/dev.c                           |   78 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h                       |    1 +
 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h                |    2 +-
 drivers/net/wireless/rtlwifi/core.c                                  |    1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c                          |    2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c                   |    1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h                         |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                          |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h                         |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c                          |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c                          |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c                         |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h                         |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c                          |    4 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c                          |    1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c                          |    3 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h                         |    1 +
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c                          |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c                   |    1 -
 drivers/net/wireless/rtlwifi/rtl8723be/reg.h                         |    1 +
 drivers/net/wireless/ti/wl1251/main.c                                |    3 +-
 drivers/net/wireless/ti/wl12xx/main.c                                |    2 +-
 drivers/net/wireless/ti/wl12xx/scan.c                                |   20 +-
 drivers/net/wireless/ti/wl12xx/scan.h                                |    2 +-
 drivers/net/wireless/ti/wl18xx/cmd.c                                 |   89 +
 drivers/net/wireless/ti/wl18xx/cmd.h                                 |   19 +-
 drivers/net/wireless/ti/wl18xx/event.c                               |   65 +
 drivers/net/wireless/ti/wl18xx/event.h                               |    2 +
 drivers/net/wireless/ti/wl18xx/main.c                                |   34 +-
 drivers/net/wireless/ti/wl18xx/scan.c                                |   16 +-
 drivers/net/wireless/ti/wl18xx/scan.h                                |    2 +-
 drivers/net/wireless/ti/wl18xx/tx.c                                  |    7 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h                              |    2 +-
 drivers/net/wireless/ti/wlcore/Makefile                              |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.c                                 |   23 +-
 drivers/net/wireless/ti/wlcore/cmd.h                                 |    6 +-
 drivers/net/wireless/ti/wlcore/debugfs.c                             |    2 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h                              |   27 +
 drivers/net/wireless/ti/wlcore/main.c                                |  108 +-
 drivers/net/wireless/ti/wlcore/scan.h                                |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c                                  |    2 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c                          |  197 ++
 drivers/net/wireless/ti/wlcore/vendor_cmd.h                          |   45 +
 drivers/net/wireless/ti/wlcore/wlcore.h                              |   10 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h                            |   20 +-
 drivers/net/wireless/zd1211rw/Kconfig                                |    4 +-
 drivers/net/xen-netback/common.h                                     |   30 +-
 drivers/net/xen-netback/interface.c                                  |   74 +-
 drivers/net/xen-netback/netback.c                                    |  110 +-
 drivers/net/xen-netback/xenbus.c                                     |  178 +-
 drivers/net/xen-netfront.c                                           |   74 +-
 drivers/nfc/Kconfig                                                  |    2 +-
 drivers/nfc/Makefile                                                 |    3 +-
 drivers/nfc/st21nfca/Makefile                                        |    2 +-
 drivers/nfc/st21nfca/i2c.c                                           |    9 +-
 drivers/nfc/st21nfca/st21nfca.c                                      |  272 +-
 drivers/nfc/st21nfca/st21nfca.h                                      |   26 +-
 drivers/nfc/st21nfca/st21nfca_dep.c                                  |  661 +++++
 drivers/nfc/st21nfca/st21nfca_dep.h                                  |   43 +
 drivers/nfc/st21nfcb/Kconfig                                         |   22 +
 drivers/nfc/st21nfcb/Makefile                                        |    8 +
 drivers/nfc/st21nfcb/i2c.c                                           |  462 +++
 drivers/nfc/st21nfcb/ndlc.c                                          |  298 ++
 drivers/nfc/st21nfcb/ndlc.h                                          |   55 +
 drivers/nfc/st21nfcb/st21nfcb.c                                      |  129 +
 drivers/nfc/st21nfcb/st21nfcb.h                                      |   38 +
 drivers/ptp/ptp_chardev.c                                            |    9 +-
 drivers/s390/net/claw.c                                              |    2 +-
 drivers/s390/net/ctcm_main.c                                         |    6 +-
 drivers/s390/net/netiucv.c                                           |    2 +-
 drivers/s390/net/qeth_core.h                                         |    7 +
 drivers/s390/net/qeth_core_main.c                                    |   39 +
 drivers/s390/net/qeth_core_mpc.h                                     |   17 +
 drivers/s390/net/qeth_core_sys.c                                     |   38 +-
 drivers/s390/net/qeth_l2_main.c                                      |    6 +-
 drivers/s390/net/qeth_l3_main.c                                      |    3 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                                   |  363 ++-
 drivers/scsi/cxgbi/libcxgbi.c                                        |  241 +-
 drivers/scsi/cxgbi/libcxgbi.h                                        |   21 +-
 drivers/ssb/pci.c                                                    |  113 +-
 drivers/staging/cxt1e1/linux.c                                       |    3 +-
 drivers/staging/gdm724x/gdm_lte.c                                    |    2 +-
 drivers/staging/gdm72xx/gdm_wimax.c                                  |    3 +-
 drivers/staging/vt6655/wpactl.c                                      |    3 +-
 drivers/staging/wlan-ng/p80211netdev.c                               |    2 +-
 drivers/tty/n_gsm.c                                                  |    5 +-
 drivers/usb/gadget/f_phonet.c                                        |    3 +-
 fs/compat_ioctl.c                                                    |    2 +-
 include/linux/arcdevice.h                                            |   10 +-
 include/linux/bcma/bcma.h                                            |   27 +-
 include/linux/bcma/bcma_driver_pcie2.h                               |  158 +
 include/linux/crc32.h                                                |   20 +-
 include/linux/filter.h                                               |  112 +-
 include/linux/ieee80211.h                                            |   23 +
 include/linux/if_bridge.h                                            |   20 +
 include/linux/ipv6.h                                                 |   24 +-
 include/linux/isdn_ppp.h                                             |    4 +-
 include/linux/kernel.h                                               |    2 +-
 include/linux/mlx4/device.h                                          |   18 +
 include/linux/mlx5/device.h                                          |    4 -
 include/linux/mlx5/driver.h                                          |   27 +-
 include/linux/netdev_features.h                                      |    8 +
 include/linux/netdevice.h                                            |  421 ++-
 include/linux/phy.h                                                  |   18 +
 include/linux/platform_data/st21nfcb.h                               |   32 +
 include/linux/ptp_classify.h                                         |    5 +-
 include/linux/rhashtable.h                                           |  213 ++
 include/linux/rndis.h                                                |    1 +
 include/linux/rtnetlink.h                                            |    1 +
 include/linux/skbuff.h                                               |   44 +-
 include/linux/spi/cc2520.h                                           |   26 +
 include/linux/ssb/ssb_regs.h                                         |   37 +
 include/linux/stmmac.h                                               |    2 +
 include/linux/tcp.h                                                  |    3 -
 include/linux/usb/usbnet.h                                           |    3 +
 include/net/6lowpan.h                                                |   50 -
 include/net/bluetooth/bluetooth.h                                    |   18 +-
 include/net/bluetooth/hci.h                                          |  297 +-
 include/net/bluetooth/hci_core.h                                     |  187 +-
 include/net/bluetooth/hci_sock.h                                     |  175 ++
 include/net/bluetooth/l2cap.h                                        |   46 +-
 include/net/bluetooth/mgmt.h                                         |  103 +-
 include/net/bluetooth/sco.h                                          |   30 -
 include/net/cfg80211.h                                               |   38 +-
 include/net/dcbnl.h                                                  |    4 +-
 include/net/flow_keys.h                                              |   15 +
 include/net/if_inet6.h                                               |    1 +
 include/net/inet_frag.h                                              |  118 +-
 include/net/inet_sock.h                                              |    6 +-
 include/net/inet_timewait_sock.h                                     |    3 +-
 include/net/ip.h                                                     |   21 +-
 include/net/ip_tunnels.h                                             |    1 +
 include/net/ipv6.h                                                   |   71 +-
 include/net/mac80211.h                                               |  105 +-
 include/net/mac802154.h                                              |   19 +
 include/net/netfilter/nf_conntrack_ecache.h                          |   26 +-
 include/net/netfilter/nf_log.h                                       |   42 +-
 include/net/netfilter/xt_log.h                                       |   54 -
 include/net/netlink.h                                                |    6 +-
 include/net/netns/conntrack.h                                        |    6 +-
 include/net/netns/ipv6.h                                             |    1 +
 include/net/netns/x_tables.h                                         |    6 -
 include/net/nfc/digital.h                                            |   13 +
 include/net/nfc/hci.h                                                |    1 +
 include/net/rtnetlink.h                                              |    1 +
 include/net/sch_generic.h                                            |    2 +-
 include/net/sctp/command.h                                           |   39 +-
 include/net/sctp/constants.h                                         |    2 +-
 include/net/sctp/sctp.h                                              |   24 +-
 include/net/sctp/structs.h                                           |   15 +-
 include/net/sctp/ulpevent.h                                          |   14 +-
 include/net/sock.h                                                   |   72 +-
 include/net/tcp.h                                                    |   63 +-
 include/net/udp.h                                                    |   29 +
 include/net/udp_tunnel.h                                             |   32 +
 include/net/vxlan.h                                                  |    2 -
 include/uapi/linux/can/netlink.h                                     |    3 +-
 include/uapi/linux/dcbnl.h                                           |    3 +-
 include/uapi/linux/errqueue.h                                        |   20 +
 include/uapi/linux/if_link.h                                         |    6 +
 include/uapi/linux/if_packet.h                                       |    2 +-
 include/uapi/linux/in6.h                                             |    1 +
 include/uapi/linux/ipv6.h                                            |    1 +
 include/uapi/linux/net_tstamp.h                                      |   10 +-
 include/uapi/linux/netdevice.h                                       |    6 +
 include/uapi/linux/netfilter/nf_tables.h                             |    4 +
 include/uapi/linux/netfilter/xt_bpf.h                                |    4 +-
 include/uapi/linux/netfilter_bridge/Kbuild                           |    1 -
 include/uapi/linux/netfilter_bridge/ebt_ulog.h                       |   38 -
 include/uapi/linux/netfilter_ipv4/Kbuild                             |    1 -
 include/uapi/linux/netfilter_ipv4/ipt_ULOG.h                         |   49 -
 include/uapi/linux/nl80211.h                                         |    5 +
 include/uapi/linux/openvswitch.h                                     |   13 +-
 include/uapi/linux/sctp.h                                            |  102 +-
 include/uapi/linux/sysctl.h                                          |    1 +
 include/uapi/linux/tipc_config.h                                     |    2 +-
 kernel/Makefile                                                      |    1 +
 kernel/bpf/Makefile                                                  |    1 +
 kernel/bpf/core.c                                                    |  534 ++++
 kernel/seccomp.c                                                     |   20 +-
 kernel/sysctl_binary.c                                               |    1 +
 lib/Kconfig.debug                                                    |    8 +
 lib/Makefile                                                         |    2 +-
 lib/crc32.c                                                          |  153 +-
 lib/dynamic_debug.c                                                  |    8 +-
 lib/iovec.c                                                          |    4 +
 lib/net_utils.c                                                      |   10 +-
 lib/random32.c                                                       |   49 +-
 lib/rhashtable.c                                                     |  797 +++++
 lib/test_bpf.c                                                       |   28 +-
 net/6lowpan/Kconfig                                                  |    6 +
 net/6lowpan/Makefile                                                 |    3 +
 net/{ieee802154/6lowpan_iphc.c => 6lowpan/iphc.c}                    |  296 +-
 net/802/fc.c                                                         |    2 +-
 net/802/fddi.c                                                       |    3 +-
 net/802/hippi.c                                                      |    3 +-
 net/8021q/vlan.c                                                     |   24 +-
 net/8021q/vlan_dev.c                                                 |    2 +
 net/8021q/vlanproc.c                                                 |    2 +
 net/9p/client.c                                                      |    1 -
 net/Kconfig                                                          |    1 +
 net/Makefile                                                         |    3 +-
 net/appletalk/ddp.c                                                  |    2 +-
 net/appletalk/dev.c                                                  |    3 +-
 net/atm/br2684.c                                                     |    4 +-
 net/atm/clip.c                                                       |    3 +-
 net/batman-adv/bat_iv_ogm.c                                          |   13 +-
 net/batman-adv/distributed-arp-table.c                               |    3 +-
 net/batman-adv/fragmentation.c                                       |   10 +-
 net/batman-adv/hash.c                                                |    6 +-
 net/batman-adv/main.h                                                |   22 +-
 net/batman-adv/routing.c                                             |   18 +-
 net/batman-adv/soft-interface.c                                      |    4 +-
 net/batman-adv/sysfs.c                                               |   24 +-
 net/bluetooth/6lowpan.c                                              |  857 ++++--
 net/bluetooth/6lowpan.h                                              |   47 -
 net/bluetooth/Kconfig                                                |    7 +-
 net/bluetooth/Makefile                                               |    4 +-
 net/bluetooth/a2mp.c                                                 |    8 +-
 net/bluetooth/af_bluetooth.c                                         |    2 +-
 net/bluetooth/amp.c                                                  |    6 +-
 net/bluetooth/bnep/core.c                                            |    5 +-
 net/bluetooth/cmtp/capi.c                                            |    6 -
 net/bluetooth/hci_conn.c                                             |  191 +-
 net/bluetooth/hci_core.c                                             | 1190 +++++---
 net/bluetooth/hci_event.c                                            |  815 +++--
 net/bluetooth/hci_sock.c                                             |   33 +-
 net/bluetooth/hidp/core.c                                            |    2 +-
 net/bluetooth/l2cap_core.c                                           |  174 +-
 net/bluetooth/l2cap_sock.c                                           |   53 +-
 net/bluetooth/mgmt.c                                                 | 1399 +++++++--
 net/bluetooth/rfcomm/core.c                                          |   10 +-
 net/bluetooth/rfcomm/sock.c                                          |    3 +-
 net/bluetooth/sco.c                                                  |  125 +-
 net/bluetooth/smp.c                                                  |  246 +-
 net/bluetooth/smp.h                                                  |    7 +
 net/bridge/br_fdb.c                                                  |   26 +-
 net/bridge/br_if.c                                                   |    2 +-
 net/bridge/br_multicast.c                                            |   37 +
 net/bridge/br_netlink.c                                              |    1 -
 net/bridge/br_private.h                                              |    2 +-
 net/bridge/br_vlan.c                                                 |    6 +-
 net/bridge/netfilter/Kconfig                                         |   25 +-
 net/bridge/netfilter/Makefile                                        |    5 +-
 net/bridge/netfilter/ebt_log.c                                       |   47 +-
 net/bridge/netfilter/ebt_ulog.c                                      |  393 ---
 net/bridge/netfilter/nf_log_bridge.c                                 |   96 +
 net/bridge/netfilter/nft_reject_bridge.c                             |   67 +
 net/caif/caif_socket.c                                               |    3 +-
 net/caif/cfctrl.c                                                    |    1 -
 net/core/dev.c                                                       |   53 +-
 net/core/drop_monitor.c                                              |    2 -
 net/core/filter.c                                                    |  728 +----
 net/core/flow_dissector.c                                            |   85 +-
 net/core/net-sysfs.c                                                 |  154 +-
 net/core/netpoll.c                                                   |    3 +-
 net/core/pktgen.c                                                    |  111 +-
 net/core/ptp_classifier.c                                            |   70 +-
 net/core/request_sock.c                                              |   43 +-
 net/core/rtnetlink.c                                                 |  107 +-
 net/core/skbuff.c                                                    |   22 +-
 net/core/sock.c                                                      |   52 +-
 net/core/sock_diag.c                                                 |    4 +-
 net/core/timestamping.c                                              |   57 +-
 net/dcb/dcbnl.c                                                      |   13 +-
 net/dccp/ipv6.c                                                      |    2 +-
 net/dccp/minisocks.c                                                 |    4 +-
 net/dsa/dsa.c                                                        |    3 +-
 net/dsa/slave.c                                                      |    4 +-
 net/ethernet/eth.c                                                   |    3 +-
 net/hsr/Makefile                                                     |    3 +-
 net/hsr/hsr_device.c                                                 |  580 ++--
 net/hsr/hsr_device.h                                                 |   12 +-
 net/hsr/hsr_forward.c                                                |  368 +++
 net/hsr/hsr_forward.h                                                |   20 +
 net/hsr/hsr_framereg.c                                               |  477 ++-
 net/hsr/hsr_framereg.h                                               |   45 +-
 net/hsr/hsr_main.c                                                   |  425 +--
 net/hsr/hsr_main.h                                                   |   61 +-
 net/hsr/hsr_netlink.c                                                |  102 +-
 net/hsr/hsr_netlink.h                                                |   11 +-
 net/hsr/hsr_slave.c                                                  |  196 ++
 net/hsr/hsr_slave.h                                                  |   38 +
 net/ieee802154/6lowpan_rtnl.c                                        |   16 +-
 net/ieee802154/Kconfig                                               |    9 +-
 net/ieee802154/Makefile                                              |    5 +-
 net/ieee802154/af_ieee802154.c                                       |   26 +-
 net/ieee802154/dgram.c                                               |   28 +-
 net/ieee802154/ieee802154.h                                          |    2 +-
 net/ieee802154/netlink.c                                             |    4 +-
 net/ieee802154/nl-mac.c                                              |   48 +-
 net/ieee802154/nl-phy.c                                              |   23 +-
 net/ieee802154/raw.c                                                 |   14 +-
 net/ieee802154/reassembly.c                                          |   69 +-
 net/ieee802154/wpan-class.c                                          |   10 +-
 net/ipv4/Kconfig                                                     |    4 +
 net/ipv4/Makefile                                                    |    1 +
 net/ipv4/datagram.c                                                  |    1 +
 net/ipv4/devinet.c                                                   |   36 +-
 net/ipv4/gre_offload.c                                               |    2 +-
 net/ipv4/icmp.c                                                      |    6 +-
 net/ipv4/igmp.c                                                      |    2 +-
 net/ipv4/inet_fragment.c                                             |  318 +-
 net/ipv4/ip_fragment.c                                               |   87 +-
 net/ipv4/ip_output.c                                                 |   13 +-
 net/ipv4/ip_sockglue.c                                               |    2 +-
 net/ipv4/ip_tunnel.c                                                 |   31 +-
 net/ipv4/ip_vti.c                                                    |   54 +-
 net/ipv4/ipconfig.c                                                  |    5 +-
 net/ipv4/ipmr.c                                                      |    2 +-
 net/ipv4/netfilter/Kconfig                                           |   29 +-
 net/ipv4/netfilter/Makefile                                          |    5 +-
 net/ipv4/netfilter/ipt_ULOG.c                                        |  498 ----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                       |    6 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c                         |    4 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                                  |    8 +-
 net/ipv4/netfilter/nf_log_arp.c                                      |  149 +
 net/ipv4/netfilter/nf_log_ipv4.c                                     |  385 +++
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c                             |    4 +
 net/ipv4/netfilter/nf_nat_proto_gre.c                                |    2 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c                               |    2 +-
 net/ipv4/ping.c                                                      |    2 +-
 net/ipv4/proc.c                                                      |    5 +-
 net/ipv4/raw.c                                                       |    9 +-
 net/ipv4/syncookies.c                                                |    3 +-
 net/ipv4/tcp.c                                                       |   22 +-
 net/ipv4/tcp_input.c                                                 |  200 +-
 net/ipv4/tcp_ipv4.c                                                  |  201 +-
 net/ipv4/tcp_metrics.c                                               |    1 -
 net/ipv4/tcp_minisocks.c                                             |    2 +-
 net/ipv4/tcp_offload.c                                               |   18 +
 net/ipv4/tcp_output.c                                                |   18 +-
 net/ipv4/tcp_timer.c                                                 |    4 +-
 net/ipv4/tcp_vegas.c                                                 |    3 +-
 net/ipv4/tcp_veno.c                                                  |    2 +-
 net/ipv4/udp.c                                                       |  156 +-
 net/ipv4/udp_offload.c                                               |   76 +
 net/ipv4/udp_tunnel.c                                                |  100 +
 net/ipv4/xfrm4_protocol.c                                            |    2 +-
 net/ipv6/addrconf.c                                                  |  148 +-
 net/ipv6/af_inet6.c                                                  |    7 +-
 net/ipv6/datagram.c                                                  |    1 +
 net/ipv6/icmp.c                                                      |   13 +-
 net/ipv6/ip6_gre.c                                                   |   13 +-
 net/ipv6/ip6_output.c                                                |   32 +-
 net/ipv6/ip6_tunnel.c                                                |    8 +-
 net/ipv6/ip6_vti.c                                                   |   55 +-
 net/ipv6/ip6mr.c                                                     |    2 +-
 net/ipv6/ipv6_sockglue.c                                             |   13 +-
 net/ipv6/ndisc.c                                                     |   58 +-
 net/ipv6/netfilter/Kconfig                                           |    5 +
 net/ipv6/netfilter/Makefile                                          |    3 +
 net/ipv6/netfilter/ip6t_ipv6header.c                                 |    1 -
 net/ipv6/netfilter/nf_conntrack_reasm.c                              |   49 +-
 net/ipv6/netfilter/nf_log_ipv6.c                                     |  417 +++
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c                             |    4 +
 net/ipv6/proc.c                                                      |    4 +-
 net/ipv6/raw.c                                                       |   14 +-
 net/ipv6/reassembly.c                                                |   90 +-
 net/ipv6/sit.c                                                       |    4 +-
 net/ipv6/syncookies.c                                                |    2 +-
 net/ipv6/sysctl_net_ipv6.c                                           |    9 +
 net/ipv6/tcp_ipv6.c                                                  |  209 +-
 net/ipv6/udp.c                                                       |  131 +-
 net/irda/af_irda.c                                                   |    1 -
 net/irda/irda_device.c                                               |    3 +-
 net/irda/irlan/irlan_common.c                                        |    1 -
 net/irda/irlan/irlan_eth.c                                           |    2 +-
 net/irda/irlmp.c                                                     |    3 +-
 net/iucv/af_iucv.c                                                   |    4 +-
 net/key/af_key.c                                                     |    3 -
 net/l2tp/Kconfig                                                     |    1 +
 net/l2tp/l2tp_core.c                                                 |   86 +-
 net/l2tp/l2tp_eth.c                                                  |    3 +-
 net/l2tp/l2tp_ip6.c                                                  |    2 +-
 net/mac80211/Kconfig                                                 |   17 -
 net/mac80211/Makefile                                                |    6 +-
 net/mac80211/agg-rx.c                                                |  110 +-
 net/mac80211/agg-tx.c                                                |    8 +-
 net/mac80211/cfg.c                                                   |  558 +---
 net/mac80211/chan.c                                                  |  861 +++++-
 net/mac80211/debugfs_sta.c                                           |    3 +-
 net/mac80211/driver-ops.h                                            |   20 +-
 net/mac80211/ethtool.c                                               |  244 ++
 net/mac80211/ht.c                                                    |   10 +-
 net/mac80211/ibss.c                                                  |   15 +-
 net/mac80211/ieee80211_i.h                                           |  116 +-
 net/mac80211/iface.c                                                 |   46 +-
 net/mac80211/key.c                                                   |    3 -
 net/mac80211/main.c                                                  |   10 +-
 net/mac80211/mesh.c                                                  |    4 +-
 net/mac80211/mesh_hwmp.c                                             |    1 -
 net/mac80211/mesh_plink.c                                            |   30 +-
 net/mac80211/mlme.c                                                  |  156 +-
 net/mac80211/offchannel.c                                            |    6 +-
 net/mac80211/pm.c                                                    |    6 +-
 net/mac80211/rate.h                                                  |   13 -
 net/mac80211/rc80211_pid.h                                           |  278 --
 net/mac80211/rc80211_pid_algo.c                                      |  478 ---
 net/mac80211/rc80211_pid_debugfs.c                                   |  228 --
 net/mac80211/rx.c                                                    |   67 +-
 net/mac80211/scan.c                                                  |  118 +-
 net/mac80211/sta_info.c                                              |  204 +-
 net/mac80211/sta_info.h                                              |   21 +-
 net/mac80211/status.c                                                |    7 +-
 net/mac80211/tdls.c                                                  |  674 ++++-
 net/mac80211/trace.h                                                 |    7 +
 net/mac80211/tx.c                                                    |  170 +-
 net/mac80211/util.c                                                  |  285 +-
 net/mac80211/vht.c                                                   |    4 +
 net/mac80211/wep.c                                                   |   20 -
 net/mac80211/wpa.c                                                   |    2 +-
 net/mac802154/ieee802154_dev.c                                       |   70 +-
 net/mac802154/llsec.c                                                |    1 +
 net/mac802154/mib.c                                                  |    7 +-
 net/mac802154/tx.c                                                   |    1 +
 net/netfilter/Kconfig                                                |    4 +
 net/netfilter/Makefile                                               |    3 +
 net/netfilter/ipvs/ip_vs_ctl.c                                       |   86 -
 net/netfilter/ipvs/ip_vs_sync.c                                      |    3 +-
 net/netfilter/ipvs/ip_vs_xmit.c                                      |    2 +-
 net/netfilter/nf_conntrack_core.c                                    |   68 +-
 net/netfilter/nf_conntrack_ecache.c                                  |   96 +-
 net/netfilter/nf_conntrack_netlink.c                                 |    3 +-
 net/netfilter/nf_log.c                                               |  155 +-
 net/netfilter/nf_log_common.c                                        |  187 ++
 net/netfilter/nf_nat_core.c                                          |    2 +-
 net/netfilter/nf_nat_proto_common.c                                  |    2 +-
 net/netfilter/nf_nat_proto_dccp.c                                    |    2 +-
 net/netfilter/nf_nat_proto_sctp.c                                    |    2 +-
 net/netfilter/nf_nat_proto_tcp.c                                     |    2 +-
 net/netfilter/nf_nat_proto_udp.c                                     |    2 +-
 net/netfilter/nf_nat_proto_udplite.c                                 |    2 +-
 net/netfilter/nf_tables_api.c                                        |  138 +-
 net/netfilter/nfnetlink_acct.c                                       |   12 +-
 net/netfilter/nfnetlink_log.c                                        |    4 +
 net/netfilter/nft_hash.c                                             |  291 +-
 net/netfilter/nft_log.c                                              |   98 +-
 net/netfilter/x_tables.c                                             |   23 +-
 net/netfilter/xt_LED.c                                               |   14 +-
 net/netfilter/xt_LOG.c                                               |  884 +-----
 net/netfilter/xt_bpf.c                                               |    6 +-
 net/netfilter/xt_hashlimit.c                                         |   31 +-
 net/netlabel/netlabel_kapi.c                                         |    1 -
 net/netlink/af_netlink.c                                             |  308 +-
 net/netlink/af_netlink.h                                             |   18 +-
 net/netlink/diag.c                                                   |   11 +-
 net/netrom/af_netrom.c                                               |    2 +-
 net/nfc/digital.h                                                    |    3 +
 net/nfc/digital_core.c                                               |   27 +-
 net/nfc/digital_dep.c                                                |   13 +-
 net/nfc/digital_technology.c                                         |   96 +-
 net/nfc/hci/core.c                                                   |    7 +-
 net/nfc/nci/ntf.c                                                    |    4 +-
 net/openvswitch/actions.c                                            |   50 +-
 net/openvswitch/datapath.c                                           |   55 +-
 net/openvswitch/datapath.h                                           |    2 +-
 net/openvswitch/vport-internal_dev.c                                 |   24 +-
 net/openvswitch/vport-internal_dev.h                                 |    2 +
 net/openvswitch/vport-vxlan.c                                        |    5 +-
 net/openvswitch/vport.c                                              |  101 +-
 net/openvswitch/vport.h                                              |   27 +-
 net/packet/af_packet.c                                               |   14 +-
 net/phonet/pep-gprs.c                                                |    2 +-
 net/rose/af_rose.c                                                   |    2 +-
 net/rxrpc/ar-key.c                                                   |    2 +-
 net/sched/act_mirred.c                                               |    2 +
 net/sched/cls_api.c                                                  |   11 +-
 net/sched/cls_bpf.c                                                  |   12 +-
 net/sched/cls_tcindex.c                                              |    2 +-
 net/sched/em_canid.c                                                 |    7 -
 net/sched/sch_generic.c                                              |    4 +-
 net/sched/sch_teql.c                                                 |    4 +-
 net/sctp/Makefile                                                    |    2 +-
 net/sctp/command.c                                                   |   68 -
 net/sctp/input.c                                                     |    5 -
 net/sctp/ipv6.c                                                      |  156 +-
 net/sctp/output.c                                                    |   73 +-
 net/sctp/outqueue.c                                                  |    5 +-
 net/sctp/protocol.c                                                  |   12 +-
 net/sctp/sm_statefuns.c                                              |    4 -
 net/sctp/socket.c                                                    |  327 +-
 net/sctp/sysctl.c                                                    |    5 +-
 net/sctp/transport.c                                                 |   21 +-
 net/sctp/ulpevent.c                                                  |   65 +-
 net/socket.c                                                         |   39 +-
 net/tipc/bcast.c                                                     |   87 +-
 net/tipc/bcast.h                                                     |    5 +-
 net/tipc/link.c                                                      |  794 ++---
 net/tipc/link.h                                                      |    7 +-
 net/tipc/msg.c                                                       |  381 ++-
 net/tipc/msg.h                                                       |   35 +-
 net/tipc/name_distr.c                                                |   76 +-
 net/tipc/name_distr.h                                                |    2 +-
 net/tipc/net.c                                                       |   63 +-
 net/tipc/net.h                                                       |    2 -
 net/tipc/node.c                                                      |   38 +-
 net/tipc/node.h                                                      |   17 +
 net/tipc/node_subscr.c                                               |    6 +-
 net/tipc/port.c                                                      |  440 +--
 net/tipc/port.h                                                      |   50 -
 net/tipc/socket.c                                                    |  551 ++--
 net/tipc/socket.h                                                    |   16 +
 net/wireless/Kconfig                                                 |    6 +
 net/wireless/core.c                                                  |    3 -
 net/wireless/ethtool.c                                               |   86 +-
 net/wireless/ethtool.h                                               |    6 -
 net/wireless/genregdb.awk                                            |   35 +-
 net/wireless/nl80211.c                                               |   18 +-
 net/wireless/rdev-ops.h                                              |   54 +-
 net/wireless/trace.h                                                 |   59 +-
 1160 files changed, 70930 insertions(+), 30835 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st21nfcb.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
 create mode 100644 drivers/bcma/driver_pcie2.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-dcb.c
 create mode 100644 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
 create mode 100644 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h
 create mode 100644 drivers/net/ethernet/cisco/enic/enic_clsf.c
 create mode 100644 drivers/net/ethernet/cisco/enic/enic_clsf.h
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_fcoe.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_fcoe.h
 create mode 100644 drivers/net/ethernet/marvell/mvpp2.c
 create mode 100644 drivers/net/ieee802154/cc2520.c
 create mode 100644 drivers/net/wireless/ath/ath9k/channel.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/commonring.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/commonring.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/feature.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/feature.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/flowring.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/flowring.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/of.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/of.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/pcie.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/pcie.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/vendor.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/vendor.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
 create mode 100644 drivers/net/wireless/ti/wlcore/vendor_cmd.c
 create mode 100644 drivers/net/wireless/ti/wlcore/vendor_cmd.h
 create mode 100644 drivers/nfc/st21nfca/st21nfca_dep.c
 create mode 100644 drivers/nfc/st21nfca/st21nfca_dep.h
 create mode 100644 drivers/nfc/st21nfcb/Kconfig
 create mode 100644 drivers/nfc/st21nfcb/Makefile
 create mode 100644 drivers/nfc/st21nfcb/i2c.c
 create mode 100644 drivers/nfc/st21nfcb/ndlc.c
 create mode 100644 drivers/nfc/st21nfcb/ndlc.h
 create mode 100644 drivers/nfc/st21nfcb/st21nfcb.c
 create mode 100644 drivers/nfc/st21nfcb/st21nfcb.h
 create mode 100644 include/linux/bcma/bcma_driver_pcie2.h
 create mode 100644 include/linux/platform_data/st21nfcb.h
 create mode 100644 include/linux/rhashtable.h
 create mode 100644 include/linux/spi/cc2520.h
 create mode 100644 include/net/bluetooth/hci_sock.h
 delete mode 100644 include/net/netfilter/xt_log.h
 create mode 100644 include/net/udp_tunnel.h
 delete mode 100644 include/uapi/linux/netfilter_bridge/ebt_ulog.h
 delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_ULOG.h
 create mode 100644 kernel/bpf/Makefile
 create mode 100644 kernel/bpf/core.c
 create mode 100644 lib/rhashtable.c
 create mode 100644 net/6lowpan/Kconfig
 create mode 100644 net/6lowpan/Makefile
 rename net/{ieee802154/6lowpan_iphc.c => 6lowpan/iphc.c} (74%)
 delete mode 100644 net/bluetooth/6lowpan.h
 delete mode 100644 net/bridge/netfilter/ebt_ulog.c
 create mode 100644 net/bridge/netfilter/nf_log_bridge.c
 create mode 100644 net/bridge/netfilter/nft_reject_bridge.c
 create mode 100644 net/hsr/hsr_forward.c
 create mode 100644 net/hsr/hsr_forward.h
 create mode 100644 net/hsr/hsr_slave.c
 create mode 100644 net/hsr/hsr_slave.h
 delete mode 100644 net/ipv4/netfilter/ipt_ULOG.c
 create mode 100644 net/ipv4/netfilter/nf_log_arp.c
 create mode 100644 net/ipv4/netfilter/nf_log_ipv4.c
 create mode 100644 net/ipv4/udp_tunnel.c
 create mode 100644 net/ipv6/netfilter/nf_log_ipv6.c
 create mode 100644 net/mac80211/ethtool.c
 delete mode 100644 net/mac80211/rc80211_pid.h
 delete mode 100644 net/mac80211/rc80211_pid_algo.c
 delete mode 100644 net/mac80211/rc80211_pid_debugfs.c
 create mode 100644 net/netfilter/nf_log_common.c
 delete mode 100644 net/sctp/command.c
 delete mode 100644 net/wireless/ethtool.h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
