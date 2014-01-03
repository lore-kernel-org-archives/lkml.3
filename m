Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaACWrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:47:12 -0500
Received: from [198.137.202.10] ([198.137.202.10]:33759 "EHLO
	terminus.zytor.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaACWrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:47:09 -0500
Date: Fri, 3 Jan 2014 14:46:09 -0800
From: tip-bot for David Woodhouse <tipbot@zytor.com>
Message-ID: <tip-c86cd70a46c97b001dd9d8b3e925d2a38b88d3ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
In-Reply-To: <1388788242.2391.75.camel@shinybook.infradead.org>
References: <1388788242.2391.75.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, boot: Use .code16 instead of .code16gcc
Git-Commit-ID: c86cd70a46c97b001dd9d8b3e925d2a38b88d3ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 03 Jan 2014 14:46:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c86cd70a46c97b001dd9d8b3e925d2a38b88d3ca
Gitweb:     http://git.kernel.org/tip/c86cd70a46c97b001dd9d8b3e925d2a38b88d3ca
Author:     David Woodhouse <dwmw2@infradead.org>
AuthorDate: Fri, 3 Jan 2014 22:30:42 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 3 Jan 2014 14:40:09 -0800

x86, boot: Use .code16 instead of .code16gcc

This reverts commit 28b48688 ("x86, boot: use .code16gcc instead
of .code16").

Versions of binutils older than 2.16 are already not working, so this
workaround is no longer necessary either.  At the same time, some of
the transformations that .code16gcc does can be *extremely*
counterintuitive to a human programmer.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1388788242.2391.75.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/bioscall.S | 2 +-
 arch/x86/boot/copy.S     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
index 1dfbf64..5077937 100644
--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -13,7 +13,7 @@
  * touching registers they shouldn't be.
  */
 
-	.code16gcc
+	.code16
 	.text
 	.globl	intcall
 	.type	intcall, @function
diff --git a/arch/x86/boot/copy.S b/arch/x86/boot/copy.S
index 11f272c..07a7a4a 100644
--- a/arch/x86/boot/copy.S
+++ b/arch/x86/boot/copy.S
@@ -14,7 +14,7 @@
  * Memory copy routines
  */
 
-	.code16gcc
+	.code16
 	.text
 
 GLOBAL(memcpy)
