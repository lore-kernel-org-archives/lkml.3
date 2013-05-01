Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3EAUsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:48:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42825 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3EAUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:47:59 -0400
Date: Wed, 01 May 2013 16:47:55 -0400 (EDT)
Message-Id: <20130501.164755.1859264969403837546.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 01 May 2013 13:47:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r41KmJfA032273


Three very minor conflicts you will see when you pull this:

1) tools/Makefile

   My tree is simply adding "net" after "vm" in the list of FORCE targets
   with the rule command "$(call descend,$@)"

   Similarly, add "net_clean" after "vm_clean" in the list of clean
   targets with rule command "$(call descend,$(@:_clean=),clean)"

2) tools/selftests/Makefile

   My tree simply adds the line "TARGETS += net".

3) include/linux/pci.h

   The PCI changes that went into your tree removed "extern" from the
   declarations in this file.

   My tree adds:

	int pci_vfs_assigned(struct pci_dev *dev);

   between the declarations for pci_num_vf and pci_sriov_set_totalvfs.

Highlights (1721 non-merge commits, this has to be a record of some
sort):

1) Add 'random' mode to team driver, from Jiri Pirko and Eric Dumazet.

2) Make it so that any driver that supports configuration of multiple
   MAC addresses can provide the forwarding database add and del calls
   by providing a default implementation and hooking that up if the
   driver doesn't have an explicit set of handlers.  From Vlad
   Yasevich.

3) Support GSO segmentation over tunnels and other encapsulating devices
   such as VXLAN, from Pravin B Shelar.

4) Support L2 GRE tunnels in the flow dissector, from Michael Dalton.

5) Implement Tail Loss Probe (TLP) detection in TCP, from Nandita
   Dukkipati.

6) In the PHY layer, allow supporting wake-on-lan in situations where
   the PHY registers have to be written for it to be configured.

   Use it to support wake-on-lan in mv643xx_eth.

   From Michael Stapelberg.

7) Significantly improve firewire IPV6 support, from YOSHIFUJI
   Hideaki.

8) Allow multiple packets to be sent in a single transmission using
   network coding in batman-adv, from Martin Hundeb√∏ll.

9) Add support for T5 cxgb4 chips, from Santosh Rastapur.

10) Generalize the VXLAN forwarding tables so that there is more flexibility
    in configurating various aspects of the endpoints.  From David Stevens.

11) Support RSS and TSO in hardware over GRE tunnels in bxn2x driver, from
    Dmitry Kravkov.

12) Zero copy support in nfnelink_queue, from Eric Dumazet and Pablo Neira
    Ayuso.

13) Start adding networking selftests.

14) In situations of overload on the same AF_PACKET fanout socket, or
    per-cpu packet receive queue, minimize drop by distributing the
    load to other cpus/fanouts.  From Willem de Bruijn and Eric
    Dumazet.

15) Add support for new payload offset BPF instruction, from Daniel
    Borkmann.

16) Convert several drivers over to mdoule_platform_driver(), from
    Sachin Kamat.

17) Provide a minimal BPF JIT image disassembler userspace tool, from
    Daniel Borkmann.

18) Rewrite F-RTO implementation in TCP to match the final specification
    of it in RFC4138 and RFC5682.  From Yuchung Cheng.

19) Provide netlink socket diag of netlink sockets ("Yo dawg, I hear you
    like netlink, so I implemented netlink dumping of netlink sockets.")
    From Andrey Vagin.

20) Remove ugly passing of rtnetlink attributes into rtnl_doit functions,
    from Thomas Graf.

21) Allow userspace to be able to see if a configuration change occurs
    in the middle of an address or device list dump, from Nicolas
    Dichtel.

22) Support RFC3168 ECN protection for ipv6 fragments, from Hannes
    Frederic Sowa.

23) Increase accuracy of packet length used by packet scheduler, from
    Jason Wang.

24) Beginning set of changes to make ipv4/ipv6 fragment handling more
    scalable and less susceptible to overload and locking contention,
    from Jesper Dangaard Brouer.

25) Get rid of using non-type-safe NLMSG_* macros and use nlmsg_*()
    instead.  From Hong Zhiguo.

26) Optimize route usage in IPVS by avoiding reference counting where
    possible, from Julian Anastasov.

27) Convert IPVS schedulers to RCU, also from Julian Anastasov.

28) Support cpu fanouts in xt_NFQUEUE netfilter target, from Holger
    Eitzenberger.

29) Network namespace support for nf_log, ebt_log, xt_LOG, ipt_ULOG,
    nfnetlink_log, and nfnetlink_queue.  From Gao feng.

30) Implement RFC3168 ECN protection, from Hannes Frederic Sowa.

31) Support several new r8169 chips, from Hayes Wang.

32) Support tokenized interface identifiers in ipv6, from Daniel
    Borkmann.

33) Use usbnet_link_change() helper in USB net driver, from Ming Lei.

34) Add 802.1ad vlan offload support, from Patrick McHardy.

35) Support mmap() based netlink communication, also from Patrick
    McHardy.

36) Support HW timestamping in mlx4 driver, from Amir Vadai.

37) Rationalize AF_PACKET packet timestamping when transmitting, from
    Willem de Bruijn and Daniel Borkmann.

38) Bring parity to what's provided by /proc/net/packet socket dumping
    and the info provided by netlink socket dumping of AF_PACKET
    sockets.  From Nicolas Dichtel.

39) Fix peeking beyond zero sized SKBs in AF_UNIX, from Benjamin
    Poirier.

Please pull, thanks a lot!

The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:

  Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to 20074f357da4a637430aec2879c9d864c5d2c23c:

  filter: fix va_list build error (2013-05-01 16:28:48 -0400)

----------------------------------------------------------------
Ajit Khaparde (3):
      be2net: Remove an incorrect pvid check in Tx
      be2net: fix a Tx stall bug caused by a specific ipv6 packet
      be2net: Fix PVID tag offload for packets with inline VLAN tag.

Akeem G. Abodunrin (6):
      igb: Support for 100base-fx SFP
      igb: Support to read and export SFF-8472/8079 data
      igb: Implement support to power sfp cage and turn on I2C
      igb: random code and comments fix
      igb: Fix sparse warnings on function pointers
      igb: SERDES loopback sigdetect bit on i210 devices

Alan Ott (10):
      mrf24j40: pinctrl support
      mrf24j40: Warn if transmit interrupts timeout
      mrf24j40: Increase max SPI speed to 10MHz
      mrf24j40: Fix byte-order of IEEE address
      mac802154: Do not try to resend failed packets
      mac802154: Use netif flow control
      mac802154: Increase tx_buffer_len
      6lowpan: handle dev_queue_xmit() error code properly
      mrf24j40: Enable link-layer acknowledgement and retry
      mac802154: Keep track of the channel when changed

Alex A. Mihaylov (1):
      rt2x00: Fix transmit power troubles on some Ralink RT30xx cards

Alexander Bondar (16):
      mac80211: add driver callback for per-interface multicast filter
      mac80211: allow drivers to set default uAPSD parameters
      iwlwifi: mvm: downgrade to old power management API
      iwlwifi: mvm: Rename some power management definitions and methods
      iwlwifi: mvm: don't disable power management due to P2P device
      iwlwifi: mvm: Fix active-to-powersave transition time units
      iwlwifi: mvm: always send power table command
      iwlwifi: mvm: set keepalive period regardless of PM state
      iwlwifi: mvm: encapsulate power table command log message
      iwlwifi: mvm: change active-to-powersave transition time for BPS
      iwlwifi: mvm: remove redundant iwl_power_get_params()
      mac80211: disable uAPSD if all ACs are under ACM
      mac80211: remove warning from ieee80211_beacon_loss
      iwlwifi: mvm: change TX/RX AM-to-PSM transition time for LP mode
      iwlwifi: mvm: remove usage of power_save module parameter
      mac80211: indicate admission control in TX queue parameters

Alexander Duyck (9):
      ixgbevf: Make next_to_watch a pointer and adjust memory barriers to avoid races
      ioat/dca: Update DCA BIOS workarounds to use TAINT_FIRMWARE_WORKAROUND
      ixgbe: Mask off check of frag_off as we only want fragment offset
      ixgbe: Drop check for PAGE_SIZE from ixgbe_xmit_frame_ring
      igb: Mask off check of frag_off as we only want fragment offset
      igb: Pull adapter out of main path in igb_xmit_frame_ring
      igb: Use rx/tx_itr_setting when setting up initial value of itr
      pci: Add SRIOV helper function to determine if VFs are assigned to guest
      igb: Use pci_vfs_assigned instead of igb_vfs_are_assigned

Alexandre Rames (2):
      sfc: Remove rx_alloc_method SKB
      sfc: Add AER and EEH support for Siena

Alexandru Copot (1):
      audit: pass int* to nlmsg_next

Alexandru Gheorghiu (2):
      Bluetooth: Use PTR_RET function
      Bluetooth: Replaced kzalloc and memcpy with kmemdup

Amerigo Wang (1):
      bridge: use ipv4_is_local_multicast() helper

Amir Vadai (5):
      net/mlx4_en: Add HW timestamping (TS) support
      net/mlx4_en: Support software timestamping
      net/mlx4_en: Add a service task
      net/mlx4_core: Disable HW timestamping for VFs
      net/mlx4_en: Disable HW clock overflow check when no HW support

Amitkumar Karwar (3):
      mwifiex: shorten the host sleep configuration macro names
      mwifiex: add "ethtool wol" command support
      mwifiex: add WOWLAN support

Amnon Paz (1):
      iwlwifi: fix indirect write bug

Andi Kleen (1):
      igb: limit udelay for phy changes to 10000us

Andre Guedes (14):
      Bluetooth: Rename hci_acl_disconn
      Bluetooth: Fix __hci_req_sync
      Bluetooth: Return ENODATA in hci_req_run
      Bluetooth: Check hci_req_run returning value in __hci_req_sync
      Bluetooth: HCI request error handling
      Bluetooth: Make hci_req_add returning void
      Bluetooth: Check req->err in hci_req_add
      Bluetooth: Fix HCI request framework
      Bluetooth: Fix hci_inquiry ioctl usage
      Bluetooth: Remove unneeded hci_req_cmd_status function
      Bluetooth: Change LE scanning timeout macros
      Bluetooth: Add LE scan type macros
      Bluetooth: Add macros for filter duplicates values
      Bluetooth: Rename LE_SCANNING_* macros

Andreas Fenkart (8):
      mwifiex: correct wrong list in list_empty check
      mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl
      mwifiex: fix infinite loop by removing NO_PKT_PRIO_TID
      mwifiex: hold proper locks when accessing ra_list / bss_prio lists
      mwifiex: replace ra_list_curr by list rotation.
      mwifiex: rework round robin scheduling of bss nodes.
      Bluetooth: btmrvl: release lock while waiting for fw download complete
      Bluetooth: btmrvl: report error if verify_fw_download times out

Andreea Hodea (1):
      eicon: Fixed checkpatch warning

Andrei Epure (3):
      wireless:rtlwifi: replaced kmalloc+memcpy with kmemdup
      ath: changed kmalloc to kmemdup
      iwlwifi: use kmemdup instead of kmalloc+memcpy

Andrey Vagin (2):
      net: prepare netlink code for netlink diag
      netlink: Diag core and basic socket info dumping (v2)

Andy Gospodarek (1):
      bond: add support to read speed and duplex via ethtool

Andy King (1):
      VSOCK: Split vm_sockets.h into kernel/uapi

Andy Shevchenko (4):
      net: core: let's use native isxdigit instead of custom
      ppp: reuse print_hex_dump_bytes
      ipw2x00: move to kstrto* functions
      Bluetooth: btmrvl: use native helpers for debugfs

Andy Zhou (1):
      openvswitch: datapath.h: Fix a stale comment.

Antonio Quartulli (7):
      batman-adv: don't use !! in bool conversion
      batman-adv: free an hard-interface before adding it
      batman-adv: update Makefile copyright years
      batman-adv: use seq_puts instead of seq_printf when the format is constant
      ip_gre: don't overwrite iflink during net_dev init
      batman-adv: use the proper header len when checking the TTVN
      batman-adv: fix global protection fault during soft_iface destruction

Arend van Spriel (67):
      brcmfmac: introduce tracepoints for message logging
      brcmfmac: make debug module parameter more clear
      brcmfmac: cleanup module information macros
      brcmfmac: remove null-pointer check in .sched_scan_start() callback
      brcmfmac: increase required skbuff headroom for firmware signalling
      brcmutil: add macros for setting bitfields using mask/shift operations
      brcmfmac: add support for TLV based firmware signalling
      brcmfmac: release transmit packet in brcmf_txcomplete()
      brcmfmac: assure brcmf_txcomplete() is called in failure paths
      brcmutil: add dequeue function with filtering
      brcmfmac: add parameter to brcmf_proto_hdrpush() for data offset
      brcmfmac: correct success flag passed by brcmf_sdbrcm_txpkt()
      brcmfmac: minor optimization of brcmf_sdbrcm_txpkt() function
      brcmfmac: use skb_cow() in brcmf_sdbrcm_txpkt() to assure alignment
      brcmfmac: hookup firmware signalling to firmware interface events
      brcmfmac: handle firmware signal for updating mac descriptor info
      brcmfmac: add handler for credit map firmware events
      brcmfmac: add firmware-signalling cleanup function
      brcmfmac: allow stopping netif queue for different reasons
      brcmfmac: add definitions for handling sk_buff control buffer data
      brcmfmac: perform filtered firmware-signalling cleanup upon DEL_IF
      brcmfmac: add firmware-signalling hanger functions
      brcmfmac: add optional bus callback definition for tx queue cleanup
      brcmfmac: add flow-control mode to firmware signalling
      brcmfmac: enable tx status signalling
      brcmfmac: fix handling sk_buff cleanup upon bus tx failure
      brcmfmac: avoid error output in receive path
      brcmfmac: add dedicated log level for low-level sdio debugging
      brcmfmac: initialize struct brcmf_fws_info fields before iovar
      brcmfmac: correct specified length from FIFOCREDITBACK signal
      brcmfmac: move brcmf_fws_{de,}init() functions
      brcmfmac: only allocate firmware-signalling resources if required
      brcmfmac: no flow-control tlv signals when fcmode is NONE
      brcmfmac: enable sk_buff queueing when credits deplete
      brcmfmac: fix unaligned access in TXSTATUS signal handling
      brcmfmac: handle firmware signalling destination entry state
      brcmfmac: handle firmware signals requesting for packets
      brcmfmac: add hexadecimal trace of message payload
      brcmfmac: add role attribute to struct brcmf_if_event definition
      brcmfmac: remove condition for calling event handler
      brcmfmac: remove use of unconditional access of struct wireless_dev::netdev
      brcmfmac: use struct brcmf_if instance as parameter in brcmf_set_mpc()
      brcmfmac: use struct brcmf_if instance iso netdevice in escan functions
      brcmfmac: support creation of P2P_DEVICE through user-space
      brcmfmac: wait for firmware event when creating P2P_DEVICE interface
      brcmfmac: fix reception of P2P probe requests on P2P_DEVICE interface
      brcmfmac: obtain wdev using vif object in action frame rx
      brcmfmac: only use ifidx from BDC header in brcmf_rx_frames()
      brcmfmac: obtain iftype for firmware-signal descriptor lookup
      brcmfmac: pass ifp pointer in brcmf_fws_find_mac_desc()
      brcmfmac: rename brcmf_fws_mac_desc_ready()
      brcmfmac: remove ifidx variable from brcmf_fws_process_skb()
      cfg80211: introduce critical protocol indication from user-space
      brcmfmac: reinitialize dequeue mask per node
      brcmfmac: check memory allocation in brcmf_add_if()
      brcmfmac: remove error message upon allocation failure
      brcmutil: simplify brcmu_pkt_free_skb()
      brcmfmac: destination mac closed when interface is closed
      brcmfmac: schedule dequeue upon firmware-signal reception
      brcmfmac: use lock in brcmf_fws_del_interface()
      brcmfmac: finalize transmit upon any rollback failure
      brcmfmac: change return type for brcmf_rollback_toq() to void
      brcmfmac: stop dequeue upon sk_buff commit failure
      brcmfmac: allow scanning to be suppressed in the driver
      brcmfmac: flush queue upon MACDESC_DEL firmware signal
      brcmfmac: correct error handling in brcmf_fws_init()
      brcmfmac: add credit borrowing mechanism

Ariel Elior (7):
      bnx2x: Set ethtool ops for vfs
      bnx2x: Prevent "Unknown MF" print in SF mode
      bnx2x: Add iproute2 support for vfs
      bnx2x: Control number of vfs dynamically
      bnx2x: missing ARI should not be lethal
      bnx2x: Fix VF statistics
      bnx2x: Fix VF outer vlan removal

Arik Nemtsov (8):
      wlcore: fix link count in single-link-PSM optimization
      wlcore: don't risk using stale HLID during .sta_state callback
      wlcore: consolidate tx_seq handling on recovery
      wlcore: change warn on missing lock in wlcore_queue_xx funcs
      wlcore: free AP global links properly on recovery
      wlcore: AP-mode - recover security seq num for stations
      wlcore: correctly check state before regdomain conf
      wlcore: consider dummy packets when tx queues are empty

Arnd Bergmann (1):
      atm: he: use mdelay instead of large udelay constants

Arvind Bhushan (4):
      csiostor: Segregate T4 adapter operations.
      csiostor: Add T5 adapter operations.
      csiostor: Header file modifications for chip support and bug fixes.
      csiostor: Cleanup chip specific operations.

Ashok Nagarajan (1):
      mwifiex: Trigger a card reset on reaching tx_timeout threshold

Asias He (1):
      VSOCK: Fix misc device registration

Atzm Watanabe (1):
      vxlan: Allow setting destination to unicast address.

Avinash Patil (7):
      mwifiex: modify skb->truesize for PCIE Rx
      mwifiex: do not enable PCIe interrupt in Power Save sleep state
      mwifiex: avoid waking up device in awake state
      mwifiex: use fw_status register to wake up PCIe card
      mwifiex: change default tx/rx win_size for BA setup
      mwifiex: use separate AMPDU tx/rx window sizes in 11ac networks
      mwifiex: use PCI_DMA_FROMDEVICE for RX queue de-init

Baker Zhang (1):
      xfrm: use xfrm direction when lookup policy

Ben Greear (6):
      ath9k: Report txerr-filtered errors in debugfs.
      ath9k: Report rx-crc-errors in ethtool stats.
      mac80211: make beacon-loss-count configurable
      mac80211: add beacon stats to debugfs
      mac80211: be more careful about sending beacon-loss-events
      ath: Let user know which keycache method is complaining.

Ben Hutchings (18):
      Merge branch 'sfc-3.9' into master
      sfc: Allow efx_channel_type::receive_skb() to reject a packet
      sfc: More sensible semantics for efx_filter_insert_filter() replace flag
      sfc: Remove redundant parameter to efx_filter_search()
      sfc: Don't use efx_filter_{build,hash,increment}() for default MAC filters
      sfc: Merge efx_filter_search() into efx_filter_insert()
      sfc: Fix replacement detection in efx_filter_insert_filter()
      sfc: Disable RSS when using SR-IOV and only 1 RX queue on the PF
      sfc: Document current usage of efx_rx_buffer::len and efx_nic::rx_buffer_len
      sfc: Properly distinguish RX buffer and DMA lengths
      sfc: Make RX queue descriptor counts unsigned for consistency
      sfc: Wrap __efx_rx_packet() with efx_rx_flush_packet()
      sfc: Replace efx_rx_buf_eh() with simpler efx_rx_buf_va()
      sfc: Explicitly prefetch RX hash prefix, not just Ethernet heade
      sfc: Update RX buffer address together with length
      sfc: Enable RX DMA scattering where possible
      sfc: Replace efx_rx_is_last_buffer() with a flag
      sfc: Fix naming of MTD partitions for FPGA bitfiles

Ben Pfaff (1):
      openvswitch: Allow OVS_USERSPACE_ATTR_USERDATA to be variable length.

Beni Lev (2):
      iwlwifi: 7000: disable HT greenfield support
      iwlwifi: disable greenfield transmissions as a workaround

Benjamin Poirier (3):
      unix/dgram: peek beyond 0-sized skbs
      unix/dgram: fix peeking with an offset larger than data in queue
      unix/stream: fix peeking with an offset larger than data in queue

Bhanu Prakash Gollapudi (1):
      bnx2x, bnx2fc: Use per port max exchange resources

Bing Zhao (11):
      mwifiex: remove static forward declarations in pcie.c
      mwifiex: fix [-Wunused-function] warnings on pcie suspend/resume
      mwifiex: avoid [-Wmaybe-uninitialized] warnings in pcie.c
      mwifiex: fix potential null dereference 'mef_entry'
      mwifiex: fix negative cmd_pending count
      mwifiex: configure p2p interface during initialization
      mwifiex: correct bss_mode check while appending vht operation IE
      mwifiex: make use of msecs_to_jiffies()
      mwifiex: don't try to associate when bss_mode is not STA
      mwifiex: fix use-after-free in beacon_ie processing
      mwifiex: remove redundant initialization for bss_descriptor

Bj√∏rn Mork (2):
      net: cdc_ncm: demote "unexpected notification" to debug level
      net: cdc_ether: silence sparse __CHECK_ENDIAN__ warning

Bob Copeland (3):
      ath9k: simplify ATH_EP_RND
      mac80211: return new mpath from mesh_path_add()
      mac80211: use synchronize_rcu() with rcu_barrier()

Bruce Allan (24):
      e1000e: cleanup CODE_INDENT checkpatch errors
      e1000e: cleanup SPACING checkpatch errors and warnings
      e1000e: cleanup LONG_LINE checkpatch warnings
      e1000e: cleanup LEADING_SPACE checkpatch warnings
      e1000e: cleanup PARENTHESIS_ALIGNMENT checkpatch checks
      e1000e: cleanup SPACING checkpatch checks
      e1000e: cleanup (add/remove) blank lines where appropriate
      e1000e: cleanup unusually placed comments
      e1000e: cleanup formatting of static structs
      e1000e: cleanup unnecessary line breaks
      e1000e: cleanup USLEEP_RANGE checkpatch checks
      e1000e: cleanup format of struct e1000_opt_list struct
      e1000e: cleanup - move defines to appropriate header file
      e1000e: additional error handling on PHY register accesses
      e1000e: slow performance between two 82579 connected via 10Mbit hub
      e1000e: fix LED blink logic for designs with LEDs driven by cathode
      e1000e: long access timeouts when I217/I218 MAC and PHY are out of sync
      e1000e: EEE capability advertisement not set/disabled as required
      e1000e: enable EEE by default
      e1000e: add support for LTR on I217/I218
      e1000e: cleanup unused defines
      e1000e: increase driver version number
      e1000e: fix scheduling while atomic bugs
      e1000e: panic caused by Rx traffic arriving while interface going down

Byungho An (1):
      stmmac: modified pcs mode support for SGMII

Carolyn Wyborny (3):
      igb: Add support for i354 devices
      igb: Remove id's that will not be productized for Linux.
      igb: Bump version of driver

Chan-yeol Park (3):
      Bluetooth: Fix H4 crash from incoming UART packets
      Bluetooth: Fix possible NULL dereference in hci_uart_tty_receive
      Bluetooth: Remove trivial white space

Chen Gang (5):
      drivers/net/wireless/ath/wil6210: Makefile, only -Werror when no -W* in EXTRA_CFLAGS
      include/linux: printk is needed in filter.h when CONFIG_BPF_JIT is defined
      ISDN:divert: beautify code: useless 'break', 'return (0)', additional comments.
      net: ipv4: typo issue, remove erroneous semicolon
      net: mac802154: comparision issue of type cast, finding by EXTRA_CFLAGS=-W

Chen, Chien-Chia (1):
      rtlwifi: rtl8188ee: Fix wrong header patch

Chris Metcalf (1):
      dynticks: avoid flow_cache_flush() interrupting every core

Christian Lamparter (2):
      carl9170: fix frame drop and WARN due to minstrel_ht change
      carl9170: remove fast channel change feature

Christoph Paasch (2):
      tcp: Remove unused tw_cookie_values from tcp_timewait_sock
      tcp: Remove TCPCT

Chun-Yeow Yeoh (1):
      mac80211: fix the PREP mesh hwmp debug message

Claudio Takahasi (5):
      Bluetooth: Fix SCO connection reference
      Bluetooth: Use GFP_KERNEL in sco_conn_add
      Bluetooth: Minor coding style fix
      Bluetooth: Remove unneeded parameter
      Bluetooth: Reject SCO when hci connection timeouts

Claudiu Manoil (7):
      gianfar: Fix tx napi polling
      gianfar: Poll only active Rx queues
      gianfar: Remove redundant programming of [rt]xic registers
      gianfar: Refactor config coalescing calls for all queues
      gianfar: Remove 'maybe-uninitialized' compile warning
      gianfar: Cleanup dead code and minor formatting
      gianfar: Remove superfluous kernel_dropped local counter

Colin Ian King (1):
      yam: remove redundant null check on dev

Cong Wang (6):
      tunnel: use iptunnel_xmit() again
      ipv6: introduce ip6tunnel_xmit() helper
      net: fix some typos in netif features
      ip_gre: increase inner ip header ID during segmentation
      udp: increase inner ip header ID during segmentation
      802: fix a possible race condition

