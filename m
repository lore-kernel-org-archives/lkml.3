Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaJAXJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 19:09:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbaJAXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 19:09:07 -0400
Date: Thu, 2 Oct 2014 00:08:59 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86/common.c: fix build warning when
 !CONFIG_IA32_EMULATION
Message-ID: <20141001230859.GA25576@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function syscall32_cpu_init() is used only when CONFIG_IA32_EMULATION is
defined.

arch/x86/kernel/cpu/common.c:968:13: warning: 'syscall32_cpu_init' defined but not used [-Wunused-function]

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b42bd6f..b7ac5404cacf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -964,6 +964,7 @@ static void vgetcpu_set_mode(void)
 		vgetcpu_mode = VGETCPU_LSL;
 }
 
+#ifdef CONFIG_IA32_EMULATION
 /* May not be __init: called during resume */
 static void syscall32_cpu_init(void)
 {
@@ -976,6 +977,7 @@ static void syscall32_cpu_init(void)
 	wrmsrl(MSR_CSTAR, ia32_cstar_target);
 }
 #endif
+#endif
 
 #ifdef CONFIG_X86_32
 void enable_sep_cpu(void)
-- 
2.1.0
