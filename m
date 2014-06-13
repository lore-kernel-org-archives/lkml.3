Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaFMUWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:22:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56288 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaFMUWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:22:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.13.y.z extended stable] Linux 3.13.11.3
Date: Fri, 13 Jun 2014 13:22:28 -0700
Message-Id: <1402690949-17968-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.13.11.3 kernel.

The updated 3.13.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.13.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.13.y;a=shortlog

The diff from v3.13.11.2 is posted as a follow-up to this email.

The 3.13.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/input/elantech.txt               |   5 +-
 Makefile                                       |   2 +-
 arch/arc/kernel/entry.S                        |   8 +-
 arch/arm/boot/dts/tegra124.dtsi                |   8 --
 arch/arm/include/asm/div64.h                   |   2 +-
 arch/arm/kernel/machine_kexec.c                |   7 ++
 arch/arm/kvm/mmu.c                             |  15 ++--
 arch/arm/mach-pxa/include/mach/hx4700.h        |   1 +
 arch/mips/cavium-octeon/octeon-irq.c           |   2 +-
 arch/parisc/kernel/syscall_table.S             |   2 +-
 arch/powerpc/include/asm/reg.h                 |   1 +
 arch/s390/net/bpf_jit_comp.c                   |   1 -
 arch/x86/xen/spinlock.c                        |   5 +-
 drivers/acpi/ec.c                              |  21 ++---
 drivers/ata/ahci.c                             |  18 ++---
 drivers/ata/libata-core.c                      |  23 ++++--
 drivers/ata/pata_at91.c                        |  11 +--
 drivers/base/dd.c                              |  17 ++++
 drivers/base/platform.c                        |   7 +-
 drivers/clocksource/exynos_mct.c               |  12 +--
 drivers/dma/edma.c                             |   6 +-
 drivers/gpu/drm/i915/i915_irq.c                |  17 +++-
 drivers/gpu/drm/i915/intel_display.c           |  49 ++++++++----
 drivers/gpu/drm/i915/intel_drv.h               |   3 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |   3 -
 drivers/gpu/drm/nouveau/nouveau_display.c      |   2 +-
 drivers/gpu/drm/radeon/ci_dpm.c                |   8 ++
 drivers/gpu/drm/radeon/cik.c                   | 104 ++++++++++++++++++++++---
 drivers/gpu/drm/radeon/cik_sdma.c              |   2 +-
 drivers/gpu/drm/radeon/cikd.h                  |   9 +++
 drivers/gpu/drm/radeon/dce6_afmt.c             |  14 +++-
 drivers/gpu/drm/radeon/evergreen.c             |  28 +++++--
 drivers/gpu/drm/radeon/r600.c                  |  13 +++-
 drivers/gpu/drm/radeon/r600_dpm.c              |  35 +++++----
 drivers/gpu/drm/radeon/radeon.h                |  12 ++-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c   |   9 ++-
 drivers/gpu/drm/radeon/radeon_device.c         |  19 ++---
 drivers/gpu/drm/radeon/radeon_display.c        |   4 +
 drivers/gpu/drm/radeon/radeon_drv.c            |  12 +--
 drivers/gpu/drm/radeon/radeon_family.h         |   1 +
 drivers/gpu/drm/radeon/radeon_kms.c            |  17 ++--
 drivers/gpu/drm/radeon/radeon_pm.c             |  51 +++++++-----
 drivers/gpu/drm/radeon/radeon_ucode.h          |   7 +-
 drivers/gpu/drm/radeon/radeon_uvd.c            |   4 +
 drivers/gpu/drm/radeon/si.c                    |  65 +++++++++++-----
 drivers/gpu/drm/radeon/uvd_v1_0.c              |  10 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c        |  22 ++++++
 drivers/hid/hid-core.c                         |   3 +
 drivers/hid/hid-ids.h                          |   1 +
 drivers/hid/usbhid/hid-quirks.c                |   1 +
 drivers/hv/connection.c                        |   5 +-
 drivers/iio/adc/at91_adc.c                     |  26 ++++++-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c     |   7 +-
 drivers/iio/industrialio-buffer.c              |   6 +-
 drivers/iio/light/cm36651.c                    |  22 +++++-
 drivers/input/keyboard/atkbd.c                 |  29 ++++++-
 drivers/input/mouse/elantech.c                 |  26 ++++++-
 drivers/input/mouse/elantech.h                 |   1 +
 drivers/input/mouse/synaptics.c                |  50 ++++++++++++
 drivers/irqchip/irq-armada-370-xp.c            |  17 +++-
 drivers/irqchip/irq-gic.c                      |   8 +-
 drivers/md/dm-cache-target.c                   |   1 +
 drivers/misc/mei/hw-me-regs.h                  |   5 ++
 drivers/misc/mei/interrupt.c                   |   3 +-
 drivers/misc/mei/main.c                        |   3 +-
 drivers/misc/mei/pci-me.c                      |  30 +++++--
 drivers/net/ethernet/marvell/mvneta.c          |  41 ++++++++--
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |   1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   6 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |   1 -
 drivers/net/wireless/ath/ath9k/xmit.c          |   4 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c        |   1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c        |   2 +
 drivers/net/wireless/rt2x00/rt2x00mac.c        |  22 +++---
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c   |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c    |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c   |   6 ++
 drivers/of/irq.c                               |  26 +++++++
 drivers/of/platform.c                          |   4 +-
 drivers/s390/cio/chsc.c                        |  22 ++++--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           |   1 -
 drivers/scsi/virtio_scsi.c                     |   6 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c      |  19 ++---
 drivers/staging/rtl8712/rtl871x_recv.c         |  13 ++--
 drivers/tty/hvc/hvc_console.c                  |   2 +-
 drivers/tty/serial/8250/8250_core.c            |   4 +-
 drivers/tty/serial/8250/8250_dma.c             |   9 ++-
 drivers/tty/serial/omap-serial.c               |  29 ++++---
 drivers/tty/tty_buffer.c                       |  17 +++-
 drivers/usb/class/cdc-acm.c                    |  28 +++++--
 drivers/usb/core/hcd-pci.c                     |   2 +-
 drivers/usb/gadget/zero.c                      |   2 +-
 drivers/usb/host/ehci-fsl.c                    |   3 +-
 drivers/usb/host/ohci-hub.c                    |  18 +++++
 drivers/usb/host/ohci-pci.c                    |   1 +
 drivers/usb/host/ohci.h                        |   2 +
 drivers/usb/host/xhci-pci.c                    |   2 +
 drivers/usb/host/xhci-ring.c                   |  77 +++++++++---------
 drivers/usb/host/xhci.c                        |   1 -
 drivers/usb/host/xhci.h                        |   2 -
 drivers/usb/serial/cp210x.c                    |   1 +
 drivers/usb/serial/ftdi_sio.c                  |  33 ++++++++
 drivers/usb/serial/ftdi_sio_ids.h              |  37 +++++++++
 drivers/usb/serial/io_ti.c                     |  50 ++++++++----
 drivers/usb/serial/option.c                    |  83 +++++++++++++++++++-
 drivers/usb/serial/pl2303.c                    |   3 +
 drivers/usb/serial/pl2303.h                    |   5 +-
 drivers/usb/serial/qcserial.c                  |  24 ++++++
 drivers/usb/serial/sierra.c                    |   1 -
 drivers/usb/serial/usb-serial.c                |   4 +-
 drivers/usb/serial/usb_wwan.c                  |   9 +--
 drivers/usb/storage/shuttle_usbat.c            |   2 +-
 drivers/usb/storage/unusual_devs.h             |  14 ++++
 fs/aio.c                                       |   6 +-
 fs/autofs4/root.c                              |   4 +-
 fs/btrfs/inode-map.c                           |  18 +----
 fs/cifs/cifsfs.c                               |  14 +++-
 fs/cifs/cifsglob.h                             |   8 ++
 fs/cifs/cifsproto.h                            |   3 +
 fs/cifs/file.c                                 |  31 +++++++-
 fs/cifs/misc.c                                 |  74 +++++++++++++++++-
 fs/cifs/smb1ops.c                              |  11 +++
 fs/cifs/smb2misc.c                             |  18 ++++-
 fs/cifs/smb2ops.c                              |  14 ++++
 fs/coredump.c                                  |   7 +-
 fs/dcache.c                                    |   3 +-
 fs/ext4/ext4.h                                 |  17 ----
 fs/ext4/file.c                                 |   2 +-
 fs/ext4/inode.c                                |  26 ++++++-
 fs/ext4/page-io.c                              |   5 +-
 fs/ext4/xattr.c                                |  23 +++++-
 fs/locks.c                                     |   7 +-
 fs/namei.c                                     |   6 +-
 fs/nfsd/nfs4callback.c                         |   4 +-
 fs/posix_acl.c                                 |   6 ++
 include/asm-generic/pgtable.h                  |  31 ++++++--
 include/asm-generic/word-at-a-time.h           |   8 +-
 include/linux/ftrace.h                         |   2 +
 include/linux/hyperv.h                         |   4 +-
 include/linux/interrupt.h                      |  35 ++++++++-
 include/linux/irq.h                            |   3 +-
 include/linux/libata.h                         |   1 +
 include/linux/of_irq.h                         |   5 ++
 include/linux/sock_diag.h                      |   2 +-
 init/Kconfig                                   |  24 +++---
 kernel/hrtimer.c                               |  22 ++++++
 kernel/irq/manage.c                            |  17 ++--
 kernel/module.c                                |   8 +-
 kernel/time/tick-common.c                      |   2 +-
 kernel/time/tick-sched.c                       |   2 +-
 kernel/timer.c                                 |   2 +-
 kernel/trace/ftrace.c                          |  27 +------
 mm/compaction.c                                |  41 ++++++----
 mm/huge_memory.c                               |  13 +++-
 mm/hugetlb.c                                   |   1 +
 mm/memory.c                                    |   8 +-
 mm/page-writeback.c                            |   6 +-
 net/bluetooth/hci_event.c                      |   6 ++
 net/core/sock_diag.c                           |   4 +-
 net/mac80211/main.c                            |   2 +
 net/mac80211/offchannel.c                      |   1 +
 net/packet/diag.c                              |   2 +-
 sound/pci/hda/patch_hdmi.c                     |   4 +-
 sound/pci/hda/patch_realtek.c                  |   7 ++
 sound/soc/soc-dapm.c                           |   1 -
 sound/usb/card.h                               |   1 +
 sound/usb/endpoint.c                           |  15 +++-
 virt/kvm/arm/vgic.c                            |   1 +
 virt/kvm/async_pf.c                            |   8 +-
 170 files changed, 1649 insertions(+), 558 deletions(-)

Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Al Viro (1):
      fix races between __d_instantiate() and checks of dentry flags

