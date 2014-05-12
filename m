Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaELJsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:48:14 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:59307 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaELJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:48:09 -0400
Date: Mon, 12 May 2014 11:48:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.15-rc5
Message-ID: <alpine.DEB.2.02.1405121147480.29403@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.15-rc5[1] compared to v3.14[2].

Summarized:
  - build errors: +7/-2
  - build warnings: +115/-113

JFYI, when comparing v3.15-rc5[1]  to v3.15-rc4[3], the summaries are:
  - build errors: +3/-7
  - build warnings: +29/-94

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.15-rc5.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7468/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7320/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7449/ (all 119 configs)


*** ERRORS ***

7 regressions:
  + /scratch/kisskb/src/arch/powerpc/platforms/powernv/setup.c: error: implicit declaration of function 'get_hard_smp_processor_id' [-Werror=implicit-function-declaration]:  => 179:4
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function):  => 99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]:  => 192:2
  + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: 'TMPFS_MAGIC' undeclared (first use in this function):  => 31
  + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: (Each undeclared identifier is reported only once:  => 31
  + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: for each function it appears in.):  => 31
  + /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: linux/magic.h: No such file or directory:  => 16:25

2 improvements:
  - error: initramfs.c: undefined reference to `__stack_chk_guard': .init.text+0x1067) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+bc8: (.text+0x9c2) => 


*** WARNINGS ***

115 regressions:
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 376 => 383, 380
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 376 => 383, 380
  + /scratch/kisskb/src/arch/sh/math-emu/math.c: warning: 'ieee_fpe_handler' defined but not used [-Wunused-function]:  => 505:12
  + /scratch/kisskb/src/drivers/char/random.c: warning: 'arch_random_refill' uses dynamic stack allocation [enabled by default]:  => 1326:1
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
  + /scratch/kisskb/src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6884:13
  + /scratch/kisskb/src/drivers/message/i2o/i2o_config.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 992:1
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1310:1
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1177:1
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1560 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 417:1
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1864 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 972:1
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2228 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_util.c: warning: the frame size of 1476 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 89:1
  + /scratch/kisskb/src/drivers/mtd/lpddr/lpddr_cmds.c: warning: the frame size of 1180 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 737:1
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: warning: passing argument 1 of 'bnx2x_vf_pci_dealloc' from incompatible pointer type [enabled by default]:  => 13237:4
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: 'return' with a value, in function returning void [enabled by default]:  => 574:59
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: 'struct bnx2' declared inside parameter list [enabled by default]:  => 574:48
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]:  => 574:48
  + /scratch/kisskb/src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 1 of 'inw' makes integer from pointer without a cast [enabled by default]: 1642:2, 569:14, 1668:2, 1262:4, 1647:2, 856:2, 1673:2, 468:4, 1338:9, 675:12, 619:2, 1341:2, 440:3, 1881:2, 331:2, 1907:2, 1337:11, 412:18, 770:2, 748:2, 490:3, 1276:4, 727:2, 1894:2, 689:3, 677:4, 1246:4, 829:2, 1194:2, 1285:4, 315:2, 1675:2, 1221:2, 1282:4, 1222:9, 1930:2, 1229:12, 397:2, 715:14, 792:2, 1170:2, 722:17, 1342:2, 796:3, 1339:2, 1809:16, 1863:2, 422:2, 752:2 => 332:2, 1286:4, 749:2, 1223:9, 1895:2, 793:2, 690:3, 1340:2, 728:2, 1908:2, 1339:9, 1247:4, 1222:2, 1676:2, 723:17, 1882:2, 1864:2, 1343:2, 1277:4, 1230:12, 316:2, 1273:4, 1232:3, 413:18, 1171:2, 797:3, 771:2, 1674:2, 1648:2, 423:2, 1643:2, 441:3, 676:12, 678:4, 1195:2, 1810:16, 469:4, 1338:11, 830:2, 857:2, 1263:4, 716:14, 491:3, 1669:2, 1931:2, 398:2, 753:2, 620:2, 570:14, 1342:2, 1283:4
  + /scratch/kisskb/src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast [enabled by default]: 1636:2, 390:2, 749:2, 358:2, 1070:2, 1666:2, 723:2, 1340:2, 1639:2, 1169:2, 314:2, 326:2, 779:3, 1261:4, 297:2, 1906:2, 271:2, 592:2, 726:2, 689:3, 396:2, 1450:2, 756:2, 488:3, 1643:2, 677:4, 1677:2, 1246:4, 469:4, 1795:2, 1196:2, 348:2, 936:2, 758:2, 667:2, 1071:2, 1285:4, 834:2, 1193:2, 1649:2, 598:2, 1669:2, 1453:3, 1449:2, 1020:3, 753:2, 419:2, 350:2, 1641:2, 392:2, 1880:2, 279:2, 357:2, 1291:2, 381:2, 1664:2, 1021:3, 1929:2, 793:2, 329:2, 579:2, 856:2, 1635:2, 312:2, 310:2, 255:2, 330:2, 619:2, 847:2, 351:2, 817:2, 1822:2, 1455:2, 1343:2, 272:2, 391:2, 1276:4, 311:2, 1223:2, 1171:2, 1452:3, 580:2, 441:3, 1794:2, 1638:2, 1195:2, 1663:2, 1128:2, 382:2, 861:2, 1667:2, 801:3, 829:2, 935:2, 1263:4, 1282:4, 612:2, 757:2, 491:3, 799:3, 1678:2, 1801:2, 397:2, 781:3, 1650:2, 346:2, 1893:2, 1292:2, 254:2, 934:2, 347:2, 1197:2 => 1670:2, 1642:2, 1636:2, 1668:2, 358:2, 349:2, 1454:3, 393:2, 1224:2, 848:2, 1639:2, 1072:2, 1293:2, 613:2, 759:2, 1456:2, 1907:2, 273:2, 1637:2, 1277:4, 937:2, 727:2, 1022:3, 1894:2, 1450:2, 862:2, 678:4, 599:2, 1823:2, 1795:2, 724:2, 581:2, 750:2, 1196:2, 348:2, 936:2, 1640:2, 1194:2, 758:2, 1071:2, 313:2, 315:2, 754:2, 1930:2, 420:2, 1453:3, 392:2, 1344:2, 1170:2, 620:2, 1198:2, 1664:2, 489:3, 593:2, 1021:3, 1286:4, 1262:4, 1172:2, 1451:2, 1264:4, 802:3, 1651:2, 690:3, 312:2, 782:3, 255:2, 330:2, 1341:2, 351:2, 1881:2, 1247:4, 331:2, 1644:2, 272:2, 391:2, 311:2, 1273:4, 298:2, 780:3, 668:2, 1232:3, 800:3, 580:2, 442:3, 382:2, 352:2, 280:2, 1667:2, 794:2, 470:4, 830:2, 935:2, 857:2, 383:2, 757:2, 359:2, 1796:2, 1679:2, 1678:2, 1665:2, 1802:2, 1129:2, 398:2, 397:2, 492:3, 256:2, 1650:2, 835:2, 1292:2, 818:2, 327:2, 1283:4, 347:2, 1197:2
  + /scratch/kisskb/src/drivers/net/wireless/ti/wlcore/spi.c: warning: the frame size of 1168 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 317:1
  + /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'phys_addr_t' [-Wformat]:  => 1006:2
  + /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]:  => 1006:2
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]:  => 6628:5
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
  + /scratch/kisskb/src/drivers/usb/serial/ti_usb_3410_5052.c: warning: 'lsr' may be used uninitialized in this function [-Wuninitialized]:  => 641:20
  + /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 622:11, 566:10
  + /scratch/kisskb/src/drivers/video/fbdev/amifb.c: warning: 'amifb_setup' defined but not used [-Wunused-function]:  => 2346:19
  + /scratch/kisskb/src/drivers/video/fbdev/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + /scratch/kisskb/src/drivers/video/fbdev/auo_k190x.c: warning: 'auok190x_resume' defined but not used [-Wunused-function]:  => 899:12
  + /scratch/kisskb/src/drivers/video/fbdev/auo_k190x.c: warning: 'auok190x_suspend' defined but not used [-Wunused-function]:  => 859:12
  + /scratch/kisskb/src/drivers/video/fbdev/goldfishfb.c: warning: 'fbpaddr' may be used uninitialized in this function [-Wuninitialized]:  => 256:24
  + /scratch/kisskb/src/drivers/video/fbdev/intelfb/intelfbhw.c: warning: 'm1' may be used uninitialized in this function [-Wuninitialized]:  => 1021:9
  + /scratch/kisskb/src/drivers/video/fbdev/intelfb/intelfbhw.c: warning: 'm2' may be used uninitialized in this function [-Wuninitialized]:  => 1026:25
  + /scratch/kisskb/src/drivers/video/fbdev/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /scratch/kisskb/src/drivers/video/fbdev/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1185:23
  + /scratch/kisskb/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + /scratch/kisskb/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + /scratch/kisskb/src/drivers/video/fbdev/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 734:23
  + /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]:  => 58:13
  + /scratch/kisskb/src/fs/f2fs/checkpoint.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 89:1
  + /scratch/kisskb/src/include/drm/drm_fixed.h: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]:  => 64:13
  + /scratch/kisskb/src/include/linux/ceph/osdmap.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 54:1
  + /scratch/kisskb/src/include/linux/pagemap.h: warning: 'blk_addr' may be used uninitialized in this function [-Wuninitialized]:  => 287:2
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]:  => 1609:13
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function:  => 1486
  + /scratch/kisskb/src/mm/slab_common.c: warning: 's' may be used uninitialized in this function [-Wuninitialized]:  => 203:21
  + /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_field_array_hash_tfm' uses dynamic stack allocation [enabled by default]:  => 194:1
  + /scratch/kisskb/src/sound/soc/codecs/adau1977.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 971:3
  + /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_resume' defined but not used [-Wunused-function]:  => 545:12
  + /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_suspend' defined but not used [-Wunused-function]:  => 520:12
  + <stdin>: warning: #warning syscall renameat2 not implemented [-Wcpp]:  => 1232:2
  + <stdin>: warning: #warning syscall renameat2 not implemented:  => 1232:2
  + warning: (INTEL_MIC_HOST && CAIF_VIRTIO && VHOST_NET && VHOST_SCSI && VHOST_NET && VHOST_SCSI) selects VHOST_RING which has unmet direct dependencies (NETDEVICES && CAIF_VIRTIO || VIRTUALIZATION):  => N/A
  + warning: (IXP4XX_ETH && PTP_1588_CLOCK) selects NET_PTP_CLASSIFY which has unmet direct dependencies (NET):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: drivers/built-in.o(.data+0x107c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa70): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb10): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc74): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd84): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xde4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe44): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xeac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x2c007c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x51290): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d54): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x3fd84): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
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

113 improvements:
  - /scratch/kisskb/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 573:1 => 
  - /scratch/kisskb/src/drivers/base/topology.c: warning: unused variable 'cpu' [-Wunused-variable]: 86:1, 83:1 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_resume' defined but not used [-Wunused-function]: 2550:12 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_suspend' defined but not used [-Wunused-function]: 2541:12 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]: 243:17 => 
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
