Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaIJERv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:17:51 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:38375 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751118AbaIJERs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:17:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2904:3138:3139:3140:3141:3142:3165:3352:3865:3866:4250:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357:14093:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grass30_60f25c5dd0311
X-Filterd-Recvd-Size: 2422
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Ursula Braun <ursula.braun@de.ibm.com>, linux390@de.ibm.com,
        "David S. Miller" <davem@davemloft.net>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] iucv: Convert pr_warning to pr_warn
Date: Tue,  9 Sep 2014 21:17:31 -0700
Message-Id: <d976373ac5f17cb7716048d938a3ee1a5a10e6e2.1410322181.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1410322181.git.joe@perches.com>
References: <cover.1410322181.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.
Coalesce formats.
Realign arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/iucv/iucv.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index da78793..2a6a1fd 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -493,8 +493,8 @@ static void iucv_declare_cpu(void *data)
 			err = "Paging or storage error";
 			break;
 		}
-		pr_warning("Defining an interrupt buffer on CPU %i"
-			   " failed with 0x%02x (%s)\n", cpu, rc, err);
+		pr_warn("Defining an interrupt buffer on CPU %i failed with 0x%02x (%s)\n",
+			cpu, rc, err);
 		return;
 	}
 
@@ -1831,7 +1831,7 @@ static void iucv_external_interrupt(struct ext_code ext_code,
 	BUG_ON(p->iptype  < 0x01 || p->iptype > 0x09);
 	work = kmalloc(sizeof(struct iucv_irq_list), GFP_ATOMIC);
 	if (!work) {
-		pr_warning("iucv_external_interrupt: out of memory\n");
+		pr_warn("iucv_external_interrupt: out of memory\n");
 		return;
 	}
 	memcpy(&work->data, p, sizeof(work->data));
@@ -1974,8 +1974,7 @@ static int iucv_pm_restore(struct device *dev)
 	printk(KERN_WARNING "iucv_pm_restore %p\n", iucv_path_table);
 #endif
 	if ((iucv_pm_state != IUCV_PM_RESTORING) && iucv_path_table)
-		pr_warning("Suspending Linux did not completely close all IUCV "
-			"connections\n");
+		pr_warn("Suspending Linux did not completely close all IUCV connections\n");
 	iucv_pm_state = IUCV_PM_RESTORING;
 	if (cpumask_empty(&iucv_irq_cpumask)) {
 		rc = iucv_query_maxconn();
-- 
1.8.1.2.459.gbcd45b4.dirty

