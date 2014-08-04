Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaHDH4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:56:36 -0400
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:53714 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751136AbaHDH4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:56:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3867:3871:3872:4321:5007:7652:7903:8957:9010:9012:9592:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13069:13221:13229:13311:13357:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bat21_9099bfaf4b310
X-Filterd-Recvd-Size: 2298
Message-ID: <1407138992.16152.53.camel@joe-AO725>
Subject: [PATCH] checkpatch: Add uninitialized_var to the declaration_macro
 list
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dotan Barak <dotanb@mellanox.com>, Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Aug 2014 00:56:32 -0700
In-Reply-To: <9084ad9a17844ed898132853d161b495@DB3PR05MB380.eurprd05.prod.outlook.com>
References: <9084ad9a17844ed898132853d161b495@DB3PR05MB380.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using uninitialized_var reports a false positive for
"Missing blank line after declarations".

Fix it by adding uninitialized_var to the $declaration_macros
exceptions list.

Move the macro list after $Type is declared.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Dotan Barak <dotanb@mellanox.com>
---
 scripts/checkpatch.pl | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index da74e65..99cce04 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -423,11 +423,6 @@ foreach my $entry (@mode_permission_funcs) {
 	$mode_perms_search .= $entry->[0];
 }
 
-our $declaration_macros = qr{(?x:
-	(?:$Storage\s+)?(?:DECLARE|DEFINE)_[A-Z]+\s*\(|
-	(?:$Storage\s+)?LIST_HEAD\s*\(
-)};
-
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory
@@ -490,6 +485,12 @@ our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
 our $LvalOrFunc	= qr{((?:[\&\*]\s*)?$Lval)\s*($balanced_parens{0,1})\s*};
 our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 
+our $declaration_macros = qr{(?x:
+	(?:$Storage\s+)?(?:DECLARE|DEFINE)_[A-Z]+\s*\(|
+	(?:$Storage\s+)?LIST_HEAD\s*\(|
+	(?:$Storage\s+)?$Type\s+uninitialized_var\s*\(
+)};
+
 sub deparenthesize {
 	my ($string) = @_;
 	return "" if (!defined($string));


