Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaEYXc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:32:26 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:38094 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaEYXcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:32:23 -0400
MIME-Version: 1.0
Date: Sun, 25 May 2014 16:32:22 -0700
X-Google-Sender-Auth: YsSsyfpDx8LpfhawZhJntm70DbY
Message-ID: <CA+55aFzXZp4YdqnPsBXR7khcYvUzFqG0fPA_xKd+uB7KQ6Ep7A@mail.gmail.com>
Subject: Linux 3.15-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. and with this, I'm back on my usual Sunday schedule.

It's just a few days after -rc6, but as expected, there were some
pending stuff for when I got back home, so you should think of this as
being the "normal" release, and rc6 just having been oddly delayed by
my travel.

The bulk of this is (by far) the networking changes (mostly drivers),
since most other trees had synced up for rc6, but there are various
smaller things in here too: drm, scheduler, perf, nfsd, afs etc.

              Linus

---

Alex Deucher (4):
      drm/radeon: fix DCE83 check for mullins
      drm/radeon: handle non-VGA class pci devices with ATRM
      drm/radeon: fix register typo on si
      drm/radeon/pm: don't allow debugfs/sysfs access when PX card is off (v2)

Alexander Bondar (1):
      iwlwifi: mvm: several fixes in scan

Alexei Starovoitov (1):
      net: filter: x86: fix JIT address randomization

Antonio Quartulli (3):
      batman-adv: fix reference counting imbalance while sending fragment
      batman-adv: increase orig refcount when storing ref in gw_node
      batman-adv: fix local TT check for outgoing arp requests in DAT

Ben Skeggs (1):
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup

Bjørn Mork (2):
      net: cdc_mbim: __vlan_find_dev_deep need rcu_read_lock
      net: cdc_mbim: handle unaccelerated VLAN tagged frames

Bob Copeland (1):
      mac80211: fixup radiotap tx flags for RTS/CTS

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for
handling a free hugepage

Christian König (4):
      drm/radeon: also try GART for CPU accessed buffers
      drm/radeon: fix page directory update size estimation
      drm/radeon: fix buffer placement under memory pressure v2
      drm/radeon: fix typo in finding PLL params

Chun-Yeow Yeoh (1):
      mac80211: avoid handling of SMPS for mesh

Cong Wang (5):
      ipv4: move local_port_range out of CONFIG_SYSCTL
      ping: move ping_group_range out of CONFIG_SYSCTL
      rtnetlink: wait for unregistering devices in rtnl_link_unregister()
      net_sched: fix an oops in tcindex filter
      batman: fix a bogus warning from batadv_is_on_batman_iface()

Daniel Kim (1):
      brcmfmac: Fix iovar 'bw_cap' set command failure

Daniel Mack (1):
      net: mdio: of_mdiobus_register(): fall back to
mdiobus_register() for !CONFIG_OF

Darek Marcinkiewicz (1):
      Driver for Beckhoff CX5020 EtherCAT master module.

David Howells (2):
      AFS: Fix cache manager service handlers
      AFS: Pass an afs_call* to call->async_workfn() instead of a work_struct*

David S. Miller (3):
      sparc64: Don't bark so loudly about 32-bit tasks generating
64-bit fault addresses.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Add membar to Niagara2 memcpy code.

David Spinadel (2):
      iwlwifi: mvm: do no sched scan while associated
      iwlwifi: mvm: prevent sched scan while not idle

David Vrabel (1):
      xen-netback: fix race between napi_complete() and interrupt handler

Denys Fedoryshchenko (1):
      netfilter: nfnetlink: Fix use after free when it fails to process batch

Duan Jiong (2):
      neigh: set nud_state to NUD_INCOMPLETE when probing router reachability
      ipv6: update Destination Cache entries when gateway turn into host

Eliad Peller (5):
      cfg80211: free sme on connection failures
      cfg80211: add cfg80211_sched_scan_stopped_rtnl
      mac80211: fix nested rtnl locking on ieee80211_reconfig
      mac80211: fix vif name tracing
      iwlwifi: mvm: fix off-by-one in scan channels configuration

Emil Goode (1):
      net: cassini: use nested lock annotation

Emmanuel Grumbach (5):
      iwlwifi: mvm: BT Coex - fix validity flags during init
      iwlwifi: mvm: rs - s/CPTCFG/CONFIG
      iwlwifi: pcie: disable interrupts upon PCIe alloc
      iwlwifi: mvm: fix setting channel in monitor mode
      mac80211: fix suspend vs. association race

Eric Dumazet (2):
      net: gro: make sure skb->cb[] initial content has not to be zero
      ipv6: gro: fix CHECKSUM_COMPLETE support

