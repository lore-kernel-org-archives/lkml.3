Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3KFVOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:14:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42401 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab3KFVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:14:49 -0500
Date: Wed, 6 Nov 2013 13:13:52 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: make OABI default to off
Message-ID: <20131106211352.GA24006@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given recent discussions about the lack of OABI in the wild, switch
CONFIG_OABI_COMPAT to off-by-default to encourage more system builders
to avoid it.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6c094d..4ace7f33e8a1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1728,7 +1728,7 @@ config AEABI
 config OABI_COMPAT
 	bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
 	depends on AEABI && !THUMB2_KERNEL
-	default y
+	default n
 	help
 	  This option preserves the old syscall interface along with the
 	  new (ARM EABI) one. It also provides a compatibility layer to
@@ -1740,7 +1740,7 @@ config OABI_COMPAT
 	  can say N here. If this option is not selected and you attempt
 	  to execute a legacy ABI binary then the result will be
 	  UNPREDICTABLE (in fact it can be predicted that it won't work
-	  at all). If in doubt say Y.
+	  at all). If in doubt say N.
 
 config ARCH_HAS_HOLES_MEMORYMODEL
 	bool
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
