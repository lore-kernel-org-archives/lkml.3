Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3H0BHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3H0BG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 10/74] iwlwifi: mvm: fix MCAST in AP mode
Date: Mon, 26 Aug 2013 18:08:08 -0700
Message-Id: <20130827010426.789508494@linuxfoundation.org>
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

commit 9116a3683902583a302ac5dcb283416d504d9bb4 upstream.

In multicast, there is no retries nor RTS since there is no
specific recipient that can ACK or send CTS. This means
that we must not use the rate scale table for multicast
frames.
This true for any frame that doesn't have a valid
ieee80211_sta pointer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -175,7 +175,7 @@ static void iwl_mvm_set_tx_cmd_rate(stru
 	 * table is controlled by LINK_QUALITY commands
 	 */
 
-	if (ieee80211_is_data(fc)) {
+	if (ieee80211_is_data(fc) && sta) {
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_STA_RATE);
 		return;


