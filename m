Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbaBGMst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:48:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaBGLuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eliad Peller <eliadx.peller@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 110/233] iwlwifi: mvm: fix missing cleanup in .start() error path
Date: Fri,  7 Feb 2014 11:45:29 +0000
Message-Id: <1391773652-25214-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliadx.peller@intel.com>

commit 91b0d1198417cf4fd9a7bd4138b6909f0b359099 upstream.

Cleanup of iwl_mvm_leds was missing in case of error,
resulting in the following warning:

WARNING: at lib/kobject.c:196 kobject_add_internal+0x1f4/0x210()
kobject_add_internal failed for phy0-led with -EEXIST, don't try to register things with the same name in the same directory.

which prevents further reloads of the driver.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index af79a14..0a677b5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -435,6 +435,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
  out_unregister:
 	ieee80211_unregister_hw(mvm->hw);
+	iwl_mvm_leds_exit(mvm);
  out_free:
 	iwl_phy_db_free(mvm->phy_db);
 	kfree(mvm->scan_cmd);
-- 
1.8.3.2

