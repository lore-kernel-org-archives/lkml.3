Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaDRWU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:20:27 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39420 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaDRWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:20:17 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH v2 1/7] x86: move FIX_EARLYCON_MEM kconfig into x86
Date: Fri, 18 Apr 2014 17:19:54 -0500
Message-Id: <1397859600-11507-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

In preparation to support FIX_EARLYCON_MEM on other arches, make the
option per arch.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/Kconfig                | 3 +++
 drivers/tty/serial/8250/Kconfig | 5 -----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..0fb6cfd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -261,6 +261,9 @@ config ARCH_HWEIGHT_CFLAGS
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
+config FIX_EARLYCON_MEM
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 2332991..91f1d83 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -90,11 +90,6 @@ config SERIAL_8250_CONSOLE
 
 	  If unsure, say N.
 
-config FIX_EARLYCON_MEM
-	bool
-	depends on X86
-	default y
-
 config SERIAL_8250_GSC
 	tristate
 	depends on SERIAL_8250 && GSC
-- 
1.9.1

