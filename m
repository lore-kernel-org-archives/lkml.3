Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3EJVbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:31:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3EJVbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:31:01 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=zmWEv6NRrQlQwPHe9Q4A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=LNAhOsk1euzRQumX:21 a=ym0FjWZFiF05YpkB:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368221459.6828.0.camel@gandalf.local.home>
Subject: Linux 3.6.11.3
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Date: Fri, 10 May 2013 17:30:59 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm announcing the release of the 3.6.11.3 kernel.

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.3.xz

thanks,

-- Steve

 Makefile                                           |    2 +-
 arch/alpha/kernel/sys_nautilus.c                   |    5 ++
 arch/arm/include/asm/hardware/iop3xx.h             |    2 +-
 arch/arm/kernel/perf_event.c                       |    5 +-
 arch/arm/kernel/sched_clock.c                      |    4 +-
 arch/arm/mach-imx/clk-imx35.c                      |    2 +
 arch/arm/mm/cache-feroceon-l2.c                    |    1 +
 arch/arm/mm/proc-arm920.S                          |    2 +-
 arch/arm/mm/proc-arm926.S                          |    2 +-
 arch/arm/mm/proc-mohawk.S                          |    2 +-
 arch/arm/mm/proc-sa1100.S                          |    2 +-
 arch/arm/mm/proc-v6.S                              |    2 +-
 arch/arm/mm/proc-xsc3.S                            |    2 +-
 arch/arm/mm/proc-xscale.S                          |    2 +-
 arch/powerpc/platforms/pseries/lpar.c              |    8 ++-
 arch/x86/boot/compressed/Makefile                  |    5 +-
 arch/x86/include/asm/kvm_host.h                    |    4 +-
 arch/x86/include/asm/paravirt.h                    |    5 +-
 arch/x86/include/asm/paravirt_types.h              |    2 +
 arch/x86/include/asm/syscall.h                     |    4 +-
 arch/x86/include/asm/tlb.h                         |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   20 ++++--
 arch/x86/kernel/paravirt.c                         |   25 ++++----
 arch/x86/kvm/lapic.c                               |    2 +-
 arch/x86/kvm/x86.c                                 |   45 ++++++-------
 arch/x86/lguest/boot.c                             |    1 +
 arch/x86/mm/fault.c                                |    6 +-
 arch/x86/mm/pgtable.c                              |    7 ++
 arch/x86/xen/mmu.c                                 |    1 +
 block/blk-sysfs.c                                  |    2 +
 crypto/algif_hash.c                                |    2 +
 crypto/algif_skcipher.c                            |    1 +
 crypto/gcm.c                                       |   17 ++++-
 drivers/ata/ata_piix.c                             |   11 ++++
 drivers/ata/libata-core.c                          |    4 ++
 drivers/base/regmap/regcache-rbtree.c              |    2 +-
 drivers/char/hpet.c                                |   14 +---
 drivers/cpufreq/exynos-cpufreq.c                   |    4 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    2 +-
 drivers/eisa/pci_eisa.c                            |   67 ++++++++++++++------
 drivers/gpu/drm/i915/intel_display.c               |    9 +++
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   13 +---
 drivers/gpu/drm/udl/udl_connector.c                |    4 ++
 drivers/hwspinlock/hwspinlock_core.c               |    2 +
 drivers/mtd/mtdchar.c                              |   38 ++---------
 drivers/net/bonding/bond_main.c                    |   10 +++
 drivers/net/can/mcp251x.c                          |   10 ++-
 drivers/net/can/sja1000/sja1000_of_platform.c      |   31 +++++----
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    1 +
 drivers/net/ethernet/broadcom/tg3.c                |   18 +++++-
 drivers/net/ethernet/broadcom/tg3.h                |    2 +
 drivers/net/ethernet/realtek/r8169.c               |   28 +++++++-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/b43/phy_n.c                   |    3 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |    4 +-
 drivers/pci/pcie/portdrv_pci.c                     |   13 ----
 drivers/platform/x86/msi-wmi.c                     |    4 +-
 drivers/remoteproc/Kconfig                         |    2 +-
 drivers/remoteproc/remoteproc_core.c               |    4 +-
 drivers/scsi/libsas/sas_expander.c                 |   12 ++++
 drivers/spi/spi-mpc512x-psc.c                      |    2 +-
 drivers/spi/spi-s3c64xx.c                          |   41 +++++++-----
 drivers/ssb/driver_chipcommon_pmu.c                |   29 +++++++++
 drivers/target/target_core_alua.c                  |    3 +
 drivers/thermal/thermal_sys.c                      |    1 +
 drivers/tty/tty_io.c                               |   14 +++-
 drivers/vfio/pci/vfio_pci.c                        |    3 +-
 drivers/video/fbmem.c                              |   40 ++++--------
 fs/aio.c                                           |    2 +-
 fs/btrfs/tree-log.c                                |   48 ++++++++++++--
 fs/cifs/connect.c                                  |   16 ++++-
 fs/gfs2/file.c                                     |    5 +-
 fs/hfsplus/extents.c                               |    2 +-
 fs/inode.c                                         |    2 +-
 fs/ubifs/super.c                                   |   12 ++--
 include/asm-generic/tlb.h                          |    7 +-
 include/linux/ata.h                                |    2 +-
 include/linux/capability.h                         |    2 +
 include/linux/ftrace.h                             |    3 +-
 include/linux/kref.h                               |   21 ++++++
 include/linux/kvm_host.h                           |    2 +-
 include/linux/kvm_types.h                          |    1 +
 include/linux/libata.h                             |    1 +
 include/linux/mm.h                                 |    2 +
 include/linux/netdevice.h                          |    2 +-
 include/linux/preempt.h                            |   22 ++++---
 include/linux/socket.h                             |    3 +-
 include/linux/spinlock_up.h                        |   29 +++++----
 include/linux/ssb/ssb_driver_chipcommon.h          |    2 +
 include/net/scm.h                                  |    2 +-
 kernel/capability.c                                |   24 +++++++
 kernel/events/core.c                               |    2 +-
 kernel/hrtimer.c                                   |    3 +-
 kernel/sched/clock.c                               |   26 ++++++++
 kernel/sched/core.c                                |    6 +-
 kernel/signal.c                                    |    2 +-
 kernel/sys.c                                       |    3 +-
 kernel/trace/ftrace.c                              |   21 +++---
 kernel/trace/trace_stack.c                         |    2 +-
 lib/kobject.c                                      |    9 ++-
 mm/hugetlb.c                                       |   12 +++-
 mm/memory.c                                        |   48 ++++++++++++++
 mm/mmap.c                                          |    2 +-
 mm/nommu.c                                         |    2 +-
 net/atm/common.c                                   |    2 +
 net/ax25/af_ax25.c                                 |    1 +
 net/bluetooth/af_bluetooth.c                       |    4 +-
 net/bluetooth/rfcomm/sock.c                        |    1 +
 net/caif/caif_socket.c                             |    2 +
 net/can/gw.c                                       |    6 +-
 net/core/dev.c                                     |    3 +
 net/core/dev_addr_lists.c                          |    6 +-
 net/core/rtnetlink.c                               |    4 +-
 net/core/sock.c                                    |   14 ++--
 net/ipv4/esp4.c                                    |    6 +-
 net/ipv4/ip_fragment.c                             |   15 +++--
 net/ipv4/syncookies.c                              |    4 +-
 net/ipv4/tcp_input.c                               |   65 ++++++++++---------
 net/ipv4/tcp_output.c                              |    8 ++-
 net/ipv6/addrconf.c                                |   27 ++++++++
 net/ipv6/reassembly.c                              |   13 +++-
 net/ipv6/tcp_ipv6.c                                |    1 +
 net/irda/af_irda.c                                 |    2 +
 net/iucv/af_iucv.c                                 |    2 +
 net/l2tp/l2tp_ip6.c                                |    1 +
 net/llc/af_llc.c                                   |    2 +
 net/mac80211/cfg.c                                 |    6 +-
 net/mac80211/ieee80211_i.h                         |    3 +-
 net/mac80211/mlme.c                                |   24 +++++--
 net/mac80211/offchannel.c                          |   23 +++++--
 net/netrom/af_netrom.c                             |    1 +
 net/nfc/llcp/sock.c                                |    2 +
 net/rose/af_rose.c                                 |    1 +
 net/sched/sch_cbq.c                                |    5 +-
 net/tipc/socket.c                                  |    7 ++
 net/unix/af_unix.c                                 |    2 +-
 sound/core/pcm_native.c                            |   12 +---
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/patch_realtek.c                      |    4 +-
 sound/soc/codecs/wm8903.c                          |    2 +
 sound/soc/fsl/imx-ssi.c                            |    5 ++
 sound/soc/sh/dma-sh7760.c                          |    4 +-
 sound/soc/spear/spear_pcm.c                        |   12 ++--
 sound/usb/mixer_quirks.c                           |    4 +-
 sound/usb/quirks.c                                 |    2 +-
 virt/kvm/ioapic.c                                  |    7 +-
 virt/kvm/kvm_main.c                                |   47 +++++++++++---
 150 files changed, 942 insertions(+), 420 deletions(-)
