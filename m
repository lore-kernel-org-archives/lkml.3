Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbaGAH6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:58:45 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:53063 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbaGAH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:58:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.16-rc3
Date: Tue,  1 Jul 2014 09:58:44 +0200
Message-Id: <1404201524-7568-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.16-rc3[1] compared to v3.15-rc8[2].

Summarized:
  - build errors: +19/-3
  - build warnings: +89/-68

JFYI, when comparing v3.16-rc3[1]  to v3.16-rc2[3], the summaries are:
  - build errors: +5/-63
  - build warnings: +35/-38

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.16-rc3.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7619/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7532/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7595/ (all 119 configs)


*** ERRORS ***

19 regressions:
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add' [-Werror=implicit-function-declaration]:  => 176:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add_negative' [-Werror=implicit-function-declaration]:  => 211:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add_return' [-Werror=implicit-function-declaration]:  => 218:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec' [-Werror=implicit-function-declaration]:  => 169:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec_and_test' [-Werror=implicit-function-declaration]:  => 197:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec_return' [-Werror=implicit-function-declaration]:  => 239:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc' [-Werror=implicit-function-declaration]:  => 162:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc_and_test' [-Werror=implicit-function-declaration]:  => 204:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc_return' [-Werror=implicit-function-declaration]:  => 232:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_set' [-Werror=implicit-function-declaration]:  => 155:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub' [-Werror=implicit-function-declaration]:  => 183:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub_and_test' [-Werror=implicit-function-declaration]:  => 190:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub_return' [-Werror=implicit-function-declaration]:  => 225:2
  + /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function '__atomic_add_unless' [-Werror=implicit-function-declaration]:  => 53:2
  + /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function 'atomic_cmpxchg' [-Werror=implicit-function-declaration]:  => 89:3
  + /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function 'atomic_read' [-Werror=implicit-function-declaration]:  => 136:2
  + /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endianmake[3]: :  => 1:0
  + error: filter.c: undefined reference to `__fpscr_values':  => .text+0x31c8c), .text+0x3156c), .text+0x323b0), .text+0x31760), .text+0x31f00)
  + error: misc.c: undefined reference to `ftrace_likely_update':  => .text+0x22c), .text+0x898)

3 improvements:
  - /scratch/kisskb/src/arch/powerpc/platforms/powernv/setup.c: error: implicit declaration of function 'get_hard_smp_processor_id' [-Werror=implicit-function-declaration]: 179:4 => 
  - /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - error: "flush_cache_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!: N/A => 


*** WARNINGS ***

