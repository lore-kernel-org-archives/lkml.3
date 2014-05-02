Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaEBPjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:39:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEBPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y.z extended stable] Linux 3.13.11.1 stable review
Date: Fri,  2 May 2014 08:36:28 -0700
Message-Id: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11.1 stable kernel.

This version contains 151 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11.1 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 .../devicetree/bindings/spi/efm32-spi.txt          |   4 +-
 Documentation/video4linux/gspca.txt                |   1 +
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/boot/dts/am33xx.dtsi                      |   4 +-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   1 +
 arch/arm/include/asm/futex.h                       |   6 -
 arch/arm/include/asm/pgtable-2level.h              |   1 +
 arch/arm/mach-omap2/irq.c                          |   8 +
 arch/arm/mm/Kconfig                                |   3 +-
 arch/arm/mm/mmu.c                                  |  10 +
 arch/arm/mm/proc-macros.S                          |  19 +-
 arch/arm/mm/proc-v7-2level.S                       |   7 -
 arch/arm64/include/asm/pgtable.h                   |   8 +-
 arch/mips/kvm/kvm_mips_emul.c                      |   7 +-
 arch/mips/power/hibernate.S                        |   1 +
 arch/powerpc/include/asm/compat.h                  |   4 +
 arch/powerpc/kernel/process.c                      |  34 ++-
 arch/powerpc/kernel/signal_32.c                    |   2 +
 arch/powerpc/kernel/signal_64.c                    |   2 +
 arch/powerpc/kernel/tm.S                           |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/s390/include/asm/atomic.h                     |  70 +++---
 arch/s390/include/asm/bitops.h                     |  41 +--
 arch/s390/include/asm/ccwdev.h                     |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   3 +-
 arch/sh/kernel/dumpstack.c                         |   2 +-
 arch/x86/include/asm/cpufeature.h                  |   4 +
 arch/x86/include/asm/xsave.h                       |  13 +-
 arch/x86/kernel/ldt.c                              |  11 +
 block/blk-core.c                                   |   2 +-
 block/blk-mq.c                                     |   2 +-
 drivers/acpi/acpica/nsrepair.c                     |  25 +-
 drivers/block/mtip32xx/mtip32xx.c                  |  88 ++++---
 drivers/clk/clk-s2mps11.c                          |   2 +-
 drivers/gpio/gpio-mxs.c                            |   3 +-
 drivers/gpu/drm/armada/armada_crtc.c               |   1 +
 drivers/gpu/drm/i915/i915_drv.c                    |  90 +++++--
 drivers/gpu/drm/i915/i915_gem.c                    |   4 +-
 drivers/gpu/drm/i915/i915_trace.h                  |   4 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   8 +
 drivers/gpu/drm/i915/intel_display.c               |   3 +
 drivers/gpu/drm/i915/intel_pm.c                    |   4 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   9 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  12 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                      |   1 +
 drivers/gpu/drm/radeon/cik.c                       |   6 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   1 +
 drivers/gpu/drm/radeon/radeon_ring.c               |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |   5 +-
 drivers/infiniband/hw/ehca/ehca_cq.c               |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c           |  66 ++---
 drivers/infiniband/hw/mthca/mthca_provider.c       |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c              |   2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |   3 +-
 drivers/infiniband/hw/qib/qib_init.c               |  25 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  37 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  16 +-
 drivers/md/dm-cache-metadata.c                     |  98 +++++---
 drivers/md/dm-cache-metadata.h                     |   9 +-
 drivers/md/dm-cache-target.c                       |  63 +----
 drivers/md/dm-thin-metadata.c                      |  80 +++---
 drivers/md/dm-thin.c                               |   2 +-
 drivers/md/persistent-data/dm-block-manager.c      |  15 +-
 drivers/md/persistent-data/dm-block-manager.h      |   3 +-
 .../md/persistent-data/dm-transaction-manager.c    |   5 +-
 .../md/persistent-data/dm-transaction-manager.h    |  17 +-
 drivers/md/raid1.c                                 |  17 +-
 drivers/media/dvb-frontends/m88rs2000.c            |  19 +-
 drivers/media/platform/omap3isp/isppreview.c       |   9 +
 drivers/media/usb/em28xx/em28xx-dvb.c              |   3 +-
 drivers/media/usb/gspca/sn9c20x.c                  |   1 +
 drivers/media/usb/uvc/uvc_video.c                  |  20 +-
 drivers/mfd/88pm800.c                              |   3 +-
 drivers/mfd/88pm860x-core.c                        |   6 +
 drivers/mfd/Kconfig                                |   6 +-
 drivers/mfd/kempld-core.c                          |   7 +-
 drivers/mfd/max77686.c                             |   4 +
 drivers/mfd/max77693.c                             |  12 +-
 drivers/mfd/max8925-i2c.c                          |   9 +
 drivers/mfd/max8997.c                              |  18 ++
 drivers/mfd/max8998.c                              |   4 +
 drivers/mfd/sec-core.c                             |   4 +
 drivers/mfd/tps65910.c                             |   4 +-
 drivers/misc/mei/client.c                          |  76 ++++--
 drivers/misc/mei/client.h                          |  18 --
 drivers/mmc/host/sdhci-bcm-kona.c                  |   2 +-
 drivers/mtd/nand/atmel_nand.c                      |   1 +
 drivers/net/wireless/ath/ath9k/xmit.c              |   2 +-
 drivers/net/wireless/b43/phy_n.c                   |  14 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   8 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        |  20 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |  15 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |  27 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        |  18 +-
 drivers/pci/host/pci-mvebu.c                       |   2 +-
 drivers/pci/pci.c                                  |   3 -
 drivers/platform/x86/thinkpad_acpi.c               |  12 +
 drivers/regulator/arizona-ldo1.c                   |   7 +-
 drivers/s390/char/con3215.c                        |   2 +-
 drivers/s390/char/con3270.c                        |   6 +-
 drivers/s390/char/raw3270.c                        |  10 +-
 drivers/s390/char/raw3270.h                        |   2 +-
 drivers/s390/cio/device.c                          |   3 +-
 drivers/spi/spi-efm32.c                            |   3 +
 drivers/staging/serqt_usb2/serqt_usb2.c            |   2 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/target/target_core_sbc.c                   |   3 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   1 +
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/usb/core/driver.c                          |  94 ++++---
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/usb.h                             |   2 +-
 drivers/usb/dwc3/core.h                            |  36 ++-
 drivers/usb/dwc3/gadget.h                          |  12 -
 drivers/usb/gadget/atmel_usba_udc.c                |   6 +-
 drivers/usb/gadget/tcm_usb_gadget.c                |   2 +-
 drivers/usb/host/xhci-pci.c                        |  11 +-
 drivers/usb/musb/musb_core.c                       |   5 +-
 drivers/usb/phy/phy-ulpi.c                         |   2 +
 drivers/video/aty/mach64_accel.c                   |   3 +-
 drivers/video/aty/mach64_cursor.c                  |  22 +-
 drivers/video/cfbcopyarea.c                        | 153 +++++------
 drivers/video/matrox/matroxfb_accel.c              |  38 ++-
 drivers/video/matrox/matroxfb_base.h               |   2 +
 drivers/video/tgafb.c                              | 279 +++++----------------
 drivers/virtio/virtio_balloon.c                    |   6 +
 drivers/w1/w1_netlink.c                            |  25 +-
 fs/aio.c                                           | 120 +++++----
 fs/dcache.c                                        |   9 +-
 fs/file_table.c                                    |   4 +-
 fs/lockd/svc.c                                     |   1 +
 fs/namespace.c                                     |  11 +-
 fs/nfs/nfs4proc.c                                  |  19 +-
 fs/nfsd/nfs4proc.c                                 |   9 +-
 fs/nfsd/nfs4state.c                                |  13 +-
 fs/nfsd/nfs4xdr.c                                  |   5 +
 fs/nfsd/nfsctl.c                                   |   5 +
 fs/nfsd/nfsd.h                                     |   2 +-
 fs/nfsd/vfs.c                                      |   9 +
 fs/ocfs2/buffer_head_io.c                          |   2 -
 fs/ocfs2/dlm/dlmrecovery.c                         |  29 ++-
 fs/ocfs2/namei.c                                   |   2 -
 fs/open.c                                          |  26 +-
 fs/pnode.c                                         | 198 +++++++++------
 fs/pnode.h                                         |   3 +
 fs/reiserfs/dir.c                                  |   6 +-
 include/linux/mount.h                              |   3 +
 include/linux/sched.h                              |  20 +-
 include/linux/sunrpc/svcsock.h                     |   1 +
 include/trace/events/block.h                       |  33 ++-
 include/uapi/linux/libc-compat.h                   |   9 +
 include/uapi/linux/xattr.h                         |   7 +
 kernel/audit.c                                     |   8 +-
 kernel/auditsc.c                                   |   2 +-
 kernel/sysctl.c                                    |   6 +
 kernel/trace/blktrace.c                            |  20 +-
 lib/percpu_counter.c                               |   2 +-
 mm/hugetlb.c                                       |   1 +
 mm/internal.h                                      |   1 +
 mm/mlock.c                                         |   2 +
 mm/page_alloc.c                                    |  89 +++----
 mm/rmap.c                                          |  14 +-
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/mlme.c                                |  28 ++-
 net/mac80211/pm.c                                  |  14 +-
 net/mac80211/tx.c                                  |   2 +-
 net/netfilter/nfnetlink_queue_core.c               |  31 ++-
 net/sunrpc/svcsock.c                               |  16 ++
 sound/pci/hda/patch_realtek.c                      |  95 ++++++-
 sound/pci/ice1712/ice1712.c                        |  15 +-
 sound/soc/codecs/cs42l51.c                         |   9 +-
 sound/soc/codecs/cs42l52.c                         |   8 +-
 sound/soc/codecs/cs42l73.c                         |   6 +-
 174 files changed, 1824 insertions(+), 1200 deletions(-)

