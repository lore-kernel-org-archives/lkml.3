Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3DYADG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:03:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:46442 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580Ab3DYADE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:03:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,546,1363158000"; 
   d="scan'208";a="291518849"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Handle JITed code in shared memory
Date: Wed, 24 Apr 2013 17:03:02 -0700
Message-Id: <1366848182-30449-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Need to check for /dev/zero.

Most likely more strings are missing too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/map.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 6fcb9de..8bcdf9e 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -21,6 +21,7 @@ const char *map_type__name[MAP__NR_TYPES] = {
 static inline int is_anon_memory(const char *filename)
 {
 	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/dev/zero (deleted)") ||
 	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
-- 
1.7.7.6

