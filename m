Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab3LXAyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:54:43 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:57083 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab3LXAyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:54:41 -0500
MIME-Version: 1.0
Date: Tue, 24 Dec 2013 08:54:40 +0800
Message-ID: <CAPgLHd8TNm2WE9yA73E8R_2zi8PKSMwwWkyy=hN+52m1hq1p=Q@mail.gmail.com>
Subject: [PATCH -next] Staging: silicom: fix sparse non static symbol warnings
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, chad@dahc.us,
        michael.hoefler@studium.uni-erlangen.de, christoph.kohl@t-online.de,
        rupert@rmuch.net, rdunlap@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/staging/silicom/bypasslib/bypass.c:528:12: warning:
 symbol 'init_lib_module' was not declared. Should it be static?
drivers/staging/silicom/bypasslib/bypass.c:534:13: warning:
 symbol 'cleanup_lib_module' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/silicom/bypasslib/bypass.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index 9b771c9..09e00da 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -525,13 +525,13 @@ static int get_bypass_info(int if_index, struct bp_info *bp_info)
 }
 EXPORT_SYMBOL(get_bypass_info);
 
-int __init init_lib_module(void)
+static int __init init_lib_module(void)
 {
 	printk(VERSION);
 	return 0;
 }
 
-void __exit cleanup_lib_module(void)
+static void __exit cleanup_lib_module(void)
 {
 }
 

