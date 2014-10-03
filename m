Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbaJCXzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:55:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbaJCVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 241/357] iwlwifi: increase DEFAULT_MAX_TX_POWER
Date: Fri,  3 Oct 2014 14:30:27 -0700
Message-Id: <20141003212940.746153883@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 22d059a5c7c5de61e53c88e30b65e55fbfd91e91 upstream.

The chip is able to transmit up to 22dBm, so set
the constant appropriately.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-config.h    |    2 ++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -120,6 +120,8 @@ enum iwl_led_mode {
 #define IWL_LONG_WD_TIMEOUT	10000
 #define IWL_MAX_WD_TIMEOUT	120000
 
+#define IWL_DEFAULT_MAX_TX_POWER 22
+
 /* Antenna presence definitions */
 #define	ANT_NONE	0x0
 #define	ANT_A		BIT(0)
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -143,8 +143,6 @@ static const u8 iwl_nvm_channels_family_
 #define LAST_2GHZ_HT_PLUS		9
 #define LAST_5GHZ_HT			161
 
-#define DEFAULT_MAX_TX_POWER 16
-
 /* rate data (static) */
 static struct ieee80211_rate iwl_cfg80211_rates[] = {
 	{ .bitrate = 1 * 10, .hw_value = 0, .hw_value_short = 0, },
@@ -279,7 +277,7 @@ static int iwl_init_channel_map(struct d
 		 * Default value - highest tx power value.  max_power
 		 * is not used in mvm, and is used for backwards compatibility
 		 */
-		channel->max_power = DEFAULT_MAX_TX_POWER;
+		channel->max_power = IWL_DEFAULT_MAX_TX_POWER;
 		is_5ghz = channel->band == IEEE80211_BAND_5GHZ;
 		IWL_DEBUG_EEPROM(dev,
 				 "Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",


