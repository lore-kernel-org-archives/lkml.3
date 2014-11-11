Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaKKVmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:42:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:55229 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752015AbaKKVmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:42:08 -0500
Message-Id: <20141111214206.961266375@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 11 Nov 2014 16:41:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 4/6] ftracetest: Use logfile name supported by busyboxs mktemp
References: <20141111214127.196849367@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ftracetest-Use-logfile-name-supported-by-busybox-s-m.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When I run the ftracetest in a busybox docker container, I saw
following error.  Make the logfile template to comply with busybox's
mktemp.  It also keep the logfiles under the logs directory.

  # /linux/tools/testing/selftests/ftrace/ftracetest
  === Ftrace unit tests ===
  mktemp: unrecognized option `--tmpdir=/linux/tools/testing/selftests/ftrace/logs/20141106-003624/'
  BusyBox v1.22.1 (2014-05-22 23:22:11 UTC) multi-call binary.

  Usage: mktemp [-dt] [-p DIR] [TEMPLATE]

  Create a temporary file with name based on TEMPLATE and print its name.
  TEMPLATE must end with XXXXXX (e.g. [/dir/]nameXXXXXX).
  Without TEMPLATE, -t tmp.XXXXXX is assumed.

  	-d	  Make directory, not file
  	-q	  Fail silently on errors
  	-t	  Prepend base directory name to TEMPLATE
  	-p DIR	  Use DIR as a base directory (implies -t)
  	-u Do not create anything; print a name

  Base directory is: -p DIR, else $TMPDIR, else /tmp

  [1] Basic trace file check/linux/tools/testing/selftests/ftrace/ftracetest: line 244: can't create : nonexistent directory
  /linux/tools/testing/selftests/ftrace/ftracetest: line 244: can't create : nonexistent directory
						  [FAIL]

Link: http://lkml.kernel.org/r/1415239470-28705-1-git-send-email-namhyung@kernel.org

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/selftests/ftrace/ftracetest | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index c6381a9faf83..535b98b79c29 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -218,7 +218,7 @@ trap 'SIG_RESULT=$XFAIL' $SIG_XFAIL
 # Run one test case
 run_test() { # testfile
   local testname=`basename $1`
-  local testlog=`mktemp --tmpdir=$LOG_DIR ${testname}-XXXXXX.log`
+  local testlog=`mktemp $LOG_DIR/${testname}-log.XXXXXX`
   testcase $1
   echo "execute: "$1 > $testlog
   SIG_RESULT=0
-- 
2.1.1


