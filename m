Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbbAMQrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:47:21 -0500
Received: from sauhun.de ([89.238.76.85]:35966 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbbAMQrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:47:17 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org
Subject: [PATCH RESEND] dmaengine: drop owner assignment from platform_drivers
Date: Tue, 13 Jan 2015 17:46:48 +0100
Message-Id: <1421167621-24786-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/dma/at_xdmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index b60d77a22df6..1c4c96b7e2bf 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1507,7 +1507,6 @@ static struct platform_driver at_xdmac_driver = {
 	.remove		= at_xdmac_remove,
 	.driver = {
 		.name		= "at_xdmac",
-		.owner		= THIS_MODULE,
 		.of_match_table	= of_match_ptr(atmel_xdmac_dt_ids),
 		.pm		= &atmel_xdmac_dev_pm_ops,
 	}
-- 
2.1.3

