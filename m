Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbbAZKPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:15:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbbAZKPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:15:40 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 31/36] perf build: Add build documentation
Date: Mon, 26 Jan 2015 11:12:31 +0100
Message-Id: <1422267156-13873-32-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding file describing the basics of perf build process.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/Build.txt | 49 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 tools/perf/Documentation/Build.txt

diff --git a/tools/perf/Documentation/Build.txt b/tools/perf/Documentation/Build.txt
new file mode 100644
index 000000000000..f6fc6507ba55
--- /dev/null
+++ b/tools/perf/Documentation/Build.txt
@@ -0,0 +1,49 @@
+
+1) perf build
+=============
+The perf build process consists of several separated building blocks,
+which are linked together to form the perf binary:
+  - libperf library (static)
+  - perf builtin commands
+  - traceevent library (static)
+  - GTK ui library
+
+Several makefiles govern the perf build:
+
+  - Makefile
+    top level Makefile working as a wrapper that calls the main
+    Makefile.perf with a -j option to do parallel builds.
+
+  - Makefile.perf
+    main makefile that triggers build of all perf objects including
+    installation and documentation processing.
+
+  - tools/build/Makefile.build
+    main makefile of the build framework
+
+  - tools/build/Build.include
+    build framework generic definitions
+
+  - Build makefiles
+    makefiles that defines build objects
+
+Please refer to tools/build/Documentation/Build.txt for more
+information about build framework.
+
+
+2) perf build
+=============
+The Makefile.perf triggers the build framework for build objects:
+   perf, libperf, gtk
+
+resulting in following objects:
+  $ ls  *-in.o
+  gtk-in.o  libperf-in.o  perf-in.o
+
+Those objects are then used in final linking:
+  libperf-gtk.so <- gtk-in.o  libperf-in.o
+  perf           <- perf-in.o libperf-in.o
+
+
+NOTE this description is omitting other libraries involved, only
+     focusing on build framework outcomes
-- 
1.9.3

