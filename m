Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaI3Vb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:31:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60714 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaI3Vbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:31:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y.z extended stable] Linux 3.13.11.8 stable review
Date: Tue, 30 Sep 2014 14:30:05 -0700
Message-Id: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11.8 stable kernel.

This version contains 103 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11.8 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 .../bindings/interrupt-controller/interrupts.txt   |  12 +-
 arch/arm/boot/dts/imx53.dtsi                       |   2 +-
 arch/arm/include/asm/cacheflush.h                  |   1 -
 arch/arm/kernel/entry-header.S                     |  29 +--
 arch/arm/kvm/handle_exit.c                         |   2 +
 arch/arm/kvm/init.S                                |   4 +
 arch/arm/mm/abort-ev6.S                            |   6 -
 arch/arm/mm/abort-ev7.S                            |   6 -
 arch/arm64/include/asm/hw_breakpoint.h             |   1 -
 arch/arm64/kernel/ptrace.c                         |   3 +-
 arch/arm64/kvm/handle_exit.c                       |   2 +
 arch/arm64/kvm/hyp-init.S                          |   4 +
 arch/mips/cavium-octeon/setup.c                    |  18 +-
 arch/s390/kvm/kvm-s390.c                           |  12 -
 arch/s390/mm/pgtable.c                             |  10 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/xtensa/include/asm/pgtable.h                  |   7 +-
 arch/xtensa/include/asm/uaccess.h                  |   5 +
 arch/xtensa/include/uapi/asm/ioctls.h              |  19 +-
 arch/xtensa/kernel/entry.S                         |  26 ++-
 arch/xtensa/kernel/pci-dma.c                       |  12 +-
 block/cfq-iosched.c                                |  11 +-
 drivers/acpi/processor_idle.c                      |   4 +-
 drivers/ata/libata-core.c                          |   2 +-
 drivers/ata/pata_scc.c                             |  15 +-
 drivers/base/regmap/internal.h                     |   3 +
 drivers/base/regmap/regcache-rbtree.c              |   9 +-
 drivers/base/regmap/regcache.c                     |   2 +-
 drivers/base/regmap/regmap-debugfs.c               |   3 +
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/firmware/efi/vars.c                        |   8 +-
 drivers/gpu/drm/i915/intel_bios.c                  |   2 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   2 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   2 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   3 +
 drivers/gpu/drm/radeon/cik.c                       |   1 +
 drivers/gpu/drm/radeon/kv_dpm.c                    |   5 +-
 drivers/gpu/drm/radeon/radeon.h                    |   1 +
 drivers/gpu/drm/radeon/radeon_drv.c                |   4 +
 drivers/gpu/drm/radeon/radeon_pm.c                 |  16 +-
 drivers/gpu/drm/radeon/trinity_dpm.c               |  17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               |   3 +-
 drivers/hid/hid-cherry.c                           |   2 +-
 drivers/hid/hid-kye.c                              |   2 +-
 drivers/hid/hid-lg.c                               |   4 +-
 drivers/hid/hid-logitech-dj.c                      |  54 +++--
 drivers/hid/hid-logitech-dj.h                      |   1 +
 drivers/hid/hid-magicmouse.c                       |  10 +
 drivers/hid/hid-monterey.c                         |   2 +-
 drivers/hid/hid-petalynx.c                         |   2 +-
 drivers/hid/hid-picolcd_core.c                     |   6 +
 drivers/hid/hid-sunplus.c                          |   2 +-
 drivers/hwmon/ds1621.c                             |   1 +
 drivers/i2c/busses/i2c-at91.c                      |  32 ++-
 drivers/i2c/busses/i2c-mv64xxx.c                   |   3 +-
 drivers/i2c/busses/i2c-rcar.c                      |  18 +-
 drivers/input/mouse/synaptics.c                    |  68 ++++--
 drivers/input/mouse/synaptics.h                    |  11 +
 drivers/iommu/amd_iommu.c                          |  10 +-
 drivers/md/raid10.c                                |   3 +-
 drivers/md/raid5.c                                 |   2 +
 drivers/misc/mei/nfc.c                             |  11 +-
 drivers/mtd/nand/omap2.c                           |   2 +-
 drivers/net/can/c_can/c_can_platform.c             |   2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  18 +-
 drivers/of/irq.c                                   |  17 +-
 drivers/spi/spi-omap2-mcspi.c                      |   3 +-
 drivers/spi/spi-pxa2xx.c                           |   1 +
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   2 +
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/host/ehci-hub.c                        |   2 +-
 drivers/usb/host/xhci-pci.c                        |   4 +
 drivers/usb/host/xhci-ring.c                       |  78 ++++---
 drivers/usb/host/xhci.c                            |   3 +
 drivers/usb/misc/sisusbvga/sisusb.c                |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/option.c                        |  31 ++-
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   1 +
 drivers/usb/serial/usb-serial.c                    |  37 ++-
 drivers/usb/serial/whiteheat.c                     |   7 +-
 drivers/usb/serial/zte_ev.c                        |  20 --
 fs/aio.c                                           |   6 +
 fs/cifs/cifsglob.h                                 |   2 +
 fs/cifs/file.c                                     |   2 +-
 fs/cifs/inode.c                                    |   6 +
 fs/cifs/readdir.c                                  |   2 +-
 fs/cifs/smb1ops.c                                  |   7 +
 fs/cifs/smb2maperror.c                             |   2 +-
 fs/cifs/smb2ops.c                                  |   9 +
 fs/cifs/smb2pdu.c                                  |  12 +-
 fs/ext4/inode.c                                    |  10 +-
 fs/ext4/super.c                                    |   5 +-
 fs/isofs/inode.c                                   |  15 +-
 fs/isofs/isofs.h                                   |  23 +-
 fs/isofs/rock.c                                    |  39 +++-
 fs/jbd2/commit.c                                   |  21 +-
 fs/jbd2/journal.c                                  |  56 +++--
 fs/jbd2/recovery.c                                 |  33 +--
 fs/jbd2/revoke.c                                   |   6 +-
 fs/namespace.c                                     |  10 +-
 fs/nfs/nfs4proc.c                                  |  17 +-
 fs/pnode.c                                         |   1 +
 fs/udf/inode.c                                     |  57 +++--
 fs/xfs/xfs_aops.c                                  |  61 +++++
 fs/xfs/xfs_file.c                                  |  21 +-
 include/drm/drm_pciids.h                           |   7 +
 include/linux/jbd2.h                               |  30 ++-
 include/uapi/linux/xattr.h                         |   2 +-
 kernel/trace/ring_buffer.c                         |  16 +-
 lib/assoc_array.c                                  |   6 +-
 mm/memblock.c                                      |   3 +-
 net/ceph/auth_x.c                                  | 256 +++++++++++----------
 sound/core/info.c                                  |   4 +-
 sound/pci/hda/patch_conexant.c                     |   9 +-
 sound/pci/hda/patch_realtek.c                      |  28 ++-
 sound/soc/codecs/rt5640.c                          |   1 +
 sound/soc/pxa/pxa-ssp.c                            |   4 +-
 120 files changed, 1031 insertions(+), 548 deletions(-)

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Al Viro (2):
      get rid of propagate_umount() mistakenly treating slaves as busy.
      fix EBUSY on umount() from MNT_SHRINKABLE

