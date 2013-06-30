Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3F3XKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 19:10:04 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:50144 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3F3XKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 19:10:01 -0400
MIME-Version: 1.0
Date: Sun, 30 Jun 2013 16:09:59 -0700
X-Google-Sender-Auth: XX2VNSIHz8rEq0OJYYnu0GKrtCg
Message-ID: <CA+55aFzWRsRGgE9Muig0LoeqMLZXZvGEw+ROYguV0ZcnMhqQ0g@mail.gmail.com>
Subject: Linux 3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I delayed this by a day, considering whether to do another -rc, but
decided that there wasn't enough upside. Sure, it hasn't been as quiet
as I'd like, and we had this long discussion about an inode list
locking scalability issue over the last week or two, but in the end
that issue turned out to not be new, and while we may end up
back-porting the eventual resolution to 3.10, it wasn't a reason to
delay the release.

Similarly, while I might wish for fewer pull requests during the late
rc's (and particularly the ones that came in Friday evening -
inconvenient for a weekend release), at some point delaying things
doesn't really help things, and just makes the pent up demand for the
next merge window worse.

In other words, I could really have gone either way, but decided that
there wasn't enough reason to break the normal pattern of "rc7 is the
last rc before the release". So here goes..

The appended changelog is (as usual) just the changes since the last
rc. This time mainly from the networking pull (which includes drivers
and core networking, as well as bluetooth), the rest were pretty small
and scattered. We've got some arch updates, some acpi/pm fixes, and a
scattering of other random fixes..

In the bigger picture (ie since 3.9) this release has been pretty
typical and not particularly prone to problems, despite my waffling
about the exact release date. As usual, the bulk patch-wise is all
drivers (pretty much exactly two thirds), while the rest is evenly
split between arch updates and "misc". No major new subsystems this
time around, although there are individual new features. As usual, I'm
sure H-Online and kernelnewbies will do better writeups of the
details..


                   Linus

---

Aaron Lu (1):
      libata-acpi: add back ACPI based hotplug functionality

Akira Takeuchi (2):
      mn10300: Allow to pass array name to get_user()
      mn10300: Use early_param() to parse "mem=" parameter

Amir Vadai (1):
      net/mlx_en: Timestamping is not supported in slave mode

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Arend van Spriel (2):
      brcmsmac: disable power-save related functions
      brcmfmac: free primary net_device when brcmf_bus_start() fails

Artem Bityutskiy (2):
      UBIFS: prepare to fix a horrid bug
      UBIFS: fix a horrid bug

Aydin Arik (1):
      ipv4: Fixed MD5 key lookups when adding/ removing MD5 to/ from
TCP sockets.

Balazs Peter Odor (1):
      netfilter: nf_nat_sip: fix mangling

Ben Hutchings (3):
      Input: add missing dependencies on CONFIG_HAS_IOMEM
      s390/irq: Only define synchronize_irq() on SMP
      sfc: Remove write permission from phy_type attribute

Chris Wilson (1):
      drm/i915: Restore fences after resume and GPU resets

Dan Williams (1):
      qmi_wwan: add various Novatel Gobi1K IDs

Daniel Drake (1):
      Bluetooth: btmrvl: fix thread stopping race

Daniel Lezcano (1):
      tick: Fix tick_broadcast_pending_mask not cleared

Dave Airlie (1):
      drm/qxl: add missing access check for execbuffer ioctl

David Daney (2):
      netdev: octeon_mgmt: Correct tx IFG workaround.
      netdev: octeon_mgmt: Fix structure layout for little-endian.

Emmanuel Grumbach (1):
      iwlwifi: mvm: correctly set the flags for BAR

Eric Dumazet (2):
      gre: fix a possible skb leak
      ipv6: ip6_sk_dst_check() must not assume ipv6 dst

Felix Fietkau (1):
      ath9k: fix an RCU issue in calling ieee80211_get_tx_rates

Fernando Luis Vazquez Cao (1):
      vlan: restore ethtool ABI to control VLAN hardware acceleration

