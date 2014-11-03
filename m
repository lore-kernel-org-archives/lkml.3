Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaKCV2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:28:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:52678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752710AbaKCV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:28:43 -0500
Message-Id: <20141103212841.832443898@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 03 Nov 2014 16:27:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 2/4 v2] ftracetest: Add disable/enable_tracing() helper calls
References: <20141103212737.696365174@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftracetest-Add-disable-enable_tracing-helper-calls.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add calls that disable and enable tracing respectively by echoing
0 or 1 into tracing_on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/test.d/functions | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
index 1aa9f2e9c40b..c5bf630e9be8 100644
--- a/tools/testing/selftests/ftrace/test.d/functions
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -2,3 +2,11 @@
 clear_trace() { # reset trace output
     echo > trace
 }
+
+disable_tracing() { # stop trace recording
+    echo 0 > tracing_on
+}
+
+enable_tracing() { # start trace recording
+    echo 1 > tracing_on
+}
-- 
2.1.1


