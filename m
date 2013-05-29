Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3E2QTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:19:22 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45807 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab3E2QS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:18:56 -0400
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: [PATCH trace-cmd 1/2] Makefile: add libdir variable
Date: Wed, 29 May 2013 18:18:47 +0200
Message-Id: <1369844328-30582-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow build scripts such as rpm to set libdir=lib64
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 83329ca..d53cde3 100644
--- a/Makefile
+++ b/Makefile
@@ -47,6 +47,7 @@ html_install = $(prefix)/share/kernelshark/html
 html_install_SQ = '$(subst ','\'',$(html_install))'
 img_install = $(prefix)/share/kernelshark/html/images
 img_install_SQ = '$(subst ','\'',$(img_install))'
+libdir ?= lib
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
@@ -56,8 +57,8 @@ ifeq ($(prefix),$(HOME))
 plugin_dir = $(HOME)/.trace-cmd/plugins
 python_dir = $(HOME)/.trace-cmd/python
 else
-plugin_dir = $(prefix)/lib/trace-cmd/plugins
-python_dir = $(prefix)/lib/trace-cmd/python
+plugin_dir = $(prefix)/$(libdir)/trace-cmd/plugins
+python_dir = $(prefix)/$(libdir)/trace-cmd/python
 PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
 PYTHON_DIR = -DPYTHON_DIR="$(python_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
-- 
1.7.11.7

