Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaBZTiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:38:54 -0500
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:36597 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754290AbaBZTiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:38:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:2914:3138:3139:3140:3141:3142:3353:3653:3865:3866:3870:5007:6119:6261:7903:10004:10026:10848:11658:11914:12291:12296:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kitty62_4d2d0c473e43e
X-Filterd-Recvd-Size: 2661
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] checkpatch: Use a more consistent function argument style
Date: Wed, 26 Feb 2014 11:38:48 -0800
Message-Id: <21756c833a9c8aef5577bbf6dcadbfbbc82c0d4b.1393443451.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of array indexing $_, use temporary variables like
all the other subroutines in the script use.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 91308be..ae9f71d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1431,21 +1431,25 @@ sub possible {
 my $prefix = '';
 
 sub show_type {
-	return defined $use_type{$_[0]} if (scalar keys %use_type > 0);
+	my ($type) = @_;
 
-	return !defined $ignore_type{$_[0]};
+	return defined $use_type{$type} if (scalar keys %use_type > 0);
+
+	return !defined $ignore_type{$type};
 }
 
 sub report {
-	if (!show_type($_[1]) ||
-	    (defined $tst_only && $_[2] !~ /\Q$tst_only\E/)) {
+	my ($level, $type, $msg) = @_;
+
+	if (!show_type($type) ||
+	    (defined $tst_only && $msg !~ /\Q$tst_only\E/)) {
 		return 0;
 	}
 	my $line;
 	if ($show_types) {
-		$line = "$prefix$_[0]:$_[1]: $_[2]\n";
+		$line = "$prefix$level:$type: $msg\n";
 	} else {
-		$line = "$prefix$_[0]: $_[2]\n";
+		$line = "$prefix$level: $msg\n";
 	}
 	$line = (split('\n', $line))[0] . "\n" if ($terse);
 
@@ -1453,12 +1457,15 @@ sub report {
 
 	return 1;
 }
+
 sub report_dump {
 	our @report;
 }
 
 sub ERROR {
-	if (report("ERROR", $_[0], $_[1])) {
+	my ($type, $msg) = @_;
+
+	if (report("ERROR", $type, $msg)) {
 		our $clean = 0;
 		our $cnt_error++;
 		return 1;
@@ -1466,7 +1473,9 @@ sub ERROR {
 	return 0;
 }
 sub WARN {
-	if (report("WARNING", $_[0], $_[1])) {
+	my ($type, $msg) = @_;
+
+	if (report("WARNING", $type, $msg)) {
 		our $clean = 0;
 		our $cnt_warn++;
 		return 1;
@@ -1474,7 +1483,9 @@ sub WARN {
 	return 0;
 }
 sub CHK {
-	if ($check && report("CHECK", $_[0], $_[1])) {
+	my ($type, $msg) = @_;
+
+	if ($check && report("CHECK", $type, $msg)) {
 		our $clean = 0;
 		our $cnt_chk++;
 		return 1;
-- 
1.8.1.2.459.gbcd45b4.dirty

