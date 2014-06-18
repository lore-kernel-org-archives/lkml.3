Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaFRWWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:22:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51494 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaFRWWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:22:42 -0400
Date: Wed, 18 Jun 2014 15:22:09 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-d0f2dd186133a0241a2ccefb188a0e49e8187859@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, bp@suse.de,
        hpa@linux.intel.com
In-Reply-To: <1403000468-30094-1-git-send-email-bp@alien8.de>
References: <1403000468-30094-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Add forgotten inline annotation
Git-Commit-ID: d0f2dd186133a0241a2ccefb188a0e49e8187859
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

Commit-ID:  d0f2dd186133a0241a2ccefb188a0e49e8187859
Gitweb:     http://git.kernel.org/tip/d0f2dd186133a0241a2ccefb188a0e49e8187859
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 17 Jun 2014 12:21:08 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 18 Jun 2014 15:19:59 -0700

x86, xsave: Add forgotten inline annotation

Add a missing inline annotation on a static function, in order to shut
up a bunch of warnings like:

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
Link: http://lkml.kernel.org/r/1403000468-30094-1-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xsave.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index bbebd6e..7e7a79a 100644
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
