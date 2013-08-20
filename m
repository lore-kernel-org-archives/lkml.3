Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000Ab3HTJVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:21:37 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:60450 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3HTJVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:21:33 -0400
Date: Tue, 20 Aug 2013 11:21:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.11-rc6
Message-ID: <alpine.DEB.2.02.1308201120400.26995@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.11-rc6[1] compared to v3.10[2].

Summarized:
  - build errors: +55/-52
  - build warnings: +179/-203

JFYI, when comparing v3.11-rc6 to v3.11-rc5[3], the summaries are:
  - build errors: +6/-9
  - build warnings: +50/-65

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.11-rc6.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/6556/ (all 120 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/6378/ (all 120 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/6532/ (all 120 configs)


*** ERRORS ***

55 regressions:
  + arch/powerpc/kvm/book3s_xics.c: error: implicit declaration of function 'get_tb' [-Werror=implicit-function-declaration]:  => 812:3
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
  + drivers/dma/timb_dma.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 130:2
  + drivers/dma/timb_dma.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 134:2
  + drivers/gpu/drm/drm_bufs.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]:  => 219:5
  + drivers/gpu/drm/drm_memory.c: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]:  => 129:3
  + drivers/ipack/devices/ipoctal.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 134:3
  + drivers/ipack/devices/ipoctal.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]:  => 68:2
  + drivers/ipack/ipack.c: error: implicit declaration of function 'ioread16be' [-Werror=implicit-function-declaration]:  => 376:3
  + drivers/ipack/ipack.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]:  => 358:2
  + drivers/md/dm-cache-policy-mq.c: error: conflicting types for 'remove_mapping':  => 962:13
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
  + error: No rule to make target /etc/sound/dsp001.ld:  => N/A
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_unlock' defined in .spinlock.text section in kernel/built-in.o:  => (.text+0x1ffaf20), (.text+0x1ffaec4)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.kfree' defined in .text section in mm/built-in.o:  => (.text+0x1ff97a0), (.text+0x1ff9690)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.net_ratelimit' defined in .text section in net/built-in.o:  => (.text+0x1ffa164)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffafc4)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_23' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffafcc)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa480)
  + error: hostap_plx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa7ac), (.text+0x1ffa9c4)
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

