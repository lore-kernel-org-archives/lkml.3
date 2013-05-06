Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3EFSkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:40:47 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:44250 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3EFSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:40:46 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH] perf tools: Fix output directory of Documentation/
Date: Mon,  6 May 2013 20:40:14 +0200
Message-Id: <1367865614-30876-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

The OUTPUT directory is wrongly determind leading to:

 make[3]: *** No rule to make target `.../.build/perf/PERF-VERSION-FILE'.  Stop.

Fixing this by using the generic approach in script/Makefile.include.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 tools/perf/Documentation/Makefile | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index f751757..1368e88 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -1,12 +1,6 @@
+include ../../scripts/Makefile.include
 include ../config/utilities.mak
 
-OUTPUT := ./
-ifeq ("$(origin O)", "command line")
-  ifneq ($(O),)
-	OUTPUT := $(O)/
-  endif
-endif
-
 MAN1_TXT= \
 	$(filter-out $(addsuffix .txt, $(ARTICLES) $(SP_ARTICLES)), \
 		$(wildcard perf-*.txt)) \
-- 
1.8.1.1

