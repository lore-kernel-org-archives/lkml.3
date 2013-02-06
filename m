Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab3BFVoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:44:30 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33162
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758694Ab3BFVo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:44:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/17] perf tools: Check for flex and bison before continuing building
Date: Wed,  6 Feb 2013 18:44:06 -0300
Message-Id: <1360187059-12661-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360187059-12661-1-git-send-email-acme@infradead.org>
References: <1360187059-12661-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Check whether both executables are present on the system before
continuing with the build instead of failing halfway, if either are
missing.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1359979554-9160-1-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4b1044c..a158309 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -149,6 +149,8 @@ RM = rm -f
 MKDIR = mkdir
 FIND = find
 INSTALL = install
+FLEX = flex
+BISON= bison
 
 # sparse is architecture-neutral, which means that we need to tell it
 # explicitly what architecture to check for. Fix this up for yours..
@@ -158,6 +160,14 @@ ifneq ($(MAKECMDGOALS),clean)
 ifneq ($(MAKECMDGOALS),tags)
 -include config/feature-tests.mak
 
+ifeq ($(call get-executable,$(FLEX)),)
+	dummy := $(error Error: $(FLEX) is missing on this system, please install it)
+endif
+
+ifeq ($(call get-executable,$(BISON)),)
+	dummy := $(error Error: $(BISON) is missing on this system, please install it)
+endif
+
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
@@ -282,9 +292,6 @@ endif
 
 export PERL_PATH
 
-FLEX = flex
-BISON= bison
-
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
-- 
1.8.1.1.361.gec3ae6e

