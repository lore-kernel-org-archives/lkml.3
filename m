Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaGUEW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 00:22:56 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:34939 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaGUEWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 00:22:53 -0400
MIME-Version: 1.0
Date: Sun, 20 Jul 2014 21:22:52 -0700
X-Google-Sender-Auth: Ka8FQUx8IC2_UhMpoqcaYH47V7k
Message-ID: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
Subject: Linux 3.16-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Week by week, we're getting to what is supposed to be the last rc's,
but quite frankly, things aren't calming down the way they are
supposed to.

That was already true for rc5 - it was bigger than rc4. That didn't
worry me all that much, because rc4 was really pretty small. But now
rc6 is out, and it's bigger than rc5 was, and it's not even all
trivial stuff.

That's not how this is all supposed to work.

Anyway, rc6 still isn't all *that* big, so I'm not exactly worried,
but I am getting to the point where I'm going to start calling people
names and shouting at you if you send me stuff that isn't appropriate
for the late rc releases. Which is not to say that people did: while
rc6 is bigger than I wished for, I don't think there's too much
obviously frivolous in there. But I'll be keepign an eye out, and I'll
be starting to get grumpy (or grumpiER) if I notice that peopel aren't
being serious about trying to calm things down.

Regardless, rc6 itself ends up having changes pretty much all over:
drivers (much of it networking, but there's gpu, there's infiniband,
you name it), filesystems (late nfs fixes, xfs, fuse, gfs2, btrfs),
core networking code, etc etc. The shortlog is appended for those
interested in (an overview of) the details.

So go get the latest rc and kick the tires, to see that nothing has
fallen through the cracks, ok?

             Linus

---

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID 0x10de0070 to snd-hda

Abbas Raza (1):
      usb: chipidea: udc: Disable auto ZLP generation on ep0

Alex Deucher (2):
      drm/radeon: avoid leaking edid data
      drm/radeon: set default bl level to something reasonable

Alex Wang (1):
      openvswitch: Use exact lookup for flow_get and flow_del.

Alexander Aring (2):
      ieee802154: reassembly: fix possible buffer overflow
      MAINTAINERS: change IEEE 802.15.4 maintainer

Alexey Khoroshilov (1):
      farsync: fix invalid memory accesses in fst_add_one() and fst_init_card()

Amir Vadai (4):
      net/mlx4_en: Don't use irq_affinity_notifier to track changes in
IRQ affinity map
      lib/cpumask: cpumask_set_cpu_local_first to use all cores when
numa node is not defined
      net/mlx4_en: IRQ affinity hint is not cleared on port down
      net/mlx4_en: Ignore budget on TX napi polling

Amit Shah (2):
      hwrng: fetch randomness only after device init
      hwrng: virtio - ensure reads happen after successful probe

Amitkumar Karwar (2):
      mwifiex: fix Tx timeout issue
      mwifiex: initialize Tx/Rx info of a packet correctly

Amritha Nambiar (1):
      GRE: enable offloads for GRE

Anand Avati (1):
      fuse: ignore entry-timeout on LOOKUP_REVAL

Andrea Adami (1):
      mtd: cfi_cmdset_0001.c: add support for Sharp LH28F640BF NOR

Andrea Merello (1):
      rt2800usb: Don't perform DMA from stack

Andrey Utkin (1):
      appletalk: Fix socket referencing in skb

Andy Zhou (1):
      openvswitch: Fix a double free bug for the sample action

Ard Biesheuvel (1):
      efi/arm64: efistub: remove local copy of linux_banner

Arend van Spriel (1):
      brcmfmac: assign chip id and rev in bus interface after brcmf_usb_dlneeded

Arik Nemtsov (1):
      Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"

Axel Lin (2):
      hwmon: (da9052) Don't use dash in the name attribute
      hwmon: (da9055) Don't use dash in the name attribute

Bartosz Markowski (1):
      ath10k: fix 8th virtual AP interface with DFS

Ben Pfaff (2):
      openvswitch: Fix tracking of flags seen in TCP flows.
      netlink: Fix handling of error from netlink_dump().

