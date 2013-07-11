Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab3GKOpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:45:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3GKO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 38/98] drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq
Date: Thu, 11 Jul 2013 15:24:08 +0100
Message-Id: <1373552708-15235-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
index 0fbe57b..21d63d1 100644
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

