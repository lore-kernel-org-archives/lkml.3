Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3JXTOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:14:48 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:52991 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3JXTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:14:46 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd 3/5] Add missing libgen.h includes
Date: Thu, 24 Oct 2013 14:14:32 -0500
Message-Id: <1382642074-15567-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for basname(). Without the include the compiler
may assume that basename() returns int, which leads to a segfault
in some cases.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 kernel-shark.c     | 1 +
 trace-graph-main.c | 1 +
 trace-view-main.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/kernel-shark.c b/kernel-shark.c
index ee4796a..0201427 100644
--- a/kernel-shark.c
+++ b/kernel-shark.c
@@ -28,6 +28,7 @@
 #include <gtk/gtk.h>
 #include <errno.h>
 #include <getopt.h>
+#include <libgen.h>
 
 #include "trace-compat.h"
 #include "trace-capture.h"
diff --git a/trace-graph-main.c b/trace-graph-main.c
index 1bc10c1..3654295 100644
--- a/trace-graph-main.c
+++ b/trace-graph-main.c
@@ -23,6 +23,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
+#include <libgen.h>
 
 #include "trace-cmd.h"
 #include "trace-graph.h"
diff --git a/trace-view-main.c b/trace-view-main.c
index 73dfa8a..935b8c1 100644
--- a/trace-view-main.c
+++ b/trace-view-main.c
@@ -23,6 +23,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
+#include <libgen.h>
 
 #include "trace-cmd.h"
 #include "trace-view.h"
-- 
1.8.3.2

