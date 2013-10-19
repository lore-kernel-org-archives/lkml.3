Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3JSTu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 15:50:56 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:56450 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3JSTuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 15:50:52 -0400
MIME-Version: 1.0
Date: Sat, 19 Oct 2013 12:50:51 -0700
X-Google-Sender-Auth: xL7vRqg5NHqPGQZIm4U3JWBKLhI
Message-ID: <CA+55aFx89vufPmMmnSN6bq7HU=zafm4mmM3GQ2m418k+R9AsPQ@mail.gmail.com>
Subject: Linux 3.12-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm at PDX, about to fly out to the kernel summit, and it has almost
become a tradition to do an rc release using the airport wifi. So here
it is..

The patch is still busily being pushed out, but the git trees are
up-to-date, and the tar-file should already be out. Nothing major
happened last week., and the upcoming week is likely to be quiet too,
since a lot of core maintainers will be in Edinburgh for the KS.

Shortlog with more details appended, but the overview is just mainly
driver updates. USB, infiniband, acpi.. Some documentation and Cifs
updates, and the rest is random noise.

Please test,

                    Linus

---

AKASHI Takahiro (1):
      ARM: 7851/1: check for number of arguments in syscall_get/set_arguments()

Aaron Lu (1):
      ATA / ACPI: remove power dependent device handling

Alexandre Courbot (2):
      gpiolib: safer implementation of desc_to_gpio()
      gpiolib: let gpiod_request() return -EPROBE_DEFER

Andrea Adami (1):
      ARM: 7845/1: sharpsl_param.c: fix invalid memory access for pxa devices

Andrea Arcangeli (1):
      mm: hugetlb: initialize PG_reserved for tail pages of gigantic
compound pages

Andreas Herrmann (1):
      ARM: dma-mapping: Always pass proper prot flags to iommu_map()

Andrew Vagin (1):
      mm/vmscan.c: don't forget to free shrinker->nr_deferred

Antonios Motakis (1):
      VFIO: vfio_iommu_type1: fix bug caused by break in nested loop

Ard Biesheuvel (1):
      ARM: 7843/1: drop asm/types.h from generic-y

Borislav Petkov (1):
      x86/microcode: Correct Kconfig dependencies

Charles Keepax (1):
      cpufreq: s3c64xx: Rename index to driver_data

Christoph Lameter (1):
      slab_common: Do not check for duplicate slab names

Cyrill Gorcunov (2):
      mm: migration: do not lose soft dirty bit if page is in migration state
      mm: /proc/pid/pagemap: inspect _PAGE_SOFT_DIRTY only on present pages

Dan Carpenter (1):
      ALSA: hdsp - info leak in snd_hdsp_hwdep_ioctl()

David Henningsson (1):
      ALSA: hda - Fix inverted internal mic not indicated on some machines

David Rientjes (1):
      mm, memcg: protect mem_cgroup_read_events for cpu hotplug

Davidlohr Bueso (1):
      ipc: update locking scheme comments

Diego Elio Pettenò (1):
      USB: serial: ti_usb_3410_5052: add Abbott strip port ID to
combined table as well.

Dirk Brandewie (1):
      cpufreq / intel_pstate: Fix max_perf_pct on resume

Doug Anderson (1):
      block/partitions/efi.c: treat size mismatch as a warning, not an error

Eli Cohen (12):
      IB/mlx5: Fix send work queue size calculation
      mlx5: Remove checksum on command interface commands
      IB/mlx5: Decrease memory consumption of mr caches
      IB/mlx5: Avoid async events on invalid port number
      mlx5: Keep polling to reclaim pages while any returned
      mlx5: Fix layout of struct mlx5_init_seg
      IB/mlx5: Disable atomic operations
      mlx5: Fix opt param mask for sq err to rts transition
      IB/mlx5: Fix opt param mask according to firmware spec
      mlx5: Fix error code translation from firmware to driver
      IB/mlx5: Fix alignment of reg umr gather buffers
      IB/mlx5: Ensure proper synchronization accessing memory

Enrico Mioso (1):
      usb: serial: option: blacklist Olivetti Olicard200

Fangxiaozhi (Franko) (1):
      USB: support new huawei devices in option.c

Felipe Pena (1):
      tools/testing/selftests: fix uninitialized variable

Fengguang Wu (1):
      writeback: fix negative bdi max pause

Frediano Ziglio (1):
      xen: Fix possible user space selector corruption

Grant Likely (2):
      of: fix unnecessary warning on missing /cpus node
      Revert "of: Feed entire flattened device tree into the random pool"

Greg Kroah-Hartman (4):
      Revert "serial: i.MX: evaluate linux,stdout-path property"
      USB: serial: option: add support for Inovia SEW858 device
      Revert "usb: musb: gadget: fix otg active status flag"
      Revert "Drivers: hv: vmbus: Fix a bug in channel rescind code"

Guenter Roeck (1):
      usb: usb_phy_gen: refine conditional declaration of usb_nop_xceiv_register

HATAYAMA Daisuke (2):
      procfs: fix unintended truncation of returned mapped address
      procfs: call default get_unmapped_area on MMU-present architectures

Hans-Frieder Vogt (2):
      w1 - fix fops in w1_bus_notify
      w1 - call request_module with w1 master mutex unlocked

