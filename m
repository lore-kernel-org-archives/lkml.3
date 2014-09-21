Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaIUXDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 19:03:24 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:36426 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaIUXDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 19:03:22 -0400
MIME-Version: 1.0
Date: Sun, 21 Sep 2014 16:03:21 -0700
X-Google-Sender-Auth: 6i-P50_cFyHKMgLvfzYH2HA7hRk
Message-ID: <CA+55aFxS42748WK6drajdAm3=x+2YfGUhaOFQ8Ch1KpEZ+7QiA@mail.gmail.com>
Subject: Linux 3.17-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been quiet - enough so that coupled with my upcoming travel, this
might just be the last -rc, and final 3.17 might be next weekend.

Of course, that still depends on what happens - if we have something
scary coming up next week, I may have to delay things. But as it looks
right now, we're all good to go.

The shortlog is appended, but the view from ten thousand feet is
pretty normal: a bit more than half is drivers (gpu, sound, iio,
media, usb), just under a third is arch updates (arm, mips, x86), and
the rest is mainly filesystem updates (gfs2, cifs, btrfs, nfs).

Nothing particular stands out, and I'm not aware of any big pending
issues either. So please go out and test, because this *should* all be
pretty close to release.

            Linus

---

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Al Viro (1):
      GFS2: fix d_splice_alias() misuses

Alan Stern (1):
      USB: EHCI: unlink QHs even after the controller has stopped

Alex Deucher (7):
      drm/radeon/dpm: fix resume on mullins
      drm/radeon: don't reset dma on NI/SI init
      drm/radeon: don't reset sdma on CIK init
      drm/radeon: don't reset dma on r6xx-evergreen init
      vgaswitcheroo: add vga_switcheroo_fini_domain_pm_ops
      drm/radeon/px: fix module unload
      drm/nouveau/runpm: fix module unload

Amos Kong (2):
      virtio-rng: fix stuck of hot-unplugging busy device
      virtio-rng: skip reading when we start to remove the device

Andrey Utkin (1):
      arch/mips/net/bpf_jit.c: fix failure check

Antti Palosaari (2):
      [media] Kconfig: do not select SPI bus on sub-driver auto-select
      [media] af9033: feed clock to RF tuner

Arnd Bergmann (1):
      cifs: remove dead code

Aurelien Jarno (1):
      MIPS: ZBOOT: add missing <linux/string.h> include

Axel Lin (2):
      spi: fsl: Don't use devm_kzalloc in master->setup callback
      spi: dw: Don't use devm_kzalloc in master->setup callback

Bartlomiej Zolnierkiewicz (2):
      phy: spear1310-miphy: fix driver dependencies
      phy: spear1340-miphy: fix driver dependencies

Ben Skeggs (1):
      drm/nouveau: ltc/gf100-: fix cbc issues on certain boards

Benjamin Coddington (1):
      GFS2: Hash the negative dentry during inode lookup

Benjamin Gaignard (1):
      drm: sti: do not iterate over the info frame array

Bimow Chen (2):
      [media] af9033: update IT9135 tuner inittabs
      [media] it913x: init tuner on attach

Bjorn Helgaas (3):
      PCI: Add pci_ignore_hotplug() to ignore hotplug events for a device
      PCI: Remove "no hotplug settings from platform" warning
      ACPIPHP / radeon / nouveau: Remove acpi_bus_no_hotplug()

Bob Peterson (2):
      GFS2: Change maxlen variables to size_t
      GFS2: Request demote when a "try" flock fails

Bruno Prémont (2):
      vgaarb: Don't default exclusively to first video device with mem+io
      vgaarb: Drop obsolete #ifndef

Charles Keepax (1):
      ASoC: samsung-i2s: Check secondary DAI exists before referencing

Chris Mason (1):
      Revert "Btrfs: device_list_add() should not update list when mounted"

Chris Wilson (1):
      drm/i915: Fix SRC_COPY width on 830/845g

Christoph Hellwig (1):
      [SCSI] fix regression that accidentally disabled block-based tcq

Cong Wang (1):
      perf: Fix a race condition in perf_remove_from_context()

Dan Carpenter (1):
      staging: vt6655: buffer overflow in ioctl

Daniel Gryniewicz (1):
      [SCSI] fix for bidi use after free

Denis CIOCCA (1):
      iio:magnetometer: bugfix magnetometers gain values

Dmitry Torokhov (1):
      Input: atkbd - do not try 'deactivate' keyboard on any LG laptops

Doug Anderson (3):
      spi/rockchip: Fix the wait_for_idle() timeout
      spi/rockchip: Don't warn if SPI is busy but disabled
      spi/rockchip: Mark DMA as optional

Fabian Frederick (1):
      GFS2: fs/gfs2/super.c: replace seq_printf by seq_puts

