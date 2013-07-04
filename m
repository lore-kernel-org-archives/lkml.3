Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3GDNdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:33:12 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:39595 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3GDNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:33:10 -0400
MIME-Version: 1.0
Date: Thu, 4 Jul 2013 21:33:08 +0800
Message-ID: <CAPgLHd_Cpt-6R+75SuKamb3tCboFCw7_A2isFdkecHCFpvsGUA@mail.gmail.com>
Subject: [PATCH] c2port: fix return value check in duramar2150_c2port_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@suse.de
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function c2port_device_register() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check should be
replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/c2port/c2port-duramar2150.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/c2port/c2port-duramar2150.c b/drivers/misc/c2port/c2port-duramar2150.c
index 5484301..3dc61ea 100644
--- a/drivers/misc/c2port/c2port-duramar2150.c
+++ b/drivers/misc/c2port/c2port-duramar2150.c
@@ -129,8 +129,8 @@ static int __init duramar2150_c2port_init(void)
 
 	duramar2150_c2port_dev = c2port_device_register("uc",
 					&duramar2150_c2port_ops, NULL);
-	if (!duramar2150_c2port_dev) {
-		ret = -ENODEV;
+	if (IS_ERR(duramar2150_c2port_dev)) {
+		ret = PTR_ERR(duramar2150_c2port_dev);
 		goto free_region;
 	}
 

