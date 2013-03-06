Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3CFXTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:19:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:40671 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab3CFXTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:19:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="210035712"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, tools: Define MADV_*HUGEPAGE for old kernels
Date: Wed,  6 Mar 2013 15:19:16 -0800
Message-Id: <1362611957-4358-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Avoids this on RHEL6:

bench/numa.c: In function ‘alloc_data’:
bench/numa.c:334: error: ‘MADV_HUGEPAGE’ undeclared (first use in this function)
bench/numa.c:334: error: (Each undeclared identifier is reported only once
bench/numa.c:334: error: for each function it appears in.)
bench/numa.c:341: error: ‘MADV_NOHUGEPAGE’ undeclared (first use in this function)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/bench/numa.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 30d1c32..8f30ce1 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -30,6 +30,9 @@
 #include <numa.h>
 #include <numaif.h>
 
+#define MADV_HUGEPAGE   14              /* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE 15              /* Not worth backing with hugepages */
+
 /*
  * Regular printout to the terminal, supressed if -q is specified:
  */
-- 
1.7.7.6

