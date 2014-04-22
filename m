Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaDVH36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:29:58 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:51339 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaDVH3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:29:53 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.15-rc2
Date: Tue, 22 Apr 2014 09:29:51 +0200
Message-Id: <1398151791-24689-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.15-rc2[1] compared to v3.14[2].

Summarized:
  - build errors: +10/-3
  - build warnings: +148/-108

JFYI, when comparing v3.15-rc2[1]  to v3.15-rc1[3], the summaries are:
  - build errors: +4/-24
  - build warnings: +79/-45

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.15-rc2.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7401/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7320/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7375/ (all 119 configs)


*** ERRORS ***

10 regressions:
  + /scratch/kisskb/src/drivers/cpufreq/powernv-cpufreq.c: error: implicit declaration of function 'cpu_sibling_mask' [-Werror=implicit-function-declaration]:  => 241:2
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]:  => 1102:4
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 1130:3
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 1097:4
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_set_value' [-Werror=implicit-function-declaration]:  => 169:3
  + error: "__invalidate_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A
  + error: No rule to make target /etc/sound/dsp001.ld:  => N/A
  + error: No rule to make target /etc/sound/msndinit.bin:  => N/A
  + error: No rule to make target /etc/sound/msndperm.bin:  => N/A
  + error: No rule to make target /etc/sound/trxpro.hex:  => N/A