Craig Hada (1):
      be2net: enable IOMMU pass through for be2net

Dan Carpenter (12):
      ray_cs: read past the end of the array
      ath6kl: small cleanup in ath6kl_htc_pipe_rx_complete()
      ath6kl: small cleanup in ath6kl_htc_pipe_rx_complete()
      l2tp: calling the ref() instead of deref()
      ath9k: use GFP_ATOMIC under spinlock
      ipvs: off by one in set_sctp_state()
      netfilter: nf_nat: missing condition in nf_xfrm_me_harder()
      appletalk: info leak in ->getname()
      netrom: info leak in ->getname()
      isdn: mISDN: set ->family in ->getname()
      NFC: llcp: two bugs in ->getname()
      net: calxedaxgmac: fix condition in xgmac_set_features()

Daniel Baluta (1):
      net: fix psock_fanout selftest bind error message

Daniel Borkmann (35):
      net: flow_dissector: add __skb_get_poff to get a start offset to payload
      filter: add ANC_PAY_OFFSET instruction for loading payload start offset
      filter: add minimal BPF JIT image disassembler
      filter: bpf_jit_comp: refactor and unify BPF JIT image dump output
      doc: packet: add minimal TPACKET_V3 example code
      selftests: net: add PF_PACKET TPACKET v1/v2/v3 selftests
      net: ipv6: add tokenized interface identifier support
      net: ipv6: minor: use in6addr_any in token init
      net: ipv6: also allow token to be set when device not ready
      net: ipv6: only invalidate previously tokenized addresses
      net: sctp: introduce uapi header for sctp
      net: sock: make sock_tx_timestamp void
      net: tcp_memcontrol: minor: remove unused variable
      net: sctp: remove sctp_ep_common struct member 'malloced'
      net: sctp: minor: make sctp_ep_common's member 'dead' a bool
      packet: minor: add generic tpacket_uhdr to access packet headers
      net: sctp: sctp_ssnmap: remove 'malloced' element from struct
      net: sctp: sctp_inq: remove dead code
      net: sctp: sctp_outq: remove 'malloced' from its struct
      net: sctp: outqueue: simplify sctp_outq_uncork function
      net: sctp: sctp_transport: remove unused variable
      net: sctp: sctp_bind_addr: remove dead code
      net: sctp: sctp_ulpq: remove 'malloced' struct member
      net: socket: move ktime2ts to ktime header api
      packet: move hw/sw timestamp extraction into a small helper
      net: sctp: minor: remove dead code from sctp_packet
      packet: enable hardware tx timestamping on tpacket ring
      packet: minor: convert status bits into shifting format
      packet: if hw/sw ts enabled in rx/tx ring, report which ts we got
      packet: doc: update timestamping part
      packet: reorder a member in packet_ring_buffer
      packet: account statistics only in tpacket_stats_u
      selftests: psock_tpacket: fix status check
      netlink: kconfig: move mmap i/o into netlink kconfig
      net: sctp: attribute printl with __printf for gcc fmt checks

Daniel Pieczko (2):
      sfc: reuse pages to avoid DMA mapping/unmapping costs
      sfc: allocate more RX buffers per page

David Daney (1):
      netdev/phy: Implement ieee802.3 clause 45 in mdio-octeon.c

David Herrmann (20):
      Bluetooth: discard bt_sock_unregister() errors
      Bluetooth: change bt_sock_unregister() to return void
      Bluetooth: hidp: remove redundant error message
      Bluetooth: hidp: verify l2cap sockets
      Bluetooth: rename hci_conn_put to hci_conn_drop
      Bluetooth: remove unneeded hci_conn_hold/put_device()
      Bluetooth: introduce hci_conn ref-counting
      Bluetooth: hidp: remove unused session->state field
      Bluetooth: hidp: test "terminate" before sleeping
      Bluetooth: allow constant arguments for bacmp()/bacpy()
      Bluetooth: hidp: move hidp_schedule() to core.c
      Bluetooth: l2cap: introduce l2cap_conn ref-counting
      Bluetooth: l2cap: add l2cap_user sub-modules
      Bluetooth: hidp: add new session-management helpers
      Bluetooth: hidp: remove old session-management
      Bluetooth: hidp: handle kernel_sendmsg() errors correctly
      Bluetooth: hidp: merge hidp_process_{ctrl,intr}_transmit()
      Bluetooth: hidp: merge 'send' functions into hidp_send_message()
      Bluetooth: hidp: don't send boot-protocol messages as HID-reports
      Bluetooth: hidp: fix sending output reports on intr channel

David J. Choi (1):
      ks8851_mll: basic ethernet statistics

David S. Miller (70):
      Merge branch 'fdb'
      Merge branch 'tg3'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Revert "eicon: Fixed checkpatch warning"
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'cpsw'
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      net: Add socket() system call self test.
      net: Fix failure string in net-socket selftests Makefile.
      net: Get rid of compat defines in psock_fanout.c selftest.
      Merge git://git.kernel.org/.../davem/net
      net: Move selftests to common net/ subdirectory.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next into wireless
      Merge branch 'mv643xx_eth'
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'firewire-net-resource-mgt' of git://git.kernel.org/.../ieee1394/linux1394
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      net: Print functions in /proc/net/ptype without the offset.
      Merge branch 'tunnels'
      Merge branch 'ipv6-firewire'
      Merge branch '6lowpan'
      Merge branch 'transport-header'
      Merge branch 'stmmac'
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'tg3'
      Merge branch 'wireless'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Revert "netprio_cgroup: make local table static"
      Merge branch 'sync_multiple'
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'tipc-ipoib'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'intel'
      Merge branch '8021ad'
      Merge branch 'netlink-mmap'
      Merge branch 'qlcnic'
      net: Add missing netdev feature strings for NETIF_F_HW_VLAN_STAG_*
      net: Add .gitignore to networking selftests directory.
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      net: Fix some __vlan_hwaccel_put_tag() callers.
      net: Fix vlan bitmask changes in EHEA driver.
      Merge git://git.kernel.org/.../davem/net
      netlink: Fix build with mmap disabled.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'mlx4'
      Merge branch 'bnx2x'
      Merge branch 'qlcnic'
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'af_packet-timestamp'
      Merge tag 'batman-adv-fix-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'mlx4'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'pktdiag'
      Merge branch 'pegasus'
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge branch 'vxlan_bnx2x_offload'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'bnx2x'

David Stevens (2):
      vxlan: generalize forwarding tables
      VXLAN: Allow L2 redirection with L3 switching

Dean Jenkins (6):
      Bluetooth: Avoid rfcomm_session_timeout using freed session
      Bluetooth: Check rfcomm session and DLC exists on socket close
      Bluetooth: Return RFCOMM session ptrs to avoid freed session
      Bluetooth: Remove RFCOMM session refcnt
      Bluetooth: Remove redundant call to rfcomm_send_disc
      Bluetooth: Remove redundant RFCOMM BT_CLOSED settings

Denis Kirjanov (1):
      sis900: check for DMA map errors

Devendra Naga (2):
      cdc_ncm: return -ENOMEM if kzalloc fails
      tlan: cancel work at remove path

Dilip Daya (1):
      sctp: Add buffer utilization fields to /proc/net/sctp/assocs

Dmitry Kravkov (17):
      bnx2x: use FW 7.8.17
      bnx2x: Restore FCoE 4-port devices support
      bnx2x: add CSUM and TSO support for encapsulation protocols
      bnx2x: add RSS capability for GRE traffic
      bnx2x: increase inner ip id during encapsulated tso
      bnx2x: Prevent VF race
      bnx2x: fix compilation without CONFIG_BNX2X_SRIOV
      bnx2x: refactor nvram read procedure
      bnx2x: fix byte-by-byte nvram write for BE machines
      bnx2x: remove non-necessary assignment
      bnx2x: add additional regions for CRC memory test
      bnx2x: allow nvram test to run when device is down
      bnx2x: update version to 1.78.17-0
      bnx2x: Enhance MAC configuration for VFs
      vxlan: do not set SKB_GSO_UDP
      bnx2x: allow handling tunnel over udp offload
      Revert "bnx2x: allow nvram test to run when device is down"

Don Skidmore (6):
      ixgbe: fix MNG FW support when adapter not up
      ixgbe: Fix 1G link WoL
      ixgbe: bump version number
      ixgbe: fix possible divide by zero in ixgbe_update_itr
      ixgbe: add driver support for x520 OCP adapter.
      ixgbe: add SFP+ LX module support

Dor Shaish (2):
      iwlwifi: mvm: don't use cts to self
      iwlwifi: mvm: Change NVM default section read size

Emil Tantilov (6):
      ixgbe: don't do arithmetic operations on bitmasks
      ixgbe: add WOL support for new subdevice ID
      ixgbe: fix register access during ethtool loopback test
      ixgbe: cache AUTOC reads
      ixgbe: add support for disabling link at boot time on 82599
      ixgbe: add mac type to the version in ethtool_regs

Emmanuel Grumbach (37):
      iwlwifi: a few fixes in license
      iwlwifi: mvm: respect disable Tx AGG parameter
      iwlwifi: mvm: free AGG queue when we STA is removed
      iwlwifi: mvm: support IEEE80211_AMPDU_TX_STOP_FLUSH
      iwlwifi: dvm: pad iwl_compressed_ba_resp
      iwlwifi: make device configuration bus agnostic
      iwlwifi: mvm: add CARD_STATE_NOTIFICATION to the cmd strings
      iwlwifi: mvm: add BT Coex FW API
      iwlwifi: mvm: begin basic BT-Coex implementation
      iwlwifi: mvm: handle BT-coex notification
      iwlwifi: mvm: update SMPS when BT gets active
      iwlwifi: mvm: export last bt_notif through debugfs
      iwlwifi: mvm: update firmware API - MAC ID in RX
      iwlwifi: move firmware restart debugfs hook to op_mode
      iwlwifi: mvm: the SCD byte count is a TLV flag
      iwlwifi: mvm: MVM op_mode is supported on 7000 only
      iwlwifi: mvm: fix the {ack,cts}_kill_msk
      iwlwifi: mvm: don't support multi-channel inhibition
      iwlwifi: mvm: print the flags in ALIVE notification
      iwlwifi: add debug message when a CMD is dropped in RFKILL
      iwlwifi: mvm: take the radio type / step / dash from TLVs
      iwlwifi: mvm: take the valid_{rx,tx}_ant from the TLV
      iwlwifi: mvm: tune the move to static SMPS due to BT load
      mac80211: return the RSSI in dBm
      iwlwifi: mvm: ignore bt_ch_announce module parameter
      iwlwifi: mvm: split long debug print
      iwlwifi: mvm: implement reduced Tx power
      iwlwifi: mvm: remove BT Coex constraints upon roaming to A band
      iwlwifi: mvm: beautify code in BT Coex
      iwlwifi: mvm: clean up invalid station handling
      iwlwifi: mvm: rename iwl_mvm_new_bt_coex_notif
      iwlwifi: mvm: remove users of nvm_data->valid_tx_ant
      iwlwifi: dvm: handle FLUSH ampdu actions from mac80211
      iwlwifi: mvm: remove TODO which has been addressed
      iwlwifi: mvm: fix first_antenna
      iwlwifi: dvm: don't send zeroed LQ cmd
      iwlwifi: add a subdevice ID for 7000 series

Eric Dumazet (22):
      net: introduce NAPI_POLL_WEIGHT
      bnx2x: use the default NAPI weight
      htb: add HTB_DIRECT_QLEN attribute
      tcp: uninline tcp_prequeue()
      ipv6 flowlabel: add __rcu annotations
      netfilter: nfnetlink_queue: zero copy support
      chelsio: add headroom in RX path
      net: reorder some fields of net_device
      macvlan: use the right RCU api
      bridge: remove a redundant synchronize_net()
      ip_gre: fix a possible crash in parse_gre_header()
      act_csum: fix possible use after free
      tcp: GSO should be TSQ friendly
      tcp: tcp_tso_segment() small optimization
      tcp: introduce TCPSpuriousRtxHostQueues SNMP counter
      net: remove a stale comment for dl_next
      tcp: force a dst refcount when prequeue packet
      net: remove redundant code in dev_hard_start_xmit()
      net: defer net_secret[] initialization
      net: Add MIB counters for checksum errors
      mlx4_en: fix a build error on 32bit arches
      af_unix: fix a fatal race with bit fields

Eric Lapuyade (1):
      NFC: mei: Add a common mei bus API for NFC drivers

Eric W. Biederman (1):
      scm: Stop passing struct cred

Erwan Yvin (1):
      caif: remove caif_shm

Eugenia Emantayev (3):
      net/mlx4_en: set correct MTU in SRIOV
      net/mlx4_core: Add timestamping device capability
      net/mlx4_core: Read HCA frequency and map internal clock

Eyal Shapira (1):
      wlcore: don't attempt to roam in case of p2p

Eytan Lifshitz (1):
      iwlwifi: mvm: advertise VHT capabilities

Fabio Estevam (11):
      fec: Remove unused pci header
      fec: Use devm_request_and_ioremap()
      fec: Fix PHC device log
      can: mcp251x: Remove unneeded PM_OPS definitions
      atl1: Remove unneeded PM_OPS definitions
      tg3: Remove unneeded PM_OPS definitions
      xgmac: Remove unneeded PM_OPS definitions
      ks8851: Remove unneeded PM_OPS definitions
      fec: Use SIMPLE_DEV_PM_OPS
      atl1: Protect atl1_suspend with CONFIG_PM_SLEEP
      fec: Remove unneeded asm header files

Felix Fietkau (26):
      ieee80211: mark 802.11 related structs as being 2-byte aligned
      mac80211/minstrel_ht: improve accuracy of throughput metric at high data rates
      mac80211/minstrel_ht: improve max_prob_rate selection
      minstrel_ht: increase sampling frequency
      mac80211/minstrel_ht: increase sampling frequency of some slower rates
      mac80211/minstrel_ht: fix spacing between sample attempts
      mac80211/minstrel_ht: disable multiple consecutive sample attempts
      mac80211/minstrel_ht: improve rate selection stability
      mac80211/minstrel_ht: avoid useless sampling of high-probability slower rates
      mac80211/minstrel_ht: do not sample actively used rates
      ath9k_hw: clean up RF Bank6 handling on AR5416/AR91xx
      ath9k_hw: make various ar5416/ar91xx rf banks const
      ath9k_common: remove ath9k_cmn_padpos
      ath9k: improve dma map failure handling
      ath9k: fix handling of broken descriptors
      ath9k: detect more kinds of invalid descriptors
      ath9k: implement buffer holding handling for EDMA FIFO
      mac80211: fix and optimize MCS mask handling
      mac80211: fix CTS protection handling
      mac80211: improve the rate control API
      mac80211/minstrel_ht: use the new rate control API
      mac80211/minstrel: use the new rate control API
      ath: update hardware mac address with bssid mask
      ath9k: always set common->macaddr to the MAC adress of a virtual interface
      ath9k: merge ath_tx_start_dma into ath_tx_start
      ath9k: add support for the new rate control API

Fengguang Wu (1):
      Bluetooth: hci_get_cmd_complete() can be static

Fernando Luis Vazquez Cao (1):
      net: clean leftover of COMPAT_NET_DEV_OPS removal

Flavio Leitner (3):
      tcp: ipv6: bind() use stronger condition for bind_conflict
      tg3: shows HW time stamping support only if ptp_capable is present
      tg3: fix to append hardware time stamping flags

Florian Fainelli (9):
      r6040: check MDIO register busy waiting result
      net: mvmdio: allow platform device style registration
      net: mvmdio: rename base register cookie from smireg to regs
      net: mvmdio: enhance driver to support SMI error/done interrupts
      mv643xx_eth: convert to use the Marvell Orion MDIO driver
      dsa: add device tree bindings to register DSA switches
      dsa: fix device tree binding documentation typo on #address-cells
      dsa: factor freeing of dsa_platform_data
      dsa: fix freeing of sparse port allocation

Florian Westphal (5):
      netfilter: xt_rpfilter: depend on raw or mangle table
      netfilter: nf_queue: move device refcount bump to extra function
      netfilter: move skb_gso_segment into nfnetlink_queue module
      netfilter: nfnetlink_queue: add skb info attribute
      netfilter: nfnetlink_queue: avoid expensive gso segmentation and checksum fixup

Frank Li (1):
      net: fec: build fec.c and fec_ptp.c to one module

Franky Lin (6):
      brcmfmac: aggregate dongle ram access interface
      brcmfmac: move chip download state code to sdio_chip.c
      brcmutil: add new d11 interface support
      brcmfmac: adopt new d11 interface
      brcmfmac: add support for dongle ARM CR4 core
      brcmfmac: add BCM4335 sdio interface support

Fr√©d√©ric Dalleau (1):
      Bluetooth: Move and rename hci_conn_accept

Gabor Juhos (10):
      rt2x00: introduce rt2x00_set_{rt,rf} helpers
      rt2x00: rt2800lib: separate RT and RF chipset detection
      rt2x00: rt2800lib: probe RT chipset earlier
      rt2x00: rt2x00mmio: use rt2x00mmio prefix in function names
      rt2x00: rt2400pci: use the rt2x00mmio_* routines
      rt2x00: rt2500pci: use the rt2x00mmio_* routines
      rt2x00: rt61pci: use the rt2x00mmio_* routines
      rt2x00: rt2800pci: use the rt2x00mmio_* routines
      rt2x00: rt2x00mmio: remove unused rt2x00pci_* defines
      rt2x00: rt2800lib: rename rt2800_init_bbb_early to rt2800_init_bbp_early

Gao feng (12):
      netfilter: ebt_ulog: remove unnecessary spin lock protection
      netfilter: use IS_ENABLE to replace if defined in TRACE target
      netfilter: make /proc/net/netfilter pernet
      netfilter: nf_log: prepare net namespace support for loggers
      netfilter: ebt_log: add net namespace support for ebt_log
      netfilter: xt_LOG: add net namespace support for xt_LOG
      netfilter: ebt_ulog: add net namespace support for ebt_ulog
      netfilter: ipt_ULOG: add net namespace support for ipt_ULOG
      netfilter: nfnetlink_log: add net namespace support for nfnetlink_log
      netfilter: enable per netns support for nf_loggers
      netfilter: nfnetlink_queue: add net namespace support for nfnetlink_queue
      net: tun: release the reference of tun device in tun_recvmsg

Geert Uytterhoeven (2):
      VSOCK: Drop bogus __init annotation from vsock_init_tables()
      isdn/sc: Fix incorrect module_param_array types

Geoff Levand (1):
      net: Fix p3_gelic_net sparse warnings

Giuseppe CAVALLARO (10):
      stmmac: reorganize chain/ring modes removing Koptions
      stmmac: support extend descriptors
      stmmac: start adding pcs and rgmii core irq
      stmmac: initial support to manage pcs modes
      stmmac: update the Doc and Version (PTP+SGMII)
      stmmac: review driver documentation
      stmmac: improve/review and fix kernel-doc
      stmmac: code tidy-up
      stmmac: review private structure fields
      stmmac: prefetch all dma_erx when use extend_desc

Greg Rose (3):
      ixgbe: Don't give VFs random MAC addresses
      ixgbevf: Adjust to handle unassigned MAC address from PF
      igb: Retain HW VLAN filtering while in promiscuous + VT mode

Guenter Roeck (5):
      of_net.h: Provide empty functions if OF_NET is not configured
      net/cadence/at91_ether: Simplify OF dependencies
      net/cadence/macb: Simplify OF dependencies
      net/freescale/fec: Simplify OF dependencies
      net/nxp/lpc_eth: Drop ifdef CONFIG_OF_NET

Gustavo Padovan (1):
      Bluetooth: remove unneeded var initialization in btmrvl

Hadar Hen Zion (2):
      net/mlx4_core: Add helper function to translate B0 steering rules to DMFS
      net/mlx4_core: Translate guest B0 steering rules to DMFS

Haiyang Zhang (1):
      hyperv: Fix a compiler warning in netvsc_send()

Han Shen (1):
      rtl8192c:dm: Properly initialize local array and set value.

Hannes Frederic Sowa (7):
      ipv6: introdcue __ipv6_addr_needs_scope_id and ipv6_iface_scope_id helper functions
      ipv6: use newly introduced __ipv6_addr_needs_scope_id and ipv6_iface_scope_id
      ipv6: report sin6_scope_id if sockopt RECVORIGDSTADDR is set
      netfilter: nf_ct_ipv6: use ipv6_iface_scope_id in conntrack to return scope id
      inet: generalize ipv4-only RFC3168 5.3 ecn fragmentation handling for future use by ipv6
      ipv6: implement RFC3168 5.3 (ecn protection) for ipv6 fragmentation handling
      netfilter: implement RFC3168 5.3 (ecn protection) for ipv6 fragmentation handling

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Hante Meuleman (4):
      brcmfmac: determine the wiphy->bands property correctly.
      brcmfmac: Add 43143 SDIO support.
      brcmfmac: Add drive strength programming for SDIO 43143.
      brcmfmac: define and use platform specific data for SDIO.

Hauke Mehrtens (32):
      ssb: fix unaligned access to mac address
      brcmsmac: export firmware version to ethtool
      b43: use bcma_chipco_gpio_control()
      ssb: fix sprom constant for ant_available_{bg,a}
      ssb: read additional sprom v2 and v3 attributes.
      b43: remove warning for LP-PHY with sprom < 8
      b43: use constants
      brcmsmac: implement ieee80211_ops get_tsf and set_tsf
      brcmsmac: add interface type to brcms_bss_cfg
      brcmsmac: remove brcms_bss_cfg->BSS
      brcmsmac: remove brcms_bss_cfg->associated
      brcmsmac: remove brcms_bss_cfg->enable
      brcmsmac: remove brcms_bss_cfg->up
      brcmsmac: remove brcms_bss_cfg->cur_etheraddr
      brcmsmac: remove brcms_pub->bcmerr
      brcmsmac: write beacon period to hardware
      brcmsmac: add beacon template support
      brcmsmac: react on changing SSID
      brcmsmac: add support for probe response template
      brcmsmac: deactivate ucode sending probe responses
      brcmsmac: activate AP support
      brcmsmac: add support for adhoc mode
      bcma: mark eromptr as __iomem
      bcma: use BCMA_CC_PMU_CTL_* constants
      bcma: handle more devices in bcma_pmu_get_alp_clock()
      bcma: export bcma_chipco_get_alp_clock()
      bcma: export some gpio functions
      brcmsmac: remove some pmu functions and use the bcma equivalents
      b43: mark some functions and structs static
      b43: make struct b2056_inittabs_pts const
      b43: use bcma_pmu_spuravoid_pllupdate()
      ssb: implement ssb spuravoid for chipid BCM43222

Hector Palacios (2):
      phy/micrel: Add support for KSZ8031
      phy/micrel: move flag handling to function for common use

Helmut Schaa (2):
      rt2x00: Revert "rt2x00: remove unused argument"
      rt2x00: Fix tx status reporting for reordered frames in rt2800pci

Himanshu Madhani (6):
      qlcnic: Enable LED test support for 83xx adapter
      qlcnic: Implement flash sysfs callback for 83xx adapter
      qlcnic: Log warning message for 83xx adapter in MSI mode.
      qlcnic: Enable Interrupt Coalescing for 83xx adapter
      qlcnic: Rename the IRQ description.
      qlcnic: Add identifying string for 83xx adapter

Hong zhi guo (11):
      bridge: avoid br_ifinfo_notify when nothing changed
      netlink: have length check of rtnl msg before deref
      netlink: remove duplicated NLMSG_ALIGN
      net-next: replace obsolete NLMSG_* with type safe nlmsg_*
      audit: replace obsolete NLMSG_* with type safe nlmsg_*
      selinux: replace obsolete NLMSG_* with type safe nlmsg_*
      gdm72xx: replace obsolete NLMSG_* with type safe nlmsg_*
      scsi: replace obsolete NLMSG_* with type safe nlmsg_*
      connector: replace obsolete NLMSG_* with type safe nlmsg_*
      bridge: remove unused variable ifm
      netlink: fix the warning introduced by netlink API replacement

Igal Chernobelsky (2):
      wlcore: enter elp in force ps mode in 5ms
      wlcore: set max num of Rx BA sessions per chip

Ilan Peer (10):
      mac80211: Allow drivers to differentiate between ROC types
      iwlwifi: mvm: Update MAC context filter flags
      iwlwifi: mvm: Add support for additional addresses
      mac80211: Call drv_set_tim only if there is a change
      iwlwifi: mvm: Add beacon notification handler
      iwlwifi: mvm: Remove obsolete queue definitions
      iwlwifi: mvm: Fix quota handling for monitor interface
      iwlwifi: mvm: Increase the max remain on channel time
      iwlwifi: mvm: Add support for different ROC types
      iwlwifi: mvm: Sync FW API time event notification change

Ivan Vecera (1):
      be2net: remove unused variable 'sge'

Jacob Keller (7):
      net: fix smatch warnings inside datagram_poll
      ixgbe: Enable support for recognizing PCI-e Gen3 link speed
      ixgbe: create conversion functions from link_status to bus/speed
      ixgbe: enable devices with internal switch to read pci parent
      ixgbe: Add support for WoL on 82599 SFP+ LOM
      ixgbe: rename wol_supported to more fitting wol_enabled
      ixgbe: fix EICR write in ixgbe_msix_other

