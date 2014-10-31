Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbaJaKzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:55:39 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47835 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbaJaKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:55:36 -0400
Subject: [PATCH perf/core 2/6] [DOC] perf-probe: Update perf-probe document
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 31 Oct 2014 14:51:43 -0400
Message-ID: <20141031185142.27889.6591.stgit@localhost.localdomain>
In-Reply-To: <20141031185128.27889.32747.stgit@localhost.localdomain>
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Documentation/perf-probe.txt to add descriptions
of some newer options.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/Documentation/perf-probe.txt |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index aaa869b..239609c 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -47,6 +47,12 @@ OPTIONS
 -v::
 --verbose::
         Be more verbose (show parsed arguments, etc).
+	Can not use with -q.
+
+-q::
+--quiet::
+	Be quiet (do not show any messages including errors).
+	Can not use with -v.
 
 -a::
 --add=::
@@ -96,7 +102,7 @@ OPTIONS
 	Dry run. With this option, --add and --del doesn't execute actual
 	adding and removal operations.
 
---max-probes::
+--max-probes=NUM::
 	Set the maximum number of probe points for an event. Default is 128.
 
 -x::
@@ -104,8 +110,13 @@ OPTIONS
 	Specify path to the executable or shared library file for user
 	space tracing. Can also be used with --funcs option.
 
+--demangle::
+	Demangle application symbols. --no-demangle is also available
+	for disabling demangling.
+
 --demangle-kernel::
-	Demangle kernel symbols.
+	Demangle kernel symbols. --no-demangle-kernel is also available
+	for disabling kernel demangling.
 
 In absence of -m/-x options, perf probe checks if the first argument after
 the options is an absolute path name. If its an absolute path, perf probe
@@ -137,6 +148,7 @@ Each probe argument follows below syntax.
  [NAME=]LOCALVAR|$retval|%REG|@SYMBOL[:TYPE]
 
 'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), local array with fixed index (e.g. array[1], var->array[0], var->pointer[2]), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
+'$vars' special argument is also available for NAME, it is expanded to the local variables which can access at given probe point.
 'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo. You can specify 'string' type only for the local variable or structure member which is an array of or a pointer to 'char' or 'unsigned char' type.
 
 On x86 systems %REG is always the short form of the register: for example %AX. %RAX or %EAX is not valid.