Al Viro (3):
      __dentry_path() fixes
      smarter propagate_mnt()
      don't bother with {get,put}_write_access() on non-regular files

Alan Stern (1):
      USB: unbind all interfaces before rebinding any

Alex Deucher (3):
      drm/radeon: call drm_edid_to_eld when we update the edid
      drm/radeon: fix endian swap on hawaii clear state buffer setup
      drm/radeon: fix typo in spectre_golden_registers

Andrew Lunn (1):
      ARM: Fix default CPU selection for ARCH_MULTI_V5

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg

Anton Blanchard (2):
      powerpc/compat: 32-bit little endian machine name is ppcle, not ppc
      KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=n

Antti Palosaari (1):
      [media] em28xx: fix PCTV 290e LNA oops

Benjamin LaHaise (1):
      aio: v4 ensure access to ctx->ring_pages is correctly serialised for migration

Brian Austin (3):
      ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and Analog kcontrols

Catalin Marinas (2):
      arm64: Make DMA coherent and strongly ordered mappings not executable
      arm64: Do not synchronise I and D caches for special ptes

Charles Keepax (1):
      regulator: arizona-ldo1: Correct default regulator init_data

Chris Wilson (1):
      drm/i915: Fix unsafe loop iteration over vma whilst unbinding them

Christian Borntraeger (1):
      KVM: s390: Optimize ucontrol path

