Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3IXSi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:38:58 -0400
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:53489 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752912Ab3IXSi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:38:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3866:3874:4321:4605:5007:7652:8957:10004:10400:10848:11658:11914:12043:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pie04_88126d46e5320
X-Filterd-Recvd-Size: 1656
Message-ID: <1380047934.3575.100.camel@joe-AO722>
Subject: [PATCH] checkpatch: Find CamelCase definitions of struct/union/enum
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Sep 2013 11:38:54 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch doesn't currently find CamelCase definitions
of structs, unions or enums.

Add that ability.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c03e427..3d51710 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -442,8 +442,9 @@ sub seed_camelcase_file {
 		next if ($line !~ /(?:[A-Z][a-z]|[a-z][A-Z])/);
 		if ($line =~ /^[ \t]*(?:#[ \t]*define|typedef\s+$Type)\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)/) {
 			$camelcase{$1} = 1;
-		}
-	        elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*[\(\[,;]/) {
+		} elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*[\(\[,;]/) {
+			$camelcase{$1} = 1;
+		} elsif ($line =~ /^\s*(?:union|struct|enum)\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*[;\{]/) {
 			$camelcase{$1} = 1;
 		}
 	}


