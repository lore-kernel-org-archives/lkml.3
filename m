Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaBZTjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:39:06 -0500
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:47146 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754295AbaBZTix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:38:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3872:4321:5007:6261:10004:10026:10848:11026:11473:11657:11658:11914:12043:12438:12517:12519:12555:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hair97_4d69c1df1df42
X-Filterd-Recvd-Size: 1791
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] checkpatch: Ignore networking block comment style first lines in file
Date: Wed, 26 Feb 2014 11:38:49 -0800
Message-Id: <3da3ed6658e3cd7dd2a36674d921ef9044ae0c3c.1393443451.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <21756c833a9c8aef5577bbf6dcadbfbbc82c0d4b.1393443451.git.joe@perches.com>
References: <21756c833a9c8aef5577bbf6dcadbfbbc82c0d4b.1393443451.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's very common to have normal block comments for the initial
comments of a file description preface.

So for files in drivers/net and net/ don't emit a warning when
the first comment block in the file uses the normal block comment
style and not the networking block comment style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ae9f71d..c624b04 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2219,7 +2219,8 @@ sub process {
 
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
-		    $rawline =~ /^\+[ \t]*\*/) {
+		    $rawline =~ /^\+[ \t]*\*/ &&
+		    $realline > 2) {
 			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
 			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

