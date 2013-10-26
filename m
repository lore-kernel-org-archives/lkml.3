Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3JZUnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:43:41 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39432 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3JZUke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:40:34 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, pali.rohar@gmail.com,
        David Gnedt <david.gnedt@davizone.at>
Subject: [PATCH 09/16] wl1251: disable power saving in monitor mode
Date: Sat, 26 Oct 2013 22:34:08 +0200
Message-Id: <1382819655-30430-10-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gnedt <david.gnedt@davizone.at>

Force power saving off while monitor interface is present.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 drivers/net/wireless/ti/wl1251/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 727f2ee..62cb374 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -617,7 +617,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out_sleep;
 	}
 
-	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
+	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested &&
+	    !wl->monitor_present) {
 		wl1251_debug(DEBUG_PSM, "psm enabled");
 
 		wl->psm_requested = true;
@@ -633,8 +634,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			goto out_sleep;
-	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-		   wl->psm_requested) {
+	} else if ((!(conf->flags & IEEE80211_CONF_PS) || wl->monitor_present)
+		   && wl->psm_requested) {
 		wl1251_debug(DEBUG_PSM, "psm disabled");
 
 		wl->psm_requested = false;
-- 
1.7.10.4

