Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaH1R0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:26:34 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37688 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaH1R0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:26:33 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typo in printk
Date: Fri, 29 Aug 2014 02:26:05 +0900
Message-Id: <1409246765-28327-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo in printk.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/m68k/Kconfig.devices                   | 2 +-
 arch/mips/lantiq/falcon/sysctrl.c           | 2 +-
 arch/mips/lantiq/xway/sysctrl.c             | 2 +-
 arch/mips/pci/pci-lantiq.c                  | 2 +-
 arch/powerpc/kvm/e500_mmu_host.c            | 2 +-
 arch/powerpc/platforms/powernv/opal.c       | 2 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c    | 4 ++--
 drivers/net/ethernet/via/via-velocity.c     | 2 +-
 drivers/net/wireless/libertas/cfg.c         | 2 +-
 drivers/scsi/fnic/fnic_debugfs.c            | 2 +-
 drivers/scsi/fnic/fnic_trace.c              | 2 +-
 drivers/video/backlight/88pm860x_bl.c       | 2 +-
 net/netfilter/ipset/ip_set_core.c           | 2 +-
 scripts/sign-file                           | 2 +-
 16 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index d163991..2a74777 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -73,7 +73,7 @@ config ATARI_ETHERNEC
 	  ROM port. The driver works by polling instead of interrupts, so it
 	  is quite slow.
 
-	  This driver also suppports the ethernet part of the NetUSBee ROM
+	  This driver also supports the ethernet part of the NetUSBee ROM
 	  port combined Ethernet/USB adapter.
 
 	  To compile the actual ethernet driver, choose Y or M in for the NE2000
diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index 8f1866d..468ffa0 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -221,7 +221,7 @@ void __init ltq_soc_init(void)
 		(request_mem_region(res_sys[2].start,
 				resource_size(&res_sys[2]),
 				res_sys[2].name) < 0))
-		pr_err("Failed to request core reources");
+		pr_err("Failed to request core resources");
 
 	status_membase = ioremap_nocache(res_status.start,
 					resource_size(&res_status));
diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index 51804b1..2b15491 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -318,7 +318,7 @@ void __init ltq_soc_init(void)
 				res_cgu.name) < 0) ||
 		(request_mem_region(res_ebu.start, resource_size(&res_ebu),
 				res_ebu.name) < 0))
