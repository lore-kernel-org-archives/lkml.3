Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3IHDT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56041 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab3IHDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Richard Kuo" <rkuo@codeaurora.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.55222056@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [098/121] Hexagon: misc compile warning/error cleanup due to
 missing headers
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Kuo <rkuo@codeaurora.org>

commit 6bbbc30ce6b0ae428575c8af7c2a6c342c534e19 upstream.

Fixed warnings/errors for EXPORT_SYMBOL, linux_binprm, elf related
defines

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/hexagon/kernel/dma.c    | 1 +
 arch/hexagon/kernel/ptrace.c | 1 +
 arch/hexagon/kernel/time.c   | 1 +
 arch/hexagon/kernel/vdso.c   | 1 +
 4 files changed, 4 insertions(+)

--- a/arch/hexagon/kernel/dma.c
+++ b/arch/hexagon/kernel/dma.c
@@ -22,6 +22,7 @@
 #include <linux/bootmem.h>
 #include <linux/genalloc.h>
 #include <asm/dma-mapping.h>
+#include <linux/module.h>
 
 struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
--- a/arch/hexagon/kernel/ptrace.c
+++ b/arch/hexagon/kernel/ptrace.c
@@ -28,6 +28,7 @@
 #include <linux/ptrace.h>
 #include <linux/regset.h>
 #include <linux/user.h>
+#include <linux/elf.h>
 
 #include <asm/system.h>
 #include <asm/user.h>
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -28,6 +28,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/module.h>
 
 #include <asm/timer-regs.h>
 #include <asm/hexagon_vm.h>
--- a/arch/hexagon/kernel/vdso.c
+++ b/arch/hexagon/kernel/vdso.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/binfmts.h>
 
 #include <asm/vdso.h>
 

