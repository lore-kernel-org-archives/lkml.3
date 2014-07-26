Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaGZT10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:27:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaGZTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.15 107/109] iwlwifi: mvm: disable CTS to Self
Date: Sat, 26 Jul 2014 12:03:09 -0700
Message-Id: <20140726190227.071086142@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit dc271ee0d04d12d6bfabacbec803289a7072fbd9 upstream.

Firmware folks seem say that this flag can make trouble.
Drop it. The advantage of CTS to self is that it slightly
reduces the cost of the protection, but make the protection
less reliable.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -667,13 +667,9 @@ static void iwl_mvm_mac_ctxt_cmd_common(
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
+
 	IWL_DEBUG_RATE(mvm, "use_cts_prot %d, ht_operation_mode %d\n",
 		       vif->bss_conf.use_cts_prot,
 		       vif->bss_conf.ht_operation_mode);


