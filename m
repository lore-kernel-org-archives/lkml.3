Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaFYDqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 23:46:45 -0400
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:45960 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752564AbaFYDqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 23:46:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3868:4321:5007:6120:7652:7903:10004:10400:10848:11658:11914:12043:12438:12517:12519:12555:13018:13019:13069:13095:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stop57_5283f8c0c23
X-Filterd-Recvd-Size: 1784
Message-ID: <1403668000.12657.15.camel@joe-AO725>
Subject: [RFC PATCH] checkpatch: Warn on unnecessary parentheses around
 references of foo->bar
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 24 Jun 2014 20:46:40 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parentheses around  &(foo->bar) and *(foo->bar) are unnecessary.
Emit a --strict only message on these uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
lk sources by far use &foo->bar over &(foo->bar).
(a rough count shows about 25:1)

 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 538105a..8feaee2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3462,6 +3462,14 @@ sub process {
 			}
 		}
 
+# check unnecessary parentheses around addressof/dereference single $Lvals
+# ie: &(foo->bar) should be &foo->bar and *(foo->bar) should be *foo->bar
+
+		while ($line =~ /(?:[^&]&\s*|\*)\(\s*($Ident\s*(?:$Member\s*)+)\s*\)/g) {
+			CHK("UNNECESSARY_PARENTHESES",
+			    "Unnecessary parentheses around $1\n" . $herecurr);
+		    }
+
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {




