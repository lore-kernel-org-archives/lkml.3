Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbaJUSKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:10:44 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:50454 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbaJUSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:10:41 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.18-rc1
Date: Tue, 21 Oct 2014 20:10:46 +0200
Message-Id: <1413915046-32485-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.18-rc1[1] compared to v3.17[2].

Summarized:
  - build errors: +21/-15
  - build warnings: +106/-57

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.18-rc1.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/8002/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7938/ (118 out of 119 configs)


*** ERRORS ***

21 regressions:
  + /scratch/kisskb/src/arch/powerpc/kernel/cacheinfo.c: error: 'size_kb' may be used uninitialized in this function [-Werror=uninitialized]:  => 525:2
  + /scratch/kisskb/src/arch/powerpc/lib/rheap.c: error: 'be' may be used uninitialized in this function [-Werror=uninitialized]:  => 417:2
  + /scratch/kisskb/src/arch/powerpc/lib/rheap.c: error: 'bs' may be used uninitialized in this function [-Werror=uninitialized]:  => 424:17
  + /scratch/kisskb/src/arch/powerpc/lib/rheap.c: error: 'start' may be used uninitialized in this function [-Werror=uninitialized]:  => 497:22
  + /scratch/kisskb/src/arch/powerpc/lib/sstep.c: error: 'do_lfd' undeclared (first use in this function):  => 1874:29
  + /scratch/kisskb/src/arch/powerpc/lib/sstep.c: error: 'do_lfs' undeclared (first use in this function):  => 1872:29
  + /scratch/kisskb/src/arch/powerpc/lib/sstep.c: error: 'do_stfd' undeclared (first use in this function):  => 1928:30
  + /scratch/kisskb/src/arch/powerpc/lib/sstep.c: error: 'do_stfs' undeclared (first use in this function):  => 1926:30
  + /scratch/kisskb/src/arch/powerpc/lib/sstep.c: error: implicit declaration of function 'do_fp_load' [-Werror=implicit-function-declaration]:  => 1872:4
  + /scratch/kisskb/src/arch/powerpc/lib/sstep.c: error: implicit declaration of function 'do_fp_store' [-Werror=implicit-function-declaration]:  => 1926:4
  + /scratch/kisskb/src/arch/powerpc/xmon/xmon.c: error: unused variable 'badaddr' [-Werror=unused-variable]:  => 1141:13
  + /scratch/kisskb/src/arch/powerpc/xmon/xmon.c: error: unused variable 'mode' [-Werror=unused-variable]:  => 1139:6
  + /scratch/kisskb/src/drivers/bcma/main.c: error: implicit declaration of function 'of_translate_address' [-Werror=implicit-function-declaration]:  => 150:3
  + error: No rule to make target /etc/sound/trxpro.hex:  => N/A
  + error: icm.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.__alloc_pages_nodemask' defined in .text section in mm/built-in.o:  => (.text+0x1ff8d64)
  + error: icm.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.alloc_pages_current' defined in .text section in mm/built-in.o:  => (.text+0x1ff8d94)
  + error: icm.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8a54), (.text+0x1ff8cb4)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.kmem_cache_alloc_trace' defined in .text section in mm/built-in.o:  => (.text+0x1ff9630), (.text+0x1ff94e4)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.sg_init_table' defined in .text section in lib/built-in.o:  => (.text+0x1ff9698)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `.sg_next' defined in .text section in lib/built-in.o:  => (.text+0x1ff9a4c), (.text+0x1ff9874)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_16' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8478)

15 improvements:
  - /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_check_functionality' [-Werror=implicit-function-declaration]: 117:2 => 
  - /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_master_send' [-Werror=implicit-function-declaration]: 96:2 => 
  - /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_read_byte_data' [-Werror=implicit-function-declaration]: 28:2 => 
  - /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_read_word_data' [-Werror=implicit-function-declaration]: 64:2 => 
  - /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_write_byte_data' [-Werror=implicit-function-declaration]: 46:2 => 
  - /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_write_word_data' [-Werror=implicit-function-declaration]: 82:2 => 
  - /scratch/kisskb/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_transfer' [-Werror=implicit-function-declaration]: 130:2 => 
  - /scratch/kisskb/src/drivers/extcon/extcon-sm5502.c: error: implicit declaration of function 'i2c_add_driver' [-Werror=implicit-function-declaration]: 718:2 => 
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.__dev_kfree_skb_any' defined in .text section in net/built-in.o: (.text+0x1ff8e58) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_unlock_irqrestore' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ff9af0), (.text+0x1ff9820) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.bitrev32' defined in .text section in lib/built-in.o: (.text+0x1ff9598) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.strlcpy' defined in .text section in lib/lib.a(string.o): (.text+0x1ff8b90), (.text+0x1ff8bd0), (.text+0x1ff8b6c) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_21' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9b0c) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8a94), (.text+0x1ff8ae4) => 


*** WARNINGS ***

106 regressions:
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2178:6
  + /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat]:  => 2175:2
  + /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat]:  => 1607:3, 926:3
  + /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 2240:3
  + /scratch/kisskb/src/drivers/crypto/caam/ctrl.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 214:3
  + /scratch/kisskb/src/drivers/gpio/gpio-dwapb.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 540:6
  + /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 466:4
  + /scratch/kisskb/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]: 838:1 => 945:1, 1272:1, 749:1
  + /scratch/kisskb/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: 'hdrlen' may be used uninitialized in this function [-Wuninitialized]:  => 349:23
  + /scratch/kisskb/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 1812:1
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'clock2' may be used uninitialized in this function [-Wuninitialized]:  => 2575:3
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]:  => 3000:30
  + /scratch/kisskb/src/drivers/gpu/drm/ttm/ttm_bo.c: warning: 'mem_type' may be used uninitialized in this function [-Wuninitialized]:  => 72:37
  + /scratch/kisskb/src/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c: warning: 'res' may be used uninitialized in this function [-Wuninitialized]:  => 456:2
  + /scratch/kisskb/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1171:33, 1203:14, 1172:31, 1198:14
  + /scratch/kisskb/src/drivers/input/keyboard/tca8418_keypad.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]:  => 172:9
  + /scratch/kisskb/src/drivers/media/pci/pt3/pt3_i2c.c: warning: 'v' may be used uninitialized in this function [-Wuninitialized]:  => 150:11
  + /scratch/kisskb/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'high_plane' may be used uninitialized in this function [-Wuninitialized]:  => 359:13, 371:31
  + /scratch/kisskb/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'low_plane' may be used uninitialized in this function [-Wuninitialized]:  => 359:30
  + /scratch/kisskb/src/drivers/media/platform/exynos4-is/fimc-core.c: warning: 'fimc_m2m_resume' defined but not used [-Wunused-function]:  => 857:12
  + /scratch/kisskb/src/drivers/media/platform/exynos4-is/fimc-core.c: warning: 'fimc_m2m_suspend' defined but not used [-Wunused-function]:  => 835:12
  + /scratch/kisskb/src/drivers/media/platform/s5p-jpeg/jpeg-core.c: warning: 'components' may be used uninitialized in this function [-Wuninitialized]:  => 965:15
  + /scratch/kisskb/src/drivers/media/platform/s5p-jpeg/jpeg-core.c: warning: 's5p_jpeg_resume' defined but not used [-Wunused-function]:  => 2693:12
  + /scratch/kisskb/src/drivers/media/platform/s5p-jpeg/jpeg-core.c: warning: 's5p_jpeg_suspend' defined but not used [-Wunused-function]:  => 2685:12
  + /scratch/kisskb/src/drivers/media/rc/ir-hix5hd2.c: warning: 'hix5hd2_ir_resume' defined but not used [-Wunused-function]:  => 311:12
  + /scratch/kisskb/src/drivers/media/rc/ir-hix5hd2.c: warning: 'hix5hd2_ir_suspend' defined but not used [-Wunused-function]:  => 301:12
  + /scratch/kisskb/src/drivers/media/rc/st_rc.c: warning: 'st_rc_resume' defined but not used [-Wunused-function]:  => 359:12
  + /scratch/kisskb/src/drivers/media/rc/st_rc.c: warning: 'st_rc_suspend' defined but not used [-Wunused-function]:  => 338:12
  + /scratch/kisskb/src/drivers/media/tuners/max2165.c: warning: 'fraction' may be used uninitialized in this function [-Wuninitialized]:  => 206:11
  + /scratch/kisskb/src/drivers/media/tuners/max2165.c: warning: 'quotient' may be used uninitialized in this function [-Wuninitialized]:  => 208:19
  + /scratch/kisskb/src/drivers/media/usb/em28xx/em28xx-core.c: warning: 'vid' may be used uninitialized in this function [-Wuninitialized]:  => 598:3
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2256 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 651:1
  + /scratch/kisskb/src/drivers/mtd/devices/phram.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 264:8
  + /scratch/kisskb/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 181:17, 164:17
  + /scratch/kisskb/src/drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 407:9
  + /scratch/kisskb/src/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 130:29, 245:34, 130:21
  + /scratch/kisskb/src/drivers/net/wireless/ath/wil6210/fw_inc.c: warning: 'hdr_sz' may be used uninitialized in this function [-Wuninitialized]:  => 447:4
  + /scratch/kisskb/src/drivers/net/wireless/cw1200/scan.c: warning: value computed is not used [-Wunused-value]:  => 332:2
  + /scratch/kisskb/src/drivers/net/wireless/cw1200/sta.c: warning: value computed is not used [-Wunused-value]:  => 143:2
  + /scratch/kisskb/src/drivers/of/platform.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 85:16
  + /scratch/kisskb/src/drivers/pci/quirks.c: warning: 'host_bridge' may be used uninitialized in this function [-Wuninitialized]:  => 2446:2
  + /scratch/kisskb/src/drivers/regulator/max8925-regulator.c: warning: 'regulator_idx' may be used uninitialized in this function [-Wuninitialized]:  => 309:2
  + /scratch/kisskb/src/drivers/regulator/max8925-regulator.c: warning: 'ri' may be used uninitialized in this function [-Wuninitialized]:  => 313:45
  + /scratch/kisskb/src/drivers/regulator/s2mpa01.c: warning: 'ramp_shift' may be used uninitialized in this function [-Wuninitialized]:  => 207:56
  + /scratch/kisskb/src/drivers/regulator/s2mps11.c: warning: 'ramp_shift' may be used uninitialized in this function [-Wuninitialized]:  => 227:56
  + /scratch/kisskb/src/drivers/regulator/s5m8767.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 207:29
  + /scratch/kisskb/src/drivers/s390/kvm/virtio_ccw.c: warning: unused variable 'drv' [-Wunused-variable]:  => 891:24
  + /scratch/kisskb/src/drivers/scsi/qla2xxx/qla_target.c: warning: 'cnt' may be used uninitialized in this function [-Wuninitialized]:  => 1502:9
  + /scratch/kisskb/src/drivers/scsi/qla2xxx/qla_target.c: warning: 'cnt_in' may be used uninitialized in this function [-Wuninitialized]:  => 1502:9
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/dmm32at.c: warning: statement with no effect [-Wunused-value]:  => 562:3
  + /scratch/kisskb/src/drivers/thunderbolt/ctl.c: warning: 'pkg' may be used uninitialized in this function [-Wuninitialized]:  => 460:18
  + /scratch/kisskb/src/drivers/tty/serial/8250/8250_hp300.c: warning: #warning CONFIG_SERIAL_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure? [-Wcpp]:  => 24:2
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 269:6
  + /scratch/kisskb/src/drivers/usb/gadget/udc/udc-xilinx.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 2135:2
  + /scratch/kisskb/src/drivers/usb/musb/ux500_dma.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 211:51
  + /scratch/kisskb/src/drivers/usb/renesas_usbhs/common.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 469:25
  + /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 599:32, 625:11, 443:16, 569:10
  + /scratch/kisskb/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 811:11, 785:32, 564:16
  + /scratch/kisskb/src/drivers/video/backlight/ld9040.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 575:2
  + /scratch/kisskb/src/drivers/video/fbdev/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /scratch/kisskb/src/drivers/video/fbdev/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]:  => 64:2
  + /scratch/kisskb/src/drivers/video/fbdev/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]:  => 65:2
  + /scratch/kisskb/src/drivers/video/fbdev/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]:  => 4127:13
  + /scratch/kisskb/src/fs/btrfs/extent_io.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 2166:13
  + /scratch/kisskb/src/fs/exofs/common.h: warning: 'packed' attribute ignored for field of type 'struct exofs_layout_sliding_window' [-Wattributes]  LD      sound/pci/ice1712/built-in.o:  => 243:3
  + /scratch/kisskb/src/fs/mpage.c: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 310:1
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]:  => 39:7
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.flags' may be used uninitialized in this function [-Wuninitialized]:  => 38:2
  + /scratch/kisskb/src/include/linux/pci.h: warning: 'ctrl_pos2' may be used uninitialized in this function [-Wuninitialized]:  => 884:2
  + /scratch/kisskb/src/include/linux/percpu-refcount.h: warning: 'percpu_count' may be used uninitialized in this function [-Wuninitialized]:  => 158:1, 182:1, 216:1, 243:1
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 349:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 349:2
  + /scratch/kisskb/src/kernel/debug/debug_core.c: warning: value computed is not used [-Wunused-value]:  => 504:4, 519:5
  + /scratch/kisskb/src/kernel/futex.c: warning: 'entry' may be used uninitialized in this function [-Wuninitialized]:  => 2887:3
  + /scratch/kisskb/src/kernel/futex.c: warning: 'pending' may be used uninitialized in this function [-Wuninitialized]:  => 2904:2
  + /scratch/kisskb/src/kernel/futex.c: warning: 'pip' may be used uninitialized in this function [-Wuninitialized]:  => 2905:21
  + /scratch/kisskb/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 742:2
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 1006:15
  + /scratch/kisskb/src/mm/slub.c: warning: '__slab_alloc.constprop.43' uses dynamic stack allocation [enabled by default]:  => 2363:1
  + /scratch/kisskb/src/net/core/dev.c: warning: 'tail' may be used uninitialized in this function [-Wuninitialized]:  => 2736:15
  + /scratch/kisskb/src/net/core/dev.c: warning: 'tail' may be used uninitialized in this function:  => 2720, 2720:39
  + /scratch/kisskb/src/net/mac80211/mlme.c: warning: 'pwr_level_cisco' may be used uninitialized in this function [-Wuninitialized]:  => 1289:3
  + /scratch/kisskb/src/sound/drivers/mpu401/mpu401_uart.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 290:6, 312:6
  + /scratch/kisskb/src/sound/firewire/amdtp.c: warning: 'data_blocks' may be used uninitialized in this function [-Wuninitialized]:  => 724:22
  + /scratch/kisskb/src/sound/firewire/bebob/bebob_focusrite.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 175:14
  + /scratch/kisskb/src/sound/soc/codecs/cs35l32.c: warning: 'val' is used uninitialized in this function [-Wuninitialized]:  => 314:2
  + /scratch/kisskb/src/sound/soc/codecs/cs35l32.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 314:2
  + <stdin>: warning: #warning syscall bpf not implemented [-Wcpp]:  => 1247:2
  + <stdin>: warning: #warning syscall bpf not implemented:  => 1247:2
  + modpost: WARNING: modpost: Found 4 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 5 section mismatch(es).:  => N/A
  + warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && MFD_TIMBERDALE):  => N/A
  + warning: 1 bad relocations:  => N/A
  + warning: drivers/built-in.o(.text+0x2e634c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x56d68): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d38): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x43bd4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1340): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x41330): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x413d0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x41534): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x41644): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x416a4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41704): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4176c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x4193c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

57 improvements:
  - /scratch/kisskb/src/arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]: 63:2 => 
  - /scratch/kisskb/src/arch/x86/kernel/cpu/common.c: warning: 'syscall32_cpu_init' defined but not used [-Wunused-function]: 968:13 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]: 194:13 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]: 177:13 => 
  - /scratch/kisskb/src/drivers/memstick/host/r592.c: warning: 'r592_clear_interrupts' defined but not used [-Wunused-function]: 192:13 => 
  - /scratch/kisskb/src/drivers/mfd/88pm860x-i2c.c: warning: 'write_device' uses dynamic stack allocation [enabled by default]: 141:1 => 
  - /scratch/kisskb/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_resume' defined but not used [-Wunused-function]: 127:12 => 
  - /scratch/kisskb/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_suspend' defined but not used [-Wunused-function]: 118:12 => 
  - /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_bulk_write' uses dynamic stack allocation [enabled by default]: 108:1 => 
  - /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_reg_write' uses dynamic stack allocation [enabled by default]: 80:1 => 
  - /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_set_bits' uses dynamic stack allocation [enabled by default]: 128:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:213) [-Wdeprecated-declarations]: 624:3 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/genet/bcmgenet.c: warning: 'bcmgenet_wol_resume' defined but not used [-Wunused-function]: 2020:12 => 
  - /scratch/kisskb/src/drivers/nfc/trf7970a.c: warning: 'trf7970a_init' defined but not used [-Wunused-function]: 754:12 => 
  - /scratch/kisskb/src/drivers/scsi/cxgbi/libcxgbi.c: warning: 'cxgbi_device_find_by_mac' defined but not used [-Wunused-function]: 278:29 => 
  - /scratch/kisskb/src/drivers/spi/spi-omap-100k.c: warning: "READ" redefined [enabled by default]: 74:0 => 
  - /scratch/kisskb/src/drivers/spi/spi-omap-100k.c: warning: "WRITE" redefined [enabled by default]: 73:0 => 
  - /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 572:1 => 
  - /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 572:1 => 
  - /scratch/kisskb/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 2 has type 'sk_buff_data_t' [-Wformat]: 885:5 => 
  - /scratch/kisskb/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 3 has type 'sk_buff_data_t' [-Wformat]: 885:5 => 
  - /scratch/kisskb/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%d' expects argument of type 'int', but argument 5 has type 'u64' [-Wformat]: 749:2, 1151:5 => 
  - /scratch/kisskb/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%d' expects argument of type 'int', but argument 7 has type 'u64' [-Wformat]: 1142:4 => 
  - /scratch/kisskb/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'u64' [-Wformat]: 520:2 => 
  - /scratch/kisskb/src/drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 1068 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 792:1 => 
  - /scratch/kisskb/src/drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 792:1 => 
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_hp300.c: warning: #warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure? [-Wcpp]: 24:2 => 
  - /scratch/kisskb/src/drivers/usb/gadget/function/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function [-Wuninitialized]: 2356:47 => 
  - /scratch/kisskb/src/fs/mpage.c: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 308:1 => 
  - /scratch/kisskb/src/include/linux/mtd/cfi.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]  CC      drivers/sh/pm_runtime.o: 489:3 => 
  - /scratch/kisskb/src/kernel/acct.c: warning: unused variable 'ns' [-Wunused-variable]: 475:24 => 
  - /scratch/kisskb/src/kernel/acct.c: warning: unused variable 'ns': 475 => 
  - /scratch/kisskb/src/mm/slab_common.c: warning: 's' may be used uninitialized in this function [-Wuninitialized]: 204:21 => 
  - /scratch/kisskb/src/mm/slub.c: warning: '__slab_alloc.constprop.44' uses dynamic stack allocation [enabled by default]: 2361:1 => 
  - /scratch/kisskb/src/sound/soc/codecs/mc13783.c: warning: 'np' may be used uninitialized in this function [-Wuninitialized]: 787:13 => 
  - /scratch/kisskb/src/sound/soc/codecs/rt286.c: warning: 'rt286_index_sync' defined but not used [-Wunused-function]: 272:13 => 
  - /scratch/kisskb/src/sound/soc/codecs/tas2552.c: warning: 'tas2552_sw_shutdown' defined but not used [-Wunused-function]: 81:13 => 
  - /scratch/kisskb/src/sound/soc/fsl/fsl_sai.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 337:7 => 
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
