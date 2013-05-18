Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab3ERDIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:08:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659Ab3ERDAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:23 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=uty_dIo9Yj0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_SVTL1rvyCwA:10 a=hGzw-44bAAAA:8 a=h3sCQ_blAAAA:8 a=VwQbUJbxAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=A71SCvCayfUA:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=dowx1zmaLagA:10 a=fNChW5oJl9MA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021656.207772840@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <acme@ghostprotocols.net>, <stable@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 090/136 ] perf/x86/intel: Fix unintended variable name reuse
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0090-perf-x86-intel-Fix-unintended-variable-name-reuse.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>

[ Upstream commit 1b0dac2ac6debdbf1541e15f2cede03613cf4465 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 906b553..0c0957d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2398,7 +2398,7 @@ static void __init uncore_types_exit(struct intel_uncore_type **types)
 static int __init uncore_type_init(struct intel_uncore_type *type)
 {
 	struct intel_uncore_pmu *pmus;
-	struct attribute_group *events_group;
+	struct attribute_group *attr_group;
 	struct attribute **attrs;
 	int i, j;
 
@@ -2425,19 +2425,19 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
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
 
-		type->attr_groups[1] = events_group;
+		type->attr_groups[1] = attr_group;
 	}
 
 	type->pmus = pmus;
-- 
1.7.10.4


