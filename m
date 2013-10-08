Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3JHUgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:36:07 -0400
Received: from sauhun.de ([89.238.76.85]:52221 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab3JHUgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:36:03 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] spi: spi-txx9: replace platform_driver_probe to support deferred probing
Date: Tue,  8 Oct 2013 22:35:41 +0200
Message-Id: <1381264542-29396-10-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
References: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystems like pinctrl and gpio rightfully make use of deferred probing at
core level. Now, deferred drivers won't be retried if they don't have a .probe
function specified in the driver struct. Fix this driver to have that, so the
devices it supports won't get lost in a deferred probe.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/spi/spi-txx9.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-txx9.c b/drivers/spi/spi-txx9.c
index 7c6d157..c67a1b8 100644
--- a/drivers/spi/spi-txx9.c
+++ b/drivers/spi/spi-txx9.c
@@ -440,6 +440,7 @@ static int txx9spi_remove(struct platform_device *dev)
 MODULE_ALIAS("platform:spi_txx9");
 
 static struct platform_driver txx9spi_driver = {
+	.probe = txx9spi_probe,
 	.remove = txx9spi_remove,
 	.driver = {
 		.name = "spi_txx9",
@@ -449,7 +450,7 @@ static struct platform_driver txx9spi_driver = {
 
 static int __init txx9spi_init(void)
 {
-	return platform_driver_probe(&txx9spi_driver, txx9spi_probe);
+	return platform_driver_register(&txx9spi_driver);
 }
 subsys_initcall(txx9spi_init);
 
-- 
1.8.4.rc3

