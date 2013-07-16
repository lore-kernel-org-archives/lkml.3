Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3GPHuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:50:35 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:47322 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3GPHub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:50:31 -0400
Date: Tue, 16 Jul 2013 09:50:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.11-rc1
Message-ID: <alpine.DEB.2.02.1307160950110.8862@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.11-rc1[1] compared to v3.10[2].

Summarized:
  - build errors: +73/-52
  - build warnings: +249/-162

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.11-rc1.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/6435/ (all 120 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/6378/ (all 120 configs)


*** ERRORS ***

73 regressions:
  + arch/mips/mm/tlbex.c: error: 'tlbmiss_handler_setup_pgd_array' undeclared (first use in this function):  => 1469:11
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'dmac_resource.end'):  => 87:2
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'dmac_resource.start'):  => 86:2
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[0].end'):  => 69:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[0].start'):  => 68:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[1].end'):  => 74:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[1].start'):  => 73:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[0].end'):  => 50:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[0].start'):  => 49:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[1].end'):  => 55:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[1].start'):  => 54:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[0].end'):  => 100:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[0].start'):  => 99:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[1].end'):  => 105:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[1].start'):  => 104:3
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: braced-group within expression allowed only inside a function:  => 30:12, 73:12, 31:10, 99:12, 68:12, 36:10, 86:11, 54:12, 74:10, 55:10, 104:12, 49:12, 69:10, 87:9, 105:10, 35:12, 50:10, 100:10
  + arch/sh/drivers/superhyway/ops-sh4-202.c: error: initializer element is not constant:  => 74:3, 86:2, 55:3, 105:3, 73:3, 68:3, 100:3, 104:3, 99:3, 87:2, 50:3, 69:3, 49:3, 54:3
  + arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function):  => 99:17
  + arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]:  => 192:2
  + arch/xtensa/kernel/xtensa_ksyms.c: error: '_mcount' undeclared here (not in a function):  => 129:1
  + drivers/ata/libata-core.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 6734:2
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 2172:3
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]:  => 567:3
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]:  => 626:3
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 86:2
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]:  => 569:3
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 3018:2
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]:  => 628:3
  + drivers/ata/libata-sff.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 301:3
  + drivers/ata/pata_arasan_cf.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 549:3
  + drivers/ata/sata_mv.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 1957:3
  + drivers/ata/sata_rcar.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 163:3
  + drivers/ata/sata_rcar.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 136:2
  + drivers/crypto/amcc/crypto4xx_core.c: error: expected declaration specifiers or '...' before string constant:  => 1299:15, 1300:20, 1298:16
  + drivers/dma/timb_dma.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 130:2
  + drivers/dma/timb_dma.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 134:2
  + drivers/gpu/drm/drm_bufs.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]:  => 219:5
  + drivers/gpu/drm/drm_memory.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]:  => 129:3
  + drivers/ipack/devices/ipoctal.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 134:3
  + drivers/ipack/devices/ipoctal.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 68:2
  + drivers/ipack/ipack.c: error: implicit declaration of function 'ioread16be' [-Werror=implicit-function-declaration]:  => 376:3
  + drivers/ipack/ipack.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 358:2
  + drivers/media/platform/sh_veu.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 228:2
  + drivers/media/platform/sh_veu.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 234:2
  + drivers/mfd/kempld-core.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 38:2
  + drivers/mfd/kempld-core.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 45:2
  + drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'ioread16' [-Werror=implicit-function-declaration]:  => 207:2
  + drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 247:2
  + drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 233:2
  + drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'iowrite16' [-Werror=implicit-function-declaration]:  => 185:2
  + drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 180:2
  + drivers/net/ethernet/micrel/ks8842.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 192:2
  + drivers/net/ethernet/renesas/sh_eth.h: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 548:2
  + drivers/net/ethernet/renesas/sh_eth.h: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 540:2
  + drivers/ptp/ptp_pch.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 153:2
  + drivers/ptp/ptp_pch.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 154:2
  + drivers/spi/spi-xilinx.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 105:2
  + drivers/spi/spi-xilinx.c: error: implicit declaration of function 'ioread32be' [-Werror=implicit-function-declaration]:  => 115:2
  + drivers/spi/spi-xilinx.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 100:2
  + drivers/spi/spi-xilinx.c: error: implicit declaration of function 'iowrite32be' [-Werror=implicit-function-declaration]:  => 110:2
  + drivers/usb/gadget/fotg210-udc.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 33:2
  + drivers/usb/gadget/fotg210-udc.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 39:2
  + drivers/video/uvesafb.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]:  => 1563:2
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.free_irq' defined in .text section in kernel/built-in.o:  => (.text+0x1ffb600)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.kfree' defined in .text section in mm/built-in.o:  => (.text+0x1ffb7c0)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.proc_create_data' defined in .text section in fs/built-in.o:  => (.text+0x1ffb6f8)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.request_threaded_irq' defined in .text section in kernel/built-in.o:  => (.text+0x1ffb550)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.udelay' defined in .text section in arch/powerpc/kernel/built-in.o:  => (.text+0x1ffac0c), (.text+0x1ffc1cc), (.text+0x1ffca70), (.text+0x1ffc924)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_21' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa420)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_14' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffb7f0)
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+b8c:  => (.text+0x986)
  + sound/soc/codecs/wm0010.c: error: implicit declaration of function 'irq_set_irq_wake' [-Werror=implicit-function-declaration]:  => 976:2

