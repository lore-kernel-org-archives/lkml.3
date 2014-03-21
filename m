Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965852AbaCUBNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:13:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991AbaCUAEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 081/149] spi: coldfire-qspi: Fix getting correct address for *mcfqspi
Date: Thu, 20 Mar 2014 17:04:04 -0700
Message-Id: <20140321000439.771440263@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit ee73b4c6e3fc0755a91752ab8eebc8e070038b53 upstream.

dev_get_drvdata() returns the address of master rather than mcfqspi.

Fixes: af361079 (spi/coldfire-qspi: Drop extra calls to spi_master_get in suspend/resume functions)
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-coldfire-qspi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -539,7 +539,8 @@ static int mcfqspi_resume(struct device
 #ifdef CONFIG_PM_RUNTIME
 static int mcfqspi_runtime_suspend(struct device *dev)
 {
-	struct mcfqspi *mcfqspi = dev_get_drvdata(dev);
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct mcfqspi *mcfqspi = spi_master_get_devdata(master);
 
 	clk_disable(mcfqspi->clk);
 
@@ -548,7 +549,8 @@ static int mcfqspi_runtime_suspend(struc
 
 static int mcfqspi_runtime_resume(struct device *dev)
 {
-	struct mcfqspi *mcfqspi = dev_get_drvdata(dev);
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct mcfqspi *mcfqspi = spi_master_get_devdata(master);
 
 	clk_enable(mcfqspi->clk);
 


