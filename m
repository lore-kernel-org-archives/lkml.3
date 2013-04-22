Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3DVJjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:39:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39829 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3DVJi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:38:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [3.5.y.z extended stable] Linux 3.5.7.11
Date: Mon, 22 Apr 2013 10:38:54 +0100
Message-Id: <1366623535-8481-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 3.5.7.11 tree of stable patches.

This tree picks up the latest 3.5 stable release upstream, and add patches
on top that were later marked for stable but can't be added to 3.5, as
it is not anymore an stable series maintained upstream.

The tree is maintained by the Ubuntu Kernel Team, with the intention
to continue to provide support for the 3.5 series. Anyone is welcomed
on using it or contributing to this effort.

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

The updated 3.5.y tree can be found at: 

  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

The diffstat and shortlog with changes since previous v3.5.7.10 release are
shown below.

-Luis

-- 
 Makefile                                      |  2 +-
 arch/alpha/kernel/sys_nautilus.c              |  5 ++
 arch/arm/mach-at91/include/mach/at91_rtc.h    |  1 +
 arch/arm/mm/proc-arm920.S                     |  2 +-
 arch/arm/mm/proc-arm926.S                     |  2 +-
 arch/arm/mm/proc-mohawk.S                     |  2 +-
 arch/arm/mm/proc-sa1100.S                     |  2 +-
 arch/arm/mm/proc-v6.S                         |  2 +-
 arch/arm/mm/proc-xsc3.S                       |  2 +-
 arch/arm/mm/proc-xscale.S                     |  2 +-
 arch/powerpc/platforms/pseries/lpar.c         |  8 +++-
 arch/x86/boot/compressed/Makefile             |  5 +-
 arch/x86/include/asm/kvm_host.h               |  4 +-
 arch/x86/include/asm/paravirt.h               |  5 +-
 arch/x86/include/asm/paravirt_types.h         |  2 +
 arch/x86/include/asm/syscall.h                |  4 +-
 arch/x86/kernel/paravirt.c                    | 25 +++++-----
 arch/x86/kvm/x86.c                            | 44 ++++++++---------
 arch/x86/lguest/boot.c                        |  1 +
 arch/x86/mm/fault.c                           |  6 ++-
 arch/x86/xen/mmu.c                            |  1 +
 block/blk-sysfs.c                             |  2 +
 crypto/gcm.c                                  | 17 +++++--
 drivers/ata/ata_piix.c                        | 13 ++++-
 drivers/ata/libata-core.c                     |  4 ++
 drivers/bluetooth/ath3k.c                     | 14 ++++++
 drivers/bluetooth/btusb.c                     |  7 +++
 drivers/eisa/pci_eisa.c                       | 67 ++++++++++++++++++--------
 drivers/firmware/Kconfig                      | 18 +++++++
 drivers/firmware/efivars.c                    | 69 ++++++++++-----------------
 drivers/gpu/drm/i915/i915_gem_gtt.c           |  2 +-
 drivers/gpu/drm/i915/intel_display.c          | 41 ++++++++++++++++
 drivers/gpu/drm/mgag200/mgag200_mode.c        | 13 ++---
 drivers/gpu/drm/udl/udl_connector.c           |  4 ++
 drivers/gpu/vga/vga_switcheroo.c              |  3 ++
 drivers/hwspinlock/hwspinlock_core.c          |  2 +
 drivers/mtd/mtdchar.c                         |  6 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  7 ++-
 drivers/net/ethernet/realtek/r8169.c          | 28 +++++++++--
 drivers/net/wireless/mwifiex/cfg80211.c       |  3 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c       |  4 +-
 drivers/platform/x86/msi-wmi.c                |  4 +-
 drivers/remoteproc/Kconfig                    |  2 +-
 drivers/remoteproc/remoteproc_core.c          |  4 +-
 drivers/rtc/rtc-at91rm9200.c                  | 50 ++++++++-----------
 drivers/scsi/libsas/sas_expander.c            | 12 +++++
 drivers/spi/spi-mpc512x-psc.c                 |  2 +-
 drivers/spi/spi-s3c64xx.c                     | 41 +++++++++-------
 drivers/target/target_core_alua.c             |  3 ++
 drivers/video/console/fbcon.c                 | 11 +++--
 drivers/video/fbmem.c                         |  2 +
 fs/btrfs/tree-log.c                           | 48 ++++++++++++++++---
 fs/cifs/connect.c                             | 16 +++++--
 fs/gfs2/file.c                                |  5 +-
 fs/inode.c                                    |  2 +-
 include/linux/ata.h                           |  2 +-
 include/linux/ftrace.h                        |  3 +-
 include/linux/kref.h                          | 21 ++++++++
 include/linux/kvm_host.h                      |  2 +-
 include/linux/kvm_types.h                     |  1 +
 include/linux/libata.h                        |  1 +
 include/linux/preempt.h                       | 22 +++++----
 include/linux/spinlock_up.h                   | 29 ++++++-----
 kernel/hrtimer.c                              |  3 +-
 kernel/panic.c                                |  8 ++++
 kernel/sched/clock.c                          | 26 ++++++++++
 kernel/sys.c                                  |  3 +-
 kernel/trace/ftrace.c                         | 45 ++++++++---------
 kernel/trace/trace_stack.c                    |  2 +-
 lib/kobject.c                                 |  9 +++-
 net/can/gw.c                                  |  6 +--
 sound/pci/hda/hda_codec.c                     |  2 +-
 sound/pci/hda/hda_eld.c                       |  2 +-
 sound/pci/hda/patch_realtek.c                 |  4 +-
 sound/soc/codecs/wm8903.c                     |  2 +
 sound/soc/fsl/imx-ssi.c                       |  5 ++
 sound/soc/sh/dma-sh7760.c                     |  4 +-
 sound/usb/mixer_quirks.c                      |  4 +-
 sound/usb/quirks.c                            |  2 +-
 virt/kvm/ioapic.c                             |  7 ++-
 virt/kvm/kvm_main.c                           | 47 ++++++++++++++----
 81 files changed, 631 insertions(+), 284 deletions(-)

