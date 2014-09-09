Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaIIK0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:26:53 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:55816 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbaIIK0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:26:52 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kbuild: remove obj-n and lib-n handling
Date: Tue,  9 Sep 2014 19:26:21 +0900
Message-Id: <1410258381-7088-4-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig never defines CONFIG_* as 'n'.
Now obj-n is only used in firmware/Makefile and it can be
replaced with obj-.  No makefile uses lib-n.

Let's rip off obj-n and lib-n.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 firmware/Makefile       | 2 +-
 scripts/Makefile.build  | 4 ++--
 scripts/Makefile.clean  | 4 +---
 scripts/Makefile.fwinst | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/firmware/Makefile b/firmware/Makefile
index 0862d34..e297e1b 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -232,6 +232,6 @@ targets := $(fw-shipped-) $(patsubst $(obj)/%,%, \
 
 # Without this, built-in.o won't be created when it's empty, and the
 # final vmlinux link will fail.
-obj-n := dummy
+obj- := dummy
 
 hostprogs-y := ihex2fw
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5b09d36..649ce68 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -79,11 +79,11 @@ endif
 
 # ===========================================================================
 
-ifneq ($(strip $(lib-y) $(lib-m) $(lib-n) $(lib-)),)
+ifneq ($(strip $(lib-y) $(lib-m) $(lib-)),)
 lib-target := $(obj)/lib.a
 endif
 
-ifneq ($(strip $(obj-y) $(obj-m) $(obj-n) $(obj-) $(subdir-m) $(lib-target)),)
+ifneq ($(strip $(obj-y) $(obj-m) $(obj-) $(subdir-m) $(lib-target)),)
 builtin-target := $(obj)/built-in.o
 endif
 
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index a651cee..c630ab5 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -23,15 +23,13 @@ __subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
 subdir-y	+= $(__subdir-y)
 __subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
 subdir-m	+= $(__subdir-m)
-__subdir-n	:= $(patsubst %/,%,$(filter %/, $(obj-n)))
-subdir-n	+= $(__subdir-n)
 __subdir-	:= $(patsubst %/,%,$(filter %/, $(obj-)))
 subdir-		+= $(__subdir-)
 
 # Subdirectories we need to descend into
 
 subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
-subdir-ymn      := $(sort $(subdir-ym) $(subdir-n) $(subdir-))
+subdir-ymn      := $(sort $(subdir-ym) $(subdir-))
 
 # Add subdir path
 
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index d8e335e..5b698ad 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -2,7 +2,7 @@
 # Installing firmware
 #
 # We don't include the .config, so all firmware files are in $(fw-shipped-)
-# rather than in $(fw-shipped-y) or $(fw-shipped-n).
+# rather than in $(fw-shipped-y) or $(fw-shipped-m).
 # ==========================================================================
 
 INSTALL := install
-- 
1.9.1

