Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaFBQ6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:58:40 -0400
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:42030 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753304AbaFBQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:58:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3870:3874:3876:4321:5007:7652:8531:10004:10400:10848:11658:11914:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoes50_2e3c64bd0e50b
X-Filterd-Recvd-Size: 1503
Message-ID: <1401728316.5770.9.camel@joe-AO725>
Subject: [PATCH] checkpatch: Warn on unnecessary void function return
 statements
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jun 2014 09:58:36 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

void function lines that use a single tab then "return;"
are generally unnecessary.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7774025..f9bb12c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3470,6 +3470,13 @@ sub process {
 			}
 		}
 
+# unnecessary return in a void function? (a single leading tab, then return;)
+		if ($sline =~ /^\+\treturn\s*;\s*$/ &&
+		    $prevline =~ /^\+/) {
+			WARN("RETURN_VOID",
+			     "void function return statements are not generally useful\n" . $herecurr);
+		}
+
 # if statements using unnecessary parentheses - ie: if ((foo == bar))
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /\bif\s*((?:\(\s*){2,})/) {


