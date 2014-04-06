Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaDFNap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:30:45 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:39037 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaDFNam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:30:42 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "John W. Linville" <linville@tuxdriver.com>,
        Fariya Fatima <fariyaf@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] rsi: Add missing initialization of ii
Date: Sun,  6 Apr 2014 15:30:39 +0200
Message-Id: <1396791040-26816-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/wireless/rsi/rsi_91x_core.c: In function ‘rsi_core_determine_hal_queue’:
drivers/net/wireless/rsi/rsi_91x_core.c:91: warning: ‘ii’ may be used uninitialized in this function

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Is zero the correct initialization value?

 drivers/net/wireless/rsi/rsi_91x_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index e89535e86caf..20a62f36e89b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -88,7 +88,7 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 	bool recontend_queue = false;
 	u32 q_len = 0;
 	u8 q_num = INVALID_QUEUE;
-	u8 ii, min = 0;
+	u8 ii = 0, min = 0;
 
 	if (skb_queue_len(&common->tx_queue[MGMT_SOFT_Q])) {
 		if (!common->mgmt_q_block)
-- 
1.7.9.5

