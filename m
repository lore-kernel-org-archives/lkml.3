Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaHDCut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 22:50:49 -0400
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:37704 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750900AbaHDCus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 22:50:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3653:3866:3867:4321:5007:6642:7652:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13208:13229:13311:13357:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twig73_5e0a08f4f4848
X-Filterd-Recvd-Size: 2014
Message-ID: <1407120645.16152.28.camel@joe-AO725>
Subject: [PATCH] checkpatch: Add test for printf formats with 0x that emit
 decimal
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Hans Wennborg <hans@hanshq.net>,
        Andy Whitcroft <apw@canonical.com>
Date: Sun, 03 Aug 2014 19:50:45 -0700
In-Reply-To: <1407112425.16152.10.camel@joe-AO725>
References: <1407018043-648-1-git-send-email-hans@hanshq.net>
	 <1407026806.1835.21.camel@joe-AO725> <53DD8E17.1@hanshq.net>
	 <1407046215.1835.24.camel@joe-AO725> <53DED2E9.5090205@hanshq.net>
	 <1407112425.16152.10.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0x%<foo> should be used to emit hexadecimal values.

Uses of 0x%[udi] emit decimal values but these should
probably instead use 0x%x variants.

Warn on these uses.

Signed-off-by: Joe Perches <joe@perches.com>
Noticed-by: Hans Wennborg <hans@hanshq.net>
---
 scripts/checkpatch.pl | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index da74e65..0178fe0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4985,6 +4985,10 @@ sub process {
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
 			$string = substr($rawline, $-[1], $+[1] - $-[1]);
 			$string =~ s/%%/__/g;
+			if ($string =~ /(0x(?<!%)%[0-9.\*]*[Ll]*[udi])(?![xX])/) {
+				WARN("PRINTF_HEX_WITH_DECIMAL",
+				     "Using printf format $1 emits a decimal not hexadecimal value\n" . $herecurr);
+			}
 			if ($string =~ /(?<!%)%L[udi]/) {
 				WARN("PRINTF_L",
 				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);


