Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911AbaH0SyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:54:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884AbaH0SyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:54:20 -0400
Date: Wed, 27 Aug 2014 20:51:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86, fpu: change __thread_fpu_begin() to use
	use_eager_fpu()
Message-ID: <20140827185154.GA12505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827185138.GA12487@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__thread_fpu_begin() checks X86_FEATURE_EAGER_FPU by hand, we have
a helper for that.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index b0537b9..4cbb40e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -344,7 +344,7 @@ static inline void __thread_fpu_end(struct task_struct *tsk)
 
 static inline void __thread_fpu_begin(struct task_struct *tsk)
 {
-	if (!static_cpu_has_safe(X86_FEATURE_EAGER_FPU))
+	if (!use_eager_fpu())
 		clts();
 	__thread_set_has_fpu(tsk);
 }
-- 
1.5.5.1

