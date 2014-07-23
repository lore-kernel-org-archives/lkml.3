Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaGWEbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:31:23 -0400
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:36301 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751246AbaGWEbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:31:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3870:3871:4321:5007:7652:10004:10400:10848:11658:11914:12043:12517:12519:12555:13069:13221:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: teeth02_8013e1a99c448
X-Filterd-Recvd-Size: 1878
Message-ID: <1406089878.2755.11.camel@joe-AO725>
Subject: [PATCH] checkpatch: Fix false positives for --strict "space after
 cast" test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hartley Sweeten <HartleyS@visionengravers.com>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 21:31:18 -0700
In-Reply-To: <1406056988.2755.1.camel@joe-AO725>
References: <DC148C5AA1CEBA4E87973D432B1C2D8825F13B6F@P3PWEX4MB008.ex4.secureserver.net>
	 <1406056988.2755.1.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 89da401f6cff ("checkpatch: improve "no space after cast" test")
in -next improved the cast test for non pointer types, but also
introduced false positives for some types of static inlines.

Add a test for an open brace to the exclusions to avoid these
false positives.

Reported-by: Hartley Sweeten <HartleyS@visionengravers.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dc72a9b..7dcfc75 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2418,7 +2418,7 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic)/) {
+		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|{)/) {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {


