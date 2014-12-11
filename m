Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411AbaLKVDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:03:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56652 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815AbaLKVC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:02:59 -0500
Date: Thu, 11 Dec 2014 16:02:55 -0500 (EST)
Message-Id: <20141211.160255.1994701234811969403.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 13:02:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBBL3frH014369


There is a silent merge conflict you need to resolve when you pull
this, arch/nios2/include/asm/Kbuild adds a reference to hash.h
via "generic-y += hash.h" which is removed by changes in the net-next
tree.  So you'll have to remove that line from the nios2 Kbuild
fild when you pull this.

1) New offloading infrastructure and example 'rocker' driver for offloading
   of switching and routing to hardware.

   This work was done by a large group of dedicated individuals, not
   limited to: Scott Feldman, Jiri Pirko, Thomas Graf, John Fastabend,
   Jamal Hadi Salim, Andy Gospodarek, Florian Fainelli, Roopa Prabhu

2) Start making the networking operate on IOV iterators instead of
   modifying iov objects in-situ during transfers.  Thanks to Al
   Viro and Herbert Xu.

3) A set of new netlink interfaces for the TIPC stack, from Richard
   Alpe.

4) Remove unnecessary looping during ipv6 routing lookups, from
   Martin KaFai Lau.

5) Add PAUSE frame generation support to gianfar driver, from Matei
   Pavaluca.

6) Allow for larger reordering levels in TCP, which are easily achievable
   in the real world right now, from Eric Dumazet.

7) Add a variable of napi_schedule that doesn't need to disable cpu
   interrupts, from Eric Dumazet.

8) Use a doubly linked list to optimize neigh_parms_release(), from
   Nicolas Dichtel.

9) Various enhancements to the kernel BPF verifier, and allow eBPF
   programs to actually be attached to sockets.  From Alexei
   Starovoitov.

10) Support TSO/LSO in sunvnet driver, from David L Stevens.

11) Allow controlling ECN usage via routing metrics, from Florian
    Westphal.

12) Remote checksum offload, from Tom Herbert.

13) Add split-header receive, BQL, and xmit_more support to amd-xgbe
    driver, from Thomas Lendacky.

14) Add MPLS support to openvswitch, from Simon Horman.

15) Support wildcard tunnel endpoints in ipv6 tunnels, from Steffen
    Klassert.

16) Do gro flushes on a per-device basis using a timer, from Eric
    Dumazet.  This tries to resolve the conflicting goals between
    the desired handling of bulk vs. RPC-like traffic.

17) Allow userspace to ask for the CPU upon what a packet was
    received/steered, via SO_INCOMING_CPU.  From Eric Dumazet.

18) Limit GSO packets to half the current congestion window, from
    Eric Dumazet.

19) Add a generic helper so that all drivers set their RSS keys
    in a consistent way, from Eric Dumazet.

20) Add xmit_more support to enic driver, from Govindarajulu
    Varadarajan.

21) Add VLAN packet scheduler action, from Jiri Pirko.

22) Support configurable RSS hash functions via ethtool, from
    Eyal Perry.

Please pull, thanks a lot!