Jaganath Kanakkassery (1):
      Bluetooth: Fix incorrect SSP mode bit for non SSP devices

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables

Janusz Dziedzic (3):
      cfg80211: add P2P Notice of Absence attribute
      mac80211: use ieee80211_p2p_noa_attr structure
      mac80211: add P2P NoA settings

Jarno Rajahalme (2):
      linux/openvswitch.h: Make OVSP_LOCAL 32-bit.
      openvswitch: Change ENOENT return value to ENODEV in lookup_vport().

Jason Wang (13):
      macvtap: set transport header before passing skb to lower device
      tuntap: set transport header before passing it to kernel
      packet: set transport header before doing xmit
      netback: set transport header before passing it to kernel
      net_sched: better precise estimation on packet length for untrusted packets
      net: core: let skb_partial_csum_set() set transport header
      net: core: introduce skb_probe_transport_header()
      net: switch to use skb_probe_transport_header()
      vhost_net: remove tx polling state
      virtio-net: initialize vlan_features
      tuntap: initialize vlan_features
      xen-netback: switch to use skb_partial_csum_set()
      tuntap: correct the return value in tun_set_iff()

Jeff Kirsher (1):
      igb: Fix code comments and whitespace

Jesper Dangaard Brouer (4):
      net: frag, avoid several CPUs grabbing same frag queue during LRU evictor loop
      net: use the frag lru_lock to protect netns_frags.nqueues update
      net: frag queue per hash bucket locking
      net: increase frag hash size

Jesper Derehag (1):
      connector: Added coredumping event to the process connector

Jim Baxter (2):
      net: fec: TX Buffer incorrectly initialized
      net: fec: Enable imx6 enet checksum acceleration.

Jingchang Lu (1):
      ethernet/fec: Add Vybrid family fec support

Jingoo Han (13):
      net: at91_ether: use module_platform_driver_probe()
      net: macb: use module_platform_driver_probe()
      net: cs89x0: use module_platform_driver_probe()
      net: ethernet: wiznet: add CONFIG_PM_SLEEP to suspend/resume functions
      net: ethernet: atheros: add CONFIG_PM_SLEEP to suspend/resume functions
      net: wireless: iwlegacy: add CONFIG_PM_SLEEP to suspend/resume functions
      net: ieee802154: mrf24j40: use spi_get_drvdata() and spi_set_drvdata()
      net: can: mcp251x: use spi_get_drvdata() and spi_set_drvdata()
      net: ethernet: ks8851: use spi_get_drvdata() and spi_set_drvdata()
      net: ethernet: enc28j60: use spi_get_drvdata() and spi_set_drvdata()
      net: wireless: wl1251: use spi_get_drvdata() and spi_set_drvdata()
      net: wireless: p54spi: use spi_get_drvdata() and spi_set_drvdata()
      net: phy: spi_ks8995: use spi_get_drvdata() and spi_set_drvdata()

Jiri Benc (3):
      ptp_pch: fix typo in module parameter description
      MAINTAINERS: add netdev list for PTP (IEEE 1588)
      ptp: dynamic allocation of PHC char devices

Jiri Pirko (2):
      team: introduce two default team_modeop functions and use them in modes
      team: introduce random mode

Jiri Slaby (1):
      ath5k: cleanup channel to eprom_mode function

Joe Perches (13):
      ssb: pci: Standardize a function to get mac address
      ssb: Convert ssb_printk to ssb_<level>
      drivers:net: Remove unnecessary OOM messages after netdev_alloc_skb
      drivers:net: Remove dma_alloc_coherent OOM messages
      drivers:net: dma_alloc_coherent: use __GFP_ZERO instead of memset(, 0)
      brcmsmac: Remove unused macro SI_MSG
      tg3: Use bool not int
      fec: Convert printks to netdev_<level>
      gianfar: Use netdev_<level> when possible
      ucc_geth: Convert ugeth_<level> to pr_<level>
      neighbour: Convert NEIGH_PRINTK to neigh_dbg
      ixgbe: Remove unnecessary #ifdef CONFIG_DEBUG_FS tests
      rt2x00: Use more current logging styles, shrink object size

Johan Hedberg (46):
      Bluetooth: Rename hci_request to hci_req_sync
      Bluetooth: Fix __hci_req_sync() handling of empty requests
      Bluetooth: Split HCI init sequence into three stages
      Bluetooth: Add initial skeleton for asynchronous HCI requests
      Bluetooth: Refactor HCI command skb creation
      Bluetooth: Introduce new hci_req_add function
      Bluetooth: Fix stand-alone HCI command handling
      Bluetooth: Add request cmd_complete and cmd_status functions
      Bluetooth: Use async requests internally in hci_req_sync
      Bluetooth: Remove unused hdev->init_last_cmd
      Bluetooth: Remove empty HCI event handlers
      Bluetooth: Fix endianness handling of cmd_status/complete opcodes
      Bluetooth: Move power on HCI command updates to their own function
      Bluetooth: Update mgmt powered HCI commands to use async requests
      Bluetooth: Wait for HCI command completion with mgmt_set_powered
      Bluetooth: Fix busy condition testing for EIR and class updates
      Bluetooth: Fix UUID/class mgmt command response synchronization
      Bluetooth: Remove useless HCI_PENDING_CLASS flag
      Bluetooth: Add a define for the HCI persistent flags mask
      Bluetooth: Clear non-persistent flags when closing HCI device
      Bluetooth: Fix clearing flags on power off before notifying mgmt
      Bluetooth: Fix waiting for EIR update when setting local name
      Bluetooth: Handle AD updating through an async request
      Bluetooth: Fix local name setting for LE-only controllers
      Bluetooth: Fix setting local name to the existing value
      Bluetooth: Use an async request for mgmt_set_connectable
      Bluetooth: Fix fast connectable response sending
      Bluetooth: Limit fast connectable support to >= 1.2 controllers
      Bluetooth: Fix error response for simultaneous fast connectable commands
      Bluetooth: Add proper flag for fast connectable mode
      Bluetooth: Refactor fast connectable HCI commands
      Bluetooth: Disable fast connectable when disabling connectable
      Bluetooth: Add reading of page scan parameters
      Bluetooth: Update page scan parameters after successful write commands
      Bluetooth: Fix updating page scan parameters when not necessary
      Bluetooth: Fix fast connectable state when enabling page scan
      Bluetooth: Simplify address parameters of user_pairing_resp()
      Bluetooth: Fix PIN/Confirm/Passkey response parameters
      Bluetooth: Track received events in hdev
      Bluetooth: Add __hci_cmd_sync() helper function
      Bluetooth: Add support for custom event terminated commands
      Bluetooth: Add __hci_cmd_sync_ev function
      Bluetooth: Track feature pages in a single table
      Bluetooth: Add reading of all local feature pages
      Bluetooth: Fix HCI command send functions to use const specifier
      Bluetooth: Fix sending write_le_host_supporte for LE-only controllers

Johannes Berg (88):
      Merge remote-tracking branch 'mac80211/master' into HEAD
      cfg80211: clean up mesh plink station change API
      cfg80211: constify station parameter pointers
      cfg80211: clean up station WME attribute parsing
      cfg80211: unify station WME parsing
      cfg80211: comprehensively check station changes
      mac80211: clarify alignment comment
      nl80211: allow splitting wiphy information in dumps
      nl80211: conditionally add back radar information
      nl80211: conditionally add back TCP WoWLAN information
      wireless: move sequence number arithmetic to ieee80211.h
      nl80211: re-add channel width and extended capa advertising
      cfg80211: move exported event functions into nl80211
      wireless: remove unused VHT MCS defines
      cfg80211: add ability to override VHT capabilities
      mac80211: support VHT capability overrides
      cfg80211: refactor association parameters
      cfg80211: prohibit zero keepalive interval
      mac80211: remove IEEE80211_KEY_FLAG_WMM_STA
      mac80211: defer tailroom counter manipulation when roaming
      mac80211: flush keys when stopping AP
      mac80211: simplify AP interface stop
      mac80211: don't apply HT overrides to TDLS peers
      mac80211: fix HT capability overrides for AP station
      mac80211: restrict peer's VHT capabilities to own
      mac80211: add VHT capabilities station debugfs file
      cfg80211: enable TDLS on P2P client interfaces
      regulatory: allow VHT channels in world roaming
      Merge remote-tracking branch 'iwlwifi-fixes/master' into HEAD
      iwlwifi: support DSSS/CCK mode in 40 MHz
      iwlwifi: use __get_str in tracing
      iwlwifi: mvm: implement remote wake
      iwlwifi: mvm: set up initial SMPS/NSS station info
      iwlwifi: mvm: don't read system time when modifying AP/GO MAC
      iwlwifi: allow selecting only MVM driver
      iwlwifi: export symbols only conditionally
      mac80211: provide race-free 64-bit traffic counters
      mac80211: provide ieee80211_sta_eosp()
      mac80211: clean up key freeing a bit
      mac80211: remove underscores from some key functions
      mac80211: batch key free synchronize_net()
      mac80211: remove a few set but unused variables
      mac80211: pass queue bitmap to flush operation
      mac80211: stop queues temporarily for flushing
      mac80211_hwsim: assign CAB queue properly on interface type change
      iwlwifi: mvm: suppress key error messages in AP mode
      cfg80211: fix potential connection work crash
      iwlwifi: mvm: specify filter flags in monitor mode
      iwlwifi: mvm: fix WoWLAN RF-kill bug
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      mac80211: ibss: disable beaconing before freeing beacon
      mac80211: ibss: use beacon_data struct for beacon and probe response
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: add per-interface debugfs with mac_params file
      iwlwifi: print opmode when firmware is loaded
      iwlwifi: sleep for at least 10 seconds
      mac80211: remove ancient reference to master interface
      mac80211: remove unused IE pointers from parser
      mac80211: check DSSS params IE length in parser
      mac80211: check ERP info IE length in parser
      mac80211: parse Timeout Interval Element using a struct
      mac80211: remove outdated comment referring to master interface
      mac80211: purge remain-on-channel items when suspending
      mac80211: destroy virtual monitor interface across suspend
      mac80211: fix do_stop handling while suspended
      mac80211: don't fiddle with netdev queues in MLME code
      mac80211: replace some dead code by a warning
      mac80211: don't start new netdev queues if driver stopped
      mac80211: make ieee802_11_parse_elems an inline
      iwlwifi: print warning on request_module failure
      mac80211: always advertise STBC/MCSes even if no AP support
      brcm80211: simplify makefiles
      ath5k: use more idiomatic tracing include style
      wireless: regulatory: fix channel disabling race condition
      mac80211: use second center_freq segment only in 80+80
      mac80211: unify CSA action frame/beacon processing
      cfg80211: add ieee80211_operating_class_to_band
      mac80211: support extended channel switch
      mac80211: support secondary channel offset in CSA
      mac80211: handle extended channel switch announcement
      mac80211: parse VHT channel switch IEs
      mac80211: handle wide bandwidth channel switch
      mac80211: fix station entry leak/warning while suspending
      mac80211: fix P2P-Device management frame RX
      nl80211: allow using wdev identifiers to get scan results
      Merge remote-tracking branch 'wireless-next/master' into mac80211-next
      cfg80211: fix P2P-Device stop locking
      cfg80211: invert P2P-Device vs. netdev check ordering

John Fastabend (1):
      net: rtnetlink: fdb dflt dump must set idx used for cb->arg[0]

John W. Linville (25):
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'nfc-next-3.10-1' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge tag 'for-linville-20130318' of git://github.com/kvalo/ath6kl
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'nfc-next-3.10-2' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.infradead.org/users/rafal/b43-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'nfc-next-3.10-4' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jonas Gorski (6):
      bcm63xx_enet: use managed io memory allocations
      bcm63xx_enet: use managed memory allocations
      bcm63xx_enet: properly prepare/unprepare clocks before/after usage
      mwl8k: don't overwrite regulatory settings on fw reload
      mwl8k: always apply configuration even when device is idle
      mwl8k: remove nonstandard rate 72 Mbps

Jouni Malinen (2):
      cfg80211: Extend support for IEEE 802.11r Fast BSS Transition
      cfg80211: Document update_ft_ies() cfg80211_ops

Jozsef Kadlecsik (13):
      netfilter: ipset: Make possible to test elements marked with nomatch
      netfilter: ipset: Move often used IPv6 address masking function to header file
      netfilter: ipset: Introduce extensions to elements in the core
      netfilter: ipset: Unified bitmap type generation
      netfilter: ipset: Bitmap types using the unified code base
      netfilter: ipset: Unified hash type generation
      netfilter: ipset: Hash types using the unified code base
      netfilter: ipset: list:set type using the extension interface
      netfilter: ipset: Introduce the counter extension in the core
      netfilter: ipset: The bitmap types with counter support
      netfilter: ipset: The hash types with counter support
      netfilter: ipset: The list:set type with counter support
      netfilter: ipset: set match: add support to match the counters

Julian Anastasov (41):
      ipvs: fix hashing in ip_vs_svc_hashkey
      ipvs: fix some sparse warnings
      net: add skb_dst_set_noref_force
      ipvs: avoid routing by TOS for real server
      ipvs: prefer NETDEV_DOWN event to free cached dsts
      ipvs: convert the IP_VS_XMIT macros to functions
      ipvs: rename functions related to dst_cache reset
      ipvs: no need to reroute anymore on DNAT over loopback
      ipvs: do not use skb_share_check
      ipvs: consolidate all dst checks on transmit in one place
      ipvs: optimize dst usage for real server
      ipvs: convert app locks
      ipvs: remove rs_lock by using RCU
      ipvs: convert locks used in persistence engines
      ipvs: convert connection locking
      ipvs: reorder keys in connection structure
      ipvs: avoid kmem_cache_zalloc in ip_vs_conn_new
      ipvs: change ip_vs_sched_lock to mutex
      ipvs: preparations for using rcu in schedulers
      ipvs: add ip_vs_dest_hold and ip_vs_dest_put
      ipvs: convert dh scheduler to rcu
      ipvs: convert lblc scheduler to rcu
      ipvs: convert lblcr scheduler to rcu
      ipvs: convert lc scheduler to rcu
      ipvs: convert nq scheduler to rcu
      ipvs: convert rr scheduler to rcu
      ipvs: convert sed scheduler to rcu
      ipvs: convert sh scheduler to rcu
      ipvs: convert wlc scheduler to rcu
      ipvs: convert wrr scheduler to rcu
      ipvs: reorganize dest trash
      ipvs: do not expect result from done_service
      ipvs: convert sched_lock to spin lock
      ipvs: convert dests to rcu
      ipvs: convert services to rcu
      ipvs: do not disable bh for long time
      ipvs: properly dereference dest_dst in ip_vs_forget_dev
      ipvs: fix sparse warnings for ip_vs_conn listing
      ipvs: fix the remaining sparse warnings in ip_vs_ctl.c
      ipvs: fix sparse warnings in lblc and lblcr
      ipvs: fix sparse warnings for some parameters

Jussi Kivilinna (5):
      rndis_wlan: update email address
      rtlwifi: usb: use usb_alloc_coherent for RX buffers
      rtlwifi: usb: remove extra skb copy on RX path
      rtlwifi: usb: defer rx processing to tasklet
      rtlwifi: usb: add NET_IP_ALIGN padding to RX skb when needed

Kalesh AP (2):
      be2net: Use GET_FUNCTION_CONFIG V1 cmd
      be2net: FLR must be first cmd issued to Lancer FW

Kalle Valo (14):
      ath6kl: print firmware capabilities
      ath6kl: cleanup ath6kl_reset_device()
      ath6kl: fix usb related error handling and warnings
      ath6kl: cold reset target after host warm boot
      ath6kl: add tracing support and tracing points for wmi packets
      ath6kl: add tracing points for sdio transfers
      ath6kl: add tracing point for hif irqs
      ath6kl: adding tracing points for htc_mbox
      ath6kl: convert ath6kl_info/err/warn macros to real functions
      ath6kl: add tracing support to log functions
      ath6kl: add tracing support to debug message macros
      ath6kl: add an extra band check to ath6kl_wmi_beginscan_cmd()
      ath6kl: remove false check from ath6kl_rx()
      ath6kl: fix size_t printf warnings

Karl Beldan (13):
      mac80211: Use a cfg80211_chan_def in ieee80211_hw_conf_chan
      mac80211: let drivers not supporting channel contexts use VHT
      mac80211_hwsim: advertise VHT support also when channels == 1
      mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates
      mac80211: fix rate control tx handler for VHT rates
      mac80211: adjust initial chandefs assignments in ieee80211_register_hw
      mac80211: VHT off-by-one NSS
      mac80211_hwsim: handle VHT rates in rx_status
      mac80211: cosmetics for minstrel_debugfs
      mac80211: optimize minstrel_ewma
      mac80211: minstrel_ht: pick only supported rates for sta and group max*rates
      mac80211: minstrel_ht: initialize rates selection
      mac80211_hwsim: handle IEEE80211_HW_SUPPORTS_RC_TABLE

Karl Relton (1):
      Bluetooth: Make hidp_get_raw_report abort if the session is terminating

Keller, Jacob E (1):
      net: add option to enable error queue packets waking select

Kirill Kapranov (1):
      phy: Elimination the forced speed reduction algorithm.

Koki Sanagi (1):
      igb: display a warning message when SmartSpeed works

Kusanagi Kouichi (1):
      net: Fix a comment typo

Lai Jiangshan (1):
      netpoll: use DEFINE_STATIC_SRCU() to define netpoll_srcu

Larry Finger (14):
      ssb: pci: Fix flipping of MAC address
      rtlwifi Modify existing bits to match vendor version 2013.02.07
      rtlwifi: rtl8192se: Update driver to match vendor driver of 2013.02.07
      rtlwifi: rtl8723ae: Update to vendor driver of 2013.02.07
      rtlwifi: rtl8192c: rtl8192ce: Update to vendor driver of 2013.02.07
      rtlwifi: Rework rtl_lps_leave() and rtl_lps_enter() to use work queue
      rtlwifi: rtl8188ee: Add new driver
      rtlwifi: rtl8192c: rtl8192ce: rtl8192cu: rtl8192de: rtl8723ae: Add changes required by adding rtl81988ee
      rtlwifi: rtl8188ee: Enable recognition of RTL8188EE
      rtlwifi: rtl8188ee: Enable build of new driver
      rtlwifi: rtl8188ee: Fix linker warnings
      rtlwifi: rtl8188ee: Fix allyesconfig build failures
      rtlwifi: rtl8188ee: Fix loop that ends early
      rtlwifi: rtl8192cu: Fix false loss of AP indication

Lars-Peter Clausen (5):
      can: mcp251x: Remove redundant spi driver bus initialization
      can: mcp251x: Use module_spi_driver
      can: mcp251x: Use dev_pm_ops
      net: ks8851: Use module_spi_driver
      net: ks8851: Use dev_pm_ops

Laurence Evans (2):
      sfc: PTP changes to support improved UUID filtering mode
      sfc: tidy up PTP synchronize function efx_ptp_process_times()

Li Fei (1):
      wl1251: call pm_runtime_put_sync in pm_runtime_get_sync failed case

Li RongQing (5):
      Documentation: fix neigh/default/gc_thresh1 default value.
      driver/qlogic: replace ip_fast_csum with csum_replace2
      ipv4: replace ip_fast_csum with csum_replace2
      net: neterion: replace ip_fast_csum with csum_replace2
      net: simplify the getting percpu of flow_cache

Lior Levy (1):
      igb: add support for spoofchk config

Lubomir Rintel (1):
      bluetooth: btmrvl_sdio: look for sd8688 firmware in proper location

Luciano Coelho (3):
      wlcore: use print_hex_dump_debug()
      wlcore: move handling from hardirq to the irq thread function
      Merge branch 'wl12xx-next' into for-linville

Ludovic Desroches (2):
      can: at91_can: add dt support
      can: Kconfig: CAN_AT91 depends on ARM

Manish Chopra (2):
      qlcnic: Enhance channel configuration logs
      qlcnic: Take EPORT out of reset sequence before disabling PAUSE

Manish chopra (1):
      qlcnic: Fix configure mailbox interrupt command for 83xx adapter

Marc Kleine-Budde (1):
      can: bfin_can: declare locally used functions static

Marcel Holtmann (6):
      Bluetooth: Add driver setup stage for early init
      Bluetooth: Convert BCM92035 support to driver setup callback
      Bluetooth: Remove driver init queue from core
      Bluetooth: Use separate function for BCM92035 vendor setup
      Bluetooth: Remove unneeded parameter from L2CAP ATT channel handling
      NFC: Add missing RFKILL dependency for Kconfig

Marek Lindner (2):
      batman-adv: replace redundant primary_if_get calls
      batman-adv: rename batadv_softif_destroy to reflect sysfs use case

Marek Puzyniak (2):
      mac80211: clear SSID when stopping AP
      mac80211: provide SSID in IBSS mode

Marina Makienko (1):
      NFC: pn533: Add missing usb_put_dev

Martin Hundeb√∏ll (8):
      batman-adv: Return reason for failure in batadv_check_unicast_packet()
      batman-adv: network coding - add the initial infrastructure code
      batman-adv: network coding - detect coding nodes and remove these after timeout
      batman-adv: network coding - buffer unicast packets before forward
      batman-adv: network coding - code and transmit packets if possible
      batman-adv: network coding - save overheard and tx packets for decoding
      batman-adv: network coding - receive coded packets and decode them
      batman-adv: Fix endianness errors for network coding

Martin Pitt (1):
      mac80211_hwsim: Register and bind to driver

Mathias Krause (5):
      xfrm_user: constify netlink dispatch table
      ipv6: remove superfluous nla_data() NULL pointer checks
      irda: use GFP_KERNEL in irda_create()
      irda: use GFP_KERNEL in irda_connect_response()
      TTY: ircomm, use GFP_KERNEL in ircomm_open()

Mathias Kretschmer (1):
      ath9k: apply coverage class on slottime too

Matt Carlson (1):
      tg3: Add new FW_TSO flag

Matthew Vick (3):
      igb: Enable EEE LP advertisement
      igb: Add SMBI semaphore to I210/I211
      igb: Remove dead code path

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)

Michael Chan (3):
      tg3: Fix NVRAM size detection for the STM45PE20 pinstrap on 5762 devices
      tg3: Add tg3_clear_mac_status() common function
      tg3: Add SGMII phy support for 5719/5718 serdes

Michael Dalton (1):
      flow_dissector: support L2 GRE

Michael Stapelberg (2):
      phy: add set_wol/get_wol functions
      mv643xx_eth with 88E1318S: support Wake on LAN

Michal Kubeƒçek (1):
      netfilter: fix struct ip6t_frag field description

Michal Pecio (1):
      orinoco_usb: don't release nonexistent firmware

Mike Rapoport (2):
      vxlan: use htonl when snooping for loopback address
      vxlan: don't bypass encapsulation for multi- and broadcasts

Ming Lei (11):
      usbnet: introduce usbnet_link_change API
      usbnet: mcs7830: don't reset link
      usbnet: mcs7830: apply usbnet_link_change
      usbnet: cdc_ncm: apply usbnet_link_change
      usbnet: asix: apply usbnet_link_change
      usbnet: ax88179_1781: apply usbnet_link_change
      usbnet: cdc-ether: apply usbnet_link_change
      usbnet: dm9601: apply usbnet_link_change
      usbnet: sierra: apply usbnet_link_change
      usbnet: apply usbnet_link_change
      usbnet: handle link change

Mohammed Shafi Shajakhan (5):
      ath6kl: Cosmetic change in checking for free vif slot
      ath6kl: Protect ath6kl_cfg80211_vif_cleanup using rtnl_locks
      ath6kl: Return error from ath6kl_bmi_done()
      ath6kl: Remove NETDEV_REGISTERED flag
      ath6kl: Fix a debugfs crash for USB devices

Mugunthan V N (6):
      documentation: dt: bindings: cpsw: cleanup documentation
      drivers: net: ethernet: cpsw: change cpts_active_slave to active_slave
      driver: net: ethernet: cpsw: implement ethtool get/set phy setting
      driver: net: ethernet: cpsw: implement interrupt pacing via ethtool
      drivers: net: ethernet: cpsw: implement get phy_id via ioctl
      drivers: net: cpsw: fix kernel warn on cpsw irq enable

Myoungje Kim (1):
      ath6kl: Fix the byte alignment rule to avoid loss of bytes in a TCP segment

Nadim Zubidat (1):
      wlcore: report rssi from roaming statistics

Nandita Dukkipati (2):
      tcp: Tail loss probe (TLP)
      tcp: TLP loss detection.

Neal Cardwell (1):
      tcp: Remove dead sysctl_tcp_cookie_size declaration

Neil Horman (2):
      forcedeth: Do a dma_mapping_error check after skb_frag_dma_map
      netpoll: convert mutex into a semaphore

Nicolas Dichtel (8):
      xfrm: allow to avoid copying DSCP during encapsulation
      netconf: add the handler to dump entries
      ipv4: provide addr and netconf dump consistency info
      ipv6: provide addr and netconf dump consistency info
      netlink: fix compilation after memory mapped patches
      packet_diag: disclose uid value
      packet_diag: disclose meminfo values
      sock_diag: allow to dump bpf filters

