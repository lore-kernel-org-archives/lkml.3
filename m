Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3EIWct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:32:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab3EIWcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Ingo Molnar <mingo@kernel.org>, rostedt@goodmis.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net
Subject: [ 10/73] perf/x86/intel: Fix unintended variable name reuse
Date: Thu,  9 May 2013 15:31:33 -0700
Message-Id: <20130509222759.066414439@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan-Simon Möller <dl9pf@gmx.de>

commit 1b0dac2ac6debdbf1541e15f2cede03613cf4465 upstream.

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
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2428,7 +2428,7 @@ static void __init uncore_types_exit(str
 static int __init uncore_type_init(struct intel_uncore_type *type)
 {
 	struct intel_uncore_pmu *pmus;
-	struct attribute_group *events_group;
+	struct attribute_group *attr_group;
 	struct attribute **attrs;
 	int i, j;
 
@@ -2455,19 +2455,19 @@ static int __init uncore_type_init(struc
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


