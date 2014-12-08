Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaLHKZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:25:03 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:37119 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaLHKYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:24:55 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.18
Date: Mon,  8 Dec 2014 11:24:54 +0100
Message-Id: <1418034294-17584-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.18[1] compared to v3.17[2].

Summarized:
  - build errors: +16/-15
  - build warnings: +134/-78

JFYI, when comparing v3.18[1]  to v3.18-rc7[3], the summaries are:
  - build errors: +13/-11
  - build warnings: +46/-57

Note that there may be false regressions, as the number of configs has
been increased dramatically (from 119 to 262!).
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.18.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/8168/ (262 out of 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7938/ (118 out of 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/8143/ (262 out of 119 configs)


*** ERRORS ***

16 regressions:
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.capacity’):  => 152:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.blk_config.seg_max’):  => 151:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtblk_dev_page.host_features’):  => 149:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: (near initialization for ‘virtnet_dev_page.host_features’):  => 119:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: braced-group within expression allowed only inside a function:  => 146:10, 93:10, 96:10, 116:10, 113:10
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error: initializer element is not constant:  => 151:3, 119:3, 152:3, 149:3
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfd' undeclared (first use in this function):  => 1874:29
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfs' undeclared (first use in this function):  => 1872:29
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfd' undeclared (first use in this function):  => 1928:30
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfs' undeclared (first use in this function):  => 1926:30
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit declaration of function 'do_fp_load' [-Werror=implicit-function-declaration]:  => 1872:4
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit declaration of function 'do_fp_store' [-Werror=implicit-function-declaration]:  => 1926:4
  + /home/kisskb/slave/src/arch/powerpc/xmon/xmon.c: error: implicit declaration of function 'dump_tlb_44x' [-Werror=implicit-function-declaration]:  => 912:4
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o:  => (.text+0x1ff8794), (.text+0x1ff880c), (.text+0x1ff8714), (.text+0x1ff887c), (.text+0x1ff858c), (.text+0x1ff8a24)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff8b0c)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff886c), (.text+0x1ff8580), (.text+0x1ff8b14)

15 improvements:
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_check_functionality' [-Werror=implicit-function-declaration]: 117:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_master_send' [-Werror=implicit-function-declaration]: 96:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_read_byte_data' [-Werror=implicit-function-declaration]: 28:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_read_word_data' [-Werror=implicit-function-declaration]: 64:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_write_byte_data' [-Werror=implicit-function-declaration]: 46:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_write_word_data' [-Werror=implicit-function-declaration]: 82:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_transfer' [-Werror=implicit-function-declaration]: 130:2 => 
  - /home/kisskb/slave/src/drivers/extcon/extcon-sm5502.c: error: implicit declaration of function 'i2c_add_driver' [-Werror=implicit-function-declaration]: 718:2 => 
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.__dev_kfree_skb_any' defined in .text section in net/built-in.o: (.text+0x1ff8e58) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_unlock_irqrestore' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ff9820), (.text+0x1ff9af0) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.bitrev32' defined in .text section in lib/built-in.o: (.text+0x1ff9598) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.strlcpy' defined in .text section in lib/lib.a(string.o): (.text+0x1ff8b90), (.text+0x1ff8b6c), (.text+0x1ff8bd0) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_21' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9b0c) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8ae4), (.text+0x1ff8a94) => 


*** WARNINGS ***