Hugh Dickins (2):
      mm: fix BUG in __split_huge_page_pmd
      mm: revert mremap pud_free anti-fix

Jan Klos (1):
      cifs: Fix inability to write files >2GB to SMB2/3 shares

Joe Perches (1):
      IB: Remove unnecessary semicolons

Johannes Weiner (2):
      mm: memcg: handle non-error OOM situations more gracefully
      fs: buffer: move allocation failure loop into the allocator

John Johansen (2):
      apparmor: fix memleak of the profile hash
      apparmor: fix bad lock balance when introspecting policy

Joonsoo Kim (1):
      mm/hugetlb.c: correct missing private flag clearing

Josef Bacik (1):
      Btrfs: release path before starting transaction in can_nocow_extent

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in channel rescind code

Krzysztof Kozlowski (1):
      swap: fix set_blocksize race during swapon/swapoff

Krzysztof Mazur (1):
      ACPI: remove /proc/acpi/event from ACPI_BUTTON help

Lan Tianyu (1):
      ACPI / power: Release resource_lock after acpi_power_get_state()
return error

Lars-Peter Clausen (1):
      iio:buffer: Free active scan mask in iio_disable_all_buffers()

Linus Torvalds (1):
      Linux 3.12-rc6

Manfred Spraul (1):
      ipc/sem.c: synchronize semop and semctl with IPC_RMID

Marek Szyprowski (2):
      Revert "ARM: init: add support for reserved memory defined by device tree"
      Revert "drivers: of: add initialization code for dma reserved memory"

Matias Bjorling (1):
      percpu_refcount: export symbols

Matthew Dawson (1):
      usb: misc: usb3503: Fix compile error due to incorrect regmap depedency

Mika Westerberg (1):
      gpio/lynxpoint: check if the interrupt is enabled in IRQ handler

Miklos Szeredi (1):
      ext[34]: fix double put in tmpfile

Mikulas Patocka (1):
      dm snapshot: fix data corruption

Moshe Lazer (2):
      IB/mlx5: Flush cache workqueue before destroying it
      IB/mlx5: Fix memory leak in mlx5_ib_create_srq

Nicolas Pitre (1):
      ARM: 7842/1: MCPM: don't explode if invoked without being
initialized first

Oliver Neukum (4):
      xhci: quirk for extra long delay for S4
      USB: quirks.c: add one device that cannot deal with suspension
      USB: quirks: add touchscreen that is dazzeled by remote wakeup
      usb-storage: add quirk for mandatory READ_CAPACITY_16

Peter Oberparleiter (1):
      gcov: MAINTAINERS: Add an entry for gcov

Rafael J. Wysocki (9):
      MAINTAINERS / Documentation: Update Rafael's e-mail address
      MAINTAINERS / ACPI: Update links and git tree information
      MAINTAINERS / ACPI: Update links to the Linux-ACPI project web page
      ACPI / PM / Documentation: Replace outdated project links and addresses
      ACPI / hotplug / PCI: Fix error code path in acpiphp_enumerate_slots()
      ACPI / hotplug / PCI: Drop WARN_ON() from acpiphp_enumerate_slots()
      intel_pstate: Fix type mismatch warning
      ACPI / power: Drop automaitc resume of power resource dependent devices
      ACPI / PM: Drop two functions that are not used any more

Raghavendra K T (1):
      KVM: Enable pvspinlock after jump_label_init() to avoid VM hang

Rob Herring (1):
      tpm: xen-tpmfront: fix missing declaration of xen_domain

Roel Kluin (1):
      serial: vt8500: add missing braces

Russ Anderson (1):
      x86: Update UV3 hub revision ID

Russell King - ARM Linux (1):
      usb/chipidea: fix oops on memory allocation failure

Sachin Prabhu (1):
      cifs: Allow LANMAN auth method for servers supporting
unencapsulated authentication methods

Sagi Grimberg (1):
      IB/mlx5: Fix eq names to display nicely in /proc/interrupts

Santosh Shilimkar (1):
      ARM: 7846/1: Update SMP_ON_UP code to detect A9MPCore with 1 CPU devices

Sarah Sharp (1):
      xhci: Don't enable/disable RWE on bus suspend/resume.

Sebastian Andrzej Siewior (1):
      usb: musb: start musb on the udc side, too

Shirish Pargaonkar (1):
      cifs: Avoid umount hangs with smb2 when server is unresponsive

Steve French (1):
      do not treat non-symlink reparse points as valid symlinks

Takashi Iwai (2):
      xhci: Fix spurious wakeups after S5 on Haswell
      ALSA: us122l: Fix pcm_usb_stream mmapping regression

Tim Gardner (1):
      cifs: ntstatus_to_dos_map[] is not terminated

Wei Yongjun (1):
      iio: frequency: adf4350: add missing clk_disable_unprepare() on
error in adf4350_probe()

Weijie Yang (1):
      mm/zswap: bugfix: memory leak when re-swapon

Xenia Ragiadakou (1):
      xhci: fix write to USB3_PSSEN and XUSB2PRM pci config registers

Yasuaki Ishimatsu (1):
      driver core: Release device_hotplug_lock when store_mem_state
returns EINVAL