Benjamin LaHaise (1):
      aio: protect reqs_available updates from changes in interrupt handlers

Bernd Wachter (1):
      net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2

Bo Shen (1):
      ARM: at91: at91sam9x5: correct typo error for ohci clock

Bob Peterson (3):
      GFS2: Only wait for demote when last holder is dequeued
      GFS2: Allow flocks to use normal glock dq rather than dq_wait
      GFS2: Allow caching of glocks for flock

Boris BREZILLON (2):
      ARM: at91/dt: fix usb0 clocks definition in sam9n12 dtsi
      ARM: at91/dt: add missing clocks property to pwm node in sam9x5.dtsi

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

Brian Norris (1):
      UBI: fastmap: do not miss bit-flips

Brian W Hart (1):
      cpufreq: make table sentinel macros unsigned to match use

Catalin Marinas (1):
      efi: fdt: Do not report an error during boot if UEFI is not available

Christoph Hellwig (1):
      nfs: only show Posix ACLs in listxattr if actually present

Christoph Paasch (1):
      tcp: Fix divide by zero when pushing during tcp-repair

Christoph Schulz (2):
      net: pppoe: use correct channel MTU when using Multilink PPP
      net: ppp: don't call sk_chk_filter twice

Daniel Borkmann (1):
      net: sctp: fix information leaks in ulpevent layer

Daniel Mack (1):
      net: fix circular dependency in of_mdio code

Daniel Vetter (2):
      Revert "drm/i915: Don't set the 8to6 dither flag when not scaling"
      drm/i915: Track the primary plane correctly when reassigning planes

Darren Hart (1):
      ACPI / documentation: Remove reference to
acpi_platform_device_ids from enumeration.txt

Dave Airlie (1):
      Revert "drm/i915: reverse dp link param selection, prefer fast
over wide again"

Dave Chinner (3):
      Revert "xfs: block allocation work needs to be kswapd aware"
      xfs: refine the allocation stack switch
      xfs: null unused quota inodes when quota is on

David S. Miller (1):
      Revert "net: stmmac: add platform init/exit for Altera's ARM socfpga"

David Vrabel (4):
      xen/manage: fix potential deadlock when resuming the console
      xen/balloon: set ballooned out pages as invalid in p2m
      xen-netfront: don't nest queue locks in xennet_connect()
      xen-netfront: call netif_carrier_off() only once when disconnecting

Davidlohr Bueso (1):
      locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER

Denis Kirjanov (2):
      powerpc: bpf: Use correct mask while accessing the VLAN tag
      powerpc: bpf: Fix the broken LD_VLAN_TAG_PRESENT test

Dexuan Cui (1):
      Drivers: hv: hv_fcopy: fix a race condition for SMP guest

Dmitry Popov (1):
      ip_tunnel: fix ip_tunnel_lookup

Edward Allcutt (1):
      ipv4: icmp: Fix pMTU handling for rare case

Eliad Peller (2):
      cfg80211: fix elapsed_jiffies calculation
      iwlwifi: mvm: rework sched scan channel configuration

Emmanuel Grumbach (2):
      iwlwifi: dvm: don't enable CTS to self
      iwlwifi: mvm: disable CTS to Self

Eric Dumazet (4):
      ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix
      bnx2x: fix possible panic under memory stress
      vlan: free percpu stats in device destructor
      net: fix sparse warning in sk_dst_set()

Eric Sandeen (1):
      btrfs: test for valid bdev before kobj removal in btrfs_rm_device

Ezequiel Garcia (1):
      ARM: mvebu: Fix coherency bus notifiers by using separate notifiers

Fabian Frederick (3):
      fuse: replace count*size kzalloc by kcalloc
      GFS2: replace count*size kzalloc by kcalloc
      GFS2: fs/gfs2/rgrp.c: kernel-doc warning fixes

