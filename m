Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab3GEOZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:25:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3GEOZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:25:18 -0400
Date: Fri, 5 Jul 2013 07:25:00 -0700
From: tip-bot for Wang YanQing <tipbot@zytor.com>
Message-ID: <tip-237d1548543312fcc8c99d302ab68fbf8ef6f97f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de,
        udknight@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, udknight@gmail.com, bp@suse.de,
        hpa@linux.intel.com
In-Reply-To: <20130628144516.GA2177@udknight>
References: <20130628144516.GA2177@udknight>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Fix override new_cpu_data.x86 with 486
Git-Commit-ID: 237d1548543312fcc8c99d302ab68fbf8ef6f97f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Jul 2013 07:25:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  237d1548543312fcc8c99d302ab68fbf8ef6f97f
Gitweb:     http://git.kernel.org/tip/237d1548543312fcc8c99d302ab68fbf8ef6f97f
Author:     Wang YanQing <udknight@gmail.com>
AuthorDate: Fri, 28 Jun 2013 22:45:16 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 28 Jun 2013 15:27:29 -0700

x86: Fix override new_cpu_data.x86 with 486

We should set X86 to 486 before use cpuid to detect the cpu type, if
we set X86 to 486 after cpuid, then we will get 486 until cpu_detect
runs.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Link: http://lkml.kernel.org/r/20130628144516.GA2177@udknight
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index e65ddc6..fe79573 100644
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
