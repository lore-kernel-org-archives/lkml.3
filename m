Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935980Ab3DIG3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:29:13 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36793 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3DIG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:29:12 -0400
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 14:29:11 +0800
Message-ID: <CAPgLHd_MMO5pCMzQnfomBKkK+waYqQzpzDpX9AAP4FV7Cp0xEw@mail.gmail.com>
Subject: [PATCH -next] workqueue: use kmem_cache_free() instead of kfree()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: tj@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

memory allocated by kmem_cache_alloc() should be freed using
kmem_cache_free(), not kfree().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c273376..154aa12 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3750,7 +3750,7 @@ static void free_unbound_pwq(struct pool_workqueue *pwq)
 
 	if (pwq) {
 		put_unbound_pool(pwq->pool);
-		kfree(pwq);
+		kmem_cache_free(pwq_cache, pwq);
 	}
 }
 