134 regressions:
  + /home/kisskb/slave/src/Documentation/networking/timestamping/txtimestamp.c: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 3 has type ‘int64_t’ [-Wformat=]:  => 93:3
  + /home/kisskb/slave/src/arch/arm/include/asm/atomic.h: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]:  => 194:1
  + /home/kisskb/slave/src/arch/arm/kernel/head-nommu.S: Warning: Use of r13 as a source register is deprecated when r15 is the destination register.:  => 167
  + /home/kisskb/slave/src/arch/arm/mm/cache-l2x0.c: warning: 'l2x0_cache_sync' defined but not used [-Wunused-function]:  => 168:13
  + /home/kisskb/slave/src/arch/arm/mm/cache-l2x0.c: warning: 'l2x0_disable' defined but not used [-Wunused-function]:  => 195:13
  + /home/kisskb/slave/src/arch/arm/mm/cache-l2x0.c: warning: 'l2x0_flush_all' defined but not used [-Wunused-function]:  => 185:13
  + /home/kisskb/slave/src/arch/arm/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]:  => 346:17
  + /home/kisskb/slave/src/arch/arm/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]:  => 343:10
  + /home/kisskb/slave/src/arch/s390/mm/vmem.c: warning: 'vmem_alloc_pages' defined but not used [-Wunused-function]:  => 30:20
  + /home/kisskb/slave/src/arch/sparc/include/uapi/asm/swab.h: warning: use of memory input without lvalue in asm operand 1 is deprecated [enabled by default]:  => 23:2, 34:2, 12:2
  + /home/kisskb/slave/src/drivers/ata/pata_bf54x.c: warning: 'atapi_io_port' defined but not used [-Wunused-variable]:  => 1496:23
  + /home/kisskb/slave/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2178:6
  + /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]: 590:18 => 587:17, 590:18
  + /home/kisskb/slave/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]: 590:18 => 587:17, 590:18
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat]:  => 2175:2
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat]:  => 1607:3, 926:3
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 2240:3
  + /home/kisskb/slave/src/drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function [-Wuninitialized]:  => 204:3
  + /home/kisskb/slave/src/drivers/char/xillybus/xillybus_core.c: warning: 'idt_handle.chandesc' may be used uninitialized in this function [-Wuninitialized]:  => 2023:5
  + /home/kisskb/slave/src/drivers/char/xillybus/xillybus_core.c: warning: 'idt_handle.entries' may be used uninitialized in this function [-Wuninitialized]:  => 2023:5
  + /home/kisskb/slave/src/drivers/edac/ppc4xx_edac.c: warning: initialization from incompatible pointer type [enabled by default]:  => 924:28
  + /home/kisskb/slave/src/drivers/gpio/gpio-grgpio.c: warning: 'lirq' may be used uninitialized in this function [-Wuninitialized]:  => 326:27
  + /home/kisskb/slave/src/drivers/gpu/drm/armada/armada_drv.c: warning: 'fb' may be used uninitialized in this function [-Wuninitialized]:  => 69:30
  + /home/kisskb/slave/src/drivers/gpu/drm/armada/armada_drv.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 99:6
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 466:4
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]: 838:1 => 1272:1, 945:1, 749:1
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: 'hdrlen' may be used uninitialized in this function [-Wuninitialized]:  => 349:23
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 1812:1
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_edid.c: warning: 'clock2' may be used uninitialized in this function [-Wuninitialized]:  => 2575:3
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]:  => 2808:2
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_edid_load.c: warning: 'fwdata' may be used uninitialized in this function [-Wuninitialized]:  => 205:2
  + /home/kisskb/slave/src/drivers/i2c/busses/i2c-gpio.c: warning: 'scl_pin' may be used uninitialized in this function [-Wuninitialized]:  => 172:18
  + /home/kisskb/slave/src/drivers/i2c/busses/i2c-gpio.c: warning: 'sda_pin' may be used uninitialized in this function [-Wuninitialized]:  => 150:6
  + /home/kisskb/slave/src/drivers/iio/light/lm3533-als.c: warning: 'enable' may be used uninitialized in this function [-Wuninitialized]:  => 424:2
  + /home/kisskb/slave/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1203:14, 1198:14, 1172:31, 1171:33
  + /home/kisskb/slave/src/drivers/input/keyboard/bf54x-keys.c: warning: unused variable 'pdata' [-Wunused-variable]:  => 335:34
  + /home/kisskb/slave/src/drivers/leds/leds-max8997.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 92:7
  + /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'high_plane' may be used uninitialized in this function [-Wuninitialized]:  => 371:31, 359:13
  + /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'low_plane' may be used uninitialized in this function [-Wuninitialized]:  => 359:30
  + /home/kisskb/slave/src/drivers/media/rc/st_rc.c: warning: 'st_rc_resume' defined but not used [-Wunused-function]:  => 359:12
  + /home/kisskb/slave/src/drivers/media/rc/st_rc.c: warning: 'st_rc_suspend' defined but not used [-Wunused-function]:  => 338:12
  + /home/kisskb/slave/src/drivers/media/tuners/max2165.c: warning: 'fraction' may be used uninitialized in this function [-Wuninitialized]:  => 206:11
  + /home/kisskb/slave/src/drivers/media/tuners/max2165.c: warning: 'quotient' may be used uninitialized in this function [-Wuninitialized]:  => 208:19
  + /home/kisskb/slave/src/drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]:  => 363:3
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'int' [-Wformat]:  => 465:2
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'int' [-Wformat]:  => 174:4
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type 'int' [-Wformat]:  => 174:4
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 8 has type 'int' [-Wformat]:  => 174:4
  + /home/kisskb/slave/src/drivers/mmc/host/bfin_sdh.c: warning: unused variable 'drv_data' [-Wunused-variable]:  => 642:23, 651:23
  + /home/kisskb/slave/src/drivers/mmc/host/omap_hsmmc.c: warning: 'rx_req' may be used uninitialized in this function [-Wuninitialized]:  => 2184:10
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1456 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1835:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 603:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2256 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 651:1
  + /home/kisskb/slave/src/drivers/mtd/maps/bfin-async-flash.c: warning: unused variable 'ret' [-Wunused-variable]:  => 129:6
  + /home/kisskb/slave/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 181:17, 164:17
  + /home/kisskb/slave/src/drivers/net/can/bfin_can.c: warning: unused variable 'priv' [-Wunused-variable]:  => 617:24
  + /home/kisskb/slave/src/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 243:34
  + /home/kisskb/slave/src/drivers/net/ethernet/freescale/fec_main.c: warning: unused variable 'pdata' [-Wunused-variable]:  => 1632:28
  + /home/kisskb/slave/src/drivers/net/ethernet/freescale/fec_main.c: warning: unused variable 'val' [-Wunused-variable]:  => 929:6
  + /home/kisskb/slave/src/drivers/net/wireless/ath/wil6210/fw_inc.c: warning: 'hdr_sz' may be used uninitialized in this function [-Wuninitialized]:  => 447:4
  + /home/kisskb/slave/src/drivers/net/wireless/cw1200/scan.c: warning: value computed is not used [-Wunused-value]:  => 332:2
  + /home/kisskb/slave/src/drivers/net/wireless/cw1200/sta.c: warning: value computed is not used [-Wunused-value]:  => 143:2
  + /home/kisskb/slave/src/drivers/of/platform.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 85:16
  + /home/kisskb/slave/src/drivers/regulator/s2mps11.c: warning: 'ramp_shift' may be used uninitialized in this function [-Wuninitialized]:  => 227:56
  + /home/kisskb/slave/src/drivers/scsi/osst.h: warning: 'packed' attribute ignored for field of type 'u32' [-Wattributes]  CC [M]  drivers/staging/comedi/drivers/mpc624.o:  => 96:2
  + /home/kisskb/slave/src/drivers/scsi/qla2xxx/qla_target.c: warning: 'cnt' may be used uninitialized in this function [-Wuninitialized]:  => 1504:9
  + /home/kisskb/slave/src/drivers/scsi/qla2xxx/qla_target.c: warning: 'cnt_in' may be used uninitialized in this function [-Wuninitialized]:  => 1504:9
  + /home/kisskb/slave/src/drivers/staging/comedi/drivers/dmm32at.c: warning: statement with no effect [-Wunused-value]:  => 562:3
  + /home/kisskb/slave/src/drivers/staging/goldfish/goldfish_nand.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 90:14
  + /home/kisskb/slave/src/drivers/staging/vt6655/device_main.c: warning: the frame size of 1304 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2993:1
  + /home/kisskb/slave/src/drivers/tty/goldfish.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 84:13, 62:13
  + /home/kisskb/slave/src/drivers/tty/serial/8250/8250_hp300.c: warning: #warning CONFIG_SERIAL_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure? [-Wcpp]:  => 24:2
  + /home/kisskb/slave/src/drivers/tty/serial/crisv10.c: warning: 'ser_interrupt' defined but not used [-Wunused-function]  CC      drivers/staging/iio/meter/ade7854-spi.o:  => 2506:1
  + /home/kisskb/slave/src/drivers/usb/gadget/udc/udc-xilinx.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 2135:2
  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: warning: 'bfin_remove' defined but not used [-Wunused-function]:  => 528:12
  + /home/kisskb/slave/src/drivers/usb/musb/ux500_dma.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 211:51
  + /home/kisskb/slave/src/drivers/usb/renesas_usbhs/common.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 469:25
  + /home/kisskb/slave/src/drivers/video/fbdev/bf54x-lq043fb.c: warning: unused variable 'eppi_req_18' [-Wunused-variable]:  => 272:6, 240:6
  + /home/kisskb/slave/src/drivers/video/fbdev/bf54x-lq043fb.c: warning: unused variable 'eppi_req_24' [-Wunused-variable]:  => 256:7, 279:7
  + /home/kisskb/slave/src/drivers/video/fbdev/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /home/kisskb/slave/src/fs/autofs4/waitq.c: warning: 'wq' may be used uninitialized in this function [-Wuninitialized]:  => 461:3
  + /home/kisskb/slave/src/fs/btrfs/extent_io.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 2166:13
  + /home/kisskb/slave/src/fs/mpage.c: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 310:1
  + /home/kisskb/slave/src/fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]:  => 134:23
  + /home/kisskb/slave/src/fs/overlayfs/readdir.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 314:2
  + /home/kisskb/slave/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]:  => 39:7
  + /home/kisskb/slave/src/include/linux/file.h: warning: 'output.flags' may be used uninitialized in this function [-Wuninitialized]:  => 38:2
  + /home/kisskb/slave/src/include/linux/percpu-refcount.h: warning: 'percpu_count' may be used uninitialized in this function [-Wuninitialized]:  => 188:1, 164:1, 222:1, 249:1
  + /home/kisskb/slave/src/include/linux/scatterlist.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]  CC [M]  drivers/usb/misc/usblcd.o:  => 115:2
  + /home/kisskb/slave/src/include/linux/time.h: warning: 'busy_until.tv_sec' may be used uninitialized in this function [-Wuninitialized]:  => 28:2
  + /home/kisskb/slave/src/ipc/sem.c: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]:  => 1734:11
  + /home/kisskb/slave/src/kernel/debug/debug_core.c: warning: value computed is not used [-Wunused-value]:  => 504:4, 519:5
  + /home/kisskb/slave/src/kernel/user_namespace.c: warning: 'first' may be used uninitialized in this function [-Wuninitialized]:  => 188:6, 165:6, 211:6
  + /home/kisskb/slave/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]:  => 676:14
  + /home/kisskb/slave/src/mm/memory.c: warning: 'ptep' may be used uninitialized in this function [-Wuninitialized]:  => 3508:9
  + /home/kisskb/slave/src/mm/page_isolation.c: warning: 'order' may be used uninitialized in this function [-Wuninitialized]:  => 126:15
  + /home/kisskb/slave/src/mm/percpu.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1040:3
  + /home/kisskb/slave/src/mm/slub.c: warning: '__slab_alloc.constprop.43' uses dynamic stack allocation [enabled by default]:  => 2363:1
  + /home/kisskb/slave/src/mm/vmstat.c: warning: 'frag_next' defined but not used [-Wunused-function]:  => 700:14
  + /home/kisskb/slave/src/mm/vmstat.c: warning: 'frag_start' defined but not used [-Wunused-function]:  => 688:14
  + /home/kisskb/slave/src/mm/vmstat.c: warning: 'frag_stop' defined but not used [-Wunused-function]:  => 708:13
  + /home/kisskb/slave/src/mm/vmstat.c: warning: 'walk_zones_in_node' defined but not used [-Wunused-function]:  => 713:13
  + /home/kisskb/slave/src/net/core/dev.c: warning: 'tail' may be used uninitialized in this function [-Wuninitialized]:  => 2736:15
  + /home/kisskb/slave/src/net/core/dev.c: warning: 'tail' may be used uninitialized in this function:  => 2720:39, 2720
  + /home/kisskb/slave/src/net/mac80211/mlme.c: warning: 'pwr_level_cisco' may be used uninitialized in this function [-Wuninitialized]:  => 1290:3
  + /home/kisskb/slave/src/net/rds/iw_rdma.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + /home/kisskb/slave/src/scripts/kconfig/menu.c: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 590:18
  + /home/kisskb/slave/src/security/integrity/iint.c: warning: 'iint' may be used uninitialized in this function [-Wuninitialized]:  => 35:31
  + /home/kisskb/slave/src/sound/soc/blackfin/bf5xx-ac97.c: warning: statement with no effect [-Wunused-value]:  => 181:2
  + /home/kisskb/slave/src/sound/soc/codecs/cs35l32.c: warning: 'val' is used uninitialized in this function [-Wuninitialized]:  => 314:2
  + /home/kisskb/slave/src/sound/soc/intel/sst-atom-controls.c: warning: 'sst_fill_and_send_cmd' defined but not used [-Wunused-function]:  => 70:12
  + /home/kisskb/slave/src/sound/soc/intel/sst-mfld-platform-pcm.c: warning: 'sst_media_dai_ops' defined but not used [-Wunused-variable]:  => 454:31
  + <stdin>: warning: #warning syscall bpf not implemented [-Wcpp]:  => 1247:2
  + <stdin>: warning: #warning syscall bpf not implemented:  => 1247:2
  + arch/blackfin/configs/BF527-EZKIT_defconfig: warning: override: MUSB_PIO_ONLY changes choice state:  => 150
  + arch/blackfin/configs/BF527-EZKIT_defconfig: warning: override: reassigning to symbol MUSB_PIO_ONLY:  => 150
  + warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && MFD_TIMBERDALE):  => N/A
  + warning: 1 bad relocations:  => N/A
  + warning: drivers/built-in.o(.text+0x2e7e58): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x56e4c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d38): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x43f1c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1340): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/ethernet/3com/3c59x.o(.data+0xe4): Section mismatch in reference from the variable vortex_eisa_driver to the function .init.text:vortex_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/dec/tulip/de4x5.o(.data+0xd8): Section mismatch in reference from the variable de4x5_eisa_driver to the function .init.text:de4x5_eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41650): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x416f0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x41854): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x41964): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x419c4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41a24): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41a8c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41c5c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.text+0x8a6c7): Section mismatch in reference from the function intel_scu_devices_create() to the function .init.text:i2c_register_board_info():  => N/A

