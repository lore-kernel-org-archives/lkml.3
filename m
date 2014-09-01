Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaIANsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:48:30 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:50839 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaIANsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:48:24 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] perf kvm stat report: Save pid string in opts.target.pid
Date: Mon,  1 Sep 2014 17:44:53 +0400
Message-Id: <1409579095-12963-2-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409579095-12963-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1409579095-12963-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090113-5024-0000-0000-0000012503D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'perf kvm stat report' command uses the kvm->pid_str field to keep
the value of the --pid option. Let's use kvm->opts.target.pid instead.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c   |    6 +++---
 tools/perf/util/kvm-stat.h |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 43367eb..ad73476 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1088,8 +1088,8 @@ static int read_events(struct perf_kvm_stat *kvm)

 static int parse_target_str(struct perf_kvm_stat *kvm)
 {
-	if (kvm->pid_str) {
-		kvm->pid_list = intlist__new(kvm->pid_str);
+	if (kvm->opts.target.pid) {
+		kvm->pid_list = intlist__new(kvm->opts.target.pid);
 		if (kvm->pid_list == NULL) {
 			pr_err("Error parsing process id string\n");
 			return -EINVAL;
@@ -1191,7 +1191,7 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
 			    "key for sorting: sample(sort by samples number)"
 			    " time (sort by avg time)"),
-		OPT_STRING('p', "pid", &kvm->pid_str, "pid",
+		OPT_STRING('p', "pid", &kvm->opts.target.pid, "pid",
 			   "analyze events only for given process id(s)"),
 		OPT_END()
 	};
diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
index 0b5a8cd..cf1d7913 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -92,7 +92,6 @@ struct perf_kvm_stat {
 	u64 lost_events;
 	u64 duration;

-	const char *pid_str;
 	struct intlist *pid_list;

 	struct rb_root result;
--
1.7.9.5

