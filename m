Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab3JTMrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 08:47:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:17049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3JTMrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 08:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,533,1378882800"; 
   d="scan'208";a="395712696"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Fix bfd link on opensuse
Date: Sun, 20 Oct 2013 05:47:00 -0700
Message-Id: <1382273220-25870-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

My opensuse libbfd requires libz and libiberty. perf
was not adding that for the bfd check, so the bfd
check was always failing.

Always add -lz and -liberty to BFD

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/config/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 40a41c6..ec94f59 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -360,10 +360,10 @@ else
   endif
 endif
 
-FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
+FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd -liberty -lz
 has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
 ifeq ($(has_bfd),y)
-  EXTLIBS += -lbfd
+  EXTLIBS += -lbfd -liberty -lz
   CFLAGS += -DLIBBFD_SUPPORT
 endif
 
-- 
1.8.3.1

