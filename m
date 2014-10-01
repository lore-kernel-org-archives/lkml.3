Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaJARlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:41:13 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60451 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaJARlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:41:09 -0400
From: Alexandru M Stan <amstan@chromium.org>
To: Max Schwarz <max.schwarz@online.de>, Wolfram Sang <wsa@the-dreams.de>
Cc: Doug Anderson <dianders@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        addy ke <addy.ke@rock-chips.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        ZhengShunQian <zhengsq@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Alexandru M Stan <amstan@chromium.org>, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: rk3x: fix 0 length write transfers
Date: Wed,  1 Oct 2014 10:40:41 -0700
Message-Id: <1412185241-24950-1-git-send-email-amstan@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2cdetect -q was broken (everything was a false positive, and no transfers were
actually being sent over i2c). The way it works is by sending a 0 length write
request and checking for NACK. This patch fixes the 0 length writes and actually
sends them.

Reported-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Alexandru M Stan <amstan@chromium.org>
---
 drivers/i2c/busses/i2c-rk3x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index b41d979..f486d0e 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -238,7 +238,7 @@ static void rk3x_i2c_fill_transmit_buf(struct rk3x_i2c *i2c)
 	for (i = 0; i < 8; ++i) {
 		val = 0;
 		for (j = 0; j < 4; ++j) {
-			if (i2c->processed == i2c->msg->len)
+			if ((i2c->processed == i2c->msg->len) && (cnt != 0))
 				break;
 
 			if (i2c->processed == 0 && cnt == 0)
-- 
2.1.0.rc2.206.gedb03e5

