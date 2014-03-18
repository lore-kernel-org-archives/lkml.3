Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaCRI3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:29:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaCRI3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:29:23 -0400
Date: Tue, 18 Mar 2014 01:29:06 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-5b4398209d646635a4d84c46a5c7193fbce1a07c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1393596135-4227-3-git-send-email-andi@firstfloor.org>
References: <1393596135-4227-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Clarify x86 register naming for perf probe
Git-Commit-ID: 5b4398209d646635a4d84c46a5c7193fbce1a07c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b4398209d646635a4d84c46a5c7193fbce1a07c
Gitweb:     http://git.kernel.org/tip/5b4398209d646635a4d84c46a5c7193fbce1a07c
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 28 Feb 2014 06:02:15 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 11:20:44 -0300

perf probe: Clarify x86 register naming for perf probe

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
index b715cb7..1513935 100644
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