89 regressions:
  + /scratch/kisskb/src/arch/mips/include/asm/page.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]:  => 206:2
  + /scratch/kisskb/src/arch/powerpc/boot/addnote.c: warning: right shift count >= width of type [enabled by default]:  => 211:3, 188:3, 183:3, 206:3
  + /scratch/kisskb/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2160 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 566:1
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 347, 349
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence  CC      arch/sh/kernel/cpu/sh4/softfloat.o:  => 383
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4a/setup-sh7786.c: warning: 'tmu3_device' defined but not used [-Wunused-variable]:  => 251:31
  + /scratch/kisskb/src/arch/sparc/include/asm/atomic_32.h: warning: conflicting types for 'atomic_set' [enabled by default]:  => 27:6
  + /scratch/kisskb/src/arch/sparc/include/asm/processor.h: warning: "nop" redefined [enabled by default]:  => 9:0
  + /scratch/kisskb/src/arch/x86/kernel/cpu/common.c: warning: 'syscall32_cpu_init' defined but not used [-Wunused-function]:  => 960:13
  + /scratch/kisskb/src/drivers/base/regmap/regmap-mmio.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 86:1
  + /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]:  => 194:13
  + /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]:  => 177:13
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_gem_userptr.c: warning: 'mmu' may be used uninitialized in this function [-Wuninitialized]:  => 321:11
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 77:6
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 117:5
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 118:15
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 118:3
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/i2c/nv94.c: warning: 'stat' may be used uninitialized in this function [-Wuninitialized]:  => 185:31
  + /scratch/kisskb/src/drivers/hid/hid-rmi.c: warning: 'rmi_post_reset' defined but not used [-Wunused-function]:  => 431:12
  + /scratch/kisskb/src/drivers/hid/hid-rmi.c: warning: 'rmi_post_resume' defined but not used [-Wunused-function]:  => 436:12
  + /scratch/kisskb/src/drivers/input/keyboard/st-keyscan.c: warning: 'keyscan_resume' defined but not used [-Wunused-function]:  => 235:12
  + /scratch/kisskb/src/drivers/input/keyboard/st-keyscan.c: warning: 'keyscan_suspend' defined but not used [-Wunused-function]:  => 218:12
  + /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.11' uses dynamic stack allocation [enabled by default]:  => 572:1
  + /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_tcw_whitening.isra.10' uses dynamic stack allocation [enabled by default]:  => 714:1
  + /scratch/kisskb/src/drivers/media/firewire/firedtv-avc.c: warning: 'pos' may be used uninitialized in this function [-Wuninitialized]:  => 608:26
  + /scratch/kisskb/src/drivers/mfd/stmpe-i2c.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 88:13
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 417:1 => 417:1, 972:1
  + /scratch/kisskb/src/drivers/mtd/inftlmount.c: warning: 'check_free_sectors.isra.0.constprop.1' uses dynamic stack allocation [enabled by default]:  => 361:1
  + /scratch/kisskb/src/drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 52:2
  + /scratch/kisskb/src/drivers/mtd/nftlmount.c: warning: 'check_free_sectors.isra.0' uses dynamic stack allocation [enabled by default]:  => 294:1
  + /scratch/kisskb/src/drivers/net/ethernet/xilinx/ll_temac_main.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 78:7
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'atqa' may be used uninitialized in this function [-Wuninitialized]:  => 488:21
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 490:10, 490:4
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'sak' may be used uninitialized in this function [-Wuninitialized]:  => 489:20, 484:31
  + /scratch/kisskb/src/drivers/nfc/trf7970a.c: warning: 'trf7970a_init' defined but not used [-Wunused-function]:  => 754:12
  + /scratch/kisskb/src/drivers/platform/x86/tc1100-wmi.c: warning: 'suspend_data' defined but not used [-Wunused-variable]:  => 55:27
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]:  => 693:12
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]:  => 724:13
  + /scratch/kisskb/src/drivers/sh/clk/cpg.c: warning: passing argument 1 of 'ioread8' discards 'const' qualifier from pointer target type [enabled by default]  CC      drivers/tty/tty_mutex.o:  => 41:2
  + /scratch/kisskb/src/drivers/spi/spi-rspi.c: warning: unused variable 'ret' [-Wunused-variable]:  => 633:6
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 582:1
  + /scratch/kisskb/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 2 has type 'sk_buff_data_t' [-Wformat]:  => 885:5
  + /scratch/kisskb/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 3 has type 'sk_buff_data_t' [-Wformat]:  => 885:5
  + /scratch/kisskb/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]:  => 411:3
  + /scratch/kisskb/src/drivers/usb/misc/usb3503.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 195:11
  + /scratch/kisskb/src/drivers/video/fbdev/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + /scratch/kisskb/src/drivers/video/fbdev/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1185:23
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function [-Wuninitialized]:  => 920:9, 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function:  => 913
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function [-Wuninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function:  => 913
  + /scratch/kisskb/src/fs/f2fs/node.c: warning: 'restore_node_summary' uses dynamic stack allocation [enabled by default]:  => 1743:1
  + /scratch/kisskb/src/fs/nfs/filelayout/filelayout.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 85:1
  + /scratch/kisskb/src/fs/splice.c: warning: 'ret' may be used uninitialized in this function:  => 954
  + /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u8' makes pointer from integer without a cast [enabled by default]  LD      drivers/net/ethernet/brocade/built-in.o:  => 209:4
  + /scratch/kisskb/src/include/linux/scatterlist.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]:  => 115:2
  + /scratch/kisskb/src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32' [-Wattributes]/scratch/kisskb/src/include/linux/sysv_fs.h:130:2: warning: 'packed' attribute ignored for field of type '__fs32' [-Wattributes]:  => 144:2
  + /scratch/kisskb/src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32' [-Wattributes]/scratch/kisskb/src/include/linux/sysv_fs.h:42:2: warning: 'packed' attribute ignored for field of type '__fs32' [-Wattributes]:  => 43:2
  + /scratch/kisskb/src/include/linux/typecheck.h: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 11:18
  + /scratch/kisskb/src/include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + /scratch/kisskb/src/include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 1609:13 => 1772:13, 1036:9
  + /scratch/kisskb/src/lib/cpumask.c: warning: the address of 'cpu_all_bits' will always evaluate as 'true' [-Waddress]:  => 194:6
  + /scratch/kisskb/src/mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in this function [-Wuninitialized]: 5714:32, 5586:19, 5696:35 => 5568:35, 5458:19, 5586:32, 5455:16
  + /scratch/kisskb/src/mm/slub.c: warning: '__slab_alloc.constprop.44' uses dynamic stack allocation [enabled by default]:  => 2391:1
  + /scratch/kisskb/src/mm/slub.c: warning: 'get_partial_node.isra.35' uses dynamic stack allocation [enabled by default]:  => 1656:1
  + /scratch/kisskb/src/mm/slub.c: warning: 'unfreeze_partials.isra.33' uses dynamic stack allocation [enabled by default]:  => 2016:1
  + /scratch/kisskb/src/net/mac802154/llsec.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 654:1
  + /scratch/kisskb/src/sound/pci/hda/hda_intel.c: warning: 'haswell_restore_bclk' defined but not used [-Wunused-function]:  => 609:13
  + /scratch/kisskb/src/sound/pci/hda/hda_intel.c: warning: 'haswell_save_bclk' defined but not used [-Wunused-function]:  => 601:13
  + /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_resume' defined but not used [-Wunused-function]:  => 2432:12
  + /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_suspend' defined but not used [-Wunused-function]:  => 2449:12
  + /scratch/kisskb/src/sound/soc/fsl/fsl_sai.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 337:7
  + warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (PPC_CELLEB) selects HAS_TXX9_SERIAL which has unmet direct dependencies (TTY && HAS_IOMEM):  => N/A
  + warning: drivers/built-in.o(.text+0x2cd398): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x518ec): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x42aac): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x41930): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x419d0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x41b34): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x41c44): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41ca4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41d04): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41d6c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41f3c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

