Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaDUQiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:38:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaDUQiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:38:52 -0400
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8188ee: initialize packet_beacon
Date: Mon, 21 Apr 2014 17:38:44 +0100
Message-Id: <1398098324-5193-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

static code analysis from cppcheck reports:

[drivers/net/wireless/rtlwifi/rtl8188ee/trx.c:322]:
  (error) Uninitialized variable: packet_beacon

packet_beacon is not initialized and hence packet_beacon
contains garbage from the stack, so set it to false.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
index 06ef47c..5b4c225 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
@@ -293,7 +293,7 @@ static void _rtl88ee_translate_rx_signal_stuff(struct ieee80211_hw *hw,
 	u8 *psaddr;
 	__le16 fc;
 	u16 type, ufc;
-	bool match_bssid, packet_toself, packet_beacon, addr;
+	bool match_bssid, packet_toself, packet_beacon = false, addr;
 
 	tmp_buf = skb->data + pstatus->rx_drvinfo_size + pstatus->rx_bufshift;
 
-- 
1.9.1

