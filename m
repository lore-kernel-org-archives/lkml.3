Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaIBWTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:19:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbaIBWTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:19:16 -0400
Date: Tue, 2 Sep 2014 15:19:01 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-31d963389f67165402aa447a8e8ce5ffb9188b3d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sbsiddha@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sbsiddha@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        hpa@linux.intel.com
In-Reply-To: <20140902175720.GA21656@redhat.com>
References: <20140902175720.GA21656@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Change __thread_fpu_begin()
  to use use_eager_fpu()
Git-Commit-ID: 31d963389f67165402aa447a8e8ce5ffb9188b3d
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

Commit-ID:  31d963389f67165402aa447a8e8ce5ffb9188b3d
Gitweb:     http://git.kernel.org/tip/31d963389f67165402aa447a8e8ce5ffb9188b3d
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 2 Sep 2014 19:57:20 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Sep 2014 14:51:15 -0700

x86, fpu: Change __thread_fpu_begin() to use use_eager_fpu()

__thread_fpu_begin() checks X86_FEATURE_EAGER_FPU by hand, we have
a helper for that.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175720.GA21656@redhat.com
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fpu-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 412ecec..e97622f 100644
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
