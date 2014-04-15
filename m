Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaDOQTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:19:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60135 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDOQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:19:10 -0400
Date: Tue, 15 Apr 2014 09:18:46 -0700
From: tip-bot for Pranith Kumar <tipbot@zytor.com>
Message-ID: <tip-73679e50820123ebdedc67ebcda4562d1d6e4aba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bobby.prani@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bobby.prani@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <CAJhHMCAnYPy0+qD-1KBnJPLt3XgAjdR12j+ySSnPgmZcpbE7HQ@mail.gmail.com>
References: <CAJhHMCAnYPy0+qD-1KBnJPLt3XgAjdR12j+ySSnPgmZcpbE7HQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] compiler-intel.h: Remove duplicate definition
Git-Commit-ID: 73679e50820123ebdedc67ebcda4562d1d6e4aba
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

Commit-ID:  73679e50820123ebdedc67ebcda4562d1d6e4aba
Gitweb:     http://git.kernel.org/tip/73679e50820123ebdedc67ebcda4562d1d6e4aba
Author:     Pranith Kumar <bobby.prani@gmail.com>
AuthorDate: Tue, 15 Apr 2014 12:05:22 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 15 Apr 2014 09:15:39 -0700

compiler-intel.h: Remove duplicate definition

barrier is already defined as __memory_barrier in compiler.h
Remove this unnecessary redefinition.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Link: http://lkml.kernel.org/r/CAJhHMCAnYPy0%2BqD-1KBnJPLt3XgAjdR12j%2BySSnPgmZcpbE7HQ@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/compiler-intel.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index 5529c52..ba147a1 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -13,12 +13,9 @@
 /* Intel ECC compiler doesn't support gcc specific asm stmts.
  * It uses intrinsics to do the equivalent things.
  */
-#undef barrier
 #undef RELOC_HIDE
 #undef OPTIMIZER_HIDE_VAR
 
-#define barrier() __memory_barrier()
-
 #define RELOC_HIDE(ptr, off)					\
   ({ unsigned long __ptr;					\
      __ptr = (unsigned long) (ptr);				\
