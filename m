Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3ELQRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:17:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37485 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754098Ab3ELQRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:17:52 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] checkpatch: Change CamelCase test and make it --strict
Date: Sun, 12 May 2013 09:17:48 -0700
Message-Id: <a8ee80e0453181086992b11d34de77fb06609fe5.1368375304.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not bleat a message on nominally acceptable
CamelCase uses that are separated by an _ like
drm_core_has_MTRR.

CamelCase tests are also a bit noisy against certain
types of code acceptable to some kernel developers.

Make the test applicable only with --strict.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..f1aad19 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2938,12 +2938,12 @@ sub process {
 		while ($line =~ m{($Constant|$Lval)}g) {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
-			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
+			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
 			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
-				WARN("CAMELCASE",
-				     "Avoid CamelCase: <$var>\n" . $herecurr);
+				CHK("CAMELCASE",
+				    "Avoid CamelCase: <$var>\n" . $herecurr);
 			}
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