---------------------------
Aaro Koskinen (1):
      ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running

Alex Williamson (1):
      vfio-pci: Fix possible integer overflow

Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.

Andy Honig (3):
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
      KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache functions (CVE-2013-1797)
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)

Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after loopback down-up

Ben Greear (1):
      net: rate-limit warn-bad-offload splats.

Boris Ostrovsky (1):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems

Christoph Paasch (1):
      ipv6/tcp: Stop processing ICMPv6 redirect messages

Christopher Harvey (1):
      drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal.

Dave Airlie (1):
      udl: handle EDID failure properly.

Dave Hansen (1):
      x86-32: Fix possible incomplete TLB invalidate with PAE pagetables

David Henningsson (1):
      ALSA: hda - fix typo in proc output

David Woodhouse (1):
      mtd: Disable mtdchar mmap on MMU systems

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under synflood

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Eric Dumazet (2):
      tcp: call tcp_replace_ts_recent() from tcp_ack()
      net: drop dst before queueing fragments

Eric W. Biederman (1):
      af_unix: If we don't care about credentials coallesce all messages

Felix Fietkau (2):
      ath9k_htc: accept 1.x firmware newer than 1.3
      ath9k_hw: change AR9580 initvals to fix a stability issue

Girish K S (1):
      spi/s3c64xx: modified error interrupt handling and init

