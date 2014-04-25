Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaDYPcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:32:22 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:40855 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaDYPbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:31:47 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCH 3/3] perf-test: Add a test of kvm-390: trace event
Date: Fri, 25 Apr 2014 17:34:07 +0200
Message-Id: <1398440047-6641-4-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1398440047-6641-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1398440047-6641-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042515-1948-0000-0000-000008959FE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a s390 specific test of a hardcoded trace event with '-'
in the name.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
---
 tools/perf/tests/parse-events.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 81dbd5a..deba669 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1389,6 +1389,13 @@ static struct evlist_test test__events[] = {
 		.check = test__pinned_group,
 		.id    = 41,
 	},
+#if defined(__s390x__)
+	{
+		.name  = "kvm-s390:kvm_s390_create_vm",
+		.check = test__checkevent_tracepoint,
+		.id    = 100,
+	},
+#endif
 };
 
 static struct evlist_test test__events_pmu[] = {
-- 
1.7.9.5

