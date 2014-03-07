Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaCGULA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:11:00 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36173 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaCGUK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:10:57 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 01/15] uprobes: Kconfig dependency fix
Date: Fri,  7 Mar 2014 15:10:26 -0500
Message-Id: <1394223040-17129-2-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Suggested change from Oleg Nesterov. Fixes incomplete dependencies
for uprobes feature.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/Kconfig         | 6 +-----
 kernel/trace/Kconfig | 1 +
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 80bbb8c..97ff872 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -86,9 +86,7 @@ config KPROBES_ON_FTRACE
 	 optimize on top of function tracing.
 
 config UPROBES
-	bool "Transparent user-space probes (EXPERIMENTAL)"
-	depends on UPROBE_EVENT && PERF_EVENTS
-	default n
+	def_bool n
 	select PERCPU_RWSEM
 	help
 	  Uprobes is the user-space counterpart to kprobes: they
@@ -101,8 +99,6 @@ config UPROBES
 	    managed by the kernel and kept transparent to the probed
 	    application. )
 
-	  If in doubt, say "N".
-
 config HAVE_64BIT_ALIGNED_ACCESS
 	def_bool 64BIT && !HAVE_EFFICIENT_UNALIGNED_ACCESS
 	help
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 015f85a..8639819 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -424,6 +424,7 @@ config UPROBE_EVENT
 	bool "Enable uprobes-based dynamic events"
 	depends on ARCH_SUPPORTS_UPROBES
 	depends on MMU
+	depends on PERF_EVENTS
 	select UPROBES
 	select PROBE_EVENTS
 	select TRACING
-- 
1.8.1.2

