Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaIHVSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:18:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:39085 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbaIHVSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:18:41 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/13] perf kvm stat report: Unify the title bar output
Date: Mon,  8 Sep 2014 18:18:01 -0300
Message-Id: <1410211089-28668-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410211089-28668-1-git-send-email-acme@kernel.org>
References: <1410211089-28668-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

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
index 84295ab6c4e1..f5d3ae483110 100644
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
-- 
1.9.3

