Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbaAFR4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:56:35 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52718 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaAFR4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:56:32 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd 1/1] Makefile: Use CPPFLAGS from the environment
Date: Mon,  6 Jan 2014 11:56:25 -0600
Message-Id: <1389030985-26657-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389030985-26657-1-git-send-email-seth.forshee@canonical.com>
References: <1389030985-26657-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPPFLAGS is commonly used for preprecessor definitions which
should be used when compiling C and C++ files. In particular,
Debian uses it to pass hardening flags and expects those flags
to be used.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index a2ba385..f097bbc 100644
--- a/Makefile
+++ b/Makefile
@@ -220,6 +220,7 @@ include features.mk
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
+CPPFLAGS ?=
 LDFLAGS ?=
 
 # Required CFLAGS
@@ -263,7 +264,7 @@ endif
 
 do_fpic_compile =					\
 	($(print_fpic_compile)				\
-	$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@)
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
 
 do_app_build =						\
 	($(print_app_build)				\
@@ -275,7 +276,7 @@ do_compile_shared_library =			\
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
-	$(CC) -c $(CFLAGS) -fPIC -o $@ $<)
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) -fPIC -o $@ $<)
 
 do_plugin_build =				\
 	($(print_plugin_build)			\
@@ -291,7 +292,7 @@ define check_gui
 		$(REBUILD_GUI);							\
 	else									\
 		$(print_compile)						\
-		$(CC) -c $(CFLAGS) $(EXT) $< -o $(obj)/$@;			\
+		$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $(obj)/$@;		\
 	fi;
 endef
 
@@ -449,10 +450,10 @@ define check_gui_deps
 		if [ $(BUILDGUI) -ne 1 ]; then			\
 			$(REBUILD_GUI);				\
 		else						\
-			$(CC) -M $(CFLAGS) $< > $@;		\
+			$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@;	\
 		fi						\
 	elif [ $(BUILDGUI) -eq 0 ]; then			\
-		$(CC) -M $(CFLAGS) $< > $@;			\
+		$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@;		\
 	else							\
 		echo SKIPPING $@;				\
 	fi;
@@ -569,12 +570,12 @@ PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 
 ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
 	swig -Wall -python -noproxy ctracecmd.i
-	$(CC) -fpic -c $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
+	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
 	$(CC) --shared $(TCMD_LIB_OBJS) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
 
 ctracecmdgui.so: $(TRACE_VIEW_OBJS) $(LIB_FILE)
 	swig -Wall -python -noproxy ctracecmdgui.i
-	$(CC) -fpic -c  $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
+	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
 	$(CC) --shared $^ $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
 
 PHONY += python
@@ -590,7 +591,7 @@ CFLAGS_plugin_python.o += $(PYTHON_DIR_SQ)
 
 do_compile_python_plugin_obj =			\
 	($(print_plugin_obj_compile)		\
-	$(CC) -c $(CFLAGS) $(CFLAGS_$@) $(PYTHON_INCLUDES) -fPIC -o $@ $<)
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(CFLAGS_$@) $(PYTHON_INCLUDES) -fPIC -o $@ $<)
 
 do_python_plugin_build =			\
 	($(print_plugin_build)			\
-- 
1.8.3.2

