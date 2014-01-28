Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaA1SW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:22:27 -0500
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:58508 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755324AbaA1SW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:22:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1515:1516:1518:1534:1539:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3876:3877:4321:5007:6114:6642:7652:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tank63_31ff892cd122f
X-Filterd-Recvd-Size: 1351
Message-ID: <1390933342.11756.12.camel@joe-AO722>
Subject: [PATCH] powerpc: numa: Fix decimal permissions
From: Joe Perches <joe@perches.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jan 2014 10:22:22 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should have been octal.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 86a63de..30a42e2 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1785,7 +1785,7 @@ static const struct file_operations topology_ops = {
 static int topology_update_init(void)
 {
 	start_topology_update();
-	proc_create("powerpc/topology_updates", 644, NULL, &topology_ops);
+	proc_create("powerpc/topology_updates", 0644, NULL, &topology_ops);
 
 	return 0;
 }


