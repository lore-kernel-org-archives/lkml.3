Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbaCLBcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:32:43 -0400
Received: from mail.efficios.com ([78.47.125.74]:47354 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbaCLBcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:32:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] Tracepoint API doc update: data argument
Date: Tue, 11 Mar 2014 21:32:28 -0400
Message-Id: <1394587948-27878-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the @data argument (probe private data).

Fixes: 38516ab59fbc "tracing: Let tracepoints have data passed to tracepoint callbacks"
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/tracepoint.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 444e416..49cb94e 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -376,6 +376,7 @@ tracepoint_add_probe(const char *name, void *probe, void *data)
  * tracepoint_probe_register -  Connect a probe to a tracepoint
  * @name: tracepoint name
  * @probe: probe handler
+ * @data: probe private data
  *
  * Returns 0 if ok, error value on error.
  * The probe address must at least be aligned on the architecture pointer size.
@@ -424,6 +425,7 @@ tracepoint_remove_probe(const char *name, void *probe, void *data)
  * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
  * @name: tracepoint name
  * @probe: probe function pointer
+ * @data: probe private data
  *
  * We do not need to call a synchronize_sched to make sure the probes have
  * finished running before doing a module unload, because the module unload
@@ -464,6 +466,7 @@ static void tracepoint_add_old_probes(void *old)
  * tracepoint_probe_register_noupdate -  register a probe but not connect
  * @name: tracepoint name
  * @probe: probe handler
+ * @data: probe private data
  *
  * caller must call tracepoint_probe_update_all()
  */
@@ -488,6 +491,7 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register_noupdate);
  * tracepoint_probe_unregister_noupdate -  remove a probe but not disconnect
  * @name: tracepoint name
  * @probe: probe function pointer
+ * @data: probe private data
  *
  * caller must call tracepoint_probe_update_all()
  */
-- 
1.7.10.4