Ferruh Yigit (2):
      Input: cyttsp - fix memcpy size param
      Input: cyttsp - add missing handshake

Florian Westphal (1):
      netfilter: ctnetlink: send event when conntrack label was modified

Gao feng (2):
      ipv6: don't call addrconf_dst_alloc again when enable lo
      netfilter: ipt_ULOG: fix incorrect setting of ulog timer

Gavin Shan (2):
      net/tg3: Avoid delay during MMIO access
      powerpc/eeh: Fix fetching bus for single-dev-PE

Giuseppe CAVALLARO (1):
      stmmac: fix EEE setup

Gregory CLEMENT (1):
      ARM: 7773/1: PJ4B: Add support for errata 4742

Guenter Roeck (2):
      net: fec: Fix build for MCF5272
      powerpc/pci: Improve device hotplug initialization

Haiyang Zhang (1):
      Fix the VLAN_TAG_PRESENT in netvsc_recv_callback()

Hannes Frederic Sowa (1):
      ipv6: check return value of ipv6_get_lladdr

Heiko Carstens (1):
      s390/mem_detect: fix memory hole handling

Herbert Xu (1):
      crypto: algboss - Hold ref count on larval

Jacob Shin (1):
      cpufreq: fix NULL pointer deference at od_set_powersave_bias()

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

Javier Martinez Canillas (1):
      gpio/omap: don't use linear domain mapping for OMAP1

Jiang Liu (2):
      ACPI / dock: Initialize ACPI dock subsystem upfront
      PCI / ACPI: Use boot-time resource allocation rules during hotplug

Johan Hedberg (1):
      Bluetooth: Fix conditions for HCI_Delete_Stored_Link_Key

Johannes Berg (4):
      iwlwifi: don't print module loading error if not modular
      mac80211: work around broken APs not including HT info
      alx: add a simple AR816x/AR817x device driver
      nl80211: fix attrbuf access race by allocating a separate one

Jonas Jensen (1):
      ARM: 7760/1: cpu_fa526_do_idle: remove WFI

Josh Durgin (2):
      rbd: fetch object order before using it
      rbd: send snapshot context with writes

Julian Anastasov (1):
      ipvs: SCTP ports should be writable in ICMP packets

Konrad Rzeszutek Wilk (1):
      drm/i915: make compact dma scatter lists creation work with
SWIOTLB backend.

Krishna Mohan (1):
      libfcoe: Fix Conflicting FCFs issue in the fabric

Linus Lüssing (1):
      bridge: fix switched interval for MLD Query types

Linus Torvalds (1):
      Linux 3.10

Lorenzo Pieralisi (2):
      ARM: 7762/1: kernel: fix arm_dt_init_cpu_maps() to skip non-cpu nodes
      ARM: 7763/1: kernel: fix __cpu_logical_map default initialization

Lubomir Rintel (2):
      pxa168_eth: Allocate receive queue initialized to zero
      mv643xx_eth: Allocate receive queue initialized to zero

Marc Dietrich (1):
      mfd: tps6586x: correct device name of the regulator cell

Marc Kleine-Budde (1):
      can: usb_8dev: unregister netdev before free()ing

Mark Rustad (1):
      libfc: Correct check for initiator role

Masami Hiramatsu (1):
      kprobes: Fix arch_prepare_kprobe to handle copy insn failures

Mathias Krause (1):
      af_key: fix info leaks in notify messages

Mathieu Desnoyers (1):
      Fix: kernel/ptrace.c: ptrace_peek_siginfo() missing __put_user()
validation

Matthias Kaehlcke (1):
      Input: cyttsp - fix swapped mfg_stat and mfg_cmd registers

Matthias Schiffer (1):
      ipv6: ndisc: fix ndisc_send_redirect writing to the wrong skb

Maxim Patlasov (1):
      fuse: hold i_mutex in fuse_file_fallocate()

Michael Holzheu (1):
      s390/ipl: Fix FCP WWPN and LUN format strings for read

