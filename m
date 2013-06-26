Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3FZQ1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:27:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3FZQ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:26:59 -0400
Date: Thu, 27 Jun 2013 00:26:40 +0800
From: Wang YanQing <udknight@gmail.com>
To: hpa@zytor.com
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, bp@suse.de,
        fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix override new_cpu_data.x86 with 486
Message-ID: <20130626162640.GA19913@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, hpa@zytor.com,
	tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, bp@suse.de,
	fenghua.yu@intel.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should set X86 to 486 before use cpuid
to detect the cpu type, if we set X86 to 486
after cpuid, then we will get 486 for ever.

Yes, we will correct this in early_cpu_init,
but it is still a wrong behavior, right? So
just fix it.

I also find maybe we can delete the new_cpu_data,
because we will over write all the information
in early_cpu_init, and before early_cpu_init,
there is no user of new_cpu_data, but this is
another patch in the future.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/kernel/head_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 73afd11..733a8ef 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -410,6 +410,7 @@ enable_paging:
 /*
  * Check if it is 486
  */
+	movb $4,X86                     # at least 486
 	cmpl $-1,X86_CPUID
 	je is486
 
@@ -437,7 +438,6 @@ enable_paging:
 	movl %edx,X86_CAPABILITY
 
 is486:
-	movb $4,X86
 	movl $0x50022,%ecx	# set AM, WP, NE and MP
 	movl %cr0,%eax
 	andl $0x80000011,%eax	# Save PG,PE,ET
-- 
1.7.12.4.dirty
