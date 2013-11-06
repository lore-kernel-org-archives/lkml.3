Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3KFJ3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:29:09 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39549 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3KFJ3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:29:05 -0500
Date: Wed, 6 Nov 2013 10:29:00 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.12
Message-ID: <alpine.DEB.2.02.1311061028420.20227@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.12[1] compared to v3.11[2].

Summarized:
  - build errors: +31/-10
  - build warnings: +151/-98

JFYI, when comparing v3.12 to v3.12-rc7[3], the summaries are:
  - build errors: +11/-6
  - build warnings: +78/-165

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.12.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/6840/ (all 120 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/6601/ (all 120 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/6819/ (119 out of 120 configs)


*** ERRORS ***

31 regressions:
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_HIGH_MASK' undeclared (first use in this function):  => 98:12
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_HIGH_SHIFT' undeclared (first use in this function):  => 98:34, 145:10
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_LOW_MASK' undeclared (first use in this function):  => 97:21
  + /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_LOW_SHIFT' undeclared (first use in this function):  => 97:42, 145:10
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function):  => 99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]:  => 192:2
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
  + error: "flush_cache_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!:  => N/A
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.__kmalloc' defined in .text section in mm/built-in.o:  => (.text+0x1ffa1ac), (.text+0x1ffa13c)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.ip_fast_csum' defined in .text section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9648)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.memcmp' defined in .text section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff99fc), (.text+0x1ff9a40)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_24' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9704)
  + error: sungem_phy.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffb504), (.text+0x1ffae84)
  + error: sungem_phy.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffb39c), (.text+0x1ffad20)

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

