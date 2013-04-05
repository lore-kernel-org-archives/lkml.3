Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162017Ab3DEQRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:17:10 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58350 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161964Ab3DEQRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:17:09 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <jsmoeller.linux@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: [PATCH] [TRIVIAL] FIX: unintended variable name reuse
Date: Fri, 05 Apr 2013 18:17:01 +0200
Message-ID: <2178091.aRcfQYZIWb@aragorn.auenland.lan>
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup a variable name reuse. 


Fix suggested by PaX Team <pageexec@freemail.hu>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c 
b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b43200d..4c783be 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2428,7 +2428,7 @@ static void __init uncore_types_exit(struct 
intel_uncore_type **types)
 static int __init uncore_type_init(struct intel_uncore_type *type)
 {
 	struct intel_uncore_pmu *pmus;
-	struct attribute_group *events_group;
+	struct attribute_group *attr_group;
 	struct attribute **attrs;
 	int i, j;
 
@@ -2455,19 +2455,19 @@ static int __init uncore_type_init(struct 
intel_uncore_type *type)
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


