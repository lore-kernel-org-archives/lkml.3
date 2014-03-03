Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaCCS4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:56:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbaCCS4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:56:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.8.y.z extended stable] Linux 3.8.13.19 stable review
Date: Mon,  3 Mar 2014 10:54:48 -0800
Message-Id: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.19 stable kernel.

This version contains 67 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.19 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/arm64/include/asm/cacheflush.h           |   1 +
 arch/arm64/kernel/vdso.c                      |   4 +-
 arch/arm64/kernel/vdso/Makefile               |   2 +-
 arch/arm64/kernel/vdso/gettimeofday.S         |   7 +-
 arch/arm64/mm/mmu.c                           |  12 ++-
 arch/s390/crypto/aes_s390.c                   |  65 +++++++----
 arch/s390/crypto/des_s390.c                   |  95 ++++++++++------
 arch/s390/mm/page-states.c                    |  10 ++
 arch/x86/kernel/cpu/common.c                  |   7 +-
 arch/x86/kernel/ftrace.c                      |  83 +++++++-------
 arch/x86/kvm/lapic.c                          |   3 +-
 arch/x86/mm/fault.c                           |  14 ++-
 block/blk-lib.c                               |   8 ++
 block/blk.h                                   |   2 +-
 crypto/ansi_cprng.c                           |   4 +-
 drivers/block/xen-blkfront.c                  |   5 +-
 drivers/char/raw.c                            |   2 +-
 drivers/edac/edac_mc.c                        |  13 ++-
 drivers/edac/edac_mc_sysfs.c                  |  12 ++-
 drivers/edac/edac_module.h                    |   2 +-
 drivers/gpu/drm/ast/ast_fb.c                  |   2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c         |   2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c          |   2 +-
 drivers/hv/connection.c                       |  12 +--
 drivers/infiniband/hw/qib/qib_iba7322.c       |   5 +
 drivers/md/raid5.c                            |  90 ++++++++--------
 drivers/media/usb/dvb-usb-v2/af9035.c         |   2 +
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |   2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c      |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  25 ++---
 drivers/net/wireless/ath/ath9k/init.c         |   8 +-
 drivers/of/address.c                          |   9 +-
 drivers/power/max17040_battery.c              |   5 +-
 drivers/spi/spi-nuc900.c                      |   2 +
 drivers/staging/comedi/drivers/adv_pci1710.c  |  17 ++-
 drivers/staging/iio/adc/ad799x_core.c         |   3 +-
 drivers/tty/n_gsm.c                           |  11 ++
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
 fs/buffer.c                                   |   6 +-
 fs/file.c                                     |   2 +-
 fs/lockd/svclock.c                            |   8 ++
 fs/xfs/xfs_ioctl.c                            |   3 +-
 fs/xfs/xfs_ioctl32.c                          |   3 +-
 include/linux/compiler-gcc4.h                 |   6 +-
 include/uapi/xen/Kbuild                       |   2 +
 include/uapi/xen/gntalloc.h                   |  82 ++++++++++++++
 include/uapi/xen/gntdev.h                     | 150 ++++++++++++++++++++++++++
 include/xen/gntalloc.h                        |  82 --------------
 include/xen/gntdev.h                          | 150 --------------------------
 kernel/irq/irqdesc.c                          |   1 +
 kernel/time/jiffies.c                         |   6 ++
 kernel/trace/ring_buffer.c                    |   7 ++
 lib/Makefile                                  |   1 +
 mm/page-writeback.c                           |   5 +-
 mm/swapfile.c                                 |  11 +-
 net/mac80211/cfg.c                            |  41 +++----
 net/mac80211/ibss.c                           |   5 +-
 net/mac80211/tx.c                             |   2 +-
 net/netfilter/nf_nat_irc.c                    |  28 ++++-
 scripts/mod/file2alias.c                      |   4 +-
 security/selinux/ss/services.c                |   4 +
 sound/pci/hda/patch_realtek.c                 |   1 +
 virt/kvm/coalesced_mmio.c                     |   8 +-
 74 files changed, 731 insertions(+), 490 deletions(-)

Alan Stern (3):
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: enable multi-LUN scanning when needed

Andrew Jones (1):
      kvm: x86: fix apic_base enable check

Antti Palosaari (1):
      [media] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Axel Lin (1):
      spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->lsb is true

Benjamin Herrenschmidt (1):
      of: Fix address decoding on Bimini and js2x machines

Bjørn Mork (2):
      usb: ftdi_sio: add Mindstorms EV3 console adapter
      usb: qcserial: add Netgear Aircard 340U

Borislav Petkov (2):
      EDAC: Poll timeout cannot be zero, p2
      EDAC: Correct workqueue setup path

Catalin Marinas (1):
      arm64: Invalidate the TLB when replacing pmd entries during boot

Dan Carpenter (2):
      xfs: underflow bug in xfs_attrlist_by_handle()
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

Daniel Borkmann (1):
      netfilter: nf_nat: fix access to uninitialized buffer in IRC NAT helper

Dave Airlie (1):
      drm/mgag200,ast,cirrus: fix regression with drm_can_sleep conversion

Dave Jones (2):
      [media] mxl111sf: Fix unintentional garbage stack read
      [media] mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

David Vrabel (2):
      xen-blkfront: handle backend CLOSED without CLOSING
      xen: install xen/gntdev.h and xen/gntalloc.h

Eliad Peller (1):
      mac80211: move roc cookie assignment earlier

Emmanuel Grumbach (1):
      mac80211: release the channel in error path in start_ap

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value

H. Peter Anvin (2):
      x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
      x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off

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

K. Y. Srinivasan (1):
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

Martyn Welch (1):
      VME: Correct read/write alignment algorithm

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Mikulas Patocka (1):
      time: Fix overflow when HZ is smaller than 60

Nathan Lynch (2):
      arm64: vdso: fix coarse clock handling
      arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

NeilBrown (1):
      lockd: send correct lock when granting a delayed lock.

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

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface

Stanislaw Gruszka (1):
      ath9k_htc: make ->sta_rc_update atomic for most calls

Stephen Smalley (1):
      SELinux:  Fix kernel BUG on empty security contexts.

Steven Noonan (1):
      compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

Steven Rostedt (Red Hat) (2):
      ring-buffer: Fix first commit on sub-buffer having non-zero delta
      ftrace/x86: Use breakpoints for converting function graph caller

Sujith Manoharan (2):
      ath9k: Do not support PowerSave by default
      mac80211: Fix IBSS disconnect

Takashi Iwai (1):
      ALSA: hda - Fix mic capture on Sony VAIO Pro 11

Tejun Heo (1):
      block: __elv_next_request() shouldn't call into the elevator if bypassing

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs

Vinayak Kale (1):
      arm64: add DSB after icache flush in __flush_icache_all()

Weijie Yang (1):
      mm/swap: fix race on swap_info reuse between swapoff and swapon

Will Deacon (1):
      arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k
