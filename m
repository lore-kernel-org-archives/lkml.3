Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaHRJjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:39:25 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:50396 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbaHRJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:39:23 -0400
MIME-Version: 1.0
Date: Mon, 18 Aug 2014 15:09:22 +0530
Message-ID: <CAFdej00nLYi__6STxb7wMGXR9iCSYF-VBFc9DjjYo3_rwYnm7Q@mail.gmail.com>
Subject: checkpatch.pl: Use of extern in function prototype
From: Arun Chandran <achandran@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Geoff Levand <geoff@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a piece of code as shown below.

#######################
diff --git a/arch/arm64/include/asm/proc-fns.h
b/arch/arm64/include/asm/proc-fns.h
index 9a8fd84..86be4f9 100644
--- a/arch/arm64/include/asm/proc-fns.h
+++ b/arch/arm64/include/asm/proc-fns.h
@@ -32,7 +32,7 @@ extern void cpu_cache_off(void);
 extern void cpu_do_idle(void);
 extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
 extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
+extern void cpu_soft_restart(phys_addr_t cpu_reset,
                unsigned long addr) __attribute__((noreturn));
 extern void cpu_do_suspend(struct cpu_suspend_ctx *ptr);
 extern u64 cpu_do_resume(phys_addr_t ptr, u64 idmap_ttbr);
########################

Other lines had an "extern" in them I also added it blindly.
when the above code is given checkpatch.pl did not throw any
error/warning,; but I got this reply

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/279691.html

[[As the functions have external linkage by default, the extern keyword is
irrelevant in this case.]]

Does checkpatch.pl misbehave in my case?

--Arun
