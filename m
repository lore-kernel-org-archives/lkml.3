Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaHHJnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:43:55 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:37046 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaHHJny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:43:54 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: wsa@the-dreams.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <41d6acbdbf19d85bdbe780e6ee5c704b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH] i2c: rk3x: fix interrupt handling issue
Date: Fri,  8 Aug 2014 17:41:40 +0800
Message-Id: <1407490900-4718-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If slave holds scl, I2C_IPD[7] will be set 1 by controller
for debugging. Driver must ignore it.

[    5.752391] rk3x-i2c ff160000.i2c: unexpected irq in WRITE: 0x80
[    5.939027] rk3x-i2c ff160000.i2c: timeout, ipd: 0x80, state: 4

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/i2c/busses/i2c-rk3x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 9e3084c..eab49e6 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -399,7 +399,7 @@ static irqreturn_t rk3x_i2c_irq(int irqno, void *dev_id)
 	}
 
 	/* is there anything left to handle? */
-	if (unlikely(ipd == 0))
+	if (unlikely((ipd & REG_INT_ALL) == 0))
 		goto out;
 
 	switch (i2c->state) {
-- 
1.8.3.2


