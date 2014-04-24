Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaDXIxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:53:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbaDXIxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 080/182] mac80211: fix potential use-after-free
Date: Thu, 24 Apr 2014 09:50:05 +0100
Message-Id: <1398329507-5911-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d2722f8b87fb172ff2f31d3a2816b31d58678d40 upstream.

The bss struct might be freed in ieee80211_rx_bss_put(),
so we shouldn't use it afterwards.

Fixes: 817cee7675237 ("mac80211: track AP's beacon rate and give it to the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a83d76a..06f71fb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2871,8 +2871,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
 					channel);
 	if (bss) {
-		ieee80211_rx_bss_put(local, bss);
 		sdata->vif.bss_conf.beacon_rate = bss->beacon_rate;
+		ieee80211_rx_bss_put(local, bss);
 	}
 }
 
-- 
1.9.1