Christian König (1):
      drm/radeon: clear needs_reset flag if IB test fails

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length

Dave Airlie (1):
      drm/nouveau: don't suspend/resume display on runtime s/r

David Fries (1):
      w1: fix w1_send_slave dropping a slave id

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet routine

Emmanuel Grumbach (2):
      iwlwifi: dvm: take mutex when sending SYNC BT config command
      iwlwifi: mvm: disable uAPSD due to bugs in the firmware

Felipe Balbi (2):
      usb: musb: avoid NULL pointer dereference
      usb: dwc3: fix randconfig build errors

Felipe Franciosi (2):
      mtip32xx: Set queue bounce limit
      mtip32xx: Unmap the DMA segments before completing the IO request

Felix Fietkau (1):
      ath9k: fix ready time of the multicast buffer queue

Fenghua Yu (2):
      x86, AVX-512: AVX-512 Feature Detection
      x86, AVX-512: Enable AVX-512 States Context Switch

Florian Vaussard (1):
      [media] omap3isp: preview: Fix the crop margins

Giacomo Comes (1):
      Skip intel_crt_init for Dell XPS 8700

Gregory CLEMENT (1):
      usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled

Guenter Roeck (1):
      mfd: kempld-core: Fix potential hang-up during boot

H. Peter Anvin (1):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Heiko Carstens (1):
      s390/bitops,atomic: add missing memory barriers

