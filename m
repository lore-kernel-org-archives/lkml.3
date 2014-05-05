Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaEEUMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:12:22 -0400
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:38336 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754405AbaEEUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:12:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3871:4605:5007:7652:10004:10128:10400:10848:11026:11658:11914:12043:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ball69_6b61783b17f48
X-Filterd-Recvd-Size: 3227
Message-ID: <1399320736.26330.8.camel@joe-AO725>
Subject: [PATCH] checkpatch: Improve missing blank line after declarations
 test
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Seunghun Lee <waydi1@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 05 May 2014 13:12:16 -0700
In-Reply-To: <1399319468.26330.2.camel@joe-AO725>
References: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
	 <20140429173221.GE26890@mwanda> <20140503234326.GA30117@kroah.com>
	 <20140505095935.GO26890@mwanda> <1399319468.26330.2.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more modifications to the declarations tests.

o Declarations can also be bitfields so exclude things with a colon
o Make sure the current and previous lines are indented the same
  to avoid matching some macro where a struct type is passed on
  the previous line like:

		next = list_entry(buffer->entry.next,
				  struct binder_buffer, entry);
		if (buffer_start_page(next) == buffer_end_page(buffer)) 

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 89f44f1..f2ef63a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2275,7 +2275,7 @@ sub process {
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
-		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
+		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2287,7 +2287,7 @@ sub process {
 			# not starting a section or a macro "\" extended line
 		      $prevline =~ /(?:\{\s*|\\)$/) &&
 			# looks like a declaration
-		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
+		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2299,7 +2299,9 @@ sub process {
 			# bitfield continuation
 		      $sline =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||
 			# other possible extensions of declaration lines
-		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
+		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/) &&
+			# indentation of previous and current line are the same
+		    (($prevline =~ /\+(\s+)\S/) && $sline =~ /^\+$1\S/)) {
 			WARN("SPACING",
 			     "Missing a blank line after declarations\n" . $hereprev);
 		}