Nicolas Ferre (1):
      net/macb: fix error return code in macb_probe()

Nishant Sarmukadam (2):
      mwl8k: Adding support for 8764 4x4 AP
      mwl8k: Load 8764 firmware image

Nithin Sujir (13):
      tg3: Refactor cpu pause/resume code
      tg3: Refactor the 2nd type of cpu pause
      tg3: Cleanup firmware parsing code
      tg3: Enhance firmware download code to support fragmented firmware
      tg3: Download 57766 EEE service patch firmware
      tg3: Fix flow control settings not propagated to hardware
      tg3: Remove unnecessary phy reset during ethtool commands
      tg3: Add a warning during link settings change if mgmt enabled
      tg3: Add support for link flap avoidance
      tg3: Pull the phy advertised speed and flow control settings on driver load
      tg3: Reset the phy to allow modified EEE settings to take effect
      tg3: Update version to 3.131
      MAINTAINERS: Update tg3 to reflect organizational changes

Nobuhiro Iwamatsu (1):
      net: sh-eth: Use pr_err instead of printk

Noguchi Kazutosi (1):
      Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]

Oliver Hartkopp (2):
      can: dump stack on protocol bugs
      can: sja1000: use common prefix for all sja1000 defines

Olivier Guiter (1):
      NFC: llcp: Fix zero octets length SDU handling

Or Gerlitz (3):
      net/mlx4_core: Added proper description for two device capabilities
      net/mlx4_en: Enable DCB ETS ops only when supported by the firmware
      net/mlx4_en: Advertize DCB_CAP_DCBX_HOST in getdcbx

Pablo Neira Ayuso (3):
      netfilter: nfnetlink_queue: use xor hash function to distribute instances
      netfilter: ctnetlink: allow to dump expectation per master conntrack
      netfilter: remove unneeded variable proc_net_netfilter

Patrick McHardy (33):
      netfilter: ipv4: propagate routing errors from ip_route_me_harder()
      netfilter: ipv6: propagate routing errors from ip6_route_me_harder()
      netfilter: nat: propagate errors from xfrm_me_harder()
      tipc: remove unused str2addr media callback
      tipc: move bcast_addr from struct tipc_media to struct tipc_bearer
      tipc: set skb->protocol in eth_media packet transmission
      tipc: add InfiniBand media type
      IPoIB: add support for TIPC protocol
      netfilter: add my copyright statements
      net: vlan: rename NETIF_F_HW_VLAN_* feature flags to NETIF_F_HW_VLAN_CTAG_*
      net: vlan: prepare for 802.1ad VLAN filtering offload
      net: vlan: prepare for 802.1ad support
      net: vlan: add protocol argument to packet tagging functions
      net: vlan: add 802.1ad support
      net: vlan: announce STAG offload capability in some drivers
      netlink: add symbolic value for congested state
      netlink: rename ssk to sk in struct netlink_skb_params
      net: add function to allocate sk_buff head without data area
      netlink: don't orphan skb in netlink_trim()
      netlink: add netlink_skb_set_owner_r()
      netlink: mmaped netlink: ring setup
      netlink: add mmap'ed netlink helper functions
      netlink: implement memory mapped sendmsg()
      netlink: implement memory mapped recvmsg()
      netlink: add flow control for memory mapped I/O
      netlink: add RX/TX-ring support to netlink diag
      netlink: add documentation for memory mapped I/O
      netfilter: rename netlink related "pid" variables to "portid"
      nfnetlink: add support for memory mapped netlink
      net: vlan: fix memory leak in vlan_info_rcu_free()
      net: vlan: fix dummy function signatures for CONFIG_VLAN=n
      net: vlan: fix up vlan_proto_idx() for CONFIG_BUG=n
      qeth: fix VLAN related compilation errors

Paul Bolle (3):
      appletalk: remove "config IPDDP_DECAP"
      tokenring: delete last holdout of CONFIG_TR
      cirrus: cs89x0: remove two obsolete Kconfig macros

Paul Gortmaker (1):
      ipconfig: add informative timeout messages while waiting for carrier

Paul Stewart (1):
      mwifiex: Start P2P devices in P2P mode

Petko Manolov (3):
      drivers: net: usb: pegasus: remove skb pool
      drivers: net: usb: pegasus: read/write_mii_word optimised
      drivers: net: usb: pegasus: fix control urb submission

Piotr Haber (8):
      brcmsmac: radio on led support
      brcmfmac: avoid error output on header only packet
      brcmfmac: read firmware console without trap indication
      brcmfmac: firmware shared data version fix
      brcmfmac: support save&restore firmware feature
      brcmfmac: setup SDIO reset behavior
      brcmfmac: support critical protocol API for DHCP
      brcmsmac: Fix merge issue

Pravin B Shelar (24):
      net: Kill link between CSUM and SG features.
      tunnel: Inherit NETIF_F_SG for hw_enc_features.
      net: Add skb_headers_offset_update helper function.
      tunneling: Capture inner mac header during encapsulation.
      tunneling: Add generic Tunnel segmentation.
      VXLAN: Use UDP Tunnel segmention.
      ipip: Use tunnel_ip_select_ident() for tunnel IP-Identification.
      ipip: capture inner headers during encapsulation
      Revert "ip_gre: increase inner ip header ID during segmentation"
      Revert "udp: increase inner ip header ID during segmentation"
      ipv4: Fix ip-header identification for gso packets.
      GRE: Refactor GRE tunneling code.
      IPIP: Use ip-tunneling code.
      VXLAN: Fix vxlan stats handling.
      VXLAN: Use IP Tunnels tunnel ENC encap API
      Tunneling: use IP Tunnel stats APIs.
      VXLAN: Fix sparse warnings.
      ip_tunnel: Fix off-by-one error in forming dev name.
      openvswitch: Simplify datapath locking.
      openvswitch: Use generic struct pcpu_tstats.
      genl: Allow concurrent genl callbacks.
      openvswitch: Use parallel_ops genl.
      ipv6: Kill ipv6 dependency of icmpv6_send().
      netlink: Fix skb ref counting.

Rafa≈Ç Mi≈Çecki (43):
      bcma: ignore extra GMAC cores on BCM4706
      bcma: implement disabling PLLs
      b43: define BCMA wireless specific PLLs
      b43: HT-PHY: make it BCMA-only
      bgmac: register MII bus
      b43: HT-PHY: rename AFE defines
      b43: HT-PHY: add classifier control function
      b43: HT-PHY: move TX fix to the separated function
      b43: HT-PHY: implement spurious tone avoidance
      b43: HT-PHY: implement MAC reclocking
      b43: HT-PHY: implement CCA reset
      b43: HT-PHY: implement PA override
      b43: HT-PHY: implement controlling TX power control
      b43: HT-PHY: implement stopping sample tone playback
      b43: HT-PHY: implement playing sample tone
      b43: HT-PHY: implement RSSI polling
      b43: HT-PHY: setup TX power control
      b43: HT-PHY: enable basic TX power setup
      ssb: extract board_type from SPROM
      bcma: extract board_type from SPROM
      ssb: define more board types
      bcma: define board types
      b43: HT-PHY: rename defines addressing cores on the 2059 radio
      b43: HT-PHY: tables: don't duplicate core-generic regs
      b43: HT-PHY: finish calculating values for idle TSSI
      b43: HT-PHY: do some extra TSSI setup after configuring TX
      b43: HT-PHY: define regs for power estimation
      b43: HT-PHY: store TX power state before disabling it
      b43: HT-PHY: use enum for RSSI types
      b43: N-PHY: use enum for RAIL type
      b43: N-PHY: simplify conditions in RSSI offset scale function
      b43: N-PHY: use more friendly variables names in RSSI code
      b43: N-PHY: rename RSSI types to be shorter and more accurate
      b43: N-PHY: use enum for RSSI type everywhere we use it
      b43: N-PHY: fix "NB" RSSI calibration on PHYs rev2-
      b43: use defines for board_type
      b43: N-PHY: define missing registers
      b43: N-PHY: use enum for INTC override function argument
      b43: N-PHY: use shortcut "ctl" in functions names
      b43: N-PHY: use defines for (re)storing VCM config
      b43: N-PHY: move tables init function to tables file
      b43: N-PHY: clean init tables
      b43: N-PHY: don't use deprecated b43_radio_foo16

Rajesh Borundia (19):
      qlcnic: Support SR-IOV enable and disable
      qlcnic: SR-IOV VF probe
      qlcnic: Use shared interrupt vector for Tx and Rx
      qlcnic: VF-PF communication channel implementation
      qlcnic: Support VF-PF communication channel commands.
      qlcnic: Support atomic commands
      qlcnic: Bump up the version to 5.2.39
      qlcnic: Fix potential NULL dereference
      qlcnic: Fix NULL dereference in error path.
      qlcnic: Fix sparse warnings.
      qlcnic: Bump up the version to 5.2.40
      qlcnic: Change 82xx adapter VLAN id endian type.
      qlcnic: VF FLR implementation.
      qlcnic: VF reset recovery implementation.
      qlcnic: Support MAC address, Tx rate config.
      qlcnic: Support VLAN id config.
      qlcnic: Fix loopback test for SR-IOV PF.
      qlcnic: Support polling for mailbox events.
      qlcnic: Update version to 5.2.41

Rami Rosen (1):
      Documentation: cgroup: add documentation for net_cls cgroups.

Rayagond Kokatanur (3):
      stmmac: add tx_skbuff_dma to save descriptors used by PTP
      stmmac: add IEEE PTPv1 and PTPv2 support.
      stmmac: add the support for PTP hw clock driver

Reilly Grant (1):
      VSOCK: Support VM sockets connected to the hypervisor.

Richard Cochran (2):
      gianfar: do not advertise any alarm capability.
      e1000e: fix numeric overflow in phc settime method

Robert Shade (1):
      Show actual timeout value in failed calibration messages.

Rony Efraim (6):
      net/mlx4: Add reference counting to MAC registeration
      net/mlx4: Add structures to keep VF Ethernet ports information
      net/mlx4: Add set VF mac address support
      net/mlx4: Add set VF default vlan ID and priority support
      net/mlx4: Add VF MAC spoof checking support
      net/mlx4: Add support to get VF config

Rusty Russell (1):
      virtio: remove obsolete virtqueue_get_queue_index()

Sachin Kamat (10):
      net: rfkill: Fix sparse warning in rfkill-regulator.c
      net: dm9000: Use module_platform_driver()
      net: ep93xx_eth: Use module_platform_driver()
      net: ftgmac100: Use module_platform_driver()
      net/smsc911x: Use NULL instead of integer for pointer
      net: ks8695net: Use module_platform_driver()
      net: s6gmac: Use module_platform_driver()
      net: au1k_ir: Use module_platform_driver()
      net: mdio-gpio: Use module_platform_driver()
      net: mdio-octeon: Use module_platform_driver()

Sahara (1):
      ptp_pch: eliminate a number of sparse warnings

Samuel Ortiz (18):
      NFC: microread: Fix MEI build failure
      NFC: llcp: Rename socket rw and miu fields
      NFC: llcp: Implement socket options
      NFC: llcp: Use socket specific link parameters before the local ones
      NFC: llcp: Remove redundant printk
      Revert "NFC: microread: Fix MEI build failure"
      NFC: pn533: Use dynamic debug for pn533 hex dumps
      NFC: llcp: Socket miux is a big endian field
      NFC: llcp: Fall back to local values when getting socket options
      NFC: llcp: Only keep raw sockets alive when the LLCP local leaves
      NFC: llcp: Remove local_cleanup last argument
      NFC: llcp: Terminate connection when receiving a DISC on (0,0)
      NFC: Prevent polling when device is down
      NFC: pn533: Turn radio on and off when bringing the device up and down
      rfkill: Add NFC to the list of supported radios
      NFC: RFKILL support
      NFC: pn544: Add MEI physical layer
      NFC: Move LLCP code to the NFC top level diirectory

Santosh Rastapur (11):
      cxgb4: Add register definations for T5
      cxgb4: Add macros, structures and inline functions for T5
      cxgb4: Initialize T5
      cxgb4: Dump T5 registers
      cxgb4: Add T5 write combining support
      cxgb4: Enable doorbell drop recovery only for T4 adapter
      cxgb4: Add T5 debugfs support
      cxgb4: Add T5 PCI ids
      cxgb4: Update driver version and description
      cxgb4: Disable SR-IOV support for PF4-7 for T5
      cxgb4vf: Add support for Chelsio T5 adapter

Sarveshwar Bandi (1):
      be2net: Fix to show wol disabled/enabled state correctly.

Sascha Herrmann (3):
      at86rf230: remove unnecessary / dead code
      at86rf230: add irq type configuration option
      at86rf230: change irq handling to prevent lockups with edge type irq

Sebastian Hesselbarth (7):
      net: mvmdio: get and enable optional clock
      net: of_mdio: scan mdiobus for PHYs without reg property
      net: mvmdio: add clocks property to binding documentation
      net: mv643xx_eth: add shared clk and cleanup existing clk handling
      net: mv643xx_eth: use managed devm_kzalloc
      net: mv643xx_eth: Add GRO support
      net: mv643xx_eth: remove deprecated inet_lro support

Sebastian Siewior (9):
      net/davinci_cpdma: don't check for jiffies with interrupts
      net/cpsw: don't continue if we miss to allocate rx skbs
      net/cpsw: don't rely only on netif_running() to check which device is active
      net/davinci_cpdma: remove unused argument in cpdma_chan_submit()
      net/cpsw: redo rx skb allocation in rx path
      net/ti: add MODULE_DEVICE_TABLE + MODULE_LICENSE
      net/cpsw: make sure modules remove does not leak any ressources
      net/cpsw: optimize the for_each_slave_macro()
      net/cpsw: fix irq_disable() with threaded interrupts

Sekhar Nori (1):
      net/davinci_emac: use devres APIs

Sergei Shtylyov (8):
      sh_eth: use PIR_* bits
      sh_eth: kill unneeded typecast in sh_eth_drv_probe()
      sh_eth: use managed device API
      sh_eth: fix unused variable warning
      sh_eth: move data from header file to driver
      sh_eth: add R-Car support for real
      sh_eth: add R8A77781 support
      sh_eth: use random MAC address if no valid one supplied

Shahed Shaikh (11):
      qlcnic: Fix endian issues in 83xx driver
      qlcnic: Fix ethtool statistics for 82xx adapter
      qlcnic: Fix ethtool statistics collection
      qlcnic: Bump up the version to 5.1.36
      qlcnic: Bump up the version to 5.1.37
      qlcnic: change mdelay to msleep
      qlcnic: Clear link status when interface is down
      qlcnic: Bump up the version to 5.1.38
      MAINTAINERS: Update qlge maintainers list
      qlcnic: Add eSwitch statistics support
      qlcnic: Update version to 5.2.42

Shuduo Sang (1):
      iwlwifi: add new pci id for 6x35 series

Silviu-Mihai Popescu (6):
      CAIF: fix indentation for function arguments
      ethernet: amd: use PTR_RET instead of IS_ERR + PTR_ERR
      ipv4: netfilter: use PTR_RET instead of IS_ERR + PTR_ERR
      bridge: netfilter: use PTR_RET instead of IS_ERR + PTR_ERR
      drivers: net: irda: use resource_size() in au1k_ir.c
      net: ethernet: stmicro: stmmac: use devm_ioremap_resource()

Simon Baatz (2):
      net: mvmdio: define module alias for platform device
      mv643xx_eth: defer probing if Marvell Orion MDIO driver not loaded

Simon Horman (5):
      net: add ETH_P_802_3_MIN
      ipvs: Avoid shadowing net variable in ip_vs_leave()
      ipvs: Use min3() in ip_vs_dbg_callid()
      ipvs: Use network byte order for sync message size
      sctp: Correct type and usage of sctp_end_cksum()

Simon Wunderlich (2):
      batman-adv: Start new development cycle
      mac80211: fix recalc_radar hwconf sync problem

Somnath Kotur (2):
      be2net: enable interrupts in be_probe() (RoCE and other ULPs need them)
      be2net: Use new F/W mailbox cmd to manipulate interrupts.

Sridhar Samudrala (2):
      vxlan: Bypass encapsulation if the destination is local
      net: Use consume_skb() to free gso segmented skb

Stanislaw Gruszka (51):
      mac80211: remove napi
      cfg80211/mac80211: disconnect on suspend
      mac80211: cleanup generic suspend/resume procedures
      mac80211: cleanup suspend/resume on managed mode
      mac80211: cleanup suspend/resume on ibss mode
      mac80211: cleanup suspend/resume on mesh mode
      mac80211: merge reconfig assign chanctx code
      mac80211: move sdata debugfs dir to vif
      mac80211: remove vif debugfs driver callbacks
      rt2800: do not crash if spec->channels is NULL
      rt2800: 5592: early defines
      rt2800: 5592: add channels table
      rt2800: 5592: channel config stub
      rt2800: 5592: MAC registers initalization
      rt2800: 5592: BBP registers initialization
      rt2800: 5592: common BBP initialization
      rt2800: 5592: RF early registers initialization
      rt2800: 5592: initalize RF_R27 on older revisions
      rt2800: 5592: initalize BBP_R103 register on new revisions
      rt2800: 5592: initialize BBP_R138 register
      rt2800: 5592: initialize RF_38/39/30 registers
      rt2800: 5592: init frequency calibration
      rt2800: 5592: setup LDO_CFG0 when configuring channel
      rt2800: 5592: enable rf init
      rt2800: 5592: more channel switch registers settings (BBP & GLRT)
      rt2800: 5592: add iq calibration
      rt2800: rearrange bbp/rfcsr initialization
      rt2800: add write_with_rx_chain function
      rt2800: 5592: add AGC init
      rt2800: 5592: add chip specific vgc calculations
      rt2800: 5592: TXWI & RXWI descriptors size
      rt2800: 5592: add Kconfig
      rt2800: 5592: iq calibration for 5GHz
      rt2800: 5592: add more USB devices IDs
      iwlwifi: remove 5ghz_disable option
      iwlwifi: fix freeing uninitialized pointer
      iwlwifi: remove redundant argument from iwl_dump_nic_event_log
      iwlwifi: remove unneeded goto from iwl_dbgfs_log_event_read
      rt2800: merge 5xxx normal mode setup
      rt2800: move rf init calibration code
      rt2800: move RFCSR29_RSSI_GAIN to 3290 specific rfcsr init
      rt2800: move 30xx common rf init code
      rt2800: move GPIO_SWITCH setup to 3390 specific rfcsr init
      rt2800: move RFCSR6_R2 & LDO_CFG0 setup to 3572 specific rfcsr init
      rt2800: add rt2800_rx_filter_calibration procedure
      rt2800: move RF_R27 setup to individual rfcsr init subroutines
      rt2800: add rt2800_led_open_drain_enable subroutine
      rt2800: add rt2800_normal_mode_setup_3xxx subroutine
      rt2800: cleanup rt2800_init_rfcsr
      rt2x00: provide separate information about TXWI & RXWI sizes
      rt2800: nulify all last words of TXWI

Stefan Assmann (1):
      enic: be less verbose about non-critical firmware errors

Stefan Bader (1):
      r8169: fix 8168evl frame padding.

Stefan Raspl (2):
      qeth: remove unused variable
      qeth: Fix missing pointer update

Steffen Trumtrar (3):
      net/macb: clear tx/rx completion flags in ISR
      net/macb: force endian_swp_pkt_en to off
      net/macb: make clk_enable atomic

Stephen Hemminger (2):
      ixgbevf: use PCI_DEVICE_TABLE macro
      iwlegacy: fix sparse warnings

Stephen Rothwell (1):
      netlink: fix typo in net/netlink/af_netlink.c

Stephen R√∂ttger (1):
      ieee802154/dgram: Pass source address in dgram_recvmsg

Sujith Manoharan (8):
      ath9k_hw: Remove CHANNEL_CW_INT
      ath9k_hw: Use helper functions to simplify HW reset
      ath9k_hw: Update initvals for AR9462
      ath9k_hw: Fix fixed antenna for AR9462
      ath9k: Remove unused argument "size"
      ath9k: Reduce deep indentation
      ath9k: Use lockless variants for the RX fifo queue
      ath9k: Fix RX DMA mapping

Suresh Reddy (4):
      be2net: Add support for setting and getting rx flow hash options
      be2net: Renamed rx_address_mismatch_errors to rx_address_filtered
      be2net: Avoid diagnostic test in certain versions of firmware to avoid NIC freeze.
      be2net: Fixed memory leak

Sven Eckelmann (5):
      batman-adv: Move soft-interface initialization to ndo_init
      batman-adv: Move deinitialization of soft-interface to destructor
      batman-adv: Don't always delete softif when last slave was removed
      batman-adv: Allow to use rntl_link for device creation/deletion
      batman-adv: Allow to modify slaves of soft-interfaces through rntl_link

Syam Sidhardhan (1):
      rndis_wlan: Remove redundant NULL check before kfree

Tedd Ho-Jeong An (1):
      Bluetooth: Add support for Intel Bluetooth device [8087:07dc]

Thierry Escande (8):
      NFC: Add missing type policies for netlink attributes
      NFC: llcp: Service Name Lookup SDRES aggregation
      NFC: llcp: Service Name Lookup netlink interface
      NFC: llcp: Add cleanup support for unreplied SNL requests
      NFC: llcp: Aggregated frames support
      NFC: llcp: Use localy stored remote_miu value if not set at socket level
      NFC: llcp: Reset RW, LTO, and MIU remote parameters when link goes down
      NFC: llcp: Add support in getsockopt for RW, LTO, and MIU remote parameters

Thomas Graf (14):
      openvswitch: Use eth_mac_addr() instead of duplicating it
      openvswitch: Avoid useless holes in struct vport
      ipv6: ndisc: remove redundant check for !dev->addr_len
      decnet: Parse netlink attributes on our own
      rtnetlink: Remove passing of attributes into rtnl_doit functions
      decnet: Move rtm_dn_policy to dn_route to make it available if !CONFIG_DECNET_ROUTER
      openvswitch: Specify the minimal length of OVS_PACKET_ATTR_PACKET in the policy
      openvswitch: Use nla_memcpy() to memcpy() data from attributes
      openvswitch: Refine Netlink message size calculation and kill FLOW_BUFSIZE
      openvswitch: Move common genl notify code into ovs_notify()
      openvswitch: Use ETH_ALEN to define ethernet addresses
      openvswitch: Expose <linux/openvswitch.h> to userspace
      openvswitch: Don't insert empty OVS_VPORT_ATTR_OPTIONS attribute
      openvswitch: Remove unneeded ovs_netdev_get_ifindex()

Thomas Huehn (7):
      mac80211: merge EWMA calculation of minstrel_ht and minstrel
      mac80211: merge value scaling macros of minstrel_ht and minstrel
      mac80211: add documentation and verbose variable names in
      mac80211: extend minstrel's rate sampling to avoid unsampled rates
      mac80211: add lowest rate into minstrel's random rate sampling table
      mac80211: treat minstrel success probabilities below 10% as implausible
      mac80211: improve minstrels rate sorting by means of throughput & probability

Thomas Pedersen (9):
      nl80211: explicit userspace MPM
      cfg80211: rename mesh station types
      mac80211: support userspace MPM
      nl80211: user_mpm overrides auto_open_plinks
      mac80211: disallow changing auto_open_plinks
      mac80211: init mesh timer for user authed STAs
      mac80211: unset FC retry bit in mesh fwding path
      mac80211: stringify another plink state
      mac80211: fix ieee80211_queue_stopped()

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

Tony Cheneau (14):
      6lowpan: lowpan_is_iid_16_bit_compressable() does not detect compressible address correctly
      6lowpan: next header is not properly set upon decompression of a UDP header.
      6lowpan: always enable link-layer acknowledgments
      mac802154: turn on ACK when enabled by the upper layers
      6lowpan: use short IEEE 802.15.4 addresses for broadcast destination
      6lowpan: fix first fragment (FRAG1) handling
      6lowpan: add debug messages for 6LoWPAN fragmentation
      6lowpan: store fragment tag values per device instead of net stack wide
      mac802154: add mac802154_dev_get_dsn()
      6lowpan: obtain IEEE802.15.4 sequence number from the MAC layer
      6lowpan: use the PANID provided by the device instead of a static value
      6lowpan: modify udp compression/uncompression to match the standard
      6lowpan: fix a small formatting issue
      6lowpan: use IEEE802154_ADDR_LEN instead of a magic number

Valentin Ilie (1):
      net: can: af_can.c: Fix checkpatch warnings

Vasundhara Volam (5):
      be2net: Update copyright year
      be2net: Use TXQ_CREATE_V2 cmd
      be2net: Don't log "Out of MCCQ wrbs" error
      be2net: Avoid flashing BE3 UFI on BE3-R chip.
      be2net: Use GET_PROFILE_CONFIG V1 cmd for BE3-R

Veaceslav Falico (2):
      bonding: cleanup unneeded rcu_read_lock()
      pch_gbe: minor: report the actual error on MTU change

Victor Goldenshtein (1):
      wl18xx: print chip info during boot

