Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3JDVlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:41:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:30818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3JDVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="414189163"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, rostedt@goodmis.org
Subject: [PATCH 4/6] trace: Make UPROBES depend on PERF_EVENTS
Date: Fri,  4 Oct 2013 14:39:46 -0700
Message-Id: <1380922788-23112-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

UPROBES need the perf events code, so add a dependency
from PERF_EVENTS to UPROBES.

Cc: rostedt@goodmis.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/trace/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 015f85a..8639819 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -424,6 +424,7 @@ config UPROBE_EVENT
 	bool "Enable uprobes-based dynamic events"
 	depends on ARCH_SUPPORTS_UPROBES
 	depends on MMU
+	depends on PERF_EVENTS
 	select UPROBES
 	select PROBE_EVENTS
 	select TRACING
-- 
1.8.3.1

