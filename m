Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbaD2I6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:58:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49198 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbaD2I6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:58:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.11.y.z extended stable] Linux 3.11.10.9
Date: Tue, 29 Apr 2014 09:58:27 +0100
Message-Id: <1398761908-5320-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.11.10.9 kernel.

The updated 3.11.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.11.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.11.y;a=shortlog

The diff from v3.11.10.8 is posted as a follow-up to this email.

The 3.11.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Documentation/sysctl/kernel.txt                    |  11 +
 Documentation/video4linux/gspca.txt                |   1 +
 Makefile                                           |   2 +-
 arch/arc/boot/dts/nsimosci.dts                     |  12 +-
 arch/arc/configs/nsimosci_defconfig                |   1 +
 arch/arm/Kconfig                                   |   2 +-
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
 arch/parisc/kernel/syscall_table.S                 |   2 +-
 arch/powerpc/include/asm/compat.h                  |   4 +
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/s390/include/asm/ccwdev.h                     |   2 +-
 arch/sh/kernel/dumpstack.c                         |   2 +-
 arch/x86/include/asm/cpufeature.h                  |   5 +
 arch/x86/kernel/cpu/mshyperv.c                     |   6 +
 arch/x86/kernel/early-quirks.c                     |  15 +-
 arch/x86/kernel/ldt.c                              |  11 +
 block/blk-core.c                                   |   2 +-
 drivers/acpi/acpica/nsrepair.c                     |  25 +-
 drivers/acpi/button.c                              |   4 +
 drivers/base/topology.c                            |   3 +-
 drivers/block/mtip32xx/mtip32xx.c                  |  25 +-
 drivers/char/ipmi/ipmi_bt_sm.c                     |   2 +-
 drivers/char/ipmi/ipmi_kcs_sm.c                    |   5 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  46 ++--
 drivers/gpio/gpio-mxs.c                            |   3 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   8 +
 drivers/gpu/drm/i915/intel_display.c               |   3 +
 drivers/gpu/drm/i915/intel_tv.c                    |   9 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                      |   1 +
 drivers/gpu/drm/radeon/cik.c                       |   2 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   1 +
 drivers/gpu/drm/radeon/radeon_kms.c                |   5 +-
 drivers/gpu/drm/radeon/radeon_ucode.h              |   3 +
 drivers/gpu/drm/radeon/si.c                        |  37 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |   5 +-
 drivers/gpu/host1x/hw/intr_hw.c                    |   4 +-
 drivers/hv/connection.c                            |   5 +-
 drivers/infiniband/hw/ehca/ehca_cq.c               |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c           |  66 ++---
 drivers/infiniband/hw/mthca/mthca_provider.c       |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c              |   2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |   3 +-
 drivers/infiniband/hw/qib/qib_init.c               |  25 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  16 +-
 drivers/md/dm-cache-metadata.c                     |  98 ++++---
 drivers/md/dm-cache-metadata.h                     |   9 +-
 drivers/md/dm-cache-target.c                       |  65 +----
 drivers/md/dm-thin-metadata.c                      |  80 +++---
 drivers/md/dm-thin.c                               |   2 +-
 drivers/md/persistent-data/dm-block-manager.c      |  15 +-
 drivers/md/persistent-data/dm-block-manager.h      |   3 +-
 .../md/persistent-data/dm-transaction-manager.c    |   5 +-
 .../md/persistent-data/dm-transaction-manager.h    |  17 +-
 drivers/md/raid1.c                                 |  17 +-
 drivers/media/dvb-frontends/m88rs2000.c            |  19 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |   4 +-
 drivers/media/platform/omap3isp/isppreview.c       |   9 +
 drivers/media/usb/em28xx/em28xx-dvb.c              |   3 +-
 drivers/media/usb/gspca/sn9c20x.c                  |   1 +
 drivers/media/usb/uvc/uvc_video.c                  |  20 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 drivers/mfd/88pm800.c                              |   3 +-
 drivers/mfd/88pm860x-core.c                        |   6 +
 drivers/mfd/Kconfig                                |   5 +-
 drivers/mfd/kempld-core.c                          |   7 +-
 drivers/mfd/max77686.c                             |   4 +
 drivers/mfd/max77693.c                             |  12 +-
 drivers/mfd/max8925-i2c.c                          |   9 +
 drivers/mfd/max8997.c                              |  18 ++
 drivers/mfd/max8998.c                              |   4 +
 drivers/mfd/sec-core.c                             |   4 +
 drivers/mfd/tps65910.c                             |   4 +-
 drivers/misc/mei/client.c                          |  76 ++++--
 drivers/misc/mei/client.h                          |  17 --
 drivers/misc/mei/hw-me-regs.h                      |   5 +
 drivers/misc/mei/interrupt.c                       |   3 +-
 drivers/misc/mei/main.c                            |   3 +-
 drivers/misc/mei/pci-me.c                          |  30 ++-
 drivers/mtd/nand/atmel_nand.c                      |   1 +
 drivers/net/ethernet/marvell/mvneta.c              |  41 ++-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c         |   1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   6 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   1 -
 drivers/net/wireless/ath/ath9k/xmit.c              |   2 +-
 drivers/net/wireless/b43/phy_n.c                   |  14 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  14 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   8 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        |  20 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |  15 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |  27 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        |  18 +-
 drivers/regulator/arizona-ldo1.c                   |   7 +-
 drivers/s390/char/con3215.c                        |   2 +-
 drivers/s390/char/con3270.c                        |   6 +-
 drivers/s390/char/raw3270.c                        |  10 +-
 drivers/s390/char/raw3270.h                        |   2 +-
 drivers/s390/cio/device.c                          |   3 +-
 drivers/staging/comedi/drivers/8255_pci.c          |  34 +++
 drivers/staging/rtl8712/rtl871x_recv.c             |  13 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   2 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   1 +
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/tty_io.c                               |  23 +-
 drivers/usb/class/cdc-acm.c                        |  28 +-
 drivers/usb/core/driver.c                          |  94 ++++---
 drivers/usb/core/hcd-pci.c                         |   2 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/usb.h                             |   2 +-
 drivers/usb/dwc3/core.h                            |  36 ++-
 drivers/usb/dwc3/gadget.h                          |  12 -
 drivers/usb/gadget/atmel_usba_udc.c                |   6 +-
 drivers/usb/gadget/tcm_usb_gadget.c                |   2 +-
 drivers/usb/host/xhci-pci.c                        |  11 +-
 drivers/usb/musb/musb_core.c                       |   5 +-
 drivers/usb/phy/phy-ulpi.c                         |   2 +
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |  33 +++
 drivers/usb/serial/ftdi_sio_ids.h                  |  37 +++
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/serial/pl2303.c                        |   3 +
 drivers/usb/serial/pl2303.h                        |   5 +-
 drivers/usb/serial/sierra.c                        |   1 -
 drivers/usb/serial/usb_wwan.c                      |   9 +-
 drivers/video/aty/mach64_accel.c                   |   3 +-
 drivers/video/aty/mach64_cursor.c                  |  22 +-
 drivers/video/cfbcopyarea.c                        | 153 +++++------
 drivers/video/matrox/matroxfb_accel.c              |  38 ++-
 drivers/video/matrox/matroxfb_base.h               |   2 +
 drivers/video/tgafb.c                              | 283 +++++----------------
 drivers/virtio/virtio_balloon.c                    |   6 +
 drivers/w1/w1_netlink.c                            |  25 +-
 fs/btrfs/disk-io.c                                 |   4 +
 fs/btrfs/transaction.c                             |  14 +-
 fs/coredump.c                                      |   7 +-
 fs/ext4/extents.c                                  |  40 ++-
 fs/file_table.c                                    |   4 +-
 fs/fs-writeback.c                                  |  31 ++-
 fs/jffs2/compr_rtime.c                             |   4 +-
 fs/jffs2/nodelist.h                                |   2 +-
 fs/jffs2/nodemgmt.c                                |  14 +-
 fs/lockd/svc.c                                     |   1 +
 fs/nfs/nfs4proc.c                                  |  19 +-
 fs/nfsd/nfs4proc.c                                 |   9 +-
 fs/nfsd/nfs4state.c                                |  13 +-
 fs/nfsd/nfs4xdr.c                                  |   5 +
 fs/nfsd/nfsctl.c                                   |   5 +
 fs/nfsd/nfsd.h                                     |   2 +-
 fs/nfsd/vfs.c                                      |   9 +
 fs/ocfs2/buffer_head_io.c                          |   2 -
 fs/ocfs2/dlm/dlmrecovery.c                         |  29 ++-
 fs/open.c                                          |  26 +-
 fs/reiserfs/dir.c                                  |   6 +-
 fs/xattr_acl.c                                     |   5 +-
 fs/xfs/xfs_da_btree.c                              |   2 +-
 include/asm-generic/pgtable.h                      |  31 ++-
 include/linux/backing-dev.h                        |   2 +-
 include/linux/hyperv.h                             |   4 +-
 include/linux/sched.h                              |  20 +-
 include/linux/sunrpc/svcsock.h                     |   1 +
 include/trace/events/block.h                       |  33 ++-
 include/uapi/drm/tegra_drm.h                       |   1 -
 kernel/audit.c                                     |   4 +-
 kernel/auditsc.c                                   |   2 +-
 kernel/exit.c                                      |  21 +-
 kernel/pid_namespace.c                             |   4 +-
 kernel/sysctl.c                                    |   6 +
 kernel/time/tick-common.c                          |   2 +-
 kernel/trace/blktrace.c                            |  20 +-
 kernel/user_namespace.c                            |  11 +-
 lib/percpu_counter.c                               |   2 +-
 mm/backing-dev.c                                   |  16 +-
 mm/hugetlb.c                                       |   2 +
 mm/mlock.c                                         |   2 +
 mm/rmap.c                                          |  14 +-
 net/bluetooth/hci_event.c                          |   8 +-
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/main.c                                |   2 +
 net/mac80211/mlme.c                                |  28 +-
 net/mac80211/offchannel.c                          |   1 +
 net/mac80211/pm.c                                  |  14 +-
 net/mac80211/tx.c                                  |   2 +-
 net/sunrpc/svcsock.c                               |  16 ++
 sound/pci/hda/patch_realtek.c                      |  11 +-
 sound/pci/ice1712/ice1712.c                        |  15 +-
 sound/soc/codecs/cs42l51.c                         |   9 +-
 sound/soc/codecs/cs42l52.c                         |   8 +-
 sound/soc/codecs/cs42l73.c                         |   6 +-
 198 files changed, 1666 insertions(+), 1059 deletions(-)

Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize

