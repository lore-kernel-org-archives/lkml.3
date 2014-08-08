Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbaHHUyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:54:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132AbaHHUyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 115/259] iwlwifi: mvm: disable CTS to Self
Date: Fri,  8 Aug 2014 13:38:58 -0700
Message-Id: <1407530482-4483-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit dc271ee0d04d12d6bfabacbec803289a7072fbd9 upstream.

Firmware folks seem say that this flag can make trouble.
Drop it. The advantage of CTS to self is that it slightly
reduces the cost of the protection, but make the protection
less reliable.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[ kamal: backport to 3.13-stable (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index f41f9b0..1fc0332 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -566,13 +566,8 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
 
-	/* Don't use cts to self as the fw doesn't support it currently. */
-	if (vif->bss_conf.use_cts_prot) {
+	if (vif->bss_conf.use_cts_prot)
 		cmd->protection_flags |= cpu_to_le32(MAC_PROT_FLG_TGG_PROTECT);
-		if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 8)
-			cmd->protection_flags |=
-				cpu_to_le32(MAC_PROT_FLG_SELF_CTS_EN);
-	}
 
 	/*
 	 * I think that we should enable these 2 flags regardless the HT PROT
-- 
1.9.1

