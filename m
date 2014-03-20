Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaCTDAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:00:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32718 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752923AbaCTDAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:00:11 -0400
Message-Id: <20140320030010.073469437@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Mar 2014 22:58:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-next][PATCH 3/4] tracepoints: API doc update to tracepoint_probe_register() return
 value
References: <20140320025831.285817697@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracepoints-API-doc-update-to-tracepoint_probe_regis.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Describe the return values of tracepoint_probe_register(), including
-ENODEV added by commit:

Author: Steven Rostedt <rostedt@goodmis.org>

    tracing: Warn if a tracepoint is not set via debugfs

Link: http://lkml.kernel.org/r/1394499898-1537-2-git-send-email-mathieu.desnoyers@efficios.com

CC: Ingo Molnar <mingo@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index a4f629d..e2a58a2 100644
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
1.8.5.3


