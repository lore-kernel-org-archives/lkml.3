Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaHLQhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:37:07 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:49013 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752834AbaHLQhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:37:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:3870:3871:3874:4321:5007:6120:7522:7652:8531:10004:10400:10848:11026:11473:11658:11914:12043:12517:12519:12555:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smell12_3d9612486742a
X-Filterd-Recvd-Size: 1989
Message-ID: <1407861421.3141.21.camel@joe-AO725>
Subject: [RFC PATCH] checkpatch: Warn on patch subjects with "checkpatch"
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@linuxfoundation.org, swetland@google.com, ccross@android.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Phong Tran <tranmanphong@gmail.com>
Date: Tue, 12 Aug 2014 09:37:01 -0700
In-Reply-To: <1407860250-9779-2-git-send-email-tranmanphong@gmail.com>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
	 <1407860250-9779-2-git-send-email-tranmanphong@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think patch subject lines with "checkpatch" in
them are almost never really useful.

Maybe a new checkpatch test to see if a subject line
is perhaps less than informational should be added.

Something like:
---
 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 31a731e..a690515 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2048,6 +2048,13 @@ sub process {
 			$in_commit_log = 0;
 		}
 
+# Check patch subject lines for "checkpatch" (but not checkpatch:)
+		if ($in_header_lines &&
+		    $line =~ /^\s*subject:.*\bcheckpatch(?!(?:\.pl)?:)\b/i) {
+			WARN("BAD_PATCH_SUBJECT",
+			     "Patch subjects with 'checkpatch' are not generally useful.  Describe the change, not the tool that suggests the change.\n" . $herecurr);
+		}
+
 # Check signature styles
 		if (!$in_header_lines &&
 		    $line =~ /^(\s*)([a-z0-9_-]+by:|$signature_tags)(\s*)(.*)/i) {


