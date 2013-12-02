Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab3LBTOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:14:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab3LBTOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 168/173] iwlwifi: dont WARN on host commands sent when firmware is dead
Date: Mon,  2 Dec 2013 11:12:31 -0800
Message-Id: <20131202191202.324559132@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 8ca95995e64f5d270889badb3e449dca91106a2b upstream.

This triggers automatic bug reports and add no valuable
information. Print a simple error instead and drop the
host command.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -605,8 +605,10 @@ static inline int iwl_trans_send_cmd(str
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


