Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaJQBoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 21:44:38 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:42479 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaJQBog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 21:44:36 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <33610cf56be98550291e3b5d532f3aa7>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Addy Ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, dianders@chromium.org,
        grant.likely@linaro.org, robh+dt@kernel.org, amstan@google.com,
        sonnyrao@google.com
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH] spi/rockchip: spi controller must be disabled in tx callback too
Date: Fri, 17 Oct 2014 09:44:13 +0800
Message-Id: <1413510253-3519-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/spi/spi-rockchip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 153269b..87bc16f 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -418,8 +418,10 @@ static void rockchip_spi_dma_txcb(void *data)
 	spin_lock_irqsave(&rs->lock, flags);
 
 	rs->state &= ~TXBUSY;
-	if (!(rs->state & RXBUSY))
+	if (!(rs->state & RXBUSY)) {
+		spi_enable_chip(rs, 0);
 		spi_finalize_current_transfer(rs->master);
+	}
 
 	spin_unlock_irqrestore(&rs->lock, flags);
 }
-- 
1.8.3.2


