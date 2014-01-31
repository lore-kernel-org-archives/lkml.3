Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaAaKZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:25:18 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42877 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754133AbaAaKZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:25:15 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/3] spi: core: Update the devm_spi_register_master documentation
Date: Fri, 31 Jan 2014 11:23:11 +0100
Message-Id: <1391163792-21819-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the devm_spi_register_master function is used together with the
spi_alloc_master as advertised in the documentation, it will either lead to a
memory leak if spi_put_master is removed, or we will try to access an already
freed memory area during the unregistration function.

Advertise that you want to use the devm_spi_alloc_master function in such case.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index eb728ec..dc577b7 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1444,7 +1444,7 @@ static void devm_spi_unregister(struct device *dev, void *res)
 /**
  * dev_spi_register_master - register managed SPI master controller
  * @dev:    device managing SPI master
- * @master: initialized master, originally from spi_alloc_master()
+ * @master: initialized master, originally from devm_spi_alloc_master()
  * Context: can sleep
  *
  * Register a SPI device as with spi_register_master() which will
-- 
1.8.4.2

