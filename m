Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaDBAnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:43:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45075 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbaDBAnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:43:11 -0400
Message-ID: <1396399386.22689.26.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.56
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 02 Apr 2014 01:43:06 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vPDzKSqS+7+vU8+rYdFX"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vPDzKSqS+7+vU8+rYdFX
Content-Type: multipart/mixed; boundary="=-tnyLLp81uTBoYMwXuP/k"


--=-tnyLLp81uTBoYMwXuP/k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.56 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.55 is attached to this message.

Ben.

------------

 Documentation/filesystems/proc.txt                 |   4 +-
 Documentation/i2c/busses/i2c-piix4                 |   2 +-
 Makefile                                           |   2 +-
 arch/alpha/lib/csum_partial_copy.c                 |   9 +-
 arch/arm/include/asm/cacheflush.h                  |   1 +
 arch/arm/include/asm/spinlock.h                    |  15 +--
 arch/arm/mm/proc-v6.S                              |   3 +-
 arch/arm/mm/proc-v7.S                              |   2 +-
 arch/avr32/Makefile                                |   2 +-
 arch/avr32/boards/mimc200/fram.c                   |   1 +
 arch/mips/mm/c-r4k.c                               |  11 ---
 arch/powerpc/kernel/cacheinfo.c                    |   3 +
 arch/powerpc/kernel/crash_dump.c                   |   8 +-
 arch/powerpc/kernel/reloc_64.S                     |   1 +
 arch/powerpc/kvm/e500_tlb.c                        |   2 +-
 arch/s390/crypto/aes_s390.c                        |  79 +++++++++++-----
 arch/s390/crypto/des_s390.c                        | 103 ++++++++++++++---=
----
 arch/s390/crypto/ghash_s390.c                      |  21 +++--
 arch/s390/crypto/sha_common.c                      |   9 +-
 arch/s390/mm/page-states.c                         |  10 ++
 arch/x86/include/asm/irq.h                         |   1 +
 arch/x86/kernel/cpu/perf_event.c                   |   3 +
 arch/x86/kernel/irq.c                              |  70 ++++++++++++++
 arch/x86/kernel/quirks.c                           |   2 +-
 arch/x86/kernel/smpboot.c                          |   5 +
 arch/x86/kvm/i8254.c                               |  18 ++++
 arch/x86/kvm/lapic.c                               |   3 -
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/kvm/x86.c                                 |   3 +
 arch/x86/kvm/x86.h                                 |   2 +
 arch/x86/platform/efi/efi.c                        |   2 +-
 block/blk-lib.c                                    |   8 ++
 drivers/acpi/bus.c                                 |   9 ++
 drivers/acpi/processor_throttling.c                |  69 +++++++-------
 drivers/acpi/video.c                               |   8 +-
 drivers/ata/ahci.c                                 |  14 +++
 drivers/ata/libata-core.c                          |  28 ++++++
 drivers/ata/libata-pmp.c                           |   7 +-
 drivers/ata/libata-scsi.c                          |  18 +++-
 drivers/ata/sata_sil.c                             |   1 +
 drivers/block/xen-blkfront.c                       |   5 +-
 drivers/char/raw.c                                 |   2 +-
 drivers/dma/ioat/dma.c                             |  46 +++++++--
 drivers/dma/ioat/dma.h                             |   1 +
 drivers/dma/ioat/dma_v2.c                          |  11 +--
 drivers/dma/ioat/dma_v3.c                          |   3 +
 drivers/dma/ste_dma40.c                            |   4 +-
 drivers/edac/edac_mc.c                             |  11 ++-
 drivers/edac/i7300_edac.c                          |  38 ++++----
 drivers/edac/i7core_edac.c                         |   9 +-
 drivers/gpu/drm/i915/intel_display.c               |  14 +++
 drivers/gpu/drm/i915/intel_dp.c                    |  19 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  21 +++++
 drivers/gpu/drm/i915/intel_ringbuffer.h            |   1 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |   5 +-
 drivers/gpu/drm/radeon/r600.c                      |  14 +--
 drivers/gpu/drm/radeon/r600d.h                     |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |   4 +
 drivers/gpu/drm/radeon/radeon_i2c.c                |   3 +
 drivers/gpu/drm/radeon/radeon_pm.c                 |   6 +-
 drivers/hv/connection.c                            |  12 +--
 drivers/hwmon/max1668.c                            |   2 +-
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/busses/i2c-piix4.c                     |  26 +++++-
 drivers/idle/intel_idle.c                          |   3 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   5 +
 drivers/infiniband/hw/qib/qib_ud.c                 |   9 +-
 drivers/iommu/intel-iommu.c                        |   2 +-
 drivers/md/Kconfig                                 |   4 +
 drivers/md/Makefile                                |   1 +
 drivers/md/dm-builtin.c                            |  49 ++++++++++
 drivers/md/dm-sysfs.c                              |   5 +-
 drivers/md/dm.c                                    |  11 +--
 drivers/md/dm.h                                    |  17 ++++
 drivers/md/persistent-data/dm-space-map-common.c   |   6 +-
 drivers/md/raid5.c                                 |  91 +++++++++--------=
-
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.h         |   2 +-
 drivers/media/dvb/frontends/dib8000.c              |  33 +++++--
 drivers/media/video/saa7134/saa7134-alsa.c         |   2 +
 drivers/mmc/host/atmel-mci.c                       |  13 ++-
 drivers/mmc/host/sdhci.c                           |  17 ++--
 drivers/mtd/nand/mxc_nand.c                        |   1 -
 drivers/net/bonding/bond_3ad.c                     |   6 +-
 drivers/net/bonding/bond_3ad.h                     |   1 +
 drivers/net/can/flexcan.c                          |  13 ++-
 drivers/net/ethernet/broadcom/tg3.c                |   7 +-
 drivers/net/ethernet/broadcom/tg3.h                |   6 +-
 drivers/net/usb/gl620a.c                           |   4 +
 drivers/net/usb/mcs7830.c                          |   5 +-
 drivers/net/usb/net1080.c                          |   4 +
 drivers/net/usb/rndis_host.c                       |   4 +
 drivers/net/usb/smsc75xx.c                         |   4 +
 drivers/net/usb/smsc95xx.c                         |   4 +
 drivers/net/usb/usbnet.c                           |  25 ++---
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  19 +++-
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   8 +-
 drivers/net/wireless/ath/ath9k/init.c              |   8 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   8 +-
 drivers/net/wireless/b43/xmit.c                    |   4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  16 +++-
 drivers/net/wireless/mwifiex/11n.c                 |   3 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h     |  10 +-
 drivers/net/wireless/rtlwifi/core.c                |   1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |  18 +++-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |  29 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   1 +
 drivers/of/address.c                               |   9 +-
 drivers/parport/parport_pc.c                       |  10 +-
 drivers/pci/pci.c                                  |  13 +++
 drivers/platform/x86/hp_accel.c                    |   1 +
 drivers/power/max17040_battery.c                   |   5 +-
 drivers/rtc/rtc-cmos.c                             |  52 ++++++++++-
 drivers/scsi/bfa/bfad.c                            |   6 +-
 drivers/scsi/isci/host.h                           |   5 +-
 drivers/scsi/isci/port_config.c                    |   7 --
 drivers/scsi/isci/task.c                           |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  17 +++-
 drivers/staging/comedi/drivers/pcmuio.c            |  12 +--
 drivers/staging/comedi/drivers/ssv_dnp.c           |   6 +-
 drivers/staging/iio/adc/ad799x_core.c              |   3 +-
 drivers/staging/rtl8712/usb_intf.c                 |   5 +
 drivers/staging/vt6656/baseband.c                  |   3 -
 drivers/target/iscsi/iscsi_target.c                |  34 ++++---
 drivers/tty/n_gsm.c                                |  11 +++
 drivers/tty/serial/8250.c                          |   4 +
 drivers/tty/serial/8250_pci.c                      |  20 ++++
 drivers/tty/serial/pmac_zilog.c                    |   3 +
 drivers/usb/core/config.c                          |   4 +
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/host/ehci-hcd.c                        |  13 ++-
 drivers/usb/host/ehci-hub.c                        |  26 +++++-
 drivers/usb/host/ehci.h                            |  18 +++-
 drivers/usb/serial/cypress_m8.h                    |   2 +-
 drivers/usb/serial/ftdi_sio.c                      |  23 ++++-
 drivers/usb/serial/ftdi_sio_ids.h                  |  19 ++++
 drivers/usb/serial/option.c                        |  21 ++++-
 drivers/usb/serial/pl2303.c                        |  33 +++++--
 drivers/usb/storage/Kconfig                        |   4 +-
 drivers/usb/storage/scsiglue.c                     |   4 +
 drivers/usb/storage/unusual_cypress.h              |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  14 +++
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/btrfs/inode.c                                   |  18 ++--
 fs/btrfs/ioctl.c                                   |  15 ++-
 fs/buffer.c                                        |   6 +-
 fs/cifs/connect.c                                  |   3 +-
 fs/exofs/ore.c                                     |  37 +++++---
 fs/ext4/ext4.h                                     |   2 +
 fs/file.c                                          |   2 +-
 fs/fuse/dev.c                                      |  22 +----
 fs/hpfs/alloc.c                                    |  66 ++++++++++++-
 fs/hpfs/dir.c                                      |  10 +-
 fs/hpfs/hpfs_fn.h                                  |   2 +-
 fs/hpfs/super.c                                    |  32 +++++--
 fs/lockd/svclock.c                                 |   8 ++
 fs/nfs/blocklayout/extents.c                       |   2 +-
 fs/nfs/nfs4proc.c                                  |   4 +-
 fs/nfs/nfs4xdr.c                                   |  47 ++++++----
 fs/ocfs2/file.c                                    |   8 +-
 fs/ocfs2/quota_global.c                            |  27 ++++--
 fs/ocfs2/quota_local.c                             |   4 -
 fs/quota/dquot.c                                   |  14 ++-
 fs/splice.c                                        |  18 ++++
 include/linux/compiler-gcc4.h                      |   6 +-
 include/linux/jiffies.h                            |   8 +-
 include/linux/libata.h                             |   2 +
 include/linux/pipe_fs_i.h                          |   2 +
 include/linux/tracepoint.h                         |   6 ++
 include/scsi/osd_ore.h                             |   1 +
 include/xen/Kbuild                                 |   2 +
 kernel/cgroup.c                                    |   5 +
 kernel/cpuset.c                                    |   2 +-
 kernel/events/core.c                               |  12 +--
 kernel/irq/manage.c                                |   2 +-
 kernel/printk.c                                    |   1 -
 kernel/sched_fair.c                                |   8 +-
 kernel/time/jiffies.c                              |   6 ++
 kernel/time/timekeeping.c                          |   2 +-
 kernel/trace/ftrace.c                              |  81 ++++++++++++++--
 kernel/trace/ring_buffer.c                         |   7 ++
 kernel/trace/trace_events.c                        |  10 ++
 kernel/tracepoint.c                                |   7 +-
 kernel/workqueue.c                                 |   7 ++
 lib/Makefile                                       |   1 +
 mm/oom_kill.c                                      |   2 +-
 mm/page-writeback.c                                |   5 +-
 mm/rmap.c                                          |   4 +
 mm/slub.c                                          |   8 +-
 mm/swapfile.c                                      |  11 ++-
 net/core/fib_rules.c                               |   7 ++
 net/core/skbuff.c                                  |  32 +------
 net/mac80211/sta_info.c                            |   5 +
 net/mac80211/sta_info.h                            |   7 +-
 net/mac80211/tx.c                                  |  17 +++-
 net/sctp/sm_statefuns.c                            |   7 ++
 net/sctp/socket.c                                  |  41 ++++++--
 net/sunrpc/clnt.c                                  |   8 +-
 net/sunrpc/xprtsock.c                              |   6 +-
 net/unix/af_unix.c                                 |   4 +-
 scripts/mod/file2alias.c                           |   4 +-
 security/selinux/hooks.c                           |  42 +++++++--
 security/selinux/ss/policydb.c                     |  22 ++++-
 security/selinux/ss/services.c                     |   4 +
 sound/pci/Kconfig                                  |  12 +++
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/pci/oxygen/xonar_dg.c                        |  12 ++-
 sound/pci/rme9652/rme9652.c                        |   2 +-
 sound/soc/codecs/adau1701.c                        |   2 +-
 sound/soc/codecs/sta32x.c                          |  74 +++++++--------
 sound/soc/codecs/wm8770.c                          |   4 +-
 sound/usb/mixer.c                                  |   1 +
 sound/usb/mixer_maps.c                             |   9 ++
 tools/power/x86/turbostat/turbostat.c              |  11 ++-
 virt/kvm/coalesced_mmio.c                          |   8 +-
 217 files changed, 1916 insertions(+), 713 deletions(-)

Aisheng Dong (1):
      mmc: sdhci: fix lockdep error in tuning routine

Al Viro (2):
      ocfs2 syncs the wrong range...
      hpfs: deadlock and race in directory lseek()

Alan Stern (4):
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: enable multi-LUN scanning when needed
      USB: EHCI: add delay during suspend to prevent erroneous wakeups

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS=
8

Alex Deucher (4):
      drm/radeon: warn users when hw_i2c is enabled (v2)
      drm/radeon: disable ss on DP for DCE3.x
      drm/radeon: set the full cache bit for fences on r7xx+
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)

Alex Williamson (1):
      intel-iommu: fix off-by-one in pagetable freeing

Amitkumar Karwar (1):
      mwifiex: copy AP's HT capability info correctly

Andy Grover (1):
      target/iscsi: Fix network portal creation race

Anton Blanchard (2):
      net: unix socket code abuses csum_partial
      powerpc: Align p_dyn, p_rela and p_st symbols

Arnd Bergmann (1):
      vmxnet3: fix building without CONFIG_PCI_MSI

Ben Hutchings (1):
      Linux 3.2.56

Benjamin Herrenschmidt (1):
      of: Fix address decoding on Bimini and js2x machines

Bjorn Helgaas (2):
      PCI: Enable INTx if BIOS left them disabled
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not ena=
bled

Bj=C3=B8rn Mork (1):
      usb: ftdi_sio: add Mindstorms EV3 console adapter

Boaz Harrosh (1):
      ore: Fix wrong math in allocation of per device BIO

Borislav Petkov (2):
      rtc-cmos: Add an alarm disable quirk
      EDAC: Correct workqueue setup path

Chen Gang (1):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Chris Mason (1):
      Btrfs: setup inode location during btrfs_init_inode_locked

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Clemens Ladisch (2):
      ALSA: usb-audio: work around KEF X300A firmware bug
      ALSA: oxygen: Xonar DG(X): modify DAC routing

Colin Cross (1):
      timekeeping: fix 32-bit overflow in get_monotonic_boottime

Colin Leitner (1):
      USB: ftdi_sio: added CS5 quirk for broken smartcard readers

Dan Carpenter (1):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

Dan Williams (2):
      ioat: fix tasklet tear down
      isci: fix reset timeout handling

Daniel Borkmann (2):
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capabl=
e

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Dave Jones (1):
      mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

Dave Young (1):
      x86/efi: Fix off-by-one bug in EFI Boot Services reservation

David Rientjes (1):
      mm, oom: base root bonus on current usage

David Sterba (1):
      btrfs: restrict snapshotting to own subvolumes

David Vrabel (2):
      xen-blkfront: handle backend CLOSED without CLOSING
      xen: install xen/gntdev.h and xen/gntalloc.h

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394

Emil Goode (1):
      usbnet: remove generic hard_header_len check

Emmanuel Grumbach (1):
      mac80211: fix AP powersave TX vs. wakeup race

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

Geert Uytterhoeven (1):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()

George McCollister (1):
      sched: Fix double normalization of vruntime

Giridhar Malavali (1):
      qla2xxx: Poll during initialization for ISP25xx and ISP83xx

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value

Hans de Goede (1):
      ACPI / video: Filter the _BCL table for duplicate brightness values

Harald Freudenberger (3):
      crypto: s390 - fix concurrency issue in aes-ctr mode
      crypto: s390 - fix des and des3_ede cbc concurrency issue
      crypto: s390 - fix des and des3_ede ctr concurrency issue

Hartmut Knaack (1):
      staging:iio:ad799x fix error_free_irq which was freeing an irq that m=
ay not have been requested

Helge Deller (1):
      nfs: fix do_div() warning by instead using sector_div()

Ian Abbott (2):
      staging: comedi: ssv_dnp: correct insn_bits result
      staging: comedi: pcmuio: fix possible NULL deref on detach

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1

Jan Glauber (1):
      s390/crypto: Don't panic after crypto instruction failures

Jan Kara (2):
      quota: Fix race between dqput() and dquot_scan_active()
      ocfs2: fix quota file corruption

Jan Moskyto Matejka (1):
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Jani Nikula (2):
      drm/i915/dp: increase native aux defer retry timeout
      drm/i915/dp: add native aux defer retry limit

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Jean Delvare (2):
      i7core_edac: Fix PCI device reference count
      i7300_edac: Fix device reference count

Jens Axboe (1):
      block: add cond_resched() to potentially long running ioctl discard l=
oop

Jianguo Wu (1):
      mm/hugetlb: check for pte NULL pointer in __page_check_address()

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Joe Thornber (1):
      dm space map common: make sure new space is used during extend

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

Johan Hovold (2):
      USB: pl2303: fix data corruption on termios updates
      USB: cypress_m8: fix ring-indicator detection and reporting

Johannes Berg (3):
      mac80211: fix fragmentation code, particularly for encryption
      iwlwifi: fix TX status for aggregated packets
      mac80211: clear sequence/fragment number in QoS-null frames

Josh Triplett (1):
      turbostat: Use GCC's CPUID functions to support PIC

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration reque=
sts

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Don't timeout during the initial connection with =
host

KOSAKI Motohiro (2):
      mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of =
spin_lock_irq()
      mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

Kleber Sacilotto de Souza (1):
      of: fix PCI bus match for PCIe slots

Konrad Rzeszutek Wilk (1):
      intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing=
 it.

Krzysztof Kozlowski (1):
      power: max17040: Fix NULL pointer dereference when there is no platfo=
rm_data

Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()

Larry Finger (4):
      rtlwifi: Set the link state
      rtlwifi: rtl8192cu: Fix some code in RF handling
      staging: r8712u: Set device type to wlan
      rtlwifi: rtl8192cu: Add new device ID

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control

Lars-Peter Clausen (1):
      ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Levente Kurusa (1):
      ahci: disable NCQ on Samsung pci-e SSDs on macbooks

Li Zefan (2):
      slub: Fix calculation of cpu slabs
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor

Ludovic Desroches (1):
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Lukasz Dorau (1):
      isci: correct erroneous for_each_isci_host macro

Maciej =C5=BBenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Malcolm Priestley (1):
      staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity=
 on bScanning

Marc Kleine-Budde (3):
      can: flexcan: fix shutdown: first disable chip, then all interrupts
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() =
fails
      can: flexcan: flexcan_remove(): add missing netif_napi_del()

Marcelo Tosatti (1):
      KVM: x86: limit PIT timer frequency

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to r=
egulator API

Martijn de Gouw (1):
      cifs: set MAY_SIGN when sec=3Dkrb5

Mauro Carvalho Chehab (1):
      dib8000: make 32 bits read atomic

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Michel D=C3=A4nzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus Sp=
inPoint M8 (2BA30001)

Mihai Caraman (1):
      KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Mikhail Zolotaryov (1):
      USB: Nokia 502 is an unusual device

Miklos Szeredi (1):
      fuse: fix pipe_buf_operations

Mikulas Patocka (5):
      dm: wait until embedded kobject is released before destroying a devic=
e
      dm sysfs: fix a module unload race
      alpha: fix broken network checksum
      time: Fix overflow when HZ is smaller than 60
      hpfs: remember free space

Neil Horman (1):
      vmxnet3: fix netpoll race condition

NeilBrown (2):
      md/raid5: fix long-standing problem with bitmap handling on write fai=
lure.
      lockd: send correct lock when granting a delayed lock.

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Oleg Nesterov (1):
      md/raid5: Fix CPU hotplug callback registration

Oleksij Rempel (1):
      ath9k_htc: Do not support PowerSave by default

Olivier Langlois (1):
      rtlwifi: rtl8192ce: Fix too long disable of IRQs

Paul Bolle (1):
      raw: test against runtime value of max_raw_minors

Paul E. McKenney (2):
      printk: Fix scheduling-while-atomic problem in console_cpu_notify()
      jiffies: Avoid undefined behavior from signed overflow

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c

Paul Mackerras (1):
      powerpc: Make sure "cache" directory is removed when offlining cpu

Paul Moore (1):
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinu=
x_ip_postroute()

Peter Chen (1):
      usb: ehci: add freescale imx28 special write register method

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=3Dy

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Prarit Bhargava (1):
      x86: Add check for number of available vectors before CPU down

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      KVM: SVM: fix cr8 intercept window

Rahul Bedarkar (1):
      USB: serial: add support for iBall 3.5G connect usb modem

Ralf Baechle (1):
      MIPS: Fix potencial corruption

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface

Roman Volkov (1):
      ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2

Sebastian Andrzej Siewior (1):
      parport: parport_pc: remove double PCI ID for NetMos

Shane Huang (1):
      i2c: piix4: Add support for AMD ML and CZ SMBus changes

Stanislaw Gruszka (3):
      rtl8187: fix regression on MIPS without coherent DMA
      ath9k: protect tid->sched check
      usb: ehci: fix deadlock when threadirqs option is used

Stephen Smalley (1):
      SELinux: Fix kernel BUG on empty security contexts.

Stephen Warren (1):
      serial: 8250: enable UART_BUG_NOMSR for Tegra

Steven Noonan (1):
      compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

Steven Rostedt (2):
      ftrace: Use schedule_on_each_cpu() as a heavy synchronize_sched()
      ftrace: Have function graph only trace based on global_ops filters

Steven Rostedt (Red Hat) (3):
      ftrace: Fix synchronization location disabling and freeing ftrace_ops
      ring-buffer: Fix first commit on sub-buffer having non-zero delta
      tracing: Do not add event files for modules that fail tracepoints

Sujith Manoharan (2):
      ath9k: Do not support PowerSave by default
      ath9k: Fix ETSI compliance for AR9462 2.0

Takashi Iwai (9):
      ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
      ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks
      hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
      ALSA: hda/realtek - Avoid invalid COEFs for ALC271X
      ASoC: sta32x: Fix array access overflow
      ASoC: wm8770: Fix wrong number of enum items
      ASoC: sta32x: Fix wrong enum for limiter2 release rate
      ALSA: usb-audio: Add quirk for Logitech Webcam C500
      saa7134: Fix unlocked snd_pcm_stop() call

Tejun Heo (3):
      libata: disable LPM for some WD SATA-I devices
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
      cgroup: update cgroup_enable_task_cg_lists() to grab siglock

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy

Theodore Ts'o (1):
      ext4: don't leave i_crtime.tv_sec uninitialized

Trond Myklebust (2):
      NFSv4: OPEN must handle the NFS4ERR_IO return code correctly
      SUNRPC: Fix races in xs_nospace()

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs

Vijaya Mohan Guvva (1):
      bfa: Chinook quad port 16G FC HBA claim issue

Ville Syrj=C3=A4l=C3=A4 (2):
      drm/i915: Add intel_ring_cachline_align()
      drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Wang Shilong (1):
      Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Weijie Yang (1):
      mm/swap: fix race on swap_info reuse between swapoff and swapon

Weston Andros Adamson (2):
      sunrpc: Fix infinite loop in RPC state machine
      nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME

Will Deacon (2):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling =
MMU
      ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev

Yegor Yefremov (2):
      serial: add support for 400 and 800 v3 series Titan cards
      serial: add support for 200 v3 series Titan card

ZHAO Gang (1):
      b43: fix the wrong assignment of status.freq in b43_rx()

=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 =D0=9A=D1=80=D0=B0=D0=BC=D0=B0=
=D1=80=D0=B5=D0=BD=D0=BA=D0=BE (1):
      USB: serial: ftdi_sio: add id for Z3X Box device

=E5=BC=A0=E5=90=9B (1):
      usb: option: add new zte 3g modem pids to option driver


--=20
Ben Hutchings
compatible: Gracefully accepts erroneous data from any source

--=-tnyLLp81uTBoYMwXuP/k
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.56.patch"
Content-Disposition: attachment; filename="linux-3.2.56.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZmlsZXN5c3RlbXMvcHJvYy50eHQgYi9Eb2N1bWVu
dGF0aW9uL2ZpbGVzeXN0ZW1zL3Byb2MudHh0DQppbmRleCAwZWM5MWYwLi40MDRhMDk3IDEwMDY0
NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi9maWxlc3lzdGVtcy9wcm9jLnR4dA0KKysrIGIvRG9jdW1l
bnRhdGlvbi9maWxlc3lzdGVtcy9wcm9jLnR4dA0KQEAgLTEyOTMsOCArMTI5Myw4IEBAIG1heSBh
bGxvY2F0ZSBmcm9tIGJhc2VkIG9uIGFuIGVzdGltYXRpb24gb2YgaXRzIGN1cnJlbnQgbWVtb3J5
IGFuZCBzd2FwIHVzZS4NCiBGb3IgZXhhbXBsZSwgaWYgYSB0YXNrIGlzIHVzaW5nIGFsbCBhbGxv
d2VkIG1lbW9yeSwgaXRzIGJhZG5lc3Mgc2NvcmUgd2lsbCBiZQ0KIDEwMDAuICBJZiBpdCBpcyB1
c2luZyBoYWxmIG9mIGl0cyBhbGxvd2VkIG1lbW9yeSwgaXRzIHNjb3JlIHdpbGwgYmUgNTAwLg0K
IA0KLVRoZXJlIGlzIGFuIGFkZGl0aW9uYWwgZmFjdG9yIGluY2x1ZGVkIGluIHRoZSBiYWRuZXNz
IHNjb3JlOiByb290DQotcHJvY2Vzc2VzIGFyZSBnaXZlbiAzJSBleHRyYSBtZW1vcnkgb3ZlciBv
dGhlciB0YXNrcy4NCitUaGVyZSBpcyBhbiBhZGRpdGlvbmFsIGZhY3RvciBpbmNsdWRlZCBpbiB0
aGUgYmFkbmVzcyBzY29yZTogdGhlIGN1cnJlbnQgbWVtb3J5DQorYW5kIHN3YXAgdXNhZ2UgaXMg
ZGlzY291bnRlZCBieSAzJSBmb3Igcm9vdCBwcm9jZXNzZXMuDQogDQogVGhlIGFtb3VudCBvZiAi
YWxsb3dlZCIgbWVtb3J5IGRlcGVuZHMgb24gdGhlIGNvbnRleHQgaW4gd2hpY2ggdGhlIG9vbSBr
aWxsZXINCiB3YXMgY2FsbGVkLiAgSWYgaXQgaXMgZHVlIHRvIHRoZSBtZW1vcnkgYXNzaWduZWQg
dG8gdGhlIGFsbG9jYXRpbmcgdGFzaydzIGNwdXNldA0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRp
b24vaTJjL2J1c3Nlcy9pMmMtcGlpeDQgYi9Eb2N1bWVudGF0aW9uL2kyYy9idXNzZXMvaTJjLXBp
aXg0DQppbmRleCA2NWRhMTU3Li4wOTgyZTcyIDEwMDY0NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi9p
MmMvYnVzc2VzL2kyYy1waWl4NA0KKysrIGIvRG9jdW1lbnRhdGlvbi9pMmMvYnVzc2VzL2kyYy1w
aWl4NA0KQEAgLTgsNyArOCw3IEBAIFN1cHBvcnRlZCBhZGFwdGVyczoNCiAgICAgRGF0YXNoZWV0
OiBPbmx5IGF2YWlsYWJsZSB2aWEgTkRBIGZyb20gU2VydmVyV29ya3MNCiAgICogQVRJIElYUDIw
MCwgSVhQMzAwLCBJWFA0MDAsIFNCNjAwLCBTQjcwMCBhbmQgU0I4MDAgc291dGhicmlkZ2VzDQog
ICAgIERhdGFzaGVldDogTm90IHB1YmxpY2x5IGF2YWlsYWJsZQ0KLSAgKiBBTUQgSHVkc29uLTIs
IENaDQorICAqIEFNRCBIdWRzb24tMiwgTUwsIENaDQogICAgIERhdGFzaGVldDogTm90IHB1Ymxp
Y2x5IGF2YWlsYWJsZQ0KICAgKiBTdGFuZGFyZCBNaWNyb3N5c3RlbXMgKFNNU0MpIFNMQzkwRTY2
IChWaWN0b3J5NjYpIHNvdXRoYnJpZGdlDQogICAgIERhdGFzaGVldDogUHVibGljbHkgYXZhaWxh
YmxlIGF0IHRoZSBTTVNDIHdlYnNpdGUgaHR0cDovL3d3dy5zbXNjLmNvbQ0KZGlmZiAtLWdpdCBh
L01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IDUzODQ2M2UuLmVjOTBiZmIgMTAwNjQ0DQotLS0g
YS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0KIFZFUlNJT04gPSAz
DQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDU1DQorU1VCTEVWRUwgPSA1Ng0KIEVYVFJB
VkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiANCmRpZmYgLS1naXQg
YS9hcmNoL2FscGhhL2xpYi9jc3VtX3BhcnRpYWxfY29weS5jIGIvYXJjaC9hbHBoYS9saWIvY3N1
bV9wYXJ0aWFsX2NvcHkuYw0KaW5kZXggNDA3MzZkYS4uMWQyZWY1YSAxMDA2NDQNCi0tLSBhL2Fy
Y2gvYWxwaGEvbGliL2NzdW1fcGFydGlhbF9jb3B5LmMNCisrKyBiL2FyY2gvYWxwaGEvbGliL2Nz
dW1fcGFydGlhbF9jb3B5LmMNCkBAIC0zNzMsNiArMzczLDExIEBAIGNzdW1fcGFydGlhbF9jb3B5
X2Zyb21fdXNlcihjb25zdCB2b2lkIF9fdXNlciAqc3JjLCB2b2lkICpkc3QsIGludCBsZW4sDQog
X193c3VtDQogY3N1bV9wYXJ0aWFsX2NvcHlfbm9jaGVjayhjb25zdCB2b2lkICpzcmMsIHZvaWQg
KmRzdCwgaW50IGxlbiwgX193c3VtIHN1bSkNCiB7DQotCXJldHVybiBjc3VtX3BhcnRpYWxfY29w
eV9mcm9tX3VzZXIoKF9fZm9yY2UgY29uc3Qgdm9pZCBfX3VzZXIgKilzcmMsDQotCQkJZHN0LCBs
ZW4sIHN1bSwgTlVMTCk7DQorCV9fd3N1bSBjaGVja3N1bTsNCisJbW1fc2VnbWVudF90IG9sZGZz
ID0gZ2V0X2ZzKCk7DQorCXNldF9mcyhLRVJORUxfRFMpOw0KKwljaGVja3N1bSA9IGNzdW1fcGFy
dGlhbF9jb3B5X2Zyb21fdXNlcigoX19mb3JjZSBjb25zdCB2b2lkIF9fdXNlciAqKXNyYywNCisJ
CQkJCQlkc3QsIGxlbiwgc3VtLCBOVUxMKTsNCisJc2V0X2ZzKG9sZGZzKTsNCisJcmV0dXJuIGNo
ZWNrc3VtOw0KIH0NCmRpZmYgLS1naXQgYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9jYWNoZWZsdXNo
LmggYi9hcmNoL2FybS9pbmNsdWRlL2FzbS9jYWNoZWZsdXNoLmgNCmluZGV4IDEzOTc0MDguLmIx
ZTBlMDcgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9jYWNoZWZsdXNoLmgNCisr
KyBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL2NhY2hlZmx1c2guaA0KQEAgLTIwMiw2ICsyMDIsNyBA
QCBleHRlcm4gdm9pZCBjb3B5X3RvX3VzZXJfcGFnZShzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKiwg
c3RydWN0IHBhZ2UgKiwNCiBzdGF0aWMgaW5saW5lIHZvaWQgX19mbHVzaF9pY2FjaGVfYWxsKHZv
aWQpDQogew0KIAlfX2ZsdXNoX2ljYWNoZV9wcmVmZXJyZWQoKTsNCisJZHNiKCk7DQogfQ0KIA0K
ICNkZWZpbmUgZmx1c2hfY2FjaGVfYWxsKCkJCV9fY3B1Y19mbHVzaF9rZXJuX2FsbCgpDQpkaWZm
IC0tZ2l0IGEvYXJjaC9hcm0vaW5jbHVkZS9hc20vc3BpbmxvY2suaCBiL2FyY2gvYXJtL2luY2x1
ZGUvYXNtL3NwaW5sb2NrLmgNCmluZGV4IDY1ZmEzYzguLjA5NWE5YTMgMTAwNjQ0DQotLS0gYS9h
cmNoL2FybS9pbmNsdWRlL2FzbS9zcGlubG9jay5oDQorKysgYi9hcmNoL2FybS9pbmNsdWRlL2Fz
bS9zcGlubG9jay5oDQpAQCAtNDQsMTggKzQ0LDkgQEANCiANCiBzdGF0aWMgaW5saW5lIHZvaWQg
ZHNiX3Nldih2b2lkKQ0KIHsNCi0jaWYgX19MSU5VWF9BUk1fQVJDSF9fID49IDcNCi0JX19hc21f
XyBfX3ZvbGF0aWxlX18gKA0KLQkJImRzYlxuIg0KLQkJU0VWDQotCSk7DQotI2Vsc2UNCi0JX19h
c21fXyBfX3ZvbGF0aWxlX18gKA0KLQkJIm1jciBwMTUsIDAsICUwLCBjNywgYzEwLCA0XG4iDQot
CQlTRVYNCi0JCTogOiAiciIgKDApDQotCSk7DQotI2VuZGlmDQorDQorCWRzYigpOw0KKwlfX2Fz
bV9fKFNFVik7DQogfQ0KIA0KIC8qDQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vbW0vcHJvYy12Ni5T
IGIvYXJjaC9hcm0vbW0vcHJvYy12Ni5TDQppbmRleCA4MTY4ZDk5Li44NWE1MzQ4IDEwMDY0NA0K
LS0tIGEvYXJjaC9hcm0vbW0vcHJvYy12Ni5TDQorKysgYi9hcmNoL2FybS9tbS9wcm9jLXY2LlMN
CkBAIC0xOTksNyArMTk5LDYgQEAgX192Nl9zZXR1cDoNCiAJbWNyCXAxNSwgMCwgcjAsIGM3LCBj
MTQsIDAJCUAgY2xlYW4raW52YWxpZGF0ZSBEIGNhY2hlDQogCW1jcglwMTUsIDAsIHIwLCBjNywg
YzUsIDAJCUAgaW52YWxpZGF0ZSBJIGNhY2hlDQogCW1jcglwMTUsIDAsIHIwLCBjNywgYzE1LCAw
CQlAIGNsZWFuK2ludmFsaWRhdGUgY2FjaGUNCi0JbWNyCXAxNSwgMCwgcjAsIGM3LCBjMTAsIDQJ
CUAgZHJhaW4gd3JpdGUgYnVmZmVyDQogI2lmZGVmIENPTkZJR19NTVUNCiAJbWNyCXAxNSwgMCwg
cjAsIGM4LCBjNywgMAkJQCBpbnZhbGlkYXRlIEkgKyBEIFRMQnMNCiAJbWNyCXAxNSwgMCwgcjAs
IGMyLCBjMCwgMgkJQCBUVEIgY29udHJvbCByZWdpc3Rlcg0KQEAgLTIwOSw2ICsyMDgsOCBAQCBf
X3Y2X3NldHVwOg0KIAlBTFRfVVAob3JyCXI4LCByOCwgI1RUQl9GTEFHU19VUCkNCiAJbWNyCXAx
NSwgMCwgcjgsIGMyLCBjMCwgMQkJQCBsb2FkIFRUQjENCiAjZW5kaWYgLyogQ09ORklHX01NVSAq
Lw0KKwltY3IJcDE1LCAwLCByMCwgYzcsIGMxMCwgNAkJQCBkcmFpbiB3cml0ZSBidWZmZXIgYW5k
DQorCQkJCQkJQCBjb21wbGV0ZSBpbnZhbGlkYXRpb25zDQogCWFkcglyNSwgdjZfY3J2YWwNCiAJ
bGRtaWEJcjUsIHtyNSwgcjZ9DQogI2lmZGVmIENPTkZJR19DUFVfRU5ESUFOX0JFOA0KZGlmZiAt
LWdpdCBhL2FyY2gvYXJtL21tL3Byb2MtdjcuUyBiL2FyY2gvYXJtL21tL3Byb2MtdjcuUw0KaW5k
ZXggNzg1MzY1ZS4uMTlkMjFmZiAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL21tL3Byb2MtdjcuUw0K
KysrIGIvYXJjaC9hcm0vbW0vcHJvYy12Ny5TDQpAQCAtMzY4LDcgKzM2OCw2IEBAIF9fdjdfc2V0
dXA6DQogDQogMzoJbW92CXIxMCwgIzANCiAJbWNyCXAxNSwgMCwgcjEwLCBjNywgYzUsIDAJCUAg
SStCVEIgY2FjaGUgaW52YWxpZGF0ZQ0KLQlkc2INCiAjaWZkZWYgQ09ORklHX01NVQ0KIAltY3IJ
cDE1LCAwLCByMTAsIGM4LCBjNywgMAkJQCBpbnZhbGlkYXRlIEkgKyBEIFRMQnMNCiAJbWNyCXAx
NSwgMCwgcjEwLCBjMiwgYzAsIDIJCUAgVFRCIGNvbnRyb2wgcmVnaXN0ZXINCkBAIC0zODIsNiAr
MzgxLDcgQEAgX192N19zZXR1cDoNCiAJbWNyCXAxNSwgMCwgcjUsIGMxMCwgYzIsIDAJCUAgd3Jp
dGUgUFJSUg0KIAltY3IJcDE1LCAwLCByNiwgYzEwLCBjMiwgMQkJQCB3cml0ZSBOTVJSDQogI2Vu
ZGlmDQorCWRzYgkJCQkJQCBDb21wbGV0ZSBpbnZhbGlkYXRpb25zDQogI2lmbmRlZiBDT05GSUdf
QVJNX1RIVU1CRUUNCiAJbXJjCXAxNSwgMCwgcjAsIGMwLCBjMSwgMAkJQCByZWFkIElEX1BGUjAg
Zm9yIFRodW1iRUUNCiAJYW5kCXIwLCByMCwgIygweGYgPDwgMTIpCQlAIFRodW1iRUUgZW5hYmxl
ZCBmaWVsZA0KZGlmZiAtLWdpdCBhL2FyY2gvYXZyMzIvTWFrZWZpbGUgYi9hcmNoL2F2cjMyL01h
a2VmaWxlDQppbmRleCAyMmZiNjY1Li5kYmE0OGE1IDEwMDY0NA0KLS0tIGEvYXJjaC9hdnIzMi9N
YWtlZmlsZQ0KKysrIGIvYXJjaC9hdnIzMi9NYWtlZmlsZQ0KQEAgLTExLDcgKzExLDcgQEAgYWxs
OiB1SW1hZ2Ugdm1saW51eC5lbGYNCiANCiBLQlVJTERfREVGQ09ORklHCTo9IGF0c3RrMTAwMl9k
ZWZjb25maWcNCiANCi1LQlVJTERfQ0ZMQUdTCSs9IC1waXBlIC1mbm8tYnVpbHRpbiAtbW5vLXBp
Yw0KK0tCVUlMRF9DRkxBR1MJKz0gLXBpcGUgLWZuby1idWlsdGluIC1tbm8tcGljIC1EX19saW51
eF9fDQogS0JVSUxEX0FGTEFHUwkrPSAtbXJlbGF4IC1tbm8tcGljDQogS0JVSUxEX0NGTEFHU19N
T0RVTEUgKz0gLW1uby1yZWxheA0KIExERkxBR1Nfdm1saW51eAkrPSAtLXJlbGF4DQpkaWZmIC0t
Z2l0IGEvYXJjaC9hdnIzMi9ib2FyZHMvbWltYzIwMC9mcmFtLmMgYi9hcmNoL2F2cjMyL2JvYXJk
cy9taW1jMjAwL2ZyYW0uYw0KaW5kZXggOTc2NGExYS4uYzE0NjZhOCAxMDA2NDQNCi0tLSBhL2Fy
Y2gvYXZyMzIvYm9hcmRzL21pbWMyMDAvZnJhbS5jDQorKysgYi9hcmNoL2F2cjMyL2JvYXJkcy9t
aW1jMjAwL2ZyYW0uYw0KQEAgLTExLDYgKzExLDcgQEANCiAjZGVmaW5lIEZSQU1fVkVSU0lPTgki
MS4wIg0KIA0KICNpbmNsdWRlIDxsaW51eC9taXNjZGV2aWNlLmg+DQorI2luY2x1ZGUgPGxpbnV4
L21vZHVsZS5oPg0KICNpbmNsdWRlIDxsaW51eC9wcm9jX2ZzLmg+DQogI2luY2x1ZGUgPGxpbnV4
L21tLmg+DQogI2luY2x1ZGUgPGxpbnV4L2lvLmg+DQpkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL21t
L2MtcjRrLmMgYi9hcmNoL21pcHMvbW0vYy1yNGsuYw0KaW5kZXggYTc5ZmU5YS4uN2Q1YWMwYiAx
MDA2NDQNCi0tLSBhL2FyY2gvbWlwcy9tbS9jLXI0ay5jDQorKysgYi9hcmNoL21pcHMvbW0vYy1y
NGsuYw0KQEAgLTYzMyw5ICs2MzMsNiBAQCBzdGF0aWMgdm9pZCByNGtfZG1hX2NhY2hlX2ludih1
bnNpZ25lZCBsb25nIGFkZHIsIHVuc2lnbmVkIGxvbmcgc2l6ZSkNCiAJCWlmIChzaXplID49IHNj
YWNoZV9zaXplKQ0KIAkJCXI0a19ibGFzdF9zY2FjaGUoKTsNCiAJCWVsc2Ugew0KLQkJCXVuc2ln
bmVkIGxvbmcgbHNpemUgPSBjcHVfc2NhY2hlX2xpbmVfc2l6ZSgpOw0KLQkJCXVuc2lnbmVkIGxv
bmcgYWxtYXNrID0gfihsc2l6ZSAtIDEpOw0KLQ0KIAkJCS8qDQogCQkJICogVGhlcmUgaXMgbm8g
Y2xlYXJseSBkb2N1bWVudGVkIGFsaWdubWVudCByZXF1aXJlbWVudA0KIAkJCSAqIGZvciB0aGUg
Y2FjaGUgaW5zdHJ1Y3Rpb24gb24gTUlQUyBwcm9jZXNzb3JzIGFuZA0KQEAgLTY0NCw5ICs2NDEs
NiBAQCBzdGF0aWMgdm9pZCByNGtfZG1hX2NhY2hlX2ludih1bnNpZ25lZCBsb25nIGFkZHIsIHVu
c2lnbmVkIGxvbmcgc2l6ZSkNCiAJCQkgKiBoaXQgb3BzIHdpdGggaW5zdWZmaWNpZW50IGFsaWdu
bWVudC4gIFNvbHZlZCBieQ0KIAkJCSAqIGFsaWduaW5nIHRoZSBhZGRyZXNzIHRvIGNhY2hlIGxp
bmUgc2l6ZS4NCiAJCQkgKi8NCi0JCQljYWNoZV9vcChIaXRfV3JpdGViYWNrX0ludl9TRCwgYWRk
ciAmIGFsbWFzayk7DQotCQkJY2FjaGVfb3AoSGl0X1dyaXRlYmFja19JbnZfU0QsDQotCQkJCSAo
YWRkciArIHNpemUgLSAxKSAmIGFsbWFzayk7DQogCQkJYmxhc3RfaW52X3NjYWNoZV9yYW5nZShh
ZGRyLCBhZGRyICsgc2l6ZSk7DQogCQl9DQogCQlfX3N5bmMoKTsNCkBAIC02NTYsMTIgKzY1MCw3
IEBAIHN0YXRpYyB2b2lkIHI0a19kbWFfY2FjaGVfaW52KHVuc2lnbmVkIGxvbmcgYWRkciwgdW5z
aWduZWQgbG9uZyBzaXplKQ0KIAlpZiAoY3B1X2hhc19zYWZlX2luZGV4X2NhY2hlb3BzICYmIHNp
emUgPj0gZGNhY2hlX3NpemUpIHsNCiAJCXI0a19ibGFzdF9kY2FjaGUoKTsNCiAJfSBlbHNlIHsN
Ci0JCXVuc2lnbmVkIGxvbmcgbHNpemUgPSBjcHVfZGNhY2hlX2xpbmVfc2l6ZSgpOw0KLQkJdW5z
aWduZWQgbG9uZyBhbG1hc2sgPSB+KGxzaXplIC0gMSk7DQotDQogCQlSNDYwMF9ISVRfQ0FDSEVP
UF9XQVJfSU1QTDsNCi0JCWNhY2hlX29wKEhpdF9Xcml0ZWJhY2tfSW52X0QsIGFkZHIgJiBhbG1h
c2spOw0KLQkJY2FjaGVfb3AoSGl0X1dyaXRlYmFja19JbnZfRCwgKGFkZHIgKyBzaXplIC0gMSkg
ICYgYWxtYXNrKTsNCiAJCWJsYXN0X2ludl9kY2FjaGVfcmFuZ2UoYWRkciwgYWRkciArIHNpemUp
Ow0KIAl9DQogDQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9jYWNoZWluZm8uYyBi
L2FyY2gvcG93ZXJwYy9rZXJuZWwvY2FjaGVpbmZvLmMNCmluZGV4IGEzYzY4NGIuLjAyZWJlMWEg
MTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVsL2NhY2hlaW5mby5jDQorKysgYi9hcmNo
L3Bvd2VycGMva2VybmVsL2NhY2hlaW5mby5jDQpAQCAtNzg4LDYgKzc4OCw5IEBAIHN0YXRpYyB2
b2lkIHJlbW92ZV9jYWNoZV9kaXIoc3RydWN0IGNhY2hlX2RpciAqY2FjaGVfZGlyKQ0KIHsNCiAJ
cmVtb3ZlX2luZGV4X2RpcnMoY2FjaGVfZGlyKTsNCiANCisJLyogUmVtb3ZlIGNhY2hlIGRpciBm
cm9tIHN5c2ZzICovDQorCWtvYmplY3RfZGVsKGNhY2hlX2Rpci0+a29iaik7DQorDQogCWtvYmpl
Y3RfcHV0KGNhY2hlX2Rpci0+a29iaik7DQogDQogCWtmcmVlKGNhY2hlX2Rpcik7DQpkaWZmIC0t
Z2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9jcmFzaF9kdW1wLmMgYi9hcmNoL3Bvd2VycGMva2Vy
bmVsL2NyYXNoX2R1bXAuYw0KaW5kZXggNDI0YWZiNi4uMzk3ODdjOSAxMDA2NDQNCi0tLSBhL2Fy
Y2gvcG93ZXJwYy9rZXJuZWwvY3Jhc2hfZHVtcC5jDQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVs
L2NyYXNoX2R1bXAuYw0KQEAgLTEwOCwxNyArMTA4LDE5IEBAIHNzaXplX3QgY29weV9vbGRtZW1f
cGFnZSh1bnNpZ25lZCBsb25nIHBmbiwgY2hhciAqYnVmLA0KIAkJCXNpemVfdCBjc2l6ZSwgdW5z
aWduZWQgbG9uZyBvZmZzZXQsIGludCB1c2VyYnVmKQ0KIHsNCiAJdm9pZCAgKnZhZGRyOw0KKwlw
aHlzX2FkZHJfdCBwYWRkcjsNCiANCiAJaWYgKCFjc2l6ZSkNCiAJCXJldHVybiAwOw0KIA0KIAlj
c2l6ZSA9IG1pbl90KHNpemVfdCwgY3NpemUsIFBBR0VfU0laRSk7DQorCXBhZGRyID0gcGZuIDw8
IFBBR0VfU0hJRlQ7DQogDQotCWlmICgobWluX2xvd19wZm4gPCBwZm4pICYmIChwZm4gPCBtYXhf
cGZuKSkgew0KLQkJdmFkZHIgPSBfX3ZhKHBmbiA8PCBQQUdFX1NISUZUKTsNCisJaWYgKG1lbWJs
b2NrX2lzX3JlZ2lvbl9tZW1vcnkocGFkZHIsIGNzaXplKSkgew0KKwkJdmFkZHIgPSBfX3ZhKHBh
ZGRyKTsNCiAJCWNzaXplID0gY29weV9vbGRtZW1fdmFkZHIodmFkZHIsIGJ1ZiwgY3NpemUsIG9m
ZnNldCwgdXNlcmJ1Zik7DQogCX0gZWxzZSB7DQotCQl2YWRkciA9IF9faW9yZW1hcChwZm4gPDwg
UEFHRV9TSElGVCwgUEFHRV9TSVpFLCAwKTsNCisJCXZhZGRyID0gX19pb3JlbWFwKHBhZGRyLCBQ
QUdFX1NJWkUsIDApOw0KIAkJY3NpemUgPSBjb3B5X29sZG1lbV92YWRkcih2YWRkciwgYnVmLCBj
c2l6ZSwgb2Zmc2V0LCB1c2VyYnVmKTsNCiAJCWlvdW5tYXAodmFkZHIpOw0KIAl9DQpkaWZmIC0t
Z2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9yZWxvY182NC5TIGIvYXJjaC9wb3dlcnBjL2tlcm5l
bC9yZWxvY182NC5TDQppbmRleCBiNDdhMGUxLi5jNzEyZWNlIDEwMDY0NA0KLS0tIGEvYXJjaC9w
b3dlcnBjL2tlcm5lbC9yZWxvY182NC5TDQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL3JlbG9j
XzY0LlMNCkBAIC04MSw2ICs4MSw3IEBAIF9HTE9CQUwocmVsb2NhdGUpDQogDQogNjoJYmxyDQog
DQorLmJhbGlnbiA4DQogcF9keW46CS5sbG9uZwlfX2R5bmFtaWNfc3RhcnQgLSAwYg0KIHBfcmVs
YToJLmxsb25nCV9fcmVsYV9keW5fc3RhcnQgLSAwYg0KIHBfc3Q6CS5sbG9uZwlfc3RleHQgLSAw
Yg0KZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9rdm0vZTUwMF90bGIuYyBiL2FyY2gvcG93ZXJw
Yy9rdm0vZTUwMF90bGIuYw0KaW5kZXggMTNjNDMyZS4uODQ0ZmM4MyAxMDA2NDQNCi0tLSBhL2Fy
Y2gvcG93ZXJwYy9rdm0vZTUwMF90bGIuYw0KKysrIGIvYXJjaC9wb3dlcnBjL2t2bS9lNTAwX3Rs
Yi5jDQpAQCAtNDgxLDcgKzQ4MSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBrdm1wcGNfZTUwMF9w
cml2X3JlbGVhc2Uoc3RydWN0IHRsYmVfcHJpdiAqcHJpdikNCiB9DQogDQogc3RhdGljIGlubGlu
ZSB2b2lkIGt2bXBwY19lNTAwX2RlbGl2ZXJfdGxiX21pc3Moc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LA0KLQkJdW5zaWduZWQgaW50IGVhZGRyLCBpbnQgYXMpDQorCQlndmFfdCBlYWRkciwgaW50IGFz
KQ0KIHsNCiAJc3RydWN0IGt2bXBwY192Y3B1X2U1MDAgKnZjcHVfZTUwMCA9IHRvX2U1MDAodmNw
dSk7DQogCXVuc2lnbmVkIGludCB2aWN0aW0sIHBpZHNlbCwgdHNpemVkOw0KZGlmZiAtLWdpdCBh
L2FyY2gvczM5MC9jcnlwdG8vYWVzX3MzOTAuYyBiL2FyY2gvczM5MC9jcnlwdG8vYWVzX3MzOTAu
Yw0KaW5kZXggM2VjOGIzOS4uNTFmYjFlZiAxMDA2NDQNCi0tLSBhL2FyY2gvczM5MC9jcnlwdG8v
YWVzX3MzOTAuYw0KKysrIGIvYXJjaC9zMzkwL2NyeXB0by9hZXNfczM5MC5jDQpAQCAtMjUsNiAr
MjUsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9lcnIuaD4NCiAjaW5jbHVkZSA8bGludXgvbW9kdWxl
Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4NCisjaW5jbHVkZSA8bGludXgvc3BpbmxvY2su
aD4NCiAjaW5jbHVkZSAiY3J5cHRfczM5MC5oIg0KIA0KICNkZWZpbmUgQUVTX0tFWUxFTl8xMjgJ
CTENCkBAIC0zMiw2ICszMyw3IEBADQogI2RlZmluZSBBRVNfS0VZTEVOXzI1NgkJNA0KIA0KIHN0
YXRpYyB1OCAqY3RyYmxrOw0KK3N0YXRpYyBERUZJTkVfU1BJTkxPQ0soY3RyYmxrX2xvY2spOw0K
IHN0YXRpYyBjaGFyIGtleWxlbl9mbGFnOw0KIA0KIHN0cnVjdCBzMzkwX2Flc19jdHggew0KQEAg
LTMyNCw3ICszMjYsOCBAQCBzdGF0aWMgaW50IGVjYl9hZXNfY3J5cHQoc3RydWN0IGJsa2NpcGhl
cl9kZXNjICpkZXNjLCBsb25nIGZ1bmMsIHZvaWQgKnBhcmFtLA0KIAkJdTggKmluID0gd2Fsay0+
c3JjLnZpcnQuYWRkcjsNCiANCiAJCXJldCA9IGNyeXB0X3MzOTBfa20oZnVuYywgcGFyYW0sIG91
dCwgaW4sIG4pOw0KLQkJQlVHX09OKChyZXQgPCAwKSB8fCAocmV0ICE9IG4pKTsNCisJCWlmIChy
ZXQgPCAwIHx8IHJldCAhPSBuKQ0KKwkJCXJldHVybiAtRUlPOw0KIA0KIAkJbmJ5dGVzICY9IEFF
U19CTE9DS19TSVpFIC0gMTsNCiAJCXJldCA9IGJsa2NpcGhlcl93YWxrX2RvbmUoZGVzYywgd2Fs
aywgbmJ5dGVzKTsNCkBAIC00NjMsNyArNDY2LDggQEAgc3RhdGljIGludCBjYmNfYWVzX2NyeXB0
KHN0cnVjdCBibGtjaXBoZXJfZGVzYyAqZGVzYywgbG9uZyBmdW5jLA0KIAkJdTggKmluID0gd2Fs
ay0+c3JjLnZpcnQuYWRkcjsNCiANCiAJCXJldCA9IGNyeXB0X3MzOTBfa21jKGZ1bmMsICZwYXJh
bSwgb3V0LCBpbiwgbik7DQotCQlCVUdfT04oKHJldCA8IDApIHx8IChyZXQgIT0gbikpOw0KKwkJ
aWYgKHJldCA8IDAgfHwgcmV0ICE9IG4pDQorCQkJcmV0dXJuIC1FSU87DQogDQogCQluYnl0ZXMg
Jj0gQUVTX0JMT0NLX1NJWkUgLSAxOw0KIAkJcmV0ID0gYmxrY2lwaGVyX3dhbGtfZG9uZShkZXNj
LCB3YWxrLCBuYnl0ZXMpOw0KQEAgLTYzNiw3ICs2NDAsOCBAQCBzdGF0aWMgaW50IHh0c19hZXNf
Y3J5cHQoc3RydWN0IGJsa2NpcGhlcl9kZXNjICpkZXNjLCBsb25nIGZ1bmMsDQogCW1lbWNweShw
Y2NfcGFyYW0udHdlYWssIHdhbGstPml2LCBzaXplb2YocGNjX3BhcmFtLnR3ZWFrKSk7DQogCW1l
bWNweShwY2NfcGFyYW0ua2V5LCB4dHNfY3R4LT5wY2Nfa2V5LCAzMik7DQogCXJldCA9IGNyeXB0
X3MzOTBfcGNjKGZ1bmMsICZwY2NfcGFyYW0ua2V5W29mZnNldF0pOw0KLQlCVUdfT04ocmV0IDwg
MCk7DQorCWlmIChyZXQgPCAwKQ0KKwkJcmV0dXJuIC1FSU87DQogDQogCW1lbWNweSh4dHNfcGFy
YW0ua2V5LCB4dHNfY3R4LT5rZXksIDMyKTsNCiAJbWVtY3B5KHh0c19wYXJhbS5pbml0LCBwY2Nf
cGFyYW0ueHRzLCAxNik7DQpAQCAtNjQ3LDcgKzY1Miw4IEBAIHN0YXRpYyBpbnQgeHRzX2Flc19j
cnlwdChzdHJ1Y3QgYmxrY2lwaGVyX2Rlc2MgKmRlc2MsIGxvbmcgZnVuYywNCiAJCWluID0gd2Fs
ay0+c3JjLnZpcnQuYWRkcjsNCiANCiAJCXJldCA9IGNyeXB0X3MzOTBfa20oZnVuYywgJnh0c19w
YXJhbS5rZXlbb2Zmc2V0XSwgb3V0LCBpbiwgbik7DQotCQlCVUdfT04ocmV0IDwgMCB8fCByZXQg
IT0gbik7DQorCQlpZiAocmV0IDwgMCB8fCByZXQgIT0gbikNCisJCQlyZXR1cm4gLUVJTzsNCiAN
CiAJCW5ieXRlcyAmPSBBRVNfQkxPQ0tfU0laRSAtIDE7DQogCQlyZXQgPSBibGtjaXBoZXJfd2Fs
a19kb25lKGRlc2MsIHdhbGssIG5ieXRlcyk7DQpAQCAtNzU2LDQyICs3NjIsNjcgQEAgc3RhdGlj
IGludCBjdHJfYWVzX3NldF9rZXkoc3RydWN0IGNyeXB0b190Zm0gKnRmbSwgY29uc3QgdTggKmlu
X2tleSwNCiAJcmV0dXJuIGFlc19zZXRfa2V5KHRmbSwgaW5fa2V5LCBrZXlfbGVuKTsNCiB9DQog
DQorc3RhdGljIHVuc2lnbmVkIGludCBfX2N0cmJsa19pbml0KHU4ICpjdHJwdHIsIHVuc2lnbmVk
IGludCBuYnl0ZXMpDQorew0KKwl1bnNpZ25lZCBpbnQgaSwgbjsNCisNCisJLyogb25seSB1c2Ug
Y29tcGxldGUgYmxvY2tzLCBtYXguIFBBR0VfU0laRSAqLw0KKwluID0gKG5ieXRlcyA+IFBBR0Vf
U0laRSkgPyBQQUdFX1NJWkUgOiBuYnl0ZXMgJiB+KEFFU19CTE9DS19TSVpFIC0gMSk7DQorCWZv
ciAoaSA9IEFFU19CTE9DS19TSVpFOyBpIDwgbjsgaSArPSBBRVNfQkxPQ0tfU0laRSkgew0KKwkJ
bWVtY3B5KGN0cnB0ciArIGksIGN0cnB0ciArIGkgLSBBRVNfQkxPQ0tfU0laRSwNCisJCSAgICAg
ICBBRVNfQkxPQ0tfU0laRSk7DQorCQljcnlwdG9faW5jKGN0cnB0ciArIGksIEFFU19CTE9DS19T
SVpFKTsNCisJfQ0KKwlyZXR1cm4gbjsNCit9DQorDQogc3RhdGljIGludCBjdHJfYWVzX2NyeXB0
KHN0cnVjdCBibGtjaXBoZXJfZGVzYyAqZGVzYywgbG9uZyBmdW5jLA0KIAkJCSBzdHJ1Y3QgczM5
MF9hZXNfY3R4ICpzY3R4LCBzdHJ1Y3QgYmxrY2lwaGVyX3dhbGsgKndhbGspDQogew0KIAlpbnQg
cmV0ID0gYmxrY2lwaGVyX3dhbGtfdmlydF9ibG9jayhkZXNjLCB3YWxrLCBBRVNfQkxPQ0tfU0la
RSk7DQotCXVuc2lnbmVkIGludCBpLCBuLCBuYnl0ZXM7DQotCXU4IGJ1ZltBRVNfQkxPQ0tfU0la
RV07DQotCXU4ICpvdXQsICppbjsNCisJdW5zaWduZWQgaW50IG4sIG5ieXRlczsNCisJdTggYnVm
W0FFU19CTE9DS19TSVpFXSwgY3RyYnVmW0FFU19CTE9DS19TSVpFXTsNCisJdTggKm91dCwgKmlu
LCAqY3RycHRyID0gY3RyYnVmOw0KIA0KIAlpZiAoIXdhbGstPm5ieXRlcykNCiAJCXJldHVybiBy
ZXQ7DQogDQotCW1lbWNweShjdHJibGssIHdhbGstPml2LCBBRVNfQkxPQ0tfU0laRSk7DQorCWlm
IChzcGluX3RyeWxvY2soJmN0cmJsa19sb2NrKSkNCisJCWN0cnB0ciA9IGN0cmJsazsNCisNCisJ
bWVtY3B5KGN0cnB0ciwgd2Fsay0+aXYsIEFFU19CTE9DS19TSVpFKTsNCiAJd2hpbGUgKChuYnl0
ZXMgPSB3YWxrLT5uYnl0ZXMpID49IEFFU19CTE9DS19TSVpFKSB7DQogCQlvdXQgPSB3YWxrLT5k
c3QudmlydC5hZGRyOw0KIAkJaW4gPSB3YWxrLT5zcmMudmlydC5hZGRyOw0KIAkJd2hpbGUgKG5i
eXRlcyA+PSBBRVNfQkxPQ0tfU0laRSkgew0KLQkJCS8qIG9ubHkgdXNlIGNvbXBsZXRlIGJsb2Nr
cywgbWF4LiBQQUdFX1NJWkUgKi8NCi0JCQluID0gKG5ieXRlcyA+IFBBR0VfU0laRSkgPyBQQUdF
X1NJWkUgOg0KLQkJCQkJCSBuYnl0ZXMgJiB+KEFFU19CTE9DS19TSVpFIC0gMSk7DQotCQkJZm9y
IChpID0gQUVTX0JMT0NLX1NJWkU7IGkgPCBuOyBpICs9IEFFU19CTE9DS19TSVpFKSB7DQotCQkJ
CW1lbWNweShjdHJibGsgKyBpLCBjdHJibGsgKyBpIC0gQUVTX0JMT0NLX1NJWkUsDQotCQkJCSAg
ICAgICBBRVNfQkxPQ0tfU0laRSk7DQotCQkJCWNyeXB0b19pbmMoY3RyYmxrICsgaSwgQUVTX0JM
T0NLX1NJWkUpOw0KKwkJCWlmIChjdHJwdHIgPT0gY3RyYmxrKQ0KKwkJCQluID0gX19jdHJibGtf
aW5pdChjdHJwdHIsIG5ieXRlcyk7DQorCQkJZWxzZQ0KKwkJCQluID0gQUVTX0JMT0NLX1NJWkU7
DQorCQkJcmV0ID0gY3J5cHRfczM5MF9rbWN0cihmdW5jLCBzY3R4LT5rZXksIG91dCwgaW4sDQor
CQkJCQkgICAgICAgbiwgY3RycHRyKTsNCisJCQlpZiAocmV0IDwgMCB8fCByZXQgIT0gbikgew0K
KwkJCQlpZiAoY3RycHRyID09IGN0cmJsaykNCisJCQkJCXNwaW5fdW5sb2NrKCZjdHJibGtfbG9j
ayk7DQorCQkJCXJldHVybiAtRUlPOw0KIAkJCX0NCi0JCQlyZXQgPSBjcnlwdF9zMzkwX2ttY3Ry
KGZ1bmMsIHNjdHgtPmtleSwgb3V0LCBpbiwgbiwgY3RyYmxrKTsNCi0JCQlCVUdfT04ocmV0IDwg
MCB8fCByZXQgIT0gbik7DQogCQkJaWYgKG4gPiBBRVNfQkxPQ0tfU0laRSkNCi0JCQkJbWVtY3B5
KGN0cmJsaywgY3RyYmxrICsgbiAtIEFFU19CTE9DS19TSVpFLA0KKwkJCQltZW1jcHkoY3RycHRy
LCBjdHJwdHIgKyBuIC0gQUVTX0JMT0NLX1NJWkUsDQogCQkJCSAgICAgICBBRVNfQkxPQ0tfU0la
RSk7DQotCQkJY3J5cHRvX2luYyhjdHJibGssIEFFU19CTE9DS19TSVpFKTsNCisJCQljcnlwdG9f
aW5jKGN0cnB0ciwgQUVTX0JMT0NLX1NJWkUpOw0KIAkJCW91dCArPSBuOw0KIAkJCWluICs9IG47
DQogCQkJbmJ5dGVzIC09IG47DQogCQl9DQogCQlyZXQgPSBibGtjaXBoZXJfd2Fsa19kb25lKGRl
c2MsIHdhbGssIG5ieXRlcyk7DQogCX0NCisJaWYgKGN0cnB0ciA9PSBjdHJibGspIHsNCisJCWlm
IChuYnl0ZXMpDQorCQkJbWVtY3B5KGN0cmJ1ZiwgY3RycHRyLCBBRVNfQkxPQ0tfU0laRSk7DQor
CQllbHNlDQorCQkJbWVtY3B5KHdhbGstPml2LCBjdHJwdHIsIEFFU19CTE9DS19TSVpFKTsNCisJ
CXNwaW5fdW5sb2NrKCZjdHJibGtfbG9jayk7DQorCX0NCiAJLyoNCiAJICogZmluYWwgYmxvY2sg
bWF5IGJlIDwgQUVTX0JMT0NLX1NJWkUsIGNvcHkgb25seSBuYnl0ZXMNCiAJICovDQpAQCAtNzk5
LDEzICs4MzAsMTUgQEAgc3RhdGljIGludCBjdHJfYWVzX2NyeXB0KHN0cnVjdCBibGtjaXBoZXJf
ZGVzYyAqZGVzYywgbG9uZyBmdW5jLA0KIAkJb3V0ID0gd2Fsay0+ZHN0LnZpcnQuYWRkcjsNCiAJ
CWluID0gd2Fsay0+c3JjLnZpcnQuYWRkcjsNCiAJCXJldCA9IGNyeXB0X3MzOTBfa21jdHIoZnVu
Yywgc2N0eC0+a2V5LCBidWYsIGluLA0KLQkJCQkgICAgICAgQUVTX0JMT0NLX1NJWkUsIGN0cmJs
ayk7DQotCQlCVUdfT04ocmV0IDwgMCB8fCByZXQgIT0gQUVTX0JMT0NLX1NJWkUpOw0KKwkJCQkg
ICAgICAgQUVTX0JMT0NLX1NJWkUsIGN0cmJ1Zik7DQorCQlpZiAocmV0IDwgMCB8fCByZXQgIT0g
QUVTX0JMT0NLX1NJWkUpDQorCQkJcmV0dXJuIC1FSU87DQogCQltZW1jcHkob3V0LCBidWYsIG5i
eXRlcyk7DQotCQljcnlwdG9faW5jKGN0cmJsaywgQUVTX0JMT0NLX1NJWkUpOw0KKwkJY3J5cHRv
X2luYyhjdHJidWYsIEFFU19CTE9DS19TSVpFKTsNCiAJCXJldCA9IGJsa2NpcGhlcl93YWxrX2Rv
bmUoZGVzYywgd2FsaywgMCk7DQorCQltZW1jcHkod2Fsay0+aXYsIGN0cmJ1ZiwgQUVTX0JMT0NL
X1NJWkUpOw0KIAl9DQotCW1lbWNweSh3YWxrLT5pdiwgY3RyYmxrLCBBRVNfQkxPQ0tfU0laRSk7
DQorDQogCXJldHVybiByZXQ7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvczM5MC9jcnlwdG8v
ZGVzX3MzOTAuYyBiL2FyY2gvczM5MC9jcnlwdG8vZGVzX3MzOTAuYw0KaW5kZXggYTUyYmZkMS4u
OTkxZmI3ZCAxMDA2NDQNCi0tLSBhL2FyY2gvczM5MC9jcnlwdG8vZGVzX3MzOTAuYw0KKysrIGIv
YXJjaC9zMzkwL2NyeXB0by9kZXNfczM5MC5jDQpAQCAtMjUsNiArMjUsNyBAQA0KICNkZWZpbmUg
REVTM19LRVlfU0laRQkoMyAqIERFU19LRVlfU0laRSkNCiANCiBzdGF0aWMgdTggKmN0cmJsazsN
CitzdGF0aWMgREVGSU5FX1NQSU5MT0NLKGN0cmJsa19sb2NrKTsNCiANCiBzdHJ1Y3QgczM5MF9k
ZXNfY3R4IHsNCiAJdTggaXZbREVTX0JMT0NLX1NJWkVdOw0KQEAgLTk1LDcgKzk2LDggQEAgc3Rh
dGljIGludCBlY2JfZGVzYWxsX2NyeXB0KHN0cnVjdCBibGtjaXBoZXJfZGVzYyAqZGVzYywgbG9u
ZyBmdW5jLA0KIAkJdTggKmluID0gd2Fsay0+c3JjLnZpcnQuYWRkcjsNCiANCiAJCXJldCA9IGNy
eXB0X3MzOTBfa20oZnVuYywga2V5LCBvdXQsIGluLCBuKTsNCi0JCUJVR19PTigocmV0IDwgMCkg
fHwgKHJldCAhPSBuKSk7DQorCQlpZiAocmV0IDwgMCB8fCByZXQgIT0gbikNCisJCQlyZXR1cm4g
LUVJTzsNCiANCiAJCW5ieXRlcyAmPSBERVNfQkxPQ0tfU0laRSAtIDE7DQogCQlyZXQgPSBibGtj
aXBoZXJfd2Fsa19kb25lKGRlc2MsIHdhbGssIG5ieXRlcyk7DQpAQCAtMTA1LDI4ICsxMDcsMzUg
QEAgc3RhdGljIGludCBlY2JfZGVzYWxsX2NyeXB0KHN0cnVjdCBibGtjaXBoZXJfZGVzYyAqZGVz
YywgbG9uZyBmdW5jLA0KIH0NCiANCiBzdGF0aWMgaW50IGNiY19kZXNhbGxfY3J5cHQoc3RydWN0
IGJsa2NpcGhlcl9kZXNjICpkZXNjLCBsb25nIGZ1bmMsDQotCQkJICAgIHU4ICppdiwgc3RydWN0
IGJsa2NpcGhlcl93YWxrICp3YWxrKQ0KKwkJCSAgICBzdHJ1Y3QgYmxrY2lwaGVyX3dhbGsgKndh
bGspDQogew0KKwlzdHJ1Y3QgczM5MF9kZXNfY3R4ICpjdHggPSBjcnlwdG9fYmxrY2lwaGVyX2N0
eChkZXNjLT50Zm0pOw0KIAlpbnQgcmV0ID0gYmxrY2lwaGVyX3dhbGtfdmlydChkZXNjLCB3YWxr
KTsNCiAJdW5zaWduZWQgaW50IG5ieXRlcyA9IHdhbGstPm5ieXRlczsNCisJc3RydWN0IHsNCisJ
CXU4IGl2W0RFU19CTE9DS19TSVpFXTsNCisJCXU4IGtleVtERVMzX0tFWV9TSVpFXTsNCisJfSBw
YXJhbTsNCiANCiAJaWYgKCFuYnl0ZXMpDQogCQlnb3RvIG91dDsNCiANCi0JbWVtY3B5KGl2LCB3
YWxrLT5pdiwgREVTX0JMT0NLX1NJWkUpOw0KKwltZW1jcHkocGFyYW0uaXYsIHdhbGstPml2LCBE
RVNfQkxPQ0tfU0laRSk7DQorCW1lbWNweShwYXJhbS5rZXksIGN0eC0+a2V5LCBERVMzX0tFWV9T
SVpFKTsNCiAJZG8gew0KIAkJLyogb25seSB1c2UgY29tcGxldGUgYmxvY2tzICovDQogCQl1bnNp
Z25lZCBpbnQgbiA9IG5ieXRlcyAmIH4oREVTX0JMT0NLX1NJWkUgLSAxKTsNCiAJCXU4ICpvdXQg
PSB3YWxrLT5kc3QudmlydC5hZGRyOw0KIAkJdTggKmluID0gd2Fsay0+c3JjLnZpcnQuYWRkcjsN
CiANCi0JCXJldCA9IGNyeXB0X3MzOTBfa21jKGZ1bmMsIGl2LCBvdXQsIGluLCBuKTsNCi0JCUJV
R19PTigocmV0IDwgMCkgfHwgKHJldCAhPSBuKSk7DQorCQlyZXQgPSBjcnlwdF9zMzkwX2ttYyhm
dW5jLCAmcGFyYW0sIG91dCwgaW4sIG4pOw0KKwkJaWYgKHJldCA8IDAgfHwgcmV0ICE9IG4pDQor
CQkJcmV0dXJuIC1FSU87DQogDQogCQluYnl0ZXMgJj0gREVTX0JMT0NLX1NJWkUgLSAxOw0KIAkJ
cmV0ID0gYmxrY2lwaGVyX3dhbGtfZG9uZShkZXNjLCB3YWxrLCBuYnl0ZXMpOw0KIAl9IHdoaWxl
ICgobmJ5dGVzID0gd2Fsay0+bmJ5dGVzKSk7DQotCW1lbWNweSh3YWxrLT5pdiwgaXYsIERFU19C
TE9DS19TSVpFKTsNCisJbWVtY3B5KHdhbGstPml2LCBwYXJhbS5pdiwgREVTX0JMT0NLX1NJWkUp
Ow0KIA0KIG91dDoNCiAJcmV0dXJuIHJldDsNCkBAIC0xNzksMjIgKzE4OCwyMCBAQCBzdGF0aWMg
aW50IGNiY19kZXNfZW5jcnlwdChzdHJ1Y3QgYmxrY2lwaGVyX2Rlc2MgKmRlc2MsDQogCQkJICAg
c3RydWN0IHNjYXR0ZXJsaXN0ICpkc3QsIHN0cnVjdCBzY2F0dGVybGlzdCAqc3JjLA0KIAkJCSAg
IHVuc2lnbmVkIGludCBuYnl0ZXMpDQogew0KLQlzdHJ1Y3QgczM5MF9kZXNfY3R4ICpjdHggPSBj
cnlwdG9fYmxrY2lwaGVyX2N0eChkZXNjLT50Zm0pOw0KIAlzdHJ1Y3QgYmxrY2lwaGVyX3dhbGsg
d2FsazsNCiANCiAJYmxrY2lwaGVyX3dhbGtfaW5pdCgmd2FsaywgZHN0LCBzcmMsIG5ieXRlcyk7
DQotCXJldHVybiBjYmNfZGVzYWxsX2NyeXB0KGRlc2MsIEtNQ19ERUFfRU5DUllQVCwgY3R4LT5p
diwgJndhbGspOw0KKwlyZXR1cm4gY2JjX2Rlc2FsbF9jcnlwdChkZXNjLCBLTUNfREVBX0VOQ1JZ
UFQsICZ3YWxrKTsNCiB9DQogDQogc3RhdGljIGludCBjYmNfZGVzX2RlY3J5cHQoc3RydWN0IGJs
a2NpcGhlcl9kZXNjICpkZXNjLA0KIAkJCSAgIHN0cnVjdCBzY2F0dGVybGlzdCAqZHN0LCBzdHJ1
Y3Qgc2NhdHRlcmxpc3QgKnNyYywNCiAJCQkgICB1bnNpZ25lZCBpbnQgbmJ5dGVzKQ0KIHsNCi0J
c3RydWN0IHMzOTBfZGVzX2N0eCAqY3R4ID0gY3J5cHRvX2Jsa2NpcGhlcl9jdHgoZGVzYy0+dGZt
KTsNCiAJc3RydWN0IGJsa2NpcGhlcl93YWxrIHdhbGs7DQogDQogCWJsa2NpcGhlcl93YWxrX2lu
aXQoJndhbGssIGRzdCwgc3JjLCBuYnl0ZXMpOw0KLQlyZXR1cm4gY2JjX2Rlc2FsbF9jcnlwdChk
ZXNjLCBLTUNfREVBX0RFQ1JZUFQsIGN0eC0+aXYsICZ3YWxrKTsNCisJcmV0dXJuIGNiY19kZXNh
bGxfY3J5cHQoZGVzYywgS01DX0RFQV9ERUNSWVBULCAmd2Fsayk7DQogfQ0KIA0KIHN0YXRpYyBz
dHJ1Y3QgY3J5cHRvX2FsZyBjYmNfZGVzX2FsZyA9IHsNCkBAIC0zMzEsMjIgKzMzOCwyMCBAQCBz
dGF0aWMgaW50IGNiY19kZXMzX2VuY3J5cHQoc3RydWN0IGJsa2NpcGhlcl9kZXNjICpkZXNjLA0K
IAkJCSAgICBzdHJ1Y3Qgc2NhdHRlcmxpc3QgKmRzdCwgc3RydWN0IHNjYXR0ZXJsaXN0ICpzcmMs
DQogCQkJICAgIHVuc2lnbmVkIGludCBuYnl0ZXMpDQogew0KLQlzdHJ1Y3QgczM5MF9kZXNfY3R4
ICpjdHggPSBjcnlwdG9fYmxrY2lwaGVyX2N0eChkZXNjLT50Zm0pOw0KIAlzdHJ1Y3QgYmxrY2lw
aGVyX3dhbGsgd2FsazsNCiANCiAJYmxrY2lwaGVyX3dhbGtfaW5pdCgmd2FsaywgZHN0LCBzcmMs
IG5ieXRlcyk7DQotCXJldHVybiBjYmNfZGVzYWxsX2NyeXB0KGRlc2MsIEtNQ19UREVBXzE5Ml9F
TkNSWVBULCBjdHgtPml2LCAmd2Fsayk7DQorCXJldHVybiBjYmNfZGVzYWxsX2NyeXB0KGRlc2Ms
IEtNQ19UREVBXzE5Ml9FTkNSWVBULCAmd2Fsayk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgY2JjX2Rl
czNfZGVjcnlwdChzdHJ1Y3QgYmxrY2lwaGVyX2Rlc2MgKmRlc2MsDQogCQkJICAgIHN0cnVjdCBz
Y2F0dGVybGlzdCAqZHN0LCBzdHJ1Y3Qgc2NhdHRlcmxpc3QgKnNyYywNCiAJCQkgICAgdW5zaWdu
ZWQgaW50IG5ieXRlcykNCiB7DQotCXN0cnVjdCBzMzkwX2Rlc19jdHggKmN0eCA9IGNyeXB0b19i
bGtjaXBoZXJfY3R4KGRlc2MtPnRmbSk7DQogCXN0cnVjdCBibGtjaXBoZXJfd2FsayB3YWxrOw0K
IA0KIAlibGtjaXBoZXJfd2Fsa19pbml0KCZ3YWxrLCBkc3QsIHNyYywgbmJ5dGVzKTsNCi0JcmV0
dXJuIGNiY19kZXNhbGxfY3J5cHQoZGVzYywgS01DX1RERUFfMTkyX0RFQ1JZUFQsIGN0eC0+aXYs
ICZ3YWxrKTsNCisJcmV0dXJuIGNiY19kZXNhbGxfY3J5cHQoZGVzYywgS01DX1RERUFfMTkyX0RF
Q1JZUFQsICZ3YWxrKTsNCiB9DQogDQogc3RhdGljIHN0cnVjdCBjcnlwdG9fYWxnIGNiY19kZXMz
X2FsZyA9IHsNCkBAIC0zNzIsNTIgKzM3Nyw4MCBAQCBzdGF0aWMgc3RydWN0IGNyeXB0b19hbGcg
Y2JjX2RlczNfYWxnID0gew0KIAl9DQogfTsNCiANCitzdGF0aWMgdW5zaWduZWQgaW50IF9fY3Ry
YmxrX2luaXQodTggKmN0cnB0ciwgdW5zaWduZWQgaW50IG5ieXRlcykNCit7DQorCXVuc2lnbmVk
IGludCBpLCBuOw0KKw0KKwkvKiBhbGlnbiB0byBibG9jayBzaXplLCBtYXguIFBBR0VfU0laRSAq
Lw0KKwluID0gKG5ieXRlcyA+IFBBR0VfU0laRSkgPyBQQUdFX1NJWkUgOiBuYnl0ZXMgJiB+KERF
U19CTE9DS19TSVpFIC0gMSk7DQorCWZvciAoaSA9IERFU19CTE9DS19TSVpFOyBpIDwgbjsgaSAr
PSBERVNfQkxPQ0tfU0laRSkgew0KKwkJbWVtY3B5KGN0cnB0ciArIGksIGN0cnB0ciArIGkgLSBE
RVNfQkxPQ0tfU0laRSwgREVTX0JMT0NLX1NJWkUpOw0KKwkJY3J5cHRvX2luYyhjdHJwdHIgKyBp
LCBERVNfQkxPQ0tfU0laRSk7DQorCX0NCisJcmV0dXJuIG47DQorfQ0KKw0KIHN0YXRpYyBpbnQg
Y3RyX2Rlc2FsbF9jcnlwdChzdHJ1Y3QgYmxrY2lwaGVyX2Rlc2MgKmRlc2MsIGxvbmcgZnVuYywN
Ci0JCQkgICAgc3RydWN0IHMzOTBfZGVzX2N0eCAqY3R4LCBzdHJ1Y3QgYmxrY2lwaGVyX3dhbGsg
KndhbGspDQorCQkJICAgIHN0cnVjdCBzMzkwX2Rlc19jdHggKmN0eCwNCisJCQkgICAgc3RydWN0
IGJsa2NpcGhlcl93YWxrICp3YWxrKQ0KIHsNCiAJaW50IHJldCA9IGJsa2NpcGhlcl93YWxrX3Zp
cnRfYmxvY2soZGVzYywgd2FsaywgREVTX0JMT0NLX1NJWkUpOw0KLQl1bnNpZ25lZCBpbnQgaSwg
biwgbmJ5dGVzOw0KLQl1OCBidWZbREVTX0JMT0NLX1NJWkVdOw0KLQl1OCAqb3V0LCAqaW47DQor
CXVuc2lnbmVkIGludCBuLCBuYnl0ZXM7DQorCXU4IGJ1ZltERVNfQkxPQ0tfU0laRV0sIGN0cmJ1
ZltERVNfQkxPQ0tfU0laRV07DQorCXU4ICpvdXQsICppbiwgKmN0cnB0ciA9IGN0cmJ1ZjsNCisN
CisJaWYgKCF3YWxrLT5uYnl0ZXMpDQorCQlyZXR1cm4gcmV0Ow0KKw0KKwlpZiAoc3Bpbl90cnls
b2NrKCZjdHJibGtfbG9jaykpDQorCQljdHJwdHIgPSBjdHJibGs7DQogDQotCW1lbWNweShjdHJi
bGssIHdhbGstPml2LCBERVNfQkxPQ0tfU0laRSk7DQorCW1lbWNweShjdHJwdHIsIHdhbGstPml2
LCBERVNfQkxPQ0tfU0laRSk7DQogCXdoaWxlICgobmJ5dGVzID0gd2Fsay0+bmJ5dGVzKSA+PSBE
RVNfQkxPQ0tfU0laRSkgew0KIAkJb3V0ID0gd2Fsay0+ZHN0LnZpcnQuYWRkcjsNCiAJCWluID0g
d2Fsay0+c3JjLnZpcnQuYWRkcjsNCiAJCXdoaWxlIChuYnl0ZXMgPj0gREVTX0JMT0NLX1NJWkUp
IHsNCi0JCQkvKiBhbGlnbiB0byBibG9jayBzaXplLCBtYXguIFBBR0VfU0laRSAqLw0KLQkJCW4g
PSAobmJ5dGVzID4gUEFHRV9TSVpFKSA/IFBBR0VfU0laRSA6DQotCQkJCW5ieXRlcyAmIH4oREVT
X0JMT0NLX1NJWkUgLSAxKTsNCi0JCQlmb3IgKGkgPSBERVNfQkxPQ0tfU0laRTsgaSA8IG47IGkg
Kz0gREVTX0JMT0NLX1NJWkUpIHsNCi0JCQkJbWVtY3B5KGN0cmJsayArIGksIGN0cmJsayArIGkg
LSBERVNfQkxPQ0tfU0laRSwNCi0JCQkJICAgICAgIERFU19CTE9DS19TSVpFKTsNCi0JCQkJY3J5
cHRvX2luYyhjdHJibGsgKyBpLCBERVNfQkxPQ0tfU0laRSk7DQorCQkJaWYgKGN0cnB0ciA9PSBj
dHJibGspDQorCQkJCW4gPSBfX2N0cmJsa19pbml0KGN0cnB0ciwgbmJ5dGVzKTsNCisJCQllbHNl
DQorCQkJCW4gPSBERVNfQkxPQ0tfU0laRTsNCisJCQlyZXQgPSBjcnlwdF9zMzkwX2ttY3RyKGZ1
bmMsIGN0eC0+a2V5LCBvdXQsIGluLA0KKwkJCQkJICAgICAgIG4sIGN0cnB0cik7DQorCQkJaWYg
KHJldCA8IDAgfHwgcmV0ICE9IG4pIHsNCisJCQkJaWYgKGN0cnB0ciA9PSBjdHJibGspDQorCQkJ
CQlzcGluX3VubG9jaygmY3RyYmxrX2xvY2spOw0KKwkJCQlyZXR1cm4gLUVJTzsNCiAJCQl9DQot
CQkJcmV0ID0gY3J5cHRfczM5MF9rbWN0cihmdW5jLCBjdHgtPmtleSwgb3V0LCBpbiwgbiwgY3Ry
YmxrKTsNCi0JCQlCVUdfT04oKHJldCA8IDApIHx8IChyZXQgIT0gbikpOw0KIAkJCWlmIChuID4g
REVTX0JMT0NLX1NJWkUpDQotCQkJCW1lbWNweShjdHJibGssIGN0cmJsayArIG4gLSBERVNfQkxP
Q0tfU0laRSwNCisJCQkJbWVtY3B5KGN0cnB0ciwgY3RycHRyICsgbiAtIERFU19CTE9DS19TSVpF
LA0KIAkJCQkgICAgICAgREVTX0JMT0NLX1NJWkUpOw0KLQkJCWNyeXB0b19pbmMoY3RyYmxrLCBE
RVNfQkxPQ0tfU0laRSk7DQorCQkJY3J5cHRvX2luYyhjdHJwdHIsIERFU19CTE9DS19TSVpFKTsN
CiAJCQlvdXQgKz0gbjsNCiAJCQlpbiArPSBuOw0KIAkJCW5ieXRlcyAtPSBuOw0KIAkJfQ0KIAkJ
cmV0ID0gYmxrY2lwaGVyX3dhbGtfZG9uZShkZXNjLCB3YWxrLCBuYnl0ZXMpOw0KIAl9DQotDQor
CWlmIChjdHJwdHIgPT0gY3RyYmxrKSB7DQorCQlpZiAobmJ5dGVzKQ0KKwkJCW1lbWNweShjdHJi
dWYsIGN0cnB0ciwgREVTX0JMT0NLX1NJWkUpOw0KKwkJZWxzZQ0KKwkJCW1lbWNweSh3YWxrLT5p
diwgY3RycHRyLCBERVNfQkxPQ0tfU0laRSk7DQorCQlzcGluX3VubG9jaygmY3RyYmxrX2xvY2sp
Ow0KKwl9DQogCS8qIGZpbmFsIGJsb2NrIG1heSBiZSA8IERFU19CTE9DS19TSVpFLCBjb3B5IG9u
bHkgbmJ5dGVzICovDQogCWlmIChuYnl0ZXMpIHsNCiAJCW91dCA9IHdhbGstPmRzdC52aXJ0LmFk
ZHI7DQogCQlpbiA9IHdhbGstPnNyYy52aXJ0LmFkZHI7DQogCQlyZXQgPSBjcnlwdF9zMzkwX2tt
Y3RyKGZ1bmMsIGN0eC0+a2V5LCBidWYsIGluLA0KLQkJCQkgICAgICAgREVTX0JMT0NLX1NJWkUs
IGN0cmJsayk7DQotCQlCVUdfT04ocmV0IDwgMCB8fCByZXQgIT0gREVTX0JMT0NLX1NJWkUpOw0K
KwkJCQkgICAgICAgREVTX0JMT0NLX1NJWkUsIGN0cmJ1Zik7DQorCQlpZiAocmV0IDwgMCB8fCBy
ZXQgIT0gREVTX0JMT0NLX1NJWkUpDQorCQkJcmV0dXJuIC1FSU87DQogCQltZW1jcHkob3V0LCBi
dWYsIG5ieXRlcyk7DQotCQljcnlwdG9faW5jKGN0cmJsaywgREVTX0JMT0NLX1NJWkUpOw0KKwkJ
Y3J5cHRvX2luYyhjdHJidWYsIERFU19CTE9DS19TSVpFKTsNCiAJCXJldCA9IGJsa2NpcGhlcl93
YWxrX2RvbmUoZGVzYywgd2FsaywgMCk7DQorCQltZW1jcHkod2Fsay0+aXYsIGN0cmJ1ZiwgREVT
X0JMT0NLX1NJWkUpOw0KIAl9DQotCW1lbWNweSh3YWxrLT5pdiwgY3RyYmxrLCBERVNfQkxPQ0tf
U0laRSk7DQogCXJldHVybiByZXQ7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvczM5MC9jcnlw
dG8vZ2hhc2hfczM5MC5jIGIvYXJjaC9zMzkwL2NyeXB0by9naGFzaF9zMzkwLmMNCmluZGV4IGIx
YmQxNzAuLmY2MzczZjAgMTAwNjQ0DQotLS0gYS9hcmNoL3MzOTAvY3J5cHRvL2doYXNoX3MzOTAu
Yw0KKysrIGIvYXJjaC9zMzkwL2NyeXB0by9naGFzaF9zMzkwLmMNCkBAIC03MiwxNCArNzIsMTYg
QEAgc3RhdGljIGludCBnaGFzaF91cGRhdGUoc3RydWN0IHNoYXNoX2Rlc2MgKmRlc2MsDQogCQlp
ZiAoIWRjdHgtPmJ5dGVzKSB7DQogCQkJcmV0ID0gY3J5cHRfczM5MF9raW1kKEtJTURfR0hBU0gs
IGN0eCwgYnVmLA0KIAkJCQkJICAgICAgR0hBU0hfQkxPQ0tfU0laRSk7DQotCQkJQlVHX09OKHJl
dCAhPSBHSEFTSF9CTE9DS19TSVpFKTsNCisJCQlpZiAocmV0ICE9IEdIQVNIX0JMT0NLX1NJWkUp
DQorCQkJCXJldHVybiAtRUlPOw0KIAkJfQ0KIAl9DQogDQogCW4gPSBzcmNsZW4gJiB+KEdIQVNI
X0JMT0NLX1NJWkUgLSAxKTsNCiAJaWYgKG4pIHsNCiAJCXJldCA9IGNyeXB0X3MzOTBfa2ltZChL
SU1EX0dIQVNILCBjdHgsIHNyYywgbik7DQotCQlCVUdfT04ocmV0ICE9IG4pOw0KKwkJaWYgKHJl
dCAhPSBuKQ0KKwkJCXJldHVybiAtRUlPOw0KIAkJc3JjICs9IG47DQogCQlzcmNsZW4gLT0gbjsN
CiAJfQ0KQEAgLTkyLDcgKzk0LDcgQEAgc3RhdGljIGludCBnaGFzaF91cGRhdGUoc3RydWN0IHNo
YXNoX2Rlc2MgKmRlc2MsDQogCXJldHVybiAwOw0KIH0NCiANCi1zdGF0aWMgdm9pZCBnaGFzaF9m
bHVzaChzdHJ1Y3QgZ2hhc2hfY3R4ICpjdHgsIHN0cnVjdCBnaGFzaF9kZXNjX2N0eCAqZGN0eCkN
CitzdGF0aWMgaW50IGdoYXNoX2ZsdXNoKHN0cnVjdCBnaGFzaF9jdHggKmN0eCwgc3RydWN0IGdo
YXNoX2Rlc2NfY3R4ICpkY3R4KQ0KIHsNCiAJdTggKmJ1ZiA9IGRjdHgtPmJ1ZmZlcjsNCiAJaW50
IHJldDsNCkBAIC0xMDMsMjEgKzEwNSwyNCBAQCBzdGF0aWMgdm9pZCBnaGFzaF9mbHVzaChzdHJ1
Y3QgZ2hhc2hfY3R4ICpjdHgsIHN0cnVjdCBnaGFzaF9kZXNjX2N0eCAqZGN0eCkNCiAJCW1lbXNl
dChwb3MsIDAsIGRjdHgtPmJ5dGVzKTsNCiANCiAJCXJldCA9IGNyeXB0X3MzOTBfa2ltZChLSU1E
X0dIQVNILCBjdHgsIGJ1ZiwgR0hBU0hfQkxPQ0tfU0laRSk7DQotCQlCVUdfT04ocmV0ICE9IEdI
QVNIX0JMT0NLX1NJWkUpOw0KKwkJaWYgKHJldCAhPSBHSEFTSF9CTE9DS19TSVpFKQ0KKwkJCXJl
dHVybiAtRUlPOw0KIAl9DQogDQogCWRjdHgtPmJ5dGVzID0gMDsNCisJcmV0dXJuIDA7DQogfQ0K
IA0KIHN0YXRpYyBpbnQgZ2hhc2hfZmluYWwoc3RydWN0IHNoYXNoX2Rlc2MgKmRlc2MsIHU4ICpk
c3QpDQogew0KIAlzdHJ1Y3QgZ2hhc2hfZGVzY19jdHggKmRjdHggPSBzaGFzaF9kZXNjX2N0eChk
ZXNjKTsNCiAJc3RydWN0IGdoYXNoX2N0eCAqY3R4ID0gY3J5cHRvX3NoYXNoX2N0eChkZXNjLT50
Zm0pOw0KKwlpbnQgcmV0Ow0KIA0KLQlnaGFzaF9mbHVzaChjdHgsIGRjdHgpOw0KLQltZW1jcHko
ZHN0LCBjdHgtPmljdiwgR0hBU0hfQkxPQ0tfU0laRSk7DQotDQotCXJldHVybiAwOw0KKwlyZXQg
PSBnaGFzaF9mbHVzaChjdHgsIGRjdHgpOw0KKwlpZiAoIXJldCkNCisJCW1lbWNweShkc3QsIGN0
eC0+aWN2LCBHSEFTSF9CTE9DS19TSVpFKTsNCisJcmV0dXJuIHJldDsNCiB9DQogDQogc3RhdGlj
IHN0cnVjdCBzaGFzaF9hbGcgZ2hhc2hfYWxnID0gew0KZGlmZiAtLWdpdCBhL2FyY2gvczM5MC9j
cnlwdG8vc2hhX2NvbW1vbi5jIGIvYXJjaC9zMzkwL2NyeXB0by9zaGFfY29tbW9uLmMNCmluZGV4
IGJkMzdkMDkuLjg2MjBiMGUgMTAwNjQ0DQotLS0gYS9hcmNoL3MzOTAvY3J5cHRvL3NoYV9jb21t
b24uYw0KKysrIGIvYXJjaC9zMzkwL2NyeXB0by9zaGFfY29tbW9uLmMNCkBAIC0zNiw3ICszNiw4
IEBAIGludCBzMzkwX3NoYV91cGRhdGUoc3RydWN0IHNoYXNoX2Rlc2MgKmRlc2MsIGNvbnN0IHU4
ICpkYXRhLCB1bnNpZ25lZCBpbnQgbGVuKQ0KIAlpZiAoaW5kZXgpIHsNCiAJCW1lbWNweShjdHgt
PmJ1ZiArIGluZGV4LCBkYXRhLCBic2l6ZSAtIGluZGV4KTsNCiAJCXJldCA9IGNyeXB0X3MzOTBf
a2ltZChjdHgtPmZ1bmMsIGN0eC0+c3RhdGUsIGN0eC0+YnVmLCBic2l6ZSk7DQotCQlCVUdfT04o
cmV0ICE9IGJzaXplKTsNCisJCWlmIChyZXQgIT0gYnNpemUpDQorCQkJcmV0dXJuIC1FSU87DQog
CQlkYXRhICs9IGJzaXplIC0gaW5kZXg7DQogCQlsZW4gLT0gYnNpemUgLSBpbmRleDsNCiAJCWlu
ZGV4ID0gMDsNCkBAIC00Niw3ICs0Nyw4IEBAIGludCBzMzkwX3NoYV91cGRhdGUoc3RydWN0IHNo
YXNoX2Rlc2MgKmRlc2MsIGNvbnN0IHU4ICpkYXRhLCB1bnNpZ25lZCBpbnQgbGVuKQ0KIAlpZiAo
bGVuID49IGJzaXplKSB7DQogCQlyZXQgPSBjcnlwdF9zMzkwX2tpbWQoY3R4LT5mdW5jLCBjdHgt
PnN0YXRlLCBkYXRhLA0KIAkJCQkgICAgICBsZW4gJiB+KGJzaXplIC0gMSkpOw0KLQkJQlVHX09O
KHJldCAhPSAobGVuICYgfihic2l6ZSAtIDEpKSk7DQorCQlpZiAocmV0ICE9IChsZW4gJiB+KGJz
aXplIC0gMSkpKQ0KKwkJCXJldHVybiAtRUlPOw0KIAkJZGF0YSArPSByZXQ7DQogCQlsZW4gLT0g
cmV0Ow0KIAl9DQpAQCAtODgsNyArOTAsOCBAQCBpbnQgczM5MF9zaGFfZmluYWwoc3RydWN0IHNo
YXNoX2Rlc2MgKmRlc2MsIHU4ICpvdXQpDQogCW1lbWNweShjdHgtPmJ1ZiArIGVuZCAtIDgsICZi
aXRzLCBzaXplb2YoYml0cykpOw0KIA0KIAlyZXQgPSBjcnlwdF9zMzkwX2tpbWQoY3R4LT5mdW5j
LCBjdHgtPnN0YXRlLCBjdHgtPmJ1ZiwgZW5kKTsNCi0JQlVHX09OKHJldCAhPSBlbmQpOw0KKwlp
ZiAocmV0ICE9IGVuZCkNCisJCXJldHVybiAtRUlPOw0KIA0KIAkvKiBjb3B5IGRpZ2VzdCB0byBv
dXQgKi8NCiAJbWVtY3B5KG91dCwgY3R4LT5zdGF0ZSwgY3J5cHRvX3NoYXNoX2RpZ2VzdHNpemUo
ZGVzYy0+dGZtKSk7DQpkaWZmIC0tZ2l0IGEvYXJjaC9zMzkwL21tL3BhZ2Utc3RhdGVzLmMgYi9h
cmNoL3MzOTAvbW0vcGFnZS1zdGF0ZXMuYw0KaW5kZXggYTkwZDQ1ZS4uMjdjNTBmNCAxMDA2NDQN
Ci0tLSBhL2FyY2gvczM5MC9tbS9wYWdlLXN0YXRlcy5jDQorKysgYi9hcmNoL3MzOTAvbW0vcGFn
ZS1zdGF0ZXMuYw0KQEAgLTEyLDYgKzEyLDggQEANCiAjaW5jbHVkZSA8bGludXgvbW0uaD4NCiAj
aW5jbHVkZSA8bGludXgvZ2ZwLmg+DQogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4NCisjaW5jbHVk
ZSA8YXNtL3NldHVwLmg+DQorI2luY2x1ZGUgPGFzbS9pcGwuaD4NCiANCiAjZGVmaW5lIEVTU0Ff
U0VUX1NUQUJMRQkJMQ0KICNkZWZpbmUgRVNTQV9TRVRfVU5VU0VECQkyDQpAQCAtNDEsNiArNDMs
MTQgQEAgdm9pZCBfX2luaXQgY21tYV9pbml0KHZvaWQpDQogDQogCWlmICghY21tYV9mbGFnKQ0K
IAkJcmV0dXJuOw0KKwkvKg0KKwkgKiBEaXNhYmxlIENNTSBmb3IgZHVtcCwgb3RoZXJ3aXNlICB0
aGUgdHByb3QgYmFzZWQgbWVtb3J5DQorCSAqIGRldGVjdGlvbiBjYW4gZmFpbCBiZWNhdXNlIG9m
IHVuc3RhYmxlIHBhZ2VzLg0KKwkgKi8NCisJaWYgKE9MRE1FTV9CQVNFIHx8IGlwbF9pbmZvLnR5
cGUgPT0gSVBMX1RZUEVfRkNQX0RVTVApIHsNCisJCWNtbWFfZmxhZyA9IDA7DQorCQlyZXR1cm47
DQorCX0NCiAJYXNtIHZvbGF0aWxlKA0KIAkJIiAgICAgICAuaW5zbiBycmYsMHhiOWFiMDAwMCwl
MSwlMSwwLDBcbiINCiAJCSIwOiAgICAgbGEgICAgICAlMCwwXG4iDQpkaWZmIC0tZ2l0IGEvYXJj
aC94ODYvaW5jbHVkZS9hc20vaXJxLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9pcnEuaA0KaW5k
ZXggYmE4NzBiYi4uZjk3MTM0YSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2ly
cS5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9pcnEuaA0KQEAgLTI1LDYgKzI1LDcgQEAg
ZXh0ZXJuIHZvaWQgaXJxX2N0eF9pbml0KGludCBjcHUpOw0KIA0KICNpZmRlZiBDT05GSUdfSE9U
UExVR19DUFUNCiAjaW5jbHVkZSA8bGludXgvY3B1bWFzay5oPg0KK2V4dGVybiBpbnQgY2hlY2tf
aXJxX3ZlY3RvcnNfZm9yX2NwdV9kaXNhYmxlKHZvaWQpOw0KIGV4dGVybiB2b2lkIGZpeHVwX2ly
cXModm9pZCk7DQogZXh0ZXJuIHZvaWQgaXJxX2ZvcmNlX2NvbXBsZXRlX21vdmUoaW50KTsNCiAj
ZW5kaWYNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3BlcmZfZXZlbnQuYyBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudC5jDQppbmRleCAyYmRhMjEyLi4xYzA0MWUwIDEw
MDY0NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50LmMNCisrKyBiL2FyY2gv
eDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudC5jDQpAQCAtOTcxLDYgKzk3MSw5IEBAIHN0YXRpYyB2
b2lkIHg4Nl9wbXVfZGVsKHN0cnVjdCBwZXJmX2V2ZW50ICpldmVudCwgaW50IGZsYWdzKQ0KIAlm
b3IgKGkgPSAwOyBpIDwgY3B1Yy0+bl9ldmVudHM7IGkrKykgew0KIAkJaWYgKGV2ZW50ID09IGNw
dWMtPmV2ZW50X2xpc3RbaV0pIHsNCiANCisJCQlpZiAoaSA+PSBjcHVjLT5uX2V2ZW50cyAtIGNw
dWMtPm5fYWRkZWQpDQorCQkJCS0tY3B1Yy0+bl9hZGRlZDsNCisNCiAJCQlpZiAoeDg2X3BtdS5w
dXRfZXZlbnRfY29uc3RyYWludHMpDQogCQkJCXg4Nl9wbXUucHV0X2V2ZW50X2NvbnN0cmFpbnRz
KGNwdWMsIGV2ZW50KTsNCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvaXJxLmMgYi9h
cmNoL3g4Ni9rZXJuZWwvaXJxLmMNCmluZGV4IGZiMmViMzIuLjY4NzYzN2IgMTAwNjQ0DQotLS0g
YS9hcmNoL3g4Ni9rZXJuZWwvaXJxLmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9pcnEuYw0KQEAg
LTIyMiw2ICsyMjIsNzYgQEAgdm9pZCBzbXBfeDg2X3BsYXRmb3JtX2lwaShzdHJ1Y3QgcHRfcmVn
cyAqcmVncykNCiBFWFBPUlRfU1lNQk9MX0dQTCh2ZWN0b3JfdXNlZF9ieV9wZXJjcHVfaXJxKTsN
CiANCiAjaWZkZWYgQ09ORklHX0hPVFBMVUdfQ1BVDQorLyoNCisgKiBUaGlzIGNwdSBpcyBnb2lu
ZyB0byBiZSByZW1vdmVkIGFuZCBpdHMgdmVjdG9ycyBtaWdyYXRlZCB0byB0aGUgcmVtYWluaW5n
DQorICogb25saW5lIGNwdXMuICBDaGVjayB0byBzZWUgaWYgdGhlcmUgYXJlIGVub3VnaCB2ZWN0
b3JzIGluIHRoZSByZW1haW5pbmcgY3B1cy4NCisgKiBUaGlzIGZ1bmN0aW9uIGlzIHByb3RlY3Rl
ZCBieSBzdG9wX21hY2hpbmUoKS4NCisgKi8NCitpbnQgY2hlY2tfaXJxX3ZlY3RvcnNfZm9yX2Nw
dV9kaXNhYmxlKHZvaWQpDQorew0KKwlpbnQgaXJxLCBjcHU7DQorCXVuc2lnbmVkIGludCB0aGlz
X2NwdSwgdmVjdG9yLCB0aGlzX2NvdW50LCBjb3VudDsNCisJc3RydWN0IGlycV9kZXNjICpkZXNj
Ow0KKwlzdHJ1Y3QgaXJxX2RhdGEgKmRhdGE7DQorCXN0cnVjdCBjcHVtYXNrIGFmZmluaXR5X25l
dywgb25saW5lX25ldzsNCisNCisJdGhpc19jcHUgPSBzbXBfcHJvY2Vzc29yX2lkKCk7DQorCWNw
dW1hc2tfY29weSgmb25saW5lX25ldywgY3B1X29ubGluZV9tYXNrKTsNCisJY3B1X2NsZWFyKHRo
aXNfY3B1LCBvbmxpbmVfbmV3KTsNCisNCisJdGhpc19jb3VudCA9IDA7DQorCWZvciAodmVjdG9y
ID0gRklSU1RfRVhURVJOQUxfVkVDVE9SOyB2ZWN0b3IgPCBOUl9WRUNUT1JTOyB2ZWN0b3IrKykg
ew0KKwkJaXJxID0gX190aGlzX2NwdV9yZWFkKHZlY3Rvcl9pcnFbdmVjdG9yXSk7DQorCQlpZiAo
aXJxID49IDApIHsNCisJCQlkZXNjID0gaXJxX3RvX2Rlc2MoaXJxKTsNCisJCQlkYXRhID0gaXJx
X2Rlc2NfZ2V0X2lycV9kYXRhKGRlc2MpOw0KKwkJCWNwdW1hc2tfY29weSgmYWZmaW5pdHlfbmV3
LCBkYXRhLT5hZmZpbml0eSk7DQorCQkJY3B1X2NsZWFyKHRoaXNfY3B1LCBhZmZpbml0eV9uZXcp
Ow0KKw0KKwkJCS8qIERvIG5vdCBjb3VudCBpbmFjdGl2ZSBvciBwZXItY3B1IGlycXMuICovDQor
CQkJaWYgKCFpcnFfaGFzX2FjdGlvbihpcnEpIHx8IGlycWRfaXNfcGVyX2NwdShkYXRhKSkNCisJ
CQkJY29udGludWU7DQorDQorCQkJLyoNCisJCQkgKiBBIHNpbmdsZSBpcnEgbWF5IGJlIG1hcHBl
ZCB0byBtdWx0aXBsZQ0KKwkJCSAqIGNwdSdzIHZlY3Rvcl9pcnFbXSAoZm9yIGV4YW1wbGUgSU9B
UElDIGNsdXN0ZXINCisJCQkgKiBtb2RlKS4gIEluIHRoaXMgY2FzZSB3ZSBoYXZlIHR3bw0KKwkJ
CSAqIHBvc3NpYmlsaXRpZXM6DQorCQkJICoNCisJCQkgKiAxKSB0aGUgcmVzdWx0aW5nIGFmZmlu
aXR5IG1hc2sgaXMgZW1wdHk7IHRoYXQgaXMNCisJCQkgKiB0aGlzIHRoZSBkb3duJ2QgY3B1IGlz
IHRoZSBsYXN0IGNwdSBpbiB0aGUgaXJxJ3MNCisJCQkgKiBhZmZpbml0eSBtYXNrLCBvcg0KKwkJ
CSAqDQorCQkJICogMikgdGhlIHJlc3VsdGluZyBhZmZpbml0eSBtYXNrIGlzIG5vIGxvbmdlcg0K
KwkJCSAqIGEgc3Vic2V0IG9mIHRoZSBvbmxpbmUgY3B1cyBidXQgdGhlIGFmZmluaXR5DQorCQkJ
ICogbWFzayBpcyBub3QgemVybzsgdGhhdCBpcyB0aGUgZG93bidkIGNwdSBpcyB0aGUNCisJCQkg
KiBsYXN0IG9ubGluZSBjcHUgaW4gYSB1c2VyIHNldCBhZmZpbml0eSBtYXNrLg0KKwkJCSAqLw0K
KwkJCWlmIChjcHVtYXNrX2VtcHR5KCZhZmZpbml0eV9uZXcpIHx8DQorCQkJICAgICFjcHVtYXNr
X3N1YnNldCgmYWZmaW5pdHlfbmV3LCAmb25saW5lX25ldykpDQorCQkJCXRoaXNfY291bnQrKzsN
CisJCX0NCisJfQ0KKw0KKwljb3VudCA9IDA7DQorCWZvcl9lYWNoX29ubGluZV9jcHUoY3B1KSB7
DQorCQlpZiAoY3B1ID09IHRoaXNfY3B1KQ0KKwkJCWNvbnRpbnVlOw0KKwkJZm9yICh2ZWN0b3Ig
PSBGSVJTVF9FWFRFUk5BTF9WRUNUT1I7IHZlY3RvciA8IE5SX1ZFQ1RPUlM7DQorCQkgICAgIHZl
Y3RvcisrKSB7DQorCQkJaWYgKHBlcl9jcHUodmVjdG9yX2lycSwgY3B1KVt2ZWN0b3JdIDwgMCkN
CisJCQkJY291bnQrKzsNCisJCX0NCisJfQ0KKw0KKwlpZiAoY291bnQgPCB0aGlzX2NvdW50KSB7
DQorCQlwcl93YXJuKCJDUFUgJWQgZGlzYWJsZSBmYWlsZWQ6IENQVSBoYXMgJXUgdmVjdG9ycyBh
c3NpZ25lZCBhbmQgdGhlcmUgYXJlIG9ubHkgJXUgYXZhaWxhYmxlLlxuIiwNCisJCQl0aGlzX2Nw
dSwgdGhpc19jb3VudCwgY291bnQpOw0KKwkJcmV0dXJuIC1FUkFOR0U7DQorCX0NCisJcmV0dXJu
IDA7DQorfQ0KKw0KIC8qIEEgY3B1IGhhcyBiZWVuIHJlbW92ZWQgZnJvbSBjcHVfb25saW5lX21h
c2suICBSZXNldCBpcnEgYWZmaW5pdGllcy4gKi8NCiB2b2lkIGZpeHVwX2lycXModm9pZCkNCiB7
DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3F1aXJrcy5jIGIvYXJjaC94ODYva2VybmVs
L3F1aXJrcy5jDQppbmRleCAwMzkyMGExLi4yOGEzZTYyIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYv
a2VybmVsL3F1aXJrcy5jDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwvcXVpcmtzLmMNCkBAIC01MjUs
NyArNTI1LDcgQEAgc3RhdGljIHZvaWQgX19pbml0IHF1aXJrX2FtZF9uYl9ub2RlKHN0cnVjdCBw
Y2lfZGV2ICpkZXYpDQogCQlyZXR1cm47DQogDQogCXBjaV9yZWFkX2NvbmZpZ19kd29yZChuYl9o
dCwgMHg2MCwgJnZhbCk7DQotCW5vZGUgPSB2YWwgJiA3Ow0KKwlub2RlID0gcGNpYnVzX3RvX25v
ZGUoZGV2LT5idXMpIHwgKHZhbCAmIDcpOw0KIAkvKg0KIAkgKiBTb21lIGhhcmR3YXJlIG1heSBy
ZXR1cm4gYW4gaW52YWxpZCBub2RlIElELA0KIAkgKiBzbyBjaGVjayBpdCBmaXJzdDoNCmRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvc21wYm9vdC5jIGIvYXJjaC94ODYva2VybmVsL3NtcGJv
b3QuYw0KaW5kZXggOWY1NDhjYi4uYjg4ZWFkYiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2tlcm5l
bC9zbXBib290LmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9zbXBib290LmMNCkBAIC0xMjc4LDYg
KzEyNzgsNyBAQCB2b2lkIGNwdV9kaXNhYmxlX2NvbW1vbih2b2lkKQ0KIGludCBuYXRpdmVfY3B1
X2Rpc2FibGUodm9pZCkNCiB7DQogCWludCBjcHUgPSBzbXBfcHJvY2Vzc29yX2lkKCk7DQorCWlu
dCByZXQ7DQogDQogCS8qDQogCSAqIFBlcmhhcHMgdXNlIGNwdWZyZXEgdG8gZHJvcCBmcmVxdWVu
Y3ksIGJ1dCB0aGF0IGNvdWxkIGdvDQpAQCAtMTI5MCw2ICsxMjkxLDEwIEBAIGludCBuYXRpdmVf
Y3B1X2Rpc2FibGUodm9pZCkNCiAJaWYgKGNwdSA9PSAwKQ0KIAkJcmV0dXJuIC1FQlVTWTsNCiAN
CisJcmV0ID0gY2hlY2tfaXJxX3ZlY3RvcnNfZm9yX2NwdV9kaXNhYmxlKCk7DQorCWlmIChyZXQp
DQorCQlyZXR1cm4gcmV0Ow0KKw0KIAljbGVhcl9sb2NhbF9BUElDKCk7DQogDQogCWNwdV9kaXNh
YmxlX2NvbW1vbigpOw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9pODI1NC5jIGIvYXJjaC94
ODYva3ZtL2k4MjU0LmMNCmluZGV4IDQwNWYyNjIuLjEzOTQxNWUgMTAwNjQ0DQotLS0gYS9hcmNo
L3g4Ni9rdm0vaTgyNTQuYw0KKysrIGIvYXJjaC94ODYva3ZtL2k4MjU0LmMNCkBAIC0zOCw2ICsz
OCw3IEBADQogDQogI2luY2x1ZGUgImlycS5oIg0KICNpbmNsdWRlICJpODI1NC5oIg0KKyNpbmNs
dWRlICJ4ODYuaCINCiANCiAjaWZuZGVmIENPTkZJR19YODZfNjQNCiAjZGVmaW5lIG1vZF82NCh4
LCB5KSAoKHgpIC0gKHkpICogZGl2NjRfdTY0KHgsIHkpKQ0KQEAgLTM2NCw2ICszNjUsMjMgQEAg
c3RhdGljIHZvaWQgY3JlYXRlX3BpdF90aW1lcihzdHJ1Y3Qga3ZtICprdm0sIHUzMiB2YWwsIGlu
dCBpc19wZXJpb2QpDQogCWF0b21pY19zZXQoJnB0LT5wZW5kaW5nLCAwKTsNCiAJcHMtPmlycV9h
Y2sgPSAxOw0KIA0KKwkvKg0KKwkgKiBEbyBub3QgYWxsb3cgdGhlIGd1ZXN0IHRvIHByb2dyYW0g
cGVyaW9kaWMgdGltZXJzIHdpdGggc21hbGwNCisJICogaW50ZXJ2YWwsIHNpbmNlIHRoZSBocnRp
bWVycyBhcmUgbm90IHRocm90dGxlZCBieSB0aGUgaG9zdA0KKwkgKiBzY2hlZHVsZXIuDQorCSAq
Lw0KKwlpZiAocHMtPmlzX3BlcmlvZGljKSB7DQorCQlzNjQgbWluX3BlcmlvZCA9IG1pbl90aW1l
cl9wZXJpb2RfdXMgKiAxMDAwTEw7DQorDQorCQlpZiAocHQtPnBlcmlvZCA8IG1pbl9wZXJpb2Qp
IHsNCisJCQlwcl9pbmZvX3JhdGVsaW1pdGVkKA0KKwkJCSAgICAia3ZtOiByZXF1ZXN0ZWQgJWxs
ZCBucyAiDQorCQkJICAgICJpODI1NCB0aW1lciBwZXJpb2QgbGltaXRlZCB0byAlbGxkIG5zXG4i
LA0KKwkJCSAgICBwdC0+cGVyaW9kLCBtaW5fcGVyaW9kKTsNCisJCQlwdC0+cGVyaW9kID0gbWlu
X3BlcmlvZDsNCisJCX0NCisJfQ0KKw0KIAlocnRpbWVyX3N0YXJ0KCZwdC0+dGltZXIsIGt0aW1l
X2FkZF9ucyhrdGltZV9nZXQoKSwgaW50ZXJ2YWwpLA0KIAkJICAgICAgSFJUSU1FUl9NT0RFX0FC
Uyk7DQogfQ0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9sYXBpYy5jIGIvYXJjaC94ODYva3Zt
L2xhcGljLmMNCmluZGV4IDc1N2M3MTYuLjE3NjIwNWEgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9r
dm0vbGFwaWMuYw0KKysrIGIvYXJjaC94ODYva3ZtL2xhcGljLmMNCkBAIC02OCw5ICs2OCw2IEBA
DQogI2RlZmluZSBWRUNfUE9TKHYpICgodikgJiAoMzIgLSAxKSkNCiAjZGVmaW5lIFJFR19QT1Mo
dikgKCgodikgPj4gNSkgPDwgNCkNCiANCi1zdGF0aWMgdW5zaWduZWQgaW50IG1pbl90aW1lcl9w
ZXJpb2RfdXMgPSA1MDA7DQotbW9kdWxlX3BhcmFtKG1pbl90aW1lcl9wZXJpb2RfdXMsIHVpbnQs
IFNfSVJVR08gfCBTX0lXVVNSKTsNCi0NCiBzdGF0aWMgaW5saW5lIHUzMiBhcGljX2dldF9yZWco
c3RydWN0IGt2bV9sYXBpYyAqYXBpYywgaW50IHJlZ19vZmYpDQogew0KIAlyZXR1cm4gKigodTMy
ICopIChhcGljLT5yZWdzICsgcmVnX29mZikpOw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9z
dm0uYyBiL2FyY2gveDg2L2t2bS9zdm0uYw0KaW5kZXggOTRhNDY3Mi4uMjEwMmExNyAxMDA2NDQN
Ci0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KKysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQpAQCAt
MjkwNCwxMCArMjkwNCw4IEBAIHN0YXRpYyBpbnQgY3I4X3dyaXRlX2ludGVyY2VwdGlvbihzdHJ1
Y3QgdmNwdV9zdm0gKnN2bSkNCiAJdTggY3I4X3ByZXYgPSBrdm1fZ2V0X2NyOCgmc3ZtLT52Y3B1
KTsNCiAJLyogaW5zdHJ1Y3Rpb24gZW11bGF0aW9uIGNhbGxzIGt2bV9zZXRfY3I4KCkgKi8NCiAJ
ciA9IGNyX2ludGVyY2VwdGlvbihzdm0pOw0KLQlpZiAoaXJxY2hpcF9pbl9rZXJuZWwoc3ZtLT52
Y3B1Lmt2bSkpIHsNCi0JCWNscl9jcl9pbnRlcmNlcHQoc3ZtLCBJTlRFUkNFUFRfQ1I4X1dSSVRF
KTsNCisJaWYgKGlycWNoaXBfaW5fa2VybmVsKHN2bS0+dmNwdS5rdm0pKQ0KIAkJcmV0dXJuIHI7
DQotCX0NCiAJaWYgKGNyOF9wcmV2IDw9IGt2bV9nZXRfY3I4KCZzdm0tPnZjcHUpKQ0KIAkJcmV0
dXJuIHI7DQogCWt2bV9ydW4tPmV4aXRfcmVhc29uID0gS1ZNX0VYSVRfU0VUX1RQUjsNCkBAIC0z
NDYyLDYgKzM0NjAsOCBAQCBzdGF0aWMgdm9pZCB1cGRhdGVfY3I4X2ludGVyY2VwdChzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIGludCB0cHIsIGludCBpcnIpDQogCWlmIChpc19ndWVzdF9tb2RlKHZj
cHUpICYmICh2Y3B1LT5hcmNoLmhmbGFncyAmIEhGX1ZJTlRSX01BU0spKQ0KIAkJcmV0dXJuOw0K
IA0KKwljbHJfY3JfaW50ZXJjZXB0KHN2bSwgSU5URVJDRVBUX0NSOF9XUklURSk7DQorDQogCWlm
IChpcnIgPT0gLTEpDQogCQlyZXR1cm47DQogDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4
Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQppbmRleCA3Nzc0Y2NhLi5iOWZlZmFmIDEwMDY0NA0K
LS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQorKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCkBAIC05
Miw2ICs5Miw5IEBAIEVYUE9SVF9TWU1CT0xfR1BMKGt2bV94ODZfb3BzKTsNCiBpbnQgaWdub3Jl
X21zcnMgPSAwOw0KIG1vZHVsZV9wYXJhbV9uYW1lZChpZ25vcmVfbXNycywgaWdub3JlX21zcnMs
IGJvb2wsIFNfSVJVR08gfCBTX0lXVVNSKTsNCiANCit1bnNpZ25lZCBpbnQgbWluX3RpbWVyX3Bl
cmlvZF91cyA9IDUwMDsNCittb2R1bGVfcGFyYW0obWluX3RpbWVyX3BlcmlvZF91cywgdWludCwg
U19JUlVHTyB8IFNfSVdVU1IpOw0KKw0KIGJvb2wga3ZtX2hhc190c2NfY29udHJvbDsNCiBFWFBP
UlRfU1lNQk9MX0dQTChrdm1faGFzX3RzY19jb250cm9sKTsNCiB1MzIgIGt2bV9tYXhfZ3Vlc3Rf
dHNjX2toejsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmggYi9hcmNoL3g4Ni9rdm0v
eDg2LmgNCmluZGV4IGQzNmZlMjMuLjBlMjJmNjQgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0v
eDg2LmgNCisrKyBiL2FyY2gveDg2L2t2bS94ODYuaA0KQEAgLTEyNSw0ICsxMjUsNiBAQCBpbnQg
a3ZtX3dyaXRlX2d1ZXN0X3ZpcnRfc3lzdGVtKHN0cnVjdCB4ODZfZW11bGF0ZV9jdHh0ICpjdHh0
LA0KIAlndmFfdCBhZGRyLCB2b2lkICp2YWwsIHVuc2lnbmVkIGludCBieXRlcywNCiAJc3RydWN0
IHg4Nl9leGNlcHRpb24gKmV4Y2VwdGlvbik7DQogDQorZXh0ZXJuIHVuc2lnbmVkIGludCBtaW5f
dGltZXJfcGVyaW9kX3VzOw0KKw0KICNlbmRpZg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BsYXRm
b3JtL2VmaS9lZmkuYyBiL2FyY2gveDg2L3BsYXRmb3JtL2VmaS9lZmkuYw0KaW5kZXggYmVlNzVh
Ni4uZTU2ZGE3NyAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L3BsYXRmb3JtL2VmaS9lZmkuYw0KKysr
IGIvYXJjaC94ODYvcGxhdGZvcm0vZWZpL2VmaS5jDQpAQCAtNDI0LDcgKzQyNCw3IEBAIHZvaWQg
X19pbml0IGVmaV9yZXNlcnZlX2Jvb3Rfc2VydmljZXModm9pZCkNCiAJCSAqIC0gTm90IHdpdGhp
biBhbnkgcGFydCBvZiB0aGUga2VybmVsDQogCQkgKiAtIE5vdCB0aGUgYmlvcyByZXNlcnZlZCBh
cmVhDQogCQkqLw0KLQkJaWYgKChzdGFydCtzaXplID49IHZpcnRfdG9fcGh5cyhfdGV4dCkNCisJ
CWlmICgoc3RhcnQgKyBzaXplID4gdmlydF90b19waHlzKF90ZXh0KQ0KIAkJCQkmJiBzdGFydCA8
PSB2aXJ0X3RvX3BoeXMoX2VuZCkpIHx8DQogCQkJIWU4MjBfYWxsX21hcHBlZChzdGFydCwgc3Rh
cnQrc2l6ZSwgRTgyMF9SQU0pIHx8DQogCQkJbWVtYmxvY2tfeDg2X2NoZWNrX3Jlc2VydmVkX3Np
emUoJnN0YXJ0LCAmc2l6ZSwNCmRpZmYgLS1naXQgYS9ibG9jay9ibGstbGliLmMgYi9ibG9jay9i
bGstbGliLmMNCmluZGV4IDJiNDYxYjQuLjM2NzUxZTIgMTAwNjQ0DQotLS0gYS9ibG9jay9ibGst
bGliLmMNCisrKyBiL2Jsb2NrL2Jsay1saWIuYw0KQEAgLTEwMSw2ICsxMDEsMTQgQEAgaW50IGJs
a2Rldl9pc3N1ZV9kaXNjYXJkKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHNlY3Rvcl90IHNl
Y3RvciwNCiANCiAJCWF0b21pY19pbmMoJmJiLmRvbmUpOw0KIAkJc3VibWl0X2Jpbyh0eXBlLCBi
aW8pOw0KKw0KKwkJLyoNCisJCSAqIFdlIGNhbiBsb29wIGZvciBhIGxvbmcgdGltZSBpbiBoZXJl
LCBpZiBzb21lb25lIGRvZXMNCisJCSAqIGZ1bGwgZGV2aWNlIGRpc2NhcmRzIChsaWtlIG1rZnMp
LiBCZSBuaWNlIGFuZCBhbGxvdw0KKwkJICogdXMgdG8gc2NoZWR1bGUgb3V0IHRvIGF2b2lkIHNv
ZnRsb2NraW5nIGlmIHByZWVtcHQNCisJCSAqIGlzIGRpc2FibGVkLg0KKwkJICovDQorCQljb25k
X3Jlc2NoZWQoKTsNCiAJfQ0KIA0KIAkvKiBXYWl0IGZvciBiaW9zIGluLWZsaWdodCAqLw0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9idXMuYyBiL2RyaXZlcnMvYWNwaS9idXMuYw0KaW5kZXgg
NTAxNmRlNS4uZjMyNDQyOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYWNwaS9idXMuYw0KKysrIGIv
ZHJpdmVycy9hY3BpL2J1cy5jDQpAQCAtMzMsNiArMzMsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9w
cm9jX2ZzLmg+DQogI2luY2x1ZGUgPGxpbnV4L2FjcGkuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xh
Yi5oPg0KKyNpbmNsdWRlIDxsaW51eC9yZWd1bGF0b3IvbWFjaGluZS5oPg0KICNpZmRlZiBDT05G
SUdfWDg2DQogI2luY2x1ZGUgPGFzbS9tcHNwZWMuaD4NCiAjZW5kaWYNCkBAIC05MTcsNiArOTE4
LDE0IEBAIHZvaWQgX19pbml0IGFjcGlfZWFybHlfaW5pdCh2b2lkKQ0KIAkJZ290byBlcnJvcjA7
DQogCX0NCiANCisJLyoNCisJICogSWYgdGhlIHN5c3RlbSBpcyB1c2luZyBBQ1BJIHRoZW4gd2Ug
Y2FuIGJlIHJlYXNvbmFibHkNCisJICogY29uZmlkZW50IHRoYXQgYW55IHJlZ3VsYXRvcnMgYXJl
IG1hbmFnZWQgYnkgdGhlIGZpcm13YXJlDQorCSAqIHNvIHRlbGwgdGhlIHJlZ3VsYXRvciBjb3Jl
IGl0IGhhcyBldmVyeXRoaW5nIGl0IG5lZWRzIHRvDQorCSAqIGtub3cuDQorCSAqLw0KKwlyZWd1
bGF0b3JfaGFzX2Z1bGxfY29uc3RyYWludHMoKTsNCisNCiAJcmV0dXJuOw0KIA0KICAgICAgIGVy
cm9yMDoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvcHJvY2Vzc29yX3Rocm90dGxpbmcuYyBi
L2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfdGhyb3R0bGluZy5jDQppbmRleCA2MDVhMjk1Li5hYmU0
NWNiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl90aHJvdHRsaW5nLmMNCisr
KyBiL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfdGhyb3R0bGluZy5jDQpAQCAtNTksNiArNTksMTIg
QEAgc3RydWN0IHRocm90dGxpbmdfdHN0YXRlIHsNCiAJaW50IHRhcmdldF9zdGF0ZTsJCS8qIHRh
cmdldCBULXN0YXRlICovDQogfTsNCiANCitzdHJ1Y3QgYWNwaV9wcm9jZXNzb3JfdGhyb3R0bGlu
Z19hcmcgew0KKwlzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKnByOw0KKwlpbnQgdGFyZ2V0X3N0YXRl
Ow0KKwlib29sIGZvcmNlOw0KK307DQorDQogI2RlZmluZSBUSFJPVFRMSU5HX1BSRUNIQU5HRSAg
ICAgICAoMSkNCiAjZGVmaW5lIFRIUk9UVExJTkdfUE9TVENIQU5HRSAgICAgICgyKQ0KIA0KQEAg
LTEwNjMsMTYgKzEwNjksMjQgQEAgc3RhdGljIGludCBhY3BpX3Byb2Nlc3Nvcl9zZXRfdGhyb3R0
bGluZ19wdGMoc3RydWN0IGFjcGlfcHJvY2Vzc29yICpwciwNCiAJcmV0dXJuIDA7DQogfQ0KIA0K
K3N0YXRpYyBsb25nIGFjcGlfcHJvY2Vzc29yX3Rocm90dGxpbmdfZm4odm9pZCAqZGF0YSkNCit7
DQorCXN0cnVjdCBhY3BpX3Byb2Nlc3Nvcl90aHJvdHRsaW5nX2FyZyAqYXJnID0gZGF0YTsNCisJ
c3RydWN0IGFjcGlfcHJvY2Vzc29yICpwciA9IGFyZy0+cHI7DQorDQorCXJldHVybiBwci0+dGhy
b3R0bGluZy5hY3BpX3Byb2Nlc3Nvcl9zZXRfdGhyb3R0bGluZyhwciwNCisJCQlhcmctPnRhcmdl
dF9zdGF0ZSwgYXJnLT5mb3JjZSk7DQorfQ0KKw0KIGludCBhY3BpX3Byb2Nlc3Nvcl9zZXRfdGhy
b3R0bGluZyhzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKnByLA0KIAkJCQkJCWludCBzdGF0ZSwgYm9v
bCBmb3JjZSkNCiB7DQotCWNwdW1hc2tfdmFyX3Qgc2F2ZWRfbWFzazsNCiAJaW50IHJldCA9IDA7
DQogCXVuc2lnbmVkIGludCBpOw0KIAlzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKm1hdGNoX3ByOw0K
IAlzdHJ1Y3QgYWNwaV9wcm9jZXNzb3JfdGhyb3R0bGluZyAqcF90aHJvdHRsaW5nOw0KKwlzdHJ1
Y3QgYWNwaV9wcm9jZXNzb3JfdGhyb3R0bGluZ19hcmcgYXJnOw0KIAlzdHJ1Y3QgdGhyb3R0bGlu
Z190c3RhdGUgdF9zdGF0ZTsNCi0JY3B1bWFza192YXJfdCBvbmxpbmVfdGhyb3R0bGluZ19jcHVz
Ow0KIA0KIAlpZiAoIXByKQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQpAQCAtMTA4MywxNCArMTA5Nyw2
IEBAIGludCBhY3BpX3Byb2Nlc3Nvcl9zZXRfdGhyb3R0bGluZyhzdHJ1Y3QgYWNwaV9wcm9jZXNz
b3IgKnByLA0KIAlpZiAoKHN0YXRlIDwgMCkgfHwgKHN0YXRlID4gKHByLT50aHJvdHRsaW5nLnN0
YXRlX2NvdW50IC0gMSkpKQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQotCWlmICghYWxsb2NfY3B1
bWFza192YXIoJnNhdmVkX21hc2ssIEdGUF9LRVJORUwpKQ0KLQkJcmV0dXJuIC1FTk9NRU07DQot
DQotCWlmICghYWxsb2NfY3B1bWFza192YXIoJm9ubGluZV90aHJvdHRsaW5nX2NwdXMsIEdGUF9L
RVJORUwpKSB7DQotCQlmcmVlX2NwdW1hc2tfdmFyKHNhdmVkX21hc2spOw0KLQkJcmV0dXJuIC1F
Tk9NRU07DQotCX0NCi0NCiAJaWYgKGNwdV9pc19vZmZsaW5lKHByLT5pZCkpIHsNCiAJCS8qDQog
CQkgKiB0aGUgY3B1IHBvaW50ZWQgYnkgcHItPmlkIGlzIG9mZmxpbmUuIFVubmVjZXNzYXJ5IHRv
IGNoYW5nZQ0KQEAgLTEwOTksMTcgKzExMDUsMTUgQEAgaW50IGFjcGlfcHJvY2Vzc29yX3NldF90
aHJvdHRsaW5nKHN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHIsDQogCQlyZXR1cm4gLUVOT0RFVjsN
CiAJfQ0KIA0KLQljcHVtYXNrX2NvcHkoc2F2ZWRfbWFzaywgJmN1cnJlbnQtPmNwdXNfYWxsb3dl
ZCk7DQogCXRfc3RhdGUudGFyZ2V0X3N0YXRlID0gc3RhdGU7DQogCXBfdGhyb3R0bGluZyA9ICYo
cHItPnRocm90dGxpbmcpOw0KLQljcHVtYXNrX2FuZChvbmxpbmVfdGhyb3R0bGluZ19jcHVzLCBj
cHVfb25saW5lX21hc2ssDQotCQkgICAgcF90aHJvdHRsaW5nLT5zaGFyZWRfY3B1X21hcCk7DQor
DQogCS8qDQogCSAqIFRoZSB0aHJvdHRsaW5nIG5vdGlmaWVyIHdpbGwgYmUgY2FsbGVkIGZvciBl
dmVyeQ0KIAkgKiBhZmZlY3RlZCBjcHUgaW4gb3JkZXIgdG8gZ2V0IG9uZSBwcm9wZXIgVC1zdGF0
ZS4NCiAJICogVGhlIG5vdGlmaWVyIGV2ZW50IGlzIFRIUk9UVExJTkdfUFJFQ0hBTkdFLg0KIAkg
Ki8NCi0JZm9yX2VhY2hfY3B1KGksIG9ubGluZV90aHJvdHRsaW5nX2NwdXMpIHsNCisJZm9yX2Vh
Y2hfY3B1X2FuZChpLCBjcHVfb25saW5lX21hc2ssIHBfdGhyb3R0bGluZy0+c2hhcmVkX2NwdV9t
YXApIHsNCiAJCXRfc3RhdGUuY3B1ID0gaTsNCiAJCWFjcGlfcHJvY2Vzc29yX3Rocm90dGxpbmdf
bm90aWZpZXIoVEhST1RUTElOR19QUkVDSEFOR0UsDQogCQkJCQkJCSZ0X3N0YXRlKTsNCkBAIC0x
MTIxLDIxICsxMTI1LDE4IEBAIGludCBhY3BpX3Byb2Nlc3Nvcl9zZXRfdGhyb3R0bGluZyhzdHJ1
Y3QgYWNwaV9wcm9jZXNzb3IgKnByLA0KIAkgKiBpdCBjYW4gYmUgY2FsbGVkIG9ubHkgZm9yIHRo
ZSBjcHUgcG9pbnRlZCBieSBwci4NCiAJICovDQogCWlmIChwX3Rocm90dGxpbmctPnNoYXJlZF90
eXBlID09IERPTUFJTl9DT09SRF9UWVBFX1NXX0FOWSkgew0KLQkJLyogRklYTUU6IHVzZSB3b3Jr
X29uX2NwdSgpICovDQotCQlpZiAoc2V0X2NwdXNfYWxsb3dlZF9wdHIoY3VycmVudCwgY3B1bWFz
a19vZihwci0+aWQpKSkgew0KLQkJCS8qIENhbid0IG1pZ3JhdGUgdG8gdGhlIHByLT5pZCBDUFUu
IEV4aXQgKi8NCi0JCQlyZXQgPSAtRU5PREVWOw0KLQkJCWdvdG8gZXhpdDsNCi0JCX0NCi0JCXJl
dCA9IHBfdGhyb3R0bGluZy0+YWNwaV9wcm9jZXNzb3Jfc2V0X3Rocm90dGxpbmcocHIsDQotCQkJ
CQkJdF9zdGF0ZS50YXJnZXRfc3RhdGUsIGZvcmNlKTsNCisJCWFyZy5wciA9IHByOw0KKwkJYXJn
LnRhcmdldF9zdGF0ZSA9IHN0YXRlOw0KKwkJYXJnLmZvcmNlID0gZm9yY2U7DQorCQlyZXQgPSB3
b3JrX29uX2NwdShwci0+aWQsIGFjcGlfcHJvY2Vzc29yX3Rocm90dGxpbmdfZm4sICZhcmcpOw0K
IAl9IGVsc2Ugew0KIAkJLyoNCiAJCSAqIFdoZW4gdGhlIFQtc3RhdGUgY29vcmRpbmF0aW9uIGlz
IFNXX0FMTCBvciBIV19BTEwsDQogCQkgKiBpdCBpcyBuZWNlc3NhcnkgdG8gc2V0IFQtc3RhdGUg
Zm9yIGV2ZXJ5IGFmZmVjdGVkDQogCQkgKiBjcHVzLg0KIAkJICovDQotCQlmb3JfZWFjaF9jcHUo
aSwgb25saW5lX3Rocm90dGxpbmdfY3B1cykgew0KKwkJZm9yX2VhY2hfY3B1X2FuZChpLCBjcHVf
b25saW5lX21hc2ssDQorCQkgICAgcF90aHJvdHRsaW5nLT5zaGFyZWRfY3B1X21hcCkgew0KIAkJ
CW1hdGNoX3ByID0gcGVyX2NwdShwcm9jZXNzb3JzLCBpKTsNCiAJCQkvKg0KIAkJCSAqIElmIHRo
ZSBwb2ludGVyIGlzIGludmFsaWQsIHdlIHdpbGwgcmVwb3J0IHRoZQ0KQEAgLTExNTYsMTMgKzEx
NTcsMTIgQEAgaW50IGFjcGlfcHJvY2Vzc29yX3NldF90aHJvdHRsaW5nKHN0cnVjdCBhY3BpX3By
b2Nlc3NvciAqcHIsDQogCQkJCQkib24gQ1BVICVkXG4iLCBpKSk7DQogCQkJCWNvbnRpbnVlOw0K
IAkJCX0NCi0JCQl0X3N0YXRlLmNwdSA9IGk7DQotCQkJLyogRklYTUU6IHVzZSB3b3JrX29uX2Nw
dSgpICovDQotCQkJaWYgKHNldF9jcHVzX2FsbG93ZWRfcHRyKGN1cnJlbnQsIGNwdW1hc2tfb2Yo
aSkpKQ0KLQkJCQljb250aW51ZTsNCi0JCQlyZXQgPSBtYXRjaF9wci0+dGhyb3R0bGluZy4NCi0J
CQkJYWNwaV9wcm9jZXNzb3Jfc2V0X3Rocm90dGxpbmcoDQotCQkJCW1hdGNoX3ByLCB0X3N0YXRl
LnRhcmdldF9zdGF0ZSwgZm9yY2UpOw0KKw0KKwkJCWFyZy5wciA9IG1hdGNoX3ByOw0KKwkJCWFy
Zy50YXJnZXRfc3RhdGUgPSBzdGF0ZTsNCisJCQlhcmcuZm9yY2UgPSBmb3JjZTsNCisJCQlyZXQg
PSB3b3JrX29uX2NwdShwci0+aWQsIGFjcGlfcHJvY2Vzc29yX3Rocm90dGxpbmdfZm4sDQorCQkJ
CSZhcmcpOw0KIAkJfQ0KIAl9DQogCS8qDQpAQCAtMTE3MSwxNyArMTE3MSwxMiBAQCBpbnQgYWNw
aV9wcm9jZXNzb3Jfc2V0X3Rocm90dGxpbmcoc3RydWN0IGFjcGlfcHJvY2Vzc29yICpwciwNCiAJ
ICogYWZmZWN0ZWQgY3B1IHRvIHVwZGF0ZSB0aGUgVC1zdGF0ZXMuDQogCSAqIFRoZSBub3RpZmll
ciBldmVudCBpcyBUSFJPVFRMSU5HX1BPU1RDSEFOR0UNCiAJICovDQotCWZvcl9lYWNoX2NwdShp
LCBvbmxpbmVfdGhyb3R0bGluZ19jcHVzKSB7DQorCWZvcl9lYWNoX2NwdV9hbmQoaSwgY3B1X29u
bGluZV9tYXNrLCBwX3Rocm90dGxpbmctPnNoYXJlZF9jcHVfbWFwKSB7DQogCQl0X3N0YXRlLmNw
dSA9IGk7DQogCQlhY3BpX3Byb2Nlc3Nvcl90aHJvdHRsaW5nX25vdGlmaWVyKFRIUk9UVExJTkdf
UE9TVENIQU5HRSwNCiAJCQkJCQkJJnRfc3RhdGUpOw0KIAl9DQotCS8qIHJlc3RvcmUgdGhlIHBy
ZXZpb3VzIHN0YXRlICovDQotCS8qIEZJWE1FOiB1c2Ugd29ya19vbl9jcHUoKSAqLw0KLQlzZXRf
Y3B1c19hbGxvd2VkX3B0cihjdXJyZW50LCBzYXZlZF9tYXNrKTsNCi1leGl0Og0KLQlmcmVlX2Nw
dW1hc2tfdmFyKG9ubGluZV90aHJvdHRsaW5nX2NwdXMpOw0KLQlmcmVlX2NwdW1hc2tfdmFyKHNh
dmVkX21hc2spOw0KKw0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2FjcGkvdmlkZW8uYyBiL2RyaXZlcnMvYWNwaS92aWRlby5jDQppbmRleCBlMTk4OThkLi4yZWJm
ZGQyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hY3BpL3ZpZGVvLmMNCisrKyBiL2RyaXZlcnMvYWNw
aS92aWRlby5jDQpAQCAtNjQ2LDYgKzY0Niw3IEBAIGFjcGlfdmlkZW9faW5pdF9icmlnaHRuZXNz
KHN0cnVjdCBhY3BpX3ZpZGVvX2RldmljZSAqZGV2aWNlKQ0KIAl1bmlvbiBhY3BpX29iamVjdCAq
bzsNCiAJc3RydWN0IGFjcGlfdmlkZW9fZGV2aWNlX2JyaWdodG5lc3MgKmJyID0gTlVMTDsNCiAJ
aW50IHJlc3VsdCA9IC1FSU5WQUw7DQorCXUzMiB2YWx1ZTsNCiANCiAJaWYgKCFBQ1BJX1NVQ0NF
U1MoYWNwaV92aWRlb19kZXZpY2VfbGNkX3F1ZXJ5X2xldmVscyhkZXZpY2UsICZvYmopKSkgew0K
IAkJQUNQSV9ERUJVR19QUklOVCgoQUNQSV9EQl9JTkZPLCAiQ291bGQgbm90IHF1ZXJ5IGF2YWls
YWJsZSAiDQpAQCAtNjc2LDcgKzY3NywxMiBAQCBhY3BpX3ZpZGVvX2luaXRfYnJpZ2h0bmVzcyhz
dHJ1Y3QgYWNwaV92aWRlb19kZXZpY2UgKmRldmljZSkNCiAJCQlwcmludGsoS0VSTl9FUlIgUFJF
RklYICJJbnZhbGlkIGRhdGFcbiIpOw0KIAkJCWNvbnRpbnVlOw0KIAkJfQ0KLQkJYnItPmxldmVs
c1tjb3VudF0gPSAodTMyKSBvLT5pbnRlZ2VyLnZhbHVlOw0KKwkJdmFsdWUgPSAodTMyKSBvLT5p
bnRlZ2VyLnZhbHVlOw0KKwkJLyogU2tpcCBkdXBsaWNhdGUgZW50cmllcyAqLw0KKwkJaWYgKGNv
dW50ID4gMiAmJiBici0+bGV2ZWxzW2NvdW50IC0gMV0gPT0gdmFsdWUpDQorCQkJY29udGludWU7
DQorDQorCQlici0+bGV2ZWxzW2NvdW50XSA9IHZhbHVlOw0KIA0KIAkJaWYgKGJyLT5sZXZlbHNb
Y291bnRdID4gbWF4X2xldmVsKQ0KIAkJCW1heF9sZXZlbCA9IGJyLT5sZXZlbHNbY291bnRdOw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2FoY2kuYyBiL2RyaXZlcnMvYXRhL2FoY2kuYw0KaW5k
ZXggZjQwMDBlZS4uMGZlZmZjMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRhL2FoY2kuYw0KKysr
IGIvZHJpdmVycy9hdGEvYWhjaS5jDQpAQCAtNjEsNiArNjEsNyBAQCBlbnVtIGJvYXJkX2lkcyB7
DQogCS8qIGJvYXJkIElEcyBieSBmZWF0dXJlIGluIGFscGhhYmV0aWNhbCBvcmRlciAqLw0KIAli
b2FyZF9haGNpLA0KIAlib2FyZF9haGNpX2lnbl9pZmVyciwNCisJYm9hcmRfYWhjaV9ub25jcSwN
CiAJYm9hcmRfYWhjaV9ub3NudGYsDQogCWJvYXJkX2FoY2lfeWVzX2ZicywNCiANCkBAIC0xMjMs
NiArMTI0LDEzIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYXRhX3BvcnRfaW5mbyBhaGNpX3BvcnRf
aW5mb1tdID0gew0KIAkJLnVkbWFfbWFzawk9IEFUQV9VRE1BNiwNCiAJCS5wb3J0X29wcwk9ICZh
aGNpX29wcywNCiAJfSwNCisJW2JvYXJkX2FoY2lfbm9uY3FdID0gew0KKwkJQUhDSV9IRkxBR1MJ
KEFIQ0lfSEZMQUdfTk9fTkNRKSwNCisJCS5mbGFncwkJPSBBSENJX0ZMQUdfQ09NTU9OLA0KKwkJ
LnBpb19tYXNrCT0gQVRBX1BJTzQsDQorCQkudWRtYV9tYXNrCT0gQVRBX1VETUE2LA0KKwkJLnBv
cnRfb3BzCT0gJmFoY2lfb3BzLA0KKwl9LA0KIAlbYm9hcmRfYWhjaV9ub3NudGZdID0NCiAJew0K
IAkJQUhDSV9IRkxBR1MJKEFIQ0lfSEZMQUdfTk9fU05URiksDQpAQCAtNDU4LDYgKzQ2NiwxMiBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgYWhjaV9wY2lfdGJsW10gPSB7DQog
CXsgUENJX1ZERVZJQ0UoQVNNRURJQSwgMHgwNjExKSwgYm9hcmRfYWhjaSB9LAkvKiBBU00xMDYx
ICovDQogCXsgUENJX1ZERVZJQ0UoQVNNRURJQSwgMHgwNjEyKSwgYm9hcmRfYWhjaSB9LAkvKiBB
U00xMDYyICovDQogDQorCS8qDQorCSAqIFNhbXN1bmcgU1NEcyBmb3VuZCBvbiBzb21lIG1hY2Jv
b2tzLiAgTkNRIHRpbWVzIG91dC4NCisJICogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3No
b3dfYnVnLmNnaT9pZD02MDczMQ0KKwkgKi8NCisJeyBQQ0lfVkRFVklDRShTQU1TVU5HLCAweDE2
MDApLCBib2FyZF9haGNpX25vbmNxIH0sDQorDQogCS8qIEVubW90dXMgKi8NCiAJeyBQQ0lfREVW
SUNFKDB4MWM0NCwgMHg4MDAwKSwgYm9hcmRfYWhjaSB9LA0KIA0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvYXRhL2xpYmF0YS1jb3JlLmMgYi9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5jDQppbmRleCA3
MmJiYjVlLi5iM2YwZjVhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYw0K
KysrIGIvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYw0KQEAgLTIxODgsNiArMjE4OCwxNiBAQCBp
bnQgYXRhX2Rldl9jb25maWd1cmUoc3RydWN0IGF0YV9kZXZpY2UgKmRldikNCiAJaWYgKHJjKQ0K
IAkJcmV0dXJuIHJjOw0KIA0KKwkvKiBzb21lIFdEIFNBVEEtMSBkcml2ZXMgaGF2ZSBpc3N1ZXMg
d2l0aCBMUE0sIHR1cm4gb24gTk9MUE0gZm9yIHRoZW0gKi8NCisJaWYgKChkZXYtPmhvcmthZ2Ug
JiBBVEFfSE9SS0FHRV9XRF9CUk9LRU5fTFBNKSAmJg0KKwkgICAgKGlkWzc2XSAmIDB4ZSkgPT0g
MHgyKQ0KKwkJZGV2LT5ob3JrYWdlIHw9IEFUQV9IT1JLQUdFX05PTFBNOw0KKw0KKwlpZiAoZGV2
LT5ob3JrYWdlICYgQVRBX0hPUktBR0VfTk9MUE0pIHsNCisJCWF0YV9kZXZfd2FybihkZXYsICJM
UE0gc3VwcG9ydCBicm9rZW4sIGZvcmNpbmcgbWF4X3Bvd2VyXG4iKTsNCisJCWRldi0+bGluay0+
YXAtPnRhcmdldF9scG1fcG9saWN5ID0gQVRBX0xQTV9NQVhfUE9XRVI7DQorCX0NCisNCiAJLyog
bGV0IEFDUEkgd29yayBpdHMgbWFnaWMgKi8NCiAJcmMgPSBhdGFfYWNwaV9vbl9kZXZjZmcoZGV2
KTsNCiAJaWYgKHJjKQ0KQEAgLTQwOTksNiArNDEwOSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
YXRhX2JsYWNrbGlzdF9lbnRyeSBhdGFfZGV2aWNlX2JsYWNrbGlzdCBbXSA9IHsNCiANCiAJLyog
U2VhZ2F0ZSBNb21lbnR1cyBTcGluUG9pbnQgTTggc2VlbSB0byBoYXZlIEZQTURBX0FBIGlzc3Vl
cyAqLw0KIAl7ICJTVDEwMDBMTTAyNCBITi1NMTAxTUJCIiwgIjJBUjEwMDAxIiwJQVRBX0hPUktB
R0VfQlJPS0VOX0ZQRE1BX0FBIH0sDQorCXsgIlNUMTAwMExNMDI0IEhOLU0xMDFNQkIiLCAiMkJB
MzAwMDEiLAlBVEFfSE9SS0FHRV9CUk9LRU5fRlBETUFfQUEgfSwNCiANCiAJLyogQmxhY2tsaXN0
IGVudHJpZXMgdGFrZW4gZnJvbSBTaWxpY29uIEltYWdlIDMxMjQvMzEzMg0KIAkgICBXaW5kb3dz
IGRyaXZlciAuaW5mIGZpbGUgLSBhbHNvIHNldmVyYWwgTGludXggcHJvYmxlbSByZXBvcnRzICov
DQpAQCAtNDE0Myw2ICs0MTU0LDIzIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYXRhX2JsYWNrbGlz
dF9lbnRyeSBhdGFfZGV2aWNlX2JsYWNrbGlzdCBbXSA9IHsNCiAJeyAiUElPTkVFUiBEVkQtUlcg
IERWUi0yMTJEIiwJTlVMTCwJQVRBX0hPUktBR0VfTk9TRVRYRkVSIH0sDQogCXsgIlBJT05FRVIg
RFZELVJXICBEVlItMjE2RCIsCU5VTEwsCUFUQV9IT1JLQUdFX05PU0VUWEZFUiB9LA0KIA0KKwkv
Kg0KKwkgKiBTb21lIFdEIFNBVEEtSSBkcml2ZXMgc3BpbiB1cCBhbmQgZG93biBlcnJhdGljYWxs
eSB3aGVuIHRoZSBsaW5rDQorCSAqIGlzIHB1dCBpbnRvIHRoZSBzbHVtYmVyIG1vZGUuICBXZSBk
b24ndCBoYXZlIGZ1bGwgbGlzdCBvZiB0aGUNCisJICogYWZmZWN0ZWQgZGV2aWNlcy4gIERpc2Fi
bGUgTFBNIGlmIHRoZSBkZXZpY2UgbWF0Y2hlcyBvbmUgb2YgdGhlDQorCSAqIGtub3duIHByZWZp
eGVzIGFuZCBpcyBTQVRBLTEuICBBcyBhIHNpZGUgZWZmZWN0IExQTSBwYXJ0aWFsIGlzDQorCSAq
IGxvc3QgdG9vLg0KKwkgKg0KKwkgKiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19i
dWcuY2dpP2lkPTU3MjExDQorCSAqLw0KKwl7ICJXREMgV0Q4MDBKRC0qIiwJCU5VTEwsCUFUQV9I
T1JLQUdFX1dEX0JST0tFTl9MUE0gfSwNCisJeyAiV0RDIFdEMTIwMEpELSoiLAkJTlVMTCwJQVRB
X0hPUktBR0VfV0RfQlJPS0VOX0xQTSB9LA0KKwl7ICJXREMgV0QxNjAwSkQtKiIsCQlOVUxMLAlB
VEFfSE9SS0FHRV9XRF9CUk9LRU5fTFBNIH0sDQorCXsgIldEQyBXRDIwMDBKRC0qIiwJCU5VTEws
CUFUQV9IT1JLQUdFX1dEX0JST0tFTl9MUE0gfSwNCisJeyAiV0RDIFdEMjUwMEpELSoiLAkJTlVM
TCwJQVRBX0hPUktBR0VfV0RfQlJPS0VOX0xQTSB9LA0KKwl7ICJXREMgV0QzMDAwSkQtKiIsCQlO
VUxMLAlBVEFfSE9SS0FHRV9XRF9CUk9LRU5fTFBNIH0sDQorCXsgIldEQyBXRDMyMDBKRC0qIiwJ
CU5VTEwsCUFUQV9IT1JLQUdFX1dEX0JST0tFTl9MUE0gfSwNCisNCiAJLyogRW5kIE1hcmtlciAq
Lw0KIAl7IH0NCiB9Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2xpYmF0YS1wbXAuYyBiL2Ry
aXZlcnMvYXRhL2xpYmF0YS1wbXAuYw0KaW5kZXggZjVjMzViZS4uMGJhMzJmZSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvYXRhL2xpYmF0YS1wbXAuYw0KKysrIGIvZHJpdmVycy9hdGEvbGliYXRhLXBt
cC5jDQpAQCAtNDQ3LDggKzQ0NywxMSBAQCBzdGF0aWMgdm9pZCBzYXRhX3BtcF9xdWlya3Moc3Ry
dWN0IGF0YV9wb3J0ICphcCkNCiAJCSAqIG90aGVyd2lzZS4gIERvbid0IHRyeSBoYXJkIHRvIHJl
Y292ZXIgaXQuDQogCQkgKi8NCiAJCWFwLT5wbXBfbGlua1thcC0+bnJfcG1wX2xpbmtzIC0gMV0u
ZmxhZ3MgfD0gQVRBX0xGTEFHX05PX1JFVFJZOw0KLQl9IGVsc2UgaWYgKHZlbmRvciA9PSAweDE5
N2IgJiYgZGV2aWQgPT0gMHgyMzUyKSB7DQotCQkvKiBjaGlwIGZvdW5kIGluIFRoZXJtYWx0YWtl
IEJsYWNrWCBEdWV0LCBqbWljcm9uIEpNQjM1MD8gKi8NCisJfSBlbHNlIGlmICh2ZW5kb3IgPT0g
MHgxOTdiICYmIChkZXZpZCA9PSAweDIzNTIgfHwgZGV2aWQgPT0gMHgwMzI1KSkgew0KKwkJLyoN
CisJCSAqIDB4MjM1MjogZm91bmQgaW4gVGhlcm1hbHRha2UgQmxhY2tYIER1ZXQsIGptaWNyb24g
Sk1CMzUwPw0KKwkJICogMHgwMzI1OiBqbWljcm9uIEpNQjM5NC4NCisJCSAqLw0KIAkJYXRhX2Zv
cl9lYWNoX2xpbmsobGluaywgYXAsIEVER0UpIHsNCiAJCQkvKiBTUlNUIGJyZWFrcyBkZXRlY3Rp
b24gYW5kIGRpc2tzIGdldCBtaXNjbGFzc2lmaWVkDQogCQkJICogTFBNIGRpc2FibGVkIHRvIGF2
b2lkIHBvdGVudGlhbCBwcm9ibGVtcw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2xpYmF0YS1z
Y3NpLmMgYi9kcml2ZXJzL2F0YS9saWJhdGEtc2NzaS5jDQppbmRleCBkZDMzMmU1Li44NDYwZTYy
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvbGliYXRhLXNjc2kuYw0KKysrIGIvZHJpdmVycy9h
dGEvbGliYXRhLXNjc2kuYw0KQEAgLTExMSwxMiArMTExLDE0IEBAIHN0YXRpYyBjb25zdCBjaGFy
ICphdGFfbHBtX3BvbGljeV9uYW1lc1tdID0gew0KIAlbQVRBX0xQTV9NSU5fUE9XRVJdCT0gIm1p
bl9wb3dlciIsDQogfTsNCiANCi1zdGF0aWMgc3NpemVfdCBhdGFfc2NzaV9scG1fc3RvcmUoc3Ry
dWN0IGRldmljZSAqZGV2LA0KK3N0YXRpYyBzc2l6ZV90IGF0YV9zY3NpX2xwbV9zdG9yZShzdHJ1
Y3QgZGV2aWNlICpkZXZpY2UsDQogCQkJCSAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIs
DQogCQkJCSAgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpDQogew0KLQlzdHJ1Y3QgU2Nz
aV9Ib3N0ICpzaG9zdCA9IGNsYXNzX3RvX3Nob3N0KGRldik7DQorCXN0cnVjdCBTY3NpX0hvc3Qg
KnNob3N0ID0gY2xhc3NfdG9fc2hvc3QoZGV2aWNlKTsNCiAJc3RydWN0IGF0YV9wb3J0ICphcCA9
IGF0YV9zaG9zdF90b19wb3J0KHNob3N0KTsNCisJc3RydWN0IGF0YV9saW5rICpsaW5rOw0KKwlz
dHJ1Y3QgYXRhX2RldmljZSAqZGV2Ow0KIAllbnVtIGF0YV9scG1fcG9saWN5IHBvbGljeTsNCiAJ
dW5zaWduZWQgbG9uZyBmbGFnczsNCiANCkBAIC0xMzIsMTAgKzEzNCwyMCBAQCBzdGF0aWMgc3Np
emVfdCBhdGFfc2NzaV9scG1fc3RvcmUoc3RydWN0IGRldmljZSAqZGV2LA0KIAkJcmV0dXJuIC1F
SU5WQUw7DQogDQogCXNwaW5fbG9ja19pcnFzYXZlKGFwLT5sb2NrLCBmbGFncyk7DQorDQorCWF0
YV9mb3JfZWFjaF9saW5rKGxpbmssIGFwLCBFREdFKSB7DQorCQlhdGFfZm9yX2VhY2hfZGV2KGRl
diwgJmFwLT5saW5rLCBFTkFCTEVEKSB7DQorCQkJaWYgKGRldi0+aG9ya2FnZSAmIEFUQV9IT1JL
QUdFX05PTFBNKSB7DQorCQkJCWNvdW50ID0gLUVPUE5PVFNVUFA7DQorCQkJCWdvdG8gb3V0X3Vu
bG9jazsNCisJCQl9DQorCQl9DQorCX0NCisNCiAJYXAtPnRhcmdldF9scG1fcG9saWN5ID0gcG9s
aWN5Ow0KIAlhdGFfcG9ydF9zY2hlZHVsZV9laChhcCk7DQorb3V0X3VubG9jazoNCiAJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZShhcC0+bG9jaywgZmxhZ3MpOw0KLQ0KIAlyZXR1cm4gY291bnQ7DQog
fQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL3NhdGFfc2lsLmMgYi9kcml2ZXJzL2F0YS9z
YXRhX3NpbC5jDQppbmRleCA5ZGZiNDBiLi4wYzRlZDg5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9h
dGEvc2F0YV9zaWwuYw0KKysrIGIvZHJpdmVycy9hdGEvc2F0YV9zaWwuYw0KQEAgLTE1Nyw2ICsx
NTcsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHNpbF9kcml2ZWxpc3Qgew0KIAl7ICJTVDM4MDAx
MUFTTCIsCVNJTF9RVUlSS19NT0QxNVdSSVRFIH0sDQogCXsgIlNUMzEyMDAyMkFTTCIsCVNJTF9R
VUlSS19NT0QxNVdSSVRFIH0sDQogCXsgIlNUMzE2MDAyMUFTTCIsCVNJTF9RVUlSS19NT0QxNVdS
SVRFIH0sDQorCXsgIlRPU0hJQkEgTUsyNTYxR1NZTiIsCVNJTF9RVUlSS19NT0QxNVdSSVRFIH0s
DQogCXsgIk1heHRvciA0RDA2MEgzIiwJU0lMX1FVSVJLX1VETUE1TUFYIH0sDQogCXsgfQ0KIH07
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay94ZW4tYmxrZnJvbnQuYyBiL2RyaXZlcnMvYmxv
Y2sveGVuLWJsa2Zyb250LmMNCmluZGV4IDdiMmVjNTkuLjk2YjhjYjcgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL2Jsb2NrL3hlbi1ibGtmcm9udC5jDQorKysgYi9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtm
cm9udC5jDQpAQCAtMTI4MSwxMyArMTI4MSwxNiBAQCBzdGF0aWMgdm9pZCBibGtiYWNrX2NoYW5n
ZWQoc3RydWN0IHhlbmJ1c19kZXZpY2UgKmRldiwNCiAJY2FzZSBYZW5idXNTdGF0ZVJlY29uZmln
dXJpbmc6DQogCWNhc2UgWGVuYnVzU3RhdGVSZWNvbmZpZ3VyZWQ6DQogCWNhc2UgWGVuYnVzU3Rh
dGVVbmtub3duOg0KLQljYXNlIFhlbmJ1c1N0YXRlQ2xvc2VkOg0KIAkJYnJlYWs7DQogDQogCWNh
c2UgWGVuYnVzU3RhdGVDb25uZWN0ZWQ6DQogCQlibGtmcm9udF9jb25uZWN0KGluZm8pOw0KIAkJ
YnJlYWs7DQogDQorCWNhc2UgWGVuYnVzU3RhdGVDbG9zZWQ6DQorCQlpZiAoZGV2LT5zdGF0ZSA9
PSBYZW5idXNTdGF0ZUNsb3NlZCkNCisJCQlicmVhazsNCisJCS8qIE1pc3NlZCB0aGUgYmFja2Vu
ZCdzIENsb3Npbmcgc3RhdGUgLS0gZmFsbHRocm91Z2ggKi8NCiAJY2FzZSBYZW5idXNTdGF0ZUNs
b3Npbmc6DQogCQlibGtmcm9udF9jbG9zaW5nKGluZm8pOw0KIAkJYnJlYWs7DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9jaGFyL3Jhdy5jIGIvZHJpdmVycy9jaGFyL3Jhdy5jDQppbmRleCBiNmRlMmMw
Li41ZGVkMWE1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jaGFyL3Jhdy5jDQorKysgYi9kcml2ZXJz
L2NoYXIvcmF3LmMNCkBAIC0xOTAsNyArMTkwLDcgQEAgc3RhdGljIGludCBiaW5kX2dldChpbnQg
bnVtYmVyLCBkZXZfdCAqZGV2KQ0KIAlzdHJ1Y3QgcmF3X2RldmljZV9kYXRhICpyYXdkZXY7DQog
CXN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXY7DQogDQotCWlmIChudW1iZXIgPD0gMCB8fCBudW1i
ZXIgPj0gTUFYX1JBV19NSU5PUlMpDQorCWlmIChudW1iZXIgPD0gMCB8fCBudW1iZXIgPj0gbWF4
X3Jhd19taW5vcnMpDQogCQlyZXR1cm4gLUVJTlZBTDsNCiANCiAJcmF3ZGV2ID0gJnJhd19kZXZp
Y2VzW251bWJlcl07DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEvaW9hdC9kbWEuYyBiL2RyaXZl
cnMvZG1hL2lvYXQvZG1hLmMNCmluZGV4IDY1OTUxODAuLjNmODkzODYgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL2RtYS9pb2F0L2RtYS5jDQorKysgYi9kcml2ZXJzL2RtYS9pb2F0L2RtYS5jDQpAQCAt
NzUsNyArNzUsOCBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgaW9hdF9kbWFfZG9faW50ZXJydXB0KGlu
dCBpcnEsIHZvaWQgKmRhdGEpDQogCWF0dG5zdGF0dXMgPSByZWFkbChpbnN0YW5jZS0+cmVnX2Jh
c2UgKyBJT0FUX0FUVE5TVEFUVVNfT0ZGU0VUKTsNCiAJZm9yX2VhY2hfc2V0X2JpdChiaXQsICZh
dHRuc3RhdHVzLCBCSVRTX1BFUl9MT05HKSB7DQogCQljaGFuID0gaW9hdF9jaGFuX2J5X2luZGV4
KGluc3RhbmNlLCBiaXQpOw0KLQkJdGFza2xldF9zY2hlZHVsZSgmY2hhbi0+Y2xlYW51cF90YXNr
KTsNCisJCWlmICh0ZXN0X2JpdChJT0FUX1JVTiwgJmNoYW4tPnN0YXRlKSkNCisJCQl0YXNrbGV0
X3NjaGVkdWxlKCZjaGFuLT5jbGVhbnVwX3Rhc2spOw0KIAl9DQogDQogCXdyaXRlYihpbnRyY3Ry
bCwgaW5zdGFuY2UtPnJlZ19iYXNlICsgSU9BVF9JTlRSQ1RSTF9PRkZTRVQpOw0KQEAgLTkxLDcg
KzkyLDggQEAgc3RhdGljIGlycXJldHVybl90IGlvYXRfZG1hX2RvX2ludGVycnVwdF9tc2l4KGlu
dCBpcnEsIHZvaWQgKmRhdGEpDQogew0KIAlzdHJ1Y3QgaW9hdF9jaGFuX2NvbW1vbiAqY2hhbiA9
IGRhdGE7DQogDQotCXRhc2tsZXRfc2NoZWR1bGUoJmNoYW4tPmNsZWFudXBfdGFzayk7DQorCWlm
ICh0ZXN0X2JpdChJT0FUX1JVTiwgJmNoYW4tPnN0YXRlKSkNCisJCXRhc2tsZXRfc2NoZWR1bGUo
JmNoYW4tPmNsZWFudXBfdGFzayk7DQogDQogCXJldHVybiBJUlFfSEFORExFRDsNCiB9DQpAQCAt
MTEzLDcgKzExNSw2IEBAIHZvaWQgaW9hdF9pbml0X2NoYW5uZWwoc3RydWN0IGlvYXRkbWFfZGV2
aWNlICpkZXZpY2UsIHN0cnVjdCBpb2F0X2NoYW5fY29tbW9uICpjDQogCWNoYW4tPnRpbWVyLmZ1
bmN0aW9uID0gZGV2aWNlLT50aW1lcl9mbjsNCiAJY2hhbi0+dGltZXIuZGF0YSA9IGRhdGE7DQog
CXRhc2tsZXRfaW5pdCgmY2hhbi0+Y2xlYW51cF90YXNrLCBkZXZpY2UtPmNsZWFudXBfZm4sIGRh
dGEpOw0KLQl0YXNrbGV0X2Rpc2FibGUoJmNoYW4tPmNsZWFudXBfdGFzayk7DQogfQ0KIA0KIC8q
Kg0KQEAgLTM1NiwxMyArMzU3LDQzIEBAIHN0YXRpYyBpbnQgaW9hdDFfZG1hX2FsbG9jX2NoYW5f
cmVzb3VyY2VzKHN0cnVjdCBkbWFfY2hhbiAqYykNCiAJd3JpdGVsKCgodTY0KSBjaGFuLT5jb21w
bGV0aW9uX2RtYSkgPj4gMzIsDQogCSAgICAgICBjaGFuLT5yZWdfYmFzZSArIElPQVRfQ0hBTkNN
UF9PRkZTRVRfSElHSCk7DQogDQotCXRhc2tsZXRfZW5hYmxlKCZjaGFuLT5jbGVhbnVwX3Rhc2sp
Ow0KKwlzZXRfYml0KElPQVRfUlVOLCAmY2hhbi0+c3RhdGUpOw0KIAlpb2F0MV9kbWFfc3RhcnRf
bnVsbF9kZXNjKGlvYXQpOyAgLyogZ2l2ZSBjaGFpbiB0byBkbWEgZGV2aWNlICovDQogCWRldl9k
YmcodG9fZGV2KGNoYW4pLCAiJXM6IGFsbG9jYXRlZCAlZCBkZXNjcmlwdG9yc1xuIiwNCiAJCV9f
ZnVuY19fLCBpb2F0LT5kZXNjY291bnQpOw0KIAlyZXR1cm4gaW9hdC0+ZGVzY2NvdW50Ow0KIH0N
CiANCit2b2lkIGlvYXRfc3RvcChzdHJ1Y3QgaW9hdF9jaGFuX2NvbW1vbiAqY2hhbikNCit7DQor
CXN0cnVjdCBpb2F0ZG1hX2RldmljZSAqZGV2aWNlID0gY2hhbi0+ZGV2aWNlOw0KKwlzdHJ1Y3Qg
cGNpX2RldiAqcGRldiA9IGRldmljZS0+cGRldjsNCisJaW50IGNoYW5faWQgPSBjaGFuX251bShj
aGFuKTsNCisNCisJLyogMS8gc3RvcCBpcnEgZnJvbSBmaXJpbmcgdGFza2xldHMNCisJICogMi8g
c3RvcCB0aGUgdGFza2xldCBmcm9tIHJlLWFybWluZyBpcnFzDQorCSAqLw0KKwljbGVhcl9iaXQo
SU9BVF9SVU4sICZjaGFuLT5zdGF0ZSk7DQorDQorCS8qIGZsdXNoIGluZmxpZ2h0IGludGVycnVw
dHMgKi8NCisjaWZkZWYgQ09ORklHX1BDSV9NU0kNCisJaWYgKHBkZXYtPm1zaXhfZW5hYmxlZCkg
ew0KKwkJc3RydWN0IG1zaXhfZW50cnkgKm1zaXggPSAmZGV2aWNlLT5tc2l4X2VudHJpZXNbY2hh
bl9pZF07DQorCQlzeW5jaHJvbml6ZV9pcnEobXNpeC0+dmVjdG9yKTsNCisJfSBlbHNlDQorI2Vu
ZGlmDQorCQlzeW5jaHJvbml6ZV9pcnEocGRldi0+aXJxKTsNCisNCisJLyogZmx1c2ggaW5mbGln
aHQgdGltZXJzICovDQorCWRlbF90aW1lcl9zeW5jKCZjaGFuLT50aW1lcik7DQorDQorCS8qIGZs
dXNoIGluZmxpZ2h0IHRhc2tsZXQgcnVucyAqLw0KKwl0YXNrbGV0X2tpbGwoJmNoYW4tPmNsZWFu
dXBfdGFzayk7DQorDQorCS8qIGZpbmFsIGNsZWFudXAgbm93IHRoYXQgZXZlcnl0aGluZyBpcyBx
dWllc2NlZCBhbmQgY2FuJ3QgcmUtYXJtICovDQorCWRldmljZS0+Y2xlYW51cF9mbigodW5zaWdu
ZWQgbG9uZykgJmNoYW4tPmNvbW1vbik7DQorfQ0KKw0KIC8qKg0KICAqIGlvYXQxX2RtYV9mcmVl
X2NoYW5fcmVzb3VyY2VzIC0gcmVsZWFzZSBhbGwgdGhlIGRlc2NyaXB0b3JzDQogICogQGNoYW46
IHRoZSBjaGFubmVsIHRvIGJlIGNsZWFuZWQNCkBAIC0zODEsOSArNDEyLDcgQEAgc3RhdGljIHZv
aWQgaW9hdDFfZG1hX2ZyZWVfY2hhbl9yZXNvdXJjZXMoc3RydWN0IGRtYV9jaGFuICpjKQ0KIAlp
ZiAoaW9hdC0+ZGVzY2NvdW50ID09IDApDQogCQlyZXR1cm47DQogDQotCXRhc2tsZXRfZGlzYWJs
ZSgmY2hhbi0+Y2xlYW51cF90YXNrKTsNCi0JZGVsX3RpbWVyX3N5bmMoJmNoYW4tPnRpbWVyKTsN
Ci0JaW9hdDFfY2xlYW51cChpb2F0KTsNCisJaW9hdF9zdG9wKGNoYW4pOw0KIA0KIAkvKiBEZWxh
eSAxMDBtcyBhZnRlciByZXNldCB0byBhbGxvdyBpbnRlcm5hbCBETUEgbG9naWMgdG8gcXVpZXNj
ZQ0KIAkgKiBiZWZvcmUgcmVtb3ZpbmcgRE1BIGRlc2NyaXB0b3IgcmVzb3VyY2VzLg0KQEAgLTUy
OCw4ICs1NTcsMTEgQEAgaW9hdDFfZG1hX3ByZXBfbWVtY3B5KHN0cnVjdCBkbWFfY2hhbiAqYywg
ZG1hX2FkZHJfdCBkbWFfZGVzdCwNCiBzdGF0aWMgdm9pZCBpb2F0MV9jbGVhbnVwX2V2ZW50KHVu
c2lnbmVkIGxvbmcgZGF0YSkNCiB7DQogCXN0cnVjdCBpb2F0X2RtYV9jaGFuICppb2F0ID0gdG9f
aW9hdF9jaGFuKCh2b2lkICopIGRhdGEpOw0KKwlzdHJ1Y3QgaW9hdF9jaGFuX2NvbW1vbiAqY2hh
biA9ICZpb2F0LT5iYXNlOw0KIA0KIAlpb2F0MV9jbGVhbnVwKGlvYXQpOw0KKwlpZiAoIXRlc3Rf
Yml0KElPQVRfUlVOLCAmY2hhbi0+c3RhdGUpKQ0KKwkJcmV0dXJuOw0KIAl3cml0ZXcoSU9BVF9D
SEFOQ1RSTF9SVU4sIGlvYXQtPmJhc2UucmVnX2Jhc2UgKyBJT0FUX0NIQU5DVFJMX09GRlNFVCk7
DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL2lvYXQvZG1hLmggYi9kcml2ZXJzL2Rt
YS9pb2F0L2RtYS5oDQppbmRleCA4YmViZGRkLi40NjZlMGYzNGMgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2RtYS9pb2F0L2RtYS5oDQorKysgYi9kcml2ZXJzL2RtYS9pb2F0L2RtYS5oDQpAQCAtMzQ0
LDYgKzM0NCw3IEBAIGJvb2wgaW9hdF9jbGVhbnVwX3ByZWFtYmxlKHN0cnVjdCBpb2F0X2NoYW5f
Y29tbW9uICpjaGFuLA0KIAkJCSAgIGRtYV9hZGRyX3QgKnBoeXNfY29tcGxldGUpOw0KIHZvaWQg
aW9hdF9rb2JqZWN0X2FkZChzdHJ1Y3QgaW9hdGRtYV9kZXZpY2UgKmRldmljZSwgc3RydWN0IGtv
YmpfdHlwZSAqdHlwZSk7DQogdm9pZCBpb2F0X2tvYmplY3RfZGVsKHN0cnVjdCBpb2F0ZG1hX2Rl
dmljZSAqZGV2aWNlKTsNCit2b2lkIGlvYXRfc3RvcChzdHJ1Y3QgaW9hdF9jaGFuX2NvbW1vbiAq
Y2hhbik7DQogZXh0ZXJuIGNvbnN0IHN0cnVjdCBzeXNmc19vcHMgaW9hdF9zeXNmc19vcHM7DQog
ZXh0ZXJuIHN0cnVjdCBpb2F0X3N5c2ZzX2VudHJ5IGlvYXRfdmVyc2lvbl9hdHRyOw0KIGV4dGVy
biBzdHJ1Y3QgaW9hdF9zeXNmc19lbnRyeSBpb2F0X2NhcF9hdHRyOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvZG1hL2lvYXQvZG1hX3YyLmMgYi9kcml2ZXJzL2RtYS9pb2F0L2RtYV92Mi5jDQppbmRl
eCBjYjg4NjRkLi5lNjA5MzNlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9kbWEvaW9hdC9kbWFfdjIu
Yw0KKysrIGIvZHJpdmVycy9kbWEvaW9hdC9kbWFfdjIuYw0KQEAgLTE4OSw4ICsxODksMTEgQEAg
c3RhdGljIHZvaWQgaW9hdDJfY2xlYW51cChzdHJ1Y3QgaW9hdDJfZG1hX2NoYW4gKmlvYXQpDQog
dm9pZCBpb2F0Ml9jbGVhbnVwX2V2ZW50KHVuc2lnbmVkIGxvbmcgZGF0YSkNCiB7DQogCXN0cnVj
dCBpb2F0Ml9kbWFfY2hhbiAqaW9hdCA9IHRvX2lvYXQyX2NoYW4oKHZvaWQgKikgZGF0YSk7DQor
CXN0cnVjdCBpb2F0X2NoYW5fY29tbW9uICpjaGFuID0gJmlvYXQtPmJhc2U7DQogDQogCWlvYXQy
X2NsZWFudXAoaW9hdCk7DQorCWlmICghdGVzdF9iaXQoSU9BVF9SVU4sICZjaGFuLT5zdGF0ZSkp
DQorCQlyZXR1cm47DQogCXdyaXRldyhJT0FUX0NIQU5DVFJMX1JVTiwgaW9hdC0+YmFzZS5yZWdf
YmFzZSArIElPQVRfQ0hBTkNUUkxfT0ZGU0VUKTsNCiB9DQogDQpAQCAtNTQyLDEwICs1NDUsMTAg
QEAgaW50IGlvYXQyX2FsbG9jX2NoYW5fcmVzb3VyY2VzKHN0cnVjdCBkbWFfY2hhbiAqYykNCiAJ
aW9hdC0+aXNzdWVkID0gMDsNCiAJaW9hdC0+dGFpbCA9IDA7DQogCWlvYXQtPmFsbG9jX29yZGVy
ID0gb3JkZXI7DQorCXNldF9iaXQoSU9BVF9SVU4sICZjaGFuLT5zdGF0ZSk7DQogCXNwaW5fdW5s
b2NrX2JoKCZpb2F0LT5wcmVwX2xvY2spOw0KIAlzcGluX3VubG9ja19iaCgmY2hhbi0+Y2xlYW51
cF9sb2NrKTsNCiANCi0JdGFza2xldF9lbmFibGUoJmNoYW4tPmNsZWFudXBfdGFzayk7DQogCWlv
YXQyX3N0YXJ0X251bGxfZGVzYyhpb2F0KTsNCiANCiAJLyogY2hlY2sgdGhhdCB3ZSBnb3Qgb2Zm
IHRoZSBncm91bmQgKi8NCkBAIC01NTUsNyArNTU4LDYgQEAgaW50IGlvYXQyX2FsbG9jX2NoYW5f
cmVzb3VyY2VzKHN0cnVjdCBkbWFfY2hhbiAqYykNCiAJfSB3aGlsZSAoaSsrIDwgMjAgJiYgIWlz
X2lvYXRfYWN0aXZlKHN0YXR1cykgJiYgIWlzX2lvYXRfaWRsZShzdGF0dXMpKTsNCiANCiAJaWYg
KGlzX2lvYXRfYWN0aXZlKHN0YXR1cykgfHwgaXNfaW9hdF9pZGxlKHN0YXR1cykpIHsNCi0JCXNl
dF9iaXQoSU9BVF9SVU4sICZjaGFuLT5zdGF0ZSk7DQogCQlyZXR1cm4gMSA8PCBpb2F0LT5hbGxv
Y19vcmRlcjsNCiAJfSBlbHNlIHsNCiAJCXUzMiBjaGFuZXJyID0gcmVhZGwoY2hhbi0+cmVnX2Jh
c2UgKyBJT0FUX0NIQU5FUlJfT0ZGU0VUKTsNCkBAIC03OTgsMTEgKzgwMCw4IEBAIHZvaWQgaW9h
dDJfZnJlZV9jaGFuX3Jlc291cmNlcyhzdHJ1Y3QgZG1hX2NoYW4gKmMpDQogCWlmICghaW9hdC0+
cmluZykNCiAJCXJldHVybjsNCiANCi0JdGFza2xldF9kaXNhYmxlKCZjaGFuLT5jbGVhbnVwX3Rh
c2spOw0KLQlkZWxfdGltZXJfc3luYygmY2hhbi0+dGltZXIpOw0KLQlkZXZpY2UtPmNsZWFudXBf
Zm4oKHVuc2lnbmVkIGxvbmcpIGMpOw0KKwlpb2F0X3N0b3AoY2hhbik7DQogCWRldmljZS0+cmVz
ZXRfaHcoY2hhbik7DQotCWNsZWFyX2JpdChJT0FUX1JVTiwgJmNoYW4tPnN0YXRlKTsNCiANCiAJ
c3Bpbl9sb2NrX2JoKCZjaGFuLT5jbGVhbnVwX2xvY2spOw0KIAlzcGluX2xvY2tfYmgoJmlvYXQt
PnByZXBfbG9jayk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEvaW9hdC9kbWFfdjMuYyBiL2Ry
aXZlcnMvZG1hL2lvYXQvZG1hX3YzLmMNCmluZGV4IDcxNDU2MGYuLjg2ODAwMzEgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2RtYS9pb2F0L2RtYV92My5jDQorKysgYi9kcml2ZXJzL2RtYS9pb2F0L2Rt
YV92My5jDQpAQCAtMzI1LDggKzMyNSwxMSBAQCBzdGF0aWMgdm9pZCBpb2F0M19jbGVhbnVwKHN0
cnVjdCBpb2F0Ml9kbWFfY2hhbiAqaW9hdCkNCiBzdGF0aWMgdm9pZCBpb2F0M19jbGVhbnVwX2V2
ZW50KHVuc2lnbmVkIGxvbmcgZGF0YSkNCiB7DQogCXN0cnVjdCBpb2F0Ml9kbWFfY2hhbiAqaW9h
dCA9IHRvX2lvYXQyX2NoYW4oKHZvaWQgKikgZGF0YSk7DQorCXN0cnVjdCBpb2F0X2NoYW5fY29t
bW9uICpjaGFuID0gJmlvYXQtPmJhc2U7DQogDQogCWlvYXQzX2NsZWFudXAoaW9hdCk7DQorCWlm
ICghdGVzdF9iaXQoSU9BVF9SVU4sICZjaGFuLT5zdGF0ZSkpDQorCQlyZXR1cm47DQogCXdyaXRl
dyhJT0FUX0NIQU5DVFJMX1JVTiwgaW9hdC0+YmFzZS5yZWdfYmFzZSArIElPQVRfQ0hBTkNUUkxf
T0ZGU0VUKTsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEvc3RlX2RtYTQwLmMgYi9k
cml2ZXJzL2RtYS9zdGVfZG1hNDAuYw0KaW5kZXggMTMyNTljYS4uNGIyN2M1NCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvZG1hL3N0ZV9kbWE0MC5jDQorKysgYi9kcml2ZXJzL2RtYS9zdGVfZG1hNDAu
Yw0KQEAgLTEyMDIsNiArMTIwMiw3IEBAIHN0YXRpYyB2b2lkIGRtYV90YXNrbGV0KHVuc2lnbmVk
IGxvbmcgZGF0YSkNCiAJc3RydWN0IGQ0MF9jaGFuICpkNDBjID0gKHN0cnVjdCBkNDBfY2hhbiAq
KSBkYXRhOw0KIAlzdHJ1Y3QgZDQwX2Rlc2MgKmQ0MGQ7DQogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7
DQorCWJvb2wgY2FsbGJhY2tfYWN0aXZlOw0KIAlkbWFfYXN5bmNfdHhfY2FsbGJhY2sgY2FsbGJh
Y2s7DQogCXZvaWQgKmNhbGxiYWNrX3BhcmFtOw0KIA0KQEAgLTEyMjUsNiArMTIyNiw3IEBAIHN0
YXRpYyB2b2lkIGRtYV90YXNrbGV0KHVuc2lnbmVkIGxvbmcgZGF0YSkNCiAJfQ0KIA0KIAkvKiBD
YWxsYmFjayB0byBjbGllbnQgKi8NCisJY2FsbGJhY2tfYWN0aXZlID0gISEoZDQwZC0+dHhkLmZs
YWdzICYgRE1BX1BSRVBfSU5URVJSVVBUKTsNCiAJY2FsbGJhY2sgPSBkNDBkLT50eGQuY2FsbGJh
Y2s7DQogCWNhbGxiYWNrX3BhcmFtID0gZDQwZC0+dHhkLmNhbGxiYWNrX3BhcmFtOw0KIA0KQEAg
LTEyNDksNyArMTI1MSw3IEBAIHN0YXRpYyB2b2lkIGRtYV90YXNrbGV0KHVuc2lnbmVkIGxvbmcg
ZGF0YSkNCiANCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZDQwYy0+bG9jaywgZmxhZ3MpOw0K
IA0KLQlpZiAoY2FsbGJhY2sgJiYgKGQ0MGQtPnR4ZC5mbGFncyAmIERNQV9QUkVQX0lOVEVSUlVQ
VCkpDQorCWlmIChjYWxsYmFja19hY3RpdmUgJiYgY2FsbGJhY2spDQogCQljYWxsYmFjayhjYWxs
YmFja19wYXJhbSk7DQogDQogCXJldHVybjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2VkYWMvZWRh
Y19tYy5jIGIvZHJpdmVycy9lZGFjL2VkYWNfbWMuYw0KaW5kZXggZDY5MTQ0YS4uN2RiMTAxYiAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvZWRhYy9lZGFjX21jLmMNCisrKyBiL2RyaXZlcnMvZWRhYy9l
ZGFjX21jLmMNCkBAIC0zMjMsNyArMzIzLDggQEAgc3RhdGljIHZvaWQgZWRhY19tY193b3JrcV9m
dW5jdGlvbihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmtfcmVxKQ0KICAqDQogICoJCWNhbGxlZCB3
aXRoIHRoZSBtZW1fY3Rsc19tdXRleCBoZWxkDQogICovDQotc3RhdGljIHZvaWQgZWRhY19tY193
b3JrcV9zZXR1cChzdHJ1Y3QgbWVtX2N0bF9pbmZvICptY2ksIHVuc2lnbmVkIG1zZWMpDQorc3Rh
dGljIHZvaWQgZWRhY19tY193b3JrcV9zZXR1cChzdHJ1Y3QgbWVtX2N0bF9pbmZvICptY2ksIHVu
c2lnbmVkIG1zZWMsDQorCQkJCWJvb2wgaW5pdCkNCiB7DQogCWRlYnVnZjAoIiVzKClcbiIsIF9f
ZnVuY19fKTsNCiANCkBAIC0zMzEsNyArMzMyLDkgQEAgc3RhdGljIHZvaWQgZWRhY19tY193b3Jr
cV9zZXR1cChzdHJ1Y3QgbWVtX2N0bF9pbmZvICptY2ksIHVuc2lnbmVkIG1zZWMpDQogCWlmICht
Y2ktPm9wX3N0YXRlICE9IE9QX1JVTk5JTkdfUE9MTCkNCiAJCXJldHVybjsNCiANCi0JSU5JVF9E
RUxBWUVEX1dPUksoJm1jaS0+d29yaywgZWRhY19tY193b3JrcV9mdW5jdGlvbik7DQorCWlmIChp
bml0KQ0KKwkJSU5JVF9ERUxBWUVEX1dPUksoJm1jaS0+d29yaywgZWRhY19tY193b3JrcV9mdW5j
dGlvbik7DQorDQogCXF1ZXVlX2RlbGF5ZWRfd29yayhlZGFjX3dvcmtxdWV1ZSwgJm1jaS0+d29y
aywgbXNlY3NfdG9famlmZmllcyhtc2VjKSk7DQogfQ0KIA0KQEAgLTM5MSw3ICszOTQsNyBAQCB2
b2lkIGVkYWNfbWNfcmVzZXRfZGVsYXlfcGVyaW9kKGludCB2YWx1ZSkNCiAJbGlzdF9mb3JfZWFj
aChpdGVtLCAmbWNfZGV2aWNlcykgew0KIAkJbWNpID0gbGlzdF9lbnRyeShpdGVtLCBzdHJ1Y3Qg
bWVtX2N0bF9pbmZvLCBsaW5rKTsNCiANCi0JCWVkYWNfbWNfd29ya3Ffc2V0dXAobWNpLCAodW5z
aWduZWQgbG9uZykgdmFsdWUpOw0KKwkJZWRhY19tY193b3JrcV9zZXR1cChtY2ksIHZhbHVlLCBm
YWxzZSk7DQogCX0NCiANCiAJbXV0ZXhfdW5sb2NrKCZtZW1fY3Rsc19tdXRleCk7DQpAQCAtNTM5
LDcgKzU0Miw3IEBAIGludCBlZGFjX21jX2FkZF9tYyhzdHJ1Y3QgbWVtX2N0bF9pbmZvICptY2kp
DQogCQkvKiBUaGlzIGluc3RhbmNlIGlzIE5PVyBSVU5OSU5HICovDQogCQltY2ktPm9wX3N0YXRl
ID0gT1BfUlVOTklOR19QT0xMOw0KIA0KLQkJZWRhY19tY193b3JrcV9zZXR1cChtY2ksIGVkYWNf
bWNfZ2V0X3BvbGxfbXNlYygpKTsNCisJCWVkYWNfbWNfd29ya3Ffc2V0dXAobWNpLCBlZGFjX21j
X2dldF9wb2xsX21zZWMoKSwgdHJ1ZSk7DQogCX0gZWxzZSB7DQogCQltY2ktPm9wX3N0YXRlID0g
T1BfUlVOTklOR19JTlRFUlJVUFQ7DQogCX0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL2VkYWMvaTcz
MDBfZWRhYy5jIGIvZHJpdmVycy9lZGFjL2k3MzAwX2VkYWMuYw0KaW5kZXggMjI0NGRmMC4uMWUw
ODQyNiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZWRhYy9pNzMwMF9lZGFjLmMNCisrKyBiL2RyaXZl
cnMvZWRhYy9pNzMwMF9lZGFjLmMNCkBAIC05NjIsMzMgKzk2MiwzNSBAQCBzdGF0aWMgaW50IF9f
ZGV2aW5pdCBpNzMwMF9nZXRfZGV2aWNlcyhzdHJ1Y3QgbWVtX2N0bF9pbmZvICptY2kpDQogDQog
CS8qIEF0dGVtcHQgdG8gJ2dldCcgdGhlIE1DSCByZWdpc3RlciB3ZSB3YW50ICovDQogCXBkZXYg
PSBOVUxMOw0KLQl3aGlsZSAoIXB2dC0+cGNpX2Rldl8xNl8xX2ZzYl9hZGRyX21hcCB8fA0KLQkg
ICAgICAgIXB2dC0+cGNpX2Rldl8xNl8yX2ZzYl9lcnJfcmVncykgew0KLQkJcGRldiA9IHBjaV9n
ZXRfZGV2aWNlKFBDSV9WRU5ET1JfSURfSU5URUwsDQotCQkJCSAgICAgIFBDSV9ERVZJQ0VfSURf
SU5URUxfSTczMDBfTUNIX0VSUiwgcGRldik7DQotCQlpZiAoIXBkZXYpIHsNCi0JCQkvKiBFbmQg
b2YgbGlzdCwgbGVhdmUgKi8NCi0JCQlpNzMwMF9wcmludGsoS0VSTl9FUlIsDQotCQkJCSInc3lz
dGVtIGFkZHJlc3MsUHJvY2VzcyBCdXMnICINCi0JCQkJImRldmljZSBub3QgZm91bmQ6Ig0KLQkJ
CQkidmVuZG9yIDB4JXggZGV2aWNlIDB4JXggRVJSIGZ1bmNzICINCi0JCQkJIihicm9rZW4gQklP
Uz8pXG4iLA0KLQkJCQlQQ0lfVkVORE9SX0lEX0lOVEVMLA0KLQkJCQlQQ0lfREVWSUNFX0lEX0lO
VEVMX0k3MzAwX01DSF9FUlIpOw0KLQkJCWdvdG8gZXJyb3I7DQotCQl9DQotDQorCXdoaWxlICgo
cGRldiA9IHBjaV9nZXRfZGV2aWNlKFBDSV9WRU5ET1JfSURfSU5URUwsDQorCQkJCSAgICAgIFBD
SV9ERVZJQ0VfSURfSU5URUxfSTczMDBfTUNIX0VSUiwNCisJCQkJICAgICAgcGRldikpKSB7DQog
CQkvKiBTdG9yZSBkZXZpY2UgMTYgZnVuY3MgMSBhbmQgMiAqLw0KIAkJc3dpdGNoIChQQ0lfRlVO
QyhwZGV2LT5kZXZmbikpIHsNCiAJCWNhc2UgMToNCi0JCQlwdnQtPnBjaV9kZXZfMTZfMV9mc2Jf
YWRkcl9tYXAgPSBwZGV2Ow0KKwkJCWlmICghcHZ0LT5wY2lfZGV2XzE2XzFfZnNiX2FkZHJfbWFw
KQ0KKwkJCQlwdnQtPnBjaV9kZXZfMTZfMV9mc2JfYWRkcl9tYXAgPQ0KKwkJCQkJCQlwY2lfZGV2
X2dldChwZGV2KTsNCiAJCQlicmVhazsNCiAJCWNhc2UgMjoNCi0JCQlwdnQtPnBjaV9kZXZfMTZf
Ml9mc2JfZXJyX3JlZ3MgPSBwZGV2Ow0KKwkJCWlmICghcHZ0LT5wY2lfZGV2XzE2XzJfZnNiX2Vy
cl9yZWdzKQ0KKwkJCQlwdnQtPnBjaV9kZXZfMTZfMl9mc2JfZXJyX3JlZ3MgPQ0KKwkJCQkJCQlw
Y2lfZGV2X2dldChwZGV2KTsNCiAJCQlicmVhazsNCiAJCX0NCiAJfQ0KIA0KKwlpZiAoIXB2dC0+
cGNpX2Rldl8xNl8xX2ZzYl9hZGRyX21hcCB8fA0KKwkgICAgIXB2dC0+cGNpX2Rldl8xNl8yX2Zz
Yl9lcnJfcmVncykgew0KKwkJLyogQXQgbGVhc3Qgb25lIGRldmljZSB3YXMgbm90IGZvdW5kICov
DQorCQlpNzMwMF9wcmludGsoS0VSTl9FUlIsDQorCQkJIidzeXN0ZW0gYWRkcmVzcyxQcm9jZXNz
IEJ1cycgZGV2aWNlIG5vdCBmb3VuZDoiDQorCQkJInZlbmRvciAweCV4IGRldmljZSAweCV4IEVS
UiBmdW5jcyAoYnJva2VuIEJJT1M/KVxuIiwNCisJCQlQQ0lfVkVORE9SX0lEX0lOVEVMLA0KKwkJ
CVBDSV9ERVZJQ0VfSURfSU5URUxfSTczMDBfTUNIX0VSUik7DQorCQlnb3RvIGVycm9yOw0KKwl9
DQorDQogCWRlYnVnZjEoIlN5c3RlbSBBZGRyZXNzLCBwcm9jZXNzb3IgYnVzLSBQQ0kgQnVzIElE
OiAlcyAgJXg6JXhcbiIsDQogCQlwY2lfbmFtZShwdnQtPnBjaV9kZXZfMTZfMF9mc2JfY3Rsciks
DQogCQlwdnQtPnBjaV9kZXZfMTZfMF9mc2JfY3Rsci0+dmVuZG9yLA0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvZWRhYy9pN2NvcmVfZWRhYy5jIGIvZHJpdmVycy9lZGFjL2k3Y29yZV9lZGFjLmMNCmlu
ZGV4IGIzY2NlZmEuLjRjMThiM2MgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2VkYWMvaTdjb3JlX2Vk
YWMuYw0KKysrIGIvZHJpdmVycy9lZGFjL2k3Y29yZV9lZGFjLmMNCkBAIC0xMzY1LDE0ICsxMzY1
LDE5IEBAIHN0YXRpYyBpbnQgaTdjb3JlX2dldF9vbmVkZXZpY2Uoc3RydWN0IHBjaV9kZXYgKipw
cmV2LA0KIAkgKiBpcyBhdCBhZGRyIDgwODY6MmM0MCwgaW5zdGVhZCBvZiA4MDg2OjJjNDEuIFNv
LCB3ZSBuZWVkDQogCSAqIHRvIHByb2JlIGZvciB0aGUgYWx0ZXJuYXRlIGFkZHJlc3MgaW4gY2Fz
ZSBvZiBmYWlsdXJlDQogCSAqLw0KLQlpZiAoZGV2X2Rlc2NyLT5kZXZfaWQgPT0gUENJX0RFVklD
RV9JRF9JTlRFTF9JN19OT05DT1JFICYmICFwZGV2KQ0KKwlpZiAoZGV2X2Rlc2NyLT5kZXZfaWQg
PT0gUENJX0RFVklDRV9JRF9JTlRFTF9JN19OT05DT1JFICYmICFwZGV2KSB7DQorCQlwY2lfZGV2
X2dldCgqcHJldik7CS8qIHBjaV9nZXRfZGV2aWNlIHdpbGwgcHV0IGl0ICovDQogCQlwZGV2ID0g
cGNpX2dldF9kZXZpY2UoUENJX1ZFTkRPUl9JRF9JTlRFTCwNCiAJCQkJICAgICAgUENJX0RFVklD
RV9JRF9JTlRFTF9JN19OT05DT1JFX0FMVCwgKnByZXYpOw0KKwl9DQogDQotCWlmIChkZXZfZGVz
Y3ItPmRldl9pZCA9PSBQQ0lfREVWSUNFX0lEX0lOVEVMX0xZTk5GSUVMRF9OT05DT1JFICYmICFw
ZGV2KQ0KKwlpZiAoZGV2X2Rlc2NyLT5kZXZfaWQgPT0gUENJX0RFVklDRV9JRF9JTlRFTF9MWU5O
RklFTERfTk9OQ09SRSAmJg0KKwkgICAgIXBkZXYpIHsNCisJCXBjaV9kZXZfZ2V0KCpwcmV2KTsJ
LyogcGNpX2dldF9kZXZpY2Ugd2lsbCBwdXQgaXQgKi8NCiAJCXBkZXYgPSBwY2lfZ2V0X2Rldmlj
ZShQQ0lfVkVORE9SX0lEX0lOVEVMLA0KIAkJCQkgICAgICBQQ0lfREVWSUNFX0lEX0lOVEVMX0xZ
Tk5GSUVMRF9OT05DT1JFX0FMVCwNCiAJCQkJICAgICAgKnByZXYpOw0KKwl9DQogDQogCWlmICgh
cGRldikgew0KIAkJaWYgKCpwcmV2KSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaW50ZWxfZGlzcGxheS5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5j
DQppbmRleCA2MWI3MDhiLi4yZWE4YTk2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5
MTUvaW50ZWxfZGlzcGxheS5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kaXNw
bGF5LmMNCkBAIC03MjUyLDYgKzcyNTIsMjAgQEAgc3RhdGljIGludCBpbnRlbF9nZW43X3F1ZXVl
X2ZsaXAoc3RydWN0IGRybV9kZXZpY2UgKmRldiwNCiAJCWdvdG8gZXJyX3VucGluOw0KIAl9DQog
DQorCS8qDQorCSAqIEJTcGVjIE1JX0RJU1BMQVlfRkxJUCBmb3IgSVZCOg0KKwkgKiAiVGhlIGZ1
bGwgcGFja2V0IG11c3QgYmUgY29udGFpbmVkIHdpdGhpbiB0aGUgc2FtZSBjYWNoZSBsaW5lLiIN
CisJICoNCisJICogQ3VycmVudGx5IHRoZSBMUkkrU1JNK01JX0RJU1BMQVlfRkxJUCBhbGwgZml0
IHdpdGhpbiB0aGUgc2FtZQ0KKwkgKiBjYWNoZWxpbmUsIGlmIHdlIGV2ZXIgc3RhcnQgZW1pdHRp
bmcgbW9yZSBjb21tYW5kcyBiZWZvcmUNCisJICogdGhlIE1JX0RJU1BMQVlfRkxJUCB3ZSBtYXkg
bmVlZCB0byBmaXJzdCBlbWl0IGV2ZXJ5dGhpbmcgZWxzZSwNCisJICogdGhlbiBkbyB0aGUgY2Fj
aGVsaW5lIGFsaWdubWVudCwgYW5kIGZpbmFsbHkgZW1pdCB0aGUNCisJICogTUlfRElTUExBWV9G
TElQLg0KKwkgKi8NCisJcmV0ID0gaW50ZWxfcmluZ19jYWNoZWxpbmVfYWxpZ24ocmluZyk7DQor
CWlmIChyZXQpDQorCQlnb3RvIGVycl91bnBpbjsNCisNCiAJcmV0ID0gaW50ZWxfcmluZ19iZWdp
bihyaW5nLCA0KTsNCiAJaWYgKHJldCkNCiAJCWdvdG8gZXJyX3VucGluOw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2RwLmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9p
bnRlbF9kcC5jDQppbmRleCA3MjE2M2U4Li5jYTc1MDc2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9n
cHUvZHJtL2k5MTUvaW50ZWxfZHAuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxf
ZHAuYw0KQEAgLTQ4Myw2ICs0ODMsNyBAQCBpbnRlbF9kcF9hdXhfbmF0aXZlX3dyaXRlKHN0cnVj
dCBpbnRlbF9kcCAqaW50ZWxfZHAsDQogCXVpbnQ4X3QJbXNnWzIwXTsNCiAJaW50IG1zZ19ieXRl
czsNCiAJdWludDhfdAlhY2s7DQorCWludCByZXRyeTsNCiANCiAJaW50ZWxfZHBfY2hlY2tfZWRw
KGludGVsX2RwKTsNCiAJaWYgKHNlbmRfYnl0ZXMgPiAxNikNCkBAIC00OTMsMTggKzQ5NCwyMCBA
QCBpbnRlbF9kcF9hdXhfbmF0aXZlX3dyaXRlKHN0cnVjdCBpbnRlbF9kcCAqaW50ZWxfZHAsDQog
CW1zZ1szXSA9IHNlbmRfYnl0ZXMgLSAxOw0KIAltZW1jcHkoJm1zZ1s0XSwgc2VuZCwgc2VuZF9i
eXRlcyk7DQogCW1zZ19ieXRlcyA9IHNlbmRfYnl0ZXMgKyA0Ow0KLQlmb3IgKDs7KSB7DQorCWZv
ciAocmV0cnkgPSAwOyByZXRyeSA8IDc7IHJldHJ5KyspIHsNCiAJCXJldCA9IGludGVsX2RwX2F1
eF9jaChpbnRlbF9kcCwgbXNnLCBtc2dfYnl0ZXMsICZhY2ssIDEpOw0KIAkJaWYgKHJldCA8IDAp
DQogCQkJcmV0dXJuIHJldDsNCiAJCWlmICgoYWNrICYgQVVYX05BVElWRV9SRVBMWV9NQVNLKSA9
PSBBVVhfTkFUSVZFX1JFUExZX0FDSykNCi0JCQlicmVhazsNCisJCQlyZXR1cm4gc2VuZF9ieXRl
czsNCiAJCWVsc2UgaWYgKChhY2sgJiBBVVhfTkFUSVZFX1JFUExZX01BU0spID09IEFVWF9OQVRJ
VkVfUkVQTFlfREVGRVIpDQotCQkJdWRlbGF5KDEwMCk7DQorCQkJdXNsZWVwX3JhbmdlKDQwMCwg
NTAwKTsNCiAJCWVsc2UNCiAJCQlyZXR1cm4gLUVJTzsNCiAJfQ0KLQlyZXR1cm4gc2VuZF9ieXRl
czsNCisNCisJRFJNX0VSUk9SKCJ0b28gbWFueSByZXRyaWVzLCBnaXZpbmcgdXBcbiIpOw0KKwly
ZXR1cm4gLUVJTzsNCiB9DQogDQogLyogV3JpdGUgYSBzaW5nbGUgYnl0ZSB0byB0aGUgYXV4IGNo
YW5uZWwgaW4gbmF0aXZlIG1vZGUgKi8NCkBAIC01MjYsNiArNTI5LDcgQEAgaW50ZWxfZHBfYXV4
X25hdGl2ZV9yZWFkKHN0cnVjdCBpbnRlbF9kcCAqaW50ZWxfZHAsDQogCWludCByZXBseV9ieXRl
czsNCiAJdWludDhfdCBhY2s7DQogCWludCByZXQ7DQorCWludCByZXRyeTsNCiANCiAJaW50ZWxf
ZHBfY2hlY2tfZWRwKGludGVsX2RwKTsNCiAJbXNnWzBdID0gQVVYX05BVElWRV9SRUFEIDw8IDQ7
DQpAQCAtNTM2LDcgKzU0MCw3IEBAIGludGVsX2RwX2F1eF9uYXRpdmVfcmVhZChzdHJ1Y3QgaW50
ZWxfZHAgKmludGVsX2RwLA0KIAltc2dfYnl0ZXMgPSA0Ow0KIAlyZXBseV9ieXRlcyA9IHJlY3Zf
Ynl0ZXMgKyAxOw0KIA0KLQlmb3IgKDs7KSB7DQorCWZvciAocmV0cnkgPSAwOyByZXRyeSA8IDc7
IHJldHJ5KyspIHsNCiAJCXJldCA9IGludGVsX2RwX2F1eF9jaChpbnRlbF9kcCwgbXNnLCBtc2df
Ynl0ZXMsDQogCQkJCSAgICAgIHJlcGx5LCByZXBseV9ieXRlcyk7DQogCQlpZiAocmV0ID09IDAp
DQpAQCAtNTQ5LDEwICs1NTMsMTMgQEAgaW50ZWxfZHBfYXV4X25hdGl2ZV9yZWFkKHN0cnVjdCBp
bnRlbF9kcCAqaW50ZWxfZHAsDQogCQkJcmV0dXJuIHJldCAtIDE7DQogCQl9DQogCQllbHNlIGlm
ICgoYWNrICYgQVVYX05BVElWRV9SRVBMWV9NQVNLKSA9PSBBVVhfTkFUSVZFX1JFUExZX0RFRkVS
KQ0KLQkJCXVkZWxheSgxMDApOw0KKwkJCXVzbGVlcF9yYW5nZSg0MDAsIDUwMCk7DQogCQllbHNl
DQogCQkJcmV0dXJuIC1FSU87DQogCX0NCisNCisJRFJNX0VSUk9SKCJ0b28gbWFueSByZXRyaWVz
LCBnaXZpbmcgdXBcbiIpOw0KKwlyZXR1cm4gLUVJTzsNCiB9DQogDQogc3RhdGljIGludA0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZmZXIuYyBiL2RyaXZl
cnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZmZXIuYw0KaW5kZXggM2M1NWNmNi4uOGVlMDY4
ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZmZXIuYw0K
KysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZlci5jDQpAQCAtMTIxMyw2
ICsxMjEzLDI3IEBAIGludCBpbnRlbF9yaW5nX2JlZ2luKHN0cnVjdCBpbnRlbF9yaW5nX2J1ZmZl
ciAqcmluZywNCiAJcmV0dXJuIDA7DQogfQ0KIA0KKy8qIEFsaWduIHRoZSByaW5nIHRhaWwgdG8g
YSBjYWNoZWxpbmUgYm91bmRhcnkgKi8NCitpbnQgaW50ZWxfcmluZ19jYWNoZWxpbmVfYWxpZ24o
c3RydWN0IGludGVsX3JpbmdfYnVmZmVyICpyaW5nKQ0KK3sNCisJaW50IG51bV9kd29yZHMgPSAo
NjQgLSAocmluZy0+dGFpbCAmIDYzKSkgLyBzaXplb2YodWludDMyX3QpOw0KKwlpbnQgcmV0Ow0K
Kw0KKwlpZiAobnVtX2R3b3JkcyA9PSAwKQ0KKwkJcmV0dXJuIDA7DQorDQorCXJldCA9IGludGVs
X3JpbmdfYmVnaW4ocmluZywgbnVtX2R3b3Jkcyk7DQorCWlmIChyZXQpDQorCQlyZXR1cm4gcmV0
Ow0KKw0KKwl3aGlsZSAobnVtX2R3b3Jkcy0tKQ0KKwkJaW50ZWxfcmluZ19lbWl0KHJpbmcsIE1J
X05PT1ApOw0KKw0KKwlpbnRlbF9yaW5nX2FkdmFuY2UocmluZyk7DQorDQorCXJldHVybiAwOw0K
K30NCisNCiB2b2lkIGludGVsX3JpbmdfYWR2YW5jZShzdHJ1Y3QgaW50ZWxfcmluZ19idWZmZXIg
KnJpbmcpDQogew0KIAlyaW5nLT50YWlsICY9IHJpbmctPnNpemUgLSAxOw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZmZXIuaCBiL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2ludGVsX3JpbmdidWZmZXIuaA0KaW5kZXggNjgyODFjOS4uZDgzY2M5NyAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3JpbmdidWZmZXIuaA0KKysrIGIvZHJp
dmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfcmluZ2J1ZmZlci5oDQpAQCAtMTc0LDYgKzE3NCw3IEBA
IHN0YXRpYyBpbmxpbmUgaW50IGludGVsX3dhaXRfcmluZ19pZGxlKHN0cnVjdCBpbnRlbF9yaW5n
X2J1ZmZlciAqcmluZykNCiB9DQogDQogaW50IF9fbXVzdF9jaGVjayBpbnRlbF9yaW5nX2JlZ2lu
KHN0cnVjdCBpbnRlbF9yaW5nX2J1ZmZlciAqcmluZywgaW50IG4pOw0KK2ludCBfX211c3RfY2hl
Y2sgaW50ZWxfcmluZ19jYWNoZWxpbmVfYWxpZ24oc3RydWN0IGludGVsX3JpbmdfYnVmZmVyICpy
aW5nKTsNCiANCiBzdGF0aWMgaW5saW5lIHZvaWQgaW50ZWxfcmluZ19lbWl0KHN0cnVjdCBpbnRl
bF9yaW5nX2J1ZmZlciAqcmluZywNCiAJCQkJICAgdTMyIGRhdGEpDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFk
ZW9uL2F0b21iaW9zX2NydGMuYw0KaW5kZXggMDM4NTcwYS4uY2Q5OGMwNiAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jDQorKysgYi9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL2F0b21iaW9zX2NydGMuYw0KQEAgLTk1NiwxMCArOTU2LDEzIEBAIHN0YXRp
YyB2b2lkIGF0b21iaW9zX2NydGNfc2V0X3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMsIHN0cnVj
dCBkcm1fZGlzcGxheV9tb2RlDQogCQkJCQkJc3NfZW5hYmxlZCA9DQogCQkJCQkJCXJhZGVvbl9h
dG9tYmlvc19nZXRfcHBsbF9zc19pbmZvKHJkZXYsICZzcywNCiAJCQkJCQkJCQkJCSBBVE9NX0RQ
X1NTX0lEMSk7DQotCQkJCX0gZWxzZQ0KKwkJCQl9IGVsc2Ugew0KIAkJCQkJc3NfZW5hYmxlZCA9
DQogCQkJCQkJcmFkZW9uX2F0b21iaW9zX2dldF9wcGxsX3NzX2luZm8ocmRldiwgJnNzLA0KIAkJ
CQkJCQkJCQkgQVRPTV9EUF9TU19JRDEpOw0KKwkJCQl9DQorCQkJCS8qIGRpc2FibGUgc3ByZWFk
IHNwZWN0cnVtIG9uIERDRTMgRFAgKi8NCisJCQkJc3NfZW5hYmxlZCA9IGZhbHNlOw0KIAkJCX0N
CiAJCQlicmVhazsNCiAJCWNhc2UgQVRPTV9FTkNPREVSX01PREVfTFZEUzoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cjYwMC5jDQppbmRleCA1N2U0NWM2Li5mN2UzY2MwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9yNjAwLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMC5jDQpA
QCAtMjMxNSwxNCArMjMxNSwxOCBAQCBpbnQgcjYwMF9yaW5nX3Rlc3Qoc3RydWN0IHJhZGVvbl9k
ZXZpY2UgKnJkZXYpDQogdm9pZCByNjAwX2ZlbmNlX3JpbmdfZW1pdChzdHJ1Y3QgcmFkZW9uX2Rl
dmljZSAqcmRldiwNCiAJCQkgIHN0cnVjdCByYWRlb25fZmVuY2UgKmZlbmNlKQ0KIHsNCisJdTMy
IGNwX2NvaGVyX2NudGwgPSBQQUNLRVQzX1RDX0FDVElPTl9FTkEgfCBQQUNLRVQzX1ZDX0FDVElP
Tl9FTkEgfA0KKwkJUEFDS0VUM19TSF9BQ1RJT05fRU5BOw0KKw0KKwlpZiAocmRldi0+ZmFtaWx5
ID49IENISVBfUlY3NzApDQorCQljcF9jb2hlcl9jbnRsIHw9IFBBQ0tFVDNfRlVMTF9DQUNIRV9F
TkE7DQorDQogCWlmIChyZGV2LT53Yi51c2VfZXZlbnQpIHsNCiAJCXU2NCBhZGRyID0gcmRldi0+
d2IuZ3B1X2FkZHIgKyBSNjAwX1dCX0VWRU5UX09GRlNFVCArDQogCQkJKHU2NCkocmRldi0+ZmVu
Y2VfZHJ2LnNjcmF0Y2hfcmVnIC0gcmRldi0+c2NyYXRjaC5yZWdfYmFzZSk7DQogCQkvKiBmbHVz
aCByZWFkIGNhY2hlIG92ZXIgZ2FydCAqLw0KIAkJcmFkZW9uX3Jpbmdfd3JpdGUocmRldiwgUEFD
S0VUMyhQQUNLRVQzX1NVUkZBQ0VfU1lOQywgMykpOw0KLQkJcmFkZW9uX3Jpbmdfd3JpdGUocmRl
diwgUEFDS0VUM19UQ19BQ1RJT05fRU5BIHwNCi0JCQkJCVBBQ0tFVDNfVkNfQUNUSU9OX0VOQSB8
DQotCQkJCQlQQUNLRVQzX1NIX0FDVElPTl9FTkEpOw0KKwkJcmFkZW9uX3Jpbmdfd3JpdGUocmRl
diwgY3BfY29oZXJfY250bCk7DQogCQlyYWRlb25fcmluZ193cml0ZShyZGV2LCAweEZGRkZGRkZG
KTsNCiAJCXJhZGVvbl9yaW5nX3dyaXRlKHJkZXYsIDApOw0KIAkJcmFkZW9uX3Jpbmdfd3JpdGUo
cmRldiwgMTApOyAvKiBwb2xsIGludGVydmFsICovDQpAQCAtMjMzNiw5ICsyMzQwLDcgQEAgdm9p
ZCByNjAwX2ZlbmNlX3JpbmdfZW1pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiwNCiAJfSBl
bHNlIHsNCiAJCS8qIGZsdXNoIHJlYWQgY2FjaGUgb3ZlciBnYXJ0ICovDQogCQlyYWRlb25fcmlu
Z193cml0ZShyZGV2LCBQQUNLRVQzKFBBQ0tFVDNfU1VSRkFDRV9TWU5DLCAzKSk7DQotCQlyYWRl
b25fcmluZ193cml0ZShyZGV2LCBQQUNLRVQzX1RDX0FDVElPTl9FTkEgfA0KLQkJCQkJUEFDS0VU
M19WQ19BQ1RJT05fRU5BIHwNCi0JCQkJCVBBQ0tFVDNfU0hfQUNUSU9OX0VOQSk7DQorCQlyYWRl
b25fcmluZ193cml0ZShyZGV2LCBjcF9jb2hlcl9jbnRsKTsNCiAJCXJhZGVvbl9yaW5nX3dyaXRl
KHJkZXYsIDB4RkZGRkZGRkYpOw0KIAkJcmFkZW9uX3Jpbmdfd3JpdGUocmRldiwgMCk7DQogCQly
YWRlb25fcmluZ193cml0ZShyZGV2LCAxMCk7IC8qIHBvbGwgaW50ZXJ2YWwgKi8NCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDBkLmggYi9kcml2ZXJzL2dwdS9kcm0vcmFk
ZW9uL3I2MDBkLmgNCmluZGV4IGQ0ZDIzYThkLi5jYjI5NDgwIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9yNjAwZC5oDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2
MDBkLmgNCkBAIC04MzgsNiArODM4LDcgQEANCiAjZGVmaW5lCVBBQ0tFVDNfSU5ESVJFQ1RfQlVG
RkVSCQkJCTB4MzINCiAjZGVmaW5lCVBBQ0tFVDNfU1VSRkFDRV9TWU5DCQkJCTB4NDMNCiAjICAg
ICAgICAgICAgICBkZWZpbmUgUEFDS0VUM19DQjBfREVTVF9CQVNFX0VOQSAgICAoMSA8PCA2KQ0K
KyMgICAgICAgICAgICAgIGRlZmluZSBQQUNLRVQzX0ZVTExfQ0FDSEVfRU5BICAgICAgICgxIDw8
IDIwKSAvKiByN3h4KyBvbmx5ICovDQogIyAgICAgICAgICAgICAgZGVmaW5lIFBBQ0tFVDNfVENf
QUNUSU9OX0VOQSAgICAgICAgKDEgPDwgMjMpDQogIyAgICAgICAgICAgICAgZGVmaW5lIFBBQ0tF
VDNfVkNfQUNUSU9OX0VOQSAgICAgICAgKDEgPDwgMjQpDQogIyAgICAgICAgICAgICAgZGVmaW5l
IFBBQ0tFVDNfQ0JfQUNUSU9OX0VOQSAgICAgICAgKDEgPDwgMjUpDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXRvbWJpb3MuYyBiL2RyaXZlcnMvZ3B1L2RybS9y
YWRlb24vcmFkZW9uX2F0b21iaW9zLmMNCmluZGV4IGNkYTg5YzZiLi5lNGU0NTVlIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXRvbWJpb3MuYw0KKysrIGIvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXRvbWJpb3MuYw0KQEAgLTI3MzUsNiArMjczNSwx
MCBAQCB2b2lkIHJhZGVvbl9hdG9tX2luaXRpYWxpemVfYmlvc19zY3JhdGNoX3JlZ3Moc3RydWN0
IGRybV9kZXZpY2UgKmRldikNCiAJLyogdGVsbCB0aGUgYmlvcyBub3QgdG8gaGFuZGxlIG1vZGUg
c3dpdGNoaW5nICovDQogCWJpb3NfNl9zY3JhdGNoIHw9IEFUT01fUzZfQUNDX0JMT0NLX0RJU1BM
QVlfU1dJVENIOw0KIA0KKwkvKiBjbGVhciB0aGUgdmJpb3MgZHBtcyBzdGF0ZSAqLw0KKwlpZiAo
QVNJQ19JU19EQ0U0KHJkZXYpKQ0KKwkJYmlvc18yX3NjcmF0Y2ggJj0gfkFUT01fUzJfREVWSUNF
X0RQTVNfU1RBVEU7DQorDQogCWlmIChyZGV2LT5mYW1pbHkgPj0gQ0hJUF9SNjAwKSB7DQogCQlX
UkVHMzIoUjYwMF9CSU9TXzJfU0NSQVRDSCwgYmlvc18yX3NjcmF0Y2gpOw0KIAkJV1JFRzMyKFI2
MDBfQklPU182X1NDUkFUQ0gsIGJpb3NfNl9zY3JhdGNoKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9pMmMuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFk
ZW9uX2kyYy5jDQppbmRleCBjZjIwMzUxLi44OTRiNWYwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yYWRlb25faTJjLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cmFkZW9uX2kyYy5jDQpAQCAtOTk4LDYgKzk5OCw5IEBAIHZvaWQgcmFkZW9uX2kyY19kZXN0cm95
KHN0cnVjdCByYWRlb25faTJjX2NoYW4gKmkyYykNCiAvKiBBZGQgdGhlIGRlZmF1bHQgYnVzZXMg
Ki8NCiB2b2lkIHJhZGVvbl9pMmNfaW5pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiB7
DQorCWlmIChyYWRlb25faHdfaTJjKQ0KKwkJRFJNX0lORk8oImh3X2kyYyBmb3JjZWQgb24sIHlv
dSBtYXkgZXhwZXJpZW5jZSBkaXNwbGF5IGRldGVjdGlvbiBwcm9ibGVtcyFcbiIpOw0KKw0KIAlp
ZiAocmRldi0+aXNfYXRvbV9iaW9zKQ0KIAkJcmFkZW9uX2F0b21iaW9zX2kyY19pbml0KHJkZXYp
Ow0KIAllbHNlDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fcG0u
YyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX3BtLmMNCmluZGV4IGQ1OGVjY2IuLmIw
YTBlZTQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9wbS5jDQor
KysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9wbS5jDQpAQCAtNTczLDggKzU3Mywx
MCBAQCB2b2lkIHJhZGVvbl9wbV9yZXN1bWUoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpDQog
CXJkZXYtPnBtLmN1cnJlbnRfY2xvY2tfbW9kZV9pbmRleCA9IDA7DQogCXJkZXYtPnBtLmN1cnJl
bnRfc2NsayA9IHJkZXYtPnBtLmRlZmF1bHRfc2NsazsNCiAJcmRldi0+cG0uY3VycmVudF9tY2xr
ID0gcmRldi0+cG0uZGVmYXVsdF9tY2xrOw0KLQlyZGV2LT5wbS5jdXJyZW50X3ZkZGMgPSByZGV2
LT5wbS5wb3dlcl9zdGF0ZVtyZGV2LT5wbS5kZWZhdWx0X3Bvd2VyX3N0YXRlX2luZGV4XS5jbG9j
a19pbmZvWzBdLnZvbHRhZ2Uudm9sdGFnZTsNCi0JcmRldi0+cG0uY3VycmVudF92ZGRjaSA9IHJk
ZXYtPnBtLnBvd2VyX3N0YXRlW3JkZXYtPnBtLmRlZmF1bHRfcG93ZXJfc3RhdGVfaW5kZXhdLmNs
b2NrX2luZm9bMF0udm9sdGFnZS52ZGRjaTsNCisJaWYgKHJkZXYtPnBtLnBvd2VyX3N0YXRlKSB7
DQorCQlyZGV2LT5wbS5jdXJyZW50X3ZkZGMgPSByZGV2LT5wbS5wb3dlcl9zdGF0ZVtyZGV2LT5w
bS5kZWZhdWx0X3Bvd2VyX3N0YXRlX2luZGV4XS5jbG9ja19pbmZvWzBdLnZvbHRhZ2Uudm9sdGFn
ZTsNCisJCXJkZXYtPnBtLmN1cnJlbnRfdmRkY2kgPSByZGV2LT5wbS5wb3dlcl9zdGF0ZVtyZGV2
LT5wbS5kZWZhdWx0X3Bvd2VyX3N0YXRlX2luZGV4XS5jbG9ja19pbmZvWzBdLnZvbHRhZ2UudmRk
Y2k7DQorCX0NCiAJaWYgKHJkZXYtPnBtLnBtX21ldGhvZCA9PSBQTV9NRVRIT0RfRFlOUE0NCiAJ
ICAgICYmIHJkZXYtPnBtLmR5bnBtX3N0YXRlID09IERZTlBNX1NUQVRFX1NVU1BFTkRFRCkgew0K
IAkJcmRldi0+cG0uZHlucG1fc3RhdGUgPSBEWU5QTV9TVEFURV9BQ1RJVkU7DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9odi9jb25uZWN0aW9uLmMgYi9kcml2ZXJzL2h2L2Nvbm5lY3Rpb24uYw0KaW5k
ZXggNjUwYzlmMC4uZDdmM2RmOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaHYvY29ubmVjdGlvbi5j
DQorKysgYi9kcml2ZXJzL2h2L2Nvbm5lY3Rpb24uYw0KQEAgLTQ1LDcgKzQ1LDYgQEAgc3RydWN0
IHZtYnVzX2Nvbm5lY3Rpb24gdm1idXNfY29ubmVjdGlvbiA9IHsNCiBpbnQgdm1idXNfY29ubmVj
dCh2b2lkKQ0KIHsNCiAJaW50IHJldCA9IDA7DQotCWludCB0Ow0KIAlzdHJ1Y3Qgdm1idXNfY2hh
bm5lbF9tc2dpbmZvICptc2dpbmZvID0gTlVMTDsNCiAJc3RydWN0IHZtYnVzX2NoYW5uZWxfaW5p
dGlhdGVfY29udGFjdCAqbXNnOw0KIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KQEAgLTEzMiwxNiAr
MTMxLDcgQEAgaW50IHZtYnVzX2Nvbm5lY3Qodm9pZCkNCiAJfQ0KIA0KIAkvKiBXYWl0IGZvciB0
aGUgY29ubmVjdGlvbiByZXNwb25zZSAqLw0KLQl0ID0gIHdhaXRfZm9yX2NvbXBsZXRpb25fdGlt
ZW91dCgmbXNnaW5mby0+d2FpdGV2ZW50LCA1KkhaKTsNCi0JaWYgKHQgPT0gMCkgew0KLQkJc3Bp
bl9sb2NrX2lycXNhdmUoJnZtYnVzX2Nvbm5lY3Rpb24uY2hhbm5lbG1zZ19sb2NrLA0KLQkJCQlm
bGFncyk7DQotCQlsaXN0X2RlbCgmbXNnaW5mby0+bXNnbGlzdGVudHJ5KTsNCi0JCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJnZtYnVzX2Nvbm5lY3Rpb24uY2hhbm5lbG1zZ19sb2NrLA0KLQkJCQkJ
ZmxhZ3MpOw0KLQkJcmV0ID0gLUVUSU1FRE9VVDsNCi0JCWdvdG8gY2xlYW51cDsNCi0JfQ0KKwl3
YWl0X2Zvcl9jb21wbGV0aW9uKCZtc2dpbmZvLT53YWl0ZXZlbnQpOw0KIA0KIAlzcGluX2xvY2tf
aXJxc2F2ZSgmdm1idXNfY29ubmVjdGlvbi5jaGFubmVsbXNnX2xvY2ssIGZsYWdzKTsNCiAJbGlz
dF9kZWwoJm1zZ2luZm8tPm1zZ2xpc3RlbnRyeSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9od21v
bi9tYXgxNjY4LmMgYi9kcml2ZXJzL2h3bW9uL21heDE2NjguYw0KaW5kZXggMjBkMWIyZC4uZTE5
ZmVmNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaHdtb24vbWF4MTY2OC5jDQorKysgYi9kcml2ZXJz
L2h3bW9uL21heDE2NjguYw0KQEAgLTI0Myw3ICsyNDMsNyBAQCBzdGF0aWMgc3NpemVfdCBzZXRf
dGVtcF9taW4oc3RydWN0IGRldmljZSAqZGV2LA0KIAlkYXRhLT50ZW1wX21pbltpbmRleF0gPSBT
RU5TT1JTX0xJTUlUKHRlbXAvMTAwMCwgLTEyOCwgMTI3KTsNCiAJaWYgKGkyY19zbWJ1c193cml0
ZV9ieXRlX2RhdGEoY2xpZW50LA0KIAkJCQkJTUFYMTY2OF9SRUdfTElNTF9XUihpbmRleCksDQot
CQkJCQlkYXRhLT50ZW1wX21heFtpbmRleF0pKQ0KKwkJCQkJZGF0YS0+dGVtcF9taW5baW5kZXhd
KSkNCiAJCWNvdW50ID0gLUVJTzsNCiAJbXV0ZXhfdW5sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7
DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pMmMvYnVzc2VzL0tjb25maWcgYi9kcml2ZXJzL2ky
Yy9idXNzZXMvS2NvbmZpZw0KaW5kZXggZGJkNGZhNS4uOTQ5ZWE2NDAgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL2kyYy9idXNzZXMvS2NvbmZpZw0KKysrIGIvZHJpdmVycy9pMmMvYnVzc2VzL0tjb25m
aWcNCkBAIC0xMzcsNiArMTM3LDcgQEAgY29uZmlnIEkyQ19QSUlYNA0KIAkgICAgQVRJIFNCNzAw
DQogCSAgICBBVEkgU0I4MDANCiAJICAgIEFNRCBIdWRzb24tMg0KKwkgICAgQU1EIE1MDQogCSAg
ICBBTUQgQ1oNCiAJICAgIFNlcnZlcndvcmtzIE9TQjQNCiAJICAgIFNlcnZlcndvcmtzIENTQjUN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2kyYy9idXNzZXMvaTJjLXBpaXg0LmMgYi9kcml2ZXJzL2ky
Yy9idXNzZXMvaTJjLXBpaXg0LmMNCmluZGV4IDE0YjU4OGMuLmM2MGY4ZTEgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2kyYy9idXNzZXMvaTJjLXBpaXg0LmMNCisrKyBiL2RyaXZlcnMvaTJjL2J1c3Nl
cy9pMmMtcGlpeDQuYw0KQEAgLTIyLDcgKzIyLDcgQEANCiAJSW50ZWwgUElJWDQsIDQ0ME1YDQog
CVNlcnZlcndvcmtzIE9TQjQsIENTQjUsIENTQjYsIEhULTEwMDAsIEhULTExMDANCiAJQVRJIElY
UDIwMCwgSVhQMzAwLCBJWFA0MDAsIFNCNjAwLCBTQjcwMCwgU0I4MDANCi0JQU1EIEh1ZHNvbi0y
LCBDWg0KKwlBTUQgSHVkc29uLTIsIE1MLCBDWg0KIAlTTVNDIFZpY3Rvcnk2Ng0KIA0KICAgIE5v
dGU6IHdlIGFzc3VtZSB0aGVyZSBjYW4gb25seSBiZSBvbmUgZGV2aWNlLCB3aXRoIG9uZSBTTUJ1
cyBpbnRlcmZhY2UuDQpAQCAtMjMxLDcgKzIzMSw4IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHBp
aXg0X3NldHVwX3NiODAwKHN0cnVjdCBwY2lfZGV2ICpQSUlYNF9kZXYsDQogCQkJCWNvbnN0IHN0
cnVjdCBwY2lfZGV2aWNlX2lkICppZCkNCiB7DQogCXVuc2lnbmVkIHNob3J0IHNtYmFfaWR4ID0g
MHhjZDY7DQotCXU4IHNtYmFfZW5fbG8sIHNtYmFfZW5faGksIGkyY2NmZywgaTJjY2ZnX29mZnNl
dCA9IDB4MTAsIHNtYl9lbiA9IDB4MmM7DQorCXU4IHNtYmFfZW5fbG8sIHNtYmFfZW5faGksIHNt
Yl9lbiwgc21iX2VuX3N0YXR1czsNCisJdTggaTJjY2ZnLCBpMmNjZmdfb2Zmc2V0ID0gMHgxMDsN
CiANCiAJLyogU0I4MDAgYW5kIGxhdGVyIFNNQnVzIGRvZXMgbm90IHN1cHBvcnQgZm9yY2luZyBh
ZGRyZXNzICovDQogCWlmIChmb3JjZSB8fCBmb3JjZV9hZGRyKSB7DQpAQCAtMjQxLDYgKzI0Miwx
NiBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBwaWl4NF9zZXR1cF9zYjgwMChzdHJ1Y3QgcGNpX2Rl
diAqUElJWDRfZGV2LA0KIAl9DQogDQogCS8qIERldGVybWluZSB0aGUgYWRkcmVzcyBvZiB0aGUg
U01CdXMgYXJlYXMgKi8NCisJaWYgKChQSUlYNF9kZXYtPnZlbmRvciA9PSBQQ0lfVkVORE9SX0lE
X0FNRCAmJg0KKwkgICAgIFBJSVg0X2Rldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfQU1EX0hV
RFNPTjJfU01CVVMgJiYNCisJICAgICBQSUlYNF9kZXYtPnJldmlzaW9uID49IDB4NDEpIHx8DQor
CSAgICAoUElJWDRfZGV2LT52ZW5kb3IgPT0gUENJX1ZFTkRPUl9JRF9BTUQgJiYNCisJICAgICBQ
SUlYNF9kZXYtPmRldmljZSA9PSAweDc5MGIgJiYNCisJICAgICBQSUlYNF9kZXYtPnJldmlzaW9u
ID49IDB4NDkpKQ0KKwkJc21iX2VuID0gMHgwMDsNCisJZWxzZQ0KKwkJc21iX2VuID0gMHgyYzsN
CisNCiAJaWYgKCFyZXF1ZXN0X3JlZ2lvbihzbWJhX2lkeCwgMiwgInNtYmFfaWR4IikpIHsNCiAJ
CWRldl9lcnIoJlBJSVg0X2Rldi0+ZGV2LCAiU01CdXMgYmFzZSBhZGRyZXNzIGluZGV4IHJlZ2lv
biAiDQogCQkJIjB4JXggYWxyZWFkeSBpbiB1c2UhXG4iLCBzbWJhX2lkeCk7DQpAQCAtMjUyLDEz
ICsyNjMsMjAgQEAgc3RhdGljIGludCBfX2RldmluaXQgcGlpeDRfc2V0dXBfc2I4MDAoc3RydWN0
IHBjaV9kZXYgKlBJSVg0X2RldiwNCiAJc21iYV9lbl9oaSA9IGluYl9wKHNtYmFfaWR4ICsgMSk7
DQogCXJlbGVhc2VfcmVnaW9uKHNtYmFfaWR4LCAyKTsNCiANCi0JaWYgKChzbWJhX2VuX2xvICYg
MSkgPT0gMCkgew0KKwlpZiAoIXNtYl9lbikgew0KKwkJc21iX2VuX3N0YXR1cyA9IHNtYmFfZW5f
bG8gJiAweDEwOw0KKwkJcGlpeDRfc21iYSA9IHNtYmFfZW5faGkgPDwgODsNCisJfSBlbHNlIHsN
CisJCXNtYl9lbl9zdGF0dXMgPSBzbWJhX2VuX2xvICYgMHgwMTsNCisJCXBpaXg0X3NtYmEgPSAo
KHNtYmFfZW5faGkgPDwgOCkgfCBzbWJhX2VuX2xvKSAmIDB4ZmZlMDsNCisJfQ0KKw0KKwlpZiAo
IXNtYl9lbl9zdGF0dXMpIHsNCiAJCWRldl9lcnIoJlBJSVg0X2Rldi0+ZGV2LA0KIAkJCSJIb3N0
IFNNQnVzIGNvbnRyb2xsZXIgbm90IGVuYWJsZWQhXG4iKTsNCiAJCXJldHVybiAtRU5PREVWOw0K
IAl9DQogDQotCXBpaXg0X3NtYmEgPSAoKHNtYmFfZW5faGkgPDwgOCkgfCBzbWJhX2VuX2xvKSAm
IDB4ZmZlMDsNCiAJaWYgKGFjcGlfY2hlY2tfcmVnaW9uKHBpaXg0X3NtYmEsIFNNQklPU0laRSwg
cGlpeDRfZHJpdmVyLm5hbWUpKQ0KIAkJcmV0dXJuIC1FTk9ERVY7DQogDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9pZGxlL2ludGVsX2lkbGUuYyBiL2RyaXZlcnMvaWRsZS9pbnRlbF9pZGxlLmMNCmlu
ZGV4IDRmYTJiMTEuLjQ0ZmRlNDMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lkbGUvaW50ZWxfaWRs
ZS5jDQorKysgYi9kcml2ZXJzL2lkbGUvaW50ZWxfaWRsZS5jDQpAQCAtNTg0LDggKzU4NCw5IEBA
IHN0YXRpYyBpbnQgX19pbml0IGludGVsX2lkbGVfaW5pdCh2b2lkKQ0KIAlpbnRlbF9pZGxlX2Nw
dWlkbGVfZHJpdmVyX2luaXQoKTsNCiAJcmV0dmFsID0gY3B1aWRsZV9yZWdpc3Rlcl9kcml2ZXIo
JmludGVsX2lkbGVfZHJpdmVyKTsNCiAJaWYgKHJldHZhbCkgew0KKwkJc3RydWN0IGNwdWlkbGVf
ZHJpdmVyICpkcnYgPSBjcHVpZGxlX2dldF9kcml2ZXIoKTsNCiAJCXByaW50ayhLRVJOX0RFQlVH
IFBSRUZJWCAiaW50ZWxfaWRsZSB5aWVsZGluZyB0byAlcyIsDQotCQkJY3B1aWRsZV9nZXRfZHJp
dmVyKCktPm5hbWUpOw0KKwkJCWRydiA/IGRydi0+bmFtZSA6ICJub25lIik7DQogCQlyZXR1cm4g
cmV0dmFsOw0KIAl9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L3FpYi9x
aWJfaWJhNzMyMi5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L3FpYi9xaWJfaWJhNzMyMi5jDQpp
bmRleCA1YTA3MGU4Li5kODUxN2ZjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3
L3FpYi9xaWJfaWJhNzMyMi5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl9p
YmE3MzIyLmMNCkBAIC0yMjc5LDYgKzIyNzksMTEgQEAgc3RhdGljIGludCBxaWJfNzMyMl9icmlu
Z3VwX3NlcmRlcyhzdHJ1Y3QgcWliX3Bwb3J0ZGF0YSAqcHBkKQ0KIAlxaWJfd3JpdGVfa3JlZ19w
b3J0KHBwZCwga3JwX2liY2N0cmxfYSwgcHBkLT5jcHNwZWMtPmliY2N0cmxfYSk7DQogCXFpYl93
cml0ZV9rcmVnKGRkLCBrcl9zY3JhdGNoLCAwVUxMKTsNCiANCisJLyogZW5zdXJlIHByZXZpb3Vz
IFR4IHBhcmFtZXRlcnMgYXJlIG5vdCBzdGlsbCBmb3JjZWQgKi8NCisJcWliX3dyaXRlX2tyZWdf
cG9ydChwcGQsIGtycF90eF9kZWVtcGhfb3ZlcnJpZGUsDQorCQlTWU1fTUFTSyhJQlNEX1RYX0RF
RU1QSEFTSVNfT1ZFUlJJREVfMCwNCisJCXJlc2V0X3R4X2RlZW1waGFzaXNfb3ZlcnJpZGUpKTsN
CisNCiAJaWYgKHFpYl9jb21wYXRfZGRyX25lZ290aWF0ZSkgew0KIAkJcHBkLT5jcHNwZWMtPmli
ZGVsdGFpbnByb2cgPSAxOw0KIAkJcHBkLT5jcHNwZWMtPmlic3ltc25hcCA9IHJlYWRfNzMyMl9j
cmVnMzJfcG9ydChwcGQsDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L3FpYi9x
aWJfdWQuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9xaWIvcWliX3VkLmMNCmluZGV4IDgyODYw
OWYuLmMwZDkzZDQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl91
ZC5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl91ZC5jDQpAQCAtNTcsMTMg
KzU3LDIwIEBAIHN0YXRpYyB2b2lkIHFpYl91ZF9sb29wYmFjayhzdHJ1Y3QgcWliX3FwICpzcXAs
IHN0cnVjdCBxaWJfc3dxZSAqc3dxZSkNCiAJc3RydWN0IHFpYl9zZ2UgKnNnZTsNCiAJc3RydWN0
IGliX3djIHdjOw0KIAl1MzIgbGVuZ3RoOw0KKwllbnVtIGliX3FwX3R5cGUgc3FwdHlwZSwgZHFw
dHlwZTsNCiANCiAJcXAgPSBxaWJfbG9va3VwX3FwbihpYnAsIHN3cWUtPndyLndyLnVkLnJlbW90
ZV9xcG4pOw0KIAlpZiAoIXFwKSB7DQogCQlpYnAtPm5fcGt0X2Ryb3BzKys7DQogCQlyZXR1cm47
DQogCX0NCi0JaWYgKHFwLT5pYnFwLnFwX3R5cGUgIT0gc3FwLT5pYnFwLnFwX3R5cGUgfHwNCisN
CisJc3FwdHlwZSA9IHNxcC0+aWJxcC5xcF90eXBlID09IElCX1FQVF9HU0kgPw0KKwkJCUlCX1FQ
VF9VRCA6IHNxcC0+aWJxcC5xcF90eXBlOw0KKwlkcXB0eXBlID0gcXAtPmlicXAucXBfdHlwZSA9
PSBJQl9RUFRfR1NJID8NCisJCQlJQl9RUFRfVUQgOiBxcC0+aWJxcC5xcF90eXBlOw0KKw0KKwlp
ZiAoZHFwdHlwZSAhPSBzcXB0eXBlIHx8DQogCSAgICAhKGliX3FpYl9zdGF0ZV9vcHNbcXAtPnN0
YXRlXSAmIFFJQl9QUk9DRVNTX1JFQ1ZfT0spKSB7DQogCQlpYnAtPm5fcGt0X2Ryb3BzKys7DQog
CQlnb3RvIGRyb3A7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9pbnRlbC1pb21tdS5jIGIv
ZHJpdmVycy9pb21tdS9pbnRlbC1pb21tdS5jDQppbmRleCBiNGE0YWFmLi4xYTUxYjNkIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9pb21tdS9pbnRlbC1pb21tdS5jDQorKysgYi9kcml2ZXJzL2lvbW11
L2ludGVsLWlvbW11LmMNCkBAIC04ODQsNyArODg0LDcgQEAgc3RhdGljIHZvaWQgZG1hX3B0ZV9m
cmVlX2xldmVsKHN0cnVjdCBkbWFyX2RvbWFpbiAqZG9tYWluLCBpbnQgbGV2ZWwsDQogDQogCQkv
KiBJZiByYW5nZSBjb3ZlcnMgZW50aXJlIHBhZ2V0YWJsZSwgZnJlZSBpdCAqLw0KIAkJaWYgKCEo
c3RhcnRfcGZuID4gbGV2ZWxfcGZuIHx8DQotCQkgICAgICBsYXN0X3BmbiA8IGxldmVsX3BmbiAr
IGxldmVsX3NpemUobGV2ZWwpKSkgew0KKwkJICAgICAgbGFzdF9wZm4gPCBsZXZlbF9wZm4gKyBs
ZXZlbF9zaXplKGxldmVsKSAtIDEpKSB7DQogCQkJZG1hX2NsZWFyX3B0ZShwdGUpOw0KIAkJCWRv
bWFpbl9mbHVzaF9jYWNoZShkb21haW4sIHB0ZSwgc2l6ZW9mKCpwdGUpKTsNCiAJCQlmcmVlX3Bn
dGFibGVfcGFnZShsZXZlbF9wdGUpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvS2NvbmZpZyBi
L2RyaXZlcnMvbWQvS2NvbmZpZw0KaW5kZXggZmFhNDc0MS4uZTEwYjZiYiAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbWQvS2NvbmZpZw0KKysrIGIvZHJpdmVycy9tZC9LY29uZmlnDQpAQCAtMTg1LDgg
KzE4NSwxMiBAQCBjb25maWcgTURfRkFVTFRZDQogDQogCSAgSW4gdW5zdXJlLCBzYXkgTi4NCiAN
Citjb25maWcgQkxLX0RFVl9ETV9CVUlMVElODQorCWJvb2xlYW4NCisNCiBjb25maWcgQkxLX0RF
Vl9ETQ0KIAl0cmlzdGF0ZSAiRGV2aWNlIG1hcHBlciBzdXBwb3J0Ig0KKwlzZWxlY3QgQkxLX0RF
Vl9ETV9CVUlMVElODQogCS0tLWhlbHAtLS0NCiAJICBEZXZpY2UtbWFwcGVyIGlzIGEgbG93IGxl
dmVsIHZvbHVtZSBtYW5hZ2VyLiAgSXQgd29ya3MgYnkgYWxsb3dpbmcNCiAJICBwZW9wbGUgdG8g
c3BlY2lmeSBtYXBwaW5ncyBmb3IgcmFuZ2VzIG9mIGxvZ2ljYWwgc2VjdG9ycy4gIFZhcmlvdXMN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL01ha2VmaWxlIGIvZHJpdmVycy9tZC9NYWtlZmlsZQ0K
aW5kZXggMDQ2ODYwYy4uZjY3ZGVjMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvTWFrZWZpbGUN
CisrKyBiL2RyaXZlcnMvbWQvTWFrZWZpbGUNCkBAIC0yOCw2ICsyOCw3IEBAIG9iai0kKENPTkZJ
R19NRF9NVUxUSVBBVEgpCSs9IG11bHRpcGF0aC5vDQogb2JqLSQoQ09ORklHX01EX0ZBVUxUWSkJ
CSs9IGZhdWx0eS5vDQogb2JqLSQoQ09ORklHX0JMS19ERVZfTUQpCSs9IG1kLW1vZC5vDQogb2Jq
LSQoQ09ORklHX0JMS19ERVZfRE0pCSs9IGRtLW1vZC5vDQorb2JqLSQoQ09ORklHX0JMS19ERVZf
RE1fQlVJTFRJTikgKz0gZG0tYnVpbHRpbi5vDQogb2JqLSQoQ09ORklHX0RNX0JVRklPKQkJKz0g
ZG0tYnVmaW8ubw0KIG9iai0kKENPTkZJR19ETV9DUllQVCkJCSs9IGRtLWNyeXB0Lm8NCiBvYmot
JChDT05GSUdfRE1fREVMQVkpCQkrPSBkbS1kZWxheS5vDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZC9kbS1idWlsdGluLmMgYi9kcml2ZXJzL21kL2RtLWJ1aWx0aW4uYw0KbmV3IGZpbGUgbW9kZSAx
MDA2NDQNCmluZGV4IDAwMDAwMDAuLjhiODI3ODgNCi0tLSAvZGV2L251bGwNCisrKyBiL2RyaXZl
cnMvbWQvZG0tYnVpbHRpbi5jDQpAQCAtMCwwICsxLDQ5IEBADQorI2luY2x1ZGUgPGxpbnV4L2V4
cG9ydC5oPg0KKyNpbmNsdWRlICJkbS5oIg0KKw0KKy8qDQorICogVGhlIGtvYmplY3QgcmVsZWFz
ZSBtZXRob2QgbXVzdCBub3QgYmUgcGxhY2VkIGluIHRoZSBtb2R1bGUgaXRzZWxmLA0KKyAqIG90
aGVyd2lzZSB3ZSBhcmUgc3ViamVjdCB0byBtb2R1bGUgdW5sb2FkIHJhY2VzLg0KKyAqDQorICog
VGhlIHJlbGVhc2UgbWV0aG9kIGlzIGNhbGxlZCB3aGVuIHRoZSBsYXN0IHJlZmVyZW5jZSB0byB0
aGUga29iamVjdCBpcw0KKyAqIGRyb3BwZWQuIEl0IG1heSBiZSBjYWxsZWQgYnkgYW55IG90aGVy
IGtlcm5lbCBjb2RlIHRoYXQgZHJvcHMgdGhlIGxhc3QNCisgKiByZWZlcmVuY2UuDQorICoNCisg
KiBUaGUgcmVsZWFzZSBtZXRob2Qgc3VmZmVycyBmcm9tIG1vZHVsZSB1bmxvYWQgcmFjZS4gV2Ug
bWF5IHByZXZlbnQgdGhlDQorICogbW9kdWxlIGZyb20gYmVpbmcgdW5sb2FkZWQgYXQgdGhlIHN0
YXJ0IG9mIHRoZSByZWxlYXNlIG1ldGhvZCAodXNpbmcNCisgKiBpbmNyZWFzZWQgbW9kdWxlIHJl
ZmVyZW5jZSBjb3VudCBvciBzeW5jaHJvbml6aW5nIGFnYWluc3QgdGhlIHJlbGVhc2UNCisgKiBt
ZXRob2QpLCBob3dldmVyIHRoZXJlIGlzIG5vIHdheSB0byBwcmV2ZW50IHRoZSBtb2R1bGUgZnJv
bSBiZWluZw0KKyAqIHVubG9hZGVkIGF0IHRoZSBlbmQgb2YgdGhlIHJlbGVhc2UgbWV0aG9kLg0K
KyAqDQorICogSWYgdGhpcyBjb2RlIHdlcmUgcGxhY2VkIGluIHRoZSBkbSBtb2R1bGUsIHRoZSBm
b2xsb3dpbmcgcmFjZSBtYXkNCisgKiBoYXBwZW46DQorICogIDEuIFNvbWUgb3RoZXIgcHJvY2Vz
cyB0YWtlcyBhIHJlZmVyZW5jZSB0byBkbSBrb2JqZWN0DQorICogIDIuIFRoZSB1c2VyIGlzc3Vl
cyBpb2N0bCBmdW5jdGlvbiB0byB1bmxvYWQgdGhlIGRtIGRldmljZQ0KKyAqICAzLiBkbV9zeXNm
c19leGl0IGNhbGxzIGtvYmplY3RfcHV0LCBob3dldmVyIHRoZSBvYmplY3QgaXMgbm90IHJlbGVh
c2VkDQorICogICAgIGJlY2F1c2Ugb2YgdGhlIG90aGVyIHJlZmVyZW5jZSB0YWtlbiBhdCBzdGVw
IDENCisgKiAgNC4gZG1fc3lzZnNfZXhpdCB3YWl0cyBvbiB0aGUgY29tcGxldGlvbg0KKyAqICA1
LiBUaGUgb3RoZXIgcHJvY2VzcyB0aGF0IHRvb2sgdGhlIHJlZmVyZW5jZSBpbiBzdGVwIDEgZHJv
cHMgaXQsDQorICogICAgIGRtX2tvYmplY3RfcmVsZWFzZSBpcyBjYWxsZWQgZnJvbSB0aGlzIHBy
b2Nlc3MNCisgKiAgNi4gZG1fa29iamVjdF9yZWxlYXNlIGNhbGxzIGNvbXBsZXRlKCkNCisgKiAg
Ny4gYSByZXNjaGVkdWxlIGhhcHBlbnMgYmVmb3JlIGRtX2tvYmplY3RfcmVsZWFzZSByZXR1cm5z
DQorICogIDguIGRtX3N5c2ZzX2V4aXQgY29udGludWVzLCB0aGUgZG0gZGV2aWNlIGlzIHVubG9h
ZGVkLCBtb2R1bGUgcmVmZXJlbmNlDQorICogICAgIGNvdW50IGlzIGRlY3JlbWVudGVkDQorICog
IDkuIFRoZSB1c2VyIHVubG9hZHMgdGhlIGRtIG1vZHVsZQ0KKyAqIDEwLiBUaGUgb3RoZXIgcHJv
Y2VzcyB0aGF0IHdhcyByZXNjaGVkdWxlZCBpbiBzdGVwIDcgY29udGludWVzIHRvIHJ1biwNCisg
KiAgICAgaXQgaXMgbm93IGV4ZWN1dGluZyBjb2RlIGluIHVubG9hZGVkIG1vZHVsZSwgc28gaXQg
Y3Jhc2hlcw0KKyAqDQorICogTm90ZSB0aGF0IGlmIHRoZSBwcm9jZXNzIHRoYXQgdGFrZXMgdGhl
IGZvcmVpZ24gcmVmZXJlbmNlIHRvIGRtIGtvYmplY3QNCisgKiBoYXMgYSBsb3cgcHJpb3JpdHkg
YW5kIHRoZSBzeXN0ZW0gaXMgc3VmZmljaWVudGx5IGxvYWRlZCB3aXRoDQorICogaGlnaGVyLXBy
aW9yaXR5IHByb2Nlc3NlcyB0aGF0IHByZXZlbnQgdGhlIGxvdy1wcmlvcml0eSBwcm9jZXNzIGZy
b20NCisgKiBiZWluZyBzY2hlZHVsZWQgbG9uZyBlbm91Z2gsIHRoaXMgYnVnIG1heSByZWFsbHkg
aGFwcGVuLg0KKyAqDQorICogSW4gb3JkZXIgdG8gZml4IHRoaXMgbW9kdWxlIHVubG9hZCByYWNl
LCB3ZSBwbGFjZSB0aGUgcmVsZWFzZSBtZXRob2QNCisgKiBpbnRvIGEgaGVscGVyIGNvZGUgdGhh
dCBpcyBjb21waWxlZCBkaXJlY3RseSBpbnRvIHRoZSBrZXJuZWwuDQorICovDQorDQordm9pZCBk
bV9rb2JqZWN0X3JlbGVhc2Uoc3RydWN0IGtvYmplY3QgKmtvYmopDQorew0KKwljb21wbGV0ZShk
bV9nZXRfY29tcGxldGlvbl9mcm9tX2tvYmplY3Qoa29iaikpOw0KK30NCisNCitFWFBPUlRfU1lN
Qk9MKGRtX2tvYmplY3RfcmVsZWFzZSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1zeXNm
cy5jIGIvZHJpdmVycy9tZC9kbS1zeXNmcy5jDQppbmRleCA4NGQyYjkxLi5jNjJjNWFiIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9tZC9kbS1zeXNmcy5jDQorKysgYi9kcml2ZXJzL21kL2RtLXN5c2Zz
LmMNCkBAIC04Niw2ICs4Niw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc3lzZnNfb3BzIGRtX3N5
c2ZzX29wcyA9IHsNCiBzdGF0aWMgc3RydWN0IGtvYmpfdHlwZSBkbV9rdHlwZSA9IHsNCiAJLnN5
c2ZzX29wcwk9ICZkbV9zeXNmc19vcHMsDQogCS5kZWZhdWx0X2F0dHJzCT0gZG1fYXR0cnMsDQor
CS5yZWxlYXNlCT0gZG1fa29iamVjdF9yZWxlYXNlLA0KIH07DQogDQogLyoNCkBAIC0xMDQsNSAr
MTA1LDcgQEAgaW50IGRtX3N5c2ZzX2luaXQoc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kKQ0KICAq
Lw0KIHZvaWQgZG1fc3lzZnNfZXhpdChzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQpDQogew0KLQlr
b2JqZWN0X3B1dChkbV9rb2JqZWN0KG1kKSk7DQorCXN0cnVjdCBrb2JqZWN0ICprb2JqID0gZG1f
a29iamVjdChtZCk7DQorCWtvYmplY3RfcHV0KGtvYmopOw0KKwl3YWl0X2Zvcl9jb21wbGV0aW9u
KGRtX2dldF9jb21wbGV0aW9uX2Zyb21fa29iamVjdChrb2JqKSk7DQogfQ0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbWQvZG0uYyBiL2RyaXZlcnMvbWQvZG0uYw0KaW5kZXggODk1MzYzMC4uN2VhZDA2
NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvZG0uYw0KKysrIGIvZHJpdmVycy9tZC9kbS5jDQpA
QCAtMTkyLDggKzE5Miw4IEBAIHN0cnVjdCBtYXBwZWRfZGV2aWNlIHsNCiAJLyogZm9yY2VkIGdl
b21ldHJ5IHNldHRpbmdzICovDQogCXN0cnVjdCBoZF9nZW9tZXRyeSBnZW9tZXRyeTsNCiANCi0J
Lyogc3lzZnMgaGFuZGxlICovDQotCXN0cnVjdCBrb2JqZWN0IGtvYmo7DQorCS8qIGtvYmplY3Qg
YW5kIGNvbXBsZXRpb24gKi8NCisJc3RydWN0IGRtX2tvYmplY3RfaG9sZGVyIGtvYmpfaG9sZGVy
Ow0KIA0KIAkvKiB6ZXJvLWxlbmd0aCBmbHVzaCB0aGF0IHdpbGwgYmUgY2xvbmVkIGFuZCBzdWJt
aXR0ZWQgdG8gdGFyZ2V0cyAqLw0KIAlzdHJ1Y3QgYmlvIGZsdXNoX2JpbzsNCkBAIC0xODkxLDYg
KzE4OTEsNyBAQCBzdGF0aWMgc3RydWN0IG1hcHBlZF9kZXZpY2UgKmFsbG9jX2RldihpbnQgbWlu
b3IpDQogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJm1kLT53YWl0KTsNCiAJSU5JVF9XT1JLKCZtZC0+
d29yaywgZG1fd3Ffd29yayk7DQogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJm1kLT5ldmVudHEpOw0K
Kwlpbml0X2NvbXBsZXRpb24oJm1kLT5rb2JqX2hvbGRlci5jb21wbGV0aW9uKTsNCiANCiAJbWQt
PmRpc2stPm1ham9yID0gX21ham9yOw0KIAltZC0+ZGlzay0+Zmlyc3RfbWlub3IgPSBtaW5vcjsN
CkBAIC0yNjgyLDcgKzI2ODMsNyBAQCBzdHJ1Y3QgZ2VuZGlzayAqZG1fZGlzayhzdHJ1Y3QgbWFw
cGVkX2RldmljZSAqbWQpDQogDQogc3RydWN0IGtvYmplY3QgKmRtX2tvYmplY3Qoc3RydWN0IG1h
cHBlZF9kZXZpY2UgKm1kKQ0KIHsNCi0JcmV0dXJuICZtZC0+a29iajsNCisJcmV0dXJuICZtZC0+
a29ial9ob2xkZXIua29iajsNCiB9DQogDQogLyoNCkBAIC0yNjkzLDkgKzI2OTQsNyBAQCBzdHJ1
Y3QgbWFwcGVkX2RldmljZSAqZG1fZ2V0X2Zyb21fa29iamVjdChzdHJ1Y3Qga29iamVjdCAqa29i
aikNCiB7DQogCXN0cnVjdCBtYXBwZWRfZGV2aWNlICptZDsNCiANCi0JbWQgPSBjb250YWluZXJf
b2Yoa29iaiwgc3RydWN0IG1hcHBlZF9kZXZpY2UsIGtvYmopOw0KLQlpZiAoJm1kLT5rb2JqICE9
IGtvYmopDQotCQlyZXR1cm4gTlVMTDsNCisJbWQgPSBjb250YWluZXJfb2Yoa29iaiwgc3RydWN0
IG1hcHBlZF9kZXZpY2UsIGtvYmpfaG9sZGVyLmtvYmopOw0KIA0KIAlpZiAodGVzdF9iaXQoRE1G
X0ZSRUVJTkcsICZtZC0+ZmxhZ3MpIHx8DQogCSAgICBkbV9kZWxldGluZ19tZChtZCkpDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9tZC9kbS5oIGIvZHJpdmVycy9tZC9kbS5oDQppbmRleCBiN2RhY2Q1
Li45ZGI4MGM5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9kbS5oDQorKysgYi9kcml2ZXJzL21k
L2RtLmgNCkBAIC0xNSw2ICsxNSw4IEBADQogI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCiAjaW5j
bHVkZSA8bGludXgvYmxrZGV2Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2hkcmVnLmg+DQorI2luY2x1
ZGUgPGxpbnV4L2NvbXBsZXRpb24uaD4NCisjaW5jbHVkZSA8bGludXgva29iamVjdC5oPg0KIA0K
IC8qDQogICogU3VzcGVuZCBmZWF0dXJlIGZsYWdzDQpAQCAtMTE5LDEyICsxMjEsMjcgQEAgdm9p
ZCBkbV9pbnRlcmZhY2VfZXhpdCh2b2lkKTsNCiAvKg0KICAqIHN5c2ZzIGludGVyZmFjZQ0KICAq
Lw0KK3N0cnVjdCBkbV9rb2JqZWN0X2hvbGRlciB7DQorCXN0cnVjdCBrb2JqZWN0IGtvYmo7DQor
CXN0cnVjdCBjb21wbGV0aW9uIGNvbXBsZXRpb247DQorfTsNCisNCitzdGF0aWMgaW5saW5lIHN0
cnVjdCBjb21wbGV0aW9uICpkbV9nZXRfY29tcGxldGlvbl9mcm9tX2tvYmplY3Qoc3RydWN0IGtv
YmplY3QgKmtvYmopDQorew0KKwlyZXR1cm4gJmNvbnRhaW5lcl9vZihrb2JqLCBzdHJ1Y3QgZG1f
a29iamVjdF9ob2xkZXIsIGtvYmopLT5jb21wbGV0aW9uOw0KK30NCisNCiBpbnQgZG1fc3lzZnNf
aW5pdChzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQpOw0KIHZvaWQgZG1fc3lzZnNfZXhpdChzdHJ1
Y3QgbWFwcGVkX2RldmljZSAqbWQpOw0KIHN0cnVjdCBrb2JqZWN0ICpkbV9rb2JqZWN0KHN0cnVj
dCBtYXBwZWRfZGV2aWNlICptZCk7DQogc3RydWN0IG1hcHBlZF9kZXZpY2UgKmRtX2dldF9mcm9t
X2tvYmplY3Qoc3RydWN0IGtvYmplY3QgKmtvYmopOw0KIA0KIC8qDQorICogVGhlIGtvYmplY3Qg
aGVscGVyDQorICovDQordm9pZCBkbV9rb2JqZWN0X3JlbGVhc2Uoc3RydWN0IGtvYmplY3QgKmtv
YmopOw0KKw0KKy8qDQogICogVGFyZ2V0cyBmb3IgbGluZWFyIGFuZCBzdHJpcGVkIG1hcHBpbmdz
DQogICovDQogaW50IGRtX2xpbmVhcl9pbml0KHZvaWQpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bWQvcGVyc2lzdGVudC1kYXRhL2RtLXNwYWNlLW1hcC1jb21tb24uYyBiL2RyaXZlcnMvbWQvcGVy
c2lzdGVudC1kYXRhL2RtLXNwYWNlLW1hcC1jb21tb24uYw0KaW5kZXggZGYyNDk0Yy4uOGM1Yjgy
NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvcGVyc2lzdGVudC1kYXRhL2RtLXNwYWNlLW1hcC1j
b21tb24uYw0KKysrIGIvZHJpdmVycy9tZC9wZXJzaXN0ZW50LWRhdGEvZG0tc3BhY2UtbWFwLWNv
bW1vbi5jDQpAQCAtMjQ0LDYgKzI0NCwxMCBAQCBpbnQgc21fbGxfZXh0ZW5kKHN0cnVjdCBsbF9k
aXNrICpsbCwgZG1fYmxvY2tfdCBleHRyYV9ibG9ja3MpDQogCQlyZXR1cm4gLUVJTlZBTDsNCiAJ
fQ0KIA0KKwkvKg0KKwkgKiBXZSBuZWVkIHRvIHNldCB0aGlzIGJlZm9yZSB0aGUgZG1fdG1fbmV3
X2Jsb2NrKCkgY2FsbCBiZWxvdy4NCisJICovDQorCWxsLT5ucl9ibG9ja3MgPSBucl9ibG9ja3M7
DQogCWZvciAoaSA9IG9sZF9ibG9ja3M7IGkgPCBibG9ja3M7IGkrKykgew0KIAkJc3RydWN0IGRt
X2Jsb2NrICpiOw0KIAkJc3RydWN0IGRpc2tfaW5kZXhfZW50cnkgaWR4Ow0KQEAgLTI1MSw2ICsy
NTUsNyBAQCBpbnQgc21fbGxfZXh0ZW5kKHN0cnVjdCBsbF9kaXNrICpsbCwgZG1fYmxvY2tfdCBl
eHRyYV9ibG9ja3MpDQogCQlyID0gZG1fdG1fbmV3X2Jsb2NrKGxsLT50bSwgJmRtX3NtX2JpdG1h
cF92YWxpZGF0b3IsICZiKTsNCiAJCWlmIChyIDwgMCkNCiAJCQlyZXR1cm4gcjsNCisNCiAJCWlk
eC5ibG9ja25yID0gY3B1X3RvX2xlNjQoZG1fYmxvY2tfbG9jYXRpb24oYikpOw0KIA0KIAkJciA9
IGRtX3RtX3VubG9jayhsbC0+dG0sIGIpOw0KQEAgLTI2NSw3ICsyNzAsNiBAQCBpbnQgc21fbGxf
ZXh0ZW5kKHN0cnVjdCBsbF9kaXNrICpsbCwgZG1fYmxvY2tfdCBleHRyYV9ibG9ja3MpDQogCQkJ
cmV0dXJuIHI7DQogCX0NCiANCi0JbGwtPm5yX2Jsb2NrcyA9IG5yX2Jsb2NrczsNCiAJcmV0dXJu
IDA7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDUuYyBiL2RyaXZlcnMvbWQv
cmFpZDUuYw0KaW5kZXggZmI2NzgzMy4uN2M5NjNjNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQv
cmFpZDUuYw0KKysrIGIvZHJpdmVycy9tZC9yYWlkNS5jDQpAQCAtMTY5Myw2ICsxNjkzLDcgQEAg
c3RhdGljIHZvaWQgcmFpZDVfZW5kX3dyaXRlX3JlcXVlc3Qoc3RydWN0IGJpbyAqYmksIGludCBl
cnJvcikNCiAJfQ0KIA0KIAlpZiAoIXVwdG9kYXRlKSB7DQorCQlzZXRfYml0KFNUUklQRV9ERUdS
QURFRCwgJnNoLT5zdGF0ZSk7DQogCQlzZXRfYml0KFdyaXRlRXJyb3JTZWVuLCAmY29uZi0+ZGlz
a3NbaV0ucmRldi0+ZmxhZ3MpOw0KIAkJc2V0X2JpdChSNV9Xcml0ZUVycm9yLCAmc2gtPmRldltp
XS5mbGFncyk7DQogCX0gZWxzZSBpZiAoaXNfYmFkYmxvY2soY29uZi0+ZGlza3NbaV0ucmRldiwg
c2gtPnNlY3RvciwgU1RSSVBFX1NFQ1RPUlMsDQpAQCAtNDQ0OSwyMyArNDQ1MCw0MyBAQCByYWlk
NV9zaXplKHN0cnVjdCBtZGRldiAqbWRkZXYsIHNlY3Rvcl90IHNlY3RvcnMsIGludCByYWlkX2Rp
c2tzKQ0KIAlyZXR1cm4gc2VjdG9ycyAqIChyYWlkX2Rpc2tzIC0gY29uZi0+bWF4X2RlZ3JhZGVk
KTsNCiB9DQogDQorc3RhdGljIHZvaWQgZnJlZV9zY3JhdGNoX2J1ZmZlcihzdHJ1Y3QgcjVjb25m
ICpjb25mLCBzdHJ1Y3QgcmFpZDVfcGVyY3B1ICpwZXJjcHUpDQorew0KKwlzYWZlX3B1dF9wYWdl
KHBlcmNwdS0+c3BhcmVfcGFnZSk7DQorCWtmcmVlKHBlcmNwdS0+c2NyaWJibGUpOw0KKwlwZXJj
cHUtPnNwYXJlX3BhZ2UgPSBOVUxMOw0KKwlwZXJjcHUtPnNjcmliYmxlID0gTlVMTDsNCit9DQor
DQorc3RhdGljIGludCBhbGxvY19zY3JhdGNoX2J1ZmZlcihzdHJ1Y3QgcjVjb25mICpjb25mLCBz
dHJ1Y3QgcmFpZDVfcGVyY3B1ICpwZXJjcHUpDQorew0KKwlpZiAoY29uZi0+bGV2ZWwgPT0gNiAm
JiAhcGVyY3B1LT5zcGFyZV9wYWdlKQ0KKwkJcGVyY3B1LT5zcGFyZV9wYWdlID0gYWxsb2NfcGFn
ZShHRlBfS0VSTkVMKTsNCisJaWYgKCFwZXJjcHUtPnNjcmliYmxlKQ0KKwkJcGVyY3B1LT5zY3Jp
YmJsZSA9IGttYWxsb2MoY29uZi0+c2NyaWJibGVfbGVuLCBHRlBfS0VSTkVMKTsNCisNCisJaWYg
KCFwZXJjcHUtPnNjcmliYmxlIHx8IChjb25mLT5sZXZlbCA9PSA2ICYmICFwZXJjcHUtPnNwYXJl
X3BhZ2UpKSB7DQorCQlmcmVlX3NjcmF0Y2hfYnVmZmVyKGNvbmYsIHBlcmNwdSk7DQorCQlyZXR1
cm4gLUVOT01FTTsNCisJfQ0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQogc3RhdGljIHZvaWQgcmFp
ZDVfZnJlZV9wZXJjcHUoc3RydWN0IHI1Y29uZiAqY29uZikNCiB7DQotCXN0cnVjdCByYWlkNV9w
ZXJjcHUgKnBlcmNwdTsNCiAJdW5zaWduZWQgbG9uZyBjcHU7DQogDQogCWlmICghY29uZi0+cGVy
Y3B1KQ0KIAkJcmV0dXJuOw0KIA0KLQlnZXRfb25saW5lX2NwdXMoKTsNCi0JZm9yX2VhY2hfcG9z
c2libGVfY3B1KGNwdSkgew0KLQkJcGVyY3B1ID0gcGVyX2NwdV9wdHIoY29uZi0+cGVyY3B1LCBj
cHUpOw0KLQkJc2FmZV9wdXRfcGFnZShwZXJjcHUtPnNwYXJlX3BhZ2UpOw0KLQkJa2ZyZWUocGVy
Y3B1LT5zY3JpYmJsZSk7DQotCX0NCiAjaWZkZWYgQ09ORklHX0hPVFBMVUdfQ1BVDQogCXVucmVn
aXN0ZXJfY3B1X25vdGlmaWVyKCZjb25mLT5jcHVfbm90aWZ5KTsNCiAjZW5kaWYNCisNCisJZ2V0
X29ubGluZV9jcHVzKCk7DQorCWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpDQorCQlmcmVlX3Nj
cmF0Y2hfYnVmZmVyKGNvbmYsIHBlcl9jcHVfcHRyKGNvbmYtPnBlcmNwdSwgY3B1KSk7DQogCXB1
dF9vbmxpbmVfY3B1cygpOw0KIA0KIAlmcmVlX3BlcmNwdShjb25mLT5wZXJjcHUpOw0KQEAgLTQ0
OTEsMTUgKzQ1MTIsNyBAQCBzdGF0aWMgaW50IHJhaWQ0NTZfY3B1X25vdGlmeShzdHJ1Y3Qgbm90
aWZpZXJfYmxvY2sgKm5mYiwgdW5zaWduZWQgbG9uZyBhY3Rpb24sDQogCXN3aXRjaCAoYWN0aW9u
KSB7DQogCWNhc2UgQ1BVX1VQX1BSRVBBUkU6DQogCWNhc2UgQ1BVX1VQX1BSRVBBUkVfRlJPWkVO
Og0KLQkJaWYgKGNvbmYtPmxldmVsID09IDYgJiYgIXBlcmNwdS0+c3BhcmVfcGFnZSkNCi0JCQlw
ZXJjcHUtPnNwYXJlX3BhZ2UgPSBhbGxvY19wYWdlKEdGUF9LRVJORUwpOw0KLQkJaWYgKCFwZXJj
cHUtPnNjcmliYmxlKQ0KLQkJCXBlcmNwdS0+c2NyaWJibGUgPSBrbWFsbG9jKGNvbmYtPnNjcmli
YmxlX2xlbiwgR0ZQX0tFUk5FTCk7DQotDQotCQlpZiAoIXBlcmNwdS0+c2NyaWJibGUgfHwNCi0J
CSAgICAoY29uZi0+bGV2ZWwgPT0gNiAmJiAhcGVyY3B1LT5zcGFyZV9wYWdlKSkgew0KLQkJCXNh
ZmVfcHV0X3BhZ2UocGVyY3B1LT5zcGFyZV9wYWdlKTsNCi0JCQlrZnJlZShwZXJjcHUtPnNjcmli
YmxlKTsNCisJCWlmIChhbGxvY19zY3JhdGNoX2J1ZmZlcihjb25mLCBwZXJjcHUpKSB7DQogCQkJ
cHJfZXJyKCIlczogZmFpbGVkIG1lbW9yeSBhbGxvY2F0aW9uIGZvciBjcHUlbGRcbiIsDQogCQkJ
ICAgICAgIF9fZnVuY19fLCBjcHUpOw0KIAkJCXJldHVybiBub3RpZmllcl9mcm9tX2Vycm5vKC1F
Tk9NRU0pOw0KQEAgLTQ1MDcsMTAgKzQ1MjAsNyBAQCBzdGF0aWMgaW50IHJhaWQ0NTZfY3B1X25v
dGlmeShzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5mYiwgdW5zaWduZWQgbG9uZyBhY3Rpb24sDQog
CQlicmVhazsNCiAJY2FzZSBDUFVfREVBRDoNCiAJY2FzZSBDUFVfREVBRF9GUk9aRU46DQotCQlz
YWZlX3B1dF9wYWdlKHBlcmNwdS0+c3BhcmVfcGFnZSk7DQotCQlrZnJlZShwZXJjcHUtPnNjcmli
YmxlKTsNCi0JCXBlcmNwdS0+c3BhcmVfcGFnZSA9IE5VTEw7DQotCQlwZXJjcHUtPnNjcmliYmxl
ID0gTlVMTDsNCisJCWZyZWVfc2NyYXRjaF9idWZmZXIoY29uZiwgcGVyX2NwdV9wdHIoY29uZi0+
cGVyY3B1LCBjcHUpKTsNCiAJCWJyZWFrOw0KIAlkZWZhdWx0Og0KIAkJYnJlYWs7DQpAQCAtNDUy
Miw0MCArNDUzMiwyOSBAQCBzdGF0aWMgaW50IHJhaWQ0NTZfY3B1X25vdGlmeShzdHJ1Y3Qgbm90
aWZpZXJfYmxvY2sgKm5mYiwgdW5zaWduZWQgbG9uZyBhY3Rpb24sDQogc3RhdGljIGludCByYWlk
NV9hbGxvY19wZXJjcHUoc3RydWN0IHI1Y29uZiAqY29uZikNCiB7DQogCXVuc2lnbmVkIGxvbmcg
Y3B1Ow0KLQlzdHJ1Y3QgcGFnZSAqc3BhcmVfcGFnZTsNCi0Jc3RydWN0IHJhaWQ1X3BlcmNwdSBf
X3BlcmNwdSAqYWxsY3B1czsNCi0Jdm9pZCAqc2NyaWJibGU7DQotCWludCBlcnI7DQorCWludCBl
cnIgPSAwOw0KIA0KLQlhbGxjcHVzID0gYWxsb2NfcGVyY3B1KHN0cnVjdCByYWlkNV9wZXJjcHUp
Ow0KLQlpZiAoIWFsbGNwdXMpDQorCWNvbmYtPnBlcmNwdSA9IGFsbG9jX3BlcmNwdShzdHJ1Y3Qg
cmFpZDVfcGVyY3B1KTsNCisJaWYgKCFjb25mLT5wZXJjcHUpDQogCQlyZXR1cm4gLUVOT01FTTsN
Ci0JY29uZi0+cGVyY3B1ID0gYWxsY3B1czsNCisNCisjaWZkZWYgQ09ORklHX0hPVFBMVUdfQ1BV
DQorCWNvbmYtPmNwdV9ub3RpZnkubm90aWZpZXJfY2FsbCA9IHJhaWQ0NTZfY3B1X25vdGlmeTsN
CisJY29uZi0+Y3B1X25vdGlmeS5wcmlvcml0eSA9IDA7DQorCWVyciA9IHJlZ2lzdGVyX2NwdV9u
b3RpZmllcigmY29uZi0+Y3B1X25vdGlmeSk7DQorCWlmIChlcnIpDQorCQlyZXR1cm4gZXJyOw0K
KyNlbmRpZg0KIA0KIAlnZXRfb25saW5lX2NwdXMoKTsNCi0JZXJyID0gMDsNCiAJZm9yX2VhY2hf
cHJlc2VudF9jcHUoY3B1KSB7DQotCQlpZiAoY29uZi0+bGV2ZWwgPT0gNikgew0KLQkJCXNwYXJl
X3BhZ2UgPSBhbGxvY19wYWdlKEdGUF9LRVJORUwpOw0KLQkJCWlmICghc3BhcmVfcGFnZSkgew0K
LQkJCQllcnIgPSAtRU5PTUVNOw0KLQkJCQlicmVhazsNCi0JCQl9DQotCQkJcGVyX2NwdV9wdHIo
Y29uZi0+cGVyY3B1LCBjcHUpLT5zcGFyZV9wYWdlID0gc3BhcmVfcGFnZTsNCi0JCX0NCi0JCXNj
cmliYmxlID0ga21hbGxvYyhjb25mLT5zY3JpYmJsZV9sZW4sIEdGUF9LRVJORUwpOw0KLQkJaWYg
KCFzY3JpYmJsZSkgew0KLQkJCWVyciA9IC1FTk9NRU07DQorCQllcnIgPSBhbGxvY19zY3JhdGNo
X2J1ZmZlcihjb25mLCBwZXJfY3B1X3B0cihjb25mLT5wZXJjcHUsIGNwdSkpOw0KKwkJaWYgKGVy
cikgew0KKwkJCXByX2VycigiJXM6IGZhaWxlZCBtZW1vcnkgYWxsb2NhdGlvbiBmb3IgY3B1JWxk
XG4iLA0KKwkJCSAgICAgICBfX2Z1bmNfXywgY3B1KTsNCiAJCQlicmVhazsNCiAJCX0NCi0JCXBl
cl9jcHVfcHRyKGNvbmYtPnBlcmNwdSwgY3B1KS0+c2NyaWJibGUgPSBzY3JpYmJsZTsNCiAJfQ0K
LSNpZmRlZiBDT05GSUdfSE9UUExVR19DUFUNCi0JY29uZi0+Y3B1X25vdGlmeS5ub3RpZmllcl9j
YWxsID0gcmFpZDQ1Nl9jcHVfbm90aWZ5Ow0KLQljb25mLT5jcHVfbm90aWZ5LnByaW9yaXR5ID0g
MDsNCi0JaWYgKGVyciA9PSAwKQ0KLQkJZXJyID0gcmVnaXN0ZXJfY3B1X25vdGlmaWVyKCZjb25m
LT5jcHVfbm90aWZ5KTsNCi0jZW5kaWYNCiAJcHV0X29ubGluZV9jcHVzKCk7DQogDQogCXJldHVy
biBlcnI7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9teGwxMTFzZi10
dW5lci5oIGIvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9teGwxMTFzZi10dW5lci5oDQppbmRl
eCBmZjMzMzk2Li4xMGI5M2M0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVz
Yi9teGwxMTFzZi10dW5lci5oDQorKysgYi9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL214bDEx
MXNmLXR1bmVyLmgNCkBAIC02OSw3ICs2OSw3IEBAIHN0cnVjdCBkdmJfZnJvbnRlbmQgKm14bDEx
MXNmX3R1bmVyX2F0dGFjaChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSwNCiAjZWxzZQ0KIHN0YXRp
YyBpbmxpbmUNCiBzdHJ1Y3QgZHZiX2Zyb250ZW5kICpteGwxMTFzZl90dW5lcl9hdHRhY2goc3Ry
dWN0IGR2Yl9mcm9udGVuZCAqZmUsDQotCQkJCQkgICBzdHJ1Y3QgbXhsMTExc2Zfc3RhdGUgKm14
bF9zdGF0ZQ0KKwkJCQkJICAgc3RydWN0IG14bDExMXNmX3N0YXRlICpteGxfc3RhdGUsDQogCQkJ
CQkgICBzdHJ1Y3QgbXhsMTExc2ZfdHVuZXJfY29uZmlnICpjZmcpDQogew0KIAlwcmludGsoS0VS
Tl9XQVJOSU5HICIlczogZHJpdmVyIGRpc2FibGVkIGJ5IEtjb25maWdcbiIsIF9fZnVuY19fKTsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvZGliODAwMC5jIGIvZHJp
dmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL2RpYjgwMDAuYw0KaW5kZXggZmUyODRkNS4uYTU0MmRi
MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9kaWI4MDAwLmMNCisr
KyBiL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9kaWI4MDAwLmMNCkBAIC0xMTQsMTUgKzEx
NCwxMCBAQCBzdGF0aWMgdTE2IGRpYjgwMDBfaTJjX3JlYWQxNihzdHJ1Y3QgaTJjX2RldmljZSAq
aTJjLCB1MTYgcmVnKQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCi1zdGF0aWMgdTE2IGRpYjgwMDBf
cmVhZF93b3JkKHN0cnVjdCBkaWI4MDAwX3N0YXRlICpzdGF0ZSwgdTE2IHJlZykNCitzdGF0aWMg
dTE2IF9fZGliODAwMF9yZWFkX3dvcmQoc3RydWN0IGRpYjgwMDBfc3RhdGUgKnN0YXRlLCB1MTYg
cmVnKQ0KIHsNCiAJdTE2IHJldDsNCiANCi0JaWYgKG11dGV4X2xvY2tfaW50ZXJydXB0aWJsZSgm
c3RhdGUtPmkyY19idWZmZXJfbG9jaykgPCAwKSB7DQotCQlkcHJpbnRrKCJjb3VsZCBub3QgYWNx
dWlyZSBsb2NrIik7DQotCQlyZXR1cm4gMDsNCi0JfQ0KLQ0KIAlzdGF0ZS0+aTJjX3dyaXRlX2J1
ZmZlclswXSA9IHJlZyA+PiA4Ow0KIAlzdGF0ZS0+aTJjX3dyaXRlX2J1ZmZlclsxXSA9IHJlZyAm
IDB4ZmY7DQogDQpAQCAtMTQwLDYgKzEzNSwyMSBAQCBzdGF0aWMgdTE2IGRpYjgwMDBfcmVhZF93
b3JkKHN0cnVjdCBkaWI4MDAwX3N0YXRlICpzdGF0ZSwgdTE2IHJlZykNCiAJCWRwcmludGsoImky
YyByZWFkIGVycm9yIG9uICVkIiwgcmVnKTsNCiANCiAJcmV0ID0gKHN0YXRlLT5pMmNfcmVhZF9i
dWZmZXJbMF0gPDwgOCkgfCBzdGF0ZS0+aTJjX3JlYWRfYnVmZmVyWzFdOw0KKw0KKwlyZXR1cm4g
cmV0Ow0KK30NCisNCitzdGF0aWMgdTE2IGRpYjgwMDBfcmVhZF93b3JkKHN0cnVjdCBkaWI4MDAw
X3N0YXRlICpzdGF0ZSwgdTE2IHJlZykNCit7DQorCXUxNiByZXQ7DQorDQorCWlmIChtdXRleF9s
b2NrX2ludGVycnVwdGlibGUoJnN0YXRlLT5pMmNfYnVmZmVyX2xvY2spIDwgMCkgew0KKwkJZHBy
aW50aygiY291bGQgbm90IGFjcXVpcmUgbG9jayIpOw0KKwkJcmV0dXJuIDA7DQorCX0NCisNCisJ
cmV0ID0gX19kaWI4MDAwX3JlYWRfd29yZChzdGF0ZSwgcmVnKTsNCisNCiAJbXV0ZXhfdW5sb2Nr
KCZzdGF0ZS0+aTJjX2J1ZmZlcl9sb2NrKTsNCiANCiAJcmV0dXJuIHJldDsNCkBAIC0xNDksOCAr
MTU5LDE1IEBAIHN0YXRpYyB1MzIgZGliODAwMF9yZWFkMzIoc3RydWN0IGRpYjgwMDBfc3RhdGUg
KnN0YXRlLCB1MTYgcmVnKQ0KIHsNCiAJdTE2IHJ3WzJdOw0KIA0KLQlyd1swXSA9IGRpYjgwMDBf
cmVhZF93b3JkKHN0YXRlLCByZWcgKyAwKTsNCi0JcndbMV0gPSBkaWI4MDAwX3JlYWRfd29yZChz
dGF0ZSwgcmVnICsgMSk7DQorCWlmIChtdXRleF9sb2NrX2ludGVycnVwdGlibGUoJnN0YXRlLT5p
MmNfYnVmZmVyX2xvY2spIDwgMCkgew0KKwkJZHByaW50aygiY291bGQgbm90IGFjcXVpcmUgbG9j
ayIpOw0KKwkJcmV0dXJuIDA7DQorCX0NCisNCisJcndbMF0gPSBfX2RpYjgwMDBfcmVhZF93b3Jk
KHN0YXRlLCByZWcgKyAwKTsNCisJcndbMV0gPSBfX2RpYjgwMDBfcmVhZF93b3JkKHN0YXRlLCBy
ZWcgKyAxKTsNCisNCisJbXV0ZXhfdW5sb2NrKCZzdGF0ZS0+aTJjX2J1ZmZlcl9sb2NrKTsNCiAN
CiAJcmV0dXJuICgocndbMF0gPDwgMTYpIHwgKHJ3WzFdKSk7DQogfQ0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEzNC9zYWE3MTM0LWFsc2EuYyBiL2RyaXZlcnMvbWVkaWEv
dmlkZW8vc2FhNzEzNC9zYWE3MTM0LWFsc2EuYw0KaW5kZXggMTA0NjBmZC4uZGJjZGZiZiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEzNC9zYWE3MTM0LWFsc2EuYw0KKysr
IGIvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3NhYTcxMzQtYWxzYS5jDQpAQCAtMTcyLDcg
KzE3Miw5IEBAIHN0YXRpYyB2b2lkIHNhYTcxMzRfaXJxX2Fsc2FfZG9uZShzdHJ1Y3Qgc2FhNzEz
NF9kZXYgKmRldiwNCiAJCWRwcmludGsoImlycTogb3ZlcnJ1biBbZnVsbD0lZC8lZF0gLSBCbG9j
a3MgaW4gJWRcbiIsZGV2LT5kbWFzb3VuZC5yZWFkX2NvdW50LA0KIAkJCWRldi0+ZG1hc291bmQu
YnVmc2l6ZSwgZGV2LT5kbWFzb3VuZC5ibG9ja3MpOw0KIAkJc3Bpbl91bmxvY2soJmRldi0+c2xv
Y2spOw0KKwkJc25kX3BjbV9zdHJlYW1fbG9jayhkZXYtPmRtYXNvdW5kLnN1YnN0cmVhbSk7DQog
CQlzbmRfcGNtX3N0b3AoZGV2LT5kbWFzb3VuZC5zdWJzdHJlYW0sU05EUlZfUENNX1NUQVRFX1hS
VU4pOw0KKwkJc25kX3BjbV9zdHJlYW1fdW5sb2NrKGRldi0+ZG1hc291bmQuc3Vic3RyZWFtKTsN
CiAJCXJldHVybjsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2hvc3QvYXRtZWwt
bWNpLmMgYi9kcml2ZXJzL21tYy9ob3N0L2F0bWVsLW1jaS5jDQppbmRleCA4Mzc5MGYyLi5mZDYx
ZjYzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tbWMvaG9zdC9hdG1lbC1tY2kuYw0KKysrIGIvZHJp
dmVycy9tbWMvaG9zdC9hdG1lbC1tY2kuYw0KQEAgLTEwMTQsMTEgKzEwMTQsMjIgQEAgc3RhdGlj
IHZvaWQgYXRtY2lfc3RhcnRfcmVxdWVzdChzdHJ1Y3QgYXRtZWxfbWNpICpob3N0LA0KIAlpZmxh
Z3MgfD0gQVRNQ0lfQ01EUkRZOw0KIAljbWQgPSBtcnEtPmNtZDsNCiAJY21kZmxhZ3MgPSBhdG1j
aV9wcmVwYXJlX2NvbW1hbmQoc2xvdC0+bW1jLCBjbWQpOw0KLQlhdG1jaV9zZW5kX2NvbW1hbmQo
aG9zdCwgY21kLCBjbWRmbGFncyk7DQorDQorCS8qDQorCSAqIERNQSB0cmFuc2ZlciBzaG91bGQg
YmUgc3RhcnRlZCBiZWZvcmUgc2VuZGluZyB0aGUgY29tbWFuZCB0byBhdm9pZA0KKwkgKiB1bmV4
cGVjdGVkIGVycm9ycyBlc3BlY2lhbGx5IGZvciByZWFkIG9wZXJhdGlvbnMgaW4gU0RJTyBtb2Rl
Lg0KKwkgKiBVbmZvcnR1bmF0ZWx5LCBpbiBQREMgbW9kZSwgY29tbWFuZCBoYXMgdG8gYmUgc2Vu
dCBiZWZvcmUgc3RhcnRpbmcNCisJICogdGhlIHRyYW5zZmVyLg0KKwkgKi8NCisJaWYgKGhvc3Qt
PnN1Ym1pdF9kYXRhICE9ICZhdG1jaV9zdWJtaXRfZGF0YV9kbWEpDQorCQlhdG1jaV9zZW5kX2Nv
bW1hbmQoaG9zdCwgY21kLCBjbWRmbGFncyk7DQogDQogCWlmIChkYXRhKQ0KIAkJaG9zdC0+c3Vi
bWl0X2RhdGEoaG9zdCwgZGF0YSk7DQogDQorCWlmIChob3N0LT5zdWJtaXRfZGF0YSA9PSAmYXRt
Y2lfc3VibWl0X2RhdGFfZG1hKQ0KKwkJYXRtY2lfc2VuZF9jb21tYW5kKGhvc3QsIGNtZCwgY21k
ZmxhZ3MpOw0KKw0KIAlpZiAobXJxLT5zdG9wKSB7DQogCQlob3N0LT5zdG9wX2NtZHIgPSBhdG1j
aV9wcmVwYXJlX2NvbW1hbmQoc2xvdC0+bW1jLCBtcnEtPnN0b3ApOw0KIAkJaG9zdC0+c3RvcF9j
bWRyIHw9IEFUTUNJX0NNRFJfU1RPUF9YRkVSOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2hv
c3Qvc2RoY2kuYyBiL2RyaXZlcnMvbW1jL2hvc3Qvc2RoY2kuYw0KaW5kZXggYWFlYWZmMi4uOWY2
OGI4MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbW1jL2hvc3Qvc2RoY2kuYw0KKysrIGIvZHJpdmVy
cy9tbWMvaG9zdC9zZGhjaS5jDQpAQCAtMTY3MCwxMiArMTY3MCwxMiBAQCBzdGF0aWMgaW50IHNk
aGNpX2V4ZWN1dGVfdHVuaW5nKHN0cnVjdCBtbWNfaG9zdCAqbW1jKQ0KIAlpbnQgdHVuaW5nX2xv
b3BfY291bnRlciA9IE1BWF9UVU5JTkdfTE9PUDsNCiAJdW5zaWduZWQgbG9uZyB0aW1lb3V0Ow0K
IAlpbnQgZXJyID0gMDsNCisJdW5zaWduZWQgbG9uZyBmbGFnczsNCiANCiAJaG9zdCA9IG1tY19w
cml2KG1tYyk7DQogDQogCXNkaGNpX3J1bnRpbWVfcG1fZ2V0KGhvc3QpOw0KLQlkaXNhYmxlX2ly
cShob3N0LT5pcnEpOw0KLQlzcGluX2xvY2soJmhvc3QtPmxvY2spOw0KKwlzcGluX2xvY2tfaXJx
c2F2ZSgmaG9zdC0+bG9jaywgZmxhZ3MpOw0KIA0KIAljdHJsID0gc2RoY2lfcmVhZHcoaG9zdCwg
U0RIQ0lfSE9TVF9DT05UUk9MMik7DQogDQpAQCAtMTY4OSw4ICsxNjg5LDcgQEAgc3RhdGljIGlu
dCBzZGhjaV9leGVjdXRlX3R1bmluZyhzdHJ1Y3QgbW1jX2hvc3QgKm1tYykNCiAJICAgIChob3N0
LT5mbGFncyAmIFNESENJX1NEUjUwX05FRURTX1RVTklORykpKQ0KIAkJY3RybCB8PSBTREhDSV9D
VFJMX0VYRUNfVFVOSU5HOw0KIAllbHNlIHsNCi0JCXNwaW5fdW5sb2NrKCZob3N0LT5sb2NrKTsN
Ci0JCWVuYWJsZV9pcnEoaG9zdC0+aXJxKTsNCisJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhv
c3QtPmxvY2ssIGZsYWdzKTsNCiAJCXNkaGNpX3J1bnRpbWVfcG1fcHV0KGhvc3QpOw0KIAkJcmV0
dXJuIDA7DQogCX0NCkBAIC0xNzUyLDE1ICsxNzUxLDEyIEBAIHN0YXRpYyBpbnQgc2RoY2lfZXhl
Y3V0ZV90dW5pbmcoc3RydWN0IG1tY19ob3N0ICptbWMpDQogCQlob3N0LT5jbWQgPSBOVUxMOw0K
IAkJaG9zdC0+bXJxID0gTlVMTDsNCiANCi0JCXNwaW5fdW5sb2NrKCZob3N0LT5sb2NrKTsNCi0J
CWVuYWJsZV9pcnEoaG9zdC0+aXJxKTsNCi0NCisJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhv
c3QtPmxvY2ssIGZsYWdzKTsNCiAJCS8qIFdhaXQgZm9yIEJ1ZmZlciBSZWFkIFJlYWR5IGludGVy
cnVwdCAqLw0KIAkJd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxlX3RpbWVvdXQoaG9zdC0+YnVmX3Jl
YWR5X2ludCwNCiAJCQkJCShob3N0LT50dW5pbmdfZG9uZSA9PSAxKSwNCiAJCQkJCW1zZWNzX3Rv
X2ppZmZpZXMoNTApKTsNCi0JCWRpc2FibGVfaXJxKGhvc3QtPmlycSk7DQotCQlzcGluX2xvY2so
Jmhvc3QtPmxvY2spOw0KKwkJc3Bpbl9sb2NrX2lycXNhdmUoJmhvc3QtPmxvY2ssIGZsYWdzKTsN
CiANCiAJCWlmICghaG9zdC0+dHVuaW5nX2RvbmUpIHsNCiAJCQlwcl9pbmZvKERSSVZFUl9OQU1F
ICI6IFRpbWVvdXQgd2FpdGluZyBmb3IgIg0KQEAgLTE4MzMsOCArMTgyOSw3IEBAIG91dDoNCiAJ
CWVyciA9IDA7DQogDQogCXNkaGNpX2NsZWFyX3NldF9pcnFzKGhvc3QsIFNESENJX0lOVF9EQVRB
X0FWQUlMLCBpZXIpOw0KLQlzcGluX3VubG9jaygmaG9zdC0+bG9jayk7DQotCWVuYWJsZV9pcnEo
aG9zdC0+aXJxKTsNCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaG9zdC0+bG9jaywgZmxhZ3Mp
Ow0KIAlzZGhjaV9ydW50aW1lX3BtX3B1dChob3N0KTsNCiANCiAJcmV0dXJuIGVycjsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL210ZC9uYW5kL214Y19uYW5kLmMgYi9kcml2ZXJzL210ZC9uYW5kL214
Y19uYW5kLmMNCmluZGV4IDc0YTQzYjguLmJhZjgzNTYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL210
ZC9uYW5kL214Y19uYW5kLmMNCisrKyBiL2RyaXZlcnMvbXRkL25hbmQvbXhjX25hbmQuYw0KQEAg
LTU5Niw3ICs1OTYsNiBAQCBzdGF0aWMgaW50IG14Y19uYW5kX2NvcnJlY3RfZGF0YV92Ml92Myhz
dHJ1Y3QgbXRkX2luZm8gKm10ZCwgdV9jaGFyICpkYXQsDQogCQllY2Nfc3RhdCA+Pj0gNDsNCiAJ
fSB3aGlsZSAoLS1ub19zdWJwYWdlcyk7DQogDQotCW10ZC0+ZWNjX3N0YXRzLmNvcnJlY3RlZCAr
PSByZXQ7DQogCXByX2RlYnVnKCIlZCBTeW1ib2wgQ29ycmVjdGFibGUgUlMtRUNDIEVycm9yXG4i
LCByZXQpOw0KIA0KIAlyZXR1cm4gcmV0Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2JvbmRp
bmcvYm9uZF8zYWQuYyBiL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF8zYWQuYw0KaW5kZXggMGFl
MGQ3Yy4uYWFhNzk5OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF8zYWQu
Yw0KKysrIGIvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kXzNhZC5jDQpAQCAtMTg1NCw4ICsxODU0
LDYgQEAgdm9pZCBib25kXzNhZF9pbml0aWF0ZV9hZ2dfc2VsZWN0aW9uKHN0cnVjdCBib25kaW5n
ICpib25kLCBpbnQgdGltZW91dCkNCiAJQk9ORF9BRF9JTkZPKGJvbmQpLmFnZ19zZWxlY3RfdGlt
ZXIgPSB0aW1lb3V0Ow0KIH0NCiANCi1zdGF0aWMgdTE2IGFnZ3JlZ2F0b3JfaWRlbnRpZmllcjsN
Ci0NCiAvKioNCiAgKiBib25kXzNhZF9pbml0aWFsaXplIC0gaW5pdGlhbGl6ZSBhIGJvbmQncyA4
MDIuM2FkIHBhcmFtZXRlcnMgYW5kIHN0cnVjdHVyZXMNCiAgKiBAYm9uZDogYm9uZGluZyBzdHJ1
Y3QgdG8gd29yayBvbg0KQEAgLTE4NjksNyArMTg2Nyw3IEBAIHZvaWQgYm9uZF8zYWRfaW5pdGlh
bGl6ZShzdHJ1Y3QgYm9uZGluZyAqYm9uZCwgdTE2IHRpY2tfcmVzb2x1dGlvbikNCiAJaWYgKE1B
Q19BRERSRVNTX0NPTVBBUkUoJihCT05EX0FEX0lORk8oYm9uZCkuc3lzdGVtLnN5c19tYWNfYWRk
ciksDQogCQkJCWJvbmQtPmRldi0+ZGV2X2FkZHIpKSB7DQogDQotCQlhZ2dyZWdhdG9yX2lkZW50
aWZpZXIgPSAwOw0KKwkJQk9ORF9BRF9JTkZPKGJvbmQpLmFnZ3JlZ2F0b3JfaWRlbnRpZmllciA9
IDA7DQogDQogCQlCT05EX0FEX0lORk8oYm9uZCkuc3lzdGVtLnN5c19wcmlvcml0eSA9IDB4RkZG
RjsNCiAJCUJPTkRfQURfSU5GTyhib25kKS5zeXN0ZW0uc3lzX21hY19hZGRyID0gKigoc3RydWN0
IG1hY19hZGRyICopYm9uZC0+ZGV2LT5kZXZfYWRkcik7DQpAQCAtMTk0MSw3ICsxOTM5LDcgQEAg
aW50IGJvbmRfM2FkX2JpbmRfc2xhdmUoc3RydWN0IHNsYXZlICpzbGF2ZSkNCiAJCWFkX2luaXRp
YWxpemVfYWdnKGFnZ3JlZ2F0b3IpOw0KIA0KIAkJYWdncmVnYXRvci0+YWdncmVnYXRvcl9tYWNf
YWRkcmVzcyA9ICooKHN0cnVjdCBtYWNfYWRkciAqKWJvbmQtPmRldi0+ZGV2X2FkZHIpOw0KLQkJ
YWdncmVnYXRvci0+YWdncmVnYXRvcl9pZGVudGlmaWVyID0gKCsrYWdncmVnYXRvcl9pZGVudGlm
aWVyKTsNCisJCWFnZ3JlZ2F0b3ItPmFnZ3JlZ2F0b3JfaWRlbnRpZmllciA9ICsrQk9ORF9BRF9J
TkZPKGJvbmQpLmFnZ3JlZ2F0b3JfaWRlbnRpZmllcjsNCiAJCWFnZ3JlZ2F0b3ItPnNsYXZlID0g
c2xhdmU7DQogCQlhZ2dyZWdhdG9yLT5pc19hY3RpdmUgPSAwOw0KIAkJYWdncmVnYXRvci0+bnVt
X29mX3BvcnRzID0gMDsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfM2Fk
LmggYi9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfM2FkLmgNCmluZGV4IDIzNWIyY2MuLjIwZDlj
NzggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfM2FkLmgNCisrKyBiL2Ry
aXZlcnMvbmV0L2JvbmRpbmcvYm9uZF8zYWQuaA0KQEAgLTI1Myw2ICsyNTMsNyBAQCBzdHJ1Y3Qg
YWRfc3lzdGVtIHsNCiBzdHJ1Y3QgYWRfYm9uZF9pbmZvIHsNCiAJc3RydWN0IGFkX3N5c3RlbSBz
eXN0ZW07CSAgICAvKiA4MDIuM2FkIHN5c3RlbSBzdHJ1Y3R1cmUgKi8NCiAJdTMyIGFnZ19zZWxl
Y3RfdGltZXI7CSAgICAvLyBUaW1lciB0byBzZWxlY3QgYWdncmVnYXRvciBhZnRlciBhbGwgYWRh
cHRlcidzIGhhbmQgc2hha2VzDQorCXUxNiBhZ2dyZWdhdG9yX2lkZW50aWZpZXI7DQogfTsNCiAN
CiBzdHJ1Y3QgYWRfc2xhdmVfaW5mbyB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2Zs
ZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCmluZGV4IGJiODI4YzIuLjdjNmJi
NWEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQorKysgYi9kcml2ZXJz
L25ldC9jYW4vZmxleGNhbi5jDQpAQCAtNzc3LDE0ICs3NzcsMTYgQEAgc3RhdGljIHZvaWQgZmxl
eGNhbl9jaGlwX3N0b3Aoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAJc3RydWN0IGZsZXhjYW5f
cmVncyBfX2lvbWVtICpyZWdzID0gcHJpdi0+YmFzZTsNCiAJdTMyIHJlZzsNCiANCi0JLyogRGlz
YWJsZSBhbGwgaW50ZXJydXB0cyAqLw0KLQlmbGV4Y2FuX3dyaXRlKDAsICZyZWdzLT5pbWFzazEp
Ow0KLQ0KIAkvKiBEaXNhYmxlICsgaGFsdCBtb2R1bGUgKi8NCiAJcmVnID0gZmxleGNhbl9yZWFk
KCZyZWdzLT5tY3IpOw0KIAlyZWcgfD0gRkxFWENBTl9NQ1JfTURJUyB8IEZMRVhDQU5fTUNSX0hB
TFQ7DQogCWZsZXhjYW5fd3JpdGUocmVnLCAmcmVncy0+bWNyKTsNCiANCisJLyogRGlzYWJsZSBh
bGwgaW50ZXJydXB0cyAqLw0KKwlmbGV4Y2FuX3dyaXRlKDAsICZyZWdzLT5pbWFzazEpOw0KKwlm
bGV4Y2FuX3dyaXRlKHByaXYtPnJlZ19jdHJsX2RlZmF1bHQgJiB+RkxFWENBTl9DVFJMX0VSUl9B
TEwsDQorCQkgICAgICAmcmVncy0+Y3RybCk7DQorDQogCWZsZXhjYW5fdHJhbnNjZWl2ZXJfc3dp
dGNoKHByaXYsIDApOw0KIAlwcml2LT5jYW4uc3RhdGUgPSBDQU5fU1RBVEVfU1RPUFBFRDsNCiAN
CkBAIC04MDksMTIgKzgxMSwxNCBAQCBzdGF0aWMgaW50IGZsZXhjYW5fb3BlbihzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2KQ0KIAkvKiBzdGFydCBjaGlwIGFuZCBxdWV1aW5nICovDQogCWVyciA9IGZs
ZXhjYW5fY2hpcF9zdGFydChkZXYpOw0KIAlpZiAoZXJyKQ0KLQkJZ290byBvdXRfY2xvc2U7DQor
CQlnb3RvIG91dF9mcmVlX2lycTsNCiAJbmFwaV9lbmFibGUoJnByaXYtPm5hcGkpOw0KIAluZXRp
Zl9zdGFydF9xdWV1ZShkZXYpOw0KIA0KIAlyZXR1cm4gMDsNCiANCisgb3V0X2ZyZWVfaXJxOg0K
KwlmcmVlX2lycShkZXYtPmlycSwgZGV2KTsNCiAgb3V0X2Nsb3NlOg0KIAljbG9zZV9jYW5kZXYo
ZGV2KTsNCiAgb3V0Og0KQEAgLTEwMjMsNiArMTAyNyw3IEBAIHN0YXRpYyBpbnQgX19kZXZleGl0
IGZsZXhjYW5fcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQogCXN0cnVjdCBy
ZXNvdXJjZSAqbWVtOw0KIA0KIAl1bnJlZ2lzdGVyX2ZsZXhjYW5kZXYoZGV2KTsNCisJbmV0aWZf
bmFwaV9kZWwoJnByaXYtPm5hcGkpOw0KIAlwbGF0Zm9ybV9zZXRfZHJ2ZGF0YShwZGV2LCBOVUxM
KTsNCiAJaW91bm1hcChwcml2LT5iYXNlKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9icm9hZGNvbS90ZzMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL3Rn
My5jDQppbmRleCBkNTc5M2QzLi5jNzdjNDYyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvYnJvYWRjb20vdGczLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29t
L3RnMy5jDQpAQCAtNTYzNyw4ICs1NjM3LDcgQEAgc3RhdGljIGludCB0ZzNfcngoc3RydWN0IHRn
M19uYXBpICp0bmFwaSwgaW50IGJ1ZGdldCkNCiANCiAJCXdvcmtfbWFzayB8PSBvcGFxdWVfa2V5
Ow0KIA0KLQkJaWYgKChkZXNjLT5lcnJfdmxhbiAmIFJYRF9FUlJfTUFTSykgIT0gMCAmJg0KLQkJ
ICAgIChkZXNjLT5lcnJfdmxhbiAhPSBSWERfRVJSX09ERF9OSUJCTEVfUkNWRF9NSUkpKSB7DQor
CQlpZiAoZGVzYy0+ZXJyX3ZsYW4gJiBSWERfRVJSX01BU0spIHsNCiAJCWRyb3BfaXQ6DQogCQkJ
dGczX3JlY3ljbGVfcngodG5hcGksIHRwciwgb3BhcXVlX2tleSwNCiAJCQkJICAgICAgIGRlc2Nf
aWR4LCAqcG9zdF9wdHIpOw0KQEAgLTcxMDMsMTIgKzcxMDIsMTIgQEAgc3RhdGljIGludCB0ZzNf
Y2hhbmdlX210dShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBpbnQgbmV3X210dSkNCiANCiAJdGcz
X25ldGlmX3N0b3AodHApOw0KIA0KKwl0ZzNfc2V0X210dShkZXYsIHRwLCBuZXdfbXR1KTsNCisN
CiAJdGczX2Z1bGxfbG9jayh0cCwgMSk7DQogDQogCXRnM19oYWx0KHRwLCBSRVNFVF9LSU5EX1NI
VVRET1dOLCAxKTsNCiANCi0JdGczX3NldF9tdHUoZGV2LCB0cCwgbmV3X210dSk7DQotDQogCWVy
ciA9IHRnM19yZXN0YXJ0X2h3KHRwLCAwKTsNCiANCiAJaWYgKCFlcnIpDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vdGczLmggYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9icm9hZGNvbS90ZzMuaA0KaW5kZXggZGE5MGJhNS4uYTM5OGE2ZiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9icm9hZGNvbS90ZzMuaA0KQEAgLTI0NzcsNyArMjQ3NywxMSBAQCBzdHJ1Y3QgdGczX3J4
X2J1ZmZlcl9kZXNjIHsNCiAjZGVmaW5lIFJYRF9FUlJfVE9PX1NNQUxMCQkweDAwNDAwMDAwDQog
I2RlZmluZSBSWERfRVJSX05PX1JFU09VUkNFUwkJMHgwMDgwMDAwMA0KICNkZWZpbmUgUlhEX0VS
Ul9IVUdFX0ZSQU1FCQkweDAxMDAwMDAwDQotI2RlZmluZSBSWERfRVJSX01BU0sJCQkweGZmZmYw
MDAwDQorDQorI2RlZmluZSBSWERfRVJSX01BU0sJKFJYRF9FUlJfQkFEX0NSQyB8IFJYRF9FUlJf
Q09MTElTSU9OIHwJCVwNCisJCQkgUlhEX0VSUl9MSU5LX0xPU1QgfCBSWERfRVJSX1BIWV9ERUNP
REUgfAlcDQorCQkJIFJYRF9FUlJfTUFDX0FCUlQgfCBSWERfRVJSX1RPT19TTUFMTCB8CQlcDQor
CQkJIFJYRF9FUlJfTk9fUkVTT1VSQ0VTIHwgUlhEX0VSUl9IVUdFX0ZSQU1FKQ0KIA0KIAl1MzIJ
CQkJcmVzZXJ2ZWQ7DQogCXUzMgkJCQlvcGFxdWU7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
dXNiL2dsNjIwYS5jIGIvZHJpdmVycy9uZXQvdXNiL2dsNjIwYS5jDQppbmRleCBjNGNmZDFkLi43
NWQ5MDQwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdXNiL2dsNjIwYS5jDQorKysgYi9kcml2
ZXJzL25ldC91c2IvZ2w2MjBhLmMNCkBAIC04Niw2ICs4NiwxMCBAQCBzdGF0aWMgaW50IGdlbmVs
aW5rX3J4X2ZpeHVwKHN0cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHNrX2J1ZmYgKnNrYikNCiAJ
dTMyCQkJc2l6ZTsNCiAJdTMyCQkJY291bnQ7DQogDQorCS8qIFRoaXMgY2hlY2sgaXMgbm8gbG9u
Z2VyIGRvbmUgYnkgdXNibmV0ICovDQorCWlmIChza2ItPmxlbiA8IGRldi0+bmV0LT5oYXJkX2hl
YWRlcl9sZW4pDQorCQlyZXR1cm4gMDsNCisNCiAJaGVhZGVyID0gKHN0cnVjdCBnbF9oZWFkZXIg
Kikgc2tiLT5kYXRhOw0KIA0KIAkvLyBnZXQgdGhlIHBhY2tldCBjb3VudCBvZiB0aGUgcmVjZWl2
ZWQgc2tiDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL21jczc4MzAuYyBiL2RyaXZlcnMv
bmV0L3VzYi9tY3M3ODMwLmMNCmluZGV4IGRiMmNiNzQuLmEyZjc1NzkgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC91c2IvbWNzNzgzMC5jDQorKysgYi9kcml2ZXJzL25ldC91c2IvbWNzNzgzMC5j
DQpAQCAtNjAxLDggKzYwMSw5IEBAIHN0YXRpYyBpbnQgbWNzNzgzMF9yeF9maXh1cChzdHJ1Y3Qg
dXNibmV0ICpkZXYsIHN0cnVjdCBza19idWZmICpza2IpDQogew0KIAl1OCBzdGF0dXM7DQogDQot
CWlmIChza2ItPmxlbiA9PSAwKSB7DQotCQlkZXZfZXJyKCZkZXYtPnVkZXYtPmRldiwgInVuZXhw
ZWN0ZWQgZW1wdHkgcnggZnJhbWVcbiIpOw0KKwkvKiBUaGlzIGNoZWNrIGlzIG5vIGxvbmdlciBk
b25lIGJ5IHVzYm5ldCAqLw0KKwlpZiAoc2tiLT5sZW4gPCBkZXYtPm5ldC0+aGFyZF9oZWFkZXJf
bGVuKSB7DQorCQlkZXZfZXJyKCZkZXYtPnVkZXYtPmRldiwgInVuZXhwZWN0ZWQgdGlueSByeCBm
cmFtZVxuIik7DQogCQlyZXR1cm4gMDsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3VzYi9uZXQxMDgwLmMgYi9kcml2ZXJzL25ldC91c2IvbmV0MTA4MC5jDQppbmRleCAwMWRiNDYw
Li5jOWUzMjc4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdXNiL25ldDEwODAuYw0KKysrIGIv
ZHJpdmVycy9uZXQvdXNiL25ldDEwODAuYw0KQEAgLTQxOSw2ICs0MTksMTAgQEAgc3RhdGljIGlu
dCBuZXQxMDgwX3J4X2ZpeHVwKHN0cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHNrX2J1ZmYgKnNr
YikNCiAJc3RydWN0IG5jX3RyYWlsZXIJKnRyYWlsZXI7DQogCXUxNgkJCWhkcl9sZW4sIHBhY2tl
dF9sZW47DQogDQorCS8qIFRoaXMgY2hlY2sgaXMgbm8gbG9uZ2VyIGRvbmUgYnkgdXNibmV0ICov
DQorCWlmIChza2ItPmxlbiA8IGRldi0+bmV0LT5oYXJkX2hlYWRlcl9sZW4pDQorCQlyZXR1cm4g
MDsNCisNCiAJaWYgKCEoc2tiLT5sZW4gJiAweDAxKSkgew0KICNpZmRlZiBERUJVRw0KIAkJc3Ry
dWN0IG5ldF9kZXZpY2UJKm5ldCA9IGRldi0+bmV0Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3VzYi9ybmRpc19ob3N0LmMgYi9kcml2ZXJzL25ldC91c2Ivcm5kaXNfaG9zdC5jDQppbmRleCAy
NTVkNmE0Li4xM2I0MGUzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdXNiL3JuZGlzX2hvc3Qu
Yw0KKysrIGIvZHJpdmVycy9uZXQvdXNiL3JuZGlzX2hvc3QuYw0KQEAgLTQ5MCw2ICs0OTAsMTAg
QEAgRVhQT1JUX1NZTUJPTF9HUEwocm5kaXNfdW5iaW5kKTsNCiAgKi8NCiBpbnQgcm5kaXNfcnhf
Zml4dXAoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIHsNCisJLyog
VGhpcyBjaGVjayBpcyBubyBsb25nZXIgZG9uZSBieSB1c2JuZXQgKi8NCisJaWYgKHNrYi0+bGVu
IDwgZGV2LT5uZXQtPmhhcmRfaGVhZGVyX2xlbikNCisJCXJldHVybiAwOw0KKw0KIAkvKiBwZXJp
cGhlcmFsIG1heSBoYXZlIGJhdGNoZWQgcGFja2V0cyB0byB1cy4uLiAqLw0KIAl3aGlsZSAobGlr
ZWx5KHNrYi0+bGVuKSkgew0KIAkJc3RydWN0IHJuZGlzX2RhdGFfaGRyCSpoZHIgPSAodm9pZCAq
KXNrYi0+ZGF0YTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC91c2Ivc21zYzc1eHguYyBiL2Ry
aXZlcnMvbmV0L3VzYi9zbXNjNzV4eC5jDQppbmRleCBhOGU0NjQwLi5jNDFiNDJiIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvdXNiL3Ntc2M3NXh4LmMNCisrKyBiL2RyaXZlcnMvbmV0L3VzYi9z
bXNjNzV4eC5jDQpAQCAtMTA3OSw2ICsxMDc5LDEwIEBAIHN0YXRpYyB2b2lkIHNtc2M3NXh4X3J4
X2NzdW1fb2ZmbG9hZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVjdCBza19idWZmICpza2IsDQog
DQogc3RhdGljIGludCBzbXNjNzV4eF9yeF9maXh1cChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVj
dCBza19idWZmICpza2IpDQogew0KKwkvKiBUaGlzIGNoZWNrIGlzIG5vIGxvbmdlciBkb25lIGJ5
IHVzYm5ldCAqLw0KKwlpZiAoc2tiLT5sZW4gPCBkZXYtPm5ldC0+aGFyZF9oZWFkZXJfbGVuKQ0K
KwkJcmV0dXJuIDA7DQorDQogCXdoaWxlIChza2ItPmxlbiA+IDApIHsNCiAJCXUzMiByeF9jbWRf
YSwgcnhfY21kX2IsIGFsaWduX2NvdW50LCBzaXplOw0KIAkJc3RydWN0IHNrX2J1ZmYgKmF4X3Nr
YjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYyBiL2RyaXZlcnMvbmV0
L3VzYi9zbXNjOTV4eC5jDQppbmRleCA1NWIzMjE4Li42NjE3MzI1IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMNCisrKyBiL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5j
DQpAQCAtMTAzOSw2ICsxMDM5LDEwIEBAIHN0YXRpYyB2b2lkIHNtc2M5NXh4X3J4X2NzdW1fb2Zm
bG9hZChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIA0KIHN0YXRpYyBpbnQgc21zYzk1eHhfcnhfZml4
dXAoc3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIHsNCisJLyogVGhp
cyBjaGVjayBpcyBubyBsb25nZXIgZG9uZSBieSB1c2JuZXQgKi8NCisJaWYgKHNrYi0+bGVuIDwg
ZGV2LT5uZXQtPmhhcmRfaGVhZGVyX2xlbikNCisJCXJldHVybiAwOw0KKw0KIAl3aGlsZSAoc2ti
LT5sZW4gPiAwKSB7DQogCQl1MzIgaGVhZGVyLCBhbGlnbl9jb3VudDsNCiAJCXN0cnVjdCBza19i
dWZmICpheF9za2I7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jIGIvZHJp
dmVycy9uZXQvdXNiL3VzYm5ldC5jDQppbmRleCBkYzUzYThmLi4zZDIxNzQyIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvdXNiL3VzYm5ldC5jDQorKysgYi9kcml2ZXJzL25ldC91c2IvdXNibmV0
LmMNCkBAIC00MTQsMTcgKzQxNCwxOSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgcnhfcHJvY2VzcyAo
c3RydWN0IHVzYm5ldCAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIAl9DQogCS8vIGVsc2Ug
bmV0d29yayBzdGFjayByZW1vdmVzIGV4dHJhIGJ5dGUgaWYgd2UgZm9yY2VkIGEgc2hvcnQgcGFj
a2V0DQogDQotCWlmIChza2ItPmxlbikgew0KLQkJLyogYWxsIGRhdGEgd2FzIGFscmVhZHkgY2xv
bmVkIGZyb20gc2tiIGluc2lkZSB0aGUgZHJpdmVyICovDQotCQlpZiAoZGV2LT5kcml2ZXJfaW5m
by0+ZmxhZ3MgJiBGTEFHX01VTFRJX1BBQ0tFVCkNCi0JCQlkZXZfa2ZyZWVfc2tiX2FueShza2Ip
Ow0KLQkJZWxzZQ0KLQkJCXVzYm5ldF9za2JfcmV0dXJuKGRldiwgc2tiKTsNCisJLyogYWxsIGRh
dGEgd2FzIGFscmVhZHkgY2xvbmVkIGZyb20gc2tiIGluc2lkZSB0aGUgZHJpdmVyICovDQorCWlm
IChkZXYtPmRyaXZlcl9pbmZvLT5mbGFncyAmIEZMQUdfTVVMVElfUEFDS0VUKQ0KKwkJZ290byBk
b25lOw0KKw0KKwlpZiAoc2tiLT5sZW4gPCBFVEhfSExFTikgew0KKwkJZGV2LT5uZXQtPnN0YXRz
LnJ4X2Vycm9ycysrOw0KKwkJZGV2LT5uZXQtPnN0YXRzLnJ4X2xlbmd0aF9lcnJvcnMrKzsNCisJ
CW5ldGlmX2RiZyhkZXYsIHJ4X2VyciwgZGV2LT5uZXQsICJyeCBsZW5ndGggJWRcbiIsIHNrYi0+
bGVuKTsNCisJfSBlbHNlIHsNCisJCXVzYm5ldF9za2JfcmV0dXJuKGRldiwgc2tiKTsNCiAJCXJl
dHVybjsNCiAJfQ0KIA0KLQluZXRpZl9kYmcoZGV2LCByeF9lcnIsIGRldi0+bmV0LCAiZHJvcFxu
Iik7DQotCWRldi0+bmV0LT5zdGF0cy5yeF9lcnJvcnMrKzsNCiBkb25lOg0KIAlza2JfcXVldWVf
dGFpbCgmZGV2LT5kb25lLCBza2IpOw0KIH0NCkBAIC00NDYsMTMgKzQ0OCw2IEBAIHN0YXRpYyB2
b2lkIHJ4X2NvbXBsZXRlIChzdHJ1Y3QgdXJiICp1cmIpDQogCXN3aXRjaCAodXJiX3N0YXR1cykg
ew0KIAkvKiBzdWNjZXNzICovDQogCWNhc2UgMDoNCi0JCWlmIChza2ItPmxlbiA8IGRldi0+bmV0
LT5oYXJkX2hlYWRlcl9sZW4pIHsNCi0JCQlzdGF0ZSA9IHJ4X2NsZWFudXA7DQotCQkJZGV2LT5u
ZXQtPnN0YXRzLnJ4X2Vycm9ycysrOw0KLQkJCWRldi0+bmV0LT5zdGF0cy5yeF9sZW5ndGhfZXJy
b3JzKys7DQotCQkJbmV0aWZfZGJnKGRldiwgcnhfZXJyLCBkZXYtPm5ldCwNCi0JCQkJICAicngg
bGVuZ3RoICVkXG4iLCBza2ItPmxlbik7DQotCQl9DQogCQlicmVhazsNCiANCiAJLyogc3RhbGxz
IG5lZWQgbWFudWFsIHJlc2V0LiB0aGlzIGlzIHJhcmUgLi4uIGV4Y2VwdCB0aGF0DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jIGIvZHJpdmVycy9uZXQvdmlydGlvX25ldC5j
DQppbmRleCA0M2E2YTExLi5mMTNhNjczIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdmlydGlv
X25ldC5jDQorKysgYi9kcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMNCkBAIC0xMDI5LDcgKzEwMjks
OCBAQCBzdGF0aWMgaW50IHZpcnRuZXRfcHJvYmUoc3RydWN0IHZpcnRpb19kZXZpY2UgKnZkZXYp
DQogCS8qIElmIHdlIGNhbiByZWNlaXZlIEFOWSBHU08gcGFja2V0cywgd2UgbXVzdCBhbGxvY2F0
ZSBsYXJnZSBvbmVzLiAqLw0KIAlpZiAodmlydGlvX2hhc19mZWF0dXJlKHZkZXYsIFZJUlRJT19O
RVRfRl9HVUVTVF9UU080KSB8fA0KIAkgICAgdmlydGlvX2hhc19mZWF0dXJlKHZkZXYsIFZJUlRJ
T19ORVRfRl9HVUVTVF9UU082KSB8fA0KLQkgICAgdmlydGlvX2hhc19mZWF0dXJlKHZkZXYsIFZJ
UlRJT19ORVRfRl9HVUVTVF9FQ04pKQ0KKwkgICAgdmlydGlvX2hhc19mZWF0dXJlKHZkZXYsIFZJ
UlRJT19ORVRfRl9HVUVTVF9FQ04pIHx8DQorCSAgICB2aXJ0aW9faGFzX2ZlYXR1cmUodmRldiwg
VklSVElPX05FVF9GX0dVRVNUX1VGTykpDQogCQl2aS0+YmlnX3BhY2tldHMgPSB0cnVlOw0KIA0K
IAlpZiAodmlydGlvX2hhc19mZWF0dXJlKHZkZXYsIFZJUlRJT19ORVRfRl9NUkdfUlhCVUYpKQ0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3ZteG5ldDMvdm14bmV0M19kcnYuYyBiL2RyaXZlcnMv
bmV0L3ZteG5ldDMvdm14bmV0M19kcnYuYw0KaW5kZXggZDQyNjI2MS4uMjhjZWVmMiAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L3ZteG5ldDMvdm14bmV0M19kcnYuYw0KKysrIGIvZHJpdmVycy9u
ZXQvdm14bmV0My92bXhuZXQzX2Rydi5jDQpAQCAtMTczNCwxMSArMTczNCwyMCBAQCB2bXhuZXQz
X25ldHBvbGwoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCiB7DQogCXN0cnVjdCB2bXhuZXQz
X2FkYXB0ZXIgKmFkYXB0ZXIgPSBuZXRkZXZfcHJpdihuZXRkZXYpOw0KIA0KLQlpZiAoYWRhcHRl
ci0+aW50ci5tYXNrX21vZGUgPT0gVk1YTkVUM19JTU1fQUNUSVZFKQ0KLQkJdm14bmV0M19kaXNh
YmxlX2FsbF9pbnRycyhhZGFwdGVyKTsNCi0NCi0Jdm14bmV0M19kb19wb2xsKGFkYXB0ZXIsIGFk
YXB0ZXItPnJ4X3F1ZXVlWzBdLnJ4X3JpbmdbMF0uc2l6ZSk7DQotCXZteG5ldDNfZW5hYmxlX2Fs
bF9pbnRycyhhZGFwdGVyKTsNCisJc3dpdGNoIChhZGFwdGVyLT5pbnRyLnR5cGUpIHsNCisjaWZk
ZWYgQ09ORklHX1BDSV9NU0kNCisJY2FzZSBWTVhORVQzX0lUX01TSVg6IHsNCisJCWludCBpOw0K
KwkJZm9yIChpID0gMDsgaSA8IGFkYXB0ZXItPm51bV9yeF9xdWV1ZXM7IGkrKykNCisJCQl2bXhu
ZXQzX21zaXhfcngoMCwgJmFkYXB0ZXItPnJ4X3F1ZXVlW2ldKTsNCisJCWJyZWFrOw0KKwl9DQor
I2VuZGlmDQorCWNhc2UgVk1YTkVUM19JVF9NU0k6DQorCWRlZmF1bHQ6DQorCQl2bXhuZXQzX2lu
dHIoMCwgYWRhcHRlci0+bmV0ZGV2KTsNCisJCWJyZWFrOw0KKwl9DQogDQogfQ0KICNlbmRpZgkv
KiBDT05GSUdfTkVUX1BPTExfQ09OVFJPTExFUiAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjk0NjJfMnAwX2luaXR2YWxzLmggYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9hdGgvYXRoOWsvYXI5NDYyXzJwMF9pbml0dmFscy5oDQppbmRleCA5YzUxYjM5Li5l
YWJmMzc0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2FyOTQ2
Ml8ycDBfaW5pdHZhbHMuaA0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2Fy
OTQ2Ml8ycDBfaW5pdHZhbHMuaA0KQEAgLTU1LDcgKzU1LDcgQEAgc3RhdGljIGNvbnN0IHUzMiBh
cjk0NjJfMnAwX2Jhc2ViYW5kX3Bvc3RhbWJsZVtdWzVdID0gew0KIAl7MHgwMDAwOWUxNCwgMHgz
N2I5NWQ1ZSwgMHgzN2I5NjA1ZSwgMHgzMDM5NjA1ZSwgMHgzMzc5NWQ1ZX0sDQogCXsweDAwMDA5
ZTE4LCAweDAwMDAwMDAwLCAweDAwMDAwMDAwLCAweDAwMDAwMDAwLCAweDAwMDAwMDAwfSwNCiAJ
ezB4MDAwMDllMWMsIDB4MDAwMWNmOWMsIDB4MDAwMWNmOWMsIDB4MDAwMjFmOWMsIDB4MDAwMjFm
OWN9LA0KLQl7MHgwMDAwOWUyMCwgMHgwMDAwMDNiNSwgMHgwMDAwMDNiNSwgMHgwMDAwMDNjZSwg
MHgwMDAwMDNjZX0sDQorCXsweDAwMDA5ZTIwLCAweDAwMDAwM2E1LCAweDAwMDAwM2E1LCAweDAw
MDAwM2E1LCAweDAwMDAwM2E1fSwNCiAJezB4MDAwMDllMmMsIDB4MDAwMDAwMWMsIDB4MDAwMDAw
MWMsIDB4MDAwMDAwMjEsIDB4MDAwMDAwMjF9LA0KIAl7MHgwMDAwOWUzYywgMHhjZjk0NjIyMCwg
MHhjZjk0NjIyMCwgMHhjZmQ1Yzc4MiwgMHhjZmQ1Yzc4Mn0sDQogCXsweDAwMDA5ZTQ0LCAweGZl
MzIxZTI3LCAweGZlMzIxZTI3LCAweGZlMjkxZTI3LCAweGZlMjkxZTI3fSwNCkBAIC04NSw3ICs4
NSw3IEBAIHN0YXRpYyBjb25zdCB1MzIgYXI5NDYyXzJwMF9iYXNlYmFuZF9wb3N0YW1ibGVbXVs1
XSA9IHsNCiAJezB4MDAwMGFlMDQsIDB4MDAxYzAwMDAsIDB4MDAxYzAwMDAsIDB4MDAxYzAwMDAs
IDB4MDAxMDAwMDB9LA0KIAl7MHgwMDAwYWUxOCwgMHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwgMHgw
MDAwMDAwMCwgMHgwMDAwMDAwMH0sDQogCXsweDAwMDBhZTFjLCAweDAwMDAwMTljLCAweDAwMDAw
MTljLCAweDAwMDAwMTljLCAweDAwMDAwMTljfSwNCi0JezB4MDAwMGFlMjAsIDB4MDAwMDAxYjUs
IDB4MDAwMDAxYjUsIDB4MDAwMDAxY2UsIDB4MDAwMDAxY2V9LA0KKwl7MHgwMDAwYWUyMCwgMHgw
MDAwMDFhNiwgMHgwMDAwMDFhNiwgMHgwMDAwMDFhYSwgMHgwMDAwMDFhYX0sDQogCXsweDAwMDBi
Mjg0LCAweDAwMDAwMDAwLCAweDAwMDAwMDAwLCAweDAwMDAwNTUwLCAweDAwMDAwNTUwfSwNCiB9
Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9odGNfZHJ2
X2luaXQuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9odGNfZHJ2X2luaXQuYw0K
aW5kZXggZWY5MjFlMS4uYzZjM2UxYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9odGNfZHJ2X2luaXQuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDlrL2h0Y19kcnZfaW5pdC5jDQpAQCAtMjgsNiArMjgsMTAgQEAgaW50IGh0Y19tb2RwYXJh
bV9ub2h3Y3J5cHQ7DQogbW9kdWxlX3BhcmFtX25hbWVkKG5vaHdjcnlwdCwgaHRjX21vZHBhcmFt
X25vaHdjcnlwdCwgaW50LCAwNDQ0KTsNCiBNT0RVTEVfUEFSTV9ERVNDKG5vaHdjcnlwdCwgIkRp
c2FibGUgaGFyZHdhcmUgZW5jcnlwdGlvbiIpOw0KIA0KK3N0YXRpYyBpbnQgYXRoOWtfcHNfZW5h
YmxlOw0KK21vZHVsZV9wYXJhbV9uYW1lZChwc19lbmFibGUsIGF0aDlrX3BzX2VuYWJsZSwgaW50
LCAwNDQ0KTsNCitNT0RVTEVfUEFSTV9ERVNDKHBzX2VuYWJsZSwgIkVuYWJsZSBXTEFOIFBvd2Vy
U2F2ZSIpOw0KKw0KICNkZWZpbmUgQ0hBTjJHKF9mcmVxLCBfaWR4KSAgeyBcDQogCS5jZW50ZXJf
ZnJlcSA9IChfZnJlcSksIFwNCiAJLmh3X3ZhbHVlID0gKF9pZHgpLCBcDQpAQCAtNzI5LDExICs3
MzMsMTMgQEAgc3RhdGljIHZvaWQgYXRoOWtfc2V0X2h3X2NhcGFiKHN0cnVjdCBhdGg5a19odGNf
cHJpdiAqcHJpdiwNCiAJCUlFRUU4MDIxMV9IV19TUEVDVFJVTV9NR01UIHwNCiAJCUlFRUU4MDIx
MV9IV19IQVNfUkFURV9DT05UUk9MIHwNCiAJCUlFRUU4MDIxMV9IV19SWF9JTkNMVURFU19GQ1Mg
fA0KLQkJSUVFRTgwMjExX0hXX1NVUFBPUlRTX1BTIHwNCiAJCUlFRUU4MDIxMV9IV19QU19OVUxM
RlVOQ19TVEFDSyB8DQogCQlJRUVFODAyMTFfSFdfUkVQT1JUU19UWF9BQ0tfU1RBVFVTIHwNCiAJ
CUlFRUU4MDIxMV9IV19IT1NUX0JST0FEQ0FTVF9QU19CVUZGRVJJTkc7DQogDQorCWlmIChhdGg5
a19wc19lbmFibGUpDQorCQlody0+ZmxhZ3MgfD0gSUVFRTgwMjExX0hXX1NVUFBPUlRTX1BTOw0K
Kw0KIAlody0+d2lwaHktPmludGVyZmFjZV9tb2RlcyA9DQogCQlCSVQoTkw4MDIxMV9JRlRZUEVf
U1RBVElPTikgfA0KIAkJQklUKE5MODAyMTFfSUZUWVBFX0FESE9DKSB8DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2luaXQuYyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg5ay9pbml0LmMNCmluZGV4IGJhNmE0OWMuLjEzNTVkNzEgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaW5pdC5jDQorKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXRoOWsvaW5pdC5jDQpAQCAtNDQsNiArNDQsMTAgQEAgc3RhdGljIGlu
dCBhdGg5a19idGNvZXhfZW5hYmxlOw0KIG1vZHVsZV9wYXJhbV9uYW1lZChidGNvZXhfZW5hYmxl
LCBhdGg5a19idGNvZXhfZW5hYmxlLCBpbnQsIDA0NDQpOw0KIE1PRFVMRV9QQVJNX0RFU0MoYnRj
b2V4X2VuYWJsZSwgIkVuYWJsZSB3aWZpLUJUIGNvZXhpc3RlbmNlIik7DQogDQorc3RhdGljIGlu
dCBhdGg5a19wc19lbmFibGU7DQorbW9kdWxlX3BhcmFtX25hbWVkKHBzX2VuYWJsZSwgYXRoOWtf
cHNfZW5hYmxlLCBpbnQsIDA0NDQpOw0KK01PRFVMRV9QQVJNX0RFU0MocHNfZW5hYmxlLCAiRW5h
YmxlIFdMQU4gUG93ZXJTYXZlIik7DQorDQogYm9vbCBpc19hdGg5a191bmxvYWRlZDsNCiAvKiBX
ZSB1c2UgdGhlIGh3X3ZhbHVlIGFzIGFuIGluZGV4IGludG8gb3VyIHByaXZhdGUgY2hhbm5lbCBz
dHJ1Y3R1cmUgKi8NCiANCkBAIC02NzEsMTEgKzY3NSwxMyBAQCB2b2lkIGF0aDlrX3NldF9od19j
YXBhYihzdHJ1Y3QgYXRoX3NvZnRjICpzYywgc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQogCWh3
LT5mbGFncyA9IElFRUU4MDIxMV9IV19SWF9JTkNMVURFU19GQ1MgfA0KIAkJSUVFRTgwMjExX0hX
X0hPU1RfQlJPQURDQVNUX1BTX0JVRkZFUklORyB8DQogCQlJRUVFODAyMTFfSFdfU0lHTkFMX0RC
TSB8DQotCQlJRUVFODAyMTFfSFdfU1VQUE9SVFNfUFMgfA0KIAkJSUVFRTgwMjExX0hXX1BTX05V
TExGVU5DX1NUQUNLIHwNCiAJCUlFRUU4MDIxMV9IV19TUEVDVFJVTV9NR01UIHwNCiAJCUlFRUU4
MDIxMV9IV19SRVBPUlRTX1RYX0FDS19TVEFUVVM7DQogDQorCWlmIChhdGg5a19wc19lbmFibGUp
DQorCQlody0+ZmxhZ3MgfD0gSUVFRTgwMjExX0hXX1NVUFBPUlRTX1BTOw0KKw0KIAlpZiAoc2Mt
PnNjX2FoLT5jYXBzLmh3X2NhcHMgJiBBVEg5S19IV19DQVBfSFQpDQogCQkgaHctPmZsYWdzIHw9
IElFRUU4MDIxMV9IV19BTVBEVV9BR0dSRUdBVElPTjsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoOWsveG1pdC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDlrL3htaXQuYw0KaW5kZXggMTI2ZWQzMS4uMmU4OGFmMSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay94bWl0LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGg5ay94bWl0LmMNCkBAIC0xMTc2LDE0ICsxMTc2LDE2IEBAIHZvaWQgYXRoX3R4
X2FnZ3Jfc2xlZXAoc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwgc3RydWN0IGF0aF9zb2Z0YyAq
c2MsDQogCWZvciAodGlkbm8gPSAwLCB0aWQgPSAmYW4tPnRpZFt0aWRub107DQogCSAgICAgdGlk
bm8gPCBXTUVfTlVNX1RJRDsgdGlkbm8rKywgdGlkKyspIHsNCiANCi0JCWlmICghdGlkLT5zY2hl
ZCkNCi0JCQljb250aW51ZTsNCi0NCiAJCWFjID0gdGlkLT5hYzsNCiAJCXR4cSA9IGFjLT50eHE7
DQogDQogCQlzcGluX2xvY2tfYmgoJnR4cS0+YXhxX2xvY2spOw0KIA0KKwkJaWYgKCF0aWQtPnNj
aGVkKSB7DQorCQkJc3Bpbl91bmxvY2tfYmgoJnR4cS0+YXhxX2xvY2spOw0KKwkJCWNvbnRpbnVl
Ow0KKwkJfQ0KKw0KIAkJYnVmZmVyZWQgPSAhc2tiX3F1ZXVlX2VtcHR5KCZ0aWQtPmJ1Zl9xKTsN
CiANCiAJCXRpZC0+c2NoZWQgPSBmYWxzZTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9iNDMveG1pdC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3htaXQuYw0KaW5kZXgg
NWY3N2NiZS4uYzZjMzRiZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My94
bWl0LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My94bWl0LmMNCkBAIC04MTksMTAg
KzgxOSwxMCBAQCB2b2lkIGI0M19yeChzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYsIHN0cnVjdCBza19i
dWZmICpza2IsIGNvbnN0IHZvaWQgKl9yeGhkcikNCiAJCSAqIGNoYW5uZWwgbnVtYmVyIGluIGI0
My4gKi8NCiAJCWlmIChjaGFuc3RhdCAmIEI0M19SWF9DSEFOXzVHSFopIHsNCiAJCQlzdGF0dXMu
YmFuZCA9IElFRUU4MDIxMV9CQU5EXzVHSFo7DQotCQkJc3RhdHVzLmZyZXEgPSBiNDNfZnJlcV90
b19jaGFubmVsXzVnaHooY2hhbmlkKTsNCisJCQlzdGF0dXMuZnJlcSA9IGI0M19jaGFubmVsX3Rv
X2ZyZXFfNWdoeihjaGFuaWQpOw0KIAkJfSBlbHNlIHsNCiAJCQlzdGF0dXMuYmFuZCA9IElFRUU4
MDIxMV9CQU5EXzJHSFo7DQotCQkJc3RhdHVzLmZyZXEgPSBiNDNfZnJlcV90b19jaGFubmVsXzJn
aHooY2hhbmlkKTsNCisJCQlzdGF0dXMuZnJlcSA9IGI0M19jaGFubmVsX3RvX2ZyZXFfMmdoeihj
aGFuaWQpOw0KIAkJfQ0KIAkJYnJlYWs7DQogCWRlZmF1bHQ6DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9pd2x3aWZpL2l3bC1hZ24tdHguYw0KaW5kZXggZGYxNTQwYy4uNWZlNDYwMiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi10eC5jDQorKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24tdHguYw0KQEAgLTg1NCw4ICs4NTQsNiBA
QCBpbnQgaXdsYWduX3J4X3JlcGx5X2NvbXByZXNzZWRfYmEoc3RydWN0IGl3bF9wcml2ICpwcml2
LA0KIAlzdHJ1Y3QgaXdsX2NvbXByZXNzZWRfYmFfcmVzcCAqYmFfcmVzcCA9ICZwa3QtPnUuY29t
cHJlc3NlZF9iYTsNCiAJc3RydWN0IGl3bF9odF9hZ2cgKmFnZzsNCiAJc3RydWN0IHNrX2J1ZmZf
aGVhZCByZWNsYWltZWRfc2ticzsNCi0Jc3RydWN0IGllZWU4MDIxMV90eF9pbmZvICppbmZvOw0K
LQlzdHJ1Y3QgaWVlZTgwMjExX2hkciAqaGRyOw0KIAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KIAl1
bnNpZ25lZCBsb25nIGZsYWdzOw0KIAlpbnQgc3RhX2lkOw0KQEAgLTk0MSwyNCArOTM5LDMyIEBA
IGludCBpd2xhZ25fcnhfcmVwbHlfY29tcHJlc3NlZF9iYShzdHJ1Y3QgaXdsX3ByaXYgKnByaXYs
DQogCQkJICAwLCAmcmVjbGFpbWVkX3NrYnMpOw0KIAlmcmVlZCA9IDA7DQogCXdoaWxlICghc2ti
X3F1ZXVlX2VtcHR5KCZyZWNsYWltZWRfc2ticykpIHsNCisJCXN0cnVjdCBpZWVlODAyMTFfaGRy
ICpoZHI7DQorCQlzdHJ1Y3QgaWVlZTgwMjExX3R4X2luZm8gKmluZm87DQogDQogCQlza2IgPSBf
X3NrYl9kZXF1ZXVlKCZyZWNsYWltZWRfc2ticyk7DQotCQloZHIgPSAoc3RydWN0IGllZWU4MDIx
MV9oZHIgKilza2ItPmRhdGE7DQorCQloZHIgPSAodm9pZCAqKXNrYi0+ZGF0YTsNCisJCWluZm8g
PSBJRUVFODAyMTFfU0tCX0NCKHNrYik7DQogDQogCQlpZiAoaWVlZTgwMjExX2lzX2RhdGFfcW9z
KGhkci0+ZnJhbWVfY29udHJvbCkpDQogCQkJZnJlZWQrKzsNCiAJCWVsc2UNCiAJCQlXQVJOX09O
X09OQ0UoMSk7DQogDQotCQlpbmZvID0gSUVFRTgwMjExX1NLQl9DQihza2IpOw0KIAkJa21lbV9j
YWNoZV9mcmVlKHByaXYtPnR4X2NtZF9wb29sLCAoaW5mby0+ZHJpdmVyX2RhdGFbMV0pKTsNCiAN
CisJCW1lbXNldCgmaW5mby0+c3RhdHVzLCAwLCBzaXplb2YoaW5mby0+c3RhdHVzKSk7DQorCQkv
KiBQYWNrZXQgd2FzIHRyYW5zbWl0dGVkIHN1Y2Nlc3NmdWxseSwgZmFpbHVyZXMgY29tZSBhcyBz
aW5nbGUNCisJCSAqIGZyYW1lcyBiZWNhdXNlIGJlZm9yZSBmYWlsaW5nIGEgZnJhbWUgdGhlIGZp
cm13YXJlIHRyYW5zbWl0cw0KKwkJICogaXQgd2l0aG91dCBhZ2dyZWdhdGlvbiBhdCBsZWFzdCBv
bmNlLg0KKwkJICovDQorCQlpbmZvLT5mbGFncyB8PSBJRUVFODAyMTFfVFhfU1RBVF9BQ0s7DQor
DQogCQlpZiAoZnJlZWQgPT0gMSkgew0KIAkJCS8qIHRoaXMgaXMgdGhlIGZpcnN0IHNrYiB3ZSBk
ZWxpdmVyIGluIHRoaXMgYmF0Y2ggKi8NCiAJCQkvKiBwdXQgdGhlIHJhdGUgc2NhbGluZyBkYXRh
IHRoZXJlICovDQogCQkJaW5mbyA9IElFRUU4MDIxMV9TS0JfQ0Ioc2tiKTsNCiAJCQltZW1zZXQo
JmluZm8tPnN0YXR1cywgMCwgc2l6ZW9mKGluZm8tPnN0YXR1cykpOw0KLQkJCWluZm8tPmZsYWdz
IHw9IElFRUU4MDIxMV9UWF9TVEFUX0FDSzsNCiAJCQlpbmZvLT5mbGFncyB8PSBJRUVFODAyMTFf
VFhfU1RBVF9BTVBEVTsNCiAJCQlpbmZvLT5zdGF0dXMuYW1wZHVfYWNrX2xlbiA9IGJhX3Jlc3At
PnR4ZWRfMl9kb25lOw0KIAkJCWluZm8tPnN0YXR1cy5hbXBkdV9sZW4gPSBiYV9yZXNwLT50eGVk
Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvMTFuLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4LzExbi5jDQppbmRleCAzNGJiYTUyLi42NTQzZjRmIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC8xMW4uYw0KKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC8xMW4uYw0KQEAgLTM0Myw4ICszNDMsNyBAQCBtd2lm
aWV4X2NtZF9hcHBlbmRfMTFuX3RsdihzdHJ1Y3QgbXdpZmlleF9wcml2YXRlICpwcml2LA0KIAkJ
aHRfY2FwLT5oZWFkZXIubGVuID0NCiAJCQkJY3B1X3RvX2xlMTYoc2l6ZW9mKHN0cnVjdCBpZWVl
ODAyMTFfaHRfY2FwKSk7DQogCQltZW1jcHkoKHU4ICopIGh0X2NhcCArIHNpemVvZihzdHJ1Y3Qg
bXdpZmlleF9pZV90eXBlc19oZWFkZXIpLA0KLQkJICAgICAgICh1OCAqKSBic3NfZGVzYy0+YmNu
X2h0X2NhcCArDQotCQkgICAgICAgc2l6ZW9mKHN0cnVjdCBpZWVlX3R5cGVzX2hlYWRlciksDQor
CQkgICAgICAgKHU4ICopYnNzX2Rlc2MtPmJjbl9odF9jYXAsDQogCQkgICAgICAgbGUxNl90b19j
cHUoaHRfY2FwLT5oZWFkZXIubGVuKSk7DQogDQogCQltd2lmaWV4X2ZpbGxfY2FwX2luZm8ocHJp
diwgcmFkaW9fdHlwZSwgaHRfY2FwKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9ydGw4MTh4L3J0bDgxODcvcnRsODE4Ny5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsODE4
eC9ydGw4MTg3L3J0bDgxODcuaA0KaW5kZXggZjFjYzkwNy4uNmQzZDY1MyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bDgxOHgvcnRsODE4Ny9ydGw4MTg3LmgNCisrKyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3J0bDgxOHgvcnRsODE4Ny9ydGw4MTg3LmgNCkBAIC0xNSw2ICsx
NSw4IEBADQogI2lmbmRlZiBSVEw4MTg3X0gNCiAjZGVmaW5lIFJUTDgxODdfSA0KIA0KKyNpbmNs
dWRlIDxsaW51eC9jYWNoZS5oPg0KKw0KICNpbmNsdWRlICJydGw4MTh4LmgiDQogI2luY2x1ZGUg
ImxlZHMuaCINCiANCkBAIC0xMzEsNyArMTMzLDEwIEBAIHN0cnVjdCBydGw4MTg3X3ByaXYgew0K
IAl1OCBhaWZzbls0XTsNCiAJdTggcmZraWxsX21hc2s7DQogCXN0cnVjdCB7DQotCQlfX2xlNjQg
YnVmOw0KKwkJdW5pb24gew0KKwkJCV9fbGU2NCBidWY7DQorCQkJdTggZHVtbXkxW0wxX0NBQ0hF
X0JZVEVTXTsNCisJCX0gX19fX2NhY2hlbGluZV9hbGlnbmVkOw0KIAkJc3RydWN0IHNrX2J1ZmZf
aGVhZCBxdWV1ZTsNCiAJfSBiX3R4X3N0YXR1czsgLyogVGhpcyBxdWV1ZSBpcyB1c2VkIGJ5IGJv
dGggLWIgYW5kIG5vbi1iIGRldmljZXMgKi8NCiAJc3RydWN0IG11dGV4IGlvX211dGV4Ow0KQEAg
LTEzOSw3ICsxNDQsOCBAQCBzdHJ1Y3QgcnRsODE4N19wcml2IHsNCiAJCXU4IGJpdHM4Ow0KIAkJ
X19sZTE2IGJpdHMxNjsNCiAJCV9fbGUzMiBiaXRzMzI7DQotCX0gKmlvX2RtYWJ1ZjsNCisJCXU4
IGR1bW15MltMMV9DQUNIRV9CWVRFU107DQorCX0gKmlvX2RtYWJ1ZiBfX19fY2FjaGVsaW5lX2Fs
aWduZWQ7DQogCWJvb2wgcmZraWxsX29mZjsNCiB9Ow0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3J0bHdpZmkvY29yZS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lm
aS9jb3JlLmMNCmluZGV4IDNmMGYwNTYuLjRmYTk4N2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9ydGx3aWZpL2NvcmUuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRs
d2lmaS9jb3JlLmMNCkBAIC0xMzEsNiArMTMxLDcgQEAgc3RhdGljIGludCBydGxfb3BfYWRkX2lu
dGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCiAJCQkJCXJ0bHByaXYtPmNmZy0+bWFw
cw0KIAkJCQkJW1JUTF9JQlNTX0lOVF9NQVNLU10pOw0KIAkJfQ0KKwkJbWFjLT5saW5rX3N0YXRl
ID0gTUFDODAyMTFfTElOS0VEOw0KIAkJYnJlYWs7DQogCWNhc2UgTkw4MDIxMV9JRlRZUEVfQURI
T0M6DQogCQlSVF9UUkFDRShydGxwcml2LCBDT01QX01BQzgwMjExLCBEQkdfTE9VRCwNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJjZS9ody5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY2UvaHcuYw0KaW5kZXggY2I0ODBkOC4u
Y2UxZmRiZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5
MmNlL2h3LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmNlL2h3
LmMNCkBAIC05MDUsMTQgKzkwNSwyNiBAQCBpbnQgcnRsOTJjZV9od19pbml0KHN0cnVjdCBpZWVl
ODAyMTFfaHcgKmh3KQ0KIAlib29sIGlzOTJjOw0KIAlpbnQgZXJyOw0KIAl1OCB0bXBfdTFiOw0K
Kwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIA0KIAlydGxwY2ktPmJlaW5nX2luaXRfYWRhcHRlciA9
IHRydWU7DQorDQorCS8qIFNpbmNlIHRoaXMgZnVuY3Rpb24gY2FuIHRha2UgYSB2ZXJ5IGxvbmcg
dGltZSAodXAgdG8gMzUwIG1zKQ0KKwkgKiBhbmQgY2FuIGJlIGNhbGxlZCB3aXRoIGlycXMgZGlz
YWJsZWQsIHJlZW5hYmxlIHRoZSBpcnFzDQorCSAqIHRvIGxldCB0aGUgb3RoZXIgZGV2aWNlcyBj
b250aW51ZSBiZWluZyBzZXJ2aWNlZC4NCisJICoNCisJICogSXQgaXMgc2FmZSBkb2luZyBzbyBz
aW5jZSBvdXIgb3duIGludGVycnVwdHMgd2lsbCBvbmx5IGJlIGVuYWJsZWQNCisJICogaW4gYSBz
dWJzZXF1ZW50IHN0ZXAuDQorCSAqLw0KKwlsb2NhbF9zYXZlX2ZsYWdzKGZsYWdzKTsNCisJbG9j
YWxfaXJxX2VuYWJsZSgpOw0KKw0KIAlydGxwcml2LT5pbnRmX29wcy0+ZGlzYWJsZV9hc3BtKGh3
KTsNCiAJcnRzdGF0dXMgPSBfcnRsOTJjZV9pbml0X21hYyhodyk7DQogCWlmIChydHN0YXR1cyAh
PSB0cnVlKSB7DQogCQlSVF9UUkFDRShydGxwcml2LCBDT01QX0VSUiwgREJHX0VNRVJHLCAoIklu
aXQgTUFDIGZhaWxlZFxuIikpOw0KIAkJZXJyID0gMTsNCi0JCXJldHVybiBlcnI7DQorCQlnb3Rv
IGV4aXQ7DQogCX0NCiANCiAJZXJyID0gcnRsOTJjX2Rvd25sb2FkX2Z3KGh3KTsNCkBAIC05MjIs
NyArOTM0LDcgQEAgaW50IHJ0bDkyY2VfaHdfaW5pdChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykN
CiAJCQkgICJ3aXRob3V0IEZXIG5vdy4uXG4iKSk7DQogCQllcnIgPSAxOw0KIAkJcnRsaGFsLT5m
d19yZWFkeSA9IGZhbHNlOw0KLQkJcmV0dXJuIGVycjsNCisJCWdvdG8gZXhpdDsNCiAJfSBlbHNl
IHsNCiAJCXJ0bGhhbC0+ZndfcmVhZHkgPSB0cnVlOw0KIAl9DQpAQCAtOTg1LDYgKzk5Nyw4IEBA
IGludCBydGw5MmNlX2h3X2luaXQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQogCQlSVF9UUkFD
RShydGxwcml2LCBDT01QX0lOSVQsIERCR19UUkFDRSwgKCJ1bmRlciAxLjVWXG4iKSk7DQogCX0N
CiAJcnRsOTJjX2RtX2luaXQoaHcpOw0KK2V4aXQ6DQorCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdz
KTsNCiAJcnRscGNpLT5iZWluZ19pbml0X2FkYXB0ZXIgPSBmYWxzZTsNCiAJcmV0dXJuIGVycjsN
CiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3Uv
cmYuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L3JmLmMNCmluZGV4
IDE3YThlOTYuLmQ5ODQ4NjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL3J0bDgxOTJjdS9yZi5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0
bDgxOTJjdS9yZi5jDQpAQCAtODUsMTcgKzg1LDE1IEBAIHZvaWQgcnRsOTJjdV9waHlfcmY2MDUy
X3NldF9jY2tfdHhwb3dlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCiAJaWYgKG1hYy0+YWN0
X3NjYW5uaW5nKSB7DQogCQl0eF9hZ2NbUkY5MF9QQVRIX0FdID0gMHgzZjNmM2YzZjsNCiAJCXR4
X2FnY1tSRjkwX1BBVEhfQl0gPSAweDNmM2YzZjNmOw0KLQkJaWYgKHR1cmJvX3NjYW5vZmYpIHsN
Ci0JCQlmb3IgKGlkeDEgPSBSRjkwX1BBVEhfQTsgaWR4MSA8PSBSRjkwX1BBVEhfQjsgaWR4MSsr
KSB7DQotCQkJCXR4X2FnY1tpZHgxXSA9IHBwb3dlcmxldmVsW2lkeDFdIHwNCi0JCQkJICAgIChw
cG93ZXJsZXZlbFtpZHgxXSA8PCA4KSB8DQotCQkJCSAgICAocHBvd2VybGV2ZWxbaWR4MV0gPDwg
MTYpIHwNCi0JCQkJICAgIChwcG93ZXJsZXZlbFtpZHgxXSA8PCAyNCk7DQotCQkJCWlmIChydGxo
YWwtPmludGVyZmFjZSA9PSBJTlRGX1VTQikgew0KLQkJCQkJaWYgKHR4X2FnY1tpZHgxXSA+IDB4
MjAgJiYNCi0JCQkJCSAgICBydGxlZnVzZS0+ZXh0ZXJuYWxfcGEpDQotCQkJCQkJdHhfYWdjW2lk
eDFdID0gMHgyMDsNCi0JCQkJfQ0KKwkJZm9yIChpZHgxID0gUkY5MF9QQVRIX0E7IGlkeDEgPD0g
UkY5MF9QQVRIX0I7IGlkeDErKykgew0KKwkJCXR4X2FnY1tpZHgxXSA9IHBwb3dlcmxldmVsW2lk
eDFdIHwNCisJCQkgICAgKHBwb3dlcmxldmVsW2lkeDFdIDw8IDgpIHwNCisJCQkgICAgKHBwb3dl
cmxldmVsW2lkeDFdIDw8IDE2KSB8DQorCQkJICAgIChwcG93ZXJsZXZlbFtpZHgxXSA8PCAyNCk7
DQorCQkJaWYgKHJ0bGhhbC0+aW50ZXJmYWNlID09IElOVEZfVVNCKSB7DQorCQkJCWlmICh0eF9h
Z2NbaWR4MV0gPiAweDIwICYmDQorCQkJCSAgICBydGxlZnVzZS0+ZXh0ZXJuYWxfcGEpDQorCQkJ
CQl0eF9hZ2NbaWR4MV0gPSAweDIwOw0KIAkJCX0NCiAJCX0NCiAJfSBlbHNlIHsNCkBAIC0xMDcs
NyArMTA1LDcgQEAgdm9pZCBydGw5MmN1X3BoeV9yZjYwNTJfc2V0X2Nja190eHBvd2VyKHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3LA0KIAkJCSAgIFRYSElHSFBXUkxFVkVMX0xFVkVMMikgew0KIAkJ
CXR4X2FnY1tSRjkwX1BBVEhfQV0gPSAweDAwMDAwMDAwOw0KIAkJCXR4X2FnY1tSRjkwX1BBVEhf
Ql0gPSAweDAwMDAwMDAwOw0KLQkJfSBlbHNlew0KKwkJfSBlbHNlIHsNCiAJCQlmb3IgKGlkeDEg
PSBSRjkwX1BBVEhfQTsgaWR4MSA8PSBSRjkwX1BBVEhfQjsgaWR4MSsrKSB7DQogCQkJCXR4X2Fn
Y1tpZHgxXSA9IHBwb3dlcmxldmVsW2lkeDFdIHwNCiAJCQkJICAgIChwcG93ZXJsZXZlbFtpZHgx
XSA8PCA4KSB8DQpAQCAtMzgwLDcgKzM3OCwxMiBAQCBzdGF0aWMgdm9pZCBfcnRsOTJjX3dyaXRl
X29mZG1fcG93ZXJfcmVnKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAkJCSAgICByZWdvZmZz
ZXQgPT0gUlRYQUdDX0JfTUNTMDdfTUNTMDQpDQogCQkJCXJlZ29mZnNldCA9IDB4Yzk4Ow0KIAkJ
CWZvciAoaSA9IDA7IGkgPCAzOyBpKyspIHsNCi0JCQkJd3JpdGVWYWwgPSAod3JpdGVWYWwgPiA2
KSA/ICh3cml0ZVZhbCAtIDYpIDogMDsNCisJCQkJaWYgKGkgIT0gMikNCisJCQkJCXdyaXRlVmFs
ID0gKHdyaXRlVmFsID4gOCkgPw0KKwkJCQkJCSAgICh3cml0ZVZhbCAtIDgpIDogMDsNCisJCQkJ
ZWxzZQ0KKwkJCQkJd3JpdGVWYWwgPSAod3JpdGVWYWwgPiA2KSA/DQorCQkJCQkJICAgKHdyaXRl
VmFsIC0gNikgOiAwOw0KIAkJCQlydGxfd3JpdGVfYnl0ZShydGxwcml2LCAodTMyKShyZWdvZmZz
ZXQgKyBpKSwNCiAJCQkJCSAgICAgICh1OCl3cml0ZVZhbCk7DQogCQkJfQ0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L3N3LmMgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJjdS9zdy5jDQppbmRleCAwMTZlZjg2Li5jMTg0MjUz
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3Uvc3cu
Yw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3Uvc3cuYw0KQEAg
LTMxNiw2ICszMTYsNyBAQCBzdGF0aWMgc3RydWN0IHVzYl9kZXZpY2VfaWQgcnRsODE5MmNfdXNi
X2lkc1tdID0gew0KIAl7UlRMX1VTQl9ERVZJQ0UoMHgwYmRhLCAweDUwODgsIHJ0bDkyY3VfaGFs
X2NmZyl9LCAvKlRoaW5rd2FyZS1DQyZDKi8NCiAJe1JUTF9VU0JfREVWSUNFKDB4MGRmNiwgMHgw
MDUyLCBydGw5MmN1X2hhbF9jZmcpfSwgLypTaXRlY29tIC0gRWRpbWF4Ki8NCiAJe1JUTF9VU0Jf
REVWSUNFKDB4MGRmNiwgMHgwMDVjLCBydGw5MmN1X2hhbF9jZmcpfSwgLypTaXRlY29tIC0gRWRp
bWF4Ki8NCisJe1JUTF9VU0JfREVWSUNFKDB4MGRmNiwgMHgwMDc3LCBydGw5MmN1X2hhbF9jZmcp
fSwgLypTaXRlY29tLVdMQTIxMDBWMiovDQogCXtSVExfVVNCX0RFVklDRSgweDBlYjAsIDB4OTA3
MSwgcnRsOTJjdV9oYWxfY2ZnKX0sIC8qTk8gQnJhbmQgLSBFdG9wKi8NCiAJe1JUTF9VU0JfREVW
SUNFKDB4NDg1NiwgMHgwMDkxLCBydGw5MmN1X2hhbF9jZmcpfSwgLypOZXR3ZWVOIC0gRmVpeHVu
Ki8NCiAJLyogSFAgLSBMaXRlLU9uICw4MTg4Q1VTIFNsaW0gQ29tYm8gKi8NCmRpZmYgLS1naXQg
YS9kcml2ZXJzL29mL2FkZHJlc3MuYyBiL2RyaXZlcnMvb2YvYWRkcmVzcy5jDQppbmRleCA3MmMz
M2ZiLi40NWMxNzI3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9vZi9hZGRyZXNzLmMNCisrKyBiL2Ry
aXZlcnMvb2YvYWRkcmVzcy5jDQpAQCAtOTcsOCArOTcsMTMgQEAgc3RhdGljIHVuc2lnbmVkIGlu
dCBvZl9idXNfZGVmYXVsdF9nZXRfZmxhZ3MoY29uc3QgX19iZTMyICphZGRyKQ0KIA0KIHN0YXRp
YyBpbnQgb2ZfYnVzX3BjaV9tYXRjaChzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wKQ0KIHsNCi0JLyog
InZjaSIgaXMgZm9yIHRoZSAvY2hhb3MgYnJpZGdlIG9uIDFzdC1nZW4gUENJIHBvd2VybWFjcyAq
Lw0KLQlyZXR1cm4gIXN0cmNtcChucC0+dHlwZSwgInBjaSIpIHx8ICFzdHJjbXAobnAtPnR5cGUs
ICJ2Y2kiKTsNCisJLyoNCisgCSAqICJwY2lleCIgaXMgUENJIEV4cHJlc3MNCisJICogInZjaSIg
aXMgZm9yIHRoZSAvY2hhb3MgYnJpZGdlIG9uIDFzdC1nZW4gUENJIHBvd2VybWFjcw0KKwkgKiAi
aHQiIGlzIGh5cGVydHJhbnNwb3J0DQorCSAqLw0KKwlyZXR1cm4gIXN0cmNtcChucC0+dHlwZSwg
InBjaSIpIHx8ICFzdHJjbXAobnAtPnR5cGUsICJwY2lleCIpIHx8DQorCQkhc3RyY21wKG5wLT50
eXBlLCAidmNpIikgfHwgIXN0cmNtcChucC0+dHlwZSwgImh0Iik7DQogfQ0KIA0KIHN0YXRpYyB2
b2lkIG9mX2J1c19wY2lfY291bnRfY2VsbHMoc3RydWN0IGRldmljZV9ub2RlICpucCwNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3BhcnBvcnQvcGFycG9ydF9wYy5jIGIvZHJpdmVycy9wYXJwb3J0L3Bh
cnBvcnRfcGMuYw0KaW5kZXggZDBiNTk3Yi4uNWE0NDMyZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
cGFycG9ydC9wYXJwb3J0X3BjLmMNCisrKyBiL2RyaXZlcnMvcGFycG9ydC9wYXJwb3J0X3BjLmMN
CkBAIC0yODc1LDggKzI4NzUsNiBAQCBlbnVtIHBhcnBvcnRfcGNfcGNpX2NhcmRzIHsNCiAJc3li
YV8ycF9lcHAsDQogCXN5YmFfMXBfZWNwLA0KIAl0aXRhbl8wMTBsLA0KLQl0aXRhbl8xMjg0cDEs
DQotCXRpdGFuXzEyODRwMiwNCiAJYXZsYWJfMXAsDQogCWF2bGFiXzJwLA0KIAlveHNlbWlfOTUy
LA0KQEAgLTI5MzUsOCArMjkzMyw2IEBAIHN0YXRpYyBzdHJ1Y3QgcGFycG9ydF9wY19wY2kgew0K
IAkvKiBzeWJhXzJwX2VwcCBBUDEzOEIgKi8JeyAyLCB7IHsgMCwgMHgwNzggfSwgeyAwLCAweDE3
OCB9LCB9IH0sDQogCS8qIHN5YmFfMXBfZWNwIFc4Mzc4NyAqLwl7IDEsIHsgeyAwLCAweDA3OCB9
LCB9IH0sDQogCS8qIHRpdGFuXzAxMGwgKi8JCXsgMSwgeyB7IDMsIC0xIH0sIH0gfSwNCi0JLyog
dGl0YW5fMTI4NHAxICovICAgICAgICAgICAgICB7IDEsIHsgeyAwLCAxIH0sIH0gfSwNCi0JLyog
dGl0YW5fMTI4NHAyICovCQl7IDIsIHsgeyAwLCAxIH0sIHsgMiwgMyB9LCB9IH0sDQogCS8qIGF2
bGFiXzFwCQkqLwl7IDEsIHsgeyAwLCAxfSwgfSB9LA0KIAkvKiBhdmxhYl8ycAkJKi8JeyAyLCB7
IHsgMCwgMX0sIHsgMiwgMyB9LH0gfSwNCiAJLyogVGhlIE94Zm9yZCBTZW1pIGNhcmRzIGFyZSB1
bnVzdWFsOiA5NTQgZG9lc24ndCBzdXBwb3J0IEVDUCwNCkBAIC0yOTUyLDggKzI5NDgsOCBAQCBz
dGF0aWMgc3RydWN0IHBhcnBvcnRfcGNfcGNpIHsNCiAJLyogbmV0bW9zXzk3MDUgKi8gICAgICAg
ICAgICAgICB7IDEsIHsgeyAwLCAtMSB9LCB9IH0sDQogCS8qIG5ldG1vc185NzE1ICovICAgICAg
ICAgICAgICAgeyAyLCB7IHsgMCwgMSB9LCB7IDIsIDMgfSx9IH0sDQogCS8qIG5ldG1vc185NzU1
ICovICAgICAgICAgICAgICAgeyAyLCB7IHsgMCwgMSB9LCB7IDIsIDMgfSx9IH0sDQotCS8qIG5l
dG1vc185ODA1ICovICAgICAgICAgICAgICAgeyAxLCB7IHsgMCwgLTEgfSwgfSB9LA0KLQkvKiBu
ZXRtb3NfOTgxNSAqLyAgICAgICAgICAgICAgIHsgMiwgeyB7IDAsIC0xIH0sIHsgMiwgLTEgfSwg
fSB9LA0KKwkvKiBuZXRtb3NfOTgwNSAqLwkJeyAxLCB7IHsgMCwgMSB9LCB9IH0sDQorCS8qIG5l
dG1vc185ODE1ICovCQl7IDIsIHsgeyAwLCAxIH0sIHsgMiwgMyB9LCB9IH0sDQogCS8qIG5ldG1v
c185OTAxICovICAgICAgICAgICAgICAgeyAxLCB7IHsgMCwgLTEgfSwgfSB9LA0KIAkvKiBuZXRt
b3NfOTg2NSAqLyAgICAgICAgICAgICAgIHsgMSwgeyB7IDAsIC0xIH0sIH0gfSwNCiAJLyogcXVh
dGVjaF9zcHB4cDEwMCAqLwkJeyAxLCB7IHsgMCwgMSB9LCB9IH0sDQpAQCAtMjk5Nyw4ICsyOTkz
LDYgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkIHBhcnBvcnRfcGNfcGNpX3Ri
bFtdID0gew0KIAkgIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIHN5YmFfMXBfZWNwIH0s
DQogCXsgUENJX1ZFTkRPUl9JRF9USVRBTiwgUENJX0RFVklDRV9JRF9USVRBTl8wMTBMLA0KIAkg
IFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIHRpdGFuXzAxMGwgfSwNCi0JeyAweDk3MTAs
IDB4OTgwNSwgMHgxMDAwLCAweDAwMTAsIDAsIDAsIHRpdGFuXzEyODRwMSB9LA0KLQl7IDB4OTcx
MCwgMHg5ODE1LCAweDEwMDAsIDB4MDAyMCwgMCwgMCwgdGl0YW5fMTI4NHAyIH0sDQogCS8qIFBD
SV9WRU5ET1JfSURfQVZMQUIvSW50ZWsyMSBoYXMgYW5vdGhlciBidW5jaCBvZiBjYXJkcyAuLi4q
Lw0KIAkvKiBBRkFWTEFCX1RLOTkwMiAqLw0KIAl7IDB4MTRkYiwgMHgyMTIwLCBQQ0lfQU5ZX0lE
LCBQQ0lfQU5ZX0lELCAwLCAwLCBhdmxhYl8xcH0sDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kv
cGNpLmMgYi9kcml2ZXJzL3BjaS9wY2kuYw0KaW5kZXggOWYxZmVjMS4uNGMzYTllOSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvcGNpL3BjaS5jDQorKysgYi9kcml2ZXJzL3BjaS9wY2kuYw0KQEAgLTEw
NzgsNiArMTA3OCw4IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHBjaV9sb2FkX2FuZF9mcmVlX3NhdmVk
X3N0YXRlKTsNCiBzdGF0aWMgaW50IGRvX3BjaV9lbmFibGVfZGV2aWNlKHN0cnVjdCBwY2lfZGV2
ICpkZXYsIGludCBiYXJzKQ0KIHsNCiAJaW50IGVycjsNCisJdTE2IGNtZDsNCisJdTggcGluOw0K
IA0KIAllcnIgPSBwY2lfc2V0X3Bvd2VyX3N0YXRlKGRldiwgUENJX0QwKTsNCiAJaWYgKGVyciA8
IDAgJiYgZXJyICE9IC1FSU8pDQpAQCAtMTA4Nyw2ICsxMDg5LDE3IEBAIHN0YXRpYyBpbnQgZG9f
cGNpX2VuYWJsZV9kZXZpY2Uoc3RydWN0IHBjaV9kZXYgKmRldiwgaW50IGJhcnMpDQogCQlyZXR1
cm4gZXJyOw0KIAlwY2lfZml4dXBfZGV2aWNlKHBjaV9maXh1cF9lbmFibGUsIGRldik7DQogDQor
CWlmIChkZXYtPm1zaV9lbmFibGVkIHx8IGRldi0+bXNpeF9lbmFibGVkKQ0KKwkJcmV0dXJuIDA7
DQorDQorCXBjaV9yZWFkX2NvbmZpZ19ieXRlKGRldiwgUENJX0lOVEVSUlVQVF9QSU4sICZwaW4p
Ow0KKwlpZiAocGluKSB7DQorCQlwY2lfcmVhZF9jb25maWdfd29yZChkZXYsIFBDSV9DT01NQU5E
LCAmY21kKTsNCisJCWlmIChjbWQgJiBQQ0lfQ09NTUFORF9JTlRYX0RJU0FCTEUpDQorCQkJcGNp
X3dyaXRlX2NvbmZpZ193b3JkKGRldiwgUENJX0NPTU1BTkQsDQorCQkJCQkgICAgICBjbWQgJiB+
UENJX0NPTU1BTkRfSU5UWF9ESVNBQkxFKTsNCisJfQ0KKw0KIAlyZXR1cm4gMDsNCiB9DQogDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9wbGF0Zm9ybS94ODYvaHBfYWNjZWwuYyBiL2RyaXZlcnMvcGxh
dGZvcm0veDg2L2hwX2FjY2VsLmMNCmluZGV4IGZkYWNmY2UuLjAwNzZmZWEgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3BsYXRmb3JtL3g4Ni9ocF9hY2NlbC5jDQorKysgYi9kcml2ZXJzL3BsYXRmb3Jt
L3g4Ni9ocF9hY2NlbC5jDQpAQCAtNzcsNiArNzcsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgZGVs
YXllZF9zeXNmc19zZXQoc3RydWN0IGxlZF9jbGFzc2RldiAqbGVkX2NkZXYsDQogc3RhdGljIHN0
cnVjdCBhY3BpX2RldmljZV9pZCBsaXMzbHYwMmRfZGV2aWNlX2lkc1tdID0gew0KIAl7IkhQUTAw
MDQiLCAwfSwgLyogSFAgTW9iaWxlIERhdGEgUHJvdGVjdGlvbiBTeXN0ZW0gUE5QICovDQogCXsi
SFBRNjAwMCIsIDB9LCAvKiBIUCBNb2JpbGUgRGF0YSBQcm90ZWN0aW9uIFN5c3RlbSBQTlAgKi8N
CisJeyJIUFE2MDA3IiwgMH0sIC8qIEhQIE1vYmlsZSBEYXRhIFByb3RlY3Rpb24gU3lzdGVtIFBO
UCAqLw0KIAl7IiIsIDB9LA0KIH07DQogTU9EVUxFX0RFVklDRV9UQUJMRShhY3BpLCBsaXMzbHYw
MmRfZGV2aWNlX2lkcyk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wb3dlci9tYXgxNzA0MF9iYXR0
ZXJ5LmMgYi9kcml2ZXJzL3Bvd2VyL21heDE3MDQwX2JhdHRlcnkuYw0KaW5kZXggMmYyZjlhNi4u
MzlkMzY5NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvcG93ZXIvbWF4MTcwNDBfYmF0dGVyeS5jDQor
KysgYi9kcml2ZXJzL3Bvd2VyL21heDE3MDQwX2JhdHRlcnkuYw0KQEAgLTE0OCw3ICsxNDgsNyBA
QCBzdGF0aWMgdm9pZCBtYXgxNzA0MF9nZXRfb25saW5lKHN0cnVjdCBpMmNfY2xpZW50ICpjbGll
bnQpDQogew0KIAlzdHJ1Y3QgbWF4MTcwNDBfY2hpcCAqY2hpcCA9IGkyY19nZXRfY2xpZW50ZGF0
YShjbGllbnQpOw0KIA0KLQlpZiAoY2hpcC0+cGRhdGEtPmJhdHRlcnlfb25saW5lKQ0KKwlpZiAo
Y2hpcC0+cGRhdGEgJiYgY2hpcC0+cGRhdGEtPmJhdHRlcnlfb25saW5lKQ0KIAkJY2hpcC0+b25s
aW5lID0gY2hpcC0+cGRhdGEtPmJhdHRlcnlfb25saW5lKCk7DQogCWVsc2UNCiAJCWNoaXAtPm9u
bGluZSA9IDE7DQpAQCAtMTU4LDcgKzE1OCw4IEBAIHN0YXRpYyB2b2lkIG1heDE3MDQwX2dldF9z
dGF0dXMoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCkNCiB7DQogCXN0cnVjdCBtYXgxNzA0MF9j
aGlwICpjaGlwID0gaTJjX2dldF9jbGllbnRkYXRhKGNsaWVudCk7DQogDQotCWlmICghY2hpcC0+
cGRhdGEtPmNoYXJnZXJfb25saW5lIHx8ICFjaGlwLT5wZGF0YS0+Y2hhcmdlcl9lbmFibGUpIHsN
CisJaWYgKCFjaGlwLT5wZGF0YSB8fCAhY2hpcC0+cGRhdGEtPmNoYXJnZXJfb25saW5lDQorCQkJ
fHwgIWNoaXAtPnBkYXRhLT5jaGFyZ2VyX2VuYWJsZSkgew0KIAkJY2hpcC0+c3RhdHVzID0gUE9X
RVJfU1VQUExZX1NUQVRVU19VTktOT1dOOw0KIAkJcmV0dXJuOw0KIAl9DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ydGMvcnRjLWNtb3MuYyBiL2RyaXZlcnMvcnRjL3J0Yy1jbW9zLmMNCmluZGV4IGUz
ZWVkMTguLmNhZTg5ODUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3J0Yy9ydGMtY21vcy5jDQorKysg
Yi9kcml2ZXJzL3J0Yy9ydGMtY21vcy5jDQpAQCAtMzQsMTEgKzM0LDExIEBADQogI2luY2x1ZGUg
PGxpbnV4L2ludGVycnVwdC5oPg0KICNpbmNsdWRlIDxsaW51eC9zcGlubG9jay5oPg0KICNpbmNs
dWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4NCi0jaW5jbHVkZSA8bGludXgvbW9kX2Rldmlj
ZXRhYmxlLmg+DQogI2luY2x1ZGUgPGxpbnV4L2xvZzIuaD4NCiAjaW5jbHVkZSA8bGludXgvcG0u
aD4NCiAjaW5jbHVkZSA8bGludXgvb2YuaD4NCiAjaW5jbHVkZSA8bGludXgvb2ZfcGxhdGZvcm0u
aD4NCisjaW5jbHVkZSA8bGludXgvZG1pLmg+DQogDQogLyogdGhpcyBpcyBmb3IgImdlbmVyaWMg
YWNjZXNzIHRvIFBDLXN0eWxlIFJUQyIgdXNpbmcgQ01PU19SRUFEL0NNT1NfV1JJVEUgKi8NCiAj
aW5jbHVkZSA8YXNtLWdlbmVyaWMvcnRjLmg+DQpAQCAtMzc3LDYgKzM3Nyw1MSBAQCBzdGF0aWMg
aW50IGNtb3Nfc2V0X2FsYXJtKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IHJ0Y193a2Fscm0g
KnQpDQogCXJldHVybiAwOw0KIH0NCiANCisvKg0KKyAqIERvIG5vdCBkaXNhYmxlIFJUQyBhbGFy
bSBvbiBzaHV0ZG93biAtIHdvcmthcm91bmQgZm9yIGIwcmtlZCBCSU9TZXMuDQorICovDQorc3Rh
dGljIGJvb2wgYWxhcm1fZGlzYWJsZV9xdWlyazsNCisNCitzdGF0aWMgaW50IF9faW5pdCBzZXRf
YWxhcm1fZGlzYWJsZV9xdWlyayhjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCAqaWQpDQorew0K
KwlhbGFybV9kaXNhYmxlX3F1aXJrID0gdHJ1ZTsNCisJcHJfaW5mbygicnRjLWNtb3M6IEJJT1Mg
aGFzIGFsYXJtLWRpc2FibGUgcXVpcmsuICIpOw0KKwlwcl9pbmZvKCJSVEMgYWxhcm1zIGRpc2Fi
bGVkXG4iKTsNCisJcmV0dXJuIDA7DQorfQ0KKw0KK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZG1pX3N5
c3RlbV9pZCBydGNfcXVpcmtzW10gX19pbml0Y29uc3QgPSB7DQorCS8qIGh0dHBzOi8vYnVnemls
bGEubm92ZWxsLmNvbS9zaG93X2J1Zy5jZ2k/aWQ9ODA1NzQwICovDQorCXsNCisJCS5jYWxsYmFj
ayA9IHNldF9hbGFybV9kaXNhYmxlX3F1aXJrLA0KKwkJLmlkZW50ICAgID0gIklCTSBUcnVtYW4i
LA0KKwkJLm1hdGNoZXMgID0gew0KKwkJCURNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIlRPU0hJ
QkEiKSwNCisJCQlETUlfTUFUQ0goRE1JX1BST0RVQ1RfTkFNRSwgIjQ4NTI1NzAiKSwNCisJCX0s
DQorCX0sDQorCS8qIGh0dHBzOi8vYnVnemlsbGEubm92ZWxsLmNvbS9zaG93X2J1Zy5jZ2k/aWQ9
ODEyNTkyICovDQorCXsNCisJCS5jYWxsYmFjayA9IHNldF9hbGFybV9kaXNhYmxlX3F1aXJrLA0K
KwkJLmlkZW50ICAgID0gIkdpZ2FieXRlIEdBLTk5MFhBLVVEMyIsDQorCQkubWF0Y2hlcyAgPSB7
DQorCQkJRE1JX01BVENIKERNSV9TWVNfVkVORE9SLA0KKwkJCQkJIkdpZ2FieXRlIFRlY2hub2xv
Z3kgQ28uLCBMdGQuIiksDQorCQkJRE1JX01BVENIKERNSV9QUk9EVUNUX05BTUUsICJHQS05OTBY
QS1VRDMiKSwNCisJCX0sDQorCX0sDQorCS8qIGh0dHA6Ly9wZXJtYWxpbmsuZ21hbmUub3JnL2dt
YW5lLmxpbnV4Lmtlcm5lbC8xNjA0NDc0ICovDQorCXsNCisJCS5jYWxsYmFjayA9IHNldF9hbGFy
bV9kaXNhYmxlX3F1aXJrLA0KKwkJLmlkZW50ICAgID0gIlRvc2hpYmEgU2F0ZWxsaXRlIEwzMDAi
LA0KKwkJLm1hdGNoZXMgID0gew0KKwkJCURNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIlRPU0hJ
QkEiKSwNCisJCQlETUlfTUFUQ0goRE1JX1BST0RVQ1RfTkFNRSwgIlNhdGVsbGl0ZSBMMzAwIiks
DQorCQl9LA0KKwl9LA0KKwl7fQ0KK307DQorDQogc3RhdGljIGludCBjbW9zX2FsYXJtX2lycV9l
bmFibGUoc3RydWN0IGRldmljZSAqZGV2LCB1bnNpZ25lZCBpbnQgZW5hYmxlZCkNCiB7DQogCXN0
cnVjdCBjbW9zX3J0YwkqY21vcyA9IGRldl9nZXRfZHJ2ZGF0YShkZXYpOw0KQEAgLTM4NSw2ICs0
MzAsOSBAQCBzdGF0aWMgaW50IGNtb3NfYWxhcm1faXJxX2VuYWJsZShzdHJ1Y3QgZGV2aWNlICpk
ZXYsIHVuc2lnbmVkIGludCBlbmFibGVkKQ0KIAlpZiAoIWlzX3ZhbGlkX2lycShjbW9zLT5pcnEp
KQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQorCWlmIChhbGFybV9kaXNhYmxlX3F1aXJrKQ0KKwkJ
cmV0dXJuIDA7DQorDQogCXNwaW5fbG9ja19pcnFzYXZlKCZydGNfbG9jaywgZmxhZ3MpOw0KIA0K
IAlpZiAoZW5hYmxlZCkNCkBAIC0xMTY2LDYgKzEyMTQsOCBAQCBzdGF0aWMgaW50IF9faW5pdCBj
bW9zX2luaXQodm9pZCkNCiAJCQlwbGF0Zm9ybV9kcml2ZXJfcmVnaXN0ZXJlZCA9IHRydWU7DQog
CX0NCiANCisJZG1pX2NoZWNrX3N5c3RlbShydGNfcXVpcmtzKTsNCisNCiAJaWYgKHJldHZhbCA9
PSAwKQ0KIAkJcmV0dXJuIDA7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2JmYS9iZmFk
LmMgYi9kcml2ZXJzL3Njc2kvYmZhL2JmYWQuYw0KaW5kZXggNjZmYjcyNS4uNjMzMDQ4YiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9iZmEvYmZhZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvYmZh
L2JmYWQuYw0KQEAgLTE2MTMsNyArMTYxMyw3IEBAIG91dDoNCiBzdGF0aWMgdTMyICoNCiBiZmFk
X2xvYWRfZndpbWcoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQogew0KLQlpZiAocGRldi0+ZGV2aWNl
ID09IEJGQV9QQ0lfREVWSUNFX0lEX0NUMikgew0KKwlpZiAoYmZhX2FzaWNfaWRfY3QyKHBkZXYt
PmRldmljZSkpIHsNCiAJCWlmIChiZmlfaW1hZ2VfY3QyX3NpemUgPT0gMCkNCiAJCQliZmFkX3Jl
YWRfZmlybXdhcmUocGRldiwgJmJmaV9pbWFnZV9jdDIsDQogCQkJCSZiZmlfaW1hZ2VfY3QyX3Np
emUsIEJGQURfRldfRklMRV9DVDIpOw0KQEAgLTE2MjMsMTIgKzE2MjMsMTQgQEAgYmZhZF9sb2Fk
X2Z3aW1nKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KIAkJCWJmYWRfcmVhZF9maXJtd2FyZShwZGV2
LCAmYmZpX2ltYWdlX2N0LA0KIAkJCQkmYmZpX2ltYWdlX2N0X3NpemUsIEJGQURfRldfRklMRV9D
VCk7DQogCQlyZXR1cm4gYmZpX2ltYWdlX2N0Ow0KLQl9IGVsc2Ugew0KKwl9IGVsc2UgaWYgKGJm
YV9hc2ljX2lkX2NiKHBkZXYtPmRldmljZSkpIHsNCiAJCWlmIChiZmlfaW1hZ2VfY2Jfc2l6ZSA9
PSAwKQ0KIAkJCWJmYWRfcmVhZF9maXJtd2FyZShwZGV2LCAmYmZpX2ltYWdlX2NiLA0KIAkJCQkm
YmZpX2ltYWdlX2NiX3NpemUsIEJGQURfRldfRklMRV9DQik7DQogCQlyZXR1cm4gYmZpX2ltYWdl
X2NiOw0KIAl9DQorDQorCXJldHVybiBOVUxMOw0KIH0NCiANCiBzdGF0aWMgdm9pZA0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc2NzaS9pc2NpL2hvc3QuaCBiL2RyaXZlcnMvc2NzaS9pc2NpL2hvc3Qu
aA0KaW5kZXggNjQ2MDUxYS4uZWY4NDc3OCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9pc2Np
L2hvc3QuaA0KKysrIGIvZHJpdmVycy9zY3NpL2lzY2kvaG9zdC5oDQpAQCAtMzA5LDkgKzMwOSw4
IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IGlzY2lfcGNpX2luZm8gKnRvX3BjaV9pbmZvKHN0cnVj
dCBwY2lfZGV2ICpwZGV2KQ0KIH0NCiANCiAjZGVmaW5lIGZvcl9lYWNoX2lzY2lfaG9zdChpZCwg
aWhvc3QsIHBkZXYpIFwNCi0JZm9yIChpZCA9IDAsIGlob3N0ID0gdG9fcGNpX2luZm8ocGRldikt
Pmhvc3RzW2lkXTsgXA0KLQkgICAgIGlkIDwgQVJSQVlfU0laRSh0b19wY2lfaW5mbyhwZGV2KS0+
aG9zdHMpICYmIGlob3N0OyBcDQotCSAgICAgaWhvc3QgPSB0b19wY2lfaW5mbyhwZGV2KS0+aG9z
dHNbKytpZF0pDQorCWZvciAoaWQgPSAwOyBpZCA8IFNDSV9NQVhfQ09OVFJPTExFUlMgJiYgXA0K
KwkgICAgIChpaG9zdCA9IHRvX3BjaV9pbmZvKHBkZXYpLT5ob3N0c1tpZF0pOyBpZCsrKQ0KIA0K
IHN0YXRpYyBpbmxpbmUgZW51bSBpc2NpX3N0YXR1cyBpc2NpX2hvc3RfZ2V0X3N0YXRlKHN0cnVj
dCBpc2NpX2hvc3QgKmlzY2lfaG9zdCkNCiB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2lz
Y2kvcG9ydF9jb25maWcuYyBiL2RyaXZlcnMvc2NzaS9pc2NpL3BvcnRfY29uZmlnLmMNCmluZGV4
IDM4YTk5ZDIuLjIxYTY3NjkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvaXNjaS9wb3J0X2Nv
bmZpZy5jDQorKysgYi9kcml2ZXJzL3Njc2kvaXNjaS9wb3J0X2NvbmZpZy5jDQpAQCAtNjEwLDEz
ICs2MTAsNiBAQCBzdGF0aWMgdm9pZCBzY2lfYXBjX2FnZW50X2xpbmtfdXAoc3RydWN0IGlzY2lf
aG9zdCAqaWhvc3QsDQogCQlzY2lfYXBjX2FnZW50X2NvbmZpZ3VyZV9wb3J0cyhpaG9zdCwgcG9y
dF9hZ2VudCwgaXBoeSwgdHJ1ZSk7DQogCX0gZWxzZSB7DQogCQkvKiB0aGUgcGh5IGlzIGFscmVh
ZHkgdGhlIHBhcnQgb2YgdGhlIHBvcnQgKi8NCi0JCXUzMiBwb3J0X3N0YXRlID0gaXBvcnQtPnNt
LmN1cnJlbnRfc3RhdGVfaWQ7DQotDQotCQkvKiBpZiB0aGUgUE9SVCdTIHN0YXRlIGlzIHJlc2V0
dGluZyB0aGVuIHRoZSBsaW5rIHVwIGlzIGZyb20NCi0JCSAqIHBvcnQgaGFyZCByZXNldCBpbiB0
aGlzIGNhc2UsIHdlIG5lZWQgdG8gdGVsbCB0aGUgcG9ydA0KLQkJICogdGhhdCBsaW5rIHVwIGlz
IHJlY2lldmVkDQotCQkgKi8NCi0JCUJVR19PTihwb3J0X3N0YXRlICE9IFNDSV9QT1JUX1JFU0VU
VElORyk7DQogCQlwb3J0X2FnZW50LT5waHlfcmVhZHlfbWFzayB8PSAxIDw8IHBoeV9pbmRleDsN
CiAJCXNjaV9wb3J0X2xpbmtfdXAoaXBvcnQsIGlwaHkpOw0KIAl9DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL2lzY2kvdGFzay5jIGIvZHJpdmVycy9zY3NpL2lzY2kvdGFzay5jDQppbmRleCBl
Mjk0ZDExLi42MGE1MzBmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL2lzY2kvdGFzay5jDQor
KysgYi9kcml2ZXJzL3Njc2kvaXNjaS90YXNrLmMNCkBAIC0xMzkwLDcgKzEzOTAsNyBAQCBpbnQg
aXNjaV90YXNrX0lfVF9uZXh1c19yZXNldChzdHJ1Y3QgZG9tYWluX2RldmljZSAqZGV2KQ0KIAlz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZpaG9zdC0+c2NpY19sb2NrLCBmbGFncyk7DQogDQogCWlm
ICghaWRldiB8fCAhdGVzdF9iaXQoSURFVl9FSCwgJmlkZXYtPmZsYWdzKSkgew0KLQkJcmV0ID0g
VE1GX1JFU1BfRlVOQ19DT01QTEVURTsNCisJCXJldCA9IC1FTk9ERVY7DQogCQlnb3RvIG91dDsN
CiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaCBiL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaA0KaW5kZXggZmNmMDUyYy4uYzQ5MWE5NCAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaA0KKysrIGIvZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX2RlZi5oDQpAQCAtMjU2OCw4ICsyNTY4LDcgQEAgc3RydWN0IHFsYV9o
d19kYXRhIHsNCiAJCQkJSVNfUUxBMjVYWChoYSkgfHwgSVNfUUxBODFYWChoYSkgfHwgXA0KIAkJ
CQlJU19RTEE4MlhYKGhhKSkNCiAjZGVmaW5lIElTX01TSVhfTkFDS19DQVBBQkxFKGhhKSAoSVNf
UUxBODFYWChoYSkpDQotI2RlZmluZSBJU19OT1BPTExJTkdfVFlQRShoYSkJKChJU19RTEEyNVhY
KGhhKSB8fCBJU19RTEE4MVhYKGhhKSkgJiYgXA0KLQkJCQkoaGEpLT5mbGFncy5tc2l4X2VuYWJs
ZWQpDQorI2RlZmluZSBJU19OT1BPTExJTkdfVFlQRShoYSkJKElTX1FMQTgxWFgoaGEpICYmICho
YSktPmZsYWdzLm1zaXhfZW5hYmxlZCkNCiAjZGVmaW5lIElTX0ZBQ19SRVFVSVJFRChoYSkJKElT
X1FMQTgxWFgoaGEpKQ0KICNkZWZpbmUgSVNfTk9DQUNIRV9WUERfVFlQRShoYSkJKElTX1FMQTgx
WFgoaGEpKQ0KICNkZWZpbmUgSVNfQUxPR0lPX0NBUEFCTEUoaGEpCShJU19RTEEyM1hYKGhhKSB8
fCBJU19GV0kyX0NBUEFCTEUoaGEpKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9jb21l
ZGkvZHJpdmVycy9hZHZfcGNpMTcxMC5jIGIvZHJpdmVycy9zdGFnaW5nL2NvbWVkaS9kcml2ZXJz
L2Fkdl9wY2kxNzEwLmMNCmluZGV4IGRhMmI3NWIuLjY3MjUzOGUgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvY29tZWRpL2RyaXZlcnMvYWR2X3BjaTE3MTAuYw0KKysrIGIvZHJpdmVycy9z
dGFnaW5nL2NvbWVkaS9kcml2ZXJzL2Fkdl9wY2kxNzEwLmMNCkBAIC00MTQsNiArNDE0LDcgQEAg
c3RhdGljIGludCBwY2kxNzF4X2luc25fd3JpdGVfYW8oc3RydWN0IGNvbWVkaV9kZXZpY2UgKmRl
diwNCiAJCQkJIHN0cnVjdCBjb21lZGlfc3ViZGV2aWNlICpzLA0KIAkJCQkgc3RydWN0IGNvbWVk
aV9pbnNuICppbnNuLCB1bnNpZ25lZCBpbnQgKmRhdGEpDQogew0KKwl1bnNpZ25lZCBpbnQgdmFs
Ow0KIAlpbnQgbiwgY2hhbiwgcmFuZ2UsIG9mczsNCiANCiAJY2hhbiA9IENSX0NIQU4oaW5zbi0+
Y2hhbnNwZWMpOw0KQEAgLTQyOSwxMSArNDMwLDE0IEBAIHN0YXRpYyBpbnQgcGNpMTcxeF9pbnNu
X3dyaXRlX2FvKHN0cnVjdCBjb21lZGlfZGV2aWNlICpkZXYsDQogCQlvdXR3KGRldnByaXYtPmRh
X3JhbmdlcywgZGV2LT5pb2Jhc2UgKyBQQ0kxNzF4X0RBUkVGKTsNCiAJCW9mcyA9IFBDSTE3MXhf
REExOw0KIAl9DQorCXZhbCA9IGRldnByaXYtPmFvX2RhdGFbY2hhbl07DQogDQotCWZvciAobiA9
IDA7IG4gPCBpbnNuLT5uOyBuKyspDQotCQlvdXR3KGRhdGFbbl0sIGRldi0+aW9iYXNlICsgb2Zz
KTsNCisJZm9yIChuID0gMDsgbiA8IGluc24tPm47IG4rKykgew0KKwkJdmFsID0gZGF0YVtuXTsN
CisJCW91dHcodmFsLCBkZXYtPmlvYmFzZSArIG9mcyk7DQorCX0NCiANCi0JZGV2cHJpdi0+YW9f
ZGF0YVtjaGFuXSA9IGRhdGFbbl07DQorCWRldnByaXYtPmFvX2RhdGFbY2hhbl0gPSB2YWw7DQog
DQogCXJldHVybiBuOw0KIA0KQEAgLTU4Miw2ICs1ODYsNyBAQCBzdGF0aWMgaW50IHBjaTE3MjBf
aW5zbl93cml0ZV9hbyhzdHJ1Y3QgY29tZWRpX2RldmljZSAqZGV2LA0KIAkJCQkgc3RydWN0IGNv
bWVkaV9zdWJkZXZpY2UgKnMsDQogCQkJCSBzdHJ1Y3QgY29tZWRpX2luc24gKmluc24sIHVuc2ln
bmVkIGludCAqZGF0YSkNCiB7DQorCXVuc2lnbmVkIGludCB2YWw7DQogCWludCBuLCByYW5nZXJl
ZywgY2hhbjsNCiANCiAJY2hhbiA9IENSX0NIQU4oaW5zbi0+Y2hhbnNwZWMpOw0KQEAgLTU5MSwx
MyArNTk2LDE1IEBAIHN0YXRpYyBpbnQgcGNpMTcyMF9pbnNuX3dyaXRlX2FvKHN0cnVjdCBjb21l
ZGlfZGV2aWNlICpkZXYsDQogCQlvdXRiKHJhbmdlcmVnLCBkZXYtPmlvYmFzZSArIFBDSTE3MjBf
UkFOR0UpOw0KIAkJZGV2cHJpdi0+ZGFfcmFuZ2VzID0gcmFuZ2VyZWc7DQogCX0NCisJdmFsID0g
ZGV2cHJpdi0+YW9fZGF0YVtjaGFuXTsNCiANCiAJZm9yIChuID0gMDsgbiA8IGluc24tPm47IG4r
Kykgew0KLQkJb3V0dyhkYXRhW25dLCBkZXYtPmlvYmFzZSArIFBDSTE3MjBfREEwICsgKGNoYW4g
PDwgMSkpOw0KKwkJdmFsID0gZGF0YVtuXTsNCisJCW91dHcodmFsLCBkZXYtPmlvYmFzZSArIFBD
STE3MjBfREEwICsgKGNoYW4gPDwgMSkpOw0KIAkJb3V0YigwLCBkZXYtPmlvYmFzZSArIFBDSTE3
MjBfU1lOQ09VVCk7CS8qICB1cGRhdGUgb3V0cHV0cyAqLw0KIAl9DQogDQotCWRldnByaXYtPmFv
X2RhdGFbY2hhbl0gPSBkYXRhW25dOw0KKwlkZXZwcml2LT5hb19kYXRhW2NoYW5dID0gdmFsOw0K
IA0KIAlyZXR1cm4gbjsNCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL2NvbWVkaS9k
cml2ZXJzL3BjbXVpby5jIGIvZHJpdmVycy9zdGFnaW5nL2NvbWVkaS9kcml2ZXJzL3BjbXVpby5j
DQppbmRleCBiMmMyYzg5Li42YzI1YmQzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL2Nv
bWVkaS9kcml2ZXJzL3BjbXVpby5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvY29tZWRpL2RyaXZl
cnMvcGNtdWlvLmMNCkBAIC00NjQsMTMgKzQ2NCwxMyBAQCBzdGF0aWMgaW50IHBjbXVpb19kZXRh
Y2goc3RydWN0IGNvbWVkaV9kZXZpY2UgKmRldikNCiAJaWYgKGRldi0+aW9iYXNlKQ0KIAkJcmVs
ZWFzZV9yZWdpb24oZGV2LT5pb2Jhc2UsIEFTSUNfSU9TSVpFICogdGhpc2JvYXJkLT5udW1fYXNp
Y3MpOw0KIA0KLQlmb3IgKGkgPSAwOyBpIDwgTUFYX0FTSUNTOyArK2kpIHsNCi0JCWlmIChkZXZw
cml2LT5hc2ljc1tpXS5pcnEpDQotCQkJZnJlZV9pcnEoZGV2cHJpdi0+YXNpY3NbaV0uaXJxLCBk
ZXYpOw0KLQl9DQotDQotCWlmIChkZXZwcml2ICYmIGRldnByaXYtPnNwcml2cykNCisJaWYgKGRl
dnByaXYpIHsNCisJCWZvciAoaSA9IDA7IGkgPCBNQVhfQVNJQ1M7ICsraSkgew0KKwkJCWlmIChk
ZXZwcml2LT5hc2ljc1tpXS5pcnEpDQorCQkJCWZyZWVfaXJxKGRldnByaXYtPmFzaWNzW2ldLmly
cSwgZGV2KTsNCisJCX0NCiAJCWtmcmVlKGRldnByaXYtPnNwcml2cyk7DQorCX0NCiANCiAJcmV0
dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvZHJpdmVycy9z
c3ZfZG5wLmMgYi9kcml2ZXJzL3N0YWdpbmcvY29tZWRpL2RyaXZlcnMvc3N2X2RucC5jDQppbmRl
eCA1MjZkZTJlLi4wMzE2NzgwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL2NvbWVkaS9k
cml2ZXJzL3Nzdl9kbnAuYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL2NvbWVkaS9kcml2ZXJzL3Nz
dl9kbnAuYw0KQEAgLTI1MSwxMSArMjUxLDExIEBAIHN0YXRpYyBpbnQgZG5wX2Rpb19pbnNuX2Jp
dHMoc3RydWN0IGNvbWVkaV9kZXZpY2UgKmRldiwNCiANCiAJLyogb24gcmV0dXJuLCBkYXRhWzFd
IGNvbnRhaW5zIHRoZSB2YWx1ZSBvZiB0aGUgZGlnaXRhbCBpbnB1dCBsaW5lcy4gKi8NCiAJb3V0
YihQQURSLCBDU0NJUik7DQotCWRhdGFbMF0gPSBpbmIoQ1NDRFIpOw0KKwlkYXRhWzFdID0gaW5i
KENTQ0RSKTsNCiAJb3V0YihQQkRSLCBDU0NJUik7DQotCWRhdGFbMF0gKz0gaW5iKENTQ0RSKSA8
PCA4Ow0KKwlkYXRhWzFdICs9IGluYihDU0NEUikgPDwgODsNCiAJb3V0YihQQ0RSLCBDU0NJUik7
DQotCWRhdGFbMF0gKz0gKChpbmIoQ1NDRFIpICYgMHhGMCkgPDwgMTIpOw0KKwlkYXRhWzFdICs9
ICgoaW5iKENTQ0RSKSAmIDB4RjApIDw8IDEyKTsNCiANCiAJcmV0dXJuIDI7DQogDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL2lpby9hZGMvYWQ3OTl4X2NvcmUuYyBiL2RyaXZlcnMvc3Rh
Z2luZy9paW8vYWRjL2FkNzk5eF9jb3JlLmMNCmluZGV4IGVlNmNkNzkuLmY3OWQwY2IgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvaWlvL2FkYy9hZDc5OXhfY29yZS5jDQorKysgYi9kcml2
ZXJzL3N0YWdpbmcvaWlvL2FkYy9hZDc5OXhfY29yZS5jDQpAQCAtODczLDcgKzg3Myw4IEBAIHN0
YXRpYyBpbnQgX19kZXZpbml0IGFkNzk5eF9wcm9iZShzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50
LA0KIAlyZXR1cm4gMDsNCiANCiBlcnJvcl9mcmVlX2lycToNCi0JZnJlZV9pcnEoY2xpZW50LT5p
cnEsIGluZGlvX2Rldik7DQorCWlmIChjbGllbnQtPmlycSA+IDApDQorCQlmcmVlX2lycShjbGll
bnQtPmlycSwgaW5kaW9fZGV2KTsNCiBlcnJvcl9jbGVhbnVwX3Jpbmc6DQogCWFkNzk5eF9yaW5n
X2NsZWFudXAoaW5kaW9fZGV2KTsNCiBlcnJvcl9kaXNhYmxlX3JlZzoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvcnRsODcxMi91c2JfaW50Zi5jIGIvZHJpdmVycy9zdGFnaW5nL3J0bDg3
MTIvdXNiX2ludGYuYw0KaW5kZXggODhkMWQzNS4uYTc0ZTgzZCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvc3RhZ2luZy9ydGw4NzEyL3VzYl9pbnRmLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9ydGw4
NzEyL3VzYl9pbnRmLmMNCkBAIC0zNjMsNiArMzYzLDEwIEBAIHN0YXRpYyB1OCBrZXlfMmNoYXIy
bnVtKHU4IGhjaCwgdTggbGNoKQ0KIAlyZXR1cm4gKGhleF90b19iaW4oaGNoKSA8PCA0KSB8IGhl
eF90b19iaW4obGNoKTsNCiB9DQogDQorc3RhdGljIGNvbnN0IHN0cnVjdCBkZXZpY2VfdHlwZSB3
bGFuX3R5cGUgPSB7DQorCS5uYW1lID0gIndsYW4iLA0KK307DQorDQogLyoNCiAgKiBkcnZfaW5p
dCgpIC0gYSBkZXZpY2UgcG90ZW50aWFsbHkgZm9yIHVzDQogICoNCkBAIC0zOTgsNiArNDAyLDcg
QEAgc3RhdGljIGludCByODcxeHVfZHJ2X2luaXQoc3RydWN0IHVzYl9pbnRlcmZhY2UgKnB1c2Jf
aW50ZiwNCiAJcGFkYXB0ZXItPnB1c2JfaW50ZiA9IHB1c2JfaW50ZjsNCiAJdXNiX3NldF9pbnRm
ZGF0YShwdXNiX2ludGYsIHBuZXRkZXYpOw0KIAlTRVRfTkVUREVWX0RFVihwbmV0ZGV2LCAmcHVz
Yl9pbnRmLT5kZXYpOw0KKwlwbmV0ZGV2LT5kZXYudHlwZSA9ICZ3bGFuX3R5cGU7DQogCS8qIHN0
ZXAgMi4gKi8NCiAJcGFkYXB0ZXItPmR2b2JqX2luaXQgPSAmcjg3MTJfdXNiX2R2b2JqX2luaXQ7
DQogCXBhZGFwdGVyLT5kdm9ial9kZWluaXQgPSAmcjg3MTJfdXNiX2R2b2JqX2RlaW5pdDsNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvdnQ2NjU2L2Jhc2ViYW5kLmMgYi9kcml2ZXJzL3N0
YWdpbmcvdnQ2NjU2L2Jhc2ViYW5kLmMNCmluZGV4IDBkMTExNDcuLjU5Y2Y2NzQgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvdnQ2NjU2L2Jhc2ViYW5kLmMNCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy92dDY2NTYvYmFzZWJhbmQuYw0KQEAgLTE2NTYsNyArMTY1Niw2IEBAIEJCdlVwZGF0ZVBy
ZUVEVGhyZXNob2xkKA0KIA0KICAgICAgICAgICAgIGlmKCBiU2Nhbm5pbmcgKQ0KICAgICAgICAg
ICAgIHsgICAvLyBuZWVkIE1heCBzZW5zaXRpdml0eSAvL1JTU0kgLTY5LCAtNzAsLi4uLg0KLSAg
ICAgICAgICAgICAgICBpZihwRGV2aWNlLT5ieUJCUHJlRURJbmRleCA9PSAwKSBicmVhazsNCiAg
ICAgICAgICAgICAgICAgcERldmljZS0+YnlCQlByZUVESW5kZXggPSAwOw0KICAgICAgICAgICAg
ICAgICBDb250cm9sdldyaXRlQnl0ZShwRGV2aWNlLCBNRVNTQUdFX1JFUVVFU1RfQkJSRUcsIDB4
QzksIDB4MDApOyAvL0NSMjAxKDB4QzkpDQogICAgICAgICAgICAgICAgIENvbnRyb2x2V3JpdGVC
eXRlKHBEZXZpY2UsIE1FU1NBR0VfUkVRVUVTVF9CQlJFRywgMHhDRSwgMHgzMCk7IC8vQ1IyMDYo
MHhDRSkNCkBAIC0xNzk5LDcgKzE3OTgsNiBAQCBCQnZVcGRhdGVQcmVFRFRocmVzaG9sZCgNCiAN
CiAgICAgICAgICAgICBpZiggYlNjYW5uaW5nICkNCiAgICAgICAgICAgICB7ICAgLy8gbmVlZCBN
YXggc2Vuc2l0aXZpdHkgIC8vUlNTSSAtNjksIC03MCwgLi4uDQotICAgICAgICAgICAgICAgIGlm
KHBEZXZpY2UtPmJ5QkJQcmVFREluZGV4ID09IDApIGJyZWFrOw0KICAgICAgICAgICAgICAgICBw
RGV2aWNlLT5ieUJCUHJlRURJbmRleCA9IDA7DQogICAgICAgICAgICAgICAgIENvbnRyb2x2V3Jp
dGVCeXRlKHBEZXZpY2UsIE1FU1NBR0VfUkVRVUVTVF9CQlJFRywgMHhDOSwgMHgwMCk7IC8vQ1Iy
MDEoMHhDOSkNCiAgICAgICAgICAgICAgICAgQ29udHJvbHZXcml0ZUJ5dGUocERldmljZSwgTUVT
U0FHRV9SRVFVRVNUX0JCUkVHLCAweENFLCAweDI0KTsgLy9DUjIwNigweENFKQ0KQEAgLTE5NTEs
NyArMTk0OSw2IEBAIEJCdlVwZGF0ZVByZUVEVGhyZXNob2xkKA0KICAgICAgICAgY2FzZSBSRl9W
VDMzNDJBMDogLy9Sb2JlcnRZdToyMDA2MDYyNywgdGVzdGluZyB0YWJsZQ0KICAgICAgICAgICAg
IGlmKCBiU2Nhbm5pbmcgKQ0KICAgICAgICAgICAgIHsgICAvLyBuZWVkIE1heCBzZW5zaXRpdml0
eSAgLy9SU1NJIC02NywgLTY4LCAuLi4NCi0gICAgICAgICAgICAgICAgaWYocERldmljZS0+YnlC
QlByZUVESW5kZXggPT0gMCkgYnJlYWs7DQogICAgICAgICAgICAgICAgIHBEZXZpY2UtPmJ5QkJQ
cmVFREluZGV4ID0gMDsNCiAgICAgICAgICAgICAgICAgQ29udHJvbHZXcml0ZUJ5dGUocERldmlj
ZSwgTUVTU0FHRV9SRVFVRVNUX0JCUkVHLCAweEM5LCAweDAwKTsgLy9DUjIwMSgweEM5KQ0KICAg
ICAgICAgICAgICAgICBDb250cm9sdldyaXRlQnl0ZShwRGV2aWNlLCBNRVNTQUdFX1JFUVVFU1Rf
QkJSRUcsIDB4Q0UsIDB4MzgpOyAvL0NSMjA2KDB4Q0UpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy90
YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0LmMgYi9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90
YXJnZXQuYw0KaW5kZXggNDVjMTNhNi4uNGE4OGVlYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdGFy
Z2V0L2lzY3NpL2lzY3NpX3RhcmdldC5jDQorKysgYi9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2Nz
aV90YXJnZXQuYw0KQEAgLTUwLDcgKzUwLDcgQEANCiBzdGF0aWMgTElTVF9IRUFEKGdfdGlxbl9s
aXN0KTsNCiBzdGF0aWMgTElTVF9IRUFEKGdfbnBfbGlzdCk7DQogc3RhdGljIERFRklORV9TUElO
TE9DSyh0aXFuX2xvY2spOw0KLXN0YXRpYyBERUZJTkVfU1BJTkxPQ0sobnBfbG9jayk7DQorc3Rh
dGljIERFRklORV9NVVRFWChucF9sb2NrKTsNCiANCiBzdGF0aWMgc3RydWN0IGlkciB0aXFuX2lk
cjsNCiBzdHJ1Y3QgaWRyIHNlc3NfaWRyOw0KQEAgLTI2Miw2ICsyNjIsOSBAQCBpbnQgaXNjc2l0
X2RlYWNjZXNzX25wKHN0cnVjdCBpc2NzaV9ucCAqbnAsIHN0cnVjdCBpc2NzaV9wb3J0YWxfZ3Jv
dXAgKnRwZykNCiAJcmV0dXJuIDA7DQogfQ0KIA0KKy8qDQorICogQ2FsbGVkIHdpdGggbXV0ZXgg
bnBfbG9jayBoZWxkDQorICovDQogc3RhdGljIHN0cnVjdCBpc2NzaV9ucCAqaXNjc2l0X2dldF9u
cCgNCiAJc3RydWN0IF9fa2VybmVsX3NvY2thZGRyX3N0b3JhZ2UgKnNvY2thZGRyLA0KIAlpbnQg
bmV0d29ya190cmFuc3BvcnQpDQpAQCAtMjcyLDExICsyNzUsMTAgQEAgc3RhdGljIHN0cnVjdCBp
c2NzaV9ucCAqaXNjc2l0X2dldF9ucCgNCiAJaW50IGlwX21hdGNoID0gMDsNCiAJdTE2IHBvcnQ7
DQogDQotCXNwaW5fbG9ja19iaCgmbnBfbG9jayk7DQogCWxpc3RfZm9yX2VhY2hfZW50cnkobnAs
ICZnX25wX2xpc3QsIG5wX2xpc3QpIHsNCi0JCXNwaW5fbG9jaygmbnAtPm5wX3RocmVhZF9sb2Nr
KTsNCisJCXNwaW5fbG9ja19iaCgmbnAtPm5wX3RocmVhZF9sb2NrKTsNCiAJCWlmIChucC0+bnBf
dGhyZWFkX3N0YXRlICE9IElTQ1NJX05QX1RIUkVBRF9BQ1RJVkUpIHsNCi0JCQlzcGluX3VubG9j
aygmbnAtPm5wX3RocmVhZF9sb2NrKTsNCisJCQlzcGluX3VubG9ja19iaCgmbnAtPm5wX3RocmVh
ZF9sb2NrKTsNCiAJCQljb250aW51ZTsNCiAJCX0NCiANCkBAIC0zMDksMTMgKzMxMSwxMSBAQCBz
dGF0aWMgc3RydWN0IGlzY3NpX25wICppc2NzaXRfZ2V0X25wKA0KIAkJCSAqIHdoaWxlIGlzY3Np
X3RwZ19hZGRfbmV0d29ya19wb3J0YWwoKSBpcyBjYWxsZWQuDQogCQkJICovDQogCQkJbnAtPm5w
X2V4cG9ydHMrKzsNCi0JCQlzcGluX3VubG9jaygmbnAtPm5wX3RocmVhZF9sb2NrKTsNCi0JCQlz
cGluX3VubG9ja19iaCgmbnBfbG9jayk7DQorCQkJc3Bpbl91bmxvY2tfYmgoJm5wLT5ucF90aHJl
YWRfbG9jayk7DQogCQkJcmV0dXJuIG5wOw0KIAkJfQ0KLQkJc3Bpbl91bmxvY2soJm5wLT5ucF90
aHJlYWRfbG9jayk7DQorCQlzcGluX3VubG9ja19iaCgmbnAtPm5wX3RocmVhZF9sb2NrKTsNCiAJ
fQ0KLQlzcGluX3VubG9ja19iaCgmbnBfbG9jayk7DQogDQogCXJldHVybiBOVUxMOw0KIH0NCkBA
IC0zMjksMTYgKzMyOSwyMiBAQCBzdHJ1Y3QgaXNjc2lfbnAgKmlzY3NpdF9hZGRfbnAoDQogCXN0
cnVjdCBzb2NrYWRkcl9pbjYgKnNvY2tfaW42Ow0KIAlzdHJ1Y3QgaXNjc2lfbnAgKm5wOw0KIAlp
bnQgcmV0Ow0KKw0KKwltdXRleF9sb2NrKCZucF9sb2NrKTsNCisNCiAJLyoNCiAJICogTG9jYXRl
IHRoZSBleGlzdGluZyBzdHJ1Y3QgaXNjc2lfbnAgaWYgYWxyZWFkeSBhY3RpdmUuLg0KIAkgKi8N
CiAJbnAgPSBpc2NzaXRfZ2V0X25wKHNvY2thZGRyLCBuZXR3b3JrX3RyYW5zcG9ydCk7DQotCWlm
IChucCkNCisJaWYgKG5wKSB7DQorCQltdXRleF91bmxvY2soJm5wX2xvY2spOw0KIAkJcmV0dXJu
IG5wOw0KKwl9DQogDQogCW5wID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IGlzY3NpX25wKSwgR0ZQ
X0tFUk5FTCk7DQogCWlmICghbnApIHsNCiAJCXByX2VycigiVW5hYmxlIHRvIGFsbG9jYXRlIG1l
bW9yeSBmb3Igc3RydWN0IGlzY3NpX25wXG4iKTsNCisJCW11dGV4X3VubG9jaygmbnBfbG9jayk7
DQogCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsNCiAJfQ0KIA0KQEAgLTM2MSw2ICszNjcsNyBA
QCBzdHJ1Y3QgaXNjc2lfbnAgKmlzY3NpdF9hZGRfbnAoDQogCXJldCA9IGlzY3NpX3RhcmdldF9z
ZXR1cF9sb2dpbl9zb2NrZXQobnAsIHNvY2thZGRyKTsNCiAJaWYgKHJldCAhPSAwKSB7DQogCQlr
ZnJlZShucCk7DQorCQltdXRleF91bmxvY2soJm5wX2xvY2spOw0KIAkJcmV0dXJuIEVSUl9QVFIo
cmV0KTsNCiAJfQ0KIA0KQEAgLTM2OSw2ICszNzYsNyBAQCBzdHJ1Y3QgaXNjc2lfbnAgKmlzY3Np
dF9hZGRfbnAoDQogCQlwcl9lcnIoIlVuYWJsZSB0byBjcmVhdGUga3RocmVhZDogaXNjc2lfbnBc
biIpOw0KIAkJcmV0ID0gUFRSX0VSUihucC0+bnBfdGhyZWFkKTsNCiAJCWtmcmVlKG5wKTsNCisJ
CW11dGV4X3VubG9jaygmbnBfbG9jayk7DQogCQlyZXR1cm4gRVJSX1BUUihyZXQpOw0KIAl9DQog
CS8qDQpAQCAtMzc5LDEwICszODcsMTAgQEAgc3RydWN0IGlzY3NpX25wICppc2NzaXRfYWRkX25w
KA0KIAkgKiBwb2ludCBiZWNhdXNlIGlzY3NpX25wIGhhcyBub3QgYmVlbiBhZGRlZCB0byBnX25w
X2xpc3QgeWV0Lg0KIAkgKi8NCiAJbnAtPm5wX2V4cG9ydHMgPSAxOw0KKwlucC0+bnBfdGhyZWFk
X3N0YXRlID0gSVNDU0lfTlBfVEhSRUFEX0FDVElWRTsNCiANCi0Jc3Bpbl9sb2NrX2JoKCZucF9s
b2NrKTsNCiAJbGlzdF9hZGRfdGFpbCgmbnAtPm5wX2xpc3QsICZnX25wX2xpc3QpOw0KLQlzcGlu
X3VubG9ja19iaCgmbnBfbG9jayk7DQorCW11dGV4X3VubG9jaygmbnBfbG9jayk7DQogDQogCXBy
X2RlYnVnKCJDT1JFWzBdIC0gQWRkZWQgTmV0d29yayBQb3J0YWw6ICVzOiVodSBvbiAlc1xuIiwN
CiAJCW5wLT5ucF9pcCwgbnAtPm5wX3BvcnQsIChucC0+bnBfbmV0d29ya190cmFuc3BvcnQgPT0g
SVNDU0lfVENQKSA/DQpAQCAtNDUzLDkgKzQ2MSw5IEBAIGludCBpc2NzaXRfZGVsX25wKHN0cnVj
dCBpc2NzaV9ucCAqbnApDQogCX0NCiAJaXNjc2l0X2RlbF9ucF9jb21tKG5wKTsNCiANCi0Jc3Bp
bl9sb2NrX2JoKCZucF9sb2NrKTsNCisJbXV0ZXhfbG9jaygmbnBfbG9jayk7DQogCWxpc3RfZGVs
KCZucC0+bnBfbGlzdCk7DQotCXNwaW5fdW5sb2NrX2JoKCZucF9sb2NrKTsNCisJbXV0ZXhfdW5s
b2NrKCZucF9sb2NrKTsNCiANCiAJcHJfZGVidWcoIkNPUkVbMF0gLSBSZW1vdmVkIE5ldHdvcmsg
UG9ydGFsOiAlczolaHUgb24gJXNcbiIsDQogCQlucC0+bnBfaXAsIG5wLT5ucF9wb3J0LCAobnAt
Pm5wX25ldHdvcmtfdHJhbnNwb3J0ID09IElTQ1NJX1RDUCkgPw0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdHR5L25fZ3NtLmMgYi9kcml2ZXJzL3R0eS9uX2dzbS5jDQppbmRleCBkMTkwMjY5Li42NDNh
MGEwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy90dHkvbl9nc20uYw0KKysrIGIvZHJpdmVycy90dHkv
bl9nc20uYw0KQEAgLTEwOTAsNiArMTA5MCw3IEBAIHN0YXRpYyB2b2lkIGdzbV9jb250cm9sX21v
ZGVtKHN0cnVjdCBnc21fbXV4ICpnc20sIHU4ICpkYXRhLCBpbnQgY2xlbikNCiB7DQogCXVuc2ln
bmVkIGludCBhZGRyID0gMDsNCiAJdW5zaWduZWQgaW50IG1vZGVtID0gMDsNCisJdW5zaWduZWQg
aW50IGJyayA9IDA7DQogCXN0cnVjdCBnc21fZGxjaSAqZGxjaTsNCiAJaW50IGxlbiA9IGNsZW47
DQogCXU4ICpkcCA9IGRhdGE7DQpAQCAtMTExNiw2ICsxMTE3LDE2IEBAIHN0YXRpYyB2b2lkIGdz
bV9jb250cm9sX21vZGVtKHN0cnVjdCBnc21fbXV4ICpnc20sIHU4ICpkYXRhLCBpbnQgY2xlbikN
CiAJCWlmIChsZW4gPT0gMCkNCiAJCQlyZXR1cm47DQogCX0NCisJbGVuLS07DQorCWlmIChsZW4g
PiAwKSB7DQorCQl3aGlsZSAoZ3NtX3JlYWRfZWEoJmJyaywgKmRwKyspID09IDApIHsNCisJCQls
ZW4tLTsNCisJCQlpZiAobGVuID09IDApDQorCQkJCXJldHVybjsNCisJCX0NCisJCW1vZGVtIDw8
PSA3Ow0KKwkJbW9kZW0gfD0gKGJyayAmIDB4N2YpOw0KKwl9DQogCXR0eSA9IHR0eV9wb3J0X3R0
eV9nZXQoJmRsY2ktPnBvcnQpOw0KIAlnc21fcHJvY2Vzc19tb2RlbSh0dHksIGRsY2ksIG1vZGVt
LCBjbGVuKTsNCiAJaWYgKHR0eSkgew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L3NlcmlhbC84
MjUwLmMgYi9kcml2ZXJzL3R0eS9zZXJpYWwvODI1MC5jDQppbmRleCBjZmYwM2U1Li4zMzYwMWY4
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy90dHkvc2VyaWFsLzgyNTAuYw0KKysrIGIvZHJpdmVycy90
dHkvc2VyaWFsLzgyNTAuYw0KQEAgLTI3MDEsNiArMjcwMSwxMCBAQCBzdGF0aWMgdm9pZCBzZXJp
YWw4MjUwX2NvbmZpZ19wb3J0KHN0cnVjdCB1YXJ0X3BvcnQgKnBvcnQsIGludCBmbGFncykNCiAJ
aWYgKHVwLT5wb3J0LnR5cGUgPT0gUE9SVF8xNjU1MEEgJiYgdXAtPnBvcnQuaW90eXBlID09IFVQ
SU9fQVUpDQogCQl1cC0+YnVncyB8PSBVQVJUX0JVR19OT01TUjsNCiANCisJLyogSFcgYnVncyBt
YXkgdHJpZ2dlciBJUlEgd2hpbGUgSUlSID09IE5PX0lOVCAqLw0KKwlpZiAodXAtPnBvcnQudHlw
ZSA9PSBQT1JUX1RFR1JBKQ0KKwkJdXAtPmJ1Z3MgfD0gVUFSVF9CVUdfTk9NU1I7DQorDQogCWlm
ICh1cC0+cG9ydC50eXBlICE9IFBPUlRfVU5LTk9XTiAmJiBmbGFncyAmIFVBUlRfQ09ORklHX0lS
USkNCiAJCWF1dG9jb25maWdfaXJxKHVwKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3R0eS9z
ZXJpYWwvODI1MF9wY2kuYyBiL2RyaXZlcnMvdHR5L3NlcmlhbC84MjUwX3BjaS5jDQppbmRleCA2
YzliY2RmLi5lZjI0ZTk2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy90dHkvc2VyaWFsLzgyNTBfcGNp
LmMNCisrKyBiL2RyaXZlcnMvdHR5L3NlcmlhbC84MjUwX3BjaS5jDQpAQCAtMTE0Nyw2ICsxMTQ3
LDExIEBAIHBjaV94cjE3YzE1NF9zZXR1cChzdHJ1Y3Qgc2VyaWFsX3ByaXZhdGUgKnByaXYsDQog
I2RlZmluZSBQQ0lfREVWSUNFX0lEX1RJVEFOXzgwMEUJMHhBMDE0DQogI2RlZmluZSBQQ0lfREVW
SUNFX0lEX1RJVEFOXzIwMEVJCTB4QTAxNg0KICNkZWZpbmUgUENJX0RFVklDRV9JRF9USVRBTl8y
MDBFSVNJCTB4QTAxNw0KKyNkZWZpbmUgUENJX0RFVklDRV9JRF9USVRBTl8yMDBWMwkweEEzMDYN
CisjZGVmaW5lIFBDSV9ERVZJQ0VfSURfVElUQU5fNDAwVjMJMHhBMzEwDQorI2RlZmluZSBQQ0lf
REVWSUNFX0lEX1RJVEFOXzQxMFYzCTB4QTMxMg0KKyNkZWZpbmUgUENJX0RFVklDRV9JRF9USVRB
Tl84MDBWMwkweEEzMTQNCisjZGVmaW5lIFBDSV9ERVZJQ0VfSURfVElUQU5fODAwVjNCCTB4QTMx
NQ0KICNkZWZpbmUgUENJX0RFVklDRV9JRF9PWFNFTUlfMTZQQ0k5NTgJMHg5NTM4DQogI2RlZmlu
ZSBQQ0lFX0RFVklDRV9JRF9ORU9fMl9PWF9JQk0JMHgwMEY2DQogI2RlZmluZSBQQ0lfREVWSUNF
X0lEX1BMWF9DUk9OWVhfT01FR0EJMHhjMDAxDQpAQCAtMzQ2NSw2ICszNDcwLDIxIEBAIHN0YXRp
YyBzdHJ1Y3QgcGNpX2RldmljZV9pZCBzZXJpYWxfcGNpX3RibFtdID0gew0KIAl7CVBDSV9WRU5E
T1JfSURfVElUQU4sIFBDSV9ERVZJQ0VfSURfVElUQU5fMjAwRUlTSSwNCiAJCVBDSV9BTllfSUQs
IFBDSV9BTllfSUQsIDAsIDAsDQogCQlwYm5fb3hzZW1pXzJfNDAwMDAwMCB9LA0KKwl7CVBDSV9W
RU5ET1JfSURfVElUQU4sIFBDSV9ERVZJQ0VfSURfVElUQU5fMjAwVjMsDQorCQlQQ0lfQU5ZX0lE
LCBQQ0lfQU5ZX0lELCAwLCAwLA0KKwkJcGJuX2IwX2J0XzJfOTIxNjAwIH0sDQorCXsJUENJX1ZF
TkRPUl9JRF9USVRBTiwgUENJX0RFVklDRV9JRF9USVRBTl80MDBWMywNCisJCVBDSV9BTllfSUQs
IFBDSV9BTllfSUQsIDAsIDAsDQorCQlwYm5fYjBfNF85MjE2MDAgfSwNCisJewlQQ0lfVkVORE9S
X0lEX1RJVEFOLCBQQ0lfREVWSUNFX0lEX1RJVEFOXzQxMFYzLA0KKwkJUENJX0FOWV9JRCwgUENJ
X0FOWV9JRCwgMCwgMCwNCisJCXBibl9iMF80XzkyMTYwMCB9LA0KKwl7CVBDSV9WRU5ET1JfSURf
VElUQU4sIFBDSV9ERVZJQ0VfSURfVElUQU5fODAwVjMsDQorCQlQQ0lfQU5ZX0lELCBQQ0lfQU5Z
X0lELCAwLCAwLA0KKwkJcGJuX2IwXzRfOTIxNjAwIH0sDQorCXsJUENJX1ZFTkRPUl9JRF9USVRB
TiwgUENJX0RFVklDRV9JRF9USVRBTl84MDBWM0IsDQorCQlQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lE
LCAwLCAwLA0KKwkJcGJuX2IwXzRfOTIxNjAwIH0sDQogDQogCXsJUENJX1ZFTkRPUl9JRF9TSUlH
LCBQQ0lfREVWSUNFX0lEX1NJSUdfMVNfMTB4XzU1MCwNCiAJCVBDSV9BTllfSUQsIFBDSV9BTllf
SUQsIDAsIDAsDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvc2VyaWFsL3BtYWNfemlsb2cuYyBi
L2RyaXZlcnMvdHR5L3NlcmlhbC9wbWFjX3ppbG9nLmMNCmluZGV4IDA4NmY3ZmUuLmE2Y2FmNjIg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3R0eS9zZXJpYWwvcG1hY196aWxvZy5jDQorKysgYi9kcml2
ZXJzL3R0eS9zZXJpYWwvcG1hY196aWxvZy5jDQpAQCAtMjE5OCw2ICsyMTk4LDkgQEAgc3RhdGlj
IGludCBfX2luaXQgcG16X2NvbnNvbGVfaW5pdCh2b2lkKQ0KIAkvKiBQcm9iZSBwb3J0cyAqLw0K
IAlwbXpfcHJvYmUoKTsNCiANCisJaWYgKHBtel9wb3J0c19jb3VudCA9PSAwKQ0KKwkJcmV0dXJu
IC1FTk9ERVY7DQorDQogCS8qIFRPRE86IEF1dG9wcm9iZSBjb25zb2xlIGJhc2VkIG9uIE9GICov
DQogCS8qIHBtel9jb25zb2xlLmluZGV4ID0gaTsgKi8NCiAJcmVnaXN0ZXJfY29uc29sZSgmcG16
X2NvbnNvbGUpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvY29uZmlnLmMgYi9kcml2
ZXJzL3VzYi9jb3JlL2NvbmZpZy5jDQppbmRleCA3ODYwOWQzLi4xZTNlMjExIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy91c2IvY29yZS9jb25maWcuYw0KKysrIGIvZHJpdmVycy91c2IvY29yZS9jb25m
aWcuYw0KQEAgLTcyMiw2ICs3MjIsMTAgQEAgaW50IHVzYl9nZXRfY29uZmlndXJhdGlvbihzdHJ1
Y3QgdXNiX2RldmljZSAqZGV2KQ0KIAkJCXJlc3VsdCA9IC1FTk9NRU07DQogCQkJZ290byBlcnI7
DQogCQl9DQorDQorCQlpZiAoZGV2LT5xdWlya3MgJiBVU0JfUVVJUktfREVMQVlfSU5JVCkNCisJ
CQltc2xlZXAoMTAwKTsNCisNCiAJCXJlc3VsdCA9IHVzYl9nZXRfZGVzY3JpcHRvcihkZXYsIFVT
Ql9EVF9DT05GSUcsIGNmZ25vLA0KIAkJICAgIGJpZ2J1ZmZlciwgbGVuZ3RoKTsNCiAJCWlmIChy
ZXN1bHQgPCAwKSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvY29yZS9xdWlya3MuYyBiL2Ry
aXZlcnMvdXNiL2NvcmUvcXVpcmtzLmMNCmluZGV4IGJjZGU2ZjYuLjM2NzdkMjIgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3VzYi9jb3JlL3F1aXJrcy5jDQorKysgYi9kcml2ZXJzL3VzYi9jb3JlL3F1
aXJrcy5jDQpAQCAtNDYsNiArNDYsMTAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNl
X2lkIHVzYl9xdWlya19saXN0W10gPSB7DQogCS8qIE1pY3Jvc29mdCBMaWZlQ2FtLVZYNzAwIHYy
LjAgKi8NCiAJeyBVU0JfREVWSUNFKDB4MDQ1ZSwgMHgwNzcwKSwgLmRyaXZlcl9pbmZvID0gVVNC
X1FVSVJLX1JFU0VUX1JFU1VNRSB9LA0KIA0KKwkvKiBMb2dpdGVjaCBIRCBQcm8gV2ViY2FtcyBD
OTIwIGFuZCBDOTMwZSAqLw0KKwl7IFVTQl9ERVZJQ0UoMHgwNDZkLCAweDA4MmQpLCAuZHJpdmVy
X2luZm8gPSBVU0JfUVVJUktfREVMQVlfSU5JVCB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgwNDZkLCAw
eDA4NDMpLCAuZHJpdmVyX2luZm8gPSBVU0JfUVVJUktfREVMQVlfSU5JVCB9LA0KKw0KIAkvKiBM
b2dpdGVjaCBRdWlja2NhbSBGdXNpb24gKi8NCiAJeyBVU0JfREVWSUNFKDB4MDQ2ZCwgMHgwOGMx
KSwgLmRyaXZlcl9pbmZvID0gVVNCX1FVSVJLX1JFU0VUX1JFU1VNRSB9LA0KIA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdXNiL2hvc3QvZWhjaS1oY2QuYyBiL2RyaXZlcnMvdXNiL2hvc3QvZWhjaS1o
Y2QuYw0KaW5kZXggMzM5YmUxMC4uMmFiZGFkNiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2hv
c3QvZWhjaS1oY2QuYw0KKysrIGIvZHJpdmVycy91c2IvaG9zdC9laGNpLWhjZC5jDQpAQCAtODA3
LDggKzgwNywxNSBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgZWhjaV9pcnEgKHN0cnVjdCB1c2JfaGNk
ICpoY2QpDQogCXN0cnVjdCBlaGNpX2hjZAkJKmVoY2kgPSBoY2RfdG9fZWhjaSAoaGNkKTsNCiAJ
dTMyCQkJc3RhdHVzLCBtYXNrZWRfc3RhdHVzLCBwY2Rfc3RhdHVzID0gMCwgY21kOw0KIAlpbnQJ
CQliaDsNCisJdW5zaWduZWQgbG9uZwkJZmxhZ3M7DQogDQotCXNwaW5fbG9jayAoJmVoY2ktPmxv
Y2spOw0KKwkvKg0KKwkgKiBGb3IgdGhyZWFkaXJxcyBvcHRpb24gd2UgdXNlIHNwaW5fbG9ja19p
cnFzYXZlKCkgdmFyaWFudCB0byBwcmV2ZW50DQorCSAqIGRlYWRsb2NrIHdpdGggZWhjaSBocnRp
bWVyIGNhbGxiYWNrLCBiZWNhdXNlIGhydGltZXIgY2FsbGJhY2tzIHJ1bg0KKwkgKiBpbiBpbnRl
cnJ1cHQgY29udGV4dCBldmVuIHdoZW4gdGhyZWFkaXJxcyBpcyBzcGVjaWZpZWQuIFdlIGNhbiBn
bw0KKwkgKiBiYWNrIHRvIHNwaW5fbG9jaygpIHZhcmlhbnQgd2hlbiBocnRpbWVyIGNhbGxiYWNr
cyBiZWNvbWUgdGhyZWFkZWQuDQorCSAqLw0KKwlzcGluX2xvY2tfaXJxc2F2ZSgmZWhjaS0+bG9j
aywgZmxhZ3MpOw0KIA0KIAlzdGF0dXMgPSBlaGNpX3JlYWRsKGVoY2ksICZlaGNpLT5yZWdzLT5z
dGF0dXMpOw0KIA0KQEAgLTgyNiw3ICs4MzMsNyBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgZWhjaV9p
cnEgKHN0cnVjdCB1c2JfaGNkICpoY2QpDQogDQogCS8qIFNoYXJlZCBJUlE/ICovDQogCWlmICgh
bWFza2VkX3N0YXR1cyB8fCB1bmxpa2VseShlaGNpLT5yaF9zdGF0ZSA9PSBFSENJX1JIX0hBTFRF
RCkpIHsNCi0JCXNwaW5fdW5sb2NrKCZlaGNpLT5sb2NrKTsNCisJCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoJmVoY2ktPmxvY2ssIGZsYWdzKTsNCiAJCXJldHVybiBJUlFfTk9ORTsNCiAJfQ0KIA0K
QEAgLTkyOSw3ICs5MzYsNyBAQCBkZWFkOg0KIA0KIAlpZiAoYmgpDQogCQllaGNpX3dvcmsgKGVo
Y2kpOw0KLQlzcGluX3VubG9jayAoJmVoY2ktPmxvY2spOw0KKwlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZlaGNpLT5sb2NrLCBmbGFncyk7DQogCWlmIChwY2Rfc3RhdHVzKQ0KIAkJdXNiX2hjZF9w
b2xsX3JoX3N0YXR1cyhoY2QpOw0KIAlyZXR1cm4gSVJRX0hBTkRMRUQ7DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy91c2IvaG9zdC9laGNpLWh1Yi5jIGIvZHJpdmVycy91c2IvaG9zdC9laGNpLWh1Yi5j
DQppbmRleCA3N2JiYjIzLi40NTI3YjkwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvaG9zdC9l
aGNpLWh1Yi5jDQorKysgYi9kcml2ZXJzL3VzYi9ob3N0L2VoY2ktaHViLmMNCkBAIC0yMDcsNiAr
MjA3LDcgQEAgc3RhdGljIGludCBlaGNpX2J1c19zdXNwZW5kIChzdHJ1Y3QgdXNiX2hjZCAqaGNk
KQ0KIAlpbnQJCQlwb3J0Ow0KIAlpbnQJCQltYXNrOw0KIAlpbnQJCQljaGFuZ2VkOw0KKwlib29s
CQkJZnNfaWRsZV9kZWxheTsNCiANCiAJZWhjaV9kYmcoZWhjaSwgInN1c3BlbmQgcm9vdCBodWJc
biIpOw0KIA0KQEAgLTI0OSw2ICsyNTAsNyBAQCBzdGF0aWMgaW50IGVoY2lfYnVzX3N1c3BlbmQg
KHN0cnVjdCB1c2JfaGNkICpoY2QpDQogCWVoY2ktPmJ1c19zdXNwZW5kZWQgPSAwOw0KIAllaGNp
LT5vd25lZF9wb3J0cyA9IDA7DQogCWNoYW5nZWQgPSAwOw0KKwlmc19pZGxlX2RlbGF5ID0gZmFs
c2U7DQogCXBvcnQgPSBIQ1NfTl9QT1JUUyhlaGNpLT5oY3NfcGFyYW1zKTsNCiAJd2hpbGUgKHBv
cnQtLSkgew0KIAkJdTMyIF9faW9tZW0JKnJlZyA9ICZlaGNpLT5yZWdzLT5wb3J0X3N0YXR1cyBb
cG9ydF07DQpAQCAtMjc5LDE2ICsyODEsMzQgQEAgc3RhdGljIGludCBlaGNpX2J1c19zdXNwZW5k
IChzdHJ1Y3QgdXNiX2hjZCAqaGNkKQ0KIAkJaWYgKHQxICE9IHQyKSB7DQogCQkJZWhjaV92ZGJn
IChlaGNpLCAicG9ydCAlZCwgJTA4eCAtPiAlMDh4XG4iLA0KIAkJCQlwb3J0ICsgMSwgdDEsIHQy
KTsNCisJCQkvKg0KKwkJCSAqIE9uIHNvbWUgY29udHJvbGxlcnMsIFdha2UtT24tRGlzY29ubmVj
dCB3aWxsDQorCQkJICogZ2VuZXJhdGUgZmFsc2Ugd2FrZXVwIHNpZ25hbHMgdW50aWwgdGhlIGJ1
cw0KKwkJCSAqIHN3aXRjaGVzIG92ZXIgdG8gZnVsbC1zcGVlZCBpZGxlLiAgRm9yIHRoZWlyDQor
CQkJICogc2FrZSwgYWRkIGEgZGVsYXkgaWYgd2UgbmVlZCBvbmUuDQorCQkJICovDQorCQkJaWYg
KCh0MiAmIFBPUlRfV0tESVNDX0UpICYmDQorCQkJCQllaGNpX3BvcnRfc3BlZWQoZWhjaSwgdDIp
ID09DQorCQkJCQkJVVNCX1BPUlRfU1RBVF9ISUdIX1NQRUVEKQ0KKwkJCQlmc19pZGxlX2RlbGF5
ID0gdHJ1ZTsNCiAJCQllaGNpX3dyaXRlbChlaGNpLCB0MiwgcmVnKTsNCiAJCQljaGFuZ2VkID0g
MTsNCiAJCX0NCiAJfQ0KKwlzcGluX3VubG9ja19pcnEoJmVoY2ktPmxvY2spOw0KKw0KKwlpZiAo
KGNoYW5nZWQgJiYgZWhjaS0+aGFzX2hvc3RwYykgfHwgZnNfaWRsZV9kZWxheSkgew0KKwkJLyoN
CisJCSAqIFdhaXQgZm9yIEhDRCB0byBlbnRlciBsb3ctcG93ZXIgbW9kZSBvciBmb3IgdGhlIGJ1
cw0KKwkJICogdG8gc3dpdGNoIHRvIGZ1bGwtc3BlZWQgaWRsZS4NCisJCSAqLw0KKwkJdXNsZWVw
X3JhbmdlKDUwMDAsIDU1MDApOw0KKwl9DQorDQorCXNwaW5fbG9ja19pcnEoJmVoY2ktPmxvY2sp
Ow0KIA0KIAlpZiAoY2hhbmdlZCAmJiBlaGNpLT5oYXNfaG9zdHBjKSB7DQotCQlzcGluX3VubG9j
a19pcnEoJmVoY2ktPmxvY2spOw0KLQkJbXNsZWVwKDUpOwkvKiA1IG1zIGZvciBIQ0QgdG8gZW50
ZXIgbG93LXBvd2VyIG1vZGUgKi8NCiAJCXNwaW5fbG9ja19pcnEoJmVoY2ktPmxvY2spOw0KLQ0K
IAkJcG9ydCA9IEhDU19OX1BPUlRTKGVoY2ktPmhjc19wYXJhbXMpOw0KIAkJd2hpbGUgKHBvcnQt
LSkgew0KIAkJCXUzMiBfX2lvbWVtCSpob3N0cGNfcmVnOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dXNiL2hvc3QvZWhjaS5oIGIvZHJpdmVycy91c2IvaG9zdC9laGNpLmgNCmluZGV4IDBhNWZkYTcu
LmI2NTkxMmQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0L2VoY2kuaA0KKysrIGIvZHJp
dmVycy91c2IvaG9zdC9laGNpLmgNCkBAIC0xNDcsNiArMTQ3LDcgQEAgc3RydWN0IGVoY2lfaGNk
IHsJCQkvKiBvbmUgcGVyIGNvbnRyb2xsZXIgKi8NCiAJdW5zaWduZWQJCXVzZV9kdW1teV9xaDox
OwkvKiBBTUQgRnJhbWUgTGlzdCB0YWJsZSBxdWlyayovDQogCXVuc2lnbmVkCQloYXNfc3lub3Bz
eXNfaGNfYnVnOjE7IC8qIFN5bm9wc3lzIEhDICovDQogCXVuc2lnbmVkCQlmcmFtZV9pbmRleF9i
dWc6MTsgLyogTW9zQ2hpcCAoQUtBIE5ldE1vcykgKi8NCisJdW5zaWduZWQJCWlteDI4X3dyaXRl
X2ZpeDoxOyAvKiBGb3IgRnJlZXNjYWxlIGkuTVgyOCAqLw0KIA0KIAkvKiByZXF1aXJlZCBmb3Ig
dXNiMzIgcXVpcmsgKi8NCiAJI2RlZmluZSBPSENJX0NUUkxfSENGUyAgICAgICAgICAoMyA8PCA2
KQ0KQEAgLTY1NCw2ICs2NTUsMTggQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgZWhjaV9y
ZWFkbChjb25zdCBzdHJ1Y3QgZWhjaV9oY2QgKmVoY2ksDQogI2VuZGlmDQogfQ0KIA0KKyNpZmRl
ZiBDT05GSUdfU09DX0lNWDI4DQorc3RhdGljIGlubGluZSB2b2lkIGlteDI4X2VoY2lfd3JpdGVs
KGNvbnN0IHVuc2lnbmVkIGludCB2YWwsDQorCQl2b2xhdGlsZSBfX3UzMiBfX2lvbWVtICphZGRy
KQ0KK3sNCisJX19hc21fXyAoInN3cCAlMCwgJTAsIFslMV0iIDogOiAiciIodmFsKSwgInIiKGFk
ZHIpKTsNCit9DQorI2Vsc2UNCitzdGF0aWMgaW5saW5lIHZvaWQgaW14MjhfZWhjaV93cml0ZWwo
Y29uc3QgdW5zaWduZWQgaW50IHZhbCwNCisJCXZvbGF0aWxlIF9fdTMyIF9faW9tZW0gKmFkZHIp
DQorew0KK30NCisjZW5kaWYNCiBzdGF0aWMgaW5saW5lIHZvaWQgZWhjaV93cml0ZWwoY29uc3Qg
c3RydWN0IGVoY2lfaGNkICplaGNpLA0KIAkJY29uc3QgdW5zaWduZWQgaW50IHZhbCwgX191MzIg
X19pb21lbSAqcmVncykNCiB7DQpAQCAtNjYyLDcgKzY3NSwxMCBAQCBzdGF0aWMgaW5saW5lIHZv
aWQgZWhjaV93cml0ZWwoY29uc3Qgc3RydWN0IGVoY2lfaGNkICplaGNpLA0KIAkJd3JpdGVsX2Jl
KHZhbCwgcmVncykgOg0KIAkJd3JpdGVsKHZhbCwgcmVncyk7DQogI2Vsc2UNCi0Jd3JpdGVsKHZh
bCwgcmVncyk7DQorCWlmIChlaGNpLT5pbXgyOF93cml0ZV9maXgpDQorCQlpbXgyOF9laGNpX3dy
aXRlbCh2YWwsIHJlZ3MpOw0KKwllbHNlDQorCQl3cml0ZWwodmFsLCByZWdzKTsNCiAjZW5kaWYN
CiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL2N5cHJlc3NfbTguaCBiL2Ry
aXZlcnMvdXNiL3NlcmlhbC9jeXByZXNzX204LmgNCmluZGV4IGI0NjEzMTEuLmNlMTNlNjEgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvY3lwcmVzc19tOC5oDQorKysgYi9kcml2ZXJz
L3VzYi9zZXJpYWwvY3lwcmVzc19tOC5oDQpAQCAtNjMsNyArNjMsNyBAQA0KICNkZWZpbmUgVUFS
VF9EU1IJMHgyMAkvKiBkYXRhIHNldCByZWFkeSAtIGZsb3cgY29udHJvbCAtIGRldmljZSB0byBo
b3N0ICovDQogI2RlZmluZSBDT05UUk9MX1JUUwkweDEwCS8qIHJlcXVlc3QgdG8gc2VuZCAtIGZs
b3cgY29udHJvbCAtIGhvc3QgdG8gZGV2aWNlICovDQogI2RlZmluZSBVQVJUX0NUUwkweDEwCS8q
IGNsZWFyIHRvIHNlbmQgLSBmbG93IGNvbnRyb2wgLSBkZXZpY2UgdG8gaG9zdCAqLw0KLSNkZWZp
bmUgVUFSVF9SSQkJMHgxMAkvKiByaW5nIGluZGljYXRvciAtIG1vZGVtIC0gZGV2aWNlIHRvIGhv
c3QgKi8NCisjZGVmaW5lIFVBUlRfUkkJCTB4ODAJLyogcmluZyBpbmRpY2F0b3IgLSBtb2RlbSAt
IGRldmljZSB0byBob3N0ICovDQogI2RlZmluZSBVQVJUX0NECQkweDQwCS8qIGNhcnJpZXIgZGV0
ZWN0IC0gbW9kZW0gLSBkZXZpY2UgdG8gaG9zdCAqLw0KICNkZWZpbmUgQ1lQX0VSUk9SCTB4MDgJ
LyogcmVjZWl2ZWQgZnJvbSBpbnB1dCByZXBvcnQgLSBkZXZpY2UgdG8gaG9zdCAqLw0KIC8qIE5v
dGUgLSB0aGUgYmVsb3cgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCB0aGUgImZlYXR1cmUgcmVwb3J0
IiByZXNldCAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jIGIv
ZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lvLmMNCmluZGV4IDg1NTA0YmIuLjVjOTdkOWYgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8uYw0KKysrIGIvZHJpdmVycy91
c2Ivc2VyaWFsL2Z0ZGlfc2lvLmMNCkBAIC0xNjMsNiArMTYzLDcgQEAgc3RhdGljIHN0cnVjdCB1
c2JfZGV2aWNlX2lkIGlkX3RhYmxlX2NvbWJpbmVkIFtdID0gew0KIAl7IFVTQl9ERVZJQ0UoRlRE
SV9WSUQsIEZURElfQ0FOVVNCX1BJRCkgfSwNCiAJeyBVU0JfREVWSUNFKEZURElfVklELCBGVERJ
X0NBTkRBUFRFUl9QSUQpIH0sDQogCXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9OWFRDQU1f
UElEKSB9LA0KKwl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfRVYzQ09OX1BJRCkgfSwNCiAJ
eyBVU0JfREVWSUNFKEZURElfVklELCBGVERJX1NDU19ERVZJQ0VfMF9QSUQpIH0sDQogCXsgVVNC
X0RFVklDRShGVERJX1ZJRCwgRlRESV9TQ1NfREVWSUNFXzFfUElEKSB9LA0KIAl7IFVTQl9ERVZJ
Q0UoRlRESV9WSUQsIEZURElfU0NTX0RFVklDRV8yX1BJRCkgfSwNCkBAIC0yMDIsNiArMjAzLDgg
QEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGlkX3RhYmxlX2NvbWJpbmVkIFtdID0gew0K
IAl7IFVTQl9ERVZJQ0UoSU5URVJCSU9NRVRSSUNTX1ZJRCwgSU5URVJCSU9NRVRSSUNTX0lPQk9B
UkRfUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoSU5URVJCSU9NRVRSSUNTX1ZJRCwgSU5URVJCSU9N
RVRSSUNTX01JTklfSU9CT0FSRF9QSUQpIH0sDQogCXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRE
SV9TUFJPR19JSSkgfSwNCisJeyBVU0JfREVWSUNFKEZURElfVklELCBGVERJX1RBR1NZU19MUDEw
MV9QSUQpIH0sDQorCXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9UQUdTWVNfUDIwMFhfUElE
KSB9LA0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfTEVOWl9MSVVTQl9QSUQpIH0sDQog
CXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9YRl82MzJfUElEKSB9LA0KIAl7IFVTQl9ERVZJ
Q0UoRlRESV9WSUQsIEZURElfWEZfNjM0X1BJRCkgfSwNCkBAIC05MTQsNiArOTE3LDkgQEAgc3Rh
dGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGlkX3RhYmxlX2NvbWJpbmVkIFtdID0gew0KIAl7IFVT
Ql9ERVZJQ0UoRlRESV9WSUQsIEZURElfTFVNRUxfUEQxMl9QSUQpIH0sDQogCS8qIENydWNpYmxl
IERldmljZXMgKi8NCiAJeyBVU0JfREVWSUNFKEZURElfVklELCBGVERJX0NUX0NPTUVUX1BJRCkg
fSwNCisJeyBVU0JfREVWSUNFKEZURElfVklELCBGVERJX1ozWF9QSUQpIH0sDQorCS8qIENyZXNz
aSBEZXZpY2VzICovDQorCXsgVVNCX0RFVklDRShGVERJX1ZJRCwgRlRESV9DUkVTU0lfUElEKSB9
LA0KIAl7IH0sCQkJCQkvKiBPcHRpb25hbCBwYXJhbWV0ZXIgZW50cnkgKi8NCiAJeyB9CQkJCQkv
KiBUZXJtaW5hdGluZyBlbnRyeSAqLw0KIH07DQpAQCAtMjE5MywxMCArMjE5OSwyMCBAQCBzdGF0
aWMgdm9pZCBmdGRpX3NldF90ZXJtaW9zKHN0cnVjdCB0dHlfc3RydWN0ICp0dHksDQogCX0NCiAN
CiAJLyoNCi0JICogQWxsIEZUREkgVUFSVCBjaGlwcyBhcmUgbGltaXRlZCB0byBDUzcvOC4gV2Ug
d29uJ3QgcHJldGVuZCB0bw0KKwkgKiBBbGwgRlRESSBVQVJUIGNoaXBzIGFyZSBsaW1pdGVkIHRv
IENTNy84LiBXZSBzaG91bGRuJ3QgcHJldGVuZCB0bw0KIAkgKiBzdXBwb3J0IENTNS82IGFuZCBy
ZXZlcnQgdGhlIENTSVpFIHNldHRpbmcgaW5zdGVhZC4NCisJICoNCisJICogQ1M1IGhvd2V2ZXIg
aXMgdXNlZCB0byBjb250cm9sIHNvbWUgc21hcnRjYXJkIHJlYWRlcnMgd2hpY2ggYWJ1c2UNCisJ
ICogdGhpcyBsaW1pdGF0aW9uIHRvIHN3aXRjaCBtb2Rlcy4gT3JpZ2luYWwgRlRESSBjaGlwcyBm
YWxsIGJhY2sgdG8NCisJICogZWlnaHQgZGF0YSBiaXRzLg0KKwkgKg0KKwkgKiBUT0RPOiBJbXBs
ZW1lbnQgYSBxdWlyayB0byBvbmx5IGFsbG93IHRoaXMgd2l0aCBtZW50aW9uZWQNCisJICogICAg
ICAgcmVhZGVycy4gT25lIEkga25vdyBvZiAoQXJnb2xpcyBTbWFydHJlYWRlciBWMSkNCisJICog
ICAgICAgcmV0dXJucyAiVVNCIHNtYXJ0Y2FyZCBzZXJ2ZXIiIGFzIGlJbnRlcmZhY2Ugc3RyaW5n
Lg0KKwkgKiAgICAgICBUaGUgdmVuZG9yIGRpZG4ndCBib3RoZXIgd2l0aCBhIGN1c3RvbSBWSUQv
UElEIG9mDQorCSAqICAgICAgIGNvdXJzZS4NCiAJICovDQotCWlmICgoQ19DU0laRSh0dHkpICE9
IENTOCkgJiYgKENfQ1NJWkUodHR5KSAhPSBDUzcpKSB7DQorCWlmIChDX0NTSVpFKHR0eSkgPT0g
Q1M2KSB7DQogCQlkZXZfd2FybigmcG9ydC0+ZGV2LCAicmVxdWVzdGVkIENTSVpFIHNldHRpbmcg
bm90IHN1cHBvcnRlZFxuIik7DQogDQogCQl0ZXJtaW9zLT5jX2NmbGFnICY9IH5DU0laRTsNCkBA
IC0yMjQzLDYgKzIyNTksOSBAQCBub19za2lwOg0KIAkJdXJiX3ZhbHVlIHw9IEZURElfU0lPX1NF
VF9EQVRBX1BBUklUWV9OT05FOw0KIAl9DQogCXN3aXRjaCAoY2ZsYWcgJiBDU0laRSkgew0KKwlj
YXNlIENTNToNCisJCWRldl9kYmcoJnBvcnQtPmRldiwgIlNldHRpbmcgQ1M1IHF1aXJrXG4iKTsN
CisJCWJyZWFrOw0KIAljYXNlIENTNzoNCiAJCXVyYl92YWx1ZSB8PSA3Ow0KIAkJZGV2X2RiZygm
cG9ydC0+ZGV2LCAiU2V0dGluZyBDUzdcbiIpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3Nl
cmlhbC9mdGRpX3Npb19pZHMuaCBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npb19pZHMuaA0K
aW5kZXggNjE2ODVlZC4uNzFmZTJkZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9m
dGRpX3Npb19pZHMuaA0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lvX2lkcy5oDQpA
QCAtNTAsNiArNTAsNyBAQA0KICNkZWZpbmUgVElfWERTMTAwVjJfUElECQkweGE2ZDANCiANCiAj
ZGVmaW5lIEZURElfTlhUQ0FNX1BJRAkJMHhBQkI4IC8qIE5YVENhbSBmb3IgTWluZHN0b3JtcyBO
WFQgKi8NCisjZGVmaW5lIEZURElfRVYzQ09OX1BJRAkJMHhBQkI5IC8qIE1pbmRzdG9ybXMgRVYz
IENvbnNvbGUgQWRhcHRlciAqLw0KIA0KIC8qIFVTIEludGVyZmFjZSBOYXZpZ2F0b3IgKGh0dHA6
Ly93d3cudXNpbnRlcmZhY2UuY29tLykgKi8NCiAjZGVmaW5lIEZURElfVVNJTlRfQ0FUX1BJRAkw
eGI4MTAJLyogTmF2aWdhdG9yIENBVCBhbmQgMm5kIFBUVCBsaW5lcyAqLw0KQEAgLTM2Myw2ICsz
NjQsMTIgQEANCiAvKiBTcHJvZyBJSSAoQW5kcmV3IENyb3NsYW5kJ3MgU3Byb2dJSSBEQ0MgaW50
ZXJmYWNlKSAqLw0KICNkZWZpbmUgRlRESV9TUFJPR19JSQkJMHhGMEM4DQogDQorLyoNCisgKiBU
d28gb2YgdGhlIFRhZ3N5cyBSRklEIFJlYWRlcnMNCisgKi8NCisjZGVmaW5lIEZURElfVEFHU1lT
X0xQMTAxX1BJRAkweEYwRTkJLyogVGFnc3lzIEwtUDEwMSBSRklEKi8NCisjZGVmaW5lIEZURElf
VEFHU1lTX1AyMDBYX1BJRAkweEYwRUUJLyogVGFnc3lzIE1lZGlvIFAyMDB4IFJGSUQqLw0KKw0K
IC8qIGFuIGluZnJhcmVkIHJlY2VpdmVyIGZvciB1c2VyIGFjY2VzcyBjb250cm9sIHdpdGggSVIg
dGFncyAqLw0KICNkZWZpbmUgRlRESV9QSUVHUk9VUF9QSUQJMHhGMjA4CS8qIFByb2R1Y3QgSWQg
Ki8NCiANCkBAIC0xMzA3LDMgKzEzMTQsMTUgQEANCiAgKiBNYW51ZmFjdHVyZXI6IENydWNpYmxl
IFRlY2hub2xvZ2llcw0KICAqLw0KICNkZWZpbmUgRlRESV9DVF9DT01FVF9QSUQJMHg4ZTA4DQor
DQorLyoNCisgKiBQcm9kdWN0OiBaM1ggQm94DQorICogTWFudWZhY3R1cmVyOiBTbWFydCBHU00g
VGVhbQ0KKyAqLw0KKyNkZWZpbmUgRlRESV9aM1hfUElECQkweDAwMTENCisNCisvKg0KKyAqIFBy
b2R1Y3Q6IENyZXNzaSBQQyBJbnRlcmZhY2UNCisgKiBNYW51ZmFjdHVyZXI6IENyZXNzaQ0KKyAq
Lw0KKyNkZWZpbmUgRlRESV9DUkVTU0lfUElECQkweDg3ZDANCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3VzYi9zZXJpYWwvb3B0aW9uLmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9uLmMNCmluZGV4
IGQ2ZDBmYjQuLjVmNTA0N2YgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9u
LmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYw0KQEAgLTMyNSw2ICszMjUsOSBA
QCBzdGF0aWMgdm9pZCBvcHRpb25faW5zdGF0X2NhbGxiYWNrKHN0cnVjdCB1cmIgKnVyYik7DQog
ICogSXQgc2VlbXMgdG8gY29udGFpbiBhIFF1YWxjb21tIFFTQzYyNDAvNjI5MCBjaGlwc2V0ICAg
ICAgICAgICAgKi8NCiAjZGVmaW5lIEZPVVJfR19TWVNURU1TX1BST0RVQ1RfVzE0CQkweDk2MDMN
CiANCisvKiBpQmFsbCAzLjVHIGNvbm5lY3Qgd2lyZWxlc3MgbW9kZW0gKi8NCisjZGVmaW5lIElC
QUxMXzNfNUdfQ09OTkVDVAkJCTB4OTYwNQ0KKw0KIC8qIFpvb20gKi8NCiAjZGVmaW5lIFpPT01f
UFJPRFVDVF80NTk3CQkJMHg5NjA3DQogDQpAQCAtMTM3Myw3ICsxMzc2LDggQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9wdGlvbl9pZHNbXSA9IHsNCiAJeyBVU0JfREVWSUNF
X0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDEyNjcsIDB4ZmYsIDB4ZmYsIDB4
ZmYpIH0sDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwg
MHgxMjY4LCAweGZmLCAweGZmLCAweGZmKSB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFD
RV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4MTI2OSwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCi0JeyBV
U0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDEyNzAsIDB4ZmYs
IDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZF
TkRPUl9JRCwgMHgxMjcwLCAweGZmLCAweGZmLCAweGZmKSwNCisJICAuZHJpdmVyX2luZm8gPSAo
a2VybmVsX3Vsb25nX3QpJm5ldF9pbnRmNV9ibGFja2xpc3QgfSwNCiAJeyBVU0JfREVWSUNFX0FO
RF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDEyNzEsIDB4ZmYsIDB4ZmYsIDB4ZmYp
IH0sDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgx
MjcyLCAweGZmLCAweGZmLCAweGZmKSB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9J
TkZPKFpURV9WRU5ET1JfSUQsIDB4MTI3MywgMHhmZiwgMHhmZiwgMHhmZikgfSwNCkBAIC0xNDYx
LDYgKzE0NjUsMTcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9wdGlvbl9p
ZHNbXSA9IHsNCiAJCS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmbmV0X2ludGYzX2Js
YWNrbGlzdCB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1Jf
SUQsIDB4MDE3OCwgMHhmZiwgMHhmZiwgMHhmZiksDQogCQkuZHJpdmVyX2luZm8gPSAoa2VybmVs
X3Vsb25nX3QpJm5ldF9pbnRmM19ibGFja2xpc3QgfSwNCisJeyBVU0JfREVWSUNFX0FORF9JTlRF
UkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweGZmZTksIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQor
CXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHhmZjhiLCAw
eGZmLCAweGZmLCAweGZmKSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpU
RV9WRU5ET1JfSUQsIDB4ZmY4YywgMHhmZiwgMHhmZiwgMHhmZikgfSwNCisJeyBVU0JfREVWSUNF
X0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweGZmOGQsIDB4ZmYsIDB4ZmYsIDB4
ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwg
MHhmZjhlLCAweGZmLCAweGZmLCAweGZmKSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFD
RV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4ZmY4ZiwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCisJeyBV
U0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweGZmOTAsIDB4ZmYs
IDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZF
TkRPUl9JRCwgMHhmZjkxLCAweGZmLCAweGZmLCAweGZmKSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5E
X0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4ZmY5MiwgMHhmZiwgMHhmZiwgMHhmZikg
fSwNCisJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweGZm
OTMsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lO
Rk8oWlRFX1ZFTkRPUl9JRCwgMHhmZjk0LCAweGZmLCAweGZmLCAweGZmKSB9LA0KIA0KIAl7IFVT
Ql9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIFpURV9QUk9EVUNUX0NE
TUFfVEVDSCwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCiAJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZB
Q0VfSU5GTyhaVEVfVkVORE9SX0lELCBaVEVfUFJPRFVDVF9BQzg3MTAsIDB4ZmYsIDB4ZmYsIDB4
ZmYpIH0sDQpAQCAtMTUwOSw2ICsxNTI0LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2
aWNlX2lkIG9wdGlvbl9pZHNbXSA9IHsNCiAgIAkgIC5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxv
bmdfdCkmZm91cl9nX3cxNF9ibGFja2xpc3QNCiAgIAl9LA0KIAl7IFVTQl9ERVZJQ0UoTE9OR0NI
RUVSX1ZFTkRPUl9JRCwgWk9PTV9QUk9EVUNUXzQ1OTcpIH0sDQorCXsgVVNCX0RFVklDRShMT05H
Q0hFRVJfVkVORE9SX0lELCBJQkFMTF8zXzVHX0NPTk5FQ1QpIH0sDQogCXsgVVNCX0RFVklDRShI
QUlFUl9WRU5ET1JfSUQsIEhBSUVSX1BST0RVQ1RfQ0UxMDApIH0sDQogCS8qIFBpcmVsbGkgICov
DQogCXsgVVNCX0RFVklDRShQSVJFTExJX1ZFTkRPUl9JRCwgUElSRUxMSV9QUk9EVUNUX0MxMDBf
MSl9LA0KQEAgLTE1MzAsNyArMTU0Niw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2Rldmlj
ZV9pZCBvcHRpb25faWRzW10gPSB7DQogCS8qIENpbnRlcmlvbiAqLw0KIAl7IFVTQl9ERVZJQ0Uo
Q0lOVEVSSU9OX1ZFTkRPUl9JRCwgQ0lOVEVSSU9OX1BST0RVQ1RfRVUzX0UpIH0sDQogCXsgVVNC
X0RFVklDRShDSU5URVJJT05fVkVORE9SX0lELCBDSU5URVJJT05fUFJPRFVDVF9FVTNfUCkgfSwN
Ci0JeyBVU0JfREVWSUNFKENJTlRFUklPTl9WRU5ET1JfSUQsIENJTlRFUklPTl9QUk9EVUNUX1BI
OCkgfSwNCisJeyBVU0JfREVWSUNFKENJTlRFUklPTl9WRU5ET1JfSUQsIENJTlRFUklPTl9QUk9E
VUNUX1BIOCksDQorCQkuZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpJm5ldF9pbnRmNF9i
bGFja2xpc3QgfSwNCiAJeyBVU0JfREVWSUNFKENJTlRFUklPTl9WRU5ET1JfSUQsIENJTlRFUklP
Tl9QUk9EVUNUX0FIWFgpIH0sDQogCXsgVVNCX0RFVklDRShDSU5URVJJT05fVkVORE9SX0lELCBD
SU5URVJJT05fUFJPRFVDVF9QTFhYKSwNCiAJCS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdf
dCkmbmV0X2ludGY0X2JsYWNrbGlzdCB9LA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3Nlcmlh
bC9wbDIzMDMuYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9wbDIzMDMuYw0KaW5kZXggZTM5MzZjMS4u
N2IyOTMxNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9wbDIzMDMuYw0KKysrIGIv
ZHJpdmVycy91c2Ivc2VyaWFsL3BsMjMwMy5jDQpAQCAtMTUzLDYgKzE1Myw4IEBAIHN0cnVjdCBw
bDIzMDNfcHJpdmF0ZSB7DQogCXU4IGxpbmVfY29udHJvbDsNCiAJdTggbGluZV9zdGF0dXM7DQog
CWVudW0gcGwyMzAzX3R5cGUgdHlwZTsNCisNCisJdTggbGluZV9zZXR0aW5nc1s3XTsNCiB9Ow0K
IA0KIHN0YXRpYyBpbnQgcGwyMzAzX3ZlbmRvcl9yZWFkKF9fdTE2IHZhbHVlLCBfX3UxNiBpbmRl
eCwNCkBAIC0yNjYsMTAgKzI2OCw2IEBAIHN0YXRpYyB2b2lkIHBsMjMwM19zZXRfdGVybWlvcyhz
dHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LA0KIA0KIAlkYmcoIiVzIC0gIHBvcnQgJWQiLCBfX2Z1bmNf
XywgcG9ydC0+bnVtYmVyKTsNCiANCi0JLyogVGhlIFBMMjMwMyBpcyByZXBvcnRlZCB0byBsb3Nl
IGJ5dGVzIGlmIHlvdSBjaGFuZ2UNCi0JICAgc2VyaWFsIHNldHRpbmdzIGV2ZW4gdG8gdGhlIHNh
bWUgdmFsdWVzIGFzIGJlZm9yZS4gVGh1cw0KLQkgICB3ZSBhY3R1YWxseSBuZWVkIHRvIGZpbHRl
ciBpbiB0aGlzIHNwZWNpZmljIGNhc2UgKi8NCi0NCiAJaWYgKG9sZF90ZXJtaW9zICYmICF0dHlf
dGVybWlvc19od19jaGFuZ2UodHR5LT50ZXJtaW9zLCBvbGRfdGVybWlvcykpDQogCQlyZXR1cm47
DQogDQpAQCAtNDA3LDEwICs0MDUsMjkgQEAgc3RhdGljIHZvaWQgcGwyMzAzX3NldF90ZXJtaW9z
KHN0cnVjdCB0dHlfc3RydWN0ICp0dHksDQogCQlkYmcoIiVzIC0gcGFyaXR5ID0gbm9uZSIsIF9f
ZnVuY19fKTsNCiAJfQ0KIA0KLQlpID0gdXNiX2NvbnRyb2xfbXNnKHNlcmlhbC0+ZGV2LCB1c2Jf
c25kY3RybHBpcGUoc2VyaWFsLT5kZXYsIDApLA0KLQkJCSAgICBTRVRfTElORV9SRVFVRVNULCBT
RVRfTElORV9SRVFVRVNUX1RZUEUsDQotCQkJICAgIDAsIDAsIGJ1ZiwgNywgMTAwKTsNCi0JZGJn
KCIweDIxOjB4MjA6MDowICAlZCIsIGkpOw0KKwkvKg0KKwkgKiBTb21lIFBMMjMwMyBhcmUga25v
d24gdG8gbG9zZSBieXRlcyBpZiB5b3UgY2hhbmdlIHNlcmlhbCBzZXR0aW5ncw0KKwkgKiBldmVu
IHRvIHRoZSBzYW1lIHZhbHVlcyBhcyBiZWZvcmUuIFRodXMgd2UgYWN0dWFsbHkgbmVlZCB0byBm
aWx0ZXINCisJICogaW4gdGhpcyBzcGVjaWZpYyBjYXNlLg0KKwkgKg0KKwkgKiBOb3RlIHRoYXQg
dGhlIHR0eV90ZXJtaW9zX2h3X2NoYW5nZSBjaGVjayBhYm92ZSBpcyBub3Qgc3VmZmljaWVudA0K
KwkgKiBhcyBhIHByZXZpb3VzbHkgcmVxdWVzdGVkIGJhdWQgcmF0ZSBtYXkgZGlmZmVyIGZyb20g
dGhlIG9uZQ0KKwkgKiBhY3R1YWxseSB1c2VkIChhbmQgc3RvcmVkIGluIG9sZF90ZXJtaW9zKS4N
CisJICoNCisJICogTk9URTogTm8gYWRkaXRpb25hbCBsb2NraW5nIG5lZWRlZCBmb3IgbGluZV9z
ZXR0aW5ncyBhcyBpdCBpcw0KKwkgKiAgICAgICBvbmx5IHVzZWQgaW4gc2V0X3Rlcm1pb3MsIHdo
aWNoIGlzIHNlcmlhbGlzZWQgYWdhaW5zdCBpdHNlbGYuDQorCSAqLw0KKwlpZiAoIW9sZF90ZXJt
aW9zIHx8IG1lbWNtcChidWYsIHByaXYtPmxpbmVfc2V0dGluZ3MsIDcpKSB7DQorCQlpID0gdXNi
X2NvbnRyb2xfbXNnKHNlcmlhbC0+ZGV2LA0KKwkJCQkgICAgdXNiX3NuZGN0cmxwaXBlKHNlcmlh
bC0+ZGV2LCAwKSwNCisJCQkJICAgIFNFVF9MSU5FX1JFUVVFU1QsIFNFVF9MSU5FX1JFUVVFU1Rf
VFlQRSwNCisJCQkJICAgIDAsIDAsIGJ1ZiwgNywgMTAwKTsNCisNCisJCWRiZygiMHgyMToweDIw
OjA6MCAgJWQiLCBpKTsNCisNCisJCWlmIChpID09IDcpDQorCQkJbWVtY3B5KHByaXYtPmxpbmVf
c2V0dGluZ3MsIGJ1ZiwgNyk7DQorCX0NCiANCiAJLyogY2hhbmdlIGNvbnRyb2wgbGluZXMgaWYg
d2UgYXJlIHN3aXRjaGluZyB0byBvciBmcm9tIEIwICovDQogCXNwaW5fbG9ja19pcnFzYXZlKCZw
cml2LT5sb2NrLCBmbGFncyk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc3RvcmFnZS9LY29u
ZmlnIGIvZHJpdmVycy91c2Ivc3RvcmFnZS9LY29uZmlnDQppbmRleCAzMDNjMzRiLi4zNDYwZWU4
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc3RvcmFnZS9LY29uZmlnDQorKysgYi9kcml2ZXJz
L3VzYi9zdG9yYWdlL0tjb25maWcNCkBAIC0xOSw3ICsxOSw5IEBAIGNvbmZpZyBVU0JfU1RPUkFH
RQ0KIA0KIAkgIFRoaXMgb3B0aW9uIGRlcGVuZHMgb24gJ1NDU0knIHN1cHBvcnQgYmVpbmcgZW5h
YmxlZCwgYnV0IHlvdQ0KIAkgIHByb2JhYmx5IGFsc28gbmVlZCAnU0NTSSBkZXZpY2Ugc3VwcG9y
dDogU0NTSSBkaXNrIHN1cHBvcnQnDQotCSAgKEJMS19ERVZfU0QpIGZvciBtb3N0IFVTQiBzdG9y
YWdlIGRldmljZXMuDQorCSAgKEJMS19ERVZfU0QpIGZvciBtb3N0IFVTQiBzdG9yYWdlIGRldmlj
ZXMuICBTb21lIGRldmljZXMgYWxzbw0KKwkgIHdpbGwgcmVxdWlyZSAnUHJvYmUgYWxsIExVTnMg
b24gZWFjaCBTQ1NJIGRldmljZScNCisJICAoU0NTSV9NVUxUSV9MVU4pLg0KIA0KIAkgIFRvIGNv
bXBpbGUgdGhpcyBkcml2ZXIgYXMgYSBtb2R1bGUsIGNob29zZSBNIGhlcmU6IHRoZQ0KIAkgIG1v
ZHVsZSB3aWxsIGJlIGNhbGxlZCB1c2Itc3RvcmFnZS4NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Vz
Yi9zdG9yYWdlL3Njc2lnbHVlLmMgYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3Njc2lnbHVlLmMNCmlu
ZGV4IDEzYjhiY2QuLmViNjYwYmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zdG9yYWdlL3Nj
c2lnbHVlLmMNCisrKyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2Uvc2NzaWdsdWUuYw0KQEAgLTExNiw2
ICsxMTYsMTAgQEAgc3RhdGljIGludCBzbGF2ZV9hbGxvYyAoc3RydWN0IHNjc2lfZGV2aWNlICpz
ZGV2KQ0KIAlpZiAodXMtPnN1YmNsYXNzID09IFVTQl9TQ19VRkkpDQogCQlzZGV2LT5zZGV2X3Rh
cmdldC0+cGR0XzFmX2Zvcl9ub19sdW4gPSAxOw0KIA0KKwkvKiBUZWxsIHRoZSBTQ1NJIGxheWVy
IGlmIHdlIGtub3cgdGhlcmUgaXMgbW9yZSB0aGFuIG9uZSBMVU4gKi8NCisJaWYgKHVzLT5wcm90
b2NvbCA9PSBVU0JfUFJfQlVMSyAmJiB1cy0+bWF4X2x1biA+IDApDQorCQlzZGV2LT5zZGV2X2Jm
bGFncyB8PSBCTElTVF9GT1JDRUxVTjsNCisNCiAJcmV0dXJuIDA7DQogfQ0KIA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdW51c3VhbF9jeXByZXNzLmggYi9kcml2ZXJzL3VzYi9z
dG9yYWdlL3VudXN1YWxfY3lwcmVzcy5oDQppbmRleCA2NWE2YTc1Li44MmU4ZWQwIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy91c2Ivc3RvcmFnZS91bnVzdWFsX2N5cHJlc3MuaA0KKysrIGIvZHJpdmVy
cy91c2Ivc3RvcmFnZS91bnVzdWFsX2N5cHJlc3MuaA0KQEAgLTMxLDcgKzMxLDcgQEAgVU5VU1VB
TF9ERVYoICAweDA0YjQsIDB4NjgzMSwgMHgwMDAwLCAweDk5OTksDQogCQkiQ3lwcmVzcyBJU0Qt
MzAwTFAiLA0KIAkJVVNCX1NDX0NZUF9BVEFDQiwgVVNCX1BSX0RFVklDRSwgTlVMTCwgMCksDQog
DQotVU5VU1VBTF9ERVYoIDB4MTRjZCwgMHg2MTE2LCAweDAwMDAsIDB4MDIxOSwNCitVTlVTVUFM
X0RFViggMHgxNGNkLCAweDYxMTYsIDB4MDE2MCwgMHgwMTYwLA0KIAkJIlN1cGVyIFRvcCIsDQog
CQkiVVNCIDIuMCAgU0FUQSBCUklER0UiLA0KIAkJVVNCX1NDX0NZUF9BVEFDQiwgVVNCX1BSX0RF
VklDRSwgTlVMTCwgMCksDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc3RvcmFnZS91bnVzdWFs
X2RldnMuaCBiL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdW51c3VhbF9kZXZzLmgNCmluZGV4IDhhM2I1
MzEuLjA4NzExYmMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2
cy5oDQorKysgYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oDQpAQCAtMjI2LDYg
KzIyNiwxMyBAQCBVTlVTVUFMX0RFViggIDB4MDQyMSwgMHgwNDk1LCAweDAzNzAsIDB4MDM3MCwN
CiAJCVVTQl9TQ19ERVZJQ0UsIFVTQl9QUl9ERVZJQ0UsIE5VTEwsDQogCQlVU19GTF9NQVhfU0VD
VE9SU182NCApLA0KIA0KKy8qIFBhdGNoIHN1Ym1pdHRlZCBieSBNaWtoYWlsIFpvbG90YXJ5b3Yg
PGxlYm9uQGxlYm9uLm9yZy51YT4gKi8NCitVTlVTVUFMX0RFViggIDB4MDQyMSwgMHgwNmFhLCAw
eDExMTAsIDB4MTExMCwNCisJCSJOb2tpYSIsDQorCQkiNTAyIiwNCisJCVVTQl9TQ19ERVZJQ0Us
IFVTQl9QUl9ERVZJQ0UsIE5VTEwsDQorCQlVU19GTF9NQVhfU0VDVE9SU182NCApLA0KKw0KICNp
ZmRlZiBOT19TRERSMDkNCiBVTlVTVUFMX0RFViggIDB4MDQzNiwgMHgwMDA1LCAweDAxMDAsIDB4
MDEwMCwNCiAJCSJNaWNyb3RlY2giLA0KQEAgLTE0MzQsNiArMTQ0MSwxMyBAQCBVTlVTVUFMX0RF
ViggMHgwZjg4LCAweDA0MmUsIDB4MDEwMCwgMHgwMTAwLA0KIAkJVVNCX1NDX0RFVklDRSwgVVNC
X1BSX0RFVklDRSwgTlVMTCwNCiAJCVVTX0ZMX0ZJWF9DQVBBQ0lUWSApLA0KIA0KKy8qIFJlcG9y
dGVkIGJ5IE1vcml0eiBNb2VsbGVyLUhlcnJtYW5uIDxtb3JpdHota2VybmVsQG1vZWxsZXItaGVy
cm1hbm4uZGU+ICovDQorVU5VU1VBTF9ERVYoICAweDBmY2EsIDB4ODAwNCwgMHgwMjAxLCAweDAy
MDEsDQorCQkiUmVzZWFyY2ggSW4gTW90aW9uIiwNCisJCSJCbGFja0JlcnJ5IEJvbGQgOTAwMCIs
DQorCQlVU0JfU0NfREVWSUNFLCBVU0JfUFJfREVWSUNFLCBOVUxMLA0KKwkJVVNfRkxfTUFYX1NF
Q1RPUlNfNjQgKSwNCisNCiAvKiBSZXBvcnRlZCBieSBNaWNoYWVsIFN0YXR0bWFubiA8bWljaGFl
bEBzdGF0dG1hbm4uY29tPiAqLw0KIFVOVVNVQUxfREVWKCAgMHgwZmNlLCAweGQwMDgsIDB4MDAw
MCwgMHgwMDAwLA0KIAkJIlNvbnkgRXJpY3Nzb24iLA0KZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL2V4
dGVudC10cmVlLmMgYi9mcy9idHJmcy9leHRlbnQtdHJlZS5jDQppbmRleCA0OWVlZmRiLi5mNjM3
MTlhIDEwMDY0NA0KLS0tIGEvZnMvYnRyZnMvZXh0ZW50LXRyZWUuYw0KKysrIGIvZnMvYnRyZnMv
ZXh0ZW50LXRyZWUuYw0KQEAgLTY3MjUsNyArNjcyNSw3IEBAIG91dDoNCiAJICovDQogCWlmIChy
b290X2Ryb3BwZWQgPT0gZmFsc2UpDQogCQlidHJmc19hZGRfZGVhZF9yb290KHJvb3QpOw0KLQlp
ZiAoZXJyKQ0KKwlpZiAoZXJyICYmIGVyciAhPSAtRUFHQUlOKQ0KIAkJYnRyZnNfc3RkX2Vycm9y
KHJvb3QtPmZzX2luZm8sIGVycik7DQogCXJldHVybjsNCiB9DQpkaWZmIC0tZ2l0IGEvZnMvYnRy
ZnMvaW5vZGUuYyBiL2ZzL2J0cmZzL2lub2RlLmMNCmluZGV4IDEzNzI2MzQuLjYyMmQzMjIgMTAw
NjQ0DQotLS0gYS9mcy9idHJmcy9pbm9kZS5jDQorKysgYi9mcy9idHJmcy9pbm9kZS5jDQpAQCAt
NTYsNyArNTYsNyBAQA0KICNpbmNsdWRlICJpbm9kZS1tYXAuaCINCiANCiBzdHJ1Y3QgYnRyZnNf
aWdldF9hcmdzIHsNCi0JdTY0IGlubzsNCisJc3RydWN0IGJ0cmZzX2tleSAqbG9jYXRpb247DQog
CXN0cnVjdCBidHJmc19yb290ICpyb290Ow0KIH07DQogDQpAQCAtMzg0Nyw3ICszODQ3LDkgQEAg
YWdhaW46DQogc3RhdGljIGludCBidHJmc19pbml0X2xvY2tlZF9pbm9kZShzdHJ1Y3QgaW5vZGUg
Kmlub2RlLCB2b2lkICpwKQ0KIHsNCiAJc3RydWN0IGJ0cmZzX2lnZXRfYXJncyAqYXJncyA9IHA7
DQotCWlub2RlLT5pX2lubyA9IGFyZ3MtPmlubzsNCisJaW5vZGUtPmlfaW5vID0gYXJncy0+bG9j
YXRpb24tPm9iamVjdGlkOw0KKwltZW1jcHkoJkJUUkZTX0koaW5vZGUpLT5sb2NhdGlvbiwgYXJn
cy0+bG9jYXRpb24sDQorCSAgICAgICBzaXplb2YoKmFyZ3MtPmxvY2F0aW9uKSk7DQogCUJUUkZT
X0koaW5vZGUpLT5yb290ID0gYXJncy0+cm9vdDsNCiAJYnRyZnNfc2V0X2lub2RlX3NwYWNlX2lu
Zm8oYXJncy0+cm9vdCwgaW5vZGUpOw0KIAlyZXR1cm4gMDsNCkBAIC0zODU2LDIwICszODU4LDIw
IEBAIHN0YXRpYyBpbnQgYnRyZnNfaW5pdF9sb2NrZWRfaW5vZGUoc3RydWN0IGlub2RlICppbm9k
ZSwgdm9pZCAqcCkNCiBzdGF0aWMgaW50IGJ0cmZzX2ZpbmRfYWN0b3Ioc3RydWN0IGlub2RlICpp
bm9kZSwgdm9pZCAqb3BhcXVlKQ0KIHsNCiAJc3RydWN0IGJ0cmZzX2lnZXRfYXJncyAqYXJncyA9
IG9wYXF1ZTsNCi0JcmV0dXJuIGFyZ3MtPmlubyA9PSBidHJmc19pbm8oaW5vZGUpICYmDQorCXJl
dHVybiBhcmdzLT5sb2NhdGlvbi0+b2JqZWN0aWQgPT0gQlRSRlNfSShpbm9kZSktPmxvY2F0aW9u
Lm9iamVjdGlkICYmDQogCQlhcmdzLT5yb290ID09IEJUUkZTX0koaW5vZGUpLT5yb290Ow0KIH0N
CiANCiBzdGF0aWMgc3RydWN0IGlub2RlICpidHJmc19pZ2V0X2xvY2tlZChzdHJ1Y3Qgc3VwZXJf
YmxvY2sgKnMsDQotCQkJCSAgICAgICB1NjQgb2JqZWN0aWQsDQorCQkJCSAgICAgICBzdHJ1Y3Qg
YnRyZnNfa2V5ICpsb2NhdGlvbiwNCiAJCQkJICAgICAgIHN0cnVjdCBidHJmc19yb290ICpyb290
KQ0KIHsNCiAJc3RydWN0IGlub2RlICppbm9kZTsNCiAJc3RydWN0IGJ0cmZzX2lnZXRfYXJncyBh
cmdzOw0KLQlhcmdzLmlubyA9IG9iamVjdGlkOw0KKwlhcmdzLmxvY2F0aW9uID0gbG9jYXRpb247
DQogCWFyZ3Mucm9vdCA9IHJvb3Q7DQogDQotCWlub2RlID0gaWdldDVfbG9ja2VkKHMsIG9iamVj
dGlkLCBidHJmc19maW5kX2FjdG9yLA0KKwlpbm9kZSA9IGlnZXQ1X2xvY2tlZChzLCBsb2NhdGlv
bi0+b2JqZWN0aWQsIGJ0cmZzX2ZpbmRfYWN0b3IsDQogCQkJICAgICBidHJmc19pbml0X2xvY2tl
ZF9pbm9kZSwNCiAJCQkgICAgICh2b2lkICopJmFyZ3MpOw0KIAlyZXR1cm4gaW5vZGU7DQpAQCAt
Mzg4MywxMyArMzg4NSwxMSBAQCBzdHJ1Y3QgaW5vZGUgKmJ0cmZzX2lnZXQoc3RydWN0IHN1cGVy
X2Jsb2NrICpzLCBzdHJ1Y3QgYnRyZnNfa2V5ICpsb2NhdGlvbiwNCiB7DQogCXN0cnVjdCBpbm9k
ZSAqaW5vZGU7DQogDQotCWlub2RlID0gYnRyZnNfaWdldF9sb2NrZWQocywgbG9jYXRpb24tPm9i
amVjdGlkLCByb290KTsNCisJaW5vZGUgPSBidHJmc19pZ2V0X2xvY2tlZChzLCBsb2NhdGlvbiwg
cm9vdCk7DQogCWlmICghaW5vZGUpDQogCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsNCiANCiAJ
aWYgKGlub2RlLT5pX3N0YXRlICYgSV9ORVcpIHsNCi0JCUJUUkZTX0koaW5vZGUpLT5yb290ID0g
cm9vdDsNCi0JCW1lbWNweSgmQlRSRlNfSShpbm9kZSktPmxvY2F0aW9uLCBsb2NhdGlvbiwgc2l6
ZW9mKCpsb2NhdGlvbikpOw0KIAkJYnRyZnNfcmVhZF9sb2NrZWRfaW5vZGUoaW5vZGUpOw0KIAkJ
aWYgKCFpc19iYWRfaW5vZGUoaW5vZGUpKSB7DQogCQkJaW5vZGVfdHJlZV9hZGQoaW5vZGUpOw0K
ZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL2lvY3RsLmMgYi9mcy9idHJmcy9pb2N0bC5jDQppbmRleCA2
MThhZTZmLi43Y2JlMmY4IDEwMDY0NA0KLS0tIGEvZnMvYnRyZnMvaW9jdGwuYw0KKysrIGIvZnMv
YnRyZnMvaW9jdGwuYw0KQEAgLTEzMjcsMTIgKzEzMjcsMTcgQEAgc3RhdGljIG5vaW5saW5lIGlu
dCBidHJmc19pb2N0bF9zbmFwX2NyZWF0ZV90cmFuc2lkKHN0cnVjdCBmaWxlICpmaWxlLA0KIAkJ
CXByaW50ayhLRVJOX0lORk8gImJ0cmZzOiBTbmFwc2hvdCBzcmMgZnJvbSAiDQogCQkJICAgICAg
ICJhbm90aGVyIEZTXG4iKTsNCiAJCQlyZXQgPSAtRUlOVkFMOw0KLQkJCWZwdXQoc3JjX2ZpbGUp
Ow0KLQkJCWdvdG8gb3V0Ow0KKwkJfSBlbHNlIGlmICghaW5vZGVfb3duZXJfb3JfY2FwYWJsZShz
cmNfaW5vZGUpKSB7DQorCQkJLyoNCisJCQkgKiBTdWJ2b2x1bWUgY3JlYXRpb24gaXMgbm90IHJl
c3RyaWN0ZWQsIGJ1dCBzbmFwc2hvdHMNCisJCQkgKiBhcmUgbGltaXRlZCB0byBvd24gc3Vidm9s
dW1lcyBvbmx5DQorCQkJICovDQorCQkJcmV0ID0gLUVQRVJNOw0KKwkJfSBlbHNlIHsNCisJCQly
ZXQgPSBidHJmc19ta3N1YnZvbCgmZmlsZS0+Zl9wYXRoLCBuYW1lLCBuYW1lbGVuLA0KKwkJCQkJ
ICAgICBCVFJGU19JKHNyY19pbm9kZSktPnJvb3QsDQorCQkJCQkgICAgIHRyYW5zaWQsIHJlYWRv
bmx5KTsNCiAJCX0NCi0JCXJldCA9IGJ0cmZzX21rc3Vidm9sKCZmaWxlLT5mX3BhdGgsIG5hbWUs
IG5hbWVsZW4sDQotCQkJCSAgICAgQlRSRlNfSShzcmNfaW5vZGUpLT5yb290LA0KLQkJCQkgICAg
IHRyYW5zaWQsIHJlYWRvbmx5KTsNCiAJCWZwdXQoc3JjX2ZpbGUpOw0KIAl9DQogb3V0Og0KZGlm
ZiAtLWdpdCBhL2ZzL2J1ZmZlci5jIGIvZnMvYnVmZmVyLmMNCmluZGV4IDE5YTRmMGIuLjVmNGJk
ZTIgMTAwNjQ0DQotLS0gYS9mcy9idWZmZXIuYw0KKysrIGIvZnMvYnVmZmVyLmMNCkBAIC02NjMs
MTQgKzY2MywxNiBAQCBFWFBPUlRfU1lNQk9MKG1hcmtfYnVmZmVyX2RpcnR5X2lub2RlKTsNCiBz
dGF0aWMgdm9pZCBfX3NldF9wYWdlX2RpcnR5KHN0cnVjdCBwYWdlICpwYWdlLA0KIAkJc3RydWN0
IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsIGludCB3YXJuKQ0KIHsNCi0Jc3Bpbl9sb2NrX2lycSgm
bWFwcGluZy0+dHJlZV9sb2NrKTsNCisJdW5zaWduZWQgbG9uZyBmbGFnczsNCisNCisJc3Bpbl9s
b2NrX2lycXNhdmUoJm1hcHBpbmctPnRyZWVfbG9jaywgZmxhZ3MpOw0KIAlpZiAocGFnZS0+bWFw
cGluZykgewkvKiBSYWNlIHdpdGggdHJ1bmNhdGU/ICovDQogCQlXQVJOX09OX09OQ0Uod2FybiAm
JiAhUGFnZVVwdG9kYXRlKHBhZ2UpKTsNCiAJCWFjY291bnRfcGFnZV9kaXJ0aWVkKHBhZ2UsIG1h
cHBpbmcpOw0KIAkJcmFkaXhfdHJlZV90YWdfc2V0KCZtYXBwaW5nLT5wYWdlX3RyZWUsDQogCQkJ
CXBhZ2VfaW5kZXgocGFnZSksIFBBR0VDQUNIRV9UQUdfRElSVFkpOw0KIAl9DQotCXNwaW5fdW5s
b2NrX2lycSgmbWFwcGluZy0+dHJlZV9sb2NrKTsNCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
bWFwcGluZy0+dHJlZV9sb2NrLCBmbGFncyk7DQogCV9fbWFya19pbm9kZV9kaXJ0eShtYXBwaW5n
LT5ob3N0LCBJX0RJUlRZX1BBR0VTKTsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25u
ZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYw0KaW5kZXggNTZjMTUyZC4uNDlkNmUyMSAxMDA2NDQN
Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jDQorKysgYi9mcy9jaWZzL2Nvbm5lY3QuYw0KQEAgLTEx
MTMsNyArMTExMyw4IEBAIGNpZnNfcGFyc2VfbW91bnRfb3B0aW9ucyhjb25zdCBjaGFyICptb3Vu
dGRhdGEsIGNvbnN0IGNoYXIgKmRldm5hbWUsDQogCQkJCWNFUlJPUigxLCAiS3JiNSBjaWZzIHBy
aXZhY3kgbm90IHN1cHBvcnRlZCIpOw0KIAkJCQlnb3RvIGNpZnNfcGFyc2VfbW91bnRfZXJyOw0K
IAkJCX0gZWxzZSBpZiAoc3RybmljbXAodmFsdWUsICJrcmI1IiwgNCkgPT0gMCkgew0KLQkJCQl2
b2wtPnNlY0ZsZyB8PSBDSUZTU0VDX01BWV9LUkI1Ow0KKwkJCQl2b2wtPnNlY0ZsZyB8PSBDSUZT
U0VDX01BWV9LUkI1IHwgDQorCQkJCQlDSUZTU0VDX01BWV9TSUdOOw0KIAkJCX0gZWxzZSBpZiAo
c3RybmljbXAodmFsdWUsICJudGxtc3NwaSIsIDgpID09IDApIHsNCiAJCQkJdm9sLT5zZWNGbGcg
fD0gQ0lGU1NFQ19NQVlfTlRMTVNTUCB8DQogCQkJCQlDSUZTU0VDX01VU1RfU0lHTjsNCmRpZmYg
LS1naXQgYS9mcy9leG9mcy9vcmUuYyBiL2ZzL2V4b2ZzL29yZS5jDQppbmRleCAyNmJiNTEyLi5k
ZjRhMTBmIDEwMDY0NA0KLS0tIGEvZnMvZXhvZnMvb3JlLmMNCisrKyBiL2ZzL2V4b2ZzL29yZS5j
DQpAQCAtMTAzLDcgKzEwMyw3IEBAIGludCBvcmVfdmVyaWZ5X2xheW91dCh1bnNpZ25lZCB0b3Rh
bF9jb21wcywgc3RydWN0IG9yZV9sYXlvdXQgKmxheW91dCkNCiANCiAJbGF5b3V0LT5tYXhfaW9f
bGVuZ3RoID0NCiAJCShCSU9fTUFYX1BBR0VTX0tNQUxMT0MgKiBQQUdFX1NJWkUgLSBsYXlvdXQt
PnN0cmlwZV91bml0KSAqDQotCQkJCQkJCWxheW91dC0+Z3JvdXBfd2lkdGg7DQorCQkJCQkobGF5
b3V0LT5ncm91cF93aWR0aCAtIGxheW91dC0+cGFyaXR5KTsNCiAJaWYgKGxheW91dC0+cGFyaXR5
KSB7DQogCQl1bnNpZ25lZCBzdHJpcGVfbGVuZ3RoID0NCiAJCQkJKGxheW91dC0+Z3JvdXBfd2lk
dGggLSBsYXlvdXQtPnBhcml0eSkgKg0KQEAgLTI4Niw3ICsyODYsOCBAQCBpbnQgIG9yZV9nZXRf
cndfc3RhdGUoc3RydWN0IG9yZV9sYXlvdXQgKmxheW91dCwgc3RydWN0IG9yZV9jb21wb25lbnRz
ICpvYywNCiAJaWYgKGxlbmd0aCkgew0KIAkJb3JlX2NhbGNfc3RyaXBlX2luZm8obGF5b3V0LCBv
ZmZzZXQsIGxlbmd0aCwgJmlvcy0+c2kpOw0KIAkJaW9zLT5sZW5ndGggPSBpb3MtPnNpLmxlbmd0
aDsNCi0JCWlvcy0+bnJfcGFnZXMgPSAoaW9zLT5sZW5ndGggKyBQQUdFX1NJWkUgLSAxKSAvIFBB
R0VfU0laRTsNCisJCWlvcy0+bnJfcGFnZXMgPSAoKGlvcy0+b2Zmc2V0ICYgKFBBR0VfU0laRSAt
IDEpKSArDQorCQkJCSBpb3MtPmxlbmd0aCArIFBBR0VfU0laRSAtIDEpIC8gUEFHRV9TSVpFOw0K
IAkJaWYgKGxheW91dC0+cGFyaXR5KQ0KIAkJCV9vcmVfcG9zdF9hbGxvY19yYWlkX3N0dWZmKGlv
cyk7DQogCX0NCkBAIC01MzYsNiArNTM3LDcgQEAgdm9pZCBvcmVfY2FsY19zdHJpcGVfaW5mbyhz
dHJ1Y3Qgb3JlX2xheW91dCAqbGF5b3V0LCB1NjQgZmlsZV9vZmZzZXQsDQogCXU2NAlIID0gTG1v
ZFMgLSBHICogVDsNCiANCiAJdTMyCU4gPSBkaXZfdTY0KEgsIFUpOw0KKwl1MzIJTmxhc3Q7DQog
DQogCS8qICJIIC0gKE4gKiBVKSIgaXMganVzdCAiSCAlIFUiIHNvIGl0J3MgYm91bmQgdG8gdTMy
ICovDQogCXUzMglDID0gKHUzMikoSCAtIChOICogVSkpIC8gc3RyaXBlX3VuaXQgKyBHICogZ3Jv
dXBfd2lkdGg7DQpAQCAtNTY4LDYgKzU3MCwxMCBAQCB2b2lkIG9yZV9jYWxjX3N0cmlwZV9pbmZv
KHN0cnVjdCBvcmVfbGF5b3V0ICpsYXlvdXQsIHU2NCBmaWxlX29mZnNldCwNCiAJc2ktPmxlbmd0
aCA9IFQgLSBIOw0KIAlpZiAoc2ktPmxlbmd0aCA+IGxlbmd0aCkNCiAJCXNpLT5sZW5ndGggPSBs
ZW5ndGg7DQorDQorCU5sYXN0ID0gZGl2X3U2NChIICsgc2ktPmxlbmd0aCArIFUgLSAxLCBVKTsN
CisJc2ktPm1heGRldlVuaXRzID0gTmxhc3QgLSBOOw0KKw0KIAlzaS0+TSA9IE07DQogfQ0KIEVY
UE9SVF9TWU1CT0wob3JlX2NhbGNfc3RyaXBlX2luZm8pOw0KQEAgLTU4MywxMyArNTg5LDE2IEBA
IGludCBfb3JlX2FkZF9zdHJpcGVfdW5pdChzdHJ1Y3Qgb3JlX2lvX3N0YXRlICppb3MsICB1bnNp
Z25lZCAqY3VyX3BnLA0KIAlpbnQgcmV0Ow0KIA0KIAlpZiAocGVyX2Rldi0+YmlvID09IE5VTEwp
IHsNCi0JCXVuc2lnbmVkIHBhZ2VzX2luX3N0cmlwZSA9IGlvcy0+bGF5b3V0LT5ncm91cF93aWR0
aCAqDQotCQkJCQkoaW9zLT5sYXlvdXQtPnN0cmlwZV91bml0IC8gUEFHRV9TSVpFKTsNCi0JCXVu
c2lnbmVkIG5yX3BhZ2VzID0gaW9zLT5ucl9wYWdlcyAqIGlvcy0+bGF5b3V0LT5ncm91cF93aWR0
aCAvDQotCQkJCQkoaW9zLT5sYXlvdXQtPmdyb3VwX3dpZHRoIC0NCi0JCQkJCSBpb3MtPmxheW91
dC0+cGFyaXR5KTsNCi0JCXVuc2lnbmVkIGJpb19zaXplID0gKG5yX3BhZ2VzICsgcGFnZXNfaW5f
c3RyaXBlKSAvDQotCQkJCQlpb3MtPmxheW91dC0+Z3JvdXBfd2lkdGg7DQorCQl1bnNpZ25lZCBi
aW9fc2l6ZTsNCisNCisJCWlmICghaW9zLT5yZWFkaW5nKSB7DQorCQkJYmlvX3NpemUgPSBpb3Mt
PnNpLm1heGRldlVuaXRzOw0KKwkJfSBlbHNlIHsNCisJCQliaW9fc2l6ZSA9IChpb3MtPnNpLm1h
eGRldlVuaXRzICsgMSkgKg0KKwkJCSAgICAgKGlvcy0+bGF5b3V0LT5ncm91cF93aWR0aCAtIGlv
cy0+bGF5b3V0LT5wYXJpdHkpIC8NCisJCQkgICAgIGlvcy0+bGF5b3V0LT5ncm91cF93aWR0aDsN
CisJCX0NCisJCWJpb19zaXplICo9IChpb3MtPmxheW91dC0+c3RyaXBlX3VuaXQgLyBQQUdFX1NJ
WkUpOw0KIA0KIAkJcGVyX2Rldi0+YmlvID0gYmlvX2ttYWxsb2MoR0ZQX0tFUk5FTCwgYmlvX3Np
emUpOw0KIAkJaWYgKHVubGlrZWx5KCFwZXJfZGV2LT5iaW8pKSB7DQpAQCAtNjA5LDggKzYxOCwx
MiBAQCBpbnQgX29yZV9hZGRfc3RyaXBlX3VuaXQoc3RydWN0IG9yZV9pb19zdGF0ZSAqaW9zLCAg
dW5zaWduZWQgKmN1cl9wZywNCiAJCWFkZGVkX2xlbiA9IGJpb19hZGRfcGNfcGFnZShxLCBwZXJf
ZGV2LT5iaW8sIHBhZ2VzW3BnXSwNCiAJCQkJCSAgICBwZ2xlbiwgcGdiYXNlKTsNCiAJCWlmICh1
bmxpa2VseShwZ2xlbiAhPSBhZGRlZF9sZW4pKSB7DQotCQkJT1JFX0RCR01TRygiRmFpbGVkIGJp
b19hZGRfcGNfcGFnZSBiaV92Y250PSV1XG4iLA0KLQkJCQkgICBwZXJfZGV2LT5iaW8tPmJpX3Zj
bnQpOw0KKwkJCS8qIElmIGJpX3ZjbnQgPT0gYmlfbWF4IHRoZW4gdGhpcyBpcyBhIFNXIEJVRyAq
Lw0KKwkJCU9SRV9EQkdNU0coIkZhaWxlZCBiaW9fYWRkX3BjX3BhZ2UgYmlfdmNudD0weCV4ICIN
CisJCQkJICAgImJpX21heD0weCV4IEJJT19NQVg9MHgleCBjdXJfbGVuPTB4JXhcbiIsDQorCQkJ
CSAgIHBlcl9kZXYtPmJpby0+YmlfdmNudCwNCisJCQkJICAgcGVyX2Rldi0+YmlvLT5iaV9tYXhf
dmVjcywNCisJCQkJICAgQklPX01BWF9QQUdFU19LTUFMTE9DLCBjdXJfbGVuKTsNCiAJCQlyZXQg
PSAtRU5PTUVNOw0KIAkJCWdvdG8gb3V0Ow0KIAkJfQ0KQEAgLTEwOTksNyArMTExMiw3IEBAIGlu
dCBvcmVfdHJ1bmNhdGUoc3RydWN0IG9yZV9sYXlvdXQgKmxheW91dCwgc3RydWN0IG9yZV9jb21w
b25lbnRzICpvYywNCiAJCXNpemVfYXR0ci0+YXR0ciA9IGdfYXR0cl9sb2dpY2FsX2xlbmd0aDsN
CiAJCXNpemVfYXR0ci0+YXR0ci52YWxfcHRyID0gJnNpemVfYXR0ci0+bmV3c2l6ZTsNCiANCi0J
CU9SRV9EQkdNU0coInRydW5jKDB4JWxseCkgb2JqX29mZnNldD0weCVsbHggZGV2PSVkXG4iLA0K
KwkJT1JFX0RCR01TRzIoInRydW5jKDB4JWxseCkgb2JqX29mZnNldD0weCVsbHggZGV2PSVkXG4i
LA0KIAkJCSAgICAgX0xMVShvYy0+Y29tcHMtPm9iai5pZCksIF9MTFUob2JqX3NpemUpLCBpKTsN
CiAJCXJldCA9IF90cnVuY2F0ZV9taXJyb3JzKGlvcywgaSAqIGlvcy0+bGF5b3V0LT5taXJyb3Jz
X3AxLA0KIAkJCQkJJnNpemVfYXR0ci0+YXR0cik7DQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9leHQ0
LmggYi9mcy9leHQ0L2V4dDQuaA0KaW5kZXggNjhiMTYwMi4uNDBmNGQwNiAxMDA2NDQNCi0tLSBh
L2ZzL2V4dDQvZXh0NC5oDQorKysgYi9mcy9leHQ0L2V4dDQuaA0KQEAgLTc0NSw2ICs3NDUsOCBA
QCBkbyB7CQkJCQkJCQkJICAgICAgIFwNCiAJaWYgKEVYVDRfRklUU19JTl9JTk9ERShyYXdfaW5v
ZGUsIGVpbm9kZSwgeHRpbWUpKQkJICAgICAgIFwNCiAJCShlaW5vZGUpLT54dGltZS50dl9zZWMg
PSAJCQkJICAgICAgIFwNCiAJCQkoc2lnbmVkKWxlMzJfdG9fY3B1KChyYXdfaW5vZGUpLT54dGlt
ZSk7CSAgICAgICBcDQorCWVsc2UJCQkJCQkJCSAgICAgICBcDQorCQkoZWlub2RlKS0+eHRpbWUu
dHZfc2VjID0gMDsJCQkJICAgICAgIFwNCiAJaWYgKEVYVDRfRklUU19JTl9JTk9ERShyYXdfaW5v
ZGUsIGVpbm9kZSwgeHRpbWUgIyMgX2V4dHJhKSkJICAgICAgIFwNCiAJCWV4dDRfZGVjb2RlX2V4
dHJhX3RpbWUoJihlaW5vZGUpLT54dGltZSwJCSAgICAgICBcDQogCQkJCSAgICAgICByYXdfaW5v
ZGUtPnh0aW1lICMjIF9leHRyYSk7CSAgICAgICBcDQpkaWZmIC0tZ2l0IGEvZnMvZmlsZS5jIGIv
ZnMvZmlsZS5jDQppbmRleCA0YzY5OTJkLi4zMGJmYzk5IDEwMDY0NA0KLS0tIGEvZnMvZmlsZS5j
DQorKysgYi9mcy9maWxlLmMNCkBAIC00Nyw3ICs0Nyw3IEBAIHN0YXRpYyB2b2lkICphbGxvY19m
ZG1lbSh1bnNpZ25lZCBpbnQgc2l6ZSkNCiAJICogdm1hbGxvYygpIGlmIHRoZSBhbGxvY2F0aW9u
IHNpemUgd2lsbCBiZSBjb25zaWRlcmVkICJsYXJnZSIgYnkgdGhlIFZNLg0KIAkgKi8NCiAJaWYg
KHNpemUgPD0gKFBBR0VfU0laRSA8PCBQQUdFX0FMTE9DX0NPU1RMWV9PUkRFUikpIHsNCi0JCXZv
aWQgKmRhdGEgPSBrbWFsbG9jKHNpemUsIEdGUF9LRVJORUx8X19HRlBfTk9XQVJOKTsNCisJCXZv
aWQgKmRhdGEgPSBrbWFsbG9jKHNpemUsIEdGUF9LRVJORUx8X19HRlBfTk9XQVJOfF9fR0ZQX05P
UkVUUlkpOw0KIAkJaWYgKGRhdGEgIT0gTlVMTCkNCiAJCQlyZXR1cm4gZGF0YTsNCiAJfQ0KZGlm
ZiAtLWdpdCBhL2ZzL2Z1c2UvZGV2LmMgYi9mcy9mdXNlL2Rldi5jDQppbmRleCA1YzAyOWZiLi5j
ZjAwOThkIDEwMDY0NA0KLS0tIGEvZnMvZnVzZS9kZXYuYw0KKysrIGIvZnMvZnVzZS9kZXYuYw0K
QEAgLTExOTksMjIgKzExOTksNiBAQCBzdGF0aWMgc3NpemVfdCBmdXNlX2Rldl9yZWFkKHN0cnVj
dCBraW9jYiAqaW9jYiwgY29uc3Qgc3RydWN0IGlvdmVjICppb3YsDQogCXJldHVybiBmdXNlX2Rl
dl9kb19yZWFkKGZjLCBmaWxlLCAmY3MsIGlvdl9sZW5ndGgoaW92LCBucl9zZWdzKSk7DQogfQ0K
IA0KLXN0YXRpYyBpbnQgZnVzZV9kZXZfcGlwZV9idWZfc3RlYWwoc3RydWN0IHBpcGVfaW5vZGVf
aW5mbyAqcGlwZSwNCi0JCQkJICAgc3RydWN0IHBpcGVfYnVmZmVyICpidWYpDQotew0KLQlyZXR1
cm4gMTsNCi19DQotDQotc3RhdGljIGNvbnN0IHN0cnVjdCBwaXBlX2J1Zl9vcGVyYXRpb25zIGZ1
c2VfZGV2X3BpcGVfYnVmX29wcyA9IHsNCi0JLmNhbl9tZXJnZSA9IDAsDQotCS5tYXAgPSBnZW5l
cmljX3BpcGVfYnVmX21hcCwNCi0JLnVubWFwID0gZ2VuZXJpY19waXBlX2J1Zl91bm1hcCwNCi0J
LmNvbmZpcm0gPSBnZW5lcmljX3BpcGVfYnVmX2NvbmZpcm0sDQotCS5yZWxlYXNlID0gZ2VuZXJp
Y19waXBlX2J1Zl9yZWxlYXNlLA0KLQkuc3RlYWwgPSBmdXNlX2Rldl9waXBlX2J1Zl9zdGVhbCwN
Ci0JLmdldCA9IGdlbmVyaWNfcGlwZV9idWZfZ2V0LA0KLX07DQotDQogc3RhdGljIHNzaXplX3Qg
ZnVzZV9kZXZfc3BsaWNlX3JlYWQoc3RydWN0IGZpbGUgKmluLCBsb2ZmX3QgKnBwb3MsDQogCQkJ
CSAgICBzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvICpwaXBlLA0KIAkJCQkgICAgc2l6ZV90IGxlbiwg
dW5zaWduZWQgaW50IGZsYWdzKQ0KQEAgLTEyNjEsNyArMTI0NSwxMSBAQCBzdGF0aWMgc3NpemVf
dCBmdXNlX2Rldl9zcGxpY2VfcmVhZChzdHJ1Y3QgZmlsZSAqaW4sIGxvZmZfdCAqcHBvcywNCiAJ
CWJ1Zi0+cGFnZSA9IGJ1ZnNbcGFnZV9ucl0ucGFnZTsNCiAJCWJ1Zi0+b2Zmc2V0ID0gYnVmc1tw
YWdlX25yXS5vZmZzZXQ7DQogCQlidWYtPmxlbiA9IGJ1ZnNbcGFnZV9ucl0ubGVuOw0KLQkJYnVm
LT5vcHMgPSAmZnVzZV9kZXZfcGlwZV9idWZfb3BzOw0KKwkJLyoNCisJCSAqIE5lZWQgdG8gYmUg
Y2FyZWZ1bCBhYm91dCB0aGlzLiAgSGF2aW5nIGJ1Zi0+b3BzIGluIG1vZHVsZQ0KKwkJICogY29k
ZSBjYW4gT29wcyBpZiB0aGUgYnVmZmVyIHBlcnNpc3RzIGFmdGVyIG1vZHVsZSB1bmxvYWQuDQor
CQkgKi8NCisJCWJ1Zi0+b3BzID0gJm5vc3RlYWxfcGlwZV9idWZfb3BzOw0KIA0KIAkJcGlwZS0+
bnJidWZzKys7DQogCQlwYWdlX25yKys7DQpkaWZmIC0tZ2l0IGEvZnMvaHBmcy9hbGxvYy5jIGIv
ZnMvaHBmcy9hbGxvYy5jDQppbmRleCA3YTVlYjJjLi5lMGQ1N2MwIDEwMDY0NA0KLS0tIGEvZnMv
aHBmcy9hbGxvYy5jDQorKysgYi9mcy9ocGZzL2FsbG9jLmMNCkBAIC04LDYgKzgsNTggQEANCiAN
CiAjaW5jbHVkZSAiaHBmc19mbi5oIg0KIA0KK3N0YXRpYyB2b2lkIGhwZnNfY2xhaW1fYWxsb2Mo
c3RydWN0IHN1cGVyX2Jsb2NrICpzLCBzZWNubyBzZWMpDQorew0KKwlzdHJ1Y3QgaHBmc19zYl9p
bmZvICpzYmkgPSBocGZzX3NiKHMpOw0KKwlpZiAoc2JpLT5zYl9uX2ZyZWUgIT0gKHVuc2lnbmVk
KS0xKSB7DQorCQlpZiAodW5saWtlbHkoIXNiaS0+c2Jfbl9mcmVlKSkgew0KKwkJCWhwZnNfZXJy
b3IocywgImZyZWUgY291bnQgdW5kZXJmbG93LCBhbGxvY2F0aW5nIHNlY3RvciAlMDh4Iiwgc2Vj
KTsNCisJCQlzYmktPnNiX25fZnJlZSA9IC0xOw0KKwkJCXJldHVybjsNCisJCX0NCisJCXNiaS0+
c2Jfbl9mcmVlLS07DQorCX0NCit9DQorDQorc3RhdGljIHZvaWQgaHBmc19jbGFpbV9mcmVlKHN0
cnVjdCBzdXBlcl9ibG9jayAqcywgc2Vjbm8gc2VjKQ0KK3sNCisJc3RydWN0IGhwZnNfc2JfaW5m
byAqc2JpID0gaHBmc19zYihzKTsNCisJaWYgKHNiaS0+c2Jfbl9mcmVlICE9ICh1bnNpZ25lZCkt
MSkgew0KKwkJaWYgKHVubGlrZWx5KHNiaS0+c2Jfbl9mcmVlID49IHNiaS0+c2JfZnNfc2l6ZSkp
IHsNCisJCQlocGZzX2Vycm9yKHMsICJmcmVlIGNvdW50IG92ZXJmbG93LCBmcmVlaW5nIHNlY3Rv
ciAlMDh4Iiwgc2VjKTsNCisJCQlzYmktPnNiX25fZnJlZSA9IC0xOw0KKwkJCXJldHVybjsNCisJ
CX0NCisJCXNiaS0+c2Jfbl9mcmVlKys7DQorCX0NCit9DQorDQorc3RhdGljIHZvaWQgaHBmc19j
bGFpbV9kaXJiYW5kX2FsbG9jKHN0cnVjdCBzdXBlcl9ibG9jayAqcywgc2Vjbm8gc2VjKQ0KK3sN
CisJc3RydWN0IGhwZnNfc2JfaW5mbyAqc2JpID0gaHBmc19zYihzKTsNCisJaWYgKHNiaS0+c2Jf
bl9mcmVlX2Rub2RlcyAhPSAodW5zaWduZWQpLTEpIHsNCisJCWlmICh1bmxpa2VseSghc2JpLT5z
Yl9uX2ZyZWVfZG5vZGVzKSkgew0KKwkJCWhwZnNfZXJyb3IocywgImRpcmJhbmQgZnJlZSBjb3Vu
dCB1bmRlcmZsb3csIGFsbG9jYXRpbmcgc2VjdG9yICUwOHgiLCBzZWMpOw0KKwkJCXNiaS0+c2Jf
bl9mcmVlX2Rub2RlcyA9IC0xOw0KKwkJCXJldHVybjsNCisJCX0NCisJCXNiaS0+c2Jfbl9mcmVl
X2Rub2Rlcy0tOw0KKwl9DQorfQ0KKw0KK3N0YXRpYyB2b2lkIGhwZnNfY2xhaW1fZGlyYmFuZF9m
cmVlKHN0cnVjdCBzdXBlcl9ibG9jayAqcywgc2Vjbm8gc2VjKQ0KK3sNCisJc3RydWN0IGhwZnNf
c2JfaW5mbyAqc2JpID0gaHBmc19zYihzKTsNCisJaWYgKHNiaS0+c2Jfbl9mcmVlX2Rub2RlcyAh
PSAodW5zaWduZWQpLTEpIHsNCisJCWlmICh1bmxpa2VseShzYmktPnNiX25fZnJlZV9kbm9kZXMg
Pj0gc2JpLT5zYl9kaXJiYW5kX3NpemUgLyA0KSkgew0KKwkJCWhwZnNfZXJyb3IocywgImRpcmJh
bmQgZnJlZSBjb3VudCBvdmVyZmxvdywgZnJlZWluZyBzZWN0b3IgJTA4eCIsIHNlYyk7DQorCQkJ
c2JpLT5zYl9uX2ZyZWVfZG5vZGVzID0gLTE7DQorCQkJcmV0dXJuOw0KKwkJfQ0KKwkJc2JpLT5z
Yl9uX2ZyZWVfZG5vZGVzKys7DQorCX0NCit9DQorDQogLyoNCiAgKiBDaGVjayBpZiBhIHNlY3Rv
ciBpcyBhbGxvY2F0ZWQgaW4gYml0bWFwDQogICogVGhpcyBpcyByZWFsbHkgc2xvdy4gVHVybmVk
IG9uIG9ubHkgaWYgY2hrPT0yDQpAQCAtMjAzLDkgKzI1NSwxNSBAQCBzZWNubyBocGZzX2FsbG9j
X3NlY3RvcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnMsIHNlY25vIG5lYXIsIHVuc2lnbmVkIG4sIGlu
dCBmb3J3YQ0KIAl9DQogCXNlYyA9IDA7DQogCXJldDoNCisJaWYgKHNlYykgew0KKwkJaSA9IDA7
DQorCQlkbw0KKwkJCWhwZnNfY2xhaW1fYWxsb2Mocywgc2VjICsgaSk7DQorCQl3aGlsZSAodW5s
aWtlbHkoKytpIDwgbikpOw0KKwl9DQogCWlmIChzZWMgJiYgZl9wKSB7DQogCQlmb3IgKGkgPSAw
OyBpIDwgZm9yd2FyZDsgaSsrKSB7DQotCQkJaWYgKCFocGZzX2FsbG9jX2lmX3Bvc3NpYmxlKHMs
IHNlYyArIGkgKyAxKSkgew0KKwkJCWlmICghaHBmc19hbGxvY19pZl9wb3NzaWJsZShzLCBzZWMg
KyBuICsgaSkpIHsNCiAJCQkJaHBmc19lcnJvcihzLCAiUHJlYWxsb2MgZG9lc24ndCB3b3JrISBX
YW50ZWQgJWQsIGFsbG9jYXRlZCBhdCAlMDh4LCBjYW4ndCBhbGxvY2F0ZSAlZCIsIGZvcndhcmQs
IHNlYywgaSk7DQogCQkJCXNlYyA9IDA7DQogCQkJCWJyZWFrOw0KQEAgLTIyOCw2ICsyODYsNyBA
QCBzdGF0aWMgc2Vjbm8gYWxsb2NfaW5fZGlyYmFuZChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnMsIHNl
Y25vIG5lYXIpDQogCW5yID4+PSAyOw0KIAlzZWMgPSBhbGxvY19pbl9ibXAocywgKH4weDNmZmYp
IHwgbnIsIDEsIDApOw0KIAlpZiAoIXNlYykgcmV0dXJuIDA7DQorCWhwZnNfY2xhaW1fZGlyYmFu
ZF9hbGxvYyhzLCBzZWMpOw0KIAlyZXR1cm4gKChzZWMgJiAweDNmZmYpIDw8IDIpICsgc2JpLT5z
Yl9kaXJiYW5kX3N0YXJ0Ow0KIH0NCiANCkBAIC0yNDIsNiArMzAxLDcgQEAgaW50IGhwZnNfYWxs
b2NfaWZfcG9zc2libGUoc3RydWN0IHN1cGVyX2Jsb2NrICpzLCBzZWNubyBzZWMpDQogCQlibXBb
KHNlYyAmIDB4M2ZmZikgPj4gNV0gJj0gY3B1X3RvX2xlMzIofigxIDw8IChzZWMgJiAweDFmKSkp
Ow0KIAkJaHBmc19tYXJrXzRidWZmZXJzX2RpcnR5KCZxYmgpOw0KIAkJaHBmc19icmVsc2U0KCZx
YmgpOw0KKwkJaHBmc19jbGFpbV9hbGxvYyhzLCBzZWMpOw0KIAkJcmV0dXJuIDE7DQogCX0NCiAJ
aHBmc19icmVsc2U0KCZxYmgpOw0KQEAgLTI3NSw2ICszMzUsNyBAQCB2b2lkIGhwZnNfZnJlZV9z
ZWN0b3JzKHN0cnVjdCBzdXBlcl9ibG9jayAqcywgc2Vjbm8gc2VjLCB1bnNpZ25lZCBuKQ0KIAkJ
cmV0dXJuOw0KIAl9DQogCWJtcFsoc2VjICYgMHgzZmZmKSA+PiA1XSB8PSBjcHVfdG9fbGUzMigx
IDw8IChzZWMgJiAweDFmKSk7DQorCWhwZnNfY2xhaW1fZnJlZShzLCBzZWMpOw0KIAlpZiAoIS0t
bikgew0KIAkJaHBmc19tYXJrXzRidWZmZXJzX2RpcnR5KCZxYmgpOw0KIAkJaHBmc19icmVsc2U0
KCZxYmgpOw0KQEAgLTM1OSw2ICs0MjAsNyBAQCB2b2lkIGhwZnNfZnJlZV9kbm9kZShzdHJ1Y3Qg
c3VwZXJfYmxvY2sgKnMsIGRub2RlX3NlY25vIGRubykNCiAJCWJtcFtzc2VjID4+IDVdIHw9IGNw
dV90b19sZTMyKDEgPDwgKHNzZWMgJiAweDFmKSk7DQogCQlocGZzX21hcmtfNGJ1ZmZlcnNfZGly
dHkoJnFiaCk7DQogCQlocGZzX2JyZWxzZTQoJnFiaCk7DQorCQlocGZzX2NsYWltX2RpcmJhbmRf
ZnJlZShzLCBkbm8pOw0KIAl9DQogfQ0KIA0KQEAgLTM2Niw3ICs0MjgsNyBAQCBzdHJ1Y3QgZG5v
ZGUgKmhwZnNfYWxsb2NfZG5vZGUoc3RydWN0IHN1cGVyX2Jsb2NrICpzLCBzZWNubyBuZWFyLA0K
IAkJCSBkbm9kZV9zZWNubyAqZG5vLCBzdHJ1Y3QgcXVhZF9idWZmZXJfaGVhZCAqcWJoKQ0KIHsN
CiAJc3RydWN0IGRub2RlICpkOw0KLQlpZiAoaHBmc19jb3VudF9vbmVfYml0bWFwKHMsIGhwZnNf
c2IocyktPnNiX2RtYXApID4gRlJFRV9ETk9ERVNfQUREKSB7DQorCWlmIChocGZzX2dldF9mcmVl
X2Rub2RlcyhzKSA+IEZSRUVfRE5PREVTX0FERCkgew0KIAkJaWYgKCEoKmRubyA9IGFsbG9jX2lu
X2RpcmJhbmQocywgbmVhcikpKQ0KIAkJCWlmICghKCpkbm8gPSBocGZzX2FsbG9jX3NlY3Rvcihz
LCBuZWFyLCA0LCAwKSkpIHJldHVybiBOVUxMOw0KIAl9IGVsc2Ugew0KZGlmZiAtLWdpdCBhL2Zz
L2hwZnMvZGlyLmMgYi9mcy9ocGZzL2Rpci5jDQppbmRleCAyZmEwMDg5Li40NjU0OWM3IDEwMDY0
NA0KLS0tIGEvZnMvaHBmcy9kaXIuYw0KKysrIGIvZnMvaHBmcy9kaXIuYw0KQEAgLTMzLDI1ICsz
MywyNyBAQCBzdGF0aWMgbG9mZl90IGhwZnNfZGlyX2xzZWVrKHN0cnVjdCBmaWxlICpmaWxwLCBs
b2ZmX3Qgb2ZmLCBpbnQgd2hlbmNlKQ0KIAlpZiAod2hlbmNlID09IFNFRUtfREFUQSB8fCB3aGVu
Y2UgPT0gU0VFS19IT0xFKQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQorCW11dGV4X2xvY2soJmkt
PmlfbXV0ZXgpOw0KIAlocGZzX2xvY2socyk7DQogDQogCS8qcHJpbnRrKCJkaXIgbHNlZWtcbiIp
OyovDQogCWlmIChuZXdfb2ZmID09IDAgfHwgbmV3X29mZiA9PSAxIHx8IG5ld19vZmYgPT0gMTEg
fHwgbmV3X29mZiA9PSAxMiB8fCBuZXdfb2ZmID09IDEzKSBnb3RvIG9rOw0KLQltdXRleF9sb2Nr
KCZpLT5pX211dGV4KTsNCiAJcG9zID0gKChsb2ZmX3QpIGhwZnNfZGVfYXNfZG93bl9hc19wb3Nz
aWJsZShzLCBocGZzX2lub2RlLT5pX2RubykgPDwgNCkgKyAxOw0KIAl3aGlsZSAocG9zICE9IG5l
d19vZmYpIHsNCiAJCWlmIChtYXBfcG9zX2RpcmVudChpLCAmcG9zLCAmcWJoKSkgaHBmc19icmVs
c2U0KCZxYmgpOw0KIAkJZWxzZSBnb3RvIGZhaWw7DQogCQlpZiAocG9zID09IDEyKSBnb3RvIGZh
aWw7DQogCX0NCi0JbXV0ZXhfdW5sb2NrKCZpLT5pX211dGV4KTsNCisJaHBmc19hZGRfcG9zKGks
ICZmaWxwLT5mX3Bvcyk7DQogb2s6DQorCWZpbHAtPmZfcG9zID0gbmV3X29mZjsNCiAJaHBmc191
bmxvY2socyk7DQotCXJldHVybiBmaWxwLT5mX3BvcyA9IG5ld19vZmY7DQotZmFpbDoNCiAJbXV0
ZXhfdW5sb2NrKCZpLT5pX211dGV4KTsNCisJcmV0dXJuIG5ld19vZmY7DQorZmFpbDoNCiAJLypw
cmludGsoImlsbGVnYWwgbHNlZWs6ICUwMTZsbHhcbiIsIG5ld19vZmYpOyovDQogCWhwZnNfdW5s
b2NrKHMpOw0KKwltdXRleF91bmxvY2soJmktPmlfbXV0ZXgpOw0KIAlyZXR1cm4gLUVTUElQRTsN
CiB9DQogDQpkaWZmIC0tZ2l0IGEvZnMvaHBmcy9ocGZzX2ZuLmggYi9mcy9ocGZzL2hwZnNfZm4u
aA0KaW5kZXggZGU5NDYxNy4uZjFmMmNhNyAxMDA2NDQNCi0tLSBhL2ZzL2hwZnMvaHBmc19mbi5o
DQorKysgYi9mcy9ocGZzL2hwZnNfZm4uaA0KQEAgLTMxNCw3ICszMTQsNyBAQCBzdGF0aWMgaW5s
aW5lIHN0cnVjdCBocGZzX3NiX2luZm8gKmhwZnNfc2Ioc3RydWN0IHN1cGVyX2Jsb2NrICpzYikN
CiBfX3ByaW50ZigyLCAzKQ0KIHZvaWQgaHBmc19lcnJvcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKiwg
Y29uc3QgY2hhciAqLCAuLi4pOw0KIGludCBocGZzX3N0b3BfY3ljbGVzKHN0cnVjdCBzdXBlcl9i
bG9jayAqLCBpbnQsIGludCAqLCBpbnQgKiwgY2hhciAqKTsNCi11bnNpZ25lZCBocGZzX2NvdW50
X29uZV9iaXRtYXAoc3RydWN0IHN1cGVyX2Jsb2NrICosIHNlY25vKTsNCit1bnNpZ25lZCBocGZz
X2dldF9mcmVlX2Rub2RlcyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKik7DQogDQogLyoNCiAgKiBsb2Nh
bCB0aW1lIChIUEZTKSB0byBHTVQgKFVuaXgpDQpkaWZmIC0tZ2l0IGEvZnMvaHBmcy9zdXBlci5j
IGIvZnMvaHBmcy9zdXBlci5jDQppbmRleCBmNzYwYzE1Li5iMDNlNzY2IDEwMDY0NA0KLS0tIGEv
ZnMvaHBmcy9zdXBlci5jDQorKysgYi9mcy9ocGZzL3N1cGVyLmMNCkBAIC0xMTUsNyArMTE1LDcg
QEAgc3RhdGljIHZvaWQgaHBmc19wdXRfc3VwZXIoc3RydWN0IHN1cGVyX2Jsb2NrICpzKQ0KIAlr
ZnJlZShzYmkpOw0KIH0NCiANCi11bnNpZ25lZCBocGZzX2NvdW50X29uZV9iaXRtYXAoc3RydWN0
IHN1cGVyX2Jsb2NrICpzLCBzZWNubyBzZWNubykNCitzdGF0aWMgdW5zaWduZWQgaHBmc19jb3Vu
dF9vbmVfYml0bWFwKHN0cnVjdCBzdXBlcl9ibG9jayAqcywgc2Vjbm8gc2Vjbm8pDQogew0KIAlz
dHJ1Y3QgcXVhZF9idWZmZXJfaGVhZCBxYmg7DQogCXVuc2lnbmVkIGxvbmcgKmJpdHM7DQpAQCAt
MTIzLDcgKzEyMyw3IEBAIHVuc2lnbmVkIGhwZnNfY291bnRfb25lX2JpdG1hcChzdHJ1Y3Qgc3Vw
ZXJfYmxvY2sgKnMsIHNlY25vIHNlY25vKQ0KIA0KIAliaXRzID0gaHBmc19tYXBfNHNlY3RvcnMo
cywgc2Vjbm8sICZxYmgsIDQpOw0KIAlpZiAoIWJpdHMpDQotCQlyZXR1cm4gMDsNCisJCXJldHVy
biAodW5zaWduZWQpLTE7DQogCWNvdW50ID0gYml0bWFwX3dlaWdodChiaXRzLCAyMDQ4ICogQklU
U19QRVJfQllURSk7DQogCWhwZnNfYnJlbHNlNCgmcWJoKTsNCiAJcmV0dXJuIGNvdW50Ow0KQEAg
LTEzNCwyOSArMTM0LDQ1IEBAIHN0YXRpYyB1bnNpZ25lZCBjb3VudF9iaXRtYXBzKHN0cnVjdCBz
dXBlcl9ibG9jayAqcykNCiAJdW5zaWduZWQgbiwgY291bnQsIG5fYmFuZHM7DQogCW5fYmFuZHMg
PSAoaHBmc19zYihzKS0+c2JfZnNfc2l6ZSArIDB4M2ZmZikgPj4gMTQ7DQogCWNvdW50ID0gMDsN
Ci0JZm9yIChuID0gMDsgbiA8IG5fYmFuZHM7IG4rKykNCi0JCWNvdW50ICs9IGhwZnNfY291bnRf
b25lX2JpdG1hcChzLCBsZTMyX3RvX2NwdShocGZzX3NiKHMpLT5zYl9ibXBfZGlyW25dKSk7DQor
CWZvciAobiA9IDA7IG4gPCBuX2JhbmRzOyBuKyspIHsNCisJCXVuc2lnbmVkIGM7DQorCQljID0g
aHBmc19jb3VudF9vbmVfYml0bWFwKHMsIGxlMzJfdG9fY3B1KGhwZnNfc2IocyktPnNiX2JtcF9k
aXJbbl0pKTsNCisJCWlmIChjICE9ICh1bnNpZ25lZCktMSkNCisJCQljb3VudCArPSBjOw0KKwl9
DQogCXJldHVybiBjb3VudDsNCiB9DQogDQordW5zaWduZWQgaHBmc19nZXRfZnJlZV9kbm9kZXMo
c3RydWN0IHN1cGVyX2Jsb2NrICpzKQ0KK3sNCisJc3RydWN0IGhwZnNfc2JfaW5mbyAqc2JpID0g
aHBmc19zYihzKTsNCisJaWYgKHNiaS0+c2Jfbl9mcmVlX2Rub2RlcyA9PSAodW5zaWduZWQpLTEp
IHsNCisJCXVuc2lnbmVkIGMgPSBocGZzX2NvdW50X29uZV9iaXRtYXAocywgc2JpLT5zYl9kbWFw
KTsNCisJCWlmIChjID09ICh1bnNpZ25lZCktMSkNCisJCQlyZXR1cm4gMDsNCisJCXNiaS0+c2Jf
bl9mcmVlX2Rub2RlcyA9IGM7DQorCX0NCisJcmV0dXJuIHNiaS0+c2Jfbl9mcmVlX2Rub2RlczsN
Cit9DQorDQogc3RhdGljIGludCBocGZzX3N0YXRmcyhzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHN0
cnVjdCBrc3RhdGZzICpidWYpDQogew0KIAlzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnMgPSBkZW50cnkt
PmRfc2I7DQogCXN0cnVjdCBocGZzX3NiX2luZm8gKnNiaSA9IGhwZnNfc2Iocyk7DQogCXU2NCBp
ZCA9IGh1Z2VfZW5jb2RlX2RldihzLT5zX2JkZXYtPmJkX2Rldik7DQorDQogCWhwZnNfbG9jayhz
KTsNCiANCi0JLyppZiAoc2JpLT5zYl9uX2ZyZWUgPT0gLTEpIHsqLw0KKwlpZiAoc2JpLT5zYl9u
X2ZyZWUgPT0gKHVuc2lnbmVkKS0xKQ0KIAkJc2JpLT5zYl9uX2ZyZWUgPSBjb3VudF9iaXRtYXBz
KHMpOw0KLQkJc2JpLT5zYl9uX2ZyZWVfZG5vZGVzID0gaHBmc19jb3VudF9vbmVfYml0bWFwKHMs
IHNiaS0+c2JfZG1hcCk7DQotCS8qfSovDQorDQogCWJ1Zi0+Zl90eXBlID0gcy0+c19tYWdpYzsN
CiAJYnVmLT5mX2JzaXplID0gNTEyOw0KIAlidWYtPmZfYmxvY2tzID0gc2JpLT5zYl9mc19zaXpl
Ow0KIAlidWYtPmZfYmZyZWUgPSBzYmktPnNiX25fZnJlZTsNCiAJYnVmLT5mX2JhdmFpbCA9IHNi
aS0+c2Jfbl9mcmVlOw0KIAlidWYtPmZfZmlsZXMgPSBzYmktPnNiX2RpcmJhbmRfc2l6ZSAvIDQ7
DQotCWJ1Zi0+Zl9mZnJlZSA9IHNiaS0+c2Jfbl9mcmVlX2Rub2RlczsNCisJYnVmLT5mX2ZmcmVl
ID0gaHBmc19nZXRfZnJlZV9kbm9kZXMocyk7DQogCWJ1Zi0+Zl9mc2lkLnZhbFswXSA9ICh1MzIp
aWQ7DQogCWJ1Zi0+Zl9mc2lkLnZhbFsxXSA9ICh1MzIpKGlkID4+IDMyKTsNCiAJYnVmLT5mX25h
bWVsZW4gPSAyNTQ7DQpkaWZmIC0tZ2l0IGEvZnMvbG9ja2Qvc3ZjbG9jay5jIGIvZnMvbG9ja2Qv
c3ZjbG9jay5jDQppbmRleCBjZDg3MDNkLi5jYjdiMTg2IDEwMDY0NA0KLS0tIGEvZnMvbG9ja2Qv
c3ZjbG9jay5jDQorKysgYi9mcy9sb2NrZC9zdmNsb2NrLmMNCkBAIC03NDEsNiArNzQxLDcgQEAg
bmxtc3ZjX2dyYW50X2Jsb2NrZWQoc3RydWN0IG5sbV9ibG9jayAqYmxvY2spDQogCXN0cnVjdCBu
bG1fZmlsZQkJKmZpbGUgPSBibG9jay0+Yl9maWxlOw0KIAlzdHJ1Y3QgbmxtX2xvY2sJCSpsb2Nr
ID0gJmJsb2NrLT5iX2NhbGwtPmFfYXJncy5sb2NrOw0KIAlpbnQJCQllcnJvcjsNCisJbG9mZl90
CQkJZmxfc3RhcnQsIGZsX2VuZDsNCiANCiAJZHByaW50aygibG9ja2Q6IGdyYW50IGJsb2NrZWQg
bG9jayAlcFxuIiwgYmxvY2spOw0KIA0KQEAgLTc1OCw5ICs3NTksMTYgQEAgbmxtc3ZjX2dyYW50
X2Jsb2NrZWQoc3RydWN0IG5sbV9ibG9jayAqYmxvY2spDQogCX0NCiANCiAJLyogVHJ5IHRoZSBs
b2NrIG9wZXJhdGlvbiBhZ2FpbiAqLw0KKwkvKiB2ZnNfbG9ja19maWxlKCkgY2FuIG1hbmdsZSBm
bF9zdGFydCBhbmQgZmxfZW5kLCBidXQgd2UgbmVlZA0KKwkgKiB0aGVtIHVuY2hhbmdlZCBmb3Ig
dGhlIEdSQU5UX01TRw0KKwkgKi8NCiAJbG9jay0+ZmwuZmxfZmxhZ3MgfD0gRkxfU0xFRVA7DQor
CWZsX3N0YXJ0ID0gbG9jay0+ZmwuZmxfc3RhcnQ7DQorCWZsX2VuZCA9IGxvY2stPmZsLmZsX2Vu
ZDsNCiAJZXJyb3IgPSB2ZnNfbG9ja19maWxlKGZpbGUtPmZfZmlsZSwgRl9TRVRMSywgJmxvY2st
PmZsLCBOVUxMKTsNCiAJbG9jay0+ZmwuZmxfZmxhZ3MgJj0gfkZMX1NMRUVQOw0KKwlsb2NrLT5m
bC5mbF9zdGFydCA9IGZsX3N0YXJ0Ow0KKwlsb2NrLT5mbC5mbF9lbmQgPSBmbF9lbmQ7DQogDQog
CXN3aXRjaCAoZXJyb3IpIHsNCiAJY2FzZSAwOg0KZGlmZiAtLWdpdCBhL2ZzL25mcy9ibG9ja2xh
eW91dC9leHRlbnRzLmMgYi9mcy9uZnMvYmxvY2tsYXlvdXQvZXh0ZW50cy5jDQppbmRleCA0ZTJl
ZTk5Li5iYjE1Y2NjIDEwMDY0NA0KLS0tIGEvZnMvbmZzL2Jsb2NrbGF5b3V0L2V4dGVudHMuYw0K
KysrIGIvZnMvbmZzL2Jsb2NrbGF5b3V0L2V4dGVudHMuYw0KQEAgLTQ0LDcgKzQ0LDcgQEANCiBz
dGF0aWMgaW5saW5lIHNlY3Rvcl90IG5vcm1hbGl6ZShzZWN0b3JfdCBzLCBpbnQgYmFzZSkNCiB7
DQogCXNlY3Rvcl90IHRtcCA9IHM7IC8qIFNpbmNlIGRvX2RpdiBtb2RpZmllcyBpdHMgYXJndW1l
bnQgKi8NCi0JcmV0dXJuIHMgLSBkb19kaXYodG1wLCBiYXNlKTsNCisJcmV0dXJuIHMgLSBzZWN0
b3JfZGl2KHRtcCwgYmFzZSk7DQogfQ0KIA0KIHN0YXRpYyBpbmxpbmUgc2VjdG9yX3Qgbm9ybWFs
aXplX3VwKHNlY3Rvcl90IHMsIGludCBiYXNlKQ0KZGlmZiAtLWdpdCBhL2ZzL25mcy9uZnM0cHJv
Yy5jIGIvZnMvbmZzL25mczRwcm9jLmMNCmluZGV4IDNkMDI5MzEuLjVhZWEzMGEgMTAwNjQ0DQot
LS0gYS9mcy9uZnMvbmZzNHByb2MuYw0KKysrIGIvZnMvbmZzL25mczRwcm9jLmMNCkBAIC02MTk3
LDcgKzYxOTcsNyBAQCBuZnM0MV9wcm9jX3NlY2luZm9fbm9fbmFtZShzdHJ1Y3QgbmZzX3NlcnZl
ciAqc2VydmVyLCBzdHJ1Y3QgbmZzX2ZoICpmaGFuZGxlLA0KIAkJc3dpdGNoIChlcnIpIHsNCiAJ
CWNhc2UgMDoNCiAJCWNhc2UgLU5GUzRFUlJfV1JPTkdTRUM6DQotCQljYXNlIC1ORlM0RVJSX05P
VFNVUFA6DQorCQljYXNlIC1FTk9UU1VQUDoNCiAJCQlnb3RvIG91dDsNCiAJCWRlZmF1bHQ6DQog
CQkJZXJyID0gbmZzNF9oYW5kbGVfZXhjZXB0aW9uKHNlcnZlciwgZXJyLCAmZXhjZXB0aW9uKTsN
CkBAIC02MjI5LDcgKzYyMjksNyBAQCBuZnM0MV9maW5kX3Jvb3Rfc2VjKHN0cnVjdCBuZnNfc2Vy
dmVyICpzZXJ2ZXIsIHN0cnVjdCBuZnNfZmggKmZoYW5kbGUsDQogCSAqIEZhbGwgYmFjayBvbiAi
Z3Vlc3MgYW5kIGNoZWNrIiBtZXRob2QgaWYNCiAJICogdGhlIHNlcnZlciBkb2Vzbid0IHN1cHBv
cnQgU0VDSU5GT19OT19OQU1FDQogCSAqLw0KLQlpZiAoZXJyID09IC1ORlM0RVJSX1dST05HU0VD
IHx8IGVyciA9PSAtTkZTNEVSUl9OT1RTVVBQKSB7DQorCWlmIChlcnIgPT0gLU5GUzRFUlJfV1JP
TkdTRUMgfHwgZXJyID09IC1FTk9UU1VQUCkgew0KIAkJZXJyID0gbmZzNF9maW5kX3Jvb3Rfc2Vj
KHNlcnZlciwgZmhhbmRsZSwgaW5mbyk7DQogCQlnb3RvIG91dF9mcmVlcGFnZTsNCiAJfQ0KZGlm
ZiAtLWdpdCBhL2ZzL25mcy9uZnM0eGRyLmMgYi9mcy9uZnMvbmZzNHhkci5jDQppbmRleCAwMDgx
OGM4Li40NDc5ZjY2IDEwMDY0NA0KLS0tIGEvZnMvbmZzL25mczR4ZHIuYw0KKysrIGIvZnMvbmZz
L25mczR4ZHIuYw0KQEAgLTMwNTYsNyArMzA1Niw4IEBAIG91dF9vdmVyZmxvdzoNCiAJcmV0dXJu
IC1FSU87DQogfQ0KIA0KLXN0YXRpYyBpbnQgZGVjb2RlX29wX2hkcihzdHJ1Y3QgeGRyX3N0cmVh
bSAqeGRyLCBlbnVtIG5mc19vcG51bTQgZXhwZWN0ZWQpDQorc3RhdGljIGJvb2wgX19kZWNvZGVf
b3BfaGRyKHN0cnVjdCB4ZHJfc3RyZWFtICp4ZHIsIGVudW0gbmZzX29wbnVtNCBleHBlY3RlZCwN
CisJCWludCAqbmZzX3JldHZhbCkNCiB7DQogCV9fYmUzMiAqcDsNCiAJdWludDMyX3Qgb3BudW07
DQpAQCAtMzA2NiwxOSArMzA2NywzMiBAQCBzdGF0aWMgaW50IGRlY29kZV9vcF9oZHIoc3RydWN0
IHhkcl9zdHJlYW0gKnhkciwgZW51bSBuZnNfb3BudW00IGV4cGVjdGVkKQ0KIAlpZiAodW5saWtl
bHkoIXApKQ0KIAkJZ290byBvdXRfb3ZlcmZsb3c7DQogCW9wbnVtID0gYmUzMl90b19jcHVwKHAr
Kyk7DQotCWlmIChvcG51bSAhPSBleHBlY3RlZCkgew0KLQkJZHByaW50aygibmZzOiBTZXJ2ZXIg
cmV0dXJuZWQgb3BlcmF0aW9uIg0KLQkJCSIgJWQgYnV0IHdlIGlzc3VlZCBhIHJlcXVlc3QgZm9y
ICVkXG4iLA0KLQkJCQlvcG51bSwgZXhwZWN0ZWQpOw0KLQkJcmV0dXJuIC1FSU87DQotCX0NCisJ
aWYgKHVubGlrZWx5KG9wbnVtICE9IGV4cGVjdGVkKSkNCisJCWdvdG8gb3V0X2JhZF9vcGVyYXRp
b247DQogCW5mc2VyciA9IGJlMzJfdG9fY3B1cChwKTsNCi0JaWYgKG5mc2VyciAhPSBORlNfT0sp
DQotCQlyZXR1cm4gbmZzNF9zdGF0X3RvX2Vycm5vKG5mc2Vycik7DQotCXJldHVybiAwOw0KKwlp
ZiAobmZzZXJyID09IE5GU19PSykNCisJCSpuZnNfcmV0dmFsID0gMDsNCisJZWxzZQ0KKwkJKm5m
c19yZXR2YWwgPSBuZnM0X3N0YXRfdG9fZXJybm8obmZzZXJyKTsNCisJcmV0dXJuIHRydWU7DQor
b3V0X2JhZF9vcGVyYXRpb246DQorCWRwcmludGsoIm5mczogU2VydmVyIHJldHVybmVkIG9wZXJh
dGlvbiINCisJCSIgJWQgYnV0IHdlIGlzc3VlZCBhIHJlcXVlc3QgZm9yICVkXG4iLA0KKwkJCW9w
bnVtLCBleHBlY3RlZCk7DQorCSpuZnNfcmV0dmFsID0gLUVSRU1PVEVJTzsNCisJcmV0dXJuIGZh
bHNlOw0KIG91dF9vdmVyZmxvdzoNCiAJcHJpbnRfb3ZlcmZsb3dfbXNnKF9fZnVuY19fLCB4ZHIp
Ow0KLQlyZXR1cm4gLUVJTzsNCisJKm5mc19yZXR2YWwgPSAtRUlPOw0KKwlyZXR1cm4gZmFsc2U7
DQorfQ0KKw0KK3N0YXRpYyBpbnQgZGVjb2RlX29wX2hkcihzdHJ1Y3QgeGRyX3N0cmVhbSAqeGRy
LCBlbnVtIG5mc19vcG51bTQgZXhwZWN0ZWQpDQorew0KKwlpbnQgcmV0dmFsOw0KKw0KKwlfX2Rl
Y29kZV9vcF9oZHIoeGRyLCBleHBlY3RlZCwgJnJldHZhbCk7DQorCXJldHVybiByZXR2YWw7DQog
fQ0KIA0KIC8qIER1bW15IHJvdXRpbmUgKi8NCkBAIC00NzQ0LDExICs0NzU4LDEyIEBAIHN0YXRp
YyBpbnQgZGVjb2RlX29wZW4oc3RydWN0IHhkcl9zdHJlYW0gKnhkciwgc3RydWN0IG5mc19vcGVu
cmVzICpyZXMpDQogCXVpbnQzMl90IHNhdmV3b3JkcywgYm1sZW4sIGk7DQogCWludCBzdGF0dXM7
DQogDQotCXN0YXR1cyA9IGRlY29kZV9vcF9oZHIoeGRyLCBPUF9PUEVOKTsNCi0JaWYgKHN0YXR1
cyAhPSAtRUlPKQ0KLQkJbmZzX2luY3JlbWVudF9vcGVuX3NlcWlkKHN0YXR1cywgcmVzLT5zZXFp
ZCk7DQotCWlmICghc3RhdHVzKQ0KLQkJc3RhdHVzID0gZGVjb2RlX3N0YXRlaWQoeGRyLCAmcmVz
LT5zdGF0ZWlkKTsNCisJaWYgKCFfX2RlY29kZV9vcF9oZHIoeGRyLCBPUF9PUEVOLCAmc3RhdHVz
KSkNCisJCXJldHVybiBzdGF0dXM7DQorCW5mc19pbmNyZW1lbnRfb3Blbl9zZXFpZChzdGF0dXMs
IHJlcy0+c2VxaWQpOw0KKwlpZiAoc3RhdHVzKQ0KKwkJcmV0dXJuIHN0YXR1czsNCisJc3RhdHVz
ID0gZGVjb2RlX3N0YXRlaWQoeGRyLCAmcmVzLT5zdGF0ZWlkKTsNCiAJaWYgKHVubGlrZWx5KHN0
YXR1cykpDQogCQlyZXR1cm4gc3RhdHVzOw0KIA0KZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2ZpbGUu
YyBiL2ZzL29jZnMyL2ZpbGUuYw0KaW5kZXggMWM3ZDQ1ZS4uZDIwZDY0YyAxMDA2NDQNCi0tLSBh
L2ZzL29jZnMyL2ZpbGUuYw0KKysrIGIvZnMvb2NmczIvZmlsZS5jDQpAQCAtMjM4OSw4ICsyMzg5
LDggQEAgb3V0X2RpbzoNCiANCiAJaWYgKCgoZmlsZS0+Zl9mbGFncyAmIE9fRFNZTkMpICYmICFk
aXJlY3RfaW8pIHx8IElTX1NZTkMoaW5vZGUpIHx8DQogCSAgICAoKGZpbGUtPmZfZmxhZ3MgJiBP
X0RJUkVDVCkgJiYgIWRpcmVjdF9pbykpIHsNCi0JCXJldCA9IGZpbGVtYXBfZmRhdGF3cml0ZV9y
YW5nZShmaWxlLT5mX21hcHBpbmcsIHBvcywNCi0JCQkJCSAgICAgICBwb3MgKyBjb3VudCAtIDEp
Ow0KKwkJcmV0ID0gZmlsZW1hcF9mZGF0YXdyaXRlX3JhbmdlKGZpbGUtPmZfbWFwcGluZywgKnBw
b3MsDQorCQkJCQkgICAgICAgKnBwb3MgKyBjb3VudCAtIDEpOw0KIAkJaWYgKHJldCA8IDApDQog
CQkJd3JpdHRlbiA9IHJldDsNCiANCkBAIC0yNDAzLDggKzI0MDMsOCBAQCBvdXRfZGlvOg0KIAkJ
fQ0KIA0KIAkJaWYgKCFyZXQpDQotCQkJcmV0ID0gZmlsZW1hcF9mZGF0YXdhaXRfcmFuZ2UoZmls
ZS0+Zl9tYXBwaW5nLCBwb3MsDQotCQkJCQkJICAgICAgcG9zICsgY291bnQgLSAxKTsNCisJCQly
ZXQgPSBmaWxlbWFwX2ZkYXRhd2FpdF9yYW5nZShmaWxlLT5mX21hcHBpbmcsICpwcG9zLA0KKwkJ
CQkJCSAgICAgICpwcG9zICsgY291bnQgLSAxKTsNCiAJfQ0KIA0KIAkvKg0KZGlmZiAtLWdpdCBh
L2ZzL29jZnMyL3F1b3RhX2dsb2JhbC5jIGIvZnMvb2NmczIvcXVvdGFfZ2xvYmFsLmMNCmluZGV4
IDkyZmNkNTcuLmE0MGU1Y2UgMTAwNjQ0DQotLS0gYS9mcy9vY2ZzMi9xdW90YV9nbG9iYWwuYw0K
KysrIGIvZnMvb2NmczIvcXVvdGFfZ2xvYmFsLmMNCkBAIC03MTIsNiArNzEyLDEyIEBAIHN0YXRp
YyBpbnQgb2NmczJfcmVsZWFzZV9kcXVvdChzdHJ1Y3QgZHF1b3QgKmRxdW90KQ0KIAkgKi8NCiAJ
aWYgKHN0YXR1cyA8IDApDQogCQltbG9nX2Vycm5vKHN0YXR1cyk7DQorCS8qDQorCSAqIENsZWFy
IGRxX29mZiBzbyB0aGF0IHdlIHNlYXJjaCBmb3IgdGhlIHN0cnVjdHVyZSBpbiBxdW90YSBmaWxl
IG5leHQNCisJICogdGltZSB3ZSBhY3F1aXJlIGl0LiBUaGUgc3RydWN0dXJlIG1pZ2h0IGJlIGRl
bGV0ZWQgYW5kIHJlYWxsb2NhdGVkDQorCSAqIGVsc2V3aGVyZSBieSBhbm90aGVyIG5vZGUgd2hp
bGUgb3VyIGRxdW90IHN0cnVjdHVyZSBpcyBvbiBmcmVlbGlzdC4NCisJICovDQorCWRxdW90LT5k
cV9vZmYgPSAwOw0KIAljbGVhcl9iaXQoRFFfQUNUSVZFX0IsICZkcXVvdC0+ZHFfZmxhZ3MpOw0K
IG91dF90cmFuczoNCiAJb2NmczJfY29tbWl0X3RyYW5zKG9zYiwgaGFuZGxlKTsNCkBAIC03NTAs
MTYgKzc1NiwxNyBAQCBzdGF0aWMgaW50IG9jZnMyX2FjcXVpcmVfZHF1b3Qoc3RydWN0IGRxdW90
ICpkcXVvdCkNCiAJc3RhdHVzID0gb2NmczJfbG9ja19nbG9iYWxfcWYoaW5mbywgMSk7DQogCWlm
IChzdGF0dXMgPCAwKQ0KIAkJZ290byBvdXQ7DQotCWlmICghdGVzdF9iaXQoRFFfUkVBRF9CLCAm
ZHF1b3QtPmRxX2ZsYWdzKSkgew0KLQkJc3RhdHVzID0gb2NmczJfcWluZm9fbG9jayhpbmZvLCAw
KTsNCi0JCWlmIChzdGF0dXMgPCAwKQ0KLQkJCWdvdG8gb3V0X2RxOw0KLQkJc3RhdHVzID0gcXRy
ZWVfcmVhZF9kcXVvdCgmaW5mby0+ZHFpX2dpLCBkcXVvdCk7DQotCQlvY2ZzMl9xaW5mb191bmxv
Y2soaW5mbywgMCk7DQotCQlpZiAoc3RhdHVzIDwgMCkNCi0JCQlnb3RvIG91dF9kcTsNCi0JfQ0K
LQlzZXRfYml0KERRX1JFQURfQiwgJmRxdW90LT5kcV9mbGFncyk7DQorCXN0YXR1cyA9IG9jZnMy
X3FpbmZvX2xvY2soaW5mbywgMCk7DQorCWlmIChzdGF0dXMgPCAwKQ0KKwkJZ290byBvdXRfZHE7
DQorCS8qDQorCSAqIFdlIGFsd2F5cyB3YW50IHRvIHJlYWQgZHF1b3Qgc3RydWN0dXJlIGZyb20g
ZGlzayBiZWNhdXNlIHdlIGRvbid0DQorCSAqIGtub3cgd2hhdCBoYXBwZW5lZCB3aXRoIGl0IHdo
aWxlIGl0IHdhcyBvbiBmcmVlbGlzdC4NCisJICovDQorCXN0YXR1cyA9IHF0cmVlX3JlYWRfZHF1
b3QoJmluZm8tPmRxaV9naSwgZHF1b3QpOw0KKwlvY2ZzMl9xaW5mb191bmxvY2soaW5mbywgMCk7
DQorCWlmIChzdGF0dXMgPCAwKQ0KKwkJZ290byBvdXRfZHE7DQogDQogCU9DRlMyX0RRVU9UKGRx
dW90KS0+ZHFfdXNlX2NvdW50Kys7DQogCU9DRlMyX0RRVU9UKGRxdW90KS0+ZHFfb3JpZ3NwYWNl
ID0gZHF1b3QtPmRxX2RxYi5kcWJfY3Vyc3BhY2U7DQpkaWZmIC0tZ2l0IGEvZnMvb2NmczIvcXVv
dGFfbG9jYWwuYyBiL2ZzL29jZnMyL3F1b3RhX2xvY2FsLmMNCmluZGV4IGYxMDBiZjcuLmI2Y2Zj
ZjIgMTAwNjQ0DQotLS0gYS9mcy9vY2ZzMi9xdW90YV9sb2NhbC5jDQorKysgYi9mcy9vY2ZzMi9x
dW90YV9sb2NhbC5jDQpAQCAtMTMwMCwxMCArMTMwMCw2IEBAIGludCBvY2ZzMl9sb2NhbF9yZWxl
YXNlX2RxdW90KGhhbmRsZV90ICpoYW5kbGUsIHN0cnVjdCBkcXVvdCAqZHF1b3QpDQogCW9jZnMy
X2pvdXJuYWxfZGlydHkoaGFuZGxlLCBvZC0+ZHFfY2h1bmstPnFjX2hlYWRlcmJoKTsNCiANCiBv
dXQ6DQotCS8qIENsZWFyIHRoZSByZWFkIGJpdCBzbyB0aGF0IG5leHQgdGltZSBzb21lb25lIHVz
ZXMgdGhpcw0KLQkgKiBkcXVvdCBoZSByZWFkcyBmcmVzaCBpbmZvIGZyb20gZGlzayBhbmQgYWxs
b2NhdGVzIGxvY2FsDQotCSAqIGRxdW90IHN0cnVjdHVyZSAqLw0KLQljbGVhcl9iaXQoRFFfUkVB
RF9CLCAmZHF1b3QtPmRxX2ZsYWdzKTsNCiAJcmV0dXJuIHN0YXR1czsNCiB9DQogDQpkaWZmIC0t
Z2l0IGEvZnMvcXVvdGEvZHF1b3QuYyBiL2ZzL3F1b3RhL2RxdW90LmMNCmluZGV4IDViNTcyYzgu
LjNkNWQ3MTcgMTAwNjQ0DQotLS0gYS9mcy9xdW90YS9kcXVvdC5jDQorKysgYi9mcy9xdW90YS9k
cXVvdC5jDQpAQCAtNTgwLDkgKzU4MCwxNyBAQCBpbnQgZHF1b3Rfc2Nhbl9hY3RpdmUoc3RydWN0
IHN1cGVyX2Jsb2NrICpzYiwNCiAJCWRxc3RhdHNfaW5jKERRU1RfTE9PS1VQUyk7DQogCQlkcXB1
dChvbGRfZHF1b3QpOw0KIAkJb2xkX2RxdW90ID0gZHF1b3Q7DQotCQlyZXQgPSBmbihkcXVvdCwg
cHJpdik7DQotCQlpZiAocmV0IDwgMCkNCi0JCQlnb3RvIG91dDsNCisJCS8qDQorCQkgKiAtPnJl
bGVhc2VfZHF1b3QoKSBjYW4gYmUgcmFjaW5nIHdpdGggdXMuIE91ciByZWZlcmVuY2UNCisJCSAq
IHByb3RlY3RzIHVzIGZyb20gbmV3IGNhbGxzIHRvIGl0IHNvIGp1c3Qgd2FpdCBmb3IgYW55DQor
CQkgKiBvdXRzdGFuZGluZyBjYWxsIGFuZCByZWNoZWNrIHRoZSBEUV9BQ1RJVkVfQiBhZnRlciB0
aGF0Lg0KKwkJICovDQorCQl3YWl0X29uX2RxdW90KGRxdW90KTsNCisJCWlmICh0ZXN0X2JpdChE
UV9BQ1RJVkVfQiwgJmRxdW90LT5kcV9mbGFncykpIHsNCisJCQlyZXQgPSBmbihkcXVvdCwgcHJp
dik7DQorCQkJaWYgKHJldCA8IDApDQorCQkJCWdvdG8gb3V0Ow0KKwkJfQ0KIAkJc3Bpbl9sb2Nr
KCZkcV9saXN0X2xvY2spOw0KIAkJLyogV2UgYXJlIHNhZmUgdG8gY29udGludWUgbm93IGJlY2F1
c2Ugb3VyIGRxdW90IGNvdWxkIG5vdA0KIAkJICogYmUgbW92ZWQgb3V0IG9mIHRoZSBpbnVzZSBs
aXN0IHdoaWxlIHdlIGhvbGQgdGhlIHJlZmVyZW5jZSAqLw0KZGlmZiAtLWdpdCBhL2ZzL3NwbGlj
ZS5jIGIvZnMvc3BsaWNlLmMNCmluZGV4IDU4YWI5MTguLjcxNDQ3MWQgMTAwNjQ0DQotLS0gYS9m
cy9zcGxpY2UuYw0KKysrIGIvZnMvc3BsaWNlLmMNCkBAIC01NTQsNiArNTU0LDI0IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgcGlwZV9idWZfb3BlcmF0aW9ucyBkZWZhdWx0X3BpcGVfYnVmX29wcyA9
IHsNCiAJLmdldCA9IGdlbmVyaWNfcGlwZV9idWZfZ2V0LA0KIH07DQogDQorc3RhdGljIGludCBn
ZW5lcmljX3BpcGVfYnVmX25vc3RlYWwoc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqcGlwZSwNCisJ
CQkJICAgIHN0cnVjdCBwaXBlX2J1ZmZlciAqYnVmKQ0KK3sNCisJcmV0dXJuIDE7DQorfQ0KKw0K
Ky8qIFBpcGUgYnVmZmVyIG9wZXJhdGlvbnMgZm9yIGEgc29ja2V0IGFuZCBzaW1pbGFyLiAqLw0K
K2NvbnN0IHN0cnVjdCBwaXBlX2J1Zl9vcGVyYXRpb25zIG5vc3RlYWxfcGlwZV9idWZfb3BzID0g
ew0KKwkuY2FuX21lcmdlID0gMCwNCisJLm1hcCA9IGdlbmVyaWNfcGlwZV9idWZfbWFwLA0KKwku
dW5tYXAgPSBnZW5lcmljX3BpcGVfYnVmX3VubWFwLA0KKwkuY29uZmlybSA9IGdlbmVyaWNfcGlw
ZV9idWZfY29uZmlybSwNCisJLnJlbGVhc2UgPSBnZW5lcmljX3BpcGVfYnVmX3JlbGVhc2UsDQor
CS5zdGVhbCA9IGdlbmVyaWNfcGlwZV9idWZfbm9zdGVhbCwNCisJLmdldCA9IGdlbmVyaWNfcGlw
ZV9idWZfZ2V0LA0KK307DQorRVhQT1JUX1NZTUJPTChub3N0ZWFsX3BpcGVfYnVmX29wcyk7DQor
DQogc3RhdGljIHNzaXplX3Qga2VybmVsX3JlYWR2KHN0cnVjdCBmaWxlICpmaWxlLCBjb25zdCBz
dHJ1Y3QgaW92ZWMgKnZlYywNCiAJCQkgICAgdW5zaWduZWQgbG9uZyB2bGVuLCBsb2ZmX3Qgb2Zm
c2V0KQ0KIHsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyLWdjYzQuaCBiL2lu
Y2x1ZGUvbGludXgvY29tcGlsZXItZ2NjNC5oDQppbmRleCA2NDNkNmM0Li5lMmEzNjBhIDEwMDY0
NA0KLS0tIGEvaW5jbHVkZS9saW51eC9jb21waWxlci1nY2M0LmgNCisrKyBiL2luY2x1ZGUvbGlu
dXgvY29tcGlsZXItZ2NjNC5oDQpAQCAtMzksMTEgKzM5LDcgQEANCiAgKg0KICAqIChhc20gZ290
byBpcyBhdXRvbWF0aWNhbGx5IHZvbGF0aWxlIC0gdGhlIG5hbWluZyByZWZsZWN0cyB0aGlzLikN
CiAgKi8NCi0jaWYgR0NDX1ZFUlNJT04gPD0gNDA4MDENCi0jIGRlZmluZSBhc21fdm9sYXRpbGVf
Z290byh4Li4uKQlkbyB7IGFzbSBnb3RvKHgpOyBhc20gKCIiKTsgfSB3aGlsZSAoMCkNCi0jZWxz
ZQ0KLSMgZGVmaW5lIGFzbV92b2xhdGlsZV9nb3RvKHguLi4pCWRvIHsgYXNtIGdvdG8oeCk7IH0g
d2hpbGUgKDApDQotI2VuZGlmDQorI2RlZmluZSBhc21fdm9sYXRpbGVfZ290byh4Li4uKQlkbyB7
IGFzbSBnb3RvKHgpOyBhc20gKCIiKTsgfSB3aGlsZSAoMCkNCiANCiAjaWYgX19HTlVDX01JTk9S
X18gPj0gNQ0KIC8qDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9qaWZmaWVzLmggYi9pbmNs
dWRlL2xpbnV4L2ppZmZpZXMuaA0KaW5kZXggMjY1ZTJjMy4uZjVkZjNkYyAxMDA2NDQNCi0tLSBh
L2luY2x1ZGUvbGludXgvamlmZmllcy5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2ppZmZpZXMuaA0K
QEAgLTEwNiwxMyArMTA2LDEzIEBAIHN0YXRpYyBpbmxpbmUgdTY0IGdldF9qaWZmaWVzXzY0KHZv
aWQpDQogI2RlZmluZSB0aW1lX2FmdGVyKGEsYikJCVwNCiAJKHR5cGVjaGVjayh1bnNpZ25lZCBs
b25nLCBhKSAmJiBcDQogCSB0eXBlY2hlY2sodW5zaWduZWQgbG9uZywgYikgJiYgXA0KLQkgKChs
b25nKShiKSAtIChsb25nKShhKSA8IDApKQ0KKwkgKChsb25nKSgoYikgLSAoYSkpIDwgMCkpDQog
I2RlZmluZSB0aW1lX2JlZm9yZShhLGIpCXRpbWVfYWZ0ZXIoYixhKQ0KIA0KICNkZWZpbmUgdGlt
ZV9hZnRlcl9lcShhLGIpCVwNCiAJKHR5cGVjaGVjayh1bnNpZ25lZCBsb25nLCBhKSAmJiBcDQog
CSB0eXBlY2hlY2sodW5zaWduZWQgbG9uZywgYikgJiYgXA0KLQkgKChsb25nKShhKSAtIChsb25n
KShiKSA+PSAwKSkNCisJICgobG9uZykoKGEpIC0gKGIpKSA+PSAwKSkNCiAjZGVmaW5lIHRpbWVf
YmVmb3JlX2VxKGEsYikJdGltZV9hZnRlcl9lcShiLGEpDQogDQogLyoNCkBAIC0xMzUsMTMgKzEz
NSwxMyBAQCBzdGF0aWMgaW5saW5lIHU2NCBnZXRfamlmZmllc182NCh2b2lkKQ0KICNkZWZpbmUg
dGltZV9hZnRlcjY0KGEsYikJXA0KIAkodHlwZWNoZWNrKF9fdTY0LCBhKSAmJglcDQogCSB0eXBl
Y2hlY2soX191NjQsIGIpICYmIFwNCi0JICgoX19zNjQpKGIpIC0gKF9fczY0KShhKSA8IDApKQ0K
KwkgKChfX3M2NCkoKGIpIC0gKGEpKSA8IDApKQ0KICNkZWZpbmUgdGltZV9iZWZvcmU2NChhLGIp
CXRpbWVfYWZ0ZXI2NChiLGEpDQogDQogI2RlZmluZSB0aW1lX2FmdGVyX2VxNjQoYSxiKQlcDQog
CSh0eXBlY2hlY2soX191NjQsIGEpICYmIFwNCiAJIHR5cGVjaGVjayhfX3U2NCwgYikgJiYgXA0K
LQkgKChfX3M2NCkoYSkgLSAoX19zNjQpKGIpID49IDApKQ0KKwkgKChfX3M2NCkoKGEpIC0gKGIp
KSA+PSAwKSkNCiAjZGVmaW5lIHRpbWVfYmVmb3JlX2VxNjQoYSxiKQl0aW1lX2FmdGVyX2VxNjQo
YixhKQ0KIA0KIC8qDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9saWJhdGEuaCBiL2luY2x1
ZGUvbGludXgvbGliYXRhLmgNCmluZGV4IDYyNDY3Y2EuLmIxZmNkYmEgMTAwNjQ0DQotLS0gYS9p
bmNsdWRlL2xpbnV4L2xpYmF0YS5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2xpYmF0YS5oDQpAQCAt
MzkzLDYgKzM5Myw4IEBAIGVudW0gew0KIAlBVEFfSE9SS0FHRV9CUk9LRU5fRlBETUFfQUEJPSAo
MSA8PCAxNSksCS8qIHNraXAgQUEgKi8NCiAJQVRBX0hPUktBR0VfRFVNUF9JRAk9ICgxIDw8IDE2
KSwJLyogZHVtcCBJREVOVElGWSBkYXRhICovDQogCUFUQV9IT1JLQUdFX01BWF9TRUNfTEJBNDgg
PSAoMSA8PCAxNyksCS8qIFNldCBtYXggc2VjdHMgdG8gNjU1MzUgKi8NCisJQVRBX0hPUktBR0Vf
Tk9MUE0JPSAoMSA8PCAyMCksCS8qIGRvbid0IHVzZSBMUE0gKi8NCisJQVRBX0hPUktBR0VfV0Rf
QlJPS0VOX0xQTSA9ICgxIDw8IDIxKSwJLyogc29tZSBXRHMgaGF2ZSBicm9rZW4gTFBNICovDQog
DQogCSAvKiBETUEgbWFzayBmb3IgdXNlciBETUEgY29udHJvbDogVXNlciB2aXNpYmxlIHZhbHVl
czsgRE8gTk9UDQogCSAgICByZW51bWJlciAqLw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
cGlwZV9mc19pLmggYi9pbmNsdWRlL2xpbnV4L3BpcGVfZnNfaS5oDQppbmRleCAwMDcyYTUzLi44
Nzc4YzI2IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9waXBlX2ZzX2kuaA0KKysrIGIvaW5j
bHVkZS9saW51eC9waXBlX2ZzX2kuaA0KQEAgLTE2MCw2ICsxNjAsOCBAQCBpbnQgZ2VuZXJpY19w
aXBlX2J1Zl9jb25maXJtKHN0cnVjdCBwaXBlX2lub2RlX2luZm8gKiwgc3RydWN0IHBpcGVfYnVm
ZmVyICopOw0KIGludCBnZW5lcmljX3BpcGVfYnVmX3N0ZWFsKHN0cnVjdCBwaXBlX2lub2RlX2lu
Zm8gKiwgc3RydWN0IHBpcGVfYnVmZmVyICopOw0KIHZvaWQgZ2VuZXJpY19waXBlX2J1Zl9yZWxl
YXNlKHN0cnVjdCBwaXBlX2lub2RlX2luZm8gKiwgc3RydWN0IHBpcGVfYnVmZmVyICopOw0KIA0K
K2V4dGVybiBjb25zdCBzdHJ1Y3QgcGlwZV9idWZfb3BlcmF0aW9ucyBub3N0ZWFsX3BpcGVfYnVm
X29wczsNCisNCiAvKiBmb3IgRl9TRVRQSVBFX1NaIGFuZCBGX0dFVFBJUEVfU1ogKi8NCiBsb25n
IHBpcGVfZmNudGwoc3RydWN0IGZpbGUgKiwgdW5zaWduZWQgaW50LCB1bnNpZ25lZCBsb25nIGFy
Zyk7DQogc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqZ2V0X3BpcGVfaW5mbyhzdHJ1Y3QgZmlsZSAq
ZmlsZSk7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC90cmFjZXBvaW50LmggYi9pbmNsdWRl
L2xpbnV4L3RyYWNlcG9pbnQuaA0KaW5kZXggZGYwYTc3OS4uZjM2ODBhYSAxMDA2NDQNCi0tLSBh
L2luY2x1ZGUvbGludXgvdHJhY2Vwb2ludC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L3RyYWNlcG9p
bnQuaA0KQEAgLTYwLDYgKzYwLDEyIEBAIHN0cnVjdCB0cF9tb2R1bGUgew0KIAl1bnNpZ25lZCBp
bnQgbnVtX3RyYWNlcG9pbnRzOw0KIAlzdHJ1Y3QgdHJhY2Vwb2ludCAqIGNvbnN0ICp0cmFjZXBv
aW50c19wdHJzOw0KIH07DQorYm9vbCB0cmFjZV9tb2R1bGVfaGFzX2JhZF90YWludChzdHJ1Y3Qg
bW9kdWxlICptb2QpOw0KKyNlbHNlDQorc3RhdGljIGlubGluZSBib29sIHRyYWNlX21vZHVsZV9o
YXNfYmFkX3RhaW50KHN0cnVjdCBtb2R1bGUgKm1vZCkNCit7DQorCXJldHVybiBmYWxzZTsNCit9
DQogI2VuZGlmIC8qIENPTkZJR19NT0RVTEVTICovDQogDQogc3RydWN0IHRyYWNlcG9pbnRfaXRl
ciB7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9zY3NpL29zZF9vcmUuaCBiL2luY2x1ZGUvc2NzaS9v
c2Rfb3JlLmgNCmluZGV4IGYwNWZhODIuLjQ3YjQ1OGMgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL3Nj
c2kvb3NkX29yZS5oDQorKysgYi9pbmNsdWRlL3Njc2kvb3NkX29yZS5oDQpAQCAtMTAxLDYgKzEw
MSw3IEBAIHN0cnVjdCBvcmVfc3RyaXBpbmdfaW5mbyB7DQogCXVuc2lnbmVkIHVuaXRfb2ZmOw0K
IAl1bnNpZ25lZCBjdXJfcGc7DQogCXVuc2lnbmVkIGN1cl9jb21wOw0KKwl1bnNpZ25lZCBtYXhk
ZXZVbml0czsNCiB9Ow0KIA0KIHN0cnVjdCBvcmVfaW9fc3RhdGU7DQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS94ZW4vS2J1aWxkIGIvaW5jbHVkZS94ZW4vS2J1aWxkDQppbmRleCA4NGFkOGYwLi41NjMx
NjFhIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS94ZW4vS2J1aWxkDQorKysgYi9pbmNsdWRlL3hlbi9L
YnVpbGQNCkBAIC0xLDIgKzEsNCBAQA0KIGhlYWRlci15ICs9IGV2dGNobi5oDQoraGVhZGVyLXkg
Kz0gZ250YWxsb2MuaA0KK2hlYWRlci15ICs9IGdudGRldi5oDQogaGVhZGVyLXkgKz0gcHJpdmNt
ZC5oDQpkaWZmIC0tZ2l0IGEva2VybmVsL2Nncm91cC5jIGIva2VybmVsL2Nncm91cC5jDQppbmRl
eCAyYTFmZmI3Li45M2ZjMTVlIDEwMDY0NA0KLS0tIGEva2VybmVsL2Nncm91cC5jDQorKysgYi9r
ZXJuZWwvY2dyb3VwLmMNCkBAIC0yNzg1LDkgKzI3ODUsMTQgQEAgc3RhdGljIHZvaWQgY2dyb3Vw
X2VuYWJsZV90YXNrX2NnX2xpc3RzKHZvaWQpDQogCQkgKiBXZSBzaG91bGQgY2hlY2sgaWYgdGhl
IHByb2Nlc3MgaXMgZXhpdGluZywgb3RoZXJ3aXNlDQogCQkgKiBpdCB3aWxsIHJhY2Ugd2l0aCBj
Z3JvdXBfZXhpdCgpIGluIHRoYXQgdGhlIGxpc3QNCiAJCSAqIGVudHJ5IHdvbid0IGJlIGRlbGV0
ZWQgdGhvdWdoIHRoZSBwcm9jZXNzIGhhcyBleGl0ZWQuDQorCQkgKiBEbyBpdCB3aGlsZSBob2xk
aW5nIHNpZ2xvY2sgc28gdGhhdCB3ZSBkb24ndCBlbmQgdXANCisJCSAqIHJhY2luZyBhZ2FpbnN0
IGNncm91cF9leGl0KCkuDQogCQkgKi8NCisJCXNwaW5fbG9ja19pcnEoJnAtPnNpZ2hhbmQtPnNp
Z2xvY2spOw0KIAkJaWYgKCEocC0+ZmxhZ3MgJiBQRl9FWElUSU5HKSAmJiBsaXN0X2VtcHR5KCZw
LT5jZ19saXN0KSkNCiAJCQlsaXN0X2FkZCgmcC0+Y2dfbGlzdCwgJnAtPmNncm91cHMtPnRhc2tz
KTsNCisJCXNwaW5fdW5sb2NrX2lycSgmcC0+c2lnaGFuZC0+c2lnbG9jayk7DQorDQogCQl0YXNr
X3VubG9jayhwKTsNCiAJfSB3aGlsZV9lYWNoX3RocmVhZChnLCBwKTsNCiAJd3JpdGVfdW5sb2Nr
KCZjc3Nfc2V0X2xvY2spOw0KZGlmZiAtLWdpdCBhL2tlcm5lbC9jcHVzZXQuYyBiL2tlcm5lbC9j
cHVzZXQuYw0KaW5kZXggNTdlYjk4ZC4uMWUyYzVmMCAxMDA2NDQNCi0tLSBhL2tlcm5lbC9jcHVz
ZXQuYw0KKysrIGIva2VybmVsL2NwdXNldC5jDQpAQCAtMjM2Niw5ICsyMzY2LDkgQEAgaW50IF9f
Y3B1c2V0X25vZGVfYWxsb3dlZF9zb2Z0d2FsbChpbnQgbm9kZSwgZ2ZwX3QgZ2ZwX21hc2spDQog
DQogCXRhc2tfbG9jayhjdXJyZW50KTsNCiAJY3MgPSBuZWFyZXN0X2hhcmR3YWxsX2FuY2VzdG9y
KHRhc2tfY3MoY3VycmVudCkpOw0KKwlhbGxvd2VkID0gbm9kZV9pc3NldChub2RlLCBjcy0+bWVt
c19hbGxvd2VkKTsNCiAJdGFza191bmxvY2soY3VycmVudCk7DQogDQotCWFsbG93ZWQgPSBub2Rl
X2lzc2V0KG5vZGUsIGNzLT5tZW1zX2FsbG93ZWQpOw0KIAltdXRleF91bmxvY2soJmNhbGxiYWNr
X211dGV4KTsNCiAJcmV0dXJuIGFsbG93ZWQ7DQogfQ0KZGlmZiAtLWdpdCBhL2tlcm5lbC9ldmVu
dHMvY29yZS5jIGIva2VybmVsL2V2ZW50cy9jb3JlLmMNCmluZGV4IDgzZDU2MjEuLmIxNWI0Zjcg
MTAwNjQ0DQotLS0gYS9rZXJuZWwvZXZlbnRzL2NvcmUuYw0KKysrIGIva2VybmVsL2V2ZW50cy9j
b3JlLmMNCkBAIC03MTAxLDE0ICs3MTAxLDE0IEBAIHN0YXRpYyB2b2lkIHBlcmZfcG11X3JvdGF0
ZV9zdG9wKHN0cnVjdCBwbXUgKnBtdSkNCiBzdGF0aWMgdm9pZCBfX3BlcmZfZXZlbnRfZXhpdF9j
b250ZXh0KHZvaWQgKl9faW5mbykNCiB7DQogCXN0cnVjdCBwZXJmX2V2ZW50X2NvbnRleHQgKmN0
eCA9IF9faW5mbzsNCi0Jc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50LCAqdG1wOw0KKwlzdHJ1Y3Qg
cGVyZl9ldmVudCAqZXZlbnQ7DQogDQogCXBlcmZfcG11X3JvdGF0ZV9zdG9wKGN0eC0+cG11KTsN
CiANCi0JbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGV2ZW50LCB0bXAsICZjdHgtPnBpbm5lZF9n
cm91cHMsIGdyb3VwX2VudHJ5KQ0KLQkJX19wZXJmX3JlbW92ZV9mcm9tX2NvbnRleHQoZXZlbnQp
Ow0KLQlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoZXZlbnQsIHRtcCwgJmN0eC0+ZmxleGlibGVf
Z3JvdXBzLCBncm91cF9lbnRyeSkNCisJcmN1X3JlYWRfbG9jaygpOw0KKwlsaXN0X2Zvcl9lYWNo
X2VudHJ5X3JjdShldmVudCwgJmN0eC0+ZXZlbnRfbGlzdCwgZXZlbnRfZW50cnkpDQogCQlfX3Bl
cmZfcmVtb3ZlX2Zyb21fY29udGV4dChldmVudCk7DQorCXJjdV9yZWFkX3VubG9jaygpOw0KIH0N
CiANCiBzdGF0aWMgdm9pZCBwZXJmX2V2ZW50X2V4aXRfY3B1X2NvbnRleHQoaW50IGNwdSkNCkBA
IC03MTMyLDExICs3MTMyLDExIEBAIHN0YXRpYyB2b2lkIHBlcmZfZXZlbnRfZXhpdF9jcHUoaW50
IGNwdSkNCiB7DQogCXN0cnVjdCBzd2V2ZW50X2h0YWJsZSAqc3doYXNoID0gJnBlcl9jcHUoc3dl
dmVudF9odGFibGUsIGNwdSk7DQogDQorCXBlcmZfZXZlbnRfZXhpdF9jcHVfY29udGV4dChjcHUp
Ow0KKw0KIAltdXRleF9sb2NrKCZzd2hhc2gtPmhsaXN0X211dGV4KTsNCiAJc3dldmVudF9obGlz
dF9yZWxlYXNlKHN3aGFzaCk7DQogCW11dGV4X3VubG9jaygmc3doYXNoLT5obGlzdF9tdXRleCk7
DQotDQotCXBlcmZfZXZlbnRfZXhpdF9jcHVfY29udGV4dChjcHUpOw0KIH0NCiAjZWxzZQ0KIHN0
YXRpYyBpbmxpbmUgdm9pZCBwZXJmX2V2ZW50X2V4aXRfY3B1KGludCBjcHUpIHsgfQ0KZGlmZiAt
LWdpdCBhL2tlcm5lbC9pcnEvbWFuYWdlLmMgYi9rZXJuZWwvaXJxL21hbmFnZS5jDQppbmRleCA1
MmJkZDU4Li40Nzc1MjI5IDEwMDY0NA0KLS0tIGEva2VybmVsL2lycS9tYW5hZ2UuYw0KKysrIGIv
a2VybmVsL2lycS9tYW5hZ2UuYw0KQEAgLTgxOSw3ICs4MTksNyBAQCBzdGF0aWMgaW50IGlycV90
aHJlYWQodm9pZCAqZGF0YSkNCiANCiAJCXdha2UgPSBhdG9taWNfZGVjX2FuZF90ZXN0KCZkZXNj
LT50aHJlYWRzX2FjdGl2ZSk7DQogDQotCQlpZiAod2FrZSAmJiB3YWl0cXVldWVfYWN0aXZlKCZk
ZXNjLT53YWl0X2Zvcl90aHJlYWRzKSkNCisJCWlmICh3YWtlKQ0KIAkJCXdha2VfdXAoJmRlc2Mt
PndhaXRfZm9yX3RocmVhZHMpOw0KIAl9DQogDQpkaWZmIC0tZ2l0IGEva2VybmVsL3ByaW50ay5j
IGIva2VybmVsL3ByaW50ay5jDQppbmRleCAxNjY4OGVjLi44ZmFjNDM0IDEwMDY0NA0KLS0tIGEv
a2VybmVsL3ByaW50ay5jDQorKysgYi9rZXJuZWwvcHJpbnRrLmMNCkBAIC0xMTY1LDcgKzExNjUs
NiBAQCBzdGF0aWMgaW50IF9fY3B1aW5pdCBjb25zb2xlX2NwdV9ub3RpZnkoc3RydWN0IG5vdGlm
aWVyX2Jsb2NrICpzZWxmLA0KIAlzd2l0Y2ggKGFjdGlvbikgew0KIAljYXNlIENQVV9PTkxJTkU6
DQogCWNhc2UgQ1BVX0RFQUQ6DQotCWNhc2UgQ1BVX0RZSU5HOg0KIAljYXNlIENQVV9ET1dOX0ZB
SUxFRDoNCiAJY2FzZSBDUFVfVVBfQ0FOQ0VMRUQ6DQogCQljb25zb2xlX2xvY2soKTsNCmRpZmYg
LS1naXQgYS9rZXJuZWwvc2NoZWRfZmFpci5jIGIva2VybmVsL3NjaGVkX2ZhaXIuYw0KaW5kZXgg
MzdmM2YzOS4uNGM2ZGFlMSAxMDA2NDQNCi0tLSBhL2tlcm5lbC9zY2hlZF9mYWlyLmMNCisrKyBi
L2tlcm5lbC9zY2hlZF9mYWlyLmMNCkBAIC00OTUzLDE1ICs0OTUzLDE1IEBAIHN0YXRpYyB2b2lk
IHN3aXRjaGVkX2Zyb21fZmFpcihzdHJ1Y3QgcnEgKnJxLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAp
DQogCXN0cnVjdCBjZnNfcnEgKmNmc19ycSA9IGNmc19ycV9vZihzZSk7DQogDQogCS8qDQotCSAq
IEVuc3VyZSB0aGUgdGFzaydzIHZydW50aW1lIGlzIG5vcm1hbGl6ZWQsIHNvIHRoYXQgd2hlbiBp
dHMNCisJICogRW5zdXJlIHRoZSB0YXNrJ3MgdnJ1bnRpbWUgaXMgbm9ybWFsaXplZCwgc28gdGhh
dCB3aGVuIGl0J3MNCiAJICogc3dpdGNoZWQgYmFjayB0byB0aGUgZmFpciBjbGFzcyB0aGUgZW5x
dWV1ZV9lbnRpdHkoLmZsYWdzPTApIHdpbGwNCiAJICogZG8gdGhlIHJpZ2h0IHRoaW5nLg0KIAkg
Kg0KLQkgKiBJZiBpdCB3YXMgb25fcnEsIHRoZW4gdGhlIGRlcXVldWVfZW50aXR5KC5mbGFncz0w
KSB3aWxsIGFscmVhZHkNCi0JICogaGF2ZSBub3JtYWxpemVkIHRoZSB2cnVudGltZSwgaWYgaXQg
d2FzICFvbl9ycSwgdGhlbiBvbmx5IHdoZW4NCisJICogSWYgaXQncyBvbl9ycSwgdGhlbiB0aGUg
ZGVxdWV1ZV9lbnRpdHkoLmZsYWdzPTApIHdpbGwgYWxyZWFkeQ0KKwkgKiBoYXZlIG5vcm1hbGl6
ZWQgdGhlIHZydW50aW1lLCBpZiBpdCdzICFvbl9ycSwgdGhlbiBvbmx5IHdoZW4NCiAJICogdGhl
IHRhc2sgaXMgc2xlZXBpbmcgd2lsbCBpdCBzdGlsbCBoYXZlIG5vbi1ub3JtYWxpemVkIHZydW50
aW1lLg0KIAkgKi8NCi0JaWYgKCFzZS0+b25fcnEgJiYgcC0+c3RhdGUgIT0gVEFTS19SVU5OSU5H
KSB7DQorCWlmICghcC0+b25fcnEgJiYgcC0+c3RhdGUgIT0gVEFTS19SVU5OSU5HKSB7DQogCQkv
Kg0KIAkJICogRml4IHVwIG91ciB2cnVudGltZSBzbyB0aGF0IHRoZSBjdXJyZW50IHNsZWVwIGRv
ZXNuJ3QNCiAJCSAqIGNhdXNlICd1bmxpbWl0ZWQnIHNsZWVwIGJvbnVzLg0KZGlmZiAtLWdpdCBh
L2tlcm5lbC90aW1lL2ppZmZpZXMuYyBiL2tlcm5lbC90aW1lL2ppZmZpZXMuYw0KaW5kZXggYTQ3
MDE1NC4uOTU1NTYwZSAxMDA2NDQNCi0tLSBhL2tlcm5lbC90aW1lL2ppZmZpZXMuYw0KKysrIGIv
a2VybmVsL3RpbWUvamlmZmllcy5jDQpAQCAtNTEsNyArNTEsMTMgQEANCiAgKiBIWiBzaHJpbmtz
LCBzbyB2YWx1ZXMgZ3JlYXRlciB0aGFuIDggb3ZlcmZsb3cgMzJiaXRzIHdoZW4NCiAgKiBIWj0x
MDAuDQogICovDQorI2lmIEhaIDwgMzQNCisjZGVmaW5lIEpJRkZJRVNfU0hJRlQJNg0KKyNlbGlm
IEhaIDwgNjcNCisjZGVmaW5lIEpJRkZJRVNfU0hJRlQJNw0KKyNlbHNlDQogI2RlZmluZSBKSUZG
SUVTX1NISUZUCTgNCisjZW5kaWYNCiANCiBzdGF0aWMgY3ljbGVfdCBqaWZmaWVzX3JlYWQoc3Ry
dWN0IGNsb2Nrc291cmNlICpjcykNCiB7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RpbWUvdGltZWtl
ZXBpbmcuYyBiL2tlcm5lbC90aW1lL3RpbWVrZWVwaW5nLmMNCmluZGV4IGNiN2YzM2UuLjA2OGMw
OTIgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdGltZS90aW1la2VlcGluZy5jDQorKysgYi9rZXJuZWwv
dGltZS90aW1la2VlcGluZy5jDQpAQCAtMTE2MSw3ICsxMTYxLDcgQEAgdm9pZCBnZXRfbW9ub3Rv
bmljX2Jvb3R0aW1lKHN0cnVjdCB0aW1lc3BlYyAqdHMpDQogCX0gd2hpbGUgKHJlYWRfc2VxcmV0
cnkoJnh0aW1lX2xvY2ssIHNlcSkpOw0KIA0KIAlzZXRfbm9ybWFsaXplZF90aW1lc3BlYyh0cywg
dHMtPnR2X3NlYyArIHRvbW9uby50dl9zZWMgKyBzbGVlcC50dl9zZWMsDQotCQkJdHMtPnR2X25z
ZWMgKyB0b21vbm8udHZfbnNlYyArIHNsZWVwLnR2X25zZWMgKyBuc2Vjcyk7DQorCQkoczY0KXRz
LT50dl9uc2VjICsgdG9tb25vLnR2X25zZWMgKyBzbGVlcC50dl9uc2VjICsgbnNlY3MpOw0KIH0N
CiBFWFBPUlRfU1lNQk9MX0dQTChnZXRfbW9ub3RvbmljX2Jvb3R0aW1lKTsNCiANCmRpZmYgLS1n
aXQgYS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCmluZGV4
IGNmOGI0MzkuLmE2NWZhMzYgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCisr
KyBiL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KQEAgLTE5MCw2ICsxOTAsMTIgQEAgc3RhdGljIHZv
aWQgdXBkYXRlX2dsb2JhbF9vcHModm9pZCkNCiAJZ2xvYmFsX29wcy5mdW5jID0gZnVuYzsNCiB9
DQogDQorI2lmZGVmIENPTkZJR19GVU5DVElPTl9HUkFQSF9UUkFDRVINCitzdGF0aWMgdm9pZCB1
cGRhdGVfZnVuY3Rpb25fZ3JhcGhfZnVuYyh2b2lkKTsNCisjZWxzZQ0KK3N0YXRpYyBpbmxpbmUg
dm9pZCB1cGRhdGVfZnVuY3Rpb25fZ3JhcGhfZnVuYyh2b2lkKSB7IH0NCisjZW5kaWYNCisNCiBz
dGF0aWMgdm9pZCB1cGRhdGVfZnRyYWNlX2Z1bmN0aW9uKHZvaWQpDQogew0KIAlmdHJhY2VfZnVu
Y190IGZ1bmM7DQpAQCAtMjM3LDYgKzI0Myw4IEBAIHN0YXRpYyBpbnQgcmVtb3ZlX2Z0cmFjZV9v
cHMoc3RydWN0IGZ0cmFjZV9vcHMgKipsaXN0LCBzdHJ1Y3QgZnRyYWNlX29wcyAqb3BzKQ0KIHsN
CiAJc3RydWN0IGZ0cmFjZV9vcHMgKipwOw0KIA0KKwl1cGRhdGVfZnVuY3Rpb25fZ3JhcGhfZnVu
YygpOw0KKw0KIAkvKg0KIAkgKiBJZiB3ZSBhcmUgcmVtb3ZpbmcgdGhlIGxhc3QgZnVuY3Rpb24s
IHRoZW4gc2ltcGx5IHBvaW50DQogCSAqIHRvIHRoZSBmdHJhY2Vfc3R1Yi4NCkBAIC0yODMsNiAr
MjkxLDE3IEBAIHN0YXRpYyBpbnQgX19yZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb24oc3RydWN0IGZ0
cmFjZV9vcHMgKm9wcykNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIGZ0cmFjZV9z
eW5jKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCit7DQorCS8qDQorCSAqIFRoaXMgZnVuY3Rp
b24gaXMganVzdCBhIHN0dWIgdG8gaW1wbGVtZW50IGEgaGFyZCBmb3JjZQ0KKwkgKiBvZiBzeW5j
aHJvbml6ZV9zY2hlZCgpLiBUaGlzIHJlcXVpcmVzIHN5bmNocm9uaXppbmcNCisJICogdGFza3Mg
ZXZlbiBpbiB1c2Vyc3BhY2UgYW5kIGlkbGUuDQorCSAqDQorCSAqIFllcywgZnVuY3Rpb24gdHJh
Y2luZyBpcyBydWRlLg0KKwkgKi8NCit9DQorDQogc3RhdGljIGludCBfX3VucmVnaXN0ZXJfZnRy
YWNlX2Z1bmN0aW9uKHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMpDQogew0KIAlpbnQgcmV0Ow0KQEAg
LTMwOCwxMyArMzI3LDYgQEAgc3RhdGljIGludCBfX3VucmVnaXN0ZXJfZnRyYWNlX2Z1bmN0aW9u
KHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMpDQogCWlmIChmdHJhY2VfZW5hYmxlZCkNCiAJCXVwZGF0
ZV9mdHJhY2VfZnVuY3Rpb24oKTsNCiANCi0JLyoNCi0JICogRHluYW1pYyBvcHMgbWF5IGJlIGZy
ZWVkLCB3ZSBtdXN0IG1ha2Ugc3VyZSB0aGF0IGFsbA0KLQkgKiBjYWxsZXJzIGFyZSBkb25lIGJl
Zm9yZSBsZWF2aW5nIHRoaXMgZnVuY3Rpb24uDQotCSAqLw0KLQlpZiAob3BzLT5mbGFncyAmIEZU
UkFDRV9PUFNfRkxfRFlOQU1JQykNCi0JCXN5bmNocm9uaXplX3NjaGVkKCk7DQotDQogCXJldHVy
biAwOw0KIH0NCiANCkBAIC0xNzc1LDYgKzE3ODcsMjQgQEAgc3RhdGljIGludCBmdHJhY2Vfc2h1
dGRvd24oc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywgaW50IGNvbW1hbmQpDQogCQlyZXR1cm4gMDsN
CiANCiAJZnRyYWNlX3J1bl91cGRhdGVfY29kZShjb21tYW5kKTsNCisNCisJLyoNCisJICogRHlu
YW1pYyBvcHMgbWF5IGJlIGZyZWVkLCB3ZSBtdXN0IG1ha2Ugc3VyZSB0aGF0IGFsbA0KKwkgKiBj
YWxsZXJzIGFyZSBkb25lIGJlZm9yZSBsZWF2aW5nIHRoaXMgZnVuY3Rpb24uDQorCSAqIFRoZSBz
YW1lIGdvZXMgZm9yIGZyZWVpbmcgdGhlIHBlcl9jcHUgZGF0YSBvZiB0aGUgY29udHJvbA0KKwkg
KiBvcHMuDQorCSAqDQorCSAqIEFnYWluLCBub3JtYWwgc3luY2hyb25pemVfc2NoZWQoKSBpcyBu
b3QgZ29vZCBlbm91Z2guDQorCSAqIFdlIG5lZWQgdG8gZG8gYSBoYXJkIGZvcmNlIG9mIHNjaGVk
IHN5bmNocm9uaXphdGlvbi4NCisJICogVGhpcyBpcyBiZWNhdXNlIHdlIHVzZSBwcmVlbXB0X2Rp
c2FibGUoKSB0byBkbyBSQ1UsIGJ1dA0KKwkgKiB0aGUgZnVuY3Rpb24gdHJhY2VycyBjYW4gYmUg
Y2FsbGVkIHdoZXJlIFJDVSBpcyBub3Qgd2F0Y2hpbmcNCisJICogKGxpa2UgYmVmb3JlIHVzZXJf
ZXhpdCgpKS4gV2UgY2FuIG5vdCByZWx5IG9uIHRoZSBSQ1UNCisJICogaW5mcmFzdHJ1Y3R1cmUg
dG8gZG8gdGhlIHN5bmNocm9uaXphdGlvbiwgdGh1cyB3ZSBtdXN0IGRvIGl0DQorCSAqIG91cnNl
bHZlcy4NCisJICovDQorCWlmIChvcHMtPmZsYWdzICYgKEZUUkFDRV9PUFNfRkxfRFlOQU1JQykp
DQorCQlzY2hlZHVsZV9vbl9lYWNoX2NwdShmdHJhY2Vfc3luYyk7DQorDQogCXJldHVybiAwOw0K
IH0NCiANCkBAIC00MDQ1LDYgKzQwNzUsNyBAQCBpbnQgZnRyYWNlX2dyYXBoX2VudHJ5X3N0dWIo
c3RydWN0IGZ0cmFjZV9ncmFwaF9lbnQgKnRyYWNlKQ0KIHRyYWNlX2Z1bmNfZ3JhcGhfcmV0X3Qg
ZnRyYWNlX2dyYXBoX3JldHVybiA9DQogCQkJKHRyYWNlX2Z1bmNfZ3JhcGhfcmV0X3QpZnRyYWNl
X3N0dWI7DQogdHJhY2VfZnVuY19ncmFwaF9lbnRfdCBmdHJhY2VfZ3JhcGhfZW50cnkgPSBmdHJh
Y2VfZ3JhcGhfZW50cnlfc3R1YjsNCitzdGF0aWMgdHJhY2VfZnVuY19ncmFwaF9lbnRfdCBfX2Z0
cmFjZV9ncmFwaF9lbnRyeSA9IGZ0cmFjZV9ncmFwaF9lbnRyeV9zdHViOw0KIA0KIC8qIFRyeSB0
byBhc3NpZ24gYSByZXR1cm4gc3RhY2sgYXJyYXkgb24gRlRSQUNFX1JFVFNUQUNLX0FMTE9DX1NJ
WkUgdGFza3MuICovDQogc3RhdGljIGludCBhbGxvY19yZXRzdGFja190YXNrbGlzdChzdHJ1Y3Qg
ZnRyYWNlX3JldF9zdGFjayAqKnJldF9zdGFja19saXN0KQ0KQEAgLTQxODUsNiArNDIxNiwzMCBA
QCBzdGF0aWMgc3RydWN0IGZ0cmFjZV9vcHMgZmdyYXBoX29wcyBfX3JlYWRfbW9zdGx5ID0gew0K
IAkuZmxhZ3MJCT0gRlRSQUNFX09QU19GTF9HTE9CQUwsDQogfTsNCiANCitzdGF0aWMgaW50IGZ0
cmFjZV9ncmFwaF9lbnRyeV90ZXN0KHN0cnVjdCBmdHJhY2VfZ3JhcGhfZW50ICp0cmFjZSkNCit7
DQorCWlmICghZnRyYWNlX29wc190ZXN0KCZnbG9iYWxfb3BzLCB0cmFjZS0+ZnVuYykpDQorCQly
ZXR1cm4gMDsNCisJcmV0dXJuIF9fZnRyYWNlX2dyYXBoX2VudHJ5KHRyYWNlKTsNCit9DQorDQor
LyoNCisgKiBUaGUgZnVuY3Rpb24gZ3JhcGggdHJhY2VyIHNob3VsZCBvbmx5IHRyYWNlIHRoZSBm
dW5jdGlvbnMgZGVmaW5lZA0KKyAqIGJ5IHNldF9mdHJhY2VfZmlsdGVyIGFuZCBzZXRfZnRyYWNl
X25vdHJhY2UuIElmIGFub3RoZXIgZnVuY3Rpb24NCisgKiB0cmFjZXIgb3BzIGlzIHJlZ2lzdGVy
ZWQsIHRoZSBncmFwaCB0cmFjZXIgcmVxdWlyZXMgdGVzdGluZyB0aGUNCisgKiBmdW5jdGlvbiBh
Z2FpbnN0IHRoZSBnbG9iYWwgb3BzLCBhbmQgbm90IGp1c3QgdHJhY2UgYW55IGZ1bmN0aW9uDQor
ICogdGhhdCBhbnkgZnRyYWNlX29wcyByZWdpc3RlcmVkLg0KKyAqLw0KK3N0YXRpYyB2b2lkIHVw
ZGF0ZV9mdW5jdGlvbl9ncmFwaF9mdW5jKHZvaWQpDQorew0KKwlpZiAoZnRyYWNlX29wc19saXN0
ID09ICZmdHJhY2VfbGlzdF9lbmQgfHwNCisJICAgIChmdHJhY2Vfb3BzX2xpc3QgPT0gJmdsb2Jh
bF9vcHMgJiYNCisJICAgICBnbG9iYWxfb3BzLm5leHQgPT0gJmZ0cmFjZV9saXN0X2VuZCkpDQor
CQlmdHJhY2VfZ3JhcGhfZW50cnkgPSBfX2Z0cmFjZV9ncmFwaF9lbnRyeTsNCisJZWxzZQ0KKwkJ
ZnRyYWNlX2dyYXBoX2VudHJ5ID0gZnRyYWNlX2dyYXBoX2VudHJ5X3Rlc3Q7DQorfQ0KKw0KIGlu
dCByZWdpc3Rlcl9mdHJhY2VfZ3JhcGgodHJhY2VfZnVuY19ncmFwaF9yZXRfdCByZXRmdW5jLA0K
IAkJCXRyYWNlX2Z1bmNfZ3JhcGhfZW50X3QgZW50cnlmdW5jKQ0KIHsNCkBAIC00MjA5LDcgKzQy
NjQsMTYgQEAgaW50IHJlZ2lzdGVyX2Z0cmFjZV9ncmFwaCh0cmFjZV9mdW5jX2dyYXBoX3JldF90
IHJldGZ1bmMsDQogCX0NCiANCiAJZnRyYWNlX2dyYXBoX3JldHVybiA9IHJldGZ1bmM7DQotCWZ0
cmFjZV9ncmFwaF9lbnRyeSA9IGVudHJ5ZnVuYzsNCisNCisJLyoNCisJICogVXBkYXRlIHRoZSBp
bmRpcmVjdCBmdW5jdGlvbiB0byB0aGUgZW50cnlmdW5jLCBhbmQgdGhlDQorCSAqIGZ1bmN0aW9u
IHRoYXQgZ2V0cyBjYWxsZWQgdG8gdGhlIGVudHJ5X3Rlc3QgZmlyc3QuIFRoZW4NCisJICogY2Fs
bCB0aGUgdXBkYXRlIGZncmFwaCBlbnRyeSBmdW5jdGlvbiB0byBkZXRlcm1pbmUgaWYNCisJICog
dGhlIGVudHJ5ZnVuYyBzaG91bGQgYmUgY2FsbGVkIGRpcmVjdGx5IG9yIG5vdC4NCisJICovDQor
CV9fZnRyYWNlX2dyYXBoX2VudHJ5ID0gZW50cnlmdW5jOw0KKwlmdHJhY2VfZ3JhcGhfZW50cnkg
PSBmdHJhY2VfZ3JhcGhfZW50cnlfdGVzdDsNCisJdXBkYXRlX2Z1bmN0aW9uX2dyYXBoX2Z1bmMo
KTsNCiANCiAJcmV0ID0gZnRyYWNlX3N0YXJ0dXAoJmZncmFwaF9vcHMsIEZUUkFDRV9TVEFSVF9G
VU5DX1JFVCk7DQogDQpAQCAtNDIyOCw2ICs0MjkyLDcgQEAgdm9pZCB1bnJlZ2lzdGVyX2Z0cmFj
ZV9ncmFwaCh2b2lkKQ0KIAlmdHJhY2VfZ3JhcGhfYWN0aXZlLS07DQogCWZ0cmFjZV9ncmFwaF9y
ZXR1cm4gPSAodHJhY2VfZnVuY19ncmFwaF9yZXRfdClmdHJhY2Vfc3R1YjsNCiAJZnRyYWNlX2dy
YXBoX2VudHJ5ID0gZnRyYWNlX2dyYXBoX2VudHJ5X3N0dWI7DQorCV9fZnRyYWNlX2dyYXBoX2Vu
dHJ5ID0gZnRyYWNlX2dyYXBoX2VudHJ5X3N0dWI7DQogCWZ0cmFjZV9zaHV0ZG93bigmZmdyYXBo
X29wcywgRlRSQUNFX1NUT1BfRlVOQ19SRVQpOw0KIAl1bnJlZ2lzdGVyX3BtX25vdGlmaWVyKCZm
dHJhY2Vfc3VzcGVuZF9ub3RpZmllcik7DQogCXVucmVnaXN0ZXJfdHJhY2Vfc2NoZWRfc3dpdGNo
KGZ0cmFjZV9ncmFwaF9wcm9iZV9zY2hlZF9zd2l0Y2gsIE5VTEwpOw0KZGlmZiAtLWdpdCBhL2tl
cm5lbC90cmFjZS9yaW5nX2J1ZmZlci5jIGIva2VybmVsL3RyYWNlL3JpbmdfYnVmZmVyLmMNCmlu
ZGV4IDZmZGM2MjkuLjY0OGYyNWEgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdHJhY2UvcmluZ19idWZm
ZXIuYw0KKysrIGIva2VybmVsL3RyYWNlL3JpbmdfYnVmZmVyLmMNCkBAIC0yMDQwLDYgKzIwNDAs
MTMgQEAgX19yYl9yZXNlcnZlX25leHQoc3RydWN0IHJpbmdfYnVmZmVyX3Blcl9jcHUgKmNwdV9i
dWZmZXIsDQogCXdyaXRlICY9IFJCX1dSSVRFX01BU0s7DQogCXRhaWwgPSB3cml0ZSAtIGxlbmd0
aDsNCiANCisJLyoNCisJICogSWYgdGhpcyBpcyB0aGUgZmlyc3QgY29tbWl0IG9uIHRoZSBwYWdl
LCB0aGVuIGl0IGhhcyB0aGUgc2FtZQ0KKwkgKiB0aW1lc3RhbXAgYXMgdGhlIHBhZ2UgaXRzZWxm
Lg0KKwkgKi8NCisJaWYgKCF0YWlsKQ0KKwkJZGVsdGEgPSAwOw0KKw0KIAkvKiBTZWUgaWYgd2Ug
c2hvdCBwYXNzIHRoZSBlbmQgb2YgdGhpcyBidWZmZXIgcGFnZSAqLw0KIAlpZiAodW5saWtlbHko
d3JpdGUgPiBCVUZfUEFHRV9TSVpFKSkNCiAJCXJldHVybiByYl9tb3ZlX3RhaWwoY3B1X2J1ZmZl
ciwgbGVuZ3RoLCB0YWlsLA0KZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHMu
YyBiL2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHMuYw0KaW5kZXggYzIxMmE3Zi4uODc1ZmVkNCAx
MDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHMuYw0KKysrIGIva2VybmVsL3Ry
YWNlL3RyYWNlX2V2ZW50cy5jDQpAQCAtMTM0NSw2ICsxMzQ1LDE2IEBAIHN0YXRpYyB2b2lkIHRy
YWNlX21vZHVsZV9hZGRfZXZlbnRzKHN0cnVjdCBtb2R1bGUgKm1vZCkNCiAJc3RydWN0IGZ0cmFj
ZV9tb2R1bGVfZmlsZV9vcHMgKmZpbGVfb3BzID0gTlVMTDsNCiAJc3RydWN0IGZ0cmFjZV9ldmVu
dF9jYWxsICoqY2FsbCwgKipzdGFydCwgKiplbmQ7DQogDQorCWlmICghbW9kLT5udW1fdHJhY2Vf
ZXZlbnRzKQ0KKwkJcmV0dXJuOw0KKw0KKwkvKiBEb24ndCBhZGQgaW5mcmFzdHJ1Y3R1cmUgZm9y
IG1vZHMgd2l0aG91dCB0cmFjZXBvaW50cyAqLw0KKwlpZiAodHJhY2VfbW9kdWxlX2hhc19iYWRf
dGFpbnQobW9kKSkgew0KKwkJcHJfZXJyKCIlczogbW9kdWxlIGhhcyBiYWQgdGFpbnQsIG5vdCBj
cmVhdGluZyB0cmFjZSBldmVudHNcbiIsDQorCQkgICAgICAgbW9kLT5uYW1lKTsNCisJCXJldHVy
bjsNCisJfQ0KKw0KIAlzdGFydCA9IG1vZC0+dHJhY2VfZXZlbnRzOw0KIAllbmQgPSBtb2QtPnRy
YWNlX2V2ZW50cyArIG1vZC0+bnVtX3RyYWNlX2V2ZW50czsNCiANCmRpZmYgLS1naXQgYS9rZXJu
ZWwvdHJhY2Vwb2ludC5jIGIva2VybmVsL3RyYWNlcG9pbnQuYw0KaW5kZXggZjE1MzlkZS4uNDFi
MjVhMCAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZXBvaW50LmMNCisrKyBiL2tlcm5lbC90cmFj
ZXBvaW50LmMNCkBAIC02MjgsNiArNjI4LDExIEBAIHZvaWQgdHJhY2Vwb2ludF9pdGVyX3Jlc2V0
KHN0cnVjdCB0cmFjZXBvaW50X2l0ZXIgKml0ZXIpDQogRVhQT1JUX1NZTUJPTF9HUEwodHJhY2Vw
b2ludF9pdGVyX3Jlc2V0KTsNCiANCiAjaWZkZWYgQ09ORklHX01PRFVMRVMNCitib29sIHRyYWNl
X21vZHVsZV9oYXNfYmFkX3RhaW50KHN0cnVjdCBtb2R1bGUgKm1vZCkNCit7DQorCXJldHVybiBt
b2QtPnRhaW50cyAmIH4oKDEgPDwgVEFJTlRfT09UX01PRFVMRSkgfCAoMSA8PCBUQUlOVF9DUkFQ
KSk7DQorfQ0KKw0KIHN0YXRpYyBpbnQgdHJhY2Vwb2ludF9tb2R1bGVfY29taW5nKHN0cnVjdCBt
b2R1bGUgKm1vZCkNCiB7DQogCXN0cnVjdCB0cF9tb2R1bGUgKnRwX21vZCwgKml0ZXI7DQpAQCAt
NjM4LDcgKzY0Myw3IEBAIHN0YXRpYyBpbnQgdHJhY2Vwb2ludF9tb2R1bGVfY29taW5nKHN0cnVj
dCBtb2R1bGUgKm1vZCkNCiAJICogbW9kdWxlIGhlYWRlcnMgKGZvciBmb3JjZWQgbG9hZCksIHRv
IG1ha2Ugc3VyZSB3ZSBkb24ndCBjYXVzZSBhIGNyYXNoLg0KIAkgKiBTdGFnaW5nIGFuZCBvdXQt
b2YtdHJlZSBHUEwgbW9kdWxlcyBhcmUgZmluZS4NCiAJICovDQotCWlmIChtb2QtPnRhaW50cyAm
IH4oKDEgPDwgVEFJTlRfT09UX01PRFVMRSkgfCAoMSA8PCBUQUlOVF9DUkFQKSkpDQorCWlmICh0
cmFjZV9tb2R1bGVfaGFzX2JhZF90YWludChtb2QpKQ0KIAkJcmV0dXJuIDA7DQogCW11dGV4X2xv
Y2soJnRyYWNlcG9pbnRzX211dGV4KTsNCiAJdHBfbW9kID0ga21hbGxvYyhzaXplb2Yoc3RydWN0
IHRwX21vZHVsZSksIEdGUF9LRVJORUwpOw0KZGlmZiAtLWdpdCBhL2tlcm5lbC93b3JrcXVldWUu
YyBiL2tlcm5lbC93b3JrcXVldWUuYw0KaW5kZXggMGJjOWZmMC4uNTYzODIwYyAxMDA2NDQNCi0t
LSBhL2tlcm5lbC93b3JrcXVldWUuYw0KKysrIGIva2VybmVsL3dvcmtxdWV1ZS5jDQpAQCAtMTQ3
NCwxMiArMTQ3NCwxOSBAQCBzdGF0aWMgdm9pZCBkZXN0cm95X3dvcmtlcihzdHJ1Y3Qgd29ya2Vy
ICp3b3JrZXIpDQogCWlmICh3b3JrZXItPmZsYWdzICYgV09SS0VSX0lETEUpDQogCQlnY3dxLT5u
cl9pZGxlLS07DQogDQorCS8qDQorCSAqIE9uY2UgV09SS0VSX0RJRSBpcyBzZXQsIHRoZSBrd29y
a2VyIG1heSBkZXN0cm95IGl0c2VsZiBhdCBhbnkNCisJICogcG9pbnQuICBQaW4gdG8gZW5zdXJl
IHRoZSB0YXNrIHN0YXlzIHVudGlsIHdlJ3JlIGRvbmUgd2l0aCBpdC4NCisJICovDQorCWdldF90
YXNrX3N0cnVjdCh3b3JrZXItPnRhc2spOw0KKw0KIAlsaXN0X2RlbF9pbml0KCZ3b3JrZXItPmVu
dHJ5KTsNCiAJd29ya2VyLT5mbGFncyB8PSBXT1JLRVJfRElFOw0KIA0KIAlzcGluX3VubG9ja19p
cnEoJmdjd3EtPmxvY2spOw0KIA0KIAlrdGhyZWFkX3N0b3Aod29ya2VyLT50YXNrKTsNCisJcHV0
X3Rhc2tfc3RydWN0KHdvcmtlci0+dGFzayk7DQogCWtmcmVlKHdvcmtlcik7DQogDQogCXNwaW5f
bG9ja19pcnEoJmdjd3EtPmxvY2spOw0KZGlmZiAtLWdpdCBhL2xpYi9NYWtlZmlsZSBiL2xpYi9N
YWtlZmlsZQ0KaW5kZXggYTRkYTI4My4uYzA2ZWZjYSAxMDA2NDQNCi0tLSBhL2xpYi9NYWtlZmls
ZQ0KKysrIGIvbGliL01ha2VmaWxlDQpAQCAtNDAsNiArNDAsNyBAQCBvYmotJChDT05GSUdfREVC
VUdfU1BJTkxPQ0spICs9IHNwaW5sb2NrX2RlYnVnLm8NCiBsaWItJChDT05GSUdfUldTRU1fR0VO
RVJJQ19TUElOTE9DSykgKz0gcndzZW0tc3BpbmxvY2subw0KIGxpYi0kKENPTkZJR19SV1NFTV9Y
Q0hHQUREX0FMR09SSVRITSkgKz0gcndzZW0ubw0KIA0KK0dDT1ZfUFJPRklMRV9od2VpZ2h0Lm8g
Oj0gbg0KIENGTEFHU19od2VpZ2h0Lm8gPSAkKHN1YnN0ICQocXVvdGUpLCwkKENPTkZJR19BUkNI
X0hXRUlHSFRfQ0ZMQUdTKSkNCiBvYmotJChDT05GSUdfR0VORVJJQ19IV0VJR0hUKSArPSBod2Vp
Z2h0Lm8NCiANCmRpZmYgLS1naXQgYS9tbS9vb21fa2lsbC5jIGIvbW0vb29tX2tpbGwuYw0KaW5k
ZXggMDY5YjY0ZS4uNGRkYTk0OCAxMDA2NDQNCi0tLSBhL21tL29vbV9raWxsLmMNCisrKyBiL21t
L29vbV9raWxsLmMNCkBAIC0yMTMsNyArMjEzLDcgQEAgdW5zaWduZWQgaW50IG9vbV9iYWRuZXNz
KHN0cnVjdCB0YXNrX3N0cnVjdCAqcCwgc3RydWN0IG1lbV9jZ3JvdXAgKm1lbSwNCiAJICogaW1w
bGVtZW50YXRpb24gdXNlZCBieSBMU01zLg0KIAkgKi8NCiAJaWYgKGhhc19jYXBhYmlsaXR5X25v
YXVkaXQocCwgQ0FQX1NZU19BRE1JTikpDQotCQlwb2ludHMgLT0gMzA7DQorCQlwb2ludHMgLT0g
KHBvaW50cyAqIDMpIC8gMTAwOw0KIA0KIAkvKg0KIAkgKiAvcHJvYy9waWQvb29tX3Njb3JlX2Fk
aiByYW5nZXMgZnJvbSAtMTAwMCB0byArMTAwMCBzdWNoIHRoYXQgaXQgbWF5DQpkaWZmIC0tZ2l0
IGEvbW0vcGFnZS13cml0ZWJhY2suYyBiL21tL3BhZ2Utd3JpdGViYWNrLmMNCmluZGV4IGVhM2Y4
M2IuLmI1Y2Q3OTYgMTAwNjQ0DQotLS0gYS9tbS9wYWdlLXdyaXRlYmFjay5jDQorKysgYi9tbS9w
YWdlLXdyaXRlYmFjay5jDQpAQCAtMTc3NiwxMSArMTc3NiwxMiBAQCBpbnQgX19zZXRfcGFnZV9k
aXJ0eV9ub2J1ZmZlcnMoc3RydWN0IHBhZ2UgKnBhZ2UpDQogCWlmICghVGVzdFNldFBhZ2VEaXJ0
eShwYWdlKSkgew0KIAkJc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcgPSBwYWdlX21hcHBp
bmcocGFnZSk7DQogCQlzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZzI7DQorCQl1bnNpZ25l
ZCBsb25nIGZsYWdzOw0KIA0KIAkJaWYgKCFtYXBwaW5nKQ0KIAkJCXJldHVybiAxOw0KIA0KLQkJ
c3Bpbl9sb2NrX2lycSgmbWFwcGluZy0+dHJlZV9sb2NrKTsNCisJCXNwaW5fbG9ja19pcnFzYXZl
KCZtYXBwaW5nLT50cmVlX2xvY2ssIGZsYWdzKTsNCiAJCW1hcHBpbmcyID0gcGFnZV9tYXBwaW5n
KHBhZ2UpOw0KIAkJaWYgKG1hcHBpbmcyKSB7IC8qIFJhY2Ugd2l0aCB0cnVuY2F0ZT8gKi8NCiAJ
CQlCVUdfT04obWFwcGluZzIgIT0gbWFwcGluZyk7DQpAQCAtMTc4OSw3ICsxNzkwLDcgQEAgaW50
IF9fc2V0X3BhZ2VfZGlydHlfbm9idWZmZXJzKHN0cnVjdCBwYWdlICpwYWdlKQ0KIAkJCXJhZGl4
X3RyZWVfdGFnX3NldCgmbWFwcGluZy0+cGFnZV90cmVlLA0KIAkJCQlwYWdlX2luZGV4KHBhZ2Up
LCBQQUdFQ0FDSEVfVEFHX0RJUlRZKTsNCiAJCX0NCi0JCXNwaW5fdW5sb2NrX2lycSgmbWFwcGlu
Zy0+dHJlZV9sb2NrKTsNCisJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm1hcHBpbmctPnRyZWVf
bG9jaywgZmxhZ3MpOw0KIAkJaWYgKG1hcHBpbmctPmhvc3QpIHsNCiAJCQkvKiAhUGFnZUFub24g
JiYgIXN3YXBwZXJfc3BhY2UgKi8NCiAJCQlfX21hcmtfaW5vZGVfZGlydHkobWFwcGluZy0+aG9z
dCwgSV9ESVJUWV9QQUdFUyk7DQpkaWZmIC0tZ2l0IGEvbW0vcm1hcC5jIGIvbW0vcm1hcC5jDQpp
bmRleCA4Njg1Njk3Li41MmEyZjM2IDEwMDY0NA0KLS0tIGEvbW0vcm1hcC5jDQorKysgYi9tbS9y
bWFwLmMNCkBAIC01ODEsNyArNTgxLDExIEBAIHB0ZV90ICpfX3BhZ2VfY2hlY2tfYWRkcmVzcyhz
dHJ1Y3QgcGFnZSAqcGFnZSwgc3RydWN0IG1tX3N0cnVjdCAqbW0sDQogCXNwaW5sb2NrX3QgKnB0
bDsNCiANCiAJaWYgKHVubGlrZWx5KFBhZ2VIdWdlKHBhZ2UpKSkgew0KKwkJLyogd2hlbiBwdWQg
aXMgbm90IHByZXNlbnQsIHB0ZSB3aWxsIGJlIE5VTEwgKi8NCiAJCXB0ZSA9IGh1Z2VfcHRlX29m
ZnNldChtbSwgYWRkcmVzcyk7DQorCQlpZiAoIXB0ZSkNCisJCQlyZXR1cm4gTlVMTDsNCisNCiAJ
CXB0bCA9ICZtbS0+cGFnZV90YWJsZV9sb2NrOw0KIAkJZ290byBjaGVjazsNCiAJfQ0KZGlmZiAt
LWdpdCBhL21tL3NsdWIuYyBiL21tL3NsdWIuYw0KaW5kZXggNTcxMDc4OC4uZmM3MTlmNyAxMDA2
NDQNCi0tLSBhL21tL3NsdWIuYw0KKysrIGIvbW0vc2x1Yi5jDQpAQCAtNDQ4Myw3ICs0NDgzLDEz
IEBAIHN0YXRpYyBzc2l6ZV90IHNob3dfc2xhYl9vYmplY3RzKHN0cnVjdCBrbWVtX2NhY2hlICpz
LA0KIAkJCXBhZ2UgPSBjLT5wYXJ0aWFsOw0KIA0KIAkJCWlmIChwYWdlKSB7DQotCQkJCXggPSBw
YWdlLT5wb2JqZWN0czsNCisJCQkJbm9kZSA9IHBhZ2VfdG9fbmlkKHBhZ2UpOw0KKwkJCQlpZiAo
ZmxhZ3MgJiBTT19UT1RBTCkNCisJCQkJCVdBUk5fT05fT05DRSgxKTsNCisJCQkJZWxzZSBpZiAo
ZmxhZ3MgJiBTT19PQkpFQ1RTKQ0KKwkJCQkJV0FSTl9PTl9PTkNFKDEpOw0KKwkJCQllbHNlDQor
CQkJCQl4ID0gcGFnZS0+cGFnZXM7DQogCQkJCXRvdGFsICs9IHg7DQogCQkJCW5vZGVzW25vZGVd
ICs9IHg7DQogCQkJfQ0KZGlmZiAtLWdpdCBhL21tL3N3YXBmaWxlLmMgYi9tbS9zd2FwZmlsZS5j
DQppbmRleCBmYWQxODMwLi5kYmQyYjY3IDEwMDY0NA0KLS0tIGEvbW0vc3dhcGZpbGUuYw0KKysr
IGIvbW0vc3dhcGZpbGUuYw0KQEAgLTE2NDksNyArMTY0OSw2IEBAIFNZU0NBTExfREVGSU5FMShz
d2Fwb2ZmLCBjb25zdCBjaGFyIF9fdXNlciAqLCBzcGVjaWFsZmlsZSkNCiAJcC0+bWF4ID0gMDsN
CiAJc3dhcF9tYXAgPSBwLT5zd2FwX21hcDsNCiAJcC0+c3dhcF9tYXAgPSBOVUxMOw0KLQlwLT5m
bGFncyA9IDA7DQogCXNwaW5fdW5sb2NrKCZzd2FwX2xvY2spOw0KIAltdXRleF91bmxvY2soJnN3
YXBvbl9tdXRleCk7DQogCXZmcmVlKHN3YXBfbWFwKTsNCkBAIC0xNjY3LDYgKzE2NjYsMTYgQEAg
U1lTQ0FMTF9ERUZJTkUxKHN3YXBvZmYsIGNvbnN0IGNoYXIgX191c2VyICosIHNwZWNpYWxmaWxl
KQ0KIAkJbXV0ZXhfdW5sb2NrKCZpbm9kZS0+aV9tdXRleCk7DQogCX0NCiAJZmlscF9jbG9zZShz
d2FwX2ZpbGUsIE5VTEwpOw0KKw0KKwkvKg0KKwkgKiBDbGVhciB0aGUgU1dQX1VTRUQgZmxhZyBh
ZnRlciBhbGwgcmVzb3VyY2VzIGFyZSBmcmVlZCBzbyB0aGF0IHN3YXBvbg0KKwkgKiBjYW4gcmV1
c2UgdGhpcyBzd2FwX2luZm8gaW4gYWxsb2Nfc3dhcF9pbmZvKCkgc2FmZWx5LiAgSXQgaXMgb2sg
dG8NCisJICogbm90IGhvbGQgcC0+bG9jayBhZnRlciB3ZSBjbGVhcmVkIGl0cyBTV1BfV1JJVEVP
Sy4NCisJICovDQorCXNwaW5fbG9jaygmc3dhcF9sb2NrKTsNCisJcC0+ZmxhZ3MgPSAwOw0KKwlz
cGluX3VubG9jaygmc3dhcF9sb2NrKTsNCisNCiAJZXJyID0gMDsNCiAJYXRvbWljX2luYygmcHJv
Y19wb2xsX2V2ZW50KTsNCiAJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZwcm9jX3BvbGxfd2FpdCk7
DQpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZmliX3J1bGVzLmMgYi9uZXQvY29yZS9maWJfcnVsZXMu
Yw0KaW5kZXggYzBjMjFiMS4uNmFmNTRmMiAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL2ZpYl9ydWxl
cy5jDQorKysgYi9uZXQvY29yZS9maWJfcnVsZXMuYw0KQEAgLTcxOCw2ICs3MTgsMTMgQEAgc3Rh
dGljIGludCBmaWJfcnVsZXNfZXZlbnQoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICp0aGlzLCB1bnNp
Z25lZCBsb25nIGV2ZW50LA0KIAkJCWF0dGFjaF9ydWxlcygmb3BzLT5ydWxlc19saXN0LCBkZXYp
Ow0KIAkJYnJlYWs7DQogDQorCWNhc2UgTkVUREVWX0NIQU5HRU5BTUU6DQorCQlsaXN0X2Zvcl9l
YWNoX2VudHJ5KG9wcywgJm5ldC0+cnVsZXNfb3BzLCBsaXN0KSB7DQorCQkJZGV0YWNoX3J1bGVz
KCZvcHMtPnJ1bGVzX2xpc3QsIGRldik7DQorCQkJYXR0YWNoX3J1bGVzKCZvcHMtPnJ1bGVzX2xp
c3QsIGRldik7DQorCQl9DQorCQlicmVhazsNCisNCiAJY2FzZSBORVRERVZfVU5SRUdJU1RFUjoN
CiAJCWxpc3RfZm9yX2VhY2hfZW50cnkob3BzLCAmbmV0LT5ydWxlc19vcHMsIGxpc3QpDQogCQkJ
ZGV0YWNoX3J1bGVzKCZvcHMtPnJ1bGVzX2xpc3QsIGRldik7DQpkaWZmIC0tZ2l0IGEvbmV0L2Nv
cmUvc2tidWZmLmMgYi9uZXQvY29yZS9za2J1ZmYuYw0KaW5kZXggYWY5YzNjNi4uNWQ2Y2I1NCAx
MDA2NDQNCi0tLSBhL25ldC9jb3JlL3NrYnVmZi5jDQorKysgYi9uZXQvY29yZS9za2J1ZmYuYw0K
QEAgLTc0LDM2ICs3NCw2IEBADQogc3RhdGljIHN0cnVjdCBrbWVtX2NhY2hlICpza2J1ZmZfaGVh
ZF9jYWNoZSBfX3JlYWRfbW9zdGx5Ow0KIHN0YXRpYyBzdHJ1Y3Qga21lbV9jYWNoZSAqc2tidWZm
X2ZjbG9uZV9jYWNoZSBfX3JlYWRfbW9zdGx5Ow0KIA0KLXN0YXRpYyB2b2lkIHNvY2tfcGlwZV9i
dWZfcmVsZWFzZShzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvICpwaXBlLA0KLQkJCQkgIHN0cnVjdCBw
aXBlX2J1ZmZlciAqYnVmKQ0KLXsNCi0JcHV0X3BhZ2UoYnVmLT5wYWdlKTsNCi19DQotDQotc3Rh
dGljIHZvaWQgc29ja19waXBlX2J1Zl9nZXQoc3RydWN0IHBpcGVfaW5vZGVfaW5mbyAqcGlwZSwN
Ci0JCQkJc3RydWN0IHBpcGVfYnVmZmVyICpidWYpDQotew0KLQlnZXRfcGFnZShidWYtPnBhZ2Up
Ow0KLX0NCi0NCi1zdGF0aWMgaW50IHNvY2tfcGlwZV9idWZfc3RlYWwoc3RydWN0IHBpcGVfaW5v
ZGVfaW5mbyAqcGlwZSwNCi0JCQkgICAgICAgc3RydWN0IHBpcGVfYnVmZmVyICpidWYpDQotew0K
LQlyZXR1cm4gMTsNCi19DQotDQotDQotLyogUGlwZSBidWZmZXIgb3BlcmF0aW9ucyBmb3IgYSBz
b2NrZXQuICovDQotc3RhdGljIGNvbnN0IHN0cnVjdCBwaXBlX2J1Zl9vcGVyYXRpb25zIHNvY2tf
cGlwZV9idWZfb3BzID0gew0KLQkuY2FuX21lcmdlID0gMCwNCi0JLm1hcCA9IGdlbmVyaWNfcGlw
ZV9idWZfbWFwLA0KLQkudW5tYXAgPSBnZW5lcmljX3BpcGVfYnVmX3VubWFwLA0KLQkuY29uZmly
bSA9IGdlbmVyaWNfcGlwZV9idWZfY29uZmlybSwNCi0JLnJlbGVhc2UgPSBzb2NrX3BpcGVfYnVm
X3JlbGVhc2UsDQotCS5zdGVhbCA9IHNvY2tfcGlwZV9idWZfc3RlYWwsDQotCS5nZXQgPSBzb2Nr
X3BpcGVfYnVmX2dldCwNCi19Ow0KLQ0KIC8qDQogICoJS2VlcCBvdXQtb2YtbGluZSB0byBwcmV2
ZW50IGtlcm5lbCBibG9hdC4NCiAgKglfX2J1aWx0aW5fcmV0dXJuX2FkZHJlc3MgaXMgbm90IHVz
ZWQgYmVjYXVzZSBpdCBpcyBub3QgYWx3YXlzDQpAQCAtMTY2NSw3ICsxNjM1LDcgQEAgaW50IHNr
Yl9zcGxpY2VfYml0cyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1bnNpZ25lZCBpbnQgb2Zmc2V0LA0K
IAkJLnBhcnRpYWwgPSBwYXJ0aWFsLA0KIAkJLm5yX3BhZ2VzX21heCA9IE1BWF9TS0JfRlJBR1Ms
DQogCQkuZmxhZ3MgPSBmbGFncywNCi0JCS5vcHMgPSAmc29ja19waXBlX2J1Zl9vcHMsDQorCQku
b3BzID0gJm5vc3RlYWxfcGlwZV9idWZfb3BzLA0KIAkJLnNwZF9yZWxlYXNlID0gc29ja19zcGRf
cmVsZWFzZSwNCiAJfTsNCiAJc3RydWN0IHNrX2J1ZmYgKmZyYWdfaXRlcjsNCmRpZmYgLS1naXQg
YS9uZXQvbWFjODAyMTEvc3RhX2luZm8uYyBiL25ldC9tYWM4MDIxMS9zdGFfaW5mby5jDQppbmRl
eCA0ODg2MDBjLi4xOTE0ZjVhIDEwMDY0NA0KLS0tIGEvbmV0L21hYzgwMjExL3N0YV9pbmZvLmMN
CisrKyBiL25ldC9tYWM4MDIxMS9zdGFfaW5mby5jDQpAQCAtMjkyLDYgKzI5Miw3IEBAIHN0cnVj
dCBzdGFfaW5mbyAqc3RhX2luZm9fYWxsb2Moc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAq
c2RhdGEsDQogCQlyZXR1cm4gTlVMTDsNCiANCiAJc3Bpbl9sb2NrX2luaXQoJnN0YS0+bG9jayk7
DQorCXNwaW5fbG9ja19pbml0KCZzdGEtPnBzX2xvY2spOw0KIAlJTklUX1dPUksoJnN0YS0+ZHJ2
X3VuYmxvY2tfd2ssIHN0YV91bmJsb2NrKTsNCiAJSU5JVF9XT1JLKCZzdGEtPmFtcGR1X21sbWUu
d29yaywgaWVlZTgwMjExX2JhX3Nlc3Npb25fd29yayk7DQogCW11dGV4X2luaXQoJnN0YS0+YW1w
ZHVfbWxtZS5tdHgpOw0KQEAgLTExNDEsNiArMTE0Miw4IEBAIHZvaWQgaWVlZTgwMjExX3N0YV9w
c19kZWxpdmVyX3dha2V1cChzdHJ1Y3Qgc3RhX2luZm8gKnN0YSkNCiANCiAJc2tiX3F1ZXVlX2hl
YWRfaW5pdCgmcGVuZGluZyk7DQogDQorCS8qIHN5bmMgd2l0aCBpZWVlODAyMTFfdHhfaF91bmlj
YXN0X3BzX2J1ZiAqLw0KKwlzcGluX2xvY2soJnN0YS0+cHNfbG9jayk7DQogCS8qIFNlbmQgYWxs
IGJ1ZmZlcmVkIGZyYW1lcyB0byB0aGUgc3RhdGlvbiAqLw0KIAlmb3IgKGFjID0gMDsgYWMgPCBJ
RUVFODAyMTFfTlVNX0FDUzsgYWMrKykgew0KIAkJaW50IGNvdW50ID0gc2tiX3F1ZXVlX2xlbigm
cGVuZGluZyksIHRtcDsNCkBAIC0xMTYwLDYgKzExNjMsNyBAQCB2b2lkIGllZWU4MDIxMV9zdGFf
cHNfZGVsaXZlcl93YWtldXAoc3RydWN0IHN0YV9pbmZvICpzdGEpDQogCX0NCiANCiAJaWVlZTgw
MjExX2FkZF9wZW5kaW5nX3NrYnNfZm4obG9jYWwsICZwZW5kaW5nLCBjbGVhcl9zdGFfcHNfZmxh
Z3MsIHN0YSk7DQorCXNwaW5fdW5sb2NrKCZzdGEtPnBzX2xvY2spOw0KIA0KIAlsb2NhbC0+dG90
YWxfcHNfYnVmZmVyZWQgLT0gYnVmZmVyZWQ7DQogDQpAQCAtMTIwNyw2ICsxMjExLDcgQEAgc3Rh
dGljIHZvaWQgaWVlZTgwMjExX3NlbmRfbnVsbF9yZXNwb25zZShzdHJ1Y3QgaWVlZTgwMjExX3N1
Yl9pZl9kYXRhICpzZGF0YSwNCiAJbWVtY3B5KG51bGxmdW5jLT5hZGRyMSwgc3RhLT5zdGEuYWRk
ciwgRVRIX0FMRU4pOw0KIAltZW1jcHkobnVsbGZ1bmMtPmFkZHIyLCBzZGF0YS0+dmlmLmFkZHIs
IEVUSF9BTEVOKTsNCiAJbWVtY3B5KG51bGxmdW5jLT5hZGRyMywgc2RhdGEtPnZpZi5hZGRyLCBF
VEhfQUxFTik7DQorCW51bGxmdW5jLT5zZXFfY3RybCA9IDA7DQogDQogCXNrYi0+cHJpb3JpdHkg
PSB0aWQ7DQogCXNrYl9zZXRfcXVldWVfbWFwcGluZyhza2IsIGllZWU4MDJfMWRfdG9fYWNbdGlk
XSk7DQpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL3N0YV9pbmZvLmggYi9uZXQvbWFjODAyMTEv
c3RhX2luZm8uaA0KaW5kZXggOGM4Y2UwNS4uYTY4MTU1ZiAxMDA2NDQNCi0tLSBhL25ldC9tYWM4
MDIxMS9zdGFfaW5mby5oDQorKysgYi9uZXQvbWFjODAyMTEvc3RhX2luZm8uaA0KQEAgLTIxNiw2
ICsyMTYsNyBAQCBzdHJ1Y3Qgc3RhX2FtcGR1X21sbWUgew0KICAqIEBkcnZfdW5ibG9ja193azog
dXNlZCBmb3IgZHJpdmVyIFBTIHVuYmxvY2tpbmcNCiAgKiBAbGlzdGVuX2ludGVydmFsOiBsaXN0
ZW4gaW50ZXJ2YWwgb2YgdGhpcyBzdGF0aW9uLCB3aGVuIHdlJ3JlIGFjdGluZyBhcyBBUA0KICAq
IEBfZmxhZ3M6IFNUQSBmbGFncywgc2VlICZlbnVtIGllZWU4MDIxMV9zdGFfaW5mb19mbGFncywg
ZG8gbm90IHVzZSBkaXJlY3RseQ0KKyAqIEBwc19sb2NrOiB1c2VkIGZvciBwb3dlcnNhdmUgKHdo
ZW4gbWFjODAyMTEgaXMgdGhlIEFQKSByZWxhdGVkIGxvY2tpbmcNCiAgKiBAcHNfdHhfYnVmOiBi
dWZmZXJzIChwZXIgQUMpIG9mIGZyYW1lcyB0byB0cmFuc21pdCB0byB0aGlzIHN0YXRpb24NCiAg
Kgl3aGVuIGl0IGxlYXZlcyBwb3dlciBzYXZpbmcgc3RhdGUgb3IgcG9sbHMNCiAgKiBAdHhfZmls
dGVyZWQ6IGJ1ZmZlcnMgKHBlciBBQykgb2YgZnJhbWVzIHdlIGFscmVhZHkgdHJpZWQgdG8NCkBA
IC0yODQsMTAgKzI4NSw4IEBAIHN0cnVjdCBzdGFfaW5mbyB7DQogCS8qIHVzZSB0aGUgYWNjZXNz
b3JzIGRlZmluZWQgYmVsb3cgKi8NCiAJdW5zaWduZWQgbG9uZyBfZmxhZ3M7DQogDQotCS8qDQot
CSAqIFNUQSBwb3dlcnNhdmUgZnJhbWUgcXVldWVzLCBubyBtb3JlIHRoYW4gdGhlIGludGVybmFs
DQotCSAqIGxvY2tpbmcgcmVxdWlyZWQuDQotCSAqLw0KKwkvKiBTVEEgcG93ZXJzYXZlIGxvY2sg
YW5kIGZyYW1lIHF1ZXVlcyAqLw0KKwlzcGlubG9ja190IHBzX2xvY2s7DQogCXN0cnVjdCBza19i
dWZmX2hlYWQgcHNfdHhfYnVmW0lFRUU4MDIxMV9OVU1fQUNTXTsNCiAJc3RydWN0IHNrX2J1ZmZf
aGVhZCB0eF9maWx0ZXJlZFtJRUVFODAyMTFfTlVNX0FDU107DQogCXVuc2lnbmVkIGxvbmcgZHJp
dmVyX2J1ZmZlcmVkX3RpZHM7DQpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL3R4LmMgYi9uZXQv
bWFjODAyMTEvdHguYw0KaW5kZXggNGZmMzViZi4uMjViYmIyZSAxMDA2NDQNCi0tLSBhL25ldC9t
YWM4MDIxMS90eC5jDQorKysgYi9uZXQvbWFjODAyMTEvdHguYw0KQEAgLTQ2NCw2ICs0NjQsMjAg
QEAgaWVlZTgwMjExX3R4X2hfdW5pY2FzdF9wc19idWYoc3RydWN0IGllZWU4MDIxMV90eF9kYXRh
ICp0eCkNCiAjZW5kaWYgLyogQ09ORklHX01BQzgwMjExX1ZFUkJPU0VfUFNfREVCVUcgKi8NCiAJ
CWlmICh0eC0+bG9jYWwtPnRvdGFsX3BzX2J1ZmZlcmVkID49IFRPVEFMX01BWF9UWF9CVUZGRVIp
DQogCQkJcHVyZ2Vfb2xkX3BzX2J1ZmZlcnModHgtPmxvY2FsKTsNCisNCisJCS8qIHN5bmMgd2l0
aCBpZWVlODAyMTFfc3RhX3BzX2RlbGl2ZXJfd2FrZXVwICovDQorCQlzcGluX2xvY2soJnN0YS0+
cHNfbG9jayk7DQorCQkvKg0KKwkJICogU1RBIHdva2UgdXAgdGhlIG1lYW50aW1lIGFuZCBhbGwg
dGhlIGZyYW1lcyBvbiBwc190eF9idWYgaGF2ZQ0KKwkJICogYmVlbiBxdWV1ZWQgdG8gcGVuZGlu
ZyBxdWV1ZS4gTm8gcmVvcmRlcmluZyBjYW4gaGFwcGVuLCBnbw0KKwkJICogYWhlYWQgYW5kIFR4
IHRoZSBwYWNrZXQuDQorCQkgKi8NCisJCWlmICghdGVzdF9zdGFfZmxhZyhzdGEsIFdMQU5fU1RB
X1BTX1NUQSkgJiYNCisJCSAgICAhdGVzdF9zdGFfZmxhZyhzdGEsIFdMQU5fU1RBX1BTX0RSSVZF
UikpIHsNCisJCQlzcGluX3VubG9jaygmc3RhLT5wc19sb2NrKTsNCisJCQlyZXR1cm4gVFhfQ09O
VElOVUU7DQorCQl9DQorDQogCQlpZiAoc2tiX3F1ZXVlX2xlbigmc3RhLT5wc190eF9idWZbYWNd
KSA+PSBTVEFfTUFYX1RYX0JVRkZFUikgew0KIAkJCXN0cnVjdCBza19idWZmICpvbGQgPSBza2Jf
ZGVxdWV1ZSgmc3RhLT5wc190eF9idWZbYWNdKTsNCiAjaWZkZWYgQ09ORklHX01BQzgwMjExX1ZF
UkJPU0VfUFNfREVCVUcNCkBAIC00ODAsNiArNDk0LDcgQEAgaWVlZTgwMjExX3R4X2hfdW5pY2Fz
dF9wc19idWYoc3RydWN0IGllZWU4MDIxMV90eF9kYXRhICp0eCkNCiAJCWluZm8tPmNvbnRyb2wu
dmlmID0gJnR4LT5zZGF0YS0+dmlmOw0KIAkJaW5mby0+ZmxhZ3MgfD0gSUVFRTgwMjExX1RYX0lO
VEZMX05FRURfVFhQUk9DRVNTSU5HOw0KIAkJc2tiX3F1ZXVlX3RhaWwoJnN0YS0+cHNfdHhfYnVm
W2FjXSwgdHgtPnNrYik7DQorCQlzcGluX3VubG9jaygmc3RhLT5wc19sb2NrKTsNCiANCiAJCWlm
ICghdGltZXJfcGVuZGluZygmbG9jYWwtPnN0YV9jbGVhbnVwKSkNCiAJCQltb2RfdGltZXIoJmxv
Y2FsLT5zdGFfY2xlYW51cCwNCkBAIC04ODQsNyArODk5LDcgQEAgc3RhdGljIGludCBpZWVlODAy
MTFfZnJhZ21lbnQoc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9jYWwsDQogCQlwb3MgKz0gZnJh
Z2xlbjsNCiAJfQ0KIA0KLQlza2ItPmxlbiA9IGhkcmxlbiArIHBlcl9mcmFnbTsNCisJc2tiX3Ry
aW0oc2tiLCBoZHJsZW4gKyBwZXJfZnJhZ20pOw0KIAlyZXR1cm4gMDsNCiB9DQogDQpkaWZmIC0t
Z2l0IGEvbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMgYi9uZXQvc2N0cC9zbV9zdGF0ZWZ1bnMuYw0K
aW5kZXggY2IxYzQzMC4uZjEzMWNhZiAxMDA2NDQNCi0tLSBhL25ldC9zY3RwL3NtX3N0YXRlZnVu
cy5jDQorKysgYi9uZXQvc2N0cC9zbV9zdGF0ZWZ1bnMuYw0KQEAgLTc0Nyw2ICs3NDcsMTMgQEAg
c2N0cF9kaXNwb3NpdGlvbl90IHNjdHBfc2ZfZG9fNV8xRF9jZShjb25zdCBzdHJ1Y3Qgc2N0cF9l
bmRwb2ludCAqZXAsDQogCQlzdHJ1Y3Qgc2N0cF9jaHVuayBhdXRoOw0KIAkJc2N0cF9pZXJyb3Jf
dCByZXQ7DQogDQorCQkvKiBNYWtlIHN1cmUgdGhhdCB3ZSBhbmQgdGhlIHBlZXIgYXJlIEFVVEgg
Y2FwYWJsZSAqLw0KKwkJaWYgKCFzY3RwX2F1dGhfZW5hYmxlIHx8ICFuZXdfYXNvYy0+cGVlci5h
dXRoX2NhcGFibGUpIHsNCisJCQlrZnJlZV9za2IoY2h1bmstPmF1dGhfY2h1bmspOw0KKwkJCXNj
dHBfYXNzb2NpYXRpb25fZnJlZShuZXdfYXNvYyk7DQorCQkJcmV0dXJuIHNjdHBfc2ZfcGRpc2Nh
cmQoZXAsIGFzb2MsIHR5cGUsIGFyZywgY29tbWFuZHMpOw0KKwkJfQ0KKw0KIAkJLyogc2V0LXVw
IG91ciBmYWtlIGNodW5rIHNvIHRoYXQgd2UgY2FuIHByb2Nlc3MgaXQgKi8NCiAJCWF1dGguc2ti
ID0gY2h1bmstPmF1dGhfY2h1bms7DQogCQlhdXRoLmFzb2MgPSBjaHVuay0+YXNvYzsNCmRpZmYg
LS1naXQgYS9uZXQvc2N0cC9zb2NrZXQuYyBiL25ldC9zY3RwL3NvY2tldC5jDQppbmRleCBjNTNk
MDFlLi5jMjhlYjdiIDEwMDY0NA0KLS0tIGEvbmV0L3NjdHAvc29ja2V0LmMNCisrKyBiL25ldC9z
Y3RwL3NvY2tldC5jDQpAQCAtNzAsNiArNzAsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+
DQogI2luY2x1ZGUgPGxpbnV4L2NyeXB0by5oPg0KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQor
I2luY2x1ZGUgPGxpbnV4L2NvbXBhdC5oPg0KIA0KICNpbmNsdWRlIDxuZXQvaXAuaD4NCiAjaW5j
bHVkZSA8bmV0L2ljbXAuaD4NCkBAIC0xMzc2LDExICsxMzc3LDE5IEBAIFNDVFBfU1RBVElDIGlu
dCBzY3RwX3NldHNvY2tvcHRfY29ubmVjdHgoc3RydWN0IHNvY2sqIHNrLA0KIC8qDQogICogTmV3
IChob3BlZnVsbHkgZmluYWwpIGludGVyZmFjZSBmb3IgdGhlIEFQSS4NCiAgKiBXZSB1c2UgdGhl
IHNjdHBfZ2V0YWRkcnNfb2xkIHN0cnVjdHVyZSBzbyB0aGF0IHVzZS1zcGFjZSBsaWJyYXJ5DQot
ICogY2FuIGF2b2lkIGFueSB1bm5lY2Vzc2FyeSBhbGxvY2F0aW9ucy4gICBUaGUgb25seSBkZWZm
ZXJlbnQgcGFydA0KKyAqIGNhbiBhdm9pZCBhbnkgdW5uZWNlc3NhcnkgYWxsb2NhdGlvbnMuIFRo
ZSBvbmx5IGRpZmZlcmVudCBwYXJ0DQogICogaXMgdGhhdCB3ZSBzdG9yZSB0aGUgYWN0dWFsIGxl
bmd0aCBvZiB0aGUgYWRkcmVzcyBidWZmZXIgaW50byB0aGUNCi0gKiBhZGRyc19udW0gc3RydWN0
dXJlIG1lbWJlci4gIFRoYXQgd2F5IHdlIGNhbiByZS11c2UgdGhlIGV4aXN0aW5nDQorICogYWRk
cnNfbnVtIHN0cnVjdHVyZSBtZW1iZXIuIFRoYXQgd2F5IHdlIGNhbiByZS11c2UgdGhlIGV4aXN0
aW5nDQogICogY29kZS4NCiAgKi8NCisjaWZkZWYgQ09ORklHX0NPTVBBVA0KK3N0cnVjdCBjb21w
YXRfc2N0cF9nZXRhZGRyc19vbGQgew0KKwlzY3RwX2Fzc29jX3QJYXNzb2NfaWQ7DQorCXMzMgkJ
YWRkcl9udW07DQorCWNvbXBhdF91cHRyX3QJYWRkcnM7CQkvKiBzdHJ1Y3Qgc29ja2FkZHIgKiAq
Lw0KK307DQorI2VuZGlmDQorDQogU0NUUF9TVEFUSUMgaW50IHNjdHBfZ2V0c29ja29wdF9jb25u
ZWN0eDMoc3RydWN0IHNvY2sqIHNrLCBpbnQgbGVuLA0KIAkJCQkJY2hhciBfX3VzZXIgKm9wdHZh
bCwNCiAJCQkJCWludCBfX3VzZXIgKm9wdGxlbikNCkBAIC0xMzg5LDE2ICsxMzk4LDMwIEBAIFND
VFBfU1RBVElDIGludCBzY3RwX2dldHNvY2tvcHRfY29ubmVjdHgzKHN0cnVjdCBzb2NrKiBzaywg
aW50IGxlbiwNCiAJc2N0cF9hc3NvY190IGFzc29jX2lkID0gMDsNCiAJaW50IGVyciA9IDA7DQog
DQotCWlmIChsZW4gPCBzaXplb2YocGFyYW0pKQ0KLQkJcmV0dXJuIC1FSU5WQUw7DQorI2lmZGVm
IENPTkZJR19DT01QQVQNCisJaWYgKGlzX2NvbXBhdF90YXNrKCkpIHsNCisJCXN0cnVjdCBjb21w
YXRfc2N0cF9nZXRhZGRyc19vbGQgcGFyYW0zMjsNCiANCi0JaWYgKGNvcHlfZnJvbV91c2VyKCZw
YXJhbSwgb3B0dmFsLCBzaXplb2YocGFyYW0pKSkNCi0JCXJldHVybiAtRUZBVUxUOw0KKwkJaWYg
KGxlbiA8IHNpemVvZihwYXJhbTMyKSkNCisJCQlyZXR1cm4gLUVJTlZBTDsNCisJCWlmIChjb3B5
X2Zyb21fdXNlcigmcGFyYW0zMiwgb3B0dmFsLCBzaXplb2YocGFyYW0zMikpKQ0KKwkJCXJldHVy
biAtRUZBVUxUOw0KIA0KLQllcnIgPSBfX3NjdHBfc2V0c29ja29wdF9jb25uZWN0eChzaywNCi0J
CQkoc3RydWN0IHNvY2thZGRyIF9fdXNlciAqKXBhcmFtLmFkZHJzLA0KLQkJCXBhcmFtLmFkZHJf
bnVtLCAmYXNzb2NfaWQpOw0KKwkJcGFyYW0uYXNzb2NfaWQgPSBwYXJhbTMyLmFzc29jX2lkOw0K
KwkJcGFyYW0uYWRkcl9udW0gPSBwYXJhbTMyLmFkZHJfbnVtOw0KKwkJcGFyYW0uYWRkcnMgPSBj
b21wYXRfcHRyKHBhcmFtMzIuYWRkcnMpOw0KKwl9IGVsc2UNCisjZW5kaWYNCisJew0KKwkJaWYg
KGxlbiA8IHNpemVvZihwYXJhbSkpDQorCQkJcmV0dXJuIC1FSU5WQUw7DQorCQlpZiAoY29weV9m
cm9tX3VzZXIoJnBhcmFtLCBvcHR2YWwsIHNpemVvZihwYXJhbSkpKQ0KKwkJCXJldHVybiAtRUZB
VUxUOw0KKwl9DQogDQorCWVyciA9IF9fc2N0cF9zZXRzb2Nrb3B0X2Nvbm5lY3R4KHNrLCAoc3Ry
dWN0IHNvY2thZGRyIF9fdXNlciAqKQ0KKwkJCQkJIHBhcmFtLmFkZHJzLCBwYXJhbS5hZGRyX251
bSwNCisJCQkJCSAmYXNzb2NfaWQpOw0KIAlpZiAoZXJyID09IDAgfHwgZXJyID09IC1FSU5QUk9H
UkVTUykgew0KIAkJaWYgKGNvcHlfdG9fdXNlcihvcHR2YWwsICZhc3NvY19pZCwgc2l6ZW9mKGFz
c29jX2lkKSkpDQogCQkJcmV0dXJuIC1FRkFVTFQ7DQpkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy9j
bG50LmMgYi9uZXQvc3VucnBjL2NsbnQuYw0KaW5kZXggYjIyNTBkYS4uYTBlNTVlNSAxMDA2NDQN
Ci0tLSBhL25ldC9zdW5ycGMvY2xudC5jDQorKysgYi9uZXQvc3VucnBjL2NsbnQuYw0KQEAgLTEw
MDIsOSArMTAwMiwxMyBAQCBjYWxsX3JlZnJlc2hyZXN1bHQoc3RydWN0IHJwY190YXNrICp0YXNr
KQ0KIAl0YXNrLT50a19hY3Rpb24gPSBjYWxsX3JlZnJlc2g7DQogCXN3aXRjaCAoc3RhdHVzKSB7
DQogCWNhc2UgMDoNCi0JCWlmIChycGNhdXRoX3VwdG9kYXRlY3JlZCh0YXNrKSkNCisJCWlmIChy
cGNhdXRoX3VwdG9kYXRlY3JlZCh0YXNrKSkgew0KIAkJCXRhc2stPnRrX2FjdGlvbiA9IGNhbGxf
YWxsb2NhdGU7DQotCQlyZXR1cm47DQorCQkJcmV0dXJuOw0KKwkJfQ0KKwkJLyogVXNlIHJhdGUt
bGltaXRpbmcgYW5kIGEgbWF4IG51bWJlciBvZiByZXRyaWVzIGlmIHJlZnJlc2gNCisJCSAqIGhh
ZCBzdGF0dXMgMCBidXQgZmFpbGVkIHRvIHVwZGF0ZSB0aGUgY3JlZC4NCisJCSAqLw0KIAljYXNl
IC1FVElNRURPVVQ6DQogCQlycGNfZGVsYXkodGFzaywgMypIWik7DQogCWNhc2UgLUVBR0FJTjoN
CmRpZmYgLS1naXQgYS9uZXQvc3VucnBjL3hwcnRzb2NrLmMgYi9uZXQvc3VucnBjL3hwcnRzb2Nr
LmMNCmluZGV4IGJmYjc4ZmEuLmQ3N2E0ZjAgMTAwNjQ0DQotLS0gYS9uZXQvc3VucnBjL3hwcnRz
b2NrLmMNCisrKyBiL25ldC9zdW5ycGMveHBydHNvY2suYw0KQEAgLTUwMSw2ICs1MDEsNyBAQCBz
dGF0aWMgaW50IHhzX25vc3BhY2Uoc3RydWN0IHJwY190YXNrICp0YXNrKQ0KIAlzdHJ1Y3QgcnBj
X3Jxc3QgKnJlcSA9IHRhc2stPnRrX3Jxc3RwOw0KIAlzdHJ1Y3QgcnBjX3hwcnQgKnhwcnQgPSBy
ZXEtPnJxX3hwcnQ7DQogCXN0cnVjdCBzb2NrX3hwcnQgKnRyYW5zcG9ydCA9IGNvbnRhaW5lcl9v
Zih4cHJ0LCBzdHJ1Y3Qgc29ja194cHJ0LCB4cHJ0KTsNCisJc3RydWN0IHNvY2sgKnNrID0gdHJh
bnNwb3J0LT5pbmV0Ow0KIAlpbnQgcmV0ID0gLUVBR0FJTjsNCiANCiAJZHByaW50aygiUlBDOiAl
NXUgeG1pdCBpbmNvbXBsZXRlICgldSBsZWZ0IG9mICV1KVxuIiwNCkBAIC01MTgsNyArNTE5LDcg
QEAgc3RhdGljIGludCB4c19ub3NwYWNlKHN0cnVjdCBycGNfdGFzayAqdGFzaykNCiAJCQkgKiB3
aW5kb3cgc2l6ZQ0KIAkJCSAqLw0KIAkJCXNldF9iaXQoU09DS19OT1NQQUNFLCAmdHJhbnNwb3J0
LT5zb2NrLT5mbGFncyk7DQotCQkJdHJhbnNwb3J0LT5pbmV0LT5za193cml0ZV9wZW5kaW5nKys7
DQorCQkJc2stPnNrX3dyaXRlX3BlbmRpbmcrKzsNCiAJCQkvKiAuLi5hbmQgd2FpdCBmb3IgbW9y
ZSBidWZmZXIgc3BhY2UgKi8NCiAJCQl4cHJ0X3dhaXRfZm9yX2J1ZmZlcl9zcGFjZSh0YXNrLCB4
c19ub3NwYWNlX2NhbGxiYWNrKTsNCiAJCX0NCkBAIC01MjgsNiArNTI5LDkgQEAgc3RhdGljIGlu
dCB4c19ub3NwYWNlKHN0cnVjdCBycGNfdGFzayAqdGFzaykNCiAJfQ0KIA0KIAlzcGluX3VubG9j
a19iaCgmeHBydC0+dHJhbnNwb3J0X2xvY2spOw0KKw0KKwkvKiBSYWNlIGJyZWFrZXIgaW4gY2Fz
ZSBtZW1vcnkgaXMgZnJlZWQgYmVmb3JlIGFib3ZlIGNvZGUgaXMgY2FsbGVkICovDQorCXNrLT5z
a193cml0ZV9zcGFjZShzayk7DQogCXJldHVybiByZXQ7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL25l
dC91bml4L2FmX3VuaXguYyBiL25ldC91bml4L2FmX3VuaXguYw0KaW5kZXggZWRkZmRlYy4uNTRm
YzkwYiAxMDA2NDQNCi0tLSBhL25ldC91bml4L2FmX3VuaXguYw0KKysrIGIvbmV0L3VuaXgvYWZf
dW5peC5jDQpAQCAtMTQ5LDggKzE0OSw4IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB1bml4X3NldF9z
ZWNkYXRhKHN0cnVjdCBzY21fY29va2llICpzY20sIHN0cnVjdCBza19idWZmICpza2IpDQogDQog
c3RhdGljIGlubGluZSB1bnNpZ25lZCB1bml4X2hhc2hfZm9sZChfX3dzdW0gbikNCiB7DQotCXVu
c2lnbmVkIGhhc2ggPSAoX19mb3JjZSB1bnNpZ25lZCluOw0KLQloYXNoIF49IGhhc2g+PjE2Ow0K
Kwl1bnNpZ25lZCBpbnQgaGFzaCA9IChfX2ZvcmNlIHVuc2lnbmVkIGludCljc3VtX2ZvbGQobik7
DQorDQogCWhhc2ggXj0gaGFzaD4+ODsNCiAJcmV0dXJuIGhhc2gmKFVOSVhfSEFTSF9TSVpFLTEp
Ow0KIH0NCmRpZmYgLS1naXQgYS9zY3JpcHRzL21vZC9maWxlMmFsaWFzLmMgYi9zY3JpcHRzL21v
ZC9maWxlMmFsaWFzLmMNCmluZGV4IGQxZDBhZTguLjk4ZmYzMzEgMTAwNjQ0DQotLS0gYS9zY3Jp
cHRzL21vZC9maWxlMmFsaWFzLmMNCisrKyBiL3NjcmlwdHMvbW9kL2ZpbGUyYWxpYXMuYw0KQEAg
LTEzMCw4ICsxMzAsOCBAQCBzdGF0aWMgdm9pZCBkb191c2JfZW50cnkoc3RydWN0IHVzYl9kZXZp
Y2VfaWQgKmlkLA0KIAkJCQlyYW5nZV9sbyA8IDB4OSA/ICJbJVgtOSIgOiAiWyVYIiwNCiAJCQkJ
cmFuZ2VfbG8pOw0KIAkJCXNwcmludGYoYWxpYXMgKyBzdHJsZW4oYWxpYXMpLA0KLQkJCQlyYW5n
ZV9oaSA+IDB4QSA/ICJhLSVYXSIgOiAiJVhdIiwNCi0JCQkJcmFuZ2VfbG8pOw0KKwkJCQlyYW5n
ZV9oaSA+IDB4QSA/ICJBLSVYXSIgOiAiJVhdIiwNCisJCQkJcmFuZ2VfaGkpOw0KIAkJfQ0KIAl9
DQogCWlmIChiY2REZXZpY2VfaW5pdGlhbF9kaWdpdHMgPCAoc2l6ZW9mKGlkLT5iY2REZXZpY2Vf
bG8pICogMiAtIDEpKQ0KZGlmZiAtLWdpdCBhL3NlY3VyaXR5L3NlbGludXgvaG9va3MuYyBiL3Nl
Y3VyaXR5L3NlbGludXgvaG9va3MuYw0KaW5kZXggYmNmMWQ3My4uNGZhNzkzOSAxMDA2NDQNCi0t
LSBhL3NlY3VyaXR5L3NlbGludXgvaG9va3MuYw0KKysrIGIvc2VjdXJpdHkvc2VsaW51eC9ob29r
cy5jDQpAQCAtNDY3NiwyMiArNDY3NiwzMSBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHNlbGludXhf
aXBfcG9zdHJvdXRlKHN0cnVjdCBza19idWZmICpza2IsIGludCBpZmluZGV4LA0KIAkgKiBhcyBm
YXN0IGFuZCBhcyBjbGVhbiBhcyBwb3NzaWJsZS4gKi8NCiAJaWYgKCFzZWxpbnV4X3BvbGljeWNh
cF9uZXRwZWVyKQ0KIAkJcmV0dXJuIHNlbGludXhfaXBfcG9zdHJvdXRlX2NvbXBhdChza2IsIGlm
aW5kZXgsIGZhbWlseSk7DQorDQorCXNlY21hcmtfYWN0aXZlID0gc2VsaW51eF9zZWNtYXJrX2Vu
YWJsZWQoKTsNCisJcGVlcmxibF9hY3RpdmUgPSBuZXRsYmxfZW5hYmxlZCgpIHx8IHNlbGludXhf
eGZybV9lbmFibGVkKCk7DQorCWlmICghc2VjbWFya19hY3RpdmUgJiYgIXBlZXJsYmxfYWN0aXZl
KQ0KKwkJcmV0dXJuIE5GX0FDQ0VQVDsNCisNCisJc2sgPSBza2ItPnNrOw0KKw0KICNpZmRlZiBD
T05GSUdfWEZSTQ0KIAkvKiBJZiBza2ItPmRzdC0+eGZybSBpcyBub24tTlVMTCB0aGVuIHRoZSBw
YWNrZXQgaXMgdW5kZXJnb2luZyBhbiBJUHNlYw0KIAkgKiBwYWNrZXQgdHJhbnNmb3JtYXRpb24g
c28gYWxsb3cgdGhlIHBhY2tldCB0byBwYXNzIHdpdGhvdXQgYW55IGNoZWNrcw0KIAkgKiBzaW5j
ZSB3ZSdsbCBoYXZlIGFub3RoZXIgY2hhbmNlIHRvIHBlcmZvcm0gYWNjZXNzIGNvbnRyb2wgY2hl
Y2tzDQogCSAqIHdoZW4gdGhlIHBhY2tldCBpcyBvbiBpdCdzIGZpbmFsIHdheSBvdXQuDQogCSAq
IE5PVEU6IHRoZXJlIGFwcGVhciB0byBiZSBzb21lIElQdjYgbXVsdGljYXN0IGNhc2VzIHdoZXJl
IHNrYi0+ZHN0DQotCSAqICAgICAgIGlzIE5VTEwsIGluIHRoaXMgY2FzZSBnbyBhaGVhZCBhbmQg
YXBwbHkgYWNjZXNzIGNvbnRyb2wuICovDQotCWlmIChza2JfZHN0KHNrYikgIT0gTlVMTCAmJiBz
a2JfZHN0KHNrYiktPnhmcm0gIT0gTlVMTCkNCisJICogICAgICAgaXMgTlVMTCwgaW4gdGhpcyBj
YXNlIGdvIGFoZWFkIGFuZCBhcHBseSBhY2Nlc3MgY29udHJvbC4NCisJICogTk9URTogaWYgdGhp
cyBpcyBhIGxvY2FsIHNvY2tldCAoc2tiLT5zayAhPSBOVUxMKSB0aGF0IGlzIGluIHRoZQ0KKwkg
KiAgICAgICBUQ1AgbGlzdGVuaW5nIHN0YXRlIHdlIGNhbm5vdCB3YWl0IHVudGlsIHRoZSBYRlJN
IHByb2Nlc3NpbmcNCisJICogICAgICAgaXMgZG9uZSBhcyB3ZSB3aWxsIG1pc3Mgb3V0IG9uIHRo
ZSBTQSBsYWJlbCBpZiB3ZSBkbzsNCisJICogICAgICAgdW5mb3J0dW5hdGVseSwgdGhpcyBtZWFu
cyBtb3JlIHdvcmssIGJ1dCBpdCBpcyBvbmx5IG9uY2UgcGVyDQorCSAqICAgICAgIGNvbm5lY3Rp
b24uICovDQorCWlmIChza2JfZHN0KHNrYikgIT0gTlVMTCAmJiBza2JfZHN0KHNrYiktPnhmcm0g
IT0gTlVMTCAmJg0KKwkgICAgIShzayAhPSBOVUxMICYmIHNrLT5za19zdGF0ZSA9PSBUQ1BfTElT
VEVOKSkNCiAJCXJldHVybiBORl9BQ0NFUFQ7DQogI2VuZGlmDQotCXNlY21hcmtfYWN0aXZlID0g
c2VsaW51eF9zZWNtYXJrX2VuYWJsZWQoKTsNCi0JcGVlcmxibF9hY3RpdmUgPSBuZXRsYmxfZW5h
YmxlZCgpIHx8IHNlbGludXhfeGZybV9lbmFibGVkKCk7DQotCWlmICghc2VjbWFya19hY3RpdmUg
JiYgIXBlZXJsYmxfYWN0aXZlKQ0KLQkJcmV0dXJuIE5GX0FDQ0VQVDsNCiANCi0Jc2sgPSBza2It
PnNrOw0KIAlpZiAoc2sgPT0gTlVMTCkgew0KIAkJLyogV2l0aG91dCBhbiBhc3NvY2lhdGVkIHNv
Y2tldCB0aGUgcGFja2V0IGlzIGVpdGhlciBjb21pbmcNCiAJCSAqIGZyb20gdGhlIGtlcm5lbCBv
ciBpdCBpcyBiZWluZyBmb3J3YXJkZWQ7IGNoZWNrIHRoZSBwYWNrZXQNCkBAIC00NzE5LDYgKzQ3
MjgsMjUgQEAgc3RhdGljIHVuc2lnbmVkIGludCBzZWxpbnV4X2lwX3Bvc3Ryb3V0ZShzdHJ1Y3Qg
c2tfYnVmZiAqc2tiLCBpbnQgaWZpbmRleCwNCiAJCXN0cnVjdCBza19zZWN1cml0eV9zdHJ1Y3Qg
KnNrc2VjID0gc2stPnNrX3NlY3VyaXR5Ow0KIAkJaWYgKHNlbGludXhfc2tiX3BlZXJsYmxfc2lk
KHNrYiwgZmFtaWx5LCAmc2tiX3NpZCkpDQogCQkJcmV0dXJuIE5GX0RST1A7DQorCQkvKiBBdCB0
aGlzIHBvaW50LCBpZiB0aGUgcmV0dXJuZWQgc2tiIHBlZXJsYmwgaXMgU0VDU0lEX05VTEwNCisJ
CSAqIGFuZCB0aGUgcGFja2V0IGhhcyBiZWVuIHRocm91Z2ggYXQgbGVhc3Qgb25lIFhGUk0NCisJ
CSAqIHRyYW5zZm9ybWF0aW9uIHRoZW4gd2UgbXVzdCBiZSBkZWFsaW5nIHdpdGggdGhlICJmaW5h
bCINCisJCSAqIGZvcm0gb2YgbGFiZWxlZCBJUHNlYyBwYWNrZXQ7IHNpbmNlIHdlJ3ZlIGFscmVh
ZHkgYXBwbGllZA0KKwkJICogYWxsIG9mIG91ciBhY2Nlc3MgY29udHJvbHMgb24gdGhpcyBwYWNr
ZXQgd2UgY2FuIHNhZmVseQ0KKwkJICogcGFzcyB0aGUgcGFja2V0LiAqLw0KKwkJaWYgKHNrYl9z
aWQgPT0gU0VDU0lEX05VTEwpIHsNCisJCQlzd2l0Y2ggKGZhbWlseSkgew0KKwkJCWNhc2UgUEZf
SU5FVDoNCisJCQkJaWYgKElQQ0Ioc2tiKS0+ZmxhZ3MgJiBJUFNLQl9YRlJNX1RSQU5TRk9STUVE
KQ0KKwkJCQkJcmV0dXJuIE5GX0FDQ0VQVDsNCisJCQkJYnJlYWs7DQorCQkJY2FzZSBQRl9JTkVU
NjoNCisJCQkJaWYgKElQNkNCKHNrYiktPmZsYWdzICYgSVA2U0tCX1hGUk1fVFJBTlNGT1JNRUQp
DQorCQkJCQlyZXR1cm4gTkZfQUNDRVBUOw0KKwkJCWRlZmF1bHQ6DQorCQkJCXJldHVybiBORl9E
Uk9QX0VSUigtRUNPTk5SRUZVU0VEKTsNCisJCQl9DQorCQl9DQogCQlpZiAoc2VsaW51eF9jb25u
X3NpZChza3NlYy0+c2lkLCBza2Jfc2lkLCAmcGVlcl9zaWQpKQ0KIAkJCXJldHVybiBORl9EUk9Q
Ow0KIAkJc2VjbWFya19wZXJtID0gUEFDS0VUX19TRU5EOw0KZGlmZiAtLWdpdCBhL3NlY3VyaXR5
L3NlbGludXgvc3MvcG9saWN5ZGIuYyBiL3NlY3VyaXR5L3NlbGludXgvc3MvcG9saWN5ZGIuYw0K
aW5kZXggYTdmNjFkNS4uMjNlOWNiYSAxMDA2NDQNCi0tLSBhL3NlY3VyaXR5L3NlbGludXgvc3Mv
cG9saWN5ZGIuYw0KKysrIGIvc2VjdXJpdHkvc2VsaW51eC9zcy9wb2xpY3lkYi5jDQpAQCAtMTkx
NCw3ICsxOTE0LDE5IEBAIHN0YXRpYyBpbnQgZmlsZW5hbWVfdHJhbnNfcmVhZChzdHJ1Y3QgcG9s
aWN5ZGIgKnAsIHZvaWQgKmZwKQ0KIAkJaWYgKHJjKQ0KIAkJCWdvdG8gb3V0Ow0KIA0KLQkJaGFz
aHRhYl9pbnNlcnQocC0+ZmlsZW5hbWVfdHJhbnMsIGZ0LCBvdHlwZSk7DQorCQlyYyA9IGhhc2h0
YWJfaW5zZXJ0KHAtPmZpbGVuYW1lX3RyYW5zLCBmdCwgb3R5cGUpOw0KKwkJaWYgKHJjKSB7DQor
CQkJLyoNCisJCQkgKiBEbyBub3QgcmV0dXJuIC1FRVhJU1QgdG8gdGhlIGNhbGxlciwgb3IgdGhl
IHN5c3RlbQ0KKwkJCSAqIHdpbGwgbm90IGJvb3QuDQorCQkJICovDQorCQkJaWYgKHJjICE9IC1F
RVhJU1QpDQorCQkJCWdvdG8gb3V0Ow0KKwkJCS8qIEJ1dCBmcmVlIG1lbW9yeSB0byBhdm9pZCBt
ZW1vcnkgbGVhay4gKi8NCisJCQlrZnJlZShmdCk7DQorCQkJa2ZyZWUobmFtZSk7DQorCQkJa2Zy
ZWUob3R5cGUpOw0KKwkJfQ0KIAl9DQogCWhhc2hfZXZhbChwLT5maWxlbmFtZV90cmFucywgImZp
bGVuYW1ldHIiKTsNCiAJcmV0dXJuIDA7DQpAQCAtMzIwMiwxMCArMzIxNCwxMCBAQCBzdGF0aWMg
aW50IGZpbGVuYW1lX3dyaXRlX2hlbHBlcih2b2lkICprZXksIHZvaWQgKmRhdGEsIHZvaWQgKnB0
cikNCiAJaWYgKHJjKQ0KIAkJcmV0dXJuIHJjOw0KIA0KLQlidWZbMF0gPSBmdC0+c3R5cGU7DQot
CWJ1ZlsxXSA9IGZ0LT50dHlwZTsNCi0JYnVmWzJdID0gZnQtPnRjbGFzczsNCi0JYnVmWzNdID0g
b3R5cGUtPm90eXBlOw0KKwlidWZbMF0gPSBjcHVfdG9fbGUzMihmdC0+c3R5cGUpOw0KKwlidWZb
MV0gPSBjcHVfdG9fbGUzMihmdC0+dHR5cGUpOw0KKwlidWZbMl0gPSBjcHVfdG9fbGUzMihmdC0+
dGNsYXNzKTsNCisJYnVmWzNdID0gY3B1X3RvX2xlMzIob3R5cGUtPm90eXBlKTsNCiANCiAJcmMg
PSBwdXRfZW50cnkoYnVmLCBzaXplb2YodTMyKSwgNCwgZnApOw0KIAlpZiAocmMpDQpkaWZmIC0t
Z2l0IGEvc2VjdXJpdHkvc2VsaW51eC9zcy9zZXJ2aWNlcy5jIGIvc2VjdXJpdHkvc2VsaW51eC9z
cy9zZXJ2aWNlcy5jDQppbmRleCAxODVmODQ5Li43MmIyMGIxIDEwMDY0NA0KLS0tIGEvc2VjdXJp
dHkvc2VsaW51eC9zcy9zZXJ2aWNlcy5jDQorKysgYi9zZWN1cml0eS9zZWxpbnV4L3NzL3NlcnZp
Y2VzLmMNCkBAIC0xMjI5LDYgKzEyMjksMTAgQEAgc3RhdGljIGludCBzZWN1cml0eV9jb250ZXh0
X3RvX3NpZF9jb3JlKGNvbnN0IGNoYXIgKnNjb250ZXh0LCB1MzIgc2NvbnRleHRfbGVuLA0KIAlz
dHJ1Y3QgY29udGV4dCBjb250ZXh0Ow0KIAlpbnQgcmMgPSAwOw0KIA0KKwkvKiBBbiBlbXB0eSBz
ZWN1cml0eSBjb250ZXh0IGlzIG5ldmVyIHZhbGlkLiAqLw0KKwlpZiAoIXNjb250ZXh0X2xlbikN
CisJCXJldHVybiAtRUlOVkFMOw0KKw0KIAlpZiAoIXNzX2luaXRpYWxpemVkKSB7DQogCQlpbnQg
aTsNCiANCmRpZmYgLS1naXQgYS9zb3VuZC9wY2kvS2NvbmZpZyBiL3NvdW5kL3BjaS9LY29uZmln
DQppbmRleCA4ODE2ODA0Li5lNzI0NGFjIDEwMDY0NA0KLS0tIGEvc291bmQvcGNpL0tjb25maWcN
CisrKyBiL3NvdW5kL3BjaS9LY29uZmlnDQpAQCAtMzAsNiArMzAsNyBAQCBjb25maWcgU05EX0FM
UzMwMA0KIAlzZWxlY3QgU05EX1BDTQ0KIAlzZWxlY3QgU05EX0FDOTdfQ09ERUMNCiAJc2VsZWN0
IFNORF9PUEwzX0xJQg0KKwlzZWxlY3QgWk9ORV9ETUENCiAJaGVscA0KIAkgIFNheSAnWScgb3Ig
J00nIHRvIGluY2x1ZGUgc3VwcG9ydCBmb3IgQXZhbmNlIExvZ2ljIEFMUzMwMC9BTFMzMDArDQog
DQpAQCAtNTQsNiArNTUsNyBAQCBjb25maWcgU05EX0FMSTU0NTENCiAJdHJpc3RhdGUgIkFMaSBN
NTQ1MSBQQ0kgQXVkaW8gQ29udHJvbGxlciINCiAJc2VsZWN0IFNORF9NUFU0MDFfVUFSVA0KIAlz
ZWxlY3QgU05EX0FDOTdfQ09ERUMNCisJc2VsZWN0IFpPTkVfRE1BDQogCWhlbHANCiAJICBTYXkg
WSBoZXJlIHRvIGluY2x1ZGUgc3VwcG9ydCBmb3IgdGhlIGludGVncmF0ZWQgQUM5NyBzb3VuZA0K
IAkgIGRldmljZSBvbiBtb3RoZXJib2FyZHMgdXNpbmcgdGhlIEFMaSBNNTQ1MSBBdWRpbyBDb250
cm9sbGVyDQpAQCAtMTU4LDYgKzE2MCw3IEBAIGNvbmZpZyBTTkRfQVpUMzMyOA0KIAlzZWxlY3Qg
U05EX1BDTQ0KIAlzZWxlY3QgU05EX1JBV01JREkNCiAJc2VsZWN0IFNORF9BQzk3X0NPREVDDQor
CXNlbGVjdCBaT05FX0RNQQ0KIAloZWxwDQogCSAgU2F5IFkgaGVyZSB0byBpbmNsdWRlIHN1cHBv
cnQgZm9yIEF6dGVjaCBBWkYzMzI4IChQQ0kxNjgpDQogCSAgc291bmRjYXJkcy4NCkBAIC00NjMs
NiArNDY2LDcgQEAgY29uZmlnIFNORF9FTVUxMEsxDQogCXNlbGVjdCBTTkRfSFdERVANCiAJc2Vs
ZWN0IFNORF9SQVdNSURJDQogCXNlbGVjdCBTTkRfQUM5N19DT0RFQw0KKwlzZWxlY3QgWk9ORV9E
TUENCiAJaGVscA0KIAkgIFNheSBZIHRvIGluY2x1ZGUgc3VwcG9ydCBmb3IgU291bmQgQmxhc3Rl
ciBQQ0kgNTEyLCBMaXZlISwNCiAJICBBdWRpZ3kgYW5kIEUtbXUgQVBTIChwYXJ0aWFsbHkgc3Vw
cG9ydGVkKSBzb3VuZGNhcmRzLg0KQEAgLTQ3OCw2ICs0ODIsNyBAQCBjb25maWcgU05EX0VNVTEw
SzFYDQogCXRyaXN0YXRlICJFbXUxMGsxWCAoRGVsbCBPRU0gVmVyc2lvbikiDQogCXNlbGVjdCBT
TkRfQUM5N19DT0RFQw0KIAlzZWxlY3QgU05EX1JBV01JREkNCisJc2VsZWN0IFpPTkVfRE1BDQog
CWhlbHANCiAJICBTYXkgWSBoZXJlIHRvIGluY2x1ZGUgc3VwcG9ydCBmb3IgdGhlIERlbGwgT0VN
IHZlcnNpb24gb2YgdGhlDQogCSAgU291bmQgQmxhc3RlciBMaXZlIS4NCkBAIC01MTEsNiArNTE2
LDcgQEAgY29uZmlnIFNORF9FUzE5MzgNCiAJc2VsZWN0IFNORF9PUEwzX0xJQg0KIAlzZWxlY3Qg
U05EX01QVTQwMV9VQVJUDQogCXNlbGVjdCBTTkRfQUM5N19DT0RFQw0KKwlzZWxlY3QgWk9ORV9E
TUENCiAJaGVscA0KIAkgIFNheSBZIGhlcmUgdG8gaW5jbHVkZSBzdXBwb3J0IGZvciBzb3VuZGNh
cmRzIGJhc2VkIG9uIEVTUyBTb2xvLTENCiAJICAoRVMxOTM4LCBFUzE5NDYsIEVTMTk2OSkgY2hp
cHMuDQpAQCAtNTIyLDYgKzUyOCw3IEBAIGNvbmZpZyBTTkRfRVMxOTY4DQogCXRyaXN0YXRlICJF
U1MgRVMxOTY4LzE5NzggKE1hZXN0cm8tMS8yLzJFKSINCiAJc2VsZWN0IFNORF9NUFU0MDFfVUFS
VA0KIAlzZWxlY3QgU05EX0FDOTdfQ09ERUMNCisJc2VsZWN0IFpPTkVfRE1BDQogCWhlbHANCiAJ
ICBTYXkgWSBoZXJlIHRvIGluY2x1ZGUgc3VwcG9ydCBmb3Igc291bmRjYXJkcyBiYXNlZCBvbiBF
U1MgTWFlc3Rybw0KIAkgIDEvMi8yRSBjaGlwcy4NCkBAIC02MDIsNiArNjA5LDcgQEAgY29uZmln
IFNORF9JQ0UxNzEyDQogCXNlbGVjdCBTTkRfTVBVNDAxX1VBUlQNCiAJc2VsZWN0IFNORF9BQzk3
X0NPREVDDQogCXNlbGVjdCBCSVRSRVZFUlNFDQorCXNlbGVjdCBaT05FX0RNQQ0KIAloZWxwDQog
CSAgU2F5IFkgaGVyZSB0byBpbmNsdWRlIHN1cHBvcnQgZm9yIHNvdW5kY2FyZHMgYmFzZWQgb24g
dGhlDQogCSAgSUNFMTcxMiAoRW52eTI0KSBjaGlwLg0KQEAgLTY4OCw2ICs2OTYsNyBAQCBjb25m
aWcgU05EX0xYNjQ2NEVTDQogY29uZmlnIFNORF9NQUVTVFJPMw0KIAl0cmlzdGF0ZSAiRVNTIEFs
bGVncm8vTWFlc3RybzMiDQogCXNlbGVjdCBTTkRfQUM5N19DT0RFQw0KKwlzZWxlY3QgWk9ORV9E
TUENCiAJaGVscA0KIAkgIFNheSBZIGhlcmUgdG8gaW5jbHVkZSBzdXBwb3J0IGZvciBzb3VuZGNh
cmRzIGJhc2VkIG9uIEVTUyBNYWVzdHJvIDMNCiAJICAoQWxsZWdybykgY2hpcHMuDQpAQCAtNzgy
LDYgKzc5MSw3IEBAIGNvbmZpZyBTTkRfU0lTNzAxOQ0KIAl0cmlzdGF0ZSAiU2lTIDcwMTkgQXVk
aW8gQWNjZWxlcmF0b3IiDQogCWRlcGVuZHMgb24gWDg2ICYmICFYODZfNjQNCiAJc2VsZWN0IFNO
RF9BQzk3X0NPREVDDQorCXNlbGVjdCBaT05FX0RNQQ0KIAloZWxwDQogCSAgU2F5IFkgaGVyZSB0
byBpbmNsdWRlIHN1cHBvcnQgZm9yIHRoZSBTaVMgNzAxOSBBdWRpbyBBY2NlbGVyYXRvci4NCiAN
CkBAIC03OTMsNiArODAzLDcgQEAgY29uZmlnIFNORF9TT05JQ1ZJQkVTDQogCXNlbGVjdCBTTkRf
T1BMM19MSUINCiAJc2VsZWN0IFNORF9NUFU0MDFfVUFSVA0KIAlzZWxlY3QgU05EX0FDOTdfQ09E
RUMNCisJc2VsZWN0IFpPTkVfRE1BDQogCWhlbHANCiAJICBTYXkgWSBoZXJlIHRvIGluY2x1ZGUg
c3VwcG9ydCBmb3Igc291bmRjYXJkcyBiYXNlZCBvbiB0aGUgUzMNCiAJICBTb25pY1ZpYmVzIGNo
aXAuDQpAQCAtODA0LDYgKzgxNSw3IEBAIGNvbmZpZyBTTkRfVFJJREVOVA0KIAl0cmlzdGF0ZSAi
VHJpZGVudCA0RC1XYXZlIERYL05YOyBTaVMgNzAxOCINCiAJc2VsZWN0IFNORF9NUFU0MDFfVUFS
VA0KIAlzZWxlY3QgU05EX0FDOTdfQ09ERUMNCisJc2VsZWN0IFpPTkVfRE1BDQogCWhlbHANCiAJ
ICBTYXkgWSBoZXJlIHRvIGluY2x1ZGUgc3VwcG9ydCBmb3Igc291bmRjYXJkcyBiYXNlZCBvbiBU
cmlkZW50DQogCSAgNEQtV2F2ZSBEWC9OWCBvciBTaVMgNzAxOCBjaGlwcy4NCmRpZmYgLS1naXQg
YS9zb3VuZC9wY2kvaGRhL3BhdGNoX3JlYWx0ZWsuYyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfcmVh
bHRlay5jDQppbmRleCAxZjc4Y2E2Li4zNmJjZTY4IDEwMDY0NA0KLS0tIGEvc291bmQvcGNpL2hk
YS9wYXRjaF9yZWFsdGVrLmMNCisrKyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfcmVhbHRlay5jDQpA
QCAtNTE1Nyw2ICs1MTU3LDkgQEAgc3RhdGljIGludCBhbGMyNjlfZmlsbF9jb2VmKHN0cnVjdCBo
ZGFfY29kZWMgKmNvZGVjKQ0KIA0KIAlpZiAoc3BlYy0+Y29kZWNfdmFyaWFudCAhPSBBTEMyNjlf
VFlQRV9BTEMyNjlWQikNCiAJCXJldHVybiAwOw0KKwkvKiBBTEMyNzFYIGRvZXNuJ3Qgc2VlbSB0
byBzdXBwb3J0IHRoZXNlIENPRUZzIChia28jNTIxODEpICovDQorCWlmICghc3RyY21wKGNvZGVj
LT5jaGlwX25hbWUsICJBTEMyNzFYIikpDQorCQlyZXR1cm4gMDsNCiANCiAJaWYgKChhbGNfZ2V0
X2NvZWYwKGNvZGVjKSAmIDB4MDBmZikgPCAweDAxNSkgew0KIAkJYWxjX3dyaXRlX2NvZWZfaWR4
KGNvZGVjLCAweGYsIDB4OTYwYik7DQpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL294eWdlbi94b25h
cl9kZy5jIGIvc291bmQvcGNpL294eWdlbi94b25hcl9kZy5jDQppbmRleCBiYzZlYjU4Li41OWVk
YTBhIDEwMDY0NA0KLS0tIGEvc291bmQvcGNpL294eWdlbi94b25hcl9kZy5jDQorKysgYi9zb3Vu
ZC9wY2kvb3h5Z2VuL3hvbmFyX2RnLmMNCkBAIC0yOTQsNiArMjk0LDE2IEBAIHN0YXRpYyBpbnQg
b3V0cHV0X3N3aXRjaF9wdXQoc3RydWN0IHNuZF9rY29udHJvbCAqY3RsLA0KIAkJb3h5Z2VuX3dy
aXRlMTZfbWFza2VkKGNoaXAsIE9YWUdFTl9HUElPX0RBVEEsDQogCQkJCSAgICAgIGRhdGEtPm91
dHB1dF9zZWwgPT0gMSA/IEdQSU9fSFBfUkVBUiA6IDAsDQogCQkJCSAgICAgIEdQSU9fSFBfUkVB
Uik7DQorCQlveHlnZW5fd3JpdGU4X21hc2tlZChjaGlwLCBPWFlHRU5fUExBWV9ST1VUSU5HLA0K
KwkJCQkgICAgIGRhdGEtPm91dHB1dF9zZWwgPT0gMCA/DQorCQkJCSAgICAgT1hZR0VOX1BMQVlf
TVVURTAxIDoNCisJCQkJICAgICBPWFlHRU5fUExBWV9NVVRFMjMgfA0KKwkJCQkgICAgIE9YWUdF
Tl9QTEFZX01VVEU0NSB8DQorCQkJCSAgICAgT1hZR0VOX1BMQVlfTVVURTY3LA0KKwkJCQkgICAg
IE9YWUdFTl9QTEFZX01VVEUwMSB8DQorCQkJCSAgICAgT1hZR0VOX1BMQVlfTVVURTIzIHwNCisJ
CQkJICAgICBPWFlHRU5fUExBWV9NVVRFNDUgfA0KKwkJCQkgICAgIE9YWUdFTl9QTEFZX01VVEU2
Nyk7DQogCX0NCiAJbXV0ZXhfdW5sb2NrKCZjaGlwLT5tdXRleCk7DQogCXJldHVybiBjaGFuZ2Vk
Ow0KQEAgLTU5Nyw3ICs2MDcsNyBAQCBzdHJ1Y3Qgb3h5Z2VuX21vZGVsIG1vZGVsX3hvbmFyX2Rn
ID0gew0KIAkubW9kZWxfZGF0YV9zaXplID0gc2l6ZW9mKHN0cnVjdCBkZyksDQogCS5kZXZpY2Vf
Y29uZmlnID0gUExBWUJBQ0tfMF9UT19JMlMgfA0KIAkJCSBQTEFZQkFDS18xX1RPX1NQRElGIHwN
Ci0JCQkgQ0FQVFVSRV8wX0ZST01fSTJTXzIsDQorCQkJIENBUFRVUkVfMF9GUk9NX0kyU18xLA0K
IAkuZGFjX2NoYW5uZWxzX3BjbSA9IDYsDQogCS5kYWNfY2hhbm5lbHNfbWl4ZXIgPSAwLA0KIAku
ZnVuY3Rpb25fZmxhZ3MgPSBPWFlHRU5fRlVOQ1RJT05fU1BJLA0KZGlmZiAtLWdpdCBhL3NvdW5k
L3BjaS9ybWU5NjUyL3JtZTk2NTIuYyBiL3NvdW5kL3BjaS9ybWU5NjUyL3JtZTk2NTIuYw0KaW5k
ZXggNzMyYzVlOC4uMWIzNTg2NCAxMDA2NDQNCi0tLSBhL3NvdW5kL3BjaS9ybWU5NjUyL3JtZTk2
NTIuYw0KKysrIGIvc291bmQvcGNpL3JtZTk2NTIvcm1lOTY1Mi5jDQpAQCAtMjg1LDcgKzI4NSw3
IEBAIHN0YXRpYyBjaGFyIGNoYW5uZWxfbWFwXzk2MzZfZHNbMjZdID0gew0KIAkvKiBBREFUIGNo
YW5uZWxzIGFyZSByZW1hcHBlZCAqLw0KIAkxLCAzLCA1LCA3LCA5LCAxMSwgMTMsIDE1LA0KIAkv
KiBjaGFubmVscyA4IGFuZCA5IGFyZSBTL1BESUYgKi8NCi0JMjQsIDI1DQorCTI0LCAyNSwNCiAJ
Lyogb3RoZXJzIGRvbid0IGV4aXN0ICovDQogCS0xLCAtMSwgLTEsIC0xLCAtMSwgLTEsIC0xLCAt
MSwgLTEsIC0xLCAtMSwgLTEsIC0xLCAtMSwgLTENCiB9Ow0KZGlmZiAtLWdpdCBhL3NvdW5kL3Nv
Yy9jb2RlY3MvYWRhdTE3MDEuYyBiL3NvdW5kL3NvYy9jb2RlY3MvYWRhdTE3MDEuYw0KaW5kZXgg
OGI3ZTFjNS4uM2NjYTU1OCAxMDA2NDQNCi0tLSBhL3NvdW5kL3NvYy9jb2RlY3MvYWRhdTE3MDEu
Yw0KKysrIGIvc291bmQvc29jL2NvZGVjcy9hZGF1MTcwMS5jDQpAQCAtNjQsNyArNjQsNyBAQA0K
IA0KICNkZWZpbmUgQURBVTE3MDFfU0VST0NUTF9XT1JEX0xFTl8yNAkweDAwMDANCiAjZGVmaW5l
IEFEQVUxNzAxX1NFUk9DVExfV09SRF9MRU5fMjAJMHgwMDAxDQotI2RlZmluZSBBREFVMTcwMV9T
RVJPQ1RMX1dPUkRfTEVOXzE2CTB4MDAxMA0KKyNkZWZpbmUgQURBVTE3MDFfU0VST0NUTF9XT1JE
X0xFTl8xNgkweDAwMDINCiAjZGVmaW5lIEFEQVUxNzAxX1NFUk9DVExfV09SRF9MRU5fTUFTSwkw
eDAwMDMNCiANCiAjZGVmaW5lIEFEQVUxNzAxX0FVWE5QT1dfVkJQRAkJMHg0MA0KZGlmZiAtLWdp
dCBhL3NvdW5kL3NvYy9jb2RlY3Mvc3RhMzJ4LmMgYi9zb3VuZC9zb2MvY29kZWNzL3N0YTMyeC5j
DQppbmRleCBkMmYzNzE1Li4yNWFlMDU5IDEwMDY0NA0KLS0tIGEvc291bmQvc29jL2NvZGVjcy9z
dGEzMnguYw0KKysrIGIvc291bmQvc29jL2NvZGVjcy9zdGEzMnguYw0KQEAgLTE0Myw0MiArMTQz
LDQyIEBAIHN0YXRpYyBjb25zdCB1bnNpZ25lZCBpbnQgc3RhMzJ4X2xpbWl0ZXJfZHJjX3JlbGVh
c2VfdGx2W10gPSB7DQogCTEzLCAxNiwgVExWX0RCX1NDQUxFX0lURU0oLTE1MDAsIDMwMCwgMCks
DQogfTsNCiANCi1zdGF0aWMgY29uc3Qgc3RydWN0IHNvY19lbnVtIHN0YTMyeF9kcmNfYWNfZW51
bSA9DQotCVNPQ19FTlVNX1NJTkdMRShTVEEzMlhfQ09ORkQsIFNUQTMyWF9DT05GRF9EUkNfU0hJ
RlQsDQotCQkJMiwgc3RhMzJ4X2RyY19hYyk7DQotc3RhdGljIGNvbnN0IHN0cnVjdCBzb2NfZW51
bSBzdGEzMnhfYXV0b19lcV9lbnVtID0NCi0JU09DX0VOVU1fU0lOR0xFKFNUQTMyWF9BVVRPMSwg
U1RBMzJYX0FVVE8xX0FNRVFfU0hJRlQsDQotCQkJMywgc3RhMzJ4X2F1dG9fZXFfbW9kZSk7DQot
c3RhdGljIGNvbnN0IHN0cnVjdCBzb2NfZW51bSBzdGEzMnhfYXV0b19nY19lbnVtID0NCi0JU09D
X0VOVU1fU0lOR0xFKFNUQTMyWF9BVVRPMSwgU1RBMzJYX0FVVE8xX0FNR0NfU0hJRlQsDQotCQkJ
NCwgc3RhMzJ4X2F1dG9fZ2NfbW9kZSk7DQotc3RhdGljIGNvbnN0IHN0cnVjdCBzb2NfZW51bSBz
dGEzMnhfYXV0b194b19lbnVtID0NCi0JU09DX0VOVU1fU0lOR0xFKFNUQTMyWF9BVVRPMiwgU1RB
MzJYX0FVVE8yX1hPX1NISUZULA0KLQkJCTE2LCBzdGEzMnhfYXV0b194b19tb2RlKTsNCi1zdGF0
aWMgY29uc3Qgc3RydWN0IHNvY19lbnVtIHN0YTMyeF9wcmVzZXRfZXFfZW51bSA9DQotCVNPQ19F
TlVNX1NJTkdMRShTVEEzMlhfQVVUTzMsIFNUQTMyWF9BVVRPM19QRVFfU0hJRlQsDQotCQkJMzIs
IHN0YTMyeF9wcmVzZXRfZXFfbW9kZSk7DQotc3RhdGljIGNvbnN0IHN0cnVjdCBzb2NfZW51bSBz
dGEzMnhfbGltaXRlcl9jaDFfZW51bSA9DQotCVNPQ19FTlVNX1NJTkdMRShTVEEzMlhfQzFDRkcs
IFNUQTMyWF9DeENGR19MU19TSElGVCwNCi0JCQkzLCBzdGEzMnhfbGltaXRlcl9zZWxlY3QpOw0K
LXN0YXRpYyBjb25zdCBzdHJ1Y3Qgc29jX2VudW0gc3RhMzJ4X2xpbWl0ZXJfY2gyX2VudW0gPQ0K
LQlTT0NfRU5VTV9TSU5HTEUoU1RBMzJYX0MyQ0ZHLCBTVEEzMlhfQ3hDRkdfTFNfU0hJRlQsDQot
CQkJMywgc3RhMzJ4X2xpbWl0ZXJfc2VsZWN0KTsNCi1zdGF0aWMgY29uc3Qgc3RydWN0IHNvY19l
bnVtIHN0YTMyeF9saW1pdGVyX2NoM19lbnVtID0NCi0JU09DX0VOVU1fU0lOR0xFKFNUQTMyWF9D
M0NGRywgU1RBMzJYX0N4Q0ZHX0xTX1NISUZULA0KLQkJCTMsIHN0YTMyeF9saW1pdGVyX3NlbGVj
dCk7DQotc3RhdGljIGNvbnN0IHN0cnVjdCBzb2NfZW51bSBzdGEzMnhfbGltaXRlcjFfYXR0YWNr
X3JhdGVfZW51bSA9DQotCVNPQ19FTlVNX1NJTkdMRShTVEEzMlhfTDFBUiwgU1RBMzJYX0x4QV9T
SElGVCwNCi0JCQkxNiwgc3RhMzJ4X2xpbWl0ZXJfYXR0YWNrX3JhdGUpOw0KLXN0YXRpYyBjb25z
dCBzdHJ1Y3Qgc29jX2VudW0gc3RhMzJ4X2xpbWl0ZXIyX2F0dGFja19yYXRlX2VudW0gPQ0KLQlT
T0NfRU5VTV9TSU5HTEUoU1RBMzJYX0wyQVIsIFNUQTMyWF9MeEFfU0hJRlQsDQotCQkJMTYsIHN0
YTMyeF9saW1pdGVyX2F0dGFja19yYXRlKTsNCi1zdGF0aWMgY29uc3Qgc3RydWN0IHNvY19lbnVt
IHN0YTMyeF9saW1pdGVyMV9yZWxlYXNlX3JhdGVfZW51bSA9DQotCVNPQ19FTlVNX1NJTkdMRShT
VEEzMlhfTDFBUiwgU1RBMzJYX0x4Ul9TSElGVCwNCi0JCQkxNiwgc3RhMzJ4X2xpbWl0ZXJfcmVs
ZWFzZV9yYXRlKTsNCi1zdGF0aWMgY29uc3Qgc3RydWN0IHNvY19lbnVtIHN0YTMyeF9saW1pdGVy
Ml9yZWxlYXNlX3JhdGVfZW51bSA9DQotCVNPQ19FTlVNX1NJTkdMRShTVEEzMlhfTDJBUiwgU1RB
MzJYX0x4Ul9TSElGVCwNCi0JCQkxNiwgc3RhMzJ4X2xpbWl0ZXJfcmVsZWFzZV9yYXRlKTsNCitz
dGF0aWMgU09DX0VOVU1fU0lOR0xFX0RFQ0woc3RhMzJ4X2RyY19hY19lbnVtLA0KKwkJCSAgICBT
VEEzMlhfQ09ORkQsIFNUQTMyWF9DT05GRF9EUkNfU0hJRlQsDQorCQkJICAgIHN0YTMyeF9kcmNf
YWMpOw0KK3N0YXRpYyBTT0NfRU5VTV9TSU5HTEVfREVDTChzdGEzMnhfYXV0b19lcV9lbnVtLA0K
KwkJCSAgICBTVEEzMlhfQVVUTzEsIFNUQTMyWF9BVVRPMV9BTUVRX1NISUZULA0KKwkJCSAgICBz
dGEzMnhfYXV0b19lcV9tb2RlKTsNCitzdGF0aWMgU09DX0VOVU1fU0lOR0xFX0RFQ0woc3RhMzJ4
X2F1dG9fZ2NfZW51bSwNCisJCQkgICAgU1RBMzJYX0FVVE8xLCBTVEEzMlhfQVVUTzFfQU1HQ19T
SElGVCwNCisJCQkgICAgc3RhMzJ4X2F1dG9fZ2NfbW9kZSk7DQorc3RhdGljIFNPQ19FTlVNX1NJ
TkdMRV9ERUNMKHN0YTMyeF9hdXRvX3hvX2VudW0sDQorCQkJICAgIFNUQTMyWF9BVVRPMiwgU1RB
MzJYX0FVVE8yX1hPX1NISUZULA0KKwkJCSAgICBzdGEzMnhfYXV0b194b19tb2RlKTsNCitzdGF0
aWMgU09DX0VOVU1fU0lOR0xFX0RFQ0woc3RhMzJ4X3ByZXNldF9lcV9lbnVtLA0KKwkJCSAgICBT
VEEzMlhfQVVUTzMsIFNUQTMyWF9BVVRPM19QRVFfU0hJRlQsDQorCQkJICAgIHN0YTMyeF9wcmVz
ZXRfZXFfbW9kZSk7DQorc3RhdGljIFNPQ19FTlVNX1NJTkdMRV9ERUNMKHN0YTMyeF9saW1pdGVy
X2NoMV9lbnVtLA0KKwkJCSAgICBTVEEzMlhfQzFDRkcsIFNUQTMyWF9DeENGR19MU19TSElGVCwN
CisJCQkgICAgc3RhMzJ4X2xpbWl0ZXJfc2VsZWN0KTsNCitzdGF0aWMgU09DX0VOVU1fU0lOR0xF
X0RFQ0woc3RhMzJ4X2xpbWl0ZXJfY2gyX2VudW0sDQorCQkJICAgIFNUQTMyWF9DMkNGRywgU1RB
MzJYX0N4Q0ZHX0xTX1NISUZULA0KKwkJCSAgICBzdGEzMnhfbGltaXRlcl9zZWxlY3QpOw0KK3N0
YXRpYyBTT0NfRU5VTV9TSU5HTEVfREVDTChzdGEzMnhfbGltaXRlcl9jaDNfZW51bSwNCisJCQkg
ICAgU1RBMzJYX0MzQ0ZHLCBTVEEzMlhfQ3hDRkdfTFNfU0hJRlQsDQorCQkJICAgIHN0YTMyeF9s
aW1pdGVyX3NlbGVjdCk7DQorc3RhdGljIFNPQ19FTlVNX1NJTkdMRV9ERUNMKHN0YTMyeF9saW1p
dGVyMV9hdHRhY2tfcmF0ZV9lbnVtLA0KKwkJCSAgICBTVEEzMlhfTDFBUiwgU1RBMzJYX0x4QV9T
SElGVCwNCisJCQkgICAgc3RhMzJ4X2xpbWl0ZXJfYXR0YWNrX3JhdGUpOw0KK3N0YXRpYyBTT0Nf
RU5VTV9TSU5HTEVfREVDTChzdGEzMnhfbGltaXRlcjJfYXR0YWNrX3JhdGVfZW51bSwNCisJCQkg
ICAgU1RBMzJYX0wyQVIsIFNUQTMyWF9MeEFfU0hJRlQsDQorCQkJICAgIHN0YTMyeF9saW1pdGVy
X2F0dGFja19yYXRlKTsNCitzdGF0aWMgU09DX0VOVU1fU0lOR0xFX0RFQ0woc3RhMzJ4X2xpbWl0
ZXIxX3JlbGVhc2VfcmF0ZV9lbnVtLA0KKwkJCSAgICBTVEEzMlhfTDFBUiwgU1RBMzJYX0x4Ul9T
SElGVCwNCisJCQkgICAgc3RhMzJ4X2xpbWl0ZXJfcmVsZWFzZV9yYXRlKTsNCitzdGF0aWMgU09D
X0VOVU1fU0lOR0xFX0RFQ0woc3RhMzJ4X2xpbWl0ZXIyX3JlbGVhc2VfcmF0ZV9lbnVtLA0KKwkJ
CSAgICBTVEEzMlhfTDJBUiwgU1RBMzJYX0x4Ul9TSElGVCwNCisJCQkgICAgc3RhMzJ4X2xpbWl0
ZXJfcmVsZWFzZV9yYXRlKTsNCiANCiAvKiBieXRlIGFycmF5IGNvbnRyb2xzIGZvciBzZXR0aW5n
IGJpcXVhZCwgbWl4ZXIsIHNjYWxpbmcgY29lZmZpY2llbnRzOw0KICAqIGZvciBiaXF1YWRzIGFs
bCBmaXZlIGNvZWZmaWNpZW50cyBuZWVkIHRvIGJlIHNldCBpbiBvbmUgZ28sDQpAQCAtMzUwLDcg
KzM1MCw3IEBAIFNPQ19TSU5HTEVfVExWKCJUcmVibGUgVG9uZSBDb250cm9sIiwgU1RBMzJYX1RP
TkUsIFNUQTMyWF9UT05FX1RUQ19TSElGVCwgMTUsIDAsDQogU09DX0VOVU0oIkxpbWl0ZXIxIEF0
dGFjayBSYXRlIChkQi9tcykiLCBzdGEzMnhfbGltaXRlcjFfYXR0YWNrX3JhdGVfZW51bSksDQog
U09DX0VOVU0oIkxpbWl0ZXIyIEF0dGFjayBSYXRlIChkQi9tcykiLCBzdGEzMnhfbGltaXRlcjJf
YXR0YWNrX3JhdGVfZW51bSksDQogU09DX0VOVU0oIkxpbWl0ZXIxIFJlbGVhc2UgUmF0ZSAoZEIv
bXMpIiwgc3RhMzJ4X2xpbWl0ZXIxX3JlbGVhc2VfcmF0ZV9lbnVtKSwNCi1TT0NfRU5VTSgiTGlt
aXRlcjIgUmVsZWFzZSBSYXRlIChkQi9tcykiLCBzdGEzMnhfbGltaXRlcjFfcmVsZWFzZV9yYXRl
X2VudW0pLA0KK1NPQ19FTlVNKCJMaW1pdGVyMiBSZWxlYXNlIFJhdGUgKGRCL21zKSIsIHN0YTMy
eF9saW1pdGVyMl9yZWxlYXNlX3JhdGVfZW51bSksDQogDQogLyogZGVwZW5kaW5nIG9uIG1vZGUs
IHRoZSBhdHRhY2svcmVsZWFzZSB0aHJlc2hvbGRzIGhhdmUNCiAgKiB0d28gZGlmZmVyZW50IGVu
dW0gZGVmaW5pdGlvbnM7IHByb3ZpZGUgYm90aA0KZGlmZiAtLWdpdCBhL3NvdW5kL3NvYy9jb2Rl
Y3Mvd204NzcwLmMgYi9zb3VuZC9zb2MvY29kZWNzL3dtODc3MC5jDQppbmRleCBhYTA1ZTY1Li5k
NWY3ZDhkIDEwMDY0NA0KLS0tIGEvc291bmQvc29jL2NvZGVjcy93bTg3NzAuYw0KKysrIGIvc291
bmQvc29jL2NvZGVjcy93bTg3NzAuYw0KQEAgLTE2Myw4ICsxNjMsOCBAQCBzdGF0aWMgY29uc3Qg
Y2hhciAqYWluX3RleHRbXSA9IHsNCiAJIkFJTjUiLCAiQUlONiIsICJBSU43IiwgIkFJTjgiDQog
fTsNCiANCi1zdGF0aWMgY29uc3Qgc3RydWN0IHNvY19lbnVtIGFpbl9lbnVtID0NCi0JU09DX0VO
VU1fRE9VQkxFKFdNODc3MF9BRENNVVgsIDAsIDQsIDgsIGFpbl90ZXh0KTsNCitzdGF0aWMgU09D
X0VOVU1fRE9VQkxFX0RFQ0woYWluX2VudW0sDQorCQkJICAgIFdNODc3MF9BRENNVVgsIDAsIDQs
IGFpbl90ZXh0KTsNCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IHNuZF9rY29udHJvbF9uZXcgYWlu
X211eCA9DQogCVNPQ19EQVBNX0VOVU0oIkNhcHR1cmUgTXV4IiwgYWluX2VudW0pOw0KZGlmZiAt
LWdpdCBhL3NvdW5kL3VzYi9taXhlci5jIGIvc291bmQvdXNiL21peGVyLmMNCmluZGV4IDQxYjlm
ZTAuLjRmN2IzMzAgMTAwNjQ0DQotLS0gYS9zb3VuZC91c2IvbWl4ZXIuYw0KKysrIGIvc291bmQv
dXNiL21peGVyLmMNCkBAIC04MzEsNiArODMxLDcgQEAgc3RhdGljIHZvaWQgdm9sdW1lX2NvbnRy
b2xfcXVpcmtzKHN0cnVjdCB1c2JfbWl4ZXJfZWxlbV9pbmZvICpjdmFsLA0KIAkJfQ0KIAkJYnJl
YWs7DQogDQorCWNhc2UgVVNCX0lEKDB4MDQ2ZCwgMHgwODA3KTogLyogTG9naXRlY2ggV2ViY2Ft
IEM1MDAgKi8NCiAJY2FzZSBVU0JfSUQoMHgwNDZkLCAweDA4MDgpOg0KIAljYXNlIFVTQl9JRCgw
eDA0NmQsIDB4MDgwOSk6DQogCWNhc2UgVVNCX0lEKDB4MDQ2ZCwgMHgwODFiKTogLyogSEQgV2Vi
Y2FtIGMzMTAgKi8NCmRpZmYgLS1naXQgYS9zb3VuZC91c2IvbWl4ZXJfbWFwcy5jIGIvc291bmQv
dXNiL21peGVyX21hcHMuYw0KaW5kZXggZjEzMjRjNC4uMGU0ZTkwOSAxMDA2NDQNCi0tLSBhL3Nv
dW5kL3VzYi9taXhlcl9tYXBzLmMNCisrKyBiL3NvdW5kL3VzYi9taXhlcl9tYXBzLmMNCkBAIC0z
MDQsNiArMzA0LDExIEBAIHN0YXRpYyBzdHJ1Y3QgdXNibWl4X25hbWVfbWFwIGhlcmN1bGVzX3Vz
YjUxX21hcFtdID0gew0KIAl7IDAgfQkJCQkvKiB0ZXJtaW5hdG9yICovDQogfTsNCiANCitzdGF0
aWMgY29uc3Qgc3RydWN0IHVzYm1peF9uYW1lX21hcCBrZWZfeDMwMGFfbWFwW10gPSB7DQorCXsg
MTAsIE5VTEwgfSwgLyogZmlybXdhcmUgbG9ja3MgdXAgKD8pIHdoZW4gd2UgdHJ5IHRvIGFjY2Vz
cyB0aGlzIEZVICovDQorCXsgMCB9DQorfTsNCisNCiAvKg0KICAqIENvbnRyb2wgbWFwIGVudHJp
ZXMNCiAgKi8NCkBAIC0zNzEsNiArMzc2LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgdXNibWl4X2N0bF9t
YXAgdXNibWl4X2N0bF9tYXBzW10gPSB7DQogCQkubWFwID0gc2NyYXRjaF9saXZlX21hcCwNCiAJ
CS5pZ25vcmVfY3RsX2Vycm9yID0gMSwNCiAJfSwNCisJew0KKwkJLmlkID0gVVNCX0lEKDB4Mjdh
YywgMHgxMDAwKSwNCisJCS5tYXAgPSBrZWZfeDMwMGFfbWFwLA0KKwl9LA0KIAl7IDAgfSAvKiB0
ZXJtaW5hdG9yICovDQogfTsNCiANCmRpZmYgLS1naXQgYS90b29scy9wb3dlci94ODYvdHVyYm9z
dGF0L3R1cmJvc3RhdC5jIGIvdG9vbHMvcG93ZXIveDg2L3R1cmJvc3RhdC90dXJib3N0YXQuYw0K
aW5kZXggM2M2Zjc4MC4uMjc5YTJmMSAxMDA2NDQNCi0tLSBhL3Rvb2xzL3Bvd2VyL3g4Ni90dXJi
b3N0YXQvdHVyYm9zdGF0LmMNCisrKyBiL3Rvb2xzL3Bvd2VyL3g4Ni90dXJib3N0YXQvdHVyYm9z
dGF0LmMNCkBAIC0zMiw2ICszMiw3IEBADQogI2luY2x1ZGUgPGRpcmVudC5oPg0KICNpbmNsdWRl
IDxzdHJpbmcuaD4NCiAjaW5jbHVkZSA8Y3R5cGUuaD4NCisjaW5jbHVkZSA8Y3B1aWQuaD4NCiAN
CiAjZGVmaW5lIE1TUl9UU0MJMHgxMA0KICNkZWZpbmUgTVNSX05FSEFMRU1fUExBVEZPUk1fSU5G
TwkweENFDQpAQCAtODQ3LDcgKzg0OCw3IEBAIHZvaWQgY2hlY2tfY3B1aWQoKQ0KIA0KIAllYXgg
PSBlYnggPSBlY3ggPSBlZHggPSAwOw0KIA0KLQlhc20oImNwdWlkIiA6ICI9YSIgKG1heF9sZXZl
bCksICI9YiIgKGVieCksICI9YyIgKGVjeCksICI9ZCIgKGVkeCkgOiAiYSIgKDApKTsNCisJX19n
ZXRfY3B1aWQoMCwgJm1heF9sZXZlbCwgJmVieCwgJmVjeCwgJmVkeCk7DQogDQogCWlmIChlYngg
PT0gMHg3NTZlNjU0NyAmJiBlZHggPT0gMHg0OTY1NmU2OSAmJiBlY3ggPT0gMHg2YzY1NzQ2ZSkN
CiAJCWdlbnVpbmVfaW50ZWwgPSAxOw0KQEAgLTg1Niw3ICs4NTcsNyBAQCB2b2lkIGNoZWNrX2Nw
dWlkKCkNCiAJCWZwcmludGYoc3RkZXJyLCAiJS40cyUuNHMlLjRzICIsDQogCQkJKGNoYXIgKikm
ZWJ4LCAoY2hhciAqKSZlZHgsIChjaGFyICopJmVjeCk7DQogDQotCWFzbSgiY3B1aWQiIDogIj1h
IiAoZm1zKSwgIj1jIiAoZWN4KSwgIj1kIiAoZWR4KSA6ICJhIiAoMSkgOiAiZWJ4Iik7DQorCV9f
Z2V0X2NwdWlkKDEsICZmbXMsICZlYngsICZlY3gsICZlZHgpOw0KIAlmYW1pbHkgPSAoZm1zID4+
IDgpICYgMHhmOw0KIAltb2RlbCA9IChmbXMgPj4gNCkgJiAweGY7DQogCXN0ZXBwaW5nID0gZm1z
ICYgMHhmOw0KQEAgLTg3OCw3ICs4NzksNyBAQCB2b2lkIGNoZWNrX2NwdWlkKCkNCiAJICogVGhp
cyBjaGVjayBpcyB2YWxpZCBmb3IgYm90aCBJbnRlbCBhbmQgQU1ELg0KIAkgKi8NCiAJZWJ4ID0g
ZWN4ID0gZWR4ID0gMDsNCi0JYXNtKCJjcHVpZCIgOiAiPWEiIChtYXhfbGV2ZWwpLCAiPWIiIChl
YngpLCAiPWMiIChlY3gpLCAiPWQiIChlZHgpIDogImEiICgweDgwMDAwMDAwKSk7DQorCV9fZ2V0
X2NwdWlkKDB4ODAwMDAwMDAsICZtYXhfbGV2ZWwsICZlYngsICZlY3gsICZlZHgpOw0KIA0KIAlp
ZiAobWF4X2xldmVsIDwgMHg4MDAwMDAwNykgew0KIAkJZnByaW50ZihzdGRlcnIsICJDUFVJRDog
bm8gaW52YXJpYW50IFRTQyAobWF4X2xldmVsIDB4JXgpXG4iLCBtYXhfbGV2ZWwpOw0KQEAgLTg4
OSw3ICs4OTAsNyBAQCB2b2lkIGNoZWNrX2NwdWlkKCkNCiAJICogTm9uLVN0b3AgVFNDIGlzIGFk
dmVydGlzZWQgYnkgQ1BVSUQuRUFYPTB4ODAwMDAwMDc6IEVEWC5iaXQ4DQogCSAqIHRoaXMgY2hl
Y2sgaXMgdmFsaWQgZm9yIGJvdGggSW50ZWwgYW5kIEFNRA0KIAkgKi8NCi0JYXNtKCJjcHVpZCIg
OiAiPWEiIChlYXgpLCAiPWIiIChlYngpLCAiPWMiIChlY3gpLCAiPWQiIChlZHgpIDogImEiICgw
eDgwMDAwMDA3KSk7DQorCV9fZ2V0X2NwdWlkKDB4ODAwMDAwMDcsICZlYXgsICZlYngsICZlY3gs
ICZlZHgpOw0KIAloYXNfaW52YXJpYW50X3RzYyA9IGVkeCAmICgxIDw8IDgpOw0KIA0KIAlpZiAo
IWhhc19pbnZhcmlhbnRfdHNjKSB7DQpAQCAtOTAyLDcgKzkwMyw3IEBAIHZvaWQgY2hlY2tfY3B1
aWQoKQ0KIAkgKiB0aGlzIGNoZWNrIGlzIHZhbGlkIGZvciBib3RoIEludGVsIGFuZCBBTUQNCiAJ
ICovDQogDQotCWFzbSgiY3B1aWQiIDogIj1hIiAoZWF4KSwgIj1iIiAoZWJ4KSwgIj1jIiAoZWN4
KSwgIj1kIiAoZWR4KSA6ICJhIiAoMHg2KSk7DQorCV9fZ2V0X2NwdWlkKDB4NiwgJmVheCwgJmVi
eCwgJmVjeCwgJmVkeCk7DQogCWhhc19hcGVyZiA9IGVjeCAmICgxIDw8IDApOw0KIAlpZiAoIWhh
c19hcGVyZikgew0KIAkJZnByaW50ZihzdGRlcnIsICJObyBBUEVSRiBNU1JcbiIpOw0KZGlmZiAt
LWdpdCBhL3ZpcnQva3ZtL2NvYWxlc2NlZF9tbWlvLmMgYi92aXJ0L2t2bS9jb2FsZXNjZWRfbW1p
by5jDQppbmRleCBhNmVjMjA2Li5lNTZiMjQwIDEwMDY0NA0KLS0tIGEvdmlydC9rdm0vY29hbGVz
Y2VkX21taW8uYw0KKysrIGIvdmlydC9rdm0vY29hbGVzY2VkX21taW8uYw0KQEAgLTE0OCwxNyAr
MTQ4LDEzIEBAIGludCBrdm1fdm1faW9jdGxfcmVnaXN0ZXJfY29hbGVzY2VkX21taW8oc3RydWN0
IGt2bSAqa3ZtLA0KIAlsaXN0X2FkZF90YWlsKCZkZXYtPmxpc3QsICZrdm0tPmNvYWxlc2NlZF96
b25lcyk7DQogCW11dGV4X3VubG9jaygma3ZtLT5zbG90c19sb2NrKTsNCiANCi0JcmV0dXJuIHJl
dDsNCisJcmV0dXJuIDA7DQogDQogb3V0X2ZyZWVfZGV2Og0KIAltdXRleF91bmxvY2soJmt2bS0+
c2xvdHNfbG9jayk7DQotDQogCWtmcmVlKGRldik7DQogDQotCWlmIChkZXYgPT0gTlVMTCkNCi0J
CXJldHVybiAtRU5YSU87DQotDQotCXJldHVybiAwOw0KKwlyZXR1cm4gcmV0Ow0KIH0NCiANCiBp
bnQga3ZtX3ZtX2lvY3RsX3VucmVnaXN0ZXJfY29hbGVzY2VkX21taW8oc3RydWN0IGt2bSAqa3Zt
LA0K


--=-tnyLLp81uTBoYMwXuP/k--

--=-vPDzKSqS+7+vU8+rYdFX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUztdGue/yOyVhhEJAQoysxAAqvUXHwjK4LKEsM+zpwvyDow8xk47SI1i
w9uQB8puBcNj6/1gaLZcWdcvTIakLcChVZtzu9VEb5dTZxxtrTH0oGTON11g/kzv
zPCfZFKxtN6pdc3uiWG5Hs+ePMii/vBBIX0xCf2tAhkMqJqSXVPORnpopZpCVwcp
wB+BnwS17/v2TI661l+QVE/vveCV9drmhoAWNCAuMkUfmwPZ/fnadS89S1IIQ5UT
cF26L+j5D1D0aUc4xLDT4qsLQ2iuqhC7ywDTgW8cI40jA+qrrw5w4SXhhX5S6drU
gXW90ERScXFAeeR/iLw8k9xMsPUmyKuz8K8pFDFBdntMzFUHdnfgLApnP1EoQ09Z
Mr3LKtWrxFjR9e4MWkFKppkRclU+Q2LYdSAm0tatB2Fx+Zn7LEm4m2w4esM8RRU0
bNQiRjS3dLN4fT4TL6BP+zHpABmG3qKDplcVpbSnzke5JtwLWtOkjp3xGevzLMjQ
RDHgEEBipZ+HZk9qaSfM0mrkUzH/YaH0jDa2DS8+exwLsmDzXeOMAA+3Rjy6yotd
aSNGQEPyznPRIQBeZZAsc4/+WzmS6SAwAymV855Y4/uScQSKlpmF51X6ifUZZY0x
nbrUoU3mm4j+k42I0Qj7AVmslbQH/iRunLiPdqtwLse3sJI314LImvS0cxdyTOua
szdrcYPxylQ=
=MtNk
-----END PGP SIGNATURE-----

--=-vPDzKSqS+7+vU8+rYdFX--
