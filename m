Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaBKReC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:34:02 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:49143 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaBKRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:33:58 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.14-rc2
Date: Tue, 11 Feb 2014 18:33:55 +0100
Message-Id: <1392140035-31263-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.14-rc2[1] compared to v3.13[2].

Summarized:
  - build errors: +10/-31
  - build warnings: +126/-71

JFYI, when comparing v3.14-rc2[1]  to v3.14-rc1[3], the summaries are:
  - build errors: +3/-2
  - build warnings: +57/-53

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.14-rc2.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7167/ (119 out of 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7082/ (119 out of 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7145/ (119 out of 119 configs)


*** ERRORS ***

10 regressions:
  + /scratch/kisskb/src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards:  => 1312
  + /scratch/kisskb/src/drivers/gpio/gpio-xtensa.c: error: implicit declaration of function 'RSR_CPENABLE' [-Werror=implicit-function-declaration]:  => 48:2
  + /scratch/kisskb/src/drivers/gpio/gpio-xtensa.c: error: implicit declaration of function 'WSR_CPENABLE' [-Werror=implicit-function-declaration]:  => 49:2
  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: error: implicit declaration of function 'dma_alloc_writecombine' [-Werror=implicit-function-declaration]:  => 91:2
  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: error: implicit declaration of function 'dma_free_writecombine' [-Werror=implicit-function-declaration]:  => 176:3
  + /scratch/kisskb/src/drivers/staging/android/ion/ion_dummy_driver.c: error: implicit declaration of function 'virt_to_phys' [-Werror=implicit-function-declaration]:  => 81:7
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: error: 'ffsusb_func' undeclared (first use in this function):  => 2688:1
  + error: "irq_to_desc" [drivers/gpio/gpio-mcp23s08.ko] undefined!:  => N/A
  + error: jump_label.c: undefined reference to `arch_jump_label_transform':  => .text+0x85dbc)
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

126 regressions:
  + /scratch/kisskb/src/arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]:  => 63:2
  + /scratch/kisskb/src/arch/cris/include/arch-v10/arch/system.h: warning: "nop" redefined [enabled by default]:  => 39:0
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]:  => 514:18, 511:17
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]:  => 514:18, 511:17
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]:  => 511:17
  + /scratch/kisskb/src/drivers/gpio/gpio-sch311x.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]:  => 286:18
  + /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio':  => 204
  + /scratch/kisskb/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 697:1
  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 91:17
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 77:6
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 117:5
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 118:15
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 118:3
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/cik.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1917:11
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/cik.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1886:5
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 795:11
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 786:6
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'me_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 762:5
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 750:5
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 769:10
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 773:5
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/radeon_ttm.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 938:22
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/rv770_smc.c: warning: 'int_vect' may be used uninitialized in this function [-Wuninitialized]:  => 480:5
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/rv770_smc.c: warning: 'ucode_size' may be used uninitialized in this function [-Wuninitialized]:  => 589:31
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/si.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1673:10
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/si.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1666:5
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/si.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1651:10
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/si.c: warning: 'smc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1682:12
  + /scratch/kisskb/src/drivers/gpu/drm/shmobile/shmob_drm_drv.c: warning: "CONFIG_PM_SLEEP" is not defined [-Wundef]:  => 300:5
  + /scratch/kisskb/src/drivers/md/bcache/btree.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1816:9
  + /scratch/kisskb/src/drivers/md/bcache/extents.c: warning: format '%li' expects argument of type 'long int', but argument 4 has type 'size_t' [-Wformat]:  => 196:2
  + /scratch/kisskb/src/drivers/media/media-entity.c: warning: 'media_entity_pipeline_start' uses dynamic stack allocation [enabled by default]  CC      drivers/media/usb/dvb-usb/af9005.o:  => 322:1
  + /scratch/kisskb/src/drivers/media/media-entity.c: warning: 'media_entity_pipeline_start' uses dynamic stack allocation [enabled by default]:  => 322:1
  + /scratch/kisskb/src/drivers/mfd/max14577.c: warning: 'max14577_resume' defined but not used [-Wunused-function]:  => 199:12
  + /scratch/kisskb/src/drivers/mfd/max14577.c: warning: 'max14577_suspend' defined but not used [-Wunused-function]:  => 176:12
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'sec_pmic_resume' defined but not used [-Wunused-function]:  => 340:12
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'sec_pmic_suspend' defined but not used [-Wunused-function]:  => 318:12
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 1257:10, 474:31, 1111:10, 827:10
  + /scratch/kisskb/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 164:17, 181:17
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/cnic.c: warning: the frame size of 1316 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 4834:1
  + /scratch/kisskb/src/drivers/net/ethernet/cadence/macb.c: warning: 'macb_resume' defined but not used [-Wunused-function]:  => 2030:12
  + /scratch/kisskb/src/drivers/net/ethernet/cadence/macb.c: warning: 'macb_suspend' defined but not used [-Wunused-function]:  => 2013:12
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ef10.c: warning: 'efx_ef10_free_vis' uses dynamic stack allocation [enabled by default]:  => 295:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: '_efx_mcdi_rpc_finish' uses dynamic stack allocation [enabled by default]:  => 617:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_complete_async' uses dynamic stack allocation [enabled by default]:  => 468:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_read_assertion' uses dynamic stack allocation [enabled by default]:  => 1425:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ptp.c: warning: 'efx_ptp_disable' uses dynamic stack allocation [enabled by default]:  => 614:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ptp.c: warning: 'efx_ptp_enable' uses dynamic stack allocation [enabled by default]:  => 591:1
  + /scratch/kisskb/src/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: warning: 'stmmac_pltfr_resume' defined but not used [-Wunused-function]:  => 295:12
  + /scratch/kisskb/src/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: warning: 'stmmac_pltfr_suspend' defined but not used [-Wunused-function]:  => 281:12
  + /scratch/kisskb/src/drivers/scsi/aacraid/nark.c: warning: passing argument 1 of '__iounmap' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 48:3
  + /scratch/kisskb/src/drivers/scsi/aic7xxx/aic79xx_osm.c: warning: passing argument 1 of '__iounmap' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1363:4
  + /scratch/kisskb/src/drivers/scsi/aic7xxx/aic7xxx_osm.c: warning: passing argument 1 of '__iounmap' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 1262:4
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'driver_support' is used uninitialized in this function [-Wuninitialized]:  => 4375:17
  + /scratch/kisskb/src/drivers/scsi/mpt3sas/mpt3sas_base.c: warning: passing argument 1 of '__iounmap' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 4421:3, 1875:3
  + /scratch/kisskb/src/drivers/scsi/scsi_debug.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 2002:2, 305:11
  + /scratch/kisskb/src/drivers/scsi/scsi_debug.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 305:2, 2002:2
  + /scratch/kisskb/src/drivers/scsi/scsi_debug.c: warning: right shift count >= width of type [enabled by default]:  => 305:2, 2002:2
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]:  => 1246:3
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 1246:3
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 961:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 173:1 => 164:1, 103:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 658:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 658:1
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 583:1
  + /scratch/kisskb/src/drivers/staging/dgrp/dgrp_net_ops.c: warning: 'buf' may be used uninitialized in this function [-Wuninitialized]:  => 2395:21
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1618:6
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 1618:6
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: right shift count >= width of type [enabled by default]:  => 1618:6
  + /scratch/kisskb/src/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: warning: passing argument 1 of 'is_vmalloc_addr' makes pointer from integer without a cast [enabled by default]:  => 532:2
  + /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 773:18
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'data_len' may be used uninitialized in this function [-Wuninitialized]:  => 665:17
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'kernel_ffsusb_func' defined but not used [-Wunused-variable]:  => 2688:1
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 2688:1
  + /scratch/kisskb/src/drivers/usb/serial/ti_usb_3410_5052.c: warning: 'lsr' may be used uninitialized in this function [-Wuninitialized]:  => 641:20
  + /scratch/kisskb/src/drivers/video/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + /scratch/kisskb/src/drivers/video/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /scratch/kisskb/src/drivers/video/riva/fbdev.c: warning: passing argument 1 of '__iounmap' discards 'volatile' qualifier from pointer target type [enabled by default]:  => 2127:3, 2088:3
  + /scratch/kisskb/src/drivers/video/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1185:23
  + /scratch/kisskb/src/drivers/video/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 734:23
  + /scratch/kisskb/src/fs/autofs4/inode.c: warning: 'pgrp' may be used uninitialized in this function:  => 213
  + /scratch/kisskb/src/fs/btrfs/hash.c: warning: 'btrfs_crc32c' uses dynamic stack allocation [enabled by default]:  => 50:1
  + /scratch/kisskb/src/fs/ceph/acl.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 80:7
  + /scratch/kisskb/src/fs/f2fs/segment.c: warning: '__next_free_blkoff' uses dynamic stack allocation [enabled by default]:  => 683:1
  + /scratch/kisskb/src/fs/f2fs/segment.c: warning: 'add_discard_addrs' uses dynamic stack allocation [enabled by default]:  => 318:1
  + /scratch/kisskb/src/fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]:  => 134:23
  + /scratch/kisskb/src/fs/ocfs2/stack_o2cb.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 161:19
  + /scratch/kisskb/src/fs/posix_acl.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 34:1
  + /scratch/kisskb/src/include/asm-generic/bitops/non-atomic.h: warning: array subscript is above array bounds [-Warray-bounds]:  => 105:20
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'vf' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/kernel/trace/ftrace.c: warning: 'control_ops_free' defined but not used [-Wunused-function]:  => 240:13
  + /scratch/kisskb/src/lib/vsprintf.c: warning: 'resource_string.isra.11' uses dynamic stack allocation [enabled by default]:  => 744:1
  + /scratch/kisskb/src/mm/percpu.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]:  => 1693:3
  + /scratch/kisskb/src/net/ceph/osdmap.c: warning: 'crush_do_rule_ary' uses dynamic stack allocation [enabled by default]:  => 1153:1
  + /scratch/kisskb/src/net/core/neighbour.c: warning: 'p_name' may be used uninitialized in this function [-Wuninitialized]:  => 3094:10
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'family' may be used uninitialized in this function [-Wuninitialized]  CC      fs/nfs/nfs3xdr.o:  => 457:2
  + /scratch/kisskb/src/scripts/kconfig/menu.c: warning: 'jump' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 587:18
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: right shift count >= width of type [enabled by default]:  => 972:3
  + <stdin>: warning: #warning syscall sched_getattr not implemented [-Wcpp]:  => 1229:2
  + <stdin>: warning: #warning syscall sched_getattr not implemented:  => 1229:2
  + <stdin>: warning: #warning syscall sched_setattr not implemented [-Wcpp]:  => 1226:2
  + <stdin>: warning: #warning syscall sched_setattr not implemented:  => 1226:2
  + warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER):  => N/A
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
  + warning: drivers/built-in.o(.text+0x2b42a4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d8c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x3ef90): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x3ff88): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x40028): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40184): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x4028c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x402ec): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4034c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x403ac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x40554): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

71 improvements:
  - /scratch/kisskb/src/arch/x86/kvm/../../../virt/kvm/vfio.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 104:22 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-mcp23s08.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 643:10 => 
  - /scratch/kisskb/src/drivers/gpu/drm/gma500/backlight.c: warning: 'do_gma_backlight_set' defined but not used [-Wunused-function]: 29:13 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i915/i915_debugfs.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 2393:2 => 
  - /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 79:25 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]: 121:41, 197:47 => 120:41
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]: 121:17, 197:23 => 120:17
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'shift' may be used uninitialized in this function [-Wuninitialized]: 198:22, 121:57 => 120:57
  - /scratch/kisskb/src/drivers/leds/leds-pwm.c: warning: unused variable 'node' [-Wunused-variable]: 88:22 => 
  - /scratch/kisskb/src/drivers/md/bcache/alloc.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]: 416:18 => 
  - /scratch/kisskb/src/drivers/mfd/max8998.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 178:10 => 
  - /scratch/kisskb/src/drivers/mfd/tps65217.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 173:13 => 
  - /scratch/kisskb/src/drivers/mtd/devices/docg3.c: warning: unused variable 'base' [-Wunused-variable]: 2122:16 => 
  - /scratch/kisskb/src/drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - /scratch/kisskb/src/drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20 => 
  - /scratch/kisskb/src/drivers/net/ethernet/hp/hp100.c: warning: 'cleanup_dev' defined but not used [-Wunused-function]: 2825:13 => 
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
  - /scratch/kisskb/src/drivers/tty/serial/sh-sci.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 560:23 => 
  - /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]: 58:13 => 
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
