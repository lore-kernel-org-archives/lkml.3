Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaAMIcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:32:10 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:56099 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaAMIcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:32:07 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.13-rc8
Date: Mon, 13 Jan 2014 09:32:02 +0100
Message-Id: <1389601922-18094-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.13-rc8[1] compared to v3.12[2].

Summarized:
  - build errors: +6/-165
  - build warnings: +107/-186

JFYI, when comparing v3.13-rc8[1]  to v3.13-rc7[3], the summaries are:
  - build errors: +1/-13
  - build warnings: +48/-204

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.13-rc8.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7056/ (119 out of 120 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/6840/ (120 out of 120 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7037/ (119 out of 120 configs)


*** ERRORS ***

6 regressions:
  + /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]:  => 363:1
  + error: No rule to make target /etc/sound/msndinit.bin:  => N/A
  + error: No rule to make target /etc/sound/msndperm.bin:  => N/A
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A
  + error: nsc-ircc.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.printk' defined in .text.unlikely section in kernel/built-in.o:  => (.text+0x1ffa208), (.text+0x1ffa104), (.text+0x1ffa144), (.text+0x1ffa0c0), (.text+0x1ffa824), (.text+0x1ff94e8), (.text+0x1ffa184), (.text+0x1ffa1c4), (.text+0x1ffa7e4)
  + error: nsc-ircc.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff948c)

