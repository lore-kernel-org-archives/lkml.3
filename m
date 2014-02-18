Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaBRJDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:03:11 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:46858 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaBRJC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:02:57 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.14-rc3
Date: Tue, 18 Feb 2014 10:02:51 +0100
Message-Id: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.14-rc3[1] compared to v3.13[2].

Summarized:
  - build errors: +21/-31
  - build warnings: +188/-74

JFYI, when comparing v3.14-rc3[1]  to v3.14-rc2[3], the summaries are:
  - build errors: +17/-6
  - build warnings: +114/-57

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.14-rc3.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7190/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7082/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7167/ (all 119 configs)


*** ERRORS ***

21 regressions:
  + /scratch/kisskb/src/arch/powerpc/include/asm/floppy.h: error: 'isa_bridge_pcidev' undeclared (first use in this function):  => 142:20
  + /scratch/kisskb/src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards:  => 1312
  + /scratch/kisskb/src/drivers/gpio/gpio-xtensa.c: Error: unknown opcode or format name 'read_impwire':  => 87
  + /scratch/kisskb/src/drivers/gpio/gpio-xtensa.c: Error: unknown opcode or format name 'rur.expstate':  => 110
  + /scratch/kisskb/src/drivers/gpio/gpio-xtensa.c: Error: unknown opcode or format name 'wrmsk_expstate':  => 124
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: #error m8xx_pcmcia: Bad configuration!:  => 127:2
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: 'PCMCIA_IO_WIN_NO' undeclared here (not in a function):  => 220:30
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: 'PCMCIA_MEM_WIN_NO' undeclared here (not in a function):  => 219:32
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: 'PCMCIA_SOCKETS_NO' undeclared here (not in a function):  => 225:34
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: 'irq_map' undeclared (first use in this function):  => 1027:10
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: 's' undeclared (first use in this function):  => 982:2
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: expected ')' before 'PCMCIA_BOARD_MSG':  => 1036:2
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: implicit declaration of function 'hardware_disable' [-Werror=implicit-function-declaration]:  => 1137:3
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: implicit declaration of function 'hardware_enable' [-Werror=implicit-function-declaration]:  => 1080:2
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: implicit declaration of function 'mk_int_int_mask' [-Werror=implicit-function-declaration]:  => 748:6
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: implicit declaration of function 'socket_get' [-Werror=implicit-function-declaration]:  => 657:2
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: error: implicit declaration of function 'voltage_set' [-Werror=implicit-function-declaration]:  => 686:2
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: error: 'ffsusb_func' undeclared (first use in this function):  => 2688:1
  + error: jump_label.c: undefined reference to `arch_jump_label_transform':  => .text+0x85e5c)
  + error: kvm_main.c: undefined reference to `__stack_chk_guard':  => .text+0x6895)
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+bc8:  => (.text+0x9c2)

31 improvements:
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'dmac_resource.end'): 87:2 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'dmac_resource.start'): 86:2 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[0].end'): 69:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[0].start'): 68:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[1].end'): 74:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[1].start'): 73:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[0].end'): 50:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[0].start'): 49:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[1].end'): 55:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[1].start'): 54:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[0].end'): 100:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[0].start'): 99:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[1].end'): 105:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[1].start'): 104:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: braced-group within expression allowed only inside a function: 30:12, 73:12, 31:10, 99:12, 68:12, 36:10, 86:11, 54:12, 74:10, 55:10, 104:12, 49:12, 69:10, 87:9, 105:10, 35:12, 50:10, 100:10 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: initializer element is not constant: 74:3, 86:2, 55:3, 105:3, 73:3, 68:3, 100:3, 104:3, 99:3, 87:2, 50:3, 69:3, 49:3, 54:3 => 
  - /scratch/kisskb/src/arch/sh/kernel/kgdb.c: error: 'SIGTRAP' undeclared (first use in this function): 310:27 => 
  - /scratch/kisskb/src/arch/sh/kernel/kgdb.c: error: dereferencing pointer to incomplete type: 243:22, 242:23 => 
  - /scratch/kisskb/src/arch/sh/kernel/kgdb.c: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]: 225:32 => 
  - /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function): 99:17 => 
  - /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]: 192:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/das6402.c: error: implicit declaration of function 'outw_p' [-Werror=implicit-function-declaration]: 164:3 => 
  - /scratch/kisskb/src/drivers/staging/speakup/speakup_dtlk.c: error: implicit declaration of function 'inw_p' [-Werror=implicit-function-declaration]: 362:2 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]: 363:1 => 
  - /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - <stdin>: error: -mcall-aixdesc must be big endian: 1:0 => 
  - error: nsc-ircc.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.printk' defined in .text.unlikely section in kernel/built-in.o: (.text+0x1ffa5f4), (.text+0x1ffa634), (.text+0x1ff8e2c), (.text+0x1ffa674), (.text+0x1ffa5b0), (.text+0x1ff8c90), (.text+0x1ff99d8), (.text+0x1ffa6b4), (.text+0x1ffa6f8) => 
  - error: nsc-ircc.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff997c) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+b8c: (.text+0x986) => 


