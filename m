Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbaEKTXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:23:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237AbaEKTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 40/83] iwlwifi: mvm: disable uAPSD due to bugs in the firmware
Date: Sun, 11 May 2014 21:19:41 +0200
Message-Id: <20140511191912.458734117@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit a82dda6cd492b8c88952be6f6527f3656f7ac585 upstream.

The current firmware advertises support for uAPSD, but
critical bugs force us to disable the feature.
When a fixed firmware will be available, we will be able to
re-enable uAPSD.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -179,7 +179,7 @@ int iwl_mvm_mac_setup_register(struct iw
 	    !iwlwifi_mod_params.sw_crypto)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT) {
+	if (0 && mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT) {
 		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
 		hw->uapsd_queues = IWL_UAPSD_AC_INFO;
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;


