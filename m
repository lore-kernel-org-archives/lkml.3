Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbaGVWXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:23:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaGVWXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 089/116] arm64: uid16: fix __kernel_old_{gid,uid}_t definitions
Date: Tue, 22 Jul 2014 15:21:40 -0700
Message-Id: <1406067727-19683-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/include/asm/Kbuild             |  1 -
 arch/arm64/include/uapi/asm/posix_types.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/uapi/asm/posix_types.h

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 14a9d5a..9357d33 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -27,7 +27,6 @@ generic-y += mutex.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
-generic-y += posix_types.h
 generic-y += resource.h
 generic-y += scatterlist.h
 generic-y += sections.h
diff --git a/arch/arm64/include/uapi/asm/posix_types.h b/arch/arm64/include/uapi/asm/posix_types.h
new file mode 100644
index 0000000..7985ff6
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
-- 
1.9.1

