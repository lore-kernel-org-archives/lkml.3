Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044Ab3BTALi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:11:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35268 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3BTALf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:11:35 -0500
Date: Wed, 20 Feb 2013 11:11:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [GIT PULL UPDATED] workqueue core changes for 3.9-rc1
Message-Id: <20130220111125.8040fb7cd9c74c80baab6dde@canb.auug.org.au>
In-Reply-To: <20130219181356.GP17414@htj.dyndns.org>
References: <20130219173937.GM17414@htj.dyndns.org>
	<20130219181356.GP17414@htj.dyndns.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_11_11_25_+1100_sXZd2YdQ4ILCH/=X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_11_11_25_+1100_sXZd2YdQ4ILCH/=X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 19 Feb 2013 10:13:56 -0800 Tejun Heo <tj@kernel.org> wrote:
>
> wq/for-3.8-fixes contained one commit to drop _GPL from
> delayed_work_timer_fn() export (a regression which prevents
> out-of-kernel users from using delayed_work) which didn't get pushed
> out and I forgot to cherry pick it.
>=20
> Everything else is the same other than one more commit at the top -
> 1438ade567 ("workqueue: un-GPL function delayed_work_timer_fn()").
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git=20
>=20
> for you to fetch changes up to 1438ade5670b56d5386c220e1ad4b5a824a1e585:
>=20
>   workqueue: un-GPL function delayed_work_timer_fn() (2013-02-19 10:09:13=
 -0800)
>=20
>=20
>  include/linux/async.h            |    1 +
>  include/linux/workqueue.h        |   35 +-
>  include/trace/events/workqueue.h |   10 +-
>  kernel/async.c                   |   14 +
>  kernel/sched/core.c              |    2 +-
>  kernel/workqueue.c               | 1530 ++++++++++++++++++--------------=
------
>  kernel/workqueue_internal.h      |   65 ++
>  kernel/workqueue_sched.h         |    9 -
>  8 files changed, 818 insertions(+), 848 deletions(-)
>  create mode 100644 kernel/workqueue_internal.h
>  delete mode 100644 kernel/workqueue_sched.h

This is very different from what has been in linux-next (it looks like
you have been cherry-picking fixes from other sources into your for-next
branch?):