Vipul Pandya (10):
      RDMA/cxgb4: Add Support for Chelsio T5 adapter
      RDMA/cxgb4: Turn off db coalescing when RDMA QPs are in use.
      RDMA/cxgb4: Add module_params to enable DB FC & Coalescing on T5
      RDMA/cxgb4: Use DSGLs for fastreg and adapter memory writes for T5.
      RDMA/cxgb4: Map pbl buffers for dma if using DSGL.
      RDMA/cxgb4: Bump tcam_full stat and WR reply timeout
      RDMA/cxgb4: Fix onchip queue support for T5
      cxgb4: Fix pci_device_id structure initialization with correct PF number
      cxgb4: Support CPL_SGE_EGR_UPDATEs encapsulated in a CPL_FW4_MSG
      cxgb4vf: Support CPL_SGE_EGR_UPDATEs encapsulated in a CPL_FW4_MSG

Vlad Yasevich (7):
      net: generic fdb support for drivers without ndo_fdb_<op>
      ixgbe: Make use of the default fdb handlers.
      mlx4: Remove driver specific fdb handlers.
      qlcnic: Use generic fdb handler when driver options are not enabled.
      net: add dev_uc_sync_multiple() and dev_mc_sync_multiple() api
      team: Use new sync_multiple api to sync devices adressess.
      net: fix address check in rtnl_fdb_del

Vladimir Davydov (1):
      netfilter: nf_conntrack: speed up module removal path if netns in use

Vladimir Kondratiev (18):
      wil6210: Remove local implementation of dynamic hexdump
      wil6210: handle linkup/linkdown WMI events
      wil6210: handle WMI_BA_STATUS_EVENTID
      wil6210: do not set IE's for beacon
      wil6210: Fix garbage sent to the FW with wmi_set_ie()
      wil6210: refactor connect_worker
      wil6210: use cfg80211_inform_bss_frame()
      wil6210: report all received mgmt frames
      wil6210: fix FW error notification
      wil6210: use WLAN_CAPABILITY_DMG_TYPE_MASK
      wil6210: headers clean-up
      wil6210: new SW reset
      wil6210: sync with new firmware
      wil6210: temperature measurement
      wil6210: Use cached copy of Rx descriptor
      wil6210: Tx init optimization
      wil6210: Use cached copy of Tx descriptor
      wil6210: more Rx descriptor accessor functions

W. Trevor King (1):
      b43: Fix 'me' -> 'be' typo in Kconfig

Waldemar Rymarkiewicz (19):
      NFC: pn533: Reword all std frame logic funct
      NFC: pn533: Print out response status bits in hex
      NFC: pn533: Fix div by zero while stopping polling
      NFC: pn533: Update copyrights note
      NFC: pn533: Rename pn533_fw_reset appropriately
      NFC: pn533: Fix memleak while scheduling next cmd
      NFC: pn533: Optimise issued cmd context tracking
      NFC: pn533: Keep cmd context in pn533 struct
      NFC: pn533: Remove redundant cmd_ prefix in the struct
      NFC: pn533: Fix incorrect kfree of complete args
      NFC: pn533: Simplify __pn533_send_frame_async
      NFC: pn533: Avoid function declarations
      NFC: pn533: Re-group fields in struct pn533
      NFC: pn533: Move wq_in_error to cmd context
      NFC: pn533: Add protocol type for frame ops
      NFC: pn533: Add support for ACS ACR122U reader
      NFC: pn533: Add pn533_abort_cmd procedure
      NFC: pn533: Remove unused pn533_cmd_complete_t
      NFC: pn533: Increase version number

