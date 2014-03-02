Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaCBJWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:22:00 -0500
Received: from www84.your-server.de ([213.133.104.84]:48039 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaCBJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:20:57 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v21 07/12] introduce VVAR marco for vdso32
Date: Sun,  2 Mar 2014 10:20:15 +0100
Message-Id: <1393752020-6740-8-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393752020-6740-1-git-send-email-stefani@seibold.net>
References: <1393752020-6740-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch revamp the vvar.h for introduce the VVAR macro for vdso32.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/vvar.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 0a534ea..52c79ff 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -26,6 +26,15 @@
 
 #else
 
+#ifdef BUILD_VDSO32
+
+#define DECLARE_VVAR(offset, type, name)				\
+	extern type vvar_ ## name __attribute__((visibility("hidden")));
+
+#define VVAR(name) (vvar_ ## name)
+
+#else
+
 extern char __vvar_page;
 
 /* Base address of vvars.  This is not ABI. */
@@ -39,12 +48,13 @@ extern char __vvar_page;
 	static type const * const vvaraddr_ ## name =			\
 		(void *)(VVAR_ADDRESS + (offset));
 
+#define VVAR(name) (*vvaraddr_ ## name)
+#endif
+
 #define DEFINE_VVAR(type, name)						\
 	type name							\
 	__attribute__((section(".vvar_" #name), aligned(16))) __visible
 
-#define VVAR(name) (*vvaraddr_ ## name)
-
 #endif
 
 /* DECLARE_VVAR(offset, type, name) */
-- 
1.9.0

