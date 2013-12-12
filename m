Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3LLQzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:55:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24961 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3LLQyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:55 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 9/9] perf: Known exploit detection for CVE-2013-2094
Date: Thu, 12 Dec 2013 17:52:32 +0100
Message-Id: <1386867152-24072-9-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

See 8176cced706b5e5d15887584150764894e94e02f.

Cc: Tommi Rantala <tt.rantala@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 kernel/events/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 953c143..32b9383 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -39,6 +39,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
+#include <linux/exploit.h>
 
 #include "internal.h"
 
@@ -5721,6 +5722,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 static int perf_swevent_init(struct perf_event *event)
 {
 	u64 event_id = event->attr.config;
+	exploit_on((int) event_id < 0, "CVE-2013-2094");
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
-- 
1.7.10.4

