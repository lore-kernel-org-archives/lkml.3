Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaFCLkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaFCLkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/138] rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()
Date: Tue,  3 Jun 2014 12:37:36 +0100
Message-Id: <1401795584-22664-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 3234f5b06fc3094176a86772cc64baf3decc98fc upstream.

Fixes: a53268be0cb9 ('rtlwifi: rtl8192cu: Fix too long disable of IRQs')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

