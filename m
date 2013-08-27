Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3H0B0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:26:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3H0BG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [ 14/74] iwlwifi: mvm: unregister leds when registration failed
Date: Mon, 26 Aug 2013 18:08:12 -0700
Message-Id: <20130827010427.554156414@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b7327d89ae694a89f9934d428bde520b77b3131c upstream.

This was missing and prevented any further attempts
to load the module.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -243,7 +243,11 @@ int iwl_mvm_mac_setup_register(struct iw
 	if (ret)
 		return ret;
 
-	return ieee80211_register_hw(mvm->hw);
+	ret = ieee80211_register_hw(mvm->hw);
+	if (ret)
+		iwl_mvm_leds_exit(mvm);
+
+	return ret;
 }
 
 static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,


