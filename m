Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaEUWrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:47:40 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:54983 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaEUWrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:47:37 -0400
MIME-Version: 1.0
Date: Thu, 22 May 2014 07:47:35 +0900
X-Google-Sender-Auth: fuYGKW9U0_9fXODE8zhkuZnshZY
Message-ID: <CA+55aFzwqPh+WUAxi2CY8D6k+LkDbUb__G98qVFrE-DHNMSPUw@mail.gmail.com>
Subject: Linux 3.15-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to travels and related lack of internet access, the rc releases
haven't been following the normal Sunday release cycle, and since I
caught up with what happened while I was off-line, rather than wait
until next Sunday to reset to the normal cycle, I'm just releasing rc6
now mid-week from Tokyo.

With rc5 being a couple of days early, and rc6 being several days
late, we had almost two weeks in between them. The size of the result
is not twice as large, though, hopefully partially because it's
getting late in the rc series and things are supposed to be calming
down, but presumably also because some submaintainers just didn't send
their pull requests because they knew I was off-line. Whatever the
reason, things don't look bad.

The patch distribution looks pretty normal too. Mostly drivers (acpi,
sound, media, i915, clk, pci..) with the bulk of the rest being
various arch updates (notably MIPS, but arm and parisc too). And a
smattering of other random stuff in filesystems and core kernel code.

Anyway, depending a bit on what else is pending, I'll probably stretch
out rc7 to get back to the normal Sunday schedule, and depending on
how things look by then that may or may not be the last rc.

But please do test this,

            Linus

---

Aaro Koskinen (1):
      MIPS/loongson2_cpufreq: Fix CPU clock rate setting

Aaron Lu (2):
      ACPI / video: correct DMI tag for Dell Inspiron 7520
      drm/i915: restore backlight precision when converting from ACPI

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID to snd-hda

Alex Elder (1):
      clk: bcm281xx: don't use unnamed structs or unions

Alex Williamson (1):
      iommu/amd: Fix interrupt remapping for aliased devices

Andrew Lunn (1):
      ARM: Kirkwood: T5325: Fix double probe of Codec

Andy Gross (1):
      i2c: qup: Fix pm_runtime_get_sync usage

Andy Grover (2):
      target: Allow non-supporting backends to set pi_prot_type to 0
      target: Don't allow setting WC emulation if device doesn't support

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Anton Blanchard (1):
      powerpc: irq work racing with timer interrupt can result in
timer interrupt hang

Antti Palosaari (3):
      [media] rtl28xxu: do not hard depend on staging SDR module
      [media] rtl28xxu: silence error log about disabled rtl2832_sdr module
      [media] fc2580: fix tuning failure on 32-bit arch

Aristeu Rozanski (3):
      device_cgroup: rework device access check and exception checking
      device_cgroup: fix the comment format for recently added functions
      device_cgroup: check if exception removal is allowed

Arnd Bergmann (2):
      genirq: Provide irq_force_affinity fallback for non-SMP
      ata: pata_at91 only works on sam9

Axel Lin (1):
      spi: qup: Fix return value checking for pm_runtime_get_sync()

Ben Dooks (1):
      clk: shmobile: clk-mstp: change to using clock-indices

Ben Hutchings (1):
      PCI: Update my email address

Bo Shen (1):
      ARM: at91: fix spi cs on sama5d3 Xplained board

Catalin Marinas (1):
      mm: postpone the disabling of kmemleak early logging

Charles Keepax (1):
      ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Chris Wilson (1):
      drm/i915: Use the first mode if there is no preferred mode in the EDID

Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd

Cyril Hrubis (1):
      MAINTAINERS: update maintainership of LTP

Daeseok Youn (1):
      workqueue: fix bugs in wq_update_unbound_numa() failure path

Dan Carpenter (1):
      ALSA: sb_mixer: missing return statement