3 improvements:
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: initramfs.c: undefined reference to `__stack_chk_guard': .init.text+0x1067) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+bc8: (.text+0x9c2) => 


*** WARNINGS ***

148 regressions:
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 376 => 383, 380
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 376 => 383, 380
  + /scratch/kisskb/src/arch/sh/math-emu/math.c: warning: 'ieee_fpe_handler' defined but not used [-Wunused-function]:  => 505:12
  + /scratch/kisskb/src/arch/x86/crypto/sha1_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 50:1
  + /scratch/kisskb/src/arch/x86/crypto/sha256_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 56:1
  + /scratch/kisskb/src/arch/x86/crypto/sha512_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 55:1
  + /scratch/kisskb/src/arch/x86/kernel/cpu/perf_event.c: warning: 'reg_fail' may be used uninitialized in this function [-Wuninitialized]:  => 236:9
  + /scratch/kisskb/src/arch/x86/kernel/cpu/perf_event.c: warning: 'val_fail' may be used uninitialized in this function [-Wuninitialized]:  => 236:9
  + /scratch/kisskb/src/arch/x86/kernel/machine_kexec_32.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 191:12
  + /scratch/kisskb/src/arch/x86/kernel/syscall_32.c: warning: 'externally_visible' attribute ignored [-Wattributes]:  => 14:1
  + /scratch/kisskb/src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 74:2
  + /scratch/kisskb/src/drivers/atm/ambassador.c: warning: 'fw' may be used uninitialized in this function [-Wuninitialized]:  => 1969:19
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2024:6
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'this_page' may be used uninitialized in this function [-Wuninitialized]:  => 1683:4
  + /scratch/kisskb/src/drivers/char/random.c: warning: 'arch_random_refill' uses dynamic stack allocation [enabled by default]:  => 1326:1
  + /scratch/kisskb/src/drivers/cpufreq/powernv-cpufreq.c: warning: passing argument 1 of 'smp_call_function_any' makes pointer from integer without a cast [enabled by default]:  => 242:4
  + /scratch/kisskb/src/drivers/edac/mpc85xx_edac.c: warning: unused variable 'pvr' [-Wunused-variable]:  => 1234:6
  + /scratch/kisskb/src/drivers/gpio/gpio-bcm-kona.c: warning: 'res' may be used uninitialized in this function [-Wuninitialized]:  => 298:12
  + /scratch/kisskb/src/drivers/gpu/drm/bochs/bochs_drv.c: warning: 'bochs_pm_resume' defined but not used [-Wunused-function]:  => 117:12
  + /scratch/kisskb/src/drivers/gpu/drm/bochs/bochs_drv.c: warning: 'bochs_pm_suspend' defined but not used [-Wunused-function]:  => 100:12
  + /scratch/kisskb/src/drivers/gpu/drm/cirrus/cirrus_drv.c: warning: 'cirrus_pm_resume' defined but not used [-Wunused-function]:  => 96:12
  + /scratch/kisskb/src/drivers/gpu/drm/cirrus/cirrus_drv.c: warning: 'cirrus_pm_suspend' defined but not used [-Wunused-function]:  => 79:12
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_cmd_parser.c: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]:  => 405:4
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/r100.c: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]:  => 3577:47
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/r100.c: warning: 'disp_drain_rate.full' may be used uninitialized in this function [-Wuninitialized]:  => 3576:42
  + /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/cq.c: warning: 'hw_cqe' may be used uninitialized in this function [-Wuninitialized]:  => 307:33, 303:21
  + /scratch/kisskb/src/drivers/infiniband/hw/ehca/ehca_mrmw.c: warning: 'prev_pgaddr' may be used uninitialized in this function [-Wuninitialized]:  => 1907:6
  + /scratch/kisskb/src/drivers/input/misc/max8997_haptic.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 185:19
  + /scratch/kisskb/src/drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 128:11, 420:15
  + /scratch/kisskb/src/drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 96:11, 102:2, 144:15, 142:20
  + /scratch/kisskb/src/drivers/net/bonding/bond_netlink.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 118:6
  + /scratch/kisskb/src/drivers/net/wireless/libertas/if_spi.c: warning: 'hiStatus' may be used uninitialized in this function [-Wuninitialized]:  => 886:2
  + /scratch/kisskb/src/drivers/net/wireless/libertas/if_spi.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 730:20, 574:7, 780:55
  + /scratch/kisskb/src/drivers/net/wireless/libertas/if_spi.c: warning: 'rval' may be used uninitialized in this function [-Wuninitialized]:  => 409:2
  + /scratch/kisskb/src/drivers/net/wireless/libertas/if_spi.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 303:4
  + /scratch/kisskb/src/drivers/net/wireless/rtlwifi/rtl8723be/phy.c: warning: 'txpower' may be used uninitialized in this function [-Wuninitialized]:  => 1001:11
  + /scratch/kisskb/src/drivers/net/wireless/ti/wlcore/scan.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 386:15
  + /scratch/kisskb/src/drivers/net/wireless/ti/wlcore/spi.c: warning: the frame size of 1168 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 317:1
  + /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'phys_addr_t' [-Wformat]:  => 1006:2
  + /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]:  => 1006:2
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'chg_end_current' may be used uninitialized in this function [-Wuninitialized]:  => 266:4
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 213:17, 184:21, 200:21, 160:21, 144:20, 172:12, 115:16
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 133:2
  + /scratch/kisskb/src/drivers/regulator/pbias-regulator.c: warning: 'vmode' may be used uninitialized in this function [-Wuninitialized]:  => 60:26
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]:  => 6628:5
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'trans_support' may be used uninitialized in this function [-Wuninitialized]:  => 7467:20
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
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.h: warning: "IO_FIELD" redefined [enabled by default]:  => 447:0
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 583:1
  + /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'invalid_cmd_field' defined but not used [-Wunused-variable]:  => 651:11
  + /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'media_not_present' defined but not used [-Wunused-variable]:  => 649:11
  + /scratch/kisskb/src/drivers/staging/silicom/bpctl_mod.c: warning: 'bp_proc_create' defined but not used [-Wunused-function]:  => 6786:12
  + /scratch/kisskb/src/drivers/staging/usbip/stub_dev.c: warning: 'stub_table' defined but not used [-Wunused-variable]:  => 33:29
  + /scratch/kisskb/src/drivers/staging/wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_off' which is not static [enabled by default]:  => 1035:2
  + /scratch/kisskb/src/drivers/staging/wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_on' which is not static [enabled by default]:  => 1023:2
  + /scratch/kisskb/src/drivers/staging/wlags49_h25/../wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_off' which is not static [enabled by default]:  => 1035:2
  + /scratch/kisskb/src/drivers/staging/wlags49_h25/../wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_on' which is not static [enabled by default]:  => 1023:2
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 349:9
  + /scratch/kisskb/src/drivers/video/fbdev/amifb.c: warning: 'amifb_setup' defined but not used [-Wunused-function]:  => 2346:19
  + /scratch/kisskb/src/drivers/video/fbdev/auo_k190x.c: warning: 'auok190x_resume' defined but not used [-Wunused-function]:  => 899:12
  + /scratch/kisskb/src/drivers/video/fbdev/auo_k190x.c: warning: 'auok190x_suspend' defined but not used [-Wunused-function]:  => 859:12
  + /scratch/kisskb/src/drivers/video/fbdev/goldfishfb.c: warning: 'fbpaddr' may be used uninitialized in this function [-Wuninitialized]:  => 256:24
  + /scratch/kisskb/src/drivers/video/fbdev/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /scratch/kisskb/src/drivers/video/fbdev/valkyriefb.c: warning: unused variable 'i' [-Wunused-variable]:  => 267:6
  + /scratch/kisskb/src/drivers/video/fbdev/valkyriefb.c: warning: unused variable 'req' [-Wunused-variable]:  => 266:21
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1347:23
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]:  => 1343:38
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1348:18
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'eb' may be used uninitialized in this function [-Wuninitialized]:  => 150:25
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'offset' may be used uninitialized in this function [-Wuninitialized]:  => 149:21
  + /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]:  => 58:13
  + /scratch/kisskb/src/fs/ext4/extents_status.c: warning: integer constant is too large for 'long' type:  => 813
  + /scratch/kisskb/src/fs/f2fs/checkpoint.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 89:1
  + /scratch/kisskb/src/fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]:  => 909:21, 664:17
  + /scratch/kisskb/src/fs/xfs/./xfs_trace.h: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 6 has type 'xfs_fsblock_t' [-Wformat]:  => 654:1
  + /scratch/kisskb/src/fs/xfs/xfs_qm_syscalls.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 281:7
  + /scratch/kisskb/src/include/drm/drm_fixed.h: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]:  => 64:13
  + /scratch/kisskb/src/include/linux/ceph/osdmap.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 54:1
  + /scratch/kisskb/src/include/linux/etherdevice.h: warning: '*((void *)&tmp_mac+4)' may be used uninitialized in this function [-Wuninitialized]:  => 231:20
  + /scratch/kisskb/src/include/linux/etherdevice.h: warning: 'tmp_mac' may be used uninitialized in this function [-Wuninitialized]:  => 230:14
  + /scratch/kisskb/src/include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 644:13
  + /scratch/kisskb/src/include/linux/pagemap.h: warning: 'blk_addr' may be used uninitialized in this function [-Wuninitialized]:  => 287:2
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]:  => 1609:13
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function:  => 1486
  + /scratch/kisskb/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 736:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]:  => 70:2, 73:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]:  => 45:2, 49:4, 56:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]:  => 113:2, 116:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]:  => 92:4, 99:2, 88:2
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 944:15
  + /scratch/kisskb/src/mm/slab_common.c: warning: 's' may be used uninitialized in this function [-Wuninitialized]:  => 203:21
  + /scratch/kisskb/src/mm/swapfile.c: warning: 'nr_extents' may be used uninitialized in this function [-Wuninitialized]:  => 2269:6
  + /scratch/kisskb/src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 209:2
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]:  => 656:16
  + /scratch/kisskb/src/net/mac80211/tx.c: warning: 'chanctx_conf' may be used uninitialized in this function [-Wuninitialized]: 1872:27 => 1868:27, 1860:3
  + /scratch/kisskb/src/net/rxrpc/ar-connection.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 593:16
  + /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_field_array_hash_tfm' uses dynamic stack allocation [enabled by default]:  => 194:1
  + /scratch/kisskb/src/sound/pci/pcxhr/pcxhr_core.c: warning: 'new_sample_count' may be used uninitialized in this function [-Wuninitialized]:  => 1204:4
  + /scratch/kisskb/src/sound/soc/codecs/adau1977.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 971:3
  + /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_resume' defined but not used [-Wunused-function]:  => 545:12
  + /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_suspend' defined but not used [-Wunused-function]:  => 520:12
  + <stdin>: warning: #warning syscall renameat2 not implemented [-Wcpp]:  => 1232:2
  + <stdin>: warning: #warning syscall renameat2 not implemented:  => 1232:2
  + warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST)):  => N/A
  + warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet direct dependencies (!CPU_LITTLE_ENDIAN):  => N/A
  + warning: drivers/built-in.o(.data+0x107c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa70): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb10): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc74): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd84): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xde4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe44): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xeac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x2c21f4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x51200): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
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

108 improvements:
  - /scratch/kisskb/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 573:1 => 
  - /scratch/kisskb/src/drivers/base/topology.c: warning: unused variable 'cpu' [-Wunused-variable]: 86:1, 83:1 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_resume' defined but not used [-Wunused-function]: 2550:12 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_suspend' defined but not used [-Wunused-function]: 2541:12 => 
  - /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio': 204 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-designware-pcidrv.c: warning: 'i2c_dw_pci_runtime_idle' defined but not used [-Wunused-function]: 188:12 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]: 120:41 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]: 120:57 => 
  - /scratch/kisskb/src/drivers/md/bcache/bset.c: warning: format '%li' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat]: 27:10 => 
  - /scratch/kisskb/src/drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]: 1105:1 => 
  - /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 190:10 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2.c: warning: 'bnx2_resume' defined but not used [-Wunused-function]: 8655:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2.c: warning: 'bnx2_suspend' defined but not used [-Wunused-function]: 8635:1 => 
  - /scratch/kisskb/src/drivers/net/wireless/iwlwifi/mvm/nvm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 471:6 => 
  - /scratch/kisskb/src/drivers/platform/x86/acer-wmi.c: warning: 'acer_resume' defined but not used [-Wunused-function]: 2060:12 => 
  - /scratch/kisskb/src/drivers/platform/x86/acer-wmi.c: warning: 'acer_suspend' defined but not used [-Wunused-function]: 2038:12 => 
  - /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]: 1246:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]: 1246:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: warning: 'cr_width' may be used uninitialized in this function [-Wuninitialized]: 698:6 => 
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
  - /scratch/kisskb/src/drivers/staging/line6/midi.c: warning: 'line6_midi_transmit' uses dynamic stack allocation [enabled by default]: 76:1 => 
  - /scratch/kisskb/src/drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'sm7xx_vga_setup' defined but not used [-Wunused-function]: 117:19 => 
  - /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]: 773:18 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'data_len' may be used uninitialized in this function [-Wuninitialized]: 670:17 => 
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
