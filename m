Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab3D3KEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 06:04:24 -0400
Received: from mout.gmx.net ([212.227.15.15]:61292 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759641Ab3D3KEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 06:04:23 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1/HplAMve3HxqD0njGV0gag8t0ob4VDRRYYMFsjtT
	v7k9Q8Pzag3QtH
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: tglx@linutronix.de, hpa@zytor.com, rostedt@goodmis.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [TRIVIAL] FIX: unintended variable name reuse
Date: Tue, 30 Apr 2013 12:02:33 +0200
Message-Id: <1367316153-14808-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

The variable name events_group is already in used and led to a compilation error
when using clang to build the Linux Kernel . The fix is just to rename the var.
No functional change. Please apply.

Fix suggested in discussion by PaX Team <pageexec@freemail.hu>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

CC: tglx@linutronix.de
CC: hpa@zytor.com
CC: rostedt@goodmis.org
CC: a.p.zijlstra@chello.nl
CC: paulus@samba.org
CC: mingo@redhat.com
CC: acme@ghostprotocols.net
CC: x86@kernel.org
CC: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index d0f9e5a..c01d159 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3093,7 +3093,7 @@ static void __init uncore_types_exit(struct intel_uncore_type **types)
 static int __init uncore_type_init(struct intel_uncore_type *type)
 {
 	struct intel_uncore_pmu *pmus;
-	struct attribute_group *events_group;
+	struct attribute_group *attr_group;
 	struct attribute **attrs;
 	int i, j;
 
@@ -3120,19 +3120,19 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
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
-- 
1.8.1.4

