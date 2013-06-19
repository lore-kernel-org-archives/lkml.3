Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab3FSEsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:48:15 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59033 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3FSEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:48:11 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, hjk@hansjkoch.de, dhobsong@igel.co.jp,
        sachin.kamat@linaro.org
Subject: [PATCH Resend 2/2] drivers: uio_pdrv_genirq: Use of_match_ptr() macro
Date: Wed, 19 Jun 2013 10:02:48 +0530
Message-Id: <1371616368-16459-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371616368-16459-1-git-send-email-sachin.kamat@linaro.org>
References: <1371616368-16459-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates having an #ifdef returning NULL for the case
when OF is disabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/uio/uio_pdrv_genirq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index c122bca..d7ba355 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -267,8 +267,6 @@ static const struct of_device_id uio_of_genirq_match[] = {
 	{ /* empty for now */ },
 };
 MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
-#else
-# define uio_of_genirq_match NULL
 #endif
 
 static struct platform_driver uio_pdrv_genirq = {
@@ -278,7 +276,7 @@ static struct platform_driver uio_pdrv_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_pdrv_genirq_dev_pm_ops,
-		.of_match_table = uio_of_genirq_match,
+		.of_match_table = of_match_ptr(uio_of_genirq_match),
 	},
 };
 
-- 
1.7.9.5

