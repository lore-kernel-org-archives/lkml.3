Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaFYXlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:41:01 -0400
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:39103 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932143AbaFYXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:41:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3868:3871:4605:5007:7652:7903:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12555:13019:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: able77_5fd58587edd2f
X-Filterd-Recvd-Size: 2602
Message-ID: <1403739657.24788.20.camel@joe-AO725>
Subject: [PATCH V2] checkpatch: Add test for blank lines after
 function/struct/union/enum declarations
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 16:40:57 -0700
In-Reply-To: <20140625123523.b00c71c3a3f0a9129f9e6f3d@linux-foundation.org>
References: <cover.1403530604.git.joe@perches.com>
	 <c7cdaa8e080157cdabb92278a4c3beba89b49070.1403530604.git.joe@perches.com>
	 <1403546524.12008.2.camel@Lunix2.home>
	 <1403550950.15811.15.camel@joe-AO725> <1403557507.20657.3.camel@joe-AO725>
	 <1403559395.20657.8.camel@joe-AO725>
	 <20140625123523.b00c71c3a3f0a9129f9e6f3d@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a --strict test asking for a blank line after
function/struct/union/enum declarations.

Allow exceptions for several attributes and macro uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
V2: Fix a problem with patch context lines by checking
    the line after the closing brace is an insertion.

 scripts/checkpatch.pl | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 538105a..d56ad2a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2291,6 +2291,22 @@ sub process {
 			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
 
+# check for missing blank lines after struct/union declarations
+# with exceptions for various attributes and macros
+		if ($prevline =~ /^[\+ ]};?\s*$/ &&
+		    $line =~ /^\+/ &&
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