Filipe Manana (1):
      Btrfs: set inode's logged_trans/last_log_commit after ranged fsync

Geert Uytterhoeven (1):
      MIPS: Spelling s/confugrations/configurations/

Gerd Hoffmann (2):
      drm/cirrus: add missing drm_connector_register call
      drm/bochs: add missing drm_connector_register call

Grygorii Strashko (2):
      spi: davinci: request cs_gpio's from probe
      spi: davinci: remove empty function davinci_spi_cleanup

Guenter Roeck (1):
      MIPS: NL: Fix nlm_xlp_defconfig build error

Guodong Xu (1):
      regulator: remove unnecessary of_node_get() to parent

Hans Verkuil (1):
      [media] cx18: fix kernel oops with tda8290 tuner

Hans de Goede (3):
      Input: i8042 - add Fujitsu U574 to no_timeout dmi table
      Input: i8042 - add nomux quirk for Avatar AVIU-145A6
      Input: i8042 - also set the firmware id for MUXed ports

Hauke Mehrtens (1):
      MIPS: BCM47XX: Fix reboot problem on BCM4705/BCM4785

Herbert Xu (1):
      crypto: drbg - backport "fix maximum value checks on 32 bit systems"

Huacai Chen (2):
      MIPS: Loongson: Fix COP2 usage for preemptible kernel
      MIPS: Move CPU topology macros to topology.h

James Hogan (1):
      vfs: workaround gcc <4.6 build error in link_path_walk()

Jan Kara (1):
      GFS2: Don't use MAXQUOTAS value

Jan-Simon Möller (1):
      x86/mm: Apply the section attribute to the variable, not its type

Jiang Liu (1):
      x86, irq: Fix build error caused by 9eabc99a635a77cbf09

Jianqun (3):
      ASoC: rockchip-i2s: fix master mode set bit error
      ASoC: rockchip-i2s: fix registers' property of rockchip i2s controller
      ASoC: rockchip-i2s: dt: swap tx and rx channed request number in example

Joern Engel (1):
      iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Johannes Pointner (1):
      iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name

Julia Lawall (1):
      MIPS: BCM63xx: delete double assignment

Jyri Sarha (1):
      ASoC: tlv320aic31xx: Fix 24bit samples with I2S format and 12MHz mclk

Konstantin Khlebnikov (1):
      ARM: 8132/1: LPAE: drop wrong carry flag correction after adding
TTBR1_OFFSET

Krzysztof Hałasa (1):
      Fix unbalanced mutex in dma_pool_create().

Kyle McMartin (1):
      drm/radeon: delete unused PTE_* defines

Lars Persson (1):
      MIPS: Remove race window in page fault handling

Lee Jones (1):
      phy: miphy365x: Fix off-by-one error

Linus Torvalds (2):
      vfs: simplify and shrink stack frame of link_path_walk()
      Linux 3.17-rc6

Lucas Stach (2):
      MAINTAINERS: Add Lucas Stach as co-maintainer for i.MX6 PCI driver
      PCI: imx6: Put LTSSM in "Detect" state before disabling it

Ludovic Desroches (1):
      iio: adc: at91: don't use the last converted data register

Malcolm Priestley (1):
      [media] af9035: new IDs: add support for PCTV 78e and PCTV 79e

Manuel Lauss (1):
      MIPS: Alchemy: Fix db1200 PSC clock enablement

Mark (3):
      USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter
      USB: storage: Add quirk for Ariston Technologies iConnect USB to
SCSI adapter
      USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters

Mark Salter (1):
      efi/arm64: Fix fdt-related memory reservation

Markos Chandras (8):
      MIPS: Malta: Improve system memory detection for '{e, }memsize' >= 2G
      MIPS: syscall: Fix AUDIT value for O32 processes on MIPS64
      MIPS: scall64-o32: Fix indirect syscall detection
      MIPS: EVA: Add new EVA header
      MIPS: Malta: EVA: Rename 'eva_entry' to 'platform_eva_init'
      MIPS: CPS: Initialize EVA before bringing up VPEs from secondary cores
      MIPS: Kconfig: Select SMP symbols for CMP
      MIPS: SmartMIPS: Disable assembler warnings

Markus Pargmann (1):
      regmap: Fix debugfs-file 'registers' mode

Mathias Krause (1):
      x86-64, ptdump: Mark espfix area only if existent

Matt Fleming (1):
      x86/efi: Fixup GOT in all boot code paths

Michel Dänzer (2):
      drm/radeon: Disable HDP flush before every CS again for < r600
      drm/radeon: Fix typo 'addr' -> 'entry' in rs400_gart_set_page

Mike Christie (1):
      [SCSI] libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

Nathan Lynch (1):
      ARM: 8148/1: flush TLS and thumbee register state during exec

NeilBrown (1):
      NFS: remove BUG possibility in nfs4_open_and_get_state

