Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3CNOGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:06:47 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41970 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab3CNOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:06:46 -0400
MIME-Version: 1.0
Date: Thu, 14 Mar 2013 22:06:45 +0800
Message-ID: <CAPgLHd9BkPUDrgg5jsexFD08=d_ExujMSQmDQd0=9sX5CbPpDg@mail.gmail.com>
Subject: [PATCH] xtensa: net: fix invalid use of sizeof in iss_net_setup()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: chris@zankel.net, jcmvbkbc@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

sizeof() when applied to a pointer typed expression gives the
size of the pointer, not that of the pointed data.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/xtensa/platforms/iss/network.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 7d0fea6..da56fec 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -737,7 +737,7 @@ static int iss_net_setup(char *str)
 		return 1;
 	}
 
-	if ((new = alloc_bootmem(sizeof new)) == NULL) {
+	if ((new = alloc_bootmem(sizeof(*new)) == NULL) {
 		printk("Alloc_bootmem failed\n");
 		return 1;
 	}