179 regressions:
  + arch/cris/include/arch-v10/arch/swab.h: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]:  => 24:2
  + arch/powerpc/include/asm/mmu-hash64.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 180:1
  + arch/sh/include/uapi/asm/swab.h: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]:  => 32:2
  + arch/sparc/include/asm/cacheflush_32.h: warning: 'struct page' declared inside parameter list [enabled by default]:  => 39:44
  + arch/sparc/include/asm/cacheflush_32.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 39:44
  + drivers/bcma/sprom.c: warning: 'sprom' may be used uninitialized in this function [-Wuninitialized]:  => 614:8
  + drivers/gpu/drm/drm_bufs.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 219:17
  + drivers/gpu/drm/drm_memory.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 129:15
  + drivers/gpu/drm/i915/i915_irq.c: warning: 'score' may be used uninitialized in this function [-Wuninitialized]:  => 2509:27
  + drivers/gpu/drm/mgag200/mgag200_mode.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1473:2, 1476:2
  + drivers/gpu/drm/radeon/cik.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 856:11
  + drivers/gpu/drm/radeon/cik.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 836:5
  + drivers/gpu/drm/radeon/cypress_dpm.c: warning: unused variable 'eg_pi' [-Wunused-variable]:  => 302:31
  + drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 795:11
  + drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 786:6
  + drivers/gpu/drm/radeon/ni.c: warning: 'me_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 762:5
  + drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 750:5
  + drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 769:10
  + drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 773:5
  + drivers/gpu/drm/radeon/ni_dpm.c: warning: unused variable 'eg_pi' [-Wunused-variable]:  => 3423:31
  + drivers/gpu/drm/radeon/rv770_smc.c: warning: 'int_vect' may be used uninitialized in this function [-Wuninitialized]:  => 476:12
  + drivers/gpu/drm/radeon/rv770_smc.c: warning: 'ucode_size' may be used uninitialized in this function [-Wuninitialized]:  => 581:6
  + drivers/gpu/drm/radeon/si.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1664:10
  + drivers/gpu/drm/radeon/si.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1657:5
  + drivers/gpu/drm/radeon/si.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1642:10
  + drivers/gpu/drm/radeon/si.c: warning: 'smc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1672:12
  + drivers/gpu/drm/radeon/si_smc.c: warning: 'ucode_size' may be used uninitialized in this function [-Wuninitialized]:  => 253:14
  + drivers/hwmon/dme1737.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 2766:6
  + drivers/i2c/busses/i2c-mpc.c: warning: 'mpc_i2c_resume' defined but not used [-Wunused-function]:  => 734:12
  + drivers/i2c/busses/i2c-mpc.c: warning: 'mpc_i2c_suspend' defined but not used [-Wunused-function]:  => 724:12
  + drivers/idle/i7300_idle.c: warning: 'got_ctl' may be used uninitialized in this function [-Wuninitialized]:  => 423:2
  + drivers/iio/adc/ti_am335x_adc.c: warning: unused variable 'cur' [-Wunused-variable]:  => 209:17
  + drivers/iio/adc/ti_am335x_adc.c: warning: unused variable 'prop' [-Wunused-variable]:  => 208:20
  + drivers/input/touchscreen/cy8ctmg110_ts.c: warning: 'cy8ctmg110_resume' defined but not used [-Wunused-function]:  => 309:12
  + drivers/input/touchscreen/cy8ctmg110_ts.c: warning: 'cy8ctmg110_suspend' defined but not used [-Wunused-function]:  => 295:12
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
  + drivers/leds/leds-mc13783.c: warning: 'shift' may be used uninitialized in this function [-Wuninitialized]:  => 198:22, 121:57
  + drivers/leds/leds-mc13783.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 121:57
  + drivers/md/bcache/btree.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' [-Wformat]:  => 259:8
  + drivers/media/pci/saa7164/saa7164-encoder.c: warning: 'tsport' may be used uninitialized in this function [-Wuninitialized]:  => 387:5
  + drivers/media/pci/saa7164/saa7164-vbi.c: warning: 'tsport' may be used uninitialized in this function [-Wuninitialized]:  => 359:5
  + drivers/media/platform/soc_camera/soc_camera.c: warning: 'sasd' may be used uninitialized in this function [-Wuninitialized]:  => 1513:10, 1514:55
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
  + drivers/net/ethernet/chelsio/cxgb3/sge.c: warning: passing argument 4 of 'make_sgl' makes integer from pointer without a cast [enabled by default]:  => 1603:9
  + drivers/net/ethernet/chelsio/cxgb4/sge.c: warning: 'buf_size' may be used uninitialized in this function [-Wuninitialized]:  => 472:18, 499:17, 1824:11
  + drivers/net/usb/hso.c: warning: format '%d' expects argument of type 'int', but argument 4 has type 'tcflag_t' [-Wformat]:  => 1425:3
  + drivers/net/usb/hso.c: warning: format '%d' expects argument of type 'int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 1425:3
  + drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]:  => 641:2
  + drivers/net/wireless/b43/xmit.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]:  => 64:3, 88:3, 290:3, 283:3, 77:3
  + drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]:  => 381:2
  + drivers/net/wireless/cw1200/scan.c: warning: value computed is not used [-Wunused-value]:  => 330:2
  + drivers/net/wireless/cw1200/sta.c: warning: value computed is not used [-Wunused-value]:  => 142:2
  + drivers/net/wireless/cw1200/wsm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 380:6
  + drivers/regulator/lp872x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 910:33
  + drivers/scsi/aic7xxx_old.c: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]  CC [M]  drivers/video/uvesafb.o:  => 7898:5
  + drivers/scsi/osst.h: warning: 'packed' attribute ignored for field of type 'u32' [-Wattributes]:  => 96:2
  + drivers/spi/spi-bfin5xx.c: warning: 'cr_width' may be used uninitialized in this function [-Wuninitialized]:  => 698:6
  + drivers/spi/spi-gpio.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 446:2
  + drivers/spi/spi-pxa2xx.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1152:3
  + drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]:  => 2270:7
  + drivers/tty/serial/8250/8250_core.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1712:2, 1717:18 => 1712:2, 1714:18, 1717:18
  + drivers/tty/serial/8250/8250_core.c: warning: statement with no effect [-Wunused-value]: 2214:3 => 2214:3, 2190:3, 1233:3
  + drivers/tty/serial/sunzilog.c: warning: 'sunzilog_putchar' defined but not used [-Wunused-function]:  => 1121:13
  + drivers/usb/serial/cp210x.c: warning: passing argument 2 of 'cp210x_get_termios_port' from incompatible pointer type [enabled by default]:  => 485:4
  + drivers/usb/serial/io_edgeport.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 1467:2, 1468:2
  + drivers/usb/serial/io_edgeport.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'tcflag_t' [-Wformat]:  => 1467:2, 1468:2
  + drivers/usb/serial/io_ti.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 2283:2, 2281:2
  + drivers/usb/serial/io_ti.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'tcflag_t' [-Wformat]:  => 2283:2, 2281:2
  + drivers/usb/serial/mos7720.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 1711:2, 1708:2
  + drivers/usb/serial/mos7720.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'long unsigned int' [-Wformat]:  => 1711:2, 1708:2
  + drivers/usb/serial/mos7840.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 2015:2, 2013:2
  + drivers/usb/serial/mos7840.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'long unsigned int' [-Wformat]:  => 2015:2, 2013:2
  + drivers/usb/serial/ti_usb_3410_5052.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 787:2, 786:2
  + drivers/usb/serial/ti_usb_3410_5052.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'tcflag_t' [-Wformat]:  => 787:2, 786:2
  + drivers/video/goldfishfb.c: warning: 'fbpaddr' may be used uninitialized in this function [-Wuninitialized]:  => 256:24
  + drivers/video/uvesafb.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1563:20
  + drivers/watchdog/shwdt.c: warning: unused variable 'wdt' [-Wunused-variable]:  => 297:17
  + fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]:  => 58:13
  + fs/exofs/common.h: warning: 'packed' attribute ignored for field of type 'struct exofs_layout_implict_list' [-Wattributes]:  => 252:3
  + fs/exofs/common.h: warning: 'packed' attribute ignored for field of type 'struct exofs_layout_sliding_window' [-Wattributes]:  => 243:3
  + fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]:  => 625:1
  + fs/mpage.c: warning: the frame size of 1104 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 320:1
  + fs/mpage.c: warning: the frame size of 1144 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + include/net/ipv6.h: warning: '*((void *)&addr+8)' may be used uninitialized in this function [-Wuninitialized]:  => 414:38
  + kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]:  => 334:12
  + kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]:  => 270:13
  + kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]:  => 247:13
  + kernel/seccomp.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 455:15
  + kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 112:1
  + lib/vsprintf.c: warning: 'resource_string.isra.10' uses dynamic stack allocation [enabled by default]:  => 667:1
  + modpost: WARNING: modpost: Found 3 section mismatch(es).:  => N/A
  + net/9p/trans_rdma.c: warning: 'rdma_cancelled' defined but not used [-Wunused-function]:  => 594:12
  + net/core/sysctl_net_core.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 153:9
  + net/ipv4/ping.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]:  => 449:63, 532:37
  + net/ipv4/ping.c: warning: 'family' may be used uninitialized in this function [-Wuninitialized]:  => 552:49, 449:17, 449:2
  + net/ipv4/ping.c: warning: 'icmph' may be used uninitialized in this function [-Wuninitialized]:  => 493:29, 486:48, 486:35
  + net/ipv4/ping.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 505:3, 450:29, 544:42, 489:2, 663:21
  + net/rxrpc/ar-connection.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 587:16
  + net/xfrm/xfrm_policy.c: warning: 'xfrm_dst_ops' may be used uninitialized in this function [-Wuninitialized]  CC      drivers/net/ethernet/marvell/sky2.o:  => 2731:17
  + sound/drivers/serial-u16550.c: warning: statement with no effect [-Wunused-value]:  => 462:2, 307:2, 501:2, 463:2, 461:2
  + sound/usb/mixer_quirks.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1514:6
  + warning: "cause_of_death" [arch/cris/arch-v10/kernel/built-in] is COMMON symbol:  => N/A
  + warning: (ARM_GIC && ARM_NVIC && ARM_VIC && ORION_IRQCHIP && RENESAS_INTC_IRQPIN && RENESAS_IRQC && TB10X_IRQC && VERSATILE_FPGA_IRQ && REGMAP && PINCTRL_BAYTRAIL && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && MFD_MAX8998 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS):  => N/A
  + warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (DW_DMAC && DW_DMAC_PCI) selects DW_DMAC_CORE which has unmet direct dependencies (DMADEVICES && GENERIC_HARDIRQS):  => N/A
  + warning: (HWPOISON_INJECT && MEM_SOFT_DIRTY) selects PROC_PAGE_MONITOR which has unmet direct dependencies (PROC_FS && MMU):  => N/A
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
  + warning: arch/x86/built-in.o(.text.unlikely+0x435d): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed:  => N/A
  + warning: arch/x86/mm/built-in.o(.text.unlikely+0x1b84): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed:  => N/A
  + warning: drivers/built-in.o(.data+0x988): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa28): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb84): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc8c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xcec): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xd4c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xf54): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x32d03a): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/built-in.o(.text+0x32d04a): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/net/ethernet/3com/3c59x.o(.data+0x44): Section mismatch in reference from the variable vortex_eisa_driver to the function .init.text:vortex_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/dec/tulip/de4x5.o(.data+0x38): Section mismatch in reference from the variable de4x5_eisa_driver to the function .init.text:de4x5_eisa_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x168): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x208): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x364): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x46c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x4cc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x52c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x734): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/video/built-in.o(.text+0x29b722): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/video/built-in.o(.text+0x29b732): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: mm/built-in.o(.meminit.text+0x1250): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.data+0x3ff68): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x40008): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40164): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x4026c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x402cc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4032c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4038c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x40534): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.meminit.text+0x1660): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x154e5aa): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0x154e5ba): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x372): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x37a): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x3da): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x3e6): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x432): Section mismatch in reference from the function .free_lppacas() to the variable .init.data:lppaca_size:  => N/A
  + warning: vmlinux.o(.text.unlikely+0x43ca): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed:  => N/A
  + warning: vmlinux.o(.text.unlikely+0xc6): Section mismatch in reference from the function .prom_rtas_call() to the variable .init.data:dt_string_start:  => N/A
  + warning: vmlinux.o(.text.unlikely+0xce): Section mismatch in reference from the function .prom_rtas_call() to the variable .init.data:dt_string_start:  => N/A

