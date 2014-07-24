Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934624AbaGXKD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:03:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55014 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608AbaGXJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 085/128] mac80211: fix IBSS join by initializing last_scan_completed
Date: Thu, 24 Jul 2014 10:45:34 +0100
Message-Id: <1406195177-8656-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>

commit c7d37a66e345df2fdf1aa7b2c9a6d3d53846ca5b upstream.

Without this fix, freshly rebooted Linux creates a new IBSS
instead of joining an existing one. Only when jiffies counter
overflows after 5 minutes the IBSS can be successfully joined.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
[edit commit message slightly]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/ibss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 2d45643c964e..97a4b5b9d506 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1055,6 +1055,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.control_port = params->control_port;
 	sdata->u.ibss.basic_rates = params->basic_rates;
+	sdata->u.ibss.last_scan_completed = jiffies;
 	memcpy(sdata->vif.bss_conf.mcast_rate, params->mcast_rate,
 	       sizeof(params->mcast_rate));
 
-- 
1.9.1

