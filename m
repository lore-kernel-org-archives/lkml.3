Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3KYOFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:05:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58948 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab3KYNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John W. Linville" <linville@tuxdriver.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.20673800@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 42/87] iwlwifi: remove un-supported SKUs
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit b6cb406a023184733bffc7762a75a2e204fff6b9 upstream.

BG only SKUs are no longer supported by 2000 and 1x5 series. Remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c | 20 --------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c | 10 ----------
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |  6 ------
 drivers/net/wireless/iwlwifi/iwl-pci.c  | 18 ------------------
 4 files changed, 54 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -270,11 +270,6 @@ struct iwl_cfg iwl2000_2bgn_cfg = {
 	.ht_params = &iwl2000_ht_params,
 };
 
-struct iwl_cfg iwl2000_2bg_cfg = {
-	.name = "2000 Series 2x2 BG",
-	IWL_DEVICE_2000,
-};
-
 struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.name = "2000D Series 2x2 BGN",
 	IWL_DEVICE_2000,
@@ -304,11 +299,6 @@ struct iwl_cfg iwl2030_2bgn_cfg = {
 	.ht_params = &iwl2000_ht_params,
 };
 
-struct iwl_cfg iwl2030_2bg_cfg = {
-	.name = "2000 Series 2x2 BG/BT",
-	IWL_DEVICE_2030,
-};
-
 #define IWL_DEVICE_105						\
 	.fw_name_pre = IWL105_FW_PRE,				\
 	.ucode_api_max = IWL105_UCODE_API_MAX,			\
@@ -326,11 +316,6 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	.rx_with_siso_diversity = true,				\
 	.iq_invert = true					\
 
-struct iwl_cfg iwl105_bg_cfg = {
-	.name = "105 Series 1x1 BG",
-	IWL_DEVICE_105,
-};
-
 struct iwl_cfg iwl105_bgn_cfg = {
 	.name = "105 Series 1x1 BGN",
 	IWL_DEVICE_105,
@@ -361,11 +346,6 @@ struct iwl_cfg iwl105_bgn_d_cfg = {
 	.rx_with_siso_diversity = true,				\
 	.iq_invert = true					\
 
-struct iwl_cfg iwl135_bg_cfg = {
-	.name = "135 Series 1x1 BG/BT",
-	IWL_DEVICE_135,
-};
-
 struct iwl_cfg iwl135_bgn_cfg = {
 	.name = "135 Series 1x1 BGN/BT",
 	IWL_DEVICE_135,
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -469,16 +469,6 @@ struct iwl_cfg iwl6035_2agn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6035_2abg_cfg = {
-	.name = "6035 Series 2x2 ABG/BT",
-	IWL_DEVICE_6030,
-};
-
-struct iwl_cfg iwl6035_2bg_cfg = {
-	.name = "6035 Series 2x2 BG/BT",
-	IWL_DEVICE_6030,
-};
-
 struct iwl_cfg iwl1030_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
 	IWL_DEVICE_6030,
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -101,17 +101,11 @@ extern struct iwl_cfg iwl100_bg_cfg;
 extern struct iwl_cfg iwl130_bgn_cfg;
 extern struct iwl_cfg iwl130_bg_cfg;
 extern struct iwl_cfg iwl2000_2bgn_cfg;
-extern struct iwl_cfg iwl2000_2bg_cfg;
 extern struct iwl_cfg iwl2000_2bgn_d_cfg;
 extern struct iwl_cfg iwl2030_2bgn_cfg;
-extern struct iwl_cfg iwl2030_2bg_cfg;
 extern struct iwl_cfg iwl6035_2agn_cfg;
-extern struct iwl_cfg iwl6035_2abg_cfg;
-extern struct iwl_cfg iwl6035_2bg_cfg;
-extern struct iwl_cfg iwl105_bg_cfg;
 extern struct iwl_cfg iwl105_bgn_cfg;
 extern struct iwl_cfg iwl105_bgn_d_cfg;
-extern struct iwl_cfg iwl135_bg_cfg;
 extern struct iwl_cfg iwl135_bgn_cfg;
 
 #endif /* __iwl_pci_h__ */
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -328,46 +328,28 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 	{IWL_PCI_DEVICE(0x0890, 0x4022, iwl2000_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0891, 0x4222, iwl2000_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0890, 0x4422, iwl2000_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0890, 0x4026, iwl2000_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0891, 0x4226, iwl2000_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0890, 0x4426, iwl2000_2bg_cfg)},
 	{IWL_PCI_DEVICE(0x0890, 0x4822, iwl2000_2bgn_d_cfg)},
 
 /* 2x30 Series */
 	{IWL_PCI_DEVICE(0x0887, 0x4062, iwl2030_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0888, 0x4262, iwl2030_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0887, 0x4462, iwl2030_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0887, 0x4066, iwl2030_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0888, 0x4266, iwl2030_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0887, 0x4466, iwl2030_2bg_cfg)},
 
 /* 6x35 Series */
 	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4064, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088F, 0x4264, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4464, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4066, iwl6035_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x088F, 0x4266, iwl6035_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4466, iwl6035_2bg_cfg)},
 
 /* 105 Series */
 	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0895, 0x0222, iwl105_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0894, 0x0422, iwl105_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0026, iwl105_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0895, 0x0226, iwl105_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0426, iwl105_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0894, 0x0822, iwl105_bgn_d_cfg)},
 
 /* 135 Series */
 	{IWL_PCI_DEVICE(0x0892, 0x0062, iwl135_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0893, 0x0262, iwl135_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0892, 0x0462, iwl135_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0066, iwl135_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0893, 0x0266, iwl135_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0466, iwl135_bg_cfg)},
 
 	{0}
 };

