Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3JTVaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:30:11 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:33878 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3JTVaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:30:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.12-rc6
Date: Sun, 20 Oct 2013 23:30:03 +0200
Message-Id: <1382304603-26395-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.12-rc6[1] compared to v3.11[2].

Summarized:
  - build errors: +28/-10
  - build warnings: +307/-94

JFYI, when comparing v3.12-rc6 to v3.12-rc5[3], the summaries are:
  - build errors: +9/-13
  - build warnings: +168/-48

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.12-rc6.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/6796/ (all 120 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/6601/ (all 120 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/6776/ (all 120 configs)


*** ERRORS ***

28 regressions:
  + /scratch/kisskb/src/drivers/i2c/busses/i2c-pca-platform.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]cc1: some warnings being treated as errors:  => 46:2
  + /scratch/kisskb/src/drivers/media/platform/soc_camera/rcar_vin.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 351:2
  + /scratch/kisskb/src/drivers/media/platform/soc_camera/rcar_vin.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 283:3
  + /scratch/kisskb/src/drivers/media/platform/vsp1/vsp1.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 66:2
  + /scratch/kisskb/src/drivers/media/platform/vsp1/vsp1.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 71:2
  + /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]:  => 263:2
  + /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: error: implicit declaration of function 'ioread8_rep' [-Werror=implicit-function-declaration]:  => 231:2
  + /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]:  => 247:2
  + /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: error: implicit declaration of function 'iowrite8_rep' [-Werror=implicit-function-declaration]:  => 216:2
  + /scratch/kisskb/src/drivers/spi/spi-sh-hspi.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 68:2
  + /scratch/kisskb/src/drivers/spi/spi-sh-hspi.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 63:2
  + /scratch/kisskb/src/drivers/spi/spi-sh.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 112:3
  + /scratch/kisskb/src/drivers/spi/spi-sh.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 110:3
  + /scratch/kisskb/src/drivers/spi/spi-sh.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 104:3
  + /scratch/kisskb/src/drivers/spi/spi-sh.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 102:3
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/das6402.c: error: implicit declaration of function 'outw_p' [-Werror=implicit-function-declaration]:  => 164:3
  + /scratch/kisskb/src/drivers/usb/host/fotg210-hcd.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 5859:2
  + /scratch/kisskb/src/drivers/usb/host/fotg210-hcd.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 5856:2
  + /scratch/kisskb/src/include/linux/omap-dma.h: error: expected identifier before numeric constant:  => 171:8
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: error: 'NO_IRQ' undeclared (first use in this function):  => 939:26
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.__kmalloc' defined in .text section in mm/built-in.o:  => (.text+0x1ffb078), (.text+0x1ffb008)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_24' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa5d0)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffb1a0)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffaf70)
  + error: slip.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.consume_skb' defined in .text section in net/built-in.o:  => (.text+0x1ff8fe4), (.text+0x1ff90e8), (.text+0x1ff8f98)
  + error: slip.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.dev_close' defined in .text section in net/built-in.o:  => (.text+0x1ff9a9c)
  + error: sungem_phy.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffb288)

10 improvements:
  - /scratch/kisskb/src/arch/xtensa/kernel/xtensa_ksyms.c: error: '_mcount' undeclared here (not in a function): 129:1 => 
  - /scratch/kisskb/src/sound/soc/codecs/wm0010.c: error: implicit declaration of function 'irq_set_irq_wake' [-Werror=implicit-function-declaration]: 976:2 => 
  - error: No rule to make target arch/cris/arch-v10/drivers/ds1302.o: N/A => 
  - error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.__init_waitqueue_head' defined in .text section in kernel/built-in.o: (.text+0x1ffaf4c) => 
  - error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_unlock' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ffa718), (.text+0x1ffa6bc) => 
  - error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.kfree' defined in .text section in mm/built-in.o: (.text+0x1ffb734) => 
  - error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.net_ratelimit' defined in .text section in net/built-in.o: (.text+0x1ff995c) => 
  - error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_21' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffb784) => 
  - error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_23' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa7c4) => 
  - error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9fa4), (.text+0x1ffb78c), (.text+0x1ffa1bc) => 


*** WARNINGS ***

