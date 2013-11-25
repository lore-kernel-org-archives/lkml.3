Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3KYN72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:59:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58955 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383Ab3KYNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:52 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.968550357@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 43/87] iwlwifi: update pci subsystem id
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

commit 378911233f424d7a1bf4a579587ae71c7d887166 upstream.

Update the pci subsystem id and product name for 6005 series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c | 11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |  2 ++
 drivers/net/wireless/iwlwifi/iwl-pci.c  |  6 +++---
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -411,6 +411,17 @@ struct iwl_cfg iwl6005_2agn_d_cfg = {
 	.ht_params = &iwl6000_ht_params,
 };
 
+struct iwl_cfg iwl6005_2agn_mow1_cfg = {
+	.name = "Intel(R) Centrino(R) Advanced-N 6206 AGN",
+	IWL_DEVICE_6005,
+	.ht_params = &iwl6000_ht_params,
+};
+struct iwl_cfg iwl6005_2agn_mow2_cfg = {
+	.name = "Intel(R) Centrino(R) Advanced-N 6207 AGN",
+	IWL_DEVICE_6005,
+	.ht_params = &iwl6000_ht_params,
+};
+
 #define IWL_DEVICE_6030						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -80,6 +80,8 @@ extern struct iwl_cfg iwl6005_2abg_cfg;
 extern struct iwl_cfg iwl6005_2bg_cfg;
 extern struct iwl_cfg iwl6005_2agn_sff_cfg;
 extern struct iwl_cfg iwl6005_2agn_d_cfg;
+extern struct iwl_cfg iwl6005_2agn_mow1_cfg;
+extern struct iwl_cfg iwl6005_2agn_mow2_cfg;
 extern struct iwl_cfg iwl1030_bgn_cfg;
 extern struct iwl_cfg iwl1030_bg_cfg;
 extern struct iwl_cfg iwl6030_2agn_cfg;
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -256,9 +256,9 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0xC020, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0xC220, iwl6005_2agn_sff_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1341, iwl6005_2agn_d_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1304, iwl6005_2agn_cfg)},/* low 5GHz active */
-	{IWL_PCI_DEVICE(0x0082, 0x1305, iwl6005_2agn_cfg)},/* high 5GHz active */
+	{IWL_PCI_DEVICE(0x0082, 0x4820, iwl6005_2agn_d_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1304, iwl6005_2agn_mow1_cfg)},/* low 5GHz active */
+	{IWL_PCI_DEVICE(0x0082, 0x1305, iwl6005_2agn_mow2_cfg)},/* high 5GHz active */
 
 /* 6x30 Series */
 	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},

