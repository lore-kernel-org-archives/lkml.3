Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162594Ab3LFN14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:27:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161821Ab3LFNDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 190/272] iwlwifi: don't WARN on host commands sent when firmware is dead
Date: Fri,  6 Dec 2013 12:57:59 +0000
Message-Id: <1386334761-25517-191-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 8ca95995e64f5d270889badb3e449dca91106a2b upstream.

This triggers automatic bug reports and add no valuable
information. Print a simple error instead and drop the
host command.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8d91422c..3dde033 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -606,8 +606,10 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 {
 	int ret;
 
-	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
-		  "%s bad state = %d", __func__, trans->state);
+	if (trans->state != IWL_TRANS_FW_ALIVE) {
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+		return -EIO;
+	}
 
 	if (!(cmd->flags & CMD_ASYNC))
 		lock_map_acquire_read(&trans->sync_cmd_lockdep_map);
-- 
1.8.3.2

