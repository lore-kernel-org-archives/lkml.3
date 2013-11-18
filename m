Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3KRWkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:40:32 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3KRWka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:40:30 -0500
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Nov 2013 17:40:30 EST
From: Richard Weinberger <richard@nod.at>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, joe@perches.com,
        bp@alien8.de, Richard Weinberger <richard@nod.at>
Subject: [PATCH] checkpatch.pl: Check for functions without a real prototype
Date: Mon, 18 Nov 2013 23:31:54 +0100
Message-Id: <1384813914-11491-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions like this one are evil:

void foo()
{
	...
}

Signed-off-by: Richard Weinberger <richard@nod.at>
CC: hpa@zytor.com
---
 scripts/checkpatch.pl | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 61090e0..a1b846d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2785,6 +2785,19 @@ sub process {
 			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
+		if ($line=~/$Type\s*$Ident\(\)/) {
+			ERROR("FUNCTION_NO_PROTOTYPE",
+"Function without a real prototype\n" . $herecurr .
+"Thou shalt not, in the language of C, under any circumstances, on the
+pain of death, declare or define a function with an empty set of
+parentheses, for though in the language of C++ it meaneth the same as
+(void), in C it meaneth (...) which is of meaningless as there be no
+anchor argument by which the types of the varadic arguments can be
+expressed, and which misleadeth the compiler into allowing unsavory code
+and in some cases generate really ugly stuff for varadic handling.
+	-hpa\n");
+		}
+
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
-- 
1.8.4.2

