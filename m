Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbbAEM3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:29:24 -0500
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:36019 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753557AbbAEM3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:29:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3870:3871:3872:5007:6261:10004:10400:10848:11026:11473:11658:11914:12296:12438:12517:12519:12555:13069:13311:13357:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act96_8b98ebdb55b5f
X-Filterd-Recvd-Size: 1542
Message-ID: <1420460958.2652.4.camel@perches.com>
Subject: [PATCH] s390: Remove unnecessary KERN_CONT
From: Joe Perches <joe@perches.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 05 Jan 2015 04:29:18 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has no effect as KERN_CONT is an empty string,

It's probably just a missing conversion artifact as the
other pr_cont uses in the same file don't have this prefix.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/mm/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 811937b..232c14e 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -171,7 +171,7 @@ static void dump_pagetable(unsigned long asce, unsigned long address)
 		table = table + ((address >> 20) & 0x7ff);
 		if (bad_address(table))
 			goto bad;
-		pr_cont(KERN_CONT "S:%016lx ", *table);
+		pr_cont("S:%016lx ", *table);
 		if (*table & (_SEGMENT_ENTRY_INVALID | _SEGMENT_ENTRY_LARGE))
 			goto out;
 		table = (unsigned long *)(*table & _SEGMENT_ENTRY_ORIGIN);


