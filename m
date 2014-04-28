Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaD1BcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42856 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.968600797@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 18/94] sparc32: fix build failure for arch_jump_label_transform
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

[ Upstream commit 4f6500fff5f7644a03c46728fd7ef0f62fa6940b ]

In arch/sparc/Kernel/Makefile, we see:

   obj-$(CONFIG_SPARC64)   += jump_label.o

However, the Kconfig selects HAVE_ARCH_JUMP_LABEL unconditionally
for all SPARC.  This in turn leads to the following failure when
doing allmodconfig coverage builds:

kernel/built-in.o: In function `__jump_label_update':
jump_label.c:(.text+0x8560c): undefined reference to `arch_jump_label_transform'
kernel/built-in.o: In function `arch_jump_label_transform_static':
(.text+0x85cf4): undefined reference to `arch_jump_label_transform'
make: *** [vmlinux] Error 1

Change HAVE_ARCH_JUMP_LABEL to be conditional on SPARC64 so that it
matches the Makefile.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 87537e2..88d442d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -24,7 +24,7 @@ config SPARC
 	select HAVE_IRQ_WORK
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
-	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_ARCH_JUMP_LABEL if SPARC64
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select USE_GENERIC_SMP_HELPERS if SMP

