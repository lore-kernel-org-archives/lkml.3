Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3JaRnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:43:10 -0400
Received: from zimbra3.corp.accelance.fr ([213.162.49.233]:54062 "EHLO
	zimbra3.corp.accelance.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3JaRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:43:09 -0400
From: Romain Naour <romain.naour@openwide.fr>
To: linux-kernel@vger.kernel.org
Cc: Romain <romain.naour@openwide.fr>
Subject: [PATCH 1/1] trace-cmd: use pkg-config instead of python-config
Date: Thu, 31 Oct 2013 18:39:42 +0100
Message-Id: <1383241182-11162-1-git-send-email-romain.naour@openwide.fr>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Romain <romain.naour@openwide.fr>

trace-cmd use python-config to find out which headers
and libraries should be used to link against the Python libraries.
By default, python-config returns paths that are inappropriate for
cross-compilation.

Add PYTHON_VERS to build trace-cmd with python2 or python3

Signed-off-by: Romain Naour <romain.naour@openwide.fr>
---
 Makefile | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 1964949..2f862ec 100644
--- a/Makefile
+++ b/Makefile
@@ -81,8 +81,10 @@ ifndef NO_PYTHON
 PYTHON		:= ctracecmd.so
 PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
 
+PYTHON_VERS ?= python
+
 # Can build python?
-ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo y"), y)
+ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo y"), y)
 	PYTHON_PLUGINS := plugin_python.so
 	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
 	PYTHON_SO_INSTALL := ctracecmd.install
@@ -550,8 +552,8 @@ clean:
 
 ##### PYTHON STUFF #####
 
-PYTHON_INCLUDES = `python-config --includes`
-PYTHON_LDFLAGS = `python-config --ldflags` \
+PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_VERS)`
+PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
 		$(shell python -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LINKFORSHARED')")
 PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 
-- 
1.8.1.4

