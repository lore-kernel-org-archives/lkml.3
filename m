Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaF1SGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:06:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaF1Rwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.15 103/139] arm64: uid16: fix __kernel_old_{gid,uid}_t definitions
Date: Sat, 28 Jun 2014 10:47:44 -0700
Message-Id: <20140628174610.122412440@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 34c65c43f1518bf85f93526ad373adc6a683b4c5 upstream.

Whilst native arm64 applications don't have the 16-bit UID/GID syscalls
wired up, compat tasks can still access them. The 16-bit wrappers for
these syscalls use __kernel_old_uid_t and __kernel_old_gid_t, which must
be 16-bit data types to maintain compatibility with the 16-bit UIDs used
by compat applications.

This patch defines 16-bit __kernel_old_{gid,uid}_t types for arm64
instead of using the 32-bit types provided by asm-generic.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/Kbuild             |    1 -
 arch/arm64/include/uapi/asm/posix_types.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -30,7 +30,6 @@ generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += pci.h
 generic-y += poll.h
-generic-y += posix_types.h
 generic-y += preempt.h
 generic-y += resource.h
 generic-y += rwsem.h
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/posix_types.h
@@ -0,0 +1,10 @@
+#ifndef __ASM_POSIX_TYPES_H
+#define __ASM_POSIX_TYPES_H
+
+typedef unsigned short __kernel_old_uid_t;
+typedef unsigned short __kernel_old_gid_t;
+#define __kernel_old_uid_t __kernel_old_uid_t
+
+#include <asm-generic/posix_types.h>
+
+#endif /*  __ASM_POSIX_TYPES_H */


