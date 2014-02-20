Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaBUAQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:16:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaBTXxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:53:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.13 23/99] iwlwifi: mvm: disable scheduled scan
Date: Thu, 20 Feb 2014 15:52:18 -0800
Message-Id: <20140220235118.889367463@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 0822afe8ebb9389997ef677447c7b08e08797de9 upstream.

The iwlwifi scheduled scan implementation doesn't adhere to the
userspace API correctly - the API assumes that any new incoming
'incompatible' request (like scan or remain-on-channel for this
driver) will just cancel the scheduled scan. Instead our driver
relies on userspace cancelling it, thus breaking existing wpa_s
versions.

Fixes: 35a000b7c1bb ("iwlwifi: mvm: support sched scan if supported by the fw")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -246,7 +246,7 @@ int iwl_mvm_mac_setup_register(struct iw
 	else
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_SCHED_SCAN) {
+	if (0 && mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_SCHED_SCAN) {
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 		hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
 		hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;


