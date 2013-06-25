Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab3FYEpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 00:45:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3FYEpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 00:45:03 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, hjk@hansjkoch.de, sachin.kamat@linaro.org
Subject: [PATCH Resend] drivers: uio_pdrv_genirq: Use of_match_ptr() macro
Date: Tue, 25 Jun 2013 09:59:52 +0530
Message-Id: <1372134592-21800-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates having an #ifdef returning NULL for the case
when OF is disabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Rebased on latest char-misc-next branch of char-misc tree.
---
 drivers/uio/uio_pdrv_genirq.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index bcd72f3..4eb8eaf 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -271,11 +271,8 @@ static struct of_device_id uio_of_genirq_match[] = {
 	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
-
 module_param_string(of_id, uio_of_genirq_match[0].compatible, 128, 0);
 MODULE_PARM_DESC(of_id, "Openfirmware id of the device to be handled by uio");
-#else
-# define uio_of_genirq_match NULL
 #endif
 
 static struct platform_driver uio_pdrv_genirq = {
@@ -285,7 +282,7 @@ static struct platform_driver uio_pdrv_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_pdrv_genirq_dev_pm_ops,
-		.of_match_table = uio_of_genirq_match,
+		.of_match_table = of_match_ptr(uio_of_genirq_match),
 	},
 };
 
-- 
1.7.9.5

