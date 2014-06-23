Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbaFWQgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:36:07 -0400
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:52884 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756377AbaFWQgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:36:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3653:3876:3877:4321:5007:6114:6261:6642:10004:10026:10848:11026:11658:11914:12517:12519:12555:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: heat14_3461b5fd5cb1d
X-Filterd-Recvd-Size: 1933
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <jdelvare@suse.de>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] checkpatch: Add a multiple blank lines test
Date: Mon, 23 Jun 2014 09:35:53 -0700
Message-Id: <c069ba9c948d974761a0f50e63e0c364d66cfa9d.1403541113.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403541113.git.joe@perches.com>
References: <cover.1403541113.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple consecutive blank lines waste screen space.
Emit a --strict only message with these blank lines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4bb4218..3d6dea6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1642,6 +1642,8 @@ sub process {
 
 	my $non_utf8_charset = 0;
 
+	my $last_blank_line = 0;
+
 	our @report = ();
 	our $cnt_lines = 0;
 	our $cnt_error = 0;
@@ -2306,6 +2308,15 @@ sub process {
 			    "Please use a blank line after function/struct/union/enum declarations\n" . $hereprev);
 		}
 
+# check for multiple consecutive blank lines
+		if ($prevline =~ /^[\+ ]\s*$/ &&
+		    $line =~ /^\+\s*$/ &&
+		    $last_blank_line != ($linenr - 1)) {
+			CHK("LINE_SPACING",
+			    "Please don't use multiple blank lines\n" . $hereprev);
+			$last_blank_line = $linenr;
+		}
+
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
-- 
1.8.1.2.459.gbcd45b4.dirty

