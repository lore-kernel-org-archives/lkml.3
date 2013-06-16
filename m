Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3FPWbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:31:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46295 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755544Ab3FPWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        "Hinnerk van Bruinehsen" <h.v.bruinehsen@fu-berlin.de>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.96731477@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [07/83] iwlwifi: dvm: fix zero LQ CMD sending avoidance
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -604,7 +604,7 @@ void iwl_restore_stations(struct iwl_pri
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
 
-				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+				if (memcmp(&lq, &zero_lq, sizeof(lq)))
 					send_lq = true;
 			}
 			spin_unlock_irqrestore(&priv->shrd->sta_lock,

