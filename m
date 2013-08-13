Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab3HMUU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:20:29 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13013 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759050Ab3HMUUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:20:25 -0400
Message-ID: <201308132020.r7DKKOxG022747@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 13 Aug 2013 14:42:36 -0400
Subject: [PATCH] tile: check for correct compiler earlier in asm-offsets.c
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we wait until after including a bunch of other files, we
will have generated so much warning spew that it's hard to
notice the error about using the wrong compiler.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/asm-offsets.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/tile/kernel/asm-offsets.c b/arch/tile/kernel/asm-offsets.c
index 0a04a16..80877ff 100644
--- a/arch/tile/kernel/asm-offsets.c
+++ b/arch/tile/kernel/asm-offsets.c
@@ -14,16 +14,6 @@
  * Generates definitions from c-type structures used by assembly sources.
  */
 
-#include <linux/kbuild.h>
-#include <linux/thread_info.h>
-#include <linux/sched.h>
-#include <linux/hardirq.h>
-#include <linux/ptrace.h>
-#include <hv/hypervisor.h>
-#ifdef CONFIG_KVM
-#include <linux/kvm_host.h>
-#endif
-
 /* Check for compatible compiler early in the build. */
 #ifdef CONFIG_TILEGX
 # ifndef __tilegx__
@@ -34,10 +24,20 @@
 # endif
 #else
 # ifdef __tilegx__
-#  error Can not build TILEPro/TILE64 configurations with tilegx compiler
+#  error Can not build TILEPro configurations with tilegx compiler
 # endif
 #endif
 
+#include <linux/kbuild.h>
+#include <linux/thread_info.h>
+#include <linux/sched.h>
+#include <linux/hardirq.h>
+#include <linux/ptrace.h>
+#include <hv/hypervisor.h>
+#ifdef CONFIG_KVM
+#include <linux/kvm_host.h>
+#endif
+
 void foo(void)
 {
 	DEFINE(SINGLESTEP_STATE_BUFFER_OFFSET,
-- 
1.8.3.1

