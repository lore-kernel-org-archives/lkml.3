Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab3DBDyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:54:51 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60514 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760379Ab3DBDys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:54:48 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, linux-kbuild@vger.kernel.org
Subject: [PATCH 01/23] perf: initial infrasructure for kconfig
Date: Mon,  1 Apr 2013 21:54:15 -0600
Message-Id: <1364874877-5618-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Pconfig file which will hold the build options.
Update Makefile with new config files.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: linux-kbuild@vger.kernel.org
---
 tools/perf/Makefile |    5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 tools/perf/Pconfig

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bb74c79..4e54d05 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -5,6 +5,9 @@ all:
 
 include config/utilities.mak
 
+# Read in config if it exists
+-include $(OUTPUT)include/config/auto.conf
+
 # Define V to have a more verbose compile.
 #
 # Define O to save output files in a separate directory.
@@ -203,6 +206,7 @@ ifneq ($(OUTPUT),)
 endif
 
 BASIC_CFLAGS = \
+	-I$(OUTPUT)include \
 	-Iutil/include \
 	-Iarch/$(ARCH)/include \
 	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
@@ -409,6 +413,7 @@ LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
 LIB_H += ui/ui.h
+LIB_H += $(OUTPUT)include/generated/autoconf.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
new file mode 100644
index 0000000..e69de29
-- 
1.7.10.1

