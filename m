Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaBUMtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbaBUMtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.11.y.z extended stable] Linux 3.11.10.5 stable review
Date: Fri, 21 Feb 2014 12:47:04 +0000
Message-Id: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.11.10.5 stable kernel.

This version contains 121 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.11.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.11.y-review

The review period for version 3.11.10.5 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.11.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/ABI/testing/sysfs-tty           |   3 +-
 arch/arm64/include/asm/cacheflush.h           |   1 +
 arch/arm64/kernel/vdso.c                      |   4 +-
 arch/arm64/kernel/vdso/Makefile               |   2 +-
 arch/arm64/kernel/vdso/gettimeofday.S         |   7 +-
 arch/arm64/mm/mmu.c                           |  12 ++-
 arch/s390/crypto/aes_s390.c                   |  65 +++++++----
 arch/s390/crypto/des_s390.c                   |  95 ++++++++++------
 arch/s390/kernel/head64.S                     |   7 +-
 arch/s390/mm/page-states.c                    |  10 ++
 arch/tile/include/asm/compat.h                |   1 -
 arch/x86/include/asm/xen/page.h               |  31 ++++--
 arch/x86/kernel/cpu/common.c                  |   7 +-
 arch/x86/kernel/cpu/intel.c                   |   2 +-
 arch/x86/kernel/ftrace.c                      |  83 +++++++-------
 arch/x86/mm/fault.c                           |  14 ++-
 arch/x86/xen/p2m.c                            |  10 +-
 arch/x86/xen/smp.c                            |   9 ++
 block/blk-lib.c                               |   8 ++
 block/blk.h                                   |   2 +-
 drivers/block/xen-blkfront.c                  |   5 +-
 drivers/char/raw.c                            |   2 +-
 drivers/cpufreq/intel_pstate.c                |  43 ++++----
 drivers/edac/edac_mc.c                        |  13 ++-
 drivers/edac/edac_mc_sysfs.c                  |  12 ++-
 drivers/edac/edac_module.h                    |   2 +-
 drivers/gpu/drm/ast/ast_fb.c                  |   2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c         |   2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c          |   2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c        |   4 +-
 drivers/gpu/drm/radeon/r600.c                 |   4 +
 drivers/gpu/drm/radeon/si.c                   |   4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c       |   9 +-
 drivers/hv/connection.c                       |  13 +--
 drivers/hwmon/ntc_thermistor.c                |   6 +-
 drivers/iio/imu/adis16400.h                   |   1 +
 drivers/iio/imu/adis16400_core.c              |  10 +-
 drivers/iio/magnetometer/ak8975.c             |  16 +--
 drivers/infiniband/hw/qib/qib_iba7322.c       |   5 +
 drivers/irqchip/irq-armada-370-xp.c           |   2 +-
 drivers/md/raid1.c                            |  13 ++-
 drivers/md/raid5.c                            |  90 ++++++++--------
 drivers/media/usb/dvb-usb-v2/af9035.c         |   2 +
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |   2 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c |  12 +--
 drivers/media/v4l2-core/videobuf-dma-sg.c     |  10 +-
 drivers/media/v4l2-core/videobuf-vmalloc.c    |  10 +-
 drivers/misc/mei/client.c                     |  11 +-
 drivers/net/wireless/ath/ar5523/ar5523.c      |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  25 ++---
 drivers/net/wireless/ath/ath9k/init.c         |   8 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c  |   5 +
 drivers/net/wireless/iwlwifi/mvm/scan.c       |   3 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c      |   2 +
 drivers/of/address.c                          |   5 +-
 drivers/pinctrl/core.c                        |   8 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c          |  15 ++-
 drivers/power/max17040_battery.c              |   5 +-
 drivers/rtc/rtc-cmos.c                        |  52 ++++++++-
 drivers/spi/spi-nuc900.c                      |   2 +
 drivers/staging/comedi/drivers/adv_pci1710.c  |  17 ++-
 drivers/staging/iio/adc/ad799x_core.c         |   3 +-
 drivers/target/target_core_pr.c               |  11 +-
 drivers/tty/n_gsm.c                           |  11 ++
 drivers/tty/tty_io.c                          |  25 +++--
 drivers/tty/vt/vt.c                           |   2 +
 drivers/usb/core/hcd.c                        |   1 -
 drivers/usb/core/hub.c                        |   7 +-
 drivers/usb/core/usb.h                        |   1 -
 drivers/usb/host/xhci-pci.c                   |   5 +
 drivers/usb/serial/ftdi_sio.c                 |   3 +
 drivers/usb/serial/ftdi_sio_ids.h             |   7 ++
 drivers/usb/serial/option.c                   |   3 +-
 drivers/usb/serial/qcserial.c                 |   3 +
 drivers/usb/storage/Kconfig                   |   4 +-
 drivers/usb/storage/scsiglue.c                |   6 ++
 drivers/usb/storage/unusual_cypress.h         |   2 +-
 drivers/usb/storage/unusual_devs.h            |   7 ++
 drivers/vme/bridges/vme_ca91cx42.c            |   4 +-
 drivers/vme/bridges/vme_tsi148.c              |   4 +-
 fs/bio-integrity.c                            |  10 +-
 fs/btrfs/inode.c                              |   2 +-
 fs/buffer.c                                   |   6 +-
 fs/cifs/cifsacl.c                             |  28 ++++-
 fs/cifs/cifsglob.h                            |  10 ++
 fs/cifs/inode.c                               |  13 ++-
 fs/cifs/smb1ops.c                             |   8 ++
 fs/cifs/xattr.c                               |  64 +++++++----
 fs/file.c                                     |   2 +-
 fs/lockd/svclock.c                            |   8 ++
 fs/nfs/dir.c                                  |   5 +
 include/linux/compiler-gcc4.h                 |   6 +-
 include/linux/hyperv.h                        |   2 +-
 include/uapi/xen/Kbuild                       |   2 +
 include/uapi/xen/gntalloc.h                   |  82 ++++++++++++++
 include/uapi/xen/gntdev.h                     | 150 ++++++++++++++++++++++++++
 include/xen/gntalloc.h                        |  82 --------------
 include/xen/gntdev.h                          | 150 --------------------------
 kernel/irq/Kconfig                            |   1 +
 kernel/irq/irqdesc.c                          |   1 +
 kernel/time/jiffies.c                         |   6 ++
 kernel/time/tick-broadcast.c                  |   1 +
 kernel/time/timekeeping.c                     |  47 +++++---
 kernel/trace/ftrace.c                         | 132 ++++++++++++++++++++---
 kernel/trace/ring_buffer.c                    |   7 ++
 lib/Makefile                                  |   1 +
 mm/memory-failure.c                           |   6 +-
 mm/page-writeback.c                           |   5 +-
 mm/swapfile.c                                 |  11 +-
 net/9p/trans_virtio.c                         |   5 +-
 net/mac80211/cfg.c                            |  41 +++----
 net/mac80211/tx.c                             |   2 +-
 net/wireless/nl80211.c                        |   3 +-
 scripts/mod/file2alias.c                      |   4 +-
 security/selinux/ss/services.c                |   4 +
 sound/pci/hda/patch_analog.c                  |  27 +++++
 sound/pci/hda/patch_realtek.c                 |  11 +-
 sound/usb/Kconfig                             |   1 +
 virt/kvm/coalesced_mmio.c                     |   8 +-
 121 files changed, 1244 insertions(+), 658 deletions(-)

