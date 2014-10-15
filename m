Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaJOTc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:32:27 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:52565 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751020AbaJOTcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:32:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2902:3138:3139:3140:3141:3142:3351:3876:3877:4321:4605:5007:6114:6261:6642:10004:10848:11658:11914:12043:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: park70_4eb4a1b2c8109
X-Filterd-Recvd-Size: 1567
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] checkpatch: Add error on use of attribute((weak)) or __weak
Date: Wed, 15 Oct 2014 12:32:08 -0700
Message-Id: <4391d882bb26278110d07b9a5e23ec44f5f8328a.1413400022.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2.443.g670a3c1
In-Reply-To: <cover.1413400022.git.joe@perches.com>
References: <cover.1413400022.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using weak can have unintended link defects.
Emit an error on its use.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 696254e..692fdb6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4671,6 +4671,14 @@ sub process {
 			}
 		}
 
+# Check for __attribute__ weak, or __weak (may have link issues)
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    ($line =~ /\b__attribute__\s*\(\s*\(.*\bweak\b/ ||
+		     $line =~ \b__weak\b/)) {
+			ERROR("AVOID_WEAK",
+			      "Using weak can have unintended link defects" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",
-- 
2.1.0