$ git diff --stat -M -C origin/master..workqueues/for-next
 Documentation/device-mapper/dm-raid.txt            |    1 -
 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    5 +-
 Documentation/hid/hid-sensor.txt                   |    0
 Documentation/kernel-parameters.txt                |    2 +-
 Documentation/x86/boot.txt                         |   28 +-
 Documentation/x86/zero-page.txt                    |    4 -
 MAINTAINERS                                        |   28 +-
 Makefile                                           |    6 +-
 arch/arm/boot/dts/armada-370-db.dts                |    2 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |   14 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |   21 +-
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           |   21 +-
 arch/arm/boot/dts/at91rm9200.dtsi                  |    4 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   60 +-
 arch/arm/boot/dts/cros5250-common.dtsi             |   12 +-
 arch/arm/boot/dts/dove-cubox.dts                   |   14 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi         |   16 -
 arch/arm/boot/dts/kirkwood.dtsi                    |    2 -
 arch/arm/boot/dts/kizbox.dts                       |    2 -
 arch/arm/boot/dts/sunxi.dtsi                       |    6 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |    2 +
 arch/arm/common/gic.c                              |   25 +-
 arch/arm/configs/at91_dt_defconfig                 |    3 +-
 arch/arm/include/asm/memory.h                      |    2 +-
 arch/arm/include/asm/smp_scu.h                     |    8 +-
 arch/arm/kernel/debug.S                            |    2 -
 arch/arm/kernel/head.S                             |    5 +-
 arch/arm/kernel/hyp-stub.S                         |   18 +-
 arch/arm/kernel/smp_scu.c                          |    2 +-
 arch/arm/mach-at91/setup.c                         |    2 -
 arch/arm/mach-exynos/Kconfig                       |    2 +-
 arch/arm/mach-highbank/highbank.c                  |    3 +-
 arch/arm/mach-highbank/sysregs.h                   |    4 +-
 arch/arm/mach-imx/Kconfig                          |    1 -
 arch/arm/mach-imx/clk-imx25.c                      |    6 +-
 arch/arm/mach-imx/clk-imx27.c                      |    6 +-
 arch/arm/mach-imx/clk-imx31.c                      |    6 +-
 arch/arm/mach-imx/clk-imx35.c                      |    6 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                |    6 +-
 arch/arm/mach-imx/clk-imx6q.c                      |    3 -
 arch/arm/mach-imx/common.h                         |    1 -
 arch/arm/mach-imx/devices/devices-common.h         |    1 -
 arch/arm/mach-imx/devices/platform-fsl-usb2-udc.c  |   15 +-
 arch/arm/mach-imx/devices/platform-imx-fb.c        |    2 +-
 arch/arm/mach-imx/hotplug.c                        |   10 +-
 .../imx-iram.h =3D> arch/arm/mach-imx/iram.h         |    0
 arch/arm/mach-imx/iram_alloc.c                     |    3 +-
 arch/arm/mach-imx/platsmp.c                        |    1 -
 arch/arm/mach-imx/pm-imx6q.c                       |    1 -
 arch/arm/mach-integrator/pci_v3.c                  |   14 +-
 arch/arm/mach-kirkwood/board-ns2.c                 |   38 +
 arch/arm/mach-mvebu/Makefile                       |    2 -
 arch/arm/mach-omap2/board-omap4panda.c             |    6 -
 arch/arm/mach-omap2/cclock2420_data.c              |    2 -
 arch/arm/mach-omap2/cclock2430_data.c              |    2 -
 arch/arm/mach-omap2/cclock44xx_data.c              |   13 +-
 arch/arm/mach-omap2/devices.c                      |    2 +-
 arch/arm/mach-omap2/drm.c                          |    3 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    6 +-
 arch/arm/mach-omap2/timer.c                        |    8 +-
 arch/arm/mach-realview/include/mach/irqs-eb.h      |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    2 +-
 arch/arm/mach-s3c64xx/pm.c                         |    2 -
 arch/arm/mm/dma-mapping.c                          |   20 +-
 arch/arm/mm/mmu.c                                  |    2 +-
 arch/arm/plat-versatile/headsmp.S                  |    2 +-
 arch/arm/vfp/entry.S                               |    6 +-
 arch/arm/vfp/vfphw.S                               |    4 +-
 arch/arm64/include/asm/elf.h                       |    5 +-
 arch/avr32/include/asm/dma-mapping.h               |   10 -
 arch/blackfin/include/asm/dma-mapping.h            |   10 -
 arch/c6x/include/asm/dma-mapping.h                 |   15 -
 arch/cris/include/asm/dma-mapping.h                |   10 -
 arch/frv/include/asm/dma-mapping.h                 |   15 -
 arch/m68k/include/asm/dma-mapping.h                |   26 -
 arch/m68k/include/asm/processor.h                  |    1 +
 arch/m68k/include/asm/unistd.h                     |    2 +-
 arch/m68k/include/uapi/asm/unistd.h                |    1 -
 arch/m68k/kernel/syscalltable.S                    |    1 -
 arch/mips/bcm47xx/Kconfig                          |    3 -
 arch/mips/cavium-octeon/executive/cvmx-l2c.c       |    9 +-
 arch/mips/include/{uapi =3D> }/asm/break.h           |    0
 arch/mips/include/asm/dsp.h                        |    2 +-
 arch/mips/include/asm/inst.h                       |    1 -
 arch/mips/include/asm/mach-pnx833x/war.h           |    2 +-
 arch/mips/include/asm/pgtable-64.h                 |    1 -
 arch/mips/include/uapi/asm/Kbuild                  |    1 -
 arch/mips/kernel/ftrace.c                          |   36 +-
 arch/mips/kernel/mcount.S                          |    7 +-
 arch/mips/kernel/vpe.c                             |    2 +-
 arch/mips/lantiq/irq.c                             |    2 +-
 arch/mips/lib/delay.c                              |    2 +-
 arch/mips/mm/ioremap.c                             |    6 +
 arch/mips/mm/mmap.c                                |    6 -
 arch/mips/netlogic/xlr/setup.c                     |    5 +-
 arch/mips/pci/pci-ar71xx.c                         |    2 +-
 arch/mips/pci/pci-ar724x.c                         |    2 +-
 arch/mn10300/include/asm/dma-mapping.h             |   15 -
 arch/parisc/include/asm/dma-mapping.h              |   15 -
 arch/powerpc/kernel/entry_32.S                     |    2 -
 arch/powerpc/kernel/entry_64.S                     |   13 -
 arch/powerpc/kernel/kgdb.c                         |    5 +-
 arch/powerpc/kernel/time.c                         |    9 +-
 arch/powerpc/kvm/emulate.c                         |    2 -
 arch/powerpc/mm/hash_low_64.S                      |   62 +-
 arch/powerpc/oprofile/op_model_power4.c            |    2 +-
 arch/powerpc/platforms/pasemi/cpufreq.c            |    7 -
 arch/s390/include/asm/pgtable.h                    |   12 -
 arch/s390/kernel/time.c                            |    3 -
 arch/sparc/Kconfig                                 |    1 -
 arch/sparc/include/asm/pgtable_64.h                |   14 +-
 arch/sparc/kernel/sbus.c                           |    6 +-
 arch/sparc/mm/gup.c                                |   59 +-
 arch/tile/Kconfig                                  |    2 -
 arch/tile/include/asm/io.h                         |    6 +-
 arch/tile/include/asm/irqflags.h                   |   32 +-
 arch/tile/include/uapi/arch/interrupts_32.h        |  394 +++--
 arch/tile/include/uapi/arch/interrupts_64.h        |  346 +++--
 arch/tile/kernel/intvec_64.S                       |    4 -
 arch/tile/kernel/process.c                         |    2 +-
 arch/tile/kernel/reboot.c                          |    2 -
 arch/tile/kernel/setup.c                           |    5 -
 arch/tile/kernel/stack.c                           |    3 +-
 arch/tile/lib/cacheflush.c                         |    2 -
 arch/tile/lib/cpumask.c                            |    2 -
 arch/tile/lib/exports.c                            |    2 -
 arch/tile/mm/homecache.c                           |    1 -
 arch/x86/Kconfig                                   |    1 -
 arch/x86/boot/Makefile                             |    4 +-
 arch/x86/boot/compressed/eboot.c                   |   21 +-
 arch/x86/boot/compressed/head_32.S                 |    8 +-
 arch/x86/boot/compressed/head_64.S                 |    8 +-
 arch/x86/boot/header.S                             |   39 +-
 arch/x86/boot/setup.ld                             |    2 +-
 arch/x86/boot/tools/build.c                        |   81 +-
 arch/x86/ia32/ia32entry.S                          |    4 +-
 arch/x86/include/asm/efi.h                         |    1 -
 arch/x86/include/asm/mce.h                         |   84 --
 arch/x86/include/asm/pgtable.h                     |    5 -
 arch/x86/include/asm/uv/uv.h                       |    2 +-
 arch/x86/include/uapi/asm/bootparam.h              |   63 +-
 arch/x86/include/uapi/asm/mce.h                    |   87 ++
 arch/x86/kernel/apic/x2apic_phys.c                 |   21 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |    7 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |   14 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |    6 +-
 arch/x86/kernel/cpu/perf_event_p6.c                |    2 +-
 arch/x86/kernel/entry_64.S                         |    7 +-
 arch/x86/kernel/head_32.S                          |    9 +-
 arch/x86/kernel/msr.c                              |    3 -
 arch/x86/kernel/pci-dma.c                          |    2 +-
 arch/x86/kernel/reboot.c                           |    2 +-
 arch/x86/kernel/setup.c                            |   28 +-
 arch/x86/mm/fault.c                                |    8 +-
 arch/x86/mm/init_64.c                              |    3 -
 arch/x86/platform/efi/efi.c                        |   59 +-
 arch/x86/platform/efi/efi_64.c                     |   22 +-
 arch/x86/platform/uv/tlb_uv.c                      |   10 +-
 arch/x86/tools/insn_sanity.c                       |   10 +-
 arch/x86/tools/relocs.c                            |    6 +-
 arch/x86/xen/enlighten.c                           |   77 +-
 arch/x86/xen/suspend.c                             |    2 +-
 arch/x86/xen/xen-asm_32.S                          |   14 +-
 arch/x86/xen/xen-ops.h                             |    2 +-
 arch/xtensa/include/asm/dma-mapping.h              |   15 -
 block/elevator.c                                   |   35 +-
 block/genhd.c                                      |   42 +-
 drivers/acpi/apei/apei-base.c                      |    3 -
 drivers/acpi/osl.c                                 |    2 +-
 drivers/acpi/processor_idle.c                      |    4 -
 drivers/acpi/processor_perflib.c                   |    7 -
 drivers/atm/iphase.h                               |  146 +-
 drivers/base/regmap/regmap-debugfs.c               |    2 +
 drivers/base/regmap/regmap.c                       |    2 +-
 drivers/bcma/bcma_private.h                        |    5 -
 drivers/bcma/driver_chipcommon_nflash.c            |    2 +-
 drivers/bcma/driver_gpio.c                         |    5 -
 drivers/bcma/main.c                                |    7 -
 drivers/block/drbd/drbd_req.c                      |    2 +-
 drivers/block/drbd/drbd_req.h                      |    1 -
 drivers/block/drbd/drbd_state.c                    |    7 -
 drivers/block/mtip32xx/mtip32xx.c                  |   24 +-
 drivers/block/sunvdc.c                             |    2 +-
 drivers/block/xen-blkback/blkback.c                |   18 +-
 drivers/block/xen-blkfront.c                       |   10 +-
 drivers/bluetooth/ath3k.c                          |   10 -
 drivers/bluetooth/btusb.c                          |    5 -
 drivers/char/virtio_console.c                      |    3 +-
 drivers/clk/mvebu/clk-cpu.c                        |    9 +-
 drivers/cpufreq/Kconfig.x86                        |    2 +-
 drivers/cpufreq/acpi-cpufreq.c                     |    7 -
 drivers/cpufreq/cpufreq-cpu0.c                     |    5 -
 drivers/cpufreq/omap-cpufreq.c                     |    3 -
 drivers/devfreq/devfreq.c                          |    5 -
 drivers/devfreq/exynos4_bus.c                      |   94 +-
 drivers/dma/imx-dma.c                              |    5 +-
 drivers/dma/ioat/dma_v3.c                          |    2 +-
 drivers/dma/tegra20-apb-dma.c                      |    8 +-
 drivers/edac/edac_mc.c                             |    6 +-
 drivers/edac/edac_pci_sysfs.c                      |    2 +-
 drivers/firmware/dmi_scan.c                        |    2 +-
 drivers/firmware/efivars.c                         |    9 +-
 drivers/firmware/iscsi_ibft_find.c                 |    2 +-
 drivers/gpu/drm/exynos/Kconfig                     |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c      |   33 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |   24 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c           |    9 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h           |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c            |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   26 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  121 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |    9 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    2 -
 drivers/gpu/drm/i915/i915_reg.h                    |    1 -
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   24 +-
 drivers/gpu/drm/nouveau/core/core/falcon.c         |    7 +-
 drivers/gpu/drm/nouveau/core/core/subdev.c         |    2 +-
 drivers/gpu/drm/nouveau/core/include/core/object.h |    7 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/base.c      |    4 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |    5 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    1 -
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    3 -
 drivers/gpu/drm/radeon/evergreen.c                 |   27 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   86 +-
 drivers/gpu/drm/radeon/ni.c                        |    8 +-
 drivers/gpu/drm/radeon/r600.c                      |   15 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   38 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |    6 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |    8 -
 drivers/gpu/drm/radeon/radeon_cs.c                 |    2 -
 drivers/gpu/drm/radeon/radeon_cursor.c             |    3 +-
 drivers/gpu/drm/radeon/radeon_device.c             |    3 +-
 drivers/gpu/drm/radeon/radeon_display.c            |    6 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |    3 -
 drivers/gpu/drm/radeon/radeon_ttm.c                |    1 -
 drivers/gpu/drm/radeon/reg_srcs/cayman             |    1 -
 drivers/gpu/drm/radeon/rv515.c                     |    2 -
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |   13 +-
 drivers/hid/hid-ids.h                              |    3 -
 drivers/hid/i2c-hid/i2c-hid.c                      |   13 +-
 drivers/hid/usbhid/hid-quirks.c                    |    1 -
 drivers/i2c/busses/i2c-designware-core.c           |    4 -
 drivers/i2c/busses/i2c-mxs.c                       |    6 +-
 drivers/i2c/busses/i2c-omap.c                      |    6 +-
 drivers/i2c/busses/i2c-sirf.c                      |    4 -
 drivers/i2c/muxes/i2c-mux-pinctrl.c                |    2 +-
 drivers/idle/intel_idle.c                          |    3 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |   11 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |    6 +-
 drivers/input/input.c                              |   16 +-
 drivers/input/joystick/analog.c                    |    2 +-
 drivers/input/keyboard/lm8323.c                    |    2 +-
 drivers/input/tablet/wacom_sys.c                   |    6 +-
 drivers/iommu/amd_iommu_init.c                     |   34 -
 drivers/iommu/intel-iommu.c                        |   21 +-
 drivers/isdn/gigaset/capi.c                        |    2 -
 drivers/md/dm-raid.c                               |  101 +-
 drivers/md/dm-thin.c                               |   13 +-
 drivers/md/dm.c                                    |    6 +-
 drivers/media/dvb-core/dvb_frontend.c              |    6 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |    2 +-
 drivers/media/platform/coda.c                      |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    3 +
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   88 +-
 drivers/media/radio/radio-keene.c                  |    1 -
 drivers/media/radio/radio-si4713.c                 |    1 -
 drivers/media/radio/radio-wl1273.c                 |    1 -
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |   10 -
 drivers/media/usb/gspca/kinect.c                   |    1 -
 drivers/media/usb/gspca/sonixb.c                   |   13 +-
 drivers/media/usb/gspca/sonixj.c                   |    1 -
 drivers/media/usb/uvc/uvc_ctrl.c                   |    4 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |    6 +-
 drivers/media/v4l2-core/videobuf2-core.c           |    4 +-
 drivers/mfd/Kconfig                                |    1 -
 drivers/mfd/ab8500-core.c                          |    1 -
 drivers/mfd/arizona-core.c                         |    7 +-
 drivers/mfd/arizona-irq.c                          |   18 +-
 drivers/mfd/da9052-i2c.c                           |   61 -
 drivers/mfd/db8500-prcmu.c                         |   13 +-
 drivers/mfd/max77686.c                             |   18 +-
 drivers/mfd/max77693.c                             |   34 +-
 drivers/mfd/pcf50633-core.c                        |    5 +-
 drivers/mfd/rtl8411.c                              |   29 -
 drivers/mfd/rts5209.c                              |   21 -
 drivers/mfd/rts5229.c                              |   21 -
 drivers/mfd/rtsx_pcr.c                             |   27 +-
 drivers/mfd/tc3589x.c                              |   17 +-
 drivers/mfd/twl4030-power.c                        |    2 +-
 drivers/mfd/vexpress-config.c                      |    8 +-
 drivers/mfd/vexpress-sysreg.c                      |   32 +-
 drivers/mfd/wm5102-tables.c                        |    2 +-
 drivers/misc/ti-st/st_kim.c                        |   37 +-
 drivers/mmc/host/mvsdio.c                          |   92 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   30 +-
 drivers/mtd/devices/Kconfig                        |    1 -
 drivers/mtd/maps/physmap_of.c                      |    2 +-
 drivers/mtd/nand/bcm47xxnflash/ops_bcm4706.c       |    4 +-
 drivers/mtd/nand/davinci_nand.c                    |    2 +-
 drivers/mtd/nand/nand_base.c                       |    7 +-
 drivers/net/bonding/bond_sysfs.c                   |    1 -
 drivers/net/can/c_can/c_can.c                      |   10 +-
 drivers/net/can/pch_can.c                          |    2 +-
 drivers/net/can/sja1000/peak_pci.c                 |    3 +-
 drivers/net/can/ti_hecc.c                          |    4 +-
 drivers/net/ethernet/3com/3c574_cs.c               |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   71 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   12 +-
 drivers/net/ethernet/broadcom/tg3.c                |   62 +-
 drivers/net/ethernet/cadence/macb.c                |    5 -
 drivers/net/ethernet/calxeda/xgmac.c               |    4 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   17 +-
 drivers/net/ethernet/emulex/benet/be.h             |    8 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    2 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |    9 -
 drivers/net/ethernet/intel/e1000e/e1000.h          |    2 -
 drivers/net/ethernet/intel/e1000e/ethtool.c        |    2 -
 drivers/net/ethernet/intel/e1000e/hw.h             |    1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   11 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |   46 -
 drivers/net/ethernet/intel/ixgbe/Makefile          |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c   |    5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |    4 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   13 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   13 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |    2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |    7 +-
 drivers/net/ethernet/realtek/r8169.c               |  107 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   10 +-
 drivers/net/ethernet/via/via-rhine.c               |    8 +-
 drivers/net/hyperv/hyperv_net.h                    |    2 +-
 drivers/net/hyperv/netvsc_drv.c                    |    2 +-
 drivers/net/loopback.c                             |    5 -
 drivers/net/macvlan.c                              |    5 +-
 drivers/net/phy/icplus.c                           |   29 +-
 drivers/net/phy/marvell.c                          |    9 +
 drivers/net/tun.c                                  |   83 +-
 drivers/net/usb/cdc_mbim.c                         |   19 -
 drivers/net/usb/cdc_ncm.c                          |   34 +-
 drivers/net/usb/dm9601.c                           |   52 +-
 drivers/net/usb/qmi_wwan.c                         |   16 -
 drivers/net/usb/usbnet.c                           |   39 +-
 drivers/net/virtio_net.c                           |  118 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |    7 +-
 drivers/net/wimax/i2400m/netdev.c                  |   31 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |    2 -
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   27 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    3 +
 drivers/net/wireless/ath/ath9k/beacon.c            |    2 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    1 +
 drivers/net/wireless/ath/ath9k/debug.h             |    2 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    2 -
 drivers/net/wireless/ath/ath9k/hw.h                |    1 -
 drivers/net/wireless/ath/ath9k/main.c              |   22 +-
 drivers/net/wireless/ath/ath9k/recv.c              |   54 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   42 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   40 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    3 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |   31 +-
 drivers/net/wireless/ipw2x00/ipw2100.h             |    3 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |   13 +-
 drivers/net/wireless/iwlegacy/common.c             |   35 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |   26 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |   17 +-
 drivers/net/wireless/mwifiex/pcie.c                |    2 +-
 drivers/net/wireless/mwifiex/scan.c                |    9 +-
 drivers/net/wireless/mwifiex/sdio.c                |    9 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   14 -
 drivers/net/wireless/mwl8k.c                       |   36 +-
 drivers/net/wireless/rtlwifi/Kconfig               |    4 +-
 drivers/net/wireless/rtlwifi/base.c                |    7 +-
 drivers/net/wireless/rtlwifi/usb.c                 |    4 +-
 drivers/net/wireless/ti/wl1251/ps.c                |    3 +-
 drivers/net/xen-netback/common.h                   |    3 -
 drivers/net/xen-netback/interface.c                |   23 +-
 drivers/net/xen-netback/netback.c                  |  115 +-
 drivers/pci/remove.c                               |    2 -
 drivers/pinctrl/Kconfig                            |    5 +-
 drivers/pinctrl/Makefile                           |    2 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c               |    2 +-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c           |    8 +-
 drivers/pinctrl/pinctrl-exynos5440.c               |   10 +-
 drivers/pinctrl/pinctrl-mxs.c                      |    9 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |    2 +-
 drivers/pinctrl/pinctrl-single.c                   |   79 +-
 drivers/pinctrl/pinctrl-sirf.c                     |   18 -
 drivers/platform/x86/ibm_rtl.c                     |    2 +-
 drivers/platform/x86/samsung-laptop.c              |    4 -
 drivers/platform/x86/thinkpad_acpi.c               |    3 +-
 drivers/regulator/dbx500-prcmu.c                   |    1 -
 drivers/regulator/max77686.c                       |   15 +-
 drivers/regulator/max8907-regulator.c              |    3 +-
 drivers/regulator/max8997.c                        |   39 +-
 drivers/regulator/max8998.c                        |    2 +-
 drivers/regulator/of_regulator.c                   |    6 -
 drivers/regulator/s2mps11.c                        |    4 +-
 drivers/regulator/tps65217-regulator.c             |    4 +-
 drivers/regulator/tps65910-regulator.c             |    2 +-
 drivers/regulator/tps80031-regulator.c             |    2 +-
 drivers/rtc/rtc-isl1208.c                          |    3 -
 drivers/rtc/rtc-pl031.c                            |   10 +-
 drivers/rtc/rtc-vt8500.c                           |    2 +-
 drivers/scsi/isci/init.c                           |    2 +-
 drivers/ssb/driver_gpio.c                          |   12 -
 drivers/ssb/main.c                                 |    9 -
 drivers/ssb/ssb_private.h                          |    5 -
 drivers/staging/omapdrm/Kconfig                    |    2 +-
 drivers/target/target_core_device.c                |    8 +-
 drivers/target/target_core_fabric_configfs.c       |    5 -
 drivers/target/target_core_sbc.c                   |   18 +-
 drivers/target/target_core_spc.c                   |   44 +-
 drivers/tty/serial/max3100.c                       |    3 +-
 drivers/usb/core/hcd.c                             |   44 -
 drivers/usb/core/hub.c                             |   70 +-
 drivers/usb/dwc3/gadget.c                          |    1 -
 drivers/usb/gadget/f_fs.c                          |    6 +-
 drivers/usb/gadget/fsl_mxc_udc.c                   |   40 +-
 drivers/usb/gadget/fsl_udc_core.c                  |   42 +-
 drivers/usb/gadget/fsl_usb2_udc.h                  |    5 +-
 drivers/usb/host/Kconfig                           |    2 +-
 drivers/usb/host/Makefile                          |    1 -
 drivers/usb/host/ehci-hcd.c                        |   13 +-
 drivers/usb/host/ehci-hub.c                        |    9 +-
 drivers/usb/host/ehci-mxc.c                        |  120 +-
 drivers/usb/host/ehci-q.c                          |   50 +-
 drivers/usb/host/ehci-sched.c                      |    9 +-
 drivers/usb/host/ehci-timer.c                      |   29 +-
 drivers/usb/host/ehci.h                            |    7 -
 drivers/usb/host/pci-quirks.c                      |    1 -
 drivers/usb/host/uhci-hcd.c                        |   15 +-
 drivers/usb/host/uhci-hub.c                        |    3 -
 drivers/usb/host/xhci-ring.c                       |   13 +-
 drivers/usb/musb/cppi_dma.c                        |    4 +-
 drivers/usb/serial/cp210x.c                        |    1 -
 drivers/usb/serial/ftdi_sio.c                      |    2 -
 drivers/usb/serial/ftdi_sio_ids.h                  |    9 +-
 drivers/usb/serial/option.c                        |   13 -
 drivers/usb/serial/qcserial.c                      |    1 -
 drivers/usb/storage/initializers.c                 |   76 +-
 drivers/usb/storage/initializers.h                 |    4 +-
 drivers/usb/storage/unusual_devs.h                 |  329 ++++-
 drivers/usb/storage/usb.c                          |   12 -
 drivers/usb/storage/usual-tables.c                 |   15 -
 drivers/vhost/net.c                                |   41 +-
 drivers/vhost/tcm_vhost.c                          |    4 +-
 drivers/vhost/vhost.c                              |   18 +-
 drivers/vhost/vhost.h                              |    2 +-
 drivers/video/exynos/exynos_dp_core.c              |    6 +-
 drivers/video/imxfb.c                              |   13 +-
 drivers/video/omap2/dss/dss_features.c             |    1 -
 drivers/xen/events.c                               |    4 +-
 drivers/xen/pcpu.c                                 |    3 +-
 drivers/xen/xen-pciback/pciback_ops.c              |   14 +-
 fs/btrfs/extent-tree.c                             |   28 +-
 fs/btrfs/extent_map.c                              |   14 +-
 fs/btrfs/extent_map.h                              |    1 -
 fs/btrfs/file-item.c                               |    4 +-
 fs/btrfs/file.c                                    |   35 +-
 fs/btrfs/free-space-cache.c                        |   20 +-
 fs/btrfs/inode.c                                   |  137 +-
 fs/btrfs/ioctl.c                                   |  134 +-
 fs/btrfs/ordered-data.c                            |   13 +-
 fs/btrfs/qgroup.c                                  |   20 +-
 fs/btrfs/scrub.c                                   |   25 +-
 fs/btrfs/send.c                                    |    4 +-
 fs/btrfs/super.c                                   |    2 +-
 fs/btrfs/transaction.c                             |   46 +-
 fs/btrfs/tree-log.c                                |   10 +-
 fs/btrfs/volumes.c                                 |   26 +-
 fs/cifs/cifs_dfs_ref.c                             |    2 -
 fs/cifs/connect.c                                  |    2 +-
 fs/dlm/user.c                                      |    8 +-
 fs/gfs2/lock_dlm.c                                 |    7 +-
 fs/nfs/namespace.c                                 |   20 -
 fs/nfs/nfs4client.c                                |   62 +-
 fs/nfs/nfs4state.c                                 |   22 +-
 fs/nfs/super.c                                     |   22 +-
 fs/nilfs2/ioctl.c                                  |    5 +-
 fs/xfs/xfs_aops.c                                  |    2 +-
 fs/xfs/xfs_bmap.c                                  |    6 +-
 fs/xfs/xfs_buf.c                                   |   20 -
 fs/xfs/xfs_buf_item.c                              |   12 +-
 fs/xfs/xfs_dfrag.c                                 |    4 +-
 fs/xfs/xfs_iomap.c                                 |    9 -
 fs/xfs/xfs_mount.c                                 |    2 +-
 fs/xfs/xfs_trace.h                                 |    1 -
 include/asm-generic/dma-mapping-broken.h           |   16 -
 include/linux/async.h                              |   10 +-
 include/linux/efi.h                                |   24 +-
 include/linux/elevator.h                           |    5 +
 include/linux/init.h                               |    1 +
 include/linux/llist.h                              |   25 -
 include/linux/memcontrol.h                         |    2 +-
 include/linux/mfd/abx500.h                         |    2 +
 include/linux/mfd/abx500/ab8500-bm.h               |   29 +-
 include/linux/mfd/da9052/da9052.h                  |   66 +-
 include/linux/mfd/da9052/reg.h                     |    3 -
 include/linux/mfd/rtsx_common.h                    |    3 -
 include/linux/mfd/rtsx_pci.h                       |   25 +-
 include/linux/mmu_notifier.h                       |    2 +-
 include/linux/security.h                           |   59 +-
 include/linux/usb.h                                |    2 -
 include/linux/usb/hcd.h                            |    3 -
 include/linux/usb/usbnet.h                         |    3 -
 include/linux/workqueue.h                          |   35 +-
 include/net/ip.h                                   |    2 -
 include/net/netfilter/nf_conntrack_core.h          |    2 -
 include/net/transp_v6.h                            |   22 +-
 include/trace/events/workqueue.h                   |   10 +-
 include/uapi/linux/auto_fs.h                       |   25 +-
 include/uapi/linux/usb/ch9.h                       |    6 -
 init/do_mounts_initrd.c                            |    3 +
 init/initramfs.c                                   |    8 +-
 init/main.c                                        |   20 +-
 kernel/async.c                                     |  167 +--
 kernel/events/core.c                               |   20 +-
 kernel/kmod.c                                      |    9 +
 kernel/kprobes.c                                   |   23 +-
 kernel/pid.c                                       |    2 +-
 kernel/printk.c                                    |    9 +
 kernel/rcutree_plugin.h                            |   13 +-
 kernel/sched/core.c                                |    2 +-
 kernel/sched/debug.c                               |    4 +-
 kernel/sched/fair.c                                |    2 +-
 kernel/sched/rt.c                                  |    2 +-
 kernel/smp.c                                       |   13 +-
 kernel/workqueue.c                                 | 1528 +++++++++-------=