Ezequiel Garcia (1):
      dma: mv_xor: Flush descriptors before activating a channel

Fabian Godehardt (1):
      net/dsa/dsa.c: increment chip_index during of_node handling on
dsa_of_probe()

Florian Westphal (6):
      netfilter: ctnetlink: don't add null bindings if no nat requested
      netfilter: ipv4: defrag: set local_df flag on defragmented skb
      net: ipv4: ip_forward: fix inverted local_df test
      net: ipv6: send pkttoobig immediately if orig frag size > mtu
      net: ip: push gso skb forwarding handling down the stack
      Revert "net: core: introduce netif_skb_dev_features"

Guenter Roeck (1):
      net: phy: Don't call phy_resume if phy_init_hw failed

Hannes Frederic Sowa (2):
      net: avoid dependency of net_get_random_once on nop patching
      ipv6: fix calculation of option len in ip6_append_data

Hans de Goede (1):
      stmmac: Remove unbalanced clk_disable call

Heiko Carstens (1):
      net: filter: s390: fix JIT address randomization

Henning Rogge (1):
      mac80211: Fix mac80211 station info rx bitrate for IBSS mode

J. Bruce Fields (3):
      nfsd4: fix corruption on setting an ACL.
      nfsd4: remove lockowner when removing lock stateid
      nfsd4: warn on finding lockowner without stateid's

Jan Moskyto Matejka (1):
      Documentation: update /proc/stat "intr" count summary

Jason Low (2):
      sched: Fix updating rq->max_idle_balance_cost and
rq->next_balance in idle_balance()
      sched/numa: Initialize newidle balance stats in sd_numa_init()

Jean Delvare (3):
      hwmon: Document temp[1-*]_min_hyst sysfs attribute
      hwmon: (ntc_thermistor) Fix dependencies
      hwmon: (ntc_thermistor) Fix OF device ID mapping

Jens Axboe (1):
      mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT

Jesse Gross (1):
      MAINTAINERS: Pravin Shelar is Open vSwitch maintainer.

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Joe Lawrence (1):
      [SCSI] scsi_transport_sas: move bsg destructor into sas_rphy_remove

Joe Perches (1):
      bnx2x: Convert return 0 to return rc

Johan Hovold (5):
      net: mdio-gpio: fix device-tree binding documentation
      net: mdio-gpio: warn about missing bus alias id
      Revert "net: eth: cpsw: Correctly attach to GPIO bitbang MDIO driver"
      net: cpsw: fix null dereference at probe
      net: cpsw: add missing of_node_put

Johannes Berg (4):
      mac80211: allow VHT with peers not capable of 40MHz
      nl80211: fix NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL API
      mac80211: fix on-channel remain-on-channel
      Documentation: fix DOCBOOKS=... building

Johannes Weiner (1):
      mm: madvise: fix MADV_WILLNEED on shmem swapouts

Jonathan Callen (1):
      Documentation: update java sample wrapper for java 7

Joseph Qi (1):
      ocfs2: fix double kmem_cache_destroy in dlm_init

Juri Lelli (1):
      sched/deadline: Fix sched_yield() behavior

Jérôme Glisse (1):
      drm/radeon: avoid segfault on device open when accel is not working.

Kalesh AP (1):
      be2net: enable interrupts in EEH resume

Leo Liu (1):
      drm/radeon: check VCE relocation buffer range v3

Li RongQing (1):
      ipv4: initialise the itag variable in __mkroute_input

Li Zefan (1):
      sched/deadline: Fix memory leak

Linus Torvalds (2):
      parisc: 'renameat2()' doesn't need (or have) a separate compat system call
      Linux 3.15-rc7

Lorenzo Colitti (1):
      net: ipv6: make "ip -6 route get mark xyz" work.

Manish Chopra (1):
      qlcnic: Fix panic while dumping TX queues on TX timeout

Marek Lindner (1):
      batman-adv: fix indirect hard_iface NULL dereference

Martin Peres (1):
      drm/nvd9/therm: handle another kind of PWM fan

Masanari Iida (2):
      sched/docbook: Fix 'make htmldocs' warnings caused by missing description
      Documentation: fix typos in drm docbook

Masatake YAMATO (1):
      wait: swap EXIT_ZOMBIE(Z) and EXIT_DEAD(X) chars in TASK_STATE_TO_CHAR_STR

Matan Barak (2):
      net/mlx4_core: Add UPDATE_QP SRIOV wrapper support
      IB/mlx4: Invoke UPDATE_QP for proxy QP1 on MAC changes

Mathias Krause (1):
      vti6: Don't unregister pernet ops twice on init errors

Michal Hocko (1):
      memcg: fix swapcache charge from kernel thread context

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak by race between poison and unpoison

