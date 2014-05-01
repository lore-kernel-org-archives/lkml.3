Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaEAGb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:31:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbaEAGbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:31:23 -0400
Date: Wed, 30 Apr 2014 23:31:11 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-c0bc8c6d4a2e18e54ef7854a86bc5a47a8e3d04e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, yarygin@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yarygin@linux.vnet.ibm.com, jolsa@kernel.org, tglx@linutronix.de
In-Reply-To: <1398440047-6641-4-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1398440047-6641-4-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add a test of kvm-390: trace event
Git-Commit-ID: c0bc8c6d4a2e18e54ef7854a86bc5a47a8e3d04e
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

Commit-ID:  c0bc8c6d4a2e18e54ef7854a86bc5a47a8e3d04e
Gitweb:     http://git.kernel.org/tip/c0bc8c6d4a2e18e54ef7854a86bc5a47a8e3d04e
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Fri, 25 Apr 2014 17:34:07 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 29 Apr 2014 14:30:43 +0200

perf tests: Add a test of kvm-390: trace event

Add a s390 specific test of a hardcoded trace event with '-'
in the name.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1398440047-6641-4-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/parse-events.c | 7 +++++++
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
