Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaEXHFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:05:40 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54955 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaEXHCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:24 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 08/24] Allow a 32bit ABI to use the naming of the 64bit ABI syscalls to avoid confusion of not splitting the registers.
Date: Sat, 24 May 2014 00:02:03 -0700
Message-Id: <1400914939-9708-9-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
To: linux-arch@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the ARM64 ILP32 case, we want to say the syscalls that normally would pass 64bit as two arguments are now passing as one so want to use the 64bit naming scheme.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 include/uapi/asm-generic/unistd.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 3336406..0648659 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -875,8 +875,11 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
  * they take different names.
  * Here we map the numbers so that both versions
  * use the same syscall table layout.
+ * For 32bit abis where 64bit can be passed via one
+ * register, use the same naming as the 64bit ones
+ * as they will only have a 64 bit off_t.
  */
-#if __BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)
+#if (__BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)) || defined(__SYSCALL_NONCOMPAT)
 #define __NR_fcntl __NR3264_fcntl
 #define __NR_statfs __NR3264_statfs
 #define __NR_fstatfs __NR3264_fstatfs
-- 
1.7.2.5