Florian Fainelli (7):
      net: systemport: do not clear IFF_MULTICAST flag
      net: systemport: fix UniMAC reset logic
      net: systemport: fix TX NAPI work done return value
      net: bcmgenet: disable clock before register_netdev
      net: bcmgenet: start with carrier off
      net: bcmgenet: do not set packet length for RX buffers
      net: bcmgenet: fix RGMII_MODE_EN bit

Gavin Guo (1):
      usb: Check if port status is equal to RxDetect

Geert Uytterhoeven (2):
      firewire: IEEE 1394 (FireWire) support should depend on HAS_DMA
      GFS2: memcontrol: Spelling s/invlidate/invalidate/

Gregory CLEMENT (1):
      ARM: mvebu: Fix the operand list in the inline asm of
armada_370_xp_pmsu_idle_enter

Guenter Roeck (3):
      sched: Fix compiler warnings
      platform_get_irq: Revert to platform_get_resource if of_irq_get fails
      hwmon: (adt7470) Fix writes to temperature limit registers

HATAYAMA Daisuke (1):
      perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Hangbin Liu (1):
      ipv6: Fix MLD Query message check

Hannes Frederic Sowa (1):
      random: check for increase of entropy_count because of signed conversion

Hans de Goede (1):
      ACPI / video: Add use_native_backlight quirk for HP ProBook 4540s

Hariprasad S (2):
      RDMA/cxgb4: Fix skb_leak in reject_cr()
      RDMA/cxgb4: Clean up connection on ARP error

Heiko Schocher (1):
      UBI: fix the volumes tree sorting criteria

Himangi Saraogi (1):
      fuse: inode: drop cast

Ilan Peer (1):
      iwlwifi: mvm: Fix broadcast filtering

James M Leddy (1):
      udp: Add MIB counters for rcvbuferrors

Jason Low (6):
      locking/rwsem: Allow conservative optimistic spinning when
readers have lock
      locking/spinlocks/mcs: Rename optimistic_spin_queue() to
optimistic_spin_node()
      locking/spinlocks/mcs: Convert osq lock to atomic_t to reduce overhead
      locking/spinlocks/mcs: Introduce and use init macro and function
for osq locks
      locking/spinlocks/mcs: Micro-optimize osq_unlock()
      locking/rwsem: Reduce the size of struct rw_semaphore

Jason Wang (2):
      mlx4: mark napi id for gro_skb
      drm/qxl: return IRQ_NONE if it was not our irq

Jiri Olsa (2):
      perf tools: Fix segfault in cumulative.callchain report
      perf: Do not allow optimized switch for non-cloned events

Johan Hedberg (3):
      Bluetooth: Fix overriding higher security level in SMP
      Bluetooth: Refactor authentication method lookup into its own function
      Bluetooth: Fix rejecting pairing in case of insufficient capabilities

Johannes Berg (2):
      Revert "cfg80211: Use 5MHz bandwidth by default when checking
usable channels"
      nl80211: move set_qos_map command into split state

John Stultz (1):
      alarmtimer: Fix bug where relative alarm timers were treated as absolute

Jon Paul Maloy (2):
      tipc: fix bug in multicast/broadcast message reassembly
      tipc: clear 'next'-pointer of message fragments before reassembly

Joonyoung Shim (1):
      usbnet: smsc95xx: add reset_resume function with reset operation

Linus Torvalds (1):
      Linux 3.16-rc6

Linus Walleij (1):
      cpufreq: sa1110: set memory type for h3600

Liu Bo (1):
      Btrfs: fix abnormal long waiting in fsync

Loic Poulain (1):
      Bluetooth: Ignore H5 non-link packets in non-active state

Loic Prylli (1):
      net: Fix NETDEV_CHANGE notifier usage causing spurious arp flush

Lucas Stach (1):
      ARM: clk-imx6q: parent lvds_sel input from upstream clock gates

Lukasz Rymanowski (1):
      Bluetooth: Fix for ACL disconnect when pairing fails

Maciej W. Rozycki (2):
      defxx: Remove an incorrectly inverted preprocessor conditional
      defxx: Fix !DYNAMIC_BUFFERS compilation warnings