Al Viro (1):
      don't bother with {get,put}_write_access() on non-regular files

Alan Stern (2):
      USB: unbind all interfaces before rebinding any
      USB: fix crash during hotplug of PCI USB controller card

Alex Deucher (4):
      drm/radeon: call drm_edid_to_eld when we update the edid
      drm/radeon: fix typo in spectre_golden_registers
      drm/radeon: add support for newer mc ucode on SI (v2)
      drm/radeon/si: make sure mc ucode is loaded before checking the size

Alexander Usyskin (1):
      mei: ignore client writing state during cb completion

Andrew Lunn (1):
      ARM: Fix default CPU selection for ARCH_MULTI_V5

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg

Anton Blanchard (2):
      powerpc/compat: 32-bit little endian machine name is ppcle, not ppc
      KVM: PPC: Book3S HV: Fix KVM hang with CONFIG_KVM_XICS=n

Antti Palosaari (1):
      [media] em28xx: fix PCTV 290e LNA oops

Bodo Stroesser (1):
      ipmi: Fix a race restarting the timer

Brian Austin (3):
      ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and Analog kcontrols

Catalin Marinas (2):
      arm64: Make DMA coherent and strongly ordered mappings not executable
      arm64: Do not synchronise I and D caches for special ptes

Charles Keepax (1):
      regulator: arizona-ldo1: Correct default regulator init_data

