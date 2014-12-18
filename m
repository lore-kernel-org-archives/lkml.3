Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaLRWRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:17:13 -0500
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:55524 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751324AbaLRWRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:17:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3868:3871:3872:4321:4605:5007:6119:6261:7903:10004:10400:10848:11658:11914:12043:12517:12519:12555:13019:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pies70_4649646e190a
X-Filterd-Recvd-Size: 2059
Message-ID: <1418941028.28384.18.camel@perches.com>
Subject: checkpatch: Emit an error when using predefined timestamp macros
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andy Whitcroft <apw@canonical.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2014 14:17:08 -0800
In-Reply-To: <1418938012.28384.16.camel@perches.com>
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1418383004.18092.46.camel@perches.com> <87ppbg64nj.fsf@rasmusvillemoes.dk>
	 <1418938012.28384.16.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit fe7c36c7bde1 ("Makefile: Build with -Werror=date-time if
the compiler supports it"), use of __DATE__, __TIME__, and __TIMESTAMP__
has not been allowed.

As this test is gcc version specific (> 4.9), it hasn't prevented a few
new uses from creeping into the kernel sources.

Make checkpatch complain about them.

Original-patch-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d6..501c286 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5089,6 +5089,12 @@ sub process {
 			}
 		}
 
+# check for uses of __DATE__, __TIME__, __TIMESTAMP__
+		while ($line =~ /\b(__(?:DATE|TIME|TIMESTAMP)__)\b/g) {
+			ERROR("DATE_TIME",
+			      "Use of the '$1' macro makes the build non-deterministic\n" . $herecurr);
+		}
+
 # check for use of yield()
 		if ($line =~ /\byield\s*\(\s*\)/) {
 			WARN("YIELD",



