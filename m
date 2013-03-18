Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3CREbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33622 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab3CREa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:58 -0400
Message-Id: <20130318042148.213970439@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:25 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Steven Rostedt <srostedt@redhat.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 41/82] ftrace: Update the kconfig for DYNAMIC_FTRACE
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/Kconfig |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -386,24 +386,28 @@ config KPROBE_EVENT
 	  If you want to use perf tools, this option is strongly recommended.
 
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


