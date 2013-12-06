Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162789Ab3LFNut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:50:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab3LFNCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 115/272] rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP
Date: Fri,  6 Dec 2013 12:56:44 +0000
Message-Id: <1386334761-25517-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit b4ade797668e33b4e8353c2701ce01d7084dfafa upstream.

The routine that processes received frames was returning the RSSI value for the
signal strength; however, that value is available only for associated APs. As
a result, the strength was the absurd value of 10 dBm. As a result, scans
return incorrect values for the strength, which causes unwanted attempts to roam.

This patch fixes https://bugzilla.kernel.org/show_bug.cgi?id=63881.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Matthieu Baerts <matttbe@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index c709511..7d0f2e2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -329,7 +329,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	}
 
 	/*rx_status->qual = stats->signal; */
-	rx_status->signal = stats->rssi + 10;
+	rx_status->signal = stats->recvsignalpower + 10;
 	/*rx_status->noise = -stats->noise; */
 
 	return true;
-- 
1.8.3.2