Wei Liu (7):
      xen-netfront: remove unused variable `extra'
      xen-netfront: frags -> slots in xennet_get_responses
      xen-netback: remove skb in xen_netbk_alloc_page
      xen-netfront: frags -> slots in log message
      xen-netfront: reduce gso_max_size to account for max TCP header
      xen-netback: coalesce slots in TX path and fix regressions
      xen-netback: don't disconnect frontend when seeing oversize packet

Wei Yongjun (24):
      iwlwifi: convert to use simple_open()
      wil6210: convert to use simple_open()
      qlcnic: remove duplicated include from qlcnic_sysfs.c
      bnx2x: use list_move instead of list_del/list_add
      bridge: using for_each_set_bit_from to simplify the code
      bridge: using for_each_set_bit to simplify the code
      sfc: remove duplicated include from efx.c
      tuntap: remove unused variable in __tun_detach()
      wil6210: remove unused including <linux/version.h>
      cfg80211: fix error return code in cfg80211_init()
      Bluetooth: fix error return code in rfcomm_add_listener()
      net: ethernet: davinci_emac: make local function emac_poll_controller() static
      net: fec: make local function fec_poll_controller() static
      s6gmac: fix error return code in s6gmac_probe()
      sctp: fix error return code in __sctp_connect()
      net_cls: remove duplicated include from cls_api.c
      decnet: remove duplicated include from dn_table.c
      mrf24j40: use module_spi_driver to simplify the code
      vxlan: fix some sparse warnings
      net/at91_ether: fix error return code in at91ether_probe()
      rfkill: fix error return code in rfkill_gpio_probe()
      brcmfmac: fix potential NULL pointer dereference in brcmf_fws_flow_control_check()
      caif: spi: missing platform_driver_unregister() on error in cfspi_init_module()
      genetlink: fix possible memory leak in genl_family_rcv_msg()

Werner Almesberger (2):
      IEEE 802.15.4: remove get_bsn from "struct ieee802154_mlme_ops"
      ieee802154/nl-mac.c: make some MLME operations optional

Willem de Bruijn (4):
      packet: packet fanout rollover during socket overload
      net: fix psock_fanout selftest hash collision
      net: fix psock_fanout on sparc64
      packet: tx timestamping on tpacket ring

Wu Fengguang (1):
      irda: irlmp_reasons[] can be static

Xi Wang (1):
      filter: fix va_list build error

YOSHIFUJI Hideaki (12):
      firewire net: No need to reset dev->local_fifo after failure of fw_core_add_address_handler().
      firewire net: Introduce fwnet_fifo_{start, stop}() helpers.
      firewire net: Setup broadcast and local fifo independently.
      firewire net: Check dev->broadcast_state inside fwnet_broadcast_start().
      firewire net: Fix memory leakage in fwnet_remove().
      firewire net: Clear dev->broadcast_rcv_context and dev->broadcast_state after destruction of context.
      firewire net: Omit checking dev->broadcast_rcv_context in fwnet_broadcast_start().
      firewire net: Fix leakage of kmap for broadcast receive buffer.
      firewire net: Allocate dev->broadcast_rcv_buffer_ptrs early.
      firewire net: Introduce fwnet_broadcast_stop() to destroy broadcast resources.
      firewire net: Release broadcast/fifo resources on ifdown.
      netfilter: ip6t_NPT: Use csum_partial()

YOSHIFUJI Hideaki / ÂêâËó§Ëã±Êòé (6):
      firewire net: Accept IPv4 and ARP only.
      firewire net: Send L2 multicast via GASP.
      firewire net: Allocate address handler before registering net_device.
      firewire net: Ignore spd and max_payload advertised by ARP.
      firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.
      firewire net, ipv6: IPv6 over Firewire (RFC3146) support.

Yaniv Rosner (7):
      bnx2x: Add RJ45 SFP module detection
      bnx2x: Add EEE support for BCM84834
      bnx2x: Control SFP+ tap values via nvm config
      bnx2x: Support reading I2C EEPROM SFF8472
      bnx2x: Cosmetic changes
      bnx2x: Allow RX/TX pause control in autoneg
      bnx2x: correct reading of speed capabilities

Ying Xue (1):
      net: fix compile error of implicit declaration of skb_probe_transport_header

Yogesh Ashok Powar (6):
      mwifiex: cleanup VHT cap
      mwifiex: add support to configure VHT for AP mode
      mwifiex: Use pci_release_region() instead of a pci_release_regions()
      mwifiex: Call pci_release_region after calling pci_disable_device
      mwifiex: Do not kfree cmd buf while unregistering PCIe
      mwifiex: Correct pci_unmap_single's size

Yuchung Cheng (4):
      tcp: refactor F-RTO
      tcp: refactor CA_Loss state processing
      tcp: implement RFC5682 F-RTO
      tcp: reset timer after any SYNACK retransmit

Yuval Mintz (11):
      bnx2x: fix vlan-mac memory leak
      bnx2x: Take chip version from MFW
      bnx2x: Get gso_segs from FW
      bnx2x: Avoid using zero MAC
      bnx2x: AER revised
      bnx2x: Fix AER semaphore release
      bnx2x: prevent GRO false checksum claims
      bnx2x: Fix memory leak
      bnx2x: Allow recovery from second slot reset
      bnx2x: Prevent NULL pointer dereference in kdump
      bnx2x: Prevent memory leak when cnic is absent

Zefan Li (4):
      net: remove redundant ifdef CONFIG_CGROUPS
      tcp_memcontrol: remove a redundant statement in tcp_destroy_cgroup()
      cls_cgroup: remove task_struct parameter from sock_update_classid()
      netprio_cgroup: remove task_struct parameter from sock_update_netprio()

Zefir Kurtisi (5):
      ath9k: trivial: change spectral relayfs buffering
      ath9k: add interface combinations for DFS master
      ath9k: add debugfs based DFS radar simulation
      ath9k: add support for DFS master mode
      ath9k: change DFS logging to use ath_dbg()

Zhang Yanfei (3):
      driver: isdn: capi: remove cast for kmalloc return value
      driver: isdn: hisax: remove cast for kmalloc/kzalloc return value
      qeth: remove cast for kzalloc return value

akepner (1):
      ixgbe: in shutdown, do netif_running() under rtnl_lock

dingtianhong (1):
      net: Remove return value from list_netdevice()

hayeswang (8):
      r8169: Remove firmware code
      r8169: Modify the mothod for PHY settings of RTL8111G
      r8169: Update PHY settings of RTL8111G
      r8169: Modify the method for setting firmware
      r8169: Update the RTL8111G parameters
      r8169: add a new chip for RTL8111G
      r8169: adjust the flow of hw_start
      r8169: add a new chip for RTL8106E

holger@eitzenberger.org (2):
      netfilter: xt_NFQUEUE: introduce CPU fanout
      netfilter: xt_NFQUEUE: coalesce IPv4 and IPv6 hashing

nikolay@redhat.com (2):
      netxen: write IP address to firmware when using bonding
      bonding: fix locking in enslave failure path

roopa (1):
      bridge: Add fdb dst check during fdb update

sjur.brandeland@stericsson.com (4):
      MAINTAINERS: Change Maintainer for CAIF
      caif: Remove my bouncing email address.
      caif: Remove bouncing address for Daniel Martensson
      caif: Update Dmitry's email address.

stefan@datenfreihafen.org (2):
      ieee802154/at86rf230: Implement hardware address filter callback.
      ieee802154/at86rf230: Fix register names for RX_AACK_ON and TX_ARET_ON

stephen hemminger (18):
      bna: fix declaration mismatch
      Supject: phy: make local function static
      phy: vitesse make vsc824x_add_skew static
      team: make local function static
      dcb: fix sparse warnings
      sfc: make local functions static
      netfilter: nf_conntrack: add include to fix sparse warning
      chelsio: use netdev_alloc_skb_ip_align
      bnx2: make cnic_probe static
      xen-netback: fix sparse warning
      netprio_cgroup: make local table static
      vxlan: update mail address and copyright date
      vxlan: document UDP default port
      vxlan: fix byte order issues with NDA_PORT
      vxlan: source compatiablity with IFLA_VXLAN_GROUP (v2)
      vxlan: compute source port in network byte order
      vxlan: allow choosing destination port per vxlan
      bridge: avoid OOPS if root port not found

 Documentation/ABI/testing/sysfs-class-net-mesh               |    8 +
 Documentation/DocBook/80211.tmpl                             |    2 +-
 Documentation/cgroups/00-INDEX                               |    2 +
 Documentation/cgroups/net_cls.txt                            |   34 +
 Documentation/devicetree/bindings/marvell.txt                |    3 +
 Documentation/devicetree/bindings/net/can/atmel-can.txt      |   14 +
 Documentation/devicetree/bindings/net/cpsw.txt               |   16 +-
 Documentation/devicetree/bindings/net/dsa/dsa.txt            |   91 +++
 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt |    4 +
 Documentation/networking/ieee802154.txt                      |    5 +-
 Documentation/networking/ip-sysctl.txt                       |   53 +-
 Documentation/networking/netlink_mmap.txt                    |  339 ++++++++
 Documentation/networking/packet_mmap.txt                     |  368 ++++++++-
 Documentation/networking/stmmac.txt                          |   45 +-
 MAINTAINERS                                                  |    8 +-
 arch/alpha/include/uapi/asm/socket.h                         |    2 +
 arch/arm/boot/dts/am33xx.dtsi                                |    2 +-
 arch/arm/net/bpf_jit_32.c                                    |    5 +-
 arch/arm/plat-orion/common.c                                 |   54 +-
 arch/avr32/include/uapi/asm/socket.h                         |    2 +
 arch/cris/include/uapi/asm/socket.h                          |    2 +
 arch/frv/include/uapi/asm/socket.h                           |    2 +
 arch/h8300/include/uapi/asm/socket.h                         |    2 +
 arch/ia64/include/uapi/asm/socket.h                          |    2 +
 arch/m32r/include/uapi/asm/socket.h                          |    2 +
 arch/mips/include/uapi/asm/socket.h                          |    2 +
 arch/mn10300/include/uapi/asm/socket.h                       |    2 +
 arch/parisc/include/uapi/asm/socket.h                        |    2 +
 arch/powerpc/include/uapi/asm/socket.h                       |    2 +
 arch/powerpc/net/bpf_jit_comp.c                              |   12 +-
 arch/powerpc/platforms/chrp/pegasos_eth.c                    |   20 +
 arch/powerpc/sysdev/mv64x60_dev.c                            |   16 +-
 arch/s390/include/uapi/asm/socket.h                          |    2 +
 arch/sparc/include/uapi/asm/socket.h                         |    2 +
 arch/sparc/net/bpf_jit_comp.c                                |    6 +-
 arch/x86/net/bpf_jit_comp.c                                  |    9 +-
 arch/xtensa/include/uapi/asm/socket.h                        |    2 +
 drivers/atm/he.c                                             |    2 +-
 drivers/bcma/core.c                                          |    8 +-
 drivers/bcma/driver_chipcommon.c                             |    5 +-
 drivers/bcma/driver_chipcommon_pmu.c                         |   34 +-
 drivers/bcma/main.c                                          |    5 +
 drivers/bcma/scan.c                                          |   16 +-
 drivers/bcma/sprom.c                                         |    1 +
 drivers/bluetooth/ath3k.c                                    |    2 +
 drivers/bluetooth/btmrvl_debugfs.c                           |  266 +------
 drivers/bluetooth/btmrvl_sdio.c                              |   49 +-
 drivers/bluetooth/btusb.c                                    |  418 +++++++++-
 drivers/bluetooth/hci_h4.c                                   |    3 +
 drivers/bluetooth/hci_ldisc.c                                |   15 +-
 drivers/connector/cn_proc.c                                  |   25 +
 drivers/connector/connector.c                                |   12 +-
 drivers/dma/ioat/dca.c                                       |   11 +-
 drivers/firewire/Kconfig                                     |    6 +-
 drivers/firewire/net.c                                       |  462 +++++------
 drivers/infiniband/hw/cxgb4/cm.c                             |   68 +-
 drivers/infiniband/hw/cxgb4/device.c                         |   34 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h                       |   14 +-
 drivers/infiniband/hw/cxgb4/mem.c                            |  155 +++-
 drivers/infiniband/hw/cxgb4/provider.c                       |   15 +-
 drivers/infiniband/hw/cxgb4/qp.c                             |  113 ++-
 drivers/infiniband/hw/cxgb4/t4.h                             |   11 +-
 drivers/infiniband/hw/mlx4/cq.c                              |    2 +-
 drivers/infiniband/hw/nes/nes_hw.c                           |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c                          |   14 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c                    |    4 +-
 drivers/isdn/capi/capidrv.c                                  |    3 +-
 drivers/isdn/divert/isdn_divert.c                            |    8 +-
 drivers/isdn/hisax/fsm.c                                     |    2 +-
 drivers/isdn/hisax/hfc_sx.c                                  |    2 +-
 drivers/isdn/i4l/isdn_net.c                                  |    2 +-
 drivers/isdn/mISDN/socket.c                                  |    1 +
 drivers/isdn/sc/init.c                                       |    4 +-
 drivers/media/dvb-core/dvb_net.c                             |   10 +-
 drivers/net/Kconfig                                          |    1 +
 drivers/net/appletalk/Kconfig                                |   18 +-
 drivers/net/bonding/bond_alb.c                               |    4 +-
 drivers/net/bonding/bond_main.c                              |   72 +-
 drivers/net/caif/Kconfig                                     |    7 -
 drivers/net/caif/Makefile                                    |    4 -
 drivers/net/caif/caif_hsi.c                                  |    7 +-
 drivers/net/caif/caif_serial.c                               |    4 +-
 drivers/net/caif/caif_shm_u5500.c                            |  128 ---
 drivers/net/caif/caif_shmcore.c                              |  747 ------------------
 drivers/net/caif/caif_spi.c                                  |    6 +-
 drivers/net/caif/caif_spi_slave.c                            |    3 +-
 drivers/net/can/Kconfig                                      |    2 +-
 drivers/net/can/at91_can.c                                   |   76 +-
 drivers/net/can/bfin_can.c                                   |    4 +-
 drivers/net/can/mcp251x.c                                    |   65 +-
 drivers/net/can/sja1000/ems_pci.c                            |    6 +-
 drivers/net/can/sja1000/ems_pcmcia.c                         |    6 +-
 drivers/net/can/sja1000/kvaser_pci.c                         |    4 +-
 drivers/net/can/sja1000/peak_pci.c                           |    2 +-
 drivers/net/can/sja1000/peak_pcmcia.c                        |    8 +-
 drivers/net/can/sja1000/plx_pci.c                            |   12 +-
 drivers/net/can/sja1000/sja1000.c                            |  126 +--
 drivers/net/can/sja1000/sja1000.h                            |   68 +-
 drivers/net/ethernet/3com/3c509.c                            |    2 +
 drivers/net/ethernet/3com/typhoon.c                          |    6 +-
 drivers/net/ethernet/adaptec/starfire.c                      |   10 +-
 drivers/net/ethernet/adi/bfin_mac.c                          |    6 +-
 drivers/net/ethernet/aeroflex/greth.c                        |   24 +-
 drivers/net/ethernet/alteon/acenic.c                         |    4 +-
 drivers/net/ethernet/amd/7990.c                              |    2 -
 drivers/net/ethernet/amd/a2065.c                             |    1 -
 drivers/net/ethernet/amd/am79c961a.c                         |    1 -
 drivers/net/ethernet/amd/amd8111e.c                          |    6 +-
 drivers/net/ethernet/amd/ariadne.c                           |    1 -
 drivers/net/ethernet/amd/atarilance.c                        |    6 +-
 drivers/net/ethernet/amd/au1000_eth.c                        |    1 -
 drivers/net/ethernet/amd/declance.c                          |    2 -
 drivers/net/ethernet/amd/mvme147.c                           |    4 +-
 drivers/net/ethernet/amd/ni65.c                              |    2 +-
 drivers/net/ethernet/amd/pcnet32.c                           |    1 -
 drivers/net/ethernet/amd/sun3lance.c                         |    7 +-
 drivers/net/ethernet/amd/sunlance.c                          |    9 +-
 drivers/net/ethernet/apple/macmace.c                         |   16 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c              |   24 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c              |   22 +-
 drivers/net/ethernet/atheros/atlx/atl1.c                     |   21 +-
 drivers/net/ethernet/atheros/atlx/atl2.c                     |   21 +-
 drivers/net/ethernet/atheros/atlx/atlx.c                     |   10 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c                 |   73 +-
 drivers/net/ethernet/broadcom/bgmac.c                        |   84 +-
 drivers/net/ethernet/broadcom/bgmac.h                        |    1 +
 drivers/net/ethernet/broadcom/bnx2.c                         |   19 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                  |   58 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c              |  368 ++++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h              |   47 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c          |  377 +++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h          |   91 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h              |  252 +++++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c             |  240 +++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h             |   16 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c             |  349 ++++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h              |    6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c               |   79 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h               |   21 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c            |  351 ++++++++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h            |   27 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c            |   77 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h            |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c             |  126 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h             |    9 +-
 drivers/net/ethernet/broadcom/cnic.c                         |    4 +-
 drivers/net/ethernet/broadcom/cnic_if.h                      |    3 +
 drivers/net/ethernet/broadcom/sb1250-mac.c                   |    5 +-
 drivers/net/ethernet/broadcom/tg3.c                          |  912 +++++++++++++++------
 drivers/net/ethernet/broadcom/tg3.h                          |   30 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c                   |    2 +-
 drivers/net/ethernet/brocade/bna/bnad.c                      |   17 +-
 drivers/net/ethernet/cadence/at91_ether.c                    |   80 +-
 drivers/net/ethernet/cadence/macb.c                          |   84 +-
 drivers/net/ethernet/cadence/macb.h                          |    2 +
 drivers/net/ethernet/calxeda/xgmac.c                         |    9 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                    |   13 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c                      |    9 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c              |   20 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c           |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c                     |    4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                   |   55 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c              |  819 +++++++++++++++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h               |    3 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c                     |   93 ++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                   |  256 ++++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h                   |    1 -
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h                  |   64 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h                 |   98 +++
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h                |   40 +-
 drivers/net/ethernet/chelsio/cxgb4vf/adapter.h               |    1 +
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c          |   75 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c                   |   13 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h           |   24 +
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c               |   14 +-
 drivers/net/ethernet/cirrus/cs89x0.c                         |   74 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c                     |   13 +-
 drivers/net/ethernet/cisco/enic/enic_dev.c                   |    4 +-
 drivers/net/ethernet/cisco/enic/enic_dev.h                   |    4 +-
 drivers/net/ethernet/cisco/enic/enic_main.c                  |    6 +-
 drivers/net/ethernet/cisco/enic/vnic_dev.c                   |    3 +
 drivers/net/ethernet/davicom/dm9000.c                        |   17 +-
 drivers/net/ethernet/dec/tulip/xircom_cb.c                   |    9 +-
 drivers/net/ethernet/dlink/dl2k.c                            |    7 +-
 drivers/net/ethernet/emulex/benet/be.h                       |   14 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                  |  257 ++++--
 drivers/net/ethernet/emulex/benet/be_cmds.h                  |  103 +--
 drivers/net/ethernet/emulex/benet/be_ethtool.c               |  177 ++++-
 drivers/net/ethernet/emulex/benet/be_hw.h                    |    9 +-
 drivers/net/ethernet/emulex/benet/be_main.c                  |  307 +++++---
 drivers/net/ethernet/emulex/benet/be_roce.c                  |    2 +-
 drivers/net/ethernet/emulex/benet/be_roce.h                  |    2 +-
 drivers/net/ethernet/faraday/ftgmac100.c                     |   22 +-
 drivers/net/ethernet/faraday/ftmac100.c                      |    8 +-
 drivers/net/ethernet/freescale/Makefile                      |    3 +-
 drivers/net/ethernet/freescale/fec.h                         |   10 +-
 drivers/net/ethernet/freescale/{fec.c => fec_main.c}         |  207 +++--
 drivers/net/ethernet/freescale/fec_mpc52xx.c                 |   16 +-
 drivers/net/ethernet/freescale/fec_ptp.c                     |    7 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c        |   17 +-
 drivers/net/ethernet/freescale/gianfar.c                     |  176 +++--
 drivers/net/ethernet/freescale/gianfar.h                     |    8 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c             |   29 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c                 |    6 +-
 drivers/net/ethernet/freescale/gianfar_sysfs.c               |    2 +-
 drivers/net/ethernet/freescale/ucc_geth.c                    |  881 +++++++++------------
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c            |   24 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c                    |    2 -
 drivers/net/ethernet/i825xx/82596.c                          |    8 +-
 drivers/net/ethernet/i825xx/lib82596.c                       |    6 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c                    |   28 +-
 drivers/net/ethernet/ibm/emac/mal.c                          |    9 +-
 drivers/net/ethernet/ibm/ibmveth.c                           |    6 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c             |    6 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c                |   47 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.c              |  131 ++--
 drivers/net/ethernet/intel/e1000e/82571.c                    |   38 +-
 drivers/net/ethernet/intel/e1000e/82571.h                    |    2 +
 drivers/net/ethernet/intel/e1000e/defines.h                  |   27 +-
 drivers/net/ethernet/intel/e1000e/e1000.h                    |   21 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c                  |  240 +++---
 drivers/net/ethernet/intel/e1000e/hw.h                       |    4 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                  |  408 +++++++---
 drivers/net/ethernet/intel/e1000e/ich8lan.h                  |   11 +-
 drivers/net/ethernet/intel/e1000e/mac.c                      |   37 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                   |  343 ++++----
 drivers/net/ethernet/intel/e1000e/nvm.c                      |    2 +-
 drivers/net/ethernet/intel/e1000e/param.c                    |   62 +-
 drivers/net/ethernet/intel/e1000e/phy.c                      |  134 ++--
 drivers/net/ethernet/intel/e1000e/ptp.c                      |    3 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                 |  261 ++++--
 drivers/net/ethernet/intel/igb/e1000_82575.h                 |    2 +
 drivers/net/ethernet/intel/igb/e1000_defines.h               |   50 +-
 drivers/net/ethernet/intel/igb/e1000_hw.h                    |   60 +-
 drivers/net/ethernet/intel/igb/e1000_i210.c                  |  156 +++-
 drivers/net/ethernet/intel/igb/e1000_i210.h                  |    4 +
 drivers/net/ethernet/intel/igb/e1000_mac.c                   |  124 ++-
 drivers/net/ethernet/intel/igb/e1000_mac.h                   |   17 +-
 drivers/net/ethernet/intel/igb/e1000_mbx.c                   |   11 +-
 drivers/net/ethernet/intel/igb/e1000_mbx.h                   |   52 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.c                   |   27 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c                   |  261 +++---
 drivers/net/ethernet/intel/igb/e1000_regs.h                  |   53 +-
 drivers/net/ethernet/intel/igb/igb.h                         |  133 ++--
 drivers/net/ethernet/intel/igb/igb_ethtool.c                 |  354 ++++++---
 drivers/net/ethernet/intel/igb/igb_hwmon.c                   |   29 +-
 drivers/net/ethernet/intel/igb/igb_main.c                    | 1419 +++++++++++++++++----------------
 drivers/net/ethernet/intel/igb/igb_ptp.c                     |   61 +-
 drivers/net/ethernet/intel/igbvf/netdev.c                    |   18 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c                  |   37 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                     |    5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c               |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c               |  110 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c              |   63 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h              |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c             |   39 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                |  179 +++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                 |   21 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c               |   25 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                |   20 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c                |    1 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h                 |    2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c            |  121 +--
 drivers/net/ethernet/intel/ixgbevf/vf.c                      |    7 +-
 drivers/net/ethernet/jme.c                                   |    6 +-
 drivers/net/ethernet/marvell/Kconfig                         |    6 +-
 drivers/net/ethernet/marvell/Makefile                        |    2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c                   |  378 ++-------
 drivers/net/ethernet/marvell/mvmdio.c                        |  142 +++-
 drivers/net/ethernet/marvell/mvneta.c                        |   14 +-
 drivers/net/ethernet/marvell/pxa168_eth.c                    |   27 +-
 drivers/net/ethernet/marvell/sky2.c                          |   11 +-
 drivers/net/ethernet/mellanox/mlx4/Makefile                  |    2 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c                     |  204 ++++-
 drivers/net/ethernet/mellanox/mlx4/cq.c                      |   10 +-
 drivers/net/ethernet/mellanox/mlx4/en_clock.c                |  151 ++++
 drivers/net/ethernet/mellanox/mlx4/en_cq.c                   |   10 +-
 drivers/net/ethernet/mellanox/mlx4/en_dcb_nl.c               |   10 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c              |   30 +
 drivers/net/ethernet/mellanox/mlx4/en_main.c                 |    5 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c               |  235 ++++--
 drivers/net/ethernet/mellanox/mlx4/en_resources.c            |    3 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                   |   33 +-
 drivers/net/ethernet/mellanox/mlx4/en_selftest.c             |    5 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                   |   31 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                      |   38 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h                      |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c                    |   79 ++
 drivers/net/ethernet/mellanox/mlx4/mcg.c                     |   51 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                    |   38 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                 |   26 +-
 drivers/net/ethernet/mellanox/mlx4/port.c                    |   23 +-
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c        |  129 ++-
 drivers/net/ethernet/micrel/ks8695net.c                      |   20 +-
 drivers/net/ethernet/micrel/ks8851.c                         |   53 +-
 drivers/net/ethernet/micrel/ks8851_mll.c                     |   32 +-
 drivers/net/ethernet/microchip/enc28j60.c                    |    4 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c             |   12 +-
 drivers/net/ethernet/natsemi/jazzsonic.c                     |   12 +-
 drivers/net/ethernet/natsemi/macsonic.c                      |   12 +-
 drivers/net/ethernet/natsemi/ns83820.c                       |    4 +-
 drivers/net/ethernet/natsemi/sonic.c                         |    1 -
 drivers/net/ethernet/natsemi/xtsonic.c                       |   12 +-
 drivers/net/ethernet/neterion/s2io.c                         |   10 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c               |   14 +-
 drivers/net/ethernet/netx-eth.c                              |    2 -
 drivers/net/ethernet/nuvoton/w90p910_ether.c                 |   20 +-
 drivers/net/ethernet/nvidia/forcedeth.c                      |   64 +-
 drivers/net/ethernet/nxp/lpc_eth.c                           |    4 -
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c         |   23 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c                     |    5 +-
 drivers/net/ethernet/qlogic/Kconfig                          |   10 +
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h              |    5 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c         |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c         |  222 ++++--
 drivers/net/ethernet/qlogic/qla3xxx.c                        |    1 -
 drivers/net/ethernet/qlogic/qlcnic/Makefile                  |    4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                  |  129 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c          |  505 ++++++++----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h          |  204 ++++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c        |  107 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c              |   75 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c          |  125 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hdr.h              |    6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c               |   63 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h               |   10 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c               |  104 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c             |  371 +++++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c         |    5 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h            |  263 +++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c     | 1954 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c         | 1780 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c            |  255 +++++-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                 |   34 +-
 drivers/net/ethernet/rdc/r6040.c                             |   12 +-
 drivers/net/ethernet/realtek/8139cp.c                        |    8 +-
 drivers/net/ethernet/realtek/8139too.c                       |    2 -
 drivers/net/ethernet/realtek/atp.c                           |    2 -
 drivers/net/ethernet/realtek/r8169.c                         |  295 +++++--
 drivers/net/ethernet/renesas/Kconfig                         |    3 +-
 drivers/net/ethernet/renesas/sh_eth.c                        |  410 ++++++++--
 drivers/net/ethernet/renesas/sh_eth.h                        |  220 ------
 drivers/net/ethernet/s6gmac.c                                |   16 +-
 drivers/net/ethernet/seeq/ether3.c                           |   22 +-
 drivers/net/ethernet/seeq/sgiseeq.c                          |    2 -
 drivers/net/ethernet/sfc/efx.c                               |  267 ++++++-
 drivers/net/ethernet/sfc/efx.h                               |   14 +-
 drivers/net/ethernet/sfc/enum.h                              |   12 +-
 drivers/net/ethernet/sfc/ethtool.c                           |    4 +-
 drivers/net/ethernet/sfc/falcon.c                            |   17 +-
 drivers/net/ethernet/sfc/filter.c                            |  249 ++++--
 drivers/net/ethernet/sfc/mcdi.c                              |    2 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h                         |    1 +
 drivers/net/ethernet/sfc/net_driver.h                        |   97 ++-
 drivers/net/ethernet/sfc/nic.c                               |   94 ++-
 drivers/net/ethernet/sfc/ptp.c                               |  116 +--
 drivers/net/ethernet/sfc/rx.c                                |  793 ++++++++++---------
 drivers/net/ethernet/sfc/siena.c                             |   25 +-
 drivers/net/ethernet/sgi/meth.c                              |    5 +-
 drivers/net/ethernet/sis/sis900.c                            |   41 +-
 drivers/net/ethernet/smsc/smc9194.c                          |    2 -
 drivers/net/ethernet/smsc/smc91x.c                           |    2 -
 drivers/net/ethernet/smsc/smsc911x.c                         |    2 +-
 drivers/net/ethernet/smsc/smsc9420.c                         |    4 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig                  |   19 +-
 drivers/net/ethernet/stmicro/stmmac/Makefile                 |    8 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c             |   92 ++-
 drivers/net/ethernet/stmicro/stmmac/common.h                 |  199 +++--
 drivers/net/ethernet/stmicro/stmmac/descs.h                  |   51 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h              |   43 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h              |   81 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c         |  168 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c          |   31 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c          |   31 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c           |   30 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h              |    4 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c               |  151 +++-
 drivers/net/ethernet/stmicro/stmmac/mmc.h                    |    3 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c              |   89 ++-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c              |   40 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                 |   73 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c         |  156 +++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c        |  148 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c            | 1340 +++++++++++++++++++++++--------
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c            |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c             |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c        |    8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c             |  211 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h             |   74 ++
 drivers/net/ethernet/sun/niu.c                               |    2 +-
 drivers/net/ethernet/sun/sunbmac.c                           |    4 +-
 drivers/net/ethernet/sun/sunhme.c                            |   13 +-
 drivers/net/ethernet/sun/sunqe.c                             |    5 +-
 drivers/net/ethernet/tehuti/tehuti.c                         |   17 +-
 drivers/net/ethernet/ti/cpsw.c                               |  330 ++++++--
 drivers/net/ethernet/ti/davinci_cpdma.c                      |   31 +-
 drivers/net/ethernet/ti/davinci_cpdma.h                      |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c                       |   54 +-
 drivers/net/ethernet/ti/davinci_mdio.c                       |    1 +
 drivers/net/ethernet/ti/tlan.c                               |    5 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                 |  240 +++---
 drivers/net/ethernet/toshiba/spider_net.c                    |    7 +-
 drivers/net/ethernet/tundra/tsi108_eth.c                     |   21 +-
 drivers/net/ethernet/via/via-rhine.c                         |   17 +-
 drivers/net/ethernet/via/via-velocity.c                      |   15 +-
 drivers/net/ethernet/wiznet/w5100.c                          |    4 +-
 drivers/net/ethernet/wiznet/w5300.c                          |    4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c                  |   33 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c            |   25 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c                     |    1 -
 drivers/net/fddi/defxx.c                                     |    9 +-
 drivers/net/hamradio/yam.c                                   |    2 +-
 drivers/net/hyperv/netvsc.c                                  |    2 +-
 drivers/net/hyperv/netvsc_drv.c                              |    2 +-
 drivers/net/ieee802154/at86rf230.c                           |  151 +++-
 drivers/net/ieee802154/fakehard.c                            |   21 -
 drivers/net/ieee802154/mrf24j40.c                            |   41 +-
 drivers/net/ifb.c                                            |    3 +-
 drivers/net/irda/ali-ircc.c                                  |    6 +-
 drivers/net/irda/au1k_ir.c                                   |   18 +-
 drivers/net/irda/bfin_sir.c                                  |    3 +-
 drivers/net/irda/nsc-ircc.c                                  |    6 +-
 drivers/net/irda/pxaficp_ir.c                                |    4 +-
 drivers/net/irda/smsc-ircc2.c                                |   17 +-
 drivers/net/irda/via-ircc.c                                  |    6 +-
 drivers/net/irda/w83977af_ir.c                               |    7 +-
 drivers/net/macvlan.c                                        |   29 +-
 drivers/net/macvtap.c                                        |    2 +
 drivers/net/phy/lxt.c                                        |    2 +-
 drivers/net/phy/marvell.c                                    |  127 +++
 drivers/net/phy/mdio-gpio.c                                  |   12 +-
 drivers/net/phy/mdio-octeon.c                                |  107 ++-
 drivers/net/phy/micrel.c                                     |   41 +-
 drivers/net/phy/phy.c                                        |   66 +-
 drivers/net/phy/spi_ks8995.c                                 |    8 +-
 drivers/net/phy/vitesse.c                                    |    3 +-
 drivers/net/plip/plip.c                                      |    2 +-
 drivers/net/ppp/ppp_synctty.c                                |   53 +-
 drivers/net/team/Kconfig                                     |   12 +
 drivers/net/team/Makefile                                    |    1 +
 drivers/net/team/team.c                                      |   45 +-
 drivers/net/team/team_mode_broadcast.c                       |   14 +-
 drivers/net/team/team_mode_random.c                          |   71 ++
 drivers/net/team/team_mode_roundrobin.c                      |   36 +-
 drivers/net/tun.c                                            |   20 +-
 drivers/net/usb/asix_devices.c                               |    6 +-
 drivers/net/usb/ax88179_178a.c                               |   12 +-
 drivers/net/usb/cdc_ether.c                                  |    5 +-
 drivers/net/usb/cdc_mbim.c                                   |    4 +-
 drivers/net/usb/cdc_ncm.c                                    |   18 +-
 drivers/net/usb/dm9601.c                                     |    7 +-
 drivers/net/usb/mcs7830.c                                    |    6 +-
 drivers/net/usb/pegasus.c                                    |  447 +++--------
 drivers/net/usb/pegasus.h                                    |   11 +-
 drivers/net/usb/sierra_net.c                                 |    3 +-
 drivers/net/usb/usbnet.c                                     |   45 +-
 drivers/net/veth.c                                           |    3 +-
 drivers/net/virtio_net.c                                     |   14 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                            |   17 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c                        |    5 +-
 drivers/net/vxlan.c                                          |  546 ++++++++-----
 drivers/net/wireless/adm8211.c                               |    3 +-
 drivers/net/wireless/at76c50x-usb.c                          |    4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c                     |   16 +-
 drivers/net/wireless/ath/ath5k/Makefile                      |    1 +
 drivers/net/wireless/ath/ath5k/ath5k.h                       |    3 +-
 drivers/net/wireless/ath/ath5k/base.c                        |    2 +-
 drivers/net/wireless/ath/ath5k/eeprom.c                      |    6 +-
 drivers/net/wireless/ath/ath5k/eeprom.h                      |    3 -
 drivers/net/wireless/ath/ath5k/mac80211-ops.c                |    4 +-
 drivers/net/wireless/ath/ath5k/phy.c                         |   20 +-
 drivers/net/wireless/ath/ath5k/reset.c                       |    4 +-
 drivers/net/wireless/ath/ath5k/trace.h                       |    2 +-
 drivers/net/wireless/ath/ath6kl/Kconfig                      |    9 +
 drivers/net/wireless/ath/ath6kl/Makefile                     |    5 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c                   |   15 +-
 drivers/net/wireless/ath/ath6kl/core.h                       |    3 -
 drivers/net/wireless/ath/ath6kl/debug.c                      |   72 +-
 drivers/net/wireless/ath/ath6kl/debug.h                      |   11 +-
 drivers/net/wireless/ath/ath6kl/hif.c                        |    3 +
 drivers/net/wireless/ath/ath6kl/htc_mbox.c                   |   21 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c                   |   15 +-
 drivers/net/wireless/ath/ath6kl/init.c                       |  116 ++-
 drivers/net/wireless/ath/ath6kl/main.c                       |   41 +-
 drivers/net/wireless/ath/ath6kl/sdio.c                       |   16 +-
 drivers/net/wireless/ath/ath6kl/target.h                     |    2 +-
 drivers/net/wireless/ath/ath6kl/trace.c                      |   23 +
 drivers/net/wireless/ath/ath6kl/trace.h                      |  332 ++++++++
 drivers/net/wireless/ath/ath6kl/txrx.c                       |    5 +-
 drivers/net/wireless/ath/ath6kl/usb.c                        |   38 +-
 drivers/net/wireless/ath/ath6kl/wmi.c                        |    6 +
 drivers/net/wireless/ath/ath9k/ar5008_phy.c                  |   92 +--
 drivers/net/wireless/ath/ath9k/ar9002_calib.c                |    9 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c                   |   17 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c                |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c               |   17 +
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h         |   49 +-
 drivers/net/wireless/ath/ath9k/ath9k.h                       |    9 +-
 drivers/net/wireless/ath/ath9k/beacon.c                      |    2 +-
 drivers/net/wireless/ath/ath9k/calib.c                       |    6 +-
 drivers/net/wireless/ath/ath9k/calib.h                       |    6 +
 drivers/net/wireless/ath/ath9k/common.c                      |   19 +-
 drivers/net/wireless/ath/ath9k/common.h                      |    3 +-
 drivers/net/wireless/ath/ath9k/debug.c                       |    7 +-
 drivers/net/wireless/ath/ath9k/debug.h                       |    2 +
 drivers/net/wireless/ath/ath9k/dfs.c                         |   10 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c                   |   20 +
 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c        |   43 +-
 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h        |    6 +-
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c            |   49 +-
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h            |   27 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c              |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c                |   18 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                |   18 +-
 drivers/net/wireless/ath/ath9k/hw.c                          |  198 +++--
 drivers/net/wireless/ath/ath9k/hw.h                          |   14 -
 drivers/net/wireless/ath/ath9k/init.c                        |   41 +-
 drivers/net/wireless/ath/ath9k/link.c                        |    2 +-
 drivers/net/wireless/ath/ath9k/mac.c                         |    8 +
 drivers/net/wireless/ath/ath9k/mac.h                         |    1 +
 drivers/net/wireless/ath/ath9k/main.c                        |   46 +-
 drivers/net/wireless/ath/ath9k/rc.c                          |    4 +-
 drivers/net/wireless/ath/ath9k/recv.c                        |  177 +++--
 drivers/net/wireless/ath/ath9k/reg.h                         |    3 -
 drivers/net/wireless/ath/ath9k/xmit.c                        |  137 ++--
 drivers/net/wireless/ath/carl9170/carl9170.h                 |    8 +-
 drivers/net/wireless/ath/carl9170/debug.c                    |    4 +-
 drivers/net/wireless/ath/carl9170/mac.c                      |    8 +-
 drivers/net/wireless/ath/carl9170/main.c                     |   11 +-
 drivers/net/wireless/ath/carl9170/phy.c                      |   85 +-
 drivers/net/wireless/ath/carl9170/tx.c                       |   69 +-
 drivers/net/wireless/ath/hw.c                                |    6 +
 drivers/net/wireless/ath/key.c                               |    9 +-
 drivers/net/wireless/ath/reg.h                               |    4 +
 drivers/net/wireless/ath/wil6210/Makefile                    |    4 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c                  |   33 +-
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h               |   20 -
 drivers/net/wireless/ath/wil6210/debugfs.c                   |   58 +-
 drivers/net/wireless/ath/wil6210/interrupt.c                 |   25 +-
 drivers/net/wireless/ath/wil6210/main.c                      |   60 +-
 drivers/net/wireless/ath/wil6210/netdev.c                    |    3 -
 drivers/net/wireless/ath/wil6210/pcie_bus.c                  |    3 -
 drivers/net/wireless/ath/wil6210/txrx.c                      |   36 +-
 drivers/net/wireless/ath/wil6210/txrx.h                      |   49 +-
 drivers/net/wireless/ath/wil6210/wil6210.h                   |   17 +-
 drivers/net/wireless/ath/wil6210/wmi.c                       |  154 +++-
 drivers/net/wireless/ath/wil6210/wmi.h                       |  363 ++++++---
 drivers/net/wireless/b43/Kconfig                             |    6 +-
 drivers/net/wireless/b43/b43.h                               |   10 +-
 drivers/net/wireless/b43/dma.c                               |    9 +-
 drivers/net/wireless/b43/main.c                              |   38 +-
 drivers/net/wireless/b43/phy_ht.c                            |  708 ++++++++++++++---
 drivers/net/wireless/b43/phy_ht.h                            |   83 +-
 drivers/net/wireless/b43/phy_lcn.c                           |    5 +-
 drivers/net/wireless/b43/phy_lp.c                            |   16 +-
 drivers/net/wireless/b43/phy_n.c                             |  716 +++++++++--------
 drivers/net/wireless/b43/phy_n.h                             |  146 ++++
 drivers/net/wireless/b43/radio_2056.c                        |    6 +-
 drivers/net/wireless/b43/radio_2059.c                        |   39 +-
 drivers/net/wireless/b43/radio_2059.h                        |   14 +-
 drivers/net/wireless/b43/sdio.h                              |    4 +-
 drivers/net/wireless/b43/tables_nphy.c                       |  101 +--
 drivers/net/wireless/b43/tables_nphy.h                       |   29 +-
 drivers/net/wireless/b43/tables_phy_lcn.c                    |    6 +-
 drivers/net/wireless/b43legacy/dma.c                         |    8 +-
 drivers/net/wireless/b43legacy/main.c                        |    9 +-
 drivers/net/wireless/brcm80211/Kconfig                       |   14 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile             |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c             |  269 ++++---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c       |  176 ++---
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c             |  497 ++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.h             |   29 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                |   41 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h            |   15 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c            |   34 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c         |   33 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c            |   80 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h            |   55 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c          |  148 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h          |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c           |  794 ++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c               |   25 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h               |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c               |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c           | 2067 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h           |   33 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                |  288 +++++--
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c          |  369 ++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h          |  101 ++-
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h          |   32 +-
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c         |   22 +
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h         |  101 +++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                |   37 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c        |  594 +++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h        |   25 +-
 drivers/net/wireless/brcm80211/brcmsmac/Makefile             |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c            |    6 -
 drivers/net/wireless/brcm80211/brcmsmac/channel.c            |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/d11.h                |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/led.c                |  126 +++
 drivers/net/wireless/brcm80211/brcmsmac/led.h                |   36 +
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c        |   97 ++-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h        |    4 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c               |  377 ++++++---
 drivers/net/wireless/brcm80211/brcmsmac/main.h               |   25 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c        |   40 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h        |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c        |   35 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c          |   14 +-
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c                |   54 --
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h                |    6 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h                |   17 +-
 drivers/net/wireless/brcm80211/brcmutil/Makefile             |    9 +-
 drivers/net/wireless/brcm80211/brcmutil/d11.c                |  162 ++++
 drivers/net/wireless/brcm80211/brcmutil/utils.c              |   37 +-
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h         |    2 +
 drivers/net/wireless/brcm80211/include/brcmu_d11.h           |  145 ++++
 drivers/net/wireless/brcm80211/include/brcmu_utils.h         |   27 +
 drivers/net/wireless/brcm80211/include/brcmu_wifi.h          |   28 +-
 drivers/net/wireless/brcm80211/include/chipcommon.h          |   14 +-
 drivers/net/wireless/ipw2x00/ipw2100.c                       |   32 +-
 drivers/net/wireless/iwlegacy/3945-mac.c                     |    2 +-
 drivers/net/wireless/iwlegacy/3945-rs.c                      |    2 +-
 drivers/net/wireless/iwlegacy/3945.c                         |    4 +-
 drivers/net/wireless/iwlegacy/3945.h                         |    4 -
 drivers/net/wireless/iwlegacy/4965-mac.c                     |   65 +-
 drivers/net/wireless/iwlegacy/4965-rs.c                      |    2 +-
 drivers/net/wireless/iwlegacy/4965.c                         |    2 +-
 drivers/net/wireless/iwlegacy/common.c                       |   26 +-
 drivers/net/wireless/iwlegacy/common.h                       |   11 +-
 drivers/net/wireless/iwlwifi/Kconfig                         |   11 +-
 drivers/net/wireless/iwlwifi/Makefile                        |    3 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h                       |   10 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c                     |    2 +-
 drivers/net/wireless/iwlwifi/dvm/calib.h                     |    2 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h                  |    3 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c                   |   42 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c                   |   10 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c                       |   18 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                  |   32 +-
 drivers/net/wireless/iwlwifi/dvm/main.c                      |    6 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c                        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c                      |   11 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c                      |    2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c                       |    5 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c                  |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                        |   58 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c                     |    2 +-
 drivers/net/wireless/iwlwifi/{pcie/1000.c => iwl-1000.c}     |    1 -
 drivers/net/wireless/iwlwifi/{pcie/2000.c => iwl-2000.c}     |    1 -
 drivers/net/wireless/iwlwifi/{pcie/5000.c => iwl-5000.c}     |    1 -
 drivers/net/wireless/iwlwifi/{pcie/6000.c => iwl-6000.c}     |    1 -
 drivers/net/wireless/iwlwifi/{pcie/7000.c => iwl-7000.c}     |   63 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h                    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                    |   49 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h                       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.c                     |   13 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h                  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                       |   32 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h                       |   17 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c              |    9 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c               |    5 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h               |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h                        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h                   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h                        |   29 +-
 drivers/net/wireless/iwlwifi/iwl-io.c                        |   19 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h                 |    6 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c                |   15 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h                |    2 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                 |   51 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h                 |    2 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c                    |   11 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.h                    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h                      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-test.c                      |   14 +-
 drivers/net/wireless/iwlwifi/iwl-test.h                      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.h                  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h                     |    8 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile                    |    2 +-
 drivers/net/wireless/iwlwifi/mvm/binding.c                   |    2 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c                   |  589 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/d3.c                        |  267 ++++++-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                   |  257 +++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h            |  319 ++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h                 |   53 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h                |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h              |   66 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h                 |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h               |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h                |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                 |    8 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                    |   83 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c                        |   37 +-
 drivers/net/wireless/iwlwifi/mvm/led.c                       |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                  |   87 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                  |  119 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h                       |   59 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c                       |  145 +---
 drivers/net/wireless/iwlwifi/mvm/ops.c                       |   48 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                  |   14 +-
 drivers/net/wireless/iwlwifi/mvm/power.c                     |  117 ++-
 drivers/net/wireless/iwlwifi/mvm/quota.c                     |    5 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c                        |   50 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c                        |    2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c                      |    6 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c                       |   99 ++-
 drivers/net/wireless/iwlwifi/mvm/sta.h                       |    6 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c                |   50 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h                |    5 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c                        |   28 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c                     |    9 +-
 drivers/net/wireless/iwlwifi/pcie/cfg.h                      |  115 ---
 drivers/net/wireless/iwlwifi/pcie/drv.c                      |    6 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c                    |   25 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c                       |   13 +-
 drivers/net/wireless/libertas_tf/main.c                      |    8 +-
 drivers/net/wireless/mac80211_hwsim.c                        |  125 ++-
 drivers/net/wireless/mwifiex/11ac.c                          |   43 +-
 drivers/net/wireless/mwifiex/11ac.h                          |   17 +
 drivers/net/wireless/mwifiex/11n.c                           |   22 +
 drivers/net/wireless/mwifiex/11n_aggr.c                      |   14 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c                 |    2 +-
 drivers/net/wireless/mwifiex/Makefile                        |    1 +
 drivers/net/wireless/mwifiex/cfg80211.c                      |  255 ++++--
 drivers/net/wireless/mwifiex/cmdevt.c                        |   39 +-
 drivers/net/wireless/mwifiex/decl.h                          |   11 +-
 drivers/net/wireless/mwifiex/ethtool.c                       |   70 ++
 drivers/net/wireless/mwifiex/fw.h                            |   83 +-
 drivers/net/wireless/mwifiex/init.c                          |   33 +-
 drivers/net/wireless/mwifiex/ioctl.h                         |   31 +
 drivers/net/wireless/mwifiex/join.c                          |   23 +
 drivers/net/wireless/mwifiex/main.c                          |   15 +-
 drivers/net/wireless/mwifiex/main.h                          |   23 +-
 drivers/net/wireless/mwifiex/pcie.c                          |  216 ++---
 drivers/net/wireless/mwifiex/scan.c                          |   37 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                       |   83 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c                   |    6 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                     |   30 +-
 drivers/net/wireless/mwifiex/txrx.c                          |    2 +
 drivers/net/wireless/mwifiex/uap_cmd.c                       |   55 ++
 drivers/net/wireless/mwifiex/util.c                          |    6 +-
 drivers/net/wireless/mwifiex/wmm.c                           |  208 ++---
 drivers/net/wireless/mwifiex/wmm.h                           |    3 +
 drivers/net/wireless/mwl8k.c                                 |  167 ++--
 drivers/net/wireless/orinoco/orinoco_usb.c                   |    2 +-
 drivers/net/wireless/p54/fwio.c                              |    4 +-
 drivers/net/wireless/p54/main.c                              |    6 +-
 drivers/net/wireless/p54/p54spi.c                            |    6 +-
 drivers/net/wireless/p54/txrx.c                              |    4 +-
 drivers/net/wireless/ray_cs.c                                |    8 +-
 drivers/net/wireless/rndis_wlan.c                            |    5 +-
 drivers/net/wireless/rt2x00/Kconfig                          |    7 +
 drivers/net/wireless/rt2x00/rt2400pci.c                      |  323 ++++----
 drivers/net/wireless/rt2x00/rt2500pci.c                      |  353 ++++-----
 drivers/net/wireless/rt2x00/rt2500usb.c                      |   35 +-
 drivers/net/wireless/rt2x00/rt2800.h                         |  103 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c                      | 1597 ++++++++++++++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2800pci.c                      |  377 +++++----
 drivers/net/wireless/rt2x00/rt2800usb.c                      |  111 ++-
 drivers/net/wireless/rt2x00/rt2x00.h                         |   95 ++-
 drivers/net/wireless/rt2x00/rt2x00config.c                   |   10 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c                    |    8 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c                      |   24 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c                 |   25 +-
 drivers/net/wireless/rt2x00/rt2x00leds.c                     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                      |   19 +-
 drivers/net/wireless/rt2x00/rt2x00mmio.c                     |   52 +-
 drivers/net/wireless/rt2x00/rt2x00mmio.h                     |   52 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c                      |   14 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c                    |   57 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h                    |   15 +-
 drivers/net/wireless/rt2x00/rt2x00soc.c                      |    4 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c                      |   44 +-
 drivers/net/wireless/rt2x00/rt61pci.c                        |  550 ++++++-------
 drivers/net/wireless/rt2x00/rt73usb.c                        |   32 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c                   |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/grf5101.c               |    3 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.c               |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c               |    3 +-
 drivers/net/wireless/rtl818x/rtl8180/sa2400.c                |    3 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c                   |    4 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.c               |    3 +-
 drivers/net/wireless/rtlwifi/Kconfig                         |    9 +
 drivers/net/wireless/rtlwifi/Makefile                        |    1 +
 drivers/net/wireless/rtlwifi/base.c                          |  383 +++++++--
 drivers/net/wireless/rtlwifi/base.h                          |   14 +-
 drivers/net/wireless/rtlwifi/core.c                          |  221 ++++--
 drivers/net/wireless/rtlwifi/debug.c                         |    5 +-
 drivers/net/wireless/rtlwifi/debug.h                         |   13 +-
 drivers/net/wireless/rtlwifi/efuse.c                         |   53 +-
 drivers/net/wireless/rtlwifi/efuse.h                         |    1 -
 drivers/net/wireless/rtlwifi/pci.c                           |  150 +++-
 drivers/net/wireless/rtlwifi/pci.h                           |    2 +
 drivers/net/wireless/rtlwifi/ps.c                            |  330 +++++++-
 drivers/net/wireless/rtlwifi/ps.h                            |    2 +
 drivers/net/wireless/rtlwifi/rtl8188ee/Makefile              |   16 +
 drivers/net/wireless/rtlwifi/rtl8188ee/def.h                 |  324 ++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c                  | 1794 ++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.h                  |  326 ++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c                  |  830 ++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.h                  |  301 +++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c                  | 2530 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.h                  |   68 ++
 drivers/net/wireless/rtlwifi/rtl8188ee/led.c                 |  157 ++++
 drivers/net/wireless/rtlwifi/rtl8188ee/led.h                 |   38 +
 drivers/net/wireless/rtlwifi/rtl8188ee/phy.c                 | 2202 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/phy.h                 |  236 ++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c              |  109 +++
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h              |  327 ++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c           |  140 ++++
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h           |   97 +++
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h                 | 2258 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/rf.c                  |  467 +++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/rf.h                  |   46 ++
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c                  |  400 ++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.h                  |   36 +
 drivers/net/wireless/rtlwifi/rtl8188ee/table.c               |  643 +++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/table.h               |   47 ++
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c                 |  817 +++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.h                 |  795 +++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c            |  105 +--
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c            |   99 ++-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h            |    4 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                  |  118 ++-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h                  |    4 +
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h                 |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c                  |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c                 |  328 ++------
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c                  |   20 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c                  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c                 |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c                  |   32 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c                  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c                 |   40 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h                 |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c                  |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c                 |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192se/def.h                 |    7 -
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c                  |   49 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c                  |  150 ++--
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h                  |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c                 |   61 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.h                 |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c                  |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c                 |  300 +------
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c                  |   88 ++-
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.h                  |    6 +
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c                  |   97 ++-
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.h                  |    7 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c                  |   70 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/led.c                 |   22 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c                  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c                 |   14 +-
 drivers/net/wireless/rtlwifi/usb.c                           |  226 ++++--
 drivers/net/wireless/rtlwifi/usb.h                           |    5 +-
 drivers/net/wireless/rtlwifi/wifi.h                          |  224 +++++-
 drivers/net/wireless/ti/wl1251/main.c                        |    5 +-
 drivers/net/wireless/ti/wl1251/sdio.c                        |    4 +-
 drivers/net/wireless/ti/wl1251/spi.c                         |    4 +-
 drivers/net/wireless/ti/wl12xx/cmd.c                         |    2 +-
 drivers/net/wireless/ti/wl12xx/main.c                        |    1 +
 drivers/net/wireless/ti/wl12xx/wl12xx.h                      |    2 +
 drivers/net/wireless/ti/wl18xx/cmd.c                         |    6 +-
 drivers/net/wireless/ti/wl18xx/main.c                        |   25 +-
 drivers/net/wireless/ti/wl18xx/reg.h                         |   29 +
 drivers/net/wireless/ti/wl18xx/wl18xx.h                      |    4 +-
 drivers/net/wireless/ti/wlcore/acx.c                         |   29 +
 drivers/net/wireless/ti/wlcore/acx.h                         |   16 +-
 drivers/net/wireless/ti/wlcore/cmd.c                         |   32 +
 drivers/net/wireless/ti/wlcore/debug.h                       |   33 +-
 drivers/net/wireless/ti/wlcore/debugfs.c                     |    3 +-
 drivers/net/wireless/ti/wlcore/event.c                       |    9 +-
 drivers/net/wireless/ti/wlcore/main.c                        |  205 +++--
 drivers/net/wireless/ti/wlcore/ps.c                          |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c                          |   39 +-
 drivers/net/wireless/ti/wlcore/wlcore.h                      |    3 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h                    |   29 +-
 drivers/net/wireless/zd1211rw/zd_mac.c                       |    4 +-
 drivers/net/xen-netback/netback.c                            |  316 ++++++--
 drivers/net/xen-netfront.c                                   |   47 +-
 drivers/nfc/Kconfig                                          |   10 +
 drivers/nfc/Makefile                                         |    1 +
 drivers/nfc/mei_phy.c                                        |  164 ++++
 drivers/nfc/mei_phy.h                                        |   30 +
 drivers/nfc/microread/Kconfig                                |    2 +-
 drivers/nfc/microread/mei.c                                  |  139 +---
 drivers/nfc/pn533.c                                          |  653 ++++++++++-----
 drivers/nfc/pn544/Kconfig                                    |   13 +-
 drivers/nfc/pn544/Makefile                                   |    2 +
 drivers/nfc/pn544/mei.c                                      |  121 +++
 drivers/of/of_mdio.c                                         |   64 +-
 drivers/pci/iov.c                                            |   41 +
 drivers/ptp/ptp_clock.c                                      |   38 +-
 drivers/ptp/ptp_pch.c                                        |   29 +-
 drivers/s390/kvm/virtio_ccw.c                                |    6 +-
 drivers/s390/net/qeth_core.h                                 |    4 +-
 drivers/s390/net/qeth_core_main.c                            |    8 +-
 drivers/s390/net/qeth_l2_main.c                              |   13 +-
 drivers/s390/net/qeth_l3_main.c                              |   33 +-
 drivers/scsi/bnx2fc/bnx2fc.h                                 |   23 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                            |   35 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                             |   22 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                              |    9 +-
 drivers/scsi/csiostor/Makefile                               |    3 +-
 drivers/scsi/csiostor/csio_hw.c                              |  559 +++----------
 drivers/scsi/csiostor/csio_hw.h                              |   47 +-
 drivers/scsi/csiostor/csio_hw_chip.h                         |  175 +++++
 drivers/scsi/csiostor/csio_hw_t4.c                           |  403 ++++++++++
 drivers/scsi/csiostor/csio_hw_t5.c                           |  397 ++++++++++
 drivers/scsi/csiostor/csio_init.c                            |   48 +-
 drivers/scsi/csiostor/csio_init.h                            |   29 +-
 drivers/scsi/csiostor/csio_lnode.h                           |    2 +-
 drivers/scsi/csiostor/csio_rnode.c                           |   10 +-
 drivers/scsi/csiostor/csio_rnode.h                           |    2 +-
 drivers/scsi/csiostor/csio_wr.c                              |   60 +-
 drivers/scsi/fcoe/fcoe.c                                     |    2 +-
 drivers/scsi/scsi_netlink.c                                  |    4 +-
 drivers/scsi/scsi_transport_fc.c                             |   21 +-
 drivers/scsi/scsi_transport_iscsi.c                          |   70 +-
 drivers/ssb/driver_chipcommon.c                              |    2 +-
 drivers/ssb/driver_chipcommon_pmu.c                          |   60 +-
 drivers/ssb/driver_mipscore.c                                |   25 +-
 drivers/ssb/driver_pcicore.c                                 |   15 +-
 drivers/ssb/embedded.c                                       |    5 +-
 drivers/ssb/main.c                                           |   51 +-
 drivers/ssb/pci.c                                            |  120 +--
 drivers/ssb/pcmcia.c                                         |   46 +-
 drivers/ssb/scan.c                                           |   31 +-
 drivers/ssb/sprom.c                                          |    4 +-
 drivers/ssb/ssb_private.h                                    |   19 +-
 drivers/staging/gdm72xx/netlink_k.c                          |   12 +-
 drivers/vhost/net.c                                          |   74 +-
 drivers/vhost/vhost.c                                        |    3 +
 fs/dlm/lowcomms.c                                            |    2 +-
 include/linux/bcma/bcma.h                                    |   55 ++
 include/linux/bcma/bcma_driver_chipcommon.h                  |    6 +
 include/linux/bcma/bcma_regs.h                               |    1 +
 include/linux/cn_proc.h                                      |    4 +
 include/linux/filter.h                                       |   15 +
 include/linux/icmpv6.h                                       |   18 +-
 include/linux/ieee80211.h                                    |  125 ++-
 include/linux/if_arp.h                                       |   12 +-
 include/linux/if_team.h                                      |   25 +-
 include/linux/if_vlan.h                                      |   56 +-
 include/linux/ktime.h                                        |   18 +
 include/linux/micrel_phy.h                                   |    1 +
 include/linux/mlx4/cmd.h                                     |    6 +
 include/linux/mlx4/cq.h                                      |   16 +
 include/linux/mlx4/device.h                                  |   13 +-
 include/linux/mv643xx_eth.h                                  |    1 -
 include/linux/netdev_features.h                              |   27 +-
 include/linux/netdevice.h                                    |   79 +-
 include/linux/netfilter.h                                    |    5 -
 include/linux/netfilter/ipset/ip_set.h                       |  126 ++-
 include/linux/netfilter/ipset/ip_set_ahash.h                 | 1241 -----------------------------
 include/linux/netfilter/ipset/ip_set_bitmap.h                |    6 +
 include/linux/netfilter/ipset/ip_set_timeout.h               |  102 +--
 include/linux/netfilter/ipset/pfxlen.h                       |    9 +
 include/linux/netfilter/nfnetlink.h                          |   11 +-
 include/linux/netlink.h                                      |   11 +-
 include/linux/netpoll.h                                      |    2 +-
 include/linux/of_net.h                                       |   10 +
 include/linux/openvswitch.h                                  |  431 +---------
 include/linux/pci.h                                          |    5 +
 include/linux/phy.h                                          |   10 +
 include/linux/platform_data/brcmfmac-sdio.h                  |  124 +++
 include/linux/platform_data/cpsw.h                           |    2 +-
 include/linux/rtnetlink.h                                    |    9 +
 include/linux/sctp.h                                         |    6 +-
 include/linux/sh_eth.h                                       |    1 +
 include/linux/skbuff.h                                       |   95 ++-
 include/linux/sock_diag.h                                    |    3 +
 include/linux/socket.h                                       |    1 +
 include/linux/spi/at86rf230.h                                |   14 +
 include/linux/ssb/ssb.h                                      |   60 +-
 include/linux/ssb/ssb_regs.h                                 |   10 +-
 include/linux/tcp.h                                          |   21 +-
 include/linux/usb/usbnet.h                                   |    2 +
 include/linux/virtio.h                                       |    6 -
 include/linux/vm_sockets.h                                   |   23 +
 include/net/af_unix.h                                        |    8 +-
 include/net/bluetooth/bluetooth.h                            |   17 +-
 include/net/bluetooth/hci.h                                  |   30 +-
 include/net/bluetooth/hci_core.h                             |  128 ++-
 include/net/bluetooth/l2cap.h                                |   15 +
 include/net/bluetooth/rfcomm.h                               |    6 -
 include/net/caif/caif_dev.h                                  |    2 +-
 include/net/caif/caif_device.h                               |    2 +-
 include/net/caif/caif_hsi.h                                  |    1 -
 include/net/caif/caif_layer.h                                |    2 +-
 include/net/caif/caif_shm.h                                  |   26 -
 include/net/caif/cfcnfg.h                                    |    2 +-
 include/net/caif/cfctrl.h                                    |    2 +-
 include/net/caif/cffrml.h                                    |    2 +-
 include/net/caif/cfmuxl.h                                    |    2 +-
 include/net/caif/cfpkt.h                                     |    2 +-
 include/net/caif/cfserl.h                                    |    2 +-
 include/net/caif/cfsrvl.h                                    |    2 +-
 include/net/cfg80211.h                                       |  164 +++-
 include/net/cls_cgroup.h                                     |    4 +-
 include/net/dn_fib.h                                         |   28 +-
 include/net/firewire.h                                       |   25 +
 include/net/genetlink.h                                      |    1 +
 include/net/gre.h                                            |   51 ++
 include/net/ieee802154_netdev.h                              |    5 +-
 include/net/if_inet6.h                                       |    4 +
 include/net/inet_connection_sock.h                           |    5 +-
 include/net/inet_frag.h                                      |   24 +-
 include/net/ip6_tunnel.h                                     |   21 +
 include/net/ip_tunnels.h                                     |  177 +++++
 include/net/ip_vs.h                                          |  140 ++--
 include/net/ipip.h                                           |   87 --
 include/net/ipv6.h                                           |   22 +-
 include/net/mac80211.h                                       |  224 ++++--
 include/net/net_namespace.h                                  |    2 +
 include/net/netfilter/nf_conntrack.h                         |    2 +-
 include/net/netfilter/nf_conntrack_core.h                    |    1 +
 include/net/netfilter/nf_conntrack_expect.h                  |    4 +-
 include/net/netfilter/nf_log.h                               |   14 +-
 include/net/netfilter/nf_queue.h                             |    6 +
 include/net/netns/ipv6.h                                     |    1 +
 include/net/netns/netfilter.h                                |   18 +
 include/net/netprio_cgroup.h                                 |    4 +-
 include/net/nfc/nfc.h                                        |    2 +
 include/net/request_sock.h                                   |   10 +-
 include/net/rtnetlink.h                                      |    2 +-
 include/net/scm.h                                            |   16 +-
 include/net/sctp/checksum.h                                  |    2 +-
 include/net/sctp/constants.h                                 |    1 -
 include/net/sctp/structs.h                                   |   20 +-
 include/net/sctp/ulpqueue.h                                  |    1 -
 include/net/secure_seq.h                                     |    1 +
 include/net/sock.h                                           |    6 +-
 include/net/tcp.h                                            |  146 +---
 include/net/xfrm.h                                           |    1 +
 include/uapi/asm-generic/socket.h                            |    2 +
 include/uapi/linux/Kbuild                                    |    2 +
 include/uapi/linux/caif/caif_socket.h                        |    2 +-
 include/uapi/linux/caif/if_caif.h                            |    2 +-
 include/uapi/linux/cn_proc.h                                 |   10 +-
 include/uapi/linux/filter.h                                  |    3 +-
 include/uapi/linux/if_ether.h                                |    3 +
 include/uapi/linux/if_link.h                                 |    7 +-
 include/uapi/linux/if_packet.h                               |   29 +-
 include/uapi/linux/ip_vs.h                                   |    4 +-
 include/uapi/linux/neighbour.h                               |    3 +
 include/uapi/linux/netfilter/ipset/ip_set.h                  |   36 +-
 include/uapi/linux/netfilter/nfnetlink_queue.h               |   10 +-
 include/uapi/linux/netfilter/xt_NFQUEUE.h                    |    9 +
 include/uapi/linux/netfilter/xt_set.h                        |    9 +
 include/uapi/linux/netfilter_ipv6/ip6t_frag.h                |    4 +-
 include/uapi/linux/netlink.h                                 |   34 +-
 include/uapi/linux/netlink_diag.h                            |   52 ++
 include/uapi/linux/nfc.h                                     |   19 +
 include/uapi/linux/nl80211.h                                 |  156 +++-
 include/uapi/linux/openvswitch.h                             |  456 +++++++++++
 include/uapi/linux/packet_diag.h                             |    5 +
 include/uapi/linux/pkt_sched.h                               |    1 +
 include/uapi/linux/rfkill.h                                  |    2 +
 include/{net/sctp/user.h => uapi/linux/sctp.h}               |   84 +-
 include/uapi/linux/snmp.h                                    |    8 +
 include/uapi/linux/tcp.h                                     |   26 -
 include/uapi/linux/vm_sockets.h                              |   23 +-
 include/uapi/linux/xfrm.h                                    |    3 +
 include/xen/interface/io/netif.h                             |   19 +
 kernel/audit.c                                               |   10 +-
 kernel/signal.c                                              |    2 +
 net/802/garp.c                                               |    4 +
 net/8021q/Kconfig                                            |    2 +-
 net/8021q/vlan.c                                             |   97 +--
 net/8021q/vlan.h                                             |   58 +-
 net/8021q/vlan_core.c                                        |   80 +-
 net/8021q/vlan_dev.c                                         |   11 +-
 net/8021q/vlan_gvrp.c                                        |    4 +
 net/8021q/vlan_mvrp.c                                        |    4 +
 net/8021q/vlan_netlink.c                                     |   32 +-
 net/Kconfig                                                  |    1 +
 net/appletalk/ddp.c                                          |    2 +-
 net/atm/lec.h                                                |    2 +-
 net/batman-adv/Kconfig                                       |   14 +
 net/batman-adv/Makefile                                      |    3 +-
 net/batman-adv/bat_iv_ogm.c                                  |    5 +
 net/batman-adv/bridge_loop_avoidance.c                       |    2 +-
 net/batman-adv/debugfs.c                                     |   18 +
 net/batman-adv/distributed-arp-table.c                       |   22 +-
 net/batman-adv/gateway_client.c                              |    2 +-
 net/batman-adv/hard-interface.c                              |   66 +-
 net/batman-adv/hard-interface.h                              |   13 +-
 net/batman-adv/main.c                                        |   16 +-
 net/batman-adv/main.h                                        |   15 +-
 net/batman-adv/network-coding.c                              | 1822 ++++++++++++++++++++++++++++++++++++++++++
 net/batman-adv/network-coding.h                              |  123 +++
 net/batman-adv/originator.c                                  |   10 +-
 net/batman-adv/packet.h                                      |   33 +
 net/batman-adv/routing.c                                     |   61 +-
 net/batman-adv/send.c                                        |    5 +
 net/batman-adv/soft-interface.c                              |  288 ++++---
 net/batman-adv/soft-interface.h                              |    3 +-
 net/batman-adv/sysfs.c                                       |   22 +-
 net/batman-adv/translation-table.c                           |   29 +-
 net/batman-adv/types.h                                       |  136 ++++
 net/batman-adv/unicast.c                                     |    6 +-
 net/batman-adv/vis.c                                         |    4 +-
 net/bluetooth/a2mp.c                                         |    6 +-
 net/bluetooth/af_bluetooth.c                                 |   18 +-
 net/bluetooth/bnep/netdev.c                                  |    2 +-
 net/bluetooth/bnep/sock.c                                    |    4 +-
 net/bluetooth/cmtp/sock.c                                    |    4 +-
 net/bluetooth/hci_conn.c                                     |   42 +-
 net/bluetooth/hci_core.c                                     |  901 +++++++++++++++++----
 net/bluetooth/hci_event.c                                    |  781 +++++-------------
 net/bluetooth/hci_sock.c                                     |    9 +-
 net/bluetooth/hci_sysfs.c                                    |   21 +-
 net/bluetooth/hidp/core.c                                    |  994 +++++++++++++----------
 net/bluetooth/hidp/hidp.h                                    |   67 +-
 net/bluetooth/hidp/sock.c                                    |   26 +-
 net/bluetooth/l2cap_core.c                                   |  134 +++-
 net/bluetooth/l2cap_sock.c                                   |   10 +-
 net/bluetooth/mgmt.c                                         |  703 +++++++++++------
 net/bluetooth/rfcomm/core.c                                  |  167 ++--
 net/bluetooth/rfcomm/sock.c                                  |    3 +-
 net/bluetooth/sco.c                                          |   52 +-
 net/bluetooth/smp.c                                          |    2 +-
 net/bridge/br_device.c                                       |    4 +-
 net/bridge/br_fdb.c                                          |   30 +-
 net/bridge/br_if.c                                           |    1 -
 net/bridge/br_mdb.c                                          |    4 +-
 net/bridge/br_multicast.c                                    |    2 +-
 net/bridge/br_netfilter.c                                    |    3 +-
 net/bridge/br_netlink.c                                      |   21 +-
 net/bridge/br_stp.c                                          |    9 +-
 net/bridge/br_vlan.c                                         |   20 +-
 net/bridge/netfilter/ebt_log.c                               |   44 +-
 net/bridge/netfilter/ebt_nflog.c                             |    5 +-
 net/bridge/netfilter/ebt_ulog.c                              |  132 +++-
 net/bridge/netfilter/ebtable_broute.c                        |    4 +-
 net/bridge/netfilter/ebtables.c                              |    2 +-
 net/caif/caif_dev.c                                          |   11 +-
 net/caif/caif_socket.c                                       |   24 +-
 net/caif/caif_usb.c                                          |    6 +-
 net/caif/cfcnfg.c                                            |   21 +-
 net/caif/cfctrl.c                                            |   16 +-
 net/caif/cfdbgl.c                                            |    2 +-
 net/caif/cfdgml.c                                            |    2 +-
 net/caif/cffrml.c                                            |    6 +-
 net/caif/cfmuxl.c                                            |    6 +-
 net/caif/cfpkt_skbuff.c                                      |   10 +-
 net/caif/cfrfml.c                                            |    6 +-
 net/caif/cfserl.c                                            |    6 +-
 net/caif/cfsrvl.c                                            |   15 +-
 net/caif/cfutill.c                                           |    2 +-
 net/caif/cfveil.c                                            |    2 +-
 net/caif/cfvidl.c                                            |    2 +-
 net/caif/chnl_net.c                                          |   10 +-
 net/can/af_can.c                                             |   30 +-
 net/can/gw.c                                                 |    5 +-
 net/can/raw.c                                                |    5 +-
 net/core/datagram.c                                          |   26 +-
 net/core/dev.c                                               |  120 +--
 net/core/dev_addr_lists.c                                    |  210 ++++-
 net/core/dst.c                                               |    9 +-
 net/core/ethtool.c                                           |   29 +-
 net/core/fib_rules.c                                         |    4 +-
 net/core/filter.c                                            |    5 +
 net/core/flow.c                                              |   42 +-
 net/core/flow_dissector.c                                    |   68 ++
 net/core/neighbour.c                                         |   55 +-
 net/core/net-procfs.c                                        |    2 +-
 net/core/netpoll.c                                           |   22 +-
 net/core/rtnetlink.c                                         |  178 +++--
 net/core/scm.c                                               |   20 +-
 net/core/secure_seq.c                                        |    4 +-
 net/core/skbuff.c                                            |   93 ++-
 net/core/sock.c                                              |   22 +-
 net/core/sock_diag.c                                         |   33 +
 net/core/utils.c                                             |    5 +-
 net/dcb/dcbevent.c                                           |    1 +
 net/dcb/dcbnl.c                                              |    2 +-
 net/dccp/ipv4.c                                              |    5 +-
 net/dccp/ipv6.c                                              |    5 +-
 net/decnet/dn_dev.c                                          |    4 +-
 net/decnet/dn_fib.c                                          |  203 ++---
 net/decnet/dn_route.c                                        |   43 +-
 net/decnet/dn_table.c                                        |   45 +-
 net/decnet/netfilter/dn_rtmsg.c                              |   12 +-
 net/dsa/dsa.c                                                |  233 +++++-
 net/ethernet/eth.c                                           |    2 +-
 net/ieee802154/6lowpan.c                                     |  142 +++-
 net/ieee802154/6lowpan.h                                     |    7 +-
 net/ieee802154/dgram.c                                       |   10 +
 net/ieee802154/netlink.c                                     |    8 +-
 net/ieee802154/nl-mac.c                                      |   25 +-
 net/ipv4/Kconfig                                             |    7 +
 net/ipv4/Makefile                                            |    1 +
 net/ipv4/af_inet.c                                           |   15 +-
 net/ipv4/arp.c                                               |   27 +-
 net/ipv4/devinet.c                                           |   83 +-
 net/ipv4/fib_frontend.c                                      |   10 +-
 net/ipv4/gre.c                                               |    5 -
 net/ipv4/icmp.c                                              |    4 +-
 net/ipv4/inet_connection_sock.c                              |    2 +-
 net/ipv4/inet_diag.c                                         |   10 +-
 net/ipv4/inet_fragment.c                                     |   84 +-
 net/ipv4/inet_lro.c                                          |    5 +-
 net/ipv4/ip_fragment.c                                       |   31 +-
 net/ipv4/ip_gre.c                                            | 1517 ++++++++---------------------------
 net/ipv4/ip_input.c                                          |    4 +-
 net/ipv4/ip_output.c                                         |    3 +-
 net/ipv4/ip_tunnel.c                                         | 1035 ++++++++++++++++++++++++
 net/ipv4/ip_vti.c                                            |   42 +-
 net/ipv4/ipcomp.c                                            |    1 +
 net/ipv4/ipconfig.c                                          |   13 +-
 net/ipv4/ipip.c                                              |  748 ++----------------
 net/ipv4/ipmr.c                                              |   12 +-
 net/ipv4/netfilter.c                                         |   15 +-
 net/ipv4/netfilter/Kconfig                                   |    2 +-
 net/ipv4/netfilter/arp_tables.c                              |    1 +
 net/ipv4/netfilter/arptable_filter.c                         |    4 +-
 net/ipv4/netfilter/ip_tables.c                               |   10 +-
 net/ipv4/netfilter/ipt_ULOG.c                                |  134 +++-
 net/ipv4/netfilter/iptable_mangle.c                          |    9 +-
 net/ipv4/netfilter/iptable_nat.c                             |   23 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c               |    1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c        |    1 +
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c                 |    9 +-
 net/ipv4/netfilter/nf_nat_h323.c                             |    1 +
 net/ipv4/netfilter/nf_nat_pptp.c                             |    2 +
 net/ipv4/netfilter/nf_nat_proto_gre.c                        |    2 +
 net/ipv4/netfilter/nf_nat_snmp_basic.c                       |    2 +
 net/ipv4/ping.c                                              |    5 +-
 net/ipv4/proc.c                                              |   13 +-
 net/ipv4/route.c                                             |    2 +-
 net/ipv4/syncookies.c                                        |    3 +-
 net/ipv4/sysctl_net_ipv4.c                                   |   18 +-
 net/ipv4/tcp.c                                               |  287 +------
 net/ipv4/tcp_input.c                                         |  607 ++++----------
 net/ipv4/tcp_ipv4.c                                          |  123 +--
 net/ipv4/tcp_memcontrol.c                                    |    3 -
 net/ipv4/tcp_minisocks.c                                     |   51 +-
 net/ipv4/tcp_output.c                                        |  377 ++++-----
 net/ipv4/tcp_timer.c                                         |   21 +-
 net/ipv4/tcp_westwood.c                                      |    2 +-
 net/ipv4/udp.c                                               |  132 +++-
 net/ipv4/udp_diag.c                                          |   10 +-
 net/ipv4/xfrm4_mode_tunnel.c                                 |    8 +-
 net/ipv6/Kconfig                                             |    2 +
 net/ipv6/Makefile                                            |    2 +-
 net/ipv6/addrconf.c                                          |  208 ++++-
 net/ipv6/addrlabel.c                                         |   12 +-
 net/ipv6/af_inet6.c                                          |    7 +-
 net/ipv6/datagram.c                                          |   20 +-
 net/ipv6/icmp.c                                              |   41 +-
 net/ipv6/inet6_connection_sock.c                             |   10 +-
 net/ipv6/ip6_flowlabel.c                                     |   11 +-
 net/ipv6/ip6_gre.c                                           |   62 +-
 net/ipv6/ip6_icmp.c                                          |   47 ++
 net/ipv6/ip6_offload.c                                       |    4 +-
 net/ipv6/ip6_output.c                                        |    7 +-
 net/ipv6/ip6_tunnel.c                                        |   16 +-
 net/ipv6/ip6mr.c                                             |   10 +-
 net/ipv6/ndisc.c                                             |    2 -
 net/ipv6/netfilter.c                                         |   12 +-
 net/ipv6/netfilter/Kconfig                                   |    2 +-
 net/ipv6/netfilter/ip6_tables.c                              |    4 +-
 net/ipv6/netfilter/ip6t_NPT.c                                |   11 +-
 net/ipv6/netfilter/ip6t_REJECT.c                             |    2 +
 net/ipv6/netfilter/ip6table_mangle.c                         |    9 +-
 net/ipv6/netfilter/ip6table_nat.c                            |   23 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c               |    8 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c               |    7 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c                      |   22 +-
 net/ipv6/proc.c                                              |    4 +
 net/ipv6/raw.c                                               |    9 +-
 net/ipv6/reassembly.c                                        |   23 +-
 net/ipv6/route.c                                             |    6 +-
 net/ipv6/sit.c                                               |   41 +-
 net/ipv6/syncookies.c                                        |    3 +-
 net/ipv6/tcp_ipv6.c                                          |   75 +-
 net/ipv6/udp.c                                               |   34 +-
 net/ipv6/udp_offload.c                                       |    8 +-
 net/ipv6/xfrm6_mode_tunnel.c                                 |    7 +-
 net/irda/af_irda.c                                           |    5 +-
 net/irda/ircomm/ircomm_core.c                                |    2 +-
 net/irda/irlmp.c                                             |    2 +-
 net/iucv/af_iucv.c                                           |    3 +-
 net/l2tp/l2tp_core.c                                         |    2 +-
 net/mac80211/cfg.c                                           |  235 ++++--
 net/mac80211/chan.c                                          |   54 +-
 net/mac80211/debugfs_key.c                                   |   10 +-
 net/mac80211/debugfs_netdev.c                                |   33 +-
 net/mac80211/debugfs_sta.c                                   |   33 +
 net/mac80211/driver-ops.h                                    |   67 +-
 net/mac80211/ht.c                                            |   52 +-
 net/mac80211/ibss.c                                          |  175 ++---
 net/mac80211/ieee80211_i.h                                   |   86 +-
 net/mac80211/iface.c                                         |  150 ++--
 net/mac80211/key.c                                           |  208 +++--
 net/mac80211/key.h                                           |   18 +-
 net/mac80211/main.c                                          |  159 ++--
 net/mac80211/mesh.c                                          |   70 +-
 net/mac80211/mesh.h                                          |   15 +-
 net/mac80211/mesh_hwmp.c                                     |   28 +-
 net/mac80211/mesh_pathtbl.c                                  |   56 +-
 net/mac80211/mesh_plink.c                                    |   43 +-
 net/mac80211/mlme.c                                          |  554 +++++++------
 net/mac80211/offchannel.c                                    |   16 +-
 net/mac80211/pm.c                                            |  132 +---
 net/mac80211/rate.c                                          |  324 ++++++--
 net/mac80211/rc80211_minstrel.c                              |  342 ++++----
 net/mac80211/rc80211_minstrel.h                              |   34 +-
 net/mac80211/rc80211_minstrel_debugfs.c                      |   16 +-
 net/mac80211/rc80211_minstrel_ht.c                           |  273 ++++---
 net/mac80211/rc80211_minstrel_ht.h                           |    8 +-
 net/mac80211/rx.c                                            |   85 +-
 net/mac80211/scan.c                                          |   20 +-
 net/mac80211/sta_info.c                                      |   56 +-
 net/mac80211/sta_info.h                                      |   11 +-
 net/mac80211/trace.h                                         |   97 ++-
 net/mac80211/tx.c                                            |  163 ++--
 net/mac80211/util.c                                          |  224 +++---
 net/mac80211/vht.c                                           |  212 ++++-
 net/mac802154/mac802154.h                                    |    5 +-
 net/mac802154/mac_cmd.c                                      |    1 +
 net/mac802154/mib.c                                          |   21 +-
 net/mac802154/tx.c                                           |   29 +-
 net/mac802154/wpan.c                                         |    4 +-
 net/netfilter/core.c                                         |   30 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h                      |  277 +++++++
 net/netfilter/ipset/ip_set_bitmap_ip.c                       |  411 +++-------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c                    |  624 ++++++---------
 net/netfilter/ipset/ip_set_bitmap_port.c                     |  414 +++-------
 net/netfilter/ipset/ip_set_core.c                            |   41 +-
 net/netfilter/ipset/ip_set_hash_gen.h                        | 1100 ++++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_ip.c                         |  344 +++-----
 net/netfilter/ipset/ip_set_hash_ipport.c                     |  362 +++------
 net/netfilter/ipset/ip_set_hash_ipportip.c                   |  368 +++------
 net/netfilter/ipset/ip_set_hash_ipportnet.c                  |  469 ++++-------
 net/netfilter/ipset/ip_set_hash_net.c                        |  402 +++-------
 net/netfilter/ipset/ip_set_hash_netiface.c                   |  478 ++++-------
 net/netfilter/ipset/ip_set_hash_netport.c                    |  456 ++++-------
 net/netfilter/ipset/ip_set_list_set.c                        |  622 +++++++++------
 net/netfilter/ipvs/ip_vs_app.c                               |   31 +-
 net/netfilter/ipvs/ip_vs_conn.c                              |  312 ++++----
 net/netfilter/ipvs/ip_vs_core.c                              |   88 +--
 net/netfilter/ipvs/ip_vs_ctl.c                               |  702 ++++++++---------
 net/netfilter/ipvs/ip_vs_dh.c                                |   86 +-
 net/netfilter/ipvs/ip_vs_est.c                               |    2 +-
 net/netfilter/ipvs/ip_vs_ftp.c                               |    4 +
 net/netfilter/ipvs/ip_vs_lblc.c                              |  115 +--
 net/netfilter/ipvs/ip_vs_lblcr.c                             |  190 ++---
 net/netfilter/ipvs/ip_vs_lc.c                                |    3 +-
 net/netfilter/ipvs/ip_vs_nq.c                                |    3 +-
 net/netfilter/ipvs/ip_vs_pe.c                                |   55 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c                            |   10 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c                        |   38 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c                         |   40 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c                         |   33 +-
 net/netfilter/ipvs/ip_vs_rr.c                                |   64 +-
 net/netfilter/ipvs/ip_vs_sched.c                             |   63 +-
 net/netfilter/ipvs/ip_vs_sed.c                               |    5 +-
 net/netfilter/ipvs/ip_vs_sh.c                                |   86 +-
 net/netfilter/ipvs/ip_vs_sync.c                              |   56 +-
 net/netfilter/ipvs/ip_vs_wlc.c                               |    5 +-
 net/netfilter/ipvs/ip_vs_wrr.c                               |  176 +++--
 net/netfilter/ipvs/ip_vs_xmit.c                              | 1050 +++++++++++--------------
 net/netfilter/nf_conntrack_amanda.c                          |    1 +
 net/netfilter/nf_conntrack_core.c                            |   56 +-
 net/netfilter/nf_conntrack_ecache.c                          |    8 +-
 net/netfilter/nf_conntrack_expect.c                          |    9 +-
 net/netfilter/nf_conntrack_ftp.c                             |    1 +
 net/netfilter/nf_conntrack_h323_main.c                       |    1 +
 net/netfilter/nf_conntrack_helper.c                          |    3 +-
 net/netfilter/nf_conntrack_irc.c                             |    1 +
 net/netfilter/nf_conntrack_netlink.c                         |  100 ++-
 net/netfilter/nf_conntrack_pptp.c                            |    2 +
 net/netfilter/nf_conntrack_proto.c                           |    1 +
 net/netfilter/nf_conntrack_proto_dccp.c                      |    9 +-
 net/netfilter/nf_conntrack_proto_gre.c                       |    1 +
 net/netfilter/nf_conntrack_proto_sctp.c                      |    3 +
 net/netfilter/nf_conntrack_proto_tcp.c                       |   20 +-
 net/netfilter/nf_conntrack_proto_udp.c                       |    7 +-
 net/netfilter/nf_conntrack_proto_udplite.c                   |    8 +-
 net/netfilter/nf_conntrack_standalone.c                      |   17 +-
 net/netfilter/nf_conntrack_tftp.c                            |    2 +-
 net/netfilter/nf_log.c                                       |  206 +++--
 net/netfilter/nf_nat_amanda.c                                |    1 +
 net/netfilter/nf_nat_core.c                                  |   10 +-
 net/netfilter/nf_nat_helper.c                                |    1 +
 net/netfilter/nf_nat_proto_sctp.c                            |    5 +-
 net/netfilter/nf_queue.c                                     |  148 +---
 net/netfilter/nfnetlink.c                                    |   27 +-
 net/netfilter/nfnetlink_log.c                                |  199 +++--
 net/netfilter/nfnetlink_queue_core.c                         |  439 ++++++++---
 net/netfilter/x_tables.c                                     |    1 +
 net/netfilter/xt_LOG.c                                       |   52 +-
 net/netfilter/xt_NFQUEUE.c                                   |   63 +-
 net/netfilter/xt_TCPMSS.c                                    |    1 +
 net/netfilter/xt_conntrack.c                                 |    1 +
 net/netfilter/xt_hashlimit.c                                 |    1 +
 net/netfilter/xt_limit.c                                     |    1 +
 net/netfilter/xt_osf.c                                       |    6 +-
 net/netfilter/xt_set.c                                       |   94 ++-
 net/netlink/Kconfig                                          |   19 +
 net/netlink/Makefile                                         |    3 +
 net/netlink/af_netlink.c                                     |  900 ++++++++++++++++++---
 net/netlink/af_netlink.h                                     |   82 ++
 net/netlink/diag.c                                           |  227 ++++++
 net/netlink/genetlink.c                                      |  119 ++-
 net/netrom/af_netrom.c                                       |    2 +
 net/nfc/Kconfig                                              |    2 +-
 net/nfc/Makefile                                             |    6 +-
 net/nfc/core.c                                               |   43 +
 net/nfc/{llcp => }/llcp.h                                    |   39 +-
 net/nfc/llcp/Kconfig                                         |    7 -
 net/nfc/{llcp/commands.c => llcp_commands.c}                 |  229 +++++-
 net/nfc/{llcp/llcp.c => llcp_core.c}                         |  241 ++++--
 net/nfc/{llcp/sock.c => llcp_sock.c}                         |  171 +++-
 net/nfc/netlink.c                                            |  175 ++++-
 net/nfc/nfc.h                                                |   60 +-
 net/openvswitch/actions.c                                    |    6 +-
 net/openvswitch/datapath.c                                   |  421 ++++++----
 net/openvswitch/datapath.h                                   |   72 +-
 net/openvswitch/dp_notify.c                                  |   82 +-
 net/openvswitch/flow.c                                       |    8 +-
 net/openvswitch/flow.h                                       |   21 -
 net/openvswitch/vport-internal_dev.c                         |   22 +-
 net/openvswitch/vport-netdev.c                               |   15 +-
 net/openvswitch/vport-netdev.h                               |    1 -
 net/openvswitch/vport.c                                      |   58 +-
 net/openvswitch/vport.h                                      |   21 +-
 net/packet/af_packet.c                                       |  302 ++++---
 net/packet/diag.c                                            |   27 +-
 net/packet/internal.h                                        |   10 +-
 net/phonet/pn_netlink.c                                      |    4 +-
 net/rfkill/core.c                                            |    4 +-
 net/rfkill/rfkill-gpio.c                                     |    7 +-
 net/rfkill/rfkill-regulator.c                                |    2 +-
 net/sched/act_api.c                                          |    2 +-
 net/sched/act_csum.c                                         |   39 +-
 net/sched/act_ipt.c                                          |   33 +-
 net/sched/cls_api.c                                          |   14 +-
 net/sched/cls_flow.c                                         |    2 +-
 net/sched/em_ipset.c                                         |    2 +-
 net/sched/sch_api.c                                          |   44 +-
 net/sched/sch_htb.c                                          |   31 +-
 net/sctp/associola.c                                         |   12 +-
 net/sctp/bind_addr.c                                         |    7 -
 net/sctp/endpointola.c                                       |   14 +-
 net/sctp/inqueue.c                                           |    7 -
 net/sctp/output.c                                            |    5 +-
 net/sctp/outqueue.c                                          |   11 +-
 net/sctp/probe.c                                             |    2 +-
 net/sctp/proc.c                                              |   12 +-
 net/sctp/socket.c                                            |    8 +-
 net/sctp/ssnmap.c                                            |   23 +-
 net/sctp/transport.c                                         |    1 -
 net/sctp/ulpqueue.c                                          |    3 -
 net/socket.c                                                 |   23 +-
 net/tipc/Kconfig                                             |    7 +
 net/tipc/Makefile                                            |    2 +
 net/tipc/bcast.c                                             |    4 +-
 net/tipc/bearer.c                                            |    7 +-
 net/tipc/bearer.h                                            |   16 +-
 net/tipc/core.c                                              |   12 +-
 net/tipc/discover.c                                          |    2 +-
 net/tipc/eth_media.c                                         |   39 +-
 net/tipc/ib_media.c                                          |  387 +++++++++
 net/tipc/netlink.c                                           |    6 +-
 net/unix/af_unix.c                                           |   45 +-
 net/unix/garbage.c                                           |   12 +-
 net/vmw_vsock/af_vsock.c                                     |    4 +-
 net/vmw_vsock/vmci_transport.c                               |   16 +-
 net/vmw_vsock/vmci_transport.h                               |    3 +
 net/wireless/ap.c                                            |   62 --
 net/wireless/core.c                                          |   77 +-
 net/wireless/core.h                                          |   25 +-
 net/wireless/mesh.c                                          |   15 +-
 net/wireless/mlme.c                                          |  235 +-----
 net/wireless/nl80211.c                                       | 2142 +++++++++++++++++++++++++++++++++-----------------
 net/wireless/nl80211.h                                       |   68 --
 net/wireless/rdev-ops.h                                      |   44 +-
 net/wireless/reg.c                                           |    8 +-
 net/wireless/sme.c                                           |   28 +-
 net/wireless/sysfs.c                                         |   25 +-
 net/wireless/trace.h                                         |   81 ++
 net/wireless/util.c                                          |   30 +-
 net/xfrm/xfrm_policy.c                                       |   23 +-
 net/xfrm/xfrm_state.c                                        |    1 +
 net/xfrm/xfrm_user.c                                         |   17 +-
 security/selinux/hooks.c                                     |    4 +-
 security/selinux/netlink.c                                   |    3 +-
 tools/Makefile                                               |   11 +-
 tools/net/Makefile                                           |   15 +
 tools/net/bpf_jit_disasm.c                                   |  199 +++++
 tools/testing/selftests/Makefile                             |    1 +
 tools/testing/selftests/net/.gitignore                       |    3 +
 tools/testing/selftests/net/Makefile                         |   19 +
 tools/testing/selftests/net/psock_fanout.c                   |  312 ++++++++
 tools/testing/selftests/net/psock_lib.h                      |  127 +++
 tools/testing/selftests/net/psock_tpacket.c                  |  824 +++++++++++++++++++
 tools/testing/selftests/net/run_afpackettests                |   26 +
 tools/testing/selftests/net/run_netsocktests                 |   12 +
 tools/testing/selftests/net/socket.c                         |   92 +++
 1506 files changed, 86375 insertions(+), 37075 deletions(-)
 create mode 100644 Documentation/cgroups/net_cls.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/atmel-can.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.txt
 create mode 100644 Documentation/networking/netlink_mmap.txt
 delete mode 100644 drivers/net/caif/caif_shm_u5500.c
 delete mode 100644 drivers/net/caif/caif_shmcore.c
 rename drivers/net/ethernet/freescale/{fec.c => fec_main.c} (92%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx4/en_clock.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h
 create mode 100644 drivers/net/team/team_mode_random.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.h
 delete mode 100644 drivers/net/wireless/ath/wil6210/dbg_hexdump.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/btcoex.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmutil/d11.c
 create mode 100644 drivers/net/wireless/brcm80211/include/brcmu_d11.h
 rename drivers/net/wireless/iwlwifi/{pcie/1000.c => iwl-1000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{pcie/2000.c => iwl-2000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{pcie/5000.c => iwl-5000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{pcie/6000.c => iwl-6000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{pcie/7000.c => iwl-7000.c} (58%)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/bt-coex.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
 delete mode 100644 drivers/net/wireless/iwlwifi/pcie/cfg.h
 create mode 100644 drivers/net/wireless/mwifiex/ethtool.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/trx.h
 create mode 100644 drivers/nfc/mei_phy.c
 create mode 100644 drivers/nfc/mei_phy.h
 create mode 100644 drivers/nfc/pn544/mei.c
 create mode 100644 drivers/scsi/csiostor/csio_hw_chip.h
 create mode 100644 drivers/scsi/csiostor/csio_hw_t4.c
 create mode 100644 drivers/scsi/csiostor/csio_hw_t5.c
 delete mode 100644 include/linux/netfilter/ipset/ip_set_ahash.h
 create mode 100644 include/linux/platform_data/brcmfmac-sdio.h
 create mode 100644 include/linux/vm_sockets.h
 delete mode 100644 include/net/caif/caif_shm.h
 create mode 100644 include/net/firewire.h
 create mode 100644 include/net/ip_tunnels.h
 delete mode 100644 include/net/ipip.h
 create mode 100644 include/net/netns/netfilter.h
 create mode 100644 include/uapi/linux/netlink_diag.h
 create mode 100644 include/uapi/linux/openvswitch.h
 rename include/{net/sctp/user.h => uapi/linux/sctp.h} (90%)
 create mode 100644 net/batman-adv/network-coding.c
 create mode 100644 net/batman-adv/network-coding.h
 create mode 100644 net/ipv4/ip_tunnel.c
 create mode 100644 net/ipv6/ip6_icmp.c
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_gen.h
 create mode 100644 net/netfilter/ipset/ip_set_hash_gen.h
 create mode 100644 net/netlink/Kconfig
 create mode 100644 net/netlink/af_netlink.h
 create mode 100644 net/netlink/diag.c
 rename net/nfc/{llcp => }/llcp.h (86%)
 delete mode 100644 net/nfc/llcp/Kconfig
 rename net/nfc/{llcp/commands.c => llcp_commands.c} (72%)
 rename net/nfc/{llcp/llcp.c => llcp_core.c} (87%)
 rename net/nfc/{llcp/sock.c => llcp_sock.c} (85%)
 create mode 100644 net/tipc/ib_media.c
 create mode 100644 tools/net/Makefile
 create mode 100644 tools/net/bpf_jit_disasm.c
 create mode 100644 tools/testing/selftests/net/.gitignore
 create mode 100644 tools/testing/selftests/net/Makefile
 create mode 100644 tools/testing/selftests/net/psock_fanout.c
 create mode 100644 tools/testing/selftests/net/psock_lib.h
 create mode 100644 tools/testing/selftests/net/psock_tpacket.c
 create mode 100644 tools/testing/selftests/net/run_afpackettests
 create mode 100644 tools/testing/selftests/net/run_netsocktests
 create mode 100644 tools/testing/selftests/net/socket.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
