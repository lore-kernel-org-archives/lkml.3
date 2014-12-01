Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaLAKzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:55:40 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:56241 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaLAKzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:55:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.18-rc7
Date: Mon,  1 Dec 2014 11:55:36 +0100
Message-Id: <1417431336-2012-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.18-rc7[1] compared to v3.17[2].

Summarized:
  - build errors: +18/-18
  - build warnings: +151/-83

JFYI, when comparing v3.18-rc7[1]  to v3.18-rc6[3], the summaries are:
  - build errors: +2/-10
  - build warnings: +105/-19

Note that there may be false regressions, as the number of configs has
been increased dramatically (from 119 to 262!).
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.18-rc7.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/8143/ (262 out of 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7938/ (118 out of 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/8117/ (120 out of 119 configs)


*** ERRORS ***

18 regressions:
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.capacity’):  => 152:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.seg_max’):  => 151:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.host_features’):  => 149:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtnet_dev_page.host_features’):  => 119:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: braced-group within expression allowed only inside a function:  => 146:10, 116:10, 113:10, 96:10, 93:10
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: initializer element is not constant:  => 151:3, 152:3, 149:3, 119:3
  + /home/kisskb/slave/src/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c: error: impossible register constraint in ‘asm’:  => 34:1
  + /home/kisskb/slave/src/Documentation/prctl/disable-tsc-on-off-stress-test.c: error: impossible register constraint in ‘asm’:  => 36:1
  + /home/kisskb/slave/src/Documentation/prctl/disable-tsc-test.c: error: impossible register constraint in ‘asm’:  => 36:1
  + /home/kisskb/slave/src/Documentation/vDSO/vdso_standalone_test_x86.c: error: impossible register constraint in ‘asm’:  => 49:2
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A
  + error: fw.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.strlcpy' defined in .text section in lib/lib.a(string.o):  => (.text+0x1ff823c)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o:  => (.text+0x1ffa344), (.text+0x1ffa108)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_18' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9e34)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_20' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa0e0)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa31c), (.text+0x1ff8ce4)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_14' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa324)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff88dc), (.text+0x1ffa0e8)

18 improvements:
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_check_functionality' [-Werror=implicit-function-declaration]: 117:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_master_send' [-Werror=implicit-function-declaration]: 96:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_read_byte_data' [-Werror=implicit-function-declaration]: 28:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_read_word_data' [-Werror=implicit-function-declaration]: 64:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_write_byte_data' [-Werror=implicit-function-declaration]: 46:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_write_word_data' [-Werror=implicit-function-declaration]: 82:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_transfer' [-Werror=implicit-function-declaration]: 130:2 => 
  - /home/kisskb/slave/src/drivers/extcon/extcon-sm5502.c: error: implicit declaration of function 'i2c_add_driver' [-Werror=implicit-function-declaration]: 718:2 => 
  - /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: 'AT_FDCWD' undeclared (first use in this function): 378 => 
  - /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: (Each undeclared identifier is reported only once: 378 => 
  - /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: for each function it appears in.): 378 => 
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.__dev_kfree_skb_any' defined in .text section in net/built-in.o: (.text+0x1ff8e58) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_unlock_irqrestore' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ff9820), (.text+0x1ff9af0) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.bitrev32' defined in .text section in lib/built-in.o: (.text+0x1ff9598) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.strlcpy' defined in .text section in lib/lib.a(string.o): (.text+0x1ff8b90), (.text+0x1ff8b6c), (.text+0x1ff8bd0) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_21' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9b0c) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8a94), (.text+0x1ff8ae4) => 


*** WARNINGS ***

