Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3JKXH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:07:57 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61810 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab3JKXHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:07:55 -0400
Date: Fri, 11 Oct 2013 16:07:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@linux.intel.com>
cc: "K. Y. Srinivasan" <kys@microsoft.com>, Olaf Hering <olaf@aepfle.de>,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: [patch x86/hyperv] x86, hyperv: Fix build error
In-Reply-To: <tip-9e7827b5ea4ca93b4d864bc07c0fafb838d496b1@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1310111604160.31170@chino.kir.corp.google.com>
References: <1380554932-9888-1-git-send-email-olaf@aepfle.de> <tip-9e7827b5ea4ca93b4d864bc07c0fafb838d496b1@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9e7827b5ea4c ("x86, hyperv: Get the local APIC timer frequency from the 
hypervisor") breaks the build with some configs because apic.h isn't 
directly included:

arch/x86/kernel/cpu/mshyperv.c: In function 'ms_hyperv_init_platform':
arch/x86/kernel/cpu/mshyperv.c:90:3: error: 'lapic_timer_frequency' undeclared (first use in this function)
arch/x86/kernel/cpu/mshyperv.c:90:3: note: each undeclared identifier is reported only once for each function it appears in

Fix it by including asm/apic.h.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -25,6 +25,7 @@
 #include <asm/idle.h>
 #include <asm/irq_regs.h>
 #include <asm/i8259.h>
+#include <asm/apic.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
