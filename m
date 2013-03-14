Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3CNKdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:33:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab3CNKdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:33:17 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org, sachin.kamat@linaro.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH 1/2] drivers: uio_dmem_genirq: Use of_match_ptr() macro
Date: Thu, 14 Mar 2013 15:52:24 +0530
Message-Id: <1363256545-30687-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates having an #ifdef returning NULL for the case
when OF is disabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 drivers/uio/uio_dmem_genirq.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

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
1.7.4.1