151 regressions:
  + /home/kisskb/slave/src/Documentation/networking/timestamping/txtimestamp.c: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 3 has type ‘int64_t’ [-Wformat=]:  => 93:3
  + /home/kisskb/slave/src/arch/arm/kernel/head-nommu.S: Warning: Use of r13 as a source register is deprecated when r15 is the destination register.:  => 167
  + /home/kisskb/slave/src/arch/arm/mach-gemini/board-nas4220b.c: warning: (near initialization for '__mach_desc_NAS4220B.restart') [enabled by default]:  => 106:2
  + /home/kisskb/slave/src/arch/arm/mach-gemini/board-nas4220b.c: warning: initialization from incompatible pointer type [enabled by default]:  => 106:2
  + /home/kisskb/slave/src/arch/arm/mach-gemini/board-wbd111.c: warning: (near initialization for '__mach_desc_WBD111.restart') [enabled by default]:  => 133:2
  + /home/kisskb/slave/src/arch/arm/mach-gemini/board-wbd111.c: warning: initialization from incompatible pointer type [enabled by default]:  => 133:2
  + /home/kisskb/slave/src/arch/arm/mach-gemini/board-wbd222.c: warning: (near initialization for '__mach_desc_WBD222.restart') [enabled by default]:  => 133:2
  + /home/kisskb/slave/src/arch/arm/mach-gemini/board-wbd222.c: warning: initialization from incompatible pointer type [enabled by default]:  => 133:2
  + /home/kisskb/slave/src/arch/arm/mm/cache-l2x0.c: warning: 'l2x0_cache_sync' defined but not used [-Wunused-function]:  => 168:13
  + /home/kisskb/slave/src/arch/arm/mm/cache-l2x0.c: warning: 'l2x0_disable' defined but not used [-Wunused-function]:  => 195:13
  + /home/kisskb/slave/src/arch/arm/mm/cache-l2x0.c: warning: 'l2x0_flush_all' defined but not used [-Wunused-function]:  => 185:13
  + /home/kisskb/slave/src/arch/s390/mm/vmem.c: warning: 'vmem_alloc_pages' defined but not used [-Wunused-function]:  => 30:20
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 347, 349
  + /home/kisskb/slave/src/arch/sparc/include/uapi/asm/swab.h: warning: use of memory input without lvalue in asm operand 1 is deprecated [enabled by default]:  => 34:2, 12:2, 23:2
  + /home/kisskb/slave/src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 83:2
  + /home/kisskb/slave/src/drivers/ata/pata_bf54x.c: warning: 'atapi_io_port' defined but not used [-Wunused-variable]:  => 1496:23
  + /home/kisskb/slave/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2178:6
  + /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]: 590:18 => 590:18, 587:17
  + /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]: 590:18 => 590:18, 587:17
  + /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]: 587:17 => 2978:1, 587:17
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat]:  => 2175:2
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat]:  => 1607:3, 926:3
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 2240:3
  + /home/kisskb/slave/src/drivers/char/tpm/tpm_ibmvtpm.c: warning: 'crq_q' may be used uninitialized in this function [-Wuninitialized]:  => 642:3
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 466:4
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]: 838:1 => 1272:1, 749:1, 945:1
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: 'hdrlen' may be used uninitialized in this function [-Wuninitialized]:  => 349:23
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 1812:1
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]:  => 3000:30
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/engine/disp/nv50.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 1018:4
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 117:5, 117:2
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 118:15
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 118:3
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/pwr/memx.c: warning: 'head_sync' may be used uninitialized in this function [-Wuninitialized]:  => 150:40
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/nouveau_gem.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 342:6
  + /home/kisskb/slave/src/drivers/gpu/drm/ttm/ttm_bo.c: warning: 'mem_type' may be used uninitialized in this function [-Wuninitialized]:  => 72:37
  + /home/kisskb/slave/src/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c: warning: 'res' may be used uninitialized in this function [-Wuninitialized]:  => 456:2
  + /home/kisskb/slave/src/drivers/hid/hid-picolcd_debugfs.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 312:10
  + /home/kisskb/slave/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1203:14, 1198:14, 1172:31, 1171:33
  + /home/kisskb/slave/src/drivers/input/keyboard/bf54x-keys.c: warning: unused variable 'pdata' [-Wunused-variable]:  => 335:34
  + /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'high_plane' may be used uninitialized in this function [-Wuninitialized]:  => 371:31, 359:13
  + /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'low_plane' may be used uninitialized in this function [-Wuninitialized]:  => 359:30
  + /home/kisskb/slave/src/drivers/media/rc/st_rc.c: warning: 'st_rc_resume' defined but not used [-Wunused-function]:  => 359:12
  + /home/kisskb/slave/src/drivers/media/rc/st_rc.c: warning: 'st_rc_suspend' defined but not used [-Wunused-function]:  => 338:12
  + /home/kisskb/slave/src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6875:13
  + /home/kisskb/slave/src/drivers/mfd/da903x.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 207:2, 229:2, 185:2
  + /home/kisskb/slave/src/drivers/mfd/tc3589x.c: warning: 'version' may be used uninitialized in this function [-Wuninitialized]:  => 409:2
  + /home/kisskb/slave/src/drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]:  => 363:3
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'int' [-Wformat]:  => 465:2
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'int' [-Wformat]:  => 174:4
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type 'int' [-Wformat]:  => 174:4
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 8 has type 'int' [-Wformat]:  => 174:4
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: unused variable 'drv_data' [-Wunused-variable]:  => 651:23, 642:23
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1456 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1835:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 603:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2256 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 651:1
  + /home/kisskb/slave/src/drivers/mtd/maps/bfin-async-flash.c: warning: unused variable 'ret' [-Wunused-variable]:  => 129:6
  + /home/kisskb/slave/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 164:17, 181:17
  + /home/kisskb/slave/src/drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 407:9
  + /home/kisskb/slave/src/drivers/net/can/bfin_can.c: warning: unused variable 'priv' [-Wunused-variable]:  => 617:24
  + /home/kisskb/slave/src/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 243:34
  + /home/kisskb/slave/src/drivers/net/ethernet/freescale/fec_main.c: warning: unused variable 'pdata' [-Wunused-variable]:  => 1632:28
  + /home/kisskb/slave/src/drivers/net/ethernet/freescale/fec_main.c: warning: unused variable 'val' [-Wunused-variable]:  => 929:6
  + /home/kisskb/slave/src/drivers/net/wireless/ath/wil6210/fw_inc.c: warning: 'hdr_sz' may be used uninitialized in this function [-Wuninitialized]:  => 447:4
  + /home/kisskb/slave/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]In file included from /home/kisskb/slave/src/drivers/net/wireless/b43/main.c:48:0::  => 651:2
  + /home/kisskb/slave/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]/home/kisskb/slave/src/drivers/usb/gadget/function/f_ncm.c: In function 'ncm_unwrap_ntb'::  => 381:2
  + /home/kisskb/slave/src/drivers/net/wireless/cw1200/scan.c: warning: value computed is not used [-Wunused-value]:  => 332:2
  + /home/kisskb/slave/src/drivers/net/wireless/cw1200/sta.c: warning: value computed is not used [-Wunused-value]:  => 143:2
  + /home/kisskb/slave/src/drivers/net/wireless/p54/lmac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[3]' [-Wattributes]  LD [M]  drivers/usb/wusbcore/wusbcore.o:  => 377:2
  + /home/kisskb/slave/src/drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 184:21, 172:12, 115:16, 160:21, 200:21, 213:17, 144:20
  + /home/kisskb/slave/src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 133:2
  + /home/kisskb/slave/src/drivers/rtc/rtc-palmas.c: warning: 'high_bb_charging' may be used uninitialized in this function [-Wuninitialized]:  => 269:3
  + /home/kisskb/slave/src/drivers/scsi/qla2xxx/qla_target.c: warning: 'cnt' may be used uninitialized in this function [-Wuninitialized]:  => 1504:9
  + /home/kisskb/slave/src/drivers/scsi/qla2xxx/qla_target.c: warning: 'cnt_in' may be used uninitialized in this function [-Wuninitialized]:  => 1504:9
  + /home/kisskb/slave/src/drivers/staging/comedi/drivers/dmm32at.c: warning: statement with no effect [-Wunused-value]:  => 562:3
  + /home/kisskb/slave/src/drivers/staging/goldfish/goldfish_nand.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 90:14
  + /home/kisskb/slave/src/drivers/staging/vt6655/device_main.c: warning: the frame size of 1304 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2993:1
  + /home/kisskb/slave/src/drivers/thunderbolt/ctl.c: warning: 'pkg' may be used uninitialized in this function [-Wuninitialized]:  => 460:18
  + /home/kisskb/slave/src/drivers/tty/goldfish.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 62:13, 84:13
  + /home/kisskb/slave/src/drivers/tty/serial/8250/8250_hp300.c: warning: #warning CONFIG_SERIAL_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure? [-Wcpp]:  => 24:2
  + /home/kisskb/slave/src/drivers/usb/gadget/udc/udc-xilinx.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 2135:2
  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: warning: 'bfin_remove' defined but not used [-Wunused-function]:  => 528:12
  + /home/kisskb/slave/src/drivers/usb/musb/ux500_dma.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 211:51
  + /home/kisskb/slave/src/drivers/usb/renesas_usbhs/common.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 469:25
  + /home/kisskb/slave/src/drivers/uwb/i1480/dfu/phy.c: warning: 'phy_stat' may be used uninitialized in this function [-Wuninitialized]:  => 188:5
  + /home/kisskb/slave/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 599:32, 569:10, 443:16, 625:11
  + /home/kisskb/slave/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 811:11, 785:32, 564:16
  + /home/kisskb/slave/src/drivers/video/fbdev/bf54x-lq043fb.c: warning: unused variable 'eppi_req_18' [-Wunused-variable]:  => 272:6, 240:6
  + /home/kisskb/slave/src/drivers/video/fbdev/bf54x-lq043fb.c: warning: unused variable 'eppi_req_24' [-Wunused-variable]:  => 256:7, 279:7
  + /home/kisskb/slave/src/drivers/video/fbdev/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /home/kisskb/slave/src/drivers/video/fbdev/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]:  => 64:2
  + /home/kisskb/slave/src/drivers/video/fbdev/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]:  => 65:2
  + /home/kisskb/slave/src/drivers/video/fbdev/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]:  => 4127:13
  + /home/kisskb/slave/src/fs/btrfs/extent_io.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 2166:13
  + /home/kisskb/slave/src/fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1382:23
  + /home/kisskb/slave/src/fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1327:6 => 1342:6, 1192:6
  + /home/kisskb/slave/src/fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]:  => 1378:38
  + /home/kisskb/slave/src/fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1383:18
  + /home/kisskb/slave/src/fs/btrfs/uuid-tree.c: warning: 'eb' may be used uninitialized in this function [-Wuninitialized]:  => 150:25
  + /home/kisskb/slave/src/fs/btrfs/uuid-tree.c: warning: 'offset' may be used uninitialized in this function [-Wuninitialized]:  => 149:21
  + /home/kisskb/slave/src/fs/ext4/inode.c: warning: 'retval' may be used uninitialized in this function [-Wuninitialized]: 558:5 => 555:5, 555:2
  + /home/kisskb/slave/src/fs/f2fs/f2fs.h: warning: 'page' may be used uninitialized in this function [-Wuninitialized]:  => 958:2
  + /home/kisskb/slave/src/fs/f2fs/node.c: warning: 'nat_blk' may be used uninitialized in this function [-Wuninitialized]:  => 1888:11
  + /home/kisskb/slave/src/fs/mpage.c: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 310:1
  + /home/kisskb/slave/src/fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]:  => 909:21, 664:17
  + /home/kisskb/slave/src/include/linux/percpu-refcount.h: warning: 'percpu_count' may be used uninitialized in this function [-Wuninitialized]:  => 164:1, 249:1
  + /home/kisskb/slave/src/kernel/debug/debug_core.c: warning: value computed is not used [-Wunused-value]:  => 519:5, 504:4
  + /home/kisskb/slave/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 738:2
  + /home/kisskb/slave/src/mm/slub.c: warning: '__slab_alloc.constprop.43' uses dynamic stack allocation [enabled by default]:  => 2363:1
  + /home/kisskb/slave/src/mm/vmstat.c: warning: 'frag_next' defined but not used [-Wunused-function]:  => 700:14
  + /home/kisskb/slave/src/mm/vmstat.c: warning: 'frag_start' defined but not used [-Wunused-function]:  => 688:14
  + /home/kisskb/slave/src/mm/vmstat.c: warning: 'frag_stop' defined but not used [-Wunused-function]:  => 708:13
  + /home/kisskb/slave/src/mm/vmstat.c: warning: 'walk_zones_in_node' defined but not used [-Wunused-function]:  => 713:13
  + /home/kisskb/slave/src/net/core/dev.c: warning: 'tail' may be used uninitialized in this function [-Wuninitialized]:  => 2736:15
  + /home/kisskb/slave/src/net/core/dev.c: warning: 'tail' may be used uninitialized in this function:  => 2720:39, 2720
  + /home/kisskb/slave/src/net/mac80211/mlme.c: warning: 'pwr_level_cisco' may be used uninitialized in this function [-Wuninitialized]:  => 1290:3
  + /home/kisskb/slave/src/net/netlink/genetlink.c: warning: 'first_id' may be used uninitialized in this function [-Wuninitialized]:  => 256:23
  + /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /home/kisskb/slave/src/scripts/kconfig/menu.c: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 590:18
  + /home/kisskb/slave/src/sound/pci/pcxhr/pcxhr_core.c: warning: 'new_sample_count' may be used uninitialized in this function [-Wuninitialized]:  => 1202:4
  + /home/kisskb/slave/src/sound/soc/blackfin/bf5xx-ac97.c: warning: statement with no effect [-Wunused-value]:  => 181:2
  + /home/kisskb/slave/src/sound/soc/codecs/cs35l32.c: warning: 'val' is used uninitialized in this function [-Wuninitialized]:  => 314:2
  + /home/kisskb/slave/src/sound/soc/intel/sst-atom-controls.c: warning: 'sst_fill_and_send_cmd' defined but not used [-Wunused-function]:  => 70:12
  + /home/kisskb/slave/src/sound/soc/intel/sst-mfld-platform-pcm.c: warning: 'sst_media_dai_ops' defined but not used [-Wunused-variable]:  => 454:31
  + <stdin>: warning: #warning syscall bpf not implemented [-Wcpp]:  => 1247:2
  + <stdin>: warning: #warning syscall bpf not implemented:  => 1247:2
  + arch/blackfin/configs/BF527-EZKIT_defconfig: warning: override: MUSB_PIO_ONLY changes choice state:  => 150
  + arch/blackfin/configs/BF527-EZKIT_defconfig: warning: override: reassigning to symbol MUSB_PIO_ONLY:  => 150
  + warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES):  => N/A
  + warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && MFD_TIMBERDALE):  => N/A
  + warning: 1 bad relocations:  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x5ae8): Section mismatch in reference from the function .fsl_add_bridge() to the function .init.text:.setup_pci_cmd():  => N/A
  + warning: drivers/built-in.o(.text+0x2e7d70): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x56e54): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d38): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x43f08): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1340): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/ethernet/3com/3c59x.o(.data+0xe4): Section mismatch in reference from the variable vortex_eisa_driver to the function .init.text:vortex_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/dec/tulip/de4x5.o(.data+0xd8): Section mismatch in reference from the variable de4x5_eisa_driver to the function .init.text:de4x5_eisa_probe():  => N/A
  + warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence:  => N/A
  + warning: vmlinux.o(.data+0x41650): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x416f0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x41854): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x41964): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x419c4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41a24): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41a8c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41c5c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.text+0x8a6c7): Section mismatch in reference from the function intel_scu_devices_create() to the function .init.text:i2c_register_board_info():  => N/A

