Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3KRSr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:47:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3KRSmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:42:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oren Givon <oren.givon@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 17/24] iwlwifi: add new 7260 and 3160 series device IDs
Date: Mon, 18 Nov 2013 10:42:27 -0800
Message-Id: <20131118184223.277352559@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184222.017393843@linuxfoundation.org>
References: <20131118184222.017393843@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oren Givon <oren.givon@intel.com>

commit 93fc64114b994f9ef6901697f9b0de00762680e9 upstream.

Add new device IDs and configurations to support
all the devices.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-7000.c   |   42 +++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-config.h |    6 +++
 drivers/net/wireless/iwlwifi/pcie/drv.c   |   50 ++++++++++++++++++++++++++++--
 3 files changed, 91 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -125,7 +125,7 @@ static const struct iwl_ht_params iwl700
 
 
 const struct iwl_cfg iwl7260_2ac_cfg = {
-	.name = "Intel(R) Dual Band Wireless AC7260",
+	.name = "Intel(R) Dual Band Wireless AC 7260",
 	.fw_name_pre = IWL7260_FW_PRE,
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
@@ -133,8 +133,44 @@ const struct iwl_cfg iwl7260_2ac_cfg = {
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 };
 
-const struct iwl_cfg iwl3160_ac_cfg = {
-	.name = "Intel(R) Dual Band Wireless AC3160",
+const struct iwl_cfg iwl7260_2n_cfg = {
+	.name = "Intel(R) Dual Band Wireless N 7260",
+	.fw_name_pre = IWL7260_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL7260_NVM_VERSION,
+	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+};
+
+const struct iwl_cfg iwl7260_n_cfg = {
+	.name = "Intel(R) Wireless N 7260",
+	.fw_name_pre = IWL7260_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL7260_NVM_VERSION,
+	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+};
+
+const struct iwl_cfg iwl3160_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 3160",
+	.fw_name_pre = IWL3160_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL3160_NVM_VERSION,
+	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+};
+
+const struct iwl_cfg iwl3160_2n_cfg = {
+	.name = "Intel(R) Dual Band Wireless N 3160",
+	.fw_name_pre = IWL3160_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL3160_NVM_VERSION,
+	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+};
+
+const struct iwl_cfg iwl3160_n_cfg = {
+	.name = "Intel(R) Wireless N 3160",
 	.fw_name_pre = IWL3160_FW_PRE,
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -321,6 +321,10 @@ extern const struct iwl_cfg iwl105_bgn_c
 extern const struct iwl_cfg iwl105_bgn_d_cfg;
 extern const struct iwl_cfg iwl135_bgn_cfg;
 extern const struct iwl_cfg iwl7260_2ac_cfg;
-extern const struct iwl_cfg iwl3160_ac_cfg;
+extern const struct iwl_cfg iwl7260_2n_cfg;
+extern const struct iwl_cfg iwl7260_n_cfg;
+extern const struct iwl_cfg iwl3160_2ac_cfg;
+extern const struct iwl_cfg iwl3160_2n_cfg;
+extern const struct iwl_cfg iwl3160_n_cfg;
 
 #endif /* __IWL_CONFIG_H__ */
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -267,10 +267,54 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_ca
 
 /* 7000 Series */
 	{IWL_PCI_DEVICE(0x08B1, 0x4070, iwl7260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B1, 0x4062, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4170, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4060, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4160, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4062, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4162, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0x4270, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0x4260, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0x4262, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4470, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4460, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4462, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4870, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x486E, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4A70, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4A6E, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4A6C, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4020, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0x4220, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4420, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC070, iwl7260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B3, 0x0070, iwl3160_ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B3, 0x8070, iwl3160_ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC170, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC060, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC160, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC062, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC162, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0xC270, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0xC260, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0xC262, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC470, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC460, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC462, iwl7260_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC020, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B2, 0xC220, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC420, iwl7260_2n_cfg)},
+
+/* 3160 Series */
+	{IWL_PCI_DEVICE(0x08B3, 0x0070, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x0170, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x0060, iwl3160_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x0062, iwl3160_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B4, 0x0270, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x0470, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8070, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8170, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8060, iwl3160_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8062, iwl3160_n_cfg)},
+	{IWL_PCI_DEVICE(0x08B4, 0x8270, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8470, iwl3160_2ac_cfg)},
 
 	{0}
 };


