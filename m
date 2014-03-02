Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaCBI55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 03:57:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaCBI54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 03:57:56 -0500
Date: Sun, 2 Mar 2014 00:57:25 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-280e7c48c3b873e4987a63da276ecab25383f494@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1389469379-13340-2-git-send-email-andi@firstfloor.org>
References: <1389469379-13340-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: fix BFD detection on opensuse
Git-Commit-ID: 280e7c48c3b873e4987a63da276ecab25383f494
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  280e7c48c3b873e4987a63da276ecab25383f494
Gitweb:     http://git.kernel.org/tip/280e7c48c3b873e4987a63da276ecab25383f494
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 11 Jan 2014 11:42:51 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 27 Feb 2014 18:29:08 -0300

perf tools: fix BFD detection on opensuse

opensuse libbfd requires -lz -liberty to build. Add those to the BFD
feature detection.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1389469379-13340-2-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile                | 2 +-
 tools/perf/config/feature-checks/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c48d449..0331ea2 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -478,7 +478,7 @@ else
 endif
 
 ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd
+  EXTLIBS += -lbfd -lz -liberty
 endif
 
 ifdef NO_DEMANGLE
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 12e5513..523b7bc 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -121,7 +121,7 @@ test-libpython-version.bin:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
 test-libbfd.bin:
-	$(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -DPACKAGE='"perf"' -lbfd -lz -liberty -ldl
 
 test-liberty.bin:
 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty
