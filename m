Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaKHASO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:18:14 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62931 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaKHASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:18:13 -0500
From: Julius Werner <jwerner@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Julius Werner <jwerner@chromium.org>
Subject: [PATCH] checkpatch: Make SI unit tolerance more lenient with 3-character units
Date: Fri,  7 Nov 2014 16:18:00 -0800
Message-Id: <1415405880-8520-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch flags CamelCase identifiers in strict mode, but it has a
feature to ignore parts with only two characters to allow for SI units
like mV or uA. Unfortunately, not all SI units fit in two characters,
and not all are lower case followed by upper case.

This patch changes the check from [a-z][A-Z] to [a-zA-Z]{1,3} (any
combination of up to three lower and upper case characters), so that it
will also allow units like MHz, As or KiB.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 374abf4..0bbd25a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4055,8 +4055,8 @@ sub process {
 			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
 #Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
-#Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
-			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
+#Ignore SI style variants like nS, mV, MHz and dB (ie: max_uV, regulator_min_uA_show)
+			    $var !~ /^(?:[a-z_]*?)_?[a-zA-Z]{1,3}(?:_[a-z_]+)?$/) {
 				while ($var =~ m{($Ident)}g) {
 					my $word = $1;
 					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
-- 
1.8.3.2

