Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaHHPX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:23:29 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49535 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaHHPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:23:25 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/4] Documentation: kbuild: Improve if_changed documentation
Date: Fri,  8 Aug 2014 17:23:08 +0200
Message-Id: <1407511390-5429-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407511390-5429-1-git-send-email-geert@linux-m68k.org>
References: <1407511390-5429-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - These days if_changed is used with many more commands than ld,
    objcopy, and gzip, hence add an ellipsis,
  - Any target that utilises if_changed must be listed in $(targets),
    so it needs an assignment to "targets", not "target".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/kbuild/makefiles.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 3b416592cc44..1c6056f1b95f 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1115,7 +1115,7 @@ When kbuild executes, the following steps are followed (roughly):
 
 	Usage:
 		target: source(s) FORCE
-			$(call if_changed,ld/objcopy/gzip)
+			$(call if_changed,ld/objcopy/gzip/...)
 
 	When the rule is evaluated, it is checked to see if any files
 	need an update, or the command line has changed since the last
@@ -1133,7 +1133,7 @@ When kbuild executes, the following steps are followed (roughly):
 	significant; for instance, the below will fail (note the extra space
 	after the comma):
 		target: source(s) FORCE
-	#WRONG!#	$(call if_changed, ld/objcopy/gzip)
+	#WRONG!#	$(call if_changed, ld/objcopy/gzip/...)
 
     ld
 	Link target. Often, LDFLAGS_$@ is used to set specific options to ld.
@@ -1165,7 +1165,7 @@ When kbuild executes, the following steps are followed (roughly):
 
 	The ": %: %.o" part of the prerequisite is a shorthand that
 	free us from listing the setup.o and bootsect.o files.
-	Note: It is a common mistake to forget the "target :=" assignment,
+	Note: It is a common mistake to forget the "targets :=" assignment,
 	      resulting in the target file being recompiled for no
 	      obvious reason.
 
-- 
1.9.1

