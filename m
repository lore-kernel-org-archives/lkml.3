Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaGOVlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:41:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100AbaGOVjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/198] mac80211: fix IBSS join by initializing last_scan_completed
Date: Tue, 15 Jul 2014 14:28:43 -0700
Message-Id: <1405459868-15089-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>

commit c7d37a66e345df2fdf1aa7b2c9a6d3d53846ca5b upstream.

Without this fix, freshly rebooted Linux creates a new IBSS
instead of joining an existing one. Only when jiffies counter
overflows after 5 minutes the IBSS can be successfully joined.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
[edit commit message slightly]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/ibss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d40e0e1..3727941 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1676,6 +1676,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.control_port = params->control_port;
 	sdata->u.ibss.userspace_handles_dfs = params->userspace_handles_dfs;
 	sdata->u.ibss.basic_rates = params->basic_rates;
+	sdata->u.ibss.last_scan_completed = jiffies;
 
 	/* fix basic_rates if channel does not support these rates */
 	rate_flags = ieee80211_chandef_rate_flags(&params->chandef);
-- 
1.9.1

