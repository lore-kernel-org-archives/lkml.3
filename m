Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaKCSs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:48:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:5124 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751436AbaKCSs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:48:28 -0500
Date: Mon, 3 Nov 2014 13:48:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] ftracetest: Take the first debugfs mount found
Message-ID: <20141103134824.5e81377c@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Running the ftracetests on a machine that had the debugfs file system
mounted in two locations caused the ftracetests to fail. This is because
the ftracetests script does a grep of the /proc/mounts file to find
where the debugfs file system is mounted. If it is mounted twice, then
the grep returns two lines instead of just one. This causes the ftracetests
to get confused and fail.

Use "head -1" to only return the first mount point for debugfs.

Please pull the latest ftracetest-3.18-rc1 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
ftracetest-3.18-rc1

Tag SHA1: 8c7027b611ee71a58c89ce0cc8b2b17b6da5e81c
Head SHA1: e7dbb48958897c0a80b14250a981a563d9160e4d


Steven Rostedt (Red Hat) (1):
      ftracetest: Take the first debugfs mount found

----
 tools/testing/selftests/ftrace/ftracetest | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit e7dbb48958897c0a80b14250a981a563d9160e4d
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Fri Oct 31 18:02:05 2014 -0400

    ftracetest: Take the first debugfs mount found
    
    Running ftracetests on a box that mounted debugfs in two locations
    made the ftracetests fail. This is because the tests uses a grep
    of debugfs from the /proc/mounts file to find the debugfs mount
    point, and then appends "/tracing" to that string to get the tracing
    directory.
    
    If the debugfs directory is mounted twice, then that grep will return
    two answers and appending "/tracing" to a string with two lines will
    not work.
    
    Use "head -1" to only take the first mount point found.
    
    Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
