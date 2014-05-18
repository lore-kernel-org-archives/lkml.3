Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaERCPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 22:15:37 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55376 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaERCPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 22:15:30 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: dan.carpenter@oracle.com
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        kernel-janitors@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] Remove useless return variables
Date: Sun, 18 May 2014 04:15:10 +0200
Message-Id: <1400379310-10214-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified manually.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
@@
- T ret = C;
... when != ret
- return ret;
+ return C;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---

Should I send this a single big patch or as a set of small patches?

 arch/arc/kernel/kprobes.c                          |   3 +-
 arch/arm/mach-imx/iomux-imx31.c                    |   4 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  10 +-
 arch/arm/mach-orion5x/ts78xx-setup.c               |   4 +-
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c            |   3 +-
 arch/ia64/kernel/perfmon_default_smpl.c            |   3 +-
 arch/mips/sibyte/bcm1480/setup.c                   |   4 +-
 arch/powerpc/oprofile/op_model_cell.c              |   3 +-
 arch/powerpc/platforms/83xx/usb.c                  |   3 +-
 arch/powerpc/platforms/cell/ras.c                  |   3 +-
 drivers/clk/samsung/clk-s3c2410-dclk.c             |   3 +-
 drivers/crypto/caam/caamalg.c                      |   3 +-
 drivers/crypto/caam/ctrl.c                         |   4 +-
 drivers/crypto/nx/nx-842.c                         |   3 +-
 drivers/crypto/ux500/hash/hash_core.c              |   3 +-
 drivers/firmware/efi/efi-pstore.c                  |   4 +-
 drivers/gpu/drm/drm_crtc.c                         |   3 +-
 drivers/gpu/drm/i810/i810_dma.c                    |   4 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   3 +-
 drivers/gpu/drm/i915/intel_sprite.c                |   6 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   3 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |   3 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |   3 +-
 drivers/gpu/drm/tegra/dpaux.c                      |   3 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   3 +-
 drivers/infiniband/core/cache.c                    |   3 +-
 drivers/infiniband/hw/amso1100/c2.c                |   4 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c             |   9 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c       |   3 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c        |   4 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |   7 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   3 +-
 drivers/infiniband/hw/nes/nes_utils.c              |   3 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |   3 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   7 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |   3 +-
 drivers/mailbox/omap-mailbox.c                     |   4 +-
 drivers/md/bcache/debug.c                          |   4 +-
 drivers/media/i2c/s5k5baf.c                        |   3 +-
 drivers/media/media-devnode.c                      |   3 +-
 drivers/media/pci/saa7164/saa7164-api.c            |   3 +-
 drivers/media/platform/davinci/vpbe.c              |   3 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   3 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   3 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   3 +-
 drivers/media/rc/fintek-cir.c                      |   6 +-
 drivers/media/rc/ite-cir.c                         |   3 +-
 drivers/media/rc/nuvoton-cir.c                     |   6 +-
 drivers/media/tuners/mt2060.c                      |   3 +-
 drivers/media/tuners/mt2266.c                      |   3 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |   4 +-
 drivers/mfd/arizona-core.c                         |   4 +-
 drivers/mfd/htc-i2cpld.c                           |   3 +-
 drivers/mfd/pcf50633-irq.c                         |   4 +-
 drivers/mmc/core/sdio_bus.c                        |   3 +-
 drivers/mmc/host/sdhci.c                           |   7 +-
 drivers/mtd/mtdpart.c                              |   3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   3 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.c         |   3 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |   3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/ethernet/ti/davinci_cpdma.c            |   4 +-
 drivers/net/irda/mcs7780.c                         |   3 +-
 drivers/net/irda/via-ircc.c                        |   3 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |   4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   4 +-
 drivers/net/wireless/cw1200/cw1200_spi.c           |   4 +-
 drivers/net/wireless/cw1200/sta.c                  |   3 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |  13 +--
 drivers/net/wireless/iwlegacy/3945-mac.c           |   4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   3 +-
 drivers/net/wireless/iwlegacy/4965.c               |   3 +-
 drivers/net/wireless/mwifiex/scan.c                |   3 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |   3 +-
 drivers/pcmcia/pcmcia_resource.c                   |   3 +-
 drivers/pinctrl/pinctrl-adi2.c                     |   3 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |   4 +-
 drivers/power/pm2301_charger.c                     |   3 +-
 drivers/powercap/intel_rapl.c                      |   5 +-
 drivers/powercap/powercap_sys.c                    |   3 +-
 drivers/rtc/interface.c                            |   3 +-
 drivers/s390/cio/eadm_sch.c                        |   3 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   3 +-
 drivers/scsi/isci/request.c                        |   3 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   4 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   4 +-
 drivers/scsi/sun3_scsi_vme.c                       |   3 +-
 drivers/staging/gdm72xx/gdm_wimax.c                |   3 +-
 .../lustre/lustre/ptlrpc/gss/gss_generic_token.c   |   3 +-
 drivers/staging/media/as102/as102_usb_drv.c        |   7 +-
 drivers/staging/rtl8188eu/core/rtw_ap.c            |  22 ++---
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c     |   8 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      |   3 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |   7 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     | 104 +++++++--------------
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |   3 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c     |   3 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   9 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c         |   3 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   3 +-
 drivers/staging/rtl8192e/rtllib_softmac_wx.c       |   4 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   3 +-
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |   4 +-
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |   3 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   9 +-
 drivers/staging/rtl8192u/r819xU_phy.c              |   3 +-
 drivers/staging/rtl8712/ieee80211.c                |   8 +-
 drivers/staging/rtl8712/os_intfs.c                 |   3 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |   3 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |   4 +-
 drivers/staging/rtl8712/rtl871x_mlme.c             |   3 +-
 drivers/staging/rtl8712/rtl871x_recv.c             |   4 +-
 drivers/staging/rtl8723au/core/rtw_ap.c            |  22 ++---
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |   8 +-
 drivers/staging/rtl8723au/core/rtw_recv.c          |   4 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |  30 ++----
 drivers/staging/rtl8723au/os_dep/os_intfs.c        |   3 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |   3 +-
 drivers/staging/vt6655/hostap.c                    |  10 +-
 drivers/staging/vt6655/wpactl.c                    |  19 ++--
 drivers/staging/vt6656/hostap.c                    |  10 +-
 drivers/staging/wlags49_h2/wl_priv.c               |   6 +-
 drivers/tty/mxser.c                                |   5 +-
 drivers/tty/serial/mrst_max3110.c                  |   3 +-
 drivers/tty/tty_ldisc.c                            |   3 +-
 drivers/uio/uio_dmem_genirq.c                      |   3 +-
 drivers/usb/dwc2/gadget.c                          |   3 +-
 drivers/usb/gadget/fotg210-udc.c                   |   3 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |   4 +-
 drivers/uwb/rsv.c                                  |   3 +-
 drivers/video/fbdev/pxa168fb.c                     |   3 +-
 drivers/virt/fsl_hypervisor.c                      |   7 +-
 fs/btrfs/dir-item.c                                |   3 +-
 fs/btrfs/disk-io.c                                 |   8 +-
 fs/btrfs/extent_map.c                              |   7 +-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/jfs/jfs_metapage.c                              |   3 +-
 fs/proc/kcore.c                                    |   3 +-
 fs/reiserfs/journal.c                              |   3 +-
 kernel/debug/debug_core.c                          |   3 +-
 kernel/sched/core.c                                |   4 +-
 mm/rmap.c                                          |   5 +-
 net/9p/mod.c                                       |   4 +-
 net/rds/ib_recv.c                                  |   3 +-
 net/rds/iw_rdma.c                                  |   3 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   3 +-
 sound/ppc/snd_ps3.c                                |   3 +-
 sound/soc/codecs/wm8971.c                          |   3 +-
 sound/soc/intel/sst-haswell-ipc.c                  |   3 +-
 sound/soc/omap/mcbsp.c                             |   3 +-
 sound/soc/pxa/pxa-ssp.c                            |   3 +-
 sound/soc/samsung/dma.c                            |   3 +-
 sound/soc/soc-dapm.c                               |   4 +-
 tools/perf/util/header.c                           |   3 +-
 tools/perf/util/symbol.c                           |   3 +-
 tools/perf/util/trace-event-read.c                 |   3 +-
 tools/thermal/tmon/pid.c                           |   5 +-
 158 files changed, 286 insertions(+), 520 deletions(-)

diff --git a/arch/arc/kernel/kprobes.c b/arch/arc/kernel/kprobes.c
index 42b0504..c70c44a 100644
--- a/arch/arc/kernel/kprobes.c
+++ b/arch/arc/kernel/kprobes.c
@@ -366,7 +366,6 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 {
 	struct die_args *args = data;
 	unsigned long addr = args->err;
-	int ret = NOTIFY_DONE;
 
 	switch (val) {
 	case DIE_IERR:
@@ -383,7 +382,7 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 		break;
 	}
 
-	return ret;
+	return NOTIFY_DONE;
 }
 
 int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
