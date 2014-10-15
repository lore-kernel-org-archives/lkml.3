Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaJOTca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:32:30 -0400
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:52576 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751020AbaJOTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:32:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1539:1568:1711:1714:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3871:3872:3876:4321:5007:6261:10004:10848:11658:11914:12043:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stove83_4f8bfed25021b
X-Filterd-Recvd-Size: 1517
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] checkpatch: Improve test for no space after cast
Date: Wed, 15 Oct 2014 12:32:09 -0700
Message-Id: <65d265a551e3c4aab1d967c3625dfec3f0af1eae.1413400022.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2.443.g670a3c1
In-Reply-To: <cover.1413400022.git.joe@perches.com>
References: <cover.1413400022.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(foo) is not a cast, allow a space after it.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 scripts/checkpatch.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 692fdb6..21dac46 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2515,7 +2515,8 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|{)/) {
+		if ($line =~ /^\+.*(\w+\s*)?\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|[,;\({\[\<\>])/ &&
+		    (!defined($1) || $1 !~ /sizeof\s*/)) {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {
-- 
2.1.0

