Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaJ1Dix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:38:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaJ1Div (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:38:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.17 069/146] arm64: Fix compilation error on UP builds
Date: Tue, 28 Oct 2014 11:33:31 +0800
Message-Id: <20141028033346.374601462@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit ceab3fe69408cb98f437dad3b4b4bb79434370ef upstream.

In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
        from include/linux/irq_work.h:46,
        from include/linux/perf_event.h:49,
        from include/linux/ftrace_event.h:9,
        from include/trace/syscall.h:6,
        from include/linux/syscalls.h:81,
        from init/main.c:18:
./arch/arm64/include/asm/smp.h:24:3:
        error: #error "<asm/smp.h> included in non-SMP build"
 # error "<asm/smp.h> included in non-SMP build"

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 3631073659d0 ("arm64: Tell irq work about self IPI support")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/irq_work.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/include/asm/irq_work.h
+++ b/arch/arm64/include/asm/irq_work.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_IRQ_WORK_H
 #define __ASM_IRQ_WORK_H
 
+#ifdef CONFIG_SMP
+
 #include <asm/smp.h>
 
 static inline bool arch_irq_work_has_interrupt(void)
@@ -8,4 +10,13 @@ static inline bool arch_irq_work_has_int
 	return !!__smp_cross_call;
 }
 
+#else
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return false;
+}
+
+#endif
+
 #endif /* __ASM_IRQ_WORK_H */


