Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaLVIcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 03:32:07 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:49143 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaLVIcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 03:32:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.19-rc1
Date: Mon, 22 Dec 2014 09:31:58 +0100
Message-Id: <1419237118-9712-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.19-rc1[1] compared to v3.18[2].

Summarized:
  - build errors: +24/-16
  - build warnings: +171/-118

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.19-rc1.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/8241/ (262 out of 262 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/8168/ (262 out of 262 configs)


*** ERRORS ***

24 regressions:
  + /home/kisskb/slave/src/arch/powerpc/xmon/xmon.c: error: unused variable 'badaddr' [-Werror=unused-variable]:  => 1185:13
  + /home/kisskb/slave/src/arch/powerpc/xmon/xmon.c: error: unused variable 'mode' [-Werror=unused-variable]:  => 1183:6
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
  + error: "csum_partial_copy_nocheck" [net/ipv6/ipv6.ko] undefined!:  => N/A
  + error: No rule to make target include/config/auto.conf:  => N/A
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o:  => (.text+0x1ff9c8c), (.text+0x1ff9468), (.text+0x1ff9ac4), (.text+0x1ff94ec), (.text+0x1ff9a4c), (.text+0x1ff9d08)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.bitrev32' defined in .text section in lib/built-in.o:  => (.text+0x1ff94a4)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8c30)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8148)
  + error: skge.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8c38)

16 improvements:
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.capacity’): 152:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.seg_max’): 151:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.host_features’): 149:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtnet_dev_page.host_features’): 119:3 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: braced-group within expression allowed only inside a function: 116:10, 113:10, 146:10, 93:10, 96:10 => 
  - /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: initializer element is not constant: 119:3, 152:3, 149:3, 151:3 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfd' undeclared (first use in this function): 1874:29 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfs' undeclared (first use in this function): 1872:29 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfd' undeclared (first use in this function): 1928:30 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfs' undeclared (first use in this function): 1926:30 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit declaration of function 'do_fp_load' [-Werror=implicit-function-declaration]: 1872:4 => 
  - /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit declaration of function 'do_fp_store' [-Werror=implicit-function-declaration]: 1926:4 => 
  - /home/kisskb/slave/src/arch/powerpc/xmon/xmon.c: error: implicit declaration of function 'dump_tlb_44x' [-Werror=implicit-function-declaration]: 912:4 => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o: (.text+0x1ff8714), (.text+0x1ff8794), (.text+0x1ff880c), (.text+0x1ff858c), (.text+0x1ff887c), (.text+0x1ff8a24) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8b0c) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8580), (.text+0x1ff886c), (.text+0x1ff8b14) => 


*** WARNINGS ***

