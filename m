Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3EKSb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 14:31:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47295 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3EKSbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 14:31:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [3.5.y.z extended stable] Linux 3.5.7.12
Date: Sat, 11 May 2013 19:31:13 +0100
Message-Id: <1368297074-3578-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 3.5.7.12 tree of stable patches.

This tree picks up the latest 3.5 stable release upstream, and add patches
on top that were later marked for stable but can't be added to 3.5, as
it is not anymore an stable series maintained upstream.

The tree is maintained by the Ubuntu Kernel Team, with the intention
to continue to provide support for the 3.5 series. Anyone is welcomed
on using it or contributing to this effort.

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

The updated 3.5.y tree can be found at: 

  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

The diffstat and shortlog with changes since previous v3.5.7.11 release are
shown below.

-Luis

-- 
 Makefile                                           |   2 +-
 arch/arm/include/asm/pgtable.h                     |   9 ++
 arch/arm/kernel/perf_event.c                       |   5 +-
 arch/arm/kernel/sched_clock.c                      |   4 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |   5 +-
 arch/arm/mm/cache-feroceon-l2.c                    |   1 +
 arch/ia64/include/asm/futex.h                      |   5 +-
 arch/ia64/include/asm/mca.h                        |   1 +
 arch/ia64/kernel/irq.c                             |   8 ++
 arch/ia64/kernel/mca.c                             |  37 ++++---
 arch/ia64/kvm/vtlb.c                               |   2 +-
 arch/sparc/include/asm/pgtable_64.h                |   1 +
 arch/sparc/include/asm/switch_to_64.h              |   3 +-
 arch/sparc/include/asm/tlbflush_64.h               |  37 +++++--
 arch/sparc/kernel/smp_64.c                         |  41 ++++++-
 arch/sparc/mm/tlb.c                                |  39 ++++++-
 arch/sparc/mm/tsb.c                                |  57 +++++++---
 arch/sparc/mm/ultra.S                              | 119 ++++++++++++++++-----
 arch/x86/kernel/cpu/perf_event_intel.c             |  15 ++-
 arch/x86/xen/enlighten.c                           |   5 +-
 arch/x86/xen/smp.c                                 |   2 +
 arch/x86/xen/time.c                                |   6 +-
 crypto/algif_hash.c                                |   2 +
 crypto/algif_skcipher.c                            |   1 +
 drivers/acpi/pci_root.c                            |   4 +-
 drivers/char/hpet.c                                |  14 +--
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   5 -
 drivers/md/md.c                                    |   9 +-
 drivers/mtd/mtdchar.c                              |  23 +---
 drivers/net/bonding/bond_main.c                    |  10 ++
 drivers/net/can/mcp251x.c                          |  10 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      |  31 +++---
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |   2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   1 +
 drivers/net/ethernet/freescale/gianfar_ptp.c       |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  10 ++
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +-
 drivers/net/wireless/b43/phy_n.c                   |   3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |   5 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |  16 +--
 drivers/net/wireless/mwifiex/pcie.c                |   4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  10 +-
 drivers/pci/pci.c                                  |  12 +--
 drivers/regulator/core.c                           |  10 +-
 drivers/rtc/rtc-at91rm9200.c                       |  14 ++-
 drivers/rtc/rtc-cmos.c                             |   4 +-
 drivers/s390/char/sclp_cmd.c                       |   4 +-
 drivers/ssb/driver_chipcommon_pmu.c                |  29 +++++
 drivers/tty/pty.c                                  |   3 +
 drivers/tty/serial/serial_core.c                   |   4 +
 drivers/tty/tty_io.c                               |  14 ++-
 drivers/usb/chipidea/udc.c                         |   8 ++
 drivers/usb/chipidea/udc.h                         |   4 +-
 drivers/usb/core/devio.c                           |   2 +
 drivers/usb/misc/appledisplay.c                    |   1 +
 drivers/usb/serial/ftdi_sio.c                      |  23 ++--
 drivers/usb/serial/ftdi_sio_ids.h                  |   4 +-
 drivers/usb/serial/option.c                        |   8 ++
 drivers/usb/storage/cypress_atacb.c                |  16 ++-
 drivers/video/fbmem.c                              |  40 +++----
 fs/aio.c                                           |   2 +-
 fs/dcache.c                                        |   4 +-
 fs/exec.c                                          |   7 +-
 fs/ext4/Kconfig                                    |   3 +-
 fs/ext4/ext4_jbd2.h                                |   6 +-
 fs/ext4/fsync.c                                    |   3 +-
 fs/ext4/inode.c                                    |  11 +-
 fs/ext4/mballoc.c                                  |   8 +-
 fs/ext4/mmp.c                                      |   2 +-
 fs/ext4/resize.c                                   |   2 +
 fs/ext4/super.c                                    |   7 +-
 fs/fscache/stats.c                                 |   2 +-
 fs/hfsplus/extents.c                               |   2 +-
 fs/jbd2/commit.c                                   |  50 +++++----
 fs/jbd2/journal.c                                  |  31 ++++++
 fs/lockd/clntlock.c                                |   3 +
 fs/lockd/clntproc.c                                |   3 -
 fs/nfs/nfs4proc.c                                  |   6 ++
 fs/notify/inotify/inotify_user.c                   |   6 +-
 fs/sysfs/dir.c                                     |  15 ++-
 include/asm-generic/pgtable.h                      |  10 ++
 include/linux/ipc_namespace.h                      |   2 +-
 include/linux/jbd2.h                               |   2 +
 include/linux/mm.h                                 |   2 +
 include/linux/netdevice.h                          |   2 +-
 include/linux/sched.h                              |  18 +---
 include/linux/skbuff.h                             |   7 ++
 include/linux/socket.h                             |   3 +-
 include/linux/ssb/ssb_driver_chipcommon.h          |   2 +
 include/net/scm.h                                  |   2 +-
 ipc/shm.c                                          |   2 +-
 kernel/cgroup.c                                    |   2 +-
 kernel/events/core.c                               |   3 +-
 kernel/hrtimer.c                                   |   6 ++
 kernel/sched/core.c                                |   6 +-
 kernel/signal.c                                    |   2 +-
 kernel/time/tick-broadcast.c                       |   4 +
 kernel/time/tick-common.c                          |   1 +
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/trace.c                               |  64 +++++------
 kernel/trace/trace_selftest.c                      |   9 +-
 kernel/trace/trace_stack.c                         |  76 +++++++++++--
 kernel/trace/trace_stat.c                          |   2 +
 mm/hugetlb.c                                       |  12 ++-
 mm/memory.c                                        |  47 ++++++++
 mm/mmap.c                                          |   4 +-
 net/atm/common.c                                   |   2 +
 net/ax25/af_ax25.c                                 |   1 +
 net/bluetooth/af_bluetooth.c                       |   4 +-
 net/bluetooth/rfcomm/sock.c                        |   1 +
 net/caif/caif_socket.c                             |   2 +
 net/core/dev.c                                     |   4 +
 net/core/dev_addr_lists.c                          |   6 +-
 net/core/rtnetlink.c                               |   4 +-
 net/core/sock.c                                    |  14 ++-
 net/ipv4/esp4.c                                    |   6 +-
 net/ipv4/ip_fragment.c                             |  15 ++-
 net/ipv4/syncookies.c                              |   4 +-
 net/ipv4/tcp_input.c                               |  64 ++++++-----
 net/ipv4/tcp_output.c                              |   8 +-
 net/ipv6/addrconf.c                                |  27 +++++
 net/ipv6/reassembly.c                              |  13 ++-
 net/irda/af_irda.c                                 |   2 +
 net/iucv/af_iucv.c                                 |   2 +
 net/l2tp/l2tp_ip6.c                                |   1 +
 net/llc/af_llc.c                                   |   2 +
 net/netrom/af_netrom.c                             |   1 +
 net/nfc/llcp/sock.c                                |   2 +
 net/rose/af_rose.c                                 |   1 +
 net/sched/sch_cbq.c                                |   5 +-
 net/sctp/auth.c                                    |   2 +-
 net/tipc/socket.c                                  |   7 ++
 net/unix/af_unix.c                                 |   2 +-
 net/wireless/reg.c                                 |   2 +-
 sound/core/pcm_native.c                            |  12 +--
 136 files changed, 1028 insertions(+), 427 deletions(-)

