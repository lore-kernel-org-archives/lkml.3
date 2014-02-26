Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaBZJqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:46:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaBZJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:46:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.31
Date: Wed, 26 Feb 2014 09:46:28 +0000
Message-Id: <1393407989-8604-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.31 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.30 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Makefile                                      |   2 +-
 arch/s390/crypto/aes_s390.c                   |  65 ++++++++++-----
 arch/s390/crypto/des_s390.c                   |  95 ++++++++++++++--------
 arch/s390/kernel/head64.S                     |   7 +-
 arch/s390/mm/page-states.c                    |  10 +++
 block/blk-lib.c                               |   8 ++
 drivers/ata/ahci.c                            |  12 +--
 drivers/block/xen-blkfront.c                  |   5 +-
 drivers/char/raw.c                            |   2 +-
 drivers/edac/edac_mc.c                        |  11 ++-
 drivers/gpu/drm/mgag200/mgag200_mode.c        |   4 +-
 drivers/infiniband/hw/qib/qib_iba7322.c       |   5 ++
 drivers/md/Kconfig                            |   4 +
 drivers/md/Makefile                           |   1 +
 drivers/md/dm-builtin.c                       |  50 ++++++++++++
 drivers/md/dm-sysfs.c                         |   5 --
 drivers/md/dm.c                               |  26 ++----
 drivers/md/dm.h                               |  17 +++-
 drivers/md/raid5.c                            |  90 ++++++++++-----------
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.h    |   2 +-
 drivers/media/dvb/dvb-usb/mxl111sf.c          |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   8 +-
 drivers/net/wireless/ath/ath9k/init.c         |   8 +-
 drivers/pci/pci.c                             |  17 ++--
 drivers/power/max17040_battery.c              |   5 +-
 drivers/rtc/rtc-cmos.c                        |  52 +++++++++++-
 drivers/spi/spi-nuc900.c                      |   2 +
 drivers/staging/comedi/drivers/adv_pci1710.c  |  17 ++--
 drivers/staging/iio/adc/ad799x_core.c         |   3 +-
 drivers/staging/iio/magnetometer/ak8975.c     |  16 ++--
 drivers/tty/n_gsm.c                           |  11 +++
 drivers/usb/host/xhci-pci.c                   |   5 ++
 drivers/usb/serial/ftdi_sio.c                 |   3 +
 drivers/usb/serial/ftdi_sio_ids.h             |   7 ++
 drivers/usb/serial/option.c                   |   3 +-
 drivers/usb/storage/Kconfig                   |   4 +-
 drivers/usb/storage/scsiglue.c                |   6 ++
 drivers/usb/storage/unusual_cypress.h         |   2 +-
 drivers/usb/storage/unusual_devs.h            |   7 ++
 drivers/vme/bridges/vme_ca91cx42.c            |   4 +-
 fs/buffer.c                                   |   6 +-
 fs/file.c                                     |   2 +-
 fs/lockd/svclock.c                            |   8 ++
 include/linux/sched.h                         |   1 +
 kernel/irq/irqdesc.c                          |   1 +
 kernel/printk.c                               |   1 -
 kernel/sched/core.c                           |   3 -
 kernel/sched/fair.c                           |   7 +-
 kernel/sched/rt.c                             |  20 ++++-
 kernel/sched/sched.h                          |   1 -
 kernel/time/jiffies.c                         |   6 ++
 kernel/time/timekeeping.c                     |  14 ++--
 kernel/trace/ftrace.c                         | 112 +++++++++++++++++++++-----
 kernel/trace/ring_buffer.c                    |   7 ++
 lib/Makefile                                  |   1 +
 mm/page-writeback.c                           |   5 +-
 mm/swapfile.c                                 |  11 ++-
 net/mac80211/tx.c                             |   2 +-
 scripts/mod/file2alias.c                      |   4 +-
 security/selinux/ss/services.c                |   4 +
 sound/pci/hda/patch_analog.c                  |   6 ++
 sound/usb/Kconfig                             |   1 +
 virt/kvm/coalesced_mmio.c                     |   8 +-
 63 files changed, 614 insertions(+), 220 deletions(-)

