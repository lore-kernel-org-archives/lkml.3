Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaCLWwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:52:21 -0400
Received: from www84.your-server.de ([213.133.104.84]:55115 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaCLWwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:52:04 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 1/3] x86, vdso32: undef CONFIG_OPTIMIZE_INLINING and CONFIG_X86_PPRO_FENCE
Date: Wed, 12 Mar 2014 23:51:18 +0100
Message-Id: <1394664680-17799-2-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394664680-17799-1-git-send-email-stefani@seibold.net>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of a 32 bit vDSO build the CONFIG_OPTIMIZE_INLINING and
CONFIG_X86_PPRO_FENCE options will increase the size of the generated
vDSO not to fit in a page.

A #undef of this config options will solve this.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vdso32/vclock_gettime.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
index ab092f7..175cc72 100644
--- a/arch/x86/vdso/vdso32/vclock_gettime.c
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -1,5 +1,11 @@
 #define BUILD_VDSO32
 
+#ifndef CONFIG_CC_OPTIMIZE_FOR_SIZE
+#undef CONFIG_OPTIMIZE_INLINING
+#endif
+
+#undef CONFIG_X86_PPRO_FENCE
+
 #ifdef CONFIG_X86_64
 
 /*
-- 
1.9.0

