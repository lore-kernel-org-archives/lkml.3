Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3BFWDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:03:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37239 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab3BFWDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:03:20 -0500
Date: Wed, 6 Feb 2013 14:02:24 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-2209001fd895e8932ae2c85bfca233758234499a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1359979554-9160-1-git-send-email-bp@alien8.de>
References: <1359979554-9160-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Check for flex and bison before continuing building
Git-Commit-ID: 2209001fd895e8932ae2c85bfca233758234499a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:02:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2209001fd895e8932ae2c85bfca233758234499a
Gitweb:     http://git.kernel.org/tip/2209001fd895e8932ae2c85bfca233758234499a
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 4 Feb 2013 13:05:54 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:25 -0300

perf tools: Check for flex and bison before continuing building

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
 
