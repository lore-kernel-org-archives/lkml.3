Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3EaIsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:48:19 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:44401 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3EaIsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:10 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 01/16] perf, persistent: Fix build error for no-tracepoints configs
Date: Fri, 31 May 2013 10:47:21 +0200
Message-Id: <1369990056-10310-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

The mce_record tracepoint needs tracepoints to be enabled. Fixing
build error for no-tracepoints configs.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0ecf4a2..d421937 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1987,6 +1987,8 @@ int __init mcheck_init(void)
 	return 0;
 }
 
+#ifdef CONFIG_TRACEPOINTS
+
 int __init mcheck_init_tp(void)
 {
 	if (perf_add_persistent_event_by_id(event_mce_record.event.type)) {
@@ -2001,6 +2003,8 @@ int __init mcheck_init_tp(void)
  */
 fs_initcall_sync(mcheck_init_tp);
 
+#endif /* CONFIG_TRACEPOINTS */
+
 /*
  * mce_syscore: PM support
  */
-- 
1.8.1.1