78 improvements:
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
  - /home/kisskb/slave/src/drivers/staging/rtl8712/rtl871x_ioctl_linux.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]: 1873:15, 1855:9 => 
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
  - /home/kisskb/slave/src/sound/isa/sb/emu8000_patch.c: warning: 'cc' may be used uninitialized in this function [-Wuninitialized]: 91:5, 98:7 => 
  - /home/kisskb/slave/src/sound/soc/codecs/mc13783.c: warning: 'np' may be used uninitialized in this function [-Wuninitialized]: 787:13 => 
  - /home/kisskb/slave/src/sound/soc/codecs/rt286.c: warning: 'rt286_index_sync' defined but not used [-Wunused-function]: 272:13 => 
  - /home/kisskb/slave/src/sound/soc/codecs/tas2552.c: warning: 'tas2552_sw_shutdown' defined but not used [-Wunused-function]: 81:13 => 
  - /home/kisskb/slave/src/sound/soc/fsl/fsl_sai.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 337:7 => 
  - /home/kisskb/slave/src/sound/soc/s6000/s6000-i2s.c: warning: unused variable 'mmio' [-Wunused-variable]: 577:16 => 
  - arch/powerpc/configs/mpc85xx_defconfig: warning: override: reassigning to symbol RTC_DRV_DS1307: 216 => 
  - warning: (PPC_CELLEB) selects HAS_TXX9_SERIAL which has unmet direct dependencies (TTY && HAS_IOMEM): N/A => 
  - warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
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
