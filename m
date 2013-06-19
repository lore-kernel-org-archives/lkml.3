Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3FSEsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:48:09 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63499 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3FSEsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:48:08 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, hjk@hansjkoch.de, dhobsong@igel.co.jp,
        sachin.kamat@linaro.org
Subject: [PATCH Resend 1/2] drivers: uio_dmem_genirq: Use of_match_ptr() macro
Date: Wed, 19 Jun 2013 10:02:47 +0530
Message-Id: <1371616368-16459-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates having an #ifdef returning NULL for the case
when OF is disabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
This series is based on linux-next (next-20130618) and is
compile tested.
---

 drivers/uio/uio_dmem_genirq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index 252434c..125d0e5 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -336,8 +336,6 @@ static const struct of_device_id uio_of_genirq_match[] = {
 	{ /* empty for now */ },
 };
 MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
-#else
-# define uio_of_genirq_match NULL
 #endif
 
 static struct platform_driver uio_dmem_genirq = {
@@ -347,7 +345,7 @@ static struct platform_driver uio_dmem_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_dmem_genirq_dev_pm_ops,
-		.of_match_table = uio_of_genirq_match,
+		.of_match_table = of_match_ptr(uio_of_genirq_match),
 	},
 };
 
-- 
1.7.9.5