165 improvements:
  - /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_HIGH_MASK' undeclared (first use in this function): 98:12 => 
  - /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_HIGH_SHIFT' undeclared (first use in this function): 98:34, 145:10 => 
  - /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_LOW_MASK' undeclared (first use in this function): 97:21 => 
  - /scratch/kisskb/src/arch/sh/drivers/dma/dma-sh.c: error: 'CHCR_TS_LOW_SHIFT' undeclared (first use in this function): 97:42, 145:10 => 
  - /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function): 99:17 => 
  - /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]: 192:2 => 
  - /scratch/kisskb/src/drivers/ata/libata-core.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 6745:2 => 
  - /scratch/kisskb/src/drivers/ata/libata-sff.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 2172:3 => 
  - /scratch/kisskb/src/drivers/ata/libata-sff.c: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 567:3 => 
  - /scratch/kisskb/src/drivers/ata/libata-sff.c: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 626:3 => 
  - /scratch/kisskb/src/drivers/ata/libata-sff.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 86:2 => 
  - /scratch/kisskb/src/drivers/ata/libata-sff.c: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 569:3 => 
  - /scratch/kisskb/src/drivers/ata/libata-sff.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 3018:2 => 
  - /scratch/kisskb/src/drivers/ata/libata-sff.c: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 628:3 => 
  - /scratch/kisskb/src/drivers/ata/libata-sff.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 301:3 => 
  - /scratch/kisskb/src/drivers/ata/pata_arasan_cf.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 549:3 => 
  - /scratch/kisskb/src/drivers/ata/sata_mv.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 1962:3 => 
  - /scratch/kisskb/src/drivers/ata/sata_rcar.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 163:3 => 
  - /scratch/kisskb/src/drivers/ata/sata_rcar.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 136:2 => 
  - /scratch/kisskb/src/drivers/dma/timb_dma.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 130:2 => 
  - /scratch/kisskb/src/drivers/dma/timb_dma.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 134:2 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]: 217:5 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_memory.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]: 127:3 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 100:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 105:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 95:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 85:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 90:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 80:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-pca-platform.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 46:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-pca-platform.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 64:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 198:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 183:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 188:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 193:2 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 178:2 => 
  - /scratch/kisskb/src/drivers/input/serio/arc_ps2.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 57:3 => 
  - /scratch/kisskb/src/drivers/input/serio/arc_ps2.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 101:4 => 
  - /scratch/kisskb/src/drivers/ipack/devices/ipoctal.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 134:3 => 
  - /scratch/kisskb/src/drivers/ipack/devices/ipoctal.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 68:2 => 
  - /scratch/kisskb/src/drivers/ipack/ipack.c: error: implicit declaration of function 'ioread16be' [-Werror=implicit-function-declaration]: 376:3 => 
  - /scratch/kisskb/src/drivers/ipack/ipack.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 358:2 => 
  - /scratch/kisskb/src/drivers/media/platform/sh_veu.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 228:2 => 
  - /scratch/kisskb/src/drivers/media/platform/sh_veu.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 234:2 => 
  - /scratch/kisskb/src/drivers/media/platform/soc_camera/rcar_vin.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 351:2 => 
  - /scratch/kisskb/src/drivers/media/platform/soc_camera/rcar_vin.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 283:3 => 
  - /scratch/kisskb/src/drivers/media/platform/vsp1/vsp1.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 66:2 => 
  - /scratch/kisskb/src/drivers/media/platform/vsp1/vsp1.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 71:2 => 
  - /scratch/kisskb/src/drivers/mfd/kempld-core.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 38:2 => 
  - /scratch/kisskb/src/drivers/mfd/kempld-core.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 45:2 => 
  - /scratch/kisskb/src/drivers/mtd/nand/denali.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 116:2 => 
  - /scratch/kisskb/src/drivers/mtd/nand/denali.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 107:2 => 
  - /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 263:2 => 
  - /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: error: implicit declaration of function 'ioread8_rep' [-Werror=implicit-function-declaration]: 231:2 => 
  - /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 247:2 => 
  - /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: error: implicit declaration of function 'iowrite8_rep' [-Werror=implicit-function-declaration]: 216:2 => 
  - /scratch/kisskb/src/drivers/net/can/cc770/cc770_platform.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 69:2 => 
  - /scratch/kisskb/src/drivers/net/can/cc770/cc770_platform.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 75:2 => 
  - /scratch/kisskb/src/drivers/net/can/sja1000/sja1000_platform.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 42:2 => 
  - /scratch/kisskb/src/drivers/net/can/sja1000/sja1000_platform.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 47:2 => 
  - /scratch/kisskb/src/drivers/net/can/softing/softing_fw.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 52:4 => 
  - /scratch/kisskb/src/drivers/net/can/softing/softing_fw.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 369:2 => 
  - /scratch/kisskb/src/drivers/net/can/softing/softing_fw.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 46:3 => 
  - /scratch/kisskb/src/drivers/net/can/softing/softing_fw.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 37:2 => 
  - /scratch/kisskb/src/drivers/net/can/softing/softing_fw.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 295:3 => 
  - /scratch/kisskb/src/drivers/net/can/softing/softing_fw.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 38:2 => 
  - /scratch/kisskb/src/drivers/net/can/softing/softing_main.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 47:3 => 
  - /scratch/kisskb/src/drivers/net/can/softing/softing_main.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 47:3 => 
  - /scratch/kisskb/src/drivers/net/ethernet/ethoc.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 234:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/ethoc.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 239:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 207:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 247:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 233:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 185:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 180:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 192:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8851_mll.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 491:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8851_mll.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 760:3 => 
  - /scratch/kisskb/src/drivers/net/ethernet/micrel/ks8851_mll.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 490:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/renesas/sh_eth.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 558:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/renesas/sh_eth.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 550:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/wiznet/w5100.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 122:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/wiznet/w5100.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 128:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/wiznet/w5300.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 118:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/wiznet/w5300.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 124:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/ath/ath9k/init.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 215:3 => 
  - /scratch/kisskb/src/drivers/net/wireless/ath/ath9k/init.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 199:3 => 
  - /scratch/kisskb/src/drivers/ptp/ptp_pch.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 153:2 => 
  - /scratch/kisskb/src/drivers/ptp/ptp_pch.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 154:2 => 
  - /scratch/kisskb/src/drivers/spi/spi-sh-hspi.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 68:2 => 
  - /scratch/kisskb/src/drivers/spi/spi-sh-hspi.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 63:2 => 
  - /scratch/kisskb/src/drivers/spi/spi-sh.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 112:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-sh.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 110:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-sh.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 104:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-sh.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 102:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-xilinx.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 104:2 => 
  - /scratch/kisskb/src/drivers/spi/spi-xilinx.c: error: implicit declaration of function 'ioread32be' [-Werror=implicit-function-declaration]: 114:2 => 
  - /scratch/kisskb/src/drivers/spi/spi-xilinx.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 99:2 => 
  - /scratch/kisskb/src/drivers/spi/spi-xilinx.c: error: implicit declaration of function 'iowrite32be' [-Werror=implicit-function-declaration]: 109:2 => 
  - /scratch/kisskb/src/drivers/tty/serial/timbuart.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 54:2 => 
  - /scratch/kisskb/src/drivers/tty/serial/timbuart.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 84:3 => 
  - /scratch/kisskb/src/drivers/tty/serial/timbuart.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 55:2 => 
  - /scratch/kisskb/src/drivers/tty/serial/timbuart.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 87:3 => 
  - /scratch/kisskb/src/drivers/usb/chipidea/ci.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 253:2 => 
  - /scratch/kisskb/src/drivers/usb/chipidea/ci.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 269:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/fotg210-udc.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 33:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/fotg210-udc.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 39:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/fusb300_udc.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 42:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/fusb300_udc.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 45:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 526:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 540:3 => 
  - /scratch/kisskb/src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 537:3 => 
  - /scratch/kisskb/src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 547:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 592:3 => 
  - /scratch/kisskb/src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 577:3 => 
  - /scratch/kisskb/src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 583:6 => 
  - /scratch/kisskb/src/drivers/usb/gadget/mv_u3d_core.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 70:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/mv_u3d_core.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 72:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 127:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 161:4 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 152:5 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 144:4 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 179:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 216:4 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 269:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 209:4 => 
  - /scratch/kisskb/src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 233:3 => 
  - /scratch/kisskb/src/drivers/usb/host/fotg210-hcd.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 5859:2 => 
  - /scratch/kisskb/src/drivers/usb/host/fotg210-hcd.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 5856:2 => 
  - /scratch/kisskb/src/drivers/usb/host/r8a66597.h: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 168:2 => 
  - /scratch/kisskb/src/drivers/usb/host/r8a66597.h: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 189:3 => 
  - /scratch/kisskb/src/drivers/usb/host/r8a66597.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 183:4 => 
  - /scratch/kisskb/src/drivers/usb/host/r8a66597.h: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 180:3 => 
  - /scratch/kisskb/src/drivers/usb/host/r8a66597.h: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 196:2 => 
  - /scratch/kisskb/src/drivers/usb/host/r8a66597.h: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 240:3 => 
  - /scratch/kisskb/src/drivers/usb/host/r8a66597.h: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 225:3 => 
  - /scratch/kisskb/src/drivers/usb/host/r8a66597.h: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 231:6 => 
  - /scratch/kisskb/src/drivers/usb/musb/musb_core.c: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]: 305:5 => 
  - /scratch/kisskb/src/drivers/usb/musb/musb_core.c: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 296:5 => 
  - /scratch/kisskb/src/drivers/usb/musb/musb_core.c: error: implicit declaration of function 'ioread8_rep' [-Werror=implicit-function-declaration]: 313:3 => 
  - /scratch/kisskb/src/drivers/usb/musb/musb_core.c: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]: 262:5 => 
  - /scratch/kisskb/src/drivers/usb/musb/musb_core.c: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 253:5 => 
  - /scratch/kisskb/src/drivers/usb/musb/musb_core.c: error: implicit declaration of function 'iowrite8_rep' [-Werror=implicit-function-declaration]: 270:3 => 
  - /scratch/kisskb/src/drivers/usb/musb/tusb6010.c: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 249:5 => 
  - /scratch/kisskb/src/drivers/usb/musb/tusb6010.c: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 202:5 => 
  - /scratch/kisskb/src/drivers/usb/phy/phy-rcar-usb.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 119:4 => 
  - /scratch/kisskb/src/drivers/usb/phy/phy-rcar-usb.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 102:3 => 
  - /scratch/kisskb/src/drivers/usb/renesas_usbhs/common.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]: 73:2 => 
  - /scratch/kisskb/src/drivers/usb/renesas_usbhs/common.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]: 78:2 => 
  - /scratch/kisskb/src/drivers/usb/renesas_usbhs/fifo.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 674:4 => 
  - /scratch/kisskb/src/drivers/usb/renesas_usbhs/fifo.c: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]: 666:3 => 
  - /scratch/kisskb/src/drivers/usb/renesas_usbhs/fifo.c: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]: 519:3 => 
  - /scratch/kisskb/src/drivers/usb/renesas_usbhs/fifo.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 526:3 => 
  - /scratch/kisskb/src/drivers/video/uvesafb.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]: 1563:2 => 
  - error: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!: N/A => 
  - error: "__ashrdi3" [fs/xfs/xfs.ko] undefined!: N/A => 
  - error: "max_low_pfn" [drivers/block/aoe/aoe.ko] undefined!: N/A => 
  - error: "min_low_pfn" [drivers/block/aoe/aoe.ko] undefined!: N/A => 
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `.__kmalloc' defined in .text section in mm/built-in.o: (.text+0x1ffa1ac), (.text+0x1ffa13c) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `.ip_fast_csum' defined in .text section in arch/powerpc/lib/built-in.o: (.text+0x1ff9648) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `.memcmp' defined in .text section in arch/powerpc/lib/built-in.o: (.text+0x1ff99fc), (.text+0x1ff9a40) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_24' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9704) => 
  - error: sungem_phy.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffb504), (.text+0x1ffae84) => 
  - error: sungem_phy.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffb39c), (.text+0x1ffad20) => 


