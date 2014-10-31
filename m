Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbaJaWG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:06:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:26519 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751541AbaJaWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:06:57 -0400
Date: Fri, 31 Oct 2014 18:06:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftracetest: Take the first debugfs mount found
Message-ID: <20141031180655.1deff238@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Running ftracetests on a box that mounted debugfs in two locations
made the ftracetests fail. This is because the tests uses a grep
of debugfs from the /proc/mounts file to find the debugfs mount
point, and then appends "/tracing" to that string to get the tracing
directory.

If the debugfs directory is mounted twice, then that grep will return
two answers and appending "/tracing" to a string with two lines will
not work.

Use "head -1" to only take the first mount point found.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/ftracetest | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index a8f81c782856..515247601df4 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -82,7 +82,7 @@ parse_opts() { # opts
 }
 
 # Parameters
-DEBUGFS_DIR=`grep debugfs /proc/mounts | cut -f2 -d' '`
+DEBUGFS_DIR=`grep debugfs /proc/mounts | cut -f2 -d' ' | head -1`
 TRACING_DIR=$DEBUGFS_DIR/tracing
 TOP_DIR=`absdir $0`
 TEST_DIR=$TOP_DIR/test.d
-- 
1.8.1.4

