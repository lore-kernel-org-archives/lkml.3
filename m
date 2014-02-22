Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaBVBS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 20:18:57 -0500
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:40834 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750960AbaBVBSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 20:18:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3867:3868:3870:3871:4605:5007:7652:7903:8660:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13148:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: balls93_87e0d3d943a0c
X-Filterd-Recvd-Size: 1759
Message-ID: <1393031931.3627.6.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add test for char * arrays that could be static
 const
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, lkml <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 17:18:51 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static const char* arrays create smaller text as each
function call does not have to populate the array.

Emit a warning when char *arrays aren't static const
and the array is not apparently global by being
declared in the first column.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 646295c..2e6257b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2675,6 +2675,13 @@ sub process {
 				$herecurr);
                }
 
+# check for non-global char *foo[] = {"bar", ...} declarations.
+		if ($line =~ /^.\s+(?:static\s+|const\s+)?char\s+\*\s*\w+\s*\[\s*\]\s*=\s*\{/) {
+			WARN("STATIC_CONST_CHAR_ARRAY",
+			     "char * array declaration might be better as static const\n" .
+				$herecurr);
+               }
+
 # check for function declarations without arguments like "int foo()"
 		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
 			if (ERROR("FUNCTION_WITHOUT_ARGS",