Herve Codina (1):
      mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

Hui Wang (2):
      ALSA: hda - add headset mic detect quirks for three Dell laptops
      ALSA: hda - add headset mic detect quirk for a Dell laptop

Imre Deak (1):
      drm/i915: move power domain init earlier during system resume

J. Bruce Fields (6):
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
      nfsd4: session needs room for following op to error out
      nfsd4: leave reply buffer space for failed setattr
      nfsd4: fix test_stateid error reply encoding
      nfsd: notify_change needs elevated write count
      nfsd4: fix setclientid encode size

James Hogan (1):
      MIPS: KVM: Pass reserved instruction exceptions to guest

Jani Nikula (2):
      drm/i915: quirk invert brightness for Acer Aspire 5336
      drm/i915/tv: fix gen4 composite s-video tv-out

Jean-Jacques Hiblot (1):
      PCI: mvebu: Fix potential issue in range parsing

Jeff Layton (1):
      lockd: ensure we tear down any live sockets when socket creation fails during lockd_up

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Jens Axboe (1):
      lib/percpu_counter.c: fix bad percpu counter state during suspend

Joe Thornber (3):
      dm transaction manager: fix corruption due to non-atomic transaction commit
      dm: take care to copy the space map roots before locking the superblock
      dm cache: fix a lock-inversion

Johannes Berg (2):
      mac80211: fix potential use-after-free
      mac80211: fix suspend vs. authentication race

Johannes Weiner (1):
      mm: page_alloc: spill to remote nodes before waking kswapd

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
      ocfs2: dlm: fix recovery hung

Kailang Yang (1):
      ALSA: hda/realtek - Restore default value for ALC283

Kamal Mostafa (1):
      [3.13-stable] Revert "PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled"

Kees Cook (1):
      usb: gadget: tcm_usb_gadget: stop format strings

Kinglong Mee (1):
      NFSD: Traverse unconfirmed client through hash-table

Krzysztof Kozlowski (11):
      mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
      mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max77686: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: 88pm860x: Fix I2C device resource leak on regmap init fail
      mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy error
      mfd: 88pm800: Fix I2C device resource leak if probe fails
      mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail
      clk: s2mps11: Fix possible NULL pointer dereference

Larry Finger (4):
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix too long disable of IRQs
      rtlwifi: rtl8188ee: Fix too long disable of IRQs
      rtlwifi: rtl8723ae: Fix too long disable of IRQs

Linus Walleij (1):
      mfd: Include all drivers in subsystem menu

Liu Hua (1):
      hung_task: check the value of "sysctl_hung_task_timeout_sec"

Lv Zheng (1):
      ACPICA: Restore code that repairs NULL package elements in return values.

Maarten Lankhorst (1):
      drm/qxl: unset a pointer in sync_obj_unref

Malcolm Priestley (2):
      [media] m88rs2000: add caps FE_CAN_INVERSION_AUTO
      [media] m88rs2000: prevent frontend crash on continuous transponder scans

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

Martin Svec (1):
      Target/sbc: Initialize COMPARE_AND_WRITE write_sg scatterlist

Mathias Nyman (1):
      xhci: Prevent runtime pm from autosuspending during initialization

Matt Fleming (1):
      sh: fix format string bug in stack tracer

Michael Braun (1):
      mac80211: fix WPA with VLAN on AP side with ps-sta again