Alan Stern (3):
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: enable multi-LUN scanning when needed

Axel Lin (1):
      spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->lsb is true

Beomho Seo (1):
      iio: ak8975: Fix calculation formula for convert micro tesla to gauss unit

Bjørn Mork (1):
      usb: ftdi_sio: add Mindstorms EV3 console adapter

Borislav Petkov (2):
      rtc-cmos: Add an alarm disable quirk
      EDAC: Correct workqueue setup path

Colin Cross (1):
      timekeeping: fix 32-bit overflow in get_monotonic_boottime

Dan Carpenter (1):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

Dave Airlie (1):
      drm/mgag200: fix typo causing bw limits to be ignored on some chips

Dave Jones (2):
      [media] mxl111sf: Fix unintentional garbage stack read
      [media] mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

David Vrabel (1):
      xen-blkfront: handle backend CLOSED without CLOSING

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

George Spelvin (1):
      ahci: add an observed PCI ID for Marvell 88se9172 SATA controller

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value

Harald Freudenberger (3):
      crypto: s390 - fix concurrency issue in aes-ctr mode
      crypto: s390 - fix des and des3_ede cbc concurrency issue
      crypto: s390 - fix des and des3_ede ctr concurrency issue

Hartmut Knaack (1):
      staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested

Jan Moskyto Matejka (1):
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Jens Axboe (1):
      block: add cond_resched() to potentially long running ioctl discard loop

Johannes Berg (1):
      mac80211: fix fragmentation code, particularly for encryption

John Stultz (1):
      timekeeping: Avoid possible deadlock from clock_was_set_delayed

KOSAKI Motohiro (2):
      mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of spin_lock_irq()
      mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

Krzysztof Kozlowski (1):
      power: max17040: Fix NULL pointer dereference when there is no platform_data

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control

Luis Henriques (1):
      Linux 3.5.7.31

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions

Martyn Welch (1):
      VME: Correct read/write alignment algorithm

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Mike Galbraith (1):
      sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Mikulas Patocka (2):
      time: Fix overflow when HZ is smaller than 60
      dm sysfs: fix a module unload race

Myron Stowe (1):
      ahci: Use PCI_VENDOR_ID_MARVELL_EXT for 0x1b4b

NeilBrown (1):
      lockd: send correct lock when granting a delayed lock.

Oleg Nesterov (1):
      md/raid5: Fix CPU hotplug callback registration

Oleksij Rempel (1):
      ath9k_htc: Do not support PowerSave by default

Paul Bolle (1):
      raw: test against runtime value of max_raw_minors

Paul E. McKenney (1):
      printk: Fix scheduling-while-atomic problem in console_cpu_notify()

Paul Gortmaker (1):
      genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n

Peter Boonstoppel (1):
      sched: Unthrottle rt runqueues in __disable_runtime()

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface

Sarah Sharp (1):
      xhci: Fix resume issues on Renesas chips in Samsung laptops

Stephen Smalley (1):
      SELinux:  Fix kernel BUG on empty security contexts.

Steven Rostedt (1):
      ftrace: Synchronize setting function_trace_op with ftrace_trace_function

Steven Rostedt (Red Hat) (3):
      ftrace: Fix synchronization location disabling and freeing ftrace_ops
      ftrace: Have function graph only trace based on global_ops filters
      ring-buffer: Fix first commit on sub-buffer having non-zero delta

Sujith Manoharan (1):
      ath9k: Do not support PowerSave by default

Takashi Iwai (2):
      ALSA: usb-audio: Add missing kconfig dependecy
      ALSA: hda - Improve loopback path lookups for AD1983

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs

Weijie Yang (1):
      mm/swap: fix race on swap_info reuse between swapoff and swapon

Yijing Wang (1):
      PCI: Enable ARI if dev and upstream bridge support it; disable otherwise

Ying Xue (1):
      sched/rt: Avoid updating RT entry timeout twice within one tick period