52 improvements:
  - arch/cris/arch-v10/kernel/kgdb.c: error: expected string literal before '.' token: 1274:3 => 
  - arch/cris/arch-v10/kernel/kgdb.c: error: missing terminating " character: 1359:1, 1370:1, 1273:1, 1457:1 => 
  - arch/h8300/kernel/entry.S: Error: invalid operands: 204, 210, 307, 230, 218, 377, 358, 383, 247 => 
  - arch/h8300/kernel/entry.S: Error: junk at end of line, first unrecognized character is `(': 159, 161, 165, 160, 167, 158, 163, 166, 162, 164, 195 => 
  - arch/h8300/kernel/syscalls.S: Error: junk at end of line, first unrecognized character is `(': 127, 32, 276, 90, 206, 118, 71, 102, 331, 55, 84, 233, 259, 194, 57, 220, 316, 163, 89, 175, 31, 35, 208, 93, 292, 325, 29, 291, 199, 114, 226, 58, 211, 153, 101, 73, 76, 311, 62, 67, 241, 198, 139, 129, 327, 320, 280, 273, 236, 249, 218, 202, 168, 184, 135, 145, 49, 178, 24, 285, 140, 124, 104, 131, 181, 234, 314, 307, 154, 23, 96, 159, 326, 160, 47, 98, 335, 37, 43, 270, 195, 21, 288, 193, 119, 324, 180, 244, 162, 246, 240, 74, 334, 61, 230, 299, 115, 103, 201, 113, 152, 189, 295, 266, 91, 107, 87, 174, 77, 214, 221, 39, 64, 97, 41, 52, 312, 302, 229, 45, 260, 237, 309, 188, 68, 315, 116, 136, 144, 100, 300, 222, 25, 286, 120, 83, 305, 308, 254, 177, 217, 328, 239, 122, 143, 281, 269, 205, 158, 22, 42, 46, 235, 301, 6, 36, 213, 183, 94, 51, 317, 296, 265, 169, 132, 171, 200, 18, 125, 329, 44, 27, 272, 161, 190, 298, 95, 313, 20, 109, 231, 243, 151, 148, 287, 78, 294, 106, 275, 157, 65, 197, 203, 261, 138, 81, 137, 60, 321, 284, 86, 247, 204, 289, 165, 17, 186, 82, 110, 147, 333, 228, 323, 268, 69, 112, 319, 172, 191, 224, 187, 223, 282, 262, 79, 121, 212, 126, 238, 251, 253, 279, 176, 209, 216, 256, 117, 170, 33, 63, 80, 26, 227, 336, 99, 72, 179, 255, 264, 297, 182, 108, 277, 92, 232, 225, 330, 142, 207, 263, 167, 48, 133, 290, 123, 149, 304, 50, 210, 258, 173, 56, 66, 19, 293, 54, 274, 306, 70, 322, 166, 88, 141, 30, 128, 252, 28, 310, 283, 134, 40, 75, 156, 303, 192, 250, 59, 215, 278, 150, 271, 130, 155, 53, 245, 267, 219, 318, 105, 257, 85, 185, 332, 248, 111, 146, 38, 34, 164, 196, 242 => 
  - arch/h8300/lib/abs.S: Error: junk at end of line, first unrecognized character is `(': 12 => 
  - arch/h8300/lib/memcpy.S: Error: junk at end of line, first unrecognized character is `(': 13 => 
  - arch/h8300/lib/memset.S: Error: junk at end of line, first unrecognized character is `(': 13 => 
  - arch/h8300/platform/h8300h/generic/crt0_ram.S: Error: invalid operands: 68, 62 => 
  - arch/h8300/platform/h8300h/generic/crt0_ram.S: Error: junk at end of line, first unrecognized character is `(': 27, 25, 28, 26 => 
  - drivers/block/hd.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 256:2 => 
  - drivers/block/hd.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 297:3 => 
  - drivers/net/ethernet/3com/3c59x.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]: 1031:2 => 
  - drivers/net/ethernet/3com/3c59x.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]: 1044:3 => 
  - drivers/staging/speakup/serialio.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 83:2 => 
  - drivers/staging/speakup/serialio.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 199:3 => 
  - drivers/staging/speakup/speakup_acntpc.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 144:2 => 
  - drivers/staging/speakup/speakup_acntpc.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 166:3 => 
  - drivers/staging/speakup/speakup_decext.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 41:2 => 
  - drivers/staging/speakup/speakup_decpc.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 249:2 => 
  - drivers/staging/speakup/speakup_decpc.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 256:2 => 
  - drivers/staging/speakup/speakup_dtlk.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 158:2 => 
  - drivers/staging/speakup/speakup_dtlk.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 182:2 => 
  - drivers/staging/speakup/speakup_keypc.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 135:2 => 
  - drivers/staging/speakup/speakup_keypc.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 167:3 => 
  - drivers/staging/speakup/synth.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 45:4 => 
  - drivers/tty/serial/8250/8250_core.c: error: implicit declaration of function 'inb_p' [-Werror=implicit-function-declaration]: 1231:3 => 
  - drivers/tty/serial/8250/8250_core.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 1232:3 => 
  - drivers/video/console/fonts.c: error: #error No fonts configured.: 71:2 => 
  - error: "__sync_fetch_and_and_4" [drivers/staging/line6/line6usb.ko] undefined!: N/A => 
  - error: "__sync_fetch_and_or_4" [drivers/staging/line6/line6usb.ko] undefined!: N/A => 
  - error: "devm_request_threaded_irq" [drivers/i2c/busses/i2c-designware-pci.ko] undefined!: N/A => 
  - error: "devm_request_threaded_irq" [drivers/input/touchscreen/st1232.ko] undefined!: N/A => 
  - error: "devm_request_threaded_irq" [drivers/mfd/si476x-core.ko] undefined!: N/A => 
  - error: "devm_request_threaded_irq" [drivers/net/ethernet/marvell/mvmdio.ko] undefined!: N/A => 
  - error: "devm_request_threaded_irq" [drivers/staging/dwc2/dwc2.ko] undefined!: N/A => 
  - error: "irq_create_mapping" [drivers/mfd/mfd-core.ko] undefined!: N/A => 
  - error: dma.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.debug_dma_unmap_page' defined in .text section in lib/built-in.o: (.text+0x1ffc3c8), (.text+0x1ffb584) => 
  - error: dma.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.dev_kfree_skb_any' defined in .text section in net/built-in.o: (.text+0x1ffa980), (.text+0x1ffab2c) => 
  - error: dma.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.kfree' defined in .text section in mm/built-in.o: (.text+0x1ffc07c) => 
  - error: dma.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.skb_put' defined in .text section in net/built-in.o: (.text+0x1ffb1d8) => 
  - error: dma.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_22' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffb5c8) => 
  - error: dma.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa734), (.text+0x1ffa5a8), (.text+0x1ffa358) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+ae0: (.text+0x8de) => 
  - kernel/cpu/idle.c: error: implicit declaration of function 'check_pgt_cache' [-Werror=implicit-function-declaration]: 74:4 => 
  - kernel/task_work.c: error: implicit declaration of function 'read_barrier_depends' [-Werror=implicit-function-declaration]: 38:3 => 
  - net/mac80211/led.c: error: 'struct led_classdev' has no member named 'trig_list': 214:2, 278:2 => 
  - net/mac80211/led.c: error: 'struct led_trigger' has no member named 'led_cdevs': 214:2, 278:2 => 
  - net/mac80211/led.c: error: 'struct led_trigger' has no member named 'leddev_list_lock': 213:2, 280:2, 277:2, 216:2 => 
  - net/mac80211/led.c: error: 'struct led_trigger' has no member named 'name': 74:16, 83:16, 101:19, 92:19, 237:16 => 
  - net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register' [-Werror=implicit-function-declaration]: 75:3 => 
  - net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister' [-Werror=implicit-function-declaration]: 119:3 => 


