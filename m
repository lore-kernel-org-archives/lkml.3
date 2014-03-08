Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaCHBMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:12:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaCHBH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 96/99] iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series
Date: Fri,  7 Mar 2014 17:08:32 -0800
Message-Id: <20140308010614.643041314@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 08a5dd3842f2ac61c6d69661d2d96022df8ae359 upstream.

Add some new PCI IDs to the table for 6000, 6005 and 6235 series.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.2:
 - Adjust filenames
 - Drop const from struct iwl_cfg]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wujg: Backported to 3.4:
 - Adjust context
 - Do not drop const from struct iwl_cfg]
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-pci.c  |   10 ++++++++++
 3 files changed, 17 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -459,6 +459,12 @@ const struct iwl_cfg iwl6035_2agn_cfg =
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
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -106,6 +106,7 @@ extern const struct iwl_cfg iwl2000_2bgn
 extern const struct iwl_cfg iwl2000_2bgn_d_cfg;
 extern const struct iwl_cfg iwl2030_2bgn_cfg;
 extern const struct iwl_cfg iwl6035_2agn_cfg;
+extern const struct iwl_cfg iwl6035_2agn_sff_cfg;
 extern const struct iwl_cfg iwl105_bgn_cfg;
 extern const struct iwl_cfg iwl105_bgn_d_cfg;
 extern const struct iwl_cfg iwl135_bgn_cfg;
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -138,13 +138,16 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 
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
 
@@ -152,12 +155,16 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
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
@@ -239,8 +246,11 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 
 /* 6x35 Series */
 	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x406A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x426A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x446A, iwl6035_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
 
 /* 105 Series */