Adrian Thomasset (2):
      USB: ftdi_sio: correct ST Micro Connect Lite PIDs
      USB: ftdi_sio: enable two UART ports on ST Microconnect Lite

Alex A. Mihaylov (1):
      rt2x00: Fix transmit power troubles on some Ralink RT30xx cards

Andrzej Hajda (1):
      regulator: fixed regulator_bulk_enable unwinding code

Anurup m (1):
      fs/fscache/stats.c: fix memory leak

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after loopback down-up

Ben Greear (1):
      net: rate-limit warn-bad-offload splats.

Ben Jencks (1):
      usb/misc/appledisplay: Add 24" LED Cinema display

Bjørn Mork (1):
      USB: option: add a D-Link DWM-156 variant

Catalin Marinas (1):
      arm: set the page table freeing ceiling to TASK_SIZE

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems

Daniel Borkmann (1):
      net: sctp: sctp_auth_key_put: use kzfree instead of kfree

Daniel Lezcano (1):
      ARM: omap3: cpuidle: enable time keeping

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

David S. Miller (1):
      sparc64: Fix race in TLB batch processing.

Derek Basehore (1):
      drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

Dmitry Monakhov (3):
      jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_callback
      ext4: fix journal callback list traversal
      ext4: fix big-endian bug in metadata checksum calculations

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under synflood

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send zeroed LQ cmd

