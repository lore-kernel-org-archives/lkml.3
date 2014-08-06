Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaHFEnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:43:46 -0400
Received: from s87.loopia.se ([194.9.94.112]:34041 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbaHFEnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:43:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 04/15] [media] dvb: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:42:17 -0700
Message-Id: <1407300137-32480-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/media/dvb-frontends/mb86a16.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 9ae40ab..5939133 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -115,7 +115,7 @@ static int mb86a16_read(struct mb86a16_state *state, u8 reg, u8 *val)
 	};
 	ret = i2c_transfer(state->i2c_adap, msg, 2);
 	if (ret != 2) {
-		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=0x%i)",
+		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=0x%x)",
 			reg, ret);
 
 		return -EREMOTEIO;
-- 
2.0.0.526.g5318336

