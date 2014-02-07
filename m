Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaBGNNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:13:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaBGLsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 045/233] rtlwifi: rtl8192c: Prevent reconnect attempts if not connected
Date: Fri,  7 Feb 2014 11:44:24 +0000
Message-Id: <1391773652-25214-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 8fd77aec1a9d6f4328fc0244f21932114e066df3 upstream.

This driver has a watchdog timer that attempts to reconnect when beacon frames
are not seen for 6 seconds. This patch disables that reconnect whenever the
device has never been connected.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 3333b04..e83d671 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -1437,7 +1437,8 @@ void rtl_watchdog_wq_callback(void *data)
 			/* if we can't recv beacon for 6s, we should
 			 * reconnect this AP
 			 */
-			if (rtlpriv->link_info.roam_times >= 3) {
+			if ((rtlpriv->link_info.roam_times >= 3) &&
+			    !is_zero_ether_addr(rtlpriv->mac80211.bssid)) {
 				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 					 "AP off, try to reconnect now\n");
 				rtlpriv->link_info.roam_times = 0;
-- 
1.8.3.2

