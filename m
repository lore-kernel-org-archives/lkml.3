Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaLDPzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:55:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:54179 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754133AbaLDPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:55:45 -0500
Message-Id: <20141204155544.206813142@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 04 Dec 2014 10:55:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 1/2] ftracetest: Fix to show descriptions on dash
References: <20141204155517.575600663@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftracetest-Fix-to-show-descriptions-on-dash.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

The ftracetest doesn't show testcase's descriptions when
it is executed on dash. This fixes that to show the
descriptions on dash correctly by passing it via a variable
instead of directly passing the grep command output.

Link: http://lkml.kernel.org/r/20141204194116.7376.78940.stgit@localhost.localdomain

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/ftracetest | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 535b98b79c29..e8b402193a82 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -135,7 +135,8 @@ TOTAL_RESULT=0
 CASENO=0
 testcase() { # testfile
   CASENO=$((CASENO+1))
-  prlog -n "[$CASENO]"`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
+  desc=`grep "^#[ \t]*description:" $1 | cut -f2 -d:`
+  prlog -n "[$CASENO]$desc"
 }
 
 eval_result() { # retval sigval
-- 
2.1.3


