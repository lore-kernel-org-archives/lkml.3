Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3LZTVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:21:34 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:43072 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753833Ab3LZTUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:20:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2689:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3868:3871:3872:4321:4605:5007:6261:7903:8957:9040:9121:10004:10026:10848:11026:11233:11658:11914:12043:12438:12517:12519:12555:13153:13228,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lock53_5ca266169b747
X-Filterd-Recvd-Size: 2919
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] checkpatch: Add a --fix-inplace option
Date: Thu, 26 Dec 2013 11:20:29 -0800
Message-Id: <f15570aa85918df5942aac86ad80df19e1d743c5.1388085015.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1388085015.git.joe@perches.com>
References: <cover.1388085015.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to fix and overwrite existing files/patches instead
of creating a new file "<filename>.EXPERIMENTAL-checkpatch-fixes".

Suggested-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f5d4560..19376b4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -29,6 +29,7 @@ my $mailback = 0;
 my $summary_file = 0;
 my $show_types = 0;
 my $fix = 0;
+my $fix_inplace = 0;
 my $root;
 my %debug;
 my %camelcase = ();
@@ -76,6 +77,9 @@ Options:
                              "<inputfile>.EXPERIMENTAL-checkpatch-fixes"
                              with potential errors corrected to the preferred
                              checkpatch style
+  --fix-inplace              EXPERIMENTAL - may create horrible results
+                             Is the same as --fix, but overwrites the input
+                             file.  It's your fault if there's no backup or git
   --ignore-perl-version      override checking of perl version.  expect
                              runtime errors.
   -h, --help, --version      display this help and exit
@@ -131,6 +135,7 @@ GetOptions(
 	'mailback!'	=> \$mailback,
 	'summary-file!'	=> \$summary_file,
 	'fix!'		=> \$fix,
+	'fix-inplace!'	=> \$fix_inplace,
 	'ignore-perl-version!' => \$ignore_perl_version,
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
@@ -140,6 +145,8 @@ GetOptions(
 
 help(0) if ($help);
 
+$fix = 1 if ($fix_inplace);
+
 my $exit = 0;
 
 if ($^V && $^V lt $minimum_perl_version) {
@@ -4456,7 +4463,8 @@ sub process {
 	hash_show_words(\%ignore_type, "Ignored");
 
 	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
-		my $newfile = $filename . ".EXPERIMENTAL-checkpatch-fixes";
+		my $newfile = $filename;
+		$newfile .= ".EXPERIMENTAL-checkpatch-fixes" if (!$fix_inplace);
 		my $linecount = 0;
 		my $f;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