151 regressions:
  + /scratch/kisskb/src/arch/mips/include/asm/compat.h: warning: 'rtdev' may be used uninitialized in this function [-Wuninitialized]:  => 208:24
  + /scratch/kisskb/src/arch/s390/kernel/crash_dump.c: warning: unused variable 'rc' [-Wunused-variable]:  => 48:6
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 210
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 378 => 375, 378
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 349, 351
  + /scratch/kisskb/src/arch/x86/kernel/vsyscall_64.c: warning: 'syscall_nr' may be used uninitialized in this function [-Wuninitialized]:  => 261:16
  + /scratch/kisskb/src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 65:2
  + /scratch/kisskb/src/drivers/base/memory.c: warning: 'section_nr' may be used uninitialized in this function [-Wuninitialized]:  => 607:25
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 1936:2, 1617:6
  + /scratch/kisskb/src/drivers/block/mtip32xx/mtip32xx.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2894:1, 2917:1
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_resume' defined but not used [-Wunused-function]:  => 2242:12
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_suspend' defined but not used [-Wunused-function]:  => 2233:12
  + /scratch/kisskb/src/drivers/char/hw_random/via-rng.c: warning: 'via_rng_cpu_id' defined but not used [-Wunused-variable]:  => 224:26
  + /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 474:4
  + /scratch/kisskb/src/drivers/gpu/drm/i2c/tda998x_drv.c: warning: 'reg_write_range' uses dynamic stack allocation [enabled by default]:  => 420:1
  + /scratch/kisskb/src/drivers/gpu/drm/udl/udl_modeset.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]:  => 28:9
  + /scratch/kisskb/src/drivers/i2c/busses/i2c-diolan-u2c.c: warning: 'byte' may be used uninitialized in this function [-Wuninitialized]:  => 394:18
  + /scratch/kisskb/src/drivers/input/keyboard/stmpe-keypad.c: warning: 'stmpe_keypad_irq' uses dynamic stack allocation [enabled by default]:  => 167:1
  + /scratch/kisskb/src/drivers/input/touchscreen/cyttsp4_core.c: warning: 'cyttsp4_get_mt_touches' uses dynamic stack allocation [enabled by default]:  => 936:1
  + /scratch/kisskb/src/drivers/md/bcache/alloc.c: warning: 'bucket' may be used uninitialized in this function [-Wuninitialized]:  => 408:5
  + /scratch/kisskb/src/drivers/media/tuners/e4000.c: warning: 'e4000_rd_regs' uses dynamic stack allocation [enabled by default]:  => 84:1
  + /scratch/kisskb/src/drivers/media/usb/gspca/cpia1.c: warning: unused variable 'sd' [-Wunused-variable]:  => 1627:13
  + /scratch/kisskb/src/drivers/media/usb/gspca/konica.c: warning: unused variable 'sd' [-Wunused-variable]:  => 246:13
  + /scratch/kisskb/src/drivers/media/usb/gspca/t613.c: warning: unused variable 'sd' [-Wunused-variable]:  => 840:13
  + /scratch/kisskb/src/drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]:  => 1106:1
  + /scratch/kisskb/src/drivers/media/usb/uvc/uvc_ctrl.c: warning: 'ctrl' may be used uninitialized in this function [-Wuninitialized]:  => 1972:6
  + /scratch/kisskb/src/drivers/memstick/core/ms_block.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 654:1, 720:1, 465:1, 677:1
  + /scratch/kisskb/src/drivers/mfd/88pm860x-i2c.c: warning: 'write_device' uses dynamic stack allocation [enabled by default]:  => 140:1
  + /scratch/kisskb/src/drivers/mfd/da903x.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 185:2, 229:2, 207:2
  + /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_bulk_write' uses dynamic stack allocation [enabled by default]:  => 108:1
  + /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_reg_write' uses dynamic stack allocation [enabled by default]:  => 80:1
  + /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_set_bits' uses dynamic stack allocation [enabled by default]:  => 128:1
  + /scratch/kisskb/src/drivers/mfd/rtsx_pcr.c: warning: 'rtsx_pci_power_off' defined but not used [-Wunused-function]:  => 929:13
  + /scratch/kisskb/src/drivers/mfd/stmpe.c: warning: 'stmpe_irq' uses dynamic stack allocation [enabled by default]:  => 890:1
  + /scratch/kisskb/src/drivers/mfd/stmpe.c: warning: 'stmpe_set_altfunc' uses dynamic stack allocation [enabled by default]:  => 286:1
  + /scratch/kisskb/src/drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]:  => 344:17, 344:3
  + /scratch/kisskb/src/drivers/mtd/nand/nandsim.c: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'long unsigned int' [-Wformat]:  => 774:2
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2.c: warning: 'bnx2_resume' defined but not used [-Wunused-function]:  => 8605:1
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2.c: warning: 'bnx2_suspend' defined but not used [-Wunused-function]:  => 8585:1
  + /scratch/kisskb/src/drivers/net/ethernet/ibm/ehea/ehea_main.c: warning: 'ehea_module_device_table' defined but not used [-Wunused-variable]:  => 105:28
  + /scratch/kisskb/src/drivers/net/ethernet/intel/i40e/i40e.h: warning: "prefetch" redefined [enabled by default]:  => 96:0
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_print_fwver' uses dynamic stack allocation [enabled by default]:  => 960:1
  + /scratch/kisskb/src/drivers/net/usb/sr9700.h: warning: "RSR" redefined [enabled by default]:  => 65:0
  + /scratch/kisskb/src/drivers/nubus/proc.c: warning: #warning Need to set some I/O handlers here [-Wcpp]  CC      drivers/ide/ide-probe.o:  => 64:2
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'f_reg' may be used uninitialized in this function [-Wuninitialized]:  => 1280:2
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'ss_reg' may be used uninitialized in this function [-Wuninitialized]:  => 1280:2
  + /scratch/kisskb/src/drivers/regulator/da9063-regulator.c: warning: 'da9063_reg_matches' may be used uninitialized in this function [-Wuninitialized]:  => 847:6
  + /scratch/kisskb/src/drivers/regulator/s5m8767.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 211:29
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 1335:13, 1460:19
  + /scratch/kisskb/src/drivers/spi/spi-omap-100k.c: warning: "READ" redefined [enabled by default]:  => 74:0
  + /scratch/kisskb/src/drivers/spi/spi-omap-100k.c: warning: "WRITE" redefined [enabled by default]:  => 73:0
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/aio_aio12_8.c: warning: statement with no effect [-Wunused-value]:  => 122:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/das08.c: warning: statement with no effect [-Wunused-value]:  => 217:2, 348:3, 353:3, 218:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/das16m1.c: warning: statement with no effect [-Wunused-value]:  => 453:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: 'hb' is used uninitialized in this function [-Wuninitialized]:  => 273:14
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: 'lb' is used uninitialized in this function [-Wuninitialized]:  => 273:20
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: statement with no effect [-Wunused-value]:  => 367:2, 366:2, 368:2, 369:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2814.c: warning: statement with no effect [-Wunused-value]:  => 230:3, 229:3
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/fl512.c: warning: statement with no effect [-Wunused-value]:  => 86:3
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_at_ao.c: warning: statement with no effect [-Wunused-value]:  => 183:2
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
  + /scratch/kisskb/src/drivers/staging/rts5139/sd_cprm.c: warning: 'rsp_len' may be used uninitialized in this function [-Wuninitialized]:  => 260:7
  + /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 615:18
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 269:6
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: '__ffs_ep0_read_events' uses dynamic stack allocation [enabled by default]:  => 579:1
  + /scratch/kisskb/src/drivers/usb/gadget/g_ffs.c: warning: data definition has no type or storage class [enabled by default]:  => 79:1
  + /scratch/kisskb/src/drivers/usb/gadget/g_ffs.c: warning: function declaration isn't a prototype [-Wstrict-prototypes]:  => 79:1
  + /scratch/kisskb/src/drivers/usb/gadget/g_ffs.c: warning: type defaults to 'int' in declaration of 'USB_ETHERNET_MODULE_PARAMETERS' [-Wimplicit-int]:  => 79:1
  + /scratch/kisskb/src/drivers/usb/host/xhci-plat.c: warning: 'xhci_plat_resume' defined but not used [-Wunused-function]:  => 209:12
  + /scratch/kisskb/src/drivers/usb/host/xhci-plat.c: warning: 'xhci_plat_suspend' defined but not used [-Wunused-function]:  => 201:12
  + /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 624:11, 568:10 => 598:32, 624:11, 568:10, 443:16
  + /scratch/kisskb/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 809:11 => 809:11, 563:16, 783:32
  + /scratch/kisskb/src/fs/aio.c: warning: 'nr_segs' may be used uninitialized in this function:  => 1208
  + /scratch/kisskb/src/fs/f2fs/recovery.c: warning: 'sum.<U3660>.<U3600>.ofs_in_node' may be used uninitialized in this function [-Wuninitialized]:  => 271:51
  + /scratch/kisskb/src/fs/f2fs/recovery.c: warning: 'sum.nid' may be used uninitialized in this function [-Wuninitialized]:  => 243:2
  + /scratch/kisskb/src/fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]:  => 1782:17
  + /scratch/kisskb/src/fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]:  => 909:21, 664:17
  + /scratch/kisskb/src/fs/omfs/file.c: warning: 'remain' may be used uninitialized in this function [-Wuninitialized]:  => 257:4
  + /scratch/kisskb/src/fs/reiserfs/prints.c: warning: 'noreturn' function does return [enabled by default]:  => 368:1
  + /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u16' makes pointer from integer without a cast [enabled by default]/scratch/kisskb/src/arch/s390/include/asm/pci_io.h:59:1: note: expected 'const volatile void *' but argument is of type 'long unsigned int':  => 183:4
  + /scratch/kisskb/src/include/linux/err.h: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]:  => 39:17
  + /scratch/kisskb/src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]:  => 2559:8
  + /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: the frame size of 1052 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 535:1
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]:  => 70:2, 73:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]:  => 45:2, 49:4, 56:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]:  => 113:2, 116:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]:  => 92:4, 99:2, 88:2
  + /scratch/kisskb/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]:  => 658:14
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 735:15
  + /scratch/kisskb/src/mm/migrate.c: warning: statement with no effect [-Wunused-value]:  => 1172:4
  + /scratch/kisskb/src/net/rds/iw_rdma.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /scratch/kisskb/src/security/apparmor/crypto.c: warning: 'aa_calc_profile_hash' uses dynamic stack allocation [enabled by default]:  => 72:1
  + /scratch/kisskb/src/sound/soc/fsl/imx-audmux.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 70:13
  + /scratch/kisskb/src/sound/soc/fsl/imx-audmux.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 161:7
  + /scratch/kisskb/src/sound/soc/kirkwood/kirkwood-dma.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 164:3
  + /scratch/kisskb/src/sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3330:6
  + /scratch/kisskb/src/sound/usb/mixer_quirks.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]  CC [M]  crypto/rmd128.o:  => 1514:6
  + kernel/time/Kconfig: warning: range is invalid:  => 162
  + warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
  + warning: drivers/built-in.o(.data+0x9e8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa88): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xbe4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xcec): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xd4c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdac): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe0c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xfb4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1378): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x40428): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x404c8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40624): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x4072c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4078c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x407ec): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4084c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x409f4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.text.unlikely+0x2ee): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x2f6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x356): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x362): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x3a6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A

