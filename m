Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3LTDFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:05:30 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:47434 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3LTDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:05:18 -0500
MIME-Version: 1.0
Date: Fri, 20 Dec 2013 11:05:16 +0800
Message-ID: <CAPgLHd_XxCwb=JwKScKeCFCM1g6rgH78BBXz4k+4gm1m4t4JAw@mail.gmail.com>
Subject: [PATCH] staging: sep: add missing destroy_workqueue() in sep_crypto.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, standby24x7@gmail.com, devendra.aaru@gmail.com,
        rashika.kheria@gmail.com, joe@perches.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing destroy_workqueue() before return from
sep_crypto_setup() and sep_crypto_takedown().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/sep/sep_crypto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index b9262a7..1c62101 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -3927,6 +3927,7 @@ int sep_crypto_setup(void)
 err_algs:
 	for (k = 0; k < i; k++)
 		crypto_unregister_ahash(&hash_algs[k]);
+	destroy_workqueue(sep_dev->workqueue);
 	return err;
 
 err_crypto_algs:
@@ -3945,6 +3946,7 @@ void sep_crypto_takedown(void)
 	for (i = 0; i < ARRAY_SIZE(crypto_algs); i++)
 		crypto_unregister_alg(&crypto_algs[i]);
 
+	destroy_workqueue(sep_dev->workqueue);
 	tasklet_kill(&sep_dev->finish_tasklet);
 }
 