Dave Chinner (9):
      xfs: xfs_dir_fsync() returns positive errno
      xfs: fix incorrect error sign in xfs_file_aio_read
      xfs: xfs_commit_metadata returns wrong errno
      xfs: correct error sign on COLLAPSE_RANGE errors
      xfs: fix wrong errno from xfs_initxattrs
      xfs: fix wrong err sign on xfs_set_acl()
      xfs: negate mount workqueue init error value
      xfs: negate xfs_icsb_init_counters error value
      xfs: list_lru_init returns a negative error

Dave Gerlach (1):
      ARM: dts: am437x-gp-evm: Do not reset gpio5

Dinh Nguyen (1):
      clk: socfpga: fix clock driver for 3.15

Dirk Brandewie (2):
      intel_pstate: Set turbo VID for BayTrail
      intel_pstate: remove setting P state to MAX on init

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Edward Lin (1):
      ACPI: blacklist win8 OSI for Dell Inspiron 7737

Egbert Eich (1):
      drm/i915/SDVO: For sysfs link put directory and target in correct order

Emilio López (1):
      ARM: sun7i: fix PLL4 clock and add PLL8

Filipe Manana (1):
      Btrfs: send, fix incorrect ref access when using extrefs

Gavin Shan (2):
      powerpc/powernv: Reset root port in firmware
      PCI: Wrong register used to check pending traffic

Geert Uytterhoeven (3):
      spi: core: Ignore unsupported Dual/Quad Transfer Mode bits
      spi: core: Protect DMA code by #ifdef CONFIG_HAS_DMA
      drivers: sh: compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI

