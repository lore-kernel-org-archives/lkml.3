Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaHLTji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:39:38 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41767 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaHLTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:39:35 -0400
Date: Wed, 13 Aug 2014 01:09:29 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] rtlwifi: btcoexist: adjust double test
Message-ID: <20140812193929.GA4233@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite a duplicated test to test the correct value

The Coccinelle semantic patch that finds this problem is:

// <smpl>
@@
expression E;
@@

(
* E
  || ... || E
|
* E
  && ... && E
)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
In file drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c, there is a
similar function that tests for WIRELESS_MODE_G and WIRELESS_MODE_B.
I have not tested the code, so you am not sure whether it is the
correct solution.

 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
index 33da3df..d4bd550 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -101,7 +101,7 @@ static bool halbtc_legacy(struct rtl_priv *adapter)
 
 	bool is_legacy = false;
 
-	if ((mac->mode == WIRELESS_MODE_B) || (mac->mode == WIRELESS_MODE_B))
+	if ((mac->mode == WIRELESS_MODE_B) || (mac->mode == WIRELESS_MODE_G))
 		is_legacy = true;
 
 	return is_legacy;
-- 
1.9.1