Alan Stern (2):
      USB: fix crash during hotplug of PCI USB controller card
      USB: OHCI: fix problem with global suspend on ATI controllers

Alec Berg (1):
      iio: querying buffer scan_mask should return 0/1

Alex Deucher (14):
      drm/radeon: fix audio pin counts for DCE6+ (v2)
      drm/radeon: disable mclk dpm on R7 260X
      drm/radeon: fix runpm handling on APUs (v4)
      drm/radeon: add support for newer mc ucode on SI (v2)
      drm/radeon: add support for newer mc ucode on CI (v2)
      drm/radeon: re-enable mclk dpm on R7 260X asics
      drm/radeon/si: make sure mc ucode is loaded before checking the size
      drm/radeon/ci: make sure mc ucode is loaded before checking the size
      drm/radeon: disable dpm on rv770 by default
      drm/radeon: fix count in cik_sdma_ring_test()
      drm/radeon: properly unregister hwmon interface (v2)
      drm/radeon/pm: don't walk the crtc list before it has been initialized (v2)
      drm/radeon: fix ATPX detection on non-VGA GPUs
      drm/radeon: don't allow runpm=1 on systems with out ATPX

Alexander Gordeev (1):
      ahci: Do not receive interrupts sent by dummy ports

Alexander Usyskin (1):
      mei: ignore client writing state during cb completion

