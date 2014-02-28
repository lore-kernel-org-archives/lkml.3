Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaB1OCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:02:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:35355 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbaB1OCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:02:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,562,1389772800"; 
   d="scan'208";a="491576474"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 2/2] perf, tools, probe: Clarify x86 register naming for perf probe
Date: Fri, 28 Feb 2014 06:02:15 -0800
Message-Id: <1393596135-4227-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393596135-4227-1-git-send-email-andi@firstfloor.org>
References: <1393596135-4227-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Clarify how to specify x86 registers in perf probe. I recently
ran into this problem and had to figure it out from the source.

Cc: masami.hiramatsu.pt@hitachi.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
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
-- 
1.8.5.3

