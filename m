Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaFKX7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:59:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:36076 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbaFKX7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:59:41 -0400
Message-Id: <20140611234607.020125642@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 23:59:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: [patch 04/13] net: mac80211: Use ktime_get_ts()
References: <20140611234024.103571777@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=net-mac80211-use-ktime-get.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/debugfs_sta.c |    2 +-
 net/mac80211/sta_info.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/net/mac80211/cfg.c
===================================================================
--- linux.orig/net/mac80211/cfg.c
+++ linux/net/mac80211/cfg.c
@@ -484,7 +484,7 @@ static void sta_set_sinfo(struct sta_inf
 			STATION_INFO_STA_FLAGS |
 			STATION_INFO_BEACON_LOSS_COUNT;
 
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
 
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
Index: linux/net/mac80211/debugfs_sta.c
===================================================================
--- linux.orig/net/mac80211/debugfs_sta.c
+++ linux/net/mac80211/debugfs_sta.c
@@ -124,7 +124,7 @@ static ssize_t sta_connected_time_read(s
 	long connected_time_secs;
 	char buf[100];
 	int res;
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	connected_time_secs = uptime.tv_sec - sta->last_connected;
 	time_to_tm(connected_time_secs, 0, &result);
 	result.tm_year -= 70;
Index: linux/net/mac80211/sta_info.c
===================================================================
--- linux.orig/net/mac80211/sta_info.c
+++ linux/net/mac80211/sta_info.c
@@ -357,7 +357,7 @@ struct sta_info *sta_info_alloc(struct i
 
 	sta->sta_state = IEEE80211_STA_NONE;
 
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	sta->last_connected = uptime.tv_sec;
 	ewma_init(&sta->avg_signal, 1024, 8);
 	for (i = 0; i < ARRAY_SIZE(sta->chain_signal_avg); i++)