Alexandre Belloni (1):
      iio: adc: at91_adc: Repair broken platform_data support

Andrea Adami (1):
      ARM: pxa: hx4700.h: include "irqs.h" for PXA_NR_BUILTIN_GPIO

Andrew Lutomirski (1):
      net: Fix ns_capable check in sock_diag_put_filterinfo

Anssi Hannula (1):
      ALSA: hda - hdmi: Set converter channel count even without sink

Atilla Filiz (1):
      iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null dereference

Bartlomiej Zolnierkiewicz (1):
      pata_at91: fix ata_host_activate() failure handling

Ben Hutchings (1):
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()

Benjamin Tissoires (1):
      HID: core: do not scan constant input report

Bjørn Mork (7):
      usb: qcserial: add Sierra Wireless EM7355
      usb: qcserial: add Sierra Wireless MC73xx
      usb: qcserial: add Sierra Wireless MC7305/MC7355
      usb: option: add Olivetti Olicard 500
      usb: option: add Alcatel L800MA
      usb: option: add and update a number of CMOTech devices
      usb: qcserial: add a number of Dell devices

Chris Mason (1):
      mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Christian König (2):
      drm/radeon/uvd: use lower clocks on old UVD to boot v2
      drm/radeon: use pflip irq on R600+ v2

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Clemens Ladisch (1):
      ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data

