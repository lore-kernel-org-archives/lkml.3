Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaEFMEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:04:43 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:49341 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbaEFMEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:04:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.15-rc4
Date: Tue,  6 May 2014 14:04:37 +0200
Message-Id: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.15-rc4[1] compared to v3.14[2].

Summarized:
  - build errors: +11/-2
  - build warnings: +181/-114

JFYI, when comparing v3.15-rc4[1]  to v3.15-rc3[3], the summaries are:
  - build errors: +7/-1
  - build warnings: +76/-26

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.15-rc4.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7449/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7320/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7427/ (all 119 configs)


*** ERRORS ***

11 regressions:
  + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error: overflow in enumeration values  CC      drivers/hwmon/smsc47m192.o:  => 51:2
  + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error: overflow in enumeration values  CC [M]  drivers/usb/gadget/f_rndis.o:  => 51:2
  + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error: overflow in enumeration values:  => 51:2
  + /scratch/kisskb/src/arch/powerpc/kernel/head_44x.S: Error: invalid operands (*ABS* and *UND* sections) for `|':  => 686, 603
  + /scratch/kisskb/src/arch/powerpc/mm/tlb_nohash_low.S: Error: unsupported relocation against PPC47x_TLBE_SIZE:  => 113
  + /scratch/kisskb/src/arch/powerpc/platforms/powernv/setup.c: error: implicit declaration of function 'get_hard_smp_processor_id' [-Werror=implicit-function-declaration]:  => 179:4
  + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: 'TMPFS_MAGIC' undeclared (first use in this function):  => 31
  + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: (Each undeclared identifier is reported only once:  => 31
  + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: for each function it appears in.):  => 31
  + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: linux/magic.h: No such file or directory:  => 16:25
  + error: "__invalidate_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A

2 improvements:
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+bc8: (.text+0x9c2) => 


*** WARNINGS ***

181 regressions:
  + ./scratch/kisskb/src/drivers/scsi/scsi_tgt_if.c: warning: "TGT_RING_SIZE" redefined [enabled by default]:  => 39:0
  + /scratch/kisskb/src/arch/cris/include/arch-v10/arch/system.h: warning: "nop" redefined [enabled by default]/scratch/kisskb/src/sound/soc/codecs/pcm512x.c:545:12: warning: 'pcm512x_resume' defined but not used [-Wunused-function]:  => 39:0
  + /scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c:46) [-Wdeprecated-declarations]  CC      security/keys/gc.o:  => 73:2
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 376 => 383, 380
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 376 => 383, 380
  + /scratch/kisskb/src/arch/sh/math-emu/math.c: warning: 'ieee_fpe_handler' defined but not used [-Wunused-function]:  => 505:12
  + /scratch/kisskb/src/arch/x86/crypto/sha1_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 50:1
  + /scratch/kisskb/src/arch/x86/crypto/sha256_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 56:1
  + /scratch/kisskb/src/arch/x86/crypto/sha512_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 55:1
  + /scratch/kisskb/src/arch/x86/kernel/cpu/perf_event_amd_ibs.c: warning: 'config' may be used uninitialized in this function [-Wuninitialized]:  => 268:11
  + /scratch/kisskb/src/arch/x86/kernel/machine_kexec_32.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 191:12
  + /scratch/kisskb/src/arch/x86/kernel/syscall_32.c: warning: 'externally_visible' attribute ignored [-Wattributes]:  => 14:1
  + /scratch/kisskb/src/arch/x86/kernel/vsyscall_64.c: warning: 'syscall_nr' may be used uninitialized in this function [-Wuninitialized]:  => 217:16
  + /scratch/kisskb/src/drivers/base/memory.c: warning: 'section_nr' may be used uninitialized in this function [-Wuninitialized]:  => 607:25
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2024:6
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'this_page' may be used uninitialized in this function [-Wuninitialized]:  => 1683:4
  + /scratch/kisskb/src/drivers/char/random.c: warning: 'arch_random_refill' uses dynamic stack allocation [enabled by default]:  => 1326:1
  + /scratch/kisskb/src/drivers/gpu/drm/bochs/bochs_drv.c: warning: 'bochs_pm_resume' defined but not used [-Wunused-function]:  => 117:12
  + /scratch/kisskb/src/drivers/gpu/drm/bochs/bochs_drv.c: warning: 'bochs_pm_suspend' defined but not used [-Wunused-function]:  => 100:12
  + /scratch/kisskb/src/drivers/gpu/drm/cirrus/cirrus_drv.c: warning: 'cirrus_pm_resume' defined but not used [-Wunused-function]:  => 96:12
  + /scratch/kisskb/src/drivers/gpu/drm/cirrus/cirrus_drv.c: warning: 'cirrus_pm_suspend' defined but not used [-Wunused-function]:  => 79:12
  + /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 471:4
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'clock2' may be used uninitialized in this function [-Wuninitialized]:  => 2544:3
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]:  => 2969:30
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid_load.c: warning: 'fwdata' may be used uninitialized in this function [-Wuninitialized]:  => 186:2
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_cmd_parser.c: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]:  => 405:4
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_debugfs.c: warning: 'pipe' may be used uninitialized in this function [-Wuninitialized]:  => 3056:2
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_debugfs.c: warning: 'source' may be used uninitialized in this function [-Wuninitialized]:  => 3056:2
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_gem_gtt.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 1490:3, 123:6
  + /scratch/kisskb/src/drivers/gpu/drm/i915/intel_ringbuffer.c: warning: 'tail' may be used uninitialized in this function [-Wuninitialized]:  => 38:26
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 77:6
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 140:11
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 117:2
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 118:15
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 118:3
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/r100.c: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]:  => 3577:47
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/r100.c: warning: 'disp_drain_rate.full' may be used uninitialized in this function [-Wuninitialized]:  => 3576:42
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/rv770_dpm.c: warning: 'postdiv_yclk' may be used uninitialized in this function [-Wuninitialized]:  => 431:23
  + /scratch/kisskb/src/drivers/gpu/drm/ttm/ttm_bo.c: warning: 'mem_type' may be used uninitialized in this function [-Wuninitialized]:  => 70:37
  + /scratch/kisskb/src/drivers/hid/hid-picolcd_debugfs.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 312:10
  + /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/cq.c: warning: 'hw_cqe' may be used uninitialized in this function [-Wuninitialized]:  => 307:33, 303:21
  + /scratch/kisskb/src/drivers/infiniband/hw/ehca/ehca_mrmw.c: warning: 'prev_pgaddr' may be used uninitialized in this function [-Wuninitialized]:  => 1907:6
  + /scratch/kisskb/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1185:4
  + /scratch/kisskb/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 1185:4
  + /scratch/kisskb/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: right shift count >= width of type [enabled by default]:  => 1185:4
  + /scratch/kisskb/src/drivers/input/misc/max8997_haptic.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 185:19
  + /scratch/kisskb/src/drivers/memstick/core/ms_block.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1912:10
  + /scratch/kisskb/src/drivers/memstick/core/ms_block.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 1912:3
  + /scratch/kisskb/src/drivers/memstick/core/ms_block.c: warning: right shift count >= width of type [enabled by default]:  => 1912:3
  + /scratch/kisskb/src/drivers/misc/bh1770glc.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 236:29
  + /scratch/kisskb/src/drivers/misc/mic/host/mic_fops.c: warning: 'pa' may be used uninitialized in this function [-Wuninitialized]:  => 210:24
  + /scratch/kisskb/src/drivers/misc/mic/host/mic_virtio.c: warning: 'devp' may be used uninitialized in this function [-Wuninitialized]:  => 492:8
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/cnic.c: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 4835:1
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb/cxgb2.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 248:6
  + /scratch/kisskb/src/drivers/net/ethernet/intel/i40e/i40e_hmc.c: warning: 'ret_code' may be used uninitialized in this function [-Wuninitialized]:  => 107:2
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx4/mcg.c: warning: 'hash' may be used uninitialized in this function [-Wuninitialized]:  => 631:9
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c: warning: 'smac_index' may be used uninitialized in this function [-Wuninitialized]:  => 1821:25
  + /scratch/kisskb/src/drivers/net/plip/plip.c: warning: 'lbuf' may be used uninitialized in this function [-Wuninitialized]:  => 825:4
  + /scratch/kisskb/src/drivers/net/wireless/ti/wlcore/spi.c: warning: the frame size of 1168 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 317:1
  + /scratch/kisskb/src/drivers/net/wireless/ti/wlcore/spi.c: warning: the frame size of 38080 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 317:1
  + /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'phys_addr_t' [-Wformat]:  => 1006:2
  + /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]:  => 1006:2
  + /scratch/kisskb/src/drivers/platform/x86/samsung-laptop.c: warning: 'loca' may be used uninitialized in this function [-Wuninitialized]:  => 1356:2
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'en_term' may be used uninitialized in this function [-Wuninitialized]:  => 624:27
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'force_20pct' may be used uninitialized in this function [-Wuninitialized]:  => 617:27
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 213:17, 184:21, 200:21, 160:21, 144:20, 172:12, 115:16
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 137:19
  + /scratch/kisskb/src/drivers/regulator/max8925-regulator.c: warning: 'ri' may be used uninitialized in this function [-Wuninitialized]:  => 313:45
  + /scratch/kisskb/src/drivers/scsi/gdth_proc.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 243:13
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]:  => 6628:5
  + /scratch/kisskb/src/drivers/scsi/scsi_debug.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 2014:2, 307:11
  + /scratch/kisskb/src/drivers/scsi/scsi_debug.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 307:2, 2014:2
  + /scratch/kisskb/src/drivers/scsi/scsi_debug.c: warning: right shift count >= width of type [enabled by default]:  => 307:2, 2014:2
  + /scratch/kisskb/src/drivers/sh/clk/cpg.c: warning: passing argument 1 of 'ioread16' discards 'const' qualifier from pointer target type [enabled by default]:  => 46:2
  + /scratch/kisskb/src/drivers/sh/clk/cpg.c: warning: passing argument 1 of 'ioread32' discards 'const' qualifier from pointer target type [enabled by default]:  => 51:2
  + /scratch/kisskb/src/drivers/sh/clk/cpg.c: warning: passing argument 1 of 'ioread8' discards 'const' qualifier from pointer target type [enabled by default]:  => 41:2
  + /scratch/kisskb/src/drivers/spi/spi-fsl-lib.c: warning: unused variable 'ret' [-Wunused-variable]:  => 201:6
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/das6402.c: warning: statement with no effect [-Wunused-value]:  => 369:2, 430:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/pcl818.c: warning: 'last_chan' may be used uninitialized in this function [-Wuninitialized]:  => 412:6
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 1563:2
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'tcflag_t' [-Wformat]:  => 6258:2, 6232:2, 6310:2, 6284:2
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 6004:7, 5964:7, 5984:7, 6024:7
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.h: warning: "IO_FIELD" redefined [enabled by default]:  => 447:0
  + /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'invalid_cmd_field' defined but not used [-Wunused-variable]:  => 651:11
  + /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'media_not_present' defined but not used [-Wunused-variable]:  => 649:11
  + /scratch/kisskb/src/drivers/staging/silicom/bpctl_mod.c: warning: 'bp_proc_create' defined but not used [-Wunused-function]:  => 6786:12
  + /scratch/kisskb/src/drivers/staging/usbip/stub_dev.c: warning: 'stub_table' defined but not used [-Wunused-variable]:  => 33:29
  + /scratch/kisskb/src/drivers/tty/serial/8250/8250_core.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1712:2, 1714:18, 1717:18 => 1721:18, 1718:18, 1676:2, 1716:2
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 269:6
  + /scratch/kisskb/src/drivers/video/fbdev/amifb.c: warning: 'amifb_setup' defined but not used [-Wunused-function]:  => 2346:19
  + /scratch/kisskb/src/drivers/video/fbdev/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + /scratch/kisskb/src/drivers/video/fbdev/auo_k190x.c: warning: 'auok190x_resume' defined but not used [-Wunused-function]:  => 899:12
  + /scratch/kisskb/src/drivers/video/fbdev/auo_k190x.c: warning: 'auok190x_suspend' defined but not used [-Wunused-function]:  => 859:12
  + /scratch/kisskb/src/drivers/video/fbdev/goldfishfb.c: warning: 'fbpaddr' may be used uninitialized in this function [-Wuninitialized]:  => 256:24
  + /scratch/kisskb/src/drivers/video/fbdev/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /scratch/kisskb/src/drivers/video/fbdev/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 734:23
  + /scratch/kisskb/src/drivers/w1/slaves/w1_therm.c: warning: 'verdict' may be used uninitialized in this function [-Wuninitialized]:  => 271:2
  + /scratch/kisskb/src/fs/cifs/connect.c: warning: 'ses' may be used uninitialized in this function [-Wuninitialized]:  => 3440:20
  + /scratch/kisskb/src/fs/cifs/connect.c: warning: 'tcon' may be used uninitialized in this function [-Wuninitialized]:  => 3438:17
  + /scratch/kisskb/src/fs/cifs/connect.c: warning: 'xid' may be used uninitialized in this function [-Wuninitialized]:  => 3442:3
  + /scratch/kisskb/src/fs/cifs/inode.c: warning: 'server' may be used uninitialized in this function [-Wuninitialized]: 1997:12 => 1997:2, 1997:12
  + /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]:  => 58:13
  + /scratch/kisskb/src/fs/f2fs/checkpoint.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 89:1
  + /scratch/kisskb/src/include/drm/drm_fixed.h: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]:  => 64:13
  + /scratch/kisskb/src/include/linux/ceph/osdmap.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 54:1
  + /scratch/kisskb/src/include/linux/file.h: warning: '*((void *)&output+8)' may be used uninitialized in this function [-Wuninitialized]:  => 38:2
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]:  => 39:7
  + /scratch/kisskb/src/include/linux/hid.h: warning: 'report' may be used uninitialized in this function [-Wuninitialized]:  => 971:34
  + /scratch/kisskb/src/include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 643:11
  + /scratch/kisskb/src/include/linux/list_nulls.h: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 35:2
  + /scratch/kisskb/src/include/linux/pagemap.h: warning: 'blk_addr' may be used uninitialized in this function [-Wuninitialized]:  => 287:2
  + /scratch/kisskb/src/include/linux/pci.h: warning: 'ctrl_pos2' may be used uninitialized in this function [-Wuninitialized]:  => 858:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/ipc/mqueue.c: warning: 'msg_ptr' may be used uninitialized in this function [-Wuninitialized]:  => 1165:3
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]:  => 1609:13
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function:  => 1486
  + /scratch/kisskb/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 736:2
  + /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: 'delta' may be used uninitialized in this function [-Wuninitialized]:  => 174:20
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]:  => 70:2, 73:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]:  => 45:2, 49:4, 56:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]:  => 113:2, 116:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]:  => 92:4, 99:2, 88:2
  + /scratch/kisskb/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]:  => 668:14
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 944:15
  + /scratch/kisskb/src/mm/memory.c: warning: 'last_cpupid' may be used uninitialized in this function [-Wuninitialized]:  => 3789:18
  + /scratch/kisskb/src/mm/slab_common.c: warning: 's' may be used uninitialized in this function [-Wuninitialized]:  => 203:21
  + /scratch/kisskb/src/net/compat.c: warning: 'numsrc' may be used uninitialized in this function [-Wuninitialized]:  => 629:3
  + /scratch/kisskb/src/net/core/skbuff.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1337:6
  + /scratch/kisskb/src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 209:2
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function [-Wuninitialized]:  => 183:16
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]:  => 656:16
  + /scratch/kisskb/src/net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function [-Wuninitialized]:  => 927:3
  + /scratch/kisskb/src/net/ipv4/udp.c: warning: 'sk' may be used uninitialized in this function [-Wuninitialized]:  => 1905:8
  + /scratch/kisskb/src/net/openvswitch/datapath.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 483:2
  + /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_field_array_hash_tfm' uses dynamic stack allocation [enabled by default]:  => 194:1
  + /scratch/kisskb/src/sound/soc/codecs/adau1977.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 971:3
  + /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_resume' defined but not used [-Wunused-function]:  => 545:12
  + /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_suspend' defined but not used [-Wunused-function]:  => 520:12
  + <stdin>: warning: #warning syscall renameat2 not implemented [-Wcpp]:  => 1232:2
  + <stdin>: warning: #warning syscall renameat2 not implemented:  => 1232:2
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_PSERIES && PM_SLEEP_SMP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV || PPC_85xx && !PPC_E500MC)):  => N/A
  + warning: (VIDEO_GO7007) selects VIDEO_OV7640 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT):  => N/A
  + warning: drivers/built-in.o(.data+0x107c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa70): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb10): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc74): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd84): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xde4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe44): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xeac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x2c013c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x512a0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d54): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x3fe5c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1360): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x170): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x210): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x374): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x484): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x4e4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x544): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x5ac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x77c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.data+0x414b0): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x41550): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x416b4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x417c4): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41824): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41884): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x418ec): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41abc): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

114 improvements:
  - /scratch/kisskb/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 573:1 => 
  - /scratch/kisskb/src/drivers/base/topology.c: warning: unused variable 'cpu' [-Wunused-variable]: 86:1, 83:1 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_resume' defined but not used [-Wunused-function]: 2550:12 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_suspend' defined but not used [-Wunused-function]: 2541:12 => 
  - /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio': 204 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-designware-pcidrv.c: warning: 'i2c_dw_pci_runtime_idle' defined but not used [-Wunused-function]: 188:12 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]: 120:41 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]: 120:57 => 
  - /scratch/kisskb/src/drivers/md/bcache/bset.c: warning: format '%li' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat]: 27:10 => 
  - /scratch/kisskb/src/drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 1351:3, 1056:3 => 
  - /scratch/kisskb/src/drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]: 1105:1 => 
  - /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 190:10 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2.c: warning: 'bnx2_resume' defined but not used [-Wunused-function]: 8655:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2.c: warning: 'bnx2_suspend' defined but not used [-Wunused-function]: 8635:1 => 
  - /scratch/kisskb/src/drivers/net/wireless/iwlwifi/mvm/nvm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 471:6 => 
  - /scratch/kisskb/src/drivers/platform/x86/acer-wmi.c: warning: 'acer_resume' defined but not used [-Wunused-function]: 2060:12 => 
  - /scratch/kisskb/src/drivers/platform/x86/acer-wmi.c: warning: 'acer_suspend' defined but not used [-Wunused-function]: 2038:12 => 
  - /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]: 693:12 => 
  - /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]: 724:13 => 
  - /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]: 1246:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]: 1246:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-gpio.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 253:8 => 
  - /scratch/kisskb/src/drivers/staging/cxt1e1/functions.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 268:21 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_conf.h: warning: "IO_FIELD" redefined [enabled by default]  LD [M]  net/sunrpc/sunrpc.o: 165:0 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_conf.h: warning: "IO_FIELD" redefined [enabled by default]: 165:0 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 961:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 961:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 961:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 961:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 103:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 164:1, 103:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 103:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 164:1, 103:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'tcflag_t' [-Wformat]: 494:2, 519:2, 569:2, 544:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 292:4, 258:4, 275:4, 241:4 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 570:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 1615:6 => 
  - /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]: 1615:6 => 
  - /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: right shift count >= width of type [enabled by default]: 1615:6 => 
  - /scratch/kisskb/src/drivers/staging/line6/midi.c: warning: 'line6_midi_transmit' uses dynamic stack allocation [enabled by default]: 76:1 => 
  - /scratch/kisskb/src/drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'sm7xx_vga_setup' defined but not used [-Wunused-function]: 117:19 => 
  - /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]: 773:18 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'data_len' may be used uninitialized in this function [-Wuninitialized]: 670:17 => 
  - /scratch/kisskb/src/drivers/usb/host/xhci.c: warning: 'xhci_msix_sync_irqs' defined but not used [-Wunused-function]: 416:13 => 
  - /scratch/kisskb/src/drivers/video/amifb.c: warning: 'amifb_setup' defined but not used [-Wunused-function]: 2346:19 => 
  - /scratch/kisskb/src/drivers/video/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1019:23 => 
  - /scratch/kisskb/src/drivers/video/auo_k190x.c: warning: 'auok190x_resume' defined but not used [-Wunused-function]: 899:12 => 
  - /scratch/kisskb/src/drivers/video/auo_k190x.c: warning: 'auok190x_suspend' defined but not used [-Wunused-function]: 859:12 => 
  - /scratch/kisskb/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 809:11 => 
  - /scratch/kisskb/src/drivers/video/goldfishfb.c: warning: 'fbpaddr' may be used uninitialized in this function [-Wuninitialized]: 256:24 => 
  - /scratch/kisskb/src/drivers/video/intelfb/intelfbdrv.c: warning: passing argument 3 of 'get_opt_bool' from incompatible pointer type [enabled by default]: 367:3, 361:3, 357:3, 363:3, 365:3 => 
  - /scratch/kisskb/src/drivers/video/intelfb/intelfbhw.c: warning: 'm1' may be used uninitialized in this function [-Wuninitialized]: 1015:2 => 
  - /scratch/kisskb/src/drivers/video/intelfb/intelfbhw.c: warning: 'm2' may be used uninitialized in this function [-Wuninitialized]: 1015:2 => 
  - /scratch/kisskb/src/drivers/video/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]: 335:2 => 
  - /scratch/kisskb/src/drivers/video/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1185:23 => 
  - /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]: 64:2 => 
  - /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]: 65:2 => 
  - /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]: 4131:13 => 
  - /scratch/kisskb/src/drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]: 1634:4 => 
  - /scratch/kisskb/src/drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]: 1635:4 => 
  - /scratch/kisskb/src/drivers/watchdog/shwdt.c: warning: unused variable 'wdt' [-Wunused-variable]: 296:17 => 
  - /scratch/kisskb/src/fs/btrfs/send.c: warning: 'cb' may be used uninitialized in this function [-Wuninitialized]: 3644:7 => 
  - /scratch/kisskb/src/fs/btrfs/send.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 3629:7 => 
  - /scratch/kisskb/src/fs/file.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 434:23 => 
  - /scratch/kisskb/src/fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]: 625:1 => 
  - /scratch/kisskb/src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32' [-Wattributes]  CC [M]  net/sunrpc/auth_unix.o: 124:4 => 
  - /scratch/kisskb/src/include/linux/rbtree.h: warning: 'parent' may be used uninitialized in this function [-Wuninitialized]: 82:28 => 
  - /scratch/kisskb/src/kernel/sched/core.c: warning: control reaches end of non-void function: 2613 => 
  - /scratch/kisskb/src/kernel/trace/ftrace.c: warning: 'control_ops_free' defined but not used [-Wunused-function]: 240:13 => 
  - /scratch/kisskb/src/mm/bootmem.c: warning: control reaches end of non-void function: 379 => 
  - /scratch/kisskb/src/net/ceph/osdmap.c: warning: 'crush_do_rule_ary' uses dynamic stack allocation [enabled by default]: 1153:1 => 
  - /scratch/kisskb/src/net/core/dev.c: warning: unused variable 'null_features' [-Wunused-variable]: 2223:33 => 
  - /scratch/kisskb/src/net/sunrpc/xprtrdma/verbs.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1774:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_field_array_hash_tfm.isra.0' uses dynamic stack allocation [enabled by default]: 181:1 => 
  - /scratch/kisskb/src/sound/soc/codecs/wm8993.c: warning: unused variable 'wm8993' [-Wunused-variable]: 1562:22 => 
  - arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for ACPI_CONTAINER: 33 => 
  - arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for HOTPLUG_PCI_ACPI: 35 => 
  - warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER): N/A => 
  - warning: (PPC_CELLEB) selects HAS_TXX9_SERIAL which has unmet direct dependencies (TTY && HAS_IOMEM): N/A => 
  - warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)): N/A => 
  - warning: drivers/built-in.o(.data+0x1034): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xa68): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xb08): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xc64): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xd6c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xdcc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xe2c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xe8c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.text+0x2b4db0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x54668): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x1d8c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x3f6a4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/cris/built-in.o(.text+0x1378): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x168): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x208): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x364): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x46c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x4cc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x52c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x58c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x734): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40008): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x400a8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40204): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x4030c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4036c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x403cc): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4042c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x405d4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
