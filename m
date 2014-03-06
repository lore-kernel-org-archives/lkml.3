Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaCFRwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:52:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaCFRwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:52:49 -0500
Date: Thu, 6 Mar 2014 09:51:56 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-7ed5ee279499a02bf35c77f0a91d657c24f6474e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1393881143-3569-13-git-send-email-stefani@seibold.net>
References: <1393881143-3569-13-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso32: Disable stack protector,
  adjust optimizations
Git-Commit-ID: 7ed5ee279499a02bf35c77f0a91d657c24f6474e
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

Commit-ID:  7ed5ee279499a02bf35c77f0a91d657c24f6474e
Gitweb:     http://git.kernel.org/tip/7ed5ee279499a02bf35c77f0a91d657c24f6474e
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 6 Mar 2014 09:47:20 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 6 Mar 2014 09:47:20 -0800

x86, vdso32: Disable stack protector, adjust optimizations

For the 32-bit VDSO, match the 64-bit VDSO in:

1. Disable the stack protector.
2. Use -fno-omit-frame-pointer for user space debugging sanity.
3. Use -foptimize-sibling-calls like the 64-bit VDSO does.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/1393881143-3569-13-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 6cef7a1..55e76eb 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -151,6 +151,9 @@ KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
+KBUILD_CFLAGS_32 += $(call cc-option, -fno-stack-protector) 
+KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
+KBUILD_CFLAGS_32 += -fno-omit-frame-pointer
 $(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
