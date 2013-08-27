Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3H0B0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:26:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3H0BG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 13/74] iwlwifi: mvm: take the seqno from packet if transmit failed
Date: Mon, 26 Aug 2013 18:08:11 -0700
Message-Id: <20130827010427.365794941@linuxfoundation.org>
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

commit ebea2f32e814445f94f9e087b646f1cf4d55fa5a upstream.

The fw is unreliable in all the cases in which the packet
wasn't sent.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -610,8 +610,8 @@ static void iwl_mvm_rx_tx_cmd_single(str
 		    !(info->flags & IEEE80211_TX_STAT_ACK))
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
-		/* W/A FW bug: seq_ctl is wrong when the queue is flushed */
-		if (status == TX_STATUS_FAIL_FIFO_FLUSHED) {
+		/* W/A FW bug: seq_ctl is wrong when the status isn't success */
+		if (status != TX_STATUS_SUCCESS) {
 			struct ieee80211_hdr *hdr = (void *)skb->data;
 			seq_ctl = le16_to_cpu(hdr->seq_ctrl);
 		}


