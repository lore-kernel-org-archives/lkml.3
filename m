Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaKGGkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:40:08 -0500
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:56366 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751661AbaKGGkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:40:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3867:3871:3874:5007:6261:10004:10400:10848:11658:11914:12517:12519:12555:13069:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: eyes56_3aa6b965dde13
X-Filterd-Recvd-Size: 1563
Message-ID: <1415342399.23530.6.camel@perches.com>
Subject: [PATCH] checkpatch: Add test for consecutive string fragments
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2014 22:39:59 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit a warning when single line string coalescing occurs.

Code that uses compiler string concatenation on a single line like:
	printk("foo" "bar");
is generally better to read concatenated like:
	printk("foobar");

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 893cbd5..508037a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4462,6 +4462,12 @@ sub process {
 			    "Concatenated strings should use spaces between elements\n" . $herecurr);
 		}
 
+# uncoalesced string fragments
+		if ($line =~ /"X*"\s*"/) {
+			WARN("STRING_FRAGMENTS",
+			     "Consecutive strings are generally better as a single string\n" . $herecurr);
+		}
+
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("REDUNDANT_CODE",