Alan Stern (3):
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: enable multi-LUN scanning when needed

Alex Deucher (1):
      drm/radeon: fix UVD IRQ support on 7xx

Alexander Usyskin (2):
      mei: clear write cb from waiting list on reset
      mei: don't unset read cb ptr on reset

Antti Palosaari (1):
      [media] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Axel Lin (1):
      spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->lsb is true

Beomho Seo (1):
      iio: ak8975: Fix calculation formula for convert micro tesla to gauss unit

Bjørn Mork (2):
      usb: ftdi_sio: add Mindstorms EV3 console adapter
      usb: qcserial: add Netgear Aircard 340U

Borislav Petkov (3):
      rtc-cmos: Add an alarm disable quirk
      EDAC: Poll timeout cannot be zero, p2
      EDAC: Correct workqueue setup path

Brennan Shacklett (1):
      intel_pstate: Improve accuracy by not truncating until final result

Catalin Marinas (1):
      arm64: Invalidate the TLB when replacing pmd entries during boot

Christian König (1):
      drm/radeon: fix UVD IRQ support on SI

Dan Carpenter (1):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

Dave Airlie (2):
      drm/mgag200: fix typo causing bw limits to be ignored on some chips
      drm/mgag200,ast,cirrus: fix regression with drm_can_sleep conversion

