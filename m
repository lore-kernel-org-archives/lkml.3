Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbbAZU3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:29:14 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:43109 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZU3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:29:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.19-rc6
Date: Mon, 26 Jan 2015 21:29:00 +0100
Message-Id: <1422304140-24420-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.19-rc6[1] compared to v3.18[2].

Summarized:
  - build errors: +17/-19
  - build warnings: +174/-120

JFYI, when comparing v3.19-rc6[1] to v3.19-rc5[3], the summaries are:
  - build errors: +9/-9
  - build warnings: +60/-99

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.19-rc6.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/8360/ (255 out of 262 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/8168/ (all 262 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/8329/ (255 out of 262 configs)


*** ERRORS ***

17 regressions:
  + /home/kisskb/slave/src/arch/powerpc/kvm/book3s_pr.c: error: 'last_sc' may be used uninitialized in this function [-Werror=uninitialized]:  => 1094:31
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: error: too few arguments to function 'ioread16':  => 44:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: error: too few arguments to function 'iowrite16':  => 123:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: error: too few arguments to function 'ioread16':  => 43:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: error: too few arguments to function 'iowrite16':  => 116:2
  + /home/kisskb/slave/src/include/linux/irq.h: error: conflicting types for 'ioread16':  => 856:19
  + /home/kisskb/slave/src/include/linux/irq.h: error: conflicting types for 'iowrite16':  => 847:20
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: 'PAGES_PER_SECTION' undeclared (first use in this function):  => 1178:18, 1836:46
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: 'PAGE_SECTION_MASK' undeclared (first use in this function):  => 1177:20
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit declaration of function '__nr_to_section' [-Werror=implicit-function-declaration]:  => 1841:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit declaration of function 'find_memory_block_hinted' [-Werror=implicit-function-declaration]:  => 1848:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit declaration of function 'pfn_to_section_nr' [-Werror=implicit-function-declaration]:  => 1837:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit declaration of function 'present_section_nr' [-Werror=implicit-function-declaration]:  => 1838:3
  + error: "csum_partial_copy_nocheck" [net/ipv6/ipv6.ko] undefined!:  => N/A
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.eeh_check_failure' defined in .text section in arch/powerpc/kernel/built-in.o:  => (.text+0x1ffa644), (.text+0x1ffa900), (.text+0x1ffac74), (.text+0x1ff9f34), (.text+0x1ff9db4), (.text+0x1ffafe4), (.text+0x1ffb0ec)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_24' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9bf4)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa508), (.text+0x1ffa124)

19 improvements:
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.capacity’): 152:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.seg_max’): 151:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.host_features’): 149:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtnet_dev_page.host_features’): 119:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: braced-group within expression allowed only inside a function: 93:10, 96:10, 146:10, 113:10, 116:10 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: initializer element is not constant: 119:3, 152:3, 151:3, 149:3 => 
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
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o: (.text+0x1ff8714), (.text+0x1ff880c), (.text+0x1ff8a24), (.text+0x1ff8794), (.text+0x1ff887c), (.text+0x1ff858c) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8b0c) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff886c), (.text+0x1ff8580), (.text+0x1ff8b14) => 


*** WARNINGS ***

