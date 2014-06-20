Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563AbaFTFWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:22:44 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:49970 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933667AbaFTFWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:22:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3867:3868:3871:3872:3874:4321:4605:5007:6119:7652:7903:8531:10004:10400:10848:11026:11658:11914:12043:12517:12519:12555:12663:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: copy38_6ee07ddac4033
X-Filterd-Recvd-Size: 1870
Message-ID: <1403241760.2753.46.camel@joe-AO725>
Subject: [PATCH] checkpatch: Ignore email headers better
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jun 2014 22:22:40 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some patches created by git format-patch
that when scanned by checkpatch report errors on
lines like

To:	address.tld

This is a checkpatch false positive.

Improve the logic a bit to ignore folded email headers
to avoid emitting these messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dd845b9..1e17de2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1637,7 +1637,7 @@ sub process {
 	my $signoff = 0;
 	my $is_patch = 0;
 
-	my $in_header_lines = 1;
+	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
 
 	my $non_utf8_charset = 0;
@@ -1993,7 +1993,8 @@ sub process {
 # Check if it's the start of a commit log
 # (not a header line and we haven't seen the patch filename)
 		if ($in_header_lines && $realfile =~ /^$/ &&
-		    $rawline !~ /^(commit\b|from\b|[\w-]+:).+$/i) {
+		    !($rawline =~ /^\s+\S/ ||
+		      $rawline =~ /^(commit\b|from\b|[\w-]+:).*$/i)) {
 			$in_header_lines = 0;
 			$in_commit_log = 1;
 		}


