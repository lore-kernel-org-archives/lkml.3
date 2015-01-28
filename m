Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbbA1UnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:43:11 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54499 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761443AbbA1UnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:43:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <JBottomley@parallels.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Dov Levenglick <dovl@codeaurora.org>,
        Christoph Hellwig <hch@lst.de>, Kishon Vijay Abraham I <kishon@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] phy: qcom-ufs: export symbols needed by main drivers
Date: Wed, 28 Jan 2015 17:18:05 +0100
Message-ID: <1840882.huchmEIh5K@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:0KGzoFia6keSsrIvhsuK1UmqB/D+aZmgf6Q7nK9OwIjEMZjiY8w
 CtZFCFMaZqMTrFQPEk0jcDMy0AGipy0Nj72Hfvo4LAfyImGK9bISSglSwBmGTdA7lSSI8UT
 UfdKADp/mfLBioRdBiXaahhEAS0YWCMEU9Nt/Vhk8cS0GmXsgH8WoZkD7cR787GjryKL1XY
 IPa4TTqDfeOOfEWX7VAxA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The qcom ufs phy support is split into three separate loadable
modules, however none of the interfaces are exported, resulting
in a link error:

ERROR: "ufs_qcom_phy_power_off" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "ufs_qcom_phy_power_on" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "ufs_qcom_phy_exit" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "ufs_qcom_phy_generic_probe" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "ufs_qcom_phy_init_vregulators" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "ufs_qcom_phy_init_clks" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "ufs_qcom_phy_calibrate" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "ufs_qcom_phy_remove" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "get_ufs_qcom_phy" [drivers/phy/phy-qcom-ufs-qmp-20nm.ko] undefined!
ERROR: "ufs_qcom_phy_power_off" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!
ERROR: "ufs_qcom_phy_power_on" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!
ERROR: "ufs_qcom_phy_exit" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!
ERROR: "ufs_qcom_phy_generic_probe" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!
ERROR: "ufs_qcom_phy_init_vregulators" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!
ERROR: "ufs_qcom_phy_init_clks" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!
ERROR: "ufs_qcom_phy_calibrate" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!
ERROR: "ufs_qcom_phy_remove" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!
ERROR: "get_ufs_qcom_phy" [drivers/phy/phy-qcom-ufs-qmp-14nm.ko] undefined!

This exports all of the symbols that are provided by the base library
module and used by the two driver modules.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: adaafaa393ef ("phy: qcom-ufs: add support for QUALCOMM Technologies UFS PHY drivers")
---

The broken patch is currently in the scsi tree, so if the phy maintainer
thinks that my fix is correct, it should go there too.

An alternative approach would be to link all three phy-qcom-ufs source
files into a single module.

 drivers/phy/phy-qcom-ufs.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 44ee983d57fe..c8f8c2dac18c 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -73,6 +73,7 @@ int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_calibrate);
 
 struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
 				struct ufs_qcom_phy *common_cfg,
@@ -110,6 +111,7 @@ struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
 out:
 	return generic_phy;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_generic_probe);
 
 /*
  * This assumes the embedded phy structure inside generic_phy is of type
@@ -121,6 +123,7 @@ struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy)
 {
 	return (struct ufs_qcom_phy *)phy_get_drvdata(generic_phy);
 }
+EXPORT_SYMBOL_GPL(get_ufs_qcom_phy);
 
 static
 int ufs_qcom_phy_base_init(struct platform_device *pdev,
@@ -228,6 +231,7 @@ ufs_qcom_phy_init_clks(struct phy *generic_phy,
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_init_clks);
 
 int
 ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
@@ -252,6 +256,7 @@ ufs_qcom_phy_init_vregulators(struct phy *generic_phy,
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_init_vregulators);
 
 static int __ufs_qcom_phy_init_vreg(struct phy *phy,
 		struct ufs_qcom_phy_vreg *vreg, const char *name, bool optional)
@@ -443,6 +448,7 @@ out_disable_src:
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_ref_clk);
 
 static
 int ufs_qcom_phy_disable_vreg(struct phy *phy,
@@ -485,6 +491,7 @@ void ufs_qcom_phy_disable_ref_clk(struct phy *generic_phy)
 		phy->is_ref_clk_enabled = false;
 	}
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_ref_clk);
 
 #define UFS_REF_CLK_EN	(1 << 5)
 
@@ -523,16 +530,19 @@ static void ufs_qcom_phy_dev_ref_clk_ctrl(struct phy *generic_phy, bool enable)
 		phy->is_dev_ref_clk_enabled = enable;
 	}
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_dev_ref_clk_ctrl);
 
 void ufs_qcom_phy_enable_dev_ref_clk(struct phy *generic_phy)
 {
 	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, true);
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_dev_ref_clk);
 
 void ufs_qcom_phy_disable_dev_ref_clk(struct phy *generic_phy)
 {
 	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, false);
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_dev_ref_clk);
 
 /* Turn ON M-PHY RMMI interface clocks */
 int ufs_qcom_phy_enable_iface_clk(struct phy *generic_phy)
@@ -561,6 +571,7 @@ int ufs_qcom_phy_enable_iface_clk(struct phy *generic_phy)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_iface_clk);
 
 /* Turn OFF M-PHY RMMI interface clocks */
 void ufs_qcom_phy_disable_iface_clk(struct phy *generic_phy)
@@ -573,6 +584,7 @@ void ufs_qcom_phy_disable_iface_clk(struct phy *generic_phy)
 		phy->is_iface_clk_enabled = false;
 	}
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_iface_clk);
 
 int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
 {
@@ -589,6 +601,7 @@ int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_start_serdes);
 
 int ufs_qcom_phy_set_tx_lane_enable(struct phy *generic_phy, u32 tx_lanes)
 {
@@ -606,6 +619,7 @@ int ufs_qcom_phy_set_tx_lane_enable(struct phy *generic_phy, u32 tx_lanes)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_set_tx_lane_enable);
 
 void ufs_qcom_phy_save_controller_version(struct phy *generic_phy,
 					  u8 major, u16 minor, u16 step)
@@ -616,6 +630,7 @@ void ufs_qcom_phy_save_controller_version(struct phy *generic_phy,
 	ufs_qcom_phy->host_ctrl_rev_minor = minor;
 	ufs_qcom_phy->host_ctrl_rev_step = step;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_save_controller_version);
 
 int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rate_B)
 {
@@ -636,6 +651,7 @@ int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rate_B)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_calibrate_phy);
 
 int ufs_qcom_phy_remove(struct phy *generic_phy,
 			struct ufs_qcom_phy *ufs_qcom_phy)
@@ -647,6 +663,7 @@ int ufs_qcom_phy_remove(struct phy *generic_phy,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_remove);
 
 int ufs_qcom_phy_exit(struct phy *generic_phy)
 {
@@ -657,6 +674,7 @@ int ufs_qcom_phy_exit(struct phy *generic_phy)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_exit);
 
 int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy)
 {
@@ -671,6 +689,7 @@ int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy)
 	return ufs_qcom_phy->phy_spec_ops->
 			is_physical_coding_sublayer_ready(ufs_qcom_phy);
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_is_pcs_ready);
 
 int ufs_qcom_phy_power_on(struct phy *generic_phy)
 {
@@ -725,6 +744,7 @@ out_disable_phy:
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_power_on);
 
 int ufs_qcom_phy_power_off(struct phy *generic_phy)
 {
@@ -743,3 +763,4 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_power_off);

