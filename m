Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3KYN3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:29:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3KYNHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 06/78] iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series
Date: Mon, 25 Nov 2013 13:05:53 +0000
Message-Id: <1385384825-21681-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 08a5dd3842f2ac61c6d69661d2d96022df8ae359 upstream.

Add some new PCI IDs to the table for 6000, 6005 and 6235 series.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.5: files renamed:
  - iwlwifi/pcie/drv.c -> iwlwifi/iwl-pci.c
  - iwlwifi/iwl-config.h -> iwlwifi/iwl-cfg.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |  6 ++++++
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |  1 +
 drivers/net/wireless/iwlwifi/iwl-pci.c  | 10 ++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index e5e8ada..e6cb3f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -252,6 +252,12 @@ const struct iwl_cfg iwl6035_2agn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 };
 
+const struct iwl_cfg iwl6035_2agn_sff_cfg = {
+	.name = "Intel(R) Centrino(R) Ultimate-N 6235 AGN",
+	IWL_DEVICE_6035,
+	.ht_params = &iwl6000_ht_params,
+};
+
 const struct iwl_cfg iwl1030_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
 	IWL_DEVICE_6030,
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
index 82152311..a133e9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -106,6 +106,7 @@ extern const struct iwl_cfg iwl2000_2bgn_cfg;
 extern const struct iwl_cfg iwl2000_2bgn_d_cfg;
 extern const struct iwl_cfg iwl2030_2bgn_cfg;
 extern const struct iwl_cfg iwl6035_2agn_cfg;
+extern const struct iwl_cfg iwl6035_2agn_sff_cfg;
 extern const struct iwl_cfg iwl105_bgn_cfg;
 extern const struct iwl_cfg iwl105_bgn_d_cfg;
 extern const struct iwl_cfg iwl135_bgn_cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 2b425da..8679184 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -140,13 +140,16 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 
 /* 6x00 Series */
 	{IWL_PCI_DEVICE(0x422B, 0x1101, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422B, 0x1108, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x422B, 0x1121, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422B, 0x1128, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1301, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1306, iwl6000i_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1307, iwl6000i_2bg_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1321, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x422C, 0x1326, iwl6000i_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x4238, 0x1111, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x4238, 0x1118, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
 
@@ -154,12 +157,16 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6005_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1308, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1326, iwl6005_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1328, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6005_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1318, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0xC020, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0xC220, iwl6005_2agn_sff_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0xC228, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x4820, iwl6005_2agn_d_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1304, iwl6005_2agn_mow1_cfg)},/* low 5GHz active */
 	{IWL_PCI_DEVICE(0x0082, 0x1305, iwl6005_2agn_mow2_cfg)},/* high 5GHz active */
@@ -241,8 +248,11 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 
 /* 6x35 Series */
 	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x406A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x426A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x446A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x5260, iwl6035_2agn_cfg)},
 
-- 
1.8.3.2

