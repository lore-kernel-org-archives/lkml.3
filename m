Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3CAFYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:24:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3CAFYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:24:54 -0500
Date: Thu, 28 Feb 2013 21:23:40 -0800
From: tip-bot for gmail <tipbot@zytor.com>
Message-ID: <tip-b317219b322e36e25150d7b64f4532401779959d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, lans.zhang2008@gmail.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, lans.zhang2008@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <51300267.6000008@gmail.com>
References: <51300267.6000008@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86_64:
  Use __BOOT_DS instead_of __KERNEL_DS for safety
Git-Commit-ID: b317219b322e36e25150d7b64f4532401779959d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 28 Feb 2013 21:23:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b317219b322e36e25150d7b64f4532401779959d
Gitweb:     http://git.kernel.org/tip/b317219b322e36e25150d7b64f4532401779959d
Author:     gmail <lans.zhang2008@gmail.com>
AuthorDate: Fri, 1 Mar 2013 09:20:39 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 28 Feb 2013 20:19:50 -0800

x86_64: Use __BOOT_DS instead_of __KERNEL_DS for safety

In startup_32, the running code still uses the initial GDT
located in setup. Thus, __BOOT_DS is preferred. Currently
__KERNEL_DS is lucky to equal to __BOOT_DS, but this is
not always a safe way.

Signed-off-by: Lans Zhang <lans.zhang2008@gmail.com>
Link: http://lkml.kernel.org/r/51300267.6000008@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/head_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c1d383d..16f24e6 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -52,7 +52,7 @@ ENTRY(startup_32)
 	jnz 1f
 
 	cli
-	movl	$(__KERNEL_DS), %eax
+	movl	$(__BOOT_DS), %eax
 	movl	%eax, %ds
 	movl	%eax, %es
 	movl	%eax, %ss
