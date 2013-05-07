Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab3EGD7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:59:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab3EGD7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:59:00 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=R0xAAHpd0z4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-pYQEcHWpdoA:10 a=YhdJeHolAAAA:8 a=VwQbUJbxAAAA:8 a=oZC0XEVVAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=y_5hAxkTRQwA:10 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035847.661673701@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [040/126] can: gw: use kmem_cache_free() instead of kfree()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0040-can-gw-use-kmem_cache_free-instead-of-kfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit 3480a2125923e4b7a56d79efc76743089bf273fc ]

Memory allocated by kmem_cache_alloc() should be freed using
kmem_cache_free(), not kfree().

Cc: linux-stable <stable@vger.kernel.org> # >= v3.2
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/can/gw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index b54d5e6..36cf941 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -436,7 +436,7 @@ static int cgw_notifier(struct notifier_block *nb,
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(gwj);
-				kfree(gwj);
+				kmem_cache_free(cgw_cache, gwj);
 			}
 		}
 	}
@@ -826,7 +826,7 @@ static void cgw_remove_all_jobs(void)
 	hlist_for_each_entry_safe(gwj, n, nx, &cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 	}
 }
 
@@ -879,7 +879,7 @@ static int cgw_remove_job(struct sk_buff *skb,  struct nlmsghdr *nlh, void *arg)
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;
 	}
-- 
1.7.10.4


