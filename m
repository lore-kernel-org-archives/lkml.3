Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaIILEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:04:20 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:55544 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340AbaIILER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:04:17 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: simplify build, clean, modbuiltin shorthands
Date: Tue,  9 Sep 2014 20:03:58 +0900
Message-Id: <1410260638-23559-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$(if $(KBUILD_SRC),$(srctree)/) was a useful strategy
to omit a long absolute path for in-source-tree build
prior to commit 890676c65d699db3ad82e7dddd0cf8fb449031af
(kbuild: Use relative path when building in the source tree).

Now $(srctree) is "." when building in the source tree.
It would not be annoying to add "$(srctree)/" all the time.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Makefile               | 2 +-
 scripts/Kbuild.include | 4 ++--
 scripts/Makefile.clean | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 1a60bdd..f7b9174 100644
--- a/Makefile
+++ b/Makefile
@@ -1574,7 +1574,7 @@ endif
 # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.clean obj=dir
 # Usage:
 # $(Q)$(MAKE) $(clean)=dir
-clean := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.clean obj
+clean := -f $(srctree)/scripts/Makefile.clean obj
 
 endif	# skip-makefile
 
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 8a9a4e1..65e7b08 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -171,13 +171,13 @@ ld-ifversion = $(shell [ $(call ld-version) $(1) $(2) ] && echo $(3))
 # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.build obj=
 # Usage:
 # $(Q)$(MAKE) $(build)=dir
-build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
+build := -f $(srctree)/scripts/Makefile.build obj
 
 ###
 # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.modbuiltin obj=
 # Usage:
 # $(Q)$(MAKE) $(modbuiltin)=dir
-modbuiltin := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.modbuiltin obj
+modbuiltin := -f $(srctree)/scripts/Makefile.modbuiltin obj
 
 # Prefix -I with $(srctree) if it is not an absolute path.
 # skip if -I has no parameter
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index c630ab5..b1c668d 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -10,7 +10,7 @@ __clean:
 # Shorthand for $(Q)$(MAKE) scripts/Makefile.clean obj=dir
 # Usage:
 # $(Q)$(MAKE) $(clean)=dir
-clean := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.clean obj
+clean := -f $(srctree)/scripts/Makefile.clean obj
 
 # The filename Kbuild has precedence over Makefile
 kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
-- 
1.9.1

