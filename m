Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaICVUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:45 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35715 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbaICVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 08/24] Allow a 32bit ABI to use the naming of the 64bit ABI syscalls to avoid confusion of not splitting the registers
Date: Wed,  3 Sep 2014 14:19:02 -0700
Message-Id: <1409779158-30963-9-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the ARM64 ILP32 case, we want to say the syscalls that normally would pass
64bit as two arguments are now passing as one so want to use the 64bit
naming scheme.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 include/uapi/asm-generic/unistd.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 11d11bc..a7984a0 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -881,8 +881,12 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
  * they take different names.
  * Here we map the numbers so that both versions
  * use the same syscall table layout.
+ * For 32bit abis where 64bit can be passed via one
+ * register, use the same naming as the 64bit ones
+ * as they will only have a 64 bit off_t.
  */
-#if __BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)
+#if (__BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)) || \
+	defined(__ARCH_WANT_64BIT_SYSCALLS)
 #define __NR_fcntl __NR3264_fcntl
 #define __NR_statfs __NR3264_statfs
 #define __NR_fstatfs __NR3264_fstatfs
-- 
1.7.2.5

