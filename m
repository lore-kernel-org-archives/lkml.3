Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaIHVSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:18:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:39052 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbaIHVSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:18:33 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/13] perf kvm stat report: Save pid string in opts.target.pid
Date: Mon,  8 Sep 2014 18:17:59 -0300
Message-Id: <1410211089-28668-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410211089-28668-1-git-send-email-acme@kernel.org>
References: <1410211089-28668-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

The 'perf kvm stat report' command uses the kvm->pid_str field to keep
the value of the --pid option. Let's use kvm->opts.target.pid instead.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1409579095-12963-2-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c   | 6 +++---
 tools/perf/util/kvm-stat.h | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 1a4ef9cd9d5f..646ec5d5de80 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1085,8 +1085,8 @@ static int read_events(struct perf_kvm_stat *kvm)
 
 static int parse_target_str(struct perf_kvm_stat *kvm)
 {
-	if (kvm->pid_str) {
-		kvm->pid_list = intlist__new(kvm->pid_str);
+	if (kvm->opts.target.pid) {
+		kvm->pid_list = intlist__new(kvm->opts.target.pid);
 		if (kvm->pid_list == NULL) {
 			pr_err("Error parsing process id string\n");
 			return -EINVAL;
@@ -1188,7 +1188,7 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
 			    "key for sorting: sample(sort by samples number)"
 			    " time (sort by avg time)"),
-		OPT_STRING('p', "pid", &kvm->pid_str, "pid",
+		OPT_STRING('p', "pid", &kvm->opts.target.pid, "pid",
 			   "analyze events only for given process id(s)"),
 		OPT_END()
 	};
diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
index 0b5a8cd2ee79..cf1d7913783b 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -92,7 +92,6 @@ struct perf_kvm_stat {
 	u64 lost_events;
 	u64 duration;
 
-	const char *pid_str;
 	struct intlist *pid_list;
 
 	struct rb_root result;
-- 
1.9.3

