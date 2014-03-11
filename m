Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaCKBF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:05:27 -0400
Received: from mail.efficios.com ([78.47.125.74]:42551 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbaCKBFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:05:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] Tracepoint API doc update: tracepoint_probe_register() return value
Date: Mon, 10 Mar 2014 21:04:58 -0400
Message-Id: <1394499898-1537-2-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394499898-1537-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1394499898-1537-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the return values of tracepoint_probe_register(), including
-ENODEV added by commit:

Author: Steven Rostedt <rostedt@goodmis.org>

    tracing: Warn if a tracepoint is not set via debugfs

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/tracepoint.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 49cb94e..0839258 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -378,7 +378,17 @@ tracepoint_add_probe(const char *name, void *probe, void *data)
  * @probe: probe handler
  * @data: probe private data
  *
- * Returns 0 if ok, error value on error.
+ * Returns:
+ * - 0 if the probe was successfully registered, and tracepoint
+ *   callsites are currently loaded for that probe,
+ * - -ENODEV if the probe was successfully registered, but no tracepoint
+ *   callsite is currently loaded for that probe,
+ * - other negative error value on error.
+ *
+ * When tracepoint_probe_register() returns either 0 or -ENODEV,
+ * parameters @name, @probe, and @data may be used by the tracepoint
+ * infrastructure until the probe is unregistered.
+ *
  * The probe address must at least be aligned on the architecture pointer size.
  */
 int tracepoint_probe_register(const char *name, void *probe, void *data)
-- 
1.7.10.4

