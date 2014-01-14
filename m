Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaANBEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:04:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:5771 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbaANBEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:04:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,656,1384329600"; 
   d="scan'208";a="458241986"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, namhyung@kernel.org, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/6] perf, tools: fix BFD detection on opensuse
Date: Mon, 13 Jan 2014 17:04:16 -0800
Message-Id: <1389661461-18996-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

opensuse libbfd requires -lz -liberty to build. Add those
to the BFD feature detection.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/config/Makefile                | 2 +-
 tools/perf/config/feature-checks/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 01dd43d..d86d33c 100644
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
index 7cf6fcd..a430e4f 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -120,7 +120,7 @@ test-libpython-version.bin:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
 test-libbfd.bin:
-	$(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -DPACKAGE='"perf"' -lbfd -lz -liberty -ldl
 
 test-liberty.bin:
 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty
-- 
1.8.3.1

