Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3CSUt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:49:26 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:59998 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3CSUtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:49:20 -0400
Date: Tue, 19 Mar 2013 21:49:16 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.9-rc3
Message-ID: <alpine.DEB.2.00.1303192148530.18971@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.9-rc3[1] compared to v3.8[2].

Summarized:
  - build errors: +17/-52
  - build warnings: +154/-371

JFYI, when comparing v3.9-rc3 to v3.9-rc2[3], the summaries are:
  - build errors: +10/-12
  - build warnings: +48/-38

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.9-rc3.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/5993/ (118 out of 117 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/5896/ (all 117 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/5972/ (all 117 configs)


*** ERRORS ***

17 regressions:
  + arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards:  => 1304
  + arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'inhibit_secondary_onlining' [-Werror=implicit-function-declaration]:  => 1855:2
  + arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'uninhibit_secondary_onlining' [-Werror=implicit-function-declaration]:  => 1862:2
  + arch/sh/kernel/kgdb.c: error: 'SIGTRAP' undeclared (first use in this function):  => 310:27
  + arch/sh/kernel/kgdb.c: error: dereferencing pointer to incomplete type:  => 243:22, 242:23
  + arch/sh/kernel/kgdb.c: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]:  => 225:32
  + error: "_spill_registers" [arch/xtensa/oprofile/oprofile.ko] undefined!:  => N/A
  + error: "common_exception_return" [arch/xtensa/oprofile/oprofile.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/dma/dw_dmac.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/i2c/busses/i2c-ocores.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/i2c/i2c-smbus.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/media/platform/sh_veu.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/spi/spi-altera.ko] undefined!:  => N/A
  + error: "kernel_text_address" [arch/xtensa/oprofile/oprofile.ko] undefined!:  => N/A
  + error: "mfd_add_devices" [drivers/mfd/lpc_sch.ko] undefined!:  => N/A
  + error: "mfd_remove_devices" [drivers/mfd/lpc_sch.ko] undefined!:  => N/A
  + error: "vgacon_remap_base" [drivers/video/vga16fb.ko] undefined!:  => N/A

52 improvements:
  - arch/parisc/hpux/fs.c: error: too many arguments to function 'do_execve': 47:6 => 
  - drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'handle_nested_irq' [-Werror=implicit-function-declaration]: 209:4 => 
  - drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_alloc_descs' [-Werror=implicit-function-declaration]: 281:3 => 
  - drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_data_get_irq_chip_data' [-Werror=implicit-function-declaration]: 54:9 => 
  - drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_chip' [-Werror=implicit-function-declaration]: 229:2 => 
  - drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_chip_data' [-Werror=implicit-function-declaration]: 228:2 => 
  - drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_irq_wake' [-Werror=implicit-function-declaration]: 98:4 => 
  - drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_nested_thread' [-Werror=implicit-function-declaration]: 230:2 => 
  - drivers/base/regmap/regmap-irq.c: error: implicit declaration of function 'irq_set_noprobe' [-Werror=implicit-function-declaration]: 237:2 => 
  - drivers/firewire/ohci.c: error: 'pci_probe' redeclared as different kind of symbol: 3540:12 => 
  - drivers/gpu/drm/ast/ast_mode.c: error: conflicting types for 'get_clock': 871:12 => 
  - drivers/gpu/drm/ast/ast_mode.c: error: conflicting types for 'set_clock': 891:13 => 
  - drivers/gpu/drm/radeon/radeon_i2c.c: error: conflicting types for 'get_clock': 176:12 => 
  - drivers/gpu/drm/radeon/radeon_i2c.c: error: conflicting types for 'set_clock': 205:13 => 
  - drivers/gpu/drm/udl/udl_fb.c: error: 'PAGE_SHARED' undeclared (first use in this function): 237:52 => 
  - drivers/media/pci/zoran/zoran_driver.c: error: 'PAGE_SHARED' undeclared (first use in this function): 2955:14 => 
  - drivers/media/usb/cpia2/cpia2_core.c: error: 'PAGE_SHARED' undeclared (first use in this function): 2405:66 => 
  - drivers/mfd/arizona-irq.c: error: 'handle_edge_irq' undeclared (first use in this function): 147:52 => 
  - drivers/mfd/arizona-irq.c: error: implicit declaration of function 'handle_nested_irq' [-Werror=implicit-function-declaration]: 107:2 => 
  - drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_chip_and_handler' [-Werror=implicit-function-declaration]: 147:2 => 
  - drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_chip_data' [-Werror=implicit-function-declaration]: 146:2 => 
  - drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_irq_wake' [-Werror=implicit-function-declaration]: 68:2 => 
  - drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_nested_thread' [-Werror=implicit-function-declaration]: 148:2 => 
  - drivers/mfd/arizona-irq.c: error: implicit declaration of function 'irq_set_noprobe' [-Werror=implicit-function-declaration]: 155:2 => 
  - drivers/mfd/lp8788-irq.c: error: 'handle_edge_irq' undeclared (first use in this function): 140:39 => 
  - drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'handle_nested_irq' [-Werror=implicit-function-declaration]: 125:4 => 
  - drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_data_get_irq_chip_data' [-Werror=implicit-function-declaration]: 68:9 => 
  - drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_set_chip_and_handler' [-Werror=implicit-function-declaration]: 140:2 => 
  - drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_set_chip_data' [-Werror=implicit-function-declaration]: 139:2 => 
  - drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_set_nested_thread' [-Werror=implicit-function-declaration]: 141:2 => 
  - drivers/mfd/lp8788-irq.c: error: implicit declaration of function 'irq_set_noprobe' [-Werror=implicit-function-declaration]: 146:2 => 
  - drivers/net/ethernet/dlink/de600.c: error: implicit declaration of function 'outb_p' [-Werror=implicit-function-declaration]: 88:2 => 
  - drivers/scsi/lpfc/lpfc_sli.c: error: called object 'mb' is not a function: 6854:2 => 
  - drivers/tty/serial/serial_core.c: error: implicit declaration of function 'irq_canonicalize' [-Werror=implicit-function-declaration]: 724:2 => 
  - drivers/usb/gadget/pch_udc.c: error: implicit declaration of function 'irq_set_irq_type' [-Werror=implicit-function-declaration]: 1405:3 => 
  - drivers/usb/host/oxu210hp-hcd.c: error: implicit declaration of function 'irq_set_irq_type' [-Werror=implicit-function-declaration]: 3839:2 => 
  - drivers/usb/musb/tusb6010.c: error: implicit declaration of function 'irq_set_irq_type' [-Werror=implicit-function-declaration]: 923:2 => 
  - drivers/video/smscufx.c: error: 'PAGE_SHARED' undeclared (first use in this function): 795:52 => 
  - drivers/video/udlfb.c: error: 'PAGE_SHARED' undeclared (first use in this function): 337:52 => 
  - drivers/video/vfb.c: error: 'PAGE_SHARED' undeclared (first use in this function): 431:52 => 
  - error: 4965-calib.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff7ff8), (.text+0x1ff7e44) => 
  - error: 4965-debug.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff949c) => 
  - error: 4965-debug.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9348) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `.kfree' defined in .text section in mm/built-in.o: (.text+0x1ffa3dc) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_14' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff92a8) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_16' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8920) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8288) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_22' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9aa4), (.text+0x1ff94a4) => 
  - net/mac80211/led.c: error: 'struct led_classdev' has no member named 'trig_list': 278:411, 278:352, 278:59, 214:352, 214:411, 214:160, 278:319, 214:223, 214:319, 278:160, 214:59, 278:223 => 214:2, 278:2
  - sound/pci/lx6464es/lx6464es.c: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]: 1028:2 => 
  - sound/pci/lx6464es/lx6464es.c: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]: 565:2 => 
  - sound/soc/codecs/wm8903.c: error: implicit declaration of function 'irq_get_irq_data' [-Werror=implicit-function-declaration]: 1954:9 => 


*** WARNINGS ***

154 regressions:
  + .config: warning: override: SLOB changes choice state:  => 182, 183
  + arch/avr32/include/asm/param.h: warning:   UIMAGE  arch/avr32/boot/images/uImage:  => 6:1
  + arch/avr32/include/asm/param.h: warning: "HZ" redefined  CC [M]  net/ipv6/addrlabel.o:  => 6:1
  + arch/avr32/include/asm/param.h: warning: In file included from /scratch/kisskb/src/include/uapi/linux/param.h:4,:  => 6:1
  + arch/avr32/include/uapi/asm/param.h: warning: In file included from /scratch/kisskb/src/include/uapi/linux/param.h:4this is the location of the previous definition,:  => 6:1
  + arch/cris/include/arch-v10/arch/swab.h: warning: 'cur_cnid' may be used uninitialized in this function [-Wuninitialized]:  => 16:2
  + arch/cris/include/arch-v10/arch/swab.h: warning: 'search_cnid' may be used uninitialized in this function [-Wuninitialized]:  => 16:2
  + arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for ACPI_CONTAINER:  => 33
  + arch/mips/include/asm/compat.h: warning: 'handler' may be used uninitialized in this function [-Wuninitialized]:  => 208:24
  + arch/sh/include/uapi/asm/swab.h: warning: 'cur_cnid' may be used uninitialized in this function [-Wuninitialized]:  => 14:2
  + arch/sh/include/uapi/asm/swab.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 14:2
  + arch/sh/include/uapi/asm/swab.h: warning: 'search_cnid' may be used uninitialized in this function [-Wuninitialized]:  => 14:2
  + drivers/block/drbd/drbd_receiver.c: warning: 'what' may be used uninitialized in this function [-Wuninitialized]  CC      drivers/ide/ide-disk_ioctl.o:  => 5017:2
  + drivers/block/xen-blkback/blkback.c: warning: 'preq.dev' may be used uninitialized in this function [-Wuninitialized]:  => 904:3
  + drivers/gpio/gpio-langwell.c: warning: 'lnw_gpio_runtime_idle' defined but not used [-Wunused-function]:  => 306:12
  + drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 67:6
  + drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 144:5
  + drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 145:15
  + drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 145:3
  + drivers/i2c/busses/i2c-mpc.c: warning: 'mpc_i2c_resume' defined but not used [-Wunused-function]:  => 734:12
  + drivers/i2c/busses/i2c-mpc.c: warning: 'mpc_i2c_suspend' defined but not used [-Wunused-function]:  => 724:12
  + drivers/leds/leds-ot200.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 112:8 => 112:8, 114:6
  + drivers/media/dvb-frontends/af9013.c: warning: 'af9013_wr_regs_i2c' uses dynamic stack allocation [enabled by default]:  => 77:1
  + drivers/media/dvb-frontends/af9033.c: warning: 'af9033_wr_regs' uses dynamic stack allocation [enabled by default]:  => 68:1
  + drivers/media/dvb-frontends/rtl2830.c: warning: 'rtl2830_wr' uses dynamic stack allocation [enabled by default]:  => 56:1
  + drivers/media/dvb-frontends/rtl2832.c: warning: 'rtl2832_wr' uses dynamic stack allocation [enabled by default]:  => 187:1
  + drivers/media/dvb-frontends/stb6100.c: warning: 'stb6100_write_reg_range.constprop.3' uses dynamic stack allocation [enabled by default]:  => 216:1
  + drivers/media/dvb-frontends/stv0367.c: warning: 'stv0367_writeregs.constprop.4' uses dynamic stack allocation [enabled by default]:  => 791:1
  + drivers/media/dvb-frontends/stv6110.c: warning: 'stv6110_write_regs' uses dynamic stack allocation [enabled by default]:  => 98:1
  + drivers/media/i2c/as3645a.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 273:2
  + drivers/media/i2c/as3645a.c: warning: 'on' may be used uninitialized in this function [-Wuninitialized]:  => 273:28
  + drivers/media/pci/cx23885/cimax2.c: warning: 'netup_write_i2c' uses dynamic stack allocation [enabled by default]:  => 149:1
  + drivers/media/pci/cx25821/cx25821-audio-upstream.c: warning: 'cx25821_get_audio_data.isra.4' uses dynamic stack allocation [enabled by default]:  => 337:1
  + drivers/media/pci/cx25821/cx25821-audio-upstream.c: warning: 'cx25821_openfile_audio.isra.2' uses dynamic stack allocation [enabled by default]:  => 433:1
  + drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: warning: 'cx25821_get_frame_ch2.isra.6' uses dynamic stack allocation [enabled by default]:  => 348:1
  + drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: warning: 'cx25821_openfile_ch2.isra.4' uses dynamic stack allocation [enabled by default]:  => 445:1
  + drivers/media/pci/cx25821/cx25821-video-upstream.c: warning: 'cx25821_get_frame.isra.6' uses dynamic stack allocation [enabled by default]:  => 392:1
  + drivers/media/pci/cx25821/cx25821-video-upstream.c: warning: 'cx25821_openfile.isra.4' uses dynamic stack allocation [enabled by default]:  => 489:1
  + drivers/media/tuners/e4000.c: warning: 'e4000_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]:  => 81:1
  + drivers/media/tuners/e4000.c: warning: 'e4000_wr_regs' uses dynamic stack allocation [enabled by default]:  => 49:1
  + drivers/media/tuners/fc2580.c: warning: 'fc2580_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]:  => 98:1
  + drivers/media/tuners/fc2580.c: warning: 'fc2580_wr_regs.constprop.1' uses dynamic stack allocation [enabled by default]:  => 66:1
  + drivers/media/tuners/tda18212.c: warning: 'tda18212_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]:  => 90:1
  + drivers/media/tuners/tda18212.c: warning: 'tda18212_wr_regs' uses dynamic stack allocation [enabled by default]:  => 57:1
  + drivers/media/tuners/tda18218.c: warning: 'tda18218_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]:  => 92:1
  + drivers/media/tuners/tda18218.c: warning: 'tda18218_wr_regs' uses dynamic stack allocation [enabled by default]:  => 60:1
  + drivers/media/usb/dvb-usb-v2/af9015.c: warning: 'af9015_eeprom_hash' uses dynamic stack allocation [enabled by default]:  => 430:1
  + drivers/media/usb/dvb-usb-v2/af9035.c: warning: 'af9035_i2c_master_xfer' uses dynamic stack allocation [enabled by default]:  => 281:1
  + drivers/media/usb/dvb-usb-v2/af9035.c: warning: 'af9035_wr_regs' uses dynamic stack allocation [enabled by default]:  => 136:1
  + drivers/media/usb/dvb-usb-v2/mxl111sf.c: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]:  => 80:1
  + drivers/media/usb/dvb-usb/cxusb.c: warning: 'cxusb_ctrl_msg' uses dynamic stack allocation [enabled by default]:  => 69:1
  + drivers/media/usb/dvb-usb/cxusb.c: warning: 'cxusb_i2c_xfer' uses dynamic stack allocation [enabled by default]:  => 209:1
  + drivers/media/usb/dvb-usb/dibusb-common.c: warning: 'dibusb_i2c_msg' uses dynamic stack allocation [enabled by default]:  => 122:1
  + drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw2102_earda_i2c_transfer' uses dynamic stack allocation [enabled by default]:  => 365:1
  + drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw2104_i2c_transfer' uses dynamic stack allocation [enabled by default]:  => 446:1
  + drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw3101_i2c_transfer' uses dynamic stack allocation [enabled by default]:  => 509:1
  + drivers/media/usb/dvb-usb/dw2102.c: warning: 's6x0_i2c_transfer' uses dynamic stack allocation [enabled by default]:  => 618:1
  + drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6884:13
  + drivers/mfd/sec-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 153:10
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 1700:9
  + drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_is_locked' defined but not used:  => 2388
  + drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_lock' defined but not used:  => 2283
  + drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_unlock' defined but not used:  => 2290
  + drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 1884:7, 1510:9, 745:2, 1449:7
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1200 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1444 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1992 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 654:1
  + drivers/mtd/chips/cfi_util.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 42:3
  + drivers/mtd/chips/jedec_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 1893:24, 1906:2
  + drivers/net/wireless/iwlegacy/3945-mac.c: warning: 'phys_addr' may be used uninitialized in this function [-Wuninitialized]:  => 618:33
  + drivers/net/wireless/iwlegacy/4965-mac.c: warning: 'phys_addr' may be used uninitialized in this function [-Wuninitialized]:  => 1847:33
  + drivers/net/wireless/iwlwifi/mvm/nvm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 273:6
  + drivers/net/wireless/mac80211_hwsim.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 443:20
  + drivers/net/wireless/mwifiex/pcie.c: warning: 'desc' may be used uninitialized in this function [-Wuninitialized]:  => 1145:9
  + drivers/net/wireless/mwifiex/pcie.c: warning: 'desc2' may be used uninitialized in this function [-Wuninitialized]:  => 1143:9
  + drivers/net/wireless/p54/lmac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[3]' [-Wattributes]  CC [M]  net/sctp/primitive.o:  => 377:2
  + drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]:  => 693:12
  + drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]:  => 724:13
  + drivers/scsi/scsi_debug.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 2035:9, 2056:9, 2008:2, 1889:11, 1798:13, 1728:14
  + drivers/scsi/scsi_debug.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 2008:2, 1889:2, 1798:4, 1728:2, 2035:3, 2056:3
  + drivers/scsi/scsi_debug.c: warning: right shift count >= width of type [enabled by default]:  => 2008:2, 1889:2, 1798:4, 1728:2, 2035:3, 2056:3
  + drivers/staging/media/lirc/lirc_zilog.c: warning: 'read' uses dynamic stack allocation [enabled by default]:  => 967:1
  + drivers/staging/zcache/zcache-main.c: warning: 'cli' may be used uninitialized in this function [-Wuninitialized]:  => 1598:13, 1598:3
  + drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 622:11, 566:10
  + drivers/video/backlight/max8925_bl.c: warning: statement with no effect [-Wunused-value]:  => 177:3
  + drivers/virtio/virtio_pci.c: warning: 'virtio_pci_freeze' defined but not used [-Wunused-function]:  => 769:12
  + drivers/virtio/virtio_pci.c: warning: 'virtio_pci_restore' defined but not used [-Wunused-function]:  => 789:12
  + drivers/w1/slaves/w1_therm.c: warning: 'crc' may be used uninitialized in this function [-Wuninitialized]:  => 254:15
  + fs/btrfs/raid56.c: warning: 'finish_rmw' uses dynamic stack allocation [enabled by default]:  => 1266:1
  + fs/ext4/inode.c: warning: 'retval' may be used uninitialized in this function [-Wuninitialized]:  => 569:5
  + fs/hfsplus/bfind.c: warning: 'cur_cnid' may be used uninitialized in this function [-Wuninitialized]:  => 78:6
  + fs/hfsplus/bfind.c: warning: 'search_cnid' may be used uninitialized in this function [-Wuninitialized]:  => 78:6
  + fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32' [-Wattributes]  CC      drivers/staging/android/ashmem.o:  => 124:4
  + include/asm-generic/io.h: warning: passing argument 1 of 'readl' makes pointer from integer without a cast [enabled by default]:  => 139:2
  + include/asm-generic/io.h: warning: passing argument 1 of 'readw' makes pointer from integer without a cast [enabled by default]:  => 134:2
  + include/linux/irq_work.h: warning: 'irq_work_needs_cpu' defined but not used:  => 40
  + include/linux/mtd/cfi.h: warning: #warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work. [-Wcpp]:  => 76:2
  + include/linux/mtd/cfi.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 505:3, 489:3
  + include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 279:4, 349:2, 324:17, 278:6, 367:14, 290:22, 414:2, 332:11, 397:11
  + include/linux/thermal.h: warning: 'thermal_generate_netlink_event' defined but not used [-Wunused-function]:  => 254:12
  + include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
  + kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]:  => 334:22
  + kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]:  => 270:13
  + kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]:  => 247:13
  + kernel/rcutree.c: warning: unused variable 'idle' [-Wunused-variable]:  => 345:23, 501:23
  + mm/memory_hotplug.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'unsigned int' [-Wformat]:  => 1685:3
  + mm/memory_hotplug.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]:  => 1685:3
  + modpost: WARNING: modpost: Found 10 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 11 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 12 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 13 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 9 section mismatch(es).:  => N/A
  + net/core/dev_ioctl.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 279:10, 159:11
  + net/packet/af_packet.c: warning: 'hdrlen' may be used uninitialized in this function [-Wuninitialized]  CC      drivers/pci/rom.o:  => 1780:16
  + security/integrity/ima/ima_crypto.c: warning: 'ima_calc_boot_aggregate' uses dynamic stack allocation [enabled by default]:  => 148:1
  + security/integrity/ima/ima_crypto.c: warning: 'ima_calc_buffer_hash' uses dynamic stack allocation [enabled by default]:  => 109:1
  + security/integrity/ima/ima_crypto.c: warning: 'ima_calc_file_hash' uses dynamic stack allocation [enabled by default]:  => 93:1
  + sound/soc/atmel/atmel-pcm.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 52:2
  + sound/soc/codecs/max98090.c: warning: 'max98090_runtime_resume' defined but not used [-Wunused-function]:  => 2352:12
  + sound/soc/codecs/max98090.c: warning: 'max98090_runtime_suspend' defined but not used [-Wunused-function]:  => 2363:12
  + sound/soc/codecs/wm_hubs.c: warning: 'reg_l' may be used uninitialized in this function [-Wuninitialized]:  => 322:11
  + sound/soc/codecs/wm_hubs.c: warning: 'reg_r' may be used uninitialized in this function [-Wuninitialized]:  => 321:11
  + warning: "HZ" redefined:  => N/A
  + warning: (CAN_PEAK_PCIEC && SFC && IGB && DRM && FB_DDC && FB_BFIN_7393 && FB_VIA && SND_AOA_ONYX && SND_AOA_TAS && SND_SOC_BFIN_EVAL_ADAU1701 && FB_OLPC_DCON) selects I2C which has unmet direct dependencies (!S390):  => N/A
  + warning: (DRM_RADEON && DRM_I915 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (FSL_SOC) selects HAVE_CAN_FLEXCAN which has unmet direct dependencies (NET && CAN && CAN_DEV):  => N/A
  + warning: (HAVE_TEXT_POKE_SMP) selects STOP_MACHINE which has unmet direct dependencies (SMP && MODULE_UNLOAD || HOTPLUG_CPU):  => N/A
  + warning: (I2C_ISCH && GPIO_SCH && IE6XX_WDT) selects LPC_SCH which has unmet direct dependencies (HAS_IOMEM && PCI && GENERIC_HARDIRQS):  => N/A
  + warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
  + warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || ARCH_WANT_FRAME_POINTERS):  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22f76): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32800:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22fe2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32800:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x23012): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32797:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x2307e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32797:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x8dc8): Section mismatch in reference from the variable start_secondary_resume to the function .cpuinit.text:start_secondary():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.cpuinit.text+0x292): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline:  => N/A
  + warning: arch/powerpc/mm/built-in.o(.cpuinit.text+0x2a2): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline:  => N/A
  + warning: arch/powerpc/mm/built-in.o(.cpuinit.text+0x396): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline:  => N/A
  + warning: arch/powerpc/mm/built-in.o(.cpuinit.text+0x39e): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline:  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x3fa4): Section mismatch in reference from the function fsl_pci_probe() to the function .init.text:fsl_add_bridge():  => N/A
  + warning: drivers/built-in.o(.text+0x32780e): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/built-in.o(.text+0x32781e): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1366): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/video/built-in.o(.text+0x2997a6): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/video/built-in.o(.text+0x2997b6): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: mm/built-in.o(.meminit.text+0x1150): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x14e4e4): Section mismatch in reference from the function pwmchip_add() to the function .init.text:pcibios_fixup_bus():  => N/A
  + warning: vmlinux.o(.text+0x1524ec): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus():  => N/A
  + warning: vmlinux.o(.text+0x1b608): Section mismatch in reference from the function fsl_pci_probe() to the function .init.text:fsl_add_bridge():  => N/A
  + warning: vmlinux.o(.text+0x3c74): Section mismatch in reference from the function pgd_ctor() to the function .init.text:__alloc_bootmem():  => N/A
  + warning: vmlinux.o(.text+0x4677): Section mismatch in reference from the function iss_net_setup() to the function .init.text:__alloc_bootmem():  => N/A
  + warning: vmlinux.o(.text+0x99e8): Section mismatch in reference from the variable start_secondary_resume to the function .cpuinit.text:start_secondary():  => N/A

371 improvements:
  - ...../scratch/kisskb/src/drivers/scsi/advansys.c: warning: #warning this driver is still not properly converted to the DMA API [-Wcpp]: 71:2 => 
  - arch/alpha/kernel/process.c: warning: unused variable 'settls': 253 => 
  - arch/parisc/kernel/signal.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 285:2499, 285:1165 => 
  - arch/parisc/mm/init.c: warning: array subscript is above array bounds [-Warray-bounds]: 152:40, 144:19, 153:15, 150:15 => 
  - arch/sh/kernel/cpu/clock-cpg.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c:46) [-Wdeprecated-declarations]/scratch/kisskb/src/arch/sh/math-emu/math.c:108:1: warning: statement with no effect [-Wunused-value]: 73:2 => 
  - arch/sh/math-emu/math.c: warning: left shift count >= width of type [enabled by default]: 108:2620, 115:2620, 145:2, 122:2620, 310:1, 334:2, 122:13306, 310:325, 115:1, 122:1, 108:1 => 334:2, 145:2, 310:1, 122:1, 115:1, 108:1
  - arch/sh/math-emu/math.c: warning: left shift count is negative [enabled by default]: 333:1, 129:2620, 115:2620, 122:2620, 92:2569, 92:445, 310:325, 129:1, 115:1, 92:1, 108:1, 81:1, 108:496, 333:254, 108:2620, 122:496, 115:496, 310:1, 81:445, 81:2569, 323:2, 122:1, 129:496 => 333:1, 323:2, 129:1, 310:1, 122:1, 115:1, 92:1, 108:1, 81:1
  - arch/sh/math-emu/math.c: warning: right shift count is negative [enabled by default]: 108:2620, 324:2, 129:2620, 115:2620, 145:2, 122:2620, 310:1, 334:2, 122:13306, 310:325, 129:1, 122:1, 115:1, 294:3, 108:1 => 324:2, 145:2, 310:1, 334:2, 129:1, 115:1, 122:1, 294:3, 108:1
  - arch/sh/math-emu/math.c: warning: statement with no effect [-Wunused-value]: 108:8777, 108:10498, 147:239, 122:10772, 122:7940, 147:1, 129:10013, 324:356, 122:17986, 115:19005, 115:1, 335:1891, 108:1, 324:3188, 108:11609, 296:3624, 129:12845, 129:19949, 108:17894, 129:18926, 335:239, 115:10542, 122:17357, 122:16334, 294:2412, 294:4133, 296:1, 324:1, 115:11653, 108:19546, 115:17982, 115:8821, 335:1262, 296:1972, 129:1, 335:1, 294:5244, 129:11734, 147:1262, 324:2077, 108:18917, 147:1891, 294:1, 115:19634, 122:9661, 129:20578, 296:2995, 122:1 => 147:1, 294:1, 129:1, 115:1, 122:1, 296:1, 335:1, 108:1, 324:1
  - arch/x86/kernel/apm_32.c: warning: #warning deprecated CONFIG_APM_CPU_IDLE will be deleted in 2012 [-Wcpp]: 363:2 => 
  - crypto/ctr.c: warning: 'crypto_rfc3686_crypt' uses dynamic stack allocation [enabled by default]: 300:1 => 
  - drivers/ata/acard-ahci.c: warning: value computed is not used [-Wunused-value]: 151:3 => 
  - drivers/ata/ahci.c: warning: value computed is not used [-Wunused-value]: 613:3 => 
  - drivers/ata/ahci_platform.c: warning: value computed is not used [-Wunused-value]: 270:2 => 
  - drivers/ata/libahci.c: warning: value computed is not used [-Wunused-value]: 629:2, 831:453, 576:476, 576:2, 1446:477, 1258:3, 697:4, 1446:3, 697:478, 1258:507, 629:476, 831:4 => 
  - drivers/ata/pata_pdc2027x.c: warning: value computed is not used [-Wunused-value]: 614:491, 631:2, 631:491, 614:2 => 
  - drivers/ata/sata_highbank.c: warning: value computed is not used [-Wunused-value]: 393:2 => 
  - drivers/ata/sata_promise.c: warning: value computed is not used [-Wunused-value]: 460:2, 1032:2, 758:2, 764:2, 401:2, 758:486, 1174:496, 1032:481, 931:2, 401:521, 784:2, 1037:2, 931:486, 784:506, 764:486, 1037:501, 405:521, 747:506, 726:486, 726:2, 405:2, 1174:2, 460:456, 747:2 => 
  - drivers/ata/sata_qstor.c: warning: value computed is not used [-Wunused-value]: 327:2, 327:461 => 
  - drivers/ata/sata_sil.c: warning: value computed is not used [-Wunused-value]: 563:2, 388:2, 388:396, 563:486 => 
  - drivers/ata/sata_sx4.c: warning: value computed is not used [-Wunused-value]: 510:2, 1084:512, 579:2, 1219:496, 1435:491, 1087:3, 1435:2, 1295:2, 1087:492, 545:421, 1098:3, 1071:511, 1078:2, 1095:3, 669:552, 1250:497, 1095:512, 1428:491, 1098:492, 1242:2, 579:506, 906:2, 1334:2, 755:4, 752:4, 865:466, 1242:496, 1071:2, 1084:3, 576:551, 882:2, 906:396, 1219:2, 673:3, 1334:481, 1078:491, 882:466, 576:2, 1250:3, 865:2, 752:553, 673:557, 1119:496, 669:3, 510:421, 1295:491, 1428:2, 1119:2, 545:2, 755:558 => 
  - drivers/base/regmap/regmap-debugfs.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 180:9, 83:18 => 
  - drivers/base/regmap/regmap-irq.c: warning: initialization makes pointer from integer without a cast [enabled by default]: 128:35, 61:35, 119:35, 110:35, 54:35 => 
  - drivers/block/cciss.h: warning: value computed is not used [-Wunused-value]: 227:451, 227:2 => 
  - drivers/block/mtip32xx/mtip32xx.c: warning: value computed is not used [-Wunused-value]: 494:2, 336:481, 361:2, 336:2, 1725:471, 494:501, 1725:2, 361:481, 507:501, 507:2, 264:2, 264:471 => 
  - drivers/block/sx8.c: warning: value computed is not used [-Wunused-value]: 502:3, 1467:456, 502:457, 1450:2, 1467:2, 1450:456 => 
  - drivers/char/random.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'long int' [-Wformat]: 1167:3 => 
  - drivers/char/random.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'long unsigned int' [-Wformat]: 1167:3 => 
  - drivers/char/random.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'long int' [-Wformat]: 1158:3 => 
  - drivers/char/tpm/tpm.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 399:4, 432:4 => 
  - drivers/extcon/extcon-max77693.c: warning: 'adc' may be used uninitialized in this function [-Wuninitialized]: 355:10 => 
  - drivers/extcon/extcon-max77693.c: warning: 'adc1k' may be used uninitialized in this function [-Wuninitialized]: 355:10 => 
  - drivers/extcon/extcon-max77693.c: warning: 'adclow' may be used uninitialized in this function [-Wuninitialized]: 355:10 => 
  - drivers/gpu/drm/r128/r128_cce.c: warning: value computed is not used [-Wunused-value]: 234:2, 283:2, 285:611, 234:611, 335:2, 283:611, 335:611, 285:2 => 
  - drivers/gpu/drm/r128/r128_state.c: warning: value computed is not used [-Wunused-value]: 104:2, 1216:1329, 1216:2, 595:4, 813:1327, 1177:1328, 89:2, 165:1327, 1070:1329, 393:4, 813:2, 479:3, 927:5, 753:1328, 1513:1207, 384:1329, 536:2, 1286:1208, 384:4, 951:4, 104:1329, 1336:2, 672:3, 1481:2, 479:1328, 1453:1207, 146:1327, 146:2, 866:1327, 1603:2, 659:1328, 46:1387, 595:1329, 435:1329, 1046:5, 1313:1207, 130:2, 207:1337, 1248:2, 1534:2, 556:1327, 614:1328, 1388:1207, 165:2, 1513:2, 435:4, 536:1327, 1248:1207, 1313:2, 414:1329, 866:2, 182:1337, 515:2, 614:3, 182:2, 1603:1207, 1534:1207, 1453:2, 753:3, 46:2, 1070:4, 951:1329, 659:3, 393:1329, 1177:3, 207:2, 927:1330, 1481:1207, 1115:2, 414:4, 130:1327, 515:1327, 1046:1330, 1388:2, 89:1327, 1286:3, 556:2, 672:1328, 1336:1207, 1115:1327 => 
  - drivers/gpu/drm/radeon/r600_cp.c: warning: value computed is not used [-Wunused-value]: 501:2, 582:611, 408:2, 582:2, 585:2, 1793:611, 585:611, 1793:2, 408:611, 501:611 => 
  - drivers/gpu/drm/radeon/radeon_cp.c: warning: value computed is not used [-Wunused-value]: 713:2, 2235:612, 713:611, 2235:3, 2239:3, 722:2, 2239:612, 722:611 => 
  - drivers/gpu/drm/via/via_dma.c: warning: value computed is not used [-Wunused-value]: 460:4, 460:618, 548:616, 548:2 => 
  - drivers/gpu/drm/via/via_dmablit.c: warning: value computed is not used [-Wunused-value]: 222:2, 222:686 => 
  - drivers/hid/hid-wiimote-debug.c: warning: 'size' may be used uninitialized in this function [-Wuninitialized]: 69:98, 69:28, 69:18, 69:105 => 
  - drivers/i2c/busses/i2c-eg20t.c: warning: value computed is not used [-Wunused-value]: 578:3, 578:417 => 
  - drivers/i2c/busses/i2c-intel-mid.c: warning: value computed is not used [-Wunused-value]: 349:2, 353:2, 911:457, 595:456, 348:456, 346:456, 345:2, 1043:2, 351:2, 354:2, 354:456, 777:456, 542:456, 345:456, 350:456, 777:2, 889:2, 542:2, 349:456, 353:456, 347:456, 889:456, 506:2, 352:2, 348:2, 351:456, 911:3, 1043:461, 506:456, 350:2, 346:2, 595:2, 347:2, 352:456 => 
  - drivers/i2c/busses/i2c-ocores.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 334:15 => 
  - drivers/ide/siimage.c: warning: value computed is not used [-Wunused-value]: 476:443 => 
  - drivers/infiniband/hw/cxgb4/cm.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 2941:34 => 
  - drivers/infiniband/hw/cxgb4/cm.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 2803:12 => 
  - drivers/infiniband/hw/mlx4/qp.c: warning: 'vlan' may be used uninitialized in this function [-Wuninitialized]: 1862:30, 1862:31 => 
  - drivers/infiniband/hw/ocrdma/ocrdma_main.c: warning: 'ocrdma_add_sgid' defined but not used [-Wunused-function]: 100:13 => 
  - drivers/infiniband/hw/ocrdma/ocrdma_main.c: warning: 'ocrdma_del_sgid' defined but not used [-Wunused-function]: 131:13 => 
  - drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_fhs' defined but not used [-Wunused-function]: 320:12 => 
  - drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_i8042timer' defined but not used [-Wunused-function]: 360:12 => 
  - drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_rt' defined but not used [-Wunused-function]: 280:12 => 
  - drivers/input/misc/hp_sdc_rtc.c: warning: ignoring return value of 'down_interruptible', declared with attribute warn_unused_result [-Wunused-result]: 183:20, 179:20, 112:20 => 
  - drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 1101:3, 1392:3 => 
  - drivers/media/common/saa7146/saa7146_core.c: warning: value computed is not used [-Wunused-value]: 122:457, 122:3, 87:3, 87:457 => 
  - drivers/media/dvb-frontends/mb86a20s.h: warning: 'mb86a20s_get_tuner_i2c_adapter' defined but not used [-Wunused-function]: 45:2 => 
  - drivers/media/pci/bt8xx/bttv-i2c.c: warning: value computed is not used [-Wunused-value]: 81:491, 69:491 => 
  - drivers/media/pci/cx88/cx88-blackbird.c: warning: value computed is not used [-Wunused-value]: 286:521, 301:521, 246:521, 287:521, 260:521, 245:521 => 
  - drivers/media/pci/cx88/cx88-i2c.c: warning: value computed is not used [-Wunused-value]: 77:521, 65:521 => 
  - drivers/media/pci/cx88/cx88-vp3054-i2c.c: warning: value computed is not used [-Wunused-value]: 71:521, 54:521 => 
  - drivers/media/pci/ivtv/ivtv-driver.c: warning: 'flush_work_sync' is deprecated (declared at /scratch/kisskb/src/include/linux/workqueue.h:448) [-Wdeprecated-declarations]: 307:2 => 
  - drivers/media/pci/ivtv/ivtv-driver.c: warning: value computed is not used [-Wunused-value]: 323:876, 317:876, 1388:829 => 
  - drivers/media/pci/ivtv/ivtv-irq.c: warning: value computed is not used [-Wunused-value]: 195:2798, 299:873, 451:4260, 199:2720, 435:4260, 296:951 => 
  - drivers/media/pci/ivtv/ivtv-mailbox.c: warning: value computed is not used [-Wunused-value]: 308:734, 197:781, 152:853, 199:864, 209:793, 324:732, 194:798, 193:732 => 
  - drivers/media/pci/ivtv/ivtv-udma.c: warning: value computed is not used [-Wunused-value]: 218:4260 => 
  - drivers/media/pci/ivtv/ivtv-yuv.c: warning: value computed is not used [-Wunused-value]: 948:828 => 
  - drivers/media/pci/saa7134/saa7134-tvaudio.c: warning: value computed is not used [-Wunused-value]: 360:501, 360:2, 366:2, 347:4, 347:503, 366:501 => 
  - drivers/media/usb/gspca/cpia1.c: warning: unused variable 'sd' [-Wunused-variable]: 1630:13 => 
  - drivers/media/usb/gspca/konica.c: warning: unused variable 'sd' [-Wunused-variable]: 246:13 => 
  - drivers/media/usb/gspca/t613.c: warning: unused variable 'sd' [-Wunused-variable]: 840:13 => 
  - drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]: 1104:1 => 
  - drivers/memstick/host/tifm_ms.c: warning: value computed is not used [-Wunused-value]: 248:3, 248:502 => 
  - drivers/message/fusion/mptbase.c: warning: value computed is not used [-Wunused-value]: 2716:2, 2108:481, 2108:2, 2716:481 => 
  - drivers/mfd/lp8788-irq.c: warning: initialization makes pointer from integer without a cast [enabled by default]: 87:33, 80:33, 74:33, 68:33 => 
  - drivers/mfd/sm501.c: warning: value computed is not used [-Wunused-value]: 234:2, 234:416 => 
  - drivers/mfd/twl4030-madc.c: warning: 'twl4030_madc_remove' defined but not used [-Wunused-function]: 788:12 => 
  - drivers/misc/phantom.c: warning: value computed is not used [-Wunused-value]: 145:428, 74:3, 448:461, 396:461, 74:462, 125:427, 315:426, 470:2, 315:2, 396:2, 448:2, 77:462, 125:3, 145:4, 77:3 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1440 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 420:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1996 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 654:1 => 
  - drivers/mtd/ftl.c: warning: passing argument 4 of 'mtd_read' from incompatible pointer type [enabled by default]: 527:28, 228:24, 294:24, 490:24 => 
  - drivers/mtd/ftl.c: warning: passing argument 4 of 'mtd_write' from incompatible pointer type [enabled by default]: 557:21, 535:29, 442:25, 566:21, 426:21, 507:21 => 
  - drivers/mtd/nand/denali.c: warning: value computed is not used [-Wunused-value]: 993:501, 993:2 => 
  - drivers/mtd/sm_ftl.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 216:95, 216:11, 215:100, 215:13 => 216:11, 215:13
  - drivers/mtd/tests/mtd_torturetest.c: warning: 'tort_init' uses dynamic stack allocation [enabled by default]: 410:1 => 
  - drivers/net/ethernet/3com/typhoon.c: warning: value computed is not used [-Wunused-value]: 2228:3, 2238:441, 1754:3, 1776:475, 394:474, 1478:474, 631:494, 1478:2, 1388:474, 1429:4, 1429:476, 631:2, 1754:495, 1939:2, 2238:2, 2228:442, 394:2, 1493:2, 1388:2, 1493:474, 1939:474, 1776:3 => 
  - drivers/net/ethernet/adaptec/starfire.c: warning: value computed is not used [-Wunused-value]: 1914:2, 1307:474, 1914:456, 1307:5 => 
  - drivers/net/ethernet/alteon/acenic.c: warning: value computed is not used [-Wunused-value]: 3185:456, 3077:2, 943:452, 3082:2, 3167:3, 3151:457, 2143:2, 915:451, 2979:2, 1461:446, 3072:456, 3067:456, 3020:3, 2143:436, 921:446, 2989:456, 943:3, 3014:457, 2974:2, 3156:3, 3004:2, 623:2, 3181:456, 3167:457, 3039:2, 2984:456, 3072:2, 2989:2, 915:2, 2969:2, 3052:2, 3188:2, 1490:437, 623:446, 1490:3, 3082:456, 2969:456, 3044:2, 3173:4, 3039:456, 2979:456, 3025:457, 3188:456, 3052:456, 3020:457, 2984:2, 3077:456, 898:451, 1475:3, 3156:457, 3151:3, 975:451, 3044:456, 975:2, 3181:2, 1475:447, 898:2, 3004:456, 3025:3, 3067:2, 3014:3, 3173:458, 3185:2, 1461:2, 2974:456, 921:2 => 
  - drivers/net/ethernet/amd/amd8111e.c: warning: value computed is not used [-Wunused-value]: 1408:451, 517:421, 1611:2, 1408:2, 639:451, 607:431, 1600:451, 639:2, 627:2, 517:2, 1600:2, 1611:451, 607:2, 627:451 => 
  - drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c: warning: value computed is not used [-Wunused-value]: 146:2, 158:539, 155:539, 149:539, 166:539, 162:554, 163:539, 150:2, 160:554, 148:2, 166:2, 164:2, 164:539, 148:534, 154:539, 147:2, 162:2, 165:539, 152:2, 161:2, 165:2, 156:539, 155:2, 157:539, 153:2, 157:2, 159:2, 159:539, 145:2, 151:2, 151:539, 160:2, 163:2, 147:534, 145:539, 158:2, 146:539, 150:539, 152:539, 161:539, 154:2, 156:2, 153:529, 149:2 => 
  - drivers/net/ethernet/atheros/atl1c/atl1c_hw.c: warning: value computed is not used [-Wunused-value]: 349:2, 40:2, 40:539, 528:2, 269:3, 175:3, 96:2, 164:2, 164:539, 783:539, 175:540, 181:3, 783:2, 576:3, 36:2, 782:539, 576:540, 782:2, 70:2, 71:2, 180:540, 519:539, 349:539, 781:539, 181:540, 531:2, 103:446, 180:3, 124:536, 119:3, 519:2, 103:5, 269:540, 70:539, 124:4, 781:2, 71:559, 119:535, 531:443, 528:443, 36:539, 96:539 => 
  - drivers/net/ethernet/atheros/atl1c/atl1c_main.c: warning: value computed is not used [-Wunused-value]: 1579:540, 158:539, 1263:2, 129:2, 141:2, 1300:539, 178:494, 215:3, 1246:2, 178:3, 96:540, 1474:3, 109:3, 1465:3, 1178:539, 191:2, 1178:2, 1259:2, 1380:539, 440:599, 86:540, 86:3, 1203:539, 129:529, 1380:2, 394:539, 215:540, 191:493, 80:2, 1579:3, 1242:2, 96:3, 103:3, 1202:539, 80:539, 1201:2, 1465:625, 1242:539, 113:3, 1474:625, 1263:539, 1259:539, 1184:539, 1203:2, 682:529, 103:530, 113:540, 1201:539, 141:539, 440:2, 158:2, 1202:2, 109:540, 1300:2, 1184:2, 1246:443, 394:2, 682:2, 1174:2, 1174:539 => 
  - drivers/net/ethernet/atheros/atl1e/atl1e_main.c: warning: value computed is not used [-Wunused-value]: 1320:445, 2161:2, 126:493, 113:2, 126:2, 101:3, 1320:4, 101:494, 113:493 => 
  - drivers/net/ethernet/atheros/atlx/atl1.c: warning: value computed is not used [-Wunused-value]: 368:476, 2843:3, 338:466, 368:2, 616:2, 280:2, 280:476, 2831:3, 2817:3, 414:2, 2851:2, 2837:3, 2855:2, 616:476, 338:2, 414:471, 2841:3 => 
  - drivers/net/ethernet/atheros/atlx/atl2.c: warning: value computed is not used [-Wunused-value]: 360:5, 639:3, 2706:2, 350:2, 639:443, 2706:442, 629:4, 360:495, 1674:2, 629:444, 350:492 => 
  - drivers/net/ethernet/atheros/atlx/atlx.c: warning: value computed is not used [-Wunused-value]: 162:516, 162:2 => 
  - drivers/net/ethernet/broadcom/bnx2.c: warning: value computed is not used [-Wunused-value]: 6220:496, 538:497, 4755:3, 3443:497, 557:497, 5056:2, 3339:2, 606:2, 5796:2, 3443:3, 587:3, 3339:496, 557:3, 587:497, 5975:496, 5975:2, 5822:496, 5796:496, 538:3, 606:496, 4755:497, 500:497, 5056:496, 500:3, 6220:2, 5822:2 => 
  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c: warning: value computed is not used [-Wunused-value]: 1991:593, 1991:4 => 
  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h: warning: value computed is not used [-Wunused-value]: 260:498, 260:4 => 
  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: warning: value computed is not used [-Wunused-value]: 7487:3, 9413:2, 6758:2, 6060:3, 7487:562, 6278:506, 6060:512, 9423:2, 9413:491, 6278:2, 9423:491, 6758:516 => 
  - drivers/net/ethernet/broadcom/cnic.c: warning: value computed is not used [-Wunused-value]: 4505:2, 4505:501 => 
  - drivers/net/ethernet/broadcom/tg3.c: warning: value computed is not used [-Wunused-value]: 489:446, 584:397, 584:3, 489:2 => 
  - drivers/net/ethernet/brocade/bna/bfa_ioc.c: warning: value computed is not used [-Wunused-value]: 1130:2, 1185:501, 1906:2, 1185:2, 1130:411, 1723:526, 1906:506, 1723:2 => 
  - drivers/net/ethernet/brocade/bna/bfa_ioc_ct.c: warning: value computed is not used [-Wunused-value]: 895:4, 471:2, 471:501, 614:2, 189:2, 188:2, 895:508, 890:508, 188:481, 614:451, 189:501, 890:4 => 
  - drivers/net/ethernet/calxeda/xgmac.c: warning: value computed is not used [-Wunused-value]: 1354:472, 1354:3 => 
  - drivers/net/ethernet/chelsio/cxgb/espi.c: warning: value computed is not used [-Wunused-value]: 170:512, 136:511, 170:3, 136:2 => 
  - drivers/net/ethernet/chelsio/cxgb/sge.c: warning: value computed is not used [-Wunused-value]: 1973:2, 1973:496, 1950:2, 743:3, 743:472, 1950:496 => 
  - drivers/net/ethernet/chelsio/cxgb/subr.c: warning: value computed is not used [-Wunused-value]: 866:481, 866:2 => 
  - drivers/net/ethernet/dec/tulip/de2104x.c: warning: value computed is not used [-Wunused-value]: 1766:412, 1267:481, 1768:3, 855:3, 878:477, 1772:2, 1772:411, 1776:412, 1779:3, 878:3, 1779:412, 855:477, 1768:412, 1267:2, 1766:3, 1202:3, 1202:477, 1776:3 => 
  - drivers/net/ethernet/dec/tulip/eeprom.c: warning: value computed is not used [-Wunused-value]: 365:412, 363:412, 373:3, 363:3, 369:2, 376:412, 369:411, 376:3, 373:412, 365:3 => 
  - drivers/net/ethernet/dec/tulip/media.c: warning: value computed is not used [-Wunused-value]: 264:450, 305:5, 153:3, 305:449, 103:422, 93:3, 70:3, 143:3, 84:422, 71:442, 86:3, 160:422, 100:422, 160:3, 86:422, 158:422, 153:422, 151:422, 93:422, 151:3, 278:449, 71:3, 264:6, 143:422, 103:3, 158:3, 84:3, 291:450, 100:3, 95:3, 145:3, 291:6, 278:5, 70:442, 145:422, 95:422 => 
  - drivers/net/ethernet/dec/tulip/tulip_core.c: warning: value computed is not used [-Wunused-value]: 1517:2, 1517:441 => 
  - drivers/net/ethernet/dec/tulip/winbond-840.c: warning: value computed is not used [-Wunused-value]: 521:2, 564:422, 623:3, 616:422, 528:412, 525:412, 518:412, 528:3, 616:3, 518:3, 583:422, 516:412, 625:3, 564:3, 590:3, 585:3, 590:422, 593:422, 1626:3, 618:422, 562:422, 583:3, 525:3, 585:422, 593:3, 562:3, 623:422, 521:411, 618:3, 625:422, 516:3 => 
  - drivers/net/ethernet/dlink/de620.h: warning: "INTLEVEL" redefined [enabled by default]: 37:0 => 
  - drivers/net/ethernet/dlink/dl2k.c: warning: value computed is not used [-Wunused-value]: 1056:2, 1075:501, 1055:506, 1077:2, 1050:486, 1020:2, 1010:511, 1017:2, 1018:2, 1050:2, 1074:501, 1054:511, 1017:501, 1010:2, 1071:511, 1008:2, 1076:511, 1057:2, 1051:2, 1020:521, 1054:2, 1055:2, 1051:481, 1074:2, 1049:486, 1049:2, 1071:2, 1052:2, 1021:501, 1056:501, 1076:2, 1019:511, 1057:501, 1069:501, 1052:481, 1077:521, 1021:2, 1008:501, 1018:501, 1075:2, 1069:2, 1019:2 => 
  - drivers/net/ethernet/dlink/sundance.c: warning: value computed is not used [-Wunused-value]: 719:3, 719:452 => 
  - drivers/net/ethernet/fealnx.c: warning: value computed is not used [-Wunused-value]: 1143:3, 1143:437 => 
  - drivers/net/ethernet/icplus/ipg.c: warning: value computed is not used [-Wunused-value]: 1035:451, 1035:2 => 
  - drivers/net/ethernet/intel/e1000/e1000_ethtool.c: warning: value computed is not used [-Wunused-value]: 913:703, 876:2, 1437:703, 943:2, 913:3, 943:702, 1437:3, 895:4, 895:704, 931:704, 876:702, 931:4 => 
  - drivers/net/ethernet/intel/e1000/e1000_hw.c: warning: value computed is not used [-Wunused-value]: 590:703, 3808:703, 2719:2, 435:702, 3665:703, 3818:3, 3842:703, 4359:3, 3626:2, 4489:703, 3769:3, 590:3, 3769:703, 602:703, 3802:3, 2704:2, 4468:703, 4357:3, 435:2, 3856:703, 3626:702, 3110:3, 450:703, 3862:3, 2797:702, 4445:702, 1014:703, 2719:702, 2797:2, 3129:703, 615:703, 4489:3, 3856:3, 3796:703, 497:703, 3862:703, 3818:703, 3796:3, 3665:3, 4447:2, 1933:702, 4445:2, 4447:702, 3125:703, 450:3, 1007:703, 3790:3, 2760:703, 3790:703, 1014:3, 3115:703, 602:3, 1933:2, 3110:703, 4465:703, 4357:703, 3814:703, 925:702, 3610:2, 4465:3, 3610:702, 3842:3, 3802:703, 2760:3, 4463:3, 2704:702, 4463:703, 3125:3, 3808:3, 3115:3, 4359:703, 3814:3, 615:3, 497:3, 1007:3, 925:2, 3129:3, 4468:3 => 
  - drivers/net/ethernet/intel/e1000/e1000_main.c: warning: value computed is not used [-Wunused-value]: 2171:702, 525:702, 2187:702, 2393:4, 310:2, 3804:702, 3804:2, 2325:703, 2323:3, 2325:3, 2171:2, 2187:2, 324:2, 2339:2, 2393:704, 525:2, 310:702, 2339:702, 324:702, 2323:703 => 
  - drivers/net/ethernet/intel/igb/e1000_82575.c: warning: value computed is not used [-Wunused-value]: 1618:482, 1626:2, 1596:482, 1709:2, 1600:482, 1626:482, 1619:482, 1616:482, 1623:482, 1587:2, 1592:2, 1594:482, 1614:482, 1630:2, 1589:2, 1610:2, 1607:2, 1611:482, 1707:482, 1607:482, 1608:482, 1628:482, 1621:482, 1597:2, 1636:3, 1590:2, 1591:482, 1604:2, 1627:482, 1624:2, 1613:482, 1593:2, 1603:482, 1587:482, 1627:2, 1600:2, 1613:2, 2298:477, 1606:482, 1591:2, 2298:2, 1593:482, 1630:482, 1628:2, 1602:2, 1599:482, 1601:482, 1624:482, 1604:482, 1610:482, 1631:2, 1615:482, 1603:2, 1608:2, 1588:482, 1618:2, 1595:482, 1629:2, 1622:482, 1622:2, 2299:2, 1590:482, 1597:482, 1616:2, 1625:2, 1619:2, 1636:483, 1592:482, 1708:482, 1586:2, 1589:482, 1595:2, 1708:2, 1625:482, 1707:2, 1629:482, 1709:482, 1617:482, 1606:2, 1599:2, 1601:2, 1586:482, 1614:2, 1602:482, 1611:2, 1631:482, 2299:477, 1623:2, 1594:2, 1588:2, 1621:2, 1596:2, 1617:2, 1615:2 => 
  - drivers/net/ethernet/intel/igb/e1000_mac.c: warning: value computed is not used [-Wunused-value]: 518:2, 515:482, 510:2, 501:482, 508:482, 487:2, 521:482, 494:482, 497:2, 502:482, 493:482, 493:2, 509:482, 492:2, 517:2, 522:2, 499:482, 486:2, 498:2, 511:482, 502:2, 505:2, 517:482, 505:482, 498:482, 520:482, 495:482, 506:482, 519:2, 516:2, 490:2, 518:482, 489:2, 497:482, 491:2, 516:482, 514:2, 496:482, 512:2, 500:2, 520:2, 499:2, 509:2, 507:482, 490:482, 512:482, 500:482, 510:482, 491:482, 495:2, 503:2, 521:2, 494:2, 506:2, 508:2, 515:2, 514:482, 507:2, 511:2, 504:482, 486:482, 488:2, 488:482, 496:2, 501:2, 519:482, 487:482, 503:482, 504:2, 489:482, 492:482, 513:2, 522:482, 513:482 => 
  - drivers/net/ethernet/intel/igb/igb_main.c: warning: value computed is not used [-Wunused-value]: 2543:2, 4634:482, 1511:2, 4634:2, 4664:482, 1511:482, 4664:2, 2543:482 => 
  - drivers/net/ethernet/intel/igbvf/netdev.c: warning: value computed is not used [-Wunused-value]: 1672:481, 1672:2, 1005:481, 1479:2, 1005:2, 1479:481, 1273:2, 1354:481, 1513:2, 1513:481, 1273:481, 1354:2 => 
  - drivers/net/ethernet/intel/ixgb/ixgb_ee.c: warning: value computed is not used [-Wunused-value]: 249:493, 117:494, 60:2, 249:2, 224:493, 117:3, 218:493, 79:493, 218:2, 230:493, 212:2, 224:2, 60:493, 255:2, 79:2, 230:2, 255:493, 212:493 => 
  - drivers/net/ethernet/intel/ixgb/ixgb_hw.c: warning: value computed is not used [-Wunused-value]: 1225:2, 153:493, 153:2, 1225:493 => 
  - drivers/net/ethernet/intel/ixgb/ixgb_main.c: warning: value computed is not used [-Wunused-value]: 201:543, 184:543, 201:2, 184:2 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c: warning: value computed is not used [-Wunused-value]: 1002:2, 980:2, 1002:501, 786:501, 980:501, 786:2 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c: warning: value computed is not used [-Wunused-value]: 2178:501, 1773:2, 125:4, 1709:2, 1751:2, 1148:501, 1142:501, 1168:2, 465:2, 613:3, 484:2, 560:3, 1202:501, 125:503, 1169:2, 1167:2, 1729:502, 1170:501, 1167:501, 1138:501, 1773:501, 613:502, 1166:501, 1709:501, 484:501, 995:501, 1751:501, 995:2, 1138:2, 1151:2, 1127:2, 1151:501, 1142:2, 465:501, 1168:501, 1202:2, 1127:501, 1678:2, 1678:501, 1729:3, 1169:501, 1170:2, 1148:2, 2178:2, 560:502, 1166:2 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: warning: value computed is not used [-Wunused-value]: 387:573, 414:2, 697:2, 369:501, 426:2, 421:2, 427:2, 373:501, 412:4, 396:501, 363:2, 384:572, 440:588, 424:2, 386:573, 430:501, 370:501, 2586:2, 2653:2, 376:3, 423:501, 430:2, 426:501, 415:2, 420:2, 276:2, 399:501, 1449:2, 367:572, 753:2, 407:501, 2698:2, 442:4, 364:2, 402:2, 379:502, 408:501, 403:501, 1504:2, 431:2, 1508:2, 1652:501, 433:3, 409:501, 307:501, 384:3, 369:2, 416:501, 443:588, 437:588, 427:501, 390:4, 1547:502, 440:4, 1634:501, 371:501, 418:501, 404:501, 395:4, 1449:501, 425:501, 712:501, 383:572, 1340:4, 1547:3, 363:501, 400:501, 753:501, 431:501, 429:501, 439:4, 397:2, 418:2, 372:501, 434:3, 397:501, 390:573, 400:2, 419:501, 735:2, 2586:501, 425:2, 362:501, 412:573, 399:2, 2642:3, 1340:503, 389:4, 401:2, 404:2, 413:501, 386:4, 405:501, 420:501, 3600:2, 365:501, 421:501, 365:2, 436:4, 403:2, 367:3, 2642:502, 396:2, 375:502, 1508:501, 276:501, 1652:2, 307:2, 437:4, 2698:501, 442:588, 436:588, 409:2, 1504:501, 364:501, 1564:2, 3600:501, 419:2, 1634:2, 378:3, 405:2, 428:501, 372:2, 371:2, 413:2, 422:2, 439:583, 387:4, 408:2, 438:583, 398:501, 370:2, 375:3, 389:573, 417:2, 362:2, 712:2, 376:502, 378:502, 428:2, 406:2, 414:501, 422:501, 401:501, 423:2, 697:501, 438:4, 433:587, 429:2, 434:587, 395:573, 443:4, 415:501, 1564:501, 406:501, 402:501, 1617:501, 398:2, 416:2, 1617:2, 379:3, 2653:501, 424:501, 407:2, 383:3, 735:501, 373:2, 417:501 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c: warning: value computed is not used [-Wunused-value]: 1464:3, 1485:553, 1485:4, 1446:4, 1425:2, 1629:501, 1497:2, 1425:551, 1464:552, 1497:551, 1446:553, 1629:2 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_main.c: warning: value computed is not used [-Wunused-value]: 5270:502, 4128:501, 5270:3, 2778:501, 5272:502, 2288:502, 2778:2, 2394:3, 2731:551, 2731:2, 5272:3, 5474:502, 5239:583, 5241:4, 5274:3, 5274:502, 4128:2, 2288:3, 5241:588, 2394:552, 5474:3, 5239:4 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c: warning: value computed is not used [-Wunused-value]: 1483:501, 1654:2, 1483:2, 1630:501, 1607:3, 1654:501, 1630:2, 1607:502 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c: warning: value computed is not used [-Wunused-value]: 729:501, 840:2, 729:2, 182:2, 840:501, 132:3, 132:502, 182:501 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c: warning: value computed is not used [-Wunused-value]: 830:2, 830:501, 248:2, 248:501 => 
  - drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c: warning: value computed is not used [-Wunused-value]: 111:501, 805:501, 742:2, 776:501, 111:2, 742:501, 776:2, 805:2 => 
  - drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: warning: value computed is not used [-Wunused-value]: 1515:2, 2578:2, 997:2 => 
  - drivers/net/ethernet/intel/ixgbevf/vf.c: warning: value computed is not used [-Wunused-value]: 86:2, 152:2, 158:2 => 
  - drivers/net/ethernet/jme.h: warning: value computed is not used [-Wunused-value]: 1235:451, 1235:2 => 
  - drivers/net/ethernet/natsemi/natsemi.c: warning: value computed is not used [-Wunused-value]: 1719:471, 1019:412, 1227:3, 1026:412, 3180:2, 1029:412, 3122:2, 1309:2, 1057:2, 1022:2, 1070:452, 1019:3, 1315:2, 1022:411, 1075:451, 1057:451, 1274:471, 711:2, 1026:3, 3180:461, 3122:451, 1179:471, 1309:471, 1017:3, 1719:2, 717:511, 1017:412, 1072:452, 717:2, 1274:2, 1029:3, 1315:471, 1075:2, 1070:3, 1179:2, 711:511, 1072:3, 1227:472 => 
  - drivers/net/ethernet/natsemi/ns83820.c: warning: value computed is not used [-Wunused-value]: 1202:42, 1199:38, 796:456, 1202:471, 1203:38, 796:2, 1199:467, 1203:467, 1389:2, 1389:456, 1204:38, 1204:467 => 
  - drivers/net/ethernet/neterion/s2io.c: warning: value computed is not used [-Wunused-value]: 4799:3, 4314:3, 4314:502, 2831:3, 2831:487, 4799:502, 4756:484, 3792:2, 4756:5 => 
  - drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: value computed is not used [-Wunused-value]: 4935:2, 4935:536 => 
  - drivers/net/ethernet/nvidia/forcedeth.c: warning: value computed is not used [-Wunused-value]: 952:2, 952:396 => 
  - drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c: warning: value computed is not used [-Wunused-value]: 811:456, 795:2, 795:456, 811:2 => 
  - drivers/net/ethernet/packetengines/hamachi.c: warning: value computed is not used [-Wunused-value]: 1636:447, 1637:3, 1636:3, 1637:447 => 
  - drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c: warning: value computed is not used [-Wunused-value]: 2180:1051, 1403:2, 2079:2250, 2008:6, 2017:1048, 2178:1081, 2184:2, 2209:3, 2021:6, 2209:1093, 2313:3, 2180:3, 2209:2337, 2008:1048, 2039:1048, 2079:1048, 2146:1045, 2027:6, 2178:3, 2215:4, 2000:1048, 2264:2337, 2079:6, 2211:1082, 2269:4, 2021:1048, 2222:5, 2178:2289, 1995:1048, 2340:1076, 2021:2250, 2265:3, 2003:1048, 2265:2367, 2340:4, 2017:6, 2057:1048, 1995:6, 2211:4, 1403:496, 2012:2250, 2184:601, 2000:6, 2313:2325, 2211:2362, 1995:2292, 2265:1081, 2003:2250, 2313:1087, 2234:4, 2234:1046, 2215:1082, 2314:3, 2039:6, 2012:1048, 2027:1048, 2337:3, 2222:1083, 2264:1093, 2337:2319, 2337:1087, 2003:6, 2057:6, 2314:1075, 2269:1046, 2264:3, 2146:3, 2012:6 => 
  - drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c: warning: value computed is not used [-Wunused-value]: 2278:476, 2277:476, 2277:2, 2278:2 => 
  - drivers/net/ethernet/qlogic/qla3xxx.c: warning: value computed is not used [-Wunused-value]: 274:2, 233:2, 225:391, 129:551, 274:391, 175:571, 129:2, 262:2, 250:2, 262:391, 225:2, 240:2, 250:391, 233:391, 175:2, 240:391 => 
  - drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c: warning: value computed is not used [-Wunused-value]: 1066:501, 311:391, 314:2, 1078:2, 1078:501, 298:391, 311:2, 298:2, 1066:2, 314:391 => 
  - drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c: warning: value computed is not used [-Wunused-value]: 1952:2, 1952:476, 1953:476, 1953:2 => 
  - drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c: warning: value computed is not used [-Wunused-value]: 366:2, 155:426, 168:426, 155:2, 171:426, 171:2, 366:461, 168:2 => 
  - drivers/net/ethernet/realtek/8139cp.c: warning: value computed is not used [-Wunused-value]: 990:2, 985:822, 989:930, 993:2, 1600:3954, 1599:3954, 1028:2, 1021:3954, 1600:2, 985:2, 1599:2, 1519:486, 994:960, 904:870, 1028:930, 1528:486, 990:960, 906:864, 1519:2, 994:2, 907:2, 986:2, 986:846, 907:864, 989:2, 1021:2, 993:930, 1022:2, 906:2, 1022:3954, 1528:2, 904:2 => 
  - drivers/net/ethernet/realtek/8139too.c: warning: value computed is not used [-Wunused-value]: 2583:813, 2240:3338, 1895:2, 1419:3, 2586:2, 1733:2, 2586:866, 1394:866, 1389:2780, 2583:3, 1389:2, 1419:1131, 1388:3956, 913:3, 1895:866, 2587:866, 2587:2, 2239:3338, 2239:2, 1394:2, 1388:2, 2240:2, 1733:1892, 913:873 => 
  - drivers/net/ethernet/realtek/r8169.c: warning: value computed is not used [-Wunused-value]: 3728:451, 3731:2, 3728:2, 3731:451 => 
  - drivers/net/ethernet/seeq/seeq8005.c: warning: statement with no effect [-Wunused-value]: 559:4 => 
  - drivers/net/ethernet/silan/sc92031.c: warning: value computed is not used [-Wunused-value]: 645:486, 645:2, 310:456, 310:2 => 
  - drivers/net/ethernet/sis/sis190.c: warning: value computed is not used [-Wunused-value]: 443:486, 875:2, 875:486, 1693:486, 1693:2, 900:486, 443:2, 900:2 => 
  - drivers/net/ethernet/sis/sis900.c: warning: value computed is not used [-Wunused-value]: 988:452, 922:3, 988:3, 970:3, 922:452, 990:452, 968:3, 983:2, 924:3, 854:3, 930:3, 844:3, 858:452, 835:451, 849:2, 968:452, 892:452, 858:3, 837:2, 890:3, 933:3, 856:3, 846:3, 970:452, 979:452, 837:451, 983:451, 878:2, 863:2, 972:451, 924:452, 844:452, 930:452, 979:3, 854:452, 981:452, 846:452, 878:451, 933:452, 890:452, 863:451, 981:3, 856:452, 990:3, 835:2, 892:3, 849:451, 972:2 => 
  - drivers/net/ethernet/smsc/epic100.c: warning: value computed is not used [-Wunused-value]: 594:457, 594:3, 586:457, 597:457, 685:2, 685:461, 586:3, 597:3, 588:457, 588:3 => 
  - drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast [enabled by default]: 762:326, 390:2, 381:326, 1647:2, 1175:327, 939:326, 1673:2, 1296:327, 1132:327, 1640:327, 349:326, 1250:329, 395:326, 357:326, 1654:327, 597:2, 271:2, 1805:2, 1025:3, 757:677, 296:2, 760:326, 1286:329, 728:326, 396:2, 1295:327, 1074:327, 418:326, 493:3, 1457:328, 253:326, 1454:327, 356:326, 1200:2, 838:326, 1667:327, 582:326, 581:677, 594:326, 805:3, 1643:327, 821:326, 254:326, 761:2, 753:2, 1024:328, 350:2, 389:326, 1682:327, 621:1311, 1897:327, 1645:327, 380:326, 1935:327, 490:501, 1173:327, 328:326, 1267:329, 1265:329, 833:2, 345:326, 860:2, 797:2, 1653:2, 1884:327, 329:2, 1289:329, 851:326, 1280:329, 310:2, 1199:2, 803:3, 1826:327, 1681:2, 783:3, 938:326, 1455:2, 1642:327, 725:677, 1075:327, 471:4, 278:326, 313:326, 391:2, 1458:3, 691:1305, 311:2, 940:326, 600:2, 1460:327, 441:3, 785:3, 1344:327, 597:574, 1201:327, 1197:327, 1799:327, 679:328, 669:2, 1668:327, 325:2, 1347:327, 1670:327, 865:326, 1910:327, 309:326, 614:2, 1671:327, 346:2, 270:326, 1227:327, 1639:327, 347:2, 1798:327 => 390:2, 1668:2, 1265:4, 349:2, 389:2, 1250:4, 762:2, 1024:3, 1672:2, 1132:2, 838:2, 1671:2, 270:2, 597:2, 490:3, 271:2, 1025:3, 1800:2, 296:2, 396:2, 1173:2, 1648:2, 621:2, 1643:2, 493:3, 1827:2, 1175:2, 581:2, 1200:2, 1074:2, 939:2, 1640:2, 1799:2, 313:2, 821:2, 328:2, 1936:2, 1646:2, 1669:2, 805:3, 380:2, 309:2, 761:2, 753:2, 1267:4, 350:2, 1641:2, 1911:2, 1344:2, 1898:2, 1457:3, 851:2, 357:2, 833:2, 381:2, 860:2, 797:2, 1806:2, 1286:4, 329:2, 725:2, 278:2, 940:2, 310:2, 1199:2, 803:3, 345:2, 728:2, 1295:2, 783:3, 1296:2, 1455:2, 1644:2, 1289:4, 471:4, 582:2, 391:2, 1458:3, 311:2, 1227:2, 395:2, 600:2, 1674:2, 1460:2, 1682:2, 1654:2, 441:3, 1280:4, 1201:2, 785:3, 1885:2, 669:2, 356:2, 325:2, 757:2, 1347:2, 679:4, 594:2, 691:3, 418:2, 865:2, 614:2, 1683:2, 346:2, 253:2, 760:2, 1655:2, 1454:2, 254:2, 938:2, 1075:2, 347:2, 1197:2
  - drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c: warning: value computed is not used [-Wunused-value]: 222:472, 222:3 => 
  - drivers/net/ethernet/sun/cassini.c: warning: value computed is not used [-Wunused-value]: 4154:462, 1261:2, 1265:4, 4154:3, 1261:461, 1265:548 => 
  - drivers/net/ethernet/tehuti/tehuti.c: warning: value computed is not used [-Wunused-value]: 281:4, 526:2, 282:4, 469:443, 469:4, 281:493, 282:493, 526:491, 493:493, 493:4 => 
  - drivers/net/hippi/rrunner.c: warning: value computed is not used [-Wunused-value]: 1353:3, 1218:2, 1353:452, 1218:451 => 
  - drivers/net/wan/dscc4.c: warning: value computed is not used [-Wunused-value]: 1036:2, 434:2, 434:581, 423:656, 1036:441, 423:2 => 
  - drivers/net/wan/pc300too.c: warning: value computed is not used [-Wunused-value]: 382:381, 386:381, 395:381, 382:2, 386:2, 391:381, 391:2, 395:2 => 
  - drivers/net/wan/pci200syn.c: warning: value computed is not used [-Wunused-value]: 347:381, 343:381, 343:2, 347:2 => 
  - drivers/net/wan/wanxl.c: warning: value computed is not used [-Wunused-value]: 503:2, 506:2, 506:486, 503:486 => 
  - drivers/net/wimax/i2400m/control.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]: 134:10 => 
  - drivers/net/wimax/i2400m/control.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]: 239:6 => 
  - drivers/net/wimax/i2400m/control.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'ssize_t' [-Wformat]: 239:6 => 
  - drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]: 210:4, 215:4 => 
  - drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 8 has type 'ssize_t' [-Wformat]: 222:2 => 
  - drivers/net/wireless/adm8211.c: warning: value computed is not used [-Wunused-value]: 554:7829, 553:7827, 1370:924, 555:7828, 1406:1022, 554:5855, 554:2943, 554:3913, 553:2039, 554:6800, 1374:451, 903:461, 1156:461, 1885:462, 555:1147, 555:4925, 553:4924, 755:1022, 555:3912, 554:4926, 555:8675, 552:5854, 1153:461, 553:8674, 555:6799, 553:1146, 258:456, 552:7828, 106:451, 552:3912, 553:5853, 1557:451, 555:5854, 553:3911, 1883:462, 553:2941, 1205:451, 639:1022, 553:6798, 554:1148, 555:2942, 552:2040, 552:8675, 720:461, 552:2942, 554:8676, 552:4925, 554:2041, 555:2040, 254:466, 552:1147, 552:6799 => 
  - drivers/net/wireless/ath/ath6kl/htc_pipe.c: warning: integer overflow in expression [-Woverflow]: 1280:227, 1280:26 => 1294:26
  - drivers/net/wireless/ath/ath9k/ahb.c: warning: unused variable 'mem' [-Wunused-variable]: 171:17 => 
  - drivers/net/wireless/ath/carl9170/mac.c: warning: 'power' may be used uninitialized in this function [-Wuninitialized]: 525:10, 525:122 => 525:10
  - drivers/net/wireless/ath/carl9170/rx.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]: 809:6, 809:48 => 809:6
  - drivers/net/wireless/ipw2x00/ipw2100.c: warning: value computed is not used [-Wunused-value]: 8644:391, 8638:391, 8646:391, 8605:391, 8611:391, 8632:391, 8640:391, 8634:391, 8613:391, 8601:391, 8599:391, 8607:391, 8627:391, 8651:391, 8615:391 => 
  - drivers/net/wireless/mwl8k.c: warning: value computed is not used [-Wunused-value]: 1455:491 => 
  - drivers/pcmcia/yenta_socket.c: warning: value computed is not used [-Wunused-value]: 93:466 => 
  - drivers/platform/x86/acer-wmi.c: warning: 'devices' may be used uninitialized in this function [-Wuninitialized]: 1216:14 => 
  - drivers/regulator/lp8788-buck.c: warning: array subscript is above array bounds [-Warray-bounds]: 489:63, 489:27, 490:8 => 
  - drivers/scsi/3w-sas.c: warning: value computed is not used [-Wunused-value]: 1161:591, 1161:2 => 
  - drivers/scsi/aacraid/src.c: warning: right shift count >= width of type [enabled by default]: 434:2, 410:3 => 
  - drivers/scsi/aacraid/src.c: warning: value computed is not used [-Wunused-value]: 202:551, 98:5, 98:559, 60:557, 86:4, 202:2, 86:558, 60:3 => 
  - drivers/scsi/arcmsr/arcmsr_hba.c: warning: value computed is not used [-Wunused-value]: 1616:481, 1616:2 => 
  - drivers/scsi/bfa/bfa_ioc.c: warning: value computed is not used [-Wunused-value]: 1987:526, 1987:2, 1927:526, 1870:526, 2073:506, 1927:2, 2073:2, 1870:2 => 
  - drivers/scsi/bfa/bfa_ioc_cb.c: warning: value computed is not used [-Wunused-value]: 205:501, 87:481, 205:2, 87:2 => 
  - drivers/scsi/bfa/bfa_ioc_ct.c: warning: value computed is not used [-Wunused-value]: 136:502, 941:4, 88:3, 121:531, 88:532, 936:508, 617:451, 400:501, 139:482, 139:3, 99:531, 617:2, 68:532, 135:482, 121:2, 391:2, 99:2, 68:3, 400:2, 941:508, 136:3, 391:531, 936:4, 135:3 => 
  - drivers/scsi/csiostor/csio_hw.c: warning: value computed is not used [-Wunused-value]: 156:516, 1131:601, 1131:2, 264:531, 156:2, 3636:536, 3417:531, 264:2, 3417:2, 3636:2 => 
  - drivers/scsi/csiostor/csio_mb.c: warning: value computed is not used [-Wunused-value]: 1246:536, 1571:538, 1184:2, 1246:2, 1571:4, 1599:537, 1357:2, 1197:596, 1357:536, 1184:596, 1197:2, 1599:3 => 
  - drivers/scsi/hptiop.c: warning: value computed is not used [-Wunused-value]: 371:551, 384:2, 384:556, 378:541, 1536:541, 1542:2, 316:551, 1530:2, 68:552, 378:2, 963:2, 1546:2, 1530:541, 1536:2, 963:566, 316:2, 68:3, 1542:571, 1544:531, 1546:571, 1544:2, 371:2 => 
  - drivers/scsi/ips.c: warning: value computed is not used [-Wunused-value]: 4773:466, 4773:2 => 
  - drivers/scsi/lpfc/lpfc.h: warning: value computed is not used [-Wunused-value]: 1016:2, 1016:451 => 
  - drivers/scsi/lpfc/lpfc_attr.c: warning: value computed is not used [-Wunused-value]: 1472:453, 919:581, 1493:452, 1493:3, 919:2, 1472:4 => 
  - drivers/scsi/lpfc/lpfc_bsg.c: warning: value computed is not used [-Wunused-value]: 1388:452, 618:452, 618:3, 360:3, 360:452, 1388:3 => 
  - drivers/scsi/lpfc/lpfc_compat.h: warning: value computed is not used [-Wunused-value]: 51:407, 51:3 => 
  - drivers/scsi/lpfc/lpfc_debugfs.c: warning: value computed is not used [-Wunused-value]: 2878:3, 3102:412, 3102:3, 1973:4, 2878:412, 1967:493, 1967:4, 1979:493, 1973:493, 1979:4 => 
  - drivers/scsi/lpfc/lpfc_hbadisc.c: warning: value computed is not used [-Wunused-value]: 1078:451, 3187:3, 1078:2, 714:5, 1054:451, 3187:452, 714:454, 1054:2 => 
  - drivers/scsi/lpfc/lpfc_init.c: warning: value computed is not used [-Wunused-value]: 3308:451, 785:3, 1685:2, 705:453, 1662:451, 702:453, 539:2, 3311:451, 1681:451, 1681:2, 705:4, 702:4, 539:451, 1662:2, 3311:2, 3308:2, 785:452, 1685:451 => 
  - drivers/scsi/lpfc/lpfc_sli.c: warning: value computed is not used [-Wunused-value]: 4029:411, 3386:3, 6846:3, 10162:453, 3760:2, 3692:2, 10727:452, 6971:3, 1768:3, 3804:2, 9992:452, 1548:2, 3061:3, 4020:2, 3760:451, 10460:452, 9949:452, 6862:452, 10834:451, 4205:451, 9949:3, 3903:451, 10727:3, 10544:454, 6971:452, 10834:2, 1548:451, 10516:455, 10162:4, 10480:454, 3905:2, 4201:2, 3692:451, 3804:451, 3905:451, 3903:2, 6871:452, 1573:452, 4205:2, 10480:5, 1768:482, 3061:452, 10460:3, 10544:5, 1573:3, 331:3, 6871:3, 4020:411, 4029:2, 6862:3, 4201:451, 10516:6, 3386:452, 9992:3, 331:532, 6846:412 => 
  - drivers/scsi/megaraid/megaraid_sas_base.c: warning: value computed is not used [-Wunused-value]: 538:2, 249:2, 433:501, 249:501, 687:2, 262:2, 472:2, 728:2, 551:2, 674:501, 687:501, 420:2, 674:2, 300:511, 420:501, 262:501, 433:2, 472:526, 600:511, 600:2, 300:2, 551:501, 728:511, 538:501 => 
  - drivers/scsi/megaraid/megaraid_sas_fusion.c: warning: value computed is not used [-Wunused-value]: 113:2, 113:501, 142:512, 108:2, 142:3, 108:511 => 
  - drivers/scsi/mpt2sas/mpt2sas_base.c: warning: value computed is not used [-Wunused-value]: 850:2, 850:521 => 
  - drivers/scsi/mpt3sas/mpt3sas_base.c: warning: value computed is not used [-Wunused-value]: 853:521, 853:2 => 
  - drivers/scsi/mvsas/mv_64xx.c: warning: value computed is not used [-Wunused-value]: 191:817, 191:3, 473:834, 382:774, 473:2, 382:2, 279:841, 279:3 => 
  - drivers/scsi/mvsas/mv_94xx.c: warning: value computed is not used [-Wunused-value]: 477:774, 611:3, 477:2, 355:3, 355:841, 611:835 => 
  - drivers/scsi/pmcraid.c: warning: value computed is not used [-Wunused-value]: 4739:587, 4395:588, 493:3, 4466:608, 488:601, 2023:587, 547:607, 4395:4, 493:612, 4466:4, 547:3, 2027:2, 488:2, 544:612, 519:3, 544:3, 4739:3, 2023:3, 2027:586, 519:612 => 
  - drivers/scsi/qla2xxx/qla_dbg.c: warning: value computed is not used [-Wunused-value]: 1880:461, 134:6, 1564:461, 1244:2, 1869:461, 2261:3, 1226:461, 1889:2, 1560:431, 134:430, 976:2, 1542:2, 1235:2, 2258:427, 1226:2, 2264:427, 976:431, 1244:431, 1551:2, 246:426, 980:2, 2258:3, 1248:2, 2261:427, 1542:461, 140:5, 1902:461, 1898:431, 1551:471, 1235:471, 980:461, 1564:2, 1889:471, 1248:461, 2264:3, 140:429, 1880:2, 1898:2, 1902:2, 1869:2, 1560:2, 246:2 => 
  - drivers/scsi/qla2xxx/qla_init.c: warning: value computed is not used [-Wunused-value]: 4628:426, 1083:426, 1080:2, 1083:2, 1077:2, 4628:2, 4630:426, 1920:436, 1080:426, 1920:2, 1077:426, 4630:2 => 
  - drivers/scsi/qla2xxx/qla_iocb.c: warning: value computed is not used [-Wunused-value]: 1769:2, 488:4, 1568:491, 491:478, 1568:2, 1769:491, 488:493, 491:4 => 
  - drivers/scsi/qla2xxx/qla_isr.c: warning: value computed is not used [-Wunused-value]: 2441:461, 2607:3, 2568:3, 2635:3, 2441:2, 2473:471, 2635:427, 2568:427, 2607:427, 2473:2 => 
  - drivers/scsi/qla2xxx/qla_mbx.c: warning: value computed is not used [-Wunused-value]: 4249:5, 4249:429 => 
  - drivers/scsi/qla2xxx/qla_nx.c: warning: value computed is not used [-Wunused-value]: 921:2, 921:561 => 
  - drivers/scsi/qla2xxx/qla_os.c: warning: value computed is not used [-Wunused-value]: 1538:2, 1523:2, 1538:431, 1523:431 => 
  - drivers/scsi/qla2xxx/qla_sup.c: warning: value computed is not used [-Wunused-value]: 504:456, 1796:3, 1115:461, 1381:461, 1115:2, 1154:461, 1154:2, 1406:2, 1841:431, 1406:461, 504:2, 1381:2, 1796:432, 1841:2 => 
  - drivers/scsi/qla2xxx/qla_target.c: warning: value computed is not used [-Wunused-value]: 4716:487, 4716:3 => 
  - drivers/scsi/qla4xxx/ql4_init.c: warning: value computed is not used [-Wunused-value]: 806:483, 803:4, 680:9, 131:3, 614:471, 718:482, 614:2, 803:483, 680:483, 683:2, 683:481, 718:3, 806:4, 131:472 => 
  - drivers/scsi/qla4xxx/ql4_inline.h: warning: value computed is not used [-Wunused-value]: 58:3, 47:3, 44:3, 61:3, 44:527, 47:482, 61:482, 58:527 => 
  - drivers/scsi/qla4xxx/ql4_iocb.c: warning: value computed is not used [-Wunused-value]: 235:2, 198:516, 248:2, 198:2, 262:2, 248:466, 262:471, 204:2, 204:521, 235:521 => 
  - drivers/scsi/qla4xxx/ql4_isr.c: warning: value computed is not used [-Wunused-value]: 898:516, 1008:5, 1013:483, 1026:483, 1008:484, 923:3, 1026:4, 923:482, 898:2, 1013:4 => 
  - drivers/scsi/qla4xxx/ql4_mbx.c: warning: value computed is not used [-Wunused-value]: 27:481, 27:2, 25:476, 25:2 => 
  - drivers/scsi/qla4xxx/ql4_nvram.c: warning: value computed is not used [-Wunused-value]: 233:2, 16:2, 233:461, 16:441 => 
  - drivers/scsi/qla4xxx/ql4_nx.c: warning: value computed is not used [-Wunused-value]: 2981:522, 3286:496, 2984:517, 3284:2, 2981:3, 2984:3, 3286:2, 3284:541 => 
  - drivers/scsi/qla4xxx/ql4_os.c: warning: value computed is not used [-Wunused-value]: 2812:482, 2812:3, 2770:2, 2839:3, 3525:522, 3519:482, 2839:482, 3522:517, 2853:3, 3525:3, 3519:3, 2770:481, 2853:482, 3522:3 => 
  - drivers/scsi/stex.c: warning: value computed is not used [-Wunused-value]: 1062:2, 1056:2, 853:431, 1035:431, 1033:2, 512:2, 1283:2, 1062:431, 1257:2, 1058:2, 1190:432, 1060:431, 1033:431, 1283:501, 1107:466, 512:481, 1038:2, 992:432, 1058:431, 992:3, 853:2, 1038:431, 1109:451, 870:432, 1257:431, 543:2, 1040:431, 1056:431, 1109:2, 1035:2, 870:3, 1190:3, 1040:2, 541:2, 541:516, 1060:2, 543:501, 1107:2 => 
  - drivers/spi/spi-altera.c: warning: value computed is not used [-Wunused-value]: 263:437, 263:3 => 
  - drivers/spi/spi-atmel.c: warning: 'atmel_spi_remove' defined but not used: 1013 => 
  - drivers/staging/android/binder.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 2230:2351, 2273:1080, 2233:2354, 2230:1077, 2273:2354, 2233:1080 => 2230:9, 2273:8, 2233:9
  - drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 2 has type 'ssize_t' [-Wformat]: 146:3 => 
  - drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 146:3 => 
  - drivers/staging/cxt1e1/functions.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 275:21, 275:19 => 275:21
  - drivers/staging/line6/driver.c: warning: 'line6_write_hexdump' uses dynamic stack allocation [enabled by default]: 176:1 => 
  - drivers/staging/ramster/zbud.c: warning: passing argument 4 of 'debugfs_create_size_t' from incompatible pointer type [enabled by default]: 326:2, 332:5, 329:2, 336:2, 333:2, 335:2, 334:2, 325:5, 327:2, 328:2, 330:2, 323:2, 337:2 => 
  - drivers/staging/ramster/zcache-main.c: warning: passing argument 4 of 'debugfs_create_size_t' from incompatible pointer type [enabled by default]: 235:5, 203:2, 209:2, 237:5, 213:2, 204:2, 231:5, 219:2, 221:2, 215:2, 229:5, 202:2, 198:2, 197:2, 199:2, 210:2, 233:5, 214:2, 223:2, 222:2, 201:2, 227:5, 211:2, 218:2, 212:2, 224:2, 200:2, 220:2, 196:2, 225:2, 206:5, 207:2, 195:2, 217:5, 208:2 => 
  - drivers/staging/rtl8192e/rtllib_softmac.c: warning: value computed is not used [-Wunused-value]: 924:3, 924:4 => 924:3
  - drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'sm7xx_vga_setup' defined but not used [-Wunused-function]: 117:19, 117:122 => 117:19
  - drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]: 2262:7 => 
  - drivers/tty/serial/8250/8250.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1752:28, 1757:18, 1752:32, 1752:2 => 1712:2, 1714:18, 1717:18
  - drivers/tty/serial/8250/8250_pci.c: warning: value computed is not used [-Wunused-value]: 308:3, 285:416, 308:417, 285:2 => 
  - drivers/tty/serial/uartlite.c: warning: value computed is not used [-Wunused-value]: 233:3 => 
  - drivers/tty/serial/xilinx_uartps.c: warning: 'xuartps_remove' defined but not used [-Wunused-function]: 1000:12 => 
  - drivers/tty/serial/xilinx_uartps.c: warning: value computed is not used [-Wunused-value]: 445:477 => 
  - drivers/usb/core/devio.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 1554:2343, 1554:1069 => 1555:6
  - drivers/usb/gadget/amd5536udc.c: warning: value computed is not used [-Wunused-value]: 2649:5, 2649:509, 1685:451, 1685:2 => 
  - drivers/usb/gadget/f_hid.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 285:3 => 
  - drivers/usb/gadget/f_ncm.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]: 1004:28, 1077:6, 1057:14, 1036:4, 1057:30, 1036:13, 1077:19, 990:5 => 1057:30, 1004:28, 1077:6, 1057:14, 1077:19, 990:5, 1036:4
  - drivers/usb/gadget/goku_udc.c: warning: value computed is not used [-Wunused-value]: 917:447, 206:462, 1318:461, 917:3, 206:3, 1285:461, 1277:2, 1318:2, 1285:2, 1277:461 => 
  - drivers/usb/gadget/inode.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]: 1918:21 => 
  - drivers/usb/gadget/mv_udc_core.c: warning: 'mv_udc_remove' defined but not used [-Wunused-function]: 2131:12 => 
  - drivers/usb/gadget/net2280.h: warning: value computed is not used [-Wunused-value]: 279:2, 279:461 => 
  - drivers/usb/host/oxu210hp-hcd.c: warning: value computed is not used [-Wunused-value]: 2809:2, 3239:472, 2750:471, 2462:2, 3514:2, 2462:471, 2750:2, 3239:3, 3435:3, 3435:472, 2809:511 => 
  - drivers/usb/host/pci-quirks.c: warning: value computed is not used [-Wunused-value]: 514:432, 514:3 => 
  - drivers/usb/misc/sisusbvga/sisusb.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 982:7 => 
  - drivers/usb/misc/sisusbvga/sisusb.c: warning: passing argument 7 of 'sisusb_write_mem_bulk' from incompatible pointer type [enabled by default]: 1336:2 => 
  - drivers/usb/misc/sisusbvga/sisusb_con.c: warning: passing argument 5 of 'sisusb_copy_memory' from incompatible pointer type [enabled by default]: 996:4, 880:5, 554:5, 472:5, 985:4, 418:5, 991:4, 505:5, 664:5, 383:5 => 
  - drivers/video/aty/radeon_accel.c: warning: value computed is not used [-Wunused-value]: 221:502, 243:502, 234:502, 247:2, 247:501, 234:3, 221:3, 243:3 => 
  - drivers/video/aty/radeon_pm.c: warning: value computed is not used [-Wunused-value]: 1621:2, 1436:2, 1751:2 => 
  - drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 807:11 => 
  - drivers/video/savage/savagefb-i2c.c: warning: value computed is not used [-Wunused-value]: 56:496, 70:2, 56:2, 70:496 => 
  - drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_resume' defined but not used [-Wunused-function]: 596:12 => 
  - drivers/video/sh_mobile_meram.c: warning: 'sh_mobile_meram_suspend' defined but not used [-Wunused-function]: 572:12 => 
  - drivers/video/sm501fb.c: warning: value computed is not used [-Wunused-value]: 141:426, 141:2 => 
  - fs/9p/xattr.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]: 35:3 => 
  - fs/afs/write.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]: 653:2, 649:3 => 
  - fs/binfmt_som.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 99:1029, 93:2268, 102:2247, 93:1029, 99:2268, 102:1018, 96:1018, 96:2247 => 93:3, 96:2, 102:2, 99:3
  - fs/btrfs/volumes.c: warning: 'max_chunk_size' may be used uninitialized in this function [-Wuninitialized]: 3579:223, 3579:19 => 3759:19
  - fs/cifs/connect.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 2404:3, 2396:3, 2389:3, 2414:3 => 
  - fs/cifs/xattr.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 322:5 => 
  - fs/ecryptfs/crypto.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 1513:11 => 
  - fs/ecryptfs/miscdev.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 452:11, 413:10 => 
  - fs/ext4/inode.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'ssize_t' [-Wformat]: 2969:2 => 
  - fs/ext4/page-io.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'ssize_t' [-Wformat]: 104:5 => 
  - fs/f2fs/node.c: warning: 'nofs' may be used uninitialized in this function [-Wuninitialized]: 738:8 => 
  - fs/nfsd/nfs4state.c: warning: unused variable 'nn' [-Wunused-variable]: 1051:19 => 
  - fs/ocfs2/cluster/tcp.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 12 has type 'ssize_t' [-Wformat]: 997:3 => 
  - fs/ocfs2/dlmfs/dlmfs.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 7 has type 'ssize_t' [-Wformat]: 328:2, 284:2 => 
  - fs/quota/quota_tree.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]: 373:4 => 
  - fs/quota/quota_v2.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'ssize_t' [-Wformat]: 66:92 => 
  - include/asm-generic/io.h: warning: passing argument 1 of '__raw_readl' makes pointer from integer without a cast [enabled by default]: 182:4, 125:2 => 196:4
  - include/asm-generic/io.h: warning: passing argument 1 of '__raw_readw' makes pointer from integer without a cast [enabled by default]: 169:4, 120:2 => 183:4
  - include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u16' makes pointer from integer without a cast [enabled by default]: 169:4, 120:2 => 183:4
  - include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u32' makes pointer from integer without a cast [enabled by default]: 182:4, 125:2 => 196:4
  - include/linux/err.h: warning: 'dst_di' may be used uninitialized in this function [-Wuninitialized]: 39:38, 39:17 => 39:17
  - kernel/futex.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 2496:2291, 2496:1042 => 2495:9
  - kernel/signal.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 3086:2342, 2688:1202, 2716:2597, 2712:1244, 2688:2561, 3086:1073, 2712:2633, 2681:1245, 3111:2340, 3111:1076, 2681:2634, 2716:1223 => 2787:10, 2783:10, 2752:11, 2759:10, 3214:10, 3191:11
  - kernel/sys.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 1987:2306, 1987:1057 => 1989:9
  - kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]: 2401:8 => 
  - mm/memcontrol.c: warning: 'memcg_propagate_kmem' defined but not used [-Wunused-function]: 4974:12 => 
  - modpost: WARNING: modpost: Found 8 section mismatch(es).: N/A => 
  - net/ceph/messenger.c: warning: 'proto' may be used uninitialized in this function [-Wuninitialized]: 907:39, 907:38 => 958:38
  - net/core/dev.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 5060:195, 5129:194 => 
  - net/dccp/timer.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 285:75, 285:2 => 285:2
  - net/ipv4/igmp.c: warning: overflow in implicit constant conversion [-Woverflow]: 2314:3, 1898:3 => 
  - net/ipv6/mcast.c: warning: overflow in implicit constant conversion [-Woverflow]: 310:3, 240:4 => 
  - net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 334:7 => 
  - net/packet/af_packet.c: warning: 'hdrlen' may be used uninitialized in this function [-Wuninitialized]: 1780:30, 1780:16 => 1780:16
  - net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 693:2 => 
  - net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 675:5 => 
  - net/sunrpc/svc.c: warning: unused variable 'buf' [-Wunused-variable]: 1050:7 => 
  - net/sunrpc/svc.c: warning: unused variable 'buf': 1050:7, 1050 => 
  - net/sunrpc/xprtsock.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'ssize_t' [-Wformat]: 1203:2 => 
  - sound/pci/atiixp.c: warning: value computed is not used [-Wunused-value]: 513:491, 522:492, 513:2, 522:3 => 
  - sound/pci/atiixp_modem.c: warning: value computed is not used [-Wunused-value]: 498:492, 498:3, 489:2, 489:491 => 
  - sound/pci/au88x0/au88x0_core.c: warning: value computed is not used [-Wunused-value]: 2695:2, 967:566, 875:566, 2561:486, 1248:3, 1207:648, 875:2, 2421:2, 967:561, 2561:2, 1475:643, 1169:2, 1169:576, 2482:3, 967:2, 1248:637, 1207:4, 2421:496, 2695:496, 1475:4, 2482:497, 875:561 => 
  - sound/pci/lx6464es/lx6464es.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 1028:26 => 
  - sound/soc/codecs/wm8903.c: warning: initialization makes pointer from integer without a cast [enabled by default]: 1954:30 => 
  - sound/soc/codecs/wm8983.c: warning: 'pll_div.div2' may be used uninitialized in this function [-Wuninitialized]: 869:23 => 
  - sound/soc/codecs/wm8983.c: warning: 'pll_div.k' may be used uninitialized in this function [-Wuninitialized]: 872:15 => 
  - sound/soc/codecs/wm8983.c: warning: 'pll_div.n' may be used uninitialized in this function [-Wuninitialized]: 870:9 => 
  - sound/soc/codecs/wm8985.c: warning: 'pll_div.div2' may be used uninitialized in this function [-Wuninitialized]: 848:23 => 
  - sound/soc/codecs/wm8985.c: warning: 'pll_div.k' may be used uninitialized in this function [-Wuninitialized]: 851:15 => 
  - sound/soc/codecs/wm8985.c: warning: 'pll_div.n' may be used uninitialized in this function [-Wuninitialized]: 849:9 => 
  - warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER): N/A => 
  - warning: (CAN_PEAK_PCIEC && SFC && DRM && FB_DDC && FB_BFIN_7393 && FB_VIA && SND_AOA_ONYX && SND_AOA_TAS && SND_SOC_BFIN_EVAL_ADAU1701 && FB_OLPC_DCON) selects I2C which has unmet direct dependencies (!S390): N/A => 
  - warning: (CNIC) selects UIO which has unmet direct dependencies (!S390): N/A => 
  - warning: (DVB_USB_PCTV452E) selects TTPCI_EEPROM which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_PCI_SUPPORT && MEDIA_DIGITAL_TV_SUPPORT && I2C): N/A => 
  - warning: (I2C_TAOS_EVM) selects SERIO which has unmet direct dependencies (!S390 && !UML): N/A => 
  - warning: (I2C_TAOS_EVM) selects SERIO_SERPORT which has unmet direct dependencies (!S390 && !UML && SERIO): N/A => 
  - warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A => 
  - warning: (NET_DSA && GRETH && DNET && LPC_ENET && OCTEON_MGMT_ETHERNET && ETHOC && SH_ETH && S6GMAC && MIPS_AU1X00_ENET && MACB && BFIN_MAC && BCM63XX_ENET && SB1250_MAC && TIGON3 && FTGMAC100 && FEC && FEC_MPC52xx && FS_ENET && FSL_PQ_MDIO && FSL_XGMAC_MDIO && UCC_GETH && GIANFAR && IXP4XX_ETH && MV643XX_ETH && MVNETA && PXA168_ETH && AX88796 && W90P910_ETH && PASEMI_MAC && R6040 && SMSC911X && SMSC9420 && STMMAC_ETH && TI_DAVINCI_EMAC && TI_DAVINCI_MDIO && CPMAC && TC35815 && XILINX_EMACLITE && XILINX_AXI_EMAC && XILINX_LL_TEMAC && USB_NET_AX8817X && ET131X && OCTEON_ETHERNET) selects PHYLIB which has unmet direct dependencies (!S390 && NETDEVICES): N/A => 
  - warning: (PM_SLEEP_SMP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV || PPC_85xx && !PPC_E500MC)): N/A => 
  - warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON || MIPS_SEAD3)): N/A => 
  - warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD): N/A => 
  - warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD): N/A => 
  - warning: (VERSATILE_FPGA_IRQ && REGMAP && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_TPS65910 && TWL4030_CORE && MFD_LP8788 && MFD_MAX77686 && MFD_MAX8997 && MFD_WM831X_I2C && MFD_WM831X_SPI && AB8500_CORE && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS): N/A => 
  - warning: 1 bad relocations: N/A => 
  - warning: 3 bad relocations: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x1c36c): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x3dce0): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x3f0fc): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x1026c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xecc0): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2644): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: drivers/net/cris/built-in.o(.text+0x135e): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.text+0xb60): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DevicePresent(): N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.text+0xbc2): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature(): N/A => 
  - warning: drivers/net/ethernet/amd/depca.o(.text+0xc10): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init(): N/A => 
  - warning: drivers/w1/masters/w1-gpio.o(.data+0x188): Section mismatch in reference from the variable w1_gpio_driver to the function .init.text:w1_gpio_probe(): N/A => 
  - warning: drivers/w1/masters/w1-gpio.o(.data+0x190): Section mismatch in reference from the variable w1_gpio_driver to the function .init.text:w1_gpio_probe(): N/A => 
  - warning: drivers/w1/masters/w1-gpio.o(.data+0x1a0): Section mismatch in reference from the variable w1_gpio_driver to the function .init.text:w1_gpio_probe(): N/A => 
  - warning: mm/built-in.o(.meminit.text+0x107c): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.meminit.text+0x148c): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.text+0x149b58): Section mismatch in reference from the function pwm_get_chip_data() to the function .init.text:pcibios_fixup_bus(): N/A => 
  - warning: vmlinux.o(.text+0x14dc04): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus(): N/A => 
  - warning: vmlinux.o(.text+0x1d564): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x2618c): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init(): N/A => 
  - warning: vmlinux.o(.text+0x26198): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.notify_cpu_starting(): N/A => 
  - warning: vmlinux.o(.text+0x2b39c): Section mismatch in reference from the function .kexec_prepare_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x2bc84): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x2bd84): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x3b98): Section mismatch in reference from the function pgd_ctor() to the function .init.text:__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x45a3): Section mismatch in reference from the function iss_net_setup() to the function .init.text:__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x490c0): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init(): N/A => 
  - warning: vmlinux.o(.text+0x490e4): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.notify_cpu_starting(): N/A => 
  - warning: vmlinux.o(.text+0x4a5dc): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.vdso_getcpu_init(): N/A => 
  - warning: vmlinux.o(.text+0x4a600): Section mismatch in reference from the function .start_secondary() to the function .cpuinit.text:.notify_cpu_starting(): N/A => 
  - warning: vmlinux.o(.text+0x528e8): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x53e04): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x78530): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x7afdc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x8082): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:spinning_secondaries: N/A => 
  - warning: vmlinux.o(.text+0x90be): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:spinning_secondaries: N/A => 
  - warning: vmlinux.o(.text+0x98078): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x9ab38): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