Marcel Holtmann (1):
      Revert "Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012."

Mario Kleiner (4):
      drm/radeon: Prevent too early kms-pageflips triggered by vblank.
      drm/radeon: Remove redundant fence unref in pageflip path.
      drm/radeon: Add missing vblank_put in pageflip ioctl error path.
      drm/radeon: Make classic pageflip completion path less racy.

Martin Fuzzey (1):
      iio: mma8452: Use correct acceleration units.

Martin Lau (1):
      ring-buffer: Fix polling on trace_pipe

Martin Peres (1):
      drm/nouveau/therm: fix a potential deadlock in the therm monitoring code

Mateusz Guzik (1):
      sched: Fix possible divide by zero in avg_atom() calculation

Mathias Krause (1):
      neigh: sysctl - simplify address calculation of gc_* variables

Matthias Brugger (1):
      irqchip: gic: Add support for cortex a7 compatible string

Max Stepanov (1):
      mac80211: WEP extra head/tail room in ieee80211_send_auth

Maxim Patlasov (1):
      fuse: release temporary page if fuse_writepage_locked() failed

Michael Brown (1):
      x86/efi: Include a .bss section within the PE/COFF headers

Michael Welling (1):
      gpio: mcp23s08: Eliminates redundant checking.

Michal Kazior (1):
      ath10k: remove unnecessary htt rx corruption check

Michel Dänzer (2):
      drm/radeon: Move pinning the BO back to radeon_crtc_page_flip()
      drm/radeon: Complete page flip even if waiting on the BO fence fails

Mike Snitzer (2):
      dm thin metadata: do not allow the data block size to change
      dm cache metadata: do not allow the data block size to change

Miklos Szeredi (4):
      fuse: timeout comparison fix
      fuse: handle large user and group ID
      fuse: avoid scheduling while atomic
      fuse: restructure ->rename2()

Nicolas Del Piano (1):
      cpufreq: imx6q: Select PM_OPP

Nikolay Aleksandrov (1):
      bonding: fix ad_select module param check

Niu Yawei (1):
      quota: missing lock in dqcache_shrink_scan()

Oleg Nesterov (1):
      tracing: instance_rmdir() leaks ftrace_event_file->filter

Olivier Sobrie (2):
      hso: remove unused workqueue
      hso: fix deadlock when receiving bursts of data

Or Gerlitz (2):
      net/mlx4_en: Don't configure the HW vxlan parser when vxlan
offloading isn't set
      IB/mlx5: Enable "block multicast loopback" for kernel consumers

Oren Givon (1):
      iwlwifi: update the 7265 series HW IDs

Paul Bolle (1):
      x86: Remove unused variable "polling"

Paul E. McKenney (2):
      rcu: Export debug_init_rcu_head() and and debug_init_rcu_head()
      rcu: Reduce overhead of cond_resched() checks for RCU

Peter Zijlstra (3):
      x86, tsc: Fix cpufreq lockup
      locking/rwsem: Rename 'activity' to 'count'
      locking/mutex: Disable optimistic spinning on some architectures

Quentin Armitage (1):
      cpufreq: kirkwood: Reinstate cpufreq driver for ARCH_KIRKWOOD

Rafael J. Wysocki (1):
      Revert "ACPI / video: change acpi-video
brightness_switch_enabled default to 0"

Richard Weinberger (4):
      Revert "um: Fix wait_stub_done() error handling"
      um: Ensure that a stub page cannot get unmapped
      um: Fix hung task in fix_range_common()
      um: segv: Save regs only in case of a kernel mode fault

Rickard Strandqvist (1):
      isdn: hisax: l3ni1.c: Fix for possible null pointer dereference

S. Lockwood-Childs (1):
      tools/liblockdep: Account for bitfield changes in lockdeps lock_acquire

Sagi Grimberg (1):
      mlx5_core: Fix possible race between mr tree insert/delete

Sasha Levin (2):
      tools/liblockdep: Remove debug print left over from development
      net/l2tp: don't fall back on UDP [get|set]sockopt