Colin Ian King (1):
      rtlwifi: rtl8188ee: initialize packet_beacon

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

Daniel Vetter (2):
      drm/i915: Don't check gmch state on inherited configs
      drm/i915: Don't WARN nor handle unexpected hpd interrupts on gmch platforms

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2

David Milburn (1):
      ahci: do not request irq for dummy port

Denis Turischev (1):
      xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Egbert Eich (1):
      drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

Emmanuel Grumbach (2):
      iwlwifi: add MODULE_FIRMWARE for 7265
      iwlwifi: mvm: disable beacon filtering

Eric Dumazet (1):
      coredump: fix va_list corruption

Fam Zheng (1):
      [SCSI] virtio-scsi: Skip setting affinity on uninitialized vq

Felix Fietkau (1):
      mac80211: exclude AP_VLAN interfaces from tx power calculation

Grant Likely (1):
      drivercore: deferral race condition fix

Haibin Wang (1):
      KVM: ARM: vgic: Fix sgi dispatch problem

Hans de Goede (5):
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, S1 Yoga and X1
      xhci: For streams the css flag most be read from the stream-ctx on ep stop
      Input: synaptics - add min/max quirk for ThinkPad Edge E431
      HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S
      Input: elantech - fix touchpad initialization on Gigabyte U2442

Helge Deller (1):
      parisc: fix epoll_pwait syscall on compat kernel

Helmut Schaa (1):
      ath9k: Fix sequence number assignment for non-data frames

Hui Wang (3):
      ALSA: hda - add headset mic detect quirk for a Dell laptop
      ALSA: hda - add headset mic detect quirk for a Dell laptop
      ALSA: hda - add headset mic detect quirk for a Dell laptop

Ian Kent (1):
      autofs: fix lockref lookup

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Jan Kara (1):
      ext4: fix jbd2 warning under heavy xattr load

Jarkko Nikula (1):
      ASoC: dapm: Fix widget double free with auto-disable DAPM kcontrol

Jeff Layton (2):
      locks: allow __break_lease to sleep even when break_time is 0
      nfsd: set timeparms.to_maxval in setup_callback_client

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Johan Hedberg (1):
      Bluetooth: Fix triggering BR/EDR L2CAP Connect too early

Johan Hovold (4):
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
      USB: usb_wwan: fix handling of missing bulk endpoints
      USB: serial: fix sysfs-attribute removal deadlock
      USB: io_ti: fix firmware download on big-endian machines

Johannes Berg (1):
      mac80211: fix software remain-on-channel implementation

Julius Werner (1):
      usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC288 codec
      ALSA: hda/realtek - Add headset Mic support for Dell machine

Kamal Mostafa (1):
      Linux 3.13.11.3

Kazuya Mio (1):
      ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS

Kieran Clancy (1):
      ACPI / EC: Process rather than discard events in acpi_ec_clear

Kirill A. Shutemov (1):
      thp: close race between split and zap huge pages

Konrad Rzeszutek Wilk (1):
      xen/spinlock: Don't enable them unconditionally.

Krzysztof Kozlowski (2):
      iio: cm36651: Fix i2c client leak and possible NULL pointer dereference
      clocksource: Exynos_mct: Register clock event after request_irq()

Larry Finger (4):
      staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr will return NULL
      staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0
      staging: r8188eu: Fix case where ethtype was never obtained and always be checked against 0
      rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb

Leo Liu (1):
      drm/radeon: check buffer relocation offset

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Leon Yu (1):
      aio: fix potential leak in aio_run_iocb().

