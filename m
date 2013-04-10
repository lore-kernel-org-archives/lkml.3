Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab3DJWtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:49:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937392Ab3DJWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 62/64] can: gw: use kmem_cache_free() instead of kfree()
Date: Wed, 10 Apr 2013 15:46:59 -0700
Message-Id: <20130410224348.102974556@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 3480a2125923e4b7a56d79efc76743089bf273fc upstream.

Memory allocated by kmem_cache_alloc() should be freed using
kmem_cache_free(), not kfree().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/gw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -436,7 +436,7 @@ static int cgw_notifier(struct notifier_
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(gwj);
-				kfree(gwj);
+				kmem_cache_free(cgw_cache, gwj);
 			}
 		}
 	}
@@ -829,7 +829,7 @@ static void cgw_remove_all_jobs(void)
 	hlist_for_each_entry_safe(gwj, n, nx, &cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 	}
 }
 
@@ -885,7 +885,7 @@ static int cgw_remove_job(struct sk_buff
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;
 	}


