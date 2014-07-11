Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaGKCJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:09:12 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:57507 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaGKCJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:09:10 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <1166cc1085152717da89e5872e482f38>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        jogo@openwrt.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        wei.luo@rock-chips.com, Addy Ke <addy.ke@rockchip.com>
Subject: [PATCH 3/4] spi/rockchip: master->mode_bits: remove SPI_CS_HIGH bit
Date: Fri, 11 Jul 2014 10:08:51 +0800
Message-Id: <1405044531-6963-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405044389-6800-1-git-send-email-addy.ke@rock-chips.com>
References: <1405044389-6800-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Addy Ke <addy.ke@rockchip.com>

Suggested-by: Jonas Gorski <jogo@openwrt.org>
Signed-off-by: Addy Ke <addy.ke@rockchip.com>
---
 drivers/spi/spi-rockchip.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 09c690c..a8866c9 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -295,11 +295,6 @@ static int rockchip_spi_prepare_message(struct spi_master *master,
 	struct rockchip_spi *rs = spi_master_get_devdata(master);
 	struct spi_device *spi = msg->spi;
 
-	if (spi->mode & SPI_CS_HIGH) {
-		dev_err(rs->dev, "spi_cs_hign: not support\n");
-		return -EINVAL;
-	}
-
 	rs->mode = spi->mode;
 
 	return 0;
@@ -657,7 +652,7 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 
 	master->auto_runtime_pm = true;
 	master->bus_num = pdev->id;
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LOOP;
 	master->num_chipselect = 2;
 	master->dev.of_node = pdev->dev.of_node;
 	master->bits_per_word_mask = SPI_BPW_MASK(16) | SPI_BPW_MASK(8);
-- 
1.8.3.2