----
 kernel/workqueue_internal.h                        |   65 +
 kernel/workqueue_sched.h                           |    9 -
 lib/digsig.c                                       |    2 -
 mm/huge_memory.c                                   |    4 -
 mm/hugetlb.c                                       |    1 -
 mm/memcontrol.c                                    |    4 +-
 mm/migrate.c                                       |    4 +-
 mm/mlock.c                                         |    6 +-
 mm/mmap.c                                          |    2 +-
 mm/page_alloc.c                                    |   19 +-
 net/batman-adv/distributed-arp-table.c             |   21 +-
 net/bluetooth/hci_conn.c                           |    6 +-
 net/bluetooth/hci_core.c                           |    8 +
 net/bluetooth/hci_event.c                          |    2 +-
 net/bluetooth/hidp/core.c                          |    2 +-
 net/bluetooth/l2cap_core.c                         |   11 -
 net/bluetooth/sco.c                                |    2 +-
 net/bluetooth/smp.c                                |   13 -
 net/bridge/br_stp_bpdu.c                           |    2 -
 net/core/datagram.c                                |    2 +-
 net/core/pktgen.c                                  |    9 +-
 net/core/request_sock.c                            |    2 +
 net/core/scm.c                                     |    5 +-
 net/core/skbuff.c                                  |   46 +-
 net/ipv4/ah4.c                                     |   18 +-
 net/ipv4/arp.c                                     |   21 +-
 net/ipv4/datagram.c                                |   25 -
 net/ipv4/esp4.c                                    |   12 +-
 net/ipv4/ip_gre.c                                  |    6 +-
 net/ipv4/ipcomp.c                                  |    7 +-
 net/ipv4/ping.c                                    |    1 -
 net/ipv4/raw.c                                     |    1 -
 net/ipv4/route.c                                   |   54 +-
 net/ipv4/tcp_cong.c                                |   14 +-
 net/ipv4/tcp_input.c                               |    8 +-
 net/ipv4/tcp_ipv4.c                                |   15 +-
 net/ipv4/udp.c                                     |    1 -
 net/ipv6/addrconf.c                                |    1 -
 net/ipv6/ah6.c                                     |   11 +-
 net/ipv6/datagram.c                                |   16 +-
 net/ipv6/esp6.c                                    |    5 +-
 net/ipv6/icmp.c                                    |   12 -
 net/ipv6/ip6_flowlabel.c                           |    4 +-
 net/ipv6/ip6_gre.c                                 |    2 +-
 net/ipv6/ip6_output.c                              |    4 +-
 net/ipv6/ip6mr.c                                   |    3 -
 net/ipv6/ipv6_sockglue.c                           |    6 +-
 net/ipv6/netfilter/ip6t_NPT.c                      |   18 +-
 net/ipv6/raw.c                                     |    6 +-
 net/ipv6/route.c                                   |    2 +-
 net/ipv6/tcp_ipv6.c                                |    6 +-
 net/ipv6/udp.c                                     |    6 +-
 net/l2tp/l2tp_core.c                               |   82 +-
 net/l2tp/l2tp_core.h                               |    5 +-
 net/l2tp/l2tp_ip6.c                                |   10 +-
 net/l2tp/l2tp_ppp.c                                |    6 +
 net/mac80211/cfg.c                                 |   15 +-
 net/mac80211/ieee80211_i.h                         |    6 +-
 net/mac80211/mesh_hwmp.c                           |    5 +-
 net/mac80211/mlme.c                                |   11 +-
 net/mac80211/offchannel.c                          |   19 +-
 net/mac80211/scan.c                                |   15 +-
 net/mac80211/tx.c                                  |    9 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   35 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |    2 -
 net/netfilter/nf_conntrack_core.c                  |    9 +-
 net/netfilter/nf_conntrack_standalone.c            |    1 -
 net/netfilter/x_tables.c                           |   28 +-
 net/netfilter/xt_CT.c                              |    4 +-
 net/openvswitch/vport-netdev.c                     |   16 +-
 net/packet/af_packet.c                             |   10 +-
 net/rfkill/input.c                                 |    8 +-
 net/sched/sch_htb.c                                |    4 +-
 net/sched/sch_netem.c                              |   12 +-
 net/sctp/Kconfig                                   |    4 +-
 net/sctp/auth.c                                    |    2 +-
 net/sctp/endpointola.c                             |    5 -
 net/sctp/ipv6.c                                    |    5 +-
 net/sctp/outqueue.c                                |   12 +-
 net/sctp/sm_statefuns.c                            |    4 +-
 net/sctp/socket.c                                  |    2 +-
 net/sctp/sysctl.c                                  |    4 -
 net/sunrpc/sched.c                                 |   18 +-
 net/sunrpc/svcsock.c                               |    2 +-
 net/wireless/scan.c                                |    2 +-
 net/xfrm/xfrm_policy.c                             |    2 +-
 net/xfrm/xfrm_replay.c                             |    4 +-
 samples/seccomp/Makefile                           |    2 -
 scripts/checkpatch.pl                              |   10 +-
 security/capability.c                              |   24 +-
 security/security.c                                |   28 +-
 security/selinux/hooks.c                           |   50 +-
 security/selinux/include/classmap.h                |    2 +-
 security/selinux/include/objsec.h                  |    4 -
 sound/pci/hda/hda_codec.c                          |    5 +-
 sound/pci/hda/hda_intel.c                          |   49 +-
 sound/pci/hda/patch_conexant.c                     |    9 -
 sound/pci/hda/patch_realtek.c                      |    4 -
 sound/soc/codecs/arizona.c                         |    5 +-
 sound/soc/codecs/wm2200.c                          |    3 +
 sound/soc/codecs/wm5102.c                          |    3 +-
 sound/soc/codecs/wm5110.c                          |    3 +-
 sound/soc/codecs/wm_adsp.c                         |    6 +-
 sound/soc/fsl/imx-pcm-dma.c                        |   21 +-
 sound/soc/fsl/imx-pcm-fiq.c                        |   22 +-
 sound/soc/fsl/imx-pcm.c                            |   32 -
 sound/soc/fsl/imx-pcm.h                            |   18 -
 sound/soc/soc-dapm.c                               |   12 +-
 sound/usb/mixer.c                                  |   17 +-
 tools/perf/Makefile                                |    2 +-
 tools/vm/.gitignore                                |    2 -
 648 files changed, 4685 insertions(+), 6771 deletions(-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Feb_2013_11_11_25_+1100_sXZd2YdQ4ILCH/=X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJBStAAoJEECxmPOUX5FEcygP/ikI97X+uPhtrALpNR3Gljbz
w8bGT4dJ9P9VElqfGA3WDptGUOSmbMz6BlHAXJgiSZXHA2o7Mhy+AcZwrSoLa14R
3txmqM7oEzq66Q4GQ6HLsy9PZFQpSscB5RvGvnP4z7Smerm9IPBVQlzsjsokVgvt
Pxiwj4F/mWD8Y/meBNKCmP3fsCcNKS+0qp+laz43kLihlv+x9oe1pWRo86xLklao
PR8PAEJdNVGI2fTY6B4vR6Jqhh+rOVWLWNNH25IVz8z9Y3cgDZyXFETMrq6ivbsQ
W2BFFZxBMtzdqnZnfHRERmlvLnQbcLCuYrTRALbcGvRrWk25Kbw0e2/aqUthvIrG
Xbn8RGC/c02otU5OY7ATsR/wTG+9YdC045A13PKeqKSZxMJdekAeqp7QIJCywOEx
2E89nCXUWj+J5G6PBrMcOV5UhtYSpsHn1mwUiLGXXFCxvCLcje3yqc8nutOO/SLB
0lFLd67DXycQmlukdFBjJb7+KgiwMSneUpfH5JNqdVKWEOzq8sDGXswQMlzuL/DU
FxuJsqqPu+/0mphyq8Zhrdgj53gYKeSHDKSZQnmZROcfEmF6JKFdP2vNr0dBOExy
rCxBBTn752HQlDxmYVl5rGjflYuBWrmnb5Uxc5+SUG56yfq2CPvFelB/oEpxQejP
7lYNC/8k6viYny6aOmRQ
=tOeH
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_11_11_25_+1100_sXZd2YdQ4ILCH/=X--