174 regressions:
  + /home/kisskb/slave/src/arch/cris/arch-v32/kernel/time.c: warning: 'bite_in_progress' defined but not used [-Wunused-variable]:  => 111:12
  + /home/kisskb/slave/src/arch/cris/arch-v32/mach-fs/pinmux.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 49:1
  + /home/kisskb/slave/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2144 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 573:1
  + /home/kisskb/slave/src/arch/s390/kernel/perf_cpum_sf.c: warning: 'perf_push_sample' uses dynamic stack allocation [enabled by default]:  => 1042:1
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: warning: passing argument 2 of 'iowrite16' makes integer from pointer without a cast [enabled by default]:  => 123:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: warning: passing argument 2 of 'iowrite16' makes integer from pointer without a cast [enabled by default]:  => 116:2
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 347, 349
  + /home/kisskb/slave/src/arch/x86/kvm/emulate.c: warning: left shift count >= width of type [enabled by default]:  => 3541:4
  + /home/kisskb/slave/src/drivers/android/binder.c: warning: 'buffer' may be used uninitialized in this function [-Wuninitialized]:  => 714:24
  + /home/kisskb/slave/src/drivers/android/binder.c: warning: 'buffer_size' may be used uninitialized in this function [-Wuninitialized]:  => 714:37
  + /home/kisskb/slave/src/drivers/atm/ambassador.c: warning: passing argument 1 of 'virt_to_bus' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1762:3
  + /home/kisskb/slave/src/drivers/clocksource/timer-marco.c: warning: unused variable 'timer_div' [-Wunused-variable]:  => 260:6
  + /home/kisskb/slave/src/drivers/gpio/gpio-74xx-mmio.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 132:16
  + /home/kisskb/slave/src/drivers/gpu/drm/gma500/cdv_intel_dp.c: warning: 'i2c_dp_aux_add_bus' is deprecated (declared at /home/kisskb/slave/src/drivers/gpu/drm/gma500/cdv_intel_dp.c:224) [-Wdeprecated-declarations]:  => 869:2
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_h' may be used uninitialized in this function [-Wuninitialized]:  => 1232:26
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_w' may be used uninitialized in this function [-Wuninitialized]:  => 1232:13
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_x' may be used uninitialized in this function [-Wuninitialized]:  => 1235:25
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_y' may be used uninitialized in this function [-Wuninitialized]:  => 1249:19
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 117:5
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 118:15
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 118:3
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/i2c/gm204.c: warning: 'stat' may be used uninitialized in this function [-Wuninitialized]:  => 155:31
  + /home/kisskb/slave/src/drivers/input/joystick/analog.c: warning: #warning Precise timer not defined for this architecture. [-Wcpp]  CC [M]  drivers/infiniband/hw/cxgb4/mem.o:  => 176:2
  + /home/kisskb/slave/src/drivers/mailbox/pcc.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 175:3, 210:3
  + /home/kisskb/slave/src/drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1312:3, 1018:3
  + /home/kisskb/slave/src/drivers/media/dvb-frontends/mb86a20s.h: warning: 'mb86a20s_get_tuner_i2c_adapter' defined but not used [-Wunused-function]:  => 49:2
  + /home/kisskb/slave/src/drivers/media/pci/cx88/cx88-video.c: warning: 'restart_video_queue' defined but not used [-Wunused-function]:  => 415:12
  + /home/kisskb/slave/src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6875:13
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1835:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1384 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 417:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 417:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1700 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 972:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1792 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 972:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2156 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + /home/kisskb/slave/src/drivers/net/ethernet/amd/xgbe/xgbe-main.c: warning: 'xgbe_resume' defined but not used [-Wunused-function]:  => 474:12
  + /home/kisskb/slave/src/drivers/net/ethernet/amd/xgbe/xgbe-main.c: warning: 'xgbe_suspend' defined but not used [-Wunused-function]:  => 455:12
  + /home/kisskb/slave/src/drivers/net/ethernet/mellanox/mlx4/alloc.c: warning: 'uid' may be used uninitialized in this function [-Wuninitialized]:  => 416:9
  + /home/kisskb/slave/src/drivers/net/ethernet/rocker/rocker.c: warning: 'rocker_port_vlan_flood_group' uses dynamic stack allocation [enabled by default]:  => 2694:1
  + /home/kisskb/slave/src/drivers/net/ethernet/rocker/rocker.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 809:9
  + /home/kisskb/slave/src/drivers/net/fddi/defxx.c: warning: 'bar_len[0]' may be used uninitialized in this function [-Wuninitialized]:  => 583:10, 3726:3
  + /home/kisskb/slave/src/drivers/net/fddi/defxx.c: warning: 'bar_start[0]' may be used uninitialized in this function [-Wuninitialized]:  => 583:10, 3726:3
  + /home/kisskb/slave/src/drivers/net/wan/lmc/lmc_main.c: warning: passing argument 1 of 'virt_to_bus' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1885:9, 1900:5, 1898:9, 1887:5, 1901:5, 1876:9
  + /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]  CC [M]  drivers/input/touchscreen/wm9705.o:  => 123:2
  + /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]  CC [M]  net/ceph/ceph_common.o:  => 123:2
  + /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/ath/carl9170/wlan.h:42:0,:  => 123:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC [M]  drivers/mfd/menf21bmc.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC [M]  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC [M]  drivers/net/ethernet/stmicro/stmmac/stmmac_main.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  LD      drivers/net/wireless/ath/ath10k/built-in.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]/home/kisskb/slave/src/drivers/misc/ics932s401.c: In function 'show_value':  LD      drivers/staging/android/ion/built-in.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]/home/kisskb/slave/src/net/core/ethtool.c: In function 'ethtool_get_feature_mask':In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/ppr.c:19:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/lo.c:30:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/phy_g.c:29:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  LD [M]  drivers/media/platform/vsp1/vsp1.o:  => 381:2
  + /home/kisskb/slave/src/drivers/net/wireless/iwlegacy/3945-mac.c: warning: 'phys_addr' may be used uninitialized in this function [-Wuninitialized]  LD [M]  drivers/media/usb/gspca/gspca_sq905.o:  => 620:33
  + /home/kisskb/slave/src/drivers/net/wireless/iwlwifi/mvm/d3.c: warning: 'fw_status' may be used uninitialized in this function [-Wuninitialized]:  => 1536:37
  + /home/kisskb/slave/src/drivers/pwm/pwm-atmel-hlcdc.c: warning: 'clk_period_ns' may be used uninitialized in this function [-Wuninitialized]:  => 72:55
  + /home/kisskb/slave/src/drivers/rtc/rtc-sh.c: warning: 'sh_rtc_set_irq_wake' defined but not used [-Wunused-function]  CC      drivers/pci/pcie/aer/aerdrv.o:  => 749:13
  + /home/kisskb/slave/src/drivers/scsi/am53c974.c: warning: 'resid' may be used uninitialized in this function [-Wuninitialized]:  => 183:3
  + /home/kisskb/slave/src/drivers/scsi/fdomain.c: warning: 'fdomain_pci_tbl' defined but not used [-Wunused-variable]  CC      drivers/usb/storage/karma.o:  => 1774:29
  + /home/kisskb/slave/src/drivers/scsi/initio.c: warning: 'i91u_pci_devices' defined but not used [-Wunused-variable]  CC      lib/flex_proportions.o:  => 131:29
  + /home/kisskb/slave/src/drivers/spi/spi-atmel.c: warning: 'atmel_spi_resume' defined but not used [-Wunused-function]:  => 1484:12
  + /home/kisskb/slave/src/drivers/spi/spi-atmel.c: warning: 'atmel_spi_suspend' defined but not used [-Wunused-function]:  => 1466:12
  + /home/kisskb/slave/src/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c: warning: 'max' may be used uninitialized in this function [-Wuninitialized]:  => 99:6
  + /home/kisskb/slave/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]  CC [M]  drivers/staging/comedi/drivers/das800.o:  => 365:3
  + /home/kisskb/slave/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]  CC [M]  net/sunrpc/auth_gss/gss_rpc_xdr.o:  => 365:3
  + /home/kisskb/slave/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]/home/kisskb/slave/src/drivers/tty/serial/8250/8250_core.c: In function 'autoconfig_irq':  LD [M]  drivers/hid/usbhid/usbhid.o:  => 365:3
  + /home/kisskb/slave/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/staging/vt6656/rf.c:38:0::  => 365:3
  + /home/kisskb/slave/src/drivers/tty/serial/8250/8250_core.c: warning: 'flags' may be used uninitialized in this function:  => 3186:16
  + /home/kisskb/slave/src/drivers/tty/serial/crisv10.c: warning: 'ser_interrupt' defined but not used [-Wunused-function]  CC      drivers/tty/vt/vt_ioctl.o:  => 2506:1
  + /home/kisskb/slave/src/drivers/tty/serial/mcf.c: warning: unused variable 'pp' [-Wunused-variable]:  => 444:19, 201:19
  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: warning: 'bfin_fifo_offset' defined but not used [-Wunused-function]:  => 36:12
  + /home/kisskb/slave/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 811:11
  + /home/kisskb/slave/src/fs/btrfs/raid56.c: warning: 'finish_parity_scrub' uses dynamic stack allocation [enabled by default]:  => 2501:1
  + /home/kisskb/slave/src/fs/ceph/locks.c: warning: 'lock_type' may be used uninitialized in this function [-Wuninitialized]:  => 140:40
  + /home/kisskb/slave/src/fs/ext4/extents.c: warning: 'lblock' may be used uninitialized in this function [-Wuninitialized]:  => 2344:58
  + /home/kisskb/slave/src/fs/ext4/extents.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 2344:58
  + /home/kisskb/slave/src/fs/nfsd/nfs4xdr.c: warning: 'end' may be used uninitialized in this function [-Wuninitialized]:  => 1792:42, 1792:11
  + /home/kisskb/slave/src/fs/nfsd/nfs4xdr.c: warning: 'str' may be used uninitialized in this function [-Wuninitialized]:  => 1787:9
  + /home/kisskb/slave/src/fs/ocfs2/stack_o2cb.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 161:19
  + /home/kisskb/slave/src/include/asm-generic/atomic-long.h: warning: 'counter' may be used uninitialized in this function [-Wuninitialized]:  => 148:2
  + /home/kisskb/slave/src/include/asm-generic/bitops/non-atomic.h: warning: array subscript is above array bounds [-Warray-bounds]:  => 105:20
  + /home/kisskb/slave/src/include/linux/page_counter.h: warning: 'counter' may be used uninitialized in this function [-Wuninitialized]:  => 48:21
  + /home/kisskb/slave/src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32' [-Wattributes]  LD      fs/ubifs/built-in.o:  => 30:2
  + /home/kisskb/slave/src/include/linux/unaligned/le_byteshift.h: warning: array subscript is above array bounds [-Warray-bounds]:  => 25:7
  + /home/kisskb/slave/src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16' [-Wattributes]  LD      drivers/staging/media/bcm2048/built-in.o:  => 30:2
  + /home/kisskb/slave/src/ipc/shm.c: warning: 'file' may be used uninitialized in this function [-Wuninitialized]:  => 1310:59
  + /home/kisskb/slave/src/ipc/shm.c: warning: 'file' may be used uninitialized in this function:  => 1233
  + /home/kisskb/slave/src/kernel/events/core.c: warning: '__perf_sw_event' uses dynamic stack allocation [enabled by default]:  => 5923:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_event_comm_output' uses dynamic stack allocation [enabled by default]:  => 5275:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_event_mmap_output' uses dynamic stack allocation [enabled by default]:  => 5407:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_event_read_event' uses dynamic stack allocation [enabled by default]:  => 5067:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_event_task_output' uses dynamic stack allocation [enabled by default]:  => 5182:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_log_throttle' uses dynamic stack allocation [enabled by default]:  => 5602:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_swevent_hrtimer' uses dynamic stack allocation [enabled by default]:  => 6331:1
  + /home/kisskb/slave/src/kernel/events/core.c: warning: 'perf_tp_event' uses dynamic stack allocation [enabled by default]:  => 6200:1
  + /home/kisskb/slave/src/kernel/events/ring_buffer.c: warning: 'perf_output_begin' uses dynamic stack allocation [enabled by default]:  => 203:1
  + /home/kisskb/slave/src/kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]:  => 330:12
  + /home/kisskb/slave/src/kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]:  => 266:13
  + /home/kisskb/slave/src/kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]:  => 243:13
  + /home/kisskb/slave/src/lib/lz4/lz4defs.h: warning: "A32" redefined [enabled by default]:  => 46:0
  + /home/kisskb/slave/src/mm/compaction.c: warning: 'suitable_migration_target' defined but not used [-Wunused-function]:  => 311:13
  + /home/kisskb/slave/src/mm/memcontrol.c: warning: 'mem_cgroup_move_account' defined but not used [-Wunused-function]:  => 2941:12
  + /home/kisskb/slave/src/mm/memory_hotplug.c: warning: 'generic_online_page' used but never defined [enabled by default]:  => 47:13
  + /home/kisskb/slave/src/mm/memory_hotplug.c: warning: 'online_page_callback' defined but not used [-Wunused-variable]:  => 49:31
  + /home/kisskb/slave/src/mm/memory_hotplug.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 1841:11, 1848:7
  + /home/kisskb/slave/src/net/ipv4/raw.c: warning: passing argument 3 of 'raw_send_hdrinc' discards qualifiers from pointer target type:  => 629
  + /home/kisskb/slave/src/net/ipv6/raw.c: warning: passing argument 2 of 'rawv6_send_hdrinc' discards qualifiers from pointer target type:  => 890
  + /home/kisskb/slave/src/net/mac80211/mlme.c: warning: 'pwr_level_cisco' may be used uninitialized in this function [-Wuninitialized]  CC      fs/ext4/inline.o:  => 1348:3
  + /home/kisskb/slave/src/net/mac80211/mlme.c: warning: 'pwr_level_cisco' may be used uninitialized in this function [-Wuninitialized]: 1290:3 => 1357:24, 1348:3
  + /home/kisskb/slave/src/net/mac80211/tdls.c: warning: 'subband_start' may be used uninitialized in this function [-Wuninitialized]:  => 84:43
  + /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1052 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /home/kisskb/slave/src/sound/core/pcm_lib.c: warning: 'curr_tstamp.tv_nsec' may be used uninitialized in this function:  => 244
  + /home/kisskb/slave/src/sound/core/pcm_lib.c: warning: 'curr_tstamp.tv_sec' may be used uninitialized in this function:  => 244
  + /home/kisskb/slave/src/sound/soc/codecs/arizona.c: warning: 'aif_rx_state' may be used uninitialized in this function [-Wuninitialized]/home/kisskb/slave/src/drivers/isdn/hisax/gazel.c:60:2: warning: statement with no effect [-Wunused-value]:  => 1394:21
  + <stdin>: warning: #warning syscall execveat not implemented [-Wcpp]:  => 1250:2
  + <stdin>: warning: #warning syscall execveat not implemented:  => 1250:2
  + warning: (PPC_CELLEB) selects HAS_TXX9_SERIAL which has unmet direct dependencies (TTY && HAS_IOMEM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (SND_SOC_INTEL_BYTCR_RT5640_MACH && SND_SOC_INTEL_CHT_BSW_RT5672_MACH) selects SND_SST_IPC_ACPI which has unmet direct dependencies (SOUND && !M68K && !UML && SND && SND_SOC && ACPI):  => N/A
  + warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
  + warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG which has unmet direct dependencies (USB_SUPPORT && USB && PM):  => N/A
  + warning: (VIDEO_EM28XX_V4L2) selects VIDEO_MT9V011 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT):  => N/A
  + warning: drivers/built-in.o(.data+0x10a4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa78): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb18): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc84): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd9c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdfc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe5c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xecc): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x111ddf): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/built-in.o(.text+0x151e8e): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/built-in.o(.text+0x2f78a0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x57ad4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/iommu/built-in.o(.text+0x51c2): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/iommu/built-in.o(.text+0xa83b): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/net/built-in.o(.text+0x45e94): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
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
  + warning: vmlinux.o(.data+0x416b8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x41758): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x418c4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x419dc): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41a3c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41a9c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41b0c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41ce4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.text+0x1f7278): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.text+0x42): Section mismatch in reference from the (unknown reference) (unknown) to the variable .init.text:_inram:  => N/A
  + warning: vmlinux.o(.text+0x48): Section mismatch in reference from the variable _inflash0 to the variable .init.text:_inflash:  => N/A
  + warning: vmlinux.o(.text+0x563137): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: vmlinux.o(.text+0x66ab72): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: vmlinux.o(.text+0x8dd33): Section mismatch in reference from the function intel_scu_devices_create() to the function .init.text:i2c_register_board_info():  => N/A
  + warning: vmlinux.o(.text+0x9c3f84): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A