Alan Cox (1):
      spi/pxa2xx: Add ACPI ID for Intel Braswell

Alan Douglas (1):
      xtensa: fix address checks in dma_{alloc,free}_coherent

Alex Deucher (4):
      drm/radeon: add bapm module parameter
      drm/radeon: add new KV pci id
      drm/radeon: add new bonaire pci ids
      drm/radeon: add additional SI pci ids

Alexander Usyskin (1):
      mei: nfc: fix memory leak in error path

Anton Blanchard (1):
      ibmveth: Fix endian issues with rx_no_buffer statistic

Arjun Sreedharan (1):
      pata_scc: propagate return value of scc_wait_after_reset

Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id

Chen-Yu Tsai (1):
      i2c: mv64xxx: continue probe when clock-frequency is missing

Chris Mason (1):
      xfs: don't zero partial page cache pages during O_DIRECT writes

Christian Borntraeger (2):
      KVM: s390: Fix user triggerable bug in dead code
      KVM: s390/mm: try a cow on read only pages for key ops

Christoffer Dall (1):
      arm/arm64: KVM: Complete WFI/WFE instructions

Clemens Ladisch (1):
      ALSA: core: fix buffer overflow in snd_info_get_line()

Dan Carpenter (1):
      can: c_can: checking IS_ERR() instead of NULL

Daniel Mack (1):
      ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Darrick J. Wong (2):
      jbd2: fix infinite loop when recovering corrupt journal blocks
      jbd2: fix descriptor block size handling errors with journal_csum

Dave Chinner (2):
      xfs: don't dirty buffers beyond EOF
      xfs: don't zero partial page cache pages during O_DIRECT writes

David Howells (2):
      KEYS: Fix termination condition in assoc array garbage collection
      KEYS: Fix use-after-free in assoc_array_gc()

Dmitry Monakhov (1):
      ext4: update i_disksize coherently with block allocation on error path

Dmitry Torokhov (1):
      Input: synaptics - add support for ForcePads

Filipe Brandenburger (1):
      xattr: fix check for simultaneous glibc header inclusion

Florian Fainelli (1):
      of/irq: Fix lookup to use 'interrupts-extended' property first

Greg KH (1):
      USB: serial: pl2303: add device id for ztek device

Guenter Roeck (1):
      firmware: Do not use WARN_ON(!spin_is_locked())

Hans de Goede (1):
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL

Holger Paradies (1):
      staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

