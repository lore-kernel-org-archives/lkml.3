Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3LZTUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:20:46 -0500
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:50893 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753900Ab3LZTUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:20:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:966:973:982:988:989:1042:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3868:3870:3871:3872:3873:4250:4321:4385:5007:6119:6120:6261:7903:10004:10026:10848:11026:11473:11658:11914:12043:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bikes37_5d5c1be2f6b50
X-Filterd-Recvd-Size: 2731
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] checkpatch: Update the FSF/GPL address check
Date: Thu, 26 Dec 2013 11:20:32 -0800
Message-Id: <cffb44ce7acd55b7bf0f59b07d934e0ae6be6fef.1388085015.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1388085015.git.joe@perches.com>
References: <cover.1388085015.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSF address check is a bit too verbose looking for the GPL text.
Quiet it a bit by requiring --strict for the GPL bit.

Also make the address tests match a few uses of abbreviations
for street names and make it case insensitive.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/checkpatch.pl | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c12234e..abd1811 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1970,15 +1970,16 @@ sub process {
 		}
 
 # Check for FSF mailing addresses.
-		if ($rawline =~ /You should have received a copy/ ||
-		    $rawline =~ /write to the Free Software/ ||
-		    $rawline =~ /59 Temple Place/ ||
-		    $rawline =~ /51 Franklin Street/) {
+		if ($rawline =~ /\bYou should have received a copy/i ||
+		    $rawline =~ /\bwrite to the Free/i ||
+		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
+		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			my $msg_type = \&ERROR;
 			$msg_type = \&CHK if ($file);
+			$msg_type = \&CHK if ($rawline =~ /\bYou should have received a copy/i);
 			&{$msg_type}("FSF_MAILING_ADDRESS",
-				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}
 
 # check for Kconfig help text having a real description
-- 
1.8.1.2.459.gbcd45b4.dirty