Dave Jones (2):
      [media] mxl111sf: Fix unintentional garbage stack read
      [media] mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

David Henningsson (1):
      ALSA: hda - Add a headset quirk for Dell XPS 13

David Vrabel (3):
      xen-blkfront: handle backend CLOSED without CLOSING
      xen: install xen/gntdev.h and xen/gntalloc.h
      xen/p2m: check MFN is in range before using the m2p table

Dirk Brandewie (1):
      intel_pstate: Correct calculation of min pstate value

Doug Anderson (1):
      hwmon: (ntc_thermistor) Avoid math overflow

Eliad Peller (1):
      mac80211: move roc cookie assignment earlier

Emmanuel Grumbach (4):
      iwlwifi: mvm: print the version of the firmware when it asserts
      iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan
      iwlwifi: mvm: don't allow A band if SKU forbids it
      mac80211: release the channel in error path in start_ap

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

Florian Vaussard (1):
      pinctrl: do not init debugfs entries for unimplemented functionalities

Frediano Ziglio (1):
      xen: Fix possible user space selector corruption

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value

H. Peter Anvin (2):
      x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
      x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Hans Verkuil (1):
      [media] Revert "[media] videobuf_vm_{open,close} race fixes"

Harald Freudenberger (3):
      crypto: s390 - fix concurrency issue in aes-ctr mode
      crypto: s390 - fix des and des3_ede cbc concurrency issue
      crypto: s390 - fix des and des3_ede ctr concurrency issue

Hartmut Knaack (1):
      staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested

Heiko Carstens (1):
      tile: remove compat_sys_lookup_dcookie declaration to fix compile error

Jan Moskyto Matejka (1):
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Jens Axboe (1):
      block: add cond_resched() to potentially long running ioctl discard loop

Jingoo Han (1):
      EDAC: Replace strict_strtol() with kstrtol()

Johannes Berg (1):
      mac80211: fix fragmentation code, particularly for encryption

John Stultz (6):
      timekeeping: Fix lost updates to tai adjustment
      timekeeping: Fix potential lost pv notification of time change
      timekeeping: Avoid possible deadlock from clock_was_set_delayed
      timekeeping: Fix clock_set/clock_was_set think-o
      timekeeping: Fix CLOCK_TAI timer/nanosleep delays
      timekeeping: Fix missing timekeeping_update in suspend path

Josef Bacik (1):
      Btrfs: disable snapshot aware defrag for now

K. Y. Srinivasan (2):
      Drivers: hv: vmbus: Specify the target CPU that should receive notification
      Drivers: hv: vmbus: Don't timeout during the initial connection with host

KOSAKI Motohiro (2):
      mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of spin_lock_irq()
      mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

Kleber Sacilotto de Souza (1):
      of: fix PCI bus match for PCIe slots

Krzysztof Kozlowski (1):
      power: max17040: Fix NULL pointer dereference when there is no platform_data

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control

Lior Amsalem (1):
      irqchip: armada-370-xp: fix IPI race condition

