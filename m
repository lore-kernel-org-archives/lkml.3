Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207Ab3D3Qub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:50:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58429 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830Ab3D3Qu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:50:29 -0400
Date: Tue, 30 Apr 2013 09:50:17 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgSmFuLVNpbW9uIE3DtmxsZXI=?=" 
	<tipbot@zytor.com>
Message-ID: <tip-1b0dac2ac6debdbf1541e15f2cede03613cf4465@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dl9pf@gmx.de, stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dl9pf@gmx.de, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <1367316153-14808-1-git-send-email-dl9pf@gmx.de>
References: <1367316153-14808-1-git-send-email-dl9pf@gmx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel:
  Fix unintended variable name reuse
Git-Commit-ID: 1b0dac2ac6debdbf1541e15f2cede03613cf4465
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

Commit-ID:  1b0dac2ac6debdbf1541e15f2cede03613cf4465
Gitweb:     http://git.kernel.org/tip/1b0dac2ac6debdbf1541e15f2cede03613cf4465
Author:     Jan-Simon Möller <dl9pf@gmx.de>
AuthorDate: Tue, 30 Apr 2013 12:02:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 13:12:47 +0200

perf/x86/intel: Fix unintended variable name reuse

The variable name events_group is already in used and led to a
compilation error when using clang to build the Linux Kernel .
The fix is just to rename the var. No functional change. Please
apply.

Fix suggested in discussion by PaX Team <pageexec@freemail.hu>

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Cc: rostedt@goodmis.org
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/1367316153-14808-1-git-send-email-dl9pf@gmx.de
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 22ebaa8..45f6d13 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2428,7 +2428,7 @@ static void __init uncore_types_exit(struct intel_uncore_type **types)
 static int __init uncore_type_init(struct intel_uncore_type *type)
 {
 	struct intel_uncore_pmu *pmus;
-	struct attribute_group *events_group;
+	struct attribute_group *attr_group;
 	struct attribute **attrs;
 	int i, j;
 
@@ -2455,19 +2455,19 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 		while (type->event_descs[i].attr.attr.name)
 			i++;
 
-		events_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
-					sizeof(*events_group), GFP_KERNEL);
-		if (!events_group)
+		attr_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
+					sizeof(*attr_group), GFP_KERNEL);
+		if (!attr_group)
 			goto fail;
 
-		attrs = (struct attribute **)(events_group + 1);
-		events_group->name = "events";
-		events_group->attrs = attrs;
+		attrs = (struct attribute **)(attr_group + 1);
+		attr_group->name = "events";
+		attr_group->attrs = attrs;
 
 		for (j = 0; j < i; j++)
 			attrs[j] = &type->event_descs[j].attr.attr;
 
-		type->events_group = events_group;
+		type->events_group = attr_group;
 	}
 
 	type->pmu_group = &uncore_pmu_attr_group;
