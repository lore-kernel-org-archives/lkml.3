Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162777Ab3LFNuC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:50:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab3LFNCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 116/272] rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP
Date: Fri,  6 Dec 2013 12:56:45 +0000
Message-Id: <1386334761-25517-117-git-send-email-luis.henriques@canonical.com>
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

commit 78dbfecb95be4635b995af3bd29fa10013409fcd upstream.

The routine that processes received frames was returning the RSSI value for the
signal strength; however, that value is available only for associated APs. As
a result, the strength was the absurd value of 10 dBm. As a result, scans
return incorrect values for the strength, which causes unwanted attempts to roam.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 5dfe7e2..5c52a8a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -349,7 +349,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 						 p_drvinfo);
 	}
 	/*rx_status->qual = stats->signal; */
-	rx_status->signal = stats->rssi + 10;
+	rx_status->signal = stats->recvsignalpower + 10;
 	/*rx_status->noise = -stats->noise; */
 	return true;
 }
-- 
1.8.3.2