307 regressions:
  + /scratch/kisskb/src/arch/mips/include/asm/compat.h: warning: 'rtdev' may be used uninitialized in this function [-Wuninitialized]:  => 208:24
  + /scratch/kisskb/src/arch/s390/kernel/crash_dump.c: warning: unused variable 'rc' [-Wunused-variable]:  => 48:6
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence/scratch/kisskb/src/arch/sh/math-emu/math.c: In function 'fadd'::  => 378
  + /scratch/kisskb/src/arch/x86/kernel/cpu/perf_event_amd_ibs.c: warning: 'config' may be used uninitialized in this function [-Wuninitialized]:  => 267:11
  + /scratch/kisskb/src/arch/x86/kernel/dumpstack_64.c: warning: 'id' may be used uninitialized in this function [-Wuninitialized]:  => 153:4
  + /scratch/kisskb/src/arch/x86/kernel/vsyscall_64.c: warning: 'syscall_nr' may be used uninitialized in this function [-Wuninitialized]:  => 261:16
  + /scratch/kisskb/src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 65:2
  + /scratch/kisskb/src/block/bsg.c: warning: 'rw' may be used uninitialized in this function [-Wuninitialized]:  => 280:2
  + /scratch/kisskb/src/drivers/acpi/acpica/exprep.c: warning: 'byte_alignment' may be used uninitialized in this function [-Wuninitialized]:  => 380:44
  + /scratch/kisskb/src/drivers/ata/libata-core.c: warning: 'native_sectors' may be used uninitialized in this function [-Wuninitialized]:  => 1358:3
  + /scratch/kisskb/src/drivers/ata/libata-scsi.c: warning: 'dev' may be used uninitialized in this function [-Wuninitialized]:  => 3707:3
  + /scratch/kisskb/src/drivers/ata/libata-scsi.c: warning: 'last_failed_dev' may be used uninitialized in this function [-Wuninitialized]:  => 3707:3
  + /scratch/kisskb/src/drivers/atm/ambassador.c: warning: 'fw' may be used uninitialized in this function [-Wuninitialized]:  => 1975:19
  + /scratch/kisskb/src/drivers/atm/he.c: warning: 'he_vcc' may be used uninitialized in this function [-Wuninitialized]:  => 1749:16
  + /scratch/kisskb/src/drivers/base/memory.c: warning: 'section_nr' may be used uninitialized in this function [-Wuninitialized]:  => 607:25
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 1936:2, 1617:6
  + /scratch/kisskb/src/drivers/block/DAC960.c: warning: 'ControllerNumber' may be used uninitialized in this function [-Wuninitialized]:  => 6649:2
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[0]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[10]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[11]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[12]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[13]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[14]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[15]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[1]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[2]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[3]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[4]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[5]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[6]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[7]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[8]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/cciss.c: warning: 'sn[9]' may be used uninitialized in this function [-Wuninitialized]:  => 681:18
  + /scratch/kisskb/src/drivers/block/mtip32xx/mtip32xx.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2894:1, 2917:1
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_resume' defined but not used [-Wunused-function]:  => 2242:12
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_suspend' defined but not used [-Wunused-function]:  => 2233:12
  + /scratch/kisskb/src/drivers/block/rbd.c: warning: 'image_id' may be used uninitialized in this function [-Wuninitialized]:  => 4750:27
  + /scratch/kisskb/src/drivers/char/hpet.c: warning: 'gsi' may be used uninitialized in this function [-Wuninitialized]:  => 257:19
  + /scratch/kisskb/src/drivers/char/hw_random/via-rng.c: warning: 'via_rng_cpu_id' defined but not used [-Wunused-variable]:  => 224:26
  + /scratch/kisskb/src/drivers/dma/ioat/dma_v2.c: warning: unused variable 'chanerr' [-Wunused-variable]:  => 572:7
  + /scratch/kisskb/src/drivers/firewire/core-device.c: warning: 'changed' may be used uninitialized in this function [-Wuninitialized]:  => 1151:2
  + /scratch/kisskb/src/drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]:  => 244:17
  + /scratch/kisskb/src/drivers/gpio/gpio-langwell.c: warning: 'lnw_gpio_runtime_idle' defined but not used [-Wunused-function]:  => 301:12
  + /scratch/kisskb/src/drivers/gpio/gpiolib-acpi.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 193:7
  + /scratch/kisskb/src/drivers/gpu/drm/gma500/psb_irq.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 47:1, 83:1, 59:1
  + /scratch/kisskb/src/drivers/gpu/drm/i2c/tda998x_drv.c: warning: 'reg_write_range' uses dynamic stack allocation [enabled by default]:  => 420:1
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/cik.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1689:11
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 799:11
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 790:6
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 754:5
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 773:10
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 777:5
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/rv770_smc.c: warning: 'int_vect' may be used uninitialized in this function [-Wuninitialized]:  => 384:70
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/rv770_smc.c: warning: 'ucode_size' may be used uninitialized in this function [-Wuninitialized]:  => 589:31
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/si.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1676:10
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/si.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1654:10
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/si.c: warning: 'smc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1684:12
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/si_smc.c: warning: 'ucode_size' may be used uninitialized in this function [-Wuninitialized]:  => 261:14
  + /scratch/kisskb/src/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 411:15
  + /scratch/kisskb/src/drivers/gpu/vga/vgaarb.c: warning: 'devfn' may be used uninitialized in this function [-Wuninitialized]:  => 1082:9
  + /scratch/kisskb/src/drivers/hid/hid-picolcd_debugfs.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 312:10
  + /scratch/kisskb/src/drivers/iio/imu/adis16480.c: warning: 'freq' may be used uninitialized in this function [-Wuninitialized]:  => 301:16
  + /scratch/kisskb/src/drivers/infiniband/hw/amso1100/c2_alloc.c: warning: 'mqsp' may be used uninitialized in this function [-Wuninitialized]:  => 112:30
  + /scratch/kisskb/src/drivers/infiniband/ulp/srp/ib_srp.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 888:2
  + /scratch/kisskb/src/drivers/input/keyboard/stmpe-keypad.c: warning: 'stmpe_keypad_irq' uses dynamic stack allocation [enabled by default]:  => 167:1
  + /scratch/kisskb/src/drivers/input/touchscreen/cyttsp4_core.c: warning: 'cyttsp4_get_mt_touches' uses dynamic stack allocation [enabled by default]:  => 936:1
  + /scratch/kisskb/src/drivers/leds/leds-max8997.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 92:27
  + /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'shift' may be used uninitialized in this function [-Wuninitialized]: 198:22, 121:57 => 198:22, 121:41, 197:47, 121:57
  + /scratch/kisskb/src/drivers/leds/leds-ot200.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 112:8 => 112:8, 114:7
  + /scratch/kisskb/src/drivers/media/common/b2c2/flexcop-fe-tuner.c: warning: 'flexcop_set_voltage' defined but not used [-Wunused-function]:  => 31:12
  + /scratch/kisskb/src/drivers/media/common/b2c2/flexcop-fe-tuner.c: warning: 'flexcop_sleep' defined but not used [-Wunused-function]:  => 59:12
  + /scratch/kisskb/src/drivers/media/dvb-frontends/cx24123.h: warning: 'cx24123_get_tuner_i2c_adapter' defined but not used [-Wunused-function]:  => 54:2
  + /scratch/kisskb/src/drivers/media/i2c/vs6624.c: warning: 'vs6624_read' defined but not used [-Wunused-function]:  => 506:12
  + /scratch/kisskb/src/drivers/media/rc/rc-main.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]:  => 932:9
  + /scratch/kisskb/src/drivers/media/tuners/e4000.c: warning: 'e4000_rd_regs' uses dynamic stack allocation [enabled by default]:  => 83:1
  + /scratch/kisskb/src/drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]:  => 1106:1
  + /scratch/kisskb/src/drivers/media/v4l2-core/videobuf2-core.c: warning: 'buffer' may be used uninitialized in this function [-Wuninitialized]:  => 1922:5
  + /scratch/kisskb/src/drivers/media/v4l2-core/videobuf2-core.c: warning: 'plane' may be used uninitialized in this function [-Wuninitialized]:  => 1936:8
  + /scratch/kisskb/src/drivers/memstick/core/ms_block.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1912:10
  + /scratch/kisskb/src/drivers/memstick/core/ms_block.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 654:1, 720:1, 465:1, 677:1
  + /scratch/kisskb/src/drivers/memstick/core/ms_block.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 1912:10
  + /scratch/kisskb/src/drivers/memstick/core/ms_block.c: warning: right shift count >= width of type [enabled by default]:  => 1912:3, 1912:10
  + /scratch/kisskb/src/drivers/mfd/88pm860x-i2c.c: warning: 'write_device' uses dynamic stack allocation [enabled by default]:  => 140:1
  + /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_bulk_write' uses dynamic stack allocation [enabled by default]:  => 108:1
  + /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_reg_write' uses dynamic stack allocation [enabled by default]:  => 80:1
  + /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_set_bits' uses dynamic stack allocation [enabled by default]:  => 128:1
  + /scratch/kisskb/src/drivers/mfd/rtsx_pcr.c: warning: 'rtsx_pci_power_off' defined but not used [-Wunused-function]:  => 929:13
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 272:5 => 308:2, 308:5
  + /scratch/kisskb/src/drivers/mfd/stmpe.c: warning: 'stmpe_irq' uses dynamic stack allocation [enabled by default]:  => 890:1
  + /scratch/kisskb/src/drivers/mfd/stmpe.c: warning: 'stmpe_set_altfunc' uses dynamic stack allocation [enabled by default]:  => 286:1
  + /scratch/kisskb/src/drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]:  => 344:17
  + /scratch/kisskb/src/drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in this function [-Wuninitialized]: 384:2 => 384:2, 384:16
  + /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'arg' may be used uninitialized in this function [-Wuninitialized]:  => 986:6
  + /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'from' may be used uninitialized in this function [-Wuninitialized]:  => 986:6
  + /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'nr' may be used uninitialized in this function [-Wuninitialized]:  => 986:6
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1884:7, 1510:9, 745:2, 1449:7 => 1884:7, 1510:9, 745:2, 1449:7, 1489:2
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 1257:10, 474:31, 1111:10, 827:10
  + /scratch/kisskb/src/drivers/mtd/devices/phram.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 262:8
  + /scratch/kisskb/src/drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 53:2
  + /scratch/kisskb/src/drivers/mtd/nand/nandsim.c: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'long unsigned int' [-Wformat]:  => 774:2
  + /scratch/kisskb/src/drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 407:9
  + /scratch/kisskb/src/drivers/net/ethernet/atheros/atlx/atl1.c: warning: 'control' may be used uninitialized in this function [-Wuninitialized]:  => 496:26
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2.c: warning: 'bnx2_resume' defined but not used [-Wunused-function]:  => 8605:1
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2.c: warning: 'bnx2_suspend' defined but not used [-Wunused-function]:  => 8585:1
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1421:6, 1380:2
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb4/sge.c: warning: 'buf_size' may be used uninitialized in this function [-Wuninitialized]:  => 454:2
  + /scratch/kisskb/src/drivers/net/ethernet/ibm/ehea/ehea_main.c: warning: 'ehea_module_device_table' defined but not used [-Wunused-variable]:  => 105:28
  + /scratch/kisskb/src/drivers/net/ethernet/intel/i40e/i40e.h: warning: "prefetch" redefined [enabled by default]:  => 96:0
  + /scratch/kisskb/src/drivers/net/ethernet/intel/i40e/i40e_nvm.c: warning: 'checksum_local' may be used uninitialized in this function [-Wuninitialized]:  => 384:13
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx4/mcg.c: warning: 'hash' may be used uninitialized in this function [-Wuninitialized]:  => 609:9
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/farch.c: warning: 'data3' may be used uninitialized in this function [-Wuninitialized]:  => 2261:2
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_print_fwver' uses dynamic stack allocation [enabled by default]:  => 960:1
  + /scratch/kisskb/src/drivers/net/sb1000.c: warning: 'frequency' may be used uninitialized in this function [-Wuninitialized]:  => 1034:3
  + /scratch/kisskb/src/drivers/net/usb/sr9700.h: warning: "RSR" redefined [enabled by default]:  => 65:0
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'en_term' may be used uninitialized in this function [-Wuninitialized]:  => 624:27
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'f_reg' may be used uninitialized in this function [-Wuninitialized]:  => 1280:2
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'force_20pct' may be used uninitialized in this function [-Wuninitialized]:  => 617:27
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'ss_reg' may be used uninitialized in this function [-Wuninitialized]:  => 1280:2
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'chg_end_current' may be used uninitialized in this function [-Wuninitialized]:  => 266:4
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'level_lower' may be used uninitialized in this function [-Wuninitialized]:  => 325:6
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'level_upper' may be used uninitialized in this function [-Wuninitialized]:  => 324:22
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'vbat_lower' may be used uninitialized in this function [-Wuninitialized]:  => 325:37
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'vbat_upper' may be used uninitialized in this function [-Wuninitialized]:  => 324:59
  + /scratch/kisskb/src/drivers/regulator/da9063-regulator.c: warning: 'da9063_reg_matches' may be used uninitialized in this function [-Wuninitialized]:  => 847:6
  + /scratch/kisskb/src/drivers/regulator/s2mps11.c: warning: 'ramp_shift' may be used uninitialized in this function [-Wuninitialized]:  => 210:27
  + /scratch/kisskb/src/drivers/regulator/s5m8767.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 211:29
  + /scratch/kisskb/src/drivers/rtc/rtc-rx8025.c: warning: 'adj' may be used uninitialized in this function [-Wuninitialized]:  => 506:16
  + /scratch/kisskb/src/drivers/rtc/rtc-sh.c: warning: 'sh_rtc_set_irq_wake' defined but not used [-Wunused-function]  LD      drivers/sh/intc/built-in.o:  => 748:13
  + /scratch/kisskb/src/drivers/scsi/aacraid/comminit.c: warning: 'headers' may be used uninitialized in this function [-Wuninitialized]:  => 271:33
  + /scratch/kisskb/src/drivers/scsi/advansys.c: warning: 'adv_scsiqp' may be used uninitialized in this function [-Wuninitialized]:  => 8826:2
  + /scratch/kisskb/src/drivers/scsi/advansys.c: warning: 'next_qp' may be used uninitialized in this function [-Wuninitialized]:  => 8544:3
  + /scratch/kisskb/src/drivers/scsi/aic94xx/aic94xx_sds.c: warning: 'offs' may be used uninitialized in this function [-Wuninitialized]: 597:21 => 597:21, 273:25
  + /scratch/kisskb/src/drivers/scsi/fcoe/fcoe.c: warning: 'ctlr' may be used uninitialized in this function [-Wuninitialized]:  => 2043:15
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_els.c: warning: 'cmd' may be used uninitialized in this function [-Wuninitialized]:  => 4901:11
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_els.c: warning: 'ha_copy' may be used uninitialized in this function [-Wuninitialized]:  => 96:2
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_els.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]:  => 4900:13
  + /scratch/kisskb/src/drivers/scsi/osst.c: warning: 'STp' may be used uninitialized in this function [-Wuninitialized]:  => 4612:2
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 1335:13, 1460:19
  + /scratch/kisskb/src/drivers/spi/spi-omap-100k.c: warning: "READ" redefined [enabled by default]:  => 74:0
  + /scratch/kisskb/src/drivers/spi/spi-omap-100k.c: warning: "WRITE" redefined [enabled by default]:  => 73:0
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/aio_aio12_8.c: warning: statement with no effect [-Wunused-value]:  => 122:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/cb_pcidas.c: warning: 'nvram_data' may be used uninitialized in this function [-Wuninitialized]:  => 584:10
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/das08.c: warning: statement with no effect [-Wunused-value]:  => 217:2, 348:3, 353:3, 218:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/das16m1.c: warning: statement with no effect [-Wunused-value]:  => 453:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: 'hb' is used uninitialized in this function [-Wuninitialized]:  => 273:14
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: 'lb' is used uninitialized in this function [-Wuninitialized]:  => 273:20
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: statement with no effect [-Wunused-value]:  => 367:2, 366:2, 368:2, 369:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2814.c: warning: statement with no effect [-Wunused-value]:  => 230:3, 229:3
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/fl512.c: warning: statement with no effect [-Wunused-value]:  => 86:3
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_at_ao.c: warning: statement with no effect [-Wunused-value]:  => 183:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio.c: warning: 'ni_660x_clock' may be used uninitialized in this function [-Wuninitialized]:  => 248:17
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio.c: warning: 'ni_660x_gate_select' may be used uninitialized in this function [-Wuninitialized]:  => 253:22
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio.c: warning: 'ni_m_series_clock' may be used uninitialized in this function [-Wuninitialized]:  => 248:17
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio.c: warning: 'ni_m_series_gate_select' may be used uninitialized in this function [-Wuninitialized]:  => 253:22
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio_internal.h: warning: 'ni_660x_second_gate_select' may be used uninitialized in this function [-Wuninitialized]:  => 547:29
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/pcmda12.c: warning: statement with no effect [-Wunused-value]:  => 128:2, 89:4, 110:3
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/rti800.c: warning: statement with no effect [-Wunused-value]:  => 179:2, 298:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/s526.c: warning: statement with no effect [-Wunused-value]:  => 363:2
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_conf.h: warning: "IO_FIELD" redefined [enabled by default]:  => 165:0
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 982:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 982:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 982:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 982:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 112:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 112:1, 173:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 112:1, 173:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 112:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'tcflag_t' [-Wformat]:  => 494:2, 519:2, 569:2, 544:2
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 292:4, 258:4, 275:4, 241:4
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 576:2
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 664:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 664:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 664:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1068 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 664:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 664:1
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'tcflag_t' [-Wformat]:  => 557:2, 532:2, 607:2, 582:2
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 309:4, 292:4, 275:4, 326:4
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 525:2
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 613:1
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 613:1
  + /scratch/kisskb/src/drivers/staging/gdm724x/gdm_lte.c: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]:  => 202:3
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/llite/file.c: warning: 'count' may be used uninitialized in this function [-Wuninitialized]:  => 987:9, 1046:9
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/llite/lproc_llite.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 1066:6, 1296:6, 1130:6
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type '__kernel_suseconds_t' [-Wformat]:  => 1072:5
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/osc/lproc_osc.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 574:6, 686:6
  + /scratch/kisskb/src/drivers/staging/xillybus/xillybus_core.c: warning: 'idt_handle.entries' may be used uninitialized in this function [-Wuninitialized]:  => 2250:5
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 824:2
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: '__ffs_ep0_read_events' uses dynamic stack allocation [enabled by default]:  => 579:1
  + /scratch/kisskb/src/drivers/usb/host/xhci-plat.c: warning: 'xhci_plat_resume' defined but not used [-Wunused-function]:  => 209:12
  + /scratch/kisskb/src/drivers/usb/host/xhci-plat.c: warning: 'xhci_plat_suspend' defined but not used [-Wunused-function]:  => 201:12
  + /scratch/kisskb/src/drivers/video/aty/aty128fb.c: warning: 'backlight' defined but not used [-Wunused-variable]:  => 363:12
  + /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 624:11, 568:10 => 598:32, 624:11, 568:10, 443:16
  + /scratch/kisskb/src/drivers/video/matrox/matroxfb_maven.c: warning: 'c' may be used uninitialized in this function [-Wuninitialized]:  => 743:19
  + /scratch/kisskb/src/drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_resume' defined but not used [-Wunused-function]:  => 596:12
  + /scratch/kisskb/src/drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_suspend' defined but not used [-Wunused-function]:  => 572:12
  + /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]:  => 64:2
  + /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]:  => 65:2
  + /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]:  => 4131:13
  + /scratch/kisskb/src/drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + /scratch/kisskb/src/drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + /scratch/kisskb/src/drivers/vme/bridges/vme_ca91cx42.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 471:14
  + /scratch/kisskb/src/drivers/vme/bridges/vme_tsi148.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 744:14
  + /scratch/kisskb/src/fs/aio.c: warning: 'nr_segs' may be used uninitialized in this function [-Wuninitialized]:  => 1263:7
  + /scratch/kisskb/src/fs/aio.c: warning: 'nr_segs' may be used uninitialized in this function:  => 1208
  + /scratch/kisskb/src/fs/btrfs/backref.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 1450:3
  + /scratch/kisskb/src/fs/btrfs/ctree.c: warning: 'pslot' may be used uninitialized in this function [-Wuninitialized]:  => 1817:24, 2021:24
  + /scratch/kisskb/src/fs/btrfs/free-space-cache.c: warning: 'next_zero' may be used uninitialized in this function [-Wuninitialized]:  => 2389:5
  + /scratch/kisskb/src/fs/btrfs/free-space-cache.c: warning: 'start' may be used uninitialized in this function [-Wuninitialized]:  => 963:7
  + /scratch/kisskb/src/fs/btrfs/free-space-cache.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 718:3
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1310:23
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1356:6 => 1273:6, 1273:3
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]:  => 1306:38
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1311:18
  + /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]:  => 1384:2
  + /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]: 1282:20, 1474:6 => 1270:20, 1462:6, 1323:21
  + /scratch/kisskb/src/fs/btrfs/send.c: warning: 'eb' may be used uninitialized in this function [-Wuninitialized]:  => 2540:28
  + /scratch/kisskb/src/fs/btrfs/send.c: warning: 'slot' may be used uninitialized in this function [-Wuninitialized]:  => 2539:8
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'eb' may be used uninitialized in this function [-Wuninitialized]:  => 149:25
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'offset' may be used uninitialized in this function [-Wuninitialized]:  => 148:21
  + /scratch/kisskb/src/fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in this function [-Wuninitialized]:  => 645:12
  + /scratch/kisskb/src/fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function [-Wuninitialized]:  => 214:2
  + /scratch/kisskb/src/fs/isofs/namei.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]:  => 26:2
  + /scratch/kisskb/src/fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]:  => 1770:41
  + /scratch/kisskb/src/fs/nilfs2/btree.c: warning: 'bh' may be used uninitialized in this function [-Wuninitialized]:  => 1731:9
  + /scratch/kisskb/src/fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]:  => 909:21, 664:17
  + /scratch/kisskb/src/fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function [-Wuninitialized]: 214:32 => 214:32, 214:2
  + /scratch/kisskb/src/fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function [-Wuninitialized]: 214:17 => 214:2, 214:17
  + /scratch/kisskb/src/fs/reiserfs/prints.c: warning: 'noreturn' function does return [enabled by default]:  => 368:1
  + /scratch/kisskb/src/fs/udf/super.c: warning: 'map' may be used uninitialized in this function [-Wuninitialized]: 1259:9 => 1292:9, 1292:2
  + /scratch/kisskb/src/include/linux/err.h: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]:  => 39:17
  + /scratch/kisskb/src/include/linux/hid.h: warning: 'report' may be used uninitialized in this function [-Wuninitialized]:  => 967:27
  + /scratch/kisskb/src/include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 616:11
  + /scratch/kisskb/src/include/linux/list.h: warning: 'idev' may be used uninitialized in this function [-Wuninitialized]:  => 188:13
  + /scratch/kisskb/src/include/linux/list_nulls.h: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 35:2
  + /scratch/kisskb/src/include/linux/netfilter.h: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 180:6
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 333:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 333:2
  + /scratch/kisskb/src/kernel/kprobes.c: warning: 'probed_mod' may be used uninitialized in this function [-Wuninitialized]:  => 1526:2
  + /scratch/kisskb/src/kernel/rcutree.c: warning: unused variable 'idle' [-Wunused-variable]:  => 511:23, 374:23
  + /scratch/kisskb/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 708:2
  + /scratch/kisskb/src/kernel/trace/trace_sched_wakeup.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 127:12
  + /scratch/kisskb/src/kernel/trace/trace_sched_wakeup.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]:  => 124:16
  + /scratch/kisskb/src/lib/debugobjects.c: warning: 'obj_states' defined but not used [-Wunused-variable]:  => 73:20
  + /scratch/kisskb/src/lib/debugobjects.c: warning: unused variable 'hint' [-Wunused-variable]:  => 254:9
  + /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: 'delta' may be used uninitialized in this function [-Wuninitialized]:  => 174:20
  + /scratch/kisskb/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]:  => 658:14
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 735:15
  + /scratch/kisskb/src/mm/migrate.c: warning: statement with no effect [-Wunused-value]:  => 1172:4
  + /scratch/kisskb/src/mm/swapfile.c: warning: 'nr_extents' may be used uninitialized in this function [-Wuninitialized]:  => 2471:2
  + /scratch/kisskb/src/net/compat.c: warning: 'numsrc' may be used uninitialized in this function [-Wuninitialized]:  => 626:3
  + /scratch/kisskb/src/net/core/secure_seq.c: warning: 'net_secret_init' defined but not used [-Wunused-function]:  => 17:13
  + /scratch/kisskb/src/net/core/skbuff.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1341:6
  + /scratch/kisskb/src/net/ipv4/igmp.c: warning: 'ip_mc_rejoin_groups' defined but not used [-Wunused-function]:  => 1356:13
  + /scratch/kisskb/src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 218:2
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function [-Wuninitialized]:  => 183:16
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]:  => 656:16
  + /scratch/kisskb/src/net/ipv4/ip_output.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 299:2
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]: 449:63, 532:37 => 449:63, 544:42, 532:37
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'icmph' may be used uninitialized in this function [-Wuninitialized]: 493:29, 486:48, 486:35 => 493:29, 486:48, 486:35, 486:2
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]: 505:3, 450:29, 544:42, 489:2, 663:21 => 505:3, 663:2, 450:29, 544:42, 489:2, 663:21
  + /scratch/kisskb/src/net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function [-Wuninitialized]:  => 890:3
  + /scratch/kisskb/src/net/ipv4/xfrm4_output.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 94:2
  + /scratch/kisskb/src/net/ipv6/mcast.c: warning: 'max_delay' may be used uninitialized in this function [-Wuninitialized]:  => 1381:24
  + /scratch/kisskb/src/net/ipv6/ndisc.c: warning: label 'out' defined but not used [-Wunused-label]:  => 1730:1
  + /scratch/kisskb/src/net/netfilter/nf_conntrack_irc.c: warning: 'addr_beg_p' may be used uninitialized in this function [-Wuninitialized]:  => 214:19
  + /scratch/kisskb/src/net/netfilter/nf_conntrack_irc.c: warning: 'addr_end_p' may be used uninitialized in this function [-Wuninitialized]:  => 214:19
  + /scratch/kisskb/src/net/netfilter/nf_conntrack_irc.c: warning: 'dcc_ip' may be used uninitialized in this function [-Wuninitialized]:  => 188:4
  + /scratch/kisskb/src/net/netfilter/nf_conntrack_irc.c: warning: 'dcc_port' may be used uninitialized in this function [-Wuninitialized]:  => 204:11
  + /scratch/kisskb/src/net/netfilter/nfnetlink_queue_core.c: warning: 'packet_id_ptr' may be used uninitialized in this function [-Wuninitialized]:  => 547:17
  + /scratch/kisskb/src/net/nfc/llcp_core.c: warning: 'sn_len' may be used uninitialized in this function [-Wuninitialized]:  => 803:12
  + /scratch/kisskb/src/net/rds/iw_rdma.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /scratch/kisskb/src/net/rds/rdma.c: warning: 'iov_size' may be used uninitialized in this function [-Wuninitialized]:  => 697:15
  + /scratch/kisskb/src/net/sched/sch_atm.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 524:15
  + /scratch/kisskb/src/security/apparmor/crypto.c: warning: 'aa_calc_profile_hash' uses dynamic stack allocation [enabled by default]:  => 72:1
  + /scratch/kisskb/src/sound/core/oss/pcm_oss.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 2599:3
  + /scratch/kisskb/src/sound/drivers/mpu401/mpu401_uart.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 312:6, 290:6
  + /scratch/kisskb/src/sound/drivers/serial-u16550.c: warning: 'uart' may be used uninitialized in this function [-Wuninitialized]:  => 962:27
  + /scratch/kisskb/src/sound/soc/fsl/imx-audmux.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 70:13
  + /scratch/kisskb/src/sound/soc/fsl/imx-audmux.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 161:7
  + /scratch/kisskb/src/sound/soc/kirkwood/kirkwood-dma.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 164:3
  + kernel/time/Kconfig: warning: range is invalid:  => 162
  + warning: (HWPOISON_INJECT && MEM_SOFT_DIRTY) selects PROC_PAGE_MONITOR which has unmet direct dependencies (PROC_FS && MMU):  => N/A
  + warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
  + warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENT && PERF_EVENTS):  => N/A
  + warning: (VIDEO_PVRUSB2 && VIDEO_TLG2300 && VIDEO_USBVISION && VIDEO_CX231XX && VIDEO_TM6000 && VIDEO_EM28XX && VIDEO_IVTV && VIDEO_MXB && VIDEO_CX18 && VIDEO_CX23885 && VIDEO_CX88 && VIDEO_BT848 && VIDEO_SAA7134 && VIDEO_SAA7164 && VIDEO_GO7007) selects VIDEO_TUNER which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER):  => N/A
  + warning: drivers/built-in.o(.data+0x9e8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa88): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xbe4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xcec): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xd4c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdac): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe0c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xfb4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1378): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x403e8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x40488): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x405e4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x406ec): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4074c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x407ac): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4080c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x409b4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.text.unlikely+0x2ee): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x2f6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x356): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x362): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x3a6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A

