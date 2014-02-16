Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaBPV5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 16:57:35 -0500
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:37399 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752922AbaBPV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 16:57:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1437:1534:1540:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3653:3876:3877:4321:4605:5007:6114:6261:6642:10004:10026:10848:11026:11473:11657:11658:11914:12043:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: farm24_7baa313954104
X-Filterd-Recvd-Size: 1518
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] checkpatch: Update octal permissions warning
Date: Sun, 16 Feb 2014 13:57:26 -0800
Message-Id: <c5b2c9b85c9c955208c5d4ca10f257496315e389.1392587681.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking permissions, make sure 4 octal digits are used,
but allow a single 0 too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1054283..9f12213 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4512,9 +4512,11 @@ sub process {
 				my $val = $1;
 				$val = $6 if ($skip_args ne "");
 
-				if ($val =~ /^$Int$/ && $val !~ /^$Octal$/) {
+				if ($val !~ /^0$/ &&
+				    (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
+				     length($val) ne 4)) {
 					ERROR("NON_OCTAL_PERMISSIONS",
-					      "Use octal not decimal permissions\n" . $herecurr);
+					      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
 				}
 			}
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

