Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbaHHPXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:23:33 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:44643 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaHHPXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:23:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/4] Documentation: kbuild: Remove obsolete dtc_cpp section
Date: Fri,  8 Aug 2014 17:23:09 +0200
Message-Id: <1407511390-5429-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407511390-5429-1-git-send-email-geert@linux-m68k.org>
References: <1407511390-5429-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b40b25fff8205dd18124d8fc87b2c9c57f269b5f ("kbuild: always
run gcc -E on *.dts, remove cmd_dtc_cpp") improved the functionality of
cmd_dtc_cpp and merged it back into cmd_dtc.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/kbuild/makefiles.txt | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 1c6056f1b95f..4275a719f45f 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1186,29 +1186,6 @@ When kbuild executes, the following steps are followed (roughly):
 		clean-files += *.dtb
 		DTC_FLAGS ?= -p 1024
 
-    dtc_cpp
-	This is just like dtc as describe above, except that the C pre-
-	processor is invoked upon the .dtsp file before compiling the result
-	with dtc.
-
-	In order for build dependencies to work, all files compiled using
-	dtc_cpp must use the C pre-processor's #include functionality and not
-	dtc's /include/ functionality.
-
-	Using the C pre-processor allows use of #define to create named
-	constants. In turn, the #defines will typically appear in a header
-	file, which may be shared with regular C code. Since the dtc language
-	represents a data structure rather than code in C syntax, similar
-	restrictions are placed on a header file included by a device tree
-	file as for a header file included by an assembly language file.
-	In particular, the C pre-processor is passed -x assembler-with-cpp,
-	which sets macro __ASSEMBLY__. __DTS__ is also set. These allow header
-	files to restrict their content to that compatible with device tree
-	source.
-
-	A central rule exists to create $(obj)/%.dtb from $(src)/%.dtsp;
-	architecture Makefiles do no need to explicitly write out that rule.
-
 --- 6.8 Custom kbuild commands
 
 	When kbuild is executing with KBUILD_VERBOSE=0, then only a shorthand
-- 
1.9.1

