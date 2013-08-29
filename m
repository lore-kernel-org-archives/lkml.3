Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3H2ONR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:13:17 -0400
Received: from mout.gmx.net ([212.227.17.21]:56053 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab3H2ONQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:13:16 -0400
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>,
        Doug Covelli <dcovelli@vmware.com>, Dan Hecht <dhecht@vmware.com>,
        linux-kernel@vger.kernel.org, "'Jiri Kosina'" <trivial@kernel.org>
Subject: [PATCH] [TRIVIAL] Remove braces in arch/x86/kernel/cpu/vmware.c to fix build for clang. No functional change otherwise.
Date: Thu, 29 Aug 2013 16:11:37 +0200
Message-ID: <1618980.7O7jUTFqi5@aragorn.auenland.lan>
User-Agent: KMail/4.11 (Linux/3.7.10-1.16-default; KDE/4.11.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:itTwNC3jDdckOfMQ0MUL3bJehVxAFGOochSWfmupcLWhKirAisQ
 68RvEReDKeX3mqV5mDaChUqiygbvjl7iNvTZZaDWWucoBR9T7KgcdJtBhZ6W4j1rDdqsazo
 d+jN5zWtBFoNDPZ230b3sK5FNVa/BSKoN8hYhbn7a0Lg1YlerFqbEDElNTl+krH0sbCY66U
 YTnT1YkvkJZEQ60H9e11g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Author:  PaX Team <pageexec at freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon Möller <dl9pf at gmx.de>

Description:
  Clang chokes on the notation "inl (%dx)" but works for "inl %dx";
  GNU as accepts both forms.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

CC: Jan-Simon Möller <dl9pf@gmx.de>
CC: PaX Team <pageexec@freemail.hu>
CC: Behan Webster <behanw@converseincode.com>
CC: Doug Covelli <dcovelli@vmware.com>
CC: Dan Hecht <dhecht@vmware.com>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/cpu/vmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 628a059..32ef12c 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -38,7 +38,7 @@
 #define VMWARE_PORT_CMD_VCPU_RESERVED	31
 
 #define VMWARE_PORT(cmd, eax, ebx, ecx, edx)				\
-	__asm__("inl (%%dx)" :						\
+	__asm__("inl %%dx" :						\
 			"=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :	\
 			"0"(VMWARE_HYPERVISOR_MAGIC),			\
 			"1"(VMWARE_PORT_CMD_##cmd),			\
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
