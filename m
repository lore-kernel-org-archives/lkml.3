Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbaCRVad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:30:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54534 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbaCRVa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:30:29 -0400
Date: Tue, 18 Mar 2014 14:29:57 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-008cc907de327d83a0be609cd495fccb0e5dfa4c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1395094933-14252-13-git-send-email-stefani@seibold.net>
References: <1395094933-14252-13-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso32: Disable stack protector,
  adjust optimizations
Git-Commit-ID: 008cc907de327d83a0be609cd495fccb0e5dfa4c
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

Commit-ID:  008cc907de327d83a0be609cd495fccb0e5dfa4c
Gitweb:     http://git.kernel.org/tip/008cc907de327d83a0be609cd495fccb0e5dfa4c
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 17 Mar 2014 23:22:12 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Mar 2014 12:52:48 -0700

x86, vdso32: Disable stack protector, adjust optimizations

For the 32-bit VDSO, match the 64-bit VDSO in:

1. Disable the stack protector.
2. Use -fno-omit-frame-pointer for user space debugging sanity.
3. Use -foptimize-sibling-calls like the 64-bit VDSO does.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1395094933-14252-13-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 6cef7a1..a2de5fc 100644
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
