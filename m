Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaIJInj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:43:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50299 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaIJIne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:43:34 -0400
Date: Wed, 10 Sep 2014 11:43:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Warn on macros with flow control statements
Message-ID: <20140910084306.GV6600@mwanda>
References: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
 <20140909125410.GJ6549@mwanda>
 <1410295093.12560.60.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1410295093.12560.60.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2014 at 01:38:13PM -0700, Joe Perches wrote:
> Macros with flow control statements (goto and return) are
> not very nice to read as any flow movement is unexpected.
> 
> Try to highlight them and emit a warning on their definition.
> 
> Avoid warning on macros that use argument concatenation as
> those macros commonly create another function where the
> concatenation is used in the function name definition like:
> 	#define FOO_FUNC(name, rtn_type)	\
> 	rtn_type func##name(arg1, ...)		\
> 	{					\
> 		rtn_type rtn;			\
> 		[code...]			\
> 		return rtn;			\
> 	}
> 

It adds 382 new warnings.

The '##' trick doesn't remove all then macros which create functions.
I can't think of a better way to do that though.

We will eventually get rid of almost all the warnings in staging.  The
one that makes sense to keep is:

drivers/staging/lustre/lnet/selftest/selftest.h:559
#define STATE2STR(x) case x: return #x

My guess is that other maintainers won't be as excited to change these...

Some of the macros have "RETURN", "RET" or "EXIT" in the name so the
return is not really hidden.

I'll attach the list of warning locations.

regards,
dan carpenter


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=err-list