Michael S. Tsirkin (2):
      tun: fix recovery from gup errors
      macvtap: fix recovery from gup errors

Mika Westerberg (2):
      spi/pxa2xx: use GFP_ATOMIC in sg table allocation
      spi/pxa2xx: fix memory corruption due to wrong size used in devm_kzalloc()

Moshe Benji (1):
      iwlwifi: fix rate control regression

Mugunthan V N (2):
      drivers: net: cpsw: fix cpsw clock gating issue across suspend/resume
      drivers: net: cpsw: fix compilation error with cpsw driver

Neil Horman (2):
      libfc: extend ex_lock to protect all of fc_seq_send
      MAINTAINERS: Fix fcoe mailing list

Nicolas Schichan (1):
      net: fix kernel deadlock with interface rename and netdev name retrieval.

Nikolay Aleksandrov (1):
      bonding: fix slave speed reporting in bond_miimon_commit

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration

Olaf Hering (1):
      net: vlan: fix comment for vlan_ethhdr->h_vlan_proto

Oleg Nesterov (2):
      hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Olof Johansson (1):
      ARM: dt: Only print warning, not WARN() on bad cpu map in device tree

Pablo Neira Ayuso (1):
      netfilter: xt_TCPOPTSTRIP: don't use tcp_hdr()

Phil Oester (3):
      netfilter: xt_TCPMSS: Fix IPv6 default MSS too
      netfilter: xt_TCPMSS: Fix missing fragmentation handling
      netfilter: nf_conntrack_ipv6: Plug sk_buff leak in fragment handling

Ping Cheng (1):
      Input: wacom - add a new stylus (0x100802) for Intuos5 and Cintiqs

Rafael J. Wysocki (1):
      ACPI / dock / PCI: Synchronous handling of dock events for PCI devices

Randy Dunlap (1):
      fs: fix new splice.c kernel-doc warning

Robert Love (1):
      fcoe: Use correct API to set vlan tag for FCoE Ethertype skbs

Rojhalat Ibrahim (1):
      powerpc/pci: Fix boot panic on mpc83xx (regression)

Sebastian Ott (2):
      s390/dma: fix mapping_error detection
      s390/dma: support debug_dma_mapping_error

Sebastian Siewior (2):
      net: cpsw: check for cpts pointer after its allocation
      net: eth: davicnci_cpdma: check dma map error

Sergei Shtylyov (2):
      sh_eth: fix unhandled RFE interrupt
      sh_eth: fix misreporting of transmit abort

Shahed Shaikh (1):
      qlcnic: Do not sleep while holding spinlock

Shan Wei (1):
      tcp: doc : fix the syncookies default value

Shawn Joseph (1):
      Input: xpad - fix for "Mad Catz Street Fighter IV FightPad" controllers

Simon Baatz (1):
      ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU

Simon Wunderlich (2):
      mac80211: abort CAC in stop_ap()
      mac80211: Fix rate control mask matching call

Stanislaw Gruszka (2):
      iwlegacy: fix rate control regression
      rt2800: fix RT5390 & RT3290 TX power settings regression

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users

Sujith Manoharan (1):
      ath9k_htc: Handle IDLE state transition properly

Sylwester Nawrocki (1):
      spi: s3c64xx: Fix pm_runtime_get_sync() return value check

Thadeu Lima de Souza Cascardo (1):
      powerpc/eeh: Add eeh_dev to the cache during boot

YOSHIFUJI Hideaki / 吉藤英明 (1):
      ipv6: Process unicast packet with Router Alert by checking flag in skb.

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()

gurinder.shergill@hp.com (1):
      [SCSI] qla2xxx: Fix for locking issue between driver ISR and
mailbox routines

stephen hemminger (5):
      vxlan: fix race between flush and incoming learning
      vxlan: only migrate dynamic FDB entries
      vxlan: handle skb_clone failure
      vxlan: fix check for migration of static entry
      netlink: export netlink_diag.h header

wenxiong@linux.vnet.ibm.com (1):
      [SCSI] ipr: Avoid target_destroy accessing memory after it was freed