203 improvements:
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
  - arch/x86/kernel/cpu/perf_event.c: warning: 'reg_fail' may be used uninitialized in this function [-Wuninitialized]: 236:9 => 
  - arch/x86/kernel/cpu/perf_event.c: warning: 'val_fail' may be used uninitialized in this function [-Wuninitialized]: 236:9 => 
  - arch/xtensa/kernel/pci.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'resource_size_t' [-Wformat]: 82:11 => 
  - arch/xtensa/kernel/pci.c: warning: unused variable 'i' [-Wunused-variable]: 177:22 => 
  - block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]: 65:2 => 
  - block/blk-throttle.c: warning: value computed is not used [-Wunused-value]: 1029:2, 1030:2, 839:2 => 
  - drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 1755:9, 1497:6 => 
  - drivers/block/paride/ppc6lnx.c: warning: statement with no effect [-Wunused-value]: 522:4 => 
  - drivers/block/rbd.c: warning: 'pages' may be used uninitialized in this function [-Wuninitialized]: 2235:10 => 
  - drivers/block/rbd.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 1157:12 => 
  - drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function [-Wuninitialized]: 230:3 => 
  - drivers/dma/ioat/dma_v3.c: warning: 'dma_addr' may be used uninitialized in this function [-Wuninitialized]: 1710:17 => 
  - drivers/dma/of-dma.c: warning: 'nbcells' may be used uninitialized in this function [-Wuninitialized]: 83:15, 83:2 => 
  - drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]: 244:17 => 
  - drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]: 191:13 => 
  - drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]: 174:13 => 
  - drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]: 467:4 => 
  - drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c: warning: 'node' may be used uninitialized in this function [-Wuninitialized]: 411:15 => 
  - drivers/hid/hid-picolcd_debugfs.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 312:10 => 
  - drivers/hid/hid-picolcd_debugfs.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 312:15 => 
  - drivers/infiniband/hw/nes/nes_hw.c: warning: 'nes_iwarp_state_str' defined but not used [-Wunused-variable]: 81:23 => 
  - drivers/infiniband/hw/nes/nes_hw.c: warning: 'nes_tcp_state_str' defined but not used [-Wunused-variable]: 92:23 => 
  - drivers/input/keyboard/cros_ec_keyb.c: warning: 'cros_ec_keyb_clear_keyboard' defined but not used [-Wunused-function]: 210:13 => 
  - drivers/leds/leds-ot200.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 112:8, 114:6 => 112:8
  - drivers/md/bcache/alloc.c: warning: 'bucket' may be used uninitialized in this function [-Wuninitialized]: 413:5 => 
  - drivers/md/bcache/sysfs.c: warning: '__bch_cache_show' uses dynamic stack allocation [enabled by default]: 730:1 => 
  - drivers/md/dm-raid.c: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]: 452:4, 453:53 => 
  - drivers/md/raid5.c: warning: 'target' may be used uninitialized in this function [-Wuninitialized]: 985:8, 981:2 => 981:2
  - drivers/media/dvb-frontends/mb86a20s.h: warning: 'mb86a20s_get_tuner_i2c_adapter' defined but not used [-Wunused-function]: 49:2 => 
  - drivers/media/firewire/firedtv-avc.c: warning: 'pos' may be used uninitialized in this function [-Wuninitialized]: 608:26 => 
  - drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]: 1106:1 => 
  - drivers/mfd/da903x.c: warning: 'chip_id' may be used uninitialized in this function [-Wuninitialized]: 339:2, 262:2 => 
  - drivers/mfd/da903x.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 185:2, 229:2, 207:2 => 
  - drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 233:2, 233:5 => 272:5
  - drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]: 344:3 => 
  - drivers/misc/hpilo.c: warning: 'devnum' may be used uninitialized in this function [-Wuninitialized]: 847:20 => 
  - drivers/misc/mei/pci-me.c: warning: 'mei_me_pci_resume' defined but not used [-Wunused-function]: 296:12 => 
  - drivers/misc/mei/pci-me.c: warning: 'mei_me_pci_suspend' defined but not used [-Wunused-function]: 276:12 => 
  - drivers/misc/vmw_vmci/vmci_context.h: warning: 'src_priv_flags' may be used uninitialized in this function [-Wuninitialized]: 131:14 => 
  - drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1797:1 => 
  - drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1884:7, 1510:9, 745:2, 1449:7, 1489:2, 1511:3 => 1884:7, 1510:9, 745:2, 1449:7
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1240 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 890:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1336 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 606:1 => 
  - drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20 => 
  - drivers/mtd/sm_ftl.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]: 1094:2 => 
  - drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 407:9 => 
  - drivers/net/ethernet/3com/3c59x.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 1033:10, 1328:18, 1031:9 => 
  - drivers/net/macvtap.c: warning: 'qlist[j]' may be used uninitialized in this function [-Wuninitialized]: 242:11 => 
  - drivers/net/macvtap.c: warning: control reaches end of non-void function [-Wreturn-type]: 104:1 => 
  - drivers/net/wireless/iwlwifi/mvm/nvm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 231:5 => 
  - drivers/net/wireless/libertas/if_spi.c: warning: 'hiStatus' may be used uninitialized in this function [-Wuninitialized]: 887:2 => 
  - drivers/net/wireless/libertas/if_spi.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]: 731:20, 781:55, 575:7 => 
  - drivers/net/wireless/libertas/if_spi.c: warning: 'rval' may be used uninitialized in this function [-Wuninitialized]: 410:2 => 
  - drivers/net/wireless/libertas/if_spi.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 304:4 => 
  - drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]: 213:17, 184:21, 200:21, 160:21, 144:20, 172:12, 115:16 => 
  - drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]: 133:2 => 
  - drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning: unused variable 'event_data' [-Wunused-variable]: 5810:40 => 
  - drivers/spi/spi-pxa2xx.c: warning: 'pxa2xx_spi_resume' defined but not used [-Wunused-function]: 1332:12 => 
  - drivers/spi/spi-pxa2xx.c: warning: 'pxa2xx_spi_suspend' defined but not used [-Wunused-function]: 1317:12 => 
  - drivers/spi/spi-pxa2xx.c: warning: return makes pointer from integer without a cast [enabled by default]: 1094:3 => 
  - drivers/staging/android/binder.c: warning: 'cmd_name' may be used uninitialized in this function [-Wuninitialized]: 2238:5 => 
  - drivers/staging/wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_off' which is not static [enabled by default]: 1036:2 => 
  - drivers/staging/wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_on' which is not static [enabled by default]: 1024:2 => 
  - drivers/staging/wlags49_h25/../wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_off' which is not static [enabled by default]: 1036:2 => 
  - drivers/staging/wlags49_h25/../wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_on' which is not static [enabled by default]: 1024:2 => 
  - drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]: 612:18 => 
  - drivers/tty/serial/ifx6x60.c: warning: 'cts' may be used uninitialized in this function [-Wuninitialized]: 678:26 => 
  - drivers/tty/serial/ifx6x60.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]: 680:19 => 
  - drivers/tty/serial/ifx6x60.c: warning: 'more' may be used uninitialized in this function [-Wuninitialized]: 715:5, 715:8 => 715:8
  - drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 266:6, 342:9 => 
  - drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 598:32, 624:11, 568:10, 443:16 => 
  - drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 809:11, 563:16, 783:32 => 809:11
  - drivers/video/backlight/max8925_bl.c: warning: statement with no effect [-Wunused-value]: 177:3 => 
  - drivers/virtio/virtio_pci.c: warning: 'virtio_pci_freeze' defined but not used [-Wunused-function]: 769:12 => 
  - drivers/virtio/virtio_pci.c: warning: 'virtio_pci_restore' defined but not used [-Wunused-function]: 789:12 => 
  - fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]: 1387:23 => 
  - fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]: 1383:38 => 
  - fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]: 1388:18 => 
  - fs/ext4/inode.c: warning: 'retval' may be used uninitialized in this function [-Wuninitialized]: 640:2, 640:5 => 581:5
  - fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function [-Wuninitialized]: 337:20 => 
  - fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]: 1663:17 => 
  - fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]: 909:21, 664:17 => 
  - fs/ocfs2/suballoc.c: warning: 'bg_bh' may be used uninitialized in this function [-Wuninitialized]: 737:2 => 
  - fs/ocfs2/xattr.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 2979:2 => 
  - fs/xfs/./xfs_trace.h: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 6 has type 'xfs_fsblock_t' [-Wformat]: 622:1 => 
  - include/linux/err.h: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]: 39:17 => 
  - include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]: 628:13 => 
  - include/linux/rculist.h: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]: 65:16 => 
  - include/uapi/linux/swab.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 60:2 => 
  - ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]: 1767:26 => 
  - kernel/auditfilter.c: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]: 426:3 => 
  - kernel/rcutree.c: warning: array subscript is above array bounds [-Warray-bounds]: 3160:19 => 
  - kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]: 2558:8 => 
  - lib/dynamic_debug.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]: 366:3 => 
  - lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]: 70:2, 73:2 => 
  - lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]  CC      drivers/hid/hid-ezkey.o: 49:4 => 
  - lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]: 45:2, 49:4, 56:2 => 
  - lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]: 113:2, 116:2 => 
  - lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]: 92:4, 99:2, 88:2 => 
  - lib/vsprintf.c: warning: 'resource_string.isra.9' uses dynamic stack allocation [enabled by default]: 667:1 => 
  - mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]: 735:15 => 
  - modpost: WARNING: modpost: Found 10 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 12 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 5 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 8 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 9 section mismatch(es).: N/A => 
  - net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]: 218:2 => 
  - net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]: 656:16 => 
  - net/wireless/nl80211.c: warning: 'wdev_id' may be used uninitialized in this function [-Wuninitialized]: 90:4 => 
  - sound/soc/codecs/max98090.c: warning: 'max98090_runtime_resume' defined but not used [-Wunused-function]: 2339:12 => 
  - sound/soc/codecs/max98090.c: warning: 'max98090_runtime_suspend' defined but not used [-Wunused-function]: 2350:12 => 
  - sound/soc/codecs/wm2000.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 543:6 => 
  - sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 3214:6 => 
  - warning: (ARM_GIC && ARM_VIC && RENESAS_INTC_IRQPIN && RENESAS_IRQC && VERSATILE_FPGA_IRQ && REGMAP && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS): N/A => 
  - warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER): N/A => 
  - warning: (DRM_RADEON && DRM_I915 && DRM_GMA500 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): N/A => 
  - warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && MOUSE_SYNAPTICS_USB && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD): N/A => 
  - warning: (IWLWIFI && IWLEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): N/A => 
  - warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || ARCH_WANT_FRAME_POINTERS): N/A => 
  - warning: (PPC_MPC512x && 440EPX) selects USB_EHCI_BIG_ENDIAN_DESC which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD): N/A => 
  - warning: (PPC_MPC512x && PPC_PS3 && PPC_CELLEB && 440EPX) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD): N/A => 
  - warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet direct dependencies (HAVE_KVM): N/A => 
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