Hui Wang (1):
      ALSA: hda - restore the gpio led after resume

Ilya Dryomov (2):
      libceph: add process_one_ticket() helper
      libceph: do not hard code max auth ticket len

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jan Kara (3):
      udf: Fold udf_fill_inode() into __udf_read_inode()
      udf: Avoid infinite loop when processing indirect ICBs
      isofs: Fix unbounded recursion when processing relocated directories

Jarkko Nikula (1):
      ASoC: rt5640: Do not allow regmap to use bulk read-write operations

Jaša Bartelj (1):
      USB: ftdi_sio: Added PID for new ekey device

Jeff Moyer (1):
      aio: add missing smp_rmb() in read_events_ring

Jiri Kosina (5):
      HID: magicmouse: sanity check report size in raw_event() callback
      HID: fix a couple of off-by-ones
      HID: picolcd: sanity check report size in raw_event() callback
      HID: logitech: perform bounds checking on device_id early enough
      ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Joerg Roedel (1):
      iommu/amd: Fix cleanup_domain for mass device removal

Johan Hovold (7):
      USB: option: reduce interrupt-urb logging verbosity
      Revert "USB: option,zte_ev: move most ZTE CDMA devices to zte_ev"
      USB: zte_ev: remove duplicate Gobi PID
      USB: zte_ev: remove duplicate Qualcom PID
      USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID
      USB: serial: fix potential stack buffer overflow
      USB: serial: fix potential heap buffer overflow

Jorge A. Ventura (1):
      spi/omap-mcspi: Fix the spi task hangs waiting dma_rx

Josef Bacik (1):
      trace: Fix epoll hang when we race with new entries

Larry Finger (1):
      staging: r8188eu: Add new USB ID

Lars-Peter Clausen (1):
      regmap: Fix regcache debugfs initialization

Lothar Waßmann (1):
      ARM: dts: i.MX53: fix apparent bug in VPU clks

Marek Roszko (1):
      i2c: at91: add bound checking on SMBus block length bytes

Mark Brown (2):
      regmap: Fix handling of volatile registers for format_write() chips
      regmap: Don't attempt block writes when syncing cache on single_rw devices

Mark Rutland (2):
      ARM: 8128/1: abort: don't clear the exclusive monitors
      ARM: 8129/1: errata: work around Cortex-A15 erratum 830321 using dummy strex

Mathias Krause (1):
      drm/i915: Remove bogus __init annotation from DMI callbacks

Mathias Nyman (1):
      xhci: rework cycle bit checking for new dequeue pointers

Max Filippov (4):
      xtensa: replace IOCTL code definitions with constants
      xtensa: fix access to THREAD_RA/THREAD_SP/THREAD_DS
      xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
      xtensa: fix a6 and a7 handling in fast_syscall_xtensa

NeilBrown (3):
      md/raid6: avoid data corruption during recovery of double-degraded RAID6
      md/raid10: fix memory leak when reshaping a RAID10.
      md/raid10: Fix memory leak when raid10 reshape completes.

Oleg Chernovskiy (1):
      drm/radeon: Add missing lines to ci_set_thermal_temperature_range

Pali Rohár (1):
      drm/radeon: Add ability to get and change dpm state when radeon PX card is turned off

Paolo Bonzini (1):
      Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"

Pavel Shilovsky (2):
      CIFS: Fix SMB2 readdir error handling
      CIFS: Fix wrong directory attributes after rename

Peter Chen (1):
      usb: ehci: using wIndex + 1 for hub port

Pranavkumar Sawargaonkar (1):
      ARM/ARM64: KVM: Nuke Hyp-mode tlbs before enabling MMU

Pranith Kumar (1):
      staging: lustre: Remove circular dependency on header

Robert Coulson (1):
      hwmon: (ds1621) Update zbits after conversion rate change

Roger Quadros (2):
      mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()
      usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1

Sergei Shtylyov (1):
      i2c: rcar: fix MNR interrupt handling

Simon Lindgren (1):
      i2c: at91: Fix a race condition during signal handling in at91_do_twi_xfer.

Stephen Hemminger (1):
      USB: sisusb: add device id for Magic Control USB video

Steve French (1):
      [CIFS] Possible null ptr deref in SMB2_tcon

Takashi Iwai (3):
      ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co
      ALSA: hda - Fix digital mic on Acer Aspire 3830TG
      ALSA: hda - Fix COEF setups for ALC1150 codec

Tang Chen (1):
      memblock, memhotplug: fix wrong type in memblock_find_in_range_node().

Tejun Heo (1):
      libata: widen Crucial M550 blacklist matching

Thomas Hellstrom (1):
      drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Toshiaki Makita (1):
      cfq-iosched: Fix wrong children_weight calculation

Trond Myklebust (1):
      NFSv4: Fix problems with close in the presence of a delegation

Will Deacon (1):
      arm64: ptrace: fix compat hardware watchpoint reporting