*** WARNINGS ***

107 regressions:
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_64_mmu.c: warning: 'slb' may be used uninitialized in this function [-Wuninitialized]:  => 604:6
  + /scratch/kisskb/src/arch/s390/kvm/priv.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 54:13
  + /scratch/kisskb/src/arch/x86/kernel/cpu/perf_event.c: warning: 'reg_fail' may be used uninitialized in this function [-Wuninitialized]:  => 236:9
  + /scratch/kisskb/src/arch/x86/kernel/cpu/perf_event.c: warning: 'val_fail' may be used uninitialized in this function [-Wuninitialized]:  => 236:9
  + /scratch/kisskb/src/crypto/async_tx/async_pq.c: warning: 'async_gen_syndrome' uses dynamic stack allocation [enabled by default]:  => 254:1
  + /scratch/kisskb/src/crypto/async_tx/raid6test.c: warning: array subscript is below array bounds [-Warray-bounds]:  => 170:9
  + /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat]:  => 2176:2
  + /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat]:  => 927:3, 1608:3
  + /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 2241:3
  + /scratch/kisskb/src/drivers/dma/ioat/dma_v2.c: warning: unused variable 'chanerr' [-Wunused-variable]:  => 572:7
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_debugfs.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 2393:2
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 77:6
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 117:5
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 118:15
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 118:3
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c: warning: the frame size of 3008 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 1253:1
  + /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'shift' may be used uninitialized in this function [-Wuninitialized]: 198:22, 121:57 => 198:22, 121:41, 197:47, 121:57
  + /scratch/kisskb/src/drivers/leds/leds-pwm.c: warning: unused variable 'node' [-Wunused-variable]:  => 88:22
  + /scratch/kisskb/src/drivers/md/bcache/alloc.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 416:18
  + /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.9' uses dynamic stack allocation [enabled by default]:  => 593:1
  + /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_tcw_whitening.isra.8' uses dynamic stack allocation [enabled by default]:  => 735:1
  + /scratch/kisskb/src/drivers/md/dm-stats.c: warning: 'mult' may be used uninitialized in this function [-Wuninitialized]:  => 661:40
  + /scratch/kisskb/src/drivers/md/raid5.c: warning: 'target' may be used uninitialized in this function [-Wuninitialized]: 1103:2 => 1188:2, 1192:8
  + /scratch/kisskb/src/drivers/media/common/b2c2/flexcop-fe-tuner.c: warning: 'flexcop_set_voltage' defined but not used [-Wunused-function]:  => 31:12
  + /scratch/kisskb/src/drivers/media/common/b2c2/flexcop-fe-tuner.c: warning: 'flexcop_sleep' defined but not used [-Wunused-function]:  => 59:12
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1884:7, 1510:9, 745:2, 1449:7 => 1884:7, 1382:7, 1510:9, 745:2, 1449:7, 1828:7
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 975:1 => 975:1, 420:1
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1712 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2172 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 654:1
  + /scratch/kisskb/src/drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 130:3, 422:15, 130:11
  + /scratch/kisskb/src/drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 147:15, 96:11, 102:2, 145:20, 96:3, 127:2
  + /scratch/kisskb/src/drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 407:9
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/tx.c: warning: label 'finish_packet' defined but not used [-Wunused-label]:  => 432:1
  + /scratch/kisskb/src/drivers/net/wireless/b43/phy_n.c: warning: 'val_addr' may be used uninitialized in this function [-Wuninitialized]:  => 178:21
  + /scratch/kisskb/src/drivers/net/wireless/iwlwifi/mvm/nvm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 448:6
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 213:17, 184:21, 200:21, 160:21, 144:20, 172:12, 115:16
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 133:2
  + /scratch/kisskb/src/drivers/rtc/rtc-cmos.c: warning: 'cmos_resume' defined but not used [-Wunused-function]:  => 845:12
  + /scratch/kisskb/src/drivers/rtc/rtc-s5m.c: warning: 's5m_rtc_resume' defined but not used [-Wunused-function]:  => 642:12
  + /scratch/kisskb/src/drivers/rtc/rtc-s5m.c: warning: 's5m_rtc_suspend' defined but not used [-Wunused-function]:  => 653:12
  + /scratch/kisskb/src/drivers/scsi/g_NCR5380.c: warning: 'id_table' defined but not used [-Wunused-variable]:  => 931:32
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 658:1
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 583:1
  + /scratch/kisskb/src/drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'smtcfb_pci_resume' defined but not used [-Wunused-function]:  => 965:12
  + /scratch/kisskb/src/drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'smtcfb_pci_suspend' defined but not used [-Wunused-function]:  => 942:12
  + /scratch/kisskb/src/drivers/tty/serial/sh-sci.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 560:23
  + /scratch/kisskb/src/drivers/usb/musb/ux500.c: warning: 'ux500_resume' defined but not used [-Wunused-function]:  => 363:12
  + /scratch/kisskb/src/drivers/usb/musb/ux500.c: warning: 'ux500_suspend' defined but not used [-Wunused-function]:  => 352:12
  + /scratch/kisskb/src/drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + /scratch/kisskb/src/drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + /scratch/kisskb/src/fs/afs/internal.h: warning: 'packed' attribute ignored for field of type 'enum <anonymous>' [-Wattributes]  LD      drivers/iio/amplifiers/built-in.o:  => 163:2
  + /scratch/kisskb/src/fs/binfmt_elf_fdpic.c: warning: unused variable 'addr' [-Wunused-variable]:  => 1490:17
  + /scratch/kisskb/src/fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]: 4021:6 => 4011:2, 4012:6
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1306:23
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1273:6 => 1271:6, 1131:6
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]:  => 1302:38
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1307:18
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'eb' may be used uninitialized in this function [-Wuninitialized]:  => 149:25
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'offset' may be used uninitialized in this function [-Wuninitialized]:  => 148:21
  + /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]:  => 58:13
  + /scratch/kisskb/src/fs/ext4/inode.c: warning: 'retval' may be used uninitialized in this function [-Wuninitialized]: 581:5 => 581:5, 581:2
  + /scratch/kisskb/src/fs/hfsplus/xattr.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 159:2
  + /scratch/kisskb/src/fs/mpage.c: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 320:1
  + /scratch/kisskb/src/fs/mpage.c: warning: the frame size of 1156 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + /scratch/kisskb/src/fs/sysfs/file.c: warning: unused variable 'kobj' [-Wunused-variable]:  => 610:18
  + /scratch/kisskb/src/include/linux/mfd/da9052/da9052.h: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 173:6, 150:6
  + /scratch/kisskb/src/include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]  CC      fs/minix/itree_v2.o:  => 278:6
  + /scratch/kisskb/src/include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 279:4, 349:2, 324:17, 278:6, 367:14, 290:22, 414:2, 332:11, 397:11 => 424:3, 279:4, 349:2, 324:17, 278:6, 367:14, 290:22, 324:3, 414:2, 278:3, 332:11, 397:11
  + /scratch/kisskb/src/include/linux/rculist.h: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]:  => 80:16
  + /scratch/kisskb/src/ipc/msgutil.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 54:9, 101:10, 162:10, 155:9, 94:9, 66:10
  + /scratch/kisskb/src/ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]:  => 2012:26
  + /scratch/kisskb/src/kernel/seccomp.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 455:15
  + /scratch/kisskb/src/kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 112:1
  + /scratch/kisskb/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 708:2
  + /scratch/kisskb/src/lib/debugobjects.c: warning: 'obj_states' defined but not used [-Wunused-variable]:  => 73:20
  + /scratch/kisskb/src/lib/debugobjects.c: warning: unused variable 'hint' [-Wunused-variable]:  => 254:9
  + /scratch/kisskb/src/mm/pgtable-generic.c: warning: unused variable 'mm' [-Wunused-variable]:  => 113:20
  + /scratch/kisskb/src/mm/zswap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 537:6
  + /scratch/kisskb/src/net/netfilter/ipvs/ip_vs_sync.c: warning: unused variable 'ret' [-Wunused-variable]:  => 1640:8
  + /scratch/kisskb/src/net/netfilter/nfnetlink.c: warning: 'nfnetlink_rcv_batch' uses dynamic stack allocation [enabled by default]:  => 358:1
  + /scratch/kisskb/src/net/netfilter/nft_payload.c: warning: 'offset' may be used uninitialized in this function [-Wuninitialized]:  => 44:9
  + /scratch/kisskb/src/net/rds/iw_rdma.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /scratch/kisskb/src/security/integrity/ima/ima_api.c: warning: 'ima_audit_measurement' uses dynamic stack allocation [enabled by default]:  => 319:1
  + /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_boot_aggregate_tfm' uses dynamic stack allocation [enabled by default]:  => 240:1
  + /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_field_array_hash_tfm.isra.0' uses dynamic stack allocation [enabled by default]:  => 181:1
  + /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_file_hash_tfm' uses dynamic stack allocation [enabled by default]:  => 121:1
  + warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (E500 && PPC_FSL_BOOK3E) selects FSL_EMB_PERFMON which has unmet direct dependencies (E500 || PPC_83xx):  => N/A
  + warning: drivers/built-in.o(.data+0xa08): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xaa8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc04): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd0c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xd6c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdcc): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe2c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xfd4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d78): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x3ebdc): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x404c8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x40568): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x406c4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x407cc): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4082c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4088c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x408ec): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x40a94): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