-		pr_err("Failed to request core reources");
+		pr_err("Failed to request core resources");
 
 	pmu_membase = ioremap_nocache(res_pmu.start, resource_size(&res_pmu));
 	ltq_cgu_membase = ioremap_nocache(res_cgu.start,
diff --git a/arch/mips/pci/pci-lantiq.c b/arch/mips/pci/pci-lantiq.c
index cb1ef99..37fe8e7 100644
--- a/arch/mips/pci/pci-lantiq.c
+++ b/arch/mips/pci/pci-lantiq.c
@@ -218,7 +218,7 @@ static int ltq_pci_probe(struct platform_device *pdev)
 	res_cfg = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	res_bridge = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!res_cfg || !res_bridge) {
-		dev_err(&pdev->dev, "missing memory reources\n");
+		dev_err(&pdev->dev, "missing memory resources\n");
 		return -EINVAL;
 	}
 
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 08f14bb..c33cc7d 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -663,7 +663,7 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu, enum instruction_type type,
 	if (unlikely((pr && !(mas3 & MAS3_UX)) ||
 		     (!pr && !(mas3 & MAS3_SX)))) {
 		pr_err_ratelimited(
-			"%s: Instuction emulation from guest addres %08lx without execute permission\n",
+			"%s: Instuction emulation from guest address %08lx without execute permission\n",
 			__func__, geaddr);
 		return EMULATE_AGAIN;
 	}
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index b44eec3..4b005ae 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -322,7 +322,7 @@ static void opal_handle_message(void)
 
 	/* check for errors. */
 	if (ret) {
-		pr_warning("%s: Failed to retrive opal message, err=%lld\n",
+		pr_warning("%s: Failed to retrieve opal message, err=%lld\n",
 				__func__, ret);
 		return;
 	}
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 6f7816e..244d733 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -436,7 +436,7 @@ static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		ret = adf_ctl_ioctl_get_status(fp, cmd, arg);
 		break;
 	default:
-		pr_err("QAT: Invalid ioclt\n");
+		pr_err("QAT: Invalid ioctl\n");
 		ret = -EFAULT;
 		break;
 	}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index acb434d..e063c02 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1870,7 +1870,7 @@ static int ocrdma_build_inline_sges(struct ocrdma_qp *qp,
 		hdr->total_len = ocrdma_sglist_len(wr->sg_list, wr->num_sge);
 		if (unlikely(hdr->total_len > qp->max_inline_data)) {
 			pr_err("%s() supported_len=0x%x,\n"
-			       " unspported len req=0x%x\n", __func__,
+			       " unsupported len req=0x%x\n", __func__,
 				qp->max_inline_data, hdr->total_len);
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 65a4a0f..73b7c40 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1695,7 +1695,7 @@ static int mlx4_master_activate_admin_state(struct mlx4_priv *priv, int slave)
 			if (err) {
 				vp_oper->vlan_idx = NO_INDX;
 				mlx4_warn(&priv->dev,
-					  "No vlan resorces slave %d, port %d\n",
+					  "No vlan resources slave %d, port %d\n",
 					  slave, port);
 				return err;
 			}
@@ -1711,7 +1711,7 @@ static int mlx4_master_activate_admin_state(struct mlx4_priv *priv, int slave)
 				err = vp_oper->mac_idx;
 				vp_oper->mac_idx = NO_INDX;
 				mlx4_warn(&priv->dev,
-					  "No mac resorces slave %d, port %d\n",
+					  "No mac resources slave %d, port %d\n",
 					  slave, port);
 				return err;
 			}
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index f5fbc12..24ef4ca 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2056,7 +2056,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 	struct sk_buff *skb;
 
 	if (rd->rdesc0.RSR & (RSR_STP | RSR_EDP)) {
-		VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame span multple RDs.\n", vptr->netdev->name);
+		VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame span multiple RDs.\n", vptr->netdev->name);
 		stats->rx_length_errors++;
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 47a998d..40ab7f0 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1353,7 +1353,7 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 		wait_event_interruptible_timeout(priv->scan_q,
 						 (priv->scan_req == NULL),
 						 (15 * HZ));
-		lbs_deb_assoc("assoc: scanning competed\n");
+		lbs_deb_assoc("assoc: scanning completed\n");
 	}
 
 	/* Find the BSS we want using available scan results */
diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 2c613bd..5980c10 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -210,7 +210,7 @@ static ssize_t fnic_trace_ctrl_write(struct file *filp,
 	else if (*trace_type == fc_trc_flag->fc_clear)
 		fnic_fc_trace_cleared = val;
 	else
-		pr_err("fnic: cannot write to any debufs file\n");
+		pr_err("fnic: cannot write to any debugfs file\n");
 
 	(*ppos)++;
 
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index c772859..8b1b387 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -592,7 +592,7 @@ int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
 
 	if (fnic_fc_trace_cleared == 1) {
 		fc_trace_entries.rd_idx = fc_trace_entries.wr_idx = 0;
-		pr_info("fnic: Reseting the read idx\n");
+		pr_info("fnic: Resetting the read idx\n");
 		memset((void *)fnic_fc_ctlr_trace_buf_p, 0,
 				fnic_fc_trace_max_pages * PAGE_SIZE);
 		fnic_fc_trace_cleared = 0;
diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 7db5234..a6f7cc0 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -216,7 +216,7 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	data->reg_duty_cycle = res->start;
 	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "always on");
 	if (!res) {
-		dev_err(&pdev->dev, "No REG resorce for always on\n");
+		dev_err(&pdev->dev, "No REG resource for always on\n");
 		return -ENXIO;
 	}
 	data->reg_always_on = res->start;
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index ec8114f..5edbbe8 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -478,7 +478,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 
 	if (ret == -EAGAIN) {
 		/* Type requests element to be completed */
-		pr_debug("element must be competed, ADD is triggered\n");
+		pr_debug("element must be completed, ADD is triggered\n");
 		write_lock_bh(&set->lock);
 		set->variant->kadt(set, skb, par, IPSET_ADD, opt);
 		write_unlock_bh(&set->lock);
diff --git a/scripts/sign-file b/scripts/sign-file
index 2b7c448..3906ee1 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -398,7 +398,7 @@ if ($verbose) {
     print "Size of signer's name  : ", length($signers_name), "\n";
     print "Size of key identifier : ", length($key_identifier), "\n";
     print "Size of signature      : ", length($signature), "\n";
-    print "Size of informaton     : ", length($info), "\n";
+    print "Size of information    : ", length($info), "\n";
     print "Size of magic number   : ", length($magic_number), "\n";
     print "Signer's name          : '", $signers_name, "'\n";
     print "Digest                 : $dgst\n";
-- 
1.9.3

