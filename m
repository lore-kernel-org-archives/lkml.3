Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaIBR7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:59:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbaIBR7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:59:45 -0400
Date: Tue, 2 Sep 2014 19:57:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha <sbsiddha@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Bean Anderson <bean@azulsystems.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] x86, fpu: change __thread_fpu_begin() to use
	use_eager_fpu()
Message-ID: <20140902175720.GA21656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902175654.GA21626@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__thread_fpu_begin() checks X86_FEATURE_EAGER_FPU by hand, we have
a helper for that.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
---
 arch/x86/include/asm/fpu-internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index e3b8542..37506df 100644
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