68 improvements:
  - /scratch/kisskb/src/arch/cris/include/arch-v10/arch/system.h: warning: "nop" redefined [enabled by default]: 39:0 => 
  - /scratch/kisskb/src/arch/powerpc/kvm/book3s_64_mmu.c: warning: 'slb' may be used uninitialized in this function [-Wuninitialized]: 604:6 => 
  - /scratch/kisskb/src/arch/s390/kvm/priv.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 54:13 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]: 243:17 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i915/i915_cmd_parser.c: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]: 405:4 => 
  - /scratch/kisskb/src/drivers/input/keyboard/stmpe-keypad.c: warning: 'stmpe_keypad_irq' uses dynamic stack allocation [enabled by default]: 166:1 => 
  - /scratch/kisskb/src/drivers/input/misc/max8997_haptic.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]: 185:19 => 
  - /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.8' uses dynamic stack allocation [enabled by default]: 572:1 => 
  - /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_tcw_whitening.isra.7' uses dynamic stack allocation [enabled by default]: 714:1 => 
  - /scratch/kisskb/src/drivers/mfd/stmpe.c: warning: 'stmpe_irq' uses dynamic stack allocation [enabled by default]: 890:1 => 
  - /scratch/kisskb/src/drivers/mfd/stmpe.c: warning: 'stmpe_set_altfunc' uses dynamic stack allocation [enabled by default]: 286:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]  CC [M]  drivers/media/i2c/cx25840/cx25840-ir.o: 972:1 => 
  - /scratch/kisskb/src/drivers/mtd/inftlmount.c: warning: 'check_free_sectors.constprop.0' uses dynamic stack allocation [enabled by default]: 361:1 => 
  - /scratch/kisskb/src/drivers/mtd/mtdchar.c: warning: passing argument 2 of 'access_ok' makes pointer from integer without a cast [enabled by default]: 575:4, 576:4 => 
  - /scratch/kisskb/src/drivers/mtd/nftlmount.c: warning: 'check_free_sectors' uses dynamic stack allocation [enabled by default]: 294:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: warning: passing argument 1 of 'bnx2x_vf_pci_dealloc' from incompatible pointer type [enabled by default]: 13241:4 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: 'return' with a value, in function returning void [enabled by default]: 574:59 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: 'struct bnx2' declared inside parameter list [enabled by default]: 574:48 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]: 574:48 => 
  - /scratch/kisskb/src/drivers/net/ethernet/intel/i40e/i40e.h: warning: "prefetch" redefined [enabled by default]: 101:0 => 
  - /scratch/kisskb/src/drivers/net/wan/farsync.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1408:10 => 
  - /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'phys_addr_t' [-Wformat]: 1006:2 => 
  - /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]: 1006:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 1563:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/rts5139/rts51x.c: warning: 'rts51x_try_to_enter_ss' defined but not used [-Wunused-function]: 203:13 => 
  - /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'invalid_cmd_field' defined but not used [-Wunused-variable]: 651:11 => 
  - /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'media_not_present' defined but not used [-Wunused-variable]: 649:11 => 
  - /scratch/kisskb/src/drivers/staging/silicom/bpctl_mod.c: warning: 'bp_proc_create' defined but not used [-Wunused-function]: 6786:12 => 
  - /scratch/kisskb/src/drivers/staging/vt6655/iwctl.c: warning: the frame size of 1280 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 759:1 => 
  - /scratch/kisskb/src/drivers/staging/vt6655/iwctl.c: warning: the frame size of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 759:1 => 
  - /scratch/kisskb/src/drivers/usb/host/xhci-plat.c: warning: 'xhci_plat_resume' defined but not used [-Wunused-function]: 214:12 => 
  - /scratch/kisskb/src/drivers/usb/host/xhci-plat.c: warning: 'xhci_plat_suspend' defined but not used [-Wunused-function]: 206:12 => 
  - /scratch/kisskb/src/drivers/video/fbdev/intelfb/intelfbhw.c: warning: 'm1' may be used uninitialized in this function [-Wuninitialized]: 1147:13 => 
  - /scratch/kisskb/src/drivers/video/fbdev/intelfb/intelfbhw.c: warning: 'm2' may be used uninitialized in this function [-Wuninitialized]: 1146:35 => 
  - /scratch/kisskb/src/fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]: 4121:6 => 
  - /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'seq' may be used uninitialized in this function [-Wuninitialized]: 1418:6 => 
  - /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]: 1268:20, 1455:6 => 
  - /scratch/kisskb/src/fs/hfsplus/xattr.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 86:2 => 
  - /scratch/kisskb/src/fs/nfs/nfs4filelayout.c: warning: control reaches end of non-void function [-Wreturn-type]: 85:1 => 
  - /scratch/kisskb/src/kernel/power/hibernate.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 237:2 => 
  - /scratch/kisskb/src/lib/btree.c: warning: 'btree_get_prev' uses dynamic stack allocation [enabled by default]  CC [M]  drivers/input/joystick/spaceorb.o: 359:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: '__slab_alloc.constprop.43' uses dynamic stack allocation [enabled by default]: 2384:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: 'get_partial_node.isra.34' uses dynamic stack allocation [enabled by default]: 1650:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: 'unfreeze_partials.isra.32' uses dynamic stack allocation [enabled by default]: 2010:1 => 
  - /scratch/kisskb/src/net/dccp/timer.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 285:2 => 
  - /scratch/kisskb/src/net/sunrpc/xprtrdma/verbs.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1774:1 => 
  - /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_resume' defined but not used [-Wunused-function]: 545:12 => 
  - /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_suspend' defined but not used [-Wunused-function]: 520:12 => 
  - warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER): N/A => 
  - warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): N/A => 
  - warning: (INTEL_MIC_HOST && CAIF_VIRTIO && VHOST_NET && VHOST_SCSI && VHOST_NET && VHOST_SCSI) selects VHOST_RING which has unmet direct dependencies (NETDEVICES && CAIF_VIRTIO || VIRTUALIZATION): N/A => 
  - warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet direct dependencies (!CPU_LITTLE_ENDIAN): N/A => 
  - warning: drivers/built-in.o(.text+0x2c020c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x51300): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x3fdd8): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: vmlinux.o(.data+0x41530): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x415d0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41734): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41844): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x418a4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41904): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4196c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41b3c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
