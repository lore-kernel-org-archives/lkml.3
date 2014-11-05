Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaKEDTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:19:08 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40508 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaKEDTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:19:03 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 04/13] backports: replace BACKPORT_PWD with BACKPORT_DIR
Date: Tue,  4 Nov 2014 19:18:28 -0800
Message-Id: <1415157517-15442-5-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This will also be used for built-in kernel integration, by
using this we can share more code with the built-in kernel
approach.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Makefile             | 6 +++---
 backport/Makefile.build       | 4 ++--
 backport/Makefile.real        | 2 +-
 backport/scripts/uninstall.sh | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/backport/Makefile b/backport/Makefile
index ea3982b..fcf2f01 100644
--- a/backport/Makefile
+++ b/backport/Makefile
@@ -6,7 +6,7 @@ ifeq ($(KERNELRELEASE),)
 
 MAKEFLAGS += --no-print-directory
 SHELL := /bin/bash
-BACKPORT_PWD := $(shell pwd)
+BACKPORT_DIR := $(shell pwd)
 
 KMODDIR ?= updates
 ifneq ($(origin KLIB), undefined)
@@ -20,7 +20,7 @@ KERNEL_CONFIG := $(KLIB_BUILD)/.config
 KERNEL_MAKEFILE := $(KLIB_BUILD)/Makefile
 CONFIG_MD5 := $(shell md5sum $(KERNEL_CONFIG) 2>/dev/null | sed 's/\s.*//')
 
-export KLIB KLIB_BUILD BACKPORT_PWD KMODDIR KMODPATH_ARG
+export KLIB KLIB_BUILD BACKPORT_DIR KMODDIR KMODPATH_ARG
 
 # disable built-in rules for this file
 .SUFFIXES:
@@ -159,5 +159,5 @@ help: defconfig-help
 	@echo ""
 	@echo "Execute "make" or "make all" to build all targets marked with [*]"
 else
-include $(BACKPORT_PWD)/Makefile.kernel
+include $(BACKPORT_DIR)/Makefile.kernel
 endif
diff --git a/backport/Makefile.build b/backport/Makefile.build
index d209041..a848b37 100644
--- a/backport/Makefile.build
+++ b/backport/Makefile.build
@@ -3,8 +3,8 @@ export
 
 .PHONY: modules
 modules:
-	@$(MAKE) -C $(KLIB_BUILD) M=$(BACKPORT_PWD) modules
+	@$(MAKE) -C $(KLIB_BUILD) M=$(BACKPORT_DIR) modules
 
 .PHONY: clean
 clean:
-	@$(MAKE) -C $(KLIB_BUILD) M=$(BACKPORT_PWD) clean
+	@$(MAKE) -C $(KLIB_BUILD) M=$(BACKPORT_DIR) clean
diff --git a/backport/Makefile.real b/backport/Makefile.real
index f60d5ca..a0f4916 100644
--- a/backport/Makefile.real
+++ b/backport/Makefile.real
@@ -89,7 +89,7 @@ modules: backport-include/backport/autoconf.h
 
 .PHONY: install
 install: modules
-	@$(MAKE) -C $(KLIB_BUILD) M=$(BACKPORT_PWD)			\
+	@$(MAKE) -C $(KLIB_BUILD) M=$(BACKPORT_DIR)			\
 		INSTALL_MOD_DIR=$(KMODDIR) $(KMODPATH_ARG)		\
 		modules_install
 	@./scripts/blacklist.sh $(KLIB)/ $(KLIB)/$(KMODDIR)
diff --git a/backport/scripts/uninstall.sh b/backport/scripts/uninstall.sh
index 1eb42b0..b46d3fe 100755
--- a/backport/scripts/uninstall.sh
+++ b/backport/scripts/uninstall.sh
@@ -10,8 +10,8 @@ else
 	compr=""
 fi
 
-for driver in $(find ${BACKPORT_PWD} -type f -name *.ko); do
-	mod_name=${driver/${BACKPORT_PWD}/${KLIB}${KMODDIR}}${compr}
+for driver in $(find ${BACKPORT_DIR} -type f -name *.ko); do
+	mod_name=${driver/${BACKPORT_DIR}/${KLIB}${KMODDIR}}${compr}
 	echo "  uninstall" $mod_name
 	rm -f $mod_name
 done
-- 
2.1.1