Eric Dumazet (2):
      tcp: call tcp_replace_ts_recent() from tcp_ack()
      net: drop dst before queueing fragments

Eric W. Biederman (1):
      af_unix: If we don't care about credentials coallesce all messages

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()

Felix Fietkau (2):
      ath9k_htc: accept 1.x firmware newer than 1.3
      ath9k_hw: change AR9580 initvals to fix a stability issue

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145

Greg Thelen (1):
      fs/dcache.c: add cond_resched() to shrink_dcache_parent()

Hannes Frederic Sowa (1):
      atl1e: limit gso segment size to prevent generation of wrong ip length fields

Hans de Goede (1):
      usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep

Heiko Carstens (1):
      s390/memory hotplug: prevent offline of active memory increments

Hugh Dickins (1):
      mm: allow arch code to control the user page table ceiling

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon

Jacob Keller (1):
      ixgbe: fix EICR write in ixgbe_msix_other

Jiri Slaby (2):
      TTY: do not update atime/mtime on read/write
      TTY: fix atime/mtime regression

Johan Hovold (1):
      drivers/rtc/rtc-at91rm9200.c: fix missing iounmap

Johannes Berg (1):
      wireless: regulatory: fix channel disabling race condition

Konrad Rzeszutek Wilk (3):
      xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.

Li Zefan (1):
      cgroup: fix an off-by-one bug which may trigger BUG_ON()

Linus Torvalds (7):
      vm: add vm_iomap_memory() helper function
      vm: convert HPET mmap to vm_iomap_memory() helper
      vm: convert fb_mmap to vm_iomap_memory() helper
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
      vm: convert mtdchar mmap to vm_iomap_memory() helper
      net: fix incorrect credentials passing
      tty: fix up atime/mtime mess, take three

Luis Henriques (2):
      Revert "drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline waits"
      Linux 3.5.7.12

Marc Kleine-Budde (1):
      can: mcp251x: add missing IRQF_ONESHOT to request_threaded_irq