Chris Mason (1):
      mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length

Claudio Takahasi (1):
      Bluetooth: Fix removing Long Term Key

Corey Minyard (1):
      ipmi: Reset the KCS timeout when starting error recovery

Dan Carpenter (2):
      tgafb: potential NULL dereference in init
      fs: NULL dereference in posix_acl_to_xattr()

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2

David Fries (1):
      w1: fix w1_send_slave dropping a slave id

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet routine

Derek Basehore (1):
      backing_dev: fix hung task on sync

Emil Goode (1):
      brcmsmac: fix deadlock on missing firmware

Emmanuel Grumbach (1):
      iwlwifi: dvm: take mutex when sending SYNC BT config command

Eric Dumazet (1):
      coredump: fix va_list corruption

Eric Whitney (3):
      ext4: fix error return from ext4_ext_handle_uninitialized_extents()
      ext4: fix partial cluster handling for bigalloc file systems
      ext4: fix premature freeing of partial clusters split across leaf blocks

Felipe Balbi (2):
      usb: musb: avoid NULL pointer dereference
      usb: dwc3: fix randconfig build errors

Felipe Franciosi (2):
      mtip32xx: Set queue bounce limit
      mtip32xx: Unmap the DMA segments before completing the IO request

Felix Fietkau (2):
      mac80211: exclude AP_VLAN interfaces from tx power calculation
      ath9k: fix ready time of the multicast buffer queue