diff --git a/arch/arm/mach-imx/iomux-imx31.c b/arch/arm/mach-imx/iomux-imx31.c
index 7c66805..93f579f 100644
--- a/arch/arm/mach-imx/iomux-imx31.c
+++ b/arch/arm/mach-imx/iomux-imx31.c
@@ -46,7 +46,7 @@ static unsigned long mxc_pin_alloc_map[NB_PORTS * 32 / BITS_PER_LONG];
  */
 int mxc_iomux_mode(unsigned int pin_mode)
 {
-	u32 field, l, mode, ret = 0;
+	u32 field, l, mode;
 	void __iomem *reg;
 
 	reg = IOMUXSW_MUX_CTL + (pin_mode & IOMUX_REG_MASK);
@@ -62,7 +62,7 @@ int mxc_iomux_mode(unsigned int pin_mode)
 
 	spin_unlock(&gpio_mux_lock);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(mxc_iomux_mode);
 
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 66c60fe..6b409ea 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -762,8 +762,6 @@ static int _del_initiator_dep(struct omap_hwmod *oh, struct omap_hwmod *init_oh)
  */
 static int _init_main_clk(struct omap_hwmod *oh)
 {
-	int ret = 0;
-
 	if (!oh->main_clk)
 		return 0;
 
@@ -787,7 +785,7 @@ static int _init_main_clk(struct omap_hwmod *oh)
 		pr_debug("omap_hwmod: %s: missing clockdomain for %s.\n",
 			   oh->name, oh->main_clk);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -803,7 +801,6 @@ static int _init_interface_clks(struct omap_hwmod *oh)
 	struct list_head *p;
 	struct clk *c;
 	int i = 0;
-	int ret = 0;
 
 	p = oh->slave_ports.next;
 
@@ -831,7 +828,7 @@ static int _init_interface_clks(struct omap_hwmod *oh)
 		clk_prepare(os->_clk);
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -846,7 +843,6 @@ static int _init_opt_clks(struct omap_hwmod *oh)
 	struct omap_hwmod_opt_clk *oc;
 	struct clk *c;
 	int i;
-	int ret = 0;
 
 	for (i = oh->opt_clks_cnt, oc = oh->opt_clks; i > 0; i--, oc++) {
 		c = clk_get(NULL, oc->clk);
@@ -868,7 +864,7 @@ static int _init_opt_clks(struct omap_hwmod *oh)
 		clk_prepare(oc->_clk);
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c b/arch/arm/mach-orion5x/ts78xx-setup.c
index db16dae..cd71744 100644
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -445,8 +445,6 @@ static int ts78xx_fpga_load_devices(void)
 
 static int ts78xx_fpga_unload_devices(void)
 {
-	int ret = 0;
-
 	if (ts78xx_fpga.supports.ts_rtc.present == 1)
 		ts78xx_ts_rtc_unload();
 	if (ts78xx_fpga.supports.ts_nand.present == 1)
@@ -454,7 +452,7 @@ static int ts78xx_fpga_unload_devices(void)
 	if (ts78xx_fpga.supports.ts_rng.present == 1)
 		ts78xx_ts_rng_unload();
 
-	return ret;
+	return 0;
 }
 
 static int ts78xx_fpga_load(void)
diff --git a/arch/arm/mach-s3c24xx/mach-osiris-dvs.c b/arch/arm/mach-s3c24xx/mach-osiris-dvs.c
index 33afb91..906ea48 100644
--- a/arch/arm/mach-s3c24xx/mach-osiris-dvs.c
+++ b/arch/arm/mach-s3c24xx/mach-osiris-dvs.c
@@ -59,7 +59,6 @@ static int osiris_dvs_notify(struct notifier_block *nb,
 	struct s3c_cpufreq_freqs *freqs = to_s3c_cpufreq(cf);
 	bool old_dvs = is_dvs(&freqs->old);
 	bool new_dvs = is_dvs(&freqs->new);
-	int ret = 0;
 
 	if (!dvs_en)
 		return 0;
@@ -87,7 +86,7 @@ static int osiris_dvs_notify(struct notifier_block *nb,
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 static struct notifier_block osiris_dvs_nb = {
diff --git a/arch/ia64/kernel/perfmon_default_smpl.c b/arch/ia64/kernel/perfmon_default_smpl.c
index 30c644e..623b338 100644
--- a/arch/ia64/kernel/perfmon_default_smpl.c
+++ b/arch/ia64/kernel/perfmon_default_smpl.c
@@ -41,7 +41,6 @@ static int
 default_validate(struct task_struct *task, unsigned int flags, int cpu, void *data)
 {
 	pfm_default_smpl_arg_t *arg = (pfm_default_smpl_arg_t*)data;
-	int ret = 0;
 
 	if (data == NULL) {
 		DPRINT(("[%d] no argument passed\n", task_pid_nr(task)));
@@ -57,7 +56,7 @@ default_validate(struct task_struct *task, unsigned int flags, int cpu, void *da
 
 	DPRINT(("buf_size=%lu\n", arg->buf_size));
 
-	return ret;
+	return 0;
 }
 
 static int
diff --git a/arch/mips/sibyte/bcm1480/setup.c b/arch/mips/sibyte/bcm1480/setup.c
index 8e2e04f..e027d97 100644
--- a/arch/mips/sibyte/bcm1480/setup.c
+++ b/arch/mips/sibyte/bcm1480/setup.c
@@ -46,8 +46,6 @@ static char *pass_str;
 
 static int __init setup_bcm1x80_bcm1x55(void)
 {
-	int ret = 0;
-
 	switch (soc_pass) {
 	case K_SYS_REVISION_BCM1480_S0:
 		periph_rev = 1;
@@ -76,7 +74,7 @@ static int __init setup_bcm1x80_bcm1x55(void)
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 /* Setup code likely to be common to all SiByte platforms */
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 863d893..1b9a166 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1118,12 +1118,11 @@ static int pm_rtas_activate_spu_profiling(u32 node)
 static int
 oprof_cpufreq_notify(struct notifier_block *nb, unsigned long val, void *data)
 {
-	int ret = 0;
 	struct cpufreq_freqs *frq = data;
 	if ((val == CPUFREQ_PRECHANGE && frq->old < frq->new) ||
 	    (val == CPUFREQ_POSTCHANGE && frq->old > frq->new))
 		set_spu_profiling_frequency(frq->new, spu_cycle_reset);
-	return ret;
+	return 0;
 }
 
 static struct notifier_block cpu_freq_notifier_block = {
diff --git a/arch/powerpc/platforms/83xx/usb.c b/arch/powerpc/platforms/83xx/usb.c
index 1ad748b..102f17e 100644
--- a/arch/powerpc/platforms/83xx/usb.c
+++ b/arch/powerpc/platforms/83xx/usb.c
@@ -219,7 +219,6 @@ int mpc837x_usb_cfg(void)
 	void __iomem *immap;
 	struct device_node *np = NULL;
 	const void *prop;
-	int ret = 0;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl-usb2-dr");
 	if (!np || !of_device_is_available(np))
@@ -249,6 +248,6 @@ int mpc837x_usb_cfg(void)
 
 	iounmap(immap);
 	of_node_put(np);
-	return ret;
+	return 0;
 }
 #endif /* CONFIG_PPC_MPC837x */
diff --git a/arch/powerpc/platforms/cell/ras.c b/arch/powerpc/platforms/cell/ras.c
index e865d74..3b5bc7d 100644
--- a/arch/powerpc/platforms/cell/ras.c
+++ b/arch/powerpc/platforms/cell/ras.c
@@ -210,7 +210,6 @@ static int __init cbe_ptcal_enable(void)
 static int cbe_ptcal_disable(void)
 {
 	struct ptcal_area *area, *tmp;
-	int ret = 0;
 
 	pr_debug("%s: disabling PTCAL\n", __func__);
 
@@ -234,7 +233,7 @@ static int cbe_ptcal_disable(void)
 		kfree(area);
 	}
 
-	return ret;
+	return 0;
 }
 
 static int cbe_ptcal_notify_reboot(struct notifier_block *nb,
diff --git a/drivers/clk/samsung/clk-s3c2410-dclk.c b/drivers/clk/samsung/clk-s3c2410-dclk.c
index 8d8dff0..64fe21b 100644
--- a/drivers/clk/samsung/clk-s3c2410-dclk.c
+++ b/drivers/clk/samsung/clk-s3c2410-dclk.c
@@ -73,12 +73,11 @@ static u8 s3c24xx_clkout_get_parent(struct clk_hw *hw)
 static int s3c24xx_clkout_set_parent(struct clk_hw *hw, u8 index)
 {
 	struct s3c24xx_clkout *clkout = to_s3c24xx_clkout(hw);
-	int ret = 0;
 
 	s3c2410_modify_misccr((clkout->mask << clkout->shift),
 			      (index << clkout->shift));
 
-	return ret;
+	return 0;
 }
 
 const struct clk_ops s3c24xx_clkout_ops = {
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c09ce1f..d605bf2 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -702,7 +702,6 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct ablkcipher_tfm *tfm = &ablkcipher->base.crt_ablkcipher;
 	struct device *jrdev = ctx->jrdev;
-	int ret = 0;
 	u32 *key_jump_cmd;
 	u32 *desc;
 
@@ -798,7 +797,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		       desc_bytes(desc), 1);
 #endif
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1c38f86..5c44814 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -271,7 +271,7 @@ static int caam_remove(struct platform_device *pdev)
 	struct device *ctrldev;
 	struct caam_drv_private *ctrlpriv;
 	struct caam_full __iomem *topregs;
-	int ring, ret = 0;
+	int ring;
 
 	ctrldev = &pdev->dev;
 	ctrlpriv = dev_get_drvdata(ctrldev);
@@ -298,7 +298,7 @@ static int caam_remove(struct platform_device *pdev)
 	kfree(ctrlpriv->jrpdev);
 	kfree(ctrlpriv);
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index c4fcbf4..5aedfb9 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -734,7 +734,6 @@ static int nx842_OF_set_defaults(struct nx842_devdata *devdata)
  */
 static int nx842_OF_upd_status(struct nx842_devdata *devdata,
 					struct property *prop) {
-	int ret = 0;
 	const char *status = (const char *)prop->value;
 
 	if (!strncmp(status, "okay", (size_t)prop->length)) {
@@ -745,7 +744,7 @@ static int nx842_OF_upd_status(struct nx842_devdata *devdata,
 		devdata->status = UNAVAILABLE;
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 1c73f4f..2a0f3d5 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1346,7 +1346,6 @@ static int ahash_final(struct ahash_request *req)
 static int hash_setkey(struct crypto_ahash *tfm,
 		       const u8 *key, unsigned int keylen, int alg)
 {
-	int ret = 0;
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	/**
@@ -1360,7 +1359,7 @@ static int hash_setkey(struct crypto_ahash *tfm,
 	}
 	ctx->keylen = keylen;
 
-	return ret;
+	return 0;
 }
 
 static int ahash_sha1_init(struct ahash_request *req)
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 4b9dc83..ea4ceae4 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -243,7 +243,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	int i, ret = 0;
+	int i;
 
 	sprintf(name, "dump-type%u-%u-%d-%lu-%c", type, part, count,
 		get_seconds(), compressed ? 'C' : 'D');
@@ -259,7 +259,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 		efivar_run_worker();
 
 	*id = part;
-	return ret;
+	return 0;
 };
 
 struct pstore_erase_data {
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index d8b7099..ffbed35 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2625,7 +2625,6 @@ int drm_mode_addfb(struct drm_device *dev,
 	struct drm_mode_fb_cmd2 r = {};
 	struct drm_mode_config *config = &dev->mode_config;
 	struct drm_framebuffer *fb;
-	int ret = 0;
 
 	/* Use new struct with format internally */
 	r.fb_id = or->fb_id;
@@ -2656,7 +2655,7 @@ int drm_mode_addfb(struct drm_device *dev,
 	DRM_DEBUG_KMS("[FB:%d]\n", fb->base.id);
 	mutex_unlock(&file_priv->fbs_lock);
 
-	return ret;
+	return 0;
 }
 
 static int format_check(const struct drm_mode_fb_cmd2 *r)
diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index aeace37..4b61473 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -853,7 +853,7 @@ static int i810_flush_queue(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	struct drm_device_dma *dma = dev->dma;
-	int i, ret = 0;
+	int i;
 	RING_LOCALS;
 
 	i810_kernel_lost_context(dev);
@@ -878,7 +878,7 @@ static int i810_flush_queue(struct drm_device *dev)
 			DRM_DEBUG("still on client\n");
 	}
 
-	return ret;
+	return 0;
 }
 
 /* Must be called with the lock held */
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 6764ac8..7ccbff6 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -2609,7 +2609,6 @@ static int i9xx_pipe_crc_auto_source(struct drm_device *dev, enum pipe pipe,
 	struct intel_encoder *encoder;
 	struct intel_crtc *crtc;
 	struct intel_digital_port *dig_port;
-	int ret = 0;
 
 	*source = INTEL_PIPE_CRC_SOURCE_PIPE;
 
@@ -2651,7 +2650,7 @@ static int i9xx_pipe_crc_auto_source(struct drm_device *dev, enum pipe pipe,
 	}
 	mutex_unlock(&dev->mode_config.mutex);
 
-	return ret;
+	return 0;
 }
 
 static int vlv_pipe_crc_ctl_reg(struct drm_device *dev,
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 213cd58..e57aa2e 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -497,7 +497,6 @@ ivb_update_colorkey(struct drm_plane *plane,
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_plane *intel_plane;
 	u32 sprctl;
-	int ret = 0;
 
 	intel_plane = to_intel_plane(plane);
 
@@ -515,7 +514,7 @@ ivb_update_colorkey(struct drm_plane *plane,
 
 	POSTING_READ(SPRKEYMSK(intel_plane->pipe));
 
-	return ret;
+	return 0;
 }
 
 static void
@@ -735,7 +734,6 @@ ilk_update_colorkey(struct drm_plane *plane,
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_plane *intel_plane;
 	u32 dvscntr;
-	int ret = 0;
 
 	intel_plane = to_intel_plane(plane);
 
@@ -753,7 +751,7 @@ ilk_update_colorkey(struct drm_plane *plane,
 
 	POSTING_READ(DVSKEYMSK(intel_plane->pipe));
 
-	return ret;
+	return 0;
 }
 
 static void
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 50ec1be..eb1f013 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -722,7 +722,6 @@ static int msm_ioctl_gem_info(struct drm_device *dev, void *data,
 {
 	struct drm_msm_gem_info *args = data;
 	struct drm_gem_object *obj;
-	int ret = 0;
 
 	if (args->pad)
 		return -EINVAL;
@@ -735,7 +734,7 @@ static int msm_ioctl_gem_info(struct drm_device *dev, void *data,
 
 	drm_gem_object_unreference_unlocked(obj);
 
-	return ret;
+	return 0;
 }
 
 static int msm_ioctl_wait_fence(struct drm_device *dev, void *data,
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 8268a4c..2ce3d4b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -2032,7 +2032,6 @@ nouveau_run_vbios_init(struct drm_device *dev)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nvbios *bios = &drm->vbios;
-	int ret = 0;
 
 	/* Reset the BIOS head to 0. */
 	bios->state.crtchead = 0;
@@ -2045,7 +2044,7 @@ nouveau_run_vbios_init(struct drm_device *dev)
 		bios->fp.lvds_init_run = false;
 	}
 
-	return ret;
+	return 0;
 }
 
 static bool
diff --git a/drivers/gpu/drm/omapdrm/omap_drv.c b/drivers/gpu/drm/omapdrm/omap_drv.c
index c8270e4..42b470b 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -423,7 +423,6 @@ static int ioctl_gem_info(struct drm_device *dev, void *data,
 {
 	struct drm_omap_gem_info *args = data;
 	struct drm_gem_object *obj;
-	int ret = 0;
 
 	VERB("%p:%p: handle=%d", dev, file_priv, args->handle);
 
@@ -436,7 +435,7 @@ static int ioctl_gem_info(struct drm_device *dev, void *data,
 
 	drm_gem_object_unreference_unlocked(obj);
 
-	return ret;
+	return 0;
 }
 
 static const struct drm_ioctl_desc ioctls[DRM_COMMAND_END - DRM_COMMAND_BASE] = {
diff --git a/drivers/gpu/drm/tegra/dpaux.c b/drivers/gpu/drm/tegra/dpaux.c
index 005c19b..1ff5146 100644
--- a/drivers/gpu/drm/tegra/dpaux.c
+++ b/drivers/gpu/drm/tegra/dpaux.c
@@ -234,7 +234,6 @@ static ssize_t tegra_dpaux_transfer(struct drm_dp_aux *aux,
 static irqreturn_t tegra_dpaux_irq(int irq, void *data)
 {
 	struct tegra_dpaux *dpaux = data;
-	irqreturn_t ret = IRQ_HANDLED;
 	unsigned long value;
 
 	/* clear interrupts */
@@ -259,7 +258,7 @@ static irqreturn_t tegra_dpaux_irq(int irq, void *data)
 	if (value & DPAUX_INTR_AUX_DONE)
 		complete(&dpaux->complete);
 
-	return ret;
+	return IRQ_HANDLED;
 }
 
 static int tegra_dpaux_probe(struct platform_device *pdev)
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index bb3a996..4c5e675 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -406,7 +406,6 @@ static int i2c_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c, unsigned long iicstat)
 {
 	unsigned long tmp;
 	unsigned char byte;
-	int ret = 0;
 
 	switch (i2c->state) {
 
@@ -562,7 +561,7 @@ static int i2c_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c, unsigned long iicstat)
 	tmp &= ~S3C2410_IICCON_IRQPEND;
 	writel(tmp, i2c->regs + S3C2410_IICCON);
  out:
-	return ret;
+	return 0;
 }
 
 /* s3c24xx_i2c_irq
diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 80f6cf2..889bec7 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -236,7 +236,6 @@ int ib_get_cached_lmc(struct ib_device *device,
 		      u8                *lmc)
 {
 	unsigned long flags;
-	int ret = 0;
 
 	if (port_num < start_port(device) || port_num > end_port(device))
 		return -EINVAL;
@@ -245,7 +244,7 @@ int ib_get_cached_lmc(struct ib_device *device,
 	*lmc = device->cache.lmc_cache[port_num - start_port(device)];
 	read_unlock_irqrestore(&device->cache.lock, flags);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(ib_get_cached_lmc);
 
diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 00400c3..1e1dcf8 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -851,8 +851,6 @@ static void c2_tx_timeout(struct net_device *netdev)
 
 static int c2_change_mtu(struct net_device *netdev, int new_mtu)
 {
-	int ret = 0;
-
 	if (new_mtu < ETH_ZLEN || new_mtu > ETH_JUMBO_MTU)
 		return -EINVAL;
 
@@ -864,7 +862,7 @@ static int c2_change_mtu(struct net_device *netdev, int new_mtu)
 		c2_up(netdev);
 	}
 
-	return ret;
+	return 0;
 }
 
 static const struct net_device_ops c2_netdev = {
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 3488e8c..ccbfb78 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -1854,7 +1854,6 @@ static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
 				  u32 number,
 				  u64 *kpage)
 {
-	int ret = 0;
 	u64 pgaddr;
 	u32 j = 0;
 	int hwpages_per_kpage = PAGE_SIZE / pginfo->hwpage_size;
@@ -1888,7 +1887,7 @@ static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
 			break;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -2001,7 +2000,6 @@ next_kpage:
 static int ehca_set_pagebuf_phys(struct ehca_mr_pginfo *pginfo,
 				 u32 number, u64 *kpage)
 {
-	int ret = 0;
 	struct ib_phys_buf *pbuf;
 	u64 num_hw, offs_hw;
 	u32 i = 0;
@@ -2053,13 +2051,12 @@ static int ehca_set_pagebuf_phys(struct ehca_mr_pginfo *pginfo,
 			pginfo->next_hwpage = 0;
 		}
 	}
-	return ret;
+	return 0;
 }
 
 static int ehca_set_pagebuf_fmr(struct ehca_mr_pginfo *pginfo,
 				u32 number, u64 *kpage)
 {
-	int ret = 0;
 	u64 *fmrlist;
 	u32 i;
 
@@ -2109,7 +2106,7 @@ static int ehca_set_pagebuf_fmr(struct ehca_mr_pginfo *pginfo,
 		}
 		kpage++;
 	}
-	return ret;
+	return 0;
 }
 
 /* setup page buffer from page info */
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 6d7f453..df42118 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -2042,7 +2042,6 @@ static void unlock_expected_tids(struct ipath_portdata *pd)
 
 static int ipath_close(struct inode *in, struct file *fp)
 {
-	int ret = 0;
 	struct ipath_filedata *fd;
 	struct ipath_portdata *pd;
 	struct ipath_devdata *dd;
@@ -2154,7 +2153,7 @@ static int ipath_close(struct inode *in, struct file *fp)
 
 bail:
 	kfree(fd);
-	return ret;
+	return 0;
 }
 
 static int ipath_port_info(struct ipath_portdata *pd, u16 subport,
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 7cc3054..1c14573 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -1353,7 +1353,7 @@ static void ipath_ht_init_hwerrors(struct ipath_devdata *dd)
 static int ipath_ht_bringup_serdes(struct ipath_devdata *dd)
 {
 	u64 val, config1;
-	int ret = 0, change = 0;
+	int change = 0;
 
 	ipath_dbg("Trying to bringup serdes\n");
 
@@ -1452,7 +1452,7 @@ static int ipath_ht_bringup_serdes(struct ipath_devdata *dd)
 		   (unsigned long long)
 		   ipath_read_kreg64(dd, dd->ipath_kregs->kr_xgxsconfig));
 
-	return ret;		/* for now, say we always succeeded */
+	return 0;		/* for now, say we always succeeded */
 }
 
 /**
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index dfa9df4..066c012 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2734,8 +2734,6 @@ static int mini_cm_set(struct nes_cm_core *cm_core, u32 type, u32 value)
  */
 static int nes_cm_init_tsa_conn(struct nes_qp *nesqp, struct nes_cm_node *cm_node)
 {
-	int ret = 0;
-
 	if (!nesqp)
 		return -EINVAL;
 
@@ -2793,7 +2791,7 @@ static int nes_cm_init_tsa_conn(struct nes_qp *nesqp, struct nes_cm_node *cm_nod
 	nes_debug(NES_DBG_CM, "Change cm_node state to TSA\n");
 	cm_node->state = NES_CM_STATE_TSA;
 
-	return ret;
+	return 0;
 }
 
 
@@ -2974,7 +2972,6 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
  */
 static int nes_disconnect(struct nes_qp *nesqp, int abrupt)
 {
-	int ret = 0;
 	struct nes_vnic *nesvnic;
 	struct nes_device *nesdev;
 	struct nes_ib_device *nesibdev;
@@ -3011,7 +3008,7 @@ static int nes_disconnect(struct nes_qp *nesqp, int abrupt)
 		g_cm_core->api->close(g_cm_core, nesqp->cm_node);
 	}
 
-	return ret;
+	return 0;
 }
 
 
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 49eb511..63a865a 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -987,7 +987,6 @@ static int nes_netdev_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct nes_vnic	*nesvnic = netdev_priv(netdev);
 	struct nes_device *nesdev = nesvnic->nesdev;
-	int ret = 0;
 	u8 jumbomode = 0;
 	u32 nic_active;
 	u32 nic_active_bit;
@@ -1026,7 +1025,7 @@ static int nes_netdev_change_mtu(struct net_device *netdev, int new_mtu)
 		nes_write_indexed(nesdev, NES_IDX_NIC_UNICAST_ALL, nic_active);
 	}
 
-	return ret;
+	return 0;
 }
 
 
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 2042c0f..ecde9df 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -58,7 +58,6 @@ u32 mh_pauses_sent;
 
 static u32 nes_set_pau(struct nes_device *nesdev)
 {
-	u32 ret = 0;
 	u32 counter;
 
 	nes_write_indexed(nesdev, NES_IDX_GPR2, NES_ENABLE_PAU);
@@ -76,7 +75,7 @@ static u32 nes_set_pau(struct nes_device *nesdev)
 		printk(KERN_INFO PFX "PAU is not supported.\n");
 		return -EPERM;
 	}
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index b15e34e..2989257 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1803,7 +1803,6 @@ static void unlock_expected_tids(struct qib_ctxtdata *rcd)
 
 static int qib_close(struct inode *in, struct file *fp)
 {
-	int ret = 0;
 	struct qib_filedata *fd;
 	struct qib_ctxtdata *rcd;
 	struct qib_devdata *dd;
@@ -1889,7 +1888,7 @@ static int qib_close(struct inode *in, struct file *fp)
 
 bail:
 	kfree(fd);
-	return ret;
+	return 0;
 }
 
 static int qib_ctxt_info(struct file *fp, struct qib_ctxt_info __user *uinfo)
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index a7eb325..d0fc5ae 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2383,7 +2383,6 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	struct qib_devdata *dd = ppd->dd;
 	u64 val, guid, ibc;
 	unsigned long flags;
-	int ret = 0;
 
 	/*
 	 * SerDes model not in Pd, but still need to
@@ -2518,7 +2517,7 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 		val | ERR_MASK_N(IBStatusChanged));
 
 	/* Always zero until we start messing with SerDes for real */
-	return ret;
+	return 0;
 }
 
 /**
@@ -6921,7 +6920,7 @@ static int init_sdma_7322_regs(struct qib_pportdata *ppd)
 	struct qib_devdata *dd = ppd->dd;
 	unsigned lastbuf, erstbuf;
 	u64 senddmabufmask[3] = { 0 };
-	int n, ret = 0;
+	int n;
 
 	qib_write_kreg_port(ppd, krp_senddmabase, ppd->sdma_descq_phys);
 	qib_sdma_7322_setlengen(ppd);
@@ -6951,7 +6950,7 @@ static int init_sdma_7322_regs(struct qib_pportdata *ppd)
 	qib_write_kreg_port(ppd, krp_senddmabufmask0, senddmabufmask[0]);
 	qib_write_kreg_port(ppd, krp_senddmabufmask1, senddmabufmask[1]);
 	qib_write_kreg_port(ppd, krp_senddmabufmask2, senddmabufmask[2]);
-	return ret;
+	return 0;
 }
 
 /* sdma_lock must be held */
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 0cad0c4..0bf62fd 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -1320,7 +1320,6 @@ int qib_qp_iter_next(struct qib_qp_iter *iter)
 {
 	struct qib_ibdev *dev = iter->dev;
 	int n = iter->n;
-	int ret = 1;
 	struct qib_qp *pqp = iter->qp;
 	struct qib_qp *qp;
 
@@ -1344,7 +1343,7 @@ int qib_qp_iter_next(struct qib_qp_iter *iter)
 	rcu_read_unlock();
 	if (iter->qp)
 		atomic_dec(&iter->qp->refcount);
-	return ret;
+	return 1;
 }
 
 static const char * const qp_type_str[] = {
diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
index d79a646..3b297b4 100644
--- a/drivers/mailbox/omap-mailbox.c
+++ b/drivers/mailbox/omap-mailbox.c
@@ -76,7 +76,7 @@ static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
  */
 static int __mbox_poll_for_space(struct omap_mbox *mbox)
 {
-	int ret = 0, i = 1000;
+	int i = 1000;
 
 	while (mbox_fifo_full(mbox)) {
 		if (mbox->ops->type == OMAP_MBOX_TYPE2)
@@ -85,7 +85,7 @@ static int __mbox_poll_for_space(struct omap_mbox *mbox)
 			return -1;
 		udelay(1);
 	}
-	return ret;
+	return 0;
 }
 
 int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg)
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b1f1d5..a99cb75 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -245,8 +245,6 @@ void bch_debug_exit(void)
 
 int __init bch_debug_init(struct kobject *kobj)
 {
-	int ret = 0;
-
 	debug = debugfs_create_dir("bcache", NULL);
-	return ret;
+	return 0;
 }
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 2d768ef..8067baf 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1311,7 +1311,6 @@ static int s5k5baf_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
 	struct s5k5baf *state = to_s5k5baf(sd);
 	const struct s5k5baf_pixfmt *pixfmt;
-	int ret = 0;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		*v4l2_subdev_get_try_format(fh, fmt->pad) = *mf;
@@ -1338,7 +1337,7 @@ static int s5k5baf_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	mf->height = state->crop_source.height;
 
 	mutex_unlock(&state->lock);
-	return ret;
+	return 0;
 }
 
 enum selection_rect { R_CIS, R_CROP_SINK, R_COMPOSE, R_CROP_SOURCE, R_INVALID };
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 7acd19c..ebf9626 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -192,7 +192,6 @@ static int media_open(struct inode *inode, struct file *filp)
 static int media_release(struct inode *inode, struct file *filp)
 {
 	struct media_devnode *mdev = media_devnode_data(filp);
-	int ret = 0;
 
 	if (mdev->fops->release)
 		mdev->fops->release(filp);
@@ -201,7 +200,7 @@ static int media_release(struct inode *inode, struct file *filp)
 	   return value is ignored. */
 	put_device(&mdev->dev);
 	filp->private_data = NULL;
-	return ret;
+	return 0;
 }
 
 static const struct file_operations media_devnode_fops = {
diff --git a/drivers/media/pci/saa7164/saa7164-api.c b/drivers/media/pci/saa7164/saa7164-api.c
index e042963..4f3b1dd 100644
--- a/drivers/media/pci/saa7164/saa7164-api.c
+++ b/drivers/media/pci/saa7164/saa7164-api.c
@@ -680,7 +680,6 @@ static int saa7164_api_set_dif(struct saa7164_port *port, u8 reg, u8 val)
 int saa7164_api_configure_dif(struct saa7164_port *port, u32 std)
 {
 	struct saa7164_dev *dev = port->dev;
-	int ret = 0;
 	u8 agc_disable;
 
 	dprintk(DBGLVL_API, "%s(nr=%d, 0x%x)\n", __func__, port->nr, std);
@@ -733,7 +732,7 @@ int saa7164_api_configure_dif(struct saa7164_port *port, u32 std)
 	saa7164_api_set_dif(port, 0x04, 0x00); /* Active (again) */
 	msleep(100);
 
-	return ret;
+	return 0;
 }
 
 /* Ensure the dif is in the correct state for the operating mode
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 33b9660..5e95522 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -497,7 +497,6 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
 	struct v4l2_dv_timings dv_timings;
 	struct osd_state *osd_device;
 	int out_index = vpbe_dev->current_out_index;
-	int ret = 0;
 	int i;
 
 	if ((NULL == mode_info) || (NULL == mode_info->name))
@@ -538,7 +537,7 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
 
 	mutex_unlock(&vpbe_dev->lock);
 
-	return ret;
+	return 0;
 }
 
 static int vpbe_set_default_mode(struct vpbe_device *vpbe_dev)
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index ac6c8c6..33fd2db 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -943,12 +943,11 @@ static int vpfe_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
-	int ret = 0;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_fmt_vid_cap\n");
 	/* Fill in the information about format */
 	*fmt = vpfe_dev->fmt;
-	return ret;
+	return 0;
 }
 
 static int vpfe_enum_fmt_vid_cap(struct file *file, void  *priv,
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index ced4660..a983223 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -313,7 +313,6 @@ static int isp_video_release(struct file *file)
 	struct fimc_is_video *ivc = &isp->video_capture;
 	struct media_entity *entity = &ivc->ve.vdev.entity;
 	struct media_device *mdev = entity->parent;
-	int ret = 0;
 
 	mutex_lock(&isp->video_lock);
 
@@ -335,7 +334,7 @@ static int isp_video_release(struct file *file)
 	pm_runtime_put(&isp->pdev->dev);
 	mutex_unlock(&isp->video_lock);
 
-	return ret;
+	return 0;
 }
 
 static const struct v4l2_file_operations isp_video_fops = {
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 630aef5..5cb8ee2 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1200,7 +1200,6 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	struct flite_frame *f = &fimc->inp_frame;
-	int ret = 0;
 
 	if (sel->target != V4L2_SEL_TGT_CROP || sel->pad != FLITE_SD_PAD_SINK)
 		return -EINVAL;
@@ -1225,7 +1224,7 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 		 __func__, f->rect.left, f->rect.top, f->rect.width,
 		 f->rect.height, f->f_width, f->f_height);
 
-	return ret;
+	return 0;
 }
 
 static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 46b66e5..2dd6251 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -148,7 +148,6 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 	u8 vendor_major, vendor_minor;
 	u8 portsel, ir_class;
 	u16 vendor, chip;
-	int ret = 0;
 
 	fintek_config_mode_enable(fintek);
 
@@ -208,7 +207,7 @@ static int fintek_hw_detect(struct fintek_dev *fintek)
 
 	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static void fintek_cir_ldev_init(struct fintek_dev *fintek)
@@ -644,7 +643,6 @@ static int fintek_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 static int fintek_resume(struct pnp_dev *pdev)
 {
-	int ret = 0;
 	struct fintek_dev *fintek = pnp_get_drvdata(pdev);
 
 	fit_dbg("%s called", __func__);
@@ -661,7 +659,7 @@ static int fintek_resume(struct pnp_dev *pdev)
 
 	fintek_cir_regs_init(fintek);
 
-	return ret;
+	return 0;
 }
 
 static void fintek_shutdown(struct pnp_dev *pdev)
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index ab24cc6..b98234c 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1666,7 +1666,6 @@ static int ite_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 static int ite_resume(struct pnp_dev *pdev)
 {
-	int ret = 0;
 	struct ite_dev *dev = pnp_get_drvdata(pdev);
 	unsigned long flags;
 
@@ -1681,7 +1680,7 @@ static int ite_resume(struct pnp_dev *pdev)
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static void ite_shutdown(struct pnp_dev *pdev)
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index d244e1a..9f6d171 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -229,7 +229,6 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 {
 	unsigned long flags;
 	u8 chip_major, chip_minor;
-	int ret = 0;
 	char chip_id[12];
 	bool chip_unknown = false;
 
@@ -285,7 +284,7 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 	nvt->chip_minor = chip_minor;
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static void nvt_cir_ldev_init(struct nvt_dev *nvt)
@@ -1177,7 +1176,6 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 static int nvt_resume(struct pnp_dev *pdev)
 {
-	int ret = 0;
 	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
 
 	nvt_dbg("%s called", __func__);
@@ -1195,7 +1193,7 @@ static int nvt_resume(struct pnp_dev *pdev)
 	nvt_cir_regs_init(nvt);
 	nvt_cir_wake_regs_init(nvt);
 
-	return ret;
+	return 0;
 }
 
 static void nvt_shutdown(struct pnp_dev *pdev)
diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index 13381de..b87b254 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -157,7 +157,6 @@ static int mt2060_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2060_priv *priv;
-	int ret=0;
 	int i=0;
 	u32 freq;
 	u8  lnaband;
@@ -240,7 +239,7 @@ static int mt2060_set_params(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
 
-	return ret;
+	return 0;
 }
 
 static void mt2060_calibrate(struct mt2060_priv *priv)
diff --git a/drivers/media/tuners/mt2266.c b/drivers/media/tuners/mt2266.c
index bca4d75..3d84637 100644
--- a/drivers/media/tuners/mt2266.c
+++ b/drivers/media/tuners/mt2266.c
@@ -126,7 +126,6 @@ static int mt2266_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2266_priv *priv;
-	int ret=0;
 	u32 freq;
 	u32 tune;
 	u8  lnaband;
@@ -240,7 +239,7 @@ static int mt2266_set_params(struct dvb_frontend *fe)
 
 	priv->band = band;
 
-	return ret;
+	return 0;
 }
 
 static void mt2266_calibrate(struct mt2266_priv *priv)
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 351a78a..8a6e3d9 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -456,8 +456,6 @@ static int configure_transfer_mode(struct camera_data *cam, unsigned int alt)
 int cpia2_usb_change_streaming_alternate(struct camera_data *cam,
 					 unsigned int alt)
 {
-	int ret = 0;
-
 	if(alt < USBIF_ISO_1 || alt > USBIF_ISO_6)
 		return -EINVAL;
 
@@ -475,7 +473,7 @@ int cpia2_usb_change_streaming_alternate(struct camera_data *cam,
 
 	cpia2_usb_stream_resume(cam);
 
-	return ret;
+	return 0;
 }
 
 /******************************************************************************
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 07e6e27..8b4053a 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -69,8 +69,6 @@ EXPORT_SYMBOL_GPL(arizona_clk32k_enable);
 
 int arizona_clk32k_disable(struct arizona *arizona)
 {
-	int ret = 0;
-
 	mutex_lock(&arizona->clk_lock);
 
 	BUG_ON(arizona->clk32k_ref <= 0);
@@ -90,7 +88,7 @@ int arizona_clk32k_disable(struct arizona *arizona)
 
 	mutex_unlock(&arizona->clk_lock);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(arizona_clk32k_disable);
 
diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index d7b2a75..f5ab565 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -337,7 +337,6 @@ static int htcpld_setup_chip_irq(
 	struct htcpld_chip *chip;
 	struct htcpld_chip_platform_data *plat_chip_data;
 	unsigned int irq, irq_end;
-	int ret = 0;
 
 	/* Get the platform and driver data */
 	pdata = dev_get_platdata(dev);
@@ -358,7 +357,7 @@ static int htcpld_setup_chip_irq(
 #endif
 	}
 
-	return ret;
+	return 0;
 }
 
 static int htcpld_register_chip_i2c(
diff --git a/drivers/mfd/pcf50633-irq.c b/drivers/mfd/pcf50633-irq.c
index 498286c..71d43ed 100644
--- a/drivers/mfd/pcf50633-irq.c
+++ b/drivers/mfd/pcf50633-irq.c
@@ -55,7 +55,7 @@ EXPORT_SYMBOL_GPL(pcf50633_free_irq);
 static int __pcf50633_irq_mask_set(struct pcf50633 *pcf, int irq, u8 mask)
 {
 	u8 reg, bit;
-	int ret = 0, idx;
+	int idx;
 
 	idx = irq >> 3;
 	reg = PCF50633_REG_INT1M + idx;
@@ -72,7 +72,7 @@ static int __pcf50633_irq_mask_set(struct pcf50633 *pcf, int irq, u8 mask)
 
 	mutex_unlock(&pcf->lock);
 
-	return ret;
+	return 0;
 }
 
 int pcf50633_irq_mask(struct pcf50633 *pcf, int irq)
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 4fa8fef9..ba00610 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -168,7 +168,6 @@ static int sdio_bus_remove(struct device *dev)
 {
 	struct sdio_driver *drv = to_sdio_driver(dev->driver);
 	struct sdio_func *func = dev_to_sdio_func(dev);
-	int ret = 0;
 
 	/* Make sure card is powered before invoking ->remove() */
 	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD)
@@ -192,7 +191,7 @@ static int sdio_bus_remove(struct device *dev)
 	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD)
 		pm_runtime_put_sync(dev);
 
-	return ret;
+	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 255aaf1..ccd4452 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2678,7 +2678,6 @@ static void sdhci_runtime_pm_bus_off(struct sdhci_host *host)
 int sdhci_runtime_suspend_host(struct sdhci_host *host)
 {
 	unsigned long flags;
-	int ret = 0;
 
 	/* Disable tuning since we are suspending */
 	if (host->flags & SDHCI_USING_RETUNING_TIMER) {
@@ -2696,14 +2695,14 @@ int sdhci_runtime_suspend_host(struct sdhci_host *host)
 	host->runtime_suspended = true;
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(sdhci_runtime_suspend_host);
 
 int sdhci_runtime_resume_host(struct sdhci_host *host)
 {
 	unsigned long flags;
-	int ret = 0, host_flags = host->flags;
+	int host_flags = host->flags;
 
 	if (host_flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma)
@@ -2742,7 +2741,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(sdhci_runtime_resume_host);
 
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 1ca9aec..5bab355 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -542,7 +542,6 @@ int mtd_add_partition(struct mtd_info *master, const char *name,
 	struct mtd_partition part;
 	struct mtd_part *p, *new;
 	uint64_t start, end;
-	int ret = 0;
 
 	/* the direct offset is expected */
 	if (offset == MTDPART_OFS_APPEND ||
@@ -585,7 +584,7 @@ int mtd_add_partition(struct mtd_info *master, const char *name,
 
 	add_mtd_device(&new->mtd);
 
-	return ret;
+	return 0;
 err_inv:
 	mutex_unlock(&mtd_partitions_mutex);
 	free_partition(new);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 3a8e51e..7cff7e8 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1367,7 +1367,6 @@ int bnx2x_send_final_clnup(struct bnx2x *bp, u8 clnup_func, u32 poll_cnt)
 	u32 op_gen_command = 0;
 	u32 comp_addr = BAR_CSTRORM_INTMEM +
 			CSTORM_FINAL_CLEANUP_COMPLETE_OFFSET(clnup_func);
-	int ret = 0;
 
 	if (REG_RD(bp, comp_addr)) {
 		BNX2X_ERR("Cleanup complete was not 0 before sending\n");
@@ -1392,7 +1391,7 @@ int bnx2x_send_final_clnup(struct bnx2x *bp, u8 clnup_func, u32 poll_cnt)
 	/* Zero completion for next FLR */
 	REG_WR(bp, comp_addr, 0);
 
-	return ret;
+	return 0;
 }
 
 u8 bnx2x_is_pcie_pending(struct pci_dev *dev)
diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index cc83350..f9e1190 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -235,7 +235,7 @@ uec_set_ringparam(struct net_device *netdev,
 {
 	struct ucc_geth_private *ugeth = netdev_priv(netdev);
 	struct ucc_geth_info *ug_info = ugeth->ug_info;
-	int queue = 0, ret = 0;
+	int queue = 0;
 
 	if (ring->rx_pending < UCC_GETH_RX_BD_RING_SIZE_MIN) {
 		netdev_info(netdev, "RxBD ring size must be no smaller than %d\n",
@@ -261,7 +261,7 @@ uec_set_ringparam(struct net_device *netdev,
 		netdev_info(netdev, "Please re-open the interface\n");
 	}
 
-	return ret;
+	return 0;
 }
 
 static int uec_get_sset_count(struct net_device *netdev, int sset)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_dcb.c b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
index 036570d..28956c5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_dcb.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
@@ -327,7 +327,6 @@ static void i40e_parse_org_tlv(struct i40e_lldp_org_tlv *tlv,
 i40e_status i40e_lldp_to_dcb_config(u8 *lldpmib,
 				    struct i40e_dcbx_config *dcbcfg)
 {
-	i40e_status ret = 0;
 	struct i40e_lldp_org_tlv *tlv;
 	u16 type;
 	u16 length;
@@ -366,7 +365,7 @@ i40e_status i40e_lldp_to_dcb_config(u8 *lldpmib,
 						    length);
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index 089b713..35450fa 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -120,7 +120,6 @@ __vxge_hw_device_register_poll(void __iomem *reg, u64 mask, u32 max_millis)
 {
 	u64 val64;
 	u32 i = 0;
-	enum vxge_hw_status ret = VXGE_HW_FAIL;
 
 	udelay(10);
 
@@ -139,7 +138,7 @@ __vxge_hw_device_register_poll(void __iomem *reg, u64 mask, u32 max_millis)
 		mdelay(1);
 	} while (++i <= max_millis);
 
-	return ret;
+	return VXGE_HW_FAIL;
 }
 
 static inline enum vxge_hw_status
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index a4a4ec0..62e76a8 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3040,7 +3040,7 @@ void qlcnic_83xx_unlock_driver(struct qlcnic_adapter *adapter)
 int qlcnic_ms_mem_write128(struct qlcnic_adapter *adapter, u64 addr,
 				u32 *data, u32 count)
 {
-	int i, j, ret = 0;
+	int i, j;
 	u32 temp;
 
 	/* Check alignment */
@@ -3085,7 +3085,7 @@ int qlcnic_ms_mem_write128(struct qlcnic_adapter *adapter, u64 addr,
 
 	mutex_unlock(&adapter->ahw->mem_lock);
 
-	return ret;
+	return 0;
 }
 
 int qlcnic_83xx_flash_read32(struct qlcnic_adapter *adapter, u32 flash_addr,
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 539dbde..f6b0f49 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -449,7 +449,7 @@ EXPORT_SYMBOL_GPL(cpdma_ctlr_dump);
 int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr)
 {
 	unsigned long flags;
-	int ret = 0, i;
+	int i;
 
 	if (!ctlr)
 		return -EINVAL;
@@ -463,7 +463,7 @@ int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr)
 
 	cpdma_desc_pool_destroy(ctlr->pool);
 	spin_unlock_irqrestore(&ctlr->lock, flags);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(cpdma_ctlr_destroy);
 
diff --git a/drivers/net/irda/mcs7780.c b/drivers/net/irda/mcs7780.c
index 16f8ffb..8c0a6d1 100644
--- a/drivers/net/irda/mcs7780.c
+++ b/drivers/net/irda/mcs7780.c
@@ -668,7 +668,6 @@ static int mcs_net_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 /* Network device is taken down, done by "ifconfig irda0 down" */
 static int mcs_net_close(struct net_device *netdev)
 {
-	int ret = 0;
 	struct mcs_cb *mcs = netdev_priv(netdev);
 
 	/* Stop transmit processing */
@@ -687,7 +686,7 @@ static int mcs_net_close(struct net_device *netdev)
 		irlap_close(mcs->irlap);
 
 	mcs->irlap = NULL;
-	return ret;
+	return 0;
 }
 
 /* Network device is taken up, done by "ifconfig irda0 up" */
diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
index 2900af0..bca1828 100644
--- a/drivers/net/irda/via-ircc.c
+++ b/drivers/net/irda/via-ircc.c
@@ -926,7 +926,6 @@ static int via_ircc_dma_xmit(struct via_ircc_cb *self, u16 iobase)
 static int via_ircc_dma_xmit_complete(struct via_ircc_cb *self)
 {
 	int iobase;
-	int ret = TRUE;
 	u8 Tx_status;
 
 	IRDA_DEBUG(3, "%s()\n", __func__);
@@ -983,7 +982,7 @@ F01_E*/
 	// Tell the network layer, that we can accept more frames 
 	netif_wake_queue(self->netdev);
 //F01   }
-	return ret;
+	return TRUE;
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 94d34ee..673ab8d 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1707,7 +1707,7 @@ ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 offset;
 	u16 val;
-	int ret = 0, i;
+	int i;
 
 	offset = AR5K_EEPROM_CTL(ee->ee_version) +
 				AR5K_EEPROM_N_CTLS(ee->ee_version);
@@ -1730,7 +1730,7 @@ ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 4ab5370..85587f8 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -919,8 +919,6 @@ static const struct ieee80211_ops wcn36xx_ops = {
 
 static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 {
-	int ret = 0;
-
 	static const u32 cipher_suites[] = {
 		WLAN_CIPHER_SUITE_WEP40,
 		WLAN_CIPHER_SUITE_WEP104,
@@ -961,7 +959,7 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 	wcn->hw->sta_data_size = sizeof(struct wcn36xx_sta);
 	wcn->hw->vif_data_size = sizeof(struct wcn36xx_vif);
 
-	return ret;
+	return 0;
 }
 
 static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 40078f5..29f6b3f 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -273,13 +273,11 @@ exit:
 
 static int cw1200_spi_irq_unsubscribe(struct hwbus_priv *self)
 {
-	int ret = 0;
-
 	pr_debug("SW IRQ unsubscribe\n");
 	disable_irq_wake(self->func->irq);
 	free_irq(self->func->irq, self);
 
-	return ret;
+	return 0;
 }
 
 static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index cd0cad7..5b84664 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -2289,7 +2289,6 @@ static int cw1200_upload_null(struct cw1200_common *priv)
 
 static int cw1200_upload_qosnull(struct cw1200_common *priv)
 {
-	int ret = 0;
 	/* TODO:  This needs to be implemented
 
 	struct wsm_template_frame frame = {
@@ -2306,7 +2305,7 @@ static int cw1200_upload_qosnull(struct cw1200_common *priv)
 	dev_kfree_skb(frame.skb);
 
 	*/
-	return ret;
+	return 0;
 }
 
 static int cw1200_enable_beaconing(struct cw1200_common *priv,
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index c5aa404..82feb71 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -7159,20 +7159,19 @@ static int ipw_qos_association(struct ipw_priv *priv,
 static int ipw_qos_association_resp(struct ipw_priv *priv,
 				    struct libipw_network *network)
 {
-	int ret = 0;
 	unsigned long flags;
 	u32 size = sizeof(struct libipw_qos_parameters);
 	int set_qos_param = 0;
 
 	if ((priv == NULL) || (network == NULL) ||
 	    (priv->assoc_network == NULL))
-		return ret;
+		return 0;
 
 	if (!(priv->status & STATUS_ASSOCIATED))
-		return ret;
+		return 0;
 
 	if ((priv->ieee->iw_mode != IW_MODE_INFRA))
-		return ret;
+		return 0;
 
 	spin_lock_irqsave(&priv->ieee->lock, flags);
 	if (network->flags & NETWORK_HAS_QOS_PARAMETERS) {
@@ -7203,7 +7202,7 @@ static int ipw_qos_association_resp(struct ipw_priv *priv,
 	if (set_qos_param == 1)
 		schedule_work(&priv->qos_activate);
 
-	return ret;
+	return 0;
 }
 
 static u32 ipw_qos_get_burst_duration(struct ipw_priv *priv)
@@ -10768,8 +10767,6 @@ static void ipw_bg_link_down(struct work_struct *work)
 
 static int ipw_setup_deferred_work(struct ipw_priv *priv)
 {
-	int ret = 0;
-
 	init_waitqueue_head(&priv->wait_command_queue);
 	init_waitqueue_head(&priv->wait_state);
 
@@ -10804,7 +10801,7 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 		     ipw_irq_tasklet, (unsigned long)priv);
 
-	return ret;
+	return 0;
 }
 
 static void shim__set_security(struct net_device *dev,
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index dc1d20c..d34e95b 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -244,9 +244,7 @@ il3945_set_dynamic_key(struct il_priv *il, struct ieee80211_key_conf *keyconf,
 static int
 il3945_remove_static_key(struct il_priv *il)
 {
-	int ret = -EOPNOTSUPP;
-
-	return ret;
+	return -EOPNOTSUPP;
 }
 
 static int
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c159c05..cdf1792 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -3348,7 +3348,6 @@ il4965_set_tkip_dynamic_key_info(struct il_priv *il,
 				 struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	unsigned long flags;
-	int ret = 0;
 	__le16 key_flags = 0;
 
 	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
@@ -3385,7 +3384,7 @@ il4965_set_tkip_dynamic_key_info(struct il_priv *il,
 
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 void
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index fe47db9..4c59879 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -430,7 +430,6 @@ il4965_set_ucode_ptrs(struct il_priv *il)
 {
 	dma_addr_t pinst;
 	dma_addr_t pdata;
-	int ret = 0;
 
 	/* bits 35:4 for 4965 */
 	pinst = il->ucode_code.p_addr >> 4;
@@ -447,7 +446,7 @@ il4965_set_ucode_ptrs(struct il_priv *il)
 		   il->ucode_code.len | BSM_DRAM_INST_LOAD);
 	D_INFO("Runtime uCode pointers are set.\n");
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index d75f4eb..433e500 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1135,7 +1135,6 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				    struct mwifiex_bssdescriptor *bss_entry)
 {
-	int ret = 0;
 	u8 element_id;
 	struct ieee_types_fh_param_set *fh_param_set;
 	struct ieee_types_ds_param_set *ds_param_set;
@@ -1365,7 +1364,7 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		bytes_left -= (element_len + 2);
 
 	}	/* while (bytes_left > 2) */
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c17fcf2..df595749 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7926,7 +7926,6 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			u8 buf_size)
 {
 	struct rt2x00_sta *sta_priv = (struct rt2x00_sta *)sta->drv_priv;
-	int ret = 0;
 
 	/*
 	 * Don't allow aggregation for stations the hardware isn't aware
@@ -7963,7 +7962,7 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    "Unknown AMPDU action\n");
 	}
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_ampdu_action);
 
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index e8c19de..612a15e 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -397,7 +397,6 @@ int pcmcia_release_configuration(struct pcmcia_device *p_dev)
 static int pcmcia_release_io(struct pcmcia_device *p_dev)
 {
 	struct pcmcia_socket *s = p_dev->socket;
-	int ret = -EINVAL;
 	config_t *c;
 
 	mutex_lock(&s->ops_mutex);
@@ -417,7 +416,7 @@ static int pcmcia_release_io(struct pcmcia_device *p_dev)
 out:
 	mutex_unlock(&s->ops_mutex);
 
-	return ret;
+	return -EINVAL;
 } /* pcmcia_release_io */
 
 
diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 5c44feb..54f085b 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -380,7 +380,6 @@ static int adi_gpio_irq_type(struct irq_data *d, unsigned int type)
 	struct gpio_pint_regs *pint_regs;
 	unsigned pintmask;
 	unsigned int irq = d->irq;
-	int ret = 0;
 	char buf[16];
 
 	if (!port) {
@@ -437,7 +436,7 @@ out:
 	spin_unlock(&port->pint->lock);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 8f6f16e..584b511 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1480,8 +1480,6 @@ static const struct nmk_cfg_param nmk_cfg_params[] = {
 
 static int nmk_dt_pin_config(int index, int val, unsigned long *config)
 {
-	int ret = 0;
-
 	if (nmk_cfg_params[index].choice == NULL)
 		*config = nmk_cfg_params[index].config;
 	else {
@@ -1491,7 +1489,7 @@ static int nmk_dt_pin_config(int index, int val, unsigned long *config)
 				nmk_cfg_params[index].choice[val];
 		}
 	}
-	return ret;
+	return 0;
 }
 
 static const char *nmk_find_pin_name(struct pinctrl_dev *pctldev, const char *pin_name)
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 62c15af..50252f7 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -463,7 +463,6 @@ static int pm2_int_reg4(void *pm2_data, int val)
 static int pm2_int_reg5(void *pm2_data, int val)
 {
 	struct pm2xxx_charger *pm2 = pm2_data;
-	int ret = 0;
 
 	if (val & (PM2XXX_INT6_ITVPWR2DROP | PM2XXX_INT6_ITVPWR1DROP)) {
 		dev_dbg(pm2->dev, "VMPWR drop to VBAT level\n");
@@ -476,7 +475,7 @@ static int pm2_int_reg5(void *pm2_data, int val)
 		dev_dbg(pm2->dev, "Falling/Rising edge on WPWR1/2\n");
 	}
 
-	return ret;
+	return 0;
 }
 
 static irqreturn_t  pm2xxx_irq_int(int irq, void *data)
diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index b1cda6f..42dad7b 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1095,7 +1095,6 @@ static int rapl_register_powercap(void)
 {
 	struct rapl_domain *rd;
 	struct rapl_package *rp;
-	int ret = 0;
 
 	control_type = powercap_register_control_type(NULL, "intel-rapl", NULL);
 	if (IS_ERR(control_type)) {
@@ -1107,7 +1106,7 @@ static int rapl_register_powercap(void)
 	list_for_each_entry(rp, &rapl_packages, plist)
 		if (rapl_package_register_powercap(rp))
 			goto err_cleanup_package;
-	return ret;
+	return 0;
 
 err_cleanup_package:
 	/* clean up previously initialized packages */
@@ -1120,7 +1119,7 @@ err_cleanup_package:
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rapl_check_domain(int cpu, int domain)
diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index 84419af..7e3e609 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -297,7 +297,6 @@ static int create_constraints(struct powercap_zone *power_zone,
 				struct powercap_zone_constraint_ops *const_ops)
 {
 	int i;
-	int ret = 0;
 	int count;
 	struct powercap_zone_constraint *pconst;
 
@@ -335,7 +334,7 @@ static int create_constraints(struct powercap_zone *power_zone,
 	}
 	power_zone->zone_attr_count = count;
 
-	return ret;
+	return 0;
 }
 
 static bool control_type_valid(void *control_type)
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 5813fa5..acf3989 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -950,12 +950,11 @@ int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer *timer,
  */
 int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer *timer)
 {
-	int ret = 0;
 	mutex_lock(&rtc->ops_lock);
 	if (timer->enabled)
 		rtc_timer_remove(rtc, timer);
 	mutex_unlock(&rtc->ops_lock);
-	return ret;
+	return 0;
 }
 
 
diff --git a/drivers/s390/cio/eadm_sch.c b/drivers/s390/cio/eadm_sch.c
index 3a2ee4a..27fc0c4 100644
--- a/drivers/s390/cio/eadm_sch.c
+++ b/drivers/s390/cio/eadm_sch.c
@@ -336,7 +336,6 @@ static int eadm_subchannel_sch_event(struct subchannel *sch, int process)
 {
 	struct eadm_private *private;
 	unsigned long flags;
-	int ret = 0;
 
 	spin_lock_irqsave(sch->lock, flags);
 	if (!device_is_registered(&sch->dev))
@@ -356,7 +355,7 @@ static int eadm_subchannel_sch_event(struct subchannel *sch, int process)
 out_unlock:
 	spin_unlock_irqrestore(sch->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static struct css_device_id eadm_subchannel_ids[] = {
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..0495a3d 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2027,7 +2027,6 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 	struct cnic_dev *cnic;
 	struct iscsi_session *session = NULL;
 	struct iscsi_conn *conn = NULL;
-	int ret = 0;
 	int close = 0;
 	int close_ret = 0;
 
@@ -2104,7 +2103,7 @@ destroy_conn:
 		return -EINVAL;
 out:
 	bnx2i_ep->state = EP_STATE_IDLE;
-	return ret;
+	return 0;
 }
 
 
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 56e3809..56c55fe 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3444,7 +3444,6 @@ int isci_request_execute(struct isci_host *ihost, struct isci_remote_device *ide
 	enum sci_status status = SCI_FAILURE_UNSUPPORTED_PROTOCOL;
 	struct isci_request *ireq;
 	unsigned long flags;
-	int ret = 0;
 
 	/* do common allocation and init of request object. */
 	ireq = isci_io_request_from_tag(ihost, task, tag);
@@ -3524,5 +3523,5 @@ int isci_request_execute(struct isci_host *ihost, struct isci_remote_device *ide
 		status = SCI_SUCCESS;
 	}
 
-	return ret;
+	return 0;
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 462453e..ef40ba3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1900,8 +1900,6 @@ static int
 lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		uint8_t *txop, uint8_t *rxop)
 {
-	uint8_t ret = 0;
-
 	if (lpfc_cmd_guard_csum(sc)) {
 		switch (scsi_get_prot_op(sc)) {
 		case SCSI_PROT_READ_INSERT:
@@ -1953,7 +1951,7 @@ lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 #endif
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2260041..f046f06 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -801,7 +801,7 @@ megasas_get_map_info(struct megasas_instance *instance)
 int
 megasas_sync_map_info(struct megasas_instance *instance)
 {
-	int ret = 0, i;
+	int i;
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 	u32 size_sync_info, num_lds;
@@ -872,7 +872,7 @@ megasas_sync_map_info(struct megasas_instance *instance)
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index a3dd55d..d3786e9 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -494,7 +494,6 @@ static int sun3scsi_dma_start(unsigned long count, char *data)
 static int sun3scsi_dma_finish(int write_flag)
 {
 	unsigned short fifo;
-	int ret = 0;
 	
 	sun3_dma_active = 0;
 
@@ -562,7 +561,7 @@ static int sun3scsi_dma_finish(int write_flag)
 #endif	
 	sun3_dma_setup_done = NULL;
 
-	return ret;
+	return 0;
 
 }
 
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 05ce2a2..7d57712 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -168,7 +168,6 @@ static inline int gdm_wimax_header(struct sk_buff **pskb)
 {
 	u16 buf[HCI_HEADER_SIZE / sizeof(u16)];
 	struct sk_buff *skb = *pskb;
-	int ret = 0;
 
 	if (unlikely(skb_headroom(skb) < HCI_HEADER_SIZE)) {
 		struct sk_buff *skb2;
@@ -188,7 +187,7 @@ static inline int gdm_wimax_header(struct sk_buff **pskb)
 	memcpy(skb->data, buf, HCI_HEADER_SIZE);
 
 	*pskb = skb;
-	return ret;
+	return 0;
 }
 
 static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c
index 8dc5c72..a840205 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c
@@ -260,7 +260,6 @@ __u32 g_get_mech_oid(rawobj_t *mech, rawobj_t *in_buf)
 {
 	unsigned char *buf = in_buf->data;
 	int len = in_buf->len;
-	int ret = 0;
 	int seqsize;
 
 	len -= 1;
@@ -292,5 +291,5 @@ __u32 g_get_mech_oid(rawobj_t *mech, rawobj_t *in_buf)
 		return (G_BUFFER_ALLOC);
 	memcpy(mech->data, buf, mech->len);
 
-	return ret;
+	return 0;
 }
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index e4a6945..e6f6278 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -249,7 +249,7 @@ static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
 
 static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 {
-	int i, ret = 0;
+	int i;
 
 	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
 				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
@@ -280,7 +280,7 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 
 		dev->stream_urb[i] = urb;
 	}
-	return ret;
+	return 0;
 }
 
 static void as102_usb_stop_stream(struct as102_dev_t *dev)
@@ -458,7 +458,6 @@ exit:
 
 static int as102_release(struct inode *inode, struct file *file)
 {
-	int ret = 0;
 	struct as102_dev_t *dev = NULL;
 
 	dev = file->private_data;
@@ -467,7 +466,7 @@ static int as102_release(struct inode *inode, struct file *file)
 		kref_put(&dev->kref, as102_usb_release);
 	}
 
-	return ret;
+	return 0;
 }
 
 MODULE_DEVICE_TABLE(usb, as102_usb_id_table);
diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index ff74d0d..78f5339 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -846,7 +846,6 @@ static void start_bss_network(struct adapter *padapter, u8 *pbuf)
 
 int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 {
-	int ret = _SUCCESS;
 	u8 *p;
 	u8 *pHT_caps_ie = NULL;
 	u8 *pHT_info_ie = NULL;
@@ -1113,7 +1112,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 	psta->state |= WIFI_AP_STATE;
 	rtw_indicate_connect(padapter);
 	pmlmepriv->cur_network.join_res = true;/* for check if already set beacon */
-	return ret;
+	return _SUCCESS;
 }
 
 void rtw_set_macaddr_acl(struct adapter *padapter, int mode)
@@ -1130,7 +1129,7 @@ int rtw_acl_add_sta(struct adapter *padapter, u8 *addr)
 {
 	struct list_head *plist, *phead;
 	u8 added = false;
-	int i, ret = 0;
+	int i;
 	struct rtw_wlan_acl_node *paclnode;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct wlan_acl_pool *pacl_list = &pstapriv->acl_list;
@@ -1162,7 +1161,7 @@ int rtw_acl_add_sta(struct adapter *padapter, u8 *addr)
 	spin_unlock_bh(&(pacl_node_q->lock));
 
 	if (added)
-		return ret;
+		return 0;
 
 	spin_lock_bh(&(pacl_node_q->lock));
 
@@ -1188,13 +1187,12 @@ int rtw_acl_add_sta(struct adapter *padapter, u8 *addr)
 
 	spin_unlock_bh(&(pacl_node_q->lock));
 
-	return ret;
+	return 0;
 }
 
 int rtw_acl_remove_sta(struct adapter *padapter, u8 *addr)
 {
 	struct list_head *plist, *phead;
-	int ret = 0;
 	struct rtw_wlan_acl_node *paclnode;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct wlan_acl_pool *pacl_list = &pstapriv->acl_list;
@@ -1225,7 +1223,7 @@ int rtw_acl_remove_sta(struct adapter *padapter, u8 *addr)
 	spin_unlock_bh(&(pacl_node_q->lock));
 
 	DBG_88E("%s, acl_num =%d\n", __func__, pacl_list->num);
-	return ret;
+	return 0;
 }
 
 static void update_bcn_fixed_ie(struct adapter *padapter)
@@ -1761,7 +1759,6 @@ u8 ap_free_sta(struct adapter *padapter, struct sta_info *psta,
 int rtw_ap_inform_ch_switch(struct adapter *padapter, u8 new_ch, u8 ch_offset)
 {
 	struct list_head *phead, *plist;
-	int ret = 0;
 	struct sta_info *psta = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
@@ -1769,7 +1766,7 @@ int rtw_ap_inform_ch_switch(struct adapter *padapter, u8 new_ch, u8 ch_offset)
 	u8 bc_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
-		return ret;
+		return 0;
 
 	DBG_88E(FUNC_NDEV_FMT" with ch:%u, offset:%u\n",
 		FUNC_NDEV_ARG(padapter->pnetdev), new_ch, ch_offset);
@@ -1790,13 +1787,12 @@ int rtw_ap_inform_ch_switch(struct adapter *padapter, u8 new_ch, u8 ch_offset)
 
 	issue_action_spct_ch_switch(padapter, bc_addr, new_ch, ch_offset);
 
-	return ret;
+	return 0;
 }
 
 int rtw_sta_flush(struct adapter *padapter)
 {
 	struct list_head *phead, *plist;
-	int ret = 0;
 	struct sta_info *psta = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
@@ -1806,7 +1802,7 @@ int rtw_sta_flush(struct adapter *padapter)
 	DBG_88E(FUNC_NDEV_FMT"\n", FUNC_NDEV_ARG(padapter->pnetdev));
 
 	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
-		return ret;
+		return 0;
 
 	spin_lock_bh(&pstapriv->asoc_list_lock);
 	phead = &pstapriv->asoc_list;
@@ -1830,7 +1826,7 @@ int rtw_sta_flush(struct adapter *padapter)
 
 	associated_clients_update(padapter, true);
 
-	return ret;
+	return 0;
 }
 
 /* called > TSR LEVEL for USB or SDIO Interface*/
diff --git a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
index 0552019..4acb45a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
@@ -518,7 +518,7 @@ int rtw_get_wpa2_cipher_suite(u8 *s)
 
 int rtw_parse_wpa_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher, int *pairwise_cipher, int *is_8021x)
 {
-	int i, ret = _SUCCESS;
+	int i;
 	int left, count;
 	u8 *pos;
 	u8 SUITE_1X[4] = {0x00, 0x50, 0xf2, 1};
@@ -582,12 +582,12 @@ int rtw_parse_wpa_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher, int *pairwis
 		}
 	}
 
-	return ret;
+	return _SUCCESS;
 }
 
 int rtw_parse_wpa2_ie(u8 *rsn_ie, int rsn_ie_len, int *group_cipher, int *pairwise_cipher, int *is_8021x)
 {
-	int i, ret = _SUCCESS;
+	int i;
 	int left, count;
 	u8 *pos;
 	u8 SUITE_1X[4] = {0x00, 0x0f, 0xac, 0x01};
@@ -651,7 +651,7 @@ int rtw_parse_wpa2_ie(u8 *rsn_ie, int rsn_ie_len, int *group_cipher, int *pairwi
 			}
 		}
 	}
-	return ret;
+	return _SUCCESS;
 }
 
 int rtw_get_sec_ie(u8 *in_ie, uint in_len, u8 *rsn_ie, u16 *rsn_len, u8 *wpa_ie, u16 *wpa_len)
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 55be52f..210cdb0 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -1697,7 +1697,6 @@ unsigned int OnAtim(struct adapter *padapter, struct recv_frame *precv_frame)
 
 unsigned int on_action_spct(struct adapter *padapter, struct recv_frame *precv_frame)
 {
-	unsigned int ret = _FAIL;
 	struct sta_info *psta = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	u8 *pframe = precv_frame->rx_data;
@@ -1730,7 +1729,7 @@ unsigned int on_action_spct(struct adapter *padapter, struct recv_frame *precv_f
 	}
 
 exit:
-	return ret;
+	return _FAIL;
 }
 
 unsigned int OnAction_qos(struct adapter *padapter, struct recv_frame *precv_frame)
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index da26fa5c..ea1626a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -1384,8 +1384,6 @@ static int wlanhdr_to_ethhdr(struct recv_frame *precvframe)
 	u8	bsnaphdr;
 	u8	*psnap_type;
 	struct ieee80211_snap_hdr	*psnap;
-
-	int ret = _SUCCESS;
 	struct adapter		*adapter = precvframe->adapter;
 	struct mlme_priv	*pmlmepriv = &adapter->mlmepriv;
 	u8 *ptr = precvframe->rx_data;
@@ -1440,7 +1438,7 @@ static int wlanhdr_to_ethhdr(struct recv_frame *precvframe)
 		memcpy(ptr+12, &be_tmp, 2);
 	}
 
-	return ret;
+	return _SUCCESS;
 }
 
 /* perform defrag */
@@ -1636,7 +1634,6 @@ static int amsdu_to_msdu(struct adapter *padapter, struct recv_frame *prframe)
 	struct sk_buff *sub_skb, *subframes[MAX_SUBFRAME_COUNT];
 	struct recv_priv *precvpriv = &padapter->recvpriv;
 	struct __queue *pfree_recv_queue = &(precvpriv->free_recv_queue);
-	int	ret = _SUCCESS;
 	nr_subframes = 0;
 
 	pattrib = &prframe->attrib;
@@ -1740,7 +1737,7 @@ exit:
 	prframe->len = 0;
 	rtw_free_recvframe(prframe, pfree_recv_queue);/* free this recv_frame */
 
-	return ret;
+	return _SUCCESS;
 }
 
 static int check_indicate_seq(struct recv_reorder_ctrl *preorder_ctrl, u16 seq_num)
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index cf30a08..24789c8 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1893,7 +1893,7 @@ static int rtw_wx_get_enc(struct net_device *dev,
 			    struct iw_request_info *info,
 			    union iwreq_data *wrqu, char *keybuf)
 {
-	uint key, ret = 0;
+	uint key;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct iw_point *erq = &(wrqu->encoding);
 	struct	mlme_priv	*pmlmepriv = &(padapter->mlmepriv);
@@ -1952,7 +1952,7 @@ static int rtw_wx_get_enc(struct net_device *dev,
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_wx_get_power(struct net_device *dev,
@@ -2723,7 +2723,6 @@ static int rtw_p2p_set_go_nego_ssid(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -2731,7 +2730,7 @@ static int rtw_p2p_set_go_nego_ssid(struct net_device *dev,
 	memcpy(pwdinfo->nego_ssid, extra, strlen(extra));
 	pwdinfo->nego_ssidlen = strlen(extra);
 
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_set_intent(struct net_device *dev,
@@ -2871,7 +2870,6 @@ static int rtw_p2p_setDN(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -2880,14 +2878,13 @@ static int rtw_p2p_setDN(struct net_device *dev,
 	memcpy(pwdinfo->device_name, extra, wrqu->data.length - 1);
 	pwdinfo->device_name_len = wrqu->data.length - 1;
 
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_status(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -2902,7 +2899,7 @@ static int rtw_p2p_get_status(struct net_device *dev,
 	sprintf(extra, "\n\nStatus=%.2d\n", rtw_p2p_state(pwdinfo));
 	wrqu->data.length = strlen(extra);
 
-	return ret;
+	return 0;
 }
 
 /*	Commented by Albert 20110520 */
@@ -2914,20 +2911,18 @@ static int rtw_p2p_get_req_cm(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
 	sprintf(extra, "\n\nCM=%s\n", pwdinfo->rx_prov_disc_info.strconfig_method_desc_of_prov_disc_req);
 	wrqu->data.length = strlen(extra);
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_role(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -2937,14 +2932,13 @@ static int rtw_p2p_get_role(struct net_device *dev,
 
 	sprintf(extra, "\n\nRole=%.2d\n", rtw_p2p_role(pwdinfo));
 	wrqu->data.length = strlen(extra);
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_peer_ifaddr(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -2954,7 +2948,7 @@ static int rtw_p2p_get_peer_ifaddr(struct net_device *dev,
 	sprintf(extra, "\nMAC %pM",
 		pwdinfo->p2p_peer_interface_addr);
 	wrqu->data.length = strlen(extra);
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_peer_devaddr(struct net_device *dev,
@@ -2962,7 +2956,6 @@ static int rtw_p2p_get_peer_devaddr(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -2972,7 +2965,7 @@ static int rtw_p2p_get_peer_devaddr(struct net_device *dev,
 	sprintf(extra, "\n%pM",
 		pwdinfo->rx_prov_disc_info.peerDevAddr);
 	wrqu->data.length = strlen(extra);
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_peer_devaddr_by_invitation(struct net_device *dev,
@@ -2980,7 +2973,6 @@ static int rtw_p2p_get_peer_devaddr_by_invitation(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -2990,7 +2982,7 @@ static int rtw_p2p_get_peer_devaddr_by_invitation(struct net_device *dev,
 	sprintf(extra, "\nMAC %pM",
 		pwdinfo->p2p_peer_device_addr);
 	wrqu->data.length = strlen(extra);
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_groupid(struct net_device *dev,
@@ -2998,7 +2990,6 @@ static int rtw_p2p_get_groupid(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -3008,7 +2999,7 @@ static int rtw_p2p_get_groupid(struct net_device *dev,
 		pwdinfo->groupid_info.go_device_addr[4], pwdinfo->groupid_info.go_device_addr[5],
 		pwdinfo->groupid_info.ssid);
 	wrqu->data.length = strlen(extra);
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_op_ch(struct net_device *dev,
@@ -3016,7 +3007,6 @@ static int rtw_p2p_get_op_ch(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -3024,14 +3014,13 @@ static int rtw_p2p_get_op_ch(struct net_device *dev,
 
 	sprintf(extra, "\n\nOp_ch=%.2d\n", pwdinfo->operating_channel);
 	wrqu->data.length = strlen(extra);
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_wps_configmethod(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	u8 peerMAC[ETH_ALEN] = {0x00};
 	int jj, kk;
@@ -3095,14 +3084,13 @@ static int rtw_p2p_get_wps_configmethod(struct net_device *dev,
 
 	if (copy_to_user(wrqu->data.pointer, attr_content_str, 6 + 17))
 		return -EFAULT;
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_go_device_address(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	u8 peerMAC[ETH_ALEN] = {0x00};
 	int jj, kk;
@@ -3179,14 +3167,13 @@ static int rtw_p2p_get_go_device_address(struct net_device *dev,
 
 	if (copy_to_user(wrqu->data.pointer, go_devadd_str, sizeof(go_devadd_str)))
 		return -EFAULT;
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_device_type(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	u8 peerMAC[ETH_ALEN] = {0x00};
 	int jj, kk;
@@ -3258,14 +3245,13 @@ static int rtw_p2p_get_device_type(struct net_device *dev,
 		return -EFAULT;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_device_name(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	u8 peerMAC[ETH_ALEN] = {0x00};
 	int jj, kk;
@@ -3327,14 +3313,13 @@ static int rtw_p2p_get_device_name(struct net_device *dev,
 
 	if (copy_to_user(wrqu->data.pointer, dev_name_str, 5 + ((dev_len > 17) ? dev_len : 17)))
 		return -EFAULT;
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get_invitation_procedure(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	u8 peerMAC[ETH_ALEN] = {0x00};
 	int jj, kk;
@@ -3406,7 +3391,7 @@ static int rtw_p2p_get_invitation_procedure(struct net_device *dev,
 	}
 	if (copy_to_user(wrqu->data.pointer, inv_proc_str, 8 + 17))
 		return -EFAULT;
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_connect(struct net_device *dev,
@@ -3495,7 +3480,6 @@ static int rtw_p2p_invite_req(struct net_device *dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 	int jj, kk;
@@ -3519,12 +3503,12 @@ static int rtw_p2p_invite_req(struct net_device *dev,
 
 	if (wrqu->data.length <=  37) {
 		DBG_88E("[%s] Wrong format!\n", __func__);
-		return ret;
+		return 0;
 	}
 
 	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) {
 		DBG_88E("[%s] WiFi Direct is disable!\n", __func__);
-		return ret;
+		return 0;
 	} else {
 		/*	Reset the content of struct tx_invite_req_info */
 		pinvite_req_info->benable = false;
@@ -3600,14 +3584,13 @@ static int rtw_p2p_invite_req(struct net_device *dev,
 	} else {
 		DBG_88E("[%s] NOT Found in the Scanning Queue!\n", __func__);
 	}
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_set_persistent(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -3619,7 +3602,7 @@ static int rtw_p2p_set_persistent(struct net_device *dev,
 
 	if (rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE)) {
 		DBG_88E("[%s] WiFi Direct is disable!\n", __func__);
-		return ret;
+		return 0;
 	} else {
 		if (extra[0] == '0')	/*	Disable the persistent group function. */
 			pwdinfo->persistent_supported = false;
@@ -3629,14 +3612,13 @@ static int rtw_p2p_set_persistent(struct net_device *dev,
 			pwdinfo->persistent_supported = false;
 	}
 	pr_info("[%s] persistent_supported = %d\n", __func__, pwdinfo->persistent_supported);
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_prov_disc(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 	u8 peerMAC[ETH_ALEN] = {0x00};
@@ -3662,7 +3644,7 @@ static int rtw_p2p_prov_disc(struct net_device *dev,
 
 	if (pwdinfo->p2p_state == P2P_STATE_NONE) {
 		DBG_88E("[%s] WiFi Direct is disable!\n", __func__);
-		return ret;
+		return 0;
 	} else {
 		/*	Reset the content of struct tx_provdisc_req_info excluded the wps_config_method_request. */
 		_rtw_memset(pwdinfo->tx_prov_disc_info.peerDevAddr, 0x00, ETH_ALEN);
@@ -3686,7 +3668,7 @@ static int rtw_p2p_prov_disc(struct net_device *dev,
 		pwdinfo->tx_prov_disc_info.wps_config_method_request = WPS_CM_LABEL;
 	} else {
 		DBG_88E("[%s] Unknown WPS config methodn", __func__);
-		return ret;
+		return 0;
 	}
 
 	spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
@@ -3761,7 +3743,7 @@ static int rtw_p2p_prov_disc(struct net_device *dev,
 	} else {
 		DBG_88E("[%s] NOT Found in the Scanning Queue!\n", __func__);
 	}
-	return ret;
+	return 0;
 }
 
 /*	This function is used to inform the driver the user had specified the pin code value or pbc */
@@ -3771,7 +3753,6 @@ static int rtw_p2p_got_wpsinfo(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct wifidirect_info *pwdinfo = &(padapter->wdinfo);
 
@@ -3792,7 +3773,7 @@ static int rtw_p2p_got_wpsinfo(struct net_device *dev,
 		pwdinfo->ui_got_wps_info = P2P_GOT_WPSINFO_PBC;
 	else
 		pwdinfo->ui_got_wps_info = P2P_NO_WPSINFO;
-	return ret;
+	return 0;
 }
 
 #endif /* CONFIG_88EU_P2P */
@@ -3801,8 +3782,6 @@ static int rtw_p2p_set(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
-
 #ifdef CONFIG_88EU_P2P
 	DBG_88E("[%s] extra = %s\n", __func__, extra);
 	if (!memcmp(extra, "enable=", 7)) {
@@ -3852,15 +3831,13 @@ static int rtw_p2p_set(struct net_device *dev,
 	}
 #endif /* CONFIG_88EU_P2P */
 
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
-
 #ifdef CONFIG_88EU_P2P
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 
@@ -3895,15 +3872,13 @@ static int rtw_p2p_get(struct net_device *dev,
 		rtw_p2p_get_op_ch(dev, info, wrqu, extra);
 	}
 #endif /* CONFIG_88EU_P2P */
-	return ret;
+	return 0;
 }
 
 static int rtw_p2p_get2(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
-
 #ifdef CONFIG_88EU_P2P
 	DBG_88E("[%s] extra = %s\n", __func__,
 			(char __user *)wrqu->data.pointer);
@@ -3926,14 +3901,13 @@ static int rtw_p2p_get2(struct net_device *dev,
 
 #endif /* CONFIG_88EU_P2P */
 
-	return ret;
+	return 0;
 }
 
 static int rtw_cta_test_start(struct net_device *dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	DBG_88E("%s %s\n", __func__, extra);
 	if (!strcmp(extra, "1"))
@@ -3952,7 +3926,7 @@ static int rtw_cta_test_start(struct net_device *dev,
 		rtw_write32(padapter, REG_RCR, v);
 		DBG_88E("disable RCR_ADF\n");
 	}
-	return ret;
+	return 0;
 }
 
 static int rtw_rereg_nd_name(struct net_device *dev,
@@ -5196,7 +5170,6 @@ static int rtw_add_sta(struct net_device *dev, struct ieee_param *param)
 
 static int rtw_del_sta(struct net_device *dev, struct ieee_param *param)
 {
-	int ret = 0;
 	struct sta_info *psta = NULL;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
@@ -5228,7 +5201,7 @@ static int rtw_del_sta(struct net_device *dev, struct ieee_param *param)
 		DBG_88E("rtw_del_sta(), sta has already been removed or never been added\n");
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_ioctl_get_sta_data(struct net_device *dev, struct ieee_param *param, int len)
@@ -5328,7 +5301,6 @@ static int rtw_get_sta_wpaie(struct net_device *dev, struct ieee_param *param)
 
 static int rtw_set_wps_beacon(struct net_device *dev, struct ieee_param *param, int len)
 {
-	int ret = 0;
 	unsigned char wps_oui[4] = {0x0, 0x50, 0xf2, 0x04};
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
@@ -5362,12 +5334,11 @@ static int rtw_set_wps_beacon(struct net_device *dev, struct ieee_param *param,
 		pmlmeext->bstart_bss = true;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_set_wps_probe_resp(struct net_device *dev, struct ieee_param *param, int len)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
 	int ie_len;
@@ -5394,12 +5365,11 @@ static int rtw_set_wps_probe_resp(struct net_device *dev, struct ieee_param *par
 		memcpy(pmlmepriv->wps_probe_resp_ie, param->u.bcn_ie.buf, ie_len);
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_set_wps_assoc_resp(struct net_device *dev, struct ieee_param *param, int len)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
 	int ie_len;
@@ -5427,12 +5397,11 @@ static int rtw_set_wps_assoc_resp(struct net_device *dev, struct ieee_param *par
 		memcpy(pmlmepriv->wps_assoc_resp_ie, param->u.bcn_ie.buf, ie_len);
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_set_hidden_ssid(struct net_device *dev, struct ieee_param *param, int len)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
 	struct mlme_ext_priv	*pmlmeext = &(padapter->mlmeextpriv);
@@ -5452,7 +5421,7 @@ static int rtw_set_hidden_ssid(struct net_device *dev, struct ieee_param *param,
 		value = 0;
 	DBG_88E("%s value(%u)\n", __func__, value);
 	pmlmeinfo->hidden_ssid_mode = value;
-	return ret;
+	return 0;
 }
 
 static int rtw_ioctl_acl_remove_sta(struct net_device *dev, struct ieee_param *param, int len)
@@ -5491,7 +5460,6 @@ static int rtw_ioctl_acl_add_sta(struct net_device *dev, struct ieee_param *para
 
 static int rtw_ioctl_set_macaddr_acl(struct net_device *dev, struct ieee_param *param, int len)
 {
-	int ret = 0;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
 
@@ -5500,7 +5468,7 @@ static int rtw_ioctl_set_macaddr_acl(struct net_device *dev, struct ieee_param *
 
 	rtw_set_macaddr_acl(padapter, param->u.mlme.command);
 
-	return ret;
+	return 0;
 }
 
 static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 9edb8e8..be3afad 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -769,7 +769,6 @@ void rtw_stop_drv_threads(struct adapter *padapter)
 
 static u8 rtw_init_default_value(struct adapter *padapter)
 {
-	u8 ret  = _SUCCESS;
 	struct registry_priv *pregistrypriv = &padapter->registrypriv;
 	struct xmit_priv	*pxmitpriv = &padapter->xmitpriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -815,7 +814,7 @@ static u8 rtw_init_default_value(struct adapter *padapter)
 #ifdef CONFIG_88EU_P2P
 	padapter->bShowGetP2PState = 1;
 #endif
-	return ret;
+	return _SUCCESS;
 }
 
 u8 rtw_reset_drv_sw(struct adapter *padapter)
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
index b4bfafe..8848921 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
@@ -729,7 +729,6 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device *dev,
 {
 
 	int i;
-	u8 ret = 0;
 
 	switch (eRFPath) {
 	case RF90_PATH_A:
@@ -787,7 +786,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device *dev,
 		break;
 	}
 
-	return ret;
+	return 0;
 
 }
 static void rtl8192_SetTxPowerLevel(struct net_device *dev, u8 channel)
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 356d521..e90cfe5 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -667,19 +667,18 @@ static int rtl8192_handle_beacon(struct net_device *dev,
 static int rtl8192_qos_association_resp(struct r8192_priv *priv,
 	struct rtllib_network *network)
 {
-	int ret = 0;
 	unsigned long flags;
 	u32 size = sizeof(struct rtllib_qos_parameters);
 	int set_qos_param = 0;
 
 	if ((priv == NULL) || (network == NULL))
-		return ret;
+		return 0;
 
 	if (priv->rtllib->state != RTLLIB_LINKED)
-		return ret;
+		return 0;
 
 	if ((priv->rtllib->iw_mode != IW_MODE_INFRA))
-		return ret;
+		return 0;
 
 	spin_lock_irqsave(&priv->rtllib->lock, flags);
 	if (network->flags & NETWORK_HAS_QOS_PARAMETERS) {
@@ -709,7 +708,7 @@ static int rtl8192_qos_association_resp(struct r8192_priv *priv,
 		dm_init_edca_turbo(priv->rtllib->dev);
 		queue_work_rsl(priv->priv_wq, &priv->qos_activate);
 	}
-	return ret;
+	return 0;
 }
 
 static int rtl8192_handle_assoc_response(struct net_device *dev,
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index de76097..b850346 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -1105,7 +1105,6 @@ static int r8192_wx_get_gen_ie(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *data, char *extra)
 {
-	int ret = 0;
 	struct r8192_priv *priv = rtllib_priv(dev);
 	struct rtllib_device *ieee = priv->rtllib;
 
@@ -1119,7 +1118,7 @@ static int r8192_wx_get_gen_ie(struct net_device *dev,
 
 	data->data.length = ieee->wpa_ie_len;
 	memcpy(extra, ieee->wpa_ie, ieee->wpa_ie_len);
-	return ret;
+	return 0;
 }
 
 #define OID_RT_INTEL_PROMISCUOUS_MODE	0xFF0101F6
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index d65cba4..684ceed 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -3239,7 +3239,6 @@ static int rtllib_wpa_set_auth_algs(struct rtllib_device *ieee, int value)
 	struct rtllib_security sec = {
 		.flags = SEC_AUTH_MODE,
 	};
-	int ret = 0;
 
 	if (value & AUTH_ALG_SHARED_KEY) {
 		sec.auth_mode = WLAN_AUTH_SHARED_KEY;
@@ -3259,7 +3258,7 @@ static int rtllib_wpa_set_auth_algs(struct rtllib_device *ieee, int value)
 	if (ieee->set_security)
 		ieee->set_security(ieee->dev, &sec);
 
-	return ret;
+	return 0;
 }
 
 static int rtllib_wpa_set_param(struct rtllib_device *ieee, u8 name, u32 value)
diff --git a/drivers/staging/rtl8192e/rtllib_softmac_wx.c b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
index e6af8cf..65b650c 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
@@ -628,8 +628,6 @@ int rtllib_wx_get_power(struct rtllib_device *ieee,
 				 struct iw_request_info *info,
 				 union iwreq_data *wrqu, char *extra)
 {
-	int ret = 0;
-
 	down(&ieee->wx_sem);
 
 	if (ieee->ps == RTLLIB_PS_DISABLED) {
@@ -657,7 +655,7 @@ int rtllib_wx_get_power(struct rtllib_device *ieee,
 
 exit:
 	up(&ieee->wx_sem);
-	return ret;
+	return 0;
 
 }
 EXPORT_SYMBOL(rtllib_wx_get_power);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 9caf6fd..e2d9521 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -2843,7 +2843,6 @@ static int ieee80211_wpa_set_auth_algs(struct ieee80211_device *ieee, int value)
 	struct ieee80211_security sec = {
 		.flags = SEC_AUTH_MODE,
 	};
-	int ret = 0;
 
 	if (value & AUTH_ALG_SHARED_KEY) {
 		sec.auth_mode = WLAN_AUTH_SHARED_KEY;
@@ -2866,7 +2865,7 @@ static int ieee80211_wpa_set_auth_algs(struct ieee80211_device *ieee, int value)
 	//else
 	//	ret = -EOPNOTSUPP;
 
-	return ret;
+	return 0;
 }
 
 static int ieee80211_wpa_set_param(struct ieee80211_device *ieee, u8 name, u32 value)
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 7b7d929..3dfdc7a 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -559,8 +559,6 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
 				 struct iw_request_info *info,
 				 union iwreq_data *wrqu, char *extra)
 {
-	int ret =0;
-
 	down(&ieee->wx_sem);
 
 	if(ieee->ps == IEEE80211_PS_DISABLED){
@@ -590,7 +588,7 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
 
 exit:
 	up(&ieee->wx_sem);
-	return ret;
+	return 0;
 
 }
 EXPORT_SYMBOL(ieee80211_wx_get_essid);
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index 53ec2d4..38adecf 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -415,8 +415,7 @@ static void HTIOTPeerDetermine(struct ieee80211_device *ieee)
   * *****************************************************************************************************************/
 static u8 HTIOTActIsDisableMCS14(struct ieee80211_device *ieee, u8 *PeerMacAddr)
 {
-	u8 ret = 0;
-	return ret;
+	return 0;
  }
 
 
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1bb6143..55a1e29 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2134,19 +2134,18 @@ static int rtl8192_handle_beacon(struct net_device *dev,
 static int rtl8192_qos_association_resp(struct r8192_priv *priv,
 					struct ieee80211_network *network)
 {
-	int ret = 0;
 	unsigned long flags;
 	u32 size = sizeof(struct ieee80211_qos_parameters);
 	int set_qos_param = 0;
 
 	if ((priv == NULL) || (network == NULL))
-		return ret;
+		return 0;
 
 	if (priv->ieee80211->state != IEEE80211_LINKED)
-		return ret;
+		return 0;
 
 	if ((priv->ieee80211->iw_mode != IW_MODE_INFRA))
-		return ret;
+		return 0;
 
 	spin_lock_irqsave(&priv->ieee80211->lock, flags);
 	if (network->flags & NETWORK_HAS_QOS_PARAMETERS) {
@@ -2175,7 +2174,7 @@ static int rtl8192_qos_association_resp(struct r8192_priv *priv,
 		queue_work(priv->priv_wq, &priv->qos_activate);
 
 
-	return ret;
+	return 0;
 }
 
 
diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index 87e07ba..02554c9 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -991,7 +991,6 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device *dev,
 {
 
 	int i;
-	u8 ret = 0;
 
 	switch (eRFPath) {
 	case RF90_PATH_A:
@@ -1058,7 +1057,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device *dev,
 		break;
 	}
 
-	return ret;
+	return 0;
 
 }
 
diff --git a/drivers/staging/rtl8712/ieee80211.c b/drivers/staging/rtl8712/ieee80211.c
index 57fef70..fe9459e 100644
--- a/drivers/staging/rtl8712/ieee80211.c
+++ b/drivers/staging/rtl8712/ieee80211.c
@@ -289,7 +289,7 @@ static int r8712_get_wpa2_cipher_suite(u8 *s)
 int r8712_parse_wpa_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher,
 		 int *pairwise_cipher)
 {
-	int i, ret = _SUCCESS;
+	int i;
 	int left, count;
 	u8 *pos;
 
@@ -324,13 +324,13 @@ int r8712_parse_wpa_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher,
 		}
 	} else if (left == 1)
 		return _FAIL;
-	return ret;
+	return _SUCCESS;
 }
 
 int r8712_parse_wpa2_ie(u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 		  int *pairwise_cipher)
 {
-	int i, ret = _SUCCESS;
+	int i;
 	int left, count;
 	u8 *pos;
 
@@ -364,7 +364,7 @@ int r8712_parse_wpa2_ie(u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
 		}
 	} else if (left == 1)
 		return _FAIL;
-	return ret;
+	return _SUCCESS;
 }
 
 int r8712_get_sec_ie(u8 *in_ie, uint in_len, u8 *rsn_ie, u16 *rsn_len,
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 6bd0821..35ac666 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -273,7 +273,6 @@ void r8712_stop_drv_timers(struct _adapter *padapter)
 
 static u8 init_default_value(struct _adapter *padapter)
 {
-	u8 ret  = _SUCCESS;
 	struct registry_priv *pregistrypriv = &padapter->registrypriv;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -306,7 +305,7 @@ static u8 init_default_value(struct _adapter *padapter)
 	r8712_init_registrypriv_dev_network(padapter);
 	r8712_update_registrypriv_dev_network(padapter);
 	/*misc.*/
-	return ret;
+	return _SUCCESS;
 }
 
 u8 r8712_init_drv_sw(struct _adapter *padapter)
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 0723b2f..be98ed0 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -347,7 +347,6 @@ static int amsdu_to_msdu(struct _adapter *padapter, union recv_frame *prframe)
 	_pkt *sub_skb, *subframes[MAX_SUBFRAME_COUNT];
 	struct recv_priv *precvpriv = &padapter->recvpriv;
 	struct  __queue *pfree_recv_queue = &(precvpriv->free_recv_queue);
-	int	ret = _SUCCESS;
 
 	nr_subframes = 0;
 	pattrib = &prframe->u.hdr.attrib;
@@ -435,7 +434,7 @@ static int amsdu_to_msdu(struct _adapter *padapter, union recv_frame *prframe)
 exit:
 	prframe->u.hdr.len = 0;
 	r8712_free_recvframe(prframe, pfree_recv_queue);
-	return ret;
+	return _SUCCESS;
 }
 
 void r8712_rxcmd_event_hdl(struct _adapter *padapter, void *prxcmdbuf)
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 23d539d..730c63b 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1629,7 +1629,7 @@ static int r8711_wx_get_enc(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *keybuf)
 {
-	uint key, ret = 0;
+	uint key;
 	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 	struct iw_point *erq = &(wrqu->encoding);
 	struct	mlme_priv	*pmlmepriv = &(padapter->mlmepriv);
@@ -1685,7 +1685,7 @@ static int r8711_wx_get_enc(struct net_device *dev,
 		erq->flags |= IW_ENCODE_DISABLED;
 		break;
 	}
-	return ret;
+	return 0;
 }
 
 static int r8711_wx_get_power(struct net_device *dev,
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 3ea99ae..05d6e65 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1211,7 +1211,6 @@ sint r8712_set_auth(struct _adapter *adapter,
 	struct cmd_priv	*pcmdpriv = &adapter->cmdpriv;
 	struct cmd_obj *pcmd;
 	struct setauth_parm *psetauthparm;
-	sint ret = _SUCCESS;
 
 	pcmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
 	if (pcmd == NULL)
@@ -1232,7 +1231,7 @@ sint r8712_set_auth(struct _adapter *adapter,
 	pcmd->rspsz = 0;
 	_init_listhead(&pcmd->list);
 	r8712_enqueue_cmd(pcmdpriv, pcmd);
-	return ret;
+	return _SUCCESS;
 }
 
 sint r8712_set_key(struct _adapter *adapter,
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index 274c359..4ac4a1b 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -605,8 +605,6 @@ sint r8712_wlanhdr_to_ethhdr(union recv_frame *precvframe)
 	u8	bsnaphdr;
 	u8	*psnap_type;
 	struct ieee80211_snap_hdr *psnap;
-
-	sint ret = _SUCCESS;
 	struct _adapter	*adapter = precvframe->u.hdr.adapter;
 	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
 
@@ -653,7 +651,7 @@ sint r8712_wlanhdr_to_ethhdr(union recv_frame *precvframe)
 		len = htons(len);
 		memcpy(ptr + 12, &len, 2);
 	}
-	return ret;
+	return _SUCCESS;
 }
 
 s32 r8712_recv_entry(union recv_frame *precvframe)
diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index 9e66c91..bfa2164 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -780,7 +780,6 @@ static void start_bss_network(struct rtw_adapter *padapter, u8 *pbuf)
 int rtw_check_beacon_data23a(struct rtw_adapter *padapter, u8 *pbuf,
 			     unsigned int len)
 {
-	int ret = _SUCCESS;
 	u8 *p;
 	u8 *pHT_caps_ie = NULL;
 	u8 *pHT_info_ie = NULL;
@@ -1062,7 +1061,7 @@ int rtw_check_beacon_data23a(struct rtw_adapter *padapter, u8 *pbuf,
 	/* for check if already set beacon */
 	pmlmepriv->cur_network.join_res = true;
 
-	return ret;
+	return _SUCCESS;
 }
 
 void rtw_set_macaddr_acl23a(struct rtw_adapter *padapter, int mode)
@@ -1079,7 +1078,7 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 {
 	struct list_head *plist, *phead;
 	u8 added = false;
-	int i, ret = 0;
+	int i;
 	struct rtw_wlan_acl_node *paclnode;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct wlan_acl_pool *pacl_list = &pstapriv->acl_list;
@@ -1109,7 +1108,7 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 	spin_unlock_bh(&pacl_node_q->lock);
 
 	if (added)
-		return ret;
+		return 0;
 
 	spin_lock_bh(&pacl_node_q->lock);
 
@@ -1134,7 +1133,7 @@ int rtw_acl_add_sta23a(struct rtw_adapter *padapter, u8 *addr)
 	DBG_8723A("%s, acl_num =%d\n", __func__, pacl_list->num);
 
 	spin_unlock_bh(&pacl_node_q->lock);
-	return ret;
+	return 0;
 }
 
 int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
@@ -1144,7 +1143,6 @@ int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct wlan_acl_pool *pacl_list = &pstapriv->acl_list;
 	struct rtw_queue *pacl_node_q = &pacl_list->acl_node_q;
-	int ret = 0;
 
 	DBG_8723A("%s(acl_num =%d) = %pM\n", __func__, pacl_list->num, addr);
 
@@ -1170,7 +1168,7 @@ int rtw_acl_remove_sta23a(struct rtw_adapter *padapter, u8 *addr)
 
 	DBG_8723A("%s, acl_num =%d\n", __func__, pacl_list->num);
 
-	return ret;
+	return 0;
 }
 
 static void update_bcn_fixed_ie(struct rtw_adapter *padapter)
@@ -1768,7 +1766,6 @@ u8 ap_free_sta23a(struct rtw_adapter *padapter, struct sta_info *psta, bool acti
 int rtw_ap_inform_ch_switch23a (struct rtw_adapter *padapter, u8 new_ch, u8 ch_offset)
 {
 	struct list_head *phead, *plist;
-	int ret = 0;
 	struct sta_info *psta = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
@@ -1776,7 +1773,7 @@ int rtw_ap_inform_ch_switch23a (struct rtw_adapter *padapter, u8 new_ch, u8 ch_o
 	u8 bc_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
-		return ret;
+		return 0;
 
 	DBG_8723A("%s(%s): with ch:%u, offset:%u\n", __func__,
 		  padapter->pnetdev->name, new_ch, ch_offset);
@@ -1794,13 +1791,12 @@ int rtw_ap_inform_ch_switch23a (struct rtw_adapter *padapter, u8 new_ch, u8 ch_o
 
 	issue_action_spct_ch_switch23a (padapter, bc_addr, new_ch, ch_offset);
 
-	return ret;
+	return 0;
 }
 
 int rtw_sta_flush23a(struct rtw_adapter *padapter)
 {
 	struct list_head *phead, *plist, *ptmp;
-	int ret = 0;
 	struct sta_info *psta;
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
@@ -1813,7 +1809,7 @@ int rtw_sta_flush23a(struct rtw_adapter *padapter)
 	DBG_8723A("%s(%s)\n", __func__, padapter->pnetdev->name);
 
 	if ((pmlmeinfo->state&0x03) != WIFI_FW_AP_STATE)
-		return ret;
+		return 0;
 
 	spin_lock_bh(&pstapriv->asoc_list_lock);
 	phead = &pstapriv->asoc_list;
@@ -1839,7 +1835,7 @@ int rtw_sta_flush23a(struct rtw_adapter *padapter)
 
 	associated_clients_update23a(padapter, true);
 
-	return ret;
+	return 0;
 }
 
 /* called > TSR LEVEL for USB or SDIO Interface*/
diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 98cd990..a074004 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -495,7 +495,7 @@ int rtw_get_wpa2_cipher_suite23a(const u8 *s)
 
 int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int *pairwise_cipher, int *is_8021x)
 {
-	int i, ret = _SUCCESS;
+	int i;
 	int left, count;
 	const u8 *pos;
 
@@ -566,13 +566,13 @@ int rtw_parse_wpa_ie23a(const u8* wpa_ie, int wpa_ie_len, int *group_cipher, int
 		}
 	}
 
-	return ret;
+	return _SUCCESS;
 }
 
 int rtw_parse_wpa2_ie23a(const u8* rsn_ie, int rsn_ie_len, int *group_cipher,
 		      int *pairwise_cipher, int *is_8021x)
 {
-	int i, ret = _SUCCESS;
+	int i;
 	int left, count;
 	const u8 *pos;
 	u8 SUITE_1X[4] = {0x00, 0x0f, 0xac, 0x01};
@@ -643,7 +643,7 @@ int rtw_parse_wpa2_ie23a(const u8* rsn_ie, int rsn_ie_len, int *group_cipher,
 		}
 	}
 
-	return ret;
+	return _SUCCESS;
 }
 
 int rtw_get_sec_ie23a(u8 *in_ie, uint in_len, u8 *rsn_ie, u16 *rsn_len,
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 014bb54..1094daa 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1554,8 +1554,6 @@ static int wlanhdr_to_ethhdr (struct recv_frame *precvframe)
 	u16	eth_type, len, hdrlen;
 	u8	bsnaphdr;
 	u8	*psnap;
-
-	int ret = _SUCCESS;
 	struct rtw_adapter *adapter = precvframe->adapter;
 	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
 
@@ -1616,7 +1614,7 @@ static int wlanhdr_to_ethhdr (struct recv_frame *precvframe)
 	}
 
 
-	return ret;
+	return _SUCCESS;
 }
 
 /* perform defrag */
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 53cec46..a22350b 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -247,7 +247,6 @@ rtw_cfg80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 static int rtw_cfg80211_inform_bss(struct rtw_adapter *padapter,
 				   struct wlan_network *pnetwork)
 {
-	int ret = 0;
 	struct ieee80211_channel *notify_channel;
 	struct cfg80211_bss *bss;
 	/* struct ieee80211_supported_band *band; */
@@ -345,7 +344,7 @@ static int rtw_cfg80211_inform_bss(struct rtw_adapter *padapter,
 	cfg80211_put_bss(wiphy, bss);
 
 exit:
-	return ret;
+	return 0;
 }
 
 void rtw_cfg80211_indicate_connect(struct rtw_adapter *padapter)
@@ -1407,7 +1406,6 @@ void rtw_cfg80211_surveydone_event_callback(struct rtw_adapter *padapter)
 static int rtw_cfg80211_set_probe_req_wpsp2pie(struct rtw_adapter *padapter,
 					       char *buf, int len)
 {
-	int ret = 0;
 	uint wps_ielen = 0;
 	u8 *wps_ie;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
@@ -1437,7 +1435,7 @@ static int rtw_cfg80211_set_probe_req_wpsp2pie(struct rtw_adapter *padapter,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static int cfg80211_rtw_scan(struct wiphy *wiphy,
@@ -2381,20 +2379,16 @@ void rtw_cfg80211_indicate_sta_disassoc(struct rtw_adapter *padapter,
 
 static int rtw_cfg80211_monitor_if_open(struct net_device *ndev)
 {
-	int ret = 0;
-
 	DBG_8723A("%s\n", __func__);
 
-	return ret;
+	return 0;
 }
 
 static int rtw_cfg80211_monitor_if_close(struct net_device *ndev)
 {
-	int ret = 0;
-
 	DBG_8723A("%s\n", __func__);
 
-	return ret;
+	return 0;
 }
 
 static int rtw_cfg80211_monitor_if_xmit_entry(struct sk_buff *skb,
@@ -2529,11 +2523,9 @@ fail:
 static int
 rtw_cfg80211_monitor_if_set_mac_address(struct net_device *ndev, void *addr)
 {
-	int ret = 0;
-
 	DBG_8723A("%s\n", __func__);
 
-	return ret;
+	return 0;
 }
 
 static const struct net_device_ops rtw_cfg80211_monitor_if_ops = {
@@ -3068,7 +3060,6 @@ static int cfg80211_rtw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct rtw_adapter *padapter =
 		(struct rtw_adapter *)wiphy_to_adapter(wiphy);
 	struct rtw_wdev_priv *pwdev_priv = wdev_to_priv(padapter->rtw_wdev);
-	int ret = 0;
 	int tx_ret;
 	u32 dump_limit = RTW_MAX_MGMT_TX_CNT;
 	u32 dump_cnt = 0;
@@ -3139,7 +3130,7 @@ static int cfg80211_rtw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 exit:
-	return ret;
+	return 0;
 }
 
 static void cfg80211_rtw_mgmt_frame_register(struct wiphy *wiphy,
@@ -3155,7 +3146,6 @@ static void cfg80211_rtw_mgmt_frame_register(struct wiphy *wiphy,
 static int rtw_cfg80211_set_beacon_wpsp2pie(struct net_device *ndev, char *buf,
 					    int len)
 {
-	int ret = 0;
 	uint wps_ielen = 0;
 	u8 *wps_ie;
 #ifdef CONFIG_8723AU_AP_MODE
@@ -3198,7 +3188,7 @@ static int rtw_cfg80211_set_beacon_wpsp2pie(struct net_device *ndev, char *buf,
 
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_cfg80211_set_probe_resp_wpsp2pie(struct net_device *net,
@@ -3206,7 +3196,6 @@ static int rtw_cfg80211_set_probe_resp_wpsp2pie(struct net_device *net,
 {
 	struct rtw_adapter *padapter = netdev_priv(net);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	int ret = 0;
 	uint wps_ielen = 0;
 	u8 *wps_ie;
 
@@ -3251,13 +3240,12 @@ static int rtw_cfg80211_set_probe_resp_wpsp2pie(struct net_device *net,
 
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rtw_cfg80211_set_assoc_resp_wpsp2pie(struct net_device *net,
 						char *buf, int len)
 {
-	int ret = 0;
 	struct rtw_adapter *padapter = netdev_priv(net);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
@@ -3281,7 +3269,7 @@ static int rtw_cfg80211_set_assoc_resp_wpsp2pie(struct net_device *net,
 		pmlmepriv->wps_assoc_resp_ie_len = len;
 	}
 
-	return ret;
+	return 0;
 }
 
 int rtw_cfg80211_set_mgnt_wpsp2pie(struct net_device *net, char *buf, int len,
diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
index ca95bd3..b8eb629 100644
--- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
@@ -383,7 +383,6 @@ static u8 rtw_init_default_value(struct rtw_adapter *padapter)
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
-	u8 ret = _SUCCESS;
 
 	/* xmit_priv */
 	pxmitpriv->vcs_setting = pregistrypriv->vrtl_carrier_sense;
@@ -425,7 +424,7 @@ static u8 rtw_init_default_value(struct rtw_adapter *padapter)
 	padapter->bReadPortCancel = false;
 	padapter->bWritePortCancel = false;
 	padapter->bNotifyChannelChange = 0;
-	return ret;
+	return _SUCCESS;
 }
 
 u8 rtw_reset_drv_sw23a(struct rtw_adapter *padapter)
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index cd5235a..f610bdf 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -644,7 +644,6 @@ out:
 static int memory_regain_ownership(struct dmm_map_object *map_obj,
 		unsigned long start, ssize_t len, enum dma_data_direction dir)
 {
-	int ret = 0;
 	unsigned long first_data_page = start >> PAGE_SHIFT;
 	unsigned long last_data_page = ((u32)(start + len - 1) >> PAGE_SHIFT);
 	/* calculating the number of pages this area spans */
@@ -668,7 +667,7 @@ static int memory_regain_ownership(struct dmm_map_object *map_obj,
 	map_obj->dma_info.sg = NULL;
 
 out:
-	return ret;
+	return 0;
 }
 
 /* Cache operation against kernel address instead of users */
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index f55d0fb..317c2a8 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -421,7 +421,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 	unsigned char abySeq[MAX_KEY_LEN];
 	unsigned long long KeyRSC;
 	unsigned char byKeyDecMode = KEY_CTL_WEP;
-	int     ret = 0;
 	int     iNodeIndex = -1;
 	int     ii;
 	bool bKeyTableFull = false;
@@ -475,7 +474,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 		       MAX_KEY_LEN
 );
 
-		return ret;
+		return 0;
 	}
 
 	memcpy(abyKey, param->u.crypt.key, param->u.crypt.key_len);
@@ -531,7 +530,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 		pMgmt->byCSSGK = KEY_CTL_WEP;
 		pMgmt->sNodeDBTable[iNodeIndex].byCipherSuite = KEY_CTL_WEP;
 		pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex = dwKeyIndex;
-		return ret;
+		return 0;
 	}
 
 	if (param->u.crypt.seq) {
@@ -622,7 +621,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	pMgmt->sNodeDBTable[iNodeIndex].dwTSC47_16 = 0;
 	pMgmt->sNodeDBTable[iNodeIndex].wTSC15_0 = 0;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -643,7 +642,6 @@ static int hostap_get_encryption(PSDevice pDevice,
 				 int param_len)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	int     ret = 0;
 	int     ii;
 	int     iNodeIndex = 0;
 
@@ -663,7 +661,7 @@ static int hostap_get_encryption(PSDevice pDevice,
 	for (ii = 0; ii < 8; ii++)
 		param->u.crypt.seq[ii] = (unsigned char)pMgmt->sNodeDBTable[iNodeIndex].KeyRSC >> (ii * 8);
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 089e8a7..8392d4d 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -411,12 +411,11 @@ static int wpa_set_wpa(PSDevice pDevice,
 		       struct viawget_wpa_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	int ret = 0;
 
 	pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
 	pMgmt->bShareKeyAlgorithm = false;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -437,7 +436,6 @@ static int wpa_set_disassociate(PSDevice pDevice,
 				struct viawget_wpa_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	int ret = 0;
 
 	spin_lock_irq(&pDevice->lock);
 	if (pDevice->bLinkPass) {
@@ -446,7 +444,7 @@ static int wpa_set_disassociate(PSDevice pDevice,
 	}
 	spin_unlock_irq(&pDevice->lock);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -466,14 +464,12 @@ static int wpa_set_disassociate(PSDevice pDevice,
 static int wpa_set_scan(PSDevice pDevice,
 			struct viawget_wpa_param *param)
 {
-	int ret = 0;
-
 	spin_lock_irq(&pDevice->lock);
 	BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
 	bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 	spin_unlock_irq(&pDevice->lock);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -494,11 +490,10 @@ static int wpa_get_bssid(PSDevice pDevice,
 			 struct viawget_wpa_param *param)
 {
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
-	int ret = 0;
 
 	memcpy(param->u.wpa_associate.bssid, pMgmt->abyCurrBSSID , 6);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -520,14 +515,13 @@ static int wpa_get_ssid(PSDevice pDevice,
 {
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
 	PWLAN_IE_SSID       pItemSSID;
-	int ret = 0;
 
 	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 
 	memcpy(param->u.wpa_associate.ssid, pItemSSID->abySSID , pItemSSID->len);
 	param->u.wpa_associate.ssid_len = pItemSSID->len;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -668,7 +662,6 @@ static int wpa_set_associate(PSDevice pDevice,
 	PWLAN_IE_SSID   pItemSSID;
 	unsigned char abyNullAddr[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
 	unsigned char abyWPAIE[64];
-	int ret = 0;
 	bool bWepEnabled = false;
 
 	// set key type & algorithm
@@ -788,7 +781,7 @@ static int wpa_set_associate(PSDevice pDevice,
 	bScheduleCommand((void *)pDevice, WLAN_CMD_SSID, NULL);
 	spin_unlock_irq(&pDevice->lock);
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 2a5b7c8..1dbc632 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -412,7 +412,6 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
 	u8 abySeq[MAX_KEY_LEN];
 	NDIS_802_11_KEY_RSC   KeyRSC;
 	u8 byKeyDecMode = KEY_CTL_WEP;
-	int ret = 0;
 	s32 iNodeIndex = -1;
 	int ii;
 	bool bKeyTableFull = false;
@@ -468,7 +467,7 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
                 MAX_KEY_LEN
                );
 
-        return ret;
+	return 0;
 	}
 
     memcpy(abyKey, param->u.crypt.key, param->u.crypt.key_len);
@@ -524,7 +523,7 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
         pMgmt->byCSSGK = KEY_CTL_WEP;
         pMgmt->sNodeDBTable[iNodeIndex].byCipherSuite = KEY_CTL_WEP;
         pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex = dwKeyIndex;
-        return ret;
+	return 0;
 	}
 
 	if (param->u.crypt.seq) {
@@ -617,7 +616,7 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
     pMgmt->sNodeDBTable[iNodeIndex].dwTSC47_16 = 0;
     pMgmt->sNodeDBTable[iNodeIndex].wTSC15_0 = 0;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -638,7 +637,6 @@ static int hostap_get_encryption(struct vnt_private *pDevice,
 				       int param_len)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	int ret = 0;
 	int ii;
 	s32 iNodeIndex = 0;
 
@@ -659,7 +657,7 @@ static int hostap_get_encryption(struct vnt_private *pDevice,
         param->u.crypt.seq[ii] = (u8)pMgmt->sNodeDBTable[iNodeIndex].KeyRSC >> (ii * 8);
     }
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index 41f3324..f073dd7 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -1580,7 +1580,6 @@ int wvlan_set_netname(struct net_device *dev,
 {
 	struct wl_private *lp = wl_priv(dev);
 	unsigned long flags;
-	int ret = 0;
 
 	wl_lock(lp, &flags);
 
@@ -1591,7 +1590,7 @@ int wvlan_set_netname(struct net_device *dev,
 	wl_apply(lp);
 	wl_unlock(lp, &flags);
 
-	return ret;
+	return 0;
 } /* wvlan_set_netname */
 /*============================================================================*/
 
@@ -1683,7 +1682,6 @@ int wvlan_set_station_nickname(struct net_device *dev,
 	struct wl_private *lp = wl_priv(dev);
 	unsigned long flags;
 	size_t len;
-	int         ret = 0;
 
 	wl_lock(lp, &flags);
 
@@ -1695,7 +1693,7 @@ int wvlan_set_station_nickname(struct net_device *dev,
 	wl_apply(lp);
 	wl_unlock(lp, &flags);
 
-	return ret;
+	return 0;
 } /* wvlan_set_station_nickname */
 /*============================================================================*/
 
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 4c4a236..6ac2160 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -640,12 +640,11 @@ static int mxser_change_speed(struct tty_struct *tty,
 {
 	struct mxser_port *info = tty->driver_data;
 	unsigned cflag, cval, fcr;
-	int ret = 0;
 	unsigned char status;
 
 	cflag = tty->termios.c_cflag;
 	if (!info->ioaddr)
-		return ret;
+		return 0;
 
 	if (mxser_set_baud_method[tty->index] == 0)
 		mxser_set_baud(tty, tty_get_baud_rate(tty));
@@ -807,7 +806,7 @@ static int mxser_change_speed(struct tty_struct *tty,
 	outb(fcr, info->ioaddr + UART_FCR);	/* set fcr */
 	outb(cval, info->ioaddr + UART_LCR);
 
-	return ret;
+	return 0;
 }
 
 static void mxser_check_modem_status(struct tty_struct *tty,
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index db0448a..fc3432e 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -408,7 +408,6 @@ static int max3110_main_thread(void *_max)
 {
 	struct uart_max3110 *max = _max;
 	wait_queue_head_t *wq = &max->wq;
-	int ret = 0;
 	struct circ_buf *xmit = &max->con_xmit;
 
 	pr_info(PR_FMT "start main thread\n");
@@ -434,7 +433,7 @@ static int max3110_main_thread(void *_max)
 
 	} while (!kthread_should_stop());
 
-	return ret;
+	return 0;
 }
 
 static irqreturn_t serial_m3110_irq(int irq, void *dev_id)
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 2d822aa..2508596 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -63,7 +63,6 @@ static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc)
 {
 	unsigned long flags;
-	int ret = 0;
 
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return -EINVAL;
@@ -74,7 +73,7 @@ int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc)
 	new_ldisc->refcount = 0;
 	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(tty_register_ldisc);
 
diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index 1270f3b..9f36eea 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -47,7 +47,6 @@ static int uio_dmem_genirq_open(struct uio_info *info, struct inode *inode)
 {
 	struct uio_dmem_genirq_platdata *priv = info->priv;
 	struct uio_mem *uiomem;
-	int ret = 0;
 	int dmem_region = priv->dmem_region_start;
 
 	uiomem = &priv->uioinfo->mem[priv->dmem_region_start];
@@ -71,7 +70,7 @@ static int uio_dmem_genirq_open(struct uio_info *info, struct inode *inode)
 	mutex_unlock(&priv->alloc_lock);
 	/* Wait until the Runtime PM code has woken up the device */
 	pm_runtime_get_sync(&priv->pdev->dev);
-	return ret;
+	return 0;
 }
 
 static int uio_dmem_genirq_release(struct uio_info *info, struct inode *inode)
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 2057c38..46f7a3a 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2437,7 +2437,6 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	u32 epctrl;
 	u32 mps;
 	int dir_in;
-	int ret = 0;
 
 	dev_dbg(hsotg->dev,
 		"%s: ep %s: a 0x%02x, attr 0x%02x, mps 0x%04x, intr %d\n",
@@ -2551,7 +2550,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
 
 	spin_unlock_irqrestore(&hsotg->lock, flags);
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/drivers/usb/gadget/fotg210-udc.c b/drivers/usb/gadget/fotg210-udc.c
index e143d69..7264014 100644
--- a/drivers/usb/gadget/fotg210-udc.c
+++ b/drivers/usb/gadget/fotg210-udc.c
@@ -497,7 +497,6 @@ static int fotg210_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedge)
 	struct fotg210_ep *ep;
 	struct fotg210_udc *fotg210;
 	unsigned long flags;
-	int ret = 0;
 
 	ep = container_of(_ep, struct fotg210_ep, ep);
 
@@ -520,7 +519,7 @@ static int fotg210_set_halt_and_wedge(struct usb_ep *_ep, int value, int wedge)
 	}
 
 	spin_unlock_irqrestore(&ep->fotg210->lock, flags);
-	return ret;
+	return 0;
 }
 
 static int fotg210_ep_set_halt(struct usb_ep *_ep, int value)
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 06b5d77..1813665 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -1796,7 +1796,7 @@ sisusb_setup_screen(struct sisusb_usb_data *sisusb, int clrall, int drwfr)
 static int
 sisusb_set_default_mode(struct sisusb_usb_data *sisusb, int touchengines)
 {
-	int ret = 0, i, j, modex, modey, bpp, du;
+	int i, j, modex, modey, bpp, du;
 	u8 sr31, cr63, tmp8;
 	static const char attrdata[] = {
 		0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,
@@ -1922,7 +1922,7 @@ sisusb_set_default_mode(struct sisusb_usb_data *sisusb, int touchengines)
 
 	SETIREG(SISCR, 0x34, 0x44);	/* we just set std mode #44 */
 
-	return ret;
+	return 0;
 }
 
 static int
diff --git a/drivers/uwb/rsv.c b/drivers/uwb/rsv.c
index 3fe6119..75d9863 100644
--- a/drivers/uwb/rsv.c
+++ b/drivers/uwb/rsv.c
@@ -610,7 +610,6 @@ int uwb_rsv_try_move(struct uwb_rsv *rsv, struct uwb_mas_bm *available)
 	struct uwb_drp_backoff_win *bow = &rc->bow;
 	struct device *dev = &rc->uwb_dev.dev;
 	struct uwb_rsv_move *mv;
-	int ret = 0;
 
 	if (bow->can_reserve_extra_mases == false)
 		return -EBUSY;
@@ -629,7 +628,7 @@ int uwb_rsv_try_move(struct uwb_rsv *rsv, struct uwb_mas_bm *available)
 		dev_dbg(dev, "new allocation not found\n");
 	}
 
-	return ret;
+	return 0;
 }
 
 /* It will try to move every reservation in state O_ESTABLISHED giving
diff --git a/drivers/video/fbdev/pxa168fb.c b/drivers/video/fbdev/pxa168fb.c
index c95b9e4..db09f44 100644
--- a/drivers/video/fbdev/pxa168fb.c
+++ b/drivers/video/fbdev/pxa168fb.c
@@ -565,7 +565,6 @@ static int pxa168fb_init_mode(struct fb_info *info,
 {
 	struct pxa168fb_info *fbi = info->par;
 	struct fb_var_screeninfo *var = &info->var;
-	int ret = 0;
 	u32 total_w, total_h, refresh;
 	u64 div_result;
 	const struct fb_videomode *m;
@@ -597,7 +596,7 @@ static int pxa168fb_init_mode(struct fb_info *info,
 	do_div(div_result, total_w * total_h * refresh);
 	var->pixclock = (u32)div_result;
 
-	return ret;
+	return 0;
 }
 
 static int pxa168fb_probe(struct platform_device *pdev)
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 32c8fc5..2c88301 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -661,7 +661,6 @@ static int fsl_hv_open(struct inode *inode, struct file *filp)
 {
 	struct doorbell_queue *dbq;
 	unsigned long flags;
-	int ret = 0;
 
 	dbq = kzalloc(sizeof(struct doorbell_queue), GFP_KERNEL);
 	if (!dbq) {
@@ -678,7 +677,7 @@ static int fsl_hv_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = dbq;
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -689,15 +688,13 @@ static int fsl_hv_close(struct inode *inode, struct file *filp)
 	struct doorbell_queue *dbq = filp->private_data;
 	unsigned long flags;
 
-	int ret = 0;
-
 	spin_lock_irqsave(&db_list_lock, flags);
 	list_del(&dbq->list);
 	spin_unlock_irqrestore(&db_list_lock, flags);
 
 	kfree(dbq);
 
-	return ret;
+	return 0;
 }
 
 static const struct file_operations fsl_hv_fops = {
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index a0691df..9401db2 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -75,7 +75,6 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 			    const char *name, u16 name_len,
 			    const void *data, u16 data_len)
 {
-	int ret = 0;
 	struct btrfs_dir_item *dir_item;
 	unsigned long name_ptr, data_ptr;
 	struct btrfs_key key, location;
@@ -110,7 +109,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, data, data_ptr, data_len);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9833149..0c6610d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1057,7 +1057,6 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 {
 	struct extent_buffer *buf = NULL;
 	struct inode *btree_inode = root->fs_info->btree_inode;
-	int ret = 0;
 
 	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
 	if (!buf)
@@ -1065,7 +1064,7 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
 				 buf, 0, WAIT_NONE, btree_get_extent, 0);
 	free_extent_buffer(buf);
-	return ret;
+	return 0;
 }
 
 int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
@@ -3846,7 +3845,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
-	int ret = 0;
 
 	delayed_refs = &trans->delayed_refs;
 
@@ -3854,7 +3852,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	if (atomic_read(&delayed_refs->num_entries) == 0) {
 		spin_unlock(&delayed_refs->lock);
 		btrfs_info(root->fs_info, "delayed_refs has NO entry");
-		return ret;
+		return 0;
 	}
 
 	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {
@@ -3905,7 +3903,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 	spin_unlock(&delayed_refs->lock);
 
-	return ret;
+	return 0;
 }
 
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 1874aee..c4fb583 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -273,7 +273,6 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 		       u64 gen)
 {
-	int ret = 0;
 	struct extent_map *em;
 	bool prealloc = false;
 
@@ -307,7 +306,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 	free_extent_map(em);
 out:
 	write_unlock(&tree->lock);
-	return ret;
+	return 0;
 
 }
 
@@ -429,14 +428,12 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
  */
 int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 {
-	int ret = 0;
-
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
 	rb_erase(&em->rb_node, &tree->map);
 	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
 		list_del_init(&em->list);
 	RB_CLEAR_NODE(&em->rb_node);
-	return ret;
+	return 0;
 }
 
 void replace_extent_mapping(struct extent_map_tree *tree,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e2f45fc..58b9342 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -224,12 +224,10 @@ static int join_running_log_trans(struct btrfs_root *root)
  */
 int btrfs_pin_log_trans(struct btrfs_root *root)
 {
-	int ret = -ENOENT;
-
 	mutex_lock(&root->log_mutex);
 	atomic_inc(&root->log_writers);
 	mutex_unlock(&root->log_mutex);
-	return ret;
+	return -ENOENT;
 }
 
 /*
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 49ba7ff..fca8faf 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -546,7 +546,6 @@ add_failed:
 static int metapage_releasepage(struct page *page, gfp_t gfp_mask)
 {
 	struct metapage *mp;
-	int ret = 1;
 	int offset;
 
 	for (offset = 0; offset < PAGE_CACHE_SIZE; offset += PSIZE) {
@@ -569,7 +568,7 @@ static int metapage_releasepage(struct page *page, gfp_t gfp_mask)
 		INCREMENT(mpStat.pagefree);
 		free_metapage(mp);
 	}
-	return ret;
+	return 1;
 }
 
 static void metapage_invalidatepage(struct page *page, unsigned int offset,
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 39e6ef3..0a12314 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -144,7 +144,6 @@ static int kcore_update_ram(void)
 {
 	LIST_HEAD(head);
 	struct kcore_list *ent;
-	int ret = 0;
 
 	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
 	if (!ent)
@@ -154,7 +153,7 @@ static int kcore_update_ram(void)
 	ent->type = KCORE_RAM;
 	list_add(&ent->list, &head);
 	__kcore_update_ram(&head);
-	return ret;
+	return 0;
 }
 
 #else /* !CONFIG_HIGHMEM */
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index fd77703..c7b9e7c 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1632,7 +1632,6 @@ static int dirty_one_transaction(struct super_block *s,
 {
 	struct reiserfs_journal_cnode *cn;
 	struct reiserfs_journal_list *pjl;
-	int ret = 0;
 
 	jl->j_state |= LIST_DIRTY;
 	cn = jl->j_realblock;
@@ -1659,7 +1658,7 @@ static int dirty_one_transaction(struct super_block *s,
 		}
 		cn = cn->next;
 	}
-	return ret;
+	return 0;
 }
 
 static int kupdate_transactions(struct super_block *s,
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 1adf62b..00a8769 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -246,7 +246,6 @@ static void kgdb_flush_swbreak_addr(unsigned long addr)
 int dbg_activate_sw_breakpoints(void)
 {
 	int error;
-	int ret = 0;
 	int i;
 
 	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
@@ -264,7 +263,7 @@ int dbg_activate_sw_breakpoints(void)
 		kgdb_flush_swbreak_addr(kgdb_break[i].bpt_addr);
 		kgdb_break[i].state = BP_ACTIVE;
 	}
-	return ret;
+	return 0;
 }
 
 int dbg_set_sw_break(unsigned long addr)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1e5c71c..577eba6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7477,7 +7477,7 @@ static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 static int sched_rt_global_constraints(void)
 {
 	unsigned long flags;
-	int i, ret = 0;
+	int i;
 
 	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	for_each_possible_cpu(i) {
@@ -7489,7 +7489,7 @@ static int sched_rt_global_constraints(void)
 	}
 	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
 
-	return ret;
+	return 0;
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 8c102ce..a6bc9be 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1312,7 +1312,6 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 	unsigned long end;
-	int ret = SWAP_AGAIN;
 	int locked_vma = 0;
 
 	address = (vma->vm_start + cursor) & CLUSTER_MASK;
@@ -1324,7 +1323,7 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd)
-		return ret;
+		return SWAP_AGAIN;
 
 	mmun_start = address;
 	mmun_end   = end;
@@ -1396,7 +1395,7 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	if (locked_vma)
 		up_read(&vma->vm_mm->mmap_sem);
-	return ret;
+	return SWAP_AGAIN;
 }
 
 static int try_to_unmap_nonlinear(struct page *page,
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 6ab36ae..404c34c 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -171,13 +171,11 @@ void v9fs_put_trans(struct p9_trans_module *m)
  */
 static int __init init_p9(void)
 {
-	int ret = 0;
-
 	p9_error_init();
 	pr_info("Installing 9P2000 support\n");
 	p9_trans_fd_init();
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index d67de45..3abf179 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -1037,13 +1037,12 @@ void rds_ib_recv_tasklet_fn(unsigned long data)
 int rds_ib_recv(struct rds_connection *conn)
 {
 	struct rds_ib_connection *ic = conn->c_transport_data;
-	int ret = 0;
 
 	rdsdebug("conn %p\n", conn);
 	if (rds_conn_up(conn))
 		rds_ib_attempt_ack(ic);
 
-	return ret;
+	return 0;
 }
 
 int rds_ib_recv_init(void)
diff --git a/net/rds/iw_rdma.c b/net/rds/iw_rdma.c
index a817705..5a346a7 100644
--- a/net/rds/iw_rdma.c
+++ b/net/rds/iw_rdma.c
@@ -490,7 +490,6 @@ static int rds_iw_flush_mr_pool(struct rds_iw_mr_pool *pool, int free_all)
 	LIST_HEAD(kill_list);
 	unsigned long flags;
 	unsigned int nfreed = 0, ncleaned = 0, unpinned = 0;
-	int ret = 0;
 
 	rds_iw_stats_inc(s_iw_rdma_mr_pool_flush);
 
@@ -542,7 +541,7 @@ static int rds_iw_flush_mr_pool(struct rds_iw_mr_pool *pool, int free_all)
 	atomic_sub(nfreed, &pool->item_count);
 
 	mutex_unlock(&pool->flush_lock);
-	return ret;
+	return 0;
 }
 
 static void rds_iw_mr_pool_flush_worker(struct work_struct *work)
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 25688fa..d99d711 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -589,7 +589,6 @@ static int rdma_listen_handler(struct rdma_cm_id *cma_id,
 			       struct rdma_cm_event *event)
 {
 	struct svcxprt_rdma *xprt = cma_id->context;
-	int ret = 0;
 
 	switch (event->event) {
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
@@ -618,7 +617,7 @@ static int rdma_listen_handler(struct rdma_cm_id *cma_id,
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int rdma_cma_handler(struct rdma_cm_id *cma_id,
diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 58f292a..f6e8b47 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -646,7 +646,6 @@ static int snd_ps3_pcm_trigger(struct snd_pcm_substream *substream,
 			       int cmd)
 {
 	struct snd_ps3_card_info *card = snd_pcm_substream_chip(substream);
-	int ret = 0;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -683,7 +682,7 @@ static int snd_ps3_pcm_trigger(struct snd_pcm_substream *substream,
 
 	}
 
-	return ret;
+	return 0;
 };
 
 /*
diff --git a/sound/soc/codecs/wm8971.c b/sound/soc/codecs/wm8971.c
index 09b7b42..435f90a 100644
--- a/sound/soc/codecs/wm8971.c
+++ b/sound/soc/codecs/wm8971.c
@@ -645,7 +645,6 @@ static int wm8971_resume(struct snd_soc_codec *codec)
 
 static int wm8971_probe(struct snd_soc_codec *codec)
 {
-	int ret = 0;
 	u16 reg;
 
 	INIT_DELAYED_WORK(&codec->dapm.delayed_work, wm8971_work);
@@ -672,7 +671,7 @@ static int wm8971_probe(struct snd_soc_codec *codec)
 	snd_soc_update_bits(codec, WM8971_LINVOL, 0x0100, 0x0100);
 	snd_soc_update_bits(codec, WM8971_RINVOL, 0x0100, 0x0100);
 
-	return ret;
+	return 0;
 }
 
 
diff --git a/sound/soc/intel/sst-haswell-ipc.c b/sound/soc/intel/sst-haswell-ipc.c
index e7996b3..38ab072 100644
--- a/sound/soc/intel/sst-haswell-ipc.c
+++ b/sound/soc/intel/sst-haswell-ipc.c
@@ -809,7 +809,6 @@ static int hsw_log_message(struct sst_hsw *hsw, u32 header)
 {
 	u32 operation = (header & IPC_LOG_OP_MASK) >>  IPC_LOG_OP_SHIFT;
 	struct sst_hsw_log_stream *stream = &hsw->log_stream;
-	int ret = 1;
 
 	if (operation != IPC_DEBUG_REQUEST_LOG_DUMP) {
 		dev_err(hsw->dev,
@@ -825,7 +824,7 @@ static int hsw_log_message(struct sst_hsw *hsw, u32 header)
 
 	schedule_work(&stream->notify_work);
 
-	return ret;
+	return 1;
 }
 
 static int hsw_process_notification(struct sst_hsw *hsw)
diff --git a/sound/soc/omap/mcbsp.c b/sound/soc/omap/mcbsp.c
index 86c7538..88a55b2 100644
--- a/sound/soc/omap/mcbsp.c
+++ b/sound/soc/omap/mcbsp.c
@@ -412,7 +412,6 @@ static int omap_st_stop(struct omap_mcbsp *mcbsp)
 int omap_st_disable(struct omap_mcbsp *mcbsp)
 {
 	struct omap_mcbsp_st_data *st_data = mcbsp->st_data;
-	int ret = 0;
 
 	if (!st_data)
 		return -ENODEV;
@@ -422,7 +421,7 @@ int omap_st_disable(struct omap_mcbsp *mcbsp)
 	st_data->enabled = 0;
 	spin_unlock_irq(&mcbsp->lock);
 
-	return ret;
+	return 0;
 }
 
 int omap_st_is_enabled(struct omap_mcbsp *mcbsp)
diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index a3119a0..e8ff629 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -96,7 +96,6 @@ static int pxa_ssp_startup(struct snd_pcm_substream *substream,
 	struct ssp_priv *priv = snd_soc_dai_get_drvdata(cpu_dai);
 	struct ssp_device *ssp = priv->ssp;
 	struct snd_dmaengine_dai_dma_data *dma;
-	int ret = 0;
 
 	if (!cpu_dai->active) {
 		clk_enable(ssp->clk);
@@ -112,7 +111,7 @@ static int pxa_ssp_startup(struct snd_pcm_substream *substream,
 
 	snd_soc_dai_set_dma_data(cpu_dai, substream, dma);
 
-	return ret;
+	return 0;
 }
 
 static void pxa_ssp_shutdown(struct snd_pcm_substream *substream,
diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index dc09b71..b95cb7f 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -220,7 +220,6 @@ static int dma_hw_free(struct snd_pcm_substream *substream)
 static int dma_prepare(struct snd_pcm_substream *substream)
 {
 	struct runtime_data *prtd = substream->runtime->private_data;
-	int ret = 0;
 
 	pr_debug("Entered %s\n", __func__);
 
@@ -238,7 +237,7 @@ static int dma_prepare(struct snd_pcm_substream *substream)
 	/* enqueue dma buffers */
 	dma_enqueue(substream);
 
-	return ret;
+	return 0;
 }
 
 static int dma_trigger(struct snd_pcm_substream *substream, int cmd)
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index a74b9bf..1906a83 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2528,7 +2528,7 @@ EXPORT_SYMBOL_GPL(snd_soc_dapm_add_routes);
 int snd_soc_dapm_del_routes(struct snd_soc_dapm_context *dapm,
 			    const struct snd_soc_dapm_route *route, int num)
 {
-	int i, ret = 0;
+	int i;
 
 	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_INIT);
 	for (i = 0; i < num; i++) {
@@ -2537,7 +2537,7 @@ int snd_soc_dapm_del_routes(struct snd_soc_dapm_context *dapm,
 	}
 	mutex_unlock(&dapm->card->dapm_mutex);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_del_routes);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 893f8e2..bb5cbc8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2202,7 +2202,6 @@ static int do_write_feat(int fd, struct perf_header *h, int type,
 			 struct perf_evlist *evlist)
 {
 	int err;
-	int ret = 0;
 
 	if (perf_header__has_feat(h, type)) {
 		if (!feat_ops[type].write)
@@ -2222,7 +2221,7 @@ static int do_write_feat(int fd, struct perf_header *h, int type,
 		(*p)->size = lseek(fd, 0, SEEK_CUR) - (*p)->offset;
 		(*p)++;
 	}
-	return ret;
+	return 0;
 }
 
 static int perf_header__adds_write(struct perf_header *header,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 95e2497..78f97bc 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -431,7 +431,6 @@ void dso__sort_by_name(struct dso *dso, enum map_type type)
 size_t dso__fprintf_symbols_by_name(struct dso *dso,
 				    enum map_type type, FILE *fp)
 {
-	size_t ret = 0;
 	struct rb_node *nd;
 	struct symbol_name_rb_node *pos;
 
@@ -440,7 +439,7 @@ size_t dso__fprintf_symbols_by_name(struct dso *dso,
 		fprintf(fp, "%s\n", pos->sym.name);
 	}
 
-	return ret;
+	return 0;
 }
 
 int modules__parse(const char *filename, void *arg,
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index e113e18..63a1192 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -214,7 +214,6 @@ static int read_header_files(struct pevent *pevent)
 	unsigned long long size;
 	char *header_page;
 	char buf[BUFSIZ];
-	int ret = 0;
 
 	if (do_read(buf, 12) < 0)
 		return -1;
@@ -257,7 +256,7 @@ static int read_header_files(struct pevent *pevent)
 	size = read8(pevent);
 	skip(size);
 
-	return ret;
+	return 0;
 }
 
 static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
diff --git a/tools/thermal/tmon/pid.c b/tools/thermal/tmon/pid.c
index fd7e9e9..40beb2d 100644
--- a/tools/thermal/tmon/pid.c
+++ b/tools/thermal/tmon/pid.c
@@ -65,9 +65,6 @@ static double xk_1, xk_2; /* input temperature x[k-#] */
  */
 int init_thermal_controller(void)
 {
-	int ret = 0;
-
-	/* init pid params */
 	p_param.ts = ticktime;
 	/* TODO: get it from TUI tuning tab */
 	p_param.kp = .36;
@@ -76,7 +73,7 @@ int init_thermal_controller(void)
 
 	p_param.t_target = target_temp_user;
 
-	return ret;
+	return 0;
 }
 
 void controller_reset(void)
-- 
1.8.3.1

