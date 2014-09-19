Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbaISFUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:20:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbaISFUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:20:10 -0400
Date: Thu, 18 Sep 2014 22:19:50 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-1f3e5b55035549311e42c3f84007e6c799ed991f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, borntraeger@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, borntraeger@de.ibm.com,
        yarygin@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1409579095-12963-4-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1409579095-12963-4-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm stat report: Unify the title bar output
Git-Commit-ID: 1f3e5b55035549311e42c3f84007e6c799ed991f
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

Commit-ID:  1f3e5b55035549311e42c3f84007e6c799ed991f
Gitweb:     http://git.kernel.org/tip/1f3e5b55035549311e42c3f84007e6c799ed991f
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Mon, 1 Sep 2014 17:44:55 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:08 -0300

perf kvm stat report: Unify the title bar output

The 'live' command prints additional information to the "Analyze events
for " title bar about the current target.  Let's print the same title
for the 'report' command.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1409579095-12963-4-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 84295ab..f5d3ae4 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -543,14 +543,12 @@ static void print_vcpu_info(struct perf_kvm_stat *kvm)
 
 	pr_info("Analyze events for ");
 
-	if (kvm->live) {
-		if (kvm->opts.target.system_wide)
-			pr_info("all VMs, ");
-		else if (kvm->opts.target.pid)
-			pr_info("pid(s) %s, ", kvm->opts.target.pid);
-		else
-			pr_info("dazed and confused on what is monitored, ");
-	}
+	if (kvm->opts.target.system_wide)
+		pr_info("all VMs, ");
+	else if (kvm->opts.target.pid)
+		pr_info("pid(s) %s, ", kvm->opts.target.pid);
+	else
+		pr_info("dazed and confused on what is monitored, ");
 
 	if (vcpu == -1)
 		pr_info("all VCPUs:\n\n");
