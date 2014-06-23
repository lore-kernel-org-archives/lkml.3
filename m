Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbaFWQgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:36:01 -0400
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:60949 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756440AbaFWQgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:36:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3868:4321:4605:5007:6261:10004:10026:10848:11657:11658:11914:12043:12517:12519:12555:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: debt97_34235e0f8a919
X-Filterd-Recvd-Size: 2173
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <jdelvare@suse.de>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] checkpatch: Add test for blank lines after function/struct/union/enum
Date: Mon, 23 Jun 2014 09:35:52 -0700
Message-Id: <1ff1bd5d51b309aa44c4cdc1f9ab253791e4818f.1403541113.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403541113.git.joe@perches.com>
References: <cover.1403541113.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a --strict test asking for a blank line after
function/struct/union/enum declarations.

Allow exceptions for several attributes and macro uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 538105a..4bb4218 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2291,6 +2291,21 @@ sub process {
 			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
 
+# check for missing blank lines after struct/union declarations
+# with exceptions for various attributes and macros
+		if ($prevline =~ /^[\+ ]};?\s*$/ &&
+		    !($line =~ /^\+\s*$/ ||
+		      $line =~ /^\+\s*EXPORT_SYMBOL/ ||
+		      $line =~ /^\+\s*MODULE_/i ||
+		      $line =~ /^\+\s*\#\s*(?:end|elif|else)/ ||
+		      $line =~ /^\+[a-z_]*init/ ||
+		      $line =~ /^\+\s*(?:static\s+)?[A-Z_]*ATTR/ ||
+		      $line =~ /^\+\s*DECLARE/ ||
+		      $line =~ /^\+\s*__setup/)) {
+			CHK("LINE_SPACING",
+			    "Please use a blank line after function/struct/union/enum declarations\n" . $hereprev);
+		}
+
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
-- 
1.8.1.2.459.gbcd45b4.dirty

