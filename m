Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3CPVam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 17:30:42 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55488 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab3CPVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 17:30:40 -0400
Message-ID: <1363469435.1335.137.camel@x61.thuisdomein>
Subject: [PATCH] checkpatch: stop checking for CONFIG_EXPERIMENTAL
From: Paul Bolle <pebolle@tiscali.nl>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Mar 2013 22:30:35 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2013 21:30:35.0774 (UTC) FILETIME=[7F0EE9E0:01CE228D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EXPERIMENTAL has been removed from the tree, in commit
3d374d09f16f64ab4d71704cbe621514d36cd0b1 ("final removal of
CONFIG_EXPERIMENTAL"). There's no need to test for it in checkpatch
anymore. If it ever pops up again it can be caught when someone feels
like cleaning up invalid Kconfig symbols and macros again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Checkpatch tested!

1) A lot of defconfigs still have CONFIG_EXPERIMENTAL in them. How
should that be cleaned up?

 scripts/checkpatch.pl | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..de8b1ff 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1745,13 +1745,6 @@ sub process {
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
-# discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
-		if ($realfile =~ /Kconfig/ &&
-		    $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {
-			WARN("CONFIG_EXPERIMENTAL",
-			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
-		}
-
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
 		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
 			my $flag = $1;
@@ -1907,12 +1900,6 @@ sub process {
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
-# discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
-		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
-			WARN("CONFIG_EXPERIMENTAL",
-			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
-		}
-
 # check for RCS/CVS revision markers
 		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
 			WARN("CVS_KEYWORD",
-- 
1.7.11.7

