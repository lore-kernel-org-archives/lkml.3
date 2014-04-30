Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbaD3MPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:15:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486AbaD3MPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:15:53 -0400
From: Jan Moskyto Matejka <mq@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark@einon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH] [linux-next] [staging] rtl8821ae: fixed defined-not-used warning
Date: Wed, 30 Apr 2014 14:15:43 +0200
Message-Id: <1398860143-2676-1-git-send-email-mq@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function  halbtc8192e2ant_iswifi_status_changed  is called only
at line 4158 which is #if'd in the same way as I'm now #if-ing the function.

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
---
 drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
index 81706f4..7af412d 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
@@ -503,6 +503,7 @@ static void halbtc8192e2ant_querybt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
+#if (BT_AUTO_REPORT_ONLY_8192E_2ANT != 0)
 static bool halbtc8192e2ant_iswifi_status_changed(struct btc_coexist *btcoexist)
 {
 	static bool pre_wifi_busy;
@@ -534,6 +535,7 @@ static bool halbtc8192e2ant_iswifi_status_changed(struct btc_coexist *btcoexist)
 
 	return false;
 }
+#endif
 
 static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
 {
-- 
1.8.4.5

