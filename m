Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781Ab3BIR3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 12:29:41 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:48468 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab3BIR3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 12:29:36 -0500
Date: Sat, 9 Feb 2013 18:29:33 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.8-rc7
Message-ID: <alpine.DEB.2.00.1302091829160.19791@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.8-rc7[1] compared to v3.7[2].

To make this mail fit in the lkml limit, I deleted
  - 3996 lines about __mcount_loc warning improvements on sparc64

Summarized:
  - build errors: +70/-39
  - build warnings: +355/-4189

JFYI, when comparing v3.8-rc7 to v3.8-rc6[3], the summaries are:
  - build errors: +7/-8
  - build warnings: +35/-21

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.8-rc7.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/5870/ (all 117 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/5700/ (all 117 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/5846/ (all 117 configs)


*** ERRORS ***

70 regressions:
  + arch/parisc/hpux/fs.c: error: too many arguments to function 'do_execve':  => 47:6
  + drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'handle_nested_irq' [-Werror=implicit-function-declaration]:  => 209:4
  + drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_alloc_descs' [-Werror=implicit-function-declaration]:  => 281:3
  + drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_data_get_irq_chip_data' [-Werror=implicit-function-declaration]:  => 54:9
  + drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_chip' [-Werror=implicit-function-declaration]:  => 229:2
  + drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_chip_data' [-Werror=implicit-function-declaration]:  => 228:2
  + drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_irq_wake' [-Werror=implicit-function-declaration]:  => 98:4
  + drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_nested_thread' [-Werror=implicit-function-declaration]:  => 230:2
  + drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_noprobe' [-Werror=implicit-function-declaration]:  => 237:2
  + drivers/firewire/ohci.c: error: 'pci_probe' redeclared as different kind of symbol:  => 3540:12
  + drivers/gpu/drm/ast/ast_mode.c: error: conflicting types for 'get_clock':  => 871:12
  + drivers/gpu/drm/ast/ast_mode.c: error: conflicting types for 'set_clock':  => 891:13
  + drivers/gpu/drm/radeon/radeon_i2c.c: error: conflicting types for 'get_clock':  => 176:12
  + drivers/gpu/drm/radeon/radeon_i2c.c: error: conflicting types for 'set_clock':  => 205:13
  + drivers/gpu/drm/udl/udl_fb.c: error: 'PAGE_SHARED' undeclared (first use in this function):  => 237:52
  + drivers/input/serio/arc_ps2.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 55:3
  + drivers/input/serio/arc_ps2.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 99:4
  + drivers/media/pci/zoran/zoran_driver.c: error: 'PAGE_SHARED' undeclared (first use in this function):  => 2955:14
  + drivers/media/usb/cpia2/cpia2_core.c: error: 'PAGE_SHARED' undeclared (first use in this function):  => 2405:66
  + drivers/mfd/arizona-irq.c: error: 'handle_edge_irq' undeclared (first use in this function):  => 147:52
  + drivers/mfd/arizona-irq.c: error: implicit declaration of function 'handle_nested_irq' [-Werror=implicit-function-declaration]:  => 107:2
  + drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_chip_and_handler' [-Werror=implicit-function-declaration]:  => 147:2
  + drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_chip_data' [-Werror=implicit-function-declaration]:  => 146:2
  + drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_irq_wake' [-Werror=implicit-function-declaration]:  => 68:2
  + drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_nested_thread' [-Werror=implicit-function-declaration]:  => 148:2
  + drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_noprobe' [-Werror=implicit-function-declaration]:  => 155:2
  + drivers/mfd/lp8788-irq.c: error: 'handle_edge_irq' undeclared (first use in this function):  => 140:39
  + drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'handle_nested_irq' [-Werror=implicit-function-declaration]:  => 125:4
  + drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_data_get_irq_chip_data' [-Werror=implicit-function-declaration]:  => 68:9
  + drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_set_chip_and_handler' [-Werror=implicit-function-declaration]:  => 140:2
  + drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_set_chip_data' [-Werror=implicit-function-declaration]:  => 139:2
  + drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_set_nested_thread' [-Werror=implicit-function-declaration]:  => 141:2
  + drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_set_noprobe' [-Werror=implicit-function-declaration]:  => 146:2
  + drivers/mtd/nand/denali.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 116:2
  + drivers/mtd/nand/denali.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 107:2
  + drivers/scsi/lpfc/lpfc_sli.c: error: called object 'mb' is not a function:  => 6854:2
  + drivers/tty/serial/serial_core.c: error: implicit declaration of function 'irq_canonicalize' [-Werror=implicit-function-declaration]:  => 724:2
  + drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'irq_set_irq_type' [-Werror=implicit-function-declaration]:  => 1405:3
  + drivers/usb/host/oxu210hp-hcd.c: error: implicit declaration of function 'irq_set_irq_type' [-Werror=implicit-function-declaration]:  => 3839:2
  + drivers/usb/musb/musb_core.c: error: implicit declaration of function 'ioread16_rep' [-Werror=implicit-function-declaration]:  => 306:5
  + drivers/usb/musb/musb_core.c: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]:  => 297:5
  + drivers/usb/musb/musb_core.c: error: implicit declaration of function 'ioread8_rep' [-Werror=implicit-function-declaration]:  => 314:3
  + drivers/usb/musb/musb_core.c: error: implicit declaration of function 'iowrite16_rep' [-Werror=implicit-function-declaration]:  => 263:5
  + drivers/usb/musb/musb_core.c: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]:  => 254:5
  + drivers/usb/musb/musb_core.c: error: implicit declaration of function 'iowrite8_rep' [-Werror=implicit-function-declaration]:  => 271:3
  + drivers/usb/musb/tusb6010.c: error: implicit declaration of function 'ioread32_rep' [-Werror=implicit-function-declaration]:  => 249:5
  + drivers/usb/musb/tusb6010.c: error: implicit declaration of function 'iowrite32_rep' [-Werror=implicit-function-declaration]:  => 202:5
  + drivers/usb/musb/tusb6010.c: error: implicit declaration of function 'irq_set_irq_type' [-Werror=implicit-function-declaration]:  => 923:2
  + drivers/usb/phy/rcar-phy.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 83:4
  + drivers/usb/phy/rcar-phy.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 75:3
  + drivers/video/smscufx.c: error: 'PAGE_SHARED' undeclared (first use in this function):  => 795:52
  + drivers/video/udlfb.c: error: 'PAGE_SHARED' undeclared (first use in this function):  => 337:52
  + drivers/video/vfb.c: error: 'PAGE_SHARED' undeclared (first use in this function):  => 431:52
  + error: "max_low_pfn" [drivers/block/aoe/aoe.ko] undefined!:  => N/A
  + error: "min_low_pfn" [drivers/block/aoe/aoe.ko] undefined!:  => N/A
  + error: 4965-calib.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff7fe0), (.text+0x1ff7e2c)
  + error: 4965-debug.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9484)
  + error: 4965-debug.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9330)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.kfree' defined in .text section in mm/built-in.o:  => (.text+0x1ffa3c4)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_16' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8908)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8270)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_22' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9a8c), (.text+0x1ff948c)
  + error: tpm_ibmvtpm.c: undefined reference to `.__vio_register_driver':  => .init.text+0x5554)
  + error: tpm_ibmvtpm.c: undefined reference to `.plpar_hcall_norets':  => .text+0xd7038), .text+0xd713c), .text+0xd70f8), .text+0xd7334), .text+0xd7278)
  + error: tpm_ibmvtpm.c: undefined reference to `.vio_unregister_driver':  => .exit.text+0x1358)
  + mm/huge_memory.c: error: implicit declaration of function 'pfn_pmd' [-Werror=implicit-function-declaration]:  => 780:2
  + mm/huge_memory.c: error: incompatible types when assigning to type 'pmd_t' from type 'int':  => 780:8
  + sound/pci/lx6464es/lx6464es.c: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]:  => 1028:2
  + sound/pci/lx6464es/lx6464es.c: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]:  => 565:2
  + sound/soc/codecs/wm8903.c: error: implicit declaration of function 'irq_get_irq_data' [-Werror=implicit-function-declaration]:  => 1954:9

39 improvements:
  - arch/powerpc/mm/tlb_nohash_low.S: Error: bad expression: 212, 234, 232, 230 => 
  - arch/powerpc/mm/tlb_nohash_low.S: Error: junk at end of line, first unrecognized character is `r': 212, 234, 232, 230 => 
  - arch/powerpc/mm/tlb_nohash_low.S: Error: missing ')': 212, 234, 232, 230 => 
  - arch/sh/lib/mcount.S: Error: pcrel too far: 89 => 
  - drivers/block/paride/bpck.c: error: invalid operands to binary & (have 'void *' and 'int'): 62:140, 56:140 => 
  - drivers/block/paride/epia.c: error: invalid operands to binary & (have 'void *' and 'int'): 63:502 => 
  - drivers/block/paride/epia.c: error: invalid operands to binary | (have 'void *' and 'int'): 64:502 => 
  - drivers/block/paride/kbic.c: error: invalid operands to binary | (have 'void *' and 'int'): 85:142, 61:142, 91:142, 53:142, 67:142, 57:142 => 
  - drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'): 1373:153, 1388:151 => 
  - drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'): 151:131 => 
  - drivers/input/gameport/lightning.c: error: invalid operands to binary & (have 'void *' and 'int'): 177:136, 141:136, 86:133 => 
  - drivers/input/gameport/ns558.c: error: invalid operands to binary & (have 'void *' and 'int'): 84:124 => 
  - drivers/input/touchscreen/mk712.c: error: invalid operands to binary | (have 'void *' and 'int'): 129:136 => 
  - drivers/net/ethernet/dlink/de620.c: error: invalid operands to binary ^ (have 'void *' and 'int'): 395:147, 266:147, 371:147 => 
  - drivers/net/ethernet/seeq/seeq8005.c: error: invalid operands to binary >> (have 'void *' and 'int'): 544:161 => 
  - drivers/net/ethernet/seeq/seeq8005.c: error: invalid operands to binary | (have 'void *' and 'int'): 640:138, 220:138, 661:139, 543:140, 438:139, 671:142, 722:138, 705:140, 700:138, 468:140, 673:138, 672:142, 322:139, 461:140, 502:139 => 
  - drivers/net/hamradio/baycom_ser_fdx.c: error: invalid operands to binary >> (have 'void *' and 'int'): 189:152 => 
  - drivers/net/hamradio/baycom_ser_fdx.c: error: invalid operands to binary | (have 'void *' and 'int'): 329:145, 388:132 => 
  - drivers/net/hamradio/baycom_ser_hdx.c: error: invalid operands to binary | (have 'void *' and 'int'): 447:132, 209:142 => 
  - drivers/net/hamradio/yam.c: error: invalid operands to binary ^ (have 'void *' and 'int'): 713:159 => 
  - drivers/net/hamradio/yam.c: error: invalid operands to binary | (have 'void *' and 'int'): 320:134, 309:134, 317:134, 517:132, 481:142, 336:134 => 
  - drivers/staging/ipack/devices/ipoctal.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 141:3 => 
  - drivers/staging/ipack/devices/ipoctal.c: error: implicit declaration of function 'iowrite8' [-Werror=implicit-function-declaration]: 64:2 => 
  - drivers/staging/ipack/ipack.c: error: implicit declaration of function 'ioread16be' [-Werror=implicit-function-declaration]: 383:3 => 
  - drivers/staging/ipack/ipack.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 365:2 => 
  - drivers/staging/speakup/serialio.c: error: invalid operands to binary & (have 'void *' and 'int'): 52:137 => 
  - drivers/staging/speakup/serialio.c: error: invalid operands to binary >> (have 'void *' and 'int'): 53:137 => 
  - drivers/staging/speakup/serialio.c: error: invalid operands to binary | (have 'void *' and 'int'): 51:137, 110:148, 107:149, 58:137 => 
  - drivers/staging/speakup/speakup_apollo.c: error: invalid operands to binary | (have 'void *' and 'int'): 177:151 => 
  - drivers/tty/serial/xilinx_uartps.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 164:2 => 
  - drivers/tty/serial/xilinx_uartps.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 204:4 => 
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: phy_n.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o: (.text+0x1ff9f74), (.text+0x1ffa5bc), (.text+0x1ffbc90) => 
  - error: phy_n.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_14' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa584), (.text+0x1ff9f54) => 
  - error: phy_n.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_21' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa590) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o: (.text+0x1ffad78) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `.memset' defined in .text section in arch/powerpc/lib/built-in.o: (.text+0x1ffaec4) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_15' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffad4c) => 
  - error: vga16fb.c: undefined reference to `vgacon_remap_base': .devinit.text+0x16b52), .devinit.text+0x16b5a) => 


*** WARNINGS ***

355 regressions:
  + <stdin>: warning: #warning syscall finit_module not implemented [-Wcpp]:  => 1223:2
  + <stdin>: warning: #warning syscall finit_module not implemented:  => 1223:2
  + arch/alpha/kernel/process.c: warning: unused variable 'settls':  => 253
  + arch/avr32/kernel/process.c: warning: assignment makes integer from pointer without a cast:  => 310
  + arch/sh/kernel/cpu/sh2a/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence:  => 375, 378
  + arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning:   CC      kernel/panic.o:  => 378
  + arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence:  => 378
  + arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence:  => 378
  + arch/tile/kernel/process.c: warning: unused variable 'regs' [-Wunused-variable]:  => 162:116
  + crypto/async_tx/async_pq.c: warning: 'do_async_gen_syndrome.constprop.9' uses dynamic stack allocation [enabled by default]:  => 143:1
  + crypto/async_tx/raid6test.c: warning: 'raid6_dual_recov.constprop.3' uses dynamic stack allocation [enabled by default]:  => 133:1
  + drivers/ata/acard-ahci.c: warning: value computed is not used [-Wunused-value]:  => 151:3
  + drivers/ata/ahci.c: warning: value computed is not used [-Wunused-value]:  => 613:3
  + drivers/ata/ahci_platform.c: warning: value computed is not used [-Wunused-value]:  => 270:2
  + drivers/ata/libahci.c: warning: value computed is not used [-Wunused-value]: 831:453, 576:476, 697:478, 1446:477, 1258:507, 629:476 => 629:2, 831:453, 576:476, 576:2, 1446:477, 1258:3, 697:4, 1446:3, 697:478, 1258:507, 629:476, 831:4
  + drivers/ata/pata_pdc2027x.c: warning: value computed is not used [-Wunused-value]: 614:491, 631:491 => 614:491, 631:2, 631:491, 614:2
  + drivers/ata/sata_highbank.c: warning: value computed is not used [-Wunused-value]:  => 393:2
  + drivers/ata/sata_promise.c: warning: value computed is not used [-Wunused-value]: 401:521, 1027:481, 743:506, 397:521, 754:486, 456:456, 780:506, 926:486, 760:486, 722:486, 1169:496, 1032:501 => 460:2, 1032:2, 758:2, 764:2, 401:2, 758:486, 1174:496, 1032:481, 931:2, 401:521, 784:2, 1037:2, 931:486, 784:506, 764:486, 1037:501, 405:521, 747:506, 726:486, 726:2, 405:2, 1174:2, 460:456, 747:2
  + drivers/ata/sata_qstor.c: warning: value computed is not used [-Wunused-value]: 327:461 => 327:2, 327:461
  + drivers/ata/sata_sil.c: warning: value computed is not used [-Wunused-value]: 388:396, 563:486 => 563:2, 388:2, 388:396, 563:486
  + drivers/ata/sata_sx4.c: warning: value computed is not used [-Wunused-value]: 757:558, 547:421, 1336:481, 1100:492, 908:396, 578:551, 675:557, 1244:496, 1089:492, 1097:512, 884:466, 1437:491, 754:553, 1430:491, 581:506, 1252:497, 1086:512, 1121:496, 671:552, 1297:491, 1221:496, 867:466, 1073:511, 1080:491, 512:421 => 510:2, 1084:512, 579:2, 1219:496, 1435:491, 1087:3, 1435:2, 1295:2, 1087:492, 545:421, 1098:3, 1071:511, 1078:2, 1095:3, 669:552, 1250:497, 1095:512, 1428:491, 1098:492, 1242:2, 579:506, 906:2, 1334:2, 755:4, 752:4, 865:466, 1242:496, 1071:2, 1084:3, 576:551, 882:2, 906:396, 1219:2, 673:3, 1334:481, 1078:491, 882:466, 576:2, 1250:3, 865:2, 752:553, 673:557, 1119:496, 669:3, 510:421, 1295:491, 1428:2, 1119:2, 545:2, 755:558
  + drivers/base/regmap/regmap-debugfs.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 180:9, 83:18
  + drivers/base/regmap/regmap-irq.c: warning: initialization makes pointer from integer without a cast [enabled by default]:  => 128:35, 61:35, 119:35, 110:35, 54:35
  + drivers/block/cciss.h: warning: value computed is not used [-Wunused-value]: 227:451 => 227:451, 227:2
  + drivers/block/drbd/drbd_receiver.c: warning: 'what' may be used uninitialized in this function [-Wuninitialized]:  => 5017:2
  + drivers/block/mtip32xx/mtip32xx.c: warning: value computed is not used [-Wunused-value]: 361:481, 336:481, 507:501, 1724:471, 494:501, 264:471 => 494:2, 336:481, 361:2, 336:2, 1725:471, 494:501, 1725:2, 361:481, 507:501, 507:2, 264:2, 264:471
  + drivers/block/sx8.c: warning: value computed is not used [-Wunused-value]: 1467:456, 502:457, 1450:456 => 502:3, 1467:456, 502:457, 1450:2, 1467:2, 1450:456
  + drivers/char/random.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'int' [-Wformat]:  => 1167:3
  + drivers/char/random.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'long int' [-Wformat]:  => 1167:3
  + drivers/char/random.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'long unsigned int' [-Wformat]:  => 1167:3
  + drivers/char/random.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'size_t' [-Wformat]:  => 1167:3
  + drivers/char/random.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'int' [-Wformat]:  => 1158:3
  + drivers/char/random.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'long int' [-Wformat]:  => 1158:3
  + drivers/char/random.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]:  => 860:2, 882:2
  + drivers/char/random.c: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]:  => 828:3
  + drivers/dma/dmatest.c: warning: 'dmatest_func' uses dynamic stack allocation [enabled by default]:  => 537:1
  + drivers/dma/timb_dma.c: warning: 'td_remove' defined but not used [-Wunused-function]:  => 801:12
  + drivers/gpu/drm/drm_lock.c: warning: passing argument 1 of '__cmpxchg' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 310:3, 196:3, 272:3, 239:3, 357:5
  + drivers/gpu/drm/i915/intel_ddi.c: warning: 'port' may be used uninitialized in this function [-Wuninitialized]:  => 1165:2
  + drivers/gpu/drm/r128/r128_cce.c: warning: value computed is not used [-Wunused-value]: 283:611, 335:611, 285:611, 234:611 => 234:2, 283:2, 285:611, 234:611, 335:2, 283:611, 335:611, 285:2
  + drivers/gpu/drm/r128/r128_state.c: warning: value computed is not used [-Wunused-value]: 130:1314, 951:1316, 1177:1315, 46:1374, 1336:1194, 1070:1316, 659:1315, 813:1314, 1513:1194, 414:1316, 1603:1194, 614:1315, 515:1314, 1534:1194, 384:1316, 393:1316, 1286:1195, 104:1316, 146:1314, 556:1314, 89:1314, 1216:1316, 866:1314, 1388:1194, 927:1317, 753:1315, 1046:1317, 1453:1194, 1313:1194, 435:1316, 536:1314, 165:1314, 672:1315, 1481:1194, 479:1315, 207:1324, 595:1316, 1115:1314, 1248:1194, 182:1324 => 104:2, 1216:1329, 1216:2, 595:4, 813:1327, 1177:1328, 89:2, 165:1327, 1070:1329, 393:4, 813:2, 479:3, 927:5, 753:1328, 1513:1207, 384:1329, 536:2, 1286:1208, 384:4, 951:4, 104:1329, 1336:2, 672:3, 1481:2, 479:1328, 1453:1207, 146:1327, 146:2, 866:1327, 1603:2, 659:1328, 46:1387, 595:1329, 435:1329, 1046:5, 1313:1207, 130:2, 207:1337, 1248:2, 1534:2, 556:1327, 614:1328, 1388:1207, 165:2, 1513:2, 435:4, 536:1327, 1248:1207, 1313:2, 414:1329, 866:2, 182:1337, 515:2, 614:3, 182:2, 1603:1207, 1534:1207, 1453:2, 753:3, 46:2, 1070:4, 951:1329, 659:3, 393:1329, 1177:3, 207:2, 927:1330, 1481:1207, 1115:2, 414:4, 130:1327, 515:1327, 1046:1330, 1388:2, 89:1327, 1286:3, 556:2, 672:1328, 1336:1207, 1115:1327
  + drivers/gpu/drm/radeon/r600_cp.c: warning: value computed is not used [-Wunused-value]: 1798:611, 585:611, 501:611, 408:611, 582:611 => 501:2, 582:611, 408:2, 582:2, 585:2, 1793:611, 585:611, 1793:2, 408:611, 501:611
  + drivers/gpu/drm/radeon/radeon_cp.c: warning: value computed is not used [-Wunused-value]: 2253:612, 736:611, 2249:612, 727:611 => 713:2, 2235:612, 713:611, 2235:3, 2239:3, 722:2, 2239:612, 722:611
  + drivers/gpu/drm/via/via_dma.c: warning: value computed is not used [-Wunused-value]: 460:618, 548:616 => 460:4, 460:618, 548:616, 548:2
  + drivers/gpu/drm/via/via_dmablit.c: warning: value computed is not used [-Wunused-value]: 222:686 => 222:2, 222:686
  + drivers/i2c/busses/i2c-eg20t.c: warning: value computed is not used [-Wunused-value]: 578:417 => 578:3, 578:417
  + drivers/i2c/busses/i2c-intel-mid.c: warning: value computed is not used [-Wunused-value]: 889:456, 347:456, 351:456, 911:457, 595:456, 348:456, 346:456, 1043:461, 354:456, 506:456, 777:456, 345:456, 542:456, 350:456, 349:456, 353:456, 352:456 => 349:2, 353:2, 911:457, 595:456, 348:456, 346:456, 345:2, 1043:2, 351:2, 354:2, 354:456, 777:456, 542:456, 345:456, 350:456, 777:2, 889:2, 542:2, 349:456, 353:456, 347:456, 889:456, 506:2, 352:2, 348:2, 351:456, 911:3, 1043:461, 506:456, 350:2, 346:2, 595:2, 347:2, 352:456
  + drivers/i2c/busses/i2c-ocores.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 334:15
  + drivers/infiniband/hw/cxgb4/cm.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 2941:34
  + drivers/infiniband/hw/cxgb4/cm.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 2803:12
  + drivers/input/misc/pwm-beeper.c: warning: 'pwm_beeper_resume' defined but not used [-Wunused-function]:  => 158:12
  + drivers/input/misc/pwm-beeper.c: warning: 'pwm_beeper_suspend' defined but not used [-Wunused-function]:  => 148:12
  + drivers/md/dm-raid.c: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]:  => 399:53
  + drivers/media/common/saa7146/saa7146_core.c: warning: value computed is not used [-Wunused-value]: 122:457, 87:457 => 122:457, 122:3, 87:3, 87:457
  + drivers/media/dvb-frontends/bcm3510.c: warning: 'bcm3510_do_hab_cmd' uses dynamic stack allocation [enabled by default]:  => 230:1
  + drivers/media/dvb-frontends/cxd2820r_core.c: warning: 'cxd2820r_rd_regs_i2c.isra.1' uses dynamic stack allocation [enabled by default]:  => 84:1
  + drivers/media/dvb-frontends/cxd2820r_core.c: warning: 'cxd2820r_wr_regs_i2c.isra.0' uses dynamic stack allocation [enabled by default]:  => 51:1
  + drivers/media/dvb-frontends/itd1000.c: warning: 'itd1000_write_regs.constprop.0' uses dynamic stack allocation [enabled by default]:  => 69:1
  + drivers/media/dvb-frontends/mb86a20s.h: warning: 'mb86a20s_get_tuner_i2c_adapter' defined but not used [-Wunused-function]:  => 45:2
  + drivers/media/dvb-frontends/mt312.c: warning: 'mt312_write' uses dynamic stack allocation [enabled by default]:  => 126:1
  + drivers/media/dvb-frontends/nxt200x.c: warning: 'nxt200x_writebytes' uses dynamic stack allocation [enabled by default]:  => 111:1
  + drivers/media/dvb-frontends/s5h1420.c: warning: 's5h1420_tuner_i2c_tuner_xfer' uses dynamic stack allocation [enabled by default]:  => 851:1
  + drivers/media/dvb-frontends/stb0899_drv.c: warning: 'stb0899_write_regs' uses dynamic stack allocation [enabled by default]:  => 540:1
  + drivers/media/dvb-frontends/stv090x.c: warning: 'stv090x_write_regs.constprop.6' uses dynamic stack allocation [enabled by default]:  => 750:1
  + drivers/media/dvb-frontends/stv6110x.c: warning: 'stv6110x_write_regs' uses dynamic stack allocation [enabled by default]:  => 85:1
  + drivers/media/dvb-frontends/tda10071.c: warning: 'tda10071_rd_regs' uses dynamic stack allocation [enabled by default]:  => 84:1
  + drivers/media/dvb-frontends/tda10071.c: warning: 'tda10071_wr_regs' uses dynamic stack allocation [enabled by default]:  => 52:1
  + drivers/media/dvb-frontends/tda18271c2dd.c: warning: 'WriteRegs' uses dynamic stack allocation [enabled by default]:  => 147:1
  + drivers/media/dvb-frontends/zl10039.c: warning: 'zl10039_write' uses dynamic stack allocation [enabled by default]:  => 119:1
  + drivers/media/pci/saa7134/saa7134-tvaudio.c: warning: value computed is not used [-Wunused-value]: 360:501, 347:503, 366:501 => 360:501, 360:2, 366:2, 347:4, 347:503, 366:501
  + drivers/media/pci/ttpci/av7110_hw.c: warning: 'av7110_fw_cmd' uses dynamic stack allocation [enabled by default]:  => 510:1
  + drivers/media/tuners/tuner-xc2028.c: warning: 'load_firmware' uses dynamic stack allocation [enabled by default]:  => 651:1
  + drivers/media/usb/gspca/cpia1.c: warning: unused variable 'sd' [-Wunused-variable]:  => 1630:13
  + drivers/media/usb/gspca/konica.c: warning: unused variable 'sd' [-Wunused-variable]:  => 246:13
  + drivers/media/usb/gspca/t613.c: warning: unused variable 'sd' [-Wunused-variable]:  => 840:13
  + drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]:  => 1104:1
  + drivers/memstick/host/r592.c: warning: 'r592_resume' defined but not used [-Wunused-function]:  => 861:12
  + drivers/memstick/host/r592.c: warning: 'r592_suspend' defined but not used [-Wunused-function]:  => 850:12
  + drivers/memstick/host/tifm_ms.c: warning: value computed is not used [-Wunused-value]: 248:502 => 248:3, 248:502
  + drivers/message/fusion/mptbase.c: warning: value computed is not used [-Wunused-value]: 2108:481, 2716:481 => 2716:2, 2108:481, 2108:2, 2716:481
  + drivers/mfd/lp8788-irq.c: warning: initialization makes pointer from integer without a cast [enabled by default]:  => 87:33, 80:33, 74:33, 68:33
  + drivers/mfd/max8997.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 181:10
  + drivers/mfd/sm501.c: warning: value computed is not used [-Wunused-value]: 234:416 => 234:2, 234:416
  + drivers/mfd/tps65910.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 185:14 => 401:13, 401:14
  + drivers/mfd/twl4030-madc.c: warning: 'twl4030_madc_remove' defined but not used [-Wunused-function]:  => 788:12
  + drivers/misc/phantom.c: warning: value computed is not used [-Wunused-value]: 145:428, 448:461, 396:461, 74:462, 125:427, 77:462, 315:426 => 145:428, 74:3, 448:461, 396:461, 74:462, 125:427, 315:426, 470:2, 315:2, 396:2, 448:2, 77:462, 125:3, 145:4, 77:3
  + drivers/misc/tifm_7xx1.c: warning: 'tifm_7xx1_resume' uses dynamic stack allocation [enabled by default]:  => 297:1
  + drivers/mtd/inftlmount.c: warning: 'check_free_sectors.constprop.0' uses dynamic stack allocation [enabled by default]:  => 362:1
  + drivers/mtd/nand/denali.c: warning: 'find_valid_banks' uses dynamic stack allocation [enabled by default]:  => 437:1
  + drivers/mtd/nand/denali.c: warning: value computed is not used [-Wunused-value]: 1002:501 => 993:501, 993:2
  + drivers/mtd/nftlmount.c: warning: 'check_free_sectors' uses dynamic stack allocation [enabled by default]:  => 294:1
  + drivers/mtd/tests/mtd_torturetest.c: warning: 'tort_init' uses dynamic stack allocation [enabled by default]:  => 410:1
  + drivers/net/ethernet/3com/typhoon.c: warning: value computed is not used [-Wunused-value]: 2238:441, 1388:474, 1429:476, 1754:495, 2228:442, 394:474, 1493:474, 1776:475, 1939:474, 1478:474, 631:494 => 2228:3, 2238:441, 1754:3, 1776:475, 394:474, 1478:474, 631:494, 1478:2, 1388:474, 1429:4, 1429:476, 631:2, 1754:495, 1939:2, 2238:2, 2228:442, 394:2, 1493:2, 1388:2, 1493:474, 1939:474, 1776:3
  + drivers/net/ethernet/adaptec/starfire.c: warning: value computed is not used [-Wunused-value]: 1307:474, 1914:456 => 1914:2, 1307:474, 1914:456, 1307:5
  + drivers/net/ethernet/alteon/acenic.c: warning: value computed is not used [-Wunused-value]  CC [M]  fs/lockd/svc.o:  => 3173:4
  + drivers/net/ethernet/alteon/acenic.c: warning: value computed is not used [-Wunused-value]: 2979:456, 3025:457, 3052:456, 943:452, 3020:457, 3077:456, 898:451, 915:451, 1461:446, 3072:456, 3067:456, 975:451, 3189:456, 3044:456, 3168:457, 2143:436, 921:446, 3182:456, 3152:457, 2989:456, 3014:457, 1475:447, 2984:456, 3004:456, 3157:457, 3186:456, 1490:437, 623:446, 3082:456, 2974:456, 2969:456, 3174:458, 3039:456 => 3185:456, 3077:2, 943:452, 3082:2, 3167:3, 3151:457, 2143:2, 915:451, 2979:2, 1461:446, 3072:456, 3067:456, 3020:3, 2143:436, 921:446, 2989:456, 943:3, 3014:457, 2974:2, 3156:3, 3004:2, 623:2, 3181:456, 3167:457, 3039:2, 2984:456, 3072:2, 2989:2, 915:2, 2969:2, 3052:2, 3188:2, 1490:437, 623:446, 1490:3, 3082:456, 2969:456, 3173:4, 3044:2, 3039:456, 2979:456, 3025:457, 3188:456, 3052:456, 3020:457, 2984:2, 3077:456, 898:451, 1475:3, 3156:457, 3151:3, 975:451, 3044:456, 975:2, 3181:2, 1475:447, 898:2, 3004:456, 3025:3, 3067:2, 3014:3, 3173:458, 3185:2, 1461:2, 2974:456, 921:2
  + drivers/net/ethernet/amd/amd8111e.c: warning: value computed is not used [-Wunused-value]: 1408:451, 517:421, 639:451, 607:431, 1611:451, 1600:451, 627:451 => 1408:451, 517:421, 1611:2, 1408:2, 639:451, 607:431, 1600:451, 639:2, 627:2, 517:2, 1600:2, 1611:451, 607:2, 627:451
  + drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c: warning: value computed is not used [-Wunused-value]: 158:539, 159:539, 155:539, 149:539, 166:539, 162:554, 151:539, 163:539, 160:554, 164:539, 147:534, 145:539, 148:534, 154:539, 146:539, 150:539, 152:539, 161:539, 165:539, 153:529, 156:539, 157:539 => 146:2, 158:539, 155:539, 149:539, 166:539, 162:554, 163:539, 150:2, 160:554, 148:2, 166:2, 164:2, 164:539, 148:534, 154:539, 147:2, 162:2, 165:539, 152:2, 161:2, 165:2, 156:539, 155:2, 157:539, 153:2, 157:2, 159:2, 159:539, 145:2, 151:2, 151:539, 160:2, 163:2, 147:534, 145:539, 158:2, 146:539, 150:539, 152:539, 161:539, 154:2, 156:2, 153:529, 149:2
  + drivers/net/ethernet/atheros/atl1c/atl1c_hw.c: warning: value computed is not used [-Wunused-value]: 180:540, 519:539, 40:539, 349:539, 781:539, 164:539, 783:539, 181:540, 103:446, 124:536, 175:540, 782:539, 576:540, 269:540, 70:539, 119:535, 71:559, 531:443, 96:539, 36:539, 528:443 => 349:2, 40:2, 40:539, 528:2, 269:3, 175:3, 96:2, 164:2, 164:539, 783:539, 175:540, 181:3, 783:2, 576:3, 36:2, 782:539, 576:540, 782:2, 70:2, 71:2, 180:540, 519:539, 349:539, 781:539, 181:540, 531:2, 103:446, 180:3, 124:536, 119:3, 519:2, 103:5, 269:540, 70:539, 124:4, 781:2, 71:559, 119:535, 531:443, 528:443, 36:539, 96:539
  + drivers/net/ethernet/atheros/atl1c/atl1c_main.c: warning: value computed is not used [-Wunused-value]: 1202:539, 1579:540, 80:539, 158:539, 1465:625, 1242:539, 1474:625, 1263:539, 1259:539, 1184:539, 1300:539, 178:494, 682:529, 103:530, 113:540, 1201:539, 96:540, 141:539, 1178:539, 1380:539, 86:540, 440:599, 109:540, 1203:539, 129:529, 191:493, 215:540, 394:539, 1246:443, 1174:539 => 1579:540, 158:539, 1263:2, 129:2, 141:2, 1300:539, 178:494, 215:3, 1246:2, 178:3, 96:540, 1474:3, 109:3, 1465:3, 1178:539, 191:2, 1178:2, 1259:2, 1380:539, 440:599, 86:540, 86:3, 1203:539, 129:529, 1380:2, 394:539, 215:540, 191:493, 80:2, 1579:3, 1242:2, 96:3, 103:3, 1202:539, 80:539, 1201:2, 1465:625, 1242:539, 113:3, 1474:625, 1263:539, 1259:539, 1184:539, 1203:2, 682:529, 103:530, 113:540, 1201:539, 141:539, 440:2, 158:2, 1202:2, 109:540, 1300:2, 1184:2, 1246:443, 394:2, 682:2, 1174:2, 1174:539
  + drivers/net/ethernet/atheros/atl1e/atl1e_main.c: warning: value computed is not used [-Wunused-value]: 1320:445, 101:494, 113:493, 126:493 => 1320:445, 2161:2, 126:493, 113:2, 126:2, 101:3, 1320:4, 101:494, 113:493
  + drivers/net/ethernet/atheros/atlx/atl1.c: warning: value computed is not used [-Wunused-value]: 368:476, 616:476, 414:471, 338:466, 280:476 => 368:476, 2843:3, 338:466, 368:2, 616:2, 280:2, 280:476, 2831:3, 2817:3, 414:2, 2851:2, 2837:3, 2855:2, 616:476, 338:2, 414:471, 2841:3
  + drivers/net/ethernet/atheros/atlx/atl2.c: warning: value computed is not used [-Wunused-value]: 639:443, 360:495, 2707:442, 629:444, 350:492 => 360:5, 639:3, 2706:2, 350:2, 639:443, 2706:442, 629:4, 360:495, 1674:2, 629:444, 350:492
  + drivers/net/ethernet/atheros/atlx/atlx.c: warning: value computed is not used [-Wunused-value]: 162:516 => 162:516, 162:2
  + drivers/net/ethernet/broadcom/bnx2.c: warning: value computed is not used [-Wunused-value]: 5816:496, 539:497, 501:497, 4751:497, 5051:496, 3335:496, 607:496, 6214:496, 5790:496, 558:497, 588:497, 5969:496, 3439:497 => 6220:496, 538:497, 4755:3, 3443:497, 557:497, 5056:2, 3339:2, 606:2, 5796:2, 3443:3, 587:3, 3339:496, 557:3, 587:497, 5975:496, 5975:2, 5822:496, 5796:496, 538:3, 606:496, 4755:497, 500:497, 5056:496, 500:3, 6220:2, 5822:2
  + drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c: warning: value computed is not used [-Wunused-value]: 1991:593 => 1991:593, 1991:4
  + drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h: warning: value computed is not used [-Wunused-value]: 260:498 => 260:498, 260:4
  + drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: warning: value computed is not used [-Wunused-value]: 9226:491, 6020:512, 9216:491, 7325:562, 6242:506, 6719:516 => 7487:3, 9413:2, 6758:2, 6060:3, 7487:562, 6278:506, 6060:512, 9423:2, 9413:491, 6278:2, 9423:491, 6758:516
  + drivers/net/ethernet/broadcom/cnic.c: warning: value computed is not used [-Wunused-value]: 4490:501 => 4505:2, 4505:501
  + drivers/net/ethernet/broadcom/tg3.c: warning: value computed is not used [-Wunused-value]: 547:397, 452:446 => 489:446, 584:397, 584:3, 489:2
  + drivers/net/ethernet/brocade/bna/bfa_ioc.c: warning: value computed is not used [-Wunused-value]: 1130:411, 1906:506, 1723:526, 1185:501 => 1130:2, 1185:501, 1906:2, 1185:2, 1130:411, 1723:526, 1906:506, 1723:2
  + drivers/net/ethernet/brocade/bna/bfa_ioc_ct.c: warning: value computed is not used [-Wunused-value]: 895:508, 890:508, 188:481, 614:451, 189:501, 471:501 => 895:4, 471:2, 471:501, 614:2, 189:2, 188:2, 895:508, 890:508, 188:481, 614:451, 189:501, 890:4
  + drivers/net/ethernet/calxeda/xgmac.c: warning: value computed is not used [-Wunused-value]: 1357:472 => 1354:472, 1354:3
  + drivers/net/ethernet/chelsio/cxgb/espi.c: warning: value computed is not used [-Wunused-value]: 170:512, 136:511 => 170:512, 136:511, 170:3, 136:2
  + drivers/net/ethernet/chelsio/cxgb/sge.c: warning: value computed is not used [-Wunused-value]: 1962:496, 1985:496, 755:472 => 1973:2, 1973:496, 1950:2, 743:3, 743:472, 1950:496
  + drivers/net/ethernet/chelsio/cxgb/subr.c: warning: value computed is not used [-Wunused-value]: 866:481 => 866:481, 866:2
  + drivers/net/ethernet/dec/tulip/de2104x.c: warning: value computed is not used [-Wunused-value]: 1267:481, 855:477, 1775:412, 1767:412, 1778:412, 1202:477, 1771:411, 1765:412, 878:477 => 1766:412, 1267:481, 1768:3, 855:3, 878:477, 1772:2, 1772:411, 1776:412, 1779:3, 878:3, 1779:412, 855:477, 1768:412, 1267:2, 1766:3, 1202:3, 1202:477, 1776:3
  + drivers/net/ethernet/dec/tulip/eeprom.c: warning: value computed is not used [-Wunused-value]: 369:411, 365:412, 363:412, 373:412, 376:412 => 365:412, 363:412, 373:3, 363:3, 369:2, 376:412, 369:411, 376:3, 373:412, 365:3
  + drivers/net/ethernet/dec/tulip/media.c: warning: value computed is not used [-Wunused-value]: 264:450, 291:450, 305:449, 103:422, 71:442, 84:422, 100:422, 160:422, 86:422, 70:442, 145:422, 158:422, 151:422, 153:422, 93:422, 278:449, 95:422, 143:422 => 264:450, 305:5, 153:3, 305:449, 103:422, 93:3, 70:3, 143:3, 84:422, 71:442, 86:3, 160:422, 100:422, 160:3, 86:422, 158:422, 153:422, 151:422, 93:422, 151:3, 278:449, 71:3, 264:6, 143:422, 103:3, 158:3, 84:3, 291:450, 100:3, 95:3, 145:3, 291:6, 278:5, 70:442, 145:422, 95:422
  + drivers/net/ethernet/dec/tulip/tulip_core.c: warning: value computed is not used [-Wunused-value]: 1519:441 => 1517:2, 1517:441
  + drivers/net/ethernet/dec/tulip/winbond-840.c: warning: value computed is not used [-Wunused-value]: 517:412, 519:412, 563:422, 594:422, 591:422, 584:422, 619:422, 565:422, 522:411, 624:422, 526:412, 586:422, 617:422, 626:422, 529:412 => 521:2, 564:422, 623:3, 616:422, 528:412, 525:412, 518:412, 528:3, 616:3, 518:3, 583:422, 516:412, 625:3, 564:3, 590:3, 585:3, 590:422, 593:422, 1626:3, 618:422, 562:422, 583:3, 525:3, 585:422, 593:3, 562:3, 623:422, 521:411, 618:3, 625:422, 516:3
  + drivers/net/ethernet/dlink/dl2k.c: warning: value computed is not used [-Wunused-value]: 1075:501, 1055:506, 1051:481, 1050:486, 1010:511, 1049:486, 1074:501, 1054:511, 1017:501, 1021:501, 1019:511, 1056:501, 1071:511, 1057:501, 1052:481, 1069:501, 1077:521, 1076:511, 1018:501, 1008:501, 1020:521 => 1056:2, 1075:501, 1055:506, 1077:2, 1050:486, 1020:2, 1010:511, 1017:2, 1018:2, 1050:2, 1074:501, 1054:511, 1017:501, 1010:2, 1071:511, 1008:2, 1076:511, 1057:2, 1051:2, 1020:521, 1054:2, 1055:2, 1051:481, 1074:2, 1049:486, 1049:2, 1071:2, 1052:2, 1021:501, 1056:501, 1076:2, 1019:511, 1057:501, 1069:501, 1052:481, 1077:521, 1021:2, 1008:501, 1018:501, 1075:2, 1069:2, 1019:2
  + drivers/net/ethernet/dlink/sundance.c: warning: value computed is not used [-Wunused-value]: 709:452 => 719:3, 719:452
  + drivers/net/ethernet/fealnx.c: warning: value computed is not used [-Wunused-value]: 1143:437 => 1143:3, 1143:437
  + drivers/net/ethernet/icplus/ipg.c: warning: value computed is not used [-Wunused-value]: 1035:451 => 1035:451, 1035:2
  + drivers/net/ethernet/intel/e1000/e1000_ethtool.c: warning: value computed is not used [-Wunused-value]: 913:703, 895:704, 931:704, 1437:703, 876:702, 943:702 => 913:703, 876:2, 1437:703, 943:2, 913:3, 943:702, 1437:3, 895:4, 895:704, 931:704, 876:702, 931:4
  + drivers/net/ethernet/intel/e1000/e1000_hw.c: warning: value computed is not used [-Wunused-value]: 3843:703, 1006:703, 3613:702, 2759:703, 3652:703, 4476:703, 4346:703, 4434:702, 3829:703, 614:703, 4455:703, 3849:703, 3777:703, 3805:703, 589:703, 601:703, 4432:702, 4450:703, 3097:703, 1013:703, 3789:703, 2796:702, 924:702, 449:703, 434:702, 3102:703, 3112:703, 4344:703, 3116:703, 1932:702, 3597:702, 2718:702, 496:703, 3756:703, 4452:703, 3783:703, 3795:703, 2703:702, 3801:703 => 590:703, 3808:703, 2719:2, 435:702, 3665:703, 3818:3, 3842:703, 4359:3, 3626:2, 4489:703, 3769:3, 590:3, 3769:703, 602:703, 3802:3, 2704:2, 4468:703, 4357:3, 435:2, 3856:703, 3626:702, 3110:3, 450:703, 3862:3, 2797:702, 4445:702, 1014:703, 2719:702, 2797:2, 3129:703, 615:703, 4489:3, 3856:3, 3796:703, 497:703, 3862:703, 3818:703, 3796:3, 3665:3, 4447:2, 1933:702, 4445:2, 4447:702, 3125:703, 450:3, 1007:703, 3790:3, 2760:703, 3790:703, 1014:3, 3115:703, 602:3, 1933:2, 3110:703, 4465:703, 4357:703, 3814:703, 925:702, 3610:2, 4465:3, 3610:702, 3842:3, 3802:703, 2760:3, 4463:3, 2704:702, 4463:703, 3125:3, 3808:3, 3115:3, 4359:703, 3814:3, 615:3, 497:3, 1007:3, 925:2, 3129:3, 4468:3
  + drivers/net/ethernet/intel/e1000/e1000_main.c: warning: value computed is not used [-Wunused-value]: 525:702, 3805:702, 2340:702, 2324:703, 2172:702, 310:702, 324:702, 2394:704, 2188:702, 2326:703 => 2171:702, 525:702, 2187:702, 2393:4, 310:2, 3804:702, 3804:2, 2325:703, 2323:3, 2325:3, 2171:2, 2187:2, 324:2, 2339:2, 2393:704, 525:2, 310:702, 2339:702, 324:702, 2323:703
  + drivers/net/ethernet/intel/igb/e1000_82575.c: warning: value computed is not used [-Wunused-value]  CC [M]  drivers/staging/cxt1e1/linux.o:  => 1588:2
  + drivers/net/ethernet/intel/igb/e1000_82575.c: warning: value computed is not used [-Wunused-value]: 1671:482, 1600:483, 1585:482, 1571:482, 1578:482, 1558:482, 1594:482, 1588:482, 1673:482, 1595:482, 2260:477, 1556:482, 1579:482, 1559:482, 1565:482, 1582:482, 1581:482, 1568:482, 1590:482, 1572:482, 1557:482, 1583:482, 1550:482, 1591:482, 1553:482, 1555:482, 1567:482, 1592:482, 1570:482, 1589:482, 1577:482, 1560:482, 1552:482, 1587:482, 1574:482, 1586:482, 1561:482, 1575:482, 2259:477, 1551:482, 1580:482, 1566:482, 1593:482, 1554:482, 1564:482, 1672:482, 1563:482 => 1618:482, 1626:2, 1596:482, 1709:2, 1600:482, 1626:482, 1619:482, 1616:482, 1623:482, 1587:2, 1592:2, 1594:482, 1614:482, 1630:2, 1589:2, 1610:2, 1607:2, 1611:482, 1707:482, 1607:482, 1608:482, 1628:482, 1621:482, 1597:2, 1636:3, 1590:2, 1591:482, 1604:2, 1627:482, 1624:2, 1613:482, 1593:2, 1603:482, 1587:482, 1627:2, 1600:2, 1613:2, 2298:477, 1606:482, 1591:2, 2298:2, 1593:482, 1630:482, 1628:2, 1602:2, 1599:482, 1601:482, 1624:482, 1604:482, 1610:482, 1631:2, 1615:482, 1603:2, 1608:2, 1588:482, 1618:2, 1595:482, 1629:2, 1622:482, 1622:2, 2299:2, 1590:482, 1597:482, 1616:2, 1625:2, 1619:2, 1636:483, 1592:482, 1708:482, 1586:2, 1589:482, 1595:2, 1708:2, 1625:482, 1707:2, 1629:482, 1709:482, 1617:482, 1606:2, 1599:2, 1601:2, 1586:482, 1614:2, 1602:482, 1611:2, 1631:482, 2299:477, 1623:2, 1594:2, 1588:2, 1621:2, 1596:2, 1617:2, 1615:2
  + drivers/net/ethernet/intel/igb/e1000_mac.c: warning: value computed is not used [-Wunused-value]: 515:482, 501:482, 496:482, 508:482, 521:482, 494:482, 507:482, 502:482, 493:482, 512:482, 490:482, 500:482, 510:482, 509:482, 491:482, 499:482, 511:482, 514:482, 517:482, 505:482, 504:482, 486:482, 498:482, 520:482, 495:482, 488:482, 506:482, 519:482, 487:482, 503:482, 489:482, 492:482, 518:482, 497:482, 522:482, 513:482, 516:482 => 518:2, 515:482, 510:2, 501:482, 508:482, 487:2, 521:482, 494:482, 497:2, 502:482, 493:482, 493:2, 509:482, 492:2, 517:2, 522:2, 499:482, 486:2, 498:2, 511:482, 502:2, 505:2, 517:482, 505:482, 498:482, 520:482, 495:482, 506:482, 519:2, 516:2, 490:2, 518:482, 489:2, 497:482, 491:2, 516:482, 514:2, 496:482, 512:2, 500:2, 520:2, 499:2, 509:2, 507:482, 490:482, 512:482, 500:482, 510:482, 491:482, 495:2, 503:2, 521:2, 494:2, 506:2, 508:2, 515:2, 514:482, 507:2, 511:2, 504:482, 486:482, 488:2, 488:482, 496:2, 501:2, 519:482, 487:482, 503:482, 504:2, 489:482, 492:482, 513:2, 522:482, 513:482
  + drivers/net/ethernet/intel/igb/igb_main.c: warning: value computed is not used [-Wunused-value]: 2541:482, 4675:482, 1500:482, 4645:482 => 2543:2, 4634:482, 1511:2, 4634:2, 4664:482, 1511:482, 4664:2, 2543:482
  + drivers/net/ethernet/intel/igbvf/netdev.c: warning: value computed is not used [-Wunused-value]: 1334:481, 1652:481, 1253:481, 1493:481, 1459:481, 985:481 => 1672:481, 1672:2, 1005:481, 1479:2, 1005:2, 1479:481, 1273:2, 1354:481, 1513:2, 1513:481, 1273:481, 1354:2
  + drivers/net/ethernet/intel/ixgb/ixgb_ee.c: warning: value computed is not used [-Wunused-value]: 249:493, 117:494, 224:493, 218:493, 79:493, 230:493, 60:493, 255:493, 212:493 => 249:493, 117:494, 60:2, 249:2, 224:493, 117:3, 218:493, 79:493, 218:2, 230:493, 212:2, 224:2, 60:493, 255:2, 79:2, 230:2, 255:493, 212:493
  + drivers/net/ethernet/intel/ixgb/ixgb_hw.c: warning: value computed is not used [-Wunused-value]: 153:493, 1225:493 => 1225:2, 153:493, 153:2, 1225:493
  + drivers/net/ethernet/intel/ixgb/ixgb_main.c: warning: value computed is not used [-Wunused-value]: 201:543, 184:543 => 201:543, 184:543, 201:2, 184:2
  + drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c: warning: value computed is not used [-Wunused-value]: 1002:501, 786:501, 980:501 => 1002:2, 980:2, 1002:501, 786:501, 980:501, 786:2
  + drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c: warning: value computed is not used [-Wunused-value]: 1086:501, 1695:501, 446:501, 1082:501, 1653:501, 1114:501, 1622:501, 465:501, 1146:501, 594:502, 1071:501, 127:503, 1112:501, 958:501, 1095:501, 1717:501, 1110:501, 1673:502, 1111:501, 541:502, 1113:501, 1092:501 => 2178:501, 1773:2, 125:4, 1709:2, 1751:2, 1148:501, 1142:501, 1168:2, 465:2, 613:3, 484:2, 560:3, 1202:501, 125:503, 1169:2, 1167:2, 1729:502, 1170:501, 1167:501, 1138:501, 1773:501, 613:502, 1166:501, 1709:501, 484:501, 995:501, 1751:501, 995:2, 1138:2, 1151:2, 1127:2, 1151:501, 1142:2, 465:501, 1168:501, 1202:2, 1127:501, 1678:2, 1678:501, 1729:3, 1169:501, 1170:2, 1148:2, 2178:2, 560:502, 1166:2
  + drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: warning: value computed is not used [-Wunused-value]: 2590:501, 2638:501, 415:588, 374:573, 422:588, 410:501, 1596:501, 405:501, 416:588, 396:501, 343:501, 2661:501, 386:501, 1543:501, 2631:502, 378:501, 1428:501, 419:588, 383:501, 357:502, 1487:501, 388:501, 365:573, 384:501, 399:501, 350:501, 407:501, 346:572, 380:501, 355:502, 1319:503, 362:572, 421:588, 381:501, 393:501, 368:573, 1483:501, 382:501, 387:501, 408:501, 418:583, 255:501, 412:587, 392:501, 398:501, 403:501, 366:573, 349:501, 286:501, 409:501, 348:501, 341:501, 732:501, 352:501, 413:587, 1631:501, 714:501, 363:572, 401:501, 375:501, 404:501, 342:501, 344:501, 676:501, 377:501, 417:583, 385:501, 400:501, 358:502, 394:501, 395:501, 1613:501, 691:501, 406:501, 402:501, 379:501, 351:501, 397:501, 369:573, 376:501, 391:573, 3562:501, 1526:502, 354:502 => 387:573, 414:2, 697:2, 369:501, 426:2, 421:2, 427:2, 373:501, 412:4, 396:501, 363:2, 384:572, 440:588, 424:2, 386:573, 430:501, 370:501, 2586:2, 2653:2, 376:3, 423:501, 430:2, 426:501, 415:2, 420:2, 276:2, 399:501, 1449:2, 367:572, 753:2, 407:501, 2698:2, 442:4, 364:2, 402:2, 379:502, 408:501, 403:501, 1504:2, 431:2, 1508:2, 1652:501, 433:3, 409:501, 307:501, 384:3, 369:2, 416:501, 443:588, 437:588, 427:501, 390:4, 1547:502, 440:4, 1634:501, 371:501, 418:501, 404:501, 395:4, 1449:501, 425:501, 712:501, 383:572, 1340:4, 1547:3, 363:501, 400:501, 753:501, 431:501, 429:501, 439:4, 397:2, 418:2, 372:501, 434:3, 397:501, 390:573, 400:2, 419:501, 735:2, 2586:501, 425:2, 362:501, 412:573, 399:2, 2642:3, 1340:503, 389:4, 401:2, 404:2, 413:501, 386:4, 405:501, 420:501, 3600:2, 365:501, 421:501, 365:2, 436:4, 403:2, 367:3, 2642:502, 396:2, 375:502, 1508:501, 276:501, 1652:2, 307:2, 437:4, 2698:501, 442:588, 436:588, 409:2, 1504:501, 364:501, 1564:2, 3600:501, 419:2, 1634:2, 378:3, 405:2, 428:501, 372:2, 371:2, 413:2, 422:2, 439:583, 387:4, 408:2, 438:583, 398:501, 370:2, 375:3, 389:573, 417:2, 362:2, 712:2, 376:502, 378:502, 428:2, 406:2, 414:501, 422:501, 401:501, 423:2, 697:501, 438:4, 433:587, 429:2, 434:587, 395:573, 443:4, 415:501, 1564:501, 406:501, 402:501, 1617:501, 398:2, 416:2, 1617:2, 379:3, 2653:501, 424:501, 407:2, 383:3, 735:501, 373:2, 417:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c: warning: value computed is not used [-Wunused-value]: 1422:551, 1494:551, 1482:553, 1461:552, 1443:553, 1626:501 => 1464:3, 1485:553, 1485:4, 1446:4, 1425:2, 1629:501, 1497:2, 1425:551, 1464:552, 1497:551, 1446:553, 1629:2
  + drivers/net/ethernet/intel/ixgbe/ixgbe_main.c: warning: value computed is not used [-Wunused-value]: 5238:502, 5236:502, 5234:502, 2232:502, 5203:583, 2734:501, 2340:552, 5438:502, 2681:551, 5205:588, 4094:501 => 2287:3, 4127:501, 4127:2, 5238:4, 5473:3, 5269:3, 5240:4, 5273:502, 2777:501, 2287:502, 5271:3, 2393:552, 5240:588, 2777:2, 2730:551, 5269:502, 5473:502, 2730:2, 5238:583, 2393:3, 5271:502, 5273:3
  + drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c: warning: value computed is not used [-Wunused-value]: 1483:501, 1654:501, 1630:501, 1607:502 => 1483:501, 1654:2, 1483:2, 1630:501, 1607:3, 1654:501, 1630:2, 1607:502
  + drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c: warning: value computed is not used [-Wunused-value]: 863:501, 748:501, 132:502, 182:501 => 729:501, 840:2, 729:2, 182:2, 840:501, 132:3, 132:502, 182:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c: warning: value computed is not used [-Wunused-value]: 254:501, 573:501 => 830:2, 830:501, 248:2, 248:501
  + drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c: warning: value computed is not used [-Wunused-value]: 111:501, 805:501, 742:501, 776:501 => 111:501, 805:501, 742:2, 776:501, 111:2, 742:501, 776:2, 805:2
  + drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: warning: value computed is not used [-Wunused-value]:  => 1515:2, 2578:2, 997:2
  + drivers/net/ethernet/intel/ixgbevf/vf.c: warning: value computed is not used [-Wunused-value]:  => 86:2, 152:2, 158:2
  + drivers/net/ethernet/jme.h: warning: value computed is not used [-Wunused-value]: 1235:451 => 1235:451, 1235:2
  + drivers/net/ethernet/natsemi/natsemi.c: warning: value computed is not used [-Wunused-value]  CC [M]  drivers/staging/bcm/InterfaceTx.o:  => 1227:3
  + drivers/net/ethernet/natsemi/natsemi.c: warning: value computed is not used [-Wunused-value]: 1228:472, 1180:471, 3181:461, 1275:471, 1076:451, 1018:412, 1023:411, 1073:452, 1030:412, 717:511, 3123:451, 1027:412, 1058:451, 1310:471, 1071:452, 1020:412, 711:511, 1316:471, 1720:471 => 1719:471, 1019:412, 1227:3, 1026:412, 3180:2, 1029:412, 3122:2, 1309:2, 1057:2, 1022:2, 1070:452, 1019:3, 1315:2, 1022:411, 1075:451, 1057:451, 1274:471, 711:2, 1026:3, 3180:461, 3122:451, 1179:471, 1309:471, 1017:3, 1719:2, 717:511, 1017:412, 1072:452, 717:2, 1274:2, 1029:3, 1315:471, 1075:2, 1070:3, 1179:2, 711:511, 1072:3, 1227:472
  + drivers/net/ethernet/natsemi/ns83820.c: warning: value computed is not used [-Wunused-value]: 1203:467, 1389:456, 796:456, 1202:471, 1204:467, 1199:467 => 1202:42, 1199:38, 796:456, 1202:471, 1203:38, 796:2, 1199:467, 1203:467, 1389:2, 1389:456, 1204:38, 1204:467
  + drivers/net/ethernet/neterion/s2io.c: warning: value computed is not used [-Wunused-value]: 2831:487, 4799:502, 4756:484, 4314:502 => 4799:3, 4314:3, 4314:502, 2831:3, 2831:487, 4799:502, 4756:484, 3792:2, 4756:5
  + drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: 'vxge_hw_device_hw_info_get' uses dynamic stack allocation [enabled by default]:  => 1090:1
  + drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: value computed is not used [-Wunused-value]: 4935:536 => 4935:2, 4935:536
  + drivers/net/ethernet/nvidia/forcedeth.c: warning: value computed is not used [-Wunused-value]: 952:396 => 952:2, 952:396
  + drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c: warning: value computed is not used [-Wunused-value]: 817:456, 801:456 => 811:456, 795:2, 795:456, 811:2
  + drivers/net/ethernet/packetengines/hamachi.c: warning: value computed is not used [-Wunused-value]: 1636:447, 1637:447 => 1636:447, 1637:3, 1636:3, 1637:447
  + drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c: warning: value computed is not used [-Wunused-value]: 2180:1051, 2079:2250, 2012:2250, 1403:496, 2017:1048, 2178:1081, 2184:601, 2313:2325, 2211:2362, 2209:1093, 1995:2292, 2265:1081, 2313:1087, 2209:2337, 2008:1048, 2003:2250, 2234:1046, 2039:1048, 2079:1048, 2215:1082, 2012:1048, 2027:1048, 2146:1045, 2222:1083, 2264:1093, 2337:2319, 2000:1048, 2264:2337, 2211:1082, 2337:1087, 2021:1048, 2178:2289, 1995:1048, 2340:1076, 2314:1075, 2021:2250, 2269:1046, 2003:1048, 2265:2367, 2057:1048 => 2180:1051, 1403:2, 2079:2250, 2008:6, 2017:1048, 2178:1081, 2184:2, 2209:3, 2021:6, 2209:1093, 2313:3, 2180:3, 2209:2337, 2008:1048, 2039:1048, 2079:1048, 2146:1045, 2027:6, 2178:3, 2215:4, 2000:1048, 2264:2337, 2079:6, 2211:1082, 2269:4, 2021:1048, 2222:5, 2178:2289, 1995:1048, 2340:1076, 2021:2250, 2265:3, 2003:1048, 2265:2367, 2340:4, 2017:6, 2057:1048, 1995:6, 2211:4, 1403:496, 2012:2250, 2184:601, 2000:6, 2313:2325, 2211:2362, 1995:2292, 2265:1081, 2003:2250, 2313:1087, 2234:4, 2234:1046, 2215:1082, 2314:3, 2039:6, 2012:1048, 2027:1048, 2337:3, 2222:1083, 2264:1093, 2337:2319, 2337:1087, 2003:6, 2057:6, 2314:1075, 2269:1046, 2264:3, 2146:3, 2012:6
  + drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c: warning: value computed is not used [-Wunused-value]: 2275:476, 2276:476 => 2278:476, 2277:476, 2277:2, 2278:2
  + drivers/net/ethernet/qlogic/qla3xxx.c: warning: value computed is not used [-Wunused-value]: 250:391, 225:391, 129:551, 274:391, 233:391, 175:571, 240:391, 262:391 => 274:2, 233:2, 225:391, 129:551, 274:391, 175:571, 129:2, 262:2, 250:2, 262:391, 225:2, 240:2, 250:391, 233:391, 175:2, 240:391
  + drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c: warning: value computed is not used [-Wunused-value]: 2455:476, 2456:476 => 1952:2, 1952:476, 1953:476, 1953:2
  + drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c: warning: value computed is not used [-Wunused-value]:  => 366:2, 155:426, 168:426, 155:2, 171:426, 171:2, 366:461, 168:2
  + drivers/net/ethernet/realtek/8139cp.c: warning: value computed is not used [-Wunused-value]: 986:930, 896:864, 995:822, 1581:3954, 999:930, 893:870, 1500:486, 1003:930, 980:3954, 979:3954, 1580:3954, 996:846, 895:864, 1004:960, 1509:486, 1000:960 => 990:2, 985:822, 989:930, 993:2, 1600:3954, 1599:3954, 1028:2, 1021:3954, 1600:2, 985:2, 1599:2, 1519:486, 994:960, 904:870, 1028:930, 1528:486, 990:960, 906:864, 1519:2, 994:2, 907:2, 986:2, 986:846, 907:864, 989:2, 1021:2, 993:930, 1022:2, 906:2, 1022:3954, 1528:2, 904:2
  + drivers/net/ethernet/realtek/8139too.c: warning: value computed is not used [-Wunused-value]: 1388:3956, 2583:813, 2240:3338, 1895:866, 2587:866, 2586:866, 1394:866, 1389:2780, 2239:3338, 913:873, 1733:1892, 1419:1131 => 2583:813, 2240:3338, 1895:2, 1419:3, 2586:2, 1733:2, 2586:866, 1394:866, 1389:2780, 2583:3, 1389:2, 1419:1131, 1388:3956, 913:3, 1895:866, 2587:866, 2587:2, 2239:3338, 2239:2, 1394:2, 1388:2, 2240:2, 1733:1892, 913:873
  + drivers/net/ethernet/realtek/r8169.c: warning: value computed is not used [-Wunused-value]: 3725:451, 3722:451 => 3767:451, 3770:451, 3770:2, 3767:2
  + drivers/net/ethernet/silan/sc92031.c: warning: value computed is not used [-Wunused-value]: 645:486, 310:456 => 645:486, 645:2, 310:456, 310:2
  + drivers/net/ethernet/sis/sis190.c: warning: value computed is not used [-Wunused-value]: 443:486, 875:486, 1693:486, 900:486 => 443:486, 875:2, 875:486, 1693:486, 1693:2, 900:486, 443:2, 900:2
  + drivers/net/ethernet/sis/sis900.c: warning: value computed is not used [-Wunused-value]/scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_sli4_eq_release'::  => 856:3
  + drivers/net/ethernet/sis/sis900.c: warning: value computed is not used [-Wunused-value]: 836:451, 987:452, 855:452, 978:452, 971:451, 877:451, 989:452, 921:452, 862:451, 853:452, 834:451, 980:452, 982:451, 967:452, 843:452, 929:452, 848:451, 857:452, 932:452, 969:452, 923:452, 891:452, 845:452, 889:452 => 988:452, 922:3, 988:3, 970:3, 922:452, 990:452, 968:3, 983:2, 924:3, 854:3, 930:3, 844:3, 858:452, 835:451, 849:2, 968:452, 892:452, 858:3, 837:2, 890:3, 933:3, 856:3, 846:3, 970:452, 979:452, 837:451, 983:451, 878:2, 863:2, 972:451, 924:452, 844:452, 930:452, 979:3, 854:452, 981:452, 846:452, 878:451, 933:452, 890:452, 863:451, 981:3, 856:452, 990:3, 835:2, 892:3, 849:451, 972:2
  + drivers/net/ethernet/smsc/epic100.c: warning: value computed is not used [-Wunused-value]: 598:457, 595:457, 587:457, 686:461, 589:457 => 594:457, 594:3, 586:457, 597:457, 685:2, 685:461, 586:3, 597:3, 588:457, 588:3
  + drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c: warning: value computed is not used [-Wunused-value]: 222:472 => 222:472, 222:3
  + drivers/net/ethernet/sun/cassini.c: warning: value computed is not used [-Wunused-value]: 4154:462, 1261:461, 1265:548 => 4154:462, 1261:2, 1265:4, 4154:3, 1261:461, 1265:548
  + drivers/net/ethernet/tehuti/tehuti.c: warning: value computed is not used [-Wunused-value]: 282:493, 281:493, 526:491, 493:493, 469:443 => 281:4, 526:2, 282:4, 469:443, 469:4, 281:493, 282:493, 526:491, 493:493, 493:4
  + drivers/net/hippi/rrunner.c: warning: value computed is not used [-Wunused-value]: 1219:451, 1354:452 => 1353:3, 1218:2, 1353:452, 1218:451
  + drivers/net/wan/dscc4.c: warning: value computed is not used [-Wunused-value]: 1037:441, 434:581, 423:656 => 1036:2, 434:2, 434:581, 423:656, 1036:441, 423:2
  + drivers/net/wan/pc300too.c: warning: value computed is not used [-Wunused-value]: 382:381, 386:381, 395:381, 391:381 => 382:381, 386:381, 395:381, 382:2, 386:2, 391:381, 391:2, 395:2
  + drivers/net/wan/pci200syn.c: warning: value computed is not used [-Wunused-value]: 347:381, 343:381 => 347:381, 343:381, 343:2, 347:2
  + drivers/net/wan/wanxl.c: warning: value computed is not used [-Wunused-value]: 506:486, 503:486 => 503:2, 506:2, 506:486, 503:486
  + drivers/pci/msi.c: warning: unused variable 'i' [-Wunused-variable]:  => 340:7
  + drivers/platform/x86/acer-wmi.c: warning: 'devices' may be used uninitialized in this function [-Wuninitialized]:  => 1216:14
  + drivers/regulator/lp8788-buck.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 489:63, 489:27, 490:8
  + drivers/regulator/tps6586x-regulator.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 361:8
  + drivers/scsi/3w-sas.c: warning: value computed is not used [-Wunused-value]: 1161:591 => 1161:591, 1161:2
  + drivers/scsi/aacraid/src.c: warning: value computed is not used [-Wunused-value]: 202:551, 98:559, 60:557, 86:558 => 202:551, 98:5, 98:559, 60:557, 86:4, 202:2, 86:558, 60:3
  + drivers/scsi/aic7xxx/aic79xx_core.c: warning: 'ahd_loadseq' uses dynamic stack allocation [enabled by default]:  => 9509:1
  + drivers/scsi/aic7xxx/aic7xxx_core.c: warning: 'ahc_loadseq' uses dynamic stack allocation [enabled by default]:  => 6957:1
  + drivers/scsi/arcmsr/arcmsr_hba.c: warning: value computed is not used [-Wunused-value]: 1616:481 => 1616:481, 1616:2
  + drivers/scsi/bfa/bfa_ioc.c: warning: value computed is not used [-Wunused-value]: 1987:526, 1927:526, 1870:526, 2073:506 => 1987:526, 1987:2, 1927:526, 1870:526, 2073:506, 1927:2, 2073:2, 1870:2
  + drivers/scsi/bfa/bfa_ioc_cb.c: warning: value computed is not used [-Wunused-value]: 205:501, 87:481 => 205:501, 87:481, 205:2, 87:2
  + drivers/scsi/bfa/bfa_ioc_ct.c: warning: value computed is not used [-Wunused-value]: 99:531, 136:502, 68:532, 135:482, 121:531, 88:532, 936:508, 617:451, 941:508, 400:501, 391:531, 139:482 => 136:502, 941:4, 88:3, 121:531, 88:532, 936:508, 617:451, 400:501, 139:482, 139:3, 99:531, 617:2, 68:532, 135:482, 121:2, 391:2, 99:2, 68:3, 400:2, 941:508, 136:3, 391:531, 936:4, 135:3
  + drivers/scsi/csiostor/csio_hw.c: warning: value computed is not used [-Wunused-value]:  => 156:516, 1131:601, 1131:2, 264:531, 156:2, 3636:536, 3417:531, 264:2, 3417:2, 3636:2
  + drivers/scsi/csiostor/csio_mb.c: warning: value computed is not used [-Wunused-value]:  => 1246:536, 1571:538, 1184:2, 1246:2, 1571:4, 1599:537, 1357:2, 1197:596, 1357:536, 1184:596, 1197:2, 1599:3
  + drivers/scsi/dpt_i2o.c: warning: 'adpt_i2o_passthru' uses dynamic stack allocation [enabled by default]:  => 1984:1
  + drivers/scsi/hptiop.c: warning: value computed is not used [-Wunused-value]: 1192:541, 68:552, 1198:541, 285:541, 278:551, 243:551 => 371:551, 384:2, 384:556, 378:541, 1536:541, 1542:2, 316:551, 1530:2, 68:552, 378:2, 963:2, 1546:2, 1530:541, 1536:2, 963:566, 316:2, 68:3, 1542:571, 1544:531, 1546:571, 1544:2, 371:2
  + drivers/scsi/ips.c: warning: value computed is not used [-Wunused-value]: 4773:466 => 4773:466, 4773:2
  + drivers/scsi/lpfc/lpfc.h: warning: value computed is not used [-Wunused-value]: 1014:451 => 1016:2, 1016:451
  + drivers/scsi/lpfc/lpfc_attr.c: warning: value computed is not used [-Wunused-value]: 1472:453, 919:581, 1493:452 => 1472:453, 919:581, 1493:452, 1493:3, 919:2, 1472:4
  + drivers/scsi/lpfc/lpfc_bsg.c: warning: value computed is not used [-Wunused-value]: 1388:452, 618:452, 360:452 => 1388:452, 618:452, 618:3, 360:3, 360:452, 1388:3
  + drivers/scsi/lpfc/lpfc_compat.h: warning: value computed is not used [-Wunused-value]: 51:407 => 51:407, 51:3
  + drivers/scsi/lpfc/lpfc_debugfs.c: warning: value computed is not used [-Wunused-value]: 1979:493, 3102:412, 1973:493, 2878:412, 1967:493 => 2878:3, 3102:412, 3102:3, 1973:4, 2878:412, 1967:493, 1967:4, 1979:493, 1973:493, 1979:4
  + drivers/scsi/lpfc/lpfc_hbadisc.c: warning: value computed is not used [-Wunused-value]: 1078:451, 1054:451, 3187:452, 714:454 => 1078:451, 3187:3, 1078:2, 714:5, 1054:451, 3187:452, 714:454, 1054:2
  + drivers/scsi/lpfc/lpfc_init.c: warning: value computed is not used [-Wunused-value]: 3308:451, 539:451, 705:453, 702:453, 1662:451, 785:452, 3311:451, 1681:451, 1685:451 => 3308:451, 785:3, 1685:2, 705:453, 1662:451, 702:453, 539:2, 3311:451, 1681:451, 1681:2, 705:4, 702:4, 539:451, 1662:2, 3311:2, 3308:2, 785:452, 1685:451
  + drivers/scsi/lpfc/lpfc_sli.c: warning: value computed is not used [-Wunused-value]: 4029:411, 3692:451, 3804:451, 3905:451, 6871:452, 10162:453, 1573:452, 1768:482, 3061:452, 10727:452, 9992:452, 3760:451, 4020:411, 10460:452, 9949:452, 6862:452, 10834:451, 4201:451, 4205:451, 3903:451, 3386:452, 10544:454, 6971:452, 1548:451, 331:532, 10516:455, 10480:454, 6846:412 => 4029:411, 3386:3, 6846:3, 10162:453, 3760:2, 3692:2, 10727:452, 6971:3, 1768:3, 3804:2, 9992:452, 1548:2, 3061:3, 4020:2, 3760:451, 10460:452, 9949:452, 6862:452, 10834:451, 4205:451, 9949:3, 3903:451, 10727:3, 10544:454, 6971:452, 10834:2, 1548:451, 10516:455, 10162:4, 10480:454, 3905:2, 4201:2, 3692:451, 3804:451, 3905:451, 3903:2, 6871:452, 1573:452, 4205:2, 10480:5, 1768:482, 3061:452, 10460:3, 10544:5, 1573:3, 331:3, 6871:3, 4020:411, 4029:2, 6862:3, 4201:451, 10516:6, 3386:452, 9992:3, 331:532, 6846:412
  + drivers/scsi/megaraid/megaraid_sas_base.c: warning: value computed is not used [-Wunused-value]: 674:501, 687:501, 300:511, 420:501, 433:501, 249:501, 262:501, 472:526, 600:511, 551:501, 728:511, 538:501 => 538:2, 249:2, 433:501, 249:501, 687:2, 262:2, 472:2, 728:2, 551:2, 674:501, 687:501, 420:2, 674:2, 300:511, 420:501, 262:501, 433:2, 472:526, 600:511, 600:2, 300:2, 551:501, 728:511, 538:501
  + drivers/scsi/megaraid/megaraid_sas_fusion.c: warning: value computed is not used [-Wunused-value]: 113:501, 142:512, 108:511 => 113:2, 113:501, 142:512, 108:2, 142:3, 108:511
  + drivers/scsi/mpt2sas/mpt2sas_base.c: warning: value computed is not used [-Wunused-value]: 850:521 => 850:2, 850:521
  + drivers/scsi/mpt3sas/mpt3sas_base.c: warning: value computed is not used [-Wunused-value]:  => 853:521, 853:2
  + drivers/scsi/mvsas/mv_64xx.c: warning: value computed is not used [-Wunused-value]: 191:817, 473:834, 382:774, 279:841 => 191:817, 191:3, 473:834, 382:774, 473:2, 382:2, 279:841, 279:3
  + drivers/scsi/mvsas/mv_94xx.c: warning: value computed is not used [-Wunused-value]: 478:774, 356:841, 612:835 => 477:774, 611:3, 477:2, 355:3, 355:841, 611:835
  + drivers/scsi/pmcraid.c: warning: value computed is not used [-Wunused-value]: 4739:587, 4395:588, 4466:608, 544:612, 488:601, 2023:587, 547:607, 493:612, 519:612, 2027:586 => 4739:587, 4395:588, 493:3, 4466:608, 488:601, 2023:587, 547:607, 4395:4, 493:612, 4466:4, 547:3, 2027:2, 488:2, 544:612, 519:3, 544:3, 4739:3, 2023:3, 2027:586, 519:612
  + drivers/scsi/qla2xxx/qla_dbg.c: warning: value computed is not used [-Wunused-value]: 1880:461, 1564:461, 1902:461, 1898:431, 1551:471, 1869:461, 1226:461, 1235:471, 1560:431, 134:430, 980:461, 2258:427, 2264:427, 976:431, 1244:431, 1248:461, 1889:471, 246:426, 2261:427, 140:429, 1542:461 => 1880:461, 134:6, 1564:461, 1244:2, 1869:461, 2261:3, 1226:461, 1889:2, 1560:431, 134:430, 976:2, 1542:2, 1235:2, 2258:427, 1226:2, 2264:427, 976:431, 1244:431, 1551:2, 246:426, 980:2, 2258:3, 1248:2, 2261:427, 1542:461, 140:5, 1902:461, 1898:431, 1551:471, 1235:471, 980:461, 1564:2, 1889:471, 1248:461, 2264:3, 140:429, 1880:2, 1898:2, 1902:2, 1869:2, 1560:2, 246:2
  + drivers/scsi/qla2xxx/qla_init.c: warning: value computed is not used [-Wunused-value]: 1083:426, 1080:426, 4603:426, 1841:436, 1077:426, 4601:426 => 4628:426, 1083:426, 1080:2, 1083:2, 1077:2, 4628:2, 4630:426, 1920:436, 1080:426, 1920:2, 1077:426, 4630:2
  + drivers/scsi/qla2xxx/qla_iocb.c: warning: value computed is not used [-Wunused-value]: 1568:491, 491:478, 1769:491, 488:493 => 1769:2, 488:4, 1568:491, 491:478, 1568:2, 1769:491, 488:493, 491:4
  + drivers/scsi/qla2xxx/qla_isr.c: warning: value computed is not used [-Wunused-value]: 2611:427, 2639:427, 2477:471, 2572:427, 2445:461 => 2441:461, 2607:3, 2568:3, 2635:3, 2441:2, 2473:471, 2635:427, 2568:427, 2607:427, 2473:2
  + drivers/scsi/qla2xxx/qla_mbx.c: warning: value computed is not used [-Wunused-value]: 4249:429 => 4249:5, 4249:429
  + drivers/scsi/qla2xxx/qla_nx.c: warning: value computed is not used [-Wunused-value]: 920:561 => 921:2, 921:561
  + drivers/scsi/qla2xxx/qla_os.c: warning: value computed is not used [-Wunused-value]: 1528:431, 1513:431 => 1538:2, 1523:2, 1538:431, 1523:431
  + drivers/scsi/qla2xxx/qla_sup.c: warning: value computed is not used [-Wunused-value]: 1154:461, 504:456, 1841:431, 1406:461, 1115:461, 1796:432, 1381:461 => 504:456, 1796:3, 1115:461, 1381:461, 1115:2, 1154:461, 1154:2, 1406:2, 1841:431, 1406:461, 504:2, 1381:2, 1796:432, 1841:2
  + drivers/scsi/qla2xxx/qla_target.c: warning: value computed is not used [-Wunused-value]: 4697:487 => 4716:487, 4716:3
  + drivers/scsi/qla4xxx/ql4_init.c: warning: value computed is not used [-Wunused-value]: 803:483, 680:483, 806:483, 683:481, 614:471, 718:482, 131:472 => 806:483, 803:4, 680:9, 131:3, 614:471, 718:482, 614:2, 803:483, 680:483, 683:2, 683:481, 718:3, 806:4, 131:472
  + drivers/scsi/qla4xxx/ql4_inline.h: warning: value computed is not used [-Wunused-value]: 44:527, 47:482, 61:482, 58:527 => 58:3, 47:3, 44:3, 61:3, 44:527, 47:482, 61:482, 58:527
  + drivers/scsi/qla4xxx/ql4_iocb.c: warning: value computed is not used [-Wunused-value]: 248:466, 198:516, 262:471, 204:521, 235:521 => 235:2, 198:516, 248:2, 198:2, 262:2, 248:466, 262:471, 204:2, 204:521, 235:521
  + drivers/scsi/qla4xxx/ql4_isr.c: warning: value computed is not used [-Wunused-value]: 898:516, 1013:483, 923:482, 1026:483, 1008:484 => 898:516, 1008:5, 1013:483, 1026:483, 1008:484, 923:3, 1026:4, 923:482, 898:2, 1013:4
  + drivers/scsi/qla4xxx/ql4_mbx.c: warning: value computed is not used [-Wunused-value]: 27:481, 25:476 => 27:481, 27:2, 25:476, 25:2
  + drivers/scsi/qla4xxx/ql4_nvram.c: warning: value computed is not used [-Wunused-value]: 233:461, 16:441 => 233:2, 16:2, 233:461, 16:441
  + drivers/scsi/qla4xxx/ql4_nx.c: warning: value computed is not used [-Wunused-value]: 2981:522, 3286:496, 2984:517, 3284:541 => 2981:522, 3286:496, 2984:517, 3284:2, 2981:3, 2984:3, 3286:2, 3284:541
  + drivers/scsi/qla4xxx/ql4_os.c: warning: value computed is not used [-Wunused-value]: 3519:482, 2839:482, 2812:482, 3522:517, 2770:481, 3525:522, 2853:482 => 2812:482, 2812:3, 2770:2, 2839:3, 3525:522, 3519:482, 2839:482, 3522:517, 2853:3, 3525:3, 3519:3, 2770:481, 2853:482, 3522:3
  + drivers/scsi/stex.c: warning: value computed is not used [-Wunused-value]: 512:481, 853:431, 1035:431, 992:432, 1058:431, 1109:451, 1038:431, 870:432, 1257:431, 1056:431, 1040:431, 1062:431, 1190:432, 1060:431, 1033:431, 541:516, 1283:501, 543:501, 1107:466 => 1062:2, 1056:2, 853:431, 1035:431, 1033:2, 512:2, 1283:2, 1062:431, 1257:2, 1058:2, 1190:432, 1060:431, 1033:431, 1283:501, 1107:466, 512:481, 1038:2, 992:432, 1058:431, 992:3, 853:2, 1038:431, 1109:451, 870:432, 1257:431, 543:2, 1040:431, 1056:431, 1109:2, 1035:2, 870:3, 1190:3, 1040:2, 541:2, 541:516, 1060:2, 543:501, 1107:2
  + drivers/spi/spi-altera.c: warning: value computed is not used [-Wunused-value]: 263:437 => 263:437, 263:3
  + drivers/spi/spi-atmel.c: warning: 'atmel_spi_remove' defined but not used:  => 1013
  + drivers/staging/line6/driver.c: warning: 'line6_write_hexdump' uses dynamic stack allocation [enabled by default]:  => 176:1
  + drivers/staging/line6/midi.c: warning: 'line6_midi_transmit' uses dynamic stack allocation [enabled by default]:  => 76:1
  + drivers/tty/pty.c: warning: 'pty_unix98_shutdown' defined but not used [-Wunused-function]:  => 403:13
  + drivers/tty/serial/8250/8250_pci.c: warning: value computed is not used [-Wunused-value]: 285:416, 308:417 => 308:3, 285:416, 308:417, 285:2
  + drivers/tty/serial/ifx6x60.c: warning: 'more' may be used uninitialized in this function [-Wuninitialized]:  => 758:8
  + drivers/tty/serial/xilinx_uartps.c: warning: 'xuartps_remove' defined but not used [-Wunused-function]:  => 1000:12
  + drivers/usb/gadget/amd5536udc.c: warning: value computed is not used [-Wunused-value]: 2649:509, 1685:451 => 2649:5, 2649:509, 1685:451, 1685:2
  + drivers/usb/gadget/f_fs.c: warning: '__ffs_ep0_read_events' uses dynamic stack allocation [enabled by default]:  => 579:1
  + drivers/usb/gadget/goku_udc.c: warning: value computed is not used [-Wunused-value]: 917:447, 206:462, 1318:461, 1285:461, 1277:461 => 917:447, 206:462, 1318:461, 917:3, 206:3, 1285:461, 1277:2, 1318:2, 1285:2, 1277:461
  + drivers/usb/gadget/mv_udc_core.c: warning: 'mv_udc_remove' defined but not used [-Wunused-function]:  => 2131:12
  + drivers/usb/gadget/net2280.h: warning: value computed is not used [-Wunused-value]: 279:461 => 279:2, 279:461
  + drivers/usb/host/oxu210hp-hcd.c: warning: value computed is not used [-Wunused-value]: 2462:471, 3435:472, 3239:472, 2750:471, 2809:511 => 2809:2, 3239:472, 2750:471, 2462:2, 3514:2, 2462:471, 2750:2, 3239:3, 3435:3, 3435:472, 2809:511
  + drivers/usb/host/pci-quirks.c: warning: value computed is not used [-Wunused-value]: 514:432 => 514:432, 514:3
  + drivers/video/aty/radeon_accel.c: warning: value computed is not used [-Wunused-value]: 247:501, 221:502, 243:502, 234:502 => 221:502, 243:502, 234:502, 247:2, 247:501, 234:3, 221:3, 243:3
  + drivers/video/aty/radeon_pm.c: warning: value computed is not used [-Wunused-value]:  => 1621:2, 1436:2, 1751:2
  + drivers/video/savage/savagefb-i2c.c: warning: value computed is not used [-Wunused-value]: 56:496, 70:496 => 56:496, 70:2, 56:2, 70:496
  + drivers/video/sm501fb.c: warning: value computed is not used [-Wunused-value]: 141:426 => 141:426, 141:2
  + fs/btrfs/acl.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]: 56:7 => 56:25, 56:7
  + fs/btrfs/delayed-inode.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 469:17 => 469:17, 454:9
  + fs/btrfs/file-item.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 171:2
  + fs/btrfs/tree-log.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]:  => 3255:40
  + fs/f2fs/node.c: warning: 'nofs' may be used uninitialized in this function [-Wuninitialized]:  => 738:8
  + fs/nfsd/nfs4state.c: warning: unused variable 'nn' [-Wunused-variable]:  => 1051:19
  + fs/proc/vmcore.c: warning: initialization from incompatible pointer type [enabled by default]:  => 549:47
  + fs/pstore/ram_core.c: warning: 'persistent_ram_decode_rs8' uses dynamic stack allocation [enabled by default]:  => 104:1
  + fs/pstore/ram_core.c: warning: 'persistent_ram_encode_rs8' uses dynamic stack allocation [enabled by default]:  => 92:1
  + include/asm-generic/io.h: warning: passing argument 1 of '__raw_readb' makes pointer from integer without a cast [enabled by default]: 110:2 => 115:2, 156:4
  + include/asm-generic/io.h: warning: passing argument 1 of '__raw_readl' makes pointer from integer without a cast [enabled by default]: 120:2 => 182:4, 125:2
  + include/asm-generic/io.h: warning: passing argument 1 of '__raw_readw' makes pointer from integer without a cast [enabled by default]: 115:2 => 169:4, 120:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u16' makes pointer from integer without a cast [enabled by default]:  => 169:4, 120:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u32' makes pointer from integer without a cast [enabled by default]:  => 182:4, 125:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u8' makes pointer from integer without a cast [enabled by default]:  => 115:2, 156:4
  + include/asm-generic/io.h: warning: passing argument 2 of '__raw_writeb' makes pointer from integer without a cast [enabled by default]: 125:2 => 130:2, 195:4
  + include/asm-generic/io.h: warning: passing argument 2 of '__raw_writel' makes pointer from integer without a cast [enabled by default]: 135:2 => 219:4, 140:2
  + include/asm-generic/io.h: warning: passing argument 2 of '__raw_writew' makes pointer from integer without a cast [enabled by default]: 130:2 => 207:4, 135:2
  + include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u16' makes pointer from integer without a cast [enabled by default]:  => 207:4, 135:2
  + include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u32' makes pointer from integer without a cast [enabled by default]:  => 219:4, 140:2
  + include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u8' makes pointer from integer without a cast [enabled by default]:  => 130:2, 195:4
  + kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]:  => 356:125
  + kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]:  => 292:13
  + kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]:  => 269:13
  + kernel/rcutree.c: warning: unused variable 'idle' [-Wunused-variable]:  => 497:23, 341:23
  + kernel/sched/fair.c: warning: 'update_cfs_rq_blocked_load' declared inline after being called:  => 266
  + kernel/sched/fair.c: warning: previous declaration of 'update_cfs_rq_blocked_load' was here:  => 266
  + kernel/signal.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 2700:1202, 2728:1223, 2693:1245, 2728:2597, 2693:2634, 3098:1073, 2700:2561, 2724:1244, 2724:2633, 3098:2342 => 3086:2342, 2688:1202, 2716:2597, 2712:1244, 2688:2561, 3086:1073, 2712:2633, 2681:1245, 3111:2340, 3111:1076, 2681:2634, 2716:1223
  + lib/bch.c: warning: 'build_deg2_base' uses dynamic stack allocation [enabled by default]:  => 1149:1
  + lib/bch.c: warning: 'encode_bch' uses dynamic stack allocation [enabled by default]:  => 253:1
  + lib/bch.c: warning: 'solve_linear_system.isra.7.constprop.10' uses dynamic stack allocation [enabled by default]:  => 502:1
  + lib/reed_solomon/reed_solomon.c: warning: 'decode_rs16' uses dynamic stack allocation [enabled by default]:  => 373:1
  + lib/reed_solomon/reed_solomon.c: warning: 'decode_rs8' uses dynamic stack allocation [enabled by default]:  => 329:1
  + mm/compaction.c: warning: 'flags' may be used uninitialized in this function:  => 452, 248
  + mm/memcontrol.c: warning: 'memcg_propagate_kmem' defined but not used [-Wunused-function]:  => 4972:12
  + mm/slab_common.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]:  => 303:6
  + mm/slub.c: warning: '__slab_alloc.constprop.43' uses dynamic stack allocation [enabled by default]:  => 2309:1
  + mm/slub.c: warning: 'get_partial_node.isra.34' uses dynamic stack allocation [enabled by default]:  => 1579:1
  + mm/slub.c: warning: 'unfreeze_partials.isra.32' uses dynamic stack allocation [enabled by default]:  => 1938:1
  + modpost: WARNING: modpost: Found 8 section mismatch(es).:  => N/A
  + net/mac80211/tx.c: warning: 'chanctx_conf' may be used uninitialized in this function [-Wuninitialized]:  => 1800:27
  + net/sunrpc/svc.c: warning: unused variable 'buf' [-Wunused-variable]:  => 1050:7
  + net/sunrpc/svc.c: warning: unused variable 'buf':  => 1050:7, 1050
  + sound/core/oss/pcm_oss.c: warning: 'snd_pcm_oss_sync' uses dynamic stack allocation [enabled by default]:  => 1701:1
  + sound/core/pcm_native.c: warning: 'snd_pcm_hw_refine' uses dynamic stack allocation [enabled by default]:  => 333:1
  + sound/pci/atiixp.c: warning: value computed is not used [-Wunused-value]: 513:491, 522:492 => 513:491, 522:492, 513:2, 522:3
  + sound/pci/atiixp_modem.c: warning: value computed is not used [-Wunused-value]: 498:492, 489:491 => 498:492, 498:3, 489:2, 489:491
  + sound/pci/au88x0/au88x0_core.c: warning: value computed is not used [-Wunused-value]: 967:566, 875:566, 1169:576, 1248:637, 2556:486, 2421:496, 1207:648, 2477:497, 875:561, 967:561, 1475:643, 2690:496 => 2695:2, 967:566, 875:566, 2561:486, 1248:3, 1207:648, 875:2, 2421:2, 967:561, 2561:2, 1475:643, 1169:2, 1169:576, 2482:3, 967:2, 1248:637, 1207:4, 2421:496, 2695:496, 1475:4, 875:561, 2482:497
  + sound/pci/lx6464es/lx6464es.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1028:26
  + sound/soc/codecs/wm8903.c: warning: initialization makes pointer from integer without a cast [enabled by default]:  => 1954:30
  + sound/soc/soc-core.c: warning: 'format_register_str' uses dynamic stack allocation [enabled by default]:  => 122:1
  + warning: (CAN_PEAK_PCIEC && SFC && DRM && FB_DDC && FB_BFIN_7393 && FB_VIA && SND_AOA_ONYX && SND_AOA_TAS && SND_SOC_BFIN_EVAL_ADAU1701 && FB_OLPC_DCON) selects I2C which has unmet direct dependencies (!S390):  => N/A
  + warning: (CNIC) selects UIO which has unmet direct dependencies (!S390):  => N/A
  + warning: (I2C_TAOS_EVM) selects SERIO which has unmet direct dependencies (!S390 && !UML):  => N/A
  + warning: (I2C_TAOS_EVM) selects SERIO_SERPORT which has unmet direct dependencies (!S390 && !UML && SERIO):  => N/A
  + warning: (NET_DSA && GRETH && DNET && LPC_ENET && OCTEON_MGMT_ETHERNET && ETHOC && SH_ETH && S6GMAC && MIPS_AU1X00_ENET && MACB && BFIN_MAC && BCM63XX_ENET && SB1250_MAC && TIGON3 && FTGMAC100 && FEC && FEC_MPC52xx && FS_ENET && FSL_PQ_MDIO && FSL_XGMAC_MDIO && UCC_GETH && GIANFAR && IXP4XX_ETH && MV643XX_ETH && MVNETA && PXA168_ETH && AX88796 && W90P910_ETH && PASEMI_MAC && R6040 && SMSC911X && SMSC9420 && STMMAC_ETH && TI_DAVINCI_EMAC && TI_DAVINCI_MDIO && CPMAC && TC35815 && XILINX_EMACLITE && XILINX_AXI_EMAC && XILINX_LL_TEMAC && USB_NET_AX8817X && ET131X && OCTEON_ETHERNET) selects PHYLIB which has unmet direct dependencies (!S390 && NETDEVICES):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON || MIPS_SEAD3)):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: (VERSATILE_FPGA_IRQ && REGMAP && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_TPS65910 && TWL4030_CORE && MFD_LP8788 && MFD_MAX77686 && MFD_MAX8997 && MFD_WM831X_I2C && MFD_WM831X_SPI && AB8500_CORE && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS):  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x3dce0): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x3f0fc): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x1026c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xecc0): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: drivers/built-in.o(.data+0x784): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0x824): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0x97c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa80): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xae0): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xb40): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xbac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd50): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.text+0xb60): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DevicePresent():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.text+0xbc2): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.text+0xc10): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x164): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x204): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x35c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x460): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x4c0): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x520): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x58c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x730): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/sbus/char/bbc.o(.text+0x604): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:attach_one_i2c.constprop.0():  => N/A
  + warning: drivers/w1/masters/w1-gpio.o(.data+0x188): Section mismatch in reference from the variable w1_gpio_driver to the function .init.text:w1_gpio_probe():  => N/A
  + warning: drivers/w1/masters/w1-gpio.o(.data+0x190): Section mismatch in reference from the variable w1_gpio_driver to the function .init.text:w1_gpio_probe():  => N/A
  + warning: mm/built-in.o(.meminit.text+0x107c): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.meminit.text+0x148c): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x149b40): Section mismatch in reference from the function pwm_get_chip_data() to the function .init.text:pcibios_fixup_bus():  => N/A
  + warning: vmlinux.o(.text+0x14dbe8): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus():  => N/A
  + warning: vmlinux.o(.text+0x2bc84): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2bd84): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x3b98): Section mismatch in reference from the function pgd_ctor() to the function .init.text:__alloc_bootmem():  => N/A
  + warning: vmlinux.o(.text+0x45a3): Section mismatch in reference from the function iss_net_setup() to the function .init.text:__alloc_bootmem():  => N/A
  + warning: vmlinux.o(.text+0x490c0): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: vmlinux.o(.text+0x490e4): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.notify_cpu_starting():  => N/A
  + warning: vmlinux.o(.text+0x4a5dc): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: vmlinux.o(.text+0x4a600): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.notify_cpu_starting():  => N/A
  + warning: vmlinux.o(.text+0x528e8): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x53e04): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x78530): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x7afdc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x98078): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x9ab38): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A

4189 improvements:
  - .config: warning: override: USB_G_PRINTER changes choice state: 1875 => 
  - arch/blackfin/include/asm/bfin_twi.h: warning: "ANOMALY_16000030" is not defined [-Wundef]: 87:6 => 
  - arch/m32r/include/asm/io.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 124:34 => 
  - arch/powerpc/include/asm/swab.h: warning: 'type' may be used uninitialized in this function [-Wuninitialized]: 71:2 => 
  - arch/powerpc/sysdev/fsl_msi.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 368:6 => 
  - arch/sh/include/uapi/asm/swab.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 14:2 => 
  - arch/xtensa/kernel/time.c: warning: (near initialization for 'ccount_clocksource.read') [enabled by default]: 42:2 => 
  - arch/xtensa/kernel/time.c: warning: initialization from incompatible pointer type [enabled by default]: 42:2 => 
  - arch/xtensa/mm/tlb.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 70:79, 67:79 => 
  - block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]: 65:44 => 
  - crypto/async_tx/raid6test.c: warning: 'raid6_dual_recov.constprop.4' uses dynamic stack allocation [enabled by default]: 133:1 => 
  - drivers/ata/pata_atiixp.c: warning: 'wanted_pio' may be used uninitialized in this function [-Wuninitialized]: 195:26 => 
  - drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 1353:9, 1167:6 => 
  - drivers/block/rbd.c: warning: 'tail' may be used uninitialized in this function [-Wuninitialized]: 856:18 => 
  - drivers/gpu/drm/drm_pci.c: warning: 'lnkcap' may be used uninitialized in this function [-Wuninitialized]: 496:9 => 
  - drivers/gpu/drm/drm_pci.c: warning: 'lnkcap2' may be used uninitialized in this function [-Wuninitialized]: 497:10 => 
  - drivers/gpu/drm/nouveau/core/subdev/bios/base.c: warning: unused variable 'i' [-Wunused-variable]: 66:12 => 
  - drivers/i2c/busses/i2c-diolan-u2c.c: warning: 'byte' may be used uninitialized in this function [-Wuninitialized]: 394:18 => 
  - drivers/leds/leds-lp5523.c: warning: 'adc' may be used uninitialized in this function [-Wuninitialized]: 496:18 => 
  - drivers/leds/leds-lp5523.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]: 252:9 => 
  - drivers/leds/leds-lp5523.c: warning: 'vdd' may be used uninitialized in this function [-Wuninitialized]: 471:5 => 
  - drivers/media/dvb-frontends/drxk_hard.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]: 5467:5 => 
  - drivers/media/usb/pwc/pwc-if.c: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]: 1003:16 => 
  - drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]: 6884:13 => 
  - drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 163:5, 163:26 => 163:5
  - drivers/mfd/tps6586x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 409:16 => 
  - drivers/mmc/card/block.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 370:6 => 
  - drivers/mmc/host/tmio_mmc_dma.c: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]: 203:2, 122:144, 122:2, 203:144 => 203:2, 122:2
  - drivers/mtd/chips/cfi_cmdset_0001.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1700:9 => 
  - drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 727:2, 1492:9, 1471:145, 1854:7, 1431:7 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1257:10, 474:31, 1111:10, 827:10 => 
  - drivers/mtd/chips/cfi_util.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 42:3 => 
  - drivers/mtd/chips/jedec_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1893:24, 1906:2 => 
  - drivers/mtd/devices/docprobe.c: warning: #warning Unknown architecture for DiskOnChip. No default probe locations defined [-Wcpp]: 74:2 => 
  - drivers/mtd/devices/phram.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]: 262:8 => 
  - drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20 => 
  - drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 53:2 => 
  - drivers/mtd/nand/diskonchip.c: warning: #warning Unknown architecture for DiskOnChip. No default probe locations defined [-Wcpp]: 57:2 => 
  - drivers/net/ethernet/dec/ewrk3.c: warning: return from incompatible pointer type [enabled by default]: 1915:111 => 
  - drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c: warning: value computed is not used [-Wunused-value]: 1544:938, 1517:2121, 1517:973, 1400:939, 1571:992, 1466:991, 1371:2051, 1540:2361, 1009:501, 1631:974, 1466:2169, 1380:939, 1519:937, 1410:2051, 1367:2081, 1627:973, 1380:2135, 1385:940, 1444:967, 1539:961, 1375:2135, 1569:2091, 1379:939, 1337:937, 1626:2103, 1569:961, 1539:2091, 1626:973, 1523:461, 1576:992, 1370:939, 1625:2121, 1571:2362, 1627:2151, 1371:939, 1410:939, 1367:939, 1625:973, 1375:939, 1444:2103, 1540:991, 1644:1040, 1374:939, 1593:938, 1445:997, 1469:938 => 1066:501, 311:391, 314:2, 1078:2, 1078:501, 298:391, 311:2, 298:2, 1066:2, 314:391
  - drivers/net/hamradio/baycom_ser_fdx.c: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]: 328:7 => 
  - drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat]: 4139:2 => 
  - drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'w' may be used uninitialized in this function [-Wuninitialized]: 733:9 => 
  - drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]: 164:12, 205:17 => 
  - drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]: 125:26 => 
  - drivers/regulator/max8925-regulator.c: warning: 'ri' may be used uninitialized in this function [-Wuninitialized]: 249:28 => 
  - drivers/scsi/aacraid/src.c: warning: right shift count >= width of type [enabled by default]: 434:2, 410:3, 410:132 => 434:2, 410:3
  - drivers/scsi/advansys.c: warning: label 'err_unmap' defined but not used [-Wunused-label]: 12378:2 => 
  - drivers/scsi/g_NCR5380.c: warning: 'id_table' defined but not used [-Wunused-variable]: 942:32 => 
  - drivers/scsi/lpfc/lpfc_els.c: warning: 'cmd' may be used uninitialized in this function [-Wuninitialized]: 4837:11 => 
  - drivers/scsi/lpfc/lpfc_els.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]: 4836:14 => 
  - drivers/scsi/mvsas/mv_sas.c: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]: 1159:39, 1156:57, 1156:34, 1156:396, 1159:62, 1159:110, 1159:397, 1156:107 => 1159:39, 1156:34
  - drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 3104 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 931:1 => 
  - drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 3108 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 931:1 => 
  - drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 4136 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 931:1 => 
  - drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 4144 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 931:1 => 
  - drivers/staging/ced1401/ced_ioc.c: warning: the frame size of 4144 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 931:1 => 
  - drivers/staging/dgrp/dgrp_tty.c: warning: 'arg' may be used uninitialized in this function [-Wuninitialized]: 2289:16 => 
  - drivers/staging/dgrp/dgrp_tty.c: warning: 'new_rate' may be used uninitialized in this function [-Wuninitialized]: 2339:5 => 
  - drivers/staging/media/dt3155v4l/dt3155v4l.c: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]: 399:17 => 
  - drivers/staging/media/lirc/lirc_serial.c: warning: return from incompatible pointer type [enabled by default]: 1301:1, 1301:114 => 
  - drivers/staging/rts_pstor/sd.c: warning: 'rsp_len' may be used uninitialized in this function [-Wuninitialized]: 3625:7 => 
  - drivers/staging/silicom/bp_proc.c: warning: 'bp_procfs_dir' defined but not used [-Wunused-variable]: 74:31 => 
  - drivers/staging/silicom/bp_proc.c: warning: 'proc_getdir' defined but not used [-Wunused-function]: 76:31 => 
  - drivers/staging/speakup/synth.c: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]: 142:6 => 
  - drivers/staging/vt6656/iwctl.c: warning: the frame size of 1280 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 683:1 => 
  - drivers/staging/vt6656/iwctl.c: warning: the frame size of 1288 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 683:1 => 
  - drivers/staging/vt6656/iwctl.c: warning: the frame size of 1292 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 683:1 => 
  - drivers/staging/vt6656/iwctl.c: warning: the frame size of 1296 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 683:1 => 
  - drivers/staging/vt6656/main_usb.c: warning: the frame size of 1280 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2016:1 => 
  - drivers/staging/vt6656/main_usb.c: warning: the frame size of 1288 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2016:1 => 
  - drivers/staging/vt6656/main_usb.c: warning: the frame size of 1872 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2016:1 => 
  - drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]: 2264:7 => 
  - drivers/tty/serial/8250/8250.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1667:35, 1669:18, 1667:32, 1667:28, 1667:2, 1672:18 => 1752:28, 1757:18, 1754:18, 1752:32, 1752:2
  - drivers/usb/musb/musb_core.c: warning: label 'fail5' defined but not used [-Wunused-label]: 2032:1 => 
  - drivers/usb/musb/musb_core.c: warning: unused variable 'ctrl_base' [-Wunused-variable]: 2092:16, 2092:8 => 2041:16
  - drivers/usb/musb/musb_io.h: warning: statement with no effect [-Wunused-value]: 48:4, 46:4, 50:4 => 
  - drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used [-Wunused-variable]: 534:13 => 
  - drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used [-Wunused-variable]: 535:13 => 
  - drivers/virtio/virtio_mmio.c: warning: format '%u' expects argument of type 'unsigned int *', but argument 4 has type 'resource_size_t *' [-Wformat]: 535:4 => 
  - drivers/virtio/virtio_ring.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 392:10, 392:9 => 384:9
  - fs/jbd2/commit.c: warning: 'jbd2_block_tag_csum_set.isra.3' uses dynamic stack allocation [enabled by default]: 360:1 => 
  - fs/jbd2/commit.c: warning: 'jbd2_commit_block_csum_set' uses dynamic stack allocation [enabled by default]: 104:1 => 
  - fs/jbd2/commit.c: warning: 'jbd2_descr_block_csum_set' uses dynamic stack allocation [enabled by default]: 339:1 => 
  - fs/jbd2/journal.c: warning: 'jbd2_journal_set_features' uses dynamic stack allocation [enabled by default]: 1802:1 => 
  - fs/jbd2/journal.c: warning: 'jbd2_superblock_csum' uses dynamic stack allocation [enabled by default]: 119:1 => 
  - fs/jbd2/journal.c: warning: 'journal_get_superblock' uses dynamic stack allocation [enabled by default]: 1505:1 => 
  - fs/jbd2/recovery.c: warning: 'jbd2_block_tag_csum_verify.isra.0' uses dynamic stack allocation [enabled by default]: 414:1 => 
  - fs/jbd2/recovery.c: warning: 'jbd2_commit_block_csum_verify' uses dynamic stack allocation [enabled by default]: 397:1 => 
  - fs/jbd2/recovery.c: warning: 'jbd2_descr_block_csum_verify' uses dynamic stack allocation [enabled by default]: 195:1 => 
  - fs/jbd2/recovery.c: warning: 'jbd2_revoke_block_csum_verify' uses dynamic stack allocation [enabled by default]: 826:1 => 
  - fs/jbd2/revoke.c: warning: 'jbd2_revoke_csum_set' uses dynamic stack allocation [enabled by default]: 655:1 => 
  - fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]: 1663:17 => 
  - fs/nfs/nfs4xdr.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1749:1 => 
  - fs/nfs/nfs4xdr.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1749:1 => 
  - fs/nfsd/nfs4state.c: warning: control reaches end of non-void function [-Wreturn-type]: 530:1 => 
  - fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function [-Wuninitialized]: 208:55, 208:32 => 214:32
  - fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function [-Wuninitialized]: 208:40, 208:17 => 214:17
  - fs/pstore/ftrace.c: warning: (near initialization for 'pstore_ftrace_ops.func') [enabled by default]: 51:2 => 
  - fs/pstore/ftrace.c: warning: initialization from incompatible pointer type [enabled by default]: 51:2 => 
  - fs/quota/quota.c: warning: 'quotactl_cmd_write' defined but not used [-Wunused-function]: 311:12 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'insb' makes integer from pointer without a cast [enabled by default]: 232:2 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'insl' makes integer from pointer without a cast [enabled by default]: 222:2 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'insw' makes integer from pointer without a cast [enabled by default]: 227:2 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'outsb' makes integer from pointer without a cast [enabled by default]: 247:2 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'outsl' makes integer from pointer without a cast [enabled by default]: 237:2 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'outsw' makes integer from pointer without a cast [enabled by default]: 242:2 => 
  - include/linux/mtd/cfi.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 505:3, 489:3 => 
  - include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 323:17, 394:11, 364:14, 331:11, 346:2, 277:6, 278:4, 411:2, 289:22 => 
  - include/linux/rbtree_augmented.h: warning: '__rb_erase_color' declared inline after being called: 124, 123 => 
  - include/linux/rbtree_augmented.h: warning: previous declaration of '__rb_erase_color' was here: 124, 123 => 
  - include/linux/rculist.h: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]: 39:92 => 
  - include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]: 59:5 => 
  - include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]: 50:5 => 
  - ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]: 1570:26 => 
  - kernel/cgroup.c: warning: integer overflow in expression [-Woverflow]: 4257:32, 4257:21 => 
  - kernel/sched/fair.c: warning: 'unthrottle_offline_cfs_rqs' defined but not used [-Wunused-function]: 2055:13 => 
  - kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]: 2396:8 => 
  - lib/rbtree_test.c: warning: 'blacks' may be used uninitialized in this function [-Wuninitialized]: 132:4, 132:99 => 
  - mm/slub.c: warning: '__slab_alloc.constprop.40' uses dynamic stack allocation [enabled by default]: 2305:1 => 
  - mm/slub.c: warning: 'get_partial_node.isra.31' uses dynamic stack allocation [enabled by default]: 1577:1 => 
  - mm/slub.c: warning: 'unfreeze_partials' uses dynamic stack allocation [enabled by default]: 1934:1 => 
  - mm/swapfile.c: warning: 'nr_extents' may be used uninitialized in this function [-Wuninitialized]: 2029:1083 => 
  - modpost: WARNING: modpost: Found 13 section mismatch(es).: N/A => 
  - warning: (DRM) selects DMA_SHARED_BUFFER which has unmet direct dependencies (EXPERIMENTAL): N/A => 
  - warning: (PATA_QDI && PATA_WINBOND_VLB) selects PATA_LEGACY which has unmet direct dependencies (ATA && ATA_SFF && (ISA || PCI) && EXPERIMENTAL): N/A => 
  - warning: (PLATFORM_AT32AP) selects HAVE_NET_MACB which has unmet direct dependencies (NETDEVICES && ETHERNET): N/A => 
  - warning: (SCSI_SRP) selects SCSI_TGT which has unmet direct dependencies (SCSI && EXPERIMENTAL): N/A => 
  - warning: (XEN_FBDEV_FRONTEND) selects INPUT_XEN_KBDDEV_FRONTEND which has unmet direct dependencies (!S390 && !UML && INPUT && INPUT_MISC && XEN): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x18064): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: arch/powerpc/platforms/built-in.o(.text+0x18084): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: arch/powerpc/platforms/pseries/built-in.o(.text+0x43c4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xe1e8): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xf794): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: drivers/built-in.o(.data+0x23d7e0): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable: N/A => 
  - warning: drivers/built-in.o(.data+0x700): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0x79c): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0x8ec): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0x9ec): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xa48): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xaa4): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xb0c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xcb0): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x38): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DevicePresent(): N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x9a): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature(): N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0xe8): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x160): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x1fc): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x34c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x44c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x4a8): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x504): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x56c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x710): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:attach_one_i2c.constprop.0(): N/A => 
  - warning: drivers/spi/built-in.o(.devinit.text+0x1cc4): Section mismatch in reference from the function rspi_probe() to the function .devexit.text:spidev_remove(): N/A => 
  - warning: drivers/staging/built-in.o(.data+0x9698): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable: N/A => 
  - warning: drivers/staging/ipack/bridges/built-in.o(.data+0x18): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable: N/A => 
  - warning: drivers/staging/ipack/bridges/tpci200.o(.data+0x14): Section mismatch in reference from the variable tpci200_pci_drv to the function .devexit.text:tpci200_pci_remove(): N/A => 
  - warning: drivers/staging/ipack/bridges/tpci200.o(.data+0x18): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable: N/A => 
  - warning: drivers/staging/ipack/bridges/tpci200.o(.data+0x28): Section mismatch in reference from the variable tpci200_pci_drv to the function .devexit.text:tpci200_pci_remove(): N/A => 
  - warning: drivers/staging/ipack/bridges/tpci200.o(.data+0xc): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable: N/A => 
  - warning: drivers/staging/ipack/built-in.o(.data+0x270): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable: N/A => 
  - warning: mm/built-in.o(.meminit.text+0x1050): Section mismatch in reference from the function .free_area_init_core.isra.36() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.data+0x2b3648): Section mismatch in reference from the variable tpci200_pci_drv to the variable .devinit.rodata:tpci200_idtable: N/A => 
  - warning: vmlinux.o(.devinit.literal+0x1c0): Section mismatch in reference from the (unknown reference) (unknown) to the function .init.text:pcibios_fixup_bus(): N/A => 
  - warning: vmlinux.o(.devinit.text+0x8f4): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus(): N/A => 
  - warning: vmlinux.o(.meminit.text+0x1460): Section mismatch in reference from the function .free_area_init_core.isra.36() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.text+0x10edee8): Section mismatch in reference from the function .dlpar_add_slot() to the function .devinit.text:.init_phb_dynamic(): N/A => 
  - warning: vmlinux.o(.text+0x10ee3f0): Section mismatch in reference from the function .dlpar_remove_slot() to the function .devinit.text:.vio_unregister_device(): N/A => 
  - warning: vmlinux.o(.text+0x2be9c): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x2bf5c): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x36a4): Section mismatch in reference from the function pgd_ctor() to the function .init.text:__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x4043): Section mismatch in reference from the function iss_net_setup() to the function .init.text:__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x4e370): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x4f84c): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x732d8): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x75d84): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x8ba08): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0x8ba24): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: vmlinux.o(.text+0x8e4c8): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0x8e4e4): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.eeh_dev_init(): N/A => 
  - warning: vmlinux.o(.text+0x90ebc): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x9397c): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x93ec): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x9400): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x9946c): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0x994f8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0x9955c): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 
  - warning: vmlinux.o(.text+0x9c4b8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0x9c544): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0x9c5a8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
