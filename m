Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaHDQSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:18:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:38726 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaHDQSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:18:22 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/33] perf kvm stat: Properly show submicrosecond times
Date: Mon,  4 Aug 2014 13:17:15 -0300
Message-Id: <1407169064-25625-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

For lots of exits the min time (and sometimes max) is 0 or 1. Lets
increase the accurancy similar to what the average field alread does.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Link: http://lkml.kernel.org/r/1406805231-10675-2-git-send-email-borntraeger@de.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 43367eb00510..fe92dfdeab46 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -592,8 +592,8 @@ static void print_result(struct perf_kvm_stat *kvm)
 	pr_info("%9s ", "Samples%");
 
 	pr_info("%9s ", "Time%");
-	pr_info("%10s ", "Min Time");
-	pr_info("%10s ", "Max Time");
+	pr_info("%11s ", "Min Time");
+	pr_info("%11s ", "Max Time");
 	pr_info("%16s ", "Avg time");
 	pr_info("\n\n");
 
@@ -610,8 +610,8 @@ static void print_result(struct perf_kvm_stat *kvm)
 		pr_info("%10llu ", (unsigned long long)ecount);
 		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
 		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
-		pr_info("%8" PRIu64 "us ", min / 1000);
-		pr_info("%8" PRIu64 "us ", max / 1000);
+		pr_info("%9.2fus ", (double)min / 1e3);
+		pr_info("%9.2fus ", (double)max / 1e3);
 		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
 			kvm_event_rel_stddev(vcpu, event));
 		pr_info("\n");
-- 
1.9.3

