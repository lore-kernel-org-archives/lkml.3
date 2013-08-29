Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3H2Umw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:42:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42280 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3H2Umu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:42:50 -0400
Date: Thu, 29 Aug 2013 13:42:35 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-f69fa9a91f60fff6f2d8b658b7d84d235d9d89b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dl9pf@gmx.de, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dl9pf@gmx.de, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1377803585-5913-3-git-send-email-dl9pf@gmx.de>
References: <1377803585-5913-3-git-send-email-dl9pf@gmx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, doc:
  Update uaccess.h comment to reflect clang changes
Git-Commit-ID: f69fa9a91f60fff6f2d8b658b7d84d235d9d89b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 13:42:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f69fa9a91f60fff6f2d8b658b7d84d235d9d89b7
Gitweb:     http://git.kernel.org/tip/f69fa9a91f60fff6f2d8b658b7d84d235d9d89b7
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 29 Aug 2013 13:34:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Aug 2013 13:34:50 -0700

x86, doc: Update uaccess.h comment to reflect clang changes

Update comment in uaccess.h to reflect the changes for clang support:
gcc only cares about the base register (most architectures don't
encode the size of the operation in the operands like x86 does, and so
it is treated effectively like a register number), whereas clang tries
to enforce the size -- but not for register pairs.

Link: http://lkml.kernel.org/r/1377803585-5913-3-git-send-email-dl9pf@gmx.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/x86/include/asm/uaccess.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index f715fee..5838fa9 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -153,11 +153,14 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
  * Careful: we have to cast the result to the type of the pointer
  * for sign reasons.
  *
- * The use of %edx as the register specifier is a bit of a
+ * The use of _ASM_DX as the register specifier is a bit of a
  * simplification, as gcc only cares about it as the starting point
  * and not size: for a 64-bit value it will use %ecx:%edx on 32 bits
  * (%ecx being the next register in gcc's x86 register sequence), and
  * %rdx on 64 bits.
+ *
+ * Clang/LLVM cares about the size of the register, but still wants
+ * the base register for something that ends up being a pair.
  */
 #define get_user(x, ptr)						\
 ({									\
