Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaDAMUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:20:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaDALQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Stepanov <Max.Stepanov@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 016/144] iwlwifi: mvm: change of listen interval from 70 to 10
Date: Tue,  1 Apr 2014 12:13:40 +0100
Message-Id: <1396350948-29910-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Stepanov <Max.Stepanov@intel.com>

commit e7eb65cac0720df8b3946af7f7a9dc363cf0a814 upstream.

Some APs reject STA association request if a listen interval value exceeds
a threshold of 10. Thus, for example, Cisco APs may deny STA associations
returning status code 12 (Association denied due to reason outside the scope
of 802.11 standard) in the association response frame.

Fixing the issue by setting the default IWL_CONN_MAX_LISTEN_INTERVAL value
from 70 to 10.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 420e82d..a5e34c0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -148,7 +148,7 @@ enum iwl_power_scheme {
 	IWL_POWER_SCHEME_LP
 };
 
-#define IWL_CONN_MAX_LISTEN_INTERVAL	70
+#define IWL_CONN_MAX_LISTEN_INTERVAL	10
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 enum iwl_dbgfs_pm_mask {
-- 
1.9.1

