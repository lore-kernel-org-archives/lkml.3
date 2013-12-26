Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3LZTUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:20:41 -0500
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:50887 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753611Ab3LZTUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:20:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:3874:4321:4419:4823:5007:6261:10004:10026:10848:11026:11473:11658:11914:12296:12517:12519:12555:13221:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pan75_5cdf478296f49
X-Filterd-Recvd-Size: 2015
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] checkpatch: Improve space before tab --fix option
Date: Thu, 26 Dec 2013 11:20:30 -0800
Message-Id: <1b6f7d8b9cf4583ac399824977e081f720cdaf01.1388085015.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1388085015.git.joe@perches.com>
References: <cover.1388085015.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test should remove all the spaces before a tab not
just one space.

Substitute a tab for each 8 space block before a tab and
remove less than 8 spaces before a tab.

This SPACE_BEFORE_TAB test is done after CODE_INDENT.

If there are spaces used at the beginning of a line that
should be converted to tabs, please make sure that the
CODE_INDENT test and conversion is done before this
SPACE_BEFORE_TAB test and conversion.

Reported-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 19376b4..db72b88 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2118,8 +2118,10 @@ sub process {
 			if (WARN("SPACE_BEFORE_TAB",
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
-				    s/(^\+.*) +\t/$1\t/;
+				while ($fixed[$linenr - 1] =~
+					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
+				while ($fixed[$linenr - 1] =~
+					   s/(^\+.*) +\t/$1\t/) {}
 			}
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