AceLan Kao (3):
      Bluetooth: Add support for IMC Networks [13d3:3393]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e04e]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e056]

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running

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

Ben Hutchings (1):
      efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE

Boris Ostrovsky (1):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal

Chris Wilson (1):
      drm/i915: Use the correct size of the GTT for placing the per-process entries

Christopher Harvey (1):
      drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal.

Daniel Schaal (1):
      Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.

Dave Airlie (2):
      udl: handle EDID failure properly.
      fbcon: fix locking harder

David Henningsson (1):
      ALSA: hda - fix typo in proc output

David Woodhouse (1):
      mtd: Disable mtdchar mmap on MMU systems

Egbert Eich (1):
      DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*

Girish K S (1):
      spi/s3c64xx: modified error interrupt handling and init

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Jakub Kicinski (1):
      ixgbe: fix registration order of driver and DCA nofitication

Jan Beulich (1):
      x86: Fix rebuild with EFI_STUB enabled

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Jani Nikula (3):
      drm/i915: add quirk to invert brightness on eMachines G725
      drm/i915: add quirk to invert brightness on eMachines e725
      drm/i915: add quirk to invert brightness on Packard Bell NCL20

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources

Johan Hovold (1):
      Revert "drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR"

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay

Josh Boyer (1):
      Bluetooth: Add support for atheros 04ca:3004 device to ath3k

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment

Lars-Peter Clausen (1):
      ASoC: dma-sh7760: Fix compile error

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path

Linus Torvalds (2):
      spinlocks and preemption points need to be at least compiler barriers
      kobject: fix kset_find_obj() race with concurrent last kobject_put()

Luis Henriques (1):
      Linux 3.5.7.11

Lukasz Dorau (1):
      libsas: fix handling vacant phy in sas_set_ex_phy()

Maxim Mikityanskiy (1):
      msi-wmi: Fix memory leak

Mengdong Lin (1):
      ALSA: hda - bug fix on return value when getting HDMI ELD info

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test

Namhyung Kim (2):
      tracing: Fix double free when function profile init failed
      tracing: Fix possible NULL pointer dereferences

Nicholas Bellinger (1):
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs

Paul Moore (1):
      x86: remove the x32 syscall bitmask from syscall_get_nr()

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec

Robert Tivy (1):
      remoteproc: fix FW_CONFIG typo

Russell King (1):
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support) properly

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Sascha Hauer (1):
      ASoC: imx-ssi: Fix occasional AC97 reset failure

Sergio Cambra (1):
      Bluetooth device 04ca:3008 should use ath3k

Seth Forshee (2):
      efivars: Allow disabling use as a pstore backend
      efivars: Add module parameter to disable use as a pstore backend

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Sjur Brændeland (1):
      remoteproc: fix error path of handle_vdev

Steven Rostedt (Red Hat) (1):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Steven Whitehouse (1):
      GFS2: Fix unlock of fcntl locks during withdrawn state

Stone Piao (1):
      mwifiex: limit channel number not to overflow memory

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Sunguk Lee (1):
      Bluetooth: Device 0cf3:3008 should map AR 3012

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems

Thomas Hellstrom (1):
      kref: Implement kref_get_unless_zero v3

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

Vikram Mulukutla (1):
      panic: fix a possible deadlock in panic()

Wei Yongjun (1):
      can: gw: use kmem_cache_free() instead of kfree()

Yinghai Lu (2):
      EISA/PCI: Fix bus res reference
      EISA/PCI: Init EISA early, before PNP

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms

hayeswang (1):
      r8169: fix auto speed down issue