Nicholas Bellinger (2):
      iscsi-target: Ignore ICF_GOT_LAST_DATAOUT during Data-Out ITT lookup
      iscsi-target: Fix memory corruption in iscsit_logout_post_handler_diffcid

Nick Dyer (1):
      Input: atmel_mxt_ts - fix merge in DT documentation

Paul Gortmaker (1):
      Revert "init: make rootdelay=N consistent with rootwait behaviour"

Paul Handrigan (1):
      ASoC: cs4265: Fix register address to set the proper data type.

Peter Ujfalusi (1):
      ASoC: davinci-mcasp: Correct rx format unit configuration

Punit Agrawal (1):
      ARM: 8135/1: Fix in-correct barrier usage in SWP{B} emulation

Qiao Zhou (1):
      ASoC: soc-pcm: fix dpcm_path_get error handling

Qipan Li (2):
      spi: sirf: enable RX_IO_DMA_INT interrupt
      spi: sirf: add fifo reset/start for cmd transfer

Rajeev Kumar (2):
      ASoC: dwc: Update email id of the author
      ASoC: Update email id of the author

Ralf Baechle (3):
      MIPS: GIC: Remove useless parens from GICBIS().
      MIPS: COP2: CPP macro safety fixes.
      MIPS: Wire up new syscalls getrandom and memfd_create.

Roland Stigge (1):
      spi/pl022: Fix error message

Sagi Grimberg (4):
      Target/iser: Get isert_conn reference once got to connected_handler
      Target/iser: Don't put isert_conn inside disconnected handler
      Target/iser: Avoid calling rdma_disconnect twice
      Target/iser: Fix initiator_depth and responder_resources

Sakari Ailus (2):
      [media] smiapp: Fix power count handling
      [media] smiapp: Set sub-device owner

Sebastian Herbszt (2):
      target: Fix user data segment multiplier in spc_emulate_evpd_b3()
      target: Fix inverted logic in SE_DEV_ALUA_SUPPORT_STATE_STORE

Sergey Ryazanov (2):
      MIPS: MSP71xx: remove unused plat_irq_dispatch() argument
      MIPS: Add common plat_irq_dispatch declaration

Srinivas Pandruvada (8):
      iio:trigger: modify return value for iio_trigger_get
      iio: accel: bma180: Fix indio_dev->trig assignment
      iio: adc: ad_sigma_delta: Fix indio_dev->trig assignment
      iio: hid_sensor_hub: Fix indio_dev->trig assignment
      iio: st_sensors: Fix indio_dev->trig assignment
      iio: gyro: itg3200: Fix indio_dev->trig assignment
      iio: inv_mpu6050: Fix indio_dev->trig assignment
      iio: meter: ade7758: Fix indio_dev->trig assignment

Stephan Mueller (1):
      crypto: drbg - remove check for uninitialized DRBG handle

Stephen Boyd (1):
      ARM: 8149/1: perf: Don't sleep while atomic when enabling
per-cpu interrupts

Steve Dickson (1):
      NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()

Steve French (5):
      [CIFS] Fix setting time before epoch (negative time values)
      [SMB3] Fix oops when creating symlinks on smb3
      Revert "cifs: No need to send SIGKILL to demux_thread during umount"
      Update version number displayed by modinfo for cifs.ko
      Fix mfsymlinks file size check

Subbaraya Sundeep Bhatta (1):
      iio: adc: xilinx-xadc: assign auxiliary channels address correctly

Sudeep Holla (1):
      ARM: 8133/1: use irq_set_affinity with force=false when migrating irqs

Takashi Iwai (1):
      ALSA: hda - Fix invalid pin powermap without jack detection

Thomas Bogendoerfer (2):
      MIPS: IP28: Select correct L1_CACHE_SHIFT
      MIPS: IP28: Fix/clean spaces.h

Tony Luck (1):
      ia64: Fix syscall number for memfd_create

Trond Myklebust (1):
      NFSv4: Fix another bug in the close/open_downgrade code

Victor Kamensky (2):
      ARM: 8137/1: fix get_user BE behavior for target variable with
size of 8 bytes
      ARM: 8151/1: add missing exports for asm functions required by
get_user macro

Ville Syrjälä (1):
      drm/i915: Add limited color range readout for HDMI/DP ports on g4x/vlv/chv

Wang Nan (1):
      kprobes/x86: Free 'optinsn' cache when range check fails

Wei Yongjun (1):
      MIPS: Remove duplicated include from numa.c

Yang Wei (2):
      MIPS: kdump: Set correct value to kexec_indirection_page variable
      MIPS: perf: Mark pmu interupt IRQF_NO_THREAD

Yinghai Lu (1):
      x86/efi: Only load initrd above 4g on second try

Zubair Lutfullah Kakakhel (1):
      MIPS: Fix a warning for virt_to_page