Fenghua Yu (1):
      x86, AVX-512: AVX-512 Feature Detection

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

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Hans Verkuil (2):
      [media] v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support
      [media] saa7134: fix WARN_ON during resume

Helge Deller (1):
      parisc: fix epoll_pwait syscall on compat kernel

Herve Codina (1):
      mtd: atmel_nand: Disable subpage NAND write when using Atmel PMECC

Hidetoshi Seto (1):
      Btrfs: skip submitting barrier for missing device

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

Hui Wang (1):
      ALSA: hda - add headset mic detect quirk for a Dell laptop

Ian Abbott (1):
      staging: comedi: 8255_pci: initialize MITE data window

J. Bruce Fields (6):
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
      nfsd4: session needs room for following op to error out
      nfsd4: leave reply buffer space for failed setattr
      nfsd4: fix test_stateid error reply encoding
      nfsd: notify_change needs elevated write count
      nfsd4: fix setclientid encode size

James Hogan (1):
      MIPS: KVM: Pass reserved instruction exceptions to guest

Jan Kara (1):
      bdi: avoid oops on device removal

Jani Nikula (2):
      drm/i915: quirk invert brightness for Acer Aspire 5336
      drm/i915/tv: fix gen4 composite s-video tv-out

Jason Wang (1):
      x86, hyperv: Bypass the timer_irq_works() check

Jeff Layton (1):
      lockd: ensure we tear down any live sockets when socket creation fails during lockd_up

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Jens Axboe (1):
      lib/percpu_counter.c: fix bad percpu counter state during suspend

Jiri Slaby (1):
      Char: ipmi_bt_sm, fix infinite loop

Joe Thornber (3):
      dm transaction manager: fix corruption due to non-atomic transaction commit
      dm: take care to copy the space map roots before locking the superblock
      dm cache: fix a lock-inversion

Johan Hovold (2):
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
      USB: usb_wwan: fix handling of missing bulk endpoints

Johannes Berg (3):
      mac80211: fix potential use-after-free
      mac80211: fix suspend vs. authentication race
      mac80211: fix software remain-on-channel implementation

Josef Bacik (1):
      Btrfs: fix deadlock with nested trans handles

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
      ocfs2: dlm: fix recovery hung

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC288 codec
      ALSA: hda/realtek - Add headset Mic support for Dell machine

Kamlakant Patel (1):
      jffs2: Fix segmentation fault found in stress test

Kees Cook (1):
      usb: gadget: tcm_usb_gadget: stop format strings

Kinglong Mee (1):
      NFSD: Traverse unconfirmed client through hash-table

Krzysztof Kozlowski (10):
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

Lan Tianyu (1):
      ACPI / button: Add ACPI Button event via netlink routine

Larry Finger (5):
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
      rtlwifi: rtl8192se: Fix too long disable of IRQs
      rtlwifi: rtl8188ee: Fix too long disable of IRQs
      rtlwifi: rtl8723ae: Fix too long disable of IRQs
      staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0

Li Zefan (2):
      jffs2: remove from wait queue after schedule()
      jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

Linus Walleij (1):
      mfd: Include all drivers in subsystem menu

Liu Hua (1):
      hung_task: check the value of "sysctl_hung_task_timeout_sec"

Luis Henriques (1):
      Linux 3.11.10.9