Nathaniel W Filardo (1):
      af_rxrpc: Fix XDR length check in rxrpc key demarshalling.

Nathaniel Wesley Filardo (2):
      AFS: Part of afs_end_call() is identical to code elsewhere, so split it
      AFS: Fix kafs module unloading

Neil Horman (2):
      jme: Fix DMA unmap warning
      jme: Fix unmap loop counting error:

Nikolay Aleksandrov (2):
      sfc: fix calling of free_irq with already free vector
      bonding: fix out of range parameters for bond_intmax_tbl

Oliver Hartkopp (1):
      can: c_can: remove obsolete STRICT_FRAME_ORDERING Kconfig option

Pablo Neira Ayuso (6):
      netfilter: nf_tables: reset rule number counter after jump and goto
      netfilter: nf_tables: fix goto action
      netfilter: nf_tables: fix tracing of the goto action
      netfilter: nf_tables: fix bogus rulenum after goto action
      netfilter: nf_tables: fix missing return trace at the end of
non-base chain
      netfilter: nf_tables: fix trace of matching non-terminal rule

Paul McQuade (1):
      Documentation: update thunderbird email client settings

Peter Christensen (1):
      macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Peter Zijlstra (5):
      perf: Fix race in removing an event
      perf: Fix perf_event_init_context()
      sched: Skip double execution of pick_next_task_fair()
      perf: Limit perf_event_attr::sample_period to 63 bits
      perf: Fix a race between ring_buffer_detach() and ring_buffer_attach()

Rajkumar Manoharan (1):
      ath9k_htc: Stop ANI before doing hw_reset

Randy Dunlap (1):
      ptp: fix kconfig dependency warnings

S. Lockwood-Childs (1):
      tools/liblockdep: Build liblockdep from tools/Makefile

Sasha Levin (1):
      tools/liblockdep: Remove all build files when doing make clean

Sergey Popovich (2):
      ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation
      netfilter: Fix potential use after free in ip6_route_me_harder()

Shahed Shaikh (1):
      qlcnic: Set real_num_{tx|rx}_queues properly

Simon Wunderlich (4):
      batman-adv: fix neigh_ifinfo imbalance
      batman-adv: fix neigh reference imbalance
      batman-adv: always run purge_orig_neighbors
      batman-adv: fix removing neigh_ifinfo

Steffen Klassert (6):
      xfrm: Fix crash with ipv6 IPsec tunnel and NAT.
      vti4: Don't count header length twice.
      xfrm4: Properly handle unsupported protocols
      xfrm6: Properly handle unsupported protocols
      vti: Use the tunnel mark for lookup in the error handlers.
      ip_tunnel: Initialize the fallback device properly

Stephane Grosjean (1):
      can: peak_pci: prevent use after free at netdev removal

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

Susant Sahani (1):
      ip6_tunnel: fix potential NULL pointer dereference

Thomas Gleixner (1):
      sched: Sanitize irq accounting madness

Timo Teräs (1):
      ipv4: ip_tunnels: disable cache for nbma gre tunnels

Tobias Klauser (2):
      net: doc: Update references to skb->rxhash
      MAINTAINERS: add closing angle bracket to Vince Bridgers' email address

Toralf Förster (1):
      sparc64: fix format string mismatch in arch/sparc/kernel/sysfs.c

Ursula Braun (1):
      af_iucv: wrong mapping of sent and confirmed skbs

Vasily Averin (2):
      ipv4: fix "conntrack zones" support for defrag user check in ip_expire
      bridge: superfluous skb->nfct check in br_nf_dev_queue_xmit

Vince Bridgers (2):
      Altera TSE: Fix sparse errors and warnings
      Altera TSE: Disable Multicast filtering to workaround problem

Vlad Yasevich (9):
      net: Find the nesting level of a given device by type.
      net: Allow for more then a single subclass for netif_addr_lock
      vlan: Fix lockdep warning with stacked vlan devices.
      macvlan: Fix lockdep warnings with stacked macvlan devices
      bonding: Fix stacked device detection in arp monitoring
      bonding: Fix alb mode to only use first level vlans.
      vlan: Fix build error wth vlan_get_encap_level()
      bonding: Don't assume 802.1Q when sending alb learning packets.
      bonding: Send ALB learning packets using the right source

Xuelin Shi (1):
      dmaengine: fix dmaengine_unmap failure

Yan, Zheng (1):
      perf/x86/intel: Fix Silvermont's event constraints

Yuval Mintz (1):
      bnx2x: Fix UNDI driver unload

Zhangfei Gao (1):
      net: phy: resume phydev when going to RESUMING

Zoltan Kiss (1):
      xen-netback: Fix grant ref resolution in RX path
