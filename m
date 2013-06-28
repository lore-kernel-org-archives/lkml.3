Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3F1Opk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:45:40 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35556 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3F1Opj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:45:39 -0400
Date: Fri, 28 Jun 2013 22:45:16 +0800
From: Wang YanQing <udknight@gmail.com>
To: bp@alien8.de
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        bp@suse.de, fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2]x86: Fix override new_cpu_data.x86 with 486
Message-ID: <20130628144516.GA2177@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, bp@alien8.de,
	hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
	bp@suse.de, fenghua.yu@intel.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should set X86 to 486 before use cpuid
to detect the cpu type, if we set X86 to 486
after cpuid, then we will get 486 until
cpu_detect runs.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
ChangeLog
v1-v2:
1:Use more accurate and short commit log

 arch/x86/kernel/head_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 73afd11..24c6675 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -410,6 +410,7 @@ enable_paging:
 /*
  * Check if it is 486
  */
+	movb $4,X86			# at least 486
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