Mathias Krause (14):
      crypto: algif - suppress sending source address information in recvmsg
      atm: update msg_namelen in vcc_recvmsg()
      ax25: fix info leak via msg_name in ax25_recvmsg()
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
      Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_recvmsg()
      caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
      irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
      netrom: fix info leak via msg_name in nr_recvmsg()
      NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      tipc: fix info leaks via msg_name in recv_msg/recv_stream
      l2tp: fix info leak in l2tp_ip6_recvmsg()

Michael Grzeschik (2):
      usb: chipidea: udc: fix memory access of shared memory on armv5 machines
      usb: chipidea: udc: fix memory leak in _ep_nuke

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header length

Ming Lei (1):
      sysfs: fix use after free in case of concurrent read/write and readdir

Namhyung Kim (3):
      tracing: Fix off-by-one on allocating stat->pages
      tracing: Reset ftrace_graph_filter_enabled if count is zero
      tracing: Check return value of tracing_init_dentry()

Naoya Horiguchi (1):
      hugetlbfs: add swap entry check in follow_hugetlb_page()

NeilBrown (1):
      md: bad block list should default to disabled.

Oleg Nesterov (1):
      exec: do not abuse ->cred_guard_mutex in threadgroup_lock()

Patrick McHardy (1):
      netfilter: don't reset nf_trace in nf_reset()

Prarit Bhargava (1):
      hrtimer: Add expiry time overflow check in hrtimer_interrupt

Rafael J. Wysocki (1):
      PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()

Rafał Miłecki (1):
      ssb: implement spurious tone avoidance

Richard Cochran (1):
      gianfar: do not advertise any alarm capability.

Robin Holt (1):
      ipc: sysv shared memory limited to 8TiB

Stanislaw Gruszka (1):
      iwlwifi: fix freeing uninitialized pointer

Stefani Seibold (1):
      USB: add ftdi_sio USB ID for GDM Boost V1.x

Stephan Schreiber (2):
      Wrong asm register contraints in the futex implementation
      Wrong asm register contraints in the kvm implementation

Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Stephen Boyd (1):
      ARM: 7699/1: sched_clock: Add more notrace to prevent recursion

Steven Rostedt (Red Hat) (4):
      tracing: Use stack of calling function for stack tracer
      tracing: Fix stack tracer with fentry use
      tracing: Remove most or all of stack tracer stack size from stack_max_size
      tracing: Fix ftrace_dump()

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Theodore Ts'o (3):
      ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
      ext4: fix online resizing for ext3-compat file systems
      ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG

Thomas Gleixner (1):
      clockevents: Set dummy handler on CPU_DEAD shutdown

Thomas Graf (1):
      tcp: Reallocate headroom if it would overflow csum_start

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()

Tony Luck (1):
      Fix initialization of CMCI/CMCP interrupts

Tormod Volden (1):
      usb-storage: CY7C68300A chips do not support Cypress ATACB

Trond Myklebust (2):
      NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_open_delegation_recall
      LOCKD: Ensure that nlmclnt_block resets block->b_status after a server reboot

Vasily Averin (1):
      cbq: incorrect processing of high limits

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works properly.

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Wei Yongjun (3):
      perf: Fix error return code
      netrom: fix invalid use of sizeof in nr_recvmsg()
      esp4: fix error return code in esp_output()

Will Deacon (1):
      ARM: 7698/1: perf: fix group validation when using enable_on_exec

Yinghai Lu (1):
      PCI / ACPI: Don't query OSC support with all possible controls

Yogesh Ashok Powar (2):
      mwifiex: Use pci_release_region() instead of a pci_release_regions()
      mwifiex: Call pci_release_region after calling pci_disable_device

Zhao Hongjiang (2):
      aio: fix possible invalid memory access when DEBUG is enabled
      inotify: invalid mask should return a error number but not set it

nikolay@redhat.com (2):
      bonding: fix bonding_masters race condition in bond unloading
      bonding: IFF_BONDING is not stripped on enslave failure

