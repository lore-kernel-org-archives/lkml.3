Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab3GQXVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:21:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934285Ab3GQWy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 066/145] drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq
Date: Wed, 17 Jul 2013 15:46:38 -0700
Message-Id: <1374101277-7915-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 29ecd78c0fd6ee05f2c6b07b23823a6ae43c13ff upstream.

In the disable AIE irq code path, current code passes "1" to enable
parameter of rv3029c2_rtc_i2c_alarm_set_irq().  Thus it does not disable
AIE irq.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Heiko Schocher <hs@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/rtc/rtc-rv3029c2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv3029c2.c b/drivers/rtc/rtc-rv3029c2.c
index f8ee8ad..a7869c8 100644
--- a/drivers/rtc/rtc-rv3029c2.c
+++ b/drivers/rtc/rtc-rv3029c2.c
@@ -310,7 +310,7 @@ static int rv3029c2_rtc_i2c_set_alarm(struct i2c_client *client,
 		dev_dbg(&client->dev, "alarm IRQ armed\n");
 	} else {
 		/* disable AIE irq */
-		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 1);
+		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 0);
 		if (ret)
 			return ret;
 
-- 
1.8.1.2