*** WARNINGS ***

188 regressions:
  + /scratch/kisskb/src/arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]:  => 63:2
  + /scratch/kisskb/src/arch/cris/include/arch-v10/arch/system.h: warning: "nop" redefined [enabled by default]:  => 39:0
  + /scratch/kisskb/src/arch/x86/include/asm/io.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 67:1
  + /scratch/kisskb/src/arch/x86/kvm/pmu.c: warning: 'config' may be used uninitialized in this function [-Wuninitialized]:  => 245:19
  + /scratch/kisskb/src/arch/x86/kvm/x86.c: warning: 'exchanged' may be used uninitialized in this function [-Wuninitialized]:  => 4394:2
  + /scratch/kisskb/src/drivers/base/memory.c: warning: 'section_nr' may be used uninitialized in this function [-Wuninitialized]:  => 607:25
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2181:9, 1799:6
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]:  => 511:17
  + /scratch/kisskb/src/drivers/gpio/gpio-sch311x.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]:  => 286:18
  + /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio' [-Wunused-variable]:  => 204:12
  + /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio':  => 204
  + /scratch/kisskb/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 697:1
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/radeon_ttm.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 938:22
  + /scratch/kisskb/src/drivers/md/bcache/bset.c: warning: format '%li' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat]:  => 27:10
  + /scratch/kisskb/src/drivers/media/media-entity.c: warning: 'media_entity_pipeline_start' uses dynamic stack allocation [enabled by default]:  => 322:1
  + /scratch/kisskb/src/drivers/mfd/max14577.c: warning: 'max14577_resume' defined but not used [-Wunused-function]:  => 199:12
  + /scratch/kisskb/src/drivers/mfd/max14577.c: warning: 'max14577_suspend' defined but not used [-Wunused-function]:  => 176:12
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'sec_pmic_resume' defined but not used [-Wunused-function]:  => 340:12
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'sec_pmic_suspend' defined but not used [-Wunused-function]:  => 318:12
  + /scratch/kisskb/src/drivers/misc/bh1770glc.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 236:29
  + /scratch/kisskb/src/drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in this function [-Wuninitialized]: 384:2 => 384:2, 384:16
  + /scratch/kisskb/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 164:17, 181:17
  + /scratch/kisskb/src/drivers/net/ethernet/cadence/macb.c: warning: 'macb_resume' defined but not used [-Wunused-function]:  => 2030:12
  + /scratch/kisskb/src/drivers/net/ethernet/cadence/macb.c: warning: 'macb_suspend' defined but not used [-Wunused-function]:  => 2013:12
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 303:11, 307:11
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 467:46
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ef10.c: warning: 'efx_ef10_free_vis' uses dynamic stack allocation [enabled by default]:  => 295:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: '_efx_mcdi_rpc_finish' uses dynamic stack allocation [enabled by default]:  => 617:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_complete_async' uses dynamic stack allocation [enabled by default]:  => 468:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_read_assertion' uses dynamic stack allocation [enabled by default]:  => 1425:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ptp.c: warning: 'efx_ptp_disable' uses dynamic stack allocation [enabled by default]:  => 614:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ptp.c: warning: 'efx_ptp_enable' uses dynamic stack allocation [enabled by default]:  => 591:1
  + /scratch/kisskb/src/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: warning: 'stmmac_pltfr_resume' defined but not used [-Wunused-function]:  => 295:12
  + /scratch/kisskb/src/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: warning: 'stmmac_pltfr_suspend' defined but not used [-Wunused-function]:  => 281:12
  + /scratch/kisskb/src/drivers/net/tun.c: warning: 'copylen' may be used uninitialized in this function [-Wuninitialized]:  => 1085:21
  + /scratch/kisskb/src/drivers/net/tun.c: warning: 'linear' may be used uninitialized in this function [-Wuninitialized]:  => 1085:6
  + /scratch/kisskb/src/drivers/net/usb/sr9800.c: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'size_t' [-Wformat]:  => 826:2
  + /scratch/kisskb/src/drivers/net/virtio_net.c: warning: 'v' may be used uninitialized in this function [-Wuninitialized]:  => 1372:4
  + /scratch/kisskb/src/drivers/net/wireless/wl3501_cs.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]: 805:23 => 334:24, 804:23
  + /scratch/kisskb/src/drivers/net/wireless/wl3501_cs.c: warning: 'implemented' may be used uninitialized in this function [-Wuninitialized]/opt/cross/gcc-4.6-nolibc/sh4-linux/bin/sh4-linux-ld: :  => 1763:5
  + /scratch/kisskb/src/drivers/net/wireless/wl3501_cs.c: warning: 'next' may be used uninitialized in this function [-Wuninitialized]: 343:24 => 343:24, 338:8
  + /scratch/kisskb/src/drivers/net/wireless/wl3501_cs.c: warning: 'restricted' may be used uninitialized in this function [-Wuninitialized]/opt/cross/gcc-4.6-nolibc/sh4-linux/bin/sh4-linux-ld: failed to merge target specific data of file net/netrom/nr_loopback.o:  => 1771:23
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: warning: 'pending_events' defined but not used [-Wunused-variable]:  => 408:12
  + /scratch/kisskb/src/drivers/pcmcia/m8xx_pcmcia.c: warning: 'socket' defined but not used [-Wunused-variable]:  => 225:27
  + /scratch/kisskb/src/drivers/platform/goldfish/goldfish_pipe.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 334:3
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'en_term' may be used uninitialized in this function [-Wuninitialized]:  => 624:27
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'force_20pct' may be used uninitialized in this function [-Wuninitialized]:  => 617:27
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]:  => 693:12
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]:  => 724:13
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'level_lower' may be used uninitialized in this function [-Wuninitialized]:  => 325:6
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'level_upper' may be used uninitialized in this function [-Wuninitialized]:  => 324:22
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'vbat_lower' may be used uninitialized in this function [-Wuninitialized]:  => 325:37
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'vbat_upper' may be used uninitialized in this function [-Wuninitialized]:  => 324:59
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 213:17, 184:21, 200:21, 160:21, 144:20, 172:12, 115:16
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 137:19
  + /scratch/kisskb/src/drivers/regulator/tps80031-regulator.c: warning: 'smps_mult' may be used uninitialized in this function [-Wuninitialized]:  => 653:33
  + /scratch/kisskb/src/drivers/regulator/tps80031-regulator.c: warning: 'smps_offset' may be used uninitialized in this function [-Wuninitialized]:  => 652:34
  + /scratch/kisskb/src/drivers/regulator/wm8350-regulator.c: warning: 'setting' may be used uninitialized in this function [-Wuninitialized]:  => 133:19
  + /scratch/kisskb/src/drivers/rtc/rtc-cmos.c: warning: 'cmos_resume' defined but not used [-Wunused-function]:  => 891:12
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'driver_support' is used uninitialized in this function [-Wuninitialized]:  => 4375:17
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]:  => 1246:3
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 1246:3
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 961:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 961:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 658:1
  + /scratch/kisskb/src/drivers/staging/goldfish/goldfish_nand.c: warning: 'rv' may be used uninitialized in this function [-Wuninitialized]:  => 94:2
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1614:6
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 1614:6
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: right shift count >= width of type [enabled by default]:  => 1614:6
  + /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 773:18
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 269:6
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'data_len' may be used uninitialized in this function [-Wuninitialized]:  => 665:17
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'kernel_ffsusb_func' defined but not used [-Wunused-variable]:  => 2688:1
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 2688:1
  + /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 624:11, 568:10
  + /scratch/kisskb/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 809:11
  + /scratch/kisskb/src/drivers/video/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /scratch/kisskb/src/drivers/w1/slaves/w1_therm.c: warning: 'verdict' may be used uninitialized in this function [-Wuninitialized]:  => 255:2
  + /scratch/kisskb/src/fs/autofs4/inode.c: warning: 'pgrp' may be used uninitialized in this function:  => 213
  + /scratch/kisskb/src/fs/btrfs/hash.c: warning: 'btrfs_crc32c' uses dynamic stack allocation [enabled by default]:  => 50:1
  + /scratch/kisskb/src/fs/ceph/acl.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 80:7
  + /scratch/kisskb/src/fs/f2fs/segment.c: warning: '__next_free_blkoff' uses dynamic stack allocation [enabled by default]:  => 683:1
  + /scratch/kisskb/src/fs/f2fs/segment.c: warning: 'add_discard_addrs' uses dynamic stack allocation [enabled by default]:  => 318:1
  + /scratch/kisskb/src/fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]:  => 625:1
  + /scratch/kisskb/src/fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]:  => 134:23
  + /scratch/kisskb/src/fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function [-Wuninitialized]: 214:32 => 139:2, 139:32
  + /scratch/kisskb/src/fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function [-Wuninitialized]: 214:17 => 139:2, 139:17
  + /scratch/kisskb/src/fs/posix_acl.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 34:1
  + /scratch/kisskb/src/fs/xfs/./xfs_trace.h: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 6 has type 'xfs_fsblock_t' [-Wformat]:  => 674:1
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]:  => 37:7
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.need_put' may be used uninitialized in this function [-Wuninitialized]:  => 36:2
  + /scratch/kisskb/src/include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 643:11
  + /scratch/kisskb/src/include/linux/list_nulls.h: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 35:2
  + /scratch/kisskb/src/include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 279:4, 349:2, 324:17, 278:6, 367:14, 290:22, 414:2, 332:11, 397:11 => 279:4, 349:2, 324:17, 278:6, 367:14, 290:22, 414:2, 278:3, 332:11, 397:11
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'vf' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/sunrpc/cache.h: warning: 'rv' may be used uninitialized in this function [-Wuninitialized]:  => 295:2
  + /scratch/kisskb/src/include/uapi/linux/swab.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 60:2
  + /scratch/kisskb/src/kernel/seccomp.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 455:15
  + /scratch/kisskb/src/kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 112:1
  + /scratch/kisskb/src/kernel/trace/ftrace.c: warning: 'control_ops_free' defined but not used [-Wunused-function]:  => 240:13
  + /scratch/kisskb/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 709:2
  + /scratch/kisskb/src/lib/debugobjects.c: warning: 'obj_states' defined but not used [-Wunused-variable]:  => 73:20
  + /scratch/kisskb/src/lib/debugobjects.c: warning: unused variable 'hint' [-Wunused-variable]:  => 254:9
  + /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: 'delta' may be used uninitialized in this function [-Wuninitialized]:  => 174:20
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]:  => 70:2, 73:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]:  => 45:2, 49:4, 56:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]:  => 113:2, 116:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]:  => 92:4, 99:2, 88:2
  + /scratch/kisskb/src/lib/vsprintf.c: warning: 'resource_string.isra.11' uses dynamic stack allocation [enabled by default]:  => 744:1
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 944:15
  + /scratch/kisskb/src/mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in this function [-Wuninitialized]: 5683:19, 5801:32, 5783:35 => 5823:35, 5713:19, 5710:16, 5841:32
  + /scratch/kisskb/src/mm/memory.c: warning: #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid. [-Wcpp]:  => 74:2
  + /scratch/kisskb/src/mm/percpu.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]:  => 1693:3
  + /scratch/kisskb/src/net/ceph/osdmap.c: warning: 'crush_do_rule_ary' uses dynamic stack allocation [enabled by default]:  => 1153:1
  + /scratch/kisskb/src/net/core/neighbour.c: warning: 'p_name' may be used uninitialized in this function [-Wuninitialized]:  => 3094:10
  + /scratch/kisskb/src/net/core/skbuff.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1340:6
  + /scratch/kisskb/src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 209:2
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function [-Wuninitialized]:  => 183:16
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]:  => 656:16
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]: 450:63, 533:37 => 457:63, 552:42, 540:37
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'icmph' may be used uninitialized in this function [-Wuninitialized]: 487:48, 487:35, 494:29 => 494:2, 501:29, 494:48, 494:35
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]: 490:2, 664:21, 451:29, 506:3, 545:42 => 497:2, 671:21, 458:29, 513:3, 552:42, 671:2
  + /scratch/kisskb/src/net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function [-Wuninitialized]:  => 927:3
  + /scratch/kisskb/src/net/ipv4/udp.c: warning: 'sk' may be used uninitialized in this function [-Wuninitialized]:  => 1904:8
  + /scratch/kisskb/src/net/nfc/llcp_core.c: warning: 'sn_len' may be used uninitialized in this function [-Wuninitialized]:  => 801:12
  + /scratch/kisskb/src/net/openvswitch/datapath.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 401:6
  + /scratch/kisskb/src/net/rds/rdma.c: warning: 'iov_size' may be used uninitialized in this function [-Wuninitialized]:  => 697:15
  + /scratch/kisskb/src/net/sched/sch_sfb.c: warning: 'salt' may be used uninitialized in this function [-Wuninitialized]:  => 313:12
  + /scratch/kisskb/src/net/sunrpc/svcauth_unix.c: warning: 'gid' may be used uninitialized in this function [-Wuninitialized]:  => 517:19
  + /scratch/kisskb/src/net/sunrpc/svcauth_unix.c: warning: 'id' may be used uninitialized in this function [-Wuninitialized]:  => 495:17
  + /scratch/kisskb/src/net/sunrpc/svcsock.c: warning: 'optname' may be used uninitialized in this function [-Wuninitialized]  CC      drivers/net/ppp/ppp_deflate.o:  => 725:6
  + /scratch/kisskb/src/scripts/kconfig/menu.c: warning: 'jump' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 587:18
  + /scratch/kisskb/src/sound/core/oss/pcm_oss.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 2161:6
  + /scratch/kisskb/src/sound/drivers/mpu401/mpu401_uart.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 312:6, 290:6
  + /scratch/kisskb/src/sound/isa/cmi8330.c: warning: 'card' may be used uninitialized in this function [-Wuninitialized]:  => 642:2
  + /scratch/kisskb/src/sound/isa/opti9xx/opti92x-ad1848.c: warning: 'card' may be used uninitialized in this function [-Wuninitialized]:  => 1026:17
  + /scratch/kisskb/src/sound/isa/sb/sb16.c: warning: 'card' may be used uninitialized in this function [-Wuninitialized]:  => 515:17
  + /scratch/kisskb/src/sound/soc/codecs/arizona.c: warning: 'bclk' may be used uninitialized in this function [-Wuninitialized]:  => 1206:15
  + /scratch/kisskb/src/sound/soc/codecs/arizona.c: warning: 'ratio' may be used uninitialized in this function [-Wuninitialized]:  => 1455:34
  + /scratch/kisskb/src/sound/soc/codecs/da7210.c: warning: 'pll_div1' may be used uninitialized in this function [-Wuninitialized]:  => 1023:15
  + /scratch/kisskb/src/sound/soc/codecs/da7210.c: warning: 'pll_div2' may be used uninitialized in this function [-Wuninitialized]:  => 1024:15
  + /scratch/kisskb/src/sound/soc/codecs/da7210.c: warning: 'pll_div3' may be used uninitialized in this function [-Wuninitialized]:  => 1025:21
  + /scratch/kisskb/src/sound/soc/codecs/da9055.c: warning: 'pll_frac_bot' may be used uninitialized in this function [-Wuninitialized]:  => 1317:15
  + /scratch/kisskb/src/sound/soc/codecs/da9055.c: warning: 'pll_frac_top' may be used uninitialized in this function [-Wuninitialized]:  => 1316:15
  + /scratch/kisskb/src/sound/soc/codecs/da9055.c: warning: 'pll_integer' may be used uninitialized in this function [-Wuninitialized]:  => 1318:15
  + /scratch/kisskb/src/sound/soc/codecs/wm2200.c: warning: 'fratio' may be used uninitialized in this function [-Wuninitialized]:  => 1925:32
  + /scratch/kisskb/src/sound/soc/codecs/wm5100.c: warning: 'fratio' may be used uninitialized in this function [-Wuninitialized]:  => 1735:32
  + /scratch/kisskb/src/sound/soc/codecs/wm8350.c: warning: 'fll_div.div' may be used uninitialized in this function [-Wuninitialized]:  => 1060:28
  + /scratch/kisskb/src/sound/soc/codecs/wm8350.c: warning: 'fll_div.k' may be used uninitialized in this function [-Wuninitialized]:  => 1064:15
  + /scratch/kisskb/src/sound/soc/codecs/wm8350.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 1063:13
  + /scratch/kisskb/src/sound/soc/codecs/wm8350.c: warning: 'fll_div.ratio' may be used uninitialized in this function [-Wuninitialized]:  => 1069:54
  + /scratch/kisskb/src/sound/soc/codecs/wm8962.c: warning: 'fratio' may be used uninitialized in this function [-Wuninitialized]:  => 2794:32
  + /scratch/kisskb/src/sound/soc/codecs/wm8996.c: warning: 'fratio' may be used uninitialized in this function [-Wuninitialized]:  => 1986:32
  + /scratch/kisskb/src/sound/soc/codecs/wm_hubs.c: warning: 'reg_l' may be used uninitialized in this function [-Wuninitialized]:  => 325:11
  + /scratch/kisskb/src/sound/soc/codecs/wm_hubs.c: warning: 'reg_r' may be used uninitialized in this function [-Wuninitialized]:  => 324:11
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: right shift count >= width of type [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3385:6
  + <stdin>: warning: #warning syscall sched_getattr not implemented [-Wcpp]:  => 1229:2
  + <stdin>: warning: #warning syscall sched_getattr not implemented:  => 1229:2
  + <stdin>: warning: #warning syscall sched_setattr not implemented [-Wcpp]:  => 1226:2
  + <stdin>: warning: #warning syscall sched_setattr not implemented:  => 1226:2
  + warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet direct dependencies (!CPU_LITTLE_ENDIAN):  => N/A
  + warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME):  => N/A
  + warning: drivers/built-in.o(.data+0x9e8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa88): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xbe4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xcec): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xd4c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdac): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe0c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xfb4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x2b4674): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d8c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x3f0ac): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x3ff88): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x40028): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40184): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x4028c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x402ec): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4034c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x403ac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x40554): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