Hannes Frederic Sowa (1):
      atl1e: limit gso segment size to prevent generation of wrong ip length fields

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon

Jan Beulich (1):
      x86: Fix rebuild with EFI_STUB enabled

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()

Jani Nikula (3):
      drm/i915: add quirk to invert brightness on eMachines G725
      drm/i915: add quirk to invert brightness on eMachines e725
      drm/i915: add quirk to invert brightness on Packard Bell NCL20

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources

Jiri Slaby (2):
      TTY: do not update atime/mtime on read/write
      TTY: fix atime/mtime regression

Johannes Berg (2):
      mac80211: fix remain-on-channel cancel crash
      mac80211: fix cfg80211 interaction on auth/assoc request

Jonghwan Choi (1):
      cpufreq: exynos: Get booting freq value in exynos_cpufreq_init

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment

Lars-Peter Clausen (3):
      ASoC: dma-sh7760: Fix compile error
      ASoC: spear_pcm: Update to new pcm_new() API
      regmap: cache Fix regcache-rbtree sync

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path

Linus Torvalds (9):
      spinlocks and preemption points need to be at least compiler barriers
      kobject: fix kset_find_obj() race with concurrent last kobject_put()
      vm: add vm_iomap_memory() helper function
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
      vm: convert fb_mmap to vm_iomap_memory() helper
      vm: convert HPET mmap to vm_iomap_memory() helper
      vm: convert mtdchar mmap to vm_iomap_memory() helper
      Add file_ns_capable() helper function for open-time capability checking
      net: fix incorrect credentials passing

