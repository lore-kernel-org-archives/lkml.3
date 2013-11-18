Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3KRNvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:51:18 -0500
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:46361 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880Ab3KRNvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:51:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2332:2393:2559:2562:2828:3138:3139:3140:3141:3142:3653:3868:3871:4321:5007:7652:10004:10400:10848:11658:11914:12043:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: teeth60_60e6fa5dab74b
X-Filterd-Recvd-Size: 1517
Message-ID: <1384782664.5814.17.camel@joe-AO722>
Subject: [PATCH] checkpatch: Fix "Use of uninitialized value" warnings
From: Joe Perches <joe@perches.com>
To: Gerhard Sittig <gsi@denx.de>, Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 18 Nov 2013 05:51:04 -0800
In-Reply-To: <20131118114528.GJ17929@book.gsilab.sittig.org>
References: <20131118114528.GJ17929@book.gsilab.sittig.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch is currently confused about some complex macros
and references undefined variables $stat and $cond.

Make sure these are defined before using them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 61090e0..9c981003 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3289,6 +3289,7 @@ sub process {
 			}
 		}
 		if (!defined $suppress_whiletrailers{$linenr} &&
+		    defined($stat) && defined($cond) &&
 		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 


