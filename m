Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055Ab3B0Ax2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:53:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab3BZX6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Edmund Grimley-Evans <Edmund.Grimley-Evans@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 107/150] arm64: compat: use compat_uptr_t type for compat_ucontext.uc_link
Date: Tue, 26 Feb 2013 15:56:04 -0800
Message-Id: <20130226235535.226634726@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit c0e01d5d8f15c085236df184e5bc3d79a8b700cd upstream.

struct compat_ucontext * is a 64-bit pointer, so we need to use a
compat_uptr_t instead to avoid declaring a structure incompatible with
what AArch32 userspace expects.

Reported-by: Edmund Grimley-Evans <Edmund.Grimley-Evans@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/signal32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -76,7 +76,7 @@ struct compat_sigcontext {
 
 struct compat_ucontext {
 	compat_ulong_t			uc_flags;
-	struct compat_ucontext		*uc_link;
+	compat_uptr_t			uc_link;
 	compat_stack_t			uc_stack;
 	struct compat_sigcontext	uc_mcontext;
 	compat_sigset_t			uc_sigmask;
@@ -703,7 +703,7 @@ int compat_setup_rt_frame(int usig, stru
 	err |= copy_siginfo_to_user32(&frame->info, info);
 
 	__put_user_error(0, &frame->sig.uc.uc_flags, err);
-	__put_user_error(NULL, &frame->sig.uc.uc_link, err);
+	__put_user_error(0, &frame->sig.uc.uc_link, err);
 
 	memset(&stack, 0, sizeof(stack));
 	stack.ss_sp = (compat_uptr_t)current->sas_ss_sp;