The following changes since commit aa583096d9767892983332e7c1a984bd17e3cd39:

  copy_from_iter_nocache() (2014-12-08 20:25:23 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to 00c83b01d58068dfeb2e1351cca6fccf2a83fa8f:

  Fix race condition between vxlan_sock_add and vxlan_sock_release (2014-12-11 14:57:08 -0500)

----------------------------------------------------------------
Akeem G Abodunrin (2):
      i40e: Moving variable declaration out of the loops
      i40e: Add condition to enter fdir flush and reinit

Al Viro (36):
      separate kernel- and userland-side msghdr
      {compat_,}verify_iovec(): switch to generic copying of iovecs
      fold verify_iovec() into copy_msghdr_from_user()
      bury skb_copy_to_page()
      mlx5: don't duplicate kvfree()
      mlx4: don't duplicate kvfree()
      new helper: skb_copy_and_csum_datagram_msg()
      new helper: memcpy_from_msg()
      switch ipxrtr_route_packet() from iovec to msghdr
      new helper: memcpy_to_msg()
      switch drivers/net/tun.c to ->read_iter()
      switch macvtap to ->read_iter()
      new helpers: skb_copy_datagram_from_iter() and zerocopy_sg_from_iter()
      {macvtap,tun}_get_user(): switch to iov_iter
      kill zerocopy_sg_from_iovec()
      switch AF_PACKET and AF_UNIX to skb_copy_datagram_from_iter()
      switch sctp_user_addto_chunk() and sctp_datamsg_from_user() to passing iov_iter
      tipc_sendmsg(): pass msghdr instead of its ->msg_iov
      tipc_msg_build(): pass msghdr instead of its ->msg_iov
      vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr
      [atm] switch vcc_sendmsg() to copy_from_iter()
      rds: switch ->inc_copy_to_user() to passing iov_iter
      rds: switch rds_message_copy_from_user() to iov_iter
      Merge branch 'iov_iter' into for-davem-2
      raw.c: stick msghdr into raw_frag_vec
      ipv6 equivalent of "ipv4: Avoid reading user iov twice after raw_probe_proto_opt"
      ip_generic_getfrag, udplite_getfrag: switch to passing msghdr
      switch tcp_sock->ucopy from iovec (ucopy.iov) to msghdr (ucopy.msg)
      switch l2cap ->memcpy_fromiovec() to msghdr
      vmci: propagate msghdr all way down to __qp_memcpy_from_queue()
      put iov_iter into msghdr
      first fruits - kill l2cap ->memcpy_fromiovec()
      switch memcpy_to_msg() and skb_copy{,_and_csum}_datagram_msg() to primitives
      ppp_read(): switch to skb_copy_datagram_iter()
      skb_copy_datagram_iovec() can die
      bury memcpy_toiovec()

Alban Bedel (3):
      8139too: Allow setting MTU larger than 1500
      8139too: Allow using the largest possible MTU
      8139too: The maximum MTU should allow for VLAN headers

Alex Gartrell (1):
      ipvs: remove unnecessary assignment in __ip_vs_get_out_rt

Alexander Aring (193):
      ieee802154: 6lowpan: fix byteorder for frag tag
      ieee802154: reassembly: fix tag byteorder
      ieee802154: 6lowpan: fix sign of errno return val
      at86rf230: fix errno on tx timeout handling
      at86rf230: add missing error handling
      at86rf230: correct aret lifs and sifs handling
      at86rf230: correct at86rf2xx lifs timings
      at86rf230: squash unnecessary dereferencing
      at86rf230: add missing enable_irq
      at86rf230: fix race condition
      at86rf230: fix enable_irq handling on async spi
      at86rf230: remove unnecessary print of async error
      ieee802154: 6lowpan: improve packet registration
      ieee802154: 6lowpan: add RTNL assertion
      ieee802154: mac802154: remove FSF address
      ieee802154: ieee802154_dev: fix align typo
      mac802154: fix typo IEEE802515 to IEEE802154
      ieee802154: wpan-phy: change to __aligned(size)
      ieee802154: wpan-phy: use blank line after function
      ieee802154: wpan-class: fix trailing semicolon
      mac802154: move ieee802154_dev.c to main.c
      mac802154: move mac802154.h to ieee802154_i.h
      mac802154: move wpan.c to iface.c
      ieee802154: move wpan-phy.h to cfg802154.h
      ieee802154: move wpan-class.c to core.c
      ieee802154: move ieee802154 header
      MAINTAINERS: add missing headers in 802.15.4
      ieee802154: remove fakehard driver
      ieee802154: rename ieee802154_dev to ieee802154_hw
      mac802154: rename mac802154_priv to ieee802154_local
      mac802154: rename mac802154_sub_if_data
      mac802154: rename hw subif_data variable to local
      mac802154: rename sdata slaves and slaves_mtx
      mac802154: introduce hw_to_local function
      mac802154: introduce IEEE802154_DEV_TO_SUB_IF
      mac802154: rename dev_workqueue to workqueue
      mac802154: remove ieee802154_addr from driver_ops
      mac802154: tx: move xmit callback to tx file
      mac802154: tx: remove kmalloc in xmit hotpath
      mac802154: tx: squash multiple dereferencing
      mac802154: tx: remove xmit channel context switch
      mac802154: add netdev qeue helpers
      mac802154: tx: use queue helpers in xmit worker
      mac802154: tx: fix error handling while xmit
      mac802154: tx: add support for xmit_async callback
      mac802154: tx: don't allow if down while sync tx
      mac802154: tx: use netdev print helpers
      mac802154: tx: cleanup crc calculation
      mac802154: tx: move stats tx increment
      mac802154: tx: change naming convention
      mac802154: tx: add comment at sync xmit callback
      at86rf230: asynchronous xmit handling
      mac802154: tx: make worker information static
      mac802154: tx: use put_unaligned_le16 for copy crc
      ieee802154: drivers: use dev_alloc_skb
      mac802154: rx: use tasklet instead workqueue
      mac802154: rx: document ieee802154_rx() context requirement
      mac802154: rx: move receive handling into rx.c
      mac802154: tx: remove monitor receive while xmit
      mac802154: rx: rename remove mac802154_subif_rx
      mac802154: rx: move skb->protocol setting
      mac802154: rx: add CHECKSUM_UNNECESSARY
      mac802154: rx: add monitor pkt_type information
      mac802154: rx: move skb_reset_mac_header
      mac802154: rx: move rcu locking
      ieee802154: add valid psdu length helper
      at86rf230: use ieee802154_is_valid_psdu_len helper
      at86rf230: improve receive handling
      mac802154: rx: change naming convention
      mac802154: monitor: merge into iface implementation
      mac802154: main: move open and close into iface
      mac802154: declare struct ieee802154_ops as const
      mac802154: ops: declare channel and page as u8
      mac802154: introduce driver-ops header
      mac802154: use driver-ops function wrappers
      mac802154: remove might_sleep from driver layer
      mac802154: remove driver ops in wpan-phy
      mac802154: rework sdata state change to running
      mac802154: rename running to started
      mac802154: move local started handling
      mac802154: add synchronization handling
      mac802154: iface: remove assign to zero
      mac802154: remove channel attributes from sdata
      mac802154: move mac_params functions into mac_cmd
      mac802154: cleanup open count handling
      ieee802154: introduce sysfs file
      mac802154: main: remove unnecessary include
      mac802154: remove tab after define
      mac802154: add IEEE802154_HW_ARET hw flag
      mac802154: add hardware address filter flag
      mac802154: add support for promiscuous mode
      at86rf230: add support for promiscuous mode
      mac802154: separate omit tx/rx flags
      mac802154: rx: remove unnecessary parameter
      mac802154: rx: simplify crc receive handling
      mac802154: rx: add software checksum filtering check
      mac802154: rx: remove override pkt_type set to PACKET_HOST
      mac802154: rx: use netif_receive_skb
      mac802154: rx: add rx stats incrementation
      mac802154: rx: monitor receive cleanup
      mac802154: rx: add error handling after skb_clone
      at86rf230: deliver with checksum
      mac802154: add basic support for monitor
      at86rf230: fix page parameter constraints
      ieee802154: remove default channel settings
      at86rf230: add default channel settings
      cfg802154: introduce cfg802154_registered_device
      mac802154: introduce mac802154_config_ops
      ieee802154: add helper wpan_phy_to_rdev function
      cfg802154: convert deprecated iface add and del
      ieee802154: don't allow to change addr while netif_running
      mac802154: add helper for converting dev_addr
      mac802154: set extended address filter on ifup
      mac802154: set short address filter on ifup
      mac802154: set panid address filter on ifup
      mac802154: move phy settings into netlink receive
      ieee802154: add extended address validation helper
      mac802154: iface: add validation for extended address
      ieee802154: 6lowpan: remove set of mac address
      ieee802154: add missing ULL definition
      ieee802154: fix byteorder issues
      mac802154: fix byteorder issues
      ieee802154: sysfs: add missing include
      mac802154: cfg: add missing include
      ieee802154: remove unnecessary functions
      netdevice: add ieee802154_ptr to net_device
      ieee802154: rework wpan_phy index assignment
      ieee802154: remove nl802154 unused functions
      mac802154: move interface del handling in iface
      mac802154: move interface add handling in iface
      mac802154: move dev_hold out of ieee802154_if_add
      ieee802154: rework interface registration
      ieee802154: remove mlme get_phy callback
      mac802154: add default interface registration
      mac802154: add ieee802154_vif struct
      ieee802154: add IEEE802154_EXTENDED_ADDR_LEN
      ieee802154: add ieee802154_random_extended_addr
      mac802154: add ieee802154_le64_to_be64
      mac802154: cleanup ieee802154_netdev_to_extended_addr
      mac802154: add support for perm_extended_addr
      at86rf230: generate random perm extended address
      at86rf230: add force slotted operation bit
      mac802154: use IEEE802154_EXTENDED_ADDR_LEN
      mac802154: fix typo promisuous to promiscuous
      Bluetooth: 6lowpan: fix skb_unshare behaviour
      mac802154: move mac pib attributes into wpan_dev
      mac802154: remove mac_params in sdata
      ieee802154: rename wpan_phy_alloc
      ieee802154: add cfg802154_registered_device list
      ieee802154: add iftype to wpan_dev
      ieee802154: add wpan_dev_list
      ieee802154: sysfs add wpan_phy index and name
      ieee802154: add new nl802154 header
      ieee802154: add nl802154 framework
      ieee802154: add wpan_phy dump support
      ieee802154: add wpan_dev dump support
      mac820154: don't set monitor dev_addr
      ieee802154: netlink add rtnl lock
      ieee802154: fix iface dump with lowpan
      mac802154: protect address changes via ioctl
      mac820154: move interface unregistration into iface
      mac820154: rename sdata next to tmp
      mac820154: move mutex locks out of loop
      mac802154: add wpan_phy priv id
      mac802154: change module description
      mac802154: add ifname change notifier
      ieee802154: cleanup cfg802154 intendation
      ieee820154: add channel set support
      ieee820154: remove valid page and channel checks
      ieee820154: add pan_id setting support
      ieee820154: add short_addr setting support
      ieee820154: add backoff exponent setting support
      at86rf230: remove invalid backoff exponent check
      ieee820154: add max csma backoffs setting support
      at86rf230: remove invalid max csma backoffs check
      ieee820154: add max frame retries setting support
      at86rf230: remove invalid max frame retries check
      ieee820154: add lbt setting support
      mac802154: add interframe spacing time handling
      at86rf230: remove interframe spacing time workaround
      mac802154: remove unused prototypes
      at86rf230: fix commentation for symbol duration
      mac802154: remove const for non pointer in driver-ops
      mac802154: remove const for non pointer in cfg ops
      mac802154: remove const for non pointer in rdev-ops
      mac802154: remove deprecated linux-zigbee info
      mac802154: use new nl802154 iftype types
      mac802154: remove wpan_dev parameter in if_add
      ieee802154: add new interface command
      ieee802154: setting extended address while iface add
      ieee802154: add del interface command
      ieee802154: rename and move WPAN_NUM_ defines
      ieee802154: fix byteorder for short address and panid

Alexander Couzens (1):
      l2tp_eth: allow to set a specific mac address

Alexander Duyck (20):
      net: Add device Rx page allocation function
      cxgb4/cxgb4vf: Replace __skb_alloc_page with __dev_alloc_page
      phonet: Replace calls to __skb_alloc_page with __dev_alloc_page
      fm10k/igb/ixgbe: Replace __skb_alloc_page with dev_alloc_page
      net: Remove __skb_alloc_page and __skb_alloc_pages
      ixgbe: Clean-up page reuse code
      ixgbe: Remove tail write abstraction and add missing barrier
      net: Add functions for handling padding frame and adding to length
      ethernet/intel: Use eth_skb_pad and skb_put_padto helpers
      emulex: Use skb_put_padto instead of skb_padto() and skb->len assignment
      niu: Use eth_skb_pad helper
      myri10ge: use eth_skb_pad helper
      r8169: Use eth_skb_pad function
      fib_trie: Fix /proc/net/fib_trie when CONFIG_IP_MULTIPLE_TABLES is not defined
      net: Split netdev_alloc_frag into __alloc_page_frag and add __napi_alloc_frag
      net: Pull out core bits of __netdev_alloc_skb and add __napi_alloc_skb
      ethernet/intel: Use napi_alloc_skb
      cxgb: Use napi_alloc_skb instead of netdev_alloc_skb_ip_align
      ethernet/realtek: use napi_alloc_skb instead of netdev_alloc_skb_ip_align
      ethernet/broadcom: Use napi_alloc_skb instead of netdev_alloc_skb_ip_align

Alexei Starovoitov (19):
      bpf: reduce verifier memory consumption
      samples: bpf: add a verifier test and summary line
      test: bpf: add a testcase reduced from nmap
      bpf: add 'flags' attribute to BPF_MAP_UPDATE_ELEM command
      bpf: add hashtable type of eBPF maps
      bpf: add array type of eBPF maps
      bpf: fix BPF_MAP_LOOKUP_ELEM command return code
      bpf: add a testsuite for eBPF maps
      bpf: allow eBPF programs to use maps
      bpf: remove test map scaffolding and user proper types
      bpf: fix arraymap NULL deref and missing overflow and zero size checks
      bpf: x86: fix epilogue generation for eBPF programs
      bpf: verifier: add checks for BPF_ABS | BPF_IND instructions
      net: sock: allow eBPF programs to be attached to sockets
      samples: bpf: example of stateful socket filtering
      samples: bpf: elf_bpf file loader
      samples: bpf: trivial eBPF program in C
      samples: bpf: large eBPF program in C
      net: sock: fix access via invalid file descriptor

Alexey Andriyanov (1):
      ip6_tunnel: allow to change mode for the ip6tnl0

Alexey Khoroshilov (1):
      ath6kl: remove incorrect reset_resume handler

Alfonso Acosta (4):
      Bluetooth: Refactor arguments of mgmt_device_connected
      Bluetooth: Include ADV_IND report in Device Connected event
      Bluetooth: Remove redundant check on hci_conn's device class
      Bluetooth: Defer connection-parameter removal when unpairing

Alvaro Neira (2):
      netfilter: nf_tables_bridge: export nft_reject_ip*hdr_validate functions
      netfilter: nf_tables_bridge: set the pktinfo for IPv4/IPv6 traffic

Amir Vadai (2):
      net/mlx4_en: Report actual number of rings in indirection table
      net/mlx4_core: Protect port type setting by mutex

Amitkumar Karwar (11):
      mwifiex: fix out of memory issue observed for USB chipsets
      mwifiex: fix version display problem on big endian platforms
      Bluetooth: btmrvl: add DT bindings documentation
      Bluetooth: btmrvl: add DT-bindings for gpio-gap
      Bluetooth: btmrvl: update hs_state in interrupt handler
      mwifiex: fix sparse warning
      mwifiex: fix scan problem on big endian platforms
      mwifiex: skip delay main work logic for USB interface.
      mwifiex: add Tx status support for EAPOL packets
      mwifiex: add Tx status support for ACTION frames
      Bluetooth: btmrvl: remove extra newline character

Ana Rey (1):
      netfilter: nft_meta: add cgroup support

Anantha Krishnan (1):
      Bluetooth: Add support for Acer [0489:e078]

Andreas Ruprecht (3):
      net: wireless: rtlwifi: Do not always include drivers in obj-m
      net: wireless: rtlwifi: rtl8192ee: Fix compilation of the driver
      net: ethernet: rocker: Add dependency to CONFIG_BRIDGE in Kconfig

Andrei Otcheretianski (4):
      mac80211: export IE splitting function
      mac80211: increase U-APSD max service period length
      iwlwifi: mvm: Insert DS Parameter Set placeholder in probes
      iwlwifi: mvm: Handle failed beacon transmissions during CSA

Andrew Lunn (4):
      dsa: mv88e6171: Add support for mv88e6172
      net: dsa: Centralise code for reading the temperature sensor
      net: dsa: mv88e6171: Add support for reading the temperature
      net: dsa: mv88e6171: Add support for reading switch registers

Andrew Shewmaker (1):
      Update old iproute2 and Xen Remus links

Andrey Skvortsov (1):
      SSB / B44: fix WOL for BCM4401

Andri Yngvason (4):
      can: dev: Consolidate and unify state change handling
      can: sja1000: Consolidate and unify state change handling
      can: mscan: Consolidate and unify state change handling
      can: flexcan: Consolidate and unify state change handling

Andy Shevchenko (9):
      stmmac: fix sparse warnings
      stmmac: pci: use defined constant instead of magic number
      stmmac: pci: convert to use dev_pm_ops
      stmmac: pci: use managed resources
      stmmac: pci: convert to use dev_* macros
      stmmac: remove custom implementation of print_hex_dump()
      stmmac: platform: fix sparse warnings
      stmmac: split to core library and probe drivers
      stmmac: pci: allocate memory resources dynamically

Andy Zhou (2):
      openvswitch: refactor do_output() to move NULL check out of fast path
      openvswitch: Refactor get_dp() function into multiple access APIs.

Anish Bhatt (1):
      cxgb4i/cxgb4 : Refactor macros to conform to uniform standards

Anjali Singhai Jain (5):
      i40e: Fix a bug where Rx would stop after some time
      i40e: Add a virtual channel op to config RSS
      i40e: Define and use i40e_is_vf macro
      i40e: Add new update VSI flow to accommodate FW fix with VSI Loopback mode
      i40e: Re enable Main VSI loopback setting in the reset path

Arend van Spriel (9):
      brcmfmac: show firmware error as string in debug message
      brcmfmac: remove unused defintion
      brcmfmac: do not use firmware error code in driver
      brcmsmac: fix statistic counter update function
      brcmsmac: expose 802.11 core statistics in debugfs
      brcmfmac: fix static checker warning in pmklist handling
      brcmfmac: correct .disconnect() callback while connecting
      brcmutil: add helper function to format board revision
      brcmsmac: extend hardware info shown in debugfs

Arik Nemtsov (28):
      mac80211: fix network header breakage during encryption
      mac80211: expose TDLS-initiator value to low level driver
      mac80211: add stations in order to the station list
      mac80211: expose API allowing station iteration
      iwlwifi: mvm: remove mvm argument from get_queues_mask
      cfg80211: introduce regulatory flags controlling bw
      iwlwifi: mvm: expose some static APIs for use by TDLS code
      mac80211: add supported channels IE during TDLS setup
      mac80211: add BSS coex IE to TDLS setup frames
      cfg/mac80211: define TDLS channel switch feature bit
      mac80211: track AP and peer STA TDLS chan-switch support
      mac80211: prepare TDLS mgmt code for channel-switch templates
      cfg80211: introduce TDLS channel switch commands
      mac80211: add parsing of TDLS specific IEs
      mac80211: introduce TDLS channel switch ops
      mac80211: add TDLS channel-switch Rx flow
      cfg80211: update missing fields in custom regulatory path
      cfg80211: explicitly initialize some fields in custom reg path
      iwlwifi: pcie: support loading FW with extended mem range
      iwlwifi: mvm: declare TDLS support
      iwlwifi: mvm: add TDLS channel switch FW APIs
      iwlwifi: mvm: configure TDLS peers to FW
      iwlwifi: mvm: allow private per-STA TFD queues
      iwlwifi: mvm: disconnect TDLS peers on reconfig
      iwlwifi: mvm: use private TFD queues for TDLS stations
      iwlwifi: mvm: implement mac80211 TDLS channel-switch APIs
      iwlwifi: mvm: disconnect TDLS peers before channel switch
      cfg80211: leave invalid channels on regdomain change

Arturo Borrero (3):
      netfilter: refactor NAT redirect IPv4 to use it from nf_tables
      netfilter: refactor NAT redirect IPv6 code to use it from nf_tables
      netfilter: nf_tables: add new expression nft_redir

Avinash Patil (16):
      mwifiex: channel statistics support for mwifiex
      mwifiex: rx workqueue support for USB interface
      mwifiex: remove data_complete handler
      mwifiex: do not setup AMPDU/AMSDU with broadcast receiver
      mwifiex: fix warning while starting BSS
      mwifiex: module load parameter for interface creation
      mwifiex: update rx packet descriptor structure to match FW
      mwifiex: do not explicitly disable TDLS link during teardown
      mwifiex: wmm support for TDLS link
      mwifiex: add auto TDLS support
      mwifiex: support for parsing TDLS discovery frames
      mwifiex: enable auto TDLS support for SD8887
      mwifiex: do not delete station entries in del_sta handler
      mwifiex: delete peer station's RA list upon deauthentication
      mwifiex: guard station nodes access by station list lock
      mwifiex: do not process broadcast mac address for del_sta

Avri Altman (2):
      iwlwifi: mvm: New skip over dtim policy
      iwlwifi: mvm: Fix the keep_alive calculation

Axel Lin (1):
      NFC: llcp: Use list_for_each_entry in llcp_accept_poll

Bartosz Markowski (2):
      ath10k: advertise all possible firmware(-api) files
      ath10k: fix pm resume after suspend

Ben Greear (20):
      ath10k: add firmware crash counters
      ath10k: support ethtool stats
      ath10k: use 64-bit vdev map
      mac80211_hwsim: fix memory leak on netlink TX failure
      mac80211_hwsim: fix typo, remove unnecessary goto
      mac80211-hwsim: add ethtool stats support
      mac80211-hwsim: support destroying radio by name
      cfg80211: support creating wiphy with suggested name
      mac80211: allow creating wiphy devices with suggested name
      mac80211-hwsim: support creating radios with specific name
      mac80211: support creating wiphy w/out creating wlanX
      mac80211-hwsim: support creating wiphy w/out creating wlanX
      cfg80211: support configuring vif mac addr on create
      mac80211: support creating vifs with specified mac address
      mac80211-hwsim: add frequency attribute to netlink pkts
      mac80211-hwsim: support SGI-20
      ath9k: fix misc debugfs when not using chan context
      ath10k: add ATH10K_DBG_WMI_PRINT debug level
      ath10k: apply chainmask settings to vdev on creation
      ath10k: use configured nss instead of max nss

Carolyn Wyborny (1):
      i40e: Add description to misc and fd interrupts

Catherine Sullivan (3):
      i40e: Bump version
      i40e: Bump version to 1.1.23
      i40e: Bump i40e version to 1.2.2 and i40evf version to 1.0.6

Chan-yeol Park (1):
      Bluetooth: Fix hci_sync missing wakeup interrupt

Chaya Rachel Ivgy (1):
      iwlwifi: mvm: add support to MFUART loading notification

Christophe Ricard (25):
      NFC: st21nfca: Add of_st21nfca_i2c_match to MODULE_DEVICE_TABLE
      NFC: st21nfca: Remove gpio_irq field in static and dts configuration
      NFC: st21nfcb: Add of_st21nfcb_i2c_match to MODULE_DEVICE_TABLE
      NFC: st21nfcb: Remove gpio_irq field in static and dts configuration
      NFC: hci: Add se_io HCI operand
      NFC: nci: Fix sparse: symbol 'nci_get_prop_rf_protocol' was not declared.
      NFC: nci: Update nci_discover_se to run proprietary commands to discover all available secure element
      NFC: nci: Update nci_enable_se to run proprietary commands to enable a secure element
      NFC: nci: Update nci_disable_se to run proprietary commands to disable a secure element
      NFC: nci: Add se_io NCI operand
      NFC: st21nfca: Rework st21nfca_hci_event_received to route event to relevent gate.
      NFC: st21nfcb: Improve ndlc comment
      NFC: hci: Add open pipe command handler
      NFC: hci: Add support for NOTIFY_ALL_PIPE_CLEARED
      NFC: st21nfcb: Remove useless pr_info
      NFC: nci: Add status byte management in case of error.
      NFC: nci: Add management for NCI state for machine rf_deactivate_ntf
      NFC: nci: Add support for different NCI_DEACTIVATE_TYPE
      NFC: netlink: Add new netlink command NFC_CMD_ACTIVATE_TARGET
      NFC: Add se_io NFC operand
      NFC: hci: Add specific hci macro to not create a pipe
      NFC: st21nfca: Report error returned by functions instead of -ENODEV
      NFC: st21nfcb: Fix reported error
      NFC: Fix warning "warning: incorrect type in assignment"
      NFC: nci: Fix warning: cast to restricted __le16

Chun-Hao Lin (2):
      r8169:prevent enable hardware tx/rx too early
      r8169:disable rtl8168ep cmac engine

Chun-Yeow Yeoh (3):
      ath9k: fix the assignment of hw queues for mesh interface
      ath9k|ath9k_htc: Seperate the software crypto flag for Tx and Rx
      ath9k_htc: Enable software crypto for mgmt frame in Tx for USB devices

Chunhe Li (1):
      openvswitch: Drop packets when interdev is not up

Cyrille Pitchen (1):
      net/macb: fix compilation warning for print_hex_dump() called with skb->mac_header

Dan Carpenter (6):
      ipw2x00: remove unused ->ibss_dfs pointer
      ipw2x00: clean up a condition
      Bluetooth: 6lowpan: use after free in disconnect_devices()
      ieee802154: || vs && in ieee802154_is_valid_extended_addr()
      amd-xgbe: fix ->rss_hash_type
      brcmsmac: NULL dereferences in brcms_c_detach_mfree()

Daniel Borkmann (6):
      ipv6: mld: fix add_grhead skb_over_panic for devs with large MTUs
      net: sctp: keep owned chunk in destructor_arg instead of skb->cb
      net: sctp: use MAX_HEADER for headroom reserve in output path
      netlink: use jhash as hashfn for rhashtable
      net: replace remaining users of arch_fast_hash with jhash
      net, lib: kill arch_fast_hash library bits

Dave Taht (1):
      rtnetlink: add babel protocol recognition

David L Stevens (8):
      sunvnet: fix NULL pointer dereference
      sunvnet: rename vnet_port_alloc_tx_bufs and move after version negotiation
      sunvnet: add VIO v1.7 and v1.8 support
      sunvnet: add scatter/gather support
      sunvnet: add checksum offload support
      sunvnet: add GSO support
      sunvnet: add TSO support
      sunvnet: fix incorrect rcu_read_unlock() in vnet_start_xmit()

David S. Miller (100):
      Merge branch 'ipv6_route'
      Merge branch 'berlin_ethernet'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'sunvnet-napi'
      Merge branch 's390-next'
      Merge branch 'unnecessary_resource_check'
      Merge branch 'mellanox-next'
      openvswitch: Export lockdep_ovsl_is_held to modules.
      Merge branch 'r8152-next'
      Merge branch 'xen-netback-next'
      Merge branch 'dsa-next'
      Merge branch 'bpf-next'
      Merge branch 'sunvnet-multi-tx-queue'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'mlx4-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'ecn_via_routing_table'
      Merge branch 'stmmac-next'
      Merge branch 'gue-next'
      net: Add and use skb_copy_datagram_msg() helper.
      Merge branch 'amd-xgbe-next'
      Merge branch 'stmmac-next'
      Merge branch 'sfc-next'
      Merge branch 'r8152-next'
      Merge branch 'sunvnet-next'
      Merge branch 'net_next_ovs' of git://git.kernel.org/.../pshelar/openvswitch
      Merge branch 'amd-xgbe-next'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'iov_iter'
      Merge branch 'cxgb4-next'
      net: Move bonding headers under include/net
      Merge branch 'raw_probe_proto_opt'
      Merge tag 'master-2014-11-04' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'sunvnet-next'
      Merge branch 'so_incoming_cpu'
      Merge branch 'mlx4-next'
      Merge branch 'net_next_ovs' of git://git.kernel.org/.../pshelar/openvswitch
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'skb_alloc_pages'
      Merge branch 'module_phy_driver'
      Merge branch 'micrel-next'
      Merge branch 'bcm7xxx-next'
      Merge branch 'r8152-next'
      Merge branch 'rhash_prove_locking'
      Merge branch 'mlx4-next'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'mv88e6171_temps'
      Merge branch 'rss_key_fill'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'ebpf_maps'
      Merge branch 'fec-next'
      Merge tag 'linux-can-next-for-3.19-20141117' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'stmmac-next'
      Merge branch 'bonding_4ad'
      Merge branch 'for-davem' of git://git.kernel.org/.../viro/vfs
      Merge branch 'phy_device_type'
      Merge branch 'vlan_action'
      Merge branch 'r8152-next'
      Merge branch 'tipc-next'
      Merge branch 'amd-xgbe-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'defxx-next'
      Merge tag 'master-2014-11-20' of git://git.kernel.org/.../linville/wireless-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'cxgb4-next'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'for-davem' of git://git.kernel.org/.../viro/vfs
      Merge branch 'remcsum_adjust'
      Merge branch 'tipc-next'
      Merge branch 'bcmgenet_eee'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'rocker-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'ebpf-next'
      Merge branch 'tstamp-next'
      Merge branch 'tipc-next'
      Merge branch 'r8169-next'
      Merge branch 'mlx5-next'
      Merge branch 'eth_skb_pad'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'rss_hash'
      Merge branch 'sunvnet-next'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'genet-gphy'
      Merge branch 'amd-xgbe'
      Merge branch 'cxgb4-next'
      Merge tag 'master-2014-12-01' of git://git.kernel.org/.../linville/wireless
      Merge tag 'linux-can-fixes-for-3.18-20141207' of git://gitorious.org/linux-can/linux-can
      Merge tag 'linux-can-next-for-3.19-20141207' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge tag 'master-2014-12-08' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'bridge_mode'
      Merge branch 'for-davem-2' of git://git.kernel.org/.../viro/vfs
      Merge branch 'napi_page_frags'
      Merge branch 'isdn-next'
      Merge branch 'kill_arch_fast_hash'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'fec-next'
      Merge branch 'mlx4-next'

David Spinadel (5):
      iwlwifi: mvm: fix scan condition iterator
      iwlwifi: mvm: implement UMAC scan API
      iwlwifi: mvm: go to umac scan even if lmac tlv bit is on
      iwlwifi: mvm: remove warning on unknown scan complete
      iwlwifi: mvm: remove a dangling line of documentation

David Vrabel (2):
      xen-netfront: always keep the Rx ring full of requests
      xen-netfront: use correct linear area after linearizing an skb

Denis Kirjanov (5):
      PPC: bpf_jit_comp: add SKF_AD_PKTTYPE instruction
      PPC: bpf_jit_comp: add SKF_AD_HATYPE instruction
      PPC: bpf_jit_comp: Unify BPF_MOD | BPF_X and BPF_DIV | BPF_X
      mips: bpf: Fix broken BPF_MOD
      test: bpf: expand DIV_KX to DIV_MOD_KX

Dmitry Tunin (1):
      Bluetooth: ath3k: Add support of MCI 13d3:3408 bt device

Don Skidmore (12):
      ixgbe: fix X540 Completion timeout
      ixgbe: cleanup ixgbe_ndo_set_vf_vlan
      ixgbe: cleanup move setting PFQDE.HIDE_VLAN to support function.
      ixgbe: Add new support for X550 MAC's
      ixgbe: add helper function for setting RSS key in preparation of X550
      ixgbe: add support for X550 extended RSS support
      ixgbe: Add timeout parameter to ixgbe_host_interface_command
      ixgbe: Add x550 SW/FW semaphore support
      ixgbe: add methods for combined read and write operations
      ixgbe: cleanup checksum to allow error results
      ixgbe: Add X550 support function pointers
      ixgbe: bump version number

Dotan Barak (1):
      net/mlx4: Add a check if there are too many reserved QPs

Duan Jiong (1):
      ipv6: remove useless spin_lock/spin_unlock

Eli Cohen (8):
      net/mlx5_core: Request the mlx5 IB module on driver load
      net/mlx5_core: Fix min vectors value in mlx5_enable_msix
      net/mlx5_core: Fix command queue size enforcement
      net/mlx5_core: Remove unused dev cap enum fields
      net/mlx5_core: Print resource number on QP/SRQ async events
      net/mlx5_core: Add more supported devices
      mlx5: Fix sparse warnings
      mlx5: Fix error flow in add_keys

Eliad Peller (13):
      iwlwifi: mvm: unref SCAN ref on scan completion
      mac80211: replace restart_complete() with reconfig_complete()
      iwlwifi: mvm/trans: abort d0i3_enter in case of held ref
      iwlwifi: mvm: wake up d0i3_exit_waitq when aborting d0i3
      mac80211: remove redundant check
      mac80211: don't allow 40MHz tx rates in case of 20MHz chandef
      iwlwifi: mvm: move deferred d0i3 exit to resume_complete op
      iwlwifi: mvm: disable beacon filtering escape timer
      iwlwifi: trans: add suspend/resume ops
      iwlwifi: mvm: call iwl_trans_suspend/resume
      iwlwifi: declare d0i3 support for IWL_DEVICE_8000
      iwlwifi: mvm: add missing mvm ref debug print
      iwlwifi: pcie: refactor cmd_in_flight set/clear code

Emil Tantilov (13):
      ixgbevf: Update ixgbevf_alloc_rx_buffers to handle clearing of status bits
      ixgbevf: Test Rx status bits directly out of the descriptor
      ixgbevf: Combine the logic for post Rx processing into single function
      ixgbevf: Cleanup variable usage, improve stack performance
      ixgbevf: reorder main loop in ixgbe_clean_rx_irq to allow for do/while/continue
      ixgbevf: Update Rx next to clean in real time
      ixgbevf: Change receive model to use double buffered page based receives
      ixgbevf: compare total_rx_packets and budget in ixgbevf_clean_rx_irq
      ixgbevf: add netpoll support
      ixgbe: remove CIAA/D register reads from bad VF check
      ixgbe: fix crash on rmmod after probe fail
      ixgbevf: add support for X550 VFs
      ixgbevf: fix possible crashes in probe and remove

Emmanuel Grumbach (26):
      mac80211: don't flush when probing the AP
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      iwlwifi: mvm: remove unneeded NULL pointer check
      iwlwifi: pcie: warn if extern fw_debug buffer failed
      iwlwifi: pcie: fix recovery from ARC reset in WoWLAN
      iwlwifi: mvm: BT Coex - move BT_ANTENNA_COUPLING_THRESHOLD to constants
      iwlwifi: mvm: BT Coex - make the multiprio lut a constant
      iwlwfifi: fix WANT_DEV_COREDUMP selection in Kconfig
      iwlwifi: mvm: rs - don't use the shared antenna when BT load is high
      iwlwifi: pcie: introduce delay when waking up the device
      iwlwifi: pcie: newer platform needs a OS alive indication
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: add support for WMM Access Control
      iwlwifi: mvm: BT Coex - add support for TTC / RRC
      iwlwifi: pcie: properly reset the device
      iwlwifi: update the secure mem space and for the CPUs
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      iwlwifi: deprecate -8.ucode for 3160 / 7260 / 7265
      iwlwifi: mvm: remove IWL_UCODE_TLV_CAPA_EXTENDED_BEACON
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_CSA_FLOW
      iwlwifi: mvm: BT Coex - change the MPLUT registers' value
      iwlwifi: don't load on 7265D with old NVM
      iwlwifi: pcie: claim ownership on the device after stop_device()
      iwlwifi: dvm: fix flush support for old firmware
      iwlwifi: mvm: update values for Smart Fifo

Eran Harary (5):
      iwlwifi: always run the secured flow for family 8000
      ieee80211: add "max length of AMPDU" enum for VHT
      iwlwifi: change max HT and VHT A-MPDU exponent
      iwlwifi: mvm: support ucode load for family_8000 B0 only
      iwlwifi: mvm: Ability to work with packed usniffer image

Eric Dumazet (38):
      tcp: allow for bigger reordering level
      net: introduce napi_schedule_irqoff()
      mlx4: use napi_schedule_irqoff()
      bnx2x: use napi_schedule_irqoff()
      bonding: add bond_tx_drop() helper
      net: shrink struct softnet_data
      net: less interrupt masking in NAPI
      net: add rbnode to struct sk_buff
      net: gro: add a per device gro flush timer
      mlx4: use napi_complete_done()
      mlx4: restore conditional call to napi_complete_done()
      tcp: move sk_mark_napi_id() at the right place
      net: introduce SO_INCOMING_CPU
      tcp: limit GSO packets to half cwnd
      net: provide a per host RSS key generic infrastructure
      amd-xgbe: use netdev_rss_key_fill() helper
      bnx2x: use netdev_rss_key_fill() helper
      tg3: use netdev_rss_key_fill() helper
      bna: use netdev_rss_key_fill() helper
      be2net:use netdev_rss_key_fill() helper
      e100e: use netdev_rss_key_fill() helper
      fm10k: use netdev_rss_key_fill() helper
      i40e: use netdev_rss_key_fill() helper
      igb: use netdev_rss_key_fill() helper
      ixgbe: use netdev_rss_key_fill() helper
      mlx4: use netdev_rss_key_fill() helper
      sfc: use netdev_rss_key_fill() helper
      vmxnet3: use netdev_rss_key_fill() helper
      tcp: make connect() mem charging friendly
      mlx4: fix mlx4_en_set_rxfh()
      enic: use netdev_rss_key_fill() helper
      pkt_sched: fq: increase max delay from 125 ms to one second
      net: mvneta: fix race condition in mvneta_tx()
      net: avoid two atomic operations in fast clones
      tcp_cubic: add SNMP counters to track how effective is Hystart
      tcp_cubic: refine Hystart delay threshold
      tcp: refine TSO autosizing
      tcp: fix more NULL deref after prequeue changes

Erik Hugne (2):
      tipc: drop tx side permission checks
      tipc: fix missing spinlock init and nullptr oops

Erik Kline (1):
      net: ipv6: Add a sysctl to make optimistic addresses useful candidates

Eugenia Emantayev (2):
      net/mlx4_en: Move spinlocks and work initalizations to beginning of init_netdev
      net/mlx4: Change QP allocation scheme

Eyal Perry (2):
      ethtool: Support for configurable RSS hash function
      net/mlx4_en: Support for configurable RSS hash function

Eyal Shapira (8):
      iwlwifi: rs: option to easily disable Tx MIMO
      iwlwifi: enable STBC support for 8000 chips
      iwlwifi: mvm: rs: add Tx STBC support
      iwlwifi: mvm: handle error from iwl_trans_update_sf
      iwlwifi: mvm: rs: fix a WARNING in case of STBC and VHT
      iwlwifi: mvm: rs: fix getting stuck in a test window
      iwlwifi: mvm: rs: consider a missing BA as a single tx failure
      iwlwifi: mvm: declare support for VHT BF info in radiotap

Ezequiel Garcia (1):
      ethernet: mvneta: Use PHY status standard message

Fabian Frederick (39):
      mac80211: directly return ieee80211_vif_use_reserved_context()
      mac80211: remove unnecessary null test before debugfs_remove()
      lapb: move EXPORT_SYMBOL after functions.
      net: llc: include linux/errno.h instead of asm/errno.h
      Bluetooth: fix shadow warning in hci_disconnect()
      xfrm: fix set but not used warning in xfrm_policy_queue_process()
      ipv4: remove set but unused variable sha
      ipv6: replace min/casting by min_t
      ipv6: include linux/uaccess.h instead of asm/uaccess.h
      ipx: move extern sysctl_ipx_pprop_broadcasting to header file
      ipx: remove unnecessary casting on ntohl
      ipx: remove __inline__ in c file on static
      cfg80211: fix set but not used warning in nl80211_channel_switch()
      ipx: remove all unnecessary castings on ntohl
      ipv6: spelling s/incomming/incoming
      ipv6: remove inline on static in c file
      ipv6: remove assignment in if condition
      cipso: kerneldoc warning fix
      ipv4: include linux/bug.h instead of asm/bug.h
      cipso: remove NULL assignment on static
      tcp: spelling s/plugable/pluggable
      ipv4: use seq_puts instead of seq_printf where possible
      ipv4: remove 0/NULL assignment on static
      inet: frags: remove inline on static in c file
      udp: remove else after return
      igmp: remove camel case definitions
      esp4: remove assignment in if condition
      udp: remove blank line between set and test
      Bluetooth: hidp: replace kzalloc/copy_from_user by memdup_user
      openvswitch: use PTR_ERR_OR_ZERO
      net: dsa: replace count*size kmalloc by kmalloc_array
      net: dsa: replace count*size kzalloc by kcalloc
      dccp: kerneldoc warning fixes
      dccp: remove blank lines between function/EXPORT_SYMBOL
      dccp: replace min/casting by min_t
      dccp: spelling s/reseting/resetting
      net: fix spelling for synchronized
      net/core: include linux/types.h instead of asm/types.h
      dev_ioctl: use sizeof(x) instead of sizeof x

Fabio K (1):
      Bluetooth: Add support for Broadcom BCM20702A1 variant

Felix Fietkau (30):
      ath10k: add SURVEY_INFO_IN_USE for current channel on survey
      ath9k_hw: make support for PC-OEM cards optional
      ath9k_hw: remove support for UB124 tx gain table
      ath9k: fix processing RXORN interrupts
      ath9k: clean up debugfs print of reset causes
      ath9k: restart hardware after noise floor calibration failure
      ath9k_hw: do not run NF and periodic calibration at the same time
      ath9k_hw: start initial NF calibration after PA calibration on <AR9003
      ath9k: add support for endian swap of eeprom from platform data
      ath9k: allow disabling bands via platform data
      ath9k: use a random MAC address if the EEPROM address is invalid
      mac80211: add support for driver tx power reporting
      ath9k: add support for reporting tx power to mac80211
      mac80211: skip legacy rate mask handling for VHT rates
      mac80211: minstrel_ht: add a small optimization to minstrel_aggr_check
      mac80211: copy chandef from AP vif to VLANs
      mac80211: add more missing checks for VHT tx rates
      mac80211: minstrel_ht: move aggregation check to .get_rate()
      mac80211: add tx_status_noskb to rate_control_ops
      mac80211: minstrel: switch to .tx_status_noskb
      mac80211: minstrel_ht: switch to .tx_status_noskb
      mac80211: pass tx info to ieee80211_lost_packet instead of an skb
      mac0211: add a helper function for fixing up tx status rates
      mac80211: add ieee80211_tx_status_noskb
      ath9k_hw: fix hardware queue allocation
      ath9k: fix BE/BK queue order
      ath5k: fix hardware queue index assignment
      ath9k: prevent early IRQs from accessing hardware
      ath9k: set ATH_OP_INVALID before disabling hardware
      ath9k: do not access hardware on IRQs during reset

Fengguang Wu (1):
      at86rf230: fix simple_return.cocci warnings

Flavio Leitner (2):
      dummy: add support for ethtool get_drvinfo
      dummy: use MODULE_VERSION

Florent Fourcot (1):
      ipv6: trivial, add bracket for the if block

Florian Fainelli (14):
      net: phy: bcm7xxx: only show PHY revision once
      net: phy: bcm7xxx: drop A0 revision workaround and fix B0 workaround
      net: phy: bcm7xxx: introduce r_rc_cal_reset helper
      net: phy: bcm7xxx: add PHY revision D0 workaround sequence
      net: phy: bcm7xxx: add workaround for PHY revision E0 and F0
      net: systemport: fix tx work done in TX napi poll
      net: systemport: log RX buffer allocation and RX/TX DMA failures
      net: bcmgenet: log RX buffer allocation and RX/TX dma failures
      net: bcmgenet: add register definitions for EEE
      net: bcmgenet: add EEE support
      net: bcmgenet: support restarting auto-negotiation
      net: bcmgenet: add support for new GENET PHY revision scheme
      net: phy: bcm7xxx: add an explicit version check for GPHY rev G0
      net: systemport: allow changing MAC address

Florian Westphal (8):
      syncookies: only increment SYNCOOKIESFAILED on validation error
      syncookies: avoid magic values and document which-bit-is-what-option
      syncookies: split cookie_check_timestamp() into two functions
      net: allow setting ecn via routing table
      netfilter: fix various sparse warnings
      netfilter: xt_connlimit: honor conntrack zone if available
      netfilter: xt_recent: relax ip_pkt_list_tot restrictions
      netfilter: conntrack: avoid zeroing timer

Franky Lin (1):
      brcmfmac: switch to single message MSI

Fugang Duan (1):
      Bluetooth: hci-uart-ath: Correct the comments in this driver

Geert Uytterhoeven (3):
      cirrus/mac89x0: Remove superfluous interrupt disable/restore
      natsemi/macsonic: Remove superfluous interrupt disable/restore
      net/smsc911x: Add minimal runtime PM support

Giuseppe CAVALLARO (7):
      stmmac: remove specific SoC Koption from platform.
      stmmac: remove STMMAC_DEBUG_FS
      stmmac: remove BUS_MODE_DA
      stmmac: update driver documentation
      stmmac: document common header file
      stmmac: review driver when run kernel-doc
      stmmac: fix max coal timer parameter

Govindarajulu Varadarajan (5):
      enic: fix work done in tx napi_poll
      enic: support skb->xmit_more
      enic: use napi_schedule_irqoff()
      enic: use spin_lock(wq_lock) instead of spin_lock_irqsave(wq_lock)
      enic: add support for set/get rss hash key

Gregory Greenman (1):
      iwlwifi: allow to restrict Tx aggregation size per-device

Gu Zheng (2):
      net/socket.c : introduce helper function do_sock_sendmsg to replace reduplicate code
      net: introduce helper macro for_each_cmsghdr

Guenter Roeck (15):
      net: dsa: Don't set skb->protocol on outgoing tagged packets
      net: dsa: Report known silicon revisions for Marvell 88E6060
      net: dsa: Report known silicon revisions for Marvell 88E6131
      net: dsa: Add support for Marvell 88E6352
      net: dsa/mv88e6352: Add support for MV88E6176
      net: dsa: Add support for reporting switch chip temperatures
      net: dsa/mv88e6352: Report chip temperature
      net: dsa/mv88e6123_61_65: Report chip temperature
      net: dsa: Add support for switch EEPROM access
      dsa: Add new optional devicetree property to describe EEPROM size
      net: dsa/mv88e6352: Implement EEPROM access functions
      net: dsa: Add support for reading switch registers with ethtool
      net: dsa/mv88e6123_61_65: Add support for reading switch registers
      net: dsa/mv88e6352: Add support for reading switch registers
      net: dsa: Provide additional RMON statistics

Haiyang Zhang (3):
      hyperv: Add IPv6 into the hash computation for vRSS
      hyperv: Add processing of MTU reduced by the host
      hyperv: Add support for vNIC hot removal

Hannes Frederic Sowa (2):
      fast_hash: avoid indirect function calls
      dst: no need to take reference on DST_NOCACHE dsts

Hante Meuleman (19):
      brcmfmac: Add wowl support for USB devices.
      brcmfmac: Add wowl support for SDIO devices.
      brcmfmac: Add wowl patterns support.
      brcmfmac: (clean) Remove usb_rdl.h as it is not needed.
      brcmfmac: (clean) Remove packet filter configuration.
      brcmfmac: (clean) Move tracepoint related function.
      brcmfmac: (clean) Rename files dhd_dbg to debug
      brcmfmac: (clean) Rename dhd_bus.h in bus.h
      brcmfmac: (clean) Rename dhd_common.c in common.c
      brcmfmac: (clean) Rename files wl_cfg80211 to cfg80211
      brcmfmac: (clean) Rename sdio related files.
      brcmfmac: (clean) Rename sdio related files.
      brcmfmac: (clean) Move sdio related function.
      brcmfmac: Fix bitmap malloc bug in msgbuf.
      brcmfmac: Fix ifidx for rx data by msgbuf.
      brcmfmac: Add PCIE ids for 43602 devices.
      brcmfmac: Fix vendor cmds used interface.
      brcmfmac: Add ifidx to logging of fwil cmds.
      brcmfmac: add multiple BSS support.

Hariprasad Shenai (17):
      cxgb4: Add cxgb4_debugfs.c, move all debugfs code to new file
      cxgb4: Cleanup macros so they follow the same style and look consistent
      cxgb4: Cleanup macros so they follow the same style and look consistent, part 2
      cxgb4: Fix static checker warning
      RDMA/cxgb4: Cleanup Filter related macros/register defines
      RDMA/cxgb4/csiostor: Cleansup FW related macros/register defines for PF/VF and LDST
      cxgb4/cxgb4vf/csiostor: Cleanup macros/register defines related to queues
      cxgb4/cxgb4vf/csiostor: Cleanup macros/register defines related to port and VI
      RDMA/cxgb4/cxgb4vf/csiostor: Cleanup macros/register defines related to PCIE, RSS and FW
      cxgb4/cxgb4vf/csiostor: Add T4/T5 PCI ID Table
      cxgb4: Add a check for flashing FW using ethtool
      cxgb4: Update FW version string to match FW binary version 1.12.25.0
      cxgb4vf: Add and initialize some sge params for VF driver
      cxgb4/cxgb4vf: Add code to calculate T5 BAR2 Offsets for SGE Queue Registers
      cxgb4/cxgb4vf: Use new interfaces to calculate BAR2 SGE Queue Register addresses
      cxgb4: Update firmware version after flashing it via ethtool
      cxgb4/csiostor: Don't use MASTER_MUST for fw_hello call

Hauke Mehrtens (2):
      bcma: make it possible to specify a IRQ num in bcma_core_irq()
      bcma: get IRQ numbers from dt

Heinrich Siebmanns (1):
      Bluetooth: Add support for Broadcom BCM20702A0 variants firmware download

Henning Rogge (3):
      cfg80211: add ops to query mesh proxy path table
      mac80211: implement cfg80211_ops to query mesh proxy path table
      cfg80211: fix nl80211 cmd id in nl80211_send_mpath()

Herbert Xu (13):
      inet: Add skb_copy_datagram_iter
      tun: Use iovec iterators
      macvtap: Use iovec iterators
      net: Kill skb_copy_datagram_const_iovec
      ipv4: Use standard iovec primitive in raw_probe_proto_opt
      ipv4: Avoid reading user iov twice after raw_probe_proto_opt
      xfrm: Do not hash socket policies
      xfrm: Use __xfrm_policy_link in xfrm_policy_insert
      netlink: Move mutex_is_held under PROVE_LOCKING
      netfilter: Move mutex_is_held under PROVE_LOCKING
      rhashtable: Move mutex_is_held under PROVE_LOCKING
      rhashtable: Add parent argument to mutex_is_held
      tun: Fix GSO meta-data handling in tun_get_user

Hisashi Nakamura (2):
      net: sh_eth: Add RMII mode setting in probe
      net: sh_eth: Add r8a7793 support

Holger Brunck (1):
      tipc: allow one link per bearer to neighboring nodes

Ian Morris (2):
      sky2: use new netdev_rss_key_fill() helper
      ipv6: coding style improvements (remove assignment in if statements)

Idan Kahlon (1):
      iwlwifi: mvm: support NVM file with header

Ido Shamay (3):
      net/mlx4_en: Call napi_synchronize on stop_port
      net/mlx4_en: Remove RX buffers alignment to IP_ALIGN
      net/mlx4_en: Add __GFP_COLD gfp flags in alloc_pages

Jack Morgenstein (1):
      net/mlx4_en: Cleanups suggested by clang static checker

Jacob Keller (1):
      i40e: don't enable PTP support on more than one PF per port

Jaganath Kanakkassery (1):
      Bluetooth: Send mgmt_connected only if state is BT_CONFIG

Jakub Pawlowski (4):
      Bluetooth: Add definitions for MGMT_OP_START_SERVICE_DISCOVERY
      Bluetooth: Add extra discovery fields for storing filter information
      Bluetooth: Add logic for UUID filter handling
      Bluetooth: Add support for Start Service Discovery command

James Byrne (1):
      net: macb: Remove obsolete comment from Kconfig

James Cameron (1):
      mwifiex: simplify ad hoc join capability info

Jan Beulich (1):
      netback: don't store invalid vif pointer

Janusz Dziedzic (2):
      ath10k: don't create bssid peer for ibss
      ath10k: fix WMI scan command length

Jarno Rajahalme (2):
      openvswitch: Fix the type of struct ovs_key_nd nd_target field.
      openvswitch: Add support for OVS_FLOW_ATTR_PROBE.

Jason Wang (5):
      tun: fix issues of iovec iterators using in tun_put_user()
      tun: return NET_XMIT_DROP for dropped packets
      macvtap: advance iov iterator when needed in macvtap_put_user()
      macvlan: delay the header check for dodgy packets into lower device
      tun/macvtap: use consume_skb() instead of kfree_skb() when needed

Jay Vosburgh (1):
      Revert "fast_hash: avoid indirect function calls"

Jeff Kirsher (2):
      i40e/i40evf: Fix whitespace indentation
      i40e/i40evf: Convert macro to static inline

Jeremiah Mahler (3):
      can: eliminate banner[] variable and switch to pr_info()
      can: slcan/vcan: eliminate banner[] variable, switch to pr_info()
      can: fix spelling errors

Jesse Brandeburg (5):
      i40e: mask phy events
      i40e: enable LSE poke and simplify link state
      i40e: avoid disable of interrupt when changing ITR
      i40e: clean up throttle rate code
      i40e: enable fdb add code, remove unused code

Jesse Gross (1):
      openvswitch: Additional logging for -EINVAL on flow setups.

Jianhua Xie (2):
      bonding: change AD_LINK_SPEED_BITMASK to enum to suport more speed
      bonding: Introduce 4 AD link speed to fix agg_bandwidth

Jiri Benc (1):
      openvswitch: set correct protocol on route lookup

Jiri Pirko (32):
      sched: fix act file names in header comment
      openvswitch: actions: use skb_postpull_rcsum when possible
      vlan: make __vlan_hwaccel_put_tag return void
      vlan: kill vlan_put_tag helper
      vlan: rename __vlan_put_tag to vlan_insert_tag_set_proto
      vlan: introduce *vlan_hwaccel_push_inside helpers
      vlan: introduce __vlan_insert_tag helper which does not free skb
      net: move make_writable helper into common code
      net: move vlan pop/push functions into common code
      sched: introduce vlan action
      tc_vlan: fix type of tcfv_push_vid
      bridge: rename fdb_*_hw to fdb_*_hw_addr to avoid confusion
      neigh: sort Neighbor Cache Entry Flags
      bridge: convert flags in fbd entry into bitfields
      net: make vid as a parameter for ndo_fdb_add/ndo_fdb_del
      net: rename netdev_phys_port_id to more generic name
      net: introduce generic switch devices support
      rtnl: expose physical switch id for particular device
      net-sysfs: expose physical switch id for particular device
      rocker: introduce rocker switch driver
      rocker: implement ndo_fdb_dump
      net_sched: cls_basic: remove unnecessary iteration and use passed arg
      net_sched: cls_bpf: remove unnecessary iteration and use passed arg
      net_sched: cls_bpf: remove faulty use of list_for_each_entry_rcu
      net_sched: cls_flow: remove faulty use of list_for_each_entry_rcu
      net_sched: cls_flow: remove duplicate assignments
      net_sched: cls_cgroup: remove unnecessary if
      rocker: introduce be put/get variants and use it when appropriate
      rocker: fix eth_type type in struct rocker_ctrl
      net: sched: cls: remove unused op put from tcf_proto_ops
      net: sched: cls_basic: fix error path in basic_change()
      net: sched: cls: use nla_nest_cancel instead of nlmsg_trim

Jisheng Zhang (1):
      net: pxa168_eth: move SET_NETDEV_DEV a bit earlier

Joe Perches (24):
      ath: change logging functions to return void
      iwlwifi: dvm: Fix probable mask then right shift defect
      carl9170: Convert byte_rev_table uses to bitrev8
      net: Convert SEQ_START_TOKEN/seq_printf to seq_puts
      net; ipv[46] - Remove 2 unnecessary NETDEBUG OOM messages
      net: esp: Convert NETDEBUG to pr_info
      sock.h: Remove unused NETDEBUG macro
      dccp: Convert DCCP_WARN to net_warn_ratelimited
      cxgb4: Remove unnecessary struct in6_addr * casts
      dsa: Use netdev_<level> instead of printk
      net: Convert LIMIT_NETDEBUG to net_dbg_ratelimited
      irda: Simplify IRDA logging macros
      irda: Remove IRDA_<TYPE> logging macros
      irda: Convert IRDA_DEBUG to pr_debug
      udp: Neaten function pointer calls and add braces
      irda: Fix build failures after IRDA_DEBUG->pr_debug
      i40e: Reduce stack in i40e_dbg_dump_desc
      udp: Neaten and reduce size of compute_score functions
      x86: bpf_jit_comp: Reduce is_ereg() code size
      x86: bpf_jit_comp: Remove inline from static function definitions
      llc: Make function pointer arrays const
      llc: Make llc_conn_ev_qfyr_t function pointer arrays const
      llc: Make llc_sap_action_t function pointer arrays const
      irda: Convert function pointer arrays and uses to const

Joe Stringer (4):
      openvswitch: Remove redundant tcp_flags code.
      openvswitch: Refactor ovs_flow_cmd_fill_info().
      openvswitch: Move key_attr_size() to flow_netlink.h.
      bnx2x: Implement ndo_gso_check()

Johan Hedberg (92):
      Bluetooth: Pass only crypto context to SMP crypto functions
      Bluetooth: Add skeleton for SMP self-tests
      Bluetooth: Add self-tests for SMP crypto functions
      Bluetooth: Revert SMP self-test patches
      Bluetooth: Fix LE connection timeout deadlock
      Bluetooth: Fix check for direct advertising
      Bluetooth: Fix sparse warnings in RFCOMM
      Bluetooth: Fix sparse warning in amp.c
      Bluetooth: Fix mgmt connected notification
      Bluetooth: 6lowpan: Remove unnecessary RCU callback
      Bluetooth: Fix l2cap_sock_teardown_cb lockdep warning
      Bluetooth: Remove unnecessary hci_dev_lock/unlock in smp.c
      Bluetooth: Use proper nesting annotation for l2cap_chan lock
      Bluetooth: Fix L2CAP socket lock nesting level
      Bluetooth: Fix L2CAP nesting level initialization location
      Bluetooth: Fix correct nesting for 6lowpan server channel
      Bluetooth: Fix sending incorrect LE CoC PDU in BT_CONNECT2 state
      Bluetooth: Add key preference parameter to smp_sufficient_security
      Bluetooth: Trigger SMP for the appropriate LE CoC errors
      Bluetooth: Convert LTK list to RCU
      Bluetooth: Convert IRK list to RCU
      Bluetooth: Remove unnecessary hdev locking in smp.c
      Bluetooth: Add debug logs to help track locking issues
      Bluetooth: Fix clearing remote OOB data through mgmt
      Bluetooth: Fix BR/EDR-only address checks for remote OOB data
      Bluetooth: Use shorter "rand" name for "randomizer"
      Bluetooth: Call drain_workqueue() before resetting state
      Bluetooth: Fix setting state back to TASK_RUNNING
      Bluetooth: Fix setting conn->pending_sec_level value from link key
      Bluetooth: Convert link keys list to use RCU
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
      Bluetooth: Convert Disconnect mgmt command to use cmd_complete callback
      Bluetooth: Use cmd_complete callback for authentication mgmt commands
      Bluetooth: Convert Pair Device to use cmd_complete callback
      Bluetooth: Convert Unpair Device to use cmd_complete callback
      Bluetooth: Convert discovery commands to use cmd_complete callback
      Bluetooth: Convert Get Clock Info to use cmd_complete callback
      Bluetooth: Fix initializing hci_conn RSSI to invalid value
      Bluetooth: Fix Get Conn Info to use cmd_complete callback
      Bluetooth: Remove redundant reverse_base_uuid variable

Johan Hovold (22):
      net: phy: add module_phy_driver macro
      net: phy: replace phy_driver_register calls
      net: phy: replace phy_drivers_register calls
      dt/bindings: fix documentation of ethernet-phy compatible property
      net: phy: micrel: fix config_intr error handling
      net: phy: micrel: use BIT macro
      net: phy: micrel: refactor broadcast disable
      net: phy: micrel: disable broadcast for KSZ8081/KSZ8091
      net: phy: micrel: add led-mode sanity check
      net: phy: micrel: refactor led-mode error handling
      net: phy: micrel: clean up led-mode setup
      net: phy: micrel: enable led-mode for KSZ8081/KSZ8091
      net: phy: add static data field to struct phy_driver
      net: phy: micrel: add device-type abstraction
      net: phy: micrel: parse of nodes at probe
      net: phy: micrel: add has-broadcast-disable flag to type data
      net: phy: micrel: add generic clock-mode-select support
      net: phy: micrel: add support for clock-mode select to KSZ8081/KSZ8091
      dt/bindings: reformat micrel eth-phy documentation
      dt/bindings: add clock-select function property to micrel phy binding
      net: phy: micrel: refactor interrupt config
      net: phy: micrel: add copyright entry

Johannes Berg (49):
      mac80211: fix change flags variable signedness
      Merge branch 'mac80211' into mac80211-next
      cfg80211: make WMM TSPEC support flag an nl80211 feature flag
      mac80211: sanity check CW_min/CW_max towards driver
      mac80211: add WMM admission control support
      mac80211: don't remove tainted keys after not programming
      iwlwifi: mvm: improve MCS rate warning
      iwlwifi: mvm: flush queues without mutex held
      iwlwifi: mvm: port to devcoredump framework
      cfg80211: fix integer signedness in chandef_primary_freqs()
      mac80211-hwsim: remove spurious newline
      mac80211-hwsim: add missing policy entries
      cfg80211: avoid using default in interface type switch
      mac80211: handle RIC data element in reassociation request
      mac80211: add back support for radiotap vendor namespace data
      iwlwifi: mvm: use correct type for firmware status
      iwlwifi: mvm: rs: don't use shadowing variable
      iwlwifi: mvm: don't capture firmware coredump for D3->D0 reconfig
      mac80211: refactor duplicate detection
      Merge remote-tracking branch 'wireless-next/master' into mac80211-next
      mac80211: move skb info band assignment out
      mac80211: factor out 802.11 header building code
      mac80211: add function to create data frame template including key
      cfg80211: allow drivers to support random MAC addresses for scan
      mac80211: rcu-ify scan and scheduled scan request pointers
      mac80211: allow drivers to support NL80211_SCAN_FLAG_RANDOM_ADDR
      mac80211_hwsim: support scanning with random MAC address
      mac80211-hwsim: remove unnecessary hwname check
      mac80211: notify drivers on sta rate table changes
      iwlwifi: mvm: support random MAC address for scanning
      iwlwifi: pcie: support 7265-D devices
      iwlwifi: mvm: use unsigned for ssid_bitmap
      iwlwifi: mvm: refactor key add/remove functions
      iwlwifi: mvm: add WEP RX hardware offload support
      iwlwifi: build mac80211 rx_status in place
      iwlwifi: mvm: pull crypto header into skb->head
      iwlwifi: mvm: pull SNAP header into skb->head
      ath10k: don't rebuild all the time
      Revert "mac80211_hwsim: VHT add 160MHz width support"
      mac80211: disable 80+80/160 in VHT correctly
      cfg80211: remove pointless channel lookup in survey code
      mac80211: check if channels allow 80 MHz for VHT probe requests
      cfg80211: refactor the various CQM event sending code
      cfg80211: clean up beacon loss CQM event
      nl80211: don't crash sending invalid chandef
      cfg80211: make WEXT compatibility unselectable
      NFC: Don't include linux/unaligned/access_ok.h
      cfg80211: remove unneeded initialisations in nl80211_set_reg
      iwlwifi: move firmware file format definitions to correct header

John W. Linville (19):
      Merge tag 'for-linville-20141024' of git://github.com/kvalo/ath
      Merge tag 'iwlwifi-next-for-john-2014-10-29' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge tag 'mac80211-next-for-john-2014-11-04' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      ath9k_htc: remove return of value in empty definintion of ath9k_htc_deinit_debug
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge commit '4e6ce4dc7ce71d0886908d55129d5d6482a27ff9' of git://git.kernel.org/.../linville/wireless
      Merge tag 'mac80211-next-for-john-2014-11-20' of git://git.kernel.org/.../jberg/mac80211-next
      Merge tag 'iwlwifi-next-for-john-2014-11-24' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge tag 'iwlwifi-next-for-john-2014-12-02' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'nfc-next-3.19-1' of git://git.kernel.org/.../sameo/nfc-next
      Merge git://git.kernel.org/.../jberg/mac80211-next
      MAINTAINERS: orphan rtl8180
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless

Jouni Malinen (2):
      cfg80211: Convert del_station() callback to use a param struct
      cfg80211: Specify frame and reason code for NL80211_CMD_DEL_STATION

Jozsef Kadlecsik (6):
      netfilter: ipset: Support updating extensions when the set is full
      netfilter: ipset: Alignment problem between 64bit kernel 32bit userspace
      netfilter: ipset: Indicate when /0 networks are supported
      netfilter: ipset: Simplify cidr handling for hash:*net* types
      netfilter: ipset: Allocate the proper size of memory when /0 networks are supported
      netfilter: ipset: Explicitly add padding elements to hash:net, net and hash:net, port, net

Jukka Rissanen (9):
      mac80211-hwsim: Add support for HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE
      Bluetooth: 6lowpan: Converting rwlocks to use RCU
      Bluetooth: 6lowpan: Fix lockdep splats
      Bluetooth: Wrong style spin lock used
      mac80211-hwsim: Rename CREATE and DESTROY radio to NEW and DEL radio
      mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO
      mac80211-hwsim: Provide multicast event for HWSIM_CMD_DEL_RADIO
      mac80211-hwsim: hwname is always known so use the value from wiphy
      nl80211: Replace interface socket owner attribute with more generic one

Julia Lawall (5):
      dmfe: fix misspelling of current function in string
      isdn: fix misspelling of current function in string
      uli526x: fix misspelling of current function in string
      hp100: fix misspelling of current function in string
      chelsio: fix misspelling of current function in string

Julien Catalano (1):
      trivial: net/mac802154: Fix Kconfig typo

Julien Lefrique (10):
      NFC: NCI: Add passive Listen modes in discover request
      NFC: NCI: Enable NFC-DEP in Listen A and Listen F
      NFC: NCI: Handle Target mode activation
      NFC: NCI: Configure ATR_RES general bytes
      NFC: NCI: Implement Target mode send function
      NFC: NCI: Forward data received in Target mode to nfc core
      NFC: Fix a memory leak
      NFC: NCI: Handle Discovery deactivation type
      NFC: NCI: Signal deactivation in Target mode
      NFC: NCI: Fix max length of General Bytes in ATR_RES

Kalle Valo (6):
      ath10k: don't enable interrupts for the diagnostic window
      ath10k: add diag_read() to hif ops
      ath10k: add cal_data debugfs file
      ath10k: add back enum ath10k_bus
      ath10k: refactor ath10k_init_download_firmware()
      ath10k: retrieve calibration data from file

Kamil Krawczyk (1):
      i40e: poll firmware slower

Karl Beldan (8):
      mac80211: minstrel_ht: fix MCS_GROUP_RATES usage
      cfg80211: set the rates mask in connection probes over specified freq
      mac80211: minstrel_ht: Increase the range of handled rate indexes
      mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
      mac80211: minstrel_ht: include type (cck/ht) in rates flag
      mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
      mac80211: minstrel_ht: use group flags instead of index to display rates
      mac80211: minstrel_ht: do not always skip ht rates vht_only is true

Kenjiro Nakayama (1):
      net: Remove trailing whitespace in tcp.h icmp.c syncookies.c

Kevin Hao (1):
      gianfar: Fix dma check map error when DMA_API_DEBUG is enabled

Kevin Scott (1):
      i40e: Increase reset delay

Kristian Evensen (1):
      mwifiex: Add USB8766 support

Kuba Pawlak (2):
      Bluetooth: Clear role switch pending flag
      Bluetooth: Sort switch cases by opcode's numeric value

Kyeyoon Park (1):
      bridge: Add support for IEEE 802.11 Proxy ARP

Larry Finger (4):
      rtlwifi: rtl8821ae: Remove extra semicolons
      rtlwifi: rtl8192ce: Fix editing error that causes silent memory corruption
      rtlwifi: rtl8192ce: Fix kernel crashes due to missing callback entry
      rtlwifi: rtl8192ce: Fix missing interrupt ready flag

Lendacky, Thomas (28):
      amd-xgbe: Move ring allocation to device open
      amd-xgbe: Rename pre_xmit function to dev_xmit
      amd-xgbe: Use the u32 data type for descriptors
      amd-xgbe: Use page allocations for Rx buffers
      amd-xgbe: Implement split header receive support
      amd-xgbe: Add support for per DMA channel interrupts
      amd-xgbe: Provide support for receive side scaling
      amd-xgbe: Add receive side scaling ethtool support
      amd-xgbe: Fix a spelling error
      amd-xgbe-phy: Sync PCS and PHY modes after reset
      amd-xgbe: Let AMD_XGBE depend on HAS_IOMEM
      amd-xgbe-phy: Let AMD_XGBE_PHY depend on HAS_IOMEM
      amd-xgbe: Free channel/ring structures later
      amd-xgbe: Check for complete packet on skb allocation error
      amd-xgbe: Fix sparse endian warnings
      amd-xgbe: Add a read memory barrier to Tx/Rx path
      amd-xgbe: Tx engine must not be active before stopping it
      amd-xgbe: Incorporate Smatch coding suggestion
      amd-xgbe: Separate Tx/Rx ring data fields into new structs
      amd-xgbe: Add BQL support
      amd-xgbe: Remove unused variable
      amd-xgbe: Perform Tx coalescing on a packet basis
      amd-xgbe: Add support for the skb->xmit_more flag
      amd-xgbe: IRQ names require allocated memory
      amd-xgbe: Do not clear interrupt indicator
      amd-xgbe: Associate Tx SKB with proper ring descriptor
      amd-xgbe: Prevent Tx cleanup stall
      amd-xgbe: Use disable_irq_nosync when in IRQ context

Lennart Sorensen (2):
      drivers: net: cpsw: Fix broken loop condition in switch mode
      drivers: net: cpsw: Support ALLMULTI and fix IFF_PROMISC in switch mode

Li RongQing (2):
      Bluetooth: 6lowpan: remove unnecessary codes in give_skb_to_upper
      net: avoid to call skb_queue_len again

Liad Kaufman (12):
      iwlwifi: mvm: fix init_dbg flow to work as expected
      mac80211: add option for setting skb flags before xmit
      mac80211: retransmit TDLS teardown packet through AP if not ACKed
      mac80211: add specific-queue flushing support
      mac80211: synchronously reserve TID per station
      iwlwifi: mvm: block TID when using TDLS
      iwlwifi: pcie: add fh registers to dump data
      iwlwifi: use correct fw file in 8000 b-step
      iwlwifi: define the .ucode file format for debug
      iwlwifi: mvm: send dbg config hcmds to fw if set in tlv
      iwlwifi: pcie: config regs according to fw tlv
      iwlwifi: pcie: support more monitor types dumping

Lino Sanfilippo (4):
      wil6210: Fix potential memory leaks on error paths
      pxa168: close race between napi and irq activation
      skge: Unmask interrupts in case of spurious interrupts
      sky2: avoid pci write posting after disabling irqs

Loic Poulain (1):
      Bluetooth: HCI H5 peer reset detection

Lokesh Vutla (1):
      drivers: net : cpsw: Update Kconfig for CPSW

Lorand Jakab (1):
      openvswitch: Remove flow member from struct ovs_skb_cb

Lorenzo Bianconi (5):
      ath9k: do not overwrite AR_PHY_RADAR_1 MSB
      ath9k: set pulse_rssi threshold to 15
      rtlwifi: update RCR register in rtl_op_configure_filter()
      ath9k: add TX power per-rate tables
      ath9k: add TPC capability to TX descriptor path

Lothar Wa√ümann (8):
      net: fec: indentation cleanup
      net: fec: consistently use lower case chars as hex digits
      net: fec: properly parenthesize macro args
      net: fec: change type of 'bufdesc_ex' to bool
      net: fec: improve access to quirk flags by copying them into fec_enet_private struct
      net: fec: use swab32s() instead of cpu_to_be32()
      net: fec: simplify loop counter handling in swap_buffer()
      net: fec: remove unused return value from swap_buffer()

Luciano Coelho (46):
      mac80211: add device_timestamp to the ieee80211_channel_switch struct
      mac80211: add extended channel switching capability if the driver supports CSA
      mac80211: add pre_channel_switch driver operation
      mac80211: add post_channel_switch driver operation
      mac80211: wait for the first beacon on the new channel after CSA
      mac80211: allow channel switch with multiple channel contexts
      iwlwifi: mvm: hold the rtnl when resuming from a d3 test
      iwlwifi: mvm: split wowlan handling out of the main suspend function
      iwlwifi: mvm: move the check if associated outside of the iterator for wowlan
      iwlwifi: mvm: spin off a function to start scan offload
      iwlwifi: mvm: add debugfs entry to configure netdetect SSIDs
      iwlwifi: mvm: change the iwl_mvm_d3_iface_iterator into a generic function
      iwlwifi: mvm: remove unnecessary includes in tt.c
      mac80211: fix order of setting ch_switch and drv_pre_channel_switch call
      mac80211: add device_timestamp to the drv_pre_channel_switch trace
      cfg80211: add channel switch started notification
      mac80211: send channel switch started notifications
      cfg80211/mac80211: allow any interface to send channel switch notifications
      iwlwifi: mvm: refactor temperature notification handling
      iwlwifi: mvm: handle unsolicited DTS_MEASUREMENT_NOTIFICATIONs
      wlcore: check minimum buffer size in some cmd_send functions
      wlcore: make wlcore_cmd_send_failsafe() static
      cfg80211: refactor nl80211_start_sched_scan so it can be reused
      cfg80211: add wowlan net-detect support
      iwlwifi: mvm: make nd_ies part of the mvm struct
      iwlwifi: mvm: use new pre_channel_switch op instead of channel_switch_beacon
      iwlwifi: mvm: only save csa_vif in AP/GO mode
      iwlwifi: mvm: refactor iwl_mvm_switch_vif_chanctx to support other modes
      iwlwifi: mvm: add support for CHANCTX_SWMODE_REASSIGN_VIF
      iwlwifi: mvm: return the actual error code when switch_vif_chanctx fails
      iwlwifi: mvm: disable PS during channel switch
      iwlwifi: mvm: use switching_chanctx argument instead of csa_active
      iwlwifi: mvm: add CSA absent time event for clients
      iwlwifi: mvm: schedule CSA time event a bit before beacon 1
      iwlwifi: mvm: finalize on post_switch instead of unassign
      iwlwifi: mvm: add a channel_switch op to bypass mac80211 timer
      iwlwifi: mvm: disable beacon filtering during CSA
      iwlwifi: mvm: clear TE data if CSA time event fails to start
      iwlwifi: mvm: protect session during CSA
      iwlwifi: mvm: add support for net detect
      iwlwifi: mvm: refactor wowlan and netdetect configuration when suspending
      iwlwifi: mvm: refactor iwl_mvm_query_wakeup_reasons()
      iwlwifi: mvm: treat netdetect wake up separately
      iwlwifi: mvm: check and report if wake up was due to net detect
      iwlwifi: mvm: add SSID match information for net-detect
      iwlwifi: mvm: add channel information to the netdetect notifications

Maciej W. Rozycki (4):
      defxx: Fix DEFPA enable error propagation
      defxx: Correct DEFEA's ESIC MMIO decoding
      defxx: Disable DEFEA's ESIC I/O decoding on shutdown
      defxx: Clean up DEFEA resource management

Mahesh Bandewar (8):
      ipvlan: Initial check-in of the IPVLAN driver.
      ipvlan: fix sparse warnings
      ipvlan: ipvlan depends on INET and IPV6
      rtnetlink: delay RTM_DELLINK notification until after ndo_uninit()
      netdevice: Add a function to check macvlan port
      ipvlan: play well with macvlan device
      ipvlan: move the device check function into netdevice.h
      macvlan: play well with ipvlan device

Majd Dibbiny (1):
      net/mlx5_core: Clear outbox of dealloc uar

Malcolm Crossley (1):
      xen-netback: remove unconditional __pskb_pull_tail() in guest Tx path

Marc Kleine-Budde (1):
      can: Enable -D__CHECK_ENDIAN__ for sparse by default

Marcel Holtmann (31):
      Bluetooth: Clear LE white list when resetting controller
      Bluetooth: Check status of command complete for HCI_Reset
      Bluetooth: Print error message for HCI_Hardware_Error event
      Bluetooth: Use HCI_EV_HARDWARE_ERROR define for event payload
      Bluetooth: Introduce BT_BREDR and BT_LE config options
      Bluetooth: Add hci_reset_dev() for driver triggerd stack reset
      Bluetooth: Switch HCI H5 driver to use hci_reset_dev() function
      Bluetooth: Introduce HCI_QUIRK_STRICT_DUPLICATE_FILTER
      Bluetooth: Set HCI_QUIRK_STRICT_DUPLICATE_FILTER for Broadcom devices
      Bluetooth: Consolidate whitelist debugfs entry into device_list
      Bluetooth: btusb: Add internal callback for USB bulk rx data
      Bluetooth: Add hci_conn_lookup_type() helper function
      Bluetooth: Increase minor version of core module
      Bluetooth: Increment management interface revision
      Bluetooth: Simplify the error handling of Start Discovery command
      Bluetooth: Use {start,stop}_discovery_complete handler for cmd_complete
      Bluetooth: Split triggering of discovery commands into separate function
      Bluetooth: Add HCI_RSSI_INVALID for unknown RSSI value
      Bluetooth: Filter device found events based on RSSI threshold
      Bluetooth: Add framework for device found filtering based on UUID
      Bluetooth: Add helper function for clearing the discovery filter
      Bluetooth: Fix memory leaks from discovery filter UUID list
      Bluetooth: Clear discovery filter before starting background scan
      Bluetooth: Fix discovery filter when no RSSI is available
      Bluetooth: Report invalid RSSI for service discovery and background scan
      Bluetooth: Move LE advertising report defines to the right location
      Bluetooth: Add definitions for LE Direct Advertising Report event
      Bluetooth: Enabled LE Direct Advertising Report event if supported
      Bluetooth: Add support for handling LE Direct Advertising Report events
      Bluetooth: Add support for enabling Extended Scanner Filter Policies
      Bluetooth: Enable events for P-256 Public Key and DHKey commands

Marcelo Leitner (4):
      netfilter: nf_log: Introduce nft_log_dereference() macro
      netfilter: log: protect nf_log_register against double registering
      netfilter: nfnetlink_log: Make use of pr_fmt where applicable
      Fix race condition between vxlan_sock_add and vxlan_sock_release

Mark A. Greer (13):
      NFC: digital: Fix potential skb leaks in NFC-DEP code
      NFC: digital: Rearrange NFC-DEP DEP_REQ/DEP_RES Code
      NFC: digital: Ensure no DID in NFC-DEP responses
      NFC: digital: Add Target-mode NFC-DEP DID Support
      NFC: digital: Ensure no NAD byte in DEP_REQ and DEP_RES frames
      NFC: digital: Enforce NFC-DEP PNI sequencing
      NFC: digital: Implement NFC-DEP max payload lengths
      NFC: digital: Add NFC-DEP Send Chaining Support
      NFC: digital: Add NFC-DEP Receive Chaining Support
      NFC: digital: Add NFC-DEP Initiator-side NACK Support
      NFC: digital: Add NFC-DEP Target-side NACK Support
      NFC: digital: Add NFC-DEP Initiator-side ATN Support
      NFC: digital: Add NFC-DEP Target-side ATN Support

Markus Elfring (12):
      net: pktgen: Deletion of an unnecessary check before the function call "proc_remove"
      netlink: Deletion of an unnecessary check before the function call "__module_get"
      netfilter: Deletion of unnecessary checks before two function calls
      net: brcm80211: Deletion of unnecessary checks before two function calls
      mISDN: Deletion of unnecessary checks before the function call "vfree"
      IBM-EMAC: Deletion of unnecessary checks before the function call "of_dev_put"
      net: Xilinx: Deletion of unnecessary checks before two function calls
      net: USB: Deletion of unnecessary checks before the function call "kfree"
      net: Hyper-V: Deletion of an unnecessary check before the function call "vfree"
      net: cassini: Deletion of an unnecessary check before the function call "vfree"
      net-ipvlan: Deletion of an unnecessary check before the function call "free_percpu"
      net-PA Semi: Deletion of unnecessary checks before the function call "pci_dev_put"

Martin K Petersen (1):
      ixgbe: Look up MAC address in Open Firmware or IDPROM

Martin KaFai Lau (3):
      ipv6: Remove BACKTRACK macro
      ipv6: Avoid redoing fib6_lookup() for RTF_CACHE hit case
      ipv6: Avoid redoing fib6_lookup() with reachable = 0 by saving fn

Martin Townsend (7):
      6lowpan: Use skb_cow in IPHC decompression.
      Bluetooth: Fix missing channel unlock in l2cap_le_credits
      6lowpan: remove skb_deliver from IPHC
      6lowpan: fix process_data return values
      bluetooth:6lowpan: use consume_skb when packet processed successfully
      ieee802154: 6lowpan: rename process_data and lowpan_process_data
      6lowpan: move skb_free from error paths in decompression

Masahiro Yamada (1):
      uapi: fix to export linux/vm_sockets.h

Matan Barak (14):
      net/mlx4_core: Add retrieval of CONFIG_DEV parameters
      net/mlx4_core: Fix wrong reading of reserved_eqs
      net/mlx4_core: Use correct variable type for mlx4_slave_cap
      net/mlx4_core: Refactor mlx4_cmd_init and mlx4_cmd_cleanup
      net/mlx4_core: Refactor mlx4_load_one
      net/mlx4_core: Add QUERY_FUNC firmware command
      net/mlx4_core: Flexible (asymmetric) allocation of EQs and MSI-X vectors for PF/VFs
      net/mlx4_core: Support more than 64 VFs
      net/mlx4_core: Use tasklet for user-space CQ completion events
      net/mlx4: Add mlx4_bitmap zone allocator
      net/mlx4: Add A0 hybrid steering
      net/mlx4_core: Add explicit error message when rule doesn't meet configuration
      net/mlx4: Refactor QUERY_PORT
      net/mlx4: Add support for A0 steering

Matei Pavaluca (1):
      gianfar: Implement PAUSE frame generation support

Matti Gottlieb (1):
      iwlwifi: mvm: add remove flow for AUX ROC time events

Max Stepanov (1):
      iwlwifi: mvm: add MVM_FW_BCAST_FILTER_PASS_ALL option

Miaoqing Pan (1):
      ath9k: Use new QCA953x initvals

Michal Kazior (70):
      ath10k: workaround fw beaconing bug
      ath10k: fix tx/rx chainmask init
      ath10k: remove unused pdev_set_channel command
      ath10k: deduplicate wmi_channel code
      ath10k: deduplicate host mem chunk code
      ath10k: relocate wmi attach/deatch functions
      ath10k: deduplicate wmi service ready logic
      ath10k: clean up phyerr code
      ath10k: unify wmi event function names
      ath10k: re-work scan start command building
      ath10k: print wmi version info
      ath10k: dump hex bytes with dev string prefix
      ath10k: add debug dump for pci rx
      ath10k: split wmi stats parsing
      ath10k: rename fw_stats related stuff
      ath10k: request fw_stats once on open
      ath10k: fix fw stats processing
      ath10k: warn on unhandled htt events
      mac80211: enable DFS with channel contexts
      ath10k: clean up assoc code
      ath10k: skip some commands on reassoc
      ath10k: clean up sta auth/assoc code
      ath10k: simplify computation of mgmt rx band
      ath10k: use bss_info as txpower source
      ath10k: re-disable interrupts after target init
      ath10k: mask/unmask msi fw irq
      ath10k: split ce pipe init/alloc further
      ath10k: don't drop control and null func Rx
      ath10k: remove unused variable
      ath10k: use ieee80211 defines for crypto param lengths
      ath10k: fix rx buffer tracing
      ath10k: deduplicate htt rx dma unmapping
      ath10k: don't drop frames aggressively
      ath10k: add extra sanity check when popping amsdu
      ath10k: don't forget to replenish after fragmented Rx
      ath10k: clear htt->rx_confused on load
      ath10k: remove tsf argument from rx_desc tracing
      ath10k: re-use trace class
      ath10k: call correct function for frag threshold
      ath10k: avoid possible deadlock with scan timeout
      ath10k: change ce ring cleanup logic
      ath10k: make warm reset a bit safer and faster
      ath10k: split reset logic from power up
      ath10k: don't reset chip on power_down
      ath10k: fix possible bmi crash
      ath10k: expose hw restart via debugfs
      ath10k: speed up hw recovery
      ath10k: start using sk_buff_head
      ath10k: simplify Rx loop
      ath10k: refactor htt->rx_confused
      ath10k: unify rx undecapping
      ath10k: remove unused function argument
      ath10k: use rx descriptor for ppdu status extraction
      ath10k: report rx rate and signal for fragmented Rx
      ath10k: remove extra_tx_headroom
      ath10k: fix offchan reliability
      ath10k: make hw roc more reliable
      ath10k: fix offchannel cancel failures
      ath10k: don't drop corrupted mgmt frames
      ath10k: add missing goto
      ath10k: clean up num_peers locking
      ath10k: fix station count enforcement
      ath10k: add pointer constness to traces
      ath10k: fix wmi svc bitmap dbg print
      ath10k: add sanity checks for service bmap parsing
      ath10k: make wmi service bitmap non-debug
      ath10k: remove unused callback argument from struct ath10k_hif_cb::rx_completion
      ath10k: remove transfer_id from ath10k_hif_cb::tx_completion
      ath10k: prevent pci tx/rx starvation
      ath10k: simplify rx ring size/fill calculation

Michal Kubeƒçek (2):
      net: generic dev_disable_lro() stacked device handling
      macvlan: allow setting LRO independently of lower device

Michele Baldessari (2):
      sctp: add transport state in /proc/net/sctp/remaddr
      sctp: replace seq_printf with seq_puts

Mirko Lindner (1):
      sky2: Fix crash inside sky2_rx_clean

Mitch Williams (16):
      i40e: process link events when setting up switch
      i40e: Add 10GBaseT support
      i40evf: properly handle multiple AQ messages
      i40e: fix link checking logic
      i40e: configure VM ID in qtx_ctl
      i40e: properly parse MDET registers
      i40evf: make early init processing more robust
      i40evf: don't use more queues than CPUs
      i40e: re-enable VFLR interrupt sooner
      i40e: don't overload fields
      i40evf: update header comments
      i40evf: make checkpatch happy
      i40evf: make comparisons consistent
      i40evf: remove unnecessary else
      i40evf: make early init sequence even more robust
      i40e: increase ARQ size

Mitsuhiro Kimura (2):
      sh_eth: Optimization for RX excess judgement
      sh_eth: Remove redundant alignment adjustment

Neerav Parikh (9):
      i40e/i40evf: Use usleep_range() instead of udelay()
      i40e: Resume Port Tx after DCB event
      i40e: Add support to firmware CEE DCBX mode
      i40e: Check for LLDP AdminStatus before querying DCBX
      i40e: Update VEB's enabled_tc after reconfiguration
      i40e: Modify Tx disable wait flow in case of DCB reconfiguration
      i40e: Do not disable/enable FCoE VSI with DCB reconfig
      i40e: Prevent link flow control settings when PFC is enabled
      i40e: Set XPS bit mask to zero in DCB mode

Nicolas Dichtel (1):
      neigh: optimize neigh_parms_release()

Nimrod Andy (5):
      net: fec: init maximum receive buffer size for ring1 and ring2
      net: fec: avoid kernal crash by NULL pointer when no phy connection
      net: fec: reset fep link status in suspend function
      net: fec: clear all interrupt events to support i.MX6SX
      net: fec: only enable mdio interrupt before phy device link up

Oleksij Rempel (23):
      ath9k: add struct ath_spec_scan_priv
      ath9k: move spectral_mode to ath_spec_scan_priv
      ath9k: move spec_config to ath_spec_scan_priv
      ath9k: use struct dentry by ath9k_spectral_init_debug
      ath9k: add ath_hw to ath_spec_scan_priv
      ath9k: remove all struct ath_softc dependencies from spectral code
      ath: add struct ath_ps_ops
      ath9k: add ath_ps_ops bindings
      ath9k: use ath_ps_ops in ath9k_spectral_scan_
      ath9k: use ath_common instead of ieee80211_hw in ath9k_spectral_scan_
      ath9k: make ath9k_spectral_scan_ do not depend on ath_softc
      ath9k: move ath9k_spectral_scan_ from main.c to spectral.c
      ath9k: move spectral.* to common-spectral.*
      ath9k: For AR9271 chipsets, set count = 0 for endless samples.
      ath9k_htc: fix rs_datalen conversation
      ath9k_htc: add ath_ps_ops bindings
      ath9k_htc: add struct ath_spec_scan_priv to ath9k_htc_priv
      ath9k_htc: set initial spec_config values
      ath9k_htc: trigger spectral scan on set_channel
      ath9k_htc: process rx spectral packets
      ath9k_htc: add spectral scan debug interface
      ath9k: common-spectral: don't depend from ATH9K_DEBUGFS
      ath9k_common: make sure DEBUG_FS and RELAY enabled

Oliver Neukum (1):
      cdc-ether: implement MULTICAST flag on the device

Or Gerlitz (2):
      net/mlx4_en: Set csum level for encapsulated packets
      net/mlx4_core: Mask out host side virtualization features for guests

Oren Givon (2):
      iwlwifi: sdio: new SDIO card id for 4165 series
      iwlwifi: fix 4165 series name

Pablo Neira Ayuso (6):
      Merge branch 'ipvs-next'
      netfilter: nf_log: fix sparse warning in nf_logger_find_get()
      netfilter: fix unmet dependencies in NETFILTER_XT_TARGET_REDIRECT
      netfilter: nft_redir: fix sparse warnings
      netfilter: nfnetlink_log: remove unnecessary error messages
      netfilter: combine IPv4 and IPv6 nf_nat_redirect code in one module

Patrik Flykt (3):
      mac80211-hwsim: Factor out netlink attribute appending
      mac80211-hwsim: Add HWSIM_CMD_GET_RADIO command
      mac80211_hwsim: Send alpha2 only if non-zero

Paul Gortmaker (1):
      netpoll: delete defconfig references to obsolete NETPOLL_TRAP

Paul M Stillwell Jr (1):
      i40evf: Add support for 10G base T parts

Pavaluca Matei-B46610 (2):
      Add flow control support flags to gianfar's capabilities
      Fix the way the local advertising flow options are determined

Peter Oh (1):
      ath10k: fix mismatched wmi api call

Petri Gynther (1):
      net: bcmgenet: enable driver to work without a device tree

Pravin B Shelar (9):
      net: Remove MPLS GSO feature.
      openvswitch: Move table destroy to dp-rcu callback.
      openvswitch: Refactor action alloc and copy api.
      openvswitch: Avoid NULL mask check while building mask
      openvswitch: Export symbols as GPL symbols.
      openvswitch: Optimize recirc action.
      openvswitch: Remove redundant key ref from upcall_info.
      openvswitch: Fix build failure.
      openvswitch: Fix flow mask validation.

Rafa≈Ç Mi≈Çecki (2):
      bcma: fill core details for every device
      cfg80211: protect fools returning NULL in add_virtual_intf

Rajkumar Manoharan (9):
      ath10k: add support to configure pktlog filter
      ath10k: add tracing for ath10k_htt_pktlog
      ath10k: add tracing for rx descriptor
      ath10k: add tracing for tx info
      ath10k: add tracing for frame transmission
      ath10k: fix kernel panic while shutting down AP
      ath10k: handle ieee80211 header and payload tracing separately
      ath10k: add modpram 'skip_otp' to ignore empty otp error during BMI
      ath10k: advertise support for AP mode channel width changes

Rami Rosen (1):
      Documentation (ixgbe.txt): use a decimal address.

Rasmus Villemoes (2):
      net: typhoon: Remove redundant casts
      net: tulip: Remove private "strncmp"

Ricardo Ribalda Delgado (1):
      wireless/p54: Remove duplicated net2280 header

Richard Alpe (17):
      tipc: add bearer disable/enable to new netlink api
      tipc: add bearer get/dump to new netlink api
      tipc: add bearer set to new netlink api
      tipc: add sock dump to new netlink api
      tipc: add publication dump to new netlink api
      tipc: add link get/dump to new netlink api
      tipc: add link set to new netlink api
      tipc: add link stat reset to new netlink api
      tipc: add media get/dump to new netlink api
      tipc: add media set to new netlink api
      tipc: add node get/dump to new netlink api
      tipc: add net dump to new netlink api
      tipc: add net set to new netlink api
      tipc: add name table dump to new netlink api
      tipc: fix sparse warnings in new nl api
      tipc: add tipc_netlink.h to uapi Kbuild
      tipc: fix broadcast wakeup contention after congestion

Richard Cochran (1):
      vlan: Pass ethtool get_ts_info queries to real device.

Rick Jones (2):
      udp: Increment UDP_MIB_IGNOREDMULTI for arriving unmatched multicasts
      icmp: Remove some spurious dropped packet profile hits from the ICMP path

Roberto Medina (1):
      net: ethernet: realtek: atp: checkpatch errors and warnings corrected

Roger Quadros (9):
      can: c_can: Add timeout to c_can_hw_raminit_ti()
      can: c_can: Introduce c_can_driver_data structure
      can: c_can: Add RAMINIT register information to driver data
      can: c_can: Add syscon/regmap RAMINIT mechanism
      can: c_can: Add support for START pulse in RAMINIT sequence
      can: c_can: Disable pins when CAN interface is down
      can: c_can: Add support for TI DRA7 DCAN
      can: c_can: Add support for TI am3352 DCAN
      net: can: c_can: Add support for TI am4372 DCAN

Roopa Prabhu (3):
      bridge: new mode flag to indicate mode 'undefined'
      rocker: remove swdev mode
      bridge: remove mode BRIDGE_MODE_SWDEV

Rostislav Lisovy (2):
      cfg80211: 802.11p OCB mode handling
      mac80211: 802.11p OCB mode support

Saeed Mahameed (11):
      net/mlx4_core: Introduce mlx4_get_module_info for cable module info reading
      ethtool, net/mlx4_en: Cable info, get_module_info/eeprom ethtool support
      net/mlx4_core: Introduce ACCESS_REG CMD and eth_prot_ctrl dev cap
      net/mlx4_core: Add ethernet backplane autoneg device capability
      ethtool, net/mlx4_en: Add 100M, 20G, 56G speeds ethtool reporting support
      net/mlx4_en: Use PTYS register to query ethtool settings
      net/mlx4_en: Use PTYS register to set ethtool settings (Speed)
      net/mlx4_en: Add support for setting rxvlan offload OFF/ON
      net/mlx4_en: Add ethtool support for [rx|tx]vlan offload set to OFF/ON
      net/mlx4_core: Prevent VF from changing port configuration
      net/mlx4_en: mlx4_en_set_settings() always fails when autoneg is set

Scott Feldman (9):
      bridge: call netdev_sw_port_stp_update when bridge port STP status changes
      bridge: add API to notify bridge driver of learned FBD on offloaded device
      bridge: move private brport flags to if_bridge.h so port drivers can use flags
      bridge: add new brport flag LEARNING_SYNC
      bridge: add new hwmode swdev
      bridge: add brport flags to dflt bridge_getlink
      rocker: implement rocker ofdpa flow table manipulation
      rocker: implement L2 bridge offloading
      rocker: add ndo_bridge_setlink/getlink support for learning policy

Sebastian Hesselbarth (6):
      phy: marvell: Add support for 88E3016 FastEthernet PHY
      net: pxa168_eth: Provide phy_interface mode on platform_data
      net: pxa168_eth: Prepare proper libphy handling
      net: pxa168_eth: Remove HW auto-negotiaion
      net: pxa168_eth: Remove in-driver PHY mangling
      net: pxa168_eth: Fix providing of phy_interface mode on platform_data

Shani Michaeli (2):
      net/mlx4_en: Extend usage of napi_gro_frags
      net/mlx4_en: Extend checksum offloading by CHECKSUM COMPLETE

Shannon Nelson (24):
      i40e: remove debugfs dump stats
      i40e: scale msix vector use when more cores than vectors
      i40e: better wording for resource tracking errors
      i40e: enable debug earlier
      i40e: don't do link_status or stats collection on every ARQ
      i40e: only warn once of PTP nonsupport in 100Mbit speed
      i40e: trigger SW INT with no ITR wait
      i40e: Remove unneeded break statement
      i40e: remove useless debug noise
      i40e: allow various base numbers in debugfs aq commands
      i40e: fix netdev_stat macro definition
      i40e: get pf_id from HW rather than PCI function
      i40e: clear NVM update state on ethtool test
      i40e: better error messages for NVM update issues
      i40e: let firmware catch the NVM busy error
      i40e: rework debug messages for NVM update
      i40e: add range check to i40e_aq_rc_to_posix
      i40e: init NVM update state on adminq init
      i40e: remove unused nvm_semaphore_wait
      i40e: set max limit for access polling
      i40e: fix up NVM update sm error handling
      i40e: poll on NVM semaphore only if not other error
      i40e: check for AQ timeout in aq_rc decode
      i40e: add to NVM update debug message

Shradha Shah (3):
      sfc: Move the current VF state from efx_nic into siena_nic_data
      sfc: Rename implementations in siena_sriov.c to have a 'siena' prefix
      sfc: Add NIC type operations to replace direct calls from efx.c into siena_sriov.c

Simon Horman (2):
      datapath: Rename last_action() as nla_is_last() and move to netlink.h
      openvswitch: Add basic MPLS support to kernel

Simon Vincent (3):
      ieee802154: 6lowpan: Drop PACKET_OTHERHOST skbs in 6lowpan
      ieee802154: mrf24j40: Add support for MRF24J40MC
      6lowpan: fix udp header compression when using raw sockets

Sowmini Varadhan (11):
      sunvnet: NAPIfy sunvnet
      sunvnet: Use RCU to synchronize port usage with vnet_port_remove()
      sunvnet: Remove irqsave/irqrestore on vio.lock
      tcp: Correction to RFC number in comment
      sunvnet: Reset LDC_EVENT_DATA_READY when napi completes.
      sunvnet: Use one Tx queue per vnet_port
      sunvnet: Fix indentation in maybe_tx_wakeup()
      sunvnet: Return from vnet_napi_event() if no packets to read
      sunvnet: Fix race between vnet_start_xmit() and vnet_ack()
      sunvnet: vnet_ack() should check if !start_cons to send a missed trigger
      sunvnet: Add missing rcu_read_unlock() in vnet_start_xmit

Sriharsha Basavapatna (1):
      be2net: Export tunnel offloads only when a VxLAN tunnel is created

Stanislaw Gruszka (6):
      rt2x00: tune multi-registers I/O timeout
      rt2800: calculate tx power temperature compensation on selected chips
      rt2x00: use timeout in rt2x00usb_vendor_request
      rt2x00: change REGISTER_BUSY_COUNT for USB
      rt2x00: change REGISTER_TIMEOUT
      Revert "rt2x00: Endless loop on hub port power down"

Stefan Schmidt (5):
      net/6lowpan: Remove FSF address from GPL statement.
      net/ieee802154: Make sure alignment matches parenthesis..
      net/ieee802154: Remove and add extra blank lines as needed.
      net/mac802154: Remove extra blank lines.
      net/mac802154: No need for an extra space when casting

Steffen Klassert (3):
      ipv6: Allow sending packets through tunnels with wildcard endpoints
      ip6_tunnel: Add support for wildcard tunnel endpoints.
      vti6: Add a lookup method for tunnels with wildcard endpoints.

Stephane Grosjean (3):
      can: peak_usb: fix memset() usage
      can: peak_usb: fix cleanup sequence order in case of error during init
      can: peak_usb: fix multi-byte values endianess

Stephen Hemminger (2):
      Bluetooth: spelling fixes
      mac80211: fix spelling errors

Stephen Rothwell (1):
      cxgb4/cxgb4vf: global named must be unique

Steven Noonan (1):
      netfilter: nf_log_ipv6: correct typo in module description

Steven Walter (1):
      Bluetooth: Automatically flushable packets aren't allowed on LE links

Sudip Mukherjee (3):
      hamradio: 6pack: remove unnecessary check
      usbnet: smsc95xx: dereferencing NULL pointer
      usbnet: rtl8150: remove unused variable

Sujith Manoharan (38):
      ath9k: Use sta_state() callback
      ath9k: Enable multi-channel properly
      ath9k: Process beacons properly
      ath9k: Unify reset API
      ath9k: Set ATH_OP_HW_RESET before HW reset
      ath9k: Disable beacon tasklet during reset
      ath9k: Clear NoA schedule properly
      ath9k: Use configurable timeout for flush
      ath9k: Fix MCC flush timeout
      ath9k: Fix offchannel flush timeout
      ath9k: Check for pending frames properly
      ath9k: Send AUTHORIZED event only for station mode
      ath9k: Fix address management
      ath9k: Add a function to check for an active GO
      ath9k: Check for active GO in mgd_prepare_tx()
      ath9k: Use a helper function for offchannel NoA
      ath9k: Use a helper function to set NoA
      ath9k: Use a helper function for bmiss
      ath9k: Fix RoC expiration
      ath9k: Send oneshot NoA
      ath9k: Fix HW scan abort
      ath9k: Improve flush() in mcc mode
      ath9k: Do not start BA when scanning
      ath9k: Update AR9580 initvals
      ath9k: Update AR955x initvals
      ath9k: Update QCA953x initvals
      ath9k: Fix LED configuration
      ath9k: Enable TSF2 for generic HW timers
      ath9k: Store the chip chainmask in HW capabilities
      ath9k: Fix thermometer programming
      ath9k: Clear offchannel state properly
      ath9k: Cancel pending offchannel operations
      ath9k: Handle failure to send NoA
      ath9k: Adjust tbtt delta properly
      ath9k: Move roc completion to the offchannel timer
      ath10k: fix shared WEP
      ath10k: fix locking for WEP keys
      ath10k: fix bug reported by lockdep

Szymon Janc (3):
      Bluetooth: Fix RFCOMM NSC response
      Bluetooth: Improve RFCOMM __test_pf macro robustness
      Bluetooth: Fix invalid response for 'Start Discovery' command

S√©bastien Barr√© (1):
      Removed unused function sctp_addr_is_valid()

Thomas Graf (7):
      ovs: Turn vports with dependencies into separate modules
      openvswitch: Constify various function arguments
      FOU: Fix no return statement warning for !CONFIG_NET_FOU_IP_TUNNELS
      rhashtable: Drop gfp_flags arg in insert/remove functions
      rhashtable: Check for count mismatch while iterating in selftest
      rocker: Add proper validation of Netlink attributes
      rocker: Use logical operators on booleans

Thomas Richter (6):
      qeth: qeth_core_main make local functions static
      qeth: fix some trace formating issues
      qeth: make local functions static in qeth_l3 module
      qeth: s390 ethernet device driver dependency
      lcs: replace sscanf by kstrto function
      ctcm: replace sscanf by kstrto function

Tilman Schmidt (5):
      isdn/gigaset: drop duplicate declaration
      isdn/gigaset: clarify gigaset_modem_fill control structure
      isdn/gigaset: elliminate unnecessary argument from send_cb()
      isdn/gigaset: enable Kernel CAPI support by default
      isdn/capi: correct argument types of command_2_index

Tina Johnson (1):
      drivers: atm: eni: Add pci_dma_mapping_error() call

Tom Herbert (13):
      net: Move fou_build_header into fou.c and refactor
      udp: Offload outer UDP tunnel csum if available
      gue: Add infrastructure for flags and options
      udp: Changes to udp_offload to support remote checksum offload
      gue: Protocol constants for remote checksum offload
      gue: TX support for using remote checksum offload option
      gue: Receive side of remote checksum offload
      fou: Fix typo in returning flags in netlink
      vxlan: Fix to enable UDP checksums on interface
      ip_tunnel: Ops registration for secondary encap (fou, gue)
      net: Add remcsum_adjust as common function for remote checksum offload
      gue: Call remcsum_adjust
      gre: Set inner mac header in gro complete

Tomasz Bursztyka (1):
      nl80211: Broadcast CMD_NEW_INTERFACE and CMD_DEL_INTERFACE

Toshiaki Makita (1):
      net: skb_segment() should preserve backpressure

Valdis Kletnieks (1):
      net: fix suspicious rcu_dereference_check in net/sched/sch_fq_codel.c

Varka Bhadram (10):
      ethernet: wiznet: remove unnecessary check
      ethernet: apm: xgene: remove unnecessary check
      ethernet: marvell: remove unnecessary check
      ethernet: renesas: remove unnecessary check
      ethernet: samsung: sxgbe: remove unnecessary check
      MAINTAINERS: add cc2520 driver maintainer
      ieee802154: fix spelling mistakes
      mac802154: remove unnecessary if statement
      mac802154: use goto label on failure
      cc2520: adds terminating newline

Vasily Averin (1):
      netfilter: nf_conntrack_h323: lookup route from proper net namespace

Viet Nga Dao (1):
      net: phy: Adding SGMII support for Marvell 88ee1145 driver

Vivek Natarajan (2):
      ath: Fix a false radar detection pattern
      ath10k: do not limit RTS threshold value to 2347

Vladimir Kondratiev (14):
      wil6210: do not attempt FW recovery if interface is down
      wil6210: reset flow updates
      wil6210: prevent double disconnect command issuing
      wil6210: improve dmesg for fw error handling
      wil6210: Add support for large packets
      wil6210: propagate disconnect reason
      wil6210: add handling of RX HTRSH interrupt
      wil6210: fix recovery after scan timeout
      wil6210: remove wil_to_pcie_dev()
      wil6210: configurable vring sizes
      wil6210: fix warning in pointer arithmetic
      wil6210: Rate limit "ring full" error message
      wil6210: reset flow update
      wil6210: remove TODO wrt buffer alignment

Vladimir Zapolskiy (1):
      net: phy: spi_ks8995: remove sysfs bin file by registered attribute

WANG Cong (3):
      ipv6: move INET6_MATCH() to include/net/inet6_hashtables.h
      neigh: remove dynamic neigh table registration support
      net: kill netif_copy_real_num_queues()

Wenyu Zhang (1):
      openvswitch: Extend packet attribute for egress tunnel info

Willem de Bruijn (4):
      packet: make packet_snd fail on len smaller than l2 header
      ipv4: warn once on passing AF_INET6 socket to ip_recv_error
      net-timestamp: allow reading recv cmsg on errqueue with origin tstamp
      net-timestamp: expand documentation and test

Xinming Hu (2):
      mwifiex: add cfg80211 dump_survey handler
      Bluetooth: btmrvl add firmware dump support

Yanbo Li (2):
      ath10k: add register access debugfs interface
      ath10k: add memory dump debugfs interface

Yaniv Rosner (1):
      bnx2x: Limit 1G link enforcement

Ying Xue (20):
      tipc: remove node subscription infrastructure
      tipc: remove protocol message queue
      tipc: remove retransmission queue
      tipc: clean up the process of link pushing packets
      tipc: eliminate two pseudo message types of BUNDLE_OPEN and BUNDLE_CLOSED
      tipc: remove unused between routine
      tipc: use skb_queue_walk_safe marco to simplify link_prepare_wakeup routine
      tipc: use generic SKB list APIs to manage link transmission queue
      tipc: use generic SKB list APIs to manage deferred queue of link
      tipc: use generic SKB list APIs to manage link receive queue
      tipc: use generic SKB list APIs to manage TIPC outgoing packet chains
      tipc: remove size variable from publ_list struct
      tipc: make name table allocated dynamically
      tipc: ensure all name sequences are released when name table is stopped
      tipc: ensure all name sequences are properly protected with its lock
      tipc: any name table member must be protected under name table lock
      tipc: simplify relationship between name table lock and node lock
      tipc: remove unnecessary INIT_LIST_HEAD
      tipc: convert name table read-write lock to RCU
      tipc: avoid double lock 'spin_lock:&seq->lock'

Yuval Mintz (1):
      bnx2x: Use correct fastpath version for VFs.

Zoltan Kiss (2):
      xen-netback: Disable NAPI after disabling interrupts
      xen-netback: Remove __GFP_COLD

dingzhi (1):
      xfrm: add XFRMA_REPLAY_VAL attribute to SA messages

hayeswang (13):
      r8152: rename tx_underun
      r8152: support nway_reset of ethtool
      r8152: set RTL8152_UNPLUG when finding -ENODEV
      r8152: disable the tasklet by default
      r8152: move r8152b_get_version
      r8152: modify rtl_ops_init
      r8152: remove the definitions of the PID
      r8152: remove the duplicate init for the list of rx_done
      r8152: clear the flag of SCHEDULE_TASKLET in tasklet
      r8152: check RTL8152_UNPLUG and netif_running before autoresume
      r8152: adjust r8152_submit_rx
      r8152: adjust rtl_start_rx
      r8152: redefine REALTEK_USB_DEVICE

kbuild test robot (2):
      ath9k: ath9k_op_ps_wakeup() can be static
      ath9k_htc: ath9k_htc_op_ps_wakeup() can be static

stephen hemminger (5):
      netfilter: fix spelling errors
      ipv4: minor spelling fixes
      tipc: spelling errors
      uapi: resort Kbuild entries
      tc_act: export uapi header file

willy tarreau (1):
      net: mvneta: fix Tx interrupt delay

zhuyj (1):
      ipv6: Remove unnecessary test

 Documentation/ABI/testing/sysfs-class-net                             |    8 +
 Documentation/Changes                                                 |    2 +-
 Documentation/devicetree/bindings/btmrvl.txt                          |   29 +
 Documentation/devicetree/bindings/bus/bcma.txt                        |   21 +
 Documentation/devicetree/bindings/net/amd-xgbe.txt                    |   12 +-
 Documentation/devicetree/bindings/net/can/c_can.txt                   |    5 +
 Documentation/devicetree/bindings/net/dsa/dsa.txt                     |    9 +-
 Documentation/devicetree/bindings/net/micrel.txt                      |   35 +-
 Documentation/devicetree/bindings/net/phy.txt                         |    3 +-
 Documentation/devicetree/bindings/net/sh_eth.txt                      |    1 +
 Documentation/networking/bonding.txt                                  |    7 +-
 Documentation/networking/ip-sysctl.txt                                |   23 +-
 Documentation/networking/ipvlan.txt                                   |  107 ++
 Documentation/networking/ixgbe.txt                                    |    2 +-
 Documentation/networking/stmmac.txt                                   |  132 +-
 Documentation/networking/switchdev.txt                                |   59 +
 Documentation/networking/timestamping.txt                             |   35 +-
 Documentation/networking/timestamping/txtimestamp.c                   |   90 +-
 Documentation/sysctl/net.txt                                          |   34 +-
 MAINTAINERS                                                           |   37 +-
 Makefile                                                              |    2 +-
 arch/alpha/include/asm/Kbuild                                         |    1 -
 arch/alpha/include/uapi/asm/socket.h                                  |    5 +
 arch/arc/include/asm/Kbuild                                           |    1 -
 arch/arm/boot/dts/exynos5250-snow.dts                                 |    4 +
 arch/arm/boot/dts/exynos5250.dtsi                                     |    2 +-
 arch/arm/configs/davinci_all_defconfig                                |    1 -
 arch/arm/configs/exynos_defconfig                                     |    2 +
 arch/arm/include/asm/Kbuild                                           |    1 -
 arch/arm/include/asm/thread_info.h                                    |   11 -
 arch/arm/kernel/sys_oabi-compat.c                                     |    4 +-
 arch/arm/kernel/traps.c                                               |   31 +-
 arch/arm/kvm/mmu.c                                                    |   10 +-
 arch/arm/mach-mmp/gplugd.c                                            |    1 +
 arch/arm/mach-mvebu/coherency.c                                       |    2 +
 arch/arm/mach-tegra/irq.c                                             |   22 +-
 arch/arm/mm/proc-v7.S                                                 |    2 -
 arch/arm/mm/proc-xscale.S                                             |    4 +-
 arch/arm64/include/asm/Kbuild                                         |    1 -
 arch/arm64/kvm/sys_regs.c                                             |    9 +
 arch/avr32/include/asm/Kbuild                                         |    1 -
 arch/avr32/include/uapi/asm/socket.h                                  |    5 +
 arch/blackfin/include/asm/Kbuild                                      |    1 -
 arch/c6x/include/asm/Kbuild                                           |    1 -
 arch/cris/include/asm/Kbuild                                          |    1 -
 arch/cris/include/uapi/asm/socket.h                                   |    5 +
 arch/frv/include/asm/Kbuild                                           |    1 -
 arch/frv/include/uapi/asm/socket.h                                    |    5 +
 arch/hexagon/include/asm/Kbuild                                       |    1 -
 arch/ia64/include/asm/Kbuild                                          |    1 -
 arch/ia64/include/uapi/asm/socket.h                                   |    5 +
 arch/ia64/kvm/kvm-ia64.c                                              |    2 +-
 arch/m32r/include/asm/Kbuild                                          |    1 -
 arch/m32r/include/uapi/asm/socket.h                                   |    5 +
 arch/m68k/include/asm/Kbuild                                          |    1 -
 arch/metag/include/asm/Kbuild                                         |    1 -
 arch/microblaze/include/asm/Kbuild                                    |    1 -
 arch/mips/Kconfig                                                     |   14 +-
 arch/mips/include/asm/Kbuild                                          |    1 -
 arch/mips/include/asm/mipsregs.h                                      |    2 +
 arch/mips/include/asm/r4kcache.h                                      |    4 +
 arch/mips/include/asm/uaccess.h                                       |    6 +-
 arch/mips/include/uapi/asm/socket.h                                   |    5 +
 arch/mips/include/uapi/asm/unistd.h                                   |    2 +-
 arch/mips/kernel/bmips_vec.S                                          |    3 -
 arch/mips/kernel/cps-vec.S                                            |    2 +
 arch/mips/kernel/cpu-probe.c                                          |   33 +-
 arch/mips/kernel/rtlx.c                                               |    4 +-
 arch/mips/kernel/setup.c                                              |    4 +-
 arch/mips/kernel/signal.c                                             |    8 +-
 arch/mips/loongson/common/Makefile                                    |    3 +-
 arch/mips/mm/tlbex.c                                                  |   10 +-
 arch/mips/mti-sead3/sead3-leds.c                                      |    8 +-
 arch/mips/net/bpf_jit.c                                               |    4 +-
 arch/mips/netlogic/xlp/Makefile                                       |   12 +-
 arch/mn10300/include/asm/Kbuild                                       |    1 -
 arch/mn10300/include/uapi/asm/socket.h                                |    5 +
 arch/openrisc/include/asm/Kbuild                                      |    1 -
 arch/parisc/include/asm/Kbuild                                        |    1 -
 arch/parisc/include/uapi/asm/socket.h                                 |    5 +
 arch/powerpc/configs/85xx/ge_imp3a_defconfig                          |    1 -
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig                         |    1 -
 arch/powerpc/configs/86xx/gef_sbc310_defconfig                        |    1 -
 arch/powerpc/configs/86xx/gef_sbc610_defconfig                        |    1 -
 arch/powerpc/configs/86xx/sbc8641d_defconfig                          |    1 -
 arch/powerpc/configs/c2k_defconfig                                    |    1 -
 arch/powerpc/configs/ppc64_defconfig                                  |    1 -
 arch/powerpc/configs/ppc64e_defconfig                                 |    1 -
 arch/powerpc/configs/ppc6xx_defconfig                                 |    1 -
 arch/powerpc/configs/pseries_defconfig                                |    1 -
 arch/powerpc/configs/pseries_le_defconfig                             |    1 -
 arch/powerpc/include/asm/Kbuild                                       |    1 -
 arch/powerpc/include/asm/pci-bridge.h                                 |    2 -
 arch/powerpc/include/asm/ppc-opcode.h                                 |    1 +
 arch/powerpc/include/uapi/asm/socket.h                                |    5 +
 arch/powerpc/kernel/eeh_sysfs.c                                       |    2 +-
 arch/powerpc/kernel/pci_64.c                                          |   10 -
 arch/powerpc/kernel/vdso32/getcpu.S                                   |    4 +-
 arch/powerpc/net/bpf_jit.h                                            |    7 +
 arch/powerpc/net/bpf_jit_comp.c                                       |   49 +-
 arch/powerpc/platforms/powernv/opal-hmi.c                             |    2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c                             |    5 +-
 arch/powerpc/platforms/powernv/pci.c                                  |    3 +-
 arch/powerpc/platforms/pseries/msi.c                                  |    2 +-
 arch/powerpc/xmon/xmon.c                                              |    6 +-
 arch/s390/include/asm/Kbuild                                          |    1 -
 arch/s390/include/uapi/asm/socket.h                                   |    5 +
 arch/s390/kernel/nmi.c                                                |    8 +-
 arch/score/include/asm/Kbuild                                         |    1 -
 arch/sh/include/asm/Kbuild                                            |    1 -
 arch/sparc/include/asm/Kbuild                                         |    1 -
 arch/sparc/include/asm/dma-mapping.h                                  |    8 +
 arch/sparc/include/asm/vio.h                                          |   19 +
 arch/sparc/include/uapi/asm/socket.h                                  |    5 +
 arch/tile/configs/tilegx_defconfig                                    |    1 -
 arch/tile/configs/tilepro_defconfig                                   |    1 -
 arch/tile/include/asm/Kbuild                                          |    1 -
 arch/um/include/asm/Kbuild                                            |    1 -
 arch/unicore32/include/asm/Kbuild                                     |    1 -
 arch/x86/include/asm/hash.h                                           |    7 -
 arch/x86/kvm/mmu.c                                                    |    6 +-
 arch/x86/lib/Makefile                                                 |    2 +-
 arch/x86/lib/hash.c                                                   |   92 --
 arch/x86/net/bpf_jit_comp.c                                           |   34 +-
 arch/xtensa/include/asm/Kbuild                                        |    1 -
 arch/xtensa/include/uapi/asm/socket.h                                 |    5 +
 block/bio-integrity.c                                                 |   13 +-
 crypto/af_alg.c                                                       |    2 +-
 crypto/algif_hash.c                                                   |    6 +-
 crypto/algif_skcipher.c                                               |   14 +-
 drivers/atm/eni.c                                                     |    3 +
 drivers/atm/solos-pci.c                                               |    2 +
 drivers/bcma/bcma_private.h                                           |    1 +
 drivers/bcma/driver_chipcommon.c                                      |    2 +-
 drivers/bcma/driver_gpio.c                                            |    4 +-
 drivers/bcma/driver_mips.c                                            |   11 +-
 drivers/bcma/driver_pci_host.c                                        |    4 +-
 drivers/bcma/main.c                                                   |   79 +-
 drivers/bcma/scan.c                                                   |    1 +
 drivers/bluetooth/Kconfig                                             |    1 +
 drivers/bluetooth/ath3k.c                                             |    4 +
 drivers/bluetooth/btmrvl_debugfs.c                                    |   31 +
 drivers/bluetooth/btmrvl_drv.h                                        |   20 +
 drivers/bluetooth/btmrvl_main.c                                       |   68 +-
 drivers/bluetooth/btmrvl_sdio.c                                       |  304 +++-
 drivers/bluetooth/btmrvl_sdio.h                                       |    5 +
 drivers/bluetooth/btusb.c                                             |   14 +-
 drivers/bluetooth/hci_ath.c                                           |    2 +-
 drivers/bluetooth/hci_h5.c                                            |   25 +
 drivers/clk/at91/clk-usb.c                                            |   35 +-
 drivers/clk/clk-divider.c                                             |   18 +-
 drivers/clk/pxa/clk-pxa27x.c                                          |    4 +-
 drivers/clk/qcom/mmcc-apq8084.c                                       |    2 +-
 drivers/clk/rockchip/clk.c                                            |    4 +-
 drivers/gpu/drm/i915/intel_display.c                                  |    4 +
 drivers/gpu/drm/i915/intel_dp.c                                       |    1 +
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c                     |    1 -
 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.c                       |    2 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c                       |    4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c                       |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c                                 |    2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c                               |   92 +-
 drivers/gpu/drm/nouveau/nouveau_fence.h                               |    4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c                            |   19 +-
 drivers/gpu/drm/radeon/radeon_cs.c                                    |   17 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c                               |   10 +
 drivers/gpu/drm/radeon/radeon_kms.c                                   |    2 +
 drivers/gpu/drm/radeon/radeon_object.c                                |    7 +
 drivers/hv/channel_mgmt.c                                             |    2 +
 drivers/hwmon/g762.c                                                  |    6 +-
 drivers/i2c/busses/i2c-designware-core.c                              |    2 +-
 drivers/i2c/busses/i2c-omap.c                                         |   10 +-
 drivers/iio/accel/bmc150-accel.c                                      |   40 +-
 drivers/iio/accel/kxcjk-1013.c                                        |    2 +
 drivers/iio/adc/men_z188_adc.c                                        |    1 +
 drivers/iio/gyro/bmg160.c                                             |   53 +-
 drivers/infiniband/hw/cxgb4/cm.c                                      |  176 +-
 drivers/infiniband/hw/cxgb4/cq.c                                      |    8 +-
 drivers/infiniband/hw/cxgb4/mem.c                                     |   34 +-
 drivers/infiniband/hw/cxgb4/provider.c                                |    8 +-
 drivers/infiniband/hw/cxgb4/qp.c                                      |   26 +-
 drivers/infiniband/hw/mlx4/cq.c                                       |    5 +-
 drivers/infiniband/hw/mlx4/main.c                                     |    5 +-
 drivers/infiniband/hw/mlx4/qp.c                                       |   13 +-
 drivers/infiniband/hw/mlx5/cq.c                                       |    8 +-
 drivers/infiniband/hw/mlx5/mr.c                                       |    7 +-
 drivers/infiniband/hw/mlx5/qp.c                                       |   24 +-
 drivers/infiniband/hw/mlx5/srq.c                                      |    6 +-
 drivers/input/evdev.c                                                 |    2 +-
 drivers/input/joystick/xpad.c                                         |   16 +-
 drivers/input/mouse/elantech.c                                        |   10 +-
 drivers/input/mouse/synaptics.c                                       |    4 +
 drivers/irqchip/irq-atmel-aic-common.c                                |    6 +-
 drivers/irqchip/irq-bcm7120-l2.c                                      |    4 +-
 drivers/irqchip/irq-brcmstb-l2.c                                      |    4 +-
 drivers/isdn/capi/capiutil.c                                          |    2 +-
 drivers/isdn/gigaset/Kconfig                                          |    2 +-
 drivers/isdn/gigaset/gigaset.h                                        |    3 -
 drivers/isdn/gigaset/usb-gigaset.c                                    |   77 +-
 drivers/isdn/hisax/hfc_2bs0.c                                         |    2 +-
 drivers/isdn/hisax/hfc_sx.c                                           |    3 +-
 drivers/isdn/hisax/hfc_usb.c                                          |    5 +-
 drivers/isdn/hisax/ipacx.c                                            |    2 +-
 drivers/isdn/hisax/isdnl1.c                                           |    2 +-
 drivers/isdn/hisax/isdnl3.c                                           |    2 +-
 drivers/isdn/hysdn/hycapi.c                                           |    2 +-
 drivers/isdn/mISDN/l1oip_codec.c                                      |    6 +-
 drivers/isdn/mISDN/socket.c                                           |    4 +-
 drivers/isdn/pcbit/layer2.c                                           |    1 -
 drivers/misc/vmw_vmci/vmci_queue_pair.c                               |   17 +-
 drivers/net/Kconfig                                                   |   20 +
 drivers/net/Makefile                                                  |    1 +
 drivers/net/bonding/bond_3ad.c                                        |  106 +-
 drivers/net/bonding/bond_alb.c                                        |   23 +-
 drivers/net/bonding/bond_debugfs.c                                    |    4 +-
 drivers/net/bonding/bond_main.c                                       |   36 +-
 drivers/net/bonding/bond_netlink.c                                    |    9 +-
 drivers/net/bonding/bond_options.c                                    |    2 +-
 drivers/net/bonding/bond_procfs.c                                     |    2 +-
 drivers/net/bonding/bond_sysfs.c                                      |    2 +-
 drivers/net/bonding/bond_sysfs_slave.c                                |    2 +-
 drivers/net/can/Makefile                                              |    3 +-
 drivers/net/can/c_can/c_can.c                                         |   13 +
 drivers/net/can/c_can/c_can.h                                         |   25 +-
 drivers/net/can/c_can/c_can_platform.c                                |  201 ++-
 drivers/net/can/cc770/cc770.c                                         |    2 +-
 drivers/net/can/dev.c                                                 |   78 +
 drivers/net/can/flexcan.c                                             |  101 +-
 drivers/net/can/mscan/mscan.c                                         |   48 +-
 drivers/net/can/sja1000/sja1000.c                                     |   51 +-
 drivers/net/can/slcan.c                                               |    7 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c                               |   14 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                          |   20 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c                           |   23 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h                           |   48 +-
 drivers/net/can/vcan.c                                                |    5 +-
 drivers/net/dsa/Kconfig                                               |   15 +-
 drivers/net/dsa/Makefile                                              |    3 +
 drivers/net/dsa/bcm_sf2.c                                             |   58 +-
 drivers/net/dsa/mv88e6060.c                                           |    5 +-
 drivers/net/dsa/mv88e6123_61_65.c                                     |   25 +-
 drivers/net/dsa/mv88e6131.c                                           |   12 +-
 drivers/net/dsa/mv88e6171.c                                           |   26 +-
 drivers/net/dsa/mv88e6352.c                                           |  788 +++++++++
 drivers/net/dsa/mv88e6xxx.c                                           |  101 +-
 drivers/net/dsa/mv88e6xxx.h                                           |   16 +
 drivers/net/dummy.c                                                   |   20 +-
 drivers/net/ethernet/3com/typhoon.c                                   |    4 +-
 drivers/net/ethernet/Kconfig                                          |    1 +
 drivers/net/ethernet/Makefile                                         |    1 +
 drivers/net/ethernet/amd/Kconfig                                      |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h                           |   63 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c                             |  208 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c                              |  446 +++--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                              |  535 ++++--
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c                          |   89 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                             |   86 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h                                  |  112 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c                      |   12 -
 drivers/net/ethernet/broadcom/Kconfig                                 |    1 -
 drivers/net/ethernet/broadcom/b44.c                                   |    4 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c                          |    2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c                            |   36 +-
 drivers/net/ethernet/broadcom/bcmsysport.h                            |    3 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                       |    6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c                   |   20 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c                      |    5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                      |   13 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c                        |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h                        |    2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c                     |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h                     |    2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c                      |   75 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h                      |    9 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                        |  169 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h                        |   29 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c                          |  126 +-
 drivers/net/ethernet/broadcom/tg3.c                                   |   40 +-
 drivers/net/ethernet/brocade/bna/bnad.c                               |    2 +-
 drivers/net/ethernet/cadence/Kconfig                                  |    4 +-
 drivers/net/ethernet/cadence/macb.c                                   |    2 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c                               |   13 +-
 drivers/net/ethernet/chelsio/cxgb4/Makefile                           |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                            |   44 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c                        |   14 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.h                        |   10 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c                    |  158 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h                    |   52 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                       |  606 +++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h                        |   22 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                              |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                              |  303 ++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                            |  535 +++---
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h                           |  120 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h                    |  160 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h                          |   90 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h                         | 2269 ++++++++++++++++---------
 drivers/net/ethernet/chelsio/cxgb4vf/adapter.h                        |    7 +
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                   |  138 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c                            |  289 +++-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h                    |   21 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c                        |  555 ++++---
 drivers/net/ethernet/cirrus/mac89x0.c                                 |    8 +-
 drivers/net/ethernet/cisco/enic/enic.h                                |    2 +
 drivers/net/ethernet/cisco/enic/enic_ethtool.c                        |   38 +
 drivers/net/ethernet/cisco/enic/enic_main.c                           |   61 +-
 drivers/net/ethernet/cisco/enic/vnic_rss.h                            |    9 +-
 drivers/net/ethernet/cisco/enic/vnic_wq.h                             |   20 +-
 drivers/net/ethernet/dec/tulip/de4x5.c                                |   20 +-
 drivers/net/ethernet/dec/tulip/dmfe.c                                 |    2 +-
 drivers/net/ethernet/dec/tulip/uli526x.c                              |    2 +-
 drivers/net/ethernet/emulex/benet/be.h                                |    1 +
 drivers/net/ethernet/emulex/benet/be_ethtool.c                        |   12 +-
 drivers/net/ethernet/emulex/benet/be_main.c                           |   69 +-
 drivers/net/ethernet/freescale/fec.h                                  |  237 +--
 drivers/net/ethernet/freescale/fec_main.c                             |  137 +-
 drivers/net/ethernet/freescale/gianfar.c                              |  147 +-
 drivers/net/ethernet/freescale/gianfar.h                              |   38 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c                      |    7 +-
 drivers/net/ethernet/hp/hp100.c                                       |    7 +-
 drivers/net/ethernet/ibm/emac/core.c                                  |   24 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c                         |   10 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                            |   19 +-
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c                      |   12 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c                         |   17 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c                          |   10 +-
 drivers/net/ethernet/intel/i40e/i40e.h                                |    6 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c                         |   30 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.h                         |   15 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h                     | 2184 ++++++++++++------------
 drivers/net/ethernet/intel/i40e/i40e_common.c                         |  101 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.c                            |  252 ++-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h                            |    5 +
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c                         |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c                        |  129 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                        |  127 +-
 drivers/net/ethernet/intel/i40e/i40e_fcoe.c                           |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c                           |  483 ++++--
 drivers/net/ethernet/intel/i40e/i40e_nvm.c                            |  198 ++-
 drivers/net/ethernet/intel/i40e/i40e_prototype.h                      |    9 +
 drivers/net/ethernet/intel/i40e/i40e_ptp.c                            |   44 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                           |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h                           |    5 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h                           |   62 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl.h                       |    1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                    |   18 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h                    |    1 +
 drivers/net/ethernet/intel/i40evf/i40e_adminq.c                       |   23 +-
 drivers/net/ethernet/intel/i40evf/i40e_adminq.h                       |   15 +-
 drivers/net/ethernet/intel/i40evf/i40e_adminq_cmd.h                   | 2136 ++++++++++++------------
 drivers/net/ethernet/intel/i40evf/i40e_common.c                       |    1 +
 drivers/net/ethernet/intel/i40evf/i40e_txrx.h                         |    5 +-
 drivers/net/ethernet/intel/i40evf/i40e_type.h                         |    9 +-
 drivers/net/ethernet/intel/i40evf/i40e_virtchnl.h                     |    1 +
 drivers/net/ethernet/intel/i40evf/i40evf.h                            |    3 +-
 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c                    |   47 +-
 drivers/net/ethernet/intel/i40evf/i40evf_main.c                       |  143 +-
 drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c                   |  100 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c                          |   16 +-
 drivers/net/ethernet/intel/igb/igb_main.c                             |   56 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c                           |    6 +-
 drivers/net/ethernet/intel/ixgbe/Makefile                             |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                              |   45 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                       |  183 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h                       |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.c                          |    8 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c                       |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c                      |   46 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                          |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                         |  555 ++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.c                          |    4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                          |  275 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h                          |   10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                        |  134 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                         |  329 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c                         |   85 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.h                         |   39 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c                         | 1432 ++++++++++++++++
 drivers/net/ethernet/intel/ixgbevf/defines.h                          |    2 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h                          |   43 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c                     |  757 ++++++---
 drivers/net/ethernet/intel/ixgbevf/vf.c                               |   10 +
 drivers/net/ethernet/intel/ixgbevf/vf.h                               |    2 +
 drivers/net/ethernet/marvell/mvneta.c                                 |    8 +-
 drivers/net/ethernet/marvell/pxa168_eth.c                             |  258 ++-
 drivers/net/ethernet/marvell/skge.c                                   |    3 +-
 drivers/net/ethernet/marvell/sky2.c                                   |   20 +-
 drivers/net/ethernet/mellanox/mlx4/alloc.c                            |  425 ++++-
 drivers/net/ethernet/mellanox/mlx4/cmd.c                              |   89 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c                               |   50 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c                         |   46 -
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                       |  557 ++++++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c                          |   12 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                        |  158 +-
 drivers/net/ethernet/mellanox/mlx4/en_port.c                          |   26 +-
 drivers/net/ethernet/mellanox/mlx4/en_port.h                          |   35 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                            |  303 ++--
 drivers/net/ethernet/mellanox/mlx4/en_selftest.c                      |   12 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                            |   18 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c                               |   24 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                               |  571 ++++++-
 drivers/net/ethernet/mellanox/mlx4/fw.h                               |   57 +-
 drivers/net/ethernet/mellanox/mlx4/main.c                             |  541 +++++-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                              |   21 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                             |  118 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                          |   29 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c                               |   10 +-
 drivers/net/ethernet/mellanox/mlx4/port.c                             |  156 ++
 drivers/net/ethernet/mellanox/mlx4/profile.c                          |   19 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c                               |  303 +++-
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c                 |   26 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                          |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c                        |   15 +-
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c                   |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c                        |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c                         |    1 +
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                      |   15 +-
 drivers/net/ethernet/natsemi/macsonic.c                               |    4 -
 drivers/net/ethernet/pasemi/pasemi_mac.c                              |    6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                      |   11 +-
 drivers/net/ethernet/realtek/8139cp.c                                 |    2 +-
 drivers/net/ethernet/realtek/8139too.c                                |   22 +-
 drivers/net/ethernet/realtek/atp.h                                    |  246 +--
 drivers/net/ethernet/realtek/r8169.c                                  |   47 +-
 drivers/net/ethernet/renesas/sh_eth.c                                 |  124 +-
 drivers/net/ethernet/renesas/sh_eth.h                                 |    5 +-
 drivers/net/ethernet/rocker/Kconfig                                   |   27 +
 drivers/net/ethernet/rocker/Makefile                                  |    5 +
 drivers/net/ethernet/rocker/rocker.c                                  | 4375 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/rocker/rocker.h                                  |  428 +++++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c                   |    3 -
 drivers/net/ethernet/sfc/ef10.c                                       |    5 +
 drivers/net/ethernet/sfc/efx.c                                        |   24 +-
 drivers/net/ethernet/sfc/ethtool.c                                    |   18 +-
 drivers/net/ethernet/sfc/falcon.c                                     |   10 +
 drivers/net/ethernet/sfc/farch.c                                      |   27 +-
 drivers/net/ethernet/sfc/mcdi.c                                       |    2 +-
 drivers/net/ethernet/sfc/net_driver.h                                 |   19 +-
 drivers/net/ethernet/sfc/nic.h                                        |  112 +-
 drivers/net/ethernet/sfc/siena.c                                      |    8 +-
 drivers/net/ethernet/sfc/siena_sriov.c                                |  269 +--
 drivers/net/ethernet/smsc/smsc911x.c                                  |   10 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig                           |   72 +-
 drivers/net/ethernet/stmicro/stmmac/Makefile                          |   17 +-
 drivers/net/ethernet/stmicro/stmmac/common.h                          |   13 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c                     |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c                   |    2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c                       |   17 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c                     |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c                   |    4 -
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                          |   77 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c                  |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                     |  211 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c                      |  135 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c                 |   95 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h                 |   28 +
 drivers/net/ethernet/sun/cassini.c                                    |    3 +-
 drivers/net/ethernet/sun/niu.c                                        |    9 +-
 drivers/net/ethernet/sun/sunvnet.c                                    |  747 +++++++--
 drivers/net/ethernet/sun/sunvnet.h                                    |   17 +-
 drivers/net/ethernet/ti/Kconfig                                       |    8 +-
 drivers/net/ethernet/wiznet/w5100.c                                   |    6 +-
 drivers/net/ethernet/wiznet/w5300.c                                   |    6 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c                           |    3 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                         |    3 +-
 drivers/net/fddi/defxx.c                                              |  187 ++-
 drivers/net/fddi/defxx.h                                              |    4 +-
 drivers/net/hamradio/6pack.c                                          |    3 +-
 drivers/net/hyperv/netvsc.c                                           |   10 +-
 drivers/net/hyperv/netvsc_drv.c                                       |    9 +-
 drivers/net/hyperv/rndis_filter.c                                     |   15 +-
 drivers/net/ieee802154/Kconfig                                        |   10 -
 drivers/net/ieee802154/Makefile                                       |    1 -
 drivers/net/ieee802154/at86rf230.c                                    |  445 ++---
 drivers/net/ieee802154/cc2520.c                                       |   73 +-
 drivers/net/ieee802154/fakehard.c                                     |  430 -----
 drivers/net/ieee802154/fakelb.c                                       |   91 +-
 drivers/net/ieee802154/mrf24j40.c                                     |  104 +-
 drivers/net/ipvlan/Makefile                                           |    7 +
 drivers/net/ipvlan/ipvlan.h                                           |  121 ++
 drivers/net/ipvlan/ipvlan_core.c                                      |  607 +++++++
 drivers/net/ipvlan/ipvlan_main.c                                      |  795 +++++++++
 drivers/net/irda/act200l-sir.c                                        |   11 +-
 drivers/net/irda/actisys-sir.c                                        |    3 +-
 drivers/net/irda/ali-ircc.c                                           |  263 ++-
 drivers/net/irda/donauboe.c                                           |   96 +-
 drivers/net/irda/girbil-sir.c                                         |   14 +-
 drivers/net/irda/irda-usb.c                                           |  142 +-
 drivers/net/irda/irtty-sir.c                                          |   18 +-
 drivers/net/irda/litelink-sir.c                                       |    8 -
 drivers/net/irda/ma600-sir.c                                          |   20 +-
 drivers/net/irda/mcp2120-sir.c                                        |   14 +-
 drivers/net/irda/mcs7780.c                                            |   53 +-
 drivers/net/irda/nsc-ircc.c                                           |  229 ++-
 drivers/net/irda/old_belkin-sir.c                                     |    8 -
 drivers/net/irda/sir_dev.c                                            |   79 +-
 drivers/net/irda/sir_dongle.c                                         |    4 +-
 drivers/net/irda/smsc-ircc2.c                                         |  255 +--
 drivers/net/irda/tekram-sir.c                                         |   15 +-
 drivers/net/irda/toim3232-sir.c                                       |   12 +-
 drivers/net/irda/via-ircc.c                                           |  175 +-
 drivers/net/irda/vlsi_ir.c                                            |  145 +-
 drivers/net/irda/vlsi_ir.h                                            |    3 +-
 drivers/net/irda/w83977af_ir.c                                        |   77 +-
 drivers/net/macvlan.c                                                 |   19 +-
 drivers/net/macvtap.c                                                 |  140 +-
 drivers/net/phy/Kconfig                                               |    2 +-
 drivers/net/phy/amd-xgbe-phy.c                                        |   18 +-
 drivers/net/phy/amd.c                                                 |   17 +-
 drivers/net/phy/at803x.c                                              |   14 +-
 drivers/net/phy/bcm63xx.c                                             |   15 +-
 drivers/net/phy/bcm7xxx.c                                             |  151 +-
 drivers/net/phy/bcm87xx.c                                             |   14 +-
 drivers/net/phy/broadcom.c                                            |   15 +-
 drivers/net/phy/cicada.c                                              |   15 +-
 drivers/net/phy/davicom.c                                             |   15 +-
 drivers/net/phy/et1011c.c                                             |   17 +-
 drivers/net/phy/icplus.c                                              |   15 +-
 drivers/net/phy/lxt.c                                                 |   15 +-
 drivers/net/phy/marvell.c                                             |   67 +-
 drivers/net/phy/micrel.c                                              |  344 ++--
 drivers/net/phy/national.c                                            |   17 +-
 drivers/net/phy/qsemi.c                                               |   17 +-
 drivers/net/phy/realtek.c                                             |   13 +-
 drivers/net/phy/smsc.c                                                |   14 +-
 drivers/net/phy/spi_ks8995.c                                          |    4 +-
 drivers/net/phy/ste10Xp.c                                             |   15 +-
 drivers/net/phy/vitesse.c                                             |   14 +-
 drivers/net/ppp/ppp_generic.c                                         |    4 +-
 drivers/net/ppp/pppoe.c                                               |    4 +-
 drivers/net/team/team.c                                               |    3 +
 drivers/net/tun.c                                                     |  134 +-
 drivers/net/usb/asix_devices.c                                        |    3 +-
 drivers/net/usb/cdc-phonet.c                                          |    6 +-
 drivers/net/usb/cdc_ether.c                                           |   19 +-
 drivers/net/usb/cdc_mbim.c                                            |    2 +-
 drivers/net/usb/hso.c                                                 |    3 +-
 drivers/net/usb/r8152.c                                               |  229 +--
 drivers/net/usb/rtl8150.c                                             |    3 +-
 drivers/net/usb/smsc95xx.c                                            |    6 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                                     |    9 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c                                 |   15 +-
 drivers/net/vxlan.c                                                   |   43 +-
 drivers/net/wireless/ath/ath.h                                        |   13 +-
 drivers/net/wireless/ath/ath10k/ce.c                                  |   92 +-
 drivers/net/wireless/ath/ath10k/ce.h                                  |   21 +-
 drivers/net/wireless/ath/ath10k/core.c                                |  154 +-
 drivers/net/wireless/ath/ath10k/core.h                                |  100 +-
 drivers/net/wireless/ath/ath10k/debug.c                               | 1154 ++++++++++---
 drivers/net/wireless/ath/ath10k/debug.h                               |   46 +-
 drivers/net/wireless/ath/ath10k/hif.h                                 |   53 +-
 drivers/net/wireless/ath/ath10k/htc.c                                 |   13 +-
 drivers/net/wireless/ath/ath10k/htt.h                                 |    9 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c                              | 1256 +++++++-------
 drivers/net/wireless/ath/ath10k/htt_tx.c                              |   11 +-
 drivers/net/wireless/ath/ath10k/hw.h                                  |   32 +-
 drivers/net/wireless/ath/ath10k/mac.c                                 |  746 ++++++---
 drivers/net/wireless/ath/ath10k/mac.h                                 |    6 +
 drivers/net/wireless/ath/ath10k/pci.c                                 |  579 ++++---
 drivers/net/wireless/ath/ath10k/spectral.c                            |   34 +-
 drivers/net/wireless/ath/ath10k/spectral.h                            |    8 +-
 drivers/net/wireless/ath/ath10k/trace.h                               |  207 ++-
 drivers/net/wireless/ath/ath10k/txrx.c                                |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.c                                 | 1179 +++++++------
 drivers/net/wireless/ath/ath10k/wmi.h                                 |  401 ++---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c                         |    6 +-
 drivers/net/wireless/ath/ath5k/qcu.c                                  |    8 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                            |    4 +-
 drivers/net/wireless/ath/ath6kl/common.h                              |    2 +-
 drivers/net/wireless/ath/ath6kl/debug.c                               |   28 +-
 drivers/net/wireless/ath/ath6kl/debug.h                               |   13 +-
 drivers/net/wireless/ath/ath6kl/usb.c                                 |    9 -
 drivers/net/wireless/ath/ath9k/Kconfig                                |    7 +
 drivers/net/wireless/ath/ath9k/Makefile                               |    9 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c                           |    7 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c                         |   42 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c                           |    8 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c                           |    9 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c                         |   11 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                        |   56 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                            |   54 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c                           |    8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                           |  181 +-
 drivers/net/wireless/ath/ath9k/ar9003_rtt.h                           |   36 +
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h                      |  498 +++++-
 drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h                  |    8 +-
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h                  |  144 +-
 drivers/net/wireless/ath/ath9k/ath9k.h                                |   27 +-
 drivers/net/wireless/ath/ath9k/beacon.c                               |    5 +-
 drivers/net/wireless/ath/ath9k/calib.c                                |    6 +-
 drivers/net/wireless/ath/ath9k/calib.h                                |    2 +-
 drivers/net/wireless/ath/ath9k/channel.c                              |  338 +++-
 drivers/net/wireless/ath/ath9k/{spectral.c => common-spectral.c}      |  165 +-
 drivers/net/wireless/ath/ath9k/{spectral.h => common-spectral.h}      |   29 +-
 drivers/net/wireless/ath/ath9k/common.c                               |    2 +-
 drivers/net/wireless/ath/ath9k/common.h                               |    1 +
 drivers/net/wireless/ath/ath9k/debug.c                                |   60 +-
 drivers/net/wireless/ath/ath9k/debug.h                                |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_def.c                           |   31 +-
 drivers/net/wireless/ath/ath9k/gpio.c                                 |    9 +-
 drivers/net/wireless/ath/ath9k/htc.h                                  |    5 +
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c                        |    6 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                         |   25 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c                         |   13 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                         |   16 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h                               |    7 +-
 drivers/net/wireless/ath/ath9k/hw.c                                   |   98 +-
 drivers/net/wireless/ath/ath9k/hw.h                                   |   43 +-
 drivers/net/wireless/ath/ath9k/init.c                                 |   73 +-
 drivers/net/wireless/ath/ath9k/link.c                                 |   12 +-
 drivers/net/wireless/ath/ath9k/mac.c                                  |    9 +-
 drivers/net/wireless/ath/ath9k/mac.h                                  |    2 +-
 drivers/net/wireless/ath/ath9k/main.c                                 |  361 ++--
 drivers/net/wireless/ath/ath9k/pci.c                                  |   10 +-
 drivers/net/wireless/ath/ath9k/recv.c                                 |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h                                  |   38 +-
 drivers/net/wireless/ath/ath9k/tx99.c                                 |    4 +-
 drivers/net/wireless/ath/ath9k/xmit.c                                 |   37 +-
 drivers/net/wireless/ath/carl9170/phy.c                               |    4 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c                       |    4 +-
 drivers/net/wireless/ath/wcn36xx/main.c                               |    7 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c                           |    5 +-
 drivers/net/wireless/ath/wil6210/debug.c                              |   17 +
 drivers/net/wireless/ath/wil6210/debugfs.c                            |    8 +-
 drivers/net/wireless/ath/wil6210/fw.c                                 |    1 -
 drivers/net/wireless/ath/wil6210/fw_inc.c                             |    4 +-
 drivers/net/wireless/ath/wil6210/interrupt.c                          |   30 +-
 drivers/net/wireless/ath/wil6210/main.c                               |  136 +-
 drivers/net/wireless/ath/wil6210/netdev.c                             |    2 +-
 drivers/net/wireless/ath/wil6210/txrx.c                               |   18 +-
 drivers/net/wireless/ath/wil6210/txrx.h                               |    4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h                            |   26 +-
 drivers/net/wireless/ath/wil6210/wmi.c                                |   10 +-
 drivers/net/wireless/b43/main.c                                       |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                      |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c                        |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c                      |   51 +-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c                      |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_bus.h => bus.h}          |   11 +-
 drivers/net/wireless/brcm80211/brcmfmac/{wl_cfg80211.c => cfg80211.c} |  338 +++-
 drivers/net/wireless/brcm80211/brcmfmac/{wl_cfg80211.h => cfg80211.h} |   11 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c                        |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/common.c                      |  168 ++
 drivers/net/wireless/brcm80211/brcmfmac/commonring.c                  |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_linux.c => core.c}       |   47 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd.h => core.h}             |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.c => debug.c}        |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.h => debug.h}        |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c                  |  400 -----
 drivers/net/wireless/brcm80211/brcmfmac/feature.c                     |   34 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.h                     |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c                    |    5 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c                    |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c                        |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c                        |  102 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h                  |   95 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c                    |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c                      |   19 +-
 drivers/net/wireless/brcm80211/brcmfmac/of.c                          |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                         |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c                        |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.c                       |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_sdio.c => sdio.c}        |   55 +-
 drivers/net/wireless/brcm80211/brcmfmac/{sdio_host.h => sdio.h}       |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c                  |   15 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                         |  142 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h                     |   75 -
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c                      |   21 +-
 drivers/net/wireless/brcm80211/brcmsmac/debug.c                       |  180 +-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c                 |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c                        |   29 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c                       |   16 +
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h                  |    2 +
 drivers/net/wireless/brcm80211/include/brcmu_utils.h                  |    2 +
 drivers/net/wireless/cw1200/scan.c                                    |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c                                |    2 +-
 drivers/net/wireless/ipw2x00/libipw.h                                 |    5 -
 drivers/net/wireless/ipw2x00/libipw_module.c                          |   15 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c                              |   21 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                              |    2 +-
 drivers/net/wireless/iwlegacy/4965.h                                  |    5 +-
 drivers/net/wireless/iwlwifi/Kconfig                                  |    1 +
 drivers/net/wireless/iwlwifi/dvm/commands.h                           |   31 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c                                |   51 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                           |    1 +
 drivers/net/wireless/iwlwifi/iwl-7000.c                               |   48 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c                               |   28 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                             |   23 +
 drivers/net/wireless/iwlwifi/iwl-csr.h                                |   39 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h                              |    3 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                                |  198 ++-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c                       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h                      |    3 +
 drivers/net/wireless/iwlwifi/iwl-fw-file.h                            |  308 ++++
 drivers/net/wireless/iwlwifi/iwl-fw.h                                 |  242 +--
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                          |    5 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                            |    3 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h                               |   10 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h                              |   25 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c                               |   29 +-
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c                        |   33 +-
 drivers/net/wireless/iwlwifi/mvm/constants.h                          |    7 +
 drivers/net/wireless/iwlwifi/mvm/d3.c                                 |  618 ++++---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                            |  200 ++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h                        |    9 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h                          |    6 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h                       |    2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h                        |  297 ++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                             |  179 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c                                 |   74 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                           |  106 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                           |  543 ++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h                                |  154 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c                                |   31 +-
 drivers/net/wireless/iwlwifi/mvm/offloading.c                         |    2 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c                                |   87 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                           |    4 +-
 drivers/net/wireless/iwlwifi/mvm/power.c                              |   40 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c                                 |  123 +-
 drivers/net/wireless/iwlwifi/mvm/rs.h                                 |    2 +
 drivers/net/wireless/iwlwifi/mvm/rx.c                                 |  150 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c                               |  786 ++++++++-
 drivers/net/wireless/iwlwifi/mvm/sta.c                                |  303 +++-
 drivers/net/wireless/iwlwifi/mvm/sta.h                                |    5 +
 drivers/net/wireless/iwlwifi/mvm/tdls.c                               |  569 ++++++-
 drivers/net/wireless/iwlwifi/mvm/time-event.c                         |  146 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h                         |    4 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c                                 |   75 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c                                 |   45 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c                              |   37 +
 drivers/net/wireless/iwlwifi/pcie/drv.c                               |   20 +
 drivers/net/wireless/iwlwifi/pcie/trans.c                             |  404 +++--
 drivers/net/wireless/iwlwifi/pcie/tx.c                                |   99 +-
 drivers/net/wireless/mac80211_hwsim.c                                 |  660 +++++++-
 drivers/net/wireless/mac80211_hwsim.h                                 |   28 +-
 drivers/net/wireless/mwifiex/11n.c                                    |    4 +
 drivers/net/wireless/mwifiex/11n.h                                    |    4 +
 drivers/net/wireless/mwifiex/11n_rxreorder.c                          |    6 +
 drivers/net/wireless/mwifiex/Kconfig                                  |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c                               |  130 +-
 drivers/net/wireless/mwifiex/decl.h                                   |   19 +
 drivers/net/wireless/mwifiex/fw.h                                     |   34 +-
 drivers/net/wireless/mwifiex/init.c                                   |   22 +-
 drivers/net/wireless/mwifiex/join.c                                   |    4 +-
 drivers/net/wireless/mwifiex/main.c                                   |  123 +-
 drivers/net/wireless/mwifiex/main.h                                   |   63 +-
 drivers/net/wireless/mwifiex/scan.c                                   |   78 +-
 drivers/net/wireless/mwifiex/sdio.c                                   |    2 +
 drivers/net/wireless/mwifiex/sdio.h                                   |    7 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c                            |    2 +-
 drivers/net/wireless/mwifiex/sta_event.c                              |   14 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                              |    4 +-
 drivers/net/wireless/mwifiex/sta_rx.c                                 |    3 +
 drivers/net/wireless/mwifiex/sta_tx.c                                 |    6 +
 drivers/net/wireless/mwifiex/tdls.c                                   |  288 ++++
 drivers/net/wireless/mwifiex/txrx.c                                   |   35 +-
 drivers/net/wireless/mwifiex/uap_cmd.c                                |    2 +-
 drivers/net/wireless/mwifiex/uap_event.c                              |    5 +
 drivers/net/wireless/mwifiex/uap_txrx.c                               |   11 +-
 drivers/net/wireless/mwifiex/usb.c                                    |   51 +-
 drivers/net/wireless/mwifiex/usb.h                                    |    3 +
 drivers/net/wireless/mwifiex/util.c                                   |   38 +
 drivers/net/wireless/mwifiex/wmm.c                                    |   42 +-
 drivers/net/wireless/mwl8k.c                                          |    7 +-
 drivers/net/wireless/p54/net2280.h                                    |  451 -----
 drivers/net/wireless/p54/p54usb.h                                     |   13 +-
 drivers/net/wireless/rt2x00/rt2500usb.c                               |   18 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                               |   45 +-
 drivers/net/wireless/rt2x00/rt2x00.h                                  |   12 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                               |    7 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c                               |   28 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h                               |   41 +-
 drivers/net/wireless/rt2x00/rt73usb.c                                 |    2 +-
 drivers/net/wireless/rtlwifi/core.c                                   |   21 +-
 drivers/net/wireless/rtlwifi/pci.c                                    |   20 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                           |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c                           |    3 +
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c                          |   24 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h                          |    2 +
 drivers/net/wireless/rtlwifi/rtl8192ee/Makefile                       |    5 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/Makefile                       |    3 -
 drivers/net/wireless/rtlwifi/rtl8723be/Makefile                       |    3 -
 drivers/net/wireless/rtlwifi/rtl8821ae/Makefile                       |    3 -
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c                           |    5 +-
 drivers/net/wireless/rtlwifi/rtl8821ae/phy.c                          |   12 +-
 drivers/net/wireless/ti/wl1251/main.c                                 |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.c                                  |   15 +-
 drivers/net/wireless/ti/wlcore/cmd.h                                  |    2 -
 drivers/net/wireless/ti/wlcore/event.c                                |    5 +-
 drivers/net/wireless/ti/wlcore/main.c                                 |   23 +-
 drivers/net/xen-netback/interface.c                                   |    2 +-
 drivers/net/xen-netback/netback.c                                     |   28 +-
 drivers/net/xen-netback/xenbus.c                                      |   24 +-
 drivers/net/xen-netfront.c                                            |  261 +--
 drivers/nfc/pn544/i2c.c                                               |    2 +-
 drivers/nfc/st21nfca/i2c.c                                            |   41 +-
 drivers/nfc/st21nfca/st21nfca.c                                       |   32 +-
 drivers/nfc/st21nfca/st21nfca.h                                       |    2 -
 drivers/nfc/st21nfca/st21nfca_dep.c                                   |   47 +-
 drivers/nfc/st21nfca/st21nfca_dep.h                                   |    4 +-
 drivers/nfc/st21nfcb/i2c.c                                            |   39 +-
 drivers/nfc/st21nfcb/ndlc.c                                           |    2 +-
 drivers/of/fdt.c                                                      |    2 -
 drivers/pci/host/pci-tegra.c                                          |   28 +-
 drivers/pci/msi.c                                                     |   26 +
 drivers/s390/net/Kconfig                                              |    2 +-
 drivers/s390/net/ctcm_sysfs.c                                         |    8 +-
 drivers/s390/net/lcs.c                                                |   11 +-
 drivers/s390/net/qeth_core.h                                          |   16 -
 drivers/s390/net/qeth_core_main.c                                     |   24 +-
 drivers/s390/net/qeth_l2_main.c                                       |    2 +-
 drivers/s390/net/qeth_l3.h                                            |    4 -
 drivers/s390/net/qeth_l3_main.c                                       |   10 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                                     |    7 +
 drivers/scsi/csiostor/csio_attr.c                                     |    8 +-
 drivers/scsi/csiostor/csio_hw.c                                       |   58 +-
 drivers/scsi/csiostor/csio_hw.h                                       |    1 -
 drivers/scsi/csiostor/csio_hw_chip.h                                  |   49 +-
 drivers/scsi/csiostor/csio_hw_t4.c                                    |   15 +-
 drivers/scsi/csiostor/csio_hw_t5.c                                    |   21 +-
 drivers/scsi/csiostor/csio_init.c                                     |   78 +-
 drivers/scsi/csiostor/csio_lnode.c                                    |   20 +-
 drivers/scsi/csiostor/csio_mb.c                                       |  343 ++--
 drivers/scsi/csiostor/csio_mb.h                                       |   12 +-
 drivers/scsi/csiostor/csio_scsi.c                                     |   26 +-
 drivers/scsi/csiostor/csio_wr.h                                       |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                                    |  113 +-
 drivers/scsi/fcoe/fcoe.c                                              |    6 +-
 drivers/scsi/scsi_devinfo.c                                           |    1 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                                      |   15 +-
 drivers/scsi/ufs/ufshcd.c                                             |  104 +-
 drivers/scsi/ufs/ufshcd.h                                             |    2 -
 drivers/spi/spi-dw.c                                                  |    6 +-
 drivers/spi/spi-sirf.c                                                |    4 +-
 drivers/spi/spi.c                                                     |    6 +-
 drivers/ssb/pcihost_wrapper.c                                         |   33 +-
 drivers/staging/rtl8188eu/core/rtw_cmd.c                              |   22 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c                         |   12 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c                        |    2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                           |    1 +
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c                     |    4 +-
 drivers/staging/vt6656/main_usb.c                                     |    7 +-
 drivers/target/iscsi/iscsi_target_util.c                              |   12 +-
 drivers/thermal/cpu_cooling.c                                         |   37 +-
 drivers/thermal/samsung/exynos_thermal_common.c                       |    9 +-
 drivers/thermal/st/st_thermal.c                                       |    3 +
 drivers/tty/serial/of_serial.c                                        |   27 -
 drivers/usb/core/quirks.c                                             |    3 +
 drivers/usb/dwc3/ep0.c                                                |    8 +-
 drivers/usb/gadget/function/f_phonet.c                                |    6 +-
 drivers/usb/host/xhci-hub.c                                           |    5 +-
 drivers/usb/host/xhci-pci.c                                           |    2 +-
 drivers/usb/host/xhci-plat.c                                          |   10 +-
 drivers/usb/host/xhci-ring.c                                          |   43 +-
 drivers/usb/host/xhci.c                                               |  107 +-
 drivers/usb/host/xhci.h                                               |    2 +-
 drivers/usb/serial/cp210x.c                                           |    1 +
 drivers/usb/serial/ftdi_sio.c                                         |   33 +
 drivers/usb/serial/ftdi_sio_ids.h                                     |   39 +-
 drivers/usb/serial/keyspan.c                                          |   97 +-
 drivers/usb/serial/ssu100.c                                           |   11 +-
 drivers/usb/storage/unusual_uas.h                                     |    7 +
 drivers/vhost/net.c                                                   |    8 +-
 fs/afs/rxrpc.c                                                        |   14 +-
 fs/aio.c                                                              |   21 +-
 fs/btrfs/compression.c                                                |   33 +-
 fs/btrfs/compression.h                                                |    4 +-
 fs/btrfs/lzo.c                                                        |   15 +
 fs/btrfs/zlib.c                                                       |   20 +-
 fs/fat/namei_vfat.c                                                   |   20 +-
 fs/jbd2/journal.c                                                     |    5 +-
 fs/nfsd/nfs4callback.c                                                |    8 +-
 fs/nfsd/nfs4state.c                                                   |    6 +-
 fs/nfsd/nfsd.h                                                        |    9 +-
 include/asm-generic/hash.h                                            |    9 -
 include/dt-bindings/clock/qcom,mmcc-apq8084.h                         |    2 +-
 include/linux/ath9k_platform.h                                        |    3 +
 include/linux/bcma/bcma.h                                             |    2 +
 include/linux/bcma/bcma_driver_mips.h                                 |    4 +-
 include/linux/bpf.h                                                   |   11 +-
 include/linux/can/dev.h                                               |    3 +
 include/linux/clk-provider.h                                          |    1 -
 include/linux/etherdevice.h                                           |   12 +
 include/linux/ethtool.h                                               |   42 +-
 include/linux/filter.h                                                |    1 +
 include/linux/hash.h                                                  |   35 -
 include/linux/hyperv.h                                                |    2 +
 include/linux/ieee80211.h                                             |   71 +-
 include/{net => linux}/ieee802154.h                                   |   61 +-
 include/linux/if_bridge.h                                             |   31 +
 include/linux/if_vlan.h                                               |  107 +-
 include/linux/iio/events.h                                            |    2 +-
 include/linux/ipv6.h                                                  |   11 +-
 include/linux/kvm_host.h                                              |    2 +-
 include/linux/marvell_phy.h                                           |    1 +
 include/linux/micrel_phy.h                                            |    1 -
 include/linux/mlx4/cmd.h                                              |   31 +
 include/linux/mlx4/device.h                                           |  127 +-
 include/linux/mlx4/qp.h                                               |    4 +-
 include/linux/mlx5/device.h                                           |    8 -
 include/linux/mlx5/driver.h                                           |    8 -
 include/linux/netdev_features.h                                       |    9 +-
 include/linux/netdevice.h                                             |  134 +-
 include/linux/nl802154.h                                              |    4 -
 include/linux/pci.h                                                   |    1 +
 include/linux/phy.h                                                   |   26 +
 include/linux/platform_data/bcmgenet.h                                |   18 +
 include/linux/platform_data/st21nfca.h                                |    1 -
 include/linux/platform_data/st21nfcb.h                                |    1 -
 include/linux/pxa168_eth.h                                            |    3 +
 include/linux/rculist.h                                               |    9 +
 include/linux/rhashtable.h                                            |   15 +-
 include/linux/rtnetlink.h                                             |   14 +-
 include/linux/skbuff.h                                                |  188 ++-
 include/linux/socket.h                                                |   24 +-
 include/linux/syscalls.h                                              |    6 +-
 include/linux/tcp.h                                                   |    8 +-
 include/linux/uio.h                                                   |    1 -
 include/linux/vmw_vmci_api.h                                          |    5 +-
 include/net/6lowpan.h                                                 |   12 +-
 include/net/af_ieee802154.h                                           |    4 -
 include/net/af_vsock.h                                                |    6 +-
 include/net/bluetooth/hci.h                                           |   68 +-
 include/net/bluetooth/hci_core.h                                      |   78 +-
 include/net/bluetooth/l2cap.h                                         |   50 +-
 include/net/bluetooth/mgmt.h                                          |   24 +-
 {drivers/net/bonding => include/net}/bond_3ad.h                       |    6 +-
 {drivers/net/bonding => include/net}/bond_alb.h                       |    6 +-
 {drivers/net/bonding => include/net}/bond_options.h                   |    6 +-
 {drivers/net/bonding => include/net}/bonding.h                        |   18 +-
 include/net/cfg80211.h                                                |  241 ++-
 include/net/cfg802154.h                                               |  161 ++
 include/net/checksum.h                                                |   16 +
 include/net/compat.h                                                  |    5 +-
 include/net/dsa.h                                                     |   33 +
 include/net/fou.h                                                     |   19 +
 include/net/gue.h                                                     |  103 +-
 include/net/ieee802154_netdev.h                                       |   18 +-
 include/net/inet6_hashtables.h                                        |   10 +
 include/net/inet_common.h                                             |    2 +
 include/net/ip6_tunnel.h                                              |    3 +-
 include/net/ip_fib.h                                                  |    4 +-
 include/net/ip_tunnels.h                                              |   16 +
 include/net/ipx.h                                                     |    5 +-
 include/net/irda/irda.h                                               |   15 -
 include/net/irda/irlap.h                                              |    2 +-
 include/net/irda/parameters.h                                         |    6 +-
 include/net/llc_c_st.h                                                |    4 +-
 include/net/llc_s_st.h                                                |    2 +-
 include/net/mac80211.h                                                |  319 +++-
 include/net/mac802154.h                                               |  158 +-
 include/net/mpls.h                                                    |   39 +
 include/net/neighbour.h                                               |   14 +-
 include/net/netfilter/nf_conntrack.h                                  |   15 +-
 include/net/netfilter/nf_nat_redirect.h                               |   12 +
 include/net/netfilter/nf_tables_bridge.h                              |    7 +
 include/net/netfilter/nft_redir.h                                     |   21 +
 include/net/netlink.h                                                 |   10 +
 include/net/netns/xfrm.h                                              |    4 +-
 include/net/nfc/digital.h                                             |   13 +
 include/net/nfc/hci.h                                                 |    4 +
 include/net/nfc/nci.h                                                 |   37 +-
 include/net/nfc/nci_core.h                                            |    9 +
 include/net/nfc/nfc.h                                                 |    2 +
 include/net/nl802154.h                                                |  226 ++-
 include/net/ping.h                                                    |    2 +-
 include/net/regulatory.h                                              |   12 +
 include/net/sch_generic.h                                             |    1 -
 include/net/sctp/sm.h                                                 |    2 +-
 include/net/sctp/structs.h                                            |    7 +-
 include/net/sock.h                                                    |   45 +-
 include/net/switchdev.h                                               |   37 +
 include/net/tc_act/tc_vlan.h                                          |   27 +
 include/net/tcp.h                                                     |   25 +-
 include/net/udplite.h                                                 |   10 +-
 include/net/wpan-phy.h                                                |  105 --
 include/sound/pcm.h                                                   |    2 +
 include/uapi/asm-generic/socket.h                                     |    5 +
 include/uapi/linux/Kbuild                                             |   91 +-
 include/uapi/linux/bpf.h                                              |   14 +-
 include/uapi/linux/can/error.h                                        |    1 +
 include/uapi/linux/ethtool.h                                          |   28 +-
 include/uapi/linux/if_bridge.h                                        |    1 +
 include/uapi/linux/if_link.h                                          |   18 +
 include/uapi/linux/if_tunnel.h                                        |    1 +
 include/uapi/linux/ipv6.h                                             |    1 +
 include/uapi/linux/neighbour.h                                        |    6 +-
 include/uapi/linux/net_tstamp.h                                       |    3 +-
 include/uapi/linux/netfilter/ipset/ip_set.h                           |    8 +-
 include/uapi/linux/netfilter/nf_tables.h                              |   18 +
 include/uapi/linux/netfilter/xt_set.h                                 |   13 +-
 include/uapi/linux/nfc.h                                              |   23 +-
 include/uapi/linux/nl80211.h                                          |  147 +-
 include/uapi/linux/openvswitch.h                                      |   53 +-
 include/uapi/linux/rtnetlink.h                                        |    1 +
 include/uapi/linux/snmp.h                                             |    5 +
 include/uapi/linux/tc_act/Kbuild                                      |    1 +
 include/uapi/linux/tc_act/tc_vlan.h                                   |   35 +
 include/uapi/linux/tipc_netlink.h                                     |  244 +++
 include/uapi/sound/asound.h                                           |    4 +-
 ipc/sem.c                                                             |   15 +-
 kernel/bpf/Makefile                                                   |    2 +-
 kernel/bpf/arraymap.c                                                 |  156 ++
 kernel/bpf/hashtab.c                                                  |  367 +++++
 kernel/bpf/helpers.c                                                  |   89 +
 kernel/bpf/syscall.c                                                  |    6 +-
 kernel/bpf/test_stub.c                                                |   56 +-
 kernel/bpf/verifier.c                                                 |  171 +-
 kernel/sched/core.c                                                   |    8 +-
 lib/Makefile                                                          |    2 +-
 lib/genalloc.c                                                        |    1 +
 lib/hash.c                                                            |   39 -
 lib/iovec.c                                                           |   25 -
 lib/rhashtable.c                                                      |   88 +-
 lib/show_mem.c                                                        |    2 +-
 lib/test_bpf.c                                                        |   53 +-
 mm/frontswap.c                                                        |    4 +-
 mm/memory.c                                                           |   26 +-
 mm/mmap.c                                                             |   10 +-
 mm/rmap.c                                                             |    6 +-
 mm/slab.c                                                             |    2 +-
 mm/vmpressure.c                                                       |    8 +-
 net/6lowpan/iphc.c                                                    |  103 +-
 net/8021q/vlan_dev.c                                                  |   21 +-
 net/Kconfig                                                           |    1 +
 net/Makefile                                                          |    3 +
 net/appletalk/ddp.c                                                   |    4 +-
 net/atm/common.c                                                      |   16 +-
 net/ax25/af_ax25.c                                                    |    4 +-
 net/bluetooth/6lowpan.c                                               |  307 ++--
 net/bluetooth/Kconfig                                                 |   21 +-
 net/bluetooth/Makefile                                                |    2 +-
 net/bluetooth/a2mp.c                                                  |    4 +-
 net/bluetooth/af_bluetooth.c                                          |    6 +-
 net/bluetooth/amp.c                                                   |   25 +-
 net/bluetooth/bnep/Kconfig                                            |    2 +-
 net/bluetooth/cmtp/Kconfig                                            |    2 +-
 net/bluetooth/ecc.c                                                   |  816 +++++++++
 net/bluetooth/ecc.h                                                   |   54 +
 net/bluetooth/hci_conn.c                                              |   15 +-
 net/bluetooth/hci_core.c                                              |  415 +++--
 net/bluetooth/hci_event.c                                             |  296 +++-
 net/bluetooth/hci_sock.c                                              |    6 +-
 net/bluetooth/hidp/Kconfig                                            |    2 +-
 net/bluetooth/hidp/core.c                                             |   10 +-
 net/bluetooth/l2cap_core.c                                            |  104 +-
 net/bluetooth/l2cap_sock.c                                            |   37 +-
 net/bluetooth/mgmt.c                                                  | 1002 +++++++----
 net/bluetooth/rfcomm/Kconfig                                          |    2 +-
 net/bluetooth/rfcomm/core.c                                           |   12 +-
 net/bluetooth/rfcomm/sock.c                                           |    2 +-
 net/bluetooth/sco.c                                                   |    2 +-
 net/bluetooth/smp.c                                                   | 1675 ++++++++++++++++---
 net/bluetooth/smp.h                                                   |   60 +-
 net/bridge/br_fdb.c                                                   |  144 +-
 net/bridge/br_forward.c                                               |    5 +
 net/bridge/br_input.c                                                 |   60 +
 net/bridge/br_netfilter.c                                             |    1 +
 net/bridge/br_netlink.c                                               |    5 +-
 net/bridge/br_private.h                                               |   20 +-
 net/bridge/br_stp.c                                                   |    7 +
 net/bridge/br_sysfs_if.c                                              |    2 +
 net/bridge/br_vlan.c                                                  |    4 +-
 net/bridge/netfilter/nf_tables_bridge.c                               |   88 +-
 net/bridge/netfilter/nft_reject_bridge.c                              |   52 +-
 net/caif/caif_socket.c                                                |   10 +-
 net/can/af_can.c                                                      |    7 +-
 net/can/bcm.c                                                         |   37 +-
 net/can/gw.c                                                          |    2 +-
 net/can/raw.c                                                         |    8 +-
 net/compat.c                                                          |   87 +-
 net/core/datagram.c                                                   |  301 +---
 net/core/dev.c                                                        |  172 +-
 net/core/dev_addr_lists.c                                             |    4 +-
 net/core/dev_ioctl.c                                                  |    9 +-
 net/core/dst.c                                                        |   24 -
 net/core/ethtool.c                                                    |   81 +-
 net/core/filter.c                                                     |   97 +-
 net/core/iovec.c                                                      |   47 -
 net/core/link_watch.c                                                 |    2 +-
 net/core/neighbour.c                                                  |  279 ++--
 net/core/net-sysfs.c                                                  |   44 +-
 net/core/netpoll.c                                                    |    4 +-
 net/core/pktgen.c                                                     |    3 +-
 net/core/rtnetlink.c                                                  |  178 +-
 net/core/scm.c                                                        |    3 +-
 net/core/skbuff.c                                                     |  347 +++-
 net/core/sock.c                                                       |   20 +-
 net/core/sysctl_net_core.c                                            |   21 +
 net/core/utils.c                                                      |    3 -
 net/dccp/ackvec.c                                                     |    2 +-
 net/dccp/dccp.h                                                       |    4 +-
 net/dccp/feat.c                                                       |    4 +-
 net/dccp/input.c                                                      |    2 +-
 net/dccp/ipv4.c                                                       |    6 -
 net/dccp/proto.c                                                      |    9 +-
 net/decnet/af_decnet.c                                                |    4 +-
 net/decnet/dn_neigh.c                                                 |    4 +-
 net/dsa/Kconfig                                                       |   11 +
 net/dsa/dsa.c                                                         |  170 +-
 net/dsa/slave.c                                                       |   74 +-
 net/dsa/tag_dsa.c                                                     |    2 -
 net/dsa/tag_edsa.c                                                    |    2 -
 net/dsa/tag_trailer.c                                                 |    2 -
 net/ieee802154/6lowpan_rtnl.c                                         |  149 +-
 net/ieee802154/Makefile                                               |    4 +-
 net/ieee802154/af802154.h                                             |    4 -
 net/ieee802154/af_ieee802154.c                                        |    8 +-
 net/ieee802154/core.c                                                 |  321 ++++
 net/ieee802154/core.h                                                 |   46 +
 net/ieee802154/dgram.c                                                |   11 +-
 net/ieee802154/header_ops.c                                           |    3 +-
 net/ieee802154/ieee802154.h                                           |    6 +-
 net/ieee802154/netlink.c                                              |   11 +-
 net/ieee802154/nl-mac.c                                               |  269 +--
 net/ieee802154/nl-phy.c                                               |   32 +-
 net/ieee802154/nl802154.c                                             |  957 +++++++++++
 net/ieee802154/nl802154.h                                             |    7 +
 net/ieee802154/nl_policy.c                                            |    4 -
 net/ieee802154/raw.c                                                  |    9 +-
 net/ieee802154/rdev-ops.h                                             |   89 +
 net/ieee802154/reassembly.c                                           |    8 +-
 net/ieee802154/reassembly.h                                           |    4 +-
 net/ieee802154/sysfs.c                                                |  128 ++
 net/ieee802154/sysfs.h                                                |    9 +
 net/ieee802154/wpan-class.c                                           |  230 ---
 net/ipv4/Kconfig                                                      |    9 +
 net/ipv4/af_inet.c                                                    |   13 +-
 net/ipv4/arp.c                                                        |    2 +-
 net/ipv4/cipso_ipv4.c                                                 |    8 +-
 net/ipv4/esp4.c                                                       |   14 +-
 net/ipv4/fou.c                                                        |  423 ++++-
 net/ipv4/geneve.c                                                     |   14 +-
 net/ipv4/gre_offload.c                                                |    3 +
 net/ipv4/icmp.c                                                       |   51 +-
 net/ipv4/igmp.c                                                       |   34 +-
 net/ipv4/inet_fragment.c                                              |    2 +-
 net/ipv4/ip_fragment.c                                                |   19 +-
 net/ipv4/ip_gre.c                                                     |    2 +-
 net/ipv4/ip_output.c                                                  |   16 +-
 net/ipv4/ip_sockglue.c                                                |   28 +-
 net/ipv4/ip_tunnel.c                                                  |  115 +-
 net/ipv4/ip_vti.c                                                     |    1 +
 net/ipv4/ipconfig.c                                                   |   19 +-
 net/ipv4/ipip.c                                                       |    2 +-
 net/ipv4/netfilter/Kconfig                                            |    9 +
 net/ipv4/netfilter/Makefile                                           |    1 +
 net/ipv4/netfilter/nf_log_arp.c                                       |   24 +-
 net/ipv4/netfilter/nf_log_ipv4.c                                      |   12 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                                   |    1 +
 net/ipv4/netfilter/nft_redir_ipv4.c                                   |   77 +
 net/ipv4/netfilter/nft_reject_ipv4.c                                  |    7 +-
 net/ipv4/ping.c                                                       |   27 +-
 net/ipv4/proc.c                                                       |   11 +-
 net/ipv4/raw.c                                                        |  109 +-
 net/ipv4/syncookies.c                                                 |   86 +-
 net/ipv4/sysctl_net_ipv4.c                                            |    7 +
 net/ipv4/tcp.c                                                        |   77 +-
 net/ipv4/tcp_cong.c                                                   |    2 +-
 net/ipv4/tcp_cubic.c                                                  |   31 +-
 net/ipv4/tcp_input.c                                                  |   49 +-
 net/ipv4/tcp_ipv4.c                                                   |   13 +-
 net/ipv4/tcp_offload.c                                                |    2 +-
 net/ipv4/tcp_output.c                                                 |  152 +-
 net/ipv4/tcp_timer.c                                                  |   18 +-
 net/ipv4/udp.c                                                        |  210 +--
 net/ipv4/udp_offload.c                                                |   69 +-
 net/ipv6/addrconf.c                                                   |   74 +-
 net/ipv6/ah6.c                                                        |   14 +-
 net/ipv6/datagram.c                                                   |   31 +-
 net/ipv6/esp6.c                                                       |   17 +-
 net/ipv6/exthdrs.c                                                    |   20 +-
 net/ipv6/icmp.c                                                       |   31 +-
 net/ipv6/ip6_flowlabel.c                                              |   13 +-
 net/ipv6/ip6_gre.c                                                    |    6 +-
 net/ipv6/ip6_input.c                                                  |    3 +-
 net/ipv6/ip6_offload.c                                                |    5 +-
 net/ipv6/ip6_output.c                                                 |   22 +-
 net/ipv6/ip6_tunnel.c                                                 |  109 +-
 net/ipv6/ip6_udp_tunnel.c                                             |    4 +-
 net/ipv6/ip6_vti.c                                                    |   42 +-
 net/ipv6/ip6mr.c                                                      |    2 +-
 net/ipv6/ipv6_sockglue.c                                              |    6 +-
 net/ipv6/mcast.c                                                      |    6 +-
 net/ipv6/mip6.c                                                       |   11 +-
 net/ipv6/ndisc.c                                                      |   11 +-
 net/ipv6/netfilter.c                                                  |    2 +-
 net/ipv6/netfilter/Kconfig                                            |    9 +
 net/ipv6/netfilter/Makefile                                           |    1 +
 net/ipv6/netfilter/nf_log_ipv6.c                                      |   14 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                                   |    1 +
 net/ipv6/netfilter/nft_redir_ipv6.c                                   |   77 +
 net/ipv6/netfilter/nft_reject_ipv6.c                                  |    7 +-
 net/ipv6/ping.c                                                       |    3 +-
 net/ipv6/proc.c                                                       |    1 +
 net/ipv6/raw.c                                                        |  124 +-
 net/ipv6/reassembly.c                                                 |   15 +-
 net/ipv6/route.c                                                      |   94 +-
 net/ipv6/sit.c                                                        |    9 +-
 net/ipv6/syncookies.c                                                 |   13 +-
 net/ipv6/tcp_ipv6.c                                                   |   37 +-
 net/ipv6/udp.c                                                        |  170 +-
 net/ipv6/udp_offload.c                                                |    4 +-
 net/ipx/af_ipx.c                                                      |    8 +-
 net/ipx/ipx_proc.c                                                    |   18 +-
 net/ipx/ipx_route.c                                                   |    4 +-
 net/ipx/sysctl_net_ipx.c                                              |    4 +-
 net/irda/af_irda.c                                                    |  253 ++-
 net/irda/discovery.c                                                  |   12 +-
 net/irda/ircomm/ircomm_core.c                                         |   55 +-
 net/irda/ircomm/ircomm_event.c                                        |   28 +-
 net/irda/ircomm/ircomm_lmp.c                                          |   30 +-
 net/irda/ircomm/ircomm_param.c                                        |   52 +-
 net/irda/ircomm/ircomm_ttp.c                                          |   30 +-
 net/irda/ircomm/ircomm_tty.c                                          |  116 +-
 net/irda/ircomm/ircomm_tty_attach.c                                   |  122 +-
 net/irda/ircomm/ircomm_tty_ioctl.c                                    |   21 +-
 net/irda/irda_device.c                                                |   34 +-
 net/irda/iriap.c                                                      |  119 +-
 net/irda/iriap_event.c                                                |   42 +-
 net/irda/irias_object.c                                               |   78 +-
 net/irda/irlan/irlan_client.c                                         |   86 +-
 net/irda/irlan/irlan_client_event.c                                   |   66 +-
 net/irda/irlan/irlan_common.c                                         |   80 +-
 net/irda/irlan/irlan_eth.c                                            |   26 +-
 net/irda/irlan/irlan_event.c                                          |    4 +-
 net/irda/irlan/irlan_filter.c                                         |   23 +-
 net/irda/irlan/irlan_provider.c                                       |   42 +-
 net/irda/irlan/irlan_provider_event.c                                 |   16 +-
 net/irda/irlap.c                                                      |   74 +-
 net/irda/irlap_event.c                                                |  234 ++-
 net/irda/irlap_frame.c                                                |  117 +-
 net/irda/irlmp.c                                                      |  186 +--
 net/irda/irlmp_event.c                                                |  133 +-
 net/irda/irlmp_frame.c                                                |   56 +-
 net/irda/irmod.c                                                      |   12 -
 net/irda/irnetlink.c                                                  |    4 +-
 net/irda/irqueue.c                                                    |   14 +-
 net/irda/irsysctl.c                                                   |    9 -
 net/irda/irttp.c                                                      |  164 +-
 net/irda/parameters.c                                                 |   85 +-
 net/irda/qos.c                                                        |   89 +-
 net/irda/wrapper.c                                                    |   28 +-
 net/iucv/af_iucv.c                                                    |    8 +-
 net/key/af_key.c                                                      |    4 +-
 net/l2tp/l2tp_eth.c                                                   |    1 +
 net/l2tp/l2tp_ip.c                                                    |    4 +-
 net/l2tp/l2tp_ip6.c                                                   |    4 +-
 net/l2tp/l2tp_ppp.c                                                   |    5 +-
 net/lapb/lapb_iface.c                                                 |   17 +-
 net/llc/af_llc.c                                                      |    5 +-
 net/llc/llc_c_st.c                                                    |  708 ++++----
 net/llc/llc_conn.c                                                    |    4 +-
 net/llc/llc_if.c                                                      |    2 +-
 net/llc/llc_s_st.c                                                    |   20 +-
 net/llc/llc_sap.c                                                     |    2 +-
 net/mac80211/Kconfig                                                  |   18 +
 net/mac80211/Makefile                                                 |    3 +-
 net/mac80211/agg-tx.c                                                 |   12 +-
 net/mac80211/cfg.c                                                    |  193 ++-
 net/mac80211/chan.c                                                   |   28 +-
 net/mac80211/debug.h                                                  |   10 +
 net/mac80211/debugfs_key.c                                            |   12 +-
 net/mac80211/debugfs_sta.c                                            |   11 +-
 net/mac80211/driver-ops.h                                             |  157 +-
 net/mac80211/ieee80211_i.h                                            |  122 +-
 net/mac80211/iface.c                                                  |   33 +-
 net/mac80211/key.c                                                    |   11 +-
 net/mac80211/main.c                                                   |   44 +-
 net/mac80211/mesh.h                                                   |    3 +
 net/mac80211/mesh_pathtbl.c                                           |   31 +
 net/mac80211/mlme.c                                                   |  333 +++-
 net/mac80211/ocb.c                                                    |  250 +++
 net/mac80211/rate.c                                                   |    8 +-
 net/mac80211/rate.h                                                   |   24 +-
 net/mac80211/rc80211_minstrel.c                                       |    7 +-
 net/mac80211/rc80211_minstrel_ht.c                                    |  334 +++-
 net/mac80211/rc80211_minstrel_ht.h                                    |   40 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c                            |   43 +-
 net/mac80211/rx.c                                                     |  181 +-
 net/mac80211/scan.c                                                   |  129 +-
 net/mac80211/sta_info.c                                               |   19 +-
 net/mac80211/sta_info.h                                               |   11 +
 net/mac80211/status.c                                                 |  171 +-
 net/mac80211/tdls.c                                                   |  800 ++++++++-
 net/mac80211/trace.h                                                  |  248 ++-
 net/mac80211/tx.c                                                     |  316 +++-
 net/mac80211/util.c                                                   |  203 ++-
 net/mac80211/vht.c                                                    |    2 +
 net/mac80211/wep.c                                                    |    2 -
 net/mac80211/wme.c                                                    |   72 +-
 net/mac80211/wme.h                                                    |    2 -
 net/mac80211/wpa.c                                                    |    5 -
 net/mac802154/Kconfig                                                 |    2 +-
 net/mac802154/Makefile                                                |    4 +-
 net/mac802154/cfg.c                                                   |  210 +++
 net/mac802154/cfg.h                                                   |    9 +
 net/mac802154/driver-ops.h                                            |  222 +++
 net/mac802154/ieee802154_dev.c                                        |  415 -----
 net/mac802154/{mac802154.h => ieee802154_i.h}                         |  132 +-
 net/mac802154/iface.c                                                 |  586 +++++++
 net/mac802154/llsec.c                                                 |   23 +-
 net/mac802154/mac_cmd.c                                               |   88 +-
 net/mac802154/main.c                                                  |  217 +++
 net/mac802154/mib.c                                                   |  271 +--
 net/mac802154/monitor.c                                               |  117 --
 net/mac802154/rx.c                                                    |  310 +++-
 net/mac802154/tx.c                                                    |  154 +-
 net/mac802154/util.c                                                  |   84 +
 net/mac802154/wpan.c                                                  |  599 -------
 net/mpls/mpls_gso.c                                                   |    3 +-
 net/netfilter/Kconfig                                                 |   17 +
 net/netfilter/Makefile                                                |    2 +
 net/netfilter/core.c                                                  |    1 +
 net/netfilter/ipset/ip_set_hash_gen.h                                 |  101 +-
 net/netfilter/ipset/ip_set_hash_netiface.c                            |    1 +
 net/netfilter/ipset/ip_set_hash_netnet.c                              |    2 +
 net/netfilter/ipset/ip_set_hash_netportnet.c                          |    2 +
 net/netfilter/ipvs/ip_vs_ctl.c                                        |    3 +-
 net/netfilter/ipvs/ip_vs_pe.c                                         |    3 +-
 net/netfilter/ipvs/ip_vs_sched.c                                      |    3 +-
 net/netfilter/ipvs/ip_vs_sync.c                                       |    3 +-
 net/netfilter/ipvs/ip_vs_xmit.c                                       |    5 +-
 net/netfilter/nf_conntrack_core.c                                     |   25 +-
 net/netfilter/nf_conntrack_h323_main.c                                |   14 +-
 net/netfilter/nf_conntrack_helper.c                                   |    2 +-
 net/netfilter/nf_log.c                                                |   40 +-
 net/netfilter/nf_nat_redirect.c                                       |  127 ++
 net/netfilter/nf_tables_api.c                                         |    5 +-
 net/netfilter/nfnetlink_log.c                                         |   18 +-
 net/netfilter/nft_hash.c                                              |   10 +-
 net/netfilter/nft_meta.c                                              |    7 +
 net/netfilter/nft_redir.c                                             |   99 ++
 net/netfilter/xt_DSCP.c                                               |    6 +-
 net/netfilter/xt_REDIRECT.c                                           |   83 +-
 net/netfilter/xt_connlimit.c                                          |   25 +-
 net/netfilter/xt_recent.c                                             |   64 +-
 net/netfilter/xt_set.c                                                |   73 +-
 net/netlink/af_netlink.c                                              |   23 +-
 net/netrom/af_netrom.c                                                |    4 +-
 net/nfc/digital_dep.c                                                 |  834 +++++++++-
 net/nfc/hci/command.c                                                 |    3 +
 net/nfc/hci/core.c                                                    |   56 +
 net/nfc/llcp_commands.c                                               |   10 +-
 net/nfc/llcp_core.c                                                   |    5 +-
 net/nfc/llcp_sock.c                                                   |    8 +-
 net/nfc/nci/core.c                                                    |  150 +-
 net/nfc/nci/data.c                                                    |   24 +-
 net/nfc/nci/ntf.c                                                     |  152 +-
 net/nfc/netlink.c                                                     |   77 +-
 net/nfc/rawsock.c                                                     |    4 +-
 net/openvswitch/Kconfig                                               |   23 +-
 net/openvswitch/Makefile                                              |   14 +-
 net/openvswitch/actions.c                                             |  355 ++--
 net/openvswitch/datapath.c                                            |  346 ++--
 net/openvswitch/datapath.h                                            |   24 +-
 net/openvswitch/flow.c                                                |   38 +-
 net/openvswitch/flow.h                                                |   88 +-
 net/openvswitch/flow_netlink.c                                        |  633 ++++---
 net/openvswitch/flow_netlink.h                                        |   18 +-
 net/openvswitch/flow_table.c                                          |   27 +-
 net/openvswitch/flow_table.h                                          |   10 +-
 net/openvswitch/vport-geneve.c                                        |   46 +-
 net/openvswitch/vport-gre.c                                           |   47 +-
 net/openvswitch/vport-internal_dev.c                                  |   22 +-
 net/openvswitch/vport-netdev.c                                        |   16 +-
 net/openvswitch/vport-netdev.h                                        |    3 +
 net/openvswitch/vport-vxlan.c                                         |   47 +-
 net/openvswitch/vport.c                                               |  171 +-
 net/openvswitch/vport.h                                               |   34 +-
 net/packet/af_packet.c                                                |   47 +-
 net/phonet/af_phonet.c                                                |    9 +-
 net/phonet/datagram.c                                                 |    4 +-
 net/phonet/pep-gprs.c                                                 |    3 +-
 net/phonet/pep.c                                                      |   16 +-
 net/rds/ib.h                                                          |    3 +-
 net/rds/ib_recv.c                                                     |   37 +-
 net/rds/iw.h                                                          |    3 +-
 net/rds/iw_recv.c                                                     |   37 +-
 net/rds/message.c                                                     |   77 +-
 net/rds/rds.h                                                         |    9 +-
 net/rds/recv.c                                                        |    6 +-
 net/rds/send.c                                                        |    6 +-
 net/rds/tcp.h                                                         |    3 +-
 net/rds/tcp_recv.c                                                    |   38 +-
 net/rose/af_rose.c                                                    |    4 +-
 net/rxrpc/ar-output.c                                                 |   10 +-
 net/rxrpc/ar-recvmsg.c                                                |    2 +-
 net/sched/Kconfig                                                     |   18 +-
 net/sched/Makefile                                                    |    1 +
 net/sched/act_gact.c                                                  |    2 +-
 net/sched/act_ipt.c                                                   |    2 +-
 net/sched/act_mirred.c                                                |    2 +-
 net/sched/act_pedit.c                                                 |    2 +-
 net/sched/act_police.c                                                |    2 +-
 net/sched/act_simple.c                                                |    2 +-
 net/sched/act_vlan.c                                                  |  207 +++
 net/sched/cls_basic.c                                                 |   26 +-
 net/sched/cls_bpf.c                                                   |   26 +-
 net/sched/cls_cgroup.c                                                |   14 +-
 net/sched/cls_flow.c                                                  |   14 +-
 net/sched/cls_fw.c                                                    |    8 +-
 net/sched/cls_route.c                                                 |    8 +-
 net/sched/cls_rsvp.h                                                  |    8 +-
 net/sched/cls_tcindex.c                                               |   15 +-
 net/sched/cls_u32.c                                                   |    5 -
 net/sched/sch_fq.c                                                    |    9 +-
 net/sched/sch_fq_codel.c                                              |    2 +-
 net/sched/sch_netem.c                                                 |   27 +-
 net/sctp/chunk.c                                                      |    9 +-
 net/sctp/output.c                                                     |    4 +-
 net/sctp/proc.c                                                       |   12 +-
 net/sctp/sm_make_chunk.c                                              |   20 +-
 net/sctp/socket.c                                                     |   19 +-
 net/sctp/ulpqueue.c                                                   |    5 +-
 net/socket.c                                                          |  181 +-
 net/sunrpc/svcsock.c                                                  |   27 +-
 net/switchdev/Kconfig                                                 |   13 +
 net/switchdev/Makefile                                                |    5 +
 net/switchdev/switchdev.c                                             |   52 +
 net/tipc/Makefile                                                     |    4 +-
 net/tipc/bcast.c                                                      |  230 ++-
 net/tipc/bcast.h                                                      |    6 +-
 net/tipc/bearer.c                                                     |  447 ++++-
 net/tipc/bearer.h                                                     |   16 +-
 net/tipc/core.h                                                       |    2 +
 net/tipc/link.c                                                       |  981 +++++++----
 net/tipc/link.h                                                       |   55 +-
 net/tipc/msg.c                                                        |  133 +-
 net/tipc/msg.h                                                        |   16 +-
 net/tipc/name_distr.c                                                 |  181 +-
 net/tipc/name_distr.h                                                 |    1 +
 net/tipc/name_table.c                                                 |  373 ++++-
 net/tipc/name_table.h                                                 |   30 +-
 net/tipc/net.c                                                        |  106 ++
 net/tipc/net.h                                                        |    8 +-
 net/tipc/netlink.c                                                    |  133 +-
 net/tipc/{node_subscr.h => netlink.h}                                 |   35 +-
 net/tipc/node.c                                                       |  108 +-
 net/tipc/node.h                                                       |   16 +-
 net/tipc/node_subscr.c                                                |   96 --
 net/tipc/socket.c                                                     |  419 +++--
 net/tipc/socket.h                                                     |    3 +
 net/tipc/subscr.c                                                     |    1 -
 net/unix/af_unix.c                                                    |   11 +-
 net/vmw_vsock/af_vsock.c                                              |    6 +-
 net/vmw_vsock/vmci_transport.c                                        |   18 +-
 net/wireless/Kconfig                                                  |    2 +-
 net/wireless/Makefile                                                 |    2 +-
 net/wireless/chan.c                                                   |   10 +-
 net/wireless/core.c                                                   |   95 +-
 net/wireless/core.h                                                   |   13 +
 net/wireless/nl80211.c                                                |  978 ++++++++---
 net/wireless/ocb.c                                                    |   88 +
 net/wireless/rdev-ops.h                                               |   79 +-
 net/wireless/reg.c                                                    |  156 +-
 net/wireless/sme.c                                                    |   13 +-
 net/wireless/trace.h                                                  |  155 +-
 net/wireless/util.c                                                   |    5 +-
 net/x25/af_x25.c                                                      |    4 +-
 net/xfrm/xfrm_policy.c                                                |   52 +-
 net/xfrm/xfrm_user.c                                                  |   12 +-
 samples/bpf/Makefile                                                  |   23 +-
 samples/bpf/bpf_helpers.h                                             |   40 +
 samples/bpf/bpf_load.c                                                |  203 +++
 samples/bpf/bpf_load.h                                                |   24 +
 samples/bpf/libbpf.c                                                  |   31 +-
 samples/bpf/libbpf.h                                                  |   17 +-
 samples/bpf/sock_example.c                                            |  101 ++
 samples/bpf/sockex1_kern.c                                            |   25 +
 samples/bpf/sockex1_user.c                                            |   49 +
 samples/bpf/sockex2_kern.c                                            |  215 +++
 samples/bpf/sockex2_user.c                                            |   44 +
 samples/bpf/test_maps.c                                               |  291 ++++
 samples/bpf/test_verifier.c                                           |   60 +-
 security/keys/internal.h                                              |    1 +
 security/keys/keyctl.c                                                |   56 +-
 security/keys/keyring.c                                               |   10 +-
 security/keys/request_key.c                                           |    2 +
 security/keys/request_key_auth.c                                      |    1 +
 sound/core/pcm.c                                                      |    2 +
 sound/core/pcm_misc.c                                                 |    8 +
 sound/pci/hda/hda_intel.c                                             |   24 +-
 sound/pci/hda/hda_priv.h                                              |    1 +
 sound/pci/hda/patch_realtek.c                                         |    1 -
 sound/usb/mixer_quirks.c                                              |    4 +-
 sound/usb/quirks.c                                                    |    4 +-
 tools/perf/util/include/asm/hash.h                                    |    6 -
 virt/kvm/arm/vgic.c                                                   |    8 +-
 virt/kvm/kvm_main.c                                                   |   16 +-
 1491 files changed, 72189 insertions(+), 30007 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/btmrvl.txt
 create mode 100644 Documentation/networking/ipvlan.txt
 create mode 100644 Documentation/networking/switchdev.txt
 delete mode 100644 arch/x86/include/asm/hash.h
 delete mode 100644 arch/x86/lib/hash.c
 create mode 100644 drivers/net/dsa/mv88e6352.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h
 create mode 100644 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.h
 create mode 100644 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
 create mode 100644 drivers/net/ethernet/rocker/Kconfig
 create mode 100644 drivers/net/ethernet/rocker/Makefile
 create mode 100644 drivers/net/ethernet/rocker/rocker.c
 create mode 100644 drivers/net/ethernet/rocker/rocker.h
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
 delete mode 100644 drivers/net/ieee802154/fakehard.c
 create mode 100644 drivers/net/ipvlan/Makefile
 create mode 100644 drivers/net/ipvlan/ipvlan.h
 create mode 100644 drivers/net/ipvlan/ipvlan_core.c
 create mode 100644 drivers/net/ipvlan/ipvlan_main.c
 rename drivers/net/wireless/ath/ath9k/{spectral.c => common-spectral.c} (73%)
 rename drivers/net/wireless/ath/ath9k/{spectral.h => common-spectral.h} (85%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_bus.h => bus.h} (98%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{wl_cfg80211.c => cfg80211.c} (95%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{wl_cfg80211.h => cfg80211.h} (98%)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/common.c
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_linux.c => core.c} (96%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd.h => core.h} (96%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.c => debug.c} (98%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.h => debug.h} (98%)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_sdio.c => sdio.c} (98%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{sdio_host.h => sdio.h} (98%)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h
 delete mode 100644 drivers/net/wireless/p54/net2280.h
 delete mode 100644 include/asm-generic/hash.h
 rename include/{net => linux}/ieee802154.h (79%)
 create mode 100644 include/linux/platform_data/bcmgenet.h
 rename {drivers/net/bonding => include/net}/bond_3ad.h (99%)
 rename {drivers/net/bonding => include/net}/bond_alb.h (98%)
 rename {drivers/net/bonding => include/net}/bond_options.h (97%)
 rename {drivers/net/bonding => include/net}/bonding.h (98%)
 create mode 100644 include/net/cfg802154.h
 create mode 100644 include/net/fou.h
 create mode 100644 include/net/mpls.h
 create mode 100644 include/net/netfilter/nf_nat_redirect.h
 create mode 100644 include/net/netfilter/nf_tables_bridge.h
 create mode 100644 include/net/netfilter/nft_redir.h
 create mode 100644 include/net/switchdev.h
 create mode 100644 include/net/tc_act/tc_vlan.h
 delete mode 100644 include/net/wpan-phy.h
 create mode 100644 include/uapi/linux/tc_act/tc_vlan.h
 create mode 100644 include/uapi/linux/tipc_netlink.h
 create mode 100644 kernel/bpf/arraymap.c
 create mode 100644 kernel/bpf/hashtab.c
 create mode 100644 kernel/bpf/helpers.c
 delete mode 100644 lib/hash.c
 create mode 100644 net/bluetooth/ecc.c
 create mode 100644 net/bluetooth/ecc.h
 create mode 100644 net/ieee802154/core.c
 create mode 100644 net/ieee802154/core.h
 create mode 100644 net/ieee802154/nl802154.c
 create mode 100644 net/ieee802154/nl802154.h
 create mode 100644 net/ieee802154/rdev-ops.h
 create mode 100644 net/ieee802154/sysfs.c
 create mode 100644 net/ieee802154/sysfs.h
 delete mode 100644 net/ieee802154/wpan-class.c
 create mode 100644 net/ipv4/netfilter/nft_redir_ipv4.c
 create mode 100644 net/ipv6/netfilter/nft_redir_ipv6.c
 create mode 100644 net/mac80211/ocb.c
 create mode 100644 net/mac802154/cfg.c
 create mode 100644 net/mac802154/cfg.h
 create mode 100644 net/mac802154/driver-ops.h
 delete mode 100644 net/mac802154/ieee802154_dev.c
 rename net/mac802154/{mac802154.h => ieee802154_i.h} (63%)
 create mode 100644 net/mac802154/iface.c
 create mode 100644 net/mac802154/main.c
 delete mode 100644 net/mac802154/monitor.c
 create mode 100644 net/mac802154/util.c
 delete mode 100644 net/mac802154/wpan.c
 create mode 100644 net/netfilter/nf_nat_redirect.c
 create mode 100644 net/netfilter/nft_redir.c
 create mode 100644 net/sched/act_vlan.c
 create mode 100644 net/switchdev/Kconfig
 create mode 100644 net/switchdev/Makefile
 create mode 100644 net/switchdev/switchdev.c
 rename net/tipc/{node_subscr.h => netlink.h} (63%)
 delete mode 100644 net/tipc/node_subscr.c
 create mode 100644 net/wireless/ocb.c
 create mode 100644 samples/bpf/bpf_helpers.h
 create mode 100644 samples/bpf/bpf_load.c
 create mode 100644 samples/bpf/bpf_load.h
 create mode 100644 samples/bpf/sock_example.c
 create mode 100644 samples/bpf/sockex1_kern.c
 create mode 100644 samples/bpf/sockex1_user.c
 create mode 100644 samples/bpf/sockex2_kern.c
 create mode 100644 samples/bpf/sockex2_user.c
 create mode 100644 samples/bpf/test_maps.c
 delete mode 100644 tools/perf/util/include/asm/hash.h
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
