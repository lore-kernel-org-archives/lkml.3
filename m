Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaGZPjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:39:41 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:50550 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaGZPjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:39:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.16-rc5
Date: Sat, 26 Jul 2014 17:39:35 +0200
Message-Id: <1406389175-9745-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.16-rc5[1] compared to v3.15-rc8[2].

Summarized:
  - build errors: +31/-7
  - build warnings: +92/-71

JFYI, when comparing v3.16-rc5[1]  to v3.16-rc4[3], the summaries are:
  - build errors: +14/-11
  - build warnings: +24/-27

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.16-rc5.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7665/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7532/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7639/ (all 119 configs)


*** ERRORS ***

31 regressions:
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
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: 'PAGES_PER_SECTION' undeclared (first use in this function):  => 1149:18, 1779:46, 1887:46
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: 'PAGE_SECTION_MASK' undeclared (first use in this function):  => 1148:20
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: 'PFN_SECTION_SHIFT' undeclared (first use in this function):  => 1348:31
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit declaration of function '__nr_to_section' [-Werror=implicit-function-declaration]:  => 1784:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit declaration of function 'find_memory_block_hinted' [-Werror=implicit-function-declaration]:  => 1791:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit declaration of function 'pfn_to_section_nr' [-Werror=implicit-function-declaration]:  => 1780:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit declaration of function 'present_section_nr' [-Werror=implicit-function-declaration]:  => 1781:3
  + /scratch/kisskb/src/mm/memory_hotplug.c: error: implicit declaration of function 'section_nr_to_pfn' [-Werror=implicit-function-declaration]:  => 1816:3
  + error: filter.c: undefined reference to `__fpscr_values':  => .text+0x3156c), .text+0x31760), .text+0x31f00), .text+0x31c8c), .text+0x323b0)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.__dynamic_pr_debug' defined in .text section in lib/built-in.o:  => (.text+0x1ff939c), (.text+0x1ff92f4)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff93b4)
  + error: stmmac_hwtstamp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8a20), (.text+0x1ff86b0)
  + error: stmmac_platform.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9600)
  + error: stmmac_ptp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff91f4), (.text+0x1ff8fd4), (.text+0x1ff8f00)
  + error: stmmac_ptp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8fdc)

7 improvements:
  - /scratch/kisskb/src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards: 1315 => 
  - /scratch/kisskb/src/arch/powerpc/platforms/powernv/setup.c: error: implicit declaration of function 'get_hard_smp_processor_id' [-Werror=implicit-function-declaration]: 179:4 => 
  - /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - <stdin>: error: -mcall-aixdesc must be big endian: 1:0 => 
  - error: "flush_cache_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!: N/A => 


*** WARNINGS ***

92 regressions:
  + ./scratch/kisskb/src/arch/x86/kernel/cpu/mcheck/mce-inject.c: warning: 'mce_irq_ipi' defined but not used [-Wunused-function]:  => 97:13
  + /scratch/kisskb/src/arch/mips/include/asm/page.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]:  => 206:2
  + /scratch/kisskb/src/arch/powerpc/boot/addnote.c: warning: right shift count >= width of type [enabled by default]:  => 206:3, 211:3, 183:3, 188:3
  + /scratch/kisskb/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2160 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 566:1
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 347, 349
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4a/setup-sh7786.c: warning: 'tmu3_device' defined but not used [-Wunused-variable]:  => 251:31
  + /scratch/kisskb/src/arch/sh/math-emu/math.c: warning: left shift count is negative [enabled by default]  CC      kernel/groups.o:  => 129:1
  + /scratch/kisskb/src/arch/sparc/include/asm/atomic_32.h: warning: conflicting types for 'atomic_set' [enabled by default]:  => 27:6
  + /scratch/kisskb/src/arch/sparc/include/asm/processor.h: warning: "nop" redefined [enabled by default]:  => 9:0
  + /scratch/kisskb/src/arch/x86/kernel/cpu/common.c: warning: 'syscall32_cpu_init' defined but not used [-Wunused-function]:  => 960:13
  + /scratch/kisskb/src/drivers/base/regmap/regmap-mmio.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 86:1
  + /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]:  => 194:13
  + /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]:  => 177:13
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_gem_userptr.c: warning: 'mmu' may be used uninitialized in this function [-Wuninitialized]:  => 321:11
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/i2c/nv94.c: warning: 'stat' may be used uninitialized in this function [-Wuninitialized]:  => 185:31
  + /scratch/kisskb/src/drivers/iio/adc/ad799x.c: warning: 'valin' may be used uninitialized in this function [-Wuninitialized]:  => 458:16
  + /scratch/kisskb/src/drivers/input/keyboard/st-keyscan.c: warning: 'keyscan_resume' defined but not used [-Wunused-function]:  => 235:12
  + /scratch/kisskb/src/drivers/input/keyboard/st-keyscan.c: warning: 'keyscan_suspend' defined but not used [-Wunused-function]:  => 218:12
  + /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.11' uses dynamic stack allocation [enabled by default]:  => 572:1
  + /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_tcw_whitening.isra.10' uses dynamic stack allocation [enabled by default]:  => 714:1
  + /scratch/kisskb/src/drivers/media/firewire/firedtv-avc.c: warning: 'pos' may be used uninitialized in this function [-Wuninitialized]:  => 608:26
  + /scratch/kisskb/src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6884:13
  + /scratch/kisskb/src/drivers/mfd/stmpe-i2c.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 88:13
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 417:1 => 972:1, 417:1
  + /scratch/kisskb/src/drivers/mtd/inftlmount.c: warning: 'check_free_sectors.isra.0.constprop.1' uses dynamic stack allocation [enabled by default]:  => 361:1
  + /scratch/kisskb/src/drivers/mtd/nftlmount.c: warning: 'check_free_sectors.isra.0' uses dynamic stack allocation [enabled by default]:  => 294:1
  + /scratch/kisskb/src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 1 of 'inw' makes integer from pointer without a cast [enabled by default]  CC      net/ipv4/datagram.o:  => 1340:2
  + /scratch/kisskb/src/drivers/net/ethernet/xilinx/ll_temac_main.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 78:7
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'atqa' may be used uninitialized in this function [-Wuninitialized]:  => 488:21
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 490:4, 490:10
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'sak' may be used uninitialized in this function [-Wuninitialized]:  => 484:31, 489:20
  + /scratch/kisskb/src/drivers/nfc/trf7970a.c: warning: 'trf7970a_init' defined but not used [-Wunused-function]:  => 754:12
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]:  => 693:12
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]:  => 724:13
  + /scratch/kisskb/src/drivers/spi/spi-rspi.c: warning: unused variable 'ret' [-Wunused-variable]:  => 633:6
  + /scratch/kisskb/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 2 has type 'sk_buff_data_t' [-Wformat]:  => 885:5
  + /scratch/kisskb/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 3 has type 'sk_buff_data_t' [-Wformat]:  => 885:5
  + /scratch/kisskb/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]:  => 411:3
  + /scratch/kisskb/src/drivers/usb/misc/usb3503.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 195:11
  + /scratch/kisskb/src/drivers/video/fbdev/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1185:23
  + /scratch/kisskb/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + /scratch/kisskb/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + /scratch/kisskb/src/drivers/video/fbdev/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 734:23
  + /scratch/kisskb/src/fs/btrfs/delayed-inode.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 432:17 => 420:9, 435:17
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function [-Wuninitialized]:  => 1011:12, 920:9
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function:  => 913
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function [-Wuninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function:  => 913
  + /scratch/kisskb/src/fs/f2fs/node.c: warning: 'restore_node_summary' uses dynamic stack allocation [enabled by default]:  => 1745:1
  + /scratch/kisskb/src/fs/nfs/filelayout/filelayout.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 85:1
  + /scratch/kisskb/src/fs/ocfs2/stack_o2cb.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 161:19
  + /scratch/kisskb/src/fs/splice.c: warning: 'ret' may be used uninitialized in this function:  => 954
  + /scratch/kisskb/src/include/linux/scatterlist.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]:  => 115:2
  + /scratch/kisskb/src/include/linux/typecheck.h: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 11:18
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 1609:13 => 1804:13, 1036:9
  + /scratch/kisskb/src/lib/cpumask.c: warning: the address of 'cpu_all_bits' will always evaluate as 'true' [-Waddress]:  => 194:6
  + /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: the frame size of 1232 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 514:1
  + /scratch/kisskb/src/mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in this function [-Wuninitialized]: 5696:35, 5714:32, 5586:19 => 5455:16, 5586:32, 5568:35, 5458:19
  + /scratch/kisskb/src/mm/memory_hotplug.c: warning: 'generic_online_page' used but never defined [enabled by default]:  => 46:13
  + /scratch/kisskb/src/mm/memory_hotplug.c: warning: 'online_page_callback' defined but not used [-Wunused-variable]:  => 48:31
  + /scratch/kisskb/src/mm/memory_hotplug.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1791:7, 1784:11
  + /scratch/kisskb/src/mm/slub.c: warning: '__slab_alloc.constprop.44' uses dynamic stack allocation [enabled by default]:  => 2391:1
  + /scratch/kisskb/src/mm/slub.c: warning: 'get_partial_node.isra.35' uses dynamic stack allocation [enabled by default]:  => 1656:1
  + /scratch/kisskb/src/mm/slub.c: warning: 'unfreeze_partials.isra.33' uses dynamic stack allocation [enabled by default]:  => 2016:1
  + /scratch/kisskb/src/net/ipv4/ipconfig.c: warning: 'ic_proto_used' defined but not used [-Wunused-variable]:  => 153:12
  + /scratch/kisskb/src/net/mac802154/llsec.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 654:1
  + /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_resume' defined but not used [-Wunused-function]:  => 2432:12
  + /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_suspend' defined but not used [-Wunused-function]:  => 2449:12
  + /scratch/kisskb/src/sound/soc/fsl/fsl_sai.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 337:7
  + warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && AKEBONO && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
  + warning: drivers/built-in.o(.text+0x2cd434): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x518d8): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x42aac): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: size of symbol `sys_setgid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o:  => N/A
  + warning: vmlinux.o(.data+0x41970): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x41a10): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x41b74): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x41c84): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41ce4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41d44): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41dac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41f7c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

