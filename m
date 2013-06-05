Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab3FEVk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:40:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab3FEVgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hinnerk van Bruinehsen <h.v.bruinehsen@fu-berlin.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 108/127] iwlwifi: dvm: fix zero LQ CMD sending avoidance
Date: Wed,  5 Jun 2013 14:34:35 -0700
Message-Id: <20130605213230.296426192@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit a87783699b23395c46bbeeb5d28f6db24897bf26 upstream.

In 63b77bf489881747c5118476918cc8c29378ee63

	iwlwifi: dvm: don't send zeroed LQ cmd

I tried to avoid to send zeroed LQ cmd, but I made a (very)
stupid mistake in the memcmp.
Since this patch has been ported to stable, the fix should
go to stable too.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=58341

Reported-by: Hinnerk van Bruinehsen <h.v.bruinehsen@fu-berlin.de>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -735,7 +735,7 @@ void iwl_restore_stations(struct iwl_pri
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
 
-				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+				if (memcmp(&lq, &zero_lq, sizeof(lq)))
 					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);