186 improvements:
  - /scratch/kisskb/src/arch/cris/include/arch-v10/arch/swab.h: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]: 24:2 => 
  - /scratch/kisskb/src/arch/openrisc/kernel/module.c: warning: assignment from incompatible pointer type: 50:13, 54:13 => 
  - /scratch/kisskb/src/arch/s390/kernel/crash_dump.c: warning: unused variable 'rc' [-Wunused-variable]: 48:6 => 
  - /scratch/kisskb/src/arch/sh/include/uapi/asm/swab.h: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]: 32:2 => 
  - /scratch/kisskb/src/arch/x86/kernel/vsyscall_64.c: warning: 'syscall_nr' may be used uninitialized in this function [-Wuninitialized]: 261:16 => 
  - /scratch/kisskb/src/crypto/async_tx/async_pq.c: warning: 'do_async_gen_syndrome.constprop.9' uses dynamic stack allocation [enabled by default]: 143:1 => 
  - /scratch/kisskb/src/drivers/block/mtip32xx/mtip32xx.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2894:1, 2917:1 => 
  - /scratch/kisskb/src/drivers/char/hw_random/via-rng.c: warning: 'via_rng_cpu_id' defined but not used [-Wunused-variable]: 224:26 => 
  - /scratch/kisskb/src/drivers/char/random.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'int' [-Wformat]: 1176:3 => 
  - /scratch/kisskb/src/drivers/char/random.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'size_t' [-Wformat]: 1176:3 => 
  - /scratch/kisskb/src/drivers/char/random.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'int' [-Wformat]: 1167:3 => 
  - /scratch/kisskb/src/drivers/char/random.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]: 858:2, 886:2 => 
  - /scratch/kisskb/src/drivers/char/random.c: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]: 825:3 => 
  - /scratch/kisskb/src/drivers/dma/fsldma.c: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]: 426:2 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]: 474:4 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 217:17 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_edid_load.c: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]: 141:22 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_memory.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 127:15 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 83:3, 106:4 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 304:2 => 
  - /scratch/kisskb/src/drivers/gpu/drm/radeon/cypress_dpm.c: warning: unused variable 'eg_pi' [-Wunused-variable]: 302:31 => 
  - /scratch/kisskb/src/drivers/gpu/drm/radeon/ni_dpm.c: warning: unused variable 'eg_pi' [-Wunused-variable]: 3448:31 => 
  - /scratch/kisskb/src/drivers/gpu/drm/udl/udl_modeset.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]: 28:9 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-diolan-u2c.c: warning: 'byte' may be used uninitialized in this function [-Wuninitialized]: 394:18 => 
  - /scratch/kisskb/src/drivers/md/bcache/alloc.c: warning: 'bucket' may be used uninitialized in this function [-Wuninitialized]: 408:5 => 
  - /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.8' uses dynamic stack allocation [enabled by default]: 573:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/af9013.c: warning: 'af9013_wr_regs_i2c' uses dynamic stack allocation [enabled by default]: 77:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/af9033.c: warning: 'af9033_wr_reg_val_tab' uses dynamic stack allocation [enabled by default]: 188:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/af9033.c: warning: 'af9033_wr_regs' uses dynamic stack allocation [enabled by default]: 68:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/bcm3510.c: warning: 'bcm3510_do_hab_cmd' uses dynamic stack allocation [enabled by default]: 230:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/cxd2820r_core.c: warning: 'cxd2820r_rd_regs_i2c.isra.1' uses dynamic stack allocation [enabled by default]: 84:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/cxd2820r_core.c: warning: 'cxd2820r_wr_regs_i2c.isra.0' uses dynamic stack allocation [enabled by default]: 51:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/itd1000.c: warning: 'itd1000_write_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 69:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/mt312.c: warning: 'mt312_write' uses dynamic stack allocation [enabled by default]: 126:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/nxt200x.c: warning: 'nxt200x_writebytes' uses dynamic stack allocation [enabled by default]: 111:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/rtl2830.c: warning: 'rtl2830_wr' uses dynamic stack allocation [enabled by default]: 56:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/rtl2832.c: warning: 'rtl2832_wr' uses dynamic stack allocation [enabled by default]: 187:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/s5h1420.c: warning: 's5h1420_tuner_i2c_tuner_xfer' uses dynamic stack allocation [enabled by default]: 851:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/stb0899_drv.c: warning: 'stb0899_write_regs' uses dynamic stack allocation [enabled by default]: 540:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/stb6100.c: warning: 'stb6100_write_reg_range.constprop.3' uses dynamic stack allocation [enabled by default]: 216:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/stv0367.c: warning: 'stv0367_writeregs.constprop.4' uses dynamic stack allocation [enabled by default]: 791:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/stv090x.c: warning: 'stv090x_write_regs.constprop.6' uses dynamic stack allocation [enabled by default]: 750:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/stv6110.c: warning: 'stv6110_write_regs' uses dynamic stack allocation [enabled by default]: 98:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/stv6110x.c: warning: 'stv6110x_write_regs' uses dynamic stack allocation [enabled by default]: 85:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/tda10071.c: warning: 'tda10071_rd_regs' uses dynamic stack allocation [enabled by default]: 84:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/tda10071.c: warning: 'tda10071_wr_regs' uses dynamic stack allocation [enabled by default]: 52:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/tda18271c2dd.c: warning: 'WriteRegs' uses dynamic stack allocation [enabled by default]: 147:1 => 
  - /scratch/kisskb/src/drivers/media/dvb-frontends/zl10039.c: warning: 'zl10039_write' uses dynamic stack allocation [enabled by default]: 119:1 => 
  - /scratch/kisskb/src/drivers/media/pci/cx23885/cimax2.c: warning: 'netup_write_i2c' uses dynamic stack allocation [enabled by default]: 149:1 => 
  - /scratch/kisskb/src/drivers/media/pci/ttpci/av7110_hw.c: warning: 'av7110_fw_cmd' uses dynamic stack allocation [enabled by default]: 510:1 => 
  - /scratch/kisskb/src/drivers/media/radio/radio-shark.c: warning: 'shark_resume_leds' defined but not used [-Wunused-function]: 274:13 => 
  - /scratch/kisskb/src/drivers/media/radio/radio-shark2.c: warning: 'shark_resume_leds' defined but not used [-Wunused-function]: 240:13 => 
  - /scratch/kisskb/src/drivers/media/radio/si470x/radio-si470x-i2c.c: warning: 'si470x_i2c_resume' defined but not used [-Wunused-function]: 487:12 => 
  - /scratch/kisskb/src/drivers/media/radio/si470x/radio-si470x-i2c.c: warning: 'si470x_i2c_suspend' defined but not used [-Wunused-function]: 470:12 => 
  - /scratch/kisskb/src/drivers/media/rc/fintek-cir.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 80:2, 54:2, 81:2, 55:8, 45:2, 87:2, 46:2 => 
  - /scratch/kisskb/src/drivers/media/rc/nuvoton-cir.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 52:2, 91:2, 45:2, 81:2, 92:2, 74:2, 46:2, 53:9, 75:2 => 
  - /scratch/kisskb/src/drivers/media/tuners/e4000.c: warning: 'e4000_rd_regs' uses dynamic stack allocation [enabled by default]: 84:1 => 
  - /scratch/kisskb/src/drivers/media/tuners/e4000.c: warning: 'e4000_wr_regs' uses dynamic stack allocation [enabled by default]: 51:1 => 
  - /scratch/kisskb/src/drivers/media/tuners/fc2580.c: warning: 'fc2580_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 98:1 => 
  - /scratch/kisskb/src/drivers/media/tuners/fc2580.c: warning: 'fc2580_wr_regs.constprop.1' uses dynamic stack allocation [enabled by default]: 66:1 => 
  - /scratch/kisskb/src/drivers/media/tuners/tda18212.c: warning: 'tda18212_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 90:1 => 
  - /scratch/kisskb/src/drivers/media/tuners/tda18212.c: warning: 'tda18212_wr_regs' uses dynamic stack allocation [enabled by default]: 57:1 => 
  - /scratch/kisskb/src/drivers/media/tuners/tda18218.c: warning: 'tda18218_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 92:1 => 
  - /scratch/kisskb/src/drivers/media/tuners/tda18218.c: warning: 'tda18218_wr_regs' uses dynamic stack allocation [enabled by default]: 60:1 => 
  - /scratch/kisskb/src/drivers/media/tuners/tuner-xc2028.c: warning: 'load_firmware' uses dynamic stack allocation [enabled by default]: 651:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb-v2/af9015.c: warning: 'af9015_eeprom_hash' uses dynamic stack allocation [enabled by default]: 433:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb-v2/af9035.c: warning: 'af9035_i2c_master_xfer' uses dynamic stack allocation [enabled by default]: 305:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb-v2/af9035.c: warning: 'af9035_wr_regs' uses dynamic stack allocation [enabled by default]: 142:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb-v2/mxl111sf.c: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]: 74:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb/cxusb.c: warning: 'cxusb_ctrl_msg' uses dynamic stack allocation [enabled by default]: 69:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb/cxusb.c: warning: 'cxusb_i2c_xfer' uses dynamic stack allocation [enabled by default]: 209:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb/dibusb-common.c: warning: 'dibusb_i2c_msg' uses dynamic stack allocation [enabled by default]: 124:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw2102_earda_i2c_transfer' uses dynamic stack allocation [enabled by default]: 368:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw2104_i2c_transfer' uses dynamic stack allocation [enabled by default]: 449:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw3101_i2c_transfer' uses dynamic stack allocation [enabled by default]: 512:1 => 
  - /scratch/kisskb/src/drivers/media/usb/dvb-usb/dw2102.c: warning: 's6x0_i2c_transfer' uses dynamic stack allocation [enabled by default]: 621:1 => 
  - /scratch/kisskb/src/drivers/media/usb/gspca/cpia1.c: warning: unused variable 'sd' [-Wunused-variable]: 1627:13 => 
  - /scratch/kisskb/src/drivers/media/usb/gspca/konica.c: warning: unused variable 'sd' [-Wunused-variable]: 246:13 => 
  - /scratch/kisskb/src/drivers/media/usb/gspca/t613.c: warning: unused variable 'sd' [-Wunused-variable]: 840:13 => 
  - /scratch/kisskb/src/drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]: 1106:1 => 
  - /scratch/kisskb/src/drivers/media/usb/uvc/uvc_ctrl.c: warning: 'ctrl' may be used uninitialized in this function [-Wuninitialized]: 1972:6 => 
  - /scratch/kisskb/src/drivers/media/usb/uvc/uvc_video.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 9 has type '__kernel_suseconds_t' [-Wformat]: 678:2 => 
  - /scratch/kisskb/src/drivers/media/v4l2-core/v4l2-async.c: warning: 'v4l2_async_notifier_unregister' uses dynamic stack allocation [enabled by default]: 238:1 => 
  - /scratch/kisskb/src/drivers/mfd/da903x.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 185:2, 229:2, 207:2 => 
  - /scratch/kisskb/src/drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]: 344:17, 344:3 => 
  - /scratch/kisskb/src/drivers/misc/lkdtm.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 293:1 => 
  - /scratch/kisskb/src/drivers/misc/lkdtm.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 293:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1384 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 420:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1704 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 975:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2164 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 654:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb3/sge.c: warning: passing argument 4 of 'make_sgl' makes integer from pointer without a cast [enabled by default]: 1603:9 => 
  - /scratch/kisskb/src/drivers/net/wireless/ath/ath6kl/htc_pipe.c: warning: integer overflow in expression [-Woverflow]: 1293:26 => 
  - /scratch/kisskb/src/drivers/nubus/proc.c: warning: #warning Need to set some I/O handlers here [-Wcpp]  CC      drivers/ide/ide-probe.o: 64:2 => 
  - /scratch/kisskb/src/drivers/regulator/da9063-regulator.c: warning: 'da9063_reg_matches' may be used uninitialized in this function [-Wuninitialized]: 847:6 => 
  - /scratch/kisskb/src/drivers/regulator/s5m8767.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]: 211:29 => 
  - /scratch/kisskb/src/drivers/scsi/scsi_debug.c: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]: 1755:3 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: 'hb' is used uninitialized in this function [-Wuninitialized]: 273:14 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: 'lb' is used uninitialized in this function [-Wuninitialized]: 273:20 => 
  - /scratch/kisskb/src/drivers/staging/lustre/lustre/llite/lproc_llite.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 1066:6, 1296:6, 1130:6 => 
  - /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type '__kernel_suseconds_t' [-Wformat]: 1072:5 => 
  - /scratch/kisskb/src/drivers/staging/lustre/lustre/osc/lproc_osc.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 574:6, 686:6 => 
  - /scratch/kisskb/src/drivers/staging/media/lirc/lirc_serial.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type '__kernel_suseconds_t' [-Wformat]: 719:5, 728:6, 707:5 => 
  - /scratch/kisskb/src/drivers/staging/media/lirc/lirc_serial.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type '__kernel_suseconds_t' [-Wformat]: 719:5, 728:6, 707:5 => 
  - /scratch/kisskb/src/drivers/staging/media/lirc/lirc_zilog.c: warning: 'read' uses dynamic stack allocation [enabled by default]: 967:1 => 
  - /scratch/kisskb/src/drivers/staging/rts5139/sd_cprm.c: warning: 'rsp_len' may be used uninitialized in this function [-Wuninitialized]: 260:7 => 
  - /scratch/kisskb/src/drivers/staging/speakup/kobjects.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]: 667:39 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: warning: type defaults to 'int' in declaration of 'console_initcall' [-Wimplicit-int]: 362:1 => 
  - /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 269:6 => 
  - /scratch/kisskb/src/drivers/uio/uio.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 616:3 => 
  - /scratch/kisskb/src/drivers/usb/gadget/g_ffs.c: warning: data definition has no type or storage class [enabled by default]: 79:1 => 
  - /scratch/kisskb/src/drivers/usb/gadget/g_ffs.c: warning: function declaration isn't a prototype [-Wstrict-prototypes]: 79:1 => 
  - /scratch/kisskb/src/drivers/usb/gadget/g_ffs.c: warning: type defaults to 'int' in declaration of 'USB_ETHERNET_MODULE_PARAMETERS' [-Wimplicit-int]: 79:1 => 
  - /scratch/kisskb/src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M10' defined but not used [-Wunused-function]: 1718:13 => 
  - /scratch/kisskb/src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M9P' defined but not used [-Wunused-function]: 1971:13 => 
  - /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 598:32, 624:11, 568:10, 443:16 => 
  - /scratch/kisskb/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 809:11, 563:16, 783:32 => 
  - /scratch/kisskb/src/drivers/video/uvesafb.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 1563:20 => 
  - /scratch/kisskb/src/fs/binfmt_flat.c: warning: unused variable 'persistent' [-Wunused-variable]: 745:17 => 
  - /scratch/kisskb/src/fs/buffer.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]: 263:4 => 
  - /scratch/kisskb/src/fs/f2fs/recovery.c: warning: 'sum.<U3660>.<U3600>.ofs_in_node' may be used uninitialized in this function [-Wuninitialized]: 271:51 => 
  - /scratch/kisskb/src/fs/f2fs/recovery.c: warning: 'sum.nid' may be used uninitialized in this function [-Wuninitialized]: 243:2 => 
  - /scratch/kisskb/src/fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]: 1782:17 => 
  - /scratch/kisskb/src/fs/omfs/file.c: warning: 'remain' may be used uninitialized in this function [-Wuninitialized]: 257:4 => 
  - /scratch/kisskb/src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used [-Wunused-function]: 483:14 => 
  - /scratch/kisskb/src/fs/sysfs/file.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]: 139:2 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u16' makes pointer from integer without a cast [enabled by default]/scratch/kisskb/src/arch/s390/include/asm/pci_io.h:59:1: note: expected 'const volatile void *' but argument is of type 'long unsigned int': 183:4 => 
  - /scratch/kisskb/src/include/linux/err.h: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]: 39:17 => 
  - /scratch/kisskb/src/kernel/rcutiny.c: warning: unused variable 'idle' [-Wunused-variable]: 129:23, 68:23 => 
  - /scratch/kisskb/src/kernel/rcutiny.c: warning: unused variable 'idle': 129, 68 => 
  - /scratch/kisskb/src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]: 2559:8 => 
  - /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: the frame size of 1052 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 535:1 => 
  - /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]: 70:2, 73:2 => 
  - /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]: 45:2, 49:4, 56:2 => 
  - /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]: 113:2, 116:2 => 
  - /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]: 92:4, 99:2, 88:2 => 
  - /scratch/kisskb/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]: 658:14 => 
  - /scratch/kisskb/src/mm/migrate.c: warning: statement with no effect [-Wunused-value]: 1172:4 => 
  - /scratch/kisskb/src/mm/nommu.c: warning: format '%zx' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat]: 1650:2 => 
  - /scratch/kisskb/src/net/rds/iw_rdma.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 200:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_boot_aggregate' uses dynamic stack allocation [enabled by default]: 148:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_buffer_hash' uses dynamic stack allocation [enabled by default]: 109:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_file_hash' uses dynamic stack allocation [enabled by default]: 93:1 => 
  - /scratch/kisskb/src/security/selinux/netnode.c: warning: 'idx' may be used uninitialized in this function [-Wuninitialized]: 174:27 => 
  - /scratch/kisskb/src/sound/pci/lx6464es/lx6464es.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 456:3 => 
  - /scratch/kisskb/src/sound/pci/lx6464es/lx_core.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1194:2 => 
  - /scratch/kisskb/src/sound/soc/atmel/atmel-pcm.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 52:2 => 
  - /scratch/kisskb/src/sound/soc/kirkwood/kirkwood-dma.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 164:3 => 
  - /scratch/kisskb/src/sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 3330:6 => 
  - /scratch/kisskb/src/sound/usb/mixer_quirks.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]  CC [M]  crypto/rmd128.o: 1514:6 => 
  - /scratch/kisskb/src/sound/usb/mixer_quirks.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 1514:6 => 
  - <stdin>: warning: #warning syscall fallocate not implemented [-Wcpp]: 1145:2 => 
  - <stdin>: warning: #warning syscall utimensat not implemented [-Wcpp]: 1133:2 => 
  - arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for MCU_MPC8349EMITX: 74 => 
  - warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): N/A => 
  - warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)): N/A => 
  - warning: 1 bad relocations: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x21a): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x222): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x282): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x28e): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x2d2): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: drivers/built-in.o(.data+0x9e8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xa88): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xbe4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xcec): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xd4c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xdac): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xe0c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xfb4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40428): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x404c8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40624): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x4072c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4078c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x407ec): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4084c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x409f4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: vmlinux.o(.text.unlikely+0x2ee): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x2f6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x356): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x362): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 
  - warning: vmlinux.o(.text.unlikely+0x3a6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size: N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
