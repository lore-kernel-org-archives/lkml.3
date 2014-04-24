Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaDXVxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:53:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbaDXVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:53:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 19/27] sparc32: fix build failure for arch_jump_label_transform
Date: Thu, 24 Apr 2014 14:55:53 -0700
Message-Id: <20140424215552.545886758@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424215551.942390050@linuxfoundation.org>
References: <20140424215551.942390050@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


