Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966160AbaLLKv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:51:57 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:37166 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966055AbaLLKvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:51:49 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Joe Perches <joe@perches.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] checkpatch: Check for use of disallowed macros
Date: Fri, 12 Dec 2014 11:51:26 +0100
Message-Id: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since fe7c36c7 ("Makefile: Build with -Werror=date-time if the
compiler supports it"), use of __DATE__, __TIME__, __TIMESTAMP__ has
been disallowed. This hasn't prevented a few new users from creeping
in. Make checkpatch complain.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d60c07b..7fafd3b45539 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3008,6 +3008,12 @@ sub process {
 		$line =~ s@//.*@@;
 		$opline =~ s@//.*@@;
 
+
+# Use of __DATE__, __TIME__, __TIMESTAMP__ is not allowed
+		if ($line =~ m/\b__(?:DATE|TIME|TIMESTAMP)__\b/) {
+		    ERROR("DATETIME", "Do not use the macros __DATE__, __TIME__ and __TIMESTAMP__\n" . $herecurr)
+		}
+
 # EXPORT_SYMBOL should immediately follow the thing it is exporting, consider
 # the whole statement.
 #print "APW <$lines[$realline_next - 1]>\n";
-- 
2.1.3

