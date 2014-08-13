Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaHMFN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:13:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44702 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHMFN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:13:26 -0400
Date: Tue, 12 Aug 2014 22:13:11 -0700
From: tip-bot for Christian Borntraeger <tipbot@zytor.com>
Message-ID: <tip-b048a24cc8f29dce1bad564aaeb8680020d3701c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, borntraeger@de.ibm.com,
        pbonzini@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@kernel.org, borntraeger@de.ibm.com,
        pbonzini@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1406805231-10675-2-git-send-email-borntraeger@de.ibm.com>
References: <1406805231-10675-2-git-send-email-borntraeger@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm stat: Properly show submicrosecond times
Git-Commit-ID: b048a24cc8f29dce1bad564aaeb8680020d3701c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b048a24cc8f29dce1bad564aaeb8680020d3701c
Gitweb:     http://git.kernel.org/tip/b048a24cc8f29dce1bad564aaeb8680020d3701c
Author:     Christian Borntraeger <borntraeger@de.ibm.com>
AuthorDate: Thu, 31 Jul 2014 13:13:51 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 2 Aug 2014 10:21:11 -0300

perf kvm stat: Properly show submicrosecond times

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
