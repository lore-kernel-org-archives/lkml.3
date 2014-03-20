Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaCTDB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:01:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32197 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754680AbaCTDAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:00:13 -0400
Message-Id: <20140320030009.940568282@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Mar 2014 22:58:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-next][PATCH 2/4] tracepoints: API doc update to data argument
References: <20140320025831.285817697@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracepoints-API-doc-update-to-data-argument.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Describe the @data argument (probe private data).

Link: http://lkml.kernel.org/r/1394587948-27878-1-git-send-email-mathieu.desnoyers@efficios.com

Fixes: 38516ab59fbc "tracing: Let tracepoints have data passed to tracepoint callbacks"
CC: Ingo Molnar <mingo@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 0058f33..a4f629d 100644
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
1.8.5.3