Guennadi Liakhovetski (2):
      [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the
kernel from user-space
      [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Guenter Roeck (1):
      ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"

H. Peter Anvin (1):
      x86, rdrand: When nordrand is specified, disable RDSEED as well

Hans de Goede (3):
      ACPI / video: Add use_native_backlight quirks for more systems
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX
      ACPI / video: Revert native brightness quirk for ThinkPad T530

Harald Freudenberger (1):
      crypto: s390 - fix aes,des ctr mode concurrency finding.

Heiko Stuebner (1):
      drivers/rtc/rtc-hym8563.c: set uie_unsupported

Helge Deller (2):
      parisc,metag: Do not hardcode maximum userspace stack size
      parisc: ratelimit userspace segfault printing

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

Hui Wang (1):
      ALSA: hda - add headset mic detect quirks for three Dell laptops

Igor Mammedov (1):
      ACPI / processor: do not mark present at boot but not onlined
CPU as onlined

Ilya Dryomov (1):
      crush: decode and initialize chooseleaf_vary_r

Jacob Pan (1):
      ahci: disable DEVSLP for Intel Valleyview

James Hogan (5):
      metag: Reduce maximum stack size to 256MB
      metag: Remove _STK_LIM_MAX override
      asm-generic: remove _STK_LIM_MAX
      asm-generic: Add renameat2 syscall
      scripts/checksyscalls.sh: Make renameat optional

Jani Nikula (4):
      drm/i915: clean up VBT eDP link param decoding
      drm/i915: use lane count and link rate from VBT as minimums for eDP
      drm/i915/vlv: reset VLV media force wake request register
      drm/i915/dp: force eDP lane count to max available lanes on BDW

Jarkko Nikula (2):
      ASoC: Intel: Cancel hsw_notification_work before freeing the stream
      ASoC: Intel: Fix Baytrail SST DSP firmware loading

Jason Cooper (1):
      MAINTAINERS: Add co-maintainer for drivers/irqchip

Jason Gunthorpe (1):
      bus: mvebu-mbus: Avoid setting an undefined window size

Javier Martinez Canillas (1):
      ARM: dts: omap3-igep0020: use SMSC9221 timings

Jay Cornwall (1):
      iommu/amd: Take mmap_sem when calling get_user_pages

Jean Delvare (2):
      [media] Prefer gspca_sonixb over sn9c102 for all devices
      hwmon: (emc1403) Fix resource leak on module unload

Jeff Layton (2):
      cifs: fix actimeo=0 corner case when cifs_i->time == jiffies
      locks: only validate the lock vs. f_mode in F_SETLK codepaths

Jes Sorensen (2):
      staging: rtl8723au: Use correct pipe type for USB interrupts
      staging: rtl8723au: Do not reset wdev->iftype in netdev_close()

Jianyu Zhan (1):
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Joe Perches (1):
      ASoC: tlv320aic31xx: Convert /n to \n

Joe Thornber (2):
      dm thin: allow metadata commit if pool is in PM_OUT_OF_DATA_SPACE mode
      dm thin: add timeout to stop out-of-data-space mode holding IO forever

Joel Fernandes (1):
      ARM: OMAP5: Switch to THUMB mode if needed on secondary CPU

John David Anglin (1):
      parisc: Improve LWS-CAS performance

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

Julien Grall (1):
      arm/xen: Remove definiition of virt_to_pfn in asm/xen/page.h

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries

Kirill A. Shutemov (1):
      mm, thp: close race between mremap() and split_huge_page()

Kuninori Morimoto (1):
      ASoC: rsnd: call rsnd_dai_pointer_update() from outside of lock

Lad, Prabhakar (5):
      [media] media: davinci: vpif_capture: fix releasing of active buffers
      [media] media: davinci: vpif_display: fix releasing of active buffers
      [media] media: davinci: vpbe_display: fix releasing of active buffers
      [media] staging: media: davinci: vpfe: make sure all the buffers
are released
      [media] media: davinci: vpfe: make sure all the buffers unmapped
and released

Lai Jiangshan (2):
      workqueue: make rescuer_thread() empty wq->maydays list before exiting
      workqueue: fix a possible race condition between rescuer and pwq-release

Lan Tianyu (2):
      ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
      ACPI: Revert "ACPI / Battery: Remove battery's proc directory"

Lars-Peter Clausen (3):
      ASoC: imx-audmux: Fix section mismatch
      ASoC: dapm: Skip CODEC<->CODEC links in connect_dai_link_widgets()
      ASoC: dapm: Fix SUSPEND -> OFF bias sequence

Leif Lindholm (2):
      arm: dts: Fix missing device_type="memory" for ste-ccu8540
      mips: dts: Fix missing device_type="memory" property in memory nodes

Levente Kurusa (1):
      libata: clean up ZPODD when a port is detached

Li Zefan (1):
      cgroup: fix the retry path of cgroup_mount()

Liam Girdwood (8):
      ASoC: Intel: Fix block allocation so we only allocate blocks once.
      ASoC: Intel: Fix allocated block list usage when adding blocks.
      ASoC: Intel: Fix Haswell/Broadwell DSP page table creation.
      ASoC: Intel: Fix Audio DSP usage when IOMMU is enabled.
      ASoC: Intel: Fix allow hw_params to be called more than once.
      ASoC: Intel: Fix stream position pointer.
      ASoC: Intel: Fix check for pdata usage before dereference.
      ASoC: Intel: Fix block offset calculations.

Linus Torvalds (2):
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option
      Linux 3.15-rc6

Liu Bo (1):
      Btrfs: fix EIO on reading file after ioctl clone works on it

Lv Zheng (2):
      ACPICA: Tables: Fix invalid pointer accesses in
acpi_tb_parse_root_table().
      ACPICA: Tables: Restore old behavor to favor 32-bit FADT addresses.

Maciej W. Rozycki (5):
      MIPS: DEC: Bus error handler <asm/cpu-type.h> fixes
      MIPS: DEC/SNI: O32 wrapper stack switching fixes
      MIPS: __delay CPU_DADDI_WORKAROUNDS bug fix
      MIPS: __strncpy_from_user_asm CPU_DADDI_WORKAROUNDS bug fix
      MIPS: csum_partial.S CPU_DADDI_WORKAROUNDS bug fix

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

Mark Brown (1):
      spi: core: Don't destroy master queue if we fail to create it

Mark Salter (1):
      arm64: fix pud_huge() for 2-level pagetables

Markos Chandras (1):
      MIPS: Add new AUDIT_ARCH token for the N32 ABI on MIPS64

Matt Porter (1):
      MAINTAINERS: update Broadcom ARM tree location and add an SoC family

Maxime COQUELIN (1):
      clk: divider: Fix best div calculation for power-of-two and table dividers

Maxime Ripard (2):
      ARM: sun7i: Fix i2c4 base address
      ARM: sunxi: Enable GMAC in sunxi_defconfig

Mengdong Lin (1):
      ALSA: hda - mask buggy stream DMA0 for Broadwell display controller

Michael Welling (1):
      gpio: mcp23s08: Bug fix of SPI device tree registration.

Mika Westerberg (1):
      spi/pxa2xx: Prevent DMA from transferring too many bytes

Mike Snitzer (1):
      dm mpath: fix lock order inconsistency in multipath_ioctl

Miklos Szeredi (3):
      m68k: add renameat2 syscall
      parisc: add renameat2 syscall
      ia64: add renameat2 syscall

Mikulas Patocka (3):
      dm crypt: fix cpu hotplug crash by removing per-cpu structure
      metag: fix memory barriers
      target: fix memory leak on XCOPY

NeilBrown (2):
      md/raid10: call wait_barrier() for each request submitted.
      md: avoid possible spinning md thread at shutdown.

Nicholas Bellinger (3):
      iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
      tcm_fc: Fix free-after-use regression in ft_free_cmd
      iscsi-target: Disable Immediate + Unsolicited Data with ISER Protection

Nicolas Dufresne (1):
      [media] s5p-fimc: Fix YUV422P depth

Nicolin Chen (4):
      ASoC: pcm: Fix incorrect condition check for case
SNDRV_PCM_TRIGGER_SUSPEND
      ASoC: fsl_esai: Fix incorrect condition within ratio range check for FP
      ASoC: fsl_esai: Only bypass sck_div for EXTAL source
      ASoC: fsl_esai: Set PCRC and PRRC registers at the end of hw_params()

Olof Johansson (1):
      i2c: s3c2410: resume race fix

Paul Bolle (1):
      MIPS: Loongson: No need to select GENERIC_HARDIRQS_NO__DO_IRQ

Paul Handrigan (1):
      ASoC: Update Cirrus Logic CODEC maintainers.

Paulo Zanoni (1):
      drm/i915: consider the source max DP lane count too

Philipp Zabel (1):
      imx-drm: imx-drm-core: fix imx_drm_encoder_get_mux_id

Rafael J. Wysocki (2):
      ACPI / proc: Do not say when /proc interfaces will be deleted in Kconfig
      ACPI / TPM: Fix resume regression on Chromebooks

Ralf Baechle (5):
      Revert "MIPS: MT: proc: Add support for printing VPE and TC ids"
      MAINTAINERS: TURBOchannel: Update entry
      MIPS: Remove file missed when removing rm9k support a while ago.
      MIPS: inst.h: Rename BITFIELD_FIELD to __BITFIELD_FIELD.
      MIPS: Wire up renameat2 syscall.

Sagi Grimberg (3):
      Target/iser: Fix wrong connection requests list addition
      Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
      Target/iscsi,iser: Avoid accepting transport connections during stop stage

Salva Peiró (1):
      [media] media-device: fix infoleak in ioctl media_enum_entities()

Sascha Hauer (1):
      ARM: dts: i.MX53: Fix ipu register space size

Sebastian Hesselbarth (1):
      ARM: dts: kirkwood: fix mislocated pcie-controller nodes

Shawn Guo (5):
      imx-drm: imx-drm-core: skip components whose parent device is disabled
      imx-drm: imx-tve: correct DDC property name to 'ddc-i2c-bus'
      ahci: imx: add namespace for register enums
      ahci: imx: software workaround for phy reset issue in resume
      ahci: imx: PLL clock needs 100us to settle down

Stefano Stabellini (1):
      arm64: introduce virt_to_pfn

Stephen Boyd (2):
      clk: Fix double free due to devm_clk_register()
      clk: Fix slab corruption in clk_unregister()

Stephen Rothwell (1):
      of: fix CONFIG_OF=n prototype of of_node_full_name()

Steven J. Hill (1):
      MIPS: mm: Fix broken microMIPS kernel regression.

Su Friendy (1):
      iommu/amd: fix enabling exclusion range for an exact device

Sudeep Holla (1):
      arm64: use cpu_online_mask when using forced irq_set_affinity

Suman Anna (3):
      ARM: dts: OMAP5: Add mailbox dt node to fix boot warning
      ARM: dts: OMAP2: Fix interrupts for OMAP2420 mailbox
      ARM: dts: AM3517: Disable absent IPs inherited from OMAP3

Sylwester Nawrocki (1):
      [media] s5c73m3: Add missing rename of
v4l2_of_get_next_endpoint() function

Tejun Heo (6):
      blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats()
      kernfs, sysfs, cgroup: restrict extra perm check on open to sysfs
      cgroup: introduce task_css_is_root()
      cgroup_freezer: replace freezer->lock with freezer_mutex
      cgroup: fix rcu_read_lock() leak in update_if_frozen()
      sysfs: make sure read buffer is zeroed

Theodore Ts'o (1):
      random: fix BUG_ON caused by accounting simplification

Thomas Gleixner (1):
      ARM: common: edma: Fix xbar mapping

Thomas Petazzoni (11):
      memory: mvebu-devbus: fix the conversion of the bus width
      ARM: orion5x: fix target ID for crypto SRAM window
      bus: mvebu-mbus: allow several windows with the same target/attribute
      PCI: mvebu: split PCIe BARs into multiple MBus windows when needed
      ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree
      ARM: mvebu: use qsgmii phy-mode for Armada XP GP interfaces
      ARM: mvebu: specify I2C bus frequency on Armada 370 DB
      ARM: mvebu: enable the SATA interface on Armada 375 DB
      of: make of_update_property() usable earlier in the boot process

Tony Lindgren (3):
      ARM: dts: Fix bad OTG muxing for cm-t boards
      ARM: dts: Fix GPMC Ethernet timings for omap cm-t sbc-t boards
for device tree
      ARM: dts: Fix GPMC timings for LAN9220

Trond Myklebust (2):
      NFSd: Move default initialisers from create_client() to alloc_client()
      NFSd: call rpc_destroy_wait_queue() from free_client()

Tuomas Tynkkynen (1):
      clk: tegra: Fix wrong value written to PLLE_AUX

Tushar Behera (1):
      dt-bindings: clock: Move at91.h to dt-bindigs/clock

Ulf Hansson (1):
      i2c: nomadik: Don't use IS_ERR for devm_ioremap

Vikas Chaudhary (1):
      iscsi_ibft: Fix finding Broadcom specific ibft sign

Ville Syrjälä (1):
      drm/i915: Increase WM memory latency values on SNB

Vincent Donnefort (1):
      gpio: ich: set regs and reglen for i3100 and ich6 chipset

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()

Vladimir Murzin (1):
      xen/events/fifo: correctly align bitops

Wenkai Du (1):
      ASoC: Intel: Fix audio crash due to race condition in stream deletion

Willy Tarreau (1):
      PCI: mvebu: fix off-by-one in the computed size of the mbus windows

Wolfram Sang (1):
      i2c: rcar: bail out on zero length transfers