Linus Walleij (1):
      crypto: ux500 - add missing comma

Lukasz Dorau (1):
      libsas: fix handling vacant phy in sas_set_ex_phy()

Marc Kleine-Budde (1):
      can: mcp251x: add missing IRQF_ONESHOT to request_threaded_irq

Markus Pargmann (1):
      ARM: clk-imx35: Bugfix iomux clock

Mathias Krause (14):
      crypto: algif - suppress sending source address information in recvmsg
      atm: update msg_namelen in vcc_recvmsg()
      ax25: fix info leak via msg_name in ax25_recvmsg()
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
      Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_recvmsg()
      caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
      irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
      l2tp: fix info leak in l2tp_ip6_recvmsg()
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
      netrom: fix info leak via msg_name in nr_recvmsg()
      NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      tipc: fix info leaks via msg_name in recv_msg/recv_stream

Matt Carlson (1):
      tg3: Add 57766 device support.

Maxim Mikityanskiy (1):
      msi-wmi: Fix memory leak

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header length

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test

Namhyung Kim (2):
      tracing: Fix double free when function profile init failed
      tracing: Fix possible NULL pointer dereferences

Naoya Horiguchi (1):
      hugetlbfs: add swap entry check in follow_hugetlb_page()

Nicholas Bellinger (1):
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs

Paul Moore (1):
      x86: remove the x32 syscall bitmask from syscall_get_nr()

Rafael J. Wysocki (1):
      PCI/PM: Disable runtime PM of PCIe ports

Rafał Miłecki (1):
      ssb: implement spurious tone avoidance

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class

Robert Tivy (1):
      remoteproc: fix FW_CONFIG typo

Russell King (1):
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support) properly

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Sascha Hauer (2):
      ASoC: imx-ssi: Fix occasional AC97 reset failure
      ARM: i.MX35: enable MAX clock

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Sjur Brændeland (1):
      remoteproc: fix error path of handle_vdev

Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Stephen Boyd (1):
      ARM: 7699/1: sched_clock: Add more notrace to prevent recursion

Steven Rostedt (Red Hat) (2):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section
      Linux 3.6.11.3

Steven Whitehouse (1):
      GFS2: Fix unlock of fcntl locks during withdrawn state

Stone Piao (1):
      mwifiex: limit channel number not to overflow memory

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems

Thomas Graf (1):
      tcp: Reallocate headroom if it would overflow csum_start

Thomas Hellstrom (1):
      kref: Implement kref_get_unless_zero v3

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()

Vasily Averin (1):
      cbq: incorrect processing of high limits

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works properly.

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Wei Yongjun (3):
      can: gw: use kmem_cache_free() instead of kfree()
      netrom: fix invalid use of sizeof in nr_recvmsg()
      esp4: fix error return code in esp_output()

Will Deacon (1):
      ARM: 7698/1: perf: fix group validation when using enable_on_exec

Yinghai Lu (2):
      EISA/PCI: Init EISA early, before PNP
      EISA/PCI: Fix bus res reference

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms

Zhao Hongjiang (1):
      aio: fix possible invalid memory access when DEBUG is enabled

hayeswang (1):
      r8169: fix auto speed down issue

nikolay@redhat.com (2):
      bonding: fix bonding_masters race condition in bond unloading
      bonding: IFF_BONDING is not stripped on enslave failure

----


