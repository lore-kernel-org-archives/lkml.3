Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3KVWXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:23:32 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:49572 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3KVWXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:23:30 -0500
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: apw@canonical.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org, Elena Ufimtseva <ufimtseva@gmail.com>
Subject: [PATCH v2] checkpatch.pl: Check for functions without a real prototype
Date: Fri, 22 Nov 2013 17:17:44 -0500
Message-Id: <1385158664-12923-1-git-send-email-ufimtseva@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Richard Weinberger patch https://lkml.org/lkml/2012/3/16/510
Functions like this one are evil:

void foo()
{
	...
}

Signed-off-by: Elena Ufimtseva <ufimtseva@gmail.com>
---
Changes since v1:
- added white space in regular expression between (), based
on comments from Joe Perches.

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 61090e0..08c95c0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2785,6 +2785,19 @@ sub process {
 			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
+		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
+			ERROR("FUNCTION_NO_PROTOTYPE",
+"Bad function definition - $1() should probably be $1(void)\n" . $herecurr .
+"\nThou shalt not, in the language of C, under any circumstances, on the
+pain of death, declare or define a function with an empty set of
+parentheses, for though in the language of C++ it meaneth the same as
+(void), in C it meaneth (...) which is of meaningless as there be no
+anchor argument by which the types of the varadic arguments can be
+expressed, and which misleadeth the compiler into allowing unsavory code
+and in some cases generate really ugly stuff for varadic handling.
+							-hpa\n");
+		}
+
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
-- 
1.7.10.4