Linus Torvalds (1):
      mm: make fixup_user_fault() check the vma access rights too

Liu Hua (1):
      ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo

Loic Poulain (2):
      8250_core: Fix unwanted TX chars write
      serial: 8250: Fix thread unsafe __dma_tx_complete function

Maarten Lankhorst (1):
      drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip

Mark Salter (1):
      arm: KVM: fix possible misalignment of PGDs and bounce page

Martin K. Petersen (2):
      libata: Update queued trim blacklist for M5x0 drives
      libata: Blacklist queued trim for Crucial M500

Martin Schwidefsky (1):
      s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Matthew Wilcox (1):
      ext4: note the error in ext4_end_bio()

Mel Gorman (1):
      mm: use paravirt friendly ops for NUMA hinting ptes

Miao Xie (1):
      Btrfs: fix inode caching vs tree log

Michael Neuling (1):
      powerpc/tm: Disable IRQ in tm_recheckpoint

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver

Michael Welling (1):
      tty: serial: 8250_core.c Bug fix for Exar chips.

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards

Mike Snitzer (1):
      dm cache: fix writethrough mode quiescing in cache_map

Mizuma, Masayoshi (1):
      mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

Neil Greatorex (1):
      irqchip: armada-370-xp: Fix releasing of MSIs

Nikita Yushchenko (1):
      fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Oleg Nesterov (1):
      KVM: async_pf: mm->mm_users can not pin apf->mm

Oren Givon (1):
      iwlwifi: add new 7265 HW IDs

Peter Foley (1):
      init/Kconfig: move the trusted keyring config option to general setup

Peter Hurley (1):
      tty: Fix lockless tty buffer race

Quentin Casasnovas (1):
      drm/radeon: memory leak on bo reservation failure. v2

Rik van Riel (2):
      mm/numa: Remove BUG_ON() in __handle_mm_fault()
      mm/page-writeback.c: fix divide by zero in pos_ratio_polynom

Rob Herring (1):
      of/irq: do irq resolution in platform_get_irq

Roger Quadros (1):
      usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1

Rusty Russell (1):
      module: remove warning about waiting module removal.

Sachin Prabhu (1):
      cifs: Wait for writebacks to complete before attempting write.

Sebastian Ott (1):
      s390/chsc: fix SEI usage on old FW levels

Sekhar Nori (1):
      dma: edma: fix incorrect SG list handling

Sheng-Liang Song (1):
      Input: atkbd - fix keyboard not working on some LG laptops

Stanislaw Gruszka (1):
      rt2x00: fix beaconing on USB

Stephen Warren (1):
      ARM: tegra: remove UART5/UARTE from tegra124.dtsi

Steven Rostedt (Red Hat) (1):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected

Theodore Ts'o (3):
      ext4: avoid possible overflow in ext4_map_blocks()
      ext4: move ext4_update_i_disksize() into mpage_map_and_submit_extent()
      ext4: use i_size_read in ext4_unaligned_aio()

Thomas Gleixner (3):
      genirq: Allow forcing cpu affinity of interrupts
      irqchip: Gic: Support forced affinity setting
      clocksource: Exynos_mct: Use irq_force_affinity() in cpu bringup

Thomas Hellstrom (1):
      drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2

Thomas Petazzoni (3):
      Revert "net: mvneta: fix usage as a module on RGMII configurations"
      irqchip: armada-370-xp: fix invalid cast of signed value into unsigned variable
      irqchip: armada-370-xp: implement the ->check_device() msi_chip operation

Tomas Winkler (1):
      mei: me: do not load the driver if the FW doesn't support MEI interface

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Tony Lindgren (1):
      serial: omap: Fix missing pm_runtime_resume handling by simplifying code

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Tyler Stachecki (1):
      [SCSI] mpt2sas: Don't disable device twice at suspend.

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

Vineet Gupta (1):
      ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe

Viresh Kumar (2):
      tick-common: Fix wrong check in tick_check_replacement()
      tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()

Vlastimil Babka (2):
      mm: compaction: detect when scanners meet in isolate_freepages
      mm/compaction: make isolate_freepages start at pageblock boundary

Will Deacon (1):
      word-at-a-time: avoid undefined behaviour in zero_bytemask macro

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems

