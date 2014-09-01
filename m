Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaIANs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:48:27 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:33851 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaIANsY (ORCPT
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
Subject: [PATCH 3/3] perf kvm stat report: Unify the title bar output
Date: Mon,  1 Sep 2014 17:44:55 +0400
Message-Id: <1409579095-12963-4-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409579095-12963-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1409579095-12963-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090113-2966-0000-0000-000000FBF1AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'live' command prints additional information to the
"Analyze events for " title bar about the current target.
Let's print the same title for the 'report' command.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b7fa0bc..c3af7ee 100644
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
1.7.9.5

