Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaL2UEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 15:04:31 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:40021 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaL2UE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 15:04:28 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.19-rc2
Date: Mon, 29 Dec 2014 20:59:04 +0100
Message-Id: <1419883144-13523-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.19-rc2[1] compared to v3.18[2].

Summarized:
  - build errors: +30/-19
  - build warnings: +183/-118

JFYI, when comparing v3.19-rc2[1]  to v3.19-rc1[3], the summaries are:
  - build errors: +8/-5
  - build warnings: +62/-51

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.19-rc2.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/8257/ (all 262 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/8168/ (all 262 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/8241/ (all 262 configs)


*** ERRORS ***

30 regressions:
  + /home/kisskb/slave/src/arch/powerpc/platforms/pseries/hotplug-memory.c: error: 'SECTION_SIZE_BITS' undeclared (first use in this function):  => 27:31
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: error: too few arguments to function 'ioread16':  => 44:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: error: too few arguments to function 'iowrite16':  => 123:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: error: too few arguments to function 'ioread16':  => 43:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: error: too few arguments to function 'iowrite16':  => 116:2
  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: error: 'bfin_writel' undeclared here (not in a function):  => 476:13
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error: 'MUSB_BABBLE_CTL' undeclared here (not in a function):  => 67:17
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error: 'MUSB_CONFIGDATA' undeclared here (not in a function):  => 62:18
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error: 'MUSB_EPINFO' undeclared here (not in a function):  => 74:14
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error: 'MUSB_RAMINFO' undeclared here (not in a function):  => 75:15
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error: 'MUSB_RXFIFOADD' undeclared here (not in a function):  => 71:17
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error: 'MUSB_RXFIFOSZ' undeclared here (not in a function):  => 69:16
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error: 'MUSB_TXFIFOADD' undeclared here (not in a function):  => 70:17
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error: 'MUSB_TXFIFOSZ' undeclared here (not in a function):  => 68:16
  + /home/kisskb/slave/src/include/linux/irq.h: error: conflicting types for 'ioread16':  => 856:19
  + /home/kisskb/slave/src/include/linux/irq.h: error: conflicting types for 'iowrite16':  => 847:20
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: 'PAGES_PER_SECTION' undeclared (first use in this function):  => 1836:46, 1178:18
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: 'PAGE_SECTION_MASK' undeclared (first use in this function):  => 1177:20
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit declaration of function '__nr_to_section' [-Werror=implicit-function-declaration]:  => 1841:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit declaration of function 'find_memory_block_hinted' [-Werror=implicit-function-declaration]:  => 1848:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit declaration of function 'pfn_to_section_nr' [-Werror=implicit-function-declaration]:  => 1837:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit declaration of function 'present_section_nr' [-Werror=implicit-function-declaration]:  => 1838:3
  + error: "csum_partial_copy_nocheck" [net/ipv6/ipv6.ko] undefined!:  => N/A
  + error: No rule to make target include/config/auto.conf:  => N/A
  + error: initramfs.c: undefined reference to `__stack_chk_guard':  => .init.text+0x3132)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o:  => (.text+0x1ff950c), (.text+0x1ff9a6c), (.text+0x1ff9d28), (.text+0x1ff9488), (.text+0x1ff9cac), (.text+0x1ff9ae4)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.bitrev32' defined in .text section in lib/built-in.o:  => (.text+0x1ff94c4)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8c50)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8168)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8c58)

19 improvements:
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.capacity’): 152:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.seg_max’): 151:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.host_features’): 149:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtnet_dev_page.host_features’): 119:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: braced-group within expression allowed only inside a function: 116:10, 96:10, 93:10, 146:10, 113:10 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: initializer element is not constant: 119:3, 151:3, 149:3, 152:3 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfd' undeclared (first use in this function): 1874:29 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfs' undeclared (first use in this function): 1872:29 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfd' undeclared (first use in this function): 1928:30 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfs' undeclared (first use in this function): 1926:30 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit declaration of function 'do_fp_load' [-Werror=implicit-function-declaration]: 1872:4 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit declaration of function 'do_fp_store' [-Werror=implicit-function-declaration]: 1926:4 => 
  - /home/kisskb/slave/src/arch/powerpc/xmon/xmon.c: error: implicit declaration of function 'dump_tlb_44x' [-Werror=implicit-function-declaration]: 912:4 => 
  - /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: 'AT_FDCWD' undeclared (first use in this function): 378 => 
  - /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: (Each undeclared identifier is reported only once: 378 => 
  - /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: for each function it appears in.): 378 => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o: (.text+0x1ff8714), (.text+0x1ff887c), (.text+0x1ff8794), (.text+0x1ff880c), (.text+0x1ff8a24), (.text+0x1ff858c) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8b0c) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8b14), (.text+0x1ff886c), (.text+0x1ff8580) => 


*** WARNINGS ***

183 regressions:
  + .config: warning: symbol value '' invalid for PHYS_OFFSET:  => 23
  + /home/kisskb/slave/src/arch/cris/arch-v32/kernel/time.c: warning: 'bite_in_progress' defined but not used [-Wunused-variable]:  => 111:12
  + /home/kisskb/slave/src/arch/cris/arch-v32/mach-fs/pinmux.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 49:1
  + /home/kisskb/slave/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2144 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 573:1
  + /home/kisskb/slave/src/arch/s390/kernel/perf_cpum_sf.c: warning: 'perf_push_sample' uses dynamic stack allocation [enabled by default]:  => 1042:1
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: warning: passing argument 2 of 'iowrite16' makes integer from pointer without a cast [enabled by default]:  => 123:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: warning: passing argument 2 of 'iowrite16' makes integer from pointer without a cast [enabled by default]:  => 116:2
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 349, 347
  + /home/kisskb/slave/src/arch/x86/kernel/acpi/boot.c: warning: 'acpi_register_gsi_ioapic' defined but not used [-Wunused-function]:  => 656:12
  + /home/kisskb/slave/src/arch/x86/kernel/acpi/boot.c: warning: 'acpi_unregister_gsi_ioapic' defined but not used [-Wunused-function]:  => 670:13
  + /home/kisskb/slave/src/arch/x86/kvm/emulate.c: warning: left shift count >= width of type [enabled by default]:  => 3552:4
  + /home/kisskb/slave/src/arch/x86/mm/ioremap.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 344:10
  + /home/kisskb/slave/src/drivers/android/binder.c: warning: 'buffer' may be used uninitialized in this function [-Wuninitialized]:  => 714:24
  + /home/kisskb/slave/src/drivers/android/binder.c: warning: 'buffer_size' may be used uninitialized in this function [-Wuninitialized]:  => 714:37
  + /home/kisskb/slave/src/drivers/atm/ambassador.c: warning: passing argument 1 of 'virt_to_bus' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1762:3
  + /home/kisskb/slave/src/drivers/char/ipmi/ipmi_ssif.c: warning: format '%ld' expects argument of type 'long int', but argument 5 has type '__kernel_suseconds_t' [-Wformat]:  => 971:3
  + /home/kisskb/slave/src/drivers/clocksource/timer-marco.c: warning: unused variable 'timer_div' [-Wunused-variable]:  => 260:6
  + /home/kisskb/slave/src/drivers/gpio/gpio-74xx-mmio.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 132:16
  + /home/kisskb/slave/src/drivers/gpio/gpio-wm831x.c: warning: 'powerdomain' may be used uninitialized in this function [-Wuninitialized]:  => 217:13
  + /home/kisskb/slave/src/drivers/gpu/drm/gma500/cdv_intel_dp.c: warning: 'i2c_dp_aux_add_bus' is deprecated (declared at /home/kisskb/slave/src/drivers/gpu/drm/gma500/cdv_intel_dp.c:224) [-Wdeprecated-declarations]:  => 869:2
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_h' may be used uninitialized in this function [-Wuninitialized]:  => 1232:26
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_w' may be used uninitialized in this function [-Wuninitialized]:  => 1232:13
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_x' may be used uninitialized in this function [-Wuninitialized]:  => 1235:25
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_y' may be used uninitialized in this function [-Wuninitialized]:  => 1249:19
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/i2c/gm204.c: warning: 'stat' may be used uninitialized in this function [-Wuninitialized]:  => 155:31
  + /home/kisskb/slave/src/drivers/gpu/drm/radeon/r100.c: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]  LD      arch/x86/kernel/cpu/mcheck/built-in.o:  => 3571:47
  + /home/kisskb/slave/src/drivers/mailbox/pcc.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 210:3, 175:3
  + /home/kisskb/slave/src/drivers/media/pci/cx88/cx88-video.c: warning: 'restart_video_queue' defined but not used [-Wunused-function]:  => 415:12
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1835:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1384 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 417:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 417:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1700 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 972:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1792 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 972:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2156 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + /home/kisskb/slave/src/drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 128:11, 420:15
  + /home/kisskb/slave/src/drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 144:15, 142:20, 102:2, 96:11, 127:2
  + /home/kisskb/slave/src/drivers/net/ethernet/amd/xgbe/xgbe-main.c: warning: 'xgbe_resume' defined but not used [-Wunused-function]:  => 474:12
  + /home/kisskb/slave/src/drivers/net/ethernet/amd/xgbe/xgbe-main.c: warning: 'xgbe_suspend' defined but not used [-Wunused-function]:  => 455:12
  + /home/kisskb/slave/src/drivers/net/ethernet/dec/tulip/tulip_core.c: warning: #warning Processor architecture undefined! [-Wcpp]/home/kisskb/slave/src/drivers/input/touchscreen/cyttsp4_core.c:936:1: warning: 'cyttsp4_get_mt_touches' uses dynamic stack allocation [enabled by default]:  => 101:2
  + /home/kisskb/slave/src/drivers/net/ethernet/dec/tulip/winbond-840.c: warning: #warning Processor architecture undefined [-Wcpp]  CC      net/phonet/pep.o:  => 910:2
  + /home/kisskb/slave/src/drivers/net/ethernet/mellanox/mlx4/alloc.c: warning: 'uid' may be used uninitialized in this function [-Wuninitialized]:  => 416:9
  + /home/kisskb/slave/src/drivers/net/ethernet/neterion/vxge/vxge-main.c: warning: 'adaptive_coalesce_tx_interrupts' defined but not used [-Wunused-function]  CC      net/ipv4/tcp_metrics.o:  => 2121:13
  + /home/kisskb/slave/src/drivers/net/ethernet/rocker/rocker.c: warning: 'rocker_port_vlan_flood_group' uses dynamic stack allocation [enabled by default]:  => 2694:1
  + /home/kisskb/slave/src/drivers/net/ethernet/rocker/rocker.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 809:9
  + /home/kisskb/slave/src/drivers/net/fddi/defxx.c: warning: 'bar_len[0]' may be used uninitialized in this function [-Wuninitialized]:  => 3726:3, 583:10
  + /home/kisskb/slave/src/drivers/net/fddi/defxx.c: warning: 'bar_start[0]' may be used uninitialized in this function [-Wuninitialized]:  => 3726:3, 583:10
  + /home/kisskb/slave/src/drivers/net/wan/lmc/lmc_main.c: warning: passing argument 1 of 'virt_to_bus' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1900:5, 1898:9, 1885:9, 1901:5, 1887:5, 1876:9
  + /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]  CC      drivers/regulator/da9063-regulator.o:  => 123:2
  + /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]  LD      drivers/thermal/samsung/built-in.o:  => 123:2
  + /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]/home/kisskb/slave/src/drivers/mtd/nand/nandsim.c: In function 'init_nandsim':In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/tables_nphy.c:26:0::  => 123:2
  + /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/wa.c:27:0::  => 123:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC      drivers/media/usb/pvrusb2/pvrusb2-wm8775.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC      drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC      drivers/scsi/ufs/ufshcd.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC      drivers/staging/rtl8188eu/core/rtw_ap.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/bus.c:29:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/debugfs.c:33:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/pio.c:26:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/sysfs.c:29:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/tables.c:28:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/tables_lpphy.c:26:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/wlan.h:42:0,:  => 381:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/phy_a.c:31:0::  => 381:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43legacy/debugfs.c:33:0::  => 381:2
  + /home/kisskb/slave/src/drivers/net/wireless/iwlegacy/3945-mac.c: warning: 'phys_addr' may be used uninitialized in this function [-Wuninitialized]  CC [M]  drivers/video/fbdev/cyber2000fb.o:  => 620:33
  + /home/kisskb/slave/src/drivers/net/wireless/iwlwifi/mvm/d3.c: warning: 'fw_status' may be used uninitialized in this function [-Wuninitialized]:  => 1536:37
  + /home/kisskb/slave/src/drivers/net/wireless/p54/lmac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[3]' [-Wattributes]/home/kisskb/slave/src/net/xfrm/xfrm_policy.c: In function 'xfrm_policy_register_afinfo'::  => 377:2
  + /home/kisskb/slave/src/drivers/net/wireless/p54/lmac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[3]' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/radio_2056.c:25:0::  => 377:2
  + /home/kisskb/slave/src/drivers/pwm/pwm-atmel-hlcdc.c: warning: 'clk_period_ns' may be used uninitialized in this function [-Wuninitialized]:  => 72:55
  + /home/kisskb/slave/src/drivers/scsi/am53c974.c: warning: 'resid' may be used uninitialized in this function [-Wuninitialized]:  => 183:3
  + /home/kisskb/slave/src/drivers/scsi/ips.c: warning: #warning "This driver has only been tested on the x86/ia64/x86_64 platforms" [-Wcpp]/home/kisskb/slave/src/drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API [-Wcpp]:  => 210:2
  + /home/kisskb/slave/src/drivers/spi/spi-atmel.c: warning: 'atmel_spi_resume' defined but not used [-Wunused-function]:  => 1484:12
  + /home/kisskb/slave/src/drivers/spi/spi-atmel.c: warning: 'atmel_spi_suspend' defined but not used [-Wunused-function]:  => 1466:12
  + /home/kisskb/slave/src/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c: warning: 'max' may be used uninitialized in this function [-Wuninitialized]:  => 99:6
  + /home/kisskb/slave/src/drivers/staging/comedi/drivers/ni_at_ao.c: warning: statement with no effect [-Wunused-value]  CC      drivers/watchdog/menf21bmc_wdt.o:  => 295:2
  + /home/kisskb/slave/src/drivers/staging/dgap/dgap.h: warning: "IO_FIELD" redefined [enabled by default]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43legacy/phy.c:38:0::  => 444:0
  + /home/kisskb/slave/src/drivers/staging/goldfish/goldfish_nand.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]  LD      drivers/vme/boards/built-in.o:  => 90:14
  + /home/kisskb/slave/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]  CC      drivers/uwb/i1480/dfu/dfu.o:  => 365:3
  + /home/kisskb/slave/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]/home/kisskb/slave/src/drivers/tty/serial/crisv10.c:2506:1: warning: 'ser_interrupt' defined but not used [-Wunused-function]  CC      lib/fonts/font_10x18.o:  => 365:3
  + /home/kisskb/slave/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/staging/vt6656/key.c:34:0::  => 365:3
  + /home/kisskb/slave/src/drivers/tty/serial/8250/8250_core.c: warning: 'flags' may be used uninitialized in this function:  => 3186:16
  + /home/kisskb/slave/src/drivers/tty/serial/mcf.c: warning: unused variable 'pp' [-Wunused-variable]:  => 201:19, 444:19
  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: warning: 'bfin_fifo_offset' defined but not used [-Wunused-function]:  => 36:12
  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: warning: 'binf_writel' defined but not used [-Wunused-function]:  => 66:13
  + /home/kisskb/slave/src/drivers/usb/musb/ux500.c: warning: 'ux500_suspend' defined but not used [-Wunused-function]  CC [M]  net/bridge/netfilter/ebtables.o:  => 342:12
  + /home/kisskb/slave/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 625:11, 443:16, 569:10, 599:32
  + /home/kisskb/slave/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 564:16, 811:11, 785:32
  + /home/kisskb/slave/src/drivers/video/fbdev/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]:  => 64:2
  + /home/kisskb/slave/src/drivers/video/fbdev/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]:  => 65:2
  + /home/kisskb/slave/src/drivers/video/fbdev/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]:  => 4127:13
  + /home/kisskb/slave/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + /home/kisskb/slave/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + /home/kisskb/slave/src/fs/btrfs/raid56.c: warning: 'finish_parity_scrub' uses dynamic stack allocation [enabled by default]:  => 2501:1
  + /home/kisskb/slave/src/fs/ceph/addr.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 10 has type 'size_t' [-Wformat]:  => 1419:2
  + /home/kisskb/slave/src/fs/ceph/locks.c: warning: 'lock_type' may be used uninitialized in this function [-Wuninitialized]:  => 140:40
  + /home/kisskb/slave/src/fs/ext4/extents.c: warning: 'lblock' may be used uninitialized in this function [-Wuninitialized]:  => 2344:58
  + /home/kisskb/slave/src/fs/ext4/extents.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 2344:58
  + /home/kisskb/slave/src/fs/nfsd/nfs4xdr.c: warning: 'end' may be used uninitialized in this function [-Wuninitialized]:  => 1792:11, 1792:42
  + /home/kisskb/slave/src/fs/nfsd/nfs4xdr.c: warning: 'str' may be used uninitialized in this function [-Wuninitialized]:  => 1787:9
  + /home/kisskb/slave/src/include/asm-generic/atomic-long.h: warning: 'counter' may be used uninitialized in this function [-Wuninitialized]:  => 148:2
  + /home/kisskb/slave/src/include/linux/page_counter.h: warning: 'counter' may be used uninitialized in this function [-Wuninitialized]:  => 48:21
  + /home/kisskb/slave/src/include/linux/unaligned/le_byteshift.h: warning: array subscript is above array bounds [-Warray-bounds]:  => 25:7
  + /home/kisskb/slave/src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16' [-Wattributes]/home/kisskb/slave/src/drivers/net/hamradio/yam.c:314:2: warning: statement with no effect [-Wunused-value]:  => 32:2
  + /home/kisskb/slave/src/ipc/shm.c: warning: 'file' may be used uninitialized in this function [-Wuninitialized]:  => 1310:59
  + /home/kisskb/slave/src/ipc/shm.c: warning: 'file' may be used uninitialized in this function:  => 1233
  + /home/kisskb/slave/src/kernel/events/core.c: warning: '__perf_sw_event' uses dynamic stack allocation [enabled by default]:  => 5926:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_event_comm_output' uses dynamic stack allocation [enabled by default]:  => 5278:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_event_mmap_output' uses dynamic stack allocation [enabled by default]:  => 5410:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_event_read_event' uses dynamic stack allocation [enabled by default]:  => 5070:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_event_task_output' uses dynamic stack allocation [enabled by default]:  => 5185:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_log_throttle' uses dynamic stack allocation [enabled by default]:  => 5605:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_swevent_hrtimer' uses dynamic stack allocation [enabled by default]:  => 6334:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_tp_event' uses dynamic stack allocation [enabled by default]:  => 6203:1
  + /home/kisskb/slave/src/kernel/events/ring_buffer.c: warning: 'perf_output_begin' uses dynamic stack allocation [enabled by default]:  => 203:1
  + /home/kisskb/slave/src/lib/lz4/lz4defs.h: warning: "A32" redefined [enabled by default]:  => 46:0
  + /home/kisskb/slave/src/mm/hugetlb_cgroup.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 267:1
  + /home/kisskb/slave/src/mm/memcontrol.c: warning: 'mem_cgroup_move_account' defined but not used [-Wunused-function]:  => 2941:12
  + /home/kisskb/slave/src/mm/memory_hotplug.c: warning: 'generic_online_page' used but never defined [enabled by default]:  => 47:13
  + /home/kisskb/slave/src/mm/memory_hotplug.c: warning: 'online_page_callback' defined but not used [-Wunused-variable]:  => 49:31
  + /home/kisskb/slave/src/mm/memory_hotplug.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1848:7, 1841:11
  + /home/kisskb/slave/src/net/ipv4/raw.c: warning: passing argument 3 of 'raw_send_hdrinc' discards qualifiers from pointer target type:  => 629
  + /home/kisskb/slave/src/net/ipv6/raw.c: warning: passing argument 2 of 'rawv6_send_hdrinc' discards qualifiers from pointer target type:  => 890
  + /home/kisskb/slave/src/net/mac80211/tdls.c: warning: 'subband_start' may be used uninitialized in this function [-Wuninitialized]:  => 84:43
  + /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1052 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /home/kisskb/slave/src/sound/core/pcm_lib.c: warning: 'curr_tstamp.tv_nsec' may be used uninitialized in this function:  => 244
  + /home/kisskb/slave/src/sound/core/pcm_lib.c: warning: 'curr_tstamp.tv_sec' may be used uninitialized in this function:  => 244
  + <stdin>: warning: #warning syscall execveat not implemented [-Wcpp]:  => 1250:2
  + <stdin>: warning: #warning syscall execveat not implemented:  => 1250:2
  + warning: (ARCH_VIRT && ARCH_AXXIA && ARCH_KEYSTONE && ARCH_ROCKCHIP && ARCH_BCM_MOBILE && ARCH_BCM_63XX && ARCH_BRCMSTB && ARCH_HIP04 && SOC_LS1021A && SOC_OMAP5 && SOC_DRA7XX && ARCH_MSM8974 && SOC_EXYNOS5440 && MACH_SUN7I && ARCH_TEGRA_114_SOC && ARCH_TEGRA_124_SOC) selects HAVE_ARM_ARCH_TIMER which has unmet direct dependencies (CPU_V7):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (SHARPSL_PM && PMAC_APM_EMU) selects APM_EMULATION which has unmet direct dependencies (PM && SYS_SUPPORTS_APM_EMULATION):  => N/A
  + warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
  + warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG which has unmet direct dependencies (USB_SUPPORT && USB && PM):  => N/A
  + warning: drivers/built-in.o(.data+0x10a4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa78): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb18): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc84): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd9c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdfc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe5c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xecc): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x19747b): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/built-in.o(.text+0x2373fe): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/built-in.o(.text+0x2f7ba0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x57b1c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/iommu/built-in.o(.text+0x51c2): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/iommu/built-in.o(.text+0xa83b): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/net/built-in.o(.text+0x45eb8): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x178): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x218): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x384): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x49c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x4fc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x55c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x5cc): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x7a4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.data+0x11e4): Section mismatch in reference from the variable sercons to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x11ec): Section mismatch in reference from the variable sercons to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x121c): Section mismatch in reference from the variable sercons0 to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x1224): Section mismatch in reference from the variable sercons0 to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x1254): Section mismatch in reference from the variable sercons1 to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x125c): Section mismatch in reference from the variable sercons1 to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x128c): Section mismatch in reference from the variable sercons2 to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x1294): Section mismatch in reference from the variable sercons2 to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x12c4): Section mismatch in reference from the variable sercons3 to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x12cc): Section mismatch in reference from the variable sercons3 to the function .init.text:console_setup():  => N/A
  + warning: vmlinux.o(.data+0x41698): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x41738): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x418a4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x419bc): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41a1c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41a7c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41aec): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41cc4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.text+0x1f6eb0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.text+0x42): Section mismatch in reference from the (unknown reference) (unknown) to the variable .init.text:_inram:  => N/A
  + warning: vmlinux.o(.text+0x48): Section mismatch in reference from the variable _inflash0 to the variable .init.text:_inflash:  => N/A
  + warning: vmlinux.o(.text+0x5e7cb3): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: vmlinux.o(.text+0x74f552): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: vmlinux.o(.text+0x8daf3): Section mismatch in reference from the function intel_scu_devices_create() to the function .init.text:i2c_register_board_info():  => N/A
  + warning: vmlinux.o(.text+0x9c4538): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A

118 improvements:
  - /home/kisskb/slave/src/Documentation/networking/timestamping/txtimestamp.c: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 3 has type ‘int64_t’ [-Wformat=]: 93:3 => 
  - /home/kisskb/slave/src/arch/arm/include/asm/atomic.h: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]: 194:1 => 
  - /home/kisskb/slave/src/arch/arm/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]: 346:17 => 
  - /home/kisskb/slave/src/arch/arm/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]: 343:10 => 
  - /home/kisskb/slave/src/arch/cris/arch-v32/kernel/debugport.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 122:2 => 
  - /home/kisskb/slave/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2176 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 570:1 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 2178:6 => 
  - /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]: 590:18, 587:17 => 
  - /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]: 587:17, 590:18 => 
  - /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]: 587:17 => 
  - /home/kisskb/slave/src/drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function [-Wuninitialized]: 204:3 => 
  - /home/kisskb/slave/src/drivers/char/xillybus/xillybus_core.c: warning: 'idt_handle.chandesc' may be used uninitialized in this function [-Wuninitialized]: 2023:5 => 
  - /home/kisskb/slave/src/drivers/char/xillybus/xillybus_core.c: warning: 'idt_handle.entries' may be used uninitialized in this function [-Wuninitialized]: 2023:5 => 
  - /home/kisskb/slave/src/drivers/edac/ppc4xx_edac.c: warning: initialization from incompatible pointer type [enabled by default]: 924:28 => 
  - /home/kisskb/slave/src/drivers/gpio/gpio-grgpio.c: warning: 'lirq' may be used uninitialized in this function [-Wuninitialized]: 326:27 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/armada/armada_drv.c: warning: 'fb' may be used uninitialized in this function [-Wuninitialized]: 69:30 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/armada/armada_drv.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 99:6 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]: 466:4 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: control reaches end of non-void function [-Wreturn-type]: 1812:1 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_edid.c: warning: 'clock2' may be used uninitialized in this function [-Wuninitialized]: 2575:3 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]: 2808:2 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_edid_load.c: warning: 'fwdata' may be used uninitialized in this function [-Wuninitialized]: 205:2 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_lock.c: warning: passing argument 1 of '__cmpxchg' discards 'volatile' qualifier from pointer target type [enabled by default]: 311:3, 196:3, 272:3, 239:3, 358:5 => 
  - /home/kisskb/slave/src/drivers/i2c/busses/i2c-gpio.c: warning: 'scl_pin' may be used uninitialized in this function [-Wuninitialized]: 172:18 => 
  - /home/kisskb/slave/src/drivers/i2c/busses/i2c-gpio.c: warning: 'sda_pin' may be used uninitialized in this function [-Wuninitialized]: 150:6 => 
  - /home/kisskb/slave/src/drivers/iio/light/lm3533-als.c: warning: 'enable' may be used uninitialized in this function [-Wuninitialized]: 424:2 => 
  - /home/kisskb/slave/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1203:14, 1198:14, 1171:33, 1172:31 => 
  - /home/kisskb/slave/src/drivers/leds/leds-max8997.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 92:7 => 
  - /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'high_plane' may be used uninitialized in this function [-Wuninitialized]: 371:31, 359:13 => 
  - /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'low_plane' may be used uninitialized in this function [-Wuninitialized]: 359:30 => 
  - /home/kisskb/slave/src/drivers/media/tuners/max2165.c: warning: 'fraction' may be used uninitialized in this function [-Wuninitialized]: 206:11 => 
  - /home/kisskb/slave/src/drivers/media/tuners/max2165.c: warning: 'quotient' may be used uninitialized in this function [-Wuninitialized]: 208:19 => 
  - /home/kisskb/slave/src/drivers/misc/pch_phub.c: warning: 'pch_phub_restore_reg_conf' defined but not used [-Wunused-function]: 223:13 => 
  - /home/kisskb/slave/src/drivers/misc/pch_phub.c: warning: 'pch_phub_save_reg_conf' defined but not used [-Wunused-function]: 162:13 => 
  - /home/kisskb/slave/src/drivers/mmc/host/omap_hsmmc.c: warning: 'rx_req' may be used uninitialized in this function [-Wuninitialized]: 2184:10 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1456 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1835:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 417:1, 972:1 => 972:1
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1448 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 417:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1712 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 972:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1788 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 972:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2172 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 651:1 => 
  - /home/kisskb/slave/src/drivers/mtd/maps/bfin-async-flash.c: warning: unused variable 'ret' [-Wunused-variable]: 129:6 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'igb_resume' defined but not used [-Wunused-function]: 7402:12 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'wake' may be used uninitialized in this function [-Wuninitialized]: 7500:19 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/neterion/vxge/vxge-main.c: warning: 'adaptive_coalesce_tx_interrupts' defined but not used [-Wunused-function]: 2121:13 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: warning: 'stmmac_pltfr_resume' defined but not used [-Wunused-function]: 387:12 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: warning: 'stmmac_pltfr_suspend' defined but not used [-Wunused-function]: 373:12 => 
  - /home/kisskb/slave/src/drivers/of/platform.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]: 85:16 => 
  - /home/kisskb/slave/src/drivers/pci/pci-driver.c: warning: 'pci_restore_standard_config' defined but not used [-Wunused-function]: 477:12 => 
  - /home/kisskb/slave/src/drivers/regulator/s2mps11.c: warning: 'ramp_shift' may be used uninitialized in this function [-Wuninitialized]: 227:56 => 
  - /home/kisskb/slave/src/drivers/scsi/NCR5380.h: warning: 'NCR5380_write_info' declared 'static' but never defined [-Wunused-function]: 329:27 => 
  - /home/kisskb/slave/src/drivers/scsi/osst.h: warning: 'packed' attribute ignored for field of type 'u32' [-Wattributes]  CC [M]  drivers/staging/comedi/drivers/mpc624.o: 96:2 => 
  - /home/kisskb/slave/src/drivers/staging/android/binder.c: warning: 'buffer' may be used uninitialized in this function [-Wuninitialized]: 710:24 => 
  - /home/kisskb/slave/src/drivers/staging/android/binder.c: warning: 'buffer_size' may be used uninitialized in this function [-Wuninitialized]: 710:37 => 
  - /home/kisskb/slave/src/drivers/staging/android/sync_debug.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 100:3 => 
  - /home/kisskb/slave/src/drivers/staging/bcm/CmHost.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1546:3, 1564:3, 1503:3 => 
  - /home/kisskb/slave/src/drivers/staging/dgnc/dgnc_tty.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 477:2 => 
  - /home/kisskb/slave/src/drivers/staging/vt6655/device_main.c: warning: the frame size of 1280 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2993:1 => 
  - /home/kisskb/slave/src/drivers/staging/vt6655/device_main.c: warning: the frame size of 1296 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2993:1 => 
  - /home/kisskb/slave/src/drivers/staging/vt6655/device_main.c: warning: the frame size of 1304 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 2993:1 => 
  - /home/kisskb/slave/src/drivers/tty/serial/crisv10.c: warning: 'ser_interrupt' defined but not used [-Wunused-function]  CC      drivers/staging/iio/meter/ade7854-spi.o: 2506:1 => 
  - /home/kisskb/slave/src/drivers/usb/core/hcd-pci.c: warning: 'ehci_wait_for_companions' defined but not used [-Wunused-function]: 149:13 => 
  - /home/kisskb/slave/src/fs/autofs4/waitq.c: warning: 'wq' may be used uninitialized in this function [-Wuninitialized]: 461:3 => 
  - /home/kisskb/slave/src/fs/f2fs/checkpoint.c: warning: control reaches end of non-void function [-Wreturn-type]: 105:1 => 
  - /home/kisskb/slave/src/fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]: 134:23 => 
  - /home/kisskb/slave/src/fs/overlayfs/readdir.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 314:2 => 
  - /home/kisskb/slave/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]: 39:7 => 
  - /home/kisskb/slave/src/include/linux/file.h: warning: 'output.flags' may be used uninitialized in this function [-Wuninitialized]: 38:2 => 
  - /home/kisskb/slave/src/include/linux/percpu-refcount.h: warning: 'percpu_count' may be used uninitialized in this function [-Wuninitialized]: 188:1, 249:1, 222:1, 164:1 => 
  - /home/kisskb/slave/src/include/linux/scatterlist.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]  CC [M]  drivers/usb/misc/usblcd.o: 115:2 => 
  - /home/kisskb/slave/src/include/linux/time.h: warning: 'busy_until.tv_sec' may be used uninitialized in this function [-Wuninitialized]: 28:2 => 
  - /home/kisskb/slave/src/ipc/sem.c: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]: 1734:11 => 
  - /home/kisskb/slave/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function: 1693 => 
  - /home/kisskb/slave/src/kernel/sched/fair.c: warning: 'update_cfs_rq_blocked_load' declared inline after being called: 287 => 
  - /home/kisskb/slave/src/kernel/sched/fair.c: warning: previous declaration of 'update_cfs_rq_blocked_load' was here: 287 => 
  - /home/kisskb/slave/src/kernel/user_namespace.c: warning: 'first' may be used uninitialized in this function [-Wuninitialized]: 188:6, 211:6, 165:6 => 
  - /home/kisskb/slave/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]: 676:14 => 
  - /home/kisskb/slave/src/mm/memory.c: warning: 'ptep' may be used uninitialized in this function [-Wuninitialized]: 3508:9 => 
  - /home/kisskb/slave/src/mm/page_isolation.c: warning: 'order' may be used uninitialized in this function [-Wuninitialized]: 126:15 => 
  - /home/kisskb/slave/src/mm/percpu.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 1040:3 => 
  - /home/kisskb/slave/src/mm/slab.c: warning: passing argument 2 of '__cache_free' discards qualifiers from pointer target type: 3566 => 
  - /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 200:1 => 
  - /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 200:1 => 
  - /home/kisskb/slave/src/scripts/kconfig/menu.c: warning: 'jump' may be used uninitialized in this function [-Wmaybe-uninitialized]: 590:18 => 
  - /home/kisskb/slave/src/scripts/kconfig/menu.c: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]: 590:18 => 
  - /home/kisskb/slave/src/security/integrity/iint.c: warning: 'iint' may be used uninitialized in this function [-Wuninitialized]: 35:31 => 
  - /home/kisskb/slave/src/sound/soc/intel/sst-atom-controls.c: warning: 'sst_fill_and_send_cmd' defined but not used [-Wunused-function]: 70:12 => 
  - /home/kisskb/slave/src/sound/soc/intel/sst-mfld-platform-pcm.c: warning: 'sst_media_dai_ops' defined but not used [-Wunused-variable]: 454:31 => 
  - warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP || PM_RUNTIME): N/A => 
  - warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME): N/A => 
  - warning: drivers/built-in.o(.data+0x107c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xa70): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xb10): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xc74): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xd84): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xde4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xe44): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xeac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.text+0x2e7e58): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x56e4c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x43f1c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x170): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x210): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x374): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x484): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x4e4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x544): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x5ac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x77c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41650): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x416f0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41854): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41964): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x419c4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41a24): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41a8c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41c5c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: vmlinux.o(.text+0x8a6c7): Section mismatch in reference from the function intel_scu_devices_create() to the function .init.text:i2c_register_board_info(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
