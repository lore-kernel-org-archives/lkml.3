Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbaJIV3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:29:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59360 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaJIVJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eliad Peller <eliadx.peller@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 117/163] iwlwifi: increase DEFAULT_MAX_TX_POWER
Date: Thu,  9 Oct 2014 14:02:22 -0700
Message-Id: <1412888588-26755-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 22d059a5c7c5de61e53c88e30b65e55fbfd91e91 upstream.

The chip is able to transmit up to 22dBm, so set
the constant appropriately.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h    | 2 ++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 03fd9aa..5e2d76f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -119,6 +119,8 @@ enum iwl_led_mode {
 #define IWL_LONG_WD_TIMEOUT	10000
 #define IWL_MAX_WD_TIMEOUT	120000
 
+#define IWL_DEFAULT_MAX_TX_POWER 22
+
 /* Antenna presence definitions */
 #define	ANT_NONE	0x0
 #define	ANT_A		BIT(0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 4a1cf13..6dac0f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -118,8 +118,6 @@ static const u8 iwl_nvm_channels[] = {
 #define LAST_2GHZ_HT_PLUS	9
 #define LAST_5GHZ_HT		161
 
-#define DEFAULT_MAX_TX_POWER 16
-
 /* rate data (static) */
 static struct ieee80211_rate iwl_cfg80211_rates[] = {
 	{ .bitrate = 1 * 10, .hw_value = 0, .hw_value_short = 0, },
@@ -242,7 +240,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		 * Default value - highest tx power value.  max_power
 		 * is not used in mvm, and is used for backwards compatibility
 		 */
-		channel->max_power = DEFAULT_MAX_TX_POWER;
+		channel->max_power = IWL_DEFAULT_MAX_TX_POWER;
 		is_5ghz = channel->band == IEEE80211_BAND_5GHZ;
 		IWL_DEBUG_EEPROM(dev,
 				 "Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
-- 
1.9.1

