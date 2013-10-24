Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3JXTOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:14:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33273 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3JXTOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:14:48 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd 5/5] build: Use CFLAGS and LDFLAGS when building python bits
Date: Thu, 24 Oct 2013 14:14:34 -0500
Message-Id: <1382642074-15567-6-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distro build systems expect all objects to be built with the
flags they supply, and may complain when they are not.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 2423038..1d613c4 100644
--- a/Makefile
+++ b/Makefile
@@ -569,13 +569,13 @@ PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 
 ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
 	swig -Wall -python -noproxy ctracecmd.i
-	$(CC) -fpic -c $(PYTHON_INCLUDES)  ctracecmd_wrap.c
-	$(CC) --shared $(TCMD_LIB_OBJS) ctracecmd_wrap.o -o ctracecmd.so
+	$(CC) -fpic -c $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
+	$(CC) --shared $(TCMD_LIB_OBJS) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
 
 ctracecmdgui.so: $(TRACE_VIEW_OBJS) $(LIB_FILE)
 	swig -Wall -python -noproxy ctracecmdgui.i
 	$(CC) -fpic -c  $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
-	$(CC) --shared $^ $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
+	$(CC) --shared $^ $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
 
 PHONY += python
 python: $(PYTHON)
@@ -594,7 +594,7 @@ do_compile_python_plugin_obj =			\
 
 do_python_plugin_build =			\
 	($(print_plugin_build)			\
-	$(CC) $< -shared $(PYTHON_LDFLAGS) -o $@)
+	$(CC) $< -shared $(LDFLAGS) $(PYTHON_LDFLAGS) -o $@)
 
 plugin_python.o: %.o : $(src)/%.c trace_python_dir
 	$(Q)$(do_compile_python_plugin_obj)
-- 
1.8.3.2

