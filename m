Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaJCAyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 20:54:08 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37286 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaJCAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 20:54:05 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org
Cc: Anton Blanchard <anton@au1.ibm.com>, <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/3] tools/perf: Fix error message
Date: Thu,  2 Oct 2014 17:53:34 -0700
Message-Id: <1412297616-14179-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100300-0928-0000-0000-000005506DFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, eg: with a stripped vmlinux, we can open the file but
cannot load any symbols from it. Update error message accordingly
so the users can better understand the error.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index b709059..c478092 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -267,7 +267,7 @@ int map__load(struct map *map, symbol_filter_t filter)
 			pr_warning("%s with build id %s not found",
 				   name, sbuild_id);
 		} else
-			pr_warning("Failed to open %s", name);
+			pr_warning("Failed to load symbols for DSO %s", name);
 
 		pr_warning(", continuing without symbols\n");
 		return -1;
-- 
1.8.3.1

