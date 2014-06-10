Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaFJTub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:50:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35156 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaFJTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Ian King <colin.king@canonical.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 127/160] rtlwifi: rtl8188ee: initialize packet_beacon
Date: Tue, 10 Jun 2014 12:46:07 -0700
Message-Id: <1402429600-20477-128-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 328e203fc35f0b4f6df1c4943f74cf553bcc04f8 upstream.

static code analysis from cppcheck reports:

[drivers/net/wireless/rtlwifi/rtl8188ee/trx.c:322]:
  (error) Uninitialized variable: packet_beacon

packet_beacon is not initialized and hence packet_beacon
contains garbage from the stack, so set it to false.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
index aece6c9..7622e44 100644
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

