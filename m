Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaFIJFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:07 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58513 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 077/146] rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()
Date: Mon,  9 Jun 2014 10:50:12 +0200
Message-Id: <99e9ba35f546e51f43f9435de7cb37ce0ab0c762.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3234f5b06fc3094176a86772cc64baf3decc98fc upstream.

Fixes: a53268be0cb9 ('rtlwifi: rtl8192cu: Fix too long disable of IRQs')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 324aa581938e..c3f2b55501ae 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1001,7 +1001,7 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	err = _rtl92cu_init_mac(hw);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "init mac failed!\n");
-		return err;
+		goto exit;
 	}
 	err = rtl92c_download_fw(hw);
 	if (err) {
-- 
1.9.3

