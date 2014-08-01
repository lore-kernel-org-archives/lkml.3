Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaHAEIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 00:08:32 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47621 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHAEIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 00:08:30 -0400
From: behanw@converseincode.com
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, Behan Webster <behanw@converseincode.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>, bp@alien8.de
Subject: [PATCH v3] kbuild, LLVMLinux: Supress warnings unless W=1-3
Date: Thu, 31 Jul 2014 21:08:25 -0700
Message-Id: <1406866105-24980-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <53DAAB35.8080206@suse.cz>
References: <53DAAB35.8080206@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

clang has more warnings enabled by default. Turn them off unless W is set.
This patch fixes a logic bug where warnings in clang were disabled when W was set.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Cc: mmarek@suse.cz
Cc: bp@alien8.de
---
 Makefile                   |  1 +
 scripts/Makefile.extrawarn | 22 ++++++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index f6a7794..f343e17 100644
--- a/Makefile
+++ b/Makefile
@@ -668,6 +668,7 @@ KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
 # source of a reference will be _MergedGlobals and not on of the whitelisted names.
 # See modpost pattern 2
 KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
+KBUILD_CFLAGS += $(call cc-option, -fcatch-undefined-behavior)
 else
 
 # This warning generated too much noise in a regular build.
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 6564350..4315d34 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -26,16 +26,6 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
 
-# Clang
-warning-1 += $(call cc-disable-warning, initializer-overrides)
-warning-1 += $(call cc-disable-warning, unused-value)
-warning-1 += $(call cc-disable-warning, format)
-warning-1 += $(call cc-disable-warning, unknown-warning-option)
-warning-1 += $(call cc-disable-warning, sign-compare)
-warning-1 += $(call cc-disable-warning, format-zero-length)
-warning-1 += $(call cc-disable-warning, uninitialized)
-warning-1 += $(call cc-option, -fcatch-undefined-behavior)
-
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
 warning-2 += -Wdisabled-optimization
@@ -64,4 +54,16 @@ ifeq ("$(strip $(warning))","")
 endif
 
 KBUILD_CFLAGS += $(warning)
+else
+
+ifeq ($(COMPILER),clang)
+KBUILD_CFLAGS += $(call cc-disable-warning, initializer-overrides)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-value)
+KBUILD_CFLAGS += $(call cc-disable-warning, format)
+KBUILD_CFLAGS += $(call cc-disable-warning, unknown-warning-option)
+KBUILD_CFLAGS += $(call cc-disable-warning, sign-compare)
+KBUILD_CFLAGS += $(call cc-disable-warning, format-zero-length)
+KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
 endif
+endif
+
-- 
1.9.1

