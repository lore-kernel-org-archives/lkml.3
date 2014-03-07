Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaCGULD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:11:03 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62587 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaCGULB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:11:01 -0500
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
Subject: [PATCH v7 02/15] ARM: Fix missing includes in kprobes sources
Date: Fri,  7 Mar 2014 15:10:27 -0500
Message-Id: <1394223040-17129-3-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Make sure includes in ARM kprobes sources are done explicitly. Do not
rely on includes from other includes.

Signed-off-by: David A. Long <dave.long@linaro.org>
Acked-by: Jon Medhurst <tixy@linaro.org>
---
 arch/arm/include/asm/kprobes.h     | 2 +-
 arch/arm/kernel/kprobes-common.c   | 3 +++
 arch/arm/kernel/kprobes-test-arm.c | 1 +
 arch/arm/kernel/kprobes-test.c     | 4 +++-
 arch/arm/kernel/kprobes.c          | 2 ++
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index f82ec22..fd2e5ca 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -18,7 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/ptrace.h>
-#include <linux/percpu.h>
+#include <linux/notifier.h>
 
 #define __ARCH_WANT_KPROBES_INSN_SLOT
 #define MAX_INSN_SIZE			2
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 18a7628..455c800 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -14,6 +14,9 @@
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <asm/system_info.h>
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/bug.h>
 
 #include "kprobes.h"
 
diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index 8393129..87839de 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/kernel/kprobes-test-arm.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <asm/system_info.h>
 
 #include "kprobes-test.h"
 
diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 0cd63d0..4a774d4 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -201,7 +201,9 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/kprobes.h>
-
+#include <linux/errno.h>
+#include <linux/stddef.h>
+#include <linux/bug.h>
 #include <asm/opcodes.h>
 
 #include "kprobes.h"
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index a7b621e..54e7b46 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -27,6 +27,8 @@
 #include <linux/stringify.h>
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
+#include <linux/percpu.h>
+#include <linux/bug.h>
 
 #include "kprobes.h"
 #include "patch.h"
-- 
1.8.1.2

