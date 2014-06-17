Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaFQKVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:21:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36799 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbaFQKVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:21:10 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] x86, xsave: Add forgotten inline annotation
Date: Tue, 17 Jun 2014 12:21:08 +0200
Message-Id: <1403000468-30094-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

.. and shut up a bunch of those:

In file included from arch/x86/crypto/camellia_aesni_avx_glue.c:23:0:
./arch/x86/include/asm/xsave.h:73:12: warning: ‘xsave_state_booting’ defined but not used [-Wunused-function]
 static int xsave_state_booting(struct xsave_struct *fx, u64 mask)
            ^
In file included from arch/x86/crypto/camellia_aesni_avx2_glue.c:23:0:
./arch/x86/include/asm/xsave.h:73:12: warning: ‘xsave_state_booting’ defined but not used [-Wunused-function]
 static int xsave_state_booting(struct xsave_struct *fx, u64 mask)
            ^
...

Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/xsave.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index bbebd6e0a9ce..7e7a79ada658 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -70,7 +70,7 @@ extern int init_fpu(struct task_struct *child);
  * This function is called only during boot time when x86 caps are not set
  * up and alternative can not be used yet.
  */
-static int xsave_state_booting(struct xsave_struct *fx, u64 mask)
+static inline int xsave_state_booting(struct xsave_struct *fx, u64 mask)
 {
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
-- 
2.0.0

