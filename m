Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3LRFju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:39:50 -0500
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:60441 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752817Ab3LRFjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:39:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3868:3874:4321:4605:5007:7652:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13141:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crook34_1b532f07c481d
X-Filterd-Recvd-Size: 2360
Message-ID: <1387345186.13593.7.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Fix wrong curly bracket position
 reporting
From: Joe Perches <joe@perches.com>
To: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 17 Dec 2013 21:39:46 -0800
In-Reply-To: <1387335591-8741-1-git-send-email-jtheou@adeneo-embedded.us>
References: <1387335591-8741-1-git-send-email-jtheou@adeneo-embedded.us>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 18:59 -0800, Jean-Baptiste Theou wrote:
> This patch fixes wrong curly bracket position reporting when function
> declarations have only one void argument.
> 
> Missing error (ERROR: space required before the open brace '{') on this
> situation :
> 
> int foo(void){
> 	...
> }

That's true for any declaration with { on the same line.

Perhaps this would be better:
---
 scripts/checkpatch.pl | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8f3aecd..c4dbb8a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2784,7 +2784,8 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
+		if ($^V && $^V ge 5.10.0 &&
+		    ($line=~/$Type\s*$Ident\s*$balanced_parens\s*{\s*$/) &&
 		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
 			ERROR("OPEN_BRACE",
 			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
@@ -3159,7 +3160,9 @@ sub process {
 ## 		}
 
 #need space before brace following if, while, etc
-		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
+		if ($^V && $^V ge 5.10.0 &&
+		    ($line !~ /$Type\s*$Ident\s*$balanced_parens\s*{\s*$/) &&
+		    ($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
 		    $line =~ /do{/) {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&