120 improvements:
  - /home/kisskb/slave/src/Documentation/networking/timestamping/txtimestamp.c: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 3 has type ‘int64_t’ [-Wformat=]: 93:3 => 
  - /home/kisskb/slave/src/arch/arm/include/asm/atomic.h: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]: 194:1 => 
  - /home/kisskb/slave/src/arch/arm/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]: 346:17 => 
  - /home/kisskb/slave/src/arch/arm/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]: 343:10 => 
  - /home/kisskb/slave/src/arch/cris/arch-v32/kernel/debugport.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 122:2 => 
  - /home/kisskb/slave/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2176 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 570:1 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 2178:6 => 
  - /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]: 587:17, 590:18 => 
  - /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]: 590:18, 587:17 => 
  - /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]: 587:17 => 
  - /home/kisskb/slave/src/drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function [-Wuninitialized]: 204:3 => 
  - /home/kisskb/slave/src/drivers/char/xillybus/xillybus_core.c: warning: 'idt_handle.chandesc' may be used uninitialized in this function [-Wuninitialized]: 2023:5 => 
  - /home/kisskb/slave/src/drivers/char/xillybus/xillybus_core.c: warning: 'idt_handle.entries' may be used uninitialized in this function [-Wuninitialized]: 2023:5 => 
  - /home/kisskb/slave/src/drivers/edac/ppc4xx_edac.c: warning: initialization from incompatible pointer type [enabled by default]: 924:28 => 
  - /home/kisskb/slave/src/drivers/gpio/gpio-grgpio.c: warning: 'lirq' may be used uninitialized in this function [-Wuninitialized]: 326:27 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/armada/armada_drv.c: warning: 'fb' may be used uninitialized in this function [-Wuninitialized]: 69:30 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/armada/armada_drv.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 99:6 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]: 466:4 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: 'hdrlen' may be used uninitialized in this function [-Wuninitialized]: 349:23 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: control reaches end of non-void function [-Wreturn-type]: 1812:1 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_edid.c: warning: 'clock2' may be used uninitialized in this function [-Wuninitialized]: 2575:3 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]: 2808:2 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_edid_load.c: warning: 'fwdata' may be used uninitialized in this function [-Wuninitialized]: 205:2 => 
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_lock.c: warning: passing argument 1 of '__cmpxchg' discards 'volatile' qualifier from pointer target type [enabled by default]: 311:3, 239:3, 272:3, 196:3, 358:5 => 
  - /home/kisskb/slave/src/drivers/i2c/busses/i2c-gpio.c: warning: 'scl_pin' may be used uninitialized in this function [-Wuninitialized]: 172:18 => 
  - /home/kisskb/slave/src/drivers/i2c/busses/i2c-gpio.c: warning: 'sda_pin' may be used uninitialized in this function [-Wuninitialized]: 150:6 => 
  - /home/kisskb/slave/src/drivers/iio/light/lm3533-als.c: warning: 'enable' may be used uninitialized in this function [-Wuninitialized]: 424:2 => 
  - /home/kisskb/slave/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1171:33, 1203:14, 1198:14, 1172:31 => 
  - /home/kisskb/slave/src/drivers/leds/leds-max8997.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 92:7 => 
  - /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'high_plane' may be used uninitialized in this function [-Wuninitialized]: 359:13, 371:31 => 
  - /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'low_plane' may be used uninitialized in this function [-Wuninitialized]: 359:30 => 
  - /home/kisskb/slave/src/drivers/media/tuners/max2165.c: warning: 'fraction' may be used uninitialized in this function [-Wuninitialized]: 206:11 => 
  - /home/kisskb/slave/src/drivers/media/tuners/max2165.c: warning: 'quotient' may be used uninitialized in this function [-Wuninitialized]: 208:19 => 
  - /home/kisskb/slave/src/drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]: 363:3 => 
  - /home/kisskb/slave/src/drivers/misc/pch_phub.c: warning: 'pch_phub_restore_reg_conf' defined but not used [-Wunused-function]: 223:13 => 
  - /home/kisskb/slave/src/drivers/misc/pch_phub.c: warning: 'pch_phub_save_reg_conf' defined but not used [-Wunused-function]: 162:13 => 
  - /home/kisskb/slave/src/drivers/mmc/host/omap_hsmmc.c: warning: 'rx_req' may be used uninitialized in this function [-Wuninitialized]: 2184:10 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1456 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1835:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 972:1, 417:1 => 972:1
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1448 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 417:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1712 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 972:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1788 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 972:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2172 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 651:1 => 
  - /home/kisskb/slave/src/drivers/mtd/maps/bfin-async-flash.c: warning: unused variable 'ret' [-Wunused-variable]: 129:6 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'igb_resume' defined but not used [-Wunused-function]: 7402:12 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'wake' may be used uninitialized in this function [-Wuninitialized]: 7500:19 => 
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
  - /home/kisskb/slave/src/fs/btrfs/extent_io.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 2166:13 => 
  - /home/kisskb/slave/src/fs/cifs/netmisc.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 937:23, 941:22 => 
  - /home/kisskb/slave/src/fs/cifs/netmisc.c: warning: comparison of distinct pointer types lacks a cast: 937, 941 => 
  - /home/kisskb/slave/src/fs/f2fs/checkpoint.c: warning: control reaches end of non-void function [-Wreturn-type]: 105:1 => 
  - /home/kisskb/slave/src/fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]: 134:23 => 
  - /home/kisskb/slave/src/fs/overlayfs/readdir.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 314:2 => 
  - /home/kisskb/slave/src/include/asm-generic/div64.h: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 43:28 => 
  - /home/kisskb/slave/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]: 39:7 => 
  - /home/kisskb/slave/src/include/linux/file.h: warning: 'output.flags' may be used uninitialized in this function [-Wuninitialized]: 38:2 => 
  - /home/kisskb/slave/src/include/linux/percpu-refcount.h: warning: 'percpu_count' may be used uninitialized in this function [-Wuninitialized]: 249:1, 164:1, 188:1, 222:1 => 
  - /home/kisskb/slave/src/include/linux/scatterlist.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]  CC [M]  drivers/usb/misc/usblcd.o: 115:2 => 
  - /home/kisskb/slave/src/include/linux/time.h: warning: 'busy_until.tv_sec' may be used uninitialized in this function [-Wuninitialized]: 28:2 => 
  - /home/kisskb/slave/src/ipc/sem.c: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]: 1734:11 => 
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
