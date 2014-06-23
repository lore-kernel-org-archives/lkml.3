Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaFWQgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:36:11 -0400
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:44543 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756481AbaFWQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:36:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3653:3865:3867:3871:3872:3874:4321:5007:6119:6261:10004:10026:10848:11658:11914:12043:12517:12519:12555:13095:13221:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pot32_3527139e04428
X-Filterd-Recvd-Size: 2197
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <jdelvare@suse.de>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] checkpatch: Quiet Kconfig help message checking
Date: Mon, 23 Jun 2014 09:35:55 -0700
Message-Id: <392be9dcded6077046f022c47611ad13a387531e.1403541113.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403541113.git.joe@perches.com>
References: <cover.1403541113.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Editing Kconfig dependencies can emit unnecessary messages about
missing or too short help entries.

Only emit the message when adding help sections to Kconfig files.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Jean Delvare <jdelvare@suse.de>
Tested-by: Jean Delvare <jdelvare@suse.de>
---
 scripts/checkpatch.pl | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9795844..2a7a32c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2051,7 +2051,7 @@ sub process {
 # Only applies when adding the entry originally, after that we do not have
 # sufficient context to determine whether it is indeed long enough.
 		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /.\s*config\s+/) {
+		    $line =~ /^\+\s*config\s+/) {
 			my $length = 0;
 			my $cnt = $realcnt;
 			my $ln = $linenr + 1;
@@ -2064,10 +2064,11 @@ sub process {
 				$is_end = $lines[$ln - 1] =~ /^\+/;
 
 				next if ($f =~ /^-/);
+				last if (!$file && $f =~ /^\@\@/);
 
-				if ($lines[$ln - 1] =~ /.\s*(?:bool|tristate)\s*\"/) {
+				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate)\s*\"/) {
 					$is_start = 1;
-				} elsif ($lines[$ln - 1] =~ /.\s*(?:---)?help(?:---)?$/) {
+				} elsif ($lines[$ln - 1] =~ /^\+\s*(?:---)?help(?:---)?$/) {
 					$length = -1;
 				}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

