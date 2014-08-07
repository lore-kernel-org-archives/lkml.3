Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbaHGFmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:42:20 -0400
Received: from s87.loopia.se ([194.9.94.112]:60357 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756937AbaHGFmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:42:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 2/2] [media] dvb: return the error from i2c_transfer if negative
Date: Wed,  6 Aug 2014 22:42:04 -0700
Message-Id: <1407390124-29346-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <20140806115607.1946e967.m.chehab@samsung.com>
References: <20140806115607.1946e967.m.chehab@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/media/dvb-frontends/mb86a16.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 1f7fce7..0e65d35 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -118,6 +118,8 @@ static int mb86a16_read(struct mb86a16_state *state, u8 reg, u8 *val)
 		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=%i)",
 			reg, ret);
 
+		if (ret < 0)
+			return ret;
 		return -EREMOTEIO;
 	}
 	*val = b1[0];
-- 
2.0.0.526.g5318336

