Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbaGHWRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:17:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46118 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaGHWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:16:54 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, namhyung@kernel.org
Subject: [PATCH 4/4] perf record: add new -I option to sample interrupted machine state
Date: Wed,  9 Jul 2014 00:15:59 +0200
Message-Id: <1404857759-25105-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404857759-25105-1-git-send-email-eranian@google.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add -I option to capture machine state registers at interrupt.

Use perf report -D to display the sampled register values 
in each sample.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 378b85b..17c45f8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -876,6 +876,8 @@ const struct option record_options[] = {
 		    "sample transaction flags (special events only)"),
 	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
 		    "use per-thread mmaps"),
+	OPT_BOOLEAN('I', "sample-intr-regs", &record.opts.sample_intr_regs,
+		    "Sample machine register on interrupt"),
 	OPT_END()
 };
 
-- 
1.8.3.2

