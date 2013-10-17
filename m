Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab3JQQG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:06:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45787 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab3JQQG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:06:57 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-fb-52600b1f4341
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] spi/s3c64xx: Add missing pm_runtime_set_active() call in
 probe()
Date: Thu, 17 Oct 2013 18:06:46 +0200
Message-id: <1382026006-15544-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xq7ry3AlBBu179S0mrTvAZDH14RM2
	i9cvDC16F1xlszjb9IbdYtPja6wWl3fNYbOYcX4fk0Xjx5vsFofftLM6cHn8XfWC2WPTqk42
	j81L6j36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoErY/6ONsaCWewVEyZ9ZWlgbGHrYuTkkBAw
	kdjY0sECYYtJXLi3HijOxSEksJRR4u6ORewQTh+TRMP1I4wgVWwCxhKbly8B6xYRyJK4/W8L
	M0gRs8BkJonTL3eCFQkLBEu8e9zHCmKzCKhKfJh+jR3E5hVwl+g/2AMU5wBapyAxZ5LNBEbu
	BYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCAujLDsbFx6wOMQpwMCrx8B74Fh8kxJpY
	VlyZe4hRgoNZSYQ3jishSIg3JbGyKrUoP76oNCe1+BAjEwenVAOj91KnQ9xf1NImfljdJbI0
	a7mL0NeX+guZIxdWLwiaIuqiL/NmrbexdMv/uxc6H3nrav43VfnC4KYxx68kIL4vzzKVcaKU
	uVFy03XOnWEL5e39bdidwmp/Jd77FaB1rUhkd+g28fXiFZyHraZo9l198uHjsvxXmnN8cu6H
	NsafUVbUaOnqjlJiKc5INNRiLipOBAB40Ua+/gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark device as PM runtime active during initialization to reflect
actual device power/clocks state. This reduces the enable count for SPI
bus controller gate clock so it can be disabled when the bus controller
is not used.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 0ddaff2..ae07c3a 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1429,6 +1429,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	       S3C64XX_SPI_INT_TX_OVERRUN_EN | S3C64XX_SPI_INT_TX_UNDERRUN_EN,
 	       sdd->regs + S3C64XX_SPI_INT_EN);
 
+	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	if (spi_register_master(master)) {
-- 
1.7.9.5

