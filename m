Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaCVXWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 19:22:06 -0400
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:55287 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750866AbaCVXWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 19:22:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:7652:10004:10026:10400:10848:11658:11914:12043:12517:12519:12555:13019:13069:13141:13230:13311:13357:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grade17_4bf270962c556
X-Filterd-Recvd-Size: 2657
Message-ID: <1395530518.3667.29.camel@joe-AO722>
Subject: [PATCH] checkpatch: Update "Missing a blank line after
 declarations" test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 22 Mar 2014 16:21:58 -0700
In-Reply-To: <20140322154020.f7b6a72c.akpm@linux-foundation.org>
References: <20140321142111.f0286ecdb8a03dd526f290ea@linux-foundation.org>
	 <1395526999.3667.17.camel@joe-AO722>
	 <20140322154020.f7b6a72c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"struct foo *bar" does not match the regex "$Declare\s+$Ident"
$Declare matches "struct foo *" but there is no required space
between the pointer "*" and the $Ident.

Also it ends in a pointer, the $Declare variable also contains all
trailing spaces after the declaration so there is no space between
$Declare and $Ident.

ie:	"struct foo * bar" does not match "$Declare\s+$Ident"

So, change the \s+ to \s* to have this regex match any of
	"struct foo bar", "struct foo *bar", and "struct foo * bar"

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 93beee8..bca2be0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2259,7 +2259,7 @@ sub process {
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
-		    ($prevline =~ /^\+\s+$Declare\s+$Ident\s*[=,;\[]/ ||
+		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2271,7 +2271,7 @@ sub process {
 			# not starting a section or a macro "\" extended line
 		      $prevline =~ /(?:\{\s*|\\)$/) &&
 			# looks like a declaration
-		    !($sline =~ /^\+\s+$Declare/ ||
+		    !($sline  =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
-- 
1.8.1.2.459.gbcd45b4.dirty



