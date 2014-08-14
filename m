Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaHNAxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:53:06 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:59218 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaHNAxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:53:04 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <f69142f1fe8a611e666cb56ef3b613e4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, dianders@chromium.org,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH] spi: rockchip: return 0 if tx_buf and rx_buf are NULL
Date: Thu, 14 Aug 2014 08:52:24 +0800
Message-Id: <1407977544-2989-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To do so, spi communication can use an empty buf to pull up CS.

This patch merged from ChromiumOS tree.
Cros_ec use this function to turn off CS and add a delay to ensure
the rising edge doesn't come too soon after the end of the data.

Tested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/spi/spi-rockchip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 72fb287..1e3bcfa 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -511,8 +511,8 @@ static int rockchip_spi_transfer_one(struct spi_master *master,
 	WARN_ON((readl_relaxed(rs->regs + ROCKCHIP_SPI_SR) & SR_BUSY));
 
 	if (!xfer->tx_buf && !xfer->rx_buf) {
-		dev_err(rs->dev, "No buffer for transfer\n");
-		return -EINVAL;
+		dev_dbg(rs->dev, "No buffer for transfer\n");
+		return 0;
 	}
 
 	rs->speed = xfer->speed_hz;
-- 
1.8.3.2


