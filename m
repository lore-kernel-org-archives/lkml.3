Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaADWmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 17:42:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47604 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbaADWmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 17:42:50 -0500
Date: Sat, 4 Jan 2014 14:42:39 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-twxm8igouzbmsklmf6lfyq0w@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, boot: Move intcall()
  to the .inittext section
Git-Commit-ID: 6f34152f54bcf63a49ea701643c81f5b2168fec8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 04 Jan 2014 14:42:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f34152f54bcf63a49ea701643c81f5b2168fec8
Gitweb:     http://git.kernel.org/tip/6f34152f54bcf63a49ea701643c81f5b2168fec8
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sat, 4 Jan 2014 14:29:08 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 4 Jan 2014 14:29:08 -0800

x86, boot: Move intcall() to the .inittext section

The .inittext section tries to aggregate all functions which are
needed to get a message out in the case of a load failure.  However,
putchar() uses intcall(), so intcall() should be in the .inittext
section.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-twxm8igouzbmsklmf6lfyq0w@git.kernel.org
---
 arch/x86/boot/bioscall.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
index 5077937..d401b4a 100644
--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -1,6 +1,6 @@
 /* -----------------------------------------------------------------------
  *
- *   Copyright 2009 Intel Corporation; author H. Peter Anvin
+ *   Copyright 2009-2014 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2 or (at your
@@ -14,7 +14,7 @@
  */
 
 	.code16
-	.text
+	.section ".inittext","ax"
 	.globl	intcall
 	.type	intcall, @function
 intcall:
