Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaCNVao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:30:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54002 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaCNVaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/16] perf probe: Clarify x86 register naming for perf probe
Date: Fri, 14 Mar 2014 18:29:59 -0300
Message-Id: <1394832610-17818-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Clarify how to specify x86 registers in perf probe. I recently ran into
this problem and had to figure it out from the source.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1393596135-4227-3-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index b715cb71592b..1513935c399b 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -136,6 +136,8 @@ Each probe argument follows below syntax.
 'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), local array with fixed index (e.g. array[1], var->array[0], var->pointer[2]), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
 'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo. You can specify 'string' type only for the local variable or structure member which is an array of or a pointer to 'char' or 'unsigned char' type.
 
+On x86 systems %REG is always the short form of the register: for example %AX. %RAX or %EAX is not valid.
+
 LINE SYNTAX
 -----------
 Line range is described by following syntax.
-- 
1.8.1.4