Lv Zheng (1):
      ACPICA: Restore code that repairs NULL package elements in return values.

Maarten Lankhorst (1):
      drm/qxl: unset a pointer in sync_obj_unref

Malcolm Priestley (2):
      [media] m88rs2000: add caps FE_CAN_INVERSION_AUTO
      [media] m88rs2000: prevent frontend crash on continuous transponder scans

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

Mark Tinguely (1):
      xfs: fix directory hash ordering bug

Mathias Nyman (1):
      xhci: Prevent runtime pm from autosuspending during initialization

Matt Fleming (1):
      sh: fix format string bug in stack tracer

Mel Gorman (1):
      mm: use paravirt friendly ops for NUMA hinting ptes

Michael Braun (1):
      mac80211: fix WPA with VLAN on AP side with ps-sta again

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver

Michal Simek (1):
      usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards

Mike Marciniszyn (2):
      IB/qib: Fix debugfs ordering issue with multiple HCAs
      ib_srpt: Use correct ib_sg_dma primitives

Mike Snitzer (2):
      dm cache: prevent corruption caused by discard_block_size > cache_block_size
      dm thin: fix dangling bio in process_deferred_bios error path

Mikulas Patocka (7):
      matroxfb: restore the registers M_ACCESS and M_PITCH
      framebuffer: fix cfb_copyarea
      mach64: use unaligned access
      mach64: fix cursor when character width is not a multiple of 8 pixels
      tgafb: fix mode setting with fbset
      tgafb: fix data copying
      user namespace: fix incorrect memory barriers

Mischa Jonker (1):
      ARC: [nsimosci] Change .dts to use generic 8250 UART

Mizuma, Masayoshi (2):
      mm: hugetlb: fix softlockup when a large number of hugepages are freed.
      mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

Neil Horman (1):
      x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

NeilBrown (1):
      md/raid1: r1buf_pool_alloc: free allocate pages when subsequent allocation fails.

Nicholas Bellinger (1):
      iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug

Oleg Nesterov (3):
      pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
      exit: call disassociate_ctty() before exit_task_namespaces()
      wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race

Oleksij Rempel (1):
      [media] uvcvideo: Do not use usb_set_interface on bulk EP

Paul Gortmaker (1):
      hvc: ensure hvc_init is only ever called once in hvc_console.c

Qiaowei Ren (1):
      x86, cpufeature: Define the Intel MPX feature flag

Quentin Casasnovas (1):
      drm/radeon: memory leak on bo reservation failure. v2

Rafał Miłecki (1):
      b43: Fix machine check error due to improper access of B43_MMIO_PSM_PHY_HDR

Richard Guy Briggs (2):
      pid: get pid_t ppid of task in init_pid_ns
      audit: convert PPIDs to the inital PID namespace.

Roman Pen (1):
      blktrace: fix accounting of partially completed requests

Rusty Russell (1):
      virtio_balloon: don't softlockup on huge balloon changes.

Sebastian Ott (1):
      s390/cio: fix driver callback initialization for ccw consoles

Stanislav Kinsbursky (1):
      nfsd: check passed socket's net matches NFSd superblock's one

Stefan Sørensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Stephen Warren (1):
      gpu: host1x: handle the correct # of syncpt regs

Takashi Iwai (2):
      ALSA: hda - Fix silent speaker output due to mute LED fixup
      ALSA: ice1712: Fix boundary checks in PCM pointer ops

Thierry Reding (1):
      drm/tegra: Remove gratuitous pad field

Thomas Petazzoni (1):
      Revert "net: mvneta: fix usage as a module on RGMII configurations"

Tomas Winkler (2):
      mei: fix memory leak of pending write cb objects
      mei: me: do not load the driver if the FW doesn't support MEI interface

Tomasz Figa (1):
      ARM: dts: Keep G3D regulator always on for exynos5250-arndale

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Trond Myklebust (1):
      NFSv4: Fix a use-after-free problem in open()

Vincent Stehlé (1):
      topology: Fix compilation warning when not in SMP

Vineet Gupta (1):
      ARC: [nsimosci] Unbork console

Viresh Kumar (1):
      tick-common: Fix wrong check in tick_check_replacement()

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

alex chen (1):
      ocfs2: do not put bh when buffer_uptodate failed

