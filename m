Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbaIDAhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 20:37:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:2795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbaIDAhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 20:37:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,462,1406617200"; 
   d="scan'208";a="597612407"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: rostedt@goodmis.org, mingo@redhat.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] trace: Resolve some missing-field-initializers warnings
Date: Wed,  3 Sep 2014 17:36:42 -0700
Message-Id: <1409791002-16229-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve some missing-field-initializers warnings by using a
more elaborated form of designated initialization.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 kernel/trace/trace_export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d4ddde2..190bc09 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -177,7 +177,7 @@ struct ftrace_event_call __used event_##call = {			\
 	{								\
 		.name			= #call,			\
 	},								\
-	.event.type		= etype,				\
+	.event = { .type	= etype, },				\
 	.print_fmt		= print,				\
 	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE | TRACE_EVENT_FL_USE_CALL_FILTER, \
 };									\
-- 
1.9.3

