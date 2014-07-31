Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaGaLNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:13:46 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:43079 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaGaLNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:13:36 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH/RFC] KVM: perf/stat: Properly show submicrosecond times
Date: Thu, 31 Jul 2014 13:13:51 +0200
Message-Id: <1406805231-10675-2-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1406805231-10675-1-git-send-email-borntraeger@de.ibm.com>
References: <1406805231-10675-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073111-4966-0000-0000-000000E500E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For lots of exits the min time (and sometimes max) is 0 or 1. Lets
increase the accurancy similar to what the average field alread does.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/perf/builtin-kvm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 43367eb..fe92dfd 100644
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
1.8.4.2