171 regressions:
  + .config: warning: symbol value '' invalid for PHYS_OFFSET:  => 17
  + /home/kisskb/slave/src/arch/cris/arch-v32/kernel/time.c: warning: 'bite_in_progress' defined but not used [-Wunused-variable]:  => 111:12
  + /home/kisskb/slave/src/arch/cris/arch-v32/mach-fs/pinmux.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 49:1
  + /home/kisskb/slave/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2144 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 573:1
  + /home/kisskb/slave/src/arch/s390/kernel/perf_cpum_sf.c: warning: 'perf_push_sample' uses dynamic stack allocation [enabled by default]:  => 1042:1
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: warning: passing argument 2 of 'iowrite16' makes integer from pointer without a cast [enabled by default]:  => 123:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: warning: passing argument 2 of 'iowrite16' makes integer from pointer without a cast [enabled by default]:  => 116:2
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 347, 349
  + /home/kisskb/slave/src/arch/sh/math-emu/math.c: warning: statement with no effect [-Wunused-value]  CC      kernel/sysctl.o:  => 324:1
  + /home/kisskb/slave/src/arch/x86/kvm/emulate.c: warning: left shift count >= width of type [enabled by default]:  => 3552:4
  + /home/kisskb/slave/src/drivers/android/binder.c: warning: 'buffer' may be used uninitialized in this function [-Wuninitialized]:  => 714:24
  + /home/kisskb/slave/src/drivers/android/binder.c: warning: 'buffer_size' may be used uninitialized in this function [-Wuninitialized]:  => 714:37
  + /home/kisskb/slave/src/drivers/atm/ambassador.c: warning: passing argument 1 of 'virt_to_bus' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1762:3
  + /home/kisskb/slave/src/drivers/char/ipmi/ipmi_ssif.c: warning: format '%ld' expects argument of type 'long int', but argument 5 has type '__kernel_suseconds_t' [-Wformat]:  => 970:3
  + /home/kisskb/slave/src/drivers/clocksource/timer-marco.c: warning: unused variable 'timer_div' [-Wunused-variable]:  => 260:6
  + /home/kisskb/slave/src/drivers/gpio/gpio-74xx-mmio.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 132:16
  + /home/kisskb/slave/src/drivers/gpu/drm/gma500/cdv_intel_dp.c: warning: 'i2c_dp_aux_add_bus' is deprecated (declared at /home/kisskb/slave/src/drivers/gpu/drm/gma500/cdv_intel_dp.c:224) [-Wdeprecated-declarations]:  => 869:2
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_h' may be used uninitialized in this function [-Wuninitialized]:  => 1232:26
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_w' may be used uninitialized in this function [-Wuninitialized]:  => 1232:13
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_x' may be used uninitialized in this function [-Wuninitialized]:  => 1235:25
  + /home/kisskb/slave/src/drivers/gpu/drm/i915/intel_sprite.c: warning: 'src_y' may be used uninitialized in this function [-Wuninitialized]:  => 1249:19
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/i2c/gm204.c: warning: 'stat' may be used uninitialized in this function [-Wuninitialized]:  => 155:31
  + /home/kisskb/slave/src/drivers/input/keyboard/tca8418_keypad.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]:  => 172:9
  + /home/kisskb/slave/src/drivers/mailbox/pcc.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 210:3, 175:3
  + /home/kisskb/slave/src/drivers/media/pci/cx88/cx88-video.c: warning: 'restart_video_queue' defined but not used [-Wunused-function]:  => 415:12
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1835:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1384 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 417:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 417:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1700 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 972:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1792 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 972:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2156 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + /home/kisskb/slave/src/drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 52:2
  + /home/kisskb/slave/src/drivers/net/ethernet/amd/xgbe/xgbe-main.c: warning: 'xgbe_resume' defined but not used [-Wunused-function]:  => 474:12
  + /home/kisskb/slave/src/drivers/net/ethernet/amd/xgbe/xgbe-main.c: warning: 'xgbe_suspend' defined but not used [-Wunused-function]:  => 455:12
  + /home/kisskb/slave/src/drivers/net/ethernet/mellanox/mlx4/alloc.c: warning: 'uid' may be used uninitialized in this function [-Wuninitialized]:  => 416:9
  + /home/kisskb/slave/src/drivers/net/ethernet/rocker/rocker.c: warning: 'rocker_port_vlan_flood_group' uses dynamic stack allocation [enabled by default]:  => 2694:1
  + /home/kisskb/slave/src/drivers/net/ethernet/rocker/rocker.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 809:9
  + /home/kisskb/slave/src/drivers/net/fddi/defxx.c: warning: 'bar_len[0]' may be used uninitialized in this function [-Wuninitialized]:  => 583:10, 3726:3
  + /home/kisskb/slave/src/drivers/net/fddi/defxx.c: warning: 'bar_start[0]' may be used uninitialized in this function [-Wuninitialized]:  => 3726:3, 583:10
  + /home/kisskb/slave/src/drivers/net/wan/lmc/lmc_main.c: warning: passing argument 1 of 'virt_to_bus' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1885:9, 1898:9, 1887:5, 1876:9, 1900:5, 1901:5
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC [M]  drivers/staging/iio/adc/mxs-lradc.o:  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC [M]  drivers/media/rc/keymaps/rc-imon-pad.o:  => 381:2
  + /home/kisskb/slave/src/drivers/net/wireless/iwlwifi/mvm/d3.c: warning: 'fw_status' may be used uninitialized in this function [-Wuninitialized]:  => 1536:37
  + /home/kisskb/slave/src/drivers/net/wireless/p54/lmac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[3]' [-Wattributes]  CC [M]  drivers/net/wireless/ti/wl18xx/cmd.o:  => 377:2
  + /home/kisskb/slave/src/drivers/pwm/pwm-atmel-hlcdc.c: warning: 'clk_period_ns' may be used uninitialized in this function [-Wuninitialized]:  => 72:55
  + /home/kisskb/slave/src/drivers/scsi/am53c974.c: warning: 'resid' may be used uninitialized in this function [-Wuninitialized]:  => 183:3, 205:6
  + /home/kisskb/slave/src/drivers/spi/spi-atmel.c: warning: 'atmel_spi_resume' defined but not used [-Wunused-function]:  => 1484:12
  + /home/kisskb/slave/src/drivers/spi/spi-atmel.c: warning: 'atmel_spi_suspend' defined but not used [-Wunused-function]:  => 1466:12
  + /home/kisskb/slave/src/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c: warning: 'max' may be used uninitialized in this function [-Wuninitialized]:  => 99:6
  + /home/kisskb/slave/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]  CC [M]  net/ipv4/netfilter/iptable_filter.o:  => 365:3
  + /home/kisskb/slave/src/drivers/tty/serial/8250/8250_core.c: warning: 'flags' may be used uninitialized in this function:  => 3186:16
  + /home/kisskb/slave/src/drivers/tty/serial/mcf.c: warning: unused variable 'pp' [-Wunused-variable]:  => 444:19, 201:19
  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: warning: 'bfin_fifo_offset' defined but not used [-Wunused-function]:  => 36:12
  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: warning: 'binf_writel' defined but not used [-Wunused-function]:  => 66:13
  + /home/kisskb/slave/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 569:10, 599:32, 443:16, 625:11
  + /home/kisskb/slave/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 785:32, 811:11, 564:16
  + /home/kisskb/slave/src/fs/afs/internal.h: warning: 'packed' attribute ignored for field of type 'enum <anonymous>' [-Wattributes]  CC      net/ieee802154/reassembly.o:  => 164:2
  + /home/kisskb/slave/src/fs/btrfs/raid56.c: warning: 'finish_parity_scrub' uses dynamic stack allocation [enabled by default]:  => 2501:1
  + /home/kisskb/slave/src/fs/buffer.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat=]:  => 243:4
  + /home/kisskb/slave/src/fs/ceph/addr.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 10 has type 'size_t' [-Wformat]:  => 1419:2
  + /home/kisskb/slave/src/fs/ceph/locks.c: warning: 'lock_type' may be used uninitialized in this function [-Wuninitialized]:  => 140:40
  + /home/kisskb/slave/src/fs/ext4/extents.c: warning: 'lblock' may be used uninitialized in this function [-Wuninitialized]:  => 2344:58
  + /home/kisskb/slave/src/fs/ext4/extents.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 2344:58
  + /home/kisskb/slave/src/fs/nfsd/nfs4xdr.c: warning: 'end' may be used uninitialized in this function [-Wuninitialized]:  => 1792:11, 1792:42
  + /home/kisskb/slave/src/fs/nfsd/nfs4xdr.c: warning: 'str' may be used uninitialized in this function [-Wuninitialized]:  => 1787:9
  + /home/kisskb/slave/src/include/asm-generic/atomic-long.h: warning: 'counter' may be used uninitialized in this function [-Wuninitialized]:  => 148:2
  + /home/kisskb/slave/src/include/linux/kernel.h: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 710:17
  + /home/kisskb/slave/src/include/linux/mtd/cfi.h: warning: #warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work. [-Wcpp]:  => 76:2
  + /home/kisskb/slave/src/include/linux/page_counter.h: warning: 'counter' may be used uninitialized in this function [-Wuninitialized]:  => 48:21
  + /home/kisskb/slave/src/include/linux/unaligned/le_byteshift.h: warning: array subscript is above array bounds [-Warray-bounds]:  => 25:7
  + /home/kisskb/slave/src/include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + /home/kisskb/slave/src/include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
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
  + /home/kisskb/slave/src/lib/assoc_array.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat=]:  => 799:2, 899:3
  + /home/kisskb/slave/src/lib/lz4/lz4defs.h: warning: "A32" redefined [enabled by default]:  => 46:0
  + /home/kisskb/slave/src/lib/lz4/lz4hc_compress.c: warning: the frame size of 1104 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 535:1
  + /home/kisskb/slave/src/mm/compaction.c: warning: 'suitable_migration_target' defined but not used [-Wunused-function]:  => 311:13
  + /home/kisskb/slave/src/mm/dmapool.c: warning: format '%Zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat=]:  => 99:6
  + /home/kisskb/slave/src/mm/dmapool.c: warning: format '%Zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat=]:  => 99:6
  + /home/kisskb/slave/src/mm/memcontrol.c: warning: 'mem_cgroup_move_account' defined but not used [-Wunused-function]:  => 2941:12
  + /home/kisskb/slave/src/mm/nommu.c: warning: format '%zx' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat=]:  => 1648:2
  + /home/kisskb/slave/src/mm/percpu-km.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat=]:  => 107:10
  + /home/kisskb/slave/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat=]:  => 1040:3
  + /home/kisskb/slave/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat=]:  => 1446:9, 1040:3
  + /home/kisskb/slave/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat=]:  => 895:3, 1446:9
  + /home/kisskb/slave/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat=]:  => 1446:9, 895:3
  + /home/kisskb/slave/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat=]:  => 1446:9
  + /home/kisskb/slave/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat=]:  => 1446:9
  + /home/kisskb/slave/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'unsigned int' [-Wformat=]:  => 1446:9
  + /home/kisskb/slave/src/mm/slab_common.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat=]:  => 583:6
  + /home/kisskb/slave/src/net/core/flow.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat=]:  => 401:4
  + /home/kisskb/slave/src/net/ipv4/raw.c: warning: passing argument 3 of 'raw_send_hdrinc' discards qualifiers from pointer target type:  => 629
  + /home/kisskb/slave/src/net/ipv6/raw.c: warning: passing argument 2 of 'rawv6_send_hdrinc' discards qualifiers from pointer target type:  => 890
  + /home/kisskb/slave/src/net/mac80211/tdls.c: warning: 'subband_start' may be used uninitialized in this function [-Wuninitialized]:  => 84:43
  + /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1052 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /home/kisskb/slave/src/net/sunrpc/svc.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat=]:  => 1239:4
  + /home/kisskb/slave/src/security/keys/keyctl.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat=]:  => 1037:2
  + /home/kisskb/slave/src/security/keys/keyring.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat=]:  => 485:2
  + /home/kisskb/slave/src/security/keys/keyring.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat=]:  => 458:2
  + /home/kisskb/slave/src/security/keys/keyring.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat=]:  => 430:2
  + /home/kisskb/slave/src/security/keys/keyring.c: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat=]:  => 430:2
  + /home/kisskb/slave/src/security/keys/request_key.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat=]:  => 212:2
  + /home/kisskb/slave/src/security/keys/request_key.c: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat=]:  => 526:2
  + /home/kisskb/slave/src/security/keys/request_key_auth.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat=]:  => 77:3
  + /home/kisskb/slave/src/sound/core/pcm_lib.c: warning: 'curr_tstamp.tv_nsec' may be used uninitialized in this function:  => 244
  + /home/kisskb/slave/src/sound/core/pcm_lib.c: warning: 'curr_tstamp.tv_sec' may be used uninitialized in this function:  => 244
  + /home/kisskb/slave/src/sound/soc/codecs/cs35l32.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 314:2
  + <stdin>: warning: #warning syscall execveat not implemented [-Wcpp]:  => 1250:2
  + <stdin>: warning: #warning syscall execveat not implemented:  => 1250:2
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
  + warning: drivers/built-in.o(.text+0x19747b): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/built-in.o(.text+0x2373fe): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: drivers/built-in.o(.text+0x2f7a78): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x57b24): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
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
  + warning: vmlinux.o(.text+0x1f6f88): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.text+0x42): Section mismatch in reference from the (unknown reference) (unknown) to the variable .init.text:_inram:  => N/A
  + warning: vmlinux.o(.text+0x48): Section mismatch in reference from the variable _inflash0 to the variable .init.text:_inflash:  => N/A
  + warning: vmlinux.o(.text+0x5e7c83): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: vmlinux.o(.text+0x74f552): Section mismatch in reference from the function dmar_walk_remapping_entries() to the function .init.text:dmar_table_print_dmar_entry():  => N/A
  + warning: vmlinux.o(.text+0x8daf3): Section mismatch in reference from the function intel_scu_devices_create() to the function .init.text:i2c_register_board_info():  => N/A
  + warning: vmlinux.o(.text+0x9c401c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A

118 improvements:
  - /home/kisskb/slave/src/Documentation/networking/timestamping/txtimestamp.c: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 3 has type ‘int64_t’ [-Wformat=]: 93:3 => 
  - /home/kisskb/slave/src/arch/arm/include/asm/atomic.h: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]: 194:1 => 
  - /home/kisskb/slave/src/arch/arm/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]: 346:17 => 
  - /home/kisskb/slave/src/arch/arm/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]: 343:10 => 
  - /home/kisskb/slave/src/arch/cris/arch-v32/kernel/debugport.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 122:2 => 
  - /home/kisskb/slave/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2176 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 570:1 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 2178:6 => 
  - /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]: 590:18, 587:17 => 
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
  - /home/kisskb/slave/src/drivers/gpu/drm/drm_lock.c: warning: passing argument 1 of '__cmpxchg' discards 'volatile' qualifier from pointer target type [enabled by default]: 311:3, 196:3, 239:3, 358:5, 272:3 => 
  - /home/kisskb/slave/src/drivers/i2c/busses/i2c-gpio.c: warning: 'scl_pin' may be used uninitialized in this function [-Wuninitialized]: 172:18 => 
  - /home/kisskb/slave/src/drivers/i2c/busses/i2c-gpio.c: warning: 'sda_pin' may be used uninitialized in this function [-Wuninitialized]: 150:6 => 
  - /home/kisskb/slave/src/drivers/iio/light/lm3533-als.c: warning: 'enable' may be used uninitialized in this function [-Wuninitialized]: 424:2 => 
  - /home/kisskb/slave/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1198:14, 1203:14, 1172:31, 1171:33 => 
  - /home/kisskb/slave/src/drivers/leds/leds-max8997.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 92:7 => 
  - /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'high_plane' may be used uninitialized in this function [-Wuninitialized]: 371:31, 359:13 => 
  - /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'low_plane' may be used uninitialized in this function [-Wuninitialized]: 359:30 => 
  - /home/kisskb/slave/src/drivers/media/tuners/max2165.c: warning: 'fraction' may be used uninitialized in this function [-Wuninitialized]: 206:11 => 
  - /home/kisskb/slave/src/drivers/media/tuners/max2165.c: warning: 'quotient' may be used uninitialized in this function [-Wuninitialized]: 208:19 => 
  - /home/kisskb/slave/src/drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]: 363:3 => 
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
  - /home/kisskb/slave/src/drivers/staging/bcm/CmHost.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1546:3, 1503:3, 1564:3 => 
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
  - /home/kisskb/slave/src/include/linux/percpu-refcount.h: warning: 'percpu_count' may be used uninitialized in this function [-Wuninitialized]: 164:1, 188:1, 222:1, 249:1 => 
  - /home/kisskb/slave/src/include/linux/scatterlist.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]  CC [M]  drivers/usb/misc/usblcd.o: 115:2 => 
  - /home/kisskb/slave/src/include/linux/time.h: warning: 'busy_until.tv_sec' may be used uninitialized in this function [-Wuninitialized]: 28:2 => 
  - /home/kisskb/slave/src/ipc/sem.c: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]: 1734:11 => 
  - /home/kisskb/slave/src/kernel/user_namespace.c: warning: 'first' may be used uninitialized in this function [-Wuninitialized]: 211:6, 165:6, 188:6 => 
  - /home/kisskb/slave/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]: 676:14 => 
  - /home/kisskb/slave/src/mm/memory.c: warning: 'ptep' may be used uninitialized in this function [-Wuninitialized]: 3508:9 => 
  - /home/kisskb/slave/src/mm/page_isolation.c: warning: 'order' may be used uninitialized in this function [-Wuninitialized]: 126:15 => 
  - /home/kisskb/slave/src/mm/percpu.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 1040:3 => 
  - /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 200:1 => 
  - /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 200:1 => 
  - /home/kisskb/slave/src/scripts/kconfig/menu.c: warning: 'jump' may be used uninitialized in this function [-Wmaybe-uninitialized]: 590:18 => 
  - /home/kisskb/slave/src/scripts/kconfig/menu.c: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]: 590:18 => 
  - /home/kisskb/slave/src/security/integrity/iint.c: warning: 'iint' may be used uninitialized in this function [-Wuninitialized]: 35:31 => 
  - /home/kisskb/slave/src/sound/soc/intel/sst-atom-controls.c: warning: 'sst_fill_and_send_cmd' defined but not used [-Wunused-function]: 70:12 => 
  - /home/kisskb/slave/src/sound/soc/intel/sst-mfld-platform-pcm.c: warning: 'sst_media_dai_ops' defined but not used [-Wunused-variable]: 454:31 => 
  - warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP || PM_RUNTIME): N/A => 
  - warning: (PPC_CELL_NATIVE && AKEBONO && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
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