Marcus Folkesson (1):
      iio: adis16400: Set timestamp as the last element in chan_spec

Martin K. Petersen (1):
      block: Fix nr_vecs for inline integrity vectors

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions

Martyn Welch (1):
      VME: Correct read/write alignment algorithm

Mel Gorman (1):
      x86: mm: change tlb_flushall_shift for IvyBridge

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Mikulas Patocka (1):
      time: Fix overflow when HZ is smaller than 60

Naoya Horiguchi (1):
      mm/memory-failure.c: move refcount only in !MF_COUNT_INCREASED

Nathan Lynch (2):
      arm64: vdso: fix coarse clock handling
      arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE

NeilBrown (2):
      md/raid1: restore ability for check and repair to fix read errors.
      lockd: send correct lock when granting a delayed lock.

Nell Hardcastle (1):
      intel_pstate: Add Haswell CPU models

Nicholas Bellinger (1):
      target: Fix free-after-use regression in PR unregister

Nitin A Kamble (1):
      genirq: Generic irq chip requires IRQ_DOMAIN

Oleg Nesterov (1):
      md/raid5: Fix CPU hotplug callback registration

Oleksij Rempel (2):
      ath9k_htc: Do not support PowerSave by default
      ar5523: fix usb id for Gigaset.

Paul Bolle (1):
      raw: test against runtime value of max_raw_minors

Paul Gortmaker (1):
      genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y

Petr Písař (1):
      vt: Fix secure clear screen

Pontus Fuchs (1):
      nl80211: Reset split_start when netlink skb is exhausted

Prarit Bhargava (1):
      drivers/edac/edac_mc_sysfs.c: poll timeout cannot be zero

Rafael Aquini (1):
      mm: fix page leak at nfs_symlink()

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface

Richard Yao (1):
      9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Sarah Sharp (2):
      xhci: Fix resume issues on Renesas chips in Samsung laptops
      Revert "usbcore: set lpm_capable field for LPM capable root hubs"

Stanislaw Gruszka (2):
      pinctrl: protect pinctrl_list add
      ath9k_htc: make ->sta_rc_update atomic for most calls

Stephen Smalley (1):
      SELinux:  Fix kernel BUG on empty security contexts.

Steve French (3):
      [CIFS] Fix SMB2 mounts so they don't try to set or get xattrs via cifs
      Add protocol specific operation for CIFS xattrs
      retrieving CIFS ACLs when mounted with SMB2 fails dropping session

Steven Noonan (1):
      compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

Steven Rostedt (Red Hat) (4):
      ftrace: Synchronize setting function_trace_op with ftrace_trace_function
      ftrace: Have function graph only trace based on global_ops filters
      ring-buffer: Fix first commit on sub-buffer having non-zero delta
      ftrace/x86: Use breakpoints for converting function graph caller

Sujith Manoharan (1):
      ath9k: Do not support PowerSave by default

Takashi Iwai (6):
      ALSA: usb-audio: Add missing kconfig dependecy
      ALSA: hda - Fix silent output on Toshiba Satellite L40
      ALSA: hda - Add missing mixer widget for AD1983
      ALSA: hda - Fix missing VREF setup for Mac Pro 1,1
      ALSA: hda - Improve loopback path lookups for AD1983
      ALSA: hda - Fix mic capture on Sony VAIO Pro 11

Tejun Heo (1):
      block: __elv_next_request() shouldn't call into the elevator if bypassing

Thomas Gleixner (1):
      tick: Clear broadcast pending bit when switching to oneshot

Thomas Hellstrom (1):
      drm/vmwgfx: Fix regression caused by "drm/ttm: make ttm reservation calls behave like reservation calls"

Tony Prisk (1):
      pinctrl: vt8500: Change devicetree data parsing

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs

Vinayak Kale (1):
      arm64: add DSB after icache flush in __flush_icache_all()

Weijie Yang (1):
      mm/swap: fix race on swap_info reuse between swapoff and swapon

Will Deacon (1):
      arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k
