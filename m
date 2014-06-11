Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaFKUPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbaFKUPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:15:16 -0400
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: fix build error in sigcontext.h
Date: Wed, 11 Jun 2014 16:14:42 -0400
Message-Id: <1402517682-13061-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this build failure for arm64:

    CC [M]  Documentation/filesystems/configfs/configfs_example_macros.o
  In file included from /usr/include/bits/sigcontext.h:27:0,
                   from /usr/include/signal.h:340,
                   from /usr/include/sys/wait.h:30,
                   from Documentation/accounting/getdelays.c:24:
  .../linux/usr/include/asm/sigcontext.h:61:2: error: unknown type name ‘u64’
    u64 esr;
    ^
  make[2]: *** [Documentation/accounting/getdelays] Error 1

This was introduced by commit 15af1942dd61ee23:

  arm64: Expose ESR_EL1 information to user when SIGSEGV/SIGBUS

Using __u64 instead of u64 fixes the problem.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/include/uapi/asm/sigcontext.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
index b72cf40..ee469be 100644
--- a/arch/arm64/include/uapi/asm/sigcontext.h
+++ b/arch/arm64/include/uapi/asm/sigcontext.h
@@ -58,7 +58,7 @@ struct fpsimd_context {
 
 struct esr_context {
 	struct _aarch64_ctx head;
-	u64 esr;
+	__u64 esr;
 };
 
 #endif /* _UAPI__ASM_SIGCONTEXT_H */
-- 
1.9.0

