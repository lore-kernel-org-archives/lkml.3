Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3DVOaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:30:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51654 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755086Ab3DVOaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.140996636@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [30/75] can: gw: use kmem_cache_free() instead of kfree()
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 3480a2125923e4b7a56d79efc76743089bf273fc upstream.

Memory allocated by kmem_cache_alloc() should be freed using
kmem_cache_free(), not kfree().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
@@ -850,7 +850,7 @@ static void cgw_remove_all_jobs(void)
 	hlist_for_each_entry_safe(gwj, n, nx, &cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 	}
 }
 
@@ -903,7 +903,7 @@ static int cgw_remove_job(struct sk_buff
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;
 	}