98 improvements:
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
  - /scratch/kisskb/src/drivers/media/usb/cx231xx/cx231xx-cards.c: warning: statement with no effect [-Wunused-value]: 913:2, 1411:3, 1043:2 => 
  - /scratch/kisskb/src/drivers/mfd/ti_am335x_tscadc.c: warning: unused variable 'cur' [-Wunused-variable]: 95:27 => 
  - /scratch/kisskb/src/drivers/mfd/ti_am335x_tscadc.c: warning: unused variable 'prop' [-Wunused-variable]: 94:27 => 
  - /scratch/kisskb/src/drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 398:24, 415:9 => 
  - /scratch/kisskb/src/drivers/mmc/host/tmio_mmc_pio.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]: 798:19 => 
  - /scratch/kisskb/src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast [enabled by default]: 1670:2, 1642:2, 390:2, 1265:4, 1130:2, 349:2, 389:2, 1804:2, 1909:2, 1666:2, 723:2, 1639:2, 1287:4, 1072:2, 1293:2, 1672:2, 795:2, 759:2, 836:2, 270:2, 1452:2, 271:2, 937:2, 1022:3, 592:2, 296:2, 726:2, 689:3, 396:2, 488:3, 1278:4, 1173:2, 1652:2, 677:4, 1294:2, 469:4, 936:2, 758:2, 667:2, 313:2, 858:2, 328:2, 1646:2, 598:2, 1669:2, 380:2, 1825:2, 309:2, 1883:2, 350:2, 1641:2, 595:2, 1198:2, 357:2, 1896:2, 1455:3, 1934:2, 381:2, 1073:2, 1653:2, 329:2, 579:2, 278:2, 310:2, 1199:2, 619:2, 803:3, 345:2, 1681:2, 783:3, 849:2, 1644:2, 1456:3, 831:2, 755:2, 391:2, 1680:2, 1023:3, 311:2, 395:2, 1284:4, 1171:2, 1798:2, 580:2, 441:3, 1638:2, 1195:2, 1667:2, 801:3, 863:2, 1345:2, 1225:2, 1797:2, 1263:4, 819:2, 1453:2, 356:2, 325:2, 612:2, 1248:4, 491:3, 1458:2, 418:2, 781:3, 346:2, 253:2, 760:2, 1342:2, 254:2, 938:2, 347:2, 751:2, 1197:2 => 1670:2, 1642:2, 390:2, 1265:4, 1130:2, 349:2, 389:2, 1804:2, 1909:2, 1666:2, 723:2, 1639:2, 1287:4, 1072:2, 1293:2, 1672:2, 795:2, 759:2, 836:2, 270:2, 1452:2, 271:2, 937:2, 1022:3, 592:2, 296:2, 726:2, 689:3, 396:2, 488:3, 1278:4, 1173:2, 1652:2, 677:4, 1294:2, 469:4, 936:2, 758:2, 667:2, 313:2, 858:2, 328:2, 1646:2, 598:2, 1669:2, 380:2, 1825:2, 309:2, 1883:2, 350:2, 1641:2, 1198:2, 357:2, 1896:2, 1455:3, 1934:2, 381:2, 1073:2, 1653:2, 329:2, 579:2, 278:2, 310:2, 1199:2, 619:2, 803:3, 345:2, 1681:2, 783:3, 849:2, 1644:2, 1456:3, 831:2, 755:2, 391:2, 1680:2, 311:2, 1023:3, 395:2, 1284:4, 1171:2, 1798:2, 580:2, 441:3, 1638:2, 1195:2, 1667:2, 801:3, 863:2, 1345:2, 1225:2, 1797:2, 1263:4, 819:2, 1453:2, 356:2, 325:2, 612:2, 1248:4, 491:3, 1458:2, 418:2, 781:3, 346:2, 253:2, 760:2, 1342:2, 254:2, 938:2, 347:2, 751:2, 1197:2
  - /scratch/kisskb/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC      drivers/scsi/device_handler/scsi_dh.o: 641:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/b43/xmit.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]  CC [M]  drivers/net/wireless/rt2x00/rt2x00crypto.o: 283:3 => 
  - /scratch/kisskb/src/drivers/pci/msi.c: warning: unused variable 'i' [-Wunused-variable]: 339:7 => 
  - /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]: 693:12 => 
  - /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]: 724:13 => 
  - /scratch/kisskb/src/drivers/power/twl4030_charger.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]: 192:20 => 
  - /scratch/kisskb/src/drivers/regulator/lp872x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 910:33 => 
  - /scratch/kisskb/src/drivers/scsi/pm8001/pm8001_init.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 424:4 => 
  - /scratch/kisskb/src/drivers/spi/spi-gpio.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 446:2 => 
  - /scratch/kisskb/src/drivers/spi/spi-pxa2xx.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 1152:3 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_labpc.c: warning: unused variable 'dma_chan' [-Wunused-variable]: 1697:15 => 
  - /scratch/kisskb/src/drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]: 2270:7 => 
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_early.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 196:12 => 
  - /scratch/kisskb/src/drivers/tty/serial/pch_uart.c: warning: 'wait_for_xmitr' defined but not used [-Wunused-function]: 1504:13 => 
  - /scratch/kisskb/src/fs/afs/internal.h: warning: 'packed' attribute ignored for field of type 'enum <anonymous>' [-Wattributes]  CC      drivers/staging/ste_rmi4/synaptics_i2c_rmi4.o: 163:2 => 
  - /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]: 58:13 => 
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
