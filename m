Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3IMWtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 18:49:06 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:60914 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754990Ab3IMWtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 18:49:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3867:3868:3874:5007:6119:7652:10004:10400:10848:11232:11473:11658:11914:12043:12296:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: salt23_4edd886e62f57
X-Filterd-Recvd-Size: 2026
Message-ID: <1379112540.2066.27.camel@joe-AO722>
Subject: [PATCH] checkpatch: Update seq_<foo> tests
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 13 Sep 2013 15:49:00 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seq_vprintf, seq_printf and seq_puts are logging functions
and should be allowed to exceed the maximium line length.

Add maximum line length exceptions for these functions.

Also, suggesting seq_printf conversions to seq_puts
should be tested for arguments after the format.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 47016c3..c71ba8e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -323,7 +323,8 @@ our $logFunctions = qr{(?x:
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
 	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
-	MODULE_[A-Z_]+
+	MODULE_[A-Z_]+|
+	seq_vprintf|seq_printf|seq_puts
 )};
 
 our $signature_tags = qr{(?xi:
@@ -3903,9 +3904,9 @@ sub string_find_replace {
 		}
 
 # check for seq_printf uses that could be seq_puts
-		if ($line =~ /\bseq_printf\s*\(/) {
+		if ($sline =~ /\bseq_printf\s*\(.*"\s*\)\s*;\s*$/) {
 			my $fmt = get_quoted_string($line, $rawline);
-			if ($fmt !~ /[^\\]\%/) {
+			if ($fmt ne "" && $fmt !~ /[^\\]\%/) {
 				if (WARN("PREFER_SEQ_PUTS",
 					 "Prefer seq_puts to seq_printf\n" . $herecurr) &&
 				    $fix) {