71 improvements:
  - /scratch/kisskb/src/arch/cris/include/arch-v10/arch/system.h: warning: "nop" redefined [enabled by default]: 39:0 => 
  - /scratch/kisskb/src/arch/powerpc/kvm/book3s_64_mmu.c: warning: 'slb' may be used uninitialized in this function [-Wuninitialized]: 604:6 => 
  - /scratch/kisskb/src/arch/s390/kvm/priv.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 54:13 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]: 243:17 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i915/i915_cmd_parser.c: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]: 405:4 => 
  - /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c: warning: the frame size of 3008 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 1380:1 => 
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
  - /scratch/kisskb/src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 1 of 'inw' makes integer from pointer without a cast [enabled by default]: 413:18, 1882:2, 771:2, 1263:4, 676:12, 1339:9, 1931:2, 1338:11, 1195:2, 1171:2, 398:2, 830:2, 1895:2, 1343:2, 1222:2, 1283:4, 1648:2, 1230:12, 620:2, 1247:4, 1232:3, 678:4, 1864:2, 1908:2, 423:2, 1340:2, 728:2, 441:3, 1273:4, 491:3, 1669:2, 1286:4, 716:14, 793:2, 1676:2, 316:2, 469:4, 1342:2, 749:2, 1223:9, 1277:4, 1643:2, 332:2, 1674:2, 1810:16, 723:17, 797:3, 753:2, 570:14, 690:3, 857:2 => 469:4, 316:2, 1676:2, 332:2, 1643:2, 1277:4, 1342:2, 1223:9, 749:2, 1286:4, 491:3, 1669:2, 716:14, 793:2, 690:3, 570:14, 753:2, 857:2, 1810:16, 1674:2, 797:3, 723:17, 1931:2, 1339:9, 830:2, 398:2, 1338:11, 1195:2, 1171:2, 1263:4, 413:18, 1882:2, 771:2, 676:12, 423:2, 1908:2, 1864:2, 1273:4, 441:3, 728:2, 1230:12, 620:2, 1648:2, 1895:2, 1283:4, 1343:2, 1222:2, 1232:3, 678:4, 1247:4
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
  - /scratch/kisskb/src/fs/autofs4/inode.c: warning: 'pgrp' may be used uninitialized in this function: 213 => 
  - /scratch/kisskb/src/fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]: 4121:6 => 
  - /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'seq' may be used uninitialized in this function [-Wuninitialized]: 1418:6 => 
  - /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]: 1455:6, 1268:20 => 
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