Michael Neuling (1):
      powerpc/tm: Disable IRQ in tm_recheckpoint

Michal Simek (1):
      usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210

Mike Marciniszyn (2):
      IB/qib: Fix debugfs ordering issue with multiple HCAs
      ib_srpt: Use correct ib_sg_dma primitives

Mike Snitzer (2):
      dm cache: prevent corruption caused by discard_block_size > cache_block_size
      dm thin: fix dangling bio in process_deferred_bios error path

Mikulas Patocka (6):
      matroxfb: restore the registers M_ACCESS and M_PITCH
      framebuffer: fix cfb_copyarea
      mach64: use unaligned access
      mach64: fix cursor when character width is not a multiple of 8 pixels
      tgafb: fix mode setting with fbset
      tgafb: fix data copying

Mizuma, Masayoshi (1):
      mm: hugetlb: fix softlockup when a large number of hugepages are freed.

Mugunthan V N (1):
      ARM: dts: am33xx: correcting dt node unit address for usb

NeilBrown (1):
      md/raid1: r1buf_pool_alloc: free allocate pages when subsequent allocation fails.

Nicholas Bellinger (2):
      iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err
      iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug

Oleksij Rempel (1):
      [media] uvcvideo: Do not use usb_set_interface on bulk EP

Paul Gortmaker (1):
      hvc: ensure hvc_init is only ever called once in hvc_console.c

Rafał Miłecki (1):
      b43: Fix machine check error due to improper access of B43_MMIO_PSM_PHY_HDR

Richard Guy Briggs (3):
      pid: get pid_t ppid of task in init_pid_ns
      audit: restore order of tty and ses fields in log output
      audit: convert PPIDs to the inital PID namespace.

Roman Pen (1):
      blktrace: fix accounting of partially completed requests

Russell King (2):
      mmc: sdhci-bcm-kona: fix build errors when built-in
      DRM: armada: fix corruption while loading cursors

Rusty Russell (1):
      virtio_balloon: don't softlockup on huge balloon changes.

Sam Bradshaw (1):
      mtip32xx: mtip_async_complete() bug fixes

Sebastian Ott (1):
      s390/cio: fix driver callback initialization for ccw consoles

Serge Hallyn (1):
      xattr: guard against simultaneous glibc header inclusion

Stanislav Kinsbursky (1):
      nfsd: check passed socket's net matches NFSd superblock's one

Stefan Sørensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Steven Rostedt (1):
      drm/i915: Do not dereference pointers from ring buffer in evict event

Takashi Iwai (3):
      ALSA: hda - Fix silent speaker output due to mute LED fixup
      thinkpad_acpi: Fix inconsistent mute LED after resume
      ALSA: ice1712: Fix boundary checks in PCM pointer ops

Tetsuo Handa (1):
      ocfs2: fix panic on kfree(xattr->name)

Tomas Winkler (1):
      mei: fix memory leak of pending write cb objects

Tomasz Figa (1):
      ARM: dts: Keep G3D regulator always on for exynos5250-arndale

Trond Myklebust (1):
      NFSv4: Fix a use-after-free problem in open()

Uwe Kleine-König (1):
      spi: efm32: use $vendor,$device scheme for compatible string

Ville Syrjälä (1):
      drm/i915: Don't clobber CHICKEN_PIPESL_1 on BDW

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking

W. Trevor King (1):
      ALSA: hda - Enable beep for ASUS 1015E

Will Deacon (1):
      ARM: 7954/1: mm: remove remaining domain support from ARMv6

Wolfram Sang (1):
      [media] media: gspca: sn9c20x: add ID for Genius Look 1320 V2

Yann Droneaud (4):
      IB/qib: add missing braces in do_qib_user_sdma_queue_create()
      IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL
      IB/mthca: Return an error on ib_copy_to_udata() failure
      IB/ehca: Returns an error on ib_copy_to_udata() failure

Zoltan Kiss (1):
      core, nfqueue, openvswitch: Orphan frags in skb_zerocopy and handle errors

alex chen (1):
      ocfs2: do not put bh when buffer_uptodate failed
