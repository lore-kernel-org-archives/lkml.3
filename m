Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbbAZFA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:00:59 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34705 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbAZFA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:00:57 -0500
MIME-Version: 1.0
Date: Sun, 25 Jan 2015 21:00:56 -0800
X-Google-Sender-Auth: jL-Ah6inzECgEbqcytc1bFmNAUw
Message-ID: <CA+55aFymVMJh7O2JQpquqRTFYEp26+_TV5fxmvML7GOK6tJsDw@mail.gmail.com>
Subject: Linux 3.19-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another rc, another week closer to release. And this one is slightly
smaller than rc5 was, although smaller still would always be better.
But like rc5, none of the changes look particularly scary, and over a
quarter were cc'd for stable, so things look to be on track. I
currently expect to make an rc7 next week, with the final 3.19 in two
weeks, as per the usual schedule.

The statistics look very normal, with the patch being about 70% driver
changes (a Dell laptop platform driver revert being the biggest single
patch, but there's networking, media, gpu, gpio, sound..) and about
14% arch updates (x86 and arm are the biggest ones, but there are
small updates to others too) and the rest is mostly scattered all over
(documentation updates, some networking, some filesystem changes -
mainly btrfs, etc etc).

The shortlog gives kind of a detailed summary for people who want to
get a flavor of what was going on. Nothing really particularly stands
out.

                                        Linus

---

Aaron Lu (1):
      gpio: crystalcove: use handle_nested_irq

Ahmed S. Darwish (4):
      can: kvaser_usb: Don't free packets when tight on URBs
      can: kvaser_usb: Reset all URB tx contexts upon channel close
      can: kvaser_usb: Don't send a RESET_CHIP for non-existing channels
      can: kvaser_usb: Don't dereference skb after a netif_rx()

Al Viro (1):
      fix deadlock in cifs_ioctl_clone()

Alex Deucher (6):
      drm/radeon: fix VM flush on cayman/aruba (v3)
      drm/radeon: fix VM flush on SI (v3)
      drm/radeon: fix VM flush on CIK (v3)
      drm/radeon: add a dpm quirk list
      drm/radeon: add si dpm quirk list
      drm/radeon: use rv515_ring_start on r5xx

Alex Williamson (2):
      PCI: Add flag for devices where we can't use bus reset
      PCI: Mark Atheros AR93xx to avoid bus reset

Alexandre Belloni (1):
      ata: pata_at91: depend on !ARCH_MULTIPLATFORM

Alexandre Demers (1):
      x86/tsc: Change Fast TSC calibration failed from error to info

Andrew Lunn (1):
      bus: mvebu-mbus: fix support of MBus window 13

Andy Lutomirski (2):
      x86, tls, ldt: Stop checking lm in LDT_empty
      x86, tls: Interpret an all-zero struct user_desc as "no segment"

Andy Shevchenko (2):
      libata: export ata_get_cmd_descript()
      sata_dwc_460ex: fix resource leak on error path

Arik Nemtsov (1):
      cfg80211: fix deadlock during reg chan check

Axel Lin (2):
      hwmon: (i5500_temp) Convert to module_pci_driver
      hwmon: (i5500_temp) Convert to use ATTRIBUTE_GROUPS macro

Bartlomiej Zolnierkiewicz (1):
      ata: add MAINTAINERS entry for libata PATA drivers

Ben Hutchings (2):
      sh_eth: Fix promiscuous mode on chips without TSU
      sh_eth: Fix ethtool operation crash when net device is down

Brian King (1):
      ipr: wait for aborted command responses

Bryan O'Donoghue (1):
      x86/apic: Re-enable PCI_MSI support for non-SMP X86_32

Byungho An (1):
      net: sxgbe: Fix waring for double kfree()

Chris Wilson (2):
      drm/i915: Ban Haswell from using RCS flips
      drm/i915: Fix mutex->owner inspection race under DEBUG_MUTEXES

Christian Borntraeger (1):
      KVM: fix sparse warning in include/trace/events/kvm.h

Christian König (1):
      drm/radeon: don't print error on -ERESTARTSYS

Clemens Ladisch (2):
      ALSA: firewire-lib: remove rx_blocks_for_midi quirk
      ALSA: firewire-lib: limit the MIDI data rate

Colin Ian King (1):
      scsi_debug: test always evaluates to false, || should be used instead

Dan Carpenter (1):
      s2io: use snprintf() as a safety feature

Dan Williams (1):
      libata: allow sata_sil24 to opt-out of tag ordered submission

Daniel Borkmann (1):
      net: sctp: fix race for one-to-many sockets in sendmsg's auto associate

Daniel Thompson (2):
      ARM: 8266/1: Remove early stack deallocation from restore_user_regs
      ARM: 8255/1: perf: Prevent wraparound during overflow

Darren Hart (2):
      Revert "Documentation: Add entry for dell-laptop sysfs interface"
      Revert "platform: x86: dell-laptop: Add support for keyboard backlight"

Dave Hansen (3):
      x86, mpx: Explicitly disable 32-bit MPX support on 64-bit kernels
      x86, mpx: Fix potential performance issue on unmaps
      x86, mpx: Strictly enforce empty prctl() args

Dave Jiang (1):
      MAINTAINERS: Remove self as isci maintainer

David Howells (1):
      VFS: Convert file->f_dentry->d_inode to file_inode()

David Jeffery (1):
      libata: prevent HSM state change race between ISR and PIO

David Sterba (1):
      btrfs: sync ioctl, handle errors after transaction start

Dmitry Torokhov (2):
      MAINTAINERS: remove Dmitry Torokhov's alternate address
      Input: I8042 - add Acer Aspire 7738 to the nomux list

Doug Anderson (1):
      pinctrl: rockchip: Avoid losing interrupts when supporting both edges

Eric Dumazet (1):
      net: rps: fix cpu unplug

Ewan D. Milne (1):
      scsi: Avoid crashing if device uses DIX but adapter does not support it

Fabio Estevam (2):
      ARM: dts: imx25: Fix PWM "per" clocks
      mfd: da9052-core: Fix platform-device id collision

Felipe Balbi (4):
      irqchip: omap-intc: Fix legacy DMA regression
      arm: boot: dts: dra7: enable dwc3 suspend PHY quirk
      mfd: tps65218: Make INT[12] and STATUS registers volatile
      mfd: tps65218: Make INT1 our status_base register

Filipe Manana (1):
      Btrfs: fix race deleting block group from space_info->ro_bgs list

Gabriel Laskar (1):
      Input: uinput - fix ioctl nr overflow for UI_GET_SYSNAME/VERSION

Gabriele Mazzotta (1):
      ahci: Use dev_info() to inform about the lack of Device Sleep support

Gavin Li (1):
      irqchip: atmel-aic-common: Prevent clobbering of priority when
changing IRQ type

Geert Uytterhoeven (3):
      dt/bindings: arm-boards: Spelling s/pointong/pointing/
      ARM: dt: GIC: Spelling s/specific/specifier/, s/flaggs/flags/
      sh_eth: Fix addition of .trscer_err_mask to wrong SoC data

Girish K.S (1):
      net: sxgbe: Fix NULL dereferece when using DT

Guennadi Liakhovetski (1):
      [media] soc-camera: fix device capabilities in multiple camera
host drivers

Hagen Paul Pfeifer (1):
      ipv6: stop sending PTB packets for MTU < 1280

Hans Holmberg (1):
      gpiolib: of: Correct error handling in of_get_named_gpiod_flags

Hans Verkuil (3):
      [media] vb2: fix vb2_thread_stop race conditions
      [media] pvrusb2: fix missing device_caps in querycap
      [media] cx23885: fix free interrupt bug

Hauke Mehrtens (2):
      bgmac: register napi before the device
      bgmac: activate irqs only if there is nothing to poll

Hyungwon Hwang (1):
      drm/exynos: remove the redundant machine checking code

Imre Deak (3):
      drm/i915: gen9: fix RPS interrupt routing to CPU vs. GT
      drm/i915: fix HW lockup due to missing RPS IRQ workaround on GEN6
      drm/i915: vlv: sanitize RPS interrupt mask during GPU idling

James Ralston (1):
      ahci: Remove Device ID for Intel Sunrise Point PCH

Jan Beulich (1):
      x86, irq: Properly tag virtualization entry in /proc/interrupts

Jason Lee Cragg (1):
      ALSA: usb-audio: Add mic volume fix quirk for Logitech Webcam C210

Jean Delvare (3):
      hwmon: (i5500_temp) New driver for the Intel 5500/5520/X58 chipsets
      hwmon: (i5500_temp) Convert to devm_hwmon_device_register_with_groups
      hwmon: (i5500_temp) Don't bind to disabled sensors

Jens Axboe (1):
      NVMe: cq_vector should be signed

Jiang Liu (3):
      x86/xen: Treat SCI interrupt as normal GSI interrupt
      ACPI: pci: Do not clear pci_dev->irq in acpi_pci_irq_disable()
      x86/xen: Override ACPI IRQ management callback __acpi_unregister_gsi

Jim Lin (1):
      pinctrl: Fix two deadlocks

Joe Thornber (2):
      dm cache: share cache-metadata object across inactive and active DM tables
      dm cache: fix problematic dual use of a single migration count variable

Johan Hovold (10):
      pinctrl: lantiq: remove bogus of_gpio_chip_add
      gpio: fix memory and reference leaks in gpiochip_add error path
      gpio: fix gpio-chip list corruption
      gpio: clean up gpiochip_add error handling
      gpio: fix memory leak and sleep-while-atomic
      gpio: fix sleep-while-atomic in gpiochip_remove
      gpio: unregister gpiochip device before removing it
      gpio: sysfs: fix gpio-chip device-attribute leak
      gpio: sysfs: fix gpio device-attribute leak
      gpio: sysfs: fix gpio attribute-creation race

Johannes Berg (3):
      genetlink: document parallel_ops
      genetlink: disallow subscribing to unknown mcast groups
      genetlink: synchronize socket closing and family removal

John Linville (1):
      mac80211: uninitialized return val in
__ieee80211_sta_handle_tspec_ac_params

Jonathan McDowell (1):
      [media] Fix Mygica T230 support

Joonyoung Shim (3):
      drm/exynos: fix reset codes for memory mapped hdmi phy
      drm/exynos: remove unnecessary runtime pm operations
      drm/exynos: fix warning of vblank reference count

Juergen Gross (2):
      x86: Don't rely on VMWare emulating PAT MSR correctly
      x86, mm: Change cachemode exports to non-gpl

Jungseok Lee (1):
      arm64: Add dtb files to archclean rule

K. Y. Srinivasan (1):
      x86, hyperv: Mark the Hyper-V clocksource as being continuous

Kaixu Xia (1):
      Documentation: of: fix typo in graph bindings

Kees Cook (1):
      x86, boot: Skip relocs when load address unchanged

Kuninori Morimoto (1):
      of: replace Asahi Kasei Corp vendor prefix

Laszlo Ersek (2):
      devicetree: document ARM bindings for QEMU's Firmware Config interface
      devicetree: document the "qemu" and "virtio" vendor prefixes

Ley Foon Tan (1):
      nios2: fix kuser trampoline address

Linus Torvalds (1):
      Linux 3.19-rc6

Linus Walleij (1):
      pinctrl: MAINTAINERS: add git tree reference

Lucas Stach (1):
      MAINTAINERS: Update Richard Zhu's email address

Magnus Damm (3):
      clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
      ARM: shmobile: r8a7778: Instantiate GIC from C board code in legacy builds
      ARM: shmobile: r8a7779: Instantiate GIC from C board code in legacy builds

Marc Kleine-Budde (1):
      MAINTAINERS: update linux-can git repositories

Marc Zyngier (1):
      ARM: OMAP: Work around hardcoded interrupts

Mark Brown (1):
      arm64: dump: Fix implicit inclusion of definition for PCI_IOBASE

Markus Pargmann (1):
      watchdog: imx2_wdt: Disable power down counter on boot

Martin K. Petersen (1):
      libata: Whitelist SSDs that are known to properly return zeroes after TRIM

Masahiro Yamada (1):
      ARM: 8292/1: mm: fix size rounding-down of arm_add_memory() function

Mathias Krause (1):
      crypto: add missing crypto module aliases

Matthias Schwarzott (1):
      [media] cx23885: Split Hauppauge WinTV Starburst from HVR4400 card entry

Mauro Carvalho Chehab (1):
      [media] tlg2300: Fix media dependencies

Michael Holzheu (5):
      s390/bpf: Fix JMP_JGE_K (A >= K) and JMP_JGT_K (A > K)
      s390/bpf: Fix skb_copy_bits() parameter passing
      s390/bpf: Fix offset parameter for skb_copy_bits()
      s390/bpf: Fix sk_load_byte_msh()
      s390/bpf: Zero extend parameters before calling C function

Michael Karcher (1):
      scripts/recordmcount.pl: There is no -m32 gcc option on Super-H anymore

Michel Dänzer (1):
      drm/amdkfd: Drop interrupt SW ring buffer

Mikulas Patocka (1):
      dm: fix handling of multiple internal suspends

Ming Lei (1):
      blk-mq: fix hctx/ctx kobject use-after-free

Mugunthan V N (1):
      drivers: net: cpsw: fix cpsw hung with add vlan using vconfig

Murali Karicheri (1):
      dma-mapping: fix debug print to display correct dma_pfn_offset

Nadav Amit (2):
      KVM: x86: Fix of previously incomplete fix for CVE-2014-8480
      KVM: x86: SYSENTER emulation is broken

Nobuhiro Iwamatsu (1):
      [media] rcar_vin: Update device_caps and capabilities in querycap

Oded Gabbay (1):
      drm/amdkfd: Fix sparse warning (different address space)

Oliver Hartkopp (2):
      can: dev: fix crtlmode_supported check
      can: m_can: tag current CAN FD controllers as non-ISO

Olof Johansson (2):
      clocksource: kona: fix __iomem annotation
      Merge tag 'mvebu-fixes-3.19-3' of
git://git.infradead.org/linux-mvebu into fixes

Or Gerlitz (1):
      net/mlx4: Don't disable vxlan offloads under DMFS-A0 optimized steering

Pantelis Antoniou (3):
      of/overlay: Do not generate duplicate nodes
      of/platform: Handle of_populate drivers in notifier
      of/unittest: Overlays with sub-devices tests

Qu Wenruo (2):
      btrfs: Fix the bug that fs_info->pending_changes is never cleared.
      btrfs: Don't call btrfs_start_transaction() on frozen fs to
avoid deadlock.

Rob Herring (2):
      MAINTAINERS: drop DT regex matching on of_get_property and of_match_table
      MAINTAINERS: Update DT website and git repository

Robin Murphy (1):
      arm64: dts: add baud rate to Juno stdout-path

Roger Quadros (1):
      can: c_can: use regmap_update_bits() to modify RAMINIT register

Roger Tseng (1):
      mfd: rtsx_usb: Fix runtime PM deadlock

Rui Wang (1):
      drm: fb helper should avoid sleeping in panic context

Rusty Russell (6):
      param: initialize store function to NULL if not available.
      param: fix uninitialized read with CONFIG_DEBUG_LOCK_ALLOC
      module_arch_freeing_init(): new hook for archs before
module->module_init freed.
      module: remove mod arg from module_free, rename module_memfree().
      module: fix race in kallsyms resolution during module load success.
      module: make module_refcount() a signed integer.

Sakari Ailus (1):
      [media] omap3isp: Correctly set QUERYCAP capabilities

Sam hung (1):
      Input: elantech - support new ICs types for version 4

Sasha Levin (3):
      time: settimeofday: Validate the values of tv from user
      time: adjtimex: Validate the ADJ_FREQUENCY values
      scsi_debug: use atomic allocation in resp_rsup_opcodes

Satoru Takeuchi (1):
      btrfs: fix state->private cast on 32 bit machines

Srihari Vijayaraghavan (1):
      Input: i8042 - reset keyboard to fix Elantech touchpad detection

Sriharsha Basavapatna (1):
      be2net: Allow GRE to work concurrently while a VxLAN tunnel is configured

Stephen Boyd (1):
      pinctrl: qcom: Don't iterate past end of function array

Suman Tripathi (2):
      ahci_xgene: Fix the endianess issue in APM X-Gene SoC AHCI SATA
controller driver.
      ahci_xgene: Fix the DMA state machine lockup for the
ATA_CMD_PACKET PIO mode command.

Tejun Heo (2):
      libata: clean up MAINTAINERS entries
      workqueue: fix subtle pool management issue which can stall
whole worker_pool

Thomas Petazzoni (1):
      ARM: mvebu: completely disable hardware I/O coherency

Tobias Jakobi (1):
      clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write

Tony Lindgren (6):
      net: davinci_emac: Fix hangs with interrupts
      net: davinci_emac: Fix runtime pm calls for davinci_emac
      net: davinci_emac: Free clock after checking the frequency
      net: davinci_emac: Fix incomplete code for getting the phy from
device tree
      net: davinci_emac: Fix ioremap for devices with MDIO within the
EMAC address space
      net: davinci_emac: Add support for emac on dm816x

Tsutomu Itoh (1):
      Btrfs: fix incorrect freeing in scrub_stripe

Tyrel Datwyler (2):
      MAINTAINERS: ibmvfc driver maintainer change
      MAINTAINERS: ibmvscsi driver maintainer change

Wang Long (1):
      irqchip: hip04: Initialize hip04_cpu_map to 0xffff

Will Deacon (1):
      irqchip: gic-v3-its: Fix use of max with decimal constant

Willem de Bruijn (1):
      ip: zero sockaddr returned on error queue

Wolfram Sang (1):
      watchdog: drop owner assignment from platform_drivers

Xiubo Li (1):
      watchdog: imx2_wdt: Improve power management support.

Yinghai Lu (12):
      PCI: Pass bridge device, not bus, when updating bridge windows
      PCI: Add pci_bus_clip_resource() to clip to fit upstream window
      PCI: Add pci_claim_bridge_resource() to clip window if necessary
      x86/PCI: Clip bridge windows to fit in upstream windows
      alpha/PCI: Clip bridge windows to fit in upstream windows
      frv/PCI: Clip bridge windows to fit in upstream windows
      ia64/PCI: Clip bridge windows to fit in upstream windows
      microblaze/PCI: Clip bridge windows to fit in upstream windows
      mn10300/PCI: Clip bridge windows to fit in upstream windows
      parisc/PCI: Clip bridge windows to fit in upstream windows
      powerpc/PCI: Clip bridge windows to fit in upstream windows
      sparc/PCI: Clip bridge windows to fit in upstream windows

Yingjoe Chen (1):
      irqchip: mtk-sysirq: Use IS_ERR() instead of NULL pointer check

hayeswang (2):
      r8152: remove generic_ocp_read before writing
      r8152: remove sram_read