Scot Doyle (1):
      drm/i915: Ignore VBT backlight presence check on HP Chromebook 14

Simon Que (1):
      perf symbols: Get kernel start address by symbol name

Srinivas Pandruvada (1):
      iio:core: Handle error when mask type is not separate

Stefan Assmann (1):
      igb: do a reset on SR-IOV re-init if device is down

Stefan Sørensen (1):
      dp83640: Always decode received status frames

Steve Wise (2):
      RDMA/cxgb4: Initialize the device status page
      RDMA/cxgb4: Call iwpm_init() only once

Steven Rostedt (Red Hat) (1):
      tracing: Fix graph tracer with stack tracer on other archs

Steven Whitehouse (2):
      GFS2: Fix race in glock lru glock disposal
      GFS2: Use GFP_NOFS when allocating glocks

Suravee Suthikulpanit (1):
      irqchip: gic: Add binding probe for ARM GIC400

Suresh Reddy (1):
      be2net: set EQ DB clear-intr bit in be_open()

Takashi Iwai (3):
      ALSA: hda - Revert stream assignment order for Intel controllers
      PM / sleep: Fix request_firmware() error at resume
      ALSA: hda - Fix broken PM due to incomplete i915 initialization

Ted Juan (1):
      mtd: devices: elm: fix elm_context_save() and
elm_context_restore() functions

Thierry Reding (1):
      ALSA: hda: Fix build warning

Thomas Fitzsimmons (1):
      net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()

Thomas Petazzoni (3):
      ARM: mvebu: fix SMP boot for Armada 38x and Armada 375 Z1 in big endian
      net: mvneta: fix operation in 10 Mbit/s mode
      mtd: nand: reduce the warning noise when the ECC is too weak

Todd Fujinaka (1):
      igb: Workaround for i210 Errata 25: Slow System Clock

Tom Herbert (1):
      net: Performance fix for process_backlog

Tomasz Figa (2):
      irqchip: gic: Fix core ID calculation when topology is read from DT
      ARM: EXYNOS: Fix core ID used by platsmp and hotplug code

Trond Myklebust (2):
      NFS: Remove 2 unused variables
      NFS: Don't reset pg_moreio in __nfs_pageio_add_request

Varun Sethi (3):
      iommu/fsl: Fix PAMU window size check.
      iommu/fsl: Fix the device domain attach condition.
      iommu/fsl: Fix the error condition during iommu group

Vince Bridgers (3):
      net: stmmac: add platform init/exit for Altera's ARM socfpga
      net: stmmac: Correct duplicate if/then/else case found by cppcheck
      net: stmmac: Remove unneeded I/O read caught by cppcheck

Viresh Kumar (2):
      cpufreq: cpu0: OPPs can be populated at runtime
      cpufreq: move policy kobj to policy->cpu at resume

Wei Zhang (1):
      openvswitch: supply a dummy err_handler of gre_cisco_protocol to
prevent kernel crash

Weston Andros Adamson (5):
      nfs: mark nfs_page reqs with flag for extra ref
      nfs: nfs_page should take a ref on the head req
      nfs: change find_request to find_head_request
      nfs: handle multiple reqs in nfs_page_async_flush
      nfs: handle multiple reqs in nfs_wb_page_cancel

Yijing Wang (1):
      bnx2x: Fix the MSI flags

Yuchung Cheng (1):
      tcp: fix false undo corner cases

Zhang Rui (1):
      PM / sleep: fix freeze_ops NULL pointer dereferences

Zhao Qiang (1):
      powerpc/ucc_geth: deal with a compile warning

dingtianhong (1):
      igmp: fix the problem when mc leave group

françois romieu (1):
      MAINTAINERS: update r8169 maintainer

hayeswang (3):
      r8152: wake up the device before dumping the hw counter
      r8169: disable L23
      r8152: fix r8152_csum_workaround function

zhangdianfang (1):
      tools/liblockdep: Fix comparison of a boolean value with a value of 2

zhangwei(Jovi) (2):
      tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
      tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs
