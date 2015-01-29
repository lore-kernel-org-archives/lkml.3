Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbbA2H1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:27:41 -0500
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:60561 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752806AbbA2H1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:27:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:4321:5007:6261:10004:10400:10848:11026:11232:11658:11914:12517:12519:12555:13019:13069:13161:13229:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ball41_427e52087e35e
X-Filterd-Recvd-Size: 1955
Message-ID: <1422516455.5571.1.camel@perches.com>
Subject: [PATCH] checkpatch: Add ability to --fix unnecessary blank lines
 around braces
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 28 Jan 2015 23:27:35 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a --strict test for these blank lines.

Add the ability to automatically remove them with --fix.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6705576..059c032 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4461,12 +4461,18 @@ sub process {
 
 # check for unnecessary blank lines around braces
 		if (($line =~ /^.\s*}\s*$/ && $prevrawline =~ /^.\s*$/)) {
-			CHK("BRACES",
-			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
+			if (CHK("BRACES",
+				"Blank lines aren't necessary before a close brace '}'\n" . $hereprev) &&
+			    $fix && $prevrawline =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+			}
 		}
 		if (($rawline =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
-			CHK("BRACES",
-			    "Blank lines aren't necessary after an open brace '{'\n" . $hereprev);
+			if (CHK("BRACES",
+				"Blank lines aren't necessary after an open brace '{'\n" . $hereprev) &&
+			    $fix) {
+				fix_delete_line($fixlinenr, $rawline);
+			}
 		}
 
 # no volatiles please



