Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3CNKiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:38:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52066 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab3CNKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 74/88] ftrace: Update the kconfig for DYNAMIC_FTRACE
Date: Thu, 14 Mar 2013 10:36:07 +0000
Message-Id: <1363257381-15900-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit db05021d49a994ee40a9735d9c3cb0060c9babb8 upstream.

The prompt to enable DYNAMIC_FTRACE (the ability to nop and
enable function tracing at run time) had a confusing statement:

 "enable/disable ftrace tracepoints dynamically"

This was written before tracepoints were added to the kernel,
but now that tracepoints have been added, this is very confusing
and has confused people enough to give wrong information during
presentations.

Not only that, I looked at the help text, and it still references
that dreaded daemon that use to wake up once a second to update
the nop locations and brick NICs, that hasn't been around for over
five years.

Time to bring the text up to the current decade.

Reported-by: Ezequiel Garcia <elezegarcia@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ rostedt: adjust context for stable ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/Kconfig | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8c4c070..e222233 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -405,24 +405,28 @@ config PROBE_EVENTS
 	def_bool n
 
 config DYNAMIC_FTRACE
-	bool "enable/disable ftrace tracepoints dynamically"
+	bool "enable/disable function tracing dynamically"
 	depends on FUNCTION_TRACER
 	depends on HAVE_DYNAMIC_FTRACE
 	default y
 	help
-          This option will modify all the calls to ftrace dynamically
-	  (will patch them out of the binary image and replace them
-	  with a No-Op instruction) as they are called. A table is
-	  created to dynamically enable them again.
+	  This option will modify all the calls to function tracing
+	  dynamically (will patch them out of the binary image and
+	  replace them with a No-Op instruction) on boot up. During
+	  compile time, a table is made of all the locations that ftrace
+	  can function trace, and this table is linked into the kernel
+	  image. When this is enabled, functions can be individually
+	  enabled, and the functions not enabled will not affect
+	  performance of the system.
+
+	  See the files in /sys/kernel/debug/tracing:
+	    available_filter_functions
+	    set_ftrace_filter
+	    set_ftrace_notrace
 
 	  This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but
 	  otherwise has native performance as long as no tracing is active.
 
-	  The changes to the code are done by a kernel thread that
-	  wakes up once a second and checks to see if any ftrace calls
-	  were made. If so, it runs stop_machine (stops all CPUS)
-	  and modifies the code to jump over the call to ftrace.
-
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
-- 
1.8.1.2