94 improvements:
  - /scratch/kisskb/src/arch/avr32/kernel/process.c: warning: assignment makes integer from pointer without a cast: 292 => 
  - /scratch/kisskb/src/arch/sh/math-emu/math.c: warning: statement with no effect [-Wunused-value]  CC      ipc/msgutil.o: 122:1 => 
  - /scratch/kisskb/src/arch/tile/kernel/process.c: warning: unused variable 'tsk' [-Wunused-variable]: 572:22 => 
  - /scratch/kisskb/src/arch/x86/kvm/x86.c: warning: 'exchanged' may be used uninitialized in this function [-Wuninitialized]: 4338:5 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i915/i915_irq.c: warning: 'score' may be used uninitialized in this function [-Wuninitialized]: 2509:27 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-cpm.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]: 542:3, 551:3 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-designware-platdrv.c: warning: 'dw_i2c_resume' defined but not used [-Wunused-function]: 221:12 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-designware-platdrv.c: warning: 'dw_i2c_suspend' defined but not used [-Wunused-function]: 211:12 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-ocores.c: warning: 'ocores_i2c_resume' defined but not used [-Wunused-function]: 471:12 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-ocores.c: warning: 'ocores_i2c_suspend' defined but not used [-Wunused-function]: 460:12 => 
  - /scratch/kisskb/src/drivers/idle/i7300_idle.c: warning: 'got_ctl' may be used uninitialized in this function [-Wuninitialized]: 423:2 => 
  - /scratch/kisskb/src/drivers/iio/adc/ti_am335x_adc.c: warning: unused variable 'cur' [-Wunused-variable]: 209:17 => 
  - /scratch/kisskb/src/drivers/iio/adc/ti_am335x_adc.c: warning: unused variable 'prop' [-Wunused-variable]: 208:20 => 
  - /scratch/kisskb/src/drivers/input/keyboard/max7359_keypad.c: warning: 'max7359_resume' defined but not used [-Wunused-function]: 287:12 => 
  - /scratch/kisskb/src/drivers/input/keyboard/max7359_keypad.c: warning: 'max7359_suspend' defined but not used [-Wunused-function]: 275:12 => 
  - /scratch/kisskb/src/drivers/input/misc/pwm-beeper.c: warning: 'pwm_beeper_resume' defined but not used [-Wunused-function]: 157:12 => 
  - /scratch/kisskb/src/drivers/input/misc/pwm-beeper.c: warning: 'pwm_beeper_suspend' defined but not used [-Wunused-function]: 147:12 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/cyttsp4_core.c: warning: 'cyttsp4_core_sleep' defined but not used [-Wunused-function]: 1555:12 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/cyttsp4_core.c: warning: 'cyttsp4_core_wake' defined but not used [-Wunused-function]: 1633:12 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/eeti_ts.c: warning: 'eeti_ts_resume' defined but not used [-Wunused-function]: 287:12 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/eeti_ts.c: warning: 'eeti_ts_suspend' defined but not used [-Wunused-function]: 268:12 => 
  - /scratch/kisskb/src/drivers/isdn/hardware/mISDN/hfcpci.c: warning: ignoring return value of 'driver_for_each_device', declared with attribute warn_unused_result [-Wunused-result]: 2298:2 => 
  - /scratch/kisskb/src/drivers/md/bcache/btree.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' [-Wformat]: 259:8 => 
  - /scratch/kisskb/src/drivers/media/platform/soc_camera/soc_camera.c: warning: 'sasd' may be used uninitialized in this function [-Wuninitialized]: 1513:10, 1514:55 => 
  - /scratch/kisskb/src/drivers/media/tuners/e4000.c: warning: 'e4000_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 81:1 => 
  - /scratch/kisskb/src/drivers/mfd/ti_am335x_tscadc.c: warning: unused variable 'cur' [-Wunused-variable]: 95:27 => 
  - /scratch/kisskb/src/drivers/mfd/ti_am335x_tscadc.c: warning: unused variable 'prop' [-Wunused-variable]: 94:27 => 
  - /scratch/kisskb/src/drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 398:24, 415:9 => 
  - /scratch/kisskb/src/drivers/mmc/host/tmio_mmc_pio.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]: 798:19 => 
  - /scratch/kisskb/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC      drivers/scsi/device_handler/scsi_dh.o: 641:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/b43/xmit.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]  CC [M]  drivers/net/wireless/rt2x00/rt2x00crypto.o: 283:3 => 
  - /scratch/kisskb/src/drivers/pci/msi.c: warning: unused variable 'i' [-Wunused-variable]: 339:7 => 
  - /scratch/kisskb/src/drivers/power/twl4030_charger.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]: 192:20 => 
  - /scratch/kisskb/src/drivers/regulator/lp872x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 910:33 => 
  - /scratch/kisskb/src/drivers/scsi/pm8001/pm8001_init.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 424:4 => 
  - /scratch/kisskb/src/drivers/spi/spi-gpio.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 446:2 => 
  - /scratch/kisskb/src/drivers/spi/spi-pxa2xx.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 1152:3 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_labpc.c: warning: unused variable 'dma_chan' [-Wunused-variable]: 1697:15 => 
  - /scratch/kisskb/src/drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]: 2270:7 => 
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_early.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 196:12 => 
  - /scratch/kisskb/src/drivers/tty/serial/pch_uart.c: warning: 'wait_for_xmitr' defined but not used [-Wunused-function]: 1504:13 => 
  - /scratch/kisskb/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 809:11 => 
  - /scratch/kisskb/src/fs/afs/internal.h: warning: 'packed' attribute ignored for field of type 'enum <anonymous>' [-Wattributes]  CC      drivers/staging/ste_rmi4/synaptics_i2c_rmi4.o: 163:2 => 
  - /scratch/kisskb/src/fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]: 134:23 => 
  - /scratch/kisskb/src/fs/nfs/unlink.c: warning: 'nfs_sillyrename' uses dynamic stack allocation [enabled by default]: 563:1 => 
  - /scratch/kisskb/src/include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 424:3, 279:4, 349:2, 324:17, 278:6, 367:14, 290:22, 414:2, 332:11, 397:11 => 279:4, 349:2, 324:17, 278:6, 367:14, 290:22, 414:2, 332:11, 397:11
  - /scratch/kisskb/src/include/linux/of_net.h: warning: type qualifiers ignored on function return type: 16 => 
  - /scratch/kisskb/src/kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]: 112:1 => 
  - /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: the frame size of 1236 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 514:1 => 
  - /scratch/kisskb/src/net/9p/trans_rdma.c: warning: 'rdma_cancelled' defined but not used [-Wunused-function]: 594:12 => 
  - /scratch/kisskb/src/net/rds/iw_rdma.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 200:1 => 
  - /scratch/kisskb/src/net/rfkill/rfkill-regulator.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]: 43:20 => 
  - /scratch/kisskb/src/sound/isa/sb/sb16.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]  CC [M]  sound/usb/pcm.o: 527:6 => 
  - warning: (ARM_GIC && ARM_NVIC && ARM_VIC && ORION_IRQCHIP && RENESAS_INTC_IRQPIN && RENESAS_IRQC && TB10X_IRQC && VERSATILE_FPGA_IRQ && REGMAP && PINCTRL_BAYTRAIL && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && MFD_MAX8998 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS): N/A => 
  - warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER): N/A => 
  - warning: (DW_DMAC && DW_DMAC_PCI) selects DW_DMAC_CORE which has unmet direct dependencies (DMADEVICES && GENERIC_HARDIRQS): N/A => 
  - warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES): N/A => 
  - warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD): N/A => 
  - warning: arch/x86/built-in.o(.text.unlikely+0x435d): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed: N/A => 
  - warning: arch/x86/mm/built-in.o(.text.unlikely+0x1b84): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed: N/A => 
  - warning: drivers/built-in.o(.data+0x988): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xa28): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xb84): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xc8c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xcec): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xd4c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xdac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xf54): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/built-in.o(.text+0x32d02a): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/built-in.o(.text+0x32d03a): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/net/cris/built-in.o(.text+0x1366): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/video/built-in.o(.text+0x29b712): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/video/built-in.o(.text+0x29b722): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: mm/built-in.o(.meminit.text+0x1250): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o (.PPC.EMB.apuinfo): unexpected non-allocatable section.: N/A => 
  - warning: vmlinux.o(.data+0x3ff68): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40008): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40164): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x4026c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x402cc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4032c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4038c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40534): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: vmlinux.o(.meminit.text+0x1654): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.text+0x154def6): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: vmlinux.o(.text+0x154df06): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x372): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x37a): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x3da): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x3e6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x42a): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x43ca): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed: N/A => 
  - warning: vmlinux.o(.text.unlikely+0xc6): Section mismatch in reference from the function .prom_rtas_call() to the variable .init.data:dt_string_start: N/A => 
  - warning: vmlinux.o(.text.unlikely+0xce): Section mismatch in reference from the function .prom_rtas_call() to the variable .init.data:dt_string_start: N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
