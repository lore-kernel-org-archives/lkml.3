Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3IUWcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:32:00 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:51434 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3IUW3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:29:02 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 12/19] wireless: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:44 +0200
Message-Id: <1379802471-30252-12-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable continual is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/net/wireless/rtlwifi/efuse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 838a1ed..63d370d 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -1203,7 +1203,7 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 
 static u16 efuse_get_current_size(struct ieee80211_hw *hw)
 {
-	int continual = true;
+	bool continual = true;
 	u16 efuse_addr = 0;
 	u8 hworden;
 	u8 efuse_data, word_cnts;
-- 
1.8.3.1

