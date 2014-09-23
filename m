Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaIWT3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:29:01 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33205 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaIWT3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:29:00 -0400
From: behanw@converseincode.com
To: ak@linux.intel.com, mmarek@suse.cz, yamada.m@jp.panasonic.com
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, sam@ravnborg.org,
        Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] kbuild, LLVMLinux: Add -Werror to cc-option to support clang
Date: Tue, 23 Sep 2014 12:28:42 -0700
Message-Id: <1411500522-11480-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

Clang will warn about unknown warnings but will not return false
unless -Werror is set. GCC will return false if an unknown
warning is passed.

Adding -Werror make both compiler behave the same.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 scripts/Kbuild.include | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 8a9a4e1..e37ca5c 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -111,12 +111,12 @@ as-instr = $(call try-run,\
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) -Werror $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",y,n)
+	$(CC) -Werror $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
@@ -126,7 +126,7 @@ cc-option-align = $(subst -functions=0,,\
 # cc-disable-warning
 # Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
 cc-disable-warning = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
+	$(CC) -Werror $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
 
 # cc-version
 # Usage gcc-ver := $(call cc-version)
-- 
1.9.1