74 improvements:
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence: 89 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence: 208 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 373, 376 => 376
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence: 349, 347 => 
  - /scratch/kisskb/src/arch/x86/kvm/../../../virt/kvm/vfio.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 104:22 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-mcp23s08.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 643:10 => 
  - /scratch/kisskb/src/drivers/gpu/drm/gma500/backlight.c: warning: 'do_gma_backlight_set' defined but not used [-Wunused-function]: 29:13 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i915/i915_debugfs.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 2393:2 => 
  - /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 79:25 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]: 121:41, 197:47 => 120:41
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]: 121:17, 197:23 => 120:17
  - /scratch/kisskb/src/drivers/leds/leds-pwm.c: warning: unused variable 'node' [-Wunused-variable]: 88:22 => 
  - /scratch/kisskb/src/drivers/md/bcache/alloc.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]: 416:18 => 
  - /scratch/kisskb/src/drivers/mfd/max8998.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 178:10 => 
  - /scratch/kisskb/src/drivers/mfd/tps65217.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 173:13 => 
  - /scratch/kisskb/src/drivers/mtd/devices/docg3.c: warning: unused variable 'base' [-Wunused-variable]: 2122:16 => 
  - /scratch/kisskb/src/drivers/net/ethernet/hp/hp100.c: warning: 'cleanup_dev' defined but not used [-Wunused-function]: 2825:13 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/tx.c: warning: label 'finish_packet' defined but not used [-Wunused-label]: 432:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/smsc/smc91x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 1898:7 => 
  - /scratch/kisskb/src/drivers/regulator/ab3100.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 649:4 => 
  - /scratch/kisskb/src/drivers/regulator/tps62360-regulator.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 363:13 => 
  - /scratch/kisskb/src/drivers/rtc/rtc-s5m.c: warning: 's5m_rtc_resume' defined but not used [-Wunused-function]: 642:12 => 
  - /scratch/kisskb/src/drivers/rtc/rtc-s5m.c: warning: 's5m_rtc_suspend' defined but not used [-Wunused-function]: 653:12 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_chip_reset' defined but not used [-Wunused-function]: 8341:1 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_configure_bugs' defined but not used [-Wunused-function]: 8895:1 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_load_seeprom' defined but not used [-Wunused-function]: 8496:1 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]: 8517:5, 7901:5 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]: 7898:5, 8510:5 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: unused variable 'sxfrctl1' [-Wunused-variable]: 8983:17 => 
  - /scratch/kisskb/src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_resume' defined but not used [-Wunused-function]: 35:12 => 
  - /scratch/kisskb/src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_suspend' defined but not used [-Wunused-function]: 19:12 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 975:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 112:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1068 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c: warning: 'msgsz' may be used uninitialized in this function [-Wuninitialized]: 632:54 => 
  - /scratch/kisskb/src/drivers/staging/lustre/lustre/llite/file.c: warning: 'count' may be used uninitialized in this function [-Wuninitialized]: 987:9, 1046:9 => 
  - /scratch/kisskb/src/drivers/staging/rtl8192e/rtllib_softmac.c: warning: value computed is not used [-Wunused-value]: 924:3 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: warning: 'ehv_bc_console_init' defined but not used [-Wunused-function]: 335:19 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: warning: data definition has no type or storage class [enabled by default]: 363:1 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: warning: parameter names (without types) in function declaration [enabled by default]: 363:1 => 
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_resume' defined but not used [-Wunused-function]: 413:12 => 
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_suspend' defined but not used [-Wunused-function]: 404:12 => 
  - /scratch/kisskb/src/drivers/tty/serial/sh-sci.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 560:23 => 
  - /scratch/kisskb/src/fs/sysfs/file.c: warning: unused variable 'kobj' [-Wunused-variable]: 610:18 => 
  - /scratch/kisskb/src/include/linux/posix_acl.h: warning: control reaches end of non-void function [-Wreturn-type]: 108:1 => 
  - /scratch/kisskb/src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]: 2559:8 => 
  - /scratch/kisskb/src/lib/vsprintf.c: warning: 'resource_string.isra.10' uses dynamic stack allocation [enabled by default]: 744:1 => 
  - /scratch/kisskb/src/net/netfilter/ipvs/ip_vs_sync.c: warning: unused variable 'ret' [-Wunused-variable]: 1640:8 => 
  - modpost: WARNING: modpost: Found 4 section mismatch(es).: N/A => 
  - warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)): N/A => 
  - warning: drivers/built-in.o(.data+0xa08): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xaa8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xc04): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xd0c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xd6c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xdcc): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xe2c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xfd4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x1d78): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x3ebdc): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/usb/gadget/g_audio.o(.text.unlikely+0x114): Section mismatch in reference from the function audio_bind_config() to the function .init.text:afunc_bind(): N/A => 
  - warning: vmlinux.o(.data+0x404c8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40568): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x406c4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x407cc): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4082c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4088c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x408ec): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40a94): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
