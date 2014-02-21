Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaBUMuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46971 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaBUMuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 050/121] iwlwifi: mvm: print the version of the firmware when it asserts
Date: Fri, 21 Feb 2014 12:47:54 +0000
Message-Id: <1392986945-9693-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b900a87b2eb90c0b9586496c82a323a1b8832d73 upstream.

This can be useful to be able to spot the firmware version
from the error reports without needing to fetch it from
another place.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 1e13328..05812e4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -411,6 +411,8 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 			mvm->status, table.valid);
 	}
 
+	IWL_ERR(mvm, "Loaded firmware version: %s\n", mvm->fw->fw_version);
+
 	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
 				      table.data1, table.data2, table.data3,
 				      table.blink1, table.blink2, table.ilink1,
-- 
1.9.0