arch/alpha/lib/memcpy.c:24
arch/alpha/lib/memcpy.c:31
arch/alpha/math-emu/sfp-util.h:30
arch/arc/kernel/traps.c:65
arch/arc/kernel/unaligned.c:45
arch/arc/kernel/unaligned.c:56
arch/arc/kernel/unaligned.c:71
arch/arc/kernel/unaligned.c:98
arch/arm64/net/bpf_jit_comp.c:351
arch/arm/mach-omap2/gpmc.c:326
arch/arm/mach-omap2/gpmc.c:331
arch/arm/mm/alignment.c:215
arch/arm/mm/alignment.c:232
arch/arm/mm/alignment.c:253
arch/arm/mm/alignment.c:285
arch/blackfin/include/asm/uaccess.h:171
arch/blackfin/include/asm/uaccess.h:174
arch/frv/kernel/setup.c:665
arch/m68k/include/asm/bootstd.h:37
arch/m68k/include/asm/uaccess_no.h:138
arch/m68k/include/asm/uaccess_no.h:140
arch/m68k/math-emu/fp_emu.h:78
arch/m68k/math-emu/fp_emu.h:84
arch/mips/alchemy/common/clock.c:1016
arch/mips/cavium-octeon/executive/cvmx-spi.c:43
arch/mips/include/asm/octeon/cvmx-bootinfo.h:249
arch/mips/include/asm/octeon/cvmx-bootinfo.h:337
arch/mips/math-emu/me-debugfs.c:44
arch/mn10300/include/asm/uaccess.h:119
arch/mn10300/include/asm/uaccess.h:121
arch/mn10300/include/asm/uaccess.h:123
arch/mn10300/include/asm/uaccess.h:125
arch/mn10300/unit-asb2364/include/unit/serial.h:126
arch/parisc/include/asm/unistd.h:106
arch/parisc/include/asm/unistd.h:112
arch/parisc/include/asm/unistd.h:118
arch/parisc/include/asm/unistd.h:124
arch/parisc/include/asm/unistd.h:130
arch/parisc/include/asm/unistd.h:137
arch/parisc/kernel/module.c:81
arch/parisc/kernel/pci-dma.c:230
arch/parisc/lib/memcpy.c:71
arch/powerpc/include/asm/bitops.h:102
arch/powerpc/include/asm/io.h:406
arch/powerpc/include/asm/sfp-machine.h:353
arch/powerpc/platforms/powermac/pfunc_core.c:123
arch/powerpc/platforms/powernv/pci-ioda.c:44
arch/s390/hypfs/hypfs_vm.c:110
arch/s390/math-emu/math.c:75
arch/s390/math-emu/math.c:81
arch/s390/math-emu/math.c:87
arch/s390/math-emu/math.c:93
arch/sh/math-emu/math.c:276
arch/sh/math-emu/math.c:54
arch/sh/math-emu/math.c:55
arch/sh/math-emu/sfp-util.h:68
arch/sparc/include/asm/sfp-machine_32.h:198
arch/sparc/include/asm/sfp-machine_64.h:87
arch/sparc/include/asm/uaccess_32.h:169
arch/sparc/include/asm/uaccess_32.h:191
arch/sparc/include/asm/uaccess_64.h:150
arch/sparc/math-emu/sfp-util_32.h:108
arch/sparc/math-emu/sfp-util_64.h:113
arch/sparc/net/bpf_jit_comp.c:689
arch/unicore32/mm/alignment.c:101
arch/unicore32/mm/alignment.c:111
arch/unicore32/mm/alignment.c:135
arch/unicore32/mm/alignment.c:165
arch/unicore32/mm/alignment.c:182
arch/x86/include/asm/archrandom.h:69
arch/x86/include/asm/archrandom.h:86
arch/x86/include/asm/io.h:44
arch/x86/include/asm/rmwcc.h:24
arch/x86/kernel/nmi.c:464
arch/x86/kernel/nmi.c:475
arch/x86/kernel/ptrace.c:949
arch/x86/kernel/uprobes.c:552
arch/x86/kernel/uprobes.c:567
arch/x86/kernel/vm86_32.c:436
arch/x86/kernel/vm86_32.c:444
arch/x86/kernel/vm86_32.c:455
arch/x86/kernel/vm86_32.c:472
arch/x86/kernel/vm86_32.c:481
arch/x86/kernel/vm86_32.c:493
arch/x86/kernel/vm86_32.c:581
arch/x86/kvm/emulate.c:761
arch/x86/kvm/emulate.c:773
arch/x86/lib/insn.c:39
arch/x86/lib/insn.c:42
arch/x86/mm/pf_in.c:135
block/cfq-iosched.c:4488
block/cfq-iosched.c:4511
block/deadline-iosched.c:391
block/deadline-iosched.c:407
crypto/asymmetric_keys/verify_pefile.c:40
drivers/base/core.c:2102
drivers/block/drbd/drbd_vli.h:150
drivers/block/drbd/drbd_vli.h:176
drivers/char/dsp56k.c:60
drivers/char/dsp56k.c:77
drivers/char/dsp56k.c:87
drivers/char/ipmi/ipmi_bt_sm.c:90
drivers/char/ipmi/ipmi_bt_sm.c:92
drivers/char/pcmcia/cm4000_cs.c:204
drivers/cpufreq/cpufreq_governor.h:111
drivers/gpu/drm/drm_crtc.c:49
drivers/gpu/drm/gma500/gma_display.c:697
drivers/gpu/drm/i915/intel_display.c:10629
drivers/gpu/drm/i915/intel_display.c:10638
drivers/gpu/drm/i915/intel_display.c:10652
drivers/gpu/drm/i915/intel_display.c:10663
drivers/gpu/drm/i915/intel_display.c:10672
drivers/gpu/drm/i915/intel_display.c:542
drivers/gpu/drm/i915/intel_uncore.c:551
drivers/gpu/drm/mga/mga_drv.h:227
drivers/gpu/drm/mga/mga_drv.h:241
drivers/gpu/drm/r128/r128_drv.h:425
drivers/gpu/drm/r128/r128_drv.h:433
drivers/gpu/drm/r128/r128_drv.h:450
drivers/gpu/drm/radeon/radeon_drv.h:2006
drivers/gpu/drm/radeon/radeon_kms.c:805
drivers/gpu/drm/radeon/radeon_state.c:1824
drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c:30
drivers/input/input.c:1557
drivers/input/input.c:1564
drivers/input/input.c:1571
drivers/input/serio/i8042.c:1048
drivers/input/serio/serio.c:913
drivers/isdn/act2000/capi.c:119
drivers/isdn/hisax/l3dss1.c:359
drivers/isdn/i4l/isdn_tty.c:2595
drivers/isdn/i4l/isdn_tty.c:2596
drivers/isdn/i4l/isdn_ttyfax.c:25
drivers/macintosh/via-cuda.c:249
drivers/md/bcache/alloc.c:280
drivers/md/bcache/closure.h:319
drivers/md/bcache/closure.h:348
drivers/md/bcache/closure.h:364
drivers/md/bcache/journal.c:146
drivers/md/bcache/sysfs.h:88
drivers/md/bcache/sysfs.h:97
drivers/md/bcache/util.h:485
drivers/media/dvb-frontends/dib3000mb_priv.h:24
drivers/media/i2c/soc_camera/mt9t112.c:51
drivers/media/rc/rc-main.c:1183
drivers/media/tuners/tuner-i2c.h:129
drivers/media/usb/tlg2300/pd-video.c:214
drivers/net/dsa/mv88e6060.c:27
drivers/net/dsa/mv88e6060.c:44
drivers/net/dsa/mv88e6xxx.h:74
drivers/net/dsa/mv88e6xxx.h:84
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:2190
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:2196
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:2202
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:2208
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:12812
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:674
drivers/net/ethernet/cisco/enic/enic_res.c:54
drivers/net/ethernet/cisco/enic/vnic_vic.h:65
drivers/net/ethernet/intel/e1000e/ethtool.c:809
drivers/net/ethernet/intel/e1000e/ethtool.c:817
drivers/net/ethernet/intel/igb/igb_ethtool.c:1237
drivers/net/ethernet/intel/igb/igb_ethtool.c:1243
drivers/net/ethernet/neterion/vxge/vxge-config.c:24
drivers/net/ethernet/neterion/vxge/vxge-config.h:870
drivers/net/ethernet/tehuti/tehuti.h:543
drivers/net/ethernet/tehuti/tehuti.h:553
drivers/net/wimax/i2400m/debugfs.c:231
drivers/net/wimax/i2400m/usb.c:384
drivers/net/wireless/at76c50x-usb.c:708
drivers/net/wireless/at76c50x-usb.c:753
drivers/net/wireless/ath/ar5523/ar5523.c:368
drivers/net/wireless/ath/ath10k/wmi.h:177
drivers/net/wireless/ath/ath5k/ath5k.h:932
drivers/net/wireless/ath/ath5k/eeprom.h:244
drivers/net/wireless/ath/ath9k/ath9k.h:414
drivers/net/wireless/ath/carl9170/cmd.h:120
drivers/net/wireless/ath/carl9170/cmd.h:139
drivers/net/wireless/ath/carl9170/cmd.h:87
drivers/net/wireless/cw1200/fwio.c:65
drivers/net/wireless/cw1200/fwio.c:71
drivers/net/wireless/cw1200/fwio.c:77
drivers/net/wireless/cw1200/fwio.c:83
drivers/net/wireless/cw1200/wsm.c:30
drivers/net/wireless/cw1200/wsm.c:37
drivers/net/wireless/cw1200/wsm.c:45
drivers/net/wireless/cw1200/wsm.c:59
drivers/net/wireless/cw1200/wsm.c:68
drivers/net/wireless/iwlegacy/common.c:3788
drivers/net/wireless/iwlegacy/common.c:3794
drivers/net/wireless/iwlegacy/common.h:1526
drivers/net/wireless/iwlegacy/debug.c:136
drivers/net/wireless/iwlegacy/debug.c:144
drivers/net/wireless/iwlwifi/dvm/debugfs.c:47
drivers/net/wireless/iwlwifi/dvm/debugfs.c:55
drivers/net/wireless/iwlwifi/dvm/debugfs.c:63
drivers/net/wireless/iwlwifi/dvm/rxon.c:862
drivers/net/wireless/iwlwifi/dvm/rxon.c:868
drivers/net/wireless/iwlwifi/iwl-io.c:206
drivers/net/wireless/iwlwifi/pcie/trans.c:1450
drivers/net/wireless/p54/p54usb.c:640
drivers/net/wireless/p54/p54usb.c:648
drivers/net/wireless/rndis_wlan.c:624
drivers/parisc/ccio-dma.c:295
drivers/pcmcia/i82365.c:1154
drivers/pcmcia/m32r_cfc.c:611
drivers/pcmcia/m32r_pcc.c:599
drivers/pinctrl/pinctrl-single.c:1495
drivers/pnp/pnpacpi/core.c:36
drivers/pnp/pnpacpi/core.c:39
drivers/scsi/aha1542.c:150
drivers/scsi/aha1542.c:163
drivers/scsi/aic94xx/aic94xx_tmf.c:100
drivers/scsi/aic94xx/aic94xx_tmf.c:118
drivers/scsi/csiostor/csio_hw.c:369
drivers/scsi/fnic/fnic_res.c:39
drivers/scsi/sym53c8xx_2/sym_glue.c:1020
drivers/scsi/sym53c8xx_2/sym_glue.c:1025
drivers/ssb/pcmcia.c:595
drivers/ssb/sdio.c:465
drivers/staging/board/board.h:9
drivers/staging/dgnc/dgnc_sysfs.c:134
drivers/staging/line6/driver.h:55
drivers/staging/line6/driver.h:62
drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:246
drivers/staging/lustre/lnet/selftest/selftest.h:559
drivers/staging/lustre/lustre/include/lprocfs_status.h:673
drivers/staging/lustre/lustre/include/obd_class.h:335
drivers/staging/lustre/lustre/include/obd_class.h:344
drivers/staging/lustre/lustre/include/obd_class.h:431
drivers/staging/lustre/lustre/include/obd_class.h:441
drivers/staging/lustre/lustre/include/obd_class.h:460
drivers/staging/lustre/lustre/include/obd_class.h:470
drivers/staging/lustre/lustre/include/obd_class.h:487
drivers/staging/lustre/lustre/ptlrpc/llog_client.c:52
drivers/staging/rts5208/trace.h:49
drivers/staging/rts5208/trace.h:66
drivers/staging/rts5208/trace.h:83
drivers/staging/rts5208/trace.h:84
drivers/staging/unisys/common-spar/include/channels/iochannel.h:772
drivers/staging/unisys/virtpci/virtpci.c:301
drivers/usb/renesas_usbhs/fifo.c:222
drivers/video/fbdev/aty/atyfb_base.c:117
drivers/video/fbdev/aty/atyfb_base.c:122
drivers/video/fbdev/hgafb.c:54
drivers/video/fbdev/intelfb/intelfbdrv.c:492
drivers/video/fbdev/sis/sis.h:52
drivers/video/fbdev/vga16fb.c:281
fs/btrfs/send.c:591
fs/btrfs/send.c:609
fs/btrfs/send.c:615
fs/btrfs/send.c:622
fs/btrfs/send.c:628
fs/coda/upcall.c:60
fs/fat/dir.c:704
fs/nfsd/nfs2acl.c:16
fs/nfsd/nfs3acl.c:15
fs/nfsd/nfs3proc.c:17
fs/nfsd/nfs4xdr.c:114
fs/nfsd/nfs4xdr.c:84
fs/nfsd/nfs4xdr.c:98
fs/ntfs/super.c:114
fs/ntfs/super.c:124
fs/ntfs/super.c:132
fs/ntfs/super.c:144
fs/ntfs/super.c:156
fs/ntfs/super.c:164
fs/ntfs/super.c:171
fs/ufs/balloc.c:561
fs/xfs/xfs_error.h:43
fs/xfs/xfs_error.h:55
include/acpi/acoutput.h:372
include/acpi/acoutput.h:381
include/acpi/acoutput.h:391
include/acpi/acoutput.h:450
include/acpi/acoutput.h:451
include/acpi/acoutput.h:452
include/acpi/acoutput.h:453
include/acpi/acoutput.h:454
include/acpi/acoutput.h:455
include/acpi/acpixf.h:291
include/acpi/acpixf.h:294
include/acpi/acpixf.h:297
include/acpi/acpixf.h:314
include/acpi/acpixf.h:331
include/acpi/acpixf.h:348
include/acpi/platform/aclinux.h:105
include/acpi/platform/aclinux.h:107
include/acpi/platform/aclinux.h:109
include/acpi/platform/aclinux.h:111
include/acpi/platform/aclinux.h:113
include/drm/drmP.h:244
include/linux/ceph/decode.h:220
include/linux/ceph/decode.h:55
include/linux/compiler-gcc4.h:78
include/linux/genl_magic_func.h:178
include/linux/genl_magic_func.h:225
include/linux/genl_magic_func.h:357
include/linux/init.h:327
include/linux/init.h:333
include/linux/platform_device.h:277
include/linux/platform_device.h:291
include/linux/tracepoint.h:118
include/linux/usb/serial.h:398
include/linux/wait.h:208
include/trace/ftrace.h:322
include/trace/ftrace.h:331
include/trace/ftrace.h:346
kernel/bpf/core.c:249
kernel/bpf/core.c:250
kernel/events/internal.h:84
kernel/trace/trace_events.c:147
kernel/trace/trace_export.c:109
kernel/trace/trace_export.c:120
kernel/trace/trace_export.c:77
kernel/trace/trace_export.c:86
kernel/trace/trace_export.c:96
kernel/trace/trace_output.h:38
kernel/trace/trace_output.h:44
kernel/trace/trace_probe.c:39
kernel/trace/trace_probe.h:54
lib/inflate.c:232
lib/kstrtox.c:324
lib/lru_cache.c:46
lib/lzo/lzo1x_decompress_safe.c:30
lib/lzo/lzo1x_decompress_safe.c:36
lib/lzo/lzo1x_decompress_safe.c:42
lib/ts_fsm.c:151
lib/zlib_deflate/deflate.c:839
lib/zlib_inflate/inflate.c:196
net/bridge/netfilter/ebt_vlan.c:35
net/core/dev.c:7067
net/core/filter.c:421
net/decnet/netfilter/dn_rtmsg.c:101
net/ipv6/route.c:776
net/irda/irnet/irnet.h:364
net/irda/irnet/irnet.h:369
net/irda/irnet/irnet.h:375
net/mac80211/rx.c:2965
net/mac80211/rx.c:3023
net/mac80211/tx.c:1345
net/netfilter/nf_conntrack_h323_asn1.c:106
net/netfilter/nfnetlink_log.c:592
net/netfilter/nfnetlink_queue_core.c:800
net/rxrpc/ar-key.c:1133
net/rxrpc/ar-key.c:1139
net/rxrpc/ar-key.c:1150
net/rxrpc/rxkad.c:866
net/sched/cls_flow.c:126
net/sched/cls_flow.c:135
net/sched/cls_route.c:108
net/sched/cls_rsvp.h:119
net/vmw_vsock/af_vsock.c:1374
net/vmw_vsock/af_vsock.c:1455
net/wimax/debugfs.c:31
net/wireless/nl80211.c:4908
scripts/dtc/libfdt/fdt_rw.c:85
scripts/dtc/libfdt/fdt_sw.c:66
scripts/dtc/libfdt/libfdt_internal.h:58
sound/aoa/codecs/onyx.c:931
sound/isa/sb/emu8000_pcm.c:420
sound/oss/dmasound/dmasound.h:45
sound/oss/dmasound/dmasound_paula.c:188
sound/oss/dmasound/dmasound_paula.c:239
sound/oss/swarm_cs4297a.c:195
sound/pci/ca0106/ca0106_mixer.c:767
tools/lib/traceevent/trace-seq.c:41
tools/perf/builtin-kvm.c:1130
tools/perf/tests/attr.c:44
tools/perf/tests/keep-tracking.c:12
tools/perf/tests/keep-tracking.c:19
tools/perf/tests/perf-time-to-tsc.c:14
tools/perf/tests/perf-time-to-tsc.c:21
tools/perf/tests/sample-parsing.c:11
tools/perf/tests/sample-parsing.c:18
tools/perf/tests/tests.h:4
tools/perf/util/evsel.c:1251
tools/perf/util/parse-events.c:488
tools/perf/util/probe-event.c:2204
tools/perf/util/unwind-libunwind.c:154
tools/perf/util/unwind-libunwind.c:92
tools/testing/selftests/powerpc/utils.h:25
tools/testing/selftests/powerpc/utils.h:37
tools/usb/ffs-test.c:202

--3V7upXqbjpZ4EhLz--
