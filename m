Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbaGASJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:09:17 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:57504 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757101AbaGASJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:09:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:3872:4321:5007:7652:10004:10400:10848:11658:11914:12043:12517:12519:12555:13069:13095:13311:13357:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: clock50_165ade4354720
X-Filterd-Recvd-Size: 1680
Message-ID: <1404238152.14624.13.camel@joe-AO725>
Subject: [PATCH] checkpatch: Improve "no space after cast" test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 01 Jul 2014 11:09:12 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This --strict test previously worked only for what appeared
to be cast to pointer types.

Make it work for all casts.

Also, there's no reason to show the previous line for this
type of message, so don't.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 182be0f..0a3c759 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2256,12 +2256,12 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\*[ \t]*\)[ \t]+(?!$Assignment|$Arithmetic)/) {
+		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic)/) {
 			if (CHK("SPACING",
-				"No space is necessary after a cast\n" . $hereprev) &&
+				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {
 				$fixed[$linenr - 1] =~
-				    s/^(\+.*\*[ \t]*\))[ \t]+/$1/;
+				    s/(\(\s*$Type\s*\))[ \t]+/$1/;
 			}
 		}
 


