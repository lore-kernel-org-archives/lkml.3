Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbaCRV3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:29:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbaCRV3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:29:38 -0400
Date: Tue, 18 Mar 2014 14:29:00 -0700
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-ef721987aef0cc0abba08c88810f2155f76b0b1f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1395094933-14252-8-git-send-email-stefani@seibold.net>
References: <1395094933-14252-8-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Introduce VVAR marco for vdso32
Git-Commit-ID: ef721987aef0cc0abba08c88810f2155f76b0b1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef721987aef0cc0abba08c88810f2155f76b0b1f
Gitweb:     http://git.kernel.org/tip/ef721987aef0cc0abba08c88810f2155f76b0b1f
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon, 17 Mar 2014 23:22:07 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Mar 2014 12:52:29 -0700

x86, vdso: Introduce VVAR marco for vdso32

This patch revamps the vvar.h for introduce the VVAR macro for vdso32.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1395094933-14252-8-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
