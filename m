Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaGUNNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:13:31 -0400
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:35712 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932104AbaGUNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:13:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3872:4321:5007:7652:7903:10004:10400:10848:11658:11914:12043:12296:12517:12519:12555:13069:13161:13221:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smoke10_3b6e46d25d62b
X-Filterd-Recvd-Size: 2135
Message-ID: <1405948406.21586.10.camel@joe-AO725>
Subject: [PATCH] checkpatch: Allow case labels with ranges
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 21 Jul 2014 06:13:26 -0700
In-Reply-To: <20140721113948.GX30888@lee--X1>
References: <20140721113948.GX30888@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MISSING_BREAK / fallthrough test does not support
gcc's extension for case labels with ranges.

Add it.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Lee Jones <lee.jones@linaro.org>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dc72a9b..2258497 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4767,7 +4767,7 @@ sub process {
 		}
 
 # check for case / default statements not preceeded by break/fallthrough/switch
-		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
+		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*(?:\.\.\.\s*(?:$Ident|$Constant)\s*)?|default):/) {
 			my $has_break = 0;
 			my $has_statement = 0;
 			my $count = 0;
@@ -4778,7 +4778,7 @@ sub process {
 				my $fline = $lines[$prevline - 1];
 				last if ($fline =~ /^\@\@/);
 				next if ($fline =~ /^\-/);
-				next if ($fline =~ /^.(?:\s*(?:case\s+(?:$Ident|$Constant)[\s$;]*|default):[\s$;]*)*$/);
+				next if ($fline =~ /^.(?:\s*(?:case\s+(?:$Ident|$Constant(?:\s*\.\.\.\s*(?:$Ident|$Constant))?)[\s$;]*|default):[\s$;]*)*$/);
 				$has_break = 1 if ($rline =~ /fall[\s_-]*(through|thru)/i);
 				next if ($fline =~ /^.[\s$;]*$/);
 				$has_statement = 1;