83 improvements:
  - .config: warning: override: reassigning to symbol ENABLE_MUST_CHECK: 7885 => 
  - .config: warning: override: reassigning to symbol PROFILE_ALL_BRANCHES: 7883 => 
  - /home/kisskb/slave/src/arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]: 63:2 => 
  - /home/kisskb/slave/src/arch/mips/include/asm/compat.h: warning: 'cp' may be used uninitialized in this function [-Wuninitialized]: 208:24 => 
  - /home/kisskb/slave/src/arch/mips/include/asm/compat.h: warning: 'fp' may be used uninitialized in this function [-Wuninitialized]: 208:24 => 
  - /home/kisskb/slave/src/arch/mips/include/asm/compat.h: warning: 'handler' may be used uninitialized in this function [-Wuninitialized]: 208:24 => 
  - /home/kisskb/slave/src/arch/mips/include/asm/compat.h: warning: 'palp' may be used uninitialized in this function [-Wuninitialized]: 208:24 => 
  - /home/kisskb/slave/src/arch/mips/include/asm/compat.h: warning: 'rtdev' may be used uninitialized in this function [-Wuninitialized]: 208:24 => 
  - /home/kisskb/slave/src/arch/x86/kernel/cpu/common.c: warning: 'syscall32_cpu_init' defined but not used [-Wunused-function]: 968:13 => 
  - /home/kisskb/slave/src/block/compat_ioctl.c: warning: 'n' may be used uninitialized in this function [-Wuninitialized]: 195:9 => 
  - /home/kisskb/slave/src/block/compat_ioctl.c: warning: 'udata' may be used uninitialized in this function [-Wuninitialized]: 201:9 => 
  - /home/kisskb/slave/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]: 194:13 => 
  - /home/kisskb/slave/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]: 177:13 => 
  - /home/kisskb/slave/src/drivers/memstick/host/r592.c: warning: 'r592_clear_interrupts' defined but not used [-Wunused-function]: 192:13 => 
  - /home/kisskb/slave/src/drivers/mfd/88pm860x-i2c.c: warning: 'write_device' uses dynamic stack allocation [enabled by default]: 141:1 => 
  - /home/kisskb/slave/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_resume' defined but not used [-Wunused-function]: 127:12 => 
  - /home/kisskb/slave/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_suspend' defined but not used [-Wunused-function]: 118:12 => 
  - /home/kisskb/slave/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_bulk_write' uses dynamic stack allocation [enabled by default]: 108:1 => 
  - /home/kisskb/slave/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_reg_write' uses dynamic stack allocation [enabled by default]: 80:1 => 
  - /home/kisskb/slave/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_set_bits' uses dynamic stack allocation [enabled by default]: 128:1 => 
  - /home/kisskb/slave/src/drivers/mfd/rtsx_pcr.c: warning: 'rtsx_pci_power_off' defined but not used [-Wunused-function]: 950:13 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1835:1 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /home/kisskb/slave/src/include/pcmcia/ds.h:213) [-Wdeprecated-declarations]: 624:3 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/broadcom/genet/bcmgenet.c: warning: 'bcmgenet_wol_resume' defined but not used [-Wunused-function]: 2020:12 => 
  - /home/kisskb/slave/src/drivers/nfc/trf7970a.c: warning: 'trf7970a_init' defined but not used [-Wunused-function]: 754:12 => 
  - /home/kisskb/slave/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]: 697:12 => 
  - /home/kisskb/slave/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]: 728:13 => 
  - /home/kisskb/slave/src/drivers/pwm/core.c: warning: 'period' may be used uninitialized in this function: 609 => 
  - /home/kisskb/slave/src/drivers/pwm/core.c: warning: 'polarity' may be used uninitialized in this function [-Wuninitialized]: 676:18 => 
  - /home/kisskb/slave/src/drivers/pwm/core.c: warning: 'polarity' may be used uninitialized in this function: 610 => 
  - /home/kisskb/slave/src/drivers/scsi/cxgbi/libcxgbi.c: warning: 'cxgbi_device_find_by_mac' defined but not used [-Wunused-function]: 278:29 => 
  - /home/kisskb/slave/src/drivers/spi/spi-omap-100k.c: warning: "READ" redefined [enabled by default]: 74:0 => 
  - /home/kisskb/slave/src/drivers/spi/spi-omap-100k.c: warning: "WRITE" redefined [enabled by default]: 73:0 => 
  - /home/kisskb/slave/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 572:1 => 
  - /home/kisskb/slave/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 572:1 => 
  - /home/kisskb/slave/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 2 has type 'sk_buff_data_t' [-Wformat]: 885:5 => 
  - /home/kisskb/slave/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 3 has type 'sk_buff_data_t' [-Wformat]: 885:5 => 
  - /home/kisskb/slave/src/drivers/staging/rtl8712/rtl871x_ioctl_linux.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]: 1855:9, 1873:15 => 
  - /home/kisskb/slave/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%d' expects argument of type 'int', but argument 5 has type 'u64' [-Wformat]: 749:2, 1151:5 => 
  - /home/kisskb/slave/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%d' expects argument of type 'int', but argument 7 has type 'u64' [-Wformat]: 1142:4 => 
  - /home/kisskb/slave/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'u64' [-Wformat]: 520:2 => 
  - /home/kisskb/slave/src/drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 1068 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 792:1 => 
  - /home/kisskb/slave/src/drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 792:1 => 
  - /home/kisskb/slave/src/drivers/tty/serial/8250/8250_hp300.c: warning: #warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure? [-Wcpp]: 24:2 => 
  - /home/kisskb/slave/src/drivers/usb/gadget/function/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function [-Wuninitialized]: 2356:47 => 
  - /home/kisskb/slave/src/drivers/usb/storage/realtek_cr.c: warning: 'config_autodelink_before_power_down' defined but not used [-Wunused-function]: 629:12 => 
  - /home/kisskb/slave/src/drivers/usb/storage/realtek_cr.c: warning: 'fw5895_init' defined but not used [-Wunused-function]: 699:13 => 
  - /home/kisskb/slave/src/fs/compat_ioctl.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]: 217:9 => 
  - /home/kisskb/slave/src/fs/compat_ioctl.c: warning: 'size' may be used uninitialized in this function [-Wuninitialized]: 189:9 => 
  - /home/kisskb/slave/src/fs/mpage.c: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 308:1 => 
  - /home/kisskb/slave/src/include/linux/mtd/cfi.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]  CC      drivers/sh/pm_runtime.o: 489:3 => 
  - /home/kisskb/slave/src/include/linux/pwm.h: warning: 'period' may be used uninitialized in this function [-Wuninitialized]: 98:15 => 
  - /home/kisskb/slave/src/kernel/acct.c: warning: unused variable 'ns' [-Wunused-variable]: 475:24 => 
  - /home/kisskb/slave/src/kernel/acct.c: warning: unused variable 'ns': 475 => 
  - /home/kisskb/slave/src/kernel/sched/core.c: warning: statement with no effect [-Wunused-value]: 2342:2 => 
  - /home/kisskb/slave/src/kernel/sched/core.c: warning: value computed is not used [-Wunused-value]: 2225:2 => 
  - /home/kisskb/slave/src/mm/slab_common.c: warning: 's' may be used uninitialized in this function [-Wuninitialized]: 204:21 => 
  - /home/kisskb/slave/src/mm/slub.c: warning: '__slab_alloc.constprop.44' uses dynamic stack allocation [enabled by default]: 2361:1 => 
  - /home/kisskb/slave/src/sound/isa/sb/emu8000_patch.c: warning: 'cc' may be used uninitialized in this function [-Wuninitialized]: 98:7, 91:5 => 
  - /home/kisskb/slave/src/sound/soc/codecs/mc13783.c: warning: 'np' may be used uninitialized in this function [-Wuninitialized]: 787:13 => 
  - /home/kisskb/slave/src/sound/soc/codecs/rt286.c: warning: 'rt286_index_sync' defined but not used [-Wunused-function]: 272:13 => 
  - /home/kisskb/slave/src/sound/soc/codecs/tas2552.c: warning: 'tas2552_sw_shutdown' defined but not used [-Wunused-function]: 81:13 => 
  - /home/kisskb/slave/src/sound/soc/fsl/fsl_sai.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 337:7 => 
  - /home/kisskb/slave/src/sound/soc/s6000/s6000-i2s.c: warning: unused variable 'mmio' [-Wunused-variable]: 577:16 => 
  - arch/powerpc/configs/mpc85xx_defconfig: warning: override: reassigning to symbol RTC_DRV_DS1307: 216 => 
  - warning: (PPC_CELLEB) selects HAS_TXX9_SERIAL which has unmet direct dependencies (TTY && HAS_IOMEM): N/A => 
  - warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && AKEBONO && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: drivers/built-in.o(.text+0x2dfdc0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x56a30): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x1d58): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x42c9c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/cris/built-in.o(.text+0x1360): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: vmlinux.o(.data+0x40d50): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40df0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40f54): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41064): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x410c4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41124): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4118c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x4135c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
