Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaB1EWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:22:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:61057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbaB1EWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:22:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="463876463"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/8] perf, tools: fix BFD detection on opensuse
Date: Thu, 27 Feb 2014 20:22:25 -0800
Message-Id: <1393561352-23448-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
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
index f7c81d3..c234182 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -503,7 +503,7 @@ else
 endif
 
 ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd
+  EXTLIBS += -lbfd -lz -liberty
 endif
 
 ifdef NO_DEMANGLE
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 2b492f5..2da103c 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -122,7 +122,7 @@ test-libpython-version.bin:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
 test-libbfd.bin:
-	$(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -DPACKAGE='"perf"' -lbfd -lz -liberty -ldl
 
 test-liberty.bin:
 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty
-- 
1.8.5.3

