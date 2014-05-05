Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaEEMqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:46:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41068 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932338AbaEEMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 46/50] sparc32: fix build failure for arch_jump_label_transform
Date: Mon,  5 May 2014 14:43:28 +0200
Message-Id: <50aa539f0ea40ff117cc7ff263ed71bb9f2c4d86.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 78c4fdb91bc5..4e5683877b93 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -25,7 +25,7 @@ config SPARC
 	select RTC_DRV_M48T59
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
-	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_ARCH_JUMP_LABEL if SPARC64
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select USE_GENERIC_SMP_HELPERS if SMP
-- 
1.9.2

