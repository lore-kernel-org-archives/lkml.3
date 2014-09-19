Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbaISFTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:19:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52857 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbaISFTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:19:44 -0400
Date: Thu, 18 Sep 2014 22:19:24 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-3ae4a76ac840021294c091884e04af7c92e481ae@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, borntraeger@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, borntraeger@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1409579095-12963-2-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1409579095-12963-2-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm stat report:
  Save pid string in opts.target.pid
Git-Commit-ID: 3ae4a76ac840021294c091884e04af7c92e481ae
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

Commit-ID:  3ae4a76ac840021294c091884e04af7c92e481ae
Gitweb:     http://git.kernel.org/tip/3ae4a76ac840021294c091884e04af7c92e481ae
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Mon, 1 Sep 2014 17:44:53 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:07 -0300

perf kvm stat report: Save pid string in opts.target.pid

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
index 1a4ef9c..646ec5d 100644
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
index 0b5a8cd..cf1d7913 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -92,7 +92,6 @@ struct perf_kvm_stat {
 	u64 lost_events;
 	u64 duration;
 
-	const char *pid_str;
 	struct intlist *pid_list;
 
 	struct rb_root result;
