Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaGHToa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:44:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54074 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes.berg@intel.com>,
        "=?UTF-8?q?Krzysztof=20Ha=C5=82asa?=" <khalasa@piap.pl>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.26812079@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 016/125] mac80211: fix IBSS join by initializing
 last_scan_completed
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Hałasa <khalasa@piap.pl>

commit c7d37a66e345df2fdf1aa7b2c9a6d3d53846ca5b upstream.

Without this fix, freshly rebooted Linux creates a new IBSS
instead of joining an existing one. Only when jiffies counter
overflows after 5 minutes the IBSS can be successfully joined.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
[edit commit message slightly]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/ibss.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -914,6 +914,7 @@ int ieee80211_ibss_join(struct ieee80211
 
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.basic_rates = params->basic_rates;
+	sdata->u.ibss.last_scan_completed = jiffies;
 	memcpy(sdata->vif.bss_conf.mcast_rate, params->mcast_rate,
 	       sizeof(params->mcast_rate));
 

