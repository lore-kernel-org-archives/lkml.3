Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3FYTsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:48:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:44846 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3FYTsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:48:31 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] cfg80211/mac80211: fix doc compilation warnings
Date: Tue, 25 Jun 2013 21:48:20 +0200
Message-Id: <1372189700-6247-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes countless "No description found for parameter"
warnings generating documentation (running "make htmldocs"),
because the comments do not match the actual prototypes in the code.

This issue didn't exist in 3.9. It may we worth fixing in 3.10
(if it's not too late).

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 include/net/cfg80211.h | 1 +
 include/net/mac80211.h | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26b5b69..3949642 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4153,6 +4153,7 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
  * cfg80211_crit_proto_stopped() - indicate critical protocol stopped by driver.
  *
  * @wdev: the wireless device for which critical protocol is stopped.
+ * @gfp: the type of memory to allocate (see kmalloc).
  *
  * This function can be called by the driver to indicate it has reverted
  * operation back to normal. One reason could be that the duration given
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 885898a..79f5fa7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1235,7 +1235,7 @@ enum ieee80211_sta_rx_bandwidth {
  * struct ieee80211_sta_rates - station rate selection table
  *
  * @rcu_head: RCU head used for freeing the table on update
- * @rates: transmit rates/flags to be used by default.
+ * @rate: transmit rates/flags to be used by default.
  *	Overriding entries per-packet is possible by using cb tx control.
  */
 struct ieee80211_sta_rates {
@@ -1276,7 +1276,7 @@ struct ieee80211_sta_rates {
  *	notifications and capabilities. The value is only valid after
  *	the station moves to associated state.
  * @smps_mode: current SMPS mode (off, static or dynamic)
- * @tx_rates: rate control selection table
+ * @rates: station rate selection table
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
-- 
1.8.1.2