*** WARNINGS ***

249 regressions:
  + arch/cris/include/arch-v10/arch/swab.h: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]:  => 24:2
  + arch/mips/mm/cex-sb1.S: Warning: .previous without corresponding .section; ignored:  => 145
  + arch/sh/include/uapi/asm/swab.h: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]:  => 32:2
  + arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence  CC      arch/sh/kernel/cpu/sh3/clock-sh7710.o:  => 378
  + arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 210
  + arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 378 => 375, 378
  + arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 349, 351
  + arch/x86/kernel/vsyscall_64.c: warning: 'syscall_nr' may be used uninitialized in this function [-Wuninitialized]:  => 261:16
  + drivers/ata/pata_atiixp.c: warning: 'wanted_pio' may be used uninitialized in this function [-Wuninitialized]:  => 195:2
  + drivers/atm/ambassador.c: warning: 'fw' may be used uninitialized in this function [-Wuninitialized]:  => 1969:19
  + drivers/bcma/sprom.c: warning: 'sprom' may be used uninitialized in this function [-Wuninitialized]:  => 614:8
  + drivers/dma/ioat/dma_v2.c: warning: unused variable 'chanerr' [-Wunused-variable]:  => 572:7
  + drivers/gpio/gpio-langwell.c: warning: 'lnw_gpio_runtime_idle' defined but not used [-Wunused-function]:  => 301:12
  + drivers/gpu/drm/drm_bufs.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 219:17
  + drivers/gpu/drm/drm_memory.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 129:15
  + drivers/gpu/drm/i915/i915_gem_context.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 124:2
  + drivers/gpu/drm/i915/i915_gem_gtt.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 495:3
  + drivers/gpu/drm/i915/i915_gem_gtt.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 358:2
  + drivers/gpu/drm/i915/i915_irq.c: warning: 'score' may be used uninitialized in this function [-Wuninitialized]:  => 2509:27
  + drivers/gpu/drm/i915/i915_sysfs.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 399:2
  + drivers/gpu/drm/i915/intel_ddi.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 79:1
  + drivers/gpu/drm/i915/intel_ddi.c: warning: unused variable 'intel_crtc' [-Wunused-variable]:  => 343:21
  + drivers/gpu/drm/i915/intel_display.c: warning: 'alignment' may be used uninitialized in this function [-Wuninitialized]:  => 1803:6
  + drivers/gpu/drm/i915/intel_display.c: warning: 'state_string' defined but not used [-Wunused-function]:  => 889:20
  + drivers/gpu/drm/i915/intel_display.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 3980:1
  + drivers/gpu/drm/i915/intel_drv.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 523:1
  + drivers/gpu/drm/i915/intel_pm.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 5042:1
  + drivers/gpu/drm/mgag200/mgag200_mode.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1434:2, 1431:2
  + drivers/gpu/drm/radeon/cik.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 852:10
  + drivers/gpu/drm/radeon/cik.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 845:2
  + drivers/gpu/drm/radeon/cypress_dpm.c: warning: unused variable 'eg_pi' [-Wunused-variable]:  => 302:31
  + drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 804:11
  + drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 795:3
  + drivers/gpu/drm/radeon/ni.c: warning: 'me_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 771:2
  + drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 759:2
  + drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 778:10
  + drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 782:2
  + drivers/gpu/drm/radeon/ni_dpm.c: warning: unused variable 'eg_pi' [-Wunused-variable]:  => 3428:31
  + drivers/gpu/drm/radeon/r600.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 2274:10
  + drivers/gpu/drm/radeon/r600.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 2297:10
  + drivers/gpu/drm/radeon/rv770_smc.c: warning: 'int_vect' may be used uninitialized in this function [-Wuninitialized]:  => 587:6
  + drivers/gpu/drm/radeon/rv770_smc.c: warning: 'ucode_size' may be used uninitialized in this function [-Wuninitialized]:  => 581:31
  + drivers/gpu/drm/radeon/si.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1673:10
  + drivers/gpu/drm/radeon/si.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1666:2
  + drivers/gpu/drm/radeon/si.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1651:10
  + drivers/gpu/drm/radeon/si.c: warning: 'smc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1677:2
  + drivers/gpu/drm/ttm/ttm_bo.c: warning: 'mem_type' may be used uninitialized in this function [-Wuninitialized]:  => 97:3
  + drivers/hwmon/dme1737.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 2766:6
  + drivers/ide/ide-floppy.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]: 296:2 => 296:2, 135:2
  + drivers/iio/adc/ti_am335x_adc.c: warning: unused variable 'cur' [-Wunused-variable]:  => 194:17
  + drivers/iio/adc/ti_am335x_adc.c: warning: unused variable 'prop' [-Wunused-variable]:  => 193:20
  + drivers/infiniband/core/cma.c: warning: 'port' may be used uninitialized in this function [-Wuninitialized]:  => 465:23
  + drivers/infiniband/hw/qib/qib_sdma.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat]:  => 752:3
  + drivers/input/keyboard/tca8418_keypad.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]:  => 172:9
  + drivers/input/touchscreen/cyttsp4_core.c: warning: 'cyttsp4_core_sleep' defined but not used [-Wunused-function]:  => 1555:12
  + drivers/input/touchscreen/cyttsp4_core.c: warning: 'cyttsp4_core_wake' defined but not used [-Wunused-function]:  => 1633:12
  + drivers/isdn/hisax/avm_a1p.c: warning: statement with no effect [-Wunused-value]:  => 84:2, 120:2
  + drivers/isdn/hisax/avm_pci.c: warning: statement with no effect [-Wunused-value]:  => 101:2
  + drivers/isdn/hisax/diva.c: warning: statement with no effect [-Wunused-value]:  => 95:2
  + drivers/isdn/hisax/elsa.c: warning: statement with no effect [-Wunused-value]:  => 155:2
  + drivers/isdn/hisax/gazel.c: warning: statement with no effect [-Wunused-value]:  => 91:2, 60:2
  + drivers/isdn/hisax/niccy.c: warning: statement with no effect [-Wunused-value]:  => 59:2
  + drivers/isdn/hisax/sedlbauer.c: warning: statement with no effect [-Wunused-value]:  => 133:2
  + drivers/isdn/hisax/teles3.c: warning: statement with no effect [-Wunused-value]:  => 44:2
  + drivers/leds/leds-mc13783.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]:  => 121:41, 197:47
  + drivers/leds/leds-mc13783.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]:  => 121:17, 197:23
  + drivers/leds/leds-mc13783.c: warning: 'shift' may be used uninitialized in this function [-Wuninitialized]:  => 198:22, 121:41, 197:47, 121:57
  + drivers/leds/leds-mc13783.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 121:57
  + drivers/media/platform/soc_camera/soc_camera.c: warning: 'sasd' may be used uninitialized in this function [-Wuninitialized]:  => 1513:10, 1514:55
  + drivers/media/usb/uvc/uvc_ctrl.c: warning: 'ctrl' may be used uninitialized in this function [-Wuninitialized]:  => 1972:6
  + drivers/media/v4l2-core/v4l2-async.c: warning: 'v4l2_async_notifier_unregister' uses dynamic stack allocation [enabled by default]:  => 232:1
  + drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6884:13
  + drivers/mfd/arizona-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 509:10
  + drivers/mfd/htc-pasic3.c: warning: unused variable 'asic' [-Wunused-variable]:  => 189:22
  + drivers/mfd/max8998.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 178:10
  + drivers/mfd/ti_am335x_tscadc.c: warning: unused variable 'cur' [-Wunused-variable]:  => 95:27
  + drivers/mfd/ti_am335x_tscadc.c: warning: unused variable 'prop' [-Wunused-variable]:  => 94:27
  + drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in this function [-Wuninitialized]: 384:2 => 384:2, 384:16
  + drivers/misc/lkdtm.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 276:1
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1408 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1797:1
  + drivers/mtd/devices/phram.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 262:8
  + drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 53:2
  + drivers/net/ethernet/chelsio/cxgb3/ael1002.c: warning: 'stat1' may be used uninitialized in this function [-Wuninitialized]:  => 850:30, 192:21
  + drivers/net/ethernet/chelsio/cxgb3/ael1002.c: warning: 'stat2' may be used uninitialized in this function [-Wuninitialized]:  => 850:46, 192:38
  + drivers/net/ethernet/chelsio/cxgb3/vsc8211.c: warning: 'adv' may be used uninitialized in this function [-Wuninitialized]:  => 186:4, 246:3
  + drivers/net/ethernet/chelsio/cxgb3/vsc8211.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 223:3, 147:3
  + drivers/net/ethernet/chelsio/cxgb4/sge.c: warning: 'buf_size' may be used uninitialized in this function [-Wuninitialized]:  => 472:18, 499:17, 1824:11
  + drivers/net/ethernet/emulex/benet/be_main.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 2905:3
  + drivers/net/ethernet/intel/e100.c: warning: array subscript is below array bounds [-Warray-bounds]:  => 804:2
  + drivers/net/ethernet/sfc/filter.c: warning: 'data3' may be used uninitialized in this function [-Wuninitialized]:  => 531:2
  + drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]:  => 641:2
  + drivers/net/wireless/b43/xmit.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]:  => 64:3, 88:3, 290:3, 283:3, 77:3
  + drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC      net/sched/sch_dsmark.o:  => 381:2
  + drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]:  => 381:2
  + drivers/net/wireless/cw1200/scan.c: warning: value computed is not used [-Wunused-value]:  => 330:2
  + drivers/net/wireless/cw1200/sta.c: warning: value computed is not used [-Wunused-value]:  => 142:2
  + drivers/net/wireless/cw1200/wsm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 380:6
  + drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]:  => 693:12
  + drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]:  => 724:13
  + drivers/power/da9052-battery.c: warning: 'chg_end_current' may be used uninitialized in this function [-Wuninitialized]:  => 266:4
  + drivers/power/lp8788-charger.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 501:6
  + drivers/power/sbs-battery.c: warning: 'gpio_flags' may be used uninitialized in this function [-Wuninitialized]:  => 662:6
  + drivers/regulator/lp872x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 910:33
  + drivers/regulator/s5m8767.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 211:29
  + drivers/scsi/fcoe/fcoe.c: warning: 'ctlr' may be used uninitialized in this function [-Wuninitialized]:  => 2052:15
  + drivers/scsi/hpsa.c: warning: 'asc' may be used uninitialized in this function [-Wuninitialized]:  => 1254:5
  + drivers/scsi/hpsa.c: warning: 'ascq' may be used uninitialized in this function [-Wuninitialized]:  => 1254:5
  + drivers/scsi/hpsa.c: warning: 'sense_key' may be used uninitialized in this function [-Wuninitialized]:  => 1262:4
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'cmd' may be used uninitialized in this function [-Wuninitialized]:  => 4899:11
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]:  => 4898:13
  + drivers/scsi/osst.h: warning: 'packed' attribute ignored for field of type 'u32' [-Wattributes]:  => 96:2
  + drivers/scsi/pm8001/pm80xx_hwi.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 891:3
  + drivers/spi/spi-bfin5xx.c: warning: 'cr_width' may be used uninitialized in this function [-Wuninitialized]:  => 698:6
  + drivers/spi/spi-gpio.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 446:2
  + drivers/spi/spi-pxa2xx.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1152:3
  + drivers/staging/rts5139/sd_cprm.c: warning: 'rsp_len' may be used uninitialized in this function [-Wuninitialized]:  => 260:7
  + drivers/staging/vt6655/iwctl.c: warning: the frame size of 1292 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 758:1
  + drivers/tty/serial/8250/8250_core.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1712:2, 1717:18 => 1712:2, 1714:18, 1717:18
  + drivers/tty/serial/8250/8250_core.c: warning: statement with no effect [-Wunused-value]: 2214:3 => 2214:3, 2190:3, 1233:3
  + drivers/usb/chipidea/core.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 246:3, 230:3, 226:3, 243:3
  + drivers/usb/gadget/net2272.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2466:2, 2466:5
  + drivers/usb/host/pci-quirks.h: warning: 'struct pci_dev' declared inside parameter list [enabled by default]:  => 19:50
  + drivers/usb/host/pci-quirks.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 19:50
  + drivers/usb/host/xhci.c: warning: 'xhci_change_max_exit_latency' defined but not used [-Wunused-function]:  => 3901:12
  + drivers/usb/host/xhci.c: warning: 'xhci_msix_sync_irqs' defined but not used [-Wunused-function]: 332:13 => 332:13, 398:13
  + drivers/video/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + drivers/video/goldfishfb.c: warning: 'fbpaddr' may be used uninitialized in this function [-Wuninitialized]:  => 256:24
  + drivers/video/intelfb/intelfbdrv.c: warning: passing argument 3 of 'get_opt_bool' from incompatible pointer type [enabled by default]:  => 361:3, 363:3, 367:8, 365:8, 361:8, 367:3, 357:3, 363:8, 365:3
  + drivers/video/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1186:23
  + drivers/video/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]:  => 64:2
  + drivers/video/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]:  => 65:2
  + drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]:  => 4131:13
  + drivers/video/uvesafb.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1563:20
  + drivers/video/vga16fb.c: warning: unused variable 'dev' [-Wunused-variable]:  => 1268:26
  + drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + drivers/video/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 732:23
  + drivers/video/xilinxfb.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'phys_addr_t' [-Wformat]:  => 344:3
  + drivers/vme/bridges/vme_ca91cx42.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 467:14
  + drivers/vme/bridges/vme_tsi148.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 744:14
  + drivers/watchdog/shwdt.c: warning: unused variable 'wdt' [-Wunused-variable]:  => 297:17
  + ecific data of fi/scratch/kisskb/src/arch/sh/math-emu/math.c: warning: right shift count is negative [enabled by default]l:  => 122:1
  + fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]: 3852:6 => 3918:2, 3919:6
  + fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1350:6 => 1356:6, 1208:6
  + fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]: 1271:20, 1474:6 => 1282:20, 1335:21, 1474:6
  + fs/cifs/connect.c: warning: 'ses' may be used uninitialized in this function [-Wuninitialized]:  => 3422:20
  + fs/cifs/connect.c: warning: 'tcon' may be used uninitialized in this function [-Wuninitialized]:  => 3420:17
  + fs/cifs/connect.c: warning: 'xid' may be used uninitialized in this function [-Wuninitialized]:  => 3424:3
  + fs/exofs/common.h: warning: 'packed' attribute ignored for field of type 'struct exofs_layout_implict_list' [-Wattributes]:  => 252:3
  + fs/exofs/common.h: warning: 'packed' attribute ignored for field of type 'struct exofs_layout_sliding_window' [-Wattributes]:  => 243:3
  + fs/ext4/inode.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 2219:3, 2219:6
  + fs/ext4/inode.c: warning: 'err' may be used uninitialized in this function:  => 2161
  + fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]:  => 625:1
  + fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]:  => 134:23
  + include/linux/err.h: warning: 'bg_bh' may be used uninitialized in this function [-Wuninitialized]:  => 34:9
  + include/linux/err.h: warning: 'mrt' may be used uninitialized in this function [-Wuninitialized]:  => 34:9
  + include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
  + kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 112:1
  + lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]:  => 658:14
  + lib/vsprintf.c: warning: 'resource_string.isra.10' uses dynamic stack allocation [enabled by default]:  => 667:1
  + mm/mmap.c: warning: 'rb_parent' may be used uninitialized in this function [-Wuninitialized]  CC      net/ipv4/ip_input.o:  => 634:15
  + mm/swapfile.c: warning: 'nr_extents' may be used uninitialized in this function [-Wuninitialized]:  => 2127:2
  + modpost: WARNING: modpost: Found 3 section mismatch(es).:  => N/A
  + net/9p/trans_rdma.c: warning: 'rdma_cancelled' defined but not used [-Wunused-function]:  => 594:12
  + net/core/sysctl_net_core.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 151:9
  + net/ipv4/ping.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]:  => 449:63, 544:42, 532:37
  + net/ipv4/ping.c: warning: 'family' may be used uninitialized in this function [-Wuninitialized]:  => 552:49, 449:17, 449:2
  + net/ipv4/ping.c: warning: 'icmph' may be used uninitialized in this function [-Wuninitialized]:  => 493:29, 486:48, 486:35, 486:2
  + net/ipv4/ping.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 505:3, 663:2, 450:29, 544:42, 489:2, 663:21
  + net/rxrpc/ar-connection.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 587:16
  + sound/drivers/serial-u16550.c: warning: statement with no effect [-Wunused-value]:  => 462:2, 307:2, 501:2, 463:2, 461:2
  + sound/usb/mixer_quirks.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1514:6
  + warning: "cause_of_death" [arch/cris/arch-v10/kernel/built-in] is COMMON symbol:  => N/A
  + warning: (ARM_GIC && ARM_NVIC && ARM_VIC && ORION_IRQCHIP && RENESAS_INTC_IRQPIN && RENESAS_IRQC && TB10X_IRQC && VERSATILE_FPGA_IRQ && REGMAP && PINCTRL_BAYTRAIL && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && MFD_MAX8998 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS):  => N/A
  + warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (DW_DMAC && DW_DMAC_PCI) selects DW_DMAC_CORE which has unmet direct dependencies (DMADEVICES && GENERIC_HARDIRQS):  => N/A
  + warning: (HWPOISON_INJECT && MEM_SOFT_DIRTY) selects PROC_PAGE_MONITOR which has unmet direct dependencies (PROC_FS && MMU):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_PSERIES && PM_SLEEP_SMP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV || PPC_85xx && !PPC_E500MC)):  => N/A
  + warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x1e0): Section mismatch in reference from the variable sercons to the function .init.text:console_setup():  => N/A
  + warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x218): Section mismatch in reference from the variable sercons0 to the function .init.text:console_setup():  => N/A
  + warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x250): Section mismatch in reference from the variable sercons1 to the function .init.text:console_setup():  => N/A
  + warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x288): Section mismatch in reference from the variable sercons2 to the function .init.text:console_setup():  => N/A
  + warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x2c0): Section mismatch in reference from the variable sercons3 to the function .init.text:console_setup():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x21a): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x222): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x282): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x28e): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text.unlikely+0x2da): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x16f90): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x16fd0): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x7348): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: arch/x86/built-in.o(.text.unlikely+0x435d): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed:  => N/A
  + warning: arch/x86/mm/built-in.o(.text.unlikely+0x1b84): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed:  => N/A
  + warning: drivers/built-in.o(.data+0x193210): Section mismatch in reference from the variable fotg210_driver to the function .init.text:fotg210_udc_probe():  => N/A
  + warning: drivers/built-in.o(.data+0x888): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0x928): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa84): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb8c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xbec): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xc4c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xcac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xe54): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x32cece): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/built-in.o(.text+0x32cede): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/net/ethernet/3com/3c59x.o(.data+0x44): Section mismatch in reference from the variable vortex_eisa_driver to the function .init.text:vortex_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/dec/tulip/de4x5.o(.data+0x38): Section mismatch in reference from the variable de4x5_eisa_driver to the function .init.text:de4x5_eisa_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x168): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x208): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x364): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x46c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x4cc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x52c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x734): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/usb/built-in.o(.data+0x1e1e4): Section mismatch in reference from the variable fotg210_driver to the function .init.text:usb_init():  => N/A
  + warning: drivers/usb/built-in.o(.data+0x35988): Section mismatch in reference from the variable fotg210_driver to the function .init.text:fotg210_udc_probe():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.data+0x1f5c): Section mismatch in reference from the variable fotg210_driver to the function .init.text:usb_udc_init():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.data+0x43c8): Section mismatch in reference from the variable fotg210_driver to the function .init.text:fotg210_udc_probe():  => N/A
  + warning: drivers/usb/gadget/fotg210-udc.o(.data+0x0): Section mismatch in reference from the variable fotg210_driver to the function .init.text:fotg210_udc_probe():  => N/A
  + warning: drivers/video/built-in.o(.text+0x29b716): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/video/built-in.o(.text+0x29b726): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: kernel/built-in.o(.data+0x16a6e4): Section mismatch in reference from the variable function_trace to the function .init.text:trace_selftest_startup_function():  => N/A
  + warning: kernel/trace/built-in.o(.data+0x15a4): Section mismatch in reference from the variable function_trace to the function .init.text:trace_selftest_startup_function():  => N/A
  + warning: mm/built-in.o(.meminit.text+0x1250): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.data+0x3fe68): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x3ff08): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40064): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x4016c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x401cc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4022c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4028c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x40434): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.meminit.text+0x1660): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x154ea3e): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0x154ea4e): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0xa4330): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text+0xa63f0): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text.unlikely+0x372): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x37a): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x3da): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x3e6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x432): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x43ca): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed:  => N/A
  + warning: vmlinux.o(.text.unlikely+0xc6): Section mismatch in reference from the function .prom_rtas_call() to the variable .init.data:dt_string_start:  => N/A
  + warning: vmlinux.o(.text.unlikely+0xce): Section mismatch in reference from the function .prom_rtas_call() to the variable .init.data:dt_string_start:  => N/A

