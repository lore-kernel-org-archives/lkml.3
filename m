Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab3J1V4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:56:07 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:51547 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753501Ab3J1V4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:56:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2691:2828:2895:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:7576:7652:7903:9545:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12262:12296:12438:12517:12519:12555:12679:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fish96_34cd7dd94fe3f
X-Filterd-Recvd-Size: 2756
Message-ID: <1382997361.8718.11.camel@joe-AO722>
Subject: Re: [PATCH] Scripts: checkpatch.pl: Fix incorrect warning in
 multi-line seq_printf()
From: Joe Perches <joe@perches.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 28 Oct 2013 14:56:01 -0700
In-Reply-To: <1382995962-7023-1-git-send-email-rashika.kheria@gmail.com>
References: <1382995962-7023-1-git-send-email-rashika.kheria@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 03:02 +0530, Rashika Kheria wrote:
> This patch fixes the following incorrect warning given by checkpatch.pl
> in case of multi-line seq_printf() statements-

I believe this is already fixed in -next

>From 7f1b7c2810888bba02311ec75b19e0cbd598ef83 Mon Sep 17 00:00:00 2001
From: Joe Perches <joe@perches.com>
Date: Fri, 27 Sep 2013 10:14:51 +1000
Subject: [PATCH] checkpatch: update seq_<foo> tests

seq_vprintf, seq_printf and seq_puts are logging functions and should be
allowed to exceed the maximium line length.

Add maximum line length exceptions for these functions.

Also, suggesting seq_printf conversions to seq_puts should be tested for
arguments after the format.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/checkpatch.pl | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c03e427..42567bc 100755
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
@@ -3909,9 +3910,9 @@ sub string_find_replace {
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


