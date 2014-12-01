Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbaLAXKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:10:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:46833 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009AbaLAXKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:10:12 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 9/9] perf report: In branch stack mode use address history sorting
Date: Mon,  1 Dec 2014 20:09:24 -0300
Message-Id: <1417475364-27371-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417475364-27371-1-git-send-email-acme@kernel.org>
References: <1417475364-27371-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Enable CCKEY_ADDRESS address history sorting with --branch-history.
This makes get_srcline display the source lines correctly, otherwise all
history entries for a function a hunked into one.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1416275935-20971-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fb272ff435c9..39367609c707 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -761,6 +761,7 @@ repeat:
 		symbol_conf.cumulate_callchain = false;
 	}
 	if (branch_call_mode) {
+		callchain_param.key = CCKEY_ADDRESS;
 		callchain_param.branch_callstack = 1;
 		symbol_conf.use_callchain = true;
 		callchain_register_param(&callchain_param);
-- 
1.9.3

