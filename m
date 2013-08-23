Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3HWLh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:37:59 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753861Ab3HWLh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:37:58 -0400
From: Richard Weinberger <richard@nod.at>
To: richard@nod.at
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        david.oberhollenzer@tele2.at
Subject: [PATCH] um: prctl: Do not include linux/ptrace.h
Date: Fri, 23 Aug 2013 13:37:49 +0200
Message-Id: <1377257869-23373-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On recent toolchains we hit:
In file included from arch/x86/um/os-Linux/prctl.c:7:0:
/usr/include/linux/ptrace.h:58:8: error: redefinition of ‘struct
ptrace_peeksiginfo_args’ struct ptrace_peeksiginfo_args {
        ^
In file included from arch/x86/um/os-Linux/prctl.c:6:0:
/usr/include/sys/ptrace.h:191:8: note: originally defined here
 struct ptrace_peeksiginfo_args
        ^
make[2]: *** [arch/x86/um/os-Linux/prctl.o] Error 1
make[1]: *** [arch/x86/um/os-Linux] Error 2
make: *** [arch/x86/um] Error 2

The solution is not to include linux/ptrace.h and obtain
the arch specific ptrace command from asm/ptrace.h.

Reported-by: David Oberhollenzer <david.oberhollenzer@tele2.at>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/um/os-Linux/prctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/um/os-Linux/prctl.c b/arch/x86/um/os-Linux/prctl.c
index 9d34edd..96eb2bd 100644
--- a/arch/x86/um/os-Linux/prctl.c
+++ b/arch/x86/um/os-Linux/prctl.c
@@ -4,7 +4,7 @@
  */
 
 #include <sys/ptrace.h>
-#include <linux/ptrace.h>
+#include <asm/ptrace.h>
 
 int os_arch_prctl(int pid, int code, unsigned long *addr)
 {
-- 
1.8.1.4