162 improvements:
  - .config: warning: override: PCI_GOANY changes choice state: 522 => 
  - .config: warning: override: SLOB changes choice state: 159, 151 => 
  - .config: warning: override: SPARSEMEM_MANUAL changes choice state: 270 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'copy_registers' defined but not used [-Wunused-function]: 508:1 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'copy_registers_from_stack' declared 'static' but never defined [-Wunused-function]: 255:13 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'copy_registers_to_stack' declared 'static' but never defined [-Wunused-function]: 259:13 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'current_thread_c' defined but not used [-Wunused-variable]: 425:12 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'current_thread_g' defined but not used [-Wunused-variable]: 426:12 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'do_printk' defined but not used [-Wunused-variable]: 679:12 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'handle_exception' defined but not used [-Wunused-function]: 924:1 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'is_dyn_brkp' defined but not used [-Wunused-variable]: 442:22 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'reg_g' defined but not used [-Wunused-variable]: 430:18 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: 'write_stack_register' declared 'static' but never defined [-Wunused-function]: 267:12 => 
  - arch/cris/arch-v10/kernel/kgdb.c: warning: missing terminating " character [enabled by default]: 1359:1, 1273:6, 1457:1, 1370:6 => 
  - arch/m68k/include/asm/parport.h: warning: "insl" redefined [enabled by default]: 14:0 => 
  - arch/m68k/include/asm/parport.h: warning: "outsl" redefined [enabled by default]: 15:0 => 
  - arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning:   AS      arch/sh/kernel/head_32.o: 378 => 
  - arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence  CC      kernel/exit.o: 378 => 
  - arch/xtensa/kernel/pci.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'resource_size_t' [-Wformat]: 82:11 => 
  - arch/xtensa/kernel/pci.c: warning: unused variable 'i' [-Wunused-variable]: 177:22 => 
  - block/blk-throttle.c: warning: value computed is not used [-Wunused-value]: 1029:2, 1030:2, 839:2 => 
  - drivers/block/paride/ppc6lnx.c: warning: statement with no effect [-Wunused-value]: 522:4 => 
  - drivers/block/rbd.c: warning: 'pages' may be used uninitialized in this function [-Wuninitialized]: 2235:10 => 
  - drivers/block/rbd.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 1157:12 => 
  - drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function [-Wuninitialized]: 230:3 => 
  - drivers/dma/ioat/dma_v3.c: warning: 'dma_addr' may be used uninitialized in this function [-Wuninitialized]: 1710:17 => 
  - drivers/dma/of-dma.c: warning: 'nbcells' may be used uninitialized in this function [-Wuninitialized]: 83:15, 83:2 => 
  - drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]: 191:13 => 
  - drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]: 174:13 => 
  - drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c: warning: 'node' may be used uninitialized in this function [-Wuninitialized]: 411:15 => 
  - drivers/hid/hid-picolcd_debugfs.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 312:15 => 
  - drivers/input/keyboard/cros_ec_keyb.c: warning: 'cros_ec_keyb_clear_keyboard' defined but not used [-Wunused-function]: 210:13 => 
  - drivers/md/bcache/alloc.c: warning: 'bucket' may be used uninitialized in this function [-Wuninitialized]: 413:5 => 
  - drivers/md/dm-raid.c: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]: 452:4, 453:53 => 
  - drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 1099:3, 1390:3 => 
  - drivers/md/raid5.c: warning: 'target' may be used uninitialized in this function [-Wuninitialized]: 985:8, 981:2 => 981:2
  - drivers/media/dvb-frontends/mb86a20s.h: warning: 'mb86a20s_get_tuner_i2c_adapter' defined but not used [-Wunused-function]: 49:2 => 
  - drivers/media/firewire/firedtv-avc.c: warning: 'pos' may be used uninitialized in this function [-Wuninitialized]: 608:26 => 
  - drivers/mfd/da903x.c: warning: 'chip_id' may be used uninitialized in this function [-Wuninitialized]: 339:2, 262:2 => 
  - drivers/mfd/da903x.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 185:2, 229:2, 207:2 => 
  - drivers/misc/mei/pci-me.c: warning: 'mei_me_pci_resume' defined but not used [-Wunused-function]: 296:12 => 
  - drivers/misc/mei/pci-me.c: warning: 'mei_me_pci_suspend' defined but not used [-Wunused-function]: 276:12 => 
  - drivers/misc/vmw_vmci/vmci_context.h: warning: 'src_priv_flags' may be used uninitialized in this function [-Wuninitialized]: 131:14 => 
  - drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1797:1 => 
  - drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1884:7, 1510:9, 745:2, 1449:7, 1489:2, 1511:3 => 1884:7, 1510:9, 745:2, 1449:7
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1240 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 890:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1336 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 606:1 => 
  - drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20 => 
  - drivers/mtd/nand/r852.c: warning: 'r852_resume' defined but not used [-Wunused-function]: 1027:12 => 
  - drivers/mtd/nand/r852.c: warning: 'r852_suspend' defined but not used [-Wunused-function]: 1006:12 => 
  - drivers/net/ethernet/3com/3c59x.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 1033:10, 1328:18, 1031:9 => 
  - drivers/net/macvtap.c: warning: 'qlist[j]' may be used uninitialized in this function [-Wuninitialized]: 242:11 => 
  - drivers/net/macvtap.c: warning: control reaches end of non-void function [-Wreturn-type]: 104:1 => 
  - drivers/net/wireless/iwlwifi/mvm/nvm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 231:5 => 
  - drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning: unused variable 'event_data' [-Wunused-variable]: 5810:40 => 
  - drivers/spi/spi-pxa2xx.c: warning: 'pxa2xx_spi_resume' defined but not used [-Wunused-function]: 1332:12 => 
  - drivers/spi/spi-pxa2xx.c: warning: 'pxa2xx_spi_suspend' defined but not used [-Wunused-function]: 1317:12 => 
  - drivers/spi/spi-pxa2xx.c: warning: return makes pointer from integer without a cast [enabled by default]: 1094:3 => 
  - drivers/staging/android/binder.c: warning: 'cmd_name' may be used uninitialized in this function [-Wuninitialized]: 2238:5 => 
  - drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'smtcfb_pci_resume' defined but not used [-Wunused-function]: 967:12 => 
  - drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'smtcfb_pci_suspend' defined but not used [-Wunused-function]: 944:12 => 
  - drivers/tty/serial/ifx6x60.c: warning: 'cts' may be used uninitialized in this function [-Wuninitialized]: 678:26 => 
  - drivers/tty/serial/ifx6x60.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]: 680:19 => 
  - drivers/tty/serial/ifx6x60.c: warning: 'more' may be used uninitialized in this function [-Wuninitialized]: 715:5, 715:8 => 715:8
  - drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 598:32, 624:11, 568:10, 443:16 => 
  - drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_resume' defined but not used [-Wunused-function]: 596:12 => 
  - drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_suspend' defined but not used [-Wunused-function]: 572:12 => 
  - drivers/virtio/virtio_pci.c: warning: 'virtio_pci_freeze' defined but not used [-Wunused-function]: 769:12 => 
  - drivers/virtio/virtio_pci.c: warning: 'virtio_pci_restore' defined but not used [-Wunused-function]: 789:12 => 
  - fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function [-Wuninitialized]: 337:20 => 
  - fs/ocfs2/suballoc.c: warning: 'bg_bh' may be used uninitialized in this function [-Wuninitialized]: 737:2 => 
  - fs/xfs/./xfs_trace.h: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 6 has type 'xfs_fsblock_t' [-Wformat]: 622:1 => 
  - include/linux/err.h: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]: 39:17 => 
  - include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]: 628:13 => 
  - include/linux/rculist.h: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]: 65:16 => 
  - include/uapi/linux/swab.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 60:2 => 
  - ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]: 1767:26 => 
  - kernel/auditfilter.c: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]: 426:3 => 
  - kernel/rcutree.c: warning: array subscript is above array bounds [-Warray-bounds]: 3160:19 => 
  - lib/dynamic_debug.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]: 366:3 => 
  - lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]  CC      drivers/hid/hid-ezkey.o: 49:4 => 
  - lib/vsprintf.c: warning: 'resource_string.isra.9' uses dynamic stack allocation [enabled by default]: 667:1 => 
  - modpost: WARNING: modpost: Found 10 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 12 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 5 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 8 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 9 section mismatch(es).: N/A => 
  - net/wireless/nl80211.c: warning: 'wdev_id' may be used uninitialized in this function [-Wuninitialized]: 90:4 => 
  - sound/soc/codecs/max98090.c: warning: 'max98090_runtime_resume' defined but not used [-Wunused-function]: 2339:12 => 
  - sound/soc/codecs/max98090.c: warning: 'max98090_runtime_suspend' defined but not used [-Wunused-function]: 2350:12 => 
  - sound/soc/codecs/wm2000.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 543:6 => 
  - sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 3214:6 => 
  - warning: (ARM_GIC && ARM_VIC && RENESAS_INTC_IRQPIN && RENESAS_IRQC && VERSATILE_FPGA_IRQ && REGMAP && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS): N/A => 
  - warning: (DRM_RADEON && DRM_I915 && DRM_GMA500 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): N/A => 
  - warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD): N/A => 
  - warning: (IWLWIFI && IWLEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): N/A => 
  - warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || ARCH_WANT_FRAME_POINTERS): N/A => 
  - warning: (PPC_MPC512x && 440EPX) selects USB_EHCI_BIG_ENDIAN_DESC which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD): N/A => 
  - warning: (PPC_MPC512x && PPC_PS3 && PPC_CELLEB && 440EPX) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD): N/A => 
  - warning: (USB_FSL_USB2) selects USB_FSL_MPH_DR_OF which has unmet direct dependencies (USB_SUPPORT && USB): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x22fb2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33201: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x22fb2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33204: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x2301e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33201: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x2301e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33204: N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x1730c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb(): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x1734c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb(): N/A => 
  - warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x693c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb(): N/A => 
  - warning: drivers/built-in.o(.data+0x784): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0x824): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0x97c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xa80): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xae0): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xb40): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xbac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xd50): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/built-in.o(.text+0x32b1e2): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/built-in.o(.text+0x32b1f2): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x164): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x204): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x35c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x460): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x4c0): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x520): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x730): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/video/built-in.o(.text+0x29b6d6): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/video/built-in.o(.text+0x29b6e6): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: mm/built-in.o(.meminit.text+0x11ac): Section mismatch in reference from the function .free_area_init_core.isra.38() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.data+0x3fa84): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x3fb24): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x3fc7c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x3fd80): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x3fde0): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x3fe40): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x3feac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40050): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: vmlinux.o(.meminit.text+0x15bc): Section mismatch in reference from the function .free_area_init_core.isra.38() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.text+0x150db96): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: vmlinux.o(.text+0x150dba6): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: vmlinux.o(.text+0x1ad7a4): Section mismatch in reference from the function pwmchip_add() to the function .init.text:pcibios_fixup_bus(): N/A => 
  - warning: vmlinux.o(.text+0x1b18d8): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus(): N/A => 
  - warning: vmlinux.o(.text+0x2ec90): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x2ecd2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33201: N/A => 
  - warning: vmlinux.o(.text+0x2ed3e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33201: N/A => 
  - warning: vmlinux.o(.text+0x2edb0): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x2edf2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33204: N/A => 
  - warning: vmlinux.o(.text+0x2ee5e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33204: N/A => 
  - warning: vmlinux.o(.text+0x37238): Section mismatch in reference from the function .rtas_cpu_state_change_mask() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x37358): Section mismatch in reference from the function .rtas_cpu_state_change_mask() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x3eec): Section mismatch in reference from the function pgd_ctor() to the function .init.text:__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x4a2f): Section mismatch in reference from the function iss_net_setup() to the function .init.text:__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x58290): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x598bc): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x68610): Section mismatch in reference from the function .update_cpu_topology() to the function .cpuinit.text:.vdso_getcpu_init(): N/A => 
  - warning: vmlinux.o(.text+0x69c30): Section mismatch in reference from the function .update_cpu_topology() to the function .cpuinit.text:.vdso_getcpu_init(): N/A => 
  - warning: vmlinux.o(.text+0x9522): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:spinning_secondaries: N/A => 
  - warning: vmlinux.o(.text+0x97f8): Section mismatch in reference from the function .start_secondary_prolog() to the function .cpuinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x980c): Section mismatch in reference from the function .start_secondary_resume() to the function .cpuinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x9a3cc): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb(): N/A => 
  - warning: vmlinux.o(.text+0x9c50c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb(): N/A => 
  - warning: vmlinux.o(.text+0xa46a8): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0xa67e8): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
